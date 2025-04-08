/* 6809dasm.c - a 6809 opcode disassembler */
/* Version 1.6 27-DEC-95 */
/* Copyright © 1995 Sean Riddle */

/* thanks to Franklin Bowen for bug fixes, ideas */

/* Freely distributable on any medium given all copyrights are retained */
/* by the author and no charge greater than $7.00 is made for obtaining */
/* this software */

/* Please send all bug reports, update ideas and data files to: */
/* sriddle@ionet.net */

/* latest version at: */
/* <a href="http://www.ionet.net/~sriddle">Please don't hurl on my URL!</a> */

/* the data files must be kept compatible across systems! */
package de.malban.vide.dissy;

/**
 *
 * @author malban
 */
public class DASMStatics {
     /* 6809 ADDRESSING MODES */
    protected static final int INH =0;
    protected static final int DIR =1;
    protected static final int IND= 2;
    protected static final int REL =3;
    protected static final int EXT= 4;
    protected static final int IMM =5;
    protected static final int LREL=6;
    protected static final int PG2 =7 ;                                   /* PAGE SWITCHES - Page 2 */
    protected static final int PG3 =8 ;                                                   /* Page 3 */
    
    protected static final int  TABOPNAME = 22;
    protected static final int  TABOPERAND = 31;
    protected static final int  TABLINENUM = 48;
    protected static final int  TABCOMM = 55;

    protected static final int  OPNAMETAB = (TABOPNAME-1);
    protected static final int  OPERANDTAB = (TABOPERAND-1);
    protected static final int  COMMTAB = (TABCOMM-1);
    protected static final int  LINENUMTAB = (TABLINENUM-1);
    
    protected static final int  NUMPG1OPS = 223;
    protected static final int  NUMPG2OPS = 38;
    protected static final int  NUMPG3OPS = 9;
    
    public final static class Opcodeinfo
    {                           /* opcode structure */
        public int opcode;	/* 8-bit opcode value */
        public int numoperands;
        public String name;	/* opcode name */
        public int mode;	/* addressing mode */
        public int numcycles;	/* number of cycles - not used */
        private Opcodeinfo(int op, int no, String n, int mo, int nc )
        {
            opcode = op;
            numoperands = no;
            name = n;
            mode = mo;
            numcycles = nc;
        }
    };
    protected static final Opcodeinfo[] pg1opcodes=new Opcodeinfo[NUMPG1OPS];
    protected static final Opcodeinfo[] pg2opcodes=new Opcodeinfo[NUMPG2OPS];
    protected static final Opcodeinfo[] pg3opcodes=new Opcodeinfo[NUMPG3OPS];
    
    static int[] iLenPage0 = new int[256];
    static int[] iLenPage1 = new int[256];
    static int[] iLenPage2 = new int[256];
    
