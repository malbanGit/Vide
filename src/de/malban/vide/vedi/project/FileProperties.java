package de.malban.vide.vedi.project;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  FileProperties
{
	protected String mClass="";
	public String mName="";
	protected String mFilename="";
	protected String mTyp="";
	protected String mActionScript="";
	protected String mPreScriptName="";
	protected String mPreScriptClass="";
	protected String mFlags="";
	protected String mDescription="";
	protected String mVersion="";
	protected String mParemeter1="";
	protected String mParemeter2="";
	protected String mParemeter3="";
	protected String mPostScriptName="";
	protected String mPostScriptClass="";
	protected String mActionScriptName="";
	protected String mActionScriptClass="";
	protected boolean mNoInternalProcessing=false;
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
	public String getFilename()
	{
		return mFilename;
	}
	public void setFilename(String Filename)
	{
		mFilename=Filename;
	}
	public String getTyp()
	{
		return mTyp;
	}
	public void setTyp(String Typ)
	{
		mTyp=Typ;
	}
	public String getActionScript()
	{
		return mActionScript;
	}
	public void setActionScript(String ActionScript)
	{
		mActionScript=ActionScript;
	}
	public String getPreScriptName()
	{
		return mPreScriptName;
	}
	public void setPreScriptName(String PreScriptName)
	{
		mPreScriptName=PreScriptName;
	}
	public String getPreScriptClass()
	{
		return mPreScriptClass;
	}
	public void setPreScriptClass(String PreScriptClass)
	{
		mPreScriptClass=PreScriptClass;
	}
	public String getFlags()
	{
		return mFlags;
	}
	public void setFlags(String Flags)
	{
		mFlags=Flags;
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
	public String getParemeter1()
	{
		return mParemeter1;
	}
	public void setParemeter1(String Paremeter1)
	{
		mParemeter1=Paremeter1;
	}
	public String getParemeter2()
	{
		return mParemeter2;
	}
	public void setParemeter2(String Paremeter2)
	{
		mParemeter2=Paremeter2;
	}
	public String getParemeter3()
	{
		return mParemeter3;
	}
	public void setParemeter3(String Paremeter3)
	{
		mParemeter3=Paremeter3;
	}
	public String getPostScriptName()
	{
		return mPostScriptName;
	}
	public void setPostScriptName(String PostScriptName)
	{
		mPostScriptName=PostScriptName;
	}
	public String getPostScriptClass()
	{
		return mPostScriptClass;
	}
	public void setPostScriptClass(String PostScriptClass)
	{
		mPostScriptClass=PostScriptClass;
	}
	public String getActionScriptName()
	{
		return mActionScriptName;
	}
	public void setActionScriptName(String ActionScriptName)
	{
		mActionScriptName=ActionScriptName;
	}
	public String getActionScriptClass()
	{
		return mActionScriptClass;
	}
	public void setActionScriptClass(String ActionScriptClass)
	{
		mActionScriptClass=ActionScriptClass;
	}
	public boolean getNoInternalProcessing()
	{
		return mNoInternalProcessing;
	}
	public void setNoInternalProcessing(boolean NoInternalProcessing)
	{
		mNoInternalProcessing=NoInternalProcessing;
	}
	private String exportXML()
	{
		StringBuffer s = new StringBuffer();
		s.append( "\t<FileProperties>\n");
		s.append( "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n");
		s.append( "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n");
		s.append( "\t\t<Filename>"+UtilityString.toXML(mFilename)+"</Filename>\n");
		s.append( "\t\t<Typ>"+UtilityString.toXML(mTyp)+"</Typ>\n");
		s.append( "\t\t<ActionScript>"+UtilityString.toXML(mActionScript)+"</ActionScript>\n");
		s.append( "\t\t<PreScriptName>"+UtilityString.toXML(mPreScriptName)+"</PreScriptName>\n");
		s.append( "\t\t<PreScriptClass>"+UtilityString.toXML(mPreScriptClass)+"</PreScriptClass>\n");
		s.append( "\t\t<Flags>"+UtilityString.toXML(mFlags)+"</Flags>\n");
		s.append( "\t\t<Description>"+UtilityString.toXML(mDescription)+"</Description>\n");
		s.append( "\t\t<Version>"+UtilityString.toXML(mVersion)+"</Version>\n");
		s.append( "\t\t<Paremeter1>"+UtilityString.toXML(mParemeter1)+"</Paremeter1>\n");
		s.append( "\t\t<Paremeter2>"+UtilityString.toXML(mParemeter2)+"</Paremeter2>\n");
		s.append( "\t\t<Paremeter3>"+UtilityString.toXML(mParemeter3)+"</Paremeter3>\n");
		s.append( "\t\t<PostScriptName>"+UtilityString.toXML(mPostScriptName)+"</PostScriptName>\n");
		s.append( "\t\t<PostScriptClass>"+UtilityString.toXML(mPostScriptClass)+"</PostScriptClass>\n");
		s.append( "\t\t<ActionScriptName>"+UtilityString.toXML(mActionScriptName)+"</ActionScriptName>\n");
		s.append( "\t\t<ActionScriptClass>"+UtilityString.toXML(mActionScriptClass)+"</ActionScriptClass>\n");
		s.append( "\t\t<NoInternalProcessing>"+mNoInternalProcessing+"</NoInternalProcessing>\n");
		s.append( "\t</FileProperties>\n");
		return s.toString();
	}
	@Override public String toString()
	{
		return mName;
	}
	private static FilePropertiesXMLHandler XMLHANDLER = new FilePropertiesXMLHandler();
	public static FilePropertiesXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<FileProperties> col)
	{
	return saveCollectionAsXML(de.malban.Global.mBaseDir,  filename, col);
	}
	public static boolean saveCollectionAsXML(String pathName, String filename, Collection<FileProperties> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(pathName+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllFileProperties>\n");
			Iterator<FileProperties> iter = col.iterator();
			while (iter.hasNext())
			{
				FileProperties item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllFileProperties>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
        public static HashMap<String, FileProperties> getHashMapFromXML(String filename)
	{
            return getHashMapFromXML( filename, de.malban.Global.mBaseDir);
	}
	public static HashMap<String, FileProperties> getHashMapFromXML(String filename, String path)
	{
		HashMap<String, FileProperties> filters = new HashMap<String, FileProperties>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			FilePropertiesXMLHandler h = FileProperties.getXMLParseHandler();
			saxParser.parse(path+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"FileProperties Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
