/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.script;

import de.malban.graphics.GFXVector;
import de.malban.graphics.Vertex;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Vector;

/**
 *
 * @author malban
 */
public class DBParser {

    public static final int UNKOWN = -1;
    public static final int Draw_VLc = 0;
    public static final int Draw_VL_b = 1;
    public static final int Draw_VLcs = 2;
    public static final int Draw_VLp = 3;
    public static final int Draw_VLp_scale = 4;

    int listType = UNKOWN;
    int pos = 0;
    boolean loaded = false;
    String data = ""; // lines are \n terminated!
    
    // \r\n -> \n
    //\t -> "  "
    public boolean readFile(String filename)
    {
        Path path = Paths.get(filename);
        try
        {
            data = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);
            data = de.malban.util.UtilityString.replace(data, "\r\n","\n");
            data = de.malban.util.UtilityString.replace(data, "\t","  ");
            loaded = true;
        }
        catch (Throwable ex)
        {
            return false;
        }
        return true;
    }
    
    // \n is not returned!
    // but "counted"
    // returns "" on file end
    // pos is increased
    String tillEndOfLine()
    {
        StringBuffer b = new StringBuffer();
        
        String sign = "";
        while ((!sign.equals("\n")) && (pos < data.length()))
        {
            sign = data.substring(pos, pos+1);
            if (!sign.equals("\n"))
            {
                b.append(sign);
            }
            pos++;
        }
        return b.toString();
    }
    // set pos to beginning of last line
    void oneLineBack()
    { 
        char c; 
        do
        {
            pos--;
            if (pos ==0) return;
            c = data.charAt(pos);
        }while (c!='\n');
        do
        {
            pos--;
            if (pos ==0) return;
            c = data.charAt(pos);
        }while (c!='\n');
        pos++;
    }
    // set pos to beginning of line
    void lineStart()
    { 
        char c; 
        do
        {
            pos--;
            if (pos ==0) return;
            c = data.charAt(pos);
        }while (c!='\n');
        pos++;
    }

    
    boolean isEOF()
    {
        return pos >=data.length();
    }
    
    void skipWord()
    {
        while (!de.malban.util.UtilityString.isWordBoundry(data.charAt(pos))) pos++;
    }
    
    // get chars that form a word
    // pos is increased
    // first non word char is start of new "pos"
    String getWord()
    {
        StringBuffer b = new StringBuffer();
        if (pos>=data.length()) return "";
        while (true)
        {
            char c = data.charAt(pos);
            if (!de.malban.util.UtilityString.isWordBoundry(c))
            {
                b.append(c);
                pos++;
                if (pos>=data.length())
                    break;
            }
            else
            {
                break;
            }
        }
        return b.toString();
    }
    // get chars that form a word
    // 
    // 
    String getWord(String line)
    {
        int p = 0;
        StringBuffer b = new StringBuffer();
        if (p>=line.length()) return "";
        while (true)
        {
            char c = line.charAt(p);
            if (!de.malban.util.UtilityString.isWordBoundry(c))
            {
                b.append(c);
                p++;
                if (p>=line.length())
                    break;
            }
            else
            {
                break;
            }
        }
        return b.toString();
    }

    // label defined:
    // word starting a line
    // space/ TAB not allowed
    // * ; are treated as comment
    public void setPositionAfterLabel()
    {
        String line;
        do
        {
            line = tillEndOfLine();
        } while ((line.startsWith(" "))|| (line.startsWith(";"))||(line.startsWith("*")));
        
        // skip the label
        skipWord();
        
        // also skip (if available) the ":"
        if (data.charAt(pos) == ':') pos++;
 
    }
    
    public void setPositionAfterLabel(String label)
    {
        String line;
        String word;
        do 
        {
            do
            {
                line = tillEndOfLine();
                if (isEOF()) return;
            } while ((line.startsWith(" "))|| (line.startsWith(";"))||(line.startsWith("*")));
            word = getWord(line);
        } while (!word.equals(label));
        
        pos = pos - (line.length()- word.length());
        // also skip (if available) the ":"
        if (data.charAt(pos) == ':') pos++;
    }
    
    // pos set to 0 if not found
    // pos is set after the first occurence of text
    public void setPositionAfterFind(String text)
    {
        pos = data.indexOf(text);
        if (pos == -1) pos = 0;
        else pos += text.length(); 
    }
    public void setPosition(int p)
    {
        pos = p;
    }
    // starts at line 0
    // on out of bounds, position is not changed at all!
    // pos is set to first char of line X
    public void setPositionToLine(int line)
    {
        String[] lines = data.split("\n");
        if (line >= lines.length) return;
        int p = 0;
        int lc = 0;
        while (p < line)
        {
            p+=lines[lc++].length()+1;
        }
        pos = p;
    }
    public static final int DB = 0;
    public static final int DW = 1;

    // start: pos = start of a line
    // end: 
    // pos is posiitoned after data indicator
    // data indicators are only DB and DW
    public int getNextDataType()
    {
        String line;
        int lineStartSave = 0;
        int t = -1;
        do
        {
            lineStartSave = pos;
            line = tillEndOfLine();
            if (isEOF()) return UNKOWN;
            if (t==-1) if (line.toLowerCase().contains(" db ")) t = DB;
            if (t==-1) if (line.toLowerCase().contains(" dw ")) t = DW;
        }
        while (t == -1);

        pos = lineStartSave;
        if (t == DB) pos += line.toLowerCase().indexOf(" db ")+4;
        if (t == DW) pos += line.toLowerCase().indexOf(" dw ")+4;
        return t;
    }
    
    // whitespaces are " ", "\n" , "\t"
    // returns false if new line was encountered!
    // pos to first char of new line if \n was encountered (this CAN be a whitespace!)
    // pos to first non "whitespace" char else
    boolean skipWhiteSpaces()
    {
        char c = data.charAt(pos);
        while ((c==' ') || (c=='\t')|| (c=='\n'))
        {
            if (c == '\n')
            {
                pos++;
                return true;
            }
            pos++;
            c = data.charAt(pos);
        }
                
        return false;
    }
    // from current position to end of line or next ","
    // new pos is AFTER the seperator!
    // assumes position is befor next data!
    // returns "" if no discernable data was found! (e.g. newline without data)
    public String getNextDataText()
    {
        StringBuffer b = new StringBuffer();
        
        if (skipWhiteSpaces()) return "";
        while (true)
        {
            char c = data.charAt(pos);
            pos++;
            if ((c!= '\n')&& (c!= ','))
            {
                b.append(c);
                if (pos>=data.length())
                    break;
            }
            else
            {
                break;
            }
        }
        return b.toString();
    }
    
    // returns next discernable IntValue
    // if value can't be found Integer.MaxValue is returned
    
    public int getNextDataIntValue()
    {
        String t = getNextDataText();
        t = stripOperators(t);
        return toNumber(t);
    }
    
    // DB 5*SCALE+1 = 5
    // idea is to get a PURE number from data
    // the first digit is taken to the first nun digit!
    // return "" if not found
    String stripOperators(String s)
    {
        StringBuffer r = new StringBuffer();
        int p=0; 
        char c = s.charAt(p++);
        while (!isDigit(c, true))
        {
            if (p>=s.length()) return "";
            c = s.charAt(p++);
        }
        boolean first = true;
        while (isDigit(c, first))
        {
            r.append(c);
            first = false;
            if (p>=s.length()) break;
            c = s.charAt(p++);
        }
        
        return r.toString();
    }
    
    // 0-9 (+ - $)
    boolean isDigit(char c, boolean acceptOp)
    {
        if ((c>='0') && (c<='9')) return true;
        if (!acceptOp) return false;
        if (c=='$') return true;
        if (c=='-') return true;
        if (c=='+') return true;
        return false;
    }
    
    
    // int from 10 or radix 16 ($ or 0x leading!)
    // returns Integer.MaxValue if no number was found!
    public static int toNumber(String s)
    {
        s = s.toUpperCase();
        boolean minus = false;
        int radix = 10;
        int result = 0;
        if (s.startsWith("-"))
        {
            minus=true;
            s = s.substring(1);
        }
        if (s.startsWith("+"))
        {
            s = s.substring(1);
        }
        if (s.startsWith("$"))
        {
            radix = 16;
            s = s.substring(1);
        }
        if (s.toLowerCase().startsWith("0x"))
        {
            s= s.substring(2);
            radix = 16;
        }
        try
        {
            result = Integer.parseInt(s, radix);
            if (minus) result *=-1;
//            result = result &(0xffff);
        }
        catch (Throwable ex)
        {
            return Integer.MAX_VALUE;
        }
        return result;
    }    
    public Vertex getNextVertex()
    {
        return null;
    }
    public GFXVector getNextVector()
    {
        return null;
    }
    
    // returns null if any error
    public Vector getNextVectorList()
    {
        Vector<GFXVector> ret = new Vector<GFXVector>();
        
        if (listType == Draw_VLc)
        {
            // DB 10
            // DB x1,y1
            // DB ...
            // DB x10,y10
            if (getNextDataType() != DB) return null;
            int length = getNextDataIntValue();
            if (length == Integer.MAX_VALUE) return null;
            GFXVector oldVector=null;
            for (int i=0;i<length; i++)
            {
                if (getNextDataType() != DB) return null;
                int x = getNextDataIntValue();
                if (x == Integer.MAX_VALUE) return null;
                int y = getNextDataIntValue();
                if (y == Integer.MAX_VALUE) return null;
                GFXVector vector= new GFXVector(oldVector, x,y, 0);
                oldVector = vector;
                ret.addElement(vector);
            }
        }
        return ret;
    }
    
    public void setExpectedListType(int type)
    {
        listType = type;
    }
    
    
}
