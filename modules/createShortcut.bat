:: Made possible thanks to https://medium.com/@dbilanoski/how-to-tuesdays-shortcuts-with-powershell-how-to-make-customize-and-point-them-to-places-1ee528af2763

@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
set "status_shortcut="
if [%1] equ [all] (call :copyshortcut all & goto :EOF)
if [%1] equ [deleteallshortcuts] (call :deleteallshortcuts & goto :EOF)
:createShortcut_main
cls
echo !RED!^< [B] Back!RST!
echo.
echo [1] Add/remove shortcut to desktop
echo [2] Add/remove Start menu entry
echo.
echo [0] Add/remove all shortcuts
echo.
if defined status_shortcut (echo %status_shortcut%) else (echo.)
echo.
echo !YLW!Press corresponding key to confirm your choice...!RST!
echo.
choice /c 120b /n >nul

if %errorlevel% equ 1 call :copyshortcut "%USERPROFILE%\Desktop\Matject.lnk" & goto createShortcut_main
if %errorlevel% equ 2 call :copyshortcut "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Matject.lnk" & goto createShortcut_main
if %errorlevel% equ 3 call :copyshortcut all & goto createShortcut_main
if %errorlevel% equ 4 goto :EOF

:copyshortcut
if not exist ".settings\matject_icon.ico" call "modules\createIcon"
if not exist ".settings\Matject.lnk" call :createShortcut "%cd%\.settings\Matject.lnk"
if [%1] equ [all] (
    if exist "%USERPROFILE%\Desktop\Matject.lnk" call :deleteallshortcuts & goto :EOF
    if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Matject.lnk" call :deleteallshortcuts & goto :EOF
    for %%D in ("%USERPROFILE%\Desktop" "%APPDATA%\Microsoft\Windows\Start Menu\Programs") do (
        copy /d .settings\Matject.lnk %%D >nul
    )
    set "status_shortcut=!GRN![*] Shortcuts added to desktop and start menu.!RST!"
    goto :EOF
)
if not exist %1 (
    copy /d ".settings\Matject.lnk" %1 >nul
    set "status_shortcut=!GRN![*] Shortcut added: %1.!RST!"
) else (
    del /q %1 >nul
    set "status_shortcut=!RED![*] Shortcut removed: %1.!RST!"
)
goto :EOF

:createShortcut
echo !YLW!!BLINK![*] Creating shortcut...!RST!
if not defined chcp_failed (chcp %chcp_default% >nul 2>&1)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%1'); $s.TargetPath = '%cd%\matject.bat'; $s.Arguments = 'placebo' ; $s.IconLocation = '%cd%\.settings\matject_icon.ico'; $s.Save()"
if not defined chcp_failed (chcp 65001 >nul 2>&1)
goto :EOF

:deleteallshortcuts
for %%F in ("%USERPROFILE%\Desktop\Matject.lnk" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Matject.lnk") do (
    del /q %%F >nul 2>&1
)
if exist ".settings\matject_icon.ico" del /q ".\.settings\matject_icon.ico" >nul
if exist ".settings\Matject.lnk" del /q ".\.settings\Matject.lnk" >nul
set "status_shortcut=!RED![*] All shortcuts removed.!RST!"
goto :EOF