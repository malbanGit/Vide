package de.malban.util;


import java.util.Vector;
import java.text.*;
import java.io.*;

/**
 */
public class UtilityString
{

    public static String toHTML(String in)
    {
        String out = toXML(in);
        out = replace(out,"&apos;","&#39;");
        return out;
    }

    public static String toXML(String in)
    {
        String out = in;
        
        if (in.equals(" ")) return "&#x20;";
        
        if (out.startsWith(" "))
        {
            out = "&#x20;"+out.substring(1);
            return toXML(out);
        }
        
        if (out.endsWith(" "))
        {
            out = out.substring(0,out.length()-1)+"&#x20;";
            return toXML(out);
        }
        
        
        out = replace(out,"&","___TO#OT#OO__amp;");
        out = replace(out,"___TO#OT#OO__amp;","&amp;");
        out = replace(out,"'","&apos;");
        out = replace(out,"´","&apos;");
        out = replace(out,"`","&apos;");
        out = replace(out,"<","&lt;");
        out = replace(out,"<","&gt;");
        out = replace(out,"\"","&quot;");

        out = replace(out,"Ä","&#196;");
        out = replace(out,"Ö","&#214;");
        out = replace(out,"Ü","&#220;");
        out = replace(out,"ä","&#228;");
        out = replace(out,"ö","&#246;");
        out = replace(out,"ü","&#252;");
        out = replace(out,"ß","&#223;");
        return out;
    }

    public static String fromXML(String in)
    {
        String out = in;
        out = replace(out,"&#x20;"," ");
        out = replace(out,"&amp;","&");
        out = replace(out,"&apos;", "'");
        out = replace(out,"&apos;","´");
        out = replace(out,"&apos;", "`");
        out = replace(out,"&lt;", "<");
        out = replace(out,"&gt;", "<");
        out = replace(out,"&quot;", "\"");
        return out;
    }

    static public Vector<String> vectorReplace(Vector<String> col, String search, String with)
    {
        Vector<String> result = new Vector<String>();
        for (int i=0;i<col.size();i++)
        {
            String t = col.elementAt(i);
            t= replace(t, search, with);
            result.addElement(t);
        }
        return result;
    }

    static public String replaceLastOccurrence(String name, String search, String with) 
    {
        int lastPos = name.lastIndexOf(search);
        if (lastPos == -1) return name;
        if (lastPos <with.length()) return replace(name, search, with);
        if (lastPos == 0) return replace(name, search, with);
        
        String beginString = name.substring(0, lastPos); 
        String endString = name.substring(lastPos); 
    
        String endStringDone = replace(endString, search, with);
        return beginString+endStringDone;
    }
    /** Replace part of a string.
     * Replaces - even with empty Strings (all occurences of "search" within "name" with "with"!).
     * <PRE>
     * e.g replace("something", "thi", "tha") results in somethang
     *     replace("something", "thi", "") results in someng
     *
     * </PRE>
     */
    static public String replace(String name, String search, String with) 
    {
        return replace( name,  search,  with, false); 
    }
    static public boolean isWordBoundry(char s)
    {
        if (s == '_') return false;
        if ((s >='a') && (s<='z')) return false;
        if ((s >='A') && (s<='Z')) return false;
        if ((s >='0') && (s<='9')) return false;
        return true;
    }
    // whole words defined as
    // borders are everyrhing that is non: _a-zA-Z0-9
    static public String replace(String name, String search, String with, boolean onlyWholeWords) {
            // bad!
            if (name == null)
            {
                    return name;
            }

            if ((search == null) || (search.length() == 0)) {
                    return name;
            }

            if (with == null)
            {
                    with = "";
            }
//mConfig - search
//mConiguration - with
            // ersetzen eines Strings mit sich selber oder mehr - wuerde endlosschleife geben
            String[] keys={"!**!", "<-->", "§$$§", "%&&%"};
            String orgSearch = search;
            String orgwith = with;
            int i=0;
            while (with.indexOf(search)!=-1)
            {
                with=keys[i];
                i++;
                if (i==5) return "ERROR";
            }
            if (i!=0)
            {
                name = replace(name, search, with, onlyWholeWords);
                search=with;
                with = orgwith;
            }

            int startSearch = 0;
            while (name.substring(startSearch).indexOf(search) != -1) 
            {
                boolean wholeWord = true;
                int p = name.substring(startSearch).indexOf(search);
                if (p>0)
                {
                    wholeWord = wholeWord && isWordBoundry(name.substring(startSearch).charAt(p-1));
                }
                if (p+search.length() <name.length())
                {
                    wholeWord = wholeWord && isWordBoundry(name.substring(startSearch).charAt(p+search.length()));
                }
                if ((onlyWholeWords) && (!wholeWord))
                {
                    startSearch += p+search.length();
                    continue;
                }
                
                String n1 = new String();
                String n2 = new String();
                try {
                        // build first part of the return-String
                        n1 = name.substring(0, startSearch+p);
                } catch (StringIndexOutOfBoundsException ex) {
                }
                try {
                        // build first part of the return-String
                        n2 = name.substring(startSearch+p + search.length());
                } catch (StringIndexOutOfBoundsException ex) {
                }
                // build complete return-String
                name = n1 + with + n2;
            }
            return name;
    }

