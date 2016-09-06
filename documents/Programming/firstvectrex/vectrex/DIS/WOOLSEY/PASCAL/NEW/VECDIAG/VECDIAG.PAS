(*$A- Allow recursion *)
program vecdiag;

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

{ This marks the beginning of operational development testing on the
  prototype Vectrex interface.

As of 84/08/24, the test (and card) should simply select the 4 read and write
control lines.  At this point, that is the only section that is completely
wired.

As of 84/09/11, reading and writing of memory has worked for a few days,
and I just changed the definition of the counter so that it increments
after access (when there's plenty of time) rather than before (which
caused problems).

Later that evening, the entire host side of the interface was observed
to work, although the last problem went away when the scope probes were
moved.

As of 85/03/31, after a 6-month hiatus, I have decided to simplify the
interface in the interest of getting it working at all.  It was last observed
to get real confused when both the host and the interface were active.  Oh,
and this program got munged, so I have to reconstruct the source (I think).

Test principles:  Things that gotta work, and in what order.

Port selection must work reliably first.  Read/Write should be
selected for each port.

The latches which hold status information (the read/write status latch)
should then function, along with the address counters.

The address counters should increment without glitch, and respond to control
bits.

It should then be possible to read a ROM, in conjunction with allowing the
host to define who is accessing a ROM, and the read-only bit in the status.

It should also be possible, then, for the Vectrex to execute out of that ROM
while the host is ignoring it.

Read/Write tests on RAM should pass next.

Finally, perform a full functional test.

}

const
  control = $30;
  data = $31 { control + 1 } ;
  lsb = $32 { control + 2 } ;
  msb = $33 { control + 3 } ;
  pagesize = $800;
  pagecount = 8;
  digits: string[16] = '.123456789ABCDEF';

var
  p, i: integer;

procedure writebase(n, b, w: integer);

begin
  if w > 0 then
  begin writebase(n div b, b, w - 1); write(digits[n mod b + 1]) end
end;

procedure wait;

var i:integer;

begin
  { wait an instant }
  for i := 1 to 10 do i := i
end;

procedure rwtest(which, loops: integer);

var i: integer;
    x, y: byte;

begin
  write('Testing port '); writebase(which, 16, 2); writeln;
  y := 257;
  for i := 1 to loops do
  begin { test port read/write }
    inline($21/Y/     {   ld   hl,y   }
           $CB/$06    {   rlc  (hl)   }
           );
    port[which] := y { write port } ;
    x := port[which] { read port } ;
    if x <> y
    then
    begin
      write('Port '); writebase(which, 16, 2);
      write(' R/W failure: expected '); writebase(y, 16, 2); write(' got ');
      writebase(x, 16, 2); writeln
    end
  end;
end;

procedure testcounter(loops: integer; reed: boolean);

{ 74LS193 parts fail this test, while 74193 parts pass. }

var
  i: integer;
  x, y, z: byte;

begin
  write('Testing counter ', loops, ' times, ');
  if reed then writeln('read.') else writeln('write');
  port[control] := 0 { clear inhibits } ;
  if not reed then port[control] := $80 { set host write enable } ;
  { Following is reconstructed }
  { The order in which these are written can be important, as a carry
    can be propogated from the loaded counter to the higher counter. }
  port[lsb] := 0;
  port[msb] := 0;
  x := port[msb];
  y := port[lsb];
  writebase(x, 16, 2);
  writebase(y, 16, 2);
  writeln;
  if reed
  then
  for i := 1 to loops do
  begin
    z := port[data];
    z := port[data];
  end
  else
  for i := 1 to loops do
  begin
    port[data] := $55;
    port[data] := $55;
  end;
  port[control] := 0 { clear inhibits } ;
  x := port[msb];
  y := port[lsb];
  writebase(x, 16, 2);
  writebase(y, 16, 2);
  writeln;
end;

procedure testmem(base: byte; bytes: integer);

var
  i: integer;
  x, y: byte;

begin
  write('Testing memory at ');
  writebase(base, 16, 2); write(' for ');
  writebase(bytes, 16, 4); writeln;
  port[control] := $80; { host select }
  port[lsb] := 0;
  port[msb] := base;
  y := 257;
  for i := 1 to bytes do
  begin { test port read/write }
    inline($21/Y/     {   ld   hl,y   }
           $CB/$06    {   rlc  (hl)   }
           );
    port[control] := $82; { inhibit address increment }
    port[data] := y { write port } ;
    port[control] := $80; { allow address postincrement }
    x := port[data] { read port } ;
    if x <> y
    then
    begin
      write('Memory R/W failure: expected '); writebase(y, 16, 2); write(' got ');
      writebase(x, 16, 2); write(' at ');
      x := port[msb]; writebase(x, 16, 2);
      x := port[lsb]; writebase(x, 16, 2);
      writeln(' minus one.');
    end
  end;
end;

procedure bang;

var i: integer;
    x, y, z: byte;

begin
  writeln('Banging on counter.');
  port[control] := $80 { set host write enable } ;
  port[lsb] := 240;
  port[msb] := 255;
  while not keypressed do
    port[data] := $55;
  port[control] := 0 { clear inhibits } ;
end;

begin
  rwtest(control, 8);
  rwtest(msb, 8);
  rwtest(lsb, 8);
  for i := 1 to 4 do
  begin
    testcounter(20000, true);
    testcounter(20000, false);
  end;
  p := 0;
  for i := 1 to pagecount do
  begin
    testmem(p, pagesize);
    p := p + 8
  end;
end.
