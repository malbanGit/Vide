;***************************************************************************
;
; The J-GAME by Jan Haasch 2015 @ HU Berlin
;
; http://vectrexmuseum.com/share/coder/html/bios.htm#F511 -> Link zu ROM Routinen
;
;***************************************************************************
;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; ROM Routinen:
WAITRECAL           equ      $f192 
INTENSITY           equ      $f2ab 
PRINTSTR            equ      $f37a 
RANDOM              equ      $f511 
RESET0REF           equ      $f354 
MOVEPEN             equ      $f2fc 
MOVEDRAW            equ      $f3b7 
READBUTTONS         equ      $f1ba 
DOSOUND             equ      $f289 
INITMUSICCHK        equ      $f687 
DPTOC8              equ      $f1af 
WARMSTART           equ      $f06C 
PRINTSTRYX          equ      $f378 
PRINTSTRHWYX        equ      $f373 
; Einige Variablen:
posy                equ      $c882                        ; y-position der Figur 
jumpstate           equ      $c883                        ; Status des Sprunges hoch/runter 
action              equ      $c884                        ; Status der Aktion an/aus 
nextl               equ      $c885                        ; Zufallszahl für Level 1 
activl              equ      $c886                        ; aktives Level das im Kasten gezeichnet wird 
tmpl                equ      $c887                        ; kopie vom aktiven Level 
runcount            equ      $c888                        ; Durchlaufcounter für Levelbau 
levelx              equ      $c889                        ; X-Koordinate für den Levelbau 
scale               equ      $c890                        ; Skalierungsfaktor für Levelbau 
randomcount         equ      $c891                        ; bestimmt ob neue Zufallszahl generiert werden muss 
gameover            equ      $c892                        ; Gameoverloop zum Anzeigen des GAME OVER Schriftzuges 
speedcount          equ      $c893                        ; Counter setzt die Zählschleife time und wird immer schneller 
lifecount           equ      $c894                        ; Anzahl der Leben sind initial 3 
dead                equ      $c895                        ; wir sterben nur einmal! 
difficulty          equ      $c896                        ; Schwierigkeitsgrad, Wert wird mit Randomzahl verundet 
levelcount          equ      $c897                        ; zeigt das aktuelle Level 
;***************************************************************************
                    INCLUDE  "VECTREX.I"
; Start of vectrex memory with cartridge name...
                    ORG      0 
;***************************************************************************
; HEADER SECTION
;***************************************************************************
                    fcb      $67,$20 
                    fcc      "GCE 2015"
                    fcb      $80                          ; All text ends with $80 
                    FDB      $fd0d                        ; Play song "$fe38" from ROM 
                    FDB      $f850                        ; Width, height 
                    FDB      $30b8                        ; y-position, x-position 
                    fcc      "THE J GAME"
                    fcb      $80,$0                       ; Init block ends with $0 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; Startumgebung setzen
                    LDA      #0 
                    STA      posy                         ; setze Y-Startkoordinate 
                    STA      jumpstate                    ; setze Sprungstatus auf 0, d.h. steigen 
                    STA      action                       ; setze action auf 0, d.h. gerade wird nicht gesprungen 
                    STA      runcount                     ; setze den Durchlaufcounter auf 0 
                    STA      tmpl                         ; TempLevel, das gezeichnet wird 
                    STA      activl                       ; ActiveLevel das in Temp geladen wird 
                    STA      randomcount                  ; Counter für neu zu generierende Zufallszahl 
                    STA      gameover                     ; Schleifenwert für gameoverloop 
                    STA      dead                         ; binärwert für einmaliges sterben 
                    LDA      #40 
                    STA      speedcount                   ; gibt die Startgeschwindigkeit an, siehe auch Zeitschleife 
                    LDA      #3 
                    STA      lifecount                    ; setze die Spielerleben auf 3 
                    LDA      #1 
                    STA      levelcount                   ; zeigt die Level von 1 bis 4 
                    LDA      #-70 
                    STA      levelx                       ; setze Levelstart 
                    LDA      #%00010001 
                    STA      difficulty                   ; Schwierigkeitsgrad, steigt pro Level, mehr Hindernisse möglich 
                    JSR      RANDOM                       ; initiale Random Zahlen bestimmen 
                    ANDA     difficulty                   ; um Level zu vereinfachen, Doppelsprünge vermeiden 
                    STA      nextl 
                    LDA      #128                         ; Skalierung für Levelbau wählen 
                    STA      scale 
; ROM Routinen für Schrift initialisieren
                    LDD      #$FC20                       ; HEIGTH, WIDTH (-4, 32) 
                    STD      Vec_Text_HW                  ; store to BIOS RAM location 
