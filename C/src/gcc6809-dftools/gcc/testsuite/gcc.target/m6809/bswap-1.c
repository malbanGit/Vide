/* { dg-do run } */
/* { dg-options "-save-temps" } */
/* { dg-final { scan-assembler "exg" } } */

extern void abort (void);

unsigned int swap16 (unsigned int x)
{
	return __builtin_bswap16 (x);
}

int main ()
{
	if (swap16 (0xABCD) != 0xCDAB)
		abort ();
	return 0;
}

/* vim: set noexpandtab: */
/* vim: set ts=8: */
