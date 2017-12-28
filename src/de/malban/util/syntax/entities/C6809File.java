/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util.syntax.entities;

import de.malban.Global;
import static de.malban.util.syntax.entities.ASM6809File.ENTITY_CHANGED;
import static de.malban.util.syntax.entities.ASM6809File.ENTITY_DELETED;
import static de.malban.util.syntax.entities.ASM6809File.ENTITY_UNCHANGED;
import static de.malban.util.syntax.entities.EntityDefinition.TYP_CFUNCTION;
import static de.malban.util.syntax.entities.EntityDefinition.TYP_INCLUDE;
import static de.malban.util.syntax.entities.EntityDefinition.TYP_LABEL;
import static de.malban.util.syntax.entities.EntityDefinition.TYP_LIB_INCLUDE;
import static de.malban.util.syntax.entities.EntityDefinition.TYP_MACRO;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author malban
 */
public class C6809File
{
    String fullName; // full path an filename
    String path; // only path, like Path(fullName).getParent()
    String name; // only filename
    StringBuffer text; // complete contents of the denoted file as a stringbuffer
    int lineCount = 0;
    ArrayList<EntityDefinition> entityArray = new ArrayList<EntityDefinition>();
    
    // since we store definitions of "something" 
    // the line itself is chosen as a hashmap key
    // in a "correct" file, defintion lines won't be double,
    // if so, there might be "line errors"
    HashMap<String, EntityDefinition> lineEntityMap = new HashMap<String, EntityDefinition>();
    C6809FileMaster master;
    C6809File(C6809FileMaster m)
    {
        master = m;
    }
    
    public String toString()
    {
        return fullName;
    }
    
    // if a line starts with a label - remove it, up to first "SPACE"
    // also replaces all whitespaces with space
    String removeLeadingChars(String line)
    {
        line = de.malban.util.UtilityString.replaceWhiteSpaces(line, " ");
        if (line.startsWith(" ")) return line;
        String[] splitter = line.split(" ");
        String result = "";
        for (int i=1; i<splitter.length; i++)
        {
            result+=" " + splitter[i];
        }
        return result;
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
    
    synchronized void  resetFunctions()
    {
        Set entries = lineEntityMap.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            EntityDefinition value = (EntityDefinition) entry.getValue();
            String key = (String) entry.getKey();
            synchronized (master.knownGlobalFunctions)
            {
                if (master.knownGlobalFunctions.containsKey(value.name))
                {
                    EntityDefinition entityGlobal = master.knownGlobalFunctions.get(value.name);
                    if (value.cfile.fullName.equals(entityGlobal.cfile.fullName))
                    {
                        master.knownGlobalFunctions.remove(value.name);
                        master.knownGlobalFunctions.put(value.name, value);
                    }
                }
                else
                {
                    master.knownGlobalFunctions.remove(value.name);
                    master.knownGlobalFunctions.put(value.name, value);
                }
            }
        }

        
    }
    
