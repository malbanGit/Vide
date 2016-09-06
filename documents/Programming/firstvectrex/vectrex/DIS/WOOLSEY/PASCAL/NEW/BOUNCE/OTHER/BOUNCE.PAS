Program Bounce;
{
   Bounce:
           Bounce will produce animated patterns on the Terak screen by
           moving the points and lines between the points of an n sided
           figure.  Idea was stolen from similar (PPT) program found on
           the Plato system.
                                 Bob Isch
                                 19 Oct 79
}

Const
   debug = false; (* malban *)
   MaxPoints = 20;
   Pi = 3.1415926535;
   Pi2 = 6.2831853070;
   PiDiv2 = 1.570796327;
   Pi3 = 9.424777962;
   Xm = 160;
   Ym = 75;
   DefDelta = 8;
   Ones = -1  (* 16 one bits *);

Type
   SideType = (Left, Top, Right, Bottom);
   Quadrants = 1 .. 4;
   PenType = 0 .. 1;
   xy = (xq, yq);
   Point = Record
              Angle, dx, dy, x, y: Real;
              Side: SideType;
              SegCnt, SpeedF: Integer;
              Frozen: Boolean;
              Pen: PenType
           End;

Var
   Qpts: Array[Sidetype, 1 .. 2, xy] of Real;
   Pick: Array[SideType, 1 .. 2, Boolean] of SideType;
   Points: Array[1 .. MaxPoints] of Point;
   TotalCycles, DelayCycles, Count, Count2, NumSides, BackGround, SpeedFctr,
      SeedA, SeedB: Integer;
   InitPen, FollowPen: PenType;
   VarSpeed, FreezeOne, Bells: Boolean;

Function Deg(Angle: Real): Integer;

Begin
  Deg := Round(Angle * 180.0 / Pi)
End; (* Deg *)

(*$IDRAWLINE *)

Procedure Init;

Begin
   Qpts[left, 1, xq] := xm; Qpts[left, 1, yq] := ym;
   Qpts[left, 2, xq] := xm; Qpts[left, 2, yq] := 1; Qpts[top, 1, xq] := 1;
   Qpts[top, 1, yq] := 1; Qpts[top, 2, xq] := xm; Qpts[top , 2, yq] := 1;
   Qpts[right, 1, xq] := 1; Qpts[right, 1, yq] := 1; Qpts[right, 2, xq] := 1;
   Qpts[right, 2, yq] := ym; Qpts[bottom, 1, xq] := xm;
   Qpts[bottom, 1, yq] := ym; Qpts[bottom, 2, xq] := 1;
   Qpts[bottom, 2, yq] := ym; Pick[left, 1, true] := top;
   Pick[left, 1, false] := right; Pick[left, 2, true] := right;
   Pick[left, 2, false] := bottom; Pick[top, 1, true] := bottom;
   Pick[top, 1, false] := left; Pick[top, 2, true] := right;
   Pick[top, 2, false] := bottom; Pick[right, 1, true] := bottom;
   Pick[right, 1, false] := left; Pick[right, 2, true] := left;
   Pick[right, 2, false] := top; Pick[bottom, 1, true] := top;
   Pick[bottom, 1, false] := right; Pick[bottom, 2, true] := left;
   Pick[bottom, 2, false] := top
End; (* Init *)

Procedure ComputeIntercept(Side: SideType; x,y: Real; Angle: Real;
                           Var xi,yi: Real);

Var
   a, b: Real;

Begin
   a := Sin(Angle) / Cos(Angle); b := y - a * x; xi := 1; yi := 1;
   Case Side
      of
         Left:
            yi := a+b (* a*1+b; (x=1) *);
         Top:
            Begin
               xi := (Ym - b) / a; yi := Ym
            End;
         Right:
            Begin
               yi := a * Xm + b; xi := Xm
            End;
         Bottom:
            xi := (1 - b) / a
      End
End; (* ComputeIntercept *)

Procedure UpDate(P: Integer);

Var
    Phi, xi, yi: Real;
    q: Quadrants;
    Chk: Integer;

