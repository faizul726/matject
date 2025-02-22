@echo off
setlocal enabledelayedexpansion
:: for testing purpose only

:: 1 Add unlockedWindowsApps.txt
:: 2 Make all folders
:: 3 Copy logs
:: 4 matject tree
:: 5 origin + bkp mats details incl. size
:: 6 open minecraft folder
:: 7 disable module verification
:: 8 make all files write(able)

:: Select either MinecraftUWP or MinecraftWindowsBeta
set "productID=MinecraftUWP"

pushd "%~dp0"
pushd ..

set "selfName=%~n0"

if /i [%selfName:~7,1%] equ [_] (set getHash=true) else (set "getHash=")

if /i [%selfName:~0,7%] equ [0_debug] (
    echo Dropped to shell.
    echo.
    echo on
    @cmd
)
if /i [%selfName:~0,7%] equ [1_debug] (
    echo.>.settings\unlockedWindowsApps.txt 
    echo Debug #1: Added unlockedWindowsApps.txt
    echo           Trying to unlock WindowsApps...
    echo.
    (
    takeown /f "%ProgramFiles%\WindowsApps"
    ) && (
        echo [92mUnlock okay...
        echo Output: !errorlevel![0m
    ) || (
        echo [91mSomething went wrong...
        echo Output: !errorlevel![0m
    )
)
if /i [%selfName:~0,7%] equ [2_debug] for %%d in (.settings Backups logs MATERIALS MCPACKS tmp) do (mkdir %%d) & echo Debug #2: Made template folders
if /i [%selfName:~0,7%] equ [3_debug] (
    if not exist "%USERPROFILE%\Desktop\Matject Debug Data" (mkdir "%USERPROFILE%\Desktop\Matject Debug Data")
    for %%f in (.restoreList lastMCPACK lastPack .restoreListPreview lastMCPACKPreview lastPackPreview) do (copy /d ".settings\%%f.log" 1>nul "%USERPROFILE%\Desktop\Matject Debug Data")
    echo Debug #3: Copied logs to "Desktop\Matject Debug Data"
)

if /i [%selfName:~0,7%] equ [4_debug] (
    echo [93mCreating Matject file tree...[0m
    echo.
    if not exist "%USERPROFILE%\Desktop\Matject Debug Data" (mkdir "%USERPROFILE%\Desktop\Matject Debug Data")
    set /a fileCounter=0
    set "fileHash="
    for /r %%F in (".\*") do (set /a fileCounter+=1)
    echo:
    if defined getHash echo Found !fileCounter! files. It will take some time to get file hash.
    set "fileCounter="
    echo:
    (
        echo Date and time:         %date% // %time:~0,-6%
        echo Matject location:      "!cd:%USERNAME%=CENSORED!"
        echo.
        echo.

        tree /f /a
        echo.
        echo:
        echo File sizes:
        for /r %%F in (".\*") do (
            echo %%~nxF - %%~zF B
            if defined getHash (
                for /f "tokens=*" %%A in ('certutil -hashfile "%%~fF" SHA256 ^| findstr /v ":"') do (
                    echo SHA256: %%A
                    echo:
                )
            )
        )
    )>"%USERPROFILE%\Desktop\Matject Debug Data\matject_tree_%date:/=-%.txt"
    echo Debug #4: File tree of Matject created in "Desktop\Matject Debug Data"
)



if /i [%selfName:~0,7%] equ [5_debug] (
    echo [93mGetting %productID% and Matject backup material details...[0m
    echo.
    if defined getHash echo It will take some time to get file hash.
    echo.
    for /f "tokens=1,2 delims=///" %%i in ('powershell -NoProfile -Command "(Get-AppxPackage -Name Microsoft.%productID%).InstallLocation + '///' + (Get-AppxPackage -Name Microsoft.%productID%).Version"') do (
        set MCLOCATION=%%i
        set CURRENTVERSION=%%j
    )

    if not exist "%USERPROFILE%\Desktop\Matject Debug Data" (mkdir "%USERPROFILE%\Desktop\Matject Debug Data")
    set /a fileCounter=0

    (
        echo Date and time:         %date% // %time:~0,-6%
        echo:
        echo Matject location:      "!cd:%USERNAME%=CENSORED!"
        echo MinecraftUWP location: "!MCLOCATION!"
        echo MinecraftUWP version:  v!CURRENTVERSION!
        echo:
        echo:
        echo ### Files in renderer\materials:
        for %%M in ("!MCLOCATION!\data\renderer\materials\*") do (
            set /a fileCounter+=1
            echo %%~nxM - %%~zM B
            if defined getHash (
                for /f "tokens=*" %%A in ('certutil -hashfile "%%~fM" SHA256 ^| findstr /v ":"') do (
                    echo SHA256: %%A
                    echo:
                )
            )
        )
        echo:
        echo File count in renderer\materials: !fileCounter!
        echo:
        echo:
        set /a fileCounter=0

        echo ### Files in Matject backup:
        for %%M in (".\Backups\Materials (backup)\*") do (
            set /a fileCounter+=1
            echo %%~nxM - %%~zM B
            if defined getHash (
                for /f "tokens=*" %%A in ('certutil -hashfile "%%~fM" SHA256 ^| findstr /v ":"') do (
                    echo SHA256: %%A
                    echo:
                )
            )
        )
        echo:
        echo File count in Matject backup: !fileCounter!
        echo:
        echo:
        set /a fileCounter=0

        echo ### Files in Matject backup ^(Preview^):
        for %%M in (".\Backups (Preview)\Materials (backup)\*") do (
            set /a fileCounter+=1
            echo %%~nxM - %%~zM B
            if defined getHash (
                for /f "tokens=*" %%A in ('certutil -hashfile "%%~fM" SHA256 ^| findstr /v ":"') do (
                    echo SHA256: %%A
                    echo:
                )
            )
        )
        echo:
        echo File count in Matject backup ^(Preview^): !fileCounter!
    )>"%USERPROFILE%\Desktop\Matject Debug Data\materials_details_%date:/=-%.txt"

    set "fileCounter="
    echo Debug #5: Details of materials created in "Desktop\Matject Debug Data"
)


if /i [%selfName:~0,7%] equ [6_debug] (
    echo [93mOpening %productID% folder...[0m
    echo.
    for /f "tokens=*" %%i in ('powershell -NoProfile -Command "(Get-AppxPackage -Name Microsoft.%productID%).InstallLocation"') do (
        start "" /i explorer "%%i"
    )
    echo Debug #6: Opened %productID% folder
)


if /i [%selfName:~0,7%] equ [7_debug] (
    echo.>.settings\disableModuleVerification.txt 
    echo Debug #7: Disabled module verification
)


if /i [%selfName:~0,7%] equ [8_debug] (
    for %%F in ("matject.bat" ".\.settings\*.vbs" ".\modules\*" ".\modules\matjectNEXT\*") do (attrib -R "%%~fF")
    echo Debug #8: Made files write^(able^)
)
echo.
echo Press any key to exit...
pause >nul