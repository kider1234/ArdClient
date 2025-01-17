Haven Resource 1< src T  Sheep.java /* Preprocessed source code */
/* $use: ui/croster */

import haven.*;
import haven.res.ui.croster.*;
import java.util.*;

public class Sheep extends Entry {
    public int meat, milk, wool;
    public int meatq, milkq, woolq, hideq;
    public int seedq;
    public boolean ram, lamb, dead, pregnant, lactate;

    public Sheep(long id, String name) {
	super(SIZE, id, name);
    }

    public void draw(GOut g) {
	drawbg(g);
	int i = 0;
	drawcol(g, SheepRoster.cols.get(i), 0, this, namerend, i++);
	drawcol(g, SheepRoster.cols.get(i), 0.5, ram,      sex, i++);
	drawcol(g, SheepRoster.cols.get(i), 0.5, lamb,     growth, i++);
	drawcol(g, SheepRoster.cols.get(i), 0.5, dead,     deadrend, i++);
	drawcol(g, SheepRoster.cols.get(i), 0.5, pregnant, pregrend, i++);
	drawcol(g, SheepRoster.cols.get(i), 0.5, lactate,  lactrend, i++);
	drawcol(g, SheepRoster.cols.get(i), 1, q, quality, i++);
	drawcol(g, SheepRoster.cols.get(i), 1, meat, null, i++);
	drawcol(g, SheepRoster.cols.get(i), 1, milk, null, i++);
	drawcol(g, SheepRoster.cols.get(i), 1, wool, null, i++);
	drawcol(g, SheepRoster.cols.get(i), 1, meatq, percent, i++);
	drawcol(g, SheepRoster.cols.get(i), 1, milkq, percent, i++);
	drawcol(g, SheepRoster.cols.get(i), 1, woolq, percent, i++);
	drawcol(g, SheepRoster.cols.get(i), 1, hideq, percent, i++);
	drawcol(g, SheepRoster.cols.get(i), 1, seedq, null, i++);
	super.draw(g);
    }

    public boolean mousedown(Coord c, int button) {
	if(SheepRoster.cols.get(1).hasx(c.x)) {
	    markall(Sheep.class, o -> (o.ram == this.ram));
	    return(true);
	}
	if(SheepRoster.cols.get(2).hasx(c.x)) {
	    markall(Sheep.class, o -> (o.lamb == this.lamb));
	    return(true);
	}
	if(SheepRoster.cols.get(3).hasx(c.x)) {
	    markall(Sheep.class, o -> (o.dead == this.dead));
	    return(true);
	}
	if(SheepRoster.cols.get(4).hasx(c.x)) {
	    markall(Sheep.class, o -> (o.pregnant == this.pregnant));
	    return(true);
	}
	if(SheepRoster.cols.get(5).hasx(c.x)) {
	    markall(Sheep.class, o -> (o.lactate == this.lactate));
	    return(true);
	}
	return(super.mousedown(c, button));
    }
}

/* >wdg: SheepRoster */
src &  SheepRoster.java /* Preprocessed source code */
/* $use: ui/croster */

import haven.*;
import haven.res.ui.croster.*;
import java.util.*;

