:: matjectExamEditionReal.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off
setlocal

cls
echo !YLW!Okay, I am annoyed of people who don't read things properly and mess up how Matject works.!RST!
echo.
echo So, I added Matject exam to keep away that type of people.
echo It maybe annoying but I am sorry.
echo.
echo This is an one time exam. There will be 7 questions.
echo You have to answer each correctly.
echo.
echo Press any key to start the exam...
pause >nul

set "didntRead="
set /a ansCount=0
for /L %%N in (1,1,7) do (
    set "que%%N="
)

:redo
set /a num=%RANDOM% %% 7 + 1
if defined que!num! goto redo
call :que!num!
if !ansCount! lss 7 (goto redo) else goto examComplete

:que1
set que1=true
cls
echo !WHT![?] Does Matject patch Minecraft?!RST!
echo.
echo [Y] Yes    [N] No
choice /c yn /n >nul
if !errorlevel! neq 2 set "didntRead=true"
set /a ansCount+=1
goto :EOF

:que2
set que2=true
cls
echo !WHT![?] Does Matject need unmodified materials/shader files?!RST!
echo.
echo [Y] Yes, for backup and restore
echo [N] No, it can generate automatically
choice /c yn /n >nul
if !errorlevel! neq 1 set "didntRead=true"
set /a ansCount+=1
goto :EOF

:que3
set que3=true
cls
echo !WHT![?] How Matject adds shaders in Minecraft?!RST!
echo.
echo [1] DLL injection
echo [2] Makes Minecraft patched
echo [3] File replacement
echo [4] Deletes RenderDragon
choice /c 1234 /n >nul
if !errorlevel! neq 3 set "didntRead=true"
set /a ansCount+=1
goto :EOF

:que4
set que4=true
cls
echo !WHT![?] How do you disable shaders after injecting?!RST!
echo.
echo [1] Deactivating resource pack
echo [2] Deleting Matject
echo [3] Shaders are permanent and can't be removed
echo [4] Using an option in Matject
choice /c 1234 /n >nul
if !errorlevel! neq 4 set "didntRead=true"
set /a ansCount+=1
goto :EOF

:que5
set que5=true
cls
echo !WHT![?] What is RenderDragon?!RST!
echo.
echo [1] Graphics engine
echo [2] Adds shaders to Minecraft
echo [3] Minecraft mod
echo [4] None of above
choice /c 1234 /n >nul
if !errorlevel! neq 1 set "didntRead=true"
set /a ansCount+=1
goto :EOF

:que6
set que6=true
cls
echo !WHT![?] What should you do if blocks are invisible in game?!RST!
echo.
echo [1] Delete renderer folder and zip again
echo [2] Download shader again and import
echo [3] Use updated version of shader/enable material-updater
echo [4] Update Minecraft/Reinstall Minecraft
choice /c 1234 /n >nul
if !errorlevel! neq 3 set "didntRead=true"
set /a ansCount+=1
goto :EOF

:que7
set que7=true
cls
echo !WHT![?] What is subpack?!RST!
echo.
echo [1] A shader
echo [2] Settings for resource packs
echo [3] Matject feature
echo [4] None of above
choice /c 1234 /n >nul
if !errorlevel! neq 2 set "didntRead=true"
set /a ansCount+=1
goto :EOF

:examComplete
cls
if defined didntRead ( 
    echo !RED!Haha you failed the exam because you didn't answer all questions correctly.
    echo Now it's up to you to figure out what you did wrong. Good luck.!RST!
    timeout 2 >nul
    start https://youtu.be/dQw4w9WgXcQ
    %exitMsg%
) else (
    echo !GRN![*] Exam passed. Have fun using Matject^^!
    echo Matject exam passed on: %date% - %time:~0,-6%>"!ranOnce!"
    echo.
    echo Press any key to continue...
    pause >nul
)

endlocal