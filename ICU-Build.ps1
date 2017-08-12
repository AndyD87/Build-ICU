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

[string]$CygwinDir  = "C:\Tools\cygwin64\bin"
$CurrentDir          = ((Get-Item -Path ".\" -Verbose).FullName)
$OutputTargetCygwin  = PathToCygwinPath $OutputTarget
$IcuDir             += "\source"

$env:PATH=$env:PATH+";$CygwinDir"
cd $IcuDir

dos2unix *
if($LASTEXITCODE -ne 0)
{
    throw "Failed: dos2unix *"
}

dos2unix -f configure
if($LASTEXITCODE -ne 0)
{
    throw "Failed: dos2unix -f configure"
}

$Cmd = "bash runConfigureICU Cygwin/MSVC -prefix=`"$OutputTargetCygwin`" "
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

cmd.exe /C $Cmd

if($LASTEXITCODE -ne 0)
{
    throw "Failed: $Cmd"
}

make
if($LASTEXITCODE -ne 0)
{
    throw "Failed: make"
}
make install
if($LASTEXITCODE -ne 0)
{
    throw "Failed: make install"
}

cd $CurrentDir