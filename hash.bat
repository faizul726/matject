@echo off
setlocal enabledelayedexpansion

for %%B in ("modules\*.bat") do (
    for /f "tokens=*" %%A in ('certutil -hashfile "%%B" SHA256 ^| findstr /v ":"') do (
        set hash=%%A
        set hashkey=!hashkey! !hash:~56,8!-%%~nB
    )
)
for %%B in ("modules\matjectNEXT\*.bat") do (
    for /f "tokens=*" %%A in ('certutil -hashfile "%%B" SHA256 ^| findstr /v ":"') do (
        set hash=%%A
        set hashkey=!hashkey! !hash:~56,8!-matjectNEXT\%%~nB
    )
)
echo %hashkey:~18%|clip
endlocal