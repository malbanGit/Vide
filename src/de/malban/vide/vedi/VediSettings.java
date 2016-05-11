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

/**
 *
 * @author malban
 */
public class VediSettings implements Serializable
{
    public int pos1 = 0;
    public int pos2 = 0;
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
    ArrayList<String> currentOpenFiles = new ArrayList<>();
    ArrayList<String> recentOpenFiles = new ArrayList<>();
    ArrayList<P> recentProject = new ArrayList<>();

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
