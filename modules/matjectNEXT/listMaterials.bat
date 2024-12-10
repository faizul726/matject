@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

:list
set SRCCOUNT=
set SRCLIST=
set REPLACELIST=
set BINS=
set MTBIN=

if not exist "MATERIALS" mkdir MATERIALS

copy /d "!packPath!\renderer\materials\*.material.bin" "%cd%\MATERIALS\" >nul
echo !YLW![*] Copied !RED!main!YLW! materials.!RST!
if "!hasSubpack!" equ "true" (copy /d "!packPath!\subpacks\!subpackName!\renderer\materials\*.material.bin" "%cd%\MATERIALS" >nul)
echo !YLW![*] Copied !BLU!!subpackName!!YLW! ^(subpack^) materials.!RST!
echo.

if exist "%disableMatCompatCheck%" goto skip_matcheck
call "modules\checkMaterialCompatibility"
if !errorlevel! neq 0 (
    set "lastPack=!currentPack!"
    exit /b 1
)
:skip_matcheck


for %%f in (MATERIALS\*.material.bin) do (
    set "SRCLIST=!SRCLIST!,"%cd%\%%f""
    set "MTBIN=%%~nf"
    set "BINS=!BINS!"_!MTBIN:~0,-9!-" "
    set "REPLACELIST=!REPLACELIST!,"_!MTBIN:~0,-9!-""
    set /a SRCCOUNT+=1
)

set "SRCLIST=%SRCLIST:~1%"
set "REPLACELIST=%REPLACELIST:~1%"
set "REPLACELISTEXPORT=%REPLACELIST%"

echo !WHT!Materials count: !GRY!!SRCCOUNT!!RST!
echo !WHT!Source list:     !GRY!!SRCLIST:%cd%\MATERIALS\=!!RST!
echo !WHT!Replace list:    !GRY!!REPLACELIST!!RST!
set "REPLACELIST=!REPLACELIST:-=.material.bin!"
set "REPLACELIST=!REPLACELIST:_=%MCLOCATION%\data\renderer\materials\!"
echo.
exit /b 0