// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This mimics the Hashtable class.  Instruction objects can be retrieved
// by get() with the mnemonic (String) as the key.  Each such Instruction
// is a new instance, and can be relied on to keep its own state.  (Ie:
// future calls will not return that same object expecting it to be re-used.)
package de.malban.vide.assy.instructions;

import java.util.Hashtable;


public class InstructionSet extends Hashtable 
{

    static final String // instruction group names
            INHERENT  = "Inherent",
            BRANCH    = "Branch",
            SINGLEARG = "SingleArg",
            REGARG    = "RegArg",
            STACK     = "Stack",
            REGREG    = "RegReg",
            asmj_else = "asmj_else",
            asmj_if   = "asmj_if",
            elseif    = "elseif",
            end       = "end",
            endif     = "endif",
            endm      = "endm",
            equ       = "equ",
            error     = "error",
            exitm     = "exitm",
            fcb       = "fcb",
            fcc       = "fcc",
            fdb       = "fdb",
            ifdef     = "ifdef",
            ifndef    = "ifndef",
            ifeq      = "ifeq",
            ifneq     = "ifneq",
            include   = "include",
            org       = "org",
            psmacro   = "psmacro",
            direct    = "direct",
            rmb       = "rmb",
            noopt     = "noopt",
            opt       = "opt",
            data      = "data",
            list      = "list",
            nolist    = "nolist",
            title     = "title",
            page      = "page",
            align     = "align",
            code      = "code",
            bss       = "bss",
            bank      = "bank",
            multibank = "64kBanked",
            struct    = "struct",
            cmap      = "cmap";

    
    
    // find an instruction group's class
    static final Hashtable groupmap = new Hashtable();
    static {
            groupmap.put( INHERENT,  Inherent.class  );
            groupmap.put( BRANCH,    Branch.class    );
            groupmap.put( SINGLEARG, SingleArg.class );
            groupmap.put( REGARG,    RegArg.class    );
            groupmap.put( STACK,     Stack.class    );
            groupmap.put( REGREG,    RegReg.class    );


            groupmap.put( asmj_else,    asmj_else.class    );
            groupmap.put( asmj_if,    asmj_if.class    );
            groupmap.put( elseif,    elseif.class    );
            groupmap.put( end,    end.class    );
            groupmap.put( endif,    endif.class    );
            groupmap.put( endm,    endm.class    );
            groupmap.put( equ,    equ.class    );
            groupmap.put( error,    error.class    );
            groupmap.put( exitm,    exitm.class    );
            groupmap.put( fcb,    fcb.class    );
            groupmap.put( fcc,    fcc.class    );
            groupmap.put( fdb,    fdb.class    );
            groupmap.put( ifdef,    ifdef.class    );
            groupmap.put( ifndef,    ifndef.class    );
            groupmap.put( ifeq ,    ifeq.class    );
            groupmap.put( ifneq ,    ifneq.class    );
            groupmap.put( include,    include.class    );
            groupmap.put( org ,    org.class    );
            groupmap.put( psmacro,    psmacro.class    );
            groupmap.put( direct,    direct.class    );
            groupmap.put( noopt,    noopt.class    );
            groupmap.put( opt,    opt.class    );
            groupmap.put( data,    data.class    );
            groupmap.put( code,    code.class    );
            groupmap.put( bss,    bss.class    );
            groupmap.put( rmb,    rmb.class    );
            groupmap.put( list,    list.class    );
            groupmap.put( nolist,    nolist.class    );
            groupmap.put( title,    title.class    );
            groupmap.put( page,    page.class    );
            groupmap.put( align,    align.class    );
            groupmap.put( struct,    struct.class    );
            groupmap.put( bank,    bank.class    );
            groupmap.put( cmap,    cmap.class    );
    }

