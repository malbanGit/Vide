

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)


function done: boolean;

begin
  if library
  then done := ((ss <= 0) and (b = 0)) or eof(f)
  else done := eof(tune)
end;

function getbyte: byte;

var
  q: byte;

begin
  if not done then
  begin
    if b = 0 then blockread(f, z, 1);
    if b = 0 then ss := ss - 1;
    getbyte := z.byt[b]; b := b + 1;
    if b = 128 then b := 0;
  end
end;

procedure getstring(var x: twine);

var
  c: char;

begin
  if library
  then
    begin
      x := '';
      repeat x := x + chr(getbyte) until done or (x[length(x)] = ^J);
      while x[length(x)] in [^J, ^M] do x := copy(x, 1, length(x) - 1)
    end
  else readln(tune, x)
end;

procedure position(e: integer);

var
  a, d: integer;

begin
  b := 0;
  a := e div 4; d := e mod 4;
  title := copy(s[a].dir[d].name, 1, 8) + '.' + copy(s[a].dir[d].name, 9, 3);
  seek(f, s[a].dir[d].index); ss := s[a].dir[d].size;
end;

procedure puthex(x: twine);

const
  digit: array['0' .. 'F'] of byte =
         (0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,10,11,12,13,14,15);
var
  i, j: integer;
  z: byte;

begin
  for i := 1 to length(x) div 2 do
  begin
    z := 0;
    for j := 0 to 1 do
      z := 16 * z + digit[x[j+i+i-1]];
    port[data] := z;
  end;
end;

procedure putaddr(x: integer);

begin
  port[data] := x div 256; port[data] := x mod 256
end;

procedure setaddr(x: integer);

begin
  port[lsb] := x mod 256; port[msb] := x div 256
end;

procedure putstring(x: twine);

var
  i: byte;

begin
  for i := 1 to length(x) do port[data] := ord(x[i]);
  if not polyphonic then port[data] := $80
end;

procedure bumpshift(var x: twine);

var
  i: integer;

begin
  for i := 1 to length(x) do
    if x[i] in ['a' .. 'z'] then x[i] := chr(ord(x[i])-ord(' '));
end;

procedure header;

var
  my, ms, mb, mbaddr, mh: integer;

begin
  headed := true;
  port[control] := $80 { take control of interface };
  port[lsb] := 0;
  port[msb] := 0;
  putstring(year);
  my := port[lsb] + 256 * port[msb];
  port[data] := 0; { msb of music block address }
  port[data] := 0; { this byte rewritten later }
  port[data] := $F9;
  port[data] := $27;
  port[data] := $00;
  port[data] := 255 - 3 * length(title); { coordinates of title }
  bumpshift(title);
  putstring(title);
  port[data] := $F9;
  port[data] := $27;
  port[data] := $30;
  port[data] := 255 - 3 * length(author); { coordinates of author }
  putstring(author);
  port[data] := 0; { end of string block }

