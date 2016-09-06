

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)


procedure test;

const
  l1x: pointcoord = (30, 44, 30, 16, 30, 0);
  l1y: pointcoord = (156, 170, 184, 170, 156, 0);
  l2x: pointcoord = (16, 44, 44, 16, 16, 0);
  l2y: pointcoord = (156, 156, 184, 184, 156, 0);
  l3x: pointcoord = (44, 30, 16, 16, 30, 44);
  l3y: pointcoord = (177, 184, 177, 163, 156, 163);
  l4x: pointcoord = (-15, -15, 15, 15, -15, 0);
  l4y: pointcoord = (-15, 15, 15, -15, -15, 0);
  l5x: pointcoord = (-25, -25, 25, 25, -25, 0);
  l5y: pointcoord = (-25, 25, 25, -25, -25, 0);

var
  m1, m2: sxf;
  i, index, segnum: integer;

  procedure animate;

  const
    steps = 24;

  var
    m: sxf;
    pi, ang, dang, t1, t2, c, s: real;
    i: integer;

  begin
    pi := 4 * arctan(1);
    ang := 0.0; dang := pi * 2 / steps; t1 := 0.8; t2 := 1.0 - t1;
    m[3, 1] := 0.0; m[3, 2] := 0.0; m[3, 3] := 1.0;
    for i := 1 to steps do
    begin
      ang := ang + dang; c := cos(ang); s := sin(ang);
      m[1, 1] := c; m[1, 2] := -s; m[1, 3] := -t1 * c + t2 * s + t1;
      m[2, 1] := s; m[2, 2] := c; m[2, 3] := -t1 * s - t2 * c + t2;
      setsxf(1, m);
      m[1, 3] := -t2 * c + t1 * s + t2; m[2, 3] := -t2 * s - t1 * c + t1;
      setsxf(2, m);
    end
  end;

begin
  opengks;
  for index := 1 to 4 do nxfwindow(index, -30.0, 30.0, -30.0, 30.0);
  nxfviewport(1, 0.0, 0.5, 0.0, 0.5);
  nxfviewport(2, 0.5, 1.0, 0.0, 0.5);
  nxfviewport(3, 0.5, 1.0, 0.5, 1.0);
  nxfviewport(4, 0.0, 0.5, 0.5, 1.0);
  nxfwindow(5, -40.0, 100.0, 100.0, 240.0);
  setnxfindex(5);
  createseg(1); polyline(5, l1x, l1y); closeseg;
  createseg(2); polyline(5, l2x, l2y); closeseg;
  setnxfindex(4); polyline(5, l5x, l5y);
  animate;
  setnxfindex(5);
  createseg(20); polyline(6, l3x, l3y); closeseg;
  deleteseg(1); renameseg(20, 1); pause; animate;
  setvis(1, invisible); setvis(2, invisible); pause;
  redrawall; pause;

  segnum := 3;
  for index := 1 to 4 do
  begin
    setnxfindex(index);
    for i := 1 to 2 do
    begin
      createseg(segnum); polyline(5, l4x, l4y); closeseg;
      segnum := segnum + 1;
    end
  end;
  polyline(5, l5x, l5y); pause;
  segnum := 3;
  for index := 1 to 4 do
  begin
    setnxfindex(index);
    evalmat(-15.0, -15.0, 0.0, 0.0, pi/4, 1.0, 1.0, wc, m1);
    setsxf(segnum, m1); segnum := segnum + 1;
    accummat(m1, 0.5, 0.5, 0.0, 0.0, 0.0, 0.8, 0.8, ndc, m2);
    setsxf(segnum, m2); segnum := segnum + 1
  end;
  pause; redrawall; pause;
  setvis(1, visible); setvis(2, visible); pause;
  nxfviewport(5, 0.5, 1.0, 0.5, 1.0); redrawall; pause;
  closegks
end;
