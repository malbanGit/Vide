package de.malban.vide.script;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  ExportDataXMLHandler extends DefaultHandler
{
	private HashMap<String, ExportData> mExportData;
	private ExportData mCurrentData = null;
	private String mCurrentElement = null;
	private String mComment = "";
	private String mScript = "";
	public HashMap<String, ExportData> getLastHashMap()
	{
		return mExportData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new ExportData();
		mExportData = new HashMap<String, ExportData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("ExportData"))
		{
			mCurrentData = new ExportData();
			mComment = "";
			mScript = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("Comment")) mComment += s;
		if (mCurrentElement.equalsIgnoreCase("Script")) mScript += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("ExportData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mCurrentData.mComment = mComment;
				mComment = "";
				mCurrentData.mScript = mScript;
				mScript = "";
				mExportData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