    // During initialization, we will load this info into a Hashtable,
    // replacing the String classname with the named Class object.
    // Instruction objects will be made by calling newInstance() on
    // that.
    static final Object instructionSet[] = {
            "abx",     "Inherent", "3a",   "0", "",
            "cwai",    "RegArg",   "3c",   "1", "dxe", // malban was inherent, but is 1 arg (immediate)
            "daa",     "Inherent", "19",   "0", "",
            "mul",     "Inherent", "3d",   "0", "",
            "nop",     "Inherent", "12",   "0", "",
            "rti",     "Inherent", "3b",   "0", "",
            "rts",     "Inherent", "39",   "0", "",
            "sex",     "Inherent", "1d",   "0", "",
            "swi",     "Inherent", "3f",   "0", "",
            "swi2",    "Inherent", "103f", "0", "",
            "swi3",    "Inherent", "113f", "0", "",
            "sync",    "Inherent", "13",   "0", "",

            "asla",    "Inherent", "48", "0", "",
            "asra",    "Inherent", "47", "0", "",
            "clra",    "Inherent", "4f", "0", "",
            "coma",    "Inherent", "43", "0", "",
            "deca",    "Inherent", "4a", "0", "",
            "inca",    "Inherent", "4c", "0", "",
            "lsla",    "Inherent", "48", "0", "",
            "lsra",    "Inherent", "44", "0", "",
            "nega",    "Inherent", "40", "0", "",
            "rola",    "Inherent", "49", "0", "",
            "rora",    "Inherent", "46", "0", "",
            "tsta",    "Inherent", "4d", "0", "",

            "aslb",    "Inherent", "58", "0", "",
            "asrb",    "Inherent", "57", "0", "",
            "clrb",    "Inherent", "5f", "0", "",
            "comb",    "Inherent", "53", "0", "",
            "decb",    "Inherent", "5a", "0", "",
            "incb",    "Inherent", "5c", "0", "",
            "lslb",    "Inherent", "58", "0", "",
            "lsrb",    "Inherent", "54", "0", "",
            "negb",    "Inherent", "50", "0", "",
            "rolb",    "Inherent", "59", "0", "",
            "rorb",    "Inherent", "56", "0", "",
            "tstb",    "Inherent", "5d", "0", "",

            "asl",     "SingleArg", "08", "1", "",
            "asr",     "SingleArg", "07", "1", "",
            "clr",     "SingleArg", "0f", "1", "",
            "com",     "SingleArg", "03", "1", "",
            "dec",     "SingleArg", "0a", "1", "",
            "inc",     "SingleArg", "0c", "1", "",
            "jmp",     "SingleArg", "0e", "1", "",
            "lsl",     "SingleArg", "08", "1", "",
            "lsr",     "SingleArg", "04", "1", "",
            "neg",     "SingleArg", "00", "1", "",
            "rol",     "SingleArg", "09", "1", "",
            "ror",     "SingleArg", "06", "1", "",
            "tst",     "SingleArg", "0d", "1", "",

            "adca",    "RegArg",    "89", "1", "",
            "adda",    "RegArg",    "8b", "1", "",
            "anda",    "RegArg",    "84", "1", "",
            "bita",    "RegArg",    "85", "1", "",
            "cmpa",    "RegArg",    "81", "1", "",
            "eora",    "RegArg",    "88", "1", "",
            "lda",     "RegArg",    "86", "1", "",
            "jsr",     "RegArg",    "8d", "1", "",
            "ora",     "RegArg",    "8a", "1", "",
            "sbca",    "RegArg",    "82", "1", "",
            "sta",     "RegArg",    "87", "1", "i",
            "suba",    "RegArg",    "80", "1", "",

            "adcb",    "RegArg",    "c9", "1", "",
            "addb",    "RegArg",    "cb", "1", "",
            "andb",    "RegArg",    "c4", "1", "",
            "bitb",    "RegArg",    "c5", "1", "",
            "cmpb",    "RegArg",    "c1", "1", "",
            "eorb",    "RegArg",    "c8", "1", "",
            "ldb",     "RegArg",    "c6", "1", "",
            "orb",     "RegArg",    "ca", "1", "",
            "sbcb",    "RegArg",    "c2", "1", "",
            "stb",     "RegArg",    "c7", "1", "I",
            "subb",    "RegArg",    "c0", "1", "",

            "cmpx",    "RegArg",    "8c",   "2", "",
            "ldx",     "RegArg",    "8e",   "2", "",
            "stx",     "RegArg",    "8f",   "2", "i",
            "leax",    "RegArg",    "10",   "2", "ide",

            "cmpy",    "RegArg",    "108c", "2", "",
            "ldy",     "RegArg",    "108e", "2", "",
            "sty",     "RegArg",    "108f", "2", "i",
            "leay",    "RegArg",    "11",   "2", "ide",

            "cmps",    "RegArg",    "118c", "2", "",
            "lds",     "RegArg",    "10ce", "2", "",
            "sts",     "RegArg",    "10cf", "2", "i",
            "leas",    "RegArg",    "12",   "2", "ide",

            "cmpu",    "RegArg",    "1183", "2", "",
            "ldu",     "RegArg",    "ce",   "2", "",
            "stu",     "RegArg",    "cf",   "2", "i",
            "leau",    "RegArg",    "13",   "2", "ide",

            "cmpd",    "RegArg",    "1083", "2", "",
            "ldd",     "RegArg",    "cc",   "2", "",
            "std",     "RegArg",    "cd",   "2", "I",
            "addd",    "RegArg",    "c3",   "2", "",
            "subd",    "RegArg",    "83",   "2", "",

            "andcc",   "RegArg",    "1c",  "1", "dxe",
            "orcc",    "RegArg",    "1a",  "1", "dxe",

            "exg",     "RegReg",    "1e",  "1", "",
            "tfr",     "RegReg",    "1f",  "1", "",

            "pshs",    "Stack",     "34",  "1", "S",
            "puls",    "Stack",     "35",  "1", "S",
            "pshu",    "Stack",     "36",  "1", "U",
            "pulu",    "Stack",     "37",  "1", "U",

            "bcc",     "Branch",    "24", "1", "",
            "bcs",     "Branch",    "25", "1", "",
            "beq",     "Branch",    "27", "1", "",
            "bge",     "Branch",    "2c", "1", "",
            "bgt",     "Branch",    "2e", "1", "",
            "bhi",     "Branch",    "22", "1", "",
            "bhs",     "Branch",    "24", "1", "",
            "ble",     "Branch",    "2f", "1", "",
            "blo",     "Branch",    "25", "1", "",
            "bls",     "Branch",    "23", "1", "",
            "blt",     "Branch",    "2d", "1", "",
            "bmi",     "Branch",    "2b", "1", "",
            "bne",     "Branch",    "26", "1", "",
            "bpl",     "Branch",    "2a", "1", "",
            "bra",     "Branch",    "20", "1", "",
            "brn",     "Branch",    "21", "1", "",
            "bsr",     "Branch",    "8d", "1", "",
            "bvc",     "Branch",    "28", "1", "",
            "bvs",     "Branch",    "29", "1", "",

            "lbcc",    "Branch",    "1024", "2", "",
            "lbcs",    "Branch",    "1025", "2", "",
            "lbeq",    "Branch",    "1027", "2", "",
            "lbge",    "Branch",    "102c", "2", "",
            "lbgt",    "Branch",    "102e", "2", "",
            "lbhi",    "Branch",    "1022", "2", "",
            "lbhs",    "Branch",    "1024", "2", "",
            "lble",    "Branch",    "102f", "2", "",
            "lblo",    "Branch",    "1025", "2", "",
            "lbls",    "Branch",    "1023", "2", "",
            "lblt",    "Branch",    "102d", "2", "",
            "lbmi",    "Branch",    "102b", "2", "",
            "lbne",    "Branch",    "1026", "2", "",
            "lbpl",    "Branch",    "102a", "2", "",
            "lbra",    "Branch",    "16",   "2", "",
            "lbrn",    "Branch",    "1021", "2", "",
            "lbsr",    "Branch",    "17",   "2", "",
            "lbvc",    "Branch",    "1028", "2", "",
            "lbvs",    "Branch",    "1029", "2", "",

            "if",      "asmj_if",   "", "0", "",
            "else",    "asmj_else", "", "0", "",
            "elseif",  "elseif",    "", "0", "",
            "end",     "end",       "", "0", "",
            "endif",   "endif",     "", "0", "",
            "endm",    "endm",      "", "0", "",
            "equ",     "equ",       "", "0", "",
            "=",       "equ",       "", "0", "",
            "error",   "error",     "", "0", "",
            "exitm",   "exitm",     "", "0", "",
            "fcb",     "fcb",       "", "0", "",
            "db",      "fcb",       "", "0", "",
            "fcc",     "fcc",       "", "0", "",
            "fdb",     "fdb",       "", "0", "",
            "dw",      "fdb",       "", "0", "",
            "ifdef",   "ifdef",     "", "0", "",
            "ifeq",    "ifeq",      "", "0", "",
            "ifndef",  "ifndef",    "", "0", "",
            "ifneq",   "ifneq",     "", "0", "",
            "include", "include",   "", "0", "",
            "macro",   "psmacro",   "", "0", "",
            "org",     "org",       "", "0", "",
            "direct",  "direct",    "", "0", "",
            "noopt",   "noopt",     "", "0", "",
            "opt",     "opt",       "", "0", "",
            "data",    "data",      "", "0", "",
            "code",    "code",      "", "0", "",
            "bss",     "bss",       "", "0", "",
            "rmb",     "rmb",       "", "0", "",

            "struct",  "struct",    "", "0", "",
            "list",    "list",      "", "0", "",
            "nolist",  "nolist",    "", "0", "",
            "title",   "title",     "", "0", "",
            "page",    "page",      "", "0", "",
            "align",   "align",     "", "0", "",
            "bank",    "bank",      "", "0", "",
            "cmap",    "cmap",      "", "0", "",
            
            "ds",      "rmb",       "", "0", "",
            "fcw",     "fdb",       "", "0", ""
            
            
            
    };

