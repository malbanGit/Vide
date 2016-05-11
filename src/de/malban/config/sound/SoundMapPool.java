package de.malban.config.sound;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.swing.JOptionPane;

public class  SoundMapPool
{
	public static final String DEFAULT_XML_NAME = "SoundMap.xml";
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, SoundMap> mSoundMap = new HashMap<String, SoundMap>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public SoundMapPool(String name)
	{
		mFileName = name;
		init();
	}
	public SoundMapPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error SoundMap...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mSoundMap = SoundMap.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		SoundMap.saveCollectionAsXML(mFileName, mSoundMap.values());
		buildKlassenMap();
	}
	public void remove(SoundMap st)
	{
		mSoundMap.remove(st.mName);
	}
	public void put(SoundMap st)
	{
		mSoundMap.remove(st.mName);
		mSoundMap.put(st.mName, st);
	}
	public void putAsNew(SoundMap st)
	{
		mSoundMap.put(st.mName, st);
	}
	public SoundMap get(String key)
	{
		return mSoundMap.get(key);
	}
	public HashMap<String, SoundMap> getHashMap()
	{
		return mSoundMap;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mSoundMap.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			SoundMap value = (SoundMap) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, SoundMap> getMapForKlasse(String klasse)
	{
		HashMap<String, SoundMap> ret = new HashMap<String, SoundMap>();
		Set entries = mSoundMap.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			SoundMap value = (SoundMap) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
