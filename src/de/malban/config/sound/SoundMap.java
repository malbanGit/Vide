package de.malban.config.sound;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  SoundMap
{
	protected String mClass="";
	public String mName="";
	protected Vector<String> mSoundFile=new Vector<String>();
	protected Vector<String> mColor=new Vector<String>();
	protected Vector<String> mType=new Vector<String>();
	protected Vector<String> mSubtype=new Vector<String>();
	protected Vector<String> mID=new Vector<String>();
	protected Vector<String> mEvent=new Vector<String>();
	public Vector<String> getSoundFile()
	{
		return mSoundFile;
	}
	public void setSoundFile(Vector<String> SoundFile)
	{
		mSoundFile=SoundFile;
	}
	public Vector<String> getColor()
	{
		return mColor;
	}
	public void setColor(Vector<String> Color)
	{
		mColor=Color;
	}
	public Vector<String> getType()
	{
		return mType;
	}
	public void setType(Vector<String> Type)
	{
		mType=Type;
	}
	public Vector<String> getSubtype()
	{
		return mSubtype;
	}
	public void setSubtype(Vector<String> Subtype)
	{
		mSubtype=Subtype;
	}
	public Vector<String> getID()
	{
		return mID;
	}
	public void setID(Vector<String> ID)
	{
		mID=ID;
	}
	public Vector<String> getEvent()
	{
		return mEvent;
	}
	public void setEvent(Vector<String> Event)
	{
		mEvent=Event;
	}
	private String exportXML()
	{
		String s = new String();
		s += "\t<SoundMap>\n";
		s += "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n";
		s += "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n";
		s += "\t\t<SOUNDFILEs>\n";
		for (int i=0;i<mSoundFile.size(); i++)
		{
			s += "\t\t\t<SOUNDFILE>"+UtilityString.toXML(mSoundFile.elementAt(i))+"</SOUNDFILE>\n";
		}
		s += "\t\t</SOUNDFILEs>\n";
		s += "\t\t<COLORs>\n";
		for (int i=0;i<mColor.size(); i++)
		{
			s += "\t\t\t<COLOR>"+UtilityString.toXML(mColor.elementAt(i))+"</COLOR>\n";
		}
		s += "\t\t</COLORs>\n";
		s += "\t\t<TYPEs>\n";
		for (int i=0;i<mType.size(); i++)
		{
			s += "\t\t\t<TYPE>"+UtilityString.toXML(mType.elementAt(i))+"</TYPE>\n";
		}
		s += "\t\t</TYPEs>\n";
		s += "\t\t<SUBTYPEs>\n";
		for (int i=0;i<mSubtype.size(); i++)
		{
			s += "\t\t\t<SUBTYPE>"+UtilityString.toXML(mSubtype.elementAt(i))+"</SUBTYPE>\n";
		}
		s += "\t\t</SUBTYPEs>\n";
		s += "\t\t<IDs>\n";
		for (int i=0;i<mID.size(); i++)
		{
			s += "\t\t\t<ID>"+UtilityString.toXML(mID.elementAt(i))+"</ID>\n";
		}
		s += "\t\t</IDs>\n";
		s += "\t\t<EVENTs>\n";
		for (int i=0;i<mEvent.size(); i++)
		{
			s += "\t\t\t<EVENT>"+UtilityString.toXML(mEvent.elementAt(i))+"</EVENT>\n";
		}
		s += "\t\t</EVENTs>\n";
		s += "\t</SoundMap>\n";
		return s;
	}
	@Override public String toString()
	{
		return mName;
	}
	private static SoundMapXMLHandler XMLHANDLER = new SoundMapXMLHandler();
	public static SoundMapXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<SoundMap> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(de.malban.Global.mBaseDir+filename);
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllSoundMap>\n");
			Iterator<SoundMap> iter = col.iterator();
			while (iter.hasNext())
			{
				SoundMap item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllSoundMap>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, SoundMap> getHashMapFromXML(String filename)
	{
		HashMap<String, SoundMap> filters = new HashMap<String, SoundMap>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			SoundMapXMLHandler h = SoundMap.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			
			JOptionPane.showMessageDialog(null, e.toString() ,"SoundMap Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
