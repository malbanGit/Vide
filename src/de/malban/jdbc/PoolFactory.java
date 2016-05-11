package de.malban.jdbc;

import java.util.HashMap;

public final class PoolFactory  
{
    private HashMap<String, DBConnectionDataPool> mDBConnections = new HashMap<String, DBConnectionDataPool>();
    private HashMap<String, UserSQLStatementPool> mStatementPool = new HashMap<String, UserSQLStatementPool>();
    
    public static PoolFactory POOL = new PoolFactory();
    // Factory MUST be Singleton!
    private PoolFactory() {}
   
    public DBConnectionDataPool getConnectionPool()
    {
        DBConnectionDataPool pool = mDBConnections.get(DBConnectionDataPool.DEFAULT_XML_NAME);
        if (pool==null)
        {
            pool = new DBConnectionDataPool();
            mDBConnections.put(DBConnectionDataPool.DEFAULT_XML_NAME, pool);
        }
        return pool;
    }
    
    public UserSQLStatementPool getStatementPool()
    {
        UserSQLStatementPool pool = mStatementPool.get(UserSQLStatementPool.DEFAULT_XML_NAME);
        if (pool==null)
        {
            pool = new UserSQLStatementPool();
            mStatementPool.put(UserSQLStatementPool.DEFAULT_XML_NAME, pool);
        }
        return pool;
   }

    public DBConnectionDataPool getConnectionPool(String name)
    {
        DBConnectionDataPool pool = mDBConnections.get(name);
        if (pool==null)
        {
            pool = new DBConnectionDataPool(name);
            mDBConnections.put(name, pool);
        }
        return pool;
    }
    
    public UserSQLStatementPool getStatementPool(String name)
    {
        UserSQLStatementPool pool = mStatementPool.get(name);
        if (pool==null)
        {
            pool = new UserSQLStatementPool(name);
            mStatementPool.put(name, pool);
        }
        return pool;
   }
}
