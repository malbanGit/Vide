package de.malban.vide.veccy;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  LevelData
{
	protected String mClass="";
	public String mName="";
	protected int mLevelOrder=0;
	protected boolean mUseSmartList=false;
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
	public int getLevelOrder()
	{
		return mLevelOrder;
	}
	public void setLevelOrder(int LevelOrder)
	{
		mLevelOrder=LevelOrder;
	}
	public boolean getUseSmartList()
	{
		return mUseSmartList;
	}
	public void setUseSmartList(boolean UseSmartList)
	{
		mUseSmartList=UseSmartList;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<LevelData>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<LevelOrder>"+mLevelOrder+"</LevelOrder>\n");
		s.append( "\t\t<UseSmartList>"+mUseSmartList+"</UseSmartList>\n");
		s.append( "\t</LevelData>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static LevelDataXMLHandler XMLHANDLER = new LevelDataXMLHandler();
	public static LevelDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<LevelData> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<LevelData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllLevelData>\n");
			Iterator<LevelData> iter = col.iterator();
			while (iter.hasNext())
			{
				LevelData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllLevelData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, LevelData> getHashMapFromXML(String filename)
	{
		HashMap<String, LevelData> filters = new HashMap<String, LevelData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			LevelDataXMLHandler h = LevelData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"LevelData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
