:: progressBar.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off
setlocal

set /a currentAmount=(%2 * 40) / %1
set /a percentage=(%2 * 100) / %1

set "bar=                                        "
::if %percent% lss 10 (set "percent= %percent%")
::if %percent% lss 100 (set "percent= %percent%") 

:: if %currentAmount% geq 40 set /a currentAmount=40
if %currentAmount% leq 0  (set /a currentAmount=0 & set "remainingAmount=") else (set "remainingAmount=,-!currentAmount!")
echo Progress: 0%% [107m!bar:~0,%currentAmount%![100m!bar:~0%remainingAmount%![0m %percentage%%%

endlocal