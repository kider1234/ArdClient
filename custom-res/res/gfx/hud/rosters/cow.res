Haven Resource 1G src �  Ochs.java /* Preprocessed source code */
/* $use: ui/croster */

import haven.*;
import haven.res.ui.croster.*;
import java.util.*;

public class Ochs extends Entry {
    public int meat, milk;
    public int meatq, milkq, hideq;
    public int seedq;
    public boolean bull, calf, dead, pregnant, lactate;

    public Ochs(long id, String name) {
	super(SIZE, id, name);
    }

    public void draw(GOut g) {
	drawbg(g);
	int i = 0;
	drawcol(g, CowRoster.cols.get(i), 0, this, namerend, i++);
	drawcol(g, CowRoster.cols.get(i), 0.5, bull, sex, i++);
	drawcol(g, CowRoster.cols.get(i), 0.5, calf, growth, i++);
	drawcol(g, CowRoster.cols.get(i), 0.5, dead, deadrend, i++);
	drawcol(g, CowRoster.cols.get(i), 0.5, pregnant, pregrend, i++);
	drawcol(g, CowRoster.cols.get(i), 0.5, lactate, lactrend, i++);
	drawcol(g, CowRoster.cols.get(i), 1, q, quality, i++);
	drawcol(g, CowRoster.cols.get(i), 1, meat, null, i++);
	drawcol(g, CowRoster.cols.get(i), 1, milk, null, i++);
	drawcol(g, CowRoster.cols.get(i), 1, meatq, percent, i++);
	drawcol(g, CowRoster.cols.get(i), 1, milkq, percent, i++);
	drawcol(g, CowRoster.cols.get(i), 1, hideq, percent, i++);
	drawcol(g, CowRoster.cols.get(i), 1, seedq, null, i++);
	super.draw(g);
    }

    public boolean mousedown(Coord c, int button) {
	if(CowRoster.cols.get(1).hasx(c.x)) {
	    markall(Ochs.class, o -> (o.bull == this.bull));
	    return(true);
	}
	if(CowRoster.cols.get(2).hasx(c.x)) {
	    markall(Ochs.class, o -> (o.calf == this.calf));
	    return(true);
	}
	if(CowRoster.cols.get(3).hasx(c.x)) {
	    markall(Ochs.class, o -> (o.dead == this.dead));
	    return(true);
	}
	if(CowRoster.cols.get(4).hasx(c.x)) {
	    markall(Ochs.class, o -> (o.pregnant == this.pregnant));
	    return(true);
	}
	if(CowRoster.cols.get(5).hasx(c.x)) {
	    markall(Ochs.class, o -> (o.lactate == this.lactate));
	    return(true);
	}
	return(super.mousedown(c, button));
    }
}

/* >wdg: CowRoster */
src k  CowRoster.java /* Preprocessed source code */
/* $use: ui/croster */

import haven.*;
import haven.res.ui.croster.*;
import java.util.*;

