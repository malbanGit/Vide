/* PR middle-end/40204 */

#ifdef __m6809__
#define B_SIZE 12
#else
#define B_SIZE 28
#endif

struct S
{
  unsigned int a : 4;
  unsigned int b : B_SIZE;
} s;
char c;

void
f (void)
{
  s.a = (c >> 4) & ~(1 << 4);
}