;***************************************************************************
; MAIN();
main: 
main_loop: 
;*** Abspielen des Sounds und rekalibrieren der VECTREX
                    JSR      DPTOC8 
                    LDU      #PING1                       ; Musiknoten für Sprung laden 
                    JSR      INITMUSICCHK 
                    JSR      WAITRECAL                    ; max. einmal pro refresh aufrufen! 
                    JSR      DOSOUND                      ; Sound abspielen 
;*** Level (Schwierigkeitsgrad)
                    JSR      leveldiff 
;*** Spielerleben
                    JSR      life 
;*** Spielfigur
                    JSR      player 
;*** Spielfeld
                    JSR      field 
;*** LEVEL Bau (hier wirds kompliziert!)
                    JSR      level 
;*** Benutzereingabe lesen, Springen und Sound (siehe auch Buttonhandling)
                    JSR      user_action 
;*** Kollisionserkennung und Spielende
                    JSR      col 
                    LBRA     main_loop                    ; und zurück zum Anfang 

;**************************************************************************
; Subroutinen:
;**************************************************************************
; Levelhöhe
leveldiff: 
                    LDA      levelcount                   ; prüfe aktuelles Level 
                    CMPA     #1 
                    BNE      ld2 
                    LDU      #level_1                     ; Schrift anzeigen mit Leben 
                    JSR      PRINTSTRYX 
                    BRA      leveldiffdone 

ld2: 
                    LDA      levelcount 
                    CMPA     #2 
                    BNE      ld3 
                    LDA      #%10010010                   ; difficulty Level 2 
                    STA      difficulty 
                    LDU      #level_2 
                    JSR      PRINTSTRYX 
                    BRA      leveldiffdone 

ld3: 
                    LDA      levelcount 
                    CMPA     #3 
                    BNE      ld4 
                    LDA      #%11001100                   ; difficulty Level 3 
                    STA      difficulty 
                    LDU      #level_3 
                    JSR      PRINTSTRYX 
                    BRA      leveldiffdone 

ld4: 
                    LDU      #level_4 
                    JSR      PRINTSTRYX 
                    LDA      #%11101110                   ; difficulty Level 4 
                    STA      difficulty 
leveldiffdone: 
                    RTS                                   ; verlassen der Subroutine 

; Spielerleben
life: 
                    LDA      lifecount                    ; prüfe auf Anzahl der verbleibenden 
                    CMPA     #3                           ; Leben 
                    BNE      li2 
                    LDU      #life_3                      ; Schrift anzeigen mit Leben 
                    JSR      PRINTSTRYX 
                    BRA      lifedone 

li2: 
                    LDA      lifecount 
                    CMPA     #2 
                    BNE      li1 
                    LDU      #life_2 
                    JSR      PRINTSTRYX 
                    BRA      lifedone 

li1: 
                    LDU      #life_1 
                    JSR      PRINTSTRYX 
lifedone:           RTS                                   ; verlassen der Subroutine 

;**************************************************************************
; Spielfigur
player: 
                    JSR      RESET0REF                    ; Spring zur Mitte 
                    LDA      #127 
                    JSR      INTENSITY                    ; Setze INTENSITY auf 127 
                    LDA      posy                         ; Lade Y Koordinate 
                    LDB      #-10                         ; Lade X Koordinate, Figur steht auf -10 
                    JSR      MOVEPEN 
                    LDX      #sfigur 
                    LDA      #13                          ; Anzahl der Vektoren 
                    LDB      #128                         ; Scaling 
                    JSR      MOVEDRAW 
                    RTS                                   ; verlassen der Subroutine 

;**************************************************************************
; Spielfeld
field: 
                    JSR      RESET0REF                    ; Springe zur Mitte 
                    LDA      #30 
                    JSR      INTENSITY 
                    LDA      #0 
                    LDB      #0 
                    JSR      MOVEPEN 
                    LDX      #sfeld 
                    LDA      #8                           ; Anzahl der Vektoren 
                    LDB      #128                         ; Skalierung 
                    JSR      MOVEDRAW 
                    RTS                                   ; verlassen der Subroutine 

;**************************************************************************
; LEVEL (hier wirds kompliziert!)
level: 
                    JSR      RESET0REF                    ; Springe zur Mitte 
                    LDA      #127 
                    JSR      INTENSITY                    ; Setze Intensity 
                    LDA      #0                           ; Y-Koordinate 
                    LDB      levelx                       ; X-Koordinate, dieser Wert wird geschoben 
                    JSR      MOVEPEN                      ; springe zum Start 
                    LDA      activl                       ; lade das generierte Stück Level zur 
                    STA      tmpl                         ; Ausgabe ins TempLevel 
