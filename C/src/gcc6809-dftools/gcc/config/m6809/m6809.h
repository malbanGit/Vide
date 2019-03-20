/* Definitions of target machine for GNU compiler.  MC6809 version.

 MC6809 Version by Tom Jones (jones@sal.wisc.edu)
 Space Astronomy Laboratory
 University of Wisconsin at Madison

 minor changes to adapt it to gcc-2.5.8 by Matthias Doerfel
 ( msdoerfe@informatik.uni-erlangen.de )
 also added #pragma interrupt (inspired by gcc-6811)

 minor changes to adapt it to gcc-2.8.0 by Eric Botcazou
 (ebotcazou@multimania.com)

 minor changes to adapt it to egcs-1.1.2 by Eric Botcazou
 (ebotcazou@multimania.com)

 minor changes to adapt it to gcc-2.95.3 by Eric Botcazou
 (ebotcazou@multimania.com)

 changes for gcc-3.1.1 by ???

 further changes for gcc-3.1.1 and beyond by Brian Dominy
 (brian@oddchange.com)

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GCC; see the file COPYING3.  If not see
<http://www.gnu.org/licenses/>.  */


/* Helper macros for creating strings with macros */
#define C_STRING(x) C_STR(x)
#define C_STR(x) #x

/* Certain parts of GCC include host-side includes, which is bad.
 * Some things that get pulled in need to be undone.
 */
#undef HAVE_GAS_HIDDEN

/* Names to predefine in the preprocessor for this target machine.  */
#define TARGET_CPU_CPP_BUILTINS() m6809_cpu_cpp_builtins ()

/* As an embedded target, we have no libc.  */
#ifndef inhibit_libc
#define inhibit_libc
#endif

/* Print subsidiary information on the compiler version in use.  */
#define TARGET_VERSION fprintf (stderr, " (MC6809)");

/* Run-time compilation parameters selecting different hardware subsets.  */
extern int target_flags;
extern short *reg_renumber; /* def in local_alloc.c */

/* Runtime current values of section names */
extern int section_changed;
extern char code_section_op[], data_section_op[], bss_section_op[];

#define WARNING_OPT 0,
extern const char *m6809_abi_version_ptr;
extern unsigned int m6809_soft_regs;
extern unsigned int m6809_abi_version;

#define OVERRIDE_OPTIONS m6809_override_options ()

/* ABI versions */

#define M6809_ABI_VERSION_STACK 0
#define M6809_ABI_VERSION_REGS 1 /* deprecated, same as BX */
#define M6809_ABI_VERSION_BX 1
#define M6809_ABI_VERSION_LATEST  (M6809_ABI_VERSION_BX)

/* Allow $ in identifiers */
#define DOLLARS_IN_IDENTIFIERS 1

/*--------------------------------------------------------------
    Target machine storage layout
--------------------------------------------------------------*/

/* Define this if most significant bit is lowest numbered
   in instructions that operate on numbered bit-fields.  */
#define BITS_BIG_ENDIAN 0

/* Define to 1 if most significant byte of a word is the lowest numbered. */
#define BYTES_BIG_ENDIAN 1

/* Define to 1 if most significant word of a multiword value is the lowest numbered. */
#define WORDS_BIG_ENDIAN 1

/* Number of bits in an addressible storage unit */
#define BITS_PER_UNIT 8

/* Width in bits of a "word", or the contents of a machine register.
 * Although the 6809 has a few byte registers, define this to 16-bits
 * since this is the natural size of most registers. */
#define BITS_PER_WORD 16

/* Width of a word, in units (bytes).  */
#define UNITS_PER_WORD (BITS_PER_WORD/8)

/* Width in bits of a pointer.  See also the macro `Pmode' defined below.  */
#define POINTER_SIZE 16

/* Allocation boundary (bits) for storing pointers in memory.  */
#define POINTER_BOUNDARY 8

/* Allocation boundary (bits) for storing arguments in argument list.  */
/* PARM_BOUNDARY is divided by BITS_PER_WORD in expr.c -- tej */
#define PARM_BOUNDARY 8

/* Boundary (bits) on which stack pointer should be aligned.  */
#define STACK_BOUNDARY 8

/* Allocation boundary (bits) for the code of a function.  */
#define FUNCTION_BOUNDARY 8

/* Alignment of field after `int : 0' in a structure.  */
#define EMPTY_FIELD_BOUNDARY 8

/* Every structure's size must be a multiple of this.  */
#define STRUCTURE_SIZE_BOUNDARY 8

/* Largest mode size to use when putting an object, including
 * a structure, into a register.  By limiting this to 16, no
 * 32-bit objects will ever be allocated to a pair of hard
 * registers.  This is a good thing, since there aren't that
 * many of them.  32-bit objects are only needed for floats
 * and "long long"s.  Larger values have been tried and did not
 * work. */
#define MAX_FIXED_MODE_SIZE 16

/* No data type wants to be aligned rounder than this.  */
#define BIGGEST_ALIGNMENT 8

/* Define this if move instructions will actually fail to work
   when given unaligned data.  */
#define STRICT_ALIGNMENT 0

/*--------------------------------------------------------------
    Standard register usage.
--------------------------------------------------------------*/

/* Register values as bitmasks.
 * TODO : merge D_REGBIT and B_REGBIT, and treat this as the same
 * register. */
#define RSVD1_REGBIT    (1 << HARD_RSVD1_REGNUM)
#define D_REGBIT        (1 << HARD_D_REGNUM)
#define X_REGBIT        (1 << HARD_X_REGNUM)
#define Y_REGBIT        (1 << HARD_Y_REGNUM)
#define U_REGBIT        (1 << HARD_U_REGNUM)
#define S_REGBIT        (1 << HARD_S_REGNUM)
#define PC_REGBIT       (1 << HARD_PC_REGNUM)
#define Z_REGBIT        (1 << HARD_Z_REGNUM)
#define A_REGBIT        (1 << HARD_A_REGNUM)
#define B_REGBIT        (1 << HARD_B_REGNUM)
#define CC_REGBIT       (1 << HARD_CC_REGNUM)
#define DP_REGBIT       (1 << HARD_DP_REGNUM)
#define SOFT_FP_REGBIT  (1 << SOFT_FP_REGNUM)
#define SOFT_AP_REGBIT  (1 << SOFT_AP_REGNUM)
#define M_REGBIT(n)     (1 << (SOFT_M0_REGNUM + n))

/* Macros for dealing with set of registers.
 * A register set is just a bitwise-OR of all the register
 * bitmask values. */

/* Which registers can hold 8-bits */
#define BYTE_REGSET \
  (Z_REGBIT | A_REGBIT | B_REGBIT | D_REGBIT | CC_REGBIT | DP_REGBIT | SOFT_M_REGBITS)

/* Which registers can hold 16-bits.
 * Note: D_REGBIT is defined as both an 8-bit and 16-bit register */
#define WORD_REGSET \
  (D_REGBIT | X_REGBIT | Y_REGBIT | U_REGBIT | S_REGBIT | PC_REGBIT | SOFT_FP_REGBIT | SOFT_AP_REGBIT)

/* Returns nonzero if a given REGNO is in the REGSET. */
#define REGSET_CONTAINS_P(regno, regset)  (((1 << (regno)) & (regset)) != 0)

/* Defines related to the number of soft registers supported.
 * The actual number used may be less depending on -msoft-reg-count.
 * If you change one of these, you should change them all. */
