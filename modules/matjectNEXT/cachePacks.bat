@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k

title matjectNEXT %version%%dev%%isPreview% [caching packs]

set packName=
set counter=

if not exist "%disableManifestCheck%" (call modules\matjectNEXT\manifestChecker)

echo !YLW!!BLINK![*] Caching resource packs...!RST!
echo.
if exist "logs\cacheLog_%date%.txt" del /q /s "logs\cacheLog_%date:/=-%.txt" >nul

for /d /r "%gameData%\resource_packs" %%D in (*) do (
    if exist "%%D\manifest.json" (
        for /f "delims=" %%i in ('modules\jq -r ".header.name" "%%D\manifest.json"') do (
            for /f "delims=" %%j in ('modules\jq -r ".header.uuid" "%%D\manifest.json"') do (
                for /f "delims=" %%k in ('modules\jq -cr ".header.version | join(\"\")" "%%D\manifest.json"') do (
                    set "packName=%%i"
                    set /a counter+=1
                    set "%%j_%%k=%%D"
                    echo !counter!. !packName!
                    if defined debugMode (
                        echo !GRN!Unique ID:!RST! "%%j_%%k"
                        echo !GRY!Pack location: "!%%j_%%k:%gameData%=%WHT%%%GAMEDATA%%%GRY%!"!RST!
                        echo "!packName!" - [%%j_%%k] - "!%%j_%%k:%USERNAME%=CENSORED!" >> logs\cacheLog_%date:/=%.txt
                        echo()
                    )
                )
            )
        )
    )
)
echo.
for /d /r "%gameData%\development_resource_packs" %%D in (*) do (
    if exist "%%D\manifest.json" (
        for /f "delims=" %%i in ('modules\jq -r ".header.name" "%%D\manifest.json"') do (
            for /f "delims=" %%j in ('modules\jq -r ".header.uuid" "%%D\manifest.json"') do (
                for /f "delims=" %%k in ('modules\jq -cr ".header.version | join(\"\")" "%%D\manifest.json"') do (
                    set "packName=%%i"
                    set /a counter+=1
                    set "%%j_%%k=%%D"
                    echo !counter!. !packName! !RED![DEVELOPMENT]!RST!
                    if defined debugMode (
                        echo !GRN!Unique ID:!RST! "%%j_%%k"    
                        echo !GRY!Pack location: "!%%j_%%k:%gameData%=%WHT%%%GAMEDATA%%%GRY%!"!RST!
                        echo "!packName!" - [%%j_%%k] - "!%%j_%%k:%USERNAME%=CENSORED!" >> logs\cacheLog_%date:/=%.txt
                        echo()
                    )
                )
            )
        )
    )
)
title matjectNEXT %version%%dev%%isPreview%
echo.
echo !GRN![*] Caching OK.!RST!
set "cachedPacks=true"
echo.
echo.
if /i "[%1]" equ "[--findpack]" (
    if not defined %packUuid%_%packVerInt% (
        cls
        echo !RED![^^!] matjectNEXT couldn't find the pack that you have enabled.
        echo     It will now close to prevent any issues.
        echo     Please avoid putting marketplace packs on top.!RST!
        %exitmsg%
    )
)