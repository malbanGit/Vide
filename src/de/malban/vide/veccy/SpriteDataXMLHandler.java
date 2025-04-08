package de.malban.vide.veccy;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  SpriteDataXMLHandler extends DefaultHandler
{
	private HashMap<String, SpriteData> mSpriteData;
	private SpriteData mCurrentData = null;
	private String mCurrentElement = null;
	private String mActionID = "";
	private Vector<String> mActionIDs = null;
	private String mDefaultActionID = "";
	private String mspriteUID = "";
	public HashMap<String, SpriteData> getLastHashMap()
	{
		return mSpriteData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new SpriteData();
		mSpriteData = new HashMap<String, SpriteData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("SpriteData"))
		{
			mCurrentData = new SpriteData();
			mActionID = "";
			mActionIDs = new Vector<String>();
			mDefaultActionID = "";
			mspriteUID = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("ActionID")) mActionID += s;
		if (mCurrentElement.equalsIgnoreCase("DefaultActionID")) mDefaultActionID += s;
		if (mCurrentElement.equalsIgnoreCase("spriteUID")) mspriteUID += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("ActionID".equalsIgnoreCase(qName))
		{
			mActionIDs.addElement(mActionID);
			mActionID="";
		}
		if ("SpriteData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mActionID = "";
				mCurrentData.mActionID = mActionIDs;
				mCurrentData.mDefaultActionID = mDefaultActionID;
				mDefaultActionID = "";
				try{
				mCurrentData.mspriteUID = Integer.parseInt(mspriteUID);
				}catch (Throwable e){}
				mspriteUID = "";
				mSpriteData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
