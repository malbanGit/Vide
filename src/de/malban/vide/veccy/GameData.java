package de.malban.vide.veccy;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  GameData
{
	protected String mClass="";
	public String mName="";
	protected Vector<String> mLevel=new Vector<String>();
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
	public Vector<String> getLevel()
	{
		return mLevel;
	}
	public void setLevel(Vector<String> Level)
	{
		mLevel=Level;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<GameData>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<Levels>\n");
		for (int i=0;i<mLevel.size(); i++)
		{
			s.append( "\t\t\t<Level>"+UtilityString.toXML(mLevel.elementAt(i))+"</Level>\n");
		}
		s.append( "\t\t</Levels>\n");
		s.append( "\t</GameData>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static GameDataXMLHandler XMLHANDLER = new GameDataXMLHandler();
	public static GameDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<GameData> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<GameData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllGameData>\n");
			Iterator<GameData> iter = col.iterator();
			while (iter.hasNext())
			{
				GameData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllGameData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, GameData> getHashMapFromXML(String filename)
	{
		HashMap<String, GameData> filters = new HashMap<String, GameData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			GameDataXMLHandler h = GameData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"GameData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
