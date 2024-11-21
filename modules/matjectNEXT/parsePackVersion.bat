@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

set packVer=
set packVer2=
for /f "delims=" %%a in ('modules\jq -cr ".[0].version | join(\".\")" "%gamedata%\minecraftpe\global_resource_packs.json"') do set packVer=%%a
set packVer2=!packVer:.=!