// see: http://sourceforge.net/projects/asmj/
// http://asmj.sourceforge.net/
// http://asmj.sourceforge.net/doc/syntax.html
// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This is the 'main' program for asmj.
//
// It expects command-line arguments: the name of a source file, and
// some optional flags.
//
// By default, it generates a binary file with the same base name,
// and ".bin" appended.  (If the source file name ends in ".asm",
// then the base name is the source file name with the ".asm" removed.
// Otherwise the base name is exactly the same as the source file name.)
package de.malban.vide.assy;

/*
Labels are identifies while building a SourceLine Object (in the cosnstructor
*/

import de.malban.vide.VideConfig;
import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_CODE;
import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_EQU;
import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_STRUCT;
import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_UNKOWN;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.expressions.ExpressionSymbol;
import de.malban.vide.assy.expressions.ExpressionNumber;
import de.malban.vide.assy.instructions.Instruction;
import de.malban.vide.assy.instructions.fcb;
import de.malban.vide.assy.instructions.fdb;
import de.malban.vide.assy.instructions.rmb;
import de.malban.vide.assy.instructions.struct;
import java.io.File;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.IOException;
import java.io.LineNumberReader;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Vector;

public class Asmj {
    VideConfig config = VideConfig.getConfig();

    public static final int MAX_MACRO_DEPTH = 65536;
    public static ProcessorDependencies processor;

    public static int bank = 0;
    public static boolean inBSS = false;
    public static String currentBaseDir="";
    
    public static final int SEGMENT_CODE = 0;
    public static final int SEGMENT_DATA = 1;
    public static final int SEGMENT_BSS = 2;
    public int currentSegment = SEGMENT_CODE;
    public int currentCodeOrg =0;
    public int currentBSSOrg =0;
    public int currentDataOrg =0;
    private int globalAddress = 0;

    public int getGlobalAddress()
    {
        return globalAddress;
    }
    public void switchSegment(int newSegment)
    {
        if (currentSegment==SEGMENT_CODE)
        {
            currentCodeOrg = globalAddress;
        }
        if (currentSegment==SEGMENT_DATA)
        {
            currentDataOrg = globalAddress;
        }
        if (currentSegment==SEGMENT_BSS)
        {
            currentBSSOrg = globalAddress;
        }
        currentSegment = newSegment;
        if (currentSegment == SEGMENT_BSS)
        {
            globalAddress = currentBSSOrg;
            inBSS = true;
        }
        if (currentSegment == SEGMENT_DATA)
        {
            globalAddress = currentDataOrg;
            inBSS = false;
        }
        if (currentSegment == SEGMENT_CODE)
        {
            globalAddress = currentCodeOrg;
            inBSS = false;
        }
    }
    
    
    PrintStream ps_error;
    PrintStream ps_info;
    PrintStream ps_listing;
    PrintStream ps_symtab;
    OutputStream ps_error_add=null;
    OutputStream ps_info_add=null;
    OutputStream ps_listing_add=null;
    OutputStream ps_symtab_add=null;
    StringBuffer symtabString=new StringBuffer();
    StringBuffer errorString=new StringBuffer();
    StringBuffer  infoString=new StringBuffer();
    StringBuffer  listingString=new StringBuffer();
    public String getError()
    {
        String error = errorString.toString();
        errorString.delete(0, errorString.length());
        return error;
    }
    public String getInfo()
    {
        String infoS = infoString.toString();
        infoString.delete(0, infoString.length());
        return infoS;
    }
    public String getListing()
    {
        String listingS = listingString.toString();
        listingString.delete(0, listingString.length());
        return listingS;
    }
    public String getSymtab()
    {
        String s = symtabString.toString();
        symtabString.delete(0, symtabString.length());
        return s;
    }
    void initStreams()
    {
        ps_symtab = new PrintStream(
            new OutputStream()
            {
              @Override
              public void write( int b )
              {
                  char[] c = {(char)b};
                  String s = new String(c);
                  symtabString.append(s);
                  try { if (ps_symtab_add!=null)ps_symtab_add.write(b); } catch (Throwable e){}
              }
            }
          );
        ps_error = new PrintStream(
            new OutputStream()
            {
              @Override
              public void write( int b )
              {
                  char[] c = {(char)b};
                  String s = new String(c);
                  errorString.append(s);
                  try { if (ps_error_add!=null)ps_error_add.write(b); } catch (Throwable e){}
              }
            }
          );
        ps_listing = new PrintStream(
            new OutputStream()
            {
              @Override
              public void write( int b )
              {
                  char[] c = {(char)b};
                  String s = new String(c);
                  listingString.append(s);
                  try { if (ps_listing_add!=null)ps_listing_add.write(b); } catch (Throwable e){}
              }
            }
          );        
        ps_info = new PrintStream(
            new OutputStream()
            {
              @Override
              public void write( int b )
              {
                  char[] c = {(char)b};
                  String s = new String(c);
                  infoString.append(s);
                  try { if (ps_info_add!=null)ps_info_add.write(b); } catch (Throwable e){}
              }
            }
          );        
    }
    String mainFile = "";
    public Asmj( String filename, OutputStream errOut, OutputStream listOut, OutputStream symOut, OutputStream infoOut , String defines) 
    {
        mainFile = filename;
        ps_error_add=errOut;
        ps_info_add=infoOut;
        ps_listing_add=listOut;
        ps_symtab_add=symOut;
        bank = 0;
        initStreams();
        
        SymbolTable symtab;
        Memory image;
        initProcessor();

        Option opt_e = new Option("e",true,null);  // errors
        opt_e.stream = ps_error;
        
        
        Option opt_l = new Option("l",true,null);   // listing
        opt_l.stream = ps_listing;
        
        Option opt_t = new Option("t",true,null);   // symbol table
        opt_t.stream = ps_symtab;
        Option opt_f = new Option("f",true,null);   // input file
                opt_f.unique = false;
                opt_f.valueNeeded = true;
                opt_f.negativeValueOK = true;
                
        Option opt_b = new Option("b",true,null);   // output binary
        Option opt_s = new Option("s",false,null);  // output s-records
        Option opt_D = new Option("D",false,null);  // definition
                opt_D.unique = false;
                opt_D.valueNeeded = true;
                opt_D.negativeValueOK = true;

        symtab = new SymbolTable();
        image = new Memory();

        // Parse the command-line
        // Keep track of input filenames in the order we hit them,
        // whether as part of a "-f" option or not.
        Vector /* of String */ inputFilenames = new Vector();
        Vector<String> definitions = new Vector<String>();
        String[] defs = defines.split(";");
        for (String d : defs)
            definitions.addElement( d);
        inputFilenames.addElement( filename );
        if (inputFilenames.size() == 0) 
        {
            ps_error.println("No input file given - aborting!");
            return;
        }

        // build the array of streams and filenames
        int size = inputFilenames.size();
        LineNumberReader inputs[] = new LineNumberReader[ size ];
        String filenames[] = new String[ size ];
        String lastInputFile = null;
        for (int i=0; i<size; i++) {
            String f = (String)inputFilenames.elementAt(i);
            filenames[i] = f;
            try { inputs[i] = DynamicFile.getLineNumberReader(f); }
            catch (IOException x) { die(x); }
            lastInputFile = f;
        }

        // build the array of external symbols and their definitions
        size = definitions.size();
        String symbols[] = new String[ size ];
        int    values[]  = new int[ size ];
        for (int i=0; i<size; i++) {
            String d = (String)definitions.elementAt(i);
            int p = d.indexOf("=");
            if (p==0) { die("missing symbol name in '"+d+"'"); }
            values[i] = 0;
            if (p<0) {
                    symbols[i] = d;
            } else {
                symbols[i] = d.substring(0,p);
                try {
                        String vs = d.substring(p+1);
                        values[i] = ExpressionNumber.eval(vs);
                } catch (ParseException x) { die(x); }
            }
        }
        
        
        // figure out the default output base filename
        String baseFilename = lastInputFile;
        
        Path p = Paths.get(baseFilename);
        currentBaseDir = p.getParent().toString();
        
        if ( baseFilename.toLowerCase().endsWith(".asm") ) {
            // drop the ".asm" extension
            baseFilename = baseFilename .substring( 0, baseFilename.length()-4 );
        }
        else
        {
            int li = baseFilename.lastIndexOf(".");
            if (li>=0) 
                baseFilename = baseFilename.substring(0,li);
        }

        opt_b.default_value = baseFilename + ".bin";
        opt_s.default_value = baseFilename + ".s19";

        try {
            OutputStream binary_stream  = opt_b.getOutputStream();
            PrintStream  srecord_stream = opt_s.getPrintStream();
            PrintStream  listing_stream = (PrintStream)opt_l.stream;
            PrintStream  error_stream   = (PrintStream)opt_e.stream;
            PrintStream  symtab_stream  = (PrintStream)opt_t.stream;

            assemble( inputs, filenames,
                    binary_stream, srecord_stream,
                    listing_stream, error_stream, symtab_stream,
                    symbols, values
            );

            
            opt_b.closeStream();
            opt_s.closeStream();
            opt_l.closeStream();
            opt_e.closeStream();
            opt_t.closeStream();

        } catch (IOException x) {
                die(x);
        }
    }
    
    
     
