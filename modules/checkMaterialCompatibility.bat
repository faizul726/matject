@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k

echo !YLW![*] Checking shader compatibility... !GRY!^(this check may return false positive^)!RST!
for %%f in ("MATERIALS\*.material.bin") do (
    findstr "Direct3D" "%%f" >nul
    if !errorlevel! neq 0 (
        exit /b 1
    )
)

echo [1F[0J!GRN![*] Shader compatibility check OK.!RST!
echo.
exit /b 0