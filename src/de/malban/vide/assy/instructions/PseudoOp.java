// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This is a base for all pseudo-op PseudoOp
package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Memory;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;

public abstract class PseudoOp extends Instruction {

	public PseudoOp() {
		opcode = 0;
		opcodelength = 0;
		datalength = 0;
	}

	public boolean parse( String arg ) throws ParseException {
		return true;
	}

	// parse() already evaluated arguments.
	public boolean evalArgs() throws SymbolDoesNotExistException {
		return true;
	}

	// This pseudo-op by itself generates no code.
	public boolean codegen( Memory mm ) { return true; }
	public boolean generatedCode() { return false; }

}

