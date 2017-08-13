PARAM(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$Target
)

$CurrentDir = ((Get-Item -Path ".\" -Verbose).FullName)

$temp = .\Common\Process-StartAndGetOutput.ps1 "svn" "status --no-ignore" $Target
[string[]]$FilesToDelete = $temp.Split([Environment]::NewLine)

cd $Target
foreach($File in $FilesToDelete)
{
    if($File.Length -gt 0 -and ($File[0] -eq '?' -or $File[0] -eq 'I'))
    {
        Remove-Item $File.Substring(1).Trim() -Recurse -Force
    }
}
svn cleanup
if($LASTEXITCODE -ne 0)
{
    throw "Failed svn cleanup:"
}

cd $CurrentDir