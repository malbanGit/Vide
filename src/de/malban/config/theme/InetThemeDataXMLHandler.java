package de.malban.config.theme;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  InetThemeDataXMLHandler extends DefaultHandler
{
	private HashMap<String, InetThemeData> mInetThemeData;
	private InetThemeData mCurrentData = null;
	private String mCurrentElement = null;
	private String mThemeID = "";
	private Vector<String> mThemeIDs = null;
	private String mImageUrl = "";
	private Vector<String> mImageUrls = null;
	private String mThemeResizeBackImage = "";
	private String mSaveImageName = "";
	private Vector<String> mSaveImageNames = null;
	private String mStartX = "";
	private Vector<Integer> mStartXs = null;
	private String mStartY = "";
	private Vector<Integer> mStartYs = null;
	private String mHeight = "";
	private Vector<Integer> mHeights = null;
	private String mWidth = "";
	private Vector<Integer> mWidths = null;
	private String mScaleWidth = "";
	private Vector<Integer> mScaleWidths = null;
	private String mScaleHeight = "";
	private Vector<Integer> mScaleHeights = null;
	private String mDoScale = "";
	private Vector<Boolean> mDoScales = null;
	private String mThemeResizeTitleImage = "";
	private String mGameBackgroundImageName = "";
	private String mBuildFromMana = "";
	private Vector<Boolean> mBuildFromManas = null;
	private String mBuildFromBig = "";
	private Vector<Boolean> mBuildFromBigs = null;
	public HashMap<String, InetThemeData> getLastHashMap()
	{
		return mInetThemeData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new InetThemeData();
		mInetThemeData = new HashMap<String, InetThemeData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("InetThemeData"))
		{
			mCurrentData = new InetThemeData();
			mThemeID = "";
			mThemeIDs = new Vector<String>();
			mImageUrl = "";
			mImageUrls = new Vector<String>();
			mThemeResizeBackImage = "";
			mSaveImageName = "";
			mSaveImageNames = new Vector<String>();
			mStartX = "";
			mStartXs = new Vector<Integer>();
			mStartY = "";
			mStartYs = new Vector<Integer>();
			mHeight = "";
			mHeights = new Vector<Integer>();
			mWidth = "";
			mWidths = new Vector<Integer>();
			mScaleWidth = "";
			mScaleWidths = new Vector<Integer>();
			mScaleHeight = "";
			mScaleHeights = new Vector<Integer>();
			mDoScale = "";
			mDoScales = new Vector<Boolean>();
			mThemeResizeTitleImage = "";
			mGameBackgroundImageName = "";
			mBuildFromMana = "";
			mBuildFromManas = new Vector<Boolean>();
			mBuildFromBig = "";
			mBuildFromBigs = new Vector<Boolean>();
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("ThemeID")) mThemeID += s;
		if (mCurrentElement.equalsIgnoreCase("ImageUrl")) mImageUrl += s;
		if (mCurrentElement.equalsIgnoreCase("ThemeResizeBackImage")) mThemeResizeBackImage += s;
		if (mCurrentElement.equalsIgnoreCase("SaveImageName")) mSaveImageName += s;
		if (mCurrentElement.equalsIgnoreCase("StartX")) mStartX += s;
		if (mCurrentElement.equalsIgnoreCase("StartY")) mStartY += s;
		if (mCurrentElement.equalsIgnoreCase("Height")) mHeight += s;
		if (mCurrentElement.equalsIgnoreCase("Width")) mWidth += s;
		if (mCurrentElement.equalsIgnoreCase("ScaleWidth")) mScaleWidth += s;
		if (mCurrentElement.equalsIgnoreCase("ScaleHeight")) mScaleHeight += s;
		if (mCurrentElement.equalsIgnoreCase("DoScale")) mDoScale += s;
		if (mCurrentElement.equalsIgnoreCase("ThemeResizeTitleImage")) mThemeResizeTitleImage += s;
		if (mCurrentElement.equalsIgnoreCase("GameBackgroundImageName")) mGameBackgroundImageName += s;
		if (mCurrentElement.equalsIgnoreCase("BuildFromMana")) mBuildFromMana += s;
		if (mCurrentElement.equalsIgnoreCase("BuildFromBig")) mBuildFromBig += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("ThemeID".equalsIgnoreCase(qName))
		{
			mThemeIDs.addElement(mThemeID);
			mThemeID="";
		}
		if ("ImageUrl".equalsIgnoreCase(qName))
		{
			mImageUrls.addElement(mImageUrl);
			mImageUrl="";
		}
		if ("SaveImageName".equalsIgnoreCase(qName))
		{
			mSaveImageNames.addElement(mSaveImageName);
			mSaveImageName="";
		}
		if ("StartX".equalsIgnoreCase(qName))
		{
			try{
			mStartXs.addElement(Integer.parseInt(mStartX));
			}catch (Throwable e){}
			mStartX="";
		}
		if ("StartY".equalsIgnoreCase(qName))
		{
			try{
			mStartYs.addElement(Integer.parseInt(mStartY));
			}catch (Throwable e){}
			mStartY="";
		}
		if ("Height".equalsIgnoreCase(qName))
		{
			try{
			mHeights.addElement(Integer.parseInt(mHeight));
			}catch (Throwable e){}
			mHeight="";
		}
		if ("Width".equalsIgnoreCase(qName))
		{
			try{
			mWidths.addElement(Integer.parseInt(mWidth));
			}catch (Throwable e){}
			mWidth="";
		}
		if ("ScaleWidth".equalsIgnoreCase(qName))
		{
			try{
			mScaleWidths.addElement(Integer.parseInt(mScaleWidth));
			}catch (Throwable e){}
			mScaleWidth="";
		}
		if ("ScaleHeight".equalsIgnoreCase(qName))
		{
			try{
			mScaleHeights.addElement(Integer.parseInt(mScaleHeight));
			}catch (Throwable e){}
			mScaleHeight="";
		}
		if ("DoScale".equalsIgnoreCase(qName))
		{
			try{
			mDoScales.addElement(Boolean.parseBoolean(mDoScale));
			}catch (Throwable e){}
			mDoScale="";
		}
		if ("BuildFromMana".equalsIgnoreCase(qName))
		{
			try{
			mBuildFromManas.addElement(Boolean.parseBoolean(mBuildFromMana));
			}catch (Throwable e){}
			mBuildFromMana="";
		}
		if ("BuildFromBig".equalsIgnoreCase(qName))
		{
			try{
			mBuildFromBigs.addElement(Boolean.parseBoolean(mBuildFromBig));
			}catch (Throwable e){}
			mBuildFromBig="";
		}
		if ("InetThemeData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mThemeID = "";
				mCurrentData.mThemeID = mThemeIDs;
				mImageUrl = "";
				mCurrentData.mImageUrl = mImageUrls;
				try{
				mCurrentData.mThemeResizeBackImage = Boolean.parseBoolean(mThemeResizeBackImage);
				}catch (Throwable e){}
				mThemeResizeBackImage = "";
				mSaveImageName = "";
				mCurrentData.mSaveImageName = mSaveImageNames;
				mStartX = "";
				mCurrentData.mStartX = mStartXs;
				mStartY = "";
				mCurrentData.mStartY = mStartYs;
				mHeight = "";
				mCurrentData.mHeight = mHeights;
				mWidth = "";
				mCurrentData.mWidth = mWidths;
				mScaleWidth = "";
				mCurrentData.mScaleWidth = mScaleWidths;
				mScaleHeight = "";
				mCurrentData.mScaleHeight = mScaleHeights;
				mDoScale = "";
				mCurrentData.mDoScale = mDoScales;
				try{
				mCurrentData.mThemeResizeTitleImage = Boolean.parseBoolean(mThemeResizeTitleImage);
				}catch (Throwable e){}
				mThemeResizeTitleImage = "";
				mCurrentData.mGameBackgroundImageName = mGameBackgroundImageName;
				mGameBackgroundImageName = "";
				mBuildFromMana = "";
				mCurrentData.mBuildFromMana = mBuildFromManas;
				mBuildFromBig = "";
				mCurrentData.mBuildFromBig = mBuildFromBigs;
				mInetThemeData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
