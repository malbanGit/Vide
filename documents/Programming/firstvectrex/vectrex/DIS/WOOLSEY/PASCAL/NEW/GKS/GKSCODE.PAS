

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)


procedure print(m: sxf);

var
  i, j: integer;

begin
  for i := 1 to 3 do
  begin
    writeln;
    for j := 1 to 3 do
      write(m[i, j]: 12: 5)
  end;
  writeln
end;

function findseg(name: integer): ptr2segment;

var
  p, q: ptr2segment;

begin
  q := nil;
  p := segments;
  while p <> nil do
    if p^.name = name
    then begin q := p; p := nil { short circuit } end
    else p := p^.next;
  findseg := q
end;

procedure world(nx, ny: real; var wx, wy: real; nxfindex: integer);

{ undo normalization }

begin
  if debug then writeln('Worldizing ', nx: 10: 7, ', ', ny: 10: 7, '.');
  with nxf.window[nxfindex] do
  begin
    wx := xmin + nx * (xmax - xmin);
    wy := ymin + ny * (ymax - ymin);
  end;
  if debug then
    writeln('Worldized ', nx: 10: 7, ', ', ny: 10: 7,
                  ' to ', wx: 10: 7, ', ', wy: 10: 7, '.');
end;

procedure work(nx, ny: real; var wx, wy: real; nxfindex: integer);

{ workstation transformation }

begin
  with nxf.viewport[nxfindex] do
  begin
    wx := (nx * (xmax - xmin) + xmin) * (dxmax - dxmin) + dxmin;
    wy := (ny * (ymax - ymin) + ymin) * (dymax - dymin) + dymin;
  end;
end;

procedure normal(wx, wy: real; var nx, ny: real; nxfindex: integer);

{ something strange is going on here.  the x values have factors of
  1E7 to 1E17 in them (even when x=0!!!) their source is unknown }

{ normalization transformation }

begin
  if debug then writeln('Normalizing ', wx: 10: 7, ', ', wy: 10: 7, '.');
  with nxf.window[nxfindex] do
  begin
    nx := (wx - xmin) / (xmax - xmin);
    ny := (wy - ymin) / (ymax - ymin);
  end;
  if debug then
  writeln('Normalized ', 0.0 + wx: 10: 7, ', ', wy: 10: 7,
                 ' to ', nx: 10: 7, ', ', ny: 10: 7, '.');
end;

{ utility } procedure accummat(matin: sxf; px, py, vx, vy, angle, sx, sy: real;
                              c: coordcode; var m: sxf);

var
  t, r, s: sxf;

  procedure crash(b, a: sxf; var c: sxf);

  { crash two matrices together to get a product. see J&W p40 }

  var
    i, j, k: integer;

  begin
    for i := 1 to 3 do for j := 1 to 3 do
    begin
      c[i, j] := 0;
      for k := 1 to 3 do c[i, j] := c[i, j] + a[i, k] * b[k, j];
    end;
  end;

  procedure translate(x, y: real; var m: sxf);

  begin
    m := identity; m[1, 3] := x; m[2, 3] := y;
  end;

  procedure scale(x, y: real; var m: sxf);

  begin
    m := identity; m[1, 1] := x; m[2, 2] := y;
  end;

  procedure rotate(a: real; var m: sxf);

  begin
    m := identity;
    m[1, 1] := cos(a); m[2, 2] := m[1, 1];
    m[2, 1] := sin(a); m[1, 2] := - m[2, 1];
  end;

