// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

package de.malban.vide.assy.exceptions;

// Signifies a problem because of an undefined symbol.
// This is exactly the same as DoesNotExistException, but it is explicit
// that the non-existant entity is a symbol.

public class SymbolDoesNotExistException extends DoesNotExistException {
	public SymbolDoesNotExistException( ) { super(); }
	public SymbolDoesNotExistException( String s ) { super(s); }
	public SymbolDoesNotExistException( String s, String n ) { super(s,n); }
}

