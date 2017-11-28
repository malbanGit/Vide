/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.graphics;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.util.XMLSupport;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author malban
 */
public class GFXVectorAnimation 
{    
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    public ArrayList<GFXVectorList> list = new ArrayList<GFXVectorList>();
    public boolean isAnimation = true; // if false it is an Scenario
    
    public GFXVectorAnimation()
    {
    }
    public GFXVectorAnimation(String filename)
    {
        loadFromXML(filename);
    }
    
    // some convenience methods directly to arraylist
    public int size()
    {
        return list.size();
    }
    public void clear()
    {
        list.clear();
    }
    public int getIndexFromUID(int uid)
    {
        if (uid == -1) return -1;
        int i=0;
        for(GFXVectorList v: list)
        {
            if (uid == v.uid) return i;
            i++;
        }
        return -1;
    }
    public boolean replace(GFXVectorList newList, int indexToReplace)
    {
        if (indexToReplace <0) return false;
        if (indexToReplace >=list.size()) return false;
        list.remove(indexToReplace);
        list.add(indexToReplace, newList);
        correctOrder();
        return true;
    }
    
    
    // index, NOT uid
    public GFXVectorList get(int i)
    {
        return list.get(i);
    }
    // remove at index
    public boolean remove(int i)
    {
        list.remove(i);
        return true;
    }
    public boolean remove(GFXVectorList v)
    {
        return list.remove(v);
    }
    public boolean add(GFXVectorList v)
    {
        v.order = getHighestOrder()+1;
        v.uid = v.order;
        return list.add(v);
    }
    public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        ok = ok & XMLSupport.addElement(s, "isAnimation", isAnimation);
        for(GFXVectorList v: list)
        {
            ok = ok & v.toXML(s, "GFXVectorList");
        }
        
