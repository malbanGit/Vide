/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.jdbc;
import de.malban.gui.dialogs.ShowWarningDialog;
import de.malban.jdbc.DBConnectionData;
import java.sql.*;
import java.util.*;
/**
 * With this class all JDBC-Queries are executed.
 * All Data is stored in a Map. Each Data got from the database is kept in a SQLDataObject.
 * Methods like a TableModel are provided to access the data.
 *
 * <aBR>"last Errors" and "last Exceptions" are kept for client viewing - if done...
 * @author Malban
 */
public class SQLResult implements JavaSQLResult
{
    private UserSQLStatement mStatement = null;
    private transient String mLastError="uncalled";
    private transient Throwable mLastException=null;
    private Connection mConnection = null;
    private DBConnectionData mCData = null;
    private HashMap<String, SQLDataObject> mTableData = new HashMap<String, SQLDataObject>();
    private HashMap<String, Vector<SQLDataObject>> mTableRows = new HashMap<String, Vector<SQLDataObject>>();
    private Vector<SQLDataObject> mColumnNames = new Vector<SQLDataObject>();
    private Vector<HashMap<String, SQLDataObject>> mTableMappedRows = new Vector<HashMap<String, SQLDataObject>>();
    private String mLastAuto="";

    private HashMap<String, Integer> columnNameMapping = new HashMap<String, Integer>();
    
    public String getLastID()
    {
        // TODO: Oracle todo!!!
        return mLastAuto;
    }

    /**
     * Reset the statement - everything internaly is deleted.
     */
    public void clearAll()
    {
        mTableData = new HashMap<String, SQLDataObject>();
        mTableRows = new HashMap<String, Vector<SQLDataObject>>();
        mColumnNames = new Vector<SQLDataObject>();
        columnNameMapping = new HashMap<String, Integer>();
        mStatement = null;
        mLastError="uncalled";
        mLastException=null;
        mConnection = null;
        mCData = null;
    }
    
    public int getRowCount()
    {
        if (mTableRows!=null)
            return mTableRows.size();
        return 0;
    }
    public int getColumnCount()
    {
        if (mColumnNames!=null)
            return mColumnNames.size();
        return 0;
    }
    public String getColumnName(int i)
    {
        if (mColumnNames!=null)
            return mColumnNames.elementAt(i).mColumnName;
        return "";
    }
    public String getTableName(int i)
    {
        if (mColumnNames!=null)
            return mColumnNames.elementAt(i).mTableName;
        return "";
    }    
    
    public Throwable getLastException()
    {
        return mLastException;
    }
    
    public String getLastError()
    {
        return mLastError;
    }
    
    /**
     * The Heart of the class. Logically a statement and a dbconnection should be set in advance.
     * 
     * Problems with lobs are reported via JOptionPane - information regarding that is NOT kept in last Error/ last Exception
     * @return
     */
    public boolean doDBQuery()
    {
        if (mStatement==null)
        {
            mLastError = "Statement not set";
            mLastException = null;
            return false;
        }
        if (mCData==null)
        {
            mLastError = "DBConnectionData not set";
            mLastException = null;
            return false;
        }
        Statement st = null;
        String sql = "";
	ResultSet resultSet = null;
    
        if (!mCData.isOpen())
        {
            mLastError = "Connection is not open!";
            mLastException = null;
            return false;
            
        }
        
        mConnection = mCData.getConnection();
        
        
        
        if (!mCData.mLastError.equalsIgnoreCase("ok"))
        {
            mLastError = mCData.mLastError;
            mLastException = mCData.mLastException;
            return false;
        }
        try 
        {
            st = this.mConnection.createStatement();
        }
        catch (Exception e) 
        {
            mLastError = "Create Statement error";
            mLastException = e;
            return false;
        }
        sql = mStatement.getBuildStatement();
        try
        {
            resultSet = st.executeQuery(sql);
        }
        catch (Exception e) 
        {
            mLastError = "Execute Statement error: " + sql;
            mLastException = e;
            return false;
        }
        
        boolean ret = fillResultSet(resultSet);
        if (!ret) return false;
        
        mLastError = "OK";
        mLastException = null;
        return true;
    }

