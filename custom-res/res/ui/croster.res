Haven Resource 1 src '  Entry.java /* Preprocessed source code */
package haven.res.ui.croster;

import haven.*;
import java.util.*;
import java.util.function.*;
import haven.MenuGrid.Pagina;
import java.awt.Color;
import java.awt.image.BufferedImage;

public class Entry extends Widget {
    public static final int WIDTH = CattleRoster.WIDTH;
    public static final int HEIGHT = UI.scale(20);
    public static final Coord SIZE = new Coord(WIDTH, HEIGHT);
    public static final Color every = new Color(255, 255, 255, 16), other = new Color(255, 255, 255, 32);
    public static final Function<Integer, String> percent = v -> String.format("%d%%", v);
    public static final Function<Number, String> quality = v -> Long.toString(Math.round(v.doubleValue()));
    public final long id;
    public String name;
    public double q;
    public int idx;
    public CheckBox mark;

    public Entry(Coord sz, long id, String name) {
	super(sz);
	this.id = id;
	this.name = name;
	this.mark = adda(new CheckBox(""), UI.scale(5), sz.y / 2, 0, 0.5);
    }

    protected void drawbg(GOut g) {
	g.chcolor(((idx & 1) == 0) ? every : other);
	g.frect(Coord.z, sz);
	g.chcolor();
    }

    private Tex[] rend = {};
    private Object[] rendv = {};
    public <V> void drawcol(GOut g, Column<?> col, double a, V val, Function<? super V, ?> fmt, int idx) {
	if(fmt == null) fmt = Function.identity();
	if(rend.length <= idx) {
	    rend = Arrays.copyOf(rend, idx + 1);
	    rendv = Arrays.copyOf(rendv, idx + 1);
	}
	if(!Utils.eq(rendv[idx], val)) {
	    if(rend[idx] != null)
		rend[idx].dispose();
	    rend[idx] = CharWnd.attrf.render(String.valueOf(fmt.apply(val))).tex();
	    rendv[idx] = val;
	}
	Coord sz = rend[idx].sz();
	g.image(rend[idx], new Coord(col.x + (int)Math.round((col.w - sz.x) * a), (this.sz.y - sz.y) / 2));
    }

    public boolean mousedown(Coord c, int button) {
	if(super.mousedown(c, button))
	    return(true);
	getparent(CattleRoster.class).wdgmsg("click", (int)(id & 0x00000000ffffffffl), (int)((id & 0xffffffff00000000l) >> 32), button, ui.modflags(), ui.mc);
	return(true);
    }
}

src   Column.java /* Preprocessed source code */
package haven.res.ui.croster;

import haven.*;
import java.util.*;
import java.util.function.*;
import haven.MenuGrid.Pagina;
import java.awt.Color;
import java.awt.image.BufferedImage;

public class Column <E extends Entry> {
    public final Tex head;
    public final String tip;
    public final Comparator<? super E> order;
    public int w, x;

    public Column(String name, Comparator<? super E> order, int w) {
	this.head = CharWnd.attrf.render(name).tex();
	this.tip = null;
	this.order = order;
	this.w = UI.scale(w);
    }

    public Column(Indir<Resource> head, Comparator<? super E> order, int w) {
	Resource hres = Loading.waitfor(() -> head.get());
	Resource.Tooltip tip = hres.layer(Resource.tooltip);
	this.head = hres.layer(Resource.imgc).tex();
	this.tip = (tip == null) ? null : tip.t;
	this.order = order;
	this.w = UI.scale(w);
    }

    public Column(Indir<Resource> head, Comparator<? super E> order) {
	this(head, order, 50);
    }

    public Tex head() {
	return(head);
    }
}

src A  TypeButton.java /* Preprocessed source code */
package haven.res.ui.croster;

import haven.*;
import java.util.*;
import java.util.function.*;
import haven.MenuGrid.Pagina;
import java.awt.Color;
import java.awt.image.BufferedImage;

public class TypeButton extends IButton {
    public final int order;

    public TypeButton(BufferedImage up, BufferedImage down, int order) {
	super(up, down);
	this.order = order;
    }

    protected void depress() {
	Audio.play(Button.lbtdown.stream());
    }

    protected void unpress() {
	Audio.play(Button.lbtup.stream());
    }
}

src �  CattleRoster.java /* Preprocessed source code */
package haven.res.ui.croster;

import haven.*;
import java.util.*;
import java.util.function.*;
import haven.MenuGrid.Pagina;
import java.awt.Color;
import java.awt.image.BufferedImage;

public abstract class CattleRoster <T extends Entry> extends Widget {
    public static final int WIDTH = UI.scale(900);
    public static final Comparator<Entry> namecmp = (a, b) -> a.name.compareTo(b.name);
    public static final int HEADH = UI.scale(40);
    public final Map<Long, T> entries = new HashMap<>();
    public final Scrollbar sb;
    public final Widget entrycont;
    public List<T> display = Collections.emptyList();
    public boolean dirty = true;
    public Comparator<? super T> order = namecmp;
    public Column mousecol, ordercol;
    public boolean revorder;

