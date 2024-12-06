@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

cls
title matjectNEXT %version%%dev%

if not exist "logs\" mkdir logs

if exist %matjectNEXTenabled% goto lessgo

echo !RED![^^!] matjectNEXT works very differently from Matject.!RST!
echo     It directly syncs with Minecraft "Global Resource Packs" with help of a 3rd party JSON processor ^(jq^).
echo.
echo !YLW![*] Keep in mind...!RST!
echo - In rare cases, it may not work for you.
echo - Resource pack from world is not supported.
echo - Some packs might be incompatible.
echo - May not work with caps UUIDs.
echo - Manifests with // or /**/ comments are not supported.
echo.
echo !YLW![*] You MUST start with original materials. 
echo     You can perform Full Restore for a fresh start, !GRY!if you haven't modified materials manually without Matject^^!!YLW!
echo.
echo [^^!] IF YOU'RE USING SOMETHING LIKE CUSTOM DATA PATH IN BEDROCK LAUNCHER,
echo     MAKE SURE TO SET CUSTOM DATA PATH FOR THAT VERSION IN MATJECT SETTINGS.
echo     !GRY!And you also have to update it when needed.!RST!
echo.

set "mjnInput="
set /p "mjnInput=Enter !RED!matjectNEXT!RST! to continue (case sensitive): !RED!"
echo !RST!

