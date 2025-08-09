:: checkUpdates.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

cls
echo !YLW!!BLINK![*] Checking for Matject updates...!RST!
echo.
echo Current version: %version%
echo.
:: Checks if system has curl executable.
where curl >nul 2>&1
if !errorlevel! neq 0 echo !RED![^^!] curl is not available on your system. It is required to check for updates.!RST! & %backmsg%

:: For testing purpose
::set "version=v3.2.0"

:: First removes v from version and then the periods. Lastly, subtracts 1000 on for later comparison.
set "version2=%version:~1%"
set "version2=%version2:.=%"
set /a minus=%version2%-1000
:: Depending on the result, it decides whether current version is 4 digit or not.
if %minus% geq 10 (set cver_4digit=true) else (set cver_4digit=false)
:: This line was given by ChatGPT. All it does is store the final link after redirects in a variable.
for /f "delims=" %%i in ('curl -Ls -o NUL -w "%%{url_effective}" "https://github.com/faizul726/matject/releases/latest"') do set "latesturl=%%i"

:: For testing purpose
::set "latesturl=https://github.com/faizul726/matject/releases/tag/v2.9.2"

:: If link stays unchanged, it is considered that something is wrong with the internet connection.
if "%latesturl%" equ "https://github.com/faizul726/matject/releases/latest" (
    echo !ERR![^^!] Failed to check for updates.!RST!
    echo !YLW!Maybe check your internet connection?!RST!
    echo.
    echo Press any key to use Matject offline...
    pause >nul
    cls
    goto:EOF
)

:: Trims to only the version part from the link as well as removes periods and subtracts 1000 for later comparison.
set latestversion=%latesturl:~51%
set latestversion=%latestversion:.=%
set /a minus=%latestversion%-1000

:: Now based on previous results it compares current version and the one obtained using curl. Then calls respective function or whatever.
if %minus% geq 10 (
    if "!cver_4digit!" equ "false" (set /a version2=%version2:~0,2%0%version2:~2,1%)
    if !version2! lss !latestversion! (call :olderversion)
    if !version2! equ !latestversion! (call :sameversion)
    if !version2! gtr !latestversion! (call :newerversion)
) else (
    if "!cver_4digit!" equ "true" (set /a latestversion=%latestversion:~0,2%0%latestversion:~2,1%)
    if !version2! lss !latestversion! (call :olderversion)
    if !version2! equ !latestversion! (call :sameversion)
    if !version2! gtr !latestversion! (call :newerversion)
)
goto:EOF

:sameversion
cls
echo !GRN![*] You're on the latest version of Matject^^! :D!RST!
timeout 2 >nul
goto:EOF

:newerversion
cls
echo !WHT!o_O You must be a time traveler because !YLW!%version%!WHT! is NEWER than !YLW!%latesturl:~50%!RST!
echo.
echo Have we achieved global peace yet?
echo.
echo !GRY!Jokes aside, press any key to use Matject...!RST!
pause >nul
goto:EOF

:olderversion
cls
echo !YLW![*] New Matject update is available. !RST!^(%version% -^> %latesturl:~50%^)
echo.
echo !WHT!Make sure to restore backup before using new version.!RST!
echo.
echo !WHT![*] What's new in %latesturl:~50%?!RST!
echo.
call :fetchChangelog
echo.
echo.
echo !BEL!!YLW![?] Do you want to update to Matject %latesturl:~50%?!RST!
echo.
echo !RED![Y] Yes    !GRN![N] No, go back!RST!
choice /c yn /n >nul
echo.
if !errorlevel! equ 1 (
    cls
    if exist ".settings\.restoreList.log" (
        echo !YLW![^^!] You have to restore default materials before you can continue.!RST!
        %backmsg%
    )
    if exist ".settings\.restoreListPreview.log" (
        echo !YLW![^^!] You have to restore default materials ^(Minecraft Preview^) before you can continue.!RST!
        %backmsg%
    )
    echo !YLW![*] This will download latest source from github.com/faizul726/matject extract it.!RST!
    echo.
    echo !YLW![?] Are you sure you want to continue?!RST!
    echo.
    echo !RED![Y] Yes    !GRN![N] No, not now!RST!
    choice /c yn /n >nul
    echo.
    if !errorlevel! equ 1 call "modules\matjectUpdater"
)
goto :EOF

:fetchChangelog
setlocal DISABLEDELAYEDEXPANSION
:: Disable delayed expansion to prevent arbitrary code execution
:: Although I couldn't find a way to execute remote code but still it's better to be safe.

:: Escape symbol/code/sequence is used so that the curl output starts from the same line as getting changelog.
echo Getting changelog...[1F
curl -f %githubChangelogLink% 2>nul
if %errorlevel% neq 0 (echo %RED%[!] Failed to fetch changelog.%RST%)

setlocal enabledelayedexpansion
goto :EOF

:autoUpdate
