(*$A- Allow recursion *)
program vecdump;

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

{
   This is the Vectrex interface dumper program.
}
{
  TURBO Pascal has a stupid idiosyncracy whereby for a file of x, there is
  a header on the front of the file that describes the size of x and the
  number of x in the file.  An arbitrary file not created by TURBO is not
  likely to be readable by TURBO.  So, in order to read a real FILE OF BYTE,
  *I* have to do the buffering.  That's really crummy.
}

const
  control = $30;
  data = $31 { control + 1 } ;
  lsb = $32 { control + 2 } ;
  msb = $33 { control + 3 } ;
  sectorsize = 128;

type
  sector = array[1 .. sectorsize] of byte;

var
  memsize, i: integer;
  name: string[14];
  ch: char;
  fred: file;

function sizeup: integer { determine how much unique memory in interface } ;

{ call with Vectrex halted and/or ignoring interface }

const
  spagefactor = 8;
  maxpages = 8;

var
  page, hold, test: byte;

begin
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
end;

procedure setbase { set memory base address } ;

begin
  port[control] := $86;
  port[lsb] := 0;
  port[msb] := 0;
end;

procedure delay;

var
  i: integer;

begin
  for i := 1 to 50 do i := i;
end;

procedure readblock;

var
  i: integer;
  s: sector;
  b: byte;

begin
  for i := 1 to sectorsize do
  begin
    s[i] := port[data];
    if s[i] <> port[data] then writeln('Read error!');
    port[lsb] := port[lsb] + 1;
  end;
  if port[lsb] = 0 then port[msb] := port[msb] + 1;
  blockwrite(fred, s, 1);
  write('.');
end;

begin
  write('Dump file name:');
  readln(name);
  assign(fred, concat(name,'.GAM'));
  rewrite(fred);
  write('Say when>'); readln(ch);
  port[control] := 1;
  setbase;
  memsize := sizeup;
  write('Dumping ', memsize, ' bytes of ', name);
  setbase;
  for i := 1 to memsize div sectorsize do readblock;
  writeln;
  port[control] := 1 { let her rip, allow writes };
  close(fred);
end.
