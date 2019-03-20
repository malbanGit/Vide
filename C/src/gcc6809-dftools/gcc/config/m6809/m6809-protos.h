/* GCC for 6809 : machine-specific function prototypes

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

#ifndef __M6809_PROTOS_H__
#define __M6809_PROTOS_H__

void              print_options (FILE *file);
void              m6809_cpu_cpp_builtins (void);
void              m6809_override_options (void);
void              m6809_init_builtins (void);
unsigned int      m6809_get_live_regs (void);
const char *      m6809_get_regs_printable (unsigned int regs);
unsigned int      m6809_get_regs_size (unsigned int regs);
int               m6809_function_has_type_attr_p (tree decl, const char *);
int               m6809_current_function_has_type_attr_p (const char *);
int               prologue_epilogue_required (void);
void              output_function_prologue (FILE *file, int size);
void              output_function_epilogue (FILE *file, int size);
int               check_float_value (enum machine_mode mode, double *d, int overflow);
void              m6809_asm_named_section (const char *name, unsigned int flags, tree decl);
void              m6809_asm_file_start (void);
void              m6809_output_ascii (FILE *fp, const char *str, unsigned long size);
void              m6809_declare_function_name (FILE *asm_out_file, const char *name, tree decl);
void              m6809_reorg (void);
int               m6809_current_function_is_void (void);
int               m6809_can_merge_pushpop_p (int op, int regs1, int regs2);
int               m6809_function_value_regno_p (unsigned int regno);
void              emit_prologue_insns (void);
void              emit_epilogue_insns (bool);
void              m6809_conditional_register_usage (void);
void              m6809_output_quoted_string (FILE *asm_file, const char *string);
int               m6809_match_peephole2 (unsigned int peephole_id, unsigned int stage);
int               m6809_hard_regno_mode_ok (unsigned int regno, enum machine_mode mode);
int               power_of_two_p (unsigned int n);
void              m6809_do_casesi (rtx index, rtx lower_bound, rtx range, rtx table_label, rtx default_label);
void              m6809_output_addsi3 (int rtx_code, rtx *operands);
rtx               m6809_function_arg_on_stack (CUMULATIVE_ARGS *cump);
void              expand_constant_shift (int code, rtx dst, rtx src, rtx count);
int               m6809_single_operand_operator (rtx exp);
void              m6809_split_shift (int code, rtx *operands);
int               m6809_can_eliminate (int from, int to);
int               m6809_initial_elimination_offset (int from, int to);
const char *      m6809_abi_version_to_str (int version);
bool              m6809_allocate_stack_slots_for_args (void);

#ifdef TREE_CODE
int m6809_init_cumulative_args (CUMULATIVE_ARGS cum, tree fntype, rtx libname);
#endif /* TREE_CODE */

#ifdef RTX_CODE
void              print_direct_prefix (FILE *file, rtx addr);
void              print_operand (FILE *file, rtx x, int code);
void              print_operand_address (FILE *file, rtx addr, rtx ofst);
void              notice_update_cc (rtx exp, rtx insn);
enum              reg_class m6809_preferred_reload_class (rtx x, enum reg_class regclass);
rtx               gen_rtx_const_high (rtx r);
rtx               gen_rtx_const_low (rtx r);
rtx               gen_rtx_register_pushpop (int pop_flag, int regs);
void              emit_libcall_insns (enum machine_mode mode, const char *name, rtx *operands, int count);
const char *      output_branch_insn (enum rtx_code code, rtx *operands, int length);
void              output_call_insn (rtx *operands);
void              output_far_call_insn (rtx *operands, int has_return);
void              m6809_initialize_trampoline (rtx tramp, rtx fnaddr, rtx cxt);
rtx               m6809_expand_builtin (tree exp, rtx target, rtx subtarget, enum machine_mode mode, int ignore);
const char *      far_functionp (rtx x);
rtx               m6809_function_value (const tree valtype, const tree func);
void              m6809_output_shift_insn (int rtx_code, rtx *operands);
#endif /* RTX_CODE */

#endif /* __M6809_PROTOS_H__ */