    public CattleRoster() {
	super(new Coord(WIDTH, UI.scale(400)));
	entrycont = add(new Widget(sz), 0, HEADH);
	sb = add(new Scrollbar(sz.y, 0, 0) {
		public void changed() {redisplay(display);}
	    }, sz.x, HEADH);
	add(new Button(UI.scale(150), "Remove selected", false).action(() -> {
	    Collection<Object> args = new ArrayList<>();
	    for(Entry entry : this.entries.values()) {
		if(entry.mark.a) {
		    args.add(Integer.valueOf((int)(entry.id & 0x00000000ffffffffl)));
		    args.add(Integer.valueOf((int)((entry.id & 0xffffffff00000000l) >> 32)));
		}
	    }
	    wdgmsg("rm", args.toArray(new Object[0]));
	}), entrycont.pos("bl").adds(0, 5));
	pack();
    }

    public static <E extends Entry>  List<Column> initcols(Column... attrs) {
	for(int i = 0, x = CheckBox.sbox.sz().x + UI.scale(10); i < attrs.length; i++) {
	    Column attr = attrs[i];
	    attr.x = x;
	    x += attr.w + UI.scale(15);
	}
	return(Arrays.asList(attrs));
    }

    public void redisplay(List<T> display) {
	Set<T> hide = new HashSet<>(entries.values());
	int h = 0, th = entrycont.sz.y;
	for(T entry : display)
	    h += entry.sz.y;
	sb.max = h - th;
	int y = -sb.val, idx = 0;
	for(T entry : display) {
	    entry.idx = idx++;
	    if((y + entry.sz.y > 0) && (y < th)) {
		entry.move(new Coord(0, y));
		entry.show();
	    } else {
		entry.hide();
	    }
	    hide.remove(entry);
	    y += entry.sz.y;
	}
	for(T entry : hide)
	    entry.hide();
	this.display = display;
    }

    public void tick(double dt) {
	if(dirty) {
	    List<T> ndisp = new ArrayList<>(entries.values());
	    ndisp.sort(order);
	    redisplay(ndisp);
	    dirty = false;
	}
    }

    protected abstract List<Column> cols();

    public void drawcols(GOut g) {
	Column prev = null;
	for(Column col : cols()) {
	    if(prev != null) {
		g.chcolor(255, 255, 0, 64);
		int x = (prev.x + prev.w + col.x) / 2;
		g.line(new Coord(x, 0), new Coord(x, sz.y), 1);
		g.chcolor();
	    }
	    if((col == mousecol) && (col.order != null)) {
		g.chcolor(255, 255, 0, 16);
		g.frect2(new Coord(col.x, 0), new Coord(col.x + col.w, sz.y));
		g.chcolor();
	    }
	    if(col == ordercol) {
		g.chcolor(255, 255, 0, 16);
		g.frect2(new Coord(col.x, 0), new Coord(col.x + col.w, sz.y));
		g.chcolor();
	    }
	    Tex head = col.head();
	    g.aimage(head, new Coord(col.x + (col.w / 2), HEADH / 2), 0.5, 0.5);
	    prev = col;
	}
    }

    public void draw(GOut g) {
	drawcols(g);
	super.draw(g);
    }

    public Column onhead(Coord c) {
	if((c.y < 0) || (c.y >= HEADH))
	    return(null);
	for(Column col : cols()) {
	    if((c.x >= col.x) && (c.x < col.x + col.w))
		return(col);
	}
	return(null);
    }

    public void mousemove(Coord c) {
	super.mousemove(c);
	mousecol = onhead(c);
    }

    public boolean mousedown(Coord c, int button) {
	Column col = onhead(c);
	if(button == 1) {
	    if((col != null) && (col.order != null)) {
		revorder = (col == ordercol) ? !revorder : false;
		this.order = col.order;
		if(revorder)
		    this.order = this.order.reversed();
		ordercol = col;
		dirty = true;
		return(true);
	    }
	}
	return(super.mousedown(c, button));
    }

    public boolean mousewheel(Coord c, int amount) {
	sb.ch(amount * UI.scale(15));
	return(true);
    }

    public Object tooltip(Coord c, Widget prev) {
	if(mousecol != null)
	    return(mousecol.tip);
	return(super.tooltip(c, prev));
    }

    public void addentry(T entry) {
	entries.put(entry.id, entry);
	entrycont.add(entry, Coord.z);
	dirty = true;
    }

    public void delentry(long id) {
	T entry = entries.remove(id);
	entry.destroy();
	dirty = true;
    }

    public void delentry(T entry) {
	delentry(entry.id);
    }

    public abstract T parse(Object... args);

    public void uimsg(String msg, Object... args) {
	if(msg == "add") {
	    addentry(parse(args));
	} else if(msg == "upd") {
	    T entry = parse(args);
	    delentry(entry.id);
	    addentry(entry);
	} else if(msg == "rm") {
	    delentry((Long)args[0]);
	} else if(msg == "addto") {
	    GameUI gui = (GameUI)ui.getwidget((Integer)args[0]);
	    Pagina pag = gui.menu.paginafor(ui.sess.getres((Integer)args[1]));
	    RosterButton btn = (RosterButton)Loading.waitfor(pag::button);
	    btn.add(this);
	} else {
	    super.uimsg(msg, args);
	}
    }

    public abstract TypeButton button();

