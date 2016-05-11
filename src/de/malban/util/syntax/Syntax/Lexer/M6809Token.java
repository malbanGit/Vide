
package de.malban.util.syntax.Syntax.Lexer;


/** 
 * A M6809Token is a token that is returned by a lexer that is lexing a java
 * source file.  It has several attributes describing the token:
 * The type of token, the text of the token, the line number on which it
 * occurred, the number of characters into the input at which it started, and
 * similarly, the number of characters into the input at which it ended. <br>
 */ 
public class M6809Token extends Token {
  
    public final static int RESERVED_WORD = 0x0100;
    public static final int RESERVED_REGISTER = 0x110;
    public final static int IDENTIFIER = 0x200;

    public final static int LINE_LABEL = 0x250;
    
    public final static int LITERAL_BOOLEAN = 0x300;
    public final static int LITERAL_INTEGER = 0x310;
    
    public final static int IMMEDIATE_NUMBER = 0x340;
    public final static int LITERAL_CHARACTER = 0x350;
    public final static int LITERAL_STRING = 0x360;
    public final static int LITERAL_NULL = 0x370;
    public final static int LITERAL_VARIABLE = 0x380;

    public final static int SEPARATOR_LPAREN = 0x400;
    public final static int SEPARATOR_RPAREN = 0x401;
    public final static int SEPARATOR_LBRACE = 0x410;
    public final static int SEPARATOR_RBRACE = 0x411;  
    public final static int SEPARATOR_LBRACKET = 0x420;
    public final static int SEPARATOR_RBRACKET = 0x421;
    public final static int SEPARATOR_SEMICOLON = 0x430;
    public final static int SEPARATOR_COMMA = 0x440;
    public final static int SEPARATOR_PERIOD = 0x450;

    public final static int RESERVED_OPERATOR = 0x500;
    public final static int RESERVED_ASMWORD = 0x0600;


    public final static int COMMENT_LINE = 0xD00;
    public final static int COMMENT_END_OF_LINE = 0xD10;

    public final static int WHITE_SPACE = 0xE00;

    public final static int ERROR_IDENTIFIER = 0xF00;
    public final static int ERROR_UNCLOSED_STRING = 0xF10;
    public final static int ERROR_MALFORMED_STRING = 0xF11;
    public final static int ERROR_MALFORMED_UNCLOSED_STRING = 0xF12;
    public final static int ERROR_UNCLOSED_CHARACTER = 0xF20;
    public final static int ERROR_MALFORMED_CHARACTER = 0xF21;
    public final static int ERROR_MALFORMED_UNCLOSED_CHARACTER = 0xF22;
    public final static int ERROR_INTEGER_DECIMIAL_SIZE = 0xF30;
    public final static int ERROR_INTEGER_OCTAL_SIZE = 0xF31;
    public final static int ERROR_INTEGER_HEXIDECIMAL_SIZE = 0xF32;
    public final static int ERROR_LONG_DECIMIAL_SIZE = 0xF33;
    public final static int ERROR_LONG_OCTAL_SIZE = 0xF34;
    public final static int ERROR_LONG_HEXIDECIMAL_SIZE = 0xF35;
    public final static int ERROR_FLOAT_SIZE = 0xF36;
    public final static int ERROR_DOUBLE_SIZE = 0xF37;
    public final static int ERROR_FLOAT = 0xF38;
    public final static int ERROR_UNCLOSED_COMMENT = 0xF40;
  
    private int ID;
    private String contents;
    private int lineNumber;
    private int charBegin;
    private int charEnd;
    private int state;

    /**
     * Create a new token.
     * The constructor is typically called by the lexer
     *
     * @param ID the id number of the token
     * @param contents A string representing the text of the token
     * @param lineNumber the line number of the input on which this token started
     * @param charBegin the offset into the input in characters at which this token started
     * @param charEnd the offset into the input in characters at which this token ended
     */
    public M6809Token(int ID, String contents, int lineNumber, int charBegin, int charEnd)
    {
        this (ID, contents, lineNumber, charBegin, charEnd, Token.UNDEFINED_STATE);
    }

