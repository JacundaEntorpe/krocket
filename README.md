# krocket 🚀

Plugins do KRunner (KDE Plasma 6) pra quem programa. Abra com `Alt+Espaço` e digite:

| Digite | O que faz |
|---|---|
| `vs poke` | Lista os repositórios git (e as pastas recentes do VS Code) que batem com "poke". **Enter** abre no VS Code |
| `poke` | O mesmo, mas sem a palavra-chave: aparece junto com apps e arquivos, só quando o nome bate bem |
| `dk` / `dk ani` | Lista os containers Docker (pelo nome ou pelo projeto compose). **Enter** abre os logs (ou inicia, se estiver parado) |
| `aur:yay` | Busca no AUR |
| `bp:pikachu` / `sb:pikachu` | Bulbapedia / Serebii |
| `ot:spawn` | OTLand (fórum de OTServ) |
| `ghc:texto` | Busca código no GitHub |
| `ghme:nome` | Busca nos seus repositórios do GitHub |

A busca de repositórios entende acentos e abreviações: `fishd` acha `Fishdle`, `vs pkcs` acha `PokeCroc_Server`, `vs poke client` filtra pelo caminho. As pastas abertas no VS Code nos últimos 30 dias sobem na lista.

### Ações

Cada resultado tem botões de ação ao lado (passe o mouse, ou selecione e use **Tab**/**seta pra direita**):

- **Repositório:** abrir no terminal, abrir no Dolphin, abrir o remote no navegador (GitHub/GitLab), copiar o caminho.
- **Container:** logs, shell dentro do container, reiniciar, parar, iniciar, copiar o nome. Start/stop/restart mostram uma notificação quando terminam.

Também dá pra arrastar um repositório do KRunner pra qualquer lugar que aceite pastas.

## Instalar

Precisa de `python-dbus` e `python-gobject` (no Arch: `sudo pacman -S --needed python-dbus python-gobject`).

```bash
git clone https://github.com/JacundaEntorpe/krocket.git ~/Projetos/krocket
cd ~/Projetos/krocket && ./instalar.sh
```

Tudo fica na sua home e ligado à pasta do clone: um `git pull` já atualiza (rode `krocket reiniciar` depois). Pra tirar: `./desinstalar.sh`. Se não quiser os atalhos de busca na web: `./instalar.sh --sem-atalhos`.

## Configurar

`~/.config/krocket/config.toml` (criado na instalação a partir de [`config.exemplo.toml`](config.exemplo.toml)). Dá pra trocar as pastas onde ele procura repositórios, a profundidade, o editor (`codium`, `kate`...), o terminal e as palavras-chave. Depois de mudar: `krocket reiniciar`.

Pra ver o que ele acharia sem abrir o KRunner:

```bash
krocket --testar "vs poke"
```

## Como funciona

O KRunner conversa com plugins externos pela interface D-Bus `org.kde.krunner1`. O `krocket` é um script Python que expõe dois objetos nesse serviço (`/repos` e `/docker`). O `.service` em `~/.local/share/dbus-1/services/` faz o D-Bus subir o script sozinho na primeira busca, então não há nada pra deixar rodando no boot.

| Arquivo | Vai pra |
|---|---|
| `krocket` | `~/.local/bin/krocket` (link) |
| `dbus/*.service.in` | `~/.local/share/dbus-1/services/` |
| `plugins/*.desktop` | `~/.local/share/krunner/dbusplugins/` |
| `atalhos-web/*.desktop` | `~/.local/share/kf6/searchproviders/` |

Os repositórios são varridos a cada 2 minutos em segundo plano, lendo direto a pasta `.git` (branch e remote) sem chamar o git, pra busca continuar instantânea. A lista do Docker fica em cache por 3 segundos.

Se um plugin não aparecer:

- rode `krocket reiniciar` (o KRunner só lê plugins novos quando inicia);
- o menu do botão Meta roda dentro do `plasmashell`, que também só lê plugins ao iniciar: `systemctl --user restart plasma-plasmashell`;
- em Configurações do Sistema → Pesquisa → Plasma Search, confira se "Repositórios (VS Code)" e "Containers Docker" estão ligados.

## Licença

MIT