#define NUM_M_REGS 8
#define M_REGS_FIXED 1, 1, 1, 1, 1, 1, 1, 1
#define M_REGS_CALL_USED 1, 1, 1, 1, 1, 1, 1, 1
#define HARD_M_REGNUMS \
   SOFT_M0_REGNUM+0, SOFT_M0_REGNUM+1, SOFT_M0_REGNUM+2, SOFT_M0_REGNUM+3, \
   SOFT_M0_REGNUM+4, SOFT_M0_REGNUM+5, SOFT_M0_REGNUM+6, SOFT_M0_REGNUM+7

#define SOFT_M_REGBITS  (((1UL << NUM_M_REGS) - 1) << (SOFT_M0_REGNUM))

/* Number of actual hardware registers.
   The hardware registers are assigned numbers for the compiler
   from 0 to just below FIRST_PSEUDO_REGISTER.
   All registers that the compiler knows about must be given numbers,
   even those that are not normally considered general registers.
   Make sure the constant below matches the value of SOFT_M0_REGNUM;
   for some reason, GCC won't compile if that name is used here directly. */
#ifdef SOFT_M0_REGNUM
#if (SOFT_M0_REGNUM != 14)
#error "bad register numbering"
#endif
#endif
#define FIRST_PSEUDO_REGISTER (14 + NUM_M_REGS)

/* 1 for registers that have pervasive standard uses
   and are not available for the register allocator.
   The psuedoregisters (M_REGS) are declared fixed here, but
   will be unfixed if -msoft-reg-count is seen later.  */
#define FIXED_REGISTERS \
    {1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, M_REGS_FIXED, }
  /* -, X, Y, U, S, PC,D, Z, A, B, C, DP,FP,AP,M... */

/* 1 for registers not available across function calls.
   These must include the FIXED_REGISTERS and also any
   registers that can be used without being saved.
   The latter must include the registers where values are returned
   and the register where structure-value addresses are passed.
   Aside from that, you can include as many other registers as you like.  */
#define CALL_USED_REGISTERS \
    {1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, M_REGS_CALL_USED, }
  /* -, X, Y, U, S, PC,D, Z, A, B, C, DP,FP,AP,M... */

/* Return number of consecutive hard regs needed starting at reg REGNO
   to hold something of mode MODE.
   For the 6809, we distinguish between word-length and byte-length
   registers. */
#define HARD_REGNO_NREGS(REGNO, MODE) \
  (WORD_REGNO_P (REGNO) ? \
    ((GET_MODE_SIZE (MODE) + UNITS_PER_WORD - 1) / UNITS_PER_WORD) : \
    (GET_MODE_SIZE (MODE)))


/* Value is 1 if hard register REGNO can hold a value
of machine-mode MODE. */
#define HARD_REGNO_MODE_OK(REGNO, MODE) m6809_hard_regno_mode_ok (REGNO, MODE)

/* Value is 1 if it is a good idea to tie two pseudo registers
   when one has mode MODE1 and one has mode MODE2.
   If HARD_REGNO_MODE_OK could produce different values for MODE1 and MODE2,
   for any hard reg, then this must be 0 for correct output.  */
#define MODES_TIEABLE_P(MODE1, MODE2) 0

/* Specify the registers used for certain standard purposes.
   The values of these macros are register numbers.  */

/* program counter if referenced as a register */
#define PC_REGNUM HARD_PC_REGNUM

/* Register to use for pushing function arguments.  */
#define STACK_POINTER_REGNUM HARD_S_REGNUM

/* Base register for access to local variables of the function.
 * Before reload, FRAME_POINTER_REGNUM will be used.  Later,
 * the elimination pass will convert these to STACK_POINTER_REGNUM
 * if possible, or else HARD_FRAME_POINTER_REGNUM.  The idea is to
 * avoid tying up a hard register (U) for the frame pointer if
 * it can be eliminated entirely, making it available for use as
 * a general register. */
#define FRAME_POINTER_REGNUM       SOFT_FP_REGNUM
#define HARD_FRAME_POINTER_REGNUM  HARD_U_REGNUM


/* Value should be nonzero if functions must have frame pointers.
   Zero means the frame pointer need not be set up (and parms
   may be accessed via the stack pointer) in functions that seem suitable.
   This is computed in `reload', in reload1.c.  */
#define FRAME_POINTER_REQUIRED 0


/* Define a table of possible eliminations.
 * The idea is to try to avoid using hard registers for the argument
 * and frame pointers if they can be derived from the stack pointer
 * instead, which already has a hard register reserved for it.
 *
 * The order of entries in this table will try to convert
 * ARG_POINTER_REGNUM and FRAME_POINTER_REGNUM into stack pointer
 * references first, but if that fails, they will be converted to use
 * HARD_FRAME_POINTER_REGNUM.
 */
#define ELIMINABLE_REGS \
{{ ARG_POINTER_REGNUM, STACK_POINTER_REGNUM }, \
 { ARG_POINTER_REGNUM, HARD_FRAME_POINTER_REGNUM }, \
 { FRAME_POINTER_REGNUM, STACK_POINTER_REGNUM }, \
 { FRAME_POINTER_REGNUM, HARD_FRAME_POINTER_REGNUM }}

#define CAN_ELIMINATE(FROM, TO) m6809_can_eliminate (FROM, TO)

/* Define how to offset the frame or argument pointer to turn it
 * into a stack pointer reference.  This is based on the way that
 * the frame is constructed in the function prologue. */
#define INITIAL_ELIMINATION_OFFSET(FROM, TO, OFFSET) \
  (OFFSET) = m6809_initial_elimination_offset (FROM, TO)

/* Base register for access to arguments of the function.
 * This is only used prior to reload; no instructions will ever
 * be output referring to this register. */
#define ARG_POINTER_REGNUM SOFT_AP_REGNUM

/* Register in which static-chain is passed to a function.  */
#define STATIC_CHAIN_REGNUM HARD_Y_REGNUM

#define CONDITIONAL_REGISTER_USAGE (m6809_conditional_register_usage ())

/* Order in which hard registers are allocated to pseudos.
 *
 * Since the D register is the only valid reg for 8-bit values
 * now, avoid using it for 16-bit values by putting it after all
 * other 16-bits.
 *
 * Prefer X first since the first 16-bit function argument goes
 * there.  We may be able to pass in to a subroutine without
 * a copy.
 *
 * Prefer U over Y since instructions using Y take one extra
 * byte, and thus one extra cycle to execute.
 */
#define REG_ALLOC_ORDER \
 { HARD_X_REGNUM, HARD_U_REGNUM, HARD_Y_REGNUM, \
   HARD_D_REGNUM, HARD_M_REGNUMS, HARD_S_REGNUM, \
   HARD_PC_REGNUM, HARD_B_REGNUM, HARD_A_REGNUM, \
   HARD_CC_REGNUM, HARD_DP_REGNUM, SOFT_FP_REGNUM, \
   SOFT_AP_REGNUM, HARD_Z_REGNUM, HARD_RSVD1_REGNUM }

/*--------------------------------------------------------------
    classes of registers
--------------------------------------------------------------*/

/* Define the classes of registers for register constraints in the
   machine description.  Also define ranges of constants.

   One of the classes must always be named ALL_REGS and include all hard regs.
   If there is more than one class, another class must be named NO_REGS
   and contain no registers.

   The name GENERAL_REGS must be the name of a class (or an alias for
   another name such as ALL_REGS).  This is the class of registers
   that is allowed by "g" or "r" in a register constraint.
   Also, registers outside this class are allocated only when
   instructions express preferences for them.

   The classes must be numbered in nondecreasing order; that is,
   a larger-numbered class must never be contained completely
   in a smaller-numbered class.

   For any two classes, it is very desirable that there be another
   class that represents their union.  */
   
