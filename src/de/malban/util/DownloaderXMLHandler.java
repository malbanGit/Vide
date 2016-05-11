package de.malban.util;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  DownloaderXMLHandler extends DefaultHandler
{
	private HashMap<String, Downloader> mDownloader;
	private Downloader mCurrentData = null;
	private String mCurrentElement = null;
	private String mURL = "";
	private String misZip = "";
	private String mFileInZip = "";
	private Vector<String> mFileInZips = null;
	private String mFileUnpacked = "";
	private Vector<String> mFileUnpackeds = null;
	private String mUnpackAll = "";
	private String mDestinationDirAll = "";
	public HashMap<String, Downloader> getLastHashMap()
	{
		return mDownloader;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new Downloader();
		mDownloader = new HashMap<String, Downloader>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("Downloader"))
		{
			mCurrentData = new Downloader();
			mURL = "";
			misZip = "";
			mFileInZip = "";
			mFileInZips = new Vector<String>();
			mFileUnpacked = "";
			mFileUnpackeds = new Vector<String>();
			mUnpackAll = "";
			mDestinationDirAll = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("URL")) mURL += s;
		if (mCurrentElement.equalsIgnoreCase("isZip")) misZip += s;
		if (mCurrentElement.equalsIgnoreCase("FileInZip")) mFileInZip += s;
		if (mCurrentElement.equalsIgnoreCase("FileUnpacked")) mFileUnpacked += s;
		if (mCurrentElement.equalsIgnoreCase("UnpackAll")) mUnpackAll += s;
		if (mCurrentElement.equalsIgnoreCase("DestinationDirAll")) mDestinationDirAll += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("FileInZip".equalsIgnoreCase(qName))
		{
			mFileInZips.addElement(mFileInZip);
			mFileInZip="";
		}
		if ("FileUnpacked".equalsIgnoreCase(qName))
		{
			mFileUnpackeds.addElement(mFileUnpacked);
			mFileUnpacked="";
		}
		if ("Downloader".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mCurrentData.mURL = mURL;
				mURL = "";
				try{
				mCurrentData.misZip = Boolean.parseBoolean(misZip);
				}catch (Throwable e){}
				misZip = "";
				mFileInZip = "";
				mCurrentData.mFileInZip = mFileInZips;
				mFileUnpacked = "";
				mCurrentData.mFileUnpacked = mFileUnpackeds;
				try{
				mCurrentData.mUnpackAll = Boolean.parseBoolean(mUnpackAll);
				}catch (Throwable e){}
				mUnpackAll = "";
				mCurrentData.mDestinationDirAll = mDestinationDirAll;
				mDestinationDirAll = "";
				mDownloader.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
