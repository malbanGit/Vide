     {TERAK CORPORATION believes that the information contained herein is
     accurate. In no event will TERAK be liable for any losses or damages,
     whether direct or indirect, resulting from the use of such
     information, including, without limitation, losses arising from
     claims of patent, copyright, and trademark infringement. No license
     is granted hereby for the use of any patent or patent rights of
     TERAK. TERAK reserves the right to update the information contained
     herein at any time without further notice.

     The information contained herein is proprietary to TERAK CORPORATION
     and must be treated as confidential. It may not be disclosed to
     others or used for any purpose except as expressly consented to by
     TERAK.
                      COPYRIGHT 1980  BY TERAK CORPORATION

                             "ALL RIGHTS RESERVED"}

PROGRAM SURFACE;
CONST
  PI=3.1415926;
  ALPHA=0.3;
  GAMMA=0.69;
  XGAIN=2.5;
  YGAIN=2.5;
  ZGAIN=1.1;
  XORG=150;
  ZORG=200;
TYPE
  SCREENARRAY=ARRAY[0..239] OF PACKED ARRAY[0..319] OF BOOLEAN;

VAR
  CSA,CSG,SNA,SNG,OLDLAT,OLDFUN:REAL;
  IX,IY,K:INTEGER;
  Z:ARRAY[1..69] OF ARRAY[1..69] OF REAL;
  DSPLY1: SCREENARRAY;


procedure drawline(var range:integer;var screen;rowwidth,xstart,ystart,deltax,
                                                       deltay,penstate:integer);
external;



PROCEDURE INITIALIZE;
BEGIN
  CSA:=XGAIN*COS(ALPHA);
  CSG:=YGAIN*COS(GAMMA);
  SNA:=XGAIN*SIN(ALPHA);
  SNG:=YGAIN*SIN(GAMMA);
  FILLCHAR(DSPLY1[0],9600,CHR(0));
  (*FILLCHAR(DSPLY2[0],9600,CHR(0));*)
  UNITWRITE(3,DSPLY1,63);
END (*INITIALIZE*);

PROCEDURE CALCFUNCTION;
VAR IX,IY:INTEGER;
  X,Y,XYS,ZX,ZZ:REAL;
  ZG100,PIFACTOR:REAL;
  SINES:ARRAY[1..69] OF REAL;
BEGIN
  PIFACTOR:=7.0*PI/69;
  ZG100:=100.0*ZGAIN;
  FOR IX:=1 TO 69 DO
  BEGIN
    XYS:=(IX-35)*PIFACTOR;
    IF IX=35 THEN
      SINES[IX]:=1.0
    ELSE
      SINES[IX]:=SIN(XYS)/XYS;
  END;
  FOR IX:=1 TO 69 DO
  BEGIN
    WRITE('.');
    ZX:=SINES[IX]*ZG100;
    FOR IY:=1 TO 69 DO
      Z[IX,IY]:=ZX*SINES[IY];
  END (*FOR IX*);
END (*CALCFUNCTION*);

PROCEDURE CONTOURPOINT(IX,IY:INTEGER; VAR K:INTEGER;
                       VAR OLDLAT,OLDFUN:REAL; VAR DISP:SCREENARRAY);
VAR FUNC,LATRL,X,Y,ZZ:REAL;
  RANGE,I,J:INTEGER;
BEGIN
  FUNC:=ZORG-(Z[IX,IY]+IX*SNA+IY*SNG);
  LATRL:=XORG+IX*CSA-IY*CSG;
  IF OLDLAT=0 THEN
    BEGIN
      OLDLAT:=LATRL;
      OLDFUN:=FUNC;
    END;
  X:=LATRL-OLDLAT;
  X:=X*X;
  Y:=FUNC-OLDFUN;
  Y:=Y*Y;
  Y:=SQRT(X+Y);
  IF Y<>0 THEN
    BEGIN
      Y:=(LATRL-OLDLAT)/Y;
      X:=OLDLAT;
      REPEAT
        X:=X+Y;
        I:=ROUND(X);
        ZZ:=FUNC+(OLDFUN-FUNC)*(X-LATRL)/(OLDLAT-LATRL);
        J:=ROUND(ZZ);
        IF K<>I THEN
          DRAWLINE(RANGE,DISP,20,I,J+1,0,239-J,2);
        DISP[J,I]:=TRUE;
        K:=I;
      UNTIL X<=LATRL;
    END (*Y<>0*);
  OLDLAT:=LATRL;
  OLDFUN:=FUNC;
END (*CONTOURPOINT*);

BEGIN (*SURFACE*)
  INITIALIZE;
  CALCFUNCTION;
  UNITWRITE(3,DSPLY1,56);
  IX:=69;
  WHILE IX>=1 DO
    BEGIN
      OLDLAT:=0;
      K:=0;
      FOR IY:=1 TO 69 DO
        CONTOURPOINT(IX,IY,K,OLDLAT,OLDFUN,DSPLY1);
      IX:=IX-2;
    END;
END.


