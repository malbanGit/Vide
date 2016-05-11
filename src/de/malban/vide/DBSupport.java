/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide;

import de.malban.jdbc.DBConnectionData;
import de.malban.jdbc.DBConnectionDataPool;
import de.malban.jdbc.JavaSQLResult;
import de.malban.jdbc.UserSQLStatement;
import de.malban.util.UtilityString;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.sql.DriverManager;
import java.sql.Connection; 
import java.sql.DriverManager; 
import java.sql.ResultSet; 
import java.sql.ResultSetMetaData;
import java.sql.SQLException; 
import java.sql.Statement; 
import java.util.Vector;

/**
 *
 * @author Malban
 */
public class DBSupport {
    
    public static boolean DB_AVAILABLE = false;
    static String output="";
    
    
    
    public static boolean dbExists()
    {
        Connection connection=null;
        if (connection != null) return true;
        
        try
        {
            if (connection == null)
                 connection = DriverManager.getConnection("jdbc:derby:MacOneClickDB;user=admin;password=admin"); 
 
            // shutdown
            try
            {
                connection = DriverManager.getConnection("jdbc:derby:MacOneClickDB;user=admin;password=admin;shutdown=true;"); 
                //jLabel8.setText("Shutdown not happened... why?");
            }
            catch (Throwable x)
            {
                connection = null;
                //jLabel8.setText("Shutdown ...");
            }
            DB_AVAILABLE = true;
        }
        catch (Throwable e)
        {
            connection = null;
            System.out.println(e.getMessage());
            return false;
        }
        finally
        {
        }
        return true;
    }
    
    public static boolean createDB()
    {
        File ddl = new File("./src_db/dbCreate.sql");
        File sql = new File("./createMOC.sql");

        Vector <String > replace = new Vector<String>();
        Vector <String > with = new Vector<String>();
        

        replace.addElement("VARCHAR2");with.addElement("VARCHAR");
        replace.addElement(" CHAR)");with.addElement(")");
        replace.addElement(" NUMBER ");with.addElement(" DOUBLE ");
        replace.addElement("BLOB");with.addElement("BLOB(1M) ");
        replace.addElement("\"uid\"  ");with.addElement("\"uid\" "); // delete spaces!
        replace.addElement("\"uid\" INTEGER NOT NULL");with.addElement("\"uid\" INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) ");
        
        replace.addElement("\"uid\"");with.addElement("unique_id"); // delete spaces!
        
        UtilityString.replaceToNewFile(ddl, sql, replace, with);

        Connection connection=null;
        try
        {
            if (connection == null)
                connection = DriverManager.getConnection("jdbc:derby:MacOneClickDB;create=true;user=admin;password=admin"); 
            output="";
            PrintStream  os= new PrintStream(
             new OutputStream()
             {
               @Override
               public void write( int b )
               {
                   char[] c = {(char)b};
                   String s = new String(c);
                   output += s;
               }
             }
           );


           FileInputStream is = new FileInputStream(sql);
           // find derby
           // see: http://docs.oracle.com/javase/7/docs/api/java/nio/charset/Charset.html
           org.apache.derby.tools.ij.runScript(connection, is, "ISO-8859-1", os, "UTF-8");        
           os.flush();
           sql.delete();        
           //jTextArea1.setText(output);
           
           
            // SEQUENCE - not done by ddl
            //connection = DriverManager.getConnection("jdbc:derby:MacOneClickDB;user=admin;password=admin"); 
            // Create a statement
            Statement statement = connection.createStatement(); 
            
            // Execute a statement
            String create = "create sequence ids as int start with 0";
            boolean hasResult = statement.execute(create);             
            System.out.println(output+"\nSequence 'ids' generated... ");
           
            // shutdown
            try
            {
                connection = DriverManager.getConnection("jdbc:derby:MacOneClickDB;user=admin;password=admin;shutdown=true;"); 
                //jLabel8.setText("Shutdown not happened... why?");
            }
            catch (Throwable x)
            {
                connection = null;
                //jLabel8.setText("Shutdown ...");
            }
            DB_AVAILABLE = true;
        }
        catch (Throwable e)
        {
            sql.delete();        
            System.out.println(e.getMessage());
            return false;
        }
        finally
        {
        }

        // clean up
        return true;
    }
    
}
