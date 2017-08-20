
Function Python-GetEnv
{
    PARAM(
        [Parameter(Mandatory=$True, Position=1)]
        [string]$Version,
    
        [switch]$Mandatory
    )

    $VTarget = New-Object System.Version($Version)
    if($VTarget.Major -eq 2)
    {
        if(Get-Command python.exe -ErrorAction SilentlyContinue)
        {
            Write-Output "Python already in PATH"
        }
        # Test default location from BuildSystem
        elseif((Test-Path "C:\Tools\Python27"))
        {
            $env:PATH += ";C:\Tools\Python27"
            Write-Output "Python found at C:\Tools\Python27"
        }
        # Test default location from orignal Python-Setup 2.7.x
        elseif((Test-Path "C:\Python27"))
        {
            $env:PATH += ";C:\Python27"
            Write-Output "Python found at C:\Python27"
        }
        elseif($Mandatory)
        {
            throw( "No Python found" )
        }
        else
        {
            Write-Output "No Python found"
        }
    }

    if($VTarget.Major -eq 3)
    {
        if(Get-Command python.exe -ErrorAction SilentlyContinue)
        {
            Write-Output "Python already in PATH"
        }
        # Test default location from BuildSystem
        elseif((Test-Path "C:\Tools\Python36"))
        {
            $env:PATH += ";C:\Tools\Python36"
            Write-Output "Python found at C:\Tools\Python36"
        }
        # Test default location from orignal Python-Setup 3.6.x
        elseif((Test-Path "C:\Program Files\Python36"))
        {
            $env:PATH += ";C:\Program Files\Python36"
            Write-Output "Python found at C:\Program Files\Python36"
        }
        # Test default location from orignal Python-Setup 3.4.x
        elseif((Test-Path "C:\Program Files\Python34"))
        {
            $env:PATH += ";C:\Program Files\Python34"
            Write-Output "Python found at C:\Program Files\Python34"
        }
        elseif($Mandatory)
        {
            throw( "No Python found" )
        }
        else
        {
            Write-Output "No Python found"
        }
    }

}