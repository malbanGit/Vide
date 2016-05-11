package de.malban.vide.assy.instructions;

import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_EQU;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;



public class equ
  extends PseudoOp
{
  Expression value_expr;
  int value;
  
  public boolean parse(String paramString)
    throws ParseException
  {
    if (this.source.label == null) {
      throw new ParseException("missing label");
    }
    this.value_expr = Expression.parse(paramString, this.symtab);
    setLength(0);
    return true;
  }
  
  public boolean evalArgs() throws SymbolDoesNotExistException 
  {
    this.value = this.value_expr.eval(this.symtab);
    this.symtab.define(this.source.label, this.value, this.source.getLineNumber(), this.source.getEndOfLineComment(), SYMBOL_DEFINE_EQU);
    this.source.setEndOfLineCommentProcessed(true);
    return true;
  }
  
  public boolean definesLabel() { return true; }
}
