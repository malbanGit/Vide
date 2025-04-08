package de.malban.vide.veccy;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  ActionNewDataXMLHandler extends DefaultHandler
{
	private HashMap<String, ActionNewData> mActionNewData;
	private ActionNewData mCurrentData = null;
	private String mCurrentElement = null;
	private String manimationFile = "";
	private String mchangeWhileActiveX = "";
	private String mchangeWhileActiveY = "";
	private String msoundLoop = "";
	private String msoundFile = "";
	private String mbehaviour = "";
	private String mpositioning = "";
	private Vector<Integer> mpositionings = null;
	private String mtriggerName = "";
	private Vector<String> mtriggerNames = null;
	private String mresultName = "";
	private Vector<String> mresultNames = null;
	private String mboundingBoxOffsetX = "";
	private String mdeltaPerStepX = "";
	private Vector<Integer> mdeltaPerStepXs = null;
	private String mdeltaPerStepY = "";
	private Vector<Integer> mdeltaPerStepYs = null;
	private String mtext = "";
	private String mtextType = "";
	private String mtextHeight = "";
	private String mtextWidth = "";
	private String misEnemy = "";
	private String mboundingBoxOffsetY = "";
	private String misPlayerShot = "";
	private String misEnemyShot = "";
	private String mintensity = "";
	private String meventName = "";
	private Vector<String> meventNames = null;
	private String meventUID = "";
	private Vector<String> meventUIDs = null;
	public HashMap<String, ActionNewData> getLastHashMap()
	{
		return mActionNewData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new ActionNewData();
		mActionNewData = new HashMap<String, ActionNewData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("ActionNewData"))
		{
			mCurrentData = new ActionNewData();
			manimationFile = "";
			mchangeWhileActiveX = "";
			mchangeWhileActiveY = "";
			msoundLoop = "";
			msoundFile = "";
			mbehaviour = "";
			mpositioning = "";
			mpositionings = new Vector<Integer>();
			mtriggerName = "";
			mtriggerNames = new Vector<String>();
			mresultName = "";
			mresultNames = new Vector<String>();
			mboundingBoxOffsetX = "";
			mdeltaPerStepX = "";
			mdeltaPerStepXs = new Vector<Integer>();
			mdeltaPerStepY = "";
			mdeltaPerStepYs = new Vector<Integer>();
			mtext = "";
			mtextType = "";
			mtextHeight = "";
			mtextWidth = "";
			misEnemy = "";
			mboundingBoxOffsetY = "";
			misPlayerShot = "";
			misEnemyShot = "";
			mintensity = "";
			meventName = "";
			meventNames = new Vector<String>();
			meventUID = "";
			meventUIDs = new Vector<String>();
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("animationFile")) manimationFile += s;
		if (mCurrentElement.equalsIgnoreCase("changeWhileActiveX")) mchangeWhileActiveX += s;
		if (mCurrentElement.equalsIgnoreCase("changeWhileActiveY")) mchangeWhileActiveY += s;
		if (mCurrentElement.equalsIgnoreCase("soundLoop")) msoundLoop += s;
		if (mCurrentElement.equalsIgnoreCase("soundFile")) msoundFile += s;
		if (mCurrentElement.equalsIgnoreCase("Behaviour")) mbehaviour += s;
		if (mCurrentElement.equalsIgnoreCase("Positioning")) mpositioning += s;
		if (mCurrentElement.equalsIgnoreCase("triggerName")) mtriggerName += s;
		if (mCurrentElement.equalsIgnoreCase("resultName")) mresultName += s;
		if (mCurrentElement.equalsIgnoreCase("boundingBoxOffsetX")) mboundingBoxOffsetX += s;
		if (mCurrentElement.equalsIgnoreCase("deltaPerStepX")) mdeltaPerStepX += s;
		if (mCurrentElement.equalsIgnoreCase("deltaPerStepY")) mdeltaPerStepY += s;
		if (mCurrentElement.equalsIgnoreCase("text")) mtext += s;
		if (mCurrentElement.equalsIgnoreCase("textType")) mtextType += s;
		if (mCurrentElement.equalsIgnoreCase("textHeight")) mtextHeight += s;
		if (mCurrentElement.equalsIgnoreCase("textWidth")) mtextWidth += s;
		if (mCurrentElement.equalsIgnoreCase("isEnemy")) misEnemy += s;
		if (mCurrentElement.equalsIgnoreCase("boundingBoxOffsetY")) mboundingBoxOffsetY += s;
		if (mCurrentElement.equalsIgnoreCase("isPlayerShot")) misPlayerShot += s;
		if (mCurrentElement.equalsIgnoreCase("isEnemyShot")) misEnemyShot += s;
		if (mCurrentElement.equalsIgnoreCase("intensity")) mintensity += s;
		if (mCurrentElement.equalsIgnoreCase("eventName")) meventName += s;
		if (mCurrentElement.equalsIgnoreCase("eventUID")) meventUID += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("Positioning".equalsIgnoreCase(qName))
		{
			try{
			mpositionings.addElement(Integer.parseInt(mpositioning));
			}catch (Throwable e){}
			mpositioning="";
		}
		if ("triggerName".equalsIgnoreCase(qName))
		{
			mtriggerNames.addElement(mtriggerName);
			mtriggerName="";
		}
		if ("resultName".equalsIgnoreCase(qName))
		{
			mresultNames.addElement(mresultName);
			mresultName="";
		}
		if ("deltaPerStepX".equalsIgnoreCase(qName))
		{
			try{
			mdeltaPerStepXs.addElement(Integer.parseInt(mdeltaPerStepX));
			}catch (Throwable e){}
			mdeltaPerStepX="";
		}
		if ("deltaPerStepY".equalsIgnoreCase(qName))
		{
			try{
			mdeltaPerStepYs.addElement(Integer.parseInt(mdeltaPerStepY));
			}catch (Throwable e){}
			mdeltaPerStepY="";
		}
		if ("eventName".equalsIgnoreCase(qName))
		{
			meventNames.addElement(meventName);
			meventName="";
		}
		if ("eventUID".equalsIgnoreCase(qName))
		{
			meventUIDs.addElement(meventUID);
			meventUID="";
		}
		if ("ActionNewData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mCurrentData.manimationFile = manimationFile;
				manimationFile = "";
				mCurrentData.mchangeWhileActiveX = mchangeWhileActiveX;
				mchangeWhileActiveX = "";
				mCurrentData.mchangeWhileActiveY = mchangeWhileActiveY;
				mchangeWhileActiveY = "";
				try{
				mCurrentData.msoundLoop = Boolean.parseBoolean(msoundLoop);
				}catch (Throwable e){}
				msoundLoop = "";
				mCurrentData.msoundFile = msoundFile;
				msoundFile = "";
				mCurrentData.mbehaviour = mbehaviour;
				mbehaviour = "";
				mpositioning = "";
				mCurrentData.mpositioning = mpositionings;
				mtriggerName = "";
				mCurrentData.mtriggerName = mtriggerNames;
				mresultName = "";
				mCurrentData.mresultName = mresultNames;
				mCurrentData.mboundingBoxOffsetX = mboundingBoxOffsetX;
				mboundingBoxOffsetX = "";
				mdeltaPerStepX = "";
				mCurrentData.mdeltaPerStepX = mdeltaPerStepXs;
				mdeltaPerStepY = "";
				mCurrentData.mdeltaPerStepY = mdeltaPerStepYs;
				mCurrentData.mtext = mtext;
				mtext = "";
				mCurrentData.mtextType = mtextType;
				mtextType = "";
				try{
				mCurrentData.mtextHeight = Integer.parseInt(mtextHeight);
				}catch (Throwable e){}
				mtextHeight = "";
				try{
				mCurrentData.mtextWidth = Integer.parseInt(mtextWidth);
				}catch (Throwable e){}
				mtextWidth = "";
				try{
				mCurrentData.misEnemy = Boolean.parseBoolean(misEnemy);
				}catch (Throwable e){}
				misEnemy = "";
				mCurrentData.mboundingBoxOffsetY = mboundingBoxOffsetY;
				mboundingBoxOffsetY = "";
				try{
				mCurrentData.misPlayerShot = Boolean.parseBoolean(misPlayerShot);
				}catch (Throwable e){}
				misPlayerShot = "";
				try{
				mCurrentData.misEnemyShot = Boolean.parseBoolean(misEnemyShot);
				}catch (Throwable e){}
				misEnemyShot = "";
				mCurrentData.mintensity = mintensity;
				mintensity = "";
				meventName = "";
				mCurrentData.meventName = meventNames;
				meventUID = "";
				mCurrentData.meventUID = meventUIDs;
				mActionNewData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
