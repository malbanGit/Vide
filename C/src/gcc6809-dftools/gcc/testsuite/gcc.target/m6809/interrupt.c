/* { dg-do compile } */
/* { dg-options "-save-temps" } */
/* { dg-final { scan-assembler "rti" } } */

extern void abort (void);

__attribute__((interrupt)) void f (void)
{
}

/* vim: set noexpandtab: */
/* vim: set ts=8: */
