/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.veccy;

import de.malban.config.Configuration;
import de.malban.event.EditMouseEvent;
import de.malban.graphics.MouseMovedListener;
import de.malban.graphics.SingleVectorPanel;
import static de.malban.graphics.SingleVectorPanel.SVP_SELECT_LINE;
import static de.malban.graphics.SingleVectorPanel.SVP_SELECT_POINT;
import static de.malban.graphics.SingleVectorPanel.SVP_SET;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.HotKey;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAInternalFrame;
import de.malban.gui.components.CSAView;
import de.malban.gui.panels.LogPanel;
import java.awt.Container;
import java.awt.event.ActionEvent;
import java.text.DecimalFormat;
import javax.swing.AbstractAction;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;

/**
 *
 * @author malban
 */
public class SingleVecciPanel extends javax.swing.JPanel implements Windowable, MouseMovedListener{

    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    
    private int mClassSetting=0;
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    VeccyPanel vecci;

    @Override
    public void closing()
    {
        if (vecci != null)
            vecci.closeSingleVecciPanel();
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
    public void setParentWindow(CSAView jpv)
    {
        mParent = jpv;
    }
    @Override
    public void setMenuItem(javax.swing.JMenuItem item)
    {
        mParentMenuItem = item;
        mParentMenuItem.setText("Vector: Editor single");
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
    
    /**
     * Creates new form SingleVecciPanel
     */
    public SingleVecciPanel(VeccyPanel v) {
        mClassSetting++;
        initComponents();
        vecci = v;
        singleVectorPanel1.setUsePrivateScale(true);
        singleVectorPanel1.setUsePrivateOffset(true);
        mClassSetting--;

        updateOutput();
        
        
        new HotKey("Delete selected(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) 
        { 
            vecci.lineDeleteProxy();
        }}, this);
        new HotKey("Mode change(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.cycleMode();}}, this);
        new HotKey("UndoMac(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.undoProxy();}}, this);
        new HotKey("RedoMac(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.redoProxy();}}, this);
        new HotKey("UndoWin(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.undoProxy();}}, this);
        new HotKey("RedoWin(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.redoProxy();}}, this);
        
        new HotKey("SelectAllMac(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.selectAllProxy();}}, this);
        new HotKey("SelectAllWin(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.selectAllProxy();}}, this);
        new HotKey("CopyMac(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.copyProxy();}}, this);
        new HotKey("CopyWin(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.copyProxy();}}, this);
        new HotKey("PasteMac(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.pasteProxy();}}, this);
        new HotKey("PasteWin(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.pasteProxy();}}, this);
        new HotKey("CutMac(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.cutProxy();}}, this);
        new HotKey("CutWin(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.cutProxy();}}, this);
        

        new HotKey("AnimLeftKP(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.animLeft();}}, this);
        new HotKey("AnimRightKP(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.animRight();}}, this);
        new HotKey("AnimLeft(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.animLeft();}}, this);
        new HotKey("AnimRight(Window)", new AbstractAction() { public void actionPerformed(ActionEvent e) { vecci.animRight();}}, this);
        
        
        updateMode();
        
    }
    // otherwise mouse listener is not added to "global" var
    public void initPart2()
    {
        singleVectorPanel1.addMouseMovedListener(this);
        
    }
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        singleVectorPanel1 = new de.malban.graphics.SingleVectorPanel();
        jPanelScroller = new javax.swing.JPanel();
        jButtonUp = new javax.swing.JButton();
        jButtonDown = new javax.swing.JButton();
        jButtonLeft = new javax.swing.JButton();
        jButtonRight = new javax.swing.JButton();
        jSliderSourceScale = new javax.swing.JSlider();
        jLabelMode = new javax.swing.JLabel();
        jLabelScale = new javax.swing.JLabel();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabelXO = new javax.swing.JLabel();
        jLabelYO = new javax.swing.JLabel();

        addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                formComponentResized(evt);
            }
        });

        singleVectorPanel1.setMaximumSize(new java.awt.Dimension(300, 300));
        singleVectorPanel1.setMinimumSize(new java.awt.Dimension(300, 300));
        singleVectorPanel1.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                singleVectorPanel1ComponentResized(evt);
            }
        });

        javax.swing.GroupLayout singleVectorPanel1Layout = new javax.swing.GroupLayout(singleVectorPanel1);
        singleVectorPanel1.setLayout(singleVectorPanel1Layout);
        singleVectorPanel1Layout.setHorizontalGroup(
            singleVectorPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 371, Short.MAX_VALUE)
        );
        singleVectorPanel1Layout.setVerticalGroup(
            singleVectorPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );

        jPanelScroller.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jPanelScrollerMouseClicked(evt);
            }
        });
        jPanelScroller.setLayout(null);

        jButtonUp.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_up.png"))); // NOI18N
        jButtonUp.setToolTipText("select all");
        jButtonUp.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonUp.setMargin(new java.awt.Insets(-1, -3, -1, -4));
        jButtonUp.setPreferredSize(new java.awt.Dimension(14, 18));
        jButtonUp.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonUpActionPerformed(evt);
            }
        });
        jPanelScroller.add(jButtonUp);
        jButtonUp.setBounds(19, 1, 14, 18);

        jButtonDown.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_down.png"))); // NOI18N
        jButtonDown.setToolTipText("select all");
        jButtonDown.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDown.setMargin(new java.awt.Insets(-1, -3, -1, -4));
        jButtonDown.setPreferredSize(new java.awt.Dimension(14, 18));
        jButtonDown.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDownActionPerformed(evt);
            }
        });
        jPanelScroller.add(jButtonDown);
        jButtonDown.setBounds(19, 31, 14, 18);

        jButtonLeft.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_left.png"))); // NOI18N
        jButtonLeft.setToolTipText("select all");
        jButtonLeft.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonLeft.setMargin(new java.awt.Insets(-4, 0, -4, -1));
        jButtonLeft.setPreferredSize(new java.awt.Dimension(65, 19));
        jButtonLeft.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLeftActionPerformed(evt);
            }
        });
        jPanelScroller.add(jButtonLeft);
        jButtonLeft.setBounds(0, 18, 19, 14);

        jButtonRight.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_right.png"))); // NOI18N
        jButtonRight.setToolTipText("select all");
        jButtonRight.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonRight.setMargin(new java.awt.Insets(-1, 0, -1, -1));
        jButtonRight.setPreferredSize(new java.awt.Dimension(65, 19));
        jButtonRight.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRightActionPerformed(evt);
            }
        });
        jPanelScroller.add(jButtonRight);
        jButtonRight.setBounds(33, 18, 19, 14);

        jSliderSourceScale.setMajorTickSpacing(1);
        jSliderSourceScale.setMinimum(1);
        jSliderSourceScale.setMinorTickSpacing(1);
        jSliderSourceScale.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderSourceScale.setPaintTicks(true);
        jSliderSourceScale.setSnapToTicks(true);
        jSliderSourceScale.setValue(21);
        jSliderSourceScale.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderSourceScaleStateChanged(evt);
            }
        });

        jLabelMode.setForeground(new java.awt.Color(51, 51, 255));
        jLabelMode.setText("Mode");

        jLabelScale.setText(" ");

        jLabel1.setText("Y:");

        jLabel2.setText("X:");

        jLabelXO.setText(" ");

        jLabelYO.setText(" ");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jSliderSourceScale, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabelXO, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jLabelMode, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabelScale, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabelYO, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jPanelScroller, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 0, 0)
                .addComponent(singleVectorPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jSliderSourceScale, javax.swing.GroupLayout.DEFAULT_SIZE, 370, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelScale)
                .addGap(0, 0, 0)
                .addComponent(jLabelMode, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(2, 2, 2)
                .addComponent(jPanelScroller, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jLabelXO))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(jLabelYO)))
            .addComponent(singleVectorPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonUpActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonUpActionPerformed
        singleVectorPanel1.addYOffset(-singleVectorPanel1.getGridWidth());
        updateOutput();
        
    }//GEN-LAST:event_jButtonUpActionPerformed

    private void jButtonDownActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDownActionPerformed
        singleVectorPanel1.addYOffset(singleVectorPanel1.getGridWidth());
        updateOutput();
    }//GEN-LAST:event_jButtonDownActionPerformed

    private void jButtonLeftActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLeftActionPerformed
        singleVectorPanel1.addXOffset(-singleVectorPanel1.getGridWidth());
        updateOutput();
    }//GEN-LAST:event_jButtonLeftActionPerformed

    private void jButtonRightActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRightActionPerformed
        singleVectorPanel1.addXOffset(singleVectorPanel1.getGridWidth());
        updateOutput();
    }//GEN-LAST:event_jButtonRightActionPerformed

    private void jSliderSourceScaleStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSourceScaleStateChanged
        if (mClassSetting>0) return;
        int value = jSliderSourceScale.getValue();
        int max = jSliderSourceScale.getMaximum();

        double scale = value - ((max-1)/2);
        if (value <((max/2)+1))
        {
            value--;
            int invScale = ((max/2))-value;
            if (invScale == 0) 
                scale = 1;
            else
                scale = 1.0/invScale;
        }
        // smooth out "big steps"
        if (scale<1) scale += 0.25;
        if (scale>1) scale -= 0.75;
        if (scale>2) scale -= 0.5;
        if (scale>2.5) scale -= 0.25;
        if (scale>2.75) scale -= 0.5;
        singleVectorPanel1.setScale(scale);
        updateOutput();
    }//GEN-LAST:event_jSliderSourceScaleStateChanged

    private void jPanelScrollerMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPanelScrollerMouseClicked
        if (evt.getClickCount() == 2) 
        {
            singleVectorPanel1.setOffsets(0, 0, 0);
        }
        updateOutput();

    }//GEN-LAST:event_jPanelScrollerMouseClicked

    private void formComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_formComponentResized
        Container cc = getParent().getParent().getParent().getParent();
        if (cc instanceof CSAInternalFrame)
        {
            
            xpos = ((CSAInternalFrame)cc).getBounds().x;
            ypos = ((CSAInternalFrame)cc).getBounds().y;
            w = ((CSAInternalFrame)cc).getBounds().width;
            h = ((CSAInternalFrame)cc).getBounds().height;
        }
    }//GEN-LAST:event_formComponentResized

    public int xpos = 0;
    public int ypos = 0;
    public int w = 0;
    public int h = 0;
    
    private void singleVectorPanel1ComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_singleVectorPanel1ComponentResized
        // TODO add your handling code here:
    }//GEN-LAST:event_singleVectorPanel1ComponentResized
    public static SingleVecciPanel showSingleVecciPanelNoModal(VeccyPanel v)
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        SingleVecciPanel panel = new SingleVecciPanel(v);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addAsWindow(panel, 919, 387, "Vector: Editor single");
       return panel;
    }        
    public SingleVectorPanel getSVP()
    {
        return singleVectorPanel1;
    }

    void updateOutput()
    {
        if (mClassSetting>0) return;
        mClassSetting++;

        jLabelScale.setText(" "+new DecimalFormat("#.##").format(singleVectorPanel1.getScale()));
        
        jLabelXO.setText(" "+singleVectorPanel1.getXOffset());
        jLabelYO.setText(" "+singleVectorPanel1.getYOffset());
        mClassSetting--;
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonDown;
    private javax.swing.JButton jButtonLeft;
    private javax.swing.JButton jButtonRight;
    private javax.swing.JButton jButtonUp;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabelMode;
    private javax.swing.JLabel jLabelScale;
    private javax.swing.JLabel jLabelXO;
    private javax.swing.JLabel jLabelYO;
    private javax.swing.JPanel jPanelScroller;
    private javax.swing.JSlider jSliderSourceScale;
    private de.malban.graphics.SingleVectorPanel singleVectorPanel1;
    // End of variables declaration//GEN-END:variables

    void setSettings(VecciSettings settings)
    {
        mClassSetting++;
        Container cc = getParent().getParent().getParent().getParent();
        if (cc instanceof CSAInternalFrame)
        {
            ((CSAInternalFrame)cc).setBounds(settings.singleVecciX, settings.singleVecciY, settings.singleVecciW, settings.singleVecciH);
             xpos = ((CSAInternalFrame)cc).getBounds().x;
             ypos = ((CSAInternalFrame)cc).getBounds().y;
             w = ((CSAInternalFrame)cc).getBounds().width;
             h = ((CSAInternalFrame)cc).getBounds().height;
        }
        jSliderSourceScale.setValue(settings.singleVecciScaleSlider);
        int value = jSliderSourceScale.getValue();
        int max = jSliderSourceScale.getMaximum();
        double scale = value - ((max-1)/2);
        if (value <((max/2)+1))
        {
            int invScale = ((max/2)+2)-value;
            scale = 1.0/invScale;
        }
        jLabelScale.setText(" " +new DecimalFormat("#.##").format(scale));
        final double val = scale;
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                singleVectorPanel1.setScale(val);
                singleVectorPanel1.setGrid(settings.isGrid, settings.gridSize);
                singleVectorPanel1.repaint();
                singleVectorPanel1.sharedRepaint();
            }
        });
        
        
        mClassSetting--;
        updateOutput();
    }
    int getScaleSlider()
    {
        return jSliderSourceScale.getValue();
    }
    public void moved(EditMouseEvent evt)
    {
        if (!((evt.dragging) && (evt.ctrlPressed))) return;
        updateOutput();
    }
    public void deIconified() { }
    
    public void updateMode()
    {
        if (singleVectorPanel1.getSharedVars().workingMode == SVP_SET)
            jLabelMode.setText("Set");
        if (singleVectorPanel1.getSharedVars().workingMode == SVP_SELECT_LINE)
            jLabelMode.setText("Vector");
        if (singleVectorPanel1.getSharedVars().workingMode == SVP_SELECT_POINT)
            jLabelMode.setText("Point");
    }
    
}
