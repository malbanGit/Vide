// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy;


import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_UNKOWN;
import java.io.PrintStream;
import java.util.Vector;

public class SymbolTable {
	public static final int NO_LINE_NUMBER = -2;

	Vector /* of Symbol */ symbols;

        public Vector getSymbols()
        {
            return symbols;
        }
        
	public SymbolTable() {
		symbols = new Vector();
	}
/*
	public boolean define( String name, int value, int where_defined ) 
        {
            return define(  name,  value,  where_defined , null) ;
        }
	public boolean define( String name, int value, int where_defined , String comment) 
        {
            return define(  name,  value,  where_defined ,  comment, SYMBOL_DEFINE_UNKOWN) ;
            
        }
        */
	public boolean define( String name, int value, int where_defined , String comment, int definedHow) 
        {
            Symbol s = find(name);
            if (s != null) 
            {
                s.define( value, where_defined );
            } 
            else 
            {
                s = new Symbol( name, value, where_defined );
                symbols.addElement( s );
            }
            s.definedHow = definedHow;
            if (definedHow == Symbol.SYMBOL_DEFINE_CODE)
            {
                s.used = true;
                s.labelUsage = true;
                
            }
            if (comment != null)
            {
                s.line_Comment = comment;
            }
            return true;
	}

	public boolean undefine( Symbol s ) {
		return symbols.removeElement(s);
	}

	public Symbol reference( String name ) {
		Symbol s = find(name);
		if (s == null) {
			s = new Symbol(name);
			symbols.addElement( s );
		}
		return s;
	}

	public int getValue( String name ) {
		Symbol s = find(name);
		return (s != null)?  s.getValue()  : -1;
	}

	public void setValue( String name, int value ) {
		Symbol s = find(name);
		if (s != null) { s.setValue(value); }
	}

	// returns null if no Symbol with that name is found
	public Symbol find( String name ) {
		Symbol s;
		
		for (int i=0; i<symbols.size(); i++) {
			try { s = (Symbol)symbols.elementAt(i); }
			catch (ClassCastException x) { continue; }
			if (s.getName().equals(name)) { return s; }
		}
		return null;
	}

	public void dump( PrintStream out ) {
		Symbol s;
		String name, formatted_value;
		int i, value;
		
		out.println( "Symbol Table" );
		for (i=0; i<symbols.size(); i++) {
			s = (Symbol)symbols.elementAt(i);
			name = s.getName();
			if (name.startsWith("*")) { continue; }
			if (s.defined()) {
				value = s.getValue();
				formatted_value =
					"0000" + Integer.toHexString(value);
				formatted_value =
					formatted_value.substring( 
						formatted_value.length() - 4 );
			} else {
				formatted_value = "----";
			}
			out.println( "  "+formatted_value+"  "+name );
		}
	}

}

