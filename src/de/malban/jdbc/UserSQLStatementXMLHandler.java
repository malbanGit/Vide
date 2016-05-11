/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.jdbc;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;

/** SAX Handler to read a Statement xml document.
 *
 * @author Malban
 */
public class UserSQLStatementXMLHandler extends DefaultHandler
{
    private HashMap<String, UserSQLStatement> mUserSQLStatement;
    private UserSQLStatement mCurrentData = null;
    private String mCurrentElement = null;
    private String mComment = new String();
    private String mVariableContent = new String();
    private String mPosition  = new String();

    /** Return the last loaded data in a HashMap
     * 
     * @return
     */
    public HashMap<String, UserSQLStatement> getLastHashMap()
    {
        return mUserSQLStatement;
    }

    @Override public void startDocument() throws SAXException
    {
            mCurrentData = new UserSQLStatement();
            mUserSQLStatement = new HashMap<String, UserSQLStatement>();
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
        if (qName.equalsIgnoreCase("Statement"))
        {
            mCurrentData = new UserSQLStatement();
        }
    }

    
    @Override public void characters(char[] ch, int start, int length)  
    {
        
        String s = new String( ch, start, length );
        if (mCurrentElement == null) return;
        
        
        if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
        if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mKlasse += s;
        if (mCurrentElement.equalsIgnoreCase("Describtion")) mCurrentData.mDescribtion += s;
        if (mCurrentElement.equalsIgnoreCase("DBConnection")) mCurrentData.mDBConnection += s;
        if (mCurrentElement.equalsIgnoreCase("SQLStatement")) mCurrentData.mStatement += s;
    
        if (mCurrentElement.equalsIgnoreCase("Comment")) mComment += s;
        if (mCurrentElement.equalsIgnoreCase("VariableContent")) mVariableContent += s;
        if (mCurrentElement.equalsIgnoreCase("Position")) mPosition += s;
    }
   @Override public void endElement(String uri,
                       String localName,
                       String qName)
                throws SAXException
    {
        if ("Statement".equalsIgnoreCase(qName))
        {
            if (mCurrentData != null)
            {
                if (mUserSQLStatement != null)
                    mUserSQLStatement.put(mCurrentData.mName, mCurrentData);
                mCurrentData = null;
            }
        }
        if ("Variable".equalsIgnoreCase(qName))
        {
            mCurrentData.setVar(Integer.parseInt(mPosition), mVariableContent, mComment);
            mComment = new String();
            mVariableContent = new String();
            mPosition = new String();
        }
        mCurrentElement = null;
    }
}
