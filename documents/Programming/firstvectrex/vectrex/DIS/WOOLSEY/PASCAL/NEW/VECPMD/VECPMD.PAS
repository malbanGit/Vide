(*$A- Allow recursion *)
program vecpmd;

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

{
  This thing checks to see that the interface memory is intact, given
  that we know what it was last loaded with.
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
  digits: string[16] = '.123456789ABCDEF';

type
  sector = array[1 .. sectorsize] of byte;

var
  address, i: integer;
  fred: file;
  name: string[14];

procedure writebase(n, b, w: integer);

begin
  if w > 0 then
  begin writebase(n div b, b, w - 1); write(digits[n mod b + 1]) end
end;

procedure delay;

var
  i: integer;

begin
  for i := 1 to 50 do i := i
end;

procedure readblock;

var
  s: sector;
  i: integer;
  z, y: byte;

begin
  write('.');
  blockread(fred, s, 1);
  for i := 1 to sectorsize do
    begin
      z := port[data];
      y := s[i];
      port[lsb] := port[lsb] + 1;
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
  if port[lsb] = 0 then port[msb] := port[msb] + 1
end;

procedure setbase { set memory base address } ;

begin
  port[lsb] := 0;
  port[msb] := 0;
  address := 0;
  port[control] := $86 { clear inhibits, allow host access, halt, inhibit }
end;

begin
  port[control] := 0;
  write('Original load file name:');
  readln(name);
  assign(fred, concat(name,'.GAM'));
  reset(fred);
  setbase;
  write('Checking...');
  while not eof(fred) do readblock;
  writeln;
  port[control] := 1 { let her rip }
end.
