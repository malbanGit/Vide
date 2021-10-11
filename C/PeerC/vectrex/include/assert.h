// ***************************************************************************
// assert - runtime assertion checking
// ***************************************************************************

#pragma once

// ---------------------------------------------------------------------------
// assert(expr);
// ---------------------------------------------------------------------------

#ifndef NDEBUG
void _f_assert_failed(char* file, unsigned int length, unsigned long int line, char* func, char* expr, unsigned int l_expr);
#define assert(expr) \
	((expr) || (_f_assert_failed(__FILE__, sizeof(__FILE__), __LINE__, (char*) &__func__[0], #expr, sizeof(#expr)), 0))
#else
#define assert(expr) \
	((void) 1)
#endif

// ***************************************************************************
// end of file
// ***************************************************************************
