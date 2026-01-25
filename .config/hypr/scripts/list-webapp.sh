#!/bin/bash

APPS_DIR="$HOME/.local/share/applications"

echo -e "\e[34m📱 Web Apps installées:\e[0m\n"

for desktop in "$APPS_DIR"/webapp-*.desktop; do
    if [ -f "$desktop" ]; then
        NAME=$(grep "^Name=" "$desktop" | cut -d'=' -f2)
        URL=$(grep "^Comment=" "$desktop" | cut -d': ' -f2- | xargs)
        FILE=$(basename "$desktop")
        
        echo -e "  \e[32m●\e[0m $NAME"
        echo "    URL: $URL"
        echo "    Fichier: $FILE"
        echo ""
    fi
done
