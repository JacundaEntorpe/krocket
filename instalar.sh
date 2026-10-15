#!/bin/bash
# Instala o krocket pro seu usuário (nada vai pra fora da sua home).
# Os arquivos ficam ligados a esta pasta: dê git pull aqui e roda a versão nova.
#
#   ./instalar.sh                      instala tudo
#   ./instalar.sh --sem-atalhos        não instala os atalhos de busca na web
#   ./instalar.sh --atalho "Meta+Space"   no KDE, liga o menu do rofi a essa tecla
#                                      (sem isso: Meta+Espaço, se o krocket ainda não tiver tecla)
set -euo pipefail
AQUI="$(cd "$(dirname "$0")" && pwd)"
DADOS="${XDG_DATA_HOME:-$HOME/.local/share}"
CONF="${XDG_CONFIG_HOME:-$HOME/.config}/krocket"
ATALHOS=1; TECLA=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --sem-atalhos) ATALHOS=0 ;;
    --atalho) TECLA="${2:?--atalho precisa da tecla, ex.: --atalho Meta+Space}"; shift ;;
    *) echo "Opção desconhecida: $1"; exit 1 ;;
  esac
  shift
done

python3 -c 'import dbus, gi' 2>/dev/null || {
  echo "Falta python-dbus e python-gobject: sudo pacman -S --needed python-dbus python-gobject"; exit 1; }
KDE=0; command -v krunner >/dev/null && KDE=1

# Comando, serviço D-Bus, config e tema
mkdir -p "$HOME/.local/bin" "$DADOS/dbus-1/services" "$DADOS/applications" "$CONF"
ln -sfn "$AQUI/krocket" "$HOME/.local/bin/krocket"
sed "s|@EXEC@|$HOME/.local/bin/krocket|" "$AQUI/dbus/org.jacunda.krocket.service.in" \
  > "$DADOS/dbus-1/services/org.jacunda.krocket.service"
[[ -f "$CONF/config.toml" ]] || cp "$AQUI/config.exemplo.toml" "$CONF/config.toml"
[[ -f "$CONF/tema.rasi" ]] || cp "$AQUI/menu/tema.rasi" "$CONF/tema.rasi"

# Atalho do menu: aparece nos apps e dá pra ligar a uma tecla em qualquer desktop
cat > "$DADOS/applications/krocket.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=krocket
Comment=Repositórios, git, Docker, serviços, Tailscale e IA num menu
Exec=$HOME/.local/bin/krocket menu
Icon=system-search
Terminal=false
Categories=Utility;Development;
NoDisplay=false
EOF

# Atalhos de busca na web (o KRunner usa; o menu do rofi lê os mesmos arquivos)
if [[ $ATALHOS == 1 ]]; then
  mkdir -p "$DADOS/kf6/searchproviders"
  usuario="$(git config --global user.name 2>/dev/null || echo "$USER")"
  for f in "$AQUI"/atalhos-web/*.desktop; do
    sed "s|@GITHUB_USER@|$usuario|" "$f" > "$DADOS/kf6/searchproviders/$(basename "$f")"
  done
fi

# O D-Bus só enxerga um .service novo depois de recarregar
busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus ReloadConfig >/dev/null 2>&1 \
  || dbus-send --session --dest=org.freedesktop.DBus --type=method_call /org/freedesktop/DBus org.freedesktop.DBus.ReloadConfig 2>/dev/null || true

if [[ $KDE == 1 ]]; then
  mkdir -p "$DADOS/krunner/dbusplugins"
  cp "$AQUI"/plugins/*.desktop "$DADOS/krunner/dbusplugins/"
  kbuildsycoca6 >/dev/null 2>&1 || true  # o KDE passa a conhecer o krocket.desktop
  if [[ -z "$TECLA" ]] && ! "$AQUI/krocket" atalho >/dev/null 2>&1; then
    TECLA="Meta+Space"  # primeira instalação: o menu ainda não tem tecla
  fi
  [[ -n "$TECLA" ]] && { "$AQUI/krocket" atalho "$TECLA" || true; }
  "$AQUI/krocket" reiniciar
  echo "Pronto. Menu do krocket: $( "$AQUI/krocket" atalho 2>/dev/null || echo "sem tecla (krocket atalho Meta+Space)")."
  echo "No KRunner (Alt+Espaço), digite \"kr\" pra ver todos os comandos."
else
  echo "Pronto. Ligue o comando \"krocket menu\" a uma tecla no seu desktop (veja o README)."
fi
command -v rofi >/dev/null || echo "Pro menu: sudo pacman -S rofi (e wl-clipboard no Wayland, xclip no X11)."
