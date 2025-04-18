program investigate;

type
  FiledNote = record
                octave, note, staccato : byte;
                duration               : integer; { milliseconds? }
              end;

type
  NoteFile = file of FiledNote;

var
  f: notefile; j, i: byte;
  histogram: array[byte] of byte;

procedure noteout(d, n: integer);

begin
  histogram[n] := histogram[n] + 1
end;

procedure outnote(d, n: integer);
var q:filednote;
begin
  with q do
  begin
    n := (n - 100) div 2;
    octave := n div 12;
    note := 1 + n mod 12;
    staccato := 0;
    duration := 64 * 20 div d
  end;
  write(f, q)
end;

procedure tune1;
begin
 writeln('INVENTION.MUS - BACH INVENTION #13');
noteout(2,125);
noteout(2,166);
noteout(2,182);
noteout(2,177);
noteout(2,125);
noteout(2,177);
noteout(2,192);
noteout(4,182);
noteout(4,202);
noteout(4,159);
noteout(4,202);
noteout(2,166);
noteout(2,125);
noteout(2,166);
noteout(2,182);
noteout(2,177);
noteout(2,125);
noteout(2,177);
noteout(2,192);
noteout(4,182);
noteout(6,166);
noteout(2,202);
noteout(2,182);
noteout(2,202);
noteout(2,166);
noteout(2,182);
noteout(2,125);
noteout(2,151);
noteout(4,134);
noteout(4,166);
noteout(4,192);
noteout(6,206);
noteout(2,192);
noteout(2,177);
noteout(2,192);
noteout(2,151);
noteout(2,177);
noteout(2,105);
noteout(2,134);
noteout(4,125);
noteout(4,151);
noteout(4,182);
noteout(6,202);
noteout(2,182);
noteout(2,166);
noteout(2,182);
noteout(4,134);
noteout(6,192);
noteout(2,177);
noteout(2,151);
noteout(2,177);
noteout(4,125);
noteout(6,182);
noteout(2,166);
noteout(2,134);
noteout(2,166);
noteout(4,105);
noteout(4,177);
noteout(6,182);
end;

procedure tune2;
  begin
  writeln('MINUET.MUS - BACH MINUET IN G');
noteout(4,192);
noteout(2,151);
noteout(2,166);
noteout(2,177);
noteout(2,182);
noteout(4,192);
noteout(4,151);
noteout(4,151);
noteout(4,202);
noteout(2,182);
noteout(2,192);
noteout(2,202);
noteout(2,210);
noteout(4,214);
noteout(4,151);
noteout(4,151);
noteout(4,182);
noteout(2,192);
noteout(2,182);
noteout(2,177);
noteout(2,166);
noteout(4,177);
noteout(2,182);
noteout(2,177);
noteout(2,166);
noteout(2,151);
noteout(4,143);
noteout(2,151);
noteout(2,166);
noteout(2,177);
noteout(2,151);
noteout(4,177);
noteout(8,166);
noteout(4,192);
noteout(2,151);
noteout(2,166);
noteout(2,177);
noteout(2,182);
noteout(4,192);
noteout(4,151);
noteout(4,151);
noteout(4,202);
noteout(2,182);
noteout(2,192);
noteout(2,202);
noteout(2,210);
noteout(4,214);
noteout(4,151);
noteout(4,151);
noteout(4,182);
noteout(2,192);
noteout(2,182);
noteout(2,177);
noteout(2,166);
noteout(4,177);
noteout(2,182);
noteout(2,177);
noteout(2,166);
noteout(2,151);
noteout(4,166);
noteout(2,177);
noteout(2,166);
noteout(2,151);
noteout(2,143);
noteout(12,151);
noteout(5,228);
noteout(3,214);
noteout(3,222);
noteout(3,228);
noteout(3,214);
noteout(5,222);
noteout(2,192);
noteout(2,202);
noteout(2,210);
noteout(2,192);
noteout(4,214);
noteout(2,202);
noteout(2,210);
noteout(2,214);
noteout(2,192);
noteout(4,187);
noteout(2,177);
noteout(2,187);
noteout(4,166);
noteout(2,166);
noteout(2,177);
noteout(2,187);
noteout(2,192);
noteout(2,202);
noteout(2,210);
noteout(4,214);
noteout(4,210);
noteout(4,202);
noteout(4,210);
noteout(4,166);
noteout(4,187);
noteout(12,192);
noteout(4,192);
noteout(2,151);
noteout(2,143);
noteout(4,151);
noteout(4,202);
noteout(2,151);
noteout(2,143);
noteout(4,151);
noteout(4,192);
noteout(4,182);
noteout(4,177);
noteout(2,166);
noteout(2,151);
noteout(2,143);
noteout(2,151);
noteout(4,166);
noteout(2,105);
noteout(2,125);
noteout(2,143);
noteout(2,151);
noteout(2,166);
noteout(2,177);
noteout(4,182);
noteout(4,177);
noteout(4,166);
noteout(2,177);
noteout(2,192);
noteout(4,151);
noteout(4,143);
noteout(12,151);
end;


