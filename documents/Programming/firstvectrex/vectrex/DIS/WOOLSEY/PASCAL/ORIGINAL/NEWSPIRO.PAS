Program Spiro; (*$R+ *)

const debug = false; points = 7;

(*$IVECDRAW *)
 var height: byte absolute $FB5A;
   i, pen, X1, X2, Y1, Y2, firstx, firsty:  integer;
   H,pi,CB,A,B,C,Theta,DeltaAngle: real;
   Fudge1, Fudge2: real;              { Fudge Factors for overflow bug }
   CH: char;
   OK : boolean;

  Procedure Putem;
  begin
   Drawline(X1,Y1,X2-x1,Y2-y1,pen);    { draw a line between two points }
   X1 := X2; Y1 := Y2; pen := 1;         { save new as old    }
  end;

Procedure Spiro;
Begin
  pen := 0;
 Repeat
   Repeat
        H := CB * Theta;                           { part of the equation }
        Fudge1 := C*Cos(Theta) - B*Cos(H);
        Fudge2 := C*Sin(Theta) - B*Sin(H);
        X2 := (Trunc(Fudge1) + dxmax) div 2;     { Get new X and Y  }
        Y2 := (Trunc(Fudge2) + dymax) div 2;
        if pen = 0 then begin firstx := x2; firsty := y2 end;
        PutEm;                         { Plot Them }
        OK :=  KeyPressed or ((firstx = x2) and (firsty = y2));                         {Stop Plotting}
        Theta := Theta + DeltaAngle;                 { bump radian angle }
        Until Theta > pi + pi;
        clrseg;
     Until OK;
end;

begin                                           {first time through}
 header;
 pi := 4 * arctan(1);
 height := 24;
 X1 := 0;
 Y1 := 0;
 clrvec;

        {  See the better resolution statement above.  Change this one }
        { to DeltaAngle := 0.0314159;  Also make the ITH change above. }
        { As mentioned, this will improve resolution at the cost of    }
        { execution speed.                                             }
 DeltaAngle := 2 * pi / points;                 { set radian angle increment }
 Theta := 0;
 B := 13.0;                                   { these A and B parameters }
 A := 87.5;                                   { work well for the title  }
 C := A - B;                                  { screen.                  }
 CB := C / B;
 OK := false;
 GoToXY(19,12);
 Write('TURBO');
 GoToXY(19,13);
 Write('SPIRO');
 GOTOXY(17,14);
 Write('Key=Start');
 Repeat                                       { Plot the title spirograph }
  Spiro;
  If KeyPressed then OK := True;
  Until OK;
Repeat
 Writeln('*Note:');
 Writeln('<"Ctrl" & "C" terminates program,  <anykey> stops graph>');

  { For what its worth, when A is greater than B, you get hypercycloids. }
  { When B is greater than A, you get epicycloids.                       }

 Repeat
  GotoXY(1,8);
  BufLen := 5;
  Write('Please enter value between 1 and 100: ','':5);
  GoToXY(39,8);
  Read(B);
  Until (B >= 1) and (B <= 100);
 Repeat
  GotoXY(1,9);
  BufLen := 5;
  Write('Please enter another between 1 and 100: ','':5);
  GoToXY(41,9);
  Read(A);
  Until (A >= 1) and (A <= 100);
 (* GraphColorMode;
 Palette(2); *)
 clrvec;
 X1 := 0;                           {First time again}
 Y1 := 0;
 Theta := 0;
 C := A - B;
 CB := C / B;
 OK := false;

 Repeat
 Spiro;                                 { start graphing }
 If KeyPressed then OK := true;
 Until OK; clrscr;
Until true = false;
 end.
