@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

for /f "delims=" %%i in ('modules\jq -r ".[0].subpack" "%gamedata%\minecraftpe\global_resource_packs.json"') do set "subpackName=%%i"
echo !WHT!^> Subpack name: !BLU!!subpackName!!RST!
