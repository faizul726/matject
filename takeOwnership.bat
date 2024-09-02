@echo off

cd "%~dp0"
net session >nul 2>&1
if %errorLevel% == 0 (
    takeown /f "%ProgramFiles%\WindowsApps" /r /d y
    echo [92mSTEP 1/2 DONE![0m
    
    timeout 5 > NUL
    
    icacls "%ProgramFiles%\WindowsApps" /grant *S-1-3-4:F /t /c /l /q
    echo [92mSTEP 2/2 DONE![0m
    
    echo DONE! > claimedOwnership.txt
    ) else (
        echo YOU MUST RUN THIS AS ADMIN!
        pause
)