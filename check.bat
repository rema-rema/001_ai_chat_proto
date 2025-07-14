@echo off
chcp 65001 >nul
echo ====================================
echo AI Chat App Status Check
echo ====================================
echo.

echo [CHECKING] Backend server status...
curl -s http://localhost:5000 >nul 2>&1
if errorlevel 1 (
    echo [X] Backend server is not running (http://localhost:5000)
    set backend_status=STOPPED
) else (
    echo [O] Backend server is running normally
    set backend_status=RUNNING
)

echo.

echo [CHECKING] Frontend server status...
timeout /t 2 /nobreak >nul
curl -s http://localhost:3000 >nul 2>&1
if errorlevel 1 (
    curl -s http://localhost:3001 >nul 2>&1
    if errorlevel 1 (
        echo [X] Frontend server is not running
        set frontend_status=STOPPED
        set frontend_url=NOT_RUNNING
    ) else (
        echo [O] Frontend server is running (port 3001)
        set frontend_status=RUNNING
        set frontend_url=http://localhost:3001
    )
) else (
    echo [O] Frontend server is running (port 3000)
    set frontend_status=RUNNING
    set frontend_url=http://localhost:3000
)

echo.

echo [CHECKING] API connectivity test...
curl -s -X POST http://localhost:5000/api/chat -H "Content-Type: application/json" -d "{\"message\": \"test\", \"history\": []}" >nul 2>&1
if errorlevel 1 (
    echo [X] API connectivity test failed
    set api_status=FAILED
) else (
    echo [O] API connectivity test successful
    set api_status=OK
)

echo.
echo ====================================
echo Status Summary
echo ====================================
echo Backend:   %backend_status%
echo Frontend:  %frontend_status%
echo API:       %api_status%
if defined frontend_url (
    if not "%frontend_url%"=="NOT_RUNNING" (
        echo.
        echo Access URL: %frontend_url%
    )
)
echo ====================================
echo.

if "%backend_status%"=="STOPPED" (
    echo [SOLUTION] Backend is stopped
    echo 1. Check if backend\app.py has errors
    echo 2. Verify OPENAI_API_KEY is set correctly in .env file
    echo 3. Run manually: cd backend ^&^& py app.py
    echo.
)

if "%frontend_status%"=="STOPPED" (
    echo [SOLUTION] Frontend is stopped
    echo 1. Check if npm install completed in client directory
    echo 2. Run manually: cd client ^&^& npm run dev
    echo.
)

if "%api_status%"=="FAILED" (
    echo [SOLUTION] API connectivity failed
    echo 1. Verify OpenAI API key is valid
    echo 2. Check internet connection
    echo 3. Check OpenAI service status
    echo.
)

pause