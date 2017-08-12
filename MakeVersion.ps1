PARAM(
    [Parameter(Mandatory=$false, Position=1)]
    [string]$Version = "latest"
)

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
    $sStatic = "`$false"
    if($Static)
    {
        $sStatic = "`$true";
    }
    $Cmd = "-command .\Make.ps1 -Version `"$Version`" -VisualStudio `"$VisualStudio`" -Architecture `"$Architecture`" -Static $sStatic"
    $Cmd
    Start-Process powershell.exe -ArgumentList $Cmd -Wait -PassThru
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