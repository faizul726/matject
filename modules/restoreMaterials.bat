@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

if "!RESTORETYPE!" equ "full" (
    echo !YLW![*] Restore type: Full!RST!
    echo.
    set "RESTORETYPE="
    goto fullRestore
)
if "!RESTORETYPE!" equ "partial" (
    goto partialRestore
)

cls
if not exist "%matbak%\" (
    echo !ERR![^^!] No previous backup found.!RST!
    %backmsg%
) else (
    if exist %backupDate% set /p backupTimestamp=<%backupDate%
)

cls
echo !RED!^< [B] Back!RST!
echo.
echo.
echo !WHT![*] Backup made on: !backupTimestamp!!RST!
echo.
echo !YLW![?] How would you like to restore?!RST!
echo.
echo [1] Full restore ^(slow, restore all materials^)
echo [2] Dynamic restore ^(only restore the ones modified in previous injection^)
echo.
choice /c 12b /n 
if !errorlevel! equ 1 (
    cls
    echo !YLW![*] Restore type: Full!RST!
    echo.
    goto fullRestore
)
if !errorlevel! equ 2 (
    cls
    set "goingVanillaSir=true"
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
echo !GRN!Found !rstrCount! materials(s).!RST!

echo !RED![^^!] Please accept all UAC prompts or it will fail.!RST!
echo.
echo.

timeout 5 > NUL
cls

echo !YLW![*] Running step 1/3: Deleting game materials...!RST!
echo.

:fr-delete
if exist "!MCLOCATION!\data\renderer\materials\" (
    "%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /delete "!MCLOCATION!\data\renderer\materials"
    goto fr-delete
)
echo !GRN![*] Done!RST!
echo.
echo.
echo !YLW![*] Running step 2/3: Creating materials folder...!RST!
echo.
if not exist "tmp\materials" mkdir "tmp\materials"
goto fr-mkdir

cls
if !errorlevel! neq 0 (
    echo !YLW![*] Running step 1/%stepCount%: Deleting game materials...!RST!
    echo.
    echo !ERR!Please accept UAC.!RST!
    echo.
    echo !YLW!Trying again...!RST!
    echo.
    goto fr-delete
)


:fr-mkdir
"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move "%cd%\tmp\materials\" "!MCLOCATION!\data\renderer\"

if !errorlevel! neq 0 (
    cls
    echo !YLW![*] Running step 2/3: Creating materials folder...!RST!
    echo.
    echo !ERR!Please accept UAC.!RST!
    echo.
    echo !YLW!Trying again...!RST!
    echo.
    goto fr-mkdir
) 

echo !GRN![*] Done!RST!
echo.
echo. 
timeout 3 > NUL

:fr-split
cls
echo !YLW![*] Running step 3/3: Moving materials... ^(!rstrCount! left^)!RST!
echo.
set splitCount=
for %%f in ("%matbak%\*") do (
    set /a splitCount+=1
    if !splitCount! leq 20 (
        move /y "%%f" "tmp\" > NUL
    )
)
if not defined splitCount (
    if exist "%matbak%\" (
        rmdir /s /q "%matbak%"
    )
    if exist "tmp\" (
        rmdir /s /q "tmp"
    )
    goto completed
)

:fr-move
set SRCLIST2=
for %%f in (tmp\*) do (
    set SRCLIST2=!SRCLIST2!,"%cd%\%%f"
    echo !YLW![Moving]!RST! %%~nxf
)

"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move !SRCLIST2:~1! "!MCLOCATION!\data\renderer\materials"
if !errorlevel! equ 0 (
    cls
    set /a rstrCount-=20
    goto fr-split
) else (
    cls
    echo !YLW![*] Running step 3/3: Moving materials... ^(!rstrCount! left^)!RST!
    echo.
    echo !ERR!Please accept UAC.!RST!
    echo.
    echo !YLW!Trying again...!RST!
    echo.
    goto fr-move
)



:partialRestore
echo [*] Restoring modified materials from last injection...
echo.
if exist ".settings\.restoreList.log" (
    if exist "tmp\" (
        rmdir /q /s tmp
        mkdir "tmp"
    ) else mkdir "tmp"
    set /p COPYBINS=<".settings\.bins.log"
    if "!RESTORETYPE!" equ "partial" (
        set "RESTORETYPE="
        if not defined isGoingVanilla (
            if "!COPYBINS!" equ "!BINS!" goto:EOF
        ) else (
            set "isGoingVanilla="
        )
    )
    set "COPYBINS=!COPYBINS:_=%matbak%\!"
    set "COPYBINS=!COPYBINS:-=.material.bin!"
    set /p restoreList=< ".settings\.restoreList.log"
    set "restoreList=!restoreList:-=.material.bin!"
    set "restoreList=!restoreList:_=%MCLOCATION%\data\renderer\materials\!"
    for %%f in (!COPYBINS!) do (
        copy /d %%f "tmp" >nul
    )
    goto restore1
) else (
    echo !ERR![^^!] No logs found for previous injection.!RST!
    %backmsg%
)


:restore1
set "SRCLIST2="
for %%f in (tmp\*) do (
    set SRCLIST2=!SRCLIST2!,"%cd%\%%f"
)

"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /delete %restoreList%
if !errorlevel! neq 0 (
    echo !ERR![^^!] Please accept UAC.!RST!
    echo.
    echo Press any key to try again...
    pause > NUL
    cls
    goto restore1
) else (
    echo !GRN![*] Dynamic restore: Step 1/2 succeed^^!!RST!
)

echo.

:restore2
"%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker" /advanced /move !SRCLIST2:~1! "!MCLOCATION!\data\renderer\materials"
if !errorlevel! neq 0 (
    echo !ERR![^^!] Please accept UAC.!RST!
    echo.
    echo Press any key to try again...
    pause > NUL
    cls
    goto restore2
) else (
    echo !GRN![*] Dynamic restore: Step 2/2 succeed^^!!RST!
    echo.
    echo.
    del /q /s ".settings\.restoreList.log" > NUL
    del /q /s ".settings\.bins.log" > NUL
    if defined goingVanillaSir (
        if exist ".settings\lastPack.txt" del /q /s ".settings\lastPack.txt" >nul
        set "goingVanillaSir="
    )
    if exist "tmp\" rmdir /q /s tmp
    timeout 2 > NUL
    goto:EOF
)

:completed
cls
if exist ".settings\.restoreList.log" del /q /s ".settings\.restoreList.log" > NUL
if exist ".settings\.bins.log" del /q /s ".settings\.bins.log" > NUL
if exist ".settings\lastPack.txt" del /q /s ".settings\lastPack.txt" >nul
if exist "%backupDate%" del /q /s "%backupDate%" > NUL
echo !GRN![*] BACKUP RESTORE OK.!RST!
%exitmsg%