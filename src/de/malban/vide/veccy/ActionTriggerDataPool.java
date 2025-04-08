package de.malban.vide.veccy;

import javax.swing.JOptionPane;
import java.util.*;
public class  ActionTriggerDataPool
{
	public static final String DEFAULT_XML_NAME = new String("ActionTriggerData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, ActionTriggerData> mActionTriggerData = new HashMap<String, ActionTriggerData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public ActionTriggerDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public ActionTriggerDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error ActionTriggerData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mActionTriggerData = ActionTriggerData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		ActionTriggerData.saveCollectionAsXML(mFileName, mActionTriggerData.values());
		buildKlassenMap();
	}
	public void remove(ActionTriggerData st)
	{
		mActionTriggerData.remove(st.mName);
	}
	public void put(ActionTriggerData st)
	{
		mActionTriggerData.remove(st.mName);
		mActionTriggerData.put(st.mName, st);
	}
	public void putAsNew(ActionTriggerData st)
	{
		mActionTriggerData.put(st.mName, st);
	}
	public ActionTriggerData get(String key)
	{
		return mActionTriggerData.get(key);
	}
	public HashMap<String, ActionTriggerData> getHashMap()
	{
		return mActionTriggerData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mActionTriggerData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ActionTriggerData value = (ActionTriggerData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, ActionTriggerData> getMapForKlasse(String klasse)
	{
		HashMap<String, ActionTriggerData> ret = new HashMap<String, ActionTriggerData>();
		Set entries = mActionTriggerData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ActionTriggerData value = (ActionTriggerData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
