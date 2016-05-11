package de.malban.config;

import javax.swing.JOptionPane;
import java.util.*;
public class  ConfigurationDataPool
{
	public static final String DEFAULT_XML_NAME = new String("ConfigurationData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, ConfigurationData> mConfigurationData = new HashMap<String, ConfigurationData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public ConfigurationDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public ConfigurationDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error ConfigurationData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mConfigurationData = ConfigurationData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		ConfigurationData.saveCollectionAsXML(mFileName, mConfigurationData.values());
		buildKlassenMap();
	}
	public void remove(ConfigurationData st)
	{
		mConfigurationData.remove(st.mName);
	}
	public void put(ConfigurationData st)
	{
		mConfigurationData.remove(st.mName);
		mConfigurationData.put(st.mName, st);
	}
	public void putAsNew(ConfigurationData st)
	{
		mConfigurationData.put(st.mName, st);
	}
	public ConfigurationData get(String key)
	{
		return mConfigurationData.get(key);
	}
	public HashMap<String, ConfigurationData> getHashMap()
	{
		return mConfigurationData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mConfigurationData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ConfigurationData value = (ConfigurationData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, ConfigurationData> getMapForKlasse(String klasse)
	{
		HashMap<String, ConfigurationData> ret = new HashMap<String, ConfigurationData>();
		Set entries = mConfigurationData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ConfigurationData value = (ConfigurationData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
