/*-------------------------------------------------------------------
	FILE: m6809.c
-------------------------------------------------------------------*/
/* Subroutines for insn-output.c for MC6809.
   Copyright (C) 1989-2007 Free Software Foundation, Inc.

 MC6809 Version by Tom Jones (jones@sal.wisc.edu)
 Space Astronomy Laboratory
 University of Wisconsin at Madison

 minor changes to adapt it to gcc-2.5.8 by Matthias Doerfel
 ( msdoerfe@informatik.uni-erlangen.de )
 also added #pragma interrupt (inspired by gcc-6811)

 minor changes to adapt it to gcc-2.8.0 by Eric Botcazou
 (ebotcazou@multimania.com)

 minor changes to adapt it to gcc-2.95.3 by Eric Botcazou
 (ebotcazou@multimania.com)

 major cleanup, improvements, and upgrade to gcc 3.4 by Brian Dominy
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

#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "tree.h"
#include "rtl.h"
#include "tm_p.h"
#include "regs.h"
#include "flags.h"
#include "hard-reg-set.h"
#include "real.h"
#include "tree.h"
#include "insn-config.h"
#include "conditions.h"
#include "insn-flags.h"
#include "output.h"
#include "insn-attr.h"
#include "function.h"
#include "target.h"
#include "target-def.h"
#include "expr.h"
#include "recog.h"
#include "cpplib.h"
#include "c-pragma.h"
#include "toplev.h"
#include "optabs.h"
#include "version.h"
#include "df.h"
#include "rtlhooks-def.h"
#include "langhooks.h"

/* macro to return TRUE if length of operand mode is one byte */
#define BYTE_MODE(X) ((GET_MODE_SIZE (GET_MODE (X))) == 1)


/* REAL_REG_P(x) is a true if the rtx 'x' represents a real CPU
register and not a fake one that is emulated in software. */
#define REAL_REG_P(x) (REG_P(x) && !M_REG_P(x))

/*-------------------------------------------------------------------
    Target hooks, moved from target.h
-------------------------------------------------------------------*/

#undef TARGET_ENCODE_SECTION_INFO
#define TARGET_ENCODE_SECTION_INFO m6809_encode_section_info

#undef TARGET_ASM_FILE_START
#define TARGET_ASM_FILE_START m6809_asm_file_start

#undef TARGET_ASM_ALIGNED_HI_OP
#define TARGET_ASM_ALIGNED_HI_OP "\t.word\t"

#undef TARGET_ASM_ALIGNED_SI_OP
#define TARGET_ASM_ALIGNED_SI_OP NULL

#undef TARGET_ASM_UNALIGNED_HI_OP
#define TARGET_ASM_UNALIGNED_HI_OP "\t.word\t"

#undef TARGET_ASM_UNALIGNED_SI_OP
#define TARGET_ASM_UNALIGNED_SI_OP NULL

#undef TARGET_RTX_COSTS
#define TARGET_RTX_COSTS m6809_rtx_costs
#undef TARGET_ADDRESS_COST
#define TARGET_ADDRESS_COST m6809_address_cost

#undef TARGET_ATTRIBUTE_TABLE
#define TARGET_ATTRIBUTE_TABLE m6809_attribute_table

#undef TARGET_INIT_BUILTINS
#define TARGET_INIT_BUILTINS m6809_init_builtins

#undef TARGET_EXPAND_BUILTIN
#define TARGET_EXPAND_BUILTIN m6809_expand_builtin

#undef TARGET_DEFAULT_TARGET_FLAGS
#define TARGET_DEFAULT_TARGET_FLAGS (MASK_REG_ARGS | MASK_DIRECT)

#undef TARGET_FUNCTION_OK_FOR_SIBCALL
#define TARGET_FUNCTION_OK_FOR_SIBCALL m6809_function_ok_for_sibcall

#undef TARGET_ALLOCATE_STACK_SLOTS_FOR_ARGS
#define TARGET_ALLOCATE_STACK_SLOTS_FOR_ARGS m6809_allocate_stack_slots_for_args

/* External variables used */
extern int reload_completed;   /* set in toplev.c */
extern FILE *asm_out_file;

static int last_mem_size;   /* operand size (bytes) */

/* True if the section was recently changed and another .area
 * directive needs to be output before emitting the next label. */
int section_changed = 0;

/* Section names.  The defaults here are used until an
 * __attribute__((section)) is seen that changes it. */
char code_section_op[128] = "\t.area\t.text";
char data_section_op[128] = "\t.area\t.data";
char bss_section_op[128] = "\t.area\t.bss";
const char *code_bank_option = 0;

/* TRUE if the direct mode prefix might be valid in this context.
 * This is set by 'print_address' prior to calling output_addr_const,
 * which performs into 'print_direct_prefix' to do the final checks. */
static int check_direct_prefix_flag;

/* Nonzero if an address is being printed in a context which does not
 * permit any PIC modifications to the address */
static int pic_ok_for_addr_p = 1;

/* Current code page.  This supports machines which can do bank
 * switching to allow for more than 64KB of code/data. */
char far_code_page[64];

/* Current bank name */
static char current_bank_name[8] = "-1";

/* Default bank name */
static char default_code_bank_name[8] = "-1";

/* Direct memory reserved as soft registers */
unsigned int m6809_soft_regs = 0;

/* ABI version */
unsigned int m6809_abi_version = M6809_ABI_VERSION_BX;


/* Character class test functions */
static inline int isdigit(int c)
{
	return c >= '0' && c <= '9';
}
static inline int isalpha(int c)
{
	return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
}
static inline int isalnum(int c)
{
	return isalpha(c) || isdigit(c);
}


/* Return the ABI string from version number */
const char *m6809_abi_version_to_str(int version)
{
	const char *str = NULL;
	switch(version)
	{
		case M6809_ABI_VERSION_STACK:
			str = "stack";
			break;
		case M6809_ABI_VERSION_BX:
			str = "bx";
			break;
		default:
			abort();
	}
	return str;
}


/**
 * Called after options have been parsed.
 * If overrides have been specified on the command-line, then
 * these values are copied into the main storage variables.
 */
void
m6809_override_options (void)
{
	/* Handle -mfar-code-page */
	if (far_code_page_option == 0)
		far_code_page_option = "__default_code_page";
	strcpy (far_code_page, far_code_page_option);

	/* Handle -mcode-section, -mdata-section, and -mbss-section */
	if (code_section_ptr != 0)
		sprintf (code_section_op, "\t.area\t%s", code_section_ptr);
	if (data_section_ptr != 0)
		sprintf (data_section_op, "\t.area\t%s", data_section_ptr);
	if (bss_section_ptr != 0)
		sprintf (bss_section_op, "\t.area\t%s", bss_section_ptr);

	/* Handle -mcode-bank */
	if (code_bank_option != 0)
		sprintf (default_code_bank_name, "%s", code_bank_option);

	/* Handle -mabi or -mno-reg-args */
	if (m6809_abi_version_ptr != 0)
	{
		if (!strcmp (m6809_abi_version_ptr, "stack"))
			m6809_abi_version = M6809_ABI_VERSION_STACK;
		else if (!strcmp (m6809_abi_version_ptr, "regs"))
		{
			warning (WARNING_OPT "-mabi=regs deprecated; use -mabi=bx instead.");
			m6809_abi_version = M6809_ABI_VERSION_REGS;
		}
		else if (!strcmp (m6809_abi_version_ptr, "bx"))
			m6809_abi_version = M6809_ABI_VERSION_BX;
		else if (!strcmp (m6809_abi_version_ptr, "latest"))
			m6809_abi_version = M6809_ABI_VERSION_LATEST;
		else
		{
			if (!isdigit(*m6809_abi_version_ptr))
				error ("ABI version not recognized `%s'", m6809_abi_version_ptr);
			else
				m6809_abi_version = atoi (m6809_abi_version_ptr);
		}
		if (m6809_abi_version > M6809_ABI_VERSION_LATEST)
			m6809_abi_version = M6809_ABI_VERSION_LATEST;
	}

	/* The older -mno-reg-args option is deprecated,
	   and treated as -mabi=stack. */
	if (!TARGET_REG_ARGS)
	{
		warning (WARNING_OPT "-mno-reg-args deprecated; use -mabi=stack instead.");
		m6809_abi_version = M6809_ABI_VERSION_STACK;
	}

#if !CONFIG_SJLJ_EXCEPTIONS
	/* -fexceptions is unsupported */
	flag_exceptions = 0;
#endif
	flag_non_call_exceptions = 0;
	flag_unwind_tables = 0;
}


/**
 * Output prefix that directs the assembler to use a direct-mode
 * instruction if globally enabled, address is a symbol, and symbol
 * has been marked as in direct page.  Also, never do this if
 * using the indirect mode. */
void
print_direct_prefix (FILE * file, rtx addr)
{
	if (TARGET_DIRECT &&
       (GET_CODE (addr) == SYMBOL_REF) && 
       SYMBOL_REF_FLAG (addr) &&
       check_direct_prefix_flag)
   {
      putc ('*', file);
   }
}


/** Prints an operand (that is not an address) in assembly from RTL. */
void
print_operand (FILE * file, rtx x, int code)
{
	if (REG_P (x)) {
		/* gcc currently allocates the entire 16-bit 'd' register
		 * even when it only needs an 8-bit value.  So here it
		 * is tricked into printing only the lower 8-bit 'b'
		 * register into the assembly output.
		 *
		 * Eventually gcc should be modified to allocate a/b
		 * independently and this hack can be removed.
		 *
		 * Occasionally, we may want to do an operation using
		 * the 'a' register instead of 'b'; use the 'A' code
		 * to specify that.
		 */
		if (code == 'A')
			fputs ("a", file);
		else if ((BYTE_MODE (x)) && (REGNO (x) == HARD_D_REGNUM))
			fputs ("b", file);
		else if (M_REG_P (x) && code == 'L')
			/* Soft registers can be treated like memory and accessed
			 * at a particular offset. TODO : handle 'W' */
			fputs (reg_names[REGNO (x)+1], file);
		else
			fputs (reg_names[REGNO (x)], file);
	}

	else if (MEM_P (x)) {
		last_mem_size = GET_MODE_SIZE (GET_MODE (x));
		if (code == 'L') {	/* LSH of word address */
			if (GET_CODE (XEXP (x, 0)) == MEM)
			{
				/* Offseting an indirect addressing mode is not supported */
				error ("expression too complex for 6809 (offset indirect mode)");
				debug_rtx (x);
			}
			else
				x = adjust_address (x, QImode, 1);
		}
		else if (code == 'M') { /* MSH of word address */
			if (GET_CODE (XEXP (x, 0)) == MEM)
			{
				/* Offseting an indirect addressing mode is not supported */
				error ("expression too complex for 6809 (offset indirect mode)");
				debug_rtx (x);
			}
			else
				x = adjust_address (x, QImode, 0);
		}
		else if (code == 'W') { /* least significant half of 32-bit */
			x = adjust_address (x, HImode, 2);
		}

		pic_ok_for_addr_p = (code != 'C');
		output_address (XEXP (x, 0));
	}

	else if (GET_CODE (x) == CONST_DOUBLE && GET_MODE (x) != DImode) {
		union { double d; int i[2]; } u;
		u.i[0] = CONST_DOUBLE_LOW (x);
		u.i[1] = CONST_DOUBLE_HIGH (x);
		fprintf (file, "#%#9.9g", u.d);
	}

	else if (code == 'R') {
		fprintf (file, "%s", 
			m6809_get_regs_printable (INTVAL (x)));
	}

	else {
		if (code == 'L') {	/* LSH of word address */
			x = gen_rtx_CONST_INT (VOIDmode, (INTVAL(x) & 0xff));
		}
		else if (code == 'M') {	/* MSH of word address */
			x = gen_rtx_CONST_INT (VOIDmode, ((INTVAL(x) >> 8) & 0xff));
		}

		if (code != 'C')
			putc ('#', file);
		output_addr_const (file, x);
	}
}


