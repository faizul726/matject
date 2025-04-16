:: settings.bat // Made by github.com/faizul726
@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k

set "toggleOff=!GRY![ ]!RST!"
set "toggleOn=!GRN![x]!RST!"
:: Yes, I am too lazy to create another variable for DarkYellow
set "toggleMalfunction=!YLW:9=3![x]!RST!"

title %title% Settings

if not "[%~1]" equ "[]" goto %~1

:settingsP1
cls


if not exist %defaultMethod% (
    set "toggleone=!RED![None]!GRY! /  Auto  /  Manual  /  matjectNEXT!RST!"
    set toggleP1_1=!toggleOff!
    set "selectedMethod="
) else (
    set "toggleP1_1=!toggleOn!"
    set /p selectedMethod=<"%defaultMethod%"
    echo %hideCursor%>nul
    if /i "!selectedMethod: =!" equ "Auto" set "toggleone=!GRY! None  / !GRN![Auto]!GRY! /  Manual  /  matjectNEXT!RST!"
    if /i "!selectedMethod: =!" equ "Manual" set "toggleone=!GRY! None  /  Auto  / !BLU![Manual]!GRY! /  matjectNEXT!RST!"
    if /i "!selectedMethod: =!" equ "matjectNEXT" set "toggleone=!GRY! None  /  Auto  /  Manual  / !RED![matjectNEXT]!RST!"
)

if exist %thanksMcbegamerxx954% (
    if not exist "modules\material-updater.exe" (
        del /q ".\%thanksMcbegamerxx954%" >nul
        set toggleP1_2=!toggleOff!
    ) else (
        call :set_mtupdate_target main_settings
        set "toggleP1_2=!toggleOn!"
    )
) else set "toggleP1_2=!toggleOff!"

if exist %disableConfirmation% (set toggleP1_3=!toggleOn!) else (set toggleP1_3=!toggleOff!)
if exist %dontRetainOldBackups% (set toggleP1_4=!toggleOn!) else (set toggleP1_4=!toggleOff!)
if exist %disableSuccessMsg% (set toggleP1_5=!toggleOn!) else (set toggleP1_5=!toggleOff!)
if exist %autoOpenMCPACK% (set toggleP1_6=!toggleOn!) else (set toggleP1_6=!toggleOFF!)
if exist %dontOpenFolder% (set toggleP1_7=!toggleOn!) else (set toggleP1_7=!toggleOFF!)
if exist %useForMinecraftPreview% (set toggleP1_8=!toggleOn:GRN=RED!) else (set toggleP1_8=!toggleOff!)
if exist %disableTips% (set toggleP1_9=!toggleOn!) else (set toggleP1_9=!toggleOff!)
if exist %showAnnouncements% (set toggleP1_10=!RED![ON]!RST!) else (set toggleP1_10=!GRY![OFF]!RST!)


echo !RED!^< [B] Back!RST! ^| !YLW!^< [A]!RST! !WHT![General]!GRY! /  Custom paths  /  matjectNEXT settings  /  Updates ^& Debug !RST! !YLW![D] ^>!RST! 
echo.
echo.

echo !WHT!Here you can change how Matject works.!RST!
echo !GRY!Press [0] to open settings folder.!RST!
echo.

echo !toggleP1_1! 1. Default method: %toggleone%
if "!toggleP1_2!" equ "!toggleOff!" (
    echo !toggleP1_2! 2. Use material-updater to update materials ^(fixes invisible blocks^)
) else (
    echo !toggleP1_2! 2. Use material-updater to update materials !GRY!^(!mtupdate_target!^) ^(press 2 for more options^)!RST!
)

echo !toggleP1_3! 3. Disable confirmations
echo !toggleP1_4! 4. Don't retain old backups
echo !toggleP1_5! 5. Disable success message ^(auto/manual^)
echo !toggleP1_6! 6. Auto import MCPACK after injection ^(auto only^)
echo !toggleP1_7! 7. Don't open folder automatically ^(auto/manual^)
echo !toggleP1_8! 8. Use for Minecraft Preview !RED![BETA]!RST!
echo !toggleP1_9! 9. Disable tips
echo !GRY![M] Show Matject announcements !YLW!^(requires internet^)!RST! !toggleP1_10!
echo.

echo !YLW!Press corresponding key to toggle desired option...!RST!
echo !GRY!Press [A] or [D] to switch tab...!RST!
choice /c 12345678bad09mw /n >nul

goto toggleP1_!errorlevel!

:toggleP1_1
if not defined selectedMethod (echo Auto>%defaultMethod%) else (
    if /i "!selectedMethod!" equ "Auto" echo Manual>%defaultMethod%
    if /i "!selectedMethod!" equ "Manual" echo matjectNEXT>%defaultMethod%
    if /i "!selectedMethod!" equ "matjectNEXT" del /q ".\%defaultMethod%" >nul
) 
goto settingsP1


