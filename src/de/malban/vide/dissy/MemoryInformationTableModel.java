/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.dissy;

import static de.malban.vide.dissy.DASMStatics.pgpointers;
import java.awt.Color;
import java.util.ArrayList;
import java.util.HashMap;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author malban
 */
public class MemoryInformationTableModel extends AbstractTableModel
{
    public static Boolean[] columnVisible = {true, true,true, true,true,true, true,true, true, true,true ,true, true};
    public static int[] columnWidthSmall =    {20       , 50    , 150      , 30        , 100       ,10       ,20  , 10    };
    public static int[] columnWidth =    {10       , 100     , 150      , 30        , 100   ,  10      ,10      , 50   , 30        , 50    , 10      , 150    , 5};

    boolean smallMode = false;
    String[] columnNamesSmall = {"Address", "Label", "Content", "Mnemonic","Operand", "Cycles", "Mode","Length" };
    String[] columnNames = {"Address", "Label","Content", "Mnemonic","Operand","Page", "Cycles","Mode", "->Address", "Type","Length" ,"Comments", "DP"};
    ArrayList<MemoryInformation> visible = new ArrayList<MemoryInformation>();
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
        for (int i=0; i< columnVisible.length; i++)
            columnVisible[i] = true;
        model.orgData = mem;
        model.showAll();
        return model;
    }
    
    public void showAll()
    {
        visible.clear();
        for (int i=0; i<65536; i++)
        {
            MemoryInformation memInfo = orgData.memMap.get(i);
            if (memInfo != null)
            visible.add(i,memInfo);
        }
    }
    public void reduceBIOS()
    {
        ArrayList<MemoryInformation> visibleNew = new ArrayList<MemoryInformation>();
        for (int i=0; i<visible.size(); i++)
        {
            if (visible.get(i).address < 0xe000)
                visibleNew.add(visible.get(i));
        }
        visible = visibleNew;
    }
    public void reduceUnkown()
    {
        ArrayList<MemoryInformation> visibleNew = new ArrayList<MemoryInformation>();
        for (int i=0; i<visible.size(); i++)
        {
            if (visible.get(i).disType != MemoryInformation.DIS_TYPE_UNKOWN)
                visibleNew.add(visible.get(i));
        }
        visible = visibleNew;
    }
    
    public void reduceInvisible()
    {
        ArrayList<MemoryInformation> visibleNew = new ArrayList<MemoryInformation>();
        for (int i=0; i<visible.size(); i++)
        {
            if (visible.get(i).visible)
                visibleNew.add(visible.get(i));
        }
        visible = visibleNew;
    }
    
    public void reduceCompleteInstructions()
    {
        ArrayList<MemoryInformation> visibleNew = new ArrayList<MemoryInformation>();
        int nextPossibleAddress = 0;
        for (int i=0; i<visible.size(); i++)
        {
            if (visible.get(i).address<nextPossibleAddress) continue;
            if (visible.get(i).disType < MemoryInformation.DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_1)
            {
                visibleNew.add(visible.get(i));
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
            if (address== visible.get(i).address ) return i;
        }
        return -1;
    }
    
    // in visible column number
    // out model columnNumber
    // -1 if oob
    // todo "caching"
    public int convertViewToModel(int col)
    {
        if (smallMode) return col;

        int ret =-1;
        int counter =0;
        for (int i=0; i<columnVisible.length; i++)
        {
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
        if (smallMode) return col;
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
        if (smallMode) return columnNamesSmall.length;
        int ret = 0;
        for (int i=0; i<columnVisible.length; i++)
        {
            if (columnVisible[i])
            {
                ret ++;
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
    public int getColumnCount()
    {
        return getViewColumnCount();
    }
    // input model column!
    public boolean isVisible(int col)
    {
        if (smallMode) return true;
        return columnVisible[col];
    }
    // input data column
    public int getColWidth(int col)
    {
        if (smallMode)
            return columnWidthSmall[col];
        return columnWidth[col];
    }
    public MemoryInformation getValueAt(int row)
    {
        return visible.get(row);
    }
    // input data column
    public Object getValueAt(int row, int col)
    {
        if (smallMode)
        {
            if (col == 0) return "$"+String.format("%04X", visible.get(row).address);
            if (col == 1) 
            {
                StringBuilder l = new StringBuilder();
                if (!fullDisplay)
                {
                    int countDisplay = 0;
                    int start = -1;
                    for (int i = 0;i< visible.get(row).length; i++)
                    {
                        boolean displayed = false;
                        MemoryInformation next = orgData.memMap.get(visible.get(row).address+i);
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
                    MemoryInformation next = orgData.memMap.get(visible.get(row).address);
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
                if (visible.get(row).contentUnkown) 
                {
                    return "???";
                }
                StringBuilder l = new StringBuilder();
                for (int i = 0;i< visible.get(row).length; i++)
                {
                    MemoryInformation next = orgData.memMap.get(visible.get(row).address+i);
                    if (next != null)
                    {
                        l.append(String.format("%02X ", next.content&0xff));
                    }
                }
                return l.toString();

            }
            if (col == 3) 
            {
                String l = visible.get(row).disassembledMnemonic;
                return l;
            }
            if (col == 4) // operand(s)
            {
                String l = visible.get(row).disassembledOperand;
                return l;
            }
            if (col == 5) 
            {
                int page = visible.get(row).page;
                if (page == -1) 
                    return "???";
                int index = 1;
                if (page == 0) index = visible.get(row).indexInOpcodeTablePage0;
                if (page == 1)
                {
                    index = -1;
                    MemoryInformation next = orgData.memMap.get(visible.get(row).address+1);
                    if (next != null)
                        index = next.indexInOpcodeTablePage1;
                }
                if (page == 2)
                {
                    index = -1;
                    MemoryInformation next = orgData.memMap.get(visible.get(row).address+1);
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
                if (visible.get(row).referingAddressMode == -1) return "";
                return DASMStatics.modenames[visible.get(row).referingAddressMode];
            }
            if (col == 7) 
            {
                return visible.get(row).length;
            }

            return "-";
        }
        if (col == 0) return "$"+String.format("%04X", visible.get(row).address);
        if (col == 1) 
        {
            StringBuilder l = new StringBuilder();
            if (!fullDisplay)
            {
                int countDisplay = 0;
                int start = -1;
                for (int i = 0;i< visible.get(row).length; i++)
                {
                    boolean displayed = false;
                    MemoryInformation next = orgData.memMap.get(visible.get(row).address+i);
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
                MemoryInformation next = orgData.memMap.get(visible.get(row).address);
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
            if (visible.get(row).contentUnkown) 
            {
                return "???";
                
            }
            StringBuilder l = new StringBuilder();
          
            for (int i = 0;i< visible.get(row).length; i++)
            {
                MemoryInformation next = orgData.memMap.get(visible.get(row).address+i);
                if (next != null)
                {
                    l.append(String.format("%02X ", next.content&0xff));
                }
            }
            return l.toString();
            
        }
        if (col == 3) 
        {
            String l = visible.get(row).disassembledMnemonic;
            return l;
        }
        if (col == 4) // operand(s)
        {
            String l = visible.get(row).disassembledOperand;
            return l;
        }
        if (col == 5) //page
        {
            String l = ""+(visible.get(row).page);
            return l;
        }
        if (col == 6) 
        {
            int page = visible.get(row).page;
            if (page == -1) 
                return "???";
            int index = 1;
            if (page == 0) index = visible.get(row).indexInOpcodeTablePage0;
            if (page == 1)
            {
                index = -1;
                MemoryInformation next = orgData.memMap.get(visible.get(row).address+1);
                if (next != null)
                    index = next.indexInOpcodeTablePage1;
            }
            if (page == 2)
            {
                index = -1;
                MemoryInformation next = orgData.memMap.get(visible.get(row).address+1);
                if (next != null)
                    index = next.indexInOpcodeTablePage2;
            }
            if (index == -1) 
                return "???";
            String l = ""+pgpointers[page][index].numcycles;
            
            return ""+visible.get(row).cycles;
        }
        
        if (col == 7) // mode
        {
            if (visible.get(row).referingAddressMode == -1) return "";
            return DASMStatics.modenames[visible.get(row).referingAddressMode];
        }
        if (col == 8) // address
        {
            if (visible.get(row).referingToAddress == -1) return "";
            if (visible.get(row).referingAddressMode == DASMStatics.REL)
            {
                int a = visible.get(row).referingToAddress & 0xff;
                if (a<128)
                    return String.format("$%02X", a);
                return String.format("-$%02X", 256-a);
                
            }
            if (visible.get(row).referingAddressMode == DASMStatics.LREL)
            {
                int a = visible.get(row).referingToAddress & 0xffff;
                if (a<32768) 
                    return String.format("$%04X", a);
                return String.format("-$%04X", 65536-a);
                
            }
            if (visible.get(row).referingToShort)
                return String.format("$%02X", visible.get(row).referingToAddress);
            else
                return String.format("$%04X", visible.get(row).referingToAddress);
        }
        if (col == 9) 
        {
            return MemoryInformation.disTypeString[visible.get(row).disType];
        }
        if (col == 10) 
        {
            return visible.get(row).length;
        }
        if (col == 11) 
        {
            StringBuilder l = new StringBuilder();
            if (!fullDisplay)
            {
                int countDisplay = 0;
                int start = -1;
                for (int i = 0;i< visible.get(row).length; i++)
                {
                    MemoryInformation next = orgData.memMap.get(visible.get(row).address+i);
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
                MemoryInformation next = orgData.memMap.get(visible.get(row).address);
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
        if (col == 12) 
        {
            String ret = "";
            if (Math.abs(visible.get(row).directPageAddress)<256)
                ret =String.format("$%02X", visible.get(row).directPageAddress&0xff);
            else
                ret = String.format("$%04X", visible.get(row).directPageAddress&0xffff);
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
            MemoryInformation memInfo = visible.get(rowIndex);
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
            MemoryInformation memInfo = visible.get(rowIndex);

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
        int col = convertViewToModel( c);
            
        if (col == 0) return new Color(200,255,200,255);

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
        
        
        return null; // default
    }
    // input data column
    public Color getForeground(int row, int col)
    {
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
   
}
