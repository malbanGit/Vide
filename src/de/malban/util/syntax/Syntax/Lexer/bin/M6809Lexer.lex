/* M6809Lexer.java is a generated file.  You probably want to
 * edit M6809Lexer.lex to make changes.  Use JFlex to generate it.
 * To generate M6809Lexer.java
 * Install <a href="http://jflex.de/">JFlex</a> v1.3.2 or later.
 * Once JFlex is in your classpath run<br>
 * <code>java JFlex.Main M6809Lexer.lex</code><br>
 * You will then have a file called M6809Lexer.java
 */

package de.malban.util.syntax.Syntax.Lexer;

import java.io.*;
import java.util.HashMap;
import de.malban.vide.VideConfig;
import de.malban.util.syntax.entities.ASM6809FileMaster;

/** 
 * M6809Lexer is a M6809 lexer.  Created with JFlex.  An example of how it is used:


Not respected is "junk" after the operands. 
After the operand field all additional chars are just scanned as if they were additional operand values!



 *  <CODE>
 *  <PRE>
 *  M6809Lexer shredder = new M6809Lexer(System.in);
 *  M6809Token t;
 *  while ((t = shredder.getNextToken()) != null){
 *      System.out.println(t);
 *  }
 *  </PRE>
 *  </CODE>
 */ 

%%

%public
%class M6809Lexer
%implements Lexer
%function getNextToken
%type Token 

%{
    private int lastToken;
    private int nextState=YYINITIAL;
    HashMap<String, String> definedLocals = new HashMap<String, String>();
    HashMap<String, String> definedMacroVars = new HashMap<String, String>();
    HashMap<String, String> knownFileLabels = new HashMap<String, String>();
    HashMap<String, String> knownFileMacros = new HashMap<String, String>();
    int vediId = -1;
    public void setVediId(int id)
    {
		vediId = id;
    }

    int parenthesisCount=0;
    int parenthesisCloseCount = 0;
    void initLine()
    {
        parenthesisCount=0;
        parenthesisCloseCount = 0;
    }

    public void resetMacros()
    {
        knownFileMacros.clear();
        definedLocals.clear();
        definedMacroVars.clear();
        knownFileLabels.clear();
    }
    public M6809Lexer(java.io.InputStream in) 
    {
        this(new java.io.InputStreamReader(in));
    }

	  /** 
     * next Token method that allows you to control if whitespace and comments are
     * returned as tokens.
     */
    public Token getNextToken(boolean returnComments, boolean returnWhiteSpace)throws IOException{
        Token t = getNextToken();
        while (t != null && ((!returnWhiteSpace && t.isWhiteSpace()) || (!returnComments && t.isComment()))){
            t = getNextToken();
        }
        return (t); 
    }
        
    /**
     * Prints out tokens from a file or System.in.
     * If no arguments are given, System.in will be used for input.
     * If more arguments are given, the first argument will be used as
     * the name of the file to use as input
     *
     * @param args program arguments, of which the first is a filename
     */
    public static void main(String[] args) {
        InputStream in;
        try {
            if (args.length > 0){
                File f = new File(args[0]);
                if (f.exists()){
                    if (f.canRead()){
                        in = new FileInputStream(f);
                    } else {
                        throw new IOException("Could not open " + args[0]);
                    }
                } else {
                    throw new IOException("Could not find " + args[0]);
                }
            } else {
                in = System.in;
            }
            M6809Lexer shredder = new M6809Lexer(in);
            Token t;
            while ((t = shredder.getNextToken()) != null) {
                if (t.getID() != M6809Token.WHITE_SPACE){
                    System.out.println(t);
                }
            }
        } catch (IOException e){
            System.out.println(e.getMessage());
        }
    }  

    /**
     * Closes the current input stream, and resets the scanner to read from a new input stream.
	 * All internal variables are reset, the old input stream  cannot be reused
	 * (content of the internal buffer is discarded and lost).
	 * The lexical state is set to the initial state.
     * Subsequent tokens read from the lexer will start with the line, char, and column
     * values given here.
     *
     * @param reader The new input.
     * @param yyline The line number of the first token.
     * @param yychar The position (relative to the start of the stream) of the first token.
     * @param yycolumn The position (relative to the line) of the first token.
     * @throws IOException if an IOExecption occurs while switching readers.
     */
    public void reset(java.io.Reader reader, int yyline, int yychar, int yycolumn) throws IOException{
        yyreset(reader);
        this.yyline = yyline;
		this.yychar = yychar;
		this.yycolumn = yycolumn;
	}
%}

%line
%column
%char
%full
%ignorecase

%state AFTER_KEYWORD
%state AFTER_KEYWORD_0OP
%state AFTER_KEYWORD_1BranchOP
%state AFTER_KEYWORD_2OP
%state AFTER_KEYWORD_Stack
%state AFTER_KEYWORD_1MemOP
%state AFTER_KEYWORD_PSEUDO
%state AFTER_KEYWORD_PSEUDO_IF
%state IN_1MemOP

