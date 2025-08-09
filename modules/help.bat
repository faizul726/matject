:: help.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

if not "[%~1]" equ "[]" (
    cls
    echo !GRY!Please make the window full screen to read comfortably.
    echo Press any key go back.!RST!
    echo.
    call :%~1
    echo.
    echo !GRY!Please make the window full screen to read comfortably.
    %backmsg:~9%
)

title %title% Help
cls
echo !WHT!You need help?!RST!
echo Join Bedrock Graphics Discord server and I will try to help you.
echo !CYN!faizul726.github.io/bedrockgraphics-discord!RST!
echo.

echo Make sure to send message in the !YLW!#matject!RST! channel.
echo Also try to provide as much details you can so it's easier for me to help you.
echo.
echo Thanks in advance^^!
%backmsg%

:main-screen
echo !YLW!What does "deprecated" mean?!RST!
echo It means the option still works but will be removed soon in a future update.
echo.

echo !YLW!Why auto and manual methods are deprecated?!RST!
echo Too much manual work. matjectNEXT is way better and stable now.
echo.
echo.


echo !GRN![1] Auto!RST!
echo Auto method of Matject. Press 1 to select.
echo It will ask you for a mcpack or zip file to be inside MCPACKS folder.
echo Then if the shader has subpacks ^(pack settings in global resources of Minecraft^) it will ask you to select a subpack or skip.
echo The subpack names may not make sense due to limitations of Matject.
echo In that case, just select any one.
echo Lastly, it will inject the given shader in Minecraft after confirming.
echo.

echo !BLU![2] Manual!RST!
echo Manual method in Matject. Press 2 to select.
echo Intended to be used by shader creators who only wants to work with raw shader files.
echo It will ask for one or more .material.bin file inside MATERIALS folder.
echo Lastly, it will inject provided materials in Minecraft after confirming.
echo.

echo !RED![3] matjectNEXT!RST!
echo matjectNEXT is the advanced version of Matject. Press 3 to select.
echo Works similar to Minecraft Patch. Instead of manually taking shader/materials from user,
echo it looks for the first activated pack in Global Resources of Minecraft.
echo Then, it copies the materials and ask user to inject.
echo It automatically takes care of many situations including:
echo - Applying shader ^(From having no shader at all^)
echo - Swapping shader ^(Swapping old shader files with new one^)
echo - Removing shader ^(Removes shader entirely^)
echo It can handle following situations:
echo ^> No resources packs activated = It will remove shaders if applied already or do nothing.
echo ^> A shader on activated on top = It will apply that shader or swap if there was any old shader activated.
echo ^> A shader was activated but now non shader on top = It will remove shaders if applied already or do nothing.
echo ^> The shader is deactivated = It will remove the shader
echo It will also consider what settings you applied for the shader in global resources and adjust accordingly.
echo You can set which pack ^(1st, 2nd, 3rd etc.^) it should target in Matject Settings.
echo Note that there are some limitations of matjectNEXT which are shown when you open it for the first time.
echo This may become the default method of Matject in future.
echo.
echo.


echo !WHT![H] I need Help!RST!
echo Shows link to Bedrock Graphics Discord server where you can get help. Press H to select.
echo.

echo !WHT![A] About!RST!
echo Shows Matject credits and changelog. Press A to select.
echo.

echo !WHT![S] Matject Settings!RST!
echo Perhaps the best thing about Matject.
echo You can configure a lot of options to make Matject work the way you like.
echo Press S to select.
echo.

echo !WHT![R] Shader Removal/Tools!RST!
echo Lists options to remove shader and some other tools.
echo It's not possible to fit everything so some options are shown there.
echo Press R to select.
echo.

echo !RED![B] Exit!RST!
echo Do I really have to tell you what it does?
goto :EOF


:tools
echo !YLW![1] Shader Removal / Restore default materials!RST!
echo Use this option to restore original Minecraft files. Press 1 to select.
echo Note that this option won't work as expected if you have already made backup that includes modified files.
echo Refer to option 8 in that case
echo.

