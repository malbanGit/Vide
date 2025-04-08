package de.malban.vide.veccy;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  LevelObjectDataXMLHandler extends DefaultHandler
{
	private HashMap<String, LevelObjectData> mLevelObjectData;
	private LevelObjectData mCurrentData = null;
	private String mCurrentElement = null;
	private String mType = "";
	private String mSpriteID = "";
	private String mxPos = "";
	private String myPos = "";
	private String mScene = "";
	private String mMaxLiveObjects = "";
	private String mLiveOnInit = "";
	public HashMap<String, LevelObjectData> getLastHashMap()
	{
		return mLevelObjectData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new LevelObjectData();
		mLevelObjectData = new HashMap<String, LevelObjectData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("LevelObjectData"))
		{
			mCurrentData = new LevelObjectData();
			mType = "";
			mSpriteID = "";
			mxPos = "";
			myPos = "";
			mScene = "";
			mMaxLiveObjects = "";
			mLiveOnInit = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("Type")) mType += s;
		if (mCurrentElement.equalsIgnoreCase("SpriteID")) mSpriteID += s;
		if (mCurrentElement.equalsIgnoreCase("xPos")) mxPos += s;
		if (mCurrentElement.equalsIgnoreCase("yPos")) myPos += s;
		if (mCurrentElement.equalsIgnoreCase("Scene")) mScene += s;
		if (mCurrentElement.equalsIgnoreCase("MaxLiveObjects")) mMaxLiveObjects += s;
		if (mCurrentElement.equalsIgnoreCase("LiveOnInit")) mLiveOnInit += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("LevelObjectData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mCurrentData.mType = mType;
				mType = "";
				mCurrentData.mSpriteID = mSpriteID;
				mSpriteID = "";
				mCurrentData.mxPos = mxPos;
				mxPos = "";
				mCurrentData.myPos = myPos;
				myPos = "";
				mCurrentData.mScene = mScene;
				mScene = "";
				try{
				mCurrentData.mMaxLiveObjects = Integer.parseInt(mMaxLiveObjects);
				}catch (Throwable e){}
				mMaxLiveObjects = "";
				try{
				mCurrentData.mLiveOnInit = Boolean.parseBoolean(mLiveOnInit);
				}catch (Throwable e){}
				mLiveOnInit = "";
				mLevelObjectData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
