#!/bin/bash
# Tira tudo o que o instalar.sh colocou. A config e o tema em ~/.config/krocket ficam.
set -uo pipefail
AQUI="$(cd "$(dirname "$0")" && pwd)"
DADOS="${XDG_DATA_HOME:-$HOME/.local/share}"
pkill -f "$HOME/.local/bin/krocket" 2>/dev/null
rm -f "$HOME/.local/bin/krocket" "$DADOS/dbus-1/services/org.jacunda.krocket.service" "$DADOS/applications/krocket.desktop"
command -v kwriteconfig6 >/dev/null && kwriteconfig6 --file kglobalshortcutsrc --group services --group krocket.desktop --key _launch --delete
for f in "$AQUI"/plugins/*.desktop; do rm -f "$DADOS/krunner/dbusplugins/$(basename "$f")"; done
for f in "$AQUI"/atalhos-web/*.desktop; do rm -f "$DADOS/kf6/searchproviders/$(basename "$f")"; done
systemctl --user restart plasma-krunner >/dev/null 2>&1
echo "Desinstalado. A config continua em ~/.config/krocket (apague se quiser)."
