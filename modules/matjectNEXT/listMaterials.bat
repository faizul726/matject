:: listMaterials.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

:list
set SRCLIST=
set SRCCOUNT=
set REPLACELIST=
set REPLACELISTEXPORT=
set MTBIN=
set BINS=

if not exist "MATERIALS" mkdir MATERIALS

copy /d /b "!packPath!\renderer\materials\*" "%cd%\MATERIALS" >nul 2>&1
if defined debugMode echo !YLW![*] Copied !RED!!packName!!YLW! materials.!RST!
if /i "!hasSubpack!" equ "true" (copy /d /b "!packPath!\subpacks\!subpackName!\renderer\materials\*" "%cd%\MATERIALS" >nul 2>&1)
if defined debugMode (
    echo !YLW![*] Copied !BLU!!subpackName!!YLW! ^(subpack^) materials.!RST!
    echo.
)

if not defined mt_disableMatCompatCheck (
    call "modules\checkMaterialCompatibility"
    if !errorlevel! neq 0 (
        set "lastPack=!currentPack!"
        exit /b 1
    )
)

for %%M in ("MATERIALS\*") do (
    set "MTBIN=%%~nM"
    set SRCLIST=!SRCLIST!,"%cd%\%%M"
    rem set SRCLIST_preview=!SRCLIST_preview!,"%%~nxM"
    set "BINS=!BINS! "/!MTBIN:~0,-9!\""
    set "REPLACELIST=!REPLACELIST!,"/!MTBIN:~0,-9!\""
    set /a SRCCOUNT+=1
)

set "BINS=!BINS:~1!"
set "SRCLIST=%SRCLIST:~1%"
set "REPLACELIST=%REPLACELIST:~1%"
set "REPLACELISTEXPORT=%REPLACELIST%"

if not defined debugMode goto :skip_listMaterialsPreview
echo !WHT!Materials count: !GRY!!SRCCOUNT!!RST!
echo !WHT!Source list:     !GRY!!SRCLIST:%cd%\MATERIALS\=!!RST!
echo !WHT!Replace list:    !GRY!!REPLACELIST!!RST!
echo.

:skip_listMaterialsPreview
set "REPLACELIST=!REPLACELIST:\=.material.bin!"
set "REPLACELIST=!REPLACELIST:/=%MCLOCATION%\data\renderer\materials\!"
exit /b 0