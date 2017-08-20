PARAM(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$Target
)
Import-Module "$PSScriptRoot\Common\Svn.ps1" -Force

Svn-GetEnv -Mandatory

Svn-Clean $Target