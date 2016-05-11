package de.malban.jdbc;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;

/** SAX Handler to read a DBConnection xml document.
 *
 * @author Malban
 */
public class DBConnectionXMLHandler extends DefaultHandler
{
    private HashMap<String, DBConnectionData> mDBConnections;
    private DBConnectionData mCurrentData = null;
    private String mCurrentElement = null;
    
    /** Get the loaded Data as a HashMap
     * 
     * @return
     */
    
    public HashMap<String, DBConnectionData> getLastHashMap()
    {
        return mDBConnections;
    }
    
    @Override public void startDocument() throws SAXException
    {
            mCurrentData = new DBConnectionData();
            mDBConnections = new HashMap<String, DBConnectionData>();
    }
    
    @Override public void endDocument () throws SAXException
    {
    }
    
    @Override public void startElement(String uri,
                         String localName,
                         String qName,
                         Attributes attributes)
                  throws SAXException
    
    {
        mCurrentElement = qName;
        if (qName.equalsIgnoreCase("Connection"))
        {
            mCurrentData = new DBConnectionData();
        }
    }
    
    @Override public void characters(char[] ch, int start, int length)  
    {
        String s = new String( ch, start, length );
 
 
        if ("null".equalsIgnoreCase(s)) s=new String();
        if (mCurrentElement == null) return;
        if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
        if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
        if (mCurrentElement.equalsIgnoreCase("Type")) mCurrentData.mType += s;
        if (mCurrentElement.equalsIgnoreCase("User")) mCurrentData.mUser += s;
        if (mCurrentElement.equalsIgnoreCase("Password")) mCurrentData.mPasswd += s;
        if (mCurrentElement.equalsIgnoreCase("DatabaseName")) mCurrentData.mDBName += s;
        if (mCurrentElement.equalsIgnoreCase("Host")) mCurrentData.mHost += s;
        if (mCurrentElement.equalsIgnoreCase("Port")) mCurrentData.mPort += s;
        if (mCurrentElement.equalsIgnoreCase("DriverString")) mCurrentData.mDriverString += s;
        if (mCurrentElement.equalsIgnoreCase("URL")) mCurrentData.mURL += s;
        if (mCurrentElement.equalsIgnoreCase("Server")) mCurrentData.mServer += s;
    }
   @Override public void endElement(String uri,
                       String localName,
                       String qName)
                throws SAXException
    {
        if (qName.equalsIgnoreCase("Connection"))
        {
            if (mCurrentData != null)
            {
                if (mDBConnections != null)
                    mDBConnections.put(mCurrentData.mName, mCurrentData);
                mCurrentData = null;
            }
        }
        mCurrentElement = null;
    }
}
