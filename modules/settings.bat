@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

set "toggleOff=!GRY![ ]!RST!"
set "toggleOn=!GRN![x]!RST!"

title %title% Settings

:settings
cls


set "toggleone=!RED![None]!GRY!  /  Auto  /  Manual!RST!"
set toggle1=!toggleOff!
if exist %useAutoAlways% set "toggle1=!toggleOn!" && set "toggleone=!GRY! None   / !GRN![Auto]!GRY! /  Manual!RST!"
if exist %useManualAlways% set "toggle1=!toggleOn!" && set "toggleone=!GRY! None   /  Auto  / !BLU![Manual]!RST!"

if exist %thanksMcbegamerxx954% (
    if not exist "modules\material-updater.exe" (
        del /q /s %thanksMcbegamerxx954%
        set toggle2=!toggleOff!
    ) else set "toggle2=!toggleOn!"
) else set "toggle2=!toggleOff!"

if exist %disableConfirmation% (set toggle3=!toggleOn!) else (set toggle3=!toggleOff!)
if exist %disableInterruptionCheck% (set toggle4=!toggleOn!) else (set toggle4=!toggleOff!)
if exist %disableRetainOldBackups% (set toggle5=!toggleOn!) else (set toggle5=!toggleOff!)
if exist %disableSuccessMsg% (set toggle6=!toggleOn!) else (set "toggle6=!toggleOff!")
if exist %autoOpenMCPACK% (set toggle7=!toggleOn!) else (set "toggle7=!toggleOFF!")
if exist %customMinecraftPath% (set toggle8=1) else (set "toggle8=")
if exist ".settings\debugMode.txt" (set toggle10=!RED![ON]!RST!) else (set toggle10=!GRN![OFF]!RST!)
echo !RED!^< [B] Back!RST!
echo.
echo.

echo !YLW!Here you can change how Matject works.!RST! !RED!EPILEPSY WARNING!RST!
echo.
echo.

echo !toggle1! 1. Default method: %toggleone%
echo !toggle2! 2. Use material-updater to update materials ^(fixes invisible blocks^)
echo !toggle3! 3. Disable confirmation
echo !toggle4! 4. Disable interruption check ^(doesn't work for now^)
echo !toggle5! 5. Don't keep old backups
echo !toggle6! 6. Disable success message
echo !toggle7! 7. Auto import MCPACK after injection ^(only works for .mcpack files^)
echo.

if not defined toggle8 (
    echo !toggleOff! 8. Use custom Minecraft app path ^(makes Matject start faster^) 
) else (
    echo !toggleOn! 8. Use custom Minecraft app path
)

echo !toggleOff! 9. Use custom Minecraft data path ^(doesn't work for now^)
echo !toggleOff! 0. Use custom IObit Unlocker path ^(doesn't work for now^)
echo !toggleOff! U. Check for updates at startup ^(WIP^)
echo.
echo !GRY![D] DEBUG MODE ^(does nothing for now^) !toggle10!!RST!
echo.
echo.
echo !YLW!Press corresponding key to toggle desired option.!RST!
echo.
choice /c 1234567890bd /n

goto toggle!errorlevel!

:toggle1
if not exist %useAutoAlways% (
    if not exist %useManualAlways% (
        echo.>%useAutoAlways%
        goto settings
    ) else (
        del /q /s %useManualAlways% > NUL
        goto settings
    )
) else (
    del /q /s %useAutoAlways% > NUL
    if not exist %useManualAlways% (
        echo.>%useManualAlways%
        goto settings
    ) else (
        del /q /s %useManualAlways% > NUL
        goto settings
    )
)

goto settings


:toggle2
if exist %thanksMcbegamerxx954% (del /q /s %thanksMcbegamerxx954% > NUL && goto settings) 
if not exist "modules\material-updater.exe" (call "modules\getMaterialUpdater") else (if not exist %thanksMcbegamerxx954% (echo. > %thanksMcbegamerxx954%))
goto settings

:toggle3
if not exist %disableConfirmation% (echo.>%disableConfirmation%) else (del /q /s %disableConfirmation% > NUL)
goto settings

:toggle4
if not exist %disableInterruptionCheck% (echo.>%disableInterruptionCheck%) else (del /q /s %disableInterruptionCheck% > NUL)
goto settings

:toggle5
if not exist %disableRetainOldBackups% (echo.>%disableRetainOldBackups%) else (del /q /s %disableRetainOldBackups% > NUL)
goto settings

:toggle6
if not exist %disableSuccessMsg% (echo.>%disableSuccessMsg%) else (del /q /s %disableSuccessMsg% > NUL)
goto settings

:toggle7
if not exist %autoOpenMCPACK% (echo.>%autoOpenMCPACK%) else (del /q /s %autoOpenMCPACK% > NUL)
goto settings

:toggle8
if defined toggle8 (
    del /q /s %customMinecraftPath% > NUL
    goto settings
)
cls
set setCustomMinecraftPath=
echo !RED!^< [B] Back!RST!
echo.
echo.

echo !YLW![?] How would you like to set custom Minecraft path?!RST!
echo.
echo.

echo [1] Use retrieved Minecraft path ^(!GRN!!MCLOCATION!!RST!!^)
echo [2] Use user provided Minecraft path
echo.
choice /c b12 /n

if !errorlevel! equ 1 goto settings

if !errorlevel! equ 2 (
    echo !MCLOCATION!>%customMinecraftPath%
    goto settings
)
if !errorlevel! equ 3 (
    cls
    set /p "setCustomMinecraftPath=!YLW![*] Type your custom Minecraft path ^(make sure not to include unnecessary space. Leave blank to cancel^):!RST! "
    echo.
    if not defined setCustomMinecraftPath (
        goto settings
    ) else (
        if exist "!setCustomMinecraftPath!\AppxManifest.xml" (
            if exist "!setCustomMinecraftPath!\Minecraft.Windows.exe" (
                echo !setCustomMinecraftPath!>%customMinecraftPath%
                goto settings
            )
        )
    )
)
echo !ERR![^^!] Invalid Minecraft path.!RST!
%backmsg:~0,56%
goto settings

:toggle9
:toggle10
goto settings

:toggle11
goto:EOF

:toggle12
if not exist ".settings\debugMode.txt" (echo You are now a developer^^! [%date% - %time%]>".settings\debugMode.txt" && set debugMode=1) else (del /q /s ".settings\debugMode.txt" > NUL && set debugMode=)
goto settings
