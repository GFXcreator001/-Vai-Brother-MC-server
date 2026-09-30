
@echo off
title Minecraft Server Auto-Backup
cd /d "%~dp0"

:loop
echo.
echo [%date% %time%] Saving Minecraft World...

mcrcon.exe -H 127.0.0.1 -P 25575 -p "123456" "save-all flush"
if errorlevel 1 goto error

echo World saved successfully!
echo Syncing Minecraft World with GitHub...

git add .
if errorlevel 1 goto error

git diff --cached --quiet
if errorlevel 2 goto error
if errorlevel 1 (
    git commit -m "Auto-backup: %date% %time%"
    if errorlevel 1 goto error
) else (
    echo No new changes to commit.
)

git push origin main
if errorlevel 1 goto error

echo [%time%] GitHub Sync Successful!
echo Waiting for 5 minutes...
timeout /t 300 /nobreak
goto loop

:error
echo.
echo [ERROR] Backup failed! Check RCON or GitHub.
echo Retrying in 1 minute...
timeout /t 60 /nobreak
goto loop