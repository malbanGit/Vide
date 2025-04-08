package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.LineContext;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.expressions.ExpressionString;



public class version extends PseudoOp
{
    String value="";

    public boolean parse(String paramString) throws ParseException
    {
        setLength(0);
        Expression localExpression = null;
        localExpression = ExpressionString.parse(this.source.rest, null, true);

        value = ((ExpressionString)localExpression).getString();;
        Asmj.version = value;
        return true;
    }
    
    public String getVersion()
    {
        return value;
    }
}
