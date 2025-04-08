/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.dissy;

import de.malban.util.syntax.Syntax.TokenStyles;
import de.malban.util.UtilityString;
import de.malban.vide.VideConfig;
import static de.malban.vide.dissy.DASMStatics.pgpointers;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_DECIMAL;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_UNKOWN;
import de.malban.vide.vecx.Profiler;
import de.malban.vide.vecx.VecXPanel;
import java.awt.Color;
import java.util.ArrayList;
import javax.security.auth.login.Configuration;
import javax.swing.table.AbstractTableModel;
import javax.swing.text.AttributeSet;
import javax.swing.text.StyleConstants;

/**
 *
 * @author malban
 */
public class MemoryInformationTableModel extends AbstractTableModel
{
    public void initVisibity()
    {
        for (int i=0; i<columnVisibleALL.length; i++ )
        {
            columnVisible[i] = columnVisibleALL[i];
        }
        if (smallMode)
        {
            for (int i=5; i<columnVisibleALL.length; i++ )
            {
                columnVisible[i] = false;
            }
            columnVisible[6] = columnVisibleALL[6];
            columnVisible[7] = columnVisibleALL[7];
            columnVisible[10] = columnVisibleALL[10];
        }
    }
        
    VideConfig config = VideConfig.getConfig();
    DissiPanel dissi = null;
    
    public Profiler profiler = null;
    
    public static Boolean[] columnVisibleALL = {true, true,true, true,true,true, true,true, true, true,true ,true, true, true, true, true};
    public Boolean[] columnVisible =           {true, true,true, true,true,true, true,true, true, true,true ,true, true, true, true, true};
    public static int[] columnWidthSmall =    {20       , 50    , 150      , 30        , 100       ,10       ,20};
    public static int[] columnWidth =    {10       , 100     , 150      , 30        , 100   ,  10      ,10      , 50   , 30        , 50    , 10      , 150    , 5, 10, 10, 10};
    public static boolean wasInit = false;
    
    private boolean smallMode = false;
//    String[] columnNamesSmall = {"Address", "Label", "Content", "Mnemonic","Operand", "Cycles", "Mode","Length"};
    String[] columnNamesSmall = {"Address", "Label","Content", "Mnemonic", "Operand", "Page", "Cycles", "Mode", "->Address", "Type","Length" ,"Comments", "DP","PR access","PR cycles","Pr csum"};
    String[] columnNames =      {"Address", "Label","Content", "Mnemonic", "Operand", "Page", "Cycles", "Mode", "->Address", "Type","Length" ,"Comments", "DP","PR access","PR cycles","Pr csum"};
    private ArrayList<MemoryInformation> visible = new ArrayList<MemoryInformation>();
    Memory orgData = null; // this is NO copy, this is a reference to the DASM memory map!

    String highLightLabel = "";
    String highLightClick = "";

    public Memory getOrgData()
    {
        return orgData;
    }
    boolean fullDisplay = true;
    public void setFullDisplay(boolean b)
    {
        fullDisplay = b;
    }
    public static MemoryInformationTableModel createModel(Memory mem)
    {
        MemoryInformationTableModel model = new MemoryInformationTableModel();
        // new models reset visiblilty!   
        model.orgData = mem;
        model.showAll();
        return model;
    }
    
    public void showAll()
    {
        visible.clear();
        int addedIndex = 0;
        for (int i=0; i<65536; i++)
        {
            MemoryInformation memInfo = orgData.memMap.get(i);
            if (memInfo != null)
            {
                if (memInfo.cInfo != null)
                {
                    visible.add(memInfo);
                    memInfo.cInfoRow = addedIndex;
                    addedIndex++;
                }
                visible.add(memInfo);
                memInfo.myRow = addedIndex;
                addedIndex++;
            }
        }
    }
    public void reduceBIOS()
    {
        ArrayList<MemoryInformation> visibleNew = new ArrayList<MemoryInformation>();
        int addCount = 0;
        for (int i=0; i<visible.size(); i++)
        {
            if (visible.get(i).address < 0xe000)
            {
                MemoryInformation info = visible.get(i);
                if(info.isCInfo())
                {
                    visibleNew.add(info);
                    info.cInfoRow = addCount;
                    info.myRow = addCount;
                    addCount++;
                    
                    MemoryInformation info2 = visible.get(i+1);
                    if (info == info2)
                    {
                        visibleNew.add(info);
                        i++;
                        info.myRow = addCount;
                        addCount++;
                    }
                    continue;
                }
                visibleNew.add(info);
                info.myRow = addCount;
                addCount++;
            }
        }
        visible = visibleNew;
    }
    public void reduceUnkown()
    {
        ArrayList<MemoryInformation> visibleNew = new ArrayList<MemoryInformation>();
        int addCount =0 ;
        for (int i=0; i<visible.size(); i++)
        {
            if (visible.get(i).disType != MemoryInformation.DIS_TYPE_UNKOWN)
            {
                MemoryInformation info = visible.get(i);
                if(info.isCInfo())
                {
                    visibleNew.add(info);
                    info.cInfoRow = addCount;
                    info.myRow = addCount;
                    addCount++;
                    
                    MemoryInformation info2 = visible.get(i+1);
                    if (info == info2)
                    {
                        visibleNew.add(info);
                        i++;
                        info.myRow = addCount;
                        addCount++;
                    }
                    continue;
                }
                visibleNew.add(info);
                info.myRow = addCount;
                addCount++;
            }
        }
        visible = visibleNew;
    }
    