/** Prints an address operand to assembler from its RTL representation. */
void
print_operand_address (FILE *file, rtx addr, rtx ofst)
{
	register rtx base = 0;
	register rtx offset = 0;
	int regno;
	int indirect_flag = 0;
	enum machine_mode mode;

	check_direct_prefix_flag = 0;

	/*** check for indirect addressing ***/
	if (MEM_P (addr)) {
		last_mem_size = GET_MODE_SIZE (GET_MODE (addr));
		addr = XEXP (addr, 0);
		if (pic_ok_for_addr_p)
		{
			indirect_flag = 1;
			fprintf (file, "[");
		}
	}

	switch (GET_CODE (addr)) {
		case REG:
			if (indirect_flag && ofst != NULL_RTX && INTVAL (ofst))
				output_addr_const(file, ofst);
			regno = REGNO (addr);
			fprintf (file, ",%s", reg_names[regno]);
			break;

		case PRE_DEC:
			/* We use BLKmode as a special flag to force decrement by two */
			mode = GET_MODE (addr);
			regno = REGNO (XEXP (addr, 0));
			fputs (((mode != BLKmode && last_mem_size == 1) ? ",-" : ",--"), file);
			fprintf (file, "%s", reg_names[regno]);
			break;

		case POST_INC:
			/* We use BLKmode as a special flag to force increment by two */
			mode = GET_MODE (addr);
			regno = REGNO (XEXP (addr, 0));
			fprintf (file, ",%s", reg_names[regno]);
			fputs (((mode != BLKmode && last_mem_size == 1) ? "+" : "++"), file);
			break;

		case PLUS:
			base = XEXP (addr, 0);
			if (MEM_P (base))
				base = XEXP (base, 0);

			offset = XEXP (addr, 1);
			if (MEM_P (offset))
				offset = XEXP (offset, 0);

			if ((CONSTANT_ADDRESS_P (base)) && (CONSTANT_ADDRESS_P (offset))) {
				if (!indirect_flag)
					check_direct_prefix_flag = 1;
				output_addr_const (file, base);
				check_direct_prefix_flag = 0;
				fputs ("+", file);
				output_addr_const (file, offset);
			}

			else if ((CONSTANT_ADDRESS_P (base)) && (A_REG_P (offset))) {
				output_addr_const (file, base);
				fprintf (file, ",%s", reg_names[REGNO (offset)]);
			}

			else if ((CONSTANT_ADDRESS_P (offset)) && (A_REG_P (base))) {
				output_addr_const (file, offset);
				fprintf (file, ",%s", reg_names[REGNO (base)]);
			}

			/*** accumulator offset ***/
			else if (((D_REG_P (offset)) || (Q_REG_P (offset)))
			&& (A_REG_P (base))) {
				fprintf (file, "%s,%s",
				reg_names[REGNO (offset)], reg_names[REGNO (base)]);
			}

			else if (((D_REG_P (base)) || (Q_REG_P (base)))
			&& (A_REG_P (offset))) {
				fprintf (file, "%s,%s",
				reg_names[REGNO (base)], reg_names[REGNO (offset)]);
			}

			else if (GET_CODE (base) == PRE_DEC) {
				regno = REGNO (XEXP (base, 0));
				fputs (((last_mem_size == 1) ? ",-" : ",--"), file);
				fprintf (file, "%s", reg_names[regno]);
			}

			else
				abort ();

			break;

	default:
		/* Set this global before calling output_addr_const() */
		if (!indirect_flag)
			check_direct_prefix_flag = 1;

		output_addr_const (file, addr);

		/* When printing a SYMBOL_REF in PIC mode follow it
		   by ',pcr' to enable relative addressing. */
		if (flag_pic && pic_ok_for_addr_p && (
			GET_CODE (addr) == SYMBOL_REF ||
			(GET_CODE (addr) == CONST && GET_CODE (XEXP (addr, 0)) == PLUS && (
				(GET_CODE (XEXP (XEXP (addr, 0), 0)) == SYMBOL_REF && GET_CODE (XEXP (XEXP (addr, 0), 1)) == CONST_INT) ||
				(GET_CODE (XEXP (XEXP (addr, 0), 1)) == SYMBOL_REF && GET_CODE (XEXP (XEXP (addr, 0), 0)) == CONST_INT) ))
			))
			fputs (",pcr", file);

		check_direct_prefix_flag = 0;
		break;
	}

	if (indirect_flag)
		fprintf (file, "]");
}


/*-------------------------------------------------------------------
    Update the CC Status
---------------------------------------------------------------------
   Set the cc_status for the results of an insn whose pattern is EXP.
   We assume that jumps don't affect the condition codes.
   All else, clobbers the condition codes, by assumption.

   We assume that ALL add, minus, etc. instructions effect the condition
   codes.
-------------------------------------------------------------------*/
void
notice_update_cc (rtx exp, rtx insn ATTRIBUTE_UNUSED)
{
	int src_code;
	int dst_code;

	/*** recognize SET insn's ***/
	if (GET_CODE (exp) == SET)
	{
		src_code = GET_CODE (SET_SRC (exp));
		dst_code = GET_CODE (SET_DEST (exp));

		/* Jumps do not alter the cc's.  */
		if (SET_DEST (exp) == pc_rtx)
			return;

		/* Moving one register into another register (TFR):
		Doesn't alter the cc's, But moving to X or Y via LEAX/LEAY do alter the cc's. */
		if (REG_P (SET_DEST (exp)) && (REG_P (SET_SRC (exp)))
			&& (REGSET_CONTAINS_P (REGNO (SET_DEST (exp)), (A_REGBIT | B_REGBIT | DP_REGBIT | D_REGBIT | U_REGBIT | S_REGBIT | PC_REGBIT))))
			return;

		/* Moving memory into a register (load): Sets cc's. */
		if (REG_P (SET_DEST (exp)) && src_code == MEM) {
			cc_status.value1 = SET_SRC (exp);
			cc_status.value2 = SET_DEST (exp);
			return;
		}

		/* Moving register into memory (store): Sets cc's. */
		if (dst_code == MEM && REG_P (SET_SRC (exp))) {
			cc_status.value1 = SET_SRC (exp);
			cc_status.value2 = SET_DEST (exp);
			return;
		}

		/* Function calls clobber the cc's.  */
		else if (GET_CODE (SET_SRC (exp)) == CALL) {
			CC_STATUS_INIT;
			return;
		}

		/* Tests and compares set the cc's in predictable ways.  */
		else if (SET_DEST (exp) == cc0_rtx)
		{
			cc_status.flags = 0;
			cc_status.value1 = SET_SRC (exp);
			cc_status.value2 = SET_DEST (exp);
			return;
		}

		else if (A_REG_P (SET_DEST (exp)))
		{
			CC_STATUS_INIT;
			return;
		}

		else
		{
			/* Certain instructions affect the condition codes. */
			switch (src_code)
			{
				case PLUS:
				case MINUS:
				case NEG:
				case ASHIFT:
					/* These instructions set the condition codes,
					 * and may modify the V bit. */
					cc_status.flags |= CC_NO_OVERFLOW;
					/* FALLTHRU */

				case AND:
				case IOR:
				case XOR:
				case ASHIFTRT:
				case LSHIFTRT:
					/* These instructions set the condition codes,
					 * but cannot overflow (V=0). */
					cc_status.value1 = SET_SRC (exp);
					cc_status.value2 = SET_DEST (exp);
					break;

				default:
					/* Everything else is clobbered */
					CC_STATUS_INIT;
			}
			return;
		}
	} /* SET */

	else if (GET_CODE (exp) == PARALLEL
		&& GET_CODE (XVECEXP (exp, 0, 0)) == SET)
	{
		if (SET_DEST (XVECEXP (exp, 0, 0)) == pc_rtx)
			return;
		if (SET_DEST (XVECEXP (exp, 0, 0)) == cc0_rtx)
		{
			CC_STATUS_INIT;
			cc_status.value1 = SET_SRC (XVECEXP (exp, 0, 0));
			return;
		}
	}

	/*** default action if we haven't recognized something
	and returned earlier ***/
	CC_STATUS_INIT;
}


/** Returns nonzero if the expression EXP can be implemented using one
 * of the 6809's single operand instructions. */
int
m6809_single_operand_operator (rtx exp)
{
	rtx op1;
	HOST_WIDE_INT val;
	enum rtx_code code;

	debug_rtx(exp);

	code = GET_CODE (exp);

	/* Unary operators always qualify */
	switch (code)
	{
		case NEG:
		case NOT:
			return 1;

		default:
			break;
	}

	/* Binary operators can only qualify if the second
	 * argument is a CONST_INT of certain value. */
	op1 = XEXP (exp, 1);
	if (GET_CODE (op1) != CONST_INT)
		return 0;
	val = INTVAL (op1);
	switch (code)
	{
		case PLUS:
		case MINUS:
			if (val == -1 || val == 1)
				return 1;
			break;

		case ASHIFT:
		case ASHIFTRT:
		case LSHIFTRT:
		case ROTATE:
		case ROTATERT:
			if (val == 1)
				return 1;
			break;

		default:
			break;
	}

	return 0;
}


/** Return a bitarray of the hard registers which are used by a function. */
unsigned int
m6809_get_live_regs (void)
{
	unsigned int regs = 0;
	int regno;

	if (frame_pointer_needed)
		regs |= (1 << HARD_FRAME_POINTER_REGNUM);

	for (regno = HARD_X_REGNUM; regno <= HARD_U_REGNUM; regno++)
		if (df_regs_ever_live_p (regno) && ! call_used_regs[regno])
			regs |= (1 << regno);

	return regs;
}


/** Return a printable version of a list of hard registers, suitable
 * for use in a PSHx or PULx insn. */
const char *
m6809_get_regs_printable (unsigned int regs)
{
	static char list[64];
	char *listp = list;
	unsigned int regno;

	for (regno=0; regno < FIRST_PSEUDO_REGISTER; regno++)
		if ((regs & (1 << regno)) && !S_REGNO_P (regno))
			listp += sprintf (listp,
				(listp == list) ? "%s" : ",%s", reg_names[regno]);

	return list;
}


/** Return the total number of bytes covered by a set of hard registers. */
unsigned int
m6809_get_regs_size (unsigned int regs)
{
	unsigned int regno;
	unsigned int size = 0;

	for (regno=0; regno < FIRST_PSEUDO_REGISTER; regno++)
	{
		/* Only count register in the given register set */
		if (REGSET_CONTAINS_P (regno, regs))
		{
			/* Add 1 or 2 byte, depending on the size of the register.
			 * Since 'D' may be in both sets, check for WORD_REGSET first. */
			if (WORD_REGNO_P(regno))
				size += 2;
			else if (BYTE_REGNO_P(regno))
				size++;
		}
	}
	return size;
}


/* Given the target of call instruction in X,
 * return the tree node that contains the function declaration for
 * that target.
 *
 * If the rtx or the tree do not appear valid for any reason,
 * then return NULL_TREE.
 */
static tree call_target_decl (rtx x)
{
   tree decl;

	/* Make sure the target is really a MEM. */
	if (!x || !MEM_P (x))
		return NULL_TREE;

	/* Make sure the address is a SYMBOL_REF. */
	x = XEXP (x, 0);
	if (!x || (GET_CODE (x) != SYMBOL_REF))
		return NULL_TREE;

	/* Get the declaration of this symbol */
	decl = SYMBOL_REF_DECL (x);

	/* Make sure the declaration is really a function. */
	if (!decl || (TREE_CODE(decl) != FUNCTION_DECL))
		return NULL_TREE;

   return decl;
}


/** Returns nonzero if a function, whose declaration is in DECL,
 * was declared to have the attribute given by ATTR_NAME. */
int
m6809_function_has_type_attr_p (tree decl, const char *attr_name)
{
	tree type;

	type = TREE_TYPE (decl);
	return lookup_attribute (attr_name, TYPE_ATTRIBUTES (type)) != NULL;
}



/** Returns nonzero if the current function was declared to have the
 * attribute given by ATTR_NAME. */
int
m6809_current_function_has_type_attr_p (const char *attr_name)
{
	return m6809_function_has_type_attr_p (current_function_decl, attr_name);
}


/** Return nonzero if the current function has no return value. */
int
m6809_current_function_is_void (void)
{
   return (VOID_TYPE_P (TREE_TYPE (TREE_TYPE (current_function_decl))));
}


/** Get the value of a declaration's 'bank', as set by the 'bank'
 * attribute.  If no bank was declared, it returns NULL by default. */
static const char *
m6809_get_decl_bank (tree decl)
{
	tree attr;

	/* Lookup the 'bank' attribute.  If it does not exist, then
	 * return NULL */
	attr = lookup_attribute ("bank", DECL_ATTRIBUTES (decl));
	if (attr == NULL_TREE)
		return NULL;

	/* Make sure it has a value assigned to it */
	attr = TREE_VALUE (attr);
	if (attr == NULL_TREE)
	{
		warning (WARNING_OPT "banked function did not declare a bank number");
		return NULL;
	}

	/* Return the bank name */
	attr = TREE_VALUE (attr);
	return TREE_STRING_POINTER (attr);
}


