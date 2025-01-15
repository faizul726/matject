@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
setlocal DISABLEDELAYEDEXPANSION
:: Disable delayed expansion to prevent arbitrary code execution
:: Although I couldn't find a way to execute remote code but still it's better to be safe.


for /f "delims=" %%o in ('curl -fSs %githubChangelogLink:changelog=announcement% 2^>^&1') do (echo [1F[0J%GRN%[Announcement]%RST% %%o)

setlocal enabledelayedexpansion