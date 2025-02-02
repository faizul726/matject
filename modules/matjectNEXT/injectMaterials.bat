@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k

echo.

if exist %disableConfirmation% (goto inject)
echo !YLW![*] Press [Y] to confirm injection or [B] to cancel.!RST!
>nul 2>&1 where msg && msg * Resource packs changed, injecting new materials...
echo.
choice /c yb /n >nul
if !errorlevel! neq 1 (
    del /q /s ".\MATERIALS\*" >nul
    exit /b 9
)

:inject
if /i "!hasSubpack!" equ "true" (
    echo !YLW![*] Injecting !RED!!packName! !GRN!v!packVer!!RST! + !BLU!!subpackName!!RST! ^(!SRCCOUNT! materials^)
) else (
    echo !YLW![*] Injecting !RED!!packName! !GRN!v!packVer!!RST!!RST!
)

echo.
echo.

if exist %thanksMcbegamerxx954% call "modules\updateMaterials"


if exist "%rstrList%" (
    set "RESTORETYPE=partial"
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
    for %%z in (".\Backups\%matbak:~8%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)
echo.
echo !GRY!Executing...
echo "%IObitUnlockerPath%" /advanced /delete !REPLACELIST:%MCLOCATION%=%WHT%%%MCLOCATION%%%GRY%!!RST!
echo.
if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
"%IObitUnlockerPath%" /advanced /delete !REPLACELIST! >nul
if !errorlevel! neq 0 (
    %uacfailed%
    goto st1
) else (
    echo !GRN![*] Step 1/2 OK.!RST!
)
echo.

:st2
echo !YLW![*] Step 2/2: Replacing materials...!RST!
echo.
if defined debugMode (
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in (".\Backups\%matbak:~8%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)
echo.
echo !GRY!Executing...
echo "%IObitUnlockerPath%" /advanced /move !SRCLIST:%cd%=%WHT%%%CD%%%GRY%! "!WHT!%%MCLOCATION%%!GRY!\data\renderer\materials"!RST!
echo.
if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
"%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials" >nul
if !errorlevel! neq 0 (
    %uacfailed%
    goto st2
) else (
    if defined debugMode (
        set /a _matCount=0
        set /a _bkpMatCount=0
        for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
        for %%z in (".\Backups\%matbak:~8%\*") do (set /a _bkpMatCount+=1)
        echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
        echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
        echo.
        set "_matCount="
        set "_bkpMatCount="
    )
    echo.
    del /q /s ".\.settings\taskOngoing.txt" >nul
    echo !GRN![*] Step 2/2 OK.!RST!
)
echo.

echo !REPLACELISTEXPORT! >"%rstrList%"

if /i "!hasSubpack!" equ "true" (echo !packuuid: =!_!packVerInt: =!_!subpackName: =!>"%lastRP%") else (echo !packuuid: =!_!packVerInt: =!> "%lastRP%")

set "lastPack=!currentPack!"

(
echo matjectNEXT%isPreview% [%date% // %time:~0,-6%]
echo "CPK: !lastPack!"
echo "SRC: !SRCLIST:%USERNAME%=CENSORED!"
echo "RPC: !REPLACELIST!"
echo "RPE: !REPLACELISTEXPORT!"
echo.
)>>"logs\_injectionLog.txt"

goto:EOF