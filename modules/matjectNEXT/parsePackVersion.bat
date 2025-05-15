:: parsePackVersion.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

if not defined mtnxt_targetPackNum set "mtnxt_targetPackNum=0"
set packVer=
set packVerInt=
for /f "delims=" %%a in ('modules\jq -cr ".[!mtnxt_targetPackNum!].version | join(\".\")" "%gameData%\minecraftpe\global_resource_packs.json"') do set packVer=%%a
set packVerInt=!packVer:.=!