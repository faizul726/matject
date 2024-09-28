@echo off
setlocal enabledelayedexpansion
cls
cd "%~dp0"

REM IDEAS
REM - ADD DATETIME IN RESTORE CONSENT
REM - DELETE MATERIALS.BAK IF EMPTY
REM - MIGRATE TO CHECK RENDERER FOLDER INSTEAD OF MANIFEST
REM - USE COLORS AS VAR
REM - ADD FOUND DETAILS IN GETMCDETAILS

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


title Matject v2.0 - A shader injector for Minecraft



:INTRODUCTION
echo Matject v2.0
echo Made by faizul726
echo.

echo A batch script made to replace shader files of Minecraft.
echo.

echo [^^!] May not work for large number of materials.
echo.

echo Source: github.com/faizul726/Matject
echo.

pause
cls



:GETMCDETAILS
echo [*] Getting Minecraft installation location...
echo.

for /f "tokens=*" %%i in ('powershell -command "Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty InstallLocation"') do set "MCLOCATION=%%i"

if not defined MCLOCATION (
    echo [^^!] Couldn't find Minecraft installation location.
    echo.

    pause
    goto:EOF
)

echo [*] Getting Minecraft version...

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
    echo [^^!] You don't have IObit Unlocker installed.
    echo It's required to use Matject.
    echo.

    echo [?] Would you like to download now?
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
if /i "%MCLOCATION:~0,28%" neq "C:\Program Files\WindowsApps" (
    echo [%date% %time%] - This file was created to indicate that WindowsApps is already unlocked and skip the question in Matject. > ".settings\unlockedWindowsApps.txt"
    goto RESTORECONSENT
)

cls
echo [?] Have you unlocked the "WindowsApps" folder? [Y/N]
echo.

choice /c yn /n

if !errorlevel! equ 1 (
    echo [%date% %time%] - This file was created to indicate that WindowsApps is already unlocked and skip the question in Matject. > ".settings\unlockedWindowsApps.txt"
    cls
    goto RESTORECONSENT
)




:WAUNLOCKCONSENT
cls
echo [?] Do you want to unlock "WindowsApps" folder now? [Y/N]
echo.

choice /c yn /n

if !errorlevel! neq 1 (
    pause
    goto:EOF
) else (
    cls
    :UAC
    echo [*] Unlocking "WindowsApps"...
    echo.

    powershell -command start-process -file unlockWindowsApps.bat -verb runas -Wait
    timeout 1 > NUL
    if not exist ".settings\unlockedWindowsApps.txt" (
        echo [^^!] Please accept UAC.
        echo.

        echo [*] Trying again...
        echo.

        goto UAC
    )
    echo [*] Unlock succeed.
    echo.

    pause
)
cls



:RESTORECONSENT
if not exist "materials.bak\" goto BACKUPCONSENT

echo [^^!] FOUND OLD BACKUP
echo.

echo [?] Do you want to restore the old backup? [Y/N] [BETA]
echo.

choice /c yn /n

if !errorlevel! equ 1 (
    cls
    set RESTORETYPE=full
    call restoreVanillaShaders
    cls
    title Matject v2.0 - A material replacer for Minecraft
    goto BACKUPCONSENT
)

cls
echo [^^!] BACKUP SKIPPED BECAUSE AN OLDER BACKUP EXISTS
echo.
echo.

goto INJECTION



:BACKUPCONSENT
echo [?] Do you want to backup vanilla materials? [Y/N]
echo.

choice /c yn /n

if !errorlevel! neq 1 (
    cls
    echo [^^!] BACKUP SKIPPED BY USER
    echo.
    echo.

    goto INJECTION
)



:BACKUP
cls
xcopy "!MCLOCATION!\data\renderer\materials" "materials.bak" /e /i /h /y
echo.

echo [^^!] Backup done to "%cd%\materials.bak"
echo.

pause
cls



:INJECTION
echo Which method do you want to try?
echo.

echo [1] Auto approach
echo Put shader.mcpack/zip in the MCPACK folder. 
echo Matject will extract the its materials to the MATERIALS folder, and ask to inject.
echo.

echo [2] Manual approach
echo Put .material.bin files in the MATERIALS folder. Matject will ask to inject provided materials. 
echo.
echo.
echo (Press 1 or 2 to confirm your choice)
echo.

