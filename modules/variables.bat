:: variables.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

if not defined isPreview (
    rem Variables for release
    set "backupRunning=.settings\backupRunning.log"
    set "matbak=Backups\Materials (backup)"
    set "matjectSettings=.settings\matject_settings.ini"
    set "productID=MinecraftUWP"
    set "taskOngoing=.settings\taskOngoing.txt"
) else (
    rem Variables for preview
    set "backupRunning=.settings\backupRunningPreview.log"
    set "matbak=Backups (Preview)\Materials (backup)"
    set "matjectSettings=.settings\matject_settings_preview.ini"
    set "productID=MinecraftWindowsBeta"
    set "taskOngoing=.settings\taskOngoingPreview.log"
)

set "defaultGameData=%localappdata%\Packages\Microsoft.%productID%_8wekyb3d8bbwe\LocalState\games\com.mojang"
set "mt_fullRestoreMaterialsPerCycle_default=10"
set "disableModuleVerification=.settings\disableModuleVerification.txt"
set "dontMakeReadOnly=.settings\dontMakeReadOnly.txt"
set "gameData=%defaultGameData%"
set "githubChangelogLink=https://raw.githubusercontent.com/faizul726/faizul726.github.io/main/matject/changelog.txt"
set "githubLink=https://faizul726.github.io/matject/"
set "matjectNEXTenabled=.settings\matjectNEXTenabled.txt"
set "ranOnce=.settings\ranOnce.txt"
set "runAsAdmin=.settings\runAsAdmin.txt"
set "unlocked=.settings\unlockedWindowsApps.txt"
set "useForMinecraftPreview=.settings\useForMinecraftPreview.txt"

set "backmsg=echo. && echo Press any key to go back... && pause > NUL && goto:EOF"
set "exitmsg=echo. && echo Press any key to exit... && pause > NUL && exit"
set "relaunchmsg=echo. & echo Press any key to relaunch... & pause >nul & start "Relaunching..." /i cmd /k matject.bat placebo & exit"
set "uacfailed=echo: & echo: & echo %ERR%[^^^^^!] Please allow the admin permission request.%RST% & echo. & echo Press any key to try again... & echo: & pause >nul"
set "dbg=echo %YLW%PAUSE FOR TESTING. PRESS ANY KEY TO RESUME...%RST% && pause >nul"