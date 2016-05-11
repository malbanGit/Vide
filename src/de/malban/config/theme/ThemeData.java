package de.malban.config.theme;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  ThemeData
{
	protected String mClass="";
	public String mName="";
	protected boolean mResizeTitleImage=false;
	protected boolean mResizeGameImage=false;
	protected String mGameImage="";
	public boolean getResizeTitleImage()
	{
		return mResizeTitleImage;
	}
	public void setResizeTitleImage(boolean ResizeTitleImage)
	{
		mResizeTitleImage=ResizeTitleImage;
	}
	public boolean getResizeGameImage()
	{
		return mResizeGameImage;
	}
	public void setResizeGameImage(boolean ResizeGameImage)
	{
		mResizeGameImage=ResizeGameImage;
	}
	public String getGameImage()
	{
		return mGameImage;
	}
	public void setGameImage(String GameImage)
	{
		mGameImage=GameImage;
	}
	private String exportXML()
	{
		String s = new String();
		s += "\t<ThemeData>\n";
		s += "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n";
		s += "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n";
		s += "\t\t<ResizeTitleImage>"+mResizeTitleImage+"</ResizeTitleImage>\n";
		s += "\t\t<ResizeGameImage>"+mResizeGameImage+"</ResizeGameImage>\n";
		s += "\t\t<GameImage>"+UtilityString.toXML(mGameImage)+"</GameImage>\n";
		s += "\t</ThemeData>\n";
		return s;
	}
	@Override public String toString()
	{
		return mName;
	}
	private static ThemeDataXMLHandler XMLHANDLER = new ThemeDataXMLHandler();
	public static ThemeDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<ThemeData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(de.malban.Global.mBaseDir+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllThemeData>\n");
			Iterator<ThemeData> iter = col.iterator();
			while (iter.hasNext())
			{
				ThemeData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllThemeData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, ThemeData> getHashMapFromXML(String filename)
	{
		HashMap<String, ThemeData> filters = new HashMap<String, ThemeData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			ThemeDataXMLHandler h = ThemeData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"ThemeData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
