@echo off
setlocal enabledelayedexpansion

:: GARBAGE
 ::   echo.
::    echo [4mSource materials[0m:
  ::  echo [94m!srcList![0m
    ::echo.

   :: echo.
    ::echo [4mMaterials to delete and replace[0m:
    ::echo [91m!destList![0m
    ::echo.

    ::echo.

set "mcLocation="
set "found=false"
set "firstFile=true"
set "firstFile2=true"

set "foundSrc=false"

set "srcList="
set "destList="

cls

type biloi.txt
echo.
echo.
    echo [97mMinecraft Material Injector[0m
    echo Made by ChatGPT and faizul726.
    echo.
    echo [91mTHIS SCRIPT IS EXPERIMENTAL.
    echo Will not work for large amount of materials.[0m

    echo.
    echo Source: [4;96mgithub.com/faizul726/material-injector[0m
    echo.
    pause
cls



:: GET MINECRAFT LOCATION
for /d %%D in ("%ProgramFiles%\WindowsApps\Microsoft.MinecraftUWP_*") do (
    set "found=true"
    set "mcLocation="%%D""
    set "mcShaderLocation=%%D\data\renderer\materials\"
        set "mcShaderLocation2=%%D\data\renderer\materials"

)

if "%found%"=="false" (
    echo.
    echo [41;97mCouldn't find Minecraft in "C:\Program Files\WindowsApps" :([0m
    echo.
    echo [41;97mPlease install Minecraft :([0m
    echo.
    goto:exit
)

:: LIST SOURCE MATERIALS
:: USER CONFIRMATION
:: LIST DESTINATION MATERIALS TO DELETE AND REPLACE

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
    echo.
    takeown /f "%ProgramFiles%\WindowsApps" /r /d y
    icacls "%ProgramFiles%\WindowsApps" /grant *S-1-3-4:F /t /c /l /q
    cls
    echo [92mUNLOCKED SUCCESSFULLY[0m





:unlocked

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




:nobackup
cls
echo [93mLooking for .bin files in "materials" folder...[0m
echo.

for /f "delims=" %%f in ('dir /b /a-d "%cd%\materials" 2^>nul') do (
    if not "!firstFile!"=="true" (
        set "srcList=!srcList!,"
    )
    set "srcList=!srcList!"%cd%\materials\%%f""
    set "firstFile=false"
    set "foundSrc=true"
)
if not !foundSrc! == true (
    echo.
    echo [41;97mNo source materials found.[0m
    echo.
    echo [41;97mPlease add .bin files in /materials :([0m
    echo.
    goto:exit
) else (

for /f "delims=" %%f in ('dir /b /a-d "%cd%\materials"') do (
    if not "!firstFile2!"=="true" (
        set "destList=!destList!,"
    )
    set "destList=!destList!"!mcShaderLocation!%%f""
    set "firstFile2=false"
)
echo [92mFound .bin files in materials folder^^![0m
    echo.
    echo [97mMinecraft location:[0m !mcLocation!
    echo.



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
    echo just a random file to check if iobit is working. > status.txt
    "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /delete %destList%
    if exist status.txt (
    echo [OK]

) else (
    goto:confirmed2
)

:confirmed2

echo.
    echo [93mMoving source materials...[0m
    echo just a random file to check if iobit is working 2. > status2.txt
    "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move !srcList! "!mcShaderLocation2!"
        if exist status2.txt (
    echo [OK]
) else (
    goto:success
)

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




