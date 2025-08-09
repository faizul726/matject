:: matjectExamEditionReal.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off
setlocal

cls
echo !YLW!Okay, I am annoyed of people who don't read things properly and mess up how Matject works.!RST!
echo.
echo So, I added Matject exam to keep away that type of people.
echo It maybe annoying but I am sorry.
echo Answers can be found in the GitHub page !CYN!github.com/faizul726/matject!RST!. Although, you have to do some research yourself.
echo.
echo This is an one time exam. There will be 4 questions.
echo You have to answer each correctly.
echo.
echo Press any key to start the exam...
pause >nul

if not defined letters (
    echo Something went wrong.
    echo Press any key to exit...
    pause >nul
    exit 1
)
call "modules\createTarget" folder "%letters:~0,-15%"
del /q /f "%letters:~0,-15%\*.ini" >nul 2>&1

set "didntRead="
set /a ansCount=1
for /L %%N in (1,1,4) do (
    set "que%%N="
)

:redo
set /a num=%RANDOM% %% 4 + 1
if defined que!num! goto redo
cls
echo !WHT![*] Question !ansCount! / 4!RST!
echo.
call :que!num!
if !ansCount! leq 4 (goto redo) else (goto examComplete)

:que1
set que1=true
echo !WHT![?] Does Matject need Minecraft to have original materials before it can be used?!RST!
echo.
echo [Y] Yes    [N] No
choice /c yn /n >nul
if !errorlevel! neq 1 set "didntRead=true"
set /a ansCount+=1
goto :EOF

:que2
set que2=true
echo !WHT![?] What shaders do Matject exclusively support?!RST!
echo.
echo [1] HAL shaders
echo [2] RenderDragon shaders
echo [3] Vibrant Visuals
echo [4] RTX shaders
choice /c 1234 /n >nul
if !errorlevel! neq 2 set "didntRead=true"
set /a ansCount+=1
goto :EOF

:que3
set que3=true
echo !WHT![?] Does Matject patch Minecraft?!RST!
echo.
echo [Y] Yes    [N] No
choice /c yn /n >nul
if !errorlevel! neq 2 set "didntRead=true"
set /a ansCount+=1
goto :EOF

:que4
set que4=true
echo !WHT![?] How do you remove shaders after injecting?!RST!
echo.
echo [1] Deactive shader resource pack
echo [2] Delete Matject
echo [3] Shaders are permanent and can't be removed
echo [4] Use an option in Matject
choice /c 1234 /n >nul
if !errorlevel! neq 4 set "didntRead=true"
set /a ansCount+=1
goto :EOF

:examComplete
cls
if defined didntRead ( 
    echo !RED!Haha you failed the exam because you didn't answer all questions correctly.!RST!
    echo Please read the GitHub page !CYN!github.com/faizul726/matject!RST! for answers.
    echo.
    echo If you need help join Bedrock Graphics Discord server and send message in !YLW!#matject!RST! channel.
    echo !CYN!faizul726.github.io/bedrockgraphics-discord!RST!
    echo !GRY!Note: I won't answer the Matject questions. Join ONLY if you need help with something else.!RST!
    timeout 2 >nul
    start https://youtu.be/dQw4w9WgXcQ
    %exitMsg%
) else (
    echo !GRN![*] Exam passed. Have fun using Matject^^!!RST!
    set "randomizer=%random%%random%%random%"
    echo !randomizer!>"!ranOnce!"
    echo.>"%letters%_!randomizer!.ini"
    set "randomizer="
    echo.
    echo Press any key to continue...
    pause >nul
)

endlocal