echo !YLW![2] Open Minecraft app folder!RST!
echo Opens the folder where Minecraft app itself is stored. Press 2 to select.
echo.

echo !YLW![3] Open Minecraft data folder!RST!
echo Opens the folder where Minecraft stores data files including worlds, texture packs etc. Press 3 to select.
echo.

echo !YLW![4] View Matject on GitHub!RST!
echo Opens the GitHub link of Matject in browser. Press 4 to select.
echo.

echo !YLW![5] Visit jq website!RST!
echo Opens the jq website in browser. "jq" is the tool that is used to get resource pack information for matjectNEXT.
echo Press 5 to select.
echo.

echo !YLW![6] View material-updater on mcbegamerxx954's GitHub!RST!
echo Opens the GitHub link of material-updater in browser. 
echo It is the tool that is used to make outdated shaders compatible with current version of Minecraft.
echo Press 6 to select.
echo.

echo !YLW![7] Create shortcuts!RST!
echo You can use this to create Matject shortcut in the desktop or the start menu.
echo Press 7 to select.
echo.

echo !YLW![8] Refresh/replace backup from ZIP file!RST!
echo Used to replace the backup files of Matject, using a ZIP file as source.
echo The ZIP files can be downloaded from !CYN!mcpebd.github.io/materials!RST!
echo After downloading, put the zip file in Backups folder ^(not materials backup^)
echo Then use the option and it will refresh the backup.
echo This option should be only used if you somehow mess up your Backup
echo.

echo !YLW![9] Reset Global Resource Packs!RST!
echo Deactivates all currently activated resource packs in global resources.
echo Press 9 to select.
echo.

echo !YLW![M] Manifest checker + fix!RST!
echo Checks manifest ^(think of it as pack details^) of all resource packs and find the ones with issue.
echo It doesn't automatically fix but will let you fix by yourself or online.
echo This is ran automatically by default each time you open matjectNEXT.
echo Press M to select.
echo.

if defined debugMode (
    echo !YLW![L] Drop to shell!RST!
    echo Allows you to exit Matject but reserving current variables
    echo Can be helpful when debugging.
    echo Press L to select.
)
goto :EOF

:restore
echo !GRN![1] Dynamic Restore!RST!
echo Fast and recommended option to remove shaders.
echo It will only restore the shader files that were modified in last injection.
echo For example if last injection modified files A,D,E among A,B,C,D,E,F. It will only restore A,D,C excluding B,C,F.
echo Because B,C,F were not modified.
echo - Auto/Manual method will automatically run Dynamic Restore if it detects shader swap. 
echo - matjectNEXT will use this for both shader swap/removal.
echo Press 1 to select.
echo.

echo !RED![2] Full restore!RST!
echo Slow and only recommended to use if Dynamic Restore is not working.
echo It will restore all shader files even the unmodified ones.
echo It is never run automatically.
echo Press 2 to select.
echo.

echo !YLW!What if none are working?!RST!
echo If restore goes fine and Matject doesn't show any error then,
echo there's high chance that it made backup that contains already modified files.
echo Which makes it impossible to restore to original because it will always restore the modified ones.
echo You can be sure by downloading verifyMaterials.bat from !CYN!mcpebd.github.io/materials!RST!
echo - If it says materials don't match then get materials_windows.zip from the same site and use [8] Refresh backup option and run a full restore.
echo - If it says materials are OK and you still can't remove shaders then please report at !CYN!faizul726.github.io/bedrockgraphics-discord!RST!
echo - Or you can either update the game which will remove shaders anyways.
echo   You can reinstall the game without losing data.
goto :EOF


:settingsP1
echo !YLW![1] Default method!RST!
echo Use this to set the method to launch automatically after Matject startup.
echo Useful if you only use one method. You will get about 2 seconds to stop it from launching the selected method.
echo Press 1 to toggle between None, Auto, Manual, matjectNEXT
echo.

