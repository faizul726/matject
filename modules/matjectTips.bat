:: Made possible thanks to https://stackoverflow.com/questions/5777400/how-to-use-random-in-batch-script
:: matjectTips.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

set /a num=%RANDOM% %% 2

call :random_%num%
::set num=6
if %num% equ 1 call :tip "Enable material-updater in !WHT![S] Matject Settings!RST! to fix invisible blocks"
if %num% equ 2 call :tip "!RED![3] matjectNEXT!RST! can do the same based on the top pack in Global Resource Packs"
if %num% equ 3 call :tip "Disable confirmations in !WHT![S] Matject Settings!RST! to speed up injection. ^(if you know what you're doing^)"
if %num% equ 4 call :tip "Set default method in !WHT![S] Matject Settings!RST! if you use one method frequently"
if %num% equ 5 call :tip "You can disable automatic folder opening in !WHT![S] Matject Settings!RST! if you find it annoying"
if %num% equ 6 call :tip "You can use Matject for Minecraft Preview by enabling 'Use for Minecraft Preview' in !WHT![S] Matject Settings!RST!"
if %num% equ 7 call :tip "Getting Minecraft app location can be made faster by setting custom Minecraft app path"
if %num% equ 8 call :tip "Join !CYN!faizul726.github.io/bedrockgraphics-discord!RST! for updates and support"
if %num% equ 9 call :tip "Run Matject as admin to auto close IObit Unlocker popups. ^(or enable Run IObit Unlocker as admin in !WHT![S] Matject Settings!RST!^)"
if %num% equ 10 call :tip "You can remove shader at any time from !WHT![R] Shader Removal/Tools!RST!"
if %num% equ 11 call :tip "There's a hidden easter egg somewhere in the files. Can you find it?"
if %num% equ 12 call :tip "You can open Minecraft data folder from !WHT![R] Shader Removal/Tools!RST!"
if %num% equ 13 call :tip "Lost backup? Get from !CYN!mcpebd.github.io/materials!RST! and use Replace Backup option"
if %num% equ 14 call :tip "Don't worry about backups. Matject automatically makes new backup when game is updated"
if %num% equ 15 call :tip "!GRN![1] Auto!RST! mode supports both MCPACK and ZIP files"
if %num% equ 16 call :tip "If you are using 3rd party Minecraft Launcher, it's better to set both app and data locations in custom paths"
if %num% equ 17 call :tip "You can keep all of your shaders in MCPACKS folder and use whatever you want using !GRN![1] Auto!RST! method"
if %num% equ 18 call :tip "You can stay up to date about Matject by enabling 'Matject announcements' in !WHT![S] Matject Settings!RST!"
if %num% equ 19 call :tip "You like Matject? You can star the GitHub repo or donate to support its development :^)"
if %num% equ 20 call :tip "Chickens are basically smol dinosaurs"
if %num% equ 21 call :tip "You don't have to open Matject every time for shaders"
if %num% equ 22 call :tip "Check out !WHT![S] Matject Settings!RST! to enhance overall experience"
if %num% equ 23 call :tip "Old shaders ^(HAL^) are NOT SUPPORTED"
if %num% equ 24 call :tip "Restore won't work properly if you had modified materials already before using Matject"
if %num% equ 25 call :tip "Press Q in some screens to know what each action does."
if %num% equ 26 call :tip "Some antivirus may prevent IObit Unlocker from working"
if %num% equ 27 call :tip "The GitHub link is the only official source for Matject"
if %num% equ 28 call :tip "Matject was born on August 29, 2024"
if %num% equ 29 call :tip "Matject was previously called 'Material Injector'"
if %num% equ 30 call :tip "Matjet goes hard. & echo     !GRY!- Arc, YSS Discord admin!RST!"
if %num% equ 31 call :tip "A chimken pixel art game is hidden somewhere. Can you find it? ;^)"
if %num% equ 32 call :tip "Deleting Matject or deactivating resource pack won't remove shaders. Use [R] Shader Removal below instead"
if %num% equ 33 call :tip "Matject doesn't make Minecraft act like 'Patched App'. & echo     You have to use Matject every time for applying/switching/removing shaders"
if %num% equ 34 call :tip "If you can make changes in Minecraft app folder without IObit Unlocker, & echo       consider trying out 'Direct write mode' from 'Updates and Debug' in !WHT![S] Matject Settings!RST!"
if %num% equ 35 call :tip "Dynamic and Full restore are the same except Full restore is slow and restores even the unmodified files."
if %num% equ 36 call :tip "You can hide tips in !WHT![S] Matject Settings!RST!"
if %num% equ 37 call :tip "By changing some settings, you can make Matject work with just 2 clicks. Good luck explorer"
if %num% equ 38 call :tip "Matject can update itself automatically when you want"
if %num% equ 39 call :tip "Matject is universal. It will continue to work until Mojang changes how shaders work."
if %num% equ 40 call :tip "In some PCs, IObit Unlocker may cause Windows to crash. & echo       If that happens you should avoid using Matject"
if %num% equ 41 call :tip "Matject has nothing to do with Deferred/Vibrant Visuals/RTX"
if %num% equ 42 call :tip "IObit Unlocker is needed to bypass Minecraft app folder's write protection"
if %num% equ 43 call :tip "Video tutorial: !CYN!youtu.be/dQw4w9WgXcQ!RST!"
if %num% equ 44 call :tip "Try MLYX shader. It looks decent"
if %num% equ 45 call :tip "Some Newb shader variants may cause the game to crash. It's hardware issue"
if %num% equ 46 call :tip "!BLU![2] Manual!RST! mode is intended for shader creators and those who want to try .material.bin files"

set "num="
goto :EOF

:random_0
set /a num=%RANDOM% * 46 / 32768 + 1
goto :EOF

:random_1
set /a num=%RANDOM% %% 46 + 1
goto :EOF

:tip
echo !GRN![TIP]!RST! %~1
goto :EOF