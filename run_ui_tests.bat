@echo off
echo ==========================================
echo Lancement de l'emulateur Android Studio (AVD)...
echo ==========================================

:: Remplacez "Pixel_API_35" par le nom exact de votre AVD (sans espaces)
:: Pour lister vos AVD, ouvrez un terminal et tapez: emulator -list-avds
set AVD_NAME=Pixel_API_35

echo Demarrage de l'emulateur %AVD_NAME%...
start "" "%LOCALAPPDATA%\Android\Sdk\emulator\emulator.exe" -avd %AVD_NAME%

echo Attente du demarrage de l'emulateur (pause de 20s)...
timeout /T 20 /NOBREAK

echo.
echo ==========================================
echo Lancement des tests...
echo ==========================================
echo.
call flutter test integration_test/demo_log_test.dart

pause