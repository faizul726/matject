@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k

set packUuid=
set hasSubpack=
for /f "delims=" %%i in ('modules\jq -r ".[0].pack_id" "%gameData%\minecraftpe\global_resource_packs.json"') do set "packUuid=%%i"
if /i "!packUuid!" equ "null" (
    set "lastPack=!currentPack: =!"
    set "currentPack=none"
    goto:EOF
)

call "modules\matjectNEXT\parsePackVersion"

if not defined %packUuid%_%packVerInt% (
    call "modules\matjectNEXT\cachePacks" --findpack
)

set packPath=!%packUuid%_%packVerInt%!
for /f "delims=" %%i in ('modules\jq -r ".header.name" "!packPath!\manifest.json"') do set "packName=%%i"
for /f "delims=" %%j in ('modules\jq ".[0] | has(\"subpack\")" "%gameData%\minecraftpe\global_resource_packs.json"') do set "hasSubpack=%%j"

echo !WHT!^> First activated pack: !Red!!packName! !GRN!v!packVer!!RST!!RST!
echo !WHT!^> hasSubpack:!RST! !hasSubpack!
if /i "!hasSubpack!" equ "true" (
    call "modules\matjectNEXT\parseSubpack"
    set "currentPack=!packuuid!_!packVerInt!_!subpackName!" && set currentPack=!currentPack: =!
) else (
    set "subpackName="
    set "currentPack=!packuuid!_!packVerInt!" && set currentPack=!currentPack: =!
)

echo !WHT!^> Pack path: !GRY!!packPath:%gameData%=%WHT%%%GAMEDATA%%%RST%!!RST!
echo.