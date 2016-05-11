package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.expressions.ExpressionList;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;



public class fcc extends PseudoOp
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
    setLength(this.data.numItems());
    isBSS = Asmj.inBSS;
    return true;
  }
  
  public boolean evalArgs() throws SymbolDoesNotExistException {
    this.data.eval(this.symtab);
    return true;
  }
  
  public boolean codegen(Memory paramMemory) {
    if (isBSS) return true;
    for (int i = 0; i < this.length; i++) {
      paramMemory.write(this.address + i, this.data.getItem(i) & 0xFF, Memory.MEM_CHAR_DATA);
    }
    return true;
  }
  
  public boolean generatedCode() { return true; }
}
