@echo off
setlocal enabledelayedexpansion

cls
echo [97mRandom version comparator // Born on 20241115_1710[0m
echo Matject will use this script in the future.
echo Currently serves as a placeholder.
echo.

set /p "current_version=Enter current version: "
echo.
echo [93mYou entered [0m"%current_version%".
::echo.
::echo [93mTrimming input...[0m
set "current_version2=%current_version:~1%"
set "current_version2=%current_version2:.=%"
::echo.
echo [93mTrimmed input:[0m "%current_version2%"
::echo.
::echo [93mChecking if the input is 4 digit...[0m
set /a minus=%current_version2%-1000

if %minus% geq 10 (echo [91m%current_version% ^(current version^) is 4 digit[0m && set cver_4digit=true) else (echo [92m%current_version% ^(current version^) is NOT 4 digit[0m && set cver_4digit=false)
echo.
echo [93mGetting latest release tag...[0m

for /f "delims=" %%i in ('curl -Ls -o NUL -w "%%{url_effective}" "https://github.com/faizul726/matject/releases/latest"') do set "latesturl=%%i"

::set "latesturl=https://github.com/faizul726/matject/releases/tag/v3.1.34"

echo.
echo [93mLatest tag is:[0m %latesturl:~50%
set latesturl2=%latesturl:~51%
set latesturl2=%latesturl2:.=%
echo [93mTrimmed latest tag:[0m %latesturl2% 
::echo.
::echo [93mChecking if latest version is 4 digit...[0m
set /a minus=%latesturl2%-1000

if %minus% geq 10 (
    if "!cver_4digit!" equ "false" (
        set /a current_version2=%current_version2:~0,2%0%current_version2:~2,1%
    )
    echo [91m%latesturl:~50% ^(latest version^) is 4 digit[0m
    echo.
    if !current_version2! equ !latesturl2! (
        echo [92mYou are using LATEST version[0m
        echo Because, !current_version2! = !latesturl2!
    )
    if !current_version2! gtr !latesturl2! (
        echo [93m%current_version% is NEWER than %latesturl:~50%[0m
        echo Because, !current_version2! ^> !latesturl2!
    ) 
     if !current_version2! lss !latesturl2! (
        echo [91m%current_version% is OLDER than %latesturl:~50%[0m
        echo Because, !current_version2! ^< !latesturl2!
    )
) else (
    if "!cver_4digit!" equ "true" (
        set /a latesturl2=%latesturl2:~0,2%0%latesturl2:~2,1%
    )
    echo [92m%latesturl:~50% ^(latest version^) is NOT 4 digit[0m
    echo.
    if !current_version2! equ !latesturl2! (
        echo [92mYou are using LATEST version[0m
        echo Because, !current_version2! = !latesturl2!
    )
    if !current_version2! gtr !latesturl2! (
        echo [93m%current_version% is NEWER than %latesturl:~50%[0m
        echo Because, !current_version2! ^> !latesturl2!
    ) 
    if !current_version2! lss !latesturl2! (
        echo [91m%current_version% is OLDER than %latesturl:~50%[0m
        echo Because, !current_version2! ^< !latesturl2!
    )
)
cmd /k