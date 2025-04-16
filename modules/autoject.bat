:: autoject.bat // Made by github.com/faizul726
@echo off
setlocal enabledelayedexpansion
if "[%~1]" equ "[placebo2]" (
    title Matject: Injecting...
    set "murgi=KhayDhan"

    >nul 2>&1 where fltmc && (
        >nul 2>&1 fltmc && (set isAdmin=true) || (set "isAdmin=")
    ) || (
        >nul 2>&1 where openfiles && (
            >nul 2>&1 openfiles && (set isAdmin=true) || (set "isAdmin=")
        ) || (
            >nul 2>&1 where wmic && (
                >nul 2>&1 (wmic /locale:ms_409 service where ^(name="LanManServer"^) get state /value | findstr /i "State=Running")
                if %errorlevel% equ 0 (
                    >nul 2>&1 net session && (set isAdmin=true) || (set "isAdmin=")
                ) else (set "isAdmin=")
            ) || (set "isAdmin=")
        )
    )

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
    call "tmp\adminVariables_autoject.bat"
)
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k

if exist "%rstrList%" (
    set "RESTORETYPE=dynamic"
    call "modules\restoreMaterials"
)



:STEP1
echo !YLW![*] Injection: Deleting vanilla materials... ^(Step 1/2^)!RST!
echo Injection running... [%date% // %time:~0,-6%] > ".settings\taskOngoing.txt"

if defined debugMode (
    echo.
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in (".\Backups%matbak:~7%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)

:: Count materials for warning
set /a warn_matCount_holder=0
for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
    set /a warn_matCount_holder+=1
)

if not exist "%directWriteMode%" (
    if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" /b /i
    rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
    if defined debugMode (
        echo:
        echo !GRY![DEBUG] Executing...
        echo "%%IObitUnlockerPath%%" /advanced /delete !REPLACELIST:%ProgramFiles%\WindowsApps=...!!RST!
        echo:
        echo:
    )
    "%IObitUnlockerPath%" /advanced /delete !REPLACELIST! >nul
    if !errorlevel! neq 0 (
        %uacfailed%
        cls
        goto STEP1
    )
) else (
    for %%M in (%REPLACELIST%) do (
        if defined debugMode (echo [DEBUG] Executing: del /q %%M)
        del /q %%M >nul 2>&1
        echo.
    )
    if defined debugMode (
        echo.
        timeout 2 >nul
    )
)

set /a warn_matCount=0
for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
    set /a warn_matCount+=1
)
if %warn_matCount_holder% equ %warn_matCount% (
    echo.
    echo !YLW![^^!] Maybe injection step 1 didn't complete successfully... !GRY!^(%warn_matCount_holder% EQU %warn_matCount%^)
    if exist "%directWriteMode%" (echo     [Direct write mode])
    echo.
    echo.
    timeout 2 >nul
)


echo [1F[0J!GRN![*] Injection: Step 1/2 succeed.!RST!
if exist "%lastRP%" del /q ".\%lastRP%" >nul
echo.



:STEP2
echo !YLW![*] Injection: Replacing with provided materials... ^(Step 2/2^)!RST!

if defined debugMode (
    echo.
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in (".\Backups%matbak:~7%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)

set /a warn_matCount_holder=0
for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
    set /a warn_matCount_holder+=1
)

if not exist "%directWriteMode%" (
    if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" /b /i
    rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
    if defined debugMode (
        echo:
        echo !GRY![DEBUG] Executing...
        echo "%%IObitUnlockerPath%%" /advanced /move !SRCLIST:%USERNAME%=[REDACTED]! "!MCLOCATION:%ProgramFiles%\WindowsApps=...!\data\renderer\materials"!RST!
        echo:
        echo:
    )
    "%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials" >nul
    if !errorlevel! neq 0 (
        %uacfailed%
        cls
        goto STEP2
    )
) else (
    for %%M in (%SRCLIST%) do (
        if defined debugMode (echo [DEBUG] Executing: move /Y %%M "!MCLOCATION!\data\renderer\materials")
        move /Y %%M "!MCLOCATION!\data\renderer\materials" >nul 2>&1
        echo.
    )
    if defined debugMode (
        echo.
        timeout 2 >nul
    )
)

set /a warn_matCount=0
for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
    set /a warn_matCount+=1
)
if %warn_matCount_holder% equ %warn_matCount% (
    echo.
    echo !YLW![^^!] Maybe injection step 2 didn't complete successfully... !GRY!^(%warn_matCount_holder% EQU %warn_matCount%^)
    if exist "%directWriteMode%" (echo     [Direct write mode])
    echo.
    echo.
    timeout 2 >nul
)
set "warn_matCount="
set "warn_matCount_holder="

echo [1F[0J!GRN![*] Injection: Step 2/2 succeed.!RST!

if exist ".\Backups%matbak:~7%" echo !REPLACELISTEXPORT! >"%rstrList%"
if defined selected_mcpack (
    if defined selected_subpack (
        echo !MCPACKNAME! + !selected_subpack!>%lastMCPACK%
    ) else (echo !MCPACKNAME!>%lastMCPACK%)
    (
    echo Auto%isPreview% [%date% // %time:~0,-6%]
    echo "Name: !MCPACKNAME!" + "Subpack: !selected_subpack!" [%date% // %time:~0,-6%]
    echo.
    )>>"logs\_injectionLogs.txt"
) else (
    del /q .\%lastMCPACK% >nul 2>&1
    (
    echo Manual%isPreview% [%date% // %time:~0,-6%]
    echo "SRC: !SRCLIST:%USERNAME%=[REDACTED]!"
    echo "RPC: !REPLACELIST!"
    echo "RPE: !REPLACELISTEXPORT!"
    echo.
    )>>"logs\_injectionLogs.txt"
)
del /q ".\.settings\taskOngoing.txt" >nul
if exist "tmp" (rmdir /q /s .\tmp)

if defined debugMode (
    echo.
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in (".\Backups%matbak:~7%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)

timeout 2 >nul
if "[%~1]" equ "[murgi]" exit 0
goto :EOF