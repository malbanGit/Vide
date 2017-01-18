package de.malban.vide.assy.instructions;

import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.Memory;
import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_UNKOWN;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;




public class end
  extends PseudoOp
{
  Expression value_expr;
  int value;
  boolean isStructEnd = false;
  
  public boolean parse(String paramString)
    throws ParseException
  {
    String str = paramString.trim();
    if (str.length() > 0) 
    {
        if (str.trim().toLowerCase().contains("struct"))
        {
            isStructEnd = true;
            return true;
        }
        this.value_expr = Expression.parse(str, this.symtab);
    }
    return true;
  }
  
  public boolean evalArgs() throws SymbolDoesNotExistException 
  {
        if (this.value_expr != null) 
        {
            this.value_expr.eval(this.symtab);
            this.value = this.value_expr.getValue(2);
        } 
        else
        {
            this.value = 0;
        }
        return true;
  }
  
  public boolean codegen(Memory paramMemory)
  {
    if (isStructEnd()) return true;
    this.symtab.define("*xfer", this.value, this.source.getLineNumber(), null, SYMBOL_DEFINE_UNKOWN, null);
    return true;
  }
  
  public boolean isEnd() 
  { 
      if (source.inputLine.toLowerCase().contains(" struct"))
          return false;
      return true; 
  }
  
  public boolean isStructEnd()
  {
      if (source.inputLine.toLowerCase().contains(" struct")) return true;
      return false;
  }
}
