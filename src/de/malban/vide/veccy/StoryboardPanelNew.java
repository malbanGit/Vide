/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.veccy;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.graphics.GFXVectorAnimation;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.HotKey;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAInternalFrame;
import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.util.XMLSupport;
import de.malban.vide.assy.Asmj;
import de.malban.vide.vecx.VecXPanel;
import de.malban.vide.vedi.VediPanel;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;

/**
 *
 * @author malban
 */
public class StoryboardPanelNew extends javax.swing.JPanel  implements Windowable, StoryboardPanelInterface{

    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    String pathOnly = "";

    private int mClassSetting=0;
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    Thread two = null;
    String orgName="";
    BufferedImage baseImage ;

    VeccyPanel veccy=null;
    
    private ArrayList<StoryboardLanePanel> lanes = new ArrayList<StoryboardLanePanel>();
    private StoryboardLanePanel currentLane = null;
    private StoryboardElement currentElement = null;
    private GFXVectorAnimation currentAnimation = new GFXVectorAnimation();
    
    
    @Override
    public void closing()
    {
        if (veccy != null)
            veccy.removeSBPanel();
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
        mParentMenuItem.setText("Storyboard Panel");
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
     * @return the lanes
     */
    public ArrayList<StoryboardLanePanel> getLanes() {
        return lanes;
    }

    /**
     * @param lanes the lanes to set
     */
    public void setLanes(ArrayList<StoryboardLanePanel> lanes) {
        this.lanes = lanes;
    }

    /**
     * @return the currentLane
     */
    public StoryboardLanePanel getCurrentLane() {
        return currentLane;
    }

    /**
     * @param currentLane the currentLane to set
     */
    public void setCurrentLane(StoryboardLanePanel currentLane) {
        this.currentLane = currentLane;
    }

    /**
     * @return the currentElement
     */
    public StoryboardElement getCurrentElement() {
        return currentElement;
    }

    /**
     * @param currentElement the currentElement to set
     */
    public void setCurrentElement(StoryboardElement currentElement) {
        this.currentElement = currentElement;
    }

    /**
     * @return the currentAnimation
     */
    public GFXVectorAnimation getCurrentAnimation() {
        return currentAnimation;
    }

    /**
     * @param currentAnimation the currentAnimation to set
     */
    public void setCurrentAnimation(GFXVectorAnimation currentAnimation) {
        this.currentAnimation = currentAnimation;
    }
    
        /**
     * Creates new form StoryboardPanel
     */
    public StoryboardPanelNew() {
        initComponents();
        lanePanel.remove(storyboardLanePanel1);
       if (Global.getOSName().toUpperCase().contains("MAC"))
        {
            HotKey.addMacDefaults(jTextFieldAnimationName);
            HotKey.addMacDefaults(jTextFieldFrameCount);
            HotKey.addMacDefaults(jTextFieldDelayVectrex);
            HotKey.addMacDefaults(jTextFieldListIntensityFrom);
            HotKey.addMacDefaults(jTextFieldMoveScale);
            HotKey.addMacDefaults(jTextFieldResync);
            HotKey.addMacDefaults(jTextFieldFactor);

            HotKey.addMacDefaults(jTextFieldListScaleTo);
            HotKey.addMacDefaults(jTextFieldListScaleFrom);
            HotKey.addMacDefaults(jTextFieldListIntensityTo);
            HotKey.addMacDefaults(jTextFieldPosXFrom);
            HotKey.addMacDefaults(jTextFieldPosXTo);
            HotKey.addMacDefaults(jTextFieldPosYFrom);
            HotKey.addMacDefaults(jTextFieldPosYTo);
            HotKey.addMacDefaults(jTextFieldMoveScale);
            HotKey.addMacDefaults(jTextFieldRoundCount);
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

        buttonGroup1 = new javax.swing.ButtonGroup();
        jScrollPane1 = new javax.swing.JScrollPane();
        lanePanel = new javax.swing.JPanel();
        storyboardLanePanel1 = new de.malban.vide.veccy.StoryboardLanePanel();
        jButtonaddLane = new javax.swing.JButton();
        jPanel3 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jTextFieldFrameCount = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jButton3 = new javax.swing.JButton();
        jLabel3 = new javax.swing.JLabel();
        jTextFieldListScaleFrom = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        jTextFieldMoveScale = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jTextFieldPosXFrom = new javax.swing.JTextField();
        jTextFieldPosYFrom = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jTextFieldPosXTo = new javax.swing.JTextField();
        jTextFieldPosYTo = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        jComboBoxDrawType = new javax.swing.JComboBox();
        jTextFieldListScaleTo = new javax.swing.JTextField();
        jButtonLoad2 = new javax.swing.JButton();
        jLabel6 = new javax.swing.JLabel();
        jTextFieldAnimationName = new javax.swing.JTextField();
        jTextFieldDelayVectrex = new javax.swing.JTextField();
        jTextFieldResync = new javax.swing.JTextField();
        jTextFieldFactor = new javax.swing.JTextField();
        jLabel14 = new javax.swing.JLabel();
        jTextFieldRoundCount = new javax.swing.JTextField();
        jLabel9 = new javax.swing.JLabel();
        jTextFieldListIntensityFrom = new javax.swing.JTextField();
        jTextFieldListIntensityTo = new javax.swing.JTextField();
        jCheckBoxDisable = new javax.swing.JCheckBox();
        jCheckBoxPause = new javax.swing.JCheckBox();
        jCheckBoxNoAdditionalSynOptimization = new javax.swing.JCheckBox();
        jCheckBoxAnimationLoop = new javax.swing.JCheckBox();
        jPanel4 = new javax.swing.JPanel();
        jScrollPane5 = new javax.swing.JScrollPane();
        jTextAreaResult = new javax.swing.JTextArea();
        jPanel5 = new javax.swing.JPanel();
        jButtonLoad1 = new javax.swing.JButton();
        jButtonSave3 = new javax.swing.JButton();
        jButtonAssemble = new javax.swing.JButton();
        jButtonEditInVedi = new javax.swing.JButton();
        jButtonaddLane1 = new javax.swing.JButton();
        jLabel15 = new javax.swing.JLabel();
        jTextFieldFrameCount2 = new javax.swing.JTextField();

        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
        jScrollPane1.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);

        lanePanel.setPreferredSize(new java.awt.Dimension(600, 428));
        lanePanel.setLayout(null);
        lanePanel.add(storyboardLanePanel1);
        storyboardLanePanel1.setBounds(0, 65, 1028, 0);

        jScrollPane1.setViewportView(lanePanel);

        jButtonaddLane.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/add.png"))); // NOI18N
        jButtonaddLane.setText("add lane");
        jButtonaddLane.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButtonaddLane.setPreferredSize(new java.awt.Dimension(93, 21));
        jButtonaddLane.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonaddLaneActionPerformed(evt);
            }
        });

        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder("sequence detail"));

        jLabel1.setText("frames");

        jTextFieldFrameCount.setEditable(false);
        jTextFieldFrameCount.setText("10");

        jLabel2.setText("animation");

        jButton3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/delete.png"))); // NOI18N
        jButton3.setToolTipText("delete current element");
        jButton3.setEnabled(false);
        jButton3.setPreferredSize(new java.awt.Dimension(20, 20));
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        jLabel3.setText("scale from <-> to");

        jTextFieldListScaleFrom.setText("10");
        jTextFieldListScaleFrom.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldListScaleFromActionPerformed(evt);
            }
        });
        jTextFieldListScaleFrom.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldListScaleFromKeyReleased(evt);
            }
        });

        jLabel4.setText("move - scale");

        jTextFieldMoveScale.setText("10");
        jTextFieldMoveScale.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldMoveScaleActionPerformed(evt);
            }
        });
        jTextFieldMoveScale.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldPosStartXKeyReleased(evt);
            }
        });

        jLabel5.setText("X from <-> to");

        jTextFieldPosXFrom.setText("10");
        jTextFieldPosXFrom.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPosXFromActionPerformed(evt);
            }
        });
        jTextFieldPosXFrom.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                textfieldKeyReleased(evt);
            }
        });

        jTextFieldPosYFrom.setText("10");
        jTextFieldPosYFrom.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPosYFromActionPerformed(evt);
            }
        });
        jTextFieldPosYFrom.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldPosStartXKeyReleased(evt);
            }
        });

        jLabel7.setText("Y from <-> to");

        jTextFieldPosXTo.setText("10");
        jTextFieldPosXTo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPosXToActionPerformed(evt);
            }
        });
        jTextFieldPosXTo.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldPosStartXKeyReleased(evt);
            }
        });

        jTextFieldPosYTo.setText("10");
        jTextFieldPosYTo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPosYToActionPerformed(evt);
            }
        });
        jTextFieldPosYTo.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldPosStartXKeyReleased(evt);
            }
        });

        jLabel8.setText("draw type");

        jComboBoxDrawType.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "synced extended" }));
        jComboBoxDrawType.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxDrawTypeActionPerformed(evt);
            }
        });

        jTextFieldListScaleTo.setText("10");
        jTextFieldListScaleTo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                textFieldReturn(evt);
            }
        });
        jTextFieldListScaleTo.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldListScaleToKeyReleased(evt);
            }
        });

        jButtonLoad2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad2.setToolTipText("load animation");
        jButtonLoad2.setEnabled(false);
        jButtonLoad2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoad2ActionPerformed(evt);
            }
        });

        jLabel6.setText("animation delay");

        jTextFieldAnimationName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldAnimationNameActionPerformed(evt);
            }
        });

        jTextFieldDelayVectrex.setText("10");
        jTextFieldDelayVectrex.setToolTipText("display delay for vectrex, in \"rounds\"/ticks");
        jTextFieldDelayVectrex.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldDelayVectrexActionPerformed(evt);
            }
        });
        jTextFieldDelayVectrex.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldDelayVectrexKeyReleased(evt);
            }
        });

        jTextFieldResync.setText("10");
        jTextFieldResync.setToolTipText("resync max");
        jTextFieldResync.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldResyncActionPerformed(evt);
            }
        });
        jTextFieldResync.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldResyncjTextFieldPosStartXKeyReleased(evt);
            }
        });

        jTextFieldFactor.setText("10");
        jTextFieldFactor.setToolTipText("factor for list values");
        jTextFieldFactor.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldFactorActionPerformed(evt);
            }
        });
        jTextFieldFactor.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldFactorjTextFieldPosStartXKeyReleased(evt);
            }
        });

        jLabel14.setText("length");

        jTextFieldRoundCount.setText("200");
        jTextFieldRoundCount.setToolTipText("<html>\nLength in vectrex rounds.<BR>\nAn efficient vectrex program will run at 50Hz, thus one length \"tick\" is 1/50 of a second, <BR>\nor 0,02 seconds.<BR>\nVectrex will at least use 1/50 of a second per round, if your animations consists of more vectors than\n<BR>Vectrex can draw in 1/50 second, the \"tick\" will last longer.<BR>\n</html>");
        jTextFieldRoundCount.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldRoundCountActionPerformed(evt);
            }
        });
        jTextFieldRoundCount.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldRoundCountKeyReleased(evt);
            }
        });

        jLabel9.setText("intensity from <-> to");
        jLabel9.setEnabled(false);

        jTextFieldListIntensityFrom.setText("10");
        jTextFieldListIntensityFrom.setToolTipText("-1 = no intensity setting");
        jTextFieldListIntensityFrom.setEnabled(false);
        jTextFieldListIntensityFrom.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldListIntensityFromActionPerformed(evt);
            }
        });
        jTextFieldListIntensityFrom.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldListIntensityFromKeyReleased(evt);
            }
        });

        jTextFieldListIntensityTo.setText("10");
        jTextFieldListIntensityTo.setEnabled(false);
        jTextFieldListIntensityTo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldListIntensityTotextFieldReturn(evt);
            }
        });
        jTextFieldListIntensityTo.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldListIntensityToKeyReleased(evt);
            }
        });

        jCheckBoxDisable.setText("disable");
        jCheckBoxDisable.setToolTipText("treat sequence as if it was not avaible (for testing purposes - not SAVED)");
        jCheckBoxDisable.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxDisableActionPerformed(evt);
            }
        });

        jCheckBoxPause.setText("is pause");
        jCheckBoxPause.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxPauseActionPerformed(evt);
            }
        });

        jCheckBoxNoAdditionalSynOptimization.setSelected(true);
        jCheckBoxNoAdditionalSynOptimization.setText("no opt");
        jCheckBoxNoAdditionalSynOptimization.setToolTipText("<html>\nWhile generating the storyboard, do not try to optimize the vectorlist(s).<BR>\nOptimizing takes time - and if the list is already optimized - there will be no better results.\n</html>");

        jCheckBoxAnimationLoop.setSelected(true);
        jCheckBoxAnimationLoop.setText("loop");
        jCheckBoxAnimationLoop.setToolTipText("does the animation loop");
        jCheckBoxAnimationLoop.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxAnimationLoopActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel14)
                    .addComponent(jLabel5)
                    .addComponent(jLabel7)
                    .addComponent(jLabel4)
                    .addComponent(jLabel2)
                    .addComponent(jLabel3)
                    .addComponent(jLabel8)
                    .addComponent(jLabel9)
                    .addComponent(jLabel6)
                    .addComponent(jCheckBoxDisable))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                            .addComponent(jComboBoxDrawType, javax.swing.GroupLayout.PREFERRED_SIZE, 147, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGap(3, 3, 3)
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPanel3Layout.createSequentialGroup()
                                    .addComponent(jTextFieldResync, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jTextFieldFactor, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addComponent(jCheckBoxNoAdditionalSynOptimization)))
                        .addGroup(jPanel3Layout.createSequentialGroup()
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jCheckBoxPause, javax.swing.GroupLayout.PREFERRED_SIZE, 89, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jTextFieldMoveScale, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jTextFieldRoundCount, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addContainerGap()))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jTextFieldAnimationName, javax.swing.GroupLayout.PREFERRED_SIZE, 147, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonLoad2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxAnimationLoop))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldPosYFrom, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldPosXFrom, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldListIntensityFrom, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldListScaleFrom, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldDelayVectrex, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldPosXTo, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldPosYTo, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldListIntensityTo, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldListScaleTo, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addGap(18, 18, 18)
                                .addComponent(jTextFieldFrameCount, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))))))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(1, 1, 1)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonLoad2)
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel2)
                                .addComponent(jTextFieldAnimationName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addComponent(jCheckBoxAnimationLoop))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(jLabel6)
                    .addComponent(jTextFieldDelayVectrex, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldFrameCount, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel3)
                    .addComponent(jTextFieldListScaleFrom, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldListScaleTo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(4, 4, 4)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel9)
                    .addComponent(jTextFieldListIntensityFrom, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldListIntensityTo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldPosXFrom, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel5))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel7)
                            .addComponent(jTextFieldPosYFrom, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldMoveScale, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel4))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jLabel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jTextFieldResync, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jTextFieldFactor, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jComboBoxDrawType, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jTextFieldPosXTo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldPosYTo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(6, 6, 6)
                .addComponent(jCheckBoxNoAdditionalSynOptimization)
                .addGap(6, 6, 6)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel14)
                    .addComponent(jTextFieldRoundCount, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 9, Short.MAX_VALUE)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBoxPause)
                    .addComponent(jCheckBoxDisable)))
        );

        jTextAreaResult.setColumns(20);
        jTextAreaResult.setFont(new java.awt.Font("Courier New", 1, 12)); // NOI18N
        jTextAreaResult.setRows(5);
        jScrollPane5.setViewportView(jTextAreaResult);

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane5, javax.swing.GroupLayout.DEFAULT_SIZE, 377, Short.MAX_VALUE)
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane5)
        );

        jButtonLoad1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad1.setToolTipText("load storyboard");
        jButtonLoad1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoad1ActionPerformed(evt);
            }
        });

        jButtonSave3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave3.setToolTipText("save storyboard");
        jButtonSave3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSave3ActionPerformed(evt);
            }
        });

        jButtonAssemble.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jButtonAssemble.setToolTipText("Assemble current file, if if project is loaded, build project");
        jButtonAssemble.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAssemble.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAssembleActionPerformed(evt);
            }
        });

        jButtonEditInVedi.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_edit.png"))); // NOI18N
        jButtonEditInVedi.setToolTipText("edit output in vedi");
        jButtonEditInVedi.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonEditInVedi.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonEditInVediActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jButtonLoad1)
                .addGap(6, 6, 6)
                .addComponent(jButtonSave3)
                .addGap(18, 18, 18)
                .addComponent(jButtonAssemble)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonEditInVedi)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jButtonLoad1)
            .addComponent(jButtonSave3)
            .addComponent(jButtonAssemble)
            .addComponent(jButtonEditInVedi)
        );

        jButtonaddLane1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/delete.png"))); // NOI18N
        jButtonaddLane1.setText("delete lane");
        jButtonaddLane1.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButtonaddLane1.setPreferredSize(new java.awt.Dimension(93, 21));
        jButtonaddLane1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonaddLane1ActionPerformed(evt);
            }
        });

        jLabel15.setText("length in rounds");

        jTextFieldFrameCount2.setEditable(false);
        jTextFieldFrameCount2.setText("0");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jButtonaddLane, javax.swing.GroupLayout.PREFERRED_SIZE, 127, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(35, 35, 35)
                        .addComponent(jButtonaddLane1, javax.swing.GroupLayout.PREFERRED_SIZE, 127, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jLabel15)
                        .addGap(34, 34, 34)
                        .addComponent(jTextFieldFrameCount2, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 0, 0)
                .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel15)
                            .addComponent(jTextFieldFrameCount2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButtonaddLane, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonaddLane1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 275, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonLoad1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoad1ActionPerformed
        loadStoryboard();
    }//GEN-LAST:event_jButtonLoad1ActionPerformed

    private void jButtonSave3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSave3ActionPerformed
        saveStoryboard();
    }//GEN-LAST:event_jButtonSave3ActionPerformed

    private void jButtonEditInVediActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEditInVediActionPerformed
        generateSource();

        CSAMainFrame frame = (CSAMainFrame)Configuration.getConfiguration().getMainFrame();

        VediPanel p = new VediPanel(false);
        p.setTreeVisible(false);
        frame.addAsWindow(p, 1024, 768, VediPanel.SID);

        String tmpFile = Global.mainPathPrefix+"tmp"+File.separator+"veccyAsm.asm";
        de.malban.util.UtilityFiles.createTextFile(tmpFile, jTextAreaResult.getText());
        p.addTempEditFile(tmpFile);

    }//GEN-LAST:event_jButtonEditInVediActionPerformed

    private void jButtonAssembleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssembleActionPerformed

 // savety measure - save to tmp the current storyboard
        String filename =Global.mainPathPrefix+"tmp"+File.separator+"storyboard.tmp";
 File f =new File(filename);
        
        String saveName = f.getAbsolutePath();
