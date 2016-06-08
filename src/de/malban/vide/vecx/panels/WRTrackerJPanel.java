/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.panels;

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
    
    int max = 0;
    int min = Integer.MAX_VALUE;
    
    
    public static class TrackiInfo implements Serializable
    {
        int start;
        int end;
        String name;
        public String toString()
        {
            return name;
        }
        public boolean equals(TrackiInfo other)
        {
            if (start != other.start) return false;
            if (end != other.end) return false;
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
            persistentInfo = (Vector<TrackiInfo>) CSAMainFrame.deserialize("serialize"+File.separator+"TrackiInfo.ser");
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
    protected boolean saveSettings()
    {
        TrackiInfo ti = new TrackiInfo();
        ti.name = jTextField5.getText();
        if (ti.name.trim().length() == 0) return false;
        ti.start = DASM6809.toNumber(jTextField3.getText());
        ti.end = DASM6809.toNumber(jTextField4.getText());
        
        for (int i=0; i< persistentInfo.size(); i++)
        {
            if (persistentInfo.elementAt(i).equals(ti)) return true;
        }
        persistentInfo.addElement(ti);
        
        try
        {
            CSAMainFrame.serialize(persistentInfo, "serialize"+File.separator+"TrackiInfo.ser");
        }
        catch (Throwable e)
        {
            return false;
        }
        mClassSetting++;
        jComboBox1.setModel(new DefaultComboBoxModel(persistentInfo));
        jComboBox1.setSelectedIndex(persistentInfo.size()-1);
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
        jLabel1 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jTextField2 = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        jLabel3 = new javax.swing.JLabel();
        jTextField3 = new javax.swing.JTextField();
        jToggleButton4 = new javax.swing.JToggleButton();
        jTextField4 = new javax.swing.JTextField();
        jComboBox1 = new javax.swing.JComboBox();
        jTextField5 = new javax.swing.JTextField();
        jButtonSave = new javax.swing.JButton();

        setName("regi"); // NOI18N
        addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                formComponentResized(evt);
            }
        });

        jLabel1.setText("min");

        jTextField1.setText("00000");

        jTextField2.setText("00000");

        jLabel2.setText("max");

        jButton1.setText("reset");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jLabel3.setText("address to track");

        jTextField3.setText("$F1A2");

        jToggleButton4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton4.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton4.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton4.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton4ActionPerformed(evt);
            }
        });

        jTextField4.setText("$F192");
        jTextField4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField4ActionPerformed(evt);
            }
        });

        jComboBox1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBox1.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox1ActionPerformed(evt);
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

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jTextField5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButtonSave)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addGap(10, 10, 10))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(36, 36, 36)))
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 59, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel2)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 59, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(jButton1))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jLabel3)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 56, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 56, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel3)
                        .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButtonSave))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel1)
                        .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel2)
                        .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButton1, javax.swing.GroupLayout.Alignment.TRAILING)))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 68, Short.MAX_VALUE))
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
        int[] wrBuffer = vecxPanel.getCurrentWaitRecalBuffer();
        for (int v = 0; v < wrBuffer.length; v++) 
        {
            wrBuffer[v] = 0;
	}  
        int start = DASM6809.toNumber(jTextField3.getText());
        int end = DASM6809.toNumber(jTextField4.getText());
        
        vecxPanel.setTrackingAddress(start, end);
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jToggleButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton4ActionPerformed
        updateEnabled = jToggleButton4.isSelected();
    }//GEN-LAST:event_jToggleButton4ActionPerformed

    private void jTextField4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField4ActionPerformed
        
    }//GEN-LAST:event_jTextField4ActionPerformed

    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed
        saveSettings();
    }//GEN-LAST:event_jButtonSaveActionPerformed

    private void jComboBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox1ActionPerformed
        if (mClassSetting>0) return;
        if (jComboBox1.getSelectedIndex() == -1) return;
        TrackiInfo info = (TrackiInfo)jComboBox1.getSelectedItem();
        jTextField5.setText(info.name);
        jTextField3.setText("$"+String.format("%04X",info.start&0xffff));
        jTextField4.setText("$"+String.format("%04X",info.end&0xffff));
        // reset
        jButton1ActionPerformed(null);        
    }//GEN-LAST:event_jComboBox1ActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField3;
    private javax.swing.JTextField jTextField4;
    private javax.swing.JTextField jTextField5;
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
}
