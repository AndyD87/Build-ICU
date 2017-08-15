PARAM(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$OutputFile,
    [Parameter(Mandatory=$False, Position=2)]
    [string]$Single = "",
    [Parameter(Mandatory=$False)]
    [string[]]$Array = $null
)

# Create CMD
$cmd = "cmake -E tar "

if(-not [string]::IsNullOrEmpty($Single))
{
    $oFile = Get-Item $Single
    if($oFile.PSIsContainer)
    {
        $cmd += "cf `"$OutputFile`" --format=zip "
        $oFileList = Get-ChildItem $Single
        foreach($oFile in $oFileList)
        {
            $cmd += " `"$Single\"
            $cmd += $oFile.Name
            $cmd += "`""
        }
    }
    else
    {
        $cmd += "cf `"$OutputFile`" --format=zip "
        $cmd += "`"$Single`" "
    }
}
elseif ($Array -ne $null -and $Array.Count -gt 0)
{
    $cmd += "cf `"$OutputFile`" --format=zip "
    foreach($Folder in $Array)
    {
        $cmd += "`"$Folder`" "
    }
}
else
{
    throw "No Input given"
}

$cmd
cmd /C $cmd
if($LASTEXITCODE -ne 0)
{
    throw "Fail on creating zip: $cmd"
}
