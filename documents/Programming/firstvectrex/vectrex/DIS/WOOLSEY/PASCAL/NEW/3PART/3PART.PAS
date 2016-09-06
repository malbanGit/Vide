program threepart;

(* kludge resulting from converting BASIC program to a file of PLAY strings. *)

type
  twine = string[80];

var
  title: twine; g: text;

  reply, i: integer;
  A5,  B5, C5: array[0 .. 3] of twine;
  A10, B10, C10: array[0 .. 2] of twine;
  m3, m2, m1, m: twine;
  aa, bb, cc: twine;
  a0, b0, c0: twine;
  a1, b1, c1: twine;
  a2, b2, c2: twine;
  a3, b3, c3: twine;
  a4, b4, c4: twine;
  a6, b6, c6: twine;
  a7, b7, c7: twine;
  a8, b8, c8: twine;
  a9, b9, c9: twine;

procedure g260;

begin
(*
 -----------------------
|     Menu Entries      |
 -----------------------
 *)
  writeln(' SCOTT JOPLIN ');
  writeln('The Entertainer . . 1');
  writeln('Maple Leaf Rag  . . 2');
  writeln('Peacherine Rag  . . 3');
  writeln('TERMINATE . . . . . 4');
end;

(*$I joplin.inc *)

procedure g590;

var i: integer;

procedure music(v1, v2, v3: twine; sghdf, sdfhjg: byte);

begin { music }
  writeln(g, v3);
end;

begin { g 590 }
 (*
  -----------------------
 |      Play Music       |
  -----------------------
 *)
 MUSIC(M1,M2,M3,0,1);
 MUSIC(A0,B0,C0,0,1);
 FOR I:=1 TO 2 do begin
    MUSIC(A1,B1,C1,0,1);
    MUSIC(A2,B2,C2,0,1);
    MUSIC(A3,B3,C3,0,1);
    MUSIC(A4,B4,C4,0,1);
    MUSIC(A5[I],B5[I],C5[I],0,1)
end;
 FOR I:=1 TO 2 do begin
    MUSIC(A6,B6,C6,0,1);
    MUSIC(A7,B7,C7,0,1);
    MUSIC(A8,B8,C8,0,1);
    MUSIC(A9,B9,C9,0,1);
    MUSIC(A10[I],B10[I],C10[I],0,1);
 end;
 MUSIC(A1,B1,C1,0,1);
 MUSIC(A2,B2,C2,0,1);
 MUSIC(A3,B3,C3,0,1);
 MUSIC(A4,B4,C4,0,1);
 MUSIC(A5[3],B5[3],C5[3],0,1);
end;

begin
  assign(g, 'PEACH3.TUN'); rewrite(g); (* malban was 'B:...' *)
 g260;
 reply := 3;
  case reply of 1:gosub890;2:gosub1360;3:gosub1800 end;
  g590;
 close(g)
end.
