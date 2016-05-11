/*
 * CSATablePanel.java
 *
 * Created on 9. Februar 2009, 16:03
 */

package de.malban.gui.components;

import java.util.Vector;
import de.malban.util.InfoCallback;
import javax.swing.table.*;
import javax.swing.event.* ;
import javax.swing.*;
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.BufferedImage;

/** * @author  Malban
 */
public class CSATablePanel extends javax.swing.JPanel implements InfoCallback{

   public int COMBO_SIZE = -1;

    private Vector<SelectionChangedListener> mSelectionListener= new Vector<SelectionChangedListener>();
    private Vector<FilterChangedListener> mFilterListener= new Vector<FilterChangedListener>();
    private Vector<CSAListener> mListener = new Vector<CSAListener>();

    
    
    TableRowSorter<TableModel> mSorter = null;
    javax.swing.JFrame mFrame;
    CSATableModel mModel = null;

    private int mLastKnownSize=0;
    private int mRow = -1;
    private int mCol = -1;
    private int inEvent=0;
    private DoubleClickAction mDClickAction=null;
    private boolean mEnablePopup= true;
    private boolean mEnableDClick= true;

    
    // only dummy for GUI
    public CSATablePanel()
    {
        TableModel model = new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        );

        mModel = CSATableModel.buildTableModel(model);
        initComponents();
        initAll();
    }

    
    public CSATablePanel(CSATableModel model)
    {
        mModel = model;
        initComponents();
        initAll();
    }

    public void setModel(CSATableModel model)
    {
        mModel = model;
        initAll();
    }
    
    public void setSameModelType(CSATableModel model)
    {
        mSorter.setSortsOnUpdates(true);
        mModel.setSameModelType(model);
        mSorter.setSortsOnUpdates(false);
        resetFilters();
    }

    @Override public void paintComponent(Graphics g)
    {
        super.paintComponent(g);
        if (COMBO_SIZE == -1)
        {
            TableColumnModel cModel = jTable1.getColumnModel();
            try
            {
                for (int i=0; i <cModel.getColumnCount(); i++)
                {
                    int ch = jHeaderPanel.getComponent(i).getHeight();
                    if (ch == 0) break;
                    COMBO_SIZE = ch;
                    break;
                }
            }
            // update on an empty table might throw an exception...
            catch (Throwable e){}
            
        }
    }

    private void resetFilters()
    {
        inEvent++;
//        jHeaderPanel.removeAll();
         int x=1;
         int y=0;
         //int height = COMBO_SIZE;
         int width = 0;
         jTable1.getColumnModel();
         TableColumnModel cModel = jTable1.getColumnModel();

         for (int i=0; i <cModel.getColumnCount(); i++)
         {
             TableColumn tCol = cModel.getColumn(i);
             String name = (String) tCol.getHeaderValue();
             int realIndex = mModel.getRealColumnNumberByName(name);

             javax.swing.JComboBox comboBox = (javax.swing.JComboBox) jHeaderPanel.getComponent(i);
             String seleced = "";
             if (comboBox.getSelectedIndex() != -1)
             {
                 seleced = comboBox.getSelectedItem().toString();
             }
             comboBox.removeAllItems();
             // jHeaderPanel.add(comboBox);
             Vector <String> dinstinct = mModel.getDistinctColumnValueStrings(realIndex);
             Collections.sort(dinstinct, new Comparator<String>() {

                public int compare(String s1, String s2) {
                    return s1.compareTo(s2);
                }
            });
             comboBox.addItem("");
             for (int d=0; d<dinstinct.size();d++)
             {
                 String v = dinstinct.elementAt(d);
                 comboBox.addItem(v);
             }
             if (seleced.length()>0)
                 comboBox.setSelectedItem(seleced);
             jHeaderPanel.repaint();
             x += width+cModel.getColumnMargin()-1;
         }
//jScrollPane2.setSize(jScrollPane2.getWidth(), COMBO_SIZE);

        inEvent--;
    }


    public void setTableStyleSwitchingEnabled(boolean b)
    {
        jPanel1.setVisible(b);
    }
    public JTable getTable()
    {
        return jTable1;
    }

    public CSATableModel getModel()
    {
        return mModel;
    }

     public void setFrame(javax.swing.JFrame frame)
     {
         mFrame = frame;
     }

     /** in View Columns!
      *
      * @param col
      * @param width
      */
     public void setColumnWidth(int col, int width)
     {
         TableColumnModel cModel = jTable1.getColumnModel();

         cModel.getColumn(col).setWidth(width);
         cModel.getColumn(col).setPreferredWidth(width);

         correctFilters();
     }

    public void deleteSelected()     
    {
        int[] rows = jTable1.getSelectedRows();
        if(rows.length==0) return;
        jTable1.tableChanged(null);

        buildFilters();
        mSorter.setRowFilter(null);
        reInit();
    }
    int lastMove=-1;

    MouseAdapter ma=null;
    TableColumnModelListener tcm=null;
    AdjustmentListener adj=null;
    ChangeListener cl = null;
    ListSelectionListener lsl = null;
    
    public void initAll()
    {
        jTable1.removeMouseListener(ma);
        ma = new java.awt.event.MouseAdapter() {
            @Override public void mouseClicked(java.awt.event.MouseEvent evt) {
                mouseClickedOnTable(evt);
            }
            @Override public void mousePressed(java.awt.event.MouseEvent e) {
                mousePressedOnTable(e);
            }
        };
        jTable1.addMouseListener(ma);
        
        resetPopupMenu();
        jTable1.setModel(mModel);
        mSorter = new TableRowSorter<TableModel>(mModel);
        jTable1.setRowSorter(mSorter);
        
        TableColumnModel cModel = jTable1.getColumnModel();
        mModel.setColumnModel(cModel);
        mModel.setParent(this);

        cModel.removeColumnModelListener(tcm);
        tcm = new TableColumnModelListener() {
            public void columnAdded(TableColumnModelEvent e) {}; 
            public void columnMarginChanged(ChangeEvent e) 
            {
                correctFilters();
            }; 
            public void columnMoved(TableColumnModelEvent e) 
            {
                if (inEvent>0) return;
                if (lastMove == e.getToIndex()) return;
                lastMove = e.getToIndex();
                if (didColumnMove())
                    buildFilters();
            };
            public void columnRemoved(TableColumnModelEvent e) {}; 
            public void columnSelectionChanged(ListSelectionEvent e)  {}; 
        };
        cModel.addColumnModelListener(tcm);

        buildFilters();

        jTable1.setDefaultRenderer(Integer.class, mModel);
        jTable1.setDefaultRenderer(String.class, mModel);
        jTable1.setDefaultRenderer(Date.class, mModel);
        jTable1.setDefaultRenderer(Double.class, mModel);
        jTable1.setDefaultRenderer(BufferedImage.class, mModel);
        
        jScrollPane1.getHorizontalScrollBar().removeAdjustmentListener(adj);
        adj = new java.awt.event.AdjustmentListener ()
        {
            public void adjustmentValueChanged(AdjustmentEvent evt) 
            {
                alignPosiitons();
            }
        };
        jScrollPane1.getHorizontalScrollBar().addAdjustmentListener(adj);
        
        jScrollPane2.getViewport().removeChangeListener(cl);
        cl = new ChangeListener()
        {
            public void stateChanged(ChangeEvent e) 
            {
                if (inEvent != 0) return;
                inEvent++;
                Point p = jScrollPane1.getViewport().getViewPosition();
                p.y=0;
                jScrollPane2.getViewport().setViewPosition(p);
                inEvent--;
            }
        };
        jScrollPane2.getViewport().addChangeListener(cl);
        
        jTable1.getSelectionModel().removeListSelectionListener(lsl);
        lsl = new ListSelectionListener() {

            public void valueChanged(ListSelectionEvent lse) 
            {
                if (!lse.getValueIsAdjusting()) 
                {
                    fireSelectionChanged();
                }
            }
        };
        jTable1.getSelectionModel().addListSelectionListener(lsl);        
        adjustTable(mData);
    }

    public void reInit()
    {
        getTable().tableChanged(null);
        // jTable1.setModel(mModel);
        mSorter = new TableRowSorter<TableModel>(mModel);
        jTable1.setRowSorter(mSorter);
        buildFilters();
        
        if (mXMLId.length()!=0)
        {
            setXMLId(mXMLId);
        }
        getTable().repaint();
    }



    private void alignPosiitons()
    {
        Point p = jScrollPane1.getViewport().getViewPosition();
        p.y=0;
        inEvent++;
        jScrollPane2.getViewport().setViewPosition(p);
        inEvent--;
    }

    private void correctFilters()
    {
         int x =1;
         int y= 0;
         int width = 0;
         TableColumnModel cModel = jTable1.getColumnModel();
         try
         {
             for (int i=0; i <cModel.getColumnCount(); i++)
             {
                 width = cModel.getColumn(i).getWidth();
                 java.awt.Rectangle bounds = new java.awt.Rectangle();
                 bounds.setSize(width-2, jHeaderPanel.getComponent(i).getHeight());
                 
                 int ch = jHeaderPanel.getComponent(i).getHeight();
                 if ((ch == 0) && (COMBO_SIZE != -1)) ch = COMBO_SIZE;
                 int ph = jHeaderPanel.getHeight();
                 int dif = ph-ch;
                 int difdif = dif/2;
                 if (difdif <= 0) difdif=3;
                 bounds.setLocation(x+1, difdif);
                 
                 jHeaderPanel.getComponent(i).setBounds(bounds);
                 jHeaderPanel.getComponent(i).invalidate();
                 jHeaderPanel.getComponent(i).validate();
                 jHeaderPanel.getComponent(i).repaint();
                 mLastKnownSize=x+width;
                 x += width+cModel.getColumnMargin()-1;
             }
         }
         // update on an empty table might throw an exception...
         catch (Throwable e){}
    }

    String columnOrder = "";
    private boolean didColumnMove()
    {
         jTable1.getColumnModel();
         TableColumnModel cModel = jTable1.getColumnModel();
         String currentOrder = "";
         for (int i=0; i <cModel.getColumnCount(); i++)
         {
             TableColumn tCol = cModel.getColumn(i);
             String name = (String) tCol.getHeaderValue();
             int realIndex = mModel.getRealColumnNumberByName(name);
             currentOrder += "_"+realIndex;
         }
        return !currentOrder.equals(columnOrder);
    }
    private void buildFilters()
    {
        jHeaderPanel.removeAll();
        columnOrder = ""; 
        int x=1;
         int y=0;
//         int height = COMBO_SIZE;
         int width = 0;
         jTable1.getColumnModel();
         TableColumnModel cModel = jTable1.getColumnModel();

         for (int i=0; i <cModel.getColumnCount(); i++)
         {
             TableColumn tCol = cModel.getColumn(i);
             String name = (String) tCol.getHeaderValue();
             int realIndex = mModel.getRealColumnNumberByName(name);

             width = tCol.getWidth();
             javax.swing.JComboBox comboBox = new javax.swing.JComboBox();
             comboBox.setFont(comboBox.getFont().deriveFont(comboBox.getFont().getSize()-2f));

             jHeaderPanel.add(comboBox);
             Vector <String> dinstinct = mModel.getDistinctColumnValueStrings(realIndex);
             Collections.sort(dinstinct, new Comparator<String>() {

                public int compare(String s1, String s2) {
                    return s1.compareTo(s2);
                }
            });
             comboBox.addItem("");
             for (int d=0; d<dinstinct.size();d++)
             {
                 String v = dinstinct.elementAt(d);
                 comboBox.addItem(v);
             }

             comboBox.setName("_"+realIndex);
             columnOrder += "_"+realIndex;
             comboBox.setEditable(true);

             comboBox.addActionListener(new java.awt.event.ActionListener() {
                 public void actionPerformed(java.awt.event.ActionEvent evt) {
                     jFilterComboBoxActionPerformed(evt);
                 }
             });
             java.awt.Rectangle bounds = new java.awt.Rectangle();
             bounds.setSize(width-2, comboBox.getPreferredSize().height);
             
             
                 int ch = comboBox.getHeight();
                 if ((ch == 0) && (COMBO_SIZE != -1)) ch = COMBO_SIZE;
                 int ph = jHeaderPanel.getHeight();
                 int dif = ph-ch;
                 int difdif = dif/2;
                 bounds.setLocation(x+1, difdif);
                 
//                 bounds.setLocation(x+1, y-2);

             comboBox.setBounds(bounds);
             jHeaderPanel.repaint();
             x += width+cModel.getColumnMargin()-1;
         }
//jScrollPane2.setSize(jScrollPane2.getWidth(), COMBO_SIZE);
    }

    public int getViewRowCount()
    {
        return mSorter.getViewRowCount();
    }
    public int getViewColumnCount()
    {
        return mModel.getEnabledColumnCount();
    }
    public Object getViewValue(int r, int c)
    {
         return  mSorter.getModel().getValueAt(mSorter.convertRowIndexToModel(r), c);
    }

    public int getViewIntValue(int r, int c)
    {
         Object o = getViewValue( r,  c);
         if (!(o instanceof Integer)) return 0;
         Integer i=  (Integer) o;
         return  i;
    }
     public int convertRowIndexToView(int r)
     {
         return mSorter.convertRowIndexToView(r);
     }
     public int convertRowIndexToModel(int r)
     {
         return mSorter.convertRowIndexToModel(r);
     }

    public void addCSAListener(CSAListener listener)
    {
        mListener.removeElement(listener);
        mListener.addElement(listener);
    }
    public void removeCSAListener(CSAListener listener)
    {
        mListener.removeElement(listener);
    }
    
    private void resetPopupMenu()
     {
         jColumnSettingMenu.removeAll();
            
        for (int i=0;i<mModel.getRealColumnCount(); i++)
        {
            JCheckBoxMenuItem item = new JCheckBoxMenuItem();
            item.setText(mModel.getRealColumnName(i));
            item.setSelected(mModel.isColumnEnabled(i));
            jColumnSettingMenu.add(item);
            item.addActionListener(new java.awt.event.ActionListener() 
            {
                public void actionPerformed(java.awt.event.ActionEvent evt) 
                {
                    tableColumnChecked(evt);
                }
            });
        }
    }
     
     private void tableColumnChecked(java.awt.event.ActionEvent evt)
     {
         inEvent++;
         JCheckBoxMenuItem item = (JCheckBoxMenuItem) evt.getSource();
         mModel.enableColumn(item.getText(), item.isSelected());
         jTable1.tableChanged(null);
         buildFilters();
         mSorter.setRowFilter(null);
         inEvent--;
     }

    public void mousePressedOnTable(java.awt.event.MouseEvent evt)
    {
        if ( evt.getClickCount() == 2 )
        {
            if (mDClickAction!=null)
            {
                mDClickAction.evt = evt;
                mDClickAction.doIt();
            }
            else
            {
            }
        }
    }
    
    public void setDoubleClickAction(DoubleClickAction action)
    {
        mDClickAction = action;
    }
    
    private Frame getFrame()
    {
        Container c =getParent();
        while (!(c instanceof Frame))
        {
            c = c.getParent();
        }
        return (Frame) c;
    }
    
    public void mouseClickedOnTable(java.awt.event.MouseEvent evt)
    {
        if (evt.getButton() == java.awt.event.MouseEvent.BUTTON3)
        {
            JTable table = (JTable) evt.getSource();
            mRow = table.convertRowIndexToModel(table.rowAtPoint(evt.getPoint()));
            mCol = table.convertColumnIndexToModel(table.columnAtPoint(evt.getPoint())); 
            mCol = mModel.convertEnabledColToRealCol(mCol);
            if (isTablePopupEnabled())
            jPopupMenu1.show(evt.getComponent(), evt.getX(), evt.getY());
        
            else
            {
                if (mOtherPopup!=null)
                {
                    mOtherPopup.show(evt.getComponent(), evt.getX(), evt.getY());
                }
            }
        
        }
    }
        
    public boolean isTablePopupEnabled() {return mEnablePopup;}
    public void setTablePopupEnabled(boolean b) {mEnablePopup =b;}

    public boolean isTableDClickEnabled() {return mEnableDClick;}
    public void setTableDClickEnabled(boolean b) {mEnableDClick =b;}
    
    public javax.swing.JPopupMenu getPopUp()
    {
        return jPopupMenu1;
    }
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPopupMenu1 = new javax.swing.JPopupMenu();
        jSeparator1 = new javax.swing.JSeparator();
        jColumnSettingMenu = new javax.swing.JMenu();
        jMenuItemExcel = new javax.swing.JMenuItem();
        jMenuItemSave = new javax.swing.JMenuItem();
        jPanel1 = new javax.swing.JPanel();
        jCheckBox4 = new javax.swing.JCheckBox();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jScrollPane2 = new javax.swing.JScrollPane();
        jHeaderPanel = new javax.swing.JPanel();
        jComboBox1 = new javax.swing.JComboBox();

        jPopupMenu1.add(jSeparator1);

        jColumnSettingMenu.setText("Columns");
        jPopupMenu1.add(jColumnSettingMenu);

        jMenuItemExcel.setText("To Excel");
        jMenuItemExcel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemExcelActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemExcel);

        jMenuItemSave.setText("Save Tablestate");
        jMenuItemSave.setEnabled(false);
        jMenuItemSave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemSaveActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemSave);

        addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                formComponentResized(evt);
            }
        });

        jCheckBox4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox4ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jCheckBox4)
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jCheckBox4)
        );

        jTable1.setAutoCreateRowSorter(true);
        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane1.setViewportView(jTable1);

        jScrollPane2.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane2.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
        jScrollPane2.setMinimumSize(new java.awt.Dimension(8, 16));

        jHeaderPanel.setMinimumSize(new java.awt.Dimension(0, 0));
        jHeaderPanel.setLayout(null);

        jComboBox1.setEditable(true);
        jComboBox1.setFont(jComboBox1.getFont().deriveFont(jComboBox1.getFont().getSize()-2f));
        jComboBox1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jHeaderPanel.add(jComboBox1);
        jComboBox1.setBounds(160, 0, 97, 17);

        jScrollPane2.setViewportView(jHeaderPanel);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 395, Short.MAX_VALUE)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 395, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 26, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 239, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
    }// </editor-fold>//GEN-END:initComponents


