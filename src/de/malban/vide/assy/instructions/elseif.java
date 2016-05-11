package de.malban.vide.assy.instructions;

import de.malban.vide.VideConfig;
import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;


public class elseif extends PseudoOp
{
  int condition = 0;
  
  public boolean parse(String paramString) throws ParseException 
  {
    Expression localExpression = Expression.parse(paramString, this.symtab);
    setLength(0);
    try 
    { 
        this.condition = localExpression.eval(this.symtab, VideConfig.getConfig().treatUndefinedAsZero);
    }
    catch (SymbolDoesNotExistException localSymbolDoesNotExistException) 
    {
      throw new ParseException(localSymbolDoesNotExistException.getMessage());
    }
    return true;
  }
  
  public boolean isElseIf() { return true; }
  public boolean getCondition() { return this.condition != 0; }
}
