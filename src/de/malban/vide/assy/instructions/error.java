package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.expressions.ExpressionList;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;



public class error
  extends PseudoOp
{
  Expression data;
  
  public boolean parse(String paramString)
    throws ParseException
  {
    setLength(0);
    this.data = ExpressionList.parse(paramString, this.symtab);
    return true;
  }
  
  public boolean evalArgs() throws SymbolDoesNotExistException {
    this.data.eval(this.symtab);
    int i = this.data.numItems();
    char[] arrayOfChar = new char[i];
    for (int j = 0; j < i; j++) {
      arrayOfChar[j] = ((char)(this.data.getItem(j) & 0xFF));
    }
    String str = new String(arrayOfChar);
    Asmj.error(this.source, str);
    return true;
  }
}
