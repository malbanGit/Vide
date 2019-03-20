;;;
;;; Copyright 2006, 2007, 2008, 2009 by Brian Dominy <brian@oddchange.com>
;;;
;;; This file is part of GCC.
;;;
;;; GCC is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3, or (at your option)
;;; any later version.
;;;
;;; GCC is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; You should have received a copy of the GNU General Public License
;;; along with GCC; see the file COPYING3.  If not see
;;; <http://www.gnu.org/licenses/>.


	.module crt0.S

	/* Declare external for main() */
	.globl _main


/* The startup is heavily dependent on the type of machine and
OS environment that is available at the start point.
For the most part, the general idea is the same across machines,
but the implementation is vastly different.  This is managed via
conditional compiles throughout the startup code for each of the
supported machines. */


#ifdef TARGET_COCO /* CoCo memory map */

#define COCO_RAMROM_MODE 0xFFDE
#define COCO_ALLRAM_MODE 0xFFDF
#define COCO_PAGE1 0xFFD5

/* SAM M1 and M0 adjusts the memory size */

#define BASIC_WARMSTART_FLAG 0x0071
#define BASIC_START 0xA027

#define __PROG_SIZE
#define __STACK_TOP 0x6800

#elif defined(TARGET_SIM) /* Simulator (default) memory map */

#define SIM_EXIT_REG 0xFF01

#define __PROG_SIZE
#define __STACK_TOP 0xFE00

#else

#define __PROG_SIZE (SIZE=(0HF700))
#define TARGET_UNKNOWN

#endif


#ifdef __PIC__
#define JUMP lbra
#define CALL lbsr
#define LEA(r,a) lea##r a,pcr
#define MEM(a) a,pcr
#else
#define JUMP jmp
#define CALL jsr
#define CONCAT(a,b) a##b
#define LEA(r,a) ld##r CONCAT(#,a)
#define MEM(a) a
#endif


	;; Declare all linker sections, and combine them into a single bank
	.bank prog              __PROG_SIZE
#ifdef TARGET_UNKNOWN
	.area .direct           (BANK=prog)
#else
	.area .direct
#endif
	.area .base             (BANK=prog)
	.area .text.startup     (BANK=prog)
	.area .text             (BANK=prog)
	.area .romcall          (BANK=prog)
	.area .rodata           (BANK=prog)
	.area .data             (BANK=prog)
	.area .ctors            (BANK=prog)
	.area .dtors            (BANK=prog)
	.area .gcc_except_table (BANK=prog)
	.area .bss              (BANK=prog)
	.area .noinit           (BANK=prog)
	.area .vector

	.area	.text
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; __exit : Exit point from the program
;;; For simulation, this writes to a special I/O register that
;;; the simulator interprets as end-of-program.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.globl	__exit
__exit:
#ifdef TARGET_COCO
	;; Go back to ROM/RAM mode
	sta	COCO_RAMROM_MODE
	clr	BASIC_WARMSTART_FLAG
	jmp	BASIC_START
#elif defined(TARGET_SIM)
	tfr	x,d
	stb	SIM_EXIT_REG
	bra	__exit
#else
	lds	MEM(__stack_ptr)
	tfr	x,d
	rts
#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; __start : Entry point to the program
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.globl	__start
__start:

#ifdef __PIC__
	;; Compute relocation offset
	tfr	pc,d
	subd	#.
	std	MEM(__reloc_offset)
#endif

#ifdef HAVE_DIRECT
	;; Initialize the direct page pointer
	lda	#s_.direct/0x100
	tfr	a,dp
#endif

#ifdef TARGET_COCO
	;; Turn off interrupts
	orcc	#(0x10|0x40)

	;; Setup All RAM Mode
	sta	COCO_ALLRAM_MODE
#endif /* TARGET_COCO */

#ifdef TARGET_UNKNOWN
	;; Save stack pointer needed by _exit()
	sts	MEM(__stack_ptr)
#else
	;; Initialize the stack
	lds	#__STACK_TOP-2
#endif

#ifdef TARGET_UNKNOWN
	;; Initialize .bss area to zero
	ldx	#l_.bss
	clrb
	pshs	x,d
	LEA	(x,s_.bss)
