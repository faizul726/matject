@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
echo !YLW!!BLINK![*] Getting Minecraft%preview% details...!RST!

if not exist "%disableTips%" (
    if not exist "%customMinecraftAppPath%" (
        echo.
        echo !GRN![TIP]!RST! You can make getting details faster by enabling "Use custom Minecraft app path"
    )
)

if not defined chcp_failed (chcp %chcp_default% >nul 2>&1)
:: PowerShell command by @FlaredRoverCodes
for /f "tokens=1,2 delims=///" %%i in ('powershell -NoProfile -Command "(Get-AppxPackage -Name Microsoft.%productID%).InstallLocation + '///' + (Get-AppxPackage -Name Microsoft.%productID%).Version"') do (
    set MCLOCATION=%%i
    set CURRENTVERSION=%%j
)
echo.
if not defined chcp_failed (chcp 65001 >nul 2>&1)

if not defined MCLOCATION (
    echo !ERR![^^!] Minecraft%preview% is not installed.!RST!
    echo.
    echo !YLW![*] Disabled "Use for Minecraft Preview" to allow normal access to Matject.!RST!
    if defined preview (del /q /s ".\%useForMinecraftPreview%" >nul)
    %exitmsg%
)

echo !WHT!Minecraft%preview% location:!RST! !MCLOCATION!
echo !WHT!Minecraft%preview% version:!RST!  v!CURRENTVERSION!

if "[%1]" equ "[savepath]" (
    echo !MCLOCATION!>%customMinecraftAppPath%
    timeout 2 >nul
    exit /b 0
)

if not exist "%oldMinecraftVersion%" (echo !CURRENTVERSION!>"%oldMinecraftVersion%") else (set /p OLDVERSION=<"%oldMinecraftVersion%")
echo %hideCursor%>nul

timeout 2 > NUL