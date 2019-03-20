/* { dg-do run } */
/* { dg-options "-save-temps" } */
/* { dg-final { scan-assembler "exg" } } */

extern void abort (void);

unsigned long swap32 (unsigned long x)
{
	return __builtin_bswap32 (x);
}

int main ()
{
	if (swap32 (0x6789ABCDUL) != 0xCDAB8967UL)
		abort ();
	return 0;
}

/* vim: set noexpandtab: */
/* vim: set ts=8: */
