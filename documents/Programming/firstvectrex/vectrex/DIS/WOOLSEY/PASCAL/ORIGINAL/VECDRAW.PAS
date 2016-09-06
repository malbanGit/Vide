
(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

type
  twine = string[60];

const
  fuzz = 0;
  dxmin = 0; dxmax = 255;
  dymin = 0; dymax = 255;
  control = $30;
  data = $31;
  lsb = $32;
  msb = $33;
  vectors = $100;

var
  vecx, vecy, address: integer; intersegment: boolean;

procedure gimme; { wrest control of interface from Vectrex }

begin
  port[control] := $04 { HALT };
  port[control] := $04 { HALT }; { vec should be stopped by now. thanx, turbo }
  port[control] := $84 { HALT + HOST }; { take control of interface }
end;

procedure leggo; { release control of interface to Vectrex }

begin
  port[control] := 0; { let her rip }
end;

function getaddr: integer;

begin
  getaddr := port[lsb] + 256 * port[msb];
end;

procedure setaddr(x: integer);

begin
  port[lsb] := x mod 256; port[msb] := x div 256
end;

procedure clrseg; { prepare the display for a new segment }

var
  z: byte;

begin
  vecx := 0; vecy := 0;
  if intersegment then
  begin
    gimme;
    setaddr(address);
    repeat z := port[data]
    until z = 1;
    address := getaddr;
    leggo
  end;
  intersegment := false;
end;

procedure clrvec; { clear the display }

var
  i: integer;

begin
  intersegment := false;
  setaddr(vectors); gimme;
  if address = 0 then address := 16000; { clear lots initially }
  for i := vectors to address + 4 { fudge } do port[data] := 1; { set terminators }
  vecx := 0; vecy := 0; leggo; address := vectors;
end;

procedure puthex(x: twine);

const
  digit: array['0' .. 'F'] of byte =
         (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 10, 11, 12, 13, 14, 15);
var
  i, j: integer;
  z: byte;

begin
  for i := 1 to length(x) div 2 do
  begin
    z := 0;
    for j := 0 to 1 do
      z := 16 * z + digit[x[j+i+i-1]];
    port[data] := z;
  end;
end;

procedure header;

var
  ch: char;

begin
  address := 0;
  gimme;
  setaddr(0); { force feed resident device driver }
  puthex('6720474345203139383680FD0DF85000');
  puthex('D0475241504849435380008E002E108E');
  puthex('C880EC81EDA18C00642FF77EC8808E30');
  puthex('75BFC83DBDF192B60000816726F6BDF2');
  puthex('A58E01008D0220ECA684270881012713');
  puthex('81FF260FBDF35486CEB7D00CBDF408A6');
  puthex('8020E539');
  clrvec; leggo;
  writeln('Hit RESET on Vectrex.');
  write('then hit return here.'); readln(ch);
end;

PROCEDURE drawline(XSTART, YSTART, DELTAX, DELTAY: INTEGER; INK: INTEGER);

var
  dx, dy, x, y, xh, yh: integer; zip: byte; twice, zing: boolean;

  function harbor: integer; { read a signed port }

  var
    z: integer;

  begin
    z := port[data];
    if z > 127 then z := - (256 - z);
    harbor := z;
  end;

BEGIN
  if debug then
    writeln('DRAWLINE(', xstart, ', ', ystart, ', ',
                         deltax, ', ', deltay, ', ', ink, ')');
  xstart := xstart - 128;
  ystart := ystart - 128;
  gimme;
  if ink = 1
  then
    begin
      intersegment := true;
      setaddr(address);
      if (abs(vecx - xstart) > fuzz) or (abs(vecy - ystart) > fuzz) then
      begin
        twice := (abs(xstart-vecx) > 127) or (abs(ystart-vecy) > 127);
        dx := xstart - vecx; dy := ystart - vecy;
        if debug then writeln('First twice = ', twice);
        if twice then begin dx := dx div 2; dy := dy div 2 end;
        port[data] := 0;
        port[data] := dy; vecy := ystart;
        port[data] := dx; vecx := xstart;
        if twice then
        begin
          port[data] := 0;
          port[data] := dy;
          port[data] := dx;
        end;
      end;
      twice := (abs(deltax) > 127) or (abs(deltay) > 127);
      if debug then writeln('Second twice = ', twice);
      if twice then
      begin
        deltax := deltax div 2;
        deltay := deltay div 2; { this causes untold problems for line erase }
      end;
      port[data] := $FF;
      port[data] := deltay; vecy := vecy + deltay;
      port[data] := deltax; vecx := vecx + deltax;
      if twice then
      begin
        port[data] := $FF;
        port[data] := deltay; vecy := vecy + deltay;
        port[data] := deltax; vecx := vecx + deltax;
      end;
      address := getaddr;
    end
  else { ok, now the hard part, erasing lines }
    if (deltax <> 0) or (deltay <> 0) then
    begin
      setaddr(vectors); { start at head of list }
      zip := port[data];
      repeat
        x := 0; y := 0; zing := true;
        while zing do
        begin
          case zip of
            $00: { move } begin
                            yh := harbor; xh := harbor;
                            if debug then
                            writeln('drawline(', x, ', ', y, ', ',
                                                 xh, ', ', yh, ', ', 0, ')');
                            y := y + yh; x := x + xh
                          end;
            $01: { term } zing := false;
            $FF: { draw } begin
                            yh := harbor; xh := harbor;
                            if debug then
                            writeln('drawline(', x, ', ', y, ', ',
                                                 xh, ', ', yh, ', ', 1, ')');
                            if (y = ystart) and (x = xstart) and
                              (yh = deltay) and (xh = deltax) then
                              begin
                                if debug then writeln('Found it!');
                                setaddr(getaddr - 3); port[data] := 0;
                                yh := harbor; xh := harbor; { reread }
                              end;
                            y := y + yh; x := x + xh
                          end;
          else writeln('FORMAT ERROR! zip ', zip);
          end { case } ;
          zip := port[data];
        end { while };
        zing := zip <> 1;
        if zing and debug
        then writeln('zing')
        else if debug then writeln('zip ', zip);
      until not zing;
    end;
  leggo
 END;
(*
procedure pause;

var
  ch: char;

begin
  write('Pause: ');
  readln(ch);
end;

var
  i: integer;

begin
  header;
  drawline(0,0,50,0,1);
  drawline(50,0,0,50,1);
  drawline(50,50,-50,0,1);
  drawline(0,50,0,-50,1); pause;
  for i := 1 to 75 do
  begin
    drawline(4 * i, 100 + i, 4, 1, ord(odd(i))); if odd(i) then clrseg;
  end;
  clrseg; pause;
  for i := 2 downto -2 do
  begin
    drawline(-50, i, 50, 0, 1);
    drawline(0, i, 50, 0, 1);
    clrseg;
  end;
  for i := 2 downto -2 do
  begin
    drawline(0, i, 50, 0, 0);
    drawline(-50, i, 50, 0, 0);
  end;
  drawline(10, 20, 30, 40, 1);
end.
 *)
