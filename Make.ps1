##
# This file is part of Powershell-Common, a collection of powershell-scrips
# 
# Copyright (c) 2017 Andreas Dirmeier
# License   MIT
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##
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
    [bool]$StaticRuntime = $false,
    [Parameter(Mandatory=$false, Position=7)]
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
$OutputName     = "icu-$Version-${VisualStudio}-${Architecture}"
$IcuDir         = "$PSScriptRoot\icu-$Version"
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

    if($StaticRuntime)
    {
        $Output += "_MT"
        $OutputName += "_MT"
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
        Write-Output "******************************"
        .\ICU-Get.ps1 -Version $Version -Target $IcuDir
    }
    elseif(-not $NoClean)
    {
        Write-Output "* Cleanup ICU"
        Write-Output "******************************"
        .\ICU-Clean.ps1 $IcuDir
    }
    else
    {
        Write-Output "* NoClean"
        Write-Output "******************************"
    }

    VisualStudio-GetEnv $VisualStudio $Architecture
    .\Icu-Build.ps1 $IcuDir $Output $Static $DebugBuild -StaticRuntime $StaticRuntime -AdditionalConfig $AdditionalConfig
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
