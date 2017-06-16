/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util.syntax.entities;

import static de.malban.util.syntax.entities.EntityDefinition.SUBTYPE_MACRO_DEFINITION_LABEL;
import static de.malban.util.syntax.entities.EntityDefinition.TYP_INCLUDE;
import static de.malban.util.syntax.entities.EntityDefinition.TYP_LABEL;
import static de.malban.util.syntax.entities.EntityDefinition.TYP_MACRO;
import static de.malban.util.syntax.entities.EntityDefinition.removeComment;
import de.malban.vide.vedi.EditorPanel;
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

    private static int inUpdate = 0;
    private static boolean inReset = false;
    
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
    
    private ASM6809FileInfo(){}
    
    public static void replaceFileName(String oldFileName, String newFileName)
    {
        inUpdate++;
        
        String oldkey = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeAbsolut(oldFileName)).toLowerCase();
        String newkey = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeAbsolut(newFileName)).toLowerCase();
        
        
        
        
        ASM6809FileInfo fileInfo = allFileMap.get(oldkey);
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
    public static void resetDefinitions(String filename, String text)
    {
        if (inUpdate>0) return;
        inUpdate++;
        inReset=true;
        String key = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeAbsolut(filename)).toLowerCase();
        allFileMap.remove(key);
        handleFile(filename, text);
        inReset=false;
        inUpdate--;
    }
    public static void resetDefinitions()
    {
        if (inUpdate>0) return;
        inUpdate++;
        LabelSink.knownGlobalVariables = new HashMap<String, EntityDefinition>();
        MacroSink.knownGlobalMacros = new HashMap<String, EntityDefinition>();
        HashMap<String, ASM6809FileInfo> oldAllFileMap = allFileMap;
        allFileMap = null;
        allFileMap = new HashMap<String, ASM6809FileInfo>();

        Set entries = oldAllFileMap.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            ASM6809FileInfo value = (ASM6809FileInfo) entry.getValue();
            String key = (String) entry.getKey();
            
            ASM6809FileInfo.handleFile(value.fullName, null);
        }
        inUpdate--;
    }
    public static void clearDefinitions()
    {
        LabelSink.knownGlobalVariables = new HashMap<String, EntityDefinition>();
        MacroSink.knownGlobalMacros = new HashMap<String, EntityDefinition>();
        allFileMap = new HashMap<String, ASM6809FileInfo>();;
    }
    
    public static void resetToProject(File mainFile)
    {
        clearDefinitions();
        handleFile(mainFile.getAbsolutePath(), null);
    }
    
    public String toString()
    {
        return fullName;
    }
    
    // is the "calling" entity in a struct
    // has any of the previous lines a "struct" open
    // (and not closed?)
    boolean inMacro(EntityDefinition entity)
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
            if (e.isMacroEnd) return false;
            if (e.isMacroStart) 
                return true;
        }
        return false;
    }
    
    
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
    
    // returns true if the label is the first line label in the file
    // or if the last non empty line befor was
    // data (db, ds, dw, fcb...)
    // bra
    // lbra
    // jmp
    // rts
    // rti
    protected boolean isPureFunctionCallLabel(EntityDefinition entity)
    {
        // assuming
        int checkingLineInText = entity.getLineNumber()-1;
        String[] lines = text.toString().split("\n");

        for (int l = checkingLineInText-1; l>=0; l--)
        {
            String line = lines[l].toLowerCase();
            line = removeComment(line, ";");
            line = removeComment(line, "*");
            line = de.malban.util.UtilityString.replaceWhiteSpaces(line, " ");
            if (line.trim().length() == 0) continue;
            if (line.contains(" db ")) return true;
            if (line.contains(" dw ")) return true;
            if (line.contains(" ds ")) return true;
            if (line.contains(" fcc ")) return true;
            if (line.contains(" fcb ")) return true;
            if (line.contains(" fdb ")) return true;
            if (line.contains(" rmb ")) return true;
            if (line.contains(" rts")) return true;
            if (line.contains(" rti")) return true;
            if (line.contains(" jmp ")) return true;
            if (line.contains(" bra ")) return true;
            if (line.contains(" lbra ")) return true;
            if (line.contains(" endm")) return true;
            if (line.contains(" end")) return true;
            if (line.contains(" org")) return true;
            if (line.contains(" code")) return true;
            if (line.contains(" include")) return true;
            if (line.contains(" equ ")) continue;
            if (line.contains("=")) continue;
            return false;
        }
        // beginning of file reached
        return true;
    }
    protected boolean isDataLabel(EntityDefinition entity)
    {
        // assuming
        int checkingLineInText = entity.getLineNumber()-1;
        String[] lines = text.toString().split("\n");

        for (int l = checkingLineInText; l<lines.length; l++)
        {
            String line = lines[l].toLowerCase();
            line = removeComment(line, ";");
            line = removeComment(line, "*");
            line = removeLeadingChars(line);
            if (line.trim().length() == 0) continue;
            if (line.contains(" db ")) return true;
            if (line.contains(" dw ")) return true;
            if (line.contains(" ds ")) return true;
            if (line.contains(" fcc ")) return true;
            if (line.contains(" fcb ")) return true;
            if (line.contains(" fdb ")) return true;
            if (line.contains(" rmb ")) return true;
            return false;
        }
        // end of file reached
        return false;
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
    
    synchronized void  resetLabels()
    {
        Set entries = lineEntityMap.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            EntityDefinition value = (EntityDefinition) entry.getValue();
            String key = (String) entry.getKey();
            synchronized (LabelSink.knownGlobalVariables)
            {
                LabelSink.knownGlobalVariables.remove(value.name);
                LabelSink.knownGlobalVariables.put(value.name, value);
            }
        }

        
    }
    
    // redo complete text (no includes)
    void reset()
    {
       for (EntityDefinition e: entityArray)
       {
            if (e.type == TYP_MACRO)
            {
                MacroSink.knownGlobalMacros.remove(e.name);
                for (String n: e.parameter)
                    MacroSink.knownGlobalMacros.remove(n);
            }
            if (e.type == TYP_LABEL)
            {
                synchronized (LabelSink.knownGlobalVariables)
                {
                    LabelSink.knownGlobalVariables.remove(e.name);
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
            if (entity.previousType == TYP_MACRO)
            {
                MacroSink.knownGlobalMacros.remove(entity.previousName);
                if (entity.previousParameter!=null)
                {
                    for (String n: entity.previousParameter)
                        MacroSink.knownGlobalMacros.remove(n);
                }
            }
            if (entity.previousType == TYP_LABEL)
            {
                synchronized (LabelSink.knownGlobalVariables)
                {
                    LabelSink.knownGlobalVariables.remove(entity.previousName);
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
            if (entity.type == TYP_MACRO)
            {
                entity.subtype = SUBTYPE_MACRO_DEFINITION_LABEL;
                MacroSink.knownGlobalMacros.put(entity.name, entity);
                if (entity.parameter!=null)
                {
                    for (String n: entity.parameter)
                    {
                        if (!n.trim().toLowerCase().equals("macro"))
                            MacroSink.knownGlobalMacros.put(n, entity);
                    }
                }
            }
            else if (entity.type == TYP_LABEL)
            {
                synchronized (LabelSink.knownGlobalVariables)
                {
                    LabelSink.knownGlobalVariables.put(entity.name, entity);
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
                if (inReset)
                {
        String key = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeAbsolut(newFilename)).toLowerCase();
        allFileMap.remove(key);
                }
                
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
    private synchronized void scanText(String text)
    {
        String[] lines = text.split("\n");
        int c = 0;
        for (String line : lines)
        {
            updateEntity(line+";"+c, line+";"+c);
            c++;
        }
    }
    
    private int getLineCount(String text)
    {
        if (text == null) return 0;
        return text.split("\n").length;
    }
    
    private static String loadText(String filename)
    {
        try 
        {
            filename = de.malban.util.UtilityFiles.convertSeperator(filename);
            String edited = EditorPanel.getTextForFile(filename);
            if (edited != null) return edited;
            
            
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
    
    
    // called from colorer
    // if macros/vars have changes
    // at some stage in the future we must recolor all
    // (or remember where each entity was used, which we don't - yet)
    
    // returns labels/macros that are invalidated
    public synchronized ArrayList<String> processDocumentChanges(int start, int adjustment, String newCompleteText)
    {
        inUpdate++;
        ArrayList<String> ret = new ArrayList<String>();
        if (lineCount != getLineCount(newCompleteText))
        {
            text.delete(0, text.length());
            text.append(newCompleteText);
            lineCount = getLineCount(newCompleteText);
            reset();
            inUpdate--;
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
                if (e.type == TYP_LABEL)
                {
                    synchronized (LabelSink.knownGlobalVariables)
                    {
                        LabelSink.knownGlobalVariables.remove(e.name);
                    }
                    ret.add(e.name);
                }
                if (e.type == TYP_MACRO)
                {
                    MacroSink.knownGlobalMacros.remove(e.name);
                    ret.add(e.name);
                }
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
                            if (e.type == TYP_LABEL)
                            {
                                synchronized (LabelSink.knownGlobalVariables)
                                {
                                    LabelSink.knownGlobalVariables.remove(e.name);
                                }
                                ret.add(e.name);
                            }
                            if (e.type == TYP_MACRO)
                            {
                                MacroSink.knownGlobalMacros.remove(e.name);
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
        inUpdate--;
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
    // document text, line seperated by "\n"
    // if text is null, it will try to load text thru a document
    // to be on the save side of line end definitions
    public static ASM6809FileInfo handleFile(String _fullname, String _text)
    {
        String key = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeAbsolut(_fullname)).toLowerCase();
        ASM6809FileInfo fileInfo = allFileMap.get(key);
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
        fileInfo.lineCount = fileInfo.getLineCount(_text);
        fileInfo.scanText(_text);
        allFileMap.put(key, fileInfo);
//        System.out.println("\""+fileInfo.name+"\" loaded!");
        return fileInfo;
    }
}
    