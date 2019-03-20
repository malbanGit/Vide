/* { dg-do link } */

extern void abort (void);

/* Test that various special opcodes get used for certain constructs */

int main ()
{
	__builtin_cwai (0);
	__builtin_sync ();
	return 0;
}

/* vim: set noexpandtab: */
/* vim: set ts=8: */
