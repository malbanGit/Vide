package de.malban.util;

import javax.swing.JOptionPane;
import java.util.*;
public class  XMLClassBuilderDataPool
{
	public static final String DEFAULT_XML_NAME = new String("XMLClassBuilderData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, XMLClassBuilderData> mXMLClassBuilderData = new HashMap<String, XMLClassBuilderData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public XMLClassBuilderDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public XMLClassBuilderDataPool()
	{
		init();
	}
	private boolean init()
	{
		try
		{
			return load();
		}
		catch (Throwable e)
		{
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error XMLClassBuilderData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		mXMLClassBuilderData = XMLClassBuilderData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		XMLClassBuilderData.saveCollectionAsXML(mFileName, mXMLClassBuilderData.values());
	}
	public void remove(XMLClassBuilderData st)
	{
		mXMLClassBuilderData.remove(st.mName);
	}
	public void put(XMLClassBuilderData st)
	{
		mXMLClassBuilderData.remove(st.mName);
		mXMLClassBuilderData.put(st.mName, st);
	}
	public void putAsNew(XMLClassBuilderData st)
	{
		mXMLClassBuilderData.put(st.mName, st);
	}
	public XMLClassBuilderData get(String key)
	{
		return mXMLClassBuilderData.get(key);
	}
	public HashMap<String, XMLClassBuilderData> getHashMap()
	{
		return mXMLClassBuilderData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mXMLClassBuilderData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			XMLClassBuilderData value = (XMLClassBuilderData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, XMLClassBuilderData> getMapForKlasse(String klasse)
	{
		HashMap<String, XMLClassBuilderData> ret = new HashMap<String, XMLClassBuilderData>();
		Set entries = mXMLClassBuilderData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			XMLClassBuilderData value = (XMLClassBuilderData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
