/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.jdbc;

/** Wrapper Class that contains ONE Data Object of a Query.
 * All Data is kept as Strings, only LOBS are kept as byte[].
 * All Data of a Query is read into Memory - tables with many or large LOBS - or
 * Queries with huge results will result in -> Java Out of Memeory...
 * 
 * <BR>All data is (again) kept in public fields.
 *
 * @author Malban
 */
public class SQLDataObject {
    /**
     * Seems JDBC does not support that - never got a table name right...
     */
    public String mTableName = new String();
    public String mColumnName = new String();
    public String mData = new String();
    public String mSQLDataType = new String();
    public int mPrecision = 0;
    public int mScale = 0;
    public boolean mIsLob = false;
    /**
     * BLOB == true, CLOB == false...
     */
    public boolean mLobBin=false;

    public byte[] mLobData=null;

    /**
     * As of now BLOB is not cloned - perhaps later - never needed it!
     * @return
     */
    @Override protected Object clone()
    {
        SQLDataObject o=new SQLDataObject();
        o.mTableName = mTableName;
        o.mColumnName = mColumnName;
        o.mData = mData;
        o.mSQLDataType = mSQLDataType;
        o.mIsLob = mIsLob;
        o.mLobBin = mLobBin;
        o.mPrecision = mPrecision;
        o.mScale = mScale;
        return o;
    }
}