#!/bin/bash
# Instala o krocket pro seu usuário (nada vai pra fora da sua home).
# Os arquivos ficam ligados a esta pasta: dê git pull aqui e roda a versão nova.
#
#   ./instalar.sh                 instala tudo
#   ./instalar.sh --sem-atalhos   não instala os atalhos de busca na web
set -euo pipefail
AQUI="$(cd "$(dirname "$0")" && pwd)"
DADOS="${XDG_DATA_HOME:-$HOME/.local/share}"
CONF="${XDG_CONFIG_HOME:-$HOME/.config}/krocket"
ATALHOS=1; [[ "${1:-}" == --sem-atalhos ]] && ATALHOS=0

python3 -c 'import dbus, gi' 2>/dev/null || {
  echo "Falta python-dbus e python-gobject: sudo pacman -S --needed python-dbus python-gobject"; exit 1; }

mkdir -p "$HOME/.local/bin" "$DADOS/dbus-1/services" "$DADOS/krunner/dbusplugins" "$CONF"
ln -sfn "$AQUI/krocket" "$HOME/.local/bin/krocket"
sed "s|@EXEC@|$HOME/.local/bin/krocket|" "$AQUI/dbus/org.jacunda.krocket.service.in" \
  > "$DADOS/dbus-1/services/org.jacunda.krocket.service"
cp "$AQUI"/plugins/*.desktop "$DADOS/krunner/dbusplugins/"
[[ -f "$CONF/config.toml" ]] || cp "$AQUI/config.exemplo.toml" "$CONF/config.toml"

if [[ $ATALHOS == 1 ]]; then
  mkdir -p "$DADOS/kf6/searchproviders"
  usuario="$(git config --global user.name 2>/dev/null || echo "$USER")"
  for f in "$AQUI"/atalhos-web/*.desktop; do
    sed "s|@GITHUB_USER@|$usuario|" "$f" > "$DADOS/kf6/searchproviders/$(basename "$f")"
  done
fi

# O D-Bus só enxerga um .service novo depois de recarregar
busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus ReloadConfig >/dev/null 2>&1 \
  || dbus-send --session --dest=org.freedesktop.DBus --type=method_call /org/freedesktop/DBus org.freedesktop.DBus.ReloadConfig || true
"$AQUI/krocket" reiniciar
echo "Pronto. Alt+Espaço e teste: \"vs poke\", \"dk\", \"aur:yay\""