public class CowRoster extends CattleRoster<Ochs> {
    public static List<Column> cols = initcols(
	new Column<Entry>("Name", Comparator.comparing((Entry e) -> e.name), 200),

	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/sex", 2),      Comparator.comparing((Ochs e) -> e.bull).reversed(), 20).runon(),
	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/growth", 2),   Comparator.comparing((Ochs e) -> e.calf).reversed(), 20).runon(),
	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/deadp", 3),    Comparator.comparing((Ochs e) -> e.dead).reversed(), 20).runon(),
	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/pregnant", 2), Comparator.comparing((Ochs e) -> e.pregnant).reversed(), 20).runon(),
	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/lactate", 1),  Comparator.comparing((Ochs e) -> e.lactate).reversed(), 20),

	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/quality", 2), Comparator.comparing((Ochs e) -> e.q).reversed()),

	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/meatquantity", 1), Comparator.comparing((Ochs e) -> e.meat).reversed()),
	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/milkquantity", 1), Comparator.comparing((Ochs e) -> e.milk).reversed()),

	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/meatquality", 1), Comparator.comparing((Ochs e) -> e.meatq).reversed()),
	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/milkquality", 1), Comparator.comparing((Ochs e) -> e.milkq).reversed()),
	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/hidequality", 1), Comparator.comparing((Ochs e) -> e.hideq).reversed()),

	new Column<Ochs>(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/breedingquality", 1), Comparator.comparing((Ochs e) -> e.seedq).reversed())
    );
    protected List<Column> cols() {return(cols);}

    public static CattleRoster mkwidget(UI ui, Object... args) {
	return(new CowRoster());
    }

    public Ochs parse(Object... args) {
	int n = 0;
	long id = (Long)args[n++];
	String name = (String)args[n++];
	Ochs ret = new Ochs(id, name);
	ret.grp = (Integer)args[n++];
	int fl = (Integer)args[n++];
	ret.bull = (fl & 1) != 0;
	ret.calf = (fl & 2) != 0;
	ret.dead = (fl & 4) != 0;
	ret.pregnant = (fl & 8) != 0;
	ret.lactate = (fl & 16) != 0;
	ret.q = ((Number)args[n++]).doubleValue();
	ret.meat = (Integer)args[n++];
	ret.milk = (Integer)args[n++];
	ret.meatq = (Integer)args[n++];
	ret.milkq = (Integer)args[n++];
	ret.hideq = (Integer)args[n++];
	ret.seedq = (Integer)args[n++];
	return(ret);
    }

    public TypeButton button() {
	return(typebtn(Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/btn-cow", 2),
		       Resource.classres(CowRoster.class).pool.load("gfx/hud/rosters/btn-cow-d", 2)));
    }
}
code a  Ochs ����   4 �	 $ K
 , L
 $ M	 N O P Q R	 $ S
 $ T?�      	 $ U
 V W	 $ X	 $ Y	 $ Z	 $ [	 $ \	 $ ]	 $ ^	 $ _	 $ `	 $ a
 b c	 $ d	 $ e
 f g	 $ h	 $ i	 $ j	 $ k	 $ l	 $ m
 , n	 o p
  q r   x
 $ y  x  x  x  x
 , ~  meat I milk meatq milkq hideq seedq bull Z calf dead pregnant lactate <init> (JLjava/lang/String;)V Code LineNumberTable draw (Lhaven/GOut;)V 	mousedown (Lhaven/Coord;I)Z StackMapTable lambda$mousedown$4 	(LOchs;)Z lambda$mousedown$3 lambda$mousedown$2 lambda$mousedown$1 lambda$mousedown$0 
SourceFile 	Ochs.java � � : � � ? � � � � � � haven/res/ui/croster/Column � � � � 4 5 � � � � � 6 5 � � 7 5 � � 8 5 � � 9 5 � � � � � � � � � - . � � � / . 0 . � � 1 . 2 . 3 . > ? � � . � � Ochs BootstrapMethods � � � D � � � � � � � � @ A haven/res/ui/croster/Entry SIZE Lhaven/Coord; #(Lhaven/Coord;JLjava/lang/String;)V drawbg 	CowRoster cols Ljava/util/List; java/util/List get (I)Ljava/lang/Object; namerend Ljava/util/function/Function; drawcol ](Lhaven/GOut;Lhaven/res/ui/croster/Column;DLjava/lang/Object;Ljava/util/function/Function;I)V java/lang/Boolean valueOf (Z)Ljava/lang/Boolean; sex growth deadrend pregrend lactrend q D java/lang/Double (D)Ljava/lang/Double; quality java/lang/Integer (I)Ljava/lang/Integer; percent haven/Coord x hasx (I)Z
 � � (Ljava/lang/Object;)Z
 $ � test &(LOchs;)Ljava/util/function/Predicate; markall 2(Ljava/lang/Class;Ljava/util/function/Predicate;)V
 $ �
 $ �
 $ �
 $ � � � � H D G D F D E D C D "java/lang/invoke/LambdaMetafactory metafactory � Lookup InnerClasses �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite; � %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles 	cow.cjava ! $ ,     - .    / .    0 .    1 .    2 .    3 .    4 5    6 5    7 5    8 5    9 5     : ;  <   &     
*� -� �    =   
     	   > ?  <      �*+� =*+� �  � *� �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  � *� � � �� *+� �  � *� � �� *+� �  � *� � �� *+� �  � *� � � �� *+� �  � *� � � �� *+� �  � *� � � �� *+� �  � *�  � �� *+� !�    =   F         !  C  e  �  �  �  � 	 ' G g �  � !� "  @ A  <       �� �  � +� "� #� *$*� %  � &�� �  � +� "� #� *$*� '  � &�� �  � +� "� #� *$*� (  � &�� �  � +� "� #� *$*� )  � &�� �  � +� "� #� *$*� *  � &�*+� +�    B    $#### =   B    %  & " ' $ ) : * F + H - ^ . j / l 1 � 2 � 3 � 5 � 6 � 7 � 9 C D  <   4     +� *� � � �    B    @ =       6 E D  <   4     +� *� � � �    B    @ =       2 F D  <   4     +� *� � � �    B    @ =       . G D  <   4     +� *� � � �    B    @ =       * H D  <   4     +� *� � � �    B    @ =       &  s   4  t  u v w t  u z w t  u { w t  u | w t  u } w I    � �   
  � � � code S  CowRoster ����   4.
 H t	  u v
  t w
  x y z
  { |
 
 }	  ~	  	  �	  �	  �	  � �
  �	  �	  �	  �	  �	  �	  �	  �
 � �	 � � �
 � � �
  �
  �
 
 �
 � �
 � �	 � � � �   � � �
 & � �  � � �
 & �
 & � �  � �  � �  � �  � �  �
 & � �  � �  � � 	 � � 
 � �  � �  �
  � � cols Ljava/util/List; 	Signature /Ljava/util/List<Lhaven/res/ui/croster/Column;>; <init> ()V Code LineNumberTable ()Ljava/util/List; 1()Ljava/util/List<Lhaven/res/ui/croster/Column;>; mkwidget B(Lhaven/UI;[Ljava/lang/Object;)Lhaven/res/ui/croster/CattleRoster; parse ([Ljava/lang/Object;)LOchs; StackMapTable v � y z button #()Lhaven/res/ui/croster/TypeButton; 1([Ljava/lang/Object;)Lhaven/res/ui/croster/Entry; lambda$static$12 (LOchs;)Ljava/lang/Integer; lambda$static$11 lambda$static$10 lambda$static$9 lambda$static$8 lambda$static$7 lambda$static$6 (LOchs;)Ljava/lang/Double; lambda$static$5 (LOchs;)Ljava/lang/Boolean; lambda$static$4 lambda$static$3 lambda$static$2 lambda$static$1 lambda$static$0 0(Lhaven/res/ui/croster/Entry;)Ljava/lang/String; <clinit> +Lhaven/res/ui/croster/CattleRoster<LOchs;>; 
SourceFile CowRoster.java M N I J 	CowRoster java/lang/Long � � java/lang/String Ochs M � java/lang/Integer � � � � � � � � � � � � � � java/lang/Number � � � � � � � � � � � � � � � � � � � � � gfx/hud/rosters/btn-cow � � � gfx/hud/rosters/btn-cow-d � � U V � � � � � � � � � � � haven/res/ui/croster/Column Name BootstrapMethods � � � o � � � � � M  gfx/hud/rosters/sex i M gfx/hud/rosters/growth gfx/hud/rosters/deadp gfx/hud/rosters/pregnant	 gfx/hud/rosters/lactate
 gfx/hud/rosters/quality g M gfx/hud/rosters/meatquantity ` gfx/hud/rosters/milkquantity gfx/hud/rosters/meatquality gfx/hud/rosters/milkquality gfx/hud/rosters/hidequality gfx/hud/rosters/breedingquality !haven/res/ui/croster/CattleRoster [Ljava/lang/Object; 	longValue ()J (JLjava/lang/String;)V intValue ()I grp I bull Z calf dead pregnant lactate doubleValue ()D q D meat milk meatq milkq hideq seedq haven/Resource classres #(Ljava/lang/Class;)Lhaven/Resource; pool Pool InnerClasses Lhaven/Resource$Pool; haven/Resource$Pool load Named +(Ljava/lang/String;I)Lhaven/Resource$Named; typebtn =(Lhaven/Indir;Lhaven/Indir;)Lhaven/res/ui/croster/TypeButton; valueOf (I)Ljava/lang/Integer; java/lang/Double (D)Ljava/lang/Double; java/lang/Boolean (Z)Ljava/lang/Boolean; haven/res/ui/croster/Entry name Ljava/lang/String;
 &(Ljava/lang/Object;)Ljava/lang/Object;
  apply ()Ljava/util/function/Function; java/util/Comparator 	comparing 5(Ljava/util/function/Function;)Ljava/util/Comparator; ,(Ljava/lang/String;Ljava/util/Comparator;I)V
  reversed ()Ljava/util/Comparator; '(Lhaven/Indir;Ljava/util/Comparator;I)V runon ()Lhaven/res/ui/croster/Column;
 
 
 
 
  &(Lhaven/Indir;Ljava/util/Comparator;)V
 
  
 !
 "
 #
 $ initcols 0([Lhaven/res/ui/croster/Column;)Ljava/util/List; haven/Resource$Named%&) n o m i l i k i j i h i f g e ` d ` c ` b ` a ` _ ` "java/lang/invoke/LambdaMetafactory metafactory+ Lookup �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;, %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles 	cow.cjava !  H    	 I J  K    L   M N  O        *� �    P       >  I Q  O        � �    P       S K    R � S T  O         � Y� �    P       V � U V  O  )    =+�2� � B+�2� :� Y!� 	:+�2� 
� � +�2� 
� 6~� � � ~� � � ~� � � ~� � � ~� � � +�2� � � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � �    W   � 
� R  X Y Z [  [�    X Y Z [  [O [�    X Y Z [  [O [�    X Y Z [  [P [�    X Y Z [  [P [�    X Y Z [  [ P   N    Z  [  \  ] & ^ 7 _ E ` V a g b x c � d � e � f � g � h � i � j k l  \ ]  O   @      � � � � � � �  �    P       p  q  pA U ^  O        *+� !�    P       >
 _ `  O         *� � "�    P       Q
 a `  O         *� � "�    P       O
 b `  O         *� � "�    P       N
 c `  O         *� � "�    P       M
 d `  O         *� � "�    P       K
 e `  O         *� � "�    P       J
 f g  O         *� � #�    P       H
 h i  O         *� � $�    P       F
 j i  O         *� � $�    P       E
 k i  O         *� � $�    P       D
 l i  O         *� � $�    P       C
 m i  O         *� � $�    P       B
 n o  O        *� %�    P       @  p N  O  L     �� &Y� &Y'� (  � ) ȷ *SY� &Y� � +� � ,  � )� - � .� /SY� &Y� � 0� � 1  � )� - � .� /SY� &Y� � 2� � 3  � )� - � .� /SY� &Y� � 4� � 5  � )� - � .� /SY� &Y� � 6� � 7  � )� - � .SY� &Y� � 8� � 9  � )� - � :SY� &Y� � ;� � <  � )� - � :SY� &Y� � =� � >  � )� - � :SY	� &Y� � ?� � @  � )� - � :SY
� &Y� � A� � B  � )� - � :SY� &Y� � C� � D  � )� - � :SY� &Y� � E� � F  � )� - � :S� G� �    P   >    ?  @ $ B N C x D � E � F � H J@ Kf M� N� O� Q� ?  �   �  �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � r   - K    q �     � � � 	 � � �	'*( codeentry     wdg CowRoster   ui/croster G  