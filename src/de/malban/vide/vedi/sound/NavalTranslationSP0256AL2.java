// all coce in this file is based on
// the code found in:
// http://atariage.com/forums/index.php?automodule=blog&blogid=134&showentry=1614
// http://atariage.com/forums/index.php?app=core&module=attach&section=attach&attach_id=82222
//
// done by a forum member who goes by the name "batari" 


/*
**	English to Phoneme rules.
**
**	Derived from: 
**
**	     AUTOMATIC TRANSLATION OF ENGLISH TEXT TO PHONETICS
**	            BY MEANS OF LETTER-TO-SOUND RULES
**
**			NRL Report 7948
**
**		      January 21st, 1976
**	    Naval Research Laboratory, Washington, D.C.
**
**
**	Published by the National Technical Information Service as
**	document "AD/A021 929".
**
**
**
**	The Phoneme codes:
**
**		IY-128	bEEt		IH-129	bIt
**		EY-130	gAte		EH-131	gEt
**		AE-132	fAt		AA-136	fAther
**		AO-133	lAWn		OW-142	lOne
**		UH-138	fUll		UW-139	fOOl
**		ER-151	mURdER		AX-133	About
**		AH-134	bUt		AY-157	hIde
**		AW-163	hOW		OY-156	tOY
**	done all above
**		p-199	Pack		b-171	Back
**		t-191	Time		d-174	Dime
**		k-195	Coat		g-179	Goat
**		f-186	Fault		v-166	Vault
**		TH-190	eTHer		DH-169	eiTHer
**		s-187	Sue		z-167	Zoo
**		SH-189	leaSH		ZH-168	leiSure
**		h-184	How		m-140	suM
**		n-142	suN		NG-144	suNG
**		l-145	Laugh		w-147	Wear
**		y-158	Young		r-148	Rate
**		CH-182	CHar		j-165	Jar
**		WH-185	WHere
** done column
**
**	Rules are made up of four parts:
**	
**		The left context.
**		The text to match.
**		The right context.
**		The phonemes to substitute for the matched text.
**
**	Procedure:
**
**		Seperate each block of letters (apostrophes included) 
**		and add a space on each side.  For each unmatched 
**		letter in the word, look through the rules where the 
**		text to match starts with the letter in the word.  If 
**		the text to match is found and the right and left 
**		context patterns also match, output the phonemes for 
**		that rule and skip to the next unmatched letter.
**
**
**	Special Context Symbols:
**
**		#	One or more vowels
**		:	Zero or more consonants
**		^	One consonant.
**		.	One of B, D, V, G, J, L, M, N, R, W or Z (voiced 
**			consonants)
**		%	One of ER, E, ES, ED, ING, ELY (a suffix)
**			(Found in right context only)
**		+	One of E, I or Y (a "front" vowel)
**
*/
 package de.malban.vide.vedi.sound;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;

/**
 *
 * @author Malban
 */
public class NavalTranslationSP0256AL2 {
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    public static final String Anything = "";
    public static final String Nothing = " ";

    public static final String Pause = " ";
    public static final String Silent = "";
    
