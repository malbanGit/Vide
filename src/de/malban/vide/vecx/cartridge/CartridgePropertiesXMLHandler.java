package de.malban.vide.vecx.cartridge;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  CartridgePropertiesXMLHandler extends DefaultHandler
{
	private HashMap<String, CartridgeProperties> mCartridgeProperties;
	private CartridgeProperties mCurrentData = null;
	private String mCurrentElement = null;
	private String mCartName = "";
	private String mAuthor = "";
	private String mYear = "";
	private String mCRC = "";
	private String mTypeFlags = "";
	private String mFullFilename = "";
	private Vector<String> mFullFilenames = null;
	private String mInformation = "";
	private String mCheats = "";
	private String mEastereggs = "";
	private String mHomepage = "";
	private String mInstructionFile = "";
	private String mFrontImage = "";
	private String mBackImage = "";
	private String mOverlay = "";
	private String mInGameImage = "";
	private String mCritic = "";
	private String mOther = "";
	private String mBinaryLink = "";
	private String mLicence = "";
	private String mCopyrightType = "";
	private String mPDFLink = "";
	private String mPDFFile = "";
	private String mCartridgeImage = "";
	private String mHomebrew = "";
	private String mDemo = "";
	private String mSnippet = "";
	private String mCompleteGame = "";
	private String mextremeVecFileImage = "";
	private String mWheelName = "";
	private String mConfigOverwrite = "";
	private String mCF_AutoSync = "";
	private String mCF_AllowROMWrite = "";
	private String mCF_ROM_PC_BreakPoints = "";
	private String mCF_IntegratorMaxX = "";
	private String mCF_IntegratorMaxY = "";
	private String mCF_OverlayThreshold = "";
	private String mCF_DotdwellDivisor = "";
	public HashMap<String, CartridgeProperties> getLastHashMap()
	{
		return mCartridgeProperties;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new CartridgeProperties();
		mCartridgeProperties = new HashMap<String, CartridgeProperties>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("CartridgeProperties"))
		{
			mCurrentData = new CartridgeProperties();
			mCartName = "";
			mAuthor = "";
			mYear = "";
			mCRC = "";
			mTypeFlags = "";
			mFullFilename = "";
			mFullFilenames = new Vector<String>();
			mInformation = "";
			mCheats = "";
			mEastereggs = "";
			mHomepage = "";
			mInstructionFile = "";
			mFrontImage = "";
			mBackImage = "";
			mOverlay = "";
			mInGameImage = "";
			mCritic = "";
			mOther = "";
			mBinaryLink = "";
			mLicence = "";
			mCopyrightType = "";
			mPDFLink = "";
			mPDFFile = "";
			mCartridgeImage = "";
			mHomebrew = "";
			mDemo = "";
			mSnippet = "";
			mCompleteGame = "";
			mextremeVecFileImage = "";
			mWheelName = "";
			mConfigOverwrite = "";
			mCF_AutoSync = "";
			mCF_AllowROMWrite = "";
			mCF_ROM_PC_BreakPoints = "";
			mCF_IntegratorMaxX = "";
			mCF_IntegratorMaxY = "";
			mCF_OverlayThreshold = "";
			mCF_DotdwellDivisor = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("CartName")) mCartName += s;
		if (mCurrentElement.equalsIgnoreCase("Author")) mAuthor += s;
		if (mCurrentElement.equalsIgnoreCase("Year")) mYear += s;
		if (mCurrentElement.equalsIgnoreCase("CRC")) mCRC += s;
		if (mCurrentElement.equalsIgnoreCase("TypeFlags")) mTypeFlags += s;
		if (mCurrentElement.equalsIgnoreCase("FullFilename")) mFullFilename += s;
		if (mCurrentElement.equalsIgnoreCase("Information")) mInformation += s;
		if (mCurrentElement.equalsIgnoreCase("Cheats")) mCheats += s;
		if (mCurrentElement.equalsIgnoreCase("Eastereggs")) mEastereggs += s;
		if (mCurrentElement.equalsIgnoreCase("Homepage")) mHomepage += s;
		if (mCurrentElement.equalsIgnoreCase("InstructionFile")) mInstructionFile += s;
		if (mCurrentElement.equalsIgnoreCase("FrontImage")) mFrontImage += s;
		if (mCurrentElement.equalsIgnoreCase("BackImage")) mBackImage += s;
		if (mCurrentElement.equalsIgnoreCase("Overlay")) mOverlay += s;
		if (mCurrentElement.equalsIgnoreCase("InGameImage")) mInGameImage += s;
		if (mCurrentElement.equalsIgnoreCase("Critic")) mCritic += s;
		if (mCurrentElement.equalsIgnoreCase("Other")) mOther += s;
		if (mCurrentElement.equalsIgnoreCase("BinaryLink")) mBinaryLink += s;
		if (mCurrentElement.equalsIgnoreCase("Licence")) mLicence += s;
		if (mCurrentElement.equalsIgnoreCase("CopyrightType")) mCopyrightType += s;
		if (mCurrentElement.equalsIgnoreCase("PDFLink")) mPDFLink += s;
		if (mCurrentElement.equalsIgnoreCase("PDFFile")) mPDFFile += s;
		if (mCurrentElement.equalsIgnoreCase("CartridgeImage")) mCartridgeImage += s;
		if (mCurrentElement.equalsIgnoreCase("Homebrew")) mHomebrew += s;
		if (mCurrentElement.equalsIgnoreCase("Demo")) mDemo += s;
		if (mCurrentElement.equalsIgnoreCase("Snippet")) mSnippet += s;
		if (mCurrentElement.equalsIgnoreCase("CompleteGame")) mCompleteGame += s;
		if (mCurrentElement.equalsIgnoreCase("extremeVecFileImage")) mextremeVecFileImage += s;
		if (mCurrentElement.equalsIgnoreCase("WheelName")) mWheelName += s;
		if (mCurrentElement.equalsIgnoreCase("ConfigOverwrite")) mConfigOverwrite += s;
		if (mCurrentElement.equalsIgnoreCase("CF_AutoSync")) mCF_AutoSync += s;
		if (mCurrentElement.equalsIgnoreCase("CF_AllowROMWrite")) mCF_AllowROMWrite += s;
		if (mCurrentElement.equalsIgnoreCase("CF_ROM_PC_BreakPoints")) mCF_ROM_PC_BreakPoints += s;
		if (mCurrentElement.equalsIgnoreCase("CF_IntegratorMaxX")) mCF_IntegratorMaxX += s;
		if (mCurrentElement.equalsIgnoreCase("CF_IntegratorMaxY")) mCF_IntegratorMaxY += s;
		if (mCurrentElement.equalsIgnoreCase("CF_OverlayThreshold")) mCF_OverlayThreshold += s;
		if (mCurrentElement.equalsIgnoreCase("CF_DotdwellDivisor")) mCF_DotdwellDivisor += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("FullFilename".equalsIgnoreCase(qName))
		{
			mFullFilenames.addElement(mFullFilename);
			mFullFilename="";
		}
		if ("CartridgeProperties".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mCurrentData.mCartName = mCartName;
				mCartName = "";
				mCurrentData.mAuthor = mAuthor;
				mAuthor = "";
				mCurrentData.mYear = mYear;
				mYear = "";
				try{
				mCurrentData.mCRC = Integer.parseInt(mCRC);
				}catch (Throwable e){}
				mCRC = "";
				try{
				mCurrentData.mTypeFlags = Integer.parseInt(mTypeFlags);
				}catch (Throwable e){}
				mTypeFlags = "";
				mFullFilename = "";
				mCurrentData.mFullFilename = mFullFilenames;
				mCurrentData.mInformation = mInformation;
				mInformation = "";
                                
				mCurrentData.mCheats = de.malban.util.UtilityString.fromXML(mCheats);
				mCheats = "";
				//mCurrentData.mEastereggs = mEastereggs;
				mCurrentData.mEastereggs = de.malban.util.UtilityString.fromXML(mEastereggs);
				mEastereggs = "";
				mCurrentData.mHomepage = mHomepage;
				mHomepage = "";
				mCurrentData.mInstructionFile = mInstructionFile;
				mInstructionFile = "";
				mCurrentData.mFrontImage = mFrontImage;
				mFrontImage = "";
				mCurrentData.mBackImage = mBackImage;
				mBackImage = "";
				mCurrentData.mOverlay = mOverlay;
				mOverlay = "";
				mCurrentData.mInGameImage = mInGameImage;
				mInGameImage = "";
//				mCurrentData.mCritic = mCritic;
				mCurrentData.mCritic = de.malban.util.UtilityString.fromXML(mCritic);
				mCritic = "";
				mCurrentData.mOther = mOther;
				mOther = "";
				mCurrentData.mBinaryLink = mBinaryLink;
				mBinaryLink = "";
				mCurrentData.mLicence = mLicence;
				mLicence = "";
				mCurrentData.mCopyrightType = mCopyrightType;
				mCopyrightType = "";
				mCurrentData.mPDFLink = mPDFLink;
				mPDFLink = "";
				mCurrentData.mPDFFile = mPDFFile;
				mPDFFile = "";
				mCurrentData.mCartridgeImage = mCartridgeImage;
				mCartridgeImage = "";
				try{
				mCurrentData.mHomebrew = Boolean.parseBoolean(mHomebrew);
				}catch (Throwable e){}
				mHomebrew = "";
				try{
				mCurrentData.mDemo = Boolean.parseBoolean(mDemo);
				}catch (Throwable e){}
				mDemo = "";
				try{
				mCurrentData.mSnippet = Boolean.parseBoolean(mSnippet);
				}catch (Throwable e){}
				mSnippet = "";
				try{
				mCurrentData.mCompleteGame = Boolean.parseBoolean(mCompleteGame);
				}catch (Throwable e){}
				mCompleteGame = "";
				mCurrentData.mextremeVecFileImage = mextremeVecFileImage;
				mextremeVecFileImage = "";
				mCurrentData.mWheelName = mWheelName;
				mWheelName = "";
				try{
				mCurrentData.mConfigOverwrite = Boolean.parseBoolean(mConfigOverwrite);
				}catch (Throwable e){}
				mConfigOverwrite = "";
				try{
				mCurrentData.mCF_AutoSync = Boolean.parseBoolean(mCF_AutoSync);
				}catch (Throwable e){}
				mCF_AutoSync = "";
				try{
				mCurrentData.mCF_AllowROMWrite = Boolean.parseBoolean(mCF_AllowROMWrite);
				}catch (Throwable e){}
				mCF_AllowROMWrite = "";
				try{
				mCurrentData.mCF_ROM_PC_BreakPoints = Boolean.parseBoolean(mCF_ROM_PC_BreakPoints);
				}catch (Throwable e){}
				mCF_ROM_PC_BreakPoints = "";
				try{
				mCurrentData.mCF_IntegratorMaxX = Integer.parseInt(mCF_IntegratorMaxX);
				}catch (Throwable e){}
				mCF_IntegratorMaxX = "";
				try{
				mCurrentData.mCF_IntegratorMaxY = Integer.parseInt(mCF_IntegratorMaxY);
				}catch (Throwable e){}
				mCF_IntegratorMaxY = "";
				try{
				mCurrentData.mCF_OverlayThreshold = Float.parseFloat(mCF_OverlayThreshold);
				}catch (Throwable e){}
				mCF_OverlayThreshold = "";
				try{
				mCurrentData.mCF_DotdwellDivisor = Integer.parseInt(mCF_DotdwellDivisor);
				}catch (Throwable e){}
				mCF_DotdwellDivisor = "";
				mCartridgeProperties.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
