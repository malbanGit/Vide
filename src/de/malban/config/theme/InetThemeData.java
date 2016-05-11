package de.malban.config.theme;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  InetThemeData
{
	protected String mClass="";
	public String mName="";
	protected Vector<String> mThemeID=new Vector<String>();
	protected Vector<String> mImageUrl=new Vector<String>();
	protected boolean mThemeResizeBackImage=false;
	protected Vector<String> mSaveImageName=new Vector<String>();
	protected Vector<Integer> mStartX=new Vector<Integer>();
	protected Vector<Integer> mStartY=new Vector<Integer>();
	protected Vector<Integer> mHeight=new Vector<Integer>();
	protected Vector<Integer> mWidth=new Vector<Integer>();
	protected Vector<Integer> mScaleWidth=new Vector<Integer>();
	protected Vector<Integer> mScaleHeight=new Vector<Integer>();
	protected Vector<Boolean> mDoScale=new Vector<Boolean>();
	protected boolean mThemeResizeTitleImage=false;
	protected String mGameBackgroundImageName="";
	protected Vector<Boolean> mBuildFromMana=new Vector<Boolean>();
	protected Vector<Boolean> mBuildFromBig=new Vector<Boolean>();
	public Vector<String> getThemeID()
	{
		return mThemeID;
	}
	public void setThemeID(Vector<String> ThemeID)
	{
		mThemeID=ThemeID;
	}
	public Vector<String> getImageUrl()
	{
		return mImageUrl;
	}
	public void setImageUrl(Vector<String> ImageUrl)
	{
		mImageUrl=ImageUrl;
	}
	public boolean getThemeResizeBackImage()
	{
		return mThemeResizeBackImage;
	}
	public void setThemeResizeBackImage(boolean ThemeResizeBackImage)
	{
		mThemeResizeBackImage=ThemeResizeBackImage;
	}
	public Vector<String> getSaveImageName()
	{
		return mSaveImageName;
	}
	public void setSaveImageName(Vector<String> SaveImageName)
	{
		mSaveImageName=SaveImageName;
	}
	public Vector<Integer> getStartX()
	{
		return mStartX;
	}
	public void setStartX(Vector<Integer> StartX)
	{
		mStartX=StartX;
	}
	public Vector<Integer> getStartY()
	{
		return mStartY;
	}
	public void setStartY(Vector<Integer> StartY)
	{
		mStartY=StartY;
	}
	public Vector<Integer> getHeight()
	{
		return mHeight;
	}
	public void setHeight(Vector<Integer> Height)
	{
		mHeight=Height;
	}
	public Vector<Integer> getWidth()
	{
		return mWidth;
	}
	public void setWidth(Vector<Integer> Width)
	{
		mWidth=Width;
	}
	public Vector<Integer> getScaleWidth()
	{
		return mScaleWidth;
	}
	public void setScaleWidth(Vector<Integer> ScaleWidth)
	{
		mScaleWidth=ScaleWidth;
	}
	public Vector<Integer> getScaleHeight()
	{
		return mScaleHeight;
	}
	public void setScaleHeight(Vector<Integer> ScaleHeight)
	{
		mScaleHeight=ScaleHeight;
	}
	public Vector<Boolean> getDoScale()
	{
		return mDoScale;
	}
	public void setDoScale(Vector<Boolean> DoScale)
	{
		mDoScale=DoScale;
	}
	public boolean getThemeResizeTitleImage()
	{
		return mThemeResizeTitleImage;
	}
	public void setThemeResizeTitleImage(boolean ThemeResizeTitleImage)
	{
		mThemeResizeTitleImage=ThemeResizeTitleImage;
	}
	public String getGameBackgroundImageName()
	{
		return mGameBackgroundImageName;
	}
	public void setGameBackgroundImageName(String GameBackgroundImageName)
	{
		mGameBackgroundImageName=GameBackgroundImageName;
	}
	public Vector<Boolean> getBuildFromMana()
	{
		return mBuildFromMana;
	}
	public void setBuildFromMana(Vector<Boolean> BuildFromMana)
	{
		mBuildFromMana=BuildFromMana;
	}
	public Vector<Boolean> getBuildFromBig()
	{
		return mBuildFromBig;
	}
	public void setBuildFromBig(Vector<Boolean> BuildFromBig)
	{
		mBuildFromBig=BuildFromBig;
	}
	private String exportXML()
	{
		String s = new String();
		s += "\t<InetThemeData>\n";
		s += "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n";
		s += "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n";
		s += "\t\t<ThemeIDs>\n";
		for (int i=0;i<mThemeID.size(); i++)
		{
			s += "\t\t\t<ThemeID>"+UtilityString.toXML(mThemeID.elementAt(i))+"</ThemeID>\n";
		}
		s += "\t\t</ThemeIDs>\n";
		s += "\t\t<ImageUrls>\n";
		for (int i=0;i<mImageUrl.size(); i++)
		{
			s += "\t\t\t<ImageUrl>"+UtilityString.toXML(mImageUrl.elementAt(i))+"</ImageUrl>\n";
		}
		s += "\t\t</ImageUrls>\n";
		s += "\t\t<ThemeResizeBackImage>"+mThemeResizeBackImage+"</ThemeResizeBackImage>\n";
		s += "\t\t<SaveImageNames>\n";
		for (int i=0;i<mSaveImageName.size(); i++)
		{
			s += "\t\t\t<SaveImageName>"+UtilityString.toXML(mSaveImageName.elementAt(i))+"</SaveImageName>\n";
		}
		s += "\t\t</SaveImageNames>\n";
		s += "\t\t<StartXs>\n";
		for (int i=0;i<mStartX.size(); i++)
		{
			s += "\t\t\t<StartX>"+mStartX.elementAt(i)+"</StartX>\n";
		}
		s += "\t\t</StartXs>\n";
		s += "\t\t<StartYs>\n";
		for (int i=0;i<mStartY.size(); i++)
		{
			s += "\t\t\t<StartY>"+mStartY.elementAt(i)+"</StartY>\n";
		}
		s += "\t\t</StartYs>\n";
		s += "\t\t<Heights>\n";
		for (int i=0;i<mHeight.size(); i++)
		{
			s += "\t\t\t<Height>"+mHeight.elementAt(i)+"</Height>\n";
		}
		s += "\t\t</Heights>\n";
		s += "\t\t<Widths>\n";
		for (int i=0;i<mWidth.size(); i++)
		{
			s += "\t\t\t<Width>"+mWidth.elementAt(i)+"</Width>\n";
		}
		s += "\t\t</Widths>\n";
		s += "\t\t<ScaleWidths>\n";
		for (int i=0;i<mScaleWidth.size(); i++)
		{
			s += "\t\t\t<ScaleWidth>"+mScaleWidth.elementAt(i)+"</ScaleWidth>\n";
		}
		s += "\t\t</ScaleWidths>\n";
		s += "\t\t<ScaleHeights>\n";
		for (int i=0;i<mScaleHeight.size(); i++)
		{
			s += "\t\t\t<ScaleHeight>"+mScaleHeight.elementAt(i)+"</ScaleHeight>\n";
		}
		s += "\t\t</ScaleHeights>\n";
		s += "\t\t<DoScales>\n";
		for (int i=0;i<mDoScale.size(); i++)
		{
			s += "\t\t\t<DoScale>"+mDoScale.elementAt(i)+"</DoScale>\n";
		}
		s += "\t\t</DoScales>\n";
		s += "\t\t<ThemeResizeTitleImage>"+mThemeResizeTitleImage+"</ThemeResizeTitleImage>\n";
		s += "\t\t<GameBackgroundImageName>"+UtilityString.toXML(mGameBackgroundImageName)+"</GameBackgroundImageName>\n";
		s += "\t\t<BuildFromManas>\n";
		for (int i=0;i<mBuildFromMana.size(); i++)
		{
			s += "\t\t\t<BuildFromMana>"+mBuildFromMana.elementAt(i)+"</BuildFromMana>\n";
		}
		s += "\t\t</BuildFromManas>\n";
		s += "\t\t<BuildFromBigs>\n";
		for (int i=0;i<mBuildFromBig.size(); i++)
		{
			s += "\t\t\t<BuildFromBig>"+mBuildFromBig.elementAt(i)+"</BuildFromBig>\n";
		}
		s += "\t\t</BuildFromBigs>\n";
		s += "\t</InetThemeData>\n";
		return s;
	}
	@Override public String toString()
	{
		return mName;
	}
	private static InetThemeDataXMLHandler XMLHANDLER = new InetThemeDataXMLHandler();
	public static InetThemeDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<InetThemeData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(de.malban.Global.mBaseDir+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllInetThemeData>\n");
			Iterator<InetThemeData> iter = col.iterator();
			while (iter.hasNext())
			{
				InetThemeData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllInetThemeData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, InetThemeData> getHashMapFromXML(String filename)
	{
		HashMap<String, InetThemeData> filters = new HashMap<String, InetThemeData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			InetThemeDataXMLHandler h = InetThemeData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"InetThemeData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
