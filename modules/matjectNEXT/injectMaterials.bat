@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

::echo !GRN![*] Found !SRCCOUNT! material(s) in the "MATERIALS" folder.!RST!
echo.

if exist %disableConfirmation% (goto inject)
msg * Resource packs changed, injecting new materials...
echo !YLW![*] Press [Y] to confirm injection or [B] to cancel.!RST!
echo.
choice /c yb /n >nul
if !errorlevel! neq 1 (
    del /q /s "MATERIALS\*" >nul
    goto:EOF
)

:inject
echo !YLW![*] Injecting !RED!!packName! !GRN!v!packVer!!RST! + !BLU!!subpackName!!RST!
echo.
echo.

if exist %thanksMcbegamerxx954% call "modules\updateMaterials"


if exist ".settings\.restoreList.log" (
    set "RESTORETYPE=partial"
    call "modules\restoreMaterials"
)

echo matjectNEXT injection running... [%date% // %time%] > ".settings\taskOngoing.txt"
:st1
echo !YLW![*] Deleting materials to replace...!RST!
echo.
echo !GRY!Executing...
echo "%IObitUnlockerPath%" /advanced /delete !REPLACELIST!!RST!
echo.
"%IObitUnlockerPath%" /advanced /delete !REPLACELIST! >nul
if !errorlevel! neq 0 (
    %uacfailed%
    goto st1
) else (
    echo !GRN![*] Step 1/2 OK.!RST!
)
echo.

:st2
echo !YLW![*] Replacing materials...!RST!
echo.
echo !GRY!Executing...
echo "%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials"
echo.
"%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials" >nul
if !errorlevel! neq 0 (
    %uacfailed%
    goto st2
) else (
    echo !GRN![*] Step 2/2 OK.!RST!
)
echo.

echo !REPLACELISTEXPORT!>".settings\.restoreList.log" && echo !BINS!>".settings\.bins.log"

if "!hasSubpack!" equ "true" (echo !packuuid: =!_!packVerInt: =!_!subpackName: =!>".settings\lastPack.txt") else (echo !packuuid: =!_!packVerInt: =!> ".settings\lastPack.txt")

set "lastPack=!currentPack!"

del /q /s ".settings\taskOngoing.txt" >nul

goto:EOF