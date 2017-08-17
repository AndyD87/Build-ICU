PARAM(
    [switch]$Mandatory
)

if((Test-Path "C:\Tools\Perl"))
{
    $env:PATH += ";C:\Tools\Perl\bin"
    Write-Output "Perl found at C:\Tools\Perl\bin"
}
elseif($Mandatory)
{
    throw( "No Perl found" )
}
else
{
    Write-Output "No Perl found";
}