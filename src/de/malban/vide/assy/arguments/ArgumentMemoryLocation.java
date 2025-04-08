// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class represents an argument in memory.  It is complicated by
// the 6809's orthogonality; the same instruction can address its argument
// by any of several addressing modes.  So we can't tell from the opcode
// which addressing mode to expect, and the parser has to distinguish
// them by pulling apart the argument string itself.  The large number of
// variations of indexed mode don't make this any simpler either...
package de.malban.vide.assy.arguments;

import de.malban.vide.VideConfig;
import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.expressions.ExpressionNumber;
import de.malban.vide.assy.instructions.Instruction;
import de.malban.vide.assy.AsmjDeath;
import de.malban.vide.assy.LineContext;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.ParseString;
import de.malban.vide.assy.Register;
import de.malban.vide.assy.RegisterSet;
import de.malban.vide.assy.Symbol;
import de.malban.vide.assy.SymbolTable;
import de.malban.vide.assy.instructions.InstructionGroup;

public class ArgumentMemoryLocation extends Argument6809 
{

    public Expression offsetExpression; // holds the numeric Expression

    // offset means different things in different modes:
    //  IMMEDIATE              - the value
    //  DIRECT                 - the address
    //  EXTENDED               - the address
    //  INDEXED/constantOffset - amount added to the index register
    //  INDEXED/registerOffset - n/a (use offsetReg instead)
    //  INDEXED/autoincrement  - the amount of the increment/decrement
    int offset;
    public int getOffset()
    {
        return offset;
    }

    // mode == INDEXED_MODE:
    // Note that exactly one of the following must be true:
    //    constantOffset, registerOffset, autoincrement
    // PCR addressing is treated as constant offset from RegisterSet.pc .
    // 16-bit indirect is treated as constant offset from null.
    boolean constantOffset, registerOffset, autoincrement, // one is true
            indirect, reallyShort, prettyShort;

    boolean force16bit = false;
    boolean force8bit = false;
    boolean force5bit = false;
    boolean force0bit = false;

    // num_postbytes tells how many bytes follow the opcode
    int num_postbytes;
    // register tells which register is used as the base index
    Register register, offsetReg;



    public int getNumPostbytes()  { return num_postbytes; }



    public ArgumentMemoryLocation( String s, SymbolTable st,
            Instruction instr )
            throws ParseException
    {
        this( new ParseString(s), st, instr );
    }

    boolean correctStartWithIndexRegister(ParseString s, Instruction instr)
    {
        int len =0;
        String reg = "";
        String l = s.getCurrentString();
        int startInsert = 0;
        if (l.startsWith("["))
        {
            l = l.substring(1);
            startInsert = 1;
        }
        if (l.startsWith("-"))
        {
            l = l.substring(1);
//            startInsert++;
        }
        if (l.startsWith("-"))
        {
            l = l.substring(1);
//            startInsert++;
        }
        
        if (l.toLowerCase().trim().startsWith("y"))
        {
            reg = "y";
            len = 1;
        }
        else if (l.toLowerCase().trim().startsWith("x"))
        {
            reg = "x";
            len = 1;
        }
        else if (l.toLowerCase().trim().startsWith("s"))
        {
            reg = "s";
            len = 1;
        }
        else if (l.toLowerCase().trim().startsWith("u"))
        {
            reg = "u";
            len = 1;
        }
        else if (l.toLowerCase().trim().startsWith("pcr"))
        {
            reg = "pcr";
            len = 3;
        }
        else if (l.toLowerCase().trim().startsWith("pc"))
        {
            reg = "pc";
            len = 2;
        }
        if (len == 0) return false;
        String rest = l.substring(len);

        if (rest.length()>0)
            if (de.malban.util.UtilityString.isAlphaNumeric(rest.charAt(0))) return false; // it is a lable rather than a reg

        // replace index register with "," register
        s.insert(startInsert, ",");
        Asmj.warning(instr.getSource(), "Indexed addressing without \",\" found - inserted!");
        return true;
    }
    
