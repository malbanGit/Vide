// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class keeps track of a conditional (if..elseif..else..endif) block
// or a macro (macro..endm) block as it is parsed.  For consistency, the
// outermost block is also a kind of Conditional.
//
// The state tells whether to process lines of source code or skip them.
// When an if/elseif is parsed, the state is explicitly set to whatever
// value the instruction produces.  When an else is parsed, the state is
// inverted.  The surrounding state is passed-in when the Conditional is
// constructed, and getState() AND's the current state against that, so
// if the enclosing state is false, this will always return false.
//
// A macro definition is similar to an always-false condition: the source
// code of the definition should never generate code.  (Code is generated
// for the lines that are produced by a reference to a macro; those lines
// are not the lines in the definition, they are expanded copies.)
//
// The outer block is similar to an always-true condition: the source code
// should always generate code.  (Except where some inner conditional
// overrides it).
//
// We also keep track of the depth of macro expansion of the line that
// caused this Conditional.  The 'exitm' pseudo-op may cause 'endif's to
// be skipped; the depth lets us know which Conditionals to pop off of
// the stack to avoid complaints about those "unterminated" 'if's.
package de.malban.vide.assy;

public class Conditional {
	boolean state;
	boolean enclosingState;
	int macroDepth; // macro depth of line that created this conditional
	
	int type; // values for type:
	private static final int T_IF=1, T_MACRO=2, T_OUTER=3;
	
	boolean foundTrueBranch; // meaningful iff type==IF

	int parsed; // meaningful iff type==IF
	// values for parsed:
	private static final int P_IF=1, P_ELSE=2, P_ENDIF=3;


	// no boolean args means we're creating an outer context
	public Conditional( )   {
		type = T_OUTER;
		macroDepth = 0;
		state = enclosingState = true;
	}
	
	// one boolean arg means we're creating a macro context
	public Conditional( int d, boolean e )   {
		enclosingState = e;
		type = T_MACRO;
		macroDepth = d;
		// within macro definitions, we _never_ process instructions
		state = false;
	} 
	
	// two boolean args mean we're creating a conditional ("if") context
	public Conditional( int d, boolean e, boolean s )   {
		enclosingState = e;
		type = T_IF;
		parsed = P_IF;
		macroDepth = d;
		state = foundTrueBranch = s;
	} 
	
	public void parseElseif( boolean s ) {
		state = s && !foundTrueBranch;
		foundTrueBranch |= state;
	}
	public void parseElse()           {
		parsed = P_ELSE;
		state = !foundTrueBranch;
		foundTrueBranch = true;
	}
	
	public int getType()               { return type; }
	public boolean getState()          { return enclosingState && state; }
	public boolean getEnclosingState() { return enclosingState; }
	public boolean pastElse()          { return (parsed >= P_ELSE); }
	public boolean isMacro()           { return (type == T_MACRO); }
	public boolean isIf()              { return (type == T_IF); }
	public int getMacroDepth()         { return macroDepth; }

}

