:: autoject.bat // Made by github.com/faizul726, licence issued by YSS Group

@echo off

if "[%~1]" equ "[placebo2]" (
    setlocal enabledelayedexpansion
    title Matject: Injecting...
    set "murgi=KhayDhan"

    >nul 2>&1 where fltmc && (
        >nul 2>&1 fltmc && (set isAdmin=true) || (set "isAdmin=")
    ) || (
        >nul 2>&1 where openfiles && (
            >nul 2>&1 openfiles && (set isAdmin=true) || (set "isAdmin=")
        ) || (
            >nul 2>&1 where wmic && (
                >nul 2>&1 (wmic /locale:ms_409 service where ^(name="LanManServer"^) get state /value 2>nul | findstr /i "State=Running" >nul 2>&1)
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

if defined mt_restoreList (
    set "RESTORETYPE=dynamic"
    call "modules\restoreMaterials"
)



:STEP1
echo !YLW![*] Injection: Deleting vanilla materials... ^(Step 1/2^)!RST!
echo Injection running... [%date% // %time:~0,-6%] > "!taskOngoing:~0,-4!.log"
if not defined mt_directWriteMode (if not defined isAdmin (echo     !GRY!Please close the IObit Unlocker message when it appears...!RST![1F))

if defined debugMode (
    echo.
    echo.
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in (".\Backups!matbak:~7!\*") do (set /a _bkpMatCount+=1)
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

if not defined mt_directWriteMode (
    if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" >nul 2>&1
    rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
    if defined debugMode (
        echo:
        echo !GRY![DEBUG] Executing...
        echo "%IObitUnlockerPath%" /advanced /delete !REPLACELIST!!RST!
        echo:
        echo:
    )
    if not defined REPLACELIST (echo REPLACELIST not defined & cmd)
    "%IObitUnlockerPath%" /advanced /delete !REPLACELIST! >nul 2>&1
    if !errorlevel! neq 0 (
        %uacfailed%
        cls
        goto STEP1
    )
) else (
    for %%M in (%REPLACELIST%) do (
        if defined debugMode (
            echo [DEBUG] Executing: del /q /f %%M
            echo.
        )
        del /q /f %%M >nul 2>&1
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
    >nul 2>&1 (where /q msg && msg "%USERNAME%" Injection step 1 didn't complete successfully. Maybe it was blocked by your antivirus.)
    if defined mt_directWriteMode (echo     [Direct write mode])
    echo.
    echo.
    timeout 2 >nul
)


echo [1F[0J!GRN![*] Injection: Step 1/2 succeed.!RST!
rem if exist "%lastRP%" del /q ".\%lastRP%" >nul
call "modules\settingsV3" clear mtnxt_lastResourcePackID
echo.



:STEP2
echo !YLW![*] Injection: Replacing with provided materials... ^(Step 2/2^)!RST!
if not defined mt_directWriteMode (if not defined isAdmin (echo     !GRY!Please close the IObit Unlocker message when it appears...!RST![1F))

if defined debugMode (
    echo.
    echo.
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in (".\Backups!matbak:~7!\*") do (set /a _bkpMatCount+=1)
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

if not defined mt_directWriteMode (
    if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" >nul 2>&1
    rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
    if defined debugMode (
        echo:
        echo !GRY![DEBUG] Executing...
        echo "%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials"!RST!
        echo:
        echo:
    )
    if not defined SRCLIST (echo SRCLIST not defined & cmd)
    if not defined MCLOCATION (echo MCLOCATION not defined & cmd)
    "%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials" >nul 2>&1
    if !errorlevel! neq 0 (
        %uacfailed%
        cls
        goto STEP2
    )
) else (
    for %%M in (%SRCLIST%) do (
        if defined debugMode (
            echo [DEBUG] Executing:
            echo         copy /d /b %%M "!MCLOCATION!\data\renderer\materials"
            echo         del /q /f %%M
            echo.
        )
        rem move /Y %%M "!MCLOCATION!\data\renderer\materials" >nul 2>&1
        copy /d /b %%M "!MCLOCATION!\data\renderer\materials" >nul 2>&1
        del /q /f %%M >nul 2>&1
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
    >nul 2>&1 (where /q msg && msg "%USERNAME%" Injection step 2 didn't complete successfully. Maybe it was blocked by your antivirus.)
    if defined mt_directWriteMode (echo     [Direct write mode])
    echo.
    echo.
    timeout 2 >nul
)
set "warn_matCount="
set "warn_matCount_holder="

echo [1F[0J!GRN![*] Injection: Step 2/2 succeed.!RST!

rem if exist ".\Backups!matbak:~7!" echo !REPLACELISTEXPORT! >"%rstrList%"
if exist ".\Backups!matbak:~7!\*.material.bin" (
    call "modules\settingsV3" set mt_restoreList "!REPLACELISTEXPORT!"
)
if defined selected_mcpack (
    if defined selected_subpack (
        rem echo !MCPACKNAME! + !selected_subpack!>%lastMCPACK%
        call "modules\settingsV3" set mt_lastMCPACK "!MCPACKNAME! + !selected_subpack!"
    ) else (
        rem echo !MCPACKNAME!>%lastMCPACK%
        call "modules\settingsV3" set mt_lastMCPACK "!MCPACKNAME!"
    )
    if defined debugMode (
    echo Auto%isPreview% [%date% // %time:~0,-6%]
    echo "Name: !MCPACKNAME!" + "Subpack: !selected_subpack!" [%date% // %time:~0,-6%]
    echo.
    )>>"logs\_injectionLogs.txt"
) else (
    call "modules\settingsV3" clear mt_lastMCPACK
    if defined debugMode (
    echo Manual%isPreview% [%date% // %time:~0,-6%]
    echo "SRC: !SRCLIST:%USERNAME%=[REDACTED]!"
    echo "RPC: !REPLACELIST!"
    echo "RPE: !REPLACELISTEXPORT!"
    echo.
    )>>"logs\_injectionLogs.txt"
)
del /q /f ".\!taskOngoing:~0,-4!.log" >nul
if exist "tmp" (rmdir /q /s .\tmp)

if defined debugMode (
    echo.
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in (".\Backups!matbak:~7!\*") do (set /a _bkpMatCount+=1)
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