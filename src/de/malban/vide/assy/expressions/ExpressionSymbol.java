// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy.expressions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.ParseString;
import de.malban.vide.assy.Symbol;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.SymbolTable;


public class ExpressionSymbol extends Expression {
	Symbol symbol;
        public Symbol getSymbol()
        {
            return symbol;
        }
        
	public static Expression parse( String s, SymbolTable st )
		throws ParseException
	{
		return new ExpressionSymbol( new ParseString(s), st );
	}
        public boolean isNumber()
        {
            return false;
        }

	public static Expression parse( ParseString s, SymbolTable st )
		throws ParseException
	{
		return new ExpressionSymbol(s,st);
	}

	private ExpressionSymbol( ParseString s, SymbolTable st )
		throws ParseException
	{
		String symbolName = parseName(s);
		symbol = st.reference(symbolName);
                
		if (symbol.defined()) { value = symbol.getValue(); }
	}

	public int eval(SymbolTable st) throws SymbolDoesNotExistException {
                symbolIsDefined();
		value = symbol.getValue();
		return value;
	}
	public int eval(SymbolTable st, boolean treatAsZero) throws SymbolDoesNotExistException {
            try
            {
               symbolIsDefined();
                
            }
            catch (SymbolDoesNotExistException ex)
            {
                if (treatAsZero)
                {
                    value = 0;
                    return value;
                }
                throw ex;
            }
		value = symbol.getValue();
		return value;
	}

	public static String parseName( String s ) {
		try { return parseName( new ParseString(s) ); }
		catch (ParseException x) { return ""; }
	}

	public static String parseName( ParseString s )
		throws ParseException
	{
		char ch0, quote;
		
		//parseStart(s);
		int sourceStart = s.getPosition();
		
		ch0 = s.charAt(0);
		if ( ! isSymbolChar1(ch0) ) {
			//parseError("missing symbol name");
			s.setPosition( sourceStart );
			//sourceEnd = sourceStart;
			throw new ParseException("missing symbol name",true);
		}
		s.skip(1);
		while (s.length()>0 && isSymbolChar(s.charAt(0))) { s.skip(1); }
		int n = s.getPosition() - sourceStart;
		String symbolName = s.substring(-n,0);
		if (symbolName.startsWith("*") && symbolName.length()>1) {
			//parseError("illegal symbol name",false);
			s.setPosition( sourceStart );
			//sourceEnd = sourceStart;
			throw new ParseException("illegal symbol name",false);
		}
		
		//parseEnd();
		// int sourceEnd = s.getPosition();
		
		return symbolName;
	}



	private static boolean isSymbolChar( char ch ) {
		return symbolChars.indexOf(ch) >= 0;
	}

	private static boolean isSymbolChar1( char ch ) {
		return symbolChar1s.indexOf(ch) >= 0;
	}

	private void symbolIsDefined() throws SymbolDoesNotExistException {
		if (!symbol.defined()) {
			throw new SymbolDoesNotExistException(
				"Symbol not defined: " + symbol.getName(),
				symbol.getName()
			);
		}
	}
}

