package de.malban.config.theme;

import javax.swing.JOptionPane;
import java.util.*;
public class  ThemeDataPool
{
	public static final String DEFAULT_XML_NAME = new String("ThemeData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, ThemeData> mThemeData = new HashMap<String, ThemeData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public ThemeDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public ThemeDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error ThemeData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mThemeData = ThemeData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		ThemeData.saveCollectionAsXML(mFileName, mThemeData.values());
		buildKlassenMap();
	}
	public void remove(ThemeData st)
	{
		mThemeData.remove(st.mName);
	}
	public void put(ThemeData st)
	{
		mThemeData.remove(st.mName);
		mThemeData.put(st.mName, st);
	}
	public void putAsNew(ThemeData st)
	{
		mThemeData.put(st.mName, st);
	}
	public ThemeData get(String key)
	{
		return mThemeData.get(key);
	}
	public HashMap<String, ThemeData> getHashMap()
	{
		return mThemeData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mThemeData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ThemeData value = (ThemeData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, ThemeData> getMapForKlasse(String klasse)
	{
		HashMap<String, ThemeData> ret = new HashMap<String, ThemeData>();
		Set entries = mThemeData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ThemeData value = (ThemeData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
