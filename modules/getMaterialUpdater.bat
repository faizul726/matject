:: Made possible thanks to github.com/mcbegamerxx954 (creator of draco and mbl2)
:: getMaterialUpdater.bat // Made by github.com/faizul726

@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k

cls
if "%PROCESSOR_ARCHITECTURE%" neq "AMD64" (
    echo !RED![^^!] Unfortunately, your PC is running 32-bit ^(x86^) / ARM Windows.
    echo Since material-updater has no x86/ARM support, you can't enable this option.!RST!
    echo.

    echo Press any key to go back...
    pause > NUL
    goto:EOF
)
if "[%~1]" equ "[skip_intro]" (goto skip_intro_material-updater)
echo !RED!^< [B] Back!RST!
echo.
if "[%~1]" equ "[skip_intro_settings]" (goto skip_intro_material-updater)

echo material-updater is a tool made by @mcbegamerxx954.
echo It allows you to update outdated materials to support latest version ^(or desired version^).
echo.

echo Matject doesn't include it out of box.
echo You have to download the executable and put it in the !CYN!modules!RST! folder named as !CYN!material-updater!RST! to use it...
echo.
:skip_intro_material-updater
echo !YLW![?] How would you like to get material-updater?!RST!
echo.

echo !RED![1] Download for me!RST!
echo !GRN![2] Nah, I will download it myself!RST!
echo.

choice /c 12b /n >nul

goto option-!errorlevel!

:option-1
cls
echo [*] You can take a look from line 37 of getMaterialUpdater.bat if you want to know how it actually downloads...
echo.

echo !YLW![*] If you're fine with that you can press [Y] to download or [B] to go back.!RST!
echo.
choice /c yb /n >nul
if !errorlevel! neq 1 goto:EOF
echo.

if not exist "tmp\" mkdir tmp
if exist ".\modules\material-updater.exe" (
    del /q /f ".\modules\material-updater.exe" >nul
)
echo !YLW!!BLINK![*] Downloading material-updater...!RST!
where curl >nul 2>&1
if !errorlevel! equ 0 (
    curl -L -o tmp\material-updater-x86_64-pc-windows-msvc.zip https://github.com/mcbegamerxx954/material-updater/releases/latest/download/material-updater-x86_64-pc-windows-msvc.zip >nul
    if exist "%SYSTEMROOT%\system32\%tarexe%" (
        tar -xf "tmp\material-updater-x86_64-pc-windows-msvc.zip" -C "modules" && if not exist %thanksMcbegamerxx954% (echo github.com/mcbegamerxx954/material-updater>%thanksMcbegamerxx954%)
    ) else (
        if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
        powershell -NoProfile -Command "Expand-Archive -Force tmp/material-updater-x86_64-pc-windows-msvc.zip 'modules'" && if not exist %thanksMcbegamerxx954% (echo github.com/mcbegamerxx954/material-updater>%thanksMcbegamerxx954%)
        if not defined chcp_failed (>nul 2>&1 chcp 65001)
    )
) else (
    if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
    powershell -NoProfile -Command "Invoke-WebRequest https://github.com/mcbegamerxx954/material-updater/releases/latest/download/material-updater-x86_64-pc-windows-msvc.zip -OutFile tmp/material-updater-x86_64-pc-windows-msvc.zip ; Expand-Archive -Force tmp/material-updater-x86_64-pc-windows-msvc.zip 'modules'" && if not exist %thanksMcbegamerxx954% (echo github.com/mcbegamerxx954/material-updater>%thanksMcbegamerxx954%)
    if not defined chcp_failed (>nul 2>&1 chcp 65001)
)
rmdir /q /s ".\tmp"
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