package de.malban.vide.veccy;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  ActionDataXMLHandler extends DefaultHandler
{
	private HashMap<String, ActionData> mActionData;
	private ActionData mCurrentData = null;
	private String mCurrentElement = null;
	private String manimationFile = "";
	private String mchangeWhileActiveX = "";
	private String mchangeWhileActiveY = "";
	private String msoundLoop = "";
	private String msoundFile = "";
	private String mbehaviour = "";
	private String mpositioning = "";
	private Vector<Integer> mpositionings = null;
	private String mtriggerByCause = "";
	private Vector<String> mtriggerByCauses = null;
	private String mtriggerByTarget = "";
	private Vector<String> mtriggerByTargets = null;
	private String mtriggerByY = "";
	private Vector<Integer> mtriggerByYs = null;
	private String mtriggerByX = "";
	private Vector<Integer> mtriggerByXs = null;
	private String mtriggerByTicks = "";
	private Vector<String> mtriggerByTickss = null;
	private String mtriggerBySpriteID = "";
	private Vector<String> mtriggerBySpriteIDs = null;
	private String mtriggerByActionID = "";
	private Vector<String> mtriggerByActionIDs = null;
	private String mboundingBoxOffsetX = "";
	private String mdeltaPerStepX = "";
	private Vector<Integer> mdeltaPerStepXs = null;
	private String mdeltaPerStepY = "";
	private Vector<Integer> mdeltaPerStepYs = null;
	private String mtext = "";
	private String mtextType = "";
	private String mtextHeight = "";
	private String mtextWidth = "";
	private String mtriggerResultY = "";
	private Vector<String> mtriggerResultYs = null;
	private String mtriggerResultX = "";
	private Vector<String> mtriggerResultXs = null;
	private String misEnemy = "";
	private String mboundingBoxOffsetY = "";
	private String misPlayerShot = "";
	private String misEnemyShot = "";
	private String mintensity = "";
	private String mtriggerBySpriteIDOrigin = "";
	private Vector<String> mtriggerBySpriteIDOrigins = null;
	private String mtriggerBySpriteIDTarget = "";
	private Vector<String> mtriggerBySpriteIDTargets = null;
	public HashMap<String, ActionData> getLastHashMap()
	{
		return mActionData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new ActionData();
		mActionData = new HashMap<String, ActionData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("ActionData"))
		{
			mCurrentData = new ActionData();
			manimationFile = "";
			mchangeWhileActiveX = "";
			mchangeWhileActiveY = "";
			msoundLoop = "";
			msoundFile = "";
			mbehaviour = "";
			mpositioning = "";
			mpositionings = new Vector<Integer>();
			mtriggerByCause = "";
			mtriggerByCauses = new Vector<String>();
			mtriggerByTarget = "";
			mtriggerByTargets = new Vector<String>();
			mtriggerByY = "";
			mtriggerByYs = new Vector<Integer>();
			mtriggerByX = "";
			mtriggerByXs = new Vector<Integer>();
			mtriggerByTicks = "";
			mtriggerByTickss = new Vector<String>();
			mtriggerBySpriteID = "";
			mtriggerBySpriteIDs = new Vector<String>();
			mtriggerByActionID = "";
			mtriggerByActionIDs = new Vector<String>();
			mboundingBoxOffsetX = "";
			mdeltaPerStepX = "";
			mdeltaPerStepXs = new Vector<Integer>();
			mdeltaPerStepY = "";
			mdeltaPerStepYs = new Vector<Integer>();
			mtext = "";
			mtextType = "";
			mtextHeight = "";
			mtextWidth = "";
			mtriggerResultY = "";
			mtriggerResultYs = new Vector<String>();
			mtriggerResultX = "";
			mtriggerResultXs = new Vector<String>();
			misEnemy = "";
			mboundingBoxOffsetY = "";
			misPlayerShot = "";
			misEnemyShot = "";
			mintensity = "";
			mtriggerBySpriteIDOrigin = "";
			mtriggerBySpriteIDOrigins = new Vector<String>();
			mtriggerBySpriteIDTarget = "";
			mtriggerBySpriteIDTargets = new Vector<String>();
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
		if (mCurrentElement.equalsIgnoreCase("triggerByCause")) mtriggerByCause += s;
		if (mCurrentElement.equalsIgnoreCase("triggerByTarget")) mtriggerByTarget += s;
		if (mCurrentElement.equalsIgnoreCase("triggerByY")) mtriggerByY += s;
		if (mCurrentElement.equalsIgnoreCase("triggerByX")) mtriggerByX += s;
		if (mCurrentElement.equalsIgnoreCase("triggerByTicks")) mtriggerByTicks += s;
		if (mCurrentElement.equalsIgnoreCase("triggerBySpriteID")) mtriggerBySpriteID += s;
		if (mCurrentElement.equalsIgnoreCase("triggerByActionID")) mtriggerByActionID += s;
		if (mCurrentElement.equalsIgnoreCase("boundingBoxOffsetX")) mboundingBoxOffsetX += s;
		if (mCurrentElement.equalsIgnoreCase("deltaPerStepX")) mdeltaPerStepX += s;
		if (mCurrentElement.equalsIgnoreCase("deltaPerStepY")) mdeltaPerStepY += s;
		if (mCurrentElement.equalsIgnoreCase("text")) mtext += s;
		if (mCurrentElement.equalsIgnoreCase("textType")) mtextType += s;
		if (mCurrentElement.equalsIgnoreCase("textHeight")) mtextHeight += s;
		if (mCurrentElement.equalsIgnoreCase("textWidth")) mtextWidth += s;
		if (mCurrentElement.equalsIgnoreCase("triggerResultY")) mtriggerResultY += s;
		if (mCurrentElement.equalsIgnoreCase("triggerResultX")) mtriggerResultX += s;
		if (mCurrentElement.equalsIgnoreCase("isEnemy")) misEnemy += s;
		if (mCurrentElement.equalsIgnoreCase("boundingBoxOffsetY")) mboundingBoxOffsetY += s;
		if (mCurrentElement.equalsIgnoreCase("isPlayerShot")) misPlayerShot += s;
		if (mCurrentElement.equalsIgnoreCase("isEnemyShot")) misEnemyShot += s;
		if (mCurrentElement.equalsIgnoreCase("intensity")) mintensity += s;
		if (mCurrentElement.equalsIgnoreCase("triggerBySpriteIDOrigin")) mtriggerBySpriteIDOrigin += s;
		if (mCurrentElement.equalsIgnoreCase("triggerBySpriteIDTarget")) mtriggerBySpriteIDTarget += s;
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
		if ("triggerByCause".equalsIgnoreCase(qName))
		{
			mtriggerByCauses.addElement(mtriggerByCause);
			mtriggerByCause="";
		}
		if ("triggerByTarget".equalsIgnoreCase(qName))
		{
			mtriggerByTargets.addElement(mtriggerByTarget);
			mtriggerByTarget="";
		}
		if ("triggerByY".equalsIgnoreCase(qName))
		{
			try{
			mtriggerByYs.addElement(Integer.parseInt(mtriggerByY));
			}catch (Throwable e){}
			mtriggerByY="";
		}
		if ("triggerByX".equalsIgnoreCase(qName))
		{
			try{
			mtriggerByXs.addElement(Integer.parseInt(mtriggerByX));
			}catch (Throwable e){}
			mtriggerByX="";
		}
		if ("triggerByTicks".equalsIgnoreCase(qName))
		{
			mtriggerByTickss.addElement(mtriggerByTicks);
			mtriggerByTicks="";
		}
		if ("triggerBySpriteID".equalsIgnoreCase(qName))
		{
			mtriggerBySpriteIDs.addElement(mtriggerBySpriteID);
			mtriggerBySpriteID="";
		}
		if ("triggerByActionID".equalsIgnoreCase(qName))
		{
			mtriggerByActionIDs.addElement(mtriggerByActionID);
			mtriggerByActionID="";
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
		if ("triggerResultY".equalsIgnoreCase(qName))
		{
			mtriggerResultYs.addElement(mtriggerResultY);
			mtriggerResultY="";
		}
		if ("triggerResultX".equalsIgnoreCase(qName))
		{
			mtriggerResultXs.addElement(mtriggerResultX);
			mtriggerResultX="";
		}
		if ("triggerBySpriteIDOrigin".equalsIgnoreCase(qName))
		{
			mtriggerBySpriteIDOrigins.addElement(mtriggerBySpriteIDOrigin);
			mtriggerBySpriteIDOrigin="";
		}
		if ("triggerBySpriteIDTarget".equalsIgnoreCase(qName))
		{
			mtriggerBySpriteIDTargets.addElement(mtriggerBySpriteIDTarget);
			mtriggerBySpriteIDTarget="";
		}
		if ("ActionData".equalsIgnoreCase(qName))
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
				mtriggerByCause = "";
				mCurrentData.mtriggerByCause = mtriggerByCauses;
				mtriggerByTarget = "";
				mCurrentData.mtriggerByTarget = mtriggerByTargets;
				mtriggerByY = "";
				mCurrentData.mtriggerByY = mtriggerByYs;
				mtriggerByX = "";
				mCurrentData.mtriggerByX = mtriggerByXs;
				mtriggerByTicks = "";
				mCurrentData.mtriggerByTicks = mtriggerByTickss;
				mtriggerBySpriteID = "";
				mCurrentData.mtriggerBySpriteID = mtriggerBySpriteIDs;
				mtriggerByActionID = "";
				mCurrentData.mtriggerByActionID = mtriggerByActionIDs;
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
				mtriggerResultY = "";
				mCurrentData.mtriggerResultY = mtriggerResultYs;
				mtriggerResultX = "";
				mCurrentData.mtriggerResultX = mtriggerResultXs;
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
				mtriggerBySpriteIDOrigin = "";
				mCurrentData.mtriggerBySpriteIDOrigin = mtriggerBySpriteIDOrigins;
				mtriggerBySpriteIDTarget = "";
				mCurrentData.mtriggerBySpriteIDTarget = mtriggerBySpriteIDTargets;
				mActionData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
