:: taskkillLoop.bat // Made by github.com/faizul726, licence issued by YSS Group

@echo off
setlocal enabledelayedexpansion

set loopkiller=60

:looploop
if %loopkiller% equ 0 (goto :EOF)
for /f "delims=" %%a in ('tasklist /nh /fi "windowtitle eq IObit Unlocker"') do (
    set "output=%%a"
    if /i "!output:~0,17!" neq "IObitUnlocker.exe" (
        timeout 1 >nul
        set /a loopkiller-=1
        goto looploop
    ) 
)
taskkill /fi "WINDOWTITLE eq IObit Unlocker" >nul 2>&1