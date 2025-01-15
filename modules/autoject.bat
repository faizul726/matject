@echo off
setlocal enabledelayedexpansion
if [%1] equ [placebo2] (
    title Matject: Injecting...
    set "murgi=KhayDhan"
    >nul 2>&1 net session && set "isAdmin=true" || set "isAdmin="
    pushd "%~dp0"
    cd ..
    call modules\colors
    if not exist "matject.bat" (
        echo !ERR![^^!] Couldn't find Matject folder.!RST!
        echo.
        echo Press any key to exit...
        pause >nul
        exit /b 9
    )
    call "tmp\adminVariables.bat"
    if exist ".settings\debugMode.txt" (set "debugMode=true") else (set "debugMode=")
)
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k

if exist "%rstrList%" (
    set "RESTORETYPE=partial"
    call "modules\restoreMaterials"
)



:STEP1
echo !YLW![*] Injection: Deleting vanilla materials... ^(Step 1/2^)!RST!
echo Injection running... [%date% // %time:~0,-6%] > ".settings\taskOngoing.txt"
if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
if defined debugMode (
    echo.
    echo !GRY!Executing...
    echo "%%IObitUnlockerPath%%" /advanced /delete !REPLACELIST:%ProgramFiles%\WindowsApps=...!!RST!
    echo.
    echo.
)
"%IObitUnlockerPath%" /advanced /delete !REPLACELIST! >nul
if !errorlevel! neq 0 (
    %uacfailed%
    goto STEP1
)



echo [1F[0J!GRN![*] Injection: Step 1/2 succeed.!RST!
if exist "%lastRP%" del /q /s "%lastRP%" >nul
echo.



:STEP2
echo !YLW![*] Injection: Replacing with provided materials... ^(Step 2/2^)!RST!

if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
if defined debugMode (
    echo.
    echo !GRY!Executing...
    echo "%%IObitUnlockerPath%%" /advanced /move !SRCLIST:%USERNAME%=CENSORED! "!MCLOCATION:%ProgramFiles%\WindowsApps=...!\data\renderer\materials"!RST!
    echo.
    echo.
)
"%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials" >nul
if !errorlevel! neq 0 (
    %uacfailed%
    goto STEP2
)

echo [1F[0J!GRN![*] Injection: Step 2/2 succeed.!RST!

if exist "%matbak%\" echo !REPLACELISTEXPORT! >"%rstrList%"
if defined selected_mcpack (
    if defined selected_subpack (
        echo !MCPACKNAME! + !selected_subpack!>%lastMCPACK%
    ) else (echo !MCPACKNAME!>%lastMCPACK%)
    (
    echo Auto%isPreview% [%date% // %time:~0,-6%]
    echo "Name: !MCPACKNAME!" + "Subpack: !selected_subpack!" [%date% // %time:~0,-6%]
    echo.
    )>>"logs\_injectionLog.txt"
) else (
    del /q %lastMCPACK% >nul 2>&1
    (
    echo Manual%isPreview% [%date% // %time:~0,-6%]
    echo "SRC: !SRCLIST:%USERNAME%=CENSORED!"
    echo "RPC: !REPLACELIST!"
    echo "RPE: !REPLACELISTEXPORT!"
    echo.
    )>>"logs\_injectionLog.txt"
)
del /q /s ".settings\taskOngoing.txt" >nul
if exist "tmp" (rmdir /q /s tmp)