    public void reduceInvisible()
    {
        ArrayList<MemoryInformation> visibleNew = new ArrayList<MemoryInformation>();
        int addCount =0;
        for (int i=0; i<visible.size(); i++)
        {
            if (visible.get(i).visible)
            {
                MemoryInformation info = visible.get(i);
                if(info.isCInfo())
                {
                    visibleNew.add(info);
                    info.cInfoRow = addCount;
                    info.myRow = addCount;
                    addCount++;
                    
                    MemoryInformation info2 = visible.get(i+1);
                    if (info == info2)
                    {
                        visibleNew.add(info);
                        i++;
                        info.myRow = addCount;
                        addCount++;
                    }
                    continue;
                }
                visibleNew.add(info);
                info.myRow = addCount;
                addCount++;
                
            }
        }
        visible = visibleNew;
    }
    
    public void reduceCompleteInstructions()
    {
        ArrayList<MemoryInformation> visibleNew = new ArrayList<MemoryInformation>();
        int nextPossibleAddress = 0;
        int addCount =0;
        for (int i=0; i<visible.size(); i++)
        {
            if (visible.get(i).address<nextPossibleAddress) continue;
            if (visible.get(i).disType < MemoryInformation.DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_1)
            {
                MemoryInformation info = visible.get(i);
                if(info.isCInfo())
                {
                    visibleNew.add(info);
                    info.cInfoRow = addCount;
                    info.myRow = addCount;
                    addCount++;
                    
                    MemoryInformation info2 = visible.get(i+1);
                    if (info == info2)
                    {
                        visibleNew.add(info);
                        i++;
                        info.myRow = addCount;
                        addCount++;
                    }
                    continue;
                }
                visibleNew.add(info);
                info.myRow = addCount;
                addCount++;

                nextPossibleAddress = visible.get(i).address+visible.get(i).length;
            }
        }
        visible = visibleNew;
    }
    
    // -1 if non found!
    public int getNearestVisibleRow(int address)
    {
        int i=0;
        for (i=0; i<visible.size(); i++)
        {
            if (address>= visible.get(i).address ) continue;
            if (visible.get(i).isCInfo(i)) continue;
            break;
        }
        return i-1;
    }
    // exact
    // -1 if not found
    public int getRowForAddress(int address)
    {
        int i=0;
        for (i=0; i<visible.size(); i++)
        {
            if (visible.get(i).isCInfo(i)) continue;
            if (address== visible.get(i).address ) 
            {
                return i;
            }
        }
        return -1;
    }
    
    public void setSmallMode(boolean b)
    {
        smallMode = b;
        initVisibity();
    }
    
    // in visible column number
    // out model columnNumber
    // -1 if oob
    // todo "caching"
    public int convertViewToModel(int col)
    {
//        if (smallMode) return col;

        int ret =-1;
        int counter =0;
        for (int i=0; i<columnVisible.length; i++)
        {
            if (columnVisible[i] == null) columnVisible[i] = true;
            if (columnVisible[i])
            {
                if (counter == col) return i;
                counter ++;
            }
            else
            {
                
            }
            
        }
        
        return ret;
    }
    public int convertModelToView(int col)
    {
//        if (smallMode) return col;
        int ret = 0;
        for (int i=0; i<columnVisible.length; i++)
        {
            if (i == col) return ret;
            if (columnVisible[i])
            {
                ret++;
            }
        }
        return -1;
    }
    // todo "caching"
    public int getViewColumnCount()
    {
//        if (smallMode) return columnNamesSmall.length;
        int ret = 0;
        for (int i=0; i<columnVisible.length; i++)
        {
            if (columnVisible[i]==null) columnVisible[i] = true;
            if (columnVisible[i])
            {
                ret++;
            }
        }
        return ret;
    }
    
