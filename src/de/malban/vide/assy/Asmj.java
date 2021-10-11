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

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.ERROR;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.vide.VideConfig;
import static de.malban.vide.assy.SourceLine.commentRecognizer;
import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_CODE;
import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_EQU;
import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_STRUCT;
import static de.malban.vide.assy.Symbol.SYMBOL_DEFINE_UNKOWN;
import de.malban.vide.assy.arguments.ArgumentMemoryLocation;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.expressions.ExpressionSymbol;
import de.malban.vide.assy.expressions.ExpressionNumber;
import de.malban.vide.assy.instructions.Instruction;
import de.malban.vide.assy.instructions.RegArg;
import de.malban.vide.assy.instructions.SingleArg;
import de.malban.vide.assy.instructions.fcb;
import de.malban.vide.assy.instructions.fdb;
import de.malban.vide.assy.instructions.rmb;
import de.malban.vide.assy.instructions.struct;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.vedi.DebugComment;
import static de.malban.vide.vedi.DebugComment.COMMENT_TYPE_WATCH;
import de.malban.vide.vedi.DebugCommentList;
import java.io.File;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.IOException;
import java.io.LineNumberReader;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

public class Asmj {
    VideConfig config = VideConfig.getConfig();

    public static final int MAX_MACRO_DEPTH = 65536;
    public static ProcessorDependencies processor;

    public static int bank = 0;
    public static boolean multibank = false; // is a multibannk asm 64k in one file
    public static boolean inBSS = false;
    public static String currentBaseDir="";
    public static boolean is48k = false;
    
    public static final int SEGMENT_CODE = 0;
    public static final int SEGMENT_DATA = 1;
    public static final int SEGMENT_BSS = 2;
    public int currentSegment = SEGMENT_CODE;
    public int currentCodeOrg =0;
    public int currentBSSOrg =0;
    public int currentDataOrg =0;
    private int globalAddress = 0;

    static class Replacements
    {
        int address=0;
        int len=0;
        String replacementVarName="";
        String replacementVarListName="";
    }

    static class ReplacementFileList
    {
        String binFileName="";
        String replacementFileName="";
        ArrayList<Replacements> replacementList= new ArrayList<Replacements>();
    }
            
    static ArrayList<ReplacementFileList> allReplacements=new ArrayList<ReplacementFileList>();
    public static void resetReplacements(String prefix)
    {
        allReplacements=new ArrayList<ReplacementFileList>();
        replacementPrefix = prefix;
        if (!replacementPrefix.endsWith(File.separator))replacementPrefix+=File.separator;
    }
    private static String  replacementPrefix= Global.mainPathPrefix;

    // name change of bin files from the outside
    public static void binFileRename(String org, String banked)
    {
        for (ReplacementFileList asmR : allReplacements)
        {
            if (asmR.binFileName.equals(org)) asmR.binFileName = banked;
        }
    }
    
    
    static HashMap<String, HashMap> matchFiles;
    static HashMap<String, Integer> matchList;
    
    
    
