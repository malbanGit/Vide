
  procedure instr(mnemonic: ch5);

  const
    start = 2;

  var
    i: nybble;
    break: boolean;
    destination: real;
    z: integer;
    fred: byte;
    reference: addrkind;
    d: 1 .. 5;

    procedure relate;

    var
      displacement: real;
      fred: byte;

    begin
      write('R');
      fred := getbyte;
      if fred > 127
      then
        displacement := fred - 256
      else
        displacement := fred + 0;
      destination := address + displacement;
    end;

    procedure longrelate;

    var
      displacement: real;
      fred: byte;

      begin
        write('L');
        fred:= getbyte;
        if fred > 127 then displacement := fred - 256
                      else displacement := fred + 0;
        destination := address + 256.0 * displacement + 1.0 * getbyte + 1
        { we call getbyte twice! }
      end { longrelate };

    procedure index;

    type
      this2that = record case boolean of
                      false: (int: byte);
                      true: (bits: set of 0 .. 7)
                  end;

    var
      postbyte: this2that;
      register: 0 .. 3;
      trash: integer;

      procedure comma; begin write(ginger, ',') end;
      procedure plus; begin write(ginger, '+') end;
      procedure minus; begin write(ginger, '-') end;
      procedure left; begin write(ginger, '[') end;
      procedure right; begin write(ginger, ']') end;
      procedure a; begin write(ginger, 'A') end;
      procedure b; begin write(ginger, 'B') end;
      procedure d; begin write(ginger, 'D') end;
      procedure p; begin write(ginger, 'PCR') end;

      procedure r;

      begin
        case register of
          0: write(ginger, 'X');
          1: write(ginger, 'Y');
          2: write(ginger, 'U');
          3: write(ginger, 'S')
        end
      end { reg } ;

      procedure n;

      var z: byte;
          p: integer;

      begin
        z := getbyte;
        if z > 127 then p := z - 256 else p := z;
        write(ginger, p: 1)
      end { n } ;

      procedure en;

      var z: byte;
          p: real;

      begin
        relate;
        case refer(destination) of
          jump:          write(ginger, instlabel);
          broad, narrow: write(ginger, datalabel)
        else
          write(ginger, nolabel);
        end { case refer };
        wordout(destination)
      end { en } ;

      procedure m;

      begin
        write(ginger, nolabel);
        convert(getbyte);
        convert(getbyte)
      end { m };

      procedure em;

      begin
        longrelate;
        case refer(destination) of
          jump:          write(ginger, instlabel);
          broad, narrow: write(ginger, datalabel)
        else
          write(ginger, nolabel);
        end { case refer };
        wordout(destination)
      end { em };

    begin (* index *)
      postbyte.int := fred;
      register := (postbyte.int div 32) mod 4;
      trash := postbyte.int mod 32;
      if not (7 in postbyte.bits)
      then
        begin
          if trash > 15 then trash := trash - 32;
          write(ginger, trash: 1, ',');
          r
        end
      else
        begin
          case trash of
            0: begin comma; r; plus end;
            1: begin comma; r; plus; plus end;
            2: begin comma; minus; r end;
            3: begin comma; minus; minus; r end;
            4: begin comma; r end;
            5: begin b; comma; r end;
            6: begin a; comma; r end;
            7: ;
            8: begin n; comma; r end;
            9: begin m; comma; r end;
            10: ;
            11: begin d; comma; r end;
            12: begin en; comma; p end;
            13: begin em; comma; p end;
            14: ;
            15: ;
            16: { N/A } ;
            17: begin left; comma; r; plus; plus; right end;
            18: { N/A } ;
            19: begin left; comma; minus; minus; r; right end;
            20: begin left; comma; r; right end;
            21: begin left; b; comma; r; right end;
            22: begin left; a; comma; r; right end;
            23: ;
            24: begin left; n; comma; r; right end;
            25: begin left; m; comma; r; right end;
            26: ;
            27: begin left; d; comma; r; right end;
            28: begin left; en; comma; p; right end;
            29: begin left; em; comma; p; right end;
            30: ;
            31: begin left; m; right end
          end { case }
        end { if 7 };
    end (* index *);

    procedure spec;

    var
      upper, lower: nybble;
      pull, first, user: boolean;
      mask, i: byte;

      procedure reg(z: nybble);

      begin
        case z of
          0: write(ginger, 'D');
          1: write(ginger, 'X');
          2: write(ginger, 'Y');
          3: write(ginger, 'U');
          4: write(ginger, 'S');
          5: write(ginger, 'PC');
          8: write(ginger, 'A');
          9: write(ginger, 'B');
          10: write(ginger, 'CCR');
          11: write(ginger, 'DP')
        end { case }
      end;

    begin { spec }
      case x of
        30, 31: (* EXG, TFR *)
          begin
            x := getbyte;
            lower := x mod sixteen;
            upper := x div sixteen;
            reg(upper);
            write(ginger, ',');
            reg(lower);
          end;
        52, 53, 54, 55: (* PSHS, PULS, PSHU, PULU *)
          begin
            user := x in [54, 55];
            pull := x in [53, 55];
            x := getbyte;
            mask := 1;
            first := true;
            for i := 0 to 7 do
              begin
                if x and mask <> 0
                then
                  begin
                    if not first
                    then
                      write(ginger, ',');
                    first := false;
                    case i of
                      0: write(ginger, 'CCR');
                      1: write(ginger, 'A');
                      2: write(ginger, 'B');
                      3: write(ginger, 'DP');
                      4: write(ginger, 'X');
                      5: write(ginger, 'Y');
                      6: if user then write(ginger, 'S')
                                 else write(ginger, 'U');
                      7: begin
                           write(ginger, 'PC');
                           break := pull; { if effective return }
                         end
                    end { case i }
                  end { if mask };
                mask := mask + mask
              end { for }
            end { 52, 53, 54, 55 }
      end { case }
    end { spec } ;

  procedure comments { provide additional aids to disassembly } ;

  var
    i, x: nybble;

  begin
    write(ginger, tab, tab); wordout(spot);
    write(ginger, ' (', ftrunc(spot): 1: 0, ')', tab);
    if mode <> data then
    for i := 1 to pilesize do
    begin
      x := pile[i];
      if i > 1 then write(ginger, ',');
      write(ginger, '$');
      convert(x)
    end;
    write(ginger, tab, '''');
    for i := 1 to pilesize do
      if chr(pile[i]) in [' ' .. '~']
      then write(ginger, chr(pile[i]))
      else write(ginger, '.');
    write(ginger, '''')
  end;

  begin (* instr *)
    branch := branch or (mode in [relative, longrelative]);
    if branch
    then reference := jump
    else if mode in [long, short, inherent, data, indexed, special]
         then reference := none
         else if wide
              then reference := broad
              else reference := narrow;
    break := x in flow;
    destination := 0;
    if mode = relative
    then relate
    else if mode = longrelative
         then longrelate
         else if mode <> special then
              for i := start to size[mode] do
              begin
                fred := getbyte;
                if fred = 0 then write('z');
                destination := 256.0 * destination + (fred * 1.0)
              end;
    if destination = 0.0 then write('Z');
    case pass of
      1: note(destination, reference);
      2: begin
           write(ginger, tab);
           for d := 1 to 5 do if mnemonic[d] <> ' ' then
             write(ginger, mnemonic[d]);
           write(ginger, tab);
           case mode of
             direct:
               begin
                 write(ginger, nolabel);
                 convert(trunc(destination + 0.5))
               end;
             short:
               begin
                 write(ginger, immedlabel, nolabel);
                 convert(trunc(destination + 0.5))
               end;
             long:
               begin
                 write(ginger, immedlabel, nolabel);
                 wordout(destination)
               end;
             data:
               begin write(ginger, nolabel); convert(x) end;
             extended, relative, longrelative:
               begin
                 case refer(destination) of
                   jump:          write(ginger, instlabel);
                   broad, narrow: write(ginger, datalabel)
                 else
                   write(ginger, nolabel);
                 end { case refer };
                 wordout(destination)
               end { extended, relative } ;
             indexed: index;
             special: spec
           end (* case mode *);
           if extensive or (mode = data) then comments;
           writeln(ginger);
           if break and not inrange(bytes)
           then
             begin
               writeln(ginger);
               if refer(address) <> jump
               then
                 writeln(ginger, '*', tab, '>> No execution path to here! <<')
             end { if break }
         end (* 2 *)
    end (* case pass *)
  end { instr } ;
