package de.malban.config.theme;

import javax.swing.JOptionPane;
import java.util.*;
public class  InetThemeDataPool
{
	public static final String DEFAULT_XML_NAME = new String("InetThemeData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, InetThemeData> mInetThemeData = new HashMap<String, InetThemeData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public InetThemeDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public InetThemeDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error InetThemeData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mInetThemeData = InetThemeData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		InetThemeData.saveCollectionAsXML(mFileName, mInetThemeData.values());
		buildKlassenMap();
	}
	public void remove(InetThemeData st)
	{
		mInetThemeData.remove(st.mName);
	}
	public void put(InetThemeData st)
	{
		mInetThemeData.remove(st.mName);
		mInetThemeData.put(st.mName, st);
	}
	public void putAsNew(InetThemeData st)
	{
		mInetThemeData.put(st.mName, st);
	}
	public InetThemeData get(String key)
	{
		return mInetThemeData.get(key);
	}
	public HashMap<String, InetThemeData> getHashMap()
	{
		return mInetThemeData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mInetThemeData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			InetThemeData value = (InetThemeData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, InetThemeData> getMapForKlasse(String klasse)
	{
		HashMap<String, InetThemeData> ret = new HashMap<String, InetThemeData>();
		Set entries = mInetThemeData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			InetThemeData value = (InetThemeData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