    private MemoryInformationTableModel()
    {
    }
    
    
    public int getRowCount()
    {
        return visible.size();
    }
    public boolean isRowCInfo(int row)
    {
        return visible.get(row).cInfoRow == row;
    }
    
    
    public int getColumnCount()
    {
        return getViewColumnCount();
    }
    public int getColumnOrgCount()
    {
        return columnNames.length;
    }
    // input model column!
    public boolean isVisible(int col)
    {
//        if (smallMode) return true;
        
        if (!isProfiling())
        {
            if (col>=columnVisible.length-2)
            {
                return false;
            }
        }
        
        return columnVisible[col];
    }
    // input data column
    public int getColWidth(int col)
    {
        if (smallMode)
        {
            if (col >= columnWidthSmall.length) return 10;
            return columnWidthSmall[col];
        }
        return columnWidth[col];
    }
    public MemoryInformation getValueAt(int row)
    {
        return visible.get(row);
    }
    // input data column
    public Object getValueAt(int row, int col)
    {
        MemoryInformation minfo;
        try
        {
            minfo = getValueAt(row);
        }
        catch (Throwable e)
        {
            return "";
        }
        if (minfo.isCInfo(row))
        {
            if (col == 0) return "$"+String.format("%04X", minfo.address);
            if (col == 1) return minfo.cInfo.lineString;
            return "";
        }
/*        
        
        if (smallMode)
        {
            if (col == 0) return "$"+String.format("%04X", minfo.address);
            if (col == 1) 
            {
                StringBuilder l = new StringBuilder();
                if (!fullDisplay)
                {
                    int countDisplay = 0;
                    int start = -1;
                    
                    
                    for (int i = 0;i< minfo.length; i++)
                    {
                        boolean displayed = false;
                        MemoryInformation next = orgData.memMap.get(minfo.address+i);
                        if (next != null)
                        {
                            for (int ii = 0;ii< next.labels.size(); ii++)
                            {
                                if (!displayed)
                                {
                                    start = l.length();
                                    l.append("["+i+"]");
                                    countDisplay++;
                                }
                                displayed = true;
                                l.append(next.labels.get(ii)+":");
                            }
                        }
                    }
                    if (countDisplay==1)
                    {
                        l.replace(start, 3, "");
                    }
                }
                else
                {
                    MemoryInformation next = orgData.memMap.get(minfo.address);
                    if (next != null)
                    {
                        for (int ii = 0;ii< next.labels.size(); ii++)
                        {
                            l.append(next.labels.get(ii)+":");
                        }
                    }

                }
                return l.toString();
            }
            if (col == 2) 
            {
                if (minfo.contentUnkown) 
                {
                    return "???";
                }
                StringBuilder l = new StringBuilder();
                for (int i = 0;i< minfo.length; i++)
                {
                    MemoryInformation next = orgData.memMap.get(minfo.address+i);
                    if (next != null)
                    {
                        l.append(String.format("%02X ", next.content&0xff));
                    }
                }
                return l.toString();

            }
            if (col == 3) 
            {
                String l = minfo.disassembledMnemonic;
                return l;
            }
            if (col == 4) // operand(s)
            {
                String l = minfo.disassembledOperand;
                return l;
            }
            if (col == 5) 
            {
                int page = minfo.page;
                if (page == -1) 
                    return "???";
                int index = 1;
                if (page == 0) index = minfo.indexInOpcodeTablePage0;
                if (page == 1)
                {
                    index = -1;
                    MemoryInformation next = orgData.memMap.get(minfo.address+1);
                    if (next != null)
                        index = next.indexInOpcodeTablePage1;
                }
                if (page == 2)
                {
                    index = -1;
                    MemoryInformation next = orgData.memMap.get(minfo.address+1);
                    if (next != null)
                        index = next.indexInOpcodeTablePage2;
                }
                if (index == -1) 
                    return "???";
                String l = ""+pgpointers[page][index].numcycles;
                return l;
            }
            if (col == 6) // mode
            {
                if (minfo.referingAddressMode == -1) return "";
                return DASMStatics.modenames[minfo.referingAddressMode];
            }
            if (col == 7) 
            {
                return minfo.length;
            }

            return "-";
        }
*/
        // full mode
        if (col == 0) return "$"+String.format("%04X", minfo.address);
        if (col == 1) 
        {
            StringBuilder l = new StringBuilder();
            if (!fullDisplay)
            {
                int countDisplay = 0;
                int start = -1;
                for (int i = 0;i< minfo.length; i++)
                {
                    boolean displayed = false;
                    MemoryInformation next = orgData.memMap.get(minfo.address+i);
                    if (next != null)
                    {
                        for (int ii = 0;ii< next.labels.size(); ii++)
                        {
                            if (!displayed)
                            {
                                start = l.length();
                                l.append("["+i+"]");
                                countDisplay++;
                            }
                            displayed = true;
                            l.append(next.labels.get(ii)+":");
                        }
                    }
                }
                if (countDisplay==1)
                {
                    l.replace(start, 3, "");
                }
            }
            else
            {
                MemoryInformation next = orgData.memMap.get(minfo.address);
                if (next != null)
                {
                    for (int ii = 0;ii< next.labels.size(); ii++)
                    {
                        l.append(next.labels.get(ii)+":");
                    }
                }
                
            }
            return l.toString();
        }
        if (col == 2) 
        {
            if (minfo.contentUnkown) 
            {
                return "???";
                
            }
            
            if (minfo.disType==DIS_TYPE_UNKOWN)
            {
                // not loaded from cart
                // this might still be references in some way - e.g. flash support
                // therefor lets display what the emulator sees
                
                if (dissi!=null)
                {
                    VecXPanel vecxPanel = dissi.getVecXPanel();
                
                return "$"+String.format("%02X", vecxPanel.getVecXMem8(minfo.address));
                }
                
            }
            
            StringBuilder l = new StringBuilder();
          
            for (int i = 0;i< minfo.length; i++)
            {
                MemoryInformation next = orgData.memMap.get(minfo.address+i);
                if (next != null)
                {
                    l.append(String.format("%02X ", next.content&0xff));
                }
            }
            return l.toString();
            
        }
        if (col == 3) 
        {
            String l = minfo.disassembledMnemonic;
            return l;
        }
        if (col == 4) // operand(s)
        {
            String l = minfo.disassembledOperand;
            l=toHTML(l, minfo, row);
            return l;
        }
        if (col == 5) //page
        {
            String l = ""+(minfo.page);
            return l;
        }
        if (col == 6) 
        {
            int page = minfo.page;
            if (page == -1) 
                return "???";
            int index = 1;
            if (page == 0) index = minfo.indexInOpcodeTablePage0;
            if (page == 1)
            {
                index = -1;
                MemoryInformation next = orgData.memMap.get(minfo.address+1);
                if (next != null)
                    index = next.indexInOpcodeTablePage1;
            }
            if (page == 2)
            {
                index = -1;
                MemoryInformation next = orgData.memMap.get(minfo.address+1);
                if (next != null)
                    index = next.indexInOpcodeTablePage2;
            }
            if (index == -1) 
                return "???";
            String l = ""+pgpointers[page][index].numcycles;
            
            return ""+minfo.cycles;
        }
        
        if (col == 7) // mode
        {
            if (minfo.referingAddressMode == -1) return "";
            return DASMStatics.modenames[minfo.referingAddressMode];
        }
        if (col == 8) // address
        {
            if (minfo.referingToAddress == -1) return "";
            if (minfo.referingAddressMode == DASMStatics.REL)
            {
                int a = minfo.referingToAddress & 0xff;
                if (a<128)
                    return String.format("$%02X", a);
                return String.format("-$%02X", 256-a);
                
            }
            if (minfo.referingAddressMode == DASMStatics.LREL)
            {
                int a = minfo.referingToAddress & 0xffff;
                if (a<32768) 
                    return String.format("$%04X", a);
                return String.format("-$%04X", 65536-a);
                
            }
            if (minfo.referingToShort)
                return String.format("$%02X", minfo.referingToAddress);
            else
                return String.format("$%04X", minfo.referingToAddress);
        }
        if (col == 9) 
        {
            if (minfo.disType == -2)
                return "LOADED";
            if (minfo.disType == -1)
                return "CODE";
            if (minfo.disType>=0)
                return MemoryInformation.disTypeString[minfo.disType];
            if (minfo.disType==DIS_TYPE_DATA_DECIMAL)
                return "DB DEC";
            return "UNKOWN";
        }
        if (col == 10) 
        {
            return minfo.length;
        }
        if (col == 11) 
        {
            StringBuilder l = new StringBuilder();
            if (!fullDisplay)
            {
                int countDisplay = 0;
                int start = -1;
                for (int i = 0;i< minfo.length; i++)
                {
                    MemoryInformation next = orgData.memMap.get(minfo.address+i);
                    boolean displayed=false;
                    if (next != null)
                    {
                        for (int ii = 0;ii< next.comments.size(); ii++)
                        {
                            if (!displayed)
                            {
                                start = l.length();
                                l.append("["+i+"]");
                                countDisplay++;
                            }
                            displayed = true;
                            l.append(next.comments.get(ii)+":");
                        }
                    }
                }
                if (countDisplay==1)
                {
                    l.replace(start, 3, "");
                }
            }
            else
            {
                MemoryInformation next = orgData.memMap.get(minfo.address);
                if (next != null)
                {
                    for (int ii = 0;ii< next.comments.size(); ii++)
                    {
                        l.append(next.comments.get(ii)+":");
                    }
                }
            }
            return l.toString();
        }
        if (col == 12) // dp
        {
            String ret = "";
            if (Math.abs(minfo.directPageAddress)<256)
                ret =String.format("$%02X", minfo.directPageAddress&0xff);
            else
                ret = String.format("$%04X", minfo.directPageAddress&0xffff);
            return ret;
        }
        
        
        int address = minfo.address;

        if (col == 13) // "Pr access"
        {
            String ret = "";
            if (!isProfiling()) return ret;

            if (profiler.trackingOnly)
            {
                if (profiler.finalOnly)
                    ret = ""+ profiler.memory[address].lastTrack_accessCount_final;
                else
                    ret = ""+ profiler.memory[address].lastTrack_accessCount;
            }
            else
            {
                ret = ""+ profiler.memory[address].accessCount;
            }
            return ret;
        }
        if (col == 14) // "Pr cycles"        
        {
            String ret = "";
            if (!isProfiling()) return ret;
            Profiler.ProfilerMemoryLocation memoryLocation = profiler.memory[address];

            if (profiler.trackingOnly)
            {
                if (profiler.finalOnly)
                    ret = ""+ profiler.memory[address].lastTrack_accessCycles_final;
                else
                    ret = ""+ profiler.memory[address].lastTrack_accessCycles;
            }
            else
            {
                ret = ""+ profiler.memory[address].accessCycles;
            }
            return ret;
        }

        if (col == 15) // "Pr cycles sum"        
        {
            String ret = "";
            if (!isProfiling()) return ret;
            Profiler.ProfilerMemoryLocation memoryLocation = profiler.memory[address];
            if (profiler.trackingOnly)
            {
                if (profiler.finalOnly)
                    ret = ""+ (profiler.memory[address].caller_lastTrack_accessCyclesSum_final+ profiler.memory[address].lastTrack_accessCycles_final);
                else
                    ret = ""+ (profiler.memory[address].caller_lastTrack_accessCyclesSum+ profiler.memory[address].lastTrack_accessCycles);
            }
            else
            {
                ret = ""+ (profiler.memory[address].accessCyclesSum+profiler.memory[address].accessCycles);
            }
            return ret;
        }
        
        return "-";
    }
    // input data column
    public String getColumnName(int column) {

        if (smallMode)
            return columnNamesSmall[column];
        return columnNames[column];
    }
    // input data column
    public Class<?> getColumnClass(int columnIndex) {
        return Object.class;
    }
    // input data column
    public boolean isCellEditable(int rowIndex, int columnIndex) {
        if (smallMode) return false;
        if (isRowCInfo(rowIndex)) return false;
        if (columnIndex == 11) return true;
        if (columnIndex == 1) return true;
        return false;
    }
    // input data column
    public void setValueAt(Object aValue, int rowIndex, int columnIndex) {
        if (smallMode) return;
        if (columnIndex == 1)
        {
            // todo 
            MemoryInformation memInfo = getValueAt(rowIndex);
            ArrayList<String> oldLabels = (ArrayList<String>)memInfo.labels.clone();   
            memInfo.labels.clear();
            String label = aValue.toString();
            String[] labels = label.split(":");
            for (String l: labels)
            {
                if (l.trim().length()>0)
                    memInfo.labels.add(l);
            }
            boolean changeRelevant = true;
            if (orgData != null)
            {
                changeRelevant = orgData.labelsChanged(memInfo, oldLabels);
            }
            if (changeRelevant)
                fireTableCellUpdated(rowIndex, columnIndex);
        }
        if (columnIndex == 11) 
        {
            MemoryInformation memInfo = getValueAt(rowIndex);

            memInfo.comments.clear();
            String comment = aValue.toString();
            String[] comments = comment.split(":");
            for (String c: comments)
            memInfo.comments.add(c);
            fireTableCellUpdated(rowIndex, columnIndex);
        }
    }
    // input view column
    
