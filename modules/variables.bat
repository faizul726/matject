@echo off

if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k

if not defined isPreview (
    set "backupDate=.settings\backupDate.log"
    set "customMinecraftAppPath=.settings\customMinecraftAppPath.txt"
    set "customMinecraftDataPath=.settings\customMinecraftDataPath.txt"
    set "lastMCPACK=.settings\lastMCPACK.log"
    set "lastRP=.settings\lastPack.log"
    set "matbak=Backups\Materials (backup)"
    set "materialUpdaterArg=.settings\materialUpdaterArg.txt"
    set "oldMinecraftVersion=.settings\oldMinecraftVersion.txt"
    set "productID=MinecraftUWP"
    set "restoreDate=.settings\restoreDate.txt"
    set "rstrList=.settings\.restoreList.log"
) else (
    set "backupDate=.settings\backupDatePreview.log"
    set "customMinecraftAppPath=.settings\customMinecraftPreviewAppPath.txt"
    set "customMinecraftDataPath=.settings\customMinecraftPreviewDataPath.txt"
    set "lastMCPACK=.settings\lastMCPACKPreview.log"
    set "lastRP=.settings\lastPackPreview.log"
    set "matbak=Backups (Preview)\Materials (backup)"
    set "materialUpdaterArg=.settings\materialUpdaterArgPreview.txt"
    set "oldMinecraftVersion=.settings\oldMinecraftPreviewVersion.txt"
    set "productID=MinecraftWindowsBeta"
    set "restoreDate=.settings\restoreDatePreview.txt"
    set "rstrList=.settings\.restoreListPreview.log"
)

set "autoOpenMCPACK=.settings\autoOpenMCPACK.txt"
set "customIObitUnlockerPath=.settings\customIObitUnlockerPath.txt"
set "defaultGameData=%localappdata%\Packages\Microsoft.%productID%_8wekyb3d8bbwe\LocalState\games\com.mojang"
set "defaultMethod=.settings\defaultMethod.txt"
set "disableConfirmation=.settings\disableConfirmation.txt"
set "disableInterruptionCheck=.settings\disableInterruptionCheck.txt"
set "disableManifestCheck=.settings\disableManifestCheck.txt"
set "disableMatCompatCheck=.settings\disableMatCompatCheck.txt"
set "disableModuleVerification=.settings\disableModuleVerification.txt"
set "disableSuccessMsg=.settings\disableSuccessMsg.txt"
set "disableTips=.settings\disableTips.txt"
set "doCheckUpdates=.settings\doCheckUpdates.txt"
set "dontMakeReadOnly=.settings\dontMakeReadOnly.txt"
set "dontOpenFolder=.settings\dontOpenFolder.txt"
set "dontRetainOldBackups=.settings\dontRetainOldBackups.txt"
set "fallbackToExpandArchive=.settings\fallbackToExpandArchive.txt"
set "gameData=%defaultGameData%"
set "githubChangelogLink=https://raw.githubusercontent.com/faizul726/faizul726.github.io/main/matject/changelog.txt"
set "githubLink=https://faizul726.github.io/matject/"
set "matjectNEXTenabled=.settings\matjectNEXTenabled.txt"
set "preferWtShortcut=.settings\preferWtShortcut.txt"
set "ranOnce=.settings\ranOnce.txt"
set "runAsAdmin=.settings\runAsAdmin.txt"
set "runIObitUnlockerAsAdmin=.settings\runIObitUnlockerAsAdmin.txt"
set "showAnnouncements=.settings\showAnnouncements.txt"
set "syncThenExit=.settings\syncThenExit.txt"
set "thanksMcbegamerxx954=.settings\thanksMcbegamerxx954.txt"
set "unlocked=.settings\unlockedWindowsApps.txt"
set "useForMinecraftPreview=.settings\useForMinecraftPreview.txt"

set "backmsg=echo. && echo Press any key to go back... && pause > NUL && goto:EOF"
set "exitmsg=echo. && echo Press any key to exit... && pause > NUL && exit"
set "relaunchmsg=echo. & echo Press any key to relaunch... & pause >nul & start "Relaunching..." /i cmd /k matject.bat placebo & exit"
set "uacfailed=echo %ERR%[^^^^^!] Please allow the admin permission request.%RST% && echo. && echo Press any key to try again... && echo. && pause >nul"
set "dbg=echo PAUSE FOR TESTING. PRESS ANY KEY TO RESUME... && pause >nul"