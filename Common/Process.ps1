##
# This file is part of Powershell-Common, a collection of powershell-scrips
# 
# Copyright (c) 2017 Andreas Dirmeier
# License   MIT
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##
Function Process-RunInIse 
{
    try {    
        return $psISE -ne $null;
    }
    catch {
        return $false;
    }
}

Function Process-StartAndGetOutput
{
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
}

Function Process-StartInline
{
    PARAM(
        [Parameter(Mandatory=$True, Position=1)]
        [string]$Executable,
        [Parameter(Mandatory=$false, Position=2)]
        [string]$Arguments = "",
        [Parameter(Mandatory=$false, Position=3)]
        [string]$WorkingDir = ""
    )
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    if([string]::IsNullOrEmpty($WorkingDir))
    {
        $WorkingDir = ((Get-Item -Path ".\" -Verbose).FullName)
    }
    $pinfo.FileName = $Executable
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $Arguments
    $pinfo.WorkingDirectory = $WorkingDir
    $p = New-Object System.Diagnostics.Process
    if(Process-RunInIse)
    {
        $pinfo.RedirectStandardOutput = $true
        $p.StartInfo = $pinfo
        $trash = $p.Start()
        while($p.HasExited -eq $false)
        {
	        Write-Host $p.StandardOutput.ReadLine();
        }
        while($p.StandardOutput.EndOfStream -eq $false)
        {
	        Write-Host $p.StandardOutput.ReadLine();
        }
    }
    else
    {
        $p.StartInfo = $pinfo
        $trash = $p.Start()
        $p.WaitForExit();
    }

    return $p.ExitCode
}

Function Process-StartInlineAndThrow
{
    PARAM(
        [Parameter(Mandatory=$True, Position=1)]
        [string]$Executable,
        [Parameter(Mandatory=$false, Position=2)]
        [string]$Arguments = "",
        [Parameter(Mandatory=$false, Position=3)]
        [string]$WorkingDir = ""
    )
    if((Process-StartInline $Executable $Arguments $WorkingDir) -ne 0)
    {
        throw "Failed: $Executable $Arguments"
    }
}

Function Process-StopIfExists
{
    PARAM(
        [Parameter(Mandatory=$True, Position=1)]
        [string]$Name
    )

    $Processes = Get-Process $Name -ErrorAction SilentlyContinue

    foreach ($Process in $Processes)
    {
        Stop-Process $Process -Force
    }
}