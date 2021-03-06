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


Function Testing-PortableToolsDownload
{
    # save current PATH
    $SaveEnv = $env:PATH
    $env:PATH = "C:\Windows\System32"

    # Clean OutputFolder
    if(Test-Path "Tools")
    {
        Remove-Item "Tools" -Force -Recurse
    }

    Import-Module "$PSScriptRoot\Cygwin.ps1" -Force
    Cygwin-GetEnv -Mandatory
    Get-command bash -ErrorAction Stop

    Import-Module "$PSScriptRoot\7Zip.ps1" -Force
    7Zip-GetEnv -Mandatory
    $7zipExe = 7Zip-GetExeName

    Import-Module "$PSScriptRoot\Git.ps1" -Force
    Git-GetEnv -Mandatory
    Get-command git -ErrorAction Stop

    Import-Module "$PSScriptRoot\Nasm.ps1" -Force
    Nasm-GetEnv -Mandatory
    Get-command nasm -ErrorAction Stop

    Import-Module "$PSScriptRoot\Ninja.ps1" -Force
    Ninja-GetEnv -Mandatory
    Get-command ninja -ErrorAction Stop

    Import-Module "$PSScriptRoot\Perl.ps1" -Force
    Perl-GetEnv -Mandatory
    Get-command perl -ErrorAction Stop

    # Use Python default Version
    Import-Module "$PSScriptRoot\Python.ps1" -Force
    Python-GetEnv -Mandatory
    Get-command python -ErrorAction Stop

    Import-Module "$PSScriptRoot\Svn.ps1" -Force
    Svn-GetEnv -Mandatory
    Get-command svn -ErrorAction Stop

    $env:PATH = "C:\Windows\System32"
    # Test Python 3.6
    Python-GetEnv -Version 3.6 -Mandatory
    Get-Command python -ErrorAction Stop
    
    # Test Python 2.7
    $env:PATH = "C:\Windows\System32"
    Python-GetEnv -Version 2.7 -Mandatory
    Get-Command python -ErrorAction Stop
    
    $env:PATH = "C:\Windows\System32"
    # Test Python 3.6
    Python-GetEnv -Version 3.6 -Mandatory
    Get-Command python -ErrorAction Stop

    # restore PATH
    $env:PATH = $SaveEnv
}