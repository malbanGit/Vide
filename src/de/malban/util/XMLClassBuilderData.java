package de.malban.util;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  XMLClassBuilderData
{
	protected String mClass="";
	protected String mName="";
	protected String mPackageName="";
	protected String mClassName="";
	protected Vector<String> mFieldname=new Vector<String>();
	protected Vector<String> mXMLName=new Vector<String>();
	protected Vector<String> mType=new Vector<String>();
	public String getPackageName()
	{
		return mPackageName;
	}
	public void setPackageName(String PackageName)
	{
		mPackageName=PackageName;
	}
	public String getClassName()
	{
		return mClassName;
	}
	public void setClassName(String ClassName)
	{
		mClassName=ClassName;
	}
	public Vector<String> getFieldname()
	{
		return mFieldname;
	}
	public void setFieldname(Vector<String> Fieldname)
	{
		mFieldname=Fieldname;
	}
	public Vector<String> getXMLName()
	{
		return mXMLName;
	}
	public void setXMLName(Vector<String> XMLName)
	{
		mXMLName=XMLName;
	}
	public Vector<String> getType()
	{
		return mType;
	}
	public void setType(Vector<String> Type)
	{
		mType=Type;
	}
	private String exportXML()
	{
		String s = new String();
		s += "\t<XMLClassBuilderData>\n";
		s += "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n";
		s += "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n";
		s += "\t\t<PACKAGENAME>"+UtilityString.toXML(mPackageName)+"</PACKAGENAME>\n";
		s += "\t\t<CLASSNAME>"+UtilityString.toXML(mClassName)+"</CLASSNAME>\n";
		s += "\t\t<FIELDNAMEs>";
		for (int i=0;i<mFieldname.size(); i++)
		{
			s += "\t\t<FIELDNAME>"+UtilityString.toXML(mFieldname.elementAt(i))+"</FIELDNAME>\n";
		}
		s += "\t\t</FIELDNAMEs>";
		s += "\t\t<XMLNAMEs>";
		for (int i=0;i<mXMLName.size(); i++)
		{
			s += "\t\t<XMLNAME>"+UtilityString.toXML(mXMLName.elementAt(i))+"</XMLNAME>\n";
		}
		s += "\t\t</XMLNAMEs>";
		s += "\t\t<TYPEs>";
		for (int i=0;i<mType.size(); i++)
		{
			s += "\t\t<TYPE>"+UtilityString.toXML(mType.elementAt(i))+"</TYPE>\n";
		}
		s += "\t\t</TYPEs>";
		s += "\t</XMLClassBuilderData>\n";
		return s;
	}
	@Override public String toString()
	{
		return mName;
	}
	private static XMLClassBuilderDataXMLHandler XMLHANDLER = new XMLClassBuilderDataXMLHandler();
	public static XMLClassBuilderDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<XMLClassBuilderData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(de.malban.Global.mBaseDir+filename);
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllXMLClassBuilderData>\n");
			Iterator<XMLClassBuilderData> iter = col.iterator();
			while (iter.hasNext())
			{
				XMLClassBuilderData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllXMLClassBuilderData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, XMLClassBuilderData> getHashMapFromXML(String filename)
	{
		HashMap<String, XMLClassBuilderData> filters = new HashMap<String, XMLClassBuilderData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			XMLClassBuilderDataXMLHandler h = XMLClassBuilderData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"XMLClassBuilderData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
