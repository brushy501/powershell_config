#===============================================================
#Author: brushy501
#Description: A script to create and display markdown notes in 
#terminal in one window but seperate panes. It uses fzf for fuzzy
#searching and glow to render the markdown in the terminal
#===============================================================

#Specify the full path to the directory where your markdown notes are stored
$noteDir = "C:/Users/User/Documents"

function noted {
  #check the the directory exists
  if ( -not(Test-Path $noteDir)) {
    Write-Host "Path does not exist"
    return
  }

  #Checks if fzf is installed and available
  if (-not(Test-Path (Get-Command fzf | Select-Object -ExpandProperty Definition -ErrorAction SilentlyContinue))) {
    Write-Host "Error: fzf is not installed. Please install fzf and try again." -ForegroundColor black -BackgroundColor red
    return
  }

  # Checks if glow is installed and availble
  if ( -not(Test-Path (Get-Command glow | Select-Object -ExpandProperty Definition -ErrorAction SilentlyContinue))) {
    Write-Host "Error: glow is not installed. Please install glow and try again" -ForegroundColor black -BackgroundColor red
    return
  }

  #call the function to search for notes
  search_note
}

#function to search and select a markdown file for editing if available.If not it will be created.
function search_note {
  #Prompt the user for a filename to find using fzf.
  $selectedFile = (&fzf)

  if ([string]::IsNullOrEmpty($selectedFile)) {
    #If no search term is provided, create a new markdown file
    Write-Host "To create a new file press escape to leave fzf"
    $newFilename = Read-Host "Enter a name for the new Markdown file(without extension)"
    # create a path to the new file by joining the filename to the path
    $newFile = Join-Path -Path $noteDir -ChildPath "$newFilename.md"
    if ( -not(Test-Path $newFile)) {
      #create a new markdown file if it doesn't exist using the path created above
      New-Item -Itemtype File -Path $newFile | Out-Null
    }
  }

  #open the selected file in a split pane using nvim, it can be changed to use whatever terminal editor you want
  wt -w 0 split-pane nvim $selectedFile

  #render the markdown file in the current pane using glow
  render_markdown $selectedFile
}

#Use the glow cli to render the markdown file in the terminal and autorefresh when file changes
function render_markdown([string] $markdownfile) {
  #Get the full path of the markdown file
  $filePath = (Resolve-Path  $markdownfile).Path

  #Render markdown initially
  glow_render $markdownfile

  #watch the markdown file for changes
  watch_glow_file $filePath

}

#function to render markdown using glow
function glow_render([string] $file) {
  #clear the screen
  Clear-Host

  #Start a process to launch glow
  Start-Process -FilePath "glow" -ArgumentList $file -NoNewWindow -Wait
}

#watch for changes in the file rendered using glow
function watch_glow_file([string] $watchfile) {
  while ($true) {
    $file = Get-Item $watchfile

    #find the last write time.
    $lastWriteTime = $file.LastWriteTime

    #wait for the file to be modified
    while ($file.LastWriteTime -eq $lastWriteTime) {
      Start-Sleep -Milliseconds 500
      $file = Get-Item $watchfile
    } 
    glow_render $watchfile
  }
}