{ following code makes watching music more interesting. code is in DAISY.ASM }

  puthex('16009CFC19819031');
  puthex('3A2053484F5254454E80FC1981CC323A');
  puthex('20494E495480FC1981043C2057494454');
  puthex('48203E2080FC198148343A20424C414E');
  puthex('4B8000CC00BEFDC88386018EC899BFC8');
  puthex('8DBFC88F8ECB99BFC893BFC895A79FC8');
  puthex('8DA79FC8938E0000BFC891BFC8978EC8');
  puthex('8DBFC8898EC893BFC88B7FC88039AE22');
  puthex('ACA42719E61F1DE324ED24301A108CC8');
  puthex('8D2604ACA42707AF228601A78439CC00');
  puthex('00ED248EC899AFA420EDFCC853FDC881');
  puthex('7FCBFE8EC8856F8086B0A7808648A780');
  puthex('8601A78417FF7CCE');
  mbaddr := port[lsb] + 256 * port[msb];
  puthex('02BE7CC856BDF1AF'); { first word is music block address }
  puthex('BDF687BDF192BDF2897FC8217FC8227F');
  puthex('C8208601B7C81F7FC823BDF1F8CC0000');
  puthex('7DC81B270BCC00017DC81B2B03CCFFFF');
  puthex('BEC883308BBFC8834FBDF1B47DC81227');
  puthex('1010BEC88B17FF66260710BEC88917FF');
  puthex('5D7DC813270317FF1AFCC85310B3C881');
  puthex('2709FDC8811700A4170079AE9FC8896A');
  puthex('027DC81527057FC8802032BDF2A186CE');
  puthex('B7D00C8EC885BDF40886CEB7D00CAE9F');
  puthex('C8898601A1842708BDF40886CEB7D00C');
  puthex('AE9FC88B8601A1842703BDF408BDF354');
  puthex('BDF2A5CE000DBDF3857DC815261C7DC8');
  puthex('802617BDF354BDF2A1338DFE6EBDF385');
  puthex('8620B5D00D27037CC8807DC8561026FF');
  puthex('1C7EF00010BEC88BAE24FEC889EC4430');
  puthex('8BBCC8832F1517FEB526E910BEC889AE');
  puthex('24BCC8832F0517FEA526F0397DC85627');
  puthex('FAFEC853335EBEC88910AE84313A8CC8');
  puthex('8D261D108CC899250710AF841F122053');
  puthex('BEC88910BEC88BBFC88B10BFC88920CC');
  puthex('10BCC88F22E3108EC88D17FE6126BD10');
  puthex('8EC89317FE5810BEC89310BFC88D10BE');
  puthex('C89510BFC88F10BEC89710BFC8918E00');
  puthex('00BFC8978ECB99BFC893BFC8958601A7');
  puthex('8420ADAEA46F80E6C4E780E641E7804F');
  puthex('E6C4C13F270143A7806F80E64150E780');
  puthex('AC22270FA680A684A01AA784AE24503A');
  puthex('AF2439504FED248EC88D108CC88D2603');
  puthex('8EC893EC8410A302270DAE84A680A684');
  puthex('10AEA4A021A78439');
  mh := port[lsb] + 256 * port[msb];
    puthex('ED8FFEB60080'); { silent music block };
  port[data] := $FF; { envelope }
  port[data] := $FF;
  port[data] := $EE;
  port[data] := $EE;
  port[data] := $DD;
  port[data] := $DD;
  port[data] := $CC;
  port[data] := $CC;
  port[data] := $BB;
  port[data] := $BB;
  port[data] := $AA;
  port[data] := $AA;
  port[data] := $99;
  port[data] := $99;
  port[data] := $88;
  port[data] := $88;
  { MUSIC: }
  mb := port[lsb] + 256 * port[msb];
(*  putaddr(mb - 16); { our envelope } *)
  port[data] := $ED; port[data] := $8F; { an envelope }
(*  port[data] := $FE; port[data] := $E8; { another envelope } *)
  port[data] := $FE; port[data] := $B6; { end of music block header }
  { now fix up a few addresses }
  ms := 256 * port[msb] + port[lsb];
  setaddr(mbaddr); putaddr(mb);
  setaddr(my); putaddr(mh);
  setaddr(mb + 4); { ready for data now }
end { header } ;

procedure trailer;

var i: byte;

begin
  polyphonic := false;
  putstring(^@);
  for i := 0 to 255 do port[data] := $3F; { swi }
  port[control] := $00 ; { let her rip }
end;

procedure music(v1, v2, v3: twine);

var
  ch, x: char;
  len: integer;
  chord, s: twine;

