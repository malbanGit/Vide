// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class represents a macro.
// It is used to hold the source lines of the macro's definition, and
// to expand that definition by the argument list when it is referred to.
//
// It also keeps track of all defined macros statically, and allows
// lookups in that list.
package de.malban.vide.assy;

import de.malban.vide.assy.exceptions.AlreadyExistsException;
import java.util.Vector;
import java.util.ArrayList;
import java.util.HashMap;

public class Macro {
    static final String digits = "0123456789";
    static final String escape1 = "&";
    static final String escape2 = "\\";

    static Vector /* of Macro */ allMacros;
    static int macroInvocationNum = 0;

    Vector /* of SourceLine */ source;
    String name;
    int firstLineNum;

    // Forget all macro definitions
    public static void reset() {
        allMacros = new Vector();
        macroInvocationNum = 0;
    }

    // Look up a defined macro by name
    public static Macro find( String name ) 
    {
        for (int i=0; i<allMacros.size(); i++) 
        {
            Macro m = (Macro)allMacros.elementAt(i);
            if (m.getName().equals(name)) 
            {
                return m;
            }
        }
        return null;
    }

    // Begin (re)defining the named macro.
    public static Macro set( String n, int ln, SourceLine sn ) 
    {
        Macro m = find(n);
        if (m == null) 
        {
            try { m = new Macro(n,ln); }
            catch (AlreadyExistsException x) { /* bug */ }
        } else {
                m.firstLineNum = ln;
                m.source = new Vector();
        }
        
        //fill symbols
        
        String[] symbols = sn.rest.split(",");
        for(int i=0;i<symbols.length; i++)
        {
            String sym = symbols[i].trim();
            m.nameToIntSymbol.put(sym, i+1); // symbol 0 is special!
            m.intToNameSymbol.put(i+1, sym); // symbol 0 is special!
            m.macroSymbols.add(sym);
            m.hasArgsDefined = true;
        }
        
        return m;
    }
    HashMap<String, Integer> nameToIntSymbol = new HashMap<String, Integer>();
    HashMap<Integer, String> intToNameSymbol = new HashMap<Integer, String>();
    ArrayList<String> macroSymbols = new ArrayList<String>();
    ArrayList<String> localSymbols = new ArrayList<String>();
    boolean hasArgsDefined = false;

    public Macro( String n, int ln ) throws AlreadyExistsException 
    {
        Macro m = find(n);
        if (m != null) { throw new AlreadyExistsException(n); }
        name = n;
        firstLineNum = ln;
        source = new Vector();
        allMacros.addElement(this);
    }

    public String getName() { return name; }

    public void addLine( Object x ) 
    {
        // malban
        // preprocess Macro for a "local" keyword!
        SourceLine pl = (SourceLine)x;
        String line = pl.inputLine;
        line = Comment.removeEndOfLineComment(line);
        
        int i = line.toLowerCase().indexOf(" local ");
        if (i < 0) i = line.toLowerCase().indexOf("\tlocal ");
        if (i < 0) i = line.toLowerCase().indexOf("\tlocal\t");
        if (i < 0) i = line.toLowerCase().indexOf(" local\t");
        
        if (i>=0)
        {
            //if (de.malban.util.UtilityString.isWordBoundry(line.charAt(i+7)))
            {
                String sym = line.substring(i+7).trim();
                // yep, here we go, a local def
                // now comma seperate them
                String[] locals = sym.split(",");
                for (String ls : locals)
                {
                    if (!localSymbols.contains(ls.trim()))
                        localSymbols.add(ls.trim());
                }
                
                return; // don't att source line
            }
        }
        else
        {
            for (int ii=0; ii<localSymbols.size(); ii++)
            {
                String sym = localSymbols.get(ii);
                String line2 = de.malban.util.UtilityString.replace(line, sym, sym+"\\?", true);
                if (!line2.equals(line))
                {
                    // change pl
                    pl.inputLine = de.malban.util.UtilityString.replace(pl.inputLine, sym, sym+"\\?", true);
                    pl.label = de.malban.util.UtilityString.replace(pl.label, sym, sym+"\\?", true);
                    pl.op = de.malban.util.UtilityString.replace(pl.op, sym, sym+"\\?", true);
                    pl.rest = de.malban.util.UtilityString.replace(pl.rest, sym, sym+"\\?", true);
                }
            }
        }
            
        
        source.addElement( x ); 
    }

    public Vector /* of SourceLine */ expandSource( SourceLine p ) 
    {
        macroInvocationNum += 1;

        int depth = p.getMacroDepth() + 1;
        SourceLine p0, p1;
        Vector exp = new Vector();
        String label = (p.label != null)? p.label  :"";

        // Parse "label,arg1,arg2,...,argN".
        // But if N==0, we don't want the comma after label.
        String argList = label;
        if ( p.rest.length()>0 &&   ! Character.isWhitespace(p.rest.charAt(0)) ) 
        {
            argList += "," + p.rest;
        }

        Vector args = ParseString.parseArgs(argList);
        // first argument is empty label!
        if (argList.trim().startsWith(","))
        {
            Vector args2 = new Vector();
            args2.addElement( "" );
            for (Object ss: args)
                args2.add(ss);
            args = args2;
        }
        if (args.size()==0)
        {
            // at least an empty label
            args.add("");
        }
        
        // the first argument ist something like ",u"
        // than we also need an empty argument!
        if (p.rest.trim().startsWith(","))
        {
            Vector args2 = new Vector();
            int c= 0;
            for (Object ss: args)
            {
                c++;
                if (c==2)
                {
                    args2.add(","+ss);
                }
                else
                args2.add(ss);
            }
            args = args2;
        }
        for (int i=0; i<source.size(); i++) 
        {
            p0 = (SourceLine)source.elementAt(i);
            p1 = expandSourceLine( p0, args );
            p1.setMacroDepth( depth );
            p1.endOfLineComment = p0.endOfLineComment;
            p1.fullLineComment = p0.fullLineComment;
//            p1.dp_value = p0.dp_value; // not sure if this is allways correct! but 
            p1.setFilename( "MACRO-EXPAND from " +p1.fileName);
            exp.addElement(p1);
        }

        return exp;
    }

