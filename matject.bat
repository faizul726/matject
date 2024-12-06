@echo off
setlocal enabledelayedexpansion
cls
pushd "%~dp0"

:: A material replacer for Minecraft.
:: Made by @faizul726
:: https://faizul726.github.io/matject

::set "dev=-dev ^(20241204^)"
set "version=v3.2.2"
set "title=Matject %version%%dev%"
set "murgi=KhayDhan"

:: Load other variables
call "modules\colors"
call "modules\variables"
if exist ".settings\debugMode.txt" (set "debugMode=true") else (set "debugMode=")

REM TODO
REM - Move variables to modules [DONE]
REM - ADD DATETIME IN RESTORE CONSENT [DONE]
REM - DELETE MATERIALS.BAK IF EMPTY
REM - MIGRATE TO CHECK RENDERER FOLDER INSTEAD OF MANIFEST [DONE]
REM - ADD FOUND DETAILS IN GETMCDETAILS [DONE]
REM - STORE SHADER NAME FOR LATER USE
REM - MERGE UNLOCK...BAT WITH MATJECT
REM - RENAME MATBAK to Materials (backup) [DONE]
REM - Use subroutines


:: WORK DIRECTORY SETUP
if not exist ".settings\" (mkdir .settings)
if not exist "MCPACK\" (mkdir MCPACK)
if exist "MCPACK\putMcpackHere" (del /q /s "MCPACK\putMcpackHere" > NUL)
if not exist "MATERIALS\" (mkdir MATERIALS)
if exist "MATERIALS\putMaterialsHere" (del /q /s "MATERIALS\putMaterialsHere" > NUL)
if exist "tmp" (rmdir /q /s tmp > NUL)

title %title%

