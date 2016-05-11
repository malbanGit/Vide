PROGRAM mod2vectrex;

{

TODO:
}

uses crt;

TYPE
 tone_type = record
  instrument : byte;
  period : integer;
  note : byte;
  effect1 : byte;
  effect2 : byte;
  effect3 : byte;
 end;

 voice_type = record
  tone : array[0..63] of tone_type;
 end;

 pattern_type = record
  voice : array[0..3] of voice_type;
  used : boolean;
 end;
 
 sample_type = record
  name : string[22];
  length : word; // * 2 gives real length in bytes, big-endian (swap lo,high)
  finetune : byte; // mask upper 4 bits
  volume : byte; // 0-64
  repeat_pos : word; // * 2 gives offset in bytes
  repeat_length : word; // * 2 gives replen in bytes
 end;

CONST
 PROGNAME = 'Mod2Vectrex';
 VERSION = '1.08';
 _DATE = '02.01.2011';
 AUTHOR = 'Wolf (the@BigBadWolF.de), additions by Nitro/NCE';

 SPEED : byte = 2;

 BASS_DRUM_VALUE : byte = 63;
 HIHAT_DRUM_VALUE : byte = 1;
 SNARE_DRUM_VALUE : byte = 47;
// SILENCE_VALUE : byte = 127;	// 63
 
 VERBOSITY : byte = 1;

 HEXPRE : string = '0123456789ABCDEF';

 PERIOD : array[0..12*7-1] of integer = (
{C-1}
3424,3232,3048,2880,2712,2560,2416,2280,2152,2032,1920,1812,
{C-2}
1712,1616,1524,1440,1356,1280,1208,1140,1076,1016,960,906,
{C-3}
856,808,762,720,678,640,604,570,538,508,480,453,
{C-4}
428,404,381,360,339,320,302,285,269,254,240,226,
{C-5}
214,202,190,180,170,160,151,143,135,127,120,113,
{C-6}
107,101,95,90,85,80,75,71,67,63,60,56,
{C-7}
53,50,47,45,42,40,37,35,33,31,30,28
);

 NAME : array[0..12*7-1] of string = (
  'C-1', 'C#1', 'D-1', 'D#1', 'E-1', 'F-1', 'F#1', 'G-1', 'G#1', 'A-1', 'A#1', 'H-1',
  'C-2', 'C#2', 'D-2', 'D#2', 'E-2', 'F-2', 'F#2', 'G-2', 'G#2', 'A-2', 'A#2', 'H-2',
  'C-3', 'C#3', 'D-3', 'D#3', 'E-3', 'F-3', 'F#3', 'G-3', 'G#3', 'A-3', 'A#3', 'H-3',
  'C-4', 'C#4', 'D-4', 'D#4', 'E-4', 'F-4', 'F#4', 'G-4', 'G#4', 'A-4', 'A#4', 'H-4',
  'C-5', 'C#5', 'D-5', 'D#5', 'E-5', 'F-5', 'F#5', 'G-5', 'G#5', 'A-5', 'A#5', 'H-5',
  'C-6', 'C#6', 'D-6', 'D#6', 'E-6', 'F-6', 'F#6', 'G-6', 'G#6', 'A-6', 'A#6', 'H-6',
  'C-7', 'C#7', 'D-7', 'D#7', 'E-7', 'F-7', 'F#7', 'G-7', 'G#7', 'A-7', 'A#7', 'H-7' 
 );
 
 OFFNOTE_VALUE : byte = 84;
 OFFNOTE : string = ( '---' );

