:: cachePacks.bat // Made by github.com/faizul726
@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k

title matjectNEXT %version%%dev%%isPreview% [caching packs]

set packName=
set counter=

if not exist "%disableManifestCheck%" (call modules\matjectNEXT\manifestChecker)

if /i "[%~1]" neq "[--findpack]" (
    echo !YLW!!BLINK![*] Caching resource packs...!RST!
) else (
    echo !YLW!!BLINK![*] Pack not found. Caching resource packs again...!RST!
)
echo.
if exist "logs\cacheLog_%date%.txt" del /q ".\logs\cacheLog_%date:/=-%.txt" >nul

for /d /r "%gameData%\resource_packs" %%D in (*) do (
    if exist "%%D\manifest.json" (
        for /f "delims=" %%i in ('modules\jq -r ".header.name" "%%D\manifest.json"') do (
            for /f "delims=" %%j in ('modules\jq -r ".header.uuid" "%%D\manifest.json"') do (
                for /f "delims=" %%k in ('modules\jq -cr ".header.version | join(\"\")" "%%D\manifest.json"') do (
                    set "packName=%%i"
                    set /a counter+=1
                    set "%%j_%%k=%%D"
                    echo !WHT!!counter!. !packName!!RST!
                    if defined debugMode (
                        echo Pack UUID:     !GRY!"%%j_%%k"!RST!
                        echo Pack location: !GRY!"!%%j_%%k:%gameData%\=!"!RST!
                        echo "!packName!" - [%%j_%%k] - "!%%j_%%k:%USERNAME%=[REDACTED]!" >> logs\cacheLog_%date:/=%.txt
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
                    echo !WHT!!counter!. !packName! !RED![DEVELOPMENT]!RST!
                    if defined debugMode (
                        echo Pack UUID:     !GRY!"%%j_%%k"!RST!
                        echo Pack location: !GRY!"!%%j_%%k:%gameData%\=!"!RST!
                        echo "!packName!" - [%%j_%%k] - "!%%j_%%k:%USERNAME%=[REDACTED]!" >> logs\cacheLog_%date:/=%.txt
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
if /i "[%~1]" equ "[--findpack]" (
    if not defined %packUuid%_%packVerInt% (
        cls
        echo !RED![^^!] matjectNEXT couldn't find the pack that you have enabled.
        echo     It will now close to prevent any issues.
        echo     Please avoid putting marketplace packs on top.!RST!
        %exitmsg%
    )
)