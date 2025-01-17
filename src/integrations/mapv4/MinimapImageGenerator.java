package integrations.mapv4;

import haven.Coord;
import haven.MCache;
import static haven.MCache.cmaps;
import haven.Resource;
import haven.TexI;
import haven.Tiler;
import haven.Utils;
import haven.resutil.Ridges;
import java.awt.Color;
import java.awt.image.BufferedImage;

/**
 * @author APXEOLOG (Artyom Melnikov), at 28.01.2019
 */
public class MinimapImageGenerator {

    private static BufferedImage tileimg(int t, BufferedImage[] texes, MCache map) {
        BufferedImage img = texes[t];
        if (img == null) {
            Resource r = map.tilesetr(t);
            if (r == null)
                return (null);
            Resource.Image ir = r.layer(Resource.imgc);
            if (ir == null)
                return (null);
            img = ir.img;
            texes[t] = img;
        }
        return (img);
    }

    public static BufferedImage drawmap(MCache map, MCache.Grid grid) {
        BufferedImage[] texes = new BufferedImage[map.tiles.length];
        BufferedImage buf = TexI.mkbuf(MCache.cmaps);
        Coord c = new Coord();
        for (c.y = 0; c.y < MCache.cmaps.y; c.y++) {
            for (c.x = 0; c.x < MCache.cmaps.x; c.x++) {
                BufferedImage tex = tileimg(grid.gettile(c), texes, map);
                int rgb = 0;
                if (tex != null)
                    rgb = tex.getRGB(Utils.floormod(c.x, tex.getWidth()),
                            Utils.floormod(c.y, tex.getHeight()));
                buf.setRGB(c.x, c.y, rgb);
            }
        }
        for (c.y = 0; c.y < MCache.cmaps.y; c.y++) {
            for (c.x = 0; c.x < MCache.cmaps.x; c.x++) {
                int t = grid.gettile(c);
                Tiler tl = map.tiler(t);
                if (tl instanceof Ridges.RidgeTile) {
                    if (Ridges.brokenp(map, c, grid)) {
                        buf.setRGB(c.x, c.y, Color.BLACK.getRGB());
                        for (int y = Math.max(c.y - 1, 0); y <= Math.min(c.y + 1, cmaps.y - 1); y++) {
                            for (int x = Math.max(c.x - 1, 0); x <= Math.min(c.x + 1, cmaps.x - 1); x++) {
                                if (x == c.x && y == c.y)
                                    continue;
                                Color cc = new Color(buf.getRGB(x, y));
                                buf.setRGB(x, y, Utils.blendcol(cc, Color.BLACK, ((x == c.x) && (y == c.y)) ? 1 : 0.1).getRGB());
                            }
                        }
                    }
                }
            }
        }
        for (c.y = 0; c.y < MCache.cmaps.y; c.y++) {
            for (c.x = 0; c.x < MCache.cmaps.x; c.x++) {
                int t = grid.gettile(c);
                Coord r = c.add(grid.ul);
                if ((map.gettile(r.add(-1, 0)) > t) ||
                        (map.gettile(r.add(1, 0)) > t) ||
                        (map.gettile(r.add(0, -1)) > t) ||
                        (map.gettile(r.add(0, 1)) > t)) {
                    buf.setRGB(c.x, c.y, Color.BLACK.getRGB());
                }
            }
        }
        return buf;
    }
}
