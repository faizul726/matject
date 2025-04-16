:: getMinecraftDetails.bat // Made by github.com/faizul726
@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k
if "[%~1]" equ "[failure]" (
    echo !YLW!!BLINK![*] Automatically getting Minecraft%preview% details...!RST!
    set "MCLOCATION="
    set "CURRENTVERSION="
) else (
    echo !YLW!!BLINK![*] Getting Minecraft%preview% details...!RST!
)

if not exist "%disableTips%" (
    if not exist "%customMinecraftAppPath%" (
        echo.
        echo !GRN![TIP]!RST! You can make getting details faster by enabling "Use custom Minecraft app path"
    )
)

if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
:: PowerShell command by @FlaredRoverCodes
set "MCLOCATION="
set "CURRENTVERSION="
for /f "tokens=1,2 delims=///" %%i in ('powershell -NoProfile -Command "(Get-AppxPackage -Name Microsoft.%productID%).InstallLocation + '///' + (Get-AppxPackage -Name Microsoft.%productID%).Version"') do (
    set MCLOCATION=%%i
    set CURRENTVERSION=%%j
)
echo.
if not defined chcp_failed (>nul 2>&1 chcp 65001)

if not defined MCLOCATION (
    echo !ERR![^^!] Minecraft%preview% is not installed.!RST!
    echo.
    if defined isPreview (
        echo !YLW![*] Disabled "Use for Minecraft Preview" to allow normal access to Matject.!RST!
        del /q ".\%useForMinecraftPreview%" >nul
    )
    %exitmsg%
)

echo !WHT!Minecraft%preview% location:!RST! !MCLOCATION!
echo !WHT!Minecraft%preview% version:!RST!  v!CURRENTVERSION!

if "[%~1]" equ "[savepath]" (
    echo !MCLOCATION!>%customMinecraftAppPath%
    timeout 2 >nul
    exit /b 0
)

if not exist "%oldMinecraftVersion%" (echo !CURRENTVERSION!>"%oldMinecraftVersion%") else (set /p OLDVERSION=<"%oldMinecraftVersion%")
echo %hideCursor%>nul

if "[%~1]" neq "[failure]" (timeout 2 > NUL)