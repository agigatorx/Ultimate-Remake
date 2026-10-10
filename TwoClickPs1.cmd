    @echo off
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
    if '%errorlevel%' NEQ '0' (
    goto uacprompt
    ) else ( goto gotadmin )
    :uacprompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
    :gotadmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

    :menu
    cls
    echo 1. Allow Scripts + Set PS1 Files To Open With Windows PowerShell
    echo 2. Set PS1 Files To Open With Windows PowerShell Only
	echo.
    set /p choice=:
    if "%choice%"=="1" goto A
    if "%choice%"=="2" goto B
    goto menu
    :A

cls
call :removeuserchoice
:: open ps1 files with windows powershell on double click
reg add "HKCR\Microsoft.PowerShellScript.1\shell\open\command" /ve /t REG_SZ /d "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -ExecutionPolicy Bypass -File \"%%1\"" /f >nul 2>&1
:: allow powershell scripts
reg add "HKCU\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /v "ExecutionPolicy" /t REG_SZ /d "Bypass" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /v "ExecutionPolicy" /t REG_SZ /d "Bypass" /f >nul 2>&1
:: unblock all files in current directory
cd /d "%~dp0"
powershell -Command "Get-ChildItem -Path . -Recurse | Unblock-File"
echo Enabled PowerShell Scripts + PS1 Files Now Open With Windows PowerShell
pause
exit

    :B

cls
call :removeuserchoice
:: open ps1 files with windows powershell on double click
reg add "HKCR\Microsoft.PowerShellScript.1\shell\open\command" /ve /t REG_SZ /d "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -ExecutionPolicy Bypass -File \"%%1\"" /f >nul 2>&1
echo PS1 Files Now Open With Windows PowerShell
pause
exit

    :removeuserchoice
:: get user sid
for /f "tokens=2" %%i in ('whoami /user ^| findstr /r /c:"S-1-5-21"') do set "USERSID=%%i"
:: remove ps1 user choice (blocks the ps1 open command, delete as system)
schtasks /create /tn "UltimatePs1UserChoice" /tr "reg delete HKEY_USERS\%USERSID%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ps1\UserChoice /f" /sc once /st 00:00 /ru SYSTEM /rl HIGHEST /f >nul 2>&1
schtasks /run /tn "UltimatePs1UserChoice" >nul 2>&1
:: wait for removal (max 5 seconds, continues as soon as its gone)
for /l %%c in (1,1,5) do (
reg query "HKEY_USERS\%USERSID%\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ps1\UserChoice" >nul 2>&1 && (ping -n 2 127.0.0.1 >nul) || goto removed
)
:removed
schtasks /delete /tn "UltimatePs1UserChoice" /f >nul 2>&1
exit /b