    /**
     * Create a new token.
     * The constructor is typically called by the lexer
     *
     * @param ID the id number of the token
     * @param contents A string representing the text of the token
     * @param lineNumber the line number of the input on which this token started
     * @param charBegin the offset into the input in characters at which this token started
     * @param charEnd the offset into the input in characters at which this token ended
     * @param state the state the tokenizer is in after returning this token.
     */
    public M6809Token(int ID, String contents, int lineNumber, int charBegin, int charEnd, int state)
    {
        this.ID = ID;
        this.contents = new String(contents);
        this.lineNumber = lineNumber;
        this.charBegin = charBegin;
        this.charEnd = charEnd;
        this.state = state;
    }

    /**
       * Get an integer representing the state the tokenizer is in after
       * returning this token.
       * Those who are interested in incremental tokenizing for performance
       * reasons will want to use this method to figure out where the tokenizer
       * may be restarted.  The tokenizer starts in Token.INITIAL_STATE, so
       * any time that it reports that it has returned to this state, the
       * tokenizer may be restarted from there.
       */
    public int getState()
    {
        return state;
    }

    /** 
     * get the ID number of this token
     * 
     * @return the id number of the token
     */
    public int getID()
    {
        return ID;
    }

    /** 
     * get the contents of this token
     * 
     * @return A string representing the text of the token
     */
    public String getContents()
    {
        return (new String(contents));
    }

    /** 
     * get the line number of the input on which this token started
     * 
     * @return the line number of the input on which this token started
     */
    public int getLineNumber()
    {
        return lineNumber;
    }

  /** 
   * get the offset into the input in characters at which this token started
   *
   * @return the offset into the input in characters at which this token started
   */
  public int getCharBegin(){
  	return charBegin;
  }

  /** 
   * get the offset into the input in characters at which this token ended
   *
   * @return the offset into the input in characters at which this token ended
   */
  public int getCharEnd(){
 	return charEnd;
  }

  /** 
   * Checks this token to see if it is a reserved word.
   * Reserved words 
   * @return true if this token is a reserved word, false otherwise
   */
  public boolean isReservedWord(){
  	return((ID >> 8) == 0x1);
  }
  public boolean isRegister(){
  	return(ID  == RESERVED_REGISTER);
  }
  public boolean isASMWord(){
  	return ((ID >= 0x600) && (ID <= 0x6ff)) ;
  }

  /** 
   * Checks this token to see if it is an identifier.
   * Identifiers 
   * @return true if this token is an identifier, false otherwise
   */
  public boolean isIdentifier(){
  	return((ID >> 8) == 0x2);
  }

  public boolean isName(){
  	return ((ID&0x250) == 0x250);
  }
  /** 
   * Checks this token to see if it is a literal.
   * Literals 
   * @return true if this token is a literal, false otherwise
   */
  public boolean isLiteral(){
  	return((ID >> 8) == 0x3);
  }
  public boolean isLiteralString(){
  	return(ID  == LITERAL_STRING);
  }
  public boolean isLiteralVariable(){
  	return(ID  == LITERAL_VARIABLE);
  }
  
  
  
  /** 
   * Checks this token to see if it is a Separator.
   * Separators 
   * @return true if this token is a Separator, false otherwise
   */
  public boolean isSeparator(){
  	return((ID >> 8) == 0x4);
  }

  /** 
   * Checks this token to see if it is a Operator.
   * Operators 
   * @return true if this token is a Operator, false otherwise
   */
  public boolean isOperator(){
  	return((ID >> 8) == 0x5);
  }

  /** 
   * Checks this token to see if it is a comment.
   * 
   * @return true if this token is a comment, false otherwise
   */
  public boolean isComment(){
  	return((ID >> 8) == 0xD);
  }

