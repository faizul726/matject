:: syncMaterials.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

set packuuid=
set packver=
set packVerInt=
set hasSubpack=
set subpackName=
set packPath=
set currentPack=
set lastPack=

echo !YLW![*] Syncing with current global resource packs...!RST!
echo.
call "modules\matjectNEXT\parsePackWithCache"

if /i "!packuuid!" equ "null" (
    echo !YLW![*] No resource pack is activated.!RST!
    echo.
    goto nopacks
)
goto version

:nopacks
if defined mt_restoreList (
    echo !YLW![*] Restoring to default...!RST!
    echo.
    goto restorevanilla
) else (
    echo !GRN![*] Already using vanilla materials, no need to restore.!RST!
    timeout 2 >nul
    goto:end
)
goto:end

:restorevanilla
set "RESTORETYPE=dynamic"
set "isGoingVanilla=true"
if defined isAdmin (
    call "modules\restoreMaterials"
) else (
    if defined mt_runIObitUnlockerAsAdmin (
        echo !YLW!!BLINK![*] Starting IObit Unlocker as admin...!RST!
        echo.
        if exist "tmp\" (del /q /f ".\tmp\*" >nul) else (mkdir tmp)
        (
            echo :: This file was created to pass some of the current variables to restoreMaterials.bat [%date% // %time:~0,-6%]
            echo.
            echo set "BINS=!BINS!"
            echo set "backMsg=!backMsg!"
            echo set "backupRunning=!backupRunning!"
            echo set "matjectSettings=!matjectSettings!"
            echo set "mt_currentBackupDate=!mt_currentBackupDate!"
            echo set "taskOngoing=!taskOngoing!"
            echo set "debugMode=!debugMode!"
            echo set "mt_directWriteMode=!mt_directWriteMode!"
            echo set "exitmsg=!exitMsg!"
            echo set "IObitUnlockerPath=!IObitUnlockerPath!"
            echo set "isGoingVanilla=!isGoingVanilla!"
            echo set "isPreview=!isPreview!"
            echo set "mt_lastMCPACK=!mt_lastMCPACK!"
            echo set "mtnxt_lastResourcePackID=!mtnxt_lastResourcePackID!"
            echo set "matbak=!matbak!"
            echo set "MCLOCATION=!MCLOCATION!"
            echo set "mt_backupRestoreDate=!mt_backupRestoreDate!"
            echo set "mt_restoreList=!mt_restoreList!"
            echo set "RESTORETYPE=!RESTORETYPE!"
            echo set "uacfailed=!uacfailed!"
        )>tmp\adminVariables_restoreMaterials.bat
        if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
        powershell -NoProfile -Command Start-Process -FilePath 'modules\restoreMaterials.bat' -ArgumentList 'placebo3' -Verb runAs -Wait || (
            if not defined chcp_failed (>nul 2>&1 chcp 65001)
            echo !RED![^^!] Failed to start "Restore default materials" as admin.!RST!
            echo.
            echo !YLW![*] Disabled "Run IObit Unlocker as admin" and starting normally...!RST!
            echo.
            call "modules\settingsV3" clear mt_runIObitUnlockerAsAdmin
            timeout 3 >nul
            call "modules\restoreMaterials"
        )
        call "modules\settingsV3"
        if not defined chcp_failed (>nul 2>&1 chcp 65001)
    ) else (
        call "modules\restoreMaterials"
    )
)
goto:end

:version
if not exist "!packPath!\renderer\materials\*.material.bin" (
    if exist "!packPath!\subpacks\!subpackName!\renderer\materials\*.material.bin" (goto packfine2)
    echo !YLW![^^!] Not a shader, restoring to default...!RST!
    echo.
    goto nopacks
)
:packfine2
for /f "delims=" %%i in ('modules\jq -r ".header.name" "!packPath!\manifest.json"') do set "packName=%%i"
if /i "!hasSubpack!" equ "true" (
    set "currentPack=!packuuid!_!packVerInt!_!subpackName!"
) else (
    set "currentPack=!packuuid!_!packVerInt!"
)
set "currentPack=%currentPack: =%"

if defined mtnxt_lastResourcePackID (goto compare) else (set "lastPack=none")
if defined debugMode (
    echo !WHT!Old pack:!GRY!               !lastPack!
    echo !WHT!New pack:!RST!               !currentPack!
    echo.
)
echo !YLW![*] New shader detected.!RST!
echo.
goto newject

:compare
set "lastPack=!mtnxt_lastResourcePackID!"
echo %hideCursor%>nul
set "lastpack=!lastPack: =!"
if defined debugMode (
    echo !WHT!Old pack:!GRY!               !lastPack!
    echo !WHT!New pack:!RST!               !currentPack!
    echo.
)
if defined mtnxt_reapplyEvenIfEqu set "currentPack=!currentPack!_mtnxt_reapplyEvenIfEqu"
if /i "!currentPack!" neq "!lastPack!" (
    echo !YLW![^^!] Different shader detected.!RST!
    echo.
    echo !YLW![*] Preparing new shader for injection...!RST!
    echo.
    goto newject
) else (
    echo !GRN![*] Current pack and last pack is the same.!RST!
    timeout 2 >nul
)
goto:end

:newject
call "modules\matjectNEXT\listMaterials"
if !errorlevel! neq 0 (
    echo [1F[0J!RED![^^!] Shader is not for Windows. Skipping...!RST!
    echo.
    del /q /f ".\MATERIALS\*" >nul
    if exist tmp (rmdir /q /s ".\tmp")
    if defined mt_restoreList (
        goto restorevanilla
    )
    timeout 2 >nul
    exit /b 9
)

if defined isAdmin (
    call "modules\matjectNEXT\injectMaterials"
) else (
    if defined mt_runIObitUnlockerAsAdmin (
        echo !YLW!!BLINK![*] Starting IObit Unlocker as admin...!RST!
        echo.
        if exist "tmp\" (del /q /f ".\tmp\*" >nul) else (mkdir tmp)
        (
            echo :: This file was created to pass some of the current variables to injectMaterials.bat [%date% // %time:~0,-6%]
            echo.
            echo set "BINS=!BINS!"
            echo set "backupRunning=!backupRunning!"
            echo set "matjectSettings=!matjectSettings!"
            echo set "taskOngoing=!taskOngoing!"
            echo set "mt_currentBackupDate=!mt_currentBackupDate!"
            echo set "currentPack=!currentPack!"
            echo set "debugMode=!debugMode!"
            echo set "mt_directWriteMode=!mt_directWriteMode!"
            echo set "mt_disableConfirmation=!mt_disableConfirmation!"
            echo set "exitMsg=!exitMsg!"
            echo set "hasSubpack=!hasSubpack!"
            echo set "IObitUnlockerPath=!IObitUnlockerPath!"
            echo set "isPreview=!isPreview!"
            echo set "mt_lastMCPACK=!mt_lastMCPACK!"
            echo set "mtnxt_lastResourcePackID=!mtnxt_lastResourcePackID!"
            echo set "matbak=!matbak!"
            echo set "MCLOCATION=!MCLOCATION!"
            echo set "packName=!packName!"
            echo set "packuuid=!packuuid!"
            echo set "packVer=!packVer!"
            echo set "packVerInt=!packVerInt!"
            echo set "REPLACELIST=!REPLACELIST!"
            echo set "REPLACELISTEXPORT=!REPLACELISTEXPORT!"
            echo set "mt_backupRestoreDate=!mt_backupRestoreDate!"
            echo set "mt_restoreList=!mt_restoreList!"
            echo set "SRCCOUNT=!SRCCOUNT!"
            echo set "SRCLIST=!SRCLIST!"
            echo set "subpackName=!subpackName!"
            echo set "mt_useMaterialUpdater=!mt_useMaterialUpdater!"
            echo set "uacfailed=!uacfailed!"
        )>tmp\adminVariables_injectMaterials.bat
        if not defined chcp_failed (>nul 2>&1 chcp !chcp_default!)
        powershell -NoProfile -Command Start-Process -FilePath 'modules\matjectNEXT\injectMaterials.bat' -ArgumentList 'placebo4' -Verb runAs -Wait || (
            if not defined chcp_failed (>nul 2>&1 chcp 65001)
            echo !RED![^^!] Failed to start "Restore default materials" as admin.!RST!
            echo.
            echo !YLW![*] Disabled "Run IObit Unlocker as admin" and starting normally...!RST!
            echo.
            call "modules\settingsV3" clear mt_runIObitUnlockerAsAdmin
            timeout 3 >nul
            call "modules\matjectNEXT\injectMaterials"
        )
        call "modules\settingsV3"
        if not defined chcp_failed (>nul 2>&1 chcp 65001)
    ) else (
        call "modules\matjectNEXT\injectMaterials"
    )
)
if !errorlevel! equ 9 (
    del /q /f ".\MATERIALS\*.material.bin" >nul
    exit /b 9
)
:end
timeout 1 >nul
exit /b 0