    public Asmj( String argv[] ) 
    {
        bank = 0;

        SymbolTable symtab;
        Memory image;

        initProcessor();

        Option opt_e = new Option("e",false,null);  // errors
        Option opt_l = new Option("l",true,null);   // listing
        Option opt_t = new Option("t",true,null);   // symbol table
        Option opt_f = new Option("f",true,null);   // input file
                opt_f.unique = false;
                opt_f.valueNeeded = true;
                opt_f.negativeValueOK = true;
        Option opt_b = new Option("b",true,null);   // output binary
        Option opt_s = new Option("s",false,null);  // output s-records
        Option opt_D = new Option("D",false,null);  // definition
                opt_D.unique = false;
                opt_D.valueNeeded = true;
                opt_D.negativeValueOK = true;

        symtab = new SymbolTable();
        image = new Memory();

        // Parse the command-line
        // Keep track of input filenames in the order we hit them,
        // whether as part of a "-f" option or not.
        Vector /* of String */ inputFilenames = new Vector();
        Vector /* of String */ definitions = new Vector();
        for (int a=0; a<argv.length; a++) 
        {
            char ch1 = argv[a].charAt(0);
            if (ch1 == '-' || ch1 == '+') 
            {
                Option opt = null;

                try { opt = Option.parseAny(argv[a]); }
                catch (Exception x) { usage(x); }

                if (opt == null) {
                        usage( "Unrecognized option " + argv[a] );
                }
                if (opt.name.equals("f")) 
                {
                        inputFilenames.addElement( opt.value );
                }
                if (opt.name.equals("D")) 
                {
                        definitions.addElement( opt.value );
                }
            } else 
            {
                    inputFilenames.addElement( argv[a] );
            }
        }

        if (inputFilenames.size() == 0) 
        {
            usage( "No input filename specified." );
        }

        // build the array of streams and filenames
        int size = inputFilenames.size();
        LineNumberReader inputs[] = new LineNumberReader[ size ];
        String filenames[] = new String[ size ];
        String lastInputFile = null;
        for (int i=0; i<size; i++) {
            String f = (String)inputFilenames.elementAt(i);
            filenames[i] = f;
            try { inputs[i] = DynamicFile.getLineNumberReader(f); }
            catch (IOException x) { die(x); }
            lastInputFile = f;
        }

        // build the array of external symbols and their definitions
        size = definitions.size();
        String symbols[] = new String[ size ];
        int    values[]  = new int[ size ];
        for (int i=0; i<size; i++) {
            String d = (String)definitions.elementAt(i);
            int p = d.indexOf("=");
            if (p==0) { die("missing symbol name in '"+d+"'"); }
            values[i] = 0;
            if (p<0) {
                    symbols[i] = d;
            } else {
                symbols[i] = d.substring(0,p);
                try {
                        String vs = d.substring(p+1);
                        values[i] = ExpressionNumber.eval(vs);
                } catch (ParseException x) { die(x); }
            }
        }

        // figure out the default output base filename
        String baseFilename = lastInputFile;
        if ( baseFilename.toLowerCase().endsWith(".asm") ) {
            // drop the ".asm" extension
            baseFilename = baseFilename .substring( 0, baseFilename.length()-4 );
        }

        opt_b.default_value = baseFilename + ".bin";
        opt_s.default_value = baseFilename + ".s19";

        try {
            OutputStream binary_stream  = opt_b.getOutputStream();
            PrintStream  srecord_stream = opt_s.getPrintStream();
            PrintStream  listing_stream = opt_l.getPrintStream();
            PrintStream  error_stream   = opt_e.getPrintStream();
            PrintStream  symtab_stream  = opt_t.getPrintStream();

            assemble( inputs, filenames,
                    binary_stream, srecord_stream,
                    listing_stream, error_stream, symtab_stream,
                    symbols, values
            );

            opt_b.closeStream();
            opt_s.closeStream();
            opt_l.closeStream();
            opt_e.closeStream();
            opt_t.closeStream();

        } catch (IOException x) {
                die(x);
        }
    }

