PARAM(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$Target,
    [Parameter(Mandatory=$true, Position=2)]
    [string]$Version = ""

)
Import-Module "$PSScriptRoot\Common\Svn.ps1" -Force
Import-Module "$PSScriptRoot\Common\Process.ps1" -Force

Svn-GetEnv -Mandatory

$CurrentDir = ((Get-Item -Path ".\" -Verbose).FullName)

$Version = $Version.Replace(".", "-");

if($Version -eq "latest")
{
    $cmd = "checkout --quiet http://source.icu-project.org/repos/icu/tags/$Version/icu4c `"$Target`""
}
else
{
    $cmd = "checkout --quiet http://source.icu-project.org/repos/icu/tags/release-$Version/icu4c `"$Target`""
}

Write-Output "Checkout svn quietly"
Process-StartInlineAndThrow "svn" "$cmd"

cd $CurrentDir