{ Here is where we translate each voice into Vextrex triplets, except that
  it's only one voice at the moment.  Good luck! }

  procedure play(p, d: integer); { play the accumulated note }

  var
    x: byte;
    z: filednote;

    procedure complain;

    begin
      writeln; writeln('Pitch = ', p, ' Octave = ', octave); writeln;
      writeln('****  The note range of this tune is too large for me! ****');
      writeln; writeln; writeln;
    end;

    procedure raise;

    begin
      bumped := up; writeln;
      writeln('Octave ', octave, ', Pitch ', p, ' too low here.');
    end;

    procedure lower;

    begin
      bumped := down; writeln;
      writeln('Octave ', octave, ', Pitch ', p, ' too high here.');
    end;

  begin { play }
    if not headed then header;
    if p < 0 then if bumped = down then complain else raise;
    if p > rest then if bumped = up then complain else lower;
    if d = 0 then d := 1;
    while d > 0 do
    begin
      x := 0;
      if (d > 63) and not polyphonic and not converting
      then begin x := d - 64; d := 63 end;
      if polyphonic
      then
        if chord = ''
        then chord := chr(p) + chr(d)
        else
        begin if length(chord) < 4 then
          begin
            if d > ord(chord[length(chord)])
            then d := ord(chord[length(chord)]); { play shortest }
            delete(chord, length(chord), 1); { toss old length }
            chord := chr(p or $80) + chord + chr(d)
          end
        end
      else
        if converting
        then
          begin
            with z do
              begin
                staccato := 0; duration := 20 * d;
                octave := p div 12; note := 1 + p mod 12;
                if p = rest then note := 13;
              end;
              write(g, z);{ write out a .MUS element }
          end
        else
          begin port[data] := p; port[data] := d end;
      p := rest; d := x
    end
  end { play } ;

type
  FiledNote = record
                octave, note, staccato : byte;
                duration               : integer; { milliseconds? }
              end;


  procedure split;

  begin
    repeat
      x := s[1]; write(x);
      if x in ['a' .. 'z'] then x := chr(ord(x) - ord(' '));
      s := copy(s, 2, length(s) - 1);
    until (x <> ' ') or (length(s) < 1)
  end { split };

  procedure handle;

  var
    dummy, p, d, dd, dot: integer;

    function number: byte;

    var
      z: byte;

    begin
      z := 0; if s[1] = '=' then writeln('Forget it!');
      while (s[1] in ['0' .. '9']) and (length(s) > 0) do
      begin z := 10 * z + ord(s[1]) - ord('0'); split end;
      number := z
    end;

    procedure dodot(var total, increment: integer);

    begin
      if olddots
      then total := total + total div 2
      else
      begin
        increment := increment div 2;
        total := total + increment;
      end
    end;

  begin { handle }
    case x of
      '<': octave := octave - 1;
      '>': octave := octave + 1;
      '.': dodot(duration, dot); { lone dot for L directive }
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'P':
        begin { look out for A#4. }
          if x = 'P' then p := rest else p := 12 * octave + note[x];
          d := duration; dot := d;
          if length(s) > 0 then
            if s[1] in ['+', '-', '#']  then
              case s[1] of
                '#', '+': begin p := p + sharp; split end;
                '-': begin p := p + flat; split end;
              end;
          if (hold <> off) and (p <> pitch) and (pitch <> off) then
            { pitch changed during legato }
            begin play(pitch, hold); pitch := off; hold := off end;
          if length(s) > 0 then
            if s[1] in ['0' .. '9'] then
              begin d := tempo div number; dot := d end;
          while (length(s) > 0) and (s[1] = '.') do
            begin dodot(d, dot); split end;
          if factor = 1000 { legato }
          then { start legato sequence }
            if (pitch = off) and (hold = off)
            then begin pitch := p; hold := d end
            else hold := hold + d
          else { no longer legato, must finish what we started }
            if (hold <> off) and (pitch <> off)
            then begin play(pitch, hold + d); hold := off; pitch := off end
            else play(p, d)
        end;
      'H': begin { herald } title := s; writeln; writeln(s); s := '' end;
      'K': begin bumpshift(s); author := s; writeln; writeln(s); s := '' end;
      'L': begin duration := tempo div number; dot := duration end;
      'M': begin { ignore it just the same }
             split;
             case x of
               'B': ;
               'D': olddots := true;
               'F': ;
               'L': if polyphonic
                    then writeln('Mode ', x, ' ignored')
                    else factor := 1000;
               'N': if polyphonic
                    then writeln('Mode ', x, ' ignored')
                    else factor := 875;
               'S': if polyphonic
                    then writeln('Mode ', x, ' ignored')
                    else factor := 750;
             end;
           end;
      'N': play(number - 12 * bias, duration);
      'O': octave := number - bias;
      'R': begin writeln; writeln(s); s := '' end;
      'T': if converting
           then dummy := number
           else tempo := 64 * 188 div number;
      'V': dummy := number { ignore volume } ;
      'W': begin writeln; writeln(s); s := '' end;
      'X': writeln('Forget it!');
      'Y': begin
             year := copy(year, 1, 6) + s;
             writeln; writeln(s); s := ''
           end;
      'Z': begin
             if not headed then header;
             polyphonic := true; chord := '';
             writeln; writeln;
             writeln('Polyphonic format. Newlines now cause chords.');
             writeln; writeln;
           end;
    end
  end { handle } ;

begin { music }
  if polyphonic then chord := '';
  s := v1; while length(s) > 0 do begin split; handle end;
  if polyphonic then
    begin
      len := ord(chord[length(chord)]);
      if len > 63 then chord[length(chord)] := chr(63);
      putstring(chord);
      len := len - 64;
      while len > 0 do
      begin
        port[data] := rest;
        if len > 63 then port[data] := 63 else port[data] := len;
        len := len - 63;
      end;
    end;
  if polyphonic then writeln;
end;
