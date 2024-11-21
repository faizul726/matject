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

copy "!packPath!\renderer\materials\*.bin" "%cd%\MATERIALS\" >nul
echo Copied main materials...
echo.
if "!hasSubpack!" equ "true" copy "!packPath!\subpacks\!subpackName!\renderer\materials\*.bin" "%cd%\MATERIALS" >nul
echo Copied "!subpackName!" ^(subpack^) materials...
echo.
for %%f in (MATERIALS\*.material.bin) do (
    set "SRCLIST=!SRCLIST!,"%cd%\%%f""
    set "MTBIN=%%~nf"
    set "BINS=!BINS!"!MTBIN:~0,-9!-" "
    set "REPLACELIST=!REPLACELIST!,"_!MTBIN:~0,-9!-""
    set /a SRCCOUNT+=1
)

set "SRCLIST=%SRCLIST:~1%"
set "REPLACELIST=%REPLACELIST:~1%"
set "REPLACELISTEXPORT=%REPLACELIST%"

echo Materials count: !SRCCOUNT!
echo.
echo !GRY!Source list: !SRCLIST!
echo.
echo Replace list: !REPLACELIST!
set "REPLACELIST=!REPLACELIST:_=%MCLOCATION%\data\renderer\materials\!"
set "REPLACELIST=!REPLACELIST:-=.material.bin!"
echo.
pause
goto:EOF