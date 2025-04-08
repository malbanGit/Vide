package de.malban.vide.veccy;

import javax.swing.JOptionPane;
import java.util.*;
public class  LevelDataPool
{
	public static final String DEFAULT_XML_NAME = new String("LevelData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, LevelData> mLevelData = new HashMap<String, LevelData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public LevelDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public LevelDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error LevelData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mLevelData = LevelData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		LevelData.saveCollectionAsXML(mFileName, mLevelData.values());
		buildKlassenMap();
	}
	public void remove(LevelData st)
	{
		mLevelData.remove(st.mName);
	}
	public void put(LevelData st)
	{
		mLevelData.remove(st.mName);
		mLevelData.put(st.mName, st);
	}
	public void putAsNew(LevelData st)
	{
		mLevelData.put(st.mName, st);
	}
	public LevelData get(String key)
	{
		return mLevelData.get(key);
	}
	public HashMap<String, LevelData> getHashMap()
	{
		return mLevelData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mLevelData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			LevelData value = (LevelData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, LevelData> getMapForKlasse(String klasse)
	{
		HashMap<String, LevelData> ret = new HashMap<String, LevelData>();
		Set entries = mLevelData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			LevelData value = (LevelData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
