Haven Resource 1; src �  Horse.java /* Preprocessed source code */
/* $use: ui/croster */

import haven.*;
import haven.res.ui.croster.*;
import java.util.*;

public class Horse extends Entry {
    public int meat, milk;
    public int meatq, milkq, hideq;
    public int seedq;
    public int end, stam, mb;
    public boolean stallion, foal, dead, pregnant, lactate;

    public Horse(long id, String name) {
	super(SIZE, id, name);
    }

    public void draw(GOut g) {
	drawbg(g);
	int i = 0;
	drawcol(g, HorseRoster.cols.get(i), 0, this, namerend, i++);
	drawcol(g, HorseRoster.cols.get(i), 0.5, stallion, sex, i++);
	drawcol(g, HorseRoster.cols.get(i), 0.5, foal,     growth, i++);
	drawcol(g, HorseRoster.cols.get(i), 0.5, dead,     deadrend, i++);
	drawcol(g, HorseRoster.cols.get(i), 0.5, pregnant, pregrend, i++);
	drawcol(g, HorseRoster.cols.get(i), 0.5, lactate,  lactrend, i++);
	drawcol(g, HorseRoster.cols.get(i), 1, q, quality, i++);
	drawcol(g, HorseRoster.cols.get(i), 1, end, null, i++);
	drawcol(g, HorseRoster.cols.get(i), 1, stam, null, i++);
	drawcol(g, HorseRoster.cols.get(i), 1, mb, null, i++);
	drawcol(g, HorseRoster.cols.get(i), 1, meat, null, i++);
	drawcol(g, HorseRoster.cols.get(i), 1, milk, null, i++);
	drawcol(g, HorseRoster.cols.get(i), 1, meatq, percent, i++);
	drawcol(g, HorseRoster.cols.get(i), 1, milkq, percent, i++);
	drawcol(g, HorseRoster.cols.get(i), 1, hideq, percent, i++);
	drawcol(g, HorseRoster.cols.get(i), 1, seedq, null, i++);
	super.draw(g);
    }

    public boolean mousedown(Coord c, int button) {
	if(HorseRoster.cols.get(1).hasx(c.x)) {
	    markall(Horse.class, o -> (o.stallion == this.stallion));
	    return(true);
	}
	if(HorseRoster.cols.get(2).hasx(c.x)) {
	    markall(Horse.class, o -> (o.foal == this.foal));
	    return(true);
	}
	if(HorseRoster.cols.get(3).hasx(c.x)) {
	    markall(Horse.class, o -> (o.dead == this.dead));
	    return(true);
	}
	if(HorseRoster.cols.get(4).hasx(c.x)) {
	    markall(Horse.class, o -> (o.pregnant == this.pregnant));
	    return(true);
	}
	if(HorseRoster.cols.get(5).hasx(c.x)) {
	    markall(Horse.class, o -> (o.lactate == this.lactate));
	    return(true);
	}
	return(super.mousedown(c, button));
    }
}

/* >wdg: HorseRoster */
src �  HorseRoster.java /* Preprocessed source code */
/* $use: ui/croster */

import haven.*;
import haven.res.ui.croster.*;
import java.util.*;

