package de.malban.vide.veccy;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  ActionTriggerData
{
	protected String mClass="";
	public String mName="";
	protected Vector<String> mtriggerByCause=new Vector<String>();
	protected Vector<Integer> mtriggerByY=new Vector<Integer>();
	protected Vector<Integer> mtriggerByX=new Vector<Integer>();
	protected Vector<String> mtriggerByTicks=new Vector<String>();
	protected Vector<String> mtriggerBySpriteID=new Vector<String>();
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
	public Vector<String> gettriggerByCause()
	{
		return mtriggerByCause;
	}
	public void settriggerByCause(Vector<String> triggerByCause)
	{
		mtriggerByCause=triggerByCause;
	}
	public Vector<Integer> gettriggerByY()
	{
		return mtriggerByY;
	}
	public void settriggerByY(Vector<Integer> triggerByY)
	{
		mtriggerByY=triggerByY;
	}
	public Vector<Integer> gettriggerByX()
	{
		return mtriggerByX;
	}
	public void settriggerByX(Vector<Integer> triggerByX)
	{
		mtriggerByX=triggerByX;
	}
	public Vector<String> gettriggerByTicks()
	{
		return mtriggerByTicks;
	}
	public void settriggerByTicks(Vector<String> triggerByTicks)
	{
		mtriggerByTicks=triggerByTicks;
	}
	public Vector<String> gettriggerBySpriteID()
	{
		return mtriggerBySpriteID;
	}
	public void settriggerBySpriteID(Vector<String> triggerBySpriteID)
	{
		mtriggerBySpriteID=triggerBySpriteID;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<ActionTriggerData>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<triggerByCauses>\n");
		for (int i=0;i<mtriggerByCause.size(); i++)
		{
			s.append( "\t\t\t<triggerByCause>"+UtilityString.toXML(mtriggerByCause.elementAt(i))+"</triggerByCause>\n");
		}
		s.append( "\t\t</triggerByCauses>\n");
		s.append( "\t\t<triggerByYs>\n");
		for (int i=0;i<mtriggerByY.size(); i++)
		{
			s.append( "\t\t\t<triggerByY>"+mtriggerByY.elementAt(i)+"</triggerByY>\n");
		}
		s.append( "\t\t</triggerByYs>\n");
		s.append( "\t\t<triggerByXs>\n");
		for (int i=0;i<mtriggerByX.size(); i++)
		{
			s.append( "\t\t\t<triggerByX>"+mtriggerByX.elementAt(i)+"</triggerByX>\n");
		}
		s.append( "\t\t</triggerByXs>\n");
		s.append( "\t\t<triggerByTickss>\n");
		for (int i=0;i<mtriggerByTicks.size(); i++)
		{
			s.append( "\t\t\t<triggerByTicks>"+UtilityString.toXML(mtriggerByTicks.elementAt(i))+"</triggerByTicks>\n");
		}
		s.append( "\t\t</triggerByTickss>\n");
		s.append( "\t\t<triggerBySpriteIDs>\n");
		for (int i=0;i<mtriggerBySpriteID.size(); i++)
		{
			s.append( "\t\t\t<triggerBySpriteID>"+UtilityString.toXML(mtriggerBySpriteID.elementAt(i))+"</triggerBySpriteID>\n");
		}
		s.append( "\t\t</triggerBySpriteIDs>\n");
		s.append( "\t</ActionTriggerData>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static ActionTriggerDataXMLHandler XMLHANDLER = new ActionTriggerDataXMLHandler();
	public static ActionTriggerDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<ActionTriggerData> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<ActionTriggerData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllActionTriggerData>\n");
			Iterator<ActionTriggerData> iter = col.iterator();
			while (iter.hasNext())
			{
				ActionTriggerData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllActionTriggerData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, ActionTriggerData> getHashMapFromXML(String filename)
	{
		HashMap<String, ActionTriggerData> filters = new HashMap<String, ActionTriggerData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			ActionTriggerDataXMLHandler h = ActionTriggerData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"ActionTriggerData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
