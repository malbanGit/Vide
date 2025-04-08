package de.malban.vide.veccy;

import javax.swing.JOptionPane;
import java.util.*;
public class  ActionDataPool
{
	public static final String DEFAULT_XML_NAME = new String("ActionData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, ActionData> mActionData = new HashMap<String, ActionData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public ActionDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public ActionDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error ActionData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mActionData = ActionData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		ActionData.saveCollectionAsXML(mFileName, mActionData.values());
		buildKlassenMap();
	}
	public void remove(ActionData st)
	{
		mActionData.remove(st.mName);
	}
	public void put(ActionData st)
	{
		mActionData.remove(st.mName);
		mActionData.put(st.mName, st);
	}
	public void putAsNew(ActionData st)
	{
		mActionData.put(st.mName, st);
	}
	public ActionData get(String key)
	{
		return mActionData.get(key);
	}
	public HashMap<String, ActionData> getHashMap()
	{
		return mActionData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mActionData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ActionData value = (ActionData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, ActionData> getMapForKlasse(String klasse)
	{
		HashMap<String, ActionData> ret = new HashMap<String, ActionData>();
		Set entries = mActionData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ActionData value = (ActionData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
