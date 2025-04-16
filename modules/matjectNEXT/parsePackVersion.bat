:: parsePackVersion.bat // Made by github.com/faizul726
@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k

set packVer=
set packVerInt=
for /f "delims=" %%a in ('modules\jq -cr ".[0].version | join(\".\")" "%gameData%\minecraftpe\global_resource_packs.json"') do set packVer=%%a
set packVerInt=!packVer:.=!