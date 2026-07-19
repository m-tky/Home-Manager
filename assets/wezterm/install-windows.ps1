[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Write-Status {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Remove-RegisteredMoralerspaceFonts {
    $fontsRegistryPath = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
    if (-not (Test-Path -LiteralPath $fontsRegistryPath)) {
        New-Item -Path $fontsRegistryPath -Force | Out-Null
        return
    }

    $properties = Get-ItemProperty -Path $fontsRegistryPath
    foreach ($property in $properties.PSObject.Properties) {
        if ($property.Name -like 'Moralerspace*') {
            Remove-ItemProperty -Path $fontsRegistryPath -Name $property.Name -Force
        }
    }
}

$scriptDirectory = $PSScriptRoot
$wezTermSource = Join-Path $scriptDirectory 'wezterm-windows.lua'
if (-not (Test-Path -LiteralPath $wezTermSource)) {
    throw "WezTerm configuration was not found: $wezTermSource"
}

$wezTermDestination = Join-Path $env:USERPROFILE '.wezterm.lua'
if (Test-Path -LiteralPath $wezTermDestination) {
    Copy-Item -LiteralPath $wezTermDestination -Destination "$wezTermDestination.bak" -Force
    Write-Status "Backed up the existing WezTerm configuration to $wezTermDestination.bak"
}
Copy-Item -LiteralPath $wezTermSource -Destination $wezTermDestination -Force
Write-Status "Installed WezTerm configuration to $wezTermDestination"

$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/yuru7/moralerspace/releases/latest' -Headers @{ Accept = 'application/vnd.github+json' }
$asset = @($release.assets | Where-Object { $_.name -match '^Moralerspace_v.+\.zip$' } | Select-Object -First 1)
if ($asset.Count -ne 1) {
    throw 'Could not find the standard Moralerspace ZIP in the latest GitHub release.'
}

$temporaryDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("moralerspace-" + [guid]::NewGuid().ToString())
$archivePath = Join-Path $temporaryDirectory $asset[0].name
$extractDirectory = Join-Path $temporaryDirectory 'extracted'
$fontDestination = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts\Moralerspace'

try {
    New-Item -ItemType Directory -Path $temporaryDirectory -Force | Out-Null
    Write-Status "Downloading Moralerspace $($release.tag_name)"
    Invoke-WebRequest -Uri $asset[0].browser_download_url -OutFile $archivePath
    Expand-Archive -LiteralPath $archivePath -DestinationPath $extractDirectory -Force

    $fontFiles = @(Get-ChildItem -Path $extractDirectory -Recurse -File |
        Where-Object { $_.Extension -in '.ttf', '.otf' })
    if ($fontFiles.Count -eq 0) {
        throw 'The Moralerspace archive did not contain any TTF or OTF font files.'
    }

    # Keep every version in a dedicated directory so a rerun cleanly replaces it.
    Remove-RegisteredMoralerspaceFonts
    if (Test-Path -LiteralPath $fontDestination) {
        Remove-Item -LiteralPath $fontDestination -Recurse -Force
    }
    New-Item -ItemType Directory -Path $fontDestination -Force | Out-Null

    $fontsRegistryPath = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
    foreach ($fontFile in $fontFiles) {
        $destination = Join-Path $fontDestination $fontFile.Name
        Copy-Item -LiteralPath $fontFile.FullName -Destination $destination -Force
        New-ItemProperty -Path $fontsRegistryPath -Name ("Moralerspace " + $fontFile.Name) -Value $destination -PropertyType String -Force | Out-Null
    }

    # Tell already-running GUI applications that the per-user font set changed.
    if (-not ('MoralerspaceNativeMethods' -as [type])) {
        Add-Type @'
using System;
using System.Runtime.InteropServices;
public static class MoralerspaceNativeMethods {
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern IntPtr SendMessageTimeout(
        IntPtr hWnd, uint msg, UIntPtr wParam, string lParam,
        uint flags, uint timeout, out UIntPtr result);
}
'@
    }
    $result = [UIntPtr]::Zero
    [void][MoralerspaceNativeMethods]::SendMessageTimeout(
        [IntPtr]0xffff, 0x001d, [UIntPtr]::Zero, $null, 0x0002, 5000, [ref]$result)

    Write-Status "Installed $($fontFiles.Count) Moralerspace font files to $fontDestination"
    Write-Host 'Setup complete. Restart WezTerm if it is already open.' -ForegroundColor Green
}
finally {
    if (Test-Path -LiteralPath $temporaryDirectory) {
        Remove-Item -LiteralPath $temporaryDirectory -Recurse -Force
    }
}