    public static TypeButton typebtn(Indir<Resource> up, Indir<Resource> dn) {
	Resource ur = Loading.waitfor(() -> up.get());
	Resource.Image ui = ur.layer(Resource.imgc);
	Resource.Image di = Loading.waitfor(() -> dn.get()).layer(Resource.imgc);
	TypeButton ret = new TypeButton(ui.scaled(), di.scaled(), ui.z);
	Resource.Tooltip tip = ur.layer(Resource.tooltip);
	if(tip != null)
	    ret.settip(tip.t);
	return(ret);
    }
}

src �  RosterWindow.java /* Preprocessed source code */
package haven.res.ui.croster;

import haven.*;
import java.util.*;
import java.util.function.*;
import haven.MenuGrid.Pagina;
import java.awt.Color;
import java.awt.image.BufferedImage;

public class RosterWindow extends Window {
    public int btny = 0;
    public List<TypeButton> buttons = new ArrayList<>();

    RosterWindow() {
	super(Coord.z, "Cattle Roster", true);
    }

    public void show(CattleRoster rost) {
	for(CattleRoster ch : children(CattleRoster.class))
	    ch.show(ch == rost);
    }

    public void addroster(CattleRoster rost) {
	if(btny == 0)
	    btny = rost.sz.y + UI.scale(10);
	add(rost, Coord.z);
	TypeButton btn = this.add(rost.button());
	btn.action(() -> show(rost));
	buttons.add(btn);
	buttons.sort((a, b) -> (a.order - b.order));
	int x = 0;
	for(Widget wdg : buttons) {
	    wdg.move(new Coord(x, btny));
	    x += wdg.sz.x + UI.scale(10);
	}
	buttons.get(0).click();
	pack();
    }

    public void wdgmsg(Widget sender, String msg, Object... args) {
	if((sender == this) && msg.equals("close")) {
	    this.hide();
	    return;
	}
	super.wdgmsg(sender, msg, args);
    }
}

/* >pagina: RosterButton$Fac */
src �  RosterButton.java /* Preprocessed source code */
package haven.res.ui.croster;

import haven.*;
import java.util.*;
import java.util.function.*;
import haven.MenuGrid.Pagina;
import java.awt.Color;
import java.awt.image.BufferedImage;

public class RosterButton extends MenuGrid.PagButton {
    public final GameUI gui;
    public RosterWindow wnd;

    public RosterButton(Pagina pag) {
	super(pag);
	gui = pag.scm.getparent(GameUI.class);
    }

    public static class Fac implements Factory {
	public MenuGrid.PagButton make(Pagina pag) {
	    return(new RosterButton(pag));
	}
    }

    public void add(CattleRoster rost) {
	if(wnd == null) {
	    wnd = new RosterWindow();
	    wnd.addroster(rost);
	    gui.addchild(wnd, "misc", new Coord2d(0.3, 0.3), new Object[] {"id", "croster"});
	} else {
	    wnd.addroster(rost);
	}
    }

    public void use() {
	if(wnd == null) {
	    pag.scm.wdgmsg("act", "croster");
	} else {
	    if(wnd.show(!wnd.visible)) {
		wnd.raise();
		gui.setfocus(wnd);
	    }
	}
    }
}
code A  haven.res.ui.croster.RosterWindow ����   4 �	  E F
 + G	 * H I
  J	 * K L
 * M N O P Q P R
  S	  T	  U
 V W
 * X
  Y
 * Z [   `
  a b c  g b h b O i j
  k
  l	  T	  m b n
  o
 * p q
 r s
 * t
 + u	  v
 * w x y btny I buttons Ljava/util/List; 	Signature 3Ljava/util/List<Lhaven/res/ui/croster/TypeButton;>; <init> ()V Code LineNumberTable show &(Lhaven/res/ui/croster/CattleRoster;)V StackMapTable z x L 	addroster [ wdgmsg 6(Lhaven/Widget;Ljava/lang/String;[Ljava/lang/Object;)V lambda$addroster$1 E(Lhaven/res/ui/croster/TypeButton;Lhaven/res/ui/croster/TypeButton;)I lambda$addroster$0 
SourceFile RosterWindow.java { | Cattle Roster 2 } , - java/util/ArrayList 2 3 . / !haven/res/ui/croster/CattleRoster ~  � � � z � � � � 6 � � | � - � � � � � � � � � haven/res/ui/croster/TypeButton BootstrapMethods � 3 � � � � � � � � � � A � � � � haven/Widget haven/Coord 2 � � � � - � � � 3 � 3 close � � � � 3 > ? � - 6 7 !haven/res/ui/croster/RosterWindow haven/Window java/util/Iterator z Lhaven/Coord; #(Lhaven/Coord;Ljava/lang/String;Z)V children "(Ljava/lang/Class;)Ljava/util/Set; java/util/Set iterator ()Ljava/util/Iterator; hasNext ()Z next ()Ljava/lang/Object; (Z)Z sz y haven/UI scale (I)I add +(Lhaven/Widget;Lhaven/Coord;)Lhaven/Widget; button #()Lhaven/res/ui/croster/TypeButton; (Lhaven/Widget;)Lhaven/Widget;
 � �
 * � run \(Lhaven/res/ui/croster/RosterWindow;Lhaven/res/ui/croster/CattleRoster;)Ljava/lang/Runnable; action %(Ljava/lang/Runnable;)Lhaven/IButton; java/util/List (Ljava/lang/Object;)Z '(Ljava/lang/Object;Ljava/lang/Object;)I
 * � compare ()Ljava/util/Comparator; sort (Ljava/util/Comparator;)V (II)V move (Lhaven/Coord;)V x get (I)Ljava/lang/Object; click pack java/lang/String equals hide order � � � B 7 @ A "java/lang/invoke/LambdaMetafactory metafactory � Lookup InnerClasses �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite; � %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles croster.cjava ! * +     , -    . /  0    1    2 3  4   ?     *� � *� *� Y� � �    5      9 
5 6 :  6 7  4   �     2*� 	� 
 M,�  � ,�  � N--+� � � W��ޱ    8   8 �  9�   : ; 9 ;  ;�    : ; 9 ;  ;�  5      = > 1?  < 7  4       �*� � *+� � 
� `� *+� � W*+� � � M,*+�   � W*� ,�  W*� �   �  >*� �  :�  � 4�  � :� Y*� � � � �  
� ``>���*� � ! � � "*� #�    8    � F = 9� : 5   >   B C D !E -F 9G DH RI TJ uK �L �M �N �O �P � > ?  4   L     +*� ,$� %� *� &�*+,-� '�    8     5      S T U W X
 @ A  4   "     
*� (+� (d�    5      H B 7  4        *+� )�    5      F  \     ]  ^ _ ^ ]  d e f C    � �   
  � � � code �  haven.res.ui.croster.CattleRoster$1 ����   4 "	  
  	  
     this$0 #Lhaven/res/ui/croster/CattleRoster; <init> )(Lhaven/res/ui/croster/CattleRoster;III)V Code LineNumberTable changed ()V 
