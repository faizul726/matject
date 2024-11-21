if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

set packuuid=
set packver=
set packVer2=
set hasSubpack=
set subpackName=
set packPath=
set currentPack=
set currentPack2=
set lastPack=

echo !YLW![*] Syncing with current global resource packs...!RST!
echo.

for /f "delims=" %%i in ('modules\jq -r ".[0].pack_id" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "packuuid=%%i"

echo Top pack UUID: "!packuuid!"
echo.

if "!packuuid!" equ "null" (
    echo !YLW![*] No packs enabled.!RST!
    timeout 2 >nul
    echo.
    goto nopacks
)
goto version

:nopacks
if exist ".settings\.restoreList.log" (goto restorevanilla) else (
    echo !YLW![*] Already using vanilla materials, no need to restore.!RST!
    timeout 2 >nul
    goto:end
)
goto:end

:restorevanilla
set "RESTORETYPE=partial"
set "isGoingVanilla=true"
call "modules\restoreMaterials"
if exist ".settings\lastPack.txt" (del /q /s ".settings\lastPack.txt" > NUL)
goto:end

:version
for /f "delims=" %%a in ('modules\jq -cr ".[0].version | join(\".\")" "%gamedata%\minecraftpe\global_resource_packs.json"') do set packVer=%%a
set packVer2=!packVer:.=!
for /f "delims=" %%j in ('modules\jq ".[0] | has(\"subpack\")" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "hasSubpack=%%j"
if "!hasSubpack!" equ "true" (for /f "delims=" %%i in ('modules\jq -r ".[0].subpack" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "subpackName=%%i") else (set "subpackName=")
set "packPath=!%packuuid%_%packVer2%!"
echo Pack Version: "!packVer!"
echo Pack Version ^(trimmed^): "!packVer2!"
echo hasSubpack: "!hasSubpack!"
echo Subpack name: "!subpackName!"
echo Unique ID: %packuuid%_%packVer2%
echo !GRY!Pack path: "!packPath!"!RST!
if not exist "!packPath!\renderer\" (
    echo !YLW![^^!] Not a shader, skipping...!RST!
    if exist ".settings\lastPack.txt" del /q /s ".settings\lastPack.txt" >nul
    pause
    goto nopacks
)
for /f "delims=" %%i in ('modules\jq -r ".header.name" "!%packPath%!\manifest.json"') do set "packName=%%i"
echo Current pack ID:           "!RED!!packName!!RST!_!GRN!!packVer2!!RST!_!BLU!!subpackName!!RST!"
if "!hasSubpack!" equ "true" (
    set "currentPack=!packName!_!packVer2!_!subpackName!"
) else (
    set "currentPack=!packName!_!packVer2!"
)
set "currentPack2=%currentPack: =%"
echo Current pack ID ^(trimmed^): "!currentPack2!"
echo.
pause
if exist ".settings\lastPack.txt" goto compare
goto newject

:compare
set /p lastPack=<".settings\lastPack.txt"
set "lastpack=!lastPack: =!"
echo Last pack: "!lastPack!"
echo.
if "!currentPack2!" neq "!lastPack!" (
    echo "!currentPack2!"
    echo "!lastPack: =!"
    echo !YLW![^^!] Different shader detected.!RST!
    echo.
    echo !YLW![*] Preparing new shader for injection...!RST!
    echo.
    goto newject
) else (
    echo !GRN![*] Current pack and last pack is same.!RST!
    timeout 2 >nul
)
goto:end

:newject
call "modules\matjectNEXT\listMaterials"
call "modules\matjectNEXT\injectMaterials"

:end
exit /b 0