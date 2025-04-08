// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy;

import java.util.Vector;

// A string with a "cursor" - a marker that remembers a position.

public class ParseString {
	String buffer;
	int cursor, length;

        // replace from current position assumed HEX
        // trailing "H" with leading $
        public void changeHexTypeH()
        {
            String s1= buffer.substring(0,cursor);
            String s2= buffer.substring(cursor, buffer.indexOf("H"));
            String s3= buffer.substring(buffer.indexOf("H")+1, buffer.length());
            
            buffer = s1+"$" +s2+s3;
            length = buffer.length();
        }
        // cursor stays
        public void insert(int startInsert, String what)
        {
            String s1= buffer.substring(0,cursor+startInsert);
            String s2= buffer.substring(cursor+startInsert);

            buffer = s1+what+s2;
            length = buffer.length();
        }

        
	
        public ParseString( char c ) {
		char[] buf = { c };
		buffer = new String(buf);
		length = 1;
		cursor = 0;
	}

	public ParseString( String s ) {
		buffer = s;
		length = s.length();
		cursor = 0;
	}

        public String removeFrom(int pos)
        {
            if (pos >=length) return "";
            if (pos <0) return "";
            String ret = buffer.substring(pos);
            buffer = buffer.substring(0, pos);
            length = buffer.length();
            if (cursor >=length)
                cursor = length;
            return ret;
        }
        
        
	public int getPosition() { return cursor; }
	public void setPosition(int p) { cursor = p; }
	public boolean more() { return cursor < length; }
	public ParseString reset()     { cursor = 0;  return this; }
	public boolean skip(int n) {
            if (length() < n) { return false; }
            cursor += n;
            return true;
	}
	public boolean skip(String s) {
            if (!startsWith(s)) { return false; }
            cursor += s.length();
            return true;
	}
	public boolean skipCase(String s) {
            if (!startsWithCase(s)) { return false; }
            cursor += s.length();
            return true;
	}

	public boolean startsWith(String s) {
		return buffer.substring(cursor).startsWith(s);
	}
	public boolean startsWithCase(String s) {
            return buffer.substring(cursor).toLowerCase()
                    .startsWith( s.toLowerCase() );
	}
	public boolean endsWith(String s) {
		return buffer.substring(cursor).endsWith(s);
	}
	public boolean trimEndsWith(String s) {
		return buffer.trim().substring(cursor).endsWith(s);
	}
	
        public boolean trimLocalEndsWith(String s) {
            String l = buffer.substring(cursor).trim();
            int li = l.indexOf(",");
            if (li>=0) l = l.substring(0, li);
            li = l.indexOf(")");
            if (li>=0) l = l.substring(0, li);
            li = l.indexOf("]");
            if (li>=0) l = l.substring(0, li);
            li = l.indexOf("+");
            if (li>=0) l = l.substring(0, li);
            li = l.indexOf("-");
            if (li>=0) l = l.substring(0, li);
            li = l.indexOf("*");
            if (li>=0) l = l.substring(0, li);
            li = l.indexOf("/");
            if (li>=0) l = l.substring(0, li);
            
            return l.trim().endsWith(s);
	}
        
        public boolean startsWithNumber()
        {
            String l = buffer.substring(cursor).trim();
            int len = l.length();
            if (len <= 0) return false;
            
            int p = 0;
            String sub = l.substring(p, p+1);
            if (!de.malban.util.UtilityString.isHexNumber(sub)) return false;

            p++;
            if (p==len) return true;
            sub = l.substring(p, p+1);
            if (!de.malban.util.UtilityString.isHexNumber(sub)) return false;

            p++;
            if (p==len) return true;
            sub = l.substring(p, p+1);
            if (!de.malban.util.UtilityString.isHexNumber(sub)) return false;

            p++;
            if (p==len) return true;
            sub = l.substring(p, p+1);
            if (!de.malban.util.UtilityString.isHexNumber(sub)) return false;
            
            return false;
        }
        
        public String getCurrentString()
        {
            return buffer.substring(cursor);
        }
        
        
        
        
	public char charAt(int n) {
            if (cursor+n >= buffer.length()) return 0;
            return buffer.charAt(cursor+n);
	}
	public int length() {
		return length - cursor;
	}
	public String substring( int n ) {
		return buffer.substring( cursor+n );
	}
	public String substring( int n, int m ) {
		return buffer.substring( cursor+n, cursor+m );
	}
	public String toLowerCase() {
		return buffer.substring(cursor).toLowerCase();
	}
	public String trim() {
		return buffer.substring(cursor).trim();
	}
	public String toString() {
		return substring(0);
	}
	public boolean endOfExpression() {
		return length() <= 0 || Character.isWhitespace(charAt(0));
	}
	public void skipSpaces() {
		while ( length() > 0 && Character.isWhitespace(charAt(0)) ) {
			skip(1);
		}
	}
	// A word is everything up to a white space.
	public String nextWord() {
		int p0 = cursor;
		while ( length() > 0 && ! Character.isWhitespace(charAt(0)) ) 
                {
                    skip(1);
		}
		return buffer.substring(p0,cursor);
	}

	// A symbol starts with a letter or underscore,
	// and is followed by letters, underscores, and digits.
	private static final String
		digits = "0123456789",
		letters = "abcdefghijklmnopqrstuvwxyz"
		        + "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
		symChar1s = letters + "_" + "*", // malban added "_" to start of labels
		symChars  = letters + "_" + digits;

	public String nextSymbol() {
		int len = 0;
		if ( length()==0 || symChar1s.indexOf(charAt(len))<0 ) {
			return null;
		}
		len += 1;
		
		while ( length()>len && symChars.indexOf(charAt(len))>=0 ) {
			len += 1;
		}
		
		// special case: "*" is OK only if it is the whole symbol
		if ( charAt(0)=='*' && len>1 ) { return null; }
		
		return substring(0,len);
	}

	public Vector parseArgs() {
		return parseArgs( substring(0) );
	}

	// Chop up a comma-seperated string, ending at the first white space.
	// This is used only for macro & conditional args
	public static Vector parseArgs( String s ) {
            // malban new
            Vector args = new Vector();
            String[] ar=s.split(",");
            
            for (String a: ar)
            {
                a = a.trim();
                if (a.length()==0) continue;
                args.addElement( a );
            }
            return args;
/*            
		StringBuffer buf = new StringBuffer();
            Vector args = new Vector();
		
		for (int p0=0; p0<s.length(); p0++) {
			char ch0 = s.charAt(p0);
			if (Character.isWhitespace(ch0)) { break; }
			if (ch0 == ',') {
				args.addElement( buf.toString() );
				buf = new StringBuffer();
			} else {
				buf.append(ch0);
			}
		}
		if (buf.length() > 0 || args.size() > 0) {
			args.addElement( buf.toString() );
		}
		
		return args;
        */
	}

}

