@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

cls
if "%PROCESSOR_ARCHITECTURE%" neq "AMD64" (
    echo !RED![^^!] Unfortunately, your PC is running a 32-bit ^(x86^) / ARM Windows.
    echo Since material-updater has no x86/ARM support, you can't enable this option.!RST!
    echo.

    echo Press any key to go back...
    pause > NUL
    goto:EOF
)
echo !RED!^< [B] Back!RST!
echo.

echo material-updater is a tool made by @mcbegamerxx954.
echo It allows you to update outdated materials to support latest version ^(or desired version^).
echo.

echo Matject doesn't include it out of box.
echo You have to download the executable and put it in the !CYN!modules!RST! folder named as !CYN!material-updater!RST! to use it...
echo.

echo !YLW![?] How would you like to get it?!RST!
echo.

echo [1] Download for me
echo [2] Nah, I will download it myself
echo.

choice /c 12b /n

goto option-!errorlevel!

:option-1
cls
echo [*] You can take a look from line 36 of getMaterialUpdater.bat if you want to know how it actually downloads...
echo.

echo !YLW![*] If you're fine with that you can press [Y] to download or [B] to go back.!RST!
echo.
choice /c yb /n
if !errorlevel! neq 1 goto:EOF
echo.

if not exist "tmp\" mkdir tmp
echo !YLW![*] Downloading...!RST!
powershell -NoProfile -Command "Invoke-WebRequest https://github.com/mcbegamerxx954/material-updater/releases/latest/download/material-updater-x86_64-pc-windows-msvc.zip -OutFile tmp/material-updater-x86_64-pc-windows-msvc.zip ; Expand-Archive -Force tmp/material-updater-x86_64-pc-windows-msvc.zip 'modules'" && if not exist %thanksMcbegamerxx954% (echo github.com/mcbegamerxx954/material-updater > %thanksMcbegamerxx954%)
rmdir tmp /q /s
echo.
if exist "modules\material-updater.exe" (echo !GRN![*] Downloaded to "modules\material-updater.exe"!RST!) else (echo !RED![*] Download FAILED.!RST! && echo Press any key to go back... && pause > NUL && goto:EOF)
echo.
pause && goto:EOF


:option-2
cls
echo [^^!] Make sure to download !CYN!material-updater-x86_64-pc-windows-msvc.zip!RST! and extract !CYN!material-updater.exe!RST! to !CYN!modules!RST! folder.
echo.

echo [*] Click any key to open !CYN!github.com/mcbegamerxx954/material-updater/releases/latest!RST! in browser.
echo     Or you can close this window if you want.
pause > NUL
start https://github.com/mcbegamerxx954/material-updater/releases/latest
echo.

echo !YLW![*] When done, press any key to continue....!RST!
pause > NUL
echo.

if not exist "modules\material-updater.exe" (echo !RED![^^!] material-updater.exe not found.!RST! && echo. && echo Press any key to go back... && pause > NUL)


:option-3
goto:EOF