@echo off
title AI Kids Academy - Launching App...
color 0A
echo ===================================================
echo             AI KIDS ACADEMY IS STARTING            
echo ===================================================
echo.
echo Launching application in Google Chrome...
echo.
cd /d "%~dp0"
flutter run -d chrome
pause
