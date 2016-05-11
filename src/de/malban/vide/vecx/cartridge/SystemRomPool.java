package de.malban.vide.vecx.cartridge;

import javax.swing.JOptionPane;
import java.util.*;
public class  SystemRomPool
{
	public static final String DEFAULT_XML_NAME = new String("SystemRom.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, SystemRom> mSystemRom = new HashMap<String, SystemRom>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public SystemRomPool(String name)
	{
		mFileName = name;
		init();
	}
	public SystemRomPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error SystemRom...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mSystemRom = SystemRom.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		SystemRom.saveCollectionAsXML(mFileName, mSystemRom.values());
		buildKlassenMap();
	}
	public void remove(SystemRom st)
	{
		mSystemRom.remove(st.mName);
	}
	public void put(SystemRom st)
	{
		mSystemRom.remove(st.mName);
		mSystemRom.put(st.mName, st);
	}
	public void putAsNew(SystemRom st)
	{
		mSystemRom.put(st.mName, st);
	}
	public SystemRom get(String key)
	{
		return mSystemRom.get(key);
	}
	public HashMap<String, SystemRom> getHashMap()
	{
		return mSystemRom;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mSystemRom.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			SystemRom value = (SystemRom) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, SystemRom> getMapForKlasse(String klasse)
	{
		HashMap<String, SystemRom> ret = new HashMap<String, SystemRom>();
		Set entries = mSystemRom.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			SystemRom value = (SystemRom) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
