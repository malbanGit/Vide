/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.jdbc;

import de.malban.util.Utility;
import de.malban.*;
import de.malban.gui.dialogs.ShowErrorDialog;
import de.malban.gui.dialogs.ShowWarningDialog;
import de.malban.util.UtilityString;
import java.util.*;
import javax.swing.*;
import java.io.*;
import java.sql.*;

import javax.xml.parsers.SAXParserFactory;  
import javax.xml.parsers.SAXParser;

/** Class that holds all Data neccessary for a JDBC connection. 
 * JDBC Connections are supported for following DB´s:
 * Oracle (tested)
 * MySQL (tested)
 * Informix (tested)
 * Postgre (untested)
 * MSSQL (tested)
 * 
 * Untested means, driver should be loaded, and probably everthing is ok. But
 * implementation was done by reading examples - as of now a connection to a DB is 
 * not tested.
 * 
 * The Class can be serialized. Or Exported as XML.
 * export to XML provides "raw" output of the instance in String form (without head/footer) * 
 *
 * Due to lazyness of the author all Data is kept in public variables. It is bad - 
 * I know but can't be bothered to write wrappers for all of them.
 * @author A104032
 */
public class DBConnectionData implements Serializable 
{
    /** used as "foreign key" in UserSQLStatement
     * 
     */
    public String mName= new String();
    public String mType= new String();
    public String mUser= new String();
    public String mPasswd= new String();
    public String mDBName= new String();
    public String mHost= new String();
    public String mPort= new String();
    public String mServer= new String();
    public String mURL = new String();
    public String mClass = new String();

    /** 
     * 
     */
    
    public String mDriverString="";

    /** If an Error occured - a small information about the error is kept here - or "OK"
     * 
     */
    public transient String mLastError;

    /** If an Excpetion occured - it is kept here - or null
     * 
     */
    public transient Throwable mLastException;

    private transient Connection mConnection = null;
    private static DBConnectionXMLHandler XMLHANDLER = new DBConnectionXMLHandler();


    /** Exports as string (xml) the relevant data of the class.
     * 
     * @return
     */
    private String exportXML()
    {

        String s = new String();
        s += "\t<Connection>\n";
        s += "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n";
        s += "\t\t<Type>"+UtilityString.toXML(mType)+"</Type>\n";
        s += "\t\t<User>"+UtilityString.toXML(mUser)+"</User>\n";
        s += "\t\t<Password>"+UtilityString.toXML(mPasswd)+"</Password>\n";
        s += "\t\t<DatabaseName>"+UtilityString.toXML(mDBName)+"</DatabaseName>\n";
        s += "\t\t<Host>"+UtilityString.toXML(mHost)+"</Host>\n";
        s += "\t\t<Port>"+UtilityString.toXML(mPort)+"</Port>\n";
        s += "\t\t<DriverString>"+UtilityString.toXML(mDriverString)+"</DriverString>\n";
        s += "\t\t<Server>"+UtilityString.toXML(mServer)+"</Server>\n";
        s += "\t\t<URL>"+UtilityString.toXML(mURL)+"</URL>\n";
        s += "\t\t<CLASS>"+UtilityString.toXML(mClass)+"</CLASS>\n";
        s += "\t</Connection>\n";
        return s;
    }

    /** The Name of the Connection is returned. (mName)
     * 
     * @return 
     */
    @Override public String toString()
    {
        return mName;
    }

    /** Gives back a JDBC Object, which can execute Queries to the DB. 
     * 
     * @return
     */
    public JavaSQLResult getSQLResult()
    {
        SQLResult myResult = new SQLResult();
        myResult.setDBConnectionData(this);
        return myResult;
    }