    private boolean fillResultSet(ResultSet resultSet)
    {
        mColumnNames = new Vector<SQLDataObject>();
        int numberOfColumns = 0;

        ResultSetMetaData rsmd;
        try
        {
            rsmd = resultSet.getMetaData();
            numberOfColumns = rsmd.getColumnCount();
            for (int i=0; i<numberOfColumns; i++)
            {
                SQLDataObject data = new SQLDataObject();
                data.mColumnName = rsmd.getColumnName(i+1) ;
                data.mSQLDataType = rsmd.getColumnTypeName(i+1);
                data.mPrecision = rsmd.getPrecision(i+1);
                data.mScale = rsmd.getScale(i+1);
            
                data.mTableName = rsmd.getTableName(i+1) ;
                mColumnNames.add(data);
                columnNameMapping.put(data.mColumnName.toUpperCase(), i); 
            }
        }
        catch (Exception e) 
        {
            mLastError = "Get MetaData error";
            mLastException = e;
            return false;
        }
        
        mTableData = new HashMap<String, SQLDataObject>();
        mTableRows = new HashMap<String, Vector<SQLDataObject>>();
        mTableMappedRows = new Vector<HashMap<String, SQLDataObject>>();
        try
        {
            int rowCount =0;
            while (resultSet.next()) 
            {
                Vector<SQLDataObject> row = new Vector<SQLDataObject>();
                HashMap<String, SQLDataObject> mappedRow = new HashMap<String, SQLDataObject>();
                for (int i=0; i<numberOfColumns; i++)
                {
                    int type  = rsmd.getColumnType(i+1);
                    
                    
                    
                    SQLDataObject data = (SQLDataObject) mColumnNames.elementAt(i).clone();
                    Object o = resultSet.getObject(i+1);
                    if (o==null)
                    {
                        data.mData="null";
                    }
                    else
                    {
                        data.mData=o.toString();
                        if ((data.mData.indexOf(".DATE")!= -1) || (type == java.sql.Types.DATE))
                        {
                            java.sql.Date d = resultSet.getDate(i+1);
                            data.mData=d.toString();
                        }
                        if ((data.mData.indexOf(".TIMESTAMP")!= -1)|| (type == java.sql.Types.TIMESTAMP)|| (type == java.sql.Types.TIMESTAMP_WITH_TIMEZONE))
                        {
                            java.sql.Timestamp t = resultSet.getTimestamp(i+1);
                            data.mData=t.toString();
                        }
                        try
                        {
                            if ((data.mData.indexOf(".CLOB")!= -1)|| (type == java.sql.Types.CLOB))
                            {
                                String clob = resultSet.getClob(i+1).getSubString(1, (int) resultSet.getClob(i+1).length());
                                data.mLobData = clob.getBytes();
                                data.mIsLob=true;
                                data.mLobBin=false;
                            }
                            if ((data.mData.indexOf(".BLOB")!= -1)|| (type == java.sql.Types.BLOB))
                            {
                                Blob blob = (Blob)o;// resultSet.getBlob(i+1); // not allowed to call twice (alread by getObject)
                                data.mLobData = blob.getBytes((long)1, (int)blob.length());
                                data.mIsLob=true;
                                data.mLobBin=true;
                            }
                        }
                        catch (Throwable e)
                        {
                           // javax.swing.JOptionPane.showMessageDialog(null, e.toString() ,"LOB Problem",  javax.swing.JOptionPane.INFORMATION_MESSAGE); 
                            ShowWarningDialog.showWarningDialog("LOB Problem", e.toString());
                        }
                    }
                    row.addElement(data);
                    
                    mappedRow.put(mColumnNames.elementAt(i).mColumnName, data);
                    mTableData.put("DATA_"+rowCount+"_"+i, data);
                }
                mTableRows.put("ROW_"+rowCount, row);
                mTableMappedRows.addElement(mappedRow);
                rowCount++;
            }
        }
        catch (Exception e) 
        {
            mLastError = "Get ResultData error";
            mLastException = e;
            return false;
        }  
        return true;
    }    
    public boolean doDBChange()
    {
        return doDBChange("");
    }
    
