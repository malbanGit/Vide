package de.malban.config.sound;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  SoundMapXMLHandler extends DefaultHandler
{
	private HashMap<String, SoundMap> mSoundMap;
	private SoundMap mCurrentData = null;
	private String mCurrentElement = null;
	private String mSoundFile = "";
	private Vector<String> mSoundFiles = null;
	private String mColor = "";
	private Vector<String> mColors = null;
	private String mType = "";
	private Vector<String> mTypes = null;
	private String mSubtype = "";
	private Vector<String> mSubtypes = null;
	private String mID = "";
	private Vector<String> mIDs = null;
	private String mEvent = "";
	private Vector<String> mEvents = null;
	public HashMap<String, SoundMap> getLastHashMap()
	{
		return mSoundMap;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new SoundMap();
		mSoundMap = new HashMap<String, SoundMap>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("SoundMap"))
		{
			mCurrentData = new SoundMap();
			mSoundFile = "";
			mSoundFiles = new Vector<String>();
			mColor = "";
			mColors = new Vector<String>();
			mType = "";
			mTypes = new Vector<String>();
			mSubtype = "";
			mSubtypes = new Vector<String>();
			mID = "";
			mIDs = new Vector<String>();
			mEvent = "";
			mEvents = new Vector<String>();
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("SOUNDFILE")) mSoundFile += s;
		if (mCurrentElement.equalsIgnoreCase("COLOR")) mColor += s;
		if (mCurrentElement.equalsIgnoreCase("TYPE")) mType += s;
		if (mCurrentElement.equalsIgnoreCase("SUBTYPE")) mSubtype += s;
		if (mCurrentElement.equalsIgnoreCase("ID")) mID += s;
		if (mCurrentElement.equalsIgnoreCase("EVENT")) mEvent += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("SOUNDFILE".equalsIgnoreCase(qName))
		{
			mSoundFiles.addElement(mSoundFile);
			mSoundFile="";
		}
		if ("COLOR".equalsIgnoreCase(qName))
		{
			mColors.addElement(mColor);
			mColor="";
		}
		if ("TYPE".equalsIgnoreCase(qName))
		{
			mTypes.addElement(mType);
			mType="";
		}
		if ("SUBTYPE".equalsIgnoreCase(qName))
		{
			mSubtypes.addElement(mSubtype);
			mSubtype="";
		}
		if ("ID".equalsIgnoreCase(qName))
		{
			mIDs.addElement(mID);
			mID="";
		}
		if ("EVENT".equalsIgnoreCase(qName))
		{
			mEvents.addElement(mEvent);
			mEvent="";
		}
		if ("SoundMap".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mSoundFile = "";
				mCurrentData.mSoundFile = mSoundFiles;
				mColor = "";
				mCurrentData.mColor = mColors;
				mType = "";
				mCurrentData.mType = mTypes;
				mSubtype = "";
				mCurrentData.mSubtype = mSubtypes;
				mID = "";
				mCurrentData.mID = mIDs;
				mEvent = "";
				mCurrentData.mEvent = mEvents;
				mSoundMap.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
