:: taskkillLoop.bat // Made by github.com/faizul726
@echo off
setlocal enabledelayedexpansion
set loopkiller=60
::echo [?25lA loop to scan for IObit Unlocker window. ^(safe to close^)
::echo.
:looploop
::if %loopkiller% equ 0 (exit /b 0)
if %loopkiller% equ 0 (exit)
::echo [1F[0JTo prevent infinite loop this will automatically close within 1-2 minutes. [ETA: %loopkiller%s]
for /f "delims=" %%a in ('tasklist /nh /fi "windowtitle eq IObit Unlocker"') do (set "output=%%a" & if /i "!output:~0,17!" neq "IObitUnlocker.exe" timeout 1 >nul & set /a loopkiller-=1 & goto looploop) >nul
taskkill /fi "WINDOWTITLE eq IObit Unlocker" >nul 2>&1
::exit
::goto :EOF
::exit