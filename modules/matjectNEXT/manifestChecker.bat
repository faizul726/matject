:: manifestChecker.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

:: If you prefer a different code editor,
:: You can uncomment by removing ::
:: Then put path to code editor executable after the equal sign

::set "code_editor_to_use=path-to-code-editor-executable"

echo !YLW![*] manifest-checker: Checking manifests from resource packs...!RST!
echo.

for /d /r "%gameData%\resource_packs" %%D in (*) do (
    if exist "%%D\manifest.json" (
        modules\jq -r ".header.name" "%%D\manifest.json" >nul || call :invalidManifest "%%~nD" "%%D"
    )
)

for /d /r "%gameData%\development_resource_packs" %%D in (*) do (
    if exist "%%D\manifest.json" (
        modules\jq -r ".header.name" "%%D\manifest.json" >nul || call :invalidManifest "%%~nD" "%%D"
    )
)

echo [2F[0J!GRN![*] manifest-checker: Manifests from resource packs OK.!RST!
echo.
exit /b 0

:manifestNotFixed
echo.
echo.
echo.
echo.
echo !YLW![^^!] manifest-checker: Manifest was not fixed.!RST!
echo.
echo !WHT!Location:!RST!
echo !GRY!"%~2\manifest.json"!RST!
goto skip_invalidManifest

:invalidManifest
echo.
echo !RED![^^!] manifest-checker: Invalid manifest found.!RST!
echo.
echo !WHT!Location:!RST!
echo !GRY!"%~2\manifest.json"!RST!
:skip_invalidManifest
echo.
echo !WHT!What will you do?!RST!
echo.
echo [1] Fix it myself       [2] Auto fix it on codebeautify.org
echo [3] Disable the pack    [4] Copy it to desktop and exit
echo %RED%[5] Exit%RST%
echo.
if not defined mt_hideTips (
    echo !GRN![TIP]!RST! It's better to deactivate that pack from game first if activated then close Minecraft.
    echo       Make sure the game is closed during fixing.!RST!
)

echo.
echo.
choice /c 12345 >nul
if not defined code_editor_to_use (set code_editor_to_use=notepad)
if %errorlevel% equ 1 (
    echo !GRY![*] Waiting for user to close the text/code editor...!RST!
    start /wait /i "" "%code_editor_to_use:"=%" "%~2\manifest.json"
    modules\jq -r ".header.name" "%~2\manifest.json" >nul && goto :EOF || goto manifestNotFixed
)
if %errorlevel% equ 2 (
    type "%~2\manifest.json"|clip >nul
    echo %YLW%[*] JSON copied to clipboard.%RST%
    echo     Paste it in the left box, you will get fixed JSON in the right box.
    echo     Then in notepad, remove all existing text and paste fixed JSON there, save and close notepad.
    echo.
    start https://codebeautify.org/json-fixer
    start /i /min /wait "" %code_editor_to_use:"=% "%~2\manifest.json"
    modules\jq -r ".header.name" "%~2\manifest.json" >nul && goto :EOF || goto manifestNotFixed
)
if %errorlevel% equ 3 (rename "%~2\manifest.json" "manifest.json.disable" >nul 2>&1)
if %errorlevel% equ 4 (copy /d /b "%~2\manifest.json" "%USERPROFILE%\Desktop" & exit)
if %errorlevel% equ 5 (exit)
