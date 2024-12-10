@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k
echo !YLW![*] Getting Minecraft%isPreview: Mode=% location...!RST!
for /f "tokens=*" %%i in ('powershell -NoProfile -command "Get-AppxPackage -Name Microsoft.%productID% | Select-Object -ExpandProperty InstallLocation"') do set "MCLOCATION=%%i"

if not defined MCLOCATION (
    echo.
    echo !ERR![^^!] Minecraft%isPreview: Mode=% is not installed.!RST!
    %exitmsg%
)
echo !GRN![*] Minecraft%isPreview: Mode=% location: !MCLOCATION!!RST!
echo.
if "%1" equ "savepath" (
    echo !MCLOCATION!>%customMinecraftAppPath%
    timeout 2 >nul
    exit /b 0
)
echo !YLW![*] Getting Minecraft%isPreview: Mode=% version...!RST!
for /f "tokens=*" %%i in ('powershell -NoProfile -command "Get-AppxPackage -Name Microsoft.%productID% | Select-Object -ExpandProperty Version"') do set "CURRENTVERSION=%%i"
echo !GRN![*] Minecraft version%isPreview: Mode=%: !CURRENTVERSION!!RST!


if not exist "%oldMinecraftVersion%" (echo !CURRENTVERSION!>"%oldMinecraftVersion%") else (set /p OLDVERSION=<"%oldMinecraftVersion%")

timeout 2 > NUL