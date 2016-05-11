package de.malban.jdbc;

import de.malban.gui.dialogs.ShowWarningDialog;
import de.malban.jdbc.DBConnectionData;
import java.sql.Connection;
import java.util.*;
import javax.swing.JOptionPane;

/** Class that holds all Data neccessary for a JDBC connection. 
 */
public class DBConnectionDataPool  
{
    public static final String DEFAULT_XML_NAME = new String("dbConncetions.xml");
    private String mFileName = DEFAULT_XML_NAME;

    private static de.malban.config.Logable D;
    static 
    {
        D = de.malban.config.Configuration.getConfiguration().getDebugEntity();
    }
    
    private HashMap<String, DBConnectionData> mDBConnections = new HashMap<String, DBConnectionData>();
    
    public DBConnectionDataPool(String name)
    {
        mFileName = name;
        init();
    }
    public DBConnectionDataPool()
    {
        init();
    }
    private boolean init()
    {
        try 
        {
            return load();
        }
        catch (Throwable e)
        {
            //JOptionPane.showMessageDialog(null, e.toString() ,"Lade Problem Connections...",  JOptionPane.INFORMATION_MESSAGE); 
            ShowWarningDialog.showWarningDialog("Connection Lade Problem...", e.toString());
            return false;
        }
        
    }

    /**
     * Save all Data to XML (all DB-Connections).
     */
    public boolean load()
    {
        mDBConnections = DBConnectionData.getHashMapFromXML(mFileName);
        return true;
    }

    /**
     * Save all Data to XML (all DB-Connections).
     */
    public void save()
    {
        DBConnectionData.saveCollectionAsXML(mFileName, getHashMap().values());
    }
    /**
     * Proxy to access underlying HashMap
     * @param key
     * @return
     */
    public int getSize() 
    {
        return mDBConnections.size();
    }

    /**
     * Proxy to access underlying HashMap (not a clone!!!)
     * @param key
     * @return
     */
    public HashMap<String, DBConnectionData> getHashMap() 
    {
        return mDBConnections;
    }

    /**
     * Proxy to access underlying HashMap 
     * @param key
     * @return
     */
    public void put(String key, DBConnectionData value) 
    {
        mDBConnections.put(key, value);
    }

    /**
     * Proxy to access underlying HashMap 
     * @param key
     * @return
     */
    public DBConnectionData get(String key) 
    {
        return mDBConnections.get(key);
    }
    
    
    public static DBConnectionData getConnection(String connectionName)
    {
        DBConnectionDataPool pool = PoolFactory.POOL.getConnectionPool();
        if (pool == null)
        {
            D.addLog("Connection pool could not be initialized!!");
            return null;
        }

        DBConnectionData data = pool.get(connectionName);
        
        if (data == null)
        {
            D.addLog("Connection not found in pool!");
            return null;
        }
        
        return data;
    }
}