    public static void doReplacements()
    {   
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        matchFiles = new HashMap<String, HashMap>();
        for (ReplacementFileList asmR : allReplacements)
        {
            // load bin
            try
            {
                log.addLog("Replacement start for file: "+asmR.binFileName, INFO);
                Path path = Paths.get(asmR.binFileName);
                byte[] data = Files.readAllBytes(path);

                for (Replacements r : asmR.replacementList)
                {
                    if (r.address+r.len > data.length) continue;
                    int value = getReplacementValue(r.replacementVarName, r.replacementVarListName);
                    byte lo = (byte) (value &0xff);
                    byte hi = (byte) ((value &0xff00)>>8);

                    if (r.len ==1)
                    {
                        int org = data[r.address]&0xff;
                        data[r.address] = lo;
                        log.addLog("Replacement done (at $"+String.format("%04X", r.address)+"): '"+r.replacementVarName+"', from $"+String.format("%02X", org)+" to $"+String.format("%02X", (lo)), INFO);
                        
                        if (value == 0)
                            log.addLog("Replacement value == 0 (at $"+String.format("%04X", r.address)+"): '"+r.replacementVarName+"', from $"+String.format("%02X", org)+" to $"+String.format("%02X", (lo)), ERROR);
                    }
                    else if (r.len ==2)
                    {
                        int org = ((data[r.address]&0xff)*256+(data[r.address+1]&0xff) )&0xffff;
                        data[r.address] = hi;
                        data[r.address+1] = lo;

                        log.addLog("Replacement done (at $"+String.format("%04X", r.address)+"): '"+r.replacementVarName+"', from $"+String.format("%04X", org)+" to $"+String.format("%04X", (value&0xffff)), INFO);
                        if (value == 0)
                            log.addLog("Replacement value == 0 (at $"+String.format("%04X", r.address)+"): '"+r.replacementVarName+"', from $"+String.format("%04X", org)+" to $"+String.format("%02X", (lo)), ERROR);
                    }
                }
               
                //save bin
                de.malban.util.UtilityFiles.writeBinFile(asmR.binFileName, data, false);
            }
            catch (Throwable ex)
            {
                ex.printStackTrace();
            }
        }
    }
    public static int getReplacementValue(String varName, String listName)
    {
        
        HashMap<String, Integer> matchList = matchFiles.get(listName);
        if (matchList == null)
        {
            matchList = new HashMap<String, Integer>();
            
            Vector<String> matches = de.malban.util.UtilityString.readTextFileToString(new File(replacementPrefix+listName));
            for (int i=0; i<matches.size(); i++)
            {
                String l = matches.elementAt(i);
                String[] split = l.split("=");
                if (split.length!=2) continue;
                matchList.put(split[0],DASM6809.toNumber(split[1]));
            }
        }
        if (matchList.get(varName) != null) return matchList.get(varName);
        
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        log.addLog("Replacement match not found: "+varName, WARN);

        return 0;
    }
    
    
    public static boolean doReplacements = false;
    public static ReplacementFileList rList;
    private static void initReplacement()
    {
        doReplacements = false;
        rList= new ReplacementFileList();
    }

