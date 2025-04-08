package de.malban.vide.veccy;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  BackGroundSceneXMLHandler extends DefaultHandler
{
	private HashMap<String, BackGroundScene> mBackGroundScene;
	private BackGroundScene mCurrentData = null;
	private String mCurrentElement = null;
	private String msceneFile = "";
	private String myPos = "";
	private String mxPos = "";
	private String mscale = "";
	private String mintensity = "";
	public HashMap<String, BackGroundScene> getLastHashMap()
	{
		return mBackGroundScene;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new BackGroundScene();
		mBackGroundScene = new HashMap<String, BackGroundScene>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("BackGroundScene"))
		{
			mCurrentData = new BackGroundScene();
			msceneFile = "";
			myPos = "";
			mxPos = "";
			mscale = "";
			mintensity = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("sceneFile")) msceneFile += s;
		if (mCurrentElement.equalsIgnoreCase("yPos")) myPos += s;
		if (mCurrentElement.equalsIgnoreCase("xPos")) mxPos += s;
		if (mCurrentElement.equalsIgnoreCase("scale")) mscale += s;
		if (mCurrentElement.equalsIgnoreCase("intensity")) mintensity += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("BackGroundScene".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mCurrentData.msceneFile = msceneFile;
				msceneFile = "";
				try{
				mCurrentData.myPos = Integer.parseInt(myPos);
				}catch (Throwable e){}
				myPos = "";
				try{
				mCurrentData.mxPos = Integer.parseInt(mxPos);
				}catch (Throwable e){}
				mxPos = "";
				try{
				mCurrentData.mscale = Integer.parseInt(mscale);
				}catch (Throwable e){}
				mscale = "";
				try{
				mCurrentData.mintensity = Integer.parseInt(mintensity);
				}catch (Throwable e){}
				mintensity = "";
				mBackGroundScene.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
