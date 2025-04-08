package de.malban.vide.veccy;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  ActionTriggerDataXMLHandler extends DefaultHandler
{
	private HashMap<String, ActionTriggerData> mActionTriggerData;
	private ActionTriggerData mCurrentData = null;
	private String mCurrentElement = null;
	private String mtriggerByCause = "";
	private Vector<String> mtriggerByCauses = null;
	private String mtriggerByY = "";
	private Vector<Integer> mtriggerByYs = null;
	private String mtriggerByX = "";
	private Vector<Integer> mtriggerByXs = null;
	private String mtriggerByTicks = "";
	private Vector<String> mtriggerByTickss = null;
	private String mtriggerBySpriteID = "";
	private Vector<String> mtriggerBySpriteIDs = null;
	public HashMap<String, ActionTriggerData> getLastHashMap()
	{
		return mActionTriggerData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new ActionTriggerData();
		mActionTriggerData = new HashMap<String, ActionTriggerData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("ActionTriggerData"))
		{
			mCurrentData = new ActionTriggerData();
			mtriggerByCause = "";
			mtriggerByCauses = new Vector<String>();
			mtriggerByY = "";
			mtriggerByYs = new Vector<Integer>();
			mtriggerByX = "";
			mtriggerByXs = new Vector<Integer>();
			mtriggerByTicks = "";
			mtriggerByTickss = new Vector<String>();
			mtriggerBySpriteID = "";
			mtriggerBySpriteIDs = new Vector<String>();
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("triggerByCause")) mtriggerByCause += s;
		if (mCurrentElement.equalsIgnoreCase("triggerByY")) mtriggerByY += s;
		if (mCurrentElement.equalsIgnoreCase("triggerByX")) mtriggerByX += s;
		if (mCurrentElement.equalsIgnoreCase("triggerByTicks")) mtriggerByTicks += s;
		if (mCurrentElement.equalsIgnoreCase("triggerBySpriteID")) mtriggerBySpriteID += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("triggerByCause".equalsIgnoreCase(qName))
		{
			mtriggerByCauses.addElement(mtriggerByCause);
			mtriggerByCause="";
		}
		if ("triggerByY".equalsIgnoreCase(qName))
		{
			try{
			mtriggerByYs.addElement(Integer.parseInt(mtriggerByY));
			}catch (Throwable e){}
			mtriggerByY="";
		}
		if ("triggerByX".equalsIgnoreCase(qName))
		{
			try{
			mtriggerByXs.addElement(Integer.parseInt(mtriggerByX));
			}catch (Throwable e){}
			mtriggerByX="";
		}
		if ("triggerByTicks".equalsIgnoreCase(qName))
		{
			mtriggerByTickss.addElement(mtriggerByTicks);
			mtriggerByTicks="";
		}
		if ("triggerBySpriteID".equalsIgnoreCase(qName))
		{
			mtriggerBySpriteIDs.addElement(mtriggerBySpriteID);
			mtriggerBySpriteID="";
		}
		if ("ActionTriggerData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mtriggerByCause = "";
				mCurrentData.mtriggerByCause = mtriggerByCauses;
				mtriggerByY = "";
				mCurrentData.mtriggerByY = mtriggerByYs;
				mtriggerByX = "";
				mCurrentData.mtriggerByX = mtriggerByXs;
				mtriggerByTicks = "";
				mCurrentData.mtriggerByTicks = mtriggerByTickss;
				mtriggerBySpriteID = "";
				mCurrentData.mtriggerBySpriteID = mtriggerBySpriteIDs;
				mActionTriggerData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