    private static void exitReplacement(SymbolTable symbols)
    {
        allReplacements.add(rList);
        
        StringBuilder b = new StringBuilder();
        String name;
        int i, value;

        for (i=0; i<symbols.symbols.size(); i++) 
        {
            Symbol s = (Symbol)symbols.symbols.elementAt(i);
            name = s.getName();
            if (name.startsWith("*")) { continue; }
            if (s.defined()) 
            {
                value = s.getValue();

                if (checkReplacer(name, value)) ;//continue;

                b.append(name);
                b.append("=");
                b.append("0x"+String.format("%04X", value & 0xFFFF));
                b.append("\n");
            } 
	}
        
        String fName = replacementPrefix+rList.replacementFileName;
        de.malban.util.UtilityFiles.createTextFile(fName, b.toString());
    }
    // return true is this name denotes something that needs replacing
    // REPLACE_1_2_enemyPlayerControlledRightBehaviour_varFrom1_0
    static boolean checkReplacer(String name, int value)
    {
        String[] split = name.split("_");
        if (!split[0].equals("REPLACE")) return false;
        if (split.length != 6) return false;
        Replacements r= new Replacements();
        r.address = value;
        r.address += DASM6809.toNumber(split[1]); // plus starting place 

        r.len = DASM6809.toNumber(split[2]);
        r.replacementVarName = split[3];
        r.replacementVarListName = split[4];
        rList.replacementList.add(r);
        return true;
    }
            
    
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
    PrintStream ps_allOut;
    OutputStream ps_error_add=null;
    OutputStream ps_info_add=null;
    OutputStream ps_listing_add=null;
    OutputStream ps_symtab_add=null;
    OutputStream ps_allOut_add=null;
    StringBuffer symtabString=new StringBuffer();
    StringBuffer errorString=new StringBuffer();
    StringBuffer  infoString=new StringBuffer();
    StringBuffer  listingString=new StringBuffer();
    StringBuffer  allOutString=new StringBuffer();
    public String getAllOut()
    {
        String ao = allOutString.toString();
        allOutString.delete(0, allOutString.length());
        return ao;
    }
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
    private void initStreams()
    {
        ps_allOut = new PrintStream(
            new OutputStream()
            {
              @Override
              public void write( int b )
              {
                  char[] c = {(char)b};
//                  String s = new String(c);
                  allOutString.append(c);
//                  allOutString.append(s);
//                  try { if (ps_allOut_add!=null)ps_allOut_add.write(b); } catch (Throwable e){}
              }
            }
          );
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
    
    public Asmj(String filename, OutputStream errOut, OutputStream result)
    {
        initReplacement();
        clearLineInfo();
        mainFile = filename;
        ps_error_add=errOut;
        ps_allOut_add=result;
        bank = 0;
        initStreams();
        
        SymbolTable symtab;
        Memory image;
        initProcessor();

        Option opt_p = new Option("p",true,null);  // preprocessOnly
        opt_p.stream = ps_allOut;

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
        rList.binFileName = opt_b.default_value;
        opt_s.default_value = baseFilename + ".s19";

        try {
            OutputStream binary_stream=null;
//            binary_stream  = opt_b.getOutputStream();
            PrintStream  srecord_stream = opt_s.getPrintStream();
            PrintStream  listing_stream = (PrintStream)opt_l.stream;
            PrintStream  error_stream   = (PrintStream)opt_e.stream;
            PrintStream  symtab_stream  = (PrintStream)opt_t.stream;
            PrintStream  preprocess_stream  = (PrintStream)opt_p.stream;

            assemble( inputs, filenames,
                    binary_stream, srecord_stream,
                    listing_stream, error_stream, symtab_stream, preprocess_stream,
                    symbols, values
            );

            
            opt_b.closeStream();
            opt_s.closeStream();
            opt_l.closeStream();
            opt_e.closeStream();
            opt_t.closeStream();
            opt_p.closeStream();

        } catch (IOException x) {
                die(x);
        }        
    }
    
    String mainFile = "";
    public static HashMap <String, DebugCommentList> allDebugComments;
    public Asmj( String filename, OutputStream errOut, OutputStream listOut, OutputStream symOut, OutputStream infoOut , String defines, HashMap <String, DebugCommentList> adc) 
    {
        this(  filename,  errOut,  listOut,  symOut,  infoOut ,  defines,   adc, false);
    }
    public Asmj( String filename, OutputStream errOut, OutputStream listOut, OutputStream symOut, OutputStream infoOut , String defines, HashMap <String, DebugCommentList> adc, boolean is48k) 
    {
        Asmj.is48k = is48k;
        initReplacement();
        allDebugComments = adc; // make comments accessable to all 
        clearLineInfo();
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
        rList.binFileName = opt_b.default_value;
        opt_s.default_value = baseFilename + ".s19";

        try {
            OutputStream binary_stream  = opt_b.getOutputStream();
            PrintStream  srecord_stream = opt_s.getPrintStream();
            PrintStream  listing_stream = (PrintStream)opt_l.stream;
            PrintStream  error_stream   = (PrintStream)opt_e.stream;
            PrintStream  symtab_stream  = (PrintStream)opt_t.stream;

            assemble( inputs, filenames,
                    binary_stream, srecord_stream,
                    listing_stream, error_stream, symtab_stream, null,
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
        initReplacement();
        clearLineInfo();
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
        rList.binFileName = opt_b.default_value;
        opt_s.default_value = baseFilename + ".s19";

        try {
            OutputStream binary_stream;
            
            binary_stream  = opt_b.getOutputStream();
            PrintStream  srecord_stream = opt_s.getPrintStream();
            PrintStream  listing_stream = opt_l.getPrintStream();
            PrintStream  error_stream   = opt_e.getPrintStream();
            PrintStream  symtab_stream  = opt_t.getPrintStream();

            assemble( inputs, filenames,
                    binary_stream, srecord_stream,
                    listing_stream, error_stream, symtab_stream, null,
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
/*
    public Asmj(
            LineNumberReader inputs[], String filenames[],
            OutputStream binary, PrintStream srecords,
            PrintStream listing, PrintStream errors, PrintStream symtab,
            String symbols[], int values[] )
    {
        initReplacement();
        clearLineInfo();
        bank = 0;

        initProcessor();
        assemble( inputs, filenames,
                binary, srecords,
                listing, errors, symtab, null,
                symbols, values );
    }
*/
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
            PrintStream listing, PrintStream errors, PrintStream symbols, PrintStream preprocess,
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
                    SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_EQU, null
            );
        }

        symtab.define( "false", 0,  SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_EQU , null);
        symtab.define( "true", 1,  SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_EQU , null);
        symtab.define( "FALSE", 0,  SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_EQU, null );
        symtab.define( "TRUE", 1,  SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_EQU , null);
        
        try 
        {
            ctx = new LineContext( new SourceLine("","",-1) );
            for (int i=0; i<inputs.length; i++) 
            {
                pass0( ctx, inputs[i], filenames[i] );
            }
            pass1( ctx, symtab, 0 );
            ctx.assertEndOfContext();
            pass2( ctx, symtab, image , preprocess);
        } 
        catch (Exception x) 
        {
            throw new AsmjDeath(x);
        }
        setErrorCount( ctx ) ;
        
        if (preprocess == null)
        {
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
                if (preprocess == null)
                    if (binary   != null) { writeBinary(image,binary); }
                if (srecords != null) { writeSRecords(image,symtab,srecords); }


                if (config.outputLST)
                    if (symbols  != null) { symtab.dump(symbols); }

        }
        exitReplacement(symtab);
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
    boolean watchesDone = false;
    private void pass0( LineContext ctx, LineNumberReader in, String filename )
    {
        SourceLine pline = null;

        
        if (!watchesDone)
        {
            watchesDone = true;
            // add all watches!
            if (Asmj.allDebugComments != null)
            {
                Set entries = Asmj.allDebugComments.entrySet();
                Iterator it = entries.iterator();
                while (it.hasNext())
                {
                    Map.Entry entry = (Map.Entry) it.next();
                    DebugCommentList value = (DebugCommentList) entry.getValue();
                    for (DebugComment dbc: value.getList())
                    {
                        if (dbc.getType() == COMMENT_TYPE_WATCH)
                        {
                            pline = new SourceLine("; "+dbc.getGeneratedComment(),filename, 0);
                            pass0_line(ctx,pline);
                        }
                    }
                }

            }
        }
        
        
        
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
                                pline.getLineNumber(), null, SYMBOL_DEFINE_CODE, pline );
                    }
                    else
                    {
                        symtab.define(
                                pline.getLabel(),
                                ctx.currentStruct.currentPosition,
                                pline.getLineNumber(), null, SYMBOL_DEFINE_STRUCT, pline );
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
                                int value = ctx.currentStruct.currentPosition;
                                s.define(value, instr.getLineNumber(),pline);
//                                s.value = ctx.currentStruct.currentPosition;
//                                s.define(s.value, instr.getLineNumber(),pline);
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
                                int value = ctx.currentStruct.currentPosition;
                                s.define(value, instr.getLineNumber(),pline);
//                                s.value = ctx.currentStruct.currentPosition;
//                                s.define(s.value, instr.getLineNumber(),pline);
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
                                int value = ctx.currentStruct.currentPosition;
                                s.define(value, instr.getLineNumber(),pline);
//                                s.value = ctx.currentStruct.currentPosition;
//                                s.define(s.value, instr.getLineNumber(),pline);
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
                pline.eraseComments();
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
//                System.out.println("IF OPEN: "+pline.fileName+", "+pline.lineNumber+pline.inputLine);
//                if (pline.inputLine.contains("if USE_COMPILED = 1")) 
//                    System.out.println("sss");
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
//                System.out.println("IF CLOSE: "+pline.fileName+", "+pline.lineNumber+pline.inputLine);
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

    void doPreprocessOut(SourceLine pline, PrintStream preprocess)
    {
        boolean commentOut = false;
        String commentOutComment = "";
        boolean noOut = false;
        if (pline.instr!=null)
        {
            if (pline.instr.isBeginMacro()) 
                macroCount++;
            
            if (pline.instr.isInclude())
            {
                commentOut = true;
                commentOutComment = "include line -> ";            
            }
            if (pline.instr.isStructStart())
            {
                //preprocess.println("*************************************************");
                //preprocess.println("; STRUCTS NOT SUPPORTED FOR CLEAN CONVERSION YET!");
                //preprocess.println("*************************************************");
            }
            if (pline.instr.isIf())
            {
                noOut = true;
                conditionals.add(pline.instr.getCondition());
            }
            if (pline.instr.isElse())
            {
                noOut = true;

                boolean if_conditial = conditionals.get(conditionals.size()-1);
                conditionals.remove(conditionals.size()-1);
                conditionals.add(!if_conditial);
            }
            if (pline.instr.isElseIf())
            {
                noOut = true;
                conditionals.remove(conditionals.size()-1);
                conditionals.add(pline.instr.getCondition());
            }
            if (pline.instr.isEndIf())
            {
                noOut = true;
                conditionals.remove(conditionals.size()-1);
            }
            
        }

        if (macroCount!=0) noOut = true;
        if (conditionals.size()>0)
            condition = conditionals.get(conditionals.size()-1);
        else
            condition = true;
        
        
        
        
        if (!condition) noOut = true;
        if (pline.macro != null) 
        {
            commentOut = true;
            commentOutComment = "macro call -> ";            
        }
            
        
        if (!noOut)
        {
            if (commentOut)
            {
                preprocess.println("; "+ commentOutComment + pline.inputLine);
            }
            else
            {
                preprocess.println(pline.inputLine);
            }
        }
        
        if (pline.instr!=null)
        {
            if (pline.instr.isEndMacro()) 
            {
                macroCount--;
            }
        }
    }
    ArrayList<Boolean> conditionals = new ArrayList<Boolean>();
    boolean condition = true;
    int macroCount = 0;
    // Pass 2 generates code.
    private void pass2( LineContext ctx, SymbolTable symtab, Memory mem , PrintStream preprocess) 
    {
        Instruction instr;
        SourceLine pline;

        //System.out.println("Pass 2 ----------------------");

        // During pass2(), "*" refers to the next instruction's address.

        int address = 0;
        globalAddress = address;
        boolean oomDone = false;
        macroCount=0;
        int maxMem = 32768;
        if (Asmj.is48k) maxMem = 32768 +16384;
        for (pline=ctx.first; pline!=null; pline=pline.getNext()) 
        {
            if (preprocess != null)
            {
                doPreprocessOut(pline, preprocess);
            }
            
            instr = pline.getInstruction();
            if (instr == null) { continue; }
            
            if (ctx.currentStruct == null)
                address += instr.getLength();
            globalAddress = address;
            symtab.define("*", address, SymbolTable.NO_LINE_NUMBER, null, SYMBOL_DEFINE_UNKOWN, null);

            if (mem.current!=null)
            {
                if (!multibank)
                {
                    if (mem.current.length > maxMem)
                    {
                        oomDone = true;
                    }
                }
            }

            instr.pass2( mem, symtab );
        }
        if (oomDone)
            Asmj.error( ctx.first, "Resulting binary is larger than "+maxMem+" bytes, it can not run on a vectrex ("+mem.current.length+" -> "+(maxMem-mem.current.length)+")!" );
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
            
// obsolete with forced symbol            if (sy.getValue() == 0) continue;
// obsolete with forced symbol            if (sy.getValue() == 1) continue;
            if (sy.getName().toLowerCase().equals("include_i")) continue;
            if (sy.getName().toLowerCase().equals("assembler")) continue;
            if (sy.getName().toLowerCase().equals("__6809__")) continue;
            if (sy.getName().toLowerCase().equals("line")) continue;
            if (sy.getName().toLowerCase().equals("true")) continue;
            if (sy.getName().toLowerCase().equals("false")) continue;
            
            if (!sy.labelUsage)
            {
                // EQU 20 value - konstant
                // const only
                if (Math.abs(sy.value)<128)
                {
                    boolean isNegative = sy.value<0;
                    int v = Math.abs(sy.value);
                    buf.append("EQU ").append(isNegative?"-":"").append(String.format("$%02X", (v&0xffff))).append(" ").append(sy.getName()).append("\n");
                    if (sy.line_Comment.length()>0)
                    {
                        // COMMENT $c100 "bla" - end of line comment
                        buf.append("COMMENT_LABEL ").append(isNegative?"-":"").append(String.format("$%02X", (v&0xffff))).append(" ").append(sy.line_Comment).append("\n");
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
                    buf.append("DIRECT_LABEL ").append(String.format("$%02X", (sy.dp_estimate&0xff))).append(String.format(" $%02X", (sy.value&0xff))).append(" ").append(sy.getName()).append("\n");
                    if (sy.line_Comment.length()>0)
                    {
                        // COMMENT $c100 "bla" - end of line comment
                        buf.append("COMMENT_LABEL ").append(String.format("$%02X", (sy.value&0xff))).append(" ").append(sy.line_Comment).append("\n");
                    }
                }
                else
                {
                    // LABEL $c100 lab
                    // we don't have any clue about dp, so we just use as a normal label 
                    buf.append("LABEL ").append(String.format("$%04X", (sy.value&0xffff))).append(" ").append(sy.getName()).append("\n");
                    if (sy.line_Comment.length()>0)
                    {
                        // COMMENT $c100 "bla" - end of line comment
                        buf.append("COMMENT_LABEL ").append(String.format("$%04X", (sy.value&0xffff))).append(" ").append(sy.line_Comment).append("\n");
                    }
                }                    
                continue;
            }
            if (((typ & Symbol.SYMBOL_USAGE_DIRECT_16)) ==Symbol.SYMBOL_USAGE_DIRECT_16)
            {
                // DIRECT_LABEL D0 $00 timer_low
                buf.append("DIRECT_LABEL ").append(String.format("$%02X", ((sy.value>>8)&0xff))).append(String.format(" $%02X", (sy.value&0xff))).append(" ").append(sy.getName()).append("\n");
                if (sy.line_Comment.length()>0)
                {
                    // COMMENT $c100 "bla" - end of line comment
                    buf.append("COMMENT_LABEL ").append(String.format("$%02X", (sy.value&0xff))).append(" ").append(sy.line_Comment).append("\n");
                }
            }
            // LABEL $c100 lab
            buf.append("LABEL ").append(String.format("$%04X", (sy.value&0xffff))).append(" ").append(sy.getName()).append("\n");
            if (sy.line_Comment.length()>0)
            {
                // COMMENT $c100 "bla" - end of line comment
                buf.append("COMMENT_LABEL ").append(String.format("$%04X", (sy.value&0xffff))).append(" ").append(sy.line_Comment).append("\n");
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
            // check for symbol usage and
            // do a force symbel
            if (pline.instr != null)
            {
                
//                if (pline.instr.getAddress() == 0x73c7)
//                {
//                    System.out.println();
//                }
                
                if (pline.instr instanceof SingleArg)
                {
                    SingleArg sa = (SingleArg)pline.instr;
                    if (sa.m != null)
                    {
                        ArgumentMemoryLocation m = (ArgumentMemoryLocation) sa.m;
                        int valAll = m.getOffset();
                        if (m.offsetExpression != null)
                        {
                            if (m.offsetExpression instanceof ExpressionSymbol)
                            {
                                ExpressionSymbol oe = (ExpressionSymbol) m.offsetExpression;
                                if (oe.getSymbol() != null)
                                {
                                    if (oe.getSymbol().value == valAll)
                                    {
                                        String symbol = oe.getSymbol().getName();
                        buf.append("FORCE_SYMBOL "+String.format("$%04X", (address))+" "+symbol+"\n");

                                    
                                    }
                                }
                                
                            }
                            else  if (m.offsetExpression instanceof ExpressionNumber)
                            {
                        buf.append("FORCE_NO_SYMBOL "+String.format("$%04X", (address))+"\n");

                            }
                                
                        }
                    }
                }          
                if (pline.instr instanceof RegArg)
                {
                    RegArg ra = (RegArg)pline.instr;
                    if (ra.m != null)
                    {
                        ArgumentMemoryLocation m = (ArgumentMemoryLocation) ra.m;
                        int valAll = m.getOffset();
                        if (m.offsetExpression != null)
                        {
                            if (m.offsetExpression instanceof ExpressionSymbol)
                            {
                                ExpressionSymbol oe = (ExpressionSymbol) m.offsetExpression;
                                if (oe.getSymbol() != null)
                                {
                                    if (oe.getSymbol().value == valAll)
                                    {
                                        String symbol = oe.getSymbol().getName();
                        buf.append("FORCE_SYMBOL "+String.format("$%04X", (address))+" "+symbol+"\n");

                                    
                                    }
                                }
                                
                            }
                            else  if (m.offsetExpression instanceof ExpressionNumber)
                            {
                        buf.append("FORCE_NO_SYMBOL "+String.format("$%04X", (address))+"\n");

                            }
                                
                        }
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
            int len = getConsecutiveType(mem.current, i, type, symtab);
            if (len == 0)
            {
                i++;
                continue;
            }
            if (correctDataOption)
            {
                // out
                if ((type == Memory.MEM_BYTE_DATA))
                {
                    buf.append("RANGE "+String.format("$%04X", (i&0xffff))+"-"+String.format("$%04X", ((i+len)&0xffff))+" DB_DATA "+len+"\n");
                }
                else if ((type == Memory.MEM_CHAR_DATA))
                {
                    buf.append("RANGE "+String.format("$%04X", (i&0xffff))+"-"+String.format("$%04X", ((i+len)&0xffff))+" CHAR_DATA "+len+"\n");
                }
                else if ((type == Memory.MEM_WORD_DATA))
                {
                    buf.append("RANGE "+String.format("$%04X", (i&0xffff))+"-"+String.format("$%04X", ((i+len)&0xffff))+" DW_DATA "+(len/2)+"\n");
                }
                else if ((type == Memory.MEM_CODE))
                {
                    buf.append("RANGE "+String.format("$%04X", (i&0xffff))+"-"+String.format("$%04X", ((i+len)&0xffff))+" CODE"+"\n");
                }
            }
            else
            {
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
            line.addErrorMessage( line.fileName+"("+line.lineNumber+")" + ":  " + errmsg );
    }
    public static void warning( SourceLine line, String errmsg ) {
        if (line != null)    
            line.addWarningMessage( line.fileName+"("+line.lineNumber+")" + ":  " + errmsg );
        else
            line.addWarningMessage( "Unkown source:  " + errmsg );
        
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
    
    public static int LI_UNKOWN = 0;
    public static int LI_BYTE = 1;
    public static int LI_WORD = 3;
    public static int LI_STRING = 4;
    static class LineInfo
    {
        int startAddress=0;
        int lenInBytes = 0;
        int type = LI_UNKOWN;
        LineInfo(int a, int l, int t)
        {
            startAddress = a;
            lenInBytes = l;
            type = t;
            
        }
    }
    static HashMap<Integer, LineInfo> lineInfos;
    static boolean correctDataOption = true;
    public static void clearLineInfo()
    {
        lineInfos = new HashMap<Integer, LineInfo>();
    }
    public static void addLineInfo(int address, int lengthInByte, int type)
    {
        LineInfo li = new LineInfo(address, lengthInByte, type);
        lineInfos.put(address, li);
    }

    
    static int maxData = 8;
    int getConsecutiveType(MemorySegment mem, int address, int type, SymbolTable symtab)
    {
        int addressOrg = address;
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

        if ((!correctDataOption) || (type == Memory.MEM_CODE))
            return len;
        LineInfo li = lineInfos.get(addressOrg);
        if (li == null)
        {
            // whatever comes first
            // len = 8
            // another LI
            // a label definition
            for (int i=1; i<len; i++)
            {
                li = lineInfos.get(addressOrg+i);
                if (li != null) return i;
                if (hasLabelDefinition(addressOrg+i, symtab)) return i;
            }
            if (len > maxData) return maxData;
            return len;
        }
        return li.lenInBytes;
    }
    static boolean hasLabelDefinition(int address, SymbolTable symtab)
    {
        return symtab.find(address) != null;
    }
    
}