void
m6809_declare_function_name (FILE *asm_out_file, const char *name, tree decl)
{
	/* Check the function declaration for special properties.
	 *
	 * If the function was declare with __attribute__((bank)), output
	 * assembler definitions to force the function to go into the named
	 * bank.
	 */
	const char *bank_name = m6809_get_decl_bank (decl);
	if (bank_name != NULL)
	{
		/* Declare __self_bank as a local assembler value that denotes
		 * which bank the current function is in.  This is required only
		 * when the bank actually changes. */
		if (strcmp (bank_name, current_bank_name))
		{
			fprintf (asm_out_file, "__self_bank\t.equ\t%s\n", bank_name);
			strcpy (current_bank_name, bank_name);
		}

		/* Declare a global assembler value that denotes which bank the
		 * named function is in. */
		fprintf (asm_out_file, "__%s_bank\t.gblequ\t%s\n", name, bank_name);

		/* Force the current function into a new area */
		fprintf (asm_out_file, "\t.bank\tbank_%s (FSFX=_%s)\n",
			bank_name, bank_name);
		fprintf (asm_out_file, "\t.area\tbank_%s (BANK=bank_%s)\n",
			bank_name, bank_name);
	}

	/* Emit the label for the function's name */
	ASM_OUTPUT_LABEL (asm_out_file, name);
}


/**
 * Handle pragmas.  Note that only the last branch pragma seen in the 
 * source has any affect on code generation.  
 */
#define BAD_PRAGMA(msgid, arg) \
	do { warning (WARNING_OPT msgid, arg); return -1; } while (0)

static int
pragma_parse (const char *name, tree *sect)
{
  tree s, x;

  if (pragma_lex (&x) != CPP_OPEN_PAREN)
    BAD_PRAGMA ("missing '(' after '#pragma %s' - ignored", name);

  if (pragma_lex (&s) != CPP_STRING)
    BAD_PRAGMA ("missing section name in '#pragma %s' - ignored", name);

  if (pragma_lex (&x) != CPP_CLOSE_PAREN)
    BAD_PRAGMA ("missing ')' for '#pragma %s' - ignored", name);

  if (pragma_lex (&x) != CPP_EOF)
    warning (WARNING_OPT "junk at end of '#pragma %s'", name);

  *sect = s;
  return 0;
}


/*
 * Handle #pragma section.
 * This is deprecated; code should use __attribute__(section("name"))
 * instead.
 */
void pragma_section (cpp_reader *pfile);
void pragma_section (cpp_reader *pfile ATTRIBUTE_UNUSED)
{
	tree sect;

	if (pragma_parse ("section", &sect))
		return;

	snprintf (code_section_op, 6+TREE_STRING_LENGTH (sect),
		".area\t%s", TREE_STRING_POINTER (sect));
	snprintf (data_section_op, 6+TREE_STRING_LENGTH (sect),
		".area\t%s", TREE_STRING_POINTER (sect));

	/* Mark a flag that sections have changed.  Upon emitting another
	 * declaration, the new .area directive will be written. */
	section_changed++;
}


/**
 * Check a `double' value for validity for a particular machine mode.
 * Called by the CHECK_FLOAT_VALUE() machine-dependent macro.
 */
int
check_float_value (enum machine_mode mode, double *d, int overflow)
{
	if (mode == SFmode) {
		if (*d > 1.7014117331926443e+38) {
			error("magnitude of constant too large for `float'");
			*d = 1.7014117331926443e+38;
		}
		else if (*d < -1.7014117331926443e+38) {
			error("magnitude of constant too large for `float'");
			*d = -1.7014117331926443e+38;
		}
		else if ((*d > 0) && (*d < 2.9387358770557188e-39)) {
			warning(WARNING_OPT "`float' constant truncated to zero");
			*d = 0.0;
		}
		else if ((*d < 0) && (*d > -2.9387358770557188e-39)) {
			warning(WARNING_OPT "`float' constant truncated to zero");
			*d = 0.0;
		}
	}
	return overflow;
}



/** Declare that the target supports named output sections. */
bool m6809_have_named_section = (bool)1;


/** Write to the assembler file a directive to place
 * subsequent objects to a different section in the
 * object file.  ASxxxx uses the "area" directive for
 * this purpose.  It does not however support generalized
 * alignment, and can only place items on an odd/even
 * boundary. */
void
m6809_asm_named_section (
	const char *name, 
	unsigned int flags ATTRIBUTE_UNUSED,
	tree decl ATTRIBUTE_UNUSED)
{
	fprintf (asm_out_file, "\t.area\t%s\n", name);
}


enum reg_class
m6809_preferred_reload_class (rtx x, enum reg_class regclass)
{
	/* Check cases based on type code of rtx */
	switch (GET_CODE(x))
	{
		case CONST_INT:
		   /* Constants that can fit into 1 byte should be
			 * loaded into a Q_REGS reg */
			if ((INTVAL(x) >= -128 && INTVAL(x) <= 127) &&
  				 (regclass > A_REGS))
      		return Q_REGS;

			/* 16-bit constants should be loaded into A_REGS
			 * when possible.  gcc may already require A_REGS
			 * or D_REGS for certain types of instructions.
			 * This case applies mostly to simple copy operations
			 * to/from memory when any register will do, but
			 * it's best to avoid using D register since it is
			 * needed for other things.
			 */
			else if ((INTVAL(x) >= -32768 && INTVAL(x) <= 32767) &&
  				 (regclass > A_REGS))
      		return A_REGS;
			break;

		case SYMBOL_REF:
		case LABEL_REF:
			/* Addresses should always be loaded into A_REGS */
			if (regclass >= A_REGS)
				return (A_REGS);

		default:
			break;
	}

	/* Check cases based on mode of rtx */
   if ((GET_MODE(x) == QImode) && (regclass != A_REGS))
      return Q_REGS;

	/* Default: return whatever class reload suggested */
   return regclass;
}


/**
 * Check a new declaration for the "section" attribute.
 * If it exists, and the target section is ".direct", then mark
 * the declaration (in RTL) to indicate special treatment.
 * When the variable is referenced later, we test for this flag
 * and can emit special asm text to force the assembler to use
 * short instructions.
 */
static void
m6809_encode_section_info (tree decl, rtx rtl ATTRIBUTE_UNUSED, int first ATTRIBUTE_UNUSED)
{
   tree attr, id;
   const char *name;
   /*const char *decl_name;*/

   /* We only care about variable declarations, not functions */
   if (TREE_CODE (decl) != VAR_DECL)
      return;

	/* For debugging purposes only; grab the decl's name */
   /*decl_name = IDENTIFIER_POINTER (DECL_NAME (decl));*/

	/* Give up if the decl doesn't have any RTL */
   if (!DECL_RTL (decl))
      return;

	/* See if it has a section attribute */
   attr = lookup_attribute ("section", DECL_ATTRIBUTES (decl));
   if (!attr)
      return;

	/* See if the section attribute has a value */
   id = TREE_VALUE (TREE_VALUE (attr));
   if (!id)
      return;
   name = TREE_STRING_POINTER (id);
   if (!name)
      return;

	/* See if the value is 'direct'.  If so, mark it. */
   if (!strcmp (name, ".direct"))
      SYMBOL_REF_FLAG (XEXP (DECL_RTL (decl), 0)) = 1;
}


/**
 * Output code to perform a complex shift, for which there is no
 * direct support in the instruction set.
 *
 * shift1 is an instruction pattern for performing a 1-bit modification.
 * This code wraps that pattern in a loop to perform the shift N times,
 * where N is given by the address register in operands[2].
 *
 * To support 16-bit shifts, shift2 can also be provided: it is
 * a second instruction to be included in the loop.  8-bit shift
 * insns will pass NULL here.
 *
 * The insn length of shift1/shift2 is assumed to be 1 byte,
 * which works in all of the cases it is needed so far.
 */
static void
m6809_gen_register_shift (
		rtx *operands,
		const char *shift1,
		const char *shift2 )
{
  
	char beq_pattern[32];
	char bra_pattern[32];
	int shiftlen = (shift1 && shift2) ? 2 : 1;
  
  if (GET_MODE (operands[0]) == QImode)
  {
        int cmplen = 2; // reg a immediate	
	int beq_offset = 2 + shiftlen + 2;
	int bra_offset = shiftlen + 2 + cmplen + 1; // 1 is an immediate compare with  Reg A

	sprintf (beq_pattern, "beq\t.+%d", beq_offset);
	sprintf (bra_pattern, "bra\t.-%d", bra_offset);

	output_asm_insn ("lda\t%2; reg a not used anyway", operands);
        output_asm_insn ("deca", operands);
        output_asm_insn ("cmpa\t#-1", operands);
        output_asm_insn (beq_pattern, operands);
	if (shift1)
		output_asm_insn (shift1, operands);
	if (shift2)
		output_asm_insn (shift2, operands);
	output_asm_insn (bra_pattern, operands);
  }
  else
  {
	int cmplen = (REGNO (operands[2]) == HARD_X_REGNUM) ? 3 : 4;

	int beq_offset = 2 + shiftlen + 2;
	int bra_offset = shiftlen + 2 + cmplen + 2; 
        sprintf (beq_pattern, "beq\t.+%d", beq_offset);
	sprintf (bra_pattern, "bra\t.-%d", bra_offset);

	output_asm_insn ("pshs\t%2", operands);
	output_asm_insn ("lea%2\t-1,%2", operands);
        output_asm_insn ("cmp%2\t#-1", operands);

        output_asm_insn (beq_pattern, operands);
	if (shift1)
		output_asm_insn (shift1, operands);
	if (shift2)
		output_asm_insn (shift2, operands);
	output_asm_insn (bra_pattern, operands);
	output_asm_insn ("puls\t%2", operands);
  }
}


/** Generate RTL for the upper 8-bits of a 16-bit constant. */
rtx
gen_rtx_const_high (rtx r)
{
   unsigned char v = (INTVAL (r) >> 8) & 0xFF;
	signed char s = (signed char)v;
   return gen_int_mode (s, QImode);
}


/** Generate RTL for the lower 8-bits of a 16-bit constant. */
rtx
gen_rtx_const_low (rtx r)
{
   unsigned char v = INTVAL (r) & 0xFF;
	signed char s = (signed char)v;
   return gen_int_mode (s, QImode);
}


/** Generate RTL to allocate/free bytes on the stack.
 * CODE is given as MINUS when allocating and PLUS when freeing,
 * to match the semantics of a downward-growing stack.  SIZE
 * is always given as a positive integer.
 */
static rtx
gen_rtx_stack_adjust (enum rtx_code code, int size)
{
	if (size <= 0)
		return NULL_RTX;

	if (code == MINUS)
		size = -size;

	return gen_rtx_SET (Pmode, stack_pointer_rtx, 
		gen_rtx_PLUS (Pmode, stack_pointer_rtx,
			gen_int_mode (size, HImode)));
}


/** Generate RTL to push/pop a set of registers. */
rtx
gen_rtx_register_pushpop (int op, int regs)
{
	rtx nregs = gen_int_mode (regs, QImode);
	
	if (op == UNSPEC_PUSH_RS)
		return gen_register_push (nregs);
	else
		return gen_register_pop (nregs);
}


/* Given a register set REGS, where the bit positions correspond to
 * hard register numbers, return another bitmask that represents the
 * order in which those registers would be pushed/popped.
 * Registers that are pushed first have higher bit positions.
 * The pop order is just the reverse bitmask.
 * These values are the same as the bitmasks actually used in the
 * machine instructions. */
static unsigned int
register_push_order (int regs)
{
	unsigned int order = 0;

	if (REGSET_CONTAINS_P (HARD_PC_REGNUM, regs))
		order |= 0x80;
	if (REGSET_CONTAINS_P (HARD_U_REGNUM, regs))
		order |= 0x40;
	if (REGSET_CONTAINS_P (HARD_Y_REGNUM, regs))
		order |= 0x20;
	if (REGSET_CONTAINS_P (HARD_X_REGNUM, regs))
		order |= 0x10;
	if (REGSET_CONTAINS_P (HARD_DP_REGNUM, regs))
		order |= 0x8;
	if (REGSET_CONTAINS_P (HARD_B_REGNUM, regs))
		order |= 0x4;
	if (REGSET_CONTAINS_P (HARD_A_REGNUM, regs))
		order |= 0x2;
	if (REGSET_CONTAINS_P (HARD_CC_REGNUM, regs))
		order |= 0x1;

	if (REGSET_CONTAINS_P (HARD_D_REGNUM, regs))
		order |= (0x4 | 0x2);
	return order;
}


