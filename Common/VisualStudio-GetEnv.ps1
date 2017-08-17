PARAM(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$Version,
    [Parameter(Mandatory=$True, Position=2)]
    [string]$Architecture
)

function Invoke-CmdScript {
  param(
    [String] $scriptName
  )
  $cmdLine = """$scriptName"" $args & set"
  & cmd.exe /c $cmdLine |
  select-string '^([^=]*)=(.*)$' | foreach-object {
    $varName = $_.Matches[0].Groups[1].Value
    $varValue = $_.Matches[0].Groups[2].Value
    set-item Env:$varName $varValue
  }
}

switch($Architecture)
{
    "x64" { $Architecture = "amd64" }
    "x86" { $Architecture = "amd64_x86" }
    default { throw "Wrong Architecture: $Architecture"}
}

Write-Output "Choosen Architecture for vcvarsall.bat: $Architecture"

switch($Version)
{
    "2017" 
    {
        if(Test-Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvarsall.bat")
        {
            Invoke-CmdScript "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvarsall.bat" $Architecture
        }
        elseif (Test-Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat")
        {
            Invoke-CmdScript "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" $Architecture
        }
        else
        {
            throw "Wether Community nor Professtional Edition of VS2017 was found"
        }
        if($LASTEXITCODE -ne 0)
        {
            throw "Failed on calling vcvarsall.bat"
        }
    }
    "2015" 
    {
        if(Test-Path "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat")
        {
            Invoke-CmdScript "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" $Architecture
        }
        else
        {
            throw "Failed on calling vcvarsall.bat"
        }
        
        if($LASTEXITCODE -ne 0)
        {
            throw "VS2015 not found"
        }
    }
    "2013" 
    {
        if(Test-Path "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat")
        {
            Invoke-CmdScript "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" $Architecture
        }
        else
        {
            throw "Failed on calling vcvarsall.bat"
        }
        
        if($LASTEXITCODE -ne 0)
        {
            throw "VS2013 not found"
        }
    }
    "2012" 
    {
        if(Test-Path "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat")
        {
            Invoke-CmdScript "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" $Architecture
        }
        else
        {
            throw "Failed on calling vcvarsall.bat"
        }
        
        if($LASTEXITCODE -ne 0)
        {
            throw "VS2012 not found"
        }
    }
}