    public InstructionSet() 
    {
        String mnemonic_s, class_s, opcode_s, datalen_s, restriction_s;
        int opcode = 0, datalen = 0, opcodelen = 0;
        Class instrClass = null;

        for (int i=0; i<instructionSet.length; i+=5) 
        {
            mnemonic_s    = (String)instructionSet[i];
            class_s       = (String)instructionSet[i+1];
            opcode_s      = (String)instructionSet[i+2];
            datalen_s     = (String)instructionSet[i+3];
            restriction_s = (String)instructionSet[i+4];

            try 
            {
                instrClass = (Class)groupmap.get(class_s);
                if (instrClass == null) 
                {
                    instrClass = Class.forName(class_s);
                }
                if (instrClass==null) 
                { 
                    throw new Exception(); 
                }
                opcodelen = opcode_s.length()/2;
                if (opcodelen > 0) 
                {
                    opcode = Integer.parseInt(opcode_s,16);
                }
                if (datalen_s.length() > 0) 
                {
                    datalen = Integer.parseInt(datalen_s);
                }
            } 
            catch (Exception x) 
            {
                    // NumberFormatException/ClassNotFoundException
                    System.err.println( "Error in "+mnemonic_s +" class:" + class_s);
                    x.printStackTrace();
                    System.exit(1);
            }

            InstructionDetails details = new InstructionDetails( mnemonic_s, instrClass, opcode, opcodelen, datalen, restriction_s.toLowerCase() );

            put( mnemonic_s, details );
        }
    }