//        saveName = de.malban.util.Utility.makeRelative(saveName);
        
        if (saveName != null)
        {
            if (!saveName.toUpperCase().endsWith(".XML"))
            {
                saveName+= ".xml";
            }
            saveAsXML(saveName);
        }
        
        
        
        

        generateSource();
        filename = Global.mainPathPrefix+"tmp"+File.separator+"veccytmp.asm";
        de.malban.util.UtilityFiles.createTextFile(filename, jTextAreaResult.getText());
        startASM(filename);
    }//GEN-LAST:event_jButtonAssembleActionPerformed
    private void jButtonaddLaneActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonaddLaneActionPerformed
        StoryboardLanePanel sb = new StoryboardLanePanel(this);
        lanePanel.add(sb);
        sb.setBounds(0, 80*lanes.size(), 28, 79);
        lanes.add(sb);
        lanePanel.repaint();
        updateBounds();
    }//GEN-LAST:event_jButtonaddLaneActionPerformed

    private void jButtonLoad2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoad2ActionPerformed
        loadAnimation();
        setListType("dummy"); // just fill the combobox
        
        jTextFieldFrameCount.setText(""+currentAnimation.size());
        if (currentElement != null)
            updateToElement(false);
        guessBlowUpFactor();
    }//GEN-LAST:event_jButtonLoad2ActionPerformed

    private void jTextFieldListScaleFromKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldListScaleFromKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListScaleFromKeyReleased

    private void jTextFieldListScaleToKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldListScaleToKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListScaleToKeyReleased

    private void jTextFieldPosStartXKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldPosStartXKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldPosStartXKeyReleased

    private void textFieldReturn(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_textFieldReturn
        updateToElement(false);
    }//GEN-LAST:event_textFieldReturn

    private void textfieldKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_textfieldKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_textfieldKeyReleased

    private void jTextFieldDelayVectrexActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldDelayVectrexActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldDelayVectrexActionPerformed

    private void jTextFieldDelayVectrexKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldDelayVectrexKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldDelayVectrexKeyReleased

    private void jTextFieldMoveScaleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldMoveScaleActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldMoveScaleActionPerformed

    private void jTextFieldPosXToActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPosXToActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldPosXToActionPerformed

    private void jTextFieldPosYToActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPosYToActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldPosYToActionPerformed

    private void jTextFieldPosYFromActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPosYFromActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldPosYFromActionPerformed

    private void jTextFieldPosXFromActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPosXFromActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldPosXFromActionPerformed

    private void jTextFieldListScaleFromActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldListScaleFromActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListScaleFromActionPerformed

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        deleteCurrentElement();
    }//GEN-LAST:event_jButton3ActionPerformed

    private void jButtonaddLane1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonaddLane1ActionPerformed
        deleteLane();
    }//GEN-LAST:event_jButtonaddLane1ActionPerformed

    private void jTextFieldResyncActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldResyncActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldResyncActionPerformed

    private void jTextFieldResyncjTextFieldPosStartXKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldResyncjTextFieldPosStartXKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldResyncjTextFieldPosStartXKeyReleased

    private void jTextFieldFactorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldFactorActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldFactorActionPerformed

    private void jTextFieldFactorjTextFieldPosStartXKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldFactorjTextFieldPosStartXKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldFactorjTextFieldPosStartXKeyReleased

    private void jTextFieldListIntensityFromActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldListIntensityFromActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListIntensityFromActionPerformed

    private void jTextFieldListIntensityFromKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldListIntensityFromKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListIntensityFromKeyReleased

    private void jTextFieldListIntensityTotextFieldReturn(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldListIntensityTotextFieldReturn
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListIntensityTotextFieldReturn

    private void jTextFieldListIntensityToKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldListIntensityToKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListIntensityToKeyReleased

    private void jTextFieldRoundCountActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldRoundCountActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldRoundCountActionPerformed

    private void jCheckBoxPauseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxPauseActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jCheckBoxPauseActionPerformed

    private void jComboBoxDrawTypeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxDrawTypeActionPerformed
        if (mClassSetting>0) return;
        updateToElement(false);
        
    }//GEN-LAST:event_jComboBoxDrawTypeActionPerformed

    private void jTextFieldAnimationNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldAnimationNameActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldAnimationNameActionPerformed

    private void jCheckBoxDisableActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxDisableActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jCheckBoxDisableActionPerformed

    private void jCheckBoxAnimationLoopActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxAnimationLoopActionPerformed
        if (mClassSetting>0) return;
        updateToElement(false);
    }//GEN-LAST:event_jCheckBoxAnimationLoopActionPerformed

    private void jTextFieldRoundCountKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldRoundCountKeyReleased
        currentElement.roundCount = de.malban.util.UtilityString.IntX(jTextFieldRoundCount.getText(), 20);
    }//GEN-LAST:event_jTextFieldRoundCountKeyReleased
    public void updateBounds()
    {
        int minW = jScrollPane1.getViewport().getBounds().width;
        int minH = jScrollPane1.getViewport().getBounds().height;
        int laneH = 0;
        for (StoryboardLanePanel l: lanes)
        {
            if (l.getBounds().width > minW) minW = l.getBounds().width;
            laneH+= 80;
        }
        
        if (laneH > minH) minH = laneH;
        Rectangle bounds = lanePanel.getBounds();
        bounds.width = minW;
        bounds.height = minH;
        Dimension dim = new Dimension(minW, minH);
        lanePanel.setBounds(bounds);
        lanePanel.setPreferredSize(dim);
        lanePanel.setSize(dim);
        lanePanel.setMinimumSize(dim);
        repaint();
        
        
        
    }
    Thread one = null;
    public boolean  asmStarted = false;
    public boolean stop = false;
    public boolean running = false;
    public boolean pausing = false;

    // start a thread for assembler
    public void startASM(final String filenameASM)
    {
        if (asmStarted) return;
        asmStarted = true;
        jButtonAssemble.setEnabled(false);
        // paranoia!
        if (one != null) return;
        one = new Thread() 
        {
            public void run() 
            {
                try 
                {
                    Thread.sleep(10);
                    try
                    {
                        Asmj asm = new Asmj(filenameASM, null, null, null, null, "",null);
                        String info = asm.getInfo();
                        final boolean asmOk = info.indexOf("0 errors detected.") >=0;
                        
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                asmResult(asmOk);
                            }
                        });                    
                    }
                    catch (final Throwable e)
                    {
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                log.addLog(e, WARN);
                                asmResult(false);
                            }
                        });                    
                    }
                } 
                catch(InterruptedException v) 
                {
                }

                one = null;
                jButtonAssemble.setEnabled(true);
                asmStarted = false;
            }  
        };

        one.setName("Run ASMJ with: "+filenameASM);
        one.start();           
    }    
    protected void asmResult(boolean asmOk)
    {
        if (asmOk)
        {
            VecXPanel vec = ((CSAMainFrame)mParent).getVecxy();
            ((CSAMainFrame)mParent).getInternalFrame(vec).toFront();


            String fname = Global.mainPathPrefix+"tmp"+File.separator+"veccytmp.bin";
            vec.startUp(fname);
            log.addLog("Vecci-Assembly successfull...", INFO);
        }
        else
        {
            log.addLog("Vecci-Assembly not successfull, see ASM output...", WARN);
        }
        jButtonAssemble.setEnabled(true);
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButtonAssemble;
    private javax.swing.JButton jButtonEditInVedi;
    private javax.swing.JButton jButtonLoad1;
    private javax.swing.JButton jButtonLoad2;
    private javax.swing.JButton jButtonSave3;
    private javax.swing.JButton jButtonaddLane;
    private javax.swing.JButton jButtonaddLane1;
    private javax.swing.JCheckBox jCheckBoxAnimationLoop;
    private javax.swing.JCheckBox jCheckBoxDisable;
    private javax.swing.JCheckBox jCheckBoxNoAdditionalSynOptimization;
    private javax.swing.JCheckBox jCheckBoxPause;
    private javax.swing.JComboBox jComboBoxDrawType;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JTextArea jTextAreaResult;
    private javax.swing.JTextField jTextFieldAnimationName;
    private javax.swing.JTextField jTextFieldDelayVectrex;
    private javax.swing.JTextField jTextFieldFactor;
    private javax.swing.JTextField jTextFieldFrameCount;
    private javax.swing.JTextField jTextFieldFrameCount2;
    private javax.swing.JTextField jTextFieldListIntensityFrom;
    private javax.swing.JTextField jTextFieldListIntensityTo;
    private javax.swing.JTextField jTextFieldListScaleFrom;
    private javax.swing.JTextField jTextFieldListScaleTo;
    private javax.swing.JTextField jTextFieldMoveScale;
    private javax.swing.JTextField jTextFieldPosXFrom;
    private javax.swing.JTextField jTextFieldPosXTo;
    private javax.swing.JTextField jTextFieldPosYFrom;
    private javax.swing.JTextField jTextFieldPosYTo;
    private javax.swing.JTextField jTextFieldResync;
    private javax.swing.JTextField jTextFieldRoundCount;
    private javax.swing.JPanel lanePanel;
    private de.malban.vide.veccy.StoryboardLanePanel storyboardLanePanel1;
    // End of variables declaration//GEN-END:variables
    public void setVeccy(VeccyPanel vp)
    {
        veccy = vp;
    }
    
    public static void showModPanelNoModal(VeccyPanel v)
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        StoryboardPanelNew panel = new StoryboardPanelNew();
        if (v != null)
        {
            v.setSBPanel(panel);
            panel.veccy = v;
        }
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addAsWindow(panel, 1080, 800, "Storyboard Panel new");
    }    

    void updateToElement(boolean onlyAnimation)
    {
        if (mClassSetting>0) return;
        jButtonLoad2.setEnabled(currentElement!=null);
        jButton3.setEnabled(currentElement!=null);
        if (currentElement == null) return;
        mClassSetting++;
        if (!onlyAnimation)
        {
            currentElement.animationLoop = jCheckBoxAnimationLoop.isSelected();
            currentElement.listScaleFrom = de.malban.util.UtilityString.Int0(jTextFieldListScaleFrom.getText());
            currentElement.listScaleTo = de.malban.util.UtilityString.Int0(jTextFieldListScaleTo.getText());

            currentElement.intensityFrom = de.malban.util.UtilityString.Int0(jTextFieldListIntensityFrom.getText());
            currentElement.intensityTo = de.malban.util.UtilityString.Int0(jTextFieldListIntensityTo.getText());

            currentElement.positionXFrom = de.malban.util.UtilityString.Int0(jTextFieldPosXFrom.getText());
            currentElement.positionYFrom = de.malban.util.UtilityString.Int0(jTextFieldPosYFrom.getText());
            currentElement.positionXTo = de.malban.util.UtilityString.Int0(jTextFieldPosXTo.getText());
            currentElement.positionYTo = de.malban.util.UtilityString.Int0(jTextFieldPosYTo.getText());

            currentElement.moveScale = de.malban.util.UtilityString.Int0(jTextFieldMoveScale.getText());
            currentElement.vectrexdelay =   de.malban.util.UtilityString.Int0(jTextFieldDelayVectrex.getText());
            currentElement.delay =   currentElement.vectrexdelay*20;

            currentElement.resyncMax =   de.malban.util.UtilityString.IntX(jTextFieldResync.getText(), 20);
            currentElement.factor =   de.malban.util.UtilityString.IntX(jTextFieldFactor.getText(), 1);
            
            currentElement.disabled = jCheckBoxDisable.isSelected();
            
            currentElement.pause = jCheckBoxPause.isSelected();

            if (currentElement.vectrexdelay == 0) currentElement.vectrexdelay = 1;
            
            if (currentAnimation != null)
                jTextFieldFrameCount.setText(""+currentAnimation.size());
            
            currentElement.roundCount = de.malban.util.UtilityString.IntX(jTextFieldRoundCount.getText(), 20);

            currentElement.drawType = getListType();
            if ((currentElement.drawType == null) || (currentElement.drawType.trim().length() == 0))
            {
                // some sensible default
                currentElement.drawType ="synced";
                setListType( "synced");
            }
            jLabel9.setEnabled(!(currentElement.drawType == "synced extended"));
            jTextFieldListIntensityFrom.setEnabled(!(currentElement.drawType == "synced extended"));
            jTextFieldListIntensityTo.setEnabled(!(currentElement.drawType == "synced extended"));
            if (currentElement.drawType == "synced extended")
            {
                currentElement.intensityTo = 127;
                currentElement.intensityFrom = 127;
                jTextFieldListIntensityFrom.setText(""+currentElement.intensityFrom);
                jTextFieldListIntensityTo.setText(""+currentElement.intensityTo);
            }
        }
        currentElement.listName = jTextFieldAnimationName.getText();
        
        if (currentAnimation != null)
        {
            if (jTextFieldAnimationName.getText().trim().length() != 0) 
            {
                if (!currentElement.pause)
                    currentElement.setAnimation(currentAnimation);
            }
        }
        currentElement.setDelay(currentElement.delay);
        upladeLaneData();
        mClassSetting--;
    }
    
    void clearElement(boolean isPause)
    {
        jTextFieldListScaleFrom.setText("80");
        jTextFieldListScaleTo.setText("0");
    
        jTextFieldListIntensityFrom.setText("127");
        jTextFieldListIntensityTo.setText("0");
        
        jTextFieldPosXFrom.setText("0");
        jTextFieldPosYFrom.setText("0");
        jTextFieldPosXTo.setText("0");
        jTextFieldPosYTo.setText("0");
        
        jTextFieldMoveScale.setText("80");
        jTextFieldDelayVectrex.setText("3");
        jCheckBoxDisable.setSelected(false);
        
        jTextFieldFactor.setText("1");
        jTextFieldResync.setText("20");
        jTextFieldFrameCount.setText("0");
        jTextFieldAnimationName.setText("");

        jTextFieldRoundCount.setText("200");

        mClassSetting++;
        jCheckBoxAnimationLoop.setSelected(true);
        jComboBoxDrawType.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "" }));
        jComboBoxDrawType.setSelectedIndex(-1);
        mClassSetting--;
        upladeLaneData();
    }

    public void setElement(StoryboardElement element, StoryboardLanePanel lane)
    {
        if (currentLane != null)
        {
            currentLane.setLaneSelected(false);
        }
        currentLane = lane;
        if (currentLane == null)
        {
            clearElement(false);
            return;
        }
        currentLane.setLaneSelected(true);
        
        if (currentElement != null)
        {
            currentElement.setElementSelected(false);
        }
        currentElement = element;
        jButtonLoad2.setEnabled(currentElement!=null);
        jButton3.setEnabled(currentElement!=null);
        if (currentElement == null)
        {
            clearElement(false);
            return;
        }
        currentElement.setElementSelected(true);

        jCheckBoxPause.setSelected(currentElement.pause);
        jTextFieldRoundCount.setText(""+element.roundCount);

        if (!currentElement.pause)
        {
            if (!setAnimationFromElement(currentElement))
            {
                clearElement(currentElement.pause);
                return;
            }
        }
        jTextFieldAnimationName.setText(element.listName);
        jTextFieldFrameCount.setText(""+currentAnimation.size());
        
        jTextFieldListScaleFrom.setText(""+element.listScaleFrom);
        jTextFieldListScaleTo.setText(""+element.listScaleTo);
        
        jTextFieldListIntensityFrom.setText(""+element.intensityFrom);
        jTextFieldListIntensityTo.setText(""+element.intensityTo);
        
        jTextFieldPosXFrom.setText(""+element.positionXFrom);
        jTextFieldPosYFrom.setText(""+element.positionYFrom);
        jCheckBoxDisable.setSelected(element.disabled);
        
        jTextFieldPosXTo.setText(""+element.positionXTo);
        jTextFieldPosYTo.setText(""+element.positionYTo);
        
        jTextFieldMoveScale.setText(""+element.moveScale);
        if (element.vectrexdelay == 0) element.vectrexdelay = 1;
        jTextFieldDelayVectrex.setText(""+element.vectrexdelay);
        currentElement.delay =   currentElement.vectrexdelay*20;

        jTextFieldResync.setText(""+element.resyncMax);
        jTextFieldFactor.setText(""+element.factor);
        
        jTextFieldRoundCount.setText(""+element.roundCount);
        mClassSetting++;
        jCheckBoxAnimationLoop.setSelected(element.animationLoop);
        mClassSetting--;
        
        setListType(element.drawType);
        upladeLaneData();
    }
    
    boolean loadAnimationFromElement(String loadName)
    {
        if (currentElement == null) return false;
        boolean ok = false;
        
        if (loadName == null) 
        {
            clearElement(false);
            return false;
        }
        if (loadName.trim().length() == 0) 
        {
            clearElement(false);
            return false;
        }
        if (loadName != null)
        {
            if (!loadName.toUpperCase().endsWith(".XML"))
            {
                loadName+= ".xml";
            }
            currentAnimation = new GFXVectorAnimation();
            ok = currentAnimation.loadFromXML(loadName);
            if (ok)
            {
                if (currentAnimation.size()>0)
                {
                    updateToElement(true);
                }
                else
                {
                    clearElement(false);
                    return false;
                }
            }
        }
        loadName = de.malban.util.Utility.makeVideRelative(loadName);
        jTextFieldAnimationName.setText(loadName);
                
        currentElement.listName = loadName;
        upladeLaneData();
        return ok;
    }
    boolean setAnimationFromElement(StoryboardElement element)
    {
        if (element == null) return false;
        boolean ok = false;
        
        if (!element.pause)
        {
            String loadName = element.listName;
            currentAnimation = element.getAnimation();
            if (currentAnimation == null)
            {
                clearElement(false);
                return false;
            }
            if (currentAnimation.size()>0)
            {
                // destroys loadname
                updateToElement(true);
            }
            else
            {
                clearElement(false);
                return false;
            }
            currentElement.listName = loadName;
        }
        
        upladeLaneData();
        return true;
    }
    boolean loadAnimation()
    {
        boolean ok = false;
        
        String filename =Global.mainPathPrefix+"xml"+File.separator+"vectoranimation";
//        String loadName = VectorListFileChoserJPanel.showSavePanel(filename, "Load Vector-Animation", true);
        
        
        
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setCurrentDirectory(new java.io.File(filename));
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return false;
        String name = fc.getSelectedFile().getAbsolutePath();

        return loadAnimationFromElement(name);
//        return loadAnimationFromElement(de.malban.util.Utility.makeRelative(name));
    }
    
    private void setListType(String type)
    {
        mClassSetting++;
        if ((currentElement == null) || (currentAnimation == null))
        {
            jComboBoxDrawType.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "" }));
            jComboBoxDrawType.setSelectedIndex(-1);
            mClassSetting--;
            return;
        }
        ArrayList<String> types = new ArrayList<String>();
        
        // export Anims
        boolean Mov_Draw_VLc_a = true;
        boolean Draw_VLc = currentAnimation.isAnimation;
        boolean Draw_VLp = currentAnimation.isAnimation;
        boolean Draw_VL_mode = true;
        boolean AnimCodeGen = true;

                
        boolean allSamePattern = currentAnimation.isAllSamePattern();
        boolean allContinuous = currentAnimation.isCompleteRelative();
        boolean allHighPattern0 = getCurrentAnimation().isAllPatternHigh(true);


        if (!allSamePattern)
        {
            Draw_VLc = false;
        }
        if (!allHighPattern0)
        {
            Draw_VLp = false;
        }
        if (!allContinuous)
        {
            Mov_Draw_VLc_a = false;
            Draw_VLc = false;
            Draw_VLp = false;
            Draw_VL_mode = false;
            AnimCodeGen = false;
        }
