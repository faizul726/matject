:: unlockWindowsApps.bat // Made by github.com/faizul726, licence issued by YSS Group

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
if %errorlevel% neq 0 echo [91m[^^!] Wrong input. & echo. [0m & goto setme

if not exist "matject.bat" (echo [93m[^^!] Wrong folder.[0m & echo. & goto setme)

:rogerthat
>nul 2>&1 where fltmc && (
    >nul 2>&1 fltmc && (set isAdmin=true) || (set "isAdmin=")
) || (
    >nul 2>&1 where openfiles && (
        >nul 2>&1 openfiles && (set isAdmin=true) || (set "isAdmin=")
    ) || (
        >nul 2>&1 where wmic && (
            >nul 2>&1 (wmic /locale:ms_409 service where ^(name="LanManServer"^) get state /value 2>nul | findstr /i "State=Running" >nul 2>&1)
            if %errorlevel% equ 0 (
                >nul 2>&1 net session && (set isAdmin=true) || (set "isAdmin=")
            ) else (set "isAdmin=")
        ) || (set "isAdmin=")
    )
)


takeown /f "%ProgramFiles%\WindowsApps" || (
    >logs\_unlockLog.txt takeown /f "%ProgramFiles%\WindowsApps"
)
echo [93mResult: %errorlevel%[0m [Memorize this number, it might be required if this fails.]
if %errorlevel% equ 0 (
    echo [92m[*] Code GREEN - Everything is OK.[0m
    echo [%date% // %time:~0,-6%] - This file was created to indicate that WindowsApps is already unlocked and skip the question in Matject.>".settings\unlockedWindowsApps.txt" && timeout 3 > NUL
    if not exist ".settings\unlockedWindowsApps.txt" (
        echo Failed to create success file. Are you using any antivirus that's preventing from creating files?
        echo.
        echo Take a screenshot of the window. It might be helpful later. [%date%]
        echo If you can, report the issue on GitHub repo or join Bedrock Graphics Discord server and report in #matject
        echo [96m
        echo https://faizul726.github.io/bedrockgraphics-discord
        echo [0m[?25h
        endlocal
        echo on
        @cmd /k
    )
) else (
    echo [91m[^^!] Code RED[0m ^(ERRORLEVEL: !errorlevel!^) & echo Take a screenshot. It might be helpful later. [%date%] & echo. & pause >nul
    echo Output: "%errorlevel%" //  Current directory: "!cd:%USERNAME%=[REDACTED]!" >> ".settings\_unlockLog.txt"
)