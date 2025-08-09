:: cachePacks.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

title matjectNEXT %version%%dev%%isPreview% [caching packs]

set packName=
set counter=

if not defined mtnxt_disableManifestChecker (call "modules\matjectNEXT\manifestChecker")

if /i "[%~1]" neq "[--findpack]" (
    echo !YLW!!BLINK![*] Caching resource packs...!RST!
    echo.
)
if defined debugMode if exist "logs\cacheLog_%date%.txt" del /q /f ".\logs\cacheLog_%date:/=-%.txt" >nul

set "lss10spacer= "

if defined mtnxt_resourcePacksToScan if /i "[!mtnxt_resourcePacksToScan!]" equ "[development_resource_packs]" (goto only_development_resource_packs)

:only_resource_packs
echo !BLU![resource_packs]!RST!

for /d %%D in ("%gameData%\resource_packs\*") do (
    if exist "%%D\manifest.json" (
        call :setDetailsV2 "%%~D"
    ) else (
        for /d %%F in ("%%~D\*") do (
            if exist "%%F\manifest.json" (
                call :setDetailsV2 "%%~F"
            )
        )
    )
)

if defined mtnxt_resourcePacksToScan if /i "[!mtnxt_resourcePacksToScan!]" equ "[resource_packs]" (goto scanningComplete)

echo.

:only_development_resource_packs
echo !RED![development_resource_packs]!RST!

for /d %%D in ("%gameData%\development_resource_packs\*") do (
    if exist "%%D\manifest.json" (
        call :setDetailsV2 "%%~D"
    ) else (
        for %%F in ("%%~D\*") do (
            if exist "%%D\manifest.json" (
                call :setDetailsV2 "%%~D"
            )
        )
    )
)
:scanningComplete

rem for /d /r "%gameData%\resource_packs" %%D in (*) do (
rem     if exist "%%D\manifest.json" (
rem         for /f "delims=" %%i in ('modules\jq -r ".header.name" "%%D\manifest.json"') do (
rem             for /f "delims=" %%j in ('modules\jq -r ".header.uuid" "%%D\manifest.json"') do (
rem                 for /f "delims=" %%k in ('modules\jq -cr ".header.version | join(\"\")" "%%D\manifest.json"') do (
rem                     set "packName=%%i"
rem                     set /a counter+=1
rem                     set "%%j_%%k=%%D"
rem                     echo !WHT!!counter!. !packName!!RST!
rem                     if defined debugMode (
rem                         echo Pack UUID:     !GRY!"%%j_%%k"!RST!
rem                         echo Pack location: !GRY!"!%%j_%%k:%gameData%\=!"!RST!
rem                         echo "!packName!" - [%%j_%%k] - "!%%j_%%k:%USERNAME%=[REDACTED]!" >> logs\cacheLog_%date:/=%.txt
rem                         echo()
rem                     )
rem                 )
rem             )
rem         )
rem     )
rem )
rem echo.
rem for /d /r "%gameData%\development_resource_packs" %%D in (*) do (
rem     if exist "%%D\manifest.json" (
rem         for /f "delims=" %%i in ('modules\jq -r ".header.name" "%%D\manifest.json"') do (
rem             for /f "delims=" %%j in ('modules\jq -r ".header.uuid" "%%D\manifest.json"') do (
rem                 for /f "delims=" %%k in ('modules\jq -cr ".header.version | join(\"\")" "%%D\manifest.json"') do (
rem                     set "packName=%%i"
rem                     set /a counter+=1
rem                     set "%%j_%%k=%%D"
rem                     echo !WHT!!counter!. !packName! !RED![DEVELOPMENT]!RST!
rem                     if defined debugMode (
rem                         echo Pack UUID:     !GRY!"%%j_%%k"!RST!
rem                         echo Pack location: !GRY!"!%%j_%%k:%gameData%\=!"!RST!
rem                         echo "!packName!" - [%%j_%%k] - "!%%j_%%k:%USERNAME%=[REDACTED]!" >> logs\cacheLog_%date:/=%.txt
rem                         echo()
rem                     )
rem                 )
rem             )
rem         )
rem     )
rem )
title matjectNEXT %version%%dev%%isPreview%
echo.
if not defined counter (
    echo !RED![^^!] No resource pack found.!RST!
    %exitMsg%
)
echo !GRN![*] Cached !counter! resource packs.!RST!
set "counter="
set "cachedPacks=true"
echo.
echo.
if /i "[%~1]" equ "[--findpack]" (
    if not defined %packUuid%_%packVerInt% (
        timeout 2 >nul
        cls
        echo !RED![^^!] matjectNEXT couldn't find the pack that you have enabled.
        echo     Matject will now close to prevent any further issues.
        echo     Please avoid putting marketplace packs on top.!RST!
        %exitmsg%
    )
    call "modules\settingsV3"
)
timeout 2 >nul
goto :EOF

:setDetailsV2
for /f "delims=" %%i in ('modules\jq -r ".header.name" "%~1\manifest.json"') do (set packName_holder=%%i)
for /f "delims=" %%j in ('modules\jq -r ".header.uuid" "%~1\manifest.json"') do (set packUUID_holder=%%j)
for /f "delims=" %%k in ('modules\jq -cr ".header.version | join(\".\")" "%~1\manifest.json"') do (set packVersion_holder=%%k)
set /a counter+=1
set "%packUUID_holder%_%packVersion_holder:.=%=%~1"

if !counter! geq 10 (
    set "lss10spacer="
)
echo !lss10spacer!!WHT!!counter!. !packName_holder! !GRY!v%packVersion_holder%!RST!

if defined debugMode (
    echo Pack Unique ID: !GRY!"%packUUID_holder%_%packVersion_holder:.=%"!RST!
    echo Pack location:  !GRY!"!%packUUID_holder%_%packVersion_holder:.=%:%gameData%\=!"!RST!
    echo "!packName!" - [%%j_%%k] - "!%%j_%packVersion_holder%:%USERNAME%=[REDACTED]!" >> logs\cacheLog_%date:/=%.txt
    echo()
)
goto :EOF

:setDetailsV1
rem TODO add version in GRY next to packName
rem for /f "delims=" %%i in ('modules\jq -r ".header.name" "%~1\manifest.json"') do (
rem     for /f "delims=" %%j in ('modules\jq -r ".header.uuid" "%~1\manifest.json"') do (
rem         for /f "delims=" %%k in ('modules\jq -cr ".header.version | join(\"\")" "%~1\manifest.json"') do (
rem             set "packName=%%i"
rem             set /a counter+=1
rem             set "%%j_%%k=%1"
rem             if /i "[%~2]" neq "[dev]" (
rem                 echo !WHT!!counter!. !packName!!RST!
rem             ) else (
rem                 echo !WHT!!counter!. !packName! !RED![DEVELOPMENT]!RST!
rem             )
rem             if defined debugMode (
rem                 echo Pack UUID:     !GRY!"%%j_%%k"!RST!
rem                 echo Pack location: !GRY!"!%%j_%%k:%gameData%\=!"!RST!
rem                 echo "!packName!" - [%%j_%%k] - "!%%j_%%k:%USERNAME%=[REDACTED]!" >> logs\cacheLog_%date:/=%.txt
rem                 echo()
rem             )
rem         )
rem     )
rem )
rem goto :EOF