SourceFile CattleRoster.java EnclosingMethod  	    	       #haven/res/ui/croster/CattleRoster$1 InnerClasses haven/Scrollbar !haven/res/ui/croster/CattleRoster (III)V display Ljava/util/List; 	redisplay (Ljava/util/List;)V croster.cjava               	 
     &     *+� *� �           ~        '     *� *� � � �                 !    
              code Y  haven.res.ui.croster.TypeButton ����   4 2
  	  	  
  
  	     order I <init> @(Ljava/awt/image/BufferedImage;Ljava/awt/image/BufferedImage;I)V Code LineNumberTable depress ()V unpress 
SourceFile TypeButton.java   	 
   ! $ & ' * + , - . $ haven/res/ui/croster/TypeButton haven/IButton ?(Ljava/awt/image/BufferedImage;Ljava/awt/image/BufferedImage;)V haven/Button lbtdown Audio InnerClasses Lhaven/Resource$Audio; / haven/Resource$Audio stream 0 CS ()Lhaven/Audio$CS; haven/Audio play (Lhaven/Audio$CS;)V lbtup haven/Resource haven/Audio$CS croster.cjava !       	 
           ,     *+,� *� �           a  b  c        &     
� � � �       
    f 	 g        &     
� � � �       
    j 	 k      1 #      % "  (  )	code �  haven.res.ui.croster.RosterButton$Fac ����   4 "
   
      <init> ()V Code LineNumberTable make  Pagina InnerClasses  	PagButton 3(Lhaven/MenuGrid$Pagina;)Lhaven/MenuGrid$PagButton; 
