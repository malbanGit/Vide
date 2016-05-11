package de.malban.graphics;

import javax.swing.JOptionPane;
import java.util.*;
public class  ImageSequenceDataPool
{
	public static final String DEFAULT_XML_NAME = new String("ImageSequenceData.xml");
	private String mFileName = DEFAULT_XML_NAME;
	private HashMap<String, ImageSequenceData> mImageSequenceData = new HashMap<String, ImageSequenceData>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
        public String getFilename()
        {
            return mFileName;
        }
	public ImageSequenceDataPool(String name)
	{
		mFileName = name;
		init();
	}
	public ImageSequenceDataPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error ImageSequenceData...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
		java.io.File f = new java.io.File(de.malban.Global.mBaseDir+mFileName);
		if (!f.exists()) return false;
		mImageSequenceData = ImageSequenceData.getHashMapFromXML(mFileName);
		return true;
	}
	public void save()
	{
		ImageSequenceData.saveCollectionAsXML(mFileName, mImageSequenceData.values());
		buildKlassenMap();
	}
	public void remove(ImageSequenceData st)
	{
		mImageSequenceData.remove(st.mName);
	}
	public void put(ImageSequenceData st)
	{
		mImageSequenceData.remove(st.mName);
		mImageSequenceData.put(st.mName, st);
	}
	public void putAsNew(ImageSequenceData st)
	{
		mImageSequenceData.put(st.mName, st);
	}
	public ImageSequenceData get(String key)
	{
		return mImageSequenceData.get(key);
	}
	public HashMap<String, ImageSequenceData> getHashMap()
	{
		return mImageSequenceData;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mImageSequenceData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ImageSequenceData value = (ImageSequenceData) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, ImageSequenceData> getMapForKlasse(String klasse)
	{
		HashMap<String, ImageSequenceData> ret = new HashMap<String, ImageSequenceData>();
		Set entries = mImageSequenceData.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			ImageSequenceData value = (ImageSequenceData) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
