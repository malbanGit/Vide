package de.malban.vide.vecx.cartridge;

import javax.swing.JOptionPane;
import java.util.*;
public class  CartridgePropertiesPool
{
	public static final String DEFAULT_XML_NAME = new String("CartridgeProperties.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, CartridgeProperties> mCartridgeProperties = new HashMap<String, CartridgeProperties>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public CartridgePropertiesPool(String name)
	{
		mFileName = name;
		init();
	}
	public CartridgePropertiesPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error CartridgeProperties...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mCartridgeProperties = CartridgeProperties.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		CartridgeProperties.saveCollectionAsXML(mFileName, mCartridgeProperties.values());
		buildKlassenMap();
	}
	public void remove(CartridgeProperties st)
	{
		mCartridgeProperties.remove(st.mName);
	}
	public void put(CartridgeProperties st)
	{
		mCartridgeProperties.remove(st.mName);
		mCartridgeProperties.put(st.mName, st);
	}
	public void putAsNew(CartridgeProperties st)
	{
		mCartridgeProperties.put(st.mName, st);
	}
	public CartridgeProperties get(String key)
	{
		return mCartridgeProperties.get(key);
	}
	public HashMap<String, CartridgeProperties> getHashMap()
	{
		return mCartridgeProperties;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mCartridgeProperties.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			CartridgeProperties value = (CartridgeProperties) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, CartridgeProperties> getMapForKlasse(String klasse)
	{
		HashMap<String, CartridgeProperties> ret = new HashMap<String, CartridgeProperties>();
		Set entries = mCartridgeProperties.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			CartridgeProperties value = (CartridgeProperties) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
