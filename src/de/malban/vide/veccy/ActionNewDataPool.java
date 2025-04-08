package de.malban.vide.veccy;

import javax.swing.JOptionPane;
import java.util.*;
public class  ActionNewDataPool
{
	public static final String DEFAULT_XML_NAME = new String("ActionNewData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, ActionNewData> mActionNewData = new HashMap<String, ActionNewData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public ActionNewDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public ActionNewDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error ActionNewData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mActionNewData = ActionNewData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		ActionNewData.saveCollectionAsXML(mFileName, mActionNewData.values());
		buildKlassenMap();
	}
	public void remove(ActionNewData st)
	{
		mActionNewData.remove(st.mName);
	}
	public void put(ActionNewData st)
	{
		mActionNewData.remove(st.mName);
		mActionNewData.put(st.mName, st);
	}
	public void putAsNew(ActionNewData st)
	{
		mActionNewData.put(st.mName, st);
	}
	public ActionNewData get(String key)
	{
		return mActionNewData.get(key);
	}
	public HashMap<String, ActionNewData> getHashMap()
	{
		return mActionNewData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mActionNewData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ActionNewData value = (ActionNewData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, ActionNewData> getMapForKlasse(String klasse)
	{
		HashMap<String, ActionNewData> ret = new HashMap<String, ActionNewData>();
		Set entries = mActionNewData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ActionNewData value = (ActionNewData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
