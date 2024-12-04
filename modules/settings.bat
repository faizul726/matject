@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

set "toggleOff=!GRY![ ]!RST!"
set "toggleOn=!GRN![x]!RST!"

title %title% settings

:settingsP1
cls


if not exist %defaultMethod% (
    set "toggleone=!RED![None]!GRY! /  Auto  /  Manual  /  matjectNEXT!RST!"
    set toggleP1_1=!toggleOff!
    set "selectedMethod="
) else (
    set "toggleP1_1=!toggleOn!"
    set /p selectedMethod=<%defaultMethod%
    if "!selectedMethod!" equ "Auto" set "toggleone=!GRY! None  / !GRN![Auto]!GRY! /  Manual  /  matjectNEXT!RST!"
    if "!selectedMethod!" equ "Manual" set "toggleone=!GRY! None  /  Auto  / !BLU![Manual]!GRY! /  matjectNEXT!RST!"
    if "!selectedMethod!" equ "matjectNEXT" set "toggleone=!GRY! None  /  Auto  /  Manual  / !RED![matjectNEXT]!RST!"
)

if exist %thanksMcbegamerxx954% (
    if not exist "modules\material-updater.exe" (
        del /q /s %thanksMcbegamerxx954%
        set toggleP1_2=!toggleOff!
    ) else set "toggleP1_2=!toggleOn!"
) else set "toggleP1_2=!toggleOff!"

if exist %disableConfirmation% (set toggleP1_3=!toggleOn!) else (set toggleP1_3=!toggleOff!)
if exist %disableInterruptionCheck% (set toggleP1_4=!toggleOn!) else (set toggleP1_4=!toggleOff!)
if exist %disableRetainOldBackups% (set toggleP1_5=!toggleOn!) else (set toggleP1_5=!toggleOff!)
if exist %disableSuccessMsg% (set toggleP1_6=!toggleOn!) else (set "toggleP1_6=!toggleOff!")
if exist %autoOpenMCPACK% (set toggleP1_7=!toggleOn!) else (set "toggleP1_7=!toggleOFF!")
if exist %disableMatCompatCheck% (set toggleP1_8=!toggleOn!) else (set toggleP1_8=!toggleOff!)

echo !RED!^< [B] Back!RST! ^| !GRY!^< [A]!RST! !WHT![General]!GRY! /  Custom paths  /  matjectNEXT settings  /  Updates ^& Debug !RST! !YLW![D] ^>!RST! 
echo.
echo.

echo !WHT!Here you can change how Matject works.!RST!
echo.
echo.

