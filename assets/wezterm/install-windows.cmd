@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-windows.ps1"
if errorlevel 1 (
  echo.
  echo Setup failed. Review the message above.
  pause
  exit /b 1
)

echo.
pause
