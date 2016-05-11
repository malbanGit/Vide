package de.malban.jdbc;

import de.malban.gui.dialogs.ShowWarningDialog;
import java.util.*;
import javax.swing.JOptionPane;

/** Class that holds all Data neccessary for a JDBC connection.
 * 
 * !!!!!
 * Statements mit dem selben Namen aber in einer anderen Klasse werden NICHT unterschieden
 * Sprich, sie überschreiben sich gegenseitig!!!
 * !!!!!
 */
public class UserSQLStatementPool  
{
    public static final String DEFAULT_XML_NAME = new String("sqlStatements.xml");
    private String mFileName = DEFAULT_XML_NAME;
    private HashMap<String, UserSQLStatement> mUserSQLStatement = new HashMap<String, UserSQLStatement>();

   public UserSQLStatementPool(String name)
    {
        mFileName = name;
        init();
    }
     public UserSQLStatementPool()
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
//            JOptionPane.showMessageDialog(null, e.toString() ,"Lade Problem Statements...",  JOptionPane.INFORMATION_MESSAGE); 
            ShowWarningDialog.showWarningDialog("Statements Lade Problem...", e.toString());
            return false;
        }
    }
  
    /**
     * Save all Data to XML (all Statements and all DB-Connections.
     */
    public boolean load()
    {
        mUserSQLStatement = UserSQLStatement.getHashMapFromXML(mFileName);
        return true;
    }

    /**
     * Save all Data to XML (all Statements and all DB-Connections.
     */
    public void save()
    {
        UserSQLStatement.saveCollectionAsXML(mFileName, mUserSQLStatement.values());
    }
  
  /** 
     * Replaces a statement bye another. Replaced Statement is gotten via st.mName.
     * @param st
     */
    public void put(UserSQLStatement st)
    {
        // look kind of weird, since a HashMap should do that by itseld - alas - it seems it doesnt allways...
        
        mUserSQLStatement.remove(st.mName);
        mUserSQLStatement.put(st.mName, st);                                           
    } 

    /**
     * Proxy to access underlying HashMap
     * @param key
     * @return
     */
    public UserSQLStatement get(String key) 
    {
        return mUserSQLStatement.get(key);
    }

    /**
     * Proxy to access underlying HashMap (not a clone!!!)
     * @param key
     * @return
     */
    public HashMap<String, String> getClasses()
    {
        HashMap<String, String> mClasses = new HashMap<String, String>();
        Collection<UserSQLStatement> col = mUserSQLStatement.values();
        Iterator<UserSQLStatement> iter = col.iterator();
        while (iter.hasNext())
        {
            UserSQLStatement item = (UserSQLStatement) iter.next();
            mClasses.put(item.mKlasse, item.mKlasse);
        }
        return mClasses;
    }
    
        /**
     * Get all Statements of one "class"
     * @param key
     * @return
     */
    public HashMap<String, UserSQLStatement> getClassStatements(String filter) 
    {
        HashMap<String, UserSQLStatement> mFilteredStatement = new HashMap<String, UserSQLStatement>();
        Collection<UserSQLStatement> col = mUserSQLStatement.values();
        Iterator<UserSQLStatement> iter = col.iterator();
        while (iter.hasNext())
        {
            UserSQLStatement item = (UserSQLStatement) iter.next();
            if (item.mKlasse.equalsIgnoreCase(filter))
            {
                mFilteredStatement.put(item.mName, item);
            }
        }
        return mFilteredStatement;
    }

}
