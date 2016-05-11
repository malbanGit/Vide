// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class represents an instruction that takes a pair of same-sized
// registers as arguments.
package de.malban.vide.assy.instructions;

import de.malban.vide.assy.instructions.InstructionGroup;
import de.malban.vide.assy.arguments.ArgumentRegisterList;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.Register;
import de.malban.vide.assy.RegisterSet;

public class RegReg extends InstructionGroup {
	Register src, dst;

	public boolean parse( String arg ) throws ParseException {
		ArgumentRegisterList rl = new ArgumentRegisterList(
			arg, getRestrictions(), RegisterSet.XFER_ENCODING );
		if (rl.getNumRegisters() != 2) {
			throw new ParseException("expected two registers");
		}
		src = rl.getReg(0);
		dst = rl.getReg(1);
		if ( src.getSize() != dst.getSize() ) {
			src = dst = null;
			throw new ParseException("size mismatch");
		}
		setLength( 2 );
		return true;
	}

	public boolean evalArgs() {
		// no arguments need evaluation; always succeeds
		return true;
	}

	public boolean codegen( Memory mm ) {
		writeOpcode(mm);
		int postbyte = (src.getCode(RegisterSet.XFER_ENCODING) << 4)
		             |  dst.getCode(RegisterSet.XFER_ENCODING);
		mm.write( address+1, postbyte, Memory.MEM_CODE_POSTBYTE );
		return true;
	}

}

