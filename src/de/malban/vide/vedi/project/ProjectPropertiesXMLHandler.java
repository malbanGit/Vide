package de.malban.vide.vedi.project;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  ProjectPropertiesXMLHandler extends DefaultHandler
{
	private HashMap<String, ProjectProperties> mProjectProperties;
	private ProjectProperties mCurrentData = null;
	private String mCurrentElement = null;
	private String mProjectName = "";
	private String mDirectoryName = "";
	private String mPath = "";
	private String mMainFile = "";
	private String mDescription = "";
	private String mVersion = "";
	private String mAuthor = "";
	private String mBankswitching = "";
	private String mcreateBankswitchCode = "";
	private String mcreateGameLoopCode = "";
	private String mNumberOfBanks = "";
	private String mBankMainFiles = "";
	private Vector<String> mBankMainFiless = null;
	private String mExtras = "";
	private String mProjectPreScriptClass = "";
	private String mProjectPreScriptName = "";
	private String mProjectPostScriptClass = "";
	private String mProjectPostScriptName = "";
	private String mBankDefines = "";
	private Vector<String> mBankDefiness = null;
	private String mWheelName = "";
	private String mIsPeerCProject = "";
	private String mCDebugging = "";
	private String mCPeephole = "";
	private String mCKeepEnriched = "";
	private String mIsCProject = "";
	private String mCFLAGS = "";
        
        
        
	public HashMap<String, ProjectProperties> getLastHashMap()
	{
		return mProjectProperties;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new ProjectProperties();
		mProjectProperties = new HashMap<String, ProjectProperties>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("ProjectProperties"))
		{
			mCurrentData = new ProjectProperties();
			mProjectName = "";
			mDirectoryName = "";
			mPath = "";
			mMainFile = "";
			mDescription = "";
			mVersion = "";
			mAuthor = "";
			mBankswitching = "";
			mcreateBankswitchCode = "";
			mcreateGameLoopCode = "";
			mNumberOfBanks = "";
			mBankMainFiles = "";
			mBankMainFiless = new Vector<String>();
			mExtras = "";
			mProjectPreScriptClass = "";
			mProjectPreScriptName = "";
			mProjectPostScriptClass = "";
			mProjectPostScriptName = "";
			mBankDefines = "";
			mBankDefiness = new Vector<String>();
			mWheelName = "";
			mCDebugging = "";
			mCPeephole = "";
			mCKeepEnriched = "";
			mIsPeerCProject = "";
			mIsCProject = "";
			mCFLAGS = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("ProjectName")) mProjectName += s;
		if (mCurrentElement.equalsIgnoreCase("DirectoryName")) mDirectoryName += s;
		if (mCurrentElement.equalsIgnoreCase("Path")) mPath += s;
		if (mCurrentElement.equalsIgnoreCase("MainFile")) mMainFile += s;
		if (mCurrentElement.equalsIgnoreCase("Description")) mDescription += s;
		if (mCurrentElement.equalsIgnoreCase("Version")) mVersion += s;
		if (mCurrentElement.equalsIgnoreCase("Author")) mAuthor += s;
		if (mCurrentElement.equalsIgnoreCase("Bankswitching")) mBankswitching += s;
		if (mCurrentElement.equalsIgnoreCase("createBankswitchCode")) mcreateBankswitchCode += s;
		if (mCurrentElement.equalsIgnoreCase("createGameLoopCode")) mcreateGameLoopCode += s;
		if (mCurrentElement.equalsIgnoreCase("NumberOfBanks")) mNumberOfBanks += s;
		if (mCurrentElement.equalsIgnoreCase("BankMainFiles")) mBankMainFiles += s;
		if (mCurrentElement.equalsIgnoreCase("Extras")) mExtras += s;
		if (mCurrentElement.equalsIgnoreCase("ProjectPreScriptClass")) mProjectPreScriptClass += s;
		if (mCurrentElement.equalsIgnoreCase("ProjectPreScriptName")) mProjectPreScriptName += s;
		if (mCurrentElement.equalsIgnoreCase("ProjectPostScriptClass")) mProjectPostScriptClass += s;
		if (mCurrentElement.equalsIgnoreCase("ProjectPostScriptName")) mProjectPostScriptName += s;
		if (mCurrentElement.equalsIgnoreCase("BankDefines")) mBankDefines += s;
		if (mCurrentElement.equalsIgnoreCase("WheelName")) mWheelName += s;
		if (mCurrentElement.equalsIgnoreCase("IsPeerCProject")) mIsPeerCProject += s;
		if (mCurrentElement.equalsIgnoreCase("IsCProject")) mIsCProject += s;
		if (mCurrentElement.equalsIgnoreCase("CFLAGS")) mCFLAGS += s;
		if (mCurrentElement.equalsIgnoreCase("IsCDebugging")) mCDebugging += s;
		if (mCurrentElement.equalsIgnoreCase("IsCPeephole")) mCPeephole += s;
		if (mCurrentElement.equalsIgnoreCase("IsCKeepEnriched")) mCKeepEnriched += s;
                
                


        }
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("BankMainFiles".equalsIgnoreCase(qName))
		{
			mBankMainFiless.addElement(mBankMainFiles);
			mBankMainFiles="";
		}
		if ("BankDefines".equalsIgnoreCase(qName))
		{
			mBankDefiness.addElement(mBankDefines);
			mBankDefines="";
		}
		if ("ProjectProperties".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				mCurrentData.mProjectName = mProjectName;
				mProjectName = "";
				mCurrentData.mDirectoryName = mDirectoryName;
				mDirectoryName = "";
				mCurrentData.mPath = mPath;
				mPath = "";
				mCurrentData.mMainFile = mMainFile;
				mMainFile = "";
				mCurrentData.mDescription = mDescription;
				mDescription = "";
				mCurrentData.mVersion = mVersion;
				mVersion = "";
				mCurrentData.mAuthor = mAuthor;
				mAuthor = "";
				mCurrentData.mBankswitching = mBankswitching;
				mBankswitching = "";
				try{
				mCurrentData.mcreateBankswitchCode = Boolean.parseBoolean(mcreateBankswitchCode);
				}catch (Throwable e){}
				mcreateBankswitchCode = "";
				try{
				mCurrentData.mcreateGameLoopCode = Boolean.parseBoolean(mcreateGameLoopCode);
				}catch (Throwable e){}
				mcreateGameLoopCode = "";
				try{
				mCurrentData.mNumberOfBanks = Integer.parseInt(mNumberOfBanks);
				}catch (Throwable e){}
				mNumberOfBanks = "";
				mBankMainFiles = "";
				mCurrentData.mBankMainFiles = mBankMainFiless;
				try{
				mCurrentData.mExtras = Integer.parseInt(mExtras);
				}catch (Throwable e){}
				mExtras = "";
				mCurrentData.mProjectPreScriptClass = mProjectPreScriptClass;
				mProjectPreScriptClass = "";
				mCurrentData.mProjectPreScriptName = mProjectPreScriptName;
				mProjectPreScriptName = "";
				mCurrentData.mProjectPostScriptClass = mProjectPostScriptClass;
				mProjectPostScriptClass = "";
				mCurrentData.mProjectPostScriptName = mProjectPostScriptName;
				mProjectPostScriptName = "";
				mBankDefines = "";
				mCurrentData.mBankDefines = mBankDefiness;
				mCurrentData.mWheelName = mWheelName;
				mWheelName = "";
				try{
				mCurrentData.mIsCProject = Boolean.parseBoolean(mIsCProject);
				}catch (Throwable e){}
				try{
				mCurrentData.mIsPeerCProject = Boolean.parseBoolean(mIsPeerCProject);
				}catch (Throwable e){}
				try{
				mCurrentData.mCDebugging = Boolean.parseBoolean(mCDebugging);
				}catch (Throwable e){}
                                
				try{
				mCurrentData.mCPeephole = Boolean.parseBoolean(mCPeephole);
				}catch (Throwable e){}
                                
				try{
				mCurrentData.mCKeepEnriched = Boolean.parseBoolean(mCKeepEnriched);
				}catch (Throwable e){}
                                
                                
				mIsPeerCProject = "";
				mIsCProject = "";
				mCurrentData.mCFLAGS = mCFLAGS;
				mCFLAGS = "";
				mProjectProperties.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
