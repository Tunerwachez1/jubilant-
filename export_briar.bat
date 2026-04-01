@echo off
setlocal EnableExtensions EnableDelayedExpansion

set OUT=_briar_export
if exist "%OUT%" rmdir /S /Q "%OUT%"
mkdir "%OUT%"

echo [1/5] Copy root files...
for %%F in (settings.gradle build.gradle gradle.properties README.md CONTRIBUTING.md .gitmodules) do (
  if exist "%%F" copy /Y "%%F" "%OUT%\%%F" >nul
)

echo [2/5] Copy module build.gradle...
for %%M in (briar-android briar-core briar-api bramble-android bramble-core bramble-api bramble-java briar-headless) do (
  if exist "%%M\build.gradle" (
    mkdir "%OUT%\%%M" 2>nul
    copy /Y "%%M\build.gradle" "%OUT%\%%M\build.gradle" >nul
  )
)

echo [3/5] Copy src/main, src/test, src/androidTest...
for %%M in (briar-android briar-core briar-api bramble-android bramble-core bramble-api bramble-java briar-headless) do (
  if exist "%%M\src\main" robocopy "%%M\src\main" "%OUT%\%%M\src\main" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /NP >nul
  if exist "%%M\src\test" robocopy "%%M\src\test" "%OUT%\%%M\src\test" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /NP >nul
  if exist "%%M\src\androidTest" robocopy "%%M\src\androidTest" "%OUT%\%%M\src\androidTest" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /NP >nul
)

echo [4/5] Create zip...
if exist "briar_needed.zip" del /F /Q "briar_needed.zip"
tar -a -c -f briar_needed.zip "%OUT%" 2>nul
if errorlevel 1 powershell -NoProfile -Command "Compress-Archive -Path '%OUT%\*' -DestinationPath 'briar_needed.zip' -Force"

echo Done: briar_needed.zip
endlocal
pause