SourceFile RosterButton.java   !haven/res/ui/croster/RosterButton   %haven/res/ui/croster/RosterButton$Fac Fac java/lang/Object  haven/MenuGrid$PagButton$Factory Factory   haven/MenuGrid$Pagina haven/MenuGrid$PagButton (Lhaven/MenuGrid$Pagina;)V haven/MenuGrid croster.cjava !            	        *� �    
      e     	   !     	� Y+� �    
      g      !    "     	    	    	   	code l'  haven.res.ui.croster.CattleRoster ����   4; �	 � �
 � �
  �
  � �
  �	 � �
 � �	 � �	 � �	 � �	 � � �	 � �	 � 
 �	 �	 
 	 	 �	

   
 
 

 �
 �		 >	 >
 !
 ("	  �#$%&%'(	 / �	 )	 *	 /+
 /,
 /-
 /./0/$1
 9"#2
 �3
 �45
67
68
69	 �:	 > �
6;	 �<
 >=?�      
6>
 �?
 @
 A
 �B	 �CDE
 F
 G	 >H
 I	 /J
 aK L	 M
  N
 /O
 �PQ
 �R
 �STUV
 aWX	 �YZ
 e[
 �\]	 h^	 �_
`a
bc
 �d h
ijk
 pl
 m pq	 tr
 tst pw
 wx	 wy
 yz	 t{|	 ~~
 y��
 9 ��$	 /�	�    ����
 e�������    ���
 ��	 /�
�� �� InnerClasses WIDTH I namecmp Ljava/util/Comparator; 	Signature 4Ljava/util/Comparator<Lhaven/res/ui/croster/Entry;>; HEADH entries Ljava/util/Map; $Ljava/util/Map<Ljava/lang/Long;TT;>; sb Lhaven/Scrollbar; 	entrycont Lhaven/Widget; display Ljava/util/List; Ljava/util/List<TT;>; dirty Z order Ljava/util/Comparator<-TT;>; mousecol Lhaven/res/ui/croster/Column; ordercol revorder <init> ()V Code LineNumberTable initcols 0([Lhaven/res/ui/croster/Column;)Ljava/util/List; StackMapTable o<E:Lhaven/res/ui/croster/Entry;>([Lhaven/res/ui/croster/Column;)Ljava/util/List<Lhaven/res/ui/croster/Column;>; 	redisplay (Ljava/util/List;)V����( (Ljava/util/List<TT;>;)V tick (D)V cols ()Ljava/util/List; 1()Ljava/util/List<Lhaven/res/ui/croster/Column;>; drawcols (Lhaven/GOut;)V5 draw onhead ,(Lhaven/Coord;)Lhaven/res/ui/croster/Column; 	mousemove (Lhaven/Coord;)V 	mousedown (Lhaven/Coord;I)Z � 
mousewheel tooltip /(Lhaven/Coord;Lhaven/Widget;)Ljava/lang/Object; addentry (Lhaven/res/ui/croster/Entry;)V (TT;)V delentry (J)V parse 1([Ljava/lang/Object;)Lhaven/res/ui/croster/Entry; ([Ljava/lang/Object;)TT; uimsg ((Ljava/lang/String;[Ljava/lang/Object;)V button #()Lhaven/res/ui/croster/TypeButton; typebtn =(Lhaven/Indir;Lhaven/Indir;)Lhaven/res/ui/croster/TypeButton;�qtw| a(Lhaven/Indir<Lhaven/Resource;>;Lhaven/Indir<Lhaven/Resource;>;)Lhaven/res/ui/croster/TypeButton; lambda$typebtn$3 (Lhaven/Indir;)Lhaven/Resource; lambda$typebtn$2 lambda$new$1� lambda$static$0 ;(Lhaven/res/ui/croster/Entry;Lhaven/res/ui/croster/Entry;)I <clinit> .<T:Lhaven/res/ui/croster/Entry;>Lhaven/Widget; 
SourceFile CattleRoster.java haven/Coord � ���� �� � � java/util/HashMap � � � ��� � � � � � � � � � haven/Widget�� � �Q� � � #haven/res/ui/croster/CattleRoster$1� � ��� � haven/Scrollbar � � haven/Button Remove selected �� BootstrapMethods� ������ bl�����Q�� �������� ���� java/util/HashSet��� ���������� haven/res/ui/croster/Entry� �� �� �� �� �� ���� java/util/ArrayList�� � � � � haven/res/ui/croster/Column������ � � ��� � ����� � � � � � � � � � ���� � ����� � ������������ � � � add � � � � upd rm java/lang/Long�� addto�� java/lang/Integer���� haven/GameUI�������������  !haven/res/ui/croster/RosterButtonQ	 � �
 haven/Resource haven/Resource$Image Image haven/res/ui/croster/TypeButton� � � � haven/Resource$Tooltip Tooltip���� ��Q� java/lang/Object  �!�"#$%& �'� !haven/res/ui/croster/CattleRoster java/util/List java/util/Set java/util/Iterator haven/Indir java/util/Collection haven/UI scale (I)I (II)V java/util/Collections 	emptyList sz Lhaven/Coord;  (Lhaven/Widget;II)Lhaven/Widget; y )(Lhaven/res/ui/croster/CattleRoster;III)V x (ILjava/lang/String;Z)V
()
 �* run 9(Lhaven/res/ui/croster/CattleRoster;)Ljava/lang/Runnable; action $(Ljava/lang/Runnable;)Lhaven/Button; pos Position +(Ljava/lang/String;)Lhaven/Widget$Position; haven/Widget$Position adds (II)Lhaven/Widget$Position; +(Lhaven/Widget;Lhaven/Coord;)Lhaven/Widget; pack haven/CheckBox sbox Lhaven/Tex; 	haven/Tex ()Lhaven/Coord; w java/util/Arrays asList %([Ljava/lang/Object;)Ljava/util/List; java/util/Map values ()Ljava/util/Collection; (Ljava/util/Collection;)V iterator ()Ljava/util/Iterator; hasNext ()Z next ()Ljava/lang/Object; max val idx move show hide remove (Ljava/lang/Object;)Z sort (Ljava/util/Comparator;)V 
haven/GOut chcolor (IIII)V line (Lhaven/Coord;Lhaven/Coord;D)V frect2 (Lhaven/Coord;Lhaven/Coord;)V head ()Lhaven/Tex; aimage (Lhaven/Tex;Lhaven/Coord;DD)V java/util/Comparator reversed ()Ljava/util/Comparator; ch (I)V tip Ljava/lang/String; id J valueOf (J)Ljava/lang/Long; put 8(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object; z &(Ljava/lang/Object;)Ljava/lang/Object; destroy 	longValue ()J ui 
Lhaven/UI; intValue ()I 	getwidget (I)Lhaven/Widget; menu Lhaven/MenuGrid; sess Lhaven/Session; haven/Session getres (I)Lhaven/Indir; haven/MenuGrid 	paginafor+ Pagina &(Lhaven/Indir;)Lhaven/MenuGrid$Pagina; getClass ()Ljava/lang/Class;
�,- 	PagButton ()Lhaven/MenuGrid$PagButton; get &(Lhaven/MenuGrid$Pagina;)Lhaven/Indir; haven/Loading waitfor !(Lhaven/Indir;)Ljava/lang/Object; &(Lhaven/res/ui/croster/CattleRoster;)V
 �. ()Lhaven/Resource; (Lhaven/Indir;)Lhaven/Indir; imgc Ljava/lang/Class; layer/ Layer )(Ljava/lang/Class;)Lhaven/Resource$Layer;
 �0 scaled  ()Ljava/awt/image/BufferedImage; @(Ljava/awt/image/BufferedImage;Ljava/awt/image/BufferedImage;I)V t settip "(Ljava/lang/String;)Lhaven/Widget; mark Lhaven/CheckBox; a (I)Ljava/lang/Integer; toArray (([Ljava/lang/Object;)[Ljava/lang/Object; wdgmsg name java/lang/String 	compareTo (Ljava/lang/String;)I '(Ljava/lang/Object;Ljava/lang/Object;)I
 �1 compare236 � � haven/MenuGrid$Pagina � haven/MenuGrid$PagButton � � haven/Resource$Layer � � � � "java/lang/invoke/LambdaMetafactory metafactory8 Lookup �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;9 %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles croster.cjava! �      � �    � �  �    �  � �    � �  �    �  � �    � �    � �  �    �  � �    � �  �    �  � �    � �    � �     � �  �   �     �*� Y� �� � � *� Y� � *� 	� 
*� *� � **� Y*� � � � � **� Y**� � � *� � � � � � *� Y �� � *�   � *� � �  � !W*� "�    �   2    |  r  u & v + w 2 } I ~ o � � � � � � � � � � � �  �   w     ;<� #� $ � 
� `=*�� *2N-� %-� &� ``=����*� '�    �   
 � � ! �       �  �  � # � 0 � 6 � �    �  � �  �  �  	  � (Y*� � ) � *M>*� � +� 6+� , :� - � � . � /:� 0� `>���*� d� 1*� � 2t66+� , :� - � c� . � /:�� 3� 0� `� !� � Y� � 4� 5� � 6,� 7 W� 0� `6���,� 8 :� - � � . � /:� 6���*+� 
�    �   5 � '  � � � �  � #�  �� K �� �  ��  �   N    �  �  � = � K � V � c � � � � � � � � � � � � � � � � � � � � � � �  � �    �  � �  �   b     -*� � (� 9Y*� � ) � :N-*� � ; *-� <*� �    �    , �       �  �  � " � ' � , � � �  �    �  � �  �  �    *M*� =� , N-� - �-� . � >:,� F+ � �@� ?,� %,� &`� %`l6+� Y� � Y*� � � � @+� A*� B� F� C� >+ � �� ?+� Y� %� � Y� %� &`*� � � � D+� A*� E� >+ � �� ?+� Y� %� � Y� %� &`*� � � � D+� A� F:+� Y� %� &l`� l�  G G� IM���    �    �  � �� Z �� K� C� 1 �   R    �  �   � $ � 1 � D � c � g � x � � � � � � � � � � � � � � � � �# �& �) �  � �  �   +     *+� J*+� K�    �       �  � 
 �  � �  �   �     R+� � +� � � �*� =� , M,� - � -,� . � >N+� -� %� +� -� %-� &`� -�����    �    � 	 �/�  �       �  �  � 0 � K � M � P �  � �  �   /     *+� L**+� M� B�    �       �  �  �  � �  �   �     a*+� MN� R-� N-� C� G*-*� E� *� N� � � � N*-� C� *� N� **� � O � *-� E*� �*+� P�    �   1 � *  � � �  �C ��    � � �  � �   .    �  �  �  � 2 � : � A � N � S � X � Z �  � �  �   ,     *� � h� Q�    �   
    �  �  � �  �   ?     *� B� *� B� R�*+,� S�    �     �       �  �  �  � �  �   H     $*� +� T� U+� V W*� +� W� XW*� �    �         # �    �  � �  �   ?     *� � U� Y � /N-� Z*� �    �       	 
   � �  �   %     	*+� T� [�    �   
     �    �� � �  �    � � � �  �       �+\� **,� ]� ^� �+_� *,� ]N*-� T� [*-� ^� r+`� *,2� a� b� [� \+c� P*� d,2� e� f� g� hN-� i*� d� j,2� e� f� k� l:Y� mW� n  � o� p:*� q� 	*+,� r�    �   	 � R �   B        & + 4 D J ^ z �  �! �" �$ � �   	 � �  �   �     d*� s  � o� tM,� u� v� wN+� x  � o� t� u� v� w:� yY-� z� z-� {� |:,� }� v� ~:� � � �W�    �    � a  � � � � � � �   �   "   ) * + /, E- Q. V/ a0 �    �
 � �  �   "     
*� � � t�    �      +
 � �  �   "     
*� � � t�    �      ) � �  �   �     q� 9Y� �L*� � ) � � M,� - � C,� . � /N-� �� �� ,+-� T ��� �� � W+-� T � {�� �� � W���*`+� �� � � ��    �    �  � �� E�  �   "    �  � * � 4 � G � ] � ` � p �
 � �  �   $     *� �+� �� ��    �       p  � �  �   :      �� � � �  � (� � �    �       o 	 p  q    4   efg eno evo ��� �   : �    � �   B         w tu  ~ t}  � 	�b� 	b 	 t475 code   haven.res.ui.croster.Entry ����   4&
 G z {	 F | }	 F ~	 F 	 F � � �
  �
 � �	 $ �?�      
 F �	 F �	 F �	 F �	 F �
 � �	 $ �	 F �
 � �
 � � � �
 � � `
 � �  �	 � � � �
 � �
 � �
 � �  � �	 � �	 � �	 $ �
 � �
 $ �
 � �
 G � �
 F � �    ����
 � �����    	 F �
 � �	 � �
 , �
 � �
 � � �
 � �	 , �	 F �	 F �	 F � �
 @ �   �	 F �  �	 F � � � WIDTH I HEIGHT SIZE Lhaven/Coord; every Ljava/awt/Color; other percent Ljava/util/function/Function; 	Signature DLjava/util/function/Function<Ljava/lang/Integer;Ljava/lang/String;>; quality CLjava/util/function/Function<Ljava/lang/Number;Ljava/lang/String;>; id J name Ljava/lang/String; q D idx mark Lhaven/CheckBox; rend [Lhaven/Tex; rendv [Ljava/lang/Object; <init> #(Lhaven/Coord;JLjava/lang/String;)V Code LineNumberTable drawbg (Lhaven/GOut;)V StackMapTable � � � drawcol ](Lhaven/GOut;Lhaven/res/ui/croster/Column;DLjava/lang/Object;Ljava/util/function/Function;I)V n<V:Ljava/lang/Object;>(Lhaven/GOut;Lhaven/res/ui/croster/Column<*>;DTV;Ljava/util/function/Function<-TV;*>;I)V 	mousedown (Lhaven/Coord;I)Z lambda$static$1 &(Ljava/lang/Number;)Ljava/lang/String; lambda$static$0 '(Ljava/lang/Integer;)Ljava/lang/String; <clinit> ()V 
SourceFile 
Entry.java c � 	haven/Tex _ ` java/lang/Object a b V W X Y haven/CheckBox   c � � � � � I � � ] ^ \ I M N O N � � � � L � L � � � w � � � � � � � � � � w � � � � � � � � � � � � � � � � haven/Coord � � I � I � � � c � �  p q !haven/res/ui/croster/CattleRoster click �	 L
 %d%% H I J I K L java/awt/Color c BootstrapMethods � u � � P Q s T Q haven/res/ui/croster/Entry haven/Widget 
