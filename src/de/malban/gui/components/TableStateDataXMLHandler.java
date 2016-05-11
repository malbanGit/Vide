package de.malban.gui.components;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  TableStateDataXMLHandler extends DefaultHandler
{
	private HashMap<String, TableStateData> mTableStateData;
	private TableStateData mCurrentData = null;
	private String mCurrentElement = null;
	private String mColumnEnabled = "";
	private Vector<Boolean> mColumnEnableds = null;
	private String mColumnOrgNo = "";
	private Vector<Integer> mColumnOrgNos = null;
	private String mColumnViewNo = "";
	private Vector<Integer> mColumnViewNos = null;
	private String mColumnWidth = "";
	private Vector<Integer> mColumnWidths = null;
	private String mColumnName = "";
	private Vector<String> mColumnNames = null;
	private String munused = "";
	public HashMap<String, TableStateData> getLastHashMap()
	{
		return mTableStateData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new TableStateData();
		mTableStateData = new HashMap<String, TableStateData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("TableStateData"))
		{
			mCurrentData = new TableStateData();
			mColumnEnabled = "";
			mColumnEnableds = new Vector<Boolean>();
			mColumnOrgNo = "";
			mColumnOrgNos = new Vector<Integer>();
			mColumnViewNo = "";
			mColumnViewNos = new Vector<Integer>();
			mColumnWidth = "";
			mColumnWidths = new Vector<Integer>();
			mColumnName = "";
			mColumnNames = new Vector<String>();
			munused = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("COLUMNENABLED")) mColumnEnabled += s;
		if (mCurrentElement.equalsIgnoreCase("COLUMNORGNO")) mColumnOrgNo += s;
		if (mCurrentElement.equalsIgnoreCase("COLUMNVIEWNO")) mColumnViewNo += s;
		if (mCurrentElement.equalsIgnoreCase("COLUMNWIDTH")) mColumnWidth += s;
		if (mCurrentElement.equalsIgnoreCase("COLUMNNAME")) mColumnName += s;
		if (mCurrentElement.equalsIgnoreCase("unused")) munused += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("COLUMNENABLED".equalsIgnoreCase(qName))
		{
			try{
			mColumnEnableds.addElement(Boolean.parseBoolean(mColumnEnabled));
			}catch (Throwable e){}
			mColumnEnabled="";
		}
		if ("COLUMNORGNO".equalsIgnoreCase(qName))
		{
			try{
			mColumnOrgNos.addElement(Integer.parseInt(mColumnOrgNo));
			}catch (Throwable e){}
			mColumnOrgNo="";
		}
		if ("COLUMNVIEWNO".equalsIgnoreCase(qName))
		{
			try{
			mColumnViewNos.addElement(Integer.parseInt(mColumnViewNo));
			}catch (Throwable e){}
			mColumnViewNo="";
		}
		if ("COLUMNWIDTH".equalsIgnoreCase(qName))
		{
			try{
			mColumnWidths.addElement(Integer.parseInt(mColumnWidth));
			}catch (Throwable e){}
			mColumnWidth="";
		}
		if ("COLUMNNAME".equalsIgnoreCase(qName))
		{
			mColumnNames.addElement(mColumnName);
			mColumnName="";
		}
		if ("TableStateData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mColumnEnabled = "";
				mCurrentData.mColumnEnabled = mColumnEnableds;
				mColumnOrgNo = "";
				mCurrentData.mColumnOrgNo = mColumnOrgNos;
				mColumnViewNo = "";
				mCurrentData.mColumnViewNo = mColumnViewNos;
				mColumnWidth = "";
				mCurrentData.mColumnWidth = mColumnWidths;
				mColumnName = "";
				mCurrentData.mColumnName = mColumnNames;
				mCurrentData.munused = munused;
				munused = "";
				mTableStateData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
