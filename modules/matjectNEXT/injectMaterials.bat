@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

echo.

if exist %disableConfirmation% (goto inject)
where msg >nul 2>&1
if !errorlevel! equ 0 msg * Resource packs changed, injecting new materials...
echo !YLW![*] Press [Y] to confirm injection or [B] to cancel.!RST!
echo.
choice /c yb /n >nul
if !errorlevel! neq 1 (
    del /q /s "MATERIALS\*" >nul
    goto:EOF
)

:inject
if "!hasSubpack!" equ "true" (
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
echo matjectNEXT injection running... [%date% // %time%] > ".settings\taskOngoing.txt"
echo !YLW![*] Step 1/2: Deleting materials to replace...!RST!
echo.
echo !GRY!Executing...
echo "%IObitUnlockerPath%" /advanced /delete !REPLACELIST:%MCLOCATION%=%WHT%%%MCLOCATION%%%GRY%!!RST!
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
echo !YLW![*] Step 2/2: Replacing materials...!RST!
echo.
echo !GRY!Executing...
echo "%IObitUnlockerPath%" /advanced /move !SRCLIST:%cd%=%WHT%%%CD%%%GRY%! "!WHT!%%MCLOCATION%%!GRY!\data\renderer\materials"
echo.
"%IObitUnlockerPath%" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials" >nul
if !errorlevel! neq 0 (
    %uacfailed%
    goto st2
) else (
    echo !GRN![*] Step 2/2 OK.!RST!
)
echo.

echo !REPLACELISTEXPORT! >"%rstrList%"

if "!hasSubpack!" equ "true" (echo !packuuid: =!_!packVerInt: =!_!subpackName: =!>"%lastRP%") else (echo !packuuid: =!_!packVerInt: =!> "%lastRP%")

set "lastPack=!currentPack!"

del /q /s ".settings\taskOngoing.txt" >nul

goto:EOF