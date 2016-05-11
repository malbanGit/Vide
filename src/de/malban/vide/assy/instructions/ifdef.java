package de.malban.vide.assy.instructions;

import de.malban.vide.assy.expressions.ExpressionSymbol;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.ParseString;





public class ifdef
  extends PseudoOp
{
  boolean condition = false;
  
  public boolean parse(String paramString)
    throws ParseException
  {
    ParseString localParseString = new ParseString(paramString);
    String str = ExpressionSymbol.parseName(localParseString);
    if (!localParseString.endOfExpression()) {
      throw new ParseException("trailing characters");
    }
    setLength(0);
    this.condition = (this.symtab.find(str) != null);
    
    return true;
  }
  
  public boolean isIf() { return true; }
  public boolean getCondition() { return this.condition; }
}
