package de.malban.vide.veccy;

import javax.swing.JOptionPane;
import java.util.*;
public class  SpriteDataPool
{
	public static final String DEFAULT_XML_NAME = new String("SpriteData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, SpriteData> mSpriteData = new HashMap<String, SpriteData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public SpriteDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public SpriteDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error SpriteData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mSpriteData = SpriteData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		SpriteData.saveCollectionAsXML(mFileName, mSpriteData.values());
		buildKlassenMap();
	}
	public void remove(SpriteData st)
	{
		mSpriteData.remove(st.mName);
	}
	public void put(SpriteData st)
	{
		mSpriteData.remove(st.mName);
		mSpriteData.put(st.mName, st);
	}
	public void putAsNew(SpriteData st)
	{
		mSpriteData.put(st.mName, st);
	}
	public SpriteData get(String key)
	{
		return mSpriteData.get(key);
	}
	public HashMap<String, SpriteData> getHashMap()
	{
		return mSpriteData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mSpriteData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			SpriteData value = (SpriteData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, SpriteData> getMapForKlasse(String klasse)
	{
		HashMap<String, SpriteData> ret = new HashMap<String, SpriteData>();
		Set entries = mSpriteData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			SpriteData value = (SpriteData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
