package de.malban.vide.assy.instructions;

import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;



public class org
  extends PseudoOp
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
    } 
    catch (SymbolDoesNotExistException localSymbolDoesNotExistException) 
    {
        throw new ParseException(localSymbolDoesNotExistException.getMessage());
    }
    setLength(this.value - this.address);
    
    return true;
  }
}
