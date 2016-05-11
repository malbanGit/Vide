package de.malban.graphics;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  ImageSequenceDataXMLHandler extends DefaultHandler
{
	private HashMap<String, ImageSequenceData> mImageSequenceData;
	private ImageSequenceData mCurrentData = null;
	private String mCurrentElement = null;
	private String mImageSourceFile = "";
	private Vector<String> mImageSourceFiles = null;
	private String mXPos = "";
	private Vector<Integer> mXPoss = null;
	private String mYPos = "";
	private Vector<Integer> mYPoss = null;
	private String mWidth = "";
	private Vector<Integer> mWidths = null;
	private String mHeight = "";
	private Vector<Integer> mHeights = null;
	private String mDelay = "";
	private String mPosition = "";
	private Vector<Integer> mPositions = null;
	private String mOriginNotice = "";
	private String mCropXPos = "";
	private Vector<Integer> mCropXPoss = null;
	private String mCropYPos = "";
	private Vector<Integer> mCropYPoss = null;
	private String mCropWidth = "";
	private Vector<Integer> mCropWidths = null;
	private String mCropHeight = "";
	private Vector<Integer> mCropHeights = null;
	private String moptimzeCropOffsetX = "";
	private Vector<Integer> moptimzeCropOffsetXs = null;
	private String moptimzeCropOffsetY = "";
	private Vector<Integer> moptimzeCropOffsetYs = null;
	private String mRandomAnimationStart = "";
	public HashMap<String, ImageSequenceData> getLastHashMap()
	{
		return mImageSequenceData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new ImageSequenceData();
		mImageSequenceData = new HashMap<String, ImageSequenceData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("ImageSequenceData"))
		{
			mCurrentData = new ImageSequenceData();
			mImageSourceFile = "";
			mImageSourceFiles = new Vector<String>();
			mXPos = "";
			mXPoss = new Vector<Integer>();
			mYPos = "";
			mYPoss = new Vector<Integer>();
			mWidth = "";
			mWidths = new Vector<Integer>();
			mHeight = "";
			mHeights = new Vector<Integer>();
			mDelay = "";
			mPosition = "";
			mPositions = new Vector<Integer>();
			mOriginNotice = "";
			mCropXPos = "";
			mCropXPoss = new Vector<Integer>();
			mCropYPos = "";
			mCropYPoss = new Vector<Integer>();
			mCropWidth = "";
			mCropWidths = new Vector<Integer>();
			mCropHeight = "";
			mCropHeights = new Vector<Integer>();
			moptimzeCropOffsetX = "";
			moptimzeCropOffsetXs = new Vector<Integer>();
			moptimzeCropOffsetY = "";
			moptimzeCropOffsetYs = new Vector<Integer>();
			mRandomAnimationStart = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("IMAGESOURCEFILE")) mImageSourceFile += s;
		if (mCurrentElement.equalsIgnoreCase("XPOS")) mXPos += s;
		if (mCurrentElement.equalsIgnoreCase("YPOS")) mYPos += s;
		if (mCurrentElement.equalsIgnoreCase("WIDTH")) mWidth += s;
		if (mCurrentElement.equalsIgnoreCase("HEIGHT")) mHeight += s;
		if (mCurrentElement.equalsIgnoreCase("DELAY")) mDelay += s;
		if (mCurrentElement.equalsIgnoreCase("POSITION")) mPosition += s;
		if (mCurrentElement.equalsIgnoreCase("OriginNotice")) mOriginNotice += s;
		if (mCurrentElement.equalsIgnoreCase("CropXPos")) mCropXPos += s;
		if (mCurrentElement.equalsIgnoreCase("CropYPos")) mCropYPos += s;
		if (mCurrentElement.equalsIgnoreCase("CropWidth")) mCropWidth += s;
		if (mCurrentElement.equalsIgnoreCase("CropHeight")) mCropHeight += s;
		if (mCurrentElement.equalsIgnoreCase("optimzeCropOffsetX")) moptimzeCropOffsetX += s;
		if (mCurrentElement.equalsIgnoreCase("optimzeCropOffsetY")) moptimzeCropOffsetY += s;
		if (mCurrentElement.equalsIgnoreCase("RandomAnimationStart")) mRandomAnimationStart += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("IMAGESOURCEFILE".equalsIgnoreCase(qName))
		{
			mImageSourceFiles.addElement(mImageSourceFile);
			mImageSourceFile="";
		}
		if ("XPOS".equalsIgnoreCase(qName))
		{
			try{
			mXPoss.addElement(Integer.parseInt(mXPos));
			}catch (Throwable e){}
			mXPos="";
		}
		if ("YPOS".equalsIgnoreCase(qName))
		{
			try{
			mYPoss.addElement(Integer.parseInt(mYPos));
			}catch (Throwable e){}
			mYPos="";
		}
		if ("WIDTH".equalsIgnoreCase(qName))
		{
			try{
			mWidths.addElement(Integer.parseInt(mWidth));
			}catch (Throwable e){}
			mWidth="";
		}
		if ("HEIGHT".equalsIgnoreCase(qName))
		{
			try{
			mHeights.addElement(Integer.parseInt(mHeight));
			}catch (Throwable e){}
			mHeight="";
		}
		if ("POSITION".equalsIgnoreCase(qName))
		{
			try{
			mPositions.addElement(Integer.parseInt(mPosition));
			}catch (Throwable e){}
			mPosition="";
		}
		if ("CropXPos".equalsIgnoreCase(qName))
		{
			try{
			mCropXPoss.addElement(Integer.parseInt(mCropXPos));
			}catch (Throwable e){}
			mCropXPos="";
		}
		if ("CropYPos".equalsIgnoreCase(qName))
		{
			try{
			mCropYPoss.addElement(Integer.parseInt(mCropYPos));
			}catch (Throwable e){}
			mCropYPos="";
		}
		if ("CropWidth".equalsIgnoreCase(qName))
		{
			try{
			mCropWidths.addElement(Integer.parseInt(mCropWidth));
			}catch (Throwable e){}
			mCropWidth="";
		}
		if ("CropHeight".equalsIgnoreCase(qName))
		{
			try{
			mCropHeights.addElement(Integer.parseInt(mCropHeight));
			}catch (Throwable e){}
			mCropHeight="";
		}
		if ("optimzeCropOffsetX".equalsIgnoreCase(qName))
		{
			try{
			moptimzeCropOffsetXs.addElement(Integer.parseInt(moptimzeCropOffsetX));
			}catch (Throwable e){}
			moptimzeCropOffsetX="";
		}
		if ("optimzeCropOffsetY".equalsIgnoreCase(qName))
		{
			try{
			moptimzeCropOffsetYs.addElement(Integer.parseInt(moptimzeCropOffsetY));
			}catch (Throwable e){}
			moptimzeCropOffsetY="";
		}
		if ("ImageSequenceData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mImageSourceFile = "";
				mCurrentData.mImageSourceFile = mImageSourceFiles;
				mXPos = "";
				mCurrentData.mXPos = mXPoss;
				mYPos = "";
				mCurrentData.mYPos = mYPoss;
				mWidth = "";
				mCurrentData.mWidth = mWidths;
				mHeight = "";
				mCurrentData.mHeight = mHeights;
				try{
				mCurrentData.mDelay = Integer.parseInt(mDelay);
				}catch (Throwable e){}
				mDelay = "";
				mPosition = "";
				mCurrentData.mPosition = mPositions;
				mCurrentData.mOriginNotice = mOriginNotice;
				mOriginNotice = "";
				mCropXPos = "";
				mCurrentData.mCropXPos = mCropXPoss;
				mCropYPos = "";
				mCurrentData.mCropYPos = mCropYPoss;
				mCropWidth = "";
				mCurrentData.mCropWidth = mCropWidths;
				mCropHeight = "";
				mCurrentData.mCropHeight = mCropHeights;
				moptimzeCropOffsetX = "";
				mCurrentData.moptimzeCropOffsetX = moptimzeCropOffsetXs;
				moptimzeCropOffsetY = "";
				mCurrentData.moptimzeCropOffsetY = moptimzeCropOffsetYs;
				try{
				mCurrentData.mRandomAnimationStart = Boolean.parseBoolean(mRandomAnimationStart);
				}catch (Throwable e){}
				mRandomAnimationStart = "";
				mImageSequenceData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
