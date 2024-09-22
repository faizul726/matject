@echo off
setlocal enabledelayedexpansion

:: MCBE Material Injector
:: A batch script to inject `.material.bin` files in Minecraft.

:: Made by ChatGPT and faizul726.
:: https://github.com/faizul726/materialinjector

cd "%~dp0"

:: PATHS
set "oldVer=.settings\.versionOld.txt"
set "skipIntro=.settings\.skipIntroduction.txt"
set "skipConfirmation=.settings\.skipConfirmation.txt"
set "useAutoAlways=.settings\.useAutoAlways.txt"
set "useManualAlways=.settings\.useManualAlways.txt"


cls
title MatJect v1.0 by faizul726

:: DELETE BLANK FILE
if not exist MATERIALS\ mkdir MATERIALS
if not exist MCPACK\ mkdir MCPACK
if exist "tmp\" rmdir /s /q "tmp"
if exist "MATERIALS\putMaterialsHere" del "MATERIALS\putMaterialsHere"

:: INTRO
if exist %skipIntro% goto GETMCLOC
echo.[92m
type logo.txt
echo.[0m
echo.
echo [97mMCBE Material Injector[0m v1.0
echo.
echo A batch script to inject shader files in Minecraft.
echo Made by ChatGPT and faizul726.
echo. 
echo [91m* May not work for large number of materials.[0m
echo.
echo Source: [4;96mgithub.com/faizul726/materialinjector[0m
echo.
pause
cls

:GETMCLOC
:: GET MINECRAFT LOCATION AND VERSION
echo [93m* Getting Minecraft installation location...[0m 
echo.

for /f "tokens=*" %%i in ('powershell -command "Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty InstallLocation"') do set "mcLocation=%%i"

if not defined mcLocation (
    echo [41;97mCouldn't find Minecraft. :([0m
    echo.
    echo [41;97mPlease install Minecraft.[0m
    echo.
    pause
    goto:EOF
)

echo [93m* Getting Minecraft version...[0m 
for /f "tokens=*" %%i in ('powershell -command "Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty Version"') do set "mcVer=%%i"
echo.


echo [92mFound in: [0m"%mcLocation%"[97m
echo Version:[0m %mcVer%
echo.

if not exist %oldVer% (
    echo !mcVer! > %oldVer%
)

set /p mcVerOld=< "%oldVer%"
set mcVerOld=%mcVerOld: =%

:: MATCH REMOVE OLD BACKUP
if exist %skipConfirmation% goto unlocked
if exist materials.bak (
    if "!mcVer!" neq "%mcVerOld%" (
    cls
    echo [93m[OLD SHADER BACKUP DETECTED]
    echo.
    echo.
    echo [93mCurrent version ^(!mcVer!^) is not same as old version ^(%mcVerOld%^)^^!
    echo.
    echo * Do you want to remove old backup to avoid inconsistencies? [0m[[92mY=Yes[0m, [91mN=No[0m]
    echo.
    choice /c yn /n
    if %errorlevel% equ 1 (
        rmdir /s /q "materials.bak\"
        del %oldVer%
        ) else goto inconsistency
    )
)
goto skip2injection
:inconsistency
echo [91m[^^!] This may cause inconsistency among shader files^^![0m
echo.
pause

::SKIP TO INJECTION
:skip2injection
if exist "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker.exe" (
    if exist unlockedWindowsApps.txt (
        cls
        echo [97m* IObit Unlocked installed and WindowsApps unlocked.[92m
        echo Skipping to injection...[0m
        timeout 2 > NUL
        cls
        goto unlocked
    )
)

:: IOBIT UNLOCKER INSTALLED?
cls
echo [93m* Do you have "IObit Unlocker" installed? [0m[[92mY=Yes[0m, [91mN=No[0m]
echo.
echo [97m(Pressing N will open up download page)[0m
echo.
choice /c yn /n

if errorlevel 2 (
    cls
    if exist "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker.exe" (
    echo [97mYou already have IObit Unlocker [92minstalled[97m^^![0m
    echo.
    echo.
    echo.
    goto unlockWindowsApps
    )
    echo.
    echo [93mOpening IObit Unlocker page...[0m
    echo.
    start https://www.iobit.com/en/iobit-unlocker.php
    pause
    goto:EOF
) else (
    cls
    if not exist "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker.exe" (
        echo.
        echo   [97mu bad bad  [91m^>:[[93m
        echo   u dont have iobit unlocker installed in the default directory.[0m
        echo.
        pause
        goto:EOF
    )
    echo [97mNice^^![0m
    echo.
)

:unlockWindowsApps
:: WINDOWSAPPS UNLOCKED?
echo [93m* Have you unlocked the "WindowsApps" folder? [0m[[92mY=Yes[0m, [91mN=No/not sure[0m]
echo.
echo [97m(Pressing N will ask to unlock)[0m
echo.
choice /c yn /n

if %errorlevel% equ 2 goto locked
else (
    cls
    if not exist unlockedWindowsApps.txt (echo [%date% %time%] - This file was created to indicate that WindowsApps is already unlocked and to skip the questions in MatJect. > unlockedWindowsApps.txt)
    echo [97mGreat^^![0m
    echo.
    goto unlocked
)

:locked
:: UNLOCKING WINDOWSAPPS
cls
if exist unlockedWindowsApps.txt (
    echo [93m[^^!] You have already unlocked WindowsApps^^![0m
    echo.
    goto unlocked
)

echo [93mThis will unlock the WindowsApps folder, which may take some time.
echo.
echo * Do you want to unlock? [0m[[92mY=Yes[0m, [91mN=Not now[0m]
echo.
choice /c yn /n

if errorlevel 2 goto declinedUnlock

:unlock
cls
echo [97mOkay,[0m
echo.
echo [93mUnlocking WindowsApps...[0m
if exist unlockedWindowsApps.txt (
    echo [97mYou have already unlocked WindowsApps^^![0m
    echo.
    goto unlocked
)

:uacPrompt
echo.
powershell -command start-process -file unlockWindowsApps.bat -verb runas -Wait
timeout 1 > NUL
if exist unlockedWindowsApps.txt ( goto unlockDone ) else (
    echo [41;97mPlease accept UAC^^![0m
    echo.
    echo [93mTrying again...[0m
    goto:uacPrompt
)

:unlockDone
cls
echo [92m[UNLOCKED SUCCESSFULLY^^!][0m
echo.


:unlocked
:: BACKUP VANILLA MATERIALS?
set errorlevel=
if exist "materials.bak/" (
    echo [93mYou already have a backup would you like to restore? [0m[[92mY=Yes[0m, [91mN=No[0m] [41;97m[WIP][0m
    echo.
    choice /c yn /n
    
    if %errorlevel% equ 1 (
    set restoreType=full
    call restoreVanillaShaders.bat
    ) else (
        cls
        echo [93m[Skipping backup because a backup already exists][0m
        echo.
        goto injection
)
)


echo [93m* Do you want to backup vanilla materials? [0m[[92mY=Yes[0m, [91mN=No[0m]
echo.
choice /c yn /n

if %errorlevel% equ 1 goto backup
if %errorlevel% equ 2 (
    cls
    echo [91m[BACKUP SKIPPED][0m
    echo.
    goto injection
)

:backup
xcopy "!mcLocation!\data\renderer\materials" "%cd%\materials.bak" /E /I /H /Y
echo.
echo [92m[BACKUP DONE][0m
echo.
pause
cls

:injection
:: WHICH APPROACH TO TRY
if exist %useAutoAlways% goto auto
if exist %useManualAlways% goto manual
echo [93m* Which approach would you like to try? 
echo.
echo.
echo [92m[1] Auto approach[0m
echo Put shader.mcpack/zip in the [93mMCPACK[0m folder. MatJect will extract the mcpack, add its materials to the [93mmaterials [0mfolder, and ask to inject.[97m
echo.
echo [94m[2] Manual approach[0m
echo Put [93m.material.bin[0m files in [93mmaterials[0m folder. MatJect will ask to inject provided materials.
echo.
echo.
echo (Press 1 or 2 to confirm your choice)
echo.
choice /c 12 /n
if %errorLevel% equ 1 goto auto
if %errorLevel% equ 2 goto manual


:auto
:: AUTO APPROACH
cls
if exist %skipConfirmation% goto autoList
set /a mcpackCount=0
set mcpackzip="%cd%\tmp\mcpack.zip"
echo [92m[Auto approach selected][0m
echo.
echo [97mPlease add a [93mmcpack/zip[97m file in the [93m"MCPACK" [97mfolder.[0m
echo.
echo.
echo After adding,
pause
cls


:autoList
for %%f in ("%cd%\MCPACK\*.mcpack" "%cd%\MCPACK\*.zip") do (
    set /a mcpackCount+=1
    set "mcpack="%%f""
    set "mcpackName="%%~nxf""
)

if %mcpackCount% gtr 1 (
    echo [41;97mMultiple MCPACK/ZIPs found. Please keep only one MCPACK/ZIP in MCPACK.[0m
    echo.
    pause
    cls
    goto injection
) else if %mcpackCount% equ 0 (
    echo [41;97mNo MCPACK/ZIP found^^![0m
    echo.
    echo [97mPlease add mcpack or zip in the [93mMCPACK[97m folder and try again.[0m
    echo.
    pause
    goto injection
) else (
    if exist %skipConfirmation% goto autoExtract
    echo [92mFound MCPACK/ZIP:[97m %mcpackName%[93m
    echo.
    echo [93m* Would you like to use it for injecting? [0m[[92mY=Yes[0m, [91mN=Not now, later[0m]
    echo.
    choice /c yn /n
)

if %errorlevel% equ 2 goto bye
:autoExtract
if not exist "tmp\" mkdir tmp

copy %mcpack% "tmp\mcpack.zip" > NUL
echo.
echo.
echo.
echo [93mExtracting shader to temporary folder...[0m
echo.
powershell -command "Expand-Archive -LiteralPath %mcpackzip% -DestinationPath %cd%\tmp"

for /r "tmp" %%f in (manifest.json) do (
    if exist "%%f" (
        set "matPath=%%~dpf"
        set "matPath=!matPath:~0,-1!"
    )
)
if not defined matPath (
    if exist "%cd%\tmp\" rmdir /s /q "%cd%\tmp"
    echo [41;97mNOT A VALID MCPACK.[0m 
    echo.
    echo [97mPlease add a valid mcpack or zip in the [93mMCPACK[97m folder and try again.[0m
    goto injection
)
move /Y "!matPath!\renderer\materials\*" "materials" > NUL
goto search


:manual
:: MANUAL APPROACH
cls
if exist %skipConfirmation% goto search
echo [94m[Manual approach selected][0m
echo.
echo [97mPlease add [93m.material.bin[97m files in the [93m"MATERIALS" [97mfolder.[0m
echo.
echo.
echo After adding,
pause


:search
:: FIND .BIN FILES
cls
echo [93mLooking for .bin files in "materials" folder...[0m
echo.
for %%F in (materials\*) do (
    set srcList=!srcList!,"%cd%\%%F"
    set "bins=!bins!"%%~nxF" "
    set replaceList=!replaceList!,"%mcLocation%\data\renderer\%%F"
    set /a srcCount+=1
)

if defined srcList (
    set "srcList=%srcList:~1%"
    set "replaceList=%replaceList:~1%"
)

if not defined srcList (
    echo.
    echo [41;97mNo materials found.[0m
    echo.
    echo [41;97mPlease add .bin files in materials folder :([0m
    echo.
    pause
    cls
    goto injection
) else (
    echo [92mFound !srcCount! .bin file^(s^) in materials folder^^![0m
    echo.
    echo [97mMinecraft location:[0m !mcLocation!
    echo [97mVersion:[0m !mcVer!
    echo.
    echo [97m-------- Material list --------[0m
    for %%f in (materials\*) do (
        echo * %%~nxf
    )
    echo [97m-------------------------------[0m
    echo.
    if exist %skipConfirmation% goto injecting
)


:: INJECT CONSENT
echo [93m* Do you want to proceed with injecting? [0m[[92mY=Yes[0m, [93mR=Refresh list[0m, [91mN=No/not now[0m]
echo.
echo [92m[TIP] [97mYou can add subpack materials from [93m"!matPath!\subpacks" [97mand refresh the list.
echo.
choice /c yrn /n

if %errorlevel% equ 1 ( 
    cls
    :injecting
    echo [93m[Injection confirmed][93m
    echo.
    if exist ".settings\.replaceList.log" (
        set "restoreType=partial"
        call restoreVanillaShaders
    )
    echo.
    echo.
    goto step1 
)

if %errorlevel% equ 2 ( 
    set srcCount=0
    set srcList=
    set bins=
    set replaceList=
    goto search
)

if %errorlevel% equ 3 (
    cls
    goto bye
)

:step1
echo * Deleting vanilla materials... (Step 1/2)[0m
echo.

"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /delete !replaceList!
if not %errorlevel% equ 0 (
    echo [41;97mPlease accept UAC next time^^![0m
    echo.
    pause
    cls
    goto step1
) else echo [92mStep 1/2 succeed^^![0m
echo.
echo.

:step2
echo [93m* Replacing with provided materials... (Step 2/2)[0m
echo.

"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move !srcList! "!mcLocation!\data\renderer\materials"

if not %errorlevel% equ 0 (
    echo [41;97mPlease accept UAC next time^^![0m
    echo.
    pause
    cls
    goto step2
) else (
    echo [92mStep 2/2 succeed^^![0m
    if exist "materials.bak\" echo !bins! > ".settings\.bins.log" && echo !srcList! > ".settings\.srcList.log" && echo !replaceList! > ".settings\.replaceList.log"
)
timeout 2 > NUL


if exist "tmp\" rmdir /s /q tmp
cls
echo [42;97m [*] INJECTION SUCCEED^^! [0m
if exist %skipConfirmation% (
    pause
    goto:EOF
)
echo.
echo [92m[TIP] [97mImport and activate the shader resource pack for optimal experience.
echo.
echo.
echo Thanks for using [96mMatJect[97m, have a nice day^^! :)[0m
echo.
goto exit

:declinedUnlock
cls
echo [41;97mYou can't inject shaders without unlocking the WindowsApps folder^^![0m
goto:exit

:bye
echo.
echo [107;30m k, bye bye :v [0m
echo.

:exit
endlocal
pause