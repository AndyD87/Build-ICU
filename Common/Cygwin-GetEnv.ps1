PARAM(
    [switch]$Mandatory
)

if((Test-Path "C:\Tools\cygwin64\bin"))
{
    $env:PATH += ";C:\Tools\cygwin64\bin"
    Write-Output "Cygwin found at C:\Tools\cygwin64\bin"
}
elseif($Mandatory)
{
    throw( "No Cygwin found" )
}
else
{
    Write-Output "No Cygwin found"
}