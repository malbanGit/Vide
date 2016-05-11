package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.LineContext;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;



public class bank extends PseudoOp
{
    int value;

    public boolean parse(String paramString) throws ParseException
    {
        setLength(0);
        Expression localExpression = null;
        localExpression = Expression.parse(paramString, this.symtab);

        try
        {
            this.value = localExpression.eval(this.symtab);
        } 
        catch (SymbolDoesNotExistException localSymbolDoesNotExistException) 
        {
            throw new ParseException(localSymbolDoesNotExistException.getMessage());
        }

        Asmj.bank = value;
        
        return true;
    }
}
