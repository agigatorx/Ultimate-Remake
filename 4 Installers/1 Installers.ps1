        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        # SCRIPT CHECK INTERNET
        if (!(Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
        Write-Host "Internet Connection Required`n" -ForegroundColor Red
        Pause
        exit
        }

        # SCRIPT SILENT
        $progresspreference = 'silentlycontinue'

        function show-menu {
	    Clear-Host
	    Write-Host "Program installers`n"
        Write-Host " 1. VMWare"
		Write-Host " 2. OpenCode"
		Write-Host " 3. WinRAR"
		Write-Host " 4. Steam"
		Write-Host " 5. Visual Studio 2019 (Manuel Setup)"
		Write-Host " 6. Visual Studio 2022 (Manuel Setup)"
		Write-Host " 7. 7-Zip"
		Write-Host " 8. VS Code"
		Write-Host " 9. League Of Legends (EU & Manuel Setup)"
		Write-Host " 10. Valorant (EU & Manuel Setup)"
		Write-Host " 11. Notepad++"
		Write-Host " 12. HxD (Manuel Setup)"
		Write-Host " 13. Exit`n"
	                  }
	    show-menu
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^(1[123]|[1-9])$') {

        switch ($choice) {
        1 {

Clear-Host

Write-Host "Downloading: VMWare..."

# paths
$vmwareUrl = "https://files06.tchspt.com/down/VMware-Workstation-Full-26H1-25388281.exe"
$vmwareExe = "$env:TEMP\VMware-Workstation-Full-26H1-25388281.exe"

# download vmware to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$vmwareExe" "$vmwareUrl"
if ($LASTEXITCODE -eq 0) { $download = $true }
}

# check download
if ($download -and (Test-Path "$vmwareExe")) {

# run vmware installer silently
$install = Start-Process "$vmwareExe" -ArgumentList "/s" -Wait -PassThru

if ($install.ExitCode -eq 0) {

Write-Host "VMWare Installed" -ForegroundColor Green

} else {

Write-Host "Setup Failed (Exit Code: $($install.ExitCode))" -ForegroundColor Red

}

} else {

Remove-Item "$vmwareExe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Pause

show-menu

          }
        2 {

Clear-Host

Write-Host "Downloading: OpenCode..."

# paths
$opencodeUrl = "https://opencode.ai/tr/download/stable/windows-x64-nsis"
$opencodeExe = "$env:TEMP\opencode-setup.exe"

# download opencode to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$opencodeExe" "$opencodeUrl"
if ($LASTEXITCODE -eq 0) { $download = $true }
}

# check download
if ($download -and (Test-Path "$opencodeExe")) {

# run opencode installer silently (NSIS /S)
$install = Start-Process "$opencodeExe" -ArgumentList "/S" -Wait -PassThru

if ($install.ExitCode -eq 0) {

Write-Host "OpenCode Installed" -ForegroundColor Green

} else {

Write-Host "Setup Failed (Exit Code: $($install.ExitCode))" -ForegroundColor Red

}

} else {

Remove-Item "$opencodeExe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Remove-Item "$opencodeExe" -Force -ErrorAction SilentlyContinue

Pause

show-menu

          }
        3 {

Clear-Host

Write-Host "Downloading: WinRAR..."

# winrar postdownload is an html page, curl the page and grab the real exe link
$winrarPage = "https://www.win-rar.com/postdownload.html?&L=5"
$winrarExe  = "$env:TEMP\winrar-x64.exe"

# download winrar to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {

$winrarUrl = curl.exe -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "$winrarPage" | Select-String -Pattern 'href="(/fileadmin/winrar-versions/winrar/winrar-x64-[\w.\-]+\.exe)"' | ForEach-Object { $_.Matches[0].Groups[1].Value } | Select-Object -First 1

if ($winrarUrl) {

$winrarUrl = "https://www.win-rar.com" + $winrarUrl
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$winrarExe" "$winrarUrl"
if ($LASTEXITCODE -eq 0) { $download = $true }

}

}

# check download
if ($download -and (Test-Path "$winrarExe")) {

# run winrar installer silently (/s)
$install = Start-Process "$winrarExe" -ArgumentList "/s" -Wait -PassThru

if ($install.ExitCode -eq 0) {

Write-Host "WinRAR Installed" -ForegroundColor Green

} else {

Write-Host "Setup Failed (Exit Code: $($install.ExitCode))" -ForegroundColor Red

}

} else {

Remove-Item "$winrarExe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Remove-Item "$winrarExe" -Force -ErrorAction SilentlyContinue

Pause

show-menu

          }
        4 {

Clear-Host

Write-Host "Downloading: Steam..."

# paths
$steamUrl = "https://cdn.fastly.steamstatic.com/client/installer/SteamSetup.exe"
$steamExe = "$env:TEMP\SteamSetup.exe"

# download steam to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$steamExe" "$steamUrl"
if ($LASTEXITCODE -eq 0) { $download = $true }
}

# check download
if ($download -and (Test-Path "$steamExe")) {

# run steam installer silently (NSIS /S)
$install = Start-Process "$steamExe" -ArgumentList "/S" -Wait -PassThru

if ($install.ExitCode -eq 0) {

Write-Host "Steam Installed" -ForegroundColor Green

} else {

Write-Host "Setup Failed (Exit Code: $($install.ExitCode))" -ForegroundColor Red

}

} else {

Remove-Item "$steamExe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Remove-Item "$steamExe" -Force -ErrorAction SilentlyContinue

Pause

show-menu

          }
        5 {

Clear-Host

Write-Host "Downloading: Visual Studio 2019..."

# paths
$vs19Url = "http://aka.ms/vs/16/release/vs_community.exe"
$vs19Exe = "$env:TEMP\VS2019-Community-Setup.exe"

# download vs2019 to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$vs19Exe" "$vs19Url"
if ($LASTEXITCODE -eq 0) { $download = $true }
}

# check download
if ($download -and (Test-Path "$vs19Exe")) {

# run vs2019 bootstrapper as admin (no silent support)
Start-Process "$vs19Exe" -Verb RunAs

# manual setup notice
Write-Host "Manuel Setup Required" -ForegroundColor Yellow

} else {

Remove-Item "$vs19Exe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Remove-Item "$vs19Exe" -Force -ErrorAction SilentlyContinue

Pause

show-menu

          }
        6 {

Clear-Host

Write-Host "Downloading: Visual Studio 2022..."

# paths
$vs22Url = "http://aka.ms/vs/17/release/vs_community.exe"
$vs22Exe = "$env:TEMP\VS2022-Community-Setup.exe"

# download vs2022 to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$vs22Exe" "$vs22Url"
if ($LASTEXITCODE -eq 0) { $download = $true }
}

# check download
if ($download -and (Test-Path "$vs22Exe")) {

# run vs2022 bootstrapper as admin (no silent support)
Start-Process "$vs22Exe" -Verb RunAs

# manual setup notice
Write-Host "Manuel Setup Required" -ForegroundColor Yellow

} else {

Remove-Item "$vs22Exe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Remove-Item "$vs22Exe" -Force -ErrorAction SilentlyContinue

Pause

show-menu

          }
        7 {

Clear-Host

Write-Host "Downloading: 7-Zip..."

# paths
$sevenZipUrl = "https://github.com/ip7z/7zip/releases/download/26.04/7z2604-x64.exe"
$sevenZipExe = "$env:TEMP\7z2604-x64.exe"

# download 7zip to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$sevenZipExe" "$sevenZipUrl"
if ($LASTEXITCODE -eq 0) { $download = $true }
}

# check download
if ($download -and (Test-Path "$sevenZipExe")) {

# run 7zip installer silently (NSIS /S)
$install = Start-Process "$sevenZipExe" -ArgumentList "/S" -Wait -PassThru

if ($install.ExitCode -eq 0) {

Write-Host "7-Zip Installed" -ForegroundColor Green

} else {

Write-Host "Setup Failed (Exit Code: $($install.ExitCode))" -ForegroundColor Red

}

} else {

Remove-Item "$sevenZipExe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Remove-Item "$sevenZipExe" -Force -ErrorAction SilentlyContinue

Pause

show-menu

          }
        8 {

Clear-Host

Write-Host "Downloading: VS Code..."

# paths
$vscodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
$vscodeExe = "$env:TEMP\VSCodeUserSetup.exe"

# download vscode to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$vscodeExe" "$vscodeUrl"
if ($LASTEXITCODE -eq 0) { $download = $true }
}

# check download
if ($download -and (Test-Path "$vscodeExe")) {

# run vscode installer silently as admin (NSIS /S)
$install = Start-Process "$vscodeExe" -ArgumentList "/S" -Verb RunAs -Wait -PassThru

if ($install.ExitCode -eq 0) {

Write-Host "VS Code Installed" -ForegroundColor Green

} else {

Write-Host "Setup Failed (Exit Code: $($install.ExitCode))" -ForegroundColor Red

}

} else {

Remove-Item "$vscodeExe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Remove-Item "$vscodeExe" -Force -ErrorAction SilentlyContinue

Pause

show-menu

          }
        9 {

Clear-Host

Write-Host "Downloading: League Of Legends..."

# paths
$lolUrl = "https://lol.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.tr.exe"
$lolExe = "$env:TEMP\LeagueOfLegends-TR.exe"

# download lol to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$lolExe" "$lolUrl"
if ($LASTEXITCODE -eq 0) { $download = $true }
}

# check download
if ($download -and (Test-Path "$lolExe")) {

# run lol installer (no silent support)
Start-Process "$lolExe"

# manual setup notice
Write-Host "Manuel Setup Required" -ForegroundColor Yellow

} else {

Remove-Item "$lolExe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Pause

show-menu

          }
        10 {

Clear-Host

Write-Host "Downloading: Valorant..."

# paths
$valorantUrl = "https://valorant.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.live.eu.exe"
$valorantExe = "$env:TEMP\Valorant-EU.exe"

# download valorant to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$valorantExe" "$valorantUrl"
if ($LASTEXITCODE -eq 0) { $download = $true }
}

# check download
if ($download -and (Test-Path "$valorantExe")) {

# run valorant installer (no silent support)
Start-Process "$valorantExe"

# manual setup notice
Write-Host "Manuel Setup Required" -ForegroundColor Yellow

} else {

Remove-Item "$valorantExe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Pause

show-menu

          }
        11 {

Clear-Host

Write-Host "Downloading: Notepad++..."

# paths
$nppUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.9.8/npp.8.9.8.Installer.x64.exe"
$nppExe = "$env:TEMP\npp.8.9.8.Installer.x64.exe"

# download notepad++ to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$nppExe" "$nppUrl"
if ($LASTEXITCODE -eq 0) { $download = $true }
}

# check download
if ($download -and (Test-Path "$nppExe")) {

# run notepad++ installer silently as admin (NSIS /S)
$install = Start-Process "$nppExe" -ArgumentList "/S" -Verb RunAs -Wait -PassThru

if ($install.ExitCode -eq 0) {

Write-Host "Notepad++ Installed" -ForegroundColor Green

} else {

Write-Host "Setup Failed (Exit Code: $($install.ExitCode))" -ForegroundColor Red

}

} else {

Remove-Item "$nppExe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Remove-Item "$nppExe" -Force -ErrorAction SilentlyContinue

Pause

show-menu

          }
        12 {

Clear-Host

Write-Host "Downloading: HxD..."

# paths
$hxdUrl = "https://mh-nexus.de/downloads/HxDSetup.zip"
$hxdZip = "$env:TEMP\HxDSetup.zip"
$hxdExe = "$env:TEMP\HxDSetup.exe"

# remove leftovers
Remove-Item "$hxdZip","$hxdExe" -Force -ErrorAction SilentlyContinue

# download hxd zip to %temp% with curl (cloudflare blocks powershell iwr)
$download = $false
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
curl.exe --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -o "$hxdZip" "$hxdUrl"
if ($LASTEXITCODE -eq 0) { $download = $true }
}

# check download
if ($download -and (Test-Path "$hxdZip")) {

# extract the zip to %temp%
Expand-Archive -Path "$hxdZip" -DestinationPath "$env:TEMP" -Force -ErrorAction SilentlyContinue

}

# check extracted exe
if (Test-Path "$hxdExe") {

# run hxd installer silently (Inno Setup)
$install = Start-Process "$hxdExe" -ArgumentList "/silent /SUPPRESSMSGBOXES" -Wait -PassThru

if ($install.ExitCode -eq 0) {

Write-Host "HxD Installed" -ForegroundColor Green

} else {

Write-Host "Setup Failed (Exit Code: $($install.ExitCode))" -ForegroundColor Red

}

} else {

Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

# remove zip and exe
Remove-Item "$hxdZip","$hxdExe" -Force -ErrorAction SilentlyContinue

Pause

show-menu

          }
        13 {

Clear-Host

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-13)." } }
