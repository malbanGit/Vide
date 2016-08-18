package de.malban.vide.vedi.project;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  ProjectProperties
{
	protected String mClass="";
	public String mName="";
	protected String mProjectName="";
	protected String mDirectoryName="";
	protected String mPath="";
	protected String mMainFile="";
	protected String mDescription="";
	protected String mVersion="";
	protected String mAuthor="";
	protected String mBankswitching="";
	protected boolean mcreateBankswitchCode=false;
	protected boolean mcreateGameLoopCode=false;
	protected int mNumberOfBanks=0;
	protected Vector<String> mBankMainFiles=new Vector<String>();
	protected int mExtras=0;
	protected String mProjectPreScriptClass="";
	protected String mProjectPreScriptName="";
	protected String mProjectPostScriptClass="";
	protected String mProjectPostScriptName="";
	protected Vector<String> mBankDefines=new Vector<String>();
	protected String mWheelName="";
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
	public String getProjectName()
	{
		return mProjectName;
	}
	public void setProjectName(String ProjectName)
	{
		mProjectName=ProjectName;
	}
	public String getDirectoryName()
	{
		return mDirectoryName;
	}
	public void setDirectoryName(String DirectoryName)
	{
		mDirectoryName=DirectoryName;
	}
	public String getPath()
	{
		return mPath;
	}
	public void setPath(String Path)
	{
		mPath=Path;
	}
	public String getMainFile()
	{
		return mMainFile;
	}
	public void setMainFile(String MainFile)
	{
		mMainFile=MainFile;
	}
	public String getDescription()
	{
		return mDescription;
	}
	public void setDescription(String Description)
	{
		mDescription=Description;
	}
	public String getVersion()
	{
		return mVersion;
	}
	public void setVersion(String Version)
	{
		mVersion=Version;
	}
	public String getAuthor()
	{
		return mAuthor;
	}
	public void setAuthor(String Author)
	{
		mAuthor=Author;
	}
	public String getBankswitching()
	{
		return mBankswitching;
	}
	public void setBankswitching(String Bankswitching)
	{
		mBankswitching=Bankswitching;
	}
	public boolean getcreateBankswitchCode()
	{
		return mcreateBankswitchCode;
	}
	public void setcreateBankswitchCode(boolean createBankswitchCode)
	{
		mcreateBankswitchCode=createBankswitchCode;
	}
	public boolean getcreateGameLoopCode()
	{
		return mcreateGameLoopCode;
	}
	public void setcreateGameLoopCode(boolean createGameLoopCode)
	{
		mcreateGameLoopCode=createGameLoopCode;
	}
	public int getNumberOfBanks()
	{
		return mNumberOfBanks;
	}
	public void setNumberOfBanks(int NumberOfBanks)
	{
		mNumberOfBanks=NumberOfBanks;
	}
	public Vector<String> getBankMainFiles()
	{
		return mBankMainFiles;
	}
	public void setBankMainFiles(Vector<String> BankMainFiles)
	{
		mBankMainFiles=BankMainFiles;
	}
	public int getExtras()
	{
		return mExtras;
	}
	public void setExtras(int Extras)
	{
		mExtras=Extras;
	}
	public String getProjectPreScriptClass()
	{
		return mProjectPreScriptClass;
	}
	public void setProjectPreScriptClass(String ProjectPreScriptClass)
	{
		mProjectPreScriptClass=ProjectPreScriptClass;
	}
	public String getProjectPreScriptName()
	{
		return mProjectPreScriptName;
	}
	public void setProjectPreScriptName(String ProjectPreScriptName)
	{
		mProjectPreScriptName=ProjectPreScriptName;
	}
	public String getProjectPostScriptClass()
	{
		return mProjectPostScriptClass;
	}
	public void setProjectPostScriptClass(String ProjectPostScriptClass)
	{
		mProjectPostScriptClass=ProjectPostScriptClass;
	}
	public String getProjectPostScriptName()
	{
		return mProjectPostScriptName;
	}
	public void setProjectPostScriptName(String ProjectPostScriptName)
	{
		mProjectPostScriptName=ProjectPostScriptName;
	}
	public Vector<String> getBankDefines()
	{
		return mBankDefines;
	}
	public void setBankDefines(Vector<String> BankDefines)
	{
		mBankDefines=BankDefines;
	}
	public String getWheelName()
	{
		return mWheelName;
	}
	public void setWheelName(String WheelName)
	{
		mWheelName=WheelName;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<ProjectProperties>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<ProjectName>"+UtilityString.toXML(mProjectName)+"</ProjectName>\n");
		s.append( "\t\t<DirectoryName>"+UtilityString.toXML(mDirectoryName)+"</DirectoryName>\n");
		s.append( "\t\t<Path>"+UtilityString.toXML(mPath)+"</Path>\n");
		s.append( "\t\t<MainFile>"+UtilityString.toXML(mMainFile)+"</MainFile>\n");
		s.append( "\t\t<Description>"+UtilityString.toXML(mDescription)+"</Description>\n");
		s.append( "\t\t<Version>"+UtilityString.toXML(mVersion)+"</Version>\n");
		s.append( "\t\t<Author>"+UtilityString.toXML(mAuthor)+"</Author>\n");
		s.append( "\t\t<Bankswitching>"+UtilityString.toXML(mBankswitching)+"</Bankswitching>\n");
		s.append( "\t\t<createBankswitchCode>"+mcreateBankswitchCode+"</createBankswitchCode>\n");
		s.append( "\t\t<createGameLoopCode>"+mcreateGameLoopCode+"</createGameLoopCode>\n");
		s.append( "\t\t<NumberOfBanks>"+mNumberOfBanks+"</NumberOfBanks>\n");
		s.append( "\t\t<BankMainFiless>\n");
		for (int i=0;i<mBankMainFiles.size(); i++)
		{
			s.append( "\t\t\t<BankMainFiles>"+UtilityString.toXML(mBankMainFiles.elementAt(i))+"</BankMainFiles>\n");
		}
		s.append( "\t\t</BankMainFiless>\n");
		s.append( "\t\t<Extras>"+mExtras+"</Extras>\n");
		s.append( "\t\t<ProjectPreScriptClass>"+UtilityString.toXML(mProjectPreScriptClass)+"</ProjectPreScriptClass>\n");
		s.append( "\t\t<ProjectPreScriptName>"+UtilityString.toXML(mProjectPreScriptName)+"</ProjectPreScriptName>\n");
		s.append( "\t\t<ProjectPostScriptClass>"+UtilityString.toXML(mProjectPostScriptClass)+"</ProjectPostScriptClass>\n");
		s.append( "\t\t<ProjectPostScriptName>"+UtilityString.toXML(mProjectPostScriptName)+"</ProjectPostScriptName>\n");
		s.append( "\t\t<BankDefiness>\n");
		for (int i=0;i<mBankDefines.size(); i++)
		{
			s.append( "\t\t\t<BankDefines>"+UtilityString.toXML(mBankDefines.elementAt(i))+"</BankDefines>\n");
		}
		s.append( "\t\t</BankDefiness>\n");
		s.append( "\t\t<WheelName>"+UtilityString.toXML(mWheelName)+"</WheelName>\n");
		s.append( "\t</ProjectProperties>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static ProjectPropertiesXMLHandler XMLHANDLER = new ProjectPropertiesXMLHandler();
	public static ProjectPropertiesXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<ProjectProperties> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<ProjectProperties> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllProjectProperties>\n");
			Iterator<ProjectProperties> iter = col.iterator();
			while (iter.hasNext())
			{
				ProjectProperties item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllProjectProperties>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
        public static HashMap<String, ProjectProperties> getHashMapFromXML(String filename)
	{
            return getHashMapFromXML( filename, de.malban.Global.mBaseDir);
	}
	public static HashMap<String, ProjectProperties> getHashMapFromXML(String filename, String path)
	{
		HashMap<String, ProjectProperties> filters = new HashMap<String, ProjectProperties>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			ProjectPropertiesXMLHandler h = ProjectProperties.getXMLParseHandler();
			saxParser.parse(path+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"ProjectProperties Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