/* TODO todo add in vectrex code!
        if (Mov_Draw_VLc_a) types.add("Mov_Draw_VLc_a");
        if (Draw_VLc) types.add("Draw_VLc");
        if (Draw_VLp) types.add("Draw_VLp");
        if (Draw_VL_mode) types.add("Draw_VL_mode");
        if (AnimCodeGen) types.add("AnimCodeGen");
*/        
        types.add("synced");
        types.add("synced extended");
        
        int index = -1;
        int count =0;
        for (String s: types)
        {
            if (s.equals(type))
            {
                index = count;
                break;
            }
            count++;
        }
        
        jComboBoxDrawType.setModel(new javax.swing.DefaultComboBoxModel(types.toArray(new String[0])));
        jComboBoxDrawType.setSelectedIndex(index);
        mClassSetting--;
    }
    
    
    
    
    private String getListType()
    {
        if (jComboBoxDrawType.getSelectedIndex()== -1) return "";
        if (jComboBoxDrawType.getSelectedItem() == null) return "";
        return jComboBoxDrawType.getSelectedItem().toString();
    }

    
    
    
    boolean loadStoryboard()
    {
        
        String filename =Global.mainPathPrefix+"xml"+File.separator+"storyboard";

        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setCurrentDirectory(new java.io.File(filename));
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return false;
        String loadName = fc.getSelectedFile().getAbsolutePath();
        //loadName = de.malban.util.Utility.makeRelative(loadName);
        
        boolean ok = false;
        if (loadName != null)
        {
            clearLanes();
            if (!loadName.toUpperCase().endsWith(".XML"))
            {
                loadName+= ".xml";
            }
            ok = loadFromXML(loadName);

            jLabel9.setEnabled(!(currentElement.drawType == "synced extended"));
            jTextFieldListIntensityFrom.setEnabled(!(currentElement.drawType == "synced extended"));
            jTextFieldListIntensityTo.setEnabled(!(currentElement.drawType == "synced extended"));
            if (currentElement.drawType == "synced extended")
            {
                currentElement.intensityTo = 127;
                currentElement.intensityFrom = 127;
                jTextFieldListIntensityFrom.setText(""+currentElement.intensityFrom);
                jTextFieldListIntensityTo.setText(""+currentElement.intensityTo);
            }
        }
        return ok;
    }
    boolean saveStoryboard()
    {
        String filename =Global.mainPathPrefix+"xml"+File.separator+"storyboard";
        
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setCurrentDirectory(new java.io.File(filename));
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return false;
        if (fc.getSelectedFile() == null) return false;
        String saveName = fc.getSelectedFile().getAbsolutePath();
//        saveName = de.malban.util.Utility.makeRelative(saveName);
        
        if (saveName != null)
        {
            if (!saveName.toUpperCase().endsWith(".XML"))
            {
                saveName+= ".xml";
            }
            return saveAsXML(saveName);
        }
        return false;
        
    }
    public boolean loadFromXML(String filename)
    {
        String xml = de.malban.util.UtilityString.readTextFileToOneString(new File (filename));
        boolean ok = fromXML(xml, new XMLSupport());
        if (!ok)
        {
            log.addLog("Storyboard load from xml '"+filename+"' return false", WARN);
            return false;
        }
        return true;
    }
    
    public boolean saveAsXML(String filename)
    {
        StringBuilder xml = new StringBuilder();
        boolean ok = toXML(xml, "Storyboard");
        if (!ok)
        {
            log.addLog("Storyboard save 'toXML' return false", WARN);
            return false;
        }
        ok = de.malban.util.UtilityFiles.createTextFile(filename, xml.toString());
        if (!ok)
        {
            log.addLog("Storyboard create file '"+filename+"' return false", WARN);
            return false;
        }
        return true; 
    }
    public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        ok = ok & XMLSupport.addElement(s, "noAdditionalStoryboardOptimization", jCheckBoxNoAdditionalSynOptimization.isSelected());
    
        for(StoryboardLanePanel l: lanes)
        {
            ok = ok & l.toXML(s, "SBLane");
        }
        
        s.append("</").append(tag).append(">\n");
        return ok;        
    }

    // a xml "list" of an arbitrary number of GFXVectors
    public boolean fromXML(String xml, XMLSupport xmlSupport)
    {
        lanes = new ArrayList<StoryboardLanePanel>();
        int errorCode = 0;
        StringBuilder xmlBuffer = new StringBuilder(xml);
        StringBuilder oneElement = null;
        jCheckBoxNoAdditionalSynOptimization.setSelected(xmlSupport.getBooleanElement("noAdditionalStoryboardOptimization", xmlBuffer));
        errorCode|=xmlSupport.errorCode;
        do 
        {
            oneElement = xmlSupport.removeTag("SBLane", xmlBuffer);
            if (oneElement==null) break;
            errorCode|=xmlSupport.errorCode;
            
            StoryboardLanePanel sb = new StoryboardLanePanel(this);
            sb.fromXML(oneElement, xmlSupport);
            if (sb.isVersion1())
            {
                log.addLog("Wrong storyboard version - not loaded", WARN);
                lanes = new ArrayList<StoryboardLanePanel>();
                upladeLaneData();
                updateBounds();
                return false;
            }
            
            errorCode|=xmlSupport.errorCode;
            
            lanePanel.add(sb);
            sb.setBounds(0, 0+80*lanes.size(), sb.getBounds().width, 79);
            lanes.add(sb);
            lanePanel.repaint();
        } while (true);
        
        upladeLaneData();
        updateBounds();
        if (errorCode!= 0) return false;
        return true;
    }    
    void clearLanes()
    {
        for (int i = lanePanel.getComponentCount()-1; i>=0 ; i--)
        {
            Component c = lanePanel.getComponent(i);
            if (c instanceof StoryboardLanePanel)
            {
                lanePanel.remove(c);
            }
        }
        currentElement = null;
        currentLane = null;
        upladeLaneData();
        repaint();
    }
    void deleteCurrentElement()
    {
        if (currentElement == null)
        {
            return;
        }
        if (currentLane == null)
        {
            return;
        }
        currentLane.removeElement(currentElement);
        upladeLaneData();
        
    }
    void deleteLane()
    {
        if (currentLane == null)
        {
            return;
        }
        lanePanel.remove(currentLane);
        lanes.remove(currentLane);
        currentLane = null;
        currentElement = null;
        reorder();
        upladeLaneData();
        lanePanel.repaint();
    }
    void reorder()
    {
        int count = 0;
        for (int i = 0; i< lanePanel.getComponentCount(); i++)
        {
            Component c = lanePanel.getComponent(i);
            if (c instanceof StoryboardLanePanel)
            {
                
                StoryboardLanePanel sb = (StoryboardLanePanel)c;
                sb.setBounds(0, 0+80*count, sb.getBounds().width, 79);
                count++;
            }
        }
        updateBounds();
        repaint();
    }
    void guessBlowUpFactor()
    {
        if (currentAnimation == null)
            return;
        if (currentElement == null)
            return;
        int maxLen = (int) currentAnimation.getMaxAbsLenValue();
        if (maxLen == 0)
        {
            currentElement.factor = 1;
            jTextFieldFactor.setText(""+currentElement.factor);
            return;
        }
        int factor = 127/maxLen;
        currentElement.factor = factor;
        jTextFieldFactor.setText(""+currentElement.factor);
        
    }
    
    // TODO:
    // not done for Version II
    private void generateSource()
    {              
        StringBuilder text = new StringBuilder();
        HashMap<String, String> noDoubleAnimMap = new HashMap<String, String>();
        ArrayList<String> animData = new ArrayList<String>();

        HashMap<String, String> noDoubleRoutineMap = new HashMap<String, String>();
        ArrayList<String> routineData = new ArrayList<String>();
        
        ArrayList<String> laneInit = new ArrayList<String>();
        ArrayList<String> laneData = new ArrayList<String>();

        for (StoryboardLanePanel lane : lanes)
        {
            // collect animation data from all lanes, no doubles
            lane.getAnimData(animData, noDoubleAnimMap);

            // collect subroutines needed for display all lanes, no doubles
            lane.getDrawRoutines(routineData, noDoubleRoutineMap);

            // collect code used by one lane
            lane.getLaneData(laneData, noDoubleAnimMap);

            // collect code used by one lane
            lane.getLaneInit(laneInit);
        }
        // check list type can be drawn other than sync
        // check if animlist are doubles
        StringBuilder laneInitString = new StringBuilder();
        for (String li : laneInit)
            laneInitString.append(li);
        
        
        Path template = Paths.get(Global.mainPathPrefix, "template", "storyboardDefines.template");
        String defines = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

        template = Paths.get(Global.mainPathPrefix, "template", "storyboardMain.template");
        String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
        
        main = de.malban.util.UtilityString.replace(main, ";INSERT LANE INIT CODE", laneInitString.toString());
               
        template = Paths.get(Global.mainPathPrefix, "template", "storyboardRoutinesV2.template");
        String lane_subroutines = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

        template = Paths.get(Global.mainPathPrefix, "template", "storyboardRAMV2.template");
        String ram = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
        ram = de.malban.util.UtilityString.replace(ram, "#LANE_COUNT#", ""+lanes.size());

        text.append(ram);
        text.append(defines);
        text.append(main);
        text.append(lane_subroutines);
        
        for (String routine : routineData)
            text.append(routine);

        for (String lc : laneData)
            text.append(lc);

        for (String anim : animData)
            text.append(anim);
        
        
        jTextAreaResult.setText(text.toString());
    }             
    
    void upladeLaneData()
    {
        if (currentLane != null)
        {
            jTextFieldFrameCount2.setText(""+currentLane.getLengthInRound());
        }
        else
           jTextFieldFrameCount2.setText("0");
    }
    
    public boolean isNoAdditionalSyncOptimization()
    {
        return jCheckBoxNoAdditionalSynOptimization.isSelected();
    }
    public int getVersion()
    {
        return 2;
    }
    public void deIconified() { }
    
}