  /** 
   * Checks this token to see if it is White Space.
   * Usually tabs, line breaks, form feed, spaces, etc.
   * 
   * @return true if this token is White Space, false otherwise
   */
  public boolean isWhiteSpace(){
  	return((ID >> 8) == 0xE);
  }

  /** 
   * Checks this token to see if it is an Error.
   * Unfinished comments, numbers that are too big, unclosed strings, etc.
   * 
   * @return true if this token is an Error, false otherwise
   */
  public boolean isError(){

  	return((ID >> 8) == 0xF);
  }

	/**
	 * A description of this token.  The description should
	 * be appropriate for syntax highlighting.  For example
	 * "comment" is returned for a comment.
     *
	 * @return a description of this token.
	 */
	public String getDescription(){
		if (isRegister()){
			return("register");
		} else if (isReservedWord()){
			return("reservedWord");
		} else if (isASMWord()){
			return("preprocessor");
                } else if (isIdentifier()){
			return("identifier");
		} else if (isLiteralVariable()){
                        return("literalVariable"); 
		} else if (isLiteralString()){
                        return("literalstring"); 
		} else if (isLiteral()){
                        return("literal"); 
                } else if (isSeparator()){
			return("separator");
		} else if (isOperator()){
			return("operator");
		} else if (isComment()){
			return("comment");
		} else if (isWhiteSpace()){
			return("whitespace");
		} else if (isName()){
		 	return("name");
		} else if (isError()){
		 	return("error");
		} else {
			return("unknown");
		}
	}

  /**
   * get a String that explains the error, if this token is an error.
   * 
   * @return a  String that explains the error, if this token is an error, null otherwise.
   */
  public String errorString(){
  	String s;
  	if (isError()){
  		s = "Error on line " + lineNumber + ": ";
  		switch (ID){
  		case ERROR_IDENTIFIER:
  			s += "Unrecognized Identifier: " + contents;
  		break; 
		case ERROR_UNCLOSED_STRING:
  			s += "'\"' expected after " + contents;
  		break; 		
		case ERROR_MALFORMED_STRING:
		case ERROR_MALFORMED_UNCLOSED_STRING:
  			s += "Illegal character in " + contents;
  		break;
		case ERROR_UNCLOSED_CHARACTER:
  			s += "\"'\" expected after " + contents;
  		break; 		
		case ERROR_MALFORMED_CHARACTER:
		case ERROR_MALFORMED_UNCLOSED_CHARACTER:
  			s += "Illegal character in " + contents;
  		break;
		case ERROR_INTEGER_DECIMIAL_SIZE:
		case ERROR_INTEGER_OCTAL_SIZE:
		case ERROR_FLOAT:  			
  			s += "Illegal character in " + contents;
  		break;
		case ERROR_INTEGER_HEXIDECIMAL_SIZE:
		case ERROR_LONG_DECIMIAL_SIZE:
		case ERROR_LONG_OCTAL_SIZE:
		case ERROR_LONG_HEXIDECIMAL_SIZE:
		case ERROR_FLOAT_SIZE:
		case ERROR_DOUBLE_SIZE:
  			s += "Literal out of bounds: " + contents;
  		break;
		case ERROR_UNCLOSED_COMMENT:
  			s += "*/ expected after " + contents;
  		break;
		}
  			
  	} else {
  		s = null;
  	}
  	return (s);
  }

  /** 
   * get a representation of this token as a human readable string.
   * The format of this string is subject to change and should only be used
   * for debugging purposes.
   *
   * @return a string representation of this token
   */  
  public String toString() {
      return ("Token #" + Integer.toHexString(ID) + ": " + getDescription() + " Line " + 
      	lineNumber + " from " +charBegin + " to " + charEnd + " : " + contents);
  }


  public boolean isMacroName=false;
  public boolean isMacroLabelName=false;
  public boolean isMacroParameterName=false;
  
  
}
