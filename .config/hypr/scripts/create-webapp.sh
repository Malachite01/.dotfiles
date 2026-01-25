#!/bin/bash

set -e

# Vérifier les dépendances
if ! command -v gum &>/dev/null; then
    echo "Installer gum:   sudo dnf install gum"
    exit 1
fi

if [ "$#" -lt 3 ]; then
  echo -e "\e[32mCréons une web app pour Hyprland!\n\e[0m"
  APP_NAME=$(gum input --prompt "Nom> " --placeholder "Mon application web")
  APP_URL=$(gum input --prompt "URL> " --placeholder "https://example.com")
  ICON_REF=$(gum input --prompt "Icône (chemin)> " --placeholder "/usr/share/icons/Papirus/64x64/apps/youtube.svg")
else
  APP_NAME="$1"
  APP_URL="$2"
  ICON_REF="$3"
fi

# Créer les répertoires nécessaires
ICON_DIR="$HOME/.local/share/applications/icons"
mkdir -p "$ICON_DIR"

# Gérer l'icône
if [[ $ICON_REF =~ ^https?: // ]]; then
  ICON_PATH="$ICON_DIR/$APP_NAME.png"
  echo "Téléchargement de l'icône..."
  if curl -sL -o "$ICON_PATH" "$ICON_REF"; then
    echo "✓ Icône téléchargée"
  else
    echo "✗ Échec du téléchargement"
    exit 1
  fi
else
  ICON_PATH="$ICON_REF"
  if [ !  -f "$ICON_PATH" ]; then
    echo "✗ Icône non trouvée:  $ICON_PATH"
    exit 1
  fi
  echo "✓ Icône trouvée:  $ICON_PATH"
fi

# Créer un nom de fichier safe
SAFE_NAME=$(echo "$APP_NAME" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')

# Créer le fichier . desktop
DESKTOP_FILE="$HOME/.local/share/applications/webapp-$SAFE_NAME. desktop"

# Pour Flatpak Waterfox, utiliser la commande complète
cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Comment=Application web: $APP_URL
Exec=flatpak run net.waterfox.waterfox --new-window %u $APP_URL
Icon=$ICON_PATH
Terminal=false
StartupNotify=true
Categories=Network;WebApp;
StartupWMClass=Navigator
MimeType=text/html;text/xml;application/xhtml+xml;
EOF

chmod +x "$DESKTOP_FILE"

# Mettre à jour le cache
update-desktop-database ~/.local/share/applications 2>/dev/null || true

echo -e "\n✅ Web app créée: $APP_NAME"
echo "   Fichier:  $DESKTOP_FILE"
echo "   Icône: $ICON_PATH"
echo ""
echo "🚀 Lancez avec:  SUPER + SPACE → '$APP_NAME'"
echo ""
echo "🧪 Test:  flatpak run net.waterfox.waterfox --new-window $APP_URL"