enum reg_class {
    NO_REGS,    /* The trivial class with no registers in it */
    D_REGS,     /* 16-bit (word (HI)) data (D) */
    ACC_A_REGS, /* The A register */
    ACC_B_REGS, /* The B register */
    X_REGS,     /* The X register */
    Z_REGS,     /* The Z (zero-bit) register */
    Q_REGS,     /* 8-bit (byte (QI)) data (A,B) */
    M_REGS,     /* 8-bit (byte (QI)) soft registers */
    CC_REGS,    /* 8-bit condition code register */
    I_REGS,     /* An index register (A,B,D) */
    T_REGS,     /* 16-bit addresses, not including stack or PC (X,Y,U) */
    A_REGS,     /* 16-bit addresses (X,Y,U,S,PC) */
    S_REGS,     /* 16-bit soft registers (FP, AP) */
    P_REGS,     /* 16-bit pushable registers (D,X,Y,U); omit PC and S */
    G_REGS,     /* 16-bit data and address (D,X,Y,U,S,PC) */
    ALL_REGS,   /* All registers */
    LIM_REG_CLASSES
};

#define N_REG_CLASSES (int) LIM_REG_CLASSES

/* Since GENERAL_REGS is a smaller class than ALL_REGS,
   it is not an alias to ALL_REGS, but to G_REGS. */
#define GENERAL_REGS G_REGS

/* Give names of register classes as strings for dump file.   */
#define REG_CLASS_NAMES \
 { "NO_REGS", "D_REGS", "ACC_A_REGS", "ACC_B_REGS", "X_REGS", "Z_REGS", \
   "Q_REGS", "M_REGS", "CC_REGS", "I_REGS", "T_REGS", "A_REGS", "S_REGS", \
   "P_REGS", "G_REGS", "ALL_REGS" }

/* Define which registers fit in which classes.
   This is an initializer for a vector of HARD_REG_SET
   of length N_REG_CLASSES.  */

#define D_REGSET (D_REGBIT)
#define ACC_A_REGSET (A_REGBIT)
#define ACC_B_REGSET (D_REGBIT)
#define X_REGSET (X_REGBIT)
#define Z_REGSET (Z_REGBIT)
#define Q_REGSET (D_REGBIT | A_REGBIT)
#define M_REGSET (SOFT_M_REGBITS)
#define CC_REGSET (CC_REGBIT)
#define I_REGSET (A_REGBIT | B_REGBIT | D_REGBIT)
#define T_REGSET (X_REGBIT | Y_REGBIT | U_REGBIT)
#define A_REGSET (X_REGBIT | Y_REGBIT | U_REGBIT | S_REGBIT | PC_REGBIT)
#define S_REGSET (SOFT_FP_REGBIT | SOFT_AP_REGBIT)
#define P_REGSET (D_REGBIT | X_REGBIT | Y_REGBIT | U_REGBIT)
#define G_REGSET \
  (D_REGSET | Q_REGSET | I_REGSET | A_REGSET | M_REGSET | S_REGSET)
#define ALL_REGSET (G_REGSET)

#define REG_CLASS_CONTENTS { \
  {0}, \
  {D_REGSET}, \
  {ACC_A_REGSET}, \
  {ACC_B_REGSET}, \
  {X_REGSET}, \
  {Z_REGSET}, \
  {Q_REGSET}, \
  {M_REGSET}, \
  {CC_REGSET}, \
  {I_REGSET}, \
  {T_REGSET}, \
  {A_REGSET}, \
  {S_REGSET}, \
  {P_REGSET}, \
  {G_REGSET}, \
  {ALL_REGSET}, \
}

/* The same information, inverted.
 * This is defined to use the REG_CLASS_CONTENTS defines above, so that
 * these two sets of definitions are always consistent. */

#define REGNO_REG_CLASS(REGNO) \
  (D_REGNO_P (REGNO) ? D_REGS : \
  (Z_REGNO_P (REGNO) ? Z_REGS : \
  (ACC_A_REGNO_P (REGNO) ? ACC_A_REGS : \
  (ACC_B_REGNO_P (REGNO) ? ACC_B_REGS : \
  (X_REGNO_P (REGNO) ? X_REGS : \
  (Q_REGNO_P (REGNO) ? Q_REGS : \
  (M_REGNO_P (REGNO) ? M_REGS : \
  (CC_REGNO_P (REGNO) ? CC_REGS : \
  (I_REGNO_P (REGNO) ? I_REGS : \
  (T_REGNO_P (REGNO) ? T_REGS : \
  (A_REGNO_P (REGNO) ? A_REGS : \
  (S_REGNO_P (REGNO) ? S_REGS : \
  (P_REGNO_P (REGNO) ? P_REGS : \
  (G_REGNO_P (REGNO) ? G_REGS : ALL_REGS))))))))))))))

#define D_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, D_REGSET))
#define ACC_A_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, ACC_A_REGSET))
#define ACC_B_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, ACC_B_REGSET))
#define X_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, X_REGSET))
#define Z_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, Z_REGSET))
#define Q_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, Q_REGSET))
#define M_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, M_REGSET))
#define CC_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, CC_REGSET))
#define I_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, I_REGSET))
#define T_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, T_REGSET))
#define A_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, A_REGSET))
#define S_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, S_REGSET))
#define P_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, P_REGSET))
#define G_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, G_REGSET))

/* Macros that test an rtx 'X' to see if it's in a particular
 * register class.  'X' need not be a REG necessarily. */

#define D_REG_P(X) (REG_P (X) && D_REGNO_P (REGNO (X)))
#define ACC_A_REG_P(X) (REG_P (X) && ACC_A_REGNO_P (REGNO (X)))
#define ACC_B_REG_P(X) (REG_P (X) && ACC_B_REGNO_P (REGNO (X)))
#define X_REG_P(X) (REG_P (X) && X_REGNO_P (REGNO (X)))
#define Z_REG_P(X) (REG_P (X) && Z_REGNO_P (REGNO (X)))
#define I_REG_P(X) (REG_P (X) && I_REGNO_P (REGNO (X)))
#define T_REG_P(X) (REG_P (X) && T_REGNO_P (REGNO (X)))
#define A_REG_P(X) (REG_P (X) && A_REGNO_P (REGNO (X)))
#define S_REG_P(X) (REG_P (X) && S_REGNO_P (REGNO (X)))
#define P_REG_P(X) (REG_P (X) && P_REGNO_P (REGNO (X)))
#define Q_REG_P(X) (REG_P (X) && Q_REGNO_P (REGNO (X)))
#define M_REG_P(X) (REG_P (X) && M_REGNO_P (REGNO (X)))
#define CC_REG_P(X) (REG_P (X) && CC_REGNO_P (REGNO (X)))

/* Redefine this in terms of BYTE_REGSET */
#define BYTE_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, BYTE_REGSET))

/* Redefine this in terms of WORD_REGSET */
#define WORD_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, WORD_REGSET))

/* The class value for index registers, and the one for base regs.  */
#define INDEX_REG_CLASS I_REGS
#define BASE_REG_CLASS A_REGS

