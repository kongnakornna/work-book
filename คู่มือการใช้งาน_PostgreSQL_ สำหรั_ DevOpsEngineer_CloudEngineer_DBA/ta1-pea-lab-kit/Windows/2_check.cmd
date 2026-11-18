@echo off
if not exist "%USERPROFILE%\.ssh\pea-lab\id_lab" (
  echo [STOP] Setup has not been completed. Please run 1_setup.cmd first.
  pause
  exit /b 1
)
set "L=%~dp0check-result.txt"
set "B=pea-bastion1"
echo ==== PEA Lab connectivity check (ta1) v8 - Windows ==== > "%L%"
echo [1] OpenSSH version >> "%L%"
ssh -V >> "%L%" 2>&1
echo [2] TCP 22 to Bastion 1 and 2 (expected: True True) >> "%L%"
powershell -NoProfile -Command "Test-NetConnection 146.190.6.43 -Port 22 -InformationLevel Quiet; Test-NetConnection 159.89.209.96 -Port 22 -InformationLevel Quiet" >> "%L%" 2>&1
echo [3] lab-pg1 / lab-pg2 / lab-infra (default path, expected: OK ...) >> "%L%"
ssh -o BatchMode=yes lab-pg1 "echo OK $(hostname) $(whoami) sudo=$(sudo -n true 2>/dev/null && echo yes || echo no)" >> "%L%" 2>&1
ssh -o BatchMode=yes lab-pg2 "echo OK $(hostname)" >> "%L%" 2>&1
ssh -o BatchMode=yes lab-infra "echo OK $(hostname)" >> "%L%" 2>&1
echo [4] alt-pg1 (backup path, expected: OK ...) >> "%L%"
ssh -o BatchMode=yes alt-pg1 "echo OK $(hostname)" >> "%L%" 2>&1
echo [5] Shell on Bastion must be refused (expected: This account is currently not available) >> "%L%"
ssh -o BatchMode=yes %B% "echo SHOULD-NOT-PRINT" >> "%L%" 2>&1
echo [6] Jump to a VM not in your list must fail (expected: stdio forwarding failed) >> "%L%"
ssh -o BatchMode=yes -W 10.104.0.2:22 %B% < nul >> "%L%" 2>&1
echo [7] Ports for pgAdmin and ssh lab-tunnel (expected: OK on every line, never BLOCKED) >> "%L%"
for %%T in (ta1-pg1:5432 ta1-pg2:5432 ta1-infra:6432 ta1-infra:5000 ta1-infra:5001 ta1-infra:3000 ta1-infra:9090 ta1-infra:8025) do call :portcheck %%T
echo ==== done ==== >> "%L%"
type "%L%"
echo.
echo Result saved to: %L%
pause
exit /b 0

:portcheck
rem Ask the Bastion to open host:port. "refused" = allowed but nothing listens yet (normal before the lab installs it)
set "E=%TEMP%\pea-check-%RANDOM%.txt"
ssh -o BatchMode=yes -o LogLevel=VERBOSE -W %1 %B% < nul >nul 2> "%E%"
if not errorlevel 1 (
  echo %1 OK>> "%L%"
  goto :pc_end
)
findstr /I /C:"refused" "%E%" >nul && (
  echo %1 OK ^(allowed, service not running yet^)>> "%L%"
  goto :pc_end
)
findstr /I /C:"prohibited" "%E%" >nul && (
  echo %1 BLOCKED by Bastion>> "%L%"
  goto :pc_end
)
echo %1 FAILED:>> "%L%"
findstr /I /C:"open failed" /C:"forwarding failed" /C:"denied" /C:"timed out" /C:"resolve" "%E%" >> "%L%"
:pc_end
del /q "%E%" 2>nul
exit /b 0
