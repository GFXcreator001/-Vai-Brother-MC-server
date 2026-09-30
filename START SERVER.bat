@echo off
title Minecraft Server - START
cd /d "%~dp0"

echo ========================================
echo   Minecraft Server - START
echo ========================================
echo.

echo [1/3] Getting latest files from GitHub...
git pull --ff-only origin main
if errorlevel 1 (
    echo.
    echo [ERROR] GitHub update failed.
    echo Server will NOT start.
    echo Please resolve the Git issue first.
    pause
    exit /b 1
)

echo.
echo [2/3] Starting Minecraft Server...
start "Minecraft Server" cmd /k ""%~dp0server.bat""

echo Waiting for server startup...
timeout /t 15 /nobreak >nul

echo.
echo [3/3] Starting automatic backup...
start "Minecraft Auto Backup" cmd /k ""%~dp0auto_backup.bat""

echo.
echo ========================================
echo   Server + Auto Backup started!
echo ========================================
echo.
pause
