package de.malban.gui.components;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  TableStateData
{
	protected String mClass="";
	protected String mName="";
	protected Vector<Boolean> mColumnEnabled=new Vector<Boolean>();
	protected Vector<Integer> mColumnOrgNo=new Vector<Integer>();
	protected Vector<Integer> mColumnViewNo=new Vector<Integer>();
	protected Vector<Integer> mColumnWidth=new Vector<Integer>();
	protected Vector<String> mColumnName=new Vector<String>();
	protected String munused="";
	public Vector<Boolean> getColumnEnabled()
	{
		return mColumnEnabled;
	}
	public void setColumnEnabled(Vector<Boolean> ColumnEnabled)
	{
		mColumnEnabled=ColumnEnabled;
	}
	public Vector<Integer> getColumnOrgNo()
	{
		return mColumnOrgNo;
	}
	public void setColumnOrgNo(Vector<Integer> ColumnOrgNo)
	{
		mColumnOrgNo=ColumnOrgNo;
	}
	public Vector<Integer> getColumnViewNo()
	{
		return mColumnViewNo;
	}
	public void setColumnViewNo(Vector<Integer> ColumnViewNo)
	{
		mColumnViewNo=ColumnViewNo;
	}
	public Vector<Integer> getColumnWidth()
	{
		return mColumnWidth;
	}
	public void setColumnWidth(Vector<Integer> ColumnWidth)
	{
		mColumnWidth=ColumnWidth;
	}
	public Vector<String> getColumnName()
	{
		return mColumnName;
	}
	public void setColumnName(Vector<String> ColumnName)
	{
		mColumnName=ColumnName;
	}
	public String getunused()
	{
		return munused;
	}
	public void setunused(String unused)
	{
		munused=unused;
	}
	private String exportXML()
	{
		String s = new String();
		s += "\t<TableStateData>\n";
		s += "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n";
		s += "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n";
		s += "\t\t<COLUMNENABLEDs>\n";
		for (int i=0;i<mColumnEnabled.size(); i++)
		{
			s += "\t\t\t<COLUMNENABLED>"+mColumnEnabled.elementAt(i)+"</COLUMNENABLED>\n";
		}
		s += "\t\t</COLUMNENABLEDs>\n";
		s += "\t\t<COLUMNORGNOs>\n";
		for (int i=0;i<mColumnOrgNo.size(); i++)
		{
			s += "\t\t\t<COLUMNORGNO>"+mColumnOrgNo.elementAt(i)+"</COLUMNORGNO>\n";
		}
		s += "\t\t</COLUMNORGNOs>\n";
		s += "\t\t<COLUMNVIEWNOs>\n";
		for (int i=0;i<mColumnViewNo.size(); i++)
		{
			s += "\t\t\t<COLUMNVIEWNO>"+mColumnViewNo.elementAt(i)+"</COLUMNVIEWNO>\n";
		}
		s += "\t\t</COLUMNVIEWNOs>\n";
		s += "\t\t<COLUMNWIDTHs>\n";
		for (int i=0;i<mColumnWidth.size(); i++)
		{
			s += "\t\t\t<COLUMNWIDTH>"+mColumnWidth.elementAt(i)+"</COLUMNWIDTH>\n";
		}
		s += "\t\t</COLUMNWIDTHs>\n";
		s += "\t\t<COLUMNNAMEs>\n";
		for (int i=0;i<mColumnName.size(); i++)
		{
			s += "\t\t\t<COLUMNNAME>"+UtilityString.toXML(mColumnName.elementAt(i))+"</COLUMNNAME>\n";
		}
		s += "\t\t</COLUMNNAMEs>\n";
		s += "\t\t<unused>"+UtilityString.toXML(munused)+"</unused>\n";
		s += "\t</TableStateData>\n";
		return s;
	}
	@Override public String toString()
	{
		return mName;
	}
	private static TableStateDataXMLHandler XMLHANDLER = new TableStateDataXMLHandler();
	public static TableStateDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<TableStateData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(de.malban.Global.mBaseDir+filename);
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllTableStateData>\n");
			Iterator<TableStateData> iter = col.iterator();
			while (iter.hasNext())
			{
				TableStateData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllTableStateData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, TableStateData> getHashMapFromXML(String filename)
	{
		HashMap<String, TableStateData> filters = new HashMap<String, TableStateData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			TableStateDataXMLHandler h = TableStateData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"TableStateData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
