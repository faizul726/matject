:: about.bat // Made by github.com/faizul726
@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k

title About %title%
cls


>nul 2>&1 where mode

if !errorlevel! neq 0 (
    set "x_spacer=  "
) else (
    for /f "tokens=2 delims=:" %%a in ('mode con ^| findstr "Columns"') do set "window_width=%%a"
    set /a window_width=^(!window_width!-20^)/2
    for /L %%I in (1,1,!window_width!) do (set "x_spacer=!x_spacer! ")
)
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
::echo !x_spacer!123456789abcdefghi
echo !x_spacer:~0,-10!!WHT!Matject %version% !GRY!by github.com/faizul726!RST!
echo !x_spacer:~0,-4!!GRY!Released on: Apr 16, 2025!RST!
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
echo !x_spacer:~0,-4!!GRY!Made with !RED!^<3!GRY! in Bangladesh!RST!
echo.
echo !x_spacer:~0,-15!Press any key to read changelog and then go back...
pause >nul
cls
echo !YLW![*] What's new in Matject %version%?!RST!
echo     !GRY!Released on: Apr 16, 2025!RST!
echo.
echo - Added auto version detection for material-updater [preview not supported]
echo - Added direct write mode: Use normal move/delete commands instead of IObit Unlocker [sideloaded installation only]
echo - Added new settings UI for material-updater
echo - Added a brand new loading screen
echo - Added a setting to change the number of materials processed per cycle for full restore
echo - Added a secret game
echo - Reworked full restore logic: It should work better now
echo - Full restore no longer empties backup folder
echo - A warning now will be shown if materials are ntot moved/deleted properly
echo - MATERIALS folder now has to be empty before using auto/manual
echo - Custom path toggle color will be orange if path is invalid
echo - matjectNEXT now supports IObit Unlocker popup reduction
echo - Updated about screen
echo - Fixed non-English text display issues in some places
echo - Fixed an issue with GameData location
echo - Lots of small UI improvements

%backmsg%
:: Copy Pasta
:: !p1!!p1!!p1!!p1!!p1!  !p1!!p1!!p1!
:: !p1!              !p1!
:: !p1!  !p1!  !p1!      !p1!
:: !p1!  !p1!        !p1!
:: !p1!  !p1!!p1!!p1!    !p1!