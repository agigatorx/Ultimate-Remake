        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        # local files folder
        $source = "$PSScriptRoot\..\0 Embedded Files"

        # check embedded files
        if (!(Test-Path "$source\vcredist2005_x86.exe")) {
        Write-Host "Embedded Files Not Found: $source`n" -ForegroundColor Red
        Pause
        exit
        }

Write-Host "Copying: C++..."

# copy local c++ installers
Copy-Item "$source\vcredist*.exe" -Destination "$env:SystemRoot\Temp" -Force

Clear-Host
Write-Host "Installing: C++..."

# install c++
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2005_x86.exe" -ArgumentList "/Q /C:`"msiexec /i vcredist.msi /qn /norestart`"" -WindowStyle Hidden
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2005_x64.exe" -ArgumentList "/Q /C:`"msiexec /i vcredist.msi /qn /norestart`"" -WindowStyle Hidden
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2008_x86.exe" -ArgumentList "/q" -WindowStyle Hidden
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2008_x64.exe" -ArgumentList "/q" -WindowStyle Hidden
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2010_x86.exe" -ArgumentList "/quiet /norestart" -WindowStyle Hidden
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2010_x64.exe" -ArgumentList "/quiet /norestart" -WindowStyle Hidden
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2012_x86.exe" -ArgumentList "/quiet /norestart" -WindowStyle Hidden
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2012_x64.exe" -ArgumentList "/quiet /norestart" -WindowStyle Hidden
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2013_x86.exe" -ArgumentList "/quiet /norestart" -WindowStyle Hidden
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2013_x64.exe" -ArgumentList "/quiet /norestart" -WindowStyle Hidden
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2015_2017_2019_2022_x86.exe" -ArgumentList "/quiet /norestart" -WindowStyle Hidden
Start-Process -Wait "$env:SystemRoot\Temp\vcredist2015_2017_2019_2022_x64.exe" -ArgumentList "/quiet /norestart" -WindowStyle Hidden