    public static String replaceWhiteSpaces(String in , String with)
    {
        String out = in;

        out = replace(out,"\u00A0",with);
        out = replace(out,"\u2007",with);
        out = replace(out,"\u202F",with);
        out = replace(out,"\u0009",with);
        out = replace(out,"\u000B",with);
        out = replace(out,"\f",with);
        out = replace(out,"\t",with);
        out = replace(out,"\r",with);
        out = replace(out,"\n",with);
        return out;
    }

    public static String reverse(String in)
    {
        String ret="";
        for (int i=0; i< in.length(); i++)
        {
            String c=in.substring(i, i+1);
            ret = c+ ret;
        }
        return ret;
    }

    public static String cleanSQLString(String in)
    {
        String out = in;
        out = replace(out,"'","´");
        return out;
    }

    public static String cleanStringSpace(String in)
    {
        String out = replaceWhiteSpaces(in, " ");
        out = replace(out,"&","");
        out = replace(out,"'","");
        out = replace(out,"´","");
        out = replace(out,"`","");
        out = replace(out,"<","");
        out = replace(out,"<","");
        out = replace(out,"\"","");
        out = replace(out,"/","");
        out = replace(out,"-","");
        out = replace(out," "," ");
        out = replace(out,"(","");
        out = replace(out,")","");
        out = replace(out,".","");
        out = replace(out,"…","");

        out = replace(out,"Ä","Ae");
        out = replace(out,"Ö","Oe");
        out = replace(out,"Ü","Ue");
        out = replace(out,"ä","ae");
        out = replace(out,"ö","oe");
        out = replace(out,"ü","ue");
        out = replace(out,"ß","ss");
        out = replace(out,"  "," ");
        out = out.toUpperCase();
        return out.trim();
    }

    public static String cleanString(String in)
    {
        String out = replaceWhiteSpaces(in, "");
        out = replace(out,"&","");
        out = replace(out,"'","");
        out = replace(out,"´","");
        out = replace(out,"`","");
        out = replace(out,"<","");
        out = replace(out,"<","");
        out = replace(out,"\"","");
        out = replace(out,"/","");
        out = replace(out,"-","");
        out = replace(out," ","");
        out = replace(out,"(","");
        out = replace(out,")","");
        out = replace(out,".","");
        out = replace(out,"…","");


        out = replace(out,"Ä","Ae");
        out = replace(out,"Ö","Oe");
        out = replace(out,"Ü","Ue");
        out = replace(out,"ä","ae");
        out = replace(out,"ö","oe");
        out = replace(out,"ü","ue");
        out = replace(out,"ß","ss");
        out = out.toUpperCase();
        return out.trim();
    }

    public static String onlyUpperASCIIAndConvertedSpace(String in)
    {
        String ret="";
        in = replaceWhiteSpaces(in , " ");
        char[] c = in.toUpperCase().toCharArray();
        for (int i=0; i<c.length;i++)
        {
            if (c[i] == new Character(' ').charValue()) ret = ret + c[i];
            else if (c[i]>64)
            {
                if (c[i]<=90)
                {
                    ret = ret + c[i];
                }
            }
        }
        return ret;
    }

    public static String onlyUpperASCII(String in)
    {
        String ret="";
        char[] c = in.toUpperCase().toCharArray();
        for (int i=0; i<c.length;i++)
        {
            if (c[i]>64)
            {
                if (c[i]<=90)
                {
                    ret = ret + c[i];
                }
            }
        }
        return ret;
    }

    public static final boolean isContained(Vector<String> v, String w)
    {
        for (int i = 0; i < v.size(); i++)
        {
            String string = v.elementAt(i);
            if (string.equals(w)) return true;
        }
        return false;
    }


    public static final int whereContainedUpperTrim(Vector<String> v, String w)
    {
        for (int i = 0; i < v.size(); i++)
        {
            String string = v.elementAt(i).toUpperCase().trim();
            if (string.length()==0) continue;
            if (string.equals(w.toUpperCase().trim())) return i;
        }
        return -1;
    }