procedure tune3;
begin
writeln('BRANDENBURG.MUS - BACH BRANDENBURG CONCERTO #3');
noteout(2,151);
noteout(2,143);
noteout(4,151);
noteout(2,105);
noteout(2,85);
noteout(4,105);
noteout(2,151);
noteout(2,143);
noteout(4,151);
noteout(2,74);
noteout(4,52);
noteout(4,74);
noteout(2,151);
noteout(2,143);
noteout(4,151);
noteout(5,24);
noteout(4,52);
noteout(4,74);
noteout(4,95);
noteout(2,105);
noteout(2,95);
noteout(2,105);
noteout(2,125);
noteout(2,105);
noteout(2,143);
noteout(2,105);
noteout(2,151);
noteout(2,105);
noteout(2,95);
noteout(2,105);
noteout(2,125);
noteout(2,105);
noteout(2,166);
noteout(2,105);
noteout(2,177);
noteout(2,105);
noteout(2,95);
noteout(2,105);
noteout(2,125);
noteout(2,105);
noteout(2,182);
noteout(2,105);
noteout(2,192);
noteout(4,177);
noteout(2,166);
noteout(2,151);
noteout(4,166);
noteout(2,151);
noteout(2,143);
noteout(4,151);
noteout(2,143);
noteout(2,125);
noteout(2,105);
noteout(2,151);
noteout(2,105);
noteout(2,151);
noteout(4,125);
noteout(2,105);
noteout(2,85);
noteout(2,74);
noteout(2,151);
noteout(2,74);
noteout(2,151);
noteout(4,85);
noteout(2,74);
noteout(4,52);
noteout(5,24);
noteout(2,151);
noteout(5,24);
noteout(2,151);
noteout(2,74);
noteout(2,151);
noteout(2,95);
noteout(2,151);
noteout(2,105);
noteout(2,143);
noteout(2,105);
noteout(2,151);
noteout(2,105);
noteout(2,166);
noteout(2,105);
noteout(2,177);
noteout(2,105);
noteout(2,182);
noteout(2,105);
noteout(2,192);
noteout(4,177);
noteout(2,166);
noteout(2,151);
noteout(4,105);
noteout(4,143);
noteout(4,151);
noteout(2,143);
noteout(2,125);
noteout(2,105);
noteout(2,85);
noteout(2,74);
noteout(4,52);
noteout(4,74);
noteout(4,52);
noteout(5,24);
noteout(5,105);
noteout(5,105);
noteout(12,26);

end;

begin
  for i := 0 to 255 do histogram[i] := 0;
(* assign(f, 'INVENT.MUS'); rewrite(f); *)
  tune1;
  tune2;
  tune3;
(* close(f);*)
(* cleanup *)
noteout(0,197);
noteout(0,172);
noteout(0,115);
noteout(0,63);
noteout(0,218);
noteout(0,39);
noteout(0,225);
  j := 0;
for i := 0 to 255 do
  if histogram[i] > 0 then
    begin writeln(i:6, histogram[i]:6, i - j: 6); j := i end
end.
