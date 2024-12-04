@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

echo !YLW![*] Getting Minecraft location...!RST!
echo.
for /f "tokens=*" %%i in ('powershell -NoProfile -command "Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty InstallLocation"') do set "MCLOCATION=%%i"

if not defined MCLOCATION (
    echo !ERR![^^!] Minecraft is not installed.!RST!
    %exitmsg%
) else (
    echo !GRN![*] Minecraft location: !MCLOCATION!!RST!
    echo.
    echo !YLW![*] Getting Minecraft version...!RST!
    echo.
    for /f "tokens=*" %%i in ('powershell -NoProfile -command "Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty Version"') do set "CURRENTVERSION=%%i"
    echo !GRN![*] Minecraft version: !CURRENTVERSION!!RST!
)

if not exist "%oldMinecraftVersion%" (echo !CURRENTVERSION!>"%oldMinecraftVersion%") else (set /p OLDVERSION=<"%oldMinecraftVersion%")

timeout 1 > NUL