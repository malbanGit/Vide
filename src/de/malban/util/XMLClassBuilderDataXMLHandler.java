package de.malban.util;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  XMLClassBuilderDataXMLHandler extends DefaultHandler
{
	private HashMap<String, XMLClassBuilderData> mXMLClassBuilderData;
	private XMLClassBuilderData mCurrentData = null;
	private String mCurrentElement = null;
	private String mPackageName = "";
	private String mClassName = "";
	private String mFieldname = "";
	private Vector<String> mFieldnames = null;
	private String mXMLName = "";
	private Vector<String> mXMLNames = null;
	private String mType = "";
	private Vector<String> mTypes = null;
	public HashMap<String, XMLClassBuilderData> getLastHashMap()
	{
		return mXMLClassBuilderData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new XMLClassBuilderData();
		mXMLClassBuilderData = new HashMap<String, XMLClassBuilderData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("XMLClassBuilderData"))
		{
			mCurrentData = new XMLClassBuilderData();
			mPackageName = "";
			mClassName = "";
			mFieldname = "";
			mFieldnames = new Vector<String>();
			mXMLName = "";
			mXMLNames = new Vector<String>();
			mType = "";
			mTypes = new Vector<String>();
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("PACKAGENAME")) mPackageName += s;
		if (mCurrentElement.equalsIgnoreCase("CLASSNAME")) mClassName += s;
		if (mCurrentElement.equalsIgnoreCase("FIELDNAME")) mFieldname += s;
		if (mCurrentElement.equalsIgnoreCase("XMLNAME")) mXMLName += s;
		if (mCurrentElement.equalsIgnoreCase("TYPE")) mType += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("FIELDNAME".equalsIgnoreCase(qName))
		{
			mFieldnames.addElement(mFieldname);
			mFieldname="";
		}
		if ("XMLNAME".equalsIgnoreCase(qName))
		{
			mXMLNames.addElement(mXMLName);
			mXMLName="";
		}
		if ("TYPE".equalsIgnoreCase(qName))
		{
			mTypes.addElement(mType);
			mType="";
		}
		if ("XMLClassBuilderData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mCurrentData.mPackageName = mPackageName;
				mPackageName = "";
				mCurrentData.mClassName = mClassName;
				mClassName = "";
				mFieldname = "";
				mCurrentData.mFieldname = mFieldnames;
				mXMLName = "";
				mCurrentData.mXMLName = mXMLNames;
				mType = "";
				mCurrentData.mType = mTypes;
				mXMLClassBuilderData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
