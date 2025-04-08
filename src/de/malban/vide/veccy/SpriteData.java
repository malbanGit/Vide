package de.malban.vide.veccy;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  SpriteData
{
	protected String mClass="";
	public String mName="";
	protected Vector<String> mActionID=new Vector<String>();
	protected String mDefaultActionID="";
	protected int mspriteUID=0;
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
	public Vector<String> getActionID()
	{
		return mActionID;
	}
	public void setActionID(Vector<String> ActionID)
	{
		mActionID=ActionID;
	}
	public String getDefaultActionID()
	{
		return mDefaultActionID;
	}
	public void setDefaultActionID(String DefaultActionID)
	{
		mDefaultActionID=DefaultActionID;
	}
	public int getspriteUID()
	{
		return mspriteUID;
	}
	public void setspriteUID(int spriteUID)
	{
		mspriteUID=spriteUID;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<SpriteData>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<ActionIDs>\n");
		for (int i=0;i<mActionID.size(); i++)
		{
			s.append( "\t\t\t<ActionID>"+UtilityString.toXML(mActionID.elementAt(i))+"</ActionID>\n");
		}
		s.append( "\t\t</ActionIDs>\n");
		s.append( "\t\t<DefaultActionID>"+UtilityString.toXML(mDefaultActionID)+"</DefaultActionID>\n");
		s.append( "\t\t<spriteUID>"+mspriteUID+"</spriteUID>\n");
		s.append( "\t</SpriteData>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static SpriteDataXMLHandler XMLHANDLER = new SpriteDataXMLHandler();
	public static SpriteDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<SpriteData> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<SpriteData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllSpriteData>\n");
			Iterator<SpriteData> iter = col.iterator();
			while (iter.hasNext())
			{
				SpriteData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllSpriteData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, SpriteData> getHashMapFromXML(String filename)
	{
		HashMap<String, SpriteData> filters = new HashMap<String, SpriteData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			SpriteDataXMLHandler h = SpriteData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"SpriteData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
