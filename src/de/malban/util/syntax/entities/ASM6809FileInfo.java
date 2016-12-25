/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util.syntax.entities;

import static de.malban.util.syntax.entities.EntityDefinition.TYP_INCLUDE;
import static de.malban.util.syntax.entities.EntityDefinition.TYP_LABEL;
import static de.malban.util.syntax.entities.EntityDefinition.TYP_MACRO;
import java.io.File;
import java.io.FileReader;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.swing.JTextPane;

/**
 *
 * @author malban
 */
public class ASM6809FileInfo
{
    private static HashMap<String, ASM6809FileInfo> allFileMap  = new HashMap<String, ASM6809FileInfo>();
    public static final int ENTITY_UNCHANGED = 0;
    public static final int ENTITY_CHANGED = 1;
    public static final int ENTITY_DELETED = -1;

    public static void resetDefinitions()
    {
        LabelSink.knownGlobalVariables = new HashMap<String, EntityDefinition>();
        MacroSink.knownGlobalMacros = new HashMap<String, EntityDefinition>();
        HashMap<String, ASM6809FileInfo> oldAllFileMap = allFileMap;
        allFileMap = null;
        allFileMap = new HashMap<String, ASM6809FileInfo>();;

        Set entries = oldAllFileMap.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            ASM6809FileInfo value = (ASM6809FileInfo) entry.getValue();
            String key = (String) entry.getKey();
            
            ASM6809FileInfo.handleFile(value.fullName, null);
        }
    }
    
    private ASM6809FileInfo(){}
    
    public static void replaceFileName(String oldFileName, String newFileName)
    {
        ASM6809FileInfo fileInfo = allFileMap.get(oldFileName);
        if (fileInfo==null) return;

        fileInfo.fullName = newFileName;
        Path path = Paths.get(newFileName);
        fileInfo.name = path.getFileName().toString();
                
        if (path.getParent()!=null)
            fileInfo.path = path.getParent().toString();
        else
            fileInfo.path = "";

        allFileMap.remove(oldFileName);
        allFileMap.put(newFileName, fileInfo);
        
    }

    
    public String toString()
    {
        return fullName;
    }
    
    String fullName; // full path an filename
    String path; // only path, like Path(fullName).getParent()
    String name; // only filename
    StringBuffer text; // complete contents of the denoted file as a stringbuffer
    ArrayList<EntityDefinition> entityArray = new ArrayList<EntityDefinition>();
    
    // since we store definitions of "something" 
    // the line itself is chosen as a hashmap key
    // in a "correct" file, defintion lines won't be double,
    // if so, there might be "line errors"
    HashMap<String, EntityDefinition> lineEntityMap = new HashMap<String, EntityDefinition>();

    // is the "calling" entity in a struct
    // has any of the previous lines a "struct" open
    // (and not closed?)
    boolean inStruct(EntityDefinition entity)
    {
        // assuming
        int scanFrom = entityArray.size()-1;
        if (entity.lineNumber!=-1)
        {
            // assuming new line, wich has not been added
            // in this case we scan backwords from last 
            scanFrom = entity.lineNumber-1;
        }
        for (int i=scanFrom; i>=0;i--)
        {
            EntityDefinition e = entityArray.get(i);
            if (e.isStructEnd) return false;
            if (e.isStructStart) 
                return true;
        }
        return false;
    }
    void addLineToArray(EntityDefinition e)
    {
        entityArray.add(e);
        e.lineNumber = entityArray.size()-1;
    }
    void removeLineToArray(EntityDefinition e)
    {
        int line = e.lineNumber;
        if (line <0) // uaaahh! Error
        {
            line = entityArray.indexOf(e);
            return; // not part of error, quit quitly...
        }
        if (line != entityArray.indexOf(e))
        {
            // error to...
            line = entityArray.indexOf(e);
        }
        entityArray.remove(e);
        for (int l=line; l<entityArray.size(); l++)
        {
            entityArray.get(l).lineNumber = l;
        }
    }
    
    void resetLabels()
    {
        Set entries = lineEntityMap.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            EntityDefinition value = (EntityDefinition) entry.getValue();
            String key = (String) entry.getKey();
            LabelSink.knownGlobalVariables.remove(value.name.toLowerCase());
            LabelSink.knownGlobalVariables.put(value.name.toLowerCase(), value);
        }

        
    }
    
    // redo complete text (no includes)
    void reset()
    {
       for (EntityDefinition e: entityArray)
       {
            if (e.type == TYP_MACRO)
            {
                MacroSink.knownGlobalMacros.remove(e.name.toLowerCase());
                for (String n: e.parameter)
                    MacroSink.knownGlobalMacros.remove(n.toLowerCase());
            }
            if (e.type == TYP_LABEL)
            {
                LabelSink.knownGlobalVariables.remove(e.name.toLowerCase());
            }
       }
       
       lineEntityMap.clear();
       entityArray.clear();
       scanText(text.toString());
    }
            
    // this scans for changes between an old line and a new line
    // and sets global macro/label definitions accordingly
    // also updates entity and lineEntity
    // does not rely in any way on "StringBuffer text"
    // this method does not update text!
    // the line strings are 
    // the lines + ";linenumber"
    // so I can use them as keys in a hashmap
    private EntityDefinition updateEntity(String oldLine, String line)
    {
        if (line == null) return null;
        boolean existed = false;
        int status = ENTITY_UNCHANGED;
        EntityDefinition entity = lineEntityMap.get(oldLine);
        if (entity==null) 
        {
            entity = EntityDefinition.scanLine(this,  line);
            addLineToArray(entity);
            status = entity.getStatus();
        }
        else
        {
            existed = true;
            status = entity.updateEntity(line);
            if (entity.previousType == TYP_MACRO)
            {
                MacroSink.knownGlobalMacros.remove(entity.previousName.toLowerCase());
                if (entity.previousParameter!=null)
                {
                    for (String n: entity.previousParameter)
                        MacroSink.knownGlobalMacros.remove(n.toLowerCase());
                }
            }
            if (entity.previousType == TYP_LABEL)
            {
                LabelSink.knownGlobalVariables.remove(entity.previousName.toLowerCase());
            }
        }
    
        if (status == ENTITY_DELETED)
        {
            removeLineToArray(entity);
            lineEntityMap.remove(oldLine, entity);
        }
        else
        {
            lineEntityMap.remove(oldLine, entity);
            lineEntityMap.put(line, entity);
            if (entity.type == TYP_MACRO)
            {
                MacroSink.knownGlobalMacros.put(entity.name.toLowerCase(), entity);
                if (entity.parameter!=null)
                {
                    for (String n: entity.parameter)
                        MacroSink.knownGlobalMacros.put(n.toLowerCase(), entity);
                }
            }
            else if (entity.type == TYP_LABEL)
            {
                LabelSink.knownGlobalVariables.put(entity.name.toLowerCase(), entity);
            }
        }
        if (status == ENTITY_CHANGED)
        {
            if (entity.type == TYP_INCLUDE)
            {
                String newFilename ="";
                if (path != null)
                {
                    newFilename+=path+File.separator;
                }
                newFilename+=entity.name;
                handleFile(newFilename, null);
            }
        }
        if ((status == ENTITY_DELETED) && (!existed)) 
            entity.setStatus(ENTITY_UNCHANGED);
        
        // copy and paste often happens for lines
        // with labels,
        // the label afterwards gets edited, and the ONE entry for known
        // labels gets deleted in HashMap
        // here we check, if the just deleted label 
        // exists somewhere else!
        if (entity.previousType == TYP_LABEL)
            resetLabels();

        return entity;
    }
    private void scanText(String text)
    {
        String[] lines = text.split("\n");
        int c = 0;
        for (String line : lines)
        {
            updateEntity(line+";"+c, line+";"+c);
            c++;
        }
    }
    private static String loadText(String filename)
    {
        try 
        {
            // I know this is "bad", but what the heck,... don't bother tp check for \r\n \r ... myself
            JTextPane jTextPane1 = new JTextPane();
            FileReader fr = new FileReader(filename);
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
    public static ASM6809FileInfo handleFile(String _fullname, String _text)
    {
        ASM6809FileInfo fileInfo = allFileMap.get(_fullname);
        if (fileInfo != null) return fileInfo;
        fileInfo = new ASM6809FileInfo();
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
        fileInfo.scanText(_text);
        allFileMap.put(_fullname, fileInfo);
//        System.out.println("\""+fileInfo.name+"\" loaded!");
        return fileInfo;
    }
    
    // called from colorer
    // if macros/vars have changes
    // at some stage in the future we must recolor all
    // (or remember where each entity was used, which we don't - yet)
    
    // returns labels/macros that are invalidated
    public ArrayList<String> processDocumentChanges(int start, int adjustment, String newCompleteText)
    {
        // negative adjustment means some text was removed
        // positive adjustment, that something was added
        
        // strategy
        // find the lines that habe changed and call
        // update entity with that
        // change our "reference" text accordingly
        // TODO !!!!!
        ArrayList<String> ret = new ArrayList<String>();
        // the hard way, if adj > 1 do the complete thing!
        if (Math.abs(adjustment)> 1)
        {
            // possibly check whether changes are in one line only!
            for (EntityDefinition e: entityArray)
            {
                if (e.type == TYP_LABEL)
                {
                    LabelSink.knownGlobalVariables.remove(e.name.toLowerCase());
                    ret.add(e.name.toLowerCase());
                }
                if (e.type == TYP_MACRO)
                {
                    MacroSink.knownGlobalMacros.remove(e.name.toLowerCase());
                    ret.add(e.name.toLowerCase());
                }
            }
            text.delete(0, text.length());
            text.append(newCompleteText);
            scanText(newCompleteText);
        }
        else
        {
            // test one line change, if something happened to a var/ macro -> also scan the damn doc
            String lineOld = getLineOfChange(start-adjustment, text.toString());
            String lineNew = getLineOfChange(start, newCompleteText.toString());
            
            EntityDefinition entity = updateEntity(lineOld, lineNew);
            if (entity == null) // error
            {
                
            }
            else if (entity.getStatus() != ENTITY_UNCHANGED)
            {
                ret.add(entity.previousName); 
                ret.add(entity.name); 
            }
            text.delete(0, text.length());
            text.append(newCompleteText);
            
        }
        return ret;
    }
    String getLineOfChange(int pos, String t)
    {
        int ret = -1;
        try
        {
            String[] lines = t.toString().split("\n");
            int count = 0;
            int c = -1;
            while (count <= pos+1)
            {
                c++;
                count += lines[c].length()+1; // because of "/n"
            }
            if (c < lines.length) ret = c;
            if (ret == -1) return null;
            return lines[ret]+";"+ret;
        }
        catch (Throwable e)
        {
        }
        return null;
    }    
}
    