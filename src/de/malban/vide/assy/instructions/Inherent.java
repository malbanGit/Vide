// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class represents an instruction that has no explicitly-referenced
// arguments; the state that it manipulates is either not data-storage
// (ie: cwai et al) or is implicitly specified by the opcode (ie: clra).
package de.malban.vide.assy.instructions;

import de.malban.vide.assy.instructions.InstructionGroup;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.expressions.Expression;

public class Inherent extends InstructionGroup 
{
    int numberOf = 1;
    boolean isNop=false;
    public boolean parse( String arg ) 
    {
        length = opcodelength;
        if (mnemonic.toLowerCase().equals("nop"))
        {
            isNop = true;
            try
            {
                Expression localExpression = null;
                localExpression = Expression.parse(arg, this.symtab);
    
                numberOf = localExpression.eval(this.symtab);
                if (numberOf<=0)numberOf=1;
                length = opcodelength*numberOf;
            }
            catch (Throwable ex)
            {
                // nop is allowed to habe NO parameter, ignore
                // if nothing was found (or wrong)
            }
        }
        return true;
    }

    public boolean evalArgs() 
    {
        // no arguments to evaluate; always succeeds
        return true;
    }

    public boolean codegen( Memory mm ) 
    {
        if (isNop)
        {
            for (int i = 0; i < numberOf; i++) 
            {
                mm.write(this.address + i*opcodelength,opcode, Memory.MEM_CODE);
            }
            return true;
        }
        writeOpcode(mm);
        return true;
    }
}

