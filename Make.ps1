PARAM(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$VisualStudio,
    [Parameter(Mandatory=$true, Position=2)]
    [string]$Architecture,
    [Parameter(Mandatory=$true, Position=3)]
    [string]$Version,
    [Parameter(Mandatory=$false, Position=4)]
    [bool]$Static = $false,
    [Parameter(Mandatory=$false, Position=5)]
    [bool]$DebugBuild = $false,
    [Parameter(Mandatory=$false, Position=6)]
    [string]$AdditionalConfig = ""
)

$CurrentDir     = (Get-Item -Path ".\" -Verbose).FullName
$OutputName     = "icu4c-$Version-${VisualStudio}-${Architecture}"
$Output         = "$CurrentDir\$OutputName"
$IcuDir         = "$PSScriptRoot\$Version"

cd $PSScriptRoot

if($Static)
{
    $Output += "_static"
    $OutputName += "_static"
}

if($DebugBuild)
{
    $Output += "_debug"
    $OutputName += "_debug"
}

try
{
    if(-not (Test-Path $IcuDir))
    {
        .\ICU-Get.ps1 -Version $Version -Target $IcuDir
    }
    else
    {
        .\ICU-Clean.ps1 $IcuDir
    }
    .\Common\VisualStudio-GetEnv.ps1 $VisualStudio $Architecture
    .\Icu-Build.ps1 $IcuDir $Output $Static $DebugBuild $AdditionalConfig
    .\Common\Zip.ps1 -OutputFile "$CurrentDir\$OutputName.zip" -Single $Output
    .\Common\VisualStudio-PostBuild.ps1
    Add-Content "$CurrentDir\Build.log" "Success: $OutputName"
}
catch
{
    Add-Content "$CurrentDir\Build.log" "Failed: $OutputName"
}