    public String getConnectionString()
    {
        String url = new String();

         if (mURL != null)
         {
             if (mURL.length() != 0)
             {
                 url = mURL;
                 return url;
             }
         }
        
        if (mType.equalsIgnoreCase("oracle"))
        {
            // "jdbc:oracle:thin:@host:port:DBname";
            url = "jdbc:oracle:thin:@";
            url = url + mHost+":"+mPort+":"+mDBName;
        }
        if ((mType.equalsIgnoreCase("Derby (Java DB)")))
        {
            // "jdbc:derby:jankemidb;user=admin;password=admin"
            url = "jdbc:derby:";
            url = url + mDBName+";user="+mUser+";password="+mPasswd;
        }
        else if (mType.equalsIgnoreCase("mysql"))
        {
            // "jdbc:mysql://host:port/DBName";
            url = "jdbc:mysql://";
            url = url + mHost+":"+mPort+"/"+mDBName;
        }
        else if (mType.equalsIgnoreCase("informix"))
        {
            // jdbc:informix-sqli://[{ip-address|host-name}:port-number][/dbname]:INFORMIXSERVER=servername[;user=user;password=password] [;name=value[;name=value]...]        
            url = "jdbc:informix-sqli://";
            url = url + mHost+":"+mPort+"/"+mDBName+":informixserver="+mServer+";user="+mUser+";password="+mPasswd;
        }
        else if (mType.equalsIgnoreCase("mssql"))
        {
            // "jdbc:sqlserver://host:port;databaseName=<DBNAME>;user=<USER>;password=<PASSWD>";
            url = "jdbc:sqlserver://";
            url = url + mHost+":"+mPort+";databaseName="+mDBName+";user="+mUser+";password="+mPasswd;                       

            if (mPort.length()!=0)
            {
                // no port - use instanz
                url = "jdbc:sqlserver://";
                url = url + mHost+":"+mPort+";databaseName="+mDBName+";user="+mUser+";password="+mPasswd;                       
            }
            else
            {
                if (mServer.length()!=0)
                {
                    // no port - use instanz
                    url = "jdbc:sqlserver://";
                    url = url + mHost+"\\"+mServer+";databaseName="+mDBName+";user="+mUser+";password="+mPasswd;
                }
                else
                {
                    // no port - no instance look for default by driver
                    url = "jdbc:sqlserver://";
                    url = url + mHost+";databaseName="+mDBName+";user="+mUser+";password="+mPasswd;
                }
            }
        
        }
        else if (mType.equalsIgnoreCase("postgre"))
        {
            // "jdbc:postgresql://host:port/database
            url = "jdbc:postgresql://";
            url = url + mHost+":"+mPort+"/"+mDBName;
        }
        return url;
    }
    
    public boolean isOpen()
    {
        return mConnection != null;
    }
    public Connection getConnection()
    {
        if (mConnection == null)
        {
            mLastError = "Connection is not Open!";
            return null;
        }
        mLastError = "OK";
        return mConnection;
    }
    
    public void commit()
    {
        try {
            if (mConnection != null)
            {
                mConnection.commit();
                mLastException = null;
                mLastError = "OK";
            }
        } catch (Exception e) {
            mLastException = e;
            mLastError = "Connection commit Error";
        }            
    }
    public void rollback()
    {
        try {
            if (mConnection != null)
            {
                mConnection.rollback();
                mLastException = null;
                mLastError = "OK";
            }
        } catch (Exception e) {
            mLastException = e;
            mLastError = "Connection rollback Error";
        }            
    }
    
