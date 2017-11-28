package de.malban.vide.vecx.cartridge;

import de.malban.Global;
import de.malban.gui.ImageCache;
import de.malban.util.*;
import java.awt.image.BufferedImage;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  CartridgeProperties implements Serializable
{
	protected String mClass="";
	public String mName="";
	protected String mCartName="";
	protected String mAuthor="";
	protected String mYear="";
	protected int mCRC=0;
	protected int mTypeFlags=0;
	protected Vector<String> mFullFilename=new Vector<String>();
	protected String mInformation="";
	protected String mCheats="";
	protected String mEastereggs="";
	protected String mHomepage="";
	protected String mInstructionFile="";
	protected String mFrontImage="";
	protected String mBackImage="";
	protected String mOverlay="";
	protected String mInGameImage="";
	protected String mCritic="";
	protected String mOther="";
	protected String mBinaryLink="";
	protected String mLicence="";
	protected String mCopyrightType="";
	protected String mPDFLink="";
	protected String mPDFFile="";
	protected String mCartridgeImage="";
	protected boolean mHomebrew=false;
	protected boolean mDemo=false;
	protected boolean mSnippet=false;
	protected boolean mCompleteGame=false;
	protected String mextremeVecFileImage="";
	protected String mWheelName="";
	protected boolean mConfigOverwrite=false;
	protected boolean mCF_AutoSync=false;
	protected boolean mCF_AllowROMWrite=false;
	protected boolean mCF_ROM_PC_BreakPoints=false;
	protected int mCF_IntegratorMaxX=0;
	protected int mCF_IntegratorMaxY=0;
	protected float mCF_OverlayThreshold=0f;
	protected int mCF_DotdwellDivisor=0;
        
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
	public String getCartName()
	{
		return mCartName;
	}
	public void setCartName(String CartName)
	{
		mCartName=CartName;
	}
	public String getAuthor()
	{
		return mAuthor;
	}
	public void setAuthor(String Author)
	{
		mAuthor=Author;
	}
	public String getYear()
	{
		return mYear;
	}
	public void setYear(String Year)
	{
		mYear=Year;
	}
	public int getCRC()
	{
		return mCRC;
	}
	public void setCRC(int CRC)
	{
		mCRC=CRC;
	}
	public int getTypeFlags()
	{
		return mTypeFlags;
	}
	public void setTypeFlags(int TypeFlags)
	{
		mTypeFlags=TypeFlags;
	}
	public Vector<String> getFullFilename()
	{
		return mFullFilename;
	}
	public void setFullFilename(Vector<String> FullFilename)
	{
		mFullFilename=FullFilename;
	}
	public String getInformation()
	{
		return mInformation;
	}
	public void setInformation(String Information)
	{
		mInformation=Information;
	}
	public String getCheats()
	{
		return mCheats;
	}
	public void setCheats(String Cheats)
	{
		mCheats=Cheats;
	}
	public String getEastereggs()
	{
		return mEastereggs;
	}
	public void setEastereggs(String Eastereggs)
	{
		mEastereggs=Eastereggs;
	}
	public String getHomepage()
	{
		return mHomepage;
	}
	public void setHomepage(String Homepage)
	{
		mHomepage=Homepage;
	}
	public String getInstructionFile()
	{
		return mInstructionFile;
	}
	public void setInstructionFile(String InstructionFile)
	{
		mInstructionFile=InstructionFile;
	}
	public void setFrontImage(String FrontImage)
	{
		mFrontImage=FrontImage;
	}
	public void setBackImage(String BackImage)
	{
		mBackImage=BackImage;
	}
	public void setOverlay(String Overlay)
	{
		mOverlay=Overlay;
	}
	public void setInGameImage(String InGameImage)
	{
		mInGameImage=InGameImage;
	}
	public String getCritic()
	{
		return mCritic;
	}
	public void setCritic(String Critic)
	{
		mCritic=Critic;
	}
	public String getOther()
	{
		return mOther;
	}
	public void setOther(String Other)
	{
		mOther=Other;
	}
	public String getBinaryLink()
	{
		return mBinaryLink;
	}
	public void setBinaryLink(String BinaryLink)
	{
		mBinaryLink=BinaryLink;
	}
	public String getLicence()
	{
		return mLicence;
	}
	public void setLicence(String Licence)
	{
		mLicence=Licence;
	}
	public String getCopyrightType()
	{
		return mCopyrightType;
	}
	public void setCopyrightType(String CopyrightType)
	{
		mCopyrightType=CopyrightType;
	}
	public String getPDFLink()
	{
		return mPDFLink;
	}
	public void setPDFLink(String PDFLink)
	{
		mPDFLink=PDFLink;
	}
	public String getPDFFile()
	{
		return mPDFFile;
	}
	public void setPDFFile(String PDFFile)
	{
		mPDFFile=PDFFile;
	}
	public void setCartridgeImage(String CartridgeImage)
	{
		mCartridgeImage=CartridgeImage;
	}
	public boolean getHomebrew()
	{
		return mHomebrew;
	}
	public void setHomebrew(boolean Homebrew)
	{
		mHomebrew=Homebrew;
	}
	public boolean getDemo()
	{
		return mDemo;
	}
	public void setDemo(boolean Demo)
	{
		mDemo=Demo;
	}
	public boolean getSnippet()
	{
		return mSnippet;
	}
	public void setSnippet(boolean Snippet)
	{
		mSnippet=Snippet;
	}
	public boolean getCompleteGame()
	{
		return mCompleteGame;
	}
	public void setCompleteGame(boolean CompleteGame)
	{
		mCompleteGame=CompleteGame;
	}
	public String getextremeVecFileImage()
	{
		return mextremeVecFileImage;
	}
	public void setextremeVecFileImage(String extremeVecFileImage)
	{
		mextremeVecFileImage=extremeVecFileImage;
	}
	public String getWheelName()
	{
		return mWheelName;
	}
	public void setWheelName(String WheelName)
	{
		mWheelName=WheelName;
	}
	public boolean getConfigOverwrite()
	{
		return mConfigOverwrite;
	}
	public void setConfigOverwrite(boolean ConfigOverwrite)
	{
		mConfigOverwrite=ConfigOverwrite;
	}
	public boolean getCF_AutoSync()
	{
		return mCF_AutoSync;
	}
	public void setCF_AutoSync(boolean CF_AutoSync)
	{
		mCF_AutoSync=CF_AutoSync;
	}
	public boolean getCF_AllowROMWrite()
	{
		return mCF_AllowROMWrite;
	}
	public void setCF_AllowROMWrite(boolean CF_AllowROMWrite)
	{
		mCF_AllowROMWrite=CF_AllowROMWrite;
	}
	public boolean getCF_ROM_PC_BreakPoints()
	{
		return mCF_ROM_PC_BreakPoints;
	}
	public void setCF_ROM_PC_BreakPoints(boolean CF_ROM_PC_BreakPoints)
	{
		mCF_ROM_PC_BreakPoints=CF_ROM_PC_BreakPoints;
	}
	public int getCF_IntegratorMaxX()
	{
		return mCF_IntegratorMaxX;
	}
	public void setCF_IntegratorMaxX(int CF_IntegratorMaxX)
	{
		mCF_IntegratorMaxX=CF_IntegratorMaxX;
	}
	public int getCF_IntegratorMaxY()
	{
		return mCF_IntegratorMaxY;
	}
	public void setCF_IntegratorMaxY(int CF_IntegratorMaxY)
	{
		mCF_IntegratorMaxY=CF_IntegratorMaxY;
	}
	public float getCF_OverlayThreshold()
	{
		return mCF_OverlayThreshold;
	}
	public void setCF_OverlayThreshold(float CF_OverlayThreshold)
	{
		mCF_OverlayThreshold=CF_OverlayThreshold;
	}
	public int getCF_DotdwellDivisor()
	{
		return mCF_DotdwellDivisor;
	}
	public void setCF_DotdwellDivisor(int CF_DotdwellDivisor)
	{
		mCF_DotdwellDivisor=CF_DotdwellDivisor;
	}
        private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<CartridgeProperties>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<CartName>"+UtilityString.toXML(mCartName)+"</CartName>\n");
		s.append( "\t\t<Author>"+UtilityString.toXML(mAuthor)+"</Author>\n");
		s.append( "\t\t<Year>"+UtilityString.toXML(mYear)+"</Year>\n");
		s.append( "\t\t<CRC>"+mCRC+"</CRC>\n");
		s.append( "\t\t<TypeFlags>"+mTypeFlags+"</TypeFlags>\n");
		s.append( "\t\t<FullFilenames>\n");
		for (int i=0;i<mFullFilename.size(); i++)
		{
			s.append( "\t\t\t<FullFilename>"+UtilityString.toXML(mFullFilename.elementAt(i))+"</FullFilename>\n");
		}
		s.append( "\t\t</FullFilenames>\n");
		s.append( "\t\t<Information>"+UtilityString.toXML(mInformation)+"</Information>\n");
		s.append( "\t\t<Cheats>"+UtilityString.toXML(mCheats)+"</Cheats>\n");
		s.append( "\t\t<Eastereggs>"+UtilityString.toXML(mEastereggs)+"</Eastereggs>\n");
		s.append( "\t\t<Homepage>"+UtilityString.toXML(mHomepage)+"</Homepage>\n");
		s.append( "\t\t<InstructionFile>"+UtilityString.toXML(mInstructionFile)+"</InstructionFile>\n");
		s.append( "\t\t<FrontImage>"+UtilityString.toXML(mFrontImage)+"</FrontImage>\n");
		s.append( "\t\t<BackImage>"+UtilityString.toXML(mBackImage)+"</BackImage>\n");
		s.append( "\t\t<Overlay>"+UtilityString.toXML(mOverlay)+"</Overlay>\n");
		s.append( "\t\t<InGameImage>"+UtilityString.toXML(mInGameImage)+"</InGameImage>\n");
		s.append( "\t\t<Critic>"+UtilityString.toXML(mCritic)+"</Critic>\n");
		s.append( "\t\t<Other>"+UtilityString.toXML(mOther)+"</Other>\n");
		s.append( "\t\t<BinaryLink>"+UtilityString.toXML(mBinaryLink)+"</BinaryLink>\n");
		s.append( "\t\t<Licence>"+UtilityString.toXML(mLicence)+"</Licence>\n");
		s.append( "\t\t<CopyrightType>"+UtilityString.toXML(mCopyrightType)+"</CopyrightType>\n");
		s.append( "\t\t<PDFLink>"+UtilityString.toXML(mPDFLink)+"</PDFLink>\n");
		s.append( "\t\t<PDFFile>"+UtilityString.toXML(mPDFFile)+"</PDFFile>\n");
		s.append( "\t\t<CartridgeImage>"+UtilityString.toXML(mCartridgeImage)+"</CartridgeImage>\n");
		s.append( "\t\t<Homebrew>"+mHomebrew+"</Homebrew>\n");
		s.append( "\t\t<Demo>"+mDemo+"</Demo>\n");
		s.append( "\t\t<Snippet>"+mSnippet+"</Snippet>\n");
		s.append( "\t\t<CompleteGame>"+mCompleteGame+"</CompleteGame>\n");
		s.append( "\t\t<extremeVecFileImage>"+UtilityString.toXML(mextremeVecFileImage)+"</extremeVecFileImage>\n");
		s.append( "\t\t<WheelName>"+UtilityString.toXML(mWheelName)+"</WheelName>\n");
		s.append( "\t\t<ConfigOverwrite>"+mConfigOverwrite+"</ConfigOverwrite>\n");
		s.append( "\t\t<CF_AutoSync>"+mCF_AutoSync+"</CF_AutoSync>\n");
		s.append( "\t\t<CF_AllowROMWrite>"+mCF_AllowROMWrite+"</CF_AllowROMWrite>\n");
		s.append( "\t\t<CF_ROM_PC_BreakPoints>"+mCF_ROM_PC_BreakPoints+"</CF_ROM_PC_BreakPoints>\n");
		s.append( "\t\t<CF_IntegratorMaxX>"+mCF_IntegratorMaxX+"</CF_IntegratorMaxX>\n");
		s.append( "\t\t<CF_IntegratorMaxY>"+mCF_IntegratorMaxY+"</CF_IntegratorMaxY>\n");
		s.append( "\t\t<CF_OverlayThreshold>"+mCF_OverlayThreshold+"</CF_OverlayThreshold>\n");
		s.append( "\t\t<CF_DotdwellDivisor>"+mCF_DotdwellDivisor+"</CF_DotdwellDivisor>\n");
		s.append( "\t</CartridgeProperties>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static CartridgePropertiesXMLHandler XMLHANDLER = new CartridgePropertiesXMLHandler();
	public static CartridgePropertiesXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<CartridgeProperties> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<CartridgeProperties> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllCartridgeProperties>\n");
			Iterator<CartridgeProperties> iter = col.iterator();
			while (iter.hasNext())
			{
				CartridgeProperties item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllCartridgeProperties>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, CartridgeProperties> getHashMapFromXML(String filename)
	{
		HashMap<String, CartridgeProperties> filters = new HashMap<String, CartridgeProperties>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			CartridgePropertiesXMLHandler h = CartridgeProperties.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"CartridgeProperties Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
	public String getOverlay()
	{
		return mOverlay;
	}
	public String getCartridgeImage()
	{
		return mCartridgeImage;
	}
	public String getFrontImage()
	{
		return mFrontImage;
	}
	public String getBackImage()
	{
		return mBackImage;
	}
	public String getInGameImage()
	{
		return mInGameImage;
	}
        BufferedImage getImage(String filename, int w, int h)
        {
            File f = new File(Global.mainPathPrefix+filename);
            if (!f.exists()) return null;
            BufferedImage org = ImageCache.getImageCache().getImage(Global.mainPathPrefix+filename);
            return ImageCache.getImageCache().getDerivatScale(org, w, h);
        }
        public static String convertSeperator(String filename)
        {
            String ret = de.malban.util.UtilityString.replace(filename, "/", File.separator);
            ret = de.malban.util.UtilityString.replace(ret, "\\", File.separator);
            return ret;
        }
        transient BufferedImage mSmallCartridgeImage = null;
        transient BufferedImage mSmallFrontImage = null;
        transient BufferedImage mSmallBackImage = null;
        transient BufferedImage mSmallInGameImage = null;
        public BufferedImage getSmallCartridgeImage()
	{
            if (mSmallCartridgeImage == null)
                mSmallCartridgeImage = getImage(convertSeperator(getCartridgeImage()), 100,100);
            return mSmallCartridgeImage;
	}
	public BufferedImage getSmallFrontImage()
	{
            if (mSmallFrontImage == null)
                mSmallFrontImage = getImage(convertSeperator(getFrontImage()), 60,100);
		return mSmallFrontImage;
	}
	public BufferedImage getSmallBackImage()
	{
            if (mSmallBackImage == null)
                mSmallBackImage = getImage(convertSeperator(getBackImage()), 60,100);
		return mSmallBackImage;
	}
	public BufferedImage getSmallInGameImage()
	{
            if (mSmallInGameImage == null)
                mSmallInGameImage = getImage(convertSeperator(getInGameImage()), 60,100);
		return mSmallInGameImage;
	}
}
