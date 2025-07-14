@echo off
chcp 65001 >nul
echo ====================================
echo AI Chat App Startup Script
echo ====================================
echo.

if not exist ".env" (
    echo [ERROR] .env file not found
    echo Copy .env.example to .env and set your OpenAI API key
    pause
    exit /b 1
)

echo [INFO] Environment file check - OK
echo.

echo [START] Installing backend dependencies...
cd backend
pip install -r requirements.txt >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Backend dependency installation failed
    pause
    exit /b 1
)
echo [DONE] Backend dependencies installed
cd ..

echo [START] Installing frontend dependencies...
cd client
npm install >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Frontend dependency installation failed
    pause
    exit /b 1
)
echo [DONE] Frontend dependencies installed
cd ..

echo.
echo ====================================
echo Starting servers...
echo ====================================

echo [START] Starting backend server...
echo [DEBUG] Checking OPENAI_API_KEY...
set "API_KEY_TEST=%OPENAI_API_KEY%"
if not defined OPENAI_API_KEY (
    echo [ERROR] OPENAI_API_KEY environment variable is not set
    echo Please run set_env_variable.bat first
    pause
    exit /b 1
)
if "%API_KEY_TEST%"=="" (
    echo [ERROR] OPENAI_API_KEY environment variable is empty
    echo Please run set_env_variable.bat first
    pause
    exit /b 1
)
echo [DEBUG] OPENAI_API_KEY is set and not empty

start "AI Chat Backend" /min cmd /c "set OPENAI_API_KEY=%OPENAI_API_KEY% && cd backend && py app.py"

timeout /t 3 /nobreak >nul

echo [START] Starting frontend server...
start "AI Chat Frontend" /min cmd /c "cd client && npm run dev"

echo [INFO] Waiting for servers to initialize...
timeout /t 8 /nobreak >nul

echo.
echo ====================================
echo Starting servers in parallel...
echo ====================================
echo.
echo Frontend: http://localhost:3000
echo Backend:   http://localhost:5000
echo.
echo Please access http://localhost:3000 in your browser
echo.
echo To stop servers, press Ctrl+C in the opened command prompts
echo.
pause