:toggleP1_2
if exist "%thanksMcbegamerxx954%" (
    :material_updater_settings
    cls
    echo !RED!^< [B] Back!RST!
    call :set_mtupdate_target
    echo.
    echo.
    echo !WHT!Here you can configure material-updater.!RST!
    echo.
    echo [1] Set target version !GRY!^(Currently set to: !mtupdate_target:version =!^)!RST!
    echo.
    echo [2] Re-download/update material-updater
    echo.
    echo !RED![3] Turn off material-updater!RST!
    echo.
    echo !YLW!Press corresponding key to confirm your choice...!RST!
    choice /c 123b /n >nul

    if !errorlevel! equ 4 goto settingsP1
    if !errorlevel! equ 3 (
        set "toggleP1_2=!toggleOff!"
        del /q ".\%thanksMcbegamerxx954%" >nul
        if exist "%materialUpdaterArg%" del /q ".\%materialUpdaterArg%" >nul
        goto settingsP1
    )
    if !errorlevel! equ 2 (
        call "modules\getMaterialUpdater" skip_intro_settings
        if exist ".\modules\material-updater.exe" (
            goto material_updater_settings
        ) else (
            goto settingsP1
        )
    )
    if !errorlevel! equ 1 (
        cls
        echo !RED!^< [B] Back!RST!
        echo.
        echo.
        echo !YLW!Select target version for material-updater...!RST!
        echo.
        echo !WHT!Currently set to: !GRY!!mtupdate_target!!RST!
        echo.
        echo.
        if not defined isPreview (
            echo [0] Auto: Automatically detect game version !GRN![Recommended] !RED![BETA] ^(Preview not supported^)!RST!
        ) else (
            echo !GRY![0] Auto: Automatically detect game version [Recommended] [BETA] ^(Preview not supported^)!RST!
        )
        echo.
        echo [1] v1.21.20+
        echo [2] v1.20.80 - v1.21.2
        echo [3] v1.19.60 - v1.20.73
        echo [4] v1.18.30 - v1.19.51
        echo.
        echo !YLW!Press corresponding key to confirm your choice...!RST!
        if defined isPreview (choice /c 1234b /n >nul) else (choice /c 1234b0 /n >nul)
        rem TODO Do for %%C here to avoid double run
        if !errorlevel! equ 6 if exist "%materialUpdaterArg%" del /q ".\%materialUpdaterArg%" >nul
        if !errorlevel! equ 5 goto material_updater_settings
        if !errorlevel! equ 4 echo v1-18-30>%materialUpdaterArg%
        if !errorlevel! equ 3 echo v1-19-60>%materialUpdaterArg%
        if !errorlevel! equ 2 echo v1-20-80>%materialUpdaterArg%
        if !errorlevel! equ 1 echo v1-21-20>%materialUpdaterArg%
        goto material_updater_settings
    )
) else (
    if not exist "modules\material-updater.exe" (
        call "modules\getMaterialUpdater"
    ) else (
        if not exist %thanksMcbegamerxx954% (echo github.com/mcbegamerxx954/material-updater > %thanksMcbegamerxx954%)
    )
)
goto settingsP1

