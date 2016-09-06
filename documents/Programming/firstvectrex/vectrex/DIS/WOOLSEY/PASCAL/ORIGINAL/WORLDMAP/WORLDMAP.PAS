program Worldmap;

{  This program draws a project of the world's continents on the hires  }
{  screen very rapidly.  The program uses the external procedure        }
{  LINE.INV which must reside on the default disk in order to compile   }
{  the program.  The program also uses an external data file which      }
{  holds the map coordinates: WORLDMAP.DAT.                             }

{  Jeff Firestone.  June, 1984.                                         }

Const
  debug = false;
  ArSize = 1280;
var
  maxx,maxy,minx,miny: integer;
  n,x,x1,y,y1,i,j : integer;
  WorldArray : array [0..ArSize] of integer;
  f : file;

(*$IDRAWLINE *)

procedure ReadInfo;
begin
  FillChar(WorldArray, SizeOf(WorldArray), 0);
  assign(f, 'worldmap.dat');
  reset(f);
  BlockRead(f, WorldArray, round((ArSize/128)*2));
  close(f);
end;

procedure comparex(n: integer);

begin
  if n < minx then minx := n;
  if n > maxx then maxx := n
end;

procedure comparey(n: integer);

begin
  if n < miny then miny := n;
  if n > maxy then maxy := n
end;

begin
  miny := maxint; minx := maxint; maxy := -maxint; maxx := - maxint;
  ReadInfo;
  header;
  i:= 0;
  n:= WorldArray[i]; i:=i+1;
  repeat
    x1:= WorldArray[i]; i:=i+1; comparex(x1);
    y1:= WorldArray[i]; i:=i+1; comparey(y1);
    x := WorldArray[i]; i:=i+1; comparex(x);
    y := WorldArray[i]; i:=i+1; comparey(y);
    drawline (x1 , - y1, x-x1, y1-y, 1);
(*  drawline (x1 div 4, (dymax - y1) div 4, (x-x1) div 4, (y1-y) div 4, 1); *)
    x1:= x; y1:= y;
    for j:= 3 to n do
    begin
      x := WorldArray[i]; i:=i+1; comparex(x);
      y := WorldArray[i]; i:=i+1; comparey(y);
      drawline (x1 , - y1, x-x1, y1-y, 1);
      x1:= x; y1:= y;
    end; clrseg;
  n:= WorldArray[i]; i:=i+1;
  until (n < 1);
  writeln('X range: ', minx, ' to ', maxx);
  writeln('Y range: ', miny, ' to ', maxy);
end.

