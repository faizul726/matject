:: getJQ.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

echo !YLW![*] matjectNEXT needs jq by @jqlang to process Minecraft JSON files.!RST!
echo.

echo !RED!IT WILL NOT WORK AT ALL WITHOUT JQ.!RST!
echo.
echo.

echo !YLW![?] How would you like to get jq?!RST!
echo.

echo !RED![1] Download for me!RST!
echo !GRN![2] Nah, I will download it myself!RST!
echo.

choice /c 12b /n >nul

goto option-!errorlevel!

:option-1
cls 
echo [*] You can take a look from line 22 of getJQ.bat if you want to know how it actually downloads...
echo.
echo !YLW![*] If you're fine with that you can press [Y] to download or [B] to go back.!RST!
echo.
choice /c yb /n >nul
if !errorlevel! neq 1 exit
echo.
echo !YLW!!BLINK![*] Downloading jq...!RST!
echo.

if /i "%PROCESSOR_ARCHITECTURE%" equ "AMD64" (
    where curl >nul 2>&1
    if !errorlevel! equ 0 (
        curl -L -o modules/jq.exe https://github.com/jqlang/jq/releases/latest/download/jq-windows-amd64.exe >nul
    ) else (
        if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
        powershell -NoProfile -Command "Invoke-WebRequest https://github.com/jqlang/jq/releases/latest/download/jq-windows-amd64.exe -OutFile modules\jq.exe"
        if not defined chcp_failed (>nul 2>&1 chcp 65001)
    )
) else if /i "%PROCESSOR_ARCHITECTURE%" equ "x86" (
    where curl >nul 2>&1
    if !errorlevel! equ 0 (
        curl -L -o modules/jq.exe https://github.com/jqlang/jq/releases/latest/download/jq-windows-i386.exe >nul
    ) else (
        if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
        powershell -NoProfile -Command "Invoke-WebRequest https://github.com/jqlang/jq/releases/latest/download/jq-windows-i386.exe -OutFile modules\jq.exe"
        if not defined chcp_failed (>nul 2>&1 chcp 65001)
    )
) else (
    echo !RED![^^!] Unknown PROCESSOR_ARCHITECTURE: %PROCESSOR_ARCHITECTURE%. Maybe ARM based PC?!RST!
    %exitmsg%
)

echo.
if exist "modules\jq.exe" (echo !GRN![*] Downloaded to "modules\jq.exe"!RST!) else (echo !RED![*] Download FAILED.!RST! && echo Press any key to close... && pause > NUL && exit)
echo.
pause && goto:EOF


:option-2
cls
echo Processor architecture: %PROCESSOR_ARCHITECTURE%
echo.
echo !RED![^^!] Make sure to download matching your architecture. ^(AMD64 = amd64, x86 = i386^)!RST!
echo     !RED!Place it in "!WHT!%cd%\modules!RED!" named as !YLW!jq.exe!RST!
echo.

echo [*] Click any key to open !CYN!jqlang.github.io/jq/download!RST! in browser.
echo     Or you can close this window if you want.
pause > NUL
start https://jqlang.github.io/jq/download/
echo.

echo !YLW![*] When done, press any key to continue....!RST!
pause > NUL
echo.

if not exist "modules\jq.exe" (echo !RED![^^!] jq.exe not found.!RST! && echo. && echo Press any key to close... && pause > NUL && exit)
