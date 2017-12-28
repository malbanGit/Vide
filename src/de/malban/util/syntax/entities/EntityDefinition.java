/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util.syntax.entities;

import static de.malban.util.syntax.entities.ASM6809File.ENTITY_CHANGED;
import static de.malban.util.syntax.entities.ASM6809File.ENTITY_DELETED;
import static de.malban.util.syntax.entities.ASM6809File.ENTITY_UNCHANGED;
import de.malban.vide.dissy.DASM6809;
import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class EntityDefinition
{
    private EntityDefinition()  { }

    private static int _UID=0;
    private final int uid = (_UID++);
    int getUID()
    {
        return uid;
    }
    
    public static int TYP_MACRO = 1;
    public static int TYP_LABEL = 2;  // also for struct!
    public static int TYP_INCLUDE = 3;
    public static int TYP_MACRO_PARAM = 4;

    public static int TYP_CFUNCTION = 5;  // also for struct!
    public static int TYP_LIB_INCLUDE = 6;  // also for struct!
    
    
    // subtypes for labels
    public static int SUBTYPE_NO_LABEL = 0;
    public static int SUBTYPE_EQU_LABEL = 1;
    public static int SUBTYPE_DEFINED_LABEL = 2;
    public static int SUBTYPE_SET_LABEL = 3;
    public static int SUBTYPE_STRUCT_LABEL = 4;
    public static int SUBTYPE_INSTRUCT_LABEL = 5;
    public static int SUBTYPE_LINE_LABEL = 6;                                        
    public static int SUBTYPE_DATA_LABEL = 7;                                        
    public static int SUBTYPE_INNER_MACRO_LABEL = 8;                                        
    public static int SUBTYPE_FUNCTION_LABEL = 9;                                        
    public static int SUBTYPE_VERIFIED_FUNCTION_LABEL = 10;                                        
    public static int SUBTYPE_MACRO_DEFINITION_LABEL = 11; 
    public static int SUBTYPE_MACRO_PARAMETER_LABEL = 12; 
    

    public static String[] SUBTYPE_NAMES = {
        "unkown",
        "equ",
        "=",
        "set",
        "struct",
        "in struct",
        "line",
        "data",
        "macro",
        "function",
        "user", 
        "macro def",
        "macro par"
    };
    
    private int status = ENTITY_DELETED;
    ASM6809File file;
    C6809File cfile;
    public C6809File getCFile()
    {
        return cfile;
    }
    public ASM6809File getFile()
    {
        return file;
    }
    public int getLineNumber()
    {
        String ln = orgLine.substring(orgLine.lastIndexOf(";")+1);
        return Integer.parseInt(ln)+1;
    }
    /*
    public int setLineNumber(int ln)
    {
        orgLine = orgLine.substring(0, orgLine.lastIndexOf(";"));
        orgLine = orgLine+";"+ln;
//        String ln = orgLine.substring(orgLine.lastIndexOf(";")+1);
//        return Integer.parseInt(ln)+1;
    }
    */
    public String getOrgLine()
    {
        return orgLine.substring(0,orgLine.lastIndexOf(";"));
    }
    public String getValue()
    {
        return value;
    }
    public int getType()
    {
        return type;
    }
    public int getSubType()
    {
        return subtype;
    }
    public String getName()
    {
        return name;
    }
    
            
    
    int lineNumber = -1; // line in ArrayList of ASM6809FileInfo
    String orgLine;
    String name="";     // macro, label name, include filename
    String value;    // label, the expressio, macro parameters, include ... nothing
    ArrayList<String> parameter; // default non = null, only set if macro has parameters
    ArrayList<String> previousParameter; // default non = null, only set if macro has parameters
    int type;
    int subtype = SUBTYPE_NO_LABEL;
    String previousOrgLine;
    String previousName;
    String previousValue;
    int previousType;
    boolean isStructStart = false;
    boolean isStructEnd = false;
    boolean isMacroStart = false;
    boolean isMacroEnd = false;
    
    // return null, if no known entity was found
    public static EntityDefinition scanLine(ASM6809File _file, String _orgLine)
    {
        if (_orgLine==null) return null;
        EntityDefinition entity = new EntityDefinition();
        entity.file = _file;
        entity.processLine(_orgLine);
        return entity;
    }
    // return null, if no known entity was found
    public static EntityDefinition scanLine(C6809File _file, String _orgLine)
    {
        if (_orgLine==null) return null;
        EntityDefinition entity = new EntityDefinition();
        entity.cfile = _file;
        entity.processCLine(_orgLine);
        return entity;
    }

    public int getStatus()
    {
        return status;
    }
    public void setStatus(int s)
    {
        status = s;
    }
    
    public int updateEntity(String line)
    {
        status = ENTITY_UNCHANGED;
        if (cfile != null) 
            processCLine(line);
        else 
            processLine(line);
        return status;
    }
    
    // changed status
    private void processLine(String line)
    {
        previousOrgLine = orgLine;
        previousName = name;
        previousValue = value;
        previousType = type;
        previousParameter= parameter;
        
        boolean done = false;
        type = 0;
        name ="";
        parameter = null;
        isStructStart = false;
        isStructEnd = false;
        isMacroStart = false;
        isMacroEnd = false;
        
        orgLine = line;
        // remove comments
        line = removeComment(line, ";");
        line = removeComment(line, "*");
    
        if (line.trim().length()!=0)
        {
            // macro
            int pos = macroPos(line);
            if (pos !=-1)
            {
                done = true;
                type = TYP_MACRO;
                String[] split = line.trim().split("[ \\t,]");
                name = split[0].trim();
                if (name != null)
                {
                    if (pos+5<line.length())
                        value = line.substring(pos+5).trim();
                }
                else
                {
                    name = "";
                }
                if (split.length>1)
                {
                    parameter = new ArrayList();
                    for (int p = 2; p<split.length; p++)
                    {
                        String parm = split[p].trim();
                        if (parm.length()>0)
                            parameter.add(parm);
                        
                    }
                }
                
            }
            if (!done)
            {
                // include
                pos = includePos(line);
                if (pos !=-1)
                {
                    done = true;
                    type = TYP_INCLUDE;
                    String lineRest = line.substring(pos+7).trim();
                    name = getFirstFilename(lineRest);
                    if (name == null)
                    {
                        name = "";
                    }
                }
            }
            if (!done)
            {
                // equ
                pos = equPos(line);
                if (pos !=-1)
                {
                    done = true;
                    type = TYP_LABEL;
                    subtype = SUBTYPE_EQU_LABEL;
                    String lineRest = line.substring(pos+3).trim();
                    value = lineRest.trim();
                    String lineStart = line.substring(0, pos).trim();
                    name = getLastName(lineStart);
                    if (name == null)
                    {
                        name = "";
                    }
                    if (name.endsWith(":")) name = name.substring(0, name.length()-1);
                }
            }
            
            if (!done)
            {
                // =
                pos = equalPos(line);
                if (pos !=-1)
                {
                    done = true;
                    type = TYP_LABEL;
                    subtype = SUBTYPE_DEFINED_LABEL;
                    String lineRest = line.substring(pos+1).trim();
                    value = lineRest.trim();
                    String lineStart = line.substring(0, pos).trim();
                    name = getLastName(lineStart);
                    if (name == null)
                    {
                        name = "";
                    }
                }
            }
            if (!done)
            {
                // set
                pos = setPos(line);
                if (pos !=-1)
                {
                    done = true;
                    type = TYP_LABEL;
                    subtype = SUBTYPE_SET_LABEL;
    
                    String lineRest = line.substring(pos+3).trim();
                    value = lineRest.trim();
                    String lineStart = line.substring(0, pos).trim();
                    name = getLastName(lineStart);

                    if (name == null)
                    {
                        name = "";
                    }
                }
            }
            if (!done)
            {
                // struct
                pos = structPos(line);
                if (pos !=-1)
                {
                    done = true;
                    type = TYP_LABEL;
                    subtype = SUBTYPE_STRUCT_LABEL;
                    String lineRest = line.substring(pos+6).trim();
                    value = "struct - value not identified";
                    String[] splitter = lineRest.split(" ");
                    if (splitter.length >0)
                    {
                        name = splitter[0];
                    }
                    if (name == null)
                    {
                        name = "";
                    }
                }
            }    
            if (!done)
            {
                if (inStruct())
                {
                    // db, ds, dw (in struct)
                    pos = dbPos(line);
                    if (pos == -1) pos = dwPos(line);
                    if (pos == -1) pos = dsPos(line);
                    
                    if (pos !=-1)
                    {
                        done = true;
                        String lineRest = line.substring(pos+2).trim();
                        String[] splitter = lineRest.split("[ \\t,]");
                        if (splitter.length >0)
                        {
                            name = splitter[0];
                            // test if just a number
                            int number = DASM6809.toNumber(name);
                            if (number != 0)
                            {
                                // no label!
                                name = null;
                                done = false;
                            }
                            else
                            {
                                type = TYP_LABEL;
                                subtype = SUBTYPE_INSTRUCT_LABEL;
                                value = "struct - value not identified";
                            }
                        }
                        if (name == null)
                        {
                            name = "";
                        }
                    }
                }
            }
            if (!done)
            {
                if (inMacro())
                {
                    // must use orgline here,
                    // "line" has already been trimmed!
                    // linestart label
                    line = orgLine;
                    line = removeComment(line, ";");
                    line = removeComment(line, "*");
                    if (line.length()>0)
                    {
                        char start = line.charAt(0);
                        if (!((start == ' ') ||(start == '*')||(start == ';')||(start == '\t')) )
                        {
                            done = true;
                            type = TYP_LABEL;
                            subtype = SUBTYPE_INNER_MACRO_LABEL;
                            value = "line label";
                            name = getFirstName(line);
                            if (name == null)
                            {
                                name = "";
                            }
                            line = de.malban.util.UtilityString.replaceWhiteSpaces(line.toLowerCase(), " ");
                        }
                    }
                }
            }

            
            
            
            if (!done)
            {
                // must use orgline here,
                // "line" has already been trimmed!
                // linestart label
                line = orgLine;
                line = removeComment(line, ";");
                line = removeComment(line, "*");
                if (line.length()>0)
                {
                    char start = line.charAt(0);
                    if (!((start == ' ') ||(start == '*')||(start == ';')||(start == '\t')) )
                    {
                        done = true;
                        type = TYP_LABEL;
                        subtype = SUBTYPE_LINE_LABEL;
                        value = "line label";
                        name = getFirstName(line);
                        if (name == null)
                        {
                            name = "";
                        }
                        line = de.malban.util.UtilityString.replaceWhiteSpaces(line.toLowerCase(), " ");
                        if (line.contains("\\? ")) subtype = SUBTYPE_INNER_MACRO_LABEL;
                        if (line.contains("&@ ")) subtype = SUBTYPE_INNER_MACRO_LABEL;
                        if (line.contains("\\?: ")) subtype = SUBTYPE_INNER_MACRO_LABEL;
                        if (line.contains("&@: ")) subtype = SUBTYPE_INNER_MACRO_LABEL;
                        if (subtype == SUBTYPE_LINE_LABEL)
                            if (isDataLabel()) subtype = SUBTYPE_DATA_LABEL;
                        if (subtype == SUBTYPE_LINE_LABEL)
                            if (isPureFunctionCallLabel()) subtype = SUBTYPE_FUNCTION_LABEL;
                        
                        if (orgLine.toLowerCase().contains("#isfunction")) subtype = SUBTYPE_VERIFIED_FUNCTION_LABEL;
                        
                    }
                }
            }
        }
        if ((name.trim().length()==0) && (!isStructEnd)&& (!isMacroEnd))
        {
            status = ENTITY_DELETED;
            return;
        }
        if (name.equals(previousName)) 
        {
            status = ENTITY_UNCHANGED;
        }
        else
            status = ENTITY_CHANGED;
        return;
    }
    
    private int cincludePos(String line)
    {
        return searchPos(line.toLowerCase(), "#include", NORMAL);
    }
    private int includePos(String line)
    {
        return searchPos(line.toLowerCase(), "include", HALF_PURE);
    }
    private int macroPos(String line)
    {
        isMacroStart=false;
        int pos = searchPos(line.toLowerCase(), "macro", REALLY_PURE);
        
        // end struct does not count as struct :-)
        isMacroEnd=false;
        int pos2 = searchPos(line.toLowerCase(), "endm", PURE);
        if (pos2>=0)
        {
            isMacroEnd=true;
            return -1;
        }
        if (pos<0) return -1;
        isMacroStart=true;
        return pos;
    }
    private int equPos(String line)
    {
        return searchPos(line.toLowerCase(), "equ", REALLY_PURE);
    }
    private int equalPos(String line)
    {
        int pos = searchPos(line.toLowerCase(), "=", NORMAL);
        // check if "=" is part of an "if" clause
        int ifPos = line.toLowerCase().indexOf(" if ");
        if ((ifPos>=0) && (pos > ifPos)) return -1; 
        return pos;
    }
    private int setPos(String line)
    {
        return searchPos(line.toLowerCase(), "set", REALLY_PURE);
    }
    private int structPos(String line)
    {
        isStructStart=false;
        int pos = searchPos(line.toLowerCase(), "struct", PURE);
        // end struct does not count as struct :-)
        isStructEnd=false;
        int pos2 = searchPos(line.toLowerCase(), "end", PURE);
        if ((pos >=0 ) && (pos2>=0)) 
        {
            isStructEnd=true;
            return -1;
        }
        if (pos<0) return -1;
        isStructStart=true;
        return pos;
    }

    private int dbPos(String line)
    {
        return searchPos(line.toLowerCase(), "db", REALLY_PURE);
    }
    private int dsPos(String line)
    {
        return searchPos(line.toLowerCase(), "ds", REALLY_PURE);
    }
    private int dwPos(String line)
    {
        return searchPos(line.toLowerCase(), "dw", REALLY_PURE);
    }
    public static String removeComment(String s, String commentString)
    {
        int commentStart = searchPos(s.toLowerCase(), commentString, NORMAL);
        if (commentStart<0) return s;
        s=s.substring(0, commentStart);
        return s;
    }

    static final int PURE = 0; // terminated on both sides by a whitespace (but does not HAVE to be terminated at the end)
    static final int HALF_PURE = 1; // terminated on left side (start) by a whitespace
    static final int NORMAL = 2; // not terminated by anything
    static final int REALLY_PURE = 3; // must on both sides be terminated by whitespace
    
    private static String removeOneQuote(String wc)
    {
        int posDouble = wc.indexOf("\"");
        int posSingle = wc.indexOf("'");
        if (posSingle<0)posSingle = Integer.MAX_VALUE;
        if (posDouble<0)posDouble = Integer.MAX_VALUE;

        char quoteChar = 0;
        if (posDouble<posSingle)
            quoteChar = '\"';
        else
            quoteChar = '\'';

        wc = wc.substring(wc.indexOf(""+quoteChar)+1,wc.length());
        // wc start after opening quote

        int i=0;
        boolean found = false;
        boolean escapeFound = false;
        while (i<wc.length())
        {
            char c= wc.charAt(i);
            if (c == '\\')
            {
                if (!escapeFound)
                    escapeFound = true;
                else
                    escapeFound = false;
                i++;
                continue;
            }
            if (c == quoteChar)
            {
                if (!escapeFound)
                {
                    found = true;
                    break;
                }
            }
            i++;
            escapeFound = false;
        }
        if (found == false) return null; // string not terminated error!
        return wc.substring(i+1);
    }

    private static int reallyPurePos(String line, String search)
    {
        int pos =         line.indexOf(" "+search+" ");
        if (pos <0) pos = line.indexOf("\t"+search+" ");
        if (pos <0) pos = line.indexOf("\t"+search+"\t");
        if (pos <0) pos = line.indexOf(" "+search+"\t");
        if (pos <0) pos = line.indexOf("\t"+search+"\n");
        if (pos <0) pos = line.indexOf(" "+search+"\n");
        
        // check for end of line
        if (pos<0)
        {
            int cpos = line.indexOf(search);
            if (cpos >=0)
            {
                if (cpos+search.length() == line.length())
                {
                    cpos = line.indexOf(" "+search);
                    if (cpos <0) cpos = line.indexOf("\t"+search);
                    pos = cpos;
                }
            }
        }
        
        if (pos <0) return -1;
        return pos+1; // ignore leading WS
    }
    private static int purePos(String line, String search)
    {
        int pos =         line.indexOf(" "+search+" ");
        if (pos <0) pos = line.indexOf("\t"+search+" ");
        if (pos <0) pos = line.indexOf("\t"+search+"\t");
        if (pos <0) pos = line.indexOf(" "+search+"\t");
        if (pos <0) pos = line.indexOf("\t"+search+"\n");
        if (pos <0) pos = line.indexOf(" "+search+"\n");
        if (pos <0) pos = line.indexOf("\t"+search+"");
        if (pos <0) pos = line.indexOf(" "+search+"");
        if (pos <0) return -1;
        return pos+1; // ignore leading WS
    }
    private static int halfpurePos(String line, String search)
    {
        int pos = line.indexOf(" "+search);
        if (pos <0) pos = line.indexOf("\t"+search);
        if (pos <0) return -1;
        return pos+1; // ignore leading WS
    }
    private int purehalfPos(String line, String search)
    {
        int pos = line.indexOf(search+" ");
        if (pos <0) pos = line.indexOf(search+"\t");
        if (pos <0) return -1;
        return pos; 
    }
    
    private static int searchPos(String line, String search, int purePos)
    {
        String s= line;
        int posSemicolon = -1;
        if (purePos == REALLY_PURE)
            posSemicolon = reallyPurePos(s, search);
        if (purePos == PURE)
            posSemicolon = purePos(s, search);
        if (purePos == HALF_PURE)
            posSemicolon = halfpurePos(s, search);
        else if (purePos == NORMAL)
            posSemicolon = s.indexOf(search);

        if (posSemicolon<0)posSemicolon = Integer.MAX_VALUE;
        if (posSemicolon==Integer.MAX_VALUE) return -1;

        int posDouble = s.substring(0).indexOf("\"");
        int posSingle = s.substring(0).indexOf("'");
        if (posSingle<0)posSingle = Integer.MAX_VALUE;
        if (posDouble<0)posDouble = Integer.MAX_VALUE;

        if ((posSemicolon<posDouble) && (posSemicolon<posSingle))
        {
            return posSemicolon;
        }

        // now, we have a semicolon 
        // and we have open chars befor it!
        String wc = s.substring(0); // working copy

        boolean enough = false;
        do
        {
            wc = removeOneQuote(wc);
            if (wc == null)
            {
                return -1;
            }
            posDouble = wc.indexOf("\"");
            posSingle = wc.indexOf("'");
            posSemicolon = wc.indexOf(search);
            if (posSemicolon<0)posSemicolon = Integer.MAX_VALUE;
            if (posSemicolon==Integer.MAX_VALUE) return -1;
            if (posSingle<0)posSingle = Integer.MAX_VALUE;
            if (posDouble<0)posDouble = Integer.MAX_VALUE;
            enough = ((posSemicolon<posDouble) && (posSemicolon<posSingle));
        } while (!enough);
        // now we have string that contains somewhere a semicolon
        // and no opening chars befor it

        String semiString = wc.substring(wc.indexOf(search));
        return s.indexOf(semiString);
        
        
    }
    // next name without quotes
    // or inside quotes
    private String getFirstFilename(String line)
    {
        try
        {
            boolean hasDoubleQuotes = line.indexOf("\"")!=-1;
            boolean hasQuotes = line.indexOf("'")!=-1;

            if (hasDoubleQuotes)
            {
                String[] split = line.split("\"");
                if (split.length<2) return "";
                return split[1];
            }
            if (hasQuotes)
            {
                String[] split = line.split("'");
                if (split.length<2) return "";
                return split[1];
            }
            String[] split = line.split(" ");
            return split[0];
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
        return "";
    }
    private String getFirstCLibFilename(String line)
    {
        try
        {
            if (!line.contains("<")) return "";
            if (!line.contains(">")) return "";
            line = line.substring(line.indexOf("<")+1);
            line = line.substring(0,line.indexOf(">"));
            return line;
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
        return "";
    }    
    // last discernable "name" in line
    private String getLastName(String lineStart)
    {
        String[] split = lineStart.trim().split("[ \\t\\n]");
        String n = split[split.length-1];
        if (n.endsWith(":")) name = n.substring(0, n.length()-1);
        return n.trim();
    }
    // first discernable "name" in line
    private String getFirstName(String lineStart)
    {
        String[] split = lineStart.trim().split("[ \\t\\n:=]");
        if (split.length == 0) return null;
        String n = split[0];
        return n.trim();
    }
 
    private boolean inStruct()
    {
        return file.inStruct(this);
    }
    private boolean inMacro()
    {
        return file.inMacro(this);
    }
    private boolean inCCommentMacro()
    {
        // not done
        return false;
    }

    // returns true if the label is the first line label in the file
    // or if the last non empty line befor was
    // data (db, ds, dw, fcb...)
    // bra
    // lbra
    // jmp
    // rts
    // rti
    private boolean isPureFunctionCallLabel()
    {
        return file.isPureFunctionCallLabel(this);
    }
    private boolean isDataLabel()
    {
        return file.isDataLabel(this);
    }
    
    
    
    String removeLineNumber(String l)
    {
        int pos = l.lastIndexOf(";");
        if (pos <= 0) return l;
        if (l.trim().endsWith(";")) return l;
        
        l = l.substring(0,pos);
        return l;
    }
    
    // changed status
    private void processCLine(String line)
    {
        previousOrgLine = orgLine;
        previousName = name;
        previousValue = value;
        previousType = type;
        previousParameter= parameter;
        
        boolean done = false;
        type = 0;
        name ="";
        parameter = null;
        isStructStart = false;
        isStructEnd = false;
        isMacroStart = false;
        isMacroEnd = false;
        
        orgLine = line;
        // remove comments
        // this is RUDIMENTARY!
        
        line = removeLineNumber(line);
        
        line = removeComment(line, "//");
        line = removeComment(line, "/*");
    
        if (line.trim().length()==0)
        {
            done = true;
        }
        // functions
        if (!done)
        {
            // only simple forms!
            boolean startWithType = false;
            if (line.trim().startsWith("char "))startWithType=true;
            if (line.trim().startsWith("unsigned "))startWithType=true;
            if (line.trim().startsWith("signed "))startWithType=true;
            if (line.trim().startsWith("static "))startWithType=true;
            if (line.trim().startsWith("final "))startWithType=true;
            if (line.trim().startsWith("extern "))startWithType=true;
            if (line.trim().startsWith("int "))startWithType=true;
            if (line.trim().startsWith("short "))startWithType=true;
            if (line.trim().startsWith("const "))startWithType=true;
            if (line.trim().startsWith("long "))startWithType=true;
            if (line.trim().startsWith("volatile "))startWithType=true;
            if (line.trim().startsWith("inline "))startWithType=true;
            if (line.trim().startsWith("__INLINE "))
                startWithType=true;
            if (line.trim().startsWith("void "))startWithType=true;
            if (line.trim().startsWith("FUNCTION_TYPE "))startWithType=true;
            

            boolean nothingDisturbing = true;
            if (line.contains("="))  nothingDisturbing = false;
            if (line.contains("["))  nothingDisturbing = false;
            if (line.contains("]"))  nothingDisturbing = false;
            
            
            boolean hasBrackets = false;
//            if ((line.contains("(")) &&(line.contains(")"))) hasBrackets = true;
            if ((line.contains("("))) hasBrackets = true;

            boolean hasSemicolon = false;
//            if (line.contains(";"))  hasSemicolon = true;
            if (line.endsWith(";"))  hasSemicolon = true;
            
            if ((startWithType) && (hasBrackets)&& (nothingDisturbing) && (!hasSemicolon) && (!inCCommentMacro()))
            {
                line = de.malban.util.UtilityString.replace(line, "char", "", true);
                line = de.malban.util.UtilityString.replace(line, "unsigned", "", true);
                line = de.malban.util.UtilityString.replace(line, "signed", "", true);
                line = de.malban.util.UtilityString.replace(line, "static", "", true);
                line = de.malban.util.UtilityString.replace(line, "int", "", true);
                line = de.malban.util.UtilityString.replace(line, "const", "", true);
                line = de.malban.util.UtilityString.replace(line, "short", "", true);
                line = de.malban.util.UtilityString.replace(line, "final", "", true);
                line = de.malban.util.UtilityString.replace(line, "extern", "", true);
                line = de.malban.util.UtilityString.replace(line, "long", "", true);
                line = de.malban.util.UtilityString.replace(line, "volatile", "", true);
                line = de.malban.util.UtilityString.replace(line, "inline", "", true);
                line = de.malban.util.UtilityString.replace(line, "__INLINE", "", true);
                line = de.malban.util.UtilityString.replace(line, "void", "", true);
                line = de.malban.util.UtilityString.replace(line, "FUNCTION_TYPE", "", true);
                String[] split = line.trim().split("\\(");

                // if attribute is part of "first (", than this is a variable!
                if (!(split[0].trim().contains("__attri")))
                {
                    name = split[0].trim();
                    done = true;
                    type = TYP_CFUNCTION;
                    subtype = SUBTYPE_FUNCTION_LABEL;
                }
                else
                {
                    line = orgLine;
                }
                
                
            }
        }

//        if (line.contains("const signed char * const blocklist[]="))
//            System.out.println("s");
        // variables 
        if (!done)
        {
            // only simple forms!
            boolean startWithType = false;
            if (line.trim().startsWith("char "))startWithType=true;
            if (line.trim().startsWith("unsigned "))startWithType=true;
            if (line.trim().startsWith("signed "))startWithType=true;
            if (line.trim().startsWith("short "))startWithType=true;
            if (line.trim().startsWith("void "))startWithType=true;
            if (line.trim().startsWith("extern "))startWithType=true;
            if (line.trim().startsWith("final "))startWithType=true;
            if (line.trim().startsWith("int "))startWithType=true;
            if (line.trim().startsWith("long "))startWithType=true;
            if (line.trim().startsWith("static "))startWithType=true;
            if (line.trim().startsWith("const "))startWithType=true;
            if (line.trim().startsWith("volatile "))startWithType=true;

            boolean nothingDisturbing = true;
            if (line.contains("struct "))  nothingDisturbing = false;
            if (line.contains("#define "))  nothingDisturbing = false;
            if (line.contains("#include "))  nothingDisturbing = false;
            if (line.contains("#if "))  nothingDisturbing = false;
            if (line.contains("#endif "))  nothingDisturbing = false;
            if (line.contains("#else "))  nothingDisturbing = false;
            if (line.contains("#else "))  nothingDisturbing = false;
            boolean hasSemicolon = line.contains(";");
            
            boolean endsOpen = line.trim().endsWith("=") || line.trim().endsWith("={")|| line.trim().endsWith("= {");
            
            if ((startWithType) && (nothingDisturbing) && ((hasSemicolon)||endsOpen) && (!inCCommentMacro()))
            {
                line = de.malban.util.UtilityString.replace(line, "const", "", true);
                line = de.malban.util.UtilityString.replace(line, "extern", "", true);
                line = de.malban.util.UtilityString.replace(line, "static", "", true);
                line = de.malban.util.UtilityString.replace(line, "volatile", "", true);
                line = de.malban.util.UtilityString.replace(line, "unsigned", "", true);
                line = de.malban.util.UtilityString.replace(line, "signed", "", true);
                line = de.malban.util.UtilityString.replace(line, "short", "", true);
                line = de.malban.util.UtilityString.replace(line, "char", "", true);
                line = de.malban.util.UtilityString.replace(line, "int", "", true);
                line = de.malban.util.UtilityString.replace(line, "final", "", true);
                line = de.malban.util.UtilityString.replace(line, "long", "", true);
                line = de.malban.util.UtilityString.replace(line, "void", "", true);
                line = de.malban.util.UtilityString.replace(line, "volatile", "", true);
                line = de.malban.util.UtilityString.replace(line, "&", " ").trim();
                line = de.malban.util.UtilityString.replace(line, "*", " ").trim();
                line = de.malban.util.UtilityString.replace(line, ";", " ").trim();
                line = de.malban.util.UtilityString.replace(line, ",", " ").trim();
                line = de.malban.util.UtilityString.replace(line, "[", " ").trim();
                line = de.malban.util.UtilityString.replace(line, "\t", " ").trim();

                String[] split = line.trim().split(" ");
                if (line.contains(" "))
                {
                    name = split[0].trim();
                }
                else
                    name = line;

                
                done = true;
                type = TYP_LABEL;
                subtype = SUBTYPE_DATA_LABEL;
            }
        }
        // macros
        if (!done)
        {
            // only simple forms!
            boolean startWithDefine = false;
            if (line.trim().startsWith("#define"))startWithDefine=true;
            

            
            
            if ((startWithDefine)&& (!inCCommentMacro()))
            {
                // only one C Test for now -> FUNCTION
                line = de.malban.util.UtilityString.replace(line, "#define", "", true).trim();
                line = de.malban.util.UtilityString.replace(line, "\t", " ").trim();
                line = de.malban.util.UtilityString.replace(line, "(", " ").trim();

                String[] split = line.trim().split(" ");
                if (line.contains(" "))
                {
                    name = split[0].trim();
                }
                else
                    name = line;

                
                done = true;
                type = TYP_MACRO;
                subtype = SUBTYPE_MACRO_DEFINITION_LABEL;
            }
        }
        if (!done)
        {
            // include
            int pos;
            pos = cincludePos(line);
            if (pos !=-1)
            {
                done = true;
                String lineRest = line.substring(pos+8).trim();
                // see if " or <>
                if (lineRest.contains("<"))
                {
                    type = TYP_LIB_INCLUDE;
                    name = getFirstCLibFilename(lineRest);
                }
                else
                {
                    type = TYP_INCLUDE;
                    name = getFirstFilename(lineRest);
                }
                
                if (name == null)
                {
                    name = "";
                }


                
            }
        }
        
        
        if (name.trim().length()==0) 
        {
            status = ENTITY_DELETED;
            return;
        }
        if (name.equals(previousName)) 
        {
            status = ENTITY_UNCHANGED;
        }
        else
            status = ENTITY_CHANGED;
        return;
    }    
}
