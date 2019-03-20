#ifdef __m6809__
#define SMALL 100000LL
#define LARGE 1000000LL
#else
#define SMALL 10000000000LL
#define LARGE 100000000000LL
#endif

long long
f (long long x)
{
  return x / SMALL;
}

main ()
{
  if (f (SMALL) != 1 || f (LARGE) != 10)
    abort ();
  exit (0);
}
