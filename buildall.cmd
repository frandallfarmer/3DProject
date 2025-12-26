@echo off
setlocal

where pwsh >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: PowerShell 7 ^(pwsh^) is not installed.
    echo.
    echo Install it with:
    echo   winget install Microsoft.PowerShell
    echo.
    pause
    exit /b 1
)


@echo off
pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0buildall.ps1"
pause
