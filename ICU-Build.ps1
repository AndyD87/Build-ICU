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
    [string]$AdditionalConfig = ""
)


Function PathToCygwinPath ([string] $Path)
{
    return ("/cygdrive/" + $Path.Replace(":", "").Replace("\", "/"))
}


$CurrentDir          = ((Get-Item -Path ".\" -Verbose).FullName)

& "$PSScriptRoot\Common\Cygwin-GetEnv.ps1"
$OutputTargetCygwin  = PathToCygwinPath $OutputTarget
$IcuDir             += "\source"

$env:PATH=$env:PATH+";$CygwinDir"
cd $IcuDir

if((& "$PSScriptRoot\Common\Process-StartInline.ps1" "dos2unix" "*") -ne 0)
{
    throw "Failed: dos2unixasdf *"
}

if((& "$PSScriptRoot\Common\Process-StartInline.ps1" "dos2unix" "-f configure") -ne 0)
{
    throw "Failed: dos2unixasdf *"
}

$Cmd = "runConfigureICU Cygwin/MSVC -prefix=`"$OutputTargetCygwin`" "
if($Static)
{
    $Cmd += "-enable-static -disable-shared "
}
if($DebugBuild)
{
    $Cmd += "--enable-debug --disable-release "
}
if(-not [string]::IsNullOrEmpty($AdditionalConfig))
{
    $Cmd += $AdditionalConfig
}

if((& "$PSScriptRoot\Common\Process-StartInline.ps1" "bash" $cmd) -ne 0)
{
    Write-Output $IcuDir
    throw "Configure icu failed: $Cmd"
}

if((& "$PSScriptRoot\Common\Process-StartInline.ps1" "make") -ne 0)
{
    throw "Failed: make"
}

if((& "$PSScriptRoot\Common\Process-StartInline.ps1" "make" "install") -ne 0)
{
    throw "Failed: make install"
}

cd $CurrentDir