    public Asmj(
            LineNumberReader inputs[], String filenames[],
            OutputStream binary, PrintStream srecords,
            PrintStream listing, PrintStream errors, PrintStream symtab,
            String symbols[], int values[] )
    {
        bank = 0;

        initProcessor();
        assemble( inputs, filenames,
                binary, srecords,
                listing, errors, symtab,
                symbols, values );
    }

    private void initProcessor() 
    {
        // Dynamic access to processor-specific code allows
        // for independent compilation.
        try 
        {
            processor = new ProcessorDependencies();
        } 
        catch (Exception x) 
        {
            x.printStackTrace();
            throw new AsmjDeath( "Asmj bug - missing processor-dependencies" );
        }
        processor.sanityCheck();
    }

    public void assemble(
            LineNumberReader inputs[], String filenames[],
            OutputStream binary, PrintStream srecords,
            PrintStream listing, PrintStream errors, PrintStream symbols,
            String externalSymbols[], int externalValues[] )
    {
        SymbolTable symtab = new SymbolTable();
        Memory image = new Memory();
        LineContext ctx;

        Macro.reset();

        for (int i=0; i<externalSymbols.length; i++) 
        {
            if (externalSymbols[i] == null) { continue; }
            symtab.define(
                    externalSymbols[i],
                    externalValues[i], 
                    SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_EQU
            );
        }

        symtab.define( "false", 0,  SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_EQU );
        symtab.define( "true", 1,  SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_EQU );
        symtab.define( "FALSE", 0,  SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_EQU );
        symtab.define( "TRUE", 1,  SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_EQU );
        
        
        try 
        {
            ctx = new LineContext( new SourceLine("","",-1) );
            for (int i=0; i<inputs.length; i++) 
            {
                pass0( ctx, inputs[i], filenames[i] );
            }
            pass1( ctx, symtab, 0 );
            ctx.assertEndOfContext();
            pass2( ctx, symtab, image );
        } 
        catch (Exception x) 
        {
            throw new AsmjDeath(x);
        }
        setErrorCount( ctx ) ;
        
        
        if (errorNum == 0)
        {
            ps_info.println("0 errors detected.");

            String fn = filenames[0];
            int dot = fn.lastIndexOf(".");
            if (dot <0)
            {
                fn = fn +".cnt";
            }
            else
            {
                fn = fn.substring(0, dot);
                fn += ".cnt";
            }
            
            generateCNT( fn, symtab, ctx, image);
        }
        if (config.outputLST)
            if (listing  != null) { emitListing(ctx,image,listing); }
        if (errors   != null) { emitErrors(ctx,errors); }
        if (binary   != null) { writeBinary(image,binary); }
        if (srecords != null) { writeSRecords(image,symtab,srecords); }
        if (config.outputLST)
            if (symbols  != null) { symtab.dump(symbols); }
    }

    private void include( LineContext ctx, String filename ) throws IOException
    {
        LineNumberReader in = DynamicFile.getLineNumberReader(filename);
        pass0( ctx, in, filename );
        //System.out.println("finished reading from '"+filename+"'");

        in.close();
    }

    // Pass 0 soaks up source lines, and defines macros
    // puts SourceLines into the list after "current"
    private void pass0( LineContext ctx, LineNumberReader in, String filename )
    {
        SourceLine pline = null;

        //System.out.println("Pass 0 ----------------------");
        while (true) 
        {
            // read a line from the source file
            String line;
            try { line = in.readLine(); }
            catch (IOException x) { break; }
            if (line == null) { break; }
            //System.out.println("0line: "+line);
            int lineNum = in.getLineNumber();

            // parse it into label/op/rest
            pline = new SourceLine(line,filename,lineNum);

            
            
            
            if ( ! pass0_line(ctx,pline) ) { break; }
        }
    }

    // This version takes a list of SourceLines instead of a stream
    private void pass0( LineContext ctx, Vector /* of SourceLine */ src ) {
        SourceLine pline;

        //System.out.println("Pass 0 ----------------------");
        for (int i=0; i<src.size(); i++) {
            pline = (SourceLine)src.elementAt(i);
            //System.out.println("0line: "+pline.getInputLine());
            if ( ! pass0_line(ctx,pline) ) { break; }
        }
    }

    // fill in the line's macro or instruction reference,
    // add to the current macro definition (if any),
    // return true if pass0 should process more lines (false --> end)
    private boolean pass0_line( LineContext ctx, SourceLine pline ) 
    {
        Instruction instr = null;

        ctx.addLine( pline );

        // fill in instr
        if (pline.parsed()) 
        {
            // generate an instruction object for this line
            instr = Instruction.create(this,pline);
            pline.setInstruction( instr );
        }

        // return false at 'end' of file
        return (instr == null || !instr.isEnd());
    }

