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
    
    public String v4eVolumeName = "";
    public boolean v4eEnabled = false;

    int fontSize = 12;
    public HashMap <Integer, Bookmark> bookmarks = new HashMap<Integer, Bookmark>();
    public HashMap <String, DebugCommentList> allDebugComments = new HashMap<String, DebugCommentList>();
    public static class P implements Serializable
    {
        String mName;
        String mClass;
        String mPath;
        public P(String n, String c, String p)
        {
            mName = n;
            mClass = c;
            mPath = p;
        }
        public String toString()
        {
            Path p = Paths.get(mName);
            return p.getFileName().toString();
        }
        public boolean equals(P other)
        {
            return other.mClass.equals(mClass) && other.mName.equals(mName) && other.mPath.equals(mPath);
        }
    }
    ArrayList<EditorFileSettings> currentOpenFiles = new ArrayList<EditorFileSettings>();
    ArrayList<EditorFileSettings> recentOpenFiles = new ArrayList<EditorFileSettings>();

    public void setOpenPosition(String fn, int pos)
    {
        EditorFileSettings set = getOpen(fn);
        if (set != null) set.position = pos;
    }
    
    
    public EditorFileSettings getOpen(String fn)
    {
        for (EditorFileSettings set: currentOpenFiles)
        {
            if (set.filename.toLowerCase().equals(fn.toLowerCase())) return set;
        }
        return null;
    }
    public EditorFileSettings getRecent(String fn)
    {
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
        EditorFileSettings edi = getOpen(fn);
        if (edi == null) 
        {
            edi = new EditorFileSettings();
            currentOpenFiles.add(edi);
        }
        edi.filename = fn;
        edi.position = pos;
        return edi;
    }
    public EditorFileSettings addRecent(String fn, int pos)
    {
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
    
}
