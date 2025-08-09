:: main.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

cls
title matjectNEXT %version%%dev%%isPreview%

if defined debugMode if not exist ".\logs" mkdir logs

if exist "%matjectNEXTenabled%" goto lessgo

echo !RED![^^!] matjectNEXT works very differently from Matject.!RST!
echo     It directly syncs with Minecraft "Global Resource Packs" with help of jq, a 3rd party JSON processor.
echo.
echo !YLW![*] Keep in mind...!RST!
echo - In some cases, it may not work for you.
echo - Resource pack from world is not supported.
echo - Some packs might be incompatible.
echo - May not work with caps UUIDs.
echo - Manifests ^(JSONC^) with // or /**/ comments are not supported.
echo - Manifest checker will replace current clipboard entry if any error is found.
echo - Marketplace packs are NOT supported. Avoid putting them on top of the global resource pack list.
echo.
echo !YLW![*] You MUST start with original materials. 
echo     You can perform Full Restore for a fresh start, !GRY!ONLY if you haven't modified materials manually without Matject^^!!YLW!
echo.
echo [^^!] IF YOU'RE USING SOMETHING LIKE CUSTOM DATA PATH IN BEDROCK LAUNCHER,
echo     MAKE SURE TO SET CUSTOM DATA PATH FOR THAT VERSION IN MATJECT SETTINGS.
echo     !GRY!And you also have to update it when needed.!RST!
echo %showCursor%

set "mjnInput="
set /p "mjnInput=Type !RED!matjectNEXT!RST! and press [Enter] to confirm (case sensitive, leave blank to go back): !RED!"
echo %hideCursor%!RST!

if not defined mjnInput (
    echo [*] Returning to main screen...
    timeout 1 >nul
    goto :EOF
)

