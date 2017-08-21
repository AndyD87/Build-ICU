# Build ICU for Windows (MSVC)

This build scripts are created for Powershell in Windows.
Sources will be downloaded from original repository on https://icu-project.org

Primarily this script was created for my BuildSystem wich is described [here](https://adirmeier.de/0_Blog/ID_157/index.html).  
This scripts should work on other systems too.  
If something goes wrong feel free to debug with *Powershell ISE* or write a Message.

## Requirements

Mandatory Requirements:
 - Git
 - Visual Studio 2012/2013/2015/2017
 - Cmake (for working with Zip-Files)
 - Cygwin

Recommended Requirements:
 - Python 2.7
    Common Tools will download a Portable Version of WinPython if not available
 - Perl
    Common Scripts will download a Portable Version of StrawberryPerl if not available
 - Subversion: Required for ICU
    Common Scripts will download a Portable Version of Subversion if not available

## How to build

For example, to build the Version 59.1, execute the following command:

    .\Make.ps1 -VisualStudio 2017 -Architecture x64 -Version 59.1
    
Options (bold are mandatory):
 - **VisualStudio**: 2012/2013/2015/2017
 - **Architectrue**: x64/x86
 - Version: Version of ICU (default: latest)
 - Static: $true/$false (default: $false)
   It will rewrite runConfigureICU to build with static runtime too.
 - DebugBuild: $true/$false (default: $false)
 - StaticRuntime: $true/$false (default: $false)
 - AdditionalConfig: String to append on configure command (default: "")
 