    public Color getBackground(int row, int c)
    {
        MemoryInformation minfo = getValueAt(row);
        int col = convertViewToModel( c);
        if (col == 0) return config.tableAddress;

        if ( minfo.isCInfo(row))
        {
            return config.cLinesBack;
        }
        
        if ( highLightClick.length()>0)
        {
            if (col == 4) // operand
            {
                String op = getValueAt(row, col).toString();
                if (op.contains(highLightClick))
                    return Color.GREEN;
            }       
        }
        if ( highLightLabel.length()>0)
        {
            if (col == 4) // operand
            {
                String op = getValueAt(row, col).toString();
                if (op.toLowerCase().contains(highLightLabel))
                    return Color.YELLOW;
            }       
        }
        
        MemoryInformation memInfo = getValueAt(row);
        if (memInfo.address>=0xe000)
        {
            return config.tableBIOS;
        }
        if (orgData.currentBank != 0)
        {
            return config.tableOtherBank;
        }
        
        return null; // default
    }    
    
    // input data column
    public Color getForeground(int row, int col)
    {
        MemoryInformation minfo = getValueAt(row);

        if ( minfo.isCInfo(row))
        {
            if (col!= 0)
                return config.cLinesFore;
        }
        
        return null; // default
    }
    
    public void setHighliteLabel(String h)
    {
        highLightLabel = h.trim().toLowerCase();
    }
    public void setHighliteClick(String h)
    {
        highLightClick = h.trim();
    }
    
