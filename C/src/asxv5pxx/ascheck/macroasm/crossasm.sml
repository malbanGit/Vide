	.title	Cross Assembler Macro Library

	; This MACRO Library is Case Insensitive.
	;
	; Local Variable
	;
	;	.$.SML.$.
	;
	; Symbol Definitions
	;
	;	.$.LIST.$.
	;
	; Defined Macro Cross Assembler Groups:
	;
	;	I8085
	;	M6800
	;	M6801
	;	M6804
	;	M6805
	;	M6809
	;	S2650
	;

; The Macro Source Listing Definition

.$.SML.$. =: 0
.if	idn	a,A
  .iif	def,.$$.list	.$.SML.$. = -1
.else
  .iif	def,.$$.list	.$.SML.$. = -1
  .iif	def,.$$.LIST	.$.SML.$. =  1
.endif
.iif	lt,.$.SML.$.	.define		list.$$.
.iif	gt,.$.SML.$.	.define		LIST.$$.
.iif	ne,.$.SML.$.	.define		.$.LIST.$.


; Macro Based 8085 Cross Assembler

.$.SML.$. =: 0
.if	idn	a,A
  .iif	def,.$$.i8085	.$.SML.$. = -1
.else
  .iif	def,.$$.i8085	.$.SML.$. = -1
  .iif	def,.$$.I8085	.$.SML.$. =  1
.endif
.iif	lt,.$.SML.$.	.define		i8085.$$.
.iif	gt,.$.SML.$.	.define		I8085.$$.
.iif	ne,.$.SML.$.	.include	"i8085.mac"


; Macro Based 6800 Cross Assembler

.$.SML.$. =: 0
.if	idn	a,A
  .iif	def,.$$.m6800	.$.SML.$. = -1
.else
  .iif	def,.$$.m6800	.$.SML.$. = -1
  .iif	def,.$$.M6800	.$.SML.$. =  1
.endif
.iif	lt,.$.SML.$.	.define		m6800.$$.
.iif	gt,.$.SML.$.	.define		M6800.$$.
.iif	ne,.$.SML.$.	.include	"m6800.mac"


; Macro Based 6801 Cross Assembler

.$.SML.$. =: 0
.if	idn	a,A
  .iif	def,.$$.m6801	.$.SML.$. = -1
.else
  .iif	def,.$$.m6801	.$.SML.$. = -1
  .iif	def,.$$.M6801	.$.SML.$. =  1
.endif
.iif	lt,.$.SML.$.	.define		m6801.$$.
.iif	gt,.$.SML.$.	.define		M6801.$$.
.iif	ne,.$.SML.$.	.include	"m6801.mac"


; Macro Based 6804 Cross Assembler

.$.SML.$. =: 0
.if	idn	a,A
  .iif	def,.$$.m6804	.$.SML.$. = -1
.else
  .iif	def,.$$.m6804	.$.SML.$. = -1
  .iif	def,.$$.M6804	.$.SML.$. =  1
.endif
.iif	lt,.$.SML.$.	.define		m6804.$$.
.iif	gt,.$.SML.$.	.define		M6804.$$.
.iif	ne,.$.SML.$.	.include	"m6804.mac"


; Macro Based 6805 Cross Assembler

.$.SML.$. =: 0
.if	idn	a,A
  .iif	def,.$$.m6805	.$.SML.$. = -1
.else
  .iif	def,.$$.m6805	.$.SML.$. = -1
  .iif	def,.$$.M6805	.$.SML.$. =  1
.endif
.iif	lt,.$.SML.$.	.define		m6805.$$.
.iif	gt,.$.SML.$.	.define		M6805.$$.
.iif	ne,.$.SML.$.	.include	"m6805.mac"


; Macro Based 6809 Cross Assembler

.$.SML.$. =: 0
.if	idn	a,A
  .iif	def,.$$.m6809	.$.SML.$. = -1
.else
  .iif	def,.$$.m6809	.$.SML.$. = -1
  .iif	def,.$$.M6809	.$.SML.$. =  1
.endif
.iif	lt,.$.SML.$.	.define		m6809.$$.
.iif	gt,.$.SML.$.	.define		M6809.$$.
.iif	ne,.$.SML.$.	.include	"m6809.mac"


; Macro Based 2650 Cross Assembler

.$.SML.$. =: 0
.if	idn	a,A
  .iif	def,.$$.s2650	.$.SML.$. = -1
.else
  .iif	def,.$$.s2650	.$.SML.$. = -1
  .iif	def,.$$.S2650	.$.SML.$. =  1
.endif
.iif	lt,.$.SML.$.	.define		s2650.$$.
.iif	gt,.$.SML.$.	.define		S2650.$$.
.iif	ne,.$.SML.$.	.include	"s2650.mac"

