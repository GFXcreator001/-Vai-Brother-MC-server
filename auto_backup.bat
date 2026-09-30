@echo off
title Minecraft Server Auto-Backup
:loop
echo [%time%] Syncing Minecraft World with GitHub...

git add .
git commit -m "Auto-backup: %date% %time%"
git push -u origin main

echo [%time%] Backup successful! Waiting for 15 minutes...
timeout /t 900 /nobreak
goto loop
