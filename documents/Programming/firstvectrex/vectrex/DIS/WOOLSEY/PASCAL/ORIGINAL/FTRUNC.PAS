
function ftrunc(x: real): real;
        {removes the "fractional part" of x in a reasonably standard
        and machine independant way.  This is done by using the limited
        resolution of floating point numbers--you add to x a number so
        big that the fractional part of x must be thrown away.  This
        assumes that the floating point representation contains such a
        number, and that the radix of the exponent is some power of 2.
        Unfortunately, some machines just throw the fractional part
        away, but other machines use it for rounding.  Still other
        machines round for some fractional parts of .5 and truncate for
        the others.  This version tries to detect rounding after the
        fact and correct for it.  THERE MAY BE STRANGE FLOATING POINT
        REPRESENTATIONS FOR WHICH THIS FAILS.
                x must not be negative.  In a real program, big would
        be global and its value would be calculated only once.
        }
var big, y: real;
begin
        {find the smallest number big such that big + 0.4 = big}

        big:= 1.0;
        while (big + 0.5 > big) and (big + 0.5 < big + 1.0) do
           big:= big * 2.0;

  if x >= big then
    ftrunc := x         {x has no "fractional part"}
  else
    begin
      y := x + big;     {This is done in separate assignments to help ensure
                        evaluation order.  Beware of optimisers!}
      y := y - big;
      if y > x then
        ftrunc := y - 1.0       {rounding}
      else ftrunc := y          {no rounding}
    end
end;    {ftrunc}
