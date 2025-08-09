:: injectMaterials.bat // Made by github.com/faizul726, licence issued by YSS Group

@echo off

if "[%~1]" equ "[placebo4]" (
    setlocal enabledelayedexpansion
    title matjectNEXT: Injecting...
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

echo [?25l

if defined mt_disableConfirmation (goto inject)
echo !BEL!!YLW![*] Press [Y] to confirm injection or [B] to cancel.!RST!
>nul 2>&1 (where /q msg && start /b msg "%USERNAME%" Resource packs changed. Confirm new materials injection.)
echo.
choice /c yb /n >nul
if !errorlevel! neq 1 (
    del /q /f ".\MATERIALS\*" >nul
    exit /b 9
)
cls

:inject
if /i "!hasSubpack!" equ "true" (
    echo !YLW![*] Injecting !RED!!packName! !GRN!v!packVer!!RST! + !BLU!!subpackName!!RST! ^(!SRCCOUNT! materials^)
) else (
    echo !YLW![*] Injecting !RED!!packName! !GRN!v!packVer!!RST!!RST! ^(!SRCCOUNT! materials^)
)

echo.
echo.

if defined mt_useMaterialUpdater call "modules\updateMaterials"


if defined mt_restoreList (
    set "RESTORETYPE=dynamic"
    call "modules\restoreMaterials"
)

:st1
echo matjectNEXT injection running... [%date% // %time:~0,-6%] > "!taskOngoing:~0,-4!.log"
echo !YLW![*] Step 1/2: Deleting materials to replace...!RST!
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
    set "_matCount="
    set "_bkpMatCount="
)

:: Count materials for warning
set /a warn_matCount_holder=0
for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
    set /a warn_matCount_holder+=1
)

if not defined mt_directWriteMode (
    if defined debugMode (
        echo:
        echo !GRY!Executing...
        echo "%IObitUnlockerPath%" /advanced /delete !REPLACELIST!!RST!
        echo:
        echo:
    )
    if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" >nul 2>&1
    rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
    if not defined REPLACELIST (echo REPLACELIST not defined & cmd)
    "%IObitUnlockerPath%" /advanced /delete !REPLACELIST! >nul 2>&1
    if !errorlevel! neq 0 (
        %uacfailed%
        cls
        goto st1
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

echo.

:st2
echo !YLW![*] Step 2/2: Replacing materials...!RST!
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
    set "_matCount="
    set "_bkpMatCount="
)

set /a warn_matCount_holder=0
for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
    set /a warn_matCount_holder+=1
)

if not defined mt_directWriteMode (
    if defined debugMode (
        echo:
        echo !GRY!Executing...
        echo "%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials"!RST!
        echo:
        echo:
    )
    if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" >nul 2>&1
    rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
    if not defined SRCLIST (echo SRCLIST not defined & cmd)
    if not defined MCLOCATION (echo MCLOCATION not defined & cmd)
    "%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials" >nul 2>&1
    if !errorlevel! neq 0 (
        %uacfailed%
        cls
        goto st2
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

del /q /f ".\!taskOngoing:~0,-4!.log" >nul
echo !GRN![1F[0J[*] Injection: Step 2/2 succeed.!RST!
echo.

if defined debugMode (
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in (".\Backups!matbak:~7!\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)

rem echo !REPLACELISTEXPORT! >"%rstrList%"
call "modules\settingsV3" set mt_restoreList "!REPLACELISTEXPORT!"

if /i "!hasSubpack!" equ "true" (
    rem echo !packuuid: =!_!packVerInt: =!_!subpackName: =!>"%lastRP%"
    call "modules\settingsV3" set mtnxt_lastResourcePackID "!packuuid: =!_!packVerInt: =!_!subpackName: =!"
    call "modules\settingsV3" set mtnxt_lastResourcePackName "!packName! v!packVer! + !subpackName!"
) else (
    rem echo !packuuid: =!_!packVerInt: =!> "%lastRP%"
    call "modules\settingsV3" set mtnxt_lastResourcePackID "!packuuid: =!_!packVerInt: =!"
    call "modules\settingsV3" set mtnxt_lastResourcePackName "!packName! v!packVer!"
)

set "lastPack=!currentPack!"

if defined debugMode (
echo matjectNEXT%isPreview% [%date% // %time:~0,-6%]
echo "CPK: !lastPack!"
echo "SRC: !SRCLIST:%USERNAME%=[REDACTED]!"
echo "RPC: !REPLACELIST!"
echo "RPE: !REPLACELISTEXPORT!"
echo.
)>>"logs\_injectionLogs.txt"

goto:EOF