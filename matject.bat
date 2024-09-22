@echo off
setlocal enabledelayedexpansion
cls
cd "%~dp0"

echo SINCE MY INJECTOR IS GOING THROUGH FULL REWRITE, IT'S VERY UNSTABLE RIGHT NOW SO I DISABLED THE ABILITY TO USE IT FOR NOW.
pause
goto:EOF

:: FOLDER CREATION
if not exist ".settings\" (
    mkdir .settings
)


title Matject - A material replacer for Minecraft (v2.0)



:INTRODUCTION
echo Matject v2.0
echo.

echo A batch script made to replace shader files of Minecraft.
echo.

echo May not work for large number of materials.
echo.

echo Source: github.com/faizul726/matject
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

::ADD OLD BACKUP DELETION HERE - WIP

:IOBITUNLOCKER
::MIGRATE TO AUTO CHECK
cls
if not exist "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker.exe" (
    echo You don't have IObit Unlocker installed.
    echo.
    echo Would you like to download now?
    echo.
    choice /c yn /n
    if !errorlevel! equ 1 (
        start https://www.iobit.com/en/iobit-unlocker.php
        goto:EOF
    ) else (
        goto BYE
    )
) else (
    echo IObit Unlocker found.
)
