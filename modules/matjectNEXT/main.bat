@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

cls
title matjectNEXT %version%%dev%

if exist %matjectNEXTenabled% goto lessgo

echo !RED![^^!] matjectNEXT works very differently from Matject.!RST!
echo It directly syncs with Minecraft "Global Resource Packs" with help of a 3rd party JSON processor ^(jq^).
echo.
echo !YLW!Keep in mind,!RST!
echo - matjectNEXT is not extensively tested. It may or may not work for you.
echo - It only works if Minecraft is installed from Microsoft Store.
echo - It only works if Minecraft is not moved from C: Drive to somewhere else.
echo - Resource pack from world is not supported.
echo - development_resource_packs are not supported.
echo - Still missing some not required but important features.
echo - Some packs might be incompatible.
echo - May not work with caps UUIDs.
echo.
echo !YLW!- DO NOT mix Matject and matjectNEXT. Use only one as preferred option.
echo - You MUST start with original materials. For a fresh start, you can perform Others -^> Full restore.!RST!
echo.

set "mjnInput="
set /p "mjnInput=Enter "matjectNEXT" to continue (case sensitive): !RED!"
echo !RST!

if "!mjnInput!" equ "matjectNEXT" (
    echo Thank you for testing matjectNEXT. [%date%] [%time%]>"%matjectNEXTenabled%"
) else (
    echo !ERR![^^!] Wrong input.!RST!
    %backmsg%
)



:lessgo
if not exist ".settings\envOK.txt" (
    call "modules\matjectNEXT\testEnv"
    if not exist ".settings\envOK.txt" (echo !ERR![^^!] jq test FAILED. You can't use matjectNEXT on this PC.!RST! & %backmsg%)
)

if exist ".settings\.restoreList.txt" (
    echo !YLW![^^!] You already have modified materials.
    echo     Please perform a full restore before you can use matjectNEXT.!RST!
    %backmsg%
)

if not exist "modules\jq.exe" (
    cls
    call "modules\matjectNEXT\getJQ"
)

if not defined cachedPacks (
    call modules\matjectNEXT\cachePacks
)
call modules\matjectNEXT\syncMaterials
cls
if "!errorlevel!" equ "0" echo !GRN![*] Sync OK.!RST!
echo.
echo !YLW![?] Do you want to start monitoring for changes?!RST! [Y/N]
echo.
choice /c yn /n

if "!errorlevel!" neq "1" (goto:EOF)
cls
for /f "delims=" %%i in ('modules\jq -r ".[0].pack_id" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "packUuid=%%i"
if "!packuuid!" equ "null" (
    set "lastPack=rwxrwr-r"
    goto monitorstart
)
for /f "delims=" %%a in ('modules\jq -cr ".[0].version | join(\".\")" "%gamedata%\minecraftpe\global_resource_packs.json"') do set packVer=%%a
for /f "delims=" %%j in ('modules\jq ".[0] | has(\"subpack\")" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "hasSubpack=%%j"
if "!hasSubpack!" equ "true" (
    for /f "delims=" %%i in ('modules\jq -r ".[0].subpack" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "subpackName=%%i"
    set "currentPack2=!packuuid!_!packVer2!_!subpackName!"
) else (
    set "subpackName="
    set "currentPack2=!packuuid!_!packVer2!"
)

set "packVer2=!packVer:.=!"
set "packPath=!%packuuid%_%packVer2%!"
for /f "delims=" %%i in ('modules\jq -r ".header.name" "!packPath!\manifest.json"') do set "packName=%%i"

if "!hasSubpack!" equ "true" (
    set "lastPack=!packuuid!_!packVer2!_!subpackName!"
) else (
    set "lastPack=!packuuid!_!packVer2!"
)

set "lastPack=!currentPack2: =!"

:monitorstart
echo !YLW![*] Monitoring resource packs...!RST! ^(cooldown 5s^)
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
        echo !WHT!New:!RST! !currentPack2! 
        echo.
        if "!currentPack2!" equ "!lastPack!" (
            echo !GRN![*] Top pack unchanged.!RST!
            echo.
            echo.
            goto monitorstart
        )
        if !packUuid! equ null (
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
                set "lastPack=rwxrwr-r"
                goto monitorstart
            ) else (
                echo !GRN![*] Already using vanilla materials, no need to restore.!RST!
                echo.
                echo.
                set "lastPack=rwxrwr-r"
                goto monitorstart
            )
        ) else (
            if not exist "!packPath!\renderer\" (
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
                    if "!hasSubpack!" equ "true" (set "lastPack=!packuuid!_!packVer2!_!subpackName!" && set lastPack=!lastPack: =!) else (set "lastPack=!packuuid!_!packVer2!" && set lastPack=!lastPack: =!)
                    goto monitorstart
                ) else (
                    echo !GRN![*] Already using vanilla materials, no need to restore.!RST!
                    echo.
                    echo.
                    if "!hasSubpack!" equ "true" (set "lastPack=!packuuid!_!packVer2!_!subpackName!" && set lastPack=!lastPack: =!) else (set "lastPack=!packuuid!_!packVer2!" && set lastPack=!lastPack: =!)
                    goto monitorstart
                )
            ) else (
                call modules\matjectNEXT\listMaterials
                call modules\matjectNEXT\injectMaterials
                if "!hasSubpack!" equ "true" (set "lastPack=!packuuid!_!packVer2!_!subpackName!" && set lastPack=!lastPack: =!) else (set "lastPack=!packuuid!_!packVer2!" && set lastPack=!lastPack: =!)
                echo.
                echo.
                goto monitorstart
            )
        )
    )
    title matjectNEXT %version%%dev% [monitoring]
    choice /c b0 /t 5 /d 0 /n > NUL
    if !errorlevel! equ 1 goto:EOF
    goto monitor
) else (
    set "modtime=!modifytime!"
    goto monitor
)