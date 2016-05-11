/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.gui.components;

import java.util.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.table.*;

/**
 *
 * @author Malban
 */
public class CSATableModel extends AbstractTableModel implements TableCellRenderer 
{
    // "_row#_column#" ist der key, header wird als row 0 angenommen
    // header sollte auch in map als "_header_column#" gespeichert sein
    // protected HashMap<String, CSACell> mValues = new HashMap<String, CSACell>();
    protected javax.swing.table.TableModel mOrgModel=null;
    protected static int mBufferRow=0;

    private HashMap<Integer, Boolean> mColumnEnabled = new HashMap<Integer, Boolean>();
    private HashMap<Integer, Integer> mEnabledColumnMapping = new HashMap<Integer, Integer>();
    private HashMap<Integer, Integer> mRealColumnMapping = new HashMap<Integer, Integer>();
    
    
    private String mSheetName="";
    private int mEnabledColumnCount = 0;
    private Color lightBlue = new Color(160, 160, 255);
    private Color darkBlue  = new Color( 64,  64, 128);
    private static boolean mLogging = false;
    private static String mLog="";
    CSATablePanel parent=null;

    public static CSATableModel buildTableModel(javax.swing.table.TableModel orgModel)
    {
        CSATableModel model = new CSATableModel();
        model.setData(orgModel);
        return model;
    }

    public void setSameModelType(CSATableModel model)
    {
        mOrgModel = model.mOrgModel;
        fireTableDataChanged();
    }

    public void setParent(CSATablePanel p)
    {
        parent = p;
    }

    private CSATableModel()
    {
    }

    public void updateModel(javax.swing.table.TableModel orgModel)
    {
        if (orgModel != null)
        {
            setData(orgModel);
            fireTableDataChanged();
            if (parent != null)
                parent.reInit();
        }
    }

    protected void setData(javax.swing.table.TableModel model)
    {
        mOrgModel = model;
        mColumnEnabled = new HashMap<Integer, Boolean>();
        for (int i=0; i< mOrgModel.getColumnCount(); i++)
        {
            mColumnEnabled.put(new Integer(i), true);
        }
        resetColumnInfo();
    }

    void getInfo()
    {
        String user = java.lang.System.getProperties().getProperty("user.name");
        // toDO mails in Java:http://www.boscheri.ch/computer/java/javainsel5/javainsel16_010.htm#Rxx747java160100400063D1F048118
    }
    
    public String getSheetName()
    {
        return mSheetName;
    }

    public int convertEnabledColToRealCol(int i)
    {
        return mEnabledColumnMapping.get(i);
    }
    public int convertRealColToEnabledCol(int i)
    {
        return mRealColumnMapping.get(i);
    }
    
    public int getRealColumnCount()
    {
        return mOrgModel.getColumnCount();
    }
    
    public String getRealColumnName(int col)
    {
       return mOrgModel.getColumnName(col);
    }

    public boolean isColumnEnabled(int col)
    {
        Boolean b = mColumnEnabled.get(new Integer(col));
        if (b== null) return true;
        return b.booleanValue();
    }

    public int getEnabledColumnCount()
    {
        return mEnabledColumnCount;
    }
    
    public int getRealColumnNumberByName(String name)
    {
        for (int i=0; i< getRealColumnCount(); i++)
        {
            String cn = getRealColumnName(i);
            if (cn.equals(name)) return i;
        }
        return -1;
    }
    
    public int getEnabledColumnNumberByName(String name)
    {
        int col = getRealColumnNumberByName(name);
        return convertRealColToEnabledCol(col);
    }
    
    // col is real index!
    public void enableColumn(int col, boolean b)
    {
        mColumnEnabled.put(new Integer(col), b);
        resetColumnInfo();
    }
    
    public void enableColumn(String name, boolean b)
    {
        enableColumn(getRealColumnNumberByName(name), b);
    }
    
    public void resetColumnInfo()
    {
        mEnabledColumnCount = mOrgModel.getColumnCount();
        int disabledCount =0;

        mEnabledColumnMapping = new HashMap<Integer, Integer>();
        mRealColumnMapping = new HashMap<Integer, Integer>();

        for (int i=0; i<mEnabledColumnCount;i++)
        {
            if (!isColumnEnabled(i))
            {
                disabledCount++;
                mRealColumnMapping.put(i, -1);
            }
            else
            {
                mRealColumnMapping.put(i, i-disabledCount);
                mEnabledColumnMapping.put(i-disabledCount,i);
            }
        }
        mEnabledColumnCount -= disabledCount;
    }

    // in enabled
    @Override public String getColumnName(int col) 
    {
        int realCol = mEnabledColumnMapping.get(col);
        return mOrgModel.getColumnName(realCol);
    }
    
    public int getRowCount() 
    { 
        return mOrgModel.getRowCount();
    }
    
    public int getColumnCount() 
    { 
        return getEnabledColumnCount();
    }
        TableColumnModel mCModel = null;
    public void setColumnModel(TableColumnModel cModel)
    {
        mCModel = cModel;
    }

    public Object getValueAt(int row, int col)
    {
        Integer I = mEnabledColumnMapping.get(col);
        int realCol = col;
        if (I!=null) realCol=I;
        return mOrgModel.getValueAt(row, realCol);
    }

    // coords in real model
    public Object getRealValueAt(int row, int col)
    {
        return mOrgModel.getValueAt(row, col);
    }

    @Override public boolean isCellEditable(int row, int col)
    { 
        int realCol = mEnabledColumnMapping.get(col);
        return mOrgModel.isCellEditable(row,realCol);
    }
    @Override public void setValueAt(Object o, int row, int col)
    {
        int realCol = mEnabledColumnMapping.get(col);
        mOrgModel.setValueAt(o, row, realCol);
        parent.getTable().repaint();
    }

    @Override public Class getColumnClass(int col)
    {
        int realCol = mEnabledColumnMapping.get(col);
        return mOrgModel.getColumnClass(realCol);
    }
    
    // col in real
    public Vector<String> getDistinctColumnValueStrings(int col)
    {
        Vector<String> distinctRepresentation = new Vector<String>();
        HashMap<String, String> mStrings = new HashMap<String, String>();

        for (int i=0; i<getRowCount(); i++)
        {
            Object o = getRealValueAt(i, col);
            if (o==null) continue;
            String cn = o.toString();
            mStrings.put(cn, cn);
        }
        Set entries = mStrings.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            String key = entry.getKey().toString();
            distinctRepresentation.addElement(key);
        }
        return distinctRepresentation;
    }

    public Component getTableCellRendererComponent(
                JTable table,
                Object value,
                boolean isSelected,
                boolean hasFocus,
                int row,
                int column
                ) 
     {
        //Label erzeugen
        JLabel label ;
         if (value == null)
         {
            label = new JLabel("");
         }
         else
         {
            if (value instanceof BufferedImage)
            {
               ImageIcon icon = new ImageIcon((BufferedImage) value); 
               label = new JLabel(icon);
            }
            else
               label = new JLabel((String)(""+value));
         }
        label.setOpaque(true);
        Border b = BorderFactory.createEmptyBorder(1, 1, 1, 1);
        label.setBorder(b);
        label.setFont(table.getFont());
        label.setForeground(table.getForeground());
        label.setBackground(table.getBackground());
        if (hasFocus) {
            label.setBackground(darkBlue);
            label.setForeground(Color.white);
        } else if (isSelected) 
        {
            label.setBackground(lightBlue);
        } 
        else 
        {
            //Angezeigte Spalte in Modellspalte umwandeln
            column = table.convertColumnIndexToModel(column);
            row = table.convertRowIndexToModel(row);
/*
            CSACell eCell = getCellReal(row, column);
            if (eCell != null)
            {
                label.setBackground(eCell.getDefaultBackgroundColor());
                if (eCell.getBackgroundColor() != null)
                {
                    label.setBackground(eCell.getBackgroundColor());
                }
            }
            else
*/
 {
                 label.setBackground(Color.white);
            }
        }
        return label;
    }
}
