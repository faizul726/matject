@echo off

cd "%~dp0"
set "off=[ ]"
set "on=[x]"
set "skipIntro=.settings\.skipIntroduction.txt"
set "skipConfirmation=.settings\.skipConfirmation.txt"
set "useAutoAlways=.settings\.useAutoAlways.txt"
set "useManualAlways=.settings\.useManualAlways.txt"

title Settings for Material Replacer

:SETTINGS
if not exist ".settings\" mkdir .settings
cls

if exist "%skipIntro%" (set toggle1=%on%) else (set toggle1=%off%)
if exist "%skipConfirmation%" (set toggle2=%on%) else (set toggle2=%off%)
if exist "%useAutoAlways%" (set toggle3=%on%) else (set toggle3=%off%)
if exist "%useManualAlways%" (set toggle4=%on%) else (set toggle4=%off%)

echo You can change options of Material Replacer here.
echo.

echo %toggle1% 1. Skip introduction
echo %toggle2% 2. Skip confirmation
echo %toggle3% 3. Always use auto method
echo %toggle4% 4. Always use manual method
echo.
echo 5. Exit
echo.

echo Press number to toggle desired settings. [Press O to turn on all, F to turn off all]
choice /c 1234of5 /n

if %errorlevel% equ 1 (
	if "%toggle1%"=="%off%" (
		echo 1 > "%skipIntro%"
		) else (
			del "%skipIntro%"
)
)


if %errorlevel% equ 2 (
	if "%toggle2%"=="%off%" (
		echo 1 > "%skipConfirmation%"
		) else (
			del "%skipConfirmation%"
)
)



if %errorlevel% equ 3 (
	if "%toggle3%" equ "%off%" (
		if exist "%useManualAlways%" del %useManualAlways%
		echo 1 > "%useAutoAlways%"
	) else del "%useAutoAlways%"
)



if %errorlevel% equ 4 (
	if "%toggle4%" equ "%off%" (
		if exist "%useAutoAlways%" del %useAutoAlways%
		echo 1 > "%useManualAlways%"
	) else del "%useManualAlways%"
)



if %errorlevel% equ 5 (
	echo 5
	echo 1 > "%skipIntro%"
	echo 1 > "%skipConfirmation%"
)

if %errorlevel% equ 6 (
	if "%toggle1%" equ "%on%" del "%skipIntro%"
	if "%toggle2%" equ "%on%" del "%skipConfirmation%"
	if "%toggle3%" equ "%on%" del "%useAutoAlways%"
	if "%toggle4%" equ "%on%" del "%useManualAlways%"
)

if %errorlevel% equ 7 goto:EOF

goto SETTINGS