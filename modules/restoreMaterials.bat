@echo off
setlocal enabledelayedexpansion

if [%1] equ [placebo3] (
    title Matject: Restore default materials
    set "murgi=KhayDhan"
    >nul 2>&1 net session && set "isAdmin=true" || set "isAdmin="
    pushd "%~dp0"
    cd ..
    call "modules\colors"
    if not exist "matject.bat" (
        echo !ERR![^^!] Couldn't find Matject folder.!RST!
        echo.
        echo Press any key to exit...
        pause >nul
        exit /b 9
    )
    call "tmp\adminVariables2.bat"
    if exist ".settings\debugMode.txt" (set "debugMode=true") else (set "debugMode=")
)
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
:restoreMaterials
set "isUserInitiated="
if "!RESTORETYPE!" equ "full" (
    echo !YLW![*] Restore type: Full!RST!
    echo.
    set "RESTORETYPE="
    goto fullRestore
)
if "!RESTORETYPE!" equ "partial" (goto partialRestore)

cls
if not exist "%matbak%\" (
    echo !ERR![^^!] No previous backup found.!RST!
    %backmsg%
) else (
    if exist %backupDate% set /p backupTimestamp=<%backupDate%
    echo %hideCursor%>nul
)

cls
echo !RED!^< [B] Back!RST!
echo.
echo !YLW![?] How would you like to restore?!RST!
echo     !GRY!Backup made on:   !backupTimestamp!!RST!
if exist %restoreDate% (
    set /p restoreTimestamp=<%restoreDate%
    echo     %hideCursor%!GRY!Last restored on: !restoreTimestamp!!RST!
)
echo.
echo.
echo !GRN![1] Dynamic Restore!RST!
echo     Only restores the materials modified in previous injection.
echo.
echo !BLU![2] Full Restore !GRY!^(slow^)!RST!
echo     Restores all materials.
echo.
echo !YLW!Press corresponding key to confirm your choice...!RST!
echo.
choice /c 21b /n >nul
if !errorlevel! equ 1 (
    cls
    echo !RED!^< [B] Back!RST!
    echo.
    echo !YLW![?] Are you sure about performing a Full Restore?!RST!
    echo.
    echo !RED![Y] Yes!RST!    !GRN![N] No, go back!RST!
    echo.
    choice /c ynb /n >nul
    if !errorlevel! neq 1 goto restoreMaterials
    set "isUserInitiated=User initiated: "
    cls
    echo !YLW![*] Restore type: Full!RST!
    echo.
    goto fullRestore
)
if !errorlevel! equ 2 (
    cls
    echo !RED!^< [B] Back!RST!
    echo.
    echo !YLW![?] Are you sure about performing a Dynamic Restore?!RST!
    echo.
    echo !RED![Y] Yes!RST!    !GRN![N] No, go back!RST!
    choice /c ynb /n >nul
    if !errorlevel! neq 1 goto restoreMaterials
    set "isUserInitiated=User initiated: "
    cls
    echo !YLW![*] Restore type: Dynamic!RST!
    echo.
    goto partialRestore
)
if !errorlevel! equ 3 goto:EOF


:fullRestore
if exist "tmp\" (
    rmdir /q /s tmp
    mkdir "tmp"
) else (
    mkdir "tmp"
)
set rstrCount=
for %%f in ("%matbak%\*") do (
    set /a rstrCount+=1
)

if not defined rstrCount (
    echo !ERR!"%matbak%" folder is empty.!RST!
    %backmsg%
)

:fullRestore2
echo !GRN!Restoring !rstrCount! materials(s).!RST!
echo.
echo !RED![^^!] Please allow all admin permission requests or it will fail.!RST!
echo.
echo.