public class HorseRoster extends CattleRoster<Horse> {
    public static List<Column> cols = initcols(
	new Column<Entry>("Name", Comparator.comparing((Entry e) -> e.name), 200),

	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/sex", 2),      Comparator.comparing((Horse e) -> e.stallion).reversed(), 20).runon(),
	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/growth", 2),   Comparator.comparing((Horse e) -> e.foal).reversed(), 20).runon(),
	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/deadp", 3),    Comparator.comparing((Horse e) -> e.dead).reversed(), 20).runon(),
	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/pregnant", 2), Comparator.comparing((Horse e) -> e.pregnant).reversed(), 20).runon(),
	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/lactate", 1),  Comparator.comparing((Horse e) -> e.lactate).reversed(), 20),

	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/quality", 2), Comparator.comparing((Horse e) -> e.q).reversed()),

	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/endurance", 1), Comparator.comparing((Horse e) -> e.end).reversed()),
	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/stamina", 1), Comparator.comparing((Horse e) -> e.stam).reversed()),
	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/metabolism", 1), Comparator.comparing((Horse e) -> e.mb).reversed()),

	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/meatquantity", 1), Comparator.comparing((Horse e) -> e.meat).reversed()),
	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/milkquantity", 1), Comparator.comparing((Horse e) -> e.milk).reversed()),

	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/meatquality", 1), Comparator.comparing((Horse e) -> e.meatq).reversed()),
	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/milkquality", 1), Comparator.comparing((Horse e) -> e.milkq).reversed()),
	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/hidequality", 1), Comparator.comparing((Horse e) -> e.hideq).reversed()),

	new Column<Horse>(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/breedingquality", 1), Comparator.comparing((Horse e) -> e.seedq).reversed())
    );
    protected List<Column> cols() {return(cols);}

    public static CattleRoster mkwidget(UI ui, Object... args) {
	return(new HorseRoster());
    }

    public Horse parse(Object... args) {
	int n = 0;
	long id = (Long)args[n++];
	String name = (String)args[n++];
	Horse ret = new Horse(id, name);
	ret.grp = (Integer)args[n++];
	int fl = (Integer)args[n++];
	ret.stallion = (fl & 1) != 0;
	ret.foal = (fl & 2) != 0;
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
	ret.end = (Integer)args[n++];
	ret.stam = (Integer)args[n++];
	ret.mb = (Integer)args[n++];
	return(ret);
    }

    public TypeButton button() {
	return(typebtn(Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/btn-horse", 2),
		       Resource.classres(HorseRoster.class).pool.load("gfx/hud/rosters/btn-horse-d", 2)));
    }
}
code   Horse ����   4 �	 ' Q
 / R
 ' S	 T U V W X	 ' Y
 ' Z?�      	 ' [
 \ ]	 ' ^	 ' _	 ' `	 ' a	 ' b	 ' c	 ' d	 ' e	 ' f	 ' g
 h i	 ' j	 ' k
 l m	 ' n	 ' o	 ' p	 ' q	 ' r	 ' s	 ' t	 ' u	 ' v
 / w	 x y
  z {   �
 ' �  �  �  �  �
 / � � meat I milk meatq milkq hideq seedq end stam mb stallion Z foal dead pregnant lactate <init> (JLjava/lang/String;)V Code LineNumberTable draw (Lhaven/GOut;)V 	mousedown (Lhaven/Coord;I)Z StackMapTable lambda$mousedown$4 
(LHorse;)Z lambda$mousedown$3 lambda$mousedown$2 lambda$mousedown$1 lambda$mousedown$0 
SourceFile 
Horse.java � � @ � � E � � � � � � haven/res/ui/croster/Column � � � � : ; � � � � � < ; � � = ; � � > ; � � ? ; � � � � � � � � � 7 1 � � � 8 1 9 1 0 1 2 1 3 1 � � 4 1 5 1 6 1 D E � � 1 � � Horse BootstrapMethods � � � J � � � � � � � � F G haven/res/ui/croster/Entry SIZE Lhaven/Coord; #(Lhaven/Coord;JLjava/lang/String;)V drawbg HorseRoster cols Ljava/util/List; java/util/List get (I)Ljava/lang/Object; namerend Ljava/util/function/Function; drawcol ](Lhaven/GOut;Lhaven/res/ui/croster/Column;DLjava/lang/Object;Ljava/util/function/Function;I)V java/lang/Boolean valueOf (Z)Ljava/lang/Boolean; sex growth deadrend pregrend lactrend q D java/lang/Double (D)Ljava/lang/Double; quality java/lang/Integer (I)Ljava/lang/Integer; percent haven/Coord x hasx (I)Z
 � � (Ljava/lang/Object;)Z
 ' � test '(LHorse;)Ljava/util/function/Predicate; markall 2(Ljava/lang/Class;Ljava/util/function/Predicate;)V
 ' �
 ' �
 ' �
 ' � � � � N J M J L J K J I J "java/lang/invoke/LambdaMetafactory metafactory � Lookup InnerClasses �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite; � %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles horse.cjava ! ' /     0 1    2 1    3 1    4 1    5 1    6 1    7 1    8 1    9 1    : ;    < ;    = ;    > ;    ? ;     @ A  B   &     
*� -� �    C   
     	   D E  B  i    *+� =*+� �  � *� �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  � *� � � �� *+� �  � *� � �� *+� �  � *� � �� *+� �  � *� � �� *+� �  � *� � �� *+� �  � *� � �� *+� �  � *� � �  �� *+� �  � *� !� �  �� *+� �  � *� "� �  �� *+� �  � *� #� �� *+� $�    C   R         !  C  e  �  �  �  � 	 ' E c  � !� "� #� $� % &  F G  B       �� �  � +� %� &� *'*� (  � )�� �  � +� %� &� *'*� *  � )�� �  � +� %� &� *'*� +  � )�� �  � +� %� &� *'*� ,  � )�� �  � +� %� &� *'*� -  � )�*+� .�    H    $#### C   B    )  * " + $ - : . F / H 1 ^ 2 j 3 l 5 � 6 � 7 � 9 � : � ; � = I J  B   4     +� *� � � �    H    @ C       : K J  B   4     +� *� � � �    H    @ C       6 L J  B   4     +� *� � � �    H    @ C       2 M J  B   4     +� *� � � �    H    @ C       . N J  B   4     +� *� � � �    H    @ C       *  |   4  }  ~  � }  ~ � � }  ~ � � }  ~ � � }  ~ � � O    � �   
  � � � code �  HorseRoster ����   4L
 Q �	  � �
  � �
  � � �
  � �
 
 �	  �	  �	  �	  �	  �	  � �
  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �
 � �	 � � �
 � � �
  �
  �
 
 �
 � �
 � �	 � � � �   � � �
 ) � �  � � �
 ) �
 ) � �  � �  � �  � �  � �  �
 ) � �  � �  � � 	 � � 
 � �  � �  � �  � �  � �  �
  � � cols Ljava/util/List; 	Signature /Ljava/util/List<Lhaven/res/ui/croster/Column;>; <init> ()V Code LineNumberTable ()Ljava/util/List; 1()Ljava/util/List<Lhaven/res/ui/croster/Column;>; mkwidget B(Lhaven/UI;[Ljava/lang/Object;)Lhaven/res/ui/croster/CattleRoster; parse ([Ljava/lang/Object;)LHorse; StackMapTable � � � � button #()Lhaven/res/ui/croster/TypeButton; 1([Ljava/lang/Object;)Lhaven/res/ui/croster/Entry; lambda$static$15 (LHorse;)Ljava/lang/Integer; lambda$static$14 lambda$static$13 lambda$static$12 lambda$static$11 lambda$static$10 lambda$static$9 lambda$static$8 lambda$static$7 lambda$static$6 (LHorse;)Ljava/lang/Double; lambda$static$5 (LHorse;)Ljava/lang/Boolean; lambda$static$4 lambda$static$3 lambda$static$2 lambda$static$1 lambda$static$0 0(Lhaven/res/ui/croster/Entry;)Ljava/lang/String; <clinit> ,Lhaven/res/ui/croster/CattleRoster<LHorse;>; 
SourceFile HorseRoster.java V W R S HorseRoster java/lang/Long � � java/lang/String Horse V � java/lang/Integer � � � � � � � � � � � � � � java/lang/Number � � � � � � � � � � � � � � � � � � � � � � � � � � � gfx/hud/rosters/btn-horse  gfx/hud/rosters/btn-horse-d ^ _	
 haven/res/ui/croster/Column Name BootstrapMethods { V gfx/hud/rosters/sex u V gfx/hud/rosters/growth gfx/hud/rosters/deadp  gfx/hud/rosters/pregnant! gfx/hud/rosters/lactate" gfx/hud/rosters/quality# s V$ gfx/hud/rosters/endurance% i gfx/hud/rosters/stamina& gfx/hud/rosters/metabolism' gfx/hud/rosters/meatquantity( gfx/hud/rosters/milkquantity) gfx/hud/rosters/meatquality* gfx/hud/rosters/milkquality+ gfx/hud/rosters/hidequality, gfx/hud/rosters/breedingquality-./ !haven/res/ui/croster/CattleRoster [Ljava/lang/Object; 	longValue ()J (JLjava/lang/String;)V intValue ()I grp I stallion Z foal dead pregnant lactate doubleValue ()D q D meat milk meatq milkq hideq seedq end stam mb haven/Resource classres #(Ljava/lang/Class;)Lhaven/Resource; pool Pool InnerClasses Lhaven/Resource$Pool; haven/Resource$Pool load0 Named +(Ljava/lang/String;I)Lhaven/Resource$Named; typebtn =(Lhaven/Indir;Lhaven/Indir;)Lhaven/res/ui/croster/TypeButton; valueOf (I)Ljava/lang/Integer; java/lang/Double (D)Ljava/lang/Double; java/lang/Boolean (Z)Ljava/lang/Boolean; haven/res/ui/croster/Entry name Ljava/lang/String;
12 &(Ljava/lang/Object;)Ljava/lang/Object;
 3 apply ()Ljava/util/function/Function; java/util/Comparator 	comparing 5(Ljava/util/function/Function;)Ljava/util/Comparator; ,(Ljava/lang/String;Ljava/util/Comparator;I)V
 4 reversed ()Ljava/util/Comparator; '(Lhaven/Indir;Ljava/util/Comparator;I)V runon ()Lhaven/res/ui/croster/Column;
 5
 6
 7
 8
 9 &(Lhaven/Indir;Ljava/util/Comparator;)V
 :
 ;
 <
 =
 >
 ?
 @
 A
 B initcols 0([Lhaven/res/ui/croster/Column;)Ljava/util/List; haven/Resource$NamedCDG z { y u x u w u v u t u r s q i p i o i n i m i l i k i j i h i "java/lang/invoke/LambdaMetafactory metafactoryI Lookup �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;J %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles horse.cjava !  Q    	 R S  T    U   V W  X        *� �    Y       B  R Z  X        � �    Y       [ T    [ � \ ]  X         � Y� �    Y       ^ � ^ _  X  h    I=+�2� � B+�2� :� Y!� 	:+�2� 
� � +�2� 
� 6~� � � ~� � � ~� � � ~� � � ~� � � +�2� � � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � �    `   � 
� R  a b c d  d�    a b c d  dO d�    a b c d  dO d�    a b c d  dP d�    a b c d  dP d�    a b c d  d Y   Z    b  c  d  e & f 7 g E h V i g j x k � l � m � n � o � p � q � r s t$ u5 vF w  e f  X   @      � �  � !� � "� !� #�    Y       {  |  {A ^ g  X        *+� $�    Y       B
 h i  X         *� � %�    Y       Y
 j i  X         *� � %�    Y       W
 k i  X         *� � %�    Y       V
 l i  X         *� � %�    Y       U
 m i  X         *� � %�    Y       S
 n i  X         *� � %�    Y       R
 o i  X         *� � %�    Y       P
 p i  X         *� � %�    Y       O
 q i  X         *� � %�    Y       N
 r s  X         *� � &�    Y       L
 t u  X         *� � '�    Y       J
 v u  X         *� � '�    Y       I
 w u  X         *� � '�    Y       H
 x u  X         *� � '�    Y       G
 y u  X         *� � '�    Y       F
 z {  X        *� (�    Y       D  | W  X  �     n� )Y� )Y*� +  � , ȷ -SY� )Y� � .� !� /  � ,� 0 � 1� 2SY� )Y� � 3� !� 4  � ,� 0 � 1� 2SY� )Y� � 5� !� 6  � ,� 0 � 1� 2SY� )Y� � 7� !� 8  � ,� 0 � 1� 2SY� )Y� � 9� !� :  � ,� 0 � 1SY� )Y� � ;� !� <  � ,� 0 � =SY� )Y� � >� !� ?  � ,� 0 � =SY� )Y� � @� !� A  � ,� 0 � =SY	� )Y� � B� !� C  � ,� 0 � =SY
� )Y� � D� !� E  � ,� 0 � =SY� )Y� � F� !� G  � ,� 0 � =SY� )Y� � H� !� I  � ,� 0 � =SY� )Y� � J� !� K  � ,� 0 � =SY� )Y� � L� !� M  � ,� 0 � =SY� )Y� � N� !� O  � ,� 0 � =S� P� �    Y   J    C  D $ F N G x H � I � J � L N@ Of P� R� S� U� V$ WJ Yg C  �   �  �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � ~   K T    } �     � � � 	 �	EHF codeentry "   wdg HorseRoster   ui/croster G  