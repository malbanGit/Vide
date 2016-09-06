Program ThreeD;

{  This program is a modified version of PLOT3D.PAS.  It prompts you }
{  for the rotation amounts before plotting the next iteration.      }

{  The program displays and rotates three-dimensional images on      }
{  the IBM PC's graphics display.  The program used three data files }
{  on the default drive.  The data files have the extension '.3D'.   }

{  The program uses two External Procedures: Line.inv & Cls.inv.     }
{  These procedures must be on the default drive when compiling.     }

{  Author - Jay Mallin                                               }
{           PC Tech Journal, May 1984, pp. 44-48.                    }
{           Typed & Translated into Pascal by Jeff Firestone.        }


Type
  Strng = String[200];

Var
  Nam : Strng;
  f : text;
  exit : boolean;
  i, j, Length, LineCount, pnt, pta, ptb, temp1, temp2 : integer;

  max, xmax, ymax, zmax, xmin, ymin, zmin : real;
  Center, Xcenter, Ycenter, Zcenter : Real;
  factor, temp, rcnt : real;

  Rot : Array [0..2, 0..2] of real;
  Lines : Array [0..149, 0..1] of integer;
  XYZ : Array [0..149, 0..2] of real;
  XY : Array [0..149, 0..1] of integer;


Procedure Line(x1,y1,x2,y2,color:integer);
          External 'line.inv';

Procedure Cls; External 'Cls.inv';


Procedure InitPrgm;  { Initialize the arrays & global variables }
Begin
  FillChar(Rot, SizeOf(Rot), 0);
  FillChar(Lines, SizeOf(Lines), 0);
  FillChar(XYZ, SizeOf(XYZ), 0);
  FillChar(XY, SizeOf(XY), 0);
  max:= 0; Center:= 0; Rcnt:= 0;
  ClrScr;
end;


{ Array XYZ contains the three coordinates for each data point, and  }
{ Array XY contains the x, y coordinates for drawing on the display. }

Procedure ReadFile;  { Read in the data from the '.3D' file }
begin
  assign(f, 'diamond.3d');
  reset(f);
  readln(f, length);
  for i:= 0 to length-1 do
    read(f, xyz[i,0], xyz[i,1], xyz[i,2]);

{ Now get the pairs of points to connect with lines and store in the   }
{ array LINES.                                                         }

  LineCount:= -1;
  while (LineCount < 149) and not(EOF(f)) do
  begin
    LineCount:= LineCount + 1;
    read(f, temp1, temp2);
    Lines[LineCount, 0]:= Temp1-1;
    Lines[LineCount, 1]:= Temp2-1;
  end;
end;


{ The figure is centered, then proportioned to fit on the screen.      }
{ The first step is to find the largest and smallest value of x,y & z. }

Procedure SetupVars;  { Initialize our Variables }
begin
  xmax:= xyz[0,0]; ymax:= xyz[0,1]; zmax:= xyz[0,2];
  xmin:= xmax;     ymin:= ymax;     zmin:= zmax;
  for i:= 1 to length do
  begin
    if xyz[i,0] > xmax then xmax:= xyz[i,0];
    if xyz[i,1] > ymax then ymax:= xyz[i,1];
    if xyz[i,2] > zmax then zmax:= xyz[i,2];
    if xyz[i,0] < xmin then xmin:= xyz[i,0];
    if xyz[i,1] < ymin then ymin:= xyz[i,1];
    if xyz[i,2] < zmin then zmin:= xyz[i,2];
  end;

{ A center is found between the greatest and smallest values for each   }
{ of the three axis, and all the coordinate values are adjusted to move }
{ those centers to be at the center.                                    }

  Xcenter:= (xmax + xmin) / 2;
  Ycenter:= (ymax + ymin) / 2;
  Zcenter:= 1+(zmax + zmin) / 2;
  for i:= 0 to length do
  begin
    xyz[i,0]:= xyz[i,0] - Xcenter;
    xyz[i,1]:= xyz[i,1] - Ycenter;
    xyz[i,2]:= xyz[i,2] - Zcenter;
  end;

{ The largest value of all the newly adjusted coordinates is found, }
{ and that is used to scale the picture to stay within the screen.  }

  max:= Xmax - Xcenter;
  if max < Ymax - Ycenter then max:= Ymax - Ycenter;
  if max < Zmax - Zcenter then max:= Zmax - Zcenter;
  Factor:= 90 / Max;
  for i:= 0 to length do
  begin
    xyz[i,0]:= factor * xyz[i,0];
    xyz[i,1]:= factor * xyz[i,1];
    xyz[i,2]:= factor * xyz[i,2];
  end;
end;


{ Now we begin the section of Procedure which are run each time we }
{ wish to rotate the object in XYZ.                                }

Procedure DrawIt;

{ First build the 2D data based upon the 3D data.                  }

begin
  for pnt:= 0 to length do
  begin
    xy[pnt, 1]:= round(91 - (5*xyz[pnt,2]/12));
    xy[pnt, 0]:= round(320 + xyz[pnt, 1]);
  end;

{ Clear the old screen and draw the 2D data by connecting the points. }

  cls;
  for i:= 0 to LineCount do
  begin
    pta:= Lines[i,0];
    ptb:= Lines[i,1];
    Line(xy[pta,0],xy[pta,1],xy[ptb,0],xy[ptb,1],1);
  end;
end;


{ This procedure is not currently being used. }
Procedure GetCoords;
    begin
      gotoXY(1,24);
      writeln('Enter next rotation in degrees for each axis, or enter 361 to exit.');
      Line(0,199,620,199,1);
      gotoXY(1,25);
      write('X: '); read(rot[0,0]);
      if rot[0,0] = 361 then exit:= true;
      gotoXY(14,25);
      write('Y: '); read(rot[1,0]);
      if rot[1,0] = 361 then exit:= true;
      gotoXY(27,25);
      write('Z: '); read(rot[2,0]);
      if rot[2,0] = 361 then exit:= true;
    end;  {Procedure GetCoords}


{ Convert the coordinates and rotates them about the x, y & Z axis. }

Procedure CalcCoords;
    begin

{ Convert the input to degrees; find SIN and COS of each.  All the }
{ results are stored in Rot.                                       }

      for i:= 0 to 2 do
      begin
        rot[i,0]:= pi*(round(rot[i,0]) mod 360)/180;
        rot[i,1]:= sin(rot[i,0]);
        rot[i,2]:= cos(rot[i,0]);
      end;

{ Compute the new coordinates in XYZ to rotate around the Z axis.  }

      if rot[2,2] <> 1 then
        for pnt:= 0 to length do
        begin
          temp:= xyz[pnt,0];
          xyz[pnt,0]:= (rot[2,2] * xyz[pnt,0]) - (rot[2,1] * xyz[pnt,1]);
          xyz[pnt,1]:= (rot[2,1] * temp) + (rot[2,2] * xyz[pnt,1]);
        end;

{ Rotate around the Y axis if the rotation is not 0. }

      if rot[1,2] <> 1 then
        for pnt:= 0 to length do
        begin
          temp:= xyz[pnt,0];
          xyz[pnt,0]:= (temp * rot[1,2]) + (xyz[pnt,2] * rot[1,1]);
          xyz[pnt,2]:= (xyz[pnt,2] * rot[1,2]) - (temp * rot[1,1]);
        end;

{ Rotate around the X axis. }

      if rot[0,2] <> 1 then
         for pnt:= 0 to length do
         begin
           temp:= xyz[pnt,1];
           xyz[pnt,1]:= (temp * rot[0,2]) - (xyz[pnt,2] * rot[0,1]);
           xyz[pnt,2]:= (temp * rot[0,1]) + (xyz[pnt,2] * rot[0,2]);
         end;
    end; {Procedure CalcCoords}


{ Here we caculate the stepping of the rotation.  This sends the figure  }
{ spinning in space.                                                     }

Procedure ProcessCoords;
begin
  exit:= false;
  while not(exit) do
  begin
    calccoords;
    DrawIt;
    GetCoords;
    {rot[0,0]:= rot[0,0]+4;  { X axis rotation }
    {rot[1,0]:= rot[1,0]+7;  { Y axis rotation }
    {rot[2,0]:= rot[2,0]+3;  { Z axis rotation }
    {rcnt:=rcnt+1;if rcnt>20 then exit:= true;}

    {for i:= 0 to length do
    begin
      xyz[i,0]:= 0.97 * xyz[i,0];
      xyz[i,1]:= 0.97 * xyz[i,1];
      xyz[i,2]:= 0.97 * xyz[i,2];
    end;}
  end; {while not(exit)}
end; {Procedure ProcessCoords}


begin
  InitPrgm;
  ReadFile;
  SetupVars;
  HiRes;  HiResColor(7);
  ProcessCoords;
  TextMode;
end.