    /** Returnes a JDBC Connection for the given Database type (as in mType).
     * 
     * @return
     */
    public Connection openConnection()
    {
        mConnection = null;
        String url = new String();
        if (mType.equalsIgnoreCase("oracle"))
        {
                // DB - Verbindung aufbauen
                try {
                        Class.forName("oracle.jdbc.OracleDriver").newInstance();

                        url = getConnectionString();

                        mConnection = DriverManager.getConnection(url, mUser, mPasswd);
                        mLastException = null;
                        mLastError = "OK";
                } catch (Exception e) {
                    mLastException = e;
                    mLastError = "Connection ERROR";
                }            
        }
        else if (mType.equalsIgnoreCase("mysql"))
        {
                // DB - Verbindung aufbauen
                try {
                        Class.forName("com.mysql.jdbc.Driver").newInstance();

                        url = getConnectionString();
                        
                        mConnection = DriverManager.getConnection(url, mUser, mPasswd);
                        mLastException = null;
                        mLastError = "OK";
                } catch (Exception e) {
                    mLastException = e;
                    mLastError = "Connection ERROR";
                }            
        }
        
        
        if ((mType.equalsIgnoreCase("Derby (Java DB)")))
        {
            // DB - Verbindung aufbauen
            try {
                    url = getConnectionString();
                    mConnection = DriverManager.getConnection(url);
                    mConnection.setAutoCommit(false);
                    mLastException = null;
                    mLastError = "OK";
            } catch (Exception e) {
                mLastException = e;
                mLastError = "Connection ERROR";
            }            

        }
        else if (mType.equalsIgnoreCase("informix"))
        {
            // DB - Verbindung aufbauen
            try {
                    Class.forName("com.informix.jdbc.IfxDriver").newInstance();

                    url = getConnectionString();

                    mConnection = DriverManager.getConnection(url);
                    mLastException = null;
                    mLastError = "OK";
            } catch (Exception e) {
                mLastException = e;
                mLastError = "Connection ERROR";
            }            
        }
        else if (mType.equalsIgnoreCase("mssql"))
        {
                // DB - Verbindung aufbauen
                try {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver").newInstance();
                        
                        url = getConnectionString();
                        
                        mConnection = DriverManager.getConnection(url);
                        mLastException = null;
                        mLastError = "OK";
                } catch (Exception e) {
                    mLastException = e;
                    mLastError = "Connection ERROR";
                }            
        }
        else if (mType.equalsIgnoreCase("postgre"))
        {
                // DB - Verbindung aufbauen
                try {
                        Class.forName("org.postgresql.Driver").newInstance();

                        url = getConnectionString();
                        
                        mConnection = DriverManager.getConnection(url, mUser, mPasswd);
                        mLastException = null;
                        mLastError = "OK";
                } catch (Exception e) {
                    mLastException = e;
                    mLastError = "Connection ERROR";
                }            
        }
        else if (mType.equalsIgnoreCase("generic PW"))
        {
            // DB - Verbindung aufbauen
                try {
                        Class.forName(mClass).newInstance();

                        url = getConnectionString();
                        
                        mConnection = DriverManager.getConnection(url, mUser, mPasswd);
                        mLastException = null;
                        mLastError = "OK";
                } catch (Exception e) {
                    mLastException = e;
                    mLastError = "Connection ERROR";
                }            
        }
        else if (mType.equalsIgnoreCase("generic total"))
        {
            // DB - Verbindung aufbauen
                try {
                        Class.forName(mClass).newInstance();

                        url = getConnectionString();
                        
                        mConnection = DriverManager.getConnection(url);
                        mLastException = null;
                        mLastError = "OK";
                } catch (Exception e) {
                    mLastException = e;
                    mLastError = "Connection ERROR";
                }            
        }
        else
        {
             mLastException = null;
             mLastError = "Non Supported DB Type";
        }
        return mConnection;
    }

    /**
     * Closes the Connection.
     */
    public void closeConnection()
    {
        try {
            if (mConnection != null)
            {
                mConnection.commit();
                mConnection.close();
                mLastException = null;
                mLastError = "OK";
            }
        } catch (Exception e) {
            mLastException = e;
            mLastError = "Connection close Error";
        }            
        mConnection = null;
    }
    
    /**
     * Gives a XML Parser Handler, with which a set of DBConnections can be loaded.
     * @return
     */
    private static DBConnectionXMLHandler getXMLParseHandler()
    {
        return XMLHANDLER;
    }
    
    /** Saves a Collection of DBConnection Data to a xml file, which is created.
     * 
     * @param filename
     * @param col
     * @return
     */
    public static boolean saveCollectionAsXML(String filename, Collection<DBConnectionData> col)
    {
        try 
        {
            PrintWriter pw = new PrintWriter(de.malban.Global.mBaseDir+filename);
            pw.print("<?xml version=\"1.0\"?>\n");
            pw.print("<AllConnections>\n");
            Iterator<DBConnectionData> iter = col.iterator();
            while (iter.hasNext())
            {
                DBConnectionData item = iter.next();
                pw.print(item.exportXML());
            }
            pw.print("</AllConnections>\n");
            pw.close();
        } 
        catch (IOException e) 
        {
            System.err.println(e.toString());
            return false;
        }
        return true;
    }

    /** Loads a HashMap from of DBConnectionData from an XML File and returns the
     * Data in a HashMap. Key is mName.
     * 
     * @param filename
     * @return
     */
    public static HashMap<String, DBConnectionData> getHashMapFromXML(String filename)
    {
        HashMap<String, DBConnectionData> dBConnections = new HashMap<String, DBConnectionData>();
        try 	
	{
            SAXParserFactory factory = SAXParserFactory.newInstance();
            SAXParser saxParser = factory.newSAXParser();
            DBConnectionXMLHandler h = DBConnectionData.getXMLParseHandler();
            saxParser.parse(de.malban.Global.mBaseDir+filename, h);
            dBConnections = h.getLastHashMap();
        } 
	catch (Throwable e) 
	{
//            JOptionPane.showMessageDialog(null, e.toString() ,"Connection Lade Problem...",  JOptionPane.INFORMATION_MESSAGE); 
            ShowWarningDialog.showWarningDialog("Connection Lade Problem...", e.toString());
        }
        return dBConnections;
    }
    