    // redo complete text (no includes)
    void reset()
    {
       for (EntityDefinition e: entityArray)
       {
            if (e.type == TYP_CFUNCTION)
            {
                synchronized (master.knownGlobalFunctions)
                {
                    if (master.knownGlobalFunctions.containsKey(e.name))
                    {
                        EntityDefinition entityGlobal = master.knownGlobalFunctions.get(e.name);
                        if (e.cfile.fullName.equals(entityGlobal.cfile.fullName))
                            master.knownGlobalFunctions.remove(e.name);
                    }
                    
                    
                }
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
    private synchronized EntityDefinition updateEntity(String oldLine, String line)
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
            if (entity.previousType == TYP_CFUNCTION)
            {
                synchronized (master.knownGlobalFunctions)
                {
                    if (master.knownGlobalFunctions.containsKey(entity.previousName))
                    {
                        EntityDefinition entityGlobal = master.knownGlobalFunctions.get(entity.previousName);
                        if (entity.cfile.fullName.equals(entityGlobal.cfile.fullName))
                        {
                            master.knownGlobalFunctions.remove(entity.previousName);
                        }
                    }
                }
            }
            if (entity.previousType == TYP_MACRO)
            {
                master.knownGlobalFunctions.remove(entity.previousName);
                if (entity.previousParameter!=null)
                {
                    for (String n: entity.previousParameter)
                        master.knownGlobalFunctions.remove(n);
                }
            }
            if (entity.previousType == TYP_LABEL)
            {
                master.knownGlobalFunctions.remove(entity.previousName);
                if (entity.previousParameter!=null)
                {
                    for (String n: entity.previousParameter)
                        master.knownGlobalFunctions.remove(n);
                }
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
            if (entity.type == TYP_CFUNCTION)
            {
                synchronized (master.knownGlobalFunctions)
                {
                    if (!master.knownGlobalFunctions.containsKey(entity.previousName))
                        master.knownGlobalFunctions.put(entity.name, entity);
                }
            }
            if (entity.type == TYP_MACRO)
            {
                synchronized (master.knownGlobalFunctions)
                {
                    master.knownGlobalFunctions.put(entity.name, entity);
                }
            }
            if (entity.type == TYP_LABEL)
            {
                synchronized (master.knownGlobalFunctions)
                {
                    master.knownGlobalFunctions.put(entity.name, entity);
                }
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
                if (master.inReset)
                {
                    String key = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeAbsolut(newFilename)).toLowerCase();
                    master.allFileMap.remove(key);
                }
                
                // todo circumvent circlular includes
                // now they throw an stack overflow!
                if (!newFilename.equals(fullName))
                    master.handleFile(newFilename, null);
            }
            if (entity.type == TYP_LIB_INCLUDE)
            {
                String newFilename ="";
                
//                if (hasFramePointer)
//                {
                    newFilename = de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"C/PeerC/vectrex/include/"+entity.name);
//                }
//                else
//                {
//                    newFilename = de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"C/PeerC/vectrex/include.nf/"+entity.name);
//                }
                    
                if (master.inReset)
                {
                    String key = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeAbsolut(newFilename)).toLowerCase();
                    master.allFileMap.remove(key);
                }
                // todo circumvent circlular includes
                // now they throw an stack overflow!
                if (!newFilename.equals(fullName))
                   master.handleFile(newFilename, null);
                
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
//        if (entity.previousType == TYP_LABEL)
//            resetLabels();

        return entity;
    }
    synchronized void scanText(String text)
    {
        String[] lines = text.split("\n");
        int c = 0;
        for (String line : lines)
        {
            updateEntity(line+";"+c, line+";"+c);
            c++;
        }
    }
    
    int getLineCount(String text)
    {
        if (text == null) return 0;
        return text.split("\n").length;
    }
    
    // called from colorer
    // if macros/vars have changes
    // at some stage in the future we must recolor all
    // (or remember where each entity was used, which we don't - yet)
    
    // returns labels/macros that are invalidated
    public synchronized ArrayList<String> processDocumentChanges(int start, int adjustment, String newCompleteText)
    {
        master.inUpdate++;
        ArrayList<String> ret = new ArrayList<String>();
        if (lineCount != getLineCount(newCompleteText))
        {
            text.delete(0, text.length());
            text.append(newCompleteText);
            lineCount = getLineCount(newCompleteText);
            reset();
            master.inUpdate--;
            return null;
        }
            
        // negative adjustment means some text was removed
        // positive adjustment, that something was added
        
        // strategy
        // find the lines that have changed and call
        // update entity with that
        // change our "reference" text accordingly
        // TODO !!!!!
        // the hard way, if adj > 1 do the complete thing!
        if (Math.abs(adjustment)> 1)
        {
            // possibly check whether changes are in one line only!
            for (EntityDefinition e: entityArray)
            {
                if (e.type == TYP_CFUNCTION)
                {
                    synchronized (master.knownGlobalFunctions)
                    {
                        if (master.knownGlobalFunctions.containsKey(e.name))
                        {
                            EntityDefinition entityGlobal = master.knownGlobalFunctions.get(e.name);
                            if (e.cfile.fullName.equals(entityGlobal.cfile.fullName))
                            {
                                master.knownGlobalFunctions.remove(e.name);
                                ret.add(e.name);
                            }
                        }
                    }
                }
                if (e.type == TYP_MACRO)
                {
                    master.knownGlobalFunctions.remove(e.name);
                    ret.add(e.name);
                }
                if (e.type == TYP_LABEL)
                {
                    master.knownGlobalFunctions.remove(e.name);
                    ret.add(e.name);
                }
                /*
                if (e.type == TYP_LABEL)
                {
                    synchronized (LabelSink.knownGlobalVariables)
                    {
                        LabelSink.knownGlobalVariables.remove(e.name);
                    }
                    ret.add(e.name);
                }
                        */
            }
            text.delete(0, text.length());
            text.append(newCompleteText);
            lineCount = getLineCount(newCompleteText);
            scanText(newCompleteText);
        }
        else
        {
            // test one line change, if something happened to a var/ macro -> also scan the damn doc
            String lineOld = getLineOfChange(start-adjustment, text.toString());
            String lineNew = getLineOfChange(start, newCompleteText.toString());
            boolean done = false;
            if (adjustment == 1) // only one char dif
            {
                String[] sp1 = lineOld.split(";");
                String[] sp2 = lineNew.split(";");
                if ((sp1.length>0) && (sp2.length>0))
                {
                    if (!(sp1[sp1.length-1].equals((sp2[sp2.length-1]))))
                    {
                        // if different line numbers - than probably only a "return" happened
                        for (EntityDefinition e: entityArray)
                        {
                            if (e.type == TYP_CFUNCTION)
                            {
                                synchronized (master.knownGlobalFunctions)
                                {
                                    if (master.knownGlobalFunctions.containsKey(e.name))
                                    {
                                        EntityDefinition entityGlobal = master.knownGlobalFunctions.get(e.name);
                                        if (e.cfile.fullName.equals(entityGlobal.cfile.fullName))
                                        {
                                            master.knownGlobalFunctions.remove(e.name);
                                            ret.add(e.name);
                                        }
                                    }
                                }
                            }
                            if (e.type == TYP_MACRO)
                            {
                                synchronized (master.knownGlobalFunctions)
                                {
                                    master.knownGlobalFunctions.remove(e.name);
                                }
                                ret.add(e.name);
                            }
                            if (e.type == TYP_LABEL)
                            {
                                synchronized (master.knownGlobalFunctions)
                                {
                                    master.knownGlobalFunctions.remove(e.name);
                                }
                                ret.add(e.name);
                            }
                        }
                        text.delete(0, text.length());
                        text.append(newCompleteText);
                        lineCount = getLineCount(newCompleteText);
                        scanText(newCompleteText);
                        done = true;
                    }
                }
            }
            
            // one line change
            if (!done)
            {
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
                lineCount = getLineCount(newCompleteText);
            }
        }
        master.inUpdate--;
        return ret;
    }
    String getLineOfChangeNo(int lineNo, String t)
    {
        try
        {
            String[] lines = t.toString().split("\n");
            return lines[lineNo];
        }
        catch (Throwable e)
        {
        }
        return null;
    }    
    // pos = position in String
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
    