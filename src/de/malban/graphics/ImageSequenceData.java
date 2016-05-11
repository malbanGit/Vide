package de.malban.graphics;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  ImageSequenceData
{
	protected String mClass="";
	public String mName="";
	protected Vector<String> mImageSourceFile=new Vector<String>();
	protected Vector<Integer> mXPos=new Vector<Integer>();
	protected Vector<Integer> mYPos=new Vector<Integer>();
	protected Vector<Integer> mWidth=new Vector<Integer>();
	protected Vector<Integer> mHeight=new Vector<Integer>();
	protected int mDelay=0;
	protected Vector<Integer> mPosition=new Vector<Integer>();
	protected String mOriginNotice="";
	protected Vector<Integer> mCropXPos=new Vector<Integer>();
	protected Vector<Integer> mCropYPos=new Vector<Integer>();
	protected Vector<Integer> mCropWidth=new Vector<Integer>();
	protected Vector<Integer> mCropHeight=new Vector<Integer>();
	protected Vector<Integer> moptimzeCropOffsetX=new Vector<Integer>();
	protected Vector<Integer> moptimzeCropOffsetY=new Vector<Integer>();
	protected boolean mRandomAnimationStart=false;
        
        public String getName()
	{
		return mName;
	}
        public String getCClass()
	{
		return mClass;
	}

        public int getMaxHeight()
        {
            int h = 0;
            for (int i = 0; i < mHeight.size(); i++) {
                int s = mHeight.elementAt(i);

                if (moptimzeCropOffsetY.size()>i)
                {
                    s+=moptimzeCropOffsetY.elementAt(i);
                }
                
                if (s > h) h = s;
            }
            return h;
        }
        public int getMaxWidth()
        {
            int w = 0;
            for (int i = 0; i < mWidth.size(); i++) {
                int s = mWidth.elementAt(i);
                if (moptimzeCropOffsetX.size()>i)
                {
                    s+=moptimzeCropOffsetX.elementAt(i);
                }

                if (s > w) w = s;
            }
            return w;
        }
        public int size()
        {
            return mHeight.size();
        }

        public Vector<String> getImageSourceFile()
	{
		return mImageSourceFile;
	}
	public void setImageSourceFile(Vector<String> ImageSourceFile)
	{
		mImageSourceFile=ImageSourceFile;
	}
	public Vector<Integer> getXPos()
	{
		return mXPos;
	}
	public void setXPos(Vector<Integer> XPos)
	{
		mXPos=XPos;
	}
	public Vector<Integer> getYPos()
	{
		return mYPos;
	}
	public void setYPos(Vector<Integer> YPos)
	{
		mYPos=YPos;
	}
	public Vector<Integer> getWidth()
	{
		return mWidth;
	}
	public void setWidth(Vector<Integer> Width)
	{
		mWidth=Width;
	}
	public Vector<Integer> getHeight()
	{
		return mHeight;
	}
	public void setHeight(Vector<Integer> Height)
	{
		mHeight=Height;
	}
	public int getDelay()
	{
		return mDelay;
	}
	public void setDelay(int Delay)
	{
		mDelay=Delay;
	}
	public Vector<Integer> getPosition()
	{
		return mPosition;
	}
	public void setPosition(Vector<Integer> Position)
	{
		mPosition=Position;
	}
	public String getOriginNotice()
	{
		return mOriginNotice;
	}
	public void setOriginNotice(String OriginNotice)
	{
		mOriginNotice=OriginNotice;
	}
	public Vector<Integer> getCropXPos()
	{
		return mCropXPos;
	}
	public void setCropXPos(Vector<Integer> CropXPos)
	{
		mCropXPos=CropXPos;
	}
	public Vector<Integer> getCropYPos()
	{
		return mCropYPos;
	}
	public void setCropYPos(Vector<Integer> CropYPos)
	{
		mCropYPos=CropYPos;
	}
	public Vector<Integer> getCropWidth()
	{
		return mCropWidth;
	}
	public void setCropWidth(Vector<Integer> CropWidth)
	{
		mCropWidth=CropWidth;
	}
	public Vector<Integer> getCropHeight()
	{
		return mCropHeight;
	}
	public void setCropHeight(Vector<Integer> CropHeight)
	{
		mCropHeight=CropHeight;
	}
	public Vector<Integer> getoptimzeCropOffsetX()
	{
		return moptimzeCropOffsetX;
	}
	public void setoptimzeCropOffsetX(Vector<Integer> optimzeCropOffsetX)
	{
		moptimzeCropOffsetX=optimzeCropOffsetX;
	}
	public Vector<Integer> getoptimzeCropOffsetY()
	{
		return moptimzeCropOffsetY;
	}
	public void setoptimzeCropOffsetY(Vector<Integer> optimzeCropOffsetY)
	{
		moptimzeCropOffsetY=optimzeCropOffsetY;
	}
	public boolean getRandomAnimationStart()
	{
		return mRandomAnimationStart;
	}
	public void setRandomAnimationStart(boolean RandomAnimationStart)
	{
		mRandomAnimationStart=RandomAnimationStart;
	}
	private String exportXML()
	{
		String s = new String();
		s += "\t<ImageSequenceData>\n";
		s += "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n";
		s += "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n";
		s += "\t\t<IMAGESOURCEFILEs>\n";
		for (int i=0;i<mImageSourceFile.size(); i++)
		{
			s += "\t\t\t<IMAGESOURCEFILE>"+UtilityString.toXML(mImageSourceFile.elementAt(i))+"</IMAGESOURCEFILE>\n";
		}
		s += "\t\t</IMAGESOURCEFILEs>\n";
		s += "\t\t<XPOSs>\n";
		for (int i=0;i<mXPos.size(); i++)
		{
			s += "\t\t\t<XPOS>"+mXPos.elementAt(i)+"</XPOS>\n";
		}
		s += "\t\t</XPOSs>\n";
		s += "\t\t<YPOSs>\n";
		for (int i=0;i<mYPos.size(); i++)
		{
			s += "\t\t\t<YPOS>"+mYPos.elementAt(i)+"</YPOS>\n";
		}
		s += "\t\t</YPOSs>\n";
		s += "\t\t<WIDTHs>\n";
		for (int i=0;i<mWidth.size(); i++)
		{
			s += "\t\t\t<WIDTH>"+mWidth.elementAt(i)+"</WIDTH>\n";
		}
		s += "\t\t</WIDTHs>\n";
		s += "\t\t<HEIGHTs>\n";
		for (int i=0;i<mHeight.size(); i++)
		{
			s += "\t\t\t<HEIGHT>"+mHeight.elementAt(i)+"</HEIGHT>\n";
		}
		s += "\t\t</HEIGHTs>\n";
		s += "\t\t<DELAY>"+mDelay+"</DELAY>\n";
		s += "\t\t<POSITIONs>\n";
		for (int i=0;i<mPosition.size(); i++)
		{
			s += "\t\t\t<POSITION>"+mPosition.elementAt(i)+"</POSITION>\n";
		}
		s += "\t\t</POSITIONs>\n";
		s += "\t\t<OriginNotice>"+UtilityString.toXML(mOriginNotice)+"</OriginNotice>\n";
		s += "\t\t<CropXPoss>\n";
		for (int i=0;i<mCropXPos.size(); i++)
		{
			s += "\t\t\t<CropXPos>"+mCropXPos.elementAt(i)+"</CropXPos>\n";
		}
		s += "\t\t</CropXPoss>\n";
		s += "\t\t<CropYPoss>\n";
		for (int i=0;i<mCropYPos.size(); i++)
		{
			s += "\t\t\t<CropYPos>"+mCropYPos.elementAt(i)+"</CropYPos>\n";
		}
		s += "\t\t</CropYPoss>\n";
		s += "\t\t<CropWidths>\n";
		for (int i=0;i<mCropWidth.size(); i++)
		{
			s += "\t\t\t<CropWidth>"+mCropWidth.elementAt(i)+"</CropWidth>\n";
		}
		s += "\t\t</CropWidths>\n";
		s += "\t\t<CropHeights>\n";
		for (int i=0;i<mCropHeight.size(); i++)
		{
			s += "\t\t\t<CropHeight>"+mCropHeight.elementAt(i)+"</CropHeight>\n";
		}
		s += "\t\t</CropHeights>\n";
		s += "\t\t<optimzeCropOffsetXs>\n";
		for (int i=0;i<moptimzeCropOffsetX.size(); i++)
		{
			s += "\t\t\t<optimzeCropOffsetX>"+moptimzeCropOffsetX.elementAt(i)+"</optimzeCropOffsetX>\n";
		}
		s += "\t\t</optimzeCropOffsetXs>\n";
		s += "\t\t<optimzeCropOffsetYs>\n";
		for (int i=0;i<moptimzeCropOffsetY.size(); i++)
		{
			s += "\t\t\t<optimzeCropOffsetY>"+moptimzeCropOffsetY.elementAt(i)+"</optimzeCropOffsetY>\n";
		}
		s += "\t\t</optimzeCropOffsetYs>\n";
		s += "\t\t<RandomAnimationStart>"+mRandomAnimationStart+"</RandomAnimationStart>\n";
		s += "\t</ImageSequenceData>\n";
		return s;
	}
	@Override public String toString()
	{
		return mName;
	}
	private static ImageSequenceDataXMLHandler XMLHANDLER = new ImageSequenceDataXMLHandler();
	public static ImageSequenceDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<ImageSequenceData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(de.malban.Global.mBaseDir+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllImageSequenceData>\n");
			Iterator<ImageSequenceData> iter = col.iterator();
			while (iter.hasNext())
			{
				ImageSequenceData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllImageSequenceData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, ImageSequenceData> getHashMapFromXML(String filename)
	{
		HashMap<String, ImageSequenceData> filters = new HashMap<String, ImageSequenceData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			ImageSequenceDataXMLHandler h = ImageSequenceData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"ImageSequenceData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
