package de.malban.vide.assy.instructions;

import de.malban.vide.assy.LineContext;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;



public class direct extends PseudoOp
{
    int value;

    public boolean parse(String paramString) throws ParseException
    {
        Expression localExpression = null;
        localExpression = Expression.parse(paramString, this.symtab);
        setLength(0);

        try
        {
            this.value = localExpression.eval(this.symtab);
            if (this.value > 256)
            {
                this.value = (this.value >>8) & 0xff;
            }
        } 
        catch (SymbolDoesNotExistException localSymbolDoesNotExistException) 
        {
            throw new ParseException(localSymbolDoesNotExistException.getMessage());
        }
        LineContext.directRegister = value;
        // needed in Pass1 otherwise adress mode would not be calced correctly
        
        return true;
    }
}
