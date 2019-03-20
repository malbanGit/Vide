/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.panels;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.vide.vecx.VecXPanel;
import de.malban.gui.Scaler;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.vecx.Updatable;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.Serializable;
import java.util.Vector;
import javax.swing.DefaultComboBoxModel;

/**
 *
 * @author malban
 */
public class WRTrackerJPanel extends javax.swing.JPanel implements
        Windowable, Stateable, Updatable{
    public boolean isLoadSettings() { return true; }
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private VecXPanel vecxPanel = null; // needed for vectrex memory access
    public static String SID = "tracki";

    BufferedImage[] image = new BufferedImage[2];
    int imageSwitch = 0;
    int displayWidth = 0;
    int displayheight = 0;
    double scaleWidth = 0;
    double scaleHeight = 0;
    
    int SCALE_WR_MAX_CYCLES = 100000;
    
    int avgCount = 0;
    long avg = 0;
    int max = 0;
    int min = Integer.MAX_VALUE;
    
    
    public static class TrackiInfo implements Serializable
    {
        int start;
        int end;
        int bank;
        String name;
        public String toString()
        {
            return name;
        }
        public boolean equals(TrackiInfo other)
        {
//            if (start != other.start) return false;
//            if (end != other.end) return false;
            return (name.equals(other.name));
        }
    }
    Vector<TrackiInfo> persistentInfo = new Vector<TrackiInfo>();

    protected boolean loadSettings()
    {
        mClassSetting++;
        jComboBox1.setModel(new DefaultComboBoxModel(persistentInfo));
        mClassSetting--;
        try
        {
            persistentInfo = (Vector<TrackiInfo>) CSAMainFrame.deserialize(Global.mainPathPrefix+"serialize"+File.separator+"TrackiInfo.ser");
            if (persistentInfo == null) 
            {
                persistentInfo = new Vector<TrackiInfo>();
                return false;
            }
        }
        catch (Throwable e)
        {
            return false;
        }
        mClassSetting++;
        jComboBox1.setModel(new DefaultComboBoxModel(persistentInfo));
        mClassSetting--;

        return true;
    }
    protected boolean saveSettings(boolean fromDelete)
    {
        int oldIndex = jComboBox1.getSelectedIndex();
        TrackiInfo ti = new TrackiInfo();
        if (!fromDelete)
        {
            ti.name = jTextField5.getText();
            if (ti.name.trim().length() == 0) return false;
            ti.start = DASM6809.toNumber(jTextField3.getText());
            ti.end = DASM6809.toNumber(jTextField4.getText());
            ti.bank = DASM6809.toNumber(jTextField7.getText());

            for (int i=0; i< persistentInfo.size(); i++)
            {
                if (persistentInfo.elementAt(i).equals(ti))
                {
                    persistentInfo.removeElementAt(i);
                    break;
                }
            }

            persistentInfo.addElement(ti);
        }
        
        try
        {
            CSAMainFrame.serialize(persistentInfo, Global.mainPathPrefix+"serialize"+File.separator+"TrackiInfo.ser");
        }
        catch (Throwable e)
        {
            return false;
        }
        if (!fromDelete)
            mClassSetting++;
        jComboBox1.setModel(new DefaultComboBoxModel(persistentInfo));
        if (oldIndex>=persistentInfo.size()) oldIndex--;
        jComboBox1.setSelectedIndex(oldIndex);
        if (!fromDelete)
            mClassSetting--;
        return true;
    }    
    
    public String getID()
    {
        return SID;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}
    
    public void setVecxy(VecXPanel v)
    {
        vecxPanel = v;
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
        if (vecxPanel != null) vecxPanel.resetTracki();
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
        mParentMenuItem.setText("Tracker");
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
    public WRTrackerJPanel() {
        initComponents();
        loadSettings();
    }

    public long lastTest = 0;
    private void update()
    {        
        synchronized (image)
        {

            if (image == null) return;
            if (vecxPanel == null) return;
            if (lastTest == vecxPanel.getLastWaitRecalTest()) 
                return;

            lastTest= vecxPanel.getLastWaitRecalTest();
            int lastDisplayed = imageSwitch;
            imageSwitch = (imageSwitch+1)%2;
            if (image[imageSwitch]==null) return;
            Graphics2D g2 = image[imageSwitch].createGraphics();
            g2.drawImage(image[lastDisplayed], 0 , 0,displayWidth-2, displayheight, 2,0,displayWidth, displayheight, this);


            g2.clearRect(displayWidth-2, 0, 2, displayheight);

            int[] wrBuffer = vecxPanel.getCurrentWaitRecalBuffer();
            int current = vecxPanel.getCurrentWaitRecalBufferPos();
            int v = 1;
            current = (current + (wrBuffer.length-1)) % wrBuffer.length; // step backwards
            int height = wrBuffer[current];
            
            boolean skip = false;

            if (height > 5* avg) skip = true;
            if (avg == 0) skip = false;
            if (height<=0) skip = true;
            if (height > 1000000) skip = true;
 
            String tt = "Samples: "+vecxPanel.getTrackiCount()+", >30000: "+vecxPanel.getTrackiAbove();
jTextField2.setToolTipText(tt);
jTextFieldCurrent.setToolTipText(tt);
jTextField1.setToolTipText(tt);
jTextField6.setToolTipText(tt);
            
            
            if (!skip)
            {
                jTextFieldCurrent.setText(""+(height));
                avg = avg +height;
                avgCount++;

                jTextField6.setText(""+(avg/avgCount));

                if (max< height) 
                {
                    max = height;
                    jTextField2.setText(""+max);
                }
                if (min> height) 
                {
                    min = height;
                    jTextField1.setText(""+min);
                }
            }


            Color c = new Color(255,255,0,255);
            g2.setColor(c);
            double x0=image[imageSwitch].getWidth()-2*v;
            double y0=image[imageSwitch].getHeight();
            double x1=x0;
            double y1=SCALE_WR_MAX_CYCLES-height;

            y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);

            g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));

            g2.dispose();
            repaint();
        }
        
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jToggleButton4 = new javax.swing.JToggleButton();
        jLabel3 = new javax.swing.JLabel();
        jTextField4 = new javax.swing.JTextField();
        jTextField3 = new javax.swing.JTextField();
        jButton1 = new javax.swing.JButton();
        jTextField7 = new javax.swing.JTextField();
        jPanel3 = new javax.swing.JPanel();
        jButtonDelete = new javax.swing.JButton();
        jButtonSave = new javax.swing.JButton();
        jTextField5 = new javax.swing.JTextField();
        jComboBox1 = new javax.swing.JComboBox();
        jPanel4 = new javax.swing.JPanel();
        jTextFieldCurrent = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jTextField6 = new javax.swing.JTextField();
        jTextField1 = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        jLabel1 = new javax.swing.JLabel();
        jTextField2 = new javax.swing.JTextField();

        setName("regi"); // NOI18N
        addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                formComponentResized(evt);
            }
        });

        jPanel1.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel1.setPreferredSize(new java.awt.Dimension(345, 70));

        jToggleButton4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton4.setSelected(true);
        jToggleButton4.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton4.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton4.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton4ActionPerformed(evt);
            }
        });

        jLabel3.setText("addresses");

        jTextField4.setText("$F192");
        jTextField4.setToolTipText("lower address");
        jTextField4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField4ActionPerformed(evt);
            }
        });

        jTextField3.setText("$F1A2");
        jTextField3.setToolTipText("higher address");

        jButton1.setText("reset");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jTextField7.setText("0");
        jTextField7.setToolTipText("bank");
        jTextField7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField7ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(10, 10, 10)
                .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 86, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(4, 4, 4)
                .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField4, javax.swing.GroupLayout.DEFAULT_SIZE, 64, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField3, javax.swing.GroupLayout.DEFAULT_SIZE, 64, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton1, javax.swing.GroupLayout.DEFAULT_SIZE, 78, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        jButtonDelete.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/delete.png"))); // NOI18N
        jButtonDelete.setToolTipText("delete entry");
        jButtonDelete.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonDelete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDeleteActionPerformed(evt);
            }
        });

        jButtonSave.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave.setToolTipText("save current setting");
        jButtonSave.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveActionPerformed(evt);
            }
        });

        jComboBox1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBox1.setPreferredSize(new java.awt.Dimension(59, 20));
        jComboBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addComponent(jTextField5)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jComboBox1, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSave)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonDelete)
                .addGap(0, 0, 0))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addComponent(jButtonSave, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addComponent(jButtonDelete, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addComponent(jComboBox1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jTextFieldCurrent.setText("00000");
        jTextFieldCurrent.setToolTipText("Current cycle count");
        jTextFieldCurrent.setMinimumSize(new java.awt.Dimension(70, 19));
        jTextFieldCurrent.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldCurrentActionPerformed(evt);
            }
        });

        jLabel2.setText("max");

        jTextField6.setText("00000");
        jTextField6.setToolTipText("");
        jTextField6.setMinimumSize(new java.awt.Dimension(70, 19));

        jTextField1.setText("00000");
        jTextField1.setMinimumSize(new java.awt.Dimension(70, 19));

        jLabel4.setText("avg");

        jLabel1.setText("min");

        jTextField2.setText("00000");
        jTextField2.setMinimumSize(new java.awt.Dimension(70, 19));

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jTextFieldCurrent, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(4, 4, 4)
                .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(4, 4, 4)
                .addComponent(jTextField1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(4, 4, 4)
                .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(4, 4, 4)
                .addComponent(jTextField2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(4, 4, 4)
                .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(4, 4, 4)
                .addComponent(jTextField6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextFieldCurrent, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jPanel2, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel3, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(0, 0, 0))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(2, 2, 2)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(2, 2, 2)
                .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, 368, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
        );
    }// </editor-fold>//GEN-END:initComponents

    private void formComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_formComponentResized
        resetGfx();
        update();
        repaint();
    }//GEN-LAST:event_formComponentResized

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        max = 0;
        min = Integer.MAX_VALUE;
        avg = 0;
        avgCount = 0;
        if (vecxPanel == null) return;
        int[] wrBuffer = vecxPanel.getCurrentWaitRecalBuffer();
        for (int v = 0; v < wrBuffer.length; v++) 
        {
            wrBuffer[v] = 0;
	}  
        int start = DASM6809.toNumber(jTextField3.getText());
        int end = DASM6809.toNumber(jTextField4.getText());
        int bank = DASM6809.toNumber(jTextField7.getText());
        vecxPanel.resetAllTimeLowStack();
        
        vecxPanel.setTrackingAddress(start, end, bank);
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jToggleButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton4ActionPerformed
        updateEnabled = jToggleButton4.isSelected();
    }//GEN-LAST:event_jToggleButton4ActionPerformed

    private void jTextField4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField4ActionPerformed
        
    }//GEN-LAST:event_jTextField4ActionPerformed

    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed
        saveSettings(false);
    }//GEN-LAST:event_jButtonSaveActionPerformed

    private void jComboBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox1ActionPerformed
        if (mClassSetting>0) return;
        if (jComboBox1.getSelectedIndex() == -1) return;
        TrackiInfo info = (TrackiInfo)jComboBox1.getSelectedItem();
        jTextField5.setText(info.name);
        jTextField3.setText("$"+String.format("%04X",info.start&0xffff));
        jTextField4.setText("$"+String.format("%04X",info.end&0xffff));
        
        jTextField7.setText(""+info.bank);
        
        // reset
        jButton1ActionPerformed(null);        
    }//GEN-LAST:event_jComboBox1ActionPerformed

    private void jButtonDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteActionPerformed

        if (mClassSetting>0) return;
        if (jComboBox1.getSelectedIndex() == -1) return;
        TrackiInfo info = (TrackiInfo)jComboBox1.getSelectedItem();

        for (int i=0; i< persistentInfo.size(); i++)
        {
            if (persistentInfo.elementAt(i).equals(info)) 
            {
                persistentInfo.removeElementAt(i);
                break;
            }
        }

        saveSettings(true);
        
    }//GEN-LAST:event_jButtonDeleteActionPerformed

    private void jTextFieldCurrentActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldCurrentActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldCurrentActionPerformed

    private void jTextField7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField7ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField7ActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButtonDelete;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField3;
    private javax.swing.JTextField jTextField4;
    private javax.swing.JTextField jTextField5;
    private javax.swing.JTextField jTextField6;
    private javax.swing.JTextField jTextField7;
    private javax.swing.JTextField jTextFieldCurrent;
    private javax.swing.JToggleButton jToggleButton4;
    // End of variables declaration//GEN-END:variables


    
    private void resetGfx()
    {
        if (getWidth() == 0) return;
        if (getHeight() == 0) return;
        image[0] = de.malban.util.UtilityImage.getNewImage(getWidth(), getHeight()-jPanel1.getHeight());
        if (image[0] == null) return;
        image[1] = de.malban.util.UtilityImage.getNewImage(getWidth(), getHeight()-jPanel1.getHeight());
        if (image[1] == null) return;
        
        displayWidth = image[0].getWidth();
        displayheight = image[0].getHeight();
        
        // build an image in the size of this component
        // with vectors on it
        // representing the vectrex vectors
        scaleWidth = ((double)1);
        scaleHeight = ((double)displayheight)/((double)SCALE_WR_MAX_CYCLES);

    }
    @Override public void paintComponent(Graphics g)
    {
        super.paintComponent(g);
        if (image[imageSwitch] != null)
        {
            g.drawImage(image[imageSwitch], 0, jPanel1.getHeight(), null);

            double y=SCALE_WR_MAX_CYCLES-30000;

            y =Scaler.scaleDoubleToInt(y, scaleHeight)+jPanel1.getHeight();

            Color c = new Color(0,255,0,255);
            g.setColor(c);
            g.drawLine(((int) 0), ((int) y), displayWidth,((int) y));
            g.drawString("30000", 10, ((int) y-20));
            c = new Color(255,0,0,255);
            g.setColor(c);
            g.drawString(""+SCALE_WR_MAX_CYCLES, 10, 10+jPanel1.getHeight());
        }
        
    }
    private boolean updateEnabled = true;
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
    public void deIconified() { }
}
