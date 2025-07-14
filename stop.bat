@echo off
chcp 65001 >nul
echo ====================================
echo AI Chat App Stop Script
echo ====================================
echo.

echo [RUNNING] Stopping server processes...

echo [INFO] Stopping Python processes...
taskkill /f /im python.exe >nul 2>&1
taskkill /f /im py.exe >nul 2>&1

echo [INFO] Stopping Node.js processes...
taskkill /f /im node.exe >nul 2>&1

echo [INFO] Stopping processes by window title...
taskkill /f /fi "WindowTitle eq AI Chat Backend*" >nul 2>&1
taskkill /f /fi "WindowTitle eq AI Chat Frontend*" >nul 2>&1

echo [INFO] Stopping processes by port...
for /f "tokens=5" %%a in ('netstat -aon ^| find ":5000" ^| find "LISTENING"') do taskkill /f /pid %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -aon ^| find ":3000" ^| find "LISTENING"') do taskkill /f /pid %%a >nul 2>&1

echo [INFO] Force stopping any remaining Python/Node processes...
taskkill /f /im python.exe >nul 2>&1
taskkill /f /im py.exe >nul 2>&1
taskkill /f /im node.exe >nul 2>&1

echo [INFO] Waiting for processes to terminate...
timeout /t 2 /nobreak >nul

echo [INFO] Verifying all processes stopped...
netstat -ano | find ":5000" >nul 2>&1
if not errorlevel 1 (
    echo [WARNING] Port 5000 still in use
) else (
    echo [OK] Port 5000 is now free
)

netstat -ano | find ":3000" >nul 2>&1
if not errorlevel 1 (
    echo [WARNING] Port 3000 still in use
) else (
    echo [OK] Port 3000 is now free
)

echo [DONE] All servers stopped
echo.
pause