/* Returns nonzero if two consecutive push or pop instructions,
 * as determined by the OP, can be merged into a single instruction.
 * The first instruction in the sequence pushes/pops REGS1; the
 * second applies to REGS2.
 *
 * If true, the resulting instruction can use (regs1 | regs2)
 * safely.
 */
int
m6809_can_merge_pushpop_p (int op, int regs1, int regs2)
{
	/* Register sets must not overlap */
	if (regs1 & regs2)
		return 0;

	if (op == UNSPEC_PUSH_RS)
		return (register_push_order (regs1) > register_push_order (regs2));
	else if (op == UNSPEC_POP_RS)
		return (register_push_order (regs1) < register_push_order (regs2));
	else
		return 0;
}


/** Emit instructions for making a library call.
 * MODE is the mode of the operation.
 * NAME is the library function name.
 * OPERANDS is the rtx array provided by the recognizer.
 * COUNT is the number of input operands to the call, and
 * should be 1 for a unary op or 2 for a binary op.
 */
void emit_libcall_insns (enum machine_mode mode, 
	const char *name, 
	rtx *operands,
	int count)
{
	/* Generate an rtx for the call target. */
	rtx symbol = gen_rtx_SYMBOL_REF (Pmode, name);

	
	/* Emit the library call.  Slightly different based
	on the number of operands */
	if (count == 2)
		emit_library_call (symbol, 0, mode, 2, operands[1], mode, operands[2], mode);
	else
		emit_library_call (symbol, 0, mode, 1, operands[1], mode);

	/* The library call is expected to put its result
	in LIBCALL_VALUE, so need to copy it into the destination. */
	
	if (mode == QImode)
	  emit_move_insn (operands[0], gen_rtx_REG (mode, HARD_D_REGNUM));
	else
	  emit_move_insn (operands[0], LIBCALL_VALUE(mode));
}


/**
 * A small helper function that writes out a single branch instruction.
 * OPCODE is the short name, e.g. "ble".
 * OPERANDS has the rtx for the target label.
 * LONG_P is nonzero if we are emitting a long branch, and need to
 * prepend an 'l' to the opcode name.
 */
static void
output_branch_insn1 (const char *opcode, rtx *operands, int long_p)
{
	char pattern[64];
	sprintf (pattern, "%s%s\t%%l0", long_p ? "l" : "", opcode);
	output_asm_insn (pattern, operands);
}

/**
 * Output a branch/conditional branch insn of the proper
 * length.  code identifies the particular branch insn.
 * operands holds the branch target in operands[0].
 * length says what the size of this insn should be.
 * Based on the length, we know whether it should be a
 * short (8-bit) or long (16-bit) branch.
 */
const char *
output_branch_insn (enum rtx_code code, rtx *operands, int length)
{
	int shortform; 

	/* Decide whether or not to use the long or short form.
	 * Calculate automatically based on insn lengths. */
   shortform = ((length > 2) ? 0 : 1);

	/* Determine the proper opcode.
	 * Use the short (2-byte) opcode if the target is within
	 * reach.  Otherwise, use jmp (3-byte opcode), unless
	 * compiling with -fpic, in which case we'll need to use
	 * lbra (4-byte opcode).
	 */
	switch (code)
	{
		case LABEL_REF:
			/* Let the assembler try to optimize long to short branch. */
			output_branch_insn1 ("bra", operands, !shortform);
			/*if (shortform)
				output_branch_insn1 ("bra", operands, 0);
			else if (flag_pic)
				output_branch_insn1 ("bra", operands, 1);
			else
				output_branch_insn1 ("jmp", operands, 0);*/
			break;
		case EQ:
			output_branch_insn1 ("beq", operands, !shortform);
			break;
		case NE:
			output_branch_insn1 ("bne", operands, !shortform);
			break;
		case GT:
			output_branch_insn1 ("bgt", operands, !shortform);
			break;
		case GTU:
			output_branch_insn1 ("bhi", operands, !shortform);
			break;
		case LT:
			if (cc_prev_status.flags & CC_NO_OVERFLOW)
			{
				output_branch_insn1 ("bmi", operands, !shortform);
			}
			else
			{
				output_branch_insn1 ("blt", operands, !shortform);
			}
			break;
		case LTU:
			output_branch_insn1 ("blo", operands, !shortform);
			break;
		case GE:
			if (cc_prev_status.flags & CC_NO_OVERFLOW)
			{
				output_branch_insn1 ("bpl", operands, !shortform);
			}
			else
			{
				output_branch_insn1 ("bge", operands, !shortform);
			}
			break;
		case GEU:
			output_branch_insn1 ("bhs", operands, !shortform);
			break;
		case LE:
			if (cc_prev_status.flags & CC_NO_OVERFLOW)
			{
				output_branch_insn1 ("bmi", operands, !shortform);
				output_branch_insn1 ("beq", operands, !shortform);
			}
			else
			{
				output_branch_insn1 ("ble", operands, !shortform);
			}
			break;
		case LEU:
			output_branch_insn1 ("bls", operands, !shortform);
			break;
		default:
			abort();
			break;
	}
	return "";
}


/** Returns the "cost" of an RTL expression.
 * In general, the expression "COSTS_N_INSNS(1)" is used to represent
 * the cost of a fast 8-bit arithmetic instruction that operates on
 * a reg/mem or a reg/immed.  Other costs are relative to this.
 *
 * Notes:
 * - The cost of a REG is always zero; this cannot be changed.
 *
 * - On the 6809, instructions on two registers will nearly always take
 *   longer than those that operate on a register and a constant/memory,
 *   because of the way the instruction set is structured.
 *
 * TODO: multiply HImode by 2 should be done via shifts, instead of add.
 */
static bool
m6809_rtx_costs (rtx X, int code, int outer_code ATTRIBUTE_UNUSED,
	int *total)
{
	int has_const_arg = 0;
	HOST_WIDE_INT const_arg = 0;
	enum machine_mode mode;
	int nargs = 1;
	rtx op0, op1;

	/* Data RTXs return a value between 0-3, depending on complexity.
	All of these are less than COSTS_N_INSNS(1). */
	switch (code)
	{
		case CC0:
		case PC:
			*total = 0;
			return true;

 		case CONST_INT:
    		if (X == const0_rtx)
			{
				*total = 0;
				return true;
			}
			else if ((unsigned) INTVAL (X) < 077)
			{
				*total = 1;
				return true;
			}
			else
			{
				*total = 2;
				return true;
			}

 		case LABEL_REF: case CONST:
   		*total = 2;
			return true;

 		case SYMBOL_REF:
			/* References to memory are made cheaper if they have
			 * the 'direct' mode attribute set */
			*total = (SYMBOL_REF_FLAG (X)) ? 1 : 2;
			return true;

		case MEM:
			/* See what form of address was given */
			X = XEXP (X, 0);
			switch (GET_CODE (X))
			{
 				case SYMBOL_REF:
					*total = (SYMBOL_REF_FLAG (X)) ? 1 : 2;
					break;

				case CONST_INT:
					*total = 2;
					break;

				case MEM:
					*total = COSTS_N_INSNS (1) + 2;
					break;

				default:
					break;
			}
			return true;

 		case CONST_DOUBLE:
			/* TODO : not sure about this value. */
   		*total = 3;
			return true;

		default:
			break;
	}

	/* Decode the rtx */
	mode = GET_MODE (X);
	op0 = XEXP (X, 0);
	op1 = XEXP (X, 1);

	/* We don't implement anything in SImode or greater. */
	if (GET_MODE_SIZE (mode) >= GET_MODE_SIZE (SImode))
	{
		*total = COSTS_N_INSNS (100);
		return true;
	}

	/* Figure out if there is a constant argument, and its value. */
	if (GET_RTX_CLASS (code) == RTX_BIN_ARITH
		|| GET_RTX_CLASS (code) == RTX_COMM_ARITH)
	{
		nargs = 2;
		if (GET_CODE (op1) == CONST_INT)
		{
			has_const_arg = 1;
			const_arg = INTVAL (op1);
		}
	}

	/* Penalize a reg/reg operation by adding MEMORY_MOVE_COST,
	 * Ignore soft registers, since these are really in memory.
	 *
	 * TODO: penalize HImode reg/reg for most operations, except maybe
	 * additions since index registers allow for that.
	 *
	 * TODO: shifts by constant N do not always require N instructions;
	 * some of this can be done cheaper.  The number of actual insns can be
	 * predicted well.
	 */
	if (nargs == 2 && REAL_REG_P (op0) && REAL_REG_P (op1))
	{
		*total = MEMORY_MOVE_COST (mode, Q_REGS, 0);
	}
	else
	{
		*total = 0;
	}

	/* Operator RTXs are counted as COSTS_N_INSNS(N), where N is
	the estimated number of actual machine instructions needed to
	perform the computation.  Some small adjustments are made since
	some "instructions" are more complex than others. */
	switch (code)
	{
		case PLUS: case MINUS: case COMPARE:
			/* 6809 handles these natively in QImode, and in HImode as long
			 * as operand 1 is constant. */
			if (mode == QImode || (mode == HImode && has_const_arg))
				*total += COSTS_N_INSNS (1);
			else 
				*total += COSTS_N_INSNS (GET_MODE_SIZE (mode));

			/* -1, 0, and 1 can be done using inherent instructions
			 * for PLUS and MINUS in QImode, so don't add extra cost. */
  			if (has_const_arg
				&& (mode == QImode || mode == HImode)
				&& (const_arg == -1 || const_arg == 0 || const_arg == 1)
				&& (code == PLUS || code == MINUS))
			{
				return true;
			}
			break;

		case AND: case IOR: case XOR:
		case NEG: case NOT:
			/* 6809 handles these natively in QImode, but requires
			 * splitting in HImode.   Treat these as 2 insns. */
			*total += COSTS_N_INSNS (1) * GET_MODE_SIZE (mode);
			break;

  		case ASHIFT: case ASHIFTRT: case LSHIFTRT:
  		case ROTATE: case ROTATERT:
			/* 6809 can do shift/rotates of a QImode by a constant in
			 * 1 insn times the shift count, or in HImode by a constant 
			 * by splitting to 2 insns.
			 *
			 * Shift by a nonconstant will take significantly longer
			 * than any of these. */
  			if (has_const_arg)
			{
				const_arg %= (GET_MODE_SIZE (mode) * 8);

				/* HImode shifts greater than 8 get optimized due
				 * to register transfer from b to a; this cuts down the
				 * cost. */
				if (const_arg >= 8)
				{
					*total += COSTS_N_INSNS (1);
					const_arg -= 8;
				}

				/* The computed cost is 'const_arg' 1-bit shifts, doubled
				if in HImode, minus the cost of the constant itself which
				will be added in later but really shouldn't be. */
				*total += COSTS_N_INSNS (const_arg) * GET_MODE_SIZE (mode) - 1;
				return true;
			}
			else
			{
				/* It may take up to 7 iterations of about 6-7 real
				 * instructions, so make this expensive. */
				*total += COSTS_N_INSNS (50);
			}
  			break;

		case MULT:
 		{
 			/* Multiply is cheap when both arguments are 8-bits.  They
 			could be QImode, or QImode widened to HImode, or a constant
 			that fits into 8-bits.  As long as both operands qualify,
 			we can use a single mul instruction.
  
 			Assume that fast multiply can be used, and change this if we find
 			differently... */
 			int ok_for_qihi3 = 1;
  
 			/* Check the first operand */	
 			switch (GET_MODE (op0))
 			{
 				case QImode:
 					break;
 				case HImode:
 					if (GET_CODE (op0) != SIGN_EXTEND && GET_CODE (op0) != ZERO_EXTEND)
  						ok_for_qihi3 = 0;
 					break;
 				default:
 					ok_for_qihi3 = 0;
 					break;
  			}
 
			/* Likewise, check the second operand.  This is where constants may appear. */
 			switch (GET_MODE (op1))
 			{
 				case QImode:
 					break;
 				case HImode:
					if (GET_CODE (op1) != SIGN_EXTEND && GET_CODE (op1) != ZERO_EXTEND)
 						ok_for_qihi3 = 0;
 					break;
 				case VOIDmode:
					if (!CONST_OK_FOR_LETTER_P (const_arg, 'K'))
 						ok_for_qihi3 = 0;
					break;
 				default:
 					ok_for_qihi3 = 0;
 					break;
 			}
 
 			/* Fast multiply takes about 4 times as many cycles as a normal
 			arithmetic operation.  Otherwise, it will take an expensive libcall. */
 			if (ok_for_qihi3)
 				*total += COSTS_N_INSNS (4);
 			else
 				*total = COSTS_N_INSNS (50);
  	  		break;
 		}

		case DIV: case UDIV: case MOD: case UMOD:
			/* These all require more expensive libcalls. */
			*total += COSTS_N_INSNS (100);
  			break;

		/* TODO : TRUNCATE, SIGN_EXTEND, and ZERO_EXTEND */

		/* These can normally be done with autoincrement, etc., so
		 * don't charge for them. */
		case PRE_DEC:
		case PRE_INC:
		case POST_DEC:
		case POST_INC:
			break;

		default:
			break;
	}

	/* Always return false, and let the caller gather the costs
	 * of the operands */
	return false;
}

