@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

::echo !GRN![*] Found !SRCCOUNT! material(s) in the "MATERIALS" folder.!RST!
echo.

if exist %disableConfirmation% (goto inject)
msg * Resource packs changed, injecting new materials...
echo !YLW![*] Press [Y] to confirm injection or [B] to cancel.!RST!
echo.
choice /c yb /N
if !errorlevel! neq 1 goto:EOF

:inject
echo !YLW![*] Injecting !RED!!packName! !GRN!v!packVer!!RST! + !BLU!!subpackName!!RST!
echo.
echo.

if exist %thanksMcbegamerxx954% call "modules\updateMaterials"

::echo Yes, task ongoing -,- > ".settings\taskOngoing.txt"
if exist ".settings\.restoreList.log" (
    set "RESTORETYPE=partial"
    call "modules\restoreMaterials"
)

:st1
echo !YLW![*] Deleting materials to replace...!RST!
echo.
echo !GRY!Executing...
echo "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /delete !REPLACELIST!!RST!
echo.
"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /delete !REPLACELIST!
if !errorlevel! neq 0 (
    echo !ERR![^^!] Please accept UAC.!RST!
    echo.
    echo Press any key to try again...
    pause > NUL
    cls
    goto st1
) else (
    echo !GRN![*] Step 1/2 OK.!RST!
)
echo.

:st2
echo !YLW![*] Replacing materials...!RST!
echo.
echo !GRY!Executing...
echo "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials"
echo.
"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move !SRCLIST! "!MCLOCATION!\data\renderer\materials"
if !errorlevel! neq 0 (
    echo !ERR![^^!] Please accept UAC.!RST!
    echo.
    echo Press any key to try again...
    pause > NUL
    cls
    goto st2
) else (
    echo !GRN![*] Step 2/2 OK.!RST!
)
echo.

echo !REPLACELISTEXPORT!>".settings\.restoreList.log" && echo !BINS!>".settings\.bins.log"

if "!hasSubpack!" equ "true" (echo !packuuid: =!_!packVer2: =!_!subpackName: =! > ".settings\lastPack.txt") else (echo !packuuid: =!_!packVer2: =! > ".settings\lastPack.txt")


::del /q /s ".settings\taskOngoing.txt" > NUL


set "lastPack=!currentPack2!"

goto:EOF