PARAM(
    [Parameter(Mandatory=$false, Position=1)]
    [string]$Version = "latest"
)
Import-Module "$PSScriptRoot\Common\All.ps1" -Force

Function CreateMakeSession
{
    PARAM(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$VisualStudio,
        [Parameter(Mandatory=$true, Position=2)]
        [string]$Architecture,
        [Parameter(Mandatory=$true, Position=3)]
        [string]$Version,
        [Parameter(Mandatory=$false, Position=4)]
        [bool]$Static = $false
    )
    $sStatic = "0"
    if($Static)
    {
        $sStatic = "1";
    }
    $CurrentDir = ((Get-Item -Path ".\" -Verbose).FullName)
    $Cmd = "-command .\Make.ps1 -Version `"$Version`" -VisualStudio `"$VisualStudio`" -Architecture `"$Architecture`" -Static $sStatic"
    $Exitcode  = Process-StartInline "powershell.exe" $Cmd $CurrentDir
    if($ExitCode -ne 0)
    {
        throw "Make command failed"
    }
}
  
CreateMakeSession -Version $Version -VisualStudio "2017" -Architecture "x64" -Static $true
CreateMakeSession -Version $Version -VisualStudio "2017" -Architecture "x64" -Static $false
CreateMakeSession -Version $Version -VisualStudio "2017" -Architecture "x86" -Static $true
CreateMakeSession -Version $Version -VisualStudio "2017" -Architecture "x86" -Static $false
                                                                        
CreateMakeSession -Version $Version -VisualStudio "2015" -Architecture "x64" -Static $true
CreateMakeSession -Version $Version -VisualStudio "2015" -Architecture "x64" -Static $false
CreateMakeSession -Version $Version -VisualStudio "2015" -Architecture "x86" -Static $true
CreateMakeSession -Version $Version -VisualStudio "2015" -Architecture "x86" -Static $false
                     
CreateMakeSession -Version $Version -VisualStudio "2013" -Architecture "x64" -Static $true
CreateMakeSession -Version $Version -VisualStudio "2013" -Architecture "x64" -Static $false
CreateMakeSession -Version $Version -VisualStudio "2013" -Architecture "x86" -Static $true
CreateMakeSession -Version $Version -VisualStudio "2013" -Architecture "x86" -Static $false

CreateMakeSession -Version $Version -VisualStudio "2012" -Architecture "x64" -Static $true
CreateMakeSession -Version $Version -VisualStudio "2012" -Architecture "x64" -Static $false
CreateMakeSession -Version $Version -VisualStudio "2012" -Architecture "x86" -Static $true
CreateMakeSession -Version $Version -VisualStudio "2012" -Architecture "x86" -Static $false