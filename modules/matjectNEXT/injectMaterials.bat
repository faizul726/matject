:: injectMaterials.bat // Made by github.com/faizul726
@echo off
setlocal enabledelayedexpansion

if "[%~1]" equ "[placebo4]" (
    title matjectNEXT: Injecting...
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
    cd ..\..
    call modules\colors
    if not exist "matject.bat" (
        echo !ERR![^^!] Couldn't find Matject folder.!RST!
        echo.
        echo Press any key to exit...
        pause >nul
        exit /b 9
    )
    call "tmp\adminVariables_injectMaterials.bat"
)

if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k

echo.

if exist %disableConfirmation% (goto inject)
echo !BEL!!YLW![*] Press [Y] to confirm injection or [B] to cancel.!RST!
>nul 2>&1 where msg && start /b msg * Resource packs changed. Confirm new materials injection.
echo.
choice /c yb /n >nul
if !errorlevel! neq 1 (
    del /q ".\MATERIALS\*" >nul
    exit /b 9
)

:inject
if /i "!hasSubpack!" equ "true" (
    echo !YLW![*] Injecting !RED!!packName! !GRN!v!packVer!!RST! + !BLU!!subpackName!!RST! ^(!SRCCOUNT! materials^)
) else (
    echo !YLW![*] Injecting !RED!!packName! !GRN!v!packVer!!RST!!RST! ^(!SRCCOUNT! materials^)
)

echo.
echo.

if exist %thanksMcbegamerxx954% call "modules\updateMaterials"


if exist "%rstrList%" (
    set "RESTORETYPE=dynamic"
    call "modules\restoreMaterials"
)

:st1
echo matjectNEXT injection running... [%date% // %time:~0,-6%] > ".settings\taskOngoing.txt"
echo !YLW![*] Step 1/2: Deleting materials to replace...!RST!
echo.
if defined debugMode (
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in (".\Backups%matbak:~7%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)

:: Count materials for warning
set /a warn_matCount_holder=0
for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
    set /a warn_matCount_holder+=1
)

echo.
if not exist "%directWriteMode%" (
    echo !GRY!Executing...
    echo "%IObitUnlockerPath%" /advanced /delete !REPLACELIST:%MCLOCATION%=%WHT%%%MCLOCATION%%%GRY%!!RST!
    echo.
    if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" /b /i
    rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
    "%IObitUnlockerPath%" /advanced /delete !REPLACELIST! >nul
    if !errorlevel! neq 0 (
        %uacfailed%
        cls
        goto st1
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

echo !GRN![*] Step 1/2 OK.!RST!

echo.

:st2
echo !YLW![*] Step 2/2: Replacing materials...!RST!
echo.
if defined debugMode (
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in (".\Backups%matbak:~7%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)

set /a warn_matCount_holder=0
for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
    set /a warn_matCount_holder+=1
)

echo.

if not exist "%directWriteMode%" (
    echo !GRY!Executing...
    echo "%IObitUnlockerPath%" /advanced /move !SRCLIST:!cd!=.! "!WHT!%%MCLOCATION%%!GRY!\data\renderer\materials"!RST!
    echo.
    if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" /b /i
    rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
    "%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials" >nul
    if !errorlevel! neq 0 (
        %uacfailed%
        cls
        goto st2
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

if defined debugMode (
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in (".\Backups%matbak:~7%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    set "_matCount="
    set "_bkpMatCount="
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

echo.
del /q ".\.settings\taskOngoing.txt" >nul
echo !GRN![*] Step 2/2 OK.!RST!

echo.

echo !REPLACELISTEXPORT! >"%rstrList%"

if /i "!hasSubpack!" equ "true" (echo !packuuid: =!_!packVerInt: =!_!subpackName: =!>"%lastRP%") else (echo !packuuid: =!_!packVerInt: =!> "%lastRP%")

set "lastPack=!currentPack!"

(
echo matjectNEXT%isPreview% [%date% // %time:~0,-6%]
echo "CPK: !lastPack!"
echo "SRC: !SRCLIST:%USERNAME%=[REDACTED]!"
echo "RPC: !REPLACELIST!"
echo "RPE: !REPLACELISTEXPORT!"
echo.
)>>"logs\_injectionLogs.txt"

goto:EOF