package de.malban.vide.vecx.cartridge;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  SystemRomXMLHandler extends DefaultHandler
{
	private HashMap<String, SystemRom> mSystemRom;
	private SystemRom mCurrentData = null;
	private String mCurrentElement = null;
	private String mCartName = "";
	private String mVersion = "";
	private String mComment = "";
	public HashMap<String, SystemRom> getLastHashMap()
	{
		return mSystemRom;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new SystemRom();
		mSystemRom = new HashMap<String, SystemRom>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("SystemRom"))
		{
			mCurrentData = new SystemRom();
			mCartName = "";
			mVersion = "";
			mComment = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("CartName")) mCartName += s;
		if (mCurrentElement.equalsIgnoreCase("Version")) mVersion += s;
		if (mCurrentElement.equalsIgnoreCase("Comment")) mComment += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("SystemRom".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mCurrentData.mCartName = mCartName;
				mCartName = "";
				mCurrentData.mVersion = mVersion;
				mVersion = "";
				mCurrentData.mComment = mComment;
				mComment = "";
				mSystemRom.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