    // Pass 1 figures out sizes, defines symbols, and also handles
    // conditionals, macro definition, and macro expansion.
    private void pass1( LineContext ctx, SymbolTable symtab, int address ) 
    {
        Instruction instr;
        SourceLine pline = null;
        Macro macroRef;
        int skipMacroDepth = MAX_MACRO_DEPTH+1;
        globalAddress = address;

        //System.out.println("Pass 1 ----------------------");

        // Note: during pass1(), "*" is not defined yet.
        // (Because we don't know the instruction's length
        // until after we have parsed the line.)

        for (pline=ctx.first; pline!=null; pline=pline.getNext()) 
        {
            //System.out.println("1line: "+pline.inputLine);
            pline.dp_value = LineContext.directRegister;
            pline.setOptimize(config.opt);
            
            
            // Cache a ref to the enclosing conditional/macro
            instr = pline.getInstruction();
            Conditional c = ctx.getTopConditional();
            ctx.current = pline;
            
                    //if (pline.lineNumber ==282)
                      //  System.out.println("BU");
                    

            // If skipping over the 'false' branch of an if/else,
            // we would like to blindly skip everything up to the
            // next elseif/else/endif.  But we must keep parsing
            // because the next elseif/else/end may belong to a
            // nested if/macro; we need to look for the next one
            // that belongs to the if/else that caused the skip...


            // Are we skipping the rest of a macro?
            if ( skipMacroDepth <= MAX_MACRO_DEPTH ) 
            {
                if ( pline.getMacroDepth() >= skipMacroDepth ) 
                {
                    // skip it
                    pline.setInstruction( null );
                    pline.eraseErrorMessages();
                    ctx.hideInMacro(pline);
                    continue;
                } 
                else 
                {
                    // Done skipping macro-generated instrs.
                    // Pop contexts for skipped 'endif's
                    int d = skipMacroDepth;
                    while (c.getMacroDepth() >= d) 
                    {
                        c = ctx.popContext();
                    }
                    // no more skipping
                    skipMacroDepth = MAX_MACRO_DEPTH+1;
                }
            }

            // If the line has a label, put it into symtab.
            // labels in structs are treated different!
            if (( ctx.processInstructions() &&   pline.getLabel() != null ))
            {
                String lbl = ExpressionSymbol .parseName( pline.getLabel() );
                if ( ! pline.getLabel().equals(lbl) ) 
                {
                    // label isn't a legal symbol name
                    Asmj.error( pline, "bad label" );
                } 
                else if (instr==null || !instr.definesLabel()) 
                {
                    if (ctx.currentStruct == null)
                    {
                        symtab.define(
                                pline.getLabel(),
                                address,
                                pline.getLineNumber(), null, SYMBOL_DEFINE_CODE );
                    }
                    else
                    {
                        symtab.define(
                                pline.getLabel(),
                                ctx.currentStruct.currentPosition,
                                pline.getLineNumber(), null, SYMBOL_DEFINE_STRUCT );
                    }
                }
            }

            // First, handle macro stuff.
            if (( instr != null && instr.isEndMacro() ) && (c.isMacro()))
            {
                if (ctx.assertMacro()) 
                {
                    ctx.popContext();
                    ctx.macroDef = null;
                }
                continue;
            }

            // Within a macro definition, we just slurp up every
            // line until the first 'endm'.  We can't parse the
            // macro's innards because they won't make sense until
            // they are expanded by arguments at invokation time.
            // (Even if/else/endif/macro/endm pseudo-ops may be
            // the result of expanding args at invokation, so we
            // cannot trust any of it enough to parse it yet.)
            if ( c.isMacro() ) 
            {
                // Another line in the macro.
                // Never process the contents of macro
                // definitions; either save them or skip them.
                if ( ctx.macroDef != null ) 
                {
                    ctx.macroDef.addLine(pline);
                    // Ignore errors for now; line may not
                    // make sense until after its args are
                    // expanded at invokation time.
                    pline.eraseErrorMessages();
                }
                continue;
            }
            // Not in a macro definition.

            
            // Begin a new macro definition?
            if ( ctx.processInstructions() &&   instr != null &&   instr.isBeginMacro() ) 
            {
                String mname;
                try 
                {
                    mname = instr.macroName();
                } 
                catch (ParseException x) 
                {
                    Asmj.error( pline, x.getMessage() );
                    mname = "*undefined";
                }
                ctx.macroDef = Macro.set( mname, pline.getLineNumber(), pline );
                c = ctx.beginMacro();
                continue;
            }

            // If this line is a macro call, expand & insert it
            if ( ctx.processInstructions() &&   (macroRef=Macro.find(pline.op)) != null ) 
            {
                pline.setMacro( macroRef );
                ctx.hideInMacro(pline);
                // Was not recognized as instruction before;
                // get rid of the error message about that.
                pline.eraseErrorMessages();
                if (pline.getMacroDepth() >= MAX_MACRO_DEPTH) 
                {
                    Asmj.error( pline, "Macro recursion too deep" );
                } 
                else 
                {
                    // Insert the new lines after
                    // the current one.
                    pass0( ctx, macroRef.expandSource(pline) );
                    // Will process the new lines starting
                    // with the next iteration.
                }
                continue;
            }

            if ( ctx.processInstructions() &&   instr != null &&   instr.isExitMacro() ) 
            {
                int d = pline.getMacroDepth();
                if (d < 0) 
                {
                    Asmj.error( pline, "not in a macro" );
                }
                skipMacroDepth = d;
                ctx.hideInMacro(pline);
                continue;
            }
            // We are now finished with all macro stuff, and
            // can handle conditionals and normal instructions
            // without worrying about macros.
            
            // Don't even try to parse instructions that are
            // suppressed by conditional compilation.
            // Tricky bit: we might be skipping instructions
            // because we're in an "if" that had a false test;
            // in that case we do need to parse an "elseif" if
            // we find one; we can't skip that.
            // Basically, the 'elseif' should be handled in the
            // same context that the 'if' was, not in the
            // sub-context that was created by the 'if'.
            if (ctx.processInstructions()
            ||  ( c.isIf()               // we're in an 'if'
                && c.getEnclosingState() // 'if' was not skipped
                && instr != null         // line has an instruction
                && instr.isElseIf() )    // instruction is elseif
            ) 
            {
                if (instr != null) 
                {
                    if (ctx.currentStruct == null)
                    {
                        instr.pass1( address, symtab );

                        // malban: reload instruction in case
                        // short branches were switched to long branches
                        instr = pline.getInstruction();
                    }
                    else
                    {
                        // only pseudo instructions allowed!
                        instr.pass1( address, symtab );

                        // TODO ds , RMB still todo! for struct!
                        if (instr instanceof fcb)
                        {
                            fcb fcbInstr = (fcb) instr;
                            fcbInstr.setBSS(true);
                            Symbol s = fcbInstr.getSymbol();
                            if (s!=null)
                            {
                                s.removeUndefinedReference(instr);                          
                                s.value = ctx.currentStruct.currentPosition;
                                s.define(s.value, instr.getLineNumber());
                                s.line_Comment = instr.getSource().endOfLineComment;
                                instr.setEvalOk();
                            }
                            ctx.currentStruct.currentPosition += instr.getLength();
                        }
                        if (instr instanceof fdb)
                        {
                            fdb fdbInstr = (fdb) instr;
                            fdbInstr.setBSS(true);
                            Symbol s = fdbInstr.getSymbol();
                            if (s!=null)
                            {
                                s.removeUndefinedReference(instr);                          
                                s.value = ctx.currentStruct.currentPosition;
                                s.define(s.value, instr.getLineNumber());
                                s.line_Comment = instr.getSource().endOfLineComment;
                                instr.setEvalOk();
                            }
                            ctx.currentStruct.currentPosition += instr.getLength();
                        }
                        if (instr instanceof rmb)
                        {
                            rmb rmbInstr = (rmb) instr;
                            //rmbInstr.setBSS(true);
                            Symbol s = rmbInstr.getSymbol();
                            if (s!=null)
                            {
                                s.removeUndefinedReference(instr);                          
                                s.value = ctx.currentStruct.currentPosition;
                                s.define(s.value, instr.getLineNumber());
                                s.line_Comment = instr.getSource().endOfLineComment;
                                instr.setEvalOk();
                            }
                            ctx.currentStruct.currentPosition += instr.getLength();
                        }
                        
                        
                        if (instr.isStructEnd() )
                        {
                            ctx.currentStruct.endStruct();
                            ctx.currentStruct = null;
                        }
                    }
                }
            } 
            else 
            {
                // suppress errors in skipped code
                pline.eraseErrorMessages();
                pline.eraseWarningMessages();
                pline.eraseOptimizeMessages();
            }
            // If line has no instruction, no more work is needed
            if (instr == null) 
            {
                ctx.hideInMacro(pline);
                continue;
            }
            
            if ((instr.isStructStart()) && ctx.processInstructions())
            {
                ctx.setStruct(new Struct((struct)instr));
            }


            // Handle if/ifdef/.../endif
            if (instr.isIf()) 
            {
                c = ctx.beginIf( instr.getCondition() );
                ctx.hideInMacro(pline);
                continue;
            } 
            else if (instr.isElseIf()) 
            {
                if ( ctx.assertIf() &&   ctx.assertPastElse(false) ) 
                {
                    c.parseElseif( instr.getCondition() );
                    ctx.refreshState();
                    ctx.hideInMacro(pline);
                }
                continue;
            } 
            else if (instr.isElse()) 
            {
                if (ctx.assertIf()) 
                {
                    c.parseElse();
                    ctx.refreshState();
                    ctx.hideInMacro(pline);
                }
                continue;
            } 
            else if (instr.isEndIf()) 
            {
                if (ctx.assertIf()) 
                {
                    c = ctx.popContext();
                    ctx.hideInMacro(pline);
                }
                continue;
            }

            // Read an 'include' file?
            if (instr.isInclude()) 
            {
                // "include"s are handled specially
                try 
                {
                    String f2 = instr.includeFilename();
                    if ( ! f2.startsWith(File.separator) ) 
                    {
                        String f1="";
                        
                        if (config.includeRelativeToParent)
                        {
                            f1 = pline.getFilename();
                        }
                        else // include relative to main
                        {
                            f1 = mainFile;
                        }
                        int p = f1.lastIndexOf(File.separator);
                        String path = (p<0) ? "" : f1.substring(0,p+1);
                        f2 = path + f2; // relative path
                    }
                    include( ctx, f2 );
                } 
                catch (Exception x) 
                {
                    Asmj.error( pline, x.getMessage() );
                }
                continue;
            }


            // If we got here, the instruction is not a
            // macro or conditional pseudo-op.
            if (ctx.processInstructions()) 
            {
                if (ctx.currentStruct == null)
                    address += instr.getLength();
            } 
            else 
            {
                pline.setInstruction( null );
                ctx.hideInMacro(pline);
            }
            globalAddress = address;
        }

        // If the very last line was from a macro & hit a conditional
        // exitm, we skipped some endif's, and never cleaned up because
        // that is triggerred by a post-macro line.  Clean up now.
        if ( skipMacroDepth <= MAX_MACRO_DEPTH ) 
        {
            // pline.getMacroDepth() == 0
            // Done skipping macro-generated instrs.
            // Pop contexts for skipped 'endif's
            Conditional c = ctx.getTopConditional();
            while (c.getMacroDepth() >= skipMacroDepth) 
            {
                c = ctx.popContext();
            }
            // no more skipping
            skipMacroDepth = MAX_MACRO_DEPTH+1;
        }
    }

