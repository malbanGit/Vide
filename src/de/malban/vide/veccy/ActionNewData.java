package de.malban.vide.veccy;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  ActionNewData
{
	protected String mClass="";
	public String mName="";
	protected String manimationFile="";
	protected String mchangeWhileActiveX="";
	protected String mchangeWhileActiveY="";
	protected boolean msoundLoop=false;
	protected String msoundFile="";
	protected String mbehaviour="";
	protected Vector<Integer> mpositioning=new Vector<Integer>();
	protected Vector<String> mtriggerName=new Vector<String>();
	protected Vector<String> mresultName=new Vector<String>();
	protected String mboundingBoxOffsetX="";
	protected Vector<Integer> mdeltaPerStepX=new Vector<Integer>();
	protected Vector<Integer> mdeltaPerStepY=new Vector<Integer>();
	protected String mtext="";
	protected String mtextType="";
	protected int mtextHeight=0;
	protected int mtextWidth=0;
	protected boolean misEnemy=false;
	protected String mboundingBoxOffsetY="";
	protected boolean misPlayerShot=false;
	protected boolean misEnemyShot=false;
	protected String mintensity="";
	protected Vector<String> meventName=new Vector<String>();
	protected Vector<String> meventUID=new Vector<String>();
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
	public String getanimationFile()
	{
		return manimationFile;
	}
	public void setanimationFile(String animationFile)
	{
		manimationFile=animationFile;
	}
	public String getchangeWhileActiveX()
	{
		return mchangeWhileActiveX;
	}
	public void setchangeWhileActiveX(String changeWhileActiveX)
	{
		mchangeWhileActiveX=changeWhileActiveX;
	}
	public String getchangeWhileActiveY()
	{
		return mchangeWhileActiveY;
	}
	public void setchangeWhileActiveY(String changeWhileActiveY)
	{
		mchangeWhileActiveY=changeWhileActiveY;
	}
	public boolean getsoundLoop()
	{
		return msoundLoop;
	}
	public void setsoundLoop(boolean soundLoop)
	{
		msoundLoop=soundLoop;
	}
	public String getsoundFile()
	{
		return msoundFile;
	}
	public void setsoundFile(String soundFile)
	{
		msoundFile=soundFile;
	}
	public String getbehaviour()
	{
		return mbehaviour;
	}
	public void setbehaviour(String behaviour)
	{
		mbehaviour=behaviour;
	}
	public Vector<Integer> getpositioning()
	{
		return mpositioning;
	}
	public void setpositioning(Vector<Integer> positioning)
	{
		mpositioning=positioning;
	}
	public Vector<String> gettriggerName()
	{
		return mtriggerName;
	}
	public void settriggerName(Vector<String> triggerName)
	{
		mtriggerName=triggerName;
	}
	public Vector<String> getresultName()
	{
		return mresultName;
	}
	public void setresultName(Vector<String> resultName)
	{
		mresultName=resultName;
	}
	public String getboundingBoxOffsetX()
	{
		return mboundingBoxOffsetX;
	}
	public void setboundingBoxOffsetX(String boundingBoxOffsetX)
	{
		mboundingBoxOffsetX=boundingBoxOffsetX;
	}
	public Vector<Integer> getdeltaPerStepX()
	{
		return mdeltaPerStepX;
	}
	public void setdeltaPerStepX(Vector<Integer> deltaPerStepX)
	{
		mdeltaPerStepX=deltaPerStepX;
	}
	public Vector<Integer> getdeltaPerStepY()
	{
		return mdeltaPerStepY;
	}
	public void setdeltaPerStepY(Vector<Integer> deltaPerStepY)
	{
		mdeltaPerStepY=deltaPerStepY;
	}
	public String gettext()
	{
		return mtext;
	}
	public void settext(String text)
	{
		mtext=text;
	}
	public String gettextType()
	{
		return mtextType;
	}
	public void settextType(String textType)
	{
		mtextType=textType;
	}
	public int gettextHeight()
	{
		return mtextHeight;
	}
	public void settextHeight(int textHeight)
	{
		mtextHeight=textHeight;
	}
	public int gettextWidth()
	{
		return mtextWidth;
	}
	public void settextWidth(int textWidth)
	{
		mtextWidth=textWidth;
	}
	public boolean getisEnemy()
	{
		return misEnemy;
	}
	public void setisEnemy(boolean isEnemy)
	{
		misEnemy=isEnemy;
	}
	public String getboundingBoxOffsetY()
	{
		return mboundingBoxOffsetY;
	}
	public void setboundingBoxOffsetY(String boundingBoxOffsetY)
	{
		mboundingBoxOffsetY=boundingBoxOffsetY;
	}
	public boolean getisPlayerShot()
	{
		return misPlayerShot;
	}
	public void setisPlayerShot(boolean isPlayerShot)
	{
		misPlayerShot=isPlayerShot;
	}
	public boolean getisEnemyShot()
	{
		return misEnemyShot;
	}
	public void setisEnemyShot(boolean isEnemyShot)
	{
		misEnemyShot=isEnemyShot;
	}
	public String getintensity()
	{
		return mintensity;
	}
	public void setintensity(String intensity)
	{
		mintensity=intensity;
	}
	public Vector<String> geteventName()
	{
		return meventName;
	}
	public void seteventName(Vector<String> eventName)
	{
		meventName=eventName;
	}
	public Vector<String> geteventUID()
	{
		return meventUID;
	}
	public void seteventUID(Vector<String> eventUID)
	{
		meventUID=eventUID;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<ActionNewData>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<animationFile>"+UtilityString.toXML(manimationFile)+"</animationFile>\n");
		s.append( "\t\t<changeWhileActiveX>"+UtilityString.toXML(mchangeWhileActiveX)+"</changeWhileActiveX>\n");
		s.append( "\t\t<changeWhileActiveY>"+UtilityString.toXML(mchangeWhileActiveY)+"</changeWhileActiveY>\n");
		s.append( "\t\t<soundLoop>"+msoundLoop+"</soundLoop>\n");
		s.append( "\t\t<soundFile>"+UtilityString.toXML(msoundFile)+"</soundFile>\n");
		s.append( "\t\t<Behaviour>"+UtilityString.toXML(mbehaviour)+"</Behaviour>\n");
		s.append( "\t\t<Positionings>\n");
		for (int i=0;i<mpositioning.size(); i++)
		{
			s.append( "\t\t\t<Positioning>"+mpositioning.elementAt(i)+"</Positioning>\n");
		}
		s.append( "\t\t</Positionings>\n");
		s.append( "\t\t<triggerNames>\n");
		for (int i=0;i<mtriggerName.size(); i++)
		{
			s.append( "\t\t\t<triggerName>"+UtilityString.toXML(mtriggerName.elementAt(i))+"</triggerName>\n");
		}
		s.append( "\t\t</triggerNames>\n");
		s.append( "\t\t<resultNames>\n");
		for (int i=0;i<mresultName.size(); i++)
		{
			s.append( "\t\t\t<resultName>"+UtilityString.toXML(mresultName.elementAt(i))+"</resultName>\n");
		}
		s.append( "\t\t</resultNames>\n");
		s.append( "\t\t<boundingBoxOffsetX>"+UtilityString.toXML(mboundingBoxOffsetX)+"</boundingBoxOffsetX>\n");
		s.append( "\t\t<deltaPerStepXs>\n");
		for (int i=0;i<mdeltaPerStepX.size(); i++)
		{
			s.append( "\t\t\t<deltaPerStepX>"+mdeltaPerStepX.elementAt(i)+"</deltaPerStepX>\n");
		}
		s.append( "\t\t</deltaPerStepXs>\n");
		s.append( "\t\t<deltaPerStepYs>\n");
		for (int i=0;i<mdeltaPerStepY.size(); i++)
		{
			s.append( "\t\t\t<deltaPerStepY>"+mdeltaPerStepY.elementAt(i)+"</deltaPerStepY>\n");
		}
		s.append( "\t\t</deltaPerStepYs>\n");
		s.append( "\t\t<text>"+UtilityString.toXML(mtext)+"</text>\n");
		s.append( "\t\t<textType>"+UtilityString.toXML(mtextType)+"</textType>\n");
		s.append( "\t\t<textHeight>"+mtextHeight+"</textHeight>\n");
		s.append( "\t\t<textWidth>"+mtextWidth+"</textWidth>\n");
		s.append( "\t\t<isEnemy>"+misEnemy+"</isEnemy>\n");
		s.append( "\t\t<boundingBoxOffsetY>"+UtilityString.toXML(mboundingBoxOffsetY)+"</boundingBoxOffsetY>\n");
		s.append( "\t\t<isPlayerShot>"+misPlayerShot+"</isPlayerShot>\n");
		s.append( "\t\t<isEnemyShot>"+misEnemyShot+"</isEnemyShot>\n");
		s.append( "\t\t<intensity>"+UtilityString.toXML(mintensity)+"</intensity>\n");
		s.append( "\t\t<eventNames>\n");
		for (int i=0;i<meventName.size(); i++)
		{
			s.append( "\t\t\t<eventName>"+UtilityString.toXML(meventName.elementAt(i))+"</eventName>\n");
		}
		s.append( "\t\t</eventNames>\n");
		s.append( "\t\t<eventUIDs>\n");
		for (int i=0;i<meventUID.size(); i++)
		{
			s.append( "\t\t\t<eventUID>"+UtilityString.toXML(meventUID.elementAt(i))+"</eventUID>\n");
		}
		s.append( "\t\t</eventUIDs>\n");
		s.append( "\t</ActionNewData>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static ActionNewDataXMLHandler XMLHANDLER = new ActionNewDataXMLHandler();
	public static ActionNewDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<ActionNewData> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<ActionNewData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllActionNewData>\n");
			Iterator<ActionNewData> iter = col.iterator();
			while (iter.hasNext())
			{
				ActionNewData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllActionNewData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, ActionNewData> getHashMapFromXML(String filename)
	{
		HashMap<String, ActionNewData> filters = new HashMap<String, ActionNewData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			ActionNewDataXMLHandler h = ActionNewData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"ActionNewData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
