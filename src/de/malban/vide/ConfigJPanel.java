/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide;



import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;


import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.dialogs.ShowInfoDialog;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.input.ControllerEvent;
import de.malban.input.ControllerListern;
import de.malban.input.EventController;
import de.malban.input.SystemController;
import de.malban.sound.tinysound.TinySound;
import de.malban.util.DownloaderPanel;
import de.malban.util.KeyboardListener;
import static de.malban.vide.ControllerConfig.CONTROLLER_JOYSTICK;
import static de.malban.vide.ControllerConfig.CONTROLLER_NONE;
import static de.malban.vide.ControllerConfig.CONTROLLER_SPINNER;
import static de.malban.vide.ControllerConfig.controllerNames;
import static de.malban.vide.VideConfig.controllerConfigs;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.dissy.MemoryInformationTableModel;
import static de.malban.vide.vecx.VecXStatics.*;
import de.malban.vide.vecx.cartridge.SystemRom;
import de.malban.vide.vecx.cartridge.SystemRomPanel;
import de.malban.vide.vecx.cartridge.SystemRomPool;
import de.muntjak.tinylookandfeel.Theme;
import de.muntjak.tinylookandfeel.TinyLookAndFeel;
import java.io.File;
import java.io.Serializable;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.swing.JCheckBox;
import javax.swing.JToggleButton;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.filechooser.FileNameExtensionFilter;
import net.java.games.input.Component;
import net.java.games.input.Controller;
import net.java.games.input.ControllerEnvironment;


/**
 *
 * @author malban
 */
