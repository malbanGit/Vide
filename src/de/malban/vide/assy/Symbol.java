// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy;


import de.malban.vide.VideConfig;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.expressions.ExpressionSymbol;
import de.malban.vide.assy.instructions.Instruction;
import java.util.Vector;

public class Symbol {
	String name;
        String line_Comment="";
	int value;
	int defining_line; // -1:undefined; -2:not defined by a source line
        int dp_estimate = -1;
        boolean used = false;
        boolean isDefined = false;
        SourceLine source;
        public boolean isUsed ()
        {
            return used;
        }
        
        public static final int SYMBOL_USAGE_UNKOWN = 0;
        public static final int SYMBOL_USAGE_CONSTANT = 1;
        public static final int SYMBOL_USAGE_CONSTANT_8 = 2;
        public static final int SYMBOL_USAGE_CONSTANT_16 = 4;
        public static final int SYMBOL_USAGE_LABEL_16 = 8;
        public static final int SYMBOL_USAGE_LABEL_OFFSET_8 = 16;
        public static final int SYMBOL_USAGE_DIRECT_8 = 32;
        public static final int SYMBOL_USAGE_DIRECT_16 = 64;
        public static final int SYMBOL_USAGE_EXPRESSION = 128;
        
        public static final int SYMBOL_DEFINE_UNKOWN = 0;
        public static final int SYMBOL_DEFINE_EQU = 1;  // in header
        public static final int SYMBOL_DEFINE_CODE = 2; // label
        public static final int SYMBOL_DEFINE_STRUCT = 3; // label
        int definedHow = SYMBOL_DEFINE_UNKOWN;
        
        boolean labelUsage = false;
        public boolean isLabel()
        {
            return labelUsage;
        }
        public boolean isConstant()
        {
            return !labelUsage;
        }
        
        
        int usageType = SYMBOL_USAGE_UNKOWN;
        public int getUsageType()
        {
            return usageType;
        }
        public static void addUsage(Expression offsetExpression, int type, int dp)
        {
            if (offsetExpression != null)
            {
                if (offsetExpression instanceof ExpressionSymbol)
                {
                    ExpressionSymbol es  = (ExpressionSymbol)offsetExpression;
                    Symbol sym = es.getSymbol();
                    if (sym != null)
                    {
                        sym.used=true;
                        if (!sym.labelUsage)
                        {
                            if (sym.definedHow==SYMBOL_DEFINE_CODE)
                            {
                                sym.labelUsage = true;
                            }
                            if ((type & SYMBOL_USAGE_DIRECT_16) == SYMBOL_USAGE_DIRECT_16) sym.labelUsage = true;
                            if ((type & SYMBOL_USAGE_LABEL_16) == SYMBOL_USAGE_LABEL_16) sym.labelUsage = true;
                        }
                        if (((type & SYMBOL_USAGE_DIRECT_8) == SYMBOL_USAGE_DIRECT_8) || ((type & SYMBOL_USAGE_DIRECT_16) == SYMBOL_USAGE_DIRECT_16))
                        {
                            int value = Math.abs(sym.getValue());
                            if (dp != -1)
                            {
                                if (Math.abs(dp & 0xffff) > 256)
                                    sym.dp_estimate = (dp >>8) &0xff;
                                else
                                    sym.dp_estimate = dp & 0xff;
                            }
                            if (value > 256)
                            {
                                sym.dp_estimate = (value >>8) &0xff;
                            }
                        }
                    }
                }
            }
        }
        public static void addUsage(Expression offsetExpression, int type)
        {
            addUsage(offsetExpression, type, -1);
        }
        
        
	Vector /* of Instruction */ undefinedReferences;

	public Symbol( String n ) { this(n,0,-1, null); isDefined = false;}

	public Symbol( String n, int v, int l, SourceLine s ) 
        {
            isDefined = true;
            source = s;
            name = n;
            value = v;
            defining_line = l;
            undefinedReferences = new Vector();
	}

	public String getName() { return name;  }
	public int getValue()   { return value; }
	public void setValue(int v) { value = v; }
	public boolean defined() { return defining_line != -1; }

	public void define( int v, int dl, SourceLine s ) 
        {
            
                if (!name.startsWith("*"))
                {
                    if (VideConfig.getConfig().warnOnDoubleDefine)
                    {
                        if (isDefined)
                        {
                            String w = "Symbol: \""+name+"\" was already defined.";
                            if (s != null)
                                w+=" Source: "+s.fileName+" ("+dl+")";
                            if (source != null)
                                w+=", old define: "+source.fileName+" ("+defining_line+")";
                            Asmj.warning( s, w );
                        }
                    }
                }
            
            
            
            isDefined = true;
            source = s;
//System.out.println(" defined "+name);
            value = v;  
            defining_line = dl;
            int nur = undefinedReferences.size();
            for (int urx=nur-1; urx>=0; urx--) 
            {
                Instruction ur = (Instruction) undefinedReferences.elementAt(urx);
//System.out.println("   re-evaluating line: "+ur.getSource().getInputLine() );
                ur.eval();
                undefinedReferences.removeElementAt(urx);
                labelUsage=true;
                used = true;
            }
	}

	public void addUndefinedReference( Instruction ur ) 
        {
            undefinedReferences.addElement(ur);
//System.out.println(" added ref to "+name+" from: "+ur.getSource().getInputLine());
	}
	public void removeUndefinedReference( Instruction ur ) 
        {
            undefinedReferences.removeElement(ur);
//System.out.println(" added ref to "+name+" from: "+ur.getSource().getInputLine());
	}

}

