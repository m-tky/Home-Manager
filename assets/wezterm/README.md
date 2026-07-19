# WezTerm on Windows + WSL

On Windows, double-click `install-windows.cmd`. It installs the WezTerm
configuration and the latest standard Moralerspace release for the current
user; administrator privileges are not required.

Alternatively, run the PowerShell script from this directory:

```powershell
powershell -ExecutionPolicy Bypass -File .\install-windows.ps1
```

The script replaces `%USERPROFILE%\.wezterm.lua`, preserving its previous
contents as `%USERPROFILE%\.wezterm.lua.bak`. It installs the fonts in
`%LOCALAPPDATA%\Microsoft\Windows\Fonts\Moralerspace` and can safely be rerun
to update them.

After setup, launch (or restart) WezTerm. New windows open the default WSL
distribution in `~`.

Set the distribution from PowerShell when needed:

```powershell
wsl --set-default <distribution>
```

The launch menu also retains a PowerShell entry. The configuration uses the
same theme as the Kitty and Wayland WezTerm configurations and enables the
Kitty graphics protocol for applications running in WSL.
