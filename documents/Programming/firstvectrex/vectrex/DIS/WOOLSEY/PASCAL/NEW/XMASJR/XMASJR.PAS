program xmasjr; (*$R+ *)

type
  twine = string[30];
  seq = array[1 .. 50] of byte;

var
  f: text;
  music: array[1..50, 1..3] of twine;
  measure: byte;

procedure data(one, two, three: twine);

begin
  measure := measure + 1;
  music[measure, 1] := one;
  music[measure, 2] := two;
  music[measure, 3] := three;
end;

procedure jinglebells;

const
  m = 22;
  v = 3;
  s = 33;
  title = 'JINGLE BELLS';
  author = 'John Pierpont';
  sequence : array[1 .. s] of byte =
(1,2,3,2,4,5,6,7,8,2,9,2,10,5,11,12,13,14,14,15,16,17,18,19,20,14,14,15,16,17,18,21,22);

var
  i, j: integer; it: twine;

begin
 measure := 0;
 data('mbmno2t125v12', 'mbmno1t125v10', 'mbmno1t125v10');
 data('d8b8a8g8',      'g8>d8d8d8',     'p8b8b8b8');
 data('d4.d16d16',     '<g8d8b8p8',     'p4g8p8');
 data('e2',            'c8<g8c8p8',     'p2');
 data('e8>c8<b8a8',    'c8a8a8a8',      'p8e8e8e8');
 data('f#2',           'd8>c8c8c8',     'p8a8a8a8');
 data('>d8d8c8<a8',    '<d8>d8d8d8',    'p8f#8f#8f#8');
 data('b2',            '<g8>d8d8<d8',   'p8b8b8p8');
 data('d2',            '<g8d8b8p8',     'p4g8p8');
 data('e4.e8',         'c8<g8c8p8',     'p2');
 data('>d8d8d8d8',     'd8b8b8b8',      'p8g8g8g8');
 data('e8d8c8<a8',     'd8>c8<d8>c8',   'p8a8p8f#8');
 data('g4>g4<',        '<b4>>d4<<',     'g4>b4<');
 data('b8b8b4',        'g8>d8d8<d8',    'p8b8b8p8');
 data('b8>d8<g8.a16',  'g8>d8d8<d8',    'p8b8b8p8');
 data('b2',            'g8>d8d8<d8',    'p8b8b8p8');
 data('>c8c8c8.c16',   'f#8>d8d8<d8',   'p8>c8c8p8');
 data('c8<b8b8b16b16', 'g8>d8d8<d8',    'p8<b8b8p8');
 data('b8a8a8b8',      'e8>c#8c#8c#8',  'p8a8a8a8');
 data('mla4mn>d4<',    'd4d4<',         'f#4f#4');
 data('>d8d8c8<a8',    'f#8>d8d8<d8',   'p8>c8c8p8');
 data('g2',            'b2',            'g2');
 for j := 1 to v do
 begin
  str(j, it);
  assign(f, copy(title, 1, 2) + it + '.TUN');
  rewrite(f);
  writeln(f, 'H', title);
  if author <> '' then writeln(f, 'K', author);
  for i := 1 to s do
    writeln(f, music[sequence[i], j]);
  close(f);
 end
end;

procedure patapan;

const
  title = 'PATAPAN'; author = '';
  m = 10;
  v = 3;
  s = 24;
  sequence : array[1 .. s] of byte =
(1,2,2,3,4,5,6,7,8,9,3,4,5,6,7,8,9,3,4,5,6,7,8,10);

var i,j : byte; it: twine;

begin
 measure := 0;
 data('mbmno3t95v10','mbmno3t95v10','mbmno2t95v10');
 data('p1','o1mlg8p8g8p8g8p8p4o2mn','mlc#64d64d32d16p8d8p8d8p8p4');
 data('g8g8','g8g8','p8p8');
 data('>d8d8c8d8<b-8a16b-16>c8<a8','b-8b-8a8b-8g8f#16g16a8a8','c#64d64d32d16p8d8p8d8p8p4');
 data('>d4<b-4a4a8b-8','b-4g4f#4f#8g8','c#64d64d32d16p8d8p8d8p8p4');
 data('a8f#8g8a8b-4g16a16b-16>c16','f#8d8e8f#8g4g16f#16g16a16','d8p8d8p8g8p8p4');
 data('d4c16d16c16<b-16a4a8b-8','b-4a16b-16a16g16f#4f#8g8', 'g8p8<g8p8>d8p8p4');
 data('a8f#8g8a8b-8a16b-16>c8<b-16a16','f#8d8e8f#8g8g16g16g8g8','d8p8d8p8g8p8e-8p8');
 data('>d4<a4g4','g4f#4g4','mn<b-8>c8d4<g4>ml');
 data('ml>d8p8p4<a8p8p4g8','mlg8p8p4f#8p8p4g8','ml<b-8p8p4>d8p8p4<g8');
 for j := 1 to v do
 begin
  str(j, it);
  assign(f, copy(title, 1, 2) + it + '.TUN');
  rewrite(f);
  writeln(f, 'H', title);
  if author <> '' then writeln(f, 'K', author);
  for i := 1 to s do
    writeln(f, music[sequence[i], j]);
  close(f);
 end
