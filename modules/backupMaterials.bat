@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

title %title% (making backup)
echo !GRN![*] Backing up materials...!RST!
xcopy /g "!MCLOCATION!\data\renderer\materials\*" "%matbak%\" /e /i /h /y > NUL
echo %date% // %time%>%backupDate%
title %title%
echo.
echo !GRN![*] Backed up materials to "Backups\Materials (backup)"!RST!
echo.
timeout 5