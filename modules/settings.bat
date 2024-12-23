@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

set "toggleOff=!GRY![ ]!RST!"
set "toggleOn=!GRN![x]!RST!"

title %title% settings

if not "%1" equ "" goto %1

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
if exist %dontRetainOldBackups% (set toggleP1_4=!toggleOn!) else (set toggleP1_4=!toggleOff!)
if exist %disableSuccessMsg% (set toggleP1_5=!toggleOn!) else (set toggleP1_5=!toggleOff!)
if exist %autoOpenMCPACK% (set toggleP1_6=!toggleOn!) else (set toggleP1_6=!toggleOFF!)
if exist %dontOpenFolder% (set toggleP1_7=!toggleOn!) else (set toggleP1_7=!toggleOFF!)
if exist %useForMinecraftPreview% (set toggleP1_8=!toggleOn:GRN=RED!) else (set toggleP1_8=!toggleOff!)


echo !RED!^< [B] Back!RST! ^| !GRY!^< [A]!RST! !WHT![General]!GRY! /  Custom paths  /  matjectNEXT settings  /  Updates ^& Debug !RST! !YLW![D] ^>!RST! 
echo.
echo.

echo !WHT!Here you can change how Matject works.!RST!
echo.
echo.

echo !toggleP1_1! 1. Default method: %toggleone%
echo !toggleP1_2! 2. Use material-updater to update materials ^(fixes invisible blocks^)
echo !toggleP1_3! 3. Disable confirmations
echo !toggleP1_4! 4. Don't retain old backups
echo !toggleP1_5! 5. Disable success message ^(auto/manual^)
echo !toggleP1_6! 6. Auto import MCPACK after injection ^(auto only^)
echo !toggleP1_7! 7. Don't open folder automatically ^(auto/manual^)
echo !toggleP1_8! 8. Use for Minecraft Preview !RED![BETA]!RST!
echo.
echo.
echo !YLW!Press corresponding key to toggle desired option...!RST!
echo.
choice /c 12345678bad /n >nul

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
    if exist "%materialUpdaterArg%" del /q /s "%materialUpdaterArg%" >nul
    goto settingsP1
) 
if not exist "modules\material-updater.exe" (call "modules\getMaterialUpdater") else (if not exist %thanksMcbegamerxx954% (echo github.com/mcbegamerxx954/material-updater > %thanksMcbegamerxx954%))
goto settingsP1

