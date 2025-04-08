package de.malban.vide.veccy;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  ActionResultData
{
	protected String mClass="";
	public String mName="";
	protected Vector<String> mresultType=new Vector<String>();
	protected Vector<String> mresultActionID=new Vector<String>();
	protected Vector<String> mresultSpriteID=new Vector<String>();
	protected Vector<String> mresultY=new Vector<String>();
	protected Vector<String> mresultX=new Vector<String>();
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
	public Vector<String> getresultType()
	{
		return mresultType;
	}
	public void setresultType(Vector<String> resultType)
	{
		mresultType=resultType;
	}
	public Vector<String> getresultActionID()
	{
		return mresultActionID;
	}
	public void setresultActionID(Vector<String> resultActionID)
	{
		mresultActionID=resultActionID;
	}
	public Vector<String> getresultSpriteID()
	{
		return mresultSpriteID;
	}
	public void setresultSpriteID(Vector<String> resultSpriteID)
	{
		mresultSpriteID=resultSpriteID;
	}
	public Vector<String> getresultY()
	{
		return mresultY;
	}
	public void setresultY(Vector<String> resultY)
	{
		mresultY=resultY;
	}
	public Vector<String> getresultX()
	{
		return mresultX;
	}
	public void setresultX(Vector<String> resultX)
	{
		mresultX=resultX;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<ActionResultData>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<resultTypes>\n");
		for (int i=0;i<mresultType.size(); i++)
		{
			s.append( "\t\t\t<resultType>"+UtilityString.toXML(mresultType.elementAt(i))+"</resultType>\n");
		}
		s.append( "\t\t</resultTypes>\n");
		s.append( "\t\t<resultActionIDs>\n");
		for (int i=0;i<mresultActionID.size(); i++)
		{
			s.append( "\t\t\t<resultActionID>"+UtilityString.toXML(mresultActionID.elementAt(i))+"</resultActionID>\n");
		}
		s.append( "\t\t</resultActionIDs>\n");
		s.append( "\t\t<resultSpriteIDs>\n");
		for (int i=0;i<mresultSpriteID.size(); i++)
		{
			s.append( "\t\t\t<resultSpriteID>"+UtilityString.toXML(mresultSpriteID.elementAt(i))+"</resultSpriteID>\n");
		}
		s.append( "\t\t</resultSpriteIDs>\n");
		s.append( "\t\t<resultYs>\n");
		for (int i=0;i<mresultY.size(); i++)
		{
			s.append( "\t\t\t<resultY>"+UtilityString.toXML(mresultY.elementAt(i))+"</resultY>\n");
		}
		s.append( "\t\t</resultYs>\n");
		s.append( "\t\t<resultXs>\n");
		for (int i=0;i<mresultX.size(); i++)
		{
			s.append( "\t\t\t<resultX>"+UtilityString.toXML(mresultX.elementAt(i))+"</resultX>\n");
		}
		s.append( "\t\t</resultXs>\n");
		s.append( "\t</ActionResultData>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static ActionResultDataXMLHandler XMLHANDLER = new ActionResultDataXMLHandler();
	public static ActionResultDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<ActionResultData> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<ActionResultData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllActionResultData>\n");
			Iterator<ActionResultData> iter = col.iterator();
			while (iter.hasNext())
			{
				ActionResultData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllActionResultData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, ActionResultData> getHashMapFromXML(String filename)
	{
		HashMap<String, ActionResultData> filters = new HashMap<String, ActionResultData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			ActionResultDataXMLHandler h = ActionResultData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"ActionResultData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
