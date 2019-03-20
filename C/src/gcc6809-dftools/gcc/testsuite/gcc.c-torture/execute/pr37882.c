/* PR middle-end/37882 */

struct S
{
#ifdef __m6809__
  int a : 12;
#else
  int a : 21;
#endif
  unsigned char b : 3;
} s;

int
main ()
{
  s.b = 4;
  if (s.b > 0 && s.b < 4)
    __builtin_abort ();
  return 0;
}
