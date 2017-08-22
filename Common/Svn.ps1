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
Import-Module "$PSScriptRoot\Process.ps1"

$Global:PortableSvnDownload  = "http://mirror.adirmeier.de/projects/ThirdParty/Subversion/binaries/1.9.7/Subversion.portable.zip"
$Global:PortableSvnToolsDir  = "$PSScriptRoot\Tools"
$Global:PortableSvnTarget    = "$Global:PortableSvnToolsDir\Subversion"
$Global:PortableSvnTempZip   = "$Global:PortableSvnToolsDir\Subversion.zip"
$Global:PortableSvnTargetBin = "$Global:PortableSvnTarget\bin"

Function Svn-GetEnv
{
    PARAM(
        [Parameter(Mandatory=$False, Position=1)]
        [switch]$Mandatory
    )

    if(Get-Command svn.exe -ErrorAction SilentlyContinue)
    {
        Write-Output "Subversion already in PATH"
    }
    # Check for Portable Version already downloaded
    elseif((Test-Path "$Global:PortableSvnTargetBin"))
    {
        $env:PATH += ";$Global:PortableSvnTargetBin"
        Write-Output "NASM found at $Global:PortableSvnTargetBin"
    }
    elseif($Mandatory)
    {
        Write-Output "Mandatory Svn not found, try to download portable Version"
        Import-Module "$PSScriptRoot\Web.ps1" -Force
        Import-Module "$PSScriptRoot\Compress.ps1" -Force

        if(-not (Test-Path $Global:PortableSvnToolsDir))
        {
            New-Item -ItemType Directory -Path $Global:PortableSvnToolsDir
        }
        if(Web-Download $Global:PortableSvnDownload $Global:PortableSvnTempZip)
        {
            Compress-Unzip $Global:PortableSvnTempZip $Global:PortableSvnTarget
            Remove-Item $Global:PortableSvnTempZip
            $env:PATH += ";$Global:PortableSvnTargetBin"
            Write-Output "Svn now available at TargetBin"
        }
        else
        {
            throw( "Svn not found, download failed" )
        }
    }
    else
    {
        Write-Output "No Subversion found";
    }
}

Function Svn-Clean
{
    PARAM(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$Target
    )

    $CurrentDir = ((Get-Item -Path ".\" -Verbose).FullName)

    $temp = Process-StartAndGetOutput "svn" "status --no-ignore" $Target
    [string[]]$FilesToDelete = $temp.Split([Environment]::NewLine)

    cd $Target
    foreach($File in $FilesToDelete)
    {
        if($File.Length -gt 0 -and ($File[0] -eq '?' -or $File[0] -eq 'I'))
        {
            Remove-Item $File.Substring(1).Trim() -Recurse -Force
        }
    }
    svn cleanup
    if($LASTEXITCODE -ne 0)
    {
        throw "Failed svn cleanup:"
    }

    cd $CurrentDir
}