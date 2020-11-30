/* Preprocessed source code */
package haven.res.ui.croster;

import haven.Coord2d;
import haven.GameUI;
import haven.MenuGrid;
import haven.MenuGrid.Pagina;

public class RosterButton extends MenuGrid.PagButton {
    public final GameUI gui;
    public RosterWindow wnd;

    public RosterButton(Pagina pag) {
        super(pag);
        gui = pag.scm.getparent(GameUI.class);
    }

    public static class Fac implements Factory {
        public MenuGrid.PagButton make(Pagina pag) {
            return (new RosterButton(pag));
        }
    }

    public void add(CattleRoster rost) {
        if (wnd == null) {
            wnd = new RosterWindow();
            wnd.addroster(rost);
            gui.addchild(wnd, "misc", new Coord2d(0.3, 0.3), new Object[]{"id", "croster"});
        } else {
            wnd.addroster(rost);
        }
    }

    public void use() {
        if (wnd == null) {
            pag.scm.wdgmsg("act", "croster");
        } else {
            if (wnd.show(!wnd.visible)) {
                wnd.raise();
                gui.setfocus(wnd);
            }
        }
    }
}