/* Get reg_class from a letter in the machine description.  */
#define REG_CLASS_FROM_LETTER(C) \
 (((C) == 'a' ? A_REGS : \
  ((C) == 'd' ? D_REGS : \
  ((C) == 'x' ? I_REGS : \
  ((C) == 't' ? M_REGS : \
  ((C) == 'c' ? CC_REGS : \
  ((C) == 'A' ? ACC_A_REGS : \
  ((C) == 'B' ? ACC_B_REGS : \
  ((C) == 'v' ? X_REGS : \
  ((C) == 'u' ? S_REGS : \
  ((C) == 'U' ? P_REGS : \
  ((C) == 'T' ? T_REGS : \
  ((C) == 'z' ? Z_REGS : \
  ((C) == 'q' ? Q_REGS : NO_REGS))))))))))))))

/*--------------------------------------------------------------
   The letters I through O in a register constraint string
   can be used to stand for particular ranges of immediate operands.
   This macro defines what the ranges are.
   C is the letter, and VALUE is a constant value.
   Return 1 if VALUE is in the range specified by C.

   For the 6809, J, K, L are used for indexed addressing.
   `I' is used for the constant 1.
   `J' is used for the 5-bit offsets.
   `K' is used for the 8-bit offsets.
   `L' is used for the range of signed numbers that fit in 16 bits.
   `M' is used for the exact value '8'.
   `N' is used for the constant -1.
   `O' is used for the constant 0.
--------------------------------------------------------------*/

#define CONST_OK_FOR_LETTER_P(VALUE, C) \
  ((C) == 'I' ? ((VALUE) == 1) : \
   (C) == 'J' ? ((VALUE) >= -16 && (VALUE) <= 15) : \
   (C) == 'K' ? ((VALUE) >= -128 && (VALUE) <= 127) : \
   (C) == 'L' ? ((VALUE) >= -32768 && (VALUE) <= 32767) : \
   (C) == 'M' ? ((VALUE) == 8) : \
   (C) == 'N' ? ((VALUE) == -1) : \
   (C) == 'O' ? ((VALUE) == 0) : 0)

/* Similar, but for floating constants, and defining letters G and H.
   No floating-point constants are valid on MC6809.  */
#define CONST_DOUBLE_OK_FOR_LETTER_P(VALUE, C) \
   ((C) == 'G' ? (GET_MODE_CLASS (GET_MODE (VALUE)) == MODE_FLOAT \
     && VALUE == CONST0_RTX (GET_MODE (VALUE))) : 0)

/* Given an rtx X being reloaded into a reg required to be
   in class CLASS, return the class of reg to actually use.
   In general this is just CLASS; but on some machines
   in some cases it is preferable to use a more restrictive class.  */
#define PREFERRED_RELOAD_CLASS(X,CLASS) m6809_preferred_reload_class(X,CLASS)

#define SMALL_REGISTER_CLASSES  1

/* Return the maximum number of consecutive registers
   needed to represent mode MODE in a register of class CLASS.  */
#define CLASS_MAX_NREGS(CLASS, MODE) \
    ((GET_MODE_SIZE (MODE) + UNITS_PER_WORD - 1) / UNITS_PER_WORD)

/*--------------------------------------------------------------
    Stack layout; function entry, exit and calling.
--------------------------------------------------------------*/

/* Define this if pushing a word on the stack
   makes the stack pointer a smaller address.  */
#define STACK_GROWS_DOWNWARD


/* Define this if the nominal address of the stack frame
   is at the high-address end of the local variables;
   that is, each additional local variable allocated
   goes at a more negative offset in the frame.  */
#define FRAME_GROWS_DOWNWARD 1


/* Offset within stack frame to start allocating local variables at.
   If FRAME_GROWS_DOWNWARD, this is the offset to the END of the
   first local allocated.  Otherwise, it is the offset to the BEGINNING
   of the first local allocated.  */
#define STARTING_FRAME_OFFSET 0


/* Always push stack arguments for now.  Accumulation is not yet working. */
#define PUSH_ROUNDING(BYTES) (BYTES)


/* Offset of first parameter from the argument pointer register value.
 * ARG_POINTER_REGNUM is defined to point to the return address pushed
 * onto the stack, so we must offset by 2 bytes to get to the arguments. */
#define FIRST_PARM_OFFSET(FNDECL) 2

/* Value is 1 if returning from a function call automatically
   pops the arguments described by the number-of-args field in the call.
   FUNTYPE is the data type of the function (as a tree),
   or for a library call it is an identifier node for the subroutine name. */
#define RETURN_POPS_ARGS(FUNDECL,FUNTYPE,SIZE) 0

/* Define how to find the value returned by a function.
   VALTYPE is the data type of the value (as a tree).
   If the precise function being called is known, FUNC is its FUNCTION_DECL;
   otherwise, FUNC is 0.  */
#define FUNCTION_VALUE(VALTYPE, FUNC) m6809_function_value (VALTYPE, FUNC)

/* Define how to find the value returned by a library function
   assuming the value has mode MODE.  */

/* All return values are in the X-register. */
#define LIBCALL_VALUE(MODE)  gen_rtx_REG (MODE, HARD_X_REGNUM)

/* Define this if using the nonreentrant convention for returning
   structure and union values.  No; it is inefficient and buggy. */
#undef PCC_STATIC_STRUCT_RETURN

/* 1 if N is a possible register number for a function value. */
#define FUNCTION_VALUE_REGNO_P(N) m6809_function_value_regno_p (N)

/* Define this to be true when FUNCTION_VALUE_REGNO_P is true for
   more than one register.  */
#define NEEDS_UNTYPED_CALL 1

/* 1 if N is a possible register number for function argument passing. */
#define FUNCTION_ARG_REGNO_P(N) \
  ((m6809_abi_version != M6809_ABI_VERSION_STACK) ? \
    (((N) == HARD_D_REGNUM) || ((N) == HARD_X_REGNUM)) : \
    0)

/*--------------------------------------------------------------
    Argument Lists
--------------------------------------------------------------*/

/* Cumulative arguments are tracked in a single integer, 
 * which is the number of bytes of arguments scanned so far,
 * plus which registers have already been used.  The register
 * info is kept in some of the upper bits */
#define CUMULATIVE_ARGS unsigned int

#define CUM_STACK_ONLY 0x80000000
#define CUM_X_MASK     0x40000000
#define CUM_B_MASK     0x20000000
#define CUM_STACK_INVALID 0x10000000
#define CUM_STACK_MASK 0xFFFFFFF

#define CUM_ADVANCE_8BIT(cum) \
  (((cum) & CUM_B_MASK) ? (cum)++ : ((cum) |= CUM_B_MASK))

#define CUM_ADVANCE_16BIT(cum) \
  (((cum) & CUM_X_MASK) ? (cum) += 2 : ((cum) |= CUM_X_MASK))

/* Initialize a variable CUM of type CUMULATIVE_ARGS
   for a call to a function whose data type is FNTYPE.
   For a library call, FNTYPE is 0.
   N_NAMED was added in gcc 3.4 and is not used currently. */
#define INIT_CUMULATIVE_ARGS(CUM,FNTYPE,LIBNAME,INDIRECT,N_NAMED) \
  ((CUM) = m6809_init_cumulative_args (CUM, FNTYPE, LIBNAME))

#define FUNCTION_ARG_SIZE(MODE, TYPE) \
  ((MODE) != BLKmode ? \
    GET_MODE_SIZE (MODE) : \
    (unsigned) int_size_in_bytes (TYPE))

/* Update the data in CUM to advance over an argument
   of mode MODE and data type TYPE.
   (TYPE is null for libcalls where that information may not be available.)  */
