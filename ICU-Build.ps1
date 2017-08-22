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
    [string]$IcuDir,
    [Parameter(Mandatory=$true, Position=2)]
    [string]$OutputTarget,
    [Parameter(Mandatory=$false, Position=3)]
    [bool]$Static = $false,
    [Parameter(Mandatory=$false, Position=4)]
    [bool]$DebugBuild = $false,
    [Parameter(Mandatory=$false, Position=5)]
    [bool]$StaticRuntime = $false,
    [Parameter(Mandatory=$false, Position=6)]
    [string]$AdditionalConfig = ""
)
Import-Module "$PSScriptRoot\Common\All.ps1" -Force

Function PathToCygwinPath ([string] $Path)
{
    return ("/cygdrive/" + $Path.Replace(":", "").Replace("\", "/"))
}


$CurrentDir          = ((Get-Item -Path ".\" -Verbose).FullName)

Cygwin-GetEnv -Mandatory

$OutputTargetCygwin  = PathToCygwinPath $OutputTarget
$IcuDir             += "\source"

cd $IcuDir

$Cmd = "runConfigureICU Cygwin/MSVC -prefix=`"$OutputTargetCygwin`" "
if($Static)
{
    $Cmd += "-enable-static -disable-shared "
}
if($StaticRuntime)
{
    (Get-Content runConfigureICU) |  Foreach-Object {$_ -Replace '/MD','/MT'}  | Out-File runConfigureICU
}
if($DebugBuild)
{
    $Cmd += "--enable-debug --disable-release "
}
if(-not [string]::IsNullOrEmpty($AdditionalConfig))
{
    $Cmd += $AdditionalConfig
}


Write-Output "******************************"
Write-Output "* Start Configuration"
Write-Output "******************************"
Process-StartInlineAndThrow "dos2unix" "*"
Process-StartInlineAndThrow "dos2unix" "-f configure"
Process-StartInlineAndThrow "bash" $cmd

Write-Output "******************************"
Write-Output "* Start Build"
Write-Output "******************************"
Process-StartInlineAndThrow "make"

Write-Output "******************************"
Write-Output "* Start Install"
Write-Output "******************************"
Process-StartInlineAndThrow "make" "install"

cd $CurrentDir