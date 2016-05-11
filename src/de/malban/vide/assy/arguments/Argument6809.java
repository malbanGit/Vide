// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

package de.malban.vide.assy.arguments;

public class Argument6809 extends Argument {

	int mode;

	public static final int
		UNKNOWN_MODE   = 0,
		IMMEDIATE_MODE = 1,
		DIRECT_MODE    = 2,
		EXTENDED_MODE  = 3,
		INDEXED_MODE   = 4,
		REGISTER_MODE  = 5;

	public static final String modeName[] = {
		"unknown",
		"immediate",
		"direct",
		"extended",
		"indexed",
		"register"
	};


	public Argument6809( ) { mode = UNKNOWN_MODE; }

	public int getMode()          { return mode; }
	// override in subclasses for which they are meaningful
	public int getNumPostbytes()  { return 0; }



}