if exist %ranOnce% goto firstRunDone
echo !WHT!Welcome to %title%^^!!RST! ^(for the very first time^)
echo.
echo.
echo !ERR!=== Hol' up soldier^^! ===!RST!!YLW!
echo.
echo - Matject is not perfect, bugs may show up. Please report them to me.
echo - It assumes you HAVE NOT made any changes to materials, because it needs a copy of original materials to work properly.
echo !RED!* DO NOT MODIFY .settings and Backups folder.!YLW!
echo - It may not work properly with antivirus read/write protection.
echo - The worst thing that can happen with is material corruption.
echo   !GRY!In that case you can restore materials or reinstall Minecraft.!YLW!
echo - Minecraft Preview is not supported ^(yet^)
echo - Some packs may need extra steps for Matject auto/manual method.
echo - English is not my primary language. So, grammatical errors are expected.!RST!
echo.
echo.
set /p "firstRun= Type !GRN!yes!RST! to confirm:!GRN! "
echo.
if "!firstRun!" neq "yes" (
    echo !ERR![^^!] WRONG INPUT!RST!
    %exitmsg%
) else (
    echo !GRN![*] Confirmed.!RST!
    echo First ran by %USERNAME% on: %date% - %time%>"!ranOnce!"
    timeout 2 > NUL
    cls
    echo Matject is somewhat experimental.
    echo So, I ^(creator^) want people to use the latest version whenever possible.
    echo.
    echo !YLW![?] Do you want to check for updates at Matject startup?!RST! !YLW!^(requires internet^)!RST!
    echo.
    echo [Y] Yes, check for updates at Matject startup. ^(only informs about update^)
    echo [N] No, do not check for updates.
    echo.
    echo !GRN![TIP] You can enable/disable update checking from settings later.!RST!
    echo.
    choice /c yn /n >nul
    if !errorlevel! equ 1 echo Thank you for being a regular user of Matject [%date% // %time%]>%doCheckUpdates%
    cls
)

:firstRunDone
if exist %doCheckUpdates% (
    call "modules\checkUpdates"
)


if exist "%customIObitUnlockerPath%" (
    set /p IObitUnlockerPathTemp=<%customIObitUnlockerPath%
    if exist "!IObitUnlockerPathTemp!\IObitUnlocker.exe" (
        if exist "!IObitUnlockerPathTemp!\IObitUnlocker.dll" (
            set "IObitUnlockerPath=!IObitUnlockerPathTemp!\IObitUnlocker"
            goto iobitUnlockerFound
        )
    )
) else (
    goto checkIObitUnlocker
)
echo !ERR![^^!] Provided custom path is invalid^^!!RST!
echo !RED!Please set IObit Unlocker path again.!RST!
echo.
echo Press any key to set...
echo.
pause >nul
call "modules\settings" toggleP2_3

:checkIObitUnlocker
if not exist "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker.exe" (
    echo !RED![^^!] You don't have IObit Unlocker installed.!RST!
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

    if !errorlevel! equ 1 (
        start https://www.iobit.com/en/iobit-unlocker.php
        exit
    )
    if !errorlevel! equ 2 (exit)
    if !errorlevel! equ 3 (call "modules\settings" toggleP2_3)
    ) else (
        set "IObitUnlockerPath=%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker"
)

:iobitUnlockerFound
if exist "%customMinecraftAppPath%" (
    set /p MCLOCATION=<%customMinecraftAppPath%
    if not exist "!MCLOCATION!\AppxManifest.xml" (
        echo !ERR![^^!] Custom Minecraft app path DOES NOT exist.!RST!
        echo.
        call "modules\getMinecraftDetails"
        if exist %materialUpdaterArg% del /q /s %materialUpdaterArg% > NUL
        echo.
        echo !GRN!TIP: You may disable custom Minecraft app path in settings to remove this error.!RST!
        echo.
        pause
    ) else (
        if exist %oldMinecraftVersion% (
            set /p CURRENTVERSION=<%oldMinecraftVersion%
            set /p OLDVERSION=<%oldMinecraftVersion%
        ) else (
            for /f "tokens=*" %%i in ('powershell -NoProfile -command "Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty Version"') do set "CURRENTVERSION=%%i" && set "OLDVERSION=%%i" 
        )
    )
) else (
    call "modules\getMinecraftDetails"
    cls
)

if not exist "%customMinecraftDataPath%" (goto nocustomgamedata)
set /p gamedataTMP=<%customMinecraftDataPath%
if not exist "!gamedataTMP!\minecraftpe\options.txt" (
    echo !ERR![^^!] Custom Minecraft data path invalid.
    echo.
    echo !YLW![*] Turned off custom Minecraft data path and using default data path.!RST!
    del /q /s "%customMinecraftDataPath%" >nul
    set "gamedata=%defaultgamedata%"
) else (
    set "gamedata=!gamedataTMP!"
)


:nocustomgamedata
if exist "%unlocked%" goto DELETEOLDBACKUP

if /i "%MCLOCATION:~0,28%" neq "C:\Program Files\WindowsApps" (
    echo [%date% // %time%] - This file was created to indicate that WindowsApps is already unlocked and skip the question in Matject.>"%unlocked%"
)

if not exist "%unlocked%" (
    cls 
    echo !YLW![*] You don't have "%ProgramFiles%\WindowsApps" folder unlocked.!RST!
    echo    !RED! Without unlocking Matject CANNOT backup materials.!RST!
    echo.
    echo.
    echo !YLW![?] Do you want to unlock?!RST!
    echo.
    echo [Y] Yes, ^(requires admin privilege^)
    echo [N] No ^(exit^)
    echo.
    choice /c yn /n >nul
    echo.
    if "!errorlevel!" equ "1" (
        cls
        title %title% ^(unlocking WindowsApps^)
        echo !YLW![*] Unlocking...!RST!
        powershell -NoProfile -command start-process -file "modules\unlockWindowsApps.bat" -verb runas -Wait
        echo.
        if not exist %unlocked% (title %title% && echo !ERR![^^!] FAILED. Saved log as in .settings\unlockLog.txt. You might need it for finding the issue later.!RST! && %exitmsg%) else (echo !GRN![*] Unlocked.!RST!)
        echo.
        ) else (
            if "!errorlevel!" equ "2" exit
        )
)

:DELETEOLDBACKUP
if exist ".settings\backupRunning.txt" (
    cls
    echo !RED![^^!] Last backup was incomplete.!RST!
    echo.
    echo !YLW![*] Making new backup...!RST!
    echo.
    if exist "%matbak%" rmdir /q /s "%matbak%"
    call "modules\backupMaterials"
)
if exist "%matbak%\" (
    if "!CURRENTVERSION!" neq "!OLDVERSION!" (
    cls
    echo !RED![^^!] OLD SHADER BACKUP DETECTED!RST!
    echo.
    echo !YLW![*] Current version: v!CURRENTVERSION!, old version: v!OLDVERSION!.!RST!
    echo.
    if exist %disableRetainOldBackups% (
        echo !YLW![*] Deleting old backup...!RST!
        echo.
        rmdir /q /s "%matbak%"
    ) else (
        echo !YLW![*] Renaming old backup...!RST!
        echo.
        rename "%matbak%" "Old Materials Backup (v!OLDVERSION!)"
    )
    if exist %materialUpdaterArg% del /q /s %materialUpdaterArg% > NUL
    if exist ".settings\taskOngoing.txt" del /q /s ".settings\taskOngoing.txt" >nul
    if exist ".settings\.bins.log" del /q /s ".settings\.bins.log" >nul
    if exist ".settings\.restoreList.log" del /q /s ".settings\.restoreList.log" >nul
    if exist ".settings\lastPack.txt" del /q /s ".settings\lastPack.txt" >nul
    if exist "%backupDate%" del /q /s "%backupDate%" >nul
    echo !CURRENTVERSION!>%oldMinecraftVersion%
    call "modules\backupMaterials"
    timeout 2 > NUL
    )
) else (call "modules\backupMaterials")

for /f "tokens=2 delims==" %%a in ('"wmic os get localdatetime /value"') do (
    set "deiteu=%%a"
    set /a "imy=!deiteu:~2,2!-21"
    set "deiteu=!deiteu:~4,4!"
)

if exist %disableInterruptionCheck% (
    if exist ".settings\taskOngoing.txt" del /q /s ".settings\taskOngoing.txt" >nul
    goto skipInterruptionCheck
)
if exist ".settings\taskOngoing.txt" (
    cls
    echo !YLW![*] Seems like last injection didn't go well...
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
        del /q /s ".settings\taskOngoing.txt" >nul
        timeout 3 >nul
    )
)