    public boolean doDBChange(String seq)
    {
        if (mStatement==null)
        {
            mLastError = "Statement not set";
            mLastException = null;
            return false;
        }
        if (mCData==null)
        {
            mLastError = "DBConnectionData not set";
            mLastException = null;
            return false;
        }
        Statement st = null;
        String sql = "";
	int result = -1;
        if (!mCData.isOpen())
        {
            mLastError = "Connection is not open!";
            mLastException = null;
            return false;
            
        }
        
        mConnection = mCData.getConnection();
        sql = mStatement.getBuildStatement();

        if (!mCData.mLastError.equalsIgnoreCase("ok"))
        {
            mLastError = mCData.mLastError;
            mLastException = mCData.mLastException;
            return false;
        }
        try 
        {
            st = this.mConnection.createStatement();
        }
        catch (Exception e) 
        {
            mLastError = "Create Statement error: "+sql;
            mLastException = e;
            return false;
        }
        try
        {
            // execution of a statement WITHOUT generated keys throes an exception "illegal form for long" or somewthing like that!
            if (sql.toUpperCase().startsWith("UPDATE")) 
                result = st.executeUpdate(sql, Statement.NO_GENERATED_KEYS);
            else
                result = st.executeUpdate(sql, Statement.RETURN_GENERATED_KEYS);
            ResultSet rSet = st.getGeneratedKeys();        
            fillResultSet(rSet);

            if (mCData.mType.equalsIgnoreCase("oracle"))
            {
                if (seq.length()>0)
                {
                    sql = "select "+seq+".currval from dual";
                    ResultSet resultSet = null;
                    try
                    {
                        Statement st2 = this.mConnection.createStatement();
                        resultSet = st2.executeQuery(sql);
                        resultSet.next();
                        Object o = resultSet.getObject(1);
                        mLastError = "Sequence getting success";
                        if (o!=null)
                        {
                            mLastAuto=o.toString();
                        }
                    }
                    catch (Exception e) 
                    {
                        mLastError = "LAST INSERT ID FAILED";
                        mLastException = e;
                        return false;
                    }
                    
                }
            }
            if (mCData.mType.equalsIgnoreCase("mysql"))
            {
                ResultSet resultSet = null;
                try
                {
                    Statement st2 = this.mConnection.createStatement();
                    resultSet = st2.executeQuery("SELECT LAST_INSERT_ID()");
                    boolean valid = resultSet.first();

                    if (valid)
                    {
                        Object o = resultSet.getObject(1);
                        mLastError = "LAST INSERT ID FAILED";
                        if (o!=null)
                        {
                            mLastAuto=o.toString();
                        }
                    }
                    else
                    {
                        System.out.println("Mist");
                    }
                }
                catch (Exception e) 
                {
                    mLastError = "LAST INSERT ID FAILED";
                    mLastException = e;
                    return false;
                }
            }
            if (mCData.mType.toLowerCase().indexOf("derby") != -1)
            {
                if (getRowCount()>0)
                {
                    SQLDataObject d =  getData(0,0);
                    mLastAuto = d.mData;
                }
            }
            
        }
        catch (Exception e) 
        {
            mLastError = "Execute Statement error: "+sql;
            mLastException = e;
            return false;
        }
        mLastError = "OK";
        mLastException = null;
        return true;
    }

    /**
     * get a complete row of the results
     * @param row
     * @return
     */
    public HashMap<String, SQLDataObject> getMappedRow(int row)
    {
        if ((row <0 ) || (row >= mTableMappedRows.size())) return new HashMap<String, SQLDataObject>();
        return mTableMappedRows.elementAt(row);
    }

    /**
     * get a complete row of the results
     * @param row
     * @return
     */
    public Vector<SQLDataObject> getRow(int row)
    {
        return mTableRows.get("ROW_"+row);
    }

    /**
     * get a Hashmap containing a vector which contains one row
     * Key is: "ROW_#" where # is the row 
     * @param row
     * @return
     */
    public HashMap<String, Vector<SQLDataObject>> getAllRows(int row)
    {
        return mTableRows;
    }

    /**
     * get a Hashmap containing all data individually
     * Key is: "DATA_#_#" where the first # is row and the second # is column
     * @param row
     * @return
     */
    public HashMap<String, SQLDataObject> getAllData(int row)
    {
        return mTableData;
    }
    public SQLDataObject getData(int row, int column)
    {
        return mTableData.get("DATA_"+row+"_"+column);
    }
    public SQLDataObject getData(int row, String columnName)
    {
        int column = getColumnNumber(columnName);
        return getData( row,  column);
    }
    
    public void setStatement(UserSQLStatement s)
    {
        mStatement = s;
    }
    public void setDBConnectionData(DBConnectionData d)
    {
        mCData = d;
    }
    
    // if there are coumns with same names - the LAST column number is returned!
    public int getColumnNumber(String columnName)
    {
        if (columnNameMapping == null) return -1;
        if (!columnNameMapping.containsKey(columnName.toUpperCase())) return -1;
        return columnNameMapping.get(columnName.toUpperCase()); 
    }
}
