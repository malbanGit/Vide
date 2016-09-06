(* RANDOM.PAS *)

  Function Random(Var Ranseed: Integer): Real;

  { This random number function is from "Pascal News", issue number 12
    (June, 1978), page 18.  It is PUG algorithm A-1,
    by Brian A. E. Meekings of the University of Lancaster.
    Some modifications suggested by Jim Miner, Social Science
    Research Facilities Center, University of Minnesota, have
    been made to the original algorithm. }

  Const
    pshift = 2048 { 2^11 };
    pmod = 16  { 2^4 };
    qshift = 16 { 2^4 };
    Maxint = 32767 { 2^15 - 1 };

  Type
    Bitset = set of 0..15;

  Var
    a, b: Record
            Case Boolean of
              True: (i: Integer);
              False: (s: Bitset)
            end;

  Begin { Random }
    a.i := RanSeed;
    b.i := a.i Div qshift;
    a.s := (a.s - b.s) + (b.s - a.s);
    b.i := a.i Mod pmod * pshift;
    a.s := (a.s - b.s) + (b.s - a.s);
    RanSeed := a.i;
    Random := (a.i - 1) / Maxint
  End { Random };
