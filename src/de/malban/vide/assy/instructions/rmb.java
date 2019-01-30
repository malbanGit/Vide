package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import static de.malban.vide.assy.Asmj.LI_BYTE;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.Symbol;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.expressions.ExpressionList;
import de.malban.vide.assy.expressions.ExpressionSymbol;
import de.malban.vide.dissy.DASM6809;

public class rmb extends PseudoOp
{
    Expression data;
    ExpressionSymbol symbolExpression=null;
    
    boolean isBSS = false;
    byte fillByte = 0;
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
        fillByte = 0;
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
        // hackaty hack Malban
        else
        {
            if (paramString.contains(","))
            {
                // assuming second parameter, this than can be thought oif the filler value for ds
                String param = paramString.substring(paramString.indexOf(",")+1);
                param = param.trim();
                int value = DASM6809.toNumber(param);
                value = value & 0xff;
                fillByte = (byte) value;
            }
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
          paramMemory.write(this.address + i,fillByte, Memory.MEM_BYTE_DATA);
      }
        Asmj.addLineInfo(this.address, this.length, LI_BYTE);
      return true;
    }

    public boolean generatedCode() { return !isBSS; }
}
