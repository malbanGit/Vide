package de.malban.vide.veccy;

import javax.swing.JOptionPane;
import java.util.*;
public class  GameDataPool
{
	public static final String DEFAULT_XML_NAME = new String("GameData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, GameData> mGameData = new HashMap<String, GameData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public GameDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public GameDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error GameData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mGameData = GameData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		GameData.saveCollectionAsXML(mFileName, mGameData.values());
		buildKlassenMap();
	}
	public void remove(GameData st)
	{
		mGameData.remove(st.mName);
	}
	public void put(GameData st)
	{
		mGameData.remove(st.mName);
		mGameData.put(st.mName, st);
	}
	public void putAsNew(GameData st)
	{
		mGameData.put(st.mName, st);
	}
	public GameData get(String key)
	{
		return mGameData.get(key);
	}
	public HashMap<String, GameData> getHashMap()
	{
		return mGameData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mGameData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			GameData value = (GameData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, GameData> getMapForKlasse(String klasse)
	{
		HashMap<String, GameData> ret = new HashMap<String, GameData>();
		Set entries = mGameData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			GameData value = (GameData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
