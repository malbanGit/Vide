// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.Memory;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.SourceLine;
import de.malban.vide.assy.Symbol;
import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_UNKOWN;
import de.malban.vide.assy.exceptions.SymbolDoesNotExistException;
import de.malban.vide.assy.SymbolTable;
import java.util.Hashtable;

public abstract class Instruction 
{
    int address, length, opcode, opcodelength, datalength;
    SourceLine source;
    Asmj control; // future pseudo-ops may talk to this, eg to set options
    SymbolTable symtab;
    boolean parseOK, evalOK, genOK;
    SymbolDoesNotExistException missingSymbolEx;
    
    // malban _> struct shortcurt
    public void setEvalOk()
    {
        evalOK = true;
        missingSymbolEx = null;
    }
    


    public int getAddress()
    {
        return address;
    }
    // instantiate & return an instance of the appropriate subclass
    public static Instruction create( Asmj asmj, SourceLine p ) 
    {
        Class c;
        Instruction i;

        if (p == null) { return null; }

        i = (Instruction)Asmj.processor.instructionSet.get( p.getOp() );
        if (i == null) 
        {
            Asmj.error( p, "unrecognized opcode '"+p.op+"'" );
            return null;
        }

        i.setControl(asmj);
        i.setSource(p);
        return i;
    }

    public Instruction() {
            length = 0;
            evalOK = parseOK = genOK = false;
            missingSymbolEx = null;
    }

    public Instruction( Instruction i ) 
    {
        address = i.address;
        length = i.length;
        opcode = i.opcode;
        opcodelength = i.opcodelength;
        source = i.source;
        control = i.control;
        evalOK = i.evalOK;
        parseOK = i.parseOK;
        genOK = i.genOK;
        missingSymbolEx = i.missingSymbolEx;
    }

    public SourceLine getSource() { return source; }
    public void setSource( SourceLine p ) { source = p; }

    public Asmj getControl() { return control; }
    public void setControl( Asmj c ) { control = c; }

    private void error( String msg ) { Asmj.error( source, msg ); }

    public int getOpcodeLength() { return opcodelength; }

    public void writeOpcode( Memory mm ) {
            mm.write( address, opcode, opcodelength, true, Memory.MEM_CODE );
    }

    public String getLabel() { return source.getLabel(); }
    public int getLineNumber() { return source.getLineNumber(); }

    // getLength() may return the wrong result if called before parse()
    public int getLength() { return length; }
    public void setLength( int i ) 
    {
        length = i;
        symtab.define( "*", address+i, SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_UNKOWN, null);
    }



    // pass1(), pass2(), and eval() work for almost all instructions,
    // but a very few may have to override them.

    // Pass1 - figure out code size and define symbols.
    // Also cache the symbol table reference for use by setLength().
    public void pass1( int address, SymbolTable st )
    {
        symtab = st;

        // If I need "*", I must set my own length first.
        Symbol star = symtab.find("*");
        if (star != null) { symtab.undefine( star ); }

        this.address = address;
        try 
        { 
            parseOK = parse( source.rest ); 
        }
        catch (ParseException x) 
        {
            Asmj.error( source, x.getMessage() );
        }
        eval();
    }

    // Evaluate arguments, but if we hit an undefined symbol,
    // register for a callback later if/when the symbol becomes defined.
    // This is really part of pass 1, but needs to be callable by
    // itself later.
    public void eval() 
    {
        if (evalOK || !parseOK) { return; }

        try 
        {
            evalOK = evalArgs();
            
            missingSymbolEx = null;
        } 
        catch (SymbolDoesNotExistException x) 
        {
            // look up the undefined symbol
            String name;
            Symbol sym;

            name = x.getItemName();
            if ( name != null &&   (sym = symtab.find(name)) != null ) 
            {
                // This is asking for a callback.
                sym.addUndefinedReference(this);
                missingSymbolEx = x;
            } 
            else 
            {
                Asmj.error( source, x.getMessage() );
            }
        } 
        catch (ParseException x) 
        {
            Asmj.error( source, x.getMessage() );
        }
    }

    // Pass2 - generate code
    public void pass2( Memory mem, SymbolTable st ) 
    {
        // all symbol values should have resolved by now
        if (missingSymbolEx != null) 
        {
            Asmj.error( source, missingSymbolEx.getMessage() );
        }
        if (!evalOK) 
        {
            for (int a=address; a<address+getLength(); a++) 
            {
                mem.write( a, 0, 1, true, Memory.MEM_UNKOWN );
            }
        }
        if (genOK || !evalOK) 
        {
            return;
        }

        genOK = codegen( mem );
    }




    // Most instructions will just override the following abstract
    // methods.


    // Check the line's syntax, set the opcode & length, and save
    // any info needed for the later evaluation of arguments.
    //
    // Return true if parsing succeeded enough for evaluation to work.
    // Generate error messages before returning false.
    public abstract boolean parse( String arg ) throws ParseException;

    // Evaluate arguments as necessary to prepare for code generation.
    // Especially, throw an exception for undefined symbols; will hook
    // into the symbol table to get a callback & re-evaluation if that
    // symbol becomes defined later.
    // This will be called only if parse() succeeds.
    //
    // Return true if the evaluation succeeds enough for code gen to work.
    // Generate error messages before returning false.
    public abstract boolean evalArgs()
            throws SymbolDoesNotExistException, ParseException;

    // Generate code into the memory image.
    // This will be called only if evalArgs() succeeds.
    //
    // Return true if code generation succeeds (enough for ???).
    // Generate error messages before returning false.
    public abstract boolean codegen( Memory mem );


    public int getDataLength() { return datalength; }
    public boolean generatedCode() { return true; }
    public String getRestrictions() { return ""; }
    public boolean isEnd() { return false; }
    public boolean definesLabel() { return false; }

    // recognizers for includes
    public boolean isInclude() { return false; }
    public String includeFilename() throws ParseException { return null; }

    // recognizers for macros
    public boolean isBeginMacro() { return false; }
    public boolean isEndMacro()   { return false; }
    public boolean isExitMacro()  { return false; }
    public String macroName() throws ParseException { return null; }

    // recognizers for conditionals
    public boolean isIf()         { return false; }
    public boolean isElseIf()     { return false; }
    public boolean isElse()       { return false; }
    public boolean isEndIf()      { return false; }
    public boolean getCondition() { return true; }

    
    // recognizer for struct
    public boolean isStructStart(){ return false;}
    public boolean isStructEnd(){ return false;}

    
    public boolean isCMAP() {return false;}
    
}

