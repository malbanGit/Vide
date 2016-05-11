package de.malban.jdbc;
import de.malban.jdbc.DBConnectionData;
import java.util.*;
import javax.swing.table.*;


/**
 *
 * @author Malban
 */
public interface JavaSQLResult {
    public boolean doDBQuery();
    public boolean doDBChange();
    public boolean doDBChange(String seq);
    public Throwable getLastException();
    public String getLastError();

    // Data is not a copy is a pointer to the real data
    // key for map (allRows) is: ROW_#
    // key for map (allData) is: DATA_#_# (row column)
    // key for row data is columnName
    public Vector<SQLDataObject> getRow(int row);
    public HashMap<String, Vector<SQLDataObject>> getAllRows(int row);
    public HashMap<String, SQLDataObject> getAllData(int row);
    public HashMap<String, SQLDataObject> getMappedRow(int row);

    public SQLDataObject getData(int row, int column);
    public SQLDataObject getData(int row, String column);
    public void setStatement(UserSQLStatement s);
    public void setDBConnectionData(DBConnectionData d);    
    public int getColumnCount();
    public int getRowCount();
    public String getColumnName(int i);
    public String getTableName(int i);
    public void clearAll();
    public String getLastID();
}
