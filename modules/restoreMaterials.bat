@echo off
setlocal enabledelayedexpansion

if [%1] equ [placebo3] (
    title Matject: Restore default materials
    set "murgi=KhayDhan"

    >nul 2>&1 (wmic /locale:ms_409 service where ^(name="LanManServer"^) get state /value | findstr /i "State=Running") 
    if %errorlevel% equ 0 (
        >nul 2>&1 net session && (set isAdmin=true) || (set "isAdmin=")
    ) else (
        >nul 2>&1 where fltmc && (
            >nul 2>&1 fltmc && (set isAdmin=true) || (set "isAdmin=")
        ) || (
            >nul 2>&1 where openfiles && (
                >nul 2>&1 openfiles && (set isAdmin=true) || (set "isAdmin=")
            ) || (set "isAdmin=")
        )
    )

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
    call "tmp\adminVariables_restoreMaterials.bat"
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
if not exist ".\Backups%matbak:~7%" (
    echo !ERR![^^!] No previous backup found.!RST!
    %backmsg%
) else (
    if exist %backupDate% set /p backupTimestamp=<%backupDate%
    echo %hideCursor%>nul
)

cls
::echo !RED!^< [B] Back !RST!^| Home -^> Tools -^> Restore default materials
if [%1] neq [murgi] (echo !RED!^< [B] Back!RST!) else (echo !RED!^< [B] Exit!RST!)
echo.
echo !YLW![?] How would you like to restore?!RST!
echo     !GRY!Backup made on:   !backupTimestamp!!RST!
if exist %restoreDate% (
    echo.
    set /p restoreTimestamp=<%restoreDate%
    echo     %hideCursor%!GRY!Last restored on: !restoreTimestamp!
    echo     Current time:     %date% // %time:~0,-6%!RST!
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
    echo !BEL!!YLW![?] Are you sure about performing a Full Restore?!RST!
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
    echo !BEL!!YLW![?] Are you sure about performing a Dynamic Restore?!RST!
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
for %%f in (".\Backups%matbak:~7%\*") do (
    set /a rstrCount+=1
)

if not defined rstrCount (
    echo !ERR![^^!] "Backups%matbak:~7%" folder is empty.!RST!
    %backmsg%
)

:fullRestore2
echo !GRN!Restoring !rstrCount! materials(s).!RST!
echo.
echo !RED![^^!] Please allow all admin permission requests or it will fail...!RST!
echo.
echo.

timeout 3 > NUL
:fr-delete
echo Full Restore running... [%date% // %time:~0,-6%] > ".settings\taskOngoing.txt"
cls

echo !YLW!!BLINK![*] Running step 1/3: Deleting game materials... ^(may take multiple tries^)!RST!
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
if exist "!MCLOCATION!\data\renderer\materials\" (
    if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" /b /i
    rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
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
    for %%z in (".\Backups%matbak:~7%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)
if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" /b /i
rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
if defined debugMode (
    echo.
    echo !GRY!Executing...
    echo "%%IObitUnlockerPath%%" /advanced /move "!cd:.!\tmp\materials\" "!MCLOCATION:%ProgramFiles%\WindowsApps=...!\data\renderer\"!RST!
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
    for %%z in (".\Backups%matbak:~7%\*") do (set /a _bkpMatCount+=1)
)
set splitCount=
for %%F in (".\Backups%matbak:~7%\*") do (
    set /a splitCount+=1
    if !splitCount! leq 20 (move /y "%%~fF" ".\tmp" >nul 2>&1)
)
if not defined splitCount (
    if exist ".\Backups%matbak:~7%" (rmdir /s /q ".\Backups%matbak:~7%")
    if exist ".\tmp" (rmdir /q /s ".\tmp")
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

if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" /b /i
rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
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
    if exist ".\tmp" (
        rmdir /q /s .\tmp
        mkdir "tmp"
    ) else mkdir "tmp"
    set /p COPYBINS=<"%rstrList%"
    echo %hideCursor%>nul
    if "!RESTORETYPE!" equ "partial" (
        if not defined isGoingVanilla (
            if "!COPYBINS:,= !" equ "!BINS!" goto:EOF
        ) else (set "isGoingVanilla=")
    )
    set /p restoreList=<"%rstrList%"
    echo %hideCursor%>nul
    
    set "COPYBINS=!restoreList!"
    set "COPYBINS=!COPYBINS:-=.material.bin!"
    rem new entry
    set "SRCLIST2=!COPYBINS!"
    set "SRCLIST2=!SRCLIST2:_=%cd%\tmp\!"
    rem new entry
    set "COPYBINS=!COPYBINS:_=.\Backups%matbak:~7%\!"
    set "COPYBINS=!COPYBINS:,= !"
    set "restoreList=!restoreList:-=.material.bin!"
    set "restoreList=!restoreList:_=%MCLOCATION%\data\renderer\materials\!"
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
    for %%z in (".\Backups%matbak:~7%\*") do (set /a _bkpMatCount+=1)
    echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
    echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
    echo.
    echo.
    set "_matCount="
    set "_bkpMatCount="
)

if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" /b /i
rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
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

rem set "SRCLIST2="
rem for %%f in (tmp\*) do (
rem     set SRCLIST2=!SRCLIST2!,"%cd%\%%f"
rem )
rem echo !SRCLIST2:~1!
rem echo.
rem echo.
rem echo.
rem echo !_SRCLIST2!
rem pause

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

if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" /b /i
rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
if defined debugMode (
    echo.
    echo !GRY!Executing...
    echo "%%IObitUnlockerPath%%" /advanced /move !SRCLIST2:%USERNAME%=CENSORED! "!MCLOCATION:%ProgramFiles%\WindowsApps=...!\data\renderer\materials"!RST!
    echo.
    echo.
)
"%IObitUnlockerPath%" /advanced /move !SRCLIST2! "!MCLOCATION!\data\renderer\materials" >nul
if !errorlevel! neq 0 (
    %uacfailed%
    goto restore2
) else (
    del /q /s ".\.settings\taskOngoing.txt" >nul
    echo %date% // %time:~0,-6% ^(%isUserInitiated%Dynamic^)>%restoreDate%

    echo [1F[0J!GRN![*] Dynamic Restore: Step 2/2 succeed^^!!RST!
    echo.
    echo.
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
    if exist "%lastMCPACK%" del /q /s ".\%lastMCPACK%" >nul
    if exist "%lastRP%" del /q /s ".\%lastRP%" >nul
    del /q /s ".\%rstrList%" > NUL
    if exist ".\tmp" rmdir /q /s .\tmp
    (
        echo Dynamic%isPreview% [%date% // %time:~0,-6%]
        echo "CPYB=!COPYBINS!"
        echo "SRC2: !SRCLIST2:%USERNAME%=CENSORED!"
        echo "RSTR: !restoreList!"
        echo.
    )>>"logs\_restoreLogs.txt"

    if not defined RESTORETYPE (
        set "RESTORETYPE="
        echo !GRN![*] Dynamic Restore completed successfully^^!!RST!
        echo.
        echo !WHT!Default materials have been restored.!RST!
        timeout 3 >nul
    )
    goto :EOF
)

:completed
cls
if exist "%rstrList%" del /q /s ".\%rstrList%" > NUL
if exist "%lastMCPACK%" del /q /s ".\%lastMCPACK%" >nul
if exist "%lastRP%" del /q /s ".\%lastRP%" >nul
if exist ".settings\taskOngoing.txt" del /q /s ".\.settings\taskOngoing.txt" >nul
if exist "%backupDate%" del /q /s ".\%backupDate%" > NUL
if exist ".\Backups%matbak:~7%" (rmdir /q /s ".\Backups%matbak:~7%")
echo %date% // %time:~0,-6% ^(%isUserInitiated%Full^)>%restoreDate%
echo !GRN![*] Full Restore completed successfully^^!!RST!
echo.
echo !WHT!All default materials have been restored.!RST!
(
    echo Full Restore%isPreview% [%date% // %time:~0,-6%]
    echo "lastCount: !rstrCount!"
    echo "SRC2: !SRCLIST2:%USERNAME%=CENSORED!"
    echo.
)>>"logs\_restoreLogs.txt"
%exitmsg%