%state AFTER_LABEL
%state AFTER_MACRO
%state AFTER_EQU
%state COMMENT_LINE
%state LINE_END 
%state IN_STRING
%state WHITE_SPACE
%state WHITE_SPACE_START
%state WHITE_SPACE_AFTER_LABEL
%state WHITE_SPACE_AFTER_MACRO
%state WHITE_SPACE_AFTER_EQU
%state WHITE_SPACE_AFTER_KEYWORD
%state WHITE_SPACE_AFTER_OPPERAND
%state WHITE_SPACE_AFTER_PSEUDO
%state WHITE_SPACE_AFTER_PSEUDO_IF
%state WHITE_SPACE_1BranchOP
%state WHITE_SPACE_1BranchOPOP
%state WHITE_SPACE_2OP
%state WHITE_SPACE_Stack
%state WHITE_SPACE_1MemOP
%state WHITE_SPACE_OPERAND_FINISHED
%state AFTER_FIRST_MACRO_PARAM
%state WHITESPACE_AFTER_FIRST_MACRO_PARAM
%state AFTER_MACRO_COLON
%state WHITESPACE_AFTER_MACRO_COLON 
%state AFTER_MACROCALL
%state WHITE_SPACE_AFTER_MACROCALL 
%state AFTER_FIRST_MACROCALLPARAMETER
%state WHITE_SPACE_AFTER_FIRST_MACROCALLPARAMETER
%state IN_MACRO_CALL_PARAM


keywords6809_0OP=("abx"|"daa"|"mul"|"sex"|"rti"|"rts"
|"swi"|"swi2"|"swi3"|"sync"
|"asla"|"asra"|"clra"|"coma"|"deca"|"inca"|"lsla"
|"aslb"|"asrb"|"clrb"|"comb"|"decb"|"incb"|"lslb"
|"lsra"|"nega"|"psha"|"pula"|"rola"|"rora"|"tsta"
|"lsrb"|"negb"|"pshb"|"pulb"|"rolb"|"rorb"|"tstb")

keywords6809_1MemOP=("adda"|"adca"|"anda"|"bita"|"eora"|"ora"|"suba"|"sbca"
|"addb"|"adcb"|"andb"|"bitb"|"eorb"|"orb"|"subb"|"sbcb"|"cwai"
|"cmpa"|"cmpb"|"cmpd"|"cmpx"|"cmpy"|"cmpu"|"cmps"
|"lda" |"ldb" |"ldd" |"ldx" |"ldy" |"ldu" |"lds"
|"sta" |"stb" |"std" |"stx" |"sty" |"stu" |"sts"
|"asl"|"asr"|"clr"|"com"|"dec"|"inc"|"jmp"|"jsr"
|"lsl"|"lsr"|"neg"|"psh"|"pul"|"rol"|"ror"|"tst"|"nop"
|"addd"|"subd" | "leax"|"leay"|"leau"|"leas"
|"andcc"|"orcc"

|"bra"|"brn"|"bcc"|"bcs"|"beq"|"bge"|"bgt"
|"bhi"|"bhs"|"ble"|"blo"|"bls"|"blt"
|"bmi"|"bne"|"bvc"|"bvs"|"bpl"|"bsr"
|"lbra"|"lbrn"|"lbcc"|"lbcs"|"lbeq"|"lbge"|"lbgt"
|"lbhi"|"lbhs"|"lble"|"lblo"|"lbls"|"lblt"
|"lbmi"|"lbne"|"lbvc"|"lbvs"|"lbpl"|"lbsr"

)
keywords6809_1BranchOP=("Plumperquatsch")
/*
keywords6809_1BranchOP=("bra"|"brn"|"bcc"|"bcs"|"beq"|"bge"|"bgt"
|"bhi"|"bhs"|"ble"|"blo"|"bls"|"blt"
|"bmi"|"bne"|"bvc"|"bvs"|"bpl"|"bsr"
|"lbra"|"lbrn"|"lbcc"|"lbcs"|"lbeq"|"lbge"|"lbgt"
|"lbhi"|"lbhs"|"lble"|"lblo"|"lbls"|"lblt"
|"lbmi"|"lbne"|"lbvc"|"lbvs"|"lbpl"|"lbsr")
*/
keywords6809_2OP=("tfr"|"exg")

keywords6809_Stack=("pshs"|"pshu"|"puls"|"pulu")

keywordASM_IF=("IF"|"ELSEIF"|"IFDEF"|"IFEQ"|"IFNEQ"|"IFNDEF")
keywordASM=(
"ELSE"|"END"|"ENDIF"|"FCC"|"FDB"|"DATA"|"BSS"|"CODE"|"OPT"|"NOOPT"
|"INCLUDE"|"ORG"|"RMB"|"ENDM"|"EQU"|"ERROR"|"EXITM"|"FCB"|"FCW"|"LOCAL"|"DIRECT"|"DB"|"DS"|"DW"
|"TITLE"|"ALIGN"|"LIST"|"NOLIST"|"PAGE"|"STRUCT"|"BANK"|"CMAP"|"SET"|"END STRUCT")

TrueFalse=("FALSE"|"TRUE")

keywordOperator=(
"("|")"|"["|"]"|","|"."|"="|">"|"<"|"!"|"~"|"+"|"-"|"*"|"/"|"lo"|"hi"|"&"|"|"|"^"|"%"|"=="|"<="|">="|"!="|"||"|"&&"|"++"|"--"|">>"|"<<"|"#")

keywordOperatorNoDoubles=("."|"!"|"~"|"*"|"/"|"^"|"%"|"=="|"<="|">="|"!="|"||"|"&&"|">>"|"<<")
keywordOperatorNotIndexed=("("|")"|"["|","|"."|"="|">"|"<"|"!"|"~"|"*"|"/"|"lo"|"hi"|"&"|"|"|"^"|"%"|"=="|"<="|">="|"!="|"||"|"&&"|">>"|"<<"|"#")
keywordOperatorNoKommaParenthesis=("["|"]"|"."|"="|">"|"<"|"!"|"~"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"=="|"<="|">="|"!="|"||"|"&&"|"++"|"--"|">>"|"<<")

