@echo off
chcp 65001 >nul
echo ====================================
echo OpenAI API Key Setup
echo ====================================
echo.

set /p OPENAI_KEY="Enter your OpenAI API key: "

if "%OPENAI_KEY%"=="" (
    echo [ERROR] API key cannot be empty
    pause
    exit /b 1
)

echo OPENAI_API_KEY=%OPENAI_KEY%> .env.local
echo PORT=5000>> .env.local
echo FLASK_ENV=development>> .env.local

echo [SUCCESS] API key has been saved to .env.local
echo.
echo Now run start.bat to start the application
pause