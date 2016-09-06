(*$A- Allow recursion *)
program detokenize;

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

{  An attempt to turn a tokenized IBM-BASIC file back into ENGLISH.
   These things have PLAY statements which could eventually be played
   on the Vectrex }
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
  digits: string[16] = '0123456789ABCDEF';

type
  sector = array[1 .. sectorsize] of byte;
  ch5 = packed array[1 .. 5] of char;
  nybble = 0 .. fifteen;
  conversion = array[nybble] of char;

var
  s: sector; b: byte { global last byte read };
  fred: file;
  f: text;
  name: string[14];
  x, y, z: nybble;
  table: conversion;
  big: real;
  done: boolean;

procedure writebase(n, b, w: integer);

begin
  if w > 0 then
  begin writebase(n div b, b, w - 1); write(f,digits[n mod b + 1]) end
end;

function ftrunc(x: real): real;

var
  y: real;

begin
  if x >= big
  then
    ftrunc := x
  else
    begin
      y := x + big;
      y := y - big;
      if y > x
      then ftrunc := y - 1.0
      else ftrunc := y
    end
end { ftrunc } ;

function modd(a, b: real): integer;

begin
  modd := trunc(a - b * ftrunc(a / b))
end;

function fround(a: real): real;

begin
  fround := ftrunc(a + 0.5)
end;

procedure convert(x: byte);

begin
  write(f,table[x div sixteen], table[x mod sixteen]);
end;

procedure wordout(x: real);

begin
  convert(trunc(x / 256));
  convert(modd(x, 256))
end;

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

function getint:integer;

  var
    q: byte;

begin
  q := getbyte;
  getint := q + 256 * getbyte;
end;

procedure rope; { extract and print a string }

var
  d: byte;

begin
  write(f,'"'); d := getbyte;
  while d <> 34 do begin write(f,chr(d)); d := getbyte end;
  write(f,'"')
end;

procedure statement;