timeout 3 > NUL
:fr-delete
echo Full Restore running... [%date% // %time:~0,-6%] > ".settings\taskOngoing.txt"
cls

echo !YLW!!BLINK![*] Running step 1/3: Deleting game materials... ^(may take multiple tries^)!RST!
echo.
if exist "!MCLOCATION!\data\renderer\materials\" (
    if defined debugMode (
        set /a _matCount=0
        set /a _bkpMatCount=0
        for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
        for %%z in ("%matbak%\*") do (set /a _bkpMatCount+=1)
        echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
        echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
        echo.
        set "_matCount="
        set "_bkpMatCount="
    )
    if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
    if defined debugMode (
        echo.
        echo !GRY!Executing...
        echo "%%IObitUnlockerPath%%" /advanced /delete "!MCLOCATION:%ProgramFiles%\WindowsApps=...!\data\renderer\materials"!RST!
        echo.
        echo.
    )
    "%IObitUnlockerPath%" /advanced /delete "!MCLOCATION!\data\renderer\materials" >nul
    if !errorlevel! neq 0 (
        %uacfailed%
    )
    goto fr-delete
)
echo !GRN![*] Done.!RST!
echo.
echo.
echo.
timeout 2 > NUL
goto fr-mkdir

:fr-mkdir
if not exist "tmp\materials\" mkdir "tmp\materials"
cls
echo !YLW!!BLINK![*] Running step 2/3: Creating materials folder...!RST!
echo.
if defined debugMode (
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in ("%matbak%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)
if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
if defined debugMode (
    echo.
    echo !GRY!Executing...
    echo "%%IObitUnlockerPath%%" /advanced /move "!cd:%USERNAME%=CENSORED!\tmp\materials\" "!MCLOCATION:%ProgramFiles%\WindowsApps=...!\data\renderer\"!RST!
    echo.
    echo.
)
"%IObitUnlockerPath%" /advanced /move "%cd%\tmp\materials\" "!MCLOCATION!\data\renderer\" >nul
if !errorlevel! neq 0 (
    %uacfailed%
    goto fr-mkdir
)
if not exist "!MCLOCATION!\data\renderer\materials\" goto fr-mkdir

echo !GRN![*] Done.!RST!
echo.
echo.
echo. 
timeout 2 > NUL

:fr-split
if defined debugMode (
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in ("%matbak%\*") do (set /a _bkpMatCount+=1)
)
set splitCount=
for %%f in ("%matbak%\*") do (
    set /a splitCount+=1
    if !splitCount! leq 20 (move /y "%%f" "tmp\" >nul 2>&1)
)
if not defined splitCount (
    if exist "%matbak%\" (rmdir /s /q "%matbak%")
    if exist "tmp\" (rmdir /q /s "tmp")
    goto completed
)

:fr-move
set SRCLIST2=
cls
echo !YLW!!BLINK![*] Running step 3/3: Moving materials... ^(!rstrCount! left^)!RST!
echo.
if defined debugMode (
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)
for %%f in (tmp\*) do (
    set SRCLIST2=!SRCLIST2!,"%cd%\%%f"
    echo !YLW![Moving]!RST! %%~nxf
)
echo.

if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
if defined debugMode (
    echo.
    echo !GRY!Executing...
    echo "%%IObitUnlockerPath%%" /advanced /move +ExtraComma!SRCLIST2:%USERNAME%=CENSORED! "!MCLOCATION:%ProgramFiles%\WindowsApps=...!\data\renderer\materials"!RST!
    echo.
    echo.
)
"%IObitUnlockerPath%" /advanced /move !SRCLIST2:~1! "!MCLOCATION!\data\renderer\materials" >nul
if !errorlevel! equ 0 (
    cls
    set /a rstrCount-=20
    goto fr-split
) else (
    %uacfailed%
    goto fr-move
)



:partialRestore
echo !WHT![*] Dynamic Restore: Restoring modified materials from last injection...!RST!
echo.
if exist "%rstrList%" (
    if exist "tmp\" (
        rmdir /q /s tmp
        mkdir "tmp"
    ) else mkdir "tmp"
    set /p COPYBINS=<"%rstrList%"
    echo %hideCursor%>nul
    if "!RESTORETYPE!" equ "partial" (
        set "RESTORETYPE="
        if not defined isGoingVanilla (
            if "!COPYBINS:,= !" equ "!BINS!" goto:EOF
        ) else (set "isGoingVanilla=")
    )
    set /p restoreList=<"%rstrList%"
    echo %hideCursor%>nul
    set "COPYBINS=!restoreList:,= !"
    set "COPYBINS=!COPYBINS:_=%matbak%\!"
    set "COPYBINS=!COPYBINS:-=.material.bin!"
    set "restoreList=!restoreList:_=%MCLOCATION%\data\renderer\materials\!"
    set "restoreList=!restoreList:-=.material.bin!"
    for %%f in (!COPYBINS!) do (copy /d %%f "tmp" >nul)
    goto restore1
) else (
    echo !ERR![^^!] No logs found for previous injection.!RST!
    %backmsg%
)

:restore1
echo Dynamic Restore running... [%date% // %time:~0,-6%] > ".settings\taskOngoing.txt"
echo !YLW![*] Dynamic Restore: Step 1/2...!RST!

if defined debugMode (
    echo.
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in ("%matbak%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)

set "SRCLIST2="
for %%f in (tmp\*) do (
    set SRCLIST2=!SRCLIST2!,"%cd%\%%f"
)

if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
if defined debugMode (
    echo.
    echo !GRY!Executing...
    echo "%%IObitUnlockerPath%%" /advanced /delete !restoreList:%ProgramFiles%\WindowsApps=...!!RST!
    echo.
    echo.
)
"%IObitUnlockerPath%" /advanced /delete %restoreList% >nul
if !errorlevel! neq 0 (
    %uacfailed%
    goto restore1
) else (
    echo [1F[0J!GRN![*] Dynamic Restore: Step 1/2 succeed^^!!RST!
)

echo.

:restore2
echo !YLW![*] Dynamic Restore: Step 2/2...!RST!

if defined debugMode (
    echo.
    set /a _matCount=0
    set /a _bkpMatCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
    for %%z in ("%matbak%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)

if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
if defined debugMode (
    echo.
    echo !GRY!Executing...
    echo "%%IObitUnlockerPath%%" /advanced /move +ExtraComma!SRCLIST2:%USERNAME%=CENSORED! "!MCLOCATION:%ProgramFiles%\WindowsApps=...!\data\renderer\materials"!RST!
    echo.
    echo.
)
"%IObitUnlockerPath%" /advanced /move !SRCLIST2:~1! "!MCLOCATION!\data\renderer\materials" >nul
if !errorlevel! neq 0 (
    %uacfailed%
    goto restore2
) else (
    del /q /s ".settings\taskOngoing.txt" >nul
    echo %date% // %time:~0,-6% ^(%isUserInitiated%Dynamic^)>%restoreDate%
    echo [1F[0J!GRN![*] Dynamic Restore: Step 2/2 succeed^^!!RST!
    echo.
    echo.
    if defined debugMode (
        echo.
        set /a _matCount=0
        set /a _bkpMatCount=0
        for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
        for %%z in ("%matbak%\*") do (set /a _bkpMatCount+=1)
        echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
        echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
        echo.
        echo.
        set "_matCount="
        set "_bkpMatCount="
        timeout 2 >nul
    )
    if exist "%lastMCPACK%" del /q /s "%lastMCPACK%" >nul
    if exist "%lastRP%" del /q /s "%lastRP%" >nul
    del /q /s "%rstrList%" > NUL
    if exist "tmp\" rmdir /q /s tmp
    (
        echo Dynamic%isPreview% [%date% // %time:~0,-6%]
        echo "CPYB=!COPYBINS!"
        echo "SRC2: !SRCLIST2:%USERNAME%=CENSORED!"
        echo "RSTR: !restoreList!"
        echo.
    )>>"logs\_restoreLogs.txt"
    timeout 2 > NUL
    goto:EOF
)

:completed
cls
if exist "%rstrList%" del /q /s "%rstrList%" > NUL
if exist "%lastMCPACK%" del /q /s "%lastMCPACK%" >nul
if exist "%lastRP%" del /q /s "%lastRP%" >nul
if exist ".settings\taskOngoing.txt" del /q /s ".settings\taskOngoing.txt" >nul
if exist "%backupDate%" del /q /s "%backupDate%" > NUL
if not exist "%matbak%\*.material.bin" (rmdir /q /s "%matbak%")
echo %date% // %time:~0,-6% ^(%isUserInitiated%Full^)>%restoreDate%
echo !GRN![*] Full Restore OK.!RST!
(
    echo Full Restore%isPreview% [%date% // %time:~0,-6%]
    echo "lastCount: !rstrCount!"
    echo "SRC2: !SRCLIST2:%USERNAME%=CENSORED!"
    echo.
)>>"logs\_restoreLogs.txt"
%exitmsg%