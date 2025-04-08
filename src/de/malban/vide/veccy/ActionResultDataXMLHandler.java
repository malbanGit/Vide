package de.malban.vide.veccy;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  ActionResultDataXMLHandler extends DefaultHandler
{
	private HashMap<String, ActionResultData> mActionResultData;
	private ActionResultData mCurrentData = null;
	private String mCurrentElement = null;
	private String mresultType = "";
	private Vector<String> mresultTypes = null;
	private String mresultActionID = "";
	private Vector<String> mresultActionIDs = null;
	private String mresultSpriteID = "";
	private Vector<String> mresultSpriteIDs = null;
	private String mresultY = "";
	private Vector<String> mresultYs = null;
	private String mresultX = "";
	private Vector<String> mresultXs = null;
	public HashMap<String, ActionResultData> getLastHashMap()
	{
		return mActionResultData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new ActionResultData();
		mActionResultData = new HashMap<String, ActionResultData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("ActionResultData"))
		{
			mCurrentData = new ActionResultData();
			mresultType = "";
			mresultTypes = new Vector<String>();
			mresultActionID = "";
			mresultActionIDs = new Vector<String>();
			mresultSpriteID = "";
			mresultSpriteIDs = new Vector<String>();
			mresultY = "";
			mresultYs = new Vector<String>();
			mresultX = "";
			mresultXs = new Vector<String>();
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("resultType")) mresultType += s;
		if (mCurrentElement.equalsIgnoreCase("resultActionID")) mresultActionID += s;
		if (mCurrentElement.equalsIgnoreCase("resultSpriteID")) mresultSpriteID += s;
		if (mCurrentElement.equalsIgnoreCase("resultY")) mresultY += s;
		if (mCurrentElement.equalsIgnoreCase("resultX")) mresultX += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("resultType".equalsIgnoreCase(qName))
		{
			mresultTypes.addElement(mresultType);
			mresultType="";
		}
		if ("resultActionID".equalsIgnoreCase(qName))
		{
			mresultActionIDs.addElement(mresultActionID);
			mresultActionID="";
		}
		if ("resultSpriteID".equalsIgnoreCase(qName))
		{
			mresultSpriteIDs.addElement(mresultSpriteID);
			mresultSpriteID="";
		}
		if ("resultY".equalsIgnoreCase(qName))
		{
			mresultYs.addElement(mresultY);
			mresultY="";
		}
		if ("resultX".equalsIgnoreCase(qName))
		{
			mresultXs.addElement(mresultX);
			mresultX="";
		}
		if ("ActionResultData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mresultType = "";
				mCurrentData.mresultType = mresultTypes;
				mresultActionID = "";
				mCurrentData.mresultActionID = mresultActionIDs;
				mresultSpriteID = "";
				mCurrentData.mresultSpriteID = mresultSpriteIDs;
				mresultY = "";
				mCurrentData.mresultY = mresultYs;
				mresultX = "";
				mCurrentData.mresultX = mresultXs;
				mActionResultData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
