package de.malban.vide.veccy;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  ActionData
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
	protected Vector<String> mtriggerByCause=new Vector<String>();
	protected Vector<String> mtriggerByTarget=new Vector<String>();
	protected Vector<Integer> mtriggerByY=new Vector<Integer>();
	protected Vector<Integer> mtriggerByX=new Vector<Integer>();
	protected Vector<String> mtriggerByTicks=new Vector<String>();
	protected Vector<String> mtriggerBySpriteID=new Vector<String>();
	protected Vector<String> mtriggerByActionID=new Vector<String>();
	protected String mboundingBoxOffsetX="";
	protected Vector<Integer> mdeltaPerStepX=new Vector<Integer>();
	protected Vector<Integer> mdeltaPerStepY=new Vector<Integer>();
	protected String mtext="";
	protected String mtextType="";
	protected int mtextHeight=0;
	protected int mtextWidth=0;
	protected Vector<String> mtriggerResultY=new Vector<String>();
	protected Vector<String> mtriggerResultX=new Vector<String>();
	protected boolean misEnemy=false;
	protected String mboundingBoxOffsetY="";
	protected boolean misPlayerShot=false;
	protected boolean misEnemyShot=false;
	protected String mintensity="";
	protected Vector<String> mtriggerBySpriteIDOrigin=new Vector<String>();
	protected Vector<String> mtriggerBySpriteIDTarget=new Vector<String>();
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
	public Vector<String> gettriggerByCause()
	{
		return mtriggerByCause;
	}
	public void settriggerByCause(Vector<String> triggerByCause)
	{
		mtriggerByCause=triggerByCause;
	}
	public Vector<String> gettriggerByTarget()
	{
		return mtriggerByTarget;
	}
	public void settriggerByTarget(Vector<String> triggerByTarget)
	{
		mtriggerByTarget=triggerByTarget;
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
	public Vector<String> gettriggerByActionID()
	{
		return mtriggerByActionID;
	}
	public void settriggerByActionID(Vector<String> triggerByActionID)
	{
		mtriggerByActionID=triggerByActionID;
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
	public Vector<String> gettriggerResultY()
	{
		return mtriggerResultY;
	}
	public void settriggerResultY(Vector<String> triggerResultY)
	{
		mtriggerResultY=triggerResultY;
	}
	public Vector<String> gettriggerResultX()
	{
		return mtriggerResultX;
	}
	public void settriggerResultX(Vector<String> triggerResultX)
	{
		mtriggerResultX=triggerResultX;
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
	public Vector<String> gettriggerBySpriteIDOrigin()
	{
		return mtriggerBySpriteIDOrigin;
	}
	public void settriggerBySpriteIDOrigin(Vector<String> triggerBySpriteIDOrigin)
	{
		mtriggerBySpriteIDOrigin=triggerBySpriteIDOrigin;
	}
	public Vector<String> gettriggerBySpriteIDTarget()
	{
		return mtriggerBySpriteIDTarget;
	}
	public void settriggerBySpriteIDTarget(Vector<String> triggerBySpriteIDTarget)
	{
		mtriggerBySpriteIDTarget=triggerBySpriteIDTarget;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<ActionData>\n");
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
		s.append( "\t\t<triggerByCauses>\n");
		for (int i=0;i<mtriggerByCause.size(); i++)
		{
			s.append( "\t\t\t<triggerByCause>"+UtilityString.toXML(mtriggerByCause.elementAt(i))+"</triggerByCause>\n");
		}
		s.append( "\t\t</triggerByCauses>\n");
		s.append( "\t\t<triggerByTargets>\n");
		for (int i=0;i<mtriggerByTarget.size(); i++)
		{
			s.append( "\t\t\t<triggerByTarget>"+UtilityString.toXML(mtriggerByTarget.elementAt(i))+"</triggerByTarget>\n");
		}
		s.append( "\t\t</triggerByTargets>\n");
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
		s.append( "\t\t<triggerByActionIDs>\n");
		for (int i=0;i<mtriggerByActionID.size(); i++)
		{
			s.append( "\t\t\t<triggerByActionID>"+UtilityString.toXML(mtriggerByActionID.elementAt(i))+"</triggerByActionID>\n");
		}
		s.append( "\t\t</triggerByActionIDs>\n");
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
		s.append( "\t\t<triggerResultYs>\n");
		for (int i=0;i<mtriggerResultY.size(); i++)
		{
			s.append( "\t\t\t<triggerResultY>"+UtilityString.toXML(mtriggerResultY.elementAt(i))+"</triggerResultY>\n");
		}
		s.append( "\t\t</triggerResultYs>\n");
		s.append( "\t\t<triggerResultXs>\n");
		for (int i=0;i<mtriggerResultX.size(); i++)
		{
			s.append( "\t\t\t<triggerResultX>"+UtilityString.toXML(mtriggerResultX.elementAt(i))+"</triggerResultX>\n");
		}
		s.append( "\t\t</triggerResultXs>\n");
		s.append( "\t\t<isEnemy>"+misEnemy+"</isEnemy>\n");
		s.append( "\t\t<boundingBoxOffsetY>"+UtilityString.toXML(mboundingBoxOffsetY)+"</boundingBoxOffsetY>\n");
		s.append( "\t\t<isPlayerShot>"+misPlayerShot+"</isPlayerShot>\n");
		s.append( "\t\t<isEnemyShot>"+misEnemyShot+"</isEnemyShot>\n");
		s.append( "\t\t<intensity>"+UtilityString.toXML(mintensity)+"</intensity>\n");
		s.append( "\t\t<triggerBySpriteIDOrigins>\n");
		for (int i=0;i<mtriggerBySpriteIDOrigin.size(); i++)
		{
			s.append( "\t\t\t<triggerBySpriteIDOrigin>"+UtilityString.toXML(mtriggerBySpriteIDOrigin.elementAt(i))+"</triggerBySpriteIDOrigin>\n");
		}
		s.append( "\t\t</triggerBySpriteIDOrigins>\n");
		s.append( "\t\t<triggerBySpriteIDTargets>\n");
		for (int i=0;i<mtriggerBySpriteIDTarget.size(); i++)
		{
			s.append( "\t\t\t<triggerBySpriteIDTarget>"+UtilityString.toXML(mtriggerBySpriteIDTarget.elementAt(i))+"</triggerBySpriteIDTarget>\n");
		}
		s.append( "\t\t</triggerBySpriteIDTargets>\n");
		s.append( "\t</ActionData>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static ActionDataXMLHandler XMLHANDLER = new ActionDataXMLHandler();
	public static ActionDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<ActionData> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<ActionData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllActionData>\n");
			Iterator<ActionData> iter = col.iterator();
			while (iter.hasNext())
			{
				ActionData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllActionData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, ActionData> getHashMapFromXML(String filename)
	{
		HashMap<String, ActionData> filters = new HashMap<String, ActionData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			ActionDataXMLHandler h = ActionData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"ActionData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
