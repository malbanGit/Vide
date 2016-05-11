package de.malban.util;

import javax.swing.JOptionPane;
import java.util.*;
public class  DownloaderPool
{
	public static final String DEFAULT_XML_NAME = new String("Downloader.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, Downloader> mDownloader = new HashMap<String, Downloader>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public DownloaderPool(String name)
	{
		mFileName = name;
		init();
	}
	public DownloaderPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error Downloader...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mDownloader = Downloader.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		Downloader.saveCollectionAsXML(mFileName, mDownloader.values());
		buildKlassenMap();
	}
	public void remove(Downloader st)
	{
		mDownloader.remove(st.mName);
	}
	public void put(Downloader st)
	{
		mDownloader.remove(st.mName);
		mDownloader.put(st.mName, st);
	}
	public void putAsNew(Downloader st)
	{
		mDownloader.put(st.mName, st);
	}
	public Downloader get(String key)
	{
		return mDownloader.get(key);
	}
	public HashMap<String, Downloader> getHashMap()
	{
		return mDownloader;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mDownloader.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			Downloader value = (Downloader) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, Downloader> getMapForKlasse(String klasse)
	{
		HashMap<String, Downloader> ret = new HashMap<String, Downloader>();
		Set entries = mDownloader.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			Downloader value = (Downloader) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
