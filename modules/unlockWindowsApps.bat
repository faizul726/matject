@echo off

pushd "%~dp0"
cd ..

if exist "matject.bat" goto rogerthat

echo [93m[!] Couldn't get working folder automatically [0m
echo Please write down full location of the folder that has matject.bat and other files.
echo For example: [96mC:\Users\YourName\Downloads\matject-main[0m
echo.
:setme
set /p "workfolder=[97mWorking folder location:[0m "
echo.
cd /d "%workfolder%"
if %errorlevel% neq 0 echo [91m[!] Wrong input. & echo. [0m & goto setme
::echo ### %cd%
if not exist "matject.bat" (echo [93m[!] Wrong folder.[0m & echo. & goto setme)

:rogerthat
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [41;97mYOU MUST RUN THIS AS ADMIN![0m
    pause 
    goto:EOF
)

if not exist ".settings\" (mkdir .settings)

takeown /f "%ProgramFiles%\WindowsApps"
echo [93mResult: %errorlevel%[0m [Memorize this number, it might be required if this fails.]
if %errorlevel% equ 0 ( echo [%date% // %time%] - This file was created to indicate that WindowsApps is already unlocked and skip the question in Matject.>".settings\unlockedWindowsApps.txt" && timeout 3 > NUL )

echo Output: "%errorlevel%" //  Current directory: "%cd%" > ".settings\unlockLog.txt"