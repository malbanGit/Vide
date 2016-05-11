// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy.expressions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.AsmjDeath;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.ParseString;
import de.malban.vide.assy.SymbolTable;


public class ExpressionNumber extends Expression {
	public static Expression parse( String s, SymbolTable st )
		throws ParseException
	{ 
		return new ExpressionNumber( new ParseString(s) );
	}
        public boolean isNumber()
        {
            return true;
        }

	public static Expression parse( ParseString s, SymbolTable t )
		throws ParseException
	{
		return new ExpressionNumber(s);
	}

	public static ExpressionNumber create( int value ) {
		return new ExpressionNumber(value);
	}

	protected ExpressionNumber( int n ) {
		value = n;
	}

	protected ExpressionNumber( ParseString s ) throws ParseException {
		parseStart(s);
		
		parseNumber(s);
		
		// Malban calculating from large expressions 
                // is not wrong, as long as the
                // RESULT is small enough! 
                //value &= 65535;
		parseEnd();
	}

	// throws ParseException if not successful
	protected int parseNumber( ParseString s ) throws ParseException {
		char ch0;
		int n;
		String s2 = null;
		
		
		if (s.length() == 0) { parseError("missing numeric literal"); }
		
		ch0 = s.charAt(0);
		int p0 = s.getPosition();
		
		ExpressionNumber ext = Asmj.processor.numberParser;
		if (ext != null) {
			try { value = ext.parseNumber(s); return value; }
			catch (ParseException x) { }
		}
		
		if (s.skipCase("0x")) {
			// generic hexadecimal number
			int p1 = s.getPosition();
			while ( s.length()>0 && isHexDigit(s.charAt(0)) ) {
				s.skip(1);
			}
			n = s.getPosition() - p1;
			if (n == 0) { parseError("missing hex digits",false); }
			s2 = s.substring(-n,0);
			try { value = Integer.parseInt( s2, 16 ); }
			catch (NumberFormatException x) {
				throw new AsmjDeath(
					"Asmj bug: format of $"+s2 );
			}
			return value;
		}
		
		s.setPosition(p0);
		if ( isDecimalDigit(ch0) ) {
			// definitely a decimal number
			s.skip(1); // first digit
			while ( s.length()>0 && isDecimalDigit(s.charAt(0)) ) {
				s.skip(1);
			}
			n = s.getPosition() - p0;
			if (n==0) { parseError("missing decimal digits"); }
			s2 = s.substring(-n,0);
			try { value = Integer.parseInt( s2 ); }
			catch (NumberFormatException x) {
				throw new AsmjDeath(
					"Asmj bug: format of "+s2 );
			}
			return value;
		}
		
		// s does not hold a number
		parseError("missing numeric literal");
		
		return 0; // unreachable, but javac doesn't know that.
	}

	public int eval(SymbolTable t) { return value; }

	public static int eval(String expr) throws ParseException {
		Expression e = ExpressionNumber.parse(expr,null);
		return e.value;
	}

	protected static boolean isHexDigit( char ch ) {
		return hexDigits.indexOf(ch) >= 0;
	}

	protected static boolean isDecimalDigit( char ch ) {
		return decimalDigits.indexOf(ch) >= 0;
	}

	protected static boolean isOctalDigit( char ch ) {
		return octalDigits.indexOf(ch) >= 0;
	}

	protected static boolean isBinaryDigit( char ch ) {
		return binaryDigits.indexOf(ch) >= 0;
	}

}

