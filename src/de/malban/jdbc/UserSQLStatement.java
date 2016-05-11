/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.jdbc;

import de.malban.*;
import de.malban.gui.dialogs.ShowWarningDialog;
import de.malban.util.UtilityString;
import java.io.*;
import java.util.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;  
import javax.xml.parsers.SAXParser;

/** Data Class to store all Data regarding a User SQL Statement.
 * Data is kept as Usually in public variables.
 * <BR>
 * The Statement can contain placeholders for up to 6 variables. A Variable has the 
 * format "$v0" - "$v5".
 *
 * @author Malban
 */
public class UserSQLStatement implements Serializable, Cloneable
{
    class Var implements Serializable 
    {
        public int no;
        public String st;
        public String co;
        public Var(int n, String s, String c)
        {
            no = n;
            st = s;
            co = c;
        }
    }
    public String mKlasse;
    public String mName;
    public String mDescribtion;
    public String mStatement;
    public String mDBConnection; // NAME
    
    private HashMap mVars = new HashMap();
    private HashMap mStatements = new HashMap();

    /** Export a single Data Item to XML
     * 
     * @return
     */
    private String exportXML()
    {
        String s = new String();
        s += "\t<Statement>\n";
        s += "\t\t<Name>"+de.malban.util.UtilityString.toXML(mName)+"</Name>\n";
        s += "\t\t<Class>"+de.malban.util.UtilityString.toXML(mKlasse)+"</Class>\n";
        s += "\t\t<Describtion>"+de.malban.util.UtilityString.toXML(mDescribtion)+"</Describtion>\n";
        s += "\t\t<SQLStatement>"+de.malban.util.UtilityString.toXML(mStatement)+"</SQLStatement>\n";
        s += "\t\t<DBConnection>"+de.malban.util.UtilityString.toXML(mDBConnection)+"</DBConnection>\n";

        s += "\t\t<Variables>\n";
        for (int i=0; i<getVarNumberStatement();i++)
        {
            String var = getVarString(i);
            String comment = getVarComment(i);
            if (var == null) var = new String();
            if (comment == null) comment = new String();
            s += "\t\t\t<Variable>\n";
            s += "\t\t\t\t<Position>"+i+"</Position>\n";
            s += "\t\t\t\t<VariableContent>"+de.malban.util.UtilityString.toXML(var)+"</VariableContent>\n";
            s += "\t\t\t\t<Comment>"+de.malban.util.UtilityString.toXML(comment)+"</Comment>\n";
            s += "\t\t\t</Variable>\n";
        }
        s += "\t\t</Variables>\n";
        s += "\t</Statement>\n";
        return s;
    }

    @Override public Object clone() throws CloneNotSupportedException 
    {
        UserSQLStatement c = new UserSQLStatement();
        c.mKlasse = this.mKlasse;
        c.mName = this.mName;
        c.mDescribtion = this.mDescribtion;
        c.mStatement = this.mStatement;
        c.mDBConnection = this.mDBConnection; // NAME

        c.mVars = new HashMap();
        int i=0;
        String s = this.getVarString(i);
        while (s!=null)
        {
            String cm = this.getVarComment(i);
            c.setVar(i, s, cm);
            s = this.getVarString(i);
            i++;
        }
        
     
        c.mStatements = new HashMap();

        return c;
    }
    
    public UserSQLStatement()
    {
        mName = new String();
        mDescribtion = new String();
        mStatement = new String();
        mDBConnection = new String();
        mKlasse = new String();
    }
    
    public UserSQLStatement getCountStatement()
    {
        UserSQLStatement count = null;
        try
        {
            count = (UserSQLStatement) this.clone();
        }
        catch (Throwable e) {}
        String statement = count.getStatement();

        statement = de.malban.util.UtilityString.replaceWhiteSpaces(statement, " ");
        
        
        int index = statement.toUpperCase().indexOf(" FROM ");
        String rep = statement.substring(index);
        
        count.mStatement = "select count(*) " + rep;
        
        return count;
    }    
    
    public UserSQLStatement getSumCountStatement()
    {
        UserSQLStatement count = null;
        try
        {
            count = (UserSQLStatement) this.clone();
        }
        catch (Throwable e) {}
        String statement = count.getStatement();

        statement = de.malban.util.UtilityString.replaceWhiteSpaces(statement, " ");
        
        
        int index = statement.toUpperCase().indexOf(" FROM ");
        String rep = statement.substring(index);
        
        count.mStatement = "select sum(count(*)) " + rep;
        
        return count;
    }
    /**
     * return the SQL statemenat which may contain variable placeholders
     * @return
     */
    public String getStatement()
    {
        return mStatement;
    }
    