// REST_VALUE : byte = 85;

 EFFECT_INFO : array[0..35] of string = (
'Protracker V2.3A/3.01 Effect Commands',
'----------------------------------------------------------------------------',
'0 - Normal play or Arpeggio             0xy : x-first halfnote add, y-second',
'1 - Slide Up                            1xx : upspeed',
'2 - Slide Down                          2xx : downspeed',
'3 - Tone Portamento                     3xx : up/down speed',
'4 - Vibrato                             4xy : x-speed,   y-depth',
'5 - Tone Portamento + Volume Slide      5xy : x-upspeed, y-downspeed',
'6 - Vibrato + Volume Slide              6xy : x-upspeed, y-downspeed',
'7 - Tremolo                             7xy : x-speed,   y-depth',
'8 - NOT USED',
'9 - Set SampleOffset                    9xx : offset (23 -> 2300)',
'A - VolumeSlide                         Axy : x-upspeed, y-downspeed',
'B - Position Jump                       Bxx : songposition',
'C - Set Volume                          Cxx : volume, 00-40',
'D - Pattern Break                       Dxx : break position in next pattern',
'E - E-Commands                          Exy : see below...',
'F - Set Speed                           Fxx : speed (00-1F) / tempo (20-FF)',
'----------------------------------------------------------------------------',
'E0- Set Filter                          E0x : 0-filter on, 1-filter off',
'E1- FineSlide Up                        E1x : value',
'E2- FineSlide Down                      E2x : value',
'E3- Glissando Control                   E3x : 0-off, 1-on (use with tonep.)',
'E4- Set Vibrato Waveform                E4x : 0-sine, 1-ramp down, 2-square',
'E5- Set Loop                            E5x : set loop point',
'E6- Jump to Loop                        E6x : jump to loop, play x times',
'E7- Set Tremolo Waveform                E7x : 0-sine, 1-ramp down. 2-square',
'E8- NOT USED',
'E9- Retrig Note                         E9x : retrig from note + x vblanks',
'EA- Fine VolumeSlide Up                 EAx : add x to volume',
'EB- Fine VolumeSlide Down               EBx : subtract x from volume',
'EC- NoteCut                             ECx : cut from note + x vblanks',
'ED- NoteDelay                           EDx : delay note x vblanks',
'EE- PatternDelay                        EEx : delay pattern x notes',
'EF- Invert Loop                         EFx : speed',
'----------------------------------------------------------------------------');

VAR
 pattern : array[0..127] of pattern_type;
 sample : array[1..31] of sample_type;
 songlength : byte;
 songname : string;
 trackerID : string[4];
 inModName : string;
 outTxtName : string;
 outC64File : string;
 pattern_position : array[0..127] of byte;
 pattern_number : byte;
 loop_position : byte;


FUNCTION hex(input:byte):string[2];
BEGIN
 hex := copy(HEXPRE, (input shr 4)+1, 1);
 hex := hex+copy(HEXPRE, (input and 15)+1, 1);
END;

FUNCTION hexShort(input:byte):string[1];
BEGIN
 hexShort := copy(HEXPRE, (input and 15)+1, 1);
END;

PROCEDURE show_message;
BEGIN
 writeln(PROGNAME+' v'+VERSION+' - '+_DATE+' by '+AUTHOR);
 writeln();

 if (paramcount <> 1) then begin
  writeln('Parameters: <4trackmodfile.mod>');
  halt(1);
 end;
END;

FUNCTION findNote(period_in:integer):byte;
var
 a:integer;
BEGIN
 findNote := OFFNOTE_VALUE;
 for a := 0 to (12*7-1) do
  if (period_in = PERIOD[a]) then findNote := a-7;
END;

PROCEDURE findPatternNumber;
var
 a:integer;
BEGIN
 pattern_number := 0;
 for a:= 0 to songlength do begin
  if (pattern_position[a]>pattern_number) then pattern_number := pattern_position[a]; 
 end;
END;





PROCEDURE readMod(fileName:string);
var
 a:file;
 data: array[0..3] of byte;
 c,d,e,f:integer;
 swapChar : char;
 
