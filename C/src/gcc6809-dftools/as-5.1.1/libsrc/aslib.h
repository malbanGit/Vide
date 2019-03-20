/* aslib.h */

/*
 * Include Config File
 */
#include "../config.h"

/*
 * Local Definitions
 */
#define FSEPX '.'

/*
 * Case Sensitivity Flag
 */
#define CASE_SENSITIVE 1

struct lfile
{
	char *f_idp;          /* Pointer to file spec */
	struct lfile *f_flp;  /* lfile link */
	char f_found;         /* Module found flag */
	char f_arch;          /* Archive flag */
};

/*
 * From ardata.c
 */
extern char *ip;
extern char ib[NINPUT];
extern char ctype[];
#ifndef	CASE_SENSITIVE
extern char ccase[];
#endif
extern struct lfile *filep;
extern struct lfile *cfp;

/*
 * Misc. Defines
 */
#define SPACE  0000
#define ETC    0000
#define LETTER 0001
#define DIGIT  0002
#define BINOP  0004
#define RAD2   0010
#define RAD8   0020
#define RAD10  0040
#define RAD16  0100
#define ILL    0200
#define DGT2   DIGIT|RAD16|RAD10|RAD8|RAD2
#define DGT8   DIGIT|RAD16|RAD10|RAD8
#define DGT10  DIGIT|RAD16|RAD10
#define LTR16  LETTER|RAD16

/* EOF */