/* Return the cost of an address RTX. */

static int m6809_address_cost (rtx addr)
{
  int cost = 1; /* 0 was pretty good */

	if (MEM_P (addr))
	{
		addr = XEXP (addr, 0);
		cost += 2;
	}

	if (REGISTER_ADDRESS_P (addr))
		cost += 4;
	else if (PUSH_POP_ADDRESS_P (addr))
		cost = 0;
	else if (EXTENDED_ADDRESS_P (addr))
		cost += 2;
	else if (INDEXED_ADDRESS (addr))
	{
		int opnum;
		cost += 8;
		for (opnum=0; opnum < 2; opnum++)
		{
			rtx operand = XEXP (addr, opnum);
			if (CONSTANT_ADDRESS_P (operand) && GET_CODE (operand) == CONST_INT)
			{
				if ((unsigned) INTVAL (operand) < 16)
					cost -= 2;
				break;
			}
		}
	}
	return cost;
}


static tree
m6809_handle_fntype_attribute (tree *node, tree name,
	tree args,
	int flags ATTRIBUTE_UNUSED,
	bool *no_add_attrs)
{
	if (TREE_CODE (*node) != FUNCTION_TYPE)
	{
		warning (WARNING_OPT "'%s' only valid for functions", 
			IDENTIFIER_POINTER (name));
		*no_add_attrs = TRUE;
	}

	if (!strcmp (IDENTIFIER_POINTER (name), "interrupt"))
	{
		if (args != NULL_TREE)
		{
			tree value = TREE_VALUE (args);
			if (TREE_CODE (value) != STRING_CST)
			{
				warning (OPT_Wattributes,
					"argument of %qs attribute is not a string constant",
					IDENTIFIER_POINTER (name));
				*no_add_attrs = TRUE;
			}
			else if (strcmp (TREE_STRING_POINTER (value), "firq"))
			{
				warning (OPT_Wattributes,
					"argument of %qs attribute is not \"firq\"",
					IDENTIFIER_POINTER (name));
				*no_add_attrs = TRUE;
			}
		}
	}

	return NULL_TREE;
}


static tree
m6809_handle_data_type_attribute (tree *node ATTRIBUTE_UNUSED,
	tree name ATTRIBUTE_UNUSED,
	tree args ATTRIBUTE_UNUSED,
	int flags ATTRIBUTE_UNUSED,
	bool *no_add_attrs ATTRIBUTE_UNUSED)
{
	return NULL_TREE;
}



static tree
m6809_handle_default_attribute (tree *node ATTRIBUTE_UNUSED, 
	tree name ATTRIBUTE_UNUSED,
	tree args ATTRIBUTE_UNUSED,
	int flags ATTRIBUTE_UNUSED,
	bool *no_add_attrs ATTRIBUTE_UNUSED )
{
	return NULL_TREE;
}


/* Table of valid machine attributes */
const struct attribute_spec m6809_attribute_table[] = { /*
{ name,        min, max, decl,  type, fntype, handler } */
{ "interrupt", 0,   1,   false, true,  true,  m6809_handle_fntype_attribute },
{ "naked",     0,   0,   false, true,  true,  m6809_handle_fntype_attribute },
{ "far",       0,   1,   false, true,  true,  m6809_handle_fntype_attribute },
{ "bank",      0,   1,   true,  false, false, m6809_handle_default_attribute },
{ "boolean",   0,   0,   false, true,  false, m6809_handle_data_type_attribute },
{ NULL,        0,   0,   false, true,  false, NULL },
};


/** Initialize builtin routines for the 6809. */
void
m6809_init_builtins (void)
{
	/* Create type trees for each function signature required.
	 *
	 * void_ftype_void = void f(void)
	 * void_ftype_uchar = void f(unsigned char)
	 * uchar_ftype_uchar2 = unsigned char f (unsigned char, unsigned char)
	 * uint_ftype_uchar2 = unsigned int f (unsigned char, unsigned char)
	 */
	tree void_ftype_void =
		build_function_type (void_type_node, void_list_node);

	tree void_ftype_uchar =
		build_function_type (void_type_node,
			tree_cons (NULL_TREE, unsigned_char_type_node, void_list_node));

	tree uchar_ftype_uchar2 =
		build_function_type (unsigned_char_type_node,
			tree_cons (NULL_TREE, unsigned_char_type_node,
				tree_cons (NULL_TREE, unsigned_char_type_node, void_list_node)));

	tree uint_ftype_uchar2 =
		build_function_type (unsigned_type_node,
			tree_cons (NULL_TREE, unsigned_char_type_node,
				tree_cons (NULL_TREE, unsigned_char_type_node, void_list_node)));

	/* Register each builtin function. */
	add_builtin_function ("__builtin_swi", void_ftype_void,
		M6809_SWI, BUILT_IN_MD, NULL, NULL_TREE);

	add_builtin_function ("__builtin_swi2", void_ftype_void,
		M6809_SWI2, BUILT_IN_MD, NULL, NULL_TREE);

	add_builtin_function ("__builtin_swi3", void_ftype_void,
		M6809_SWI3, BUILT_IN_MD, NULL, NULL_TREE);

	add_builtin_function ("__builtin_cwai", void_ftype_uchar,
		M6809_CWAI, BUILT_IN_MD, NULL, NULL_TREE);

	add_builtin_function ("__builtin_sync", void_ftype_void,
		M6809_SYNC, BUILT_IN_MD, NULL, NULL_TREE);

	add_builtin_function ("__builtin_mul", uint_ftype_uchar2,
		M6809_MUL, BUILT_IN_MD, NULL, NULL_TREE);

	add_builtin_function ("__builtin_nop", void_ftype_void,
		M6809_NOP, BUILT_IN_MD, NULL, NULL_TREE);

	add_builtin_function ("__builtin_blockage", void_ftype_void,
		M6809_BLOCKAGE, BUILT_IN_MD, NULL, NULL_TREE);

	add_builtin_function ("__builtin_add_decimal", uchar_ftype_uchar2,
		M6809_ADD_DECIMAL, BUILT_IN_MD, NULL, NULL_TREE);

	add_builtin_function ("__builtin_add_carry", uchar_ftype_uchar2,
		M6809_ADD_CARRY, BUILT_IN_MD, NULL, NULL_TREE);

	add_builtin_function ("__builtin_sub_carry", uchar_ftype_uchar2,
		M6809_SUB_CARRY, BUILT_IN_MD, NULL, NULL_TREE);
}


/** Used by m6809_expand_builtin, given a tree ARGLIST which
 * refers to the operands of a builtin call, return an rtx
 * that represents the nth operand, as denoted by OPNUM, which
 * is a zero-based integer.  MODE gives the expected mode
 * of the operand.
 *
 * This rtx is suitable for use in the emitted RTL for the
 * builtin instruction. */
static rtx
m6809_builtin_operand (tree arglist, enum machine_mode mode, int opnum)
{
	tree arg;
	rtx r;

	arg = CALL_EXPR_ARG (arglist, opnum);

	/* Convert the tree to RTL */
	r = expand_expr (arg, NULL_RTX, mode, 0);
	if (r == NULL_RTX)
		return NULL_RTX;
	return r;
}


/** Expand a builtin that was registered in init_builtins into
 * RTL.  */
rtx
m6809_expand_builtin (tree exp, 
	rtx target, 
	rtx subtarget ATTRIBUTE_UNUSED,
	enum machine_mode mode ATTRIBUTE_UNUSED,
	int ignore ATTRIBUTE_UNUSED )
{
   tree fndecl = TREE_OPERAND (CALL_EXPR_FN (exp), 0);
	tree arglist = exp;
	unsigned int fcode = DECL_FUNCTION_CODE (fndecl);
	rtx r0, r1;

	switch (fcode)
	{
		case M6809_SWI:
			r0 = gen_rtx_CONST_INT (VOIDmode, 1);
			emit_insn (target = gen_m6809_swi (r0));
			return target;

		case M6809_SWI2:
			r0 = gen_rtx_CONST_INT (VOIDmode, 2);
			emit_insn (target = gen_m6809_swi (r0));
			return target;

		case M6809_SWI3:
			r0 = gen_rtx_CONST_INT (VOIDmode, 3);
			emit_insn (target = gen_m6809_swi (r0));
			return target;

		case M6809_CWAI:
			r0 = m6809_builtin_operand (arglist, QImode, 0);
			emit_insn (target = gen_m6809_cwai (r0));
			return target;

		case M6809_SYNC:
			emit_insn (target = gen_m6809_sync ());
			return target;

		case M6809_MUL:
			r0 = m6809_builtin_operand (arglist, QImode, 0);
			r1 = m6809_builtin_operand (arglist, QImode, 1);
			if (!target)
				target = gen_reg_rtx (HImode);
			emit_insn (gen_m6809_mul (target, r0, r1));
			return target;

		case M6809_ADD_CARRY:
			r0 = m6809_builtin_operand (arglist, QImode, 0);
			r1 = m6809_builtin_operand (arglist, QImode, 1);
			if (!target)
				target = gen_reg_rtx (QImode);
			emit_insn (gen_addqi3_carry (target, r0, r1));
			return target;

		case M6809_SUB_CARRY:
			r0 = m6809_builtin_operand (arglist, QImode, 0);
			r1 = m6809_builtin_operand (arglist, QImode, 1);
			if (!target)
				target = gen_reg_rtx (QImode);
			emit_insn (gen_subqi3_carry (target, r0, r1));
			return target;

		case M6809_NOP:
			emit_insn (target = gen_nop ());
			return target;

		case M6809_BLOCKAGE:
			emit_insn (target = gen_blockage ());
			return target;

		case M6809_ADD_DECIMAL:
			r0 = m6809_builtin_operand (arglist, QImode, 0);
			r1 = m6809_builtin_operand (arglist, QImode, 1);
			if (!target)
				target = gen_reg_rtx (QImode);
			emit_insn (gen_addqi3_decimal (target, r0, r1));
			return target;

		default:
			warning (WARNING_OPT "unknown builtin expansion ignored");
			return NULL_RTX;
	}
}


static const char *
far_function_type_p (tree type)
{
	tree attr;
	const char *page;

	/* Return whether or not this decl has the far attribute */
	attr = lookup_attribute ("far", TYPE_ATTRIBUTES (type));
	if (attr == NULL_TREE)
		return NULL;

	/* If it is far, check for a value */
	attr = TREE_VALUE (attr);
	if (attr == NULL_TREE)
	{
		warning (WARNING_OPT "far code page not specified, using local value");
		return far_code_page;
	}

	/* We have a TREE_LIST of attribute values, get the first one.
	 * It should be an INTEGER_CST. */
	attr = TREE_VALUE (attr);
	page = TREE_STRING_POINTER (attr);
	return page;
}


/* For a far function, returns the identifier that states which page
 * it resides in.  Otherwise, returns NULL for ordinary functions. */
const char *
far_functionp (rtx x)
{
	tree decl, decl_type;
	const char *page;

	/* Find the FUNCTION_DECL corresponding to the rtx being called. */
	decl = call_target_decl (x);
	if (decl == NULL_TREE)
		return NULL;

	/* See if the function has the new 'banked' attribute.  These
	 * are numeric instead of text */
	page = m6809_get_decl_bank (decl);
	if (page)
		return page;

	/* No, lookup the type of the function and see if the type
	 * specifies far or not. */
	decl_type = TREE_TYPE (decl);
	if (decl_type == NULL_TREE)
		return NULL;
	return far_function_type_p (decl_type);
}