    public static String dbConform(String in)
    {

        String out = in;
        out = replace(out,"'","´");
        out = replace(out,"\\","");
        out = replace(out,"–","-");

        out = replace(out,"\226","-"); // 0x96
        out = replace(out,"\032"," "); // 0x1a
        out = replace(out,"\031"," "); // 0x19
        out = replace(out,"\034"," "); // 0x1c
        out = replace(out,"\036"," "); // 0x1e
        out = replace(out,"‚","\"");
        out = replace(out,"’","\"");
        out = replace(out,"“","\"");
        out = replace(out,"„","\"");
        out = replace(out,"´","\"");
        out = replace(out,"€","Euro");
        out = replace(out,"µ","Mikro");
        out = replace(out,"…","...");

        out = replace(out,"\077"," "); // 0x3f
        out = replace(out,"\225"," "); // 0x95
        out = replace(out,"\u003f"," "); // 0x3f
        out = replace(out,"\u0095"," "); // 0x95

       // 3f = 16*4 -1 = 63 =077
       // 95 = 16*9+5 = 160-16-5 = 160-21 = 139 = 213


        return out;
    }

    public static String formatDouble(Double d)
    {
        DecimalFormat f = new DecimalFormat("#0,0");

        if (d==null) return "";
        return f.format(d);
    }


    public static String escapeRegExp(String s)
    {
        s= replace(s,"\\","OO!!11!!OO");
        s= replace(s,"[","\\[");
        s= replace(s,"^","\\^");
        s= replace(s,"$","\\$");
        s= replace(s,".","\\.");
        s= replace(s,"|","\\|");
        s= replace(s,"?","\\?");
        s= replace(s,"*","\\*");
        s= replace(s,"+","\\+");
        s= replace(s,"(","\\(");
        s= replace(s,")","\\)");
        s= replace(s,"{","\\{");
        s= replace(s,"}","\\}");

        s= replace(s,"OO!!11!!OO", "\\\\");
        return s;
    }

    public static String cleanFileString(String path)
    {
        String ret = replace(path, "\\", File.separator);
        String ret2 = replace(ret, "/", File.separator);
        return ret2;
    }

    public static int  countStrings(String string, String what)
    {
        int count = 0;
        int index;
        do
        {
            index = string.indexOf(what);
            if (index != -1)
            {
                count++;
                String partA = string.substring(0, index);
                String partB = string.substring(index+what.length());
                string = partA+partB;
            }
        } while (index!=-1);

        return count;
    }

    // returns from a relativ  path/filename, the path without the filename
    // ends with a File.seperator
    public static String getFileName(String file)
    {
        File f = new File(cleanFileString(file));
        return f.getName();
    }

    // returns from a relativ  path/filename, the path without the filename
    // ends with a File.seperator
    public static String getPath(String file)
    {
        String path ="";
        file = cleanFileString(file);
        
        File f;
        if (file.length()==0)
            f = new File("."+File.separator);
        else
            f = new File(file);
        String aPath = f.getAbsolutePath();
        path = makeRelative(aPath);

        int i = path.lastIndexOf(File.separator);
        if (i==-1) i = path.length()-1;
        if (i==-1) i=0;
        path = path.substring(0, i)+File.separator;
        return path;
    }

    public static String makeRelative(String path)
    {
        path = cleanFileString(path);
        File f = new File("."+File.separator);
        String here = f.getAbsolutePath();
        if (path.equals(here))
            return "."+File.separator;
        
        here = here.substring(0, here.length()-1); // remove the "." at the end!

        if (path.indexOf(here.substring(0,here.length()-1)) != -1)
        {
            path = path.substring(path.indexOf(here)+here.length());
        }
        else
        {
            // c:\1\2\3\.
            // c:\1\2\blub\sound.wav

            int len = 1;
            while (here.regionMatches(0, path, 0, len)) len++;
            len -=2;
            if (len <= 1) return path;

            // go back to last File separator, dirs may have the same letters in front
            while ((!(path.substring(len).startsWith(File.separator))) && (len >=1)) len--;

            String rPath = path.substring(len+1);
            String rHere = here.substring(len+1);


            // 3\.
            // blub\sound.wav
            int up = countStrings(rHere, File.separator);
            for (int i=0; i< up; i++)
            {
                rPath = ".."+File.separator+rPath;
            }
            path = rPath;
        }
        return path;
    }

