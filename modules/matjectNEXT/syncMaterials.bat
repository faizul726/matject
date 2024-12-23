if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

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

for /f "delims=" %%i in ('modules\jq -r ".[0].pack_id" "%gameData%\minecraftpe\global_resource_packs.json"') do set "packuuid=%%i"

echo !WHT!Top pack UUID:!RST!        !packuuid!
echo.

if "!packuuid!" equ "null" (
    echo !YLW![*] No packs enabled.!RST!
    timeout 1 >nul
    echo.
    goto nopacks
)
goto version

:nopacks
if exist "%rstrList%" (
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
set "RESTORETYPE=partial"
set "isGoingVanilla=true"
call "modules\restoreMaterials"
goto:end

:version
for /f "delims=" %%a in ('modules\jq -cr ".[0].version | join(\".\")" "%gameData%\minecraftpe\global_resource_packs.json"') do set packVer=%%a
set packVerInt=!packVer:.=!
for /f "delims=" %%j in ('modules\jq ".[0] | has(\"subpack\")" "%gameData%\minecraftpe\global_resource_packs.json"') do set "hasSubpack=%%j"
if "!hasSubpack!" equ "true" (for /f "delims=" %%i in ('modules\jq -r ".[0].subpack" "%gameData%\minecraftpe\global_resource_packs.json"') do set "subpackName=%%i") else (set "subpackName=")
if not defined %packUuid%_%packVerInt% (
    call "modules\matjectNEXT\cachePacks"
)
set "packPath=!%packuuid%_%packVerInt%!"
echo !WHT!* Pack Version:!RST!       !GRN!v!packVer!!RST!
echo !WHT!* hasSubpack:!RST!         !hasSubpack!
if "!hasSubpack!" equ "true" echo !WHT!* Subpack name:!RST!       !BLU!!subpackName!!RST!
echo !WHT!* Assigned unique ID:!RST! %packuuid%_%packVerInt%
echo !WHT!* Pack path:!GRY!          "!packPath:%LOCALAPPDATA%=%WHT%%%LOCALAPPDATA%%%RST%!!RST!"
echo.
if not exist "!packPath!\renderer\materials\*.material.bin" (
    echo !YLW![^^!] Not a shader, restoring to default...!RST!
    echo.
    goto nopacks
)
for /f "delims=" %%i in ('modules\jq -r ".header.name" "!packPath!\manifest.json"') do set "packName=%%i"
if "!hasSubpack!" equ "true" (
    echo !WHT!Pack details:         !RED!!packName!!RST! !GRN!v!packVer!!RST! + !BLU!!subpackName!!RST!
    set "currentPack=!packuuid!_!packVerInt!_!subpackName!"
) else (
    echo !WHT!Pack details:         !RED!!packName!!RST! !GRN!v!packVer!!RST!
    set "currentPack=!packuuid!_!packVerInt!"
)
set "currentPack=%currentPack: =%"
echo.

if exist "%lastRP%" (goto compare) else (set "lastPack=none")
echo !WHT!Old pack:!RST!             !lastPack!
echo !WHT!New pack:!RST!             !currentPack! 
echo.
echo !YLW![*] New shader detected.!RST!
echo.
goto newject

:compare
set /p lastPack=<"%lastRP%"
set "lastpack=!lastPack: =!"
echo !WHT!Old pack:!RST!             !lastPack!
echo !WHT!New pack:!RST!             !currentPack!
echo.
if /i "!currentPack!" neq "!lastPack!" (
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
if !errorlevel! neq 0 (
    echo !RED![^^!] Shader is not for Windows. Skipping...!RST!
    echo.
    del /q /s "MATERIALS\*" >nul
    if exist tmp (rmdir /q /s tmp)
    if exist "%rstrList%" (
        goto restorevanilla
    )
    goto newject_failed
)
call "modules\matjectNEXT\injectMaterials"
:newject_failed
timeout 2 >nul

:end
exit /b 0