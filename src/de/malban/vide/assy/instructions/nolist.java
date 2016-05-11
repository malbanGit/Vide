package de.malban.vide.assy.instructions;

import de.malban.vide.assy.LineContext;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;



public class nolist extends PseudoOp
{
    int value;

    public boolean parse(String paramString) throws ParseException
    {
        setLength(0);

        // do nothing yet!
        // todo: fixme  implement something
        
        return true;
    }
}