echo !YLW![2] Use material-updater!RST!
echo Enables mcbegamerxx954's material-updater to update materials to the desired version.
echo Make sure to select the correct version. For non preview Minecraft, it will select version automatically by default.
echo Press 2 to toggle. When enabled, clicking 2 will open up extra options for it.
echo.

echo !YLW![3] Disable confirmations!RST!
echo Disables confirmations in some places.
echo Enable if you inject shaders on a regular basis.
echo Press 3 to toggle.
echo.

echo !YLW![4] Don't retain old backups!RST!
echo Deletes backup of older Minecraft version instead of renaming when making new backup.
echo Older backups that already exist are likely unaffected.
echo Press 4 to toggle.
echo.

echo !YLW![5] Disable success message!RST!
echo Disables success message that appears in the end of Auto/Manual method and exits directly.
echo Press 5 to toggle.
echo.

echo !YLW![6] Auto open MCPACK after injection!RST!
echo Automatically opens MCPACK file with the associated app after Auto method.
echo If file is MCPACK with ZIP extension it will automatically turn it into a MCPACK and import.
echo Press 6 to toggle.
echo.

echo !YLW![7] Don't open folder automatically!RST!
echo Prevents Matject from opening MCPACKS/MATERIALS folder automatically.
echo Enable if you find it annoying because you put files in before opening Matject.
echo Press 7 to toggle.
echo.

echo !YLW![8] Use for Minecraft Preview!RST!
echo Sets target app to Minecraft Preview instead of the normal one.
echo Enable if you want to use Matject for Minecraft Preview.
echo Note that, Matject Settings is kept and loaded separately for Preview and non-Preview.
echo So, you may need to set some settings again.
echo If Minecraft Preview is not found then Matject will automatically disable this option.
echo Press 8 to toggle.
echo.

echo !YLW![9] Hide tips!RST!
echo Hides Matject tips from various places.
echo Enable if you are smart enough to read B^)
echo Press 9 to toggle.
echo.

echo !YLW![M] Show Matject announcements!RST!
echo Shows Matject announcements from the internet in main screen.
echo Enable if you want to stay up-to-date about Matject :d
echo Press M to toggle.
goto :EOF


:settingsP2
echo !YLW![1] Use custom Minecraft app path!RST!
echo Allows you to set/remove custom Minecraft app path to where Minecraft executable is stored.
echo It can use Get-AppxPackage comannd to get location of currently installed Minecraft or take it from you.
echo When enabled Matject will not use PowerShell at startup to get location. 
echo Which can make Matject start faster on low end PCs.
echo.

echo !YLW![2] Use custom Minecraft data path!RST!
echo Allows you to set/remove custom Minecraft app path to where Minecraft data is stored.
echo Use it if you store Minecraft data somewhere else or use Bedrock Launcher.
echo.

echo !YLW![3] Use custom IObit Unlocker path!RST!
echo Allows you to set/remove custom location of IObit Unlocker.
echo Use if you installed IObit Unlocker somewhere other than %ProgramFiles(x86)%
goto :EOF


:settingsP3
echo !YLW![1] Just sync and exit!RST!
echo Makes Matject exit 5 seconds after matjectNEXT sync is done.
echo Enable if you only care about the sync part.
echo Press 1 to toggle.
echo.

echo !YLW![2] Disable manifest checker!RST!
echo Disables manifest checking of matjectNEXT.
echo Not recommended to enable because JQ the JSON processor will error out for some type of JSON files.
echo And may lead to unexpected behavior.
echo Enable only if it takes a lot of time and you are confident that all manifest.json^(s^) are pure JSON with correct syntax.
echo Press 2 to toggle.
echo.

echo !YLW![3] Target pack in global resource!RST!
echo Allows you to set the target pack number for matjectNEXT like 1st, 2nd, 3rd from top.
echo Can be set upto 9th.
echo Enable if you want to keep shader in any place other than 1st place.
echo Press 3 to set or disable.
echo.

echo !YLW![4] Automatically open Minecraft after sync!RST!
echo Opens Minecraft automatically when matjectNEXT sync is done.
echo Enable if you only care about the sync part.
echo Suggested to be enabled with [1] Just sync and exit
echo Press 4 to toggle.
echo.

