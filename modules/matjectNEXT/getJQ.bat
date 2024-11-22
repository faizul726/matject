@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

echo !YLW![*] matjectNEXT needs jq by @jqlang to process Minecraft JSON files.!RST!
echo.

echo !RED!IT WILL NOT WORK AT ALL WITHOUT JQ.!RST!
echo.
echo.
echo %PROCESSOR_ARCHITECTURE%

echo !YLW![?] How would you like to get it?!RST!
echo.

echo [1] Download for me
echo [2] Nah, I will download it myself
echo.

choice /c 12b /n

goto option-!errorlevel!

:option-1
cls 
echo [*] You can take a look from line 22 of getJQ.bat if you want to know how it actually downloads...
echo.
echo !YLW![*] If you're fine with that you can press [Y] to download or [B] to exit.!RST!
echo.
choice /c yb /n
if !errorlevel! neq 1 exit
echo.
echo !YLW![*] Downloading...!RST!
echo.

if "%PROCESSOR_ARCHITECTURE%" equ "AMD64" (
    powershell -Command "Invoke-WebRequest https://github.com/jqlang/jq/releases/latest/download/jq-windows-amd64.exe -OutFile modules\jq.exe"
) else (
    if "%PROCESSOR_ARCHITECTURE%" equ "x86" (
        powershell -Command "Invoke-WebRequest https://github.com/jqlang/jq/releases/latest/download/jq-windows-i386.exe -OutFile modules\jq.exe"
    )
)

if exist "modules\jq.exe" (echo !GRN![*] Downloaded.!RST!) else (echo !RED![*] Download FAILED.!RST! && echo Press any key to close... && pause > NUL && exit)
echo.
pause && goto:EOF


:option-2
cls
echo !RED![^^!] Make sure to download matching your architecture. ^(AMD64 = 64 bit, i386 = 32 bit^)!RST!
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