#define FUNCTION_ARG_ADVANCE(CUM, MODE, TYPE, NAMED) \
  (((MODE == QImode) && !((CUM) & CUM_STACK_ONLY)) ? \
    CUM_ADVANCE_8BIT (CUM) : \
    ((MODE == HImode) && !((CUM) & CUM_STACK_ONLY)) ? \
      CUM_ADVANCE_16BIT (CUM) : \
      ((CUM) = ((CUM) + (TYPE ? \
        int_size_in_bytes (TYPE) : \
        2))))

/* Define where to put the arguments to a function.
   Value is zero to push the argument on the stack,
   or a hard register rtx in which to store the argument.
   This macro is used _before_ FUNCTION_ARG_ADVANCE.

   For the 6809, the first 8-bit function argument can be placed into B,
   and the first 16-bit arg can go into X.  All other arguments
   will be pushed onto the stack.

   Command-line options can adjust this behavior somewhat.
 */
#define FUNCTION_ARG(CUM, MODE, TYPE, NAMED) \
  ((MODE == VOIDmode) ? \
    NULL_RTX : \
    ((MODE == BLKmode) || (GET_MODE_SIZE (MODE) > 2)) ? \
      NULL_RTX : \
      ((MODE == QImode) && !((CUM) & (CUM_STACK_ONLY | CUM_B_MASK))) ? \
        gen_rtx_REG (QImode, HARD_D_REGNUM) : \
        ((MODE == HImode) && !((CUM) & (CUM_STACK_ONLY | CUM_X_MASK))) ? \
          gen_rtx_REG (HImode, HARD_X_REGNUM) : \
          m6809_function_arg_on_stack (&CUM))

/* Output assembler code to FILE to profile function entry.
   We do not require a label, so say NO_PROFILE_COUNTERS and don't
   use LABELNO. */
#define NO_PROFILE_COUNTERS 1

#define FUNCTION_PROFILER(FILE, LABELNO) fprintf (FILE, "\tjsr\t_mcount\n")

/* Stack pointer must be correct on function exit */
#define EXIT_IGNORE_STACK 0

/*****************************************************************************
**
** Trampolines for Nested Functions
**
*****************************************************************************/

/* Length in units of the trampoline for entering a nested function.  */
#define TRAMPOLINE_SIZE 7

/* A template for the trampoline before addresses are known. */
#define TRAMPOLINE_TEMPLATE(FILE) \
  fprintf (FILE, "\tldy\t#0\n"); \
  fprintf (FILE, "\tjmp\t0\n");

/* A C statement to initialize the variable parts of a trampoline.
   ADDR is an RTX for the address of the trampoline; FNADDR is an
   RTX for the address of the nested function; STATIC_CHAIN is an
   RTX for the static chain value that should be passed to the
   function when it is called.  */
#define INITIALIZE_TRAMPOLINE(TRAMP, FNADDR, CXT) \
  m6809_initialize_trampoline((TRAMP), (FNADDR), (CXT))


/*--------------------------------------------------------------
    Addressing modes,
    and classification of registers for them.
--------------------------------------------------------------*/

/* 6809 has postincrement and predecrement addressing modes */
#define HAVE_POST_INCREMENT  1
#define HAVE_PRE_DECREMENT  1

/* Whether or not to use index registers is configurable.
 * Experiments show that things work better when this is off, so
 * that's the way it is for now. */
#undef USE_INDEX_REGISTERS


/* Macros to check register numbers against specific register classes.  */
#define REG_VALID_FOR_BASE_P(REGNO) \
  (((REGNO) < FIRST_PSEUDO_REGISTER) && A_REGNO_P (REGNO))

/* MC6809 index registers do not allow scaling, */
/* but there is "accumulator-offset" mode. */
#ifdef USE_INDEX_REGISTERS
#define REG_VALID_FOR_INDEX_P(REGNO) \
  (((REGNO) < FIRST_PSEUDO_REGISTER) && I_REGNO_P (REGNO))
#else
#define REG_VALID_FOR_INDEX_P(REGNO) 0
#endif

/* Internal macro, the nonstrict definition for REGNO_OK_FOR_BASE_P */
#define REGNO_OK_FOR_BASE_NONSTRICT_P(REGNO) \
  ((REGNO) >= FIRST_PSEUDO_REGISTER \
   || REG_VALID_FOR_BASE_P (REGNO) \
   || (REGNO) == FRAME_POINTER_REGNUM \
   || (REGNO) == HARD_FRAME_POINTER_REGNUM \
   || (REGNO) == ARG_POINTER_REGNUM \
   || (reg_renumber && REG_VALID_FOR_BASE_P (reg_renumber[REGNO])))

/* Internal macro, the nonstrict definition for REGNO_OK_FOR_INDEX_P */
#define REGNO_OK_FOR_INDEX_NONSTRICT_P(REGNO) \
  ((REGNO) >= FIRST_PSEUDO_REGISTER \
   || REG_VALID_FOR_INDEX_P (REGNO) \
   || (reg_renumber && REG_VALID_FOR_INDEX_P (reg_renumber[REGNO])))


/* Internal macro, the strict definition for REGNO_OK_FOR_BASE_P */
#define REGNO_OK_FOR_BASE_STRICT_P(REGNO) \
  ((REGNO) < FIRST_PSEUDO_REGISTER ? \
    REG_VALID_FOR_BASE_P (REGNO) : \
    (reg_renumber && REG_VALID_FOR_BASE_P (reg_renumber[REGNO])))


/* Internal macro, the strict definition for REGNO_OK_FOR_INDEX_P */
#define REGNO_OK_FOR_INDEX_STRICT_P(REGNO) \
  ((REGNO) < FIRST_PSEUDO_REGISTER ? \
    REG_VALID_FOR_INDEX_P (REGNO) : \
    (reg_renumber && REG_VALID_FOR_INDEX_P (reg_renumber[REGNO])))


#define REGNO_OK_FOR_BASE_P(REGNO) REGNO_OK_FOR_BASE_STRICT_P (REGNO)

#define REGNO_OK_FOR_INDEX_P(REGNO) REGNO_OK_FOR_INDEX_STRICT_P (REGNO)

#define REG_OK_FOR_BASE_STRICT_P(X)     REGNO_OK_FOR_BASE_STRICT_P (REGNO (X))
#define REG_OK_FOR_BASE_NONSTRICT_P(X)  REGNO_OK_FOR_BASE_NONSTRICT_P (REGNO (X))
#define REG_OK_FOR_INDEX_STRICT_P(X)    REGNO_OK_FOR_INDEX_STRICT_P (REGNO (X))
#define REG_OK_FOR_INDEX_NONSTRICT_P(X) REGNO_OK_FOR_INDEX_NONSTRICT_P (REGNO (X))

#ifndef REG_OK_STRICT
#define REG_OK_FOR_BASE_P(X)     REG_OK_FOR_BASE_NONSTRICT_P(X)
#ifdef USE_INDEX_REGISTERS
#define REG_OK_FOR_INDEX_P(X)    REG_OK_FOR_INDEX_NONSTRICT_P(X)
#else
#define REG_OK_FOR_INDEX_P(X)    0
#endif
#else
#define REG_OK_FOR_BASE_P(X)     REG_OK_FOR_BASE_STRICT_P (X)
#ifdef USE_INDEX_REGISTERS
#define REG_OK_FOR_INDEX_P(X)    REG_OK_FOR_INDEX_STRICT_P (X)
#else
#define REG_OK_FOR_INDEX_P(X)    0
#endif
#endif

