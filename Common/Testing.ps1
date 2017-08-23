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
    Remove-Item "Tools" -Force -Recurse
    Import-Module "$PSScriptRoot\Git.ps1" -Force
    Import-Module "$PSScriptRoot\Nasm.ps1" -Force
    Import-Module "$PSScriptRoot\Ninja.ps1" -Force
    Import-Module "$PSScriptRoot\Perl.ps1" -Force
    Import-Module "$PSScriptRoot\Python.ps1" -Force
    Import-Module "$PSScriptRoot\Svn.ps1" -Force

    # save current PATH
    $SaveEnv = $env:PATH
    $env:PATH = "C:\Windows\System32"

    Git-GetEnv -Mandatory
    Nasm-GetEnv -Mandatory
    Ninja-GetEnv -Mandatory
    Perl-GetEnv -Mandatory
    Python-GetEnv -Mandatory # python without Version
    Svn-GetEnv -Mandatory

    # test if all commands are available
    Get-command git -ErrorAction Stop
    Get-command nasm -ErrorAction Stop
    Get-command ninja -ErrorAction Stop
    Get-command perl -ErrorAction Stop
    Get-command python -ErrorAction Stop
    Get-command svn -ErrorAction Stop
    
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