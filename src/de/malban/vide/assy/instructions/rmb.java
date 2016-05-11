package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.Symbol;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.expressions.ExpressionList;
import de.malban.vide.assy.expressions.ExpressionSymbol;

public class rmb extends PseudoOp
{
    Expression data;
    ExpressionSymbol symbolExpression=null;
    
    boolean isBSS = false;
    
    public Symbol getSymbol()
    {
        if (symbolExpression!=null)
        {
            return symbolExpression.getSymbol();
        }
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
    public boolean parse(String paramString) throws ParseException
    {
        isBSS =control.currentSegment == Asmj.SEGMENT_BSS;
        data = Expression.parse(paramString, this.symtab);
        if ((data instanceof ExpressionSymbol) && (paramString.contains(",")))
        {
            symbolExpression = (ExpressionSymbol)data;
            // now I am assuming struct!
            paramString = paramString.trim();
            paramString = paramString.substring(symbolExpression.getSymbol().getName().length());
            paramString = paramString.trim();
            paramString = paramString.substring(1); // assuming ","
            paramString = paramString.trim();
            data = Expression.parse(paramString, this.symtab);
        }
        setLength(0);
        int i = 0;
        try 
        {
            i = data.eval(this.symtab);
        } 
        catch (SymbolDoesNotExistException localSymbolDoesNotExistException) 
        {
            throw new ParseException(localSymbolDoesNotExistException.getMessage());
        }

        setLength(i);

        return true;
    }
    public boolean codegen(Memory paramMemory) 
    {
      if (isBSS) return true;
      for (int i = 0; i < this.length; i++) 
      {
          paramMemory.write(this.address + i,0, Memory.MEM_BYTE_DATA);
      }
      return true;
    }

    public boolean generatedCode() { return !isBSS; }
}
