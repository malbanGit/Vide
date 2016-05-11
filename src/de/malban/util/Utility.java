package de.malban.util;


import de.malban.Global;
import java.io.File;
import java.io.OutputStream;
import java.io.PrintStream;
import java.util.zip.CRC32;


/**
 */
public class Utility 
{
    public static String getCurrentStackTrace()
    {
        String s="";
        for (int i=0; i < Thread.currentThread().getStackTrace().length; i++)
        {
            s+=Thread.currentThread().getStackTrace()[i]+"\n";
        }
        return s;
    }

    static String add="";
    public static String getStackTrace(Throwable e)
    {
        add="";
         PrintStream  p= new PrintStream(
          new OutputStream()
          {
            @Override
            public void write( int b )
            {
                char[] c = {(char)b};
                String s = new String(c);
                add += s;
            }
          }
        );
        e.printStackTrace(p);
        p.flush();
        return add;
    }

    public static String makeAbsolut(String relpath)
    {
        return makeAbsolut(relpath, false);
    }
    public static String makeAbsolut(String relpath, boolean pathOnly)
    {
        File file = new File (relpath);
        String absPath = file.getAbsolutePath();
        if (!pathOnly)
        {
            return absPath;
        }
        String filename = UtilityString.getFileName(absPath);
        
        return UtilityString.replace(absPath, File.separator+filename, "");
    }
    
    static boolean isWin = Global.getOSName().toUpperCase().indexOf("WIN")!=-1;
    
    public static String makeRelative(String fullpath)
    {
//        File f = new File("."+File.separator);
        File f = new File("");
        String here = f.getAbsolutePath();
        String fullpathTest = fullpath;
        String hereTest = here;
        if (isWin)
        {
            // one has the drive letter in lower, the other in upper case??? What the HECK?????
            fullpathTest = fullpath.toLowerCase();
            hereTest = here.toLowerCase();
        }
        
        if (fullpathTest.indexOf(hereTest.substring(0,hereTest.length()-1)) != -1)
        {
            fullpath = fullpath.substring(fullpathTest.indexOf(hereTest)+hereTest.length());
            if (fullpath.startsWith(File.separator))
            {
                fullpath = fullpath.substring(1);
            }
        }
        else
        {
            // c:\1\2\3\.
            // c:\1\2\blub\sound.wav

            int len = 1;
            while (hereTest.regionMatches(0, fullpathTest, 0, len)) len++;
            len -=2;
            if (len <= 1) return fullpath;

            // go back to last File separator, dirs may have the same letters in front
            while ((!(fullpath.substring(len).startsWith(File.separator))) && (len >=1)) len--;

            String rPath = fullpath.substring(len+1);
            String rHere = here.substring(len+1);


            // 3\.
            // blub\sound.wav
            int up = UtilityString.countStrings(rHere, File.separator);
            for (int i=0; i< up; i++)
            {
                rPath = ".."+File.separator+rPath;
            }
            fullpath = rPath;
        }
        return fullpath;
    }

 
}
