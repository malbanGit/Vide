package de.malban.vide.veccy;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  LevelObjectData
{
	protected String mClass="";
	public String mName="";
	protected String mType="";
	protected String mSpriteID="";
	protected String mxPos="";
	protected String myPos="";
	protected String mScene="";
	protected int mMaxLiveObjects=0;
	protected boolean mLiveOnInit=false;
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
	public String getType()
	{
		return mType;
	}
	public void setType(String Type)
	{
		mType=Type;
	}
	public String getSpriteID()
	{
		return mSpriteID;
	}
	public void setSpriteID(String SpriteID)
	{
		mSpriteID=SpriteID;
	}
	public String getxPos()
	{
		return mxPos;
	}
	public void setxPos(String xPos)
	{
		mxPos=xPos;
	}
	public String getyPos()
	{
		return myPos;
	}
	public void setyPos(String yPos)
	{
		myPos=yPos;
	}
	public String getScene()
	{
		return mScene;
	}
	public void setScene(String Scene)
	{
		mScene=Scene;
	}
	public int getMaxLiveObjects()
	{
		return mMaxLiveObjects;
	}
	public void setMaxLiveObjects(int MaxLiveObjects)
	{
		mMaxLiveObjects=MaxLiveObjects;
	}
	public boolean getLiveOnInit()
	{
		return mLiveOnInit;
	}
	public void setLiveOnInit(boolean LiveOnInit)
	{
		mLiveOnInit=LiveOnInit;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<LevelObjectData>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<Type>"+UtilityString.toXML(mType)+"</Type>\n");
		s.append( "\t\t<SpriteID>"+UtilityString.toXML(mSpriteID)+"</SpriteID>\n");
		s.append( "\t\t<xPos>"+UtilityString.toXML(mxPos)+"</xPos>\n");
		s.append( "\t\t<yPos>"+UtilityString.toXML(myPos)+"</yPos>\n");
		s.append( "\t\t<Scene>"+UtilityString.toXML(mScene)+"</Scene>\n");
		s.append( "\t\t<MaxLiveObjects>"+mMaxLiveObjects+"</MaxLiveObjects>\n");
		s.append( "\t\t<LiveOnInit>"+mLiveOnInit+"</LiveOnInit>\n");
		s.append( "\t</LevelObjectData>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static LevelObjectDataXMLHandler XMLHANDLER = new LevelObjectDataXMLHandler();
	public static LevelObjectDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<LevelObjectData> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<LevelObjectData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllLevelObjectData>\n");
			Iterator<LevelObjectData> iter = col.iterator();
			while (iter.hasNext())
			{
				LevelObjectData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllLevelObjectData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, LevelObjectData> getHashMapFromXML(String filename)
	{
		HashMap<String, LevelObjectData> filters = new HashMap<String, LevelObjectData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			LevelObjectDataXMLHandler h = LevelObjectData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"LevelObjectData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
