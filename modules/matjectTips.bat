:: Made possible thanks to https://stackoverflow.com/questions/5777400/how-to-use-random-in-batch-script
@echo off

if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k

set /a num=%RANDOM% %% 2

call :random_%num%
if %num% equ 1 call :tip "Enable material-updater in settings to fix invisible blocks"
if %num% equ 2 call :tip "!RED!matjectNEXT!RST! can do the same based on the top pack in Global Resource Packs"
if %num% equ 3 call :tip "Disable confirmations in settings to speed up injection. ^(if you know what you're doing^)"
if %num% equ 4 call :tip "Set default method in settings if you use one method frequently"
if %num% equ 5 call :tip "You can disable automatic folder opening in settings if you find it annoying"
if %num% equ 6 call :tip "Minecraft Preview is also supported"
if %num% equ 7 call :tip "Getting Minecraft app location can be made faster by setting custom Minecraft app path"
if %num% equ 8 call :tip "Join !CYN!faizul726.github.io/newb-discord!RST! for updates and support^)"
if %num% equ 9 call :tip "Run Matject as admin to auto close IObit Unlocker popups. ^(or enable Run IObit Unlocker as admin in settings^)"
if %num% equ 10 call :tip "You can remove shader at any time from Remove Shaders/Tools"
if %num% equ 11 call :tip "There's a hidden easter egg somewhere in the files. Can you find it?"
if %num% equ 12 call :tip "You can open Minecraft data folder from Remove Shaders/Tools"
if %num% equ 13 call :tip "Lost backup? Get from !CYN!mcpebd.github.io/mats!RST! and use Replace Backup option"
if %num% equ 14 call :tip "Don't worry about backups. Matject automatically makes new backup when game is updated"
if %num% equ 15 call :tip "Auto mode supports both MCPACK and ZIP"
if %num% equ 16 call :tip "If you are using 3rd party Minecraft Launcher, it's better to set both app and data locations in custom paths"
if %num% equ 17 call :tip "You can keep all of your shaders in MCPACKS folder and use whatever you want using auto method"
if %num% equ 18 call :tip "You can stay up to date about Matject by enabling Matject announcements in settings"
if %num% equ 19 call :tip "You like Matject? You can star the GitHub repo or donate to support its development :^)"
if %num% equ 20 call :tip "Chickens are basically smol dinosaurs"
if %num% equ 21 call :tip "You don't have to open Matject every time for shaders"
if %num% equ 22 call :tip "Check out 'Matject Settings' to enhance overall experience"
if %num% equ 23 call :tip "Old shaders, RTX, PBR packs are NOT SUPPORTED"
if %num% equ 24 call :tip "Matject is not a replacement for BetterRenderDragon. Rather, it's a workaround"
if %num% equ 25 call :tip "You shouldn't use Matject if you use any kind of Windows debloater/optimizer"
if %num% equ 26 call :tip "Some antivirus may prevent IObit Unlocker from working, and Matject can't detect that"
if %num% equ 27 call :tip "The GitHub link is the only official source for Matject"
if %num% equ 28 call :tip "Matject was born on August 29, 2024"
if %num% equ 29 call :tip "Matject was previously called 'Material Injector'"
if %num% equ 30 call :tip "Matjet goes hard.      - Arc, YSS Discord admin"
set "num="
goto :EOF

:random_0
set /a num=%RANDOM% * 30 / 32768 + 1
goto :EOF

:random_1
set /a num=%RANDOM% %% 30 + 1
goto :EOF

:tip
echo !GRN![TIP]!RST! %~1
goto :EOF