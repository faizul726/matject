:: testCompatibility.bat // Made by github.com/faizul726, licence issued by YSS Group

@if not defined murgi echo [41;97mYou're supposed to open matject.bat, NOT ME.[0m :P & cmd /k
@echo off

cls
echo !YLW![*] Testing compatibility for matjectNEXT!RST!
echo.

echo !YLW![*] Checking if Minecraft data exists...!RST!
echo.
if exist "%gameData%\minecraftpe\options.txt" (echo !GRN![*] Minecraft data folder found.!RST!) else (
    echo !ERR![^^!] Minecraft data not found.!RST!
    echo.

    echo !YLW![^^!]Please open Minecraft at least once if it's from Microsoft Store/Xbox!RST!
    echo     Or, set custom Minecraft data path if you're using something like Bedrock Launcher!RST!
    %exitmsg%
)
echo.

echo !YLW!!BLINK![*] Testing jq...!RST!
echo.

if not exist tmp mkdir tmp

(
echo {
echo   "format_version": 2,
echo   "header": {
echo     "name": "Life is better without RenderDragon",
echo     "description": "hello world",
echo     "uuid": "760c860e-d0dc-4b54-af61-da71a444b2e0",
echo     "version": [
echo       1,
echo       18,
echo       12
echo     ],
echo     "min_engine_version": [
echo       1,
echo       18,
echo       12
echo     ]
echo   },
echo   "modules": [
echo     {
echo       "type": "resources",
echo       "uuid": "0e905c95-886f-4d8a-8897-b0ad8cfad6d7",
echo       "version": [
echo         1,
echo         18,
echo         12
echo       ]
echo     }
echo   ],
echo   "dependencies": [
echo     {
echo       "uuid": "0658f67b-2385-4ec1-9de1-21f0e4c06a7f",
echo       "version": [
echo         1,
echo         18,
echo         12
echo       ]
echo     }
echo   ],
echo   "subpacks": [
echo     {
echo       "folder_name": "subpackone",
echo       "name": "mono",
echo       "memory_tier": 1
echo     },
echo     {
echo       "folder_name": "subpacktwo",
echo       "name": "duo",
echo       "memory_tier": 1
echo     },
echo     {
echo       "folder_name": "subpackthree",
echo       "name": "tri",
echo       "memory_tier": 1
echo     }
echo   ],
echo   "metadata": {
echo     "authors": [
echo       "faizul726"
echo     ],
echo     "url": "faizul726.github.io/matject"
echo   }
echo }
) > tmp\sample-manifest.json

(
echo [
echo   {
echo     "pack_id" : "760c860e-d0dc-4b54-af61-da71a444b2e0",
echo     "subpack" : "subpackthree",
echo     "version" : [ 1, 18, 12 ]
echo   },
echo   {
echo     "pack_id" : "7cb7b257-bb08-416a-b0bd-cf6ddd0d5a04",
echo     "subpack" : "someotherpack",
echo     "version" : [ 1, 18, 30 ]
echo   }
echo ]
) > tmp\sample-globalpacks.json


for /d %%D in (*) do (
    if exist "%%D\sample-manifest.json" (
        for /f "delims=" %%i in ('modules\jq -r ".header.name" "%%D\sample-manifest.json"') do (
            for /f "delims=" %%j in ('modules\jq -r ".header.uuid" "%%D\sample-manifest.json"') do (
                for /f "delims=" %%k in ('modules\jq -cr ".header.version | join(\"\")" "%%D\sample-manifest.json"') do (
                    set "%%j_%%k=%%D"
                )
            )
        )
    )
)


for /f "delims=" %%i in ('modules\jq -r ".[0].pack_id" "tmp\sample-globalpacks.json"') do set "packUuid=%%i"
for /f "delims=" %%a in ('modules\jq -cr ".[0].version | join(\"\")" "tmp\sample-globalpacks.json"') do set packVerInt=%%a
for /f "delims=" %%j in ('modules\jq ".[0] | has(\"subpack\")" "tmp\sample-globalpacks.json"') do set "hasSubpack=%%j"
for /f "delims=" %%i in ('modules\jq -r ".[0].subpack" "tmp\sample-globalpacks.json"') do set "subpackName=%%i"
set packPath=!%packUuid%_%packVerInt%!

for /f "delims=" %%i in ('modules\jq -r ".header.name" "!packpath!\sample-manifest.json"') do set "packName=%%i"
rmdir /q /s ".\tmp"
if "!subpackname!" equ "subpackthree" (echo !GRN![*] Compatibility test OK. Means you can use matjectNEXT.!RST! & echo. & echo matjectNEXT compatibility test passed. [%date% // %time:~0,-6%]>".settings\compatibilityTestOK.txt" && pause)
echo.