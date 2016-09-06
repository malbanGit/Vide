program hexify;

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

{
  TURBO Pascal has a stupid idiosyncracy whereby for a file of x, there is
  a header on the front of the file that describes the size of x and the
  number of x in the file.  An arbitrary file not created by TURBO is not
  likely to be readable by TURBO.  So, in order to read a real FILE OF BYTE,
  *I* have to do the buffering.  That's really crummy.
}

const
  sectorsize = 128;
  fifteen = 15;
  sixteen = 16;
  digits: string[16] = '.123456789ABCDEF';

type { hexify }
  range = (low, high);
  nybble = 0 .. fifteen;
  conversion = array[nybble] of char;
  word = packed array[range] of byte;
  sector = array[1 .. sectorsize] of byte;

var
  x, y, z: nybble;
  checksum: integer;
  table: conversion;
  address: word;
  pile: array[nybble] of byte;
  s: sector; b: byte { global last byte read };
  fred: file;
  ginger: text;
  name: string[14];
  done: boolean;

function getbyte: byte;

var
  q: byte;

begin
  if not done then
  begin
    if b = 0 then blockread(fred, s, 1);
    b := b + 1; getbyte := s[b];
    if b = 128 then b := 0;
  end
end;

procedure convert(x: byte);

begin
  write(ginger, table[x div 16], table[x mod 16]);
  checksum := checksum - x
end;

function getpile: nybble;

var
  q: nybble;

begin
  q := 0; checksum := 0;
  while (not eof(fred)) and (q <= fifteen) do
  begin pile[q] := getbyte; q := succ(q) end;
  getpile := q
end;

begin
  for z := 0 to 9 do table[z] := chr(z+ord('0'));
  for z := 10 to 15 do table[z] := chr(z+ord('A')-10);
  write('Enter binary file name:'); readln(name); assign(fred, name);
  reset(fred);
  write('Enter decimal address bias (please?)'); readln(checksum);
  address[low] := checksum mod 256;
  address[high] := checksum div 256;
  write('Enter hex file name:'); readln(name);
  assign(ginger, name); rewrite(ginger);
  while not eof(fred) do
  begin
    write(ginger, ':'); z := getpile;
    convert(z); convert(address[high]); convert(address[low]);
    write(ginger, '00') (* record type *) ;
    for x := 0 to z - 1 do convert(pile[x]);
    convert(checksum); writeln(ginger);
    address[high] := address[high] + (address[low] + z) div 256;
    address[low] := (address[low] + z) mod 256
  end;
  writeln(ginger, ':00000001FF') (* EOF *) ;
  close(ginger)
end.