/* Maximum number of registers that can appear in a valid memory address */
#ifdef USE_INDEX_REGISTERS
#define MAX_REGS_PER_ADDRESS 2
#else
#define MAX_REGS_PER_ADDRESS 1
#endif

/* 1 if X is an rtx for a constant that is a valid address.
 * We allow any constant, plus the sum of any two constants (this allows
 * offsetting a symbol ref) */
#define CONSTANT_ADDRESS_P(X) \
  ((CONSTANT_P (X)) \
   || ((GET_CODE (X) == PLUS) \
       && (CONSTANT_P (XEXP (X, 0))) && (CONSTANT_P (XEXP (X, 1)))))

/* Nonzero if the constant value X is a legitimate general operand.
   It is given that X satisfies CONSTANT_P or is a CONST_DOUBLE.  */
/* Any single-word constant is ok; the only contexts
   allowing general_operand of mode DI or DF are movdi and movdf. */
#define LEGITIMATE_CONSTANT_P(X) (GET_CODE (X) != CONST_DOUBLE)

/* Nonzero if the X is a legitimate immediate operand in PIC mode. */
#define LEGITIMATE_PIC_OPERAND_P(X) !symbolic_operand (X, VOIDmode)

/*--------------------------------------------------------------
    Test for valid memory addresses
--------------------------------------------------------------*/
/* GO_IF_LEGITIMATE_ADDRESS recognizes an RTL expression
   that is a valid memory address for an instruction.
   The MODE argument is the machine mode for the MEM expression
   that wants to use this address. */

/*--------------------------------------------------------------
   Valid addresses are either direct or indirect (MEM) versions
   of the following forms.
      constant              N
      register              ,X
      constant indexed      N,X
      accumulator indexed   D,X
      auto_increment        ,X++
      auto_decrement        ,--X
--------------------------------------------------------------*/

#define REGISTER_ADDRESS_P(X) \
  (REG_P (X) && REG_OK_FOR_BASE_P (X))

#define EXTENDED_ADDRESS_P(X) \
  CONSTANT_ADDRESS_P (X) \

#define LEGITIMATE_BASE_P(X) \
  ((REG_P (X) && REG_OK_FOR_BASE_P (X)) \
   || (GET_CODE (X) == SIGN_EXTEND \
       && GET_CODE (XEXP (X, 0)) == REG \
       && GET_MODE (XEXP (X, 0)) == HImode \
       && REG_OK_FOR_BASE_P (XEXP (X, 0))))

#define LEGITIMATE_OFFSET_P(X) \
  (CONSTANT_ADDRESS_P (X) || (REG_P (X) && REG_OK_FOR_INDEX_P (X)))

/* 1 if X is the sum of a base register and an offset. */
#define INDEXED_ADDRESS(X) \
  ((GET_CODE (X) == PLUS \
       && LEGITIMATE_BASE_P (XEXP (X, 0)) \
       && LEGITIMATE_OFFSET_P (XEXP (X, 1))) \
   || (GET_CODE (X) == PLUS \
       && LEGITIMATE_BASE_P (XEXP (X, 1)) \
       && LEGITIMATE_OFFSET_P (XEXP (X, 0))))

#define STACK_REG_P(X) (REG_P(X) && REGNO(X) == HARD_S_REGNUM)

#define STACK_PUSH_P(X) \
  (MEM_P (X) && GET_CODE (XEXP (X, 0)) == PRE_DEC && STACK_REG_P (XEXP (XEXP (X, 0), 0)))

#define STACK_POP_P(X) \
  (MEM_P (X) && GET_CODE (XEXP (X, 0)) == POST_INC && STACK_REG_P (XEXP (XEXP (X, 0), 0)))

#define PUSH_POP_ADDRESS_P(X) \
  (((GET_CODE (X) == PRE_DEC) || (GET_CODE (X) == POST_INC)) \
    && (LEGITIMATE_BASE_P (XEXP (X, 0))))

/* Go to ADDR if X is a valid address. */
#define GO_IF_LEGITIMATE_ADDRESS(MODE, X, ADDR) \
{ \
  if (REGISTER_ADDRESS_P(X)) goto ADDR; \
  if (PUSH_POP_ADDRESS_P (X)) goto ADDR; \
  if (EXTENDED_ADDRESS_P (X)) goto ADDR; \
  if (INDEXED_ADDRESS (X)) goto ADDR; \
  if (MEM_P (X) && REGISTER_ADDRESS_P(XEXP (X, 0))) goto ADDR; \
  if (MEM_P (X) && PUSH_POP_ADDRESS_P (XEXP (X, 0))) goto ADDR; \
  if (MEM_P (X) && EXTENDED_ADDRESS_P (XEXP (X, 0))) goto ADDR; \
  if (MEM_P (X) && INDEXED_ADDRESS (XEXP (X, 0))) goto ADDR; \
}

/*--------------------------------------------------------------
    Address Fix-up
--------------------------------------------------------------*/
/* Try machine-dependent ways of modifying an illegitimate address
   to be legitimate.  If we find one, return the new, valid address.
   This macro is used in only one place: `memory_address' in explow.c.

   OLDX is the address as it was before break_out_memory_refs was called.
   In some cases it is useful to look at this to decide what needs to be done.

   MODE and WIN are passed so that this macro can use
   GO_IF_LEGITIMATE_ADDRESS.

   It is always safe for this macro to do nothing.
   It exists to recognize opportunities to optimize the output.
   --------*/

#define LEGITIMIZE_ADDRESS(X,OLDX,MODE,WIN)

/* Go to LABEL if ADDR (a legitimate address expression)
   has an effect that depends on the machine mode it is used for.
   In the latest GCC, this case is already handled by the core code
   so no action is required here. */
#define GO_IF_MODE_DEPENDENT_ADDRESS(ADDR,LABEL) {}


/*--------------------------------------------------------------
    Miscellaneous Parameters
--------------------------------------------------------------*/
/* Specify the machine mode that this machine uses
   for the index in the tablejump instruction.  */
#define CASE_VECTOR_MODE Pmode

/* Define this as 1 if `char' should by default be signed; else as 0.  */
#define DEFAULT_SIGNED_CHAR 0

/* This flag, if defined, says the same insns that convert to a signed fixnum
   also convert validly to an unsigned one.  */
#define FIXUNS_TRUNC_LIKE_FIX_TRUNC

/* Max number of bytes we can move from memory to memory/register
   in one reasonably fast instruction.  */
#define MOVE_MAX 2

/* Int can be 8 or 16 bits (default is 16) */
#define INT_TYPE_SIZE (TARGET_BYTE_INT ? 8 : 16)

/* Short is always 16 bits */
#define SHORT_TYPE_SIZE (TARGET_BYTE_INT ? 8 : 16)

/* Size (bits) of the type "long" on target machine */
#define LONG_TYPE_SIZE (TARGET_BYTE_INT ? 16 : 32)

/* Size (bits) of the type "long long" on target machine */
#define LONG_LONG_TYPE_SIZE 32

/* Size (bits) of the type "char" on target machine */
#define CHAR_TYPE_SIZE 8

/* Size (bits) of the type "float" on target machine */
#define FLOAT_TYPE_SIZE 32

/* Size (bits) of the type "double" on target machine.
 * Note that the C standard does not require that doubles
 * hold any more bits than float.  Since the 6809 has so few
 * registers, we cannot really support more than 32-bits. */
#define DOUBLE_TYPE_SIZE 32 

/* Size (bits) of the type "long double" on target machine */
#define LONG_DOUBLE_TYPE_SIZE 32

