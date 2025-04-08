// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class represents a branch instruction, which takes an address as
// its argument, and uses the offset from the current address in the
// generated code.
package de.malban.vide.assy.instructions;

import de.malban.vide.VideConfig;
import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.instructions.InstructionGroup;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;

public class Branch extends InstructionGroup {
	Expression destExpr;
	int offset, len, pc;
	SymbolDoesNotExistException x;

	public boolean parse( String arg ) throws ParseException {
		destExpr = Expression.parse(arg,symtab); // ParseException
		setLength( getOpcodeLength() + getDataLength() );
		pc = symtab.getValue("*");
		return true;
	}

	public boolean evalArgs() throws SymbolDoesNotExistException {
                    // malban
                // you can jump like:
                // 03c4   LBEQ    $F000   ;Cold_Start (Spectrum RA)
                // the test below gives an out of bounds error
                // since it does not take into account, that branches below zero "wrap"
                
                // I don't bother to correct it, 
                // i just look if it a slong branch and than stop testing,
                // long branches can never be oob!
//            if (source.getLineNumber()==385)
//                System.out.println("Buh!");
            
                // if target is a number, not a label,
                // that number is NOT again PC relative
                // that number allways is PC relative!
		int dest = destExpr.eval( symtab ); // SymbolDoesNotExistExc
                
                if (destExpr.isNumber())
                    offset = dest;
                else
                    offset = (dest - pc);
		len = getDataLength();

//                if (!source.isOptimize())
//System.out.println();
                
                if (source.isOptimize())
                {
                    boolean isShort = false;
                    boolean isNegative = offset<0;

                    if (isNegative)
                        if (offset >=-128) isShort = true;

                    // 126 insted of 128
                    // since if we took 126 and "shorten" our opcode byte two byte
                    // the offset would again be 128
                    // and that would be out of bounds again
                    if (!isNegative) 
                        if (offset <126) isShort = true;
                    
                    // check long to short offset
                    if (isShort)
                    {
                        if (source.op.toLowerCase().startsWith("l"))
                        {
                            if (source.op.toLowerCase().equals("lbra"))
                            {
                                String old = source.op;
                                source.op=source.op.substring(1);
                                Instruction i = (Instruction)Asmj.processor.instructionSet.get(source.op );
                                source.setInstruction(i);
                                i.source = source;
                                i.pass1( address, symtab );
                                Asmj.optimize( source, "Optimization changing \""+old+"\" to \""+source.op+"\" (NOP inserted)");                            
                                return true;
                            }
                            else
                            {
                                Asmj.warning(source, "Optimization possible, long branch can be changed to short:  \""+source.op+"\" offset:  "+offset);                            
                            }
                        }

                        // JSR and JMP are not "Branches" but "RegArg"/"singleArgs"
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    // check lbra
                    if (source.op.toLowerCase().equals("lbra"))
                    {
//System.out.println("Shrinking line: "+source.inputLine+" line" + source.getLineNumber());                        
                        String old = source.op;
                        source.op="JMP";
                        Instruction i = (Instruction)Asmj.processor.instructionSet.get(source.op );
                        source.setInstruction(i);
                        i.source = source;
                        i.pass1( address, symtab );
                        Asmj.optimize( source, "Optimization changing \""+old+"\" to \""+source.op+"\"");                            
                        return true;
                    }
                    // check lbrs
                    if (source.op.toLowerCase().equals("lbrs"))
                    {
                        String old = source.op;
                        source.op="JSR";
                        Instruction i = (Instruction)Asmj.processor.instructionSet.get(source.op );
                        source.setInstruction(i);
                        i.source = source;
                        i.pass1( address, symtab );
                        Asmj.optimize( source, "Optimization changing \""+old+"\" to \""+source.op+"\"");                            
                        return true;
                    }
                }
                
                
                
                if (source.op.toLowerCase().startsWith("l"))
                    return true;
                
		// Test for branch target out of range.
		// This is tricky.  We want to make sure no data is lost
		// due to the length of the data field (len).  So we mask
		// out those bits, and see if any bits are still set.
		// But if the number was negative, those bits will all
		// be set, as by sign-extension.  In that cast we negate
		// the data before masking out the lower bits.
		// Whether it was positive or negative, the sign bit should
		// be treated the same as the unmasked part, so we make the
		// mask one bit less than a whole number of bytes to leave
		// the sign bit unmasked.
		int mask = (1 << (len*8-1)) - 1;
		if ( (offset>0 && ( offset & ~mask)!=0) ||   (offset<0 && (~offset & ~mask)!=0) ) 
                {
                    // malban
                    if (VideConfig.getConfig().expandBranches)
                    {
                        // if we come here after a evalation of a befor
                        // unkown jump address (backward reference)
                        // than we can not (without) trouble expand to ling branches
                        // since all addresses ahead up to the label definition
                        // must be changed (+2 for lon branches)
                        // in this case we thro an error
                        // the user must handle that!
                        String stackTrace = de.malban.util.Utility.getCurrentStackTrace();
                        if (stackTrace.contains("Symbol.define"))
                        {
                            // we are called from hadnling "undefinedReferences"
                            // thus we can not expand - trhow error!
                            throw new SymbolDoesNotExistException( "target out of range" +
                                        "(from: $"+String.format("%04X", (pc & 0xFFFF))+
                                        " to: $"+String.format("%04X", (dest & 0xFFFF))+
                                        ", length: -$"+String.format("%02X", (65536-(offset & 0xFFFF)))+" ), forward reference code should not be altered automatically!" );
                        }
                        
                        
                        
//System.out.println("Expanding line: "+source.inputLine+" line" + source.getLineNumber());                        
                        Asmj.warning( source, "Expanding branch, "+"target out of range" +
                                    "(from: $"+String.format("%04X", (pc & 0xFFFF))+
                                    " to: $"+String.format("%04X", (dest & 0xFFFF))+
                                    ", length: -$"+String.format("%02X", (65536-(offset & 0xFFFF)))+" )"  );
                        source.op="L"+source.op;
                        Instruction i = (Instruction)Asmj.processor.instructionSet.get(source.op );
                        source.setInstruction(i);
                        i.source = source;
                        i.pass1( address, symtab );
                        return true;
                    }
                    if ((offset & 0xFFFF)>=32768)
                    {
                        throw new SymbolDoesNotExistException( "target out of range" +
                                    "(from: $"+String.format("%04X", (pc & 0xFFFF))+
                                    " to: $"+String.format("%04X", (dest & 0xFFFF))+
                                    ", length: -$"+String.format("%02X", (65536-(offset & 0xFFFF)))+" )" );
                            
                    }
                    throw new SymbolDoesNotExistException( "target out of range" +
                                "(from: $"+String.format("%04X", (pc & 0xFFFF))+
                                " to: $"+String.format("%04X", (dest & 0xFFFF))+
                                ", length: $"+String.format("%02X", (offset & 0xFFFF))+" )" );
		}
		
		return true;
	}

	public boolean codegen( Memory mm ) {
		writeOpcode(mm);
		int dataAddr = address + getOpcodeLength();
		mm.write( dataAddr, offset, len, true, Memory.MEM_CODE );
		return true;
	}
}

