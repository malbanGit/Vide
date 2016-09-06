program music; {$R+ }

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

{ turn a .MUS file into a .TUN file }
{ FLAME:  the .MUS files were created by Turbo Pascal on an MS-DOS system.
  That version of Turbo does not place the 4 byte header on binary files
  that CP/M Turbo does.  This makes binary files incompatible (well, it's
  almost more work than it's worth to fake up a 4-byte header. }

type
  FiledNote = record
                octave, note, staccato : byte;
                duration               : integer; { milliseconds? }
              end;

{ It should also be possible to append dots and use legato to get things
  to come out right. }

type
  NoteFile = file of FiledNote;

const pitch: array[0 .. 13] of string[2] =
('##', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B', 'P');

var
  f: notefile;
  dots, name: string[14];
  z: filednote;
  g: text;
  r, q: integer;
  dd, d: real;

PROCEDURE ERROR;

BEGIN
  WRITELN(Z.OCTAVE:4, Z.NOTE: 4, Z.DURATION:6);
  WRITELN(FILEPOS(F):6, FILESIZE(F):6);
END;

begin
(* malban  ERRORPTR := ADDR(ERROR); *)
  write('Enter MUSic file name:'); readln(name);
(* malban assign(f, 'B:' + name +'.MUS'); reset(f); *)
  assign(f, name +'.MUS'); reset(f);
  assign(g, name + '.TUN'); rewrite(g);
  while not eof(f) do
  begin
    read(f, z);
    dots := '';
    r := (z.duration div 20); if r = 0 then r := 1; q := 64 div r;
    if q = 0 then q := 1;
    d := q; dd := d;
    while 64 * 20 / d > z.duration do
    begin dd := dd / 2; d := d + dd; dots := dots + '.' end;
    if dots <> '' then q := q + q;
    writeln(g, 'O',z.octave:1, pitch[z.note], q: 1, dots);
  end;
  close(g);
end.
