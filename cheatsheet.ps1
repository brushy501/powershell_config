#=====================================================
#Author: brushy501
#Description: A script to take a cheatsheet text to
#find and pass the command to the terminal. Inspired
#by tldr (https://github.com/tldr-pages/tldr) and navi
#(https://github.com/denisidoro/navi).
#Requirements: fzf
#=====================================================

#The directory where cheats documents are stored as .txt files.
$cheatDir ="C:\Users\User\Documents\Cheatsheets"

# Main function
function tlder
{

    #check the the directory exists
    if ( -not(Test-Path $noteDir))
    {
        Write-Host "Path does not exist"
        return
    }

    #Checks if fzf is installed and available
    if (-not(Test-Path (Get-Command fzf | Select-Object -ExpandProperty Definition -ErrorAction SilentlyContinue)))
    {
        Write-Host "Error: fzf is not installed. Please install fzf and try again." -ForegroundColor black -BackgroundColor red
        return
    }

    search-and-execute $cheatDir
}

function get-file-details([string] $filePath)
{
    #get the all the cheat txt files in the directory
    $fileContent = Get-Content $filePath
    #get the filenames of the files.
    $fileName = (Get-ChildItem $filePath).Name

    #create an empty array to hold the details needed.
    $details = @()
    #loop through all the files and get the comments and commands in the files.
    for($i = 0; $i -lt $fileContent.Length; $i++)
    {
        #get the current line contents
        $line = $fileContent[$i]
        #if the line is a comment starting with '#' then save it to another array and the rest to other arrays.
        if($line -match '^#')
        {
            #if the line matches the regex above its a comment
            $comment = $line
            
            #initiate a new variable with an empty string for the command
            $command = ""

            #move to the next index in the array above.
            $j = $i + 1

            #check the length of the array index value and it is not a comment
            while($j -lt $fileContent.Length -and $fileContent[$j] -notmatch '^#')
            {
                #add the contents of the array to the command variable
                $command += $fileContent[$j] + " "
                $j++
            }
           
            #create a custom object to store the filename, comment and code.
            $details += [PSCustomObject]@{
                Filename = $fileName
                Comment = $comment
                Command = $command.Trim()
            }
            #decrement the $i variable.
            $i = $j -1
        }
        
    }

    return $details
}

#search and find cheat commands in the files.
function search-and-execute()
{
    #get all the files in the specified directory
    $files = Get-ChildItem -Path $cheatDir -File

    #create a table of comments and its associated commands from all files
    $fzfInput = @()

    foreach($file in $files)
    {
        # get the details from the get-file-details funtion above
        $details = get-file-details -FilePath $file.FullName
        
        #loop throught the details object to get individual detail information
        foreach($detail in $details)
        {
            $fzfInput += "$($detail.FileName) | $($detail.Comment) | $($detail.Command)"
        }
    }

    #pipe the input to fzf to select based on the search parameter entered.
    $selected = $fzfInput| fzf

    if($selected)
    {
        #Get the details from the selection and seperate using the | operator
        $selectedDetails = $selected -split '\|'
        #Get the filename from the first index
        $selectedFileName = $selectedDetails[0].Trim()
        #Get the selected command from the third index
        $selectedCommand = $selectedDetails[2].Trim()

        # Execute the selected command
        Invoke-Expression $selectedCommand
    }
}
