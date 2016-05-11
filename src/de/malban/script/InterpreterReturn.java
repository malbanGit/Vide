/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.script;

/**
 *
 * @author Malban
 */
public class InterpreterReturn
{
    public String debug="";
    public String reason="";
    public boolean bRet=true;
    public boolean bCancel=false;
    public boolean bReturnGot = false;
    public Object data = null;

    public boolean bCommunication = false;
    public boolean bScriptAvailable=false;

    public boolean error = false;
    public Throwable e=null;
    public String scriptExecuted = "";

    @Override public String toString()
    {
        String ret ="";

        ret+="bRet: "+bRet+"\n";
        ret+="reason: "+reason+"\n";

        return ret;
    }
}
