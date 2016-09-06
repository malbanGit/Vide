(*$A- *)

{[A=12, S=4, Q=1]}

{
        Snowflakes

        Adapted from an ALGOL-W program in Byte magazine
        George Gonzalez
}
PROGRAM FLAKY(input, output);

CONST
   DEBUG = FALSE;
   MAXDIR = 50;
   MAXDEPTH = 50;
   PI = 3.1415926;

TYPE
   PLTM = - 3..3;

VAR
   PLOTSIZE, SIZE, RADIUS, XBOUND, YBOUND: REAL;
   LINES, LASTX, LASTY, DEPTH, N: INTEGER;
   OUTC: CHAR;
   OUT: BOOLEAN;

(*$IVECDRAW *)

FUNCTION COT(ARG: REAL): REAL;

   BEGIN
      COT := COS(ARG) / SIN(ARG);
   END {COT};


PROCEDURE PLOT(X, Y: REAL; MODE: PLTM);

   PROCEDURE LINE(X, Y: INTEGER);

   BEGIN { Plot }
      LINES := LINES + 1;
      IF LINES MOD 15 = 0 THEN CLRSEG;
      DRAWLINE(LASTX, LASTY, X - LASTX, Y - LASTY, 1);
      LASTX := X; LASTY := Y
   END { Plot };


   PROCEDURE AT(x, y: integer);

   BEGIN { Move }
      LASTX := X; LASTY := Y
   END { Move };


   VAR
      IX, IY: INTEGER;

   BEGIN
      IX := ROUND(X * DXMAX / 2) + DXMAX DIV 2;
      IY := ROUND(Y * DYMAX / 2) + DYMAX DIV 2;
      IF MODE IN [- 3, 2, 3] THEN
         CASE MODE OF
            - 3:;
            3:
               AT(IX, IY);
            2:
               LINE(IX, IY);
         END;
   END {PLOT};


