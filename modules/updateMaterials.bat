:: Made possible thanks to...
:: github.com/mcbegamerxx954 (creator of draco and mbl2 and also material-updater)
:: github.com/ABUCKY0        (PS Installer Developer of BetterRTX)
:: github.com/jcau8          (Master plan giver o7)
:: https://stackoverflow.com/q/2143187
:: updateMaterials.bat // Made by github.com/faizul726

@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k

:askVer
set "IsAutoDetected="
if not exist "%materialUpdaterArg%" (
    if not defined isPreview (
        set "CURRENTVERSION_stripped=!CURRENTVERSION:.=!"
        set "CURRENTVERSION_stripped=!CURRENTVERSION_stripped: =!"
        set "CURRENTVERSION_trimmed=!CURRENTVERSION_stripped:~0,-3!"

        if "[!CURRENTVERSION_trimmed:~4,1!]" equ "[]" (
            set CURRENTVERSION_trimmed=%CURRENTVERSION_trimmed:~0,3%0%CURRENTVERSION_trimmed:~3%
        )
        if !CURRENTVERSION_trimmed! geq 11830 if !CURRENTVERSION_trimmed! lss 11960 (set targetVer=v1-18-30)
        if !CURRENTVERSION_trimmed! geq 11960 if !CURRENTVERSION_trimmed! lss 12080 (set targetVer=v1-19-60)
        if !CURRENTVERSION_trimmed! geq 12080 if !CURRENTVERSION_trimmed! lss 12120 (set targetVer=v1-20-80)
        if !CURRENTVERSION_trimmed! geq 12120 (set targetVer=v1-21-20)

        set "IsAutoDetected=true"
        set "CURRENTVERSION_trimmed="
        set "CURRENTVERSION_stripped="
    ) else (
        echo !YLW![?] material-updater: Which is your Minecraft Preview version?!RST!
        echo !WHT!
        echo [1] v1.21.20 or above
        echo [2] v1.20.80 - v1.21.2
        echo [3] v1.19.60 - v1.20.73
        echo [4] v1.18.30 - v1.19.51
        echo !RST!
        choice /c 1234 /n >nul
        if !errorlevel! equ 1 echo v1-21-20>%materialUpdaterArg%
        if !errorlevel! equ 2 echo v1-20-80>%materialUpdaterArg%
        if !errorlevel! equ 3 echo v1-19-60>%materialUpdaterArg%
        if !errorlevel! equ 4 echo v1-18-30>%materialUpdaterArg%
        goto askVer
    )
) else (
    set /p targetVer=<%materialUpdaterArg%
    if defined targetVer (
        set "targetVer=!targetVer: =!"
    ) else (
        set targetVer=null
    )
    
    echo %hideCursor%>nul
    if "!targetVer!" neq "v1-21-20" if "!targetVer!" neq "v1-20-80" if "!targetVer!" neq "v1-19-60" if "!targetVer!" neq "v1-18-30" (
        echo !RED![^^!] material-updater: "%materialUpdaterArg%" is invalid. Proceeding with v1-21-20...!RST!
        set "targetVer=v1-21-20"
    )
)

if "%targetVer%" equ "v1-21-20" call :updfor "v1.21.20+"
if "%targetVer%" equ "v1-20-80" call :updfor "v1.20.80 - v1.21.2"
if "%targetVer%" equ "v1-19-60" call :updfor "v1.19.60 - v1.20.73"
if "%targetVer%" equ "v1-18-30" call :updfor "v1.18.30 - v1.19.51"
echo.
for %%m in ("MATERIALS\*.material.bin") do ("modules\material-updater" "%%m" -o "%%m" -t !targetVer!)
echo.
echo !GRN![*] material-updater: Materials updated to support current version.!RST!
echo.
echo.
goto :EOF

:updfor
if defined IsAutoDetected (
    set "IsAutoDetected="
    echo !GRN![*] Automatically detected Minecraft version: %~1!RST!
    echo.
)
echo !YLW![*] material-updater: Updating for %~1!RST!
goto :EOF