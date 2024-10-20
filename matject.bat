@echo off
setlocal enabledelayedexpansion
cls
cd "%~dp0"

:: COLORS
set "GRY=[90m"
set "RED=[91m"
set "GRN=[92m"
set "YLW=[93m"
set "BLU=[94m"
set "CYN=[96m"
set "WHT=[97m"
set "RST=[0m"
set "ERR=[41;97m"

REM TODO
REM - ADD DATETIME IN RESTORE CONSENT
REM - DELETE MATERIALS.BAK IF EMPTY
REM - MIGRATE TO CHECK RENDERER FOLDER INSTEAD OF MANIFEST
REM - ADD FOUND DETAILS IN GETMCDETAILS
REM - STORE SHADER NAME FOR LATER USE
REM - MERGE UNLOCK...BAT WITH MATJECT
REM - RENAME MATBAK to Materials (backup)

:: Matject v2.0
:: A shader injector for Minecraft.
:: Made by faizul726
:: https://github.com/faizul726/matject

:: WORK DIRECTORY SETUP
if not exist ".settings\" (
    mkdir .settings
)

if not exist "MCPACK\" (
    mkdir MCPACK
)

if exist "MCPACK\putMcpackHere" (
    del /q /s "MCPACK\putMcpackHere" > NUL
)

if not exist "MATERIALS\" (
    mkdir MATERIALS
)

if exist "MATERIALS\putMaterialsHere" (
    del /q /s "MATERIALS\putMaterialsHere" > NUL
)

if exist "tmp" (
    rmdir /q /s tmp
)


title Matject v2.5 - A shader replacer for Minecraft



:INTRODUCTION
echo !WHT!Matject v2.5 (20241020)!RST!
echo Made by faizul726.
echo Source: !CYN!github.com/faizul726/matject!RST!
echo.

echo A batch script made to replace shader files of Minecraft.
echo.

echo !RED![^^!] May not work for large number of materials.!RST!
echo.

pause
cls



:GETMCDETAILS
echo !YLW![*] Getting Minecraft installation location...!RST!
echo.
REM - ADD "FOUND" HERE
for /f "tokens=*" %%i in ('powershell -command "Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty InstallLocation"') do set "MCLOCATION=%%i"

if not defined MCLOCATION (
    echo !ERR![^^!] Couldn't find Minecraft installation location.!RST!
    echo.

    pause
    goto:EOF
)

echo !YLW![*] Getting Minecraft version...!RST!

for /f "tokens=*" %%i in ('powershell -command "Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty Version"') do set "CURRENTVERSION=%%i"



:MATCHVERSION
if not exist ".settings\oldMinecraftVersion.txt" (
    echo !CURRENTVERSION! > ".settings\oldMinecraftVersion.txt"
)


set /p OLDVERSION=< ".settings\oldMinecraftVersion.txt"
set OLDVERSION=%OLDVERSION: =%



:DELETEOLDBACKUP
if exist "materials.bak\" (
    if "!CURRENTVERSION!" neq "!OLDVERSION!" (
    cls
    echo [^^!] OLD SHADER BACKUP DETECTED
    echo.
    echo.

    echo [*] Current version ^(v!CURRENTVERSION!^) is not same as old version ^(v!OLDVERSION!^).
    echo.
    echo.

    echo [?] Do you want to remove old backup to avoid conflict? [Y/N]
    echo.

    choice /c yn /n

    if !errorlevel! equ 1 (
        rmdir /q /s "materials.bak\"
        del ".settings\oldMinecraftVersion.txt"
        echo !CURRENTVERSION! > ".settings\oldMinecraftVersion.txt"
        ) else (
            echo [^^!] This may cause inconsistency among shader files.
        )
    )
)



:SKIPTOINJECTION
if exist "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker.exe" if exist ".settings\unlockedWindowsApps.txt" (
    cls
    echo [*] Questions skipped because user meets requirements.
    echo.
    goto RESTORECONSENT
)



:IOBITUNLOCKER
cls
if not exist "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker.exe" (
    echo !RED![^^!] You don't have IObit Unlocker installed.!RST!
    echo It's required to use Matject.
    echo.

    echo !YLW![?] Would you like to download now? [Y/N]!RST!
    REM - Add quitting message for N
    REM - Move IObit check to first
    REM - Add :BYE
    echo.

    choice /c yn /n

    if !errorlevel! equ 1 (
        start https://www.iobit.com/en/iobit-unlocker.php
        goto:EOF
    ) else (
        goto BYE
    )
) else (
    echo [*] IObit Unlocker found.
)



