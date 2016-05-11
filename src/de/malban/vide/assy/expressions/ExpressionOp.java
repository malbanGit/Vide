// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy.expressions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.AsmjDeath;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.ParseString;
import de.malban.vide.assy.Symbol;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.SymbolTable;


public class ExpressionOp extends Expression {
	// these ints are indices into op_tab[] and prec_tab[]
	private static final int
		BEGIN=0,
		MUL=1, DIV=2, MOD=3, ADD=4, SUB=5, LEFT=6, RIGHT=7,
		LE=8, LT=9, GE=10, GT=11, EQ=12, EQ2=13,NE=14,
		AND=15, XOR=16, OR=17,
		END=18;
	// Because we do a first-match sequential search in this array, any
	// op that forms a prefix of another must be listed after the other.
	private static final String op_tab[] = {
		"{", // BEGIN
		"*", "/", "%", "+", "-", "<<", ">>",
		"<=", "<", ">=", ">", "==","=", "!=",
		"&", "^", "|",
		"}"  // END
	};
	// operator precedence
	// higher binds more tightly; equal binds left-to-right
	// precedence is taken from K&R C
	private static final int prec_tab[] = {
		-1, // BEGIN
		13, 13, 13, 12, 12, 11, 11, // MUL DIV MOD ADD SUB LEFT RIGHT
		10, 10, 10, 10, 9, 9, 9,      // LE, LT, GE, GT, EQ, NE
		8, 7, 6,                    // AND, XOR, OR
		0   // END
	};

	// prefix operators denoted by codes >= 100
	private static final int PREFIX_OFFSET = 100;
	private static final int  LOW=PREFIX_OFFSET, HI=LOW+1,NEG=HI+1,NOT=NEG+1, COMP=NOT+1, PLUS=COMP+1, HASH=PLUS+1;
	private static final String prefix_op_tab[] = { "lo", "hi", "-", "!", "~", "+" , "#" }; // hash here, so we are not bothered by expressions like: EQU #$00
//	private static final String prefix_op_tab[] = { "-", "!", "~", "lo", "hi", "+" , "#" }; // hash here, so we are not bothered by expressions like: EQU #$00
 
	
	int op;
	Expression e1, e2;
        public boolean isNumber()
        {
            return e1.isNumber() & e2.isNumber();
        }

	public static ExpressionOp create(
		Expression e1, int op, Expression e2 )
	{
		return new ExpressionOp(e1,op,e2);
	}

	private ExpressionOp( Expression e1, int op, Expression e2 ) {
		this.e1 = e1;
		this.op = op;
		this.e2 = e2;
		sourceStart = e1.sourceStart;
		sourceEnd   = e2.sourceEnd;
	}

	public int eval(SymbolTable t, boolean treatAsZero) throws SymbolDoesNotExistException 
        {
            int n1 = e1.eval(t, treatAsZero);
            int n2 = e2.eval(t, treatAsZero);
            switch ( op ) 
            {
                case MUL:   value = n1 * n2;           break;
                case DIV:   value = n1 / n2;           break;
                case MOD:   value = n1 % n2;           break;
                case ADD:   value = n1 + n2;           break;
                case SUB:   value = n1 - n2;           break;
                case LEFT:  value = n1 << n2;          break;
                case RIGHT: value = n1 >>> n2;         break;
                case LE:    value = (n1 <= n2)? 1 :0;  break;
                case LT:    value = (n1 <  n2)? 1 :0;  break;
                case GE:    value = (n1 >= n2)? 1 :0;  break;
                case GT:    value = (n1 >  n2)? 1 :0;  break;
                case EQ:    value = (n1 == n2)? 1 :0;  break;
                case EQ2:   value = (n1 == n2)? 1 :0;  break;
                case NE:    value = (n1 != n2)? 1 :0;  break;
                case AND:   value = n1 & n2;           break;
                case XOR:   value = n1 ^ n2;           break;
                case OR:    
                    int t1=0;
                    int t2=0;
                    if (Math.abs(n1)<=128) t1 = n1&0xff;
                    else if (Math.abs(n1)<=32768) t1 = n1&0xffff;
                    if (Math.abs(n2)<=128) t2 = n2&0xff;
                    else if (Math.abs(n2)<=32768) t2 = n2&0xffff;
                    
                    value = n1 | n2;           
                
                    break;
                case NEG:   value = -n2;               break;
                case PLUS:  value = +n2;               break; // compatability and symmetry
                case NOT:   value = (n2 == 0)? 1 :0;   break;
                case COMP:  value = ~n2;               break;
                case LOW:   value = n2&0xff;           break;
                case HI:    value = (n2>>8)&0xff;      break;
                case HASH:  
                    value = n2;  
                 //                           Asmj.warning(instr.getSource(), "\"#\" suggests immediate mode, is used as a preorder operand...");
                                                       break;
                default:
                    throw new AsmjDeath( "Asmj bug: no such op: '"+op+"'" );
            }
            return value;
	}                
	public int eval(SymbolTable t) throws SymbolDoesNotExistException 
        {
            return  eval(t, false);
        }
        



