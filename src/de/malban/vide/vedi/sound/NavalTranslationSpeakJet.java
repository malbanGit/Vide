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
import static de.malban.gui.panels.LogPanel.WARN;

/**
 *
 * @author Malban
 */
public class NavalTranslationSpeakJet {
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
    
/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] punct_rules =
	{
	{Anything,	" ",		Anything,	"6 "	},
	{Anything,	"-",		Anything,	Silent	},
	{".",		"'S",		Anything,	"167 "	},
	{"#:.E",	"'S",		Anything,	"167 "	},
	{"#",		"'S",		Anything,	"167 "	},
	{Anything,	"'",		Anything,	Silent	},
	{Anything,	",",		Anything,	"15 "	},
	{Anything,	".",		Anything,	"15 "	},
	{Anything,	"?",		Anything,	"14 "	},
	{Anything,	"!",		Anything,	"14 "	},
	{Anything,	null,		Anything,	Silent	}
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] A_rules =
	{
	{Anything,	"A",		Nothing,	"133 "	},
	{Nothing,	"ARE",		Nothing,	"136 148 "	},
	{Nothing,	"AR",		"O",		"133 148 "	},
	{Anything,	"AR",		"#",		"131 148 "	},
	{"^",		"AS",		"#",		"130 187 "	},
	{Anything,	"A",		"WA",		"133 "	},
	{Anything,	"AW",		Anything,	"133 "	},
	{" :",		"ANY",		Anything,	"131 142 128 "	},
	{Anything,	"A",		"^+#",		"130 "	},
	{"#:",		"ALLY",		Anything,	"133 145 128 "	},
	{Nothing,	"AL",		"#",		"133 145 "	},
	{Anything,	"AGAIN",	Anything,	"133 179 131 142 "},
	{"#:",		"AG",		"E",		"129 165 "	},
	{Anything,	"A",		"^+:#",		"132 "	},
	{" :",		"A",		"^+ ",		"130 "	},
	{Anything,	"A",		"^%",		"130 "	},
	{Nothing,	"ARR",		Anything,	"133 148 "	},
	{Anything,	"ARR",		Anything,	"132 148 "	},
	{" :",		"AR",		Nothing,	"136 148 "	},
	{Anything,	"AR",		Nothing,	"151 "	},
	{Anything,	"AR",		Anything,	"136 148 "	},
	{Anything,	"AIR",		Anything,	"131 148 "	},
	{Anything,	"AI",		Anything,	"130 "	},
	{Anything,	"AY",		Anything,	"130 "	},
	{Anything,	"AU",		Anything,	"133 "	},
	{"#:",		"AL",		Nothing,	"133 145 "	},
	{"#:",		"ALS",		Nothing,	"133 145 167 "	},
	{Anything,	"ALK",		Anything,	"133 195 "	},
	{Anything,	"AL",		"^",		"133 145 "	},
	{" :",		"ABLE",		Anything,	"130 171 133 145 "},
	{Anything,	"ABLE",		Anything,	"133 171 133 145 "},
	{Anything,	"ANG",		"+",		"130 142 165 "	},
	{Anything,	"A",		Anything,	"132 "	},
 	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] B_rules =
	{
	{Nothing,	"BE",		"^#",		"171 129 "	},
	{Anything,	"BEING",	Anything,	"171 128 129 144 "},
	{Nothing,	"BOTH",		Nothing,	"171 142 190 "	},
	{Nothing,	"BUS",		"#",		"171 129 167 "	},
	{Anything,	"BUIL",		Anything,	"171 129 145 "	},
	{Anything,	"B",		Anything,	"171 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] C_rules =
	{
	{Nothing,	"CH",		"^",		"195 "	},
	{"^E",		"CH",		Anything,	"195 "	},
	{Anything,	"CH",		Anything,	"182 "	},
	{" S",		"CI",		"#",		"187 157 "	},
	{Anything,	"CI",		"A",		"189 "	},
	{Anything,	"CI",		"O",		"189 "	},
	{Anything,	"CI",		"EN",		"189 "	},
	{Anything,	"C",		"+",		"187 "	},
	{Anything,	"CK",		Anything,	"195 "	},
	{Anything,	"COM",		"%",		"195 134 140 "	},
	{Anything,	"C",		Anything,	"195 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] D_rules =
	{
	{"#:",		"DED",		Nothing,	"174 129 174 "	},
	{".E",		"D",		Nothing,	"174 "	},
	{"#:^E",	"D",		Nothing,	"191 "	},
	{Nothing,	"DE",		"^#",		"174 129 "	},
	{Nothing,	"DO",		Nothing,	"174 139 "	},
	{Nothing,	"DOES",		Anything,	"174 134 167 "	},
	{Nothing,	"DOING",	Anything,	"174 139 129 144 "},
	{Nothing,	"DOW",		Anything,	"174 163 "	},
	{Anything,	"DU",		"A",		"165 139 "	},
	{Anything,	"D",		Anything,	"174 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] E_rules =
	{
	{"#:",		"E",		Nothing,	Silent	},
	{"':^",		"E",		Nothing,	Silent	},
	{" :",		"E",		Nothing,	"128 "	},
	{"#",		"ED",		Nothing,	"174 "	},
	{"#:",		"E",		"D ",		Silent	},
	{Anything,	"EV",		"ER",		"131 166 "	},
	{Anything,	"E",		"^%",		"128 "	},
	{Anything,	"ERI",		"#",		"128 148 128 "	},
	{Anything,	"ERI",		Anything,	"131 148 129 "	},
	{"#:",		"ER",		"#",		"151 "	},
	{Anything,	"ER",		"#",		"131 148 "	},
	{Anything,	"ER",		Anything,	"151 "	},
	{Nothing,	"EVEN",		Anything,	"128 166 131 142 "},
	{"#:",		"E",		"W",		Silent	},
	{"T",		"EW",		Anything,	"139 "	},
	{"S",		"EW",		Anything,	"139 "	},
	{"R",		"EW",		Anything,	"139 "	},
	{"D",		"EW",		Anything,	"139 "	},
	{"L",		"EW",		Anything,	"139 "	},
	{"Z",		"EW",		Anything,	"139 "	},
	{"N",		"EW",		Anything,	"139 "	},
	{"J",		"EW",		Anything,	"139 "	},
	{"TH",		"EW",		Anything,	"139 "	},
	{"CH",		"EW",		Anything,	"139 "	},
	{"SH",		"EW",		Anything,	"139 "	},
	{Anything,	"EW",		Anything,	"158 139 "	},
	{Anything,	"E",		"O",		"128 "	},
	{"#:S",		"ES",		Nothing,	"129 167 "	},
	{"#:C",		"ES",		Nothing,	"129 167 "	},
	{"#:G",		"ES",		Nothing,	"129 167 "	},
	{"#:Z",		"ES",		Nothing,	"129 167 "	},
	{"#:X",		"ES",		Nothing,	"129 167 "	},
	{"#:J",		"ES",		Nothing,	"129 167 "	},
	{"#:CH",	"ES",		Nothing,	"129 167 "	},
	{"#:SH",	"ES",		Nothing,	"129 167 "	},
	{"#:",		"E",		"S ",		Silent	},
	{"#:",		"ELY",		Nothing,	"145 128 "	},
	{"#:",		"EMENT",	Anything,	"140 131 142 191 "	},
	{Anything,	"EFUL",		Anything,	"186 138 145 "	},
	{Anything,	"EE",		Anything,	"128 "	},
	{Anything,	"EARN",		Anything,	"151 142 "	},
	{Nothing,	"EAR",		"^",		"151 "	},
	{Anything,	"EAD",		Anything,	"131 174 "	},
	{"#:",		"EA",		Nothing,	"128 133 "	},
	{Anything,	"EA",		"SU",		"131 "	},
	{Anything,	"EA",		Anything,	"128 "	},
	{Anything,	"EIGH",		Anything,	"130 "	},
	{Anything,	"EI",		Anything,	"128 "	},
	{Nothing,	"EYE",		Anything,	"157 "	},
	{Anything,	"EY",		Anything,	"128 "	},
	{Anything,	"EU",		Anything,	"158 139 "	},
	{Anything,	"E",		Anything,	"131 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] F_rules =
	{
	{Anything,	"FUL",		Anything,	"186 138 145 "	},
	{Anything,	"F",		Anything,	"186 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] G_rules =
	{
	{Anything,	"GIV",		Anything,	"179 129 166 "	},
	{Nothing,	"G",		"I^",		"179 "	},
	{Anything,	"GE",		"T",		"179 131 "	},
	{"SU",		"GGES",		Anything,	"179 165 131 187 "	},
	{Anything,	"GG",		Anything ,	"179 "	},
	{" B#",		"G",		Anything,	"179 "	},
	{Anything,	"G",		"+",		"165 "	},
	{Anything,	"GREAT",	Anything,	"179 148 130 191 "	},
	{"#",		"GH",		Anything,	Silent	},
	{Anything,	"G",		Anything,	"179 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] H_rules =
	{
	{Nothing,	"HAV",		Anything,	"184 132 166 "	},
	{Nothing,	"HERE",		Anything,	"184 128 148 "	},
	{Nothing,	"HOUR",		Anything,	"163 151 "	},
	{Anything,	"HOW",		Anything,	"184 163 "	},
	{Anything,	"HUM",		Anything,	"184 160 140 "	},
	{Anything,	"H",		"#",		"184 "	},
	{Anything,	"H",		Anything,	Silent	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] I_rules =
	{
	{Nothing,	"IN",		Anything,	"129 142 "	},
	{Nothing,	"I",		Nothing,	"157 "	},
	{Anything,	"IN",		"D",		"157 142 "	},
	{Anything,	"IER",		Anything,	"128 151 "	},
	{"#:R",		"IED",		Anything,	"128 174 "	},
	{Anything,	"IED",		Nothing,	"157 174 "	},
	{Anything,	"IEN",		Anything,	"128 131 142 "	},
	{Anything,	"IE",		"T",		"157 131 "	},
	{" :",		"I",		"%",		"157 "	},
	{Anything,	"I",		"%",		"128 "	},
	{Anything,	"IE",		Anything,	"128 "	},
	{Anything,	"I",		"^+:#",		"129 "	},
	{Anything,	"IR",		"#",		"157 148 "	},
	{Anything,	"IZ",		"%",		"157 167 "	},
	{Anything,	"IS",		"%",		"157 167 "	},
	{Anything,	"I",		"D%",		"157 "	},
	{"+^",		"I",		"^+",		"129 "	},
	{Anything,	"I",		"T%",		"157 "	},
	{"#:^",		"I",		"^+",		"129 "	},
	{Anything,	"I",		"^+",		"157 "	},
	{Anything,	"IR",		Anything,	"151 "	},
	{Anything,	"IGH",		Anything,	"157 "	},
	{Anything,	"ILD",		Anything,	"157 145 174 "	},
	{Anything,	"IGN",		Nothing,	"157 142 "	},
	{Anything,	"IGN",		"^",		"157 142 "	},
	{Anything,	"IGN",		"%",		"157 142 "	},
	{Anything,	"IQUE",		Anything,	"128 195 "	},
	{Anything,	"I",		Anything,	"129 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] J_rules =
	{
	{Anything,	"J",		Anything,	"165 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] K_rules =
	{
	{Nothing,	"K",		"N",		Silent	},
	{Anything,	"K",		Anything,	"195 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] L_rules =
	{
	{Anything,	"LO",		"C#",		"145 142 "	},
	{"L",		"L",		Anything,	Silent	},
	{"#:^",		"L",		"%",		"133 145 "	},
	{Anything,	"LEAD",		Anything,	"145 128 174 "	},
	{Anything,	"L",		Anything,	"145 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] M_rules =
	{
	{Anything,	"MOV",		Anything,	"140 139 166 "	},
	{Anything,	"MO",		"^",	        "140 137 "	},
	{Anything,	"M",		Anything,	"140 "	},
        
        
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] N_rules =
	{
	{"E",		"NG",		"+",		"142 165 "	},
	{Anything,	"NG",		"R",		"144 179 "	},
	{Anything,	"NG",		"#",		"144 179 "	},
	{Anything,	"NGL",		"%",		"144 179 133 145 "},
	{Anything,	"NG",		Anything,	"144 "	},
	{Anything,	"NK",		Anything,	"144 195 "	},
	{Nothing,	"NOW",		Nothing,	"142 163 "	},
	{Anything,	"N",		Anything,	"142 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] O_rules =
	{
	{Anything,	"OF",		Nothing,	"133 166 "	},
	{Anything,	"OROUGH",	Anything,	"151 142 "	},
	{"#:",		"OR",		Nothing,	"151 "	},
	{"#:",		"ORS",		Nothing,	"151 167 "	},
	{Anything,	"OR",		Anything,	"133 148 "	},
	{Nothing,	"ONE",		Anything,	"147 134 142 "	},
	{Anything,	"OW",		Anything,	"142 "	},
	{Nothing,	"OVER",		Anything,	"142 166 151 "	},
	{Anything,	"OV",		Anything,	"134 166 "	},
	{Anything,	"O",		"^%",		"142 "	},
	{Anything,	"O",		"^EN",		"142 "	},
	{Anything,	"O",		"^I#",		"142 "	},
	{Anything,	"OL",		"D",		"142 145 "	},
	{Anything,	"OUGHT",	Anything,	"133 191 "	},
	{Anything,	"OUGH",		Anything,	"134 186 "	},
	{Nothing,	"OU",		Anything,	"163 "	},
	{"H",		"OU",		"S#",		"163 "	},
	{Anything,	"OUS",		Anything,	"133 187 "	},
	{Anything,	"OUR",		Anything,	"133 148 "	},
	{Anything,	"OULD",		Anything,	"138 174 "	},
	{"^",		"OU",		"^L",		"134 "	},
	{Anything,	"OUP",		Anything,	"139 199 "	},
	{Anything,	"OU",		Anything,	"163 "	},
	{Anything,	"OY",		Anything,	"156 "	},
	{Anything,	"OING",		Anything,	"142 129 144 "},
	{Anything,	"OI",		Anything,	"156 "	},
	{Anything,	"OOR",		Anything,	"133 148 "	},
	{Anything,	"OOK",		Anything,	"138 195 "	},
	{Anything,	"OOD",		Anything,	"138 174 "	},
	{Anything,	"OO",		Anything,	"139 "	},
	{Anything,	"O",		"E",		"142 "	},
	{Anything,	"O",		Nothing,	"142 "	},
	{Anything,	"OA",		Anything,	"142 "	},
	{Nothing,	"ONLY",		Anything,	"142 142 145 128 "},
	{Nothing,	"ONCE",		Anything,	"147 134 142 187 "	},
	{Anything,	"ON'T",		Anything,	"142 142 191 "	},
	{"C",		"O",		"N",		"136 "	},
	{Anything,	"O",		"NG",		"133 "	},
	{" :^",		"O",		"N",		"134 "	},
	{"I",		"ON",		Anything,	"133 142 "	},
	{"#:",		"ON",		Nothing,	"133 142 "	},
	{"#^",		"ON",		Anything,	"133 142 "	},
	{Anything,	"O",		"ST ",		"142 "	},
	{Anything,	"OF",		"^",		"133 186 "	},
	{Anything,	"OTHER",	Anything,	"134 169 151 "},
	{Anything,	"OSS",		Nothing,	"133 187 "	},
	{"#:^",		"OM",		Anything,	"134 140 "	},
	{Anything,	"O",		Anything,	"136 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] P_rules =
	{
	{Anything,	"PH",		Anything,	"186 "	},
	{Anything,	"PEOP",		Anything,	"199 128 199 "	},
	{Anything,	"POW",		Anything,	"199 163 "	},
	{Anything,	"PUT",		Nothing,	"199 138 191 "	},
	{Anything,	"P",		Anything,	"199 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] Q_rules =
	{
	{Anything,	"QUAR",		Anything,	"195 147 133 148 "	},
	{Anything,	"QU",		Anything,	"195 147 "	},
	{Anything,	"Q",		Anything,	"195 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] R_rules =
	{
	{Nothing,	"RE",		"^#",		"148 128 "	},
	{Anything,	"R",		Anything,	"148 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] S_rules =
	{
	{Anything,	"SH",		Anything,	"189 "	},
	{"#",		"SION",		Anything,	"168 133 142 "	},
	{Anything,	"SOME",		Anything,	"187 134 140 "	},
	{"#",		"SUR",		"#",		"168 151 "	},
	{Anything,	"SUR",		"#",		"189 151 "	},
	{"#",		"SU",		"#",		"168 139 "	},
	{"#",		"SSU",		"#",		"189 139 "	},
	{"#",		"SED",		Nothing,	"167 174 "	},
	{"#",		"S",		"#",		"167 "	},
	{Anything,	"SAID",		Anything,	"187 131 174 "	},
	{"^",		"SION",		Anything,	"189 133 142 "	},
	{Anything,	"S",		"S",		Silent	},
	{".",		"S",		Nothing,	"167 "	},
	{"#:.E",	"S",		Nothing,	"167 "	},
	{"#:^##",	"S",		Nothing,	"167 "	},
	{"#:^#",	"S",		Nothing,	"187 "	},
	{"U",		"S",		Nothing,	"187 "	},
	{" :#",		"S",		Nothing,	"167 "	},
	{Nothing,	"SCH",		Anything,	"187 195 "	},
	{Anything,	"S",		"C+",		Silent	},
	{"#",		"SM",		Anything,	"167 140 "	},
	{"#",		"SN",		"'",		"167 133 142 "	},
	{Anything,	"S",		Anything,	"187 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] T_rules =
	{
	{Nothing,	"THE",		Nothing,	"169 133 "	},
	{Anything,	"TO",		Nothing,	"191 139 "	},
	{Anything,	"THAT",		Nothing,	"169 132 191 "	},
	{Nothing,	"THIS",		Nothing,	"169 129 187 "	},
	{Nothing,	"THEY",		Anything,	"169 130 "	},
	{Nothing,	"THERE",	Anything,	"169 131 148 "	},
	{Anything,	"THER",		Anything,	"169 151 "	},
	{Anything,	"THEIR",	Anything,	"169 131 148 "	},
	{Nothing,	"THAN",		Nothing,	"169 132 142 "	},
	{Nothing,	"THEM",		Nothing,	"169 131 140 "	},
	{Anything,	"THESE",	Nothing,	"169 128 167 "	},
	{Nothing,	"THEN",		Anything,	"169 131 142 "	},
	{Anything,	"THROUGH",	Anything,	"190 148 139 "	},
	{Anything,	"THOSE",	Anything,	"169 142 167 "	},
	{Anything,	"THOUGH",	Nothing,	"169 142 "	},
	{Nothing,	"THUS",		Anything,	"169 134 187 "	},
	{Anything,	"TH",		Anything,	"190 "	},
	{"#:",		"TED",		Nothing,	"191 129 174 "	},
	{"S",		"TI",		"#N",		"182 "	},
	{Anything,	"TI",		"O",		"189 "	},
	{Anything,	"TI",		"A",		"189 "	},
	{Anything,	"TIEN",		Anything,	"189 133 142 "	},
	{Anything,	"TUR",		"#",		"182 151 "	},
	{Anything,	"TU",		"A",		"182 139 "	},
	{Nothing,	"TWO",		Anything,	"191 139 "	},
	{Anything,	"T",		Anything,	"191 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] U_rules =
	{
	{Nothing,	"UN",		"I",		"158 139 142 "	},
	{Nothing,	"UN",		Anything,	"134 142 "	},
	{Nothing,	"UPON",		Anything,	"133 199 133 142 "},
	{"T",		"UR",		"#",		"138 148 "	},
	{"S",		"UR",		"#",		"138 148 "	},
	{"R",		"UR",		"#",		"138 148 "	},
	{"D",		"UR",		"#",		"138 148 "	},
	{"L",		"UR",		"#",		"138 148 "	},
	{"Z",		"UR",		"#",		"138 148 "	},
	{"N",		"UR",		"#",		"138 148 "	},
	{"J",		"UR",		"#",		"138 148 "	},
	{"TH",		"UR",		"#",		"138 148 "	},
	{"CH",		"UR",		"#",		"138 148 "	},
	{"SH",		"UR",		"#",		"138 148 "	},
	{Anything,	"UR",		"#",		"158 138 148 "	},
	{Anything,	"UR",		Anything,	"151 "	},
	{Anything,	"U",		"^ ",		"134 "	},
	{Anything,	"U",		"^^",		"134 "	},
	{Anything,	"UY",		Anything,	"157 "	},
	{" G",		"U",		"#",		Silent	},
	{"G",		"U",		"%",		Silent	},
	{"G",		"U",		"#",		"147 "	},
	{"#N",		"U",		Anything,	"158 139 "	},
	{"T",		"U",		Anything,	"139 "	},
	{"S",		"U",		Anything,	"139 "	},
	{"R",		"U",		Anything,	"139 "	},
	{"D",		"U",		Anything,	"139 "	},
	{"L",		"U",		Anything,	"139 "	},
	{"Z",		"U",		Anything,	"139 "	},
	{"N",		"U",		Anything,	"139 "	},
	{"J",		"U",		Anything,	"139 "	},
	{"TH",		"U",		Anything,	"139 "	},
	{"CH",		"U",		Anything,	"139 "	},
	{"SH",		"U",		Anything,	"139 "	},
	{Anything,	"U",		Anything,	"158 139 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] V_rules =
	{
	{Anything,	"VIEW",		Anything,	"166 158 139 "	},
	{Anything,	"V",		Anything,	"166 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] W_rules =
	{
	{Nothing,	"WERE",		Anything,	"147 151 "	},
	{Anything,	"WA",		"S",		"147 136 "	},
	{Anything,	"WA",		"T",		"147 136 "	},
	{Anything,	"WHERE",	Anything,	"185 131 148 "	},
	{Anything,	"WHAT",		Anything,	"185 136 191 "	},
	{Anything,	"WHOL",		Anything,	"184 142 145 "	},
	{Anything,	"WHO",		Anything,	"184 139 "	},
	{Anything,	"WH",		Anything,	"185 "	},
	{Anything,	"WAR",		Anything,	"147 133 148 "	},
	{Anything,	"WOR",		"^",		"147 151 "	},
	{Anything,	"WR",		Anything,	"148 "	},
	{Anything,	"W",		Anything,	"147 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] X_rules =
	{
	{Anything,	"X",		Anything,	"195 187 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] Y_rules =
	{
	{Anything,	"YOUNG",	Anything,	"158 134 144 "	},
	{Nothing,	"YOU",		Anything,	"160  "	},
	{Nothing,	"YES",		Anything,	"158 131 187 "	},
	{Nothing,	"Y",		Anything,	"158 "	},
	{"#:^",		"Y",		Nothing,	"128 "	},
	{"#:^",		"Y",		"I",		"128 "	},
	{" :",		"Y",		Nothing,	"157 "	},
	{" :",		"Y",		"#",		"157 "	},
	{" :",		"Y",		"^+:#",		"129 "	},
	{" :",		"Y",		"^#",		"157 "	},
	{Anything,	"Y",		Anything,	"129 "	},
	{Anything,	null,		Anything,	Silent	},
	};

/*
**	LEFT_PART	MATCH_PART	RIGHT_PART	OUT_PART
*/
static String[][] Z_rules =
	{
	{Anything,	"Z",		Anything,	"167 "	},
	{Anything,	null,		Anything,	Silent	},
	}; 

static String[][][] Rules =
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
        String left, match, right, output;
        int remainder=0;
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
            output = rule[3];
            /*
            printf("Success: ");
            */
            outstring(output);
//System.out.println("");
            return remainder;
        }
    }


    static private boolean leftmatch(String pattern, String context, int contextIndex)
    {
        int patIndex = 0;
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
        int patIndex = 0;
        char pat;
        char text;

        if (pattern.length() == 0)	/* null string matches any context */
        {
            return true;
        }
        if (contextIndex >= context.length()) return false;
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
