Import-Module "$PSScriptRoot\Git.ps1"

# Download new sources
Git-Clone -Source "https://github.com/AndyD87/Powershell-Common.git" -Target "Powershell-Common"

# Copy downloaded sources
Move-Item "$PSScriptRoot\Powershell-Common\*" ".\" -Force -Exclude "UpdateCommon.ps1"

# Remove Folder with new sources
Remove-Item "$PSScriptRoot\Powershell-Common" -Recurse -Force