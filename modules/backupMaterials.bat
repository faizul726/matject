@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k

echo Backup running... [%date% // %time:~0,-6%]>".settings\backupRunning.txt"
title %title% (making backup)
echo !GRN![*] Backing up materials...!RST!
echo.
xcopy /g "!MCLOCATION!\data\renderer\materials\*" ".\Backups\%matbak:~8%" /q /e /i /h /y
del /q /s ".\.settings\backupRunning.txt" >nul
echo %date% // %time:~0,-6%>%backupDate%
title %title%
echo.
echo !GRN![*] Backed up materials to "Backups\%matbak:~8%"!RST!
echo.
timeout 5