:WINDOWSAPPSUNLOCK
REM - CUSTOM LAUNCHER SUPPORT NOT SURE IF IT ACTUALLY WORKS
if /i "%MCLOCATION:~0,28%" neq "C:\Program Files\WindowsApps" (
    echo [%date% %time%] - This file was created to indicate that WindowsApps is already unlocked and skip the question in Matject. > ".settings\unlockedWindowsApps.txt"
    goto RESTORECONSENT
)

cls
echo !YLW![?] Have you unlocked the "WindowsApps" folder? [Y=Yes, N=No/Not sure]!RST!
echo.

choice /c yn /n

if !errorlevel! equ 1 (
    echo [%date% %time%] - This file was created to indicate that WindowsApps is already unlocked and skip the question in Matject. > ".settings\unlockedWindowsApps.txt"
    cls
    goto RESTORECONSENT
)




:WAUNLOCKCONSENT
cls
echo !YLW![?] Do you want to unlock "WindowsApps" folder now? [Y/N]!RST!
echo.

choice /c yn /n

if !errorlevel! neq 1 (
    pause
    goto:EOF
) else (
    cls
    :UAC
    echo !YLW![*] Unlocking "WindowsApps"...!RST!
    echo.

    powershell -command start-process -file unlockWindowsApps.bat -verb runas -Wait
    timeout 1 > NUL
    if not exist ".settings\unlockedWindowsApps.txt" (
        echo !ERR![^^!] Please accept UAC.!RST!
        echo.

        echo !YLW![*] Trying again...!RST!
        echo.
        REM - ADD COOLDOWN and QUIT TIP
        goto UAC
    )
    echo !GRN![*] Unlock succeed.!RST!
    echo.

    pause
)
cls



:RESTORECONSENT
if not exist "materials.bak\" goto BACKUPCONSENT

echo !YLW![^^!] FOUND OLD BACKUP!RST!
echo.

echo !YLW![?] Do you want to restore the old backup? [Y/N] [BETA]!RST!
echo.

choice /c yn /n

if !errorlevel! equ 1 (
    cls
    set RESTORETYPE=full
    call restoreVanillaShaders
    cls
    title Matject v2.5 - A material replacer for Minecraft
    goto BACKUPCONSENT
)

cls
echo !YLW![^^!] BACKUP SKIPPED BECAUSE AN OLDER BACKUP EXISTS!RST!
echo.
echo.

goto INJECTION



:BACKUPCONSENT
echo !YLW![?] Do you want to backup vanilla materials? [Y/N]!RST!
echo.

choice /c yn /n

if !errorlevel! neq 1 (
    cls
    echo !RED![^^!] BACKUP SKIPPED BY USER!RST!
    echo.
    echo.

    goto INJECTION
)



:BACKUP
cls
xcopy "!MCLOCATION!\data\renderer\materials" "materials.bak" /e /i /h /y
echo.

echo !GRN![^^!] Backup done to "%cd%\materials.bak"!RST!
echo.

pause
cls



:INJECTION
echo !YLW!Which method do you want to try?!RST!
echo.

echo !GRN![1] Auto!RST!
echo Put shader.mcpack/zip in the MCPACK folder. 
echo Matject will extract the its materials to the MATERIALS folder, and ask to inject.
echo.

echo !CYN![2] Manual!RST!
echo Put .material.bin files in the MATERIALS folder. Matject will ask to inject provided materials. 
echo.
echo.
echo !YLW!(Press 1 or 2 to confirm your choice)!RST!
echo.

choice /c 12 /n

if !errorlevel! neq 1 (
    goto MANUAL
)



:AUTO
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
for %%f in ("%cd%\MCPACK\*.mcpack" "%cd%\MCPACK\*.zip") do (
    set /a MCPACKCOUNT+=1
    set "MCPACK=%%f"
    set "MCPACKNAME=%%~nxf"
)

if not defined MCPACKCOUNT (
    cls
    echo !ERR![^^!] NO MCPACK/ZIP FOUND.!RST!
    echo.

    echo !YLW![*] Please add mcpack/zip in the MCPACK folder and try again.!RST!
    echo.

    pause
    cls
    goto INJECTION
)

if %MCPACKCOUNT% gtr 1 (
    cls
    echo !ERR![^^!] MULTIPLE MCPACK/ZIP FOUND.!RST!
    echo.

    echo !YLW![*] Please keep only one mcpack/zip in MCPACK and try again.!RST!
    echo.

    pause
    cls
    goto INJECTION
)

cls
echo !GRN![*] Found MCPACK/ZIP: "!MCPACKNAME!"!RST!
echo.

echo !YLW![?] Would you like to use it for injecting? [Y/N]!RST!
echo.

choice /c yn /n

