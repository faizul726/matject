:: backupMaterials.bat // Made by github.com/faizul726
@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k

echo Backup running... [%date% // %time:~0,-6%]>".settings\backupRunning.txt"
title %title% (making backup)
echo !GRN![*] Backing up materials...!RST!
echo.
xcopy /g "!MCLOCATION!\data\renderer\materials\*" ".\Backups%matbak:~7%" /q /e /i /h /y
del /q ".\.settings\backupRunning.txt" >nul
echo %date% // %time:~0,-6%>%backupDate%
title %title%
echo.
echo !GRN![*] Backed up materials to "Backups%matbak:~7%"!RST!
echo.
timeout 5