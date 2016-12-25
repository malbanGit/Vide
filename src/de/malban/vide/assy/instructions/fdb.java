package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import static de.malban.vide.assy.Asmj.LI_WORD;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.expressions.ExpressionList;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.Symbol;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.expressions.ExpressionSymbol;



public class fdb
  extends PseudoOp
{
  Expression data;
  boolean isBSS = false;
  public void setBSS(boolean b)
  {
      isBSS = b;
  }
  
  public boolean parse(String paramString)
    throws ParseException
  {
    this.data = ExpressionList.parse(paramString, this.symtab);
    setLength(this.data.numItems() * 2);
    isBSS = Asmj.inBSS;
    
    return true;
  }
  public Symbol getSymbol()
  {
      if (data instanceof ExpressionSymbol)
      {
          ExpressionSymbol  sdata = (ExpressionSymbol)data;
          return sdata.getSymbol();
      }
      if (data instanceof ExpressionList)
      {
          ExpressionList  ldata = (ExpressionList)data;
          if (ldata.size()>0)
          {
                if (ldata.elementAt(0) instanceof ExpressionSymbol)
                {
                    ExpressionSymbol  sdata = (ExpressionSymbol)ldata.elementAt(0);
                    return sdata.getSymbol();
                }
          }
      }
      return null;
  }
  
  public boolean evalArgs() throws SymbolDoesNotExistException {
    this.data.eval(this.symtab);
    return true;
  }
  
  public boolean codegen(Memory paramMemory) {
    int i = this.data.numItems();
    if (isBSS) return true;
    
    for (int j = 0; j < i; j++) {
      paramMemory.write(this.address + 2 * j, this.data.getItem(j), 2, true, Memory.MEM_WORD_DATA);
    }
    Asmj.addLineInfo(this.address, i*2, LI_WORD);
    return true;
  }
  
  public boolean generatedCode() { return true; }
}