:toggleP1_3
if not exist %disableConfirmation% (echo You are c21hcnQ= [%date% // %time:~0,-6%]>%disableConfirmation%) else (del /q ".\%disableConfirmation%" > NUL)
goto settingsP1

:toggleP1_4
if not exist %dontRetainOldBackups% (echo Just like old backups, you shouldn't overthink about your past. Improve yourself for future instead. [%date% // %time:~0,-6%]>%dontRetainOldBackups%) else (del /q ".\%dontRetainOldBackups%" > NUL)
goto settingsP1

:toggleP1_5
if not exist %disableSuccessMsg% (echo Thanks for using Matject, have a good day^^! [%date% // %time:~0,-6%]>%disableSuccessMsg%) else (del /q ".\%disableSuccessMsg%" > NUL)
goto settingsP1

:toggleP1_6
if not exist %autoOpenMCPACK% (echo You are lazy [%date% // %time:~0,-6%]>%autoOpenMCPACK%) else (del /q ".\%autoOpenMCPACK%" > NUL)
goto settingsP1

:toggleP1_7
if not exist %dontOpenFolder% (echo Opening folder seems slow innit? [%date% // %time:~0,-6%]>%dontOpenFolder%) else (del /q ".\%dontOpenFolder%" > NUL)
goto settingsP1

:toggleP1_8
if not exist %useForMinecraftPreview% (echo Deferred rendering is cool. [%date% // %time:~0,-6%]>%useForMinecraftPreview%) else (del /q ".\%useForMinecraftPreview%" >nul)
cls
echo !YLW![^^!] Target app changed.
echo     Relaunch to take effect...!RST!
%relaunchmsg%
goto settingsP1

:toggleP1_9
exit /b 0

:toggleP1_10
goto settingsP4

:toggleP1_11
goto settingsP2

:toggleP1_12
start /i "" explorer "%cd%\.settings"
goto settingsP1

:toggleP1_13
if not exist %disableTips% (echo tips are helpful, but no problem. [%date% // %time:~0,-6%]>%disableTips%) else (del /q ".\%disableTips%" > NUL)
goto settingsP1

:toggleP1_14
where curl >nul 2>&1 || (
    cls
    echo !RED![^^!] curl is not available on your system. It is required to show announcements.!RST!
    %backmsg:EOF=settingsP1%
)
if not exist %showAnnouncements% (echo thanks for being up to date about Matject [%date% // %time:~0,-6%]>%showAnnouncements%) else (del /q ".\%showAnnouncements%" > NUL)
goto settingsP1

:toggleP1_15
call :hmmmmm_20250413_1545
goto settingsP1

:settingsP2
cls

echo !RED!^< [B] Back!RST! ^| !YLW!^< [A]!RST! !GRY! General  / !WHT![Custom paths]!GRY! /  matjectNEXT settings  /  Updates ^& Debug !RST! !YLW![D] ^>!RST! 
echo.
echo.

echo !WHT!Here you can set paths to be used by Matject/matjectNEXT.!RST!
echo.
echo.

if exist "%customMinecraftAppPath%" (
    set /p tmp_customMinecraftAppPath=<"%customMinecraftAppPath%"
    echo %hideCursor%>nul
    if not exist "!tmp_customMinecraftAppPath!" (
        set toggleP2_1=!toggleMalfunction!
    ) else (
        set toggleP2_1=!toggleOn!
    )
    set "tmp_customMinecraftAppPath="
) else (set toggleP2_1=!toggleOff!)

if exist %customMinecraftDataPath% (
    set /p tmp_customMinecraftDataPath=<"%customMinecraftDataPath%"
    echo %hideCursor%>nul
    if not exist "!tmp_customMinecraftAppPath!" (
        set toggleP2_2=!toggleMalfunction!
    ) else (
        set toggleP2_2=!toggleOn!
    )
    set "tmp_customMinecraftDataPath="
) else (set toggleP2_2=!toggleOff!)
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
echo.
echo !YLW!Press corresponding key to toggle desired option...!RST!
echo !GRY!Press [A] or [D] to switch tab...!RST!
choice /c 123badw /n >nul
goto toggleP2_!errorlevel!

:toggleP2_1
if exist "%customMinecraftAppPath%" (
    del /q ".\%customMinecraftAppPath%" > NUL
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
    echo %showCursor%
    set /p "setcustomMinecraftAppPath=Custom Minecraft app path: "
    echo %hideCursor%
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
    del /q ".\%customMinecraftDataPath%" > NUL
    set "gameData=!defaultGameData!"
    goto settingsP2
)
cls
set "setCustomMinecraftDataPath="
echo.
echo !YLW![*] Enter your custom Minecraft data ^(com.mojang folder^) path 
echo     ^(Make sure not to include unnecessary space. Leave blank to cancel.^)!RST!
echo %showCursor%
set /p "setCustomMinecraftDataPath=Custom Minecraft data (com.mojang folder) path: "
echo %hideCursor%
if not defined setCustomMinecraftDataPath (goto settingsP2)
set "setCustomMinecraftDataPath=!setCustomMinecraftDataPath:"=!"
set "setCustomMinecraftDataPath=!setCustomMinecraftDataPath:com.mojang\=com.mojang!"
if exist "!setCustomMinecraftDataPath!\minecraftpe\options.txt" (
    echo !setCustomMinecraftDataPath!>%customMinecraftDataPath%
    set "gameData=!setCustomMinecraftDataPath!"
    set "setCustomMinecraftDataPath="
    goto settingsP2
)
echo !ERR![^^!] Invalid Minecraft data path.!RST!
set "setCustomMinecraftDataPath="
%backmsg:EOF=settingsP2%


:toggleP2_3
if exist "%customIObitUnlockerPath%" (
    cls
    echo !YLW![^^!] Custom IObit Unlocker path removed.
    echo     Relaunch to take effect...!RST!
    del /q ".\%customIObitUnlockerPath%" > NUL
    %relaunchmsg%
)
cls
set "setCustomIObitUnlockerPath="
echo.
echo !YLW![*] Enter your custom IObit Unlocker folder path 
echo     !GRY!Make sure not to include unnecessary space. Leave blank to cancel!RST!
echo %showCursor%
set /p "setCustomIObitUnlockerPath=IObit Unlocker path: "
echo %hideCursor%

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

:toggleP2_7
call :hmmmmm_20250413_1545
goto settingsP2

:settingsP3
cls
echo !RED!^< [B] Back!RST! ^| !YLW!^< [A]!RST! !GRY! General  /  Custom paths  / !WHT![matjectNEXT settings]!GRY! /  Updates ^& Debug !RST! !YLW![D] ^>!RST! 
echo.
echo.

echo !WHT!Here you can change how matjectNEXT works.!RST!
echo.
echo.

if exist "%syncThenExit%" (set "toggleP3_1=!toggleOn!") else (set "toggleP3_1=!toggleOff!")
if exist "%disableManifestCheck%" (set toggleP3_2=!toggleOn!) else (set toggleP3_2=!toggleOff!)

echo !toggleP3_1! 1. Just sync and exit
echo !toggleP3_2! 2. Disable manifest checker !RED![EXPERIMENTAL]!RST!
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
echo !GRY!Press [A] or [D] to switch tab...!RST!
choice /c 1bad2w /n >nul

goto toggleP3_!errorlevel!

:toggleP3_1
if not exist "%syncThenExit%" (echo I hope matjectNEXT is doing its job properly. - Creator [%date% // %time:~0,-6%]>"%syncThenExit%" ) else (del /q ".\%syncThenExit%" >nul)
goto settingsP3

:toggleP3_2
exit /b 0

:toggleP3_3
goto settingsP2

:toggleP3_4
goto settingsP4

:toggleP3_5
if not exist %disableManifestCheck% (echo why minecraft imports shaders with wrong manifest? [%date% // %time:~0,-6%]>%disableManifestCheck%) else (del /q ".\%disableManifestCheck%" >nul)
goto settingsP3

:toggle_P3_6
call :hmmmmm_20250413_1545
goto settingsP3


:settingsP4
:settingsP4_01
cls
echo !RED!^< [B] Back!RST! ^| !YLW!^< [A]!RST! !GRY! General  /  Custom paths  /  matjectNEXT settings  / !WHT![Updates ^& Debug]!RST! !YLW![D] ^>!RST! 
echo.
echo.

if exist %doCheckUpdates% (set toggleP4_1=!toggleOn!) else (set toggleP4_1=!toggleOff!)
if exist %disableInterruptionCheck% (set toggleP4_2=!toggleOn!) else (set toggleP4_2=!toggleOff!)
if exist %disableMatCompatCheck% (set toggleP4_3=!toggleOn!) else (set toggleP4_3=!toggleOff!)
if exist %runIObitUnlockerAsAdmin% (set toggleP4_4=!toggleOn!) else (set toggleP4_4=!toggleOff!)
if "%debugMode%" equ "true" (set toggleP4_6=!RED![ON]!RST!) else (set toggleP4_6=!GRY![OFF]!RST!)
if exist "%runAsAdmin%" (set toggleP4_7=!RED![ON]!RST!) else (set toggleP4_7=!GRY![OFF]!RST!)

echo !WHT!Here you can check for updates or enable in-development features.!RST!
echo.
echo.
echo !toggleP4_1! 1. Check for updates at Matject startup !YLW!^(requires internet^)!RST!
echo !toggleP4_2! 2. Disable interruption check !RED!^(prevents recovery from incomplete injection^)!RST!
echo !toggleP4_3! 3. Disable material compatibility check ^(testing purpose only^)
echo !toggleP4_4! 4. Run IObit Unlocker as admin ^(admin prompts will be reduced to 1^) !RED![BETA]!RST!
echo.
echo [M] Check for updates manually !YLW!^(requires internet^)!RST!
echo !GRY![0] DEBUG MODE!RST! !toggleP4_6!
echo !GRY![X] Always run Matject as admin !RED![BETA]!RST! !toggleP4_7!
echo !GRY![Z] Reset Matject settings!RST!
echo ----------!YLW![S] Go down!RST!----------
echo.
echo !YLW!Press corresponding key to toggle desired option...!RST!
echo !GRY!Press [A] or [D] to switch tab...!RST!
choice /c 1m0bad23zx4ws /n >nul

goto toggleP4_!errorlevel!

:toggleP4_1
if not exist %doCheckUpdates% (echo Thank you for being a regular user of Matject ^^^^ [%date% // %time:~0,-6%]>%doCheckUpdates%) else (del /q ".\%doCheckUpdates%" > NUL)
goto settingsP4

:toggleP4_2
call "modules\checkUpdates"
goto settingsP4

:toggleP4_3
if "%debugMode%" neq "true" (echo You are now a developer^^! [%date% // %time:~0,-6%]>".settings\debugMode.txt" && set "debugMode=true") else (del /q ".\.settings\debugMode.txt" > NUL && set "debugMode=")
goto settingsP4

:toggleP4_4
exit /b 0

:toggleP4_5
goto settingsP3

:toggleP4_6
goto settingsP1

:toggleP4_7
if not exist %disableInterruptionCheck% (echo You are QlJBVkU= [%date% // %time:~0,-6%]>%disableInterruptionCheck%) else (del /q .\%disableInterruptionCheck% > NUL)
goto settingsP4

:toggleP4_8
if not exist "%disableMatCompatCheck%" (echo Don't blame Matject if game crashes for you. [%date% // %time:~0,-6%]>%disableMatCompatCheck%) else (del /q .\%disableMatCompatCheck% >nul)
goto settingsP4

:toggleP4_9
cls
echo !RED![?] ARE YOU SURE ABOUT RESETTING Matject settings?!RST!
echo.
echo !GRY!Type yEs and press [Enter] to confirm. ^(case sensitive^)!RST!
echo Giving wrong/blank input will cancel.
echo %showCursor%
set /p "tmpinput=Input: "
echo %hideCursor%

if "%tmpinput%" neq "yEs" (goto settingsP4)
del /q ".\.settings\*.txt" >nul
if exist "modules\jq.exe" (del /q /f ".\modules\jq.exe" >nul)
if exist "modules\material-updater.exe" (del /q /f ".\modules\material-updater.exe" >nul)
if exist ".\tmp" (del /q .\tmp >nul)
call "modules\createShortcut" deleteallshortcuts
cls
echo !YLW![^^!] Settings reset.
echo     Relaunch to take effect...!RST!
%relaunchmsg%

:toggleP4_10
if exist "%runAsAdmin%" (
    del /q ".\%runAsAdmin%" >nul 2>&1
    del /q /f ".\.settings\runAsAdmin_helper.vbs" >nul 2>&1
    goto settingsP4
)
cls
echo !RED!^< [B] Back!RST!
echo.
echo !YLW![?] How do you want to run Matject as admin?!RST!
echo.
echo !WHT![1] PowerShell !GRN![Recommended]!RST!
echo     Slow, using Start-Process with RunAs verb.
echo     Automatically turns off this setting if admin prompt is ever declined.
echo.
echo !WHT![2] VBscript !RED![BETA]!RST!
echo     Fast, using a helper .vbs script created in .settings
echo.
echo.
echo !GRY![*] Alternatively, you can create a shortcut from Shader Removal/Tools ^> Create shortcuts
echo     And then, right click the shortcut ^> Shortcut tab ^> Advanced ^> Turn on "Run as administrator"
echo     Or... Just right click matject.bat and Run as administrator.!RST!
echo.
echo !YLW!Press corresponding key to toggle desired option...!RST!
choice /c b12 /n >nul

if %errorlevel% equ 1 goto settingsP4
if %errorlevel% equ 2 (
    echo sudo is better anyways. [%date% // %time:~0,-6%]>"%runAsAdmin%"
    del /q ".\.settings\runAsAdmin_helper.vbs" >nul 2>&1
    goto settingsP4
)
:: VBscript obtained from https://ss64.com/vb/shellexecute.html
:: Thanks to ChatGPT for providing Args detection and MsgBox
if %errorlevel% equ 3 (
(
echo If WScript.Arguments^(0^) ^<^> "matjet" OR WScript.Arguments.Count ^< 2 Then
echo WScript.Echo "Be careful smarty :)"
echo MsgBox "You're NOT supposed to open this file^^!" ^& vbCrLf ^& "Understand?", vbExclamation, "Attention^^!"
echo WScript.Quit 1
echo End If
echo.
echo CreateObject^("Shell.Application"^).ShellExecute WScript.Arguments^(1^), "murgi", "", "runas", 1
)>".settings\runAsAdmin_helper.vbs"
    echo sudo is better anyways. [%date% // %time:~0,-6%]>"%runAsAdmin%"
    attrib +R ".settings\runAsAdmin_helper.vbs"
    goto settingsP4
)

:toggleP4_11
if not exist %runIObitUnlockerAsAdmin% (echo 4 minus 3 equals 1 hmm... [%date% // %time:~0,-6%]>%runIObitUnlockerAsAdmin%) else (del /q .\%runIObitUnlockerAsAdmin% >nul)
goto settingsP4

:toggleP4_12
call :hmmmmm_20250413_1545
goto settingsP4

:toggleP4_13
:settingsP4_02
cls
echo !RED!^< [B] Back!RST! ^| !YLW!^< [A]!RST! !GRY! General  /  Custom paths  /  matjectNEXT settings  / !WHT![Updates ^& Debug]!RST! !YLW![D] ^>!RST! 
echo.
echo.

if exist "%disableModuleVerification%" (set toggleP4_02_1=!toggleOn!) else (set toggleP4_02_1=!toggleOff!)
if exist "%dontMakeReadOnly%" (set toggleP4_02_2=!toggleOn!) else (set toggleP4_02_2=!toggleOff!)
if exist "%fallbackToExpandArchive%" (set toggleP4_02_3=!toggleOn!) else (set toggleP4_02_3=!toggleOff!)
if exist "%preferWtShortcut%" (set toggleP4_02_4=!toggleOn!) else (set toggleP4_02_4=!toggleOff!)
if exist "%directWriteMode%" (set toggleP4_02_5=!toggleOn!) else (set toggleP4_02_5=!toggleOff!)
if exist "%fullRestoreMaterialsPerCycle%" (
    set /p materialsPerCycle=<"%fullRestoreMaterialsPerCycle%"
    set "materialsPerCycle=!materialsPerCycle: =!"
    echo !materialsPerCycle!|findstr /R "^[1-9][0-9]*$" >nul
    if !errorlevel! neq 0 (
        del /q ".\%fullRestoreMaterialsPerCycle%"
        set /a materialsPerCycle=!defaultMaterialsPerCycle!
        set toggleP4_02_6=!toggleOff!
    ) else (
        set /a materialsPerCycle=!materialsPerCycle!
        if !materialsPerCycle! lss 2 (
            del /q ".\%fullRestoreMaterialsPerCycle%"
            set /a materialsPerCycle=!defaultMaterialsPerCycle!
            set toggleP4_02_6=!toggleOff!
        )
        if !materialsPerCycle! gtr 75 (
            del /q ".\%fullRestoreMaterialsPerCycle%"
            set /a materialsPerCycle=!defaultMaterialsPerCycle!
            set toggleP4_02_6=!toggleOff!
        )
        set toggleP4_02_6=!toggleOn!
    )
) else (
    set toggleP4_02_6=!toggleOff!
)

echo !WHT!Here you can check for updates or enable in-development features.!RST!
echo.
echo -----------!YLW![W] Go up!RST!-----------
echo !toggleP4_02_1! 1. Disable module verification !RED!^(UNSAFE^)!RST!
echo !toggleP4_02_2! 2. Don't make .bat files read-only
echo !toggleP4_02_3! 3. Force fallback to PowerShell Expand-Archive
echo !toggleP4_02_4! 4. Prefer Windows Terminal over Command Prompt for shortcuts !GRY!^(Shortcuts will not be recreated^)!RST!
echo !toggleP4_02_5! 5. Direct write mode !RED![EXPERIMENTAL]!RST!
echo !toggleP4_02_6! 6. Max materials per cycle for full restore !GRY!^(currently set to: !materialsPerCycle!^)!RST! !RED![EXPERIMENTAL]!RST!
echo.
echo.
echo.
echo.
echo.
echo !YLW!Press corresponding key to toggle desired option...!RST!
echo !GRY!Press [A] or [D] to switch tab...!RST!
choice /c 1234567890bwasd /n >nul

goto toggleP4_02_!errorlevel!

:toggleP4_02_1
if not exist %disableModuleVerification% (echo well, this is only needed when you're modifying the files... [%date% // %time:~0,-6%]>%disableModuleVerification%) else (del /q .\%disableModuleVerification% >nul)
goto settingsP4_02

:toggleP4_02_2
if not exist %dontMakeReadOnly% (echo good luck modifying modules ;^) [%date% // %time:~0,-6%]>%dontMakeReadOnly%) else (del /q .\%dontMakeReadOnly% >nul)
goto settingsP4_02

:toggleP4_02_3
if not exist "%fallbackToExpandArchive%" (
    echo tar is fast tho... [%date% // %time:~0,-6%]>"%fallbackToExpandArchive%"
    set "tarexe=confused_unga/bunga"
) else (
    >nul del /q ".\%fallbackToExpandArchive%"
    set "tarexe=tar.exe"
)
goto settingsP4_02

:toggleP4_02_4
if not exist %preferWtShortcut% (echo Windows users when they see terminal a terminal: *sweats* [%date% // %time:~0,-6%]>"%preferWtShortcut%") else (del /q ".\%preferWtShortcut%" >nul)
goto settingsP4_02

:toggleP4_02_5
if exist "%directWriteMode%" (
    del /q ".\%directWriteMode%" >nul
    goto settingsP4_02
)
cls
echo !RED!^< [B] Back!RST!
echo.
echo.

echo !WHT![*] Enabling this option will make Matject use MOVE, DEL commands instead of IObit Unlocker.
echo     Use this if you use Bedrock Launcher or Minecraft app folder is not write protected.
echo.

echo !YLW![^^!] This will run a test to confirm it works.
echo     It will be automatically disabled if it ever fails to write.!RST!
echo.
echo.
echo !YLW![?] Do you want to test and enable direct write mode?!RST!
echo.
echo !RED![Y] Yes    !GRN![N] No, go back!RST!
echo.
choice /c ynb /n >nul

if !errorlevel! equ 1 (
    (echo This file was created to check if Minecraft app folder is writable. [%date% // %time:~0,-6%]>"!MCLOCATION!\matject-test-file.txt") >nul 2>&1
    if exist "!MCLOCATION!\matject-test-file.txt" (
        del /q "!MCLOCATION!\matject-test-file.txt"
        echo being outside WindowsApps feels like freedom. [%date% // %time:~0,-6%]>"%directWriteMode%"
        echo !GRN![*] Test passed and enabled direct write mode.!RST!
    ) else (
        echo !RED![^^!] Test failed and direct write mode remains disabled.!RST!
    )
    %backmsg:EOF=settingsP4_02%
)
goto settingsP4_02

:toggleP4_02_6
if exist "%fullRestoreMaterialsPerCycle%" (
    del /q ".\%fullRestoreMaterialsPerCycle%" >nul
    goto settingsP4_02
)
cls
echo !RED!^< [B] Back!RST!
echo.
echo.
echo !WHT![*] This option allows you to set how many materials are processed per cycle for full restore.!RST!
echo.
echo !YLW![NOTE]!GRY!
echo - Default is !defaultMaterialsPerCycle!
echo - Higher number = Faster restore, lower chance of success
echo - Lower number  = Slower restore, higher chance of success
echo - This option will be automatically disabled if something goes wrong.!RST!
echo.
echo %showCursor%
set "materialsPerCycle_tmp="
set /p "materialsPerCycle_tmp=Enter a positive number between 2-75 !GRY!(leave blank to go back)!RST!: "
echo %hideCursor%
if not defined materialsPerCycle_tmp goto settingsP4_02
set "materialsPerCycle_tmp=!materialsPerCycle_tmp: =!"
echo !materialsPerCycle_tmp!|findstr /R "^[1-9][0-9]*$" >nul
if !errorlevel! neq 0 (
    echo !RED![^^!] Wrong input!RST!
    %backmsg:EOF=settingsP4_02%
) else (
    set /a materialsPerCycle_tmp=!materialsPerCycle_tmp!
    if !materialsPerCycle_tmp! lss 2 (
        echo !RED![^^!] Wrong input!RST!
        %backmsg:EOF=settingsP4_02%
    )
    if !materialsPerCycle_tmp! gtr 75 (
        echo !RED![^^!] Wrong input!RST!
        %backmsg:EOF=settingsP4_02%
    )
    set /a materialsPerCycle=!materialsPerCycle_tmp!
    set "materialsPerCycle_tmp="
    echo !materialsPerCycle!>"%fullRestoreMaterialsPerCycle%"
)
goto settingsP4_02

:toggleP4_02_7
:toggleP4_02_8
:toggleP4_02_9
:toggleP4_02_10
goto settingsP4_02

:toggleP4_02_11
exit /b 0

:toggleP4_02_12
goto settingsP4_01

:toggleP4_02_13
goto settingsP3

:toggleP4_02_14
goto settingsP4_02

:toggleP4_02_15
goto settingsP1


goto :EOF

:set_mtupdate_target
if exist "%materialUpdaterArg%" (
    set /p mtupdate_target=<"%materialUpdaterArg%"
    echo %hideCursor%>nul

    if /i "!mtupdate_target: =!" equ "v1-18-30" set "mtupdate_target=v1.18.30 - v1.19.51"
    if /i "!mtupdate_target: =!" equ "v1-19-60" set "mtupdate_target=v1.19.60 - v1.20.73"
    if /i "!mtupdate_target: =!" equ "v1-20-80" set "mtupdate_target=v1.20.80 - v1.21.2"
    if /i "!mtupdate_target: =!" equ "v1-21-20" set "mtupdate_target=v1.21.20+"
) else if defined isPreview (
    set "mtupdate_target=None"
) else (
    set "mtupdate_target=Auto"
)

if "[%~1]" equ "[main_settings]" (
    if exist "%materialUpdaterArg%" (
        set "mtupdate_target=Updating for !mtupdate_target!"
    ) else (
        if not defined isPreview (
            set "mtupdate_target=Detecting game version automatically"
        ) else (
            set "mtupdate_target=Will ask for game version"
        )
    )
)
goto :EOF

:hmmmmm_20250413_1545
@echo off
setlocal enabledelayedexpansion
rem color 8F
set /a current_pos=226
cls
set "sekret_words="
for %%S in (h,i,d,d,e,n,_c,h,i,m,k,e,n,_,p,i,x,e,l,_,a,r,t,_,g,a,m,e,_,C,o,n,g,r,a,t,u,l,a,t,i,o,n,s) do (set sekret_words=!sekret_words!%%S)
:init
echo [H[?25l[93m
echo [*] Welcome to the %sekret_words:~0,6% %sekret_words:~15,5% %sekret_words:~21,3% %sekret_words:~25,4%^^! 
echo     Complete the %sekret_words:~7,7% to exit.
echo     [90mHint: Move the black %sekret_words:~15,5% using WASD keys.[0m
echo.
for /L %%N in (1,1,256) do (
    set px_%%N=[100m  [0m
)
for %%N in (27,28,29,43,44,59,60,61,75,76,77,84,91,92,93,100,107,108,109,116,123,132,139,148,149,150,151,152,153,154,155,164,165,166,167,168,169,170,171) do (
    set px_%%N=[107m  [0m
)
for %%N in (85,86,87,88,89,90,101,102,103,104,105,106,117,118,119,120,121,122,133,134,135,136,137,138) do (
    set px_%%N=[47m  [0m
)
for %%N in (62,63,78,79,183,199,215,231,232,233) do (
    set px_%%N=[43m  [0m
)
for %%N in (94,110) do (
    set px_%%N=[41m  [0m
)
set /a here_goes_x=((current_pos-1) / 16) + 1
set /a here_goes_y=(current_pos-1) %% 16 + 1
set "px_%current_pos%=[0m  [0m"
echo [0K[*] Pos: !here_goes_x!x!here_goes_y!
echo.
echo !px_1!!px_2!!px_3!!px_4!!px_5!!px_6!!px_7!!px_8!!px_9!!px_10!!px_11!!px_12!!px_13!!px_14!!px_15!!px_16!
echo !px_17!!px_18!!px_19!!px_20!!px_21!!px_22!!px_23!!px_24!!px_25!!px_26!!px_27!!px_28!!px_29!!px_30!!px_31!!px_32!
echo !px_33!!px_34!!px_35!!px_36!!px_37!!px_38!!px_39!!px_40!!px_41!!px_42!!px_43!!px_44!!px_45!!px_46!!px_47!!px_48!
echo !px_49!!px_50!!px_51!!px_52!!px_53!!px_54!!px_55!!px_56!!px_57!!px_58!!px_59!!px_60!!px_61!!px_62!!px_63!!px_64!
echo !px_65!!px_66!!px_67!!px_68!!px_69!!px_70!!px_71!!px_72!!px_73!!px_74!!px_75!!px_76!!px_77!!px_78!!px_79!!px_80!
echo !px_81!!px_82!!px_83!!px_84!!px_85!!px_86!!px_87!!px_88!!px_89!!px_90!!px_91!!px_92!!px_93!!px_94!!px_95!!px_96!
echo !px_97!!px_98!!px_99!!px_100!!px_101!!px_102!!px_103!!px_104!!px_105!!px_106!!px_107!!px_108!!px_109!!px_110!!px_111!!px_112!
echo !px_113!!px_114!!px_115!!px_116!!px_117!!px_118!!px_119!!px_120!!px_121!!px_122!!px_123!!px_124!!px_125!!px_126!!px_127!!px_128!
echo !px_129!!px_130!!px_131!!px_132!!px_133!!px_134!!px_135!!px_136!!px_137!!px_138!!px_139!!px_140!!px_141!!px_142!!px_143!!px_144!
echo !px_145!!px_146!!px_147!!px_148!!px_149!!px_150!!px_151!!px_152!!px_153!!px_154!!px_155!!px_156!!px_157!!px_158!!px_159!!px_160!
echo !px_161!!px_162!!px_163!!px_164!!px_165!!px_166!!px_167!!px_168!!px_169!!px_170!!px_171!!px_172!!px_173!!px_174!!px_175!!px_176!
echo !px_177!!px_178!!px_179!!px_180!!px_181!!px_182!!px_183!!px_184!!px_185!!px_186!!px_187!!px_188!!px_189!!px_190!!px_191!!px_192!
echo !px_193!!px_194!!px_195!!px_196!!px_197!!px_198!!px_199!!px_200!!px_201!!px_202!!px_203!!px_204!!px_205!!px_206!!px_207!!px_208!
echo !px_209!!px_210!!px_211!!px_212!!px_213!!px_214!!px_215!!px_216!!px_217!!px_218!!px_219!!px_220!!px_221!!px_222!!px_223!!px_224!
echo !px_225!!px_226!!px_227!!px_228!!px_229!!px_230!!px_231!!px_232!!px_233!!px_234!!px_235!!px_236!!px_237!!px_238!!px_239!!px_240!
echo !px_241!!px_242!!px_243!!px_244!!px_245!!px_246!!px_247!!px_248!!px_249!!px_250!!px_251!!px_252!!px_253!!px_254!!px_255!!px_256!
echo.
if !current_pos! equ 45 (
    echo [92m[*] %sekret_words:~30%^^!
    echo     Returning to settings...[0m
    timeout 3 >nul
    goto :EOF
)
choice /c wasd /n >nul
call :!errorlevel!key
goto init

:1key
for %%N in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16) do (
    if !current_pos! equ %%N (
        echo [91m[^^!] Out of boundaries.[0m
        goto :EOF
    )
)
echo [0K
set /a current_pos-=16
goto :EOF

:2key
for %%N in (1,17,33,49,65,81,97,113,129,145,161,177,193,209,225,241) do (
    if !current_pos! equ %%N (
        echo [91m[^^!] Out of boundaries.[0m
        goto :EOF
    )
)
echo [0K
set /a current_pos-=1
goto :EOF

:3key
for %%N in (241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256) do (
    if !current_pos! equ %%N (
        echo [91m[^^!] Out of boundaries.[0m
        goto :EOF
    )
)
echo [0K
set /a current_pos+=16
goto :EOF

:4key
for %%N in (16,32,48,64,80,96,112,128,144,160,176,192,208,224,240,256) do (
    if !current_pos! equ %%N (
        echo [91m[^^!] Out of boundaries.[0m
        goto :EOF
    )
)
echo [0K
set /a current_pos+=1
goto :EOF