@echo off
title Minecraft Server - STOP
cd /d "%~dp0"

echo ========================================
echo   Minecraft Server - STOP
echo ========================================
echo.

if not exist "mcrcon.exe" (
    echo [ERROR] mcrcon.exe not found.
    pause
    exit /b 1
)

if not exist "rcon_password.txt" (
    echo [ERROR] rcon_password.txt not found.
    pause
    exit /b 1
)

set /p RCON_PASSWORD=<"rcon_password.txt"

echo [1/5] Stopping automatic backup...
taskkill /FI "WINDOWTITLE eq Minecraft Auto Backup" /T /F >nul 2>&1
timeout /t 2 /nobreak >nul

echo [2/5] Saving Minecraft World...
mcrcon.exe -H 127.0.0.1 -P 25575 -p "%RCON_PASSWORD%" "save-all flush"

if errorlevel 1 (
    echo [ERROR] RCON save failed.
    echo The server may already be offline.
    pause
    exit /b 1
)

echo.
echo [3/5] Stopping Minecraft Server...
mcrcon.exe -H 127.0.0.1 -P 25575 -p "%RCON_PASSWORD%" "stop"

if errorlevel 1 (
    echo [WARNING] Stop command could not be confirmed.
)

echo Waiting for server to shut down...
timeout /t 15 /nobreak >nul

echo.
echo [4/5] Creating final backup...
git add .
if errorlevel 1 goto git_error

git diff --cached --quiet
if errorlevel 2 goto git_error

if errorlevel 1 (
    git commit -m "Final backup: %date% %time%"
    if errorlevel 1 goto git_error
) else (
    echo No new changes to commit.
)

echo.
echo [5/5] Uploading final backup to GitHub...
git push origin main
if errorlevel 1 goto git_error

echo.
echo ========================================
echo   FINAL BACKUP UPLOADED SUCCESSFULLY
echo   Server is now OFF.
echo ========================================
pause
exit /b 0

:git_error
echo.
echo [ERROR] Final GitHub backup failed.
echo DO NOT delete or move this server folder.
echo Fix the GitHub issue, then run the final backup again.
pause
exit /b 1
