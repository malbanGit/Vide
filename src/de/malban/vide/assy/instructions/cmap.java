package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Memory;
import de.malban.vide.assy.Symbol;
import de.malban.vide.assy.SymbolTable;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.expressions.ExpressionList;
import de.malban.vide.assy.expressions.ExpressionSymbol;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;



public class cmap extends PseudoOp
{
    Expression data;
    int value; // lentgh of struct
    int startPosition;
    Symbol symbol = null;
    
    HashMap<Character, Character> cmapping = null;
    
    public int getStartPosition()
    {
        return startPosition;
    }
    public void setSymbolValue(int v)
    {
        symbol.setValue(v);
    }
    public void defineIt()
    {
        symbol.define(value, getLineNumber(), source);
    }
    
    public boolean evalArgs() throws SymbolDoesNotExistException
    {
        if (cmapType == RESET)
        {
            // no evaluation of arguments possible or needed!
            return true;
        }
        this.data.eval(this.symtab);
        // build the actual mapping
        
        if (cmapType == EXPRESSION)
        {
            cmapping = new HashMap<Character, Character>();

            int v= data.getValue();
            for (int i=0;i<256; i++)
            {
                cmapping.put(new Character((char)i), (char) v);
            }
        }
        if (cmapType == MAPPING)
        {
            cmapping = new HashMap<Character, Character>();
            
            ExpressionList list = (ExpressionList)data;
            Character startKey =new Character((char)list.getItem(0));

            for (int i=1;i<list.numItems(); i++)
            {
                int v = list.getItem(i);
                cmapping.put(startKey, (char) v);
                startKey++;
            }
        }
        return true;
    }    
    public static int RESET = 0;
    public static int EXPRESSION = 1;
    public static int MAPPING = 2;
    int cmapType = RESET;
    public boolean parse(String paramString) throws ParseException
    {
        // 0 paraemter -> reset
        if (paramString.trim().length() == 0)
        {
            cmapType = RESET;
            cmapping = null;
            return true;
        }
        startPosition = 0;
        data = (ExpressionList) ExpressionList.parse(paramString, this.symtab);
        if (((ExpressionList)data).size() == 1)
        {
            // 1 parameter, set all to that
            cmapType = EXPRESSION;
        }
        else
        {
            // more than one, create a mapping
            cmapType = MAPPING;
        }
        // "create" the mapping in eval 
        
        
        setLength(0);
        return true;
    }
    
    public boolean isCMAP()
    {
        return true;
    }
    public boolean codegen( Memory mem )
    {
        if (cmapType == RESET) 
        {
            control.setCMap(null);
            return true;
        }
        // replace/add in existing mapping
        if (control.getCMap() != null)
        {
            HashMap<Character, Character> otherMapping = control.getCMap();
            HashMap<Character, Character> newMapping = (HashMap<Character, Character>) otherMapping.clone();

            // set or replace with version of this cmap
            Set entries = cmapping.entrySet();
            Iterator it = entries.iterator();
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                Character v = (Character) entry.getValue();
                Character k = (Character) entry.getKey();
                newMapping.put(k, v);
            }
            control.setCMap(newMapping);
            return true;
        }
        control.setCMap(cmapping);
        // befor building the memory statements of FCB, we set the current cmap!
        return true;
    }
}
