package de.malban.vide.veccy;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  BackGroundScene
{
	protected String mClass="";
	public String mName="";
	protected String msceneFile="";
	protected int myPos=0;
	protected int mxPos=0;
	protected int mscale=0;
	protected int mintensity=0;
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
	public String getsceneFile()
	{
		return msceneFile;
	}
	public void setsceneFile(String sceneFile)
	{
		msceneFile=sceneFile;
	}
	public int getyPos()
	{
		return myPos;
	}
	public void setyPos(int yPos)
	{
		myPos=yPos;
	}
	public int getxPos()
	{
		return mxPos;
	}
	public void setxPos(int xPos)
	{
		mxPos=xPos;
	}
	public int getscale()
	{
		return mscale;
	}
	public void setscale(int scale)
	{
		mscale=scale;
	}
	public int getintensity()
	{
		return mintensity;
	}
	public void setintensity(int intensity)
	{
		mintensity=intensity;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<BackGroundScene>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<sceneFile>"+UtilityString.toXML(msceneFile)+"</sceneFile>\n");
		s.append( "\t\t<yPos>"+myPos+"</yPos>\n");
		s.append( "\t\t<xPos>"+mxPos+"</xPos>\n");
		s.append( "\t\t<scale>"+mscale+"</scale>\n");
		s.append( "\t\t<intensity>"+mintensity+"</intensity>\n");
		s.append( "\t</BackGroundScene>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static BackGroundSceneXMLHandler XMLHANDLER = new BackGroundSceneXMLHandler();
	public static BackGroundSceneXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<BackGroundScene> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<BackGroundScene> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllBackGroundScene>\n");
			Iterator<BackGroundScene> iter = col.iterator();
			while (iter.hasNext())
			{
				BackGroundScene item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllBackGroundScene>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, BackGroundScene> getHashMapFromXML(String filename)
	{
		HashMap<String, BackGroundScene> filters = new HashMap<String, BackGroundScene>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			BackGroundSceneXMLHandler h = BackGroundScene.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"BackGroundScene Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