/* Define the type used for "size_t".  With a 64KB address space,
 * only a 16-bit value here makes sense. */
#define SIZE_TYPE (TARGET_BYTE_INT ? "long unsigned int" : "unsigned int")

/* Likewise, the difference between two pointers is also a 16-bit
 * signed value. */
#define PTRDIFF_TYPE (TARGET_BYTE_INT ? "long int" : "int")

/* Nonzero if access to memory by bytes is slow and undesirable.  */
#define SLOW_BYTE_ACCESS 0

/* Define if shifts truncate the shift count
   which implies one can omit a sign-extension or zero-extension
   of a shift count.  */
#define SHIFT_COUNT_TRUNCATED 0

/* Value is 1 if truncating an integer of INPREC bits to OUTPREC bits
   is done just by pretending it is already truncated.  */
#define TRULY_NOOP_TRUNCATION(OUTPREC, INPREC) 1

/* It is as good to call a constant function address as to
   call an address kept in a register. */
#define NO_FUNCTION_CSE

/* Specify the machine mode that pointers have.
   After generation of rtl, the compiler makes no further distinction
   between pointers and any other objects of this machine mode.  */
#define Pmode HImode

/* A function address in a call instruction
   is a byte address (for indexing purposes)
   so give the MEM rtx a byte's mode.  */
#define FUNCTION_MODE HImode

/* Define the cost of moving a value from a register in CLASS1
 * to CLASS2, of a given MODE.
 *
 * On the 6809, hard register transfers are all basically equivalent.
 * But soft register moves are treated more like memory moves. */
#define REGISTER_MOVE_COST(MODE, CLASS1, CLASS2) \
  (((CLASS1 == M_REGS) || (CLASS2 == M_REGS)) ? 4 : 7)

/* Define the cost of moving a value between a register and memory. */
#define MEMORY_MOVE_COST(MODE, CLASS, IN) 5

/* Check a `double' value for validity for a particular machine mode.  */

#define CHECK_FLOAT_VALUE(MODE, D, OVERFLOW) \
  ((OVERFLOW) = check_float_value (MODE, &D, OVERFLOW))


/*--------------------------------------------------------------
    machine-dependent
--------------------------------------------------------------*/
/* Tell final.c how to eliminate redundant test instructions.  */

/* Here we define machine-dependent flags and fields in cc_status
   (see `conditions.h').  */

/* Store in cc_status the expressions
   that the condition codes will describe
   after execution of an instruction whose pattern is EXP.
   Do not alter them if the instruction would not alter the cc's.  */

/* On the 6809, most of the insns to store in an address register
   fail to set the cc's.  However, in some cases these instructions
   can make it possibly invalid to use the saved cc's.  In those
   cases we clear out some or all of the saved cc's so they won't be used.  */

#define NOTICE_UPDATE_CC(EXP, INSN) \
  notice_update_cc((EXP), (INSN))

/*****************************************************************************
**
** pragma support
**
*****************************************************************************/

#define REGISTER_TARGET_PRAGMAS() \
  do { \
    extern void pragma_section PARAMS ((cpp_reader *)); \
    c_register_pragma (0, "section", pragma_section); \
  } while (0)

/*--------------------------------------------------------------
    ASSEMBLER FORMAT
--------------------------------------------------------------*/

#define FMT_HOST_WIDE_INT "%ld"

/* Output to assembler file text saying following lines
   may contain character constants, extra white space, comments, etc.  */
#define ASM_APP_ON ";----- asm -----\n"

/* Output to assembler file text saying following lines
   no longer contain unusual constructs.  */
#define ASM_APP_OFF ";--- end asm ---\n"

/* Use a semicolon to begin a comment. */
#define ASM_COMMENT_START ";"

/* Output assembly directives to switch to section 'name' */
#undef TARGET_ASM_NAMED_SECTION
#define TARGET_ASM_NAMED_SECTION m6809_asm_named_section

#undef TARGET_HAVE_NAMED_SECTION
#define TARGET_HAVE_NAMED_SECTION m6809_have_named_section

/* Output before read-only data.  */
#define TEXT_SECTION_ASM_OP (code_section_op)

/* Output before writable data.  */
#define DATA_SECTION_ASM_OP (data_section_op)

/* Output before uninitialized data.  */
#define BSS_SECTION_ASM_OP (bss_section_op)

/* Support the ctors and dtors sections for g++.  */
 
#undef CTORS_SECTION_ASM_OP
#define CTORS_SECTION_ASM_OP "\t.area\t.ctors"
#undef DTORS_SECTION_ASM_OP
#define DTORS_SECTION_ASM_OP "\t.area\t.dtors"

/* Prevent generation of __CTOR_LIST__ and __DTOR_LIST__ */
#define CTOR_LISTS_DEFINED_EXTERNALLY

#undef DO_GLOBAL_CTORS_BODY
#undef DO_GLOBAL_DTORS_BODY

#define HAS_INIT_SECTION

/* This is how to output an assembler line
   that says to advance the location counter
   to a multiple of 2**LOG bytes.  */

#define ASM_OUTPUT_ALIGN(FILE,LOG) \
  if ((LOG) > 1) \
    fprintf (FILE, "\t.bndry\t%u\n", 1 << (LOG))

/* The .set foo,bar construct doesn't work by default */
#undef SET_ASM_OP
#define ASM_OUTPUT_DEF(FILE, LABEL1, LABEL2) \
  do { \
    assemble_name (FILE, LABEL1); \
    fputs ("\t.equ\t", FILE); \
    assemble_name (FILE, LABEL2); \
    fputc ('\n', FILE); \
  } while (0)

/* How to refer to registers in assembler output.
   This sequence is indexed by compiler's hard-register-number (see above).  */
#define MNAME(x) [SOFT_M0_REGNUM+(x)] = "*m" C_STRING(x) ,

#define REGISTER_NAMES { \
  [HARD_D_REGNUM]= "d", \
  [HARD_X_REGNUM]= "x", \
  [HARD_Y_REGNUM]= "y", \
  [HARD_U_REGNUM]= "u", \
  [HARD_S_REGNUM]= "s", \
  [HARD_PC_REGNUM]= "pc", \
  [HARD_A_REGNUM]= "a", \
  [HARD_B_REGNUM]= "b", \
  [HARD_CC_REGNUM]= "cc",\
  [HARD_DP_REGNUM]= "dp", \
  [SOFT_FP_REGNUM]= "soft_fp", \
  [SOFT_AP_REGNUM]= "soft_ap", \
  MNAME(0) MNAME(1) MNAME(2) MNAME(3) \
  MNAME(4) MNAME(5) MNAME(6) MNAME(7) \
  [HARD_RSVD1_REGNUM] = "-", \
  [HARD_Z_REGNUM] = "z" /* bit 2 of CC */ }

/*****************************************************************************
**
** Debug Support
**
*****************************************************************************/

/* Default to DBX-style debugging */
#define PREFERRED_DEBUGGING_TYPE DBX_DEBUG

#define DBX_DEBUGGING_INFO

#define DEFAULT_GDB_EXTENSIONS 0

#define ASM_STABS_OP ";\t.stabs\t"
#define ASM_STABD_OP ";\t.stabd\t"
#define ASM_STABN_OP ";\t.stabn\t"

#define DBX_CONTIN_LENGTH 54

