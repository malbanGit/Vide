package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Symbol;
import de.malban.vide.assy.SymbolTable;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.expressions.ExpressionList;
import de.malban.vide.assy.expressions.ExpressionSymbol;



public class struct extends PseudoOp
{
    ExpressionList data;
    int value; // lentgh of struct
    int startPosition;
    Symbol symbol = null;
    
    public int getStartPosition()
    {
        return startPosition;
    }
    public void setSymbolValue(int v)
    {
//        value = v;
        symbol.setValue(v);
    }
    public void defineIt()
    {
        symbol.define(symbol.getValue(), getLineNumber(), source);
    }
    public boolean parse(String paramString) throws ParseException
    {
        startPosition = 0;
        data = (ExpressionList) ExpressionList.parse(paramString, this.symtab);
        if (data.size()<1)
            throw(new ParseException("Struct pseudoop must have a name defined!", true));

        symbol = ((ExpressionSymbol)data.elementAt(0)).getSymbol();
        if (data.size()==2)
        {
            try
            {
                startPosition = ((Expression)data.elementAt(1)).eval(this.symtab, false);
            }
            catch (Throwable e)
            {
                throw(new ParseException("Struct start position can not be parsed: "+paramString+"!", true));
            }
        }
            
        setLength(0);
        return true;
    }
    
    public boolean isStructStart()
    {
        return true;
    }
}
