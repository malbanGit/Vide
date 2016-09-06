program hexify;

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

{
  This program converts Motorola S-format hexadecimal object files
  into Intel format hexadecimal object files.
  The intended purpose is so that 6809 object code can be loaded into
  DDT so that it can be burned into EPROMs for a 6809 system.
}

const
  fifteen = 15;

type
  range = (low, high);
  nybble = 0 .. fifteen;
  conversion = array[nybble] of char;

var
  fred, ginger: text;
  name: string[14];
  x, y, z: nybble;
  checksum: integer;
  table: conversion;

function readbyte: byte;

var
  ch: char;
  i, z: byte;

  function c(ch: char): byte;

  begin
    if ch in ['0' .. '9']
    then
      c := ord(ch)-ord('0')
    else
      c := 10+ord(ch)-ord('A');
  end;

begin
  z := 0;
  for i := 1 to 2 do
  begin
    read(fred, ch);
    z := 16 * z + c(ch);
  end;
  readbyte := z;
end;

procedure convert(x: byte);

begin
  write(ginger, table[x div 16], table[x mod 16]);
  checksum := checksum - x
end;

procedure convertline;

var
  ch: char;
  len, z: integer;

  begin
    read(fred, ch);
    if ch = 'S' then
    begin
      read(fred, ch);
      case ch of
        '0': begin writeln('Header'); readln(fred) end;
        '1': begin
               write(ginger, ':');
               checksum := 0;
               len := readbyte;
               convert(len - 3);
               for z := 1 to 2 do (* copy address  *)
                 convert(readbyte);
               write(ginger, '00') (* record type *);
               for z := 1 to len - 3 do
                 convert(readbyte);
               convert(checksum);
               writeln(ginger);
               readln(fred)
             end;
        '9': begin
               writeln('Trailer'); readln(fred);
               writeln(ginger, ':00000001FF') (* EOF *) ;
             end
        else begin writeln('Ignoring type ',ch ,' record'); readln(fred) end
      end (* case *)
    end
    else begin writeln('Garbage line ', ch, ' ignored'); readln(fred) end
  end;

begin
  for z := 0 to 9 do table[z] := chr(z+ord('0'));
  for z := 10 to 15 do table[z] := chr(z+ord('A')-10);
  writeln('Enter file name:');
  readln(name);
  assign(fred, name + '.LX');
  reset(fred);
  assign(ginger, 'B:' + name + '.HEX');
  rewrite(ginger);
  while not eof(fred) do
    convertline;
  close(ginger)
end.
