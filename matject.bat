@echo off
setlocal enabledelayedexpansion

:: Initial setup
title Loading...
cls
echo [?25lLoading...
pushd "%~dp0"
set "murgi=KhayDhan"

:: A material replacer for Minecraft.
:: Made by @faizul726
:: https://faizul726.github.io/matject

:: This script uses ANSI escape codes for text formatting.
:: "" = Hex 0x1B / Decimal 27
:: https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
:: Mostly referenced as variables from "modules\colors.bat"
:: Although I used raw escape codes in some places.

:: Starting from v3.5.2, I also added BEL symbol "" = Hex 0x07 / Decimal 7 
:: Which just plays 'Windows Foreground.wav' or 'Critical Stop' in some confirmation screens.

REM TODO
REM - STORE SHADER NAME FOR LATER USE [DONE]
REM - MERGE UNLOCK...BAT WITH MATJECT
REM - Use subroutines
REM - Use %1 for restoreMaterials
REM - L24, L34, unlockWindowsApps: use && ||
REM - Check -> Checker
REM - curl redirect stderr to stdout
REM - Move common functions to different file
REM - Use cscript for vbs [DONE]
REM - Use for %%f for colors to set variables
REM - Use start /b trickery for iobit window closing [DONE]
REM - Change up to date to you are using latest version something... [DONE]

:: Check critical components
>nul 2>&1 where certutil || (
    cls
    echo [91m[^^!] Critical component 1 not found.[0m
    echo.
    echo Exiting...
    cmd /k
)

>nul 2>&1 where findstr || (
    cls
    echo [91m[^^!] Critical component 2 not found.[0m
    echo.
    echo Exiting...
    cmd /k
)

>nul 2>&1 where powershell || (
    cls
    echo [91m[^^!] PowerShell not found.
    echo     You can't use Matject without it.[0m
    echo.
    echo Exiting...
    cmd /k
)

echo %cd% | findstr /C:"Local\Temp" /I >nul && (
    title EXTRACT FIRST^^!
    cls
    echo [93m[^^!] Are you trying to run Matject without extracting?
    echo     You have to extract it first^^![0m
    echo.
    echo Exiting...[?25h
    echo.
    echo on
    @cmd /k
)
if not exist "%cd%\matject.bat" (
    title FOLDER NOT FOUND^^!
    cls
    echo [93m[^^!] Couldn't get Matject folder automatically[0m
    echo.
    echo Exiting...[?25h
    echo.
    echo on
    @cmd /k
)

:: Check admin status
>nul 2>&1 where fltmc && (
    >nul 2>&1 fltmc && (set isAdmin=true) || (set "isAdmin=")
) || (
    >nul 2>&1 where openfiles && (
        >nul 2>&1 openfiles && (set isAdmin=true) || (set "isAdmin=")
    ) || (
        >nul 2>&1 where wmic && (
            >nul 2>&1 (wmic /locale:ms_409 service where ^(name="LanManServer"^) get state /value | findstr /i "State=Running")
            if %errorlevel% equ 0 (
                >nul 2>&1 net session && (set isAdmin=true) || (set "isAdmin=")
            ) else (set "isAdmin=")
        ) || (set "isAdmin=")
    )
)

if [%1] equ [] (
    if not exist ".settings\runAsAdmin.txt" (
        if exist ".settings\matject_icon.ico" (
            if exist ".settings\Matject.lnk" (
                start /i "Loading..." "%cd%\.settings\Matject.lnk" placebo
            ) else start /b "Loading..." cmd /k "%~f0" placebo
        ) else start /b "Loading..." cmd /k "%~f0" placebo
        goto :EOF
    ) else (
        rem net session >nul 2>&1
        if not defined isAdmin (
            if exist ".settings\runAsAdmin.vbs" (
                echo.
                echo [93m[^^!] Cancelling admin permission request will close Matject.[0m
                if exist ".settings\matject_icon.ico" (
                    if exist ".settings\Matject.lnk" (
                        cscript /NoLogo ".settings\runAsAdmin.vbs" matjet "%cd%\.settings\Matject.lnk"
                    )
                ) else cscript /NoLogo ".settings\runAsAdmin.vbs" matjet "%~f0"
                goto :EOF
            ) else (
                if exist ".settings\matject_icon.ico" (
                    if exist ".settings\Matject.lnk" (
                        powershell -NoProfile -Command Start-Process -FilePath '\"%cd%\.settings\Matject.lnk\"' -ArgumentList 'murgi' -Verb runAs && exit || (
                                            del /q ".\.settings\runAsAdmin.txt" >nul 2>&1
                                            echo [91m[^^!] Failed to launch Matject as admin.
                                            echo.
                                            echo [93m[*] Disabled "Run as admin always" to allow normal access to Matject.[0m
                                            echo.
                                            echo [*] You may want to open Matject again.
                                            echo.
                                            echo Press any key to exit...
                                            pause >nul
                                            exit /b 1
                        )
                    )
                ) else powershell -NoProfile -Command Start-Process -FilePath 'cmd' -ArgumentList '/k', '\"%cd%\matject.bat\"', 'murgi' -Verb runAs && exit || (
                    del /q ".\.settings\runAsAdmin.txt" >nul 2>&1
                    echo [91m[^^!] Failed to launch Matject as admin.
                    echo.
                    echo [93m[*] Disabled "Run as admin always" to allow normal access to Matject.[0m
                    echo.
                    echo [*] You may want to open Matject again.
                    echo.
                    echo Press any key to exit...
                    pause >nul
                    exit /b 1
                )
            )
        ) else (
            if exist ".settings\matject_icon.ico" (
                if exist ".settings\Matject.lnk" (
                    start /i "Loading..." "%cd%\.settings\Matject.lnk" placebo
                )
            ) else start /b "Loading..." cmd /k "%~f0" placebo
            goto :EOF
        )
    )
)

:: Verify modules
:: All %%h things have two things, lastEightCharactersOfSHA256-FILENAME
:: It checks if the file exists and then compare with its SHA256
if not exist ".settings\disableModuleVerification.txt" (
    cls
    title Matject: Verifying modules...
    set "fileHash="
    echo [93m[*] Verifying modules...[0m
    echo.

    :: Make all *.bat files read only
    if not exist ".settings\dontMakeReadOnly.txt" (
        for %%F in ("matject.bat" ".\.settings\*.vbs" ".\modules\*" ".\modules\matjectNEXT\*.bat") do (attrib +R "%%~fF")   
    )

    for %%h in (292a1b59-about 6e184424-autoject 9f75531d-backupMaterials 3c893fb2-checkMaterialCompatibility fa7954eb-checkUpdates d27259a2-clearVariable 440aa985-colors 8ba9f113-createIcon b2c8441e-createShortcut 235a4d69-getMaterialUpdater 4dc7e9f7-getMatjectAnnouncement 5c847776-getMinecraftDetails 064778a7-help 7a1cdeb1-matjectTips 11b68e22-matjectUpdater da724949-restoreMaterials c6f1e445-settings 7189593e-taskkillLoop a4eca8f5-unlockWindowsApps 53bcbcd2-updateMaterials 2a903b8d-variables 94d7031a-matjectNEXT\cachePacks 6bb94473-matjectNEXT\getJQ 7c371bcb-matjectNEXT\injectMaterials d972f91e-matjectNEXT\listMaterials e9548fdb-matjectNEXT\main 5a3dd67b-matjectNEXT\manifestChecker 89011b0f-matjectNEXT\parsePackVersion d08947bd-matjectNEXT\parsePackWithCache a666004f-matjectNEXT\parseSubpack e3a120e3-matjectNEXT\syncMaterials 77add459-matjectNEXT\testCompatibility) do (
        set "fileToHash=%%h"
        rem echo !fileToHash:~9! = !fileToHash:~0,8!
        if not exist "modules\!fileToHash:~9!.bat" (
            title MODULE NOT FOUND^^!
            cls
            echo [91m[^^!] MODULE IS MISSING.[90m ^(modules\!fileToHash:~9!.bat^)[0m
            echo.
            echo [93m[^^!] Don't try to fix it yourself if you are not smart enough.
            echo     Download Matject again from [96mgithub.com/faizul726/matject[93m instead.[0m
            echo.
            echo Exiting...[?25h
            echo.
            echo on
            @cmd /k
        ) else (
            for /f "tokens=*" %%A in ('certutil -hashfile "modules\!fileToHash:~9!.bat" SHA256 ^| findstr /v ":"') do (
                set "fileHash=%%A"
                if /i "!fileHash:~56,8!" neq "!fileToHash:~0,8!" (
                    title MODULE ISSUE^^!
                    cls
                    echo [91m[^^!] MODULE IS EITHER MODIFIED OR CORRUPTED.[90m ^(modules\!fileToHash:~9!.bat^)[0m
                    echo.
                    echo [93m[^^!] Don't try to fix it yourself if you are not smart enough.
                    echo     Download Matject again from [96mgithub.com/faizul726/matject[93m instead.[0m
                    echo.
                    echo [90mDetails: "!fileHash:~56,8!" NEQ "!fileToHash:~0,8!"[0m
                    echo.
                    echo Exiting...[?25h
                    echo.
                    echo on
                    @cmd /k
                )
            )
        )
    )
    set "fileHash="
    echo [2F[0J[92m[*] All modules are OK^^! ;^)[0m
    timeout 1 >nul
)
::echo. & echo [93mPAUSE FOR TESTING. PRESS ANY KEY TO RESUME...[0m & echo. & pause >nul

:: Change code page to support non-English character
for /f "tokens=4" %%c in ('chcp') do (
    set chcp_default=%%c
    >nul 2>&1 chcp 65001 && set "chcp_failed=" || (
        set chcp_failed=true
        chcp %%c >nul 2>&1
    )
)

:: Load other variables
call "modules\colors"
if exist ".settings\useForMinecraftPreview.txt" (
    set "isPreview= ^(Preview Mode^)"
    set "preview= Preview"
) else (
    set "isPreview="
    set "preview="
)
call "modules\variables"
if exist ".settings\debugMode.txt" (set "debugMode=true") else (set "debugMode=")

:: It's tricky to do logical OR in Windows Batch.
:: So, using weird variable to make sure 'if exist tar' fails.
if not exist "%fallbackToExpandArchive%" (set "tarexe=tar.exe") else (set "tarexe=confused_unga/bunga")


:: SET VERSION AND WINDOW TITLE
::set "dev=-dev ^(20241209^)"
set "version=v3.5.2"
set "title=Matject %version%%dev%%isPreview%"
title %title%


:: WORK DIRECTORY SETUP
if not exist ".settings\" (mkdir .settings)
if not exist "MCPACKS\" (mkdir MCPACKS)
if exist "MCPACKS\put-mcpacks-or-zips-here" (del /q /s ".\MCPACKS\put-mcpacks-or-zips-here" > NUL)
if not exist "MATERIALS\" (mkdir MATERIALS)
if exist "MATERIALS\put-materials-here" (del /q /s ".\MATERIALS\put-materials-here" > NUL)
if exist "tmp\" (rmdir /q /s .\tmp > NUL)
if not defined matbak (
    title VARIABLE ISSUE^^!
    cls
    echo [91m[^^!] Variable issue: matbak[0m
    echo.
    echo Exiting...[?25h
    echo on
    echo.
    @cmd /k
)
if exist ".\Backups%matbak:~7%" (
    if not exist ".\Backups%matbak:~7%\*.material.bin" (
        rmdir /q /s ".\Backups%matbak:~7%"
        rem if exist "%rstrList%" (>nul del /q ".\%rstrList%")
        rem if exist "%lastMCPACK%" del /q /s ".\%lastMCPACK%" >nul
        rem if exist "%lastRP%" del /q /s ".\%lastRP%" >nul
    )
)
if not exist logs (mkdir logs)
if exist %thanksMcbegamerxx954% (
    if not exist "modules\material-updater.exe" (del /q .\%thanksMcbegamerxx954% >nul)
)
where curl >nul 2>&1 || (
    del /q .\%doCheckUpdates% >nul 2>&1
    del /q .\%showAnnouncements% >nul 2>&1
)

if exist %ranOnce% goto firstRunDone
cls
echo !WHT!Welcome to %title%^^!!RST! ^(for the very first time^)
echo.
echo.
echo !ERR!=== Hol' up soldier^^! ===!RST!!YLW!
echo.
echo - Matject is not perfect, bugs may show up. Please report them in the GitHub repo.
echo - It assumes you HAVE NOT made any changes to materials, because it needs a copy of original materials to work properly.
echo !RED!* DO NOT MODIFY .settings, Backups, modules folder.!YLW!
echo - It may not work properly with antivirus read/write protection.
echo !RED!* 3RD PARTY ANTIVIRUS MAY PREVENT IOBIT UNLOCKER FROM WORKING.!YLW!
echo - The worst thing that can happen is material corruption.
echo   !GRY!In that case you can restore materials or reinstall Minecraft without losing data.!YLW!
echo - Deferred/PBR/RTX packs are not supported.
echo - DO NOT MODIFY files while using Matject.
echo - DO NOT USE THIS, IF IT'S NOT FROM !CYN!%githubLink:~8,-1%!YLW!
echo   That's the one and only official source. Avoid using downloading from Google/YouTube.
echo - DO NOT USE Matject on debloated/optimized Windows ^(Atlas/Revi/Tiny/Chris Titus Utility^)
echo - English is not my primary language. So, grammatical errors are expected.!RST!
echo.
echo %showCursor%
set /p "firstRun=Type !RED!yes!RST! and press [Enter] to confirm:!GRN! "
echo %hideCursor%
if "!firstRun!" neq "yes" (
    echo !ERR![^^!] WRONG INPUT!RST!
    %exitmsg%
) else (
    echo !GRN![*] Confirmed.!RST!
    echo First ran by %USERNAME% on: %date% - %time:~0,-6%>"!ranOnce!"
    timeout 2 > NUL
    cls
    echo Matject is somewhat experimental.
    echo So, it's better to use the latest version whenever possible.
    echo.
    echo !YLW![?] Do you want to check for updates at Matject startup?!RST! !YLW!^(requires internet^)!RST!
    echo.
    echo !GRN![Y] Yes, check for updates at Matject startup. !GRY!^(updating is optional^)!RST!
    echo !RED![N] No, do not check for updates.!RST!
    echo.
    echo !GRN![TIP]!RST! You can enable/disable update checking from Matject settings -^> Updates ^& Debug later.
    echo.
    choice /c yn /n >nul
    if !errorlevel! equ 1 echo Thank you for being a regular user of Matject [%date% // %time:~0,-6%]>%doCheckUpdates%
    cls
    echo !YLW![?] Do you want to make shortcuts of Matject? !RED![BETA]!RST!
    echo.
    echo !GRN![Y] Yes !GRY!^(Desktop and Start menu^)
    echo !RED![N] No!RST!
    echo.
    echo !GRN![TIP]!RST! You can add/remove shortcuts from "Remove Shaders/Tools" anytime.!RST!
    echo.
    choice /c yn /n >nul
    if !errorlevel! equ 1 call "modules\createShortcut" all
    cls
    echo !YLW![?] Do you want to get material-updater?!RST!
    echo.
    echo It's a tool made by @mcbegamerxx954.
    echo.
    echo It automatically updates shader files to support latest version.
    echo Also fixes well known "invisible blocks" issue.
    echo.
    echo !GRN![TIP]!RST! You can always enable/disable it from Matject settings later.!RST!
    echo.
    echo !GRN![Y] Yes    !RED![N] No!RST!
    echo.
    choice /c yn /n >nul
    if !errorlevel! equ 1 call "modules\getMaterialUpdater" skip_intro
)

:firstRunDone
if exist %doCheckUpdates% (call "modules\checkUpdates")


if exist "%customIObitUnlockerPath%" (
    set /p IObitUnlockerPathTemp=<%customIObitUnlockerPath%
    echo %hideCursor%>nul
    if exist "!IObitUnlockerPathTemp!\IObitUnlocker.exe" (
        if exist "!IObitUnlockerPathTemp!\IObitUnlocker.dll" (
            set "IObitUnlockerPath=!IObitUnlockerPathTemp!\IObitUnlocker"
            goto iobitUnlockerFound
        )
    )
) else (
    goto checkIObitUnlocker
)
cls
echo !ERR![^^!] Provided custom IObit Unlocker path is invalid^^!!RST!
echo.
echo Press any key to remove...
echo.
pause >nul
call "modules\settings" toggleP2_3

:checkIObitUnlocker
if not exist "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker.exe" (
    cls
    echo !BEL!!RED![^^!] It seems like you don't have IObit Unlocker installed.!RST!
    echo     It's required to use Matject.
    echo.

    echo !YLW![?] Would you like to download now?!RST!
    echo.

    echo [Y] Yes, open the site for me !CYN!^(www.iobit.com/en/iobit-unlocker.php^)!RST!
    echo !RED![B] No, I will download later ^(exit^)!RST!
    echo.
    echo [P] I already have it installed, let me set custom path.
    echo.

    choice /c ybp /n >nul
    cls

    if !errorlevel! equ 1 (start https://www.iobit.com/en/iobit-unlocker.php & exit)
    if !errorlevel! equ 2 (exit)
    if !errorlevel! equ 3 (call "modules\settings" toggleP2_3)
    ) else (set "IObitUnlockerPath=%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker.exe")

:iobitUnlockerFound
if exist "%customMinecraftAppPath%" (
    set /p MCLOCATION=<%customMinecraftAppPath%
    echo %hideCursor%>nul
    if not exist "!MCLOCATION!\AppxManifest.xml" (
        cls
        echo !ERR![^^!] Custom Minecraft app path DOES NOT exist.!RST!
        echo.
        call "modules\getMinecraftDetails"
        if exist %materialUpdaterArg% del /q /s .\%materialUpdaterArg% > NUL
        echo.
        if not exist %disableTips% (
            echo !GRN![TIP]!RST! You may disable custom Minecraft app path in settings to remove this error.
            echo.
        )
        pause
    ) else (
        if exist %oldMinecraftVersion% (
            set /p CURRENTVERSION=<%oldMinecraftVersion%
            set /p OLDVERSION=<%oldMinecraftVersion%
            echo %hideCursor%>nul
        ) else (
            if not defined chcp_failed (>nul 2>&1 chcp %chcp_default%)
            for /f "tokens=*" %%i in ('powershell -NoProfile -command "(Get-AppxPackage -Name Microsoft.%productID%).Version"') do (set "CURRENTVERSION=%%i" & set "OLDVERSION=%%i")
            if not defined chcp_failed (>nul 2>&1 chcp 65001)
        )
    )
) else (
    cls
    call "modules\getMinecraftDetails"
    if exist %oldMinecraftVersion% (set /p OLDVERSION=<%oldMinecraftVersion%)
    echo %hideCursor%>nul
    cls
)

if not exist "%customMinecraftDataPath%" (goto nocustomgamedata)
set /p gameDataTMP=<%customMinecraftDataPath%
echo %hideCursor%>nul
if not exist "!gameDataTMP!\minecraftpe\options.txt" (
    cls
    set "gameDataTMP="
    echo !ERR![^^!] Custom Minecraft data path invalid.!RST!
    echo !RED!If it's correct open the game at least once.
    echo.
    del /q /s ".\%customMinecraftDataPath%" >nul
    echo !YLW![*] Turned off custom Minecraft data path and using default data path.!RST!
    set "gameData=%defaultGameData%"
) else (
    set "gameData=!gameDataTMP!"
    set "gameDataTMP="
)


:nocustomgamedata
if exist "%unlocked%" goto DELETEOLDBACKUP

:: Disabled this part because still unsure if sideloaded installation is actually outside %ProgramFiles%
:: if /i "%MCLOCATION:~0,28%" neq "C:\Program Files\WindowsApps" (
::    echo [%date% // %time:~0,-6%] - This file was created to indicate that WindowsApps is already unlocked and skip the question in Matject.>"%unlocked%"
:: )

if not exist "%unlocked%" (
    cls 
    echo !BEL!!YLW![*] You don't have "%ProgramFiles%\WindowsApps" folder unlocked.!RST!
    echo.
    echo !RED!Without unlocking Matject CANNOT backup materials.!RST!
    echo.
    echo !YLW![?] Do you want to unlock?!RST!
    echo.
    echo !RED![Y] Yes ^(requires admin permission^)
    echo !GRN![N] No  ^(exit^)!RST!
    echo.
    choice /c yn /n >nul
    echo.
    if "!errorlevel!" equ "1" (
        cls
        title %title% ^(unlocking WindowsApps^)
        echo !YLW!!BLINK![*] Unlocking WindowsApps folder...!RST!
        if not defined chcp_failed (>nul 2>&1 chcp %chcp_default%)
        powershell -NoProfile -command Start-Process -File '\"%cd%\modules\unlockWindowsApps.bat\"' -ArgumentList 'murgi' -Verb runas -Wait
        if not defined chcp_failed (>nul 2>&1 chcp 65001)
        echo.
        if not exist %unlocked% (title %title% && echo !ERR![^^!] FAILED. Saved log in .settings\unlockLog.txt. You might need it for finding the issue later.!RST! && %exitmsg%) else (
            echo !GRN![*] Unlocked.!RST!
            timeout 2 >nul
        )
        echo.
        ) else (if "!errorlevel!" equ "2" exit)
)

:DELETEOLDBACKUP
if exist ".settings\backupRunning.txt" (
    cls
    echo !RED![^^!] Last backup was incomplete.!RST!
    echo.
    echo !YLW![*] Making new backup...!RST!
    echo.
    if exist ".\Backups%matbak:~7%" rmdir /q /s ".\Backups%matbak:~7%"
    call "modules\backupMaterials"
)
if exist ".\Backups%matbak:~7%" (
    if "!CURRENTVERSION!" neq "!OLDVERSION!" (
    cls
    echo !RED![^^!] OLD SHADER BACKUP DETECTED.!RST!
    echo.
    echo !YLW![*] Current version: v!CURRENTVERSION!, old version: v!OLDVERSION!.!RST!
    echo.
    if exist %dontRetainOldBackups% (
        echo !YLW![*] Deleting old backup...!RST!
        echo.
        rmdir /q /s ".\Backups%matbak:~7%"
    ) else (
        echo !YLW![*] Renaming old backup...!RST!
        echo.
        rename ".\Backups%matbak:~7%" "Old Materials Backup (v!OLDVERSION!)"
    )
    if exist %materialUpdaterArg% del /q /s .\%materialUpdaterArg% > NUL
    if exist ".settings\taskOngoing.txt" del /q /s ".\.settings\taskOngoing.txt" >nul
    if exist "%rstrList%" del /q /s ".\%rstrList%" >nul
    if exist "%lastMCPACK%" del /q /s ".\%lastMCPACK%" >nul
    if exist "%lastRP%" del /q /s ".\%lastRP%" >nul
    if exist "%backupDate%" del /q /s ".\%backupDate%" >nul
    echo !CURRENTVERSION!>%oldMinecraftVersion%
    call "modules\backupMaterials"
    timeout 2 > NUL
    )
) else (
    cls
    call "modules\backupMaterials"
)

rem for /f "tokens=2 delims==" %%a in ('"wmic os get localdatetime /value"') do (
rem     set "deiteu=%%a"
rem     set /a "imy=!deiteu:~2,2!-21"
rem     set "deiteu=!deiteu:~4,4!"
rem )

if exist %disableInterruptionCheck% (
    if exist ".settings\taskOngoing.txt" del /q /s ".\.settings\taskOngoing.txt" >nul
    goto skipInterruptionCheck
)
if exist ".settings\taskOngoing.txt" (
    cls
    echo !BEL!!YLW![*] Seems like last injection didn't go well...
    echo.
    echo [?] Do you want to perform a Full Restore?!RST!
    echo.
    echo !GRN![Y] Yes    !RED![N] No!RST!
    choice /c yn /n >nul
    echo.

    if !errorlevel! equ 1 (
        cls
        set "RESTORETYPE=full"
        call "modules\restoreMaterials"
    ) else if !errorlevel! equ 2 (
        cls
        echo !RED![^^!] Matject may not work as expected if you don't perform a Full Restore...!RST!
        del /q /s ".\.settings\taskOngoing.txt" >nul
        timeout 3 >nul
    )
)

:skipInterruptionCheck
if exist %defaultMethod% (
    cls
    set /p selectedMethod=<%defaultMethod%
    echo %hideCursor%!YLW![*] Opening !selectedMethod! method in 2 seconds...!RST!
    echo.
    echo !YLW!    Press [S] to open settings directly...!RST!
    choice /c s0 /t 2 /d 0 /n >nul
    if !errorlevel! equ 1 goto option6
    cls
    goto !selectedMethod!
)


:INTRODUCTION
set "usingCustomPath="
cls
if defined isAdmin (set "isAdmin=Running as admin. ")
if exist "%customMinecraftAppPath%"  (set usingCustomPath=true)
if exist "%customMinecraftDataPath%" (set usingCustomPath=true)
if exist "%customIObitUnlockerPath%" (set usingCustomPath=true)

if exist "%useForMinecraftPreview%" (
    if defined usingCustomPath (
        echo !GRY![*] %isAdmin%Using for Minecraft Preview with custom path^(s^) enabled.!RST!
    ) else (
        echo !GRY![*] %isAdmin%Using for Minecraft Preview.!RST!
    )
    echo.
) else (
    if defined usingCustomPath (
        echo !GRY![*] %isAdmin%Custom path^(s^) enabled.!RST!
        echo.
    ) else if defined isAdmin (
        echo !GRY![*] %isAdmin%!RST!
        echo.
    )
)

if exist "%lastMCPACK%" (
    set /p tmp_lastMCPACK=<%lastMCPACK%
    echo %hideCursor%>nul
    set "tmp_lastMCPACK=!GRY!^(Last injected: !tmp_lastMCPACK!^)!RST!"
) else (set "tmp_lastMCPACK=")

rem if "%deiteu%" equ "0726" echo !BLU!Happy birthday rwxrw-r-- U+1F337 ^(%imy%^)!RST!
set RESTORETYPE=
:: HOME SWEET HOME
:: START SCREEN
:: INIT
if %time:~0,2% geq 00 if %time:~0,2% lss 05 echo !WHT!You should sleep now.
if %time:~0,2% geq 05 if %time:~0,2% lss 12 echo !WHT!Good morning,
if %time:~0,2% geq 12 if %time:~0,2% lss 18 echo !WHT!Good afternoon,
if %time:~0,2% geq 18 if %time:~0,2% lss 22 echo !WHT!Good evening,
if %time:~0,2% geq 22 if %time:~0,2% lss 24 echo !WHT!Good night,
echo Welcome to %title: ^(Preview Mode^)=%^^!!RST! ^| !CYN!%githubLink:~8,-1%!RST!
echo.
if not exist %disableTips% (call modules\matjectTips)
if exist %showAnnouncements% (
    echo !GRN![Announcement]!RST! Loading...
    call modules\getMatjectAnnouncement
)
echo.

echo !YLW![?] Which method would you like to use?!RST!
echo.

echo !GRN![1] Auto!RST! %tmp_lastMCPACK%
echo     Put MCPACK/ZIP file in the MCPACKS folder.
echo     Matject will extract materials and ask you to inject.
echo.
echo !BLU![2] Manual!RST!
echo     Put .material.bin files in the MATERIALS folder.
echo     Matject will ask you to inject provided materials. 
echo.
echo !RED![3] matjectNEXT [BETA]!RST!
echo     Draco for Windows but not really.
echo.

echo.
echo !WHT![H] Help    [A] About    [S] Matject Settings    [R] Remove Shaders/Tools!RST!
echo.
echo !RED![B] Exit!RST!
echo.
echo !YLW!Press corresponding key to confirm your choice...!RST!
echo.
choice /c 123hasrb /n >nul

goto option!errorlevel!

:: OTHER OPTIONS

:option8
exit

:option7
cls
echo !RED!^< [B] Back!RST!
::echo !RED!^< [B] Back !RST!^| !WHT!Home -^> Tools!RST!
echo.
echo [1] Remove shaders / Restore default materials
echo [2] Open Minecraft app folder
echo [3] Open Minecraft data folder
echo.
echo !GRN![4] View Matject on GitHub :^)
echo !WHT![5] Visit jq website
echo [6] View material-updater on mcbegamerxx954's GitHub
echo !RST!
echo [7] Create shortcuts ^(desktop/start menu^) !RED![BETA]!WHT!
echo !GRY![8] Replace backup from ZIP file ^(use this if you don't have original materials to start with^)
echo [9] Reset Global Resource Packs ^(use this if you want to deactivate all active packs^)
echo [M] Manifest checker + fix ^(from matjectNEXT^)
if defined debugMode echo [L] Drop to shell
echo !RST!
echo !YLW!Press corresponding key to confirm your choice...!RST!
echo.
choice /c 123456789lbm /n >nul
goto others!errorlevel!

:others12
cls
call "modules\matjectNEXT\manifestChecker" && echo Press any key to go back... & pause >nul
goto option7

:others11
goto INTRODUCTION

:others10
if defined debugMode (
    cls
    echo !YLW![*] Dropped to shell.!RST!
    echo %showCursor%
    echo on
    @cmd
) else (goto option7)

:others9
cls
echo !BEL!!YLW![?] Are you sure? This will deactivate all active global resource packs.!RST!
echo.
echo !RED![Y] Yes    !GRN![N] No, go back!RST!
echo.
choice /c yn /n >nul
if !errorlevel! neq 1 (goto option7)
if exist "%gameData%\minecraftpe\global_resource_packs.json" (del /q /s "%gameData%\minecraftpe\global_resource_packs.json" >nul && echo []>"%gameData%\minecraftpe\global_resource_packs.json") else (echo []>"%gameData%\minecraftpe\global_resource_packs.json")
goto option7

:others8
cls
if exist %backupDate% set /p backupTimestamp=<%backupDate%
echo %hideCursor%>nul
echo !WHT![*] Add materials backup ZIP file in !YLW!"%cd%\%matbak:~0,-19%"!WHT!.
echo.
echo !RED![^^!] DO NOT ADD MULTIPLE ZIP FILES.
echo     Current backup from "!backupTimestamp!" will be replaced.!RST!
echo.
echo [*] Don't have any backup file? Get from !CYN!mcpebd.github.io/mats!RST!. !GRY!It will go back if no backup file is found.!RST!
echo.
start "" /i explorer "%cd%\%matbak:~0,-19%"
echo When done,
pause
echo.
if not exist "%matbak:~0,-19%\*.zip" (
    echo !RED![^^!] No backup file found^^!!RST!
    %backmsg:EOF=option7%
) else (
    set "backupFileCount="
    for %%F in ("%matbak:~0,-19%\*.zip") do (
        set /a backupFileCount+=1
        set "backupFile=%%~nxF"
    )
)
:bkpFound
if !backupFileCount! neq 1 (
    echo !ERR![^^!] Multiple ZIP files found^^!!RST!
    echo !RED!Put only 1 ZIP file in "%cd%\%matbak:~0,-19%".!RST!
    %backmsg:EOF=option7%
)
cls
echo !GRN![*] Found backup file:!RST! !backupFile!
echo.
if not exist "%disableConfirmation%" (
    echo !YLW![?] Would you like to use it to replace current backup?!RST!
    echo.
    echo !RED![^^!] Current backup from !backupTimestamp! will be replaced.!RST!
    echo.
    echo.
    echo !RED![Y] Yes    !GRN![N] No, go back!RST!
    echo.
    choice /c yn /n >nul
    if !errorlevel! equ 2 (
        set "backupFileCount="
        set "backupFile="
        goto option7
    )
)
echo !YLW!!BLINK![*] Extracting the backup...!RST!
echo.
if exist ".\Backups%matbak:~7%" (del /q /s ".\Backups%matbak:~7%\*" >nul) else (mkdir ".\Backups%matbak:~7%")
if exist "%backupDate%" del /q /s ".\%backupDate%" >nul
if exist "%SYSTEMROOT%\system32\%tarexe%" (
    tar -xf "%matbak:~0,-19%\!backupFile!" -C ".\Backups%matbak:~7%"
) else (
    if not defined chcp_failed (>nul 2>&1 chcp %chcp_default%)
    powershell -NoProfile -Command "Expand-Archive -Force '%matbak:~0,-19%\!backupFile!' '.\Backups%matbak:~7%'"
    if not defined chcp_failed (>nul 2>&1 chcp 65001)
)
if exist ".\Backups%matbak:~7%\*.material.bin" (
    echo !GRN![*] Successfully replaced backup from !backupFile!.!RST!
    echo %date% // %time:~0,-6%>%backupDate%
    echo.
    pause
) else (
    echo !RED![^^!] Failed to get materials from backup.
    echo     Maybe not an actual materials ZIP?!RST!
    %backmsg:~0,56%
    del /q /s ".\Backups%matbak:~7%\*" >nul
)
set "backupFile="
goto option7

:others7
cls
echo Loading...
call "modules\createShortcut"
goto option7

:others6
start https://github.com/mcbegamerxx954/material-updater
goto option7

:others5
start https://jqlang.github.io/jq/
goto option7

:others4
start %githubLink%
goto option7

:others3
start "" /i explorer "%localAppData%\packages\Microsoft.%productID%_8wekyb3d8bbwe\LocalState\games\com.mojang"
goto option7 

:others2
start "" /i explorer "!MCLOCATION!"
goto option7

:others1
if defined isAdmin (call "modules\restoreMaterials") else (
    if exist "%runIObitUnlockerAsAdmin%" (
        cls
        echo !YLW!!BLINK![*] Starting "Restore default materials" as admin...!RST!
        if exist "tmp\" (del /q .\tmp\* >nul) else (mkdir tmp)
        (
            echo :: This file was created to pass some of the current variables to restoreMaterials.bat [%date% // %time:~0,-6%]
            echo.
            echo set "backupDate=!backupDate!"
            echo set "debugMode=!debugMode!"
            echo set "exitmsg=!exitMsg!"
            echo set "IObitUnlockerPath=!IObitUnlockerPath!"
            echo set "isPreview=!isPreview!"
            echo set "lastMCPACK=!lastMCPACK!"
            echo set "lastRP=!lastRP!"
            echo set "matbak=!matbak!"
            echo set "MCLOCATION=!MCLOCATION!"
            echo set "restoreDate=!restoreDate!"
            echo set "rstrList=!rstrList!"
            echo set "uacfailed=!uacfailed!"
        )>tmp\adminVariables_restoreMaterials.bat
        if not defined chcp_failed (>nul 2>&1 chcp %chcp_default%)
        powershell -NoProfile -Command Start-Process -FilePath '\"%cd%\modules\restoreMaterials.bat\"' -ArgumentList 'placebo3' -Verb runAs -Wait || (
            if not defined chcp_failed (>nul 2>&1 chcp 65001)
            echo !RED![^^!] Failed to start "Restore default materials" as admin.!RST!
            echo.
            echo !YLW![*] Disabled "Run IObit Unlocker as admin" and starting normally...!RST!
            echo.
            >nul del /q ".\%runIObitUnlockerAsAdmin%"
            timeout 3 >nul
            call "modules\restoreMaterials"
        )
        if not exist ".\Backups%matbak:~7%\*.material.bin" (exit)
    ) else (call "modules\restoreMaterials")
)
goto option7

:: HOME OPTIONS

:option6
cls
echo Loading...
call "modules\settings"
title %title%
goto INTRODUCTION

:option5
cls
echo Loading...
call "modules\about"
title %title%
goto INTRODUCTION

:option4
cls
echo Loading...
call "modules\help"
title %title%
goto INTRODUCTION

:option3
cls
echo Loading...
:matjectNEXT
call "modules\matjectNEXT\main"
title Matject %version%%dev%%isPreview%

goto INTRODUCTION

:option1
:auto
cls
echo !YLW![AUTO METHOD SELECTED]!RST!
echo.
echo.
echo.

echo !YLW![^^!] Please add desired MCPACK/ZIP file in the MCPACKS folder.!RST!
echo.
if not exist %dontOpenFolder% (
    if not exist %disableTips% (echo !GRN![TIP]!RST! You can disable auto folder opening from Matject settings.)
)
echo.
if not exist %disableTips% (echo !GRN![TIP]!RST! You can put multiple MCPACK/ZIP files in the "MCPACKS" folder.)
echo.

if not exist "%dontOpenFolder%" (start "" /i explorer "%cd%\MCPACKS")

echo After adding,
pause



:AUTOLIST
call "modules\clearVariable" auto_all
if not exist "tmp\" mkdir tmp
del /q /s ".\tmp\mcpackChooser.bat" >nul 2>&1
for %%f in ("MCPACKS\*.mcpack") do (
    set /a MCPACKCOUNT+=1
    set "selected_mcpack=%%f"
    set "MCPACKNAME=%%~nxf"
    set "tmp_mcpacknames=!tmp_mcpacknames! ^& echo !WHT!!MCPACKCOUNT!. !RST!%%~nf!GRY!%%~xf!RST!"
    echo if %%1 equ !MCPACKCOUNT! set "selected_mcpack=%%f" ^& set "MCPACKNAME=!MCPACKNAME!">>tmp\mcpackChooser.bat
)
set "tmp_mcpacknames=!tmp_mcpacknames! ^& echo."
for %%f in ("MCPACKS\*.zip") do (
    set /a MCPACKCOUNT+=1
    set "selected_mcpack=%%f"
    set "MCPACKNAME=%%~nxf"
    set "tmp_mcpacknames=!tmp_mcpacknames! ^& echo !WHT!!MCPACKCOUNT!. !RST!%%~nf!GRY!%%~xf!RST!"
    echo if %%1 equ !MCPACKCOUNT! set "selected_mcpack=%%f" ^& set "MCPACKNAME=!MCPACKNAME!">>tmp\mcpackChooser.bat
)

if not defined MCPACKCOUNT (
    call "modules\clearVariable" auto_all
    cls
    echo !ERR![^^!] NO MCPACK/ZIP FOUND.!RST!
    echo.

    echo !YLW![*] Please add at least 1 MCPACK/ZIP file in the MCPACKS folder and try again.!RST!
    %backmsg:EOF=INTRODUCTION%
)

if %MCPACKCOUNT% equ 1 (goto foundmcpack)
cls
set "tmp_input="
set "selected_mcpack="
echo !YLW![*] Multiple MCPACK/ZIP found.!RST!
echo.
%tmp_mcpacknames:~2%
echo %showCursor%
set /p "tmp_input=!YLW!Choose a MCPACK/ZIP by entering its number !GRY!^(leave blank to go back^)!RST!: "
echo %hideCursor%
if defined tmp_input (call tmp\mcpackChooser.bat %tmp_input: =%) else (call "modules\clearVariable" auto_all& echo [*] Returning to main screen... & timeout 1 >nul & goto INTRODUCTION)
if not defined selected_mcpack (
    call "modules\clearVariable" auto_all
    echo !RED![^^!] Invalid input.
    echo     Only number from the list is accepted.!RST!
    rmdir /q /s ".\tmp"
    %backmsg:EOF=INTRODUCTION%
)

if defined chcp_failed (
    echo !selected_mcpack! | findstr /C:"?" >nul
    if !errorlevel! equ 0 (
        call "modules\clearVariable" auto_all
        cls
        echo !RED![^^!] File name seems to contain non-English character.!RST!
        echo.
        echo !YLW![*] Please fix the file name and try again.!RST!
        rmdir /q /s ".\tmp"
        %backmsg:EOF=INTRODUCTION%
    )
)

:foundmcpack
cls
echo !GRN![*] Selected MCPACK/ZIP: "!MCPACKNAME!"!RST!
if exist %disableConfirmation% goto AUTOEXTRACT
echo.
echo.
echo !YLW![?] Would you like to use it for injecting?!RST!
echo.
echo !WHT![Y] Yes    [N] No, go back!RST!
echo.
set "MCPACKCOUNT=" & set "tmp_input=" & set "tmp_mcpacknames="

choice /c yn /n >nul

if !errorlevel! neq 1 (
    call "modules\clearVariable" auto_all
    cls
    goto INTRODUCTION
)



:AUTOEXTRACT
set "MCPACKDIR="
copy /d "!selected_mcpack!" "tmp\mcpack.zip" > NUL
echo.
echo.
echo.

echo !YLW!!BLINK![*] Extracting MCPACK/ZIP to temporary folder...!RST!
echo.

if exist "%SYSTEMROOT%\system32\%tarexe%" (
    tar -xf "tmp\mcpack.zip" -C "tmp"
) else (
    if not defined chcp_failed (>nul 2>&1 chcp %chcp_default%)
    powershell -NoProfile -command "Expand-Archive -LiteralPath 'tmp\mcpack.zip' -DestinationPath 'tmp'"
    if not defined chcp_failed (>nul 2>&1 chcp 65001)
)
timeout 1 >nul

:: del /q /s tmp\mcpack.zip >nul
set "manifestFound="
set "MCPACKDIR="
if exist "tmp\*.material.bin" (
    set "MCPACKDIR=tmp"
    mkdir "!MCPACKDIR!\renderer\materials"
    move /Y ".\tmp\*.material.bin" "!MCPACKDIR!\renderer\materials\" >nul 2>&1
    goto packokay
)
if exist "tmp\manifest.json" (
    set "manifestFound=true"
    if exist "tmp\renderer\materials\*.material.bin" (
        set "MCPACKDIR=tmp"
        goto packokay
    ) else (
        if exist "tmp\subpacks" (
            for /d %%z in ("tmp\subpacks\*") do (
                if exist "%%z\renderer\materials\*.material.bin" set "MCPACKDIR=tmp" & goto packokay
            )
        )
        echo !ERR![^^!] Not a RenderDragon shader.!RST!
        goto invalidpack
    )
) else for /d %%f in ("tmp\*") do (
    if exist "%%f\manifest.json" (
        set "manifestFound=true"
        if exist "%%f\renderer\materials\*.material.bin" (
            set "MCPACKDIR=%%f"
            goto packokay
        ) else (
            if exist "%%f\subpacks" (
                for /d %%z in ("%%f\subpacks\*") do (
                    if exist "%%z\renderer\materials\*.material.bin" set "MCPACKDIR=%%f" & goto packokay
                )
            )
            echo !ERR![^^!] Not a RenderDragon shader.!RST!
            goto invalidpack
        )
    )
)

if not defined manifestFound (
    echo !ERR![^^!] Not a valid MCPACK^^!!RST!
    set "manifestFound="
    goto invalidpack
)

:invalidpack
call "modules\clearVariable" auto_all
echo.
echo !YLW![*] Please add a valid MCPACK/ZIP file in the MCPACKS folder and try again.!RST!
rmdir /q /s ".\tmp"
%backmsg:EOF=INTRODUCTION%

:packokay
if exist "MATERIALS\*.material.bin" del /q /s ".\MATERIALS\*.material.bin" >nul
del /q /s ".\tmp\subpackChooser.bat" >nul 2>&1
if exist "!MCPACKDIR!\subpacks\" (
    set "tmp_subpack_counter=" & set "tmp_subpacknames=" & set "selected_subpack=" & set "tmp_input="
    for /d %%F in ("!MCPACKDIR!\subpacks\*") do (goto autoGetSubpacks)
    goto moveMaterials
    :autoGetSubpacks
    for /d %%F in ("!MCPACKDIR!\subpacks\*") do (
        set /a tmp_subpack_counter+=1
        set "tmp_subpacknames=!tmp_subpacknames! ^& echo !WHT!!tmp_subpack_counter!. !RST!%%~nF"
        echo if %%1 equ !tmp_subpack_counter! set selected_subpack=%%~nF>>tmp\subpackChooser.bat
    )
    cls
    echo !YLW![*] Subpack^(s^) found.!RST!
    echo.
    %tmp_subpacknames:~2%
    echo.
    echo !WHT![*] Chosen MCPACK/ZIP:!RST! !MCPACKNAME!
    echo.
    if not exist %disableTips% (
        echo !GRN![TIP]!RST! Subpack is what you select from pack settings ^(gear icon^) in global resource packs. 
        echo       You can take a look at manifest.json to find what each subpack does.
        echo       If you are unsure, you can select any one subpack.
        echo       MAKE SURE TO select the same subpack from setting of the shader after injecting to ensure consistency.
    )
    echo %showCursor%
    set /p "tmp_input=!YLW!Choose a subpack by entering its number !GRY!^(leave blank to go back OR !WHT!/skip!GRY! to skip subpack^)!RST!: "
    echo %hideCursor%
    if /i "%tmp_input: =%" equ "/skip" (goto moveMaterials)
    echo.
    set "tmp_subpack_counter=" & set "tmp_subpacknames=" & set "selected_subpack="
    if defined tmp_input (call tmp\subpackChooser.bat %tmp_input: =%) else (echo [*] Returning to main screen... & timeout 1 >nul & goto INTRODUCTION)
    if not defined selected_subpack (
        echo !RED![^^!] Invalid input.
        echo     Only number from the list is accepted.!RST!
        rmdir /q /s ".\tmp"
        %backmsg:EOF=INTRODUCTION%
    )
)
:moveMaterials
move /Y "!MCPACKDIR!\renderer\materials\*.material.bin" ".\MATERIALS\"  >nul 2>&1
if defined selected_subpack (
    move /Y "!MCPACKDIR!\subpacks\!selected_subpack!\renderer\materials\*.material.bin" ".\MATERIALS" >nul 2>&1
)
goto SEARCH



:option2
:manual
cls
echo !YLW![MANUAL METHOD SELECTED]!RST!
echo.
echo.
echo.

echo !YLW!Please add ".material.bin" files in the "MATERIALS" folder.!RST!
echo.
if not exist %dontOpenFolder% (
    if not exist %disableTips% (echo !GRN![TIP]!RST! You can disable auto folder opening from Matject settings.)
)
echo.

if not exist "%dontOpenFolder%" (start "" /i explorer "%cd%\MATERIALS")

echo After adding,
pause



:SEARCH
cls
set SRCLIST=
set SRCCOUNT=
set REPLACELIST=
set REPLACELISTEXPORT=
set MTBIN=
set BINS=

echo !YLW![*] Looking for *.material.bin files in the "MATERIALS" folder...!RST!

for %%m in ("MATERIALS\*.material.bin") do (set /a SRCCOUNT+=1)
if defined SRCCOUNT goto matsfound

echo [1F[0J!ERR![^^!] NO MATERIALS FOUND.!RST!
echo.
echo !YLW![*] Please add *.material.bin files the MATERIALS folder and try again.!RST!
if exist "tmp\" rmdir /q /s ".\tmp"
%backmsg:EOF=INTRODUCTION%

:matsfound
echo [1F[0J!GRN![*] Found !SRCCOUNT! material(s) in the "MATERIALS" folder.!RST!
echo.
if exist "%disableMatCompatCheck%" goto skip_matcheck
call "modules\checkMaterialCompatibility"
if !errorlevel! neq 0 (
    echo [1F[0J!ERR![^^!] Given shader is not for Windows.!RST!
    echo.
    echo !WHT!Chosen MCPACK/ZIP:!RST! !MCPACKNAME!
    del /q /s ".\MATERIALS\*.material.bin" >nul
    if exist "tmp" (rmdir /q /s ".\tmp" >nul)
    %backmsg:EOF=INTRODUCTION%
)
:skip_matcheck

for %%f in ("MATERIALS\*.material.bin") do (
    set "MTBIN=%%~nf"
    set SRCLIST=!SRCLIST!,"%cd%\%%f"
    set "BINS=!BINS!"_!MTBIN:~0,-9!-" "
    set REPLACELIST=!REPLACELIST!,"_!MTBIN:~0,-9!-"
)

set "SRCLIST=%SRCLIST:~1%"
set "REPLACELIST=%REPLACELIST:~1%"
set "REPLACELISTEXPORT=%REPLACELIST%"

set "REPLACELIST=%REPLACELIST:-=.material.bin%"
set "REPLACELIST=%REPLACELIST:_=!MCLOCATION!\data\renderer\materials\%"
if exist %disableConfirmation% (
    echo !YLW![*] Injecting now...!RST!
    timeout 2 >nul
    goto INJECTIONCONFIRMED
)
if defined selected_mcpack (
    echo !WHT!Chosen MCPACK/ZIP:!RST! !MCPACKNAME!
    if defined selected_subpack (echo !WHT!Chosen subpack:!RST! %selected_subpack%)
    rem else (echo !WHT!Chosen subpack: !GRY!^<not applicable^>!RST!)
    if "!tmp_input: =!" equ "/skip" (echo. & echo !YLW![*] Subpack skipped.!RST!)
    echo.
)
echo !WHT!Minecraft%preview% location:!RST! !MCLOCATION!
echo !WHT!Minecraft%preview% version:!RST!  v!CURRENTVERSION!
echo.
echo -------- Material list --------
for %%f in ("MATERIALS\*.material.bin") do (
    echo * %%~nxf
)
echo -------------------------------
echo.



:INJECTCONSENT
echo !BEL!!YLW![?] Do you want to proceed with injecting?!RST!
echo.
echo !RED![Y] Yes    !BLU![R] Refresh list    !GRN![N] No, go back!RST!
echo.

choice /c yrn /n >nul

if !errorlevel! equ 1 goto INJECTIONCONFIRMED
if !errorlevel! equ 2 goto SEARCH
if !errorlevel! equ 3 (
    if defined selected_mcpack del /q /s ".\MATERIALS\*.material.bin" >nul
    call "modules\clearVariable" auto_all
    if exist "tmp\" rmdir /q /s ".\tmp"
    goto INTRODUCTION
)



:INJECTIONCONFIRMED
cls
echo !YLW![INJECTION CONFIRMED]!RST!
echo.
if defined selected_mcpack (
    if defined selected_subpack (
        echo !YLW![*] Injecting:!RST! !MCPACKNAME! + !selected_subpack!
    ) else (
        echo !YLW![*] Injecting:!RST! !MCPACKNAME!
    )
    echo.
)

if exist "%thanksMcbegamerxx954%" call "modules\updateMaterials"
if exist "tmp\" (del /q .\tmp\* >nul) else (mkdir tmp)
echo.
echo.

if defined isAdmin (call "modules\autoject") else (
    if exist "%runIObitUnlockerAsAdmin%" (
        echo !YLW!!BLINK![*] Starting IObit Unlocker as admin...!RST!
        echo.
        (
            echo :: This file was created to pass some of the current variables to autoject.bat [%date% // %time:~0,-6%]
            echo.
            echo set "backupDate=!backupDate!"
            echo set "debugMode=!debugMode!"
            echo set "exitmsg=!exitMsg!"
            echo set "IObitUnlockerPath=!IObitUnlockerPath!"
            echo set "isPreview=!isPreview!"
            echo set "lastMCPACK=!lastMCPACK!"
            echo set "lastRP=!lastRP!"
            echo set "matbak=!matbak!"
            echo set "MCLOCATION=!MCLOCATION!"
            echo set "MCPACKNAME=!MCPACKNAME!"
            echo set "REPLACELIST=!REPLACELIST!"
            echo set "REPLACELISTEXPORT=!REPLACELISTEXPORT!"
            echo set "restoreDate=!restoreDate!"
            echo set "rstrList=!rstrList!"
            echo set "selected_mcpack=!selected_mcpack!"
            echo set "selected_subpack=!selected_subpack!"
            echo set "SRCLIST=!SRCLIST!"
            echo set "thanksMcbegamerxx954=!thanksMcbegamerxx954!"
            echo set "uacfailed=!uacfailed!"
        )>tmp\adminVariables_autoject.bat
        if not defined chcp_failed (>nul 2>&1 chcp %chcp_default%)
        powershell -NoProfile -Command Start-Process -FilePath '\"%cd%\modules\autoject.bat\"' -ArgumentList 'placebo2' -Verb runAs -Wait || (
            if not defined chcp_failed (>nul 2>&1 chcp 65001)
            echo !RED![^^!] Failed to launch IObit Unlocker as admin.!RST!
            echo.
            echo !YLW![*] Disabled "Run IObit Unlocker as admin" and running injection normally...!RST!
            echo.
            >nul del /q ".\%runIObitUnlockerAsAdmin%"
            call "modules\autoject"
        )
    ) else (call "modules\autoject")
)

:SUCCESS
cls
echo !GRN![*] INJECTION SUCCEED.!RST!
echo.

if exist %autoOpenMCPACK% (
    if defined manifestFound (
        if /i "!MCPACKNAME:~-7,7!" equ ".mcpack" (start /i "" "MCPACKS\!MCPACKNAME!") else (
            mkdir tmp
            copy /d "MCPACKS\!MCPACKNAME!" "tmp\!MCPACKNAME!.mcpack" >nul
            start /i "" "tmp\!MCPACKNAME!.mcpack"
        )
    ) else (goto skip)
) 

if not exist %autoOpenMCPACK% (
    if not defined manifestFound (goto skip)
    echo !YLW![?] Do you want to import the MCPACK for full experience?!RST!
    echo     !GRY!Note: This will open MCPACK with currently associated app.!RST!
    echo.
    echo !GRN![Y] Yes    !RED![N] No!RST!
    echo.
    choice /c yn /n >nul
    echo.
    if "!errorlevel!" equ "2" goto skip

    if not exist %disableTips% (echo !GRN![TIP]!RST! You can enable Auto open MCPACK from Matject settings.)
    echo.
    if defined manifestFound (
        if /i "!MCPACKNAME:~-7,7!" equ ".mcpack" (start /i "" "MCPACKS\!MCPACKNAME!") else (
            mkdir tmp
            copy /d "MCPACKS\!MCPACKNAME!" "tmp\!MCPACKNAME!.mcpack" >nul
            start /i "" "tmp\!MCPACKNAME!.mcpack"
        )
    )
)

:skip
if not exist %disableTips% (
    echo !GRN![TIP]!RST! Activate the shader resource pack for full experience.
    echo       If you selected a subpack, it's better to select the same from shader settings. ^(gear icon in resource pack^)
    echo.
    echo.
)
if exist %disableSuccessMsg% (
    timeout 1 > NUL
    exit
)

echo !GRN!Thanks for using Matject, have a good day.!RST!
%exitmsg%