/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.script;

import bsh.Interpreter;
import de.malban.config.Configuration;
import de.malban.vide.veccy.VeccyPanel;
import de.malban.vide.codi.CodeLibraryPanel;
import de.malban.vide.vedi.VediPanel;
import java.awt.Frame;
import java.io.OutputStream;
import java.io.PrintStream;
import java.util.Collection;

/**
 *
 * @author malban
 */
public class ScriptEnvironment {
    
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
    public static final int SCRIPT_NOT_EXECUTED=0;
    public static final int SCRIPT_EMPTY=1;
    public static final int SCRIPT_EXECUTED=2;
    public static final int SCRIPT_EXCEPTION=3;

    public static final String[] STATE_STRINGS={
        "SCRIPT_NOT_EXECUTED",
        "SCRIPT_EMPTY",
        "SCRIPT_EXECUTED",
        "SCRIPT_EXCEPTION",
    };

    public String script="";

    public InterpreterReturn iRet = new InterpreterReturn();
    public int status=SCRIPT_NOT_EXECUTED;
    boolean dataSet = false;

    private Interpreter i = new Interpreter();  // Construct an interpreter

    @Override public String toString()
    {
        String ret="";

        return ret;
    }

    // this is only for named scripts in debugging / testing
    public ScriptEnvironment(String singleScript)
    {
        script = singleScript;
    }

    Collection mCollection = null;
    VeccyPanel vecci;    
    Frame frame;
    
    VediPanel vedi;
    CodeLibraryPanel codi;
    ExecutionDescriptor ed;
    public void setData(VediPanel ise, Frame f, ExecutionDescriptor e_d)
    {
        frame = f;
        vedi = ise;
        ed = e_d;
        status=SCRIPT_NOT_EXECUTED;
        try
        {
            i.set("vedi", vedi);  
            i.set("frame", frame);  
            i.set("ed", ed);  
        }
        catch (Throwable e)
        {
            status = SCRIPT_EXCEPTION;
            Configuration.getConfiguration().getDebugEntity().addLog("Script Exception!", 0);
            Configuration.getConfiguration().getDebugEntity().addLog(e, 0);
        }
        
        dataSet = true;
    }    
    public void setData(CodeLibraryPanel ise, Frame f, ExecutionDescriptor e_d)
    {
        frame = f;
        codi = ise;
        ed = e_d;
        status=SCRIPT_NOT_EXECUTED;
        try
        {
            i.set("codi", codi);  
            i.set("frame", frame);  
            i.set("ed", ed);  
        }
        catch (Throwable e)
        {
            status = SCRIPT_EXCEPTION;
            Configuration.getConfiguration().getDebugEntity().addLog("Script Exception!", 0);
            Configuration.getConfiguration().getDebugEntity().addLog(e, 0);
        }
        
        dataSet = true;
    }    
    
    
    public void setData(VeccyPanel ise, Frame f, ExecutionDescriptor e_d)
    {
        frame = f;
        vecci = ise;
        ed = e_d;
        status=SCRIPT_NOT_EXECUTED;
        try
        {
            i.set("vecci", vecci);  
            i.set("frame", frame);  
            i.set("ed", ed);  
        }
        catch (Throwable e)
        {
            status = SCRIPT_EXCEPTION;
            Configuration.getConfiguration().getDebugEntity().addLog("Script Exception!", 0);
            Configuration.getConfiguration().getDebugEntity().addLog(e, 0);
        }
        
        dataSet = true;
    }
    
    
    String out="";

    
     String add="";
     public String addException(Throwable e)
     {
         add="Exception!!! \n";
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
        if ((e instanceof bsh.EvalError) || (e instanceof bsh.TargetError)|| (e instanceof bsh.ParseException))
        {
            //add = e.toString() +"\n"+add;

            add = de.malban.util.UtilityString.replace(add, ";", ";\n");
            add = de.malban.util.UtilityString.replace(add, "'' :", ":\n");
            add = de.malban.util.UtilityString.replace(add, "invocation: Method", "invocation: Method\n\t");
            add = de.malban.util.UtilityString.replace(add, "not found ", "\nnot found ");
            add = de.malban.util.UtilityString.replace(add, "evaluation of: ``", "evaluation of: \n ");

        }
        return add;
     }

     public String getOutString()
    {
        String results = "";
        try
        {
            Object r = i.get("out");
            if (r != null)
            {
                String _out = ((String) (r));
                results+="out:\n"+_out+"\n";
            }
        }
        catch (Throwable e)
        {
            results+="Error evaluating results further:\n";
            results+=de.malban.util.Utility.getStackTrace(e)+"\n---\n";
        }
        if (iRet.error)
        {
            results += "ERROR!\n";
            results += addException(iRet.e)+"\n\n";
            return results;
        }
        return results;
    }
    
    public void execute()
    {
        if (!dataSet) return;
        if (script.trim().length()==0)
            return;

        if (status == SCRIPT_EXCEPTION) return;
        
        try
        {
            out="";
            i.set("out", out);
            String imports = "";

            imports += "import de.malban.graphics.GFXVector;\n";
            imports += "import de.malban.graphics.Vertex;\n";
            imports += "import de.malban.util.*;\n";
            imports += "import de.malban.vide.*;\n";
            imports += "import de.malban.vide.script.*;\n";
            
            iRet = InterpreterUtility.askScript(i, imports+script);
            status = SCRIPT_EXECUTED;
            error = "Execution ok!";
        }
        catch (Throwable e)
        {
            status = SCRIPT_EXCEPTION;
            Configuration.getConfiguration().getDebugEntity().addLog("Script Exception!", 0);
            Configuration.getConfiguration().getDebugEntity().addLog(e, 0);
            error = "Execution error!\n"+e.toString();
        }
    }
    String error = "";
    public String getErrorString()
    {
        return error;
    }
}