        s.append("</").append(tag).append(">\n");
        return ok;        
    }
    // a xml "list" of an arbitrary number of GFXVectors
    public boolean fromXML(String xml, XMLSupport xmlSupport)
    {
        list = new ArrayList<GFXVectorList>();
        int errorCode = 0;
        StringBuilder xmlBuffer = new StringBuilder(xml);
        isAnimation= xmlSupport.getBooleanElement("isAnimation", xmlBuffer);errorCode|=xmlSupport.errorCode;
        StringBuilder oneElement = null;
        do {
            oneElement = xmlSupport.removeTag("GFXVectorList", xmlBuffer);
            if (oneElement==null) break;
            errorCode|=xmlSupport.errorCode;
            GFXVectorList v = new GFXVectorList();
            v.fromXML(oneElement, xmlSupport);
            errorCode|=xmlSupport.errorCode;
            list.add(v);
        } while (true);
        
        correctOrder();
        if (errorCode!= 0) return false;
        return true;
    }
    public boolean saveAsXML(String filename)
    {
        StringBuilder xml = new StringBuilder();
        correctOrder();
        boolean ok = toXML(xml, "VectorAnimation");
        if (!ok)
        {
            log.addLog("VectorAnimation save 'toXML' return false", WARN);
            return false;
        }
        ok = de.malban.util.UtilityFiles.createTextFile(filename, xml.toString());
        if (!ok)
        {
            log.addLog("VectorAnimation create file '"+filename+"' return false", WARN);
            return false;
        }
        return true; 
    }
    public boolean loadFromXML(String filename)
    {
        list.clear();
        
        String xml = de.malban.util.UtilityString.readTextFileToOneString(new File (de.malban.util.UtilityFiles.convertSeperator(filename)));
        boolean ok = fromXML(xml, new XMLSupport());
        if (!ok)
        {
            log.addLog("VectorAnimation load from xml '"+filename+"' return false", WARN);
            return false;
        }
        return true;
    }
    
    // order start with zero and go up in 1 steps
    private void correctOrder()
    {
        int o = 0;
        GFXVectorList v = null;
        do
        {
            v = getLowestOrder(o);
            if (v != null)
            {
                v.order = o++;
            }
        } 
        while (v != null);
    }
    
    // get vlowest vector order, which is at least MIN
    private GFXVectorList getLowestOrder(int min)
    {
        int currentMin = Integer.MAX_VALUE;
        GFXVectorList currentVectorList = null;
        for(GFXVectorList v: list)
        {
            if (v.order >= min) 
            {
                if (v.order<currentMin)
                {
                    currentVectorList = v;
                    currentMin = v.order;
                }
            }
        }
        return currentVectorList;
    }
    private int getHighestOrder()
    {
        int max = -1;
        for(GFXVectorList v: list)
        {
            if (v.order>max) max = v.order;
        }        
        return max;
    }
    public double getMaxAbsValue()
    {
        double max = 0;
        GFXVectorAnimation al = this;
        
        for (int i=0; i< al.size(); i++)
        {
            double vmax = al.get(i).getMaxAbsValue();
            if (max<vmax)  max = vmax;
        }       
        return max;
    }
    public double getMaxAbsLenValue()
    {
        double max = 0;
        GFXVectorAnimation al = this;
        
        for (int i=0; i< al.size(); i++)
        {
            double vmax = al.get(i).getMaxAbsLenValue();
            if (max<vmax)  max = vmax;
        }       
        return max;
    }
    
    
    public void scaleAll(double scale, HashMap<Vertex, Boolean> safetyMap)
    {
        GFXVectorAnimation al = this;
        
        for (int i=0; i< al.size(); i++)
        {
            al.get(i).scaleAll(scale, safetyMap);
        }       
    }
    public boolean isAllSamePattern()
    {
        GFXVectorAnimation al = this;
        for (int i=0; i< al.size(); i++)
        {
            if (!al.get(i).isAllSamePattern()) 
                return false;
        }       
        return true;
    }
    public boolean isCompleteRelative()
    {
        GFXVectorAnimation al = this;
        for (int i=0; i< al.size(); i++)
        {
            if (!al.get(i).isCompleteRelative()) 
                return false;
        }       
        return true;
    }
    public boolean isAllPatternHigh()
    {
        GFXVectorAnimation al = this;
        for (int i=0; i< al.size(); i++)
        {
            if (!al.get(i).isAllPatternHigh()) 
                return false;
        }       
        return true;
    }
    public boolean isOrdered()
    {
        GFXVectorAnimation al = this;
        for (int i=0; i< al.size(); i++)
        {
            if (!al.get(i).isOrdered()) 
                return false;
        }       
        return true;
    }
    
    public boolean isMov_Draw_VLc_a()
    {
        if (!isOrdered())
        {
            log.addLog("isMov_Draw_VLc_a failed, not ordered!", WARN);
            return false;
        }
        if (!isAllSamePattern())
        {
            log.addLog("isMov_Draw_VLc_a failed, not same pattern!", WARN);
            return false;
        }
        if (!isCompleteRelative())
        {
            log.addLog("isMov_Draw_VLc_a failed, not continuos!", WARN);
            return false;
        }
        return true;
    }
    public boolean isDraw_VLc()
    {
        if (!isOrdered())
        {
            log.addLog("isDraw_VLc failed, not ordered!", WARN);
            return false;
        }
        if (!isAllSamePattern())
        {
            log.addLog("isDraw_VLc failed, not same pattern!", WARN);
            return false;
        }
        if (!isCompleteRelative())
        {
            log.addLog("isDraw_VLc failed, not continuos!", WARN);
            return false;
        }
        return true;
        
    }
    public boolean isDraw_VLp()
    {
        if (!isOrdered())
        {
            log.addLog("isDraw_VLp failed, not ordered!", WARN);
            return false;
        }
        if (!isCompleteRelative())
        {
            log.addLog("isDraw_VLp failed, not continuous!", WARN);
            return false;
        }
        if (!isAllPatternHigh())
        {
            log.addLog("isDraw_VLp failed, low patterns found!", WARN);
            return false;
        }
        
        return true;
    }
    public boolean isDraw_VL_mode()
    {
        if (!isOrdered())
        {
            log.addLog("isDraw_VL_mode failed, not ordered!", WARN);
            return false;
        }
        if (!isCompleteRelative())
        {
            log.addLog("isDraw_VL_mode failed, not continuos!", WARN);
            return false;
        }
        return true;
    }
    
    public boolean isDraw_CodeGen()
    {
        if (!isOrdered())
        {
            log.addLog("isDraw_CodeGen failed, not ordered!", WARN);
            return false;
        }
        if (!isCompleteRelative())
        {
            log.addLog("isDraw_CodeGen failed, not continuos!", WARN);
            return false;
        }
        return true;
    }
    public String createASMDraw_VL_mode(String name, boolean includeInitialMove, boolean factor)
    {
        if (!isDraw_VL_mode()) return "";
        StringBuilder source = new StringBuilder();
        StringBuilder table = new StringBuilder();
        GFXVectorAnimation al = this;
        table.append(name).append(":\n");
        
        int count = 0;
        for (GFXVectorList vl : al.list)
        {
            table.append(" "+GFXVectorList.getDW()+" "+name+"_"+count);
            if (count == 0)
                table.append(" ; list of all single vectorlists in this");
            table.append("\n");
            String asm = vl.createASMDraw_VL_mode(name+"_"+count, includeInitialMove, factor);
            if (asm.length() == 0)
            {
                log.addLog("Anim: createASMDraw_VL_mode failed, VL("+count+") returned error!", WARN);
                return "";
            }
            source.append(asm);
            
            count++;
        }
        table.append("\n");
        table.append(source);
        String text = table.toString();
        return text;        
    }
    public String createCDraw_VL_mode(String name, boolean includeInitialMove, boolean factor)
    {
        if (!isDraw_VL_mode()) return "";
        StringBuilder source = new StringBuilder();
        StringBuilder table = new StringBuilder();
        GFXVectorAnimation al = this;
        table.append("const signed char* const "+name).append("[]=\n{");
        
        int count = 0;
        for (GFXVectorList vl : al.list)
        {
            table.append("\t "+name+"_"+count);
            if (count == 0)
                table.append(", // list of all single vectorlists in this\n");
            else
                table.append(",\n");
            String asm = vl.createCDraw_VL_mode(name+"_"+count, includeInitialMove, factor, false);
            if (asm.length() == 0)
            {
                log.addLog("Anim: createCDraw_VL_mode failed, VL("+count+") returned error!", WARN);
                return "";
            }
            source.append(asm);
            
            count++;
        }
        table.append("};\n");
        return source.toString()+"\n"+table.toString();        
    }
    public String createASMDraw_VLc(String name, boolean factor)
    {
        if (!isDraw_VLc()) return "";
        StringBuilder source = new StringBuilder();
        StringBuilder table = new StringBuilder();
        GFXVectorAnimation al = this;
        table.append(name).append(":\n");
        
        int count = 0;
        for (GFXVectorList vl : al.list)
        {
            table.append(" "+GFXVectorList.getDW()+" "+name+"_"+count);
            if (count == 0)
                table.append(" ; list of all single vectorlists in this");
            table.append("\n");
            String asm = vl.createASMMov_Draw_VLc_a(false, name+"_"+count, factor);
            if (asm.length() == 0)
            {
                log.addLog("Anim: createASMDraw_VLc failed, VL("+count+") returned error!", WARN);
                return "";
            }
            source.append(asm);
            
            count++;
        }
        table.append("\n");
        table.append(source);
        String text = table.toString();
        return text;        
    }    
    
    
    public String createCDraw_VLc(String name, boolean factor)
    {
        if (!isDraw_VLc()) return "";
        StringBuilder source = new StringBuilder();
        StringBuilder table = new StringBuilder();
        GFXVectorAnimation al = this;
        table.append("const signed char* const "+name).append("[]=\n{");
        
        int count = 0;
        for (GFXVectorList vl : al.list)
        {
            table.append("\t "+name+"_"+count);
            if (count == 0)
                table.append(", // list of all single vectorlists in this\n");
            else
                table.append(",\n");
            String asm = vl.createCMov_Draw_VLc_a(false, name+"_"+count, factor, false);
            if (asm.length() == 0)
            {
                log.addLog("Anim: createCDraw_VLc failed, VL("+count+") returned error!", WARN);
                return "";
            }
            source.append(asm);
            
            count++;
        }
        table.append("};\n");
        return source.toString()+"\n"+table.toString();        
    }    
    public String createCMov_Draw_VLc_a(String name, boolean factor)
    {
        if (!isMov_Draw_VLc_a()) return "";
        StringBuilder source = new StringBuilder();
        StringBuilder table = new StringBuilder();
        GFXVectorAnimation al = this;

        table.append("const signed char* const "+name).append("[]=\n{");
        
        int count = 0;
        for (GFXVectorList vl : al.list)
        {
            table.append("\t "+name+"_"+count);
            if (count == 0)
                table.append(", // list of all single vectorlists in this\n");
            else
                table.append(",\n");
            String asm = vl.createCMov_Draw_VLc_a(true, name+"_"+count, factor, false);
            if (asm.length() == 0)
            {
                log.addLog("Anim: createCMov_Draw_VLc_a failed, VL("+count+") returned error!", WARN);
                return "";
            }
            source.append(asm);
            count++;
        }
        table.append("};\n");
        return source.toString()+"\n"+table.toString();        
    }  
    public String createASMMov_Draw_VLc_a(String name, boolean factor)
    {
        if (!isMov_Draw_VLc_a()) return "";
        StringBuilder source = new StringBuilder();
        StringBuilder table = new StringBuilder();
        GFXVectorAnimation al = this;
        table.append(name).append(":\n");
        
        int count = 0;
        for (GFXVectorList vl : al.list)
        {
            table.append(" "+GFXVectorList.getDW()+" "+name+"_"+count);
            if (count == 0)
                table.append(" ; list of all single vectorlists in this");
            table.append("\n");
            String asm = vl.createASMMov_Draw_VLc_a(true, name+"_"+count, factor);
            if (asm.length() == 0)
            {
                log.addLog("Anim: createASMMov_Draw_VLc_a failed, VL("+count+") returned error!", WARN);
                return "";
            }
            source.append(asm);
            
            count++;
        }
        table.append("\n");
        table.append(source);
        String text = table.toString();
        return text;        
    }        
    public String createCDraw_VLp(String name, boolean factor)
    {
        if (!isDraw_VLp()) return "";
        StringBuilder source = new StringBuilder();
        StringBuilder table = new StringBuilder();
        GFXVectorAnimation al = this;
        table.append("const signed char* const "+name).append("[]=\n{");
        
        int count = 0;
        for (GFXVectorList vl : al.list)
        {
            table.append("\t "+name+"_"+count);
            if (count == 0)
                table.append(", // list of all single vectorlists in this\n");
            else
                table.append(",\n");
            String asm = vl.createCDraw_VLp(name+"_"+count, factor);
            if (asm.length() == 0)
            {
                log.addLog("Anim: createCDraw_VLp failed, VL("+count+") returned error!", WARN);
                return "";
            }
            source.append(asm);
            
            count++;
        }
        table.append("};\n");
        return source.toString()+"\n"+table.toString();        
    }    
    
    public String createASMDraw_VLp(String name, boolean factor)
    {
        if (!isDraw_VLp()) return "";
        StringBuilder source = new StringBuilder();
        StringBuilder table = new StringBuilder();
        GFXVectorAnimation al = this;
        table.append(name).append(":\n");
        
        int count = 0;
        for (GFXVectorList vl : al.list)
        {
            table.append(" "+GFXVectorList.getDW()+" "+name+"_"+count);
            if (count == 0)
                table.append(" ; list of all single vectorlists in this");
            table.append("\n");
            String asm = vl.createASMDraw_VLp(name+"_"+count, factor);
            if (asm.length() == 0)
            {
                log.addLog("Anim: createASMDraw_VLp failed, VL("+count+") returned error!", WARN);
                return "";
            }
            source.append(asm);
            
            count++;
        }
        table.append("\n");
        table.append(source);
        String text = table.toString();
        return text;        
    }
    
    public boolean createCDraw_syncList(StringBuilder table, String name, boolean factor, int resync, int splitter)
    {
        return createCDraw_syncList(table,name, factor, resync, false, splitter);
    }
    public boolean createASMDraw_syncList(StringBuilder table, String name, boolean factor, int resync, int splitter)
    {
        return createASMDraw_syncList(table,name, factor, resync, false, splitter);
    }
    public boolean createASMDraw_syncList(StringBuilder table, String name, boolean factor, int resync, boolean extended, int splitter)
    {
        return createASMDraw_syncList(table, name,  factor,  resync,  extended,  splitter, false,  "BLOW_UP");
    }
    public boolean createCDraw_syncList(StringBuilder table, String name, boolean factor, int resync, boolean extended, int splitter)
    {
        return createCDraw_syncList(table, name,  factor,  resync,  extended,  splitter, false,  "BLOW_UP");
    }
    public boolean createASMDraw_syncList(StringBuilder table, String name, boolean factor, int resync, boolean extended, int splitter, boolean noAdditionalOptimization)
    {
        return createASMDraw_syncList(table, name,  factor,  resync,  extended,  splitter,  noAdditionalOptimization,  "BLOW_UP");
    }
    public boolean createCDraw_syncList(StringBuilder table, String name, boolean factor, int resync, boolean extended, int splitter, boolean noAdditionalOptimization)
    {
        return createCDraw_syncList(table, name,  factor,  resync,  extended,  splitter,  noAdditionalOptimization,  "BLOW_UP");
    }

    public boolean createASMDraw_syncList(StringBuilder table, String name, boolean factor, int resync, boolean extended, int splitter, boolean noAdditionalOptimization, String blowString)
    {
        StringBuilder source = new StringBuilder();
        GFXVectorAnimation al = this;
        table.append(name).append(":\n");
        
        int count = 0;
        for (GFXVectorList vl : al.list)
        {
            table.append(" "+GFXVectorList.getDW()+" "+name+"_"+count);
            if (count == 0)
                table.append(" ; list of all single vectorlists in this");
            table.append("\n");
            
            boolean genOk = vl.createASMDraw_syncList(source, name+"_"+count, factor, resync, extended, splitter, noAdditionalOptimization,blowString);
            if (!genOk)
            {
                log.addLog("Anim: createASMDraw_syncList failed, VL("+count+") returned error!", WARN);
                return false;
            }
            
            count++;
        }
        table.append(" DW 0\n\n");
        table.append(source);
        return true;        
    }
    
    public boolean createCDraw_syncList(StringBuilder table, String name, boolean factor, int resync, boolean extended, int splitter, boolean noAdditionalOptimization, String blowString)
    {
        StringBuilder source = new StringBuilder();
        GFXVectorAnimation al = this;
        table.append("const signed char* const "+name).append("[]=\n{");
        
        int count = 0;
        for (GFXVectorList vl : al.list)
        {
            table.append("\t "+name+"_"+count);
            if (count == 0)
                table.append(", // list of all single vectorlists in this\n");
            else
                table.append(",\n");
            
            boolean genOk = vl.createCDraw_syncList(source, name+"_"+count, factor, resync, extended, splitter, noAdditionalOptimization,blowString);
            if (!genOk)
            {
                log.addLog("Anim: createCDraw_syncList failed, VL("+count+") returned error!", WARN);
                return false;
            }
            
            count++;
        }
        table.append("};\n");
        
        table.insert(0, source.toString());
//        table.append(source);
//        String text = table.toString();
        return true;        
    }    
    
    public String createASMCodeGen(String name)
    {
        if (!isDraw_CodeGen()) return "";
        StringBuilder source = new StringBuilder();
        StringBuilder table = new StringBuilder();
        GFXVectorAnimation al = this;
        table.append(name).append(":\n");
        
        int count = 0;
        for (GFXVectorList vl : al.list)
        {
            table.append(" "+GFXVectorList.getDW()+" "+name+"_"+count);
            if (count == 0)
                table.append(" ; list of all single vectorlists in this");
            table.append("\n");
            String asm = vl.createASMCodeGen(name+"_"+count);
            if (asm.length() == 0)
            {
                log.addLog("Anim: createASMCodeGen failed, VL("+count+") returned error!", WARN);
                return "";
            }
            source.append(asm);
            
            count++;
        }
        table.append("\n");
        table.append(source);
        String text = table.toString();
        return text;       
    }    
    
    
}
