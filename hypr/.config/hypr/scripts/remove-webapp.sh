#!/bin/bash

set -e

# Vérifier gum
if ! command -v gum &>/dev/null; then
    echo "Installer gum: sudo dnf install gum"
    exit 1
fi

APPS_DIR="$HOME/.local/share/applications"
ICON_DIR="$APPS_DIR/icons"

# Lister toutes les web apps
WEBAPPS=($(ls "$APPS_DIR"/webapp-*.desktop 2>/dev/null | xargs -n1 basename))

if [ ${#WEBAPPS[@]} -eq 0 ]; then
    echo "Aucune web app trouvée!"
    exit 0
fi

# Mode interactif ou avec argument
if [ "$#" -eq 0 ]; then
    echo -e "\e[31mQuelle web app voulez-vous supprimer?\n\e[0m"
    
    # Créer une liste lisible
    CHOICES=()
    for webapp in "${WEBAPPS[@]}"; do
        # Extraire le nom depuis le fichier
        APP_NAME=$(grep "^Name=" "$APPS_DIR/$webapp" | cut -d'=' -f2)
        CHOICES+=("$APP_NAME ($webapp)")
    done
    
    SELECTED=$(gum choose "${CHOICES[@]}" --header="Sélectionnez l'application à supprimer:")
    
    # Extraire le nom du fichier
    WEBAPP_FILE=$(echo "$SELECTED" | grep -oP '\(webapp-.*? \.desktop\)' | tr -d '()')
else
    # Mode argument:  rechercher par nom
    SEARCH_NAME="$1"
    WEBAPP_FILE="webapp-$SEARCH_NAME.desktop"
    
    if [ ! -f "$APPS_DIR/$WEBAPP_FILE" ]; then
        echo "✗ Web app '$SEARCH_NAME' non trouvée!"
        echo "Web apps disponibles:"
        for webapp in "${WEBAPPS[@]}"; do
            APP_NAME=$(grep "^Name=" "$APPS_DIR/$webapp" | cut -d'=' -f2)
            echo "  - $APP_NAME (${webapp#webapp-})"
        done
        exit 1
    fi
fi

# Extraire les informations
DESKTOP_FILE="$APPS_DIR/$WEBAPP_FILE"
APP_NAME=$(grep "^Name=" "$DESKTOP_FILE" | cut -d'=' -f2)
ICON_PATH=$(grep "^Icon=" "$DESKTOP_FILE" | cut -d'=' -f2)

echo -e "\n🗑️  Suppression de:  $APP_NAME"

# Supprimer le fichier . desktop
rm -f "$DESKTOP_FILE"
echo "  ✓ Fichier . desktop supprimé"

# Supprimer l'icône si elle existe
if [ -f "$ICON_PATH" ]; then
    rm -f "$ICON_PATH"
    echo "  ✓ Icône supprimée"
fi

# Mettre à jour le cache
update-desktop-database ~/.local/share/applications 2>/dev/null || true

echo -e "\n✅ Web app '$APP_NAME' supprimée avec succès!"
