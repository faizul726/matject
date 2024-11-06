@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

echo !YLW![*] Updating materials using material-updater... [BETA]!RST!
echo.

:askVer
if not exist %materialUpdaterArg% (
    echo !YLW![?] Which is your Minecraft version?!RST!
    echo !WHT!
    echo [1] v1.21.20+
    echo [2] v1.20.80 - v1.21.2
    echo [3] v1.19.60 - v1.20.73
    echo [4] v1.18.30 - v1.19.51
    echo !RST!
    choice /c 1234 /n
    if "!errorlevel!" equ "1" echo v1-21-20>%materialUpdaterArg%
    if "!errorlevel!" equ "2" echo v1-20-80>%materialUpdaterArg%
    if "!errorlevel!" equ "3" echo v1-19-60>%materialUpdaterArg%
    if "!errorlevel!" equ "4" echo v1-18-30>%materialUpdaterArg%
    goto askVer
) else set /p targetVer=<%materialUpdaterArg%

if "%targetVer%" equ "v1-21-20" echo !YLW![*] Updating for v1.21.20+!RST!
if "%targetVer%" equ "v1-20-80" echo !YLW![*] Updating for v1.20.80 - v1.21.2!RST!
if "%targetVer%" equ "v1-19-60" echo !YLW![*] Updating for v1.19.60 - v1.20.73!RST!
if "%targetVer%" equ "v1-18-30" echo !YLW![*] Updating for v1.18.30 - v1.19.51!RST!
echo.
for %%m in ("MATERIALS\*.material.bin") do ("modules\material-updater" "%%m" -o "%%m" -t !targetVer!)
echo.
echo !GRN![*] Materials updated to support current version!RST!