// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class represents a push or pull instruction, which takes a list
// of registers as its argument.
package de.malban.vide.assy.instructions;

import de.malban.vide.assy.instructions.InstructionGroup;
import de.malban.vide.assy.arguments.ArgumentRegisterList;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.Register;
import de.malban.vide.assy.RegisterSet;

public class Stack extends InstructionGroup {
	ArgumentRegisterList rl;

	public boolean parse( String arg ) throws ParseException {
		rl = new ArgumentRegisterList(
			arg, getRestrictions(), RegisterSet.STACK_ENCODING );
		setLength( 2 );
		return true;
	}

	public boolean evalArgs() {
		// no arguments need evaluation; always succeeds
		return true;
	}

	public boolean codegen( Memory mm ) {
		writeOpcode(mm);
		int postbyte = 0;
		for (int i=0; i<rl.getNumRegisters(); i++) {
			Register reg = rl.getReg(i);
			postbyte |= reg.getCode( RegisterSet.STACK_ENCODING );
		}
		mm.write( address+1, postbyte, Memory.MEM_CODE_POSTBYTE );
		return true;
	}
}