echo !toggleP1_1! 1. Default method: %toggleone%
echo !toggleP1_2! 2. Use material-updater to update materials ^(fixes invisible blocks^)
echo !toggleP1_3! 3. Disable confirmations
echo !toggleP1_4! 4. Disable interruption check ^(doesn't work for now^)
echo !toggleP1_5! 5. Don't keep old backups
echo !toggleP1_6! 6. Disable success message
echo !toggleP1_7! 7. Auto import MCPACK after injection ^(only works for .mcpack files^)
echo !toggleP1_8! 8. Disable material compatibility check ^(this applies both to Matject ^& matjectNEXT^)
echo.
echo.
echo !YLW!Press corresponding key to toggle desired option... !RST!
echo.
choice /c 12345678bad /n

goto toggleP1_!errorlevel!

:toggleP1_1
if not defined selectedMethod (echo Auto>%defaultMethod%) else (
    if "!selectedMethod!" equ "Auto" echo Manual>%defaultMethod%
    if "!selectedMethod!" equ "Manual" echo matjectNEXT>%defaultMethod%
    if "!selectedMethod!" equ "matjectNEXT" del /q /s %defaultMethod% >nul
) 

goto settingsP1


:toggleP1_2
if exist %thanksMcbegamerxx954% (
    del /q /s %thanksMcbegamerxx954% > NUL
    if exist ".settings\materialUpdaterArg.txt" del /q /s ".settings\materialUpdaterArg.txt" >nul
    goto settingsP1
) 
if not exist "modules\material-updater.exe" (call "modules\getMaterialUpdater") else (if not exist %thanksMcbegamerxx954% (echo github.com/mcbegamerxx954/material-updater > %thanksMcbegamerxx954%))
goto settingsP1

:toggleP1_3
if not exist %disableConfirmation% (echo.>%disableConfirmation%) else (del /q /s %disableConfirmation% > NUL)
goto settingsP1

:toggleP1_4
if not exist %disableInterruptionCheck% (echo.>%disableInterruptionCheck%) else (del /q /s %disableInterruptionCheck% > NUL)
goto settingsP1

:toggleP1_5
if not exist %disableRetainOldBackups% (echo.>%disableRetainOldBackups%) else (del /q /s %disableRetainOldBackups% > NUL)
goto settingsP1

:toggleP1_6
if not exist %disableSuccessMsg% (echo.>%disableSuccessMsg%) else (del /q /s %disableSuccessMsg% > NUL)
goto settingsP1

:toggleP1_7
if not exist %autoOpenMCPACK% (echo.>%autoOpenMCPACK%) else (del /q /s %autoOpenMCPACK% > NUL)
goto settingsP1

:toggleP1_8
if not exist "%disableMatCompatCheck%" (echo.>%disableMatCompatCheck%) else (del /q /s %disableMatCompatCheck% >nul)
goto settingsP1

:toggleP1_9
exit /b 0

:toggleP1_10
goto settingsP1

:toggleP1_11
goto settingsP2



:settingsP2
cls

echo !RED!^< [B] Back!RST! ^| !YLW!^< [A]!RST! !GRY! General  / !WHT![Custom paths]!GRY! /  matjectNEXT settings  /  Updates ^& Debug !RST! !YLW![D] ^>!RST! 
echo.
echo.

echo !WHT!Here you can set paths to be used by Matject/matjectNEXT.!RST!
echo.
echo.

if exist %customMinecraftAppPath% (set toggleP2_1=!toggleOn!) else (set toggleP2_1=!toggleOff!)
if exist %customMinecraftDataPath% (set toggleP2_2=!toggleOn!) else (set toggleP2_2=!toggleOff!)
if exist %customUnlockerPath% (set toggleP2_3=!toggleOn!) else (set toggleP2_3=!toggleOff!)

echo !toggleP2_1! 1. Use custom Minecraft app path ^(makes Matject start faster^)
echo !toggleP2_2! 2. Use custom Minecraft data path ^(doesn't work for now^)
echo !toggleP2_3! 3. Use custom IObit Unlocker path ^(WIP^)
echo. 
echo.
echo.
echo.
echo.
echo.
echo.
echo !YLW!Press corresponding key to toggle desired option...!RST!
echo.
choice /c 123bad /n
goto toggleP2_!errorlevel!

:toggleP2_1
if exist "%customMinecraftAppPath%" (
    del /q /s %customMinecraftAppPath% > NUL
    goto settingsP2
)
cls
set setcustomMinecraftAppPath=
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

if !errorlevel! equ 1 goto settingsP2

if !errorlevel! equ 2 (
    echo !MCLOCATION!>%customMinecraftAppPath%
    goto settingsP2
)
if !errorlevel! equ 3 (
    cls
    set /p "setcustomMinecraftAppPath=!YLW![*] Type your custom Minecraft path ^(make sure not to include unnecessary space. Leave blank to cancel^):!RST! "
    echo.
    if not defined setcustomMinecraftAppPath (
        goto settingsP2
    ) else (
        if exist "!setcustomMinecraftAppPath!\AppxManifest.xml" (
            if exist "!setcustomMinecraftAppPath!\Minecraft.Windows.exe" (
                echo !setcustomMinecraftAppPath!>%customMinecraftAppPath%
                goto settingsP2
            )
        )
    )
)
echo !ERR![^^!] Invalid Minecraft path.!RST!
%backmsg:~0,56%
goto settingsP2

:toggleP2_2
:toggleP2_3
goto settingsP2

:toggleP2_4
exit /b 0

:toggleP2_5
goto settingsP1

:toggleP2_6
goto settingsP3

:: WIP START
cls
set /p "unlockerpath=!YLW!Enter custom IObit Unlocker path ^(leave empty to cancel^): "
if not exist "!unlockerpath!\IObitUnlocker.exe" (echo !ERR!Wrong folder.!RST! && %backmsg:~0,56%) else (!unlockerpath!)
goto settingsP1
:: WIP END



:settingsP3
cls
title matjectNEXT %version%%dev% settings

echo !RED!^< [B] Back!RST! ^| !YLW!^< [A]!RST! !GRY! General  /  Custom paths  / !WHT![matjectNEXT settings]!GRY! /  Updates ^& Debug !RST! !YLW![D] ^>!RST! 
echo.
echo.

if not defined debugMode (
    echo !YLW![^^!] Enable DEBUG MODE first.!RST!
    echo.
    choice /c ad /n
    
    if !errorlevel! equ 1 goto settingsP2
    if !errorlevel! equ 2 goto settingsP4
)

echo !WHT!Here you can change how matjectNEXT works.!RST!
echo.
echo.



if not exist "%syncThenExit%" (set "toggleP3_1=!toggleOn!") else (set "toggleP3_1=!toggleOff!")

echo !toggleP3_1! 1. Just sync and exit
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo !YLW!Press corresponding key to toggle desired option... !RST!
echo.
choice /c 1bad /n

goto toggleP3_!errorlevel!

:toggleP3_1
if not exist "%syncThenExit%" (echo.>"%syncThenExit%" ) else (del /q /s "%syncThenExit%" >nul)
goto settingsP3

:toggleP3_2
exit /b 0

:toggleP3_3
title %title% settings
goto settingsP2

:toggleP3_4
title %title% settings
goto settingsP4



:settingsP4
cls
echo !RED!^< [B] Back!RST! ^| !YLW!^< [A]!RST! !GRY! General  /  Custom paths  /  matjectNEXT settings  / !WHT![Updates ^& Debug]!RST! !GRY![D] ^>!RST! 
echo.
echo.

if exist %doCheckUpdates% (set toggleP4_1=!toggleOn!) else (set toggleP4_1=!toggleOff!)
if "%debugMode%" equ "true" (set toggleP4_2=!RED![ON]!RST!) else (set toggleP4_2=!GRY![OFF]!RST!)

echo !WHT!Here you can check for updates or enable in-development features.!RST!
echo.
echo.
echo !toggleP4_1! 1. Check for updates at Matject startup !RED!^(requires internet^)!RST!
echo.
echo.
echo [M] Check for updates manually !RED!^(requires internet^)!RST!
echo.
echo !GRY![0] DEBUG MODE ^(for testing matjectNEXT^)!RST! !toggleP4_2!
echo.
echo.
echo.
echo.
echo !YLW!Press corresponding key to toggle desired option... !RST!
echo.
choice /c 1m0bad /n

goto toggleP4_!errorlevel!

:toggleP4_1
if not exist %doCheckUpdates% (echo.>%doCheckUpdates%) else (del /q /s %doCheckUpdates% > NUL)
goto settingsP4

:toggleP4_2
call "modules\checkUpdates"
goto settingsP4

:toggleP4_3
if "%debugMode%" neq "true" (echo You are now a developer^^! [%date% - %time%]>".settings\debugMode.txt" && set "debugMode=true") else (del /q /s ".settings\debugMode.txt" > NUL && set "debugMode=")
goto settingsP4

:toggleP4_4
exit /b 0

:toggleP4_5
goto settingsP3

:toggleP4_6
goto settingsP4