    private SourceLine expandSourceLine( SourceLine p0, Vector args ) 
    {
        SourceLine p1 = new SourceLine(p0);
        p1.setInputLine( expand(p0.getInputLine(),args) );
        p1.setLabel(     expand(p0.getLabel(),    args) );
        p1.setOp(        expand(p0.getOp(),       args) );
        p1.setRest(      expand(p0.getRest(),     args) );
        return p1;
    }

    private String expand( String s, Vector args ) 
    {

        if (s == null) { return s; }

        String allArgs = "";
        for (int i=1; i<args.size(); i++) {
                if (i!=1) { allArgs += ","; }
                allArgs += (String)args.elementAt(i);
        }

        // substitute args
        StringBuffer b = new StringBuffer();
        int p0 = 0;

        String escape = escape1;
        if (s.indexOf(escape1)>0)
        {
            escape = escape1;
        }
        if (s.indexOf(escape2)>0)
        {
            escape = escape2;
        }
        if (hasArgsDefined)
        {
            escape = escape2;
            for (int ms =0; ms<macroSymbols.size(); ms++)
            {
                // replace names with numbers, makes live easier...
                s = de.malban.util.UtilityString.replace(s, macroSymbols.get(ms), "\\"+(ms+1), true);
            }
            /* above takes care of it
            if (intToNameSymbol.size()>0)
            {
                for (int i=1; i<args.size(); i++) 
                {
                    String to = (String)args.elementAt(i);
                    String from = intToNameSymbol.get(i);
                    if (from != null)
                    {
                        s = de.malban.util.UtilityString.replace(s, from, to, true);
                    }
                }
                
            }
            */
        }
        
        if (escape.equals(escape1))
        {
            while (p0 < s.length()) 
            {
                // copy string up to escape
                int p1 = (s+escape).indexOf(escape,p0);
                b.append( s.substring(p0,p1) );
                if (p1 >= s.length()) { break; }

                // get arg value
                String arg;
                char ch = s.charAt(p1+1);
                if (ch == '@') 
                {
                    // unique number for this macro expansion
                    arg = "" + macroInvocationNum;
                    p0 = p1+2;
                } else if (ch == ',') 
                {
                    // nothing
                    arg = "";
                    p0 = p1+2;
                } else if (ch == '*') 
                {
                    // all arguments
                    arg = allArgs;
                    p0 = p1+2;
                } else if (ch == '#') 
                {
                    // number of arguments
                    arg = "" + (args.size() - 1);
                    p0 = p1+2;
                } else if (digits.indexOf(ch) >= 0) 
                {
                    int n = 0;
                    for (p0=p1+1; p0<s.length(); p0++) 
                    {
                            ch = s.charAt(p0);
                            int d = digits.indexOf(ch);
                            if (d<0) { break; }
                            n = 10*n + d;
                    }
                    if (n<args.size()) 
                    {
                            arg = (String)args.elementAt(n);
                    } 
                    else 
                    {
                            arg = ""; // non-existant arg
                    }
                } 
                else 
                {
                    // some other character followed the escape
                    arg = "" + ch;
                    p0 = p1+2;
                }

                // copy arg value
                b.append( arg );
            }            
        }
        else
        {   
                
            // Malban, escape like AS09 \\ rather than &
            // &# = \0
            // &@ = \?
            
            
            while (p0 < s.length()) 
            {
                // copy string up to escape
                int p1 = (s+escape).indexOf(escape,p0);
                b.append( s.substring(p0,p1) );
                if (p1 >= s.length()) { break; }

                // get arg value
                String arg;
                char ch = s.charAt(p1+1);
                if (ch == '?') 
                {
                    // unique number for this macro expansion
                    arg = "" + macroInvocationNum;
                    p0 = p1+2;
                } else if (ch == ',') 
                {
                    // nothing
                    arg = "";
                    p0 = p1+2;
                } else if (ch == '*') 
                {
                    // all arguments
                    arg = allArgs;
                    p0 = p1+2;
                } else if (ch == '0') 
                {
                    // number of arguments
                    arg = "" + (args.size() - 1);
                    p0 = p1+2;
                } 
                else if (digits.indexOf(ch) >= 0) 
                {
                    int n = 0;
                    for (p0=p1+1; p0<s.length(); p0++) 
                    {
                            ch = s.charAt(p0);
                            int d = digits.indexOf(ch);
                            if (d<0) { break; }
                            n = 10*n + d;
                    }
                    if (n<args.size()) 
                    {
                            arg = (String)args.elementAt(n);
                    } 
                    else 
                    {
                            arg = ""; // non-existant arg
                    }
                } 
                else 
                {
                    // some other character followed the escape
                    arg = "" + ch;
                    p0 = p1+2;
                }

                // copy arg value
                b.append( arg );
            }                     
        }

        //System.out.println(" -> '"+b.toString()+"'");
        return b.toString();
    }

}

