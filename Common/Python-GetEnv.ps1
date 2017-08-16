PARAM(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$Version,
    
    [switch]$Mandatory
)

$VTarget = New-Object System.Version($Version)
if($VTarget.Major -eq 2)
{
    if((Test-Path "C:\Tools\Python27"))
    {
        $env:PATH += ";C:\Tools\Python27"
        Write-Host "Ninja found at C:\Tools\Python27"
    }
    elseif((Test-Path "C:\Python27"))
    {
        $env:PATH += ";C:\Python27"
        Write-Host "Ninja found at C:\Python27"
    }
    elseif($Mandatory)
    {
        throw( "No Python found" )
    }
    else
    {
        Write-Host "No Python found"
    }
}

if($VTarget.Major -eq 3)
{
    if((Test-Path "C:\Tools\Python36"))
    {
        $env:PATH += ";C:\Tools\Python36"
        Write-Host "Ninja found at C:\Tools\Python36"
    }
    elseif($Mandatory)
    {
        throw( "No Python found" )
    }
    else
    {
        Write-Host "No Python found"
    }
}