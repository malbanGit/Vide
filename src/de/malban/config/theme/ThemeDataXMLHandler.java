package de.malban.config.theme;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  ThemeDataXMLHandler extends DefaultHandler
{
	private HashMap<String, ThemeData> mThemeData;
	private ThemeData mCurrentData = null;
	private String mCurrentElement = null;
	private String mResizeTitleImage = "";
	private String mResizeGameImage = "";
	private String mGameImage = "";
	public HashMap<String, ThemeData> getLastHashMap()
	{
		return mThemeData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new ThemeData();
		mThemeData = new HashMap<String, ThemeData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("ThemeData"))
		{
			mCurrentData = new ThemeData();
			mResizeTitleImage = "";
			mResizeGameImage = "";
			mGameImage = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("ResizeTitleImage")) mResizeTitleImage += s;
		if (mCurrentElement.equalsIgnoreCase("ResizeGameImage")) mResizeGameImage += s;
		if (mCurrentElement.equalsIgnoreCase("GameImage")) mGameImage += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("ThemeData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				try{
				mCurrentData.mResizeTitleImage = Boolean.parseBoolean(mResizeTitleImage);
				}catch (Throwable e){}
				mResizeTitleImage = "";
				try{
				mCurrentData.mResizeGameImage = Boolean.parseBoolean(mResizeGameImage);
				}catch (Throwable e){}
				mResizeGameImage = "";
				mCurrentData.mGameImage = mGameImage;
				mGameImage = "";
				mThemeData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
