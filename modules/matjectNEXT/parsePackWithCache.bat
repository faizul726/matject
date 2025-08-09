:: parsePackWithCache.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

if defined mtnxt_targetPackNum (
    set /a mtnxt_targetPackNum_preview=!mtnxt_targetPackNum! + 1
) else (
    set mtnxt_targetPackNum=0
)

set packUuid=
set hasSubpack=
for /f "delims=" %%i in ('modules\jq -r ".[!mtnxt_targetPackNum!].pack_id" "%gameData%\minecraftpe\global_resource_packs.json"') do set "packUuid=%%i"
if /i "!packUuid!" equ "null" (
    set "lastPack=!currentPack: =!"
    set "currentPack=none"
    goto:EOF
)

call "modules\matjectNEXT\parsePackVersion"

if not defined %packUuid%_%packVerInt% (
    echo !RED!!BLINK![^^!] Pack not found. Caching resource packs again...!RST!
    echo.
    set "mtnxt_resourcePacksToScan="
    call "modules\matjectNEXT\cachePacks" --findpack
)

set packPath=!%packUuid%_%packVerInt%!
for /f "delims=" %%i in ('modules\jq -r ".header.name" "!packPath!\manifest.json"') do set "packName=%%i"
for /f "delims=" %%j in ('modules\jq ".[!mtnxt_targetPackNum!] | has(\"subpack\")" "%gameData%\minecraftpe\global_resource_packs.json"') do set "hasSubpack=%%j"

if /i "!hasSubpack!" equ "true" (
    call "modules\matjectNEXT\parseSubpack"
    set "currentPack=!packuuid!_!packVerInt!_!subpackName!" & set currentPack=!currentPack: =!
    echo !WHT!* Number !mtnxt_targetPackNum_preview! activated pack: !RED!!packName! !GRN!v!packVer!!RST! 
    echo !WHT!* Selected subpack:        !BLU!!subpackName!!RST!
) else (
    set "subpackName="
    set "currentPack=!packuuid!_!packVerInt!" & set currentPack=!currentPack: =!
    echo !WHT!* Number !mtnxt_targetPackNum_preview! activated pack: !RED!!packName! !GRN!v!packVer!!RST!
)
echo !WHT!* Pack path:               !GRY!!packPath:%gameData%\=!!RST!
echo.