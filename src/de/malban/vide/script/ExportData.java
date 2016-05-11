package de.malban.vide.script;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  ExportData
{
	protected String mClass="";
	public String mName="";
	protected String mComment="";
	protected String mScript="";
	public String getComment()
	{
		return mComment;
	}
	public void setComment(String Comment)
	{
		mComment=Comment;
	}
	public String getScript()
	{
		return mScript;
	}
	public void setScript(String Script)
	{
		mScript=Script;
	}
	private String exportXML()
	{
		String s = new String();
		s += "\t<ExportData>\n";
		s += "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n";
		s += "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n";
		s += "\t\t<Comment>"+UtilityString.toXML(mComment)+"</Comment>\n";
		s += "\t\t<Script>"+UtilityString.toXML(mScript)+"</Script>\n";
		s += "\t</ExportData>\n";
		return s;
	}
	@Override public String toString()
	{
		return mName;
	}
	private static ExportDataXMLHandler XMLHANDLER = new ExportDataXMLHandler();
	public static ExportDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<ExportData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(de.malban.Global.mBaseDir+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllExportData>\n");
			Iterator<ExportData> iter = col.iterator();
			while (iter.hasNext())
			{
				ExportData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllExportData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, ExportData> getHashMapFromXML(String filename)
	{
		HashMap<String, ExportData> filters = new HashMap<String, ExportData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			ExportDataXMLHandler h = ExportData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"ExportData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
