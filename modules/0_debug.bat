@echo off
:: for testing purpose only

:: 1 Add unlockedWindowsApps.txt
:: 2 Make all folders
:: 3 Copy logs
:: 4 matject tree
:: 5 origin mats size
:: 6 bkp mats size

pushd ..
if [%~n0] equ [1_debug] echo.>.settings\unlockedWindowsApps.txt & echo Debug #1
if [%~n0] equ [2_debug] for %%d in (.settings Backups logs MATERIALS MCPACKS tmp) do (mkdir %%d) & echo Debug #2
if [%~n0] equ [3_debug] for %%f in (.restoreList lastMCPACK lastPack .restoreListPreview lastMCPACKPreview lastPackPreview) do (copy /d ".settings\%%f.log" "%USERPROFILE%\Desktop") & echo Debug #3
if [%~n0] equ [4_debug] tree /f /a >"%USERPROFILE%\Desktop\matject_tree_%date:/=-%.txt" & echo Debug #4
cmd

