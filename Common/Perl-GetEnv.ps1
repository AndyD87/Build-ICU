PARAM(
    [switch]$Mandatory
)

if((Test-Path "C:\Tools\Perl"))
{
    $env:PATH += ";C:\Tools\Perl\bin"
    Write-Host "Perl found at C:\Tools\Perl\bin"
}
elseif($Mandatory)
{
    throw( "No Perl found" )
}
else
{
    Write-Host "No Perl found";
}