echo !YLW![5] Reapply even if old and new pack is the same!RST!
echo Reapplies shader even if old and current resource pack is the same.
echo Enable if you want it to inject the same shader without altering resource packs over and over.
echo Press 5 to toggle.
echo.

echo !YLW![6] Resource packs to scan!RST!
echo Allows you to set resource packs to scan at matjectNEXT startup.
echo Press 6 to toggle between Both, resource_packs, development_resource_packs.
goto :EOF


:settingsP4_01
echo !YLW![1] Check for updates at Matject startup!RST!
echo Enables checking for updates when Matject is started.
echo Enable if you want to stay up-to-date.
echo Press 1 to toggle.
echo.

echo !YLW![2] Disable interruption check!RST!
echo Prevents Matject from prompting you to perform a full restore in the event of a power loss or crash.
echo Not recommended to enable unless it's for testing purpose.
echo Press 2 to toggle.
echo.

echo !YLW![3] Disable material compatibility check!RST!
echo Prevents Matject from checking shader files to confirm compatibility with Windows.
echo Not recommended to enable unless it's for testing purpose.
echo Press 3 to toggle.
echo.

echo !YLW![4] Run IObit Unlocker as admin!RST!
echo Runs the "injection" part of Matject as admin to reduce number of admin permission requests to 1.
echo Matject automatically closes IObit Unlocker message when the injection part is ran as admin.
echo It's still in a bit experimental state.
echo Press 4 to toggle.
echo.

echo !YLW![M] Check for updates manually!RST!
echo Checks for Matject update manually.
echo Press M to select.
echo.

echo !YLW![0] DEBUG MODE!RST!
echo Shows a lot of information when injecting and enables Drop to shell in Tools.
echo Enable if you want to test Matject deeply.
echo Press 0 to toggle.
echo.

echo !YLW![X] Always run Matject as admin!RST!
echo Same thing as right click -^> Run as admin.
echo When enabled Matject will run itself as admin when matject.bat is opened.
echo Also, Matject will automatically close IObit Unlocker popup messages when it is ran as admin.
echo Press X to toggle.
echo.

echo !YLW![R] Reset Matject Settings!RST!
echo Resets Matject settings, deletes vbs helper, jq, material-updater.
echo Press Z to select.
goto :EOF

:settingsP4_02
echo !YLW![1] Disable module verification!RST!
echo Skips SHA256sum verification of Matject modules.
echo Not recommended to enable unless it's for testing purpose.
echo Press 1 to toggle.
echo.

echo !YLW![2] Don't make .bat files read-only!RST!
echo Prevents Matject from making matject.bat, Matject and matjectNEXT modules, exe files read-only.
echo Not recommended to enable unless it's for testing purpose.
echo Files that are already read-only will remain unchanged.
echo Press 2 to toggle.
echo.

echo !YLW![3] Force fallback to PowerShell Expand-Archive!RST!
echo Forces Matject to use PowerShell's Expand-Archive command even if "tar" exists.
echo Enable if tar is not extracting ZIP files properly.
echo Press 3 to toggle.
echo.

echo !YLW![4] Prefer Windows Terminal over Command Prompt for shortcuts!RST!
echo When enabled, Matject will prefer modern Windows Terminal over command prompt for newly created shortcuts.
echo Existing shortcuts are not affected.
echo Press 4 to toggle.
echo.

echo !YLW![5] Direct write mode!RST!
echo When enabled, Matject will use Windows built-in COPY, DEL commands instead of IObit Unlocker.
echo It's still in a bit experimental state.
echo Suggested to enable if you can freely write in the Minecraft app folder.
echo.

echo !YLW![6] Max materials per cycle for full restore!RST!
echo Allows you to set number of materials to be processed in each go for Full Restore up to 75.
echo - Default is !mt_fullRestoreMaterialsPerCycle_default!.
echo - You can increase the number if you find full restore too slow.
echo   But don't increase it too much or IObit Unlocker may not work.
goto :EOF