var
  line: integer;
  kind, c, d: byte;

  procedure span(c: byte);

  begin
    while d <> c do begin write(f,chr(d)); d := getbyte end;
  end;

  procedure token(x: byte);

    procedure number(n: byte);

    var
      i: byte;

    begin
      case n of
        11: begin write(f,'&O'); writebase(getint, 8, 5) end;
        12: begin write(f,'&H'); writebase(getint, 16, 4) end;
        13, 16, 27, 30: write(f,'Not used!');
        14, 28: write(f,getint: 1);
        15: write(f,getbyte: 1);
        17, 18, 19, 20, 21, 22, 23, 24, 25, 26: write(f,n - 17: 1);
        29: begin write(f,'Single...'); for i := 1 to 4 do convert(getbyte) end;
        31: begin write(f,'Double...'); for i := 1 to 8 do convert(getbyte) end;
      end { case }
    end;

  begin { token }
    if (x < 128) and (x > 31) then write(f,chr(x)) else
    if (x < 31) and (x > 10) then number(x) else
    case x of
      129: write(f,'END');
      130: write(f,'FOR');
      131: write(f,'NEXT');
      132: write(f,'DATA');
      133: write(f,'INPUT');
      134: write(f,'DIM');
      135: write(f,'READ');
      136: write(f,'LET');
      137: write(f,'GOTO');
      138: write(f,'RUN');
      139: write(f,'IF');
      140: write(f,'RESTORE');
      141: write(f,'GOSUB');
      142: write(f,'RETURN');

      143: write(f,'REM');
      144: write(f,'STOP');
      145: write(f,'PRINT');
      146: write(f,'CLEAR');
      147: write(f,'LIST');
      148: write(f,'NEW');
      149: write(f,'ON');
      150: write(f,'WAIT');
      151: write(f,'DEF');
      152: write(f,'POKE');
      153: write(f,'CONT');
      154, 155, 159, 180, 181, 182, 203, 223, 224, 225, 226, 227, 228, 229:
        write(f,'NU');
      156: write(f,'OUT');
      157: write(f,'LPRINT');

      158: write(f,'LLIST');
      160: write(f,'WIDTH');
      161: write(f,'ELSE');
      162: write(f,'TRON');
      163: write(f,'TROFF');
      164: write(f,'SWAP');
      165: write(f,'ERASE');
      166: write(f,'EDIT');
      167: write(f,'ERROR');
      168: write(f,'RESUME');
      169: write(f,'DELETE');

      170: write(f,'AUTO');
      171: write(f,'RENUM');
      172: write(f,'DEFSTR');
      173: write(f,'DEFINT');
      174: write(f,'DEFSNG');
      175: write(f,'DEFDBL');
      176: write(f,'LINE');
      177: write(f,'WHILE');
      178: write(f,'WEND');
      179: write(f,'CALL');

      183: write(f,'WRITE');
      184: write(f,'OPTION');
      185: write(f,'RANDOMIZE');
      186: write(f,'OPEN');
      187: write(f,'CLOSE');
      188: write(f,'LOAD');
      189: write(f,'MERGE');
      190: write(f,'SAVE');
      191: write(f,'COLOR');
      192: write(f,'CLS');
      193: write(f,'MOTOR');

      194: write(f,'BSAVE');
      195: write(f,'BLOAD');
      196: write(f,'SOUND');
      197: write(f,'BEEP');
      198: write(f,'PSET');
      199: write(f,'PRESET');
      200: write(f,'SCREEN');
      201: write(f,'KEY');
      202: write(f,'LOCATE');
      204: write(f,'TO');
      205: write(f,'THEN');
      206: write(f,'TAB(');

      207: write(f,'STEP');
      208: write(f,'USR');
      209: write(f,'FN');
      210: write(f,'SPC');
      211: write(f,'NOT');
      212: write(f,'ERL');
      213: write(f,'ERR');
      214: write(f,'STRING$');
      215: write(f,'USING');
      216: write(f,'INSTR');
      217: write(f,'''');
      218: write(f,'VARPTR');
      219: write(f,'CSRLIN');

      220: write(f,'POINT');
      221: write(f,'OFF');
      222: write(f,'INKEY$');
      230: write(f,'>');
      231: write(f,'=');
      232: write(f,'<');
      233: write(f,'+');
      234: write(f,'-');
      235: write(f,'*');
      236: write(f,'/');
      237: write(f,'^');
      238: write(f,'AND');
      239: write(f,'OR');
      240: write(f,'XOR');
      241: write(f,'EQV');

      242: write(f,'IMP');
      243: write(f,'MOD');
      253: case getbyte of
             129: write(f,'CVI');
             130: write(f,'CVS');
             131: write(f,'CVD');
             132: write(f,'MKI$');
             133: write(f,'MKS$');
             134: write(f,'MKD$');
           end;
      254: case getbyte of
             129: write(f,'FILES');
             130: write(f,'FIELD');
             131: write(f,'SYSTEM');
             132: write(f,'NAME');
             133: write(f,'LSET');
             134: write(f,'RSET');
             135: write(f,'KILL');
             136: write(f,'PUT');
             137: write(f,'GET');
             138: write(f,'RESET');
             139: write(f,'COMMON');
             140: write(f,'CHAIN');

             141: write(f,'DATE$');
             142: write(f,'TIME$');
             143: write(f,'PAINT');
             144: write(f,'COM');
             145: write(f,'CIRCLE');
             146: write(f,'DRAW');
             147: write(f,'PLAY');
             148: write(f,'TIMER');
             149: write(f,'ERDEV');
             150: write(f,'IOCTL');
             151: write(f,'CHDIR');
             152: write(f,'MKDIR');

             153: write(f,'RMDIR');
             154: write(f,'SHELL');
             155: write(f,'ENVIRON');
             156: write(f,'VIEW');
             157: write(f,'WINDOW');
             158: write(f,'PMAP');
           end;
      255: case getbyte of { intrinsic function names }
             129: write(f,'LEFT$');
             130: write(f,'RIGHT$');
             131: write(f,'MID$');
             132: write(f,'SGN');
             133: write(f,'INT');
             134: write(f,'ABS');
             135: write(f,'SQR');
             136: write(f,'RND');
             137: write(f,'SIN');
             138: write(f,'LOG');
             139: write(f,'EXP');
             140: write(f,'COS');
             141: write(f,'TAN');
             142: write(f,'ATN');
             143: write(f,'FRE');

             144: write(f,'INP');
             145: write(f,'POS');
             146: write(f,'LEN');
             147: write(f,'STR$');
             148: write(f,'VAL');
             149: write(f,'ASC');
             150: write(f,'CHR$');
             151: write(f,'PEEK');
             152: write(f,'SPACE$');
             153: write(f,'OCT$');
             154: write(f,'HEX$');
             155: write(f,'LPOS');
             156: write(f,'CINT');
             157: write(f,'CSNG');

             158: write(f,'CDBL');
             159: write(f,'FIX');
             160: write(f,'PEN');
             161: write(f,'STICK');
             162: write(f,'STRIG');
             163: write(f,'EOF');
             164: write(f,'LOC');
             165: write(f,'LOF');
           end
    end { case };
  end { token } ;

begin { statement }
  d := getbyte; { toss wierd leading byte }
  c := getbyte; { toss line number magnititude approximation (n/100+16?) }
  done := (c = 0) and (d = 0);
  if not done then
  begin
    line := getint;
    write(f,line: 1, ' ');
    repeat
      kind := getbyte;
      if (kind = 58) and false
      then
        begin
          kind := getbyte;
          if kind = 143 then rope
          else if kind <> 161 then write(f,':')
        end
      else
        token(kind);
    until kind = 0;
    writeln(f);
  end;
end { statement } ;

procedure initialize;

var
  ch: char;

begin
  {find the smallest number big such that big + 0.4 = big}
  big:= 1.0;
  while (big + 0.5 > big) and (big + 0.5 < big + 1.0) do
    big:= big * 2.0;
  for z := 0 to 9 do table[z] := chr(z + ord('0'));
  for z := 10 to fifteen do table[z] := chr(z + ord('A') - 10);
  done := false;
  write('Enter binary file name:'); readln(name);
  assign(fred, name+'.TOK'); assign(f, name+'.BAS');
(* malban  assign(fred, name+'.TOK'); assign(f, 'B:'+name+'.BAS'); *)
end { initialize } ;

begin
  initialize;
  reset(fred); b := 0; rewrite(f);
  if getbyte <> $FF then writeln('Not a tokenized program.') else
  while not done do
    statement;
  close(f)
end.