haven/GOut (Lhaven/Coord;)V (Ljava/lang/String;)V haven/UI scale (I)I y adda "(Lhaven/Widget;IIDD)Lhaven/Widget; chcolor (Ljava/awt/Color;)V z sz frect (Lhaven/Coord;Lhaven/Coord;)V java/util/function/Function identity ()Ljava/util/function/Function; java/util/Arrays copyOf )([Ljava/lang/Object;I)[Ljava/lang/Object; haven/Utils eq '(Ljava/lang/Object;Ljava/lang/Object;)Z dispose haven/CharWnd attrf Foundry InnerClasses Lhaven/Text$Foundry; apply &(Ljava/lang/Object;)Ljava/lang/Object; java/lang/String valueOf &(Ljava/lang/Object;)Ljava/lang/String; haven/Text$Foundry render Line %(Ljava/lang/String;)Lhaven/Text$Line; haven/Text$Line tex ()Lhaven/Tex; ()Lhaven/Coord; haven/res/ui/croster/Column x w java/lang/Math round (D)J (II)V image (Lhaven/Tex;Lhaven/Coord;)V 	getparent !(Ljava/lang/Class;)Lhaven/Widget; java/lang/Integer (I)Ljava/lang/Integer; ui 
Lhaven/UI; modflags ()I mc wdgmsg ((Ljava/lang/String;[Ljava/lang/Object;)V java/lang/Number doubleValue ()D java/lang/Long toString (J)Ljava/lang/String; format 9(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String; (IIII)V

 F
 F 
haven/Text! t u r s "java/lang/invoke/LambdaMetafactory metafactory# Lookup �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;$ %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles croster.cjava ! F G     H I    J I    K L    M N    O N    P Q  R    S  T Q  R    U  V W    X Y    Z [    \ I    ] ^    _ `    a b     c d  e   s 	    C*+� *� � *� � * � *� **� Y	� 
� +� l � � � �    f         $  %        B   g h  e   i     &+*� ~� 	� � � � +� *� � +� �    i    P j�   k j  j l f           ! ! % "  m n  e   	 	   �� � :*� �� $**� `� � � **� `� � *� 2� � >*� 2� *� 2�  *� � �  �  � !� "S*� S*� 2� # :+*� 2� $Y,� %,� &� 'd�)k� (�`*� � � dl� )� *�    i    
*$$ f   2    ' 
 (  ) & * 5 , D - N . Z / v 0  2 � 3 � 4 R    o  p q  e   � 	    ^*+� +� �*,� -� ,.� Y*�  /�� 1SY*�  2 {�� 1SY� 1SY*� 4� 5� 1SY*� 4� 6S� 7�    i     f       7 	 8  9 \ :
 r s  e   #     *� 8� (� 9�    f       
 t u  e   &     :� Y*S� ;�    f         v w  e   �      Y� <� =� � >� $Y� =� >� )� ?� @Y � � �� A� � @Y � � � � A� � B  � C� D  � E�    f              H  P   �     �  � � � �  � � � x   % �     � � � 	 � � � 	"  code   haven.res.ui.croster.RosterButton ����   4 d
  2	 $ 3 4
 5 6	  7	  8 9
  :
  ; < = >?�333333
  ? @ A
  B	  C D
 5 E	  F
  G
  H
  I J K M Fac InnerClasses gui Lhaven/GameUI; wnd #Lhaven/res/ui/croster/RosterWindow; <init> N Pagina (Lhaven/MenuGrid$Pagina;)V Code LineNumberTable add &(Lhaven/res/ui/croster/CattleRoster;)V StackMapTable use ()V 9 J 
SourceFile RosterButton.java # & O P haven/GameUI Q R S    ! " !haven/res/ui/croster/RosterWindow # - T * java/lang/Object misc haven/Coord2d # U id croster V W X Y act Z [ \ ] ^ _ ` - a b !haven/res/ui/croster/RosterButton haven/MenuGrid$PagButton 	PagButton %haven/res/ui/croster/RosterButton$Fac haven/MenuGrid$Pagina scm Lhaven/MenuGrid; haven/MenuGrid 	getparent !(Ljava/lang/Class;)Lhaven/Widget; 	addroster (DD)V addchild $(Lhaven/Widget;[Ljava/lang/Object;)V pag Lhaven/MenuGrid$Pagina; wdgmsg ((Ljava/lang/String;[Ljava/lang/Object;)V visible Z show (Z)Z raise setfocus (Lhaven/Widget;)V croster.cjava !             ! "     # &  '   6     *+� *+� � � � �    (      a b c  ) *  '   �     [*� � N*� Y� � *� +� 	*� *� � 
YSY� Y  � SY� 
YSYSS� � *� +� 	�    +    � R (      l m n o Rq Zs  , -  '   �     K*� � *� � � 
YS� � .*� *� � � � � � *� � *� *� � �    +    Q .�    /  . (      v w y 8z ?{ J~  0    c         	 $ 5 % 	  5 L 	code E
  haven.res.ui.croster.Column ����   4 �
  9	 : ;
 < =
 > ?	  @	  A	  B
 C D	  E   K
 L M N	  O
  P Q	  T U
  ?	  W
  X Y Z [ \ head Lhaven/Tex; tip Ljava/lang/String; order Ljava/util/Comparator; 	Signature Ljava/util/Comparator<-TE;>; w I x <init> ,(Ljava/lang/String;Ljava/util/Comparator;I)V Code LineNumberTable 2(Ljava/lang/String;Ljava/util/Comparator<-TE;>;I)V '(Lhaven/Indir;Ljava/util/Comparator;I)V StackMapTable [ ] ^ N Q _ ?(Lhaven/Indir<Lhaven/Resource;>;Ljava/util/Comparator<-TE;>;I)V &(Lhaven/Indir;Ljava/util/Comparator;)V >(Lhaven/Indir<Lhaven/Resource;>;Ljava/util/Comparator<-TE;>;)V ()Lhaven/Tex; lambda$new$0 (Lhaven/Indir;)Lhaven/Resource; 2<E:Lhaven/res/ui/croster/Entry;>Ljava/lang/Object; 
SourceFile Column.java # ` a b d f g i j k 3       l m n   ! BootstrapMethods o p q r s t u v w haven/Resource x y z } haven/Resource$Tooltip Tooltip InnerClasses ~ y haven/Resource$Image Image   # ( ] s p haven/res/ui/croster/Column java/lang/Object haven/Indir java/util/Comparator java/lang/String ()V haven/CharWnd attrf Foundry Lhaven/Text$Foundry; � haven/Text$Foundry render Line %(Ljava/lang/String;)Lhaven/Text$Line; haven/Text$Line tex haven/UI scale (I)I
 � � ()Ljava/lang/Object;
  � ()Lhaven/Resource; get (Lhaven/Indir;)Lhaven/Indir; haven/Loading waitfor !(Lhaven/Indir;)Ljava/lang/Object; tooltip Ljava/lang/Class; layer � Layer )(Ljava/lang/Class;)Lhaven/Resource$Layer; imgc t 
haven/Text � � � 4 5 haven/Resource$Layer "java/lang/invoke/LambdaMetafactory metafactory � Lookup �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite; � %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles croster.cjava !                            !    " !     # $  %   Q     %*� *� +� � � *� *,� *� � 	�    &       D  E  F  G  H $ I     '  # (  %   �     Q*� +� 
  � � :� � � :*� � � � � *� � � � *,� *� � 	�    )   9 � ;  * + , - .  *�   * + , - .  * / &   "    K  L  M  N 1 O C P H Q P R     0  # 1  %   %     	*+,2� �    &   
    U  V     2   3  %        *� �    &       Y
 4 5  %   "     
*�  � �    &       L  F     G  H I J 7    �     6 S   2    R    V  < e c 	 > e h 	 {  | � � � codeentry 0   pagina haven.res.ui.croster.RosterButton$Fac   