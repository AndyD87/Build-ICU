# Build ICU for Windows (MSVC)

This build scripts are created for Powershell in Windows.
Sources will be downloaded from original repository on https://icu-project.org

Primarily this script was created for my BuildSystem wich is described [here](https://adirmeier.de/0_Blog/ID_157/index.html).  
This scripts should work on other systems too.  

Since this Version, there are only two major requirements to get this build working.  
All other tools, wich are required for build, will be downloaded automatically and set 
to PATH for building.  
The download will only happen if Scripts wasn't able to find a local Version of this tools.
So it is still recommended to install it on your system.

If error will occur you can use *Powershell ISE* for debugging, or contact me.

## Requirements

Mandatory Requirements:
 - Powershell Version >= 3.0
 - Visual Studio 2012/2013/2015/2017

Recommended Requirements:
 - Python 2.7  
    Common Tools will download a Portable Version of WinPython if not available
 - Perl  
    Common Scripts will download a Portable Version of StrawberryPerl if not available
 - Subversion: Required for ICU  
    Common Scripts will download a Portable Version of Subversion if not available
 - Git
    Common Scripts will download a Portable Version of Git if not available
 - Cygwin
    Common Scripts will download a Portable Version of Cygwin if not available

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
 
## Output Format

The name of the output folder will be generated as follows:

    icu-$Version-$VisualStudioYear-$Architecture[_static][_debug][_MT]

Conditions for Postfixes:
 - **_static**: will be set if *-Static* is enabled
 - **_debug**: will be set if *-DebugBuild* is enabled
 - **_MT**: will be set if *-StaticRuntime* is enabled
 