/** Outputs the assembly language for a far call. */
void
output_far_call_insn (rtx *operands, int has_return)
{
	static char page_data[64];
	const char *called_page;

	/* The logic is the same for functions whether or not there
	 * is a return value.  Skip over the return value in this
	 * case, so that the call location is always operands[0].  */
	if (has_return)
		operands++;

	/* Get the name of the page being called */
	called_page = far_functionp (operands[0]);

#if 0 /* TODO : broken logic */
	/* See if the called page name is a 'bank' */
	if (isdigit (*called_page))
	{
		/* New style banking */
		if (!strcmp (called_page, current_bank_name))
		{
			/* Same page */
			output_asm_insn ("jsr\t%0", operands);
		}
		else
		{
			/* Different page */
			output_asm_insn ("jsr\t__far_call_handler\t;new style", operands);
			output_asm_insn ("\t.word\t%0", operands);
			sprintf (page_data, "\t.byte\t%s", called_page);
			output_asm_insn (page_data, operands);
		}
		return;
	}
#endif

	/* Are we calling a different page than we are running in? */
	if (!strcmp (called_page, far_code_page))
	{
		/* Same page : no need to execute a far call */
		if (flag_pic)
			output_asm_insn ("lbsr\t%C0", operands);
		else
			output_asm_insn ("jsr\t%0", operands);
	}
	else
	{
		/* Different page : need to emit far call thunk */

		/* First output a call to the thunk for making far calls. */
		if (flag_pic)
			output_asm_insn ("lbsr\t__far_call_handler", operands);
		else
			output_asm_insn ("jsr\t__far_call_handler", operands);

		/* Now output the name of the call site */
		output_asm_insn (".word\t%C0", operands);

		/* Finally output the page number */
		snprintf (page_data, sizeof(page_data), ".byte\t%s", far_functionp (operands[0]));
		output_asm_insn (page_data, operands);
	}
}


/** Outputs the assembly language for a call. */
void
output_call_insn (rtx *operands)
{
	/* First output the JSR instruction */
	fputs ("\tjsr\t", asm_out_file);

	/* Finally output the operand and a new line */
	print_operand_address (asm_out_file, XEXP (operands[0], 0), operands[1]);
	putc ('\n', asm_out_file);
}


int
m6809_init_cumulative_args (CUMULATIVE_ARGS cum ATTRIBUTE_UNUSED,
     tree fntype,
     rtx libname ATTRIBUTE_UNUSED)
{
	cum = 0;

	/* For far functions, the current implementation does not allow for
	 * stack parameters.  So note whenever the called function is far
	 * and in a different page than the current one; such a function
	 * should give an error if a stack parameter is generated. */
	if (fntype)
	{
		const char *called_page = far_function_type_p (fntype);
		if (called_page && strcmp (called_page, far_code_page) && !TARGET_FAR_STACK_PARAM)
			cum |= CUM_STACK_INVALID;
	}

	if (fntype && TYPE_ARG_TYPES (fntype) != 0 &&
		(TREE_VALUE (tree_last (TYPE_ARG_TYPES (fntype))) != void_type_node))
	{
		/* has variable arguments, cannot use registers */
		cum |= (CUM_X_MASK | CUM_B_MASK | CUM_STACK_ONLY);
	}

	/* libcall use registers if possible */
	if (libname != NULL)
		return cum;

	if (m6809_abi_version == M6809_ABI_VERSION_STACK)
	{
		/* cannot use registers ; only use the stack */
		cum |= (CUM_STACK_ONLY | CUM_X_MASK | CUM_B_MASK);
	}

	return cum;
}


rtx
m6809_function_arg_on_stack (CUMULATIVE_ARGS *cump)
{
	if (*cump & CUM_STACK_INVALID)
	{
		*cump &= ~CUM_STACK_INVALID;
		error ("far function needs stack, will not work");
	}
	return NULL_RTX;
}


/*
 * Trampoline output:
 *
 *  ldy #&cxt      4 bytes
 *  jmp fnaddr     3 bytes
 */
void
m6809_initialize_trampoline (rtx tramp, rtx fnaddr ATTRIBUTE_UNUSED, rtx cxt)
{
	/* TODO - optimize by generating the entire trampoline code here,
	 * and removing the template altogether, since there are only two
	 * bytes there that matter. */
	emit_move_insn (gen_rtx_MEM (HImode, plus_constant (tramp, 2)), cxt);
	emit_move_insn (gen_rtx_MEM (HImode, plus_constant (tramp, 5)), fnaddr);
}


/** Echo the version of the compiler and the name of the source file
 * at the beginning of each assembler output file.  asm_out_file
 * is a global FILE * pointing to the output stream. */
void
m6809_asm_file_start (void)
{
	const char *module_name;

	fprintf (asm_out_file, ";;; gcc for m6809 : %s %s\n",
		__DATE__, __TIME__);
	fprintf (asm_out_file, ";;; %s\n", version_string);
	fprintf (asm_out_file, ";;; ABI version %d\n", m6809_abi_version);
	fprintf (asm_out_file,
		optimize_size ? ";;; -mabi=%s %s%s%s%s%s -f%somit-frame-pointer -Os\n" : ";;; -mabi=%s %s%s%s%s%s -f%somit-frame-pointer -O%d\n",
		m6809_abi_version_to_str(m6809_abi_version),
		TARGET_BYTE_INT ? "-mint8" : "-mint16",
		TARGET_WPC ? " -mwpc" : "",
		TARGET_6309 ? " -m6309" : "",
		TARGET_DRET ? " -mdret" : "",
		flag_pic ? " -fpic" : "",
		flag_omit_frame_pointer ? "" : "no-",
		optimize);

	/* Print the name of the module, which is taken as the base name
	 * of the input file.
	 * See the 'User-Defined Symbols' section of the assembler
	 * documentation for the rules on valid symbols.
	 */
	module_name = lbasename (main_input_filename);

	fprintf (asm_out_file, "\t.module\t");

	if (isdigit (*module_name))
		fprintf (asm_out_file, "_");

	while (*module_name)
	{
		if (isalnum (*module_name)
			|| *module_name == '$'
			|| *module_name == '.'
			|| *module_name == '_')
		{
			fprintf (asm_out_file, "%c", *module_name);
		}
		else
		{
			fprintf (asm_out_file, "_");
		}
		module_name++;
	}

	fprintf (asm_out_file, "\n");
}


/* Naked functions should not allocate stack slots for arguments. */
bool
m6809_allocate_stack_slots_for_args (void)
{
	return !m6809_current_function_has_type_attr_p ("naked");
}


/** Returns true if prologue/epilogue code is required for the
 * current function being compiled.
 *
 * This is just the inverse of whether the function is declared as
 * 'naked'.
 */
int
prologue_epilogue_required (void)
{
	return !m6809_current_function_has_type_attr_p ("naked")
		&& !m6809_current_function_has_type_attr_p ("noreturn");
}


/** Expand RTL for function entry */
void
emit_prologue_insns (void)
{
  rtx insn;
  unsigned int live_regs = m6809_get_live_regs ();
  unsigned int frame_size = get_frame_size ();

  /* Save all registers used, including the frame pointer */
  tree type = TREE_TYPE (current_function_decl);
  tree attr = lookup_attribute ("interrupt", TYPE_ATTRIBUTES (type));
  if (attr == NULL_TREE)
  {
    if (live_regs)
    {
      insn = emit_insn (
        gen_rtx_register_pushpop (UNSPEC_PUSH_RS, live_regs));
      RTX_FRAME_RELATED_P (insn) = 1;
    }
  }
  else
  {
    /* Make sure it has a value assigned to it */
    attr = TREE_VALUE (attr);
    if (attr != NULL_TREE)
    {
      /* Return the interrupt name */
      attr = TREE_VALUE (attr);
      if (!strcmp (TREE_STRING_POINTER (attr), "firq"))
      {
        /* TODO save D and X only if they have changed or a
           function has been called */
        live_regs |= (1 << HARD_D_REGNUM) | (1 << HARD_X_REGNUM);
        insn = emit_insn (
          gen_rtx_register_pushpop (UNSPEC_PUSH_RS, live_regs));
        RTX_FRAME_RELATED_P (insn) = 1;
      }
      else
        gcc_unreachable ();
    }
  }

  /* Allocate space for local variables */
  if (frame_size != 0)
  {
    insn = emit_insn (gen_rtx_stack_adjust (MINUS, frame_size));
    RTX_FRAME_RELATED_P (insn) = 1;
  }

  /* Set the frame pointer if it is needed */
  if (frame_pointer_needed)
  {
    insn = emit_move_insn (hard_frame_pointer_rtx, stack_pointer_rtx);
    RTX_FRAME_RELATED_P (insn) = 1;
  }
}


/** Expand RTL for function exit */
void
emit_epilogue_insns (bool sibcall_p)
{
  unsigned int live_regs = m6809_get_live_regs ();
  unsigned int frame_size = get_frame_size ();

  if (frame_size != 0)
    emit_insn (gen_rtx_stack_adjust (PLUS, frame_size));

  if (sibcall_p)
  {
    if (live_regs)
      emit_insn (gen_rtx_register_pushpop (UNSPEC_POP_RS, live_regs));
  }
  else
  {
    tree type = TREE_TYPE (current_function_decl);
    tree attr = lookup_attribute ("interrupt", TYPE_ATTRIBUTES (type));
    if (attr == NULL_TREE)
    {
      if (live_regs)
        emit_insn (
          gen_rtx_register_pushpop (UNSPEC_POP_RS, PC_REGBIT | live_regs));

      emit_jump_insn (gen_return_rts ());
    }
    else
    {
      /* Make sure it has a value assigned to it */
      attr = TREE_VALUE (attr);
      if (attr != NULL_TREE)
      {
        /* Return the interrupt name */
        attr = TREE_VALUE (attr);
        if (!strcmp (TREE_STRING_POINTER (attr), "firq"))
        {
          live_regs |= (1 << HARD_D_REGNUM) | (1 << HARD_X_REGNUM);
          emit_insn (gen_rtx_register_pushpop (UNSPEC_POP_RS, live_regs));
        }
        else
          gcc_unreachable ();
      }

      emit_jump_insn (gen_return_rti ());
    }
  }
}


/** Predefine some preprocessor names according to the currently
 * selected compiler options */
void
m6809_cpu_cpp_builtins (void)
{
	extern void builtin_define_std (const char *macro); /* c-cppbuiltin.c */

	/* Always defined */
	builtin_define_std ("__M6809__");
	builtin_define_std ("__m6809__");

	if (TARGET_6309)
	{
		builtin_define_std ("__M6309__");
		builtin_define_std ("__m6309__");
	}


	if (TARGET_BYTE_INT)
		builtin_define_std ("__int8__");
	else
		builtin_define_std ("__int16__");

	switch (m6809_abi_version)
	{
		case M6809_ABI_VERSION_STACK:
			builtin_define_std ("__regargs__"); /* deprecated */
			builtin_define_std ("__ABI_STACK__");
			break;
		case M6809_ABI_VERSION_BX:
			builtin_define_std ("__ABI_REGS__"); /* deprecated */
			builtin_define_std ("__ABI_BX__");
			break;
		default:
			break;
	}

	if (TARGET_WPC)
		builtin_define_std ("__WPC__");

	if (TARGET_DRET)
		builtin_define_std ("__DRET__");

	if (flag_omit_frame_pointer)
		builtin_define_std ("__OMIT_FRAME_POINTER__");

	/* byte order macro */
	builtin_define_std ("__ORDER_LITTLE_ENDIAN__=1234");
	builtin_define_std ("__ORDER_PDP_ENDIAN__=3412");
	builtin_define_std ("__ORDER_BIG_ENDIAN__=4321");
	builtin_define_std ("__BYTE_ORDER__=__ORDER_BIG_ENDIAN__");
	builtin_define_std ("__FLOAT_WORD_ORDER__=__ORDER_BIG_ENDIAN__");
}


#define MAX_ASM_ASCII_STRING 48

