@echo off
echo ==========================================
echo Nettoyage et Preparation Flutter...
echo ==========================================
:: On s'assure que les anciens builds foireux sont effaces
call flutter clean
call flutter pub get

echo ==========================================
echo Lancement de l'emulateur Android...
echo ==========================================
set EMULATOR_PATH="C:\Users\chevallier\AppData\Local\Android\Sdk\emulator\emulator.exe"
set AVD_NAME="Medium_Phone_API_35"

:: Lance l'émulateur avec -wipe-data pour eviter les erreurs de cache disque
start "" %EMULATOR_PATH% -avd %AVD_NAME% -wipe-data

echo Attente que l'emulateur soit detecte par ADB...
:wait_emulator
timeout /t 5 /nobreak > NUL
adb devices | findstr "device$" > NUL
if %errorlevel% neq 0 (
    echo En attente du demarrage...
    goto wait_emulator
)
echo Emulateur detecte !

echo ==========================================
echo Generation de l'APK (Correction erreur No APK found)
echo ==========================================
:: On force le build pour verifier que Gradle produit bien le fichier
call flutter build apk --debug

echo ==========================================
echo Lancement des tests d'integration...
echo ==========================================
:: On utilise l'APK compilé manuellement pour éviter le bug "No APK found"
call flutter test integration_test/demo_log_test.dart -d emulator-5554 --use-application-binary build\app\outputs\flutter-apk\app-debug.apk

echo ==========================================
echo Tests termines. Fermeture de l'emulateur...
echo ==========================================
adb -s emulator-5554 emu kill

echo Fini !
pause