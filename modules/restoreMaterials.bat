:: restoreMaterials.bat // Made by github.com/faizul726, licence issued by YSS Group

@echo off

if "[%~1]" equ "[placebo3]" (
    setlocal enabledelayedexpansion
    title Matject: Restore default materials
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
rem if not defined defaultMaterialsPerCycle (set /a defaultMaterialsPerCycle=10)
rem if not defined materialsPerCycle (set /a materialsPerCycle=!defaultMaterialsPerCycle!)
rem if !materialsPerCycle! lss 2 (set /a materialsPerCycle=!defaultMaterialsPerCycle!)
rem if !materialsPerCycle! gtr 75 (set /a materialsPerCycle=!defaultMaterialsPerCycle!)
if not defined mt_fullRestoreMaterialsPerCycle (
    if defined mt_fullRestoreMaterialsPerCycle_default (
        set "mt_fullRestoreMaterialsPerCycle=!mt_fullRestoreMaterialsPerCycle_default!"
    ) else (
        set "mt_fullRestoreMaterialsPerCycle=10"
    )
)


if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k
:restoreMaterials
set "isUserInitiated="
if /i "!RESTORETYPE!" equ "full" (
    echo !YLW![*] Restore type: Full!RST!
    echo.
    set "RESTORETYPE="
    goto fullRestore
)
if /i "!RESTORETYPE!" equ "dynamic" (goto dynamicRestore)

cls
if not exist ".\Backups!matbak:~7!" (
    echo !ERR![^^!] No previous backup found.!RST!
    %backmsg%
)

:restore_mainScreen
cls
::echo !RED!^< [B] Back !RST!^| Home -^> Tools -^> Restore default materials
if "[%~1]" neq "[placebo3]" (echo !RED!^< [B] Back!RST!) else (echo [?25l!RED!^< [B] Exit!RST!)
echo.
echo !YLW![?] How would you like to restore?!RST!
if defined mt_currentBackupDate (
    echo     !GRY!Backup made on:   !mt_currentBackupDate!!RST!
) else (
    echo     !GRY!Backup made on:   Unknown!RST!
)
echo.
if defined mt_backupRestoreDate (
    echo     !GRY!Last restored on: !mt_backupRestoreDate!!RST!
) else (
    echo     !GRY!Last restored on: Not applicable!RST!
)
echo     Current time:     %date% // %time:~0,-6%

echo.
echo.
echo !GRN![1] Dynamic Restore [Recommended]!RST!
echo     Only restores the materials modified in last injection.
echo.
echo !RED![2] Full Restore !RED![EXPERIMENTAL] !GRY!^(slow^)!RST!
echo     Restores all materials.
echo.
echo !GRY![O] Open Backup folder!RST!
echo.
if defined mt_backupRestoreDate if not defined mt_hideTips (
    echo !GRN![TIP]!RST! If none of the options are removing shaders, then you may have !YLW!"already modified"!RST! materials.
    echo       Press Q to know how to fix...
)
echo.
echo !RED![Warning]!RST!
echo Due to recent reports of full restore being broken, I have reworked the logic of it.
echo It's in somewhat experimental state now and can enter an infinite loop if something blocks it.
echo You can test it if you're brave enough ;^)
echo.
echo !YLW!Press corresponding key to confirm your choice. !GRY!Press Q to know what each action does.!RST!
echo.
choice /c 21qbo /n >nul
if !errorlevel! equ 1 (
    cls
    echo !RED!^< [B] Back!RST!
    echo.
    echo !BEL!!YLW![?] Are you sure about performing a Full Restore?!RST!
    echo.
    echo !RED![^^!] IMPORTANT NOTE:
    echo     Full restore was reworked recently which means it's still in experimental state.
    echo     It may or may not work for you.!RST!
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
    goto dynamicRestore
)
if !errorlevel! equ 3 call "modules\help" "restore" & goto restoreMaterials
if !errorlevel! equ 4 goto :EOF
if !errorlevel! equ 5 start /i explorer "%matbak%"

goto restoreMaterials

:fullRestore
if exist "tmp\" (
    rmdir /q /s tmp
    mkdir "tmp"
) else (
    mkdir "tmp"
)
set rstrCount=
set "rstrCountTotal="
set /a rstrCountProgress=0
set rstrCount_holder=
for %%f in (".\Backups!matbak:~7!\*") do (
    set /a rstrCount+=1
    set /a rstrCount_holder+=1
    set /a rstrCountTotal+=1
)

if not defined rstrCount (
    echo !ERR![^^!] "Backups!matbak:~7!" folder is empty.!RST!
    %backmsg%
)

:fullRestore2
echo !GRN!Restoring !rstrCount! materials.!RST!
if not defined mt_directWriteMode (
    echo.
    if not defined isAdmin echo !RED![^^!] Please allow all admin permission requests or it will fail...!RST!
    echo.
    echo.
)

timeout 3 > NUL
:fr-delete
echo Full Restore running... [%date% // %time:~0,-6%] > "!taskOngoing:~0,-4!.log"
cls

echo !YLW!!BLINK![*] Running step 1/3: Deleting game materials... ^(may take multiple tries^)!RST!
if not defined mt_directWriteMode (if not defined isAdmin (echo     !GRY!Please close the IObit Unlocker message when it appears...!RST!))
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
if exist "!MCLOCATION!\data\renderer\materials\" (
    if not defined mt_directWriteMode (
        if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" >nul 2>&1
        rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
        if defined debugMode (
            echo.
            echo !GRY![DEBUG] Executing...
            echo "%IObitUnlockerPath%" /advanced /delete "!MCLOCATION!\data\renderer\materials"!RST!
            echo.
            echo.
        )
        if not defined MCLOCATION (echo MCLOCATION not defined & cmd)
        "%IObitUnlockerPath%" /advanced /delete "!MCLOCATION!\data\renderer\materials" >nul 2>&1
        if !errorlevel! neq 0 (
            %uacfailed%
        )
    ) else (
        if defined debugMode (
            echo [DEBUG] Executing: rmdir /q /s "!MCLOCATION!\data\renderer\materials"
            echo.
        )
        rmdir /q /s "!MCLOCATION!\data\renderer\materials"
        rem del /q "!MCLOCATION!\data\renderer\materials\*"
        if defined debugMode (echo.)
    )

    set /a warn_matCount=0
    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
        set /a warn_matCount+=1
    )
    if exist "!MCLOCATION!\data\renderer\materials\" (
        if defined mt_directWriteMode (
            echo.
            echo !RED![^^!] Folder not removed. Trying again...!RST!
            echo     [Direct write mode]
            echo.
            echo.
            timeout 2 >nul
        )
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
cls
echo !YLW!!BLINK![*] Running step 2/3: Creating materials folder...!RST!
if not defined mt_directWriteMode (if not defined isAdmin (echo     !GRY!Please close the IObit Unlocker message when it appears...!RST!))
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

if not defined mt_directWriteMode (
    if not exist "tmp\materials\" mkdir "tmp\materials"
    if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" >nul 2>&1
    rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
    if defined debugMode (
        echo.
        echo !GRY![DEBUG] Executing...
        echo "%IObitUnlockerPath%" /advanced /move "!cd!\tmp\materials\" "!MCLOCATION!\data\renderer\"!RST!
        echo.
        echo.
    )
    if not defined MCLOCATION (echo MCLOCATION not defined & cmd)
    "%IObitUnlockerPath%" /advanced /move "%cd%\tmp\materials\" "!MCLOCATION!\data\renderer\" >nul 2>&1
    if !errorlevel! neq 0 (
        %uacfailed%
        goto fr-mkdir
    )
    if not exist "!MCLOCATION!\data\renderer\materials\" goto fr-mkdir
) else (
    if defined debugMode (
        echo [DEBUG] Executing: mkdir "!MCLOCATION!\data\renderer\materials"
        echo.
    )
    mkdir "!MCLOCATION!\data\renderer\materials"
    if defined debugMode (
        echo.
        echo.
    )
)
if not exist "!MCLOCATION!\data\renderer\materials" (
    echo !RED![^^!] Can't create folder. Trying again...!RST!
    goto fr-mkdir
)

echo !GRN![*] Folder creation done.!RST!
echo     Restoring materials now...
echo.
echo.
echo. 
timeout 2 > NUL

:fr-split
set "splitCount="
cls
echo !YLW!!BLINK![*] Running step 3/3: Moving materials... !GRY!^(Listing files...^)!RST!
for %%F in (".\Backups!matbak:~7!\*") do (
    if defined debugMode (
        set /a _matCount=0
        set /a _bkpMatCount=0
        for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
        for %%z in (".\Backups!matbak:~7!\*") do (set /a _bkpMatCount+=1)
    )
    set /a splitCount+=1
    if !splitCount! lss !mt_fullRestoreMaterialsPerCycle! (
        copy /d /b "%%~fF" ".\tmp" >nul 2>&1
        set /a rstrCount_holder-=1
        if !rstrCount_holder! leq 0 goto fr-move
    ) else (
        copy /d /b "%%~fF" ".\tmp" >nul 2>&1
        set /a rstrCount_holder-=1
        set "splitCount="
        :fr-move
        set SRCLIST2=
        echo [H!YLW!!BLINK![*] Running step 3/3: Moving !mt_fullRestoreMaterialsPerCycle! materials per cycle... [0K!GRY!^(!rstrCount! left^)!RST!
        if not defined mt_directWriteMode (if not defined isAdmin (echo     !GRY!Please close the IObit Unlocker message when it appears...!RST!))
        echo.
        call "modules\progressBar" !rstrCountTotal! !rstrCountProgress!
        echo [0J
        if defined debugMode (
            echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
            echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
            echo.
            set "_matCount="
            set "_bkpMatCount="
        )
        for %%f in (tmp\*) do (
            set SRCLIST2=!SRCLIST2!,"%cd%\%%f"
            if defined debugMode (echo !YLW![Moving]!RST! %%~nxf)
        )
        set "SRCLIST2=!SRCLIST2:~1!"
        echo.

        set /a warn_matCount_holder=0
        for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
            set /a warn_matCount_holder+=1
        )

        if not defined mt_directWriteMode (
            if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" >nul 2>&1
            rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
            if defined debugMode (
                echo.
                echo !GRY![DEBUG] Executing...
                echo "%IObitUnlockerPath%" /advanced /move !SRCLIST2! "!MCLOCATION!\data\renderer\materials"!RST!
                echo.
                echo.
            )
            if not defined SRCLIST2 (echo SRCLIST2 not defined & cmd)
            if not defined MCLOCATION (echo MCLOCATION not defined & cmd)
            "%IObitUnlockerPath%" /advanced /move !SRCLIST2! "!MCLOCATION!\data\renderer\materials" >nul 2>&1
            if !errorlevel! equ 0 (
                set /a rstrCount-=!mt_fullRestoreMaterialsPerCycle!
                if !rstrCount! leq 0 (
                    set /a warn_matCount=0
                    for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
                        set /a warn_matCount+=1
                    )
                    if !warn_matCount_holder! equ !warn_matCount! (
                        echo.
                        echo !YLW![^^!] Maybe full restore step 3 didn't complete successfully... !GRY!^(!warn_matCount_holder! EQU !warn_matCount!^)!RST!
                        >nul 2>&1 (where /q msg && msg "%USERNAME%" Full restore step 3 didn't complete successfully. Maybe it was blocked by your antivirus.)
                        if defined mt_directWriteMode (echo     [Direct write mode])
                        echo.
                        echo.
                        timeout 3 >nul
                    )
                    goto completed
                )
            ) else (
                %uacfailed%
                cls
                goto fr-move
            )
        ) else (
            for %%M in (!SRCLIST2!) do (
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
            set /a rstrCount-=!mt_fullRestoreMaterialsPerCycle!
        )

        set /a warn_matCount=0
        for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
            set /a warn_matCount+=1
        )
        if !warn_matCount_holder! equ !warn_matCount! (
            echo.
            echo !YLW![^^!] Maybe full restore step 3 didn't complete successfully... !GRY!^(!warn_matCount_holder! EQU !warn_matCount!^)!RST!
            >nul 2>&1 (where /q msg && msg "%USERNAME%" Full restore step 3 didn't complete successfully. Maybe it was blocked by your antivirus.)
            if defined mt_directWriteMode (echo     [Direct write mode])
            echo.
            echo.
        ) else (
            set /a rstrCountProgress+=!mt_fullRestoreMaterialsPerCycle!
        )
        if defined mt_directWriteMode timeout 3 >nul
    )
)
goto completed

:: ### :fr-split
:: ### set splitCount=
:: ### set /a splitCountTest=0
:: ### set /a progressCcounter=0
:: ### for %%F in (".\Backups!matbak:~7!\*") do (
:: ###     set /a progressCounter+=1
:: ###     :copycounter_loop
:: ###     if defined debugMode (
:: ###         set /a _matCount=0
:: ###         set /a _bkpMatCount=0
:: ###         for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (set /a _matCount+=1)
:: ###         for %%z in (".\Backups!matbak:~7!\*") do (set /a _bkpMatCount+=1)
:: ###     )
:: ###     echo !rstrCount_holder! !splitCount!
:: ###     if !rstrCount_holder! gtr 0 (
:: ###         echo cond 1 met
:: ###         if !splitCount! lss 10 (
:: ###             copy /d /b "%%~fF" ".\tmp" >nul 2>&1
:: ###             set /a rstrCount_holder-=1
:: ###             set /a splitCount+=1
:: ###             if !rstrCount_holder! lss 0 (
:: ###                 echo cond 3 met ****
:: ###                 pause >nul
:: ###                 set splitCount=
:: ###                 call :fr-move bello
:: ###             )
:: ###         ) else (
:: ###             echo ***cond 2 met !rstrCount_holder!
:: ###             pause >nul
:: ###             set splitCount=
:: ###             call :fr-move hello
:: ###         )
:: ###     ) else (
:: ###         echo final cond met !rstrCount_holder!
:: ###         pause >nul
:: ###         set splitCount=
:: ###         call :fr-move jello
:: ###     )
:: ### )
:: ### echo !rstrCount_holder!
:: ### echo just testing
:: ### pause >nul
:: ### :: ### if not defined splitCount (
:: ### :: ###     if exist ".\Backups!matbak:~7!" (rmdir /s /q ".\Backups!matbak:~7!")
:: ### :: ###     if exist ".\tmp" (rmdir /q /s ".\tmp")
:: ### :: ###     goto completed
:: ### :: ### )
:: ### echo Hello i am under the water
:: ### echo [STOP] !progressCounter! geq !rstrCount_holder!
:: ### if !progressCounter! equ !rstrCount_holder! (
:: ###     echo [STOP2] !progressCounter! geq !rstrCount_holder!
:: ###     pause >nul
:: ###     goto completed
:: ### )

:: ### :fr-move
:: ### set SRCLIST2=
:: ### cls
:: ### echo !YLW!!BLINK![*] Running step 3/3: Moving materials... ^(!rstrCount_holder!/!rstrCount! left^)!RST!
:: ### echo.
:: ### if defined debugMode (
:: ###     echo [DEBUG] !RED!!_matCount!!RST! files in MCLOCATION\materials.
:: ###     echo         !GRN!!_bkpMatCount!!RST! files in !matbak!.
:: ###     echo.
:: ###     set "_matCount="
:: ###     set "_bkpMatCount="
:: ### )
:: ### for %%f in (tmp\*) do (
:: ###     set SRCLIST2=!SRCLIST2!,"%cd%\%%f"
:: ###     echo !YLW![Moving]!RST! %%~nxf
:: ### )
:: ### set "SRCLIST2=!SRCLIST2:~1!"
:: ### echo.
:: ### 
:: ### if not exist "%directWriteMode%" (
:: ###     if defined isAdmin start /i /b cmd /c "modules\taskkillLoop" >nul 2>&1
:: ###     rem if defined isAdmin start /MIN /i "Waiting for IObit Unlocker to appear..." "modules\taskkillLoop"
:: ###     if defined debugMode (
:: ###         echo.
:: ###         echo !GRY![DEBUG] Executing...
:: ###         echo "%%IObitUnlockerPath%%" /advanced /move !SRCLIST2:%USERNAME%=[REDACTED]! "!MCLOCATION:%ProgramFiles%\WindowsApps=...!\data\renderer\materials"!RST!
:: ###         echo.
:: ###         echo.
:: ###     )
:: ###     "%IObitUnlockerPath%" /advanced /move !SRCLIST2! "!MCLOCATION!\data\renderer\materials" >nul
:: ###     if !errorlevel! equ 0 (
:: ###         cls
:: ###         set /a rstrCount-=10
:: ###         goto fr-split
:: ###     ) else (
:: ###         %uacfailed%
:: ###         goto fr-move
:: ###     )
:: ### ) else (
:: ###     for %%M in (%SRCLIST2%) do (
:: ###         if defined debugMode (
:: ###             echo [DEBUG] Executing: move /Y %%M "!MCLOCATION!\data\renderer\materials"
:: ###             echo.
:: ###         )
:: ###         move /Y %%M "!MCLOCATION!\data\renderer\materials" >nul 2>&1
:: ###         set /a progressCounter+=1
:: ###     )
:: ###     set /a rstrCount-=10
:: ###     if [%~1] neq [] (
:: ###         goto :EOF
:: ###     )
:: ### )


:dynamicRestore
if defined mt_restoreList (
    if exist ".\tmp" (
        rmdir /q /s .\tmp
        mkdir "tmp"
    ) else mkdir "tmp"
    set "COPYBINS=!mt_restoreList!"
    echo %hideCursor%>nul
    if "!RESTORETYPE!" equ "dynamic" (
        if not defined isGoingVanilla (
            if "!COPYBINS:,= !" equ "!BINS!" goto:EOF
        ) else (set "isGoingVanilla=")
    )
    echo [?25!WHT![*] Dynamic Restore: Restoring modified materials from last injection...!RST!
    echo.
    set "restoreList=!mt_restoreList!"
    set "COPYBINS=!restoreList!"
    set "COPYBINS=!COPYBINS:\=.material.bin!"
    rem new entry start
    set "SRCLIST2=!COPYBINS!"
    set "SRCLIST2=!SRCLIST2:/=%cd%\tmp\!"
    rem new entry end
    set "COPYBINS=!COPYBINS:/=.\Backups%matbak:~7%\!"
    rem Unnecessary line... set "COPYBINS=!COPYBINS:,= !"
    set "restoreList=!restoreList:\=.material.bin!"
    set "restoreList=!restoreList:/=%MCLOCATION%\data\renderer\materials\!"
    for %%f in (!COPYBINS!) do (copy /d /b %%f "tmp" >nul)
    goto restore1
) else (
    echo !ERR![^^!] No logs found for last injection.!RST!
    %backmsg:EOF=restore_mainScreen%
)

:restore1
echo Dynamic Restore running... [%date% // %time:~0,-6%] > "!taskOngoing:~0,-4!.log"
echo !YLW![*] Dynamic Restore: Step 1/2...!RST!
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
        echo.
        echo !GRY![DEBUG] Executing...
        echo "%IObitUnlockerPath%" /advanced /delete !restoreList!!RST!
        echo.
        echo.
    )

    if not defined restoreList (echo restoreList not defined & cmd)
    "%IObitUnlockerPath%" /advanced /delete %restoreList% >nul 2>&1
    if !errorlevel! neq 0 (
        %uacfailed%
        cls
        goto restore1
    )
) else (
    for %%M in (%restoreList%) do (
        if defined debugMode (
            echo [DEBUG] Executing: del /q /f %%M
            echo.
        )
        del /q /f %%M >nul 2>&1
    )
    if defined debugMode (echo.)
)

set /a warn_matCount=0
for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
    set /a warn_matCount+=1
)
if !warn_matCount_holder! equ !warn_matCount! (
    echo.
    echo !YLW![^^!] Maybe dynamic restore step 1 didn't complete successfully... !GRY!^(!warn_matCount_holder! EQU !warn_matCount!^)!RST!
    >nul 2>&1 (where /q msg && msg "%USERNAME%" Dynamic restore step 1 didn't complete successfully. Maybe it was blocked by your antivirus.)
    if defined mt_directWriteMode (echo     [Direct write mode])
    echo.
    echo.
    timeout 2 >nul
)

echo [1F[0J!GRN![*] Dynamic Restore: Step 1/2 succeed^^!!RST!

echo.

:restore2
echo !YLW![*] Dynamic Restore: Step 2/2...!RST!
if not defined mt_directWriteMode (if not defined isAdmin (echo     !GRY!Please close the IObit Unlocker message when it appears...!RST![1F))

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
        echo.
        echo !GRY![DEBUG] Executing...
        echo "%IObitUnlockerPath%" /advanced /move !SRCLIST2! "!MCLOCATION!\data\renderer\materials"!RST!
        echo.
        echo.
    )

    if not defined SRCLIST2 (echo SRCLIST2 not defined & cmd)
    if not defined MCLOCATION (echo MCLOCATION not defined & cmd)
    "%IObitUnlockerPath%" /advanced /move !SRCLIST2! "!MCLOCATION!\data\renderer\materials" >nul 2>&1
    if !errorlevel! neq 0 (
        %uacfailed%
        cls
        goto restore2
    )   
) else (
    for %%M in (%SRCLIST2%) do (
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
    if defined debugMode (echo.)
)

set /a warn_matCount=0
for %%z in ("!MCLOCATION!\data\renderer\materials\*") do (
    set /a warn_matCount+=1
)
if !warn_matCount_holder! equ !warn_matCount! (
    echo.
    echo !YLW![^^!] Maybe dynamic restore step 2 didn't complete successfully... !GRY!^(!warn_matCount_holder! EQU !warn_matCount!^)!RST!
    >nul 2>&1 (where /q msg && msg "%USERNAME%" Dynamic restore step 2 didn't complete successfully. Maybe it was blocked by your antivirus.)
    if defined mt_directWriteMode (echo     [Direct write mode])
    echo.
    echo.
    timeout 2 >nul
)
set "warn_matCount="
set "warn_matCount_holder="

call "modules\settingsV3" set mt_backupRestoreDate "%date% // %time:~0,-6% (%isUserInitiated%Dynamic)"
del /q /f ".\!taskOngoing:~0,-4!.log" >nul
echo [1F[0J!GRN![*] Dynamic Restore: Step 2/2 succeed^^!!RST!
echo.
echo.
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
rem if exist "%lastMCPACK%" del /q ".\%lastMCPACK%" >nul
call "modules\settingsV3" clear mt_lastMCPACK
call "modules\settingsV3" clear mtnxt_lastResourcePackName
rem if exist "%lastRP%" del /q ".\%lastRP%" >nul
call "modules\settingsV3" clear mtnxt_lastResourcePackID
call "modules\settingsV3" clear mt_restoreList
if exist ".\tmp" rmdir /q /s .\tmp
if defined debugMode (
    echo Dynamic%isPreview% [%date% // %time:~0,-6%]
    echo "CPYB=!COPYBINS!"
    echo "SRC2: !SRCLIST2:%USERNAME%=[REDACTED]!"
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

:completed
cls
rem if exist "%rstrList%" del /q ".\%rstrList%" > NUL
call "modules\settingsV3" clear mt_restoreList
rem if exist "%lastMCPACK%" del /q ".\%lastMCPACK%" >nul
call "modules\settingsV3" clear mt_lastMCPACK
rem if exist "%lastRP%" del /q ".\%lastRP%" >nul
call "modules\settingsV3" clear mtnxt_lastResourcePackID
call "modules\settingsV3" clear mtnxt_lastResourcePackName
if exist "!taskOngoing:~0,-4!.log" del /q /f ".\!taskOngoing:~0,-4!.log" >nul
if exist ".\tmp" rmdir /q /s ".\tmp"
rem if exist "%backupDate%" del /q /s ".\%backupDate%" > NUL
rem if exist ".\Backups!matbak:~7!" (rmdir /q /s ".\Backups!matbak:~7!")
rem echo %date% // %time:~0,-6% ^(%isUserInitiated%Full^)>%restoreDate%
call "modules\settingsV3" set mt_backupRestoreDate "%date% // %time:~0,-6% (%isUserInitiated%Full)"


if !warn_matCount! geq !rstrCountTotal! (
    echo !GRN![*] Full Restore completed successfully^^!!RST!
    echo.
    echo !WHT!All default materials have been restored.!RST!
) else (
    echo !RED![^^!] Full Restore maybe incomplete.!RST!
    echo.
    echo !YLW!Not all materials were restored.!RST!
)

set "warn_matCount="
set "warn_matCount_holder="
set "rstrCountTotal="

if defined debugMode (
    echo Full Restore%isPreview% [%date% // %time:~0,-6%]
    echo "lastCount: !rstrCount!"
    echo "SRC2: !SRCLIST2:%USERNAME%=[REDACTED]!"
    echo.
)>>"logs\_restoreLogs.txt"
%backMsg%