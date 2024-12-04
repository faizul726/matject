@echo off
if not defined murgi echo [41;97mYou can't open me directly[0m :P & cmd /k

echo !YLW![*] Checking shader compatibility... !GRY!^(this check may return false positive^)!RST!
echo.
for %%f in (MATERIALS\*.material.bin) do (
    findstr "Direct3D" "%%f" >nul
    if !errorlevel! neq 0 (
        exit /b 1
    )
)

echo !GRN![*] Shader compatibility check OK.!RST!
echo.
exit /b 0