end;

procedure midnightclear;

const
  title = 'IT CAME UPON A MIDNIGHT CLEAR';
  author = 'Richard S. Willis';
  m = 17;
  v = 3;
  s = 33;
  sequence : array[1 .. s] of byte =
           (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,
              2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17);

var i,j : byte; it: twine;

begin
 measure := 0;
 data('mbmno2t80v10',           'mbmno2t80v8',     'mbmno1t80v8');
 data('f8>d4c8mlc8mn<b-8g8',    'd8d4d8e-4e-8',    'f8f4f#8g4a8');
 data('f4g8f4f8',               'd4e-8d4d8',       'b-4a8b-4b-8');
 data('g8a8b-8mlb-8>mnc8d8',    'e-4e-8e4e8',      'b-4b-8mlg8mna8b-8');
 data('mlc4.mnc4<f8',           'f4g8a4d8',        'a4b-8>c4<f8');
 data('>d4<a8ml>c8mn<b-8g8',    'd4d8e-4e-8',      'f4f#8g4a8');
 data('f4g8f4f8',               'd4e-8d4d8',       'b-4a8b-4b-8');
 data('g4g8mla8mng8f8',         'e-4e-8e-4e-8',    'b-4>c8mlc8<b-8mna8');
 data('mlb-4.mnb-4>d8',         'mlf4.mnf4d8',     '<mlb-4.mnb-4>d8');
 data('d4<d8mld8mne8f#8',       'd4<a8mla8mng8a8', 'd4d8d4c8');
 data('g4a8b-4>d8',             '>d4f#8g4g8',      '<b-4>d8g4<b-8');
 data('mlc8mn<b-8a8mlg8mna8g8', 'mlc8mnd8c8ml<b-8mn>c8<b-8', '>c4c8c4c8');
 data('mlf4.mnf4f8',            'a8>c8d8e-8d8c8',  'c8e-8f8g8f8e-8');
 data('>d4<a8ml>c8mn<b-8g8',    'd4d8e-4e-8',      'f4f#8g4a8');
 data('f4g8f4f8',               'd4e-8d4d8',       'b-4a8b-4b-8');
 data('g4g8mla8mng8f8',         'e-4e-8e-4e-8',    'b-4>c8mlc8<b-8mna8');
 data('mlb-4.mnb-4',            'mlf4.mnf4',       '<mlb-4.mnb-4>');
 for j := 1 to v do
 begin
  str(j, it);
  assign(f, copy(title, 1, 2) + it + '.TUN');
  rewrite(f);
  writeln(f, 'H', title);
  if author <> '' then writeln(f, 'K', author);
  for i := 1 to s do
    writeln(f, music[sequence[i], j]);
  close(f);
 end
end;

procedure deckthehall;

const
 title = 'DECK THE HALL'; author = '';
 m = 17;
 v = 3;
 s = 33;
 sequence : array[ 1 .. s] of byte =
          (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,
             2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17);

var i,j : byte; it: twine;

 begin
 measure := 0;
 data('mbmno3t200v10',    'mbmno3t200v10',    'mbmno2t200v10');
 data('>d4.c8<b4a4',      'b4.a8g4d4',        'p1');
 data('g4a4b4g4',         '<b4>d4g4g4',       'p1');
 data('a8b8>c8<a8b4p8a8', 'd8d8d8d8d4p8c8',   'd8d8d8d8g4p8c8');
 data('g4f#4g2',          '<b4a4b2',          'd4d4g2');
 data('p1',               '>d4.c8<b4a4',      'b4.a8g4d4');
 data('p1',               'g4a4b4g4',         '<b4>d4g4g4');
 data('f#8g8a8f#8g4p8g8', 'a8b8>c8<a8b4p8a8', 'd8d8d8d8g4p8e8');
 data('d4d4d2',           'g4f#4g2',          'd4d4g2');
 data('a4.b8>c4<a4',      'p4>d8d8d4d4',      'p4>c8<b8a4>c4');
 data('b4.>c8d4<a4',      'p4d8c8<b4>d4',     'p4<b8a8g4f#4');
 data('b8>c8d4e8f#8g4',   'g8a8b4b8a8g4',     'g2p4e4');
 data('f#4e4d2',          'd8d8c#4d2',        'f#8g8a4d2');
 data('d4.c8<b4a4',       'd4.c8<b4a4',       'p1');
 data('g4a4b4g4',         'g4a4b4g4',         'p1');
 data('>e8e8e8e8d4.c8',   '>e4f#4g4b8a8',     '>c4c4<b4.>e8');
 data('<b4a4g2',          'g4f#4g2',          'd4.c8<b2');
 for j := 1 to v do
 begin
  str(j, it);
  assign(f, copy(title, 1, 2) + it + '.TUN');
  rewrite(f);
  writeln(f, 'H', title);
  if author <> '' then writeln(f, 'K', author);
  for i := 1 to s do
    writeln(f, music[sequence[i], j]);
  close(f);
 end
