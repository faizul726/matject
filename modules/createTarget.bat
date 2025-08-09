:: Made possible thanks to https://stackoverflow.com/a/3728742
:: createTarget.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off
setlocal

if exist "%~2" (call :isFileOrFolder "%~1" "%~2" & set "ATTR=")

if /i "%~1" equ "file" (
    if %errorlevel% equ 4 (goto :EOF)
    if %errorlevel% equ 6 (rmdir /q /s ".\%~2")
    if "[%~3]" neq "[]" (echo %~3>"%~2") else (break>"%~2")
)

if /i "%~1" equ "folder" (
    if %errorlevel% equ 6 (goto :EOF)
    if %errorlevel% equ 4 (del /q /f ".\%~2")
    mkdir "%~2"
)

endlocal
goto :EOF

:isFileOrFolder
set ATTR=%~a2
if /i "%ATTR:~0,1%" equ "d" (exit /b 6) else (exit /b 4)