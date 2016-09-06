

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)


procedure test;

{  This program draws a projection of the world's continents }

{ maxvertices = size of a polyline }

var
  n,x,y,j,k : integer;
  zx, zy: pointcoord;
  f : text;

begin
  opengks; assign(f, 'worldata.map'); reset(f);
  nxfwindow(1, -10, 615, 400, 600);
  setnxfindex(1);
  readln(f, n);
  repeat
    readln(f, x, y);
    k := 1; zx[k] := x; zy[k] := 600 - y;
    for j:= 2 to n do
    begin
      readln(f, x, y);
      k := k + 1; zx[k] := x; zy[k] := 600 - y;
      if k = maxvertices then
      begin
        polyline(k, zx, zy); clrseg;
        zx[1] := zx[k]; zy[1] := zy[k];
        k := 1;
      end;
    end;
  if k > 1 then polyline(k, zx, zy); clrseg; (* should work well *)
  readln(f, n);
  until (n < 1) or eof(f);
  closegks;
end;