Begin
   With Points[P] Do
      If Not Frozen
      Then
         Begin
            SegCnt := SegCnt - 1;
            If SegCnt <= 0
            Then
               Begin
                  If Bells And (P <= NumSides)
                  Then
                     Write(Chr(7));
                  Angle := Pi3 - Angle;
                  While Angle > Pi Do
                     Angle := Angle-Pi;
                  q := Ord(Angle > PiDiv2) + 1;
                  Phi := (y - Qpts[Side, q, yq]) / (x - Qpts[Side, q, xq]);
                  Phi := arcTan(Phi);
                  If Phi < 0
                  Then
                     Phi := Phi + Pi;
                  Side := Pick[Side, q, Angle > Phi];
                  ComputeIntercept(Side, x, y, Angle, xi, yi);
                  SegCnt := Trunc(SqRt(Sqr(xi - x) + Sqr(yi - y)) / SpeedF);
                  If SegCnt<>0
                  Then
                     Begin
                        dx := (xi - x) / SegCnt; dy := (yi - y) / SegCnt
                     End
                  Else
                     Begin
                       dx := xi - x; dy := yi - y
                     End;
                  Chk := (P Mod NumSides) + 1;
                  If P > NumSides
                  Then
                     Chk := Chk + NumSides;
                  If Points[Chk].Frozen
                  Then
                     Begin
                        Points[Chk].Frozen := False; Frozen := True
                     End
               End (* If *);
      If Not Frozen
      Then
         Begin
            x := x + dx; y := y + dy
         End
      Else
         SegCnt := SegCnt + 1
   End (* With *)
End; (* UpDate *)


Procedure DoPair(Var P1: Point; P2: Point);

Var
   ddx, ddy: Integer;

Begin
   With P2 Do
      Begin
         ddx := Round(x - p1.x); ddy := Round(y - p1.y);
        If ddx >= 0
        Then
           ddx := ddx + 1
        Else
           ddx := ddx - 1;
        If ddy >= 0
        Then
           ddy := ddy + 1
        Else
           ddy := ddy - 1;
        DrawLine(Round(P1.x), Round(P1.y), ddx, ddy, Pen)
     End
End (* DoPair *);

Procedure Cycle;

Var
   i: Integer;

Begin
   For i := 1 to NumSides Do
      DoPair(Points[i], Points[(i Mod NumSides) + 1]);
   For i := NumSides + 1 to 2 * NumSides do
      DoPair(Points[i], Points[(i Mod NumSides) + NumSides + 1]);
   For i := 1 to 2 * NumSides do
      UpDate(i)
End (* Cycle *);

Procedure GetParams;

Begin
   ClrScr;
   Write(' How Many Sides [1..',MaxPoints div 2,']? '); Readln(Input, NumSides);
   Write(' Delay Cycles  [25]? '); Readln(Input, DelayCycles);
   Write(' Total Cycles [300]? '); Readln(Input, TotalCycles);
   Write(' Speed Factor  [10]? '); Readln(Input, SpeedFctr);
   Write(' Variable Speed   [0=No 1=Yes]? '); Readln(Input, Count);
   VarSpeed := (Count = 1);
   Write(' Freeze One Point [0=No 1=Yes]? '); Readln(Input, Count);
   FreezeOne := (Count = 1);
   Write(' Bells [0=No 1=Yes]? '); Readln(Input, Count); Bells := (Count = 1);
   ClrScr; Writeln;
   Writeln(' Pen Colors are: '); Writeln('   1: Pen Down   (Write White)');
   Writeln('   0: Erase      (Write Black)'); Writeln; Writeln(' BackGround:');
   Write(' 0) Normal (Black) 1) Inverse (White)? '); Readln(Input, BackGround);
   BackGround := BackGround * Ones;
   Write(' Initial Pen Color? '); Readln(Input, InitPen);
   Write(' Follow Pen Color? '); Readln(Input, FollowPen); ClrScr
End (* GetParams *);

Procedure Setup;

Var
   i, j: Integer;

Begin
   ClrScr;
   For i := 1 to NumSides Do
   Begin
      With Points[i] Do
      Begin
         x := Random(xm); y := Random(ym div 2); Pen := InitPen;
         Angle := Pi * (Random(999) / 1000.0);
         Side := Bottom; dx := 0; dy := 0; SegCnt := 0;
         If VarSpeed
         Then
            SpeedF := SpeedFctr + Random(SpeedFctr Div 2) - Random(SpeedFctr
            Div 2)
         Else
            SpeedF := SpeedFctr;
         Frozen := False
      End;
      UpDate(i);
      Points[i].Frozen := False
   End;
   Points[1].Frozen := FreezeOne;
   For i := NumSides + 1 to 2 * NumSides Do
   Begin
      Points[i] := Points[i - NumSides]; Points[i].Pen := FollowPen
   End;
   For i := 1 to DelayCycles Do
   Begin
      For j := 1 to NumSides Do
         DoPair(Points[j], Points[(j Mod NumSides) + 1]);
      For j := 1 to NumSides Do
         Update(j)
   End
End (* SetUp *);

Begin (* Main Program *)
   Init; GetParams; Setup;
   For Count := 1 to TotalCycles - DelayCycles Do
     Cycle;
   For Count := 1 to DelayCycles Do
   Begin
      For Count2 := NumSides to 2 * NumSides do
         DoPair(Points[Count2], Points[(Count2 Mod NumSides) + NumSides + 1]);
      For Count2 := NumSides to 2 * NumSides do
         UpDate(Count2)
   End
End (* Bounce *) .

