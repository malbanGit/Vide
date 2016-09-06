(*$A- *)

program plotter;

const
  debug = false;
  magic = 256 { largest power of two <= smallest display dimension } ;

var
   lines, o: integer;
   escape, C: char;
   I, H, X, Y, X0, Y0, N, LASTX, LASTY: INTEGER;

(*$IVECDRAW *)

   PROCEDURE PLOT;

   BEGIN { Plot }
      LINES := LINES + 1;
      if lines mod 8 = 0 then clrseg;
      DRAWLINE(LASTX, LASTY, X - LASTX, Y - LASTY, 1);
      LASTX := X; LASTY := Y
   END { Plot };


   PROCEDURE MOVE(x, y: integer);

   BEGIN { Move }
      LASTX := X; LASTY := Y
   END { Move };

procedure Hilbert(Order: integer);

const
   h0 = magic;

   procedure B(i: integer);
      forward;

   procedure C(i: integer);
      forward;

   procedure D(i: integer);
      forward;

   procedure A(i: integer);

   begin
      if i > 0 then
         begin
            D(i - 1); x := x - h; Plot;
            A(i - 1); y := y - h; Plot;
            A(i - 1); x := x + h; Plot;
            B(i - 1)
         end;
   end {A};

   procedure B { i : integer };

   begin
      if i > 0 then
         begin
            C(i - 1); y := y + h; Plot;
            B(i - 1); x := x + h; Plot;
            B(i - 1); y := y - h; Plot;
            A(i - 1)
         end;
   end {B};

   procedure C { i : integer };

   begin
      if i > 0 then
         begin
            B(i - 1); x := x + h; Plot;
            C(i - 1); y := y + h; Plot;
            C(i - 1); x := x - h; Plot;
            D(i - 1)
         end;
   end {C};

   procedure D { i : integer };

   begin
      if i > 0 then
         begin
            A(i - 1); y := y - h; Plot;
            D(i - 1); x := x - h; Plot;
            D(i - 1); y := y + h; Plot;
            C(i - 1)
         end;
   end {D};

   begin { Hilbert }
      i := 0; h := h0;
      x0 := h div 2; y0 := h div 2;
      repeat
         i := i + 1; h := h div 2;
         x0 := x0 + (h div 2); y0 := y0 + (h div 2);
         x := x0; y := y0;
      until i = Order;
      move(x, y); A(i);
   end {Hilbert};

procedure sierpinsky(Order: integer);

const
   h0 = magic;

   procedure B(i: integer);
      forward;

   procedure C(i: integer);
      forward;

   procedure D(i: integer);
      forward;

   procedure A(i: integer);

   begin
      if i > 0 then
         begin
            A(i - 1); x := x + h; y := y - h; Plot;
            B(i - 1); x := x + 2 * h; Plot;
            D(i - 1); x := x + h; y := y + h; Plot;
            A(i - 1)
         end;
   end {A};

   procedure B { i : integer };

   begin
      if i > 0 then
         begin
            B(i - 1); x := x - h; y := y - h; Plot;
            C(i - 1); y := y - 2 * h; Plot;
            A(i - 1); x := x + h; y := y - h; Plot;
            B(i - 1)
         end;
   end {B};

   procedure C { i : integer };

   begin { C }
      if i > 0 then
         begin
            C(i - 1); x := x - h; y := y + h; Plot;
            D(i - 1); x := x - 2 * h; Plot;
            B(i - 1); x := x - h; y := y - h; Plot;
            C(i - 1)
         end;
   end {C};

   procedure D { i : integer };

   begin
      if i > 0 then
         begin
            D(i - 1); x := x + h; y := y + h; Plot;
            A(i - 1); y := y + 2 * h; Plot;
            C(i - 1); x := x - h; y := y + h; Plot;
            D(i - 1)
         end;
   end {D};

   begin { sierpinsky }
      i := 0;
      h := h0 div 4;
      x0 := 2 * h; y0 := 3 * h;
      repeat
         i := i + 1; x0 := x0 - h;
         h := h div 2; y0 := y0 + h;
         x := x0; y := y0
      until i = Order;
      move(x, y);
      A(i); x := x + h; y := y - h; Plot;
      B(i); x := x - h; y := y - h; Plot;
      C(i); x := x - h; y := y + h; Plot;
      D(i); x := x + h; y := y + h; Plot
   end {sierpinsky};

begin { plotter }
   Escape := 'Q';
   header;
   repeat
      repeat
         Write(chr(14), 'Hilbert or Sierpinsky? ');
         Read(C);
         case C of
            'H': Write('ilbert');
            'S': Write('ierpinsky')
         end;
         WriteLn
      until C in [ 'H', 'S', Escape ];
      if C <> Escape then
         begin { doit }
            Write('Order? ');
            ReadLn(o);
            clrvec; lines := 0;
            case C of
               'H': Hilbert(o);
               'S': Sierpinsky(o)
            end
         end
   until C = Escape
end { Plotter }.

