/* { dg-do run } */

extern void abort (void);

#define daatest(in,out) \
do { \
	unsigned char bytevar; \
	bytevar = __builtin_add_decimal (in, 0); \
	if (bytevar != out) abort (); \
} while (0)


int main ()
{
	daatest (0x99, 0x99);
	daatest (0, 0);
	daatest (0x1A, 0x20);
	return 0;
}

/* vim: set noexpandtab: */
/* vim: set ts=8: */
