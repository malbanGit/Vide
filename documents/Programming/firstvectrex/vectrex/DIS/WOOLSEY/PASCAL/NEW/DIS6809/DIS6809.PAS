program dis6809;

(*      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.
*)

{
  At the moment this is a disassembler for the Motorola 6809 microprocessor.

  Stuff that can occur while resolving addresses:
    Under normal circumstances:
      1) Loads and stores of absolute addresses may be an 8-bit reference
         or a 16-bit reference.
      2) A reference might be either a jump or a load/store.
      3) Jumps (and data references) might be indexed.
      4) Some addresses may be outside the range of the disassembly.
      5) There are things that not even the most intelligent disassembler
         could hope to do properly.
    Under abnormal circumstances (still perfectly likely in disassembly):
      1) References to addresses might occur only in code which, it will
         later be determined, is data.  This renders the previous code
         data, and all *its* references are invalid, etcetera.
      2) Jumps may be found to land in the middle of other instructions.
}
{
    Known remaining bugs.  W85/06/26.
      1) Some relative branches should but don't get labels.
      2) If data follows an unconditional jump, there is no white space.
}
{
  TURBO Pascal has a stupid idiosyncracy whereby for a file of x, there is
  a header on the front of the file that describes the size of x and the
  number of x in the file.  An arbitrary file not created by TURBO is not
  likely to be readable by TURBO.  So, in order to read a real FILE OF BYTE,
  *I* have to do the buffering.  That's really crummy.
}

const
  tab = ^I;
  sectorsize = 128;
  fifteen = 15;
  sixteen = 16;
  passes = 2;
  romsize = 8191;
  instlabel = 'L';
  datalabel = 'D';
  nolabel = '$';
  immedlabel = '#';
  numpairs = 30;

type
  sector = array[1 .. sectorsize] of byte;
  range = (low, high);
  romrange = 0 .. romsize;
  word = packed array[range] of integer;
  ch5 = packed array[1 .. 5] of char;
  nybble = 0 .. fifteen;
  conversion = array[nybble] of char;
  modes = (inherent, relative, special, longrelative, indexed, extended, short,
           long, direct, data);
  addrkind = (none, narrow, broad, jump);
  pairs = array[1 .. numpairs] of array[0 .. 1] of real;

var
  s: sector; b: byte { global last byte read };
  fred: file;
  ginger: text;
  name: string[14];
  x, y, z: nybble;
  table: conversion;
  flow: set of byte;
  pile: array[nybble] of byte;
  size: array[modes] of nybble;
  junk, pass :integer;
  big, spot, address, bias: real;
  map: array[romrange] of addrkind;
  bytes: pairs;
  extensive: boolean;
  pilesize: nybble;

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
  write(ginger, table[x div sixteen], table[x mod sixteen]);
end;

procedure wordout(x: real);

begin
  convert(trunc(x / 256));
  convert(modd(x, 256))
end;

function inrange(var p: pairs): boolean;

var
  i: integer;
  x: boolean;

begin
  x := false;
  for i := 1 to numpairs do
    x := x or ((address > p[i, 0]) and (address <= p[i, 1]));
  inrange := x
end;

function refer(where: real): addrkind;

var
  z: real;

begin
  z := where - bias;  if z < 0 then z := z + 65536.0;
  if (z >= 0) and (z <= romsize)
  then refer := map[round(z)]
  else refer := none;
end;

procedure stake;

var
  z: addrkind;

begin
  case refer(address) of
    jump:
      begin
        write(ginger, instlabel);
        wordout(address)
      end;
    narrow, broad:
      begin
        write(ginger, datalabel);
        wordout(address)
      end
  end
end;

function done: boolean;

begin
  done := (b = 0) and eof(fred)
end;

function getbyte: byte;

var
  q: byte;

begin
  if not done then
  begin
    if b = 0 then writeln(' B ');
    if b = 0 then blockread(fred, s, 1);
    b := b + 1; getbyte := s[b];
    pilesize := pilesize + 1;
    pile[pilesize] := s[b];
    if b = 128 then b := 0;
    address := address + 1.0
  end
end;

procedure note(where: real; what: addrkind);

var
  z: real;

begin
  z := where - bias; if z < 0 then z := z + 65536.0;
  if (z >= 0) and (z <= romsize) then map[round(z)] := what
end;

procedure instruction;

var
  mode: modes;
  branch: boolean (* true if the current instruction is a jump *) ;
  wide: boolean (* true if the reference involves 16-bit data *) ;

