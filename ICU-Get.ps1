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
PARAM(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$Target,
    [Parameter(Mandatory=$true, Position=2)]
    [string]$Version = ""

)
Import-Module "$PSScriptRoot\Common\Svn.ps1" -Force
Import-Module "$PSScriptRoot\Common\Process.ps1" -Force

Svn-GetEnv -Mandatory

$CurrentDir = ((Get-Item -Path ".\" -Verbose).FullName)

$Version = $Version.Replace(".", "-");

if($Version -eq "latest")
{
    $cmd = "checkout --quiet http://source.icu-project.org/repos/icu/tags/$Version/icu4c `"$Target`""
}
else
{
    $cmd = "checkout --quiet http://source.icu-project.org/repos/icu/tags/release-$Version/icu4c `"$Target`""
}

Write-Output "Checkout svn quietly"
Process-StartInlineAndThrow "svn" "$cmd"

cd $CurrentDir