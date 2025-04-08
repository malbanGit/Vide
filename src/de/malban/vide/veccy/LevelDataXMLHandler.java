package de.malban.vide.veccy;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  LevelDataXMLHandler extends DefaultHandler
{
	private HashMap<String, LevelData> mLevelData;
	private LevelData mCurrentData = null;
	private String mCurrentElement = null;
	private String mLevelOrder = "";
	private String mUseSmartList = "";
	public HashMap<String, LevelData> getLastHashMap()
	{
		return mLevelData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new LevelData();
		mLevelData = new HashMap<String, LevelData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("LevelData"))
		{
			mCurrentData = new LevelData();
			mLevelOrder = "";
			mUseSmartList = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("LevelOrder")) mLevelOrder += s;
		if (mCurrentElement.equalsIgnoreCase("UseSmartList")) mUseSmartList += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("LevelData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				try{
				mCurrentData.mLevelOrder = Integer.parseInt(mLevelOrder);
				}catch (Throwable e){}
				mLevelOrder = "";
				try{
				mCurrentData.mUseSmartList = Boolean.parseBoolean(mUseSmartList);
				}catch (Throwable e){}
				mUseSmartList = "";
				mLevelData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
