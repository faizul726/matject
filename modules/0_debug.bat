:: for testing purpose only
@pushd ..
@if [%~n0] equ [1_debug] echo.>.settings\unlockedWindowsApps.txt & echo Debug #1
@if [%~n0] equ [2_debug] for %%d in (.settings Backups logs MATERIALS MCPACK tmp) do mkdir %%d & echo Debug #2
@if [%~n0] equ [3_debug] for %%f in (.restoreList.log lastPack.log) do copy %%f "%USERPROFILE%\Desktop" & echo Debug #3
@if [%~n0] equ [4_debug] tree /f /a >"%USERPROFILE%\Desktop\matject_tree_%date%.txt" & echo Debug #4
@cmd