    public Object get( Object mnemonic_x ) 
    {
        String mnemonic = ((String)mnemonic_x).toLowerCase();
        // look up the info for this mnemonic
        InstructionDetails d = (InstructionDetails)super.get(mnemonic);
        if (d == null) { return null; }
        // make an instance of the appropriate class
        Instruction i = null;
        try { i = (Instruction)d.instructionClass.newInstance(); }
        catch (Exception x) 
        {
            // InstantiationException, IllegalAccessException
            System.out.println( "Error in "+d.toString() );
            x.printStackTrace();
            System.exit(1);
        }
        // if the class designates an instruction group, parameterize it
        if (i instanceof InstructionGroup) 
        {
            d.parameterize( (InstructionGroup)i );
        }
        return i;
    }

    private class InstructionDetails 
    {
        public String mnemonic, restrictions;
        public Class instructionClass;
        public int opcode, opcodelength, datalength;

        public InstructionDetails(
                String m, Class c, int o, int p, int d, String r )
        {
                this.mnemonic         = m;
                this.instructionClass = c;
                this.opcode           = o;
                this.opcodelength     = p;
                this.datalength       = d;
                this.restrictions     = r;
        }

        public void parameterize( InstructionGroup g ) {
                g.setDetails(
                        mnemonic, opcode, opcodelength,
                        datalength, restrictions
                );
        }

        public String toString() {
                return "{"
                        + mnemonic + ","
                        + instructionClass + ","
                        + opcode + ","
                        + opcodelength + ","
                        + datalength + ","
                        + "'" + restrictions + "'}";
        }
    }

}
