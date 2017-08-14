PARAM(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$Name
)

$Processes = Get-Process $Name -ErrorAction SilentlyContinue

foreach ($Process in $Processes)
{
    Stop-Process $Process -Force
}
