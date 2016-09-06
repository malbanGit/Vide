 program play;
 program play;

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

(* This is version 1 of something to convert IBM PC BASIC PLAY strings
   into Vectrex music.  *)

const
  dirsize = 47;
  note: array['A' .. 'G'] of integer = (10, 12, 1, 3, 5, 6, 8);
                                       {9, 11, 0, 2, 4, 5, 7}
  rest = 63;
  flat = -1;
  sharp = 1;
  off = 100;

  control = $30;
  data = $31;
  lsb = $32;
  msb = $33;
  converting = false;

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
  screen: byte;
  my_number: byte;
  last_byte: integer;
  has_comment: boolean;
  comment: string[255];

  f: file;
  vof: text;
  outfilename: string[255];

(*  of byte; *) (* malban *)
  vofc: integer; (* malban *)
  g: notefile;
  tune: text;
  s: array[0 .. dirsize] of sector;
  z: sector;
  i, j, k, entry: integer;
  olddots, polyphonic, headed, library: boolean;
  b, ss: integer;
  filename, q: twine;
  ch: char;
  bumped: (down, no, up);
  pitch, hold, duration, tempo: integer;
  bias, octave, factor: integer;
  title, author, year, stuff: twine;
  reply: integer;


(*$I VECMUSIC.PAS *)

begin
  has_comment := false;
  screen := 25;
  vofc := 0; (* malban *)
  library := false;
  if converting then
  begin
    write('Enter MUSic file name:');
    readln(filename);
    assign(g, filename + '.MUS');
    rewrite(g)
  end;
  write('Enter tune name:');
  readln(filename);
  title := filename;

  library := (filename = '');
  if library then filename := 'VECMUSIC.LBR';
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
  else
  begin
   assign(tune, filename + '.TUN');
  end;

  entry := 0;
  if (not library) or (s[0].dir[0].size <= dirsize) then
  begin
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
            if entry mod (screen - 2) = 0 then
              begin write('Pause...'); readln(ch) end
          end;
      if library then begin write('Which one?'); readln(entry) end;
      bias := 1;
      if (entry <> 0) or not library then
      repeat
        last_byte := -1;
        polyphonic := false;
        pitch := off; hold := off; { out of range }
        tempo := 64;
        headed := false; olddots := false;
        octave := 3;
        duration := 32; factor := 875;
        author := 'bbb'; year := 'g GCE acjk';
        bumped := no;
        if library then
        begin
         position(entry);
         outfilename:='LIB_XXX.ASM';
         outfilename[5] := chr((entry div 100) + 48);
         outfilename[6] := chr(((entry mod 100) div 10) + 48);
         outfilename[7] := chr((entry mod 10) + 48);
         assign(vof,outfilename); (* malban *)
         rewrite(vof); (* malban *)
        end
        else
        begin
          assign(vof,filename+'.ASM'); (* malban *)
          rewrite(vof); (* malban *)
          (*$I- *)
          reset(tune);
          (*$I+ *)
          if ioresult <> 0 then
            writeln('File not found.');
        end;
        while not done do
        begin
          getstring(stuff);
          music(stuff, '', '');
        end;
        writeln;
        writeln;
        if bumped <> no then
          writeln('Oops.  Have to bump it an octave.  Hang on.');
        writeln;
        writeln;
        case bumped of
          down: bias := bias + 1;
          up: bias := bias - 1
        end;
        if converting and (bumped <> no) then rewrite(g);
        close(vof);
      until bumped = no;
      if not converting then
        if ((not library) or (entry <> 0)) and not headed then header;
      if not converting then
        if (not library) or (entry <> 0) then trailer;
(*
      writeln(256 * port[msb] + port[lsb]: 1,
              ' bytes of interface memory used.');
      writeln('RESET Vectrex to start music.');
*)
    until entry = 0;
    if converting then close(g);
  end
end.