PROCEDURE FLAKE(SIZE, XINIT, YINIT: REAL; DEPTH, N: INTEGER; OUT: BOOLEAN);

   VAR
      I, NDIR, TWON: INTEGER;
      NODD: BOOLEAN;
      X, Y: ARRAY [0.. MAXDIR] OF REAL;
      SIDE: ARRAY [1.. MAXDEPTH] OF REAL;
      DIVISOR, S0, X0, Y0, X1, Y1, XK, YK, ANGLE: REAL;
      DIR, LOWTURN, HIGH1, HIGH2, LEVEL: INTEGER;


   FUNCTION SUB(K: INTEGER): INTEGER;

      VAR
         DIVS: INTEGER;

      BEGIN
         IF NODD
         THEN
            DIVS := 1
         ELSE
            DIVS := 2;
         IF K < 0
         THEN
            SUB := TWON + K DIV DIVS
         ELSE
            SUB := K DIV DIVS;
      END {SUB};


   PROCEDURE WEND(X0, Y0, X1, Y1: REAL);

      VAR
         XK, YK, SK: REAL;
         I: INTEGER;

      BEGIN
         LEVEL := LEVEL + 1;
         IF LEVEL > DEPTH
         THEN
            PLOT(X1, Y1, 2)
         ELSE
            BEGIN { MOVE 1/3 OF THE WAY }
               SK := SIDE[LEVEL];
               XK := X0 + SK * X[DIR];
               YK := Y0 + SK * Y[DIR];
               WEND(X0, Y0, XK, YK);
{ THEN ESTABLISH CORNER OF NEXT LEVEL N-GON
AND TRAVEL FROM VERTEX TO VERTEX }
               X0 := XK;
               Y0 := YK;
               DIR := (DIR + HIGH1) MOD NDIR;
               XK := XK + SK * X[DIR];
               YK := YK + SK * Y[DIR];
               WEND(X0, Y0, XK, YK);
               FOR I := 3 TO N DO
                  BEGIN
                     X0 := XK;
                     Y0 := YK;
                     DIR := (DIR + HIGH2) MOD NDIR;
                     XK := XK + SK * X[DIR];
                     YK := YK + SK * Y[DIR];
                     WEND(X0, Y0, XK, YK);
                  END;
{
FOR THE LAST ONE, MOVE THE LAST 1/3 OF THE WAY
}
               DIR := (DIR + HIGH1) MOD NDIR;
               WEND(XK, YK, X1, Y1);
            END;
         LEVEL := LEVEL - 1;
      END {WEND};


   BEGIN { FLAKE }
      NODD := ODD(N);
      TWON := 2 * N;
      IF NODD
      THEN
         NDIR := TWON
      ELSE
         NDIR := N;
      BEGIN { CALCULATE THE UNIT VECTORS IN THE POSSIBLE DIRECTIONS. }
         FOR I := 0 TO NDIR - 1 DO
            BEGIN
               ANGLE := (2 * I / NDIR) * PI;
               X[I] := COS(ANGLE);
               Y[I] := SIN(ANGLE);
            END;
{
CALCULATE THE POLYGON SIDELENGTHS AT EACH LEVEL
}
         IF OUT
         THEN
            BEGIN
               IF NODD
               THEN
                  IF N = 3
                  THEN
                     DIVISOR := 1.0
                  ELSE
                     DIVISOR := 0.5 * COS(PI / N) * SQRT(10.0 + 6.0 * COS(PI /
                        N))
               ELSE
                  DIVISOR := 2.0
            END
         ELSE
            DIVISOR := 1.0;
         S0 := SIZE * 2 * SIN(PI / N) / DIVISOR;
         SIDE[1] := S0;
         FOR I := 2 TO DEPTH DO
            SIDE[I] := SIDE[I - 1] / 3;
{
DETERMINE TURN ANGLES
}
         LOWTURN := SUB(- 2);
         IF OUT
         THEN
            HIGH1 := SUB(N - 2)
         ELSE
            HIGH1 := SUB(2 - N);
         IF OUT
         THEN
            HIGH2 := SUB(- 2)
         ELSE
            HIGH2 := SUB(2);
{
LOCATE THE BEGINNING CORNER OF THE CURVE
}
         LEVEL := 1;
         X0 := XINIT - S0 / 2;
         X1 := X0;
         Y0 := YINIT - S0 * COT(PI / N) / 2;
         Y1 := Y0;
         PLOT(X0, Y0, 3);
         DIR := SUB(N - 2);
{
THEN WEND OUR WAY FROM VERTEX TO VERTEX OF THE BOTTOM-LEVEL N-GON
}
         XK := X0 + S0 * X[DIR];
         YK := Y0 + S0 * Y[DIR];
         WEND(X0, Y0, XK, YK);
         FOR I := 2 TO N - 1 DO
            BEGIN
               X0 := XK;
               Y0 := YK;
               DIR := (DIR + LOWTURN) MOD NDIR;
               XK := X0 + S0 * X[DIR];
               YK := Y0 + S0 * Y[DIR];
               WEND(X0, Y0, XK, YK);
            END;
{
USE THE SAVED COORDINATES OF THE STARTING POINT
FOR THE LAST WEND }
         DIR := (DIR + LOWTURN) MOD NDIR;
         WEND(XK, YK, X1, Y1);
      END;
   END {FLAKE};
{ FLAKE }


BEGIN { MAIN PROGRAM }
   XBOUND := 0.0;
   YBOUND := 0.0;
   HEADER;
{READ(PLOTSIZE) ;
    }
   PLOTSIZE := 10.0;
   PLOT(0.0, - 10.0, - 3);
   WRITE('Enter Depth, Number of sides, In or Out');
   READLN(DEPTH, N, OUTC);
   RADIUS := 1.0;
   OUT := OUTC <> 'I';
   WHILE RADIUS > 0.0 DO
      BEGIN
         CLRVEC;
         SIZE := 2.0 * RADIUS;
         IF YBOUND + SIZE + 2.0 > PLOTSIZE THEN
            BEGIN
               PLOT(XBOUND + 2.0, - PLOTSIZE, - 3);
               XBOUND := 0.0;
               YBOUND := 0.0;
            END;
         IF XBOUND < RADIUS THEN
            BEGIN
               PLOT(RADIUS - XBOUND, 0.0, - 3);
               XBOUND := RADIUS;
            END;
         YBOUND := YBOUND + SIZE + 2.0;
         PLOT(0.0, RADIUS + 1.0, - 3);
         FLAKE(RADIUS, 0.0, 0.0, DEPTH, N, OUT);
         PLOT(0.0, RADIUS + 1.0, - 3);
         WRITE('Enter Depth, Number of sides, In or Out');
         READLN(DEPTH, N, OUTC);
         OUT := OUTC <> 'I';
      END;
END {FLAKY}.
