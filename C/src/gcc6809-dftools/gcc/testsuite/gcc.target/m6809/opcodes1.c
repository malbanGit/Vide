/* { dg-do run } */
/* { dg-options "-save-temps" } */
/* { dg-final { scan-assembler "swi" } } */
/* { dg-final { scan-assembler "swi2" } } */
/* { dg-final { scan-assembler "swi3" } } */
/* { dg-final { scan-assembler "nop" } } */

extern void abort (void);

int main ()
{
	__builtin_swi ();
	__builtin_swi2 ();
	__builtin_swi3 ();
	__builtin_nop ();
	__builtin_blockage ();
	return 0;
}

/* vim: set noexpandtab: */
/* vim: set ts=8: */
