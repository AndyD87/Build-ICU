PARAM(
    [switch]$Mandatory
)

if((Test-Path "C:\Tools\ninja-win-1.7.2"))
{
    $env:PATH += ";C:\Tools\ninja-win-1.7.2"
    Write-Host "Ninja found at C:\Tools\ninja-win-1.7.2"
}
elseif($Mandatory)
{
    throw( "No Ninja found" )
}
else
{
    Write-Host "No Ninja found"
}