    public boolean isProfiling()
    {
        if (profiler == null) return false;
        return config.doProfile;
    }
    String toHTML(String l, MemoryInformation minfo, int row)
    {
        l = UtilityString.replace(l,"dp","^~|");
        l = UtilityString.replace(l,"DP","|~^");

        l = UtilityString.replace(l,"0","~0!");
        l = UtilityString.replace(l,"1","~1!");
        l = UtilityString.replace(l,"2","~2!");
        l = UtilityString.replace(l,"3","~3!");
        l = UtilityString.replace(l,"4","~4!");
        l = UtilityString.replace(l,"5","~5!");
        l = UtilityString.replace(l,"6","~6!");
        l = UtilityString.replace(l,"7","~7!");
        l = UtilityString.replace(l,"8","~8!");
        l = UtilityString.replace(l,"9","~9!");
        l = UtilityString.replace(l,"a","~a!");
        l = UtilityString.replace(l,"b","~b!");
        l = UtilityString.replace(l,"c","~c!");
        l = UtilityString.replace(l,"d","~d!");
        l = UtilityString.replace(l,"e","~e!");
        l = UtilityString.replace(l,"f","~f!");
        l = UtilityString.replace(l,"A","~A!");
        l = UtilityString.replace(l,"B","~B!");
        l = UtilityString.replace(l,"C","~C!");
        l = UtilityString.replace(l,"D","~D!");
        l = UtilityString.replace(l,"E","~E!");
        l = UtilityString.replace(l,"F","~F!");
        
        
        Object o = getValueAt(row,3);
        String mnemonic = "";
        boolean isAddress = (minfo.referingToAddress != -1);
        if (o!=null)mnemonic = o.toString().toLowerCase();
        Color c;
        
        AttributeSet _operator = TokenStyles.getStyle("operator");
        c = StyleConstants.getForeground(_operator);
        String operatorColor = "???HASH???"+ String.format("%02X", c.getRed()&0xff)+ String.format("%02X", c.getGreen()&0xff)+ String.format("%02X", c.getBlue()&0xff);

        AttributeSet _variable = TokenStyles.getStyle("literalVariable");
        c = StyleConstants.getForeground(_variable);
        String variableColor = "???HASH???"+ String.format("%02X", c.getRed()&0xff)+ String.format("%02X", c.getGreen()&0xff)+ String.format("%02X", c.getBlue()&0xff);

        AttributeSet _register = TokenStyles.getStyle("register");
        c = StyleConstants.getForeground(_register);
        String registerColor = "???HASH???"+ String.format("%02X", c.getRed()&0xff)+ String.format("%02X", c.getGreen()&0xff)+ String.format("%02X", c.getBlue()&0xff);

        AttributeSet _literal = TokenStyles.getStyle("literal");
        c = StyleConstants.getForeground(_literal);
        String literalColor = "???HASH???"+ String.format("%02X", c.getRed()&0xff)+ String.format("%02X", c.getGreen()&0xff)+ String.format("%02X", c.getBlue()&0xff);

        AttributeSet _preprop = TokenStyles.getStyle("preprocessor");
        c = StyleConstants.getForeground(_preprop);
        String prepropColor = "???HASH???"+ String.format("%02X", c.getRed()&0xff)+ String.format("%02X", c.getGreen()&0xff)+ String.format("%02X", c.getBlue()&0xff);

        AttributeSet _literalString = TokenStyles.getStyle("literalstring");
        c = StyleConstants.getForeground(_literalString);
        String literalStringColor = "???HASH???"+ String.format("%02X", c.getRed()&0xff)+ String.format("%02X", c.getGreen()&0xff)+ String.format("%02X", c.getBlue()&0xff);

        boolean isStringValue = false;
        String innerStringValue = "";        
        if (mnemonic.equals("db"))
        {
            if (l.trim().startsWith("\"") ) 
            {
                innerStringValue = l.substring(1,l.lastIndexOf("\""));
                l = UtilityString.replace(l,innerStringValue,"---INNER_STRING_VALUE---");

                innerStringValue = UtilityString.toXML(UtilityString.onlyXMLVisibleASCII(innerStringValue));


                isStringValue = true;
            }
        }
        String r = l;
        
        r = UtilityString.replace(r,"#","!!!HASH!!!");
        r = "<html>"+UtilityString.toXML(UtilityString.onlyXMLVisibleASCII(r))+"</html>";
        
        String sl = UtilityString.replace(l,"<", "");
        sl = UtilityString.replace(sl,">", "");
        sl = UtilityString.replace(sl,"#","");
        r = UtilityString.replace(r,sl,"<font color='"+variableColor+"'>"+sl+"</font>");

        if ((mnemonic.equals("db")) || (mnemonic.equals("dw")))
        {
            sl = UtilityString.replace(l,"\"", "&quot;");
            if (mnemonic.equals("db"))
            {
                r = UtilityString.replace(r,sl,"<font color='"+literalColor+"'>"+sl+"</font>");
                /*
                if (l.contains("\""))
                {
                    if (!l.substring(1,l.lastIndexOf("\"")).equals("&"))
                        r = UtilityString.replace(r,l.substring(1,l.lastIndexOf("\"")),"<font color='"+literalStringColor+"'>"+l.substring(1,l.lastIndexOf("\""))+"</font>");
                }
                */
            }
            else
            {
                if (l.contains("$"))
                    r = UtilityString.replace(r,sl,"<font color='"+literalColor+"'>"+sl+"</font>");
            }
        }
        else if (isAddress)
        {
            o = getValueAt(row,8);
            if (o!=null)
            {
                String os = o.toString();
                        
                r = UtilityString.replace(r,os,"<font color='"+literalColor+"'>"+os+"</font>");
            }
        }
        else // register or immediate
        {
            
            sl = UtilityString.replace(l,"<<", "");
            sl = UtilityString.replace(sl,"<", "");
            sl = UtilityString.replace(sl,">", "");
            sl = UtilityString.replace(sl,"-", "");
            if (sl.contains(","))
            {
                // this is an indexed address
                sl = sl.substring(0, sl.indexOf(","));
                if (sl.length() != 0)
                {
                    r = UtilityString.replace(r,sl,"<font color='"+literalColor+"'>"+sl+"</font>");
                }
            }
            
            
            
            if (!l.startsWith("#"))
            {
//                r = UtilityString.replace(r,"a","<font color='"+registerColor+"'>"+"a"+"</font>");
//                r = UtilityString.replace(r,"b","<font color='"+registerColor+"'>"+"b"+"</font>");
//                r = UtilityString.replace(r,"d","<font color='"+registerColor+"'>"+"d"+"</font>");
                r = UtilityString.replace(r,"~a!","<font color='"+registerColor+"'>"+"~a!"+"</font>");
                r = UtilityString.replace(r,"~b!","<font color='"+registerColor+"'>"+"~b!"+"</font>");
                r = UtilityString.replace(r,"~d!","<font color='"+registerColor+"'>"+"~d!"+"</font>");

                
                
        r = UtilityString.replace(r,"^~|","dp");
        r = UtilityString.replace(r,"|~^","DP");

                
                r = UtilityString.replace(r,"dp","<font color='"+registerColor+"'>"+"dp"+"</font>");
                r = UtilityString.replace(r,"x","<font color='"+registerColor+"'>"+"x"+"</font>");
                r = UtilityString.replace(r,"y","<font color='"+registerColor+"'>"+"y"+"</font>");
                r = UtilityString.replace(r,"u","<font color='"+registerColor+"'>"+"u"+"</font>");
                r = UtilityString.replace(r,"s","<font color='"+registerColor+"'>"+"s"+"</font>");
                r = UtilityString.replace(r,"pc","<font color='"+registerColor+"'>"+"pc"+"</font>");
                r = UtilityString.replace(r,"cc","<font color='"+registerColor+"'>"+"cc"+"</font>");
            }
            else
            {
                if ((l.substring(1).startsWith("$")) || (l.substring(1).startsWith("%")))
                    r = UtilityString.replace(r,l.substring(1),"<font color='"+literalColor+"'>"+l.substring(1)+"</font>");
            }
        }

if (isStringValue)     
{
    innerStringValue = UtilityString.replace(innerStringValue,"&#x20;", " ");
//    r = UtilityString.replace(l,"---INNER_STRING_VALUE---", innerStringValue);
    r = UtilityString.replace(r,"---INNER_STRING_VALUE---", "<font color='"+literalStringColor+"'>"+innerStringValue+"</font>");
}
        
        
        r = UtilityString.replace(r,"!!!HASH!!!","<font color='"+operatorColor+"'>"+"#"+"</font>");
        r = UtilityString.replace(r,"[","<font color='"+operatorColor+"'>"+"["+"</font>");
        r = UtilityString.replace(r,"]","<font color='"+operatorColor+"'>"+"]"+"</font>");
        r = UtilityString.replace(r,"+","<font color='"+operatorColor+"'>"+"+"+"</font>");
        r = UtilityString.replace(r,"-","<font color='"+operatorColor+"'>"+"-"+"</font>");
        r = UtilityString.replace(r,"&quot;","<font color='"+operatorColor+"'>"+"&quot;"+"</font>");


        r = UtilityString.replace(r,",","<font color='"+operatorColor+"'>"+","+"</font>");
        r = UtilityString.replace(r,"&lt;","<font color='"+operatorColor+"'>"+"&lt;"+"</font>");
        r = UtilityString.replace(r,"&gt;","<font color='"+operatorColor+"'>"+"&gt;"+"</font>");

        r = UtilityString.replace(r,"???HASH???","#");
        r = UtilityString.replace(r,"font color", "font face='Monospaced' color");

        r = UtilityString.replace(r,"_", "<u>&nbsp;</u>");
        r = UtilityString.replace(r,"<html>", "<html><nobr>");
        r = UtilityString.replace(r,"</html>", "</nobr></html>");

        r = UtilityString.replace(r,"&apos;","'");
        r = UtilityString.replace(r,"&quot;","\"");
        r = UtilityString.replace(r,"&amp;","&");

		
        r = UtilityString.replace(r,"^~|","dp");
        r = UtilityString.replace(r,"|~^","DP");

//        r = UtilityString.replace(r,"]~[","dp");
//        r = UtilityString.replace(r,"[~]","DP");
        r = UtilityString.replace(r,"~0!","0");
        r = UtilityString.replace(r,"~1!","1");
        r = UtilityString.replace(r,"~2!","2");
        r = UtilityString.replace(r,"~3!","3");
        r = UtilityString.replace(r,"~4!","4");
        r = UtilityString.replace(r,"~5!","5");
        r = UtilityString.replace(r,"~6!","6");
        r = UtilityString.replace(r,"~7!","7");
        r = UtilityString.replace(r,"~8!","8");
        r = UtilityString.replace(r,"~9!","9");
        r = UtilityString.replace(r,"~a!","a");
        r = UtilityString.replace(r,"~b!","b");
        r = UtilityString.replace(r,"~c!","c");
        r = UtilityString.replace(r,"~d!","d");
        r = UtilityString.replace(r,"~e!","e");
        r = UtilityString.replace(r,"~f!","f");
        r = UtilityString.replace(r,"~A!","A");
        r = UtilityString.replace(r,"~B!","B");
        r = UtilityString.replace(r,"~C!","C");
        r = UtilityString.replace(r,"~D!","D");
        r = UtilityString.replace(r,"~E!","E");
        r = UtilityString.replace(r,"~F!","F");
        
        
        return r;
    }


}
