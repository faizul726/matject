:: Made possible thanks to https://medium.com/@dbilanoski/how-to-tuesdays-shortcuts-with-powershell-how-to-make-customize-and-point-them-to-places-1ee528af2763
:: createShortcut.bat // Made by github.com/faizul726

@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k
set "status_shortcut="
if "[%~1]" equ "[all]" (call :copyshortcut all & goto :EOF)
if "[%~1]" equ "[deleteallshortcuts]" (call :deleteallshortcuts & goto :EOF)
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
if exist "%preferWtShortcut%" (
    echo !GRY![*] Windows Terminal will be preferred for shortcuts.!RST!
) else (
    echo !GRY![*] Command Prompt will be preferred for shortcuts.!RST!
)
if not exist "%disableTips%" (
    echo.
    echo !GRN![TIP]!RST! You can change preferred app for shortcuts in Maject Settings.
)
echo.
echo !YLW!Press corresponding key to confirm your choice...!RST!
echo.
choice /c 120b /n >nul

if %errorlevel% equ 1 call :copyshortcut "%USERPROFILE%\Desktop\Matject.lnk" & goto createShortcut_main
if %errorlevel% equ 2 call :copyshortcut "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Matject.lnk" & goto createShortcut_main
if %errorlevel% equ 3 call :copyshortcut all & goto createShortcut_main
if %errorlevel% equ 4 (
    set "status_shortcut="
    goto :EOF
)

:copyshortcut
if "[%~1]" equ "[]" goto :EOF
if "[%~1]" equ "[]" goto :EOF
if not exist ".settings\matject_icon.ico" (
    if exist ".settings\Matject.lnk" (call :deleteallshortcuts & goto :EOF)
    call "modules\createIcon"
) else (
    if "[%~1]" equ "[all]" (call :deleteallshortcuts & goto :EOF)
)
if not exist ".settings\Matject.lnk" (call :createShortcut) else (
    if "[%~1]" equ "[all]" (call :deleteallshortcuts & goto :EOF)
)
if "[%~1]" equ "[all]" (
    if exist "%USERPROFILE%\Desktop\Matject.lnk" call :deleteallshortcuts & goto :EOF
    if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Matject.lnk" call :deleteallshortcuts & goto :EOF
    for %%D in ("%USERPROFILE%\Desktop" "%APPDATA%\Microsoft\Windows\Start Menu\Programs") do (
        copy /d .settings\Matject.lnk %%D >nul
    )
    set "status_shortcut=!GRN![*] Shortcuts have been added to desktop and start menu.!RST!"
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
echo:

if "[%~1]" equ "[all]" (
    >nul 2>&1 where wt && (
        echo !YLW![?] Which one the shortcut should use to open Matject?!RST!
        echo:
        echo !GRN![1] Windows Terminal!RST!
        echo     Looks modern and beautiful, Windows 11-like UI.
        echo:
        echo !RED![2] Command Prompt!RST!
        echo     Looks ancient. Maybe you love old things?
        echo:
        echo !GRY!Note: Both are the same except for how they look.!RST!

        if not exist "%disableTips%" (
            echo:
            !GRN![TIP]!RST! You can change this in Matject Settings anytime.
        )

        choice /c yn /n >nul
        if !errorlevel! equ 1 (
            echo Windows users when they see terminal a terminal: *sweats* [%date% // %time:~0,-6%]>"%preferWtShortcut%"
        ) else (
            if exist "%preferWtShortcut%" del /q ".\%preferWtShortcut%" >nul
        )
    )
)



if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)

if exist "%preferWtShortcut%" (
    >nul 2>&1 where wt && (
        for /f "tokens=*" %%W in ('where wt') do (
            set "TargetPath=%%W"
        )
        set "cmd_placebo=cmd "
    ) || (
        set "TargetPath=cmd"
        set "cmd_placebo="
    )
) else (
    set "TargetPath=cmd"
    set "cmd_placebo="
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
$ws = New-Object -ComObject WScript.Shell; ^
$s = $ws.CreateShortcut('.settings\Matject.lnk'); ^
$s.TargetPath = '\"' + \"!TargetPath!\" + '\"'; ^
$s.Arguments = '!cmd_placebo!/k \"' + \"$PWD\matject.bat\" + '\" fromshortcut'; ^
$s.IconLocation = \"%cd%\.settings\matject_icon.ico\"; ^
$s.Description = 'A material replacer for Minecraft Bedrock Edition.'; ^
$s.Save()
set "TargetPath="
if not defined chcp_failed (>nul 2>&1 chcp 65001)
goto :EOF

:deleteallshortcuts
for %%F in ("%USERPROFILE%\Desktop\Matject.lnk" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Matject.lnk") do (
    del /q %%F >nul 2>&1
)
if exist ".settings\matject_icon.ico" del /q ".\.settings\matject_icon.ico" >nul
if exist ".settings\Matject.lnk" del /q ".\.settings\Matject.lnk" >nul
set "status_shortcut=!RED![*] All shortcuts have been removed.!RST!"
goto :EOF