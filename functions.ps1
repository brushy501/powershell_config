#Reload the powershell profile
function reload-profile{
    & $profile
}

#function to call the wttr.in weatherapi and refresh every 15mins.
function WeatherAPI()
{
    
    while($true)
    {
        Invoke-RestMethod https://wttr.in/Accra?format=3

        Start-Sleep -Seconds (30*60)
    }
    
}

#access the cheat sheet api for the following languages specified
function learn()
{
    $languages = "php","dart","flutter","html","css","javascript","vue"
    $config = $languages | fzf --prompt="CheatSheet >> " --height=~50% --layout=reverse --border --exit-0
    Write-Host "Enter query" -ForegroundColor green
    $query = Read-Host 
		
    if([string]::IsNullOrEmpty($config))
    {
        Write-Output "Nothing Selected"
        break
    }
	
    cht -Q /$config/$query
}

#function to convert hex color codes to the flutter equivalent
function Convert-HexColorToFlutter
{
    param (
        [string]$hexColor
    )

    # Remove any leading '#' characters from the input
    $hexColor = $hexColor -replace '^#'

    # Convert the hexadecimal color code to RGB components
    $red = [Convert]::ToInt32($hexColor.Substring(0,2), 16)
    $green = [Convert]::ToInt32($hexColor.Substring(2,2), 16)
    $blue = [Convert]::ToInt32($hexColor.Substring(4,2), 16)

    # Format the RGB components as a Flutter-compatible color code
    $flutterColor = "0xFF{0:X2}{1:X2}{2:X2}" -f $red, $green, $blue

    return $flutterColor
}
Set-Alias hex -Value "Convert-HexColorToFlutter"

#Edit the powershell profile
function Edit-Profile{
    nvim $PROFILE.CurrentUserAllHosts
}

# Powershell implementation of the touch cli command from linux
function touch($file){
    "" | Out-File $file -Encoding utf8
}

# function to determine the system uptime since the machine was put on.
function uptime{
  
    net statistics workstation | Select-String "since" | ForEach-Object{$_.ToString().Replace('Statistics since','') }
}

# Powershell implementation of the sed linux command
function sed($file, $find, $replace){
    (Get-Content $file).Replace("$find",$replace) | Set-Content $file
}

#Powershell implementationnof the which command
function which($name){
    Get-Command $name | Select-Object -ExpandProperty Definition
}

