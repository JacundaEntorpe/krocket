// krocket: fecha o menu do rofi quando outra janela ganha o foco (Alt+Tab, clique na
// barra de tarefas, notificação...). O krocket carrega este script no KWin enquanto o
// menu está aberto e descarrega quando ele fecha.
var rofiComFoco = false;
workspace.windowActivated.connect(function (w) {
    if (w && w.resourceClass === "rofi") {
        rofiComFoco = true;
        return;
    }
    if (rofiComFoco) {
        rofiComFoco = false;
        callDBus("org.jacunda.krocket", "/menu", "org.jacunda.krocket.Menu", "Fechar");
    }
});
