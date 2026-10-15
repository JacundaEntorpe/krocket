# krocket 🚀

Um lançador pra quem programa: repositórios, git, Docker, serviços, Tailscale e IA local a algumas teclas de distância. No KDE Plasma 6 ele vira plugins do KRunner (`Alt+Espaço`); em qualquer outro desktop (Hyprland, GNOME, Sway...) roda como um menu do [rofi](#menu-rofi-qualquer-desktop). Os comandos são os mesmos nos dois:

| Digite | O que faz | Enter |
|---|---|---|
| `kr` | Lista todos os comandos do krocket, os atalhos web e uns truques do KRunner | Abre o KRunner já no comando escolhido |
| `vs poke` ou só `poke` | Repositórios git e pastas recentes do VS Code | Abre no VS Code |
| `gs` / `gs poke` | Repositórios com alterações, commits sem push ou atrás do remote | Abre no VS Code |
| `dk` / `dk ani` | Containers Docker (pelo nome ou pelo projeto compose) | Logs (ou inicia, se estiver parado) |
| `sv` / `sv docker` | Serviços do systemd, do sistema e do usuário. `sv` sozinho mostra os favoritos | Status com as últimas linhas do log |
| `ts` / `ts vps` | Aparelhos da rede Tailscale, online primeiro | Copia o IP |
| `ia <pergunta>` | Pergunta pra IA local (Ollama) | Manda a pergunta; a resposta chega numa notificação e vai pra área de transferência |
| `ia liberar` | Mostra quanto a IA está ocupando de RAM/VRAM | Tira o modelo da memória na hora (bom antes de jogar) |
| `hm <tarefa>` | Manda uma tarefa pro [Hermes](https://github.com/NousResearch/hermes-agent), o agente que mexe no PC | Abre no terminal, pra acompanhar e aprovar o que ele fizer |

Sem a palavra-chave, só os repositórios aparecem (a partir de 3 letras e quando o nome bate bem), pra não poluir a busca normal. A busca entende acentos e abreviações: `fishd` acha `Fishdle`, `vs pkcs` acha `PokeCroc_Server`, `vs poke client` filtra pelo caminho. As pastas abertas no VS Code nos últimos 30 dias sobem na lista.

### Ações

Cada resultado tem botões de ação ao lado (passe o mouse, ou selecione e use **Tab**/**seta pra direita**):

- **Repositório (`vs`, `gs`):** terminal, Claude Code na pasta, Dolphin, remote no navegador (GitHub/GitLab), `git pull`, `git push` (no `gs`), copiar o caminho. Dá pra arrastar o resultado pra qualquer lugar que aceite pastas.
- **`gs`:** o último item, "Buscar atualizações de todos", roda `git fetch` em todos os repositórios e avisa quais têm coisa nova pra puxar. Sem isso, o ↓ mostra o que o git sabia no último fetch.
- **Container:** logs, shell dentro, reiniciar, parar, iniciar, copiar o nome.
- **Serviço:** logs ao vivo, reiniciar, parar, iniciar. Serviço do sistema pede a senha numa janela do KDE.
- **Tailscale:** SSH, copiar o nome MagicDNS, abrir no navegador, ping. O usuário do SSH por aparelho fica na config.
- **IA:** continuar a conversa no Open WebUI. Digitar a mesma pergunta de novo mostra a resposta ali no KRunner (Enter copia).
- **Hermes:** rodar em segundo plano, com a resposta numa notificação (pra tarefas que não pedem aprovação).

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

Esses se somam aos que já vêm no KDE (`gg:` Google, `yt:` YouTube, `wp:` Wikipedia, `gh:` GitHub, `archwiki:`...). A lista completa fica em Configurações do Sistema → Pesquisa → Atalhos da Web. No menu, dá pra trocar os dois-pontos por espaço: `protondb elden ring` busca direto no ProtonDB.

### Ajuda

- `kr` é a ajuda do krocket. Escolher um comando abre o KRunner só com os resultados daquele plugin, sem apps e arquivos misturados.
- `?` é a ajuda do próprio KRunner, com todos os plugins instalados e a sintaxe de cada um (os do krocket aparecem lá também).

## Menu rofi (qualquer desktop)

`krocket menu` abre os mesmos comandos num menu do rofi. Funciona no X11 e no Wayland, então serve pra Hyprland, Sway, GNOME, i3... e também no KDE, se você preferir ele ao KRunner.

- **Digite** pra filtrar: `vs poke`, `gs`, `dk ani`, `sv docker`, `ts vps`. Sem palavra-chave ele busca em tudo de uma vez: apps instalados (`viv` acha o Vivaldi, `config` as Configurações), repositórios, containers... O que bate pelo nome sobe pro topo (a busca é por começo de palavra: `server` acha `PokeCroc_Server`, `gs` não pega "logs"); quem bate só pela descrição vem depois. Os apps que você mais abre ganham prioridade.
- **Contas:** digite `2^10*3`, `15% de 80` ou `sqrt(2)` e Enter: o resultado aparece grande e já vai pra área de transferência.
- **Enter** faz a ação padrão, igual no KRunner. **Shift+Enter** abre a lista de ações (terminal, Claude Code, pull, logs, restart...).
- **Texto solto + Enter:** uma conta é resolvida, `ia <pergunta>` responde ali no menu, `hm <tarefa>` manda pro Hermes, `aur:yay` usa um atalho de busca, e qualquer outra coisa vai pro Google. Se o texto bater com algum item mas você quiser mandar ele mesmo assim, use **Ctrl+Enter**.
- `kr` mostra a ajuda; escolher um comando reabre o menu já filtrado nele.
- **O mesmo atalho abre e fecha:** apertar de novo com o menu aberto fecha ele.
- **Fecha sozinho** quando você clica fora da caixa ou quando outra janela ganha o foco (Alt+Tab, clique na barra de tarefas). Clicar fora funciona em qualquer desktop. Pra perder o foco, o rofi sozinho não percebe no Wayland: no KDE o krocket carrega um script pequeno no KWin enquanto o menu está aberto (`menu/foco-kwin.js`), e no Hyprland escuta os eventos de janela dele.

Pra ligar a uma tecla:

| Desktop | Como |
|---|---|
| KDE | O `instalar.sh` já liga em `Meta+Espaço`. Pra trocar: `krocket atalho Ctrl+Alt+K` (vale na hora; `krocket atalho` sozinho mostra a tecla atual). Uma tecla que já é de outro atalho (o `Alt+Espaço` é do KRunner) precisa ser liberada antes em Configurações do Sistema → Atalhos |
| Hyprland | `bind = SUPER, SPACE, exec, krocket menu` no `hyprland.conf` |
| Sway / i3 | `bindsym $mod+space exec krocket menu` |
| GNOME | Configurações → Teclado → Atalhos personalizados → comando `krocket menu` |

O visual fica em `~/.config/krocket/tema.rasi`: cores, transparência, tamanho, fonte e quantas linhas aparecem, tudo comentado no topo do arquivo. Mudou, abriu de novo, já está valendo.

Fora do KDE, defina o terminal na config (`terminal = "kitty"`, `"foot"`, `"alacritty"`...); kitty, foot, alacritty, wezterm, gnome-terminal e xterm já são entendidos. Pra copiar, precisa do `wl-clipboard` (Wayland) ou `xclip` (X11).

## Instalar

Precisa de `python-dbus` e `python-gobject` (no Arch: `sudo pacman -S --needed python-dbus python-gobject`). Pro menu: `rofi`, e `wl-clipboard` ou `xclip`. Cada plugin só usa o que estiver instalado: sem Docker, Tailscale, Ollama ou Hermes, o plugin correspondente fica quieto.

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

O KRunner conversa com plugins externos pela interface D-Bus `org.kde.krunner1`. O `krocket` é um script Python que expõe um objeto por plugin nesse serviço (`/repos`, `/git`, `/docker`, `/servicos`, `/tailscale`, `/ia`, `/hermes`, `/ajuda`). O `krocket menu` usa as mesmas classes direto, sem D-Bus, e mostra tudo no rofi. Ele abre o rofi antes de tudo estar pronto (~90 ms) e manda as linhas conforme cada plugin termina, então a janela aparece na hora e Docker e serviços chegam logo depois. O `.service` em `~/.local/share/dbus-1/services/` faz o D-Bus subir o script sozinho na primeira busca, então não há nada pra deixar rodando no boot.

| Arquivo | Vai pra |
|---|---|
| `krocket` | `~/.local/bin/krocket` (link) |
| `dbus/*.service.in` | `~/.local/share/dbus-1/services/` |
| `plugins/*.desktop` | `~/.local/share/krunner/dbusplugins/` (só no KDE) |
| `atalhos-web/*.desktop` | `~/.local/share/kf6/searchproviders/` |
| `menu/tema.rasi` | `~/.config/krocket/tema.rasi` (cópia, só se não existir) |
| — | `~/.local/share/applications/krocket.desktop` (o menu aparece entre os apps) |

Os repositórios são varridos a cada 2 minutos em segundo plano, lendo direto a pasta `.git` (branch e remote) sem chamar o git, pra busca continuar instantânea. A lista do Docker fica em cache por 3 segundos.

Se um plugin não aparecer:

- rode `krocket reiniciar` (o KRunner só lê plugins novos quando inicia);
- o menu do botão Meta roda dentro do `plasmashell`, que também só lê plugins ao iniciar: `systemctl --user restart plasma-plasmashell`;
- em Configurações do Sistema → Pesquisa → Plasma Search, confira se os plugins do krocket estão ligados.

## Licença

MIT
