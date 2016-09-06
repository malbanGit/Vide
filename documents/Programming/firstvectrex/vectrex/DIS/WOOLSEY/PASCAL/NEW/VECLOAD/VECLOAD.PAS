(*$A- Allow recursion *)
program vecload;

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

{
   This is the Vectrex interface loader program.
   For starters, copies of the various ROMs can be loaded into
   the Vectrex for execution.
}
{
   This program now depends on cooperation from the Vectrex.
   It first HALTs the Vectrex, fills memory with the bootstrap loader loader,
   NOPs and a JMP, releases the interface and unHALTs the Vectrex.  It then
   waits for an acknowledge byte from the bootstrap loader.  After that, it
   loads the desired program as before.

   The running program in the interface has some characteristics which make
   a live loader difficult.  1) The loader may be placed directly atop code
   which is being executed at that instant.  2) A ROM support routine may
   be reading a long string of data, be it text, vectors, or music.  Dropping
   the loader atop this will result in the loss of a terminator byte.

   Cures for the above can be affected (I hope) by 1) shrinking the loader
   load image, and 2) fill most of memory with terminator bytes ($80), which
   are a SUBA $80 instruction.
}
{
  TURBO Pascal has a stupid idiosyncracy whereby for a file of x, there is
  a header on the front of the file that describes the size of x and the
  number of x in the file.  An arbitrary file not created by TURBO is not
  likely to be readable by TURBO.  So, in order to read a real FILE OF BYTE,
  *I* have to do the buffering.  That's really crummy.
}

const
  timeout = 300;
  control = $30;
  data = $31 { control + 1 } ;
  lsb = $32 { control + 2 } ;
  msb = $33 { control + 3 } ;
  sectorsize = 128;
  digits: string[16] = '.123456789ABCDEF';

type
  sector = array[1 .. sectorsize] of byte;

var
  bytes, i, memsize: integer;
  ginger, fred: file;
  restore: byte;
  name: string[14];
  first: sector;
  singleload, writelock: boolean;
  ch: char;

procedure delay;

var
  i: integer;

begin
  for i := 1 to 100 do i := i
end;

procedure writebase(n, b, w: integer);

begin
  if w > 0 then
  begin writebase(n div b, b, w - 1); write(digits[n mod b + 1]) end
end;

procedure checkloader;

var
  s: sector;
  address, i: integer;
  z, y: byte;

begin
  writeln('Loader failure analysis.');
  address := 0;
  port[control] := 4; delay; { HALT }
  port[control] := $84 { HOST + HALT };
  for i := 1 to sectorsize do
    begin
      z := port[data];
      y := first[i];
      if z <> y then
      begin
        write('Expected ');
        writebase(y, 16, 2);
        write(' got ');
        writebase(z, 16, 2);
        write(' load error ');
        writebase(y xor z, 16, 2);
        write(' at ');
        writebase(address, 16, 4);
        writeln
      end;
      address := address + 1;
    end;
end;

procedure writeblock;

var
  i: integer;
  s: sector;

begin
  write('.');
  bytes := bytes + sectorsize;
  blockread(fred, s, 1);
  for i := 1 to sectorsize do
    port[data] := s[i]
end;

function acknowledge: boolean;

var
  y, x: byte;

begin
  x := port[control];
  y := x or 2 { IHAI };
  port[control] := y;
  acknowledge := port[data] = $76;
  port[control] := x
end;

function sizeup: integer { determine how much unique memory in interface } ;

{ call with Vectrex halted and/or ignoring interface }

const
  spagefactor = 8;
  maxpages = 8;

var
  page, hold, test: byte;

begin
  port[control] := 4; delay; { HALT }
  port[control] := $86 { HALT + HOST + IHAI };
  repeat
    hold := port[data];
    port[data] := port[msb];
    test := port[data];
    port[data] := hold;
    page := port[msb];
    port[msb] := page + spagefactor;
  until (test <> page) or (page >= spagefactor * maxpages);
  sizeup := page * 256;
  port[msb] := 0;
  port[control] := $84 { HALT + HOST }
end;

procedure loadloader { start bootstrap loader } ;

var
  t, i: integer;

begin
  port[lsb] := 0;
  port[msb] := 0;
  writeln('Halting Vectrex.');
  port[control] := $04 { halt Vectrex };
  for i := 1 to 5 do delay;
  port[control] := $84 { take control of interface };
  writeln('Sizing interface.');
  memsize := sizeup;
  writeln('Presetting ', memsize: 1, ' bytes of interface memory.');
  for i := 0 to memsize - 4 do port[data] := $80 { SUBA, data terminator };
  if false then
  begin { check following code carefully before unleashing }
    port[data] := $12 { NOP };
    port[data] := $20 { BRA };
    port[data] := $FE { * };
    port[control] := 0;
    writeln('Setting PCR = $3FFE');
    for i := 1 to 100 do delay;
    writeln('Halting Vectrex.');
    port[control] := $04 { halt Vectrex };
    for i := 1 to 5 do delay;
    port[control] := $84 { take control of interface };
    port[lsb] := $FE;
    port[msb] := $3F;
  end;
  port[data] := $12 { NOP };
  port[data] := $7E { JMP };
  port[data] := $FF;
  port[data] := $FF;
  port[lsb] := 0;
  port[msb] := 0;
  writeln('Loading loader.');
  for i := 1 to sectorsize do
    port[data] := first[i];
  port[control] := 3 { IHAI + VWRITE };
  port[lsb] := 0;
  port[msb] := 0;
  delay { allow Vectrex to run loader loader };
  writeln('Waiting for loader acknowledge.');
  t := timeout;
  while (t > 0) and not acknowledge do
  begin
    t := t - 1;
    port[control] := 3 { IHAI + VWRITE };
    for i := 1 to 10 do
    delay { allow Vectrex to write };
    port[control] := $83 { HOST + IHAI + VWRITE };
  end;
  if t = 0 then checkloader;
  port[control] := $81 { HOST + VWRITE };
end;

procedure monitor;

begin
 while not keypressed do
   write(^M, port[control])
end;

begin
  writeln('Seeking loader.');
  assign(ginger, 'LOADER.GAM');
  reset(ginger);
  writeln('Reading loader.');
  blockread(ginger, first, 1);
  write('Allow writes?');
  read(kbd, ch);
  writelock := not (ch in ['y', 'Y']);
  writeln(ch);
  write('Tile interface with load image?');
  read(kbd, ch);
  singleload := not (ch in ['y', 'Y']);
  writeln(ch);
  write('Load file name:');
  readln(name);
  assign(fred, concat(name,'.GAM'));
  reset(fred);
  repeat loadloader until acknowledge;
  for i := 0 to memsize - 1 do port[data] := $12;
  bytes := 0;
  port[lsb] := 0;
  port[msb] := 0;
  repeat
    if singleload then write('Loading ', name) else write('Tiling with ', name);
    if eof(fred) then reset(fred);
    while not eof(fred) do writeblock;
    writeln
  until singleload or (bytes >= memsize);
  if writelock then port[control] := 0 else port[control] := 1;
  monitor;
end.
