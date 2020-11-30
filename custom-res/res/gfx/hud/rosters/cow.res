Haven Resource 1 src \  Ochs.java /* Preprocessed source code */
/* $use: ui/croster */

import haven.*;
import haven.res.ui.croster.*;
import java.util.*;

public class Ochs extends Entry {
    public int meat, milk;
    public int meatq, milkq, hideq;
    public int seedq;

    public Ochs(long id, String name) {
	super(SIZE, id, name);
    }

    public void draw(GOut g) {
	drawbg(g);
	drawcol(g, CowRoster.cols.get(0), 0, name, null, 0);
	drawcol(g, CowRoster.cols.get(1), 1, q, quality, 1);
	drawcol(g, CowRoster.cols.get(2), 1, meat, null, 2);
	drawcol(g, CowRoster.cols.get(3), 1, milk, null, 3);
	drawcol(g, CowRoster.cols.get(4), 1, meatq, percent, 4);
	drawcol(g, CowRoster.cols.get(5), 1, milkq, percent, 5);
	drawcol(g, CowRoster.cols.get(6), 1, hideq, percent, 6);
	drawcol(g, CowRoster.cols.get(7), 1, seedq, null, 7);
	super.draw(g);
    }
}

/* >wdg: CowRoster */
src z  CowRoster.java /* Preprocessed source code */
/* $use: ui/croster */

import haven.*;
import haven.res.ui.croster.*;
import java.util.*;

