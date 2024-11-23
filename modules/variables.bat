@echo off

if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

set "autoOpenMCPACK=.settings\autoOpenMCPACK"
set "backupDate=.settings\backupDate.txt"
set "customMinecraftPath=.settings\customMinecraftPath.txt"
set "customUnlockerPath=.settings\customUnlockerPath.txt"
set "defaultMethod=.settings\defaultMethod.txt"
set "disableConfirmation=.settings\disableConfirmation"
set "disableInterruptionCheck=.settings\disableInterruptionCheck"
set "disableRetainOldBackups=.settings\disableRetainOldBackups"
set "disableSuccessMsg=.settings\disableSuccessMsg"
set "doCheckUpdates=.settings\doCheckUpdates.txt"
set "gamedata=%localappdata%\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang"
set "matbak=Backups\Materials (backup)"
set "materialUpdaterArg=.settings\materialUpdaterArg.txt"
set "matjectNEXTenabled=.settings\matjectNEXTenabled.txt"
set "oldMinecraftVersion=.settings\oldMinecraftVersion.txt"
set "ranOnce=.settings\ranOnce.txt"
set "thanksMcbegamerxx954=.settings\thanksMcbegamerxx954.txt"
set "unlocked=.settings\unlockedWindowsApps.txt"
set "useAutoAlways=.settings\useAutoAlways"
set "useManualAlways=.settings\useManualAlways"
set "usematjectNEXTAlways=.settings\usematjectNEXTAlways"

set "exitmsg=echo. && echo Press any key to exit... && pause > NUL && exit"
set "backmsg=echo. && echo Press any key to go back... && pause > NUL && goto:EOF"