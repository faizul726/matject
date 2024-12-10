@echo off

if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

if not defined isPreview (
    set "backupDate=.settings\backupDate.txt"
    set "customMinecraftAppPath=.settings\customMinecraftAppPath.txt"
    set "customMinecraftDataPath=.settings\customMinecraftDataPath.txt"
    set "lastRP=.settings\lastPack.txt"
    set "matbak=Backups\Materials (backup)"
    set "materialUpdaterArg=.settings\materialUpdaterArg.txt"
    set "oldMinecraftVersion=.settings\oldMinecraftVersion.txt"
    set "productID=MinecraftUWP"
    set "rstrList=.settings\.restoreList.log"
) else (
    set "backupDate=.settings\backupDatePreview.txt"
    set "customMinecraftAppPath=.settings\customMinecraftPreviewAppPath.txt"
    set "customMinecraftDataPath=.settings\customMinecraftPreviewDataPath.txt"
    set "lastRP=.settings\lastPackPreview.txt"
    set "matbak=Backups (Preview)\Materials (backup)"
    set "materialUpdaterArg=.settings\materialUpdaterArgPreview.txt"
    set "oldMinecraftVersion=.settings\oldMinecraftPreviewVersion.txt"
    set "productID=MinecraftWindowsBeta"
    set "rstrList=.settings\.restoreListPreview.log"
)

set "autoOpenMCPACK=.settings\autoOpenMCPACK.txt"
set "customIObitUnlockerPath=.settings\customIObitUnlockerPath.txt"
set "defaultGameData=%localappdata%\Packages\Microsoft.%productID%_8wekyb3d8bbwe\LocalState\games\com.mojang"
set "defaultMethod=.settings\defaultMethod.txt"
set "disableConfirmation=.settings\disableConfirmation.txt"
set "disableInterruptionCheck=.settings\disableInterruptionCheck.txt"
set "disableMatCompatCheck=.settings\disableMatCompatCheck.txt"
set "disableSuccessMsg=.settings\disableSuccessMsg.txt"
set "doCheckUpdates=.settings\doCheckUpdates.txt"
set "dontRetainOldBackups=.settings\dontRetainOldBackups.txt"
set "gameData=%defaultGameData%"
set "matjectNEXTenabled=.settings\matjectNEXTenabled.txt"
set "ranOnce=.settings\ranOnce.txt"
set "syncThenExit=.settings\syncThenExit.txt"
set "thanksMcbegamerxx954=.settings\thanksMcbegamerxx954.txt"
set "unlocked=.settings\unlockedWindowsApps.txt"
set "useForMinecraftPreview=.settings\useForMinecraftPreview.txt"

set "backmsg=echo. && echo Press any key to go back... && pause > NUL && goto:EOF"
set "exitmsg=echo. && echo Press any key to exit... && pause > NUL && exit"
set "relaunchmsg=echo. & echo Press any key to relaunch... & pause >nul & start ""Loading..."" matject & exit 0"
set "uacfailed=echo %ERR%[^^^^^!] Please accept UAC.%RST% && echo. && echo Press any key to try again... && echo. && pause >nul"