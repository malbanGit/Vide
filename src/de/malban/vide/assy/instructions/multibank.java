package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.exceptions.ParseException;



public class multibank extends PseudoOp
{
    int value;

    public boolean parse(String paramString) throws ParseException
    {
        setLength(0);
        Expression localExpression = null;
        localExpression = Expression.parse(paramString, this.symtab);


        Asmj.multibank = true;
        
        return true;
    }
}