public class ConfigJPanel extends javax.swing.JPanel implements
        Windowable, Stateable, ControllerListern{
    public boolean isLoadSettings() { return true; }
    private CSAView mParent = null;
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    VideConfig config = VideConfig.getConfig();
    
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
        mParentMenuItem.setText("Registers");
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
    public ConfigJPanel() {
        initComponents();
        VideConfig.getConfig();
        loadSystemRoms(config.usedSystemRom);
        initValues();
        inputControllerDisplay1.addEventListerner(this);
    }
    
    private void initValues()
    {
        initControllers("");
        jTextField9.setText(""+config.minimumSpinnerChangeCycles);
        jTextField10.setText(""+config.jinputPolltime);
        
        
        jTextFieldstart.setText(""+config.startFile);
        jTextField11.setText(""+config.ALG_MAX_X);
        jTextField12.setText(""+config.ALG_MAX_Y);        
        
        jTextField7.setText(de.malban.util.UtilityFiles.convertSeperator(config.themeFile));
        jSliderXSH.setValue(config.delays[TIMER_XSH_CHANGE]);
        jSliderMuxR.setValue(config.delays[TIMER_MUX_R_CHANGE]);
        jSliderMuxY.setValue(config.delays[TIMER_MUX_Y_CHANGE]);
        jSliderMuxZ.setValue(config.delays[TIMER_MUX_Z_CHANGE]);
        jSliderMuxS.setValue(config.delays[TIMER_MUX_S_CHANGE]);
        jSliderBlank.setValue(config.delays[TIMER_BLANK_CHANGE]);
        jSliderZero.setValue((int)(config.blankOnDelay*10));
        jSliderMuxSel.setValue(config.delays[TIMER_MUX_SEL_CHANGE]);
        jSliderRealZero.setValue(config.delays[TIMER_ZERO]);

        jCheckBox43.setSelected(config.includeRelativeToParent);
        
        jComboBox3.setSelectedIndex(config.generation);

        
        jCheckBoxEfficiency.setSelected(config.efficiencyEnabled);
        jSliderEfficiency.setValue((int)config.efficiency);
        
        jCheckBoxNoise.setSelected(config.noise);
        jSliderNoise.setValue((int)(config.noisefactor*10));
        
        jCheckBoxOverflow.setSelected(config.emulateIntegrationOverflow);
        jSliderOverflow.setValue((int)(config.overflowFactor));
        
        
        int rampOn = config.delays[TIMER_RAMP_CHANGE]*10;
        int rampOff = config.delays[TIMER_RAMP_OFF_CHANGE]*10;
        
        rampOn+=config.rampOnFractionValue*10;
        rampOff+=config.rampOffFractionValue*10;
        
        jSliderRamp.setValue(rampOn);
        jSliderRampOff.setValue(rampOff);

        jSliderPSGVolume.setValue(config.psgVolume);

        
        jTextField3.setText(""+((double)jSliderRamp.getValue())/10);
        jTextField2.setText(""+((double)jSliderRampOff.getValue())/10);
        
        
        
        jSliderMultiStepDelay.setValue(config.multiStepDelay);
        jSliderBrightness.setValue(config.brightness);
        jCheckBoxGlow.setSelected(config.useGlow);        
        
        jCheckBox6.setSelected(config.vectorInformationCollectionActive);   
        
        jSliderMasterVolume.setValue(config.masterVolume);

        jSliderMuxY3.setValue(config.persistenceAlpha);
        jSliderMuxY4.setValue(config.lineWidth);
        jCheckBox10.setSelected(config.antialiazing);        

        jCheckBox5.setSelected(config.psgSound);

        jCheckBox8.setSelected(config.vectorsAsArrows);
        jCheckBox12.setSelected(config.cycleExactEmulation);
        
        jCheckBox7.setSelected(config.speedLimit);

        
        jCheckBox13.setSelected(config.expandBranches);
        jCheckBox14.setSelected(config.enableBankswitch);
        jCheckBox15.setSelected(config.opt);
        jCheckBox16.setSelected(config.outputLST);
        jCheckBox17.setSelected(config.invokeEmulatorAfterAssembly);

        jCheckBox18.setSelected(config.scanMacros);
        jCheckBox19.setSelected(config.scanVars);
        jCheckBox20.setSelected(config.assumeVectrex);
        jCheckBox21.setSelected(config.createUnkownLabels);
        
        jCheckBox22.setSelected(config.codeScanActive);
        jCheckBox23.setSelected(config.ringbufferActive);
        
        jCheckBox24.setSelected(config.paintIntegrators);
        jCheckBox25.setSelected(config.treatUndefinedAsZero);
        jCheckBox26.setSelected(config.useSplines);
        jCheckBox27.setSelected(config.supressDoubleDraw);
        jCheckBox11.setSelected(config.useQuads);
        
        jCheckBox44.setSelected(config.imagerAutoOnDefault);
        
        
        jCheckBoxScanForVectorLists.setSelected(config.scanForVectorLists);

        
        jCheckBox42.setSelected(config.resetBreakpointsOnLoad);


        jSliderXDrift.setValue((int)(config.drift_x*100));
        jSliderYDrift.setValue((int)(config.drift_y*100));        
        
        
        jTextField4.setText(""+(int) (config.warmup*100));
        jTextField5.setText(""+(int) (config.cooldown*100));
        
        jRadioButton2.setSelected(!config.lstFirst);
        jRadioButton1.setSelected(config.lstFirst);
        
        
        for (int i=0;i<MemoryInformationTableModel.columnVisibleALL.length; i++)
        {
            if (i==0)  jCheckBox28.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==1)  jCheckBox29.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==2)  jCheckBox30.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==3)  jCheckBox31.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==4)  jCheckBox32.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==5)  jCheckBox33.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==6)  jCheckBox34.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==7)  jCheckBox35.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==8)  jCheckBox36.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==9)  jCheckBox37.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==10) jCheckBox38.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==11) jCheckBox39.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            if (i==12) jCheckBox40.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
        }
        jCheckBox41.setSelected(config.useRayGun);
        jCheckBoxAutoSync.setSelected(config.autoSync);

        
        jCheckBox1.setSelected(config.overlayEnabled);
        
        jSliderSplineDensity.setValue(config.splineDensity);        
        File[] files = VideConfig.getConfigs();
        jComboBox1.removeAllItems();
        mClassSetting++;
        for (File f : files)
        {
           jComboBox1.addItem(f.getName());
        }
        if (config.loadedConfig.length()!=0)
        {
           jComboBox1.setSelectedItem(config.loadedConfig);
        }
        

        for (int i=0; i<jComboBox2.getItemCount(); i++)
        {
            SystemRom o = (SystemRom)jComboBox2.getItemAt(i);
            if (o.getCartName().toLowerCase().equals(config.usedSystemRom.toLowerCase()))
            {
                jComboBox2.setSelectedIndex(i);
                break;
            }
        }
        
        
        
        mClassSetting--;
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
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel20 = new javax.swing.JPanel();
        jCheckBox1 = new javax.swing.JCheckBox();
        jLabel1 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jCheckBox6 = new javax.swing.JCheckBox();
        jPanel26 = new javax.swing.JPanel();
        jSliderMuxY3 = new javax.swing.JSlider();
        jPanel27 = new javax.swing.JPanel();
        jSliderMuxY4 = new javax.swing.JSlider();
        jCheckBox10 = new javax.swing.JCheckBox();
        jCheckBox12 = new javax.swing.JCheckBox();
        jCheckBox14 = new javax.swing.JCheckBox();
        jCheckBox23 = new javax.swing.JCheckBox();
        jComboBox2 = new javax.swing.JComboBox();
        jLabel4 = new javax.swing.JLabel();
        jCheckBox26 = new javax.swing.JCheckBox();
        jCheckBox27 = new javax.swing.JCheckBox();
        jPanel30 = new javax.swing.JPanel();
        jSliderYDrift = new javax.swing.JSlider();
        jPanel31 = new javax.swing.JPanel();
        jSliderXDrift = new javax.swing.JSlider();
        jCheckBox41 = new javax.swing.JCheckBox();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jSliderSplineDensity = new javax.swing.JSlider();
        jCheckBox11 = new javax.swing.JCheckBox();
        jCheckBoxAutoSync = new javax.swing.JCheckBox();
        jPanel32 = new javax.swing.JPanel();
        jSliderBrightness = new javax.swing.JSlider();
        jCheckBoxGlow = new javax.swing.JCheckBox();
        jPanel33 = new javax.swing.JPanel();
        jSliderEfficiency = new javax.swing.JSlider();
        jCheckBoxEfficiency = new javax.swing.JCheckBox();
        jPanel34 = new javax.swing.JPanel();
        jSliderNoise = new javax.swing.JSlider();
        jCheckBoxNoise = new javax.swing.JCheckBox();
        jPanel35 = new javax.swing.JPanel();
        jSliderOverflow = new javax.swing.JSlider();
        jCheckBoxOverflow = new javax.swing.JCheckBox();
        jSliderMasterVolume = new javax.swing.JSlider();
        jLabel9 = new javax.swing.JLabel();
        jCheckBox5 = new javax.swing.JCheckBox();
        jLabel15 = new javax.swing.JLabel();
        jSliderPSGVolume = new javax.swing.JSlider();
        jCheckBox7 = new javax.swing.JCheckBox();
        jCheckBox44 = new javax.swing.JCheckBox();
        jLabel31 = new javax.swing.JLabel();
        jTextField11 = new javax.swing.JTextField();
        jTextField12 = new javax.swing.JTextField();
        jPanel19 = new javax.swing.JPanel();
        jPanel1 = new javax.swing.JPanel();
        jSliderXSH = new javax.swing.JSlider();
        jPanel2 = new javax.swing.JPanel();
        jSliderRamp = new javax.swing.JSlider();
        jPanel3 = new javax.swing.JPanel();
        jSliderBlank = new javax.swing.JSlider();
        jPanel4 = new javax.swing.JPanel();
        jSliderZero = new javax.swing.JSlider();
        jPanel5 = new javax.swing.JPanel();
        jSliderMuxR = new javax.swing.JSlider();
        jPanel16 = new javax.swing.JPanel();
        jSliderMuxZ = new javax.swing.JSlider();
        jPanel17 = new javax.swing.JPanel();
        jSliderMuxY = new javax.swing.JSlider();
        jPanel18 = new javax.swing.JPanel();
        jSliderMuxS = new javax.swing.JSlider();
        jPanel7 = new javax.swing.JPanel();
        jSliderRampOff = new javax.swing.JSlider();
        jLabel2 = new javax.swing.JLabel();
        jTextField2 = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jTextField3 = new javax.swing.JTextField();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jTextField4 = new javax.swing.JTextField();
        jTextField5 = new javax.swing.JTextField();
        jPanel11 = new javax.swing.JPanel();
        jSliderMuxSel = new javax.swing.JSlider();
        jPanel12 = new javax.swing.JPanel();
        jSliderRealZero = new javax.swing.JSlider();
        jLabel8 = new javax.swing.JLabel();
        jComboBox3 = new javax.swing.JComboBox();
        jPanel21 = new javax.swing.JPanel();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox3 = new javax.swing.JCheckBox();
        jCheckBox4 = new javax.swing.JCheckBox();
        jCheckBox20 = new javax.swing.JCheckBox();
        jCheckBox21 = new javax.swing.JCheckBox();
        jCheckBox22 = new javax.swing.JCheckBox();
        jTabbedPane2 = new javax.swing.JTabbedPane();
        jPanel10 = new javax.swing.JPanel();
        jCheckBox28 = new javax.swing.JCheckBox();
        jCheckBox29 = new javax.swing.JCheckBox();
        jCheckBox30 = new javax.swing.JCheckBox();
        jCheckBox31 = new javax.swing.JCheckBox();
        jCheckBox32 = new javax.swing.JCheckBox();
        jCheckBox33 = new javax.swing.JCheckBox();
        jCheckBox34 = new javax.swing.JCheckBox();
        jCheckBox35 = new javax.swing.JCheckBox();
        jCheckBox36 = new javax.swing.JCheckBox();
        jCheckBox37 = new javax.swing.JCheckBox();
        jCheckBox38 = new javax.swing.JCheckBox();
        jCheckBox39 = new javax.swing.JCheckBox();
        jCheckBox40 = new javax.swing.JCheckBox();
        jPanel13 = new javax.swing.JPanel();
        jRadioButton1 = new javax.swing.JRadioButton();
        jRadioButton2 = new javax.swing.JRadioButton();
        jPanel22 = new javax.swing.JPanel();
        jCheckBox8 = new javax.swing.JCheckBox();
        jCheckBox9 = new javax.swing.JCheckBox();
        jCheckBox24 = new javax.swing.JCheckBox();
        jPanel9 = new javax.swing.JPanel();
        jSliderMultiStepDelay = new javax.swing.JSlider();
        jCheckBox42 = new javax.swing.JCheckBox();
        jPanel6 = new javax.swing.JPanel();
        jCheckBox13 = new javax.swing.JCheckBox();
        jCheckBox15 = new javax.swing.JCheckBox();
        jCheckBox16 = new javax.swing.JCheckBox();
        jCheckBox25 = new javax.swing.JCheckBox();
        jCheckBox43 = new javax.swing.JCheckBox();
        jPanel8 = new javax.swing.JPanel();
        jCheckBox17 = new javax.swing.JCheckBox();
        jCheckBox18 = new javax.swing.JCheckBox();
        jCheckBox19 = new javax.swing.JCheckBox();
        jButton4 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jCheckBoxScanForVectorLists = new javax.swing.JCheckBox();
        jLabel32 = new javax.swing.JLabel();
        jButtonFileSelect1 = new javax.swing.JButton();
        jTextFieldstart = new javax.swing.JTextField();
        jPanel14 = new javax.swing.JPanel();
        jTabbedPane3 = new javax.swing.JTabbedPane();
        keyBindingsJPanel1 = new de.malban.vide.vedi.project.KeyBindingsJPanel();
        jPanel15 = new javax.swing.JPanel();
        jLabel10 = new javax.swing.JLabel();
        jTextField7 = new javax.swing.JTextField();
        jButtonLoad = new javax.swing.JButton();
        jLabel11 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jLabel14 = new javax.swing.JLabel();
        styleJPanel1 = new de.malban.util.syntax.Syntax.StyleJPanel();
        jPanel23 = new javax.swing.JPanel();
        jLabel16 = new javax.swing.JLabel();
        jComboBox4 = new javax.swing.JComboBox();
        jPanel24 = new javax.swing.JPanel();
        jLabel22 = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        jToggleButton1 = new javax.swing.JToggleButton();
        jToggleButton2 = new javax.swing.JToggleButton();
        jLabel18 = new javax.swing.JLabel();
        jToggleButton3 = new javax.swing.JToggleButton();
        jLabel19 = new javax.swing.JLabel();
        jToggleButton4 = new javax.swing.JToggleButton();
        jLabel20 = new javax.swing.JLabel();
        jToggleButton5 = new javax.swing.JToggleButton();
        jToggleButton6 = new javax.swing.JToggleButton();
        jLabel23 = new javax.swing.JLabel();
        jToggleButton7 = new javax.swing.JToggleButton();
        jToggleButton8 = new javax.swing.JToggleButton();
        jLabel24 = new javax.swing.JLabel();
        jToggleButton9 = new javax.swing.JToggleButton();
        jLabel25 = new javax.swing.JLabel();
        jToggleButton10 = new javax.swing.JToggleButton();
        jLabel27 = new javax.swing.JLabel();
        jLabel28 = new javax.swing.JLabel();
        inputControllerDisplay1 = new de.malban.input.InputControllerDisplay();
        jLabel21 = new javax.swing.JLabel();
        jTextField8 = new javax.swing.JTextField();
        jLabel26 = new javax.swing.JLabel();
        jComboBoxJoystickConfigurations = new javax.swing.JComboBox();
        jButtonSave = new javax.swing.JButton();
        jButtonDelete1 = new javax.swing.JButton();
        jButtonNew = new javax.swing.JButton();
        jLabel29 = new javax.swing.JLabel();
        jTextField9 = new javax.swing.JTextField();
        jLabel30 = new javax.swing.JLabel();
        jTextField10 = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        jTextField6 = new javax.swing.JTextField();
        jButton3 = new javax.swing.JButton();
        jComboBox1 = new javax.swing.JComboBox();

        setName("regi"); // NOI18N

        jCheckBox1.setSelected(true);
        jCheckBox1.setText("load overlays when available");
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jLabel1.setText("rollback buffer");
        jLabel1.setEnabled(false);

        jTextField1.setText("2000");
        jTextField1.setEnabled(false);

        jCheckBox6.setSelected(true);
        jCheckBox6.setText("vector information collection active");
        jCheckBox6.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jCheckBox6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox6ActionPerformed(evt);
            }
        });

        jPanel26.setBorder(javax.swing.BorderFactory.createTitledBorder("Persistence"));

        jSliderMuxY3.setMajorTickSpacing(50);
        jSliderMuxY3.setMaximum(255);
        jSliderMuxY3.setMinorTickSpacing(10);
        jSliderMuxY3.setPaintTicks(true);
        jSliderMuxY3.setValue(0);
        jSliderMuxY3.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderMuxY3StateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel26Layout = new javax.swing.GroupLayout(jPanel26);
        jPanel26.setLayout(jPanel26Layout);
        jPanel26Layout.setHorizontalGroup(
            jPanel26Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxY3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel26Layout.setVerticalGroup(
            jPanel26Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel26Layout.createSequentialGroup()
                .addComponent(jSliderMuxY3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 2, Short.MAX_VALUE))
        );

        jPanel27.setBorder(javax.swing.BorderFactory.createTitledBorder("Line width"));

        jSliderMuxY4.setMajorTickSpacing(1);
        jSliderMuxY4.setMaximum(10);
        jSliderMuxY4.setMinimum(1);
        jSliderMuxY4.setMinorTickSpacing(1);
        jSliderMuxY4.setPaintLabels(true);
        jSliderMuxY4.setPaintTicks(true);
        jSliderMuxY4.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderMuxY4StateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel27Layout = new javax.swing.GroupLayout(jPanel27);
        jPanel27.setLayout(jPanel27Layout);
        jPanel27Layout.setHorizontalGroup(
            jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxY4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel27Layout.setVerticalGroup(
            jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxY4, javax.swing.GroupLayout.PREFERRED_SIZE, 45, Short.MAX_VALUE)
        );

        jCheckBox10.setText("Antialiazing");
        jCheckBox10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox10ActionPerformed(evt);
            }
        });

        jCheckBox12.setText("Cycle exact emulation");
        jCheckBox12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox12ActionPerformed(evt);
            }
        });

        jCheckBox14.setSelected(true);
        jCheckBox14.setText("enable Bankswitching");
        jCheckBox14.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox14ActionPerformed(evt);
            }
        });

        jCheckBox23.setText("ringbuffer active");
        jCheckBox23.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox23ActionPerformed(evt);
            }
        });

        jComboBox2.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBox2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox2ActionPerformed(evt);
            }
        });

        jLabel4.setText("Boot rom");

        jCheckBox26.setText("use splines for curved vectors");
        jCheckBox26.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox26ActionPerformed(evt);
            }
        });

        jCheckBox27.setText("suppress double draw on line sections");
        jCheckBox27.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox27ActionPerformed(evt);
            }
        });

        jPanel30.setBorder(javax.swing.BorderFactory.createTitledBorder("drift y"));

        jSliderYDrift.setMajorTickSpacing(10);
        jSliderYDrift.setMinimum(-100);
        jSliderYDrift.setMinorTickSpacing(1);
        jSliderYDrift.setPaintTicks(true);
        jSliderYDrift.setValue(0);
        jSliderYDrift.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderYDriftStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel30Layout = new javax.swing.GroupLayout(jPanel30);
        jPanel30.setLayout(jPanel30Layout);
        jPanel30Layout.setHorizontalGroup(
            jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderYDrift, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel30Layout.setVerticalGroup(
            jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderYDrift, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jPanel31.setBorder(javax.swing.BorderFactory.createTitledBorder("drift x"));

        jSliderXDrift.setMajorTickSpacing(10);
        jSliderXDrift.setMinimum(-100);
        jSliderXDrift.setMinorTickSpacing(1);
        jSliderXDrift.setPaintTicks(true);
        jSliderXDrift.setValue(0);
        jSliderXDrift.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderXDriftStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel31Layout = new javax.swing.GroupLayout(jPanel31);
        jPanel31.setLayout(jPanel31Layout);
        jPanel31Layout.setHorizontalGroup(
            jPanel31Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderXDrift, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel31Layout.setVerticalGroup(
            jPanel31Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderXDrift, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jCheckBox41.setText("Ray Gun");
        jCheckBox41.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox41ActionPerformed(evt);
            }
        });

        jButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/cog.png"))); // NOI18N
        jButton1.setToolTipText("configure system roms");
        jButton1.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton1.setPreferredSize(new java.awt.Dimension(37, 19));
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/wand.png"))); // NOI18N
        jButton2.setToolTipText("refresh (after configuration)");
        jButton2.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton2.setPreferredSize(new java.awt.Dimension(37, 20));
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jSliderSplineDensity.setMajorTickSpacing(1);
        jSliderSplineDensity.setMaximum(20);
        jSliderSplineDensity.setMinimum(1);
        jSliderSplineDensity.setMinorTickSpacing(1);
        jSliderSplineDensity.setPaintTicks(true);
        jSliderSplineDensity.setToolTipText("This is in respect to distance of two points, the minum number of control points for a slope between two points is one, regardless of these settings!");
        jSliderSplineDensity.setValue(4);
        jSliderSplineDensity.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderSplineDensityStateChanged(evt);
            }
        });

        jCheckBox11.setText("use Quads");
        jCheckBox11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox11ActionPerformed(evt);
            }
        });

        jCheckBoxAutoSync.setText("Try autoSync");
        jCheckBoxAutoSync.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxAutoSyncActionPerformed(evt);
            }
        });

        jPanel32.setBorder(javax.swing.BorderFactory.createTitledBorder("brighness"));

        jSliderBrightness.setMajorTickSpacing(10);
        jSliderBrightness.setMinimum(-100);
        jSliderBrightness.setMinorTickSpacing(1);
        jSliderBrightness.setPaintTicks(true);
        jSliderBrightness.setValue(0);
        jSliderBrightness.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderBrightnessStateChanged(evt);
            }
        });

        jCheckBoxGlow.setText("do glow");
        jCheckBoxGlow.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxGlowActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel32Layout = new javax.swing.GroupLayout(jPanel32);
        jPanel32.setLayout(jPanel32Layout);
        jPanel32Layout.setHorizontalGroup(
            jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel32Layout.createSequentialGroup()
                .addComponent(jCheckBoxGlow)
                .addGap(60, 60, 60)
                .addComponent(jSliderBrightness, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel32Layout.setVerticalGroup(
            jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderBrightness, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addComponent(jCheckBoxGlow)
        );

        jPanel33.setBorder(javax.swing.BorderFactory.createTitledBorder("efficiency value"));

        jSliderEfficiency.setMajorTickSpacing(10);
        jSliderEfficiency.setMaximum(50);
        jSliderEfficiency.setMinimum(1);
        jSliderEfficiency.setMinorTickSpacing(1);
        jSliderEfficiency.setPaintTicks(true);
        jSliderEfficiency.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderEfficiencyStateChanged(evt);
            }
        });

        jCheckBoxEfficiency.setText("efficiency");
        jCheckBoxEfficiency.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxEfficiencyActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel33Layout = new javax.swing.GroupLayout(jPanel33);
        jPanel33.setLayout(jPanel33Layout);
        jPanel33Layout.setHorizontalGroup(
            jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel33Layout.createSequentialGroup()
                .addComponent(jCheckBoxEfficiency)
                .addGap(54, 54, 54)
                .addComponent(jSliderEfficiency, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel33Layout.setVerticalGroup(
            jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel33Layout.createSequentialGroup()
                .addComponent(jSliderEfficiency, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
            .addGroup(jPanel33Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jCheckBoxEfficiency)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jPanel34.setBorder(javax.swing.BorderFactory.createTitledBorder("noise factor"));

        jSliderNoise.setMajorTickSpacing(10);
        jSliderNoise.setMaximum(40);
        jSliderNoise.setMinorTickSpacing(1);
        jSliderNoise.setPaintTicks(true);
        jSliderNoise.setValue(10);
        jSliderNoise.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderNoiseStateChanged(evt);
            }
        });

        jCheckBoxNoise.setText("noise");
        jCheckBoxNoise.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxNoiseActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel34Layout = new javax.swing.GroupLayout(jPanel34);
        jPanel34.setLayout(jPanel34Layout);
        jPanel34Layout.setHorizontalGroup(
            jPanel34Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel34Layout.createSequentialGroup()
                .addComponent(jCheckBoxNoise)
                .addGap(76, 76, 76)
                .addComponent(jSliderNoise, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel34Layout.setVerticalGroup(
            jPanel34Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel34Layout.createSequentialGroup()
                .addComponent(jSliderNoise, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
            .addGroup(jPanel34Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jCheckBoxNoise)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jPanel35.setBorder(javax.swing.BorderFactory.createTitledBorder("overflow factor"));

        jSliderOverflow.setMajorTickSpacing(50);
        jSliderOverflow.setMaximum(300);
        jSliderOverflow.setMinimum(1);
        jSliderOverflow.setMinorTickSpacing(10);
        jSliderOverflow.setPaintTicks(true);
        jSliderOverflow.setValue(10);
        jSliderOverflow.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderOverflowStateChanged(evt);
            }
        });

        jCheckBoxOverflow.setText("overflow");
        jCheckBoxOverflow.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxOverflowActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel35Layout = new javax.swing.GroupLayout(jPanel35);
        jPanel35.setLayout(jPanel35Layout);
        jPanel35Layout.setHorizontalGroup(
            jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel35Layout.createSequentialGroup()
                .addComponent(jCheckBoxOverflow)
                .addGap(58, 58, 58)
                .addComponent(jSliderOverflow, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel35Layout.setVerticalGroup(
            jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel35Layout.createSequentialGroup()
                .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jSliderOverflow, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxOverflow))
                .addGap(0, 0, Short.MAX_VALUE))
        );

        jSliderMasterVolume.setMajorTickSpacing(10);
        jSliderMasterVolume.setMaximum(255);
        jSliderMasterVolume.setMinorTickSpacing(5);
        jSliderMasterVolume.setPaintTicks(true);
        jSliderMasterVolume.setToolTipText("This is in respect to distance of two points, the minum number of control points for a slope between two points is one, regardless of these settings!");
        jSliderMasterVolume.setValue(255);
        jSliderMasterVolume.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderMasterVolumeStateChanged(evt);
            }
        });

        jLabel9.setText("Master volume:");

        jCheckBox5.setSelected(true);
        jCheckBox5.setText("PSG Sound");
        jCheckBox5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox5ActionPerformed(evt);
            }
        });

        jLabel15.setText("PSG volume:");

        jSliderPSGVolume.setMajorTickSpacing(10);
        jSliderPSGVolume.setMaximum(255);
        jSliderPSGVolume.setMinorTickSpacing(5);
        jSliderPSGVolume.setPaintTicks(true);
        jSliderPSGVolume.setToolTipText("This is in respect to distance of two points, the minum number of control points for a slope between two points is one, regardless of these settings!");
        jSliderPSGVolume.setValue(255);
        jSliderPSGVolume.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderPSGVolumeStateChanged(evt);
            }
        });

        jCheckBox7.setSelected(true);
        jCheckBox7.setText("Speed limit 100%");
        jCheckBox7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox7ActionPerformed(evt);
            }
        });

        jCheckBox44.setText("imager auto mode on default");
        jCheckBox44.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox44ActionPerformed(evt);
            }
        });

        jLabel31.setText("emulated vectrex integrator max (w/h)");

        jTextField11.setText("38000");
        jTextField11.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField11FocusLost(evt);
            }
        });
        jTextField11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField11ActionPerformed(evt);
            }
        });

        jTextField12.setText("41000");
        jTextField12.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField12FocusLost(evt);
            }
        });
        jTextField12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField12ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel20Layout = new javax.swing.GroupLayout(jPanel20);
        jPanel20.setLayout(jPanel20Layout);
        jPanel20Layout.setHorizontalGroup(
            jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel27, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel26, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel30, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel31, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel32, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel33, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel34, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel35, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel20Layout.createSequentialGroup()
                .addGap(15, 15, 15)
                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel20Layout.createSequentialGroup()
                        .addComponent(jLabel4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jComboBox2, javax.swing.GroupLayout.PREFERRED_SIZE, 126, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jCheckBox44)
                    .addGroup(jPanel20Layout.createSequentialGroup()
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox26)
                            .addComponent(jCheckBox10))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxAutoSync)
                            .addComponent(jCheckBox11)))
                    .addComponent(jCheckBox41)
                    .addComponent(jCheckBox1)
                    .addComponent(jCheckBox14)
                    .addComponent(jCheckBox12)
                    .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 47, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jCheckBox6))
                    .addGroup(jPanel20Layout.createSequentialGroup()
                        .addGap(219, 219, 219)
                        .addComponent(jLabel1))
                    .addComponent(jCheckBox27)
                    .addComponent(jCheckBox23)
                    .addGroup(jPanel20Layout.createSequentialGroup()
                        .addComponent(jLabel31, javax.swing.GroupLayout.PREFERRED_SIZE, 229, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(1, 1, 1)
                        .addComponent(jTextField11, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jTextField12, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel9)
                            .addComponent(jCheckBox5)
                            .addComponent(jSliderMasterVolume, javax.swing.GroupLayout.PREFERRED_SIZE, 174, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel15)
                            .addComponent(jSliderPSGVolume, javax.swing.GroupLayout.PREFERRED_SIZE, 174, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel20Layout.createSequentialGroup()
                            .addComponent(jCheckBox7)
                            .addGap(57, 57, 57)))
                    .addComponent(jSliderSplineDensity, javax.swing.GroupLayout.PREFERRED_SIZE, 174, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(45, 45, 45))
        );
        jPanel20Layout.setVerticalGroup(
            jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel20Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel4)
                    .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jComboBox2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addComponent(jCheckBox5))
                .addGap(0, 0, 0)
                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel20Layout.createSequentialGroup()
                        .addComponent(jLabel9)
                        .addGap(0, 0, 0)
                        .addComponent(jSliderMasterVolume, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel15)
                        .addGap(0, 0, 0)
                        .addComponent(jSliderPSGVolume, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jSliderSplineDensity, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel20Layout.createSequentialGroup()
                        .addComponent(jCheckBox1)
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBox6)
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBox41)
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBox12)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox14)
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBox23)
                            .addComponent(jLabel1)
                            .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 0, 0)
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox11)
                            .addComponent(jCheckBox26))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox27)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBox10)
                            .addComponent(jCheckBoxAutoSync))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox44)
                        .addGap(0, 0, 0)
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBox7)
                            .addComponent(jLabel31)
                            .addComponent(jTextField11, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField12, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(18, 18, 18)
                .addComponent(jPanel27, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(3, 3, 3)
                .addComponent(jPanel26, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel31, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel30, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel32, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel33, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel34, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel35, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(146, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Emulator", jPanel20);

        jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder("XSH"));

        jSliderXSH.setMajorTickSpacing(10);
        jSliderXSH.setMaximum(40);
        jSliderXSH.setMinorTickSpacing(1);
        jSliderXSH.setPaintLabels(true);
        jSliderXSH.setPaintTicks(true);
        jSliderXSH.setValue(0);
        jSliderXSH.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderXSHStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderXSH, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderXSH, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder("Ramp On Delay"));

        jSliderRamp.setMajorTickSpacing(10);
        jSliderRamp.setMaximum(200);
        jSliderRamp.setMinorTickSpacing(1);
        jSliderRamp.setPaintTicks(true);
        jSliderRamp.setValue(0);
        jSliderRamp.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderRampStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderRamp, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderRamp, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder("Blank Delay"));

        jSliderBlank.setMajorTickSpacing(10);
        jSliderBlank.setMinorTickSpacing(1);
        jSliderBlank.setPaintLabels(true);
        jSliderBlank.setPaintTicks(true);
        jSliderBlank.setValue(0);
        jSliderBlank.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderBlankStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderBlank, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addComponent(jSliderBlank, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        jPanel4.setBorder(javax.swing.BorderFactory.createTitledBorder("Blank On Delay / 10"));

        jSliderZero.setMajorTickSpacing(10);
        jSliderZero.setMaximum(40);
        jSliderZero.setMinorTickSpacing(1);
        jSliderZero.setPaintLabels(true);
        jSliderZero.setPaintTicks(true);
        jSliderZero.setValue(0);
        jSliderZero.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderZeroStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderZero, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel4Layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addComponent(jSliderZero, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        jPanel5.setBorder(javax.swing.BorderFactory.createTitledBorder("RSH"));

        jSliderMuxR.setMajorTickSpacing(10);
        jSliderMuxR.setMaximum(40);
        jSliderMuxR.setMinorTickSpacing(1);
        jSliderMuxR.setPaintLabels(true);
        jSliderMuxR.setPaintTicks(true);
        jSliderMuxR.setValue(0);
        jSliderMuxR.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderMuxRStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxR, javax.swing.GroupLayout.DEFAULT_SIZE, 597, Short.MAX_VALUE)
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxR, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jPanel16.setBorder(javax.swing.BorderFactory.createTitledBorder("ZSH"));

        jSliderMuxZ.setMajorTickSpacing(10);
        jSliderMuxZ.setMaximum(40);
        jSliderMuxZ.setMinorTickSpacing(1);
        jSliderMuxZ.setPaintLabels(true);
        jSliderMuxZ.setPaintTicks(true);
        jSliderMuxZ.setValue(0);
        jSliderMuxZ.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderMuxZStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel16Layout = new javax.swing.GroupLayout(jPanel16);
        jPanel16.setLayout(jPanel16Layout);
        jPanel16Layout.setHorizontalGroup(
            jPanel16Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxZ, javax.swing.GroupLayout.DEFAULT_SIZE, 597, Short.MAX_VALUE)
        );
        jPanel16Layout.setVerticalGroup(
            jPanel16Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxZ, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jPanel17.setBorder(javax.swing.BorderFactory.createTitledBorder("YSH"));

        jSliderMuxY.setMajorTickSpacing(10);
        jSliderMuxY.setMaximum(40);
        jSliderMuxY.setMinorTickSpacing(1);
        jSliderMuxY.setPaintLabels(true);
        jSliderMuxY.setPaintTicks(true);
        jSliderMuxY.setValue(0);
        jSliderMuxY.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderMuxYStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel17Layout = new javax.swing.GroupLayout(jPanel17);
        jPanel17.setLayout(jPanel17Layout);
        jPanel17Layout.setHorizontalGroup(
            jPanel17Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxY, javax.swing.GroupLayout.DEFAULT_SIZE, 597, Short.MAX_VALUE)
        );
        jPanel17Layout.setVerticalGroup(
            jPanel17Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxY, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jPanel18.setBorder(javax.swing.BorderFactory.createTitledBorder("SSH"));

        jSliderMuxS.setMajorTickSpacing(10);
        jSliderMuxS.setMaximum(40);
        jSliderMuxS.setMinorTickSpacing(1);
        jSliderMuxS.setPaintLabels(true);
        jSliderMuxS.setPaintTicks(true);
        jSliderMuxS.setValue(0);
        jSliderMuxS.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderMuxSStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel18Layout = new javax.swing.GroupLayout(jPanel18);
        jPanel18.setLayout(jPanel18Layout);
        jPanel18Layout.setHorizontalGroup(
            jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxS, javax.swing.GroupLayout.DEFAULT_SIZE, 597, Short.MAX_VALUE)
        );
        jPanel18Layout.setVerticalGroup(
            jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxS, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jPanel7.setBorder(javax.swing.BorderFactory.createTitledBorder("Ramp Off Delay"));

        jSliderRampOff.setMajorTickSpacing(10);
        jSliderRampOff.setMaximum(200);
        jSliderRampOff.setMinorTickSpacing(1);
        jSliderRampOff.setPaintTicks(true);
        jSliderRampOff.setValue(0);
        jSliderRampOff.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderRampOffStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel7Layout = new javax.swing.GroupLayout(jPanel7);
        jPanel7.setLayout(jPanel7Layout);
        jPanel7Layout.setHorizontalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderRampOff, javax.swing.GroupLayout.DEFAULT_SIZE, 597, Short.MAX_VALUE)
        );
        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderRampOff, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jLabel2.setText("Ramp off delay");
        jLabel2.setEnabled(false);

        jTextField2.setText("80");
        jTextField2.setEnabled(false);

        jLabel5.setText("Ramp on delay");
        jLabel5.setEnabled(false);

        jTextField3.setText("80");
        jTextField3.setEnabled(false);

        jLabel6.setText("Integrator Cool down");

        jLabel7.setText("Integrator Warmup");

        jTextField4.setText("80");
        jTextField4.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField4FocusLost(evt);
            }
        });
        jTextField4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField4ActionPerformed(evt);
            }
        });
        jTextField4.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextField4PropertyChange(evt);
            }
        });
        jTextField4.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField4KeyTyped(evt);
            }
        });

        jTextField5.setText("80");
        jTextField5.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField5FocusLost(evt);
            }
        });
        jTextField5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField5ActionPerformed(evt);
            }
        });
        jTextField5.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextField5PropertyChange(evt);
            }
        });
        jTextField5.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField5KeyTyped(evt);
            }
        });

        jPanel11.setBorder(javax.swing.BorderFactory.createTitledBorder("MUX-SEL"));

        jSliderMuxSel.setMajorTickSpacing(10);
        jSliderMuxSel.setMaximum(40);
        jSliderMuxSel.setMinorTickSpacing(1);
        jSliderMuxSel.setPaintLabels(true);
        jSliderMuxSel.setPaintTicks(true);
        jSliderMuxSel.setValue(0);
        jSliderMuxSel.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderMuxSelStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel11Layout = new javax.swing.GroupLayout(jPanel11);
        jPanel11.setLayout(jPanel11Layout);
        jPanel11Layout.setHorizontalGroup(
            jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxSel, javax.swing.GroupLayout.DEFAULT_SIZE, 597, Short.MAX_VALUE)
        );
        jPanel11Layout.setVerticalGroup(
            jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxSel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jPanel12.setBorder(javax.swing.BorderFactory.createTitledBorder("Zero"));

        jSliderRealZero.setMajorTickSpacing(10);
        jSliderRealZero.setMaximum(40);
        jSliderRealZero.setMinorTickSpacing(1);
        jSliderRealZero.setPaintLabels(true);
        jSliderRealZero.setPaintTicks(true);
        jSliderRealZero.setValue(0);
        jSliderRealZero.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderRealZeroStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel12Layout = new javax.swing.GroupLayout(jPanel12);
        jPanel12.setLayout(jPanel12Layout);
        jPanel12Layout.setHorizontalGroup(
            jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderRealZero, javax.swing.GroupLayout.DEFAULT_SIZE, 597, Short.MAX_VALUE)
        );
        jPanel12Layout.setVerticalGroup(
            jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel12Layout.createSequentialGroup()
                .addComponent(jSliderRealZero, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        jLabel8.setText("vectrex generation");

        jComboBox3.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Off", "1", "2", "3" }));
        jComboBox3.setToolTipText("<html>\nDifferent vectrex models seem to have diffferent DAC - with different delay values.<BR>\nThese setttings are experimental and not calculable, I only have vectrex generation 2+3 at hand!<BR>\nDifferences may usually be seen when DAC changes are done while Ramp is enabled!\n</html>\n");
        jComboBox3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox3ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel19Layout = new javax.swing.GroupLayout(jPanel19);
        jPanel19.setLayout(jPanel19Layout);
        jPanel19Layout.setHorizontalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel7, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel3, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel16, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel17, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel18, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel19Layout.createSequentialGroup()
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel5)
                    .addComponent(jLabel2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel7)
                    .addComponent(jLabel6))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel8)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jComboBox3, javax.swing.GroupLayout.PREFERRED_SIZE, 57, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(0, 118, Short.MAX_VALUE))
            .addComponent(jPanel11, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel12, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel19Layout.setVerticalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel19Layout.createSequentialGroup()
                .addComponent(jPanel11, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel12, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel17, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel18, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel16, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(4, 4, 4)
                .addComponent(jPanel7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel5)
                            .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(8, 8, 8)
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel2)
                            .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jComboBox3, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel7)
                                .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel8)))
                        .addGap(8, 8, 8)
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel6)
                            .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Delays", jPanel19);

        jCheckBox2.setSelected(true);
        jCheckBox2.setText("scan for *.CNT file on load");
        jCheckBox2.setEnabled(false);
        jCheckBox2.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jCheckBox2.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);

        jCheckBox3.setSelected(true);
        jCheckBox3.setText("scan for *.LST file on load");
        jCheckBox3.setEnabled(false);
        jCheckBox3.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jCheckBox3.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);

        jCheckBox4.setSelected(true);
        jCheckBox4.setText("load BIOS disassembly upon start");
        jCheckBox4.setEnabled(false);
        jCheckBox4.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jCheckBox4.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);

        jCheckBox20.setSelected(true);
        jCheckBox20.setText("assume vectrex files");
        jCheckBox20.setToolTipText("<html>\n<pre>\nIf defined the current file and all found includes (recursively) are scanned\nfor macro definitions. \nSyntax highlighting is than enabled for \"undefined\" macros (red).\nDefined macros are dark blue.\n(if switched off, all macros are dark green, as variables)\n</pre>\n</html>\n\n");
        jCheckBox20.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox20ActionPerformed(evt);
            }
        });

        jCheckBox21.setSelected(true);
        jCheckBox21.setText("build generic labels");
        jCheckBox21.setToolTipText("<html>\n<pre>\nIf defined the current file and all found includes (recursively) are scanned\nfor variable (label, equ, =) definitions. \nSyntax highlighting is than enabled for \"undefined\" variables (red).\nDefined variables are dark green.\n</pre>\n</html>\n\n");
        jCheckBox21.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox21ActionPerformed(evt);
            }
        });

        jCheckBox22.setText("codescan in Vecxi");
        jCheckBox22.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox22ActionPerformed(evt);
            }
        });

        jCheckBox28.setText("Address");
        jCheckBox28.setName("0"); // NOI18N
        jCheckBox28.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox39ActionPerformed(evt);
            }
        });

        jCheckBox29.setText("Label");
        jCheckBox29.setName("1"); // NOI18N
        jCheckBox29.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox39ActionPerformed(evt);
            }
        });

        jCheckBox30.setText("Content");
        jCheckBox30.setName("2"); // NOI18N
        jCheckBox30.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox39ActionPerformed(evt);
            }
        });

        jCheckBox31.setText("Mnemonic");
        jCheckBox31.setName("3"); // NOI18N
        jCheckBox31.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox39ActionPerformed(evt);
            }
        });

        jCheckBox32.setText("Operand");
        jCheckBox32.setName("4"); // NOI18N
        jCheckBox32.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox32ActionPerformed(evt);
            }
        });

        jCheckBox33.setText("Page");
        jCheckBox33.setName("5"); // NOI18N
        jCheckBox33.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox33ActionPerformed(evt);
            }
        });

        jCheckBox34.setText("Cycles");
        jCheckBox34.setName("6"); // NOI18N
        jCheckBox34.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox34ActionPerformed(evt);
            }
        });

        jCheckBox35.setText("Mode");
        jCheckBox35.setName("7"); // NOI18N
        jCheckBox35.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox35ActionPerformed(evt);
            }
        });

        jCheckBox36.setText("->Address");
        jCheckBox36.setName("8"); // NOI18N
        jCheckBox36.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox36ActionPerformed(evt);
            }
        });

        jCheckBox37.setText("Type");
        jCheckBox37.setName("9"); // NOI18N
        jCheckBox37.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox37ActionPerformed(evt);
            }
        });

        jCheckBox38.setText("Length");
        jCheckBox38.setName("10"); // NOI18N
        jCheckBox38.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox38ActionPerformed(evt);
            }
        });

        jCheckBox39.setText("Comments");
        jCheckBox39.setName("11"); // NOI18N
        jCheckBox39.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox39ActionPerformed(evt);
            }
        });

        jCheckBox40.setText("DP");
        jCheckBox40.setName("12"); // NOI18N
        jCheckBox40.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox40ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel10Layout = new javax.swing.GroupLayout(jPanel10);
        jPanel10.setLayout(jPanel10Layout);
        jPanel10Layout.setHorizontalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox28)
                    .addComponent(jCheckBox29)
                    .addComponent(jCheckBox30)
                    .addComponent(jCheckBox31)
                    .addComponent(jCheckBox32)
                    .addComponent(jCheckBox33)
                    .addComponent(jCheckBox34)
                    .addComponent(jCheckBox35)
                    .addComponent(jCheckBox36)
                    .addComponent(jCheckBox37)
                    .addComponent(jCheckBox38)
                    .addComponent(jCheckBox39)
                    .addComponent(jCheckBox40))
                .addContainerGap(515, Short.MAX_VALUE))
        );
        jPanel10Layout.setVerticalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addGap(17, 17, 17)
                .addComponent(jCheckBox28)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox29)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox30)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox31)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox32)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox33)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox34)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox35)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox36)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox37)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox38)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox39)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox40)
                .addContainerGap(204, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("ColumnSetup", jPanel10);

        jPanel13.setBorder(javax.swing.BorderFactory.createTitledBorder("Information precedence"));

        buttonGroup1.add(jRadioButton1);
        jRadioButton1.setText("if available load *.LST only");
        jRadioButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton1ActionPerformed(evt);
            }
        });

        buttonGroup1.add(jRadioButton2);
        jRadioButton2.setText("if available load *.CNT only");
        jRadioButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton2ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel13Layout = new javax.swing.GroupLayout(jPanel13);
        jPanel13.setLayout(jPanel13Layout);
        jPanel13Layout.setHorizontalGroup(
            jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel13Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jRadioButton1)
                    .addComponent(jRadioButton2))
                .addContainerGap(110, Short.MAX_VALUE))
        );
        jPanel13Layout.setVerticalGroup(
            jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel13Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jRadioButton1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jRadioButton2)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel21Layout = new javax.swing.GroupLayout(jPanel21);
        jPanel21.setLayout(jPanel21Layout);
        jPanel21Layout.setHorizontalGroup(
            jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel21Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel21Layout.createSequentialGroup()
                        .addComponent(jCheckBox22)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(jPanel21Layout.createSequentialGroup()
                        .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox2)
                            .addComponent(jCheckBox3)
                            .addComponent(jCheckBox4)
                            .addComponent(jCheckBox20)
                            .addComponent(jCheckBox21))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jPanel13, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
            .addComponent(jTabbedPane2)
        );
        jPanel21Layout.setVerticalGroup(
            jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel21Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel21Layout.createSequentialGroup()
                        .addComponent(jCheckBox2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox4)
                        .addGap(18, 18, 18)
                        .addComponent(jCheckBox20))
                    .addComponent(jPanel13, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox21)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox22)
                .addGap(18, 18, 18)
                .addComponent(jTabbedPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 510, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(252, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Disassembler", jPanel21);

        jCheckBox8.setText("draw Vectors as arrows");
        jCheckBox8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox8ActionPerformed(evt);
            }
        });

        jCheckBox9.setText("draw movement vectors");
        jCheckBox9.setEnabled(false);

        jCheckBox24.setText("paint integrator position");
        jCheckBox24.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox24ActionPerformed(evt);
            }
        });

        jPanel9.setBorder(javax.swing.BorderFactory.createTitledBorder("MultiStep delay"));

        jSliderMultiStepDelay.setMajorTickSpacing(100);
        jSliderMultiStepDelay.setMaximum(1000);
        jSliderMultiStepDelay.setMinimum(10);
        jSliderMultiStepDelay.setMinorTickSpacing(10);
        jSliderMultiStepDelay.setPaintTicks(true);
        jSliderMultiStepDelay.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderMultiStepDelayStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel9Layout = new javax.swing.GroupLayout(jPanel9);
        jPanel9.setLayout(jPanel9Layout);
        jPanel9Layout.setHorizontalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMultiStepDelay, javax.swing.GroupLayout.DEFAULT_SIZE, 573, Short.MAX_VALUE)
        );
        jPanel9Layout.setVerticalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMultiStepDelay, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jCheckBox42.setText("reset breakpoints on load");
        jCheckBox42.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox42ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel22Layout = new javax.swing.GroupLayout(jPanel22);
        jPanel22.setLayout(jPanel22Layout);
        jPanel22Layout.setHorizontalGroup(
            jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel22Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel22Layout.createSequentialGroup()
                        .addGroup(jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox8)
                            .addComponent(jCheckBox9)
                            .addComponent(jCheckBox24)
                            .addComponent(jCheckBox42))
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel22Layout.setVerticalGroup(
            jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel22Layout.createSequentialGroup()
                .addGap(21, 21, 21)
                .addComponent(jCheckBox8)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox9)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox24)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox42)
                .addGap(61, 61, 61)
                .addComponent(jPanel9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(690, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Debug", jPanel22);

        jCheckBox13.setSelected(true);
        jCheckBox13.setText("automatically expand short branches to long if needed");
        jCheckBox13.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox13ActionPerformed(evt);
            }
        });

        jCheckBox15.setSelected(true);
        jCheckBox15.setText("opt (in source pseudo overrides!)");
        jCheckBox15.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox15ActionPerformed(evt);
            }
        });

        jCheckBox16.setText("LST output");
        jCheckBox16.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox16ActionPerformed(evt);
            }
        });

        jCheckBox25.setText("treat undefined in if clause as 0 value");
        jCheckBox25.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox25ActionPerformed(evt);
            }
        });

        jCheckBox43.setText("includes relative to parent");
        jCheckBox43.setToolTipText("in opposite to relative to main file");
        jCheckBox43.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox43ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox13)
                    .addComponent(jCheckBox15)
                    .addComponent(jCheckBox16)
                    .addComponent(jCheckBox25)
                    .addComponent(jCheckBox43))
                .addContainerGap(283, Short.MAX_VALUE))
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jCheckBox13)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox15)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox16)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox25)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox43)
                .addContainerGap(820, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Assembler", jPanel6);

        jCheckBox17.setText("invoke Emulator after successfull assembly");
        jCheckBox17.setToolTipText("");
        jCheckBox17.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox17ActionPerformed(evt);
            }
        });

        jCheckBox18.setSelected(true);
        jCheckBox18.setText("scan for defined macros");
        jCheckBox18.setToolTipText("<html>\n<pre>\nIf defined the current file and all found includes (recursively) are scanned\nfor macro definitions. \nSyntax highlighting is than enabled for \"undefined\" macros (red).\nDefined macros are dark blue.\n(if switched off, all macros are dark green, as variables)\n</pre>\n</html>\n\n");
        jCheckBox18.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox18ActionPerformed(evt);
            }
        });

        jCheckBox19.setSelected(true);
        jCheckBox19.setText("scan for defined vars");
        jCheckBox19.setToolTipText("<html>\n<pre>\nIf defined the current file and all found includes (recursively) are scanned\nfor variable (label, equ, =) definitions. \nSyntax highlighting is than enabled for \"undefined\" variables (red).\nDefined variables are dark green.\n</pre>\n</html>\n\n");
        jCheckBox19.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox19ActionPerformed(evt);
            }
        });

        jButton4.setText("Download some ym files");
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });

        jButton5.setText("Download some ayfx files");
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jCheckBoxScanForVectorLists.setText("scan for vectorlists");
        jCheckBoxScanForVectorLists.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxScanForVectorListsActionPerformed(evt);
            }
        });

        jLabel32.setText("start up with: ");

        jButtonFileSelect1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
        jButtonFileSelect1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect1ActionPerformed(evt);
            }
        });

        jTextFieldstart.setName("vecxy"); // NOI18N
        jTextFieldstart.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldstartFocusLost(evt);
            }
        });
        jTextFieldstart.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldstartActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel8Layout = new javax.swing.GroupLayout(jPanel8);
        jPanel8.setLayout(jPanel8Layout);
        jPanel8Layout.setHorizontalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addComponent(jCheckBox17)
                        .addGap(64, 64, 64)
                        .addComponent(jCheckBoxScanForVectorLists))
                    .addComponent(jCheckBox18)
                    .addComponent(jCheckBox19)
                    .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jButton4, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButton5, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addComponent(jLabel32, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldstart, javax.swing.GroupLayout.PREFERRED_SIZE, 226, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonFileSelect1)))
                .addContainerGap(155, Short.MAX_VALUE))
        );
        jPanel8Layout.setVerticalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addGap(18, 18, 18)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox17)
                    .addComponent(jCheckBoxScanForVectorLists))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox18)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox19)
                .addGap(18, 18, 18)
                .addComponent(jButton4)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton5)
                .addGap(26, 26, 26)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel32)
                        .addComponent(jTextFieldstart, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButtonFileSelect1))
                .addContainerGap(730, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Miscellaneous ", jPanel8);

        jTabbedPane3.addTab("all keys", keyBindingsJPanel1);

        javax.swing.GroupLayout jPanel14Layout = new javax.swing.GroupLayout(jPanel14);
        jPanel14.setLayout(jPanel14Layout);
        jPanel14Layout.setHorizontalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane3)
        );
        jPanel14Layout.setVerticalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane3)
        );

        jTabbedPane1.addTab("Keyboard", jPanel14);

        jLabel10.setText("Tinylaf theme");

        jButtonLoad.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad.setToolTipText("load vectorlist");
        jButtonLoad.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoadActionPerformed(evt);
            }
        });

        jLabel11.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel11.setText("Using tinylaf you can easily configure your own laf. ");

        jLabel12.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel12.setText("If you are willing to, go to the directoy \"externalTools/tinylaf\" and start the jar file:");

        jLabel13.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel13.setText("tinycp.jar (either double click or by typing: java -jar tinycp.jar).");

        jLabel14.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel14.setText("Copy the saved *.theme file to the directory \"themes\", than you can chose it with above button.");

        javax.swing.GroupLayout jPanel15Layout = new javax.swing.GroupLayout(jPanel15);
        jPanel15.setLayout(jPanel15Layout);
        jPanel15Layout.setHorizontalGroup(
            jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel15Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel15Layout.createSequentialGroup()
                        .addComponent(jLabel10, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, 340, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonLoad))
                    .addComponent(jLabel11)
                    .addComponent(jLabel12)
                    .addComponent(jLabel13)
                    .addComponent(jLabel14))
                .addContainerGap(74, Short.MAX_VALUE))
            .addComponent(styleJPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel15Layout.setVerticalGroup(
            jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel15Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonLoad)
                    .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel10)
                        .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel11)
                .addGap(2, 2, 2)
                .addComponent(jLabel12)
                .addGap(2, 2, 2)
                .addComponent(jLabel13)
                .addGap(2, 2, 2)
                .addComponent(jLabel14)
                .addGap(59, 59, 59)
                .addComponent(styleJPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 603, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(163, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Theme/Colors", jPanel15);

        jLabel16.setText("Vectrex device");

        jComboBox4.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Joystick", " " }));
        jComboBox4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox4ActionPerformed(evt);
            }
        });

        jPanel24.setBorder(javax.swing.BorderFactory.createEmptyBorder(1, 1, 1, 1));

        jLabel22.setText("X-Axis digital");

        jLabel17.setText("button 1");

        jToggleButton1.setText("1");
        jToggleButton1.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton1.setName("1"); // NOI18N
        jToggleButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton1ActionPerformed(evt);
            }
        });

        jToggleButton2.setText("2");
        jToggleButton2.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton2.setName("2"); // NOI18N
        jToggleButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton2ActionPerformed(evt);
            }
        });

        jLabel18.setText("button 2");

        jToggleButton3.setText("3");
        jToggleButton3.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton3.setName("3"); // NOI18N
        jToggleButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton3ActionPerformed(evt);
            }
        });

        jLabel19.setText("button 3");

        jToggleButton4.setText("4");
        jToggleButton4.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton4.setName("4"); // NOI18N
        jToggleButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton4ActionPerformed(evt);
            }
        });

        jLabel20.setText("button 4");

        jToggleButton5.setText("left");
        jToggleButton5.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton5.setName("left"); // NOI18N
        jToggleButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton5ActionPerformed(evt);
            }
        });

        jToggleButton6.setText("right");
        jToggleButton6.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton6.setName("right"); // NOI18N
        jToggleButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton6ActionPerformed(evt);
            }
        });

        jLabel23.setText("Y-Axis digital ");

        jToggleButton7.setText("up");
        jToggleButton7.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton7.setName("up"); // NOI18N
        jToggleButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton7ActionPerformed(evt);
            }
        });

        jToggleButton8.setText("down");
        jToggleButton8.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton8.setName("down"); // NOI18N
        jToggleButton8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton8ActionPerformed(evt);
            }
        });

        jLabel24.setText("X analog");

        jToggleButton9.setText("horizontal");
        jToggleButton9.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton9.setName("horizontal"); // NOI18N
        jToggleButton9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton9ActionPerformed(evt);
            }
        });

        jLabel25.setText("Y analog");

        jToggleButton10.setText("vertical");
        jToggleButton10.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton10.setName("vertical"); // NOI18N
        jToggleButton10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton10ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel24Layout = new javax.swing.GroupLayout(jPanel24);
        jPanel24.setLayout(jPanel24Layout);
        jPanel24Layout.setHorizontalGroup(
            jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel24Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel24Layout.createSequentialGroup()
                        .addComponent(jLabel17, javax.swing.GroupLayout.PREFERRED_SIZE, 59, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 104, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel24Layout.createSequentialGroup()
                        .addComponent(jLabel19, javax.swing.GroupLayout.PREFERRED_SIZE, 59, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jToggleButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 104, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel24Layout.createSequentialGroup()
                        .addComponent(jLabel18, javax.swing.GroupLayout.PREFERRED_SIZE, 59, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jToggleButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 104, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel24Layout.createSequentialGroup()
                        .addComponent(jLabel20, javax.swing.GroupLayout.PREFERRED_SIZE, 59, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 104, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(10, 10, 10)
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jLabel25, javax.swing.GroupLayout.PREFERRED_SIZE, 68, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel24Layout.createSequentialGroup()
                        .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel22, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel23, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel24Layout.createSequentialGroup()
                                .addComponent(jToggleButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 61, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jToggleButton6, javax.swing.GroupLayout.PREFERRED_SIZE, 63, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel24Layout.createSequentialGroup()
                                .addGap(27, 27, 27)
                                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jToggleButton8, javax.swing.GroupLayout.PREFERRED_SIZE, 77, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jToggleButton7, javax.swing.GroupLayout.PREFERRED_SIZE, 77, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel24Layout.createSequentialGroup()
                        .addComponent(jLabel24, javax.swing.GroupLayout.PREFERRED_SIZE, 59, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jToggleButton10, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jToggleButton9, javax.swing.GroupLayout.DEFAULT_SIZE, 129, Short.MAX_VALUE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel27, javax.swing.GroupLayout.DEFAULT_SIZE, 63, Short.MAX_VALUE)
                    .addComponent(jLabel28, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel24Layout.setVerticalGroup(
            jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel24Layout.createSequentialGroup()
                .addContainerGap(14, Short.MAX_VALUE)
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel24Layout.createSequentialGroup()
                        .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel17)
                            .addComponent(jToggleButton1))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel18)
                            .addComponent(jToggleButton2))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel19)
                            .addComponent(jToggleButton3)))
                    .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addGroup(jPanel24Layout.createSequentialGroup()
                            .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jToggleButton5)
                                .addComponent(jToggleButton6)
                                .addComponent(jLabel22))
                            .addGap(56, 56, 56))
                        .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel24Layout.createSequentialGroup()
                                .addGap(16, 16, 16)
                                .addComponent(jLabel23))
                            .addGroup(jPanel24Layout.createSequentialGroup()
                                .addComponent(jToggleButton7)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jToggleButton8)))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel24Layout.createSequentialGroup()
                        .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel24Layout.createSequentialGroup()
                                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel20)
                                    .addComponent(jToggleButton4)
                                    .addComponent(jLabel25))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel24Layout.createSequentialGroup()
                                .addComponent(jLabel28, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(5, 5, 5)))
                        .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jToggleButton9)
                            .addComponent(jLabel27, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel24)))
                    .addComponent(jToggleButton10))
                .addGap(11, 11, 11))
        );

        jLabel21.setText("device name");

        jLabel26.setText("device");

        jComboBoxJoystickConfigurations.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxJoystickConfigurations.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxJoystickConfigurationsActionPerformed(evt);
            }
        });

        jButtonSave.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/add.png"))); // NOI18N
        jButtonSave.setToolTipText("add controller config");
        jButtonSave.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveActionPerformed(evt);
            }
        });

        jButtonDelete1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/delete.png"))); // NOI18N
        jButtonDelete1.setPreferredSize(new java.awt.Dimension(20, 20));
        jButtonDelete1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDelete1ActionPerformed(evt);
            }
        });

        jButtonNew.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/new.png"))); // NOI18N
        jButtonNew.setToolTipText("new Project");
        jButtonNew.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonNew.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jButtonNewMousePressed(evt);
            }
        });
        jButtonNew.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewActionPerformed(evt);
            }
        });

        jLabel29.setText("minimum cycles between spinner events:");

        jTextField9.setText("30000");
        jTextField9.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField9FocusLost(evt);
            }
        });
        jTextField9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField9ActionPerformed(evt);
            }
        });
        jTextField9.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextField9KeyReleased(evt);
            }
        });

        jLabel30.setText("JInput poll time (in ms):");

        jTextField10.setText("50");
        jTextField10.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField10FocusLost(evt);
            }
        });
        jTextField10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField10ActionPerformed(evt);
            }
        });
        jTextField10.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextField10KeyReleased(evt);
            }
        });

        javax.swing.GroupLayout jPanel23Layout = new javax.swing.GroupLayout(jPanel23);
        jPanel23.setLayout(jPanel23Layout);
        jPanel23Layout.setHorizontalGroup(
            jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel23Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel23Layout.createSequentialGroup()
                            .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel26, javax.swing.GroupLayout.PREFERRED_SIZE, 58, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel21, javax.swing.GroupLayout.PREFERRED_SIZE, 93, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel16, javax.swing.GroupLayout.PREFERRED_SIZE, 89, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                            .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                .addComponent(jTextField8, javax.swing.GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
                                .addComponent(jComboBoxJoystickConfigurations, 0, 120, Short.MAX_VALUE)
                                .addComponent(jComboBox4, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .addGap(8, 8, 8)
                            .addComponent(jButtonNew)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jButtonSave)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jButtonDelete1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addComponent(jPanel24, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel29)
                            .addComponent(jLabel30))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, 68, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, 68, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addComponent(inputControllerDisplay1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(62, Short.MAX_VALUE))
        );
        jPanel23Layout.setVerticalGroup(
            jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel23Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel29)
                    .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel30)
                    .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(34, 34, 34)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButtonSave)
                    .addComponent(jButtonDelete1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBoxJoystickConfigurations, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel26)
                    .addComponent(jButtonNew))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel21))
                .addGap(9, 9, 9)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel16)
                    .addComponent(jComboBox4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel24, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(inputControllerDisplay1, javax.swing.GroupLayout.PREFERRED_SIZE, 427, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(162, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Input", jPanel23);

        jLabel3.setText("Name");

        jTextField6.setToolTipText("More or less a filename!");

        jButton3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/disk.png"))); // NOI18N
        jButton3.setText("Save");
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        jComboBox1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jLabel3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, 115, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 93, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 169, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel3)
                        .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton3))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(3, 3, 3)))
                .addComponent(jTabbedPane1))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jSliderXSHStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderXSHStateChanged
        config.delays[TIMER_XSH_CHANGE] = jSliderXSH.getValue();
    }//GEN-LAST:event_jSliderXSHStateChanged

    private void jSliderRampStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderRampStateChanged
        config.delays[TIMER_RAMP_CHANGE] = jSliderRamp.getValue()/10;
        config.rampOnFractionValue = (jSliderRamp.getValue())-config.delays[TIMER_RAMP_CHANGE]*10;
        config.rampOnFractionValue /= 10;
        jTextField3.setText(""+((double)jSliderRamp.getValue())/10);
        
