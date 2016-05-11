package de.malban.script;

import javax.swing.JOptionPane;
import java.util.*;
public class  ExportDataPool
{
	public static final String DEFAULT_XML_NAME = new String("ExportData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, ExportData> mExportData = new HashMap<String, ExportData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public ExportDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public ExportDataPool()
	{
		init();
	}
	public void setFilename(String n)
	{
		mFileName=n;
	}
	private boolean init()
	{
		try
		{
			return load();
		}
		catch (Throwable e)
		{
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error ExportData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mExportData = ExportData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		ExportData.saveCollectionAsXML(mFileName, mExportData.values());
		buildKlassenMap();
	}
	public void remove(ExportData st)
	{
		mExportData.remove(st.mName);
	}
	public void put(ExportData st)
	{
		mExportData.remove(st.mName);
		mExportData.put(st.mName, st);
	}
	public void putAsNew(ExportData st)
	{
		mExportData.put(st.mName, st);
	}
	public ExportData get(String key)
	{
		return mExportData.get(key);
	}
	public HashMap<String, ExportData> getHashMap()
	{
		return mExportData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mExportData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ExportData value = (ExportData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, ExportData> getMapForKlasse(String klasse)
	{
		HashMap<String, ExportData> ret = new HashMap<String, ExportData>();
		Set entries = mExportData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ExportData value = (ExportData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
