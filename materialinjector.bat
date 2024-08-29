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

set "iobit=%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker"
:: GET MINECRAFT LOCATION
for /d %%D in ("%ProgramFiles%\WindowsApps\Microsoft.MinecraftUWP_*") do (
    set "found=true"
    set "mcLocation="%%D""
    set "mcShaderLocation=%%D\data\renderer\materials\"
        set "mcShaderLocation2=%%D\data\renderer\materials"

)

if "%found%"=="false" (
    echo.
    echo [41;97mCouldn't find Minecraft :([0m
    echo.
    echo [41;97mPlease install Minecraft :([0m
    echo.
    goto:exit
)

:: LIST SOURCE MATERIALS
:: LIST DESTINATION MATERIALS TO DELETE AND REPLACE


if "!found!"=="true" (
    echo Do you want to backup vanilla materials?? [[92mY=Yes[0m, [91mN=No[0m]
    choice /c yn /n

if errorlevel 2 (
    goto:nobackup

) else (
    goto:backup
)

:backup
xcopy "%mcshaderlocation2%" "%cd%\materials.bak" /E /I /H /Y



:nobackup
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
    echo [41;97mPlease add materials in /materials :([0m
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
    echo.
    echo [4mMinecraft location[0m: [92m!mcLocation![0m
    echo.



    echo Do you want to proceed with injecting? [[92mY=Yes[0m, [91mN=No[0m]
    choice /c yn /n

if errorlevel 2 (
    goto:declined

) else (
    goto:confirmed1
)
)
)

:confirmed1
    echo. 
    echo [93mDeleting vanilla materials...[0m
    echo just a random file to check if iobit is working. > status.txt
    "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /delete %destList%
    if exist status.txt (
    echo [...]

) else (
    goto:confirmed2
)

:confirmed2

echo.
    echo [93mMoving source materials...[0m
    echo just a random file to check if iobit is working 2. > status2.txt
    "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move !srcList! "!mcShaderLocation2!"
        if exist status2.txt (
    echo [...]
) else (
    goto:success
)

:success
    echo [92mDONE SUCCESSFULLY[0m
goto:exit
:declined
    echo.
    echo [107;30m k. bye bye :v [0m
    echo.

:exit
endlocal
pause