begin { accummat }
  if debug then writeln('Accumat: ', px: 10: 7, py: 10: 7, vx: 10: 7, vy: 10: 7);
  if c <> NDC then
  begin
    normal(px, py, px, py, nxf.index);
    normal(vx, vy, vx, vy, nxf.index);
  end;
  { Scale about point }
  translate(- px, - py, t);
  crash(matin, t, t);
  scale(sx, sy, s);
  crash(t, s, s);
  { Rotate about same point }
  rotate(angle, r);
  crash(s, r, r);
  translate(px, py, t);
  crash(r, t, m);
  { Translate }
  translate(vx, vy, t);
  { mash 'em all up }
  crash(m, t, m); { check all those rules about matrix multiplication }
end;

{ utility } procedure evalmat(px, py, vx, vy, angle, sx, sy: real;
                              c: coordcode; var m: sxf);

begin
  accummat(identity, px, py, vx, vy, angle, sx, sy, c, m)
end;

procedure dumpsegs;

var
  i, j: integer;
  e: ptr2primitive;
  s: ptr2segment;

begin
  s := segments;
  while s <> nil do
  begin
    writeln('Segment ', s^.name, s^.visible);
    for i := 1 to 3 do
    begin
      for j := 1 to 3 do write(s^.transform[i, j]: 10: 5);
      writeln
    end;
    e := s^.element;
    while e <> nil do
    begin
      writeln(e^.points, ' point primitive');
      for i := 1 to e^.points do
        writeln(e^.x[i]: 10: 5, e^.y[i]: 10: 5);
      e := e^.next;
    end;
    s := s^.next;
  end;
  writeln;
end;

{ utility } procedure pause;

begin
  if not debug then gotoxy(1, 1);
  writeln('Pause!');
  readln;
  if not debug then gotoxy(1, 1);
  writeln('      ');
end;

procedure pline(nxfindex, n: integer; var px, py: pointcoord; pen: integer);

var
  i: integer;
  x, y, lastx, lasty: real;

  procedure clip(xf, yf, xt, yt, xmin, xmax, ymin, ymax: real);

  { Cohen-Sutherland clipping }

  type
    outcode = set of 1 .. 4;

  var
    accept, reject, done: boolean;
    outcodef, outcodet: outcode;

    function acceptcheck(o1, o2: outcode): boolean;

    begin
      acceptcheck := o1 + o2 = [];
    end;

    procedure outcodes(x, y: real; var o: outcode);

    begin
      o := [];
      if y > ymax then o := o + [1];
      if y < ymin then o := o + [2];
      if x > xmax then o := o + [3];
      if x < xmin then o := o + [4];
    end;

    function rejectcheck(o1, o2: outcode): boolean;

    begin
      rejectcheck := o1 * o2 <> [];
    end;

    procedure swap;

    var
      t: outcode;
      z: real;

    begin
      t := outcodef; outcodef := outcodet; outcodet := t;
      z := xf; xf := xt; xt := z;
      z := yf; yf := yt; yt := z;
    end;

  begin { clip }
    if debug then writeln('clip');
    accept := false;
    reject := false;
    done := false;
    repeat
      outcodes(xf, yf, outcodef);
      outcodes(xt, yt, outcodet);
      reject := rejectcheck(outcodef, outcodet);
      if reject then done := true
      else
      begin
        accept := acceptcheck(outcodef, outcodet);
        if accept then done := true
        else
        begin
          if outcodef = [] then swap;
          if 1 in outcodef
          then
            begin
              xf := xf + (xt - xf) * (ymax - yf) / (yt - yf);
              yf := ymax
            end
          else if 2 in outcodef
               then
                 begin
                   xf := xf + (xt - xf) * (ymin - yf) / (yt - yf);
                   yf := ymin
                 end
               else if 3 in outcodef
                    then
                      begin
                        yf := yf + (yt - yf) * (xmax - xf) / (xt - xf);
                        xf := xmax
                      end
                    else if 4 in outcodef
                         then
                           begin
                             yf := yf + (yt - yf) * (xmin - xf) / (xt - xf);
                             xf := xmin
                           end
        end
      end
    until done;
    if accept then
      begin
        if debug then
          writeln(xf: 10: 6, ' ', yf: 10: 6, ' ', xt: 10: 6, ' ', yt: 10: 6);
        drawline(round(xf), round(yf), round(xt - xf), round(yt - yf), pen);
      end
  end;

begin { pline }
  for i := 1 to n do
  begin { guts }
    if i > 1 then begin lastx := x; lasty := y; end;
    work(px[i], py[i], x, y, nxfindex);
    { clipping and drawing }
    if i > 1 then
      with nxf.viewport[nxfindex] do
        clip(lastx, lasty, x, y,
             xmin * (dxmax-dxmin), xmax * (dxmax-dxmin),
             ymin * (dymax-dymin), ymax * (dymax-dymin));
  end;
end { pline } ;

procedure drawseg(s: ptr2segment; pen: integer);

var
  e: ptr2primitive;
  i: integer;
  newx, newy: pointcoord;

begin { drawseg }
  e := s^.element;
  while e <> nil do with e^ do
  begin
    for i := 1 to points do { segment transformation }
    begin
      newx[i] := x[i] * s^.transform[1, 1] + y[i] * s^.transform[1, 2] +
                 s^.transform[1, 3];
      newy[i] := x[i] * s^.transform[2, 1] + y[i] * s^.transform[2, 2] +
                 s^.transform[2, 3];
    end;
    pline(transform, points, newx, newy, pen);
    e := next;
  end;
  clrseg;
end;

{ interface } procedure redrawall;

var
  s: ptr2segment;

begin
  if debug then writeln('redrawall');
  clrvec;
  s := segments;
  while s <> nil do
  begin
    if s^.visible then drawseg(s, 1);
    s := s^.next;
  end;
end;

{ interface } procedure closeseg;

begin
  if debug then writeln('closeseg');
  if openseg <> nil then if openseg^.visible then drawseg(openseg, 1);
  openseg := nil;
end;

{ interface } procedure createseg(name: integer);

var
  p, s: ptr2segment;

begin
  if debug then writeln('createseg');
  if openseg <> nil then closeseg;
  s := findseg(name);
  if s <> nil { we found one }
  then openseg := s
  else { tack a new segment onto front of list }
  begin
    new(openseg);
    with openseg^ do
    begin
      next := segments;
      element := nil { no primitives yet };
      transform := identity;
      visible := true;
    end;
    openseg^.name := name;
    segments := openseg
  end
end;

{ interface } procedure deleteseg(name: integer);

{ Because we have to special-case the head of the list, we might as well
  make life easy on the programmer (me) and use the routines at hand.
  We'll have to traverse the segment list twice. }

var
  p, q: ptr2segment;
  r, s: ptr2primitive;

begin
  if debug then writeln('deleteseg');
  { unlink it first }
  p := findseg(name);
  if p <> nil then if p^.visible then drawseg(p, 0);
  if p <> nil then
  if p = segments
  then { special case head of list }
    segments := p^.next { unlink }
  else
  begin
    q := segments;
    while q^.next <> p do q := q^.next;
    q^.next := p^.next { unlinked }
  end;
  if p <> nil then { throw it away }
  begin
    r := p^.element;
    while r <> nil do
    begin
      s := r;
      r := r^.next;
      dispose(s);
    end;
    dispose(p)
  end;
end;

procedure missing(n: integer);

begin
  writeln('Segment ', n, ' not found!!!')
end;

{ interface } procedure renameseg(name, future: integer);

var
  p: ptr2segment;

begin
  if debug then writeln('renameseg');
  if name <> future then { something to do }
  begin
    deleteseg(future);
    p := findseg(name);
    if p <> nil then p^.name := future else missing(name);
  end
end;

{ interface } procedure setsxf(name: integer; m: sxf);

var
  p: ptr2segment;

begin
  if debug then writeln('setsxf');
  if debug then print(m);
  p := findseg(name);
  if p <> nil then
  begin
    if p^.visible then drawseg(p, 0); { erase old one }
    p^.transform := m;
    if p^.visible then drawseg(p, 1); { draw new one }
  end else missing(name)
end;

{ interface } procedure setvis(name: integer; v: viscode);

var
  p: ptr2segment;
  is, was: boolean;

begin
  if debug then writeln('setvis');
  is := v = visible;
  p := findseg(name);
  if p <> nil then
  begin
    was := p^.visible;
    p^.visible := is;
    if is <> was then if is then drawseg(p, 1) else drawseg(p, 0);
  end else missing(name);
end;

{ interface } procedure opengks;

var
  i, j: integer;

begin
  if debug then writeln('opengks');
  openseg := nil; segments := nil;
  for i := 1 to 3 do for j := 1 to 3 do
    if i = j then identity[i, j] := 1 else identity[i, j] := 0;
  for i := 1 to maxnxfindex do
  with nxf.window[i] do { set default transformations }
  begin xmin := 0.0; xmax := 1.0; ymin := 0.0; ymax := 1.0 end;
  for i := 1 to maxnxfindex do
  with nxf.viewport[i] do
  begin xmin := 0.0; xmax := 1.0; ymin := 0.0; ymax := 1.0 end;
  nxf.index := 0;
  header;
end;

{ interface } procedure closegks;

{ should probably delete all segments here, too }

var
  s: ptr2segment;

begin
  if debug then writeln('closegks');
  closeseg;
  s := segments;
  while s <> nil do
  begin
    deleteseg(s^.name);
    s := segments;
  end;
end;

{ interface } procedure nxfwindow(nxfindex: integer; xn, xx, yn, yx: real);

var
  i: integer;
  s: ptr2segment;
  e: ptr2primitive;

begin
  if debug then writeln('nxfwindow');
  if debug then writeln(xn: 10: 7, xx: 10: 7, yn: 10: 7, yx: 10: 7);
  if nxfindex > 0 then
  begin { convert relevant elements back to world }
    s := segments;
    while s <> nil do
    begin
      e := s^.element;
      while e <> nil do
      begin
        if e^.transform = nxfindex then
          for i := 1 to e^.points do
            world(e^.x[i], e^.y[i], e^.x[i], e^.y[i], nxfindex);
        e := e^.next;
      end;
      s := s^.next;
    end
  end;
  if nxfindex > 0 then
  with nxf.window[nxfindex] do
  begin xmin := xn; xmax := xx; ymin := yn; ymax := yx; end;
  if nxfindex > 0 then
  begin { convert relevant elements back to normal }
    s := segments;
    while s <> nil do
    begin
      e := s^.element;
      while e <> nil do
      begin
        if e^.transform = nxfindex then
          for i := 1 to e^.points do
            normal(e^.x[i], e^.y[i], e^.x[i], e^.y[i], nxfindex);
        e := e^.next;
      end;
      s := s^.next;
    end
  end;
end;

{ interface } procedure nxfviewport(nxfindex: integer; xn, xx, yn, yx: real);

var
  i: integer;
  s: ptr2segment;
  e: ptr2primitive;

begin
  if debug then writeln('nxfviewport');
  if debug then writeln(xn: 10: 7, xx: 10: 7, yn: 10: 7, yx: 10: 7);
  if nxfindex > 0 then
  begin { convert relevant elements back to normal }
    s := segments;
    while s <> nil do
    begin
      e := s^.element;
      while e <> nil do
      begin
        if e^.transform = nxfindex then
          for i := 1 to e^.points do
            world(e^.x[i], e^.y[i], e^.x[i], e^.y[i], nxfindex);
        e := e^.next;
      end;
      s := s^.next;
    end
  end;
  if nxfindex > 0 then
  with nxf.viewport[nxfindex] do
  begin xmin := xn; xmax := xx; ymin := yn; ymax := yx; end;
  if nxfindex > 0 then
  begin { convert relevant elements back to normal }
    s := segments;
    while s <> nil do
    begin
      e := s^.element;
      while e <> nil do
      begin
        if e^.transform = nxfindex then
          for i := 1 to e^.points do
            normal(e^.x[i], e^.y[i], e^.x[i], e^.y[i], nxfindex);
        e := e^.next;
      end;
      s := s^.next;
    end
  end;
end;

{ interface } procedure setnxfindex(nxfindex: integer);

begin
  if debug then writeln('setnxfindex');
  nxf.index := nxfindex
end;

{ interface } procedure polyline(n: integer; var px, py: pointcoord);

var
  e: ptr2primitive;
  i: integer;
  newx, newy: pointcoord;

begin
  if debug then writeln('polyline');
  if openseg = nil
  then
  begin
    for i := 1 to n do
      normal(px[i], py[i], newx[i], newy[i], nxf.index);
    pline(nxf.index, n, newx, newy, purple)
  end
  else
  begin
    new(e);
    with e^ do
    begin
      points := n; transform := nxf.index;
      for i := 1 to n do
        normal(px[i], py[i], x[i], y[i], nxf.index)
    end;
    with openseg^ do
    begin
      e^.next := element; element := e
    end;
  end;
end;
