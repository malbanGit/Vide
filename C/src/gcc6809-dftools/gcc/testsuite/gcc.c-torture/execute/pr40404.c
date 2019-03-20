extern void abort (void);
struct S {
#ifdef __m6809__
  unsigned long ui17 : 17;
#else
  unsigned int ui17 : 17;
#endif
} s;
int main()
{
  s.ui17 = 0x1ffff;
  if (s.ui17 >= 0xfffffffeu)
    abort ();
  return 0;
}