end;

procedure joytotheworld;
const
  title = 'JOY TO THE WORLD';
  author = 'George Frederick Handel';
  m = 11;
  v = 3;
  s = 21;
  sequence : array[1 .. s] of byte =
             (1,2,3,4,5,6,7,8,9,10,11,2,3,4,5,6,7,8,9,10,11);

var i,j : byte; it: twine;

begin
 measure := 0;
 data('mbmno3t85v10', 'mbmno2t85v10', 'mbmno2t85v10');
 data('>d4c#8.<b16a4.g8', 'a4a8.a16>d4.<b8', 'd4d8.d16mld8.e16mnf#8g8');
 data('f#4e4d4.a8', 'a4mla8mng8f#4.f#8', 'a4<a4b4.a8');
 data('b4.b8>c#4.c#8', 'g4.g8g4.a8', 'g4>mlg8mnf#8e4.a8');
 data('d4.d8mld8mnc#8<mlb8mna8', 'a4.p8p4.a8', 'd4.p8p4.f#8');
 data('mla8.g16mnf#8>d8mld8mnc#8<mlb8mna8', 'b8>c#8d8p8p4.<a8', 'a8a8d8p8p4.a8');
 data('mla8.g16mnf#8f#8f#8f#8f#8mlf#16mng16', 'b8>c#8d8p8p4.d8', 'a8a8d8p8p4.d8');
 data('a4.mlg16mnf#16e8e8e8mle16mnf#16', '<a8a8a8b8>c#4.<mlb16mna16', 'f#8f#8f#8g8a4.mlg16mnf#16');
 data('g4.mlf#16mne16mld8mn>d4<b8', 'g8g8g8a8b4.>c#8', 'e8e8e8f#8g4.g8');
 data('mla8.g16mnf#8g8f#4e4', 'd4.d8<a4mla8mng8', 'f#4.b8a4<a4');
 data('d2', 'f#2', '>d2');
 for j := 1 to v do
 begin
  str(j, it);
  assign(f, copy(title, 1, 2) + it + '.TUN');
  rewrite(f);
  writeln(f, 'H', title);
  if author <> '' then writeln(f, 'K', author);
  for i := 1 to s do
    writeln(f, music[sequence[i], j]);
  close(f);
 end
end;

procedure heraldangels;

const
  title = 'HARK! THE HERALD ANGELS SING';
  author = 'Felix Mendelssohn';
  m = 19;
  v = 3;
  s = 41;
  sequence : array[ 1 .. s] of byte =
           (1,2,3,4,5,6,7,8,9,10,11,10,11,12,13,14,15,16,17,18,19,
              2,3,4,5,6,7,8,9,10,11,10,11,12,13,14,15,16,17,18,19);

var i,j : byte; it: twine;

begin
 measure := 0;
 data('mbmno3t120v10',      'mbmno3t120v10', 'mbmno2t120v10');
 data('d4g4g4.f#8',         'd4d4d4.d8',     'g4g4g4.d8');
 data('g4b4mlb4mna4',       'd4g4mlg4mnf#4', '<b4g4>d2');
 data('>d4d4d4.c8',         'g4f#4e4a4',     '<b4b4>c4c4');
 data('<b4a4b2',            'g4f#4g2',       'd4d4<g2');
 data('d4g4g4.f#8',         'd4d4d4.c8',     '>g4g4g4.d8');
 data('g4b4mlb4mna4',       '<b4>g4g2',      'e4d4c#4.<a8');
 data('>d4<a4a4.f#8',       'f#4e4f#4.d8',   'b4>c#4d4<f#4');
 data('f#4e4d2',            'd4c#4d2',       'g4a4>d2');
 data('>d4d4d4<g4',         'p1',            '>d4d4d4<b4');
 data('>c4<b4mlb4mna4',     'a4g4mlg4mnf#4', 'f#4g4d2');
 data('>e4e4e4d4',          '>c4c4c4<b4',    'c4c4c4d4');
 data('c4<b4>c2',           'a4g#4a2',       'e4e4a2');
 data('<a4mlb8mn>c8d4.<g8', 'f#4f#4g4.d8',   '>d4c4<b4g4');
 data('g4a4b2',             'd4f#4g2',       'd4d4g2');
 data('>e4.e8e4d4',         '>c4.c8c4<b4',   'c4.c8c4c4');
 data('c4<b4>c2',           'a4g#4a2',       'c4e4mla4mng4');
 data('<a4mlb8mn>c8d4.<g8', 'd4f#4g4.d8',    'f#4>c4<b4g4');
 data('g4a4g2',             'd4f#4g2',       'd4d4g2');
 for j := 1 to v do
 begin
  str(j, it);
  assign(f, copy(title, 1, 2) + it + '.TUN');
  rewrite(f);
  writeln(f, 'H', title);
  if author <> '' then writeln(f, 'K', author);
  for i := 1 to s do
    writeln(f, music[sequence[i], j]);
  close(f);
 end
end;

begin
  jinglebells;
  patapan;
  midnightclear;
  deckthehall;
  joytotheworld;
  heraldangels;
end.
