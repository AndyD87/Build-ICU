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
    [string]$AdditionalConfig = "",
    
    [switch]$DoPackage,
    [switch]$NoClean,
    [string]$OverrideOutput
)

$CurrentDir     = (Get-Item -Path ".\" -Verbose).FullName
$OutputName     = "icu4c-$Version-${VisualStudio}-${Architecture}"
$IcuDir         = "icu4c-$PSScriptRoot\$Version"
if([string]::IsNullOrEmpty($OutputOverride))
{
    $Output         = "$CurrentDir\$OutputName"
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
}
else
{
    $Output     = $OverrideOutput
}

cd $PSScriptRoot

Try
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
    if($DoPackage)
    {
        .\Common\Zip.ps1 -OutputFile "$CurrentDir\$OutputName.zip" -Single $Output
    }
    Add-Content "$CurrentDir\Build.log" "Success: $OutputName"
}
Catch
{
    Add-Content "$CurrentDir\Build.log" "Failed: $OutputName"
}
Finally
{
    cd $PSScriptRoot
    # Always Endup visual studio
    .\Common\VisualStudio-PostBuild.ps1
}
