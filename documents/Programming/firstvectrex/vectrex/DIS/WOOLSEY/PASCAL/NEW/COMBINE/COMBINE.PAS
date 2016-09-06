program combine;

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

{ take lines from n files and produce a file which is a side-by-side
  concatenation. }
{ now this becomes special case as it tries to match up the note lengths
  in tune files produced by MUSIC.PAS }
{ another thing that needs determining is which note to list first.
  PLAY.PAS places subsequent notes before (with sign bit) the first note,
  thinking that the first is a melody and will be displayed.
  Thus we should place shorter notes first so that longer ones will sustain
  in higher numbered channels.  This ignores the PROBLEM, which for now
  can be solved manually on an individual basis, as long as we can now
  detect the PROBLEM. }
{ PROBLEM can be dealt with by making the longer note equal the shorter, and
  inserting a rest of the difference.  Later. }

const
  tab = ^I; unity = 64; members = 3; vecvoices = 3;
  align = true; { match up times }

type
  constituents = 1 .. members;
  twine = string[100];
  specify = set of constituents;
  roster = array[constituents] of constituents;
  voice = record
            before, time: integer;
            stuff, previous, next: twine;
            data: text;
          end;

var
  choir: array[1 .. members] of voice;
  c: text;
  i: integer;
  name: twine;
  lasttime, temp, active: specify;

function howlong(x: twine): integer;

var
  two, j, z, y: integer;

begin
  z := 0;
  j := 4; two := 2;
  if x[j] = '#' then j := j + 1;
  while (j <= length(x)) and (x[j] in ['0' .. '9']) do
    begin
      z := 10 * z + ord(x[j]) - ord('0');
      j := j + 1;
    end;
    z := unity div z;
    y := z;
    if j <= length(x) then
    repeat
      if x[j] = '.' then z := z + y div two;
      j := j + 1; two := two + two;
    until (x[j] <> '.') or (j > length(x));
  howlong := z;
end;

procedure open(n: integer; name: twine);

begin
  if n <= members then
  begin assign(choir[n].data, name); reset(choir[n].data) end
end;

function first(s: specify): integer; { find first element in set }

var
  i: integer;

begin
  first := 0; i := 1;
  if s <> [] then while (i <= members) and not (i in s) do i := i + 1;
  if i in s then first := i;
end;

function same(s: specify): boolean;

var
  v, i: integer;
  t: boolean;

begin
  t := true;
  v := first(s);
  if v <> 0 then
  begin
    s := s - [v]; v := choir[v].time;
    for i := 1 to members do if i in s then t := t and (v = choir[i].time);
  end;
  same := t;
end;

procedure smallest(s: specify; var r: specify);

var
  v, i: integer; q: specify;

begin
  if not align then r := s else
  begin
    v := first(s);
    q := [v];
    if v <> 0 then
    begin
      s := s - [v];
      for i := 1 to members do
        if i in s then
          if choir[i].time < choir[v].time then begin v := i; q := [v] end
          else if choir[i].time = choir[v].time then q := q + [i]
    end;
    r := q
  end
end;

procedure sort(s: specify; var list: roster);

var
  q: specify; i, j: integer;

begin
  j := 0;
  while s <> [] do
  begin
    smallest(s, q);
    for i := 1 to members do
      if i in q then begin j := j + 1; list[j] := i end;
    s := s - q
  end;
end;

procedure writesome(s: specify);

var
  i: integer;
  r: roster;

begin
  for i := 1 to members do r[i] := i;
  if members > vecvoices then sort(s, r);
  for i := 1 to members do
    begin
      write(c, tab);
      if r[members + 1 - i] in s then
      if choir[r[members + 1 - i]].previous <> ''
      then
      begin
        write(c, choir[r[members + 1 - i]].previous);
        choir[r[members + 1 - i]].previous := ''
      end
      else
        write(c, choir[r[members + 1 - i]].stuff)
    end;
  writeln(c);
end;

procedure subtract(v: integer; s: specify);

var
  i: integer;

begin
  for i := 1 to members do
    if i in s then with choir[i] do
    begin
      before := time;
      time := time - v
    end
end;

procedure dump;

var
  i: integer;

begin
  for i := 1 to members do
    with choir[i] do
      writeln('i, prev, before, stuff, time, next: ',
               i, ',',previous,',',before,',',stuff,',',time,',',next)
end;

procedure problem;

{ problem was called because the time spaces of two notes overlap.
  it is the job of problem to remedy this situation, generally by
  splitting the later notes at the remaining length of the earlier.
  easier said than done, because by the time problem is called, the
  information we need to recover stuff has been destroyed, and the
  problem note has already been written out.  thus we need to keep
  the previous note information around. }

var
  sharp, j, i: integer; etherial: specify; digs: twine;

procedure remain(d: integer);

{ convert a duration (1 - 64) into one or two notes that sum to it }

var
  q: integer; first: boolean; digs: twine;

begin
  q := 64; first := true;
  with choir[i] do
  if q mod d = 0
  then { one note }
  begin
    str(q div d, digs);
    previous := stuff;
    stuff := copy(stuff, 1, sharp) + digs;
    time := howlong(stuff);
  end
  else
  begin
    previous := stuff;
    while q > 1 do
    begin
      if d div q > 0 then
      begin
        str(64 div q, digs);
        if first
        then begin
               stuff := copy(stuff, 1, sharp) + digs;
               first := false
             end
        else next := copy(stuff, 1, sharp) + digs;
        d := d - q;
      end;
      q := q div 2;
    end;
  end
end;

begin { problem }
  writeln(c, 'RPROBLEM');
  for i := 1 to members do
    if i in lasttime { the problem notes }
    then with choir[i] do
      begin
        smallest(temp, etherial);
        sharp := 3;
        if pos('#', stuff) <> 0 then sharp := 4;
        str(64 div choir[first(etherial)].before, digs);
        previous := stuff;
        stuff := copy(stuff, 1, sharp) + digs;
        remain(howlong(previous) - choir[first(etherial)].before);
        time := howlong(stuff);
        temp := temp + [i];
      end;
  writesome(lasttime);
  writeln(c, 'RSOLUTION');
end;

begin
  open(1, 'jingle3.tun');
  open(2, 'jingle2.tun');
  open(3, 'jingle1.tun');
  write('Enter output file name:'); readln(name);
  assign(c, name); rewrite(c);
  writeln(c, 'Z');
  active := [1 .. members];
  lasttime := active;
  for i := 1 to members do choir[i].time := 0;
  for i := 1 to members do choir[i].stuff := 'O3P1';
  for i := 1 to members do choir[i].next := '';
  for i := 1 to members do choir[i].previous := '';
  while active <> [] do
  begin
    for i := 1 to members do
      if i in active then
        with choir[i] do
          if time = 0 then
          begin
            stuff := next; next := '';
            if stuff = '' then readln(data, stuff);
          end;
    smallest(active, temp);
    if temp * lasttime = [] then problem;
    writesome(temp);
    lasttime := temp;
    for i := 1 to members do
      if i in active then
        with choir[i] do
          if eof(data)
          then begin time := unity; active := active - [i] end
          else if not align
               then time := 0;
    for i := 1 to members do
      if i in active then
        with choir[i] do if align then
          if time = 0 then time := howlong(stuff);
    smallest(active, temp);
    subtract(choir[first(temp)].time, active);
    if active = [] then writesome(temp);
  end;
  close(c)
end.
