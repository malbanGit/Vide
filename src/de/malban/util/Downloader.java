package de.malban.util;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  Downloader
{
	protected String mClass="";
	public String mName="";
	protected String mURL="";
	protected boolean misZip=false;
	protected Vector<String> mFileInZip=new Vector<String>();
	protected Vector<String> mFileUnpacked=new Vector<String>();
	protected boolean mUnpackAll=false;
	protected String mDestinationDirAll="";
	public String getName()
	{
		return mName;
	}
	public void setName(String n)
	{
		mName=n;
	}
	public String getCClass()
	{
		return mClass;
	}
	public void setCClass(String c)
	{
		mClass=c;
	}
	public String getURL()
	{
		return mURL;
	}
	public void setURL(String URL)
	{
		mURL=URL;
	}
	public boolean getisZip()
	{
		return misZip;
	}
	public void setisZip(boolean isZip)
	{
		misZip=isZip;
	}
	public Vector<String> getFileInZip()
	{
		return mFileInZip;
	}
	public void setFileInZip(Vector<String> FileInZip)
	{
		mFileInZip=FileInZip;
	}
	public Vector<String> getFileUnpacked()
	{
		return mFileUnpacked;
	}
	public void setFileUnpacked(Vector<String> FileUnpacked)
	{
		mFileUnpacked=FileUnpacked;
	}
	public boolean getUnpackAll()
	{
		return mUnpackAll;
	}
	public void setUnpackAll(boolean UnpackAll)
	{
		mUnpackAll=UnpackAll;
	}
	public String getDestinationDirAll()
	{
		return mDestinationDirAll;
	}
	public void setDestinationDirAll(String DestinationDirAll)
	{
		mDestinationDirAll=DestinationDirAll;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<Downloader>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<URL>"+UtilityString.toXML(mURL)+"</URL>\n");
		s.append( "\t\t<isZip>"+misZip+"</isZip>\n");
		s.append( "\t\t<FileInZips>\n");
		for (int i=0;i<mFileInZip.size(); i++)
		{
			s.append( "\t\t\t<FileInZip>"+UtilityString.toXML(mFileInZip.elementAt(i))+"</FileInZip>\n");
		}
		s.append( "\t\t</FileInZips>\n");
		s.append( "\t\t<FileUnpackeds>\n");
		for (int i=0;i<mFileUnpacked.size(); i++)
		{
			s.append( "\t\t\t<FileUnpacked>"+UtilityString.toXML(mFileUnpacked.elementAt(i))+"</FileUnpacked>\n");
		}
		s.append( "\t\t</FileUnpackeds>\n");
		s.append( "\t\t<UnpackAll>"+mUnpackAll+"</UnpackAll>\n");
		s.append( "\t\t<DestinationDirAll>"+UtilityString.toXML(mDestinationDirAll)+"</DestinationDirAll>\n");
		s.append( "\t</Downloader>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static DownloaderXMLHandler XMLHANDLER = new DownloaderXMLHandler();
	public static DownloaderXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<Downloader> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<Downloader> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllDownloader>\n");
			Iterator<Downloader> iter = col.iterator();
			while (iter.hasNext())
			{
				Downloader item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllDownloader>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, Downloader> getHashMapFromXML(String filename)
	{
		HashMap<String, Downloader> filters = new HashMap<String, Downloader>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			DownloaderXMLHandler h = Downloader.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"Downloader Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
