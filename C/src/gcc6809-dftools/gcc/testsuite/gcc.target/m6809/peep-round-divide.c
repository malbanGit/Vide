/* { dg-do run } */
/* { dg-options "-O2 -save-temps" } */
/* { dg-final { scan-assembler "lsrb" } } */
/* { dg-final { scan-assembler "adcb" } } */

extern void abort (void);

unsigned char f (unsigned char x)
{
	return (x+1) / 2;
}

int main ()
{
	if (f(9) != 5) abort ();
	return 0;
}

/* vim: set noexpandtab: */
/* vim: set ts=8: */