:skipInterruptionCheck
if exist %defaultMethod% (
    set /p selectedMethod=<%defaultMethod%
    echo !YLW![*] Opening !selectedMethod! method in 2 seconds...!RST!
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
if exist "%customMinecraftAppPath%" (set usingCustomPath=true)
if exist "%customMinecraftDataPath%" (set usingCustomPath=true)
if exist "%customIObitUnlockerPath%" (set usingCustomPath=true)
if defined usingCustomPath (
    echo !GRY![*] Custom path^(s^) enabled.!RST!
    echo.
)


if "%deiteu%" equ "0726" echo !BLU!Happy birthday rwxrw-r-- U+1F337 ^(%imy%^)!RST!
set RESTORETYPE=
if %time:~0,2% geq 00 if %time:~0,2% lss 05 echo !WHT!You should sleep now.
if %time:~0,2% geq 05 if %time:~0,2% lss 12 echo !WHT!Good morning
if %time:~0,2% geq 12 if %time:~0,2% lss 18 echo !WHT!Good afternoon
if %time:~0,2% geq 18 if %time:~0,2% lss 22 echo !WHT!Good evening
if %time:~0,2% geq 22 if %time:~0,2% lss 24 echo !WHT!Good night
echo Welcome to %title%^^!!RST!
echo.
echo !CYN!faizul726.github.io/matject!RST!
echo.
echo.

echo !YLW![?] Which method would you like to use?!RST!
echo.

echo !GRN![1] Auto!RST!
echo Put mcpack/zip file in the MCPACK folder.
echo Matject will extract materials and ask you to inject.
echo.
echo !BLU![2] Manual!RST!
echo Put .material.bin files in the MATERIALS folder.
echo Matject will ask you to inject provided materials. 
echo.
echo !RED![3] matjectNEXT [BETA]!RST!
echo Draco for Windows but not really.
echo.

echo.
echo !WHT![H] Help    [A] About    [S] Settings    [R] Restore ^& Others!RST!
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
echo.
echo [1] Restore default materials
echo [2] Open Minecraft app folder
echo [3] Open Minecraft data folder
echo.
echo !GRN![4] View Matject on GitHub :^)
echo !WHT![5] Visit jq website
echo [6] View material-updater on mcbegamerxx954's GitHub
echo.
echo [7] Replace backup with ZIP file ^(use this if you don't have original materials to start with^)
echo !GRY![8] Reset Global Resource Packs ^(use this if you want to deactivate all active packs^)
echo !RST!
echo !YLW!Press corresponding key to confirm your choice...!RST!
echo.
choice /c 12345678b /n >nul
goto others!errorlevel!

:others9
goto INTRODUCTION

:others8
cls
echo !YLW![?] Are you sure? This will deactivate all active global resource packs.!RST!
echo.
echo [Y] Yes
echo [N] No, go back
echo.
choice /c yn /n >nul
if !errorlevel! neq 1 (goto option7)
if exist "%gamedata%\minecraftpe\global_resource_packs.json" (del /q /s "%gamedata%\minecraftpe\global_resource_packs.json" >nul && echo []>"%gamedata%\minecraftpe\global_resource_packs.json") else (echo []>"%gamedata%\minecraftpe\global_resource_packs.json")
goto option7

:others7
cls
echo !WHT![*] Add materials backup ZIP file in !YLW!"%cd%\Backups"!WHT!.!RED!DO NOT ADD MULTIPLE ZIP FILES.!RST!
echo.
echo !RED![^^!] Current backup will be deleted.!RST!
echo.
echo [*]Don't have any backup file? Send a message in !CYN!discord.gg/yss!RST!. !GRY!It will go back if no backup file is found.!RST!
echo.
explorer "%cd%\Backups"
echo When done,
pause
echo.
if not exist "Backups\*.zip" (
    echo !RED![^^!] No backup file found^^!!RST!
    %backmsg:~0,56%
) else (
    for %%F in (Backups\*.zip) do (
        set "backupFile=%%~nxF"
        goto bkpFound
    )
)
goto option7
:bkpFound
echo !GRN![*] Found backup file:!RST! !backupFile!
echo.
echo !YLW![*] Extracting the backup...!RST!
echo.
if exist "Backups\Materials (backup)" del /q /s "Backups\Materials (backup)\*" >nul
if exist "%backupDate%" del /q /s "%backupDate%" >nul
powershell -NoProfile -Command "Expand-Archive -Force 'Backups\!backupFile!' 'Backups\Materials (backup)\'"
if exist "Backups\Materials (backup)\*.material.bin" (
    echo !GRN![*] Succesfully added materials from !backupFile!.!RST!
    echo %date% // %time%>%backupDate%
    echo.
    pause
) else (
    echo !RED![^^!] Failed to get materials from backup.
    echo    Maybe not an actual backup file or multiple ZIPs?!RST!
    %backmsg:~0,56%
)
set "backupFile="
goto option7

:others6
start https://github.com/mcbegamerxx954/material-updater
goto option7

:others5
start https://jqlang.github.io/jq/
goto option7

:others4
start https://faizul726.github.io/matject
goto option7

:others3
explorer "%localAppData%\packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang"
goto option7 

:others2
explorer "!MCLOCATION!"
goto option7

:others1
call "modules\restoreMaterials"
goto option7

:: HOME OPTIONS

:option6
call "modules\settings"
title %title%
goto INTRODUCTION

:option5
call "modules\about"
title %title%
goto INTRODUCTION

:option4
call "modules\help"
title %title%
goto INTRODUCTION

:option3
:matjectNEXT
if "%debugMode%" neq "true" (
    cls
    echo !YLW![^^!] matjectNEXT is experimental. You can't use it without enabling DEBUG MODE.!RST!
    echo.
    %backmsg:~0,56%
    goto INTRODUCTION
) else (
    call "modules\matjectNEXT\main"
    title Matject %version%%dev%
)

goto INTRODUCTION

:option1
:auto
cls
set MCPACKCOUNT=
echo !YLW![AUTO METHOD SELECTED]!RST!
echo.
echo.
echo.

echo !YLW![^^!] Please add a mcpack/zip in the MCPACK folder.!RST!
echo.
echo.

explorer "%cd%\MCPACK"

echo After adding,
pause



:AUTOLIST
for %%f in ("MCPACK\*.mcpack" "MCPACK\*.zip") do (
    set /a MCPACKCOUNT+=1
    set "MCPACK=%%f"
    set "MCPACKNAME=%%~nxf"
)

if not defined MCPACKCOUNT (
    cls
    echo !ERR![^^!] NO MCPACK/ZIP FOUND.!RST!
    echo.

    echo !YLW![*] Please add mcpack/zip in the MCPACK folder and try again.!RST!
    %backmsg:~0,56%
    cls
    goto INTRODUCTION
)

if %MCPACKCOUNT% gtr 1 (
    cls
    echo !ERR![^^!] MULTIPLE MCPACK/ZIP FOUND.!RST!
    echo.

    echo !YLW![*] Please keep only one mcpack/zip in MCPACK and try again.!RST!
    %backmsg:~0,56%
    cls
    goto INTRODUCTION
)

cls
echo !GRN![*] Found MCPACK/ZIP: "!MCPACKNAME!"!RST!
echo.
if exist %disableConfirmation% goto AUTOEXTRACT

echo !YLW![?] Would you like to use it for injecting? [Y/N]!RST!
echo.

choice /c yn /n >nul

if !errorlevel! neq 1 (
    cls
    goto INTRODUCTION
)



:AUTOEXTRACT
set MCPACKDIR=
if not exist "tmp\" mkdir tmp
copy /d "!MCPACK!" "tmp\mcpack.zip" > NUL
echo.
echo.
echo.

echo !YLW![*] Extracting MCPACK/ZIP to temporary folder...!RST!
echo.

powershell -NoProfile -command "Expand-Archive -LiteralPath 'tmp\mcpack.zip' -DestinationPath 'tmp'"

set "manifestFound="
set "MCPACKDIR="
if exist "tmp\manifest.json" (
    if exist "tmp\renderer\materials\*material.bin" (
        set "MCPACKDIR=tmp"
        goto packokay
    ) else (
        echo !ERR![^^!] Not a RenderDragon shader.!RST!
        goto invalidpack
    )
)

for /d /r "tmp" %%f in (*) do (
    if exist "%%f\manifest.json" (
        set "manifestFound=true"
        if exist "%%f\renderer\materials\*.material.bin" (
            set "MCPACKDIR=%%f"
        ) else (
            echo !ERR![^^!] Not a RenderDragon shader.!RST!
            goto invalidpack
        )
    )
)

if not defined manifestFound (
    echo !ERR![^^!] Not a valid MCPACK^^!!RST!
    goto invalidpack
)

goto packokay
:invalidpack
echo.
echo !YLW![*] Please add a valid mcpack/zip file in the MCPACK folder and try again.!RST!
%backmsg:~0,56%
rmdir /q /s "tmp"
goto INTRODUCTION

:packokay
del /q /s MATERIALS\* >nul
move /Y "!MCPACKDIR!\renderer\materials\*.material.bin" "MATERIALS\" > NUL
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
echo.

explorer "%cd%\MATERIALS"

echo After adding,
pause



:SEARCH
cls
set SRCLIST=
set REPLACELISTEXPORT=
set BINS=
set SRCCOUNT=

echo !YLW![*] Looking for .bin files in the "MATERIALS" folder...!RST!
echo.

if exist "%disableMatCompatCheck%" goto skip_matcheck
call "modules\checkMaterialCompatibility"
if !errorlevel! neq 0 (
    echo !ERR![^^!] Given shader is not for Windows.!RST!
    %backmsg:~0,56%
    del /q /s MATERIALS\* >nul
    if exist "tmp" (rmdir /q /s "tmp")
    goto INTRODUCTION
)
:skip_matcheck

for %%f in (MATERIALS\*.material.bin) do (
    set "MTBIN=%%~nf"
    set "SRCLIST=!SRCLIST!,"%cd%\%%f""
    set "BINS=!BINS!"_!MTBIN:~0,-9!-" "
    set "REPLACELISTEXPORT=!REPLACELISTEXPORT!,"_!MTBIN:~0,-9!-""
    set /a SRCCOUNT+=1
)

if not defined SRCLIST (
    echo !ERR![^^!] NO MATERIALS FOUND.!RST!
    echo.

    echo !YLW![*] Please add .bin files the MATERIALS folder and try again.!RST!
    %backmsg:~0,56%
    cls
    goto INTRODUCTION
)

set "SRCLIST=%SRCLIST:~1%"
set "REPLACELISTEXPORT=%REPLACELISTEXPORT:~1%"
set "REPLACELIST=%REPLACELISTEXPORT:-=.material.bin%"
set "REPLACELIST=%REPLACELIST:_=!MCLOCATION!\data\renderer\materials\%"

echo !GRN![*] Found !SRCCOUNT! material(s) in the "MATERIALS" folder.!RST!
echo.

echo !WHT!Minecraft location:!RST! !MCLOCATION!
echo !WHT!Minecraft version:!RST!  v!CURRENTVERSION!
echo.

echo !CYN![TIP] You can add subpack materials from "!MCPACKDIR!\subpacks" and [R]efresh the list to use them.!RST!
echo.

echo -------- Material list --------
for %%f in (MATERIALS\*) do (
    echo * %%~nxf
)
echo -------------------------------
echo.



:INJECTCONSENT
if exist %disableConfirmation% goto INJECTIONCONFIRMED
echo !YLW![?] Do you want to proceed with injecting? [Y/R/N]!RST!
echo.

choice /c yrn /n >nul

if !errorlevel! equ 1 goto INJECTIONCONFIRMED
if !errorlevel! equ 2 goto SEARCH
if !errorlevel! equ 3 (
    del /q /s MATERIALS\* >nul
    if exist "tmp\" rmdir /q /s "tmp\"
    goto INTRODUCTION
)



:INJECTIONCONFIRMED
cls
echo !YLW![INJECTION CONFIRMED]!RST!
echo.

if exist %thanksMcbegamerxx954% call "modules\updateMaterials"
if exist "tmp\" (rmdir /q /s tmp)
echo.
echo.
if exist ".settings\.bins.log" (
    set "RESTORETYPE=partial"
    call "modules\restoreMaterials"
)



:STEP1
echo !YLW![*] Deleting vanilla materials... ^(Step 1/2^)!RST!
echo.
echo Injection running... [%date% // %time%] > ".settings\taskOngoing.txt"
"%IObitUnlockerPath%" /advanced /delete !REPLACELIST! >nul

if !errorlevel! neq 0 (
    %uacfailed%
    goto STEP1
)



echo !GRN![*] Step 1/2 succeed.!RST!
echo.
echo.



:STEP2
echo !YLW![*] Replacing with provided materials... ^(Step 2/2^)!RST!
echo.

"%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials" >nul

if !errorlevel! neq 0 (
    %uacfailed%
    goto STEP2
)

echo !GRN![*] Step 2/2 succeed.!RST!
if exist "%matbak%\" echo !REPLACELISTEXPORT!>".settings\.restoreList.log" && echo !BINS!>".settings\.bins.log"
del /q /s ".settings\taskOngoing.txt" >nul

if exist "tmp" (rmdir /q /s tmp)

:SUCCESS
cls
echo !GRN![*] INJECTION SUCCEED.!RST!
echo.

if exist %autoOpenMCPACK% (
    if "!MCPACKNAME:~-7,7!" equ ".mcpack" "MCPACK\!MCPACKNAME!"
) 

if not exist %autoOpenMCPACK% (
    if "!MCPACKNAME:~-7,7!" neq ".mcpack" goto skip
    echo !YLW![?] Do you want to import the MCPACK for full experience?!RST!
    echo.
    echo [Y] Yes    [N] No
    echo.
    choice /c yn /n >nul
    if "!errorlevel!" equ "2" goto skip

    echo !GRN![TIP] You can enable Auto open MCPACK from settings.!RST!
    echo.
    "MCPACK\!MCPACKNAME!"
)

:skip
echo !GRN![TIP] Activate the shader resource pack for full experience.!RST!
if exist %disableSuccessMsg% (
    timeout 1 > NUL
    exit
)

echo.
echo.

echo !GRN!Thanks for using Matject, have a good day.!RST!
%exitmsg%