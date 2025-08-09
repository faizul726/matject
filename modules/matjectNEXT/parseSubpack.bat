:: parseSubpack.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

if defined mtnxt_targetPackNum (
    set /a mtnxt_targetPackNum_preview=!mtnxt_targetPackNum! + 1
) else (
    set mtnxt_targetPackNum=0
)
for /f "delims=" %%i in ('modules\jq -r ".[!mtnxt_targetPackNum!].subpack" "%gameData%\minecraftpe\global_resource_packs.json"') do set "subpackName=%%i"
