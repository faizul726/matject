@echo off

if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

cls

where curl >nul 2>&1
if !errorlevel! neq 0 echo !RED![^^!] curl executable is not present. It is required to check for updates.!RST! & %backmsg%

echo !YLW![*] Checking for updates...!RST!
echo.
echo Current version: %version%%dev%
::set "version=v3.0.2"

set "version2=%version:~1%"
set "version2=%version2:.=%"
set /a minus=%version2%-1000
if %minus% geq 10 (set cver_4digit=true) else (set cver_4digit=false)
for /f "delims=" %%i in ('curl -Ls -o NUL -w "%%{url_effective}" "https://github.com/faizul726/matject/releases/latest"') do set "latesturl=%%i"
::set "latesturl=https://github.com/faizul726/matject/releases/tag/v2.9.2"
echo.
if "%latesturl%" equ "https://github.com/faizul726/matject/releases/latest" (
    echo !ERR![^^!] Failed to check for updates.!RST!
    echo !YLW!Please check your internet connection.!RST!
    echo.
    echo Press any key to use Matject offline...
    pause >nul
    cls
    goto:EOF
)

set latestversion=%latesturl:~51%
set latestversion=%latestversion:.=%
set /a minus=%latestversion%-1000

if %minus% geq 10 (
    if "!cver_4digit!" equ "false" (
        set /a version2=%version2:~0,2%0%version2:~2,1%
    )
    if !version2! equ !latestversion! (
        echo !GRN![*] Matject is up to date.!RST!
        timeout 2 >nul
    )
    if !version2! gtr !latestversion! (
        echo !WHT!o_O You must be a time traveler because !YLW!%version%%dev%!WHT! is NEWER than !YLW!%latesturl:~50%!RST!
        echo.
        echo Have we achieved global peace yet?
        echo.
        echo !GRY!Jokes aside, press any key to use Matject...!RST!
        pause >nul
    ) 
    if !version2! lss !latestversion! (
        echo !YLW![*] New update is available. !RST!^(%version%%dev% -^> %latesturl:~50%^)
        echo.
        echo !WHT!Make sure to restore backup before using new version!RST!
        echo.
        echo !WHT![^^!] Please download latest version from !CYN!faizul726.github.io/matject!RST!
        echo.
        echo or press any key to use Matject...
        echo.
        pause >nul
    )
) else (
    if "!cver_4digit!" equ "true" (
        set /a latestversion=%latestversion:~0,2%0%latestversion:~2,1%
    )
    if !version2! equ !latestversion! (
        echo !GRN![*] Matject is up to date.!RST!
        timeout 2 >nul
    )
    if !version2! gtr !latestversion! (
        echo !WHT!o_O You must be a time traveler because !YLW!%version%%dev%!WHT! is NEWER than !YLW!%latesturl:~50%!RST!
        echo.
        echo Have we achieved global peace yet?
        echo.
        echo !GRY!Jokes aside, press any key to use Matject...!RST!
        pause >nul
    ) 
    if !version2! lss !latestversion! (
        echo !YLW![*] New update is available. !RST!^(%version%%dev% -^> %latesturl:~50%^)
        echo.
        echo !WHT!Make sure to restore backup before using new version!RST!
        echo.
        echo !WHT![^^!] Please download latest version from !CYN!faizul726.github.io/matject!RST!
        echo.
        echo or press any key to use Matject...
        echo.
        pause >nul
    )
)
cls