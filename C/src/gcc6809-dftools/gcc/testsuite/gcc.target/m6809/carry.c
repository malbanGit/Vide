/* { dg-do link } */
/* { dg-options "-O2 -save-temps" } */
/* { dg-final { scan-assembler "adc" } } */
/* { dg-final { scan-assembler "sbc" } } */

extern void abort (void);

int main ()
{
	volatile register unsigned char x;
	__builtin_add_carry (x, 1);
	__builtin_sub_carry (x, 1);
	return 0;
}

/* vim: set noexpandtab: */
/* vim: set ts=8: */
