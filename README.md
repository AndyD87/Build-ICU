# Build ICU for Windows (MSVC)

This build scripts are created for Powershell in Windows.
Sources will be downloaded from original repository on https://icu-project.org

Primarily this script was created for my BuildSystem wich is described [d](https:\\adirmeier.de).  
This scripts should work on other systems too.  
If something goes wrong feel free to debug with *Powershell ISE* or write a Message.

## Requirements

 - Visual Studio
 - Cmake (for creating zip)
 - Cygwin with binutils, make, bash
 - Subversion for Commandline

## How to build

For example, to build the Version 59.1, execute the following command:

    .\Make.ps1 -VisualStudio 2017 -Architecture x64 -Version 59.1
    
Options (bold are mandatory):
 - **VisualStudio**: 2012/2013/2015/2017
 - **Architectrue**: x64/x86
 - Version: Version of ICU (default: latest)
 - Static: $true/$false (default: $false)
 - Debug: $true/$false (default: $false)
 - AdditionalConfig: String to append on configure command (default: "")
 
