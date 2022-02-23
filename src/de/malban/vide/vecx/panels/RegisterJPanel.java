/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.panels;

import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.vide.vecx.VecXPanel;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.util.KeyboardListener;
import de.malban.vide.VideConfig;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.vecx.E6809;
import de.malban.vide.vecx.Updatable;
import de.muntjak.tinylookandfeel.Theme;
import java.awt.Color;
import java.awt.Point;
import static java.awt.event.ActionEvent.SHIFT_MASK;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.Serializable;
import java.util.ArrayList;
import javax.swing.JTable;
import javax.swing.UIManager;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author malban
 */
public class RegisterJPanel extends javax.swing.JPanel implements
        Windowable, Stateable, Updatable{
    VideConfig config = VideConfig.getConfig();
    public boolean isLoadSettings() { return true; }
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private DissiPanel dissi = null;
    private E6809 e6809 = null;
    private VecXPanel vecxPanel = null; // needed for vectrex memory access
    
    public void setVecxy(VecXPanel v)
    {
        vecxPanel = v;
    }

    public class CallStackTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            return callstack.size();
        }
        public int getColumnCount()
        {
            return 1;
        }
        public Object getValueAt(int row, int col)
        {
            try
            {

                if (row<callstack.size())
                    return "$"+String.format("%04X", callstack.get(row));
            }
            catch (Throwable e)
            {
                // sometimes synch problems
                // when updated "on the fly"
                // rather than synchronize everything
                // everything - I jest catch and ignore
            }
            return "";
        }
        public int getAddress(int row)
        {
            if (row == -1) return 0;
            return callstack.get(row);
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
    
    @Override public boolean isIcon()
    {
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        if (frame.getInternalFrame(this) == null) return false;
        return frame.getInternalFrame(this).isIcon();
    }
    @Override public void setIcon(boolean b)
    {
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        if (frame.getInternalFrame(this) == null) return;
        try
        {
            frame.getInternalFrame(this).setIcon(b);
        }
        catch (Throwable e){}
    }
    @Override
    public void closing()
    {
        if (vecxPanel != null) vecxPanel.resetRegi();
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
        mParentMenuItem.setText(SID);
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
        removeUIListerner();
    }
    /**
     * Creates new form RegisterJPanel
     */
    public RegisterJPanel() {
        initComponents();
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
        jTable1.setTableHeader(null);
        jTable1.setModel(new CallStackTableModel());
    }

    public void setE6809(E6809 e)
    {
        e6809 = e;
        update();
    }
    public void setDissi(DissiPanel d)
    {
        dissi = d;
    }
    /* bittest() - test on a single bit, 1-8 */
    static boolean bittest(int c, int bitnumber)
    {
        while (--bitnumber>0)
        {
            c = (c >> 1);
        }
        return ((c&1)==1);
    }
    /* printbinary() - 8 bit ... */
    public static String printbinary(int c)
    {
        String ret = "";
        int i=8;
        while (i>0)
        {
            if (bittest(c,i))
                ret += "1";
            else
                ret += "0";
            i--;
        }
        return ret;
    }
    
    int reg_x;
    int reg_y;
    /* user stack pointer */
    int reg_u = 0;
    /* hardware stack pointer */
    int reg_s= 0;
    /* program counter */
    int reg_pc;
    /* accumulators */
    int reg_a;
    int reg_b;
    /* direct page register */
    int reg_dp;
    /* condition codes */
    int reg_cc;
    int reg_d;
    int bank;
    ArrayList<Integer> callstack = new ArrayList<Integer>();
    private void update()
    {
        callstack.clear();
        if (e6809 == null) return;
        synchronized (e6809.callStack)
        {
            try
            {
                for(Integer i: e6809.callStack) callstack.add(i);
            }
            catch (Throwable ex)
            {
                
            }
        }
        jTable1.tableChanged(null);
        
        if (vecxPanel!=null)
            jLabelCycles.setText(""+vecxPanel.getCyclesRunning());
        
        jLabel11.setText("$"+String.format("%02X", e6809.reg_a));
        if (e6809.reg_a != reg_a) jLabel11.setForeground(config.getValueChangedColor());
        else jLabel11.setForeground(config.getValueNotChangedColor());
        reg_a = e6809.reg_a&0xff;
        jLabel11.setToolTipText("decimal: "+reg_a+"("+((reg_a>127)?(reg_a-256):(reg_a))+"), binary: %"+printbinary(reg_a));
        
        jLabel12.setText("$"+String.format("%02X", e6809.reg_b));
        if (e6809.reg_b != reg_b) jLabel12.setForeground(config.getValueChangedColor());
        else jLabel12.setForeground(config.getValueNotChangedColor());
        reg_b = e6809.reg_b&0xff;
        jLabel12.setToolTipText("decimal: "+reg_b+"("+((reg_b>127)?(reg_b-256):(reg_b))+"), binary: %"+printbinary(reg_b));
        
        int d = ((reg_a << 8)&0xff00) | (reg_b & 0xff);
        jLabel15.setText("$"+String.format("%04X", d));
        if (reg_d != d) jLabel15.setForeground(config.getValueChangedColor());
        else jLabel15.setForeground(config.getValueNotChangedColor());
        reg_d = d&0xffff;
        jLabel15.setToolTipText("decimal: "+d+"("+((reg_d>32767)?(reg_d-65536):(reg_d))+"), binary: %"+printbinary(reg_a)+ " " + printbinary(reg_b));
        
        jLabel14.setText("$"+String.format("%04X", e6809.reg_x&0xffff));
        if (e6809.reg_x != reg_x) jLabel14.setForeground(config.getValueChangedColor());
        else jLabel14.setForeground(config.getValueNotChangedColor());
        reg_x = e6809.reg_x&0xffff;
        jLabel14.setToolTipText("decimal: "+reg_x+"("+((reg_x>32767)?(reg_x-65536):(reg_x))+"), binary: %"+printbinary((reg_x>>8)&0xff)+ " " + printbinary(reg_x&0xff));

        jLabel13.setText("$"+String.format("%04X", e6809.reg_y&0xffff));
        if (e6809.reg_y != reg_y) jLabel13.setForeground(config.getValueChangedColor());
        else jLabel13.setForeground(config.getValueNotChangedColor());
        reg_y = e6809.reg_y&0xffff;
        jLabel13.setToolTipText("decimal: "+reg_y+"("+((reg_y>32767)?(reg_y-65536):(reg_y))+"), binary: %"+printbinary((reg_y>>8)&0xff)+ " " + printbinary(reg_y&0xff));

        jLabel16.setText("$"+String.format("%04X", e6809.reg_u.intValue&0xffff));
        if (e6809.reg_u.intValue != reg_u) jLabel16.setForeground(config.getValueChangedColor());
        else jLabel16.setForeground(config.getValueNotChangedColor());
        reg_u = e6809.reg_u.intValue&0xffff;
        jLabel16.setToolTipText("decimal: "+reg_u+"("+((reg_u>32767)?(reg_u-65536):(reg_u))+"), binary: %"+printbinary((reg_u>>8)&0xff)+ " " + printbinary(reg_u&0xff));

        jLabel17.setText("$"+String.format("%04X", e6809.reg_pc&0xffff));
        if ((e6809.reg_pc&0xffff) != reg_pc) jLabel17.setForeground(config.getValueChangedColor());
        else jLabel17.setForeground(config.getValueNotChangedColor());
        reg_pc = e6809.reg_pc&0xffff;
        jLabel17.setToolTipText("decimal: "+reg_pc+", binary: %"+printbinary((reg_pc>>8)&0xff)+ " " + printbinary(reg_pc&0xff));

        if (vecxPanel!=null)
        {
            jLabel22.setVisible(true);
            jLabel22.setText("["+vecxPanel.getCurrentBank()+"]");
            if (bank !=vecxPanel.getCurrentBank()) jLabel22.setForeground(config.getValueChangedColor());
            else jLabel22.setForeground(config.getValueNotChangedColor());
            bank =vecxPanel.getCurrentBank();
        }
        else
        {
            jLabel22.setVisible(false);
        }
        
        jLabel18.setText("$"+String.format("%02X", e6809.reg_dp&0xff));
        if (e6809.reg_dp != reg_dp) jLabel18.setForeground(config.getValueChangedColor());
        else jLabel18.setForeground(config.getValueNotChangedColor());
        reg_dp = e6809.reg_dp;
        jLabel18.setToolTipText("decimal: "+reg_dp+", binary: %"+printbinary(reg_dp));

        jLabel19.setText("%"+printbinary(e6809.reg_cc).substring(0, 4)+" "+printbinary(e6809.reg_cc).substring(4));
        if (e6809.reg_cc != reg_cc) jLabel19.setForeground(config.getValueChangedColor());
        else jLabel19.setForeground(config.getValueNotChangedColor());
        reg_cc = e6809.reg_cc;
        String html = "<html>";
        html += "decimal: "+reg_cc+", hex: $"+String.format("%02X", reg_cc)+"<BR>";
        html +="<ol>";
        html +="<li>Carry "+(((reg_cc&0x01) == 0x01)?"is set":"is clear")+"</li>";
        html +="<li>Overflow "+(((reg_cc&0x02) == 0x02)?"is set":"is clear")+"</li>";
        html +="<li>Zero "+(((reg_cc&0x04) == 0x04)?"is set":"is clear")+"</li>";
        html +="<li>Negative "+(((reg_cc&0x08) == 0x08)?"is set":"is clear")+"</li>";
        html +="<li>IRQ Mask "+(((reg_cc&0x10) == 0x10)?"is set":"is clear")+"</li>";
        html +="<li>Half Carry "+(((reg_cc&0x20) == 0x20)?"is set":"is clear")+"</li>";
        html +="<li>FIRQ Mask "+(((reg_cc&0x40) == 0x40)?"is set":"is clear")+"</li>";
        html +="<li>Entire Flag "+(((reg_cc&0x80) == 0x80)?"is set":"is clear")+"</li>";
        html +="</ol>";
        html += "</html>";
        
        jLabel19.setToolTipText(html);
        
        jLabel20.setText("$"+String.format("%04X", e6809.reg_s.intValue));
        if (e6809.reg_s.intValue != reg_u) jLabel20.setForeground(config.getValueChangedColor());
        else jLabel20.setForeground(config.getValueNotChangedColor());
        reg_s = e6809.reg_s.intValue;
        jLabel20.setToolTipText("decimal: "+reg_s+"("+((reg_s>32767)?(reg_s-65536):(reg_s))+"), binary: %"+printbinary((reg_s>>8)&0xff)+ " " + printbinary(reg_s&0xff));
        
        
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
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jLabel11 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jLabel14 = new javax.swing.JLabel();
        jLabel15 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        jLabel18 = new javax.swing.JLabel();
        jLabel19 = new javax.swing.JLabel();
        jLabel20 = new javax.swing.JLabel();
        jLabel21 = new javax.swing.JLabel();
        jToggleButton3 = new javax.swing.JToggleButton();
        jLabel22 = new javax.swing.JLabel();
        jLabelCycles = new javax.swing.JLabel();

        setName("regi"); // NOI18N

        jLabel1.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel1.setText("A");

        jLabel2.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel2.setText("B");

        jLabel3.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel3.setText("D");

        jLabel4.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel4.setText("X");

        jLabel5.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel5.setText("Y");

        jLabel6.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel6.setText("U");

        jLabel7.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel7.setText("S");

        jLabel8.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel8.setText("PC");

        jLabel9.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel9.setText("DP");

        jLabel10.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel10.setText("CC");

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
        jTable1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTable1MousePressed(evt);
            }
        });
        jScrollPane1.setViewportView(jTable1);

        jLabel11.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel11.setText("$ff");

        jLabel12.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel12.setText("$ff");

        jLabel13.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel13.setText("$ffff");
        jLabel13.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel13MousePressed(evt);
            }
        });

        jLabel14.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel14.setText("$ffff");
        jLabel14.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel14MousePressed(evt);
            }
        });

        jLabel15.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel15.setText("$ffff");

        jLabel16.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel16.setText("$ffff");
        jLabel16.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel16MousePressed(evt);
            }
        });

        jLabel17.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel17.setText("$ffff");
        jLabel17.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel17MousePressed(evt);
            }
        });

        jLabel18.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel18.setText("$ff");

        jLabel19.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel19.setText("%0000 0000");
        jLabel19.setToolTipText("<html>\n<PRE>\nEntire flag (Bit 7, if set RTI~s=F)\nFIRQ/IRQ interrupt mask (Bit 6/4)  \nHalf carry (Bit 5)                 \nNegative (Bit 3)                   \nZero (Bit 2)                       \nOverflow (Bit 1)                   \nCarry/borrow (Bit 0)\n</PRE>\n</html>");

        jLabel20.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel20.setText("$ffff");
        jLabel20.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel20MousePressed(evt);
            }
        });

        jLabel21.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel21.setText(" EFHI NZVC");
        jLabel21.setToolTipText("<html>\n<PRE>\nEntire flag (Bit 7, if set RTI~s=F)\nFIRQ/IRQ interrupt mask (Bit 6/4)  \nHalf carry (Bit 5)                 \nNegative (Bit 3)                   \nZero (Bit 2)                       \nOverflow (Bit 1)                   \nCarry/borrow (Bit 0)\n</PRE>\n</html>");

        jToggleButton3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton3.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton3.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton3ActionPerformed(evt);
            }
        });

        jLabel22.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel22.setText("[00]");
        jLabel22.setToolTipText("bank number");

        jLabelCycles.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelCycles.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        jLabelCycles.setText("0");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel7)
                            .addComponent(jLabel4)
                            .addComponent(jLabel6)
                            .addComponent(jLabel9)
                            .addComponent(jLabel5)
                            .addComponent(jLabel8)
                            .addComponent(jLabel10)
                            .addComponent(jLabel2)
                            .addComponent(jLabel1))
                        .addGap(5, 5, 5)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel11)
                            .addComponent(jLabel12)
                            .addComponent(jLabel15)
                            .addComponent(jLabel14)
                            .addComponent(jLabel13)
                            .addComponent(jLabel16)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel17)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel22, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel18)
                            .addComponent(jLabel19)
                            .addComponent(jLabel21)
                            .addComponent(jLabel20)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 64, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jToggleButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(3, 3, 3)
                        .addComponent(jLabelCycles, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel3))
                .addGap(0, 0, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jToggleButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabelCycles, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
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
                .addGap(4, 4, 4)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel6)
                    .addComponent(jLabel16))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel8)
                    .addComponent(jLabel17)
                    .addComponent(jLabel22))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel9)
                    .addComponent(jLabel18))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel10)
                    .addComponent(jLabel19))
                .addGap(2, 2, 2)
                .addComponent(jLabel21)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel7)
                    .addComponent(jLabel20))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 130, Short.MAX_VALUE))
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

    private void jLabel14MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel14MousePressed
        if (vecxPanel==null) return;
        if (evt.getClickCount() == 2) 
            if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
                vecxPanel.setDumpToAddress(reg_x);
            else
                if (dissi != null) dissi.goAddress(reg_x, true, true, true);
    }//GEN-LAST:event_jLabel14MousePressed

    private void jLabel13MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel13MousePressed
        if (vecxPanel==null) return;
        if (evt.getClickCount() == 2) 
            if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
                vecxPanel.setDumpToAddress(reg_y);
            else
                if (dissi != null) dissi.goAddress(reg_y, true, true, true);
    }//GEN-LAST:event_jLabel13MousePressed

    private void jLabel16MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel16MousePressed
        if (vecxPanel==null) return;
        if (evt.getClickCount() == 2) 
            if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
                vecxPanel.setDumpToAddress(reg_u);
            else
                if (dissi != null) dissi.goAddress(reg_u, true, true, true);
    }//GEN-LAST:event_jLabel16MousePressed

    private void jLabel17MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel17MousePressed
        if (vecxPanel==null) return;
        if (evt.getClickCount() == 2) 
            if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
                vecxPanel.setDumpToAddress(reg_pc);
            else
                if (dissi != null) dissi.goAddress(reg_pc, true, true,true );
    }//GEN-LAST:event_jLabel17MousePressed

    private void jLabel20MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel20MousePressed
        if (vecxPanel==null) return;
        if (evt.getClickCount() == 2) 
            if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
                vecxPanel.setDumpToAddress(reg_s);
            else
                if (dissi != null) dissi.goAddress(reg_s, true, true, true);
    }//GEN-LAST:event_jLabel20MousePressed

    private void jToggleButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton3ActionPerformed
        updateEnabled = jToggleButton3.isSelected();
    }//GEN-LAST:event_jToggleButton3ActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel18;
    private javax.swing.JLabel jLabel19;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel20;
    private javax.swing.JLabel jLabel21;
    private javax.swing.JLabel jLabel22;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JLabel jLabelCycles;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JToggleButton jToggleButton3;
    // End of variables declaration//GEN-END:variables

    public static String SID = "Debug: Register";
    public String getID()
    {
        return SID;
    }
    @Override public String getFileID()
    {
        return de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replaceWhiteSpaces(SID, ""),":",""),"(",""),")","") ;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}

    private boolean updateEnabled = false;
    public void updateValues(boolean forceUpdate)
    {
        if (!forceUpdate)
            if (!updateEnabled) return;
        update();
    }
    public void setUpdateEnabled(boolean b)
    {
        updateEnabled = b;
    }
    public void removeUIListerner()
    {
        UIManager.removePropertyChangeListener(pListener);
    }
    private PropertyChangeListener pListener = new PropertyChangeListener()
    {
        public void propertyChange(PropertyChangeEvent evt)
        {
            updateMyUI();
        }
    };
    void updateMyUI()
    {
        int fontSize = Theme.textFieldFont.getFont().getSize();
        int rowHeight = fontSize+3;
        jTable1.setRowHeight(rowHeight);
    }
    public void deIconified() { }
    
    
}
