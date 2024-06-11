![powershell_config](https://socialify.git.ci/brushy501/powershell_config/image?description=1&descriptionEditable=My%20powershell%20scripts%20to%20power%20my%20productivity.&language=1&name=1&owner=1&stargazers=1&theme=Light)

My powershell profile scripts that i use in my coding environment to up my productivity.
Check, edit and customize what you want to the way you like it. The main cli utilities
used are [zoxide](https://github.com/ajeetdsouza/zoxide), [glow](https://github.com/charmbracelet/glow),
[fzf](https://github.com/junegunn/fzf), [nvim](https://github.com/neovim/neovim) and the windows terminal application.

## 1. notty.ps1
![notty](https://github.com/brushy501/powershell_config/assets/48830968/8c6e490e-b4ce-4ddd-bab7-3cab46217c99)

This script is allow the editing and previewing of a markdown document using glow from [charmbracelet](https://github.com/charmbracelet/glow).
It uses fzf to fuzzy search and find the file.The markdown file can be edited using any editor of your choice, but as i am using the terminal
i use nvim, change it to suit your terminal editor of choice.An image of it being used it below.

![notty_script_usage](https://github.com/brushy501/powershell_config/assets/48830968/20590af9-e863-486f-bce3-77623c67d202)



## 2. cheatsheet.ps1

A script to emulate the functionality of navi or tldr using the powershell scripting language and fzf. The selected cheat command is executed
when selected. I use this for git commands that i do not remember but need to execute. You can add to the functionality. The cheat files are
saved with the comment starting with a "#", example: "# Check the status of git files". The command is directly below it in a new line.

