@echo off
setlocal enabledelayedexpansion

:: MCBE Material Injector
:: A batch script to inject `.material.bin` files in Minecraft.

:: Made by ChatGPT and faizul726.
:: https://github.com/faizul726/materialinjector



set "mcLocation="
set "found=false"

cls

:: CD TO SCRIPT DIRECTORY

cd "%~dp0"

:: DELETE BLANK FILE

if exist "%cd%\materials\putMaterialsHere" del "%cd%\materials\putMaterialsHere"

:: INTRO

type biloi.txt
echo.
echo.
    echo [97mMCBE Material Injector[0m
    echo A batch script to inject `.material.bin` files in Minecraft.
    echo Made by ChatGPT and faizul726.
    echo. 
    echo [91mTHIS SCRIPT IS EXPERIMENTAL.
    echo Will not work for large number of materials.[0m

    echo.
    echo Source: [4;96mgithub.com/faizul726/materialinjector[0m
    echo.
    pause
cls


:: IObit Unlocker installed?

cls
echo [93mDo you have[0m [97mIObit Unlocker[0m [93minstalled?[0m [[92mY=Yes[0m, [91mN=No[0m]
echo.
echo [93m(Pressing N will open up download page)[0m

echo.
    choice /c yn /n

if errorlevel 2 (
        echo [93mOpening IObit Unlocker page...[0m
    start https://www.iobit.com/en/iobit-unlocker.php
    pause
    goto:exit

) else (
    cls
    cls
    echo [97mNice^^![0m
    echo.
)

:: WindowsApps unlocked?

echo [93mHave you unlocked the WindowsApps folder?[0m [[92mY=Yes[0m, [91mN=No/not sure[0m]
echo.
    choice /c yn /n

if errorlevel 2 (
    goto:locked

) else (
    cls
    echo [97mGreat^^![0m
    echo.
    goto:unlocked
)

:: WindowsApps unlock steps 

:locked

cls
echo [93mThis will unlock the WindowsApps folder. It will take time based on how many apps you have installed.[0m
echo [93mDo you want to unlock?[0m [[92mY=Yes[0m, [91mN=Not now[0m]

    choice /c yn /n

if errorlevel 2 (
    goto:declinedUnlock

) else (
    goto:unlock
)

:unlock
    echo [97mOkay[0m
    echo.
    echo [93mUnlocking...[0m
     if exist claimedOwnership.txt goto:okay
    :unlock2
    echo.
    powershell -command start-process -file takeOwnership.bat -verb runas -Wait
    timeout 1 > NUL
    if exist claimedOwnership.txt (
    goto:okay
) else (
    echo [41;97mPlease accept UAC^^![0m
    echo.
        echo [93mTrying again...[0m

    goto:unlock2
)
    :okay
    cls
    echo [92mUNLOCKED SUCCESSFULLY^^![0m
    echo.

:unlocked

:: GET MINECRAFT LOCATION
for /d %%D in ("%ProgramFiles%\WindowsApps\Microsoft.MinecraftUWP_*") do (
    set "found=true"
    set "mcLocation=%%D"
)

if "%found%"=="false" (
    echo.
    echo [41;97mCouldn't find Minecraft in "C:\Program Files\WindowsApps" :([0m
    echo.
    echo [41;97mPlease install Minecraft :([0m
    echo.
    goto:exit
)

:: Backup vanilla materials?

if "!found!"=="true" (
    echo [93mDo you want to backup vanilla materials?[0m [[92mY=Yes[0m, [91mN=No[0m]
    choice /c yn /n

if errorlevel 2 (
    goto:nobackup

) else (
    goto:backup
)
)

:backup
xcopy "%mcshaderlocation2%" "%cd%\materials.bak" /E /I /H /Y
goto:backupDone



:backupDone
    echo [92mBACKUP DONE^^![0m


:: Find .bin files

:nobackup
cls
echo [93mLooking for .bin files in "materials" folder...[0m
echo.

for %%F in (materials\*) do (
    set srcList=!srcList!,"%cd%\%%F"
    set destList=!destList!,"%mcLocation%\data\renderer\%%F"
    
)
if defined srcList (
    set "srcList=%srcList:~1%"
    set "destList=%destList:~1%"
)

if not defined srcList (
    echo.
    echo [41;97mNo source materials found.[0m
    echo.
    echo [41;97mPlease add .bin files in /materials :([0m
    echo.
    goto:exit
) else (

echo [92mFound .bin files in materials folder^^![0m
    echo.
    echo [93mMinecraft location:[0m !mcLocation!
    echo.
    echo [93mUser provided materials:[0m
    for %%f in (materials\*) do (
    echo [97m%%f[0m
)

:: INJECT MATERIALS CONSENT

    echo Do you want to proceed with injecting? [[92mY=Yes[0m, [91mN=No/not now[0m]
    choice /c yn /n

if errorlevel 2 (
    goto:declined

) else (
    goto:confirmed
)
)
)

:confirmed
    echo. 
    echo [93mDeleting vanilla materials...[0m
    "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /delete !destList!

:confirmed2

echo.
    echo [93mMoving source materials...[0m
    "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move !srcList! "!mcLocation!\data\renderer\materials"

:success
    echo [92mDONE SUCCESSFULLY^^![0m
goto:exit

:declinedUnlock
cls
        echo [41;97mYou can't inject shaders without unlocking the WindowsApps folder![0m

        goto:bye



:declined
cls
:bye
    echo.
    echo [107;30m k, bye bye :v [0m
    echo.
    goto:exit
:exit
endlocal
pause




