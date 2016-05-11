package de.malban.vide.vecx.cartridge;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  SystemRom
{
	protected String mClass="";
	public String mName="";
	protected String mCartName="";
	protected String mVersion="";
	protected String mComment="";
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
	public String getCartName()
	{
		return mCartName;
	}
	public void setCartName(String CartName)
	{
		mCartName=CartName;
	}
	public String getVersion()
	{
		return mVersion;
	}
	public void setVersion(String Version)
	{
		mVersion=Version;
	}
	public String getComment()
	{
		return mComment;
	}
	public void setComment(String Comment)
	{
		mComment=Comment;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<SystemRom>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<CartName>"+UtilityString.toXML(mCartName)+"</CartName>\n");
		s.append( "\t\t<Version>"+UtilityString.toXML(mVersion)+"</Version>\n");
		s.append( "\t\t<Comment>"+UtilityString.toXML(mComment)+"</Comment>\n");
		s.append( "\t</SystemRom>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static SystemRomXMLHandler XMLHANDLER = new SystemRomXMLHandler();
	public static SystemRomXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<SystemRom> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<SystemRom> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllSystemRom>\n");
			Iterator<SystemRom> iter = col.iterator();
			while (iter.hasNext())
			{
				SystemRom item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllSystemRom>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, SystemRom> getHashMapFromXML(String filename)
	{
		HashMap<String, SystemRom> filters = new HashMap<String, SystemRom>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			SystemRomXMLHandler h = SystemRom.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"SystemRom Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
