/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.config;

/**
 *
 * @author Malban
 */
public interface Logable
{
    /*
    public static int LOG_ERROR = 0; // allways!
    public static int LOG_WARNING = 1;
    public static int LOG_VERBOSE = 2;
*/
    public void setInterestedClasses(String c);
    public void setInterestedMethods(String m);
    public void setInterestedFiles(String f);
    public void setFiletracking(boolean b);
    public void setTrackTime(boolean b);
    public void setTrackInFile(boolean b);
    public void setDebugLevel(int l);
    public void setDebugFileOnly(boolean b);
    public void setLog(String text, int level);
    public void addLog(Throwable e, int level);
    public void addLog(String text, int level);
    public void setLog(String text);
    public void addLog(Throwable e);
    public void addLog(String text);
    public String getLog();
    public boolean saveLog();
    public void clearLog();
    public void addLogListener(LogListener l);
    public void removeLogListener(LogListener l);

}