    public ArgumentMemoryLocation( ParseString s, SymbolTable st,
            Instruction instr )
            throws ParseException
    {
        char ch;
        boolean regSymbolExists;
        boolean forceDirect = false;
        boolean forceExtended = false;

//if (            instr.getSource().getLineNumber() == 55)
//System.out.println("Buh");

        mode = UNKNOWN_MODE;
        register = null;
        reallyShort = prettyShort = indirect = false;
        constantOffset = registerOffset = autoincrement = false;
        num_postbytes = 1;

        correctStartWithIndexRegister(s, instr);
        
        
        
        if ((s.toString().contains("+")) && (s.toString().contains(",")))
        {
            if (s.toString().startsWith("0"))
            {
                s.skip("0");
                Asmj.warning(instr.getSource(), "0 offset with increment found, 0 removed!");
            }
        }
        if ((s.toString().contains("-")) && (s.toString().contains(",")))
        {
            if (s.toString().startsWith("0"))
            {
                s.skip("0");
                Asmj.warning(instr.getSource(), "0 offset with decrement found, 0 removed!");
            }
        }
        
        if (s.startsWith("#")) 
        {
            mode = checkMode( instr, mode, IMMEDIATE_MODE );
            s.skip(1);
            if (mode!=UNKNOWN_MODE) // malban: immediate mode was cancled in checkmode
            {
                offsetExpression = Expression.parse(s,st);
                Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_CONSTANT);
                parseEndOfExpression(s);
                return;

            }
        }
        if (s.toString().contains(","))
        {
            if (s.startsWith("<<")) 
            {
                mode = checkMode( instr, mode, INDEXED_MODE );
                reallyShort = true;
                force5bit=true;
                // System.out.println("  reallyShort");
                s.skip(2);
                Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_CONSTANT_8|Symbol.SYMBOL_USAGE_LABEL_OFFSET_8);
            } 
            else if (s.startsWith("<")) 
            {
                mode = checkMode( instr, mode, INDEXED_MODE );
                prettyShort = true;
                force8bit=true;
                // System.out.println("  prettyShort");
                s.skip(1);
                Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_CONSTANT_8|Symbol.SYMBOL_USAGE_LABEL_OFFSET_8);
            } 
            else if (s.startsWith(">")) 
            {
                mode = checkMode( instr, mode, INDEXED_MODE );
                force16bit=true;
                prettyShort = false;
                reallyShort = false;
                // System.out.println("  16 bit");
                s.skip(1);
                Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_CONSTANT_16|Symbol.SYMBOL_USAGE_LABEL_16);
            }
        }
        else
        {
            if (s.startsWith("<")) 
            {
                mode = checkMode( instr, mode, DIRECT_MODE );
                prettyShort = true;
                forceDirect = true;
                s.skip(1);
            }
        }

        if (s.startsWith(">")) 
        {
        //    mode = checkMode( instr, mode, EXTENDED_MODE );
          // fall through to extended mode
            forceExtended = true;
            s.skip(1);
            Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_CONSTANT_16|Symbol.SYMBOL_USAGE_LABEL_16);
        }

        if (s.startsWith("[")) 
        {
            mode = checkMode( instr, mode, INDEXED_MODE );
            indirect = true;
            // disallow really-short indirect addressing
            // System.out.println("  indirect");
            s.skip(1);
            if (reallyShort) 
            {
                reallyShort = false;
                prettyShort = true;
                if (force5bit)
                {
                    force5bit = false;
                    force8bit = true;
                }
            }
            if (s.startsWith(">")) 
            {
                reallyShort = false;
                prettyShort = false;
                force16bit = true;
                Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_CONSTANT_16|Symbol.SYMBOL_USAGE_LABEL_16);
                s.skip(1);
            }
            if (s.startsWith("<<")) 
            {
                reallyShort = false;
                prettyShort = true;
                force8bit = true;
                s.skip(2);
                Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_CONSTANT_8|Symbol.SYMBOL_USAGE_LABEL_OFFSET_8);
            }
            if (s.startsWith("<")) 
            {
                reallyShort = false;
                prettyShort = true;
                force8bit = true;
                s.skip(1);
                Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_CONSTANT_8|Symbol.SYMBOL_USAGE_LABEL_OFFSET_8);
            }
        }

        // Expression.parse() would treat a/b/d as a symbol, and
        // even define such a symbol if there wasn't already one.
        // We parse those specially, then leave offsetExpression null.
        int p0 = s.getPosition();
        offsetReg = RegisterSet.parseReg( s, "", RegisterSet.OFFSET_ENCODING );
        
        if ( offsetReg != null ) 
        {
            if (s.charAt(0) == ',') 
            {
                registerOffset = true;
                // Expression.parse() will fail at comma
            } 
            else 
            {
                // not register offset; backtrack
                s.setPosition(p0);
                offsetReg = null;
            }
        }

        try 
        {
            offsetExpression = Expression.parse(s,st);
            
            constantOffset = true;
        } 
        catch (ParseException x) 
        {
            if ( ! x.isSevere() ) { throw x; }
            offsetExpression = null;
            // System.out.println("  null offsetExpression");
        }



        // shouldn't we use parseReg() to recognize "dp"?
        if ( s.toLowerCase().startsWith(",dp") ) 
        {
            // System.out.println("  DIRECT_MODE");
            mode = checkMode( instr, mode, DIRECT_MODE );

            int dp  = LineContext.directRegister;
            if (instr.getSource().getDP() != -1)
            {
                dp = instr.getSource().getDP();
            }
            else
            {
                if (dp != -1) 
                {
                    instr.getSource().setDP(dp);
                }
            }


            Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_DIRECT_8, dp);
            s.skip(3);
            parseEndOfExpression(s);
            return;
        }

        if ( s.startsWith("]") ) 
        {
            // 16-bit indirect
            // System.out.println("  16-bit indirect");
            if ( mode != INDEXED_MODE || ! indirect ) 
            {
                throw new ParseException("unexpected ']'");
            }
            constantOffset = true;
            register = null;
            Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_LABEL_16);
            s.skip(1);
            parseEndOfExpression(s);
            num_postbytes += 2;
            return;
        }


        if ( ! s.startsWith(",") ) 
        {
            // checking DP
            if ((offsetExpression != null) && (!forceExtended))
            {
              if (LineContext.directRegister != -1)
                {
                    int knownDP = LineContext.directRegister;

                    // try to evaluate expo
                    // if it succeeds, we can set the correct DP
                    // because the value will be set!
                    try
                    {
                        offset = offsetExpression.eval(st);                            
                    }
                    catch (Throwable e)
                    {
                    }


                    if ((((offsetExpression.getValue()>>8) == knownDP) || 
                            ( ((offsetExpression.getValue()&0xff) == offsetExpression.getValue()) && (mode == DIRECT_MODE)) 
                            ) || (forceDirect))
                    {

                        boolean doIt = true;
                        if (VideConfig.getConfig().excludeJumpsToDirect)
                        {
                            if (instr instanceof InstructionGroup)
                            {
                                InstructionGroup ig = (InstructionGroup) instr;
                                if (ig.getMnemonic().toLowerCase().equals("jmp")) doIt = false;
                                if (ig.getMnemonic().toLowerCase().equals("jsr")) doIt = false;
                            }
                        }

                        if (doIt)
                        {
                            // optimize extended to DP, since DP is set!
                            mode = checkMode( instr, mode, DIRECT_MODE );

                            int dp  = LineContext.directRegister;
                            if (instr.getSource().getDP() != -1)
                            {
                                dp = instr.getSource().getDP();
                            }
                            else
                            {
                                if (dp != -1) 
                                {
                                    instr.getSource().setDP(dp);
                                }
                            }


                            Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_DIRECT_16, dp);
                            parseEndOfExpression(s);
                            return;                            
                        }
                    }
                }
            }

            // System.out.println("  EXTENDED_MODE");
            if ((offsetExpression != null) && (!forceDirect))
            {
                int v = offsetExpression.getValue();
                if ((v & 0xffff) < 256)
                {
                    if (VideConfig.getConfig().enable8bitExtendedToDirect)
                    {
                        boolean doIt = true;
                        if (VideConfig.getConfig().excludeJumpsToDirect)
                        {
                            if (instr instanceof InstructionGroup)
                            {
                                InstructionGroup ig = (InstructionGroup) instr;
                                if (ig.getMnemonic().toLowerCase().equals("jmp")) doIt = false;
                                if (ig.getMnemonic().toLowerCase().equals("jsr")) doIt = false;
                            }
                        }

                        if (doIt)
                        {
                            mode = checkMode( instr, mode, DIRECT_MODE );

                            if (mode == DIRECT_MODE)
                            {
                                Asmj.warning(instr.getSource(), "8bit extended addressing found, changing to direct addressing!");
                                forceDirect = true;
                                Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_DIRECT_8);
                            }
                        }

                    }
                }
            }

            if (!((mode == DIRECT_MODE) && (forceDirect)))
                mode = checkMode( instr, mode, EXTENDED_MODE );
            if (offsetExpression == null) 
            {
                throw new ParseException("missing argument");
            }
            Symbol.addUsage(offsetExpression, Symbol.SYMBOL_USAGE_LABEL_16);
            parseEndOfExpression(s);
            return;
        }
        
        // s.startsWith(",")
        s.skip(1);
        s.skipSpaces();
        mode = checkMode( instr, mode, INDEXED_MODE );
        // System.out.println("  INDEXED_MODE");

        String pcr = s.nextSymbol();
        if (pcr != null && pcr.equals("pcr")) 
        {
            // PC relative
            // System.out.println("  PC relative");
            constantOffset = true;
            register = RegisterSet.pc;
            s.skip(3);
        } // malban
        else if (pcr != null && pcr.equals("pc")) 
        {
            // PC relative
            // System.out.println("  PC relative");
            constantOffset = true;
            register = RegisterSet.pc;
            s.skip(2);
        } 
        else 
        {

            if ( s.startsWith("-") ) 
            {
                autoincrement = true;
                offset = s.startsWith("--")?  2  : 1;
                //System.out.println("  autodecrement "+offset);
                s.skip(offset);
                offset = - offset; // decrement
            }

            register = RegisterSet.parseReg( s, instr.getRestrictions(), RegisterSet.INDEX_ENCODING );
            if ( register == null ) 
            {
                throw new ParseException( "illegal index register" );
            }
            //System.out.println("  register "+register.getName());

            if (s.startsWith("+")) 
            {
                if (autoincrement) 
                {
                    throw new ParseException( "Cannot have both autoincrement" + " and autodecrement" );
                }
                autoincrement = true;
                offset = s.startsWith("++")?  2  : 1;
                //System.out.println("  autoincrement "+offset);
                s.skip(offset);
            }

            // An ommitted constant offset is 0.
            if ( ! autoincrement &&   ! registerOffset &&   offsetExpression == null ) 
            {
                // System.out.println("  ommitted offset = 0");
                offsetExpression = ExpressionNumber.create(0);
                constantOffset = true;
            }
        }

        if (indirect) 
        {
            if ( ! s.startsWith("]") ) 
            {
                throw new ParseException("missing ']'");
            }
            s.skip(1);
        }

        parseEndOfExpression(s);
        // adjust offset length
        if ( constantOffset ) 
        {
            // Decide on length based on the value.
            try 
            {
                // throws SymbolDoesNotExistException
                if (offsetExpression == null) 
                {
                    throw new SymbolDoesNotExistException( "invalid offset expression");
                }

                int x = offsetExpression.eval(st);
                if (register==RegisterSet.pc) 
                {
                    if (x >= -128 && x <= 127) 
                    {
                        prettyShort = true;
                    }
                    // Suppose 8-bit offset; if target is
                    // close enough, we'll get prettyShort
                    // adressing.
                    int pc = instr.getAddress() + instr.getOpcodeLength() + 2; // postbyte + 8-bit offset
                    x -= pc;
                }
                // x is a 16-bit int; sign extend to full int
                if (x > 32767) { x -= 65536; }
                if (x == 0 && register!=RegisterSet.pc) 
                {
                    reallyShort = true;
                } 
                else if (x >= -16 && x <= 15  &&  !indirect && register!=RegisterSet.pc) 
                {
                    reallyShort = true;
                } 
                else if ((x >= -128 && x <= 127) && register!=RegisterSet.pc) 
                {
                    prettyShort = true;
                }
            } 
            catch (SymbolDoesNotExistException x) 
            {
                // Cannot evaluate offset yet;
                // cannot infer shorter length.
                if ((!reallyShort) && (!force8bit) && (!force16bit) && (!prettyShort))
                    Asmj.warning(instr.getSource(), "Symbol with undefined size found, using 16bit per default - can be perhaps manually be shortend!");
            }

            if ((force8bit) && (reallyShort)) 
            {
                reallyShort = false;
                prettyShort = true;
            }
            if ((force16bit) && (reallyShort)) 
            {
                reallyShort = false;
                prettyShort = false;
            }
            if ((force16bit) && (prettyShort)) 
            {
                reallyShort = false;
                prettyShort = false;
            }

            num_postbytes += reallyShort? 0 : prettyShort? 1 : 2;
        }


        // Sanity checking

        // Must have exactly one kind of indexing
        if ( (registerOffset? 1 :0) + (constantOffset? 1 :0) + (autoincrement?  1 :0) != 1 ) 
        {
            throw new ParseException( "ambiguous indexed mode" );
        }

        // Cannot force short offset with 16-bit PCR,
        // autoincrement, or register-offset addressing
        if ( (reallyShort || prettyShort)
        &&   (	(indirect && register==null) // unreachable
                || autoincrement
                || registerOffset )
        ) 
        {
            throw new ParseException( "illegal short addressing" );
        }
    }

    // Make sure it will be okay to use mode m1 with instruction instr,
    // when its mode is already set to m0.  If okay, return mode m1;
    // otherwise throw an exception.
    private int checkMode( Instruction instr, int m0, int m1 ) throws ParseException
    {
        String r = null;

        String n0 = modeName[m0], n1 = modeName[m1];

        if (m0 != UNKNOWN_MODE && m0 != m1)
        {
            throw new ParseException("ambiguous mode "+n0+"::"+n1);
        }
        switch (m1) 
        {
            case IMMEDIATE_MODE: r = "i"; break;
            case INDEXED_MODE:   r = "x"; break;
            case DIRECT_MODE:    r = "d"; break;
            case EXTENDED_MODE:  r = "e"; break;
        }
        if ( r != null &&   instr.getRestrictions().indexOf(r) >= 0) 
        {
            if (VideConfig.getConfig().beLaxWithHashTagAndImmediate)
            {
                if ((m1 == IMMEDIATE_MODE) && (m0==UNKNOWN_MODE))
                {
                    // Malban: returning unkown and not
                    // throwing an exception
                    // skips the "#" and continues
                    // parsing
                    // than everything should work out
                    // for indexed addressing
                    Asmj.warning(instr.getSource(), "\"#\" suggests immediate mode, but instruction does not allow immediate...");
                    return UNKNOWN_MODE;
                }
            }
            throw new ParseException("bad mode - cannot be "+n1);
        }

        return m1;
    }


    // If there was an expression involved, try to evaluate it.
    // This may be called repeatedly, if symbols that are not defined
    // at first become defined later.
    public void eval( SymbolTable st ) throws SymbolDoesNotExistException {
            if (offsetExpression != null) {
                    offset = offsetExpression.eval(st);
            }
            // System.out.println("  offset "+offset);
    }

    public void codegen( Memory mm, SymbolTable st, int address, int len ) 
    {
        int pb1, pb2, pb3;
        if (mode == IMMEDIATE_MODE) {
                // System.out.println("  IMMEDIATE_MODE");
                mm.write( address, offset, len, true, Memory.MEM_CODE_POSTBYTE );

        } else if (mode == DIRECT_MODE) {
                // System.out.println("  DIRECT_MODE");
                mm.write( address, offset & 255, Memory.MEM_CODE_POSTBYTE );

        } else if (mode == EXTENDED_MODE) {
                // System.out.println("  EXTENDED_MODE");
                mm.write( address, offset, 2, true, Memory.MEM_CODE_POSTBYTE );

        } 
        else if (mode == INDEXED_MODE) 
        {
            // System.out.println("  INDEXED_MODE");
            pb1 = 0x80;

            if (indirect)     { pb1 |= 0x10; }

            if (register != null) {
                pb1 |= register.getCode( RegisterSet.INDEX_ENCODING );
            }

            if (constantOffset) 
            {
                // System.out.println("  constantOffset");
                if (register == RegisterSet.pc) 
                {
                    int pc = st.getValue("*");

                    // WHY? malban
                    // should a constant offset to the PC 
                    // be changed here????
//                                        offset -= pc;
                }
                if (reallyShort) 
                {
                    // no postbyte; offset==0 is special
                    if ( offset == 0 ) 
                    {
                        // sta <<$00,x ; explicit 5 bit CAST
                        if (force5bit)
                        {
                            pb1 &= 0x60;
                            pb1 |= offset & 0x1f;
                        }
                        else
                            pb1 |= 0x04;
                    } 
                    else 
                    {
                        pb1 &= 0x60;
                        pb1 |= offset & 0x1f;
                    }
                    mm.write( address, pb1, Memory.MEM_CODE_POSTBYTE );
                } else if (prettyShort) {
                    // This is sneaky.  If PCR, this
                    // harmlessly re-asserts the 08 bit
                    // that is already in pb1.  Else,
                    // it designates an 8-bit offset...
                    pb1 |= 0x08;
                    mm.write( address, pb1, Memory.MEM_CODE_POSTBYTE );
                    mm.write( address+1, offset & 255, Memory.MEM_CODE_POSTBYTE );
                } 
                else 
                {
                    // This is sneaky too.  Both PCR
                    // and other constant 16-bit offsets
                    // use the 01 bit; If PCR, this
                    // harmlessly re-asserts the 08 bit,
                    // else it designates a 16-bit offset...
                    pb1 |= 0x09;
                    if (register == null) 
                    {
                            // 16-bit indirect addressing
                            pb1 |= 0x0f;
                    }
                    mm.write( address, pb1, Memory.MEM_CODE_POSTBYTE );
                    mm.write( address+1, offset, 2, true, Memory.MEM_CODE_POSTBYTE );
                }

            } else if (registerOffset) 
            {
                // System.out.println("  registerOffset");
                pb1 |= offsetReg.getCode(
                        RegisterSet.OFFSET_ENCODING );
                // System.out.println("  pb1="+pb1);
                mm.write( address, pb1, Memory.MEM_CODE_POSTBYTE );
            } else if (autoincrement) 
            {
                // System.out.println("  autoincrement");
                switch (offset) 
                {
                        case 1:   pb1 |= 0x00;   break;
                        case 2:   pb1 |= 0x01;   break;
                        case -1:  pb1 |= 0x02;   break;
                        case -2:  pb1 |= 0x03;   break;
                }
                mm.write( address, pb1 , Memory.MEM_CODE_POSTBYTE);
            } 
            else 
            {
                // sanity check failed -
                // this can happen only if asmj has a bug
                throw new AsmjDeath(
                        "Asmj bug: unrecognized indexed mode"
                );
            }
        }

    }

}

