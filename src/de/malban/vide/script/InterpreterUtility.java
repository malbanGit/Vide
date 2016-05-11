/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.vide.script;

import bsh.EvalError;
import bsh.Interpreter;
import bsh.ParseException;
import bsh.TargetError;
import de.malban.config.Configuration;
import de.malban.config.Logable;
import java.io.*;

/**
 *
 * @author Malban
 */
public class InterpreterUtility {

    // checks whether ascript contains bad keywords, such as "file" or "system"
    // returns true if everything seems ok, false otherwise
    public static boolean scriptCheck(String s)
    {
        Logable D = Configuration.getConfiguration().getDebugEntity();
        String[] badWords={};

        for (int i=0; i< badWords.length;i++)
        {
            if (s.toUpperCase().indexOf(badWords[i].toUpperCase()) != -1)
            {
                D.addLog("Script not acceptable, contains word: \""+badWords[i]+"\"", 0);
                return false;
            }
        }
        return true;
    }
    public static InterpreterReturn askScript(Interpreter i, String script)
    {
        return askScript(i,script, true);
    }
    public static InterpreterReturn askScript(Interpreter i, String script, boolean recallTest)
    {
        Logable D = Configuration.getConfiguration().getDebugEntity();
        String mSkriptDebug="";
        InterpreterReturn ret = new InterpreterReturn();

        if (script == null)
        {
            ret.bScriptAvailable=false;
            return ret;
        }

        script=doImports(script);

        if (scriptCheck(script) == false)
        {
            script="";
        }

        if (script.trim().length()==0)
        {
            ret.bScriptAvailable=false;
            return ret;
        }

        try
        {
            ret.bScriptAvailable = true;
            D.addLog("Going to execute script:\n"+script, 4);
            i.set("thisScript", script);
            ret.scriptExecuted = script;
            i.eval(script);
            Object r = i.get("bRet");
            if (r != null)
            {
                ret.bRet = ((Boolean) (r)).booleanValue();
                ret.bReturnGot = true;
                D.addLog("Boolean return got: "+ret.bRet, 3);
            }
            Object re = i.get("reason");
            if (re != null)
            {
                ret.reason = ((String) (re));
                D.addLog("Reason: "+ret.reason, 3);
            }
            re = i.get("bCancel");
            if (re != null)
            {
                ret.bCancel = ((Boolean) (re)).booleanValue();
                D.addLog("Cancel: "+ret.bCancel, 3);
            }
            re = i.get("bCommunication");
            if (re != null)
            {
                ret.bCommunication = ((Boolean) (re)).booleanValue();
                D.addLog("Communication: "+ret.bCommunication, 3);
            }
            re = i.get("data");
            if (re != null)
            {
                ret.data = re;
                D.addLog("data: "+ret.data, 3);
            }
            mSkriptDebug=(String)i.get("debug");
            if (mSkriptDebug != null)
                D.addLog("Debug Info:"+mSkriptDebug, 3);
        }

         catch ( TargetError e )
         {
            // The script threw an exception
            Throwable t = e.getTarget();

            D.addLog(mSkriptDebug, 0);
            D.addLog("In Script(1): \n"+addLineNumbers(script),0);
            D.addLog(e, 0);
            D.addLog("\n"+t, 0);
            ret.error = true;
            ret.e=e;
        }
        catch ( ParseException e )
        {
            // Parsing error
            D.addLog(mSkriptDebug, 0);
            D.addLog("In Script(2): \n"+addLineNumbers(script),0);
            D.addLog(e, 0);
            ret.error = true;
            ret.e=e;
        }
        catch ( EvalError e )
        {
            // General Error evaluating script
            D.addLog(mSkriptDebug, 0);
            D.addLog("In Script(3): \n"+addLineNumbers(script),0);
            D.addLog(e, 0);
            ret.error = true;
            ret.e=e;
        }
        catch (Throwable e)
        {
            D.addLog(mSkriptDebug, 0);
            D.addLog("In Script(4): \n"+addLineNumbers(script),0);
            D.addLog(e, 0);
            ret.error = true;
            ret.e=e;
        }
        return ret;
    }

    private static String doImports(String s)
    {
        boolean importDone=false;
        Logable D = Configuration.getConfiguration().getDebugEntity();
        int pos = s.indexOf("//#import");
        if (pos!=-1)
        {
            String s1 = s.substring(0, pos+2);
            String s2 = s.substring(pos+2);
            s =s1+"(import done)"+s2; // so above String is not found again!

            String pathName="";
            int start = s.indexOf("\"",pos+8);
            pathName= s.substring(start+1);
            int end = pathName.indexOf("\"");
            pathName = pathName.substring(0,end);
            String im = getImportScript(pathName);

            int lineEnd = s.indexOf("\n",pos+8);

            String part1 = s.substring(0, lineEnd+1);
            String part2 = s.substring(lineEnd+1);
            s= part1+im+"\n"+part2;
            importDone=true;
        }
        if (importDone) s= doImports(s);

        return s;
    }

    private static  String getImportScript(String name)
    {
        Logable D = Configuration.getConfiguration().getDebugEntity();
        String ret = "";
        name = de.malban.util.UtilityString.cleanFileString(name);
        D.addLog("Try loading script import: \""+name+"\"",3);

        File f = new File(name);
        BufferedReader reader;

        try {

            Reader r = new InputStreamReader(new FileInputStream(f), "ISO-8859-1");
            reader =   new BufferedReader(r);
            String zeile = null;

            do
            {
                zeile = reader.readLine();
                if (zeile == null) continue;
                ret+=zeile+"\n";
            } while (zeile != null);
            reader.close();
        } catch (IOException e)
        {
            System.err.println("Error reading import file.");
            e.printStackTrace();
            D.addLog("Error reading import file.",3);
        }
        
        return ret;
    }

    static String addLineNumbers(String s)
    {
        String ret="";
        String[] splitter =  s.split("\n");
        for (int j = 0; j < splitter.length; j++)
        {
            String string = splitter[j];
            ret+=""+(j+1)+":  "+string+"\n";
        }
        return ret;
    }
}