    static public String getExample(String type)
    {
        if (type.equalsIgnoreCase("")) return "";
        if (type.equalsIgnoreCase("oracle"))
        {
            return "jdbc:oracle:thin:@host:port:dbname";
        }
        else if (type.equalsIgnoreCase("mysql"))
        {
            return "jdbc:mysql://host:port/dbname";
        }
        else if (type.equalsIgnoreCase("Derby (Java DB)"))
        {
            return "jdbc:derby:<DBNAME>;user=<USERNAME>;password=<PASSWD>";
        }
        else if (type.equalsIgnoreCase("informix"))
        {
            return "jdbc:informix-sqli://host:port/databaseName:informixserver=<SERVER>;user=<USERNAME>;password=<PASSWD>";
        }
        else if (type.equalsIgnoreCase("mssql"))
        {
            return "jdbc:sqlserver://host[\\INSTANCE][:port];databaseName=<DBNAME>;user=<USERNAME>;password=<PASSWD>";
        }
        else if (type.equalsIgnoreCase("postgre"))
        {
            return "jdbc:postgresql://host:port/database";
        }
        else if (type.equalsIgnoreCase("generic total"))
        {
            return "something appropriate...";
        }
        else if (type.equalsIgnoreCase("generic PW"))
        {
            return "something appropriate...";
        }
        return "Not Supported DB Type";
    }
    
    public String getHelpText()
    {
        String help = new String();
        if (mType.equalsIgnoreCase("")) return "Select a Type to get Help!";
        if (mType.equalsIgnoreCase("oracle"))
        {
            help += "Oracle";
        }
        else if (mType.equalsIgnoreCase("mysql"))
        {
        }
        else if (mType.equalsIgnoreCase("informix"))
        {
        }
        else if (mType.equalsIgnoreCase("mssql"))
        {
            help+="Die allgemeine Form der Verbindungs-URL lautet:\njdbc:sqlserver://[serverName[\\instanceName][:portNumber]][;property=value[;property=value]]\nwobei: \n";
            help+="- jdbc:sqlserver:// (erforderlich) als Subprotokoll bezeichnet wird und konstant ist. \n";
            help+="- serverName (optional) die Adresse des Servers, darstellt, zu dem eine Verbindung hergestellt \n" +
                  "  werden soll. Dabei kann es sich um eine DNS- oder IP-Adresse bzw. \"localhost\" oder \n" +
                  "  \"127.0.0.1\" für den lokalen Computer handeln. Wenn der Servername nicht in der \n" +
                  "  Verbindungs-URL angegeben wird, muss er in der properties-Auflistung angegeben werden.\n";
            help+="- instanceName (optional) bezeichnet die Instanz auf \"serverName\", zu der eine Verbindung \n" +
                  "  hergestellt werden soll. Ohne Angabe wird eine Verbindung zur Standardinstanz erstellt.\n";
            help+="- portNumber (optional) bezeichnet den Port auf \"serverName\", zu dem eine Verbindung \n" +
                  "  hergestellt werden soll. Der Standardwert ist 1433. Wenn der Standardwert verwendet wird, \n" +
                  "  brauchen Sie den Port und den davor stehenden Doppelpunkt (':') in der URL nicht anzugeben.\n";
            help+="\nHinweis:\n";
            help+="Um eine optimale Leistung der Verbindung zu gewährleisten, sollten Sie \"portNumber\" \n" +
                  "festlegen, wenn Sie eine Verbindung zu einer benannten Instanz herstellen. Dadurch \n" +
                  "werden Roundtrips zum Server vermieden, um die Portnummer zu ermitteln. Wenn \"portNumber\" \n" +
                  "und \"instanceName\" verwendet werden, hat \"portNumber\" Vorrang und \"instanceName\" wird \n" +
                  "ignoriert.\n";
        }
        
        else if (mType.equalsIgnoreCase("postgre"))
        {
        }
        else if (mType.equalsIgnoreCase("generic total"))
        {
        }
        else if (mType.equalsIgnoreCase("generic PW"))
        {
        }
        return help;
    }
}