BEGIN
 songName := '';
 writeln('Reading file "'+fileName+'"');
 assign(a,fileName); reset(a,1);

 {reading out songName}
 if (VERBOSITY>0) then writeln(' Reading songName...');
 for c := 1 to 20 do begin
  if not eof(a) then blockread(a,swapChar,1);
  if (swapChar <> #0) then songName := songName + swapChar;
 end;

 if (VERBOSITY>0) then writeln(' Reading Samples...');
 {reading samples}
 for c := 1 to 31 do begin

  sample[c].name := '';
  for d := 1 to 22 do begin
   if not eof(a) then blockread(a,swapChar,1);
   if (swapChar <> #0) then sample[c].name := sample[c].name + swapChar;
  end;
  
  blockread(a,data[0],1);
  blockread(a,data[1],1);
  sample[c].length := (data[0]*256+data[1]) * 2;
  
  blockread(a,sample[c].finetune,1);
  sample[c].finetune := sample[c].finetune or 15;

  blockread(a,sample[c].volume,1);
  
  blockread(a,data[0],1);
  blockread(a,data[1],1);
  sample[c].repeat_pos := (data[0]*256+data[1]) * 2;

  blockread(a,data[0],1);
  blockread(a,data[1],1);
  sample[c].repeat_length := (data[0]*256+data[1]) * 2;
 end;

 //songlength
 if (VERBOSITY>0) then writeln(' Reading songLength...');
 if not eof(a) then blockread(a,songlength,1);

 if not eof(a) then blockread(a,data,1);

 // pattern position table
 if (VERBOSITY>0) then writeln(' Reading Pattern Position Table...');
 for c := 0 to 127 do
  if not eof(a) then blockread(a,pattern_position[c],1);
  
 findPatternNumber();

 // "4chn"
 if (VERBOSITY>0) then writeln(' Reading Tracker-ID string...');
 trackerID := '';
 for d := 1 to 4 do begin
  if not eof(a) then blockread(a,swapChar,1);
  if (swapChar <> #0) then trackerID := trackerID + swapChar;
 end;
 
 loop_position := 0;

 if (VERBOSITY>0) then writeln(' Reading Patterns...');
 for f := 0 to pattern_number do begin
 if (VERBOSITY>1) then write('  Pattern ',f:2,': ');
 for c := 0 to 63 do begin
  if (VERBOSITY>1) then write('.');
  for d := 0 to 3 do begin
   for e := 0 to 3 do
    if not eof(a) then blockread(a,data[e],1);

   pattern[f].voice[d].tone[c].instrument := (data[0] and 240) or (data[2] shr 4);  
   pattern[f].voice[d].tone[c].period := ((data[0] and 15)shl 8) or data[1]; 
   pattern[f].voice[d].tone[c].note := findNote(pattern[f].voice[d].tone[c].period);  
   pattern[f].voice[d].tone[c].effect1 := data[2] and 15;  
   pattern[f].voice[d].tone[c].effect2 := data[3] shr 4;  
   pattern[f].voice[d].tone[c].effect3 := data[3] and 15;
   
   // check loop position
   if (pattern[f].voice[d].tone[c].effect1 = 11) then begin
    if (loop_position <> 0) then writeln(' >> Caution: More than one loop found in modfile, so I am taking the last one.');
    loop_position := data[3];
   end;

  end;
 end;
  if (VERBOSITY>1) then writeln();
 end;
 
 close(a);
 if (VERBOSITY>0) then writeln('done.');
 if (VERBOSITY>0) then writeln();
END;


PROCEDURE findUsedPatterns;
var
 e,c:integer;
BEGIN
 for e := 0 to pattern_number do begin
  pattern[e].used:=false;
  for c := 0 to songlength-1 do
   if (e=pattern_position[c]) then pattern[e].used:=true
 end;
END;




PROCEDURE writeModInfo(fileName:string);
var
 a:text;
 c,d,e:integer;
 swap_note:string;
BEGIN
 writeln('Writing file "'+fileName+'"');
 assign(a,fileName); rewrite(a);

 if (VERBOSITY>0) then writeln(' Writing header...');
 writeln(a,PROGNAME+' v'+VERSION+' - '+_DATE+' by '+AUTHOR);
 writeln(a,'');
 if (VERBOSITY>0) then writeln(' Writing SongName...');
 writeln(a,'SongName: "'+songname+'"');
 writeln(a,'');
 if (VERBOSITY>0) then writeln(' Writing TrackerID...');
 writeln(a,'TrackerID: "'+trackerID+'"');
 writeln(a,'');
 writeln(a,'');

 if (VERBOSITY>0) then writeln(' Writing Sample Information...');
 writeln(a,'Samples:');
 writeln(a,'');
 for c := 1 to 31 do if ((sample[c].length > 0) or (sample[c].name <> '')) then begin
  write(a,'Sample '+hex(c)+': ');
  writeln(a,'"'+sample[c].name+'"');
  write(a,'Length: ',sample[c].length,' bytes - ');
  write(a,'Finetune: $'+hex(sample[c].finetune)+' - ');
  writeln(a,'Volume: $'+hex(sample[c].volume));
  write(a,'Repeat position: ',sample[c].repeat_pos,' bytes - ');
  writeln(a,'Repeat length: ',sample[c].repeat_length,' bytes');
  writeln(a,'');
 end;
 writeln(a,'');
 writeln(a,'');

 if (VERBOSITY>0) then writeln(' Writing SongLength...');
 writeln(a,'Songlength: $'+hex(songlength)+' pattern positions');
 writeln(a,'Finally, song jumps to pattern position: $'+hex(loop_position));
 writeln(a,'');

 if (VERBOSITY>0) then writeln(' Writing Pattern Position Table...');
 writeln(a,'Pattern Position Table:');
 for c := 0 to songlength-1 do
  writeln(a,hex(c)+' '+hex(pattern_position[c]));
 writeln(a,'');
 writeln(a,'');

 if (VERBOSITY>0) then writeln(' Writing Patterns...');
 for e := 0 to pattern_number do if (pattern[e].used) then begin
  writeln(a,'Pattern '+hex(e));
  writeln(a,'');
  if (VERBOSITY>1) then write('  Pattern '+hex(e)+': ');
 for c := 0 to 63 do begin
  write(a,hex(c)+': ');
 for d := 0 to 3 do begin
  
  if (pattern[e].voice[d].tone[c].note <> OFFNOTE_VALUE) then
   swap_note := NAME[pattern[e].voice[d].tone[c].note]
  else
   swap_note := OFFNOTE;
  write(a,swap_note+' ');
  
  if (pattern[e].voice[d].tone[c].instrument>0) then
   write(a,hex(pattern[e].voice[d].tone[c].instrument)+' ')
  else
   write(a,'   ');
  
  write(a,hexShort(pattern[e].voice[d].tone[c].effect1));
  write(a,hexShort(pattern[e].voice[d].tone[c].effect2));
  write(a,hexShort(pattern[e].voice[d].tone[c].effect3));
  write(a,'   ');
 end;
  writeln(a,'');
  if (VERBOSITY>1) then write('.');
 end;
  if (VERBOSITY>1) then writeln;
  writeln(a,'');
  writeln(a,'');
 end;

 if (VERBOSITY>0) then writeln(' Writing Protracker Effect Information...');
 for e := 0 to 35 do writeln(a,EFFECT_INFO[e]);
 writeln(a,'');
 writeln(a,'');

 close(a);
 if (VERBOSITY>0) then writeln('done.');
 if (VERBOSITY>0) then writeln();
END;




PROCEDURE writePattern(var a:text);
var
 c,d,e:integer;
 data:byte;
BEGIN
 writeln('Writing section "Patterns"');

 writeln(a,';--- music data [created with '+PROGNAME+' v'+VERSION+' - '+_DATE+' by '+AUTHOR+'] ---');
 writeln(a);

 if (VERBOSITY>0) then writeln(' Writing Pattern Position Table...');
 writeln(a,'SIL	equ	$3f');
 writeln(a);
 writeln(a,'songLength	equ	$'+hex(songlength));
 writeln(a,'loopPosition	equ	$'+hex(loop_position));
 writeln(a);
 
 writeln(a,';;;;;;;;;;   Pattern  ; Part');
 writeln(a,'script:');
 for c := 0 to songlength-1 do
  writeln(a,'  fdb pattern'+hex(pattern_position[c])+', part1, init_part1');
 writeln(a);

 if (VERBOSITY>0) then writeln(' Writing Patterns...');
 for e := 0 to pattern_number do if (pattern[e].used) then begin
  writeln(a,'pattern'+hex(e)+':');
  writeln(a,'  fdb adsr');
  writeln(a,'  fdb twang');
  writeln(a);
  for c := 0 to 63 do begin
   write(a,'  fcb ');


 // if no note at this position, set SIL
    if (
    	(pattern[e].voice[0].tone[c].note = offnote_value) and
    	(pattern[e].voice[1].tone[c].note = offnote_value) and
    	(pattern[e].voice[2].tone[c].note = offnote_value)
	) then	write(a,'SIL,');	// SIL

   for d := 0 to 2 do begin	// first three voices 0-2

// set speed (from Martin)
    data := pattern[e].voice[d].tone[c].effect1;
    if ((data=15) and (pattern[e].voice[d].tone[c].effect2<2)) then begin
     if (VERBOSITY>0) then writeln('Setting speed to '+hex(pattern[e].voice[d].tone[c].effect2*16+pattern[e].voice[d].tone[c].effect3));
     SPEED := pattern[e].voice[d].tone[c].effect2*16+pattern[e].voice[d].tone[c].effect3;
    end;


    data := pattern[e].voice[d].tone[c].note;

    if (data<(2*12)) then writeln(#7,'*** Attention: Pattern $'+hex(e)+' Voice $'+hex(d)+' Position $'+hex(c)+' is too low! ***')
    else dec(data,(2*12));	// lower tone by 3 octaves

// drums: bass drum (instrument 0)
    if (pattern[e].voice[d].tone[c].instrument = 1) then data := BASS_DRUM_VALUE or 64;	// set bit 6 (effect)
// drums: hihat drum (instrument 1)
    if (pattern[e].voice[d].tone[c].instrument = 2) then data := HIHAT_DRUM_VALUE or 64;	// set bit 6 (effect)
// drums: snare drum (instrument 2)
    if (pattern[e].voice[d].tone[c].instrument = 3) then data := SNARE_DRUM_VALUE or 64;	// set bit 6 (effect)

// silence (instrument 3)
//    if (pattern[e].voice[d].tone[c].instrument = 4) then 
     //data := SILENCE_VALUE or 64;	// set bit 6 (effect)
//     data := SILENCE_VALUE;	// set bit 6 (effect)

 // mark tone with bit 7 if another voice follows
    if (
    	(d<2) and
	(pattern[e].voice[d+1].tone[c].note <> offnote_value)
    ) then data := data or 128;	// set bit 7

    if (
    	(d=0) and
	(pattern[e].voice[d+2].tone[c].note <> offnote_value)
    ) then data := data or 128;	// set bit 7

    if (pattern[e].voice[d].tone[c].note <> offnote_value
    ) then write(a,'$'+hex(data)+', ')
    else write(a,'     ')

   end;
    
   writeln(a,'$'+hex(SPEED)+' ; $'+hex(c));
  end;
  writeln(a,' fcb $00, $80 ; end-marker');
  writeln(a);
  if (VERBOSITY>1) then writeln();
 end;

 if (VERBOSITY>0) then writeln('done.');
 if (VERBOSITY>0) then writeln();
END;




PROCEDURE write(fileName:string);
CONST
 header : array[0..1] of byte = (00,17);
 header_string = '$1100';

var
 a:text;
BEGIN
 writeln('Writing file "'+fileName+'" beginning from '+header_string);
 writeln();
 assign(a,fileName); rewrite(a);

// countC64Effects;

// writeC64Starts(a);
 writePattern(a);
// writeC64Effects(a);
// writeC64Header(a);
// writeC64JumpTable(a);

 close(a);

 writeln('The first three channels of the mod file have been converted (0-2).');
 writeln('Every voice in a pattern has the length of $40 bytes.');
 writeln('Every pattern is 3x$40 bytes = $c0 bytes long.');
// writeln('Offnotes have the value of ',OFFNOTE_VALUE,'.');
 writeln();
 writeln('Speed is set to $'+hex(SPEED)+'.');
 writeln();
 writeln('Instrument 1 is a bass drum and gets value $'+hex(BASS_DRUM_VALUE)+'.');
 writeln('Instrument 2 is a hihat drum and gets value $'+hex(HIHAT_DRUM_VALUE)+'.');
 writeln('Instrument 3 is a snare drum and gets value $'+hex(SNARE_DRUM_VALUE)+'.');
 writeln();
// writeln('Instrument 4 makes Vectrex Soundchip silent (value $'+hex(SILENCE_VALUE)+').');
 writeln();
 writeln('Lowest note should be G-2.');
 writeln();
END;




BEGIN
 textcolor(white);
 show_message();
 inModName := paramstr(1);
 outTxtName := copy(inModName,1,length(inModName)-3)+'txt';
 outC64File := copy(inModName,1,length(inModName)-3)+'asm';

 readMod(paramstr(1));
 findUsedPatterns();
 writeModInfo(outTxtName);
 write(outC64File);
// writeSamples(inModName);
END.
