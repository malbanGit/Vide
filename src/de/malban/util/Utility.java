package de.malban.util;


import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
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
    public static boolean isFilenameRelative(String relName)
    {
        if (isWin)
        {
            if (relName.contains(":"+File.separator)) return false;
        }
        else
        {
            if (relName.startsWith(File.separator)) return false;
        }
        
        return true;
        /*
        if (relName.endsWith(File.separator)) relName = relName.substring(0, relName.length()-1);
        String absName = de.malban.util.Utility.makeAbsolut(relName);
        if (absName.endsWith(File.separator)) absName = absName.substring(0, absName.length()-1);
        boolean isRelative = !relName.toLowerCase().equals(absName.toLowerCase());
        
        
        return isRelative;
*/
    }
    // backward compatability
    public static String makeGlobalAbsolute(String relName)
    {
        return makeVideAbsolute(relName);
    }
    
    // rel path given to Vide Home directory
    public static String makeVideAbsolute(String relName)
    {
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
//        log.addLog("makeVideAbsolute() input "+ relName, INFO);
       
        relName = de.malban.util.UtilityFiles.convertSeperator(relName);
        if (!isFilenameRelative(relName)) 
        {
//            log.addLog("makeVideAbsolute() was already relative "+ relName, INFO);
            return relName;
        }
        String videRelAbs = Global.mainPathPrefix+relName;
        File f = new File(videRelAbs);
        String here = f.getAbsolutePath();
//        log.addLog("makeVideAbsolute() .. absolut: "+ here, INFO);
        try
        {
            here = f.getCanonicalPath();
//            log.addLog("makeVideAbsolute() .. canonical: "+ here, INFO);
        }
        catch (Throwable e)
        {
        }
        return here;
    }    
    
    // or just "straight absolut"
    public static String makeJavaAbsolute(String relName)
    {
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
//        log.addLog("makeJavaAbsolute() input "+ relName, INFO);
       
        
        relName = de.malban.util.UtilityFiles.convertSeperator(relName);
        if (!isFilenameRelative(relName)) 
        {
//            log.addLog("makeJavaAbsolute() was already relative "+ relName, INFO);
            return relName;
        }

        File f = new File(relName);
        String here = f.getAbsolutePath();
//        log.addLog("makeJavaAbsolute() .. absolut: "+ here, INFO);
        try
        {
            here = f.getCanonicalPath();
//            log.addLog("makeJavaAbsolute() .. canonical: "+ here, INFO);
        }
        catch (Throwable e)
        {
        }
        return here;
    }

    static boolean isWin = Global.getOSName().toUpperCase().indexOf("WIN")!=-1;
    
//    public static String ensureRelative(String path)
//    {
//        return makeRelative(makeAbsolut(path));
//    }
    // global main relative
    public static String makeVideRelative(String fullpath)
    {
        if (isFilenameRelative(fullpath)) return fullpath;
        fullpath = de.malban.util.UtilityFiles.convertSeperator(fullpath);
//        File f = new File("."+File.separator);
        File f = new File(Global.mainPathPrefix);
        String here = f.getAbsolutePath();
        String fullpathTest = fullpath;
        String hereTest = here;
        
        if (fullpath.endsWith(File.separator)) fullpath = fullpath.substring(0, fullpath.length()-File.separator.length());
        if (hereTest.endsWith(File.separator)) hereTest = hereTest.substring(0, hereTest.length()-File.separator.length());
        
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
            for (int i=0; i<=up; i++)
            {
                rPath = ".."+File.separator+rPath;
            }
            fullpath = rPath;
        }
        return fullpath;
    }
    // java start relative
//    public static String makeRealRelative(String fullpath)
    public static String makeJavaRelative(String fullpath)
    {
        fullpath = de.malban.util.UtilityFiles.convertSeperator(fullpath);
//        File f = new File("."+File.separator);
        File f = new File("./");
        String here = f.getAbsolutePath();
        try
        {
            here = f.getCanonicalPath();
        }
        catch (Throwable e){}
        String fullpathTest = fullpath;
        String hereTest = here;
        
        if (fullpath.endsWith(File.separator)) fullpath = fullpath.substring(0, fullpath.length()-File.separator.length());
        if (hereTest.endsWith(File.separator)) hereTest = hereTest.substring(0, hereTest.length()-File.separator.length());
        
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
            for (int i=0; i<=up; i++)
            {
                rPath = ".."+File.separator+rPath;
            }
            fullpath = rPath;
        }
        return fullpath;
    }
 
}
