

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)


procedure test;
var
  xd, yd, xu, yu: pointcoord;
begin
  opengks;
  xd[1] :=  0.0; xd[2] := 10.0; xd[3] :=  5.0; xd[4] :=  0.0;
  xu[1] :=  0.0; xu[2] :=  5.0; xu[3] := 10.0; xu[4] :=  0.0;
  yd[1] :=  6.0; yd[2] :=  6.0; yd[3] := -4.0; yd[4] :=  6.0;
  yu[1] :=  0.0; yu[2] := 10.0; yu[3] :=  0.0; yu[4] :=  0.0;
  nxfwindow(1, 3.0, 11.0, 3.0, 7.0);
  polyline(4, xu, yu); polyline(4, xd, yd);
  setnxfindex(1);
  nxfviewport(1, 0.5, 1.0, 0.375, 0.625);
  polyline(4, xd, yd); polyline(4, xu, yu);
  setnxfindex(2);
  nxfwindow(2, 0.0, 15.0, -5.0, 10.0);
  nxfviewport(2, 0.0, 0.5, 0.5, 1.0);
  polyline(4, xu, yu); polyline(4, xd, yd);
  closegks
end;

