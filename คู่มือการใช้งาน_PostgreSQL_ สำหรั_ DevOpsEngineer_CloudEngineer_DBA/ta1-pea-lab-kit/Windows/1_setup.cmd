@echo off
setlocal
echo ==== PEA Lab Kit setup (ta1) v8 ====
set "SRC=%~dp0..\lab-files\"
set "S=%USERPROFILE%\.ssh"
set "D=%USERPROFILE%\.ssh\pea-lab"
set "C=%USERPROFILE%\.ssh\config"
echo Kit folder : %SRC%
echo SSH folder : %S%
if not exist "%SRC%id_lab" (
  echo [ERROR] lab-files\id_lab not found
  echo         Please EXTRACT the zip first ^(Right-click ^> Extract All^), then run 1_setup.cmd again.
  goto :fail
)
if not exist "%S%" mkdir "%S%"
if not exist "%D%" mkdir "%D%"
if not exist "%D%" ( echo [ERROR] cannot create %D% & goto :fail )
echo [1/4] Copy key and config ...
copy /Y "%SRC%id_lab" "%D%\id_lab" >nul || goto :fail
copy /Y "%SRC%id_lab.pub" "%D%\id_lab.pub" >nul || goto :fail
copy /Y "%SRC%config" "%D%\config" >nul || goto :fail
copy /Y "%SRC%known_hosts" "%D%\known_hosts" >nul || goto :fail
echo [2/4] Fix key permission ...
icacls "%D%\id_lab" /inheritance:r /grant:r "%USERNAME%:F" >nul || goto :fail
echo [3/4] Link ~/.ssh/config ...
if exist "%C%" (
  findstr /X /C:"Include pea-lab/config" "%C%" >nul && (
    echo       already linked, skip
  ) || (
    copy /Y "%C%" "%C%.bak" >nul
    (echo Include pea-lab/config& type "%C%.bak") > "%C%"
    echo       backup saved: %C%.bak
  )
) else (
  echo Include pea-lab/config> "%C%"
  echo created> "%D%\.created-config"
  echo       new config created
)
echo [4/4] Verify ...
ssh -G lab-pg1 | findstr /B /C:"hostname ta1-pg1" >nul && (
  echo.
  echo SUCCESS. Next: run 2_check.cmd  or type:  ssh lab-pg1
) || (
  echo [ERROR] ssh does not see the PEA Lab config. Please send a screenshot to the instructor.
  goto :fail
)
echo.
pause
exit /b 0
:fail
echo.
echo SETUP FAILED - please send a screenshot of this window to the instructor.
pause
exit /b 1
