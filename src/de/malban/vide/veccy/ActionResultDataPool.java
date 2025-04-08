package de.malban.vide.veccy;

import javax.swing.JOptionPane;
import java.util.*;
public class  ActionResultDataPool
{
	public static final String DEFAULT_XML_NAME = new String("ActionResultData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, ActionResultData> mActionResultData = new HashMap<String, ActionResultData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public ActionResultDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public ActionResultDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error ActionResultData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mActionResultData = ActionResultData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		ActionResultData.saveCollectionAsXML(mFileName, mActionResultData.values());
		buildKlassenMap();
	}
	public void remove(ActionResultData st)
	{
		mActionResultData.remove(st.mName);
	}
	public void put(ActionResultData st)
	{
		mActionResultData.remove(st.mName);
		mActionResultData.put(st.mName, st);
	}
	public void putAsNew(ActionResultData st)
	{
		mActionResultData.put(st.mName, st);
	}
	public ActionResultData get(String key)
	{
		return mActionResultData.get(key);
	}
	public HashMap<String, ActionResultData> getHashMap()
	{
		return mActionResultData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mActionResultData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ActionResultData value = (ActionResultData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, ActionResultData> getMapForKlasse(String klasse)
	{
		HashMap<String, ActionResultData> ret = new HashMap<String, ActionResultData>();
		Set entries = mActionResultData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ActionResultData value = (ActionResultData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
