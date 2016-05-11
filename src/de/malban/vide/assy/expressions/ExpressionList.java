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
import java.util.Vector;

public class ExpressionList extends Expression {
	private Vector /* of Expression */ list;
        public Expression elementAt(int i)
        {
            return (Expression)list.elementAt(i);
        }
        public int size()
        {
            return list.size();
        }
	public static Expression parse( String s, SymbolTable st )
		throws ParseException
	{ 
		return new ExpressionList( new ParseString(s), st );
	}

	public static Expression parse( ParseString s, SymbolTable st )
		throws ParseException
	{
		return new ExpressionList(s,st);
	}

	private ExpressionList( ParseString s, SymbolTable st )
		throws ParseException
	{
		Expression t;
		
		// System.out.println("  ExpressionList("+s.toString()+")");
		parseStart(s);
		
		list = new Vector();
		while (true) {
			t = Expression.parse(s,st);
			list.addElement(t);
			// System.out.println("  s.length "+s.length);
			// if (s.length()>0) {
			// 	System.out.println("  s.charAt(0)"+s.charAt(0));
			// }
			if (s.length() <= 0 || s.charAt(0) != ',') { break; }
			s.skip(1); // comma
		}
		
		if ( ! s.endOfExpression() ) {
			throw new ParseException("illegal trailing characters");
		}
		
		parseEnd();
	}

	// List items can each possibly hold multiple subitems; keep track
	// of which subitems the "current" list item holds (itemNum0..itemNum1).
	private int listItemNum = -1, itemNum0 = -1, itemNum1 = -1;

	public Expression listItem(int n) {
		return (Expression)list.elementAt(n);
	}
        public boolean isNumber()
        {
            boolean ret = true;
            for (int i=0; i<list.size(); i++) {
                    ret = ret & listItem(i).isNumber();
            }
            return ret;
        }
	public int getItem(int n) {
		if (n < itemNum0) {
			// start searching from the beginning again
			listItemNum = itemNum0 = itemNum1 = -1;
		}
		// step forward through list items until we get n subitems
		while (itemNum1 < n) {
			listItemNum += 1;
			itemNum0 = itemNum1+1;
			itemNum1 = itemNum0+listItem(listItemNum).numItems()-1;
		}
		// get a subitem from the item
		return listItem(listItemNum).getItem(n-itemNum0);
	}

	public int getValue() { return listItem(0).getItem(0); }

	public int numItems() {
		int n = 0;
		for (int i=0; i<list.size(); i++) {
			n += listItem(i).numItems();
		}
		return n;
	}

	public int eval( SymbolTable st ) throws SymbolDoesNotExistException {
		for (int i=0; i<list.size(); i++) {
			Expression t = (Expression)list.elementAt(i);
			t.eval(st);
		}
		return 0;
	}

}