    // Pass 2 generates code.
    private void pass2( LineContext ctx, SymbolTable symtab, Memory mem ) 
    {
        Instruction instr;
        SourceLine pline;

        //System.out.println("Pass 2 ----------------------");

        // During pass2(), "*" refers to the next instruction's address.

        int address = 0;
        globalAddress = address;
        boolean oomDone = false;
        for (pline=ctx.first; pline!=null; pline=pline.getNext()) 
        {
            //System.out.println("2line: "+pline.inputLine);
            instr = pline.getInstruction();
            if (instr == null) { continue; }
            if (ctx.currentStruct == null)
                address += instr.getLength();
            globalAddress = address;
            symtab.define("*", address, SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_UNKOWN);

            if (mem.current!=null)
            if (mem.current.length > 32767)
            {
                if (!oomDone)
                Asmj.error( pline, "Resulting binary is larger than 32767 bytes, it can not run on a vectrex!" );
                oomDone = true;
            }
            
            instr.pass2( mem, symtab );
        }
    }

    private void writeBinary( Memory image, OutputStream binaryOut ) {
        image.write( binaryOut );
    }
    private void writeSRecords(
            Memory image, SymbolTable st, OutputStream srecordsOut )
    {
        int xferAddress = st.getValue("*xfer");

        try { image.writeSRecords( srecordsOut, xferAddress ); }
        catch (IOException x) {
                ps_error.println(
                        "Error writing s-record file:\n"
                        + x.toString() );
                ps_error.println(
                        "Error writing s-record file:\n"
                        + x.toString() );
        }
    }

