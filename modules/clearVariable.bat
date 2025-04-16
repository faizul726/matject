:: clearVariable.bat // Made by github.com/faizul726
@echo off
if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P[?25h & echo on & @cmd /k

if /i "[%~1]" equ "[auto_all]" (
    for %%f in (manifestFound MCPACK MCPACKCOUNT MCPACKDIR MCPACKNAME tmp_input tmp_mcpacknames tmp_subpack_counter tmp_subpacknames selected_mcpack selected_subpack) do (
        set "%%f="
    )
)

if /i "[%~1]" equ "[createIcon_all]" (
    for %%f in (b64_1 b64_2 b64_3 b64_4 b64_5 b64_6 b64_7 b64_8 b64_9 b64_A b64_B b64_C b64_D b64_E b64_F) do (
        set "%%f="
    )    
)

:: I guess I will remove this file later.
:: 20250415