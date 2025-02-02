@echo off
setlocal enabledelayedexpansion

pushd "%~dp0"
cd ..

if exist "matject.bat" goto rogerthat

echo [93m[!] Couldn't get Matject folder automatically[0m
echo Please write down full location of the folder that has matject.bat and other files.
echo For example: [96mC:\Users\YourName\Downloads\matject-main[0m
echo.
:setme
set /p "workfolder=[97mWorking folder location:[0m "
echo [?25l
pushd "%workfolder%"
if %errorlevel% neq 0 echo [91m[!] Wrong input. & echo. [0m & goto setme

if not exist "matject.bat" (echo [93m[!] Wrong folder.[0m & echo. & goto setme)

:rogerthat
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [41;97mYOU MUST RUN THIS AS ADMIN![0m
    pause 
    goto:EOF
)

if not exist ".\.settings" (mkdir .settings)

takeown /f "%ProgramFiles%\WindowsApps" || (
    >logs\unlockLog_%date:/=-%_%random%.txt takeown /f "%ProgramFiles%\WindowsApps"
)
echo [93mResult: %errorlevel%[0m [Memorize this number, it might be required if this fails.]
if %errorlevel% equ 0 (
    echo [92mCode GREEN[0m
    echo [%date% // %time:~0,-6%] - This file was created to indicate that WindowsApps is already unlocked and skip the question in Matject.>".settings\unlockedWindowsApps.txt" && timeout 3 > NUL
    if not exist ".settings\unlockedWindowsApps.txt" (
        echo Failed to create success file. Are you using any antivirus that's preventing from creating files?
        echo.
        echo Take a screenshot of the window. It might be helpful later. [%date%]
        echo If you can, report the issue on GitHub repo or join Newb Discord server and report in #newb-support
        echo [96m
        echo https://faizul726.github.io/newb-discord
        echo [0m[?25h
        echo on
        cmd /k
    )
) else (
    echo [91mCode RED[0m ^(ERRORLEVEL: !errorlevel!^) & echo Take a screenshot. It might be helpful later. [%date%] & echo. & pause >nul
    echo Output: "%errorlevel%" //  Current directory: "!cd:%USERNAME%=CENSORED!" > ".settings\_unlockLog.txt"
)