#ifdef __ABI_STACK__
	pshs	x
#endif
	CALL	_memset
#ifdef __ABI_STACK__
	leas	6,s
#else
	leas	4,s
#endif

	;; Register finalizer callback
	LEA	(x,__do_dtors)
#ifdef __ABI_STACK__
	pshs	x
#endif
	CALL	_atexit
#ifdef __ABI_STACK__
	leas	2,s
#endif
#endif

	;; Call any initializer functions
	ldy	#l_.ctors
	beq	__ctors_done
	LEA	(u,s_.ctors)
__ctors_loop:
#ifdef __PIC__
	ldx	,u++
	ldd	MEM(__reloc_offset)
	jsr	d,x
#else
	jsr	[,u++]
#endif
	leay	-2,y
	bne	__ctors_loop
__ctors_done:


#ifdef TARGET_SIM
	;; Enable interrupts on the simulator
	andcc	#~(0x10|0x40)
#endif

	;; Set up the environment
	/* TODO */

	;; Set up argc/argv
#ifndef TARGET_COCO
	;;  __argc/__argv need to be defined elsewhere,
	;;  for example from C code:
	;;   int _argc = 1;
	;;   char *_argv[] = {"param1", NULL};
	LEA	(x,__argv)
#ifdef __ABI_STACK__
	ldd	MEM(__argc)
	pshs	x,d
#else
	pshs	x
	ldx	MEM(__argc)
#endif
#endif

	;; Call the main function.  The exit code will
	;; be returned in the X register, unless compiled
	;; with -mdret, in which case it comes back in D.
	CALL	_main

#ifndef TARGET_COCO
#ifdef __ABI_STACK__
	leas	4,s
#else
	leas	2,s
#endif
#endif

#ifndef TARGET_UNKNOWN
	;; Call any finalizer functions
#ifdef __DRET__
	pshs	d
#else
	pshs	x
#endif
	ldy	#l_.dtors
	beq	__dtors_done
	LEA	(u,s_.dtors)
__dtors_loop:
#ifdef __PIC__
	ldx	,u++
	ldd	MEM(__reloc_offset)
	jsr	d,x
#else
	jsr	[,u++]
#endif
	leay	-2,y
	bne	__dtors_loop
__dtors_done:
#ifndef __ABI_STACK__
	puls	x
#endif
#else
#ifdef __ABI_STACK__
#ifdef __DRET__
	pshs	d
#else
	pshs	x
#endif
#else
#ifdef __DRET__
	tfr	d,x
#endif
#endif
#endif

	;; If main returns, then invoke exit() to stop the program
	JUMP	_exit


#ifdef TARGET_UNKNOWN
	;; Call any finalizer functions
__do_dtors:
	pshs	u,y
	ldy	#l_.dtors
	beq	__dtors_done
	LEA	(u,s_.dtors)
__dtors_loop:
#ifdef __PIC__
	ldx	,u++
	ldd	MEM(__reloc_offset)
	jsr	d,x
#else
	jsr	[,u++]
#endif
	leay	-2,y
	bne	__dtors_loop
__dtors_done:
	puls	y,u,pc
#endif

#ifndef TARGET_UNKNOWN
	;;;
	;;; __crt0_vector : Default handler for interrupts
	;;;
___crt0_vector:
	;; The default behavior is to simply ignore all
	;; non-reset interrupts.
	rti

	.area .vector
	;;;
	;;; .vector : The interrupt vector table
	;;; The linker will ensure that this gets loaded at address 0xFFF0.
	;;;
vectors:
	.word ___crt0_vector
	.word ___crt0_vector
	.word ___crt0_vector
	.word ___crt0_vector
	.word ___crt0_vector
	.word ___crt0_vector
	.word ___crt0_vector
	.word __start
	.area	.text
#endif

#ifdef __PIC__
	.area	.noinit
	.globl	__reloc_offset
__reloc_offset:
	.blkb	2
	.area	.text
#endif

#ifdef TARGET_UNKNOWN
	.area	.noinit
	.globl	__stack_ptr
__stack_ptr:
	.blkb	2
	.area	.text
#endif

	;; Set up the entry point for the linked binary
	.end	__start