void
m6809_output_ascii (FILE *fp, const char *str, unsigned long size)
{
	unsigned long i;
	bool use_ascii = true;

	/* If the size is too large, then break this up into multiple
	outputs.  The assembler can only output roughly 48 bytes at a
	time.  Note that if there are lots of escape sequences in
	the string, this may fail. */
	if (size > MAX_ASM_ASCII_STRING)
	{
		m6809_output_ascii (fp, str, MAX_ASM_ASCII_STRING);
		m6809_output_ascii (fp, str + MAX_ASM_ASCII_STRING, 
			size - MAX_ASM_ASCII_STRING);
		return;
	}

	/* Check for 8-bit codes, which cannot be embedded in an .ascii */
	for (i = 0; i < size; i++)
	{
		int c = str[i] & 0xFF;
		if (c >= 0x80)
		{
			use_ascii = false;
			break;
		}
	}

	if (use_ascii)
	{
		fputs ("\t.ascii\t\"", fp);
		for (i = 0; i < size; i++)
		{
			int c = str[i] & 0xFF;
			/* Just output the plain character if it is printable,
			otherwise output the escape code for the character.
			The assembler recognizes the same C-style octal escape sequences,
			except that it only supports 7-bit codes. */
			if (c >= ' ' && c < 0x7F && c != '\\' && c != '"')
				putc (c, fp);
			else switch (c)
			{
				case '\n':
#ifndef TARGET_COCO
					fputs ("\\n", fp);
					break;
#endif
				/* On the CoCo, we fallthrough and treat '\n' like '\r'. */
				case '\r':
					fputs ("\\r", fp);
					break;
				case '\t':
					fputs ("\\t", fp);
					break;
				case '\f':
					fputs ("\\f", fp);
					break;
				case 0:
					fputs ("\\0", fp);
					break;
				default:
					fprintf (fp, "\\%03o", c);
					break;
			}
		}
		fputs ("\"\n", fp);
	}
	else
	{
		for (i = 0; i < size; i++)
		{
			int c = str[i];
			/* Try to output 8 bytes by line. */
			if (!(i&7))
			{
				if (i)
					putc ('\n', fp);
				fputs ("\t.byte\t", fp);
			}
			else
				putc (',', fp);
			fprintf (fp, "%d", c);
		}
		putc ('\n', fp);
	}
}


void
m6809_output_quoted_string (FILE *asm_file, const char *string)
{
	char c;

	if (strlen (string) > MAX_ASM_ASCII_STRING)
	{
		/* The string length is too large.  We'll have to truncate it.
		This is only called from debugging functions, so it's usually
		not critical. */

		char truncated_string[MAX_ASM_ASCII_STRING+1];

		/* Copy as many characters as we can. */
		strncpy (truncated_string, string, MAX_ASM_ASCII_STRING);
		truncated_string[MAX_ASM_ASCII_STRING] = '\0';
		string = truncated_string;
	}

	/* Copied from toplev.c */

	putc ('\"', asm_file);
	while ((c = *string++) != 0) {
		if (ISPRINT (c)) {
			if (c == '\"' || c == '\\')
				putc ('\\', asm_file);
			putc (c, asm_file);
		}
      else
			fprintf (asm_file, "\\%03o", (unsigned char) c);
	}
	putc ('\"', asm_file);
}


/** Output the assembly code for a shift instruction where the
 * shift count is not constant. */
void
m6809_output_shift_insn (int rtx_code, rtx *operands)
{
	if (GET_CODE (operands[2]) == CONST_INT)
		abort ();

	if (GET_MODE (operands[0]) == HImode)
	{
		if (optimize_size)
		{
			switch (rtx_code)
			{
				case ASHIFT:
					output_asm_insn (flag_pic ? "lbsr\t_ashlhi3" : "jsr\t_ashlhi3", operands);
					break;
				case ASHIFTRT:
					output_asm_insn (flag_pic ? "lbsr\t_ashrhi3" : "jsr\t_ashrhi3", operands);
					break;
				case LSHIFTRT:
					output_asm_insn (flag_pic ? "lbsr\t_lshrhi3" : "jsr\t_lshrhi3", operands);
					break;
				default:
					abort ();
				}
		}
		else
		{
			switch (rtx_code)
			{
				case ASHIFT:
					m6809_gen_register_shift (operands, "aslb", "rola");
					break;
				case ASHIFTRT:
					m6809_gen_register_shift (operands, "asra", "rorb");
					break;
				case LSHIFTRT:
					m6809_gen_register_shift (operands, "lsra", "rorb");
					break;
				default:
					abort ();
			}
		}
	}
	else if (GET_MODE (operands[0]) == QImode)
	{
		switch (rtx_code)
		{
			case ASHIFT:
				m6809_gen_register_shift (operands, "aslb", NULL);
				break;
			case ASHIFTRT:
				m6809_gen_register_shift (operands, "asrb", NULL);
				break;
			case LSHIFTRT:
				m6809_gen_register_shift (operands, "lsrb", NULL);
				break;
			default:
				abort ();
		}
	}
	else
		abort ();
}


static void
m6809_emit_move_insn (rtx dst, rtx src)
{
	emit_insn (gen_rtx_SET (VOIDmode, dst, src));
	if (ACC_A_REG_P (dst))
		emit_insn (gen_rtx_USE (VOIDmode, dst));
}


/** Split a complex shift instruction into multiple CPU
 * shift instructions. */
void
m6809_split_shift (int code, rtx *operands)
{
	int mode;
	int count;

	mode = GET_MODE (operands[0]);
	count = INTVAL (operands[2]);
	
	/* Handle a shift count outside the range of 0 .. N-1, where
	 * N is the mode size in bits.  We normalize the count, and
	 * for negative counts we also invert the direction of the
	 * shift. */
	if ((count < 0) || (count >= 8 * GET_MODE_SIZE (mode)))
	{
		if (count < 0)
		{
			count = -count;
			code = (code == ASHIFT) ? ASHIFTRT : ASHIFT;
		}
		count %= (8 * GET_MODE_SIZE (mode));
		m6809_emit_move_insn (operands[0],
			gen_rtx_fmt_ee (code, mode, operands[1],
				gen_rtx_CONST_INT (VOIDmode, count)));
	}

	/* Handle shift by zero explicitly as a no-op. */
	if (count == 0)
	{
		emit_insn (gen_nop ());
		return;
	}

	/* Decompose the shift by a constant N > 8 into two
	 * shifts, first by 8 and then by N-8.
	 * This "speeds up" the process for large shifts that would be
	 * handled below, but allows for some optimization.
	 * In some cases shift by 8 can be implemented fast.  If an
	 * instruction to shift by 8 is defined, it will be used here;
	 * otherwise it will be further decomposed as below. */
	if (mode == HImode && count > 8)
	{
		rtx output = operands[0];

		m6809_emit_move_insn (operands[0],
			gen_rtx_fmt_ee (code, mode, operands[1],
				gen_rtx_CONST_INT (VOIDmode, 8)));

		/* Unsigned shifts always produce a zero in either the
		 * upper or lower half of the output; then, that part
		 * does not need to be shifted anymore.  We modify the
		 * output and the subsequent instructions to operate in
		 * QImode only on the relevant part. */
		if (REG_P (output))
		{
			if (code == ASHIFT)
			{
				output = gen_rtx_REG (QImode, HARD_A_REGNUM);
				mode = QImode;
			}
			else
			{
				output = gen_rtx_REG (QImode, HARD_D_REGNUM);
				mode = QImode;
			}
		}

		m6809_emit_move_insn (output,
			gen_rtx_fmt_ee (code, mode, copy_rtx (output), 
				gen_rtx_CONST_INT (VOIDmode, count-8)));
		return;
	}

	/* Rewrite the unsigned shift of an 8-bit register by a large constant N
	 * (near to the maximum of 8) as a rotate and mask. */
	if (mode == QImode && REG_P (operands[0]) && count >= ((code == ASHIFTRT) ? 7 : 6))
	{
		HOST_WIDE_INT mask;
		unsigned int was_signed = (code == ASHIFTRT);

		code = (code == ASHIFT) ? ROTATERT : ROTATE;
		if (code == ROTATE)
			mask = (count == 6) ? 0x03 : 0x01;
		else
			mask = (count == 6) ? 0xC0 - 0x100 : 0x80 - 0x100;
		count = 9 - count;

		do {
			m6809_emit_move_insn (operands[0],
				gen_rtx_fmt_ee (code, QImode, operands[1], const1_rtx));
		} while (--count != 0);

		m6809_emit_move_insn (operands[0],
			gen_rtx_fmt_ee (AND, QImode, operands[1],
				gen_rtx_CONST_INT (VOIDmode, mask)));

		if (was_signed)
		{
			emit_insn (gen_negqi2 (operands[0], copy_rtx (operands[0])));
			if (ACC_A_REG_P (operands[0]))
				emit_insn (gen_rtx_USE (VOIDmode, operands[0]));
		}
		return;
	}

	/* Decompose the shift by any constant N > 1 into a sequence
	 * of N shifts.
	 * This is done recursively, by creating a shift by 1 and a
	 * shift by N-1, as long as N>1. */
	if (count > 1)
	{
		m6809_emit_move_insn (operands[0],
			gen_rtx_fmt_ee (code, mode, operands[1], const1_rtx));
	
		m6809_emit_move_insn (operands[0],
			gen_rtx_fmt_ee (code, mode, operands[1], 
				gen_rtx_CONST_INT (VOIDmode, count-1)));
		return;
	}
	
	/* Decompose the single shift of a 16-bit quantity into two
	 * CPU instructions, one for each 8-bit half.
	 */
	if (mode == HImode && count == 1)
	{
		rtx first, second;
		int rotate_code;

		rotate_code = (code == ASHIFT) ? ROTATE : ROTATERT;

		/* Split the operand into two 8-bit entities.
		 * FIRST is the one that will get shifted via a regular CPU
		 * instruction.
		 * SECOND is the one that will have the result of the first shift
		 * rotated in.
		 *
		 * We initialize first and second as if we are doing a left shift,
		 * then swap the operands if it's a right shift.
		 */
		if (REG_P (operands[0]))
		{
			first = gen_rtx_REG (QImode, HARD_D_REGNUM); /* HARD_B_REGNUM? */
			second = gen_rtx_REG (QImode, HARD_A_REGNUM);
		}
		else
		{
			first = adjust_address (operands[0], QImode, 1);
			second = adjust_address (operands[0], QImode, 0);
		}

		if (rotate_code == ROTATERT)
		{
			rtx tmp; tmp = first; first = second; second = tmp;
		}

		/* Decompose into a shift and a rotate instruction. */
		m6809_emit_move_insn (first,
			gen_rtx_fmt_ee (code, QImode, copy_rtx (first), const1_rtx));
		m6809_emit_move_insn (second,
			gen_rtx_fmt_ee (rotate_code, QImode, copy_rtx (second), const1_rtx));
		return;
	}
}


/** Adjust register usage based on compile-time flags. */
void
m6809_conditional_register_usage (void)
{
	unsigned int soft_regno;

#ifdef CONFIG_SOFT_REGS_ALWAYS
	m6809_soft_regs = CONFIG_SOFT_REGS_ALWAYS;
#else
	if (!m6809_soft_reg_count)
		return;
	m6809_soft_regs = atoi (m6809_soft_reg_count);
#endif

	if (m6809_soft_regs == 0)
		return;

	if (m6809_soft_regs > NUM_M_REGS)
		m6809_soft_regs = NUM_M_REGS;

	/* Registers are marked FIXED by default.  Free up if
	the user wishes. */
	for (soft_regno = 1; soft_regno < m6809_soft_regs; soft_regno++)
	{
		fixed_regs[SOFT_M0_REGNUM + soft_regno] = 0;

		/* Mark the softregs as call-clobbered, so that they need
		 * not be saved/restored on function entry/exit. */
		call_used_regs[SOFT_M0_REGNUM + soft_regno] = 1;
	}
}


/** Return a RTX representing how to return a value from a function.
  VALTYPE gives the type of the value, FUNC identifies the function
  itself.

  In general, we only care about the width of the result. */
rtx
m6809_function_value (const tree valtype, const tree func ATTRIBUTE_UNUSED)
{
   unsigned int regno;
	enum machine_mode mode;

	/* Get the mode (i.e. width) of the result. */
	mode = TYPE_MODE (valtype);

	if (lookup_attribute ("boolean", TYPE_ATTRIBUTES (valtype)))
      regno = HARD_Z_REGNUM;
   else if (mode == QImode || (TARGET_DRET && mode == HImode))
      regno = HARD_D_REGNUM;
   else
      regno = HARD_X_REGNUM;
   return gen_rtx_REG (mode, regno);
}


/** Return 1 if REGNO is possibly needed to return the result
of a function, 0 otherwise. */
int
m6809_function_value_regno_p (unsigned int regno)
{
	if (regno == HARD_Z_REGNUM)
		return 1;
	else if ((TARGET_BYTE_INT || TARGET_DRET) && regno == HARD_D_REGNUM)
		return 1;
	else if (!TARGET_DRET && regno == HARD_X_REGNUM)
		return 1;
	else
		return 0;
}


