package de.malban.vide.veccy;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  GameDataXMLHandler extends DefaultHandler
{
	private HashMap<String, GameData> mGameData;
	private GameData mCurrentData = null;
	private String mCurrentElement = null;
	private String mLevel = "";
	private Vector<String> mLevels = null;
	public HashMap<String, GameData> getLastHashMap()
	{
		return mGameData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new GameData();
		mGameData = new HashMap<String, GameData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("GameData"))
		{
			mCurrentData = new GameData();
			mLevel = "";
			mLevels = new Vector<String>();
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("Level")) mLevel += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("Level".equalsIgnoreCase(qName))
		{
			mLevels.addElement(mLevel);
			mLevel="";
		}
		if ("GameData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mLevel = "";
				mCurrentData.mLevel = mLevels;
				mGameData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
