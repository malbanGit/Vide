/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.veccy;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.graphics.GFXVectorAnimation;
import de.malban.graphics.GFXVectorList;
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
public class StoryboardPanel extends javax.swing.JPanel  implements Windowable, StoryboardPanelInterface{

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
     * Creates new form StoryboardPanel
     */
    public StoryboardPanel() {
        initComponents();
        if (Global.getOSName().toUpperCase().contains("MAC"))
        {
            HotKey.addMacDefaults(jTextFieldAnimationName);
            HotKey.addMacDefaults(jTextFieldFrameCount);
            HotKey.addMacDefaults(jTextFieldDelayVectrex);
            HotKey.addMacDefaults(jTextFieldListScaleStart);
            HotKey.addMacDefaults(jTextFieldListScaleDelay);
            HotKey.addMacDefaults(jTextFieldListScaleIncrease);
            HotKey.addMacDefaults(jTextFieldListIntensityFrom);
            HotKey.addMacDefaults(jTextFieldListIntensityDelay);
            HotKey.addMacDefaults(jTextFieldListIntensityIncrease);
            HotKey.addMacDefaults(jTextFieldPosStartX);
            HotKey.addMacDefaults(jTextFieldPosDelayX);
            HotKey.addMacDefaults(jTextFieldPosIncreaseX);
            HotKey.addMacDefaults(jTextFieldPosStartY);
            HotKey.addMacDefaults(jTextFieldPosDelayY);
            HotKey.addMacDefaults(jTextFieldPosIncreaseY);
            HotKey.addMacDefaults(jTextFieldMoveScale);
            HotKey.addMacDefaults(jTextFieldResync);
            HotKey.addMacDefaults(jTextFieldFactor);
            HotKey.addMacDefaults(jTextFieldGotoValue);
            HotKey.addMacDefaults(jTextFieldLoopCount);
        }
        
        lanePanel.remove(storyboardLanePanel1);
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
        jTextFieldListScaleStart = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        jTextFieldMoveScale = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jTextFieldPosStartX = new javax.swing.JTextField();
        jTextFieldPosStartY = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jTextFieldPosDelayX = new javax.swing.JTextField();
        jTextFieldPosDelayY = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        jComboBoxDrawType = new javax.swing.JComboBox();
        jTextFieldPosIncreaseX = new javax.swing.JTextField();
        jTextFieldPosIncreaseY = new javax.swing.JTextField();
        jTextFieldListScaleIncrease = new javax.swing.JTextField();
        jTextFieldListScaleDelay = new javax.swing.JTextField();
        jButtonLoad2 = new javax.swing.JButton();
        jLabel6 = new javax.swing.JLabel();
        jTextFieldAnimationName = new javax.swing.JTextField();
        jLabel12 = new javax.swing.JLabel();
        jTextFieldLoopCount = new javax.swing.JTextField();
        jTextFieldDelayVectrex = new javax.swing.JTextField();
        jTextFieldResync = new javax.swing.JTextField();
        jTextFieldFactor = new javax.swing.JTextField();
        jLabel14 = new javax.swing.JLabel();
        jTextFieldRoundCount = new javax.swing.JTextField();
        jCheckBoxManualRoundCount = new javax.swing.JCheckBox();
        jLabel9 = new javax.swing.JLabel();
        jTextFieldListIntensityFrom = new javax.swing.JTextField();
        jTextFieldListIntensityDelay = new javax.swing.JTextField();
        jTextFieldListIntensityIncrease = new javax.swing.JTextField();
        jTextFieldGotoValue = new javax.swing.JTextField();
        jCheckBoxGoto = new javax.swing.JCheckBox();
        jCheckBoxLoop = new javax.swing.JCheckBox();
        jLabel13 = new javax.swing.JLabel();
        jCheckBoxDisable = new javax.swing.JCheckBox();
        jCheckBoxPause = new javax.swing.JCheckBox();
        jCheckBoxNoAdditionalSynOptimization = new javax.swing.JCheckBox();
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

        jLabel3.setText("scale/delay/increase");

        jTextFieldListScaleStart.setText("10");
        jTextFieldListScaleStart.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldListScaleStartActionPerformed(evt);
            }
        });
        jTextFieldListScaleStart.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldListScaleStartKeyReleased(evt);
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

        jLabel5.setText("X/delay/increase");

        jTextFieldPosStartX.setText("10");
        jTextFieldPosStartX.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPosStartXActionPerformed(evt);
            }
        });
        jTextFieldPosStartX.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                textfieldKeyReleased(evt);
            }
        });

        jTextFieldPosStartY.setText("10");
        jTextFieldPosStartY.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPosStartYActionPerformed(evt);
            }
        });
        jTextFieldPosStartY.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldPosStartXKeyReleased(evt);
            }
        });

        jLabel7.setText("Y/delay/increase");

        jTextFieldPosDelayX.setText("10");
        jTextFieldPosDelayX.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPosDelayXActionPerformed(evt);
            }
        });
        jTextFieldPosDelayX.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldPosStartXKeyReleased(evt);
            }
        });

        jTextFieldPosDelayY.setText("10");
        jTextFieldPosDelayY.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPosDelayYActionPerformed(evt);
            }
        });
        jTextFieldPosDelayY.addKeyListener(new java.awt.event.KeyAdapter() {
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

        jTextFieldPosIncreaseX.setText("10");
        jTextFieldPosIncreaseX.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPosIncreaseXActionPerformed(evt);
            }
        });
        jTextFieldPosIncreaseX.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldPosStartXKeyReleased(evt);
            }
        });

        jTextFieldPosIncreaseY.setText("10");
        jTextFieldPosIncreaseY.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPosIncreaseYActionPerformed(evt);
            }
        });
        jTextFieldPosIncreaseY.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldPosStartXKeyReleased(evt);
            }
        });

        jTextFieldListScaleIncrease.setText("10");
        jTextFieldListScaleIncrease.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldListScaleIncreaseActionPerformed(evt);
            }
        });
        jTextFieldListScaleIncrease.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldListScaleIncreaseKeyReleased(evt);
            }
        });

        jTextFieldListScaleDelay.setText("10");
        jTextFieldListScaleDelay.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                textFieldReturn(evt);
            }
        });
        jTextFieldListScaleDelay.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldListScaleDelayKeyReleased(evt);
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

        jLabel6.setText("delay");

        jTextFieldAnimationName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldAnimationNameActionPerformed(evt);
            }
        });

        jLabel12.setText("loop");

        jTextFieldLoopCount.setText("10");
        jTextFieldLoopCount.setToolTipText("Loop count: (0 = endless, after loop - continue)");
        jTextFieldLoopCount.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldLoopCountActionPerformed(evt);
            }
        });

        jTextFieldDelayVectrex.setText("10");
        jTextFieldDelayVectrex.setToolTipText("display delay for vectrex, in \"rounds\"");
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

        jLabel14.setText("display rounds");

        jTextFieldRoundCount.setText("0");
        jTextFieldRoundCount.setEnabled(false);
        jTextFieldRoundCount.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldRoundCountActionPerformed(evt);
            }
        });

        jCheckBoxManualRoundCount.setText("manual round count");
        jCheckBoxManualRoundCount.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxManualRoundCountActionPerformed(evt);
            }
        });

        jLabel9.setText("intensity/delay/increase");
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

        jTextFieldListIntensityDelay.setText("10");
        jTextFieldListIntensityDelay.setEnabled(false);
        jTextFieldListIntensityDelay.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldListIntensityDelaytextFieldReturn(evt);
            }
        });
        jTextFieldListIntensityDelay.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldListIntensityDelayKeyReleased(evt);
            }
        });

        jTextFieldListIntensityIncrease.setText("10");
        jTextFieldListIntensityIncrease.setEnabled(false);
        jTextFieldListIntensityIncrease.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldListIntensityIncreaseActionPerformed(evt);
            }
        });
        jTextFieldListIntensityIncrease.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldListIntensityIncreaseKeyReleased(evt);
            }
        });

        jTextFieldGotoValue.setText("10");
        jTextFieldGotoValue.setToolTipText("GotValue - must be a storyboard element within this lane - 0 based.");
        jTextFieldGotoValue.setEnabled(false);
        jTextFieldGotoValue.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldGotoValueActionPerformed(evt);
            }
        });
        jTextFieldGotoValue.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldGotoValuejTextFieldPosStartXKeyReleased(evt);
            }
        });

        jCheckBoxGoto.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxGotoActionPerformed(evt);
            }
        });

        jCheckBoxLoop.setSelected(true);
        jCheckBoxLoop.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxLoopActionPerformed(evt);
            }
        });

        jLabel13.setText("jump");

        jCheckBoxDisable.setText("disable");
        jCheckBoxDisable.setToolTipText("treat sequence as if it was not aviable (for testing purposes - not SAVED)");
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
                    .addComponent(jLabel12)
                    .addComponent(jLabel2)
                    .addComponent(jLabel1)
                    .addComponent(jLabel3)
                    .addComponent(jLabel8)
                    .addComponent(jLabel9)
                    .addComponent(jLabel13))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jTextFieldAnimationName, javax.swing.GroupLayout.PREFERRED_SIZE, 147, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonLoad2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jTextFieldMoveScale, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jComboBoxDrawType, javax.swing.GroupLayout.PREFERRED_SIZE, 147, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jTextFieldLoopCount, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel3Layout.createSequentialGroup()
                                        .addComponent(jCheckBoxGoto)
                                        .addGap(32, 32, 32)
                                        .addComponent(jTextFieldGotoValue, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))))
                            .addGap(3, 3, 3)
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPanel3Layout.createSequentialGroup()
                                    .addComponent(jTextFieldResync, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jTextFieldFactor, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addComponent(jCheckBoxNoAdditionalSynOptimization)))
                        .addGroup(jPanel3Layout.createSequentialGroup()
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jTextFieldRoundCount, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jCheckBoxLoop))
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jCheckBoxManualRoundCount)
                                .addComponent(jCheckBoxPause, javax.swing.GroupLayout.PREFERRED_SIZE, 89, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                            .addComponent(jCheckBoxDisable)
                            .addGap(39, 39, 39)))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldPosStartY, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldPosStartX, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldListIntensityFrom, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldListScaleStart, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldFrameCount, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addComponent(jTextFieldPosDelayX, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldPosIncreaseX, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addComponent(jTextFieldPosDelayY, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldPosIncreaseY, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldListScaleDelay, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel6))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldDelayVectrex, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextFieldListScaleIncrease, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addComponent(jTextFieldListIntensityDelay, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldListIntensityIncrease, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))))))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(1, 1, 1)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonLoad2)
                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel2)
                        .addComponent(jTextFieldAnimationName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(jTextFieldFrameCount, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel6)
                    .addComponent(jTextFieldDelayVectrex, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel3)
                    .addComponent(jTextFieldListScaleStart, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldListScaleDelay, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldListScaleIncrease, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(4, 4, 4)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel9)
                    .addComponent(jTextFieldListIntensityFrom, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldListIntensityDelay, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldListIntensityIncrease, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldPosStartX, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel5))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel7)
                            .addComponent(jTextFieldPosStartY, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
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
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldPosDelayX, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldPosIncreaseX, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldPosIncreaseY, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldPosDelayY, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(6, 6, 6)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxGoto)
                            .addComponent(jLabel13))
                        .addGap(5, 5, 5)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxLoop, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel12)))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jTextFieldGotoValue, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxNoAdditionalSynOptimization))
                        .addGap(7, 7, 7)
                        .addComponent(jTextFieldLoopCount, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel14)
                    .addComponent(jTextFieldRoundCount, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxManualRoundCount))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 7, Short.MAX_VALUE)
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
            .addComponent(jScrollPane5, javax.swing.GroupLayout.DEFAULT_SIZE, 344, Short.MAX_VALUE)
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
                        .addComponent(jLabel15)
                        .addGap(14, 14, 14)
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
        generateSource();
        String filename = Global.mainPathPrefix+"tmp"+File.separator+"veccytmp.asm";
        de.malban.util.UtilityFiles.createTextFile(filename, jTextAreaResult.getText());
        startASM(filename);
    }//GEN-LAST:event_jButtonAssembleActionPerformed
    private void jButtonaddLaneActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonaddLaneActionPerformed
        StoryboardLanePanel sb = new StoryboardLanePanel(this);
        lanePanel.add(sb);
        sb.setBounds(0, 80*getLanes().size(), 28, 79);
        getLanes().add(sb);
        lanePanel.repaint();
        updateBounds();
    }//GEN-LAST:event_jButtonaddLaneActionPerformed

    private void jButtonLoad2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoad2ActionPerformed
        loadAnimation();
        setListType("dummy"); // just fill the combobox
        
        jTextFieldFrameCount.setText(""+getCurrentAnimation().size());
        if (getCurrentElement() != null)
            updateToElement(false);
        guessBlowUpFactor();
    }//GEN-LAST:event_jButtonLoad2ActionPerformed

    private void jTextFieldListScaleStartKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldListScaleStartKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListScaleStartKeyReleased

    private void jTextFieldListScaleIncreaseKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldListScaleIncreaseKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListScaleIncreaseKeyReleased

    private void jTextFieldListScaleDelayKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldListScaleDelayKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListScaleDelayKeyReleased

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

    private void jTextFieldLoopCountActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldLoopCountActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldLoopCountActionPerformed

    private void jTextFieldMoveScaleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldMoveScaleActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldMoveScaleActionPerformed

    private void jTextFieldPosDelayXActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPosDelayXActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldPosDelayXActionPerformed

    private void jTextFieldPosDelayYActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPosDelayYActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldPosDelayYActionPerformed

    private void jTextFieldPosStartYActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPosStartYActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldPosStartYActionPerformed

    private void jTextFieldPosStartXActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPosStartXActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldPosStartXActionPerformed

    private void jTextFieldPosIncreaseXActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPosIncreaseXActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldPosIncreaseXActionPerformed

    private void jTextFieldPosIncreaseYActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPosIncreaseYActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldPosIncreaseYActionPerformed

    private void jTextFieldListScaleIncreaseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldListScaleIncreaseActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListScaleIncreaseActionPerformed

    private void jTextFieldListScaleStartActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldListScaleStartActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListScaleStartActionPerformed

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

    private void jTextFieldListIntensityDelaytextFieldReturn(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldListIntensityDelaytextFieldReturn
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListIntensityDelaytextFieldReturn

    private void jTextFieldListIntensityDelayKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldListIntensityDelayKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListIntensityDelayKeyReleased

    private void jTextFieldListIntensityIncreaseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldListIntensityIncreaseActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListIntensityIncreaseActionPerformed

    private void jTextFieldListIntensityIncreaseKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldListIntensityIncreaseKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldListIntensityIncreaseKeyReleased

    private void jCheckBoxManualRoundCountActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxManualRoundCountActionPerformed
        jTextFieldRoundCount.setEnabled(jCheckBoxManualRoundCount.isSelected());
        updateToElement(false);
    }//GEN-LAST:event_jCheckBoxManualRoundCountActionPerformed

    private void jTextFieldGotoValueActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldGotoValueActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldGotoValueActionPerformed

    private void jTextFieldGotoValuejTextFieldPosStartXKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldGotoValuejTextFieldPosStartXKeyReleased
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldGotoValuejTextFieldPosStartXKeyReleased

    private void jTextFieldRoundCountActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldRoundCountActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jTextFieldRoundCountActionPerformed

    private void jCheckBoxGotoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxGotoActionPerformed
        jTextFieldGotoValue.setEnabled(jCheckBoxGoto.isSelected());
        updateToElement(false);
    }//GEN-LAST:event_jCheckBoxGotoActionPerformed

    private void jCheckBoxLoopActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxLoopActionPerformed
        jTextFieldLoopCount.setEnabled(jCheckBoxLoop.isSelected());
        updateToElement(false);
    }//GEN-LAST:event_jCheckBoxLoopActionPerformed

    private void jCheckBoxPauseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxPauseActionPerformed
        if (jCheckBoxPause.isSelected())
            jCheckBoxManualRoundCount.setEnabled(true);
        updateToElement(false);
    }//GEN-LAST:event_jCheckBoxPauseActionPerformed

    private void jComboBoxDrawTypeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxDrawTypeActionPerformed
        if (mClassSetting>0) return;
        updateToElement(false);
        
    }//GEN-LAST:event_jComboBoxDrawTypeActionPerformed

    private void jTextFieldAnimationNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldAnimationNameActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldAnimationNameActionPerformed

    private void jCheckBoxDisableActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxDisableActionPerformed
        updateToElement(false);
    }//GEN-LAST:event_jCheckBoxDisableActionPerformed
    public void updateBounds()
    {
        int minW = jScrollPane1.getViewport().getBounds().width;
        int minH = jScrollPane1.getViewport().getBounds().height;
        int laneH = 0;
        for (StoryboardLanePanel l: getLanes())
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
    private javax.swing.JCheckBox jCheckBoxDisable;
    private javax.swing.JCheckBox jCheckBoxGoto;
    private javax.swing.JCheckBox jCheckBoxLoop;
    private javax.swing.JCheckBox jCheckBoxManualRoundCount;
    private javax.swing.JCheckBox jCheckBoxNoAdditionalSynOptimization;
    private javax.swing.JCheckBox jCheckBoxPause;
    private javax.swing.JComboBox jComboBoxDrawType;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
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
    private javax.swing.JTextField jTextFieldGotoValue;
    private javax.swing.JTextField jTextFieldListIntensityDelay;
    private javax.swing.JTextField jTextFieldListIntensityFrom;
    private javax.swing.JTextField jTextFieldListIntensityIncrease;
    private javax.swing.JTextField jTextFieldListScaleDelay;
    private javax.swing.JTextField jTextFieldListScaleIncrease;
    private javax.swing.JTextField jTextFieldListScaleStart;
    private javax.swing.JTextField jTextFieldLoopCount;
    private javax.swing.JTextField jTextFieldMoveScale;
    private javax.swing.JTextField jTextFieldPosDelayX;
    private javax.swing.JTextField jTextFieldPosDelayY;
    private javax.swing.JTextField jTextFieldPosIncreaseX;
    private javax.swing.JTextField jTextFieldPosIncreaseY;
    private javax.swing.JTextField jTextFieldPosStartX;
    private javax.swing.JTextField jTextFieldPosStartY;
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
        StoryboardPanel panel = new StoryboardPanel();
        if (v != null)
        {
            v.setSBPanel(panel);
            panel.veccy = v;
        }
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addAsWindow(panel, 1080, 800, "Storyboard Panel");
    }    

    void updateToElement(boolean onlyAnimation)
    {
        if (mClassSetting>0) return;
        jButtonLoad2.setEnabled(getCurrentElement()!=null);
        jButton3.setEnabled(getCurrentElement()!=null);
        if (getCurrentElement() == null) return;
        mClassSetting++;
        if (!onlyAnimation)
        {
            currentElement.listScaleStart = de.malban.util.UtilityString.Int0(jTextFieldListScaleStart.getText());
            currentElement.listScaleDelay = de.malban.util.UtilityString.Int0(jTextFieldListScaleDelay.getText());
            currentElement.listScaleIncrease = de.malban.util.UtilityString.Int0(jTextFieldListScaleIncrease.getText());

            currentElement.intensityStart = de.malban.util.UtilityString.Int0(jTextFieldListIntensityFrom.getText());
            currentElement.intensityDelay = de.malban.util.UtilityString.Int0(jTextFieldListIntensityDelay.getText());
            currentElement.intensityIncrease = de.malban.util.UtilityString.Int0(jTextFieldListIntensityIncrease.getText());

            currentElement.positionXStart = de.malban.util.UtilityString.Int0(jTextFieldPosStartX.getText());
            currentElement.positionYStart = de.malban.util.UtilityString.Int0(jTextFieldPosStartY.getText());
            currentElement.positionXDelay = de.malban.util.UtilityString.Int0(jTextFieldPosDelayX.getText());
            currentElement.positionYDelay = de.malban.util.UtilityString.Int0(jTextFieldPosDelayY.getText());
            currentElement.positionXIncrease = de.malban.util.UtilityString.Int0(jTextFieldPosIncreaseX.getText());
            currentElement.positionYIncrease = de.malban.util.UtilityString.Int0(jTextFieldPosIncreaseY.getText());

            currentElement.moveScale = de.malban.util.UtilityString.Int0(jTextFieldMoveScale.getText());
            currentElement.vectrexdelay =   de.malban.util.UtilityString.Int0(jTextFieldDelayVectrex.getText());
            currentElement.delay =   getCurrentElement().vectrexdelay*20;
            currentElement.loopCount =   de.malban.util.UtilityString.Int0(jTextFieldLoopCount.getText());

            currentElement.resyncMax =   de.malban.util.UtilityString.IntX(jTextFieldResync.getText(), 20);
            currentElement.factor =   de.malban.util.UtilityString.IntX(jTextFieldFactor.getText(), 1);
            currentElement.goto_value =   de.malban.util.UtilityString.IntX(jTextFieldGotoValue.getText(), 1);
            
            currentElement.disabled = jCheckBoxDisable.isSelected();
            
            currentElement.loop = jCheckBoxLoop.isSelected();
            currentElement._goto = jCheckBoxGoto.isSelected();
            currentElement.pause = jCheckBoxPause.isSelected();
            if (getCurrentElement().pause)
            {
                jCheckBoxManualRoundCount.setSelected(true);
            }
            
            
            if (getCurrentElement().vectrexdelay == 0) currentElement.vectrexdelay = 1;
            
            if (getCurrentAnimation() != null)
                jTextFieldFrameCount.setText(""+getCurrentAnimation().size());
            
            currentElement.roundCount = de.malban.util.UtilityString.IntX(jTextFieldRoundCount.getText(), 20);
            currentElement.manualRoundCount = jCheckBoxManualRoundCount.isSelected();
            if (!currentElement.manualRoundCount)
            {
                currentElement.roundCount = 1;
                if (getCurrentAnimation() != null)
                {
                    int roundCount = getCurrentElement().vectrexdelay * getCurrentAnimation().size();
                    if (getCurrentElement().loop)
                        roundCount *= getCurrentElement().loopCount;
                    currentElement.roundCount = roundCount;
                }
            }
            jTextFieldRoundCount.setText(""+getCurrentElement().roundCount);
            currentElement.drawType = getListType();
            if ((getCurrentElement().drawType == null) || (getCurrentElement().drawType.trim().length() == 0))
            {
                // some sensible default
                currentElement.drawType ="synced";
                setListType( "synced");
            }
            jLabel9.setEnabled(!(currentElement.drawType == "synced extended"));
            jTextFieldListIntensityFrom.setEnabled(!(currentElement.drawType == "synced extended"));
            jTextFieldListIntensityDelay.setEnabled(!(currentElement.drawType == "synced extended"));
            jTextFieldListIntensityIncrease.setEnabled(!(currentElement.drawType == "synced extended"));
            if (getCurrentElement().drawType == "synced extended")
            {
                currentElement.intensityIncrease = 0;
                jTextFieldListIntensityIncrease.setText(""+getCurrentElement().intensityIncrease);
                currentElement.intensityStart = -1;
                jTextFieldListIntensityFrom.setText(""+getCurrentElement().intensityStart);
            }
        }
        currentElement.listName = jTextFieldAnimationName.getText();
        
        
        if (getCurrentAnimation() != null)
        {
            if (jTextFieldAnimationName.getText().trim().length() != 0) 
            {
                if (!currentElement.pause)
                    getCurrentElement().setAnimation(getCurrentAnimation());
            }
        }
        if (getCurrentElement().loop)
        {
            if (!currentElement.manualRoundCount)
            {
                if (getCurrentElement().loopCount == 0)
                {
                    currentElement.roundCount = 0xffff;
                    jTextFieldRoundCount.setText(""+getCurrentElement().roundCount);
                }
            }
        }
        
        getCurrentElement().setDelay(getCurrentElement().delay);
        jTextFieldRoundCount.setEnabled(jCheckBoxManualRoundCount.isSelected());
        jTextFieldLoopCount.setEnabled(jCheckBoxLoop.isSelected());
        jTextFieldGotoValue.setEnabled(jCheckBoxGoto.isSelected());
        upladeLaneData();
        mClassSetting--;
    }
    
    void clearElement(boolean isPause)
    {
        jTextFieldListScaleStart.setText("80");
        jTextFieldListScaleIncrease.setText("0");
        jTextFieldListScaleDelay.setText("0");
    
        jTextFieldListIntensityFrom.setText("127");
        jTextFieldListIntensityIncrease.setText("0");
        jTextFieldListIntensityDelay.setText("0");
        
        jTextFieldPosStartX.setText("0");
        jTextFieldPosStartY.setText("0");
        jTextFieldPosIncreaseX.setText("0");
        jTextFieldPosIncreaseY.setText("0");
        
        jTextFieldPosDelayX.setText("0");
        jTextFieldPosDelayY.setText("0");
        
        jTextFieldMoveScale.setText("80");
        jTextFieldDelayVectrex.setText("3");
        jTextFieldLoopCount.setText("0");        
        
        jCheckBoxLoop.setSelected(true);
        jCheckBoxGoto.setSelected(false);
        jCheckBoxDisable.setSelected(false);
        

        
        jTextFieldFactor.setText("1");
        jTextFieldResync.setText("20");
        jTextFieldFrameCount.setText("0");
        jTextFieldAnimationName.setText("");
        
        
        jTextFieldGotoValue.setText("0");

        if (!isPause)
        {
            jTextFieldRoundCount.setText("0");
            jCheckBoxPause.setSelected(false);
        }
        
        mClassSetting++;
        if (!isPause)
        {
            jCheckBoxManualRoundCount.setSelected(false);
            jTextFieldRoundCount.setEnabled(jCheckBoxManualRoundCount.isSelected());
        }
        jComboBoxDrawType.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "" }));
        jComboBoxDrawType.setSelectedIndex(-1);
        jTextFieldLoopCount.setEnabled(jCheckBoxLoop.isSelected());
        jTextFieldGotoValue.setEnabled(jCheckBoxGoto.isSelected());
        mClassSetting--;
        upladeLaneData();
    }

    public void setElement(StoryboardElement element, StoryboardLanePanel lane)
    {

        if (getCurrentLane() != null)
        {
            getCurrentLane().setLaneSelected(false);
        }
        setCurrentLane(lane);
        if (getCurrentLane() == null)
        {
            clearElement(false);
            return;
        }
        getCurrentLane().setLaneSelected(true);
        
        
        if (getCurrentElement() != null)
        {
            getCurrentElement().setElementSelected(false);
        }
        setCurrentElement(element);
        jButtonLoad2.setEnabled(getCurrentElement()!=null);
        jButton3.setEnabled(getCurrentElement()!=null);
        if (getCurrentElement() == null)
        {
            clearElement(false);
            return;
        }
        getCurrentElement().setElementSelected(true);

        jCheckBoxPause.setSelected(getCurrentElement().pause);
        if (getCurrentElement().pause)
        {
            element.manualRoundCount = true;
        }
        jCheckBoxManualRoundCount.setSelected(element.manualRoundCount);
        jTextFieldRoundCount.setText(""+element.roundCount);

        if (!currentElement.pause)
        {
            if (!setAnimationFromElement(currentElement))
            {
                clearElement(getCurrentElement().pause);
                return;
            }
            
        }
        jTextFieldAnimationName.setText(element.listName);
        jTextFieldFrameCount.setText(""+getCurrentAnimation().size());
        
        jTextFieldListScaleStart.setText(""+element.listScaleStart);
        jTextFieldListScaleIncrease.setText(""+element.listScaleIncrease);
        jTextFieldListScaleDelay.setText(""+element.listScaleDelay);
        
        jTextFieldListIntensityFrom.setText(""+element.intensityStart);
        jTextFieldListIntensityIncrease.setText(""+element.intensityIncrease);
        jTextFieldListIntensityDelay.setText(""+element.intensityDelay);
        
        jTextFieldPosStartX.setText(""+element.positionXStart);
        jTextFieldPosStartY.setText(""+element.positionYStart);
        jTextFieldPosIncreaseX.setText(""+element.positionXIncrease);
        jTextFieldPosIncreaseY.setText(""+element.positionYIncrease);
        jCheckBoxDisable.setSelected(element.disabled);
        
        jTextFieldPosDelayX.setText(""+element.positionXDelay);
        jTextFieldPosDelayY.setText(""+element.positionYDelay);
        
        jTextFieldMoveScale.setText(""+element.moveScale);
        if (element.vectrexdelay == 0) element.vectrexdelay = 1;
        jTextFieldDelayVectrex.setText(""+element.vectrexdelay);
        currentElement.delay =   getCurrentElement().vectrexdelay*20;

        currentElement.goto_value =   de.malban.util.UtilityString.IntX(jTextFieldGotoValue.getText(), 1);
        
        jTextFieldLoopCount.setText(""+element.loopCount);
        jTextFieldResync.setText(""+element.resyncMax);
        jTextFieldFactor.setText(""+element.factor);
        
        jCheckBoxLoop.setSelected(element.loop);
        jCheckBoxGoto.setSelected(element._goto);
        

        if (!element.manualRoundCount)
        {
            element.roundCount = 1;
            if (getCurrentAnimation() != null)
            {
                int roundCount = element.vectrexdelay * getCurrentAnimation().size();
                if (element.loop)
                    roundCount *= element.loopCount;
                element.roundCount = roundCount;
            }
        }
        jTextFieldRoundCount.setText(""+element.roundCount);
        
        setListType(element.drawType);
        jTextFieldRoundCount.setEnabled(jCheckBoxManualRoundCount.isSelected());
        jTextFieldLoopCount.setEnabled(jCheckBoxLoop.isSelected());
        jTextFieldGotoValue.setEnabled(jCheckBoxGoto.isSelected());
        
        if (getCurrentElement().loop)
        {
            if (!currentElement.manualRoundCount)
            {
                if (getCurrentElement().loopCount == 0)
                {
                    currentElement.roundCount = 0xffff;
                    jTextFieldRoundCount.setText(""+getCurrentElement().roundCount);
                }
            }
        }
        upladeLaneData();
    }
    
    boolean loadAnimationFromElement(String loadName)
    {
        if (getCurrentElement() == null) return false;
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
            setCurrentAnimation(new GFXVectorAnimation());
            ok = getCurrentAnimation().loadFromXML(loadName);
            if (ok)
            {
                if (getCurrentAnimation().size()>0)
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
            setCurrentAnimation(element.getAnimation());
            if (getCurrentAnimation() == null)
            {
                clearElement(false);
                return false;
            }
            if (getCurrentAnimation().size()>0)
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
        if ((getCurrentElement() == null) || (getCurrentAnimation() == null))
        {
            jComboBoxDrawType.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "" }));
            jComboBoxDrawType.setSelectedIndex(-1);
            mClassSetting--;
            return;
        }
        ArrayList<String> types = new ArrayList<String>();
        
        // export Anims
        boolean Mov_Draw_VLc_a = true;
        boolean Draw_VLc = getCurrentAnimation().isAnimation;
        boolean Draw_VLp = getCurrentAnimation().isAnimation;
        boolean Draw_VL_mode = true;
        boolean AnimCodeGen = true;

                
        boolean allSamePattern = getCurrentAnimation().isAllSamePattern();
        boolean allContinuous = getCurrentAnimation().isCompleteRelative();
        boolean allHighPattern = getCurrentAnimation().isAllPatternHigh(false);
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
        for(StoryboardLanePanel l: getLanes())
        {
            ok = ok & l.toXML(s, "SBLane");
        }
        
        s.append("</").append(tag).append(">\n");
        return ok;        
    }

    // a xml "list" of an arbitrary number of GFXVectors
    public boolean fromXML(String xml, XMLSupport xmlSupport)
    {
        setLanes(new ArrayList<StoryboardLanePanel>());
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
            errorCode|=xmlSupport.errorCode;
            
            if (!sb.isVersion1())
            {
                log.addLog("Wrong storyboard version - not loaded", WARN);
                setLanes(new ArrayList<StoryboardLanePanel>());
                upladeLaneData();
                updateBounds();
                return false;
            }
            
            
            
            lanePanel.add(sb);
            sb.setBounds(0, 0+80*getLanes().size(), sb.getBounds().width, 79);
            getLanes().add(sb);
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
        setCurrentElement(null);
        setCurrentLane(null);
        upladeLaneData();
        repaint();
    }
    void deleteCurrentElement()
    {
        if (getCurrentElement() == null)
        {
            return;
        }
        if (getCurrentLane() == null)
        {
            return;
        }
        getCurrentLane().removeElement(getCurrentElement());
        upladeLaneData();
        
    }
    void deleteLane()
    {
        if (getCurrentLane() == null)
        {
            return;
        }
        lanePanel.remove(getCurrentLane());
        getLanes().remove(getCurrentLane());
        setCurrentLane(null);
        setCurrentElement(null);
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
        if (getCurrentAnimation() == null)
            return;
        if (getCurrentElement() == null)
            return;
        int maxLen = (int) getCurrentAnimation().getMaxAbsLenValue();
        if (maxLen == 0)
        {
            currentElement.factor = 1;
            jTextFieldFactor.setText(""+getCurrentElement().factor);
            return;
        }
        int factor = 127/maxLen;
        currentElement.factor = factor;
        jTextFieldFactor.setText(""+getCurrentElement().factor);
        
    }
    

    private void generateSource()
    {              
        StringBuilder text = new StringBuilder();
        HashMap<String, String> noDoubleAnimMap = new HashMap<String, String>();
        ArrayList<String> animData = new ArrayList<String>();

        HashMap<String, String> noDoubleRoutineMap = new HashMap<String, String>();
        ArrayList<String> routineData = new ArrayList<String>();
        
        ArrayList<String> laneInit = new ArrayList<String>();
        ArrayList<String> laneData = new ArrayList<String>();

        for (StoryboardLanePanel lane : getLanes())
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
               
        template = Paths.get(Global.mainPathPrefix, "template", "storyboardRoutines.template");
        String lane_subroutines = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

        template = Paths.get(Global.mainPathPrefix, "template", "storyboardRAM.template");
        String ram = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
        ram = de.malban.util.UtilityString.replace(ram, "#LANE_COUNT#", ""+getLanes().size());

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
        if (getCurrentLane() != null)
        {
            jTextFieldFrameCount2.setText(""+getCurrentLane().getLengthInRound());
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
        return 1;
    }
    public void deIconified() { }
}