#ifdef TRACE_PEEPHOLE
int
m6809_match_peephole2 (unsigned int peephole_id, unsigned int stage)
{
	if (stage == PEEP_END)
	{
		printf ("%s: peephole %d pattern and predicate matched\n",
			main_input_filename, peephole_id);
		fflush (stdout);
	}
	else if (stage == PEEP_COND)
	{
		printf ("%s: peephole %d? at least pattern matched\n",
			main_input_filename, peephole_id);
		fflush (stdout);
	}
	return 1;
}
#else
int
m6809_match_peephole2 (unsigned int peephole_id ATTRIBUTE_UNUSED,
	unsigned int stage ATTRIBUTE_UNUSED)
{
	return 1;
}
#endif /* TRACE_PEEPHOLE */


/** Return 1 if it is OK to store a value of MODE in REGNO. */
int
m6809_hard_regno_mode_ok (unsigned int regno, enum machine_mode mode)
{
   /* Soft registers, as they are just memory, can really hold
   values of any type.  However we restrict them to values of
   size HImode or QImode to prevent exhausting them for larger
   values.
      Word values cannot be placed into the first soft register,
   as it is the low byte that is being placed there, which
   corrupts the (non-soft) register before it. */
   if (M_REGNO_P (regno))
   {
      switch (GET_MODE_SIZE (mode))
      {
         case 1:
            return 1;
         case 2:
            return regno != SOFT_M0_REGNUM;
         default:
            return 0;
      }
   }

   /* VOIDmode can be stored anywhere */
   if (mode == VOIDmode)
      return 1;

   /* Zero is a reserved register, but problems occur if we don't
   say yes here??? */
   if (regno == HARD_RSVD1_REGNUM)
      return 1;

   /* For other registers, return true only if the requested size
   exactly matches the hardware size. */
   if ((WORD_REGNO_P (regno)) && (GET_MODE_SIZE (mode) == 2))
      return 1;
   if ((BYTE_REGNO_P (regno)) && (GET_MODE_SIZE (mode) == 1))
      return 1;

   return 0;
}


/* exp is the call expression.  DECL is the called function,
 * or NULL for an indirect call */
static bool
m6809_function_ok_for_sibcall (tree decl, tree exp ATTRIBUTE_UNUSED)
{
	tree type;
	bool result = 0;
	/*int step = 1;
	const char *name;
	int argcount = 0;*/

	/* If there is no DECL, it is an indirect call.
	 * Never optimize this??? */
	if (decl == NULL)
		goto done;

	/* Never allow an interrupt handler to be optimized this way. */
	if (m6809_function_has_type_attr_p (current_function_decl, "interrupt")
		|| m6809_function_has_type_attr_p (decl, "interrupt"))
		goto done;

	/* Skip sibcall if the type can't be found for
	 * some reason */
	/*step++;*/
	/*name = IDENTIFIER_POINTER (DECL_NAME (decl));*/
	type = TREE_TYPE (decl);
	if (type == NULL)
		goto done;

	/* Skip sibcall if the target is a far function */
	/*step++;*/
	if (far_function_type_p (type) != NULL)
		goto done;

	/* Skip sibcall if the called function's arguments are
	 * variable */
	/*step++;*/
	if (TYPE_ARG_TYPES (type) == NULL)
		goto done;

	/* Allow sibcalls in other cases. */
	result = 1;
done:
	/* printf ("%s ok for sibcall? %s, step %d, args %d\n", name, result ? "yes" : "no", step, argcount); */
	return result;
}


/** Emit code for the 'casesi' pattern.
 * This pattern is only used in 8-bit mode, and can be disabled
 * with -mold-case there as well.  The rationale for this is to
 * do a better job than the simpler but well-tested 'tablejump'
 * method.
 *
 * For small jumptables, where the switch expression is an
 * 8-bit value, the lookup can be done more efficiently
 * using the "B,X" style index mode. */
void
m6809_do_casesi (rtx index, rtx lower_bound, rtx range,
	rtx table_label, rtx default_label)
{
	enum machine_mode mode;
	rtx scaled;
	rtx table_in_reg;

	/* expr.c has to be patched so that it does not promote
	 * the expression to SImode, but rather to HImode.
	 * Fail now if that isn't the case. */
	if (GET_MODE_SIZE (GET_MODE (index)) > GET_MODE_SIZE (HImode))
		error ("try_casesi promotion bug");

	/* Determine whether or not we are going to work primarily in
	 * QImode or HImode.  This depends on the size of the index
	 * into the lookup table.  QImode can only be used when the
	 * index is less than 0x40, since it will be doubled but
	 * must remain unsigned. */
	if ((GET_CODE (range) == CONST_INT) && (INTVAL (range) < 0x40))
		mode = QImode;
	else
		mode = HImode;

	/* Convert to QImode if necessary */
	if (mode == QImode)
	{
		index = gen_lowpart_general (mode, index);
		lower_bound = gen_lowpart_general (mode, lower_bound);
	}

	/* Translate from case value to table index by subtraction */
	if (lower_bound != const0_rtx)
		index = expand_binop (mode, sub_optab, index, lower_bound,
			NULL_RTX, 0, OPTAB_LIB_WIDEN);

	/* Emit compare-and-jump to test for index out-of-range */
	emit_cmp_and_jump_insns (index, range, GTU, NULL_RTX, mode, 1,
		default_label);

	/* Put the table address is in a register */
	table_in_reg = gen_reg_rtx (Pmode);
	emit_move_insn (table_in_reg, gen_rtx_LABEL_REF (Pmode, table_label));

	/* Emit table lookup and jump */
	if (mode == QImode)
	{
		/* Scale the index */
		scaled = gen_reg_rtx (QImode);
		emit_insn (gen_ashlqi3 (scaled, index, const1_rtx));

		/* Emit the jump */
		emit_jump_insn (gen_tablejump_short_offset (scaled, table_in_reg));
	}
	else
	{
		/* Scale the index */
		emit_insn (gen_ashlhi3 (index, index, const1_rtx));

		/* Emit the jump */
		emit_jump_insn (gen_tablejump_long_offset (index, table_in_reg));
	}

	/* Copied from expr.c */
	if (!CASE_VECTOR_PC_RELATIVE && !flag_pic)
		emit_barrier ();
}


/** Output the assembly code for a 32-bit add/subtract. */
void
m6809_output_addsi3 (int rtx_code, rtx *operands)
{
	rtx xoperands[8];
	rtx dst = operands[0];

	/* Prepare the operands by splitting each SImode into two HImodes
	that can be operated independently.  The high word of operand 1
	is further divided into two QImode components for use with 'adc'
	style instructions. */
	xoperands[7] = operands[3];

	xoperands[0] = adjust_address (dst, HImode, 2);
	xoperands[3] = adjust_address (dst, HImode, 0);

#if 1
	xoperands[2] = adjust_address (operands[1], HImode, 2);
	xoperands[6] = adjust_address (operands[1], HImode, 0);

	/* Operand 2 may be a MEM or a CONST_INT */
	if (GET_CODE (operands[2]) == CONST_INT)
	{
		xoperands[1] = gen_int_mode (INTVAL (operands[2]) & 0xFFFF, HImode);
		xoperands[4] = gen_int_mode ((INTVAL (operands[2]) >> 24) & 0xFF, QImode);
		xoperands[5] = gen_int_mode ((INTVAL (operands[2]) >> 16) & 0xFF, QImode);
	}
	else
	{
		xoperands[1] = adjust_address (operands[2], HImode, 2);
		xoperands[4] = adjust_address (operands[2], QImode, 0);
		xoperands[5] = adjust_address (operands[2], QImode, 1);
	}

#endif

#if 0
	xoperands[1] = adjust_address (operands[1], HImode, 2);
	xoperands[4] = adjust_address (operands[1], QImode, 0);
	xoperands[5] = adjust_address (operands[1], QImode, 1);

	/* Operand 2 may be a MEM or a CONST_INT */
	if (GET_CODE (operands[2]) == CONST_INT)
	{
		xoperands[2] = gen_int_mode ((INTVAL (operands[2])) & 0xFFFF, HImode);
		xoperands[6] = gen_int_mode ((INTVAL (operands[2]) >> 16) & 0xFFFF, HImode);
	}
	else
	{
		xoperands[2] = adjust_address (operands[2], HImode, 2);
		xoperands[6] = adjust_address (operands[2], HImode, 0);
	}
#endif

	/* Output the assembly code. */
	if (rtx_code == PLUS)
	{
		output_asm_insn ("ld%7\t%2", xoperands);
		output_asm_insn ("add%7\t%1", xoperands);
		output_asm_insn ("st%7\t%0", xoperands);
		output_asm_insn ("ld%7\t%6", xoperands);
		output_asm_insn ("adcb\t%5", xoperands);
		output_asm_insn ("adca\t%4", xoperands);
		output_asm_insn ("st%7\t%3", xoperands);
	}
	else
	{
		output_asm_insn ("ld%7\t%2", xoperands);
		output_asm_insn ("sub%7\t%1", xoperands);
		output_asm_insn ("st%7\t%0", xoperands);
		output_asm_insn ("ld%7\t%6", xoperands);
		output_asm_insn ("sbcb\t%5", xoperands);
		output_asm_insn ("sbca\t%4", xoperands);
		output_asm_insn ("st%7\t%3", xoperands);
	}
}


#if 0
/** Output the assembly code for a 32-bit shift.
Operands 0 and 1 must be the same rtx, forced by a matching
constraint.  Operand 2 must be a CONST_INT.  Operand 3 is
"d" in case a temporary reg is needed. */
void
m6809_output_shiftsi3 (int rtx_code, rtx *operands)
{
	unsigned int count = INTVAL (operands[2]) % 32;
	unsigned int size = 4; /* sizeof (SImode) */
	int s;
	rtx xoperands[4];
	int op;
	int start, end, step;

	/* Initialize */
	if (rtx_code == ASHIFT)
	{
		start = size-1;
		end = -1;
		step = -1;
	}
	else
	{
		start = 0;
		end = size;
		step = 1;
	}

	xoperands[2] = operands[2];
	xoperands[3] = operands[3];

	if (count <= 0)
		abort ();
	if (rtx_code == ROTATE || rtx_code == ROTATERT)
		abort ();

	/* Extract bit shifts over 16 bits by HImode moves. */
	if (count >= 16)
	{
	}

	/* Extract bit shifts over 8 bits by QImode moves. */
	if (count >= 8)
	{
	}

	/* Iterate over the number of bits to be shifted. */
	while (count > 0)
	{
		/* Each bit to be shifted requires 1 proper bit shift
		and 3 rotates. */

		/* First, do the arithmetic/logical shift.  Left shifts
		start from the LSB; right shifts start from the MSB. */
		xoperands[0] = adjust_address (operands[0], QImode, start);
		switch (rtx_code)
		{
			case ASHIFT:
				output_asm_insn ("asl\t%0", xoperands);
				start--;
				break;
			case ASHIFTRT:
				output_asm_insn ("asr\t%0", xoperands);
				start++;
				break;
			case LSHIFTRT:
				output_asm_insn ("lsr\t%0", xoperands);
				start++;
				break;
		}

		/* Next, rotate the other bytes */
		for (s = start; s != end; s += step)
		{
			xoperands[0] = adjust_address (operands[0], QImode, s);
			switch (rtx_code)
			{
				case ASHIFT:
					output_asm_insn ("rol\t%0", xoperands);
					break;
				case ASHIFTRT:
				case LSHIFTRT:
					output_asm_insn ("ror\t%0", xoperands);
					break;
			}
		}
		count--;
	}
}
#endif

int
power_of_two_p (unsigned int n)
{
	return (n & (n-1)) == 0;
}


int
m6809_can_eliminate (int from, int to)
{
	if (from == ARG_POINTER_REGNUM && to == STACK_POINTER_REGNUM)
		return !frame_pointer_needed;
	return 1;
}


int
m6809_initial_elimination_offset (int from, int to)
{
	if (to != STACK_POINTER_REGNUM && to != HARD_FRAME_POINTER_REGNUM)
		gcc_unreachable ();
	switch (from)
	{
		case ARG_POINTER_REGNUM:
			return get_frame_size () + m6809_get_regs_size (m6809_get_live_regs ());
		case FRAME_POINTER_REGNUM:
			return get_frame_size ();
		default:
			gcc_unreachable ();
	}
}


/* Defines the target-specific hooks structure. */
struct gcc_target targetm = TARGET_INITIALIZER;

