@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

:list
set SRCCOUNT=
set SRCLIST=
set REPLACELIST=
set REPLACELIST3=
set BINS=
set MTBIN=

echo Current directory: "%cd%"

echo.
echo.
if not exist "MATERIALS" mkdir MATERIALS

copy /d "!packPath!\renderer\materials\*.bin" "%cd%\MATERIALS\" >nul
echo !YLW![*] Copied main materials...!RST!
echo.
if "!hasSubpack!" equ "true" copy /d "!packPath!\subpacks\!subpackName!\renderer\materials\*.bin" "%cd%\MATERIALS" >nul
echo !YLW![*] Copied "!subpackName!" ^(subpack^) materials...!RST!
echo.
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

echo !WHT!Materials count:!RST! !SRCCOUNT!
echo.
echo !GRY!Source list: !SRCLIST!
echo.
echo !WHT!Replace list:!GRY! !REPLACELIST!!RST!
set "REPLACELIST=!REPLACELIST:_=%MCLOCATION%\data\renderer\materials\!"
set "REPLACELIST=!REPLACELIST:-=.material.bin!"
echo.
goto:EOF