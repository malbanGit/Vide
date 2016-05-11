/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util.syntax.entities;

import static de.malban.util.syntax.entities.ASM6809FileInfo.*;
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

    
    
    private int status = ENTITY_DELETED;
    ASM6809FileInfo file;
    public ASM6809FileInfo getFile()
    {
        return file;
    }
    public int getLineNumber()
    {
        String ln = orgLine.substring(orgLine.lastIndexOf(";")+1);
        return Integer.parseInt(ln)+1;
    }
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
    
            
    
    int lineNumber = -1; // line in ArrayList of ASM6809FileInfo
    String orgLine;
    String name="";     // macro, label name, include filename
    String value;    // label, the expressio, macro parameters, include ... nothing
    ArrayList<String> parameter; // default non = null, only set if macro has parameters
    ArrayList<String> previousParameter; // default non = null, only set if macro has parameters
    int type;
    String previousOrgLine;
    String previousName;
    String previousValue;
    int previousType;
    boolean isStructStart = false;
    boolean isStructEnd = false;
    
    // return null, if no known entity was found
    public static EntityDefinition scanLine(ASM6809FileInfo _file, String _orgLine)
    {
        if (_orgLine==null) return null;
        EntityDefinition entity = new EntityDefinition();
        entity.file = _file;
        entity.processLine(_orgLine);
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
                        value = "line label";
                        name = getFirstName(line);
                        if (name == null)
                        {
                            name = "";
                        }

                    }
                }
            }
        }
        if ((name.trim().length()==0) && (!isStructEnd))
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
    
    private int includePos(String line)
    {
        return searchPos(line.toLowerCase(), "include", HALF_PURE);
    }
    private int macroPos(String line)
    {
        return searchPos(line.toLowerCase(), "macro", PURE);
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
    private String removeComment(String s, String commentString)
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
    
    private String removeOneQuote(String wc)
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

    private int reallyPurePos(String line, String search)
    {
        int pos =         line.indexOf(" "+search+" ");
        if (pos <0) pos = line.indexOf("\t"+search+" ");
        if (pos <0) pos = line.indexOf("\t"+search+"\t");
        if (pos <0) pos = line.indexOf(" "+search+"\t");
        if (pos <0) pos = line.indexOf("\t"+search+"\n");
        if (pos <0) pos = line.indexOf(" "+search+"\n");
        if (pos <0) return -1;
        return pos+1; // ignore leading WS
    }

    private int purePos(String line, String search)
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
    private int halfpurePos(String line, String search)
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
    
    private int searchPos(String line, String search, int purePos)
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
        boolean hasDoubleQuotes = line.indexOf("\"")!=-1;
        boolean hasQuotes = line.indexOf("'")!=-1;

        if (hasDoubleQuotes)
        {
            String[] split = line.split("\"");
            return split[1];
        }
        if (hasQuotes)
        {
            String[] split = line.split("'");
            return split[1];
        }
        String[] split = line.split(" ");
        return split[0];
        
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
        String n = split[0];
        return n.trim();
    }
 
    private boolean inStruct()
    {
        return file.inStruct(this);
    }
}
