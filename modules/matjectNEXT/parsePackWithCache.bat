@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

set packUuid=
set hasSubpack=
for /f "delims=" %%i in ('modules\jq -r ".[0].pack_id" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "packUuid=%%i"
if "!packUuid!" equ "null" (
    set "lastPack=!currentPack2!"
    set "currentPack2=rwxrwr-r"
    goto:EOF
)

call "modules\matjectNEXT\parsePackVersion"

if not defined %packUuid%_%packVer2% (
    call "modules\matjectNEXT\cachePacks"
)

set packPath=!%packUuid%_%packVer2%!
for /f "delims=" %%i in ('modules\jq -r ".header.name" "!packPath!\manifest.json"') do set "packName=%%i"
for /f "delims=" %%j in ('modules\jq ".[0] | has(\"subpack\")" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "hasSubpack=%%j"

echo !WHT!^> First activated pack: !Red!!packName! !GRN!v!packVer!!RST!!RST!
echo !WHT!^> hasSubpack:!RST! !hasSubpack!
if "!hasSubpack!" equ "true" (
    call "modules\matjectNEXT\parseSubpack"
    set "currentPack2=!packName!_!packVer2!_!subpackName!" && set currentPack2=!currentPack2: =!
) else (
    set "subpackName="
    set "currentPack2=!packName!_!packVer2!" && set currentPack2=!currentPack2: =!
)

echo !WHT!^> Pack path: !GRY!!packPath!!RST!