// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//3
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy.expressions;


import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.ParseString;
import de.malban.vide.assy.SymbolTable;
import java.util.Vector;

public class ExpressionString extends Expression {
	byte value[];
	int length;

	public static Expression parse( String s, SymbolTable st , boolean isFilename)
		throws ParseException
	{
		return new ExpressionString( new ParseString(s), isFilename );
	}
	public static Expression parse( String s, SymbolTable st )
		throws ParseException
	{
		return parse(  s,  st , false);
	}

	public static Expression parse( ParseString s, SymbolTable st )
		throws ParseException
	{
		return new ExpressionString(s);
	}
        public boolean isNumber()
        {
            return false;
        }

	private ExpressionString( ParseString s)
		throws ParseException
        {
            this(s ,false);
        }
	private ExpressionString( ParseString s , boolean isFilename)
		throws ParseException
	{
		char ch0, quote;
		Vector v;
//		if (s.toString().contains("\\")) 
//                    System.out.println();
		parseStart(s);
		
		if (s.length() == 0) {
			parseError("missing string expression");
		}
		
		ch0 = s.charAt(0);
		if (ch0 != '\'' && ch0 != '"') {
			parseError("missing leading quote");
		}
		quote = ch0;
		s.skip(1);
		
		v = new Vector();
		while (true) {
			if (s.length() <= 0) {
				parseError("missing trailing quote",false);
			}
			ch0 = s.charAt(0);
			if (ch0 == quote) { s.skip(1); break; }
                        if (!isFilename)
                        {
                            if (ch0 == '\\') {
                                    s.skip(1);
                                    ch0 = s.charAt(0);
                                    switch (ch0) {
                                            case '0': ch0 =  0; break;
                                            case 'a': ch0 =  7; break;
                                            case 'b': ch0 =  8; break;
                                            case 't': ch0 =  9; break;
                                            case 'n': ch0 = 10; break;
                                            case 'v': ch0 = 11; break;
                                            case 'f': ch0 = 12; break;
                                            case 'r': ch0 = 13; break;
                                    }
                            }
                        }

			v.addElement( new Integer(ch0) );
			s.skip(1);
		}
		
		length = v.size();
		value = new byte[ length ];
		for (int i=0; i<length; i++) {
			value[i] = (byte)((Integer)v.elementAt(i)).intValue();
		}
		
		parseEnd();
	}

	public int eval(SymbolTable t) { return getValue(); }
	public int numItems() { return length; }
	public int getItem(int n) { return (int)value[n]; }
	public int getValue() { return getValue(2); }
	public int getValue(int len) {
		int val = 0;
		for (int i=0; i<4 && i<len && i<length; i++) {
			val = (val << 8) | (value[i] & 255);
		}
		return val;
	}
	public String getString() { return new String(value); }

}

