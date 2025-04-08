// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class represents an instruction that uses one argument in a
// register (implicitly specified by the opcode), and one in memory
// (found by one of several possible addressing modes).
//
// The fact that one argument is in a register is relevant only because
// it means that the memory argument can use any of the four addressing
// modes.  Contrast this with the SingleArg class.
//
// The class name could be better.  What was I thinking?
package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.arguments.Argument6809;
import de.malban.vide.assy.arguments.ArgumentMemoryLocation;
import de.malban.vide.assy.Memory;
import static de.malban.vide.assy.arguments.Argument6809.EXTENDED_MODE;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;

public class RegArg extends InstructionGroup {
	public ArgumentMemoryLocation m;
	public boolean parse( String arg ) throws ParseException {
//            if (source.inputLine.contains("ZAHLEN_MAX,X"))
//                    //if (pline.lineNumber ==282)
//                        System.out.println("BU");
		m = new ArgumentMemoryLocation(arg,symtab,this);
		switch (m.getMode()) {
			case Argument6809.IMMEDIATE_MODE:
				//System.out.println("  m.getMode() IMMEDIATE");
				setLength( getOpcodeLength()+getDataLength() );
				break;
			case Argument6809.DIRECT_MODE:
				//System.out.println("  m.getMode() DIRECT");
				setLength( getOpcodeLength()+1 );
				opcode += 0x10;
				break;
			case Argument6809.INDEXED_MODE:
				//System.out.println("  m.getMode() INDEXED");
				setLength( getOpcodeLength() + m.getNumPostbytes() );
				opcode += 0x20;
				break;
			case Argument6809.EXTENDED_MODE:
				//System.out.println("  m.getMode() EXTENDED");
				setLength( getOpcodeLength()+2 );
				opcode += 0x30;
				break;
			default:
				throw new ParseException("bad mode");
		}
		return true;
	}

	public boolean evalArgs() throws SymbolDoesNotExistException {
		m.eval(symtab); // throws SymbolDoesNotExistException
               // malban

                        
                if (m.getMode() == EXTENDED_MODE)
                {
                    int pc = address + 2; // 2 size of short branch (bra), this is what our base is!
                    int dest = m.getOffset(); // SymbolDoesNotExistExc
                    int offset = (dest - pc);
                    if (source.isOptimize())
                    {
                        boolean isShort = false;
                        boolean isNegative = offset<0;

                        if (isNegative)
                            if (offset >=-128) isShort = true;

                        // 127 insted of 128
                        // since if we took 127 and "shorten" our opcode byet one byte
                        // the offset would again be 128
                        // and that would be out of bounds again
                        if (!isNegative) 
                            if (offset <127) isShort = true;
                        if (isShort)
                        {
                            if (source.op.toLowerCase().equals("jsr"))
                            {
                                Asmj.warning(source, "Optimization possible, (long) jsr can be changed to short (bsr):  \""+source.op+"\" offset:  "+offset);                            
                            }
                        }
                    }                    
                }		return true;
	}

	public boolean codegen( Memory mm ) {
		writeOpcode(mm);
		m.codegen(
			mm,
			symtab,
			address+getOpcodeLength(),
			getDataLength() );
		return true;
	}
}

