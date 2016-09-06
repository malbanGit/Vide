(*   Jeff Woolsey, CSci 5107  Simple GKS program, 84/11/20.  *)

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

(*$R+ enable range checking *)

program gkssubset;

const
  purple = 1;
  debug = false;
  maxvertices = 120;
  maxnxfindex = 10;

type
  coordcode = (WC, NDC);
  viscode = (visible, invisible);
  pointcoord = array[1 .. maxvertices] of real;
  ptr2primitive = ^ primitive;
  primitive = record
                transform: integer;
                points: 0 .. maxvertices;
                x, y: pointcoord;
                next: ptr2primitive;
              end;
  sxf = array[1 .. 3, 1 .. 3] of real;
  ptr2segment = ^ segment;
  segment = record
              visible: boolean;
              name: integer;
              transform: sxf;
              element: ptr2primitive;
              next: ptr2segment;
            end;

var
  openseg, segments: ptr2segment;
  nxf: record
         index: integer;
         window, viewport: array[0 .. maxnxfindex] of record
           xmin, xmax, ymin, ymax: real end;
       end;
  x, y: pointcoord;
  identity: sxf;

(*$IDRAWLINE *)
(*$IGKSCODE *)
(*$Igksworld *)

begin
  test;
end.
