:: A material replacer for Minecraft.
:: Made by github.com/faizul726, licence issued by YSS Group
:: https://faizul726.github.io/matject

@echo off
setlocal enabledelayedexpansion

:: Initial setup
title Loading...
cls
echo [?25lLoading...
pushd "%~dp0"
set "murgi=KhayDhan"

:: This script uses ANSI escape codes for text formatting.
:: "" = Hex 0x1B / Decimal 27
:: https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
:: Mostly referenced as variables from "modules\colors.bat"
:: Although I used raw escape codes in some places.

:: Starting from v3.5.2, I also added BEL symbol "" = Hex 0x07 / Decimal 7 
:: Which just plays 'Windows Foreground.wav' or 'Critical Stop' or 'beep' in some confirmation screens.

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
if defined comspec (
    if /i "%comspec:~-8,8%" neq "\cmd.exe" (
        :comspec_error
        cls
        echo [91m[^^!] Matject is not compatible with your PC.
        echo     Reason: %%ComSpec%% environment variable doesn't use cmd.exe
        echo     DO NOT TRY TO FIX IT YOURSELF.[0m
        echo.
        echo Exiting...[?25h
        echo.
        endlocal
        echo on
        @cmd /k
    )
) else (
    goto comspec_error
)

:: Made possible thanks to https://stackoverflow.com/a/19777616
>nul 2>&1 where /? || (
    cls
    echo [91m[^^!] Matject is not compatible with your PC.
    echo     Reason: 'where' is missing.
    echo     DO NOT TRY TO ADD IT YOURSELF.[0m
    echo.
    echo Exiting...[?25h
    echo.
    endlocal
    echo on
    @cmd /k
)

:: Made possible thanks to https://stackoverflow.com/a/4781795
rem set "where_exists="
rem for %%X in (where.exe) do (set "where_exists=%%~$PATH:X")
rem if not defined where_exists goto where_error

>nul 2>&1 where certutil || (
    cls
    echo [91m[^^!] Matject is not compatible with your PC.
    echo     Reason: 'certutil' is missing.
    echo     DO NOT TRY TO ADD IT YOURSELF.[0m
    echo.
    echo Exiting...[?25h
    echo.
    endlocal
    echo on
    @cmd /k
)

>nul 2>&1 where findstr || (
    cls
    echo [91m[^^!] Matject is not compatible with your PC.
    echo     Reason: 'findstr' is missing.
    echo     DO NOT TRY TO ADD IT YOURSELF.[0m
    echo.
    echo Exiting...[?25h
    echo.
    endlocal
    echo on
    @cmd /k
)

>nul 2>&1 where find || (
    cls
    echo [91m[^^!] Matject is not compatible with your PC.
    echo     Reason: 'find' is missing.
    echo     DO NOT TRY TO ADD IT YOURSELF.[0m
    echo.
    echo Exiting...[?25h
    echo.
    endlocal
    echo on
    @cmd /k
)

>nul 2>&1 where clip || (
    cls
    echo [91m[^^!] Matject is not compatible with your PC.
    echo     Reason: 'clip' is missing.
    echo     DO NOT TRY TO ADD IT YOURSELF.[0m
    echo.
    echo Exiting...[?25h
    echo.
    endlocal
    echo on
    @cmd /k
)

>nul 2>&1 where forfiles || (
    cls
    echo [91m[^^!] Matject is not compatible with your PC.
    echo     Reason: 'forfiles' is missing.
    echo     DO NOT TRY TO ADD IT YOURSELF.[0m
    echo.
    echo Exiting...[?25h
    echo.
    endlocal
    echo on
    @cmd /k
)

rem >nul 2>&1 where msg || (
rem    cls
rem    echo [91m[^^!] Matject is not compatible with your PC.
rem    echo     Reason: 'msg' is missing.
rem    echo     DO NOT TRY TO ADD IT YOURSELF.[0m
rem    echo.
rem    echo Exiting...[?25h
rem    echo.
rem    endlocal
rem    echo on
rem    @cmd /k
rem )

>nul 2>&1 where powershell || (
    cls
    echo [91m[^^!] Matject is not compatible with your PC.
    echo     Reason: Mandatory component 'PowerShell' is missing.
    echo     DO NOT TRY TO ADD IT YOURSELF.[0m
    echo.
    echo Exiting...[?25h
    echo.
    endlocal
    echo on
    @cmd /k
)

echo %cd% | findstr /C:"Local\Temp" /I >nul && (
    title EXTRACT FIRST^^!
    cls
    echo [93m[^^!] Are you trying to run Matject without extracting?
    echo     You have to extract it first^^![0m
    echo.
    echo Exiting...[?25h
    echo.
    endlocal
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
    endlocal
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
            >nul 2>&1 (wmic /locale:ms_409 service where ^(name="LanManServer"^) get state /value 2>nul | findstr /i "State=Running" >nul 2>&1)
            if %errorlevel% equ 0 (
                >nul 2>&1 net session && (set isAdmin=true) || (set "isAdmin=")
            ) else (set "isAdmin=")
        ) || (set "isAdmin=")
    )
)

if "[%~1]" equ "[]" (
    if exist ".settings\runAsAdmin.txt" (
        :runSelfAsAdmin
        cls
        echo [93m[*] Reopening Matject as admin...[0m
        echo.
        if not defined isAdmin (
            if exist ".settings\runAsAdmin_helper.vbs" (
                echo [93m[^^!] Cancelling admin permission request will close Matject.[0m
                if exist ".settings\matject_icon.ico" (
                    if exist ".settings\Matject.lnk" (
                        cscript /NoLogo ".settings\runAsAdmin_helper.vbs" majet ".settings\Matject.lnk"
                        exit 0
                    )
                )
                cscript /NoLogo ".settings\runAsAdmin_helper.vbs" majet "%~f0"
                exit 0
            ) else (
                if exist ".settings\matject_icon.ico" (
                    if exist ".settings\Matject.lnk" (
                        powershell -NoProfile -Command Start-Process -FilePath '.settings\Matject.lnk' -ArgumentList 'pwsh' -Verb runAs && exit 0 || goto runAsAdminPwshFailure
                    )
                )
                powershell -NoProfile -Command Start-Process -FilePath 'matject.bat' -ArgumentList 'pwsh' -Verb runAs && exit 0 || (
                    :runAsAdminPwshFailure
                    del /q ".\.settings\runAsAdmin.txt" >nul 2>&1
                    echo [91m[^^!] Failed to reopen Matject as admin.
                    echo.
                    echo [93m[*] Disabled "Run as admin always" to allow normal access to Matject.[0m
                    echo.
                    echo [*] You may want to open Matject again.
                    echo.
                    echo Press any key to exit...
                    pause >nul
                    exit 1
                )
            )
        ) else (
            goto alreadyRanAsAdmin
        )
    ) else (
        :alreadyRanAsAdmin
        if exist ".settings\matject_icon.ico" (
            if exist ".settings\Matject.lnk" (
                start /i "Loading..." "%cd%\.settings\Matject.lnk" placebo
                exit 0
            )
        )
        start /i /b "Loading..." cmd /k "%~f0" placebo
        exit 0
    )
) else (
    if "[%~1]" equ "[pwsh]" (
        start /i /b "Loading..." cmd /k "%~f0" placebo
        exit 0
    )
    if exist ".settings\runAsAdmin.txt" (
        if not defined isAdmin (
            goto runSelfAsAdmin
        )
    )
)

>nul 2>&1 where mode || (
    set "useSplash="
    goto skip_splash
)

:: Setup splash screen
set "useSplash=true"
set "window_height="
set "window_width="
:: for /f "tokens=2 delims=:" %%a in ('mode con ^| findstr "Columns"') do set "window_width=%%a"
:: for /f "tokens=2 delims=:" %%a in ('mode con ^| findstr "Lines"') do set "window_height=%%a"

for /f "tokens=2" %%N in ('mode con ^| find "Columns"') do set /a window_width=(%%N-18)/2
for /f "tokens=2" %%N in ('mode con ^| find "Lines"') do set /a window_height=(%%N-12)/2

if window_width leq 0 (set /a window_width=51)
if window_height leq 0 (set /a window_height=9)
if window_height geq 1000 (set /a window_height=9)

:: set /a window_width=%window_width%-18/2
:: set /a window_height=(%window_height%-12)/2

for /L %%I in (1,1,!window_width!) do (set "x_spacer=!x_spacer! ")
for /L %%I in (1,1,!window_height!) do (set "y_spacer=& echo: !y_spacer!")

:: Splash screen
cls
%y_spacer:~2%
set "p1=[107m  [0m"
echo !x_spacer!!p1!!p1!!p1!!p1!!p1!  !p1!!p1!!p1!
echo !x_spacer!!p1!              !p1!
echo !x_spacer!!p1!  !p1!  !p1!      !p1!
echo !x_spacer!!p1!  !p1!        !p1!
echo !x_spacer!!p1!  !p1!!p1!!p1!    !p1!
echo.
if exist ".\.settings\ranOnce.txt" (
    echo !x_spacer!!x_spacer:~0,4!Loading...
) else (
    title Welcome^^!
    echo !x_spacer:~0,-10!Welcome to Matject for the first time^^!
    echo.
    echo !x_spacer:~0,-5![90mPress any key to continue...[0m
    pause >nul
)

:skip_splash

:: Verify modules
:: All %%h things have two things, lastEightCharactersOfSHA256-FILENAME
:: It checks if the file exists and then compare with its SHA256
if not exist ".settings\disableModuleVerification.txt" (
    title Matject: Verifying modules...
    if defined useSplash (
        echo [1F[0J!x_spacer:~0,-3![93m[*] Verifying modules...[0m
    ) else (
        cls
        set "fileHash="
        echo [93m[*] Verifying modules...[0m
    )

    :: Make all *.bat files read only
    if not exist ".settings\dontMakeReadOnly.txt" (
        for %%F in ("matject.bat" ".\.settings\*.vbs" ".\modules\*" ".\modules\matjectNEXT\*.bat") do (attrib +R "%%~fF" >nul 2>&1)   
    )

    for %%h in (0b99d813-0_debug 5956fd4c-about b04562e7-autoject c4671b44-backupMaterials e5ab8ef8-checkMaterialCompatibility 006c4556-checkUpdates a929f392-clearVariable fa337c50-colors b3d46c5e-createIcon 59817bfa-createShortcut c39ca84e-createTarget e87fb00c-getMaterialUpdater 27d6b1b2-getMatjectAnnouncement 1a006390-getMinecraftDetails eb316e31-help a1cce537-matjectExamEditionReal fe068270-matjectTips e90a02f8-matjectUpdater 9a1c86c2-noobMode 1eb19df1-progressBar 39aa680e-restoreMaterials 46e769e7-settings 53ec30cd-settingsV3 245775ec-taskkillLoop 1470568e-unlockWindowsApps b700e034-updateMaterials 63572ab4-variables 29d21467-matjectNEXT\cachePacks d0281286-matjectNEXT\getJQ 5c48c003-matjectNEXT\injectMaterials 6de66c54-matjectNEXT\listMaterials 0fc807a6-matjectNEXT\main df2b6cd9-matjectNEXT\manifestChecker e63fc0da-matjectNEXT\parsePackVersion 6489d832-matjectNEXT\parsePackWithCache 20e0f133-matjectNEXT\parseSubpack 50265baa-matjectNEXT\syncMaterials 548ff3f3-matjectNEXT\testCompatibility) do (
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
            endlocal
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
                    endlocal
                    echo on
                    @cmd /k
                )
            )
        )
    )
    set "fileHash="
    if defined useSplash (
        echo [1F[0J!x_spacer:~0,-2![92m[*] All modules are OK[0m
    ) else (
        echo [1F[0J[92m[*] All modules are OK[0m
    )
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
if not exist ".settings\*" (call "modules\createTarget" folder ".settings")
call "modules\settingsV3"
if exist ".settings\debugMode.txt" (set "debugMode=true") else (set "debugMode=")

:: It's tricky to do logical OR in Windows Batch.
:: So, using weird variable to make sure 'if exist tar' fails.
if not defined mt_fallbackToExpandArchive (set "tarexe=tar.exe") else (set "tarexe=confused_unga/bunga")


:: SET VERSION AND WINDOW TITLE
::set "dev=-dev ^(20250415^)"
set "version=v3.7.0"
set "title=Matject %version%%dev%%isPreview%"
title %title%


:: WORK DIRECTORY SETUP
:: if not exist ".settings\*" (mkdir .settings)
if not exist ".settings\.DO-NOT-EDIT-ANYTHING-HERE.txt" (call "modules\createTarget" ".settings\.DO-NOT-EDIT-ANYTHING-HERE.txt" "echo DO NOT modify any files in this folder unless you have proper knowledge.")
if not exist "MCPACKS\*" (call "modules\createTarget" folder "MCPACKS")
if exist "MCPACKS\put-mcpacks-or-zips-here" (del /q ".\MCPACKS\put-mcpacks-or-zips-here" > NUL)
if not exist "MATERIALS\*" (call "modules\createTarget" folder "MATERIALS")
if exist "MATERIALS\put-materials-here" (del /q ".\MATERIALS\put-materials-here" > NUL)
if exist "tmp\*" (rmdir /q /s ".\tmp" > NUL)
if not defined matbak (
    title VARIABLE ISSUE^^!
    cls
    echo [91m[^^!] Variable issue: matbak[0m
    echo.
    echo Exiting...[?25h
    echo.
    endlocal
    echo on
    @cmd /k
)
rem if exist ".\Backups!matbak:~7!" (
rem     if not exist ".\Backups!matbak:~7!\*.material.bin" (
rem         rmdir /q /s ".\Backups!matbak:~7!"
rem         rem if exist "%rstrList%" (>nul del /q ".\%rstrList%")
rem         rem if exist "%lastMCPACK%" del /q /s ".\%lastMCPACK%" >nul
rem         rem if exist "%lastRP%" del /q /s ".\%lastRP%" >nul
rem     )
rem )

:: if not exist logs (mkdir logs)
if defined debugMode call "modules\createTarget" "folder" "logs"
if defined mt_useMaterialUpdater (
    if not exist "modules\material-updater.exe" (call "modules\settingsV3" clear mt_useMaterialUpdater)
)
>nul 2>&1 where curl || (
    call "modules\settingsV3" clear mt_doCheckUpdates
    call "modules\settingsV3" clear mt_showAnnouncements
)

if exist "%ranOnce%" (
    set /p memoire=<"%ranOnce%"
    if exist "%letters%_!memoire!.ini" (set "memoire=" & goto firstRunDone) else (set "memoire=" & del /q /f ".\%ranOnce%" >nul 2>&1)
)

cls 
echo !WHT!=== Matject Terms of Use ===!RST!
echo.
if not exist "TERMS.md" (
    echo !RED![^^!] "TERMS.md" not found.!RST!
    %exitMsg%
)
type TERMS.md
echo.
echo.
echo !GRY!Maximize the window to read properly!RST!
echo.
echo !YLW![?] Do you accept the terms of use above?!RST!
echo.
echo !RED![Y] Yes    !GRN![N] No, exit
choice /c yn /n >nul

if %errorlevel% neq 1 exit /b 403

cls
echo !WHT!Welcome to %title%^^!!RST! ^(for the very first time^)
echo.
echo.
echo !ERR!=== Please read this carefully^^! ===!RST!
echo.
echo - Matject is pretty stable now, yet you may run into issues. 
echo   Please report on GitHub or Discord server: !CYN!faizul726.github.io/bedrockgraphics-discord!RST!
echo - It needs unmodified materials to ensure shader removal works properly.
echo   If you have modified already and don't have original ones, get from !CYN!mcpebd.github.io/materials!RST!
echo - DO NOT MODIFY .settings, Backups, modules folder.
echo - Some antivirus may prevent Matject from working properly. Turning it off or whitelisting may help.
echo - IObit Unlocker may crash on some PCs for no reason. In that case Matject won't work.
echo - Matject doesn't enable Deferred/Vibrant Visuals/PBR/RTX, nor patch your game.
echo - Disabling resource pack or deleting Matject won't remove shaders. Use Shader Removal in main screen to remove.
echo - DO NOT USE THIS, IF IT'S NOT FROM !CYN!%githubLink:~8,-1%!RST!
echo   That's the one and only official source. Avoid downloading from random links/YouTube.
echo - English is not my primary language. So, grammatical errors are expected.!RST!
echo !YLW!- By using Matject, you agree to the license terms provided by YSS Group. ^(See TERMS.md^)!RST!
echo.
echo %showCursor%
set /p "firstRun=Type !RED!understood!RST! and press [Enter] to confirm:!GRN! "
echo %hideCursor%
if not defined firstRun (
    echo !ERR![^^!] Input can't be empty!RST!
    %exitmsg%
)
if "%firstRun: =%" neq "understood" (
    echo !ERR![^^!] Wrong input!RST!
    %exitmsg%
) else (
    echo !GRN![*] Confirmed.!RST!
    timeout 2 > NUL
    call "modules\matjectExamEditionReal"
    cls
    echo Matject is somewhat experimental.
    echo So, it's better to use the latest version whenever possible.
    echo.
    echo !YLW![?] Do you want to check for updates at Matject startup?!RST! !YLW!^(requires internet^)!RST!
    echo.
    echo !GRN![Y] Yes, check for updates at Matject startup. !GRY!^(updating is optional^)!RST!
    echo !RED![N] No, do not check for updates.!RST!
    echo.
    echo !GRN![TIP]!RST! You can enable/disable update checking from Matject Settings -^> Updates ^& Debug later.
    echo.
    choice /c yn /n >nul
    if !errorlevel! equ 1 call "modules\settingsV3" set mt_doCheckUpdates true
    cls
    echo !YLW![?] Do you want to make shortcuts of Matject?!RST!
    echo.
    echo !GRN![Y] Yes !GRY!^(Desktop and Start menu^)
    echo !RED![N] No!RST!
    echo.
    echo !GRN![TIP]!RST! You can add/remove shortcuts from "Shader Removal/Tools" anytime.!RST!
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
    echo !GRN![TIP]!RST! You can always enable/disable it from Matject Settings later.!RST!
    echo.
    echo !GRN![Y] Yes    !RED![N] No!RST!
    echo.
    choice /c yn /n >nul
    if !errorlevel! equ 1 call "modules\getMaterialUpdater" skip_intro
)

:firstRunDone
if defined mt_doCheckUpdates (call "modules\checkUpdates")

if defined mt_customIObitUnlockerPath (
    if exist "!mt_customIObitUnlockerPath!\IObitUnlocker.exe" (
        if exist "!mt_customIObitUnlockerPath!\IObitUnlocker.dll" (
            set "IObitUnlockerPath=!mt_customIObitUnlockerPath!\IObitUnlocker.exe"
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
if defined mt_customMinecraftAppPath (
    if not exist "!mt_customMinecraftAppPath!\AppxManifest.xml" (
        cls
        echo !ERR![^^!] Custom Minecraft app path DOES NOT exist.!RST!
        echo.
        call "modules\getMinecraftDetails" failure
        rem if exist %materialUpdaterArg% del /q .\%materialUpdaterArg% > NUL
        call "modules\settingsV3" clear mt_materialUpdaterArg
        set "useSplash="
    ) else (
        set MCLOCATION=!mt_customMinecraftAppPath!
        if defined mt_oldMinecraftVersion (
            rem set /p CURRENTVERSION=<%oldMinecraftVersion%
            rem set /p OLDVERSION=<%oldMinecraftVersion%
            set "CURRENTVERSION=!mt_oldMinecraftVersion!"
            set "OLDVERSION=!mt_oldMinecraftVersion!"
            echo %hideCursor%>nul
        ) else (
            if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
            for /f "tokens=*" %%i in ('powershell -NoProfile -command "(Get-AppxPackage -Name Microsoft.%productID%).Version"') do (set "CURRENTVERSION=%%i" & set "OLDVERSION=%%i")
            if not defined chcp_failed (>nul 2>&1 chcp 65001)
        )
    )
) else (
    cls
    set "useSplash="
    call "modules\getMinecraftDetails"
    rem if exist %oldMinecraftVersion% (set /p OLDVERSION=<%oldMinecraftVersion%)
    if defined mt_oldMinecraftVersion (
        set "OLDVERSION=!mt_oldMinecraftVersion!"
    )
    echo %hideCursor%>nul
    cls
)

if defined mt_customMinecraftDataPath (
    if exist "!mt_customMinecraftDataPath!\minecraftpe\options.txt" (
        set "gameData=!mt_customMinecraftDataPath!"
    ) else (
        cls
        call "modules\settingsV3" clear mt_customMinecraftDataPath
        echo !ERR![^^!] Custom Minecraft data path invalid.
        echo !RED!If it's correct then open the game at least once.
        echo.

        echo !YLW![*] Turned off custom Minecraft data path and using default data path.!RST!
        set "useSplash="
        echo.
        pause
    )
)

rem if not exist "%customMinecraftDataPath%" (goto nocustomgamedata)
rem set /p gameDataTMP=<%customMinecraftDataPath%
rem echo %hideCursor%>nul
rem if not exist "!gameDataTMP!\minecraftpe\options.txt" (
rem     cls
rem     set "gameDataTMP="
rem     echo !ERR![^^!] Custom Minecraft data path invalid.!RST!
rem     echo !RED!If it's correct then open the game at least once.
rem     echo.
rem     del /q ".\%customMinecraftDataPath%" >nul
rem     echo !YLW![*] Turned off custom Minecraft data path and using default data path.!RST!
rem     set "gameData=%defaultGameData%"
rem     set "useSplash="
rem ) else (
rem     set "gameData=!gameDataTMP!"
rem     set "gameDataTMP="
rem )


:nocustomgamedata
if exist "%unlocked%" goto DELETEOLDBACKUP

:: Disabled this part because still unsure if sideloaded installation is actually outside %ProgramFiles%
:: Yes it is... But will need to add more changes to adjust dynamically with current unlock state. 20250414
:: if /i "%MCLOCATION:~0,28%" neq "C:\Program Files\WindowsApps" (
::    echo [%date% // %time:~0,-6%] - This file was created to indicate that WindowsApps is already unlocked and skip the question in Matject.>"%unlocked%"
:: )

if not exist "%unlocked%" (
    cls
    set "useSplash="
    echo !BEL!!YLW![*] You don't have "%ProgramFiles%\WindowsApps" folder unlocked.!RST!
    echo.
    echo !RED!Without unlocking Matject CANNOT backup materials.!RST!
    echo.
    echo !YLW![?] Do you want to unlock?!RST!
    echo.
    echo !RED![Y] Yes ^(will request admin permission^)
    echo !GRN![N] No  ^(exit^)!RST!
    echo.
    choice /c yn /n >nul
    echo.
    if !errorlevel! equ 1 (
        cls
        title %title% ^(unlocking WindowsApps^)
        echo !YLW!!BLINK![*] Unlocking WindowsApps folder...!RST!
        if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
        powershell -NoProfile -command Start-Process -File 'modules\unlockWindowsApps.bat' -Verb runas -Wait || (
            echo !YLW![*] Seems like automatic unlock failed.
            echo     You will need to go into the modules folder of Matject,
            echo     Right-click "unlockWindowsApps" and run it as admin.
        )
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
if defined mt_directWriteMode (
    (echo This file was created to check if Minecraft app folder is writable. [%date% // %time:~0,-6%]>"!MCLOCATION!\matject-test-file.txt") >nul 2>&1
    if not exist "!MCLOCATION!\matject-test-file.txt" (
        cls
        echo !ERR![^^!] Unable to write directly in Minecraft app folder.!RST!
        echo.
        echo !YLW![*] Disabled "Direct write mode" to allow normal access to Matject.!RST!
        call "modules\settingsV3" clear mt_directWriteMode
        set "useSplash="
        pause
    ) else (
        del /q /f "!MCLOCATION!\matject-test-file.txt"
    )
)

if exist "!backupRunning:~0,-4!.log" (
    cls
    set "useSplash="
    echo !RED![^^!] Last backup was incomplete.!RST!
    echo.
    echo !YLW![*] Making new backup...!RST!
    echo.
    if exist ".\Backups!matbak:~7!" rmdir /q /s ".\Backups!matbak:~7!"
    call "modules\backupMaterials"
)
if exist ".\Backups!matbak:~7!\*.material.bin" (
    if "!CURRENTVERSION!" neq "!OLDVERSION!" (
    cls
    set "useSplash="
    echo !RED![^^!] OLD SHADER BACKUP DETECTED.!RST!
    echo.
    echo !YLW![*] Current version: v!CURRENTVERSION!, old version: v!OLDVERSION!.!RST!
    echo.
    if defined mt_dontRetainOldBackups (
        echo !YLW![*] Deleting old backup...!RST!
        echo.
        rmdir /q /s ".\Backups!matbak:~7!"
    ) else (
        echo !YLW![*] Renaming old backup...!RST!
        echo.
        if exist "Old Materials Backup (v!OLDVERSION!)" (
            rmdir /q /s ".\Backups!matbak:~0,19!\Old Materials Backup (v!OLDVERSION!)" >nul 2>&1
            del /q /f ".\Backups!matbak:~0,19!\Old Materials Backup (v!OLDVERSION!)" >nul 2>&1
        )
        rename ".\Backups!matbak:~7!" "Old Materials Backup (v!OLDVERSION!)" >nul
    )
    rem if exist %materialUpdaterArg% del /q ".\%materialUpdaterArg%" > NUL
    call "modules\settingsV3" clear mt_materialUpdaterArg
    if exist "!taskOngoing:~0,-4!.log" del /q /f ".\!taskOngoing:~0,-4!.log" >nul
    rem if exist "%rstrList%" del /q ".\%rstrList%" >nul
    call "modules\settingsV3" clear mt_restoreList
    rem if exist "%lastMCPACK%" del /q ".\%lastMCPACK%" >nul
    call "modules\settingsV3" clear mt_lastMCPACK
    rem if exist "%lastRP%" del /q ".\%lastRP%" >nul
    call "modules\settingsV3" clear mtnxt_lastResourcePackID
    rem if exist "%backupDate%" del /q ".\%backupDate%" >nul
    call "modules\settingsV3" clear mt_currentBackupDate
    rem echo !CURRENTVERSION!>%oldMinecraftVersion%
    call "modules\settingsV3" set mt_oldMinecraftVersion "!CURRENTVERSION!"
    call "modules\backupMaterials"
    timeout 2 > NUL
    )
) else (
    cls
    set "useSplash="
    call "modules\backupMaterials"
)

rem for /f "tokens=2 delims==" %%a in ('"wmic os get localdatetime /value"') do (
rem     set "deiteu=%%a"
rem     set /a "imy=!deiteu:~2,2!-21"
rem     set "deiteu=!deiteu:~4,4!"
rem )
rem Will add future April Fools Joke (100% real)

if defined mt_disableInterruptionCheck (
    if exist "!taskOngoing:~0,-4!.log" del /q /f ".\!taskOngoing:~0,-4!.log" >nul
    goto skipInterruptionCheck
)
if exist "!taskOngoing:~0,-4!.log" (
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
        del /q /f ".\!taskOngoing:~0,-4!.log" >nul
        timeout 3 >nul
    )
)

:skipInterruptionCheck
set "openingMethod="
set "x_spacer_openingMethod="
set "x_spacer_pressForSettings="
if defined mt_defaultMethod (
    if /i "!mt_defaultMethod!" equ "Auto" set "openingMethod=!GRN!Auto!RST!" & set "x_spacer_openingMethod=!x_spacer:~0,-8!"
    if /i "!mt_defaultMethod!" equ "Manual" set "openingMethod=!BLU!Manual!RST!" & set "x_spacer_openingMethod=!x_spacer:~0,-9!"
    if /i "!mt_defaultMethod!" equ "matjectNEXT" set "openingMethod=!RED!matjectNEXT!RST!" & set "x_spacer_openingMethod=!x_spacer:~0,-12!"
    if /i "!mt_defaultMethod!" neq "Auto" if /i "!mt_defaultMethod!" neq "Manual" if /i "!mt_defaultMethod!" neq "matjectNEXT" (
        call "modules\settingsV3" clear mt_defaultMethod
        goto INTRODUCTION
    )
    if defined useSplash (
        set "x_spacer_pressForSettings=!x_spacer:~0,-12!"
    ) else (
        set "x_spacer_openingMethod="
        set "x_spacer_pressForSettings="
    )
    echo [1F[0K!x_spacer_openingMethod!Opening !openingMethod! method in 2 seconds...
    echo.
    echo !YLW!!x_spacer_pressForSettings!Press [S] to open Matject settings instead!RST!
    choice /c s0 /t 2 /d 0 /n >nul
    set "openingMethod="
    set "x_spacer_openingMethod="
    set "x_spacer_pressForSettings="
    if !errorlevel! equ 1 goto option6
    goto !mt_defaultMethod!

)
rem if exist "%defaultMethod%" (
rem     set /p selectedMethod=<%defaultMethod%
rem     echo %hideCursor%>nul
rem     if defined selectedMethod (
rem         set "selectedMethod=!selectedMethod: =!"
rem     ) else (
rem         set selectedMethod=null
rem     ) 
rem 
rem     if /i "!selectedMethod!" neq "Auto" if /i "!selectedMethod!" neq "Manual" if /i "!selectedMethod!" neq "matjectNEXT" (
rem         pause
rem         echo [2F[0J
rem         if defined useSplash (
rem             echo !x_spacer:~0,-25!!RED![^^!] "%defaultMethod%" is invalid. Going to main screen...!RST!
rem         ) else (
rem             echo !RED![^^!] "%defaultMethod%" is invalid. Going to main screen...!RST!
rem         )
rem         del /q ".\%defaultMethod%" >nul
rem         timeout 2 >nul
rem         goto INTRODUCTION
rem     )
rem     if defined useSplash (
rem         echo [2F[0J
rem         if /i "!selectedMethod: =!" equ "Auto" echo !x_spacer:~0,-8!Opening !GRN!Auto!RST! method in 2 seconds...
rem         if /i "!selectedMethod: =!" equ "Manual" echo !x_spacer:~0,-9!Opening !BLU!Manual!RST! method in 2 seconds...
rem         if /i "!selectedMethod: =!" equ "matjectNEXT" echo !x_spacer:~0,-12!Opening !RED!matjectNEXT!RST! method in 2 seconds...
rem         echo.
rem         echo !YLW!!x_spacer:~0,-10!Press [S] to open settings directly...!RST!
rem     ) else (
rem         cls
rem         if /i "!selectedMethod: =!" equ "Auto" echo !WHT![*] Opening !GRN!Auto!RST! method in 2 seconds...
rem         if /i "!selectedMethod: =!" equ "Manual" echo !WHT![*] Opening !BLU!Manual!RST! method in 2 seconds...
rem         if /i "!selectedMethod: =!" equ "matjectNEXT" echo !WHT![*] Opening !RED!matjectNEXT!RST! method in 2 seconds...
rem         echo.
rem         echo     !YLW!Press [S] to open Matject Settings directly...!RST!
rem     )
rem     choice /c s0 /t 2 /d 0 /n >nul
rem     if !errorlevel! equ 1 goto option6
rem     cls
rem     goto !selectedMethod!
rem )


:INTRODUCTION
set "x_spacer="
set "y_spacer="
set "usingCustomPath="
cls
if defined isAdmin (set "isAdmin=Running as admin. ")

for %%F in ("mt_customMinecraftAppPath" "mt_customMinecraftDataPath" "mt_customIObitUnlockerPath") do (
    if defined %%~F set "usingCustomPath=true"
)

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

if defined mt_lastMCPACK (
    set "tmp_lastMCPACK=!GRY!^(Last injected: !mt_lastMCPACK!^)!RST!"
) else (set "tmp_lastMCPACK=")

if defined mtnxt_lastResourcePackName (
    set "mtnxt_lastResourcePackName_display=!GRY!^(Last injected: !mtnxt_lastResourcePackName!^)!RST!"
) else (set "mtnxt_lastResourcePackName_display=")


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
if not defined mt_hideTips (
    call modules\matjectTips
    echo.
)
if defined mt_showAnnouncements (
    echo !GRN![Announcement]!RST! Loading...
    call modules\getMatjectAnnouncement
)
echo.

echo !YLW![?] Which method would you like to use?!RST!
echo.

echo !GRN![1] Auto!RST! !GRY![Deprecated]!RST! %tmp_lastMCPACK%
echo     Put one or more MCPACK/ZIP files into the MCPACKS folder.
echo     Matject will let you choose any one to extract materials from and then ask you to inject
echo.
echo !BLU![2] Manual!RST! !GRY![Deprecated]!RST!
echo     Put .material.bin files into the MATERIALS folder.
echo     Matject will ask you to inject provided materials. 
echo.
echo !RED![3] matjectNEXT!RST! %mtnxt_lastResourcePackName_display%
if defined mt_restoreList (
    echo     Draco for Windows but not really.                  !GRY!Use this to remove shaders!RST!
    echo     Much easier to use compared to Auto/Manual.                     !GRY!^|!RST!
    echo                                                                     !GRY!V!RST!
    echo !WHT![H] I need Help    [A] About    [S] Matject Settings    !GRN:9=4![R] Shader Removal/Tools!RST!
) else (
    echo     Draco for Windows but not really. 
    echo     Much easier to use compared to Auto/Manual.
    echo.
    echo !WHT![H] I need Help    [A] About    [S] Matject Settings    [R] Shader Removal/Tools!RST!
)
echo.
echo !RED![B] Exit!RST!
echo.
echo !YLW!Press corresponding key to confirm your choice. !GRY!Press Q to know what each action does.!RST!
echo.
choice /c 123hasrbq /n >nul

goto option!errorlevel!

:: OTHER OPTIONS

:option9
call "modules\help" main-screen
title %title%
goto :INTRODUCTION

:option8
exit 0

:option7
cls
echo !RED!^< [B] Back to main screen!RST!
::echo !RED!^< [B] Back !RST!^| !WHT!Home -^> Tools!RST!
echo.
echo [1] Shader Removal / Restore default materials
echo [2] Open Minecraft app folder
echo [3] Open Minecraft data folder
echo.
echo !GRN![4] View Matject on GitHub :^)
echo !WHT![5] Visit jq website
echo [6] View material-updater on mcbegamerxx954's GitHub
echo !RST!
echo [7] Create shortcuts ^(desktop/start menu^)!WHT!
echo !GRY![8] Refresh/replace backup from ZIP file ^(use this if you don't have original materials to start with^)
echo [9] Reset Global Resource Packs ^(use this if you want to deactivate all active packs^)
echo [M] Manifest checker + fix ^(from matjectNEXT^)
if defined debugMode echo [L] Drop to shell
echo !RST!
echo !YLW!Press corresponding key to confirm your choice... !GRY!Press Q to know what each action does.!RST!
echo.
choice /c 123456789lbmq /n >nul
goto others!errorlevel!

:others13
call "modules\help" tools
goto option7

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
if exist "%gameData%\minecraftpe\global_resource_packs.json" (del /q /f "%gameData%\minecraftpe\global_resource_packs.json" >nul)
echo []>"%gameData%\minecraftpe\global_resource_packs.json"
echo !GRN![*] Reset global resource pack successfully.!RST!
%backmsg:EOF=option7%
goto option7

:others8
cls
echo %hideCursor%>nul
echo !WHT![*] Add materials backup ZIP file in !YLW!"%cd%\%matbak:~0,-19%"!WHT!.
echo.
echo !RED![^^!] DO NOT ADD MULTIPLE ZIP FILES.
if defined mt_currentBackupDate (
    echo     Current backup from "!mt_currentBackupDate!" will be replaced.!RST!
) else (
    echo     Current backup will be replaced.!RST!
)
echo.
echo [*] Don't have any backup file? Get from !CYN!mcpebd.github.io/materials!RST!. !GRY!It will go back if no backup file is found.!RST!
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
if not defined mt_disableConfirmation (
    echo !YLW![?] Would you like to use it to replace current backup?!RST!
    echo.
    echo !RED![^^!] Current backup from !mt_currentBackupDate! will be replaced.!RST!
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
if exist ".\Backups!matbak:~7!" (del /q /f ".\Backups!matbak:~7!\*" >nul) else (mkdir ".\Backups!matbak:~7!")
rem if exist "%backupDate%" del /q ".\%backupDate%" >nul
call "modules\settingsV3" clear mt_currentBackupDate

if exist "%SYSTEMROOT%\system32\%tarexe%" (
    tar -xf "%matbak:~0,-19%\!backupFile!" -C ".\Backups!matbak:~7!"
) else (
    if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
    powershell -NoProfile -Command "Expand-Archive -Force '%matbak:~0,-19%\!backupFile!' '.\Backups!matbak:~7!'"
    if not defined chcp_failed (>nul 2>&1 chcp 65001)
)
if exist ".\Backups!matbak:~7!\*.material.bin" (
    echo !GRN![*] Successfully replaced backup from !backupFile!.!RST!
    rem echo %date% // %time:~0,-6%>%backupDate%
    call "modules\settingsV3" set mt_currentBackupDate "%date% // %time:~0,-6%"
    echo.
    pause
) else (
    echo !RED![^^!] Failed to get materials from backup.
    echo     Maybe not an actual materials ZIP?!RST!
    %backmsg:~0,56%
    del /q /f ".\Backups!matbak:~7!\*" >nul
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
if not exist "%localAppData%\packages\Microsoft.%productID%_8wekyb3d8bbwe\LocalState\games\com.mojang" (
    echo !RED![^^!] Minecraft data folder not found.!RST!
    echo     Perhaps it's not created yet?
    echo.
    timeout 3 >nul
) else (
    start "" /i explorer "%localAppData%\packages\Microsoft.%productID%_8wekyb3d8bbwe\LocalState\games\com.mojang"
)
goto option7 

:others2
start "" /i explorer "!MCLOCATION!"
goto option7

:others1
if defined isAdmin (call "modules\restoreMaterials") else (
    if defined mt_runIObitUnlockerAsAdmin (
        cls
        echo !YLW!!BLINK![*] Starting "Restore default materials" as admin...!RST!
        if exist "tmp\" (del /q /f ".\tmp\*" >nul) else (mkdir tmp)
        (
            echo :: This file was created to pass some of the current variables to restoreMaterials.bat [%date% // %time:~0,-6%]
            echo.
            echo set "backMsg=!backMsg!"
            echo set "backupRunning=!backupRunning!"
            echo set "matjectSettings=!matjectSettings!"
            echo set "taskOngoing=!taskOngoing!"
            echo set "mt_currentBackupDate=!mt_currentBackupDate!"
            echo set "mt_hideTips=!mt_hideTips!"
            echo set "debugMode=!debugMode!"
            echo set "directWriteMode=!directWriteMode!"
            rem echo set "exitmsg=!exitMsg!"
            echo set "mt_fullRestoreMaterialsPerCycle=!mt_fullRestoreMaterialsPerCycle!"
            echo set "mt_fullRestoreMaterialsPerCycle_default=!mt_fullRestoreMaterialsPerCycle_default!"
            echo set "IObitUnlockerPath=!IObitUnlockerPath!"
            echo set "isPreview=!isPreview!"
            echo set "mt_lastMCPACK=!mt_lastMCPACK!"
            echo set "mtnxt_lastResourcePackID=!mtnxt_lastResourcePackID!"
            echo set "matbak=!matbak!"
            echo set "MCLOCATION=!MCLOCATION!"
            echo set "mt_backupRestoreDate=!mt_backupRestoreDate!"
            echo set "mt_restoreList=!mt_restoreList!"
            echo set "uacfailed=!uacfailed!"
        )>tmp\adminVariables_restoreMaterials.bat
        if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
        powershell -NoProfile -Command Start-Process -FilePath 'modules\restoreMaterials.bat' -ArgumentList 'placebo3' -Verb runAs -Wait || (
            if not defined chcp_failed (>nul 2>&1 chcp 65001)
            echo !RED![^^!] Failed to start "Restore default materials" as admin.!RST!
            echo.
            echo !YLW![*] Disabled "Run IObit Unlocker as admin" and starting normally...!RST!
            echo.
            call "modules\settingsV3" clear mt_runIObitUnlockerAsAdmin
            timeout 3 >nul
            call "modules\restoreMaterials"
        )
        call "modules\settingsV3"
        if not defined chcp_failed (>nul 2>&1 chcp 65001)
        if not exist ".\Backups!matbak:~7!\*.material.bin" (exit)
        if exist "!taskOngoing:~0,-4!.log" (exit)
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
if defined mt_restoreList (
    if not defined mtnxt_lastResourcePackID (
        cls
        echo !RED!^< [B] Back to main screen!RST!
        echo.
        echo !YLW![^^!] You already have modified materials.
        echo.
        echo [?] Do you want to restore materials so you can use matjectNEXT?!RST!
        echo.
        echo !GRN![Y] Yes    !RED![N] No, go back
        choice /c bny /n >nul
        if !errorlevel! equ 3 (
            goto others1
        ) else (
            goto INTRODUCTION
        )
    )
)
call "modules\matjectNEXT\main"
title Matject %version%%dev%%isPreview%

goto INTRODUCTION

:option1
if exist "MATERIALS\*.material.bin" (
    cls
    echo !RED![^^!] MATERIALS folder is not empty.
    echo     Please remove .material.bin files from the folder first..!RST!
    %backmsg:EOF=INTRODUCTION%
)
:auto
cls
echo !YLW![AUTO METHOD SELECTED]!RST!
echo.
echo.
echo.

echo !YLW![^^!] Please add desired MCPACK/ZIP file in the MCPACKS folder.!RST!
echo.
if not defined mt_dontOpenFolder (
    if not defined mt_hideTips (echo !GRN![TIP]!RST! You can disable auto folder opening from Matject Settings.)
)
echo.
if not defined mt_hideTips (echo !GRN![TIP]!RST! You can put multiple MCPACK/ZIP files in the "MCPACKS" folder.)
echo.

if not defined mt_dontOpenFolder (start "" /i explorer "%cd%\MCPACKS")

echo After adding,
pause



:AUTOLIST
cls
echo Loading...
call "modules\clearVariable" auto_all
if not exist "tmp\" mkdir tmp
del /q /f ".\tmp\mcpackChooser.bat" >nul 2>&1
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
if defined mt_disableConfirmation goto AUTOEXTRACT
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
copy /d /b "!selected_mcpack!" "tmp\mcpack.zip" > NUL
echo.
echo.
echo.

echo !YLW!!BLINK![*] Extracting MCPACK/ZIP to temporary folder...!RST!
echo.

if exist "%SYSTEMROOT%\system32\%tarexe%" (
    tar -xf "tmp\mcpack.zip" -C "tmp"
) else (
    if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
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
cls
echo Loading...
if exist "MATERIALS\*" del /q /f ".\MATERIALS\*" >nul
del /q /f ".\tmp\subpackChooser.bat" >nul 2>&1
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
    if not defined mt_hideTips (
        echo !GRN![TIP]!RST! Subpack is what you select from pack settings ^(gear icon^) in global resource packs. 
        echo       You can take a look at manifest.json to find what each subpack does.
        echo       If you are unsure, you can select any one subpack.
        echo       MAKE SURE TO select the same subpack from setting of the shader after injecting to ensure consistency.
    )
    echo %showCursor%
    set /p "tmp_input=!YLW!Choose a subpack by entering its number !GRY!^(leave blank to go back or write !WHT!/skip!GRY! to skip subpack^)!RST!: "
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
move /Y "!MCPACKDIR!\renderer\materials\*" ".\MATERIALS\"  >nul 2>&1
if defined selected_subpack (
    move /Y "!MCPACKDIR!\subpacks\!selected_subpack!\renderer\materials\*" ".\MATERIALS" >nul 2>&1
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
if not defined mt_dontOpenFolder (
    if not defined mt_hideTips (echo !GRN![TIP]!RST! You can disable auto folder opening from Matject Settings.)
)
echo.

if not defined mt_dontOpenFolder (start "" /i explorer "%cd%\MATERIALS")

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
if not defined mt_disableMatCompatCheck (
    call "modules\checkMaterialCompatibility"
    if !errorlevel! neq 0 (
        echo [1F[0J!ERR!!BEL![^^!] Given shader is not for Windows.!RST!
        echo.
        echo !WHT!Chosen MCPACK/ZIP:!RST! !MCPACKNAME!
        del /q /f ".\MATERIALS\*" >nul
        if exist "tmp" (rmdir /q /s ".\tmp" >nul)
        %backmsg:EOF=INTRODUCTION%
    )   
)

for %%f in ("MATERIALS\*.material.bin") do (
    set "MTBIN=%%~nf"
    set SRCLIST=!SRCLIST!,"%cd%\%%f"
    set "BINS=!BINS! "/!MTBIN:~0,-9!\""
    set REPLACELIST=!REPLACELIST!,"/!MTBIN:~0,-9!\"
)

set "BINS=!BINS:~1!"
set "SRCLIST=%SRCLIST:~1%"
set "REPLACELIST=%REPLACELIST:~1%"
set "REPLACELISTEXPORT=%REPLACELIST%"

set "REPLACELIST=%REPLACELIST:\=.material.bin%"
set "REPLACELIST=%REPLACELIST:/=!MCLOCATION!\data\renderer\materials\%"
if defined mt_disableConfirmation (
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
echo !RED![Y] Yes             !GRN![N] No, go back!RST!
echo !BLU![R] Refresh list    !GRY![O] Open MATERIALS folder!RST!
echo.

choice /c yron /n >nul

if !errorlevel! equ 1 goto INJECTIONCONFIRMED
if !errorlevel! equ 2 goto SEARCH
if !errorlevel! equ 3 (
    start /i explorer "%cd%\MATERIALS"
)
if !errorlevel! equ 4 (
    if defined selected_mcpack del /q /f ".\MATERIALS\*" >nul
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

if defined mt_useMaterialUpdater call "modules\updateMaterials"
if exist "tmp\" (del /q /f ".\tmp\*" >nul) else (mkdir tmp)
echo.

if defined isAdmin (call "modules\autoject") else (
    if defined mt_runIObitUnlockerAsAdmin (
        echo !YLW!!BLINK![*] Starting IObit Unlocker as admin...!RST!
        echo.
        (
            echo :: This file was created to pass some of the current variables to autoject.bat [%date% // %time:~0,-6%]
            echo.
            echo set "BINS=!BINS!"
            echo set "backupRunning=!backupRunning!"
            echo set "matjectSettings=!matjectSettings!"
            echo set "mt_currentBackupDate=!mt_currentBackupDate!"
            echo set "taskOngoing=!taskOngoing!"
            echo set "debugMode=!debugMode!"
            echo set "directWriteMode=!directWriteMode!"
            echo set "exitmsg=!exitMsg!"
            echo set "IObitUnlockerPath=!IObitUnlockerPath!"
            echo set "isPreview=!isPreview!"
            echo set "mt_lastMCPACK=!mt_lastMCPACK!"
            echo set "mtnxt_lastResourcePackID=!mtnxt_lastResourcePackID!"
            echo set "matbak=!matbak!"
            echo set "MCLOCATION=!MCLOCATION!"
            echo set "MCPACKNAME=!MCPACKNAME!"
            echo set "REPLACELIST=!REPLACELIST!"
            echo set "REPLACELISTEXPORT=!REPLACELISTEXPORT!"
            echo set "mt_backupRestoreDate=!mt_backupRestoreDate!"
            echo set "mt_restoreList=!mt_restoreList!"
            echo set "selected_mcpack=!selected_mcpack!"
            echo set "selected_subpack=!selected_subpack!"
            echo set "SRCLIST=!SRCLIST!"
            echo set "uacfailed=!uacfailed!"
        )>tmp\adminVariables_autoject.bat
        if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
        powershell -NoProfile -Command Start-Process -FilePath 'modules\autoject.bat' -ArgumentList 'placebo2' -Verb runAs -Wait || (
            if not defined chcp_failed (>nul 2>&1 chcp 65001)
            echo !RED![^^!] Failed to launch IObit Unlocker as admin.!RST!
            echo.
            echo !YLW![*] Disabled "Run IObit Unlocker as admin" and running injection normally...!RST!
            echo.
            call "modules\settingsV3" clear mt_runIObitUnlockerAsAdmin
            call "modules\autoject"
        )
        call "modules\settingsV3"
        if not defined chcp_failed (>nul 2>&1 chcp 65001)
    ) else (call "modules\autoject")
)

:SUCCESS
cls
echo !GRN![*] INJECTION SUCCEED.!RST!
echo.

if defined mt_autoImportMCPACK (
    if defined manifestFound (
        if /i "!MCPACKNAME:~-7,7!" equ ".mcpack" (start /i "" "MCPACKS\!MCPACKNAME!") else (
            mkdir tmp
            copy /d /b "MCPACKS\!MCPACKNAME!" "tmp\!MCPACKNAME!.mcpack" >nul
            start /i "" "tmp\!MCPACKNAME!.mcpack"
        )
    ) else (goto skip)
) 

if not defined mt_autoImportMCPACK (
    if not defined manifestFound (goto skip)
    echo !YLW![?] Do you want to import the MCPACK for full experience?!RST!
    echo     !GRY!Note: This will open MCPACK with currently associated app.!RST!
    echo.
    echo !GRN![Y] Yes    !RED![N] No!RST!
    echo.
    choice /c yn /n >nul
    echo.
    if "!errorlevel!" equ "2" goto skip

    if not defined mt_hideTips (echo !GRN![TIP]!RST! You can enable Auto open MCPACK from Matject Settings.)
    echo.
    if defined manifestFound (
        if /i "!MCPACKNAME:~-7,7!" equ ".mcpack" (start /i "" "MCPACKS\!MCPACKNAME!") else (
            mkdir tmp
            copy /d /b "MCPACKS\!MCPACKNAME!" "tmp\!MCPACKNAME!.mcpack" >nul
            start /i "" "tmp\!MCPACKNAME!.mcpack"
        )
    )
)

:skip
if not defined mt_hideTips (
    echo !GRN![TIP]!RST! Activate the shader resource pack for full experience.
    echo       If you selected a subpack, it's better to select the same from shader settings. ^(gear icon in resource pack^)
    echo.
    echo !GRN![TIP]!RST! If you see invisible blocks in game, 
    echo       enable material-updater from Matject Settings and inject again.
    echo.
    echo.
)
if defined mt_disableSuccessMsg (
    timeout 1 > NUL
    exit
)

echo !GRN!Thanks for using Matject, have a good day^^!!RST!

%exitmsg%
