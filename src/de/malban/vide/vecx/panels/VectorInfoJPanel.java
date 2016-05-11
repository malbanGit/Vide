/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.panels;

import de.malban.vide.vecx.VecXPanel;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.vecx.VecX;
import de.malban.vide.vecx.VecXStatics;
import java.awt.Point;
import java.io.Serializable;
import java.util.ArrayList;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.SwingUtilities;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author malban
 */
public class VectorInfoJPanel extends javax.swing.JPanel implements
        Windowable, Stateable{
    public boolean isLoadSettings() { return true; }
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private DissiPanel dissi = null;
    private VecXPanel vecxPanel = null;
    ArrayList<Integer> callStack = new ArrayList<Integer>();
    int x0 = 0;
    int y0 = 0;
    int x1 = 0;
    int y1 = 0;
    int color = 0;
    int pc = 0;
    
    public void setVecxy(VecXPanel v)
    {
        vecxPanel = v;
        jTable1.setModel(new CallStackTableModel());
    }

    public class CallStackTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            return callStack.size();
        }
        public int getColumnCount()
        {
            return 1;
        }
        public Object getValueAt(int row, int col)
        {
            return "$"+String.format("%04X", callStack.get(row));
        }
        public int getAddress(int row)
        {
            return callStack.get(row);
        }
        public String getColumnName(int column) {
            return "";
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
    }
    
    @Override
    public void closing()
    {
        if (vecxPanel != null) vecxPanel.resetVinfi();
        deinit();
    }
    @Override
    public void setParentWindow(CSAView jpv)
    {
        mParent = jpv;
    }
    @Override
    public void setMenuItem(javax.swing.JMenuItem item)
    {
        mParentMenuItem = item;
        mParentMenuItem.setText("Vector Information");
    }
    @Override
    public javax.swing.JMenuItem getMenuItem()
    {
        return mParentMenuItem;
    }
    @Override
    public javax.swing.JPanel getPanel()
    {
        return this;
    }
    public void deinit()
    {
    }
    /**
     * Creates new form RegisterJPanel
     */
    public VectorInfoJPanel() {
        initComponents();
        jTable1.setTableHeader(null);
    }

    public void setDissi(DissiPanel d)
    {
        dissi = d;
    }

    public void setMouseCoordinates(int x, int y)
    {
        SwingUtilities.invokeLater(new Runnable()
         {
             public void run()
             {
                String out ="";
                int x0 = x;
                if (x<0) 
                {
                    out+="-";
                    x0=x0*-1;
                }
                out+="$"+String.format("%04X",x0 & 0xffff)+",";
                y0 = y;
                if (y<0) 
                {
                    out+="-";
                    y0=y0*-1;
                }
                out+="$"+String.format("%04X",y0 & 0xffff);
                  
                 
                jLabel16.setText(out);
                jLabel16.setToolTipText("Mouse position in vectrex coordinates: Dec: "+x+", "+y );
                repaint();
             }
         });                    
    }
    
    public void update(VecX.vector_t v)
    {
        callStack.clear();
        pc = -1;
        if (v == null)
        {
            jTable1.tableChanged(null);
            jLabel11.setText("");
            jLabel12.setText("");
            jLabel15.setText("");
            jLabel14.setText("");
            jLabel13.setText("");
            jLabel14.setText("");
            jLabel11.setToolTipText("");
            jLabel12.setToolTipText("");
            jLabel15.setToolTipText("");
            jLabel14.setToolTipText("");
            jLabel13.setToolTipText("");
            jLabel14.setToolTipText("");
            return;
        }
        for (int i=0; i< v.callStack.size()-1; i++)
            callStack.add(v.callStack.get(i));
        pc = v.callStack.get(v.callStack.size()-1);

        x0 = v.x0-VecXStatics.ALG_MAX_X/2;
        y0 = -(v.y0-VecXStatics.ALG_MAX_Y/2);
        x1 = v.x1-VecXStatics.ALG_MAX_X/2;
        y1 = -(v.y1-VecXStatics.ALG_MAX_Y/2);
        color = v.color;
        
        jTable1.tableChanged(null);
        if (x0>=0)
            jLabel11.setText("$"+String.format("%04X",x0 & 0xffff));
        else
            jLabel11.setText("-$"+String.format("%04X",(x0*-1) & 0xffff));
        jLabel11.setToolTipText("decimal: "+(x0 & 0xffff)+"display: "+v.x0);

        if (y0>=0)
            jLabel12.setText("$"+String.format("%04X", y0 & 0xffff));
        else
            jLabel12.setText("-$"+String.format("%04X",(y0*-1) & 0xffff));
        jLabel12.setToolTipText("decimal: "+(y0 & 0xffff)+"display: "+v.y0);

        if (x1>=0)
            jLabel15.setText("$"+String.format("%04X", x1 & 0xffff));
        else
            jLabel15.setText("-$"+String.format("%04X",(x1*-1) & 0xffff));

        jLabel15.setToolTipText("decimal: "+(x1 & 0xffff)+", width: "+((x1 & 0xffff)-(x0 & 0xffff))+"display: "+v.x1);
        
        if (y1>=0)
            jLabel14.setText("$"+String.format("%04X", y1 & 0xffff));
        else
            jLabel14.setText("-$"+String.format("%04X",(y1*-1) & 0xffff));
        jLabel14.setToolTipText("decimal: "+(y1 & 0xffff)+", height: "+((y1 & 0xffff)-(y0 & 0xffff))+"display: "+v.y1);
        
        jLabel13.setText("$"+String.format("%02X", color & 0xff));
        jLabel13.setToolTipText("decimal: "+(color & 0xff));

        jLabel17.setText("$"+String.format("%04X", pc & 0xffff));
        jLabel17.setToolTipText("decimal: "+(pc & 0xffff));
        
        
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jLabel11 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jLabel14 = new javax.swing.JLabel();
        jLabel15 = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();

        setName("regi"); // NOI18N

        jLabel1.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel1.setText("X0");

        jLabel2.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel2.setText("Y0");

        jLabel3.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel3.setText("X1");

        jLabel4.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel4.setText("Y1");

        jLabel5.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel5.setText("I");

        jLabel8.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel8.setText("PC");

        jScrollPane1.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jTable1.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null},
                {null},
                {null},
                {null}
            },
            new String [] {
                "Adr"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Integer.class
            };
            boolean[] canEdit = new boolean [] {
                false
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jTable1.setShowGrid(false);
        jTable1.setShowHorizontalLines(true);
        jTable1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTable1MousePressed(evt);
            }
        });
        jScrollPane1.setViewportView(jTable1);

        jLabel11.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel11.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        jLabel11.setText("$ff");

        jLabel12.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel12.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        jLabel12.setText("$ff");

        jLabel13.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel13.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        jLabel13.setText("$ffff");

        jLabel14.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel14.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        jLabel14.setText("$ffff");

        jLabel15.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel15.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        jLabel15.setText("$ffff");

        jLabel17.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel17.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        jLabel17.setText("$ffff");
        jLabel17.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel17MousePressed(evt);
            }
        });

        jLabel16.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel16.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        jLabel16.setText("$ffff, $ffff");
        jLabel16.setToolTipText("Mouse coordinates in vectrex coordinates");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 64, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel17, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel13, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel14, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                                .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel11, javax.swing.GroupLayout.PREFERRED_SIZE, 51, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel15, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(jLabel12, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))))
                    .addComponent(jLabel16, javax.swing.GroupLayout.PREFERRED_SIZE, 93, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(21, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(jLabel11))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jLabel12))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel4)
                            .addComponent(jLabel14)))
                    .addComponent(jLabel15))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel5)
                    .addComponent(jLabel13))
                .addGap(22, 22, 22)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel8)
                    .addComponent(jLabel17))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel16)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jTable1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable1MousePressed
        if (evt.getClickCount() == 2) 
        {
            JTable table =(JTable) evt.getSource();
            Point p = evt.getPoint();
            int row = table.rowAtPoint(p);
            // your valueChanged overridden method 
            if (dissi != null)
                dissi.goAddress(((CallStackTableModel)table.getModel()).getAddress(row), true, true, true);
        }
    }//GEN-LAST:event_jTable1MousePressed

    private void jLabel17MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel17MousePressed
        if (pc != -1)
        if (evt.getClickCount() == 2) 
            if (dissi != null) dissi.goAddress(pc & 0xffff, true, true, true);
    }//GEN-LAST:event_jLabel17MousePressed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTable1;
    // End of variables declaration//GEN-END:variables

    public static String SID = "vinfi";
    public String getID()
    {
        return SID;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}

 }