;* Level aus Lines und Hops zeichnen (tmpl)
l1: 
                    LDX      #dline                       ; zeichne immer erst eine gerade Linie 
                    LDA      #1 
                    LDB      scale                        ; Skalierung 
                    JSR      MOVEDRAW 
                    LDA      tmpl                         ; prüfe die Bits des Random Bytes 
                    ANDA     #%00000001                   ; ist das erste Bit eine 1 
                    BNE      on                           ; wenn ja springe zum Hop 
                    LDX      #line                        ; wenn nicht, dann zeichne eine gerade Linie 
                    LDA      #1 
                    LDB      scale                        ; Skalierung 
                    JSR      MOVEDRAW 
                    LBRA     l2                           ; springe danach zu abschließenden Linie 

on: 
                    LDX      #hop                         ; und zeichne ein Hindernis 
                    LDA      #3 
                    LDB      scale                        ; Skalierung 
                    JSR      MOVEDRAW 
l2:                 LDX      #dline                       ; zeichne am Ende immer eine gerade Linie 
                    LDA      #1 
                    LDB      scale                        ; Skalierung 
                    JSR      MOVEDRAW 
;* Levelcounter für tmpl
                    ASR      tmpl                         ; rechts shift um Levelteil zu zeichnen 
                    INC      runcount                     ; zähle den Durchlaufzähler bis 8 hoch 
                    LDA      runcount 
                    CMPA     #8 
                    LBNE     l1                           ; ist 8 nicht erreicht, wird weiter gezeichnet 
                    LDA      #0                           ; wenn 8 erreicht Counter zurück setzen 
                    STA      runcount 
;* Level Bewegung (levelx)
                    DEC      levelx                       ; Level um 1 nach links schieben 


; outcommented by malban
; this is an active iddle counter that waits for abou 50000 cycles
; making the game unplayable and unneccessarily flickery
; sorry Jan - you didn't understand that part of 
; vectrex programming
; 
; there are other ways to slow down a player in order
; to adjust difficulty!
  ;                  JSR      time                         ; Zeitschleife für Delay aufrufen, ggf. anpassen 
                    LDA      levelx                       ; prüfe ob Levelteil Level verlassen hat 
                    CMPA     #-90 
                    LBNE     leveldone                    ; wenn nicht dann springe zum Ende 
                    LDA      #-70                         ; wenn doch, verwerfe altes Levelteil und 
                    STA      levelx                       ; springe wieder an den Rand 
                    LDA      #0                           ; setze deadflag wieder auf 0 
                    STA      dead                         ; jetzt können wir wieder sterben, 
; aber nur einmal pro Hindernis!
;* neues Levelstück einarbeiten (activl)
                    ASR      activl                       ; rechtsshift um Platz für neuen Wert zu schaffen 
                    LDA      activl 
                    ANDA     #%01111111 
                    STA      activl 
                    LDA      nextl                        ; lade generierte Zufallszahl 
                    ANDA     #%10000000                   ; lösche alles bis auf höchstwertiges Bit 
                    ORA      activl                       ; lade höchstwertiges Bit ins aktive Level 
                    STA      activl                       ; speichere das neue aktive Level 
                    ASL      nextl                        ; linksshift um nächstes Bit zu erhalten 
                    LDA      speedcount                   ; Speedcount um das Spiel 
                    CMPA     #1                           ; zu beschleungigen, von init Wert bis 1 
                    LBEQ     s1                           ; siehe time 
                    DEC      speedcount 
                    LBRA     s2                           ; Level noch nicht geschafft, weiter nach unten 

s1: 
                    LDA      levelcount 
                    CMPA     #4                           ; prüfe ob wir schon in Level 4 sind 
                    LBEQ     s2                           ; wenn ja nichts weiter tun 
                    INC      levelcount                   ; wenn nicht, erhöhe das Level um 1 
                    LDA      #40                          ; und setze die Geschwindigkeit wieder auf 40 
                    STA      speedcount 
s2: 
;* neue Zufallszahl generieren (nextl)
                    INC      randomcount                  ; wir zählen wieder die Durchläufe 
                    LDA      randomcount                  ; um nach 8 Bit eine neue Zufallszahl zu generieren 
                    CMPA     #8 
                    LBNE     leveldone                    ; wenn Grenze noch nicht erreicht zum Ende 
                    LDA      #0                           ; wenn erreicht, dann zurück setzen 
                    STA      randomcount 