    /**
     * Get the stored Variable #
     * @param v
     * @return
     */
    public String getVarString(int v)
    {
        Var var = (Var) mVars.get(v);
        if (var != null)
        {
            return var.st;
        }
        return null;
    }
    
    /**
     * Get the Comment for Variable #
     * @param v
     * @return
     */
    public String getVarComment(int v)
    {
        Var var = (Var) mVars.get(v);
        if (var != null)
        {
            return var.co;
        }
        return null;
    }
    
    /**
     * Build a SQL executable Statement, variable placeholders are replaced with stored variables (if available)
     * @return
     */
    public String getBuildStatement()
    {
        String build = mStatement;
        
        for (int i=0; i<getVarNumberStatement();i++)
        {
            String var = getVarString(i);
            if (var != null)
            {
                build = de.malban.util.UtilityString.replace(build, "$v"+i, var) ;
            }
        }
        return build;
    }
    
    /**
     * How Many variable does the statement contain.
     * @return
     */
    // $v# Variablen start with 0
    public int getVarNumberStatement()
    {
        int count = 0;
        int start = 0;
        
        while (start != -1)
        {
            start = mStatement.indexOf("$v", start);
            
            if (start != -1) {
                count++;
                start+=1;
            }
        }
        return count;
    }

    /**
     * not implemented yet
     * @return
     */
    // $s# Statements results start with 0
    public int getStatementNumberStatement()
    {
        int count = 0;
        int start = 0;
        
        while (start != -1)
        {
            start = mStatement.indexOf("$s", start);
            if (start != -1) count++;
        }
        return count;
    }

    /**
     * How many variables are SET.
     * @return
     */
    public int getVarNumberSet()
    {
        return mVars.size();
    }
    
    /**
     * set a variable - Number of variable, Data of Variable and if available a comment
     * @param i
     * @param s
     * @param c
     */
    public void setVar(int i, String s, String c)
    {
        Var var = new Var(i,s,c);
        mVars.put(i, var);
    }

    public void clearVars()
    {
        mVars.clear();
    }

    @Override public String toString()
    {
        return mName;
    }

    private static UserSQLStatementXMLHandler XMLHANDLER = new UserSQLStatementXMLHandler();
    public static UserSQLStatementXMLHandler getXMLParseHandler()
    {
        return XMLHANDLER;
    }

    /** Save a Collection of Statements to a XML file.
     * 
     * @param filename
     * @param col
     * @return
     */
    public static boolean saveCollectionAsXML(String filename, Collection<UserSQLStatement> col)
    {
        try 
        {
            PrintWriter pw = new PrintWriter(de.malban.Global.mBaseDir+filename);
            pw.print("<?xml version=\"1.0\"?>\n");
            pw.print("<AllStatements>\n");
            Iterator<UserSQLStatement> iter = col.iterator();
            while (iter.hasNext())
            {
                UserSQLStatement item = iter.next();
                pw.print(item.exportXML());
            }
            pw.print("</AllStatements>\n");
            pw.close();
        } 
        catch (IOException e) 
        {
            System.err.println(e.toString());
            return false;
        }
        return true;
    }

    /**
     * Load a XML file of Statements. return is a HashMap of Statements, Key is mName.
     * @param filename
     * @return
     */
    public static HashMap<String, UserSQLStatement> getHashMapFromXML(String filename)
    {
        HashMap<String, UserSQLStatement> userSQLStatement = new HashMap<String, UserSQLStatement>();
        try 	
	{
            SAXParserFactory factory = SAXParserFactory.newInstance();
            SAXParser saxParser = factory.newSAXParser();
            UserSQLStatementXMLHandler h = UserSQLStatement.getXMLParseHandler();
            saxParser.parse(de.malban.Global.mBaseDir+filename, h);
            userSQLStatement = h.getLastHashMap();
        } 
	catch (Throwable e) 
	{
            e.printStackTrace();
//            JOptionPane.showMessageDialog(null, e.toString() ,"Statements Lade Problem...",  JOptionPane.INFORMATION_MESSAGE); 
            ShowWarningDialog.showWarningDialog("Statements Lade Problem...", e.toString());
        }
        return userSQLStatement;
    }

}
