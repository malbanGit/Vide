package de.malban.vide.veccy;

import javax.swing.JOptionPane;
import java.util.*;
public class  LevelObjectDataPool
{
	public static final String DEFAULT_XML_NAME = new String("LevelObjectData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, LevelObjectData> mLevelObjectData = new HashMap<String, LevelObjectData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public LevelObjectDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public LevelObjectDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error LevelObjectData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mLevelObjectData = LevelObjectData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		LevelObjectData.saveCollectionAsXML(mFileName, mLevelObjectData.values());
		buildKlassenMap();
	}
	public void remove(LevelObjectData st)
	{
		mLevelObjectData.remove(st.mName);
	}
	public void put(LevelObjectData st)
	{
		mLevelObjectData.remove(st.mName);
		mLevelObjectData.put(st.mName, st);
	}
	public void putAsNew(LevelObjectData st)
	{
		mLevelObjectData.put(st.mName, st);
	}
	public LevelObjectData get(String key)
	{
		return mLevelObjectData.get(key);
	}
	public HashMap<String, LevelObjectData> getHashMap()
	{
		return mLevelObjectData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mLevelObjectData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			LevelObjectData value = (LevelObjectData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, LevelObjectData> getMapForKlasse(String klasse)
	{
		HashMap<String, LevelObjectData> ret = new HashMap<String, LevelObjectData>();
		Set entries = mLevelObjectData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			LevelObjectData value = (LevelObjectData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
