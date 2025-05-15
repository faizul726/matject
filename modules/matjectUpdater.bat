:: matjectUpdater.bat // Made by github.com/faizul726, licence issued by YSS Group

@echo off
setlocal enabledelayedexpansion
if "[%~1]" equ "[]" (if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k) else (goto letsgo)

:: Copy itself to tmp folder because during update the file itself will replaced.
echo [?25l!YLW![*] Copying updater to temporary folder...!RST!
echo.
if not exist tmp (mkdir tmp) else (del /q /f ".\tmp\*" >nul)

copy /d /b "modules\matjectUpdater.bat" "tmp" >nul

echo !YLW![*] Copied. Updating now...!RST!
start /i "" cmd /k ""tmp\matjectUpdater.bat" "%version%" "%latesturl:~50%""
timeout 3 >nul
exit

:letsgo
title Updating to Matject %~2
if not exist "%cd%\matject.bat" (
    pushd ..
    if not exist "%cd%\matject.bat" (
        echo [^^!] Failed find Matject folder.
        goto somethingNotWentWrong
    )
)

set "murgi=something"
call "modules\colors"

:: See if direct update is possible
for /f "delims=" %%x in ('curl -fSs https://raw.githubusercontent.com/faizul726/faizul726.github.io/main/matject/updateconfig.txt 2^>^&1') do (
    set "memoire=%%x"
    if "[%%x]" equ "[]" (goto somethingWentWrong) else (
        set "memoire=%%x"
        if /i "!memoire:~0,1!" neq "v" (goto somethingWentWrong) else (
            if /i "!memoire!" equ "%~1" (set "directUpdate=true") else (set "directUpdate=")
        )
    )
)

:: Once again, just in case...
for %%F in ("matject.bat" ".\.settings\*.ini" ".\.settings\*.vbs" ".\modules\*" ".\modules\matjectNEXT\*") do (attrib -R "%%~fF" >nul 2>&1)

:: Prioritize git over curl so extracting is not needed.
if defined directUpdate (
    echo !YLW![*] Updating from %~1 to %~2 ^(Direct update^)
) else (
    echo !YLW![*] Updating from %~1 to %~2 ^(Indirect update, will move old data to "Old Matject Data"^)
)
echo.
>nul 2>&1 where git && (
    echo !YLW![*] Downloading ^(using git clone^)...!RST!
    pushd tmp
    git clone https://github.com/faizul726/matject.git
    popd
    if exist "tmp\matject\matject.bat" (
        rmdir /q /s ".\tmp\matject\.git"
        rmdir /q /s ".\modules"
        del /q /f ".\*">nul 2>&1
        if not defined directUpdate (
            if not exist "Old Matject Data\%~1" (mkdir "Old Matject Data\%~1")
            for %%f in (".settings" "Backups" "Backups (Preview)" "logs" "MATERIALS" "MCPACKS") do (move /y "%%f" ".\Old Matject Data\%~1" >nul 2>&1)
        )
        for /d %%f in (tmp\matject\*) do (move /y "%%f" "%cd%" >nul 2>&1)
        for %%f in (tmp\matject\*) do (move /y "%%f" "%cd%" >nul 2>&1)
        goto updateDone
    ) else (goto somethingWentWrong)
) || (
    echo !YLW![*] Downloading ^(using curl^)...!RST!
    call :downloadSource
    if exist "%SYSTEMROOT%\system32\%tarexe%" (
        tar -xf "tmp\matject-main.zip" -C "tmp"
    ) else (
        powershell -NoProfile -Command Expand-Archive -Force 'tmp/matject-main.zip' 'tmp'
    )
    if exist "tmp\matject-main\matject.bat" (
        rmdir /q /s ".\modules"
        del /q /f ".\*">nul 2>&1
        if not defined directUpdate (
            if not exist "Old Matject Data\%~1" (mkdir "Old Matject Data\%~1")
            for %%f in (.settings Backups logs MATERIALS MCPACKS) do (move /y "%%f" "Old Matject Data\%~1" >nul 2>&1)
        )
        for /d %%f in (tmp\matject-main\*) do (move /y "%%f" "%cd%" >nul 2>&1)
        for %%f in (tmp\matject-main\*) do (move /y "%%f" "%cd%" >nul 2>&1)
        goto updateDone
    ) else (goto somethingWentWrong)
)

:updateDone
echo.
echo !GRN![*] Successfully updated to %~2!RST!
goto somethingNotWentWrong

:downloadSource
curl -fSsL -o "tmp\matject-main.zip" https://github.com/faizul726/matject/archive/main.zip
if !errorlevel! neq 0 (goto somethingWentWrong)
goto :EOF

:somethingWentWrong
echo !RED![^^!] Something went wrong...!RST!
:somethingNotWentWrong
echo.
echo Press any key to exit...
pause >nul
exit !errorlevel!