public class CowRoster extends CattleRoster<Ochs> {
    public static List<Column> cols = initcols(
	new Column<Entry>("Name", Comparator.comparing((Entry e) -> e.name), 200),

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
code B  Ochs ����   4 Y	  &
  '
  (	 ) * + , -	  .
  /	  0
 1 2	  3	  4
 5 6	  7	  8	  9	  :	  ;	  <
  = > ? meat I milk meatq milkq hideq seedq <init> (JLjava/lang/String;)V Code LineNumberTable draw (Lhaven/GOut;)V 
SourceFile 	Ochs.java @ A  B C # D E F G H I haven/res/ui/croster/Column J K L M N O P Q R S T   U Q V     W T       " # Ochs haven/res/ui/croster/Entry SIZE Lhaven/Coord; #(Lhaven/Coord;JLjava/lang/String;)V drawbg 	CowRoster cols Ljava/util/List; java/util/List get (I)Ljava/lang/Object; name Ljava/lang/String; drawcol ](Lhaven/GOut;Lhaven/res/ui/croster/Column;DLjava/lang/Object;Ljava/util/function/Function;I)V q D java/lang/Double valueOf (D)Ljava/lang/Double; quality Ljava/util/function/Function; java/lang/Integer (I)Ljava/lang/Integer; percent 	cow.cjava !                                             &     
*� -� �    !   
     	   " #     ,     �*+� *+� �  � *� � *+� �  � *� 	� 
� � *+� �  � *� � � *+� �  � *� � � *+� �  � *� � � � *+� �  � *� � � � *+� �  � *� � � � *+� �  � *� � � *+� �    !   .         :  U  p  �  �  �  �  �   $    Xcode b  CowRoster ����   4 �
 5 V	  W X
  V Y
  Z [ \
  ] ^
 
 _	  ` a
  b	  c	  d	  e	  f	  g	  h
 i j	 i k l
 m n o
  p
  q
  r
 s t	 u v w x   ~  �
  � �  ~  �
  � �  ~ �  ~ �  ~ �  ~ �  ~ �  ~
  � � cols Ljava/util/List; 	Signature /Ljava/util/List<Lhaven/res/ui/croster/Column;>; <init> ()V Code LineNumberTable ()Ljava/util/List; 1()Ljava/util/List<Lhaven/res/ui/croster/Column;>; mkwidget B(Lhaven/UI;[Ljava/lang/Object;)Lhaven/res/ui/croster/CattleRoster; parse ([Ljava/lang/Object;)LOchs; button #()Lhaven/res/ui/croster/TypeButton; 1([Ljava/lang/Object;)Lhaven/res/ui/croster/Entry; lambda$static$7 (LOchs;)Ljava/lang/Integer; lambda$static$6 lambda$static$5 lambda$static$4 lambda$static$3 lambda$static$2 lambda$static$1 (LOchs;)Ljava/lang/Double; lambda$static$0 0(Lhaven/res/ui/croster/Entry;)Ljava/lang/String; <clinit> +Lhaven/res/ui/croster/CattleRoster<LOchs;>; 
SourceFile CowRoster.java : ; 6 7 	CowRoster java/lang/Long � � java/lang/String Ochs : � java/lang/Number � � � � java/lang/Integer � � � � � � � � � � � � � � � � � � � gfx/hud/rosters/btn-cow � � � gfx/hud/rosters/btn-cow-d � � B C � � � � � � � � haven/res/ui/croster/Column Name BootstrapMethods � � � Q � � � � � : � gfx/hud/rosters/quality � O � � : � gfx/hud/rosters/meatquantity � H gfx/hud/rosters/milkquantity � gfx/hud/rosters/meatquality � gfx/hud/rosters/milkquality � gfx/hud/rosters/hidequality � gfx/hud/rosters/breedingquality � � � !haven/res/ui/croster/CattleRoster 	longValue ()J (JLjava/lang/String;)V doubleValue ()D q D intValue ()I meat I milk meatq milkq hideq seedq haven/Resource classres #(Ljava/lang/Class;)Lhaven/Resource; pool Pool InnerClasses Lhaven/Resource$Pool; haven/Resource$Pool load � Named +(Ljava/lang/String;I)Lhaven/Resource$Named; typebtn =(Lhaven/Indir;Lhaven/Indir;)Lhaven/res/ui/croster/TypeButton; valueOf (I)Ljava/lang/Integer; java/lang/Double (D)Ljava/lang/Double; haven/res/ui/croster/Entry name Ljava/lang/String;
 � � &(Ljava/lang/Object;)Ljava/lang/Object;
  � apply ()Ljava/util/function/Function; java/util/Comparator 	comparing 5(Ljava/util/function/Function;)Ljava/util/Comparator; ,(Ljava/lang/String;Ljava/util/Comparator;I)V
  � reversed ()Ljava/util/Comparator; &(Lhaven/Indir;Ljava/util/Comparator;)V
  �
  �
  �
  �
  �
  � initcols 0([Lhaven/res/ui/croster/Column;)Ljava/util/List; haven/Resource$Named � � � P Q N O M H L H K H J H I H G H "java/lang/invoke/LambdaMetafactory metafactory � Lookup �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite; � %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles 	cow.cjava !  5    	 6 7  8    9   : ;  <        *� �    =         6 >  <        � �    =       . 8    ? � @ A  <         � Y� �    =       1 � B C  <   �     �=+�2� � B+�2� :� Y!� 	:+�2� 
� � +�2� � � +�2� � � +�2� � � +�2� � � +�2� � � +�2� � � �    =   2    5  6  7  8 & 9 7 : H ; Y < j = { > � ? � @  D E  <   @      � � � � � � � �    =       D  E  DA B F  <        *+� �    =       
 G H  <         *� � �    =       ,
 I H  <         *� � �    =       *
 J H  <         *� � �    =       )
 K H  <         *� � �    =       (
 L H  <         *� � �    =       &
 M H  <         *� � �    =       %
 N O  <         *� � �    =       #
 P Q  <        *� �    =       !  R ;  <  d     (� Y� Y � !  � " ȷ #SY� Y� � $� � %  � "� & � 'SY� Y� � (� � )  � "� & � 'SY� Y� � *� � +  � "� & � 'SY� Y� � ,� � -  � "� & � 'SY� Y� � .� � /  � "� & � 'SY� Y� � 0� � 1  � "� & � 'SY� Y� � 2� � 3  � "� & � 'S� 4� �    =   * 
      ! $ # I % n & � ( � ) � * ,!    y   R  z  { | } z  { � � z  { � � z  { � � z  { � � z  { � � z  { � � z  { � � T    � 8    S �     m i � 	 � i �	 � � � codeentry     wdg CowRoster   ui/croster   