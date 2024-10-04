@echo off

cd "%~dp0"

::COLORS

set "GRY=[90m"
set "RED=[91m"
set "GRN=[92m"
set "YLW=[93m"
set "WHT=[97m"
set "RST=[0m"

set "off=%GRY%[ ]%RST%"
set "on=%GRN%[x]%RST%"
set "skipIntro=.settings\.skipIntroduction.txt"
set "skipConfirmation=.settings\.skipConfirmation.txt"
set "useAutoAlways=.settings\.useAutoAlways.txt"
set "useManualAlways=.settings\.useManualAlways.txt"
set "disableCooldown=.settings\.disableCooldown.txt"
set "noobMode=.settings\.noobMode.txt"
set "skipBackup=.settings\.skipBackup.txt"
set "skipSuccessMsg=.settings\.skipSuccessMsg.txt"

title Settings for Matject

:SETTINGS
if not exist ".settings\" mkdir .settings
cls

if exist "%skipIntro%" (set toggle1=%on%) else (set toggle1=%off%)
if exist "%skipConfirmation%" (set toggle2=%on%) else (set toggle2=%off%)
if exist "%useAutoAlways%" (set toggle3=%on%) else (set toggle3=%off%)
if exist "%useManualAlways%" (set toggle4=%on%) else (set toggle4=%off%)
if exist "%disableCooldown%" (set toggle5=%on%) else (set toggle5=%off%)
if exist "%noobMode%" (set toggle6=%on%) else (set toggle6=%off%)
if exist "%skipBackup%" (set toggle7=%on%) else (set toggle7=%off%)
if exist "%skipSuccessMsg%" (set toggle8=%on%) else (set toggle8=%off%)

echo %WHT%You can change options of Matject here. %RED%[WIP]%RST%
echo.

echo %YLW%[!] You can play with the toggles for now but it will not work in Matject :P%RST%
echo.

echo Settings folder: "%cd%\.settings"
echo.

echo %toggle1% 1. Skip introduction
echo %toggle2% 2. Skip confirmation
echo %toggle3% 3. Always use auto method
echo %toggle4% 4. Always use manual method
echo %toggle5% 5. Disable cooldown
echo %toggle6% 6. Noob mode
echo %toggle7% 7. Skip backup
echo %toggle8% 8. Skip success message
echo [TOGGLE] 9. Skip backup restore confirmation (pseudo)

echo.
echo %RED%B. Exit%WHT%
echo.

echo %WHT%Press number to toggle desired settings.%RST%
choice /c 12345678fb /n

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
	if "%toggle5%"=="%off%" (
		echo 1 > "%disableCooldown%"
		) else del "%disableCooldown%"
)

if %errorlevel% equ 6 (
	if "%toggle6%"=="%off%" (
		echo 1 > "%noobMode%"
		) else del "%noobMode%"
)

if %errorlevel% equ 7 (
	if "%toggle7%"=="%off%" (
		echo 1 > "%skipBackup%"
		) else del "%skipBackup%"
)

if %errorlevel% equ 8 (
	if "%toggle8%"=="%off%" (
		echo 1 > "%skipSuccessMsg%"
		) else del "%skipSuccessMsg%"
)

if %errorlevel% equ 9 (
	if "%toggle1%" equ "%on%" del "%skipIntro%"
	if "%toggle2%" equ "%on%" del "%skipConfirmation%"
	if "%toggle3%" equ "%on%" del "%useAutoAlways%"
	if "%toggle4%" equ "%on%" del "%useManualAlways%"
	if "%toggle5%" equ "%on%" del "%disableCooldown%"
	if "%toggle6%" equ "%on%" del "%noobMode%"
	if "%toggle7%" equ "%on%" del "%skipBackup%"
	if "%toggle8%" equ "%on%" del "%skipSuccessMsg%"
)

if %errorlevel% equ 10 goto:EOF

goto SETTINGS