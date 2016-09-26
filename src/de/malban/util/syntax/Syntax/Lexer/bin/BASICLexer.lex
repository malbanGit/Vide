/* BASICLexer.java is a generated file.  You probably want to
 * edit BASICLexer.lex to make changes.  Use JFlex to generate it.
 * To generate BASICLexer.java
 * Install <a href="http://jflex.de/">JFlex</a> v1.3.2 or later.
 * Once JFlex is in your classpath run<br>
 * <code>java JFlex.Main BASICLexer.lex</code><br>
 * You will then have a file called BASICLexer.java
 */

package de.malban.util.syntax.Syntax.Lexer;

import java.io.*;
import java.util.HashMap;
import de.malban.vide.vedi.VediPanel;

/** 
 * BASICLexer is a BASIC lexer.  Created with JFlex.  An example of how it is used:


Not respected is "junk" after the operands. 
After the operand field all additional chars are just scanned as if they were additional operand values!



 *  <CODE>
 *  <PRE>
 *  BASICLexer shredder = new BASICLexer(System.in);
 *  BASICToken t;
 *  while ((t = shredder.getNextToken()) != null){
 *      System.out.println(t);
 *  }
 *  </PRE>
 *  </CODE>
 */ 

%%

%public
%class BASICLexer
%implements Lexer
%function getNextToken
%type Token 

