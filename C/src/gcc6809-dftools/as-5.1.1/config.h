#define VERSION     "V05.11 (GCC6809)" /* Version number */
#define COPYRIGHT   "2015"             /* Copyright year */
#define NCPS        512                /* Characters per symbol */
#define NINPUT      (NCPS*2)           /* Input buffer size */
#define FILSPC      (NINPUT+10)        /* File spec length */
#define MAXHASHBIT  16                 /* Maximum bits for a hash table */
#define NOFORMFEED  1                  /* Disable form feed in listing */
#define M6809STRICT 1                  /* No opcode compatibility */

/*
 * To include NoICE Debugging set non-zero
 */
#define NOICE      1

/*
 * To include SDCC Debugging set non-zero
 */
#define SDCDB      1

