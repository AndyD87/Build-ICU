PARAM(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$Target
)

.\Common\Svn-Clean.ps1 $Target