r1: 
                    JSR      RANDOM                       ; und neue Zufallszahl wählen 
                    ANDA     difficulty                   ; Schwierigkeitsgrad einbeziehen 
                    LBEQ     r1 
                    STA      nextl 
leveldone: 
                    RTS                                   ; verlassen der Subroutine 

;**************************************************************************
; Benutzereingabe lesen, Springen und Sound
user_action: 
                    JSR      RESET0REF 
                    LDA      action                       ; prüfe ob bereits Q gedrückt wurde 
                    CMPA     #1 
                    LBEQ     jump                         ; wenn ja dann Button nicht testen 
                    JSR      READBUTTONS 
                    CMPA     #$00                         ; irgendein Button gedrueckt? 
                    LBEQ     no_button                    ; kein Button 
                    BITA     #$01                         ; wird Button 1 gedrueckt? 
                    LBEQ     false_button                 ; wenn nicht dann false_button 
                    INC      action                       ; wir beginnen action Sprung 
; ab jetzt gibt es kein Zurück mehr!
;*** Sound initialiseren
                    LDA      #1                           ; Musikflag schalten für Sprungmusik, 
                    STA      Vec_Music_Flag               ; damit Musik gespielt wird, siehe Beginn 
; der mainloop
;*** Sprung
jump: 
                    LDA      jumpstate                    ; fallen oder steigen wir? 
                    CMPA     #1                           ; 0 = wir steigen, 1 = wir fallen 
                    LBEQ     jumpdown 
                    LDA      posy                         ; hoch springen 
                    INCA                                  ; ein Stück steigen 
                    STA      posy 
                    LDA      posy 
                    CMPA     #40                          ; Ist Spielfigur schon oben angekommen? 
                    LBNE     jumpdone 
                    INC      jumpstate                    ; Figur ist oben angekommen, 
; ändere Jumpstate
                    LBRA     jumpdone                     ; springe ans Ende 

jumpdown: 
                    DEC      posy                         ; runter fallen 
                    DEC      posy                         ; ein Stück runter fallen 
                    LDA      posy                         ; sind wir unten angekommen? 
                    LBNE     jumpdone                     ; wenn nicht dann ans Ende 
                    DEC      jumpstate                    ; wenn doch, dann Jumpstate = 0 
                    DEC      action                       ; wir beenden den Sprung und aktivieren 
; die Eingabe
jumpdone: 
                    RTS                                   ; verlassen der Subroutine 

;**************************************************************************
; Buttonhandling:
false_button: 
                    LDU      #false_button_string         ; Falscher Button 
                    JSR      PRINTSTRYX                   ; String schreiben 
                    LBRA     jumpdone                     ; Zum Ende springen 

no_button: 
                    LDU      #no_button_string 
                    JSR      PRINTSTRYX 
                    LBRA     jumpdone                     ; Zum Ende springen 

