##
# Kill pending Visual Studio tasks after build
##

& "$PSScriptRoot\StopProcessIfExists.ps1" "vctip"
& "$PSScriptRoot\StopProcessIfExists.ps1" "mspdbsrv"
