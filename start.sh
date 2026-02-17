#!/bin/bash
# ===========================================
# start.sh - Lance l'app Flutter VGV sur WSL
# ===========================================

set -e

PROJECT_DIR="/mnt/c/A/claude/vgv"
FLUTTER_BIN="/mnt/c/A/logiciel/flutter/bin"
CHROME_EXE="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
ENTRYPOINT="lib/main_development.dart"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== VGV Flutter App Launcher ===${NC}"

# 1. Vérifier que Flutter est accessible
echo -e "${YELLOW}[1/4] Vérification de Flutter...${NC}"
if ! cmd.exe /c "flutter --version" > /dev/null 2>&1; then
    echo -e "${RED}Flutter non trouvé ! Vérifiez que $FLUTTER_BIN est dans le PATH Windows.${NC}"
    exit 1
fi
echo -e "${GREEN}  ✓ Flutter OK${NC}"

# 2. Vérifier Chrome
echo -e "${YELLOW}[2/4] Vérification de Chrome...${NC}"
if [ ! -f "$CHROME_EXE" ]; then
    echo -e "${RED}Chrome non trouvé à $CHROME_EXE${NC}"
    exit 1
fi
echo -e "${GREEN}  ✓ Chrome OK${NC}"

# 3. Vérifier le .env Supabase
echo -e "${YELLOW}[3/4] Vérification de la config Supabase...${NC}"
if [ ! -f "$PROJECT_DIR/.env" ]; then
    echo -e "${RED}.env manquant ! Créez $PROJECT_DIR/.env avec SUPABASE_URL et SUPABASE_ANON_KEY${NC}"
    exit 1
fi
if grep -q "SUPABASE_URL=" "$PROJECT_DIR/.env" && grep -q "SUPABASE_ANON_KEY=" "$PROJECT_DIR/.env"; then
    echo -e "${GREEN}  ✓ Supabase .env OK${NC}"
else
    echo -e "${RED}.env incomplet ! Il faut SUPABASE_URL et SUPABASE_ANON_KEY${NC}"
    exit 1
fi

# 4. Lancer l'app
echo -e "${YELLOW}[4/4] Lancement de l'app sur Chrome...${NC}"
cd "$PROJECT_DIR"

# Résoudre les dépendances d'abord
cmd.exe /c "cd /d C:\A\claude\vgv && flutter pub get" 2>&1 | tr -d '\r'

echo ""
echo -e "${GREEN}=== Démarrage de l'app Flutter (dev) ===${NC}"
echo -e "Entrypoint: $ENTRYPOINT"
echo -e "Appuyez sur 'q' pour quitter, 'r' pour hot reload, 'R' pour hot restart"
echo ""

# Lancer Flutter sur Chrome avec le bon entrypoint
cmd.exe /c "cd /d C:\A\claude\vgv && set CHROME_EXECUTABLE=C:\Program Files\Google\Chrome\Application\chrome.exe && flutter run -d chrome -t $ENTRYPOINT"