:toggleP1_3
if not exist %disableConfirmation% (echo You are c21hcnQ= [%date% // %time:~0,-6%]>%disableConfirmation%) else (del /q /s %disableConfirmation% > NUL)
goto settingsP1

:toggleP1_4
if not exist %dontRetainOldBackups% (echo Just like old backups, you shouldn't overthink about your past. Improve yourself for future instead. [%date% // %time:~0,-6%]>%dontRetainOldBackups%) else (del /q /s %dontRetainOldBackups% > NUL)
goto settingsP1

:toggleP1_5
if not exist %disableSuccessMsg% (echo Thanks for using Matject, have a good day. [%date% // %time:~0,-6%]>%disableSuccessMsg%) else (del /q /s %disableSuccessMsg% > NUL)
goto settingsP1

:toggleP1_6
if not exist %autoOpenMCPACK% (echo You are lazy [%date% // %time:~0,-6%]>%autoOpenMCPACK%) else (del /q /s %autoOpenMCPACK% > NUL)
goto settingsP1

:toggleP1_7
if not exist %dontOpenFolder% (echo Opening folder seems slow innit? [%date% // %time:~0,-6%]>%dontOpenFolder%) else (del /q /s %dontOpenFolder% > NUL)
goto settingsP1

:toggleP1_8
if not exist %useForMinecraftPreview% (echo Deferred rendering is cool. [%date% // %time:~0,-6%]>%useForMinecraftPreview%) else (del /q /s %useForMinecraftPreview% >nul)
cls
echo !YLW![^^!] Target app changed.
echo     Relaunch to take effect...!RST!
%relaunchmsg%
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
if exist %customIObitUnlockerPath% (set toggleP2_3=!toggleOn!) else (set toggleP2_3=!toggleOff!)

echo !toggleP2_1! 1. Use custom Minecraft app path ^(makes Matject start faster^)
echo !toggleP2_2! 2. Use custom Minecraft data path ^(for Bedrock Launcher or similar^) !RED!^(USE WITH CARE^)!RST!
echo !toggleP2_3! 3. Use custom IObit Unlocker path
echo. 
echo !WHT!Current paths:!GRY!
echo Minecraft app:!GRY!  "!MCLOCATION:%ProgramFiles%=%WHT%%%ProgramFiles%%%GRY%!"
echo Minecraft data:!GRY! "!gameData:%LOCALAPPDATA%=%WHT%%%LOCALAPPDATA%%%GRY%!"
echo IObit Unlocker:!GRY! "!IObitUnlockerPath:%ProgramFiles(x86)%=%WHT%%%ProgramFiles(x86)%%%GRY%!"!RST!
echo.
echo.
echo !YLW!Press corresponding key to toggle desired option...!RST!
echo.
choice /c 123bad /n >nul
goto toggleP2_!errorlevel!

:toggleP2_1
if exist "%customMinecraftAppPath%" (
    del /q /s %customMinecraftAppPath% > NUL
    cls
    call "modules\getMinecraftDetails"
    goto settingsP2
)
cls
set "setcustomMinecraftAppPath="
echo !RED!^< [B] Back!RST!
echo.
echo.

echo !YLW![?] How would you like to set custom Minecraft path?!RST!
echo.
echo.

echo [1] Set automatically !GRY!^(Get-AppxPackage^)!RST!
echo [2] Set manually
echo.
choice /c b12 /n >nul

if !errorlevel! equ 1 goto settingsP2

if !errorlevel! equ 2 (
    cls
    call "modules\getMinecraftDetails" savepath
    goto settingsP2
)
if !errorlevel! equ 3 (
    cls
    echo.
    echo !YLW![*] Enter your custom Minecraft app path ^(make sure not to include unnecessary space. Leave blank to cancel^)!RST!
    echo.
    set /p "setcustomMinecraftAppPath=Custom Minecraft app path: "
    echo.
    if not defined setcustomMinecraftAppPath (
        goto settingsP2
    ) else (
        set "setcustomMinecraftAppPath=!setcustomMinecraftAppPath:"=!"
        set "setcustomMinecraftAppPath=!setcustomMinecraftAppPath:8wekyb3d8bbwe\=8wekyb3d8bbwe!"
        if exist "!setcustomMinecraftAppPath!\AppxManifest.xml" (
            if exist "!setcustomMinecraftAppPath!\Minecraft.Windows.exe" (
                echo !setcustomMinecraftAppPath!>%customMinecraftAppPath%
                goto settingsP2
            )
        )
    )
)
echo !ERR![^^!] Invalid Minecraft app path.!RST!
%backmsg:EOF=settingsP2%

:toggleP2_2
if exist "%customMinecraftDataPath%" (
    del /q /s %customMinecraftDataPath% > NUL
    set "gameData=!defaultGameData!"
    goto settingsP2
)
cls
set "setCustomMinecraftDataPath="
echo.
echo !YLW![*] Enter your custom Minecraft data ^(com.mojang folder^) path 
echo     ^(Make sure not to include unnecessary space. Leave blank to cancel.^)!RST!
echo.
set /p "setCustomMinecraftDataPath=Custom Minecraft data (com.mojang folder) path: "
echo.
if not defined setCustomMinecraftDataPath (goto settingsP2)
set "setCustomMinecraftDataPath=!setCustomMinecraftDataPath:"=!"
set "setCustomMinecraftDataPath=!setCustomMinecraftDataPath:com.mojang\=com.mojang!"
if exist "!setCustomMinecraftDataPath!\minecraftpe\options.txt" (
    echo !setCustomMinecraftDataPath!>%customMinecraftDataPath%
    goto settingsP2
)
echo !ERR![^^!] Invalid Minecraft data path.!RST!
%backmsg:EOF=settingsP2%


:toggleP2_3
if exist "%customIObitUnlockerPath%" (
    cls
    echo !YLW![^^!] Custom IObit Unlocker path removed.
    echo     Relaunch to take effect...!RST!
    del /q /s %customIObitUnlockerPath% > NUL
    %relaunchmsg%
)
cls
set "setCustomIObitUnlockerPath="
echo.
echo !YLW![*] Enter your custom IObit Unlocker folder path ^(make sure not to include unnecessary space. Leave blank to cancel^)!RST!
echo.
set /p "setCustomIObitUnlockerPath=IObit Unlocker path: "
echo.

if not defined setCustomIObitUnlockerPath (
    cls
    echo !YLW![^^!] Custom IObit Unlocker path not set.!RST!
    %exitmsg%
) else (
    set "setCustomIObitUnlockerPath=!setCustomIObitUnlockerPath:"=!"
    set "setCustomIObitUnlockerPath=!setCustomIObitUnlockerPath:IObit Unlocker\=IObit Unlocker!"
    if exist "!setCustomIObitUnlockerPath!\IObitUnlocker.exe" (
        if exist "!setCustomIObitUnlockerPath!\IObitUnlocker.dll" (
            cls
            echo !setCustomIObitUnlockerPath!>%customIObitUnlockerPath%
            echo !GRN![*] Custom IObit Unlocker path set.
            echo     Relaunch to take effect...!RST!
            %relaunchmsg%
        )
    )
)
cls
echo !ERR![^^!] Invalid IObit Unlocker path.!RST!
%exitmsg%

:toggleP2_4
exit /b 0

:toggleP2_5
goto settingsP1

:toggleP2_6
goto settingsP3



:settingsP3
cls
echo !RED!^< [B] Back!RST! ^| !YLW!^< [A]!RST! !GRY! General  /  Custom paths  / !WHT![matjectNEXT settings]!GRY! /  Updates ^& Debug !RST! !YLW![D] ^>!RST! 
echo.
echo.

echo !WHT!Here you can change how matjectNEXT works.!RST!
echo.
echo.



if exist "%syncThenExit%" (set "toggleP3_1=!toggleOn!") else (set "toggleP3_1=!toggleOff!")

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
echo !YLW!Press corresponding key to toggle desired option...!RST!
echo.
choice /c 1bad /n >nul

goto toggleP3_!errorlevel!

:toggleP3_1
if not exist "%syncThenExit%" (echo I hope matjectNEXT is doing its job properly. - Creator [%date% // %time:~0,-6%]>"%syncThenExit%" ) else (del /q /s "%syncThenExit%" >nul)
goto settingsP3

:toggleP3_2
exit /b 0

:toggleP3_3
goto settingsP2

:toggleP3_4
goto settingsP4



:settingsP4
cls
echo !RED!^< [B] Back!RST! ^| !YLW!^< [A]!RST! !GRY! General  /  Custom paths  /  matjectNEXT settings  / !WHT![Updates ^& Debug]!RST! !GRY![D] ^>!RST! 
echo.
echo.

if exist %doCheckUpdates% (set toggleP4_1=!toggleOn!) else (set toggleP4_1=!toggleOff!)
if exist %disableInterruptionCheck% (set toggleP4_2=!toggleOn!) else (set toggleP4_2=!toggleOff!)
if exist %disableMatCompatCheck% (set toggleP4_3=!toggleOn!) else (set toggleP4_3=!toggleOff!)
if "%debugMode%" equ "true" (set toggleP4_4=!RED![ON]!RST!) else (set toggleP4_4=!GRY![OFF]!RST!)

echo !WHT!Here you can check for updates or enable in-development features.!RST!
echo.
echo.
echo !toggleP4_1! 1. Check for updates at Matject startup !YLW!^(requires internet^)!RST!
echo !toggleP4_2! 2. Disable interruption check !RED!^(prevents recovery from incomplete injection^)!RST!
echo !toggleP4_3! 3. Disable material compatibility check
echo.
echo [M] Check for updates manually !YLW!^(requires internet^)!RST!
echo.
echo !GRY![0] DEBUG MODE!RST! !toggleP4_4!
echo.
echo !GRY![Z] Reset .settings!RST!
echo.
echo !YLW!Press corresponding key to toggle desired option...!RST!
echo.
choice /c 1m0bad23z /n >nul

goto toggleP4_!errorlevel!

:toggleP4_1
if not exist %doCheckUpdates% (echo Thank you for being a regular user of Matject ^^^^ [%date% // %time:~0,-6%]>%doCheckUpdates%) else (del /q /s %doCheckUpdates% > NUL)
goto settingsP4

:toggleP4_2
call "modules\checkUpdates"
goto settingsP4

:toggleP4_3
if "%debugMode%" neq "true" (echo You are now a developer^^! [%date% // %time:~0,-6%]>".settings\debugMode.txt" && set "debugMode=true") else (del /q /s ".settings\debugMode.txt" > NUL && set "debugMode=")
goto settingsP4

:toggleP4_4
exit /b 0

:toggleP4_5
goto settingsP3

:toggleP4_6
goto settingsP4

:toggleP4_7
if not exist %disableInterruptionCheck% (echo You are QlJBVkU= [%date% // %time:~0,-6%]>%disableInterruptionCheck%) else (del /q /s %disableInterruptionCheck% > NUL)
goto settingsP4

:toggleP4_8
if not exist "%disableMatCompatCheck%" (echo Don't blame Matject if game crashes for you. [%date% // %time:~0,-6%]>%disableMatCompatCheck%) else (del /q /s %disableMatCompatCheck% >nul)
goto settingsP4

:toggleP4_9
cls
echo !RED![?] ARE YOU SURE ABOUT RESETTING .settings?!RST!
echo.
echo !GRY!Enter yEs to confirm. ^(case sensitive^) !RST!Giving wrong/blank input will cancel.
echo.
set /p "tmpinput=Input: "

if "%tmpinput%" neq "yEs" (goto settingsP4)
del /q /s .settings\*.txt >nul
if exist "modules\*.exe" (del /q /s "modules\*.exe" >nul)
call "modules\createShortcut" deleteallshortcuts
cls
echo !YLW![^^!] Settings reset.
echo     Relaunch to take effect...!RST!
%relaunchmsg%