%{
    private int lastToken;
    private int nextState=YYINITIAL;
    public BASICLexer(java.io.InputStream in) 
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
            BASICLexer shredder = new BASICLexer(in);
            Token t;
            while ((t = shredder.getNextToken()) != null) {
                if (t.getID() != BASICToken.WHITE_SPACE){
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



%state MIDDLE_OF_LINE

HASH=("#"|"??=")
LBRACKET=("["|"??(")
RBRACKET=("]"|"??)")
BACKSLASH=([\\]|"??/")
CARET=("^"|"??'")
LBRACE=("{"|"??<")
RBRACE=("}"|"??>")
VERTICAL=("|"|"??!")
TILDE=("~"|"??-")

BooleanLiteral=("true"|"false")
HexDigit=([0-9a-fA-F])
Digit=([0-9])
NonZeroDigit=([1-9])
Letter=([a-zA-Z_])
BLANK=([ ])
TAB=([\t])
FF=([\f])
EscChar=({BACKSLASH})
CR=([\r])
LF=([\n])
EOL=({CR}|{LF}|{CR}{LF})
WhiteSpace=({BLANK}|{TAB}|{FF}|{EOL})
NonBreakingWhiteSpace=({BLANK}|{TAB}|{FF})
AnyNonSeparator=([^\t\f\r\n\ \(\)\{\}\[\]\;\,\.\=\>\<\!\~\?\:\+\-\*\/\&\|\^\%\"\']|{HASH}|{BACKSLASH})

HexEscape=({EscChar}[x|X]{HexDigit}{HexDigit})

Escape=({EscChar}([a]|[b]|[f]|[n]|[r]|[t]|[v]|[\']|[\"]|[\?]|{BACKSLASH}|[0]))
Identifier=({Letter}({Letter}|{Digit}|"$")*)
ErrorIdentifier=({AnyNonSeparator}+)

Comment1=("//"[^\r\n]*)
Comment2=("'"[^\r\n]*)


LongSuffix=(([lL][uU]?)|([uU][lL]?))
DecimalNum=(([0]|{NonZeroDigit}{Digit}*){LongSuffix}?)
HexNum=([0]([x]|[X]){HexDigit}{HexDigit}*{LongSuffix}?)
HexNum2=(([$]){HexDigit}{HexDigit}*{LongSuffix}?)

Sign=([\+\-])
SignedInt=({Sign}?{Digit}+)
Expo=([eE])
ExponentPart=({Expo}{SignedInt})
FloatSuffix=([fFlL])
FloatWDecimal=(({Digit}*[\.]{Digit}+)|({Digit}+[\.]{Digit}*))
Float1=({FloatWDecimal}{ExponentPart}?)
Float2=({Digit}+{ExponentPart})
Float=(({Float1}|{Float2}){FloatSuffix}?)
ErrorFloat=({Digit}({AnyNonSeparator}|[\.])*)


AnyStrChr=([^\"\n\r\\\?])
SlashNewLine=({BACKSLASH}{EOL})
FalseTrigraph= (("?"(("?")*)[^\=\(\)\/\'\<\>\!\-\\\?\"\n\r])|("?"[\=\(\)\/\'\<\>\!\-]))
UnclosedString=([\"]((((("?")*)({Escape}|{HexEscape}))|{FalseTrigraph}|{AnyStrChr}|{SlashNewLine})*)(("?")*))
String=({UnclosedString}[\"])
MalformedUnclosedString=([\"]([^\"\n\r])*)
MalformedString=({MalformedUnclosedString}[\"])


operators=("("|")"|{LBRACE}|{RBRACE}|{LBRACKET}|{RBRACKET}|";"|"," |","|"."|"="|">"|"<"|"!"|"not"|{TILDE}|"compl"|"+"|"-"|"*" |"/"|"&"|"bitand"|{VERTICAL}|"bitor"|{CARET}|"xor"
|"%"|"=="|"<="|">="|"!="|"not_eq"|{VERTICAL}{VERTICAL}|("&&"|"and")|("||"|"or")|">>"|"<<")

keywordsBASIC=("bp"|"call"|"clear"|"chain"|"continue"|"dim"|"dir"
|"exit"|"for"|"repeat"|"while"
|"next"|"function"|"endfunction"|"if"|"then"|"else"|"elseif"
|"endif"|"let"|"load"|"mem"|"print"|"return"|"reload"|"rerun"|"until"|"rem"
|"run"|"step"|"sub"|"stop"|"endsub"|"tron"|"troff"|"endwhile")

constantsVec32=("controller1"|"controller2"|"controllernone"|"joystickanalog"|"joystickdigital"
|"joysticknone"|"joystickx"|"joysticky"|"drawto"|"moveto")
constantsBASIC=("false"|"true"|"pi"|"nil")
constants={constantsVec32}|{constantsBASIC}

functionBASIC=("abs"|"acos"|"appendarrays"|"asin"|"atan"|"chr"|"copyarray"|"cos"
|"dir"|"float"|"int"|"left"|"len"|"max"|"mid"|"min"|"rand"
|"randomize"|"right"|"round"|"sin"|"sqrt"|"strcomp"|"tan"
|"tolower"|"toupper"|"truncate"|"right"|"ubound")
functionVec32=("abc"|"clearscreen"|"distance"|"dotssprite"|"dumpsprite"|"dumpsprites"|"getframerate"|"intensitysprite"
|"linessprite"|"movesprite"|"music"|"musicisplaying"|"offset"|"peek"|"play"|"ptinrect"|"putspriteafter"
|"putspritebefore"|"regularpolygon"|"removesprite"|"returntooriginsprite"|"scalesprite"|"setframerate"|"spriteclip"
|"spriteenable"|"spritegetrotation"|"spriteintensity"|"spritemove"|"spriterotate"
|"spritescale"|"spritesetmagnification"|"spritesetrotation"|"spritetranslate"|"textlistsprite"|"textsizesprite"|"textsprite"|"version"|"waitforframe")
functions={functionBASIC}|{functionVec32}
%% 

<YYINITIAL, MIDDLE_OF_LINE> {operators} { 
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.RESERVED_OPERATOR;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

<YYINITIAL, MIDDLE_OF_LINE> {keywordsBASIC} {
    nextState = MIDDLE_OF_LINE;
	lastToken = BASICToken.RESERVED_WORD;
	String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
	yybegin(nextState);
    return(t);
}
<YYINITIAL, MIDDLE_OF_LINE> {constants} {
    nextState = MIDDLE_OF_LINE;
	lastToken = BASICToken.RESERVED_REGISTER;
	String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
	yybegin(nextState);
    return(t);
}
<YYINITIAL, MIDDLE_OF_LINE> {functions} {
    nextState = MIDDLE_OF_LINE;
	lastToken = BASICToken.RESERVED_ASMWORD;
	String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
	yybegin(nextState);
    return(t);
}



<YYINITIAL, MIDDLE_OF_LINE> {BooleanLiteral} { 
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.LITERAL_BOOLEAN;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

<YYINITIAL, MIDDLE_OF_LINE> {Identifier} { 
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.IDENTIFIER;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

<YYINITIAL, MIDDLE_OF_LINE> {DecimalNum} {
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.LITERAL_INTEGER_DECIMAL;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<YYINITIAL, MIDDLE_OF_LINE> {HexNum} {
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.LITERAL_INTEGER_HEXIDECIMAL;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<YYINITIAL, MIDDLE_OF_LINE> {HexNum2} {
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.LITERAL_INTEGER_HEXIDECIMAL;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<YYINITIAL, MIDDLE_OF_LINE> {Float} {
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.LITERAL_FLOATING_POINT;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<YYINITIAL, MIDDLE_OF_LINE> {String} { 
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.LITERAL_STRING;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

<YYINITIAL, MIDDLE_OF_LINE> ({NonBreakingWhiteSpace}+) { 
    lastToken = BASICToken.WHITE_SPACE;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
	return (t);
}

<YYINITIAL, MIDDLE_OF_LINE> ({WhiteSpace}+) { 
    nextState = YYINITIAL;
    lastToken = BASICToken.WHITE_SPACE;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
	yybegin(nextState);
    return (t);
}

<YYINITIAL, MIDDLE_OF_LINE> {Comment1} { 
    nextState = YYINITIAL;
    lastToken = BASICToken.COMMENT_END_OF_LINE;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}

<YYINITIAL, MIDDLE_OF_LINE> {Comment2} { 
    nextState = YYINITIAL;
    lastToken = BASICToken.COMMENT_END_OF_LINE;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<YYINITIAL, MIDDLE_OF_LINE> {UnclosedString} { 
    /* most of these errors have to be caught down near the end of the file.
     * This way, previous expressions of the same length have precedence.
     * This is really useful for catching anything bad by just allowing it 
     * to slip through the cracks. 
     */ 
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.ERROR_UNCLOSED_STRING;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<YYINITIAL, MIDDLE_OF_LINE> {MalformedUnclosedString} { 
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.ERROR_MALFORMED_UNCLOSED_STRING;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<YYINITIAL, MIDDLE_OF_LINE> {MalformedString} { 
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.ERROR_MALFORMED_STRING;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<YYINITIAL, MIDDLE_OF_LINE> {ErrorFloat} { 
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.ERROR_FLOAT;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
<YYINITIAL, MIDDLE_OF_LINE> {ErrorIdentifier} { 
    nextState = MIDDLE_OF_LINE;
    lastToken = BASICToken.ERROR_IDENTIFIER;
    String text = yytext();
	BASICToken t = (new BASICToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    yybegin(nextState);
    return (t);
}