#define DBX_OUTPUT_MAIN_SOURCE_FILENAME(ASMFILE, FILENAME) \
  do { \
    const char *p = FILENAME; \
    while ((p = strchr (p, '/')) != NULL) { \
      p = FILENAME = p+1; \
    } \
    fprintf (ASMFILE, "%s", ASM_STABS_OP); \
    output_quoted_string (ASMFILE, FILENAME); \
    fprintf (ASMFILE, ",%d,0,0,", N_SO); \
    assemble_name (ASMFILE, ltext_label_name); \
    fputc ('\n', ASMFILE); \
    switch_to_section (text_section); \
    (*targetm.asm_out.internal_label) (ASMFILE, "Ltext", 0); \
  } while (0)

/* With -g, GCC sometimes outputs string literals that are longer than
 * the assembler can handle.  Without actual debug support, these are
 * not really required.  Redefine the function to output strings to
 * output as much as possible. */
#define OUTPUT_QUOTED_STRING(FILE, STR) m6809_output_quoted_string (FILE, STR)

/* Debugging is not really supported at the moment, so don't insist
 * on having a frame pointer just because -g is given.  If -O is
 * used, -fomit-frame-pointer is implied. */
#define CAN_DEBUG_WITHOUT_FP 1

/*****************************************************************************
**
** Output and Generation of Labels
**
*****************************************************************************/

/* Prefixes for various assembly-time objects */

#define REGISTER_PREFIX ""

#define LOCAL_LABEL_PREFIX ""

#define USER_LABEL_PREFIX "_"

#define IMMEDIATE_PREFIX "#"

/* This is how to output the definition of a user-level label named NAME,
   such as the label on a static function or variable NAME.  */

#define ASM_OUTPUT_LABEL(FILE,NAME) \
  do { \
    if (section_changed) { \
      fprintf (FILE, "\n%s\n\n", code_section_op); \
      section_changed = 0; \
    } \
    assemble_name (FILE, NAME); \
    fputs (":\n", FILE); \
  } while (0)

/* This is how to output the label for a function definition.  It
   invokes ASM_OUTPUT_LABEL, but may examine the DECL tree node for
   other properties. */
#define ASM_DECLARE_FUNCTION_NAME(FILE,NAME,DECL) \
  m6809_declare_function_name (FILE,NAME,DECL)

/* This is how to output a command to make the user-level label
   named NAME defined for reference from other files. */

#define GLOBAL_ASM_OP "\t.globl\t"

/* This is how to output a reference to a user label named NAME. */
#define ASM_OUTPUT_LABELREF(FILE,NAME) \
  fprintf (FILE, "_%s", NAME)

/* This is how to output a reference to a symbol ref
 * Check to see if the symbol is in the direct page */
#define ASM_OUTPUT_SYMBOL_REF(FILE,sym) \
  { \
    print_direct_prefix (FILE, sym); \
    assemble_name (FILE, XSTR (sym, 0)); \
  }

/* External references aren't necessary, so don't emit anything */
#define ASM_OUTPUT_EXTERNAL(FILE,DECL,NAME)

/* This is how to store into the string LABEL
   the symbol_ref name of an internal numbered label where
   PREFIX is the class of label and NUM is the number within the class.
   This is suitable for output with `assemble_name'.  */
#define ASM_GENERATE_INTERNAL_LABEL(LABEL,PREFIX,NUM) \
  sprintf (LABEL, "*%s%lu", PREFIX, (unsigned long int)NUM)

/* This is how to output a string. */ 
#define ASM_OUTPUT_ASCII(FILE,STR,SIZE) m6809_output_ascii (FILE, STR, SIZE)

/* This is how to output an insn to push a register on the stack.
   It need not be very fast code.  */

#define ASM_OUTPUT_REG_PUSH(FILE,REGNO) \
  fprintf (FILE, "\tpshs\t%s\n", reg_names[REGNO])

/* This is how to output an insn to pop a register from the stack.
   It need not be very fast code.  */

#define ASM_OUTPUT_REG_POP(FILE,REGNO) \
  fprintf (FILE, "\tpuls\t%s\n", reg_names[REGNO])

/* This is how to output an element of a case-vector that is absolute. */

#define ASM_OUTPUT_ADDR_VEC_ELT(FILE, VALUE) \
  fprintf (FILE, "\t.word\tL%u\n", VALUE)

/* This is how to output an element of a case-vector that is relative. */

#define ASM_OUTPUT_ADDR_DIFF_ELT(FILE, BODY, VALUE, REL) \
  fprintf (FILE, "\t.word\tL%u-L%u\n", VALUE, REL)


/*****************************************************************************
**
** Assembler Commands for Alignment
**
*****************************************************************************/

/* ASM_OUTPUT_SKIP is supposed to zero initialize the data.
 * So use the .byte and .word directives instead of .blkb */
#define ASM_OUTPUT_SKIP(FILE,SIZE) \
  do { \
    int __size = SIZE, __i; \
    for (__i = 0; __i < (__size&-2); __i += 2) { \
      if (!(__i&31)) { \
        if (__i) \
          putc ('\n', FILE); \
        fputs ("\t.word\t", FILE); \
      } \
      else \
        putc (',', FILE); \
      putc ('0', FILE); \
    } \
    if (__i) \
      putc ('\n', FILE); \
    if (__size&1) \
      fputs ("\t.byte\t0\n", FILE); \
  } while (0)

/* This says how to output an assembler line
   to define a global common symbol.  */

#define ASM_OUTPUT_COMMON(FILE, NAME, SIZE, ROUNDED) \
  do { \
    switch_to_section (bss_section); \
    fputs ("\t.globl\t", FILE); \
    assemble_name ((FILE), (NAME)); \
    fputc ('\n', FILE); \
    assemble_name ((FILE), (NAME)); \
    fprintf ((FILE), ":\t.blkb\t" FMT_HOST_WIDE_INT "\n", (ROUNDED)); \
  } while (0)

/* This says how to output an assembler line
   to define a local common symbol.  */

#define ASM_OUTPUT_LOCAL(FILE, NAME, SIZE, ROUNDED) \
  do { \
    switch_to_section (bss_section); \
    assemble_name ((FILE), (NAME)); \
    fprintf ((FILE), ":\t.blkb\t" FMT_HOST_WIDE_INT "\n", (ROUNDED)); \
  } while (0)

/* Store in OUTPUT a string (made with alloca) containing
   an assembler-name for a local static variable named NAME.
   LABELNO is an integer which is different for each call.  */

#define ASM_FORMAT_PRIVATE_NAME(OUTPUT, NAME, LABELNO) \
  ( (OUTPUT) = (char *) alloca (strlen ((NAME)) + 1 + sizeof(unsigned long int)*3 + 1), \
  sprintf ((OUTPUT), "%s.%lu", (NAME), (unsigned long int)(LABELNO)))

/* Print an instruction operand X on file FILE.
   CODE is the code from the %-spec for printing this operand.
   If `%z3' was used to print operand 3, then CODE is 'z'. */
#define PRINT_OPERAND(FILE, X, CODE) print_operand (FILE, X, CODE)

/* Print a memory operand whose address is X, on file FILE. */
#define PRINT_OPERAND_ADDRESS(FILE, ADDR) print_operand_address (FILE, ADDR, NULL_RTX)

/* Don't let stack pushes build up too much. */
#define MAX_PENDING_STACK 8

/* Define values for builtin operations */
enum m6809_builtins
{
    M6809_SWI,
    M6809_SWI2,
    M6809_SWI3,
    M6809_CWAI,
    M6809_SYNC,
    M6809_MUL,
    M6809_ADD_CARRY,
    M6809_SUB_CARRY,
    M6809_ADD_DECIMAL,
    M6809_NOP,
    M6809_BLOCKAGE
};