HexDigit=([0-9a-fA-F])
BinDigit=([0-1])
Digit=([0-9])
OctalDigit=([0-7])
NonZeroDigit=([1-9])
BLANK=([ ])
TAB=([\t])
FF=([\f])
EscChar=([\\])
CR=([\r])
LF=([\n])
EOL=({CR}|{LF}|{CR}{LF})
WhiteSpace=({BLANK}|{TAB}|{FF})
LineEndingWhiteSpace=({WhiteSpace}*{EOL})

Escape=({EscChar}([r]|[n]|[b]|[f]|[t]|[\\]|[\']|[\"]))

hiloSeperator=({WhiteSpace}|"(")
hilo=("hi"|"lo")
hiloOk=({hilo}{hiloSeperator})

Comment=(";"[^\r\n]*)
CommentLine=([*][^\r\n]*)

// a single char e.g. 'o'
AnyChrChr=([^\'\n\r\\])
UnclosedCharacter=([\']({Escape}|{AnyChrChr}))
Character=({UnclosedCharacter}[\'])
MalformedUnclosedCharacter=([\']({AnyChrChr}|({EscChar}[^\n\r]))*)
MalformedCharacter=([\'][\']|{MalformedUnclosedCharacter}[\'])

// strings in single asterix like 'blabla'
AnyChrChrString=([^\'\n\r\\])
UnclosedCharacterString=([\']({Escape}|{AnyChrChrString})*)
CharacterString=({UnclosedCharacterString}[\'])
MalformedUnclosedCharacterString=([\']({EscChar}|{AnyChrChrString})*)
MalformedCharacterString=([\'][\']|{MalformedUnclosedCharacterString}[\'])

// strings in double asterix like "blabla"
DecimalNum=(([0]|{NonZeroDigit}{Digit}*))
OctalNum=([0]{OctalDigit}*)
HexNum=([0]([x]|[X]){HexDigit}{HexDigit}*)
HexNumAlt=([$]{HexDigit}{HexDigit}*)
BinNum=([%]{BinDigit}{BinDigit}{BinDigit}{BinDigit}{BinDigit}{BinDigit}{BinDigit}{BinDigit})
AnyNum=({DecimalNum}|{OctalNum}|{HexNum}|{HexNumAlt}|{BinNum}|{Character})

LabelSuffix=([:]{0,1})
LabelFirstChar=([a-zA-Z_\.])
LabelChr=([a-zA-Z_0-9])
LabelChrMacro=([a-zA-Z_0-9\?\\])
Label=(({LabelFirstChar}){LabelChr}*{LabelSuffix})
LabelWithouSuffix=(({LabelFirstChar}){LabelChr}*)

BranchNumericOperand=([+-])
BranchNumericAddress=({AnyNum})
BranchNumericTarget=({BranchNumericAddress})
BranchTarget=({LabelWithouSuffix})

MacroLine={Label}{WhiteSpace}*"macro"
EQULine={Label}{WhiteSpace}*"equ"
directEQU=({WhiteSpace}*{Variable}{WhiteSpace}*[=])
directEQUMacro=({WhiteSpace}*{MacroVariable}{WhiteSpace}*[=])

AnyStrChr=([^\"\n\r\\])
AnyChrChrNoComment=([^\"\n\r\\;])
UnclosedString=([\"]({Escape}|{AnyStrChr})*)
String=(({AnyStrChr})*)
MalformedUnclosedString=([\"]({EscChar}|{AnyStrChr})*)
MalformedString=({MalformedUnclosedString}[\"])

register8=("a"|"b"|"cc"|"dp")
register16=("x"|"y"|"u"|"s"|"d"|"pc"|"sp")

indexRegisterPrefixe=(("-")|("--")|("+")|("++"))
Triplets=(("---"[-]*)|("+++"[+]*)|(",,"[,]*)|("()")|(")("))
Doubles=(("--"[-]*)|("++"[+]*))
Bad1=([\(+-,!|\^%=.]&\~)
Bad2=([*/])
Bad3=([\)])
Bad4=([\(!\~\^%#$]|"lo"|"hi")
BadCombinations = ({Bad1}{WhiteSpace}*{Bad2}|{Bad2}{WhiteSpace}*{Bad2}|{Bad2}{WhiteSpace}*{Bad3}|{Bad1}{WhiteSpace}*{Bad3}
|{Bad3}{WhiteSpace}*{AnyNum}|{AnyNum}{WhiteSpace}*{Bad4})

QuotedString=({UnclosedString}[\"])
Variable = (({LabelFirstChar}){LabelChr}*)
MacroVariable = (({LabelFirstChar}){LabelChrMacro}*)


NoCloseChar=([^\)\n\r;])
CloseChar=([\)])
OpenChar=([\(])

// not captured with paranthesis e.g. "lda (((2)+(1))" is no error, because at no stage there aren't enough closing parenthesis available...
UnopenedParenthesis1 = ([\)])
UnopenedParenthesis= ({UnopenedParenthesis1})
UnclosedParenthesis1 = ([\(]{NoCloseChar}*)

UnclosedParenthesis2 = ( ([\(]{NoCloseChar}*[\(]{NoCloseChar}*{CloseChar}{NoCloseChar}*) 
                        |([\(]{NoCloseChar}*[\(]{NoCloseChar}*))

UnclosedParenthesis3 = ( ([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*{CloseChar}{NoCloseChar}*{CloseChar}{NoCloseChar}*) 
                        |([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*{CloseChar}{NoCloseChar}*) 
                        |([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*) )

UnclosedParenthesis4 = ( ([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*{CloseChar}{NoCloseChar}*{CloseChar}{NoCloseChar}*{CloseChar}{NoCloseChar}*) 
                        |([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*{CloseChar}{NoCloseChar}*{CloseChar}{NoCloseChar}*) 
                        |([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*{CloseChar}{NoCloseChar}*)
                        |([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*) )
UnclosedParenthesis5 = ( ([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*{CloseChar}{NoCloseChar}*{CloseChar}{NoCloseChar}*{CloseChar}{NoCloseChar}*{CloseChar}{NoCloseChar}*) 
                        |([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*{CloseChar}{NoCloseChar}*{CloseChar}{NoCloseChar}*{CloseChar}{NoCloseChar}*) 
                        |([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*{CloseChar}{NoCloseChar}*{CloseChar}{NoCloseChar}*) 
                        |([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*{CloseChar}{NoCloseChar}*)
                        |([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*) )
UnclosedParenthesis= ({UnclosedParenthesis1}|{UnclosedParenthesis2}|{UnclosedParenthesis3}|{UnclosedParenthesis4}|{UnclosedParenthesis5})

ClosedParenthesis1 = ([\(]{NoCloseChar}*[\)])
ClosedParenthesis2 = ([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\)]{NoCloseChar}*[\)])
ClosedParenthesis3 = ([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\)]{NoCloseChar}*[\)]{NoCloseChar}*[\)])
ClosedParenthesis4 = ([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\)]{NoCloseChar}*[\)]{NoCloseChar}*[\)]{NoCloseChar}*[\)])
ClosedParenthesis5 = ([\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\(]{NoCloseChar}*[\)]{NoCloseChar}*[\)]{NoCloseChar}*[\)]{NoCloseChar}*[\)]{NoCloseChar}*[\)])
ParenthesisOk= ({ClosedParenthesis1}|{ClosedParenthesis2}|{ClosedParenthesis3}|{ClosedParenthesis4}|{ClosedParenthesis5})

WellFormedOperand = (("lo"|"hi"){WhiteSpace}{WhiteSpace}*{Variable})
MalformedOperand1 = ({keywordOperatorNoKommaParenthesis}{WhiteSpace}{WhiteSpace}*{keywordOperatorNoKommaParenthesis})
MalformedOperand2 = ({keywordOperatorNoDoubles}{keywordOperatorNoDoubles})

MalformedOperand3 = ({Variable}{WhiteSpace}{WhiteSpace}*{Variable})
MalformedOperand4 = ({AnyNum}{WhiteSpace}{WhiteSpace}*{AnyNum})
MalformedOperand5 = ({Variable}{WhiteSpace}{WhiteSpace}*{AnyNum})
MalformedOperand6 = ({AnyNum}{WhiteSpace}{WhiteSpace}*{Variable})

MalformedOperand7 = ([,]{AnyChrChrNoComment}{AnyChrChrNoComment}*[,])
MalformedOperand8 = ([#]{AnyChrChrNoComment}*[#])
MalformedOperand9 = ({AnyChrChrNoComment}{AnyChrChrNoComment}*[#])
MalformedOperanda = (([-][-]{AnyChrChrNoComment}[-][-]) |([-][-]{AnyChrChrNoComment}[+][+])|([+][+]{AnyChrChrNoComment}[+][+])|([+][+]{AnyChrChrNoComment}[-][-]))
MalformedOperandc = (([-][-]{IndexRegister}[-]) |([-][-]{AnyChrChrNoComment}[+])|([+][+]{AnyChrChrNoComment}[-])|([+][+]{AnyChrChrNoComment}[+])| ([-]{IndexRegister}[-][-]) |([+]{AnyChrChrNoComment}[-][-])|([+]{AnyChrChrNoComment}[+][+])|([-]{AnyChrChrNoComment}[+][+]))
MalformedOperandd = (([-][+])|([+][-])|([*][/])|([/][*])|([>][>][<][<])|([<][<][>][>])|([\[][\]]))
MalformedOperande = ([,]{AnyChrChrNoComment}*{keywordOperatorNotIndexed})
MalformedOperandf = ([,]{AnyChrChrNoComment}*{AnyNum})
MalformedOperandg = ({Triplets})
MalformedOperandh = ([,]{WhiteSpace}*{indexRegisterPrefixe}?{WhiteSpace}*{IndexRegister}?{WhiteSpace}*{indexRegisterPrefixe}?{WhiteSpace}*{AnyNonIndexRegister})
MalformedOperandi = (([+]{WhiteSpace}*{IndexRegister}{WhiteSpace}*[-]) | ([-]{WhiteSpace}*{IndexRegister}{WhiteSpace}*[+]) | ([-]{WhiteSpace}*{IndexRegister}{WhiteSpace}*[-])|([+]{WhiteSpace}*{IndexRegister}{WhiteSpace}*[+]))
MalformedOperandk= ({AnyNum}{WhiteSpace}*({OpenChar}|[\[]))

AnyNonIndexRegister=([abdefghijklmnoqrtvwzABDEFGHIJKLMNOQRTVWZ])
IndexRegister=([XYUSxyus]|[s][p])


MalformedOperand=(
{MalformedOperand1}
|
{MalformedOperand2}
{MalformedOperand3}
|
{MalformedOperand4}
               |
{MalformedOperand5}|
{MalformedOperand6}|
{MalformedOperand7}|
{MalformedOperand8}
               |
{MalformedOperanda}|
{MalformedOperandc}|
{MalformedOperandd}
               |
{MalformedOperande}|
{MalformedOperandf}|
{MalformedOperandg}|
{MalformedOperandi}
               |
{MalformedOperandh}|
{MalformedOperandk}
|{BadCombinations}

)

MalformedMacroParameter=(
                {MalformedOperand1}|{MalformedOperand2}|{MalformedOperand3}|{MalformedOperand4}
               |{MalformedOperand5}|{MalformedOperand6}|{MalformedOperand8}
               |{MalformedOperand9}|{MalformedOperanda}|{MalformedOperandd}
               |{MalformedOperandg} 
               |{MalformedOperandk}|{Doubles}|{BadCombinations}
)


tworegarg = (({register8}{WhiteSpace}*","{WhiteSpace}*{register8})|({register16}{WhiteSpace}*","{WhiteSpace}*{register16}))
register= ({register8} | {register16})
stackArg= ({register}{WhiteSpace}* (","{WhiteSpace}* {register}{WhiteSpace}*)*)


AS09MacroEscape=([\\])
AS09MacroParameter=({AS09MacroEscape}{DecimalNum})
AS09ConcatinatedMacroParemeter=({LabelChr}*{AS09MacroParameter}{LabelChr}*)
AS09MacroLabelAddition=(({AS09MacroEscape}[\?])|({AS09MacroEscape}{Digit}))
AS09MacroLabel=({MacroVariable}{AS09MacroLabelAddition}{LabelSuffix})

ASMJMacroEscape=([&])
ASMJMacroParameter=({ASMJMacroEscape}{DecimalNum})
ASMConcatinatedMacroParemeter=({LabelChr}*{ASMJMacroParameter}{LabelChr}*)
ASMJMacroLabelAddition=(({ASMJMacroEscape}[@])|({ASMJMacroEscape}{Digit}))
ASMJMacroLabel=({MacroVariable}{ASMJMacroLabelAddition}{LabelSuffix})

ConcatinatedMacroParemeter=({AS09ConcatinatedMacroParemeter}|{ASMConcatinatedMacroParemeter})
MacroParameter=({AS09MacroParameter}|{ASMJMacroParameter})
MacroLabel=({AS09MacroLabel}|{ASMJMacroLabel})


%%
// identifies a complete line as a macro definition
// macro parameters are matched seperately
<YYINITIAL> {MacroLine} 
{
    initLine();
    lastToken = M6809Token.RESERVED_ASMWORD;
    nextState = AFTER_MACRO;    
    String text = yytext();
    definedMacroVars.clear();
    definedLocals.clear();

    String text2 = text.split(" ")[0];
    if (text2.endsWith(":")) text2=text2.substring(0,text2.length()-1);
    //knownFileMacros.put(text2, text2);

    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    t.isMacroName=true;
    yybegin(nextState);
    return(t);
}

// is this a "equ" definition line?
<YYINITIAL> {EQULine} 
{
    initLine();
    lastToken = M6809Token.RESERVED_ASMWORD;
    nextState = AFTER_EQU;    
    String text = yytext();

    String text2 = text.split(" ")[0];
    if (text2.endsWith(":")) text2=text2.substring(0,text2.length()-1);
    //knownFileLabels.put(text2, text2);

    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    t.isMacroName=true;
    yybegin(nextState);
    return(t);
}
<YYINITIAL> {directEQU} 
{ 
    initLine();
    lastToken = M6809Token.LINE_LABEL;
    String text = yytext();
    boolean localDef = false;
    nextState = WHITE_SPACE_1MemOP;    
    yybegin(nextState);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {directEQUMacro} 
{ 
    initLine();
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
    boolean localDef = false;
    nextState = WHITE_SPACE_1MemOP;    
    yybegin(nextState);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
// a line beginning with a "normal" label?
<YYINITIAL> {Label} 
{ 
    initLine();
    lastToken = M6809Token.LINE_LABEL;
    String text = yytext();
    boolean localDef = false;
    // the following only works
    // if lexer knows from context (last scanning)
    // possibly defined local macro labels 
    // invoking lexer with only "partial" scans, does not garantee this
    if (definedLocals.get(text) != null)
    {
        lastToken = M6809Token.RESERVED_ASMWORD;
        localDef = true;
    }
    else if (text.length()>1)
    {
        if (definedLocals.get(text.substring(0,text.length()-1)) != null)
        {
            lastToken = M6809Token.RESERVED_ASMWORD;
            localDef = true;
        }
    }
    if (!localDef)
    {
        String text2 = text;
        if (text2.endsWith(":")) text2 = text2.substring(0, text2.length()-1);
        //knownFileLabels.put(text2, text2);
    }
    nextState = AFTER_LABEL;    
    yybegin(nextState);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

// a line beginning with a label belonging to a local macro (\? or &@)
<YYINITIAL> {MacroLabel} 
{ 
    initLine();
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
    boolean localDef = false;
    nextState = AFTER_LABEL;    
    yybegin(nextState);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL, WHITE_SPACE_START> {WhiteSpace}+ 
{
    initLine();
    nextState = WHITE_SPACE_START;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<AFTER_LABEL, WHITE_SPACE_AFTER_LABEL> {WhiteSpace}+ 
{
    nextState = WHITE_SPACE_AFTER_LABEL;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

// is the found keyword a pseudo opcode?
// only "local" is treated in a special way
// should do some more to other keywords
// for now only local is scanned
// for local label recognition
// for all other pseudo opcodes
// the text after is treated as a MemOp Mnemonic of 6809
<WHITE_SPACE, WHITE_SPACE_START, WHITE_SPACE_AFTER_LABEL> {keywordASM} 
{
    nextState = AFTER_KEYWORD_PSEUDO; // for now treat as "bad" 6809 keyword
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
    if (text.toLowerCase().equals("local"))
    {
        nextState = AFTER_MACRO; // syntax == local? [list of params, colon seperated]
      //  nextState = AFTER_LOCAL;
    }
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}
<WHITE_SPACE, WHITE_SPACE_START, WHITE_SPACE_AFTER_LABEL> {keywordASM_IF} 
{
    nextState = AFTER_KEYWORD_PSEUDO_IF; // for now treat as "bad" 6809 keyword
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
    if (text.toLowerCase().equals("local"))
    {
        nextState = AFTER_MACRO; // syntax == local? [list of params, colon seperated]
      //  nextState = AFTER_LOCAL;
    }
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}


<AFTER_KEYWORD_PSEUDO, WHITE_SPACE_AFTER_PSEUDO> {WhiteSpace}+ {
    nextState = WHITE_SPACE_AFTER_PSEUDO;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<AFTER_KEYWORD_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO_IF> {WhiteSpace}+ {
    nextState = WHITE_SPACE_AFTER_PSEUDO_IF;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

// keywords that are not allowed to have arguments!
<WHITE_SPACE, WHITE_SPACE_START, WHITE_SPACE_AFTER_LABEL> {keywords6809_0OP} 
{
    nextState = AFTER_KEYWORD_0OP;
    lastToken = M6809Token.RESERVED_WORD;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}
<AFTER_KEYWORD_0OP, WHITE_SPACE_OPERAND_FINISHED> {WhiteSpace}+ {
    nextState = WHITE_SPACE_OPERAND_FINISHED;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

// branch keywords, that only accepts "easy" branches, no "memory" branches (like jrs or jmp)
<WHITE_SPACE, WHITE_SPACE_START, WHITE_SPACE_AFTER_LABEL> {keywords6809_1BranchOP} 
{
    nextState = AFTER_KEYWORD_1BranchOP;
    lastToken = M6809Token.RESERVED_WORD;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}
<AFTER_KEYWORD_1BranchOP, WHITE_SPACE_1BranchOP> {WhiteSpace}+ {
    nextState = WHITE_SPACE_1BranchOP;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
// branch inside a macro
<WHITE_SPACE_1BranchOP> {MacroLabel} 
{
    nextState = WHITE_SPACE_OPERAND_FINISHED;
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}
// branch target is a parameter of a macro (must have been ville...)
<WHITE_SPACE_1BranchOP> {MacroParameter} 
{
    nextState = WHITE_SPACE_OPERAND_FINISHED;
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}
// branch target, might still be a macro target, further check inside
<WHITE_SPACE_1BranchOP> {BranchTarget} 
{
    nextState = WHITE_SPACE_OPERAND_FINISHED;
    lastToken = M6809Token.LITERAL_VARIABLE;
    String text = yytext();
    if (definedLocals.get(text) != null)
    {
        lastToken = M6809Token.RESERVED_ASMWORD;
    }
    if (definedMacroVars.get(text) != null)
    {
        lastToken = M6809Token.RESERVED_ASMWORD;
    }
    else if (ASM6809FileMaster.getInfo(vediId).knownGlobalMacros.get(text) != null)
    {
        lastToken = M6809Token.RESERVED_ASMWORD;
    }
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}
<WHITE_SPACE_1BranchOP> {BranchNumericOperand} 
{
    nextState = WHITE_SPACE_1BranchOPOP;
    lastToken = M6809Token.RESERVED_OPERATOR;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}
<WHITE_SPACE_1BranchOP, WHITE_SPACE_1BranchOPOP> {BranchNumericTarget} 
{
    nextState = WHITE_SPACE_OPERAND_FINISHED;

    lastToken = M6809Token.LITERAL_INTEGER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}
// Mnemomics that have two operands (tfx and exg)
<WHITE_SPACE, WHITE_SPACE_START, WHITE_SPACE_AFTER_LABEL> {keywords6809_2OP} 
{
    nextState = AFTER_KEYWORD_2OP;
    lastToken = M6809Token.RESERVED_WORD;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}
<AFTER_KEYWORD_2OP, WHITE_SPACE_2OP> {WhiteSpace}+ {
    nextState = WHITE_SPACE_2OP;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
// test the two reg args
<WHITE_SPACE_2OP> {tworegarg} {
    nextState = WHITE_SPACE_OPERAND_FINISHED;    
    lastToken = M6809Token.RESERVED_REGISTER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
// keywords, that habe multiple registers(stack only)
<WHITE_SPACE, WHITE_SPACE_START, WHITE_SPACE_AFTER_LABEL> {keywords6809_Stack} 
{
    nextState = AFTER_KEYWORD_Stack;
    lastToken = M6809Token.RESERVED_WORD;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}
<AFTER_KEYWORD_Stack, WHITE_SPACE_Stack> {WhiteSpace}+ {
    nextState = WHITE_SPACE_Stack;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<WHITE_SPACE_Stack> {stackArg} {
    nextState = WHITE_SPACE_OPERAND_FINISHED;    
    lastToken = M6809Token.RESERVED_REGISTER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

// these are the bad ones, that can have "difficult" memory expressions
// right now, they are not correctly parsed
// nor is it even POSSIBLE to parse correctly
// since expressions in paranthesis are allowed
// and there is not recursive macro definition possibly in flex
// as of now, the user will not be syntax highlighted with errors
// only with nice different colors
// some maleformed expressions are checked later on...
<WHITE_SPACE, WHITE_SPACE_START, WHITE_SPACE_AFTER_LABEL> {keywords6809_1MemOP} 
{
    nextState = AFTER_KEYWORD_1MemOP;
    lastToken = M6809Token.RESERVED_WORD;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return(t);
}
<AFTER_KEYWORD_1MemOP, WHITE_SPACE_1MemOP> {WhiteSpace}+ {
    nextState = WHITE_SPACE_1MemOP;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

// is this a macro call ?
// we will try to get "global" macro information
<WHITE_SPACE, WHITE_SPACE_START, WHITE_SPACE_AFTER_LABEL> {Variable} 
{ 
    // VARIABLE 1
    lastToken = M6809Token.ERROR_IDENTIFIER;
    nextState = AFTER_MACROCALL; // incase of Macro call, this "catches" macro parameters
    String text = yytext();
    if (knownFileMacros.get(text) != null)
    {
        lastToken = M6809Token.RESERVED_ASMWORD;
    }
    else
    {
        if (ASM6809FileMaster.getInfo(vediId).knownGlobalMacros.get(text) != null)
        {
            lastToken = M6809Token.RESERVED_ASMWORD;
        }
    }
    if (!VideConfig.getConfig().scanMacros)
    {
        lastToken = M6809Token.LITERAL_VARIABLE;
    }
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<AFTER_MACROCALL, WHITE_SPACE_AFTER_MACROCALL, IN_MACRO_CALL_PARAM> {WhiteSpace}+ {
    nextState = IN_MACRO_CALL_PARAM;    

    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

<IN_MACRO_CALL_PARAM, WHITE_SPACE_AFTER_FIRST_MACROCALLPARAMETER> {WhiteSpace}+ {
    nextState = WHITE_SPACE_AFTER_FIRST_MACROCALLPARAMETER;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<IN_MACRO_CALL_PARAM, WHITE_SPACE_AFTER_FIRST_MACROCALLPARAMETER> "," 
{
    nextState = IN_MACRO_CALL_PARAM;    
   
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

<IN_MACRO_CALL_PARAM> {Variable} 
{ 
 // Variable 2
//    lastToken = M6809Token.LITERAL_VARIABLE;
    lastToken = M6809Token.ERROR_IDENTIFIER;
    nextState = WHITE_SPACE_AFTER_FIRST_MACROCALLPARAMETER; // incase of Macro call, this "catches" macro parameters
    String text = yytext();
//        lastToken = M6809Token.RESERVED_ASMWORD;
    // is it a Register
    if (text.toLowerCase().equals("a")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("b")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("d")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("x")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("y")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("u")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("s")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("x")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("pc")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("sp")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("dp")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("cc")) lastToken = M6809Token.RESERVED_REGISTER;

    if (ASM6809FileMaster.getInfo(vediId).knownGlobalVariables.get(text) != null)
    {
        lastToken = M6809Token.LITERAL_VARIABLE;
    }
    if (ASM6809FileMaster.getInfo(vediId).knownGlobalMacros.get(text) != null)
    {
        lastToken = M6809Token.RESERVED_ASMWORD;
    }

    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
//////////////////////////////////////
///////////// Macro call paramter list
//////////////////////////////////////
// macro call parameters are also tricky and cant be done completely right (see expressions)
// these are even more tricky, since it can be
// a colon seperated list of expressions

<IN_MACRO_CALL_PARAM> {MalformedMacroParameter} {
   // maleformed Macro
    lastToken = M6809Token.ERROR_IDENTIFIER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return(t);
}

//////////////////////////////////////
//////////////////////////////////////
//////////////////////////////////////


<AFTER_MACRO, WHITE_SPACE_AFTER_MACRO> {WhiteSpace}+ {
    nextState = WHITE_SPACE_AFTER_MACRO;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

// equ definitions can be complex... therefor do the 1MemOp dance...
<AFTER_EQU> {WhiteSpace}+ {
    nextState = WHITE_SPACE_1MemOP;    
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<WHITE_SPACE_AFTER_MACRO> {Variable} 
{ 
    nextState = AFTER_FIRST_MACRO_PARAM;    
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
// LOCAL    definedMacroVars.put(text, text);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<AFTER_FIRST_MACRO_PARAM, WHITESPACE_AFTER_FIRST_MACRO_PARAM> {WhiteSpace}+ 
{ 
    nextState = WHITESPACE_AFTER_FIRST_MACRO_PARAM;    
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
// LOCAL    definedMacroVars.put(text, text);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<WHITESPACE_AFTER_FIRST_MACRO_PARAM, AFTER_FIRST_MACRO_PARAM> "," 
{ 
    nextState = AFTER_MACRO_COLON;    
    lastToken = M6809Token.RESERVED_OPERATOR;
    String text = yytext();
// LOCAL    definedMacroVars.put(text, text);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<AFTER_MACRO_COLON, WHITESPACE_AFTER_MACRO_COLON> {WhiteSpace}+ 
{ 
    nextState = WHITESPACE_AFTER_MACRO_COLON;    
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
// LOCAL    definedMacroVars.put(text, text);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<WHITESPACE_AFTER_MACRO_COLON, AFTER_MACRO_COLON> {Variable} 
{ 
    nextState = AFTER_FIRST_MACRO_PARAM;    
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
// LOCAL    definedMacroVars.put(text, text);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}


//#######################################################################################
<WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {WellFormedOperand} {
    lastToken = M6809Token.RESERVED_OPERATOR;
    parenthesisCount++;
    // this can as of now only be lo / hi
    //we pushback, so only them
    String text = yytext();
    yypushback(text.length()-2) ;
    text = text.substring(0,2);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return(t);
}
<WHITE_SPACE_1MemOP, IN_1MemOP> {MalformedOperand} {
    // maleformed operant
    lastToken = M6809Token.ERROR_IDENTIFIER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return(t);
}

<WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {UnclosedParenthesis} {
    // unclosed Paranthes
    lastToken = M6809Token.ERROR_IDENTIFIER;
    parenthesisCount++;
    String text = yytext();
    // we pushback, so only the parentheses is part of the token!
    yypushback(text.length()-1) ;
    text = text.substring(0,1);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return(t);
}

/*
Tricky we assume every close bracket is an "error"
We look if we have "enough" opens, and than cast to be a good closer!
*/
<WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {UnopenedParenthesis} {
    // unopened paranthesis
    parenthesisCloseCount++;
    if (parenthesisCloseCount>parenthesisCount)
    {
        lastToken = M6809Token.ERROR_IDENTIFIER;
        String text = yytext();
        M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
        return(t);
    }
    else
    {
        parenthesisCloseCount--;
        parenthesisCount--;
        lastToken = M6809Token.RESERVED_OPERATOR;
        String text = yytext();
        M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
        return(t);
    }
}
<WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {ParenthesisOk} {
    lastToken = M6809Token.RESERVED_OPERATOR;
    parenthesisCount++;

    String text = yytext();
// we pushback, so only the parentheses is part of the token!
    yypushback(text.length()-1) ;
    text = text.substring(0,1);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return(t);
}

<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {keywordOperator} {
    lastToken = M6809Token.RESERVED_OPERATOR;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return(t);
}
<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {MacroParameter} {
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return(t);
}


<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {ConcatinatedMacroParemeter} {
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return(t);
}

<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {AnyNum} {
    lastToken = M6809Token.LITERAL_INTEGER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return(t);
}
<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {hiloOk} {
    lastToken = M6809Token.RESERVED_OPERATOR;
    String text = yytext();
    String text2 = yytext();
    if (text.endsWith("("))
    {
        yypushback(1) ;
        text2 = text.substring(0, text.length()-1);
    }

    M6809Token t = (new M6809Token(lastToken,text2,yyline,yychar,yychar+text2.length(),nextState));
    return(t);
}


<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {MacroLabel} {
    lastToken = M6809Token.RESERVED_ASMWORD;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return(t);
}
<WHITE_SPACE_AFTER_PSEUDO_IF> {TrueFalse} { 
    lastToken = M6809Token.RESERVED_ASMWORD;
    nextState = WHITE_SPACE_OPERAND_FINISHED;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {Variable} { 
    // variable 3
    //lastToken = M6809Token.LITERAL_VARIABLE;
    String text = yytext();

    lastToken = M6809Token.ERROR_IDENTIFIER;

    // is it a Macro
    if (definedLocals.get(text) != null)
    {
        lastToken = M6809Token.RESERVED_ASMWORD;
    }
    else if (definedMacroVars.get(text) != null)
    {
        lastToken = M6809Token.RESERVED_ASMWORD;
    }
    else if (ASM6809FileMaster.getInfo(vediId).knownGlobalMacros.get(text) != null)
    {
        lastToken = M6809Token.RESERVED_ASMWORD;
    }
    // is it a label/variable
    else if (knownFileLabels.get(text) != null)
    {
        lastToken = M6809Token.LITERAL_VARIABLE;
    }
    else if (ASM6809FileMaster.getInfo(vediId).knownGlobalVariables.get(text) != null)
    {
        lastToken = M6809Token.LITERAL_VARIABLE;
    }
    else
    {
        if (!VideConfig.getConfig().scanVars)
        {
            lastToken = M6809Token.LITERAL_VARIABLE;
        }
    }

    // is it a Register
    if (text.toLowerCase().equals("a")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("b")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("d")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("x")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("y")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("u")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("s")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("x")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("pc")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("sp")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("dp")) lastToken = M6809Token.RESERVED_REGISTER;
    else if (text.toLowerCase().equals("cc")) lastToken = M6809Token.RESERVED_REGISTER;

    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {QuotedString} { 
    lastToken = M6809Token.LITERAL_STRING;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {CharacterString} { 
    lastToken = M6809Token.LITERAL_STRING;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}


<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {UnclosedString} { 
    lastToken = M6809Token.ERROR_UNCLOSED_STRING;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {MalformedUnclosedString} { 
    lastToken = M6809Token.ERROR_MALFORMED_UNCLOSED_STRING;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {MalformedString} { 
    lastToken = M6809Token.ERROR_MALFORMED_STRING;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}


<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {UnclosedCharacterString} { 
    lastToken = M6809Token.ERROR_UNCLOSED_CHARACTER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {MalformedUnclosedCharacterString} { 
    lastToken = M6809Token.ERROR_MALFORMED_UNCLOSED_CHARACTER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {MalformedCharacterString} { 
    lastToken = M6809Token.ERROR_MALFORMED_CHARACTER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}


<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {UnclosedCharacter} { 
    lastToken = M6809Token.ERROR_UNCLOSED_CHARACTER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {MalformedUnclosedCharacter} { 
    lastToken = M6809Token.ERROR_MALFORMED_UNCLOSED_CHARACTER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<WHITE_SPACE_AFTER_PSEUDO_IF, WHITE_SPACE_AFTER_PSEUDO,WHITE_SPACE_1MemOP, IN_1MemOP, IN_MACRO_CALL_PARAM> {MalformedCharacter} { 
    lastToken = M6809Token.ERROR_MALFORMED_CHARACTER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

{Comment} 
{ 
    nextState = LINE_END;
    yybegin( LINE_END);
    lastToken = M6809Token.COMMENT_END_OF_LINE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

<YYINITIAL, WHITE_SPACE_START>{CommentLine} 
{ 
    initLine();
    nextState = LINE_END;
    yybegin( LINE_END);
    lastToken = M6809Token.COMMENT_LINE;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

{LineEndingWhiteSpace}
{ 
    lastToken = M6809Token.WHITE_SPACE;
    String text = yytext();
    nextState = YYINITIAL;    
    yybegin(YYINITIAL);
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
/* error fallback */
[^]                            
{ 
    // fallback
    initLine();
    lastToken = M6809Token.ERROR_IDENTIFIER;
    String text = yytext();
    M6809Token t = (new M6809Token(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}


