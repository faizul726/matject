@echo off
setlocal enabledelayedexpansion

cd %~dp0

if not defined mcLocation ( for /f "tokens=*" %%i in ('powershell -command "Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty InstallLocation"') do set "mcLocation=%%i" )
if not exist "tmp\" mkdir tmp

if "%restoreType%" equ "full" (
    goto fullRestore
) else if "%restoreType%"=="partial" (
    goto partialRestore
)

echo [93mHow would you like to restore?[0m
echo %restoreType%
echo.
echo [1] Full restore (restore all materials)
echo [2] Partial restore (only restore the ones modified in previous injection)
echo [3] Exit
echo.
choice /c 123 /n 
if %errorlevel% equ 1 goto fullRestore
if %errorlevel% equ 2 goto partialRestore
if %errorlevel% equ 3 goto:EOF


:fullRestore
cls
echo hi this is still WIP.
pause
goto:EOF

:partialRestore
echo TESTING
if exist ".settings\.replaceList.log" (
    move ".settings\*.log" "tmp\"
    set /p bins=< "tmp\.bins.log"
    set /p srcList=< "tmp\.srcList.log"
    set /p replaceList=< "tmp\.replaceList.log"
    goto restore1
) else echo [41;97mNo logs found for previous injection.[0m

:restore1
"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /delete %replaceList%
if not %errorlevel% equ 0 (
    echo [41;97mPlease accept UAC next time^^![0m
    echo.
    pause
    cls
    goto restore1
) else (
    echo [92mStep 1/2 succeed^^![0m
)
echo.
echo.


:restore2
"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move !srcList! "!mcLocation!\data\renderer\materials"
if not %errorlevel% equ 0 (
    echo [41;97mPlease accept UAC next time^^![0m
    echo.
    pause
    cls
    goto restore2
) else (
    echo [92mStep 2/2 succeed^^![0m
    timeout 2 > NUL
    goto: EOF
)

