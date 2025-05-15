:: backupMaterials.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

echo Backup running... [%date% // %time:~0,-6%]>"!backupRunning:~0,-4!.log"
title %title% (making backup)
echo !GRN![*] Backing up materials...!RST!
echo.
::xcopy /g "!MCLOCATION!\data\renderer\materials\*" ".\Backups!matbak:~7!" /q /e /i /h /y
if not exist "Backups!matbak:~7,-19!\*" call "modules\createTarget" folder "Backups!matbak:~7,-19!"
if not exist "Backups!matbak:~7!\*" call "modules\createTarget" folder "Backups!matbak:~7!"
del /q /f ".\Backups!matbak:~7!\*" >nul 2>&1

set /a _counter=0
set /a _counterTotal=0
for %%F in ("!MCLOCATION!\data\renderer\materials\*") do (
    set /a _counterTotal+=1
)
for %%F in ("!MCLOCATION!\data\renderer\materials\*") do (
    copy /d /b "%%F" ".\Backups!matbak:~7!" >nul 2>&1
    set /a _counter+=1
    call "modules\progressbar" !_counterTotal! !_counter!
    echo [2F
)
del /q /f ".\!backupRunning:~0,-4!.log" >nul
rem echo %date% // %time:~0,-6%>%backupDate%
call "modules\settingsV3" set mt_currentBackupDate "%date% // %time:~0,-6%"

title %title%
echo !GRN![*] Backed up %_counter% materials to "Backups!matbak:~7!"!RST!
set "_counter="
set "_counterTotal="
echo.
timeout 5