(*$IDIS6809I.PAS *)

  procedure illegal;

  begin
    (* if refer(address) = broad then mode := short else *)
    mode := data;
    instr('FCB  ')
  end;

  procedure zero;

  begin (* direct *)
    branch := branch or (z in [14]);
    case x mod sixteen of
      1, 2, 5, 11: illegal;
      0: instr('NEG  ');
      3: instr('COM  ');
      4: instr('LSR  ');
      6: instr('ROR  ');
      7: instr('ASR  ');
      8: instr('ASL  ');
      9: instr('ROL  ');
      10: instr('DEC  ');
      12: instr('INC  ');
      13: instr('TST  ');
      14: instr('JMP  ');
      15: instr('CLR  ')
    end
  end;

  procedure one;

    procedure pagetwo;

    begin
      x := getbyte;
      z := x div 16;
      case x of
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47:
          begin
            mode := longrelative;
            case x mod sixteen of
              0: begin
                   if pass = 2 then
                     writeln(ginger, tab, 'FCB', tab, '$10');
                   illegal;
                 end;
              1: instr('LBRN ');
              2: instr('LBHI ');
              3: instr('LBLS ');
              4: instr('LBHS ');
              5: instr('LBLO ');
              6: instr('LBNE ');
              7: instr('LBEQ ');
              8: instr('LBVC ');
              9: instr('LBVS ');
              10: instr('LBPL ');
              11: instr('LBMI ');
              12: instr('LBGE ');
              13: instr('LBLT ');
              14: instr('LBGT ');
              15: instr('LBHE ')
            end
          end;
        63: begin mode := inherent; instr('SWI2 ') end;
        131: begin mode := long; instr('CMPD ') end;
        140: begin mode := long; instr('CMPY ') end;
        142: begin mode := long; instr('LDY  ') end;
        147: begin mode := direct; instr('CMPD ') end;
        156: begin mode := direct; instr('CMPY ') end;
        158: begin mode := direct; instr('LDY  ') end;
        159: begin mode := direct; instr('STY  ') end;
        163: begin mode := indexed; instr('CMPD ') end;
        172: begin mode := indexed; instr('CMPY ') end;
        174: begin mode := indexed; instr('LDY  ') end;
        175: begin mode := indexed; instr('STY  ') end;
        179: begin mode := extended; instr('CMPD ') end;
        188: begin mode := extended; instr('CMPY ') end;
        190: begin mode := extended; instr('LDY  ') end;
        191: begin mode := extended; instr('STY  ') end;
        206: begin mode := long; instr('LDS  ') end;
        222: begin mode := direct; instr('LDS  ') end;
        223: begin mode := direct; instr('STS  ') end;
        238: begin mode := indexed; instr('HDS  ') end;
        239: begin mode := indexed; instr('STS  ') end;
        254: begin mode := extended; instr('LDS  ') end;
        255: begin mode := extended; instr('STS  ') end
      else
        begin
          if pass = 2 then
            writeln(ginger, tab, 'FCB', tab, '$10');
          illegal
        end
      end { case }
    end;

    procedure pagethree;

    begin
      x := getbyte;
      z := x div 16;
      case x of
        63: begin mode := inherent; instr('SWI3 ') end;
        131: begin mode := long; instr('CMPU ') end;
        140: begin mode := long; instr('CMPS ') end;
        147: begin mode := direct; instr('CMPU ') end;
        156: begin mode := direct; instr('CMPS ') end;
        163: begin mode := indexed; instr('CMPU ') end;
        172: begin mode := indexed; instr('CMPS ') end;
        179: begin mode := extended; instr('CMPU ') end;
        188: begin mode := extended; instr('CMPS ') end
      else
        begin
          if pass = 2 then
            writeln(ginger, tab, 'FCB', tab, '$11');
          illegal
        end
      end { case }
    end;

  begin (* one, inherent *)
    z := x mod sixteen;
    if z in [6, 7] then mode := longrelative;
    if z in [10, 12] then mode := short;
    if z in [14, 15] then mode := special;
    case x mod sixteen of
      4, 5, 8, 11: illegal;
      0: pagetwo;
      1: pagethree;
      2: instr('NOP  ');
      3: instr('SYNC ');
      6: instr('LBRA ');
      7: instr('LBSR ');
      9: instr('DAA  ');
      10: instr('ORCC ');
      12: instr('ANDCC');
      13: instr('SEX  ');
      14: instr('EXG  ');
      15: instr('TFR  ');
    end
  end;

  procedure two;

  begin (* relative *)
    case x mod sixteen of
      0: instr('BRA  ');
      1: instr('BRN  ');
      2: instr('BHI  ');
      3: instr('BLS  ');
      4: instr('BCC  ');
      5: instr('BCS  ');
      6: instr('BNE  ');
      7: instr('BEQ  ');
      8: instr('BVC  ');
      9: instr('BVS  ');
      10: instr('BPL  ');
      11: instr('BMI  ');
      12: instr('BGE  ');
      13: instr('BLT  ');
      14: instr('BGT  ');
      15: instr('BLE  ')
    end
  end;

  procedure three;

  begin (* inherent *)
    z := x mod sixteen;
    if z in [0, 1, 2, 3] then mode := indexed;
    if z in [4, 5, 6, 7] then mode := special;
    case x mod sixteen of
      8, 14: illegal;
      0: instr('LEAX ');
      1: instr('LEAY ');
      2: instr('LEAS ');
      3: instr('LEAU ');
      4: instr('PSHS ');
      5: instr('PULS ');
      6: instr('PSHU ');
      7: instr('PULU ');
      9: instr('RTS  ');
      10: instr('ABX  ');
      11: instr('RTI  ');
      12: instr('CWAI ');
      13: instr('MUL  ');
      15: instr('SWI  ')
    end
  end;

  procedure four;

  begin (* inherent *)
    case x mod sixteen of
      1, 2, 5, 11, 14: illegal;
      0: instr('NEGA ');
      3: instr('COMA ');
      4: instr('LSRA ');
      6: instr('RORA ');
      7: instr('ASRA ');
      8: instr('ASLA ');
      9: instr('ROLA ');
      10: instr('DECA ');
      12: instr('INCA ');
      13: instr('TSTA ');
      15: instr('CLRA ')
    end
  end;

  procedure five;

  begin (* inherent *)
    case x mod sixteen of
      1, 2, 5, 11, 14: illegal;
      0: instr('NEGB ');
      3: instr('COMB ');
      4: instr('LSRB ');
      6: instr('RORB ');
      7: instr('ASRB ');
      8: instr('ASLB ');
      9: instr('ROLB ');
      10: instr('DECB ');
      12: instr('INCB ');
      13: instr('TSTB ');
      15: instr('CLRB ')
    end
  end;

  procedure six;

  var
    z: integer;

  begin (* indexed *)
    z := x mod sixteen;
    branch := branch or (z in [14]);
    case z of
      1, 2, 5, 11: illegal;
      0: instr('NEG  ');
      3: instr('COM  ');
      4: instr('LSR  ');
      6: instr('ROR  ');
      7: instr('ASR  ');
      8: instr('ASL  ');
      9: instr('ROL  ');
      10: instr('DEC  ');
      12: instr('INC  ');
      13: instr('TST  ');
      14: instr('JMP  ');
      15: instr('CLR  ')
    end
  end;

  procedure eight;

  var
    z: integer;

  begin (* immediate, mostly *)
    z := x mod sixteen;
    if z in [3, 12, 14] then mode := long;
    if z in [13] then mode := relative;
    case z of
      7, 15: illegal (* store immediate *);
      0: instr('SUBA ');
      1: instr('CMPA ');
      2: instr('SBCA ');
      3: instr('SUBD ');
      4: instr('ANDA ');
      5: instr('BITA ');
      6: instr('LDA  ');
      8: instr('EORA ');
      9: instr('ADCA ');
      10: instr('ORA  ');
      11: instr('ADDA ');
      12: instr('CMPX ');
      13: instr('BSR  ');
      14: instr('LDX  ')
    end
  end;

  procedure nine;

  var
    z: integer;

  begin (* direct *)
    z := x mod sixteen;
    wide := wide or (z in [3, 12, 14, 15]);
    branch := branch or (z in [13]);
    case z of
      0: instr('SUBA ');
      1: instr('CMPA ');
      2: instr('SBCA ');
      3: instr('SUBD ');
      4: instr('ANDA ');
      5: instr('BITA ');
      6: instr('LDA  ');
      7: instr('STA  ');
      8: instr('EORA ');
      9: instr('ADCA ');
      10: instr('ORA  ');
      11: instr('ADDA ');
      12: instr('CMPX ');
      13: instr('JSR  ');
      14: instr('LDX  ');
      15: instr('STX  ')
    end
  end;

  procedure ten;

  var
    z: integer;

  begin (* indexed *)
    z := x mod sixteen;
    branch := branch or (z in [13]);
    wide := wide or (z in [3, 12, 14, 15]);
    case z of
      0: instr('SUBA ');
      1: instr('CMPA ');
      2: instr('SBCA ');
      3: instr('SUBD ');
      4: instr('ANDA ');
      5: instr('BITA ');
      6: instr('LDA  ');
      7: instr('STA  ');
      8: instr('EORA ');
      9: instr('ADCA ');
      10: instr('ORA  ');
      11: instr('ADDA ');
      12: instr('CMPX ');
      13: instr('JSR  ');
      14: instr('LDX  ');
      15: instr('STX  ')
    end
  end;

  procedure twelve;

  var
    z: integer;

  begin (* immediate, mostly *)
    z := x mod sixteen;
    if z in [3, 12, 14] then mode := long;
    case z of
      7, 13, 15: illegal (* store immediate *);
      0: instr('SUBB ');
      1: instr('CMPB ');
      2: instr('SBCB ');
      3: instr('ADDD ');
      4: instr('ANDB ');
      5: instr('BITB ');
      6: instr('LDB  ');
      8: instr('EORB ');
      9: instr('ADCB ');
      10: instr('ORB  ');
      11: instr('ADDB ');
      12: instr('LDD  ');
      14: instr('LDU  ')
    end
  end;

  procedure thirteen;

  var
    z: integer;

  begin (* direct *)
    z := x mod sixteen;
    wide := wide or (z in [12, 13, 14, 15]);
    case z of
      0: instr('SUBB ');
      1: instr('CMPB ');
      2: instr('SBCB ');
      3: instr('ADDD ');
      4: instr('ANDB ');
      5: instr('BITB ');
      6: instr('LDB  ');
      7: instr('STB  ');
      8: instr('EORB ');
      9: instr('ADCB ');
      10: instr('ORB  ');
      11: instr('ADDB ');
      12: instr('LDD  ');
      13: instr('STD  ');
      14: instr('LDU  ');
      15: instr('STU  ')
    end
  end;


