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

/** 
 * M6809Lexer is a M6809 lexer.  Created with JFlex.  An example of how it is used:
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
                if (t.getID() != JavaToken.WHITE_SPACE){
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
%char
%full

HexDigit=([0-9a-fA-F])
Digit=([0-9])
OctalDigit=([0-7])
TetraDigit=([0-3])
NonZeroDigit=([1-9])
BLANK=([ ])
TAB=([\t])
FF=([\f])
EscChar=([\\])
CR=([\r])
LF=([\n])
EOL=({CR}|{LF}|{CR}{LF})
WhiteSpace=({BLANK}|{TAB}|{FF}|{EOL})
AnyNonSeparator=([^\t\f\r\n\ \(\)\{\}\[\]\;\,\.\=\>\<\!\~\?\:\+\-\*\/\&\|\^\%\"\'])

OctEscape1=({EscChar}{OctalDigit})
OctEscape2=({EscChar}{OctalDigit}{OctalDigit})
OctEscape3=({EscChar}{TetraDigit}{OctalDigit}{OctalDigit})
OctEscape=({OctEscape1}|{OctEscape2}|{OctEscape3})

Escape=({EscChar}([r]|[n]|[b]|[f]|[t]|[\\]|[\']|[\"]))
ErrorIdentifier=({AnyNonSeparator}+)

Comment=(";"[^\r\n]*)

LongSuffix=([l]|[L])
DecimalNum=(([0]|{NonZeroDigit}{Digit}*))
OctalNum=([0]{OctalDigit}*)
HexNum=([0]([x]|[X]){HexDigit}{HexDigit}*)
DecimalLong=({DecimalNum}{LongSuffix})
OctalLong=({OctalNum}{LongSuffix})
HexLong=({HexNum}{LongSuffix})

AnyChrChr=([^\'\n\r\\])
UnclosedCharacter=([\']({Escape}|{OctEscape}|{AnyChrChr}))
Character=({UnclosedCharacter}[\'])
MalformedUnclosedCharacter=([\']({AnyChrChr}|({EscChar}[^\n\r]))*)
MalformedCharacter=([\'][\']|{MalformedUnclosedCharacter}[\'])

AnyStrChr=([^\"\n\r\\])
UnclosedString=([\"]({Escape}|{OctEscape}|{AnyStrChr})*)
String=({UnclosedString}[\"])
MalformedUnclosedString=([\"]({EscChar}|{AnyStrChr})*)
MalformedString=({MalformedUnclosedString}[\"])

%%

<YYINITIAL> "(" { 
    lastToken = JavaToken.SEPARATOR_LPAREN;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
    }
<YYINITIAL> ")" {
    lastToken = JavaToken.SEPARATOR_RPAREN;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "[" {
    lastToken = JavaToken.SEPARATOR_LBRACKET;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "]" {
    lastToken = JavaToken.SEPARATOR_RBRACKET;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "," {
    lastToken = JavaToken.SEPARATOR_COMMA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "." {
    lastToken = JavaToken.SEPARATOR_PERIOD;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

<YYINITIAL> "=" {
    lastToken = JavaToken.OPERATOR_ASSIGN;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> ">" {
    lastToken = JavaToken.OPERATOR_FORCE16BIT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "<" {
    lastToken = JavaToken.OPERATOR_FORCE8BIT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "!" {
    lastToken = JavaToken.OPERATOR_LOGICAL_NOT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "~" {
    lastToken = JavaToken.OPERATOR_BITWISE_COMPLIMENT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "+" {
    lastToken = JavaToken.OPERATOR_ADD;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "-" {
    lastToken = JavaToken.OPERATOR_SUBTRACT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "*" {
    lastToken = JavaToken.OPERATOR_MULTIPLY;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "/" {
    lastToken = JavaToken.OPERATOR_DIVIDE;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "&" {
    lastToken = JavaToken.OPERATOR_BITWISE_AND;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "|" {
    lastToken = JavaToken.OPERATOR_BITWISE_OR;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "^" {
    lastToken = JavaToken.OPERATOR_BITWISE_XOR;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "%" {
    lastToken = JavaToken.OPERATOR_BINARY;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

<YYINITIAL> "==" {
    lastToken = JavaToken.OPERATOR_EQUAL;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "<=" { 
    lastToken = JavaToken.OPERATOR_LESS_THAN_OR_EQUAL;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> ">=" { 
    lastToken = JavaToken.OPERATOR_GREATER_THAN_OR_EQUAL;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "!=" { 
    lastToken = JavaToken.OPERATOR_NOT_EQUAL;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "||" { 
    lastToken = JavaToken.OPERATOR_LOGICAL_OR;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "&&" { 
    lastToken = JavaToken.OPERATOR_LOGICAL_AND;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "++" { 
    lastToken = JavaToken.OPERATOR_INCREMENT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "--" { 
    lastToken = JavaToken.OPERATOR_DECREMENT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> ">>" { 
    lastToken = JavaToken.OPERATOR_SHIFT_RIGHT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "<<" { 
    lastToken = JavaToken.OPERATOR_SHIFT_LEFT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

<YYINITIAL> "LBRN" {
    lastToken = M6809Token.RESERVED_WORD_LBRN;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LDY" {
    lastToken = M6809Token.RESERVED_WORD_LDY;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LDX" {
    lastToken = M6809Token.RESERVED_WORD_LDX;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "DEC" {
    lastToken = M6809Token.RESERVED_WORD_DEC;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ASLB" {
    lastToken = M6809Token.RESERVED_WORD_ASLB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ASLA" {
    lastToken = M6809Token.RESERVED_WORD_ASLA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BRA" {
    lastToken = M6809Token.RESERVED_WORD_BRA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "SUBD" {
    lastToken = M6809Token.RESERVED_WORD_SUBD;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "SUBB" {
    lastToken = M6809Token.RESERVED_WORD_SUBB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "EXG" {
    lastToken = M6809Token.RESERVED_WORD_EXG;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBRA" {
    lastToken = M6809Token.RESERVED_WORD_LBRA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "SUBA" {
    lastToken = M6809Token.RESERVED_WORD_SUBA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "RORB" {
    lastToken = M6809Token.RESERVED_WORD_RORB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "RORA" {
    lastToken = M6809Token.RESERVED_WORD_RORA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "TSTA" {
    lastToken = M6809Token.RESERVED_WORD_TSTA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "TSTB" {
    lastToken = M6809Token.RESERVED_WORD_TSTB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BRN" {
    lastToken = M6809Token.RESERVED_WORD_BRN;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "STB" {
    lastToken = M6809Token.RESERVED_WORD_STB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "STA" {
    lastToken = M6809Token.RESERVED_WORD_STA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "STD" {
    lastToken = M6809Token.RESERVED_WORD_STD;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CLR" {
    lastToken = M6809Token.RESERVED_WORD_CLR;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "COMA" {
    lastToken = M6809Token.RESERVED_WORD_COMA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "COMB" {
    lastToken = M6809Token.RESERVED_WORD_COMB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "STS" {
    lastToken = M6809Token.RESERVED_WORD_STS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "STU" {
    lastToken = M6809Token.RESERVED_WORD_STU;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "STX" {
    lastToken = M6809Token.RESERVED_WORD_STX;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "STY" {
    lastToken = M6809Token.RESERVED_WORD_STY;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BSR" {
    lastToken = M6809Token.RESERVED_WORD_BSR;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "TFR" {
    lastToken = M6809Token.RESERVED_WORD_TFR;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LEAX" {
    lastToken = M6809Token.RESERVED_WORD_LEAX;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BCC" {
    lastToken = M6809Token.RESERVED_WORD_BCC;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LEAY" {
    lastToken = M6809Token.RESERVED_WORD_LEAY;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ROLB" {
    lastToken = M6809Token.RESERVED_WORD_ROLB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ANDB" {
    lastToken = M6809Token.RESERVED_WORD_ANDB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ROLA" {
    lastToken = M6809Token.RESERVED_WORD_ROLA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ANDA" {
    lastToken = M6809Token.RESERVED_WORD_ANDA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "JSR" {
    lastToken = M6809Token.RESERVED_WORD_JSR;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBLT" {
    lastToken = M6809Token.RESERVED_WORD_LBLT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBLS" {
    lastToken = M6809Token.RESERVED_WORD_LBLS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BCS" {
    lastToken = M6809Token.RESERVED_WORD_BCS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBCS" {
    lastToken = M6809Token.RESERVED_WORD_LBCS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LEAS" {
    lastToken = M6809Token.RESERVED_WORD_LEAS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BLE" {
    lastToken = M6809Token.RESERVED_WORD_BLE;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBLE" {
    lastToken = M6809Token.RESERVED_WORD_LBLE;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LEAU" {
    lastToken = M6809Token.RESERVED_WORD_LEAU;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "PSHU" {
    lastToken = M6809Token.RESERVED_WORD_PSHU;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBCC" {
    lastToken = M6809Token.RESERVED_WORD_LBCC;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "RTI" {
    lastToken = M6809Token.RESERVED_WORD_RTI;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBSR" {
    lastToken = M6809Token.RESERVED_WORD_LBSR;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "SEX" {
    lastToken = M6809Token.RESERVED_WORD_SEX;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BLS" {
    lastToken = M6809Token.RESERVED_WORD_BLS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BLT" {
    lastToken = M6809Token.RESERVED_WORD_BLT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "RTS" {
    lastToken = M6809Token.RESERVED_WORD_RTS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "INCA" {
    lastToken = M6809Token.RESERVED_WORD_INCA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "INCB" {
    lastToken = M6809Token.RESERVED_WORD_INCB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "EORB" {
    lastToken = M6809Token.RESERVED_WORD_EORB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ABX" {
    lastToken = M6809Token.RESERVED_WORD_ABX;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CLRA" {
    lastToken = M6809Token.RESERVED_WORD_CLRA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "EORA" {
    lastToken = M6809Token.RESERVED_WORD_EORA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CLRB" {
    lastToken = M6809Token.RESERVED_WORD_CLRB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "PULS" {
    lastToken = M6809Token.RESERVED_WORD_PULS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "SWI3" {
    lastToken = M6809Token.RESERVED_WORD_SWI3;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "PSHS" {
    lastToken = M6809Token.RESERVED_WORD_PSHS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "PULU" {
    lastToken = M6809Token.RESERVED_WORD_PULU;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ASL" {
    lastToken = M6809Token.RESERVED_WORD_ASL;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "SWI2" {
    lastToken = M6809Token.RESERVED_WORD_SWI2;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BMI" {
    lastToken = M6809Token.RESERVED_WORD_BMI;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "COM" {
    lastToken = M6809Token.RESERVED_WORD_COM;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ASR" {
    lastToken = M6809Token.RESERVED_WORD_ASR;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBVS" {
    lastToken = M6809Token.RESERVED_WORD_LBVS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "SWI" {
    lastToken = M6809Token.RESERVED_WORD_SWI;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "DAA" {
    lastToken = M6809Token.RESERVED_WORD_DAA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "JMP" {
    lastToken = M6809Token.RESERVED_WORD_JMP;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BVC" {
    lastToken = M6809Token.RESERVED_WORD_BVC;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "DECB" {
    lastToken = M6809Token.RESERVED_WORD_DECB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BEQ" {
    lastToken = M6809Token.RESERVED_WORD_BEQ;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBEQ" {
    lastToken = M6809Token.RESERVED_WORD_LBEQ;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "NEG" {
    lastToken = M6809Token.RESERVED_WORD_NEG;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBVC" {
    lastToken = M6809Token.RESERVED_WORD_LBVC;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BNE" {
    lastToken = M6809Token.RESERVED_WORD_BNE;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BVS" {
    lastToken = M6809Token.RESERVED_WORD_BVS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBNE" {
    lastToken = M6809Token.RESERVED_WORD_LBNE;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBMI" {
    lastToken = M6809Token.RESERVED_WORD_LBMI;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CPX" {
    lastToken = M6809Token.RESERVED_WORD_CPX;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "SYNC" {
    lastToken = M6809Token.RESERVED_WORD_SYNC;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "DECA" {
    lastToken = M6809Token.RESERVED_WORD_DECA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CWAI" {
    lastToken = M6809Token.RESERVED_WORD_CWAI;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ORCC" {
    lastToken = M6809Token.RESERVED_WORD_ORCC;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBPL" {
    lastToken = M6809Token.RESERVED_WORD_LBPL;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BGE" {
    lastToken = M6809Token.RESERVED_WORD_BGE;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CMPU" {
    lastToken = M6809Token.RESERVED_WORD_CMPU;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CMPS" {
    lastToken = M6809Token.RESERVED_WORD_CMPS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LSRA" {
    lastToken = M6809Token.RESERVED_WORD_LSRA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "MUL" {
    lastToken = M6809Token.RESERVED_WORD_MUL;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LSRB" {
    lastToken = M6809Token.RESERVED_WORD_LSRB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBHI" {
    lastToken = M6809Token.RESERVED_WORD_LBHI;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LSR" {
    lastToken = M6809Token.RESERVED_WORD_LSR;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ASRA" {
    lastToken = M6809Token.RESERVED_WORD_ASRA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ADDB" {
    lastToken = M6809Token.RESERVED_WORD_ADDB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ADDA" {
    lastToken = M6809Token.RESERVED_WORD_ADDA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ROL" {
    lastToken = M6809Token.RESERVED_WORD_ROL;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "NOP" {
    lastToken = M6809Token.RESERVED_WORD_NOP;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BGT" {
    lastToken = M6809Token.RESERVED_WORD_BGT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ADDD" {
    lastToken = M6809Token.RESERVED_WORD_ADDD;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ASRB" {
    lastToken = M6809Token.RESERVED_WORD_ASRB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBGT" {
    lastToken = M6809Token.RESERVED_WORD_LBGT;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "PAGE3" {
    lastToken = M6809Token.RESERVED_WORD_PAGE3;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ROR" {
    lastToken = M6809Token.RESERVED_WORD_ROR;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "TST" {
    lastToken = M6809Token.RESERVED_WORD_TST;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "PAGE2" {
    lastToken = M6809Token.RESERVED_WORD_PAGE2;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "SBCA" {
    lastToken = M6809Token.RESERVED_WORD_SBCA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BITA" {
    lastToken = M6809Token.RESERVED_WORD_BITA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "SBCB" {
    lastToken = M6809Token.RESERVED_WORD_SBCB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BITB" {
    lastToken = M6809Token.RESERVED_WORD_BITB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CMPX" {
    lastToken = M6809Token.RESERVED_WORD_CMPX;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CMPY" {
    lastToken = M6809Token.RESERVED_WORD_CMPY;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ORB" {
    lastToken = M6809Token.RESERVED_WORD_ORB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "INC" {
    lastToken = M6809Token.RESERVED_WORD_INC;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BPL" {
    lastToken = M6809Token.RESERVED_WORD_BPL;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ORA" {
    lastToken = M6809Token.RESERVED_WORD_ORA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "NEGB" {
    lastToken = M6809Token.RESERVED_WORD_NEGB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "BHI" {
    lastToken = M6809Token.RESERVED_WORD_BHI;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "NEGA" {
    lastToken = M6809Token.RESERVED_WORD_NEGA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LBGE" {
    lastToken = M6809Token.RESERVED_WORD_LBGE;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LDA" {
    lastToken = M6809Token.RESERVED_WORD_LDA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LDB" {
    lastToken = M6809Token.RESERVED_WORD_LDB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ADCA" {
    lastToken = M6809Token.RESERVED_WORD_ADCA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LDD" {
    lastToken = M6809Token.RESERVED_WORD_LDD;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ADCB" {
    lastToken = M6809Token.RESERVED_WORD_ADCB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CMPD" {
    lastToken = M6809Token.RESERVED_WORD_CMPD;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CMPB" {
    lastToken = M6809Token.RESERVED_WORD_CMPB;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "CMPA" {
    lastToken = M6809Token.RESERVED_WORD_CMPA;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LDS" {
    lastToken = M6809Token.RESERVED_WORD_LDS;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "LDU" {
    lastToken = M6809Token.RESERVED_WORD_LDU;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> "ANDCC" {
    lastToken = M6809Token.RESERVED_WORD_ANDCC;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}


<YYINITIAL> {DecimalNum} {
    /* At this point, the number we found could still be too large.
     * If it is too large, we need to return an error.
     * Java has methods built in that will decode from a string
     * and throw an exception the number is too large 
     */     
    String text = yytext();
    try {
        /* bigger negatives are allowed than positives.  Thus
         * we have to be careful to make sure a neg sign is preserved
         */
        if (lastToken == JavaToken.OPERATOR_SUBTRACT){
            Integer.decode('-' + text);
        } else {
            Integer.decode(text);
        }
        lastToken = JavaToken.LITERAL_INTEGER_DECIMAL;
    } catch (NumberFormatException e){
        lastToken = JavaToken.ERROR_INTEGER_DECIMIAL_SIZE;
    }
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {OctalNum} {
    /* An Octal number cannot be too big.  After removing 
     * initial zeros, It can have 11 digits, the first
     * of which must be 3 or less.
     */
    lastToken = JavaToken.LITERAL_INTEGER_OCTAL;
    int i;     
    String text = yytext();
    int length = text.length();
    for (i=1 ; i<length-11; i++){
        //check for initial zeros
        if (yytext().charAt(i) != '0'){ 
            lastToken = JavaToken.ERROR_INTEGER_OCTAL_SIZE;
        }
    }
    if (length - i > 11){
        lastToken = JavaToken.ERROR_INTEGER_OCTAL_SIZE;
    } else if (length - i == 11){
        // if the rest of the number is as big as possible
        // the first digit can only be 3 or less
        if (text.charAt(i) != '0' && text.charAt(i) != '1' && 
        text.charAt(i) != '2' && text.charAt(i) != '3'){
            lastToken = JavaToken.ERROR_INTEGER_OCTAL_SIZE;
        }
    }
    // Otherwise, it should be OK  
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {HexNum} {
    /* A Hex number cannot be too big.  After removing 
     * initial zeros, It can have 8 digits
     */
    lastToken = JavaToken.LITERAL_INTEGER_HEXIDECIMAL;
    int i;    
    String text = yytext();
    int length = text.length();
    for (i=2 ; i<length-8; i++){
        //check for initial zeros
        if (text.charAt(i) != '0'){ 
            lastToken = JavaToken.ERROR_INTEGER_HEXIDECIMAL_SIZE;
        }
    }
    if (length - i > 8){
        lastToken = JavaToken.ERROR_INTEGER_HEXIDECIMAL_SIZE;
    }
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {DecimalLong} { 
    String text = yytext();
    try {
        if (lastToken == JavaToken.OPERATOR_SUBTRACT){
            Long.decode('-' + text.substring(0,text.length()-1));
        } else {
            Long.decode(text.substring(0,text.length()-1));
        }
        lastToken = JavaToken.LITERAL_LONG_DECIMAL;
    } catch (NumberFormatException e){  
        lastToken = JavaToken.ERROR_LONG_DECIMIAL_SIZE;
    }
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {OctalLong} {
    /* An Octal number cannot be too big.  After removing 
     * initial zeros, It can have 23 digits, the first
     * of which must be 1 or less.  The last will be the L or l
     * at the end.
     */
    lastToken = JavaToken.LITERAL_LONG_OCTAL;
    int i; 
    String text = yytext();
    int length = text.length();
    for (i=1 ; i<length-23; i++){
        //check for initial zeros
        if (text.charAt(i) != '0'){ 
            lastToken = JavaToken.ERROR_LONG_OCTAL_SIZE;
        }
    }
    if (length - i > 23){
        lastToken = JavaToken.ERROR_LONG_OCTAL_SIZE;
    } else if (length - i == 23){
        // if the rest of the number is as big as possible
        // the first digit can only be 3 or less
        if (text.charAt(i) != '0' && text.charAt(i) != '1'){
            lastToken = JavaToken.ERROR_LONG_OCTAL_SIZE;
        }
    }
    // Otherwise, it should be OK  
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {HexLong} {
    /* A Hex long cannot be too big.  After removing 
     * initial zeros, It can have 17 digits, the last of which is
     * the L or l
     */
    lastToken = JavaToken.LITERAL_LONG_HEXIDECIMAL;
    int i;
    String text = yytext();
    int length = text.length();
    for (i=2 ; i<length-17; i++){
        //check for initial zeros
        if (text.charAt(i) != '0'){ 
            lastToken = JavaToken.ERROR_LONG_HEXIDECIMAL_SIZE;
        }
    }
    if (length - i > 17){
        lastToken = JavaToken.ERROR_LONG_HEXIDECIMAL_SIZE;
    }
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

<YYINITIAL> {Character} { 
    lastToken = JavaToken.LITERAL_CHARACTER;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {String} { 
    lastToken = JavaToken.LITERAL_STRING;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

<YYINITIAL> ({WhiteSpace}+) { 
    lastToken = JavaToken.WHITE_SPACE;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}

<YYINITIAL> {Comment} { 
    lastToken = JavaToken.COMMENT_END_OF_LINE;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}


<YYINITIAL> {UnclosedString} { 
    /* most of these errors have to be caught down near the end of the file.
     * This way, previous expressions of the same length have precedence.
     * This is really useful for catching anything bad by just allowing it 
     * to slip through the cracks. 
     */ 
    lastToken = JavaToken.ERROR_UNCLOSED_STRING;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {MalformedUnclosedString} { 
    lastToken = JavaToken.ERROR_MALFORMED_UNCLOSED_STRING;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {MalformedString} { 
    lastToken = JavaToken.ERROR_MALFORMED_STRING;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {UnclosedCharacter} { 
    lastToken = JavaToken.ERROR_UNCLOSED_CHARACTER;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {MalformedUnclosedCharacter} { 
    lastToken = JavaToken.ERROR_MALFORMED_UNCLOSED_CHARACTER;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {MalformedCharacter} { 
    lastToken = JavaToken.ERROR_MALFORMED_CHARACTER;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
<YYINITIAL> {ErrorIdentifier} { 
    lastToken = JavaToken.ERROR_IDENTIFIER;
    String text = yytext();
    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));
    return (t);
}
