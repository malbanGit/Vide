void *volatile p;

int
main (void)
{
  int n = 0;
lab:;
    {
      int x[n % 1000 + 1];
      x[0] = 1;
      x[n % 1000] = 2;
      p = x;
      n++;
    }

    {
      int x[n % 1000 + 1];
      x[0] = 1;
      x[n % 1000] = 2;
      p = x;
      n++;
    }

#ifdef __m6809__
  if (n < 1000)
#else
  if (n < 1000000)
#endif
    goto lab;

  return 0;
}
