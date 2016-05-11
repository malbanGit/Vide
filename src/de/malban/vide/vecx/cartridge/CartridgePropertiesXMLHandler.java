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
				mCurrentData.mCheats = mCheats;
				mCheats = "";
				mCurrentData.mEastereggs = mEastereggs;
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
				mCurrentData.mCritic = mCritic;
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
				mCartridgeProperties.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