public class SheepRoster extends CattleRoster<Sheep> {
    public static List<Column> cols = initcols(
	new Column<Entry>("Name", Comparator.comparing((Entry e) -> e.name), 200),

	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/sex", 2),      Comparator.comparing((Sheep e) -> e.ram).reversed(), 20).runon(),
	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/growth", 2),   Comparator.comparing((Sheep e) -> e.lamb).reversed(), 20).runon(),
	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/deadp", 3),    Comparator.comparing((Sheep e) -> e.dead).reversed(), 20).runon(),
	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/pregnant", 2), Comparator.comparing((Sheep e) -> e.pregnant).reversed(), 20).runon(),
	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/lactate", 1),  Comparator.comparing((Sheep e) -> e.lactate).reversed(), 20),

	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/quality", 2), Comparator.comparing((Sheep e) -> e.q).reversed()),

	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/meatquantity", 1), Comparator.comparing((Sheep e) -> e.meat).reversed()),
	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/milkquantity", 1), Comparator.comparing((Sheep e) -> e.milk).reversed()),
	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/woolquantity", 1), Comparator.comparing((Sheep e) -> e.wool).reversed()),

	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/meatquality", 1), Comparator.comparing((Sheep e) -> e.meatq).reversed()),
	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/milkquality", 1), Comparator.comparing((Sheep e) -> e.milkq).reversed()),
	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/woolquality", 1), Comparator.comparing((Sheep e) -> e.woolq).reversed()),
	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/hidequality", 1), Comparator.comparing((Sheep e) -> e.hideq).reversed()),

	new Column<Sheep>(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/breedingquality", 1), Comparator.comparing((Sheep e) -> e.seedq).reversed())
    );
    protected List<Column> cols() {return(cols);}

    public static CattleRoster mkwidget(UI ui, Object... args) {
	return(new SheepRoster());
    }

    public Sheep parse(Object... args) {
	int n = 0;
	long id = (Long)args[n++];
	String name = (String)args[n++];
	Sheep ret = new Sheep(id, name);
	ret.grp = (Integer)args[n++];
	int fl = (Integer)args[n++];
	ret.ram = (fl & 1) != 0;
	ret.lamb = (fl & 2) != 0;
	ret.dead = (fl & 4) != 0;
	ret.pregnant = (fl & 8) != 0;
	ret.lactate = (fl & 16) != 0;
	ret.q = ((Number)args[n++]).doubleValue();
	ret.meat = (Integer)args[n++];
	ret.milk = (Integer)args[n++];
	ret.wool = (Integer)args[n++];
	ret.meatq = (Integer)args[n++];
	ret.milkq = (Integer)args[n++];
	ret.woolq = (Integer)args[n++];
	ret.hideq = (Integer)args[n++];
	ret.seedq = (Integer)args[n++];
	return(ret);
    }

    public TypeButton button() {
	return(typebtn(Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/btn-sheep", 2),
		       Resource.classres(SheepRoster.class).pool.load("gfx/hud/rosters/btn-sheep-d", 2)));
    }
}
code �  Sheep ����   4 �	 & O
 . P
 & Q	 R S T U V	 & W
 & X?�      	 & Y
 Z [	 & \	 & ]	 & ^	 & _	 & `	 & a	 & b	 & c	 & d	 & e
 f g	 & h	 & i
 j k	 & l	 & m	 & n	 & o	 & p	 & q	 & r	 & s
 . t	 u v
  w x   ~
 &   ~  ~  ~  ~
 . � � meat I milk wool meatq milkq woolq hideq seedq ram Z lamb dead pregnant lactate <init> (JLjava/lang/String;)V Code LineNumberTable draw (Lhaven/GOut;)V 	mousedown (Lhaven/Coord;I)Z StackMapTable lambda$mousedown$4 
(LSheep;)Z lambda$mousedown$3 lambda$mousedown$2 lambda$mousedown$1 lambda$mousedown$0 
SourceFile 
Sheep.java � � > � � C � � � � � � haven/res/ui/croster/Column � � � � 8 9 � � � � � : 9 � � ; 9 � � < 9 � � = 9 � � � � � � � � � / 0 � � � 1 0 2 0 3 0 � � 4 0 5 0 6 0 7 0 B C � � 0 � � Sheep BootstrapMethods � � � H � � � � � � � � D E haven/res/ui/croster/Entry SIZE Lhaven/Coord; #(Lhaven/Coord;JLjava/lang/String;)V drawbg SheepRoster cols Ljava/util/List; java/util/List get (I)Ljava/lang/Object; namerend Ljava/util/function/Function; drawcol ](Lhaven/GOut;Lhaven/res/ui/croster/Column;DLjava/lang/Object;Ljava/util/function/Function;I)V java/lang/Boolean valueOf (Z)Ljava/lang/Boolean; sex growth deadrend pregrend lactrend q D java/lang/Double (D)Ljava/lang/Double; quality java/lang/Integer (I)Ljava/lang/Integer; percent haven/Coord x hasx (I)Z
 � � (Ljava/lang/Object;)Z
 & � test '(LSheep;)Ljava/util/function/Predicate; markall 2(Ljava/lang/Class;Ljava/util/function/Predicate;)V
 & �
 & �
 & �
 & � � � � L H K H J H I H G H "java/lang/invoke/LambdaMetafactory metafactory � Lookup InnerClasses �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite; � %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles sheep.cjava ! & .     / 0    1 0    2 0    3 0    4 0    5 0    6 0    7 0    8 9    : 9    ; 9    < 9    = 9     > ?  @   &     
*� -� �    A   
     	   B C  @  I    �*+� =*+� �  � *� �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  � *� � � �� *+� �  � *� � �� *+� �  � *� � �� *+� �  � *� � �� *+� �  � *� � � �� *+� �  � *� � � �� *+� �  � *�  � � �� *+� �  � *� !� � �� *+� �  � *� "� �� *+� #�    A   N         !  C  e  �  �  �  � 	 ' E e �  � !� "� #� $  D E  @       �� �  � +� $� %� *&*� '  � (�� �  � +� $� %� *&*� )  � (�� �  � +� $� %� *&*� *  � (�� �  � +� $� %� *&*� +  � (�� �  � +� $� %� *&*� ,  � (�*+� -�    F    $#### A   B    '  ( " ) $ + : , F - H / ^ 0 j 1 l 3 � 4 � 5 � 7 � 8 � 9 � ; G H  @   4     +� *� � � �    F    @ A       8 I H  @   4     +� *� � � �    F    @ A       4 J H  @   4     +� *� � � �    F    @ A       0 K H  @   4     +� *� � � �    F    @ A       , L H  @   4     +� *� � � �    F    @ A       (  y   4  z  { | } z  { � } z  { � } z  { � } z  { � } M    � �   
  � � � code   SheepRoster ����   4B
 N |	  } ~
  | 
  � � �
  � �
 
 �	  �	  �	  �	  �	  �	  � �
  �	  �	  �	  �	  �	  �	  �	  �	  �	  �
 � �	 � � �
 � � �
  �
  �
 
 �
 � �
 � �	 � � � �   � � �
 ( � �  � � �
 ( �
 ( � �  � �  � �  � �  � �  �
 ( � �  � �  � � 	 � � 
 � �  � �  � �  � �  �
  � � cols Ljava/util/List; 	Signature /Ljava/util/List<Lhaven/res/ui/croster/Column;>; <init> ()V Code LineNumberTable ()Ljava/util/List; 1()Ljava/util/List<Lhaven/res/ui/croster/Column;>; mkwidget B(Lhaven/UI;[Ljava/lang/Object;)Lhaven/res/ui/croster/CattleRoster; parse ([Ljava/lang/Object;)LSheep; StackMapTable ~ � � � button #()Lhaven/res/ui/croster/TypeButton; 1([Ljava/lang/Object;)Lhaven/res/ui/croster/Entry; lambda$static$14 (LSheep;)Ljava/lang/Integer; lambda$static$13 lambda$static$12 lambda$static$11 lambda$static$10 lambda$static$9 lambda$static$8 lambda$static$7 lambda$static$6 (LSheep;)Ljava/lang/Double; lambda$static$5 (LSheep;)Ljava/lang/Boolean; lambda$static$4 lambda$static$3 lambda$static$2 lambda$static$1 lambda$static$0 0(Lhaven/res/ui/croster/Entry;)Ljava/lang/String; <clinit> ,Lhaven/res/ui/croster/CattleRoster<LSheep;>; 
SourceFile SheepRoster.java S T O P SheepRoster java/lang/Long � � java/lang/String Sheep S � java/lang/Integer � � � � � � � � � � � � � � java/lang/Number � � � � � � � � � � � � � � � � � � � � � � � � � gfx/hud/rosters/btn-sheep � � � gfx/hud/rosters/btn-sheep-d � � [ \ �  � � haven/res/ui/croster/Column Name BootstrapMethods	
 w S gfx/hud/rosters/sex q S gfx/hud/rosters/growth gfx/hud/rosters/deadp gfx/hud/rosters/pregnant gfx/hud/rosters/lactate gfx/hud/rosters/quality o S gfx/hud/rosters/meatquantity f gfx/hud/rosters/milkquantity gfx/hud/rosters/woolquantity gfx/hud/rosters/meatquality  gfx/hud/rosters/milkquality! gfx/hud/rosters/woolquality" gfx/hud/rosters/hidequality# gfx/hud/rosters/breedingquality$%& !haven/res/ui/croster/CattleRoster [Ljava/lang/Object; 	longValue ()J (JLjava/lang/String;)V intValue ()I grp I ram Z lamb dead pregnant lactate doubleValue ()D q D meat milk wool meatq milkq woolq hideq seedq haven/Resource classres #(Ljava/lang/Class;)Lhaven/Resource; pool Pool InnerClasses Lhaven/Resource$Pool; haven/Resource$Pool load' Named +(Ljava/lang/String;I)Lhaven/Resource$Named; typebtn =(Lhaven/Indir;Lhaven/Indir;)Lhaven/res/ui/croster/TypeButton; valueOf (I)Ljava/lang/Integer; java/lang/Double (D)Ljava/lang/Double; java/lang/Boolean (Z)Ljava/lang/Boolean; haven/res/ui/croster/Entry name Ljava/lang/String;
() &(Ljava/lang/Object;)Ljava/lang/Object;
 * apply ()Ljava/util/function/Function; java/util/Comparator 	comparing 5(Ljava/util/function/Function;)Ljava/util/Comparator; ,(Ljava/lang/String;Ljava/util/Comparator;I)V
 + reversed ()Ljava/util/Comparator; '(Lhaven/Indir;Ljava/util/Comparator;I)V runon ()Lhaven/res/ui/croster/Column;
 ,
 -
 .
 /
 0 &(Lhaven/Indir;Ljava/util/Comparator;)V
 1
 2
 3
 4
 5
 6
 7
 8 initcols 0([Lhaven/res/ui/croster/Column;)Ljava/util/List; haven/Resource$Named9:= v w u q t q s q r q p q n o m f l f k f j f i f h f g f e f "java/lang/invoke/LambdaMetafactory metafactory? Lookup �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;@ %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles sheep.cjava !  N    	 O P  Q    R   S T  U        *� �    V       @  O W  U        � �    V       W Q    X � Y Z  U         � Y� �    V       Z � [ \  U  S    8=+�2� � B+�2� :� Y!� 	:+�2� 
� � +�2� 
� 6~� � � ~� � � ~� � � ~� � � ~� � � +�2� � � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � �    ]   � 
� R  ^ _ ` a  a�    ^ _ ` a  aO a�    ^ _ ` a  aO a�    ^ _ ` a  aP a�    ^ _ ` a  aP a�    ^ _ ` a  a V   V    ^  _  `  a & b 7 c E d V e g f x g � h � i � j � k � l � m � n o p$ q5 r  b c  U   @      � � �  � � !�  � "�    V       v  w  vA [ d  U        *+� #�    V       @
 e f  U         *� � $�    V       U
 g f  U         *� � $�    V       S
 h f  U         *� � $�    V       R
 i f  U         *� � $�    V       Q
 j f  U         *� � $�    V       P
 k f  U         *� � $�    V       N
 l f  U         *� � $�    V       M
 m f  U         *� � $�    V       L
 n o  U         *� � %�    V       J
 p q  U         *� � &�    V       H
 r q  U         *� � &�    V       G
 s q  U         *� � &�    V       F
 t q  U         *� � &�    V       E
 u q  U         *� � &�    V       D
 v w  U        *� '�    V       B  x T  U  �     H� (Y� (Y)� *  � + ȷ ,SY� (Y� � -�  � .  � +� / � 0� 1SY� (Y� � 2�  � 3  � +� / � 0� 1SY� (Y� � 4�  � 5  � +� / � 0� 1SY� (Y� � 6�  � 7  � +� / � 0� 1SY� (Y� � 8�  � 9  � +� / � 0SY� (Y� � :�  � ;  � +� / � <SY� (Y� � =�  � >  � +� / � <SY� (Y� � ?�  � @  � +� / � <SY	� (Y� � A�  � B  � +� / � <SY
� (Y� � C�  � D  � +� / � <SY� (Y� � E�  � F  � +� / � <SY� (Y� � G�  � H  � +� / � <SY� (Y� � I�  � J  � +� / � <SY� (Y� � K�  � L  � +� / � <S� M� �    V   F    A  B $ D N E x F � G � H � J L@ Mf N� P� Q� R� S$ UA A  �   �  �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � z   A Q    y �     � � � 	 � � �	;>< codeentry "   wdg SheepRoster   ui/croster G  