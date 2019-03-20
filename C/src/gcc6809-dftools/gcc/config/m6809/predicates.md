;; Predicate definitions for Motorola 6809
;; Copyright (C) 2006, 2007, 2008, 2009 Free Software Foundation, Inc.
;;
;; This file is part of GCC.
;;
;; GCC is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; GCC is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GCC; see the file COPYING3.  If not see
;; <http://www.gnu.org/licenses/>.

;; whole_register_operand is like register_operand, but it
;; does not allow SUBREGs.
(define_predicate "whole_register_operand"
  (and (match_code "reg")
       (match_operand 0 "register_operand")))


;; A predicate that matches any index register.  This can be used in nameless
;; patterns and peepholes which need a 16-bit reg, but not D.
(define_predicate "index_register_operand"
  (and (match_code "reg")
       (match_test "REGNO (op) == HARD_X_REGNUM || REGNO (op) == HARD_Y_REGNUM || REGNO (op) == HARD_U_REGNUM")))


;; Likwise, a replacement for general_operand which excludes
;; SUBREGs.
(define_predicate "whole_general_operand"
  (and (match_code "const_int,const_double,const,symbol_ref,label_ref,reg,mem")
       (match_operand 0 "general_operand")))


(define_predicate "add_general_operand"
  (and (match_code "const_int,const_double,const,symbol_ref,label_ref,reg,mem")
       (match_operand 0 "general_operand")
		 (match_test "REGNO (op) != SOFT_AP_REGNUM")))


(define_predicate "shift_count_operand"
  (and (match_code "const_int")
     (and (match_operand 0 "const_int_operand")
       (match_test "INTVAL (op) == 1 || INTVAL (op) == 8"))))


;; A predicate that matches any bitwise logical operator.  This
;; allows for a single RTL pattern to be used for multiple operations.
(define_predicate "logical_bit_operator"
	(ior (match_code "and") (match_code "ior") (match_code "xor")))


;; A predicate that matches any shift or rotate operator.  This
;; allows for a single RTL pattern to be used for multiple operations.
(define_predicate "shift_rotate_operator"
	(ior (match_code "ashift") (match_code "ashiftrt") (match_code "lshiftrt")
	     (match_code "rotate") (match_code "rotatert")))


(define_predicate "symbolic_operand" (match_code "symbol_ref"))

