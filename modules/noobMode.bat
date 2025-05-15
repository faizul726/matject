:: noobMode.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

cls
echo.
echo Welcome to Matject %version%
echo.
echo !WHT!What do you want to do?
echo.
echo.
echo  .=====================.
echo [1]    Apply shader    ^|
echo  '====================='
echo.
echo  .=====================.
echo [2] Change/swap shader ^|
echo  '====================-'
echo.
echo  _=====================_
echo [3]   Remove shader    ^|
echo  '====================='
echo.
echo.
echo !GRY![P] Pro mode    [S] Matject Settings    [B] Exit
echo.
echo !YLW!Press corresponding key to select an option...!RST!

choice /c 123psb /n >nul

goto noob_%errorlevel% 

:noob_1
:noob_2
:noob_3
:noob_4
:noob_5
:noob_6
