/* { dg-do compile } */

extern void abort (void);

int main (void)
{
#if defined(__m6809__)
#if defined(__int8__) || defined(__int16__)
#if defined(__ABI_STACK__) || defined(__ABI_REGS__) || defined(__ABI_BX__)
	return 0;
#endif
#endif
#endif
	abort ();
}

/* vim: set noexpandtab: */
/* vim: set ts=8: */
