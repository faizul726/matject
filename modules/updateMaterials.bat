@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k

:askVer
if not exist %materialUpdaterArg% (
    echo !YLW![?] material-updater: Which is your Minecraft version?!RST!
    echo !WHT!
    echo [1] v1.21.20+
    echo [2] v1.20.80 - v1.21.2
    echo [3] v1.19.60 - v1.20.73
    echo [4] v1.18.30 - v1.19.51
    echo !RST!
    choice /c 1234 /n >nul
    if "!errorlevel!" equ "1" echo v1-21-20>%materialUpdaterArg%
    if "!errorlevel!" equ "2" echo v1-20-80>%materialUpdaterArg%
    if "!errorlevel!" equ "3" echo v1-19-60>%materialUpdaterArg%
    if "!errorlevel!" equ "4" echo v1-18-30>%materialUpdaterArg%
    goto askVer
) else (
    set /p targetVer=<%materialUpdaterArg%
    echo %hideCursor%>nul
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
echo !YLW![*] material-updater: Updating for %~1!RST!
goto :EOF