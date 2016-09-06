(* kludge resulting from converint BASIC program to file of PLAY strings *)

TYPE TWINE=STRING[255];

VAR A, B1, B2, B3, B4, C1, C2, C3, C4, D1, D2, D3, D4: TWINE;
E1, E2, E3, F1, F2, F3, F4, G1, G2, G3, G4, H, I: TWINE;
TE, TG, TA, TB, TC, TD: TWINE;
T1, T2, T3, T4: REAL;
Z: INTEGER;
FF: TEXT;

FUNCTION SINGLE(X: TWINE): REAL;
BEGIN
 SINGLE := RANDOM;
END;

BEGIN
 ASSIGN(FF, 'ANITRA.TUN'); REWRITE(FF);
WRITELN(FF,'HAnitra''s Dance from "Peer Gynt"');
WRITELN(FF,'KEdvard Grieg');
 TA := 'a16b32a32b32a32b32a32';
 TB := 'b16O4c32O3b32O4c32O3b32O4c32O3b32';
 TC := 'c16d32c32d32c32d32c32';
 TD := 'd16e32d32e32d32e32d32';
 TE := 'e16f32e32f32e32f32e32';
 TG := 'g16a32g32a32g32a32g32';
 A := 'MLO5e2. e4p2 MSO1a4O3c4dd O1a4O3e4ff O1a4O3e4dd O1a4O3c4';
 B1 := 'O3e4 MLa64b64a16.MSg#abO4cd MLeae4'+td+' cac4O3'+tb+' MNa2p4';
 B2 := 'MLaO4cO3a4'+tg+' f#O4cO3MNf#2 MLfO4cO3f4'+te+' d#bMNd#2';
 B3 := 'MSba#f#baf bg#ebgd# bf#dbfc# becbd#O2b';
 B4 := 'MLO3e64f#64e16.MSd#ef#ga bO4eO3bagf# ef#gab4 O4e4p4';
 C1 := 'MLf4.MNeMLeMNd MLd4.MNeMLeMNf f2. MSe4p2 p8O3fdcO2bMLO3f';
 C2 := 'MSdcO2bO3dO2ba g#MLO3dMSO2bag#b g#fedcO1b';
 C3 := 'O4MLb-4.MNaMLaMNg MLg4.MNaMLaMNb- b-2. MSa4p2 p8O3b-gfeMLb-';
 C4 := 'MSgfeged c#MLgMSedc#e c#O2b-agfe';
 D1 := 'MSO2d4O3f#4g4 O2d4O3a4b4 O2d4O3a4a4 O4d64e64d16.c#def#g';
 D2 := 'MLaO5dO4a4'+tg+' f#O5dO4f#4'+te+'MNd2.';
 D3 := 'MSO2d4O3f4g4 O2d4O3a4b-4 O2d4O3a4a4 O4d64e64d16.c#defg';
 D4 := 'MLaO5dO4a4'+tg+'fO5dO4f4'+te+'MNd2.';
 E1 := 'MSO1d-O2e-aO3cfO4c MLf64g64f16.MSefgab- MLO5cfcMSO3gab-';
 E2 := 'MLO4cfc2 MSO1fO2f#aO3ceO4e MLa64b64a16.MSg#abO5cd';
 E3 := 'MLeaeMSO3bO4cd MLeae2 MSO1bO2bO3d#f#ab MLO4f#64g64f#16.MSff#gab';
 F1 := 'MLO5cO4cf#MSO3g#ab MLO4cO3cf#2 MSO1eO2eg#bO3de';
 F2 := 'MLb64O4c64O3b16.MSa#bO4cde';
 F3 := 'MLfO3fbMScde';
 F4 := 'MLfO2fb4MNO3e4';
 G1 := 'MLa64b64a16.MSg#abO4cd MLeae4'+td+'cec4O3'+tb+'MNa2.';
 G2 := 'MLO4aO5cO4a4'+tg+'f#O5cO4f#2 fO5cO4f4'+te+'d#bd#2 dfd4'+tc;
 G3 := 'O3bO4fO3b2 b-O4fo3b-4'+ta+'g#O4eO3g#2 MSO4ed#O3bO4edO3b-';
 G4 := 'O4ec#O3aO4ecO3g# O4eO3bgO4eO3a#f# O4eO3afO4eO3g#e';
 H := 'MLa64b64a16.MSg#abO4cd eaedcO3b abO4cde4 a4p4';
 T1 := 160;
 T2 := Single('CDCC4C80') * T1;
 T3 := Single('9A991980') * T1;
 T4 := Single('CDCC4C7F') * T1;
 T4 := T2;
 I := 'p4';
 WRITELN(FF,'T',TRUNC(T1), 'L8');
 WRITELN(FF,A);
 WRITELN(FF,B1);
 WRITELN(FF,B2);
 WRITELN(FF,B3);
 WRITELN(FF,B4);
 WRITELN(FF,B1);
 WRITELN(FF,B2);
 WRITELN(FF,B3);
 WRITELN(FF,B4);
 WRITELN(FF,'p4');
 FOR Z := 1 TO 2 DO BEGIN
   WRITELN(FF,C1);
   WRITELN(FF,C2);
   WRITELN(FF,C3);
   WRITELN(FF,C4);
   WRITELN(FF,D1);
   WRITELN(FF,D2);
   WRITELN(FF,D3);
   WRITELN(FF,D4);
   WRITELN(FF,E1);
   WRITELN(FF,E2);
   WRITELN(FF,E3);
   WRITELN(FF,F1);
   WRITELN(FF,'T', TRUNC(T2), F2);
   WRITELN(FF,'T', TRUNC(T3), F3);
   WRITELN(FF,'T', TRUNC(T4), F4);
   WRITELN(FF,'T', TRUNC(T1), G1);
   WRITELN(FF,G2);
   WRITELN(FF,G3);
   WRITELN(FF,G4);
   WRITELN(FF,H);
   WRITELN(FF,I);
   I := 'O1E4 O1A4P2 MLO4A2. A4'; { SECOND O1 WAS O0, MAKING TUNE RANGE TOO BIG }
 END; CLOSE(FF);
 END.

