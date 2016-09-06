const
  debug = false;
  xscale = 1;
  yscale = 1;

(*$IVECDRAW *)

var
  c, x, y, p, i: integer;
  f: text;
  oldx, oldy: integer;

begin
  assign(f, 'suprise.dat');
  reset(f);
  header;
  oldx := 0;
  oldy := 0;
  FOR I := 1 TO 360 do
    begin
      READln(f, y, x, P);
      y := 330 - y;
      x := dxmax - x;
      IF P = 13
      THEN C := 0
      ELSE C := 1;
      drawline(oldx div xscale,
               oldy div yscale,
               (x - oldx) div xscale,
               (y - oldy) div yscale,
               c);
      if c = 0 then clrseg;
      oldx := x;
      oldy := y
  end;
writeln('EAT YOUR HEART OUT!!!')
end.