    public class Rule
    {
        String left;
        String match;
        String right;
        String out;
    }
    // https://github.com/jas8mm/retroSpeak/blob/master/retroTTS.py

// http://www2.eng.cam.ac.uk/~tpl/asp/source/English.java    

/* Phoneme definitions - 41 Strings for phonemes in English
AY, AW, OY, AND WH need two unicode chars to make std IPA representation*/

static final String IY = "19 ";
static final String IH = "12 ";
static final String EY = "20 ";
static final String EH = "7 ";
static final String AE = "26 ";

static final String AA = "24 ";
static final String AO = "23 ";
static final String OW = "53 ";
static final String UH = "30 ";
static final String UW1 = "22 ";
static final String UW2 = "31 ";

static final String ER1 = "51 ";
static final String ER2 = "52 ";
static final String AX =  "15 ";
static final String AH = "15 "; // !!!!!
static final String AY = "6 ";
static final String AW = "32 ";

static final String OY = "5 ";
static final String p = "9 ";
static final String b1 = "28 ";
static final String b2 = "63 ";
static final String t1 = "17 ";
static final String t2 = "13 ";
static final String d1 = "21 ";
static final String d2 = "33 ";

static final String k1 = "42 ";
static final String k2 = "41 ";
static final String k3 = "8 ";
static final String g1 = "36 ";
static final String g2 = "61 ";
static final String g3 = "34";
static final String f = "40 ";
static final String v = "35 ";
static final String TH = "29 ";

static final String DH1 = "18 ";
static final String DH2 = "54 ";
static final String s = "55 ";
static final String z = "43 ";
static final String SH = "37 ";
static final String ZH = "38 ";

static final String HH1 = "27 ";
static final String HH2 = "57 ";
static final String m = "16 ";
static final String n1 = "11 ";
static final String n2 = "56 "; //ne
static final String NG = "44 ";
static final String l = "62 ";

static final String w = "46 ";
static final String y1 = "49 ";
static final String y2 = "25 ";

static final String r1 = "14 ";
static final String r2 = "29 ";
static final String xr = "47 ";
static final String or = "58 ";
static final String ar = "59 ";
static final String yr = "60 ";

static final String CH = "50 ";
static final String j = "10 ";
 	 
static final String WH = "48 ";	
    
/*    
# The NRL phoneme set is a subset of the ones available on the SP0256
# This dictionary maps from IPA to SP0256
NRLIPAtoSPO256 = { 'AA':'AA', 'AE':'AE', 'AH':'AX AX', 'AO':'AO', 'AW':'AW',  'AX':'AX',
                   'AY':'AY', 'b':'BB1', 'CH':'CH',  'd':'DD1', 'DH':'DH1', 'EH':'EH',
                   'ER':'ER1','EY':'EY', 'f':'FF',   'g':'GG2', 'h':'HH1',  'IH':'IH',
                   'IY':'IY', 'j':'JH',  'k':'KK1',  'l':'LL',  'm':'MM',   'n':'NN1',
                   'NG':'NG', 'OW':'OW', 'OY':'OY',  'p':'PP',  'r':'RR1',  's':'SS',
                   'SH':'SH', 't':'TT1', 'TH':'TH',  'UH':'UH',  'UW':'UW2','v':'VV',
'w':'WW', 'WH':'WH', 'y':'YY1', 'z':'ZZ', 'ZH':'ZH', 'PAUSE':'PA4' };    
*/
 
/* = Punctuation */
/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/

static final String punct_rules[][] =
        {
        {Anything,      " ",            Anything,       Pause   },
        {Anything,      "-",            Anything,       Silent  },
        {".",           "'S",           Anything,       z     	},
        {"#:.E",        "'S",           Anything,       z     	},
        {"#",           "'S",           Anything,       z     	},
        {Anything,      "'",            Anything,       Silent  },
        {Anything,      ",",            Anything,       Pause   },
        {Anything,      ".",            Anything,       Pause   },
        {Anything,      "?",            Anything,       Pause   },
        {Anything,      "!",            Anything,       Pause   },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/

static final String A_rules[][] =
        {
        {Anything,      "A",            Nothing,        AX    	},
        {Nothing,       "ARE",          Nothing,        ar},//AA+r  	},
        {Nothing,       "AR",           "O",            ar},//AX+r   	},
        {Anything,      "AR",           "#",            xr},//EH+r   	},
        {"^",           "AS",           "#",            EY+s   	},
        {Anything,      "A",            "WA",           AX    	},
        {Anything,      "AW",           Anything,       AO    	},
        {" :",          "ANY",          Anything,       EH+n1+IY },
        {Anything,      "A",            "^+#",          EY    	},
        {"#:",          "ALLY",         Anything,       AX+l+IY },
        {Nothing,       "AL",           "#",            AX+l    },
        {Anything,      "AGAIN",        Anything,       AX+g1+EH+n1 },
        {"#:",          "AG",           "E",            IH+j	},
        {Anything,      "A",            "^+:#",         AE	},
        {" :",          "A",            "^+ ",          EY      },
        {Anything,      "A",            "^%",           EY      },
        {Nothing,       "ARR",          Anything,       ar},//AX+r    },
        {Anything,      "ARR",          Anything,       xr},//AE+r    },
        {" :",          "AR",           Nothing,        ar},//AA+r    },
        {Anything,      "AR",           Nothing,        ER1      },
        {Anything,      "AR",           Anything,       ar},//AA+r	},
        {Anything,      "AIR",          Anything,       xr},//EH+r	},
        {Anything,      "AI",           Anything,       EY      },
        {Anything,      "AY",           Anything,       EY      },
        {Anything,      "AU",           Anything,       AO      },
        {"#:",          "AL",           Nothing,        AX+l    },
        {"#:",          "ALS",          Nothing,        AX+l+z  },
        {Anything,      "ALK",          Anything,       AO+k1    },
        {Anything,      "AL",           "^",            AO+l    },
        {" :",          "ABLE",         Anything,       EY+b1+AX+l },
        {Anything,      "ABLE",         Anything,       AX+b1+AX+l },
        {Anything,      "ANG",          "+",            EY+n1+j  },
        {Anything,      "A",            Anything,       AE    },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/

static final String B_rules[][] =
        {
        {Nothing,       "BE",           "^#",           b2+IH    },
        {Anything,      "BEING",        Anything,       b2+IY+IH+NG },
        {Nothing,       "BOTH",         Nothing,        b2+OW+TH },
        {Nothing,       "BUS",          "#",            b1+IH+z  },
        {Anything,      "BUIL",         Anything,       b2+IH+l  },
        {Anything,      "B",            Anything,       b1       },
        {Anything,      null,        Anything,       Silent  },
	};

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String C_rules[][] =
        {
        {Nothing,       "CH",           "^",            k1       },
        {"^E",          "CH",           Anything,       k1       },
        {Anything,      "CH",           Anything,       CH      },
        {" S",          "CI",           "#",            s+AY    },
        {Anything,      "CI",           "A",            SH      },
        {Anything,      "CI",           "O",            SH      },
        {Anything,      "CI",           "EN",           SH      },
        {Anything,      "C",            "+",            s	},
        {Anything,      "CK",           Anything,       k1       },
        {Anything,      "COM",          "%",            k3+AH+m  },
        {Anything,      "C",            Anything,       k1       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/

static final String D_rules[][] =
        {
        {"#:",          "DED",          Nothing,        d1+IH+d2  },
        {".E",          "D",            Nothing,        d2       },
        {"#:^E",        "D",            Nothing,        t1     	},
        {Nothing,       "DE",           "^#",           d1+IH   	},
        {Nothing,       "DO",           Nothing,        d1+UW2   	},
        {Nothing,       "DOES",         Anything,       d1+AH+z  },
        {Nothing,       "DOING",        Anything,       d1+UW2+IH+NG },
        {Nothing,       "DOW",          Anything,       d1+AW    },
        {Anything,      "DU",           "A",            j+UW1    },
        {Anything,      "D",            Anything,       d1       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/

static final String E_rules[][] =
        {
        {"#:",          "E",            Nothing,        Silent  },
        {"':^",         "E",            Nothing,        Silent  },
        {" :",          "E",            Nothing,        IY      },
        {"#",           "ED",           Nothing,        d2       },
        {"#:",          "E",            "D ",           Silent  },
        {Anything,      "EV",           "ER",           EH+v    },
        {Anything,      "E",            "^%",           IY      },
        {Anything,      "ERI",          "#",            yr+IY}, //IY+r+IY },
        {Anything,      "ERI",          Anything,       EH+r1+IH}, //EH+r+IH },
        {"#:",          "ER",           "#",            ER1      },
        {Anything,      "ER",           "#",            EH+r1    },
        {Anything,      "ER",           Anything,       ER1      },
        {Nothing,       "EVEN",         Anything,       IY+v+EH+n1 },
        {"#:",          "E",            "W",            Silent  },
        {"T",           "EW",           Anything,       UW2      },
        {"S",           "EW",           Anything,       UW2      },
        {"R",           "EW",           Anything,       UW2    	},
        {"D",           "EW",           Anything,       UW2    	},
        {"L",           "EW",           Anything,       UW2   	},
        {"Z",           "EW",           Anything,       UW2      },
        {"N",           "EW",           Anything,       UW2      },
        {"J",           "EW",           Anything,       UW2      },
        {"TH",          "EW",           Anything,       UW2      },
        {"CH",          "EW",           Anything,       UW2      },
        {"SH",          "EW",           Anything,       UW2      },
        {Anything,      "EW",           Anything,       1+UW2    },
        {Anything,      "E",            "O",            IY      },
        {"#:S",         "ES",           Nothing,        IH+z    },
        {"#:C",         "ES",           Nothing,        IH+z    },
        {"#:G",         "ES",           Nothing,        IH+z    },
        {"#:Z",         "ES",           Nothing,        IH+z    },
        {"#:X",         "ES",           Nothing,        IH+z    },
        {"#:J",         "ES",           Nothing,        IH+z    },
        {"#:CH",        "ES",           Nothing,        IH+z    },
        {"#:SH",        "ES",           Nothing,        IH+z    },
        {"#:",          "E",            "S ",           Silent  },
        {"#:",          "ELY",          Nothing,        l+IY    },
        {"#:",          "EMENT",        Anything,       m+EH+n1+t1 },
        {Anything,      "EFUL",         Anything,       f+UH+l  },
        {Anything,      "EE",           Anything,       IY      },
        {Anything,      "EARN",         Anything,       ER2+n1    },
        {Nothing,       "EAR",          "^",            ER1      },
        {Anything,      "EAD",          Anything,       EH+d2    },
        {"#:",          "EA",           Nothing,        IY+AX   },
        {Anything,      "EA",           "SU",           EH      },
        {Anything,      "EA",           Anything,       IY      },
        {Anything,      "EIGH",         Anything,       EY      },
        {Anything,      "EI",           Anything,       IY      },
        {Nothing,       "EYE",          Anything,       AY      },
        {Anything,      "EY",           Anything,       IY      },
        {Anything,      "EU",           Anything,       1+UW2     },
        {Anything,      "E",            Anything,       EH      },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/

static final String F_rules[][] =
        {
        {Anything,      "FUL",          Anything,       f+UH+l  },
        {Anything,      "F",            Anything,       f       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/

static final String G_rules[][] =
        {
        {Anything,      "GIV",          Anything,       g1+IH+v  },
        {Nothing,       "G",            "I^",           g1       },
        {Anything,      "GE",           "T",            g1+EH     },
        {"SU",          "GGES",         Anything,       g3+j+EH+s },
        {Anything,      "GG",           Anything,       g3       },
        {" B#",         "G",            Anything,       g1       },
        {Anything,      "G",            "+",            j	},
        {Anything,      "GREAT",        Anything,       g2+r2+EY+t2 },
        {"#",           "GH",           Anything,       Silent  },
        {Anything,      "G",            Anything,       g1       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String H_rules[][] =
        {
        {Nothing,       "HAV",          Anything,       HH2+AE+v  },
        {Nothing,       "HERE",         Anything,       HH1+yr},//IY+r  },
        {Nothing,       "HOUR",         Anything,       AW+ER1   },
        {Anything,      "HOW",          Anything,       HH2+AW    },
        {Anything,      "H",            "#",            HH1       },
        {Anything,      "H",            Anything,       Silent  },
        {Anything,      null,        Anything,       Silent  }
        };

	
/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String I_rules[][] =
        {
        {Nothing,       "IN",           Anything,       IH+n1    },
        {Nothing,       "I",            Nothing,        AY      },
        {Anything,      "IDI",          Anything,       IY+d2+IY   },
        {Anything,      "IN",           "D",            AY+n1    },
        {Anything,      "IER",          Anything,       IY+ER1   },
        {"#:R",         "IED",          Anything,       IY+d2    },
        {Anything,      "IED",          Nothing,        AY+d2    },
        {Anything,      "IEN",          Anything,       IY+EH+n1 },
        {Anything,      "IE",           "T",            AY+EH   },
        {" :",          "I",            "%",            AY      },
        {Anything,      "I",            "%",            IY      },
        {Anything,      "IE",           Anything,       IY      },
        {Anything,      "I",            "^+:#",         IH      },
        {Anything,      "IR",           "#",            AY+r1    },
        {Anything,      "IZ",           "%",            AY+z    },
        {Anything,      "IS",           "%",            AY+z    },
        {Anything,      "I",            "D%",           AY      },
        {"+^",          "I",            "^+",           IH      },
        {Anything,      "I",            "T%",           AY      },
        {"#:^",         "I",            "^+",           IH      },
        {Anything,      "I",            "^+",           AY      },
        {Anything,      "IR",           Anything,       ER1      },
        {Anything,      "IGH",          Anything,       AY      },
        {Anything,      "ILD",          Anything,       AY+l+d1  },
        {Anything,      "IGN",          Nothing,        AY+n1    },
        {Anything,      "IGN",          "^",            AY+n1    },
        {Anything,      "IGN",          "%",            AY+n1    },
        {Anything,      "IQUE",         Anything,       IY+k2    },
        {Anything,      "I",            Anything,       IH      },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String J_rules[][] =
        {
        {Anything,      "J",            Anything,       j       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String K_rules[][] =
        {
        {Nothing,       "K",            "N",            Silent  },
        {Anything,      "K",            Anything,       k1       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String L_rules[][] =
        {
        {Anything,      "LO",           "C#",           l+OW    },
        {"L",           "L",            Anything,       Silent  },
        {"#:^",         "L",            "%",            AX+l    },
        {Anything,      "LEAD",         Anything,       l+IY+d1  },
        {Anything,      "L",            Anything,       l       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String M_rules[][] =
        {
        {Anything,      "MOV",          Anything,       m+UW2+v  },
        {Anything,      "M",            Anything,       m       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String N_rules[][] =
        {
        {"E",           "NG",           "+",            n1+j     },
        {Anything,      "NG",           "R",            NG+g1    },
        {Anything,      "NG",           "#",            NG+g1    },
        {Anything,      "NGL",          "%",            NG+g1+AX+l },
        {Anything,      "NG",           Anything,       NG      },
        {Anything,      "NK",           Anything,       NG+k1    },
        {Nothing,       "NOW",          Nothing,        n1+AW    },
        {Anything,      "N",            Anything,       n1       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String O_rules[][] =
        {
        {Anything,      "OF",           Nothing,        AX+v    },
        {Anything,      "OROUGH",       Anything,       ER1+OW   },
        {"#:",          "OR",           Nothing,        ER1      },
        {"#:",          "ORS",          Nothing,        ER1+z    },
        {Anything,      "OR",           Anything,       AO+or},//r    },
        {Nothing,       "ONE",          Anything,       w+AH+n1  },
        {Anything,      "OW",           Anything,       OW      },
        {Nothing,       "OVER",         Anything,       OW+v+ER1 },
        {Anything,      "OV",           Anything,       AH+v    },
        {Anything,      "O",            "^%",           OW      },
        {Anything,      "O",            "^EN",          OW      },
        {Anything,      "O",            "^I#",          OW      },
        {Anything,      "OL",           "D",            OW+l    },
        {Anything,      "OUGHT",        Anything,       AO+t2    },
        {Anything,      "OUGH",         Anything,       AH+f    },
        {Nothing,       "OU",           Anything,       AW      },
        {"H",           "OU",           "S#",           AW      },
        {Anything,      "OUS",          Anything,       AX+s    },
        {Anything,      "OUR",          Anything,       AO+r1    },
        {Anything,      "OULD",         Anything,       UH+d2    },
        {"^",           "OU",           "^L",           AH      },
        {Anything,      "OUP",          Anything,       UW1+p    },
        {Anything,      "OU",           Anything,       AW      },
        {Anything,      "OY",           Anything,       OY      },
        {Anything,      "OING",         Anything,       OW+IH+NG },
        {Anything,      "OI",           Anything,       OY   	},
        {Anything,      "OOR",          Anything,       or},//AO+r   	},
        {Anything,      "OOK",          Anything,       UH+k1    },
        {Anything,      "OOD",          Anything,       UH+d2    },
        {Anything,      "OO",           Anything,       UW2      },
        {Anything,      "O",            "E",            OW      },
        {Anything,      "O",            Nothing,        OW      },
        {Anything,      "OA",           Anything,       OW      },
        {Nothing,       "ONLY",         Anything,       OW+n1+l+IY },
        {Nothing,       "ONCE",         Anything,       w+AH+n1+s },
        {Anything,      "ON'T",         Anything,       OW+n1+t2  },
        {"C",           "O",            "N",            AA    	},
        {Anything,      "O",            "NG",           AO      },
        {" :^",         "O",            "N",            AH      },
        {"I",           "ON",           Anything,       AX+n1    },
        {"#:",          "ON",           Nothing,        AX+n1    },
        {"#^",          "ON",           Anything,       AX+n1    },
        {Anything,      "O",            "ST ",          OW      },
        {Anything,      "OF",           "^",            AO+f    },
        {Anything,      "OTHER",        Anything,       AH+DH1+ER1 },
        {Anything,      "OSS",          Nothing,        AO+s    },
        {"#:^",         "OM",           Anything,       AH+m    },
        {Anything,      "O",            Anything,       AA      },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String P_rules[][] =
        {
        {Anything,      "PH",           Anything,       f       },
        {Anything,      "PEOP",         Anything,       p+IY+p  },
        {Anything,      "POW",          Anything,       p+AW    },
        {Anything,      "PUT",          Nothing,        p+UH+t1  },
        {Anything,      "P",            Anything,       p       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String Q_rules[][] =
        {
        {Anything,      "QUAR",         Anything,       k1+w+or},//AO+r },
        {Anything,      "QU",           Anything,       k1+w      },
        {Anything,      "Q",            Anything,       k1        },
        {Anything,      null,        Anything,       Silent   }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String R_rules[][] =
        {
        {Nothing,       "RE",           "^#",           r1+IY    },
        {Anything,      "R",            Anything,       r1       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String S_rules[][] =
        {
        {Anything,      "SH",           Anything,       SH      },
        {"#",           "SION",         Anything,       ZH+AX+n1 },
        {Anything,      "SOME",         Anything,       s+AH+m  },
        {"#",           "SUR",          "#",            ZH+ER1   },
        {Anything,      "SUR",          "#",            SH+ER1   },
        {"#",           "SU",           "#",            ZH+UW1   },
        {"#",           "SSU",          "#",            SH+UW1   },
        {"#",           "SED",          Nothing,        z+d1     },
        {"#",           "S",            "#",            z       },
        {Anything,      "SAID",         Anything,       s+EH+d1  },
        {"^",           "SION",         Anything,       SH+AX+n1 },
        {Anything,      "S",            "S",            Silent  },
        {".",           "S",            Nothing,        z       },
        {"#:.E",        "S",            Nothing,        z       },
        {"#:^##",       "S",            Nothing,        z       },
        {"#:^#",        "S",            Nothing,        s       },
        {"U",           "S",            Nothing,        s       },
        {" :#",         "S",            Nothing,        z       },
        {Nothing,       "SCH",          "#",            s+k2     },
        {Nothing,       "SCH",          Anything,       SH      },
        {Anything,      "S",            "C+",           Silent  },
        {"#",           "SM",           Anything,       z+m     },
        {"#",           "SN",           "'",            z+AX+n1  },
        {Anything,      "S",            Anything,       s       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String T_rules[][] =
        {
        {Nothing,       "THE",          Nothing,        DH2+AX   },
        {Anything,      "TO",           Nothing,        t1+UW1    },
        {Anything,      "THAT",         Nothing,        DH2+AE+t2 },
        {Nothing,       "THIS",         Nothing,        DH2+IH+s },
        {Nothing,       "THEY",         Anything,       DH2+EY   },
        {Nothing,       "THERE",        Anything,       DH2+xr},//EH+r },
        {Anything,      "THER",         Anything,       DH2+ER1   },
        {Anything,      "THEIR",        Anything,       DH2+xr},//EH+r },
        {Nothing,       "THAN",         Nothing,        DH2+AE+n1 },
        {Nothing,       "THEM",         Nothing,        DH2+EH+m },
        {Anything,      "THESE",        Nothing,        DH2+IY+z },
        {Nothing,       "THEN",         Anything,       DH2+EH+n1 },
        {Anything,      "THROUGH",      Anything,       TH+r2+UW2 },
        {Anything,      "THOSE",        Anything,       DH2+OW+z },
        {Anything,      "THOUGH",       Nothing,        DH2+OW   },
        {Nothing,       "THUS",         Anything,       DH2+AH+s },
        {Anything,      "TH",           Anything,       TH      },
        {"#:",          "TED",          Nothing,        t1+IH+d1  },
        {"S",           "TI",           "#N",           CH      },
        {Anything,      "TI",           "O",            SH      },
        {Anything,      "TI",           "A",            SH      },
        {Anything,      "TIEN",         Anything,       SH+AX+n1 },
        {Anything,      "TUR",          "#",            CH+ER1   },
        {Anything,      "TU",           "A",            CH+UW1   },
        {Nothing,       "TWO",          Anything,       t2+UW2    },
        {Anything,      "T",            Anything,       t1       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String U_rules[][] =
        {
        {Nothing,       "UN",           "I",            y1+UW1+n1  },
        {Nothing,       "UN",           Anything,       AH+n1    },
        {Nothing,       "UPON",         Anything,       AX+p+AO+n1 },
        {"T",           "UR",           "#",            ER2},//UH+r    },
        {"S",           "UR",           "#",            ER2},//UH+r    },
        {"R",           "UR",           "#",            ER2},//UH+r    },
        {"D",           "UR",           "#",            ER2},//UH+r    },
        {"L",           "UR",           "#",            ER2},//UH+r    },
        {"Z",           "UR",           "#",            ER2},//UH+r    },
        {"N",           "UR",           "#",            ER2},//UH+r    },
        {"J",           "UR",           "#",            ER2},//UH+r    },
        {"TH",          "UR",           "#",            ER2},//UH+r    },
        {"CH",          "UR",           "#",            ER2},//UH+r    },
        {"SH",          "UR",           "#",            ER2},//UH+r    },
        {Anything,      "UR",           "#",            y1 + ER1},//y1+UH+r  },
        {Anything,      "UR",           Anything,       ER1      },
        {Anything,      "U",            "^ ",           AH      },
        {Anything,      "U",            "^^",           AH      },
        {Anything,      "UY",           Anything,       AY      },
        {" G",          "U",            "#",            Silent  },
        {"G",           "U",            "%",            Silent  },
        {"G",           "U",            "#",            w       },
        {"#N",          "U",            Anything,       y1+UW1    },
        {"T",           "U",            Anything,       UW1      },
        {"S",           "U",            Anything,       UW1      },
        {"R",           "U",            Anything,       UW1      },
        {"D",           "U",            Anything,       UW1      },
        {"L",           "U",            Anything,       UW1      },
        {"Z",           "U",            Anything,       UW1      },
        {"N",           "U",            Anything,       UW1      },
        {"J",           "U",            Anything,       UW1      },
        {"TH",          "U",            Anything,       UW1      },
        {"CH",          "U",            Anything,       UW1      },
        {"SH",          "U",            Anything,       UW1      },
        {Anything,      "U",            Anything,       y1+UW1    },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String V_rules[][] =
        {
        {Anything,      "VIEW",         Anything,       v+y1+UW2  },
        {Anything,      "V",            Anything,       v       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String W_rules[][] =
        {
        {Nothing,       "WERE",         Anything,       w+ER2    },
        {Anything,      "WA",           "S",            w+AA    },
        {Anything,      "WA",           "T",            w+AA    },
        {Anything,      "WHERE",        Anything,       WH+EH+r1 },
        {Anything,      "WHAT",         Anything,       WH+AA+t2 },
        {Anything,      "WHOL",         Anything,       HH2+OW+l  },
        {Anything,      "WHO",          Anything,       HH2+UW2    },
        {Anything,      "WH",           Anything,       WH      },
        {Anything,      "WAR",          Anything,       w+or},//AO+r  },
        {Anything,      "WOR",          "^",            w+ER1    },
        {Anything,      "WR",           Anything,       r1       },
        {Anything,      "W",            Anything,       w       },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String X_rules[][] =
        {
        {Anything,      "X",            Anything,       k1+s     },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String Y_rules[][] =
        {
        {Anything,      "YOUNG",        Anything,       y2+AH+NG },
        {Nothing,       "YOU",          Anything,       y2+UW2    },
        {Nothing,       "YES",          Anything,       y2+EH+s  },
        {Nothing,       "Y",            Anything,       y2       },
        {"#:^",         "Y",            Nothing,        IY      },
        {"#:^",         "Y",            "I",            IY      },
        {" :",          "Y",            Nothing,        AY      },
        {" :",          "Y",            "#",            AY      },
        {" :",          "Y",            "^+:#",         IH      },
        {" :",          "Y",            "^#",           AY      },
        {Anything,      "Y",            Anything,       IH      },
        {Anything,      null,        Anything,       Silent  }
        };

/*
**      LEFT_PART       MATCH_PART      RIGHT_PART      OUT_PART
*/
static final String Z_rules[][] =
        {
        {Anything,      "Z",            Anything,       z       },
        {Anything,      null,        Anything,       Silent  }
        };


static final String[][][] Rules =
        {
            punct_rules,
            A_rules, B_rules, C_rules, D_rules, E_rules, F_rules, G_rules, 
            H_rules, I_rules, J_rules, K_rules, L_rules, M_rules, N_rules, 
            O_rules, P_rules, Q_rules, R_rules, S_rules, T_rules, U_rules, 
            V_rules, W_rules, X_rules, Y_rules, Z_rules
	};



/*
**	English to Phoneme translation.
**
**	Rules are made up of four parts:
**	
**		The left context.
**		The text to match.
**		The right context.
**		The phonemes to substitute for the matched text.
**
**	Procedure:
**
**		Seperate each block of letters (apostrophes included) 
**		and add a space on each side.  For each unmatched 
**		letter in the word, look through the rules where the 
**		text to match starts with the letter in the word.  If 
**		the text to match is found and the right and left 
**		context patterns also match, output the phonemes for 
**		that rule and skip to the next unmatched letter.
**
**
**	Special Context Symbols:
**
**		#	One or more vowels
**		:	Zero or more consonants
**		^	One consonant.
**		.	One of B, D, V, G, J, L, M, N, R, W or Z (voiced 
**			consonants)
**		%	One of ER, E, ES, ED, ING, ELY (a suffix)
**			(Right context only)
**		+	One of E, I or Y (a "front" vowel)
*/

    static private boolean isvowel(char chr)
    {
        return (chr == 'A' || chr == 'E' || chr == 'I' ||  chr == 'O' || chr == 'U');
    }

    static private boolean isconsonant(char chr)
    {
        return (!isvowel(chr));
    }
    static private boolean isLetter(char chr)
    {
        return Character.isAlphabetic(chr);
    }
    static private void outstring(String out)
    {
        output+=out;
    }
    static String output = "";
    public static String xlate_word(String word)
    {
        output = "";
        int index;	/* Current position in word */
        int type;	/* First letter of match part */

        word = word.toUpperCase().trim();
        index = 0;	/* no initial blank */

        do
        {
            if (isLetter(word.charAt(index)))
            {
                type = word.charAt(index)-('A')+1;
//                System.out.print(word.charAt(index)+": ");
            }
            else
            {
                type = 0;
//                System.out.print("0: ");
            }

            index = find_rule(word, index, Rules[type]);
        }
        while (index < word.length());
        
        return output;
    }

    static private int find_rule(String word, int index, String[][] rules)
    {
        String[] rule;
        int ruleIndex = 0;
        String left, match, right, outString;
        int remainder;
        int matchIndex;

        for (;;)	/* Search for the rule */
        {
//System.out.print("(" + (ruleIndex)+")");
            rule = rules[ruleIndex++];
            match = rule[1];

            if (match == null)	/* bad symbol! */
            {
                Configuration.getConfiguration().getDebugEntity().addLog("NavalTranslation: Can't find rule for: "+word+" index: "+ index, INFO);
                return index+1;	/* Skip it! */
            }
            for (remainder = index, matchIndex=0; ((matchIndex< match.length()) && (remainder< word.length())); remainder++, matchIndex++)
            {
                if (match.charAt(matchIndex) != word.charAt(remainder))
                    break;
            }
            if (matchIndex< match.length())	/* found missmatch */
                continue;
            /*
            printf("\nWord: \"%s\", Index:%4d, Trying: \"%s/%s/%s\" = \"%s\"\n",
            word, index, (*rule)[0], (*rule)[1], (*rule)[2], (*rule)[3]);
            */

            left = rule[0];
            right = rule[2];

            if (!leftmatch(left, word, index-1))
                continue;
            /*
            printf("leftmatch(\"%s\",\"...%c\") succeded!\n", left, word[index-1]);
            */
            if (!rightmatch(right, word, remainder))
                    continue;

//System.out.print("->" + (rule[1])+"->"+rule[3]);
            /*
            printf("rightmatch(\"%s\",\"%s\") succeded!\n", right, &word[remainder]);
            */
            outString = rule[3];
            /*
            printf("Success: ");
            */
            outstring(outString);
//System.out.println("");
            return remainder;
        }
    }


    static private boolean leftmatch(String pattern, String context, int contextIndex)
    {
        int patIndex;
        char pat;
        char text;
        int count;

        if (pattern.length() == 0)	/* null string matches any context */
        {
            return true;
        }
        if (contextIndex<0) 
        {
            if (pattern.equals(" ")) return true;
            return false;
        }

        /* point to last character in pattern string */
        count = pattern.length();
        patIndex = (count - 1);

        for (; count > 0; patIndex--, count--)
        {
            pat = pattern.charAt(patIndex);
            text = context.charAt(contextIndex);

            /* First check for simple text or space */
            if (Character.isAlphabetic(pat) || pat == '\'' || pat == ' ')
            {
                if (pat != text)
                        return false;
                else
                {
                    contextIndex--;
                    if (contextIndex <0 )
                    {
                        if (count-1<=0) return true;
                        return false;
                    }
                    continue;
                }
            }

            switch (pat)
            {
                case '#':	/* One or more vowels */
                {
                    if (!isvowel(text))
                        return false;

                    contextIndex--;
                    if (contextIndex <0 )
                    {
                        if (count-1<=0) return true;
                        return false;
                    }
                    text = context.charAt(contextIndex);

                    while (isvowel(text))
                    {
                        contextIndex--;
                        
                        if (contextIndex <0 )
                        {
                            if (count-1<=0) return true;
                            return false;
                        }
                        
                        text = context.charAt(contextIndex);
                    }
                    break;
                }

                case ':':	/* Zero or more consonants */
                {
                    while (isconsonant(text))
                    {
                        contextIndex--;
                        
                        if (contextIndex <0 )
                        {
                            if (count-1<=0) return true;
                            return false;
                        }
                        text = context.charAt(contextIndex);
                    }
                    break;
                }

                case '^':	/* One consonant */
                {
                    if (!isconsonant(text))
                            return false;
                    contextIndex--;
                    
                    if (contextIndex <0 )
                    {
                        if (count-1<=0) return true;
                        return false;
                    }
                    text = context.charAt(contextIndex);
                    break;
                }

                case '.':	/* B, D, V, G, J, L, M, N, R, W, Z */
                {
                    if (text != 'B' && text != 'D' && text != 'V'
                       && text != 'G' && text != 'J' && text != 'L'
                       && text != 'M' && text != 'N' && text != 'R'
                       && text != 'W' && text != 'Z')
                            return false;
                    contextIndex--;
                    if (contextIndex <0 )
                    {
                        if (count-1<=0) return true;
                        return false;
                    }
                    text = context.charAt(contextIndex);
                    break;

                }

                case '+':	/* E, I or Y (front vowel) */
                {
                    if (text != 'E' && text != 'I' && text != 'Y')
                            return false;
                    contextIndex--;
                    if (contextIndex <0 )
                    {
                        if (count-1<=0) return true;
                        return false;
                    }
                    text = context.charAt(contextIndex);
                    break;
                }

                case '%':
                default:
                    Configuration.getConfiguration().getDebugEntity().addLog("Bad char in left rule: '"+pat+"'", INFO );
                    return false;
            }
        }

        return true;
    }

    static private boolean rightmatch(String pattern, String context, int contextIndex)
    {
        int patIndex;
        char pat;
        char text;

        if (pattern.length() == 0)	/* null string matches any context */
        {
            return true;
        }
//        if (pattern.equals(" ")) return true;

        if (contextIndex >= context.length()) 
        {
//            if (pattern.equals(" ")) return true;
            return false;
            
        }
        text = context.charAt(contextIndex);
        

        for (patIndex = 0; patIndex < pattern.length(); patIndex++)
        {
            pat = pattern.charAt(patIndex);
            /* First check for simple text or space */
            if (Character.isAlphabetic(pat) || pat == '\'' || pat == ' ')
            {
                if (pat != text)
                    return false;
                else
                {
                    contextIndex++;
                    if (contextIndex >=context.length() )
                    {
                        if (patIndex+1 >= pattern.length()) return true;
                        return false;
                    }
                    
                    text = context.charAt(contextIndex);
                    continue;
                }
            }
            switch (pat)
            {
		case '#':	/* One or more vowels */
                {
                    if (!isvowel(text))
                        return false;

                    contextIndex++;
                    if (contextIndex >=context.length() )
                    {
                        if (patIndex+1 >= pattern.length()) return true;
                        return false;
                    }
                    text = context.charAt(contextIndex);
                    while (isvowel(text))
                    {
                        contextIndex++;
                        if (contextIndex >=context.length() )
                        {
                            if (patIndex+1 >= pattern.length()) return true;
                            return false;
                        }
                        text = context.charAt(contextIndex);
                    }
                    break;
                }

		case ':':	/* Zero or more consonants */
                {
                    while (isconsonant(text))
                    {
                        contextIndex++;
                        if (contextIndex >=context.length() )
                        {
                            if (patIndex+1 >= pattern.length()) return true;
                            return false;
                        }
                        text = context.charAt(contextIndex);
                    }
                    break;
                }

		case '^':	/* One consonant */
                {
                    if (!isconsonant(text))
                            return false;
                    contextIndex++;
                    if (contextIndex >=context.length() )
                    {
                        if (patIndex+1 >= pattern.length()) return true;
                        return false;
                    }
                    text = context.charAt(contextIndex);
                    break;
                }

		case '.':	/* B, D, V, G, J, L, M, N, R, W, Z */
                {
                    if (text != 'B' && text != 'D' && text != 'V'
                       && text != 'G' && text != 'J' && text != 'L'
                       && text != 'M' && text != 'N' && text != 'R'
                       && text != 'W' && text != 'Z')
                            return false;
                    contextIndex++;
                    if (contextIndex >=context.length() )
                    {
                        if (patIndex+1 >= pattern.length()) return true;
                        return false;
                    }
                    text = context.charAt(contextIndex);
                    break;
                }

		case '+':	/* E, I or Y (front vowel) */
                {
                    if (text != 'E' && text != 'I' && text != 'Y')
                        return false;
                    contextIndex++;
                    if (contextIndex >=context.length() )
                    {
                        if (patIndex+1 >= pattern.length()) return true;
                        return false;
                    }
                    text = context.charAt(contextIndex);
                    break;
                }

		case '%':	/* ER, E, ES, ED, ING, ELY (a suffix) */
                {
                    if (text == 'E')
                    {
                        contextIndex++;
                        if (contextIndex >=context.length() )
                        {
                            return false;
                        }
                        text = context.charAt(contextIndex);
                        if (text == 'L')
                        {
                            contextIndex++;
                            if (contextIndex >=context.length() )
                            {
                                return false;
                            }
                            text = context.charAt(contextIndex);
                            if (text == 'Y')
                            {
                                contextIndex++;
                                if (contextIndex >=context.length() )
                                {
                                    if (patIndex+1 >= pattern.length()) return true;
                                    return false;
                                }
                                text = context.charAt(contextIndex);
                                break;
                            }
                            else
                            {
                                contextIndex--;
                                text = context.charAt(contextIndex);
                                /* Don't gobble L */
                                break;
                            }
                        }
                        else
                        {
                            if (text == 'R' || text == 'S'  || text == 'D')
                            {
                                contextIndex++;
                                if (contextIndex >=context.length() )
                                {
                                    if (patIndex+1 >= pattern.length()) return true;
                                    return false;
                                }
                                text = context.charAt(contextIndex);
                            }
                        }
                        break;
                    }
                    else if (text == 'I')
                    {
                        contextIndex++;
                        if (contextIndex >=context.length() )
                        {

                            return false;
                        }
                        text = context.charAt(contextIndex);
                        if (text == 'N')
                        {
                            contextIndex++;
                            if (contextIndex >=context.length() )
                            {
                                return false;
                            }
                            text = context.charAt(contextIndex);
                            if (text == 'G')
                            {
                                contextIndex++;
                                if (contextIndex >=context.length() )
                                {
                                    if (patIndex+1 >= pattern.length()) return true;
                                    return false;
                                }
                                text = context.charAt(contextIndex);
                                break;
                            }
                        }
                        return false;
                    }
                    else
                        return false;                    
                }
                default:
                {
                    Configuration.getConfiguration().getDebugEntity().addLog("Bad char in right rule: '"+pat+"'", INFO );
                    return false;
                }
            }
        }
	return true;
    } 
}
