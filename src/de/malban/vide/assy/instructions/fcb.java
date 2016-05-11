package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.expressions.ExpressionList;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.Symbol;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.expressions.ExpressionString;
import de.malban.vide.assy.expressions.ExpressionSymbol;
import java.util.HashMap;



public class fcb extends PseudoOp
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

  // symbols as of now cannot be strings
  boolean isSymbolString(ExpressionSymbol exprS)
  {
      return false;
  }
  boolean isStringItem(int i)
  {
      if (data instanceof ExpressionString) return true;
      if (data instanceof ExpressionList) 
      {
          ExpressionList dList = (ExpressionList)data;
          
          int c=0;
          for (int li=0; li< dList.numItems(); li++)
          {
              Expression expr = dList.listItem(li);
              c+= expr.numItems();
              if (c>i)
              {
                  if (expr instanceof ExpressionString) return true;
                  if (expr instanceof ExpressionSymbol) return isSymbolString((ExpressionSymbol)expr);
                  break;        
              }
          }
      }
      if (data instanceof ExpressionSymbol) return isSymbolString((ExpressionSymbol)data);
      return false;
  }
  
  public int getCMapedItem(int i)
  {
      int value = this.data.getItem(i) & 0xFF;
      if (!isStringItem(i)) return value;
      HashMap<Character, Character> cmaping = control.getCMap();
      if (cmaping != null)
      {
          Character mapped = cmaping.get((char)value);
          if (mapped != null) return mapped;
      }
      
      return value;
  }
  
  public boolean codegen(Memory paramMemory) {
    if (isBSS) return true;
    for (int i = 0; i < this.length; i++) 
    {
        byte mappedItem = (byte)getCMapedItem(i);
        paramMemory.write(this.address + i,mappedItem, Memory.MEM_BYTE_DATA);
//        paramMemory.write(this.address + i, getCMapedItem(i), Memory.MEM_BYTE_DATA);
    }
    return true;
  }
  
  public boolean generatedCode() { return true; }
}
