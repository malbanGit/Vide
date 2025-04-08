/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import java.io.Serializable;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author malban
 */
public class VediSettings implements Serializable
{
    public int pos1 = 0;  // upper vertical split
    public int pos2 = 0;  // middle split
    public int pos3 = 0;  // lower vertical split
    public int inventoryPos = 0;
    public String vec32PortName = "";
    public String vec32UsbMount = "";

    public boolean showMacroDefinition = false;
    public boolean showEQULabel = false;
    public boolean showEqualLabel = false;
    public boolean showSetLabel = false;
    public boolean showStructLabel = false;
    public boolean showInStructLabel = false;
    public boolean showLineLabel = false;
    public boolean showDataLabel = false;
    public boolean showMacroLabel = false;
    public boolean showFunctionLabel = true;
    public boolean showUserLabel = true;
    
    public String v4eVolumeName = ""; // not used anymore! - we use "config" now
    public boolean v4eEnabled = false;
    public boolean piTrexEnabled = false;

    int fontSize = 12;
    public HashMap <Integer, Bookmark> bookmarks = new HashMap<Integer, Bookmark>();
    public HashMap <String, DebugCommentList> allDebugComments = new HashMap<String, DebugCommentList>();
    public static class P implements Serializable
    {
        String mName;
        String mClass;
        String mFullPath;
        public P(String n, String c, String p)
        {
            mName = n;
            mClass = c;
            mFullPath = p;
        }
        public String toString()
        {
            Path p = Paths.get(mName);
            return p.getFileName().toString();
        }
        public boolean equals(P other)
        {
            return other.mName.equals(mName);
//            return other.mClass.equals(mClass) && other.mName.equals(mName) && other.mPath.equals(mPath);
        }
    }
    ArrayList<EditorFileSettings> currentOpenFiles = new ArrayList<EditorFileSettings>();
    ArrayList<EditorFileSettings> recentOpenFiles = new ArrayList<EditorFileSettings>();

    public void setOpenPosition(String fn, int pos)
    {
        fn = de.malban.util.Utility.makeVideRelative(fn);
        EditorFileSettings set = getOpen(fn);
        if (set != null) set.position = pos;
    }
        
    public EditorFileSettings getOpen(String fn)
    {
        fn = de.malban.util.Utility.makeVideRelative(fn);
        for (EditorFileSettings set: currentOpenFiles)
        {
            if (set.filename.toLowerCase().equals(fn.toLowerCase())) return set;
        }
        return null;
    }
    public EditorFileSettings getRecent(String fn)
    {
        fn = de.malban.util.Utility.makeVideRelative(fn);
        for (EditorFileSettings set: recentOpenFiles)
        {
            if (set.filename.toLowerCase().equals(fn.toLowerCase())) return set;
        }
        return null;
    }
    
    public boolean openContains(String fn)
    {
        return getOpen(fn) != null;
    }
    public boolean recentContains(String fn)
    {
        return getRecent(fn) != null;
    }
    
    public EditorFileSettings addOpen(String fn, int pos)
    {
        fn = de.malban.util.Utility.makeVideRelative(fn);
        EditorFileSettings edi = getOpen(fn);
        if (edi == null) 
        {
            edi = new EditorFileSettings();
            currentOpenFiles.add(edi);
        }
        edi.filename = fn;
        edi.position = pos;
        
        removeRecent(fn);
        addRecent(fn, pos);
        return edi;
    }
    public EditorFileSettings addRecent(String fn, int pos)
    {
        fn = de.malban.util.Utility.makeVideRelative(fn);
        EditorFileSettings edi = getOpen(fn);
        if (edi == null) 
        {
            edi = new EditorFileSettings();
            recentOpenFiles.add(edi);
        }
        edi.filename = fn;
        edi.position = pos;
        return edi;
    }
    
    public boolean removeOpen(String fn)
    {
        fn = de.malban.util.Utility.makeVideRelative(fn);
        for (EditorFileSettings set: currentOpenFiles)
        {
            if (set.filename.equals(fn)) 
            {
                currentOpenFiles.remove(set);
                return true;
            }
        }
        return false;
    }
    public boolean removeRecent(String fn)
    {
        fn = de.malban.util.Utility.makeVideRelative(fn);
        for (EditorFileSettings set: recentOpenFiles)
        {
            if (set.filename.equals(fn)) 
            {
                recentOpenFiles.remove(set);
                return true;
            }
        }
        return false;
    }
    
    
    ArrayList<P> recentProject = new ArrayList<P>();

    P currentProject;
    public void addProject(String n, String c, String pp)
    {
        P _new = new P(n,c,pp);
        
        // don't add doubles
        for (P p: recentProject)
            if (p.equals(_new)) return;
        
        recentProject.add(_new);
    }
    public void setCurrentProject(String n, String c, String p)
    {
        currentProject = new P(n,c, p);
    }
    public void adjustOS()
    {
        if (currentProject != null)
        {
            currentProject.mFullPath = de.malban.util.UtilityFiles.convertSeperator(currentProject.mFullPath);
        }
        for (P p: recentProject)
        {
            p.mFullPath = de.malban.util.UtilityFiles.convertSeperator(p.mFullPath);
        }
        for (EditorFileSettings set: currentOpenFiles)
        {
            set.filename = de.malban.util.UtilityFiles.convertSeperator(set.filename);
        }
        for (EditorFileSettings set: recentOpenFiles)
        {
            set.filename = de.malban.util.UtilityFiles.convertSeperator(set.filename);
        }
        
        Set entries = bookmarks.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            Bookmark value = (Bookmark) entry.getValue();
            value.fullFilename = de.malban.util.UtilityFiles.convertSeperator(value.fullFilename);
        }        
    }
    public void relativePaths()
    {
        if (currentProject != null)
        {
            currentProject.mFullPath = de.malban.util.Utility.makeVideRelative(currentProject.mFullPath);
        }
        for (P p: recentProject)
        {
            p.mFullPath = de.malban.util.Utility.makeVideRelative(p.mFullPath);
        }
        for (EditorFileSettings set: currentOpenFiles)
        {
            set.filename = de.malban.util.Utility.makeVideRelative(set.filename);
        }
        for (EditorFileSettings set: recentOpenFiles)
        {
            set.filename = de.malban.util.Utility.makeVideRelative(set.filename);
        }
        
        Set entries = bookmarks.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            Bookmark value = (Bookmark) entry.getValue();
            value.fullFilename = de.malban.util.Utility.makeVideRelative(value.fullFilename);
        }
    
    
    }
    
}
