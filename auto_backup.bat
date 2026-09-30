@echo off
title Minecraft Auto Backup
cd /d "%~dp0"

set "RCON_HOST=127.0.0.1"
set "RCON_PORT=25575"
set "RCON_PASSWORD_FILE=rcon_password.txt"
set "BACKUP_INTERVAL=300"

if not exist "mcrcon.exe" (
    echo [ERROR] mcrcon.exe not found.
    pause
    exit /b 1
)

if not exist "%RCON_PASSWORD_FILE%" (
    echo [ERROR] rcon_password.txt not found.
    pause
    exit /b 1
)

set /p RCON_PASSWORD=<"%RCON_PASSWORD_FILE%"

:loop
echo.
echo ========================================
echo [%date% %time%] Starting backup cycle
echo ========================================

echo Saving Minecraft World...
mcrcon.exe -H %RCON_HOST% -P %RCON_PORT% -p "%RCON_PASSWORD%" "save-all flush"

if errorlevel 1 (
    echo [ERROR] RCON save failed.
    echo Retrying in 1 minute...
    timeout /t 60 /nobreak
    goto loop
)

echo World saved successfully.
echo Syncing changed files with GitHub...

git add .
if errorlevel 1 goto git_error

git diff --cached --quiet
if errorlevel 2 goto git_error

if errorlevel 1 (
    git commit -m "Auto-backup: %date% %time%"
    if errorlevel 1 goto git_error

    git push origin main
    if errorlevel 1 goto git_error

    echo [%time%] GitHub Sync Successful!
) else (
    echo No changes to commit.
)

echo Waiting 5 minutes...
timeout /t %BACKUP_INTERVAL% /nobreak
goto loop

:git_error
echo.
echo [ERROR] GitHub backup failed.
echo Retrying in 1 minute...
timeout /t 60 /nobreak
goto loop
