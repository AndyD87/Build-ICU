PARAM(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$Target,
    [Parameter(Mandatory=$true, Position=2)]
    [string]$Version = ""

)

$CurrentDir = ((Get-Item -Path ".\" -Verbose).FullName)

$Version = $Version.Replace(".", "-");

if($Version -eq "latest")
{
    $cmd = "svn checkout --quiet http://source.icu-project.org/repos/icu/tags/$Version/icu4c `"$Target`""
}
else
{
    $cmd = "svn checkout --quiet http://source.icu-project.org/repos/icu/tags/release-$Version/icu4c `"$Target`""
}
Write-Output "Checkout svn quietly"
cmd /C $cmd
if($LASTEXITCODE -ne 0)
{
    throw "Failed to get svn repository"
}

cd $CurrentDir