    public static Vector<String> readTextFileToString(File file)
    {
        Vector<String> strings = new Vector<String>();
        BufferedReader reader;

        try {
            Reader r = new InputStreamReader(new FileInputStream(file));
            reader =   new BufferedReader(r);

            String zeile = null;
            do
            {
                zeile = reader.readLine();
                if (zeile == null) continue;
                strings.addElement(zeile);

            } while (zeile != null);
            reader.close();

        } catch (IOException e)
        {
            System.err.println("Error reading file.");
            e.printStackTrace();
        }
        return strings;
    }

    public static String readTextFileToOneString(File file)
    {
        StringBuilder ret = new StringBuilder();
        BufferedReader reader;

        try {
            Reader r = new InputStreamReader(new FileInputStream(file));
            reader =   new BufferedReader(r);

            String zeile = null;
            do
            {
                zeile = reader.readLine();
                if (zeile == null) continue;
                ret.append(zeile).append("\n");

            } while (zeile != null);
            reader.close();

        } catch (IOException e)
        {
            System.err.println("Error reading file: "+file.getAbsolutePath());
            e.printStackTrace();
        }
        return ret.toString();
    }
    public static boolean writeToTextFile(Vector<String> strings, File file)
    {
        BufferedWriter writer;
        try {
            Writer w = new OutputStreamWriter(new FileOutputStream(file) );
            writer =   new BufferedWriter(w);

            for (int i = 0; i < strings.size(); i++)
            {
                String zeile = strings.elementAt(i);

                writer.write(zeile+"\n");
                writer.flush();
            }
            writer.close();

        } catch (IOException e)
        {
            System.err.println("Error writing file.");
            e.printStackTrace();
            return false;
        }
        return true;
    }

    public static boolean replaceToNewFile(File from, File to, Vector<String> searchFor, Vector<String> replaceWith)
    {
        Vector<String> stringFile = readTextFileToString(from);
        for (int i = 0; i < searchFor.size(); i++)
        {
            stringFile = vectorReplace(stringFile, searchFor.elementAt(i), replaceWith.elementAt(i));
        }
        return writeToTextFile(stringFile, to);
    }

    private static String convertToHex(byte[] data)
    {
        StringBuffer buf = new StringBuffer();
        for (int i = 0; i < data.length; i++)
        {
            int halfbyte = (data[i] >>> 4) & 0x0F;
            int two_halfs = 0;
            do
            {
                if ((0 <= halfbyte) && (halfbyte <= 9))
                {
                    buf.append((char) ('0' + halfbyte));
                } else
                {
                    buf.append((char) ('a' + (halfbyte - 10)));
                }
                halfbyte = data[i] & 0x0F;
            } while (two_halfs++ < 1);
        }
        return buf.toString();
    }
    public static int getReturnLengthOfStringFile(File file)
    {
        String line1="";
        String line2="";
        int ret = 2;
        try
        {
            FileReader reader = new FileReader(file);
            BufferedReader f = new BufferedReader(reader);
            line1 = f.readLine();
            line2 = f.readLine();
            f.close();
        } catch (Throwable e)
        {
        }

        try
        {
            FileReader reader = new FileReader(file);
            BufferedReader f = new BufferedReader(reader);
            f.skip(line1.length()+2);
            String line22;
            line22 = f.readLine();
            if (!(line22.equals(line2)))
            {
                ret = 1;
            }
            f.close();
        } catch (Throwable e)
        {
        }
        return ret;
    }
    public static int Int0(String t)
    {
        return IntX(t, 0);
    }
    public static int IntX(String t, int x)
    {
        if (t==null) return x;
        int ret = x;

        try
        {
            ret = Integer.parseInt(t);
        }catch (Throwable e){}
        return ret;
    }
    public static long LongX(String t, int x)
    {
        long ret = x;

        try
        {
            ret = Long.parseLong(t);
        }catch (Throwable e){}
        return ret;
    }
    public static float FloatX(String t, float x)
    {
        float ret = x;
        t = replace(t, ",", "."); 
        try
        {
            ret = Float.parseFloat(t);
        }catch (Throwable e){System.out.println(e);}
        return ret;
    }
    public static Vector<Integer> intVector(String s)
    {
        return intVector(s,",");
    }
    public static Vector<Integer> intVector(String s, String seperator)
    {
        Vector<Integer> ret = new Vector<Integer>();

        String ss[] = s.split(seperator);
        for (int i=0; i<ss.length; i++)
        {
            ret.addElement(Int0(ss[i].trim()));
        }
        return ret;
    }
public static String trimEnd(String s)
{
    if ( s == null || s.length() == 0 )
        return s;
    int i = s.length();
    while ( i > 0 &&  Character.isWhitespace(s.charAt(i - 1)) )
        i--;
    if ( i == s.length() )
        return s;
    else
        return s.substring(0, i);
}

}