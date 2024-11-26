@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

title matjectNEXT %version%%dev% [caching packs]

set packName=
set counter=

echo !YLW![*] Caching resource packs...!RST!
echo.
for /d %%D in ("%gamedata%\resource_packs\*") do (
    if exist "%%D\manifest.json" (
        for /f "delims=" %%i in ('modules\jq -r ".header.name" "%%D\manifest.json"') do (
            for /f "delims=" %%j in ('modules\jq -r ".header.uuid" "%%D\manifest.json"') do (
                for /f "delims=" %%k in ('modules\jq -cr ".header.version | join(\"\")" "%%D\manifest.json"') do (
                    set "packName=%%i"
                    set /a counter+=1
                    set "%%j_%%k=%%D"
                    echo !counter!. !packName!
                    echo !GRN!Unique ID:!RST! "%%j_%%k"
                    echo !GRY!Pack location: "!%%j_%%k!"!RST!
                    echo.
                )
            )
        )
    )
)
title %title%
echo.
echo !GRN![*] Caching OK!RST!
set "cachedPacks=true"
echo.
echo.

title matjectNEXT %version%%dev%