begin (* procedure instruction *)
  write('I');
  if pass = 2 then stake;
  pilesize := 0;
  spot := address;
  x := getbyte;
  z := x div sixteen;
  if inrange(bytes)
  then
    illegal
  else
    begin
      case z of { set defaults for mode }
        1, 3, 4, 5: mode := inherent;
        2:          mode := relative;
        6, 10, 14:  mode := indexed;
        7, 11, 15:  mode := extended;
        8, 12:      mode := short;
        0, 9, 13:   mode := direct;
      end;
      branch := false;
      wide := false;
      case z of
        0:          zero;
        1:          one;
        2:          two;
        3:          three;
        4:          four;
        5:          five;
        6, 7:       six;
        8:          eight;
        9:          nine;
        10, 11:     ten;
        12:         twelve;
        13, 14, 15: thirteen;
      end (* case z *)
    end { else }
end (* procedure instruction *);

procedure initialize;

var
  ch: char;

begin
  {find the smallest number big such that big + 0.4 = big}
  big:= 1.0;
  while (big + 0.5 > big) and (big + 0.5 < big + 1.0) do
    big:= big * 2.0;
  size[inherent] := 1; size[relative] := 2; size[indexed] := 2;
  size[data] := 1; size[extended] := 3; size[direct] := 2; size[short] := 2;
  size[long] := 3; size[longrelative] := 4; size[special] := 2;
  flow := [14, 32, 57, 59, 110, 126];
  for z := 0 to 9 do table[z] := chr(z + ord('0'));
  for z := 10 to fifteen do table[z] := chr(z + ord('A') - 10);
  writeln('enter binary file name:'); readln(name); assign(fred, name);
  for z := 0 to romsize do map[z] := none;
  write('extensive disassembly aids?');
  read(kbd, ch); writeln(ch); extensive := (ch in ['y', 'Y']);
  writeln('enter decimal address bias'); readln(bias);
  writeln('enter byte address pairs, one per line, decimal (0 0 to end):');
  for junk := 1 to numpairs do
  begin
    bytes[junk, 0] := 0; bytes[junk, 1] := 0;
  end;
  junk := 0;
  repeat
    junk := junk + 1;
    readln(bytes[junk, 0], bytes[junk, 1])
  until (bytes[junk, 1] = 0) or (junk = numpairs);
  writeln('enter source output file name:'); readln(name);
  assign(ginger, name); rewrite(ginger)
end { initialize } ;

begin
  initialize;
  write(ginger, tab, 'ORG', tab, '$');
  wordout(bias);
  writeln(ginger);
  writeln(ginger, tab, 'SETDP', tab, '0');
  writeln(ginger);
  for pass := 1 to passes do
  begin
    writeln('Pass', pass: 3);
    address := bias;
    reset(fred); b := 0;
    while not done do
      instruction;
   writeln
  end;
  writeln(ginger, tab, 'END');
  close(ginger);
  writeln('Disassembly complete.')
end.
