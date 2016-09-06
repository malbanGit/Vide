(*$A- Allow recursion *)
program vecrun;

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

{
   This is the Vectrex interface loader program.
   For starters, copies of the various ROMs can be loaded into
   the Vectrex for execution.
   The Vectrex live loader is of limited usefulness and support (and tiling)
   will hamper support for the library.
}

const
  dirsize = 47;

type
  twine = string[255];
  lbrentry = record
               deleted: byte;
               name: array[1 .. 11] of char;
               index, size: integer;
               filler: array[0 .. 15] of byte
             end;
  sector = record case integer of
                    0: (byt: array[0 .. 127] of byte);
                    1: (txt: array[0 .. 127] of char);
                    2: (dir: array[0 .. 3] of lbrentry)
                  end;
  FiledNote = record
                octave, note, staccato : byte;
                duration               : integer; { milliseconds? }
              end;
  NoteFile = file of FiledNote;

var
  (* malban
  screen: byte absolute $FB5A;
  *)
  screen: byte;
  f: file;
  s: array[0 .. dirsize] of sector;
  z: sector;
  i, j, k, entry: integer;
  library: boolean;
  b, ss: integer;
  title, filename, q: twine;
  ch: char;
  reply: integer;

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

var
  bytes: integer;
  writelock: boolean;

procedure position(e: integer);

var
  a, d: integer;

begin
  b := 0;
  a := e div 4; d := e mod 4;
  title := copy(s[a].dir[d].name, 1, 8) + '.' + copy(s[a].dir[d].name, 9, 3);
  seek(f, s[a].dir[d].index); ss := s[a].dir[d].size;
end;

procedure writeblock;

var
  i: integer;
  s: sector;

begin
  write('.');
  bytes := bytes + sectorsize;
  blockread(f, s, 1);
  for i := 0 to sectorsize - 1 do
    port[data] := s.byt[i]
end;

begin
  screen := 25; (* malban *)
  write('Allow writes?');
  read(kbd, ch);
  writelock := not (ch in ['y', 'Y']);
  writeln(ch);
  library := false;
  write('Enter game name:');
  readln(filename);
  title := filename;
  library := (filename = '');
  (* malban
  if library then filename := 'A:VECGAMES.LBR';
  *)
  if library then filename := 'VECGAMES.LBR';
  library := pos('.', filename) <> 0;
  if library then
  begin
    assign(f, filename);
    reset(f);
    writeln('Reading up directory.');
    blockread(f, s[0], 1);
    if s[0].dir[0].size > dirsize
    then writeln('Directory too big for buffer; increase it.')
    else blockread(f, s[1], s[0].dir[0].size - 1);
  end
  else assign(f, filename + '.GAM');
  if (not library) or (s[0].dir[0].size <= dirsize) then
  repeat
    if library then
      writeln('Library has ', 4 * s[0].dir[0].size, ' entries.');
    entry := 0;
    if library then
    for i := 0 to s[0].dir[0].size do
      for j := 0 to 3 do
        begin
          if (0 = s[i].dir[j].deleted) and (entry <= 4 * s[0].dir[0].size)
          then
            begin
              write(entry: 3, '. ');
              for k := 1 to 8 do write(s[i].dir[j].name[k]);
              write('.');
              for k:= 9 to 11 do write(s[i].dir[j].name[k]);
              writeln
            end;
          entry := entry + 1;
          if entry mod (screen - 1) = 0 then
            begin write('Pause...'); readln(ch) end
        end;
    if library then begin write('Which one?'); readln(entry) end;
    if (entry <> 0) or not library then
    begin
      if library
      then position(entry)
      else
      begin
        (*$I- *)
        reset(f);
        (*$I+ *)
        if ioresult <> 0 then
          writeln('File not found.');
      end;
      write('Loading ', title);
      bytes := 0;
      port[lsb] := 0;
      port[msb] := 0;
      port[control] := 4 { HALT };
      delay(1);
      port[control] := $84 { HOST + HALT };
      if library
      then
        for i := 1 to ss do writeblock
      else
        while not eof(f) do writeblock;
      if writelock then port[control] := 0 else port[control] := 1;
      writeln;
      writeln(256 * port[msb] + port[lsb]: 1,
            ' bytes of interface memory used.');
      writeln('RESET Vectrex to start game.');
    end
  until entry = 0
end.
