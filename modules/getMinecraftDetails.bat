:: getMinecraftDetails.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

if "[%~1]" equ "[failure]" (
    echo !YLW!!BLINK![*] Automatically getting Minecraft%preview% details...!RST!
    set "MCLOCATION="
    set "CURRENTVERSION="
) else (
    echo !YLW!!BLINK![*] Getting Minecraft%preview% details...!RST!
)

if not defined mt_hideTips (
    if not defined mt_customMinecraftAppPath (
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
        del /q /f ".\%useForMinecraftPreview%" >nul
    ) else (
        echo !YLW![?] Do you want to use Matject for Minecraft Preview instead?
        echo.
        echo !GRN![Y] Yes    !RED![N] No!RST!
        choice /c ynb /n >nul
        if !errorlevel! equ 1 (
            break>"%useForMinecraftPreview%"
            cls
            echo !YLW![^^!] Target app changed.
            echo     Relaunch to take effect...!RST!
            %relaunchmsg%
        )
    )
    %exitmsg%
)

echo !WHT!Minecraft%preview% location:!RST! !MCLOCATION!
echo !WHT!Minecraft%preview% version:!RST!  v!CURRENTVERSION!

if "[%~1]" equ "[failure]" (
    call "modules\settingsV3" set mt_customMinecraftAppPath "!MCLOCATION!"
)

if "[%~1]" equ "[savepath]" (
    call "modules\settingsV3" set mt_customMinecraftAppPath "!MCLOCATION!"
    timeout 2 >nul
    exit /b 0
)

rem if not exist "%oldMinecraftVersion%" (echo !CURRENTVERSION!>"%oldMinecraftVersion%") else (set /p OLDVERSION=<"%oldMinecraftVersion%")
if defined mt_oldMinecraftVersion (
    set "OLDVERSION=!mt_oldMinecraftVersion!"
) else (
    call "modules\settingsV3" set mt_oldMinecraftVersion "!CURRENTVERSION!"
    call "modules\settingsV3"
)
echo %hideCursor%>nul

timeout 2 > NUL