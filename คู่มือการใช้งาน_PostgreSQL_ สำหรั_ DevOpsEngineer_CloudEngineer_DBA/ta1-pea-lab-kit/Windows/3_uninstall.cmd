@echo off
setlocal
echo ==== PEA Lab Kit uninstall (ta1) - restore your SSH settings ====
set "S=%USERPROFILE%\.ssh"
set "D=%USERPROFILE%\.ssh\pea-lab"
set "C=%USERPROFILE%\.ssh\config"
set "T=%USERPROFILE%\.ssh\_trash"
echo This will:
echo   - remove the line "Include pea-lab/config" from %C%
echo   - move the folder %D% to the Recycle Bin
echo Your own keys and other SSH settings are NOT touched.
choice /C YN /M "Continue"
if errorlevel 2 ( echo Cancelled. & pause & exit /b 0 )
echo [1/3] Remove PEA Lab line from config ...
if exist "%C%" (
  findstr /V /X /C:"Include pea-lab/config" "%C%" > "%C%.peatmp"
  move /Y "%C%.peatmp" "%C%" >nul
  echo       done
) else (
  echo       no config file, skip
)
echo [2/3] Tidy up ...
if exist "%D%\.created-config" (
  for %%A in ("%C%") do if %%~zA==0 (
    call :recycle_file "%C%"
    echo       config was created by the Kit and is now empty: moved to Recycle Bin
  )
)
if exist "%C%.bak" (
  fc /b "%C%" "%C%.bak" >nul 2>&1 && (
    call :recycle_file "%C%.bak"
    echo       config is identical to config.bak: config.bak moved to Recycle Bin
  ) || (
    echo       config.bak kept ^(your config changed during the course^): %C%.bak
  )
)
echo [3/3] Move PEA Lab folder to Recycle Bin ...
if exist "%D%" call :recycle_dir "%D%"
if exist "%D%" ( echo [WARN] could not move %D% - please delete it manually ) else ( echo       done )
ssh -G lab-pg1 2>nul | findstr /B /C:"hostname ta1-pg1" >nul && (
  echo [WARN] ssh still sees PEA Lab config. Please send a screenshot to the instructor.
) || (
  echo.
  echo UNINSTALL COMPLETE. Your SSH settings are back to normal.
)
echo.
pause
exit /b 0

:recycle_file
powershell -NoProfile -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile('%~1','OnlyErrorDialogs','SendToRecycleBin')" >nul 2>&1
if not exist "%~1" exit /b 0
if not exist "%T%" mkdir "%T%"
move /Y "%~1" "%T%\" >nul
exit /b 0

:recycle_dir
powershell -NoProfile -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory('%~1','OnlyErrorDialogs','SendToRecycleBin')" >nul 2>&1
if not exist "%~1" exit /b 0
if not exist "%T%" mkdir "%T%"
move /Y "%~1" "%T%\pea-lab-%RANDOM%" >nul
exit /b 0