if "!mjnInput!" equ "matjectNEXT" (
    echo Thank you for testing matjectNEXT. [%date% // %time%]>"%matjectNEXTenabled%"
) else (
    echo !ERR![^^!] Wrong input.!RST!
    %backmsg%
)



:lessgo
if not exist "%gamedata%\minecraftpe\global_resource_packs.json" (echo []>"%gamedata%\minecraftpe\global_resource_packs.json")

if not exist "modules\jq.exe" (
    cls
    call "modules\matjectNEXT\getJQ"
)

if not exist ".settings\compatibilityTestOK.txt" (
    call "modules\matjectNEXT\testCompatibility"
    echo.
    if not exist ".settings\compatibilityTestOK.txt" (echo !ERR![^^!] Compatibility test FAILED. You can't use matjectNEXT.!RST! & %backmsg%)
)

if exist ".settings\.restoreList.txt" (
    echo !YLW![^^!] You already have modified materials.
    echo     Please perform a full restore before you can use matjectNEXT.!RST!
    %backmsg%
)

if not defined cachedPacks (
    call modules\matjectNEXT\cachePacks
)
call modules\matjectNEXT\syncMaterials
cls
if "!errorlevel!" equ "0" echo !GRN![*] Sync OK. Materials from top pack are applied. You can exit now.!RST!
echo.
if exist "%syncThenExit%" (
    echo !GRN!Thanks for using Matject, have a good day.!RST!
    echo.
    echo Exiting in 5 seconds...
    timeout 5 >nul
    exit 0
)
echo !YLW![?] Or... Do you want to start monitoring for further changes?!RST! [Y/N]
echo.
choice /c yn /n >nul

if "!errorlevel!" neq "1" (goto:EOF)
cls
for /f "delims=" %%i in ('modules\jq -r ".[0].pack_id" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "packUuid=%%i"
if "!packuuid!" equ "null" (
    set "lastPack=none"
    set "currentPack=none"
    goto monitorstart
)
for /f "delims=" %%a in ('modules\jq -cr ".[0].version | join(\".\")" "%gamedata%\minecraftpe\global_resource_packs.json"') do set packVer=%%a
for /f "delims=" %%j in ('modules\jq ".[0] | has(\"subpack\")" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "hasSubpack=%%j"
if "!hasSubpack!" equ "true" (
    for /f "delims=" %%i in ('modules\jq -r ".[0].subpack" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "subpackName=%%i"
    set "currentPack=!packuuid!_!packVerInt!_!subpackName!"
) else (
    set "subpackName="
    set "currentPack=!packuuid!_!packVerInt!"
)

set "packVerInt=!packVer:.=!"
set "packPath=!%packuuid%_%packVerInt%!"
for /f "delims=" %%i in ('modules\jq -r ".header.name" "!packPath!\manifest.json"') do set "packName=%%i"

if "!hasSubpack!" equ "true" (
    set "lastPack=!packuuid!_!packVerInt!_!subpackName!"
) else (
    set "lastPack=!packuuid!_!packVerInt!"
)

set "lastPack=!currentPack: =!"

:monitorstart
echo !YLW![*] Monitoring global resource packs for changes...!RST! ^(cooldown 5s^)
echo.
if "!packuuid!" equ "null" (
    echo !WHT!Current pack:!RST! ^(no pack applied^)
) else (
    if "!hasSubpack!" equ "true" (
        echo !WHT!Current pack: !RED!!packName!!RST! !GRN!v!packVer!!RST! + !BLU!!subpackName!!RST! 
    ) else (
        echo !WHT!Current pack: !RED!!packName!!RST! !GRN!v!packVer!!RST!
    )
)
echo !GRY!Press [B] to stop monitoring...!RST!
echo.

:monitor
for /f %%z in ('forfiles /p "%gamedata%\minecraftpe" /m global_resource_packs.json /c "cmd /c echo @fdate__@ftime"') do set "modifytime=%%z"

if defined modtime (
    if "!modtime!" neq "!modifytime!" (
        title matjectNEXT %version%%dev%
        set monitoring=
        echo.
        echo !YLW![*] Resource packs changed ^(!modifytime!^)!RST!
        echo.
        set "modtime=!modifytime!"
        call "modules\matjectNEXT\parsePackWithCache"
        echo !WHT!Old:!RST! !lastPack!
        echo !WHT!New:!RST! !currentPack! 
        echo.
        if "!currentPack!" equ "!lastPack!" (
            echo !GRN![*] Top pack unchanged.!RST!
            echo.
            echo.
            goto monitorstart
        )
        if "!packUuid!" equ "null" (
            echo !RED![^^!] No pack is enabled, restoring to default...!RST!
            echo.
            if exist ".settings\lastPack.txt" (
                set "RESTORETYPE=partial"
                set "isGoingVanilla=true"
                call "modules\restoreMaterials"
                set "isGoingVanilla="
                del /q /s ".settings\lastPack.txt" > NUL
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
                echo !RED![^^!] Not a shader, restoring to default...!RST!
                echo.
                if exist ".settings\lastPack.txt" (
                    set "RESTORETYPE=partial"
                    set "isGoingVanilla=true"
                    call "modules\restoreMaterials"
                    set "isGoingVanilla="
                    del /q /s ".settings\lastPack.txt" > NUL
                    echo.
                    echo.
                    if "!hasSubpack!" equ "true" (set "lastPack=!packuuid!_!packVerInt!_!subpackName!" && set lastPack=!lastPack: =!) else (set "lastPack=!packuuid!_!packVerInt!" && set lastPack=!lastPack: =!)
                    goto monitorstart
                ) else (
                    echo !GRN![*] Already using vanilla materials, no need to restore.!RST!
                    echo.
                    echo.
                    if "!hasSubpack!" equ "true" (set "lastPack=!packuuid!_!packVerInt!_!subpackName!" && set lastPack=!lastPack: =!) else (set "lastPack=!packuuid!_!packVerInt!" && set lastPack=!lastPack: =!)
                    goto monitorstart
                )
            ) else (
                call modules\matjectNEXT\listMaterials
                if !errorlevel! neq 0 (
                    echo !RED![^^!] Shader is not for Windows. Skipping...!RST!
                    echo.
                    if exist "tmp" (rmdir /q /s "tmp")
                    del /q /s MATERIALS\* >nul
                    echo.
                    if exist ".settings\lastPack.txt" (
                        set "RESTORETYPE=partial"
                        set "isGoingVanilla=true"
                        call "modules\restoreMaterials"
                        set "isGoingVanilla="
                        del /q /s ".settings\lastPack.txt" > NUL
                        if "!hasSubpack!" equ "true" (set "lastPack=!packuuid!_!packVerInt!_!subpackName!" && set lastPack=!lastPack: =!) else (set "lastPack=!packuuid!_!packVerInt!" && set lastPack=!lastPack: =!)
                    )
                    goto monitorstart
                )
                call modules\matjectNEXT\injectMaterials
                if "!hasSubpack!" equ "true" (set "lastPack=!packuuid!_!packVerInt!_!subpackName!" && set lastPack=!lastPack: =!) else (set "lastPack=!packuuid!_!packVerInt!" && set lastPack=!lastPack: =!)
                echo.
                echo.
                goto monitorstart
            )
        )
    )
    title matjectNEXT %version%%dev% [monitoring]
    choice /c b0 /t 5 /d 0 /n >nul
    if !errorlevel! equ 1 goto:EOF
    goto monitor
) else (
    set "modtime=!modifytime!"
    goto monitor
)