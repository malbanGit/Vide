/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util.syntax.entities;

import de.malban.Global;
import de.malban.vide.vedi.EditorPanel;
import java.io.File;
import java.io.FileReader;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.swing.JTextPane;

/**
 *
 * @author malban
 */
public class ASM6809FileMaster
{
    private static HashMap<Integer, ASM6809FileMaster> vediFileMap  = new HashMap<Integer, ASM6809FileMaster>();

    public HashMap<String, EntityDefinition> knownGlobalFunctions = new HashMap<String, EntityDefinition>();
    public HashMap<String, EntityDefinition> knownGlobalVariables = new HashMap<String, EntityDefinition>();
    public HashMap<String, EntityDefinition> knownGlobalMacros = new HashMap<String, EntityDefinition>();

    HashMap<String, ASM6809File> allFileMap  = new HashMap<String, ASM6809File>();
    int inUpdate = 0;
    boolean inReset = false;
   
    public static ASM6809FileMaster getInfo(int id)
    {
        return vediFileMap.get(id);
    }
    public static ASM6809FileMaster getInstance(int i)
    {
        ASM6809FileMaster a = new ASM6809FileMaster();
        vediFileMap.put(i, a);
        return a;
    }
    public static void removeInstance(int i)
    {
        vediFileMap.remove(i);
    }
    
    
    private ASM6809FileMaster(){}
    
    public void replaceFileName(String oldFileName, String newFileName)
    {
        inUpdate++;
        
        String oldkey = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeVideAbsolute(oldFileName)).toLowerCase();
        String newkey = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeVideAbsolute(newFileName)).toLowerCase();
        
        
        
        
        ASM6809File fileInfo = allFileMap.get(oldkey);
        if (fileInfo==null) 
        {
            
            inUpdate--;
            return;
        }

        fileInfo.fullName = newFileName;
        Path path = Paths.get(newFileName);
        fileInfo.name = path.getFileName().toString();
                
        if (path.getParent()!=null)
            fileInfo.path = path.getParent().toString();
        else
            fileInfo.path = "";
        allFileMap.remove(oldkey);
        allFileMap.put(newkey, fileInfo);
        inUpdate--;
    }

    // all included are also reset
    public void resetDefinitions(String filename, String text, boolean doIncludes)
    {
        if (inUpdate>0) return;
        inUpdate++;
        inReset=true;
        String key = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeVideAbsolute(filename)).toLowerCase();
        allFileMap.remove(key);
        handleFile(filename, text, doIncludes);
        inReset=false;
        inUpdate--;
    }
    public void resetDefinitions()
    {
        if (inUpdate>0) return;
        inUpdate++;
        knownGlobalVariables = new HashMap<String, EntityDefinition>();
        knownGlobalMacros = new HashMap<String, EntityDefinition>();
        knownGlobalFunctions = new HashMap<String, EntityDefinition>();
        HashMap<String, ASM6809File> oldAllFileMap = allFileMap;
        allFileMap = null;
        allFileMap = new HashMap<String, ASM6809File>();

        Set entries = oldAllFileMap.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            ASM6809File value = (ASM6809File) entry.getValue();
            String key = (String) entry.getKey();
            
            handleFile(value.fullName, null);
        }
        inUpdate--;
    }
    public void clearDefinitions()
    {
        knownGlobalVariables = new HashMap<String, EntityDefinition>();
        knownGlobalMacros = new HashMap<String, EntityDefinition>();
        knownGlobalFunctions = new HashMap<String, EntityDefinition>();
        allFileMap = new HashMap<String, ASM6809File>();;
    }
    
    public void resetToProject(File mainFile)
    {
        clearDefinitions();
        handleFile(mainFile.getAbsolutePath(), null);
    }
    
    private String loadText(String filename)
    {
        try 
        {
            filename = de.malban.util.UtilityFiles.convertSeperator(filename);
            String edited = EditorPanel.getTextForFile(filename);
            if (edited != null) return edited;
            
            
            // I know this is "bad", but what the heck,... don't bother tp check for \r\n \r ... myself
            JTextPane jTextPane1 = new JTextPane();
            FileReader fr = new FileReader(de.malban.util.Utility.makeVideAbsolute(filename));
            jTextPane1.read(fr, null);
            fr.close();
            String text = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength());
            return text;
        }
        catch (Throwable e) 
        {
            //e.printStackTrace();
        }
        return "";
        
    }
    
    // document text, line seperated by "\n"
    // if text is null, it will try to load text thru a document
    // to be on the save side of line end definitions
    public ASM6809File handleFile(String _fullname, String _text)
    {
        return handleFile(_fullname, _text, true);
    }
    public ASM6809File handleFile(String _fullname, String _text, boolean doIncludes)
    {
        if (_fullname.contains(Global.mainPathPrefix))
            _fullname = de .malban.util.UtilityString.replace(_fullname, Global.mainPathPrefix, "");
        
        String key = de.malban.util.Utility.makeVideAbsolute(Global.mainPathPrefix+de.malban.util.UtilityFiles.convertSeperator(_fullname)).toLowerCase();
        ASM6809File fileInfo = allFileMap.get(key);
        if (fileInfo != null) return fileInfo;
        fileInfo = new ASM6809File(this);
        fileInfo.fullName = _fullname;
        
        Path path = Paths.get(_fullname);
        if (path.toString().length()==0) return fileInfo;
        fileInfo.name = path.getFileName().toString();
        if (path.getParent()!=null)
            fileInfo.path = path.getParent().toString();
        else
            fileInfo.path = "";
        
        if (_text == null)
        {
            _text = loadText(_fullname);
        }
        fileInfo.text = new StringBuffer(_text);
        fileInfo.lineCount = fileInfo.getLineCount(_text);
        fileInfo.scanText(_text, doIncludes);
        allFileMap.put(key, fileInfo);
//        System.out.println("\""+fileInfo.name+"\" loaded!");
        return fileInfo;
    }
    
    
}
    