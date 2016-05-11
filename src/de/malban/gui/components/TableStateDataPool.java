package de.malban.gui.components;

import javax.swing.JOptionPane;
import java.util.*;
public class  TableStateDataPool
{
	public static final String DEFAULT_XML_NAME = new String("TableStateData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, TableStateData> mTableStateData = new HashMap<String, TableStateData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public TableStateDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public TableStateDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error TableStateData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mTableStateData = TableStateData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		TableStateData.saveCollectionAsXML(mFileName, mTableStateData.values());
		buildKlassenMap();
	}
	public void remove(TableStateData st)
	{
		mTableStateData.remove(st.mName);
	}
	public void put(TableStateData st)
	{
		mTableStateData.remove(st.mName);
		mTableStateData.put(st.mName, st);
	}
	public void putAsNew(TableStateData st)
	{
		mTableStateData.put(st.mName, st);
	}
	public TableStateData get(String key)
	{
		return mTableStateData.get(key);
	}
	public HashMap<String, TableStateData> getHashMap()
	{
		return mTableStateData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mTableStateData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			TableStateData value = (TableStateData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, TableStateData> getMapForKlasse(String klasse)
	{
		HashMap<String, TableStateData> ret = new HashMap<String, TableStateData>();
		Set entries = mTableStateData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			TableStateData value = (TableStateData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
