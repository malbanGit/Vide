package de.malban.vide.vedi.project;

import java.io.File;
import javax.swing.JOptionPane;
import java.util.*;
public class  FilePropertiesPool
{
	public static final String DEFAULT_XML_NAME = new String("FileProperties.xml");
	private String mFileName = DEFAULT_XML_NAME;
        private String pathName=null;
	private HashMap<String, FileProperties> mFileProperties = new HashMap<String, FileProperties>();
	private HashMap<String, String> mKlassenMap = new HashMap<String, String>();
	public FilePropertiesPool(String p, String name)
	{
                pathName = p;
		mFileName = name;
		init();
	}
	public FilePropertiesPool()
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
			JOptionPane.showMessageDialog(null, e.toString() ,"Load Error FileProperties...",  JOptionPane.INFORMATION_MESSAGE);
			return false;
		}
	}
	public boolean load()
	{
            java.io.File f;
            if (pathName==null)
                f = new java.io.File(de.malban.util.Utility.makeVideAbsolute("xml"+File.separator+mFileName));
            else
                f = new java.io.File(de.malban.util.Utility.makeVideAbsolute(pathName)+File.separator+mFileName);
            if (!f.exists()) return false;
            if (pathName == null)
            {
                if (!new java.io.File(mFileName).exists()) return false;
                mFileProperties = FileProperties.getHashMapFromXML(mFileName);
            }
            else
                mFileProperties = FileProperties.getHashMapFromXML(mFileName, de.malban.util.Utility.makeVideAbsolute(pathName));
            return true;
	}
	public void save()
	{
            if (pathName==null)
		FileProperties.saveCollectionAsXML(mFileName, mFileProperties.values());
            else
            {
                if (de.malban.util.Utility.isFilenameRelative(pathName))
                    FileProperties.saveCollectionAsXML(de.malban.Global.mainPathPrefix+pathName, mFileName, mFileProperties.values());
                else
                    FileProperties.saveCollectionAsXML(pathName, mFileName, mFileProperties.values());
                
            }
            buildKlassenMap();
	}
	public void remove(FileProperties st)
	{
		mFileProperties.remove(st.mName);
	}
	public void put(FileProperties st)
	{
		mFileProperties.remove(st.mName);
		mFileProperties.put(st.mName, st);
	}
	public void putAsNew(FileProperties st)
	{
		mFileProperties.put(st.mName, st);
	}
	public FileProperties get(String key)
	{
		return mFileProperties.get(key);
	}
	public HashMap<String, FileProperties> getHashMap()
	{
		return mFileProperties;
	}
	private void buildKlassenMap()
	{
		mKlassenMap = new HashMap<String, String>();
		Set entries = mFileProperties.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			FileProperties value = (FileProperties) entry.getValue();
			mKlassenMap.put(value.mClass, value.mClass);
		}
	}
	public HashMap<String, String> getKlassenHashMap()
	{
		buildKlassenMap();
		return mKlassenMap;
	}
	public HashMap<String, FileProperties> getMapForKlasse(String klasse)
	{
		HashMap<String, FileProperties> ret = new HashMap<String, FileProperties>();
		Set entries = mFileProperties.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
			Map.Entry entry = (Map.Entry) it.next();
			FileProperties value = (FileProperties) entry.getValue();
			if (value.mClass.equalsIgnoreCase(klasse))
			{
				ret.put(value.mName, value);
			}
		}
		 return ret;
	}
}