//        jSliderRampOff.setValue(jSliderRamp.getValue());
//        VecX.delays[TIMER_RAMP_OFF_CHANGE] = jSliderRampOff.getValue()/10;
//        VecX.rampOffFractionValue = (jSliderRampOff.getValue())-VecX.delays[TIMER_RAMP_OFF_CHANGE]*10;
//        VecX.rampOffFractionValue /= 10;
//        jTextField2.setText(""+((double)jSliderRampOff.getValue())/10);

    }//GEN-LAST:event_jSliderRampStateChanged

    private void jSliderBlankStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderBlankStateChanged
        config.delays[TIMER_BLANK_CHANGE] = jSliderBlank.getValue();
    }//GEN-LAST:event_jSliderBlankStateChanged

    private void jSliderZeroStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderZeroStateChanged
//        VecX.delays[TIMER_ZERO] = jSliderZero.getValue();
        config.blankOnDelay = ((double )jSliderZero.getValue())/10;
        
    }//GEN-LAST:event_jSliderZeroStateChanged

    private void jSliderMuxRStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderMuxRStateChanged
        config.delays[TIMER_MUX_R_CHANGE] = jSliderMuxR.getValue();
    }//GEN-LAST:event_jSliderMuxRStateChanged

    private void jSliderMuxZStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderMuxZStateChanged
        config.delays[TIMER_MUX_Z_CHANGE] = jSliderMuxZ.getValue();
    }//GEN-LAST:event_jSliderMuxZStateChanged

    private void jSliderMuxYStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderMuxYStateChanged
        config.delays[TIMER_MUX_Y_CHANGE] = jSliderMuxY.getValue();
    }//GEN-LAST:event_jSliderMuxYStateChanged

    private void jSliderMuxSStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderMuxSStateChanged
        config.delays[TIMER_MUX_S_CHANGE] = jSliderMuxS.getValue();
    }//GEN-LAST:event_jSliderMuxSStateChanged

    private void jCheckBox6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox6ActionPerformed
        config.vectorInformationCollectionActive = jCheckBox6.isSelected();
    }//GEN-LAST:event_jCheckBox6ActionPerformed

    private void jSliderMuxY3StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderMuxY3StateChanged
        config.persistenceAlpha = jSliderMuxY3.getValue();
    }//GEN-LAST:event_jSliderMuxY3StateChanged

    private void jSliderMuxY4StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderMuxY4StateChanged
        config.lineWidth = jSliderMuxY4.getValue();
    }//GEN-LAST:event_jSliderMuxY4StateChanged

    private void jCheckBox10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox10ActionPerformed
        config.antialiazing = jCheckBox10.isSelected();

    }//GEN-LAST:event_jCheckBox10ActionPerformed

    private void jSliderRampOffStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderRampOffStateChanged
        config.delays[TIMER_RAMP_OFF_CHANGE] = jSliderRampOff.getValue()/10;
        config.rampOffFractionValue = (jSliderRampOff.getValue())-config.delays[TIMER_RAMP_OFF_CHANGE]*10;
        config.rampOffFractionValue /= 10;
        jTextField2.setText(""+((double)jSliderRampOff.getValue())/10);
    }//GEN-LAST:event_jSliderRampOffStateChanged

    private void jCheckBox8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox8ActionPerformed
        config.vectorsAsArrows = jCheckBox8.isSelected();

    }//GEN-LAST:event_jCheckBox8ActionPerformed

    private void jCheckBox12ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox12ActionPerformed
        config.cycleExactEmulation = jCheckBox12.isSelected();
    }//GEN-LAST:event_jCheckBox12ActionPerformed

    private void jCheckBox13ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox13ActionPerformed
        config.expandBranches = jCheckBox13.isSelected();
    }//GEN-LAST:event_jCheckBox13ActionPerformed

    private void jCheckBox14ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox14ActionPerformed
        config.enableBankswitch = jCheckBox14.isSelected();
        
    }//GEN-LAST:event_jCheckBox14ActionPerformed

    private void jCheckBox15ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox15ActionPerformed
       config.opt = jCheckBox15.isSelected();
    }//GEN-LAST:event_jCheckBox15ActionPerformed

    private void jCheckBox16ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox16ActionPerformed
       config.outputLST = jCheckBox16.isSelected();
    }//GEN-LAST:event_jCheckBox16ActionPerformed

    private void jCheckBox17ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox17ActionPerformed
      config.invokeEmulatorAfterAssembly = jCheckBox17.isSelected();
    }//GEN-LAST:event_jCheckBox17ActionPerformed

    private void jCheckBox18ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox18ActionPerformed
        config.scanMacros = jCheckBox18.isSelected();
    }//GEN-LAST:event_jCheckBox18ActionPerformed

    private void jCheckBox19ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox19ActionPerformed
        config.scanVars = jCheckBox19.isSelected();
    }//GEN-LAST:event_jCheckBox19ActionPerformed

    private void jCheckBox20ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox20ActionPerformed
        config.assumeVectrex = jCheckBox20.isSelected();
    }//GEN-LAST:event_jCheckBox20ActionPerformed

    private void jCheckBox21ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox21ActionPerformed
        config.createUnkownLabels = jCheckBox21.isSelected();
    }//GEN-LAST:event_jCheckBox21ActionPerformed

    private void jCheckBox22ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox22ActionPerformed
        config.codeScanActive = jCheckBox22.isSelected();
    }//GEN-LAST:event_jCheckBox22ActionPerformed

    private void jCheckBox23ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox23ActionPerformed
        config.ringbufferActive = jCheckBox23.isSelected();
    }//GEN-LAST:event_jCheckBox23ActionPerformed

    private void jCheckBox24ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox24ActionPerformed
        config.paintIntegrators = jCheckBox24.isSelected();

    }//GEN-LAST:event_jCheckBox24ActionPerformed

    private void jSliderMultiStepDelayStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderMultiStepDelayStateChanged
        config.multiStepDelay = jSliderMultiStepDelay.getValue();
    }//GEN-LAST:event_jSliderMultiStepDelayStateChanged

    private void jCheckBox25ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox25ActionPerformed

    config.treatUndefinedAsZero = jCheckBox25.isSelected();
        
    }//GEN-LAST:event_jCheckBox25ActionPerformed

    private void jCheckBox26ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox26ActionPerformed
        config.useSplines = jCheckBox26.isSelected();
    }//GEN-LAST:event_jCheckBox26ActionPerformed

    private void jCheckBox27ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox27ActionPerformed
        config.supressDoubleDraw = jCheckBox27.isSelected();
    }//GEN-LAST:event_jCheckBox27ActionPerformed

    private void jSliderYDriftStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderYDriftStateChanged
        config.drift_y = (double)(((double)jSliderYDrift.getValue())/100);
    }//GEN-LAST:event_jSliderYDriftStateChanged

    private void jSliderXDriftStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderXDriftStateChanged
        config.drift_x = (double)(((double)jSliderXDrift.getValue())/100);
    }//GEN-LAST:event_jSliderXDriftStateChanged

    private void jTextField4FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField4FocusLost
        if (mClassSetting!=0) return;
        mClassSetting++;
        double i= de.malban.util.UtilityString.IntX(jTextField4.getText(), 0);
        config.warmup = i/100;
        mClassSetting--;
    }//GEN-LAST:event_jTextField4FocusLost

    private void jTextField4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField4ActionPerformed
        jTextField4FocusLost(null);
    }//GEN-LAST:event_jTextField4ActionPerformed

    private void jTextField4PropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextField4PropertyChange
        jTextField4FocusLost(null);
    }//GEN-LAST:event_jTextField4PropertyChange

    private void jTextField4KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField4KeyTyped
        jTextField4FocusLost(null);
    }//GEN-LAST:event_jTextField4KeyTyped

    private void jTextField5FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField5FocusLost
        if (mClassSetting!=0) return;
        mClassSetting++;
        double i= de.malban.util.UtilityString.IntX(jTextField5.getText(), 0);
        config.cooldown = i/100;
        mClassSetting--;
    }//GEN-LAST:event_jTextField5FocusLost

    private void jTextField5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField5ActionPerformed
        jTextField5FocusLost(null);
    }//GEN-LAST:event_jTextField5ActionPerformed

    private void jTextField5PropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextField5PropertyChange
        jTextField5FocusLost(null);
    }//GEN-LAST:event_jTextField5PropertyChange

    private void jTextField5KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField5KeyTyped
        jTextField5FocusLost(null);
    }//GEN-LAST:event_jTextField5KeyTyped

    private void jCheckBox32ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox32ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox32ActionPerformed

    private void jCheckBox33ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox33ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox33ActionPerformed

    private void jCheckBox34ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox34ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox34ActionPerformed

    private void jCheckBox35ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox35ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox35ActionPerformed

    private void jCheckBox36ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox36ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox36ActionPerformed

    private void jCheckBox37ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox37ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox37ActionPerformed

    private void jCheckBox38ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox38ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox38ActionPerformed

    private void jCheckBox39ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox39ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox39ActionPerformed

    void setColumnCheckBox(JCheckBox cb)
    {
        String name = cb.getName();
        int index = Integer.parseInt(name);
        MemoryInformationTableModel.columnVisibleALL[index] = cb.isSelected();
        DissiPanel.configChanged();
    }
    
    private void jCheckBox40ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox40ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox40ActionPerformed

    private void jCheckBox41ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox41ActionPerformed
        config.useRayGun = jCheckBox41.isSelected();
    }//GEN-LAST:event_jCheckBox41ActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed

        SystemRomPanel cd = new SystemRomPanel();
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        frame.addPanel(cd);
        frame.setMainPanel(cd);
        frame.windowMe(cd, 600, 350, "System Rom Config");
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        loadSystemRoms(((SystemRom)jComboBox2.getSelectedItem()).getCartName());
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jComboBox2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox2ActionPerformed
        if (mClassSetting>0) return;
        config.usedSystemRom = ((SystemRom)jComboBox2.getSelectedItem()).getCartName();
    }//GEN-LAST:event_jComboBox2ActionPerformed

    private void jSliderSplineDensityStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSplineDensityStateChanged
        config.splineDensity = jSliderSplineDensity.getValue();
    }//GEN-LAST:event_jSliderSplineDensityStateChanged

    private void jCheckBox11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox11ActionPerformed
        config.useQuads = jCheckBox11.isSelected();
    }//GEN-LAST:event_jCheckBox11ActionPerformed

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        String name = jTextField6.getText();
        if (name.trim().length()>0)
        {
            if (!config.save("serialize"+File.separator +name+".vsv"))
            {
                log.addLog("ConfigPanel: Config save error", WARN);
            }
            initValues(); // combobox
        }
    }//GEN-LAST:event_jButton3ActionPerformed

    private void jComboBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox1ActionPerformed
        if (jComboBox1.getSelectedIndex() == -1) return;
        if (mClassSetting>0) return;
        String name = jComboBox1.getSelectedItem().toString();
        if (!config.load(name))
        {
            log.addLog("ConfigPanel: Config load error", WARN);
        }
        initValues(); // all
        jTextField6.setText(name.substring(0, name.length()-4));
    }//GEN-LAST:event_jComboBox1ActionPerformed

    private void jSliderMuxSelStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderMuxSelStateChanged
        config.delays[TIMER_MUX_SEL_CHANGE] = jSliderMuxSel.getValue();
    }//GEN-LAST:event_jSliderMuxSelStateChanged

    private void jSliderRealZeroStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderRealZeroStateChanged
        config.delays[TIMER_ZERO] = jSliderRealZero.getValue();
        
    }//GEN-LAST:event_jSliderRealZeroStateChanged

    private void jCheckBoxAutoSyncActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxAutoSyncActionPerformed
        config.autoSync = jCheckBoxAutoSync.isSelected();
    }//GEN-LAST:event_jCheckBoxAutoSyncActionPerformed

    private void jSliderBrightnessStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderBrightnessStateChanged
        config.brightness = jSliderBrightness.getValue();
        jSliderBrightness.setToolTipText(""+config.brightness);
    }//GEN-LAST:event_jSliderBrightnessStateChanged

    private void jCheckBoxGlowActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxGlowActionPerformed
        config.useGlow = jCheckBoxGlow.isSelected();
    }//GEN-LAST:event_jCheckBoxGlowActionPerformed

    private void jRadioButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton2ActionPerformed
        config.lstFirst = !jRadioButton2.isSelected();
    }//GEN-LAST:event_jRadioButton2ActionPerformed

    private void jRadioButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton1ActionPerformed
        config.lstFirst = jRadioButton1.isSelected();
        
    }//GEN-LAST:event_jRadioButton1ActionPerformed

    private void jComboBox3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox3ActionPerformed
        config.generation = jComboBox3.getSelectedIndex();
        if (config.generation==-1) config.generation = 0;
    }//GEN-LAST:event_jComboBox3ActionPerformed

    private void jCheckBoxEfficiencyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxEfficiencyActionPerformed
        config.efficiencyEnabled = jCheckBoxEfficiency.isSelected();
    }//GEN-LAST:event_jCheckBoxEfficiencyActionPerformed

    private void jSliderEfficiencyStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderEfficiencyStateChanged
        config.efficiency = jSliderEfficiency.getValue();
    }//GEN-LAST:event_jSliderEfficiencyStateChanged

    private void jCheckBoxNoiseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxNoiseActionPerformed
        config.noise =  jCheckBoxNoise.isSelected();
    }//GEN-LAST:event_jCheckBoxNoiseActionPerformed

    private void jSliderNoiseStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderNoiseStateChanged
        config.noisefactor = ((double)jSliderNoise.getValue())/10;
    }//GEN-LAST:event_jSliderNoiseStateChanged

    private void jSliderOverflowStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderOverflowStateChanged
        config.overflowFactor = ((double)jSliderOverflow.getValue());
    }//GEN-LAST:event_jSliderOverflowStateChanged

    private void jCheckBoxOverflowActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxOverflowActionPerformed
        config.emulateIntegrationOverflow = jCheckBoxOverflow.isSelected();
    }//GEN-LAST:event_jCheckBoxOverflowActionPerformed

    private void jCheckBox42ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox42ActionPerformed
        config.resetBreakpointsOnLoad=  jCheckBox42.isSelected();
    }//GEN-LAST:event_jCheckBox42ActionPerformed

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        config.overlayEnabled = jCheckBox1.isSelected();
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
       // https://shiru.untergrund.net/files/ayfxedit04.zip
        String unpack = "download"+File.separator+"sound";
        boolean ok = DownloaderPanel.ensureLocalFile("Sound", "AYFX DOWNLOAD", unpack);
        if (!ok)
        {
            log.addLog("ayfxedit04.zip was not found...", WARN);
            return;
        }
        ShowInfoDialog.showInfoDialog("ZIP loaded and unpacked!", "'ayfxedit04.zip' was loaded and unpacked to '"+unpack+"'!");
    }//GEN-LAST:event_jButton5ActionPerformed

    private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed
       // http://pacidemo.planet-d.net/aldn/ym/ST%20synth%20musics.ym.zip
        String unpack = "download"+File.separator+"sound";
        boolean ok = DownloaderPanel.ensureLocalFile("Sound", "YM DOWNLOAD ZIP", unpack);
        if (!ok)
        {
            log.addLog("ST synth musics.ym.zip was not found...", WARN);
            return;
        }
        ShowInfoDialog.showInfoDialog("ZIP loaded and unpacked!", "'ST synth musics.ym.zip' was loaded and unpacked to '"+unpack+"'!");
    }//GEN-LAST:event_jButton4ActionPerformed

    private void jSliderMasterVolumeStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderMasterVolumeStateChanged
        config.masterVolume = jSliderMasterVolume.getValue();
        double v =  ((double) config.masterVolume)/(double)255.0;
        TinySound.setGlobalVolume(v);

        
    }//GEN-LAST:event_jSliderMasterVolumeStateChanged

    private void jCheckBoxScanForVectorListsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxScanForVectorListsActionPerformed
        config.scanForVectorLists = jCheckBoxScanForVectorLists.isSelected();
    }//GEN-LAST:event_jCheckBoxScanForVectorListsActionPerformed

    String lastPath="theme";
    private void jButtonLoadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoadActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setMultiSelectionEnabled(false);
        if (lastPath.length()==0)
        {
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        FileNameExtensionFilter  filter = new  FileNameExtensionFilter("Themes", "theme");
        fc.setFileFilter(filter);
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String fullPath = fc.getSelectedFile().getAbsolutePath();
        lastPath =fullPath;
        try
        {
            Theme.loadTheme(fc.getSelectedFile());

            // re-install the Tiny Look and Feel
            UIManager.setLookAndFeel(new TinyLookAndFeel());

            // Update the ComponentUIs for all Components. This
            // needs to be invoked for all windows.
            SwingUtilities.updateComponentTreeUI(Configuration.getConfiguration().getMainFrame());  
            
            String rel = de.malban.util.Utility.makeRelative(fc.getSelectedFile().toString());
            
            jTextField7.setText(rel);
            config.themeFile = rel;
        }
        catch (Throwable e)
        {
            e.printStackTrace();
            log.addLog(e, ERROR);
        }
        
    }//GEN-LAST:event_jButtonLoadActionPerformed

    private void jCheckBox43ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox43ActionPerformed
               config.includeRelativeToParent =  jCheckBox43.isSelected();

    }//GEN-LAST:event_jCheckBox43ActionPerformed

    private void jCheckBox5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox5ActionPerformed
        config.psgSound = jCheckBox5.isSelected();
    }//GEN-LAST:event_jCheckBox5ActionPerformed

    private void jSliderPSGVolumeStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderPSGVolumeStateChanged
        config.psgVolume = jSliderPSGVolume.getValue();

    }//GEN-LAST:event_jSliderPSGVolumeStateChanged

    private void jCheckBox7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox7ActionPerformed
        config.speedLimit = jCheckBox7.isSelected();
                
    }//GEN-LAST:event_jCheckBox7ActionPerformed

    private void jCheckBox44ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox44ActionPerformed
        config.imagerAutoOnDefault = jCheckBox44.isSelected();
    }//GEN-LAST:event_jCheckBox44ActionPerformed

    private void jToggleButton10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton10ActionPerformed
        listenFor((JToggleButton)evt.getSource());
    }//GEN-LAST:event_jToggleButton10ActionPerformed

    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed
        addJinputConfig();
    }//GEN-LAST:event_jButtonSaveActionPerformed

    private void jButtonDelete1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDelete1ActionPerformed
        removeJinputConfig();
    }//GEN-LAST:event_jButtonDelete1ActionPerformed

    private void jToggleButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton1ActionPerformed
        listenFor((JToggleButton)evt.getSource());
    }//GEN-LAST:event_jToggleButton1ActionPerformed

    private void jToggleButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton2ActionPerformed
        listenFor((JToggleButton)evt.getSource());
    }//GEN-LAST:event_jToggleButton2ActionPerformed

    private void jToggleButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton3ActionPerformed
        listenFor((JToggleButton)evt.getSource());
    }//GEN-LAST:event_jToggleButton3ActionPerformed

    private void jToggleButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton4ActionPerformed
        listenFor((JToggleButton)evt.getSource());
    }//GEN-LAST:event_jToggleButton4ActionPerformed

    private void jToggleButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton5ActionPerformed
        listenFor((JToggleButton)evt.getSource());
    }//GEN-LAST:event_jToggleButton5ActionPerformed

    private void jToggleButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton6ActionPerformed
        listenFor((JToggleButton)evt.getSource());
    }//GEN-LAST:event_jToggleButton6ActionPerformed

    private void jToggleButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton7ActionPerformed
        listenFor((JToggleButton)evt.getSource());
    }//GEN-LAST:event_jToggleButton7ActionPerformed

    private void jToggleButton9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton9ActionPerformed
        listenFor((JToggleButton)evt.getSource());
    }//GEN-LAST:event_jToggleButton9ActionPerformed

    private void jToggleButton8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton8ActionPerformed
        listenFor((JToggleButton)evt.getSource());
    }//GEN-LAST:event_jToggleButton8ActionPerformed

    private void jComboBoxJoystickConfigurationsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxJoystickConfigurationsActionPerformed
        if (mClassSetting>0) return;
        initJInputConfig();
    }//GEN-LAST:event_jComboBoxJoystickConfigurationsActionPerformed

    private void jButtonNewMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButtonNewMousePressed
        
    }//GEN-LAST:event_jButtonNewMousePressed

    private void jButtonNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewActionPerformed
        newControllerConfig();
    }//GEN-LAST:event_jButtonNewActionPerformed

    private void jComboBox4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox4ActionPerformed
        if (mClassSetting>0) return;
        if (jComboBox4.getSelectedIndex() == CONTROLLER_NONE)
        {
            jToggleButton1.setEnabled(false);
            jToggleButton2.setEnabled(false);
            jToggleButton3.setEnabled(false);
            jToggleButton4.setEnabled(false);
            jToggleButton5.setEnabled(false);
            jToggleButton6.setEnabled(false);
            jToggleButton7.setEnabled(false);
            jToggleButton8.setEnabled(false);
            jToggleButton9.setEnabled(false);
            jToggleButton10.setEnabled(false);
            jLabel17.setEnabled(false);
            jLabel18.setEnabled(false);
            jLabel19.setEnabled(false);
            jLabel20.setEnabled(false);
            jLabel22.setEnabled(false);
            jLabel23.setEnabled(false);
            jLabel24.setEnabled(false);
            jLabel25.setEnabled(false);
        }
        else if (jComboBox4.getSelectedIndex() == CONTROLLER_JOYSTICK)
        {
            jToggleButton1.setEnabled(true);
            jToggleButton2.setEnabled(true);
            jToggleButton3.setEnabled(true);
            jToggleButton4.setEnabled(true);
            jToggleButton5.setEnabled(true);
            jToggleButton6.setEnabled(true);
            jToggleButton7.setEnabled(true);
            jToggleButton8.setEnabled(true);
            jToggleButton9.setEnabled(true);
            jToggleButton10.setEnabled(true);
            jLabel17.setEnabled(true);
            jLabel18.setEnabled(true);
            jLabel19.setEnabled(true);
            jLabel20.setEnabled(true);
            jLabel22.setEnabled(true);
            jLabel23.setEnabled(true);
            jLabel24.setEnabled(true);
            jLabel25.setEnabled(true);
        }
        else if (jComboBox4.getSelectedIndex() == CONTROLLER_SPINNER)
        {
            jToggleButton1.setEnabled(false);
            jToggleButton2.setEnabled(false);
            jToggleButton3.setEnabled(true);
            jToggleButton4.setEnabled(true);
            jToggleButton5.setEnabled(false);
            jToggleButton6.setEnabled(false);
            jToggleButton7.setEnabled(false);
            jToggleButton8.setEnabled(false);
            jToggleButton9.setEnabled(true);
            jToggleButton10.setEnabled(true);
            jLabel17.setEnabled(false);
            jLabel18.setEnabled(false);
            jLabel19.setEnabled(true);
            jLabel20.setEnabled(true);
            jLabel22.setEnabled(false);
            jLabel23.setEnabled(false);
            jLabel24.setEnabled(true);
            jLabel25.setEnabled(true);
        }        
    }//GEN-LAST:event_jComboBox4ActionPerformed

    private void jTextField9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField9ActionPerformed
        config.minimumSpinnerChangeCycles = de.malban.util.UtilityString.IntX(jTextField9.getText(), 30000);
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField9ActionPerformed

    private void jTextField9FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField9FocusLost
        config.minimumSpinnerChangeCycles = de.malban.util.UtilityString.IntX(jTextField9.getText(), 30000);
    }//GEN-LAST:event_jTextField9FocusLost

    private void jTextField9KeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField9KeyReleased
        config.minimumSpinnerChangeCycles = de.malban.util.UtilityString.IntX(jTextField9.getText(), 30000);
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField9KeyReleased

    private void jTextField10FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField10FocusLost
        config.jinputPolltime = de.malban.util.UtilityString.IntX(jTextField10.getText(), 50);
        EventController.setPollResultion(config.jinputPolltime);
        
    }//GEN-LAST:event_jTextField10FocusLost

    private void jTextField10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField10ActionPerformed
        config.jinputPolltime = de.malban.util.UtilityString.IntX(jTextField10.getText(), 50);
        EventController.setPollResultion(config.jinputPolltime);
    }//GEN-LAST:event_jTextField10ActionPerformed

    private void jTextField10KeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField10KeyReleased
        config.jinputPolltime = de.malban.util.UtilityString.IntX(jTextField10.getText(), 50);
        EventController.setPollResultion(config.jinputPolltime);
    }//GEN-LAST:event_jTextField10KeyReleased

    private void jTextField11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField11ActionPerformed
        setSizes();
    }//GEN-LAST:event_jTextField11ActionPerformed

    private void jTextField12ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField12ActionPerformed
        setSizes();
    }//GEN-LAST:event_jTextField12ActionPerformed

    private void jTextField11FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField11FocusLost
        setSizes();
    }//GEN-LAST:event_jTextField11FocusLost

    private void jTextField12FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField12FocusLost
        setSizes();
    }//GEN-LAST:event_jTextField12FocusLost

    private void jButtonFileSelect1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect1ActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        if (config.startFile.length() == 0)
            fc.setCurrentDirectory(new java.io.File("."+File.separator));
        else
        {
            File dir = new java.io.File(config.startFile).getParentFile();
            if (dir != null)
                fc.setCurrentDirectory(dir);
            else
                fc.setCurrentDirectory(new java.io.File("."+File.separator));
        }
            
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String name = fc.getSelectedFile().getAbsolutePath();
        name = de.malban.util.Utility.makeRelative(name);
        jTextFieldstart.setText(name);
        config.startFile = name;
    }//GEN-LAST:event_jButtonFileSelect1ActionPerformed

    private void jTextFieldstartActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldstartActionPerformed
        if (jTextFieldstart.getText() == null)
            config.startFile = "";
        else
            config.startFile = jTextFieldstart.getText();
    }//GEN-LAST:event_jTextFieldstartActionPerformed

    private void jTextFieldstartFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldstartFocusLost
        if (jTextFieldstart.getText() == null)
            config.startFile = "";
        else
            config.startFile = jTextFieldstart.getText();
    }//GEN-LAST:event_jTextFieldstartFocusLost

    void setSizes()
    {
        config.ALG_MAX_X = de.malban.util.UtilityString.IntX(jTextField11.getText(), 38000);
        config.ALG_MAX_Y = de.malban.util.UtilityString.IntX(jTextField12.getText(), 41000);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).resizeVecxis();
    }
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private de.malban.input.InputControllerDisplay inputControllerDisplay1;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButtonDelete1;
    private javax.swing.JButton jButtonFileSelect1;
    private javax.swing.JButton jButtonLoad;
    private javax.swing.JButton jButtonNew;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox10;
    private javax.swing.JCheckBox jCheckBox11;
    private javax.swing.JCheckBox jCheckBox12;
    private javax.swing.JCheckBox jCheckBox13;
    private javax.swing.JCheckBox jCheckBox14;
    private javax.swing.JCheckBox jCheckBox15;
    private javax.swing.JCheckBox jCheckBox16;
    private javax.swing.JCheckBox jCheckBox17;
    private javax.swing.JCheckBox jCheckBox18;
    private javax.swing.JCheckBox jCheckBox19;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox20;
    private javax.swing.JCheckBox jCheckBox21;
    private javax.swing.JCheckBox jCheckBox22;
    private javax.swing.JCheckBox jCheckBox23;
    private javax.swing.JCheckBox jCheckBox24;
    private javax.swing.JCheckBox jCheckBox25;
    private javax.swing.JCheckBox jCheckBox26;
    private javax.swing.JCheckBox jCheckBox27;
    private javax.swing.JCheckBox jCheckBox28;
    private javax.swing.JCheckBox jCheckBox29;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBox30;
    private javax.swing.JCheckBox jCheckBox31;
    private javax.swing.JCheckBox jCheckBox32;
    private javax.swing.JCheckBox jCheckBox33;
    private javax.swing.JCheckBox jCheckBox34;
    private javax.swing.JCheckBox jCheckBox35;
    private javax.swing.JCheckBox jCheckBox36;
    private javax.swing.JCheckBox jCheckBox37;
    private javax.swing.JCheckBox jCheckBox38;
    private javax.swing.JCheckBox jCheckBox39;
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JCheckBox jCheckBox40;
    private javax.swing.JCheckBox jCheckBox41;
    private javax.swing.JCheckBox jCheckBox42;
    private javax.swing.JCheckBox jCheckBox43;
    private javax.swing.JCheckBox jCheckBox44;
    private javax.swing.JCheckBox jCheckBox5;
    private javax.swing.JCheckBox jCheckBox6;
    private javax.swing.JCheckBox jCheckBox7;
    private javax.swing.JCheckBox jCheckBox8;
    private javax.swing.JCheckBox jCheckBox9;
    private javax.swing.JCheckBox jCheckBoxAutoSync;
    private javax.swing.JCheckBox jCheckBoxEfficiency;
    private javax.swing.JCheckBox jCheckBoxGlow;
    private javax.swing.JCheckBox jCheckBoxNoise;
    private javax.swing.JCheckBox jCheckBoxOverflow;
    private javax.swing.JCheckBox jCheckBoxScanForVectorLists;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JComboBox jComboBox2;
    private javax.swing.JComboBox jComboBox3;
    private javax.swing.JComboBox jComboBox4;
    private javax.swing.JComboBox jComboBoxJoystickConfigurations;
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
    private javax.swing.JLabel jLabel23;
    private javax.swing.JLabel jLabel24;
    private javax.swing.JLabel jLabel25;
    private javax.swing.JLabel jLabel26;
    private javax.swing.JLabel jLabel27;
    private javax.swing.JLabel jLabel28;
    private javax.swing.JLabel jLabel29;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel30;
    private javax.swing.JLabel jLabel31;
    private javax.swing.JLabel jLabel32;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel10;
    private javax.swing.JPanel jPanel11;
    private javax.swing.JPanel jPanel12;
    private javax.swing.JPanel jPanel13;
    private javax.swing.JPanel jPanel14;
    private javax.swing.JPanel jPanel15;
    private javax.swing.JPanel jPanel16;
    private javax.swing.JPanel jPanel17;
    private javax.swing.JPanel jPanel18;
    private javax.swing.JPanel jPanel19;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel20;
    private javax.swing.JPanel jPanel21;
    private javax.swing.JPanel jPanel22;
    private javax.swing.JPanel jPanel23;
    private javax.swing.JPanel jPanel24;
    private javax.swing.JPanel jPanel26;
    private javax.swing.JPanel jPanel27;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel30;
    private javax.swing.JPanel jPanel31;
    private javax.swing.JPanel jPanel32;
    private javax.swing.JPanel jPanel33;
    private javax.swing.JPanel jPanel34;
    private javax.swing.JPanel jPanel35;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    private javax.swing.JRadioButton jRadioButton1;
    private javax.swing.JRadioButton jRadioButton2;
    private javax.swing.JSlider jSliderBlank;
    private javax.swing.JSlider jSliderBrightness;
    private javax.swing.JSlider jSliderEfficiency;
    private javax.swing.JSlider jSliderMasterVolume;
    private javax.swing.JSlider jSliderMultiStepDelay;
    private javax.swing.JSlider jSliderMuxR;
    private javax.swing.JSlider jSliderMuxS;
    private javax.swing.JSlider jSliderMuxSel;
    private javax.swing.JSlider jSliderMuxY;
    private javax.swing.JSlider jSliderMuxY3;
    private javax.swing.JSlider jSliderMuxY4;
    private javax.swing.JSlider jSliderMuxZ;
    private javax.swing.JSlider jSliderNoise;
    private javax.swing.JSlider jSliderOverflow;
    private javax.swing.JSlider jSliderPSGVolume;
    private javax.swing.JSlider jSliderRamp;
    private javax.swing.JSlider jSliderRampOff;
    private javax.swing.JSlider jSliderRealZero;
    private javax.swing.JSlider jSliderSplineDensity;
    private javax.swing.JSlider jSliderXDrift;
    private javax.swing.JSlider jSliderXSH;
    private javax.swing.JSlider jSliderYDrift;
    private javax.swing.JSlider jSliderZero;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTabbedPane jTabbedPane2;
    private javax.swing.JTabbedPane jTabbedPane3;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField10;
    private javax.swing.JTextField jTextField11;
    private javax.swing.JTextField jTextField12;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField3;
    private javax.swing.JTextField jTextField4;
    private javax.swing.JTextField jTextField5;
    private javax.swing.JTextField jTextField6;
    private javax.swing.JTextField jTextField7;
    private javax.swing.JTextField jTextField8;
    private javax.swing.JTextField jTextField9;
    private javax.swing.JTextField jTextFieldstart;
    private javax.swing.JToggleButton jToggleButton1;
    private javax.swing.JToggleButton jToggleButton10;
    private javax.swing.JToggleButton jToggleButton2;
    private javax.swing.JToggleButton jToggleButton3;
    private javax.swing.JToggleButton jToggleButton4;
    private javax.swing.JToggleButton jToggleButton5;
    private javax.swing.JToggleButton jToggleButton6;
    private javax.swing.JToggleButton jToggleButton7;
    private javax.swing.JToggleButton jToggleButton8;
    private javax.swing.JToggleButton jToggleButton9;
    private de.malban.vide.vedi.project.KeyBindingsJPanel keyBindingsJPanel1;
    private de.malban.util.syntax.Syntax.StyleJPanel styleJPanel1;
    // End of variables declaration//GEN-END:variables

    public static String SID = "config";
    public String getID()
    {
        return SID;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}
    void loadSystemRoms(String setName)
    {
        mClassSetting++;
        SystemRomPool mSystemRomPool = new SystemRomPool();
        String klasse = "SystemRom";
        Collection<SystemRom> colC = mSystemRomPool.getMapForKlasse(klasse).values();
        Iterator<SystemRom> iterC = colC.iterator();
        int i = 0;
        int selIndex = -1;
        jComboBox2.removeAllItems();
        while (iterC.hasNext())
        {
            SystemRom item = iterC.next();
            jComboBox2.addItem(item);
            if (item.getCartName().toLowerCase().equals(setName.toLowerCase())) 
                selIndex = i;
            i++;
        }        
        jComboBox2.setSelectedIndex(selIndex);
        mClassSetting--;
    }
    JToggleButton listenFor =null;
    void listenFor(JToggleButton b)
    {
        if (mClassSetting>0) return;
        mClassSetting++;
        jToggleButton1.setSelected(false);
        jToggleButton2.setSelected(false);
        jToggleButton3.setSelected(false);
        jToggleButton4.setSelected(false);
        jToggleButton5.setSelected(false);
        jToggleButton6.setSelected(false);
        jToggleButton7.setSelected(false);
        jToggleButton8.setSelected(false);
        jToggleButton9.setSelected(false);
        jToggleButton10.setSelected(false);
        b.setSelected(true);
        listenFor = b;
        mClassSetting--;
    }
    
    HashMap<String, String> inputMapping = new HashMap<String, String>();
    void updateControllerMapping()
    {
        if (inputMapping.get("1") != null)jToggleButton1.setText("1 - "+inputMapping.get("1")); else jToggleButton1.setText("1");
        if (inputMapping.get("2") != null)jToggleButton2.setText("2 - "+inputMapping.get("2")); else jToggleButton2.setText("2");
        if (inputMapping.get("3") != null)jToggleButton3.setText("3 - "+inputMapping.get("3")); else jToggleButton3.setText("3");
        if (inputMapping.get("4") != null)jToggleButton4.setText("4 - "+inputMapping.get("4")); else jToggleButton4.setText("4");
        if (inputMapping.get("left") != null)jToggleButton5.setText("left - "+inputMapping.get("left")); else jToggleButton5.setText("left");
        if (inputMapping.get("right") != null)jToggleButton6.setText("right - "+inputMapping.get("right")); else jToggleButton6.setText("right");
        if (inputMapping.get("up") != null)jToggleButton7.setText("up - "+inputMapping.get("up")); else jToggleButton7.setText("up");
        if (inputMapping.get("down") != null)jToggleButton8.setText("down - "+inputMapping.get("down")); else jToggleButton8.setText("down");
        if (inputMapping.get("horizontal") != null)jToggleButton9.setText("horizontal - "+inputMapping.get("horizontal")); else jToggleButton9.setText("horizontal");
        if (inputMapping.get("vertical") != null)jToggleButton10.setText("vertical - "+inputMapping.get("vertical")); else jToggleButton10.setText("vertical");
        
        
        
        if (jComboBox4.getSelectedIndex() == CONTROLLER_SPINNER) 
        {
            if (inputMapping.get("horizontal")!=null)
            {
                int value = de.malban.util.UtilityString.Int0(jLabel27.getText());
                int cValue = inputControllerDisplay1.getCompareValue(inputMapping.get("horizontal"));
                if (value > cValue)
                    jLabel27.setText(""+value);
                else
                    jLabel27.setText(""+cValue);
            }
        }
        else
        {
            jLabel27.setText("");
            jLabel28.setText("");
        }
        
        
    }

    public void controllerEvent(ControllerEvent e)
    {
     
        if (e.type == ControllerEvent.CONTROLLER_BUTTON_CHANGED)
        {
            if (e.componentId.equals(Component.Identifier.Button.LEFT.getName()))
            {
                if (KeyboardListener.isShiftDown()) return;
            }
        }
        if (e.type == ControllerEvent.CONTROLLER_CHANGED)
        {
            
        }
        if (listenFor!=null)
        {
            mClassSetting++;
            listenFor.setSelected(false);
            mClassSetting--;
            if ( (listenFor.getName().equals("1")) ||
                 (listenFor.getName().equals("2")) ||
                 (listenFor.getName().equals("3")) ||
                 (listenFor.getName().equals("4")) 
               )
            {
                if (e.type == ControllerEvent.CONTROLLER_BUTTON_CHANGED)
                {
                    inputMapping.put(listenFor.getName(), e.componentId);
                    listenFor = null;
                    updateControllerMapping();
                }
            }
            else if ( (listenFor.getName().equals("left")) ||
                 (listenFor.getName().equals("right")) ||
                 (listenFor.getName().equals("up")) ||
                 (listenFor.getName().equals("down")) 
               )
            {
                if (e.type == ControllerEvent.CONTROLLER_BUTTON_CHANGED)
                {
                    inputMapping.put(listenFor.getName(), e.componentId);
                    listenFor = null;
                    updateControllerMapping();
                }
            }
            else if ( (listenFor.getName().equals("horizontal")) ||
                 (listenFor.getName().equals("vertical"))
               )
            {
                if (jComboBox4.getSelectedIndex() == CONTROLLER_SPINNER) 
                {
                    if (e.type == ControllerEvent.CONTROLLER_RELATIVE_CHANGED)
                    {
                        inputMapping.put(listenFor.getName(), e.componentId);
                        listenFor = null;
                        updateControllerMapping();
                    }
                    if (e.type == ControllerEvent.CONTROLLER_AXIS_CHANGED)
                    {
                        inputMapping.put(listenFor.getName(), e.componentId);
                        listenFor = null;
                        updateControllerMapping();
                    }
                    
                    if (e.type == ControllerEvent.CONTROLLER_BUTTON_CHANGED)
                    {
                        inputMapping.put(listenFor.getName(), e.componentId);
                        listenFor = null;
                        updateControllerMapping();
                    }
                            
                }
                else
                {
                    if (e.type == ControllerEvent.CONTROLLER_AXIS_CHANGED)
                    {
                        inputMapping.put(listenFor.getName(), e.componentId);
                        listenFor = null;
                        updateControllerMapping();
                    }
                }

            }
        }
    }
    void initControllers(String name)
    {
        jComboBox4ActionPerformed(null);
        // check if JInput is available at all
        if (!SystemController.isJInputAvailable())
        {
            jTabbedPane1.setEnabledAt(8, false);
            return;
        }
        mClassSetting++;
        
        int old4 = jComboBox4.getSelectedIndex();
        jComboBox4.setModel(new javax.swing.DefaultComboBoxModel(controllerNames));
        jComboBox4.setSelectedIndex(old4);
        int oldIndex = jComboBoxJoystickConfigurations.getSelectedIndex();
        jComboBoxJoystickConfigurations.removeAllItems();
        int count = 0;
        for (ControllerConfig cConfig : controllerConfigs)
        {
            if (cConfig.isWorking)
            {
                jComboBoxJoystickConfigurations.addItem(cConfig);
                if (cConfig.name.equals(name))
                {
                    oldIndex = count;
                }
                count++;
            }
        }        
        
        mClassSetting--;
        if ((oldIndex>=jComboBoxJoystickConfigurations.getItemCount()) || (oldIndex==-1))
            jComboBoxJoystickConfigurations.setSelectedIndex(-1);
        else
            jComboBoxJoystickConfigurations.setSelectedIndex(oldIndex);
        initJInputConfig();
    }
    void addJinputConfig()
    {
        ControllerConfig cConfig =buildConfig();
        if (cConfig == null) return;
        
        removeByName(jTextField8.getText());
        VideConfig.controllerConfigs.add(cConfig);
        initControllers(jTextField8.getText());
        config.saveControllerConfig();
    }
    void removeJinputConfig()
    {
        removeByName(jTextField8.getText());
        initControllers("");
    }
  
    void removeByName(String name)
    {
        for (ControllerConfig cConfig : controllerConfigs)
        {
            if (cConfig.name.equals(name))
            {
                controllerConfigs.remove(cConfig);
                return;
            }
        }
    }
    
    ControllerConfig buildConfig()
    {
        ControllerConfig cConfig = new ControllerConfig();
        
        cConfig.name = jTextField8.getText();
        Controller controller = inputControllerDisplay1.getSelectedController();
        if (controller == null) return null;
        cConfig.JInputId = controller.getName();
        cConfig.isWorking = true;
        cConfig.vectrexType = jComboBox4.getSelectedIndex();
        if (cConfig.vectrexType <= CONTROLLER_NONE) return null;  
        if (cConfig.vectrexType == CONTROLLER_SPINNER) 
        {
            cConfig.compareValue = inputControllerDisplay1.getCompareValue(inputMapping.get("horizontal"));
        }
        
        cConfig.inputMapping = new HashMap<String, String>();
        Set entries = inputMapping.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            cConfig.inputMapping.put(entry.getKey().toString(), entry.getValue().toString());
        }
        
        return cConfig;
    }
    void newControllerConfig()
    {
        mClassSetting++;

        inputMapping = new HashMap<String, String>();
        updateControllerMapping();
        jComboBoxJoystickConfigurations.setSelectedIndex(-1);
        jComboBox4.setSelectedIndex(-1);
        jTextField8.setText("");
        jLabel27.setText("");
        mClassSetting--;

    }

    
    void initJInputConfig()
    {
        Object item = jComboBoxJoystickConfigurations.getSelectedItem();
        if (item == null)
        {
            jTextField8.setText("");
            jComboBox4.setSelectedIndex(-1);
            
            inputMapping = new HashMap<String, String>();
            updateControllerMapping();
            inputControllerDisplay1.setSelectedController("none");
            return;
        }
        ControllerConfig cConfig = (ControllerConfig)item;

        jTextField8.setText(cConfig.name);
        jComboBox4.setSelectedIndex(cConfig.vectrexType);
        
        if (cConfig.vectrexType == CONTROLLER_SPINNER)
        {
            jLabel27.setText(""+cConfig.compareValue);
        }
        
        inputMapping = new HashMap<String, String>();
        Set entries = cConfig.inputMapping.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            inputMapping.put(entry.getKey().toString(), entry.getValue().toString());
        }
        
        updateControllerMapping();
        
        inputControllerDisplay1.setSelectedController(cConfig.JInputId);
    }
}