    // constants for formatting lines in the listing
    static final int
            BYTES_PER_LINE = 6,
            CHARS_PER_LINE = 8+3*BYTES_PER_LINE;
    static final String CODE_PADDING;
    static {
        StringBuffer buf = new StringBuffer(CHARS_PER_LINE);
        for (int i=0; i<CHARS_PER_LINE; i++) { buf.append(" "); }
        CODE_PADDING = buf.toString();
    }
    boolean generateCNT(String filename, SymbolTable symtab, LineContext ctx, Memory mem)
    {
        StringBuilder buf = new StringBuilder();
        // symbols first
        Vector symbols = symtab.getSymbols();
        buf.append("BANK "+bank+"\n");
        
        
        for (int i=0; i< symbols.size(); i++)
        {
            Symbol sy = (Symbol) symbols.elementAt(i);
            
            if (!config.supportUnusedSymbols)
                if (!sy.isUsed()) continue;
            boolean equDone = false;
            int typ = sy.usageType;
//            if (sy.name.equals("x_hit_loop"))
//                System.out.println("Buh");
            if (!sy.labelUsage)
            {
                // EQU 20 value - konstant
                // const only
                if (Math.abs(sy.value)<128)
                {
                    boolean isNegative = sy.value<0;
                    int v = Math.abs(sy.value);
                    buf.append("EQU "+(isNegative?"-":"")+String.format("$%02X", (v&0xffff))+" "+sy.getName()+"\n");
                    if (sy.line_Comment.length()>0)
                    {
                        // COMMENT $c100 "bla" - end of line comment
                        buf.append("COMMENT_LABEL "+(isNegative?"-":"")+String.format("$%02X", (v&0xffff))+" "+sy.line_Comment+"\n");
                        equDone = true;
                    }
                    continue;
                }
            }
            if (((typ & Symbol.SYMBOL_USAGE_DIRECT_8)) ==Symbol.SYMBOL_USAGE_DIRECT_8)
            {
                if (sy.dp_estimate != -1)
                {
                    // DIRECT_LABEL D0 $00 timer_low
                    buf.append("DIRECT_LABEL "+String.format("$%02X", (sy.dp_estimate&0xff))+String.format(" $%02X", (sy.value&0xff))+" "+sy.getName()+"\n");
                    if (sy.line_Comment.length()>0)
                    {
                        // COMMENT $c100 "bla" - end of line comment
                        buf.append("COMMENT_LABEL "+String.format("$%02X", (sy.value&0xff))+" "+sy.line_Comment+"\n");
                    }
                }
                else
                {
                    // LABEL $c100 lab
                    // we don't have any clue about dp, so we just use as a normal label 
                    buf.append("LABEL "+String.format("$%04X", (sy.value&0xffff))+" "+sy.getName()+"\n");
                    if (sy.line_Comment.length()>0)
                    {
                        // COMMENT $c100 "bla" - end of line comment
                        buf.append("COMMENT_LABEL "+String.format("$%04X", (sy.value&0xffff))+" "+sy.line_Comment+"\n");
                    }
                }                    
                continue;
            }
            if (((typ & Symbol.SYMBOL_USAGE_DIRECT_16)) ==Symbol.SYMBOL_USAGE_DIRECT_16)
            {
                // DIRECT_LABEL D0 $00 timer_low
                buf.append("DIRECT_LABEL "+String.format("$%02X", ((sy.value>>8)&0xff))+String.format(" $%02X", (sy.value&0xff))+" "+sy.getName()+"\n");
                if (sy.line_Comment.length()>0)
                {
                    // COMMENT $c100 "bla" - end of line comment
                    buf.append("COMMENT_LABEL "+String.format("$%02", (sy.value&0xff))+" "+sy.line_Comment+"\n");
                }
            }
            // LABEL $c100 lab
            buf.append("LABEL "+String.format("$%04X", (sy.value&0xffff))+" "+sy.getName()+"\n");
            if (sy.line_Comment.length()>0)
            {
                // COMMENT $c100 "bla" - end of line comment
                buf.append("COMMENT_LABEL "+String.format("$%04X", (sy.value&0xffff))+" "+sy.line_Comment+"\n");
            }
        }
        
        // comments
        SourceLine pline;
        int address = 0;
        for (pline=ctx.first; pline!=null; pline=pline.getNext()) 
        {
            Instruction instr;
            instr = pline.getInstruction();
            if (instr != null)
            {
                // if instruction is availbale rather take instruction from
                // address, since optimizing
                // can leave e.g. a lbra to a bra and have one length less than expected
                // due to implementation, the one is "overstepped" since the defualt filler
                // for memory is "NOP", this is ok
                // but here we would lose 1 for every optimization in
                // adress -> comment relation!
            
                address = instr.getAddress();
            }
            if (pline.fullLineComment != null)
            {
                if (pline.fullLineComment.length() != 0)
                {
                    // COMMENT_LINE $c100 "bla" - line comment BEFOR adr
                    buf.append("COMMENT_LINE "+String.format("$%04X", (address))+" "+pline.fullLineComment+"\n");

                }
            }
            if (pline.endOfLineComment != null)
            {
                if (pline.endOfLineComment.length() != 0)
                {
                    if (!pline.endOfLineCommentDone)
                    {
                        // COMMENT $c100 "bla" - end of line comment
                        buf.append("COMMENT "+String.format("$%04X", (address))+" "+pline.endOfLineComment+"\n");
                        
                    }
                }
            }
            if (instr != null)
                address += instr.getLength();
        }
       
        // known DP values
        address = 0;
        int lastAddress = 0;
        int oldDP = -1;
        int currentDP=0;
        int dpStart = 0;
        for (pline=ctx.first; pline!=null; pline=pline.getNext()) 
        {
            Instruction instr;
            instr = pline.getInstruction();
            currentDP = pline.dp_value;
            if (currentDP != oldDP)
            {
                if (oldDP != -1)
                {
                    // new dp range
                    // RANGE 1000-2000 DP D0
                    buf.append("RANGE "+String.format("$%04X", (dpStart&0xffff))+"-"+String.format("$%04X", (lastAddress&0xffff))+" DP "+String.format("$%02X", (oldDP&0xff))+"\n");
                }
                dpStart = address;
            }
            oldDP = currentDP;
            lastAddress = address;
            if (instr != null) address += instr.getLength();
        }
        if (currentDP != -1)
        {
            // one more dp line
            buf.append("RANGE "+String.format("$%04X", (dpStart&0xffff))+"-"+String.format("$%04X", (lastAddress&0xffff))+" DP "+String.format("$%02X", (oldDP&0xff))+"\n");
        }
        
        if (mem.current==null)
        {
            // nothing generated? trying to compile an include???
            return false;
        }
        // code / data
        for (int i=mem.current.base; i< mem.current.base+ mem.current.length; )
        {
            int type = mem.current.getType(i);
            int len = getConsecutiveType(mem.current, i, type);

            
            
            // out
            if ((type == Memory.MEM_BYTE_DATA))
            {
                buf.append("RANGE "+String.format("$%04X", (i&0xffff))+"-"+String.format("$%04X", ((i+len)&0xffff))+" DB_DATA"+"\n");
            }
            else if ((type == Memory.MEM_CHAR_DATA))
            {
                buf.append("RANGE "+String.format("$%04X", (i&0xffff))+"-"+String.format("$%04X", ((i+len)&0xffff))+" CHAR_DATA"+"\n");
            }
            else if ((type == Memory.MEM_WORD_DATA))
            {
                buf.append("RANGE "+String.format("$%04X", (i&0xffff))+"-"+String.format("$%04X", ((i+len)&0xffff))+" DW_DATA"+"\n");
            }
            else if ((type == Memory.MEM_CODE))
            {
                buf.append("RANGE "+String.format("$%04X", (i&0xffff))+"-"+String.format("$%04X", ((i+len)&0xffff))+" CODE"+"\n");
            }
            i+= len;
        }
        try
        {
            PrintWriter out = new PrintWriter(filename);
            out.println(buf.toString());
            out.close();
        }
        catch (Throwable e)
        {
            System.out.println("Error saving CNT file...");
            return false;
        }
        
        return true;
    }
    int getConsecutiveType(MemorySegment mem, int address, int type)
    {
        int len = 0;
        if (type == Memory.MEM_CODE_POSTBYTE) type = Memory.MEM_CODE;
        int newType;
        do
        {
            len++;
            address++;
            newType = mem.getType(address);
            if (type == Memory.MEM_CODE)
            {
                if (newType == Memory.MEM_CODE_POSTBYTE)
                {
                    newType = Memory.MEM_CODE;
                }
            }
        }
        while  (type == newType);
        
        return len;
    }
    
    
    private void emitListing(
            LineContext ctx, Memory image, PrintStream listingOut )
    {
            int adr, len, errs;
            SourceLine p;
            errs = 0;
            for (p=ctx.first.getNext(); p!=null; p=p.getNext()) {
                    Instruction instr = p.getInstruction();
                    Vector msgs = p.errorMessages;
                    Vector msgs2 = p.warningMessages;
                    Vector msgs3 = p.optimizeMessages;

                    if ( p.getHidden()
                    &&   (msgs==null || msgs.size()==0) ) {
                            continue;
                    }

                    // show the source line & first few generated bytes...
                    if (instr != null && instr.generatedCode()) {
                            adr = instr.getAddress();
                            len = instr.getLength();
                            listingOut.print( formatCode(image,adr,len) );
                            adr += BYTES_PER_LINE;
                            len -= BYTES_PER_LINE;
                    } else {
                            // fill the address area with spaces
                            adr = len = 0;
                            if (instr != null)
                            {
                                adr = instr.getAddress();
                                len = instr.getLength();
                                
                            }
                            listingOut.print( formatCode(null,adr,len) );

                    }
                    String fname = p.getFilename();
                    if (fname != null && !fname.equals("")) {
                            listingOut.print( "|" );
                    } else {
                            listingOut.print( ">" );
                    }
                    listingOut.println( p.inputLine );

                    // show the rest of the generated bytes
                    if ( instr != null && instr.generatedCode() ) {
                            while (len > 0) {
                                    listingOut.print(
                                            formatCode(image,adr,len) );
                                    listingOut.println( ">" );
                                    adr += BYTES_PER_LINE;
                                    len -= BYTES_PER_LINE;
                            }
                    }

                    // show any attached error messages...
                    if (msgs != null) {
                            for (int mx=0; mx<msgs.size(); mx++) {
                                    String m = (String)msgs.elementAt(mx);
                                    listingOut.println( "****** " + m );
                                    errs += 1;
                            }
                    }
                    // show any attached warning messages...
                    if (msgs2 != null) {
                            for (int mx=0; mx<msgs2.size(); mx++) {
                                    String m = (String)msgs2.elementAt(mx);
                                    listingOut.println( "++++++ " + m );
                            }
                    }
                    // show any attached optimize messages...
                    if (msgs3 != null) {
                            for (int mx=0; mx<msgs3.size(); mx++) {
                                    String m = (String)msgs3.elementAt(mx);
                                    listingOut.println( "###### " + m );
                            }
                    }
            }
            listingOut.println("\n"+errs+" errors detected.");
            listingOut.flush();
    }

    // Format an address & some bytes, padded to the appropriate length.
    // If mem == null, generate all blanks to that same length.
    private String formatCode( Memory mem, int adr, int len ) {
            StringBuffer output = new StringBuffer(CHARS_PER_LINE);

            if (mem != null) {
                    output.append("  ")
                            .append( formatHex(adr,4) )
                            .append("  ");

                    if (len > BYTES_PER_LINE) { len = BYTES_PER_LINE; }
                    for (int j=0; j<len; j++) {
                            int b = mem.read( adr++ );
                            output.append( formatHex(b,2) )
                                    .append(" ");
                    }
            }
            if ((mem == null) && (adr != 0))
            {
                output.append("  ")
                        .append( formatHex(adr,4) )
                        .append("  ");
                
            }

            int paddingNeeded = CHARS_PER_LINE - output.length();
            output.append( CODE_PADDING.substring(0,paddingNeeded) );
            // output.delete( CHARS_PER_LINE, output.length() );

            return output.toString();
    }

    private String formatHex( int num, int len ) {
            String f = "00000000" + Integer.toHexString(num);
            return f.substring( f.length() - len );
    }

    public int getNumErrors()
    {
        return errorNum;
    }
    int errorNum = -1;
    private void setErrorCount( LineContext ctx ) 
    {
        int j, errs;
        SourceLine p;

        errs = 0;
        for (p=ctx.first; p!=null; p=p.getNext()) 
        {
            Vector msgs = p.errorMessages;
            if (msgs!=null && msgs.size()>0) 
            {
                for (j=0; j<msgs.size(); j++) 
                {
                    errs += 1;
                }
            }
        }
        errorNum = errs;
    }
    private void emitErrors( LineContext ctx, PrintStream errorsOut ) 
    {
        Instruction instr;
        int b, i, j, adr, len, errs;
        String output, f;
        SourceLine p;

        errs = 0;
        for (p=ctx.first; p!=null; p=p.getNext()) 
        {
            Vector msgs = p.errorMessages;
            if (msgs!=null && msgs.size()>0) 
            {
                for (j=0; j<msgs.size(); j++) 
                {
                    String m = (String)msgs.elementAt(j);
                    errorsOut.println( "******" + m.substring((p.fileName+"("+p.lineNumber+"): ").length()) );
                    errs += 1;
                }
                errorsOut.println( "       "+p.fileName+"("+p.lineNumber+"): " + p.inputLine+(p.instr != null?(" ("+String.format("$%04X", (p.instr.getAddress()&0xffff))+")"):"") );
            }
            
            
            msgs = p.warningMessages;
            if (msgs!=null && msgs.size()>0) 
            {
                for (j=0; j<msgs.size(); j++) 
                {
                    String m = (String)msgs.elementAt(j);
                    errorsOut.println( "++++++" + m.substring((p.fileName+"("+p.lineNumber+"): ").length()) );
                }
                errorsOut.println( "       "+p.fileName+"("+p.lineNumber+"): " + p.inputLine );
            }
            msgs = p.optimizeMessages;
            if (msgs!=null && msgs.size()>0) 
            {
                for (j=0; j<msgs.size(); j++) 
                {
                    String m = (String)msgs.elementAt(j);
                    errorsOut.println( "######" + m.substring((p.fileName+"("+p.lineNumber+"): ").length()) );
                }
                errorsOut.println( "       "+p.fileName+"("+p.lineNumber+"): " + p.inputLine );
            }        
        }
        if (errs != 0)
            errorsOut.println(""+errs+" errors detected.");
    }

