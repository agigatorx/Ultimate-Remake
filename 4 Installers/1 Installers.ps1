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
        Write-Host " 1. VMWare (Manuel Setup)"
		Write-Host " 2. Exit`n"
	                  }
	    show-menu
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^(1|2)$') {

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

# run vmware installer
Start-Process "$vmwareExe"

# manual setup notice
Write-Host "Manuel Setup Required" -ForegroundColor Yellow

} else {

Remove-Item "$vmwareExe" -Force -ErrorAction SilentlyContinue
Write-Host "Download Failed (curl.exe missing or link blocked)`n" -ForegroundColor Red

}

Pause

show-menu

          }
        2 {

Clear-Host

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
