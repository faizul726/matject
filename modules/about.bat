@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

title About %title%
cls

echo !YLW!What's new in %title%?!RST!
echo !YLW!Released on: Nov 6 2024!RST!
echo - Fixed dynamic restore missing out some files
echo - Added material-updater support                                              
echo - Added Help (but not helpful)                                                !p1!!p1!!p1!!p1!!p1!  !p1!!p1!!p1!
echo - Added settings                                                              !p1!              !p1!
echo - Added date for backup                                                       !p1!  !p1!  !p1!      !p1!
echo - Added the ability to open MCPACK automatically after injection              !p1!  !p1!        !p1!
echo - Added first run message                                                     !p1!  !p1!!p1!!p1!    !p1!
echo - Made backup mandatory                                                       
echo - Improved home screen
echo - Only accept .material.bin file                                                        
echo - Removed openMinecraftFolder.bat and added as a separate option

echo.

echo Matject is a material replacer for Minecraft Bedrock Edition.
echo It allows user to use shaders easily without going through the hassle of making backups and placing files.
echo.
echo Thanks to those who made Matject better:
echo !WHT!YSS Community, Newb Community, amg_the_imposter, @mcbegamerxx954, @MrWang2408, flaredrover
echo @CallMeSoumya2063, @anonymous_user8 and many more...!RST!
echo.
echo Also thanks to the creators of !BLU!IObit Unlocker!RST!, !BLU!material-updater!RST!

%backmsg%