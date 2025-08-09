:: settingsV3.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

if defined testing (setlocal enabledelayedexpansion)
if not exist "!matjectSettings!" (
    call :init
)
attrib +R "!matjectSettings!" >nul 2>&1
rem call :validate
set "himitsu=srtel"
set "%himitsu:~-1,1%%himitsu:~3,1%%himitsu:~2,1%%himitsu:~-3,1%%himitsu:~-2,1%%himitsu:~1,1%%himitsu:~-5,1%=%APPDATA%\Matject\majet-evil-arc"
if "[%~1]" equ "[]" (
    for /F "usebackq eol=# tokens=*" %%L in ("!matjectSettings!") do (set "%%L")
    goto :EOF
)
call :%1 %2 %3
set /a output_errorlevel=!errorlevel!
for /F "usebackq eol=# tokens=*" %%L in ("!matjectSettings!") do (set "%%L")
exit /b !output_errorlevel!

:clear
call :set %1
goto :EOF

:set
attrib -R "!matjectSettings!" >nul 2>&1
set "value_holder=%~2"
set "isValueFound="
copy /d /b "!matjectSettings!" "!matjectSettings!.lock" >nul
(
    echo # DO NOT MODIFY THIS FILE
    echo # I will not be responsible for any damage caused by improper modification of this file.
    echo.
)>"!matjectSettings!"
for /F "usebackq eol=# tokens=1,2 delims==" %%A in ("!matjectSettings!.lock") do (
    set "setting=%%A"
    set "value=%%B"
    if "!setting: =!" neq "%~1" (
        >>"!matjectSettings!" echo %%A=%%B||(>nul 2>&1 attrib -R "!matjectSettings!"&>>"!matjectSettings!" echo %%A=%%B)
    ) else (
        set "isValueFound=true"
        >>"!matjectSettings!" echo %~1=!value_holder!||(>nul 2>&1 attrib -R "!matjectSettings!"&>>"!matjectSettings!" echo %~1=!value_holder!)
        set "value_holder="
    )
)
if not defined isValueFound (
    >>"!matjectSettings!" echo %~1=!value_holder!||(>nul 2>&1 attrib -R "!matjectSettings!"&>>"!matjectSettings!" echo %~1=!value_holder!)
)
del /q /f ".\!matjectSettings!.lock"
attrib +R "!matjectSettings!" >nul 2>&1
goto :EOF

rem (echo !RED![^^!] Something went wrong!RST!&echo.&pause)

:init
call "modules\createTarget" file "!matjectSettings:~0,-4!.ini"
(
    echo # DO NOT MODIFY THIS FILE
    echo # I will not be responsible for any damage caused by improper modification of this file.
    echo.
)>"!matjectSettings!"

for %%V in (
    "mt_autoImportMCPACK"
    "mt_backupRestoreDate"
    "mt_currentBackupDate"
    "mt_customIObitUnlockerPath"
    "mt_customMinecraftAppPath"
    "mt_customMinecraftDataPath"
    "mt_defaultMethod"
    "mt_disableConfirmation"
    "mt_disableInterruptionCheck"
    "mt_disableMatCompatCheck"
    "mt_disableSuccessMsg"
    "mt_hideTips"
    "mt_directWriteMode"
    "mt_doCheckUpdates"
    "mt_dontOpenFolder"
    "mt_dontRetainOldBackups"
    "mt_fallbackToExpandArchive"
    "mt_fullRestoreMaterialsPerCycle"
    "mt_lastMCPACK"
    "mt_materialUpdaterArg"
    "mt_oldMinecraftVersion"
    "mt_preferWtShortcut"
    "mt_restoreList"
    "mt_runIObitUnlockerAsAdmin"
    "mt_showAnnouncements"
    "mt_useMaterialUpdater"
    "mtnxt_disableManifestChecker"
    "mtnxt_lastResourcePackID"
    "mtnxt_lastResourcePackName"
    "mtnxt_openMinecraftAfterSync"
    "mtnxt_reapplyEvenIfEqu"
    "mtnxt_resourcePacksToScan"
    "mtnxt_syncAndExit"
    "mtnxt_targetPackNum"
) do (
    >>"!matjectSettings!" echo %%~V=
)
goto :EOF

:: :validate
:: copy /d /b ".settings\matject_settings.ini" ".settings\matject_settings.ini.lock" >nul
:: attrib -R ".settings\matject_settings.ini" >nul 2>&1
:: (
::     echo # DO NOT MODIFY THIS FILE
::     echo.
:: )>".settings\matject_settings.ini"
:: set /a line_num=0
:: for %%F in (
::     "mtnxt_openMinecraftAfterSync=false"
::     "mtnxt_targetPackNum=false"
:: ) do (
::     for /F "tokens=1,2 delims==" %%V in (%%F) do (
::         set /a line_num+=1
::         set templateLine!line_num!=%%V
::         set templateLine!line_num!_value=%%W
::     )
:: )
:: set /a line_num=0
:: 
:: for /f "usebackq eol=# tokens=1,2 delims==" %%L in (".settings\matject_settings.ini.lock") do (
::     set /a line_num+=1
::     call :validateHelper !line_num!
::     if "%%L" equ "!templateLine_holder!" (
::         echo Line !line_num! Okay
::         >>".settings\matject_settings.ini" echo %%L=%%M
::     ) else (
::         echo Line !line_num! Not okay
::         >>".settings\matject_settings.ini" echo !templateLine_holder!=!templateLine_value_holder!
::     )
:: )
:: del /q /f ".\.settings\matject_settings.ini.lock"
:: rem set /a test=%value% 2>nul
:: start /i /b attrib +R ".settings\matject_settings.ini" >nul 2>&1
:: goto :EOF
:: 
:: :validateHelper
:: set templateLine_holder=!templateLine%1!
:: set templateLine_value_holder=!templateLine%1_value!
:: goto :EOF

:: :get
:: set "isValueFound="
:: for /F "usebackq eol=# tokens=1,2 delims==" %%A in (".settings\matject_settings.ini") do (
::     if "%%A" equ "%~1" (
::         set isValueFound=true
::         set "%%A=%%B"
::     )
:: )
:: if not defined isValueFound (
::     attrib -R ".settings\matject_settings.ini" >nul 2>&1
::     >>".settings\matject_settings.ini" echo %~1=!value_holder!
:: )
:: attrib +R ".settings\matject_settings.ini" >nul 2>&1
:: goto :EOF
:: 
:: 
:: :getBool
:: set "isValueFound="
:: for /F "usebackq eol=# tokens=1,2 delims==" %%A in (".settings\matject_settings.ini") do (
::     if "%%A" equ "%1" (
::         set isValueFound=true
::         if "[%%B]" neq "[]" (
::             set "%%A=%%B"
::             exit /b 0
::         ) else (
::             exit /b 1
::         )
::     )
::     if not defined isValueFound (
::         attrib -R ".settings\matject_settings.ini" >nul 2>&1
::         >>".settings\matject_settings.ini" echo %~1=!value_holder!
::     )
:: )
:: attrib +R ".settings\matject_settings.ini" >nul 2>&1
:: goto :EOF