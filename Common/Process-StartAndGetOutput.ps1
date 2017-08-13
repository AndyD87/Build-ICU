PARAM(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$Executable,
    [Parameter(Mandatory=$false, Position=2)]
    [string]$Arguments = "",
    [Parameter(Mandatory=$false, Position=3)]
    [string]$WorkingDir = ""
)
	
$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = $Executable
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.Arguments = $Arguments
$pinfo.WindowStyle =  [System.Diagnostics.ProcessWindowStyle]::Hidden
$pinfo.CreateNoWindow = $true
$pinfo.WorkingDirectory = $WorkingDir
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$trash = $p.Start()
$string=""
while($p.HasExited -eq $false)
{
	$string += $p.StandardOutput.ReadLine();
    $string += [Environment]::NewLine
}
while($p.StandardOutput.EndOfStream -eq $false)
{
	$string += $p.StandardOutput.ReadLine();
    $string += [Environment]::NewLine
}

return $string