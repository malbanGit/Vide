

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)


procedure test;

{ This program displays parts of the Hershey fonts. }

{ maxvertices = size of a polyline }

const
  deltac = 100;
  deltar = 100;
  colmax = 100.0;

var
  glyph, points: integer;
  j, i: integer;
  ch: char;
  name: string[30];
  zx, zy: pointcoord;
  f : text;
  column, row: real;

function scanint(width: integer): integer;

var
  n, i: integer;
  ch: char;

begin
  if eof(f)
  then
    n := -1
  else
    begin
      while eoln(f) do readln(f);
      n := 0;
      for i := 1 to width do
      begin
        read(f, ch);
        if ch = ' ' then ch := '0';
        n := 10 * n + ord(ch) - ord('0')
      end
    end;
  scanint := n
end;

begin
  opengks;
  write('Enter font file name:'); readln(name);
  assign(f, name); reset(f);
  nxfwindow(1, -12, 12, -12, 12);
  setnxfindex(1);
  row := 100; column := 0;
  repeat
    glyph := scanint(5);
    points := scanint(3);
    gotoxy(1, 1);
    write('Glyph ', glyph: 1, ' has ', points: 1, ' vertices.  ');
    clreol;
    if points > maxvertices
    then
      writeln('This exceeds my arbitrary limit of ', maxvertices, ' vertices.');
(*    nxfviewport(1, (column / colmax), (column + deltac) / colmax, (row -
                   deltar) / colmax, row / colmax);
*)    i := 0;
    read(f, ch);
    zx[1] := ord(ch) - ord('R');
    zx[2] := zx[1];
    zy[1] := -10;
    zy[2] := 10;
    polyline(2, zx, zy); clrseg;
    read(f, ch);
    zx[1] := ord(ch) - ord('R');
    zx[2] := zx[1];
    polyline(2, zx, zy); clrseg;
    for j := 2 to points do
    begin
       while eoln(f) do readln(f);
      read(f, ch);
      if ch = ' ' { next coordinate is a move }
      then
        begin
          polyline(i, zx, zy); clrseg;
          i := 0;
          read(f, ch);
          if ch <> 'R' then writeln('Bad assumption: ', ch);
        end
      else
      begin
        i := i + 1;
        if points <= maxvertices then zx[i] := ord(ch) - ord('R');
        read(f, ch);
        if points <= maxvertices then zy[i] := ord('R') - ord(ch);
      end;
    end;
    readln(f);
    if points <= maxvertices then polyline(i, zx, zy); clrseg;
    column := column + deltac;
    if column >= colmax then
    begin
      column := 0;
      row := row - deltar;
      if row < deltar
      then
        begin
          gotoxy(1, 2);
          write('Continue: ');
          readln(ch);
          redrawall; { clears screen since all are outside segments }
          row := colmax;
        end
    end
  until eof(f) or (points < 0);
  closegks;
end;
