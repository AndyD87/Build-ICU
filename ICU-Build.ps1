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