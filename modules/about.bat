:: about.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

title About %title%

>nul 2>&1 where mode

if !errorlevel! neq 0 (
    set "x_spacer=  "
) else (
    set "x_spacer="
    for /f "tokens=2" %%N in ('mode con ^| find "Columns"') do set /a window_width=^(%%N-20^)/2
    if window_width leq 0 (set /a window_width=50)
    rem for /f "tokens=2 delims=:" %%a in ('mode con ^| findstr "Columns"') do set "window_width=%%a"
    rem set /a window_width=^(!window_width!-20^)/2
    for /L %%I in (1,1,!window_width!) do (set "x_spacer=!x_spacer! ")
)
cls
echo.
echo.
echo.
for %%S in (
"!p1!!p1!!p1!!p1!!p1!  !p1!!p1!!p1!"
"!p1!              !p1!"
"!p1!  !p1!  !p1!      !p1!"
"!p1!  !p1!        !p1!"
"!p1!  !p1!!p1!!p1!    !p1!"
) do (echo !x_spacer!%%~S)
echo.
echo.
rem echo !x_spacer!123456789abcdefghi
echo !x_spacer!!x_spacer:~-2!!WHT!Matject %version%!RST!
echo !x_spacer!!x_spacer:~-9!!GRY!-
echo !x_spacer:~0,-6!Made by !CYN!github.com/faizul726!RST!
echo !x_spacer:~0,-6!!GRY!Released on August 09, 2025!RST!
echo.
echo !x_spacer:~0,-3!!WHT!Made possible thanks to:!RST!
echo !x_spacer:~0,-7!!BLU!@mcbegamerxx954!RST!, @jcau8, @Veka0
echo.
echo !x_spacer:~0,-19!Also the creators of !RED!IObit Unlocker!RST!, !GRN!jq!RST!, !BLU!material-updater!RST!
echo.
echo !x_spacer:~0,-17!!GRY!TrngN0786, @Theffyxz, @CallMeSoumya2063, @MrWang2408,
echo !x_spacer:~0,-14!@Sharkitty, @FlaredRoverCodes and many more...!RST!
echo.
echo.
echo !x_spacer:~0,-15!Press any key to read changelog and then go back...
pause >nul
cls
echo !YLW![*] What's new in Matject %version%?!RST!
echo     !GRY!Released on: August 09, 2025!RST!
echo.
echo - Added Matject Exam
echo - Added separate help pages for some places
echo - Added new guiding texts in some places to make it more user friendly
echo - Added target pack number setting for matjectNEXT
echo - Added setting to automatically open Minecraft after matjectNEXT sync
echo - Added setting to reapply the same pack for matjectNEXT
echo - Added setting to scan only development or normal resource packs
echo - Added progress bar for Full restore step 3
echo - Added progress bar for Materials backup
echo - Added Never Gonna Give You Up
echo - Matject is now distributed under a license from YSS Group.
echo - Matject Settings now stores most settings in single text file
echo - matjectNEXT is no longer BETA
echo - Full restore now shows an error if Full Restore didn't go well
echo - Incomplete backup/injection is now handled separately for both editions of Minecraft
echo - Direct write mode now uses COPY and DEL instead of MOVE
echo - Improved Custom Minecraft app path setting
echo - Improved resource pack scanning for matjectNEXT
echo - Improved custom path inputs
echo - Improved Matject startup logic
echo - Moved a lot of extra information under debug mode
echo - More robust file/folder creation in some cases
echo - Fixed 'terminal to use' prompt of initial shortcut creation
echo - Fixed an issue with dynamic restore when run IObit Unlocker as admin is on
echo - Deprecated Auto and Manual method

%backmsg%
:: Copy Pasta
:: !p1!!p1!!p1!!p1!!p1!  !p1!!p1!!p1!
:: !p1!              !p1!
:: !p1!  !p1!  !p1!      !p1!
:: !p1!  !p1!        !p1!
:: !p1!  !p1!!p1!!p1!    !p1!