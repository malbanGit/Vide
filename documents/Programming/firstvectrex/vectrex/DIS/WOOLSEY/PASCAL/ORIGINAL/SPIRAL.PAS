PROGRAM SPIRAL;

   (* ACCEPTS THE INCREMENT AND ANGLE BETWEEN THE SEGMENTS TO BE GENERATED *)

CONST
  debug = false;

VAR
   DLX, DLY, XST, YST, RAN, WID, OFFSCR: INTEGER;
   GRAPHIC: FILE;
   THREE, NUMBERS, NUMBER, ZERO: INTEGER;
   L, CANG, ANGLE, INC: REAL;

(*$IVECDRAW *)

BEGIN
  header;
  WHILE INC <> 0 DO
     BEGIN
        WRITELN ('INPUT ANGLE, INCREMENT' );
        READ(INPUT, ANGLE, INC);
        ANGLE := ANGLE * (3.1415926535897932384652643383279 / 180);
        IF INC <> 0
        THEN
           BEGIN
              clrvec;
              THREE := 63; CANG := 0; L := 0; ZERO := 0;
              DLX := 0; DLY := 0; XST := DXMAX DIV 2; YST := DYMAX DIV 2;
              WID := 20; RAN := 1; OFFSCR := 0; NUMBERS := 0;
              WHILE OFFSCR < 1 DO
              BEGIN
                 L := L + INC; CANG := CANG + ANGLE;
                 DLX := TRUNC(L * COS(CANG)); DLY := TRUNC(L * SIN(CANG));
                 DRAWLINE(XST, YST, DLX, DLY, 1);
                 NUMBERS := NUMBERS + 1;
                 if numbers mod 10 = 0 then clrseg;
                 XST := XST + DLX; YST := YST + DLY;
                 IF XST < 0 THEN OFFSCR := 1;
                 IF YST < 0 THEN OFFSCR := 1;
                 IF XST > DXMAX THEN OFFSCR := 1;
                 IF YST > DYMAX THEN OFFSCR := 1
              END
           END
     END
END.

