##
# Kill pending Visual Studio tasks after build
##

& "$PSScriptRoot\Process-StopIfExists.ps1" "vctip"
& "$PSScriptRoot\Process-StopIfExists.ps1" "mspdbsrv"
