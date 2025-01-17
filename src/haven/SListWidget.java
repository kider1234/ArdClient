package haven;

import java.awt.image.BufferedImage;
import java.util.List;
import java.util.function.Supplier;

public abstract class SListWidget<I, W extends Widget> extends Widget {
    public I sel;

    public SListWidget(Coord sz) {
        super(sz);
    }

    protected abstract List<? extends I> items();

    protected abstract W makeitem(I item, int idx, Coord sz);

    public void change(I item) {
        this.sel = item;
    }

    public static class ItemWidget<I> extends Widget {
        public final SListWidget<I, ?> list;
        public final I item;

        public ItemWidget(SListWidget<I, ?> list, Coord sz, I item) {
            super(sz);
            this.list = list;
            this.item = item;
        }

        @Override
        public boolean mousedown(Coord c, int button) {
            if (super.mousedown(c, button))
                return (true);
            list.change(item);
            return (true);
        }
    }

    public static abstract class IconText extends Widget {
        public IconText(Coord sz) {
            super(sz);
        }

        protected abstract BufferedImage img();

        protected abstract String text();

        protected int margin() {
            return (0);
        }

        protected Text.Foundry foundry() {
            return (CharWnd.attrf);
        }

        protected boolean valid(String text) {
            return (true);
        }

        private Tex img = null;

        protected void drawicon(GOut g) {
            int m = margin(), h = sz.y - (m * 2);
            try {
                if (this.img == null) {
                    BufferedImage img = img();
                    if (img.getWidth() > img.getHeight()) {
                        if (img.getWidth() != h)
                            img = PUtils.convolve(img, Coord.of(h, (h * img.getHeight()) / img.getWidth()), GobIcon.filter);
                    } else {
                        if (img.getHeight() != h)
                            img = PUtils.convolve(img, Coord.of((h * img.getWidth()) / img.getHeight(), h), GobIcon.filter);
                    }
                    this.img = new TexI(img);
                }
                g.image(this.img, Coord.of(sz.y).sub(this.img.sz()).div(2));
            } catch (Loading l) {
                g.image(WItem.missing.layer(Resource.imgc).tex(), Coord.of(m), Coord.of(sz.y - (m * 2)));
            }
        }

        private Text.Line text = null;

        protected void drawtext(GOut g) {
            int tx = sz.y + 5;
            try {
                if ((this.text == null) || !valid(text.text)) {
                    String text = text();
                    this.text = foundry().render(text);
                    if (tx + this.text.sz().x > sz.x) {
                        int len = this.text.charat(sz.x - tx - foundry().strsize("...").x);
                        this.text = foundry().render(text.substring(0, len) + "...");
                    }
                }
                g.image(this.text.tex(), Coord.of(sz.y + 5, (sz.y - this.text.sz().y) / 2));
            } catch (Loading l) {
                Tex missing = foundry().render("...").tex();
                g.image(missing, Coord.of(sz.y + 5, (sz.y - missing.sz().y) / 2));
                missing.dispose();
            }
        }

        @Override
        public void draw(GOut g) {
            drawicon(g);
            drawtext(g);
        }

//        @Override
//        public void dispose() {
//            super.dispose();
//            invalidate();
//        }

        public void invalidate() {
            if (img != null) {
                img.dispose();
                img = null;
            }
            if (text != null) {
//                text.dispose();
                text = null;
            }
        }

        public static class FromRes extends IconText {
            public final Indir<Resource> res;

            public FromRes(Coord sz, Indir<Resource> res) {
                super(sz);
                this.res = res;
            }

            @Override
            public BufferedImage img() {
                return (res.get().layer(Resource.imgc).img);
            }

            @Override
            public String text() {
                Resource.Tooltip name = res.get().layer(Resource.tooltip);
                return ((name == null) ? "???" : name.t);
            }
        }

        public static IconText of(Coord sz, Indir<Resource> res) {
            return (new FromRes(sz, res));
        }

        public static IconText of(Coord sz, Supplier<BufferedImage> img, Supplier<String> text) {
            return (new IconText(sz) {
                @Override
                public BufferedImage img() {
                    return (img.get());
                }

                @Override
                public String text() {
                    return (text.get());
                }
            });
        }
    }
}