if "!mjnInput!" equ "matjectNEXT" (
    echo Thank you for testing matjectNEXT. [%date% // %time:~0,-6%]>"%matjectNEXTenabled%"
    set "mjnInput="
) else (
    echo !ERR![^^!] Wrong input.!RST!
    %backmsg%
)



:lessgo
cls
if not exist "%gameData%\minecraftpe\global_resource_packs.json" (
    echo !RED![^^!] Game data doesn't exist.!RST!
    echo.
    echo !YLW![*] If it does then open the game at least once and try again.!RST!
    %backmsg%
)

if not exist "modules\jq.exe" (
    call "modules\matjectNEXT\getJQ"
)

if not exist ".settings\compatibilityTestOK.txt" (
    call "modules\matjectNEXT\testCompatibility"
    echo.
    if not exist ".settings\compatibilityTestOK.txt" (echo !ERR![^^!] Compatibility test FAILED. You can't use matjectNEXT.!RST! & %backmsg%)
)


if exist "MATERIALS\*.material.bin" (
    echo !RED![^^!] MATERIALS folder is not empty.
    echo     Please remove .material.bin files from the folder to use matjectNEXT.!RST!
    %backmsg%
)

if defined mtnxt_targetPackNum (
    set /a mtnxt_targetPackNum_preview=!mtnxt_targetPackNum! + 1
) else (
    set mtnxt_targetPackNum=0
)

if not defined cachedPacks (
    call "modules\matjectNEXT\cachePacks"
)
cls
call "modules\matjectNEXT\syncMaterials"
cls
cls
if !errorlevel! equ 0 echo !GRN![*] matjectNEXT has synchronized with global resource packs. You can exit now.!RST!
rem shell:appsFolder\Microsoft.MinecraftUWP_8wekyb3d8bbwe!App
rem shell:appsFolder\Microsoft.MinecraftWindowsBeta_8wekyb3d8bbwe!App
if !errorlevel! equ 9 (
    echo !BEL!!RED![^^!] Sync cancelled. Shader is on top, but its materials are not applied. Still, you can exit now if you want.!RST!   
)
if defined mtnxt_openMinecraftAfterSync (
    start /i explorer shell:appsFolder\Microsoft.!productID!_8wekyb3d8bbwe^^!App
)
echo.
if defined mtnxt_syncAndExit (
    echo !GRN!Thanks for using Matject, have a good day^^!!RST!
    echo.
    echo Exiting in 5 seconds...
    echo !GRY!Press [S] to stay.
    rem timeout 5 >nul
    choice /c s0 /t 5 /d 0 /n >nul
    if !errorlevel! equ 1 goto :EOF
    exit 0
)
echo !BEL!!YLW![?] Or... Do you want to start monitoring for more changes?!RST!
echo.
echo !WHT![Y] Yes    [N] No, go back!RST!
echo.
choice /c yn /n >nul

if "!errorlevel!" neq "1" (goto:EOF)
cls
for /f "delims=" %%i in ('modules\jq -r ".[!mtnxt_targetPackNum!].pack_id" "%gameData%\minecraftpe\global_resource_packs.json"') do set "packUuid=%%i"
if /i "!packuuid!" equ "null" (
    set "lastPack=none"
    set "currentPack=none"
    goto monitorstart
)
for /f "delims=" %%a in ('modules\jq -cr ".[!mtnxt_targetPackNum!].version | join(\".\")" "%gameData%\minecraftpe\global_resource_packs.json"') do set packVer=%%a
for /f "delims=" %%j in ('modules\jq ".[!mtnxt_targetPackNum!] | has(\"subpack\")" "%gameData%\minecraftpe\global_resource_packs.json"') do set "hasSubpack=%%j"
if /i "!hasSubpack!" equ "true" (
    for /f "delims=" %%i in ('modules\jq -r ".[!mtnxt_targetPackNum!].subpack" "%gameData%\minecraftpe\global_resource_packs.json"') do set "subpackName=%%i"
    set "currentPack=!packuuid!_!packVerInt!_!subpackName!"
) else (
    set "subpackName="
    set "currentPack=!packuuid!_!packVerInt!"
)

set "packVerInt=!packVer:.=!"
set "packPath=!%packuuid%_%packVerInt%!"
for /f "delims=" %%i in ('modules\jq -r ".header.name" "!packPath!\manifest.json"') do set "packName=%%i"

if /i "!hasSubpack!" equ "true" (
    set "lastPack=!packuuid!_!packVerInt!_!subpackName!"
) else (
    set "lastPack=!packuuid!_!packVerInt!"
)

set "lastPack=!currentPack: =!"

:monitorstart
echo !YLW![*] Monitoring global resource packs for changes...!RST! ^(cooldown 5s^)
echo.
if /i "!packuuid!" equ "null" (
    echo !WHT!Current pack:!RST! ^(no pack applied^)
) else (
    if /i "!hasSubpack!" equ "true" (
        echo !WHT!Current pack: !RED!!packName!!RST! !GRN!v!packVer!!RST! + !BLU!!subpackName!!RST! 
    ) else (
        echo !WHT!Current pack: !RED!!packName!!RST! !GRN!v!packVer!!RST!
    )
)
echo !GRY!Press [B] to stop monitoring and go back...!RST!
echo.

:monitor
for /f %%z in ('forfiles /p "%gameData%\minecraftpe" /m global_resource_packs.json /c "cmd /c echo @fdate__@ftime"') do set "modifytime=%%z"

if defined modtime (
    if /i "!modtime!" neq "!modifytime!" (
        title matjectNEXT %version%%dev%%isPreview%
        set monitoring=
        echo.
        if defined debugMode (
            echo !YLW![*] Resource packs changed!RST!
        ) else (
            echo !YLW![*] Resource packs changed ^(!modifytime!^)!RST!
        )
        echo.
        set "modtime=!modifytime!"
        call "modules\matjectNEXT\parsePackWithCache"
        if defined debugMode (
            echo !WHT!Old:!RST! !lastPack!
            echo !WHT!New:!RST! !currentPack! 
            echo:
        )
        if defined mtnxt_reapplyEvenIfEqu set "currentPack=!currentPack!_mtnxt_reapplyEvenIfEqu"
        if /i "!currentPack!" equ "!lastPack!" (
            echo !GRN![*] Top pack unchanged.!RST!
            echo.
            echo.
            goto monitorstart
        )
        if /i "!packUuid!" equ "null" (
            echo !RED![^^!] No pack is enabled, restoring to default...!RST!
            echo.
            if defined mtnxt_lastResourcePackID (
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
                            echo set "taskOngoing=!taskOngoing!"
                            echo set "mt_currentBackupDate=!mt_currentBackupDate!"
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
                echo.
                echo.
                set "lastPack=none"
                goto monitorstart
            ) else (
                echo !GRN![*] Already using vanilla materials, no need to restore.!RST!
                echo.
                echo.
                set "lastPack=none"
                goto monitorstart
            )
        ) else (
            if not exist "!packPath!\renderer\materials\*.material.bin" (
                if exist "!packPath!\subpacks\!subpackName!\renderer\materials\*.material.bin" (goto packfine)
                echo !RED![^^!] Not a shader, restoring to default...!RST!
                echo.
                if defined mtnxt_lastResourcePackID (
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
                                echo set "taskOngoing=!taskOngoing!"
                                echo set "mt_currentBackupDate=!mt_currentBackupDate!"
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
                    echo.
                    echo.
                    if /i "!hasSubpack!" equ "true" (set "lastPack=!packuuid!_!packVerInt!_!subpackName!" && set lastPack=!lastPack: =!) else (set "lastPack=!packuuid!_!packVerInt!" && set lastPack=!lastPack: =!)
                    goto monitorstart
                ) else (
                    echo !GRN![*] Already using vanilla materials, no need to restore.!RST!
                    echo.
                    echo.
                    if /i "!hasSubpack!" equ "true" (set "lastPack=!packuuid!_!packVerInt!_!subpackName!" && set lastPack=!lastPack: =!) else (set "lastPack=!packuuid!_!packVerInt!" && set lastPack=!lastPack: =!)
                    goto monitorstart
                )
            ) else (
                :packfine
                echo.
                echo.
                call modules\matjectNEXT\listMaterials
                if !errorlevel! neq 0 (
                    echo [1F[0J!RED!!BEL![^^!] Shader is not for Windows. Skipping...!RST!
                    echo.
                    if exist "tmp" (rmdir /q /s ".\tmp")
                    del /q /f ".\MATERIALS\*" >nul
                    echo.
                    if defined mtnxt_lastResourcePackID (
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
                                    echo set "taskOngoing=!taskOngoing!"
                                    echo set "mt_currentBackupDate=!mt_currentBackupDate!"
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
                        if /i "!hasSubpack!" equ "true" (set "lastPack=!packuuid!_!packVerInt!_!subpackName!" && set lastPack=!lastPack: =!) else (set "lastPack=!packuuid!_!packVerInt!" && set lastPack=!lastPack: =!)
                    )
                    goto monitorstart
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
                    echo !RED![^^!] Injection cancelled. Shader is on top, but its materials are not applied.!RST!
                    del /q /f ".\MATERIALS\*" >nul 2>&1
                )
                if /i "!hasSubpack!" equ "true" (set "lastPack=!packuuid!_!packVerInt!_!subpackName!" && set lastPack=!lastPack: =!) else (set "lastPack=!packuuid!_!packVerInt!" && set lastPack=!lastPack: =!)
                echo.
                echo.
                goto monitorstart
            )
        )
    )
    title matjectNEXT %version%%dev%%isPreview% [monitoring]
    choice /c b0 /t 5 /d 0 /n >nul
    if !errorlevel! equ 1 goto:EOF
    goto monitor
) else (
    set "modtime=!modifytime!"
    goto monitor
)