# admin
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
{
$script = 'iwr "https://benimsitem.com/IWR.ps1" -UseBasicParsing | iex'
if ($PSCommandPath) { $script = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" } else { $script = "-NoProfile -ExecutionPolicy Bypass -Command `"$script`"" }
Start-Process PowerShell.exe -ArgumentList $script -Verb RunAs
Exit
}

# silent
$progresspreference = 'silentlycontinue'

# style
Set-ItemProperty -Path HKCU:\Console -Name FontSize -Value 0x00140000 -Type DWord
Set-ItemProperty -Path HKCU:\Console -Name FaceName -Value "Consolas"
$Host.UI.RawUI.BackgroundColor = 'Black'
$Host.UI.RawUI.ForegroundColor = 'White'
Clear-Host

# menu
do {
    Clear-Host
    Write-Host "1) Ultimate Remake (Recommended)"
    Write-Host "2) Ultimate (Original)"
    $choice = Read-Host "Select an option (1-2)"
    if ($choice -ne '1' -and $choice -ne '2') {
        Write-Host "Invalid input!"
        Start-Sleep -Milliseconds 800
    }
} while ($choice -ne '1' -and $choice -ne '2')

# select
if ($choice -eq '1') {
    $url = "https://github.com/agigatorx/ultimate-remake/archive/main.zip"
    $zip = "$env:SystemRoot\Temp\UltimateRemake.zip"
    $folder = "UltimateRemake"
} else {
    $url = "https://github.com/FR33THYFR33THY/Ultimate/archive/refs/heads/main.zip"
    $zip = "$env:SystemRoot\Temp\Ultimate.zip"
    $folder = "Ultimate"
}
$extract = "$env:SystemRoot\Temp\$folder"

# download
iwr $url -UseBasicParsing -OutFile $zip

# extract
Expand-Archive -Path $zip -DestinationPath $extract -Force

# rename
$source = Get-ChildItem -Path $extract | Where-Object { $_.PSIsContainer } | Select-Object -First 1
Rename-Item -Path $source.FullName -NewName $folder -Force

# move
$Desktop = (New-Object -ComObject Shell.Application).Namespace('shell:Desktop').Self.Path
Move-Item -Path "$extract\$folder" -Destination "$Desktop\$folder" -Force

# allow
cmd /c "reg add `"HKCR\Applications\powershell.exe\shell\open\command`" /ve /t REG_SZ /d `"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -ExecutionPolicy unrestricted -File \`"`"%1\`"`"`" /f >nul 2>&1"
cmd /c "reg add `"HKCU\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell`" /v `"ExecutionPolicy`" /t REG_SZ /d `"Unrestricted`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell`" /v `"ExecutionPolicy`" /t REG_SZ /d `"Unrestricted`" /f >nul 2>&1"

# unblock
Get-ChildItem -Path "$Desktop\$folder" -Recurse | Unblock-File

# open
Start-Process "$Desktop\$folder"

# exit
exit