;**************************************************************************
; Kollisionserkennung
col: 
                    LDA      activl                       ; prüfe auf Hindernis 
                    ANDA     #%00001000 
                    LBEQ     coldone 
                    LDA      levelx                       ; in diesem Bereich können wir 
                    ADDA     #74                          ; auf ein Hindernis stoßen 
                    LBGT     coldone                      ; linke Grenze der Spielfigur 
                    LDA      levelx 
                    ADDA     #82                          ; rechte Grenze der Spielfigur 
                    LBLT     coldone 
                    LDA      posy                         ; hoffentlich sind wir hoch genug 
                    SUBA     #20                          ; wenn nicht verlieren wir ein Leben 
                    LBGE     coldone 
                    LDA      dead                         ; ein Hindernis kann uns aber nur ein Leben 
                    LBNE     coldone                      ; kosten, daher merken wir uns den Tot für 
                    LDA      #1                           ; die letzten 20 Durchläufe 
                    STA      dead                         ; wird weiter oben zurück gesetzt 
                    DEC      lifecount                    ; Mist, Leben verloren :( 
                    LDA      lifecount                    ; hoffentlich haben wir noch welche? 
                    LBGT     coldone                      ; wenn ja geht es weiter 
                    LBRA     gamelost                     ; wenn nicht ist an dieser Stelle schluss, GAME OVER 

coldone: 
                    RTS                                   ; verlassen der Subroutine 

;**************************************************************************
; Spielende:
gamelost: 
                    CLRA                                  ; Lösche den Akku 
                    LDA      #1 
                    STA      Vec_Music_Flag               ; Lade 1 für neue Musik 
gameoverloop: 
                    JSR      DPTOC8 
                    LDU      #musicb                      ; lade Musik 
                    JSR      INITMUSICCHK                 ; and init new notes 
                    JSR      WAITRECAL                    ; sets dp to d0, and pos at 0, 0 
                    JSR      DOSOUND 
                    LDU      #game_over_string            ; zeige GAME OVER Schriftzug 
                    JSR      PRINTSTRHWYX 
;*** Spielfigur Abschiedsbild
                    JSR      RESET0REF                    ; Spring zur Mitte 
                    LDA      #127 
                    JSR      INTENSITY                    ; Setze INTENSITY auf 127 
                    LDA      #0                           ; Lade Y Koordinate 
                    LDB      #0                           ; Lade X Koordinate 
                    JSR      MOVEPEN 
                    LDX      #sfigurt1 
                    LDA      #8                           ; Anzahl der Vektoren 
                    LDB      #250                         ; Scaling 
                    JSR      MOVEDRAW 
                    JSR      RESET0REF                    ; Spring zur Mitte 
                    LDA      #127 
                    JSR      INTENSITY                    ; Setze INTENSITY auf 127 
                    LDA      #0                           ; Lade Y Koordinate 
                    LDB      #0                           ; Lade X Koordinate 
                    JSR      MOVEPEN 
                    LDX      #sfigurt2 
                    LDA      #5                           ; Anzahl der Vektoren 
                    LDB      #250                         ; Scaling 
                    JSR      MOVEDRAW 
                    DEC      gameover 
                    LDA      gameover 
                    BNE      gameoverloop 
reset: 
                    JSR      WARMSTART                    ; Starte die Vectrex neu ohne Reinitialisierung 
; des OS (nicht schön, vll andere Lösung finden)
;***************************************************************************
; Textanzeige:
no_button_string: 
                    DB       70,-75, "PRESS Q TO JUMP!", $80
false_button_string: 
                    DB       70,-75, "WRONG BUTTON!", $80
game_over_string: 
                    DB       -10,50,50,-45, "GAME OVER!", $80
life_1: 
                    DB       70,30, "LIFE 1", $80
life_2: 
                    DB       70,30, "LIFE 2", $80
life_3: 
                    DB       70,30, "LIFE 3", $80
level_1: 
                    DB       -70,-75, "LEVEL 1", $80
level_2: 
                    DB       -70,-75, "LEVEL 2", $80
level_3: 
                    DB       -70,-75, "LEVEL 3", $80
level_4: 
                    DB       -70,-75, "LEVEL 4", $80
;***************************************************************************
; Zeitschleife:
time: 
                    LDA      speedcount                   ; Speedcount beeinflust Levelgeschwindigkeit 
t1: 
                    LDB      #0                           ; und damit den Schwierigkeitsgrad 
t2: 
                    DECB     
                    BNE      t2 
                    DECA     
                    BNE      t1 
                    RTS                                   ; verlassen der Subroutine 

;***************************************************************************
; Spielfigur:
sfigur: 
                    fcb      0,0 
                    fcb      2,2 
                    fcb      -2,2 
                    fcb      2,-2 
                    fcb      4,0 
                    fcb      -2,2 
                    fcb      2,-2 
                    fcb      -2,-2 
                    fcb      2,2 
                    fcb      0,-1 
                    fcb      2,0 
                    fcb      0,2 
                    fcb      -2,0 
                    fcb      0,-1 
; Spielfigur Körper:
sfigurt1: 
                    fcb      0,0 
                    fcb      4,4 
                    fcb      -4,4 
                    fcb      4,-4 
                    fcb      8,0 
                    fcb      -4,4 
                    fcb      4,-4 
                    fcb      -4,-4 
                    fcb      4,4 
;Spielfigur Kopf:
sfigurt2: 
                    fcb      0,20 
                    fcb      0,-2 
                    fcb      4,0 
                    fcb      0,4 
                    fcb      -4,0 
                    fcb      0,-2 
; Spielfeld:
sfeld: 
                    fcb      60,-70 
                    fcb      0,70 
                    fcb      0,70 
                    fcb      -60,0 
                    fcb      -60,0 
                    fcb      0,-70 
                    fcb      0,-70 
                    fcb      60,0 
                    fcb      60,0 
; LEVEL:
line: 
                    fcb      0,0 
                    fcb      0,4 
dline: 
                    fcb      0,0 
                    fcb      0,8 
hop: 
                    fcb      0,0 
                    fcb      20,0 
                    fcb      0,4 
                    fcb      -20,0 
;***************************************************************************
; Sound
PING1:                                                    ;        die Musik ist "geliehen" aus Patriots von "John Dondzilla" 
                    FDB      $FD69 
                    FDB      $FD79 
                    fcb      $20,$0A 
                    fcb      0, $80 
;***************************************************************************
                    END      main 
;***************************************************************************
