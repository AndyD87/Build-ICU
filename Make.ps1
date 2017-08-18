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
    
    [bool]$DoPackage,
    [bool]$NoClean,
    [string]$OverrideOutput
)
# Include Common Powershell modules
Import-Module "$PSScriptRoot\Common\All.ps1" -Force

Write-Output "******************************"
Write-Output "* Start ICU Build"
Write-Output "******************************"

$ExitCode       = 0
$CurrentDir     = (Get-Item -Path ".\" -Verbose).FullName
$OutputName     = "icu4c-$Version-${VisualStudio}-${Architecture}"
$IcuDir         = "$PSScriptRoot\icu4c-$Version"
if([string]::IsNullOrEmpty($OverrideOutput))
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
    Write-Output "******************************"
    if(-not (Test-Path $IcuDir))
    {
        Write-Output "* Download ICU $Version"
        .\ICU-Get.ps1 -Version $Version -Target $IcuDir
    }
    elseif(-not $NoClean)
    {
        Write-Output "* Cleanup ICU"
        .\ICU-Clean.ps1 $IcuDir
    }
    else
    {
        Write-Output "* NoClean"
    }
    Write-Output "******************************"
    VisualStudio-GetEnv $VisualStudio $Architecture
    .\Icu-Build.ps1 $IcuDir $Output $Static $DebugBuild $AdditionalConfig
    if($DoPackage)
    {
        Compress-Zip -OutputFile "$CurrentDir\$OutputName.zip" -Single $Output
    }
    Add-Content "$CurrentDir\Build.log" "Success: $OutputName"
}
Catch
{
    $ExitCode       = 1
    Write-Output $_.Exception.Message
    Add-Content "$CurrentDir\Build.log" "Failed: $OutputName"
}
Finally
{
    cd $PSScriptRoot
    # Always Endup visual studio
    VisualStudio-PostBuild
}

exit $ExitCode
