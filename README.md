# krocket 🚀

Plugins do KRunner (KDE Plasma 6) pra quem programa. Abra com `Alt+Espaço` e digite:

| Digite | O que faz | Enter |
|---|---|---|
| `kr` | Lista todos os comandos do krocket, os atalhos web e uns truques do KRunner | Abre o KRunner já no comando escolhido |
| `vs poke` ou só `poke` | Repositórios git e pastas recentes do VS Code | Abre no VS Code |
| `gs` / `gs poke` | Repositórios com alterações, commits sem push ou atrás do remote | Abre no VS Code |
| `dk` / `dk ani` | Containers Docker (pelo nome ou pelo projeto compose) | Logs (ou inicia, se estiver parado) |
| `sv` / `sv docker` | Serviços do systemd, do sistema e do usuário. `sv` sozinho mostra os favoritos | Status com as últimas linhas do log |
| `ts` / `ts vps` | Aparelhos da rede Tailscale, online primeiro | Copia o IP |
| `ia <pergunta>` | Pergunta pra IA local (Ollama) | Manda a pergunta; a resposta chega numa notificação e vai pra área de transferência |

Sem a palavra-chave, só os repositórios aparecem (a partir de 3 letras e quando o nome bate bem), pra não poluir a busca normal. A busca entende acentos e abreviações: `fishd` acha `Fishdle`, `vs pkcs` acha `PokeCroc_Server`, `vs poke client` filtra pelo caminho. As pastas abertas no VS Code nos últimos 30 dias sobem na lista.

### Ações

Cada resultado tem botões de ação ao lado (passe o mouse, ou selecione e use **Tab**/**seta pra direita**):

- **Repositório (`vs`, `gs`):** terminal, Claude Code na pasta, Dolphin, remote no navegador (GitHub/GitLab), `git pull`, `git push` (no `gs`), copiar o caminho. Dá pra arrastar o resultado pra qualquer lugar que aceite pastas.
- **`gs`:** o último item, "Buscar atualizações de todos", roda `git fetch` em todos os repositórios e avisa quais têm coisa nova pra puxar. Sem isso, o ↓ mostra o que o git sabia no último fetch.
- **Container:** logs, shell dentro, reiniciar, parar, iniciar, copiar o nome.
- **Serviço:** logs ao vivo, reiniciar, parar, iniciar. Serviço do sistema pede a senha numa janela do KDE.
- **Tailscale:** SSH, copiar o nome MagicDNS, abrir no navegador, ping. O usuário do SSH por aparelho fica na config.
- **IA:** continuar a conversa no Open WebUI. Digitar a mesma pergunta de novo mostra a resposta ali no KRunner (Enter copia).

Start/stop/restart, pull/push e a IA avisam numa notificação quando terminam.

### Busca na web

| Digite | Busca em |
|---|---|
| `aur:yay` | AUR |
| `bp:pikachu` / `bulba:pikachu` | Bulbapedia |
| `sb:pikachu` / `serebii:pikachu` | Serebii |
| `ot:spawn` / `otland:spawn` | OTLand (fórum de OTServ) |
| `ghc:texto` | Código no GitHub |
| `ghme:nome` | Seus repositórios no GitHub (o usuário vem do `git config user.name`) |

Esses se somam aos que já vêm no KDE (`gg:` Google, `yt:` YouTube, `wp:` Wikipedia, `gh:` GitHub, `archwiki:`...). A lista completa fica em Configurações do Sistema → Pesquisa → Atalhos da Web.

### Ajuda

- `kr` é a ajuda do krocket. Escolher um comando abre o KRunner só com os resultados daquele plugin, sem apps e arquivos misturados.
- `?` é a ajuda do próprio KRunner, com todos os plugins instalados e a sintaxe de cada um (os do krocket aparecem lá também).

## Instalar

Precisa de `python-dbus` e `python-gobject` (no Arch: `sudo pacman -S --needed python-dbus python-gobject`). Cada plugin só usa o que estiver instalado: sem Docker, Tailscale ou Ollama, o plugin correspondente fica quieto.

```bash
git clone https://github.com/JacundaEntorpe/krocket.git ~/Projetos/krocket
cd ~/Projetos/krocket && ./instalar.sh
```

Tudo fica na sua home e ligado à pasta do clone: um `git pull` já atualiza (rode `krocket reiniciar` depois). Pra tirar: `./desinstalar.sh`. Se não quiser os atalhos de busca na web: `./instalar.sh --sem-atalhos`.

## Configurar

`~/.config/krocket/config.toml` (criado na instalação a partir de [`config.exemplo.toml`](config.exemplo.toml)). Dá pra trocar as pastas onde ele procura repositórios, o editor (`codium`, `kate`...), o terminal, as palavras-chave, os serviços favoritos do `sv`, o usuário do SSH de cada aparelho do Tailscale e o modelo e as instruções da IA. Só precisa escrever o que for mudar. Depois de mudar: `krocket reiniciar`.

Pra ver o que ele acharia sem abrir o KRunner:

```bash
krocket --testar "vs poke"
```

## Como funciona

O KRunner conversa com plugins externos pela interface D-Bus `org.kde.krunner1`. O `krocket` é um script Python que expõe um objeto por plugin nesse serviço (`/repos`, `/git`, `/docker`, `/servicos`, `/tailscale`, `/ia`, `/ajuda`). O `.service` em `~/.local/share/dbus-1/services/` faz o D-Bus subir o script sozinho na primeira busca, então não há nada pra deixar rodando no boot.

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
- em Configurações do Sistema → Pesquisa → Plasma Search, confira se os plugins do krocket estão ligados.

## Licença

MIT
