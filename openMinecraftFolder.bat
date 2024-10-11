@echo off
cls
setlocal
title Opening Minecraft folder...
echo This script has nothing to do with Matject.
echo It's for opening Minecraft app folder.
echo.
echo [*] Getting Minecraft location and opening...
echo.
for /f "tokens=*" %%i in ('powershell -command "Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty InstallLocation"') do set "MCLOCATION=%%i"
if not defined MCLOCATION (
    echo [!] Couldn't find Minecraft installation location.
    echo.
    pause
    goto:EOF
)
explorer "%MCLOCATION%"
endlocal