public void addSelectionListerner(SelectionChangedListener listener)
{
    mSelectionListener.removeElement(listener);
    mSelectionListener.addElement(listener);
}

public void removeSelectionListerner(SelectionChangedListener listener)
{
    mSelectionListener.removeElement(listener);
}
public void fireSelectionChanged()
{
    SelectionEvent evt = new SelectionEvent();
    for (int i=0; i<mSelectionListener.size(); i++)
    {
        mSelectionListener.elementAt(i).selectionChanged(evt);
    }
}
public void addFilterListerner(FilterChangedListener listener)
{
    mFilterListener.removeElement(listener);
    mFilterListener.addElement(listener);
}

public void removeFilterListerner(FilterChangedListener listener)
{
    mFilterListener.removeElement(listener);
}
public void fireFilterChanged()
{
    for (int i=0; i<mFilterListener.size(); i++)
    {
        mFilterListener.elementAt(i).filterChanged();
    }
}

private void jCheckBox4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox4ActionPerformed

    if (jCheckBox4.isSelected())
    {
        jTable1.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
    }
    else
    {
        jTable1.setAutoResizeMode(JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    }
}//GEN-LAST:event_jCheckBox4ActionPerformed

private void formComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_formComponentResized

    correctFilters();
    alignPosiitons();
}//GEN-LAST:event_formComponentResized

private void jMenuItemExcelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemExcelActionPerformed

    de.malban.util.ExcelHelper.toExcel(getTable());

}//GEN-LAST:event_jMenuItemExcelActionPerformed

private void jMenuItemSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemSaveActionPerformed
   saveTableState();
}//GEN-LAST:event_jMenuItemSaveActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JMenu jColumnSettingMenu;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JPanel jHeaderPanel;
    private javax.swing.JMenuItem jMenuItemExcel;
    private javax.swing.JMenuItem jMenuItemSave;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPopupMenu jPopupMenu1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JTable jTable1;
    // End of variables declaration//GEN-END:variables
   public boolean askCancel(String text){return true;}
   public boolean giveInfo(String text, int currentItem, int itemCount) { return true; }
   private javax.swing.JPopupMenu mOtherPopup=null;
   public void setPopupMenu(javax.swing.JPopupMenu jPopupMenu1)
   {
       mOtherPopup=jPopupMenu1;
   }





   public void saveTableState()
   {
       if (mXMLId.trim().length()==0) return;
        TableStateDataPool pool = new TableStateDataPool("TableStateData.xml");
        pool.put(builtTableStateData());
        pool.save();
   }

   private String mXMLId="";
   private TableStateData mData=null;
   public void setXMLId(String id)
   {
       mXMLId = id;
        jMenuItemSave.setEnabled(true);
        try
        {
            TableStateDataPool pool = new TableStateDataPool("TableStateData.xml");
            mData = pool.get(mXMLId);
            if (mData != null)
                adjustTable(mData);
        }
        catch(Throwable e)
        {
            e.printStackTrace();
        }
   }
    private void adjustTable(TableStateData data)
    {
        if (data == null) return;
         inEvent++;
         TableColumnModel cModel = jTable1.getColumnModel();
         int enabledCounter=0;
         for (int c=0; c <mModel.getRealColumnCount(); c++)
         {
            boolean enabled = true;
            try
            {
                 enabled = data.getColumnEnabled().elementAt(c);
                 String colName = data.getColumnName().elementAt(c);
                 int orgPos = data.getColumnOrgNo().elementAt(c);
                 int viewPos = data.getColumnViewNo().elementAt(c);
                 int width = data.getColumnWidth().elementAt(c);
                 mModel.enableColumn(colName, enabled);
            }
            catch (Throwable ee){}
             if (enabled)
             {
                 enabledCounter++;
             }
         }
         resetPopupMenu();
         jTable1.tableChanged(null);
         enabledCounter=0;
         for (int c=0; c <mModel.getRealColumnCount(); c++)
         {
            boolean enabled = true;
            int width = 100;
            try
            {
                enabled = data.getColumnEnabled().elementAt(c);
                width = data.getColumnWidth().elementAt(c);
            }
            catch (Throwable ee){}

             if (enabled)
             {
                 cModel.getColumn(enabledCounter).setPreferredWidth(width);
                 cModel.getColumn(enabledCounter).setWidth(width);
                 cModel.getColumn(enabledCounter).setPreferredWidth(width);
                 enabledCounter++;
             }
         }
         mSorter.setRowFilter(null);
         orderColumns(data.mColumnViewNo, data.mColumnName);
         buildFilters();
         inEvent--;
    }

    int getViewIndex(String id)
    {
         TableColumnModel cModel = jTable1.getColumnModel();
         for (int i=0;i <cModel.getColumnCount();i++)
         {
             TableColumn column = cModel.getColumn(i);
             String headerI = column.getHeaderValue().toString();
          
             if (id.equals(headerI))
             {
                 return i;
             }
         }
         return -1;
    }


    private TableStateData builtTableStateData()
    {
         TableStateData data=new TableStateData();
         data.mName=mXMLId;
         data.mClass="TableState";
         TableColumnModel cModel = jTable1.getColumnModel();
         int enabledCounter=0;
         for (int c=0; c <mModel.getRealColumnCount(); c++)
         {
             boolean enabled = mModel.isColumnEnabled(c);
             String colName = mModel.getRealColumnName(c);
             int viewPos = getViewIndex(colName);
             int orgPos = c;
             int width = 50;
             if (enabled)
             {
                 width = cModel.getColumn(viewPos).getWidth();
                 enabledCounter++;
             }

             data.mColumnEnabled.add(enabled);
             data.mColumnOrgNo.add(orgPos);
             data.mColumnViewNo.add(viewPos);
             data.mColumnWidth.add(width);
             data.mColumnName.add(colName);
         }
         return data;
    }

    public void orderColumns( Vector<Integer> cPos,  Vector<String> names)
    {
        class NamedPos
        {
            int pos;
            String name;
            NamedPos(int p, String n)
            {
                pos = p;
                name = n;
            }
        }
        Vector<NamedPos> namedPositions = new Vector<NamedPos>();

        for (int i=0; i <cPos.size(); i++)
        {
            Integer pos = cPos.elementAt(i);
            if (pos != -1)
            {
                namedPositions.addElement( new NamedPos(cPos.elementAt(i), names.elementAt(i)));
            }
        }
        Collections.sort(namedPositions, new Comparator<NamedPos>()
        {
           public int compare(NamedPos s1, NamedPos s2)
           {
                return s1.pos-s2.pos;
           }
        });

        TableColumnModel model = jTable1.getColumnModel();
        for (int i=0; i<namedPositions.size(); i++)
        {
            int pos = namedPositions.elementAt(i).pos;
            String name = namedPositions.elementAt(i).name;
            int tableCol = -1;

            for (int c=0; c<model.getColumnCount(); c++)
            {
                TableColumn column = model.getColumn(c);
                String name2 = column.getHeaderValue().toString();
                if (name2.equals(name))
                {
                    tableCol=c;
                    break;
                }
            }
            if (tableCol != -1)
            try
            {
                jTable1.moveColumn(tableCol, pos);
            }
            catch (Throwable e)
            {
                System.out.println("Warning! Column Move failed. ("+tableCol+" <->"+pos+")");
            }
        }
    }

    private void jFilterComboBoxActionPerformed(java.awt.event.ActionEvent evt) {

        if (inEvent>0) return;
        inEvent++;

         jTable1.getColumnModel();
         TableColumnModel cModel = jTable1.getColumnModel();

         Vector <RowFilter<Object,Object>> filtersNot = new Vector <RowFilter<Object,Object>>();
         Vector <RowFilter<Object,Object>> filtersAnd = new Vector <RowFilter<Object,Object>>();


         for (int i=0; i <cModel.getColumnCount(); i++)
         {
             TableColumn tCol = cModel.getColumn(i);
             String name = (String) tCol.getHeaderValue();
             javax.swing.JComboBox comboBox = (javax.swing.JComboBox)jHeaderPanel.getComponent(i);
             String sel = comboBox.getSelectedItem().toString();
             if (sel.trim().length() == 0)
             {
                continue;
             }
             boolean notti = false;
             if (sel.startsWith("!"))
             {
                 notti=true;
                 sel = sel.substring(1);
             }
             sel = de.malban.util.UtilityString.escapeRegExp(sel);

             int  enabledIndex = mModel.getEnabledColumnNumberByName(name);

             RowFilter<Object,Object> filter;
                filter = RowFilter.regexFilter(sel,enabledIndex);
             if (notti)
                 filtersNot.addElement(filter);
             else
                 filtersAnd.addElement(filter);
         }

         RowFilter<Object,Object> allFilter = RowFilter.andFilter(filtersAnd);

         for (int i = 0; i < filtersNot.size(); i++)
        {
            RowFilter<Object, Object> rowFilter = filtersNot.elementAt(i);
            allFilter = allFilter.notFilter(rowFilter);

        }
         if (filtersAnd.size()+filtersNot.size()==0)
         {
            mSorter.setRowFilter(null);
         }
         else
         {
            mSorter.setRowFilter(allFilter);
         }
        inEvent--;
        fireFilterChanged();
    }

    public void setRowHeight (int h)
    {
        jTable1.setRowHeight(h);
    }
    public int getRowHeight()
    {
        return jTable1.getRowHeight();
    }
    
    // returns intager array of model rows NOT view rows
    public int[] getSelectedRows()
    {
        int[] rows =  jTable1.getSelectedRows();
        if (rows.length == 0)
        {
            int row = jTable1.getSelectedRow();
            if (row == -1) return new int[0];
            rows = new int[1];
            rows[0] = row;
        }
        int[] tRows = new int[rows.length]; // translated Rows
        
        
        for (int i = 0; i< rows.length; i++)
        {
            tRows[i] = convertRowIndexToModel(rows[i]);
        }
        return tRows;
    }
    
    public void setHeaderEnabled(boolean b)
    {
        jHeaderPanel.setVisible(b);
        jScrollPane2.setVisible(b);
    }
}
