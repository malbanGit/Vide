package de.malban.vide.vedi.project;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  FilePropertiesXMLHandler extends DefaultHandler
{
	private HashMap<String, FileProperties> mFileProperties;
	private FileProperties mCurrentData = null;
	private String mCurrentElement = null;
	private String mFilename = "";
	private String mTyp = "";
	private String mActionScript = "";
	private String mPreScriptName = "";
	private String mPreScriptClass = "";
	private String mFlags = "";
	private String mDescription = "";
	private String mVersion = "";
	private String mParemeter1 = "";
	private String mParemeter2 = "";
	private String mParemeter3 = "";
	private String mPostScriptName = "";
	private String mPostScriptClass = "";
	private String mActionScriptName = "";
	private String mActionScriptClass = "";
	private String mNoInternalProcessing = "";
	public HashMap<String, FileProperties> getLastHashMap()
	{
		return mFileProperties;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new FileProperties();
		mFileProperties = new HashMap<String, FileProperties>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("FileProperties"))
		{
			mCurrentData = new FileProperties();
			mFilename = "";
			mTyp = "";
			mActionScript = "";
			mPreScriptName = "";
			mPreScriptClass = "";
			mFlags = "";
			mDescription = "";
			mVersion = "";
			mParemeter1 = "";
			mParemeter2 = "";
			mParemeter3 = "";
			mPostScriptName = "";
			mPostScriptClass = "";
			mActionScriptName = "";
			mActionScriptClass = "";
			mNoInternalProcessing = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("Filename")) mFilename += s;
		if (mCurrentElement.equalsIgnoreCase("Typ")) mTyp += s;
		if (mCurrentElement.equalsIgnoreCase("ActionScript")) mActionScript += s;
		if (mCurrentElement.equalsIgnoreCase("PreScriptName")) mPreScriptName += s;
		if (mCurrentElement.equalsIgnoreCase("PreScriptClass")) mPreScriptClass += s;
		if (mCurrentElement.equalsIgnoreCase("Flags")) mFlags += s;
		if (mCurrentElement.equalsIgnoreCase("Description")) mDescription += s;
		if (mCurrentElement.equalsIgnoreCase("Version")) mVersion += s;
		if (mCurrentElement.equalsIgnoreCase("Paremeter1")) mParemeter1 += s;
		if (mCurrentElement.equalsIgnoreCase("Paremeter2")) mParemeter2 += s;
		if (mCurrentElement.equalsIgnoreCase("Paremeter3")) mParemeter3 += s;
		if (mCurrentElement.equalsIgnoreCase("PostScriptName")) mPostScriptName += s;
		if (mCurrentElement.equalsIgnoreCase("PostScriptClass")) mPostScriptClass += s;
		if (mCurrentElement.equalsIgnoreCase("ActionScriptName")) mActionScriptName += s;
		if (mCurrentElement.equalsIgnoreCase("ActionScriptClass")) mActionScriptClass += s;
		if (mCurrentElement.equalsIgnoreCase("NoInternalProcessing")) mNoInternalProcessing += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("FileProperties".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mCurrentData.mFilename = mFilename;
				mFilename = "";
				mCurrentData.mTyp = mTyp;
				mTyp = "";
				mCurrentData.mActionScript = mActionScript;
				mActionScript = "";
				mCurrentData.mPreScriptName = mPreScriptName;
				mPreScriptName = "";
				mCurrentData.mPreScriptClass = mPreScriptClass;
				mPreScriptClass = "";
				mCurrentData.mFlags = mFlags;
				mFlags = "";
				mCurrentData.mDescription = mDescription;
				mDescription = "";
				mCurrentData.mVersion = mVersion;
				mVersion = "";
				mCurrentData.mParemeter1 = mParemeter1;
				mParemeter1 = "";
				mCurrentData.mParemeter2 = mParemeter2;
				mParemeter2 = "";
				mCurrentData.mParemeter3 = mParemeter3;
				mParemeter3 = "";
				mCurrentData.mPostScriptName = mPostScriptName;
				mPostScriptName = "";
				mCurrentData.mPostScriptClass = mPostScriptClass;
				mPostScriptClass = "";
				mCurrentData.mActionScriptName = mActionScriptName;
				mActionScriptName = "";
				mCurrentData.mActionScriptClass = mActionScriptClass;
				mActionScriptClass = "";
				try{
				mCurrentData.mNoInternalProcessing = Boolean.parseBoolean(mNoInternalProcessing);
				}catch (Throwable e){}
				mNoInternalProcessing = "";
				mFileProperties.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
