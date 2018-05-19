# 1 "source\\mc6809.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\mc6809.c"
# 16 "source\\mc6809.c"
# 1 "include/mc6809.h" 1
# 16 "include/mc6809.h"
       



struct mc6809_t
{
 union
 {
  struct {
   unsigned int A;
   unsigned int B;
  };
  long unsigned int D;
 };
 long unsigned int X;
 long unsigned int Y;
 long unsigned int U;
};


extern struct mc6809_t _mc6809;
# 17 "source\\mc6809.c" 2




struct mc6809_t _mc6809 =
{
 { .D = 0L },
 .X = 0L,
 .Y = 0L,
 .U = 0L
};