    public static void error( SourceLine line, String errmsg ) {
            line.addErrorMessage(
                    line.fileName+"("+line.lineNumber+")"
                    + ":  " + errmsg );
    }
    public static void warning( SourceLine line, String errmsg ) {
            line.addWarningMessage(
                    line.fileName+"("+line.lineNumber+")"
                    + ":  " + errmsg );
    }
    public static void optimize( SourceLine line, String errmsg ) {
            line.addOptimizeMessage(
                    line.fileName+"("+line.lineNumber+")"
                    + ":  " + errmsg );
    }

    // add spaces to the end of a string until it is long enough
    private static String pad( String s, int len ) {
            while (s.length() < len) { s += "          "; }
            return s.substring( 0, len );
    }

    private void die( Exception x ) { die(x.toString()); }
    private void die( String s ) { throw new AsmjDeath(s); }

    private void usage( ) { usage(""); }
    private void usage( Exception x ) { usage(x.toString()); }
    private void usage( String s ) {
            if (s!=null && s.length()>0) { System.out.println( s ); }
            System.out.println( "Usage: java Asmj <options> [+f=]<filename>\n"
                    + "I/O options:\n"
                    + "  Must be preceded with '+' or '-',"
                    + " which turn them on or off, respectively.\n"
                    + "  If enabled, can be directed to a file;\n"
                    + "  otherwise default to standard I/O.\n"
                    + "    +b[=<filename>]   (binary, default=on)\n"
                    + "    +e[=<filename>]   (error, default=off)\n"
                    + "    +f=<filename>     (input, filename required)\n"
                    + "    +l[=<filename>]   (listing, default=on)\n"
                    + "    +s[=<filename>]   (s-records, default=off)\n"
                    + "    +t[=<filename>]   (symbol table, default=on)\n"
                    + "Other options:\n"
                    + "  Preceding '+' or '-' mean the same thing.\n"
                    + "    +D=symbol[=value]  (symbol definition)\n"
            );
            // System.exit(1);
    }
    HashMap<Character, Character> cmapping = null;
    public void setCMap(HashMap<Character, Character> cm)
    {
        cmapping = cm;
    }
    public HashMap<Character, Character> getCMap()
    {
        return cmapping;
    }

}

