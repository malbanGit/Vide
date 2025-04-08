// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

package de.malban.vide.assy.exceptions;

// Signifies a syntax problem

public class ParseException extends Exception {
	boolean severe;
	
	public ParseException() { severe = true; }
	public ParseException( String s ) 
        { 
            super(s); severe = true; 
        }
	public ParseException( String s, boolean b ) 
        { 
            super(s); severe = b; 
        }
	
	public boolean isSevere() { return severe; }
}

