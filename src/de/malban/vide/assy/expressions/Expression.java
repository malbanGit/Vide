// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy.expressions;

import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.ParseString;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.SymbolTable;


public abstract class Expression {
	protected static final String
		decimalDigits = "0123456789",
		octalDigits = "01234567",
		binaryDigits = "01",
		letters = "abcdefghijklmnopqrstuvwxyz"
		        + "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
		symbolChar1s = letters + "*" + "_",
		symbolChars = letters + decimalDigits + "_",
		hexDigits = decimalDigits + "abcdefABCDEF";

	// scalars leave a value here
	protected int value;
        public abstract boolean isNumber();
	// keep track of the source that we parsed into an expression
	protected int sourceStart, sourceEnd;
	protected ParseString buf;
	
	protected void parseStart( ParseString s ) {
		buf = s;
		sourceStart = buf.getPosition();
	}
	protected void parseEnd() {
		sourceEnd = buf.getPosition();
	}
	public int parseLength() { return sourceEnd - sourceStart; }
	protected void parseError( String err ) throws ParseException {
		parseError(err,true);
	}
	protected void parseError( String err, boolean sev )
		throws ParseException
	{
		buf.setPosition( sourceStart );
		sourceEnd = sourceStart;
		throw new ParseException(err,sev);
	}


	// during evaluation, we may hit undefined symbols
	public abstract int eval(SymbolTable st)
		throws SymbolDoesNotExistException;
	public int eval(SymbolTable st, boolean treatAsZero)
		throws SymbolDoesNotExistException
        {
            return eval(st);
        }
	// scalars are 1 item; strings and lists are normally more than 1...
	public int numItems() { return 1; } // strings and lists override this
	public int getItem(int n) { return value; } // ... and this
	public int getValue() { return value; }     // ... and this
	public int getValue(int len) {              // ... and this too
		int mask = (1<<(8*len)) - 1;
		return value & mask;
	}
	



	// parse an arbitrary expression
	public static Expression parse( String s, SymbolTable st )
		throws ParseException
	{
		// Given a string, convert it into a ParseString
		return parse( new ParseString(s+" "), st );
	}
	public static Expression parse( ParseString s, SymbolTable st )
		throws ParseException
	{
		return ExpressionOp.parse(s,st);
	}

	// parse a single term
	public static Expression parseTerm( ParseString buf, SymbolTable st )
		throws ParseException
	{
		Expression e;
		/* protected */ int sourceStart;
		buf.skipSpaces(); // malban why no spacen in expressions are they BAD?
		if (buf.length()==0 || Character.isWhitespace(buf.charAt(0))) {
			throw new ParseException("missing term");
		}
		
		try { return ExpressionSymbol.parse(buf,st); }
		catch (ParseException x) { if (!x.isSevere()) { throw x; } }
		
		try { return ExpressionNumber.parse(buf,st); }
		catch (ParseException x) { if (!x.isSevere()) { throw x; } }
		
		try { return ExpressionString.parse(buf,st); }
		catch (ParseException x) { if (!x.isSevere()) { throw x; } }
		
		// is it a parenthesized term?
		sourceStart = buf.getPosition();
		char ch0 = buf.charAt(0);
		if (ch0 != '(') {
			// error...
			throw new ParseException(
				"unrecognized expression: "
				+ buf.toString() );
		}
		
		buf.skip(1);
		Expression t1 = parse(buf,st);
		buf.skipSpaces(); // malban why no spacen in expressions are they BAD?
		if ( ! buf.startsWith(")") ) {
			// parse error!
			buf.setPosition( sourceStart );
			throw new ParseException(
				"missing closing parenthesis" );
		}
		buf.skip(1);
		return t1;
	}

}

