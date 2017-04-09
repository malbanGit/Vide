// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class represents an instruction that has one argument, in memory,
// found by any of several addressing modes.
package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.instructions.InstructionGroup;
import de.malban.vide.assy.arguments.Argument6809;
import de.malban.vide.assy.arguments.ArgumentMemoryLocation;
import de.malban.vide.assy.Memory;
import static de.malban.vide.assy.arguments.Argument6809.EXTENDED_MODE;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;

public class SingleArg extends InstructionGroup {
	public ArgumentMemoryLocation m;
	
	public boolean parse( String arg ) throws ParseException {
		m = new ArgumentMemoryLocation(arg,symtab,this);
		switch (m.getMode()) {
			case Argument6809.DIRECT_MODE:
				setLength( 2 );
				opcode += 0x00;
				break;
			case Argument6809.INDEXED_MODE:
				setLength( 1 + m.getNumPostbytes() );
				opcode += 0x60;
				break;
			case Argument6809.EXTENDED_MODE:
				setLength( 3 );
				opcode += 0x70;
				break;
			default:
				throw new ParseException( "bad mode" );
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
                            if (source.op.toLowerCase().equals("jmp"))
                            {
// malban   System.out.println("Changing line: "+source.inputLine+" line" + source.getLineNumber());                        
// check if something like jmp >bla
if (source.rest.startsWith(">"))
{
    source.rest = source.rest.substring(1); // bra cannot copy with extended addressing!
}
                                
                                String old = source.op;
                                source.op="BRA";
                                Instruction i = (Instruction)Asmj.processor.instructionSet.get(source.op );
                                source.setInstruction(i);
                                i.source = source;
                                i.pass1( address, symtab );
                                Asmj.optimize( source, "Optimization changing \""+old+"\" to \""+source.op+"\" (NOP inserted)");                            
                                return true;
                            }
                        }
                    }                    
                }

                                    
                
		return true;
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

