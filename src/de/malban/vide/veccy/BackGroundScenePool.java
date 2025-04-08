package de.malban.vide.veccy;

import javax.swing.JOptionPane;
import java.util.*;
public class  BackGroundScenePool
{
	public static final String DEFAULT_XML_NAME = new String("BackGroundScene.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, BackGroundScene> mBackGroundScene = new HashMap<String, BackGroundScene>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public BackGroundScenePool(String name)
	{
		mFileName = name;
		init();
	}
	public BackGroundScenePool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error BackGroundScene...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mBackGroundScene = BackGroundScene.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		BackGroundScene.saveCollectionAsXML(mFileName, mBackGroundScene.values());
		buildKlassenMap();
	}
	public void remove(BackGroundScene st)
	{
		mBackGroundScene.remove(st.mName);
	}
	public void put(BackGroundScene st)
	{
		mBackGroundScene.remove(st.mName);
		mBackGroundScene.put(st.mName, st);
	}
	public void putAsNew(BackGroundScene st)
	{
		mBackGroundScene.put(st.mName, st);
	}
	public BackGroundScene get(String key)
	{
		return mBackGroundScene.get(key);
	}
	public HashMap<String, BackGroundScene> getHashMap()
	{
		return mBackGroundScene;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mBackGroundScene.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			BackGroundScene value = (BackGroundScene) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, BackGroundScene> getMapForKlasse(String klasse)
	{
		HashMap<String, BackGroundScene> ret = new HashMap<String, BackGroundScene>();
		Set entries = mBackGroundScene.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			BackGroundScene value = (BackGroundScene) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