	public static Expression parse( String s, SymbolTable st )
		throws ParseException
	{
		return parse( new ParseString(s), st );
	}

	public static Expression parse( ParseString s, SymbolTable st )
		throws ParseException
	{
		Expression exprs[];
		int        opers[];
		int        precs[];
		int i, n;
		
		// System.out.println("  parse_("+s.toString()+")");
		
		exprs = new Expression[128];
		opers = new int[128];
		precs = new int[128];
		n = 0;
		
		exprs[n] = null;
		opers[n] = BEGIN;
		precs[n] = getOpPrecedence(opers[0]);
		n += 1;
		
		while (opers[n-1] != END) 
                {
                    // get the next term, it's trailing operator,
                    // and its precedence
                    s.skipSpaces(); // malban listed values with spaces befor a "sign" were misinterpreted
                    int op = getPrefixOp(s.toString());
                    if (op >= 0) 
                    {
                        // prefix operators will ignore their 1st arg
                        exprs[n] = ExpressionNumber.create(0);
                    } 
                    else 
                    {
                        // no prefix op; get 1st arg & infix op
                        exprs[n] = parseTerm(s,st);
                        Symbol.addUsage(exprs[n], Symbol.SYMBOL_USAGE_EXPRESSION);
                        s.skipSpaces(); // malban listed values with spaces befor a "sign" were misinterpreted
                        op = getOp(s.toString());
                    }
                    if (s.length() > 0 && op >= 0) 
                    {
                        opers[n] = op;
                        s.skip( getOpLength(op) );
                    } 
                    else 
                    {
                        opers[n] = END;
                    }
                    precs[n] = getOpPrecedence(opers[n]);
                    n += 1;

                    // While previous op's precedence >= the next op's,
                    // reduce previous op and its operands to a single term
                    while ( n > 2  &&  precs[n-2] >= precs[n-1] ) 
                    {
                        // reduce previous op/operands
                        exprs[n-2] = ExpressionOp.create( exprs[n-2], opers[n-2], exprs[n-1] );
                        opers[n-2] = opers[n-1];
                        precs[n-2] = precs[n-1];
                        n -= 1;
                    }
		}
		
		return exprs[1];
	}



	private static int getPrefixOp( String s ) 
        {
            int op = arrayIndex(s,prefix_op_tab);
            if (op == LOW-PREFIX_OFFSET)
            {
                // ensure lo is not the begining of a symbol of any kind.
                if (s.length()<=2) return -1;
                if (!de.malban.util.UtilityString.isWordBoundry(s.charAt(2)))return -1;
            }
            if (op == HI-PREFIX_OFFSET)
            {
                // ensure hi is not the begining of a symbol of any kind.
                if (s.length()<=2) return -1;
                if (!de.malban.util.UtilityString.isWordBoundry(s.charAt(2)))return -1;
            }
            return (op >= 0)?  op+PREFIX_OFFSET  : op;
	}

	private static int getOp( String s ) {
		return arrayIndex(s,op_tab);
	}

	private static int getOpLength( int op ) {
		return (op < PREFIX_OFFSET)
			? op_tab[op].length()
			: prefix_op_tab[op-PREFIX_OFFSET].length();
	}

        // malban
        //two prefixes are done in there order given as in the prefix table
        // this way a lo -30 is a lo (-30) instead of a (lo (0) -30)
	private static int getOpPrecedence( int i ) {
//		return (i<PREFIX_OFFSET)? prec_tab[i] :PREFIX_OFFSET;
		return (i<PREFIX_OFFSET)? prec_tab[i] :i;
	}

	private static int arrayIndex( String s, String array[] ) 
        {
            for (int i=0; i<array.length; i++) 
            {
                if (array[i] != null && s.startsWith(array[i])) 
                {
                    return i;
                }
            }
            return -1;
	}

}