if !errorlevel! neq 1 (
    cls
    goto INJECTION
)



:AUTOEXTRACT
if not exist "tmp\" mkdir tmp
copy "!MCPACK!" "tmp\mcpack.zip" > NUL
echo.
echo.
echo.

echo !YLW![*] Extracting shader to temporary folder...!RST!
echo.

powershell -command "Expand-Archive -LiteralPath '%cd%\tmp\mcpack.zip' -DestinationPath '%cd%\tmp'"

for /r "tmp" %%f in (manifest.json) do (
    if exist "%%f" (
        set "MCPACKDIR=%%~dpf"
        set "MCPACKDIR=!MCPACKDIR:~0,-1!"
    )
)

if not defined MCPACKDIR (
    rmdir /q /s "tmp"
    echo !ERR![^^!] NOT A VALID MCPACK.!RST!
    echo.
    echo !YLW![*] Please add a valid mcpack/zip in the MCPACK folder and try again.!RST!
    pause
    cls
    goto INJECTION
)

move /Y "!MCPACKDIR!\renderer\materials\*" "MATERIALS\" > NUL
goto SEARCH



:MANUAL
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
set REPLACELIST=
set BINS=
set SRCCOUNT=

echo !YLW![*] Looking for .bin files in the "MATERIALS" folder...!RST!
echo.

for %%f in (MATERIALS\*) do (
    set SRCLIST=!SRCLIST!,"%cd%\%%f"
    set "BINS=!BINS!"%%~nxf" "
    set REPLACELIST=!REPLACELIST!,"%MCLOCATION%\data\renderer\%%f"
    set /a SRCCOUNT+=1
)

if not defined SRCLIST (
    echo !ERR![^^!] NO MATERIALS FOUND.!RST!
    echo.

    echo !YLW![*] Please add .bin files the MATERIALS folder and try again.!RST!
    echo.

    pause
    cls
    goto INJECTION
)

set "SRCLIST=%SRCLIST:~1%"
set "REPLACELIST=%REPLACELIST:~1%"

echo !GRN![*] Found !SRCCOUNT! material(s) in the "MATERIALS" folder.!RST!
echo.

echo !WHT!Minecraft location:!RST! !MCLOCATION!
echo !WHT!Minecraft version:!RST!  v!CURRENTVERSION!
echo.

echo !CYN![TIP] You can add subpack materials from "tmp\subpacks" and ^(R^)efresh the list to use them.!RST!
echo.

echo -------- Material list --------
for %%f in (MATERIALS\*) do (
    echo * %%~nxf
)
echo -------------------------------
echo.



:INJECTCONSENT
echo !YLW![?] Do you want to proceed with injecting? [Y/R/N]!RST!
echo.

choice /c yrn /n

if !errorlevel! equ 1 goto INJECTIONCONFIRMED
if !errorlevel! equ 2 goto SEARCH
if !errorlevel! equ 3 cls && pause && goto:EOF



:INJECTIONCONFIRMED
cls
if exist "tmp\" (
    rmdir /q /s tmp
)
echo !YLW![INJECTION CONFIRMED]!YLW!
echo.
echo.
if exist ".settings\.bins.log" (
    set "RESTORETYPE=partial"
    call restoreVanillaShaders
)



:STEP1
echo !YLW![*] Deleting vanilla materials... ^(Step 1/2^)!RST!
echo.

"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /delete !REPLACELIST!

if !errorlevel! neq 0 (
    cls
    echo !ERR![^^!] PLEASE ACCEPT UAC.!RST!
    echo !YLW![*] Trying again...!RST!
    REM - ADD COOLDOWN
    echo.

    goto STEP1
)



echo !GRN![*] Step 1/2 succeed.!RST!
echo.
echo.



:STEP2
echo !YLW![*] Replacing with provided materials... ^(Step 2/2^)!RST!
echo.

"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials"

if !errorlevel! neq 0 (
    cls
    echo !ERR![^^!] PLEASE ACCEPT UAC.!RST!
    echo !YLW![*] Trying again...!RST!
    goto STEP2
    echo.

)

echo !GRN![*] Step 2/2 succeed.!RST!
if exist "materials.bak\" echo !REPLACELIST! > ".settings\.replaceList.log" && echo !BINS! > ".settings\.bins.log"

if exist "tmp" (
    rmdir /q /s tmp
)

timeout 3 > NUL




:SUCCESS
cls
echo !GRN![*] INJECTION SUCCEED.!RST!
echo.

echo !GRN![TIP] Import and activate the shader resource pack for optimal experience.!RST!
echo.
echo.

echo !CYN!Thanks for using Matject, have a good day.!RST!
echo.

pause
goto:EOF