choice /c 12 /n

if !errorlevel! neq 1 (
    goto MANUAL
)



:AUTO
cls
set MCPACKCOUNT=
echo [AUTO APPROACH SELECTED]
echo.
echo.
echo.

echo [^^!] Please add a mcpack/zip in the MCPACK folder.
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
    echo [^^!] NO MCPACK/ZIP FOUND.
    echo.

    echo [*] Please add mcpack/zip in the MCPACK folder and try again.
    echo.

    pause
    cls
    goto INJECTION
)

if %MCPACKCOUNT% gtr 1 (
    cls
    echo [^^!] MULTIPLE MCPACK/ZIP FOUND.
    echo.

    echo [*] Please keep only one mcpack/zip in MCPACK and try again.
    echo.

    pause
    cls
    goto INJECTION
)

cls
echo [*] Found MCPACK/ZIP: "!MCPACKNAME!"
echo.

echo [?] Would you like to use it for injecting? [Y/N]
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

echo [*] Extracting shader to temporary folder...
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
    echo [^^!] NOT A VALID MCPACK.
    echo.
    echo [*] Please add a valid mcpack/zip in the MCPACK folder and try again.
    pause
    cls
    goto INJECTION
)

move /Y "!MCPACKDIR!\renderer\materials\*" "MATERIALS\" > NUL
goto SEARCH



:MANUAL
cls
echo [MANUAL APPROACH SELECTED]
echo.
echo.
echo.

echo Please add ".material.bin" files in the "MATERIALS" folder.
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

echo [*] Looking for .bin files in the "MATERIALS" folder...
echo.

for %%f in (MATERIALS\*) do (
    set SRCLIST=!SRCLIST!,"%cd%\%%f"
    set "BINS=!BINS!"%%~nxf" "
    set REPLACELIST=!REPLACELIST!,"%MCLOCATION%\data\renderer\%%f"
    set /a SRCCOUNT+=1
)

if not defined SRCLIST (
    echo [^^!] NO MATERIALS FOUND.
    echo.

    echo [*] Please add .bin files the MATERIALS folder and try again.
    echo.

    pause
    cls
    goto INJECTION
)

set "SRCLIST=%SRCLIST:~1%"
set "REPLACELIST=%REPLACELIST:~1%"

echo [*] Found !SRCCOUNT! material(s) in the "MATERIALS" folder.
echo.

echo Minecraft location: "!MCLOCATION!"
echo Minecraft version:  v!CURRENTVERSION!
echo.

echo [TIP] You can add subpack materials from "tmp\subpacks" and ^(R^)efresh the list to use them.
echo.

echo -------- Material list --------
for %%f in (MATERIALS\*) do (
    echo * %%~nxf
)
echo -------------------------------
echo.



:INJECTCONSENT
echo [?] Do you want to proceed with injecting? [Y/R/N]
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
echo [INJECTION CONFIRMED]
echo.
echo.
if exist ".settings\.bins.log" (
    set /p BINS=< ".settings\.bins.log"
    set "RESTORETYPE=partial"
    call restoreVanillaShaders
)



:STEP1
echo [*] Deleting vanilla materials... ^(Step 1/2^)
echo.

"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /delete !REPLACELIST!

if !errorlevel! neq 0 (
    cls
    echo [^^!] PLEASE ACCEPT UAC.
    echo [*] Trying again...
    echo.

    goto STEP1
)



echo [*] Step 1/2 succeed.
echo.
echo.



:STEP2
echo [*] Replacing with provided materials... ^(Step 2/2^)
echo.

"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials"

if !errorlevel! neq 0 (
    cls
    echo [^^!] PLEASE ACCEPT UAC.
    echo [*] Trying again...
    goto STEP2
    echo.

)

echo [*] Step 2/2 succeed.
if exist "materials.bak\" echo !REPLACELIST! > ".settings\.replaceList.log" && echo !BINS! > ".settings\.bins.log"

timeout 3 > NUL




:SUCCESS
cls
echo [*] INJECTION SUCCEED.
echo.

echo [TIP] Import and activate the shader resource pack for optimal experience.
echo.
echo.

echo Thanks for using Matject, have a good day.
echo.

pause
goto:EOF