    static
    {
        int i=0;
        pg1opcodes[i++] = new Opcodeinfo(0,1,"neg",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(3,1,"com",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(4,1,"lsr",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(6,1,"ror",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(7,1,"asr",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(8,1,"asl",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(9,1,"rol",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(10,1,"dec",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(12,1,"inc",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(13,1,"tst",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(14,1,"jmp",DIR,3);
        pg1opcodes[i++] = new Opcodeinfo(15,1,"clr",DIR,6);

        pg1opcodes[i++] = new Opcodeinfo(16,1,"page2",PG2,0);
        pg1opcodes[i++] = new Opcodeinfo(17,1,"page3",PG3,0);
        pg1opcodes[i++] = new Opcodeinfo(18,0,"nop",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(19,0,"sync",INH,4);
        pg1opcodes[i++] = new Opcodeinfo(22,2,"lbra",LREL,5);
        pg1opcodes[i++] = new Opcodeinfo(23,2,"lbsr",LREL,9);
        pg1opcodes[i++] = new Opcodeinfo(25,0,"daa",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(26,1,"orcc",IMM,3);
        pg1opcodes[i++] = new Opcodeinfo(28,1,"andcc",IMM,3);
        pg1opcodes[i++] = new Opcodeinfo(29,0,"sex",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(30,1,"exg",IMM,8);
        pg1opcodes[i++] = new Opcodeinfo(31,1,"tfr",IMM,6);

        pg1opcodes[i++] = new Opcodeinfo(32,1,"bra",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(33,1,"brn",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(34,1,"bhi",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(35,1,"bls",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(36,1,"bcc",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(37,1,"bcs",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(38,1,"bne",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(39,1,"beq",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(40,1,"bvc",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(41,1,"bvs",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(42,1,"bpl",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(43,1,"bmi",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(44,1,"bge",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(45,1,"blt",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(46,1,"bgt",REL,3);
        pg1opcodes[i++] = new Opcodeinfo(47,1,"ble",REL,3);

        pg1opcodes[i++] = new Opcodeinfo(48,1,"leax",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(49,1,"leay",IND,4); // ? Frogger 0585
        pg1opcodes[i++] = new Opcodeinfo(50,1,"leas",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(51,1,"leau",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(52,1,"pshs",INH,5);
        pg1opcodes[i++] = new Opcodeinfo(53,1,"puls",INH,5);
        pg1opcodes[i++] = new Opcodeinfo(54,1,"pshu",INH,5);
        pg1opcodes[i++] = new Opcodeinfo(55,1,"pulu",INH,5);
        pg1opcodes[i++] = new Opcodeinfo(57,0,"rts",INH,5);
        pg1opcodes[i++] = new Opcodeinfo(58,0,"abx",INH,3);
        pg1opcodes[i++] = new Opcodeinfo(59,0,"rti",INH,6);
        pg1opcodes[i++] = new Opcodeinfo(60,1,"cwai",IMM,20);
        pg1opcodes[i++] = new Opcodeinfo(61,0,"mul",INH,11);
        pg1opcodes[i++] = new Opcodeinfo(63,0,"swi",INH,19);

        pg1opcodes[i++] = new Opcodeinfo(64,0,"nega",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(67,0,"coma",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(68,0,"lsra",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(70,0,"rora",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(71,0,"asra",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(72,0,"asla",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(73,0,"rola",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(74,0,"deca",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(76,0,"inca",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(77,0,"tsta",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(79,0,"clra",INH,2);

        pg1opcodes[i++] = new Opcodeinfo(80,0,"negb",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(83,0,"comb",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(84,0,"lsrb",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(86,0,"rorb",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(87,0,"asrb",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(88,0,"aslb",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(89,0,"rolb",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(90,0,"decb",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(92,0,"incb",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(93,0,"tstb",INH,2);
        pg1opcodes[i++] = new Opcodeinfo(95,0,"clrb",INH,2);

        pg1opcodes[i++] = new Opcodeinfo(96,1,"neg",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(99,1,"com",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(100,1,"lsr",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(102,1,"ror",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(103,1,"asr",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(104,1,"asl",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(105,1,"rol",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(106,1,"dec",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(108,1,"inc",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(109,1,"tst",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(110,1,"jmp",IND,3);
        pg1opcodes[i++] = new Opcodeinfo(111,1,"clr",IND,6);

        pg1opcodes[i++] = new Opcodeinfo(112,2,"neg",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(115,2,"com",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(116,2,"lsr",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(118,2,"ror",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(119,2,"asr",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(120,2,"asl",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(121,2,"rol",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(122,2,"dec",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(124,2,"inc",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(125,2,"tst",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(126,2,"jmp",EXT,4);
        pg1opcodes[i++] = new Opcodeinfo(127,2,"clr",EXT,7);

        pg1opcodes[i++] = new Opcodeinfo(128,1,"suba",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(129,1,"cmpa",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(130,1,"sbca",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(131,2,"subd",IMM,4);
        pg1opcodes[i++] = new Opcodeinfo(132,1,"anda",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(133,1,"bita",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(134,1,"lda",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(136,1,"eora",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(137,1,"adca",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(138,1,"ora",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(139,1,"adda",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(140,2,"cmpx",IMM,4);
        pg1opcodes[i++] = new Opcodeinfo(141,1,"bsr",REL,7);
        pg1opcodes[i++] = new Opcodeinfo(142,2,"ldx",IMM,3);

        pg1opcodes[i++] = new Opcodeinfo(144,1,"suba",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(145,1,"cmpa",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(146,1,"sbca",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(147,1,"subd",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(148,1,"anda",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(149,1,"bita",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(150,1,"lda",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(151,1,"sta",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(152,1,"eora",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(153,1,"adca",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(154,1,"ora",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(155,1,"adda",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(156,1,"cmpx",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(157,1,"jsr",DIR,7);
        pg1opcodes[i++] = new Opcodeinfo(158,1,"ldx",DIR,5);
        pg1opcodes[i++] = new Opcodeinfo(159,1,"stx",DIR,5);
// F        pg1opcodes[i++] = new Opcodeinfo(159,1,"stx",DIR,4);

        pg1opcodes[i++] = new Opcodeinfo(160,1,"suba",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(161,1,"cmpa",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(162,1,"sbca",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(163,1,"subd",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(164,1,"anda",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(165,1,"bita",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(166,1,"lda",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(167,1,"sta",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(168,1,"eora",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(169,1,"adca",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(170,1,"ora",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(171,1,"adda",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(172,1,"cmpx",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(173,1,"jsr",IND,7);
        pg1opcodes[i++] = new Opcodeinfo(174,1,"ldx",IND,5);
        pg1opcodes[i++] = new Opcodeinfo(175,1,"stx",IND,5);
// F        pg1opcodes[i++] = new Opcodeinfo(175,1,"stx",IND,4);

        pg1opcodes[i++] = new Opcodeinfo(176,2,"suba",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(177,2,"cmpa",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(178,2,"sbca",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(179,2,"subd",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(180,2,"anda",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(181,2,"bita",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(182,2,"lda",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(183,2,"sta",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(184,2,"eora",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(185,2,"adca",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(186,2,"ora",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(187,2,"adda",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(188,2,"cmpx",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(189,2,"jsr",EXT,8);
        pg1opcodes[i++] = new Opcodeinfo(190,2,"ldx",EXT,6);
        pg1opcodes[i++] = new Opcodeinfo(191,2,"stx",EXT,6);
// F        pg1opcodes[i++] = new Opcodeinfo(191,2,"stx",EXT,5);

        pg1opcodes[i++] = new Opcodeinfo(192,1,"subb",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(193,1,"cmpb",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(194,1,"sbcb",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(195,2,"addd",IMM,4);
        pg1opcodes[i++] = new Opcodeinfo(196,1,"andb",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(197,1,"bitb",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(198,1,"ldb",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(200,1,"eorb",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(201,1,"adcb",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(202,1,"orb",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(203,1,"addb",IMM,2);
        pg1opcodes[i++] = new Opcodeinfo(204,2,"ldd",IMM,3);
        pg1opcodes[i++] = new Opcodeinfo(206,2,"ldu",IMM,3);

        pg1opcodes[i++] = new Opcodeinfo(208,1,"subb",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(209,1,"cmpb",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(210,1,"sbcb",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(211,1,"addd",DIR,6);
        pg1opcodes[i++] = new Opcodeinfo(212,1,"andb",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(213,1,"bitb",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(214,1,"ldb",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(215,1,"stb",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(216,1,"eorb",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(217,1,"adcb",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(218,1,"orb",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(219,1,"addb",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(220,1,"ldd",DIR,5);
        pg1opcodes[i++] = new Opcodeinfo(221,1,"std",DIR,5);
// F        pg1opcodes[i++] = new Opcodeinfo(221,1,"std",DIR,4);
        pg1opcodes[i++] = new Opcodeinfo(222,1,"ldu",DIR,5);
        pg1opcodes[i++] = new Opcodeinfo(223,1,"stu",DIR,5);
// F        pg1opcodes[i++] = new Opcodeinfo(223,1,"stu",DIR,4);

        pg1opcodes[i++] = new Opcodeinfo(224,1,"subb",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(225,1,"cmpb",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(226,1,"sbcb",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(227,1,"addd",IND,6);
        pg1opcodes[i++] = new Opcodeinfo(228,1,"andb",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(229,1,"bitb",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(230,1,"ldb",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(231,1,"stb",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(232,1,"eorb",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(233,1,"adcb",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(234,1,"orb",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(235,1,"addb",IND,4);
// F        pg1opcodes[i++] = new Opcodeinfo(236,1,"ldd",IND,4);
// F        pg1opcodes[i++] = new Opcodeinfo(237,1,"std",IND,4);
        pg1opcodes[i++] = new Opcodeinfo(236,1,"ldd",IND,5);
        pg1opcodes[i++] = new Opcodeinfo(237,1,"std",IND,5);
        pg1opcodes[i++] = new Opcodeinfo(238,1,"ldu",IND,5);
        pg1opcodes[i++] = new Opcodeinfo(239,1,"stu",IND,5);
// F        pg1opcodes[i++] = new Opcodeinfo(239,1,"stu",IND,4);

        pg1opcodes[i++] = new Opcodeinfo(240,2,"subb",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(241,2,"cmpb",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(242,2,"sbcb",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(243,2,"addd",EXT,7);
        pg1opcodes[i++] = new Opcodeinfo(244,2,"andb",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(245,2,"bitb",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(246,2,"ldb",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(247,2,"stb",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(248,2,"eorb",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(249,2,"adcb",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(250,2,"orb",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(251,2,"addb",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(252,2,"ldd",EXT,6);
        pg1opcodes[i++] = new Opcodeinfo(253,2,"std",EXT,6);
// F        pg1opcodes[i++] = new Opcodeinfo(252,2,"ldd",EXT,5);
// F        pg1opcodes[i++] = new Opcodeinfo(253,2,"std",EXT,5);
        pg1opcodes[i++] = new Opcodeinfo(254,2,"ldu",EXT,6);
        pg1opcodes[i++] = new Opcodeinfo(255,2,"stu",EXT,6);
// F        pg1opcodes[i++] = new Opcodeinfo(255,2,"stu",EXT,5);

        /* page 2 ops 10xx*/
        i=0;
        pg2opcodes[i++] = new Opcodeinfo(33,3,"lbrn",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(34,3,"lbhi",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(35,3,"lbls",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(36,3,"lbcc",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(37,3,"lbcs",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(38,3,"lbne",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(39,3,"lbeq",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(40,3,"lbvc",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(41,3,"lbvs",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(42,3,"lbpl",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(43,3,"lbmi",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(44,3,"lbge",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(45,3,"lblt",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(46,3,"lbgt",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(47,3,"lble",LREL,5);
        pg2opcodes[i++] = new Opcodeinfo(63,1,"swi2",INH,20); /* chris changed numoperands from 2 to 1 */
        pg2opcodes[i++] = new Opcodeinfo(131,3,"cmpd",IMM,5);
        pg2opcodes[i++] = new Opcodeinfo(140,3,"cmpy",IMM,5);
        pg2opcodes[i++] = new Opcodeinfo(142,3,"ldy",IMM,4);
        pg2opcodes[i++] = new Opcodeinfo(147,2,"cmpd",DIR,7);
        pg2opcodes[i++] = new Opcodeinfo(156,2,"cmpy",DIR,7);
        pg2opcodes[i++] = new Opcodeinfo(158,2,"ldy",DIR,6);
        pg2opcodes[i++] = new Opcodeinfo(159,2,"sty",DIR,6);
        pg2opcodes[i++] = new Opcodeinfo(163,2,"cmpd",IND,7);
        pg2opcodes[i++] = new Opcodeinfo(172,2,"cmpy",IND,7);
        pg2opcodes[i++] = new Opcodeinfo(174,2,"ldy",IND,6);
        pg2opcodes[i++] = new Opcodeinfo(175,2,"sty",IND,6);
        pg2opcodes[i++] = new Opcodeinfo(179,3,"cmpd",EXT,8);
        pg2opcodes[i++] = new Opcodeinfo(188,3,"cmpy",EXT,8);
        pg2opcodes[i++] = new Opcodeinfo(190,3,"ldy",EXT,7);
        pg2opcodes[i++] = new Opcodeinfo(191,3,"sty",EXT,7);
        pg2opcodes[i++] = new Opcodeinfo(206,3,"lds",IMM,4);
        pg2opcodes[i++] = new Opcodeinfo(222,2,"lds",DIR,6);
        pg2opcodes[i++] = new Opcodeinfo(223,2,"sts",DIR,6);
        pg2opcodes[i++] = new Opcodeinfo(238,2,"lds",IND,6);
        pg2opcodes[i++] = new Opcodeinfo(239,2,"sts",IND,6);
        pg2opcodes[i++] = new Opcodeinfo(254,3,"lds",EXT,7);
        pg2opcodes[i++] = new Opcodeinfo(255,3,"sts",EXT,7);

        i=0;
        /* page 3 ops 11xx */
        pg3opcodes[i++] = new Opcodeinfo(63,1,"swi3",INH,20);
        pg3opcodes[i++] = new Opcodeinfo(131,3,"cmpu",IMM,5);
        pg3opcodes[i++] = new Opcodeinfo(140,3,"cmps",IMM,5);
        pg3opcodes[i++] = new Opcodeinfo(147,2,"cmpu",DIR,7);
        pg3opcodes[i++] = new Opcodeinfo(156,2,"cmps",DIR,7);
        pg3opcodes[i++] = new Opcodeinfo(163,2,"cmpu",IND,7);
        pg3opcodes[i++] = new Opcodeinfo(172,2,"cmps",IND,7);
        pg3opcodes[i++] = new Opcodeinfo(179,3,"cmpu",EXT,8);
        pg3opcodes[i++] = new Opcodeinfo(188,3,"cmps",EXT,8);

        for (int l=0;l<256; l++)
        {
            iLenPage0[l] = 0;
            iLenPage1[l] = 0;
            iLenPage2[l] = 0;
        }
        for (int l=0;l<NUMPG1OPS; l++)
        {
            Opcodeinfo info = pg1opcodes[l];
            iLenPage0[info.opcode] = info.numoperands;
        }
        for (int l=0;l<NUMPG2OPS; l++)
        {
            Opcodeinfo info = pg2opcodes[l];
            iLenPage1[info.opcode] = info.numoperands;
        }
        for (int l=0;l<NUMPG3OPS; l++)
        {
            Opcodeinfo info = pg3opcodes[l];
            iLenPage2[info.opcode] = info.numoperands;
        }
    }
    protected static final Opcodeinfo[][] pgpointers=
    {
        pg1opcodes, pg2opcodes, pg3opcodes
    };

    public static int getNumOpcodes(byte byte1, byte byte2)
    {
        int len = 0;
        if (byte1 == 0x10)
        {
            len = iLenPage1[(int)(byte2&0xff)];
        }
        else if (byte1 == 0x11)
        {
            len = iLenPage2[(int)(byte2&0xff)];
        }
        else 
        {
            len = iLenPage0[(int)(byte1&0xff)];
        }
        return len;
    }
    
    
    protected static final int[] numops= { NUMPG1OPS,NUMPG2OPS,NUMPG3OPS};
    protected static final String[] modenames=
    {
     "inherent",
     "direct",
     "indexed",
     "relative",
     "extended",
     "immediate",
     "long relative",
     "page 2",
     "page 3"
    };    
    
    protected static final String[] regs={"x","y","u","s","pc"};
    protected static final String[] teregs={"d","x","y","u","s","pc","inv","inv","a","b","cc", "dp","inv","inv","inv","inv"};
    protected static final int[]    teregssize={16,16,16,16,16,16,0,0,8,8,8,8,0,0,0,0};
    
}
