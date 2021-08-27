/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide;



import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.graphics.VectorColors;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.HotKey;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;


import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InternalColorChooserDialog;
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
import de.malban.util.extractor.Extractor;
import de.malban.util.syntax.Syntax.TokenStyles;
import static de.malban.vide.ControllerConfig.CONTROLLER_JOYSTICK;
import static de.malban.vide.ControllerConfig.CONTROLLER_NONE;
import static de.malban.vide.ControllerConfig.CONTROLLER_SPINNER;
import static de.malban.vide.ControllerConfig.controllerNames;
import static de.malban.vide.VideConfig.controllerConfigs;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.dissy.MemoryInformationTableModel;
import de.malban.vide.vecx.VecXPanel;
import static de.malban.vide.vecx.VecXStatics.*;
import de.malban.vide.vecx.cartridge.SystemRom;
import de.malban.vide.vecx.cartridge.SystemRomPanel;
import de.malban.vide.vecx.cartridge.SystemRomPool;
import de.malban.vide.vecx.libayemu.AY;
import de.malban.vide.vedi.VediPanel;
import de.malban.vide.vedi.peeper.PeepJPanel;
import de.muntjak.tinylookandfeel.Theme;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.DisplayMode;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.File;
import java.io.Serializable;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.swing.JCheckBox;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JToggleButton;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.text.StyleConstants;
import javax.swing.text.html.HTMLEditorKit;
import javax.swing.text.html.StyleSheet;
import net.java.games.input.Component;
import net.java.games.input.Controller;


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
        mParentMenuItem.setText("Configuration");
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
        inputControllerDisplay1.deinit();
        removeUIListerner();
    }
    /**
     * Creates new form RegisterJPanel
     */
    public ConfigJPanel() {
        mClassSetting++;
        initComponents();
        mClassSetting--;
        VideConfig.getConfig();
        loadSystemRoms(config.usedSystemRom);
        Configuration.getConfiguration().setFullScrrenResString(config.fullscreenResolution);    
        correctScreenModeIfNeccessary();
        config.fullscreenResolution = Configuration.getConfiguration().getFullScrrenResString();
        
        if (Global.getOSName().toUpperCase().contains("MAC"))
        {
            HotKey.addMacDefaults(jTextField6);
            HotKey.addMacDefaults(jTextField11);
            HotKey.addMacDefaults(jTextField12);
            HotKey.addMacDefaults(jTextFieldPath);
            HotKey.addMacDefaults(jTextFieldstart);
            HotKey.addMacDefaults(jTextFieldTabWidth);
            HotKey.addMacDefaults(jTextField7);
            HotKey.addMacDefaults(jTextField9);
            HotKey.addMacDefaults(jTextField8);
        }
        
        
        mClassSetting++;
        setScreenModes();

        jComboBoxScreenModes.setSelectedItem(config.fullscreenResolution);
        mClassSetting--;

        initValues();
        inputControllerDisplay1.addEventListerner(this);
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
    }
    
    private void initValues()
    {

        Configuration.getConfiguration().setFullScrrenResString(config.fullscreenResolution);    
        jComboBoxScreenModes.setSelectedItem(config.fullscreenResolution);

        
        initControllers("");

        jTextField14.setText(""+config.TAB_EQU);
        jTextField13.setText(""+config.TAB_EQU_VALUE);
        jTextField15.setText(""+config.TAB_MNEMONIC);
        jTextField16.setText(""+config.TAB_OP);
        jTextFieldCommentIndent.setText(""+config.TAB_COMMENT);
        jTextField27.setText(""+config.SHORT_TAB_OP);
        jPanel61.setBackground(VectorColors.VECCI_Z_AXIS_COLOR);
        jPanel60.setBackground(VectorColors.VECCI_Y_AXIS_COLOR);
        jPanel59.setBackground(VectorColors.VECCI_X_AXIS_COLOR);
        jPanel58.setBackground(VectorColors.VECCI_DRAG_AREA_COLOR);
        jPanel56.setBackground(VectorColors.VECCI_VECTOR_DRAG_COLOR);
        jPanel57.setBackground(VectorColors.VECCI_VECTOR_ENDPOINT_COLOR);
        jPanel55.setBackground(VectorColors.VECCI_MOVE_COLOR);
        jPanel54.setBackground(VectorColors.VECCI_POS_COLOR);
        jPanel53.setBackground(VectorColors.VECCI_POINT_SELECTED_COLOR);
        jPanel52.setBackground(VectorColors.VECCI_POINT_HIGHLIGHT_COLOR);
        jPanel51.setBackground(VectorColors.VECCI_POINT_JOINED_COLOR);
        jPanel50.setBackground(VectorColors.VECCI_VECTOR_SELECTED_COLOR);
        jPanel49.setBackground(VectorColors.VECCI_VECTOR_HIGHLIGHT_COLOR);
        jPanel47.setBackground(VectorColors.VECCI_VECTOR_RELATIVE_COLOR);
        jPanel46.setBackground(VectorColors.VECCI_CROSS_DRAG_COLOR);
        jPanel45.setBackground(VectorColors.VECCI_CROSS_COLOR);
        jPanel44.setBackground(VectorColors.VECCI_FRAME_COLOR);
        jPanel43.setBackground(VectorColors.VECCI_GRID_COLOR);
        jPanel42.setBackground(VectorColors.VECCI_VECTOR_FOREGROUND_COLOR);
        jPanel41.setBackground(VectorColors.VECCI_BACKGROUND_COLOR);
        
        jCheckBoxVia.setSelected(config.viaShift9BugEnabled);
        jCheckBoxProfiler.setSelected(config.doProfile);
        
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
        jSliderBlankOn.setValue(config.delays[TIMER_BLANK_ON_CHANGE]);
        jSliderBlankOnTenth.setValue((int)(config.blankOnDelay*10));
        jSliderBlankOff.setValue(config.delays[TIMER_BLANK_OFF_CHANGE]);
        jSliderBlankOffTenth.setValue((int)(config.blankOffDelay*10));
        jSliderMuxSel.setValue(config.delays[TIMER_MUX_SEL_CHANGE]);
        jSliderRealZero.setValue(config.delays[TIMER_ZERO]);

        jSliderShift.setValue(config.delays[TIMER_SHIFT]-1);
        jSliderT1.setValue(config.delays[TIMER_T1]-1);
        jSliderT_2.setValue(config.delays[TIMER_T2]-1);

        jCheckBox43.setSelected(config.includeRelativeToParent);
        jTextFieldSingestepBuffer.setText(""+config.singestepBuffer);
        jTextFieldFrameBuffer.setText(""+config.frameBuffer);

        jComboBox3.setSelectedIndex(config.generation);

        
        jCheckBoxEfficiency.setSelected(config.efficiencyEnabled);
        jSliderEfficiency.setValue((int)config.efficiency);
        jSliderZeroDivider.setValue((int)(config.zero_divider*100));
        
        jSliderScaleEfficencyThresholdY.setValue((int)(config.efficiencyThresholdY*100));
        jSliderScaleEfficencyThresholdX.setValue((int)(config.efficiencyThresholdX*100));
        
        
        jCheckBoxDeepSyntaxCheck.setSelected(config.deepSyntaxCheck);
        jTextField18.setText(""+config.deepSyntaxCheckTiming);
        
        jCheckBoxColorMode.setSelected(config.vectrexColorMode);
        jCheckBoxFaultyVIA.setSelected(config.isFaultyVIA);
                
        jCheckBoxDeepSyntaxThresholdActive.setSelected(config.deepSyntaxCheckThresholdActive);
        jTextField19.setText(""+config.deepSyntaxCheckThreshold);

        jCheckBoxNoise.setSelected(config.noise);
        jSliderNoise.setValue((int)(config.noisefactor*10));
        
        jCheckBoxOverflow.setSelected(config.emulateIntegrationOverflow);
        jSliderOverflow.setValue((int)(config.overflowFactor));
        
        jCheckBox67.setSelected(config.displayModeWriting);
        jCheckBox47.setSelected(config.autoEjectV4EonCompile);
        
        int rampOn = config.delays[TIMER_RAMP_CHANGE]*10;
        int rampOff = config.delays[TIMER_RAMP_OFF_CHANGE]*10;
        
        rampOn+=config.rampOnFractionValue*10;
        rampOff+=config.rampOffFractionValue*10;
        
        jSliderRamp.setValue(rampOn);
        jSliderRampOff.setValue(rampOff);
        
        jTextField20.setText(""+config.JOGL_SIGMA);
        jTextField1.setText(""+config.JOGLblurPass);
        jTextField21.setText(""+config.JOGL_GAUSS_RADIUS);
        jCheckBox54.setSelected(config.JOGLuseGlowShader);
        jCheckBox55.setSelected(config.JOGLadditiveBlur);
        jCheckBox56.setSelected(config.JOGLaddBase);
        jCheckBox61.setSelected(config.JOGLUseLinearSampling);
        
        jTextFieldPath.setText(""+config.v4eVolumeName);
        jSliderPSGVolume.setValue(config.psgVolume);

        
         jComboBox9.setSelectedIndex(config.JOGLMIP_RESOLUTION);
        
        jSliderZeroRetainX.setValue((int)(config.zeroRetainX*10000.0));
        jSliderZeroRetainY.setValue((int)(config.zeroRetainY*10000.0));
        
        mClassSetting++;
        if (config.rotate == 0)
            jComboBox5.setSelectedIndex(0);
        if (config.rotate == 90)
            jComboBox5.setSelectedIndex(1);
        if (config.rotate == 180)
            jComboBox5.setSelectedIndex(2);
        if (config.rotate == 270)
            jComboBox5.setSelectedIndex(3);        
        mClassSetting--;
        
        changeDisplay();
        
        jTextField3.setText(""+((double)jSliderRamp.getValue())/10);
        jTextField2.setText(""+((double)jSliderRampOff.getValue())/10);
        
        jSliderScaleEfficency.setValue((int)(config.scaleEfficiency*10));
        
        jCheckBox49.setSelected(config.ramAccessAllowed );
         
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
        jCheckBoxStarterImages.setSelected(config.loadStarterImages);
        jCheckBoxJOGL.setSelected(config.tryJOGL);
        jCheckBoxMSAA.setSelected(config.JOGLMSAA);
        jTextField23.setText(""+config.JOGLGlowThreshold);
        jCheckBox57.setSelected(config.JOGLSpillAddBase);
        jCheckBox59.setSelected(config.JOGLSpillUnfactordAddBase);
                     
        int s = 3;
        if (config.JOGLmultiSample == 0) s = 0;
        if (config.JOGLmultiSample == 2) s = 1;
        if (config.JOGLmultiSample == 4) s = 2;
        if (config.JOGLmultiSample == 8) s = 3;
        if (config.JOGLmultiSample == 16) s = 4;
        jComboBox8.setSelectedIndex(s);
        
        jCheckBox62.setSelected(config.emulateBorders);
        jCheckBox64.setSelected(config.keepAspectRatio);

        jTextField31.setText(""+config.overflowIntensityDivider);
        
        jCheckBox65.setSelected(config.debugingCore);
        checkDebuging();
        
        jTextFieldTabWidth.setText(""+config.tab_width);
        
        jTextField24.setText(""+config.JOGLSpillPass);
        jTextField22.setText(""+config.JOGLSpillThreshold);
        jCheckBox58.setSelected(config.JOGLuseSpillShader);
        
        jTextField25.setText(""+config.JOGLInitialSpillDivisor);
        jTextField26.setText(""+config.JOGLFinalSpillMultiplyer);
        jTextField28.setText(""+config.JOGL_speedMaxReduce);
        jTextField29.setText(""+config.JOGLDotDwellDivisor);
        
        jCheckBox60.setSelected(config.JOGLOverlayAdjustment);
        jTextField30.setText(""+config.JOGLOverlayAlphaThreshold);
        jTextField32.setText(""+config.JOGLOverlayAlphaAdjustmentFactor);
        jTextField33.setText(""+config.JOGLOverlayBrightnessAlphaAdjustmentFactor);
        jCheckBoxMSAA1.setSelected(config.JOGLAutoDisplay);
        
        jCheckBox63.setSelected(config.JOGLScreen);
        jTextField34.setText(""+config.JOGLOverlayBrightnessAlphaAdjustmentFactor);
        jCheckBox66.setSelected(config.JOGLScreenAdjustment);
        
        jCheckBoxStarterImages1.setSelected(config.motdActive);
        
        
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
        
        jCheckBox50.setSelected(config.romAndPcBreakpoints);


        jCheckBoxScanForVectorLists.setSelected(config.scanForVectorLists);

        
        jCheckBox42.setSelected(config.resetBreakpointsOnLoad);

        jCheckBox45.setSelected(config.supportUnusedSymbols);
        
        jCheckBox48.setSelected(config.warnOnDoubleDefine);
        
        jSliderXDrift.setValue((int)(config.drift_x*100));
        jSliderYDrift.setValue((int)(config.drift_y*100));        
        jSliderSplineMaxSize.setValue((int)(config.maxSplineSize));        
                
        jRadioButton2.setSelected(!config.lstFirst);
        jRadioButton1.setSelected(config.lstFirst);
        
        jRadioButton3.setSelected(!config.useLibAYEmu);
        jRadioButton4.setSelected(config.useLibAYEmu);

        if (config.useLibAYEmuTable.equals("AY_Kay"))
        {
            jComboBox7.setSelectedIndex(0);
        }
        else if (config.useLibAYEmuTable.equals("YM_Kay"))
        {
            jComboBox7.setSelectedIndex(1);
        }
        else if (config.useLibAYEmuTable.equals("AY_Lion17"))
        {
            jComboBox7.setSelectedIndex(2);
        }
        else if (config.useLibAYEmuTable.equals("YM_Lion17"))
        {
            jComboBox7.setSelectedIndex(3);
        }
        
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
            if (i==13)
            {
                if (MemoryInformationTableModel.columnVisibleALL[i] == null)
                    jCheckBox51.setSelected(true);
                else
                    jCheckBox51.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
            }
            if (i==14)
            {
                if (MemoryInformationTableModel.columnVisibleALL[i] == null)
                    jCheckBox52.setSelected(true);
                else
                    jCheckBox52.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
                
            }
            if (i==15)
            {
                if (MemoryInformationTableModel.columnVisibleALL[i] == null)
                    jCheckBox53.setSelected(true);
                else
                    jCheckBox53.setSelected(MemoryInformationTableModel.columnVisibleALL[i]);
                
            }
        }
        jCheckBox41.setSelected(config.useRayGun);
        jCheckBoxAutoSync.setSelected(config.autoSync);

        jCheckBox46.setSelected(config.pleaseforceDissiIconizeOnRun);
        
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
        

        jPanel71.setBackground(config.valueNotChanged);
        jPanel77.setBackground(config.valueChanged);

        jPanel73.setBackground(config.psgChannelA);
        jPanel72.setBackground(config.psgChannelB);
        jPanel74.setBackground(config.psgChannelC);
        jPanel75.setBackground(config.psgChannelNoise);

        jPanel80.setBackground(config.linkColor);
        jPanel79.setBackground(config.tableOtherBank);
        jPanel78.setBackground(config.tableBIOS);
        jPanel76.setBackground(config.tableAddress);
        jPanel82.setBackground(config.htmltext);
        
        jPanel85.setBackground(config.dataSelection);
        jPanel84.setBackground(config.IOOutput);
        jPanel83.setBackground(config.IOInput);
        jPanel87.setBackground(config.cLinesBack);
        jPanel86.setBackground(config.cLinesFore);
        
        
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
        buttonGroup2 = new javax.swing.ButtonGroup();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel20 = new javax.swing.JPanel();
        jCheckBox12 = new javax.swing.JCheckBox();
        jCheckBox14 = new javax.swing.JCheckBox();
        jComboBox2 = new javax.swing.JComboBox();
        jLabel4 = new javax.swing.JLabel();
        jPanel30 = new javax.swing.JPanel();
        jSliderYDrift = new javax.swing.JSlider();
        jPanel31 = new javax.swing.JPanel();
        jSliderXDrift = new javax.swing.JSlider();
        jCheckBox41 = new javax.swing.JCheckBox();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jCheckBoxAutoSync = new javax.swing.JCheckBox();
        jPanel33 = new javax.swing.JPanel();
        jSliderEfficiency = new javax.swing.JSlider();
        jCheckBoxEfficiency = new javax.swing.JCheckBox();
        jSliderScaleEfficency = new javax.swing.JSlider();
        jLabel34 = new javax.swing.JLabel();
        jSliderScaleEfficencyThresholdY = new javax.swing.JSlider();
        jLabel68 = new javax.swing.JLabel();
        jLabel69 = new javax.swing.JLabel();
        jSliderScaleEfficencyThresholdX = new javax.swing.JSlider();
        jPanel34 = new javax.swing.JPanel();
        jSliderNoise = new javax.swing.JSlider();
        jCheckBoxNoise = new javax.swing.JCheckBox();
        jPanel35 = new javax.swing.JPanel();
        jSliderOverflow = new javax.swing.JSlider();
        jCheckBoxOverflow = new javax.swing.JCheckBox();
        jCheckBox7 = new javax.swing.JCheckBox();
        jLabel31 = new javax.swing.JLabel();
        jTextField11 = new javax.swing.JTextField();
        jTextField12 = new javax.swing.JTextField();
        jCheckBox49 = new javax.swing.JCheckBox();
        jCheckBox44 = new javax.swing.JCheckBox();
        jCheckBox67 = new javax.swing.JCheckBox();
        jCheckBoxColorMode = new javax.swing.JCheckBox();
        jCheckBoxFaultyVIA = new javax.swing.JCheckBox();
        jPanel19 = new javax.swing.JPanel();
        jPanel7 = new javax.swing.JPanel();
        jSliderRampOff = new javax.swing.JSlider();
        jLabel2 = new javax.swing.JLabel();
        jTextField2 = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jTextField3 = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        jComboBox3 = new javax.swing.JComboBox();
        jPanel25 = new javax.swing.JPanel();
        jPanel18 = new javax.swing.JPanel();
        jSliderMuxS = new javax.swing.JSlider();
        jPanel17 = new javax.swing.JPanel();
        jSliderMuxY = new javax.swing.JSlider();
        jPanel16 = new javax.swing.JPanel();
        jSliderMuxZ = new javax.swing.JSlider();
        jPanel1 = new javax.swing.JPanel();
        jSliderXSH = new javax.swing.JSlider();
        jPanel11 = new javax.swing.JPanel();
        jSliderMuxSel = new javax.swing.JSlider();
        jPanel5 = new javax.swing.JPanel();
        jSliderMuxR = new javax.swing.JSlider();
        jPanel36 = new javax.swing.JPanel();
        jSliderT1 = new javax.swing.JSlider();
        jPanel28 = new javax.swing.JPanel();
        jPanel12 = new javax.swing.JPanel();
        jSliderRealZero = new javax.swing.JSlider();
        jPanel3 = new javax.swing.JPanel();
        jSliderBlankOn = new javax.swing.JSlider();
        jSliderBlankOff = new javax.swing.JSlider();
        jPanel4 = new javax.swing.JPanel();
        jSliderBlankOnTenth = new javax.swing.JSlider();
        jSliderBlankOffTenth = new javax.swing.JSlider();
        jPanel29 = new javax.swing.JPanel();
        jSliderShift = new javax.swing.JSlider();
        jPanel102 = new javax.swing.JPanel();
        jSliderT_2 = new javax.swing.JSlider();
        jPanel2 = new javax.swing.JPanel();
        jSliderRamp = new javax.swing.JSlider();
        jCheckBoxVia = new javax.swing.JCheckBox();
        jPanel39 = new javax.swing.JPanel();
        jSliderZeroDivider = new javax.swing.JSlider();
        jLabel35 = new javax.swing.JLabel();
        jComboBox6 = new javax.swing.JComboBox<>();
        jPanel37 = new javax.swing.JPanel();
        jSliderZeroRetainX = new javax.swing.JSlider();
        jPanel38 = new javax.swing.JPanel();
        jSliderZeroRetainY = new javax.swing.JSlider();
        jPanel63 = new javax.swing.JPanel();
        jPanel26 = new javax.swing.JPanel();
        jSliderMuxY3 = new javax.swing.JSlider();
        jPanel27 = new javax.swing.JPanel();
        jSliderMuxY4 = new javax.swing.JSlider();
        jCheckBox26 = new javax.swing.JCheckBox();
        jCheckBox27 = new javax.swing.JCheckBox();
        jCheckBox10 = new javax.swing.JCheckBox();
        jCheckBoxJOGL = new javax.swing.JCheckBox();
        jCheckBox1 = new javax.swing.JCheckBox();
        jPanel64 = new javax.swing.JPanel();
        jPanel48 = new javax.swing.JPanel();
        jCheckBox54 = new javax.swing.JCheckBox();
        jCheckBox55 = new javax.swing.JCheckBox();
        jTextField1 = new javax.swing.JTextField();
        jLabel73 = new javax.swing.JLabel();
        jTextField20 = new javax.swing.JTextField();
        jLabel74 = new javax.swing.JLabel();
        jLabel75 = new javax.swing.JLabel();
        jTextField21 = new javax.swing.JTextField();
        jCheckBox56 = new javax.swing.JCheckBox();
        jLabel80 = new javax.swing.JLabel();
        jTextField23 = new javax.swing.JTextField();
        jCheckBox61 = new javax.swing.JCheckBox();
        jComboBox9 = new javax.swing.JComboBox();
        jLabel76 = new javax.swing.JLabel();
        jPanel65 = new javax.swing.JPanel();
        jCheckBox58 = new javax.swing.JCheckBox();
        jLabel77 = new javax.swing.JLabel();
        jTextField22 = new javax.swing.JTextField();
        jLabel81 = new javax.swing.JLabel();
        jTextField24 = new javax.swing.JTextField();
        jLabel82 = new javax.swing.JLabel();
        jTextField25 = new javax.swing.JTextField();
        jLabel83 = new javax.swing.JLabel();
        jTextField26 = new javax.swing.JTextField();
        jCheckBox57 = new javax.swing.JCheckBox();
        jCheckBox59 = new javax.swing.JCheckBox();
        jLabel84 = new javax.swing.JLabel();
        jTextField28 = new javax.swing.JTextField();
        jCheckBoxMSAA = new javax.swing.JCheckBox();
        jLabel72 = new javax.swing.JLabel();
        jComboBox8 = new javax.swing.JComboBox<>();
        jLabel85 = new javax.swing.JLabel();
        jTextField29 = new javax.swing.JTextField();
        jPanel67 = new javax.swing.JPanel();
        jCheckBox60 = new javax.swing.JCheckBox();
        jLabel86 = new javax.swing.JLabel();
        jTextField30 = new javax.swing.JTextField();
        jLabel88 = new javax.swing.JLabel();
        jTextField32 = new javax.swing.JTextField();
        jLabel89 = new javax.swing.JLabel();
        jTextField33 = new javax.swing.JTextField();
        jCheckBoxMSAA1 = new javax.swing.JCheckBox();
        jLabel87 = new javax.swing.JLabel();
        jTextField31 = new javax.swing.JTextField();
        jCheckBox62 = new javax.swing.JCheckBox();
        jPanel68 = new javax.swing.JPanel();
        jCheckBox63 = new javax.swing.JCheckBox();
        jCheckBox66 = new javax.swing.JCheckBox();
        jLabel90 = new javax.swing.JLabel();
        jTextField34 = new javax.swing.JTextField();
        jPanel69 = new javax.swing.JPanel();
        jLabel78 = new javax.swing.JLabel();
        jComboBoxScreenModes = new javax.swing.JComboBox();
        jCheckBox64 = new javax.swing.JCheckBox();
        jPanel66 = new javax.swing.JPanel();
        jCheckBoxGlow = new javax.swing.JCheckBox();
        jCheckBox11 = new javax.swing.JCheckBox();
        jPanel32 = new javax.swing.JPanel();
        jSliderBrightness = new javax.swing.JSlider();
        jLabel33 = new javax.swing.JLabel();
        jComboBox5 = new javax.swing.JComboBox();
        jSliderSplineDensity = new javax.swing.JSlider();
        jSliderSplineMaxSize = new javax.swing.JSlider();
        jPanel22 = new javax.swing.JPanel();
        jCheckBox8 = new javax.swing.JCheckBox();
        jCheckBox9 = new javax.swing.JCheckBox();
        jCheckBox24 = new javax.swing.JCheckBox();
        jPanel9 = new javax.swing.JPanel();
        jSliderMultiStepDelay = new javax.swing.JSlider();
        jCheckBox42 = new javax.swing.JCheckBox();
        jCheckBox50 = new javax.swing.JCheckBox();
        jCheckBox6 = new javax.swing.JCheckBox();
        jCheckBox23 = new javax.swing.JCheckBox();
        jLabel36 = new javax.swing.JLabel();
        jLabel1 = new javax.swing.JLabel();
        jTextFieldFrameBuffer = new javax.swing.JTextField();
        jTextFieldSingestepBuffer = new javax.swing.JTextField();
        jCheckBoxProfiler = new javax.swing.JCheckBox();
        jLabel67 = new javax.swing.JLabel();
        jCheckBox22 = new javax.swing.JCheckBox();
        jCheckBox65 = new javax.swing.JCheckBox();
        jPanel21 = new javax.swing.JPanel();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox3 = new javax.swing.JCheckBox();
        jCheckBox4 = new javax.swing.JCheckBox();
        jCheckBox20 = new javax.swing.JCheckBox();
        jCheckBox21 = new javax.swing.JCheckBox();
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
        jCheckBox51 = new javax.swing.JCheckBox();
        jCheckBox52 = new javax.swing.JCheckBox();
        jCheckBox53 = new javax.swing.JCheckBox();
        jPanel13 = new javax.swing.JPanel();
        jRadioButton1 = new javax.swing.JRadioButton();
        jRadioButton2 = new javax.swing.JRadioButton();
        jCheckBox46 = new javax.swing.JCheckBox();
        jPanel6 = new javax.swing.JPanel();
        jCheckBox13 = new javax.swing.JCheckBox();
        jCheckBox15 = new javax.swing.JCheckBox();
        jCheckBox16 = new javax.swing.JCheckBox();
        jCheckBox25 = new javax.swing.JCheckBox();
        jCheckBox43 = new javax.swing.JCheckBox();
        jCheckBox45 = new javax.swing.JCheckBox();
        jCheckBox48 = new javax.swing.JCheckBox();
        jPanel62 = new javax.swing.JPanel();
        jTextField14 = new javax.swing.JTextField();
        jTextField13 = new javax.swing.JTextField();
        jLabel61 = new javax.swing.JLabel();
        jLabel60 = new javax.swing.JLabel();
        jTextField15 = new javax.swing.JTextField();
        jTextField16 = new javax.swing.JTextField();
        jLabel62 = new javax.swing.JLabel();
        jLabel63 = new javax.swing.JLabel();
        jLabel64 = new javax.swing.JLabel();
        jTextFieldCommentIndent = new javax.swing.JTextField();
        jLabel111 = new javax.swing.JLabel();
        jTextField27 = new javax.swing.JTextField();
        jCheckBoxDeepSyntaxCheck = new javax.swing.JCheckBox();
        jTextField18 = new javax.swing.JTextField();
        jLabel70 = new javax.swing.JLabel();
        jCheckBoxDeepSyntaxThresholdActive = new javax.swing.JCheckBox();
        jLabel71 = new javax.swing.JLabel();
        jTextField19 = new javax.swing.JTextField();
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
        jCheckBox47 = new javax.swing.JCheckBox();
        jCheckBox5 = new javax.swing.JCheckBox();
        jLabel9 = new javax.swing.JLabel();
        jSliderMasterVolume = new javax.swing.JSlider();
        jLabel15 = new javax.swing.JLabel();
        jSliderPSGVolume = new javax.swing.JSlider();
        jRadioButton3 = new javax.swing.JRadioButton();
        jRadioButton4 = new javax.swing.JRadioButton();
        jComboBox7 = new javax.swing.JComboBox();
        jTextFieldPath = new javax.swing.JTextField();
        jButtonFileSelect2 = new javax.swing.JButton();
        jLabel37 = new javax.swing.JLabel();
        jPanel40 = new javax.swing.JPanel();
        jButtonVecciForeground = new javax.swing.JButton();
        jPanel42 = new javax.swing.JPanel();
        jLabel39 = new javax.swing.JLabel();
        jLabel40 = new javax.swing.JLabel();
        jPanel43 = new javax.swing.JPanel();
        jButtonVecciGrid = new javax.swing.JButton();
        jButtonByteFrame = new javax.swing.JButton();
        jPanel44 = new javax.swing.JPanel();
        jLabel41 = new javax.swing.JLabel();
        jLabel42 = new javax.swing.JLabel();
        jPanel45 = new javax.swing.JPanel();
        jButtonCross = new javax.swing.JButton();
        jLabel43 = new javax.swing.JLabel();
        jPanel46 = new javax.swing.JPanel();
        jButtonCrossDrag = new javax.swing.JButton();
        jButtonRelative = new javax.swing.JButton();
        jPanel47 = new javax.swing.JPanel();
        jLabel44 = new javax.swing.JLabel();
        jLabel45 = new javax.swing.JLabel();
        jPanel49 = new javax.swing.JPanel();
        jButtonHighlite = new javax.swing.JButton();
        jLabel46 = new javax.swing.JLabel();
        jPanel50 = new javax.swing.JPanel();
        jButtonSelect = new javax.swing.JButton();
        jLabel47 = new javax.swing.JLabel();
        jPanel51 = new javax.swing.JPanel();
        jButtonPointJoined = new javax.swing.JButton();
        jLabel48 = new javax.swing.JLabel();
        jPanel52 = new javax.swing.JPanel();
        jButtonPointHighlite = new javax.swing.JButton();
        jLabel49 = new javax.swing.JLabel();
        jPanel53 = new javax.swing.JPanel();
        jButtonPointSelect = new javax.swing.JButton();
        jLabel50 = new javax.swing.JLabel();
        jPanel54 = new javax.swing.JPanel();
        jButtonVectorPos = new javax.swing.JButton();
        jLabel51 = new javax.swing.JLabel();
        jPanel55 = new javax.swing.JPanel();
        jButtonVectorMove = new javax.swing.JButton();
        jLabel52 = new javax.swing.JLabel();
        jPanel56 = new javax.swing.JPanel();
        jButtonVectorDrag = new javax.swing.JButton();
        jButtonEndpoint = new javax.swing.JButton();
        jPanel57 = new javax.swing.JPanel();
        jLabel53 = new javax.swing.JLabel();
        jButtonAreaDrag = new javax.swing.JButton();
        jPanel58 = new javax.swing.JPanel();
        jLabel54 = new javax.swing.JLabel();
        jButtonxAxis = new javax.swing.JButton();
        jPanel59 = new javax.swing.JPanel();
        jLabel55 = new javax.swing.JLabel();
        jLabel56 = new javax.swing.JLabel();
        jPanel60 = new javax.swing.JPanel();
        jButtonyAxis = new javax.swing.JButton();
        jLabel57 = new javax.swing.JLabel();
        jPanel61 = new javax.swing.JPanel();
        jButtonzAxis = new javax.swing.JButton();
        jLabel58 = new javax.swing.JLabel();
        jLabel59 = new javax.swing.JLabel();
        jLabel65 = new javax.swing.JLabel();
        jLabel66 = new javax.swing.JLabel();
        jLabel38 = new javax.swing.JLabel();
        jPanel41 = new javax.swing.JPanel();
        jButtonVecciBackground = new javax.swing.JButton();
        jCheckBoxStarterImages = new javax.swing.JCheckBox();
        jButton6 = new javax.swing.JButton();
        jLabel79 = new javax.swing.JLabel();
        jCheckBoxStarterImages1 = new javax.swing.JCheckBox();
        jButtonPre1 = new javax.swing.JButton();
        jPanel14 = new javax.swing.JPanel();
        keyBindingsJPanel1 = new de.malban.vide.vedi.project.KeyBindingsJPanel();
        jPanel15 = new javax.swing.JPanel();
        jLabel10 = new javax.swing.JLabel();
        jTextField7 = new javax.swing.JTextField();
        jButtonLoad = new javax.swing.JButton();
        styleJPanel1 = new de.malban.util.syntax.Syntax.StyleJPanel();
        jButtonLAF = new javax.swing.JButton();
        jLabel91 = new javax.swing.JLabel();
        jTextFieldTabWidth = new javax.swing.JTextField();
        jLabel92 = new javax.swing.JLabel();
        jPanel70 = new javax.swing.JPanel();
        jButtonRegUnChanged = new javax.swing.JButton();
        jPanel71 = new javax.swing.JPanel();
        jLabel93 = new javax.swing.JLabel();
        jButtonPSGA = new javax.swing.JButton();
        jButtonPSGB = new javax.swing.JButton();
        jPanel72 = new javax.swing.JPanel();
        jPanel73 = new javax.swing.JPanel();
        jLabel94 = new javax.swing.JLabel();
        jLabel95 = new javax.swing.JLabel();
        jButtonVecciBackground4 = new javax.swing.JButton();
        jPanel74 = new javax.swing.JPanel();
        jButtonVecciBackground5 = new javax.swing.JButton();
        jPanel75 = new javax.swing.JPanel();
        jLabel96 = new javax.swing.JLabel();
        jLabel97 = new javax.swing.JLabel();
        jButtontableAddress = new javax.swing.JButton();
        jPanel76 = new javax.swing.JPanel();
        jLabel98 = new javax.swing.JLabel();
        jButtontableBIOS = new javax.swing.JButton();
        jPanel78 = new javax.swing.JPanel();
        jLabel99 = new javax.swing.JLabel();
        jButtontableBank = new javax.swing.JButton();
        jPanel79 = new javax.swing.JPanel();
        jLabel100 = new javax.swing.JLabel();
        jButtonHTMLLink = new javax.swing.JButton();
        jPanel80 = new javax.swing.JPanel();
        jLabel101 = new javax.swing.JLabel();
        jButtonVecciBackground10 = new javax.swing.JButton();
        jPanel81 = new javax.swing.JPanel();
        jLabel102 = new javax.swing.JLabel();
        jButtonRegChanged = new javax.swing.JButton();
        jPanel77 = new javax.swing.JPanel();
        jLabel103 = new javax.swing.JLabel();
        jButtonHTMLText = new javax.swing.JButton();
        jPanel82 = new javax.swing.JPanel();
        jLabel104 = new javax.swing.JLabel();
        jLabel105 = new javax.swing.JLabel();
        jButtontableIOInput = new javax.swing.JButton();
        jPanel83 = new javax.swing.JPanel();
        jLabel107 = new javax.swing.JLabel();
        jButtonIOOutput = new javax.swing.JButton();
        jPanel84 = new javax.swing.JPanel();
        jLabel108 = new javax.swing.JLabel();
        jButtonTabelSelection = new javax.swing.JButton();
        jPanel85 = new javax.swing.JPanel();
        jLabel109 = new javax.swing.JLabel();
        jButtonVecciBackground6 = new javax.swing.JButton();
        jButtonVecciBackground7 = new javax.swing.JButton();
        jPanel86 = new javax.swing.JPanel();
        jPanel87 = new javax.swing.JPanel();
        jLabel106 = new javax.swing.JLabel();
        jLabel110 = new javax.swing.JLabel();
        jPanel23 = new javax.swing.JPanel();
        jLabel16 = new javax.swing.JLabel();
        jComboBox4 = new javax.swing.JComboBox();
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
        jCheckBoxMouseMode = new javax.swing.JCheckBox();
        jPanel24 = new javax.swing.JPanel();
        jLabel3 = new javax.swing.JLabel();
        jTextField6 = new javax.swing.JTextField();
        jButton3 = new javax.swing.JButton();
        jComboBox1 = new javax.swing.JComboBox();

        setName("regi"); // NOI18N
        setPreferredSize(new java.awt.Dimension(660, 870));

        jScrollPane1.setPreferredSize(new java.awt.Dimension(640, 850));

        jTabbedPane1.setPreferredSize(new java.awt.Dimension(680, 845));

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

        jComboBox2.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBox2.setPreferredSize(new java.awt.Dimension(56, 21));
        jComboBox2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox2ActionPerformed(evt);
            }
        });

        jLabel4.setText("Boot rom");

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
            .addComponent(jSliderYDrift, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel30Layout.setVerticalGroup(
            jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderYDrift, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
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
            .addComponent(jSliderXDrift, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel31Layout.setVerticalGroup(
            jPanel31Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderXDrift, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
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
        jButton1.setPreferredSize(new java.awt.Dimension(21, 21));
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/wand.png"))); // NOI18N
        jButton2.setToolTipText("refresh (after configuration)");
        jButton2.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton2.setPreferredSize(new java.awt.Dimension(21, 21));
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jCheckBoxAutoSync.setText("Try autoSync");
        jCheckBoxAutoSync.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxAutoSyncActionPerformed(evt);
            }
        });

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

        jSliderScaleEfficency.setMajorTickSpacing(10);
        jSliderScaleEfficency.setMinimum(-100);
        jSliderScaleEfficency.setMinorTickSpacing(1);
        jSliderScaleEfficency.setPaintTicks(true);
        jSliderScaleEfficency.setValue(0);
        jSliderScaleEfficency.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderScaleEfficencyStateChanged(evt);
            }
        });

        jLabel34.setText("scale/strength");

        jSliderScaleEfficencyThresholdY.setMajorTickSpacing(10);
        jSliderScaleEfficencyThresholdY.setMaximum(300);
        jSliderScaleEfficencyThresholdY.setMinimum(1);
        jSliderScaleEfficencyThresholdY.setMinorTickSpacing(5);
        jSliderScaleEfficencyThresholdY.setPaintTicks(true);
        jSliderScaleEfficencyThresholdY.setToolTipText("<html>Y The higher the value the later the efficiency is \"decreased\",<br>  this is a percent of the current maximum screensize. Since the vectors can be \"out of the screen\", the value goes from 0 to 300%. </html>");
        jSliderScaleEfficencyThresholdY.setValue(80);
        jSliderScaleEfficencyThresholdY.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderScaleEfficencyThresholdYStateChanged(evt);
            }
        });

        jLabel68.setText("efficiency");

        jLabel69.setText("threshold");

        jSliderScaleEfficencyThresholdX.setMajorTickSpacing(10);
        jSliderScaleEfficencyThresholdX.setMaximum(300);
        jSliderScaleEfficencyThresholdX.setMinimum(1);
        jSliderScaleEfficencyThresholdX.setMinorTickSpacing(5);
        jSliderScaleEfficencyThresholdX.setPaintTicks(true);
        jSliderScaleEfficencyThresholdX.setToolTipText("<html>X The higher the value the later the efficiency is \"decreased\",<br>  this is a percent of the current maximum screensize. Since the vectors can be \"out of the screen\", the value goes from 0 to 300%. </html>");
        jSliderScaleEfficencyThresholdX.setValue(80);
        jSliderScaleEfficencyThresholdX.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderScaleEfficencyThresholdXStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel33Layout = new javax.swing.GroupLayout(jPanel33);
        jPanel33.setLayout(jPanel33Layout);
        jPanel33Layout.setHorizontalGroup(
            jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel33Layout.createSequentialGroup()
                .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxEfficiency)
                    .addComponent(jLabel68)
                    .addComponent(jLabel69)
                    .addComponent(jLabel34))
                .addGap(10, 10, 10)
                .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel33Layout.createSequentialGroup()
                        .addComponent(jSliderScaleEfficencyThresholdX, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGap(30, 30, 30)
                        .addComponent(jSliderScaleEfficencyThresholdY, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jSliderEfficiency, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jSliderScaleEfficency, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
        );
        jPanel33Layout.setVerticalGroup(
            jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel33Layout.createSequentialGroup()
                .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxEfficiency)
                    .addComponent(jSliderEfficiency, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(6, 6, 6)
                .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jSliderScaleEfficencyThresholdX, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel33Layout.createSequentialGroup()
                            .addComponent(jLabel68)
                            .addGap(2, 2, 2)
                            .addComponent(jLabel69)))
                    .addComponent(jSliderScaleEfficencyThresholdY, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel33Layout.createSequentialGroup()
                        .addComponent(jSliderScaleEfficency, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addComponent(jLabel34, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(6, 6, 6))
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
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jSliderNoise, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel34Layout.setVerticalGroup(
            jPanel34Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel34Layout.createSequentialGroup()
                .addComponent(jSliderNoise, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
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
        jSliderOverflow.setEnabled(false);
        jSliderOverflow.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderOverflowStateChanged(evt);
            }
        });

        jCheckBoxOverflow.setText("overflow");
        jCheckBoxOverflow.setEnabled(false);
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
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jSliderOverflow, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel35Layout.setVerticalGroup(
            jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel35Layout.createSequentialGroup()
                .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jSliderOverflow, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxOverflow))
                .addGap(0, 0, Short.MAX_VALUE))
        );

        jCheckBox7.setSelected(true);
        jCheckBox7.setText("Speed limit 100%");
        jCheckBox7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox7ActionPerformed(evt);
            }
        });

        jLabel31.setText("emulated vectrex integrator max (w/h)");

        jTextField11.setText("38000");
        jTextField11.setPreferredSize(new java.awt.Dimension(80, 21));
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
        jTextField12.setPreferredSize(new java.awt.Dimension(80, 21));
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

        jCheckBox49.setText("allow ROM write");
        jCheckBox49.setToolTipText("if enabled, ROM can be written to (in general) from cartdigde (which is BAD!)");
        jCheckBox49.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox49ActionPerformed(evt);
            }
        });

        jCheckBox44.setText("imager auto mode on default");
        jCheckBox44.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox44ActionPerformed(evt);
            }
        });

        jCheckBox67.setText("display mode text");
        jCheckBox67.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox67ActionPerformed(evt);
            }
        });

        jCheckBoxColorMode.setText("Jason color mode");
        jCheckBoxColorMode.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxColorModeActionPerformed(evt);
            }
        });

        jCheckBoxFaultyVIA.setText("VIA faulty");
        jCheckBoxFaultyVIA.setToolTipText("As described in BLOG entry 1st of June 2019");
        jCheckBoxFaultyVIA.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxFaultyVIAActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel20Layout = new javax.swing.GroupLayout(jPanel20);
        jPanel20.setLayout(jPanel20Layout);
        jPanel20Layout.setHorizontalGroup(
            jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel20Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel20Layout.createSequentialGroup()
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jPanel35, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel34, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel33, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel31, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel30, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(jPanel20Layout.createSequentialGroup()
                                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jCheckBox12)
                                    .addComponent(jCheckBox14)
                                    .addComponent(jCheckBox49)
                                    .addComponent(jCheckBoxAutoSync)
                                    .addComponent(jCheckBox7))
                                .addGap(0, 0, Short.MAX_VALUE)))
                        .addContainerGap())
                    .addGroup(jPanel20Layout.createSequentialGroup()
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox41)
                            .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                .addComponent(jCheckBox44, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel20Layout.createSequentialGroup()
                                    .addComponent(jLabel4)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jComboBox2, javax.swing.GroupLayout.PREFERRED_SIZE, 126, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE))))
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel20Layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 54, Short.MAX_VALUE)
                                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPanel20Layout.createSequentialGroup()
                                        .addComponent(jTextField11, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jTextField12, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addComponent(jLabel31))
                                .addGap(167, 167, 167))
                            .addGroup(jPanel20Layout.createSequentialGroup()
                                .addGap(18, 18, 18)
                                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jCheckBoxColorMode, javax.swing.GroupLayout.PREFERRED_SIZE, 234, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jCheckBox67, javax.swing.GroupLayout.PREFERRED_SIZE, 234, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jCheckBoxFaultyVIA, javax.swing.GroupLayout.PREFERRED_SIZE, 234, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))))
        );
        jPanel20Layout.setVerticalGroup(
            jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel20Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel20Layout.createSequentialGroup()
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jComboBox2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel4))
                            .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox41))
                    .addGroup(jPanel20Layout.createSequentialGroup()
                        .addComponent(jLabel31)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField11, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField12, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(0, 0, 0)
                .addComponent(jCheckBox12)
                .addGap(0, 0, 0)
                .addComponent(jCheckBox14)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBoxAutoSync)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox7)
                    .addComponent(jCheckBoxFaultyVIA))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox49)
                    .addComponent(jCheckBoxColorMode))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox44)
                    .addComponent(jCheckBox67))
                .addGap(12, 12, 12)
                .addComponent(jPanel31, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel30, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel33, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel34, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel35, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        jTabbedPane1.addTab("Emulator", jPanel20);

        jPanel7.setBorder(javax.swing.BorderFactory.createTitledBorder("Ramp Off"));

        jSliderRampOff.setMajorTickSpacing(10);
        jSliderRampOff.setMaximum(200);
        jSliderRampOff.setMinorTickSpacing(1);
        jSliderRampOff.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderRampOff.setPaintLabels(true);
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
            .addComponent(jSliderRampOff, javax.swing.GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
        );
        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderRampOff, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jLabel2.setText("Ramp off delay");
        jLabel2.setEnabled(false);

        jTextField2.setText("80");
        jTextField2.setEnabled(false);
        jTextField2.setPreferredSize(new java.awt.Dimension(50, 21));

        jLabel5.setText("Ramp on delay");
        jLabel5.setEnabled(false);

        jTextField3.setText("80");
        jTextField3.setEnabled(false);
        jTextField3.setPreferredSize(new java.awt.Dimension(50, 21));

        jLabel8.setText("vectrex generation");

        jComboBox3.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Off", "1", "2", "3" }));
        jComboBox3.setToolTipText("<html>\nDifferent vectrex models seem to have diffferent DAC - with different delay values.<BR>\nThese setttings are experimental and not calculable, I only have vectrex generation 2+3 at hand!<BR>\nDifferences may usually be seen when DAC changes are done while Ramp is enabled!\n</html>\n");
        jComboBox3.setMinimumSize(new java.awt.Dimension(41, 21));
        jComboBox3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox3ActionPerformed(evt);
            }
        });

        jPanel18.setBorder(javax.swing.BorderFactory.createTitledBorder("SSH"));

        jSliderMuxS.setMajorTickSpacing(10);
        jSliderMuxS.setMaximum(40);
        jSliderMuxS.setMinorTickSpacing(1);
        jSliderMuxS.setOrientation(javax.swing.JSlider.VERTICAL);
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
            .addComponent(jSliderMuxS, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel18Layout.setVerticalGroup(
            jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxS, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jPanel17.setBorder(javax.swing.BorderFactory.createTitledBorder("YSH"));

        jSliderMuxY.setMajorTickSpacing(10);
        jSliderMuxY.setMaximum(40);
        jSliderMuxY.setMinorTickSpacing(1);
        jSliderMuxY.setOrientation(javax.swing.JSlider.VERTICAL);
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
            .addComponent(jSliderMuxY, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel17Layout.setVerticalGroup(
            jPanel17Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxY, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jPanel16.setBorder(javax.swing.BorderFactory.createTitledBorder("ZSH"));

        jSliderMuxZ.setMajorTickSpacing(10);
        jSliderMuxZ.setMaximum(40);
        jSliderMuxZ.setMinorTickSpacing(1);
        jSliderMuxZ.setOrientation(javax.swing.JSlider.VERTICAL);
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
            .addComponent(jSliderMuxZ, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel16Layout.setVerticalGroup(
            jPanel16Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxZ, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder("XSH"));

        jSliderXSH.setMajorTickSpacing(10);
        jSliderXSH.setMaximum(40);
        jSliderXSH.setMinorTickSpacing(1);
        jSliderXSH.setOrientation(javax.swing.JSlider.VERTICAL);
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
            .addComponent(jSliderXSH, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jPanel11.setBorder(javax.swing.BorderFactory.createTitledBorder("MUX-SEL"));

        jSliderMuxSel.setMajorTickSpacing(10);
        jSliderMuxSel.setMaximum(40);
        jSliderMuxSel.setMinorTickSpacing(1);
        jSliderMuxSel.setOrientation(javax.swing.JSlider.VERTICAL);
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
            .addComponent(jSliderMuxSel, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel11Layout.setVerticalGroup(
            jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxSel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jPanel5.setBorder(javax.swing.BorderFactory.createTitledBorder("RSH"));

        jSliderMuxR.setMajorTickSpacing(10);
        jSliderMuxR.setMaximum(40);
        jSliderMuxR.setMinorTickSpacing(1);
        jSliderMuxR.setOrientation(javax.swing.JSlider.VERTICAL);
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
            .addComponent(jSliderMuxR, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxR, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jPanel36.setBorder(javax.swing.BorderFactory.createTitledBorder("T1"));

        jSliderT1.setMajorTickSpacing(5);
        jSliderT1.setMaximum(10);
        jSliderT1.setMinorTickSpacing(1);
        jSliderT1.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderT1.setPaintLabels(true);
        jSliderT1.setPaintTicks(true);
        jSliderT1.setValue(0);
        jSliderT1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderT1StateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel36Layout = new javax.swing.GroupLayout(jPanel36);
        jPanel36.setLayout(jPanel36Layout);
        jPanel36Layout.setHorizontalGroup(
            jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderT1, javax.swing.GroupLayout.DEFAULT_SIZE, 60, Short.MAX_VALUE)
        );
        jPanel36Layout.setVerticalGroup(
            jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderT1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout jPanel25Layout = new javax.swing.GroupLayout(jPanel25);
        jPanel25.setLayout(jPanel25Layout);
        jPanel25Layout.setHorizontalGroup(
            jPanel25Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel25Layout.createSequentialGroup()
                .addComponent(jPanel11, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel17, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel16, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel18, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel36, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel25Layout.setVerticalGroup(
            jPanel25Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel25Layout.createSequentialGroup()
                .addGroup(jPanel25Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jPanel1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel16, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel17, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel11, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel18, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel36, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(0, 0, Short.MAX_VALUE))
        );

        jPanel12.setBorder(javax.swing.BorderFactory.createTitledBorder("Zero"));

        jSliderRealZero.setMajorTickSpacing(10);
        jSliderRealZero.setMaximum(40);
        jSliderRealZero.setMinorTickSpacing(1);
        jSliderRealZero.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderRealZero.setPaintLabels(true);
        jSliderRealZero.setPaintTicks(true);
        jSliderRealZero.setValue(0);
        jSliderRealZero.setPreferredSize(new java.awt.Dimension(63, 222));
        jSliderRealZero.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderRealZeroStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel12Layout = new javax.swing.GroupLayout(jPanel12);
        jPanel12.setLayout(jPanel12Layout);
        jPanel12Layout.setHorizontalGroup(
            jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderRealZero, javax.swing.GroupLayout.DEFAULT_SIZE, 53, Short.MAX_VALUE)
        );
        jPanel12Layout.setVerticalGroup(
            jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel12Layout.createSequentialGroup()
                .addComponent(jSliderRealZero, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder("Blank on/off"));

        jSliderBlankOn.setMajorTickSpacing(10);
        jSliderBlankOn.setMinorTickSpacing(1);
        jSliderBlankOn.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderBlankOn.setPaintLabels(true);
        jSliderBlankOn.setPaintTicks(true);
        jSliderBlankOn.setValue(0);
        jSliderBlankOn.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderBlankOnStateChanged(evt);
            }
        });

        jSliderBlankOff.setMajorTickSpacing(10);
        jSliderBlankOff.setMinorTickSpacing(1);
        jSliderBlankOff.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderBlankOff.setPaintLabels(true);
        jSliderBlankOff.setPaintTicks(true);
        jSliderBlankOff.setValue(0);
        jSliderBlankOff.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderBlankOffStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addComponent(jSliderBlankOn, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jSliderBlankOff, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addComponent(jSliderBlankOn, javax.swing.GroupLayout.PREFERRED_SIZE, 224, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addComponent(jSliderBlankOff, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jPanel4.setBorder(javax.swing.BorderFactory.createTitledBorder("Blank on/off /10"));

        jSliderBlankOnTenth.setMajorTickSpacing(10);
        jSliderBlankOnTenth.setMaximum(40);
        jSliderBlankOnTenth.setMinimum(-40);
        jSliderBlankOnTenth.setMinorTickSpacing(1);
        jSliderBlankOnTenth.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderBlankOnTenth.setPaintLabels(true);
        jSliderBlankOnTenth.setPaintTicks(true);
        jSliderBlankOnTenth.setValue(0);
        jSliderBlankOnTenth.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderBlankOnTenthStateChanged(evt);
            }
        });

        jSliderBlankOffTenth.setMajorTickSpacing(10);
        jSliderBlankOffTenth.setMaximum(40);
        jSliderBlankOffTenth.setMinimum(-40);
        jSliderBlankOffTenth.setMinorTickSpacing(1);
        jSliderBlankOffTenth.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderBlankOffTenth.setPaintLabels(true);
        jSliderBlankOffTenth.setPaintTicks(true);
        jSliderBlankOffTenth.setValue(0);
        jSliderBlankOffTenth.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderBlankOffTenthStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jSliderBlankOnTenth, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jSliderBlankOffTenth, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderBlankOnTenth, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jSliderBlankOffTenth, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jPanel29.setBorder(javax.swing.BorderFactory.createTitledBorder("SHIFT"));

        jSliderShift.setMajorTickSpacing(5);
        jSliderShift.setMaximum(20);
        jSliderShift.setMinorTickSpacing(1);
        jSliderShift.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderShift.setPaintLabels(true);
        jSliderShift.setPaintTicks(true);
        jSliderShift.setValue(0);
        jSliderShift.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderShiftStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel29Layout = new javax.swing.GroupLayout(jPanel29);
        jPanel29.setLayout(jPanel29Layout);
        jPanel29Layout.setHorizontalGroup(
            jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderShift, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel29Layout.setVerticalGroup(
            jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderShift, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jPanel102.setBorder(javax.swing.BorderFactory.createTitledBorder("T2"));

        jSliderT_2.setMajorTickSpacing(5);
        jSliderT_2.setMaximum(10);
        jSliderT_2.setMinorTickSpacing(1);
        jSliderT_2.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderT_2.setPaintLabels(true);
        jSliderT_2.setPaintTicks(true);
        jSliderT_2.setValue(0);
        jSliderT_2.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderT_2StateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel102Layout = new javax.swing.GroupLayout(jPanel102);
        jPanel102.setLayout(jPanel102Layout);
        jPanel102Layout.setHorizontalGroup(
            jPanel102Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderT_2, javax.swing.GroupLayout.DEFAULT_SIZE, 60, Short.MAX_VALUE)
        );
        jPanel102Layout.setVerticalGroup(
            jPanel102Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderT_2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout jPanel28Layout = new javax.swing.GroupLayout(jPanel28);
        jPanel28.setLayout(jPanel28Layout);
        jPanel28Layout.setHorizontalGroup(
            jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel28Layout.createSequentialGroup()
                .addComponent(jPanel12, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, 128, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel29, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel102, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        jPanel28Layout.setVerticalGroup(
            jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel102, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel29, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel12, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder("Ramp On"));

        jSliderRamp.setMajorTickSpacing(10);
        jSliderRamp.setMaximum(200);
        jSliderRamp.setMinorTickSpacing(1);
        jSliderRamp.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderRamp.setPaintLabels(true);
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
            .addComponent(jSliderRamp, javax.swing.GroupLayout.DEFAULT_SIZE, 78, Short.MAX_VALUE)
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderRamp, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jCheckBoxVia.setText("Via Shift 9 Bug");
        jCheckBoxVia.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxViaActionPerformed(evt);
            }
        });

        jPanel39.setBorder(javax.swing.BorderFactory.createTitledBorder("zero divider"));

        jSliderZeroDivider.setMajorTickSpacing(100);
        jSliderZeroDivider.setMaximum(2000);
        jSliderZeroDivider.setMinimum(100);
        jSliderZeroDivider.setMinorTickSpacing(10);
        jSliderZeroDivider.setPaintTicks(true);
        jSliderZeroDivider.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderZeroDividerStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel39Layout = new javax.swing.GroupLayout(jPanel39);
        jPanel39.setLayout(jPanel39Layout);
        jPanel39Layout.setHorizontalGroup(
            jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderZeroDivider, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel39Layout.setVerticalGroup(
            jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderZeroDivider, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jLabel35.setText("delay variants");

        jComboBox6.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "delay 0", "delay 1", "delay 2", "delay 3" }));
        jComboBox6.setToolTipText("on selection this sets preconfigured values");
        jComboBox6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox6ActionPerformed(evt);
            }
        });

        jPanel37.setBorder(javax.swing.BorderFactory.createTitledBorder("zero retain X"));

        jSliderZeroRetainX.setMajorTickSpacing(100);
        jSliderZeroRetainX.setMaximum(1000);
        jSliderZeroRetainX.setMinorTickSpacing(10);
        jSliderZeroRetainX.setPaintTicks(true);
        jSliderZeroRetainX.setValue(0);
        jSliderZeroRetainX.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderZeroRetainXStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel37Layout = new javax.swing.GroupLayout(jPanel37);
        jPanel37.setLayout(jPanel37Layout);
        jPanel37Layout.setHorizontalGroup(
            jPanel37Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderZeroRetainX, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel37Layout.setVerticalGroup(
            jPanel37Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderZeroRetainX, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jPanel38.setBorder(javax.swing.BorderFactory.createTitledBorder("zero retain Y"));

        jSliderZeroRetainY.setMajorTickSpacing(100);
        jSliderZeroRetainY.setMaximum(1000);
        jSliderZeroRetainY.setMinorTickSpacing(10);
        jSliderZeroRetainY.setPaintTicks(true);
        jSliderZeroRetainY.setValue(0);
        jSliderZeroRetainY.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderZeroRetainYStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel38Layout = new javax.swing.GroupLayout(jPanel38);
        jPanel38.setLayout(jPanel38Layout);
        jPanel38Layout.setHorizontalGroup(
            jPanel38Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderZeroRetainY, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel38Layout.setVerticalGroup(
            jPanel38Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderZeroRetainY, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        javax.swing.GroupLayout jPanel19Layout = new javax.swing.GroupLayout(jPanel19);
        jPanel19.setLayout(jPanel19Layout);
        jPanel19Layout.setHorizontalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel39, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel19Layout.createSequentialGroup()
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel5)
                                    .addComponent(jLabel2))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addComponent(jCheckBoxVia))
                        .addGap(206, 206, 206)
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel8)
                            .addComponent(jLabel35)))
                    .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jPanel28, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 448, Short.MAX_VALUE)
                        .addComponent(jPanel25, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addGap(5, 5, 5)
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                        .addComponent(jComboBox6, 0, 105, Short.MAX_VALUE)
                        .addComponent(jComboBox3, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addContainerGap(39, Short.MAX_VALUE))
            .addComponent(jPanel37, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel38, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel19Layout.setVerticalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel19Layout.createSequentialGroup()
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addComponent(jPanel25, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel28, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel7, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(10, 10, 10)
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
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel8)
                            .addComponent(jComboBox3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(8, 8, 8)
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel35)
                            .addComponent(jComboBox6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBoxVia)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel39, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel37, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel38, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(86, 86, 86))
        );

        jTabbedPane1.addTab("Delays", jPanel19);

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
            .addComponent(jSliderMuxY3, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel26Layout.setVerticalGroup(
            jPanel26Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderMuxY3, javax.swing.GroupLayout.PREFERRED_SIZE, 27, Short.MAX_VALUE)
        );

        jPanel27.setBorder(javax.swing.BorderFactory.createTitledBorder("Line width"));
        jPanel27.setPreferredSize(new java.awt.Dimension(210, 49));

        jSliderMuxY4.setMajorTickSpacing(1);
        jSliderMuxY4.setMaximum(10);
        jSliderMuxY4.setMinimum(1);
        jSliderMuxY4.setMinorTickSpacing(1);
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
            .addComponent(jSliderMuxY4, javax.swing.GroupLayout.PREFERRED_SIZE, 27, Short.MAX_VALUE)
        );

        jCheckBox26.setText("use splines for curved vectors");
        jCheckBox26.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox26ActionPerformed(evt);
            }
        });

        jCheckBox27.setText("suppress double draw on line sections");
        jCheckBox27.setEnabled(false);
        jCheckBox27.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox27ActionPerformed(evt);
            }
        });

        jCheckBox10.setText("Antialiazing");
        jCheckBox10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox10ActionPerformed(evt);
            }
        });

        jCheckBoxJOGL.setText("JOGL");
        jCheckBoxJOGL.setToolTipText("Vecxi instance must be restarted");
        jCheckBoxJOGL.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxJOGLActionPerformed(evt);
            }
        });

        jCheckBox1.setSelected(true);
        jCheckBox1.setText("load overlays when available");
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jPanel64.setBorder(javax.swing.BorderFactory.createTitledBorder("JOGL config only"));

        jPanel48.setBorder(javax.swing.BorderFactory.createTitledBorder("Glow"));

        jCheckBox54.setText("use glow shader");
        jCheckBox54.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox54ActionPerformed(evt);
            }
        });

        jCheckBox55.setText("additive blur");
        jCheckBox55.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox55ActionPerformed(evt);
            }
        });

        jTextField1.setText("2");
        jTextField1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1ActionPerformed(evt);
            }
        });

        jLabel73.setText("blur passes");

        jTextField20.setText("0.8");
        jTextField20.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField20ActionPerformed(evt);
            }
        });

        jLabel74.setText("Gauss sigma");

        jLabel75.setText("Gauss radius");

        jTextField21.setText("2");
        jTextField21.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField21ActionPerformed(evt);
            }
        });

        jCheckBox56.setText("add base");
        jCheckBox56.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox56ActionPerformed(evt);
            }
        });

        jLabel80.setText("threshold");

        jTextField23.setText("0.8");
        jTextField23.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField23ActionPerformed(evt);
            }
        });

        jCheckBox61.setText("use linear sampling");
        jCheckBox61.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox61ActionPerformed(evt);
            }
        });

        jComboBox9.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "1", "1/2", "1/4", "1/8", "1/16" }));
        jComboBox9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox9ActionPerformed(evt);
            }
        });

        jLabel76.setText("use scaling");

        javax.swing.GroupLayout jPanel48Layout = new javax.swing.GroupLayout(jPanel48);
        jPanel48.setLayout(jPanel48Layout);
        jPanel48Layout.setHorizontalGroup(
            jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel48Layout.createSequentialGroup()
                .addGroup(jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel48Layout.createSequentialGroup()
                        .addGroup(jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel48Layout.createSequentialGroup()
                                .addGap(10, 10, 10)
                                .addGroup(jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel80)
                                    .addComponent(jLabel75)))
                            .addGroup(jPanel48Layout.createSequentialGroup()
                                .addContainerGap()
                                .addComponent(jLabel76)))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jComboBox9, javax.swing.GroupLayout.PREFERRED_SIZE, 91, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                .addComponent(jTextField1, javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jTextField20, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 45, Short.MAX_VALUE)
                                .addComponent(jTextField23, javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jTextField21, javax.swing.GroupLayout.Alignment.LEADING))))
                    .addGroup(jPanel48Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addComponent(jCheckBox54))
                    .addGroup(jPanel48Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addComponent(jCheckBox56))
                    .addGroup(jPanel48Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addComponent(jCheckBox55))
                    .addGroup(jPanel48Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addComponent(jLabel73))
                    .addGroup(jPanel48Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addComponent(jLabel74))
                    .addGroup(jPanel48Layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jCheckBox61)))
                .addContainerGap(20, Short.MAX_VALUE))
        );
        jPanel48Layout.setVerticalGroup(
            jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel48Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jCheckBox54)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox55)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox56)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel73)
                    .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField20, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel74))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField21, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel75))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel80)
                    .addComponent(jTextField23, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox61)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel48Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jComboBox9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel76))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jPanel65.setBorder(javax.swing.BorderFactory.createTitledBorder("Spill"));

        jCheckBox58.setText("use spill shader");
        jCheckBox58.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox58ActionPerformed(evt);
            }
        });

        jLabel77.setText("threshold");

        jTextField22.setText("0.2");
        jTextField22.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField22ActionPerformed(evt);
            }
        });

        jLabel81.setText("spill passes");

        jTextField24.setText("2");
        jTextField24.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField24ActionPerformed(evt);
            }
        });

        jLabel82.setText("initial divisor");

        jTextField25.setText("5");
        jTextField25.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField25ActionPerformed(evt);
            }
        });

        jLabel83.setText("final factor");

        jTextField26.setText("5");
        jTextField26.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField26ActionPerformed(evt);
            }
        });

        jCheckBox57.setText("add base");
        jCheckBox57.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox57ActionPerformed(evt);
            }
        });

        jCheckBox59.setText("unfactored add base?");
        jCheckBox59.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox59ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel65Layout = new javax.swing.GroupLayout(jPanel65);
        jPanel65.setLayout(jPanel65Layout);
        jPanel65Layout.setHorizontalGroup(
            jPanel65Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel65Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel65Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel81)
                    .addComponent(jCheckBox57)
                    .addComponent(jLabel77)
                    .addComponent(jLabel82)
                    .addComponent(jLabel83))
                .addGap(9, 9, 9)
                .addGroup(jPanel65Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField25)
                    .addComponent(jTextField22)
                    .addComponent(jTextField26)
                    .addComponent(jTextField24))
                .addGap(21, 21, 21))
            .addGroup(jPanel65Layout.createSequentialGroup()
                .addGap(12, 12, 12)
                .addGroup(jPanel65Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox59)
                    .addComponent(jCheckBox58))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel65Layout.setVerticalGroup(
            jPanel65Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel65Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jCheckBox58)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox57)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox59)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel65Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField25, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel82))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel65Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField22, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel77))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel65Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel83)
                    .addComponent(jTextField26, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addGroup(jPanel65Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel81)
                    .addComponent(jTextField24, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        jLabel84.setText("vector speed maximal reduce factor");

        jTextField28.setText("5");
        jTextField28.setToolTipText("<html>\nbetween 0 and 0.9, speed of the vectorbeam (strength) influences the brightness, \n<BR>this factor determines \"how much\"\n</html>\n");
        jTextField28.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField28ActionPerformed(evt);
            }
        });

        jCheckBoxMSAA.setText("MSAA");
        jCheckBoxMSAA.setToolTipText("Only if Antialiazing is enabled. If MSAA disabled, than \"SMOOTH\" settings of OPENGL are used");
        jCheckBoxMSAA.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxMSAAActionPerformed(evt);
            }
        });

        jLabel72.setText("samples");

        jComboBox8.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "0", "2", "4", "8", "16" }));
        jComboBox8.setSelectedIndex(3);
        jComboBox8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox8ActionPerformed(evt);
            }
        });

        jLabel85.setText("dot dwell divisor");

        jTextField29.setText("25");
        jTextField29.setToolTipText("<html>\nbetween 1 and 256, (between 20-30 is sensible)<BR>\nDwell information of the vector beam is kept internally, <BR>\nthe longer the beam stays at the same position the higher the value.\n<BR>\nEach \"cycle\" adds \"4\" to the dwell value.\n</html>\n");
        jTextField29.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField29ActionPerformed(evt);
            }
        });

        jPanel67.setBorder(javax.swing.BorderFactory.createTitledBorder("Overlay"));

        jCheckBox60.setText("adjust overlay");
        jCheckBox60.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox60ActionPerformed(evt);
            }
        });

        jLabel86.setText("alpha threshold");

        jTextField30.setText("0.8");
        jTextField30.setToolTipText("needed for sub pixel opaque lines, which are rendered to \"half\" transparent");
        jTextField30.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField30ActionPerformed(evt);
            }
        });

        jLabel88.setText("overlay alpha adjust");
        jLabel88.setToolTipText("adjust alpha overlay, if above threshold");

        jTextField32.setText("0.5");
        jTextField32.setToolTipText("<html>\nThe alpha value of the overlay are adjusted with this factor.<BR>\n(all alpha values below the \"alpha\" threshold are adjusted)\n</html>");
        jTextField32.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField32ActionPerformed(evt);
            }
        });

        jLabel89.setText("overlay brightness adjust");
        jLabel89.setToolTipText("brightness adjustment of overlay, when a vectrex beam is displayed");

        jTextField33.setText("0.5");
        jTextField33.setToolTipText("<html>\nThe alpha value of the overlay are adjusted with the brightness of the vectrex\nbeam information.<BR>\nThis factor describes how much influence the brightness has on the alpha value\nof the overlay.\n</html>");
        jTextField33.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField33ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel67Layout = new javax.swing.GroupLayout(jPanel67);
        jPanel67.setLayout(jPanel67Layout);
        jPanel67Layout.setHorizontalGroup(
            jPanel67Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel67Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel67Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel86)
                    .addComponent(jLabel88)
                    .addComponent(jLabel89))
                .addGap(10, 10, 10)
                .addGroup(jPanel67Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField30, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField32)
                    .addComponent(jTextField33))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(jPanel67Layout.createSequentialGroup()
                .addGap(12, 12, 12)
                .addComponent(jCheckBox60)
                .addGap(104, 104, 104))
        );
        jPanel67Layout.setVerticalGroup(
            jPanel67Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel67Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jCheckBox60)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel67Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField30, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel86))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel67Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField32, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel88))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel67Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel89)
                    .addComponent(jTextField33, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jCheckBoxMSAA1.setText("update automatic");
        jCheckBoxMSAA1.setToolTipText("");
        jCheckBoxMSAA1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxMSAA1ActionPerformed(evt);
            }
        });

        jLabel87.setText("overflow intensity divider");

        jTextField31.setText("30000");
        jTextField31.setToolTipText("<html>\nAn arbitrary divider, experiments, vide likes something between 10000 and 50000.\n\nLike dwell information, the out of bounds intensity information is kept internally, <BR>\nthe longer the beam stays out of bounds the higher the value.\n<BR>\nEach \"cycle\" adds \"4\" to the out of bounds value.\n</html>\n");
        jTextField31.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField31ActionPerformed(evt);
            }
        });

        jCheckBox62.setText("show border overflow ");
        jCheckBox62.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox62ActionPerformed(evt);
            }
        });

        jPanel68.setBorder(javax.swing.BorderFactory.createTitledBorder("Chassis"));

        jCheckBox63.setText("screen");
        jCheckBox63.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox63ActionPerformed(evt);
            }
        });

        jCheckBox66.setText("adjust screen");
        jCheckBox66.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox66ActionPerformed(evt);
            }
        });

        jLabel90.setText("brightness adjust");

        jTextField34.setText("0.8");
        jTextField34.setToolTipText("needed for sub pixel opaque lines, which are rendered to \"half\" transparent");
        jTextField34.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField34ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel68Layout = new javax.swing.GroupLayout(jPanel68);
        jPanel68.setLayout(jPanel68Layout);
        jPanel68Layout.setHorizontalGroup(
            jPanel68Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel68Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel68Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel68Layout.createSequentialGroup()
                        .addGap(19, 19, 19)
                        .addGroup(jPanel68Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox66)
                            .addGroup(jPanel68Layout.createSequentialGroup()
                                .addComponent(jLabel90)
                                .addGap(38, 38, 38)
                                .addComponent(jTextField34, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addComponent(jCheckBox63))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel68Layout.setVerticalGroup(
            jPanel68Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel68Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jCheckBox63)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox66)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel68Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField34, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel90))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jPanel69.setBorder(javax.swing.BorderFactory.createTitledBorder("Fullscreen setup"));

        jLabel78.setText("Screen mode");

        jComboBoxScreenModes.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxScreenModes.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxScreenModesActionPerformed(evt);
            }
        });

        jCheckBox64.setText("keep aspect ratio");
        jCheckBox64.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox64ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel69Layout = new javax.swing.GroupLayout(jPanel69);
        jPanel69.setLayout(jPanel69Layout);
        jPanel69Layout.setHorizontalGroup(
            jPanel69Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel69Layout.createSequentialGroup()
                .addComponent(jLabel78)
                .addGap(0, 0, Short.MAX_VALUE))
            .addGroup(jPanel69Layout.createSequentialGroup()
                .addGroup(jPanel69Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jComboBoxScreenModes, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel69Layout.createSequentialGroup()
                        .addComponent(jCheckBox64)
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel69Layout.setVerticalGroup(
            jPanel69Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel69Layout.createSequentialGroup()
                .addComponent(jLabel78)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jComboBoxScreenModes, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox64)
                .addGap(0, 87, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel64Layout = new javax.swing.GroupLayout(jPanel64);
        jPanel64.setLayout(jPanel64Layout);
        jPanel64Layout.setHorizontalGroup(
            jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel64Layout.createSequentialGroup()
                .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel64Layout.createSequentialGroup()
                        .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel64Layout.createSequentialGroup()
                                .addContainerGap()
                                .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jLabel84)
                                    .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                        .addComponent(jLabel87)
                                        .addGroup(jPanel64Layout.createSequentialGroup()
                                            .addComponent(jCheckBoxMSAA, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addGap(63, 63, 63)
                                            .addComponent(jLabel72)))))
                            .addComponent(jPanel48, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel64Layout.createSequentialGroup()
                                .addGap(45, 45, 45)
                                .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jComboBox8, javax.swing.GroupLayout.PREFERRED_SIZE, 68, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField28, javax.swing.GroupLayout.PREFERRED_SIZE, 68, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField29, javax.swing.GroupLayout.PREFERRED_SIZE, 68, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(61, 61, 61))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel64Layout.createSequentialGroup()
                                .addComponent(jTextField31, javax.swing.GroupLayout.PREFERRED_SIZE, 93, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(36, 36, 36))
                            .addComponent(jPanel65, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jPanel67, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel68, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel69, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                    .addGroup(jPanel64Layout.createSequentialGroup()
                        .addGap(12, 12, 12)
                        .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel85)
                            .addComponent(jCheckBox62)))
                    .addGroup(jPanel64Layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jCheckBoxMSAA1, javax.swing.GroupLayout.PREFERRED_SIZE, 146, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(54, Short.MAX_VALUE))
        );
        jPanel64Layout.setVerticalGroup(
            jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel64Layout.createSequentialGroup()
                .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel64Layout.createSequentialGroup()
                        .addComponent(jPanel67, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGap(1, 1, 1)
                        .addComponent(jPanel68, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jPanel65, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel48, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(0, 0, 0)
                .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel64Layout.createSequentialGroup()
                        .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel84)
                            .addComponent(jTextField28, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel72, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jCheckBoxMSAA))
                            .addComponent(jComboBox8, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel85)
                            .addComponent(jTextField29, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox62)
                        .addGap(8, 8, 8)
                        .addGroup(jPanel64Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel87)
                            .addComponent(jTextField31, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxMSAA1)
                        .addContainerGap(30, Short.MAX_VALUE))
                    .addComponent(jPanel69, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
        );

        jPanel66.setBorder(javax.swing.BorderFactory.createTitledBorder("non JOGL config only"));

        jCheckBoxGlow.setText("do glow");
        jCheckBoxGlow.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxGlowActionPerformed(evt);
            }
        });

        jCheckBox11.setText("use Quads");
        jCheckBox11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox11ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel66Layout = new javax.swing.GroupLayout(jPanel66);
        jPanel66.setLayout(jPanel66Layout);
        jPanel66Layout.setHorizontalGroup(
            jPanel66Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel66Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jCheckBoxGlow)
                .addGap(123, 123, 123)
                .addComponent(jCheckBox11)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel66Layout.setVerticalGroup(
            jPanel66Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel66Layout.createSequentialGroup()
                .addGroup(jPanel66Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxGlow)
                    .addComponent(jCheckBox11))
                .addGap(0, 22, Short.MAX_VALUE))
        );

        jPanel32.setBorder(javax.swing.BorderFactory.createTitledBorder("brightness"));

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

        javax.swing.GroupLayout jPanel32Layout = new javax.swing.GroupLayout(jPanel32);
        jPanel32.setLayout(jPanel32Layout);
        jPanel32Layout.setHorizontalGroup(
            jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderBrightness, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel32Layout.setVerticalGroup(
            jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSliderBrightness, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jLabel33.setText("display rotation");

        jComboBox5.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "0", "90", "180", "270" }));
        jComboBox5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox5ActionPerformed(evt);
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

        jSliderSplineMaxSize.setMajorTickSpacing(5000);
        jSliderSplineMaxSize.setMaximum(30000);
        jSliderSplineMaxSize.setMinimum(100);
        jSliderSplineMaxSize.setMinorTickSpacing(500);
        jSliderSplineMaxSize.setPaintTicks(true);
        jSliderSplineMaxSize.setToolTipText("Maximum Spline vector length (100 - 30000)");
        jSliderSplineMaxSize.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderSplineMaxSizeStateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel63Layout = new javax.swing.GroupLayout(jPanel63);
        jPanel63.setLayout(jPanel63Layout);
        jPanel63Layout.setHorizontalGroup(
            jPanel63Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel26, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel27, javax.swing.GroupLayout.DEFAULT_SIZE, 676, Short.MAX_VALUE)
            .addComponent(jPanel64, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel66, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel63Layout.createSequentialGroup()
                .addGroup(jPanel63Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel63Layout.createSequentialGroup()
                        .addComponent(jCheckBox1)
                        .addGap(88, 88, 88)
                        .addComponent(jLabel33)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jComboBox5, javax.swing.GroupLayout.PREFERRED_SIZE, 91, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel63Layout.createSequentialGroup()
                        .addGroup(jPanel63Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxJOGL)
                            .addGroup(jPanel63Layout.createSequentialGroup()
                                .addComponent(jCheckBox10)
                                .addGap(45, 45, 45)
                                .addComponent(jCheckBox26)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jSliderSplineDensity, javax.swing.GroupLayout.PREFERRED_SIZE, 137, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jSliderSplineMaxSize, javax.swing.GroupLayout.PREFERRED_SIZE, 137, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jPanel32, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel63Layout.createSequentialGroup()
                .addComponent(jCheckBox27)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel63Layout.setVerticalGroup(
            jPanel63Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel63Layout.createSequentialGroup()
                .addGap(1, 1, 1)
                .addGroup(jPanel63Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel63Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jCheckBox1)
                        .addComponent(jLabel33))
                    .addComponent(jComboBox5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel27, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel26, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(1, 1, 1)
                .addComponent(jPanel32, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(2, 2, 2)
                .addGroup(jPanel63Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel63Layout.createSequentialGroup()
                        .addGroup(jPanel63Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBox10)
                            .addComponent(jCheckBox26))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxJOGL))
                    .addGroup(jPanel63Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jSliderSplineMaxSize, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jSliderSplineDensity, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(2, 2, 2)
                .addComponent(jPanel64, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel66, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox27)
                .addContainerGap())
        );

        jTabbedPane1.addTab("Display", jPanel63);

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
            .addComponent(jSliderMultiStepDelay, javax.swing.GroupLayout.DEFAULT_SIZE, 666, Short.MAX_VALUE)
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

        jCheckBox50.setText("ROM and PC breakpoints switch on by default");
        jCheckBox50.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox50ActionPerformed(evt);
            }
        });

        jCheckBox6.setSelected(true);
        jCheckBox6.setText("vector information collection active");
        jCheckBox6.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jCheckBox6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox6ActionPerformed(evt);
            }
        });

        jCheckBox23.setText("ringbuffer active");
        jCheckBox23.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox23ActionPerformed(evt);
            }
        });

        jLabel36.setText("frame");

        jLabel1.setText("& single step rollback buffer");

        jTextFieldFrameBuffer.setText("2000");
        jTextFieldFrameBuffer.setToolTipText("Every 30000 cycles one state is saved in the frame buffer - up to this number. Approx. 50 = 1 second");
        jTextFieldFrameBuffer.setPreferredSize(new java.awt.Dimension(60, 20));
        jTextFieldFrameBuffer.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldFrameBufferFocusLost(evt);
            }
        });
        jTextFieldFrameBuffer.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldFrameBufferActionPerformed(evt);
            }
        });

        jTextFieldSingestepBuffer.setText("2000");
        jTextFieldSingestepBuffer.setToolTipText("Changes clear current buffer");
        jTextFieldSingestepBuffer.setPreferredSize(new java.awt.Dimension(60, 20));
        jTextFieldSingestepBuffer.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldSingestepBufferFocusLost(evt);
            }
        });
        jTextFieldSingestepBuffer.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldSingestepBufferActionPerformed(evt);
            }
        });

        jCheckBoxProfiler.setText("enable profiler");
        jCheckBoxProfiler.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxProfilerActionPerformed(evt);
            }
        });

        jLabel67.setFont(new java.awt.Font("Tahoma", 2, 11)); // NOI18N
        jLabel67.setText("(restart of vecx needed)");

        jCheckBox22.setText("codescan in Vecxi");
        jCheckBox22.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox22ActionPerformed(evt);
            }
        });

        jCheckBox65.setText("enable debuging core");
        jCheckBox65.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox65ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel22Layout = new javax.swing.GroupLayout(jPanel22);
        jPanel22.setLayout(jPanel22Layout);
        jPanel22Layout.setHorizontalGroup(
            jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel22Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addGroup(jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox65)
                    .addGroup(jPanel22Layout.createSequentialGroup()
                        .addGap(21, 21, 21)
                        .addGroup(jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldFrameBuffer, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel36))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldSingestepBuffer, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel22Layout.createSequentialGroup()
                                .addGap(1, 1, 1)
                                .addComponent(jLabel1))))
                    .addComponent(jCheckBox23)
                    .addComponent(jCheckBox6)
                    .addComponent(jCheckBox22)
                    .addComponent(jCheckBox8)
                    .addComponent(jCheckBox9)
                    .addComponent(jCheckBox24)
                    .addComponent(jCheckBox42)
                    .addGroup(jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addGroup(jPanel22Layout.createSequentialGroup()
                            .addComponent(jCheckBoxProfiler)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel67))
                        .addComponent(jCheckBox50)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel22Layout.setVerticalGroup(
            jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel22Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addComponent(jCheckBox65)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox8)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox9)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox24)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox42)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox50)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox22)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBoxProfiler)
                    .addComponent(jLabel67))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox6)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel22Layout.createSequentialGroup()
                        .addComponent(jCheckBox23)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel36)
                        .addGap(0, 0, 0)
                        .addComponent(jTextFieldFrameBuffer, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel22Layout.createSequentialGroup()
                        .addComponent(jLabel1)
                        .addGap(0, 0, 0)
                        .addComponent(jTextFieldSingestepBuffer, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(12, 12, 12)
                .addComponent(jPanel9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        jTabbedPane1.addTab("Debug", jPanel22);

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

        jCheckBox51.setText("PR access");
        jCheckBox51.setName("13"); // NOI18N
        jCheckBox51.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox51ActionPerformed(evt);
            }
        });

        jCheckBox52.setText("PR cycles");
        jCheckBox52.setName("14"); // NOI18N
        jCheckBox52.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox52ActionPerformed(evt);
            }
        });

        jCheckBox53.setText("PR cycles sum");
        jCheckBox53.setName("15"); // NOI18N
        jCheckBox53.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox53ActionPerformed(evt);
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
                    .addComponent(jCheckBox40)
                    .addComponent(jCheckBox51)
                    .addComponent(jCheckBox52)
                    .addComponent(jCheckBox53))
                .addContainerGap(565, Short.MAX_VALUE))
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
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox51)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox52)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox53)
                .addContainerGap(97, Short.MAX_VALUE))
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

        jCheckBox46.setText("force dissi iconized on \"Run\"");
        jCheckBox46.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox46ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel21Layout = new javax.swing.GroupLayout(jPanel21);
        jPanel21.setLayout(jPanel21Layout);
        jPanel21Layout.setHorizontalGroup(
            jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel21Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox3)
                    .addGroup(jPanel21Layout.createSequentialGroup()
                        .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox2)
                            .addComponent(jCheckBox21)
                            .addComponent(jCheckBox20)
                            .addComponent(jCheckBox4))
                        .addGap(95, 95, 95)
                        .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jPanel13, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBox46))))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jTabbedPane2)
        );
        jPanel21Layout.setVerticalGroup(
            jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel21Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox2)
                    .addComponent(jCheckBox46))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel21Layout.createSequentialGroup()
                        .addComponent(jCheckBox4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jCheckBox20)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox21)
                        .addGap(66, 66, 66)
                        .addComponent(jTabbedPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 510, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jPanel13, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 0, 0))
        );

        jTabbedPane1.addTab("Disassembler", jPanel21);

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

        jCheckBox45.setText("create cnt for unused symbols");
        jCheckBox45.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox45ActionPerformed(evt);
            }
        });

        jCheckBox48.setText("warn on define same symbol twice");
        jCheckBox48.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox48ActionPerformed(evt);
            }
        });

        jPanel62.setBorder(javax.swing.BorderFactory.createTitledBorder("Pretty print settings"));

        jTextField14.setText("80");
        jTextField14.setPreferredSize(new java.awt.Dimension(50, 21));
        jTextField14.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField14FocusLost(evt);
            }
        });
        jTextField14.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField14ActionPerformed(evt);
            }
        });
        jTextField14.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextField14PropertyChange(evt);
            }
        });
        jTextField14.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField14KeyTyped(evt);
            }
        });

        jTextField13.setText("80");
        jTextField13.setPreferredSize(new java.awt.Dimension(50, 21));
        jTextField13.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField13FocusLost(evt);
            }
        });
        jTextField13.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField13ActionPerformed(evt);
            }
        });
        jTextField13.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextField13PropertyChange(evt);
            }
        });
        jTextField13.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField13KeyTyped(evt);
            }
        });

        jLabel61.setText("EQU value");

        jLabel60.setText("EQU ");

        jTextField15.setText("80");
        jTextField15.setPreferredSize(new java.awt.Dimension(50, 21));
        jTextField15.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField15FocusLost(evt);
            }
        });
        jTextField15.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField15ActionPerformed(evt);
            }
        });
        jTextField15.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextField15PropertyChange(evt);
            }
        });
        jTextField15.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField15KeyTyped(evt);
            }
        });

        jTextField16.setText("80");
        jTextField16.setPreferredSize(new java.awt.Dimension(50, 21));
        jTextField16.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField16FocusLost(evt);
            }
        });
        jTextField16.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField16ActionPerformed(evt);
            }
        });
        jTextField16.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextField16PropertyChange(evt);
            }
        });
        jTextField16.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField16KeyTyped(evt);
            }
        });

        jLabel62.setText("Operand");

        jLabel63.setText("Mnemonic");

        jLabel64.setText("Comment");

        jTextFieldCommentIndent.setText("80");
        jTextFieldCommentIndent.setPreferredSize(new java.awt.Dimension(50, 21));
        jTextFieldCommentIndent.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldCommentIndentFocusLost(evt);
            }
        });
        jTextFieldCommentIndent.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldCommentIndentActionPerformed(evt);
            }
        });
        jTextFieldCommentIndent.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextFieldCommentIndentPropertyChange(evt);
            }
        });
        jTextFieldCommentIndent.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextFieldCommentIndentKeyTyped(evt);
            }
        });

        jLabel111.setText("Short");

        jTextField27.setText("1");
        jTextField27.setPreferredSize(new java.awt.Dimension(50, 21));
        jTextField27.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField27FocusLost(evt);
            }
        });
        jTextField27.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField27ActionPerformed(evt);
            }
        });
        jTextField27.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextField27PropertyChange(evt);
            }
        });
        jTextField27.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField27KeyTyped(evt);
            }
        });

        javax.swing.GroupLayout jPanel62Layout = new javax.swing.GroupLayout(jPanel62);
        jPanel62.setLayout(jPanel62Layout);
        jPanel62Layout.setHorizontalGroup(
            jPanel62Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel62Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel62Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel60)
                    .addComponent(jLabel61)
                    .addComponent(jLabel63)
                    .addComponent(jLabel62)
                    .addComponent(jLabel64)
                    .addComponent(jLabel111))
                .addGap(39, 39, 39)
                .addGroup(jPanel62Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField27, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField14, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField13, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField15, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField16, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldCommentIndent, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(148, Short.MAX_VALUE))
        );
        jPanel62Layout.setVerticalGroup(
            jPanel62Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel62Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel62Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel60)
                    .addComponent(jTextField14, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(8, 8, 8)
                .addGroup(jPanel62Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel61)
                    .addComponent(jTextField13, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel62Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel63)
                    .addComponent(jTextField15, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(8, 8, 8)
                .addGroup(jPanel62Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel62)
                    .addComponent(jTextField16, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel62Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel64)
                    .addComponent(jTextFieldCommentIndent, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel62Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel111)
                    .addComponent(jTextField27, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jCheckBoxDeepSyntaxCheck.setText("editor deep syntax check");
        jCheckBoxDeepSyntaxCheck.setToolTipText("<html>\n<P>\nIf enabled, the syntax check/coloring while editing extends to the complete current editor file<BR>\nwhile editing. With files >100000 bytes there is a noticable slowdown (delays) while editing. <BR>\n</P>\nIf disabled, than changing of variable/location names might sometimes not be correctly syntax highlighted<BR>in other places of the current document.\n</html>");
        jCheckBoxDeepSyntaxCheck.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxDeepSyntaxCheckActionPerformed(evt);
            }
        });

        jTextField18.setText("10000");
        jTextField18.setPreferredSize(new java.awt.Dimension(50, 21));
        jTextField18.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField18FocusLost(evt);
            }
        });
        jTextField18.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField18ActionPerformed(evt);
            }
        });
        jTextField18.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextField18PropertyChange(evt);
            }
        });
        jTextField18.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField18KeyTyped(evt);
            }
        });

        jLabel70.setText("deep syntax check intervall timer (in millseconds)");

        jCheckBoxDeepSyntaxThresholdActive.setText("editor deep syntax check threshold active");
        jCheckBoxDeepSyntaxThresholdActive.setToolTipText("<html>\n<P>\nSwitches deep syntax check off when a file is larger than given byte count.</P>\n</html>");
        jCheckBoxDeepSyntaxThresholdActive.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxDeepSyntaxThresholdActiveActionPerformed(evt);
            }
        });

        jLabel71.setText("deep syntax check threshold (in bytes)");

        jTextField19.setText("100000");
        jTextField19.setPreferredSize(new java.awt.Dimension(50, 21));
        jTextField19.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField19FocusLost(evt);
            }
        });
        jTextField19.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField19ActionPerformed(evt);
            }
        });
        jTextField19.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextField19PropertyChange(evt);
            }
        });
        jTextField19.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField19KeyTyped(evt);
            }
        });

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxDeepSyntaxCheck)
                            .addComponent(jPanel62, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBox15)
                            .addComponent(jCheckBox16)
                            .addComponent(jCheckBox25)
                            .addComponent(jCheckBox43)
                            .addComponent(jCheckBox45)
                            .addComponent(jCheckBox13)
                            .addComponent(jCheckBox48)
                            .addGroup(jPanel6Layout.createSequentialGroup()
                                .addGap(29, 29, 29)
                                .addComponent(jCheckBoxDeepSyntaxThresholdActive)))
                        .addContainerGap(350, Short.MAX_VALUE))
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel6Layout.createSequentialGroup()
                                .addGap(29, 29, 29)
                                .addComponent(jLabel71))
                            .addComponent(jLabel70))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jTextField18, javax.swing.GroupLayout.DEFAULT_SIZE, 95, Short.MAX_VALUE)
                            .addComponent(jTextField19, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addContainerGap(290, Short.MAX_VALUE))))
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
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox45)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox48)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jPanel62, javax.swing.GroupLayout.PREFERRED_SIZE, 202, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBoxDeepSyntaxCheck)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField18, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel70))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBoxDeepSyntaxThresholdActive)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField19, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel71))
                .addContainerGap())
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
        jButton4.setPreferredSize(new java.awt.Dimension(300, 21));
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });

        jButton5.setText("Download some ayfx files");
        jButton5.setPreferredSize(new java.awt.Dimension(300, 21));
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
        jTextFieldstart.setPreferredSize(new java.awt.Dimension(6, 21));
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

        jCheckBox47.setText("automatically eject attached VecFever on compile success");
        jCheckBox47.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox47ActionPerformed(evt);
            }
        });

        jCheckBox5.setSelected(true);
        jCheckBox5.setText("PSG Sound");
        jCheckBox5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox5ActionPerformed(evt);
            }
        });

        jLabel9.setText("Master volume:");

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

        buttonGroup2.add(jRadioButton3);
        jRadioButton3.setSelected(true);
        jRadioButton3.setText("old MAME PSG emulation");
        jRadioButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton3ActionPerformed(evt);
            }
        });

        buttonGroup2.add(jRadioButton4);
        jRadioButton4.setText("LibAYEmu PSG emulation");
        jRadioButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton4ActionPerformed(evt);
            }
        });

        jComboBox7.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "AY_Kay", "YM_Kay", "AY_Lion17", "YM_Lion17" }));
        jComboBox7.setToolTipText("Volume table used for emulation");
        jComboBox7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox7ActionPerformed(evt);
            }
        });

        jTextFieldPath.setToolTipText("For use in dissi only!");
        jTextFieldPath.setFocusable(false);
        jTextFieldPath.setPreferredSize(new java.awt.Dimension(6, 21));

        jButtonFileSelect2.setText("...");
        jButtonFileSelect2.setToolTipText("For use in dissi only!");
        jButtonFileSelect2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect2.setPreferredSize(new java.awt.Dimension(17, 21));
        jButtonFileSelect2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect2ActionPerformed(evt);
            }
        });

        jLabel37.setText("V4E");

        jPanel40.setBorder(javax.swing.BorderFactory.createTitledBorder("Vecci - colors"));

        jButtonVecciForeground.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonVecciForeground.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonVecciForeground.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonVecciForeground.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonVecciForegroundActionPerformed(evt);
            }
        });

        jPanel42.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel42.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel42Layout = new javax.swing.GroupLayout(jPanel42);
        jPanel42.setLayout(jPanel42Layout);
        jPanel42Layout.setHorizontalGroup(
            jPanel42Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel42Layout.setVerticalGroup(
            jPanel42Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel39.setText("foreground");

        jLabel40.setText("grid");

        jPanel43.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel43.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel43Layout = new javax.swing.GroupLayout(jPanel43);
        jPanel43.setLayout(jPanel43Layout);
        jPanel43Layout.setHorizontalGroup(
            jPanel43Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel43Layout.setVerticalGroup(
            jPanel43Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonVecciGrid.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonVecciGrid.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonVecciGrid.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonVecciGrid.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonVecciGridActionPerformed(evt);
            }
        });

        jButtonByteFrame.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonByteFrame.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonByteFrame.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonByteFrame.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonByteFrameActionPerformed(evt);
            }
        });

        jPanel44.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel44.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel44Layout = new javax.swing.GroupLayout(jPanel44);
        jPanel44.setLayout(jPanel44Layout);
        jPanel44Layout.setHorizontalGroup(
            jPanel44Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel44Layout.setVerticalGroup(
            jPanel44Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel41.setText("byteframe");

        jLabel42.setText("cross");

        jPanel45.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel45.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel45Layout = new javax.swing.GroupLayout(jPanel45);
        jPanel45.setLayout(jPanel45Layout);
        jPanel45Layout.setHorizontalGroup(
            jPanel45Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel45Layout.setVerticalGroup(
            jPanel45Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonCross.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonCross.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonCross.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonCross.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCrossActionPerformed(evt);
            }
        });

        jLabel43.setText("cross drag");

        jPanel46.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel46.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel46Layout = new javax.swing.GroupLayout(jPanel46);
        jPanel46.setLayout(jPanel46Layout);
        jPanel46Layout.setHorizontalGroup(
            jPanel46Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel46Layout.setVerticalGroup(
            jPanel46Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonCrossDrag.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonCrossDrag.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonCrossDrag.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonCrossDrag.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCrossDragActionPerformed(evt);
            }
        });

        jButtonRelative.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonRelative.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonRelative.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonRelative.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRelativeActionPerformed(evt);
            }
        });

        jPanel47.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel47.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel47Layout = new javax.swing.GroupLayout(jPanel47);
        jPanel47.setLayout(jPanel47Layout);
        jPanel47Layout.setHorizontalGroup(
            jPanel47Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel47Layout.setVerticalGroup(
            jPanel47Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel44.setText("vector relative");

        jLabel45.setText("vector highlite");

        jPanel49.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel49.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel49Layout = new javax.swing.GroupLayout(jPanel49);
        jPanel49.setLayout(jPanel49Layout);
        jPanel49Layout.setHorizontalGroup(
            jPanel49Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel49Layout.setVerticalGroup(
            jPanel49Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonHighlite.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonHighlite.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonHighlite.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonHighlite.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonHighliteActionPerformed(evt);
            }
        });

        jLabel46.setText("vector select");

        jPanel50.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel50.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel50Layout = new javax.swing.GroupLayout(jPanel50);
        jPanel50.setLayout(jPanel50Layout);
        jPanel50Layout.setHorizontalGroup(
            jPanel50Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel50Layout.setVerticalGroup(
            jPanel50Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonSelect.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonSelect.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonSelect.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonSelect.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSelectActionPerformed(evt);
            }
        });

        jLabel47.setText("point joined");

        jPanel51.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel51.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel51Layout = new javax.swing.GroupLayout(jPanel51);
        jPanel51.setLayout(jPanel51Layout);
        jPanel51Layout.setHorizontalGroup(
            jPanel51Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel51Layout.setVerticalGroup(
            jPanel51Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonPointJoined.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonPointJoined.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonPointJoined.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonPointJoined.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPointJoinedActionPerformed(evt);
            }
        });

        jLabel48.setText("point highlite");

        jPanel52.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel52.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel52Layout = new javax.swing.GroupLayout(jPanel52);
        jPanel52.setLayout(jPanel52Layout);
        jPanel52Layout.setHorizontalGroup(
            jPanel52Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel52Layout.setVerticalGroup(
            jPanel52Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonPointHighlite.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonPointHighlite.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonPointHighlite.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonPointHighlite.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPointHighliteActionPerformed(evt);
            }
        });

        jLabel49.setText("point selected");

        jPanel53.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel53.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel53Layout = new javax.swing.GroupLayout(jPanel53);
        jPanel53.setLayout(jPanel53Layout);
        jPanel53Layout.setHorizontalGroup(
            jPanel53Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel53Layout.setVerticalGroup(
            jPanel53Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonPointSelect.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonPointSelect.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonPointSelect.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonPointSelect.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPointSelectActionPerformed(evt);
            }
        });

        jLabel50.setText("vector pos");

        jPanel54.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel54.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel54Layout = new javax.swing.GroupLayout(jPanel54);
        jPanel54.setLayout(jPanel54Layout);
        jPanel54Layout.setHorizontalGroup(
            jPanel54Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel54Layout.setVerticalGroup(
            jPanel54Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonVectorPos.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonVectorPos.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonVectorPos.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonVectorPos.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonVectorPosActionPerformed(evt);
            }
        });

        jLabel51.setText("vector move");

        jPanel55.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel55.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel55Layout = new javax.swing.GroupLayout(jPanel55);
        jPanel55.setLayout(jPanel55Layout);
        jPanel55Layout.setHorizontalGroup(
            jPanel55Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel55Layout.setVerticalGroup(
            jPanel55Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonVectorMove.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonVectorMove.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonVectorMove.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonVectorMove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonVectorMoveActionPerformed(evt);
            }
        });

        jLabel52.setText("vector drag");

        jPanel56.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel56.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel56Layout = new javax.swing.GroupLayout(jPanel56);
        jPanel56.setLayout(jPanel56Layout);
        jPanel56Layout.setHorizontalGroup(
            jPanel56Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel56Layout.setVerticalGroup(
            jPanel56Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonVectorDrag.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonVectorDrag.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonVectorDrag.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonVectorDrag.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonVectorDragActionPerformed(evt);
            }
        });

        jButtonEndpoint.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonEndpoint.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonEndpoint.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonEndpoint.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonEndpointActionPerformed(evt);
            }
        });

        jPanel57.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel57.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel57Layout = new javax.swing.GroupLayout(jPanel57);
        jPanel57.setLayout(jPanel57Layout);
        jPanel57Layout.setHorizontalGroup(
            jPanel57Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel57Layout.setVerticalGroup(
            jPanel57Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel53.setText("endpoint");

        jButtonAreaDrag.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonAreaDrag.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonAreaDrag.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonAreaDrag.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAreaDragActionPerformed(evt);
            }
        });

        jPanel58.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel58.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel58Layout = new javax.swing.GroupLayout(jPanel58);
        jPanel58.setLayout(jPanel58Layout);
        jPanel58Layout.setHorizontalGroup(
            jPanel58Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel58Layout.setVerticalGroup(
            jPanel58Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel54.setText("area drag");

        jButtonxAxis.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonxAxis.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonxAxis.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonxAxis.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonxAxisActionPerformed(evt);
            }
        });

        jPanel59.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel59.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel59Layout = new javax.swing.GroupLayout(jPanel59);
        jPanel59.setLayout(jPanel59Layout);
        jPanel59Layout.setHorizontalGroup(
            jPanel59Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel59Layout.setVerticalGroup(
            jPanel59Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel55.setText("x axis");

        jLabel56.setText("y axis");

        jPanel60.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel60.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel60Layout = new javax.swing.GroupLayout(jPanel60);
        jPanel60.setLayout(jPanel60Layout);
        jPanel60Layout.setHorizontalGroup(
            jPanel60Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel60Layout.setVerticalGroup(
            jPanel60Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonyAxis.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonyAxis.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonyAxis.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonyAxis.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonyAxisActionPerformed(evt);
            }
        });

        jLabel57.setText("z axis");

        jPanel61.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel61.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel61Layout = new javax.swing.GroupLayout(jPanel61);
        jPanel61.setLayout(jPanel61Layout);
        jPanel61Layout.setHorizontalGroup(
            jPanel61Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel61Layout.setVerticalGroup(
            jPanel61Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonzAxis.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonzAxis.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonzAxis.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonzAxis.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonzAxisActionPerformed(evt);
            }
        });

        jLabel58.setFont(new java.awt.Font("Tahoma", 2, 11)); // NOI18N
        jLabel58.setText("Some values will be set only");

        jLabel59.setFont(new java.awt.Font("Tahoma", 2, 11)); // NOI18N
        jLabel59.setText("with a new Vecci instance.");

        jLabel65.setFont(new java.awt.Font("Tahoma", 2, 11)); // NOI18N
        jLabel65.setText("Colors with alpha-channel are ");

        jLabel66.setFont(new java.awt.Font("Tahoma", 2, 11)); // NOI18N
        jLabel66.setText("drawn very inefficiently!");

        jLabel38.setText("background");

        jPanel41.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel41.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel41Layout = new javax.swing.GroupLayout(jPanel41);
        jPanel41.setLayout(jPanel41Layout);
        jPanel41Layout.setHorizontalGroup(
            jPanel41Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel41Layout.setVerticalGroup(
            jPanel41Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonVecciBackground.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonVecciBackground.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonVecciBackground.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonVecciBackground.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRegChanges(evt);
            }
        });

        javax.swing.GroupLayout jPanel40Layout = new javax.swing.GroupLayout(jPanel40);
        jPanel40.setLayout(jPanel40Layout);
        jPanel40Layout.setHorizontalGroup(
            jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel40Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonVecciBackground, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel41, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel38, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonVecciForeground, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel42, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel39, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonVecciGrid, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel43, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel40, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonByteFrame, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel44, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel41, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonCross, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel45, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel42, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonCrossDrag, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel46, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel43, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonRelative, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel47, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel44, javax.swing.GroupLayout.DEFAULT_SIZE, 101, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel40Layout.createSequentialGroup()
                            .addComponent(jButtonSelect, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGap(5, 5, 5)
                            .addComponent(jPanel50, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                            .addComponent(jLabel46, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel40Layout.createSequentialGroup()
                            .addComponent(jButtonHighlite, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGap(5, 5, 5)
                            .addComponent(jPanel49, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                            .addComponent(jLabel45, javax.swing.GroupLayout.DEFAULT_SIZE, 91, Short.MAX_VALUE)))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonPointJoined, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel51, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel47, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonPointHighlite, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel52, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel48, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonPointSelect, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel53, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel49, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonVectorDrag, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel56, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel52, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonVectorPos, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel54, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel50, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonVectorMove, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel55, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel51, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonEndpoint, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel57, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel53, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonAreaDrag, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel58, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel54, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonxAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel59, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel55, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonyAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel60, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel56, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jButtonzAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jPanel61, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel57, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jLabel58)
                    .addComponent(jLabel59)
                    .addComponent(jLabel65)
                    .addComponent(jLabel66))
                .addContainerGap(28, Short.MAX_VALUE))
        );
        jPanel40Layout.setVerticalGroup(
            jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel40Layout.createSequentialGroup()
                .addContainerGap(30, Short.MAX_VALUE)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jButtonVecciBackground, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jPanel41, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel38, javax.swing.GroupLayout.Alignment.TRAILING))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel42, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel39)
                        .addComponent(jButtonVecciForeground, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(6, 6, 6)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel43, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel40)
                        .addComponent(jButtonVecciGrid, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(6, 6, 6)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel44, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel41)
                        .addComponent(jButtonByteFrame, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel45, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel42)
                        .addComponent(jButtonCross, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel46, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel43)
                        .addComponent(jButtonCrossDrag, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel47, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel44)
                        .addComponent(jButtonRelative, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel49, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel45)
                        .addComponent(jButtonHighlite, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel50, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel46)
                        .addComponent(jButtonSelect, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel56, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel52)
                        .addComponent(jButtonVectorDrag, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel54, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel50)
                        .addComponent(jButtonVectorPos, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel55, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonVectorMove, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel51, javax.swing.GroupLayout.Alignment.TRAILING))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel51, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel47)
                        .addComponent(jButtonPointJoined, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel52, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel48)
                        .addComponent(jButtonPointHighlite, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel53, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel49)
                        .addComponent(jButtonPointSelect, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel57, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel53)
                        .addComponent(jButtonEndpoint, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel58, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel54)
                        .addComponent(jButtonAreaDrag, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel59, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel55)
                        .addComponent(jButtonxAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel60, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel56)
                        .addComponent(jButtonyAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel61, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel57)
                        .addComponent(jButtonzAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel58)
                .addGap(2, 2, 2)
                .addComponent(jLabel59, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel65)
                .addGap(2, 2, 2)
                .addComponent(jLabel66)
                .addContainerGap())
        );

        jCheckBoxStarterImages.setText("load images in starter (takes time!)");
        jCheckBoxStarterImages.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxStarterImagesActionPerformed(evt);
            }
        });

        jButton6.setText("import chassis from ParaJVE");
        jButton6.setEnabled(false);
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6ActionPerformed(evt);
            }
        });

        jLabel79.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel79.setText("File: \"ParaJVE_0.7.0_windows.zip\" must be in \"tmp\"-directory");
        jLabel79.setEnabled(false);

        jCheckBoxStarterImages1.setText("MOTD active");
        jCheckBoxStarterImages1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxStarterImages1ActionPerformed(evt);
            }
        });

        jButtonPre1.setText("peep config");
        jButtonPre1.setPreferredSize(new java.awt.Dimension(90, 21));
        jButtonPre1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPre1ActionPerformed(evt);
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
                        .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox17)
                            .addComponent(jRadioButton3)
                            .addGroup(jPanel8Layout.createSequentialGroup()
                                .addComponent(jRadioButton4)
                                .addGap(35, 35, 35)
                                .addComponent(jComboBox7, javax.swing.GroupLayout.PREFERRED_SIZE, 116, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                .addComponent(jButton4, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jButton5, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, 300, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel79, javax.swing.GroupLayout.PREFERRED_SIZE, 347, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel8Layout.createSequentialGroup()
                                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPanel8Layout.createSequentialGroup()
                                        .addComponent(jLabel32)
                                        .addGap(47, 47, 47)
                                        .addComponent(jTextFieldstart, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButtonFileSelect1))
                                    .addGroup(jPanel8Layout.createSequentialGroup()
                                        .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jCheckBoxScanForVectorLists)
                                            .addComponent(jCheckBoxStarterImages)
                                            .addComponent(jCheckBoxStarterImages1))
                                        .addGap(0, 0, Short.MAX_VALUE)))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .addGroup(jPanel8Layout.createSequentialGroup()
                                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jSliderPSGVolume, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jCheckBox5)
                                    .addComponent(jLabel9)
                                    .addComponent(jSliderMasterVolume, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel15)
                                    .addComponent(jCheckBox19)
                                    .addComponent(jCheckBox18)
                                    .addGroup(jPanel8Layout.createSequentialGroup()
                                        .addComponent(jLabel37)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jTextFieldPath, javax.swing.GroupLayout.PREFERRED_SIZE, 145, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButtonFileSelect2, javax.swing.GroupLayout.PREFERRED_SIZE, 13, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addComponent(jCheckBox47, javax.swing.GroupLayout.PREFERRED_SIZE, 367, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 46, Short.MAX_VALUE))
                            .addGroup(jPanel8Layout.createSequentialGroup()
                                .addComponent(jButtonPre1, javax.swing.GroupLayout.PREFERRED_SIZE, 146, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                        .addComponent(jPanel40, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(38, 38, 38))))
        );
        jPanel8Layout.setVerticalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addComponent(jCheckBox17)
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBox18)
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBox19)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxScanForVectorLists)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxStarterImages)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxStarterImages1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButtonPre1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(13, 13, 13)
                        .addComponent(jCheckBox47)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldPath, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonFileSelect2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel37))
                        .addGap(30, 30, 30)
                        .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel32)
                                .addComponent(jTextFieldstart, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jButtonFileSelect1))
                        .addGap(45, 45, 45)
                        .addComponent(jCheckBox5)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel9)
                        .addGap(0, 0, 0)
                        .addComponent(jSliderMasterVolume, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel15)
                        .addGap(2, 2, 2)
                        .addComponent(jSliderPSGVolume, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(63, 63, 63)
                        .addComponent(jRadioButton3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jRadioButton4)
                            .addComponent(jComboBox7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(41, 41, 41)
                        .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButton6))
                    .addComponent(jPanel40, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(6, 6, 6)
                .addComponent(jLabel79)
                .addContainerGap(128, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Miscellaneous ", jPanel8);

        keyBindingsJPanel1.setPreferredSize(new java.awt.Dimension(100, 100));

        javax.swing.GroupLayout jPanel14Layout = new javax.swing.GroupLayout(jPanel14);
        jPanel14.setLayout(jPanel14Layout);
        jPanel14Layout.setHorizontalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel14Layout.createSequentialGroup()
                .addComponent(keyBindingsJPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );
        jPanel14Layout.setVerticalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel14Layout.createSequentialGroup()
                .addComponent(keyBindingsJPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 818, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Keyboard", jPanel14);

        jLabel10.setText("Tinylaf theme");

        jTextField7.setPreferredSize(new java.awt.Dimension(6, 21));
        jTextField7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField7ActionPerformed(evt);
            }
        });

        jButtonLoad.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad.setToolTipText("load vectorlist");
        jButtonLoad.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoadActionPerformed(evt);
            }
        });

        jButtonLAF.setText("LAF - edit");
        jButtonLAF.setPreferredSize(new java.awt.Dimension(79, 21));
        jButtonLAF.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLAFActionPerformed(evt);
            }
        });

        jLabel91.setText("Tab-Width");

        jTextFieldTabWidth.setText("4");
        jTextFieldTabWidth.setPreferredSize(new java.awt.Dimension(50, 21));
        jTextFieldTabWidth.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldTabWidthFocusLost(evt);
            }
        });
        jTextFieldTabWidth.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldTabWidthActionPerformed(evt);
            }
        });
        jTextFieldTabWidth.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jTextFieldTabWidthPropertyChange(evt);
            }
        });
        jTextFieldTabWidth.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextFieldTabWidthKeyTyped(evt);
            }
        });

        jLabel92.setText("Syntax highlighting fonts/colors");

        jPanel70.setBorder(javax.swing.BorderFactory.createTitledBorder("Other colors"));

        jButtonRegUnChanged.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonRegUnChanged.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonRegUnChanged.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonRegUnChanged.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRegUnChangedActionPerformed(evt);
            }
        });

        jPanel71.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel71.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel71Layout = new javax.swing.GroupLayout(jPanel71);
        jPanel71.setLayout(jPanel71Layout);
        jPanel71Layout.setHorizontalGroup(
            jPanel71Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel71Layout.setVerticalGroup(
            jPanel71Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel93.setText("register unchanged");
        jLabel93.setToolTipText("unchanged registers");

        jButtonPSGA.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonPSGA.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonPSGA.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonPSGA.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPSGAActionPerformed(evt);
            }
        });

        jButtonPSGB.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonPSGB.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonPSGB.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonPSGB.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPSGBActionPerformed(evt);
            }
        });

        jPanel72.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel72.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel72Layout = new javax.swing.GroupLayout(jPanel72);
        jPanel72.setLayout(jPanel72Layout);
        jPanel72Layout.setHorizontalGroup(
            jPanel72Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel72Layout.setVerticalGroup(
            jPanel72Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jPanel73.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel73.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel73Layout = new javax.swing.GroupLayout(jPanel73);
        jPanel73.setLayout(jPanel73Layout);
        jPanel73Layout.setHorizontalGroup(
            jPanel73Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel73Layout.setVerticalGroup(
            jPanel73Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel94.setText("PSG Voice 1");

        jLabel95.setText("PSG Voice 2");

        jButtonVecciBackground4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonVecciBackground4.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonVecciBackground4.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonVecciBackground4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonVecciPSGC(evt);
            }
        });

        jPanel74.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel74.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel74Layout = new javax.swing.GroupLayout(jPanel74);
        jPanel74.setLayout(jPanel74Layout);
        jPanel74Layout.setHorizontalGroup(
            jPanel74Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel74Layout.setVerticalGroup(
            jPanel74Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jButtonVecciBackground5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonVecciBackground5.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonVecciBackground5.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonVecciBackground5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPSGNoise(evt);
            }
        });

        jPanel75.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel75.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel75Layout = new javax.swing.GroupLayout(jPanel75);
        jPanel75.setLayout(jPanel75Layout);
        jPanel75Layout.setHorizontalGroup(
            jPanel75Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel75Layout.setVerticalGroup(
            jPanel75Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel96.setText("PSG Voice 3");

        jLabel97.setText("PSG Noise");

        jButtontableAddress.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtontableAddress.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtontableAddress.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtontableAddress.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtontableAddressActionPerformed(evt);
            }
        });

        jPanel76.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel76.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel76Layout = new javax.swing.GroupLayout(jPanel76);
        jPanel76.setLayout(jPanel76Layout);
        jPanel76Layout.setHorizontalGroup(
            jPanel76Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel76Layout.setVerticalGroup(
            jPanel76Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel98.setText("table address color");
        jLabel98.setToolTipText("color of the address column in tables");

        jButtontableBIOS.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtontableBIOS.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtontableBIOS.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtontableBIOS.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtontableBIOSActionPerformed(evt);
            }
        });

        jPanel78.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel78.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel78Layout = new javax.swing.GroupLayout(jPanel78);
        jPanel78.setLayout(jPanel78Layout);
        jPanel78Layout.setHorizontalGroup(
            jPanel78Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel78Layout.setVerticalGroup(
            jPanel78Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel99.setText("dissi BIOS color");
        jLabel99.setToolTipText("color of the BIOS data in table");

        jButtontableBank.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtontableBank.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtontableBank.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtontableBank.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtontableBankActionPerformed(evt);
            }
        });

        jPanel79.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel79.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel79Layout = new javax.swing.GroupLayout(jPanel79);
        jPanel79.setLayout(jPanel79Layout);
        jPanel79Layout.setHorizontalGroup(
            jPanel79Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel79Layout.setVerticalGroup(
            jPanel79Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel100.setText("dissi Bank");
        jLabel100.setToolTipText("color of bank>0 in table");

        jButtonHTMLLink.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonHTMLLink.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonHTMLLink.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonHTMLLink.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonHTMLLinkActionPerformed(evt);
            }
        });

        jPanel80.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel80.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel80Layout = new javax.swing.GroupLayout(jPanel80);
        jPanel80.setLayout(jPanel80Layout);
        jPanel80Layout.setHorizontalGroup(
            jPanel80Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel80Layout.setVerticalGroup(
            jPanel80Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel101.setText("html link");

        jButtonVecciBackground10.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonVecciBackground10.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonVecciBackground10.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonVecciBackground10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonVecciBackground10ActionPerformed(evt);
            }
        });

        jPanel81.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel81.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel81Layout = new javax.swing.GroupLayout(jPanel81);
        jPanel81.setLayout(jPanel81Layout);
        jPanel81Layout.setHorizontalGroup(
            jPanel81Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel81Layout.setVerticalGroup(
            jPanel81Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel102.setText("all edit BG");

        jButtonRegChanged.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonRegChanged.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonRegChanged.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonRegChanged.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRegChangedActionPerformed(evt);
            }
        });

        jPanel77.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel77.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel77Layout = new javax.swing.GroupLayout(jPanel77);
        jPanel77.setLayout(jPanel77Layout);
        jPanel77Layout.setHorizontalGroup(
            jPanel77Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel77Layout.setVerticalGroup(
            jPanel77Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel103.setText("register changed");
        jLabel103.setToolTipText("changed registers");

        jButtonHTMLText.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonHTMLText.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonHTMLText.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonHTMLText.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonHTMLTextActionPerformed(evt);
            }
        });

        jPanel82.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel82.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel82Layout = new javax.swing.GroupLayout(jPanel82);
        jPanel82.setLayout(jPanel82Layout);
        jPanel82Layout.setHorizontalGroup(
            jPanel82Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel82Layout.setVerticalGroup(
            jPanel82Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel104.setText("html text");

        jLabel105.setFont(new java.awt.Font("Tahoma", 2, 11)); // NOI18N
        jLabel105.setText("Some values will be set only with new instances.  ");

        jButtontableIOInput.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtontableIOInput.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtontableIOInput.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtontableIOInput.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtontableIOInputActionPerformed(evt);
            }
        });

        jPanel83.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel83.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel83Layout = new javax.swing.GroupLayout(jPanel83);
        jPanel83.setLayout(jPanel83Layout);
        jPanel83Layout.setHorizontalGroup(
            jPanel83Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel83Layout.setVerticalGroup(
            jPanel83Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel107.setText("IO input");
        jLabel107.setToolTipText("VIA input ");

        jButtonIOOutput.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonIOOutput.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonIOOutput.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonIOOutput.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonIOOutputActionPerformed(evt);
            }
        });

        jPanel84.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel84.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel84Layout = new javax.swing.GroupLayout(jPanel84);
        jPanel84.setLayout(jPanel84Layout);
        jPanel84Layout.setHorizontalGroup(
            jPanel84Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel84Layout.setVerticalGroup(
            jPanel84Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel108.setText("IO output");
        jLabel108.setToolTipText("VIA output");

        jButtonTabelSelection.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonTabelSelection.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonTabelSelection.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonTabelSelection.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonTabelSelectionActionPerformed(evt);
            }
        });

        jPanel85.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel85.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel85Layout = new javax.swing.GroupLayout(jPanel85);
        jPanel85.setLayout(jPanel85Layout);
        jPanel85Layout.setHorizontalGroup(
            jPanel85Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel85Layout.setVerticalGroup(
            jPanel85Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel109.setText("table selection");
        jLabel109.setToolTipText("Selection in memory dump table");

        jButtonVecciBackground6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonVecciBackground6.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonVecciBackground6.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonVecciBackground6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonVecciBackground6jButtonVecciPSGC(evt);
            }
        });

        jButtonVecciBackground7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_swatch.png"))); // NOI18N
        jButtonVecciBackground7.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonVecciBackground7.setPreferredSize(new java.awt.Dimension(19, 19));
        jButtonVecciBackground7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonVecciBackground7jButtonPSGNoise(evt);
            }
        });

        jPanel86.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel86.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel86Layout = new javax.swing.GroupLayout(jPanel86);
        jPanel86.setLayout(jPanel86Layout);
        jPanel86Layout.setHorizontalGroup(
            jPanel86Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel86Layout.setVerticalGroup(
            jPanel86Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jPanel87.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel87.setPreferredSize(new java.awt.Dimension(20, 20));

        javax.swing.GroupLayout jPanel87Layout = new javax.swing.GroupLayout(jPanel87);
        jPanel87.setLayout(jPanel87Layout);
        jPanel87Layout.setHorizontalGroup(
            jPanel87Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );
        jPanel87Layout.setVerticalGroup(
            jPanel87Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 16, Short.MAX_VALUE)
        );

        jLabel106.setText("C-lines in dissi (back)");

        jLabel110.setText("C-lines in dissi (fore)");

        javax.swing.GroupLayout jPanel70Layout = new javax.swing.GroupLayout(jPanel70);
        jPanel70.setLayout(jPanel70Layout);
        jPanel70Layout.setHorizontalGroup(
            jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel70Layout.createSequentialGroup()
                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel70Layout.createSequentialGroup()
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonRegChanged, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonRegUnChanged, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtontableAddress, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtontableBIOS, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtontableBank, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtontableIOInput, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonIOOutput, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonTabelSelection, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPanel70Layout.createSequentialGroup()
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jPanel71, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGap(18, 18, 18)
                                    .addComponent(jLabel93, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel70Layout.createSequentialGroup()
                                    .addGap(5, 5, 5)
                                    .addComponent(jPanel76, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                    .addComponent(jLabel98, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(jPanel70Layout.createSequentialGroup()
                                .addGap(5, 5, 5)
                                .addComponent(jPanel78, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel99, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel70Layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jPanel77, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel103, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel70Layout.createSequentialGroup()
                        .addGap(24, 24, 24)
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel70Layout.createSequentialGroup()
                                .addComponent(jPanel85, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel109, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                                .addGap(60, 60, 60))
                            .addGroup(jPanel70Layout.createSequentialGroup()
                                .addComponent(jPanel84, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel108, javax.swing.GroupLayout.PREFERRED_SIZE, 102, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))))
                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonPSGA, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonPSGB, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonVecciBackground4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonVecciBackground5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonVecciBackground6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonVecciBackground7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel86, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel87, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel75, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel74, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel72, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel73, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel110, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel106, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel97, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel96, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel95, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel94, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonVecciBackground10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonHTMLText, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonHTMLLink, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(5, 5, 5)
                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel81, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel82, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel80, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel102, javax.swing.GroupLayout.PREFERRED_SIZE, 112, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel104, javax.swing.GroupLayout.PREFERRED_SIZE, 102, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel101, javax.swing.GroupLayout.PREFERRED_SIZE, 102, javax.swing.GroupLayout.PREFERRED_SIZE)))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel70Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel105, javax.swing.GroupLayout.PREFERRED_SIZE, 340, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(133, 133, 133))
            .addGroup(jPanel70Layout.createSequentialGroup()
                .addGap(24, 24, 24)
                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel70Layout.createSequentialGroup()
                        .addComponent(jPanel83, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel107, javax.swing.GroupLayout.PREFERRED_SIZE, 102, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(jPanel70Layout.createSequentialGroup()
                        .addComponent(jPanel79, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel100, javax.swing.GroupLayout.PREFERRED_SIZE, 102, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(502, 502, 502))))
        );
        jPanel70Layout.setVerticalGroup(
            jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel70Layout.createSequentialGroup()
                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel70Layout.createSequentialGroup()
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jPanel73, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel94, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel102, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jPanel81, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jButtonVecciBackground10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel70Layout.createSequentialGroup()
                                .addGap(1, 1, 1)
                                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jButtonRegChanged, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jPanel77, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                        .addComponent(jLabel103)
                                        .addComponent(jButtonPSGA, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel70Layout.createSequentialGroup()
                                .addGap(6, 6, 6)
                                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jLabel95)
                                    .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addComponent(jPanel72, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                            .addComponent(jLabel93)
                                            .addComponent(jButtonPSGB, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                            .addGroup(jPanel70Layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jButtonRegUnChanged, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jPanel71, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jPanel74, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel96, javax.swing.GroupLayout.Alignment.TRAILING)
                                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addComponent(jPanel76, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                            .addComponent(jLabel98)
                                            .addComponent(jButtontableAddress, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addComponent(jButtonVecciBackground4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jButtonHTMLText, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jPanel82, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel104))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel97)
                            .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jPanel75, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addComponent(jPanel78, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                            .addComponent(jLabel99)
                                            .addComponent(jButtontableBIOS, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addComponent(jButtonVecciBackground5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jButtonHTMLLink, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jPanel80, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel101))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtontableBank, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jPanel79, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addComponent(jLabel100))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jButtontableIOInput, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jPanel83, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel107))
                .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel70Layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jPanel87, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel106, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jButtonVecciBackground6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel110)
                            .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jPanel86, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jButtonVecciBackground7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel105))
                    .addGroup(jPanel70Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jButtonIOOutput, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jPanel84, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel108))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel70Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jButtonTabelSelection, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jPanel85, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel109))
                        .addGap(0, 19, Short.MAX_VALUE))))
        );

        javax.swing.GroupLayout jPanel15Layout = new javax.swing.GroupLayout(jPanel15);
        jPanel15.setLayout(jPanel15Layout);
        jPanel15Layout.setHorizontalGroup(
            jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(styleJPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel70, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel15Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel15Layout.createSequentialGroup()
                        .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel10)
                            .addComponent(jLabel91))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldTabWidth, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel15Layout.createSequentialGroup()
                                .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, 203, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonLoad)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonLAF, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addComponent(jLabel92))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel15Layout.setVerticalGroup(
            jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel15Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextFieldTabWidth, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel91))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonLoad)
                    .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel10)
                        .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButtonLAF, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addComponent(jLabel92)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(styleJPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 383, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel70, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(83, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("GUI", jPanel15);

        jLabel16.setText("Vectrex device");

        jComboBox4.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Joystick", " " }));
        jComboBox4.setPreferredSize(new java.awt.Dimension(104, 21));
        jComboBox4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox4ActionPerformed(evt);
            }
        });

        jLabel21.setText("device name");

        jTextField8.setPreferredSize(new java.awt.Dimension(104, 21));

        jLabel26.setText("device");

        jComboBoxJoystickConfigurations.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxJoystickConfigurations.setPreferredSize(new java.awt.Dimension(104, 21));
        jComboBoxJoystickConfigurations.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxJoystickConfigurationsActionPerformed(evt);
            }
        });

        jButtonSave.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/disk_add.png"))); // NOI18N
        jButtonSave.setToolTipText("add controller config");
        jButtonSave.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveActionPerformed(evt);
            }
        });

        jButtonDelete1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/delete.png"))); // NOI18N
        jButtonDelete1.setToolTipText("delete selected controller configuration");
        jButtonDelete1.setMargin(new java.awt.Insets(0, 1, 0, -1));
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
        jTextField9.setPreferredSize(new java.awt.Dimension(0, 21));
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
        jTextField10.setPreferredSize(new java.awt.Dimension(0, 21));
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

        jLabel22.setText("X-Axis digital");

        jLabel17.setText("button 1");

        jToggleButton1.setText("1");
        jToggleButton1.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton1.setName("1"); // NOI18N
        jToggleButton1.setPreferredSize(new java.awt.Dimension(104, 21));
        jToggleButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton1ActionPerformed(evt);
            }
        });

        jToggleButton2.setText("2");
        jToggleButton2.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton2.setName("2"); // NOI18N
        jToggleButton2.setPreferredSize(new java.awt.Dimension(104, 21));
        jToggleButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton2ActionPerformed(evt);
            }
        });

        jLabel18.setText("button 2");

        jToggleButton3.setText("3");
        jToggleButton3.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton3.setName("3"); // NOI18N
        jToggleButton3.setPreferredSize(new java.awt.Dimension(104, 21));
        jToggleButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton3ActionPerformed(evt);
            }
        });

        jLabel19.setText("button 3");

        jToggleButton4.setText("4");
        jToggleButton4.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton4.setName("4"); // NOI18N
        jToggleButton4.setPreferredSize(new java.awt.Dimension(104, 21));
        jToggleButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton4ActionPerformed(evt);
            }
        });

        jLabel20.setText("button 4");

        jToggleButton5.setText("left");
        jToggleButton5.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton5.setName("left"); // NOI18N
        jToggleButton5.setPreferredSize(new java.awt.Dimension(0, 21));
        jToggleButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton5ActionPerformed(evt);
            }
        });

        jToggleButton6.setText("right");
        jToggleButton6.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton6.setName("right"); // NOI18N
        jToggleButton6.setPreferredSize(new java.awt.Dimension(0, 21));
        jToggleButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton6ActionPerformed(evt);
            }
        });

        jLabel23.setText("Y-Axis digital ");

        jToggleButton7.setText("up");
        jToggleButton7.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton7.setName("up"); // NOI18N
        jToggleButton7.setPreferredSize(new java.awt.Dimension(0, 21));
        jToggleButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton7ActionPerformed(evt);
            }
        });

        jToggleButton8.setText("down");
        jToggleButton8.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton8.setName("down"); // NOI18N
        jToggleButton8.setPreferredSize(new java.awt.Dimension(0, 21));
        jToggleButton8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton8ActionPerformed(evt);
            }
        });

        jLabel24.setText("X analog");

        jToggleButton9.setText("horizontal");
        jToggleButton9.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton9.setName("horizontal"); // NOI18N
        jToggleButton9.setPreferredSize(new java.awt.Dimension(150, 21));
        jToggleButton9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton9ActionPerformed(evt);
            }
        });

        jLabel25.setText("Y analog");

        jToggleButton10.setText("vertical");
        jToggleButton10.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jToggleButton10.setName("vertical"); // NOI18N
        jToggleButton10.setPreferredSize(new java.awt.Dimension(150, 21));
        jToggleButton10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton10ActionPerformed(evt);
            }
        });

        jCheckBoxMouseMode.setText("Mouse mode");
        jCheckBoxMouseMode.setToolTipText("Translates mouse coordinates on vecxi window to analog values");
        jCheckBoxMouseMode.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxMouseModeActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel23Layout = new javax.swing.GroupLayout(jPanel23);
        jPanel23.setLayout(jPanel23Layout);
        jPanel23Layout.setHorizontalGroup(
            jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel23Layout.createSequentialGroup()
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addGap(109, 109, 109)
                        .addComponent(inputControllerDisplay1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jLabel29)
                            .addComponent(jLabel30)
                            .addGroup(jPanel23Layout.createSequentialGroup()
                                .addComponent(jLabel26, javax.swing.GroupLayout.DEFAULT_SIZE, 79, Short.MAX_VALUE)
                                .addGap(151, 151, 151)))))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel23Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jTextField10, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, 74, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel17)
                            .addComponent(jLabel19)
                            .addComponent(jLabel18)
                            .addComponent(jLabel20)
                            .addComponent(jLabel21)
                            .addComponent(jLabel16))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel23Layout.createSequentialGroup()
                                .addComponent(jComboBoxJoystickConfigurations, javax.swing.GroupLayout.PREFERRED_SIZE, 254, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jButtonNew)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonSave)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonDelete1))
                            .addComponent(jTextField8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(jPanel23Layout.createSequentialGroup()
                                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addGroup(jPanel23Layout.createSequentialGroup()
                                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                                .addComponent(jToggleButton1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 66, Short.MAX_VALUE)
                                                .addComponent(jToggleButton2, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 1, Short.MAX_VALUE))
                                            .addComponent(jToggleButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 66, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 66, javax.swing.GroupLayout.PREFERRED_SIZE))
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jLabel22)
                                            .addComponent(jLabel23)
                                            .addComponent(jLabel25)
                                            .addComponent(jLabel24))
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addGroup(jPanel23Layout.createSequentialGroup()
                                                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                                    .addComponent(jToggleButton5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                                    .addComponent(jToggleButton7, javax.swing.GroupLayout.PREFERRED_SIZE, 97, javax.swing.GroupLayout.PREFERRED_SIZE))
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                                    .addComponent(jToggleButton8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                                    .addComponent(jToggleButton6, javax.swing.GroupLayout.PREFERRED_SIZE, 98, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                            .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                                .addComponent(jToggleButton9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                                .addComponent(jToggleButton10, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE))))
                                    .addGroup(jPanel23Layout.createSequentialGroup()
                                        .addComponent(jComboBox4, javax.swing.GroupLayout.PREFERRED_SIZE, 268, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jCheckBoxMouseMode, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                                .addGap(0, 0, Short.MAX_VALUE)))))
                .addGap(262, 262, 262)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jLabel28, javax.swing.GroupLayout.DEFAULT_SIZE, 50, Short.MAX_VALUE)
                    .addComponent(jLabel27, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(134, 134, 134))
        );
        jPanel23Layout.setVerticalGroup(
            jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel23Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel29)
                    .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel30)
                    .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jComboBoxJoystickConfigurations, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel26))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel21))
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addGap(8, 8, 8)
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jButtonSave)
                            .addComponent(jButtonDelete1)
                            .addComponent(jButtonNew))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel16)
                    .addComponent(jComboBox4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxMouseMode))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel23Layout.createSequentialGroup()
                                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel17)
                                    .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(6, 6, 6)
                                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel18)
                                    .addComponent(jToggleButton2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(6, 6, 6)
                                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel19)
                                    .addComponent(jToggleButton3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addComponent(jLabel28, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel20)
                                .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel27, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel22)
                            .addComponent(jToggleButton5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jToggleButton6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel23)
                            .addComponent(jToggleButton7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jToggleButton8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel25)
                            .addComponent(jToggleButton10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel24)
                            .addComponent(jToggleButton9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(inputControllerDisplay1, javax.swing.GroupLayout.PREFERRED_SIZE, 497, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        jTabbedPane1.addTab("Input", jPanel23);

        jScrollPane1.setViewportView(jTabbedPane1);

        jLabel3.setText("Name");

        jTextField6.setToolTipText("More or less a filename!");
        jTextField6.setPreferredSize(new java.awt.Dimension(6, 21));

        jButton3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/disk.png"))); // NOI18N
        jButton3.setText("Save");
        jButton3.setPreferredSize(new java.awt.Dimension(77, 21));
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        jComboBox1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBox1.setPreferredSize(new java.awt.Dimension(56, 21));
        jComboBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel24Layout = new javax.swing.GroupLayout(jPanel24);
        jPanel24.setLayout(jPanel24Layout);
        jPanel24Layout.setHorizontalGroup(
            jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel24Layout.createSequentialGroup()
                .addComponent(jLabel3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, 115, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 93, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 169, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel24Layout.setVerticalGroup(
            jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel24Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel3, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jTextField6, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton3, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBox1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(2, 2, 2))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel24, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 689, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addComponent(jPanel24, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 845, Short.MAX_VALUE))
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

    private void jSliderBlankOnStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderBlankOnStateChanged
        config.delays[TIMER_BLANK_ON_CHANGE] = jSliderBlankOn.getValue();
    }//GEN-LAST:event_jSliderBlankOnStateChanged

    private void jSliderBlankOnTenthStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderBlankOnTenthStateChanged
        config.blankOnDelay = ((double )jSliderBlankOnTenth.getValue())/10;
    }//GEN-LAST:event_jSliderBlankOnTenthStateChanged

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
        changeDisplay();
    }//GEN-LAST:event_jSliderMuxY3StateChanged

    private void jSliderMuxY4StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderMuxY4StateChanged
        config.lineWidth = jSliderMuxY4.getValue();
    }//GEN-LAST:event_jSliderMuxY4StateChanged

    private void jCheckBox10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox10ActionPerformed
        config.antialiazing = jCheckBox10.isSelected();
        changeDisplay();
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
//        frame.addPanel(cd);
//        frame.setMainPanel(cd);
//        frame.windowMe(cd, 600, 350, "System Rom Config");
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addAsWindow(cd, 600, 350, "System Rom Config");
        
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
        if (name.trim().length()==0) 
        {
            name = "default";
            jTextField6.setText(name);
        }
        if (name.trim().length()>0)
        {
            if (!config.save(Global.mainPathPrefix+"serialize"+File.separator +name+".vsv"))
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
        config.cartOverwriteSaves.autoSync = config.autoSync;
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
        changeDisplay();
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
       // https://shiru.untergrund.net/files/ayfxedit.zip
        String unpack = Global.mainPathPrefix+"download"+File.separator+"sound";
        boolean ok = DownloaderPanel.ensureLocalFile("Sound", "AYFX DOWNLOAD", unpack);
        if (!ok)
        {
            log.addLog("ayfxedit.zip was not found...", WARN);
            return;
        }
        ShowInfoDialog.showInfoDialog("ZIP loaded and unpacked!", "'ayfxedit04.zip' was loaded and unpacked to '"+unpack+"'!");
    }//GEN-LAST:event_jButton5ActionPerformed

    private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed
       // http://pacidemo.planet-d.net/aldn/ym/ST%20synth%20musics.ym.zip
        String unpack = Global.mainPathPrefix+"download"+File.separator+"sound";
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

    String lastPath="";
    private void jButtonLoadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoadActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setMultiSelectionEnabled(false);
        if (lastPath.length()==0)
        {
            lastPath=Global.mainPathPrefix+"theme";
            fc.setCurrentDirectory(new java.io.File(lastPath));
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

            // Update the ComponentUIs for all Components. This
            // needs to be invoked for all windows.
            Global.initLAF();
            
            String rel = de.malban.util.Utility.makeVideRelative(fc.getSelectedFile().toString());
            
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
            jCheckBoxMouseMode.setEnabled(false);
            jCheckBoxMouseMode.setSelected(false);
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
            jCheckBoxMouseMode.setEnabled(true);
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
            jCheckBoxMouseMode.setEnabled(false);
            jCheckBoxMouseMode.setSelected(false);
        }        
    }//GEN-LAST:event_jComboBox4ActionPerformed

    private void jTextField9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField9ActionPerformed
        config.minimumSpinnerChangeCycles = de.malban.util.UtilityString.IntX(jTextField9.getText(), 30000);
    }//GEN-LAST:event_jTextField9ActionPerformed

    private void jTextField9FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField9FocusLost
        config.minimumSpinnerChangeCycles = de.malban.util.UtilityString.IntX(jTextField9.getText(), 30000);
    }//GEN-LAST:event_jTextField9FocusLost

    private void jTextField9KeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField9KeyReleased
        config.minimumSpinnerChangeCycles = de.malban.util.UtilityString.IntX(jTextField9.getText(), 30000);
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
        changeDisplay();
    }//GEN-LAST:event_jTextField11ActionPerformed

    private void jTextField12ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField12ActionPerformed
        changeDisplay();
    }//GEN-LAST:event_jTextField12ActionPerformed

    private void jTextField11FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField11FocusLost
        changeDisplay();
    }//GEN-LAST:event_jTextField11FocusLost

    private void jTextField12FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField12FocusLost
        changeDisplay();
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
        name = de.malban.util.Utility.makeVideRelative(name);
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

    private void jSliderShiftStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderShiftStateChanged
        config.delays[TIMER_SHIFT] = jSliderShift.getValue()+1;
    }//GEN-LAST:event_jSliderShiftStateChanged

    private void jCheckBoxViaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxViaActionPerformed
        
        config.viaShift9BugEnabled = jCheckBoxVia.isSelected();
    }//GEN-LAST:event_jCheckBoxViaActionPerformed

    private void jSliderT1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderT1StateChanged
        config.delays[TIMER_T1] = jSliderT1.getValue()+1;
    }//GEN-LAST:event_jSliderT1StateChanged

    private void jCheckBox45ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox45ActionPerformed
               config.supportUnusedSymbols =  jCheckBox45.isSelected();
    }//GEN-LAST:event_jCheckBox45ActionPerformed

    private void jSliderScaleEfficencyStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderScaleEfficencyStateChanged
        int v = jSliderScaleEfficency.getValue();
        double value = jSliderScaleEfficency.getValue() ;
        value = value /10;
        config.scaleEfficiency = value;
    }//GEN-LAST:event_jSliderScaleEfficencyStateChanged

    private void jCheckBox46ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox46ActionPerformed
        config.pleaseforceDissiIconizeOnRun = jCheckBox46.isSelected();
    }//GEN-LAST:event_jCheckBox46ActionPerformed

    private void jCheckBox47ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox47ActionPerformed
        config.autoEjectV4EonCompile = jCheckBox47.isSelected();
    }//GEN-LAST:event_jCheckBox47ActionPerformed

    private void jButtonLAFActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLAFActionPerformed

        
        
        de.muntjak.tinylookandfeel.controlpanel.ControlPanel.main(null);
        /*
        String [] cmd = new String[3];
        cmd[0] = "java";
        cmd[1] = "-jar";   
        cmd[2] = "tinycp.jar";   
//        cmd[2] = Global.mainPathPrefix+"../externalTools/tinylaf/tinycp.jar";   
        cmd[2] = Global.mainPathPrefix+"externalTools/tinylaf/tinycp.jar";   
//        de.malban.util.UtilityFiles.executeOSCommandInDir(cmd, "./externalTools/tinylaf");
        de.malban.util.UtilityFiles.executeOSCommandInDir_noWait(cmd, Global.mainPathPrefix+"theme");
        */
    }//GEN-LAST:event_jButtonLAFActionPerformed

    private void jCheckBox48ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox48ActionPerformed
        config.warnOnDoubleDefine = jCheckBox48.isSelected();
    }//GEN-LAST:event_jCheckBox48ActionPerformed

    private void jSliderZeroDividerStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderZeroDividerStateChanged
        config.zero_divider = ((double)jSliderZeroDivider.getValue())/100.0;
    }//GEN-LAST:event_jSliderZeroDividerStateChanged

    private void jComboBox5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox5ActionPerformed
        if (mClassSetting>0) return;
        config.rotate = DASM6809.toNumber(jComboBox5.getSelectedItem().toString());
        changeDisplay();
    }//GEN-LAST:event_jComboBox5ActionPerformed

    private void jComboBox6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox6ActionPerformed
        config.delays[TIMER_MUX_SEL_CHANGE] = 1;
        config.delays[TIMER_MUX_Y_CHANGE] = 13;
        config.delays[TIMER_MUX_Z_CHANGE] = 0;
        config.delays[TIMER_MUX_S_CHANGE] = 0;
        config.delays[TIMER_MUX_R_CHANGE] = 0;
        config.delays[TIMER_XSH_CHANGE] = 13;
        config.delays[TIMER_ZERO] = 5;
        config.delays[TIMER_BLANK_ON_CHANGE] = 0;
        config.blankOnDelay = 1.0;
        config.delays[TIMER_BLANK_OFF_CHANGE] = 0;
        config.blankOffDelay = 1.0;
        config.delays[TIMER_SHIFT] = 1+1;
        config.delays[TIMER_T1] = 0+1;
        config.delays[TIMER_T2] = 0+1;
        config.cycleExactEmulation = true;
        switch (jComboBox6.getSelectedIndex())
        {
            case 0:
            {
                config.delays[TIMER_RAMP_CHANGE] = 11;
                config.rampOnFractionValue = 0.5;
                config.delays[TIMER_RAMP_OFF_CHANGE] = 14;
                config.rampOffFractionValue = 0.2;
                break;
            }
            case 1:
            {
                config.delays[TIMER_RAMP_CHANGE] = 11;
                config.rampOnFractionValue = 0.8;
                config.delays[TIMER_RAMP_OFF_CHANGE] = 14;
                config.rampOffFractionValue = 0.9;
                break;
            }
            case 2:
            {
                config.delays[TIMER_RAMP_CHANGE] = 12;
                config.rampOnFractionValue = 0.2;
                config.delays[TIMER_RAMP_OFF_CHANGE] = 15;
                config.rampOffFractionValue = 0.5;
                break;
            }
            case 3:
            {
                config.delays[TIMER_RAMP_CHANGE] = 12;
                config.rampOnFractionValue = 0.7;
                config.delays[TIMER_RAMP_OFF_CHANGE] = 16;
                config.rampOffFractionValue = 0.0;
                break;
            }
            default:
            {
                break;
            }
        }
        jSliderMuxSel.setValue(config.delays[TIMER_MUX_SEL_CHANGE]);
        jSliderMuxY.setValue(config.delays[TIMER_MUX_Y_CHANGE]);
        jSliderMuxZ.setValue(config.delays[TIMER_MUX_Z_CHANGE]);
        jSliderMuxS.setValue(config.delays[TIMER_MUX_S_CHANGE]);
        jSliderMuxR.setValue(config.delays[TIMER_MUX_R_CHANGE]);
        jSliderXSH.setValue(config.delays[TIMER_XSH_CHANGE]);
        jSliderRealZero.setValue(config.delays[TIMER_ZERO]);
        jSliderBlankOn.setValue(config.delays[TIMER_BLANK_ON_CHANGE]);
        jSliderBlankOnTenth.setValue((int)(config.blankOnDelay*10));
        jSliderBlankOff.setValue(config.delays[TIMER_BLANK_OFF_CHANGE]);
        jSliderBlankOffTenth.setValue((int)(config.blankOffDelay*10));
        jSliderShift.setValue(config.delays[TIMER_SHIFT]-1);
        jSliderT1.setValue(config.delays[TIMER_T1]-1);
        jSliderT_2.setValue(config.delays[TIMER_T2]-1);
        jCheckBox12.setSelected(config.cycleExactEmulation);

        int rampOn = config.delays[TIMER_RAMP_CHANGE]*10;
        int rampOff = config.delays[TIMER_RAMP_OFF_CHANGE]*10;
        
        rampOn+=config.rampOnFractionValue*10;
        rampOff+=config.rampOffFractionValue*10;
        
        jSliderRamp.setValue(rampOn);
        jSliderRampOff.setValue(rampOff);
    }//GEN-LAST:event_jComboBox6ActionPerformed

    private void jCheckBox49ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox49ActionPerformed
       config.ramAccessAllowed = jCheckBox49.isSelected();
       config.cartOverwriteSaves.ramAccessAllowed = config.ramAccessAllowed;
        
    }//GEN-LAST:event_jCheckBox49ActionPerformed

    private void jCheckBox50ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox50ActionPerformed
        config.romAndPcBreakpoints = jCheckBox50.isSelected();
        config.cartOverwriteSaves.romAndPcBreakpoints = config.romAndPcBreakpoints;

    }//GEN-LAST:event_jCheckBox50ActionPerformed

    private void jTextFieldSingestepBufferActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldSingestepBufferActionPerformed
        config.singestepBuffer = de.malban.util.UtilityString.IntX(jTextFieldSingestepBuffer.getText(), 2000);
        if (config.singestepBuffer>50000)
            config.singestepBuffer = 50000;
        jTextFieldSingestepBuffer.setText(""+config.singestepBuffer);
        updateVecxBuffer();

    }//GEN-LAST:event_jTextFieldSingestepBufferActionPerformed

    private void jTextFieldSingestepBufferFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldSingestepBufferFocusLost
        config.singestepBuffer = de.malban.util.UtilityString.IntX(jTextFieldSingestepBuffer.getText(), 2000);
        if (config.singestepBuffer>50000)
            config.singestepBuffer = 50000;
        jTextFieldSingestepBuffer.setText(""+config.singestepBuffer);
        updateVecxBuffer();
    }//GEN-LAST:event_jTextFieldSingestepBufferFocusLost

    private void jTextFieldFrameBufferFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldFrameBufferFocusLost
        config.frameBuffer = de.malban.util.UtilityString.IntX(jTextFieldFrameBuffer.getText(), 2000);
        if (config.frameBuffer>5000)
            config.frameBuffer = 5000;
        jTextFieldFrameBuffer.setText(""+config.frameBuffer);
        updateVecxBuffer();
    }//GEN-LAST:event_jTextFieldFrameBufferFocusLost

    private void jTextFieldFrameBufferActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldFrameBufferActionPerformed
        config.frameBuffer = de.malban.util.UtilityString.IntX(jTextFieldFrameBuffer.getText(), 2000);
        if (config.frameBuffer>5000)
            config.frameBuffer = 5000;
        jTextFieldFrameBuffer.setText(""+config.frameBuffer);
        updateVecxBuffer();
    }//GEN-LAST:event_jTextFieldFrameBufferActionPerformed

    private void jRadioButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton3ActionPerformed
        config.useLibAYEmu = false;
    }//GEN-LAST:event_jRadioButton3ActionPerformed

    private void jRadioButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton4ActionPerformed
        config.useLibAYEmu = true;
    }//GEN-LAST:event_jRadioButton4ActionPerformed

    private void jComboBox7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox7ActionPerformed
        if (jComboBox7.getSelectedIndex() == 0)
        {
            config.useLibAYEmuTable = "AY_Kay";
            AY.SetChipType(AY.Chip.AY_Kay, null);
        }
        if (jComboBox7.getSelectedIndex() == 1)
        {
            config.useLibAYEmuTable = "YM_Kay";
            AY.SetChipType(AY.Chip.YM_Kay, null);
        }
        if (jComboBox7.getSelectedIndex() == 2)
        {
            config.useLibAYEmuTable = "AY_Lion17";
            AY.SetChipType(AY.Chip.AY_Lion17, null);
        }
        if (jComboBox7.getSelectedIndex() == 3)
        {
            config.useLibAYEmuTable = "YM_Lion17";
            AY.SetChipType(AY.Chip.YM_Lion17, null);
        }
    }//GEN-LAST:event_jComboBox7ActionPerformed

    private void jButtonFileSelect2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect2ActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setDialogTitle("Select VecFever RAMDISK-drive");
        fc.setCurrentDirectory(new java.io.File(File.separator));
        fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);

        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String lp = fc.getSelectedFile().getAbsolutePath();

        Path p = Paths.get(lp);
        config.v4eVolumeName = p.toString();
        jTextFieldPath.setText(p.toString());
 
    }//GEN-LAST:event_jButtonFileSelect2ActionPerformed

    private void jButtonRegChanges(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRegChanges
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_BACKGROUND_COLOR);
        if (c == null) return;
        config.VECCI_BACKGROUND_COLOR = c;
        VectorColors.VECCI_BACKGROUND_COLOR = c;
        jPanel41.setBackground(VectorColors.VECCI_BACKGROUND_COLOR);
    }//GEN-LAST:event_jButtonRegChanges

    private void jButtonVecciForegroundActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonVecciForegroundActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_VECTOR_FOREGROUND_COLOR);
        if (c == null) return;
        config.VECCI_VECTOR_FOREGROUND_COLOR = c;
        VectorColors.VECCI_VECTOR_FOREGROUND_COLOR = c;
        jPanel42.setBackground(VectorColors.VECCI_VECTOR_FOREGROUND_COLOR);
    }//GEN-LAST:event_jButtonVecciForegroundActionPerformed

    private void jButtonVecciGridActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonVecciGridActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_GRID_COLOR);
        if (c == null) return;
        config.VECCI_GRID_COLOR = c;
        VectorColors.VECCI_GRID_COLOR = c;
        jPanel43.setBackground(VectorColors.VECCI_GRID_COLOR);
    }//GEN-LAST:event_jButtonVecciGridActionPerformed

    private void jButtonByteFrameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonByteFrameActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_FRAME_COLOR);
        if (c == null) return;
        config.VECCI_FRAME_COLOR = c;
        VectorColors.VECCI_FRAME_COLOR = c;
        jPanel44.setBackground(VectorColors.VECCI_FRAME_COLOR);
    }//GEN-LAST:event_jButtonByteFrameActionPerformed

    private void jButtonCrossActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCrossActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_CROSS_COLOR);
        if (c == null) return;
        config.VECCI_CROSS_COLOR = c;
        VectorColors.VECCI_CROSS_COLOR = c;
        jPanel45.setBackground(VectorColors.VECCI_CROSS_COLOR);
    }//GEN-LAST:event_jButtonCrossActionPerformed

    private void jButtonCrossDragActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCrossDragActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_CROSS_DRAG_COLOR);
        if (c == null) return;
        config.VECCI_CROSS_DRAG_COLOR = c;
        VectorColors.VECCI_CROSS_DRAG_COLOR = c;
        jPanel46.setBackground(VectorColors.VECCI_CROSS_DRAG_COLOR);
    }//GEN-LAST:event_jButtonCrossDragActionPerformed

    private void jButtonRelativeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRelativeActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_VECTOR_RELATIVE_COLOR);
        if (c == null) return;
        config.VECCI_VECTOR_RELATIVE_COLOR = c;
        VectorColors.VECCI_VECTOR_RELATIVE_COLOR = c;
        jPanel47.setBackground(VectorColors.VECCI_VECTOR_RELATIVE_COLOR);
    }//GEN-LAST:event_jButtonRelativeActionPerformed

    private void jButtonHighliteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonHighliteActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_VECTOR_HIGHLIGHT_COLOR);
        if (c == null) return;
        config.VECCI_VECTOR_HIGHLIGHT_COLOR = c;
        VectorColors.VECCI_VECTOR_HIGHLIGHT_COLOR = c;
        jPanel49.setBackground(VectorColors.VECCI_VECTOR_HIGHLIGHT_COLOR);
    }//GEN-LAST:event_jButtonHighliteActionPerformed

    private void jButtonSelectActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSelectActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_VECTOR_SELECTED_COLOR);
        if (c == null) return;
        config.VECCI_VECTOR_SELECTED_COLOR = c;
        VectorColors.VECCI_VECTOR_SELECTED_COLOR = c;
        jPanel50.setBackground(VectorColors.VECCI_VECTOR_SELECTED_COLOR);
    }//GEN-LAST:event_jButtonSelectActionPerformed

    private void jButtonPointJoinedActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPointJoinedActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_POINT_JOINED_COLOR);
        if (c == null) return;
        config.VECCI_POINT_JOINED_COLOR = c;
        VectorColors.VECCI_POINT_JOINED_COLOR = c;
        jPanel51.setBackground(VectorColors.VECCI_POINT_JOINED_COLOR);
    }//GEN-LAST:event_jButtonPointJoinedActionPerformed

    private void jButtonPointHighliteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPointHighliteActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_POINT_HIGHLIGHT_COLOR);
        if (c == null) return;
        config.VECCI_POINT_HIGHLIGHT_COLOR = c;
        VectorColors.VECCI_POINT_HIGHLIGHT_COLOR = c;
        jPanel52.setBackground(VectorColors.VECCI_POINT_HIGHLIGHT_COLOR);
    }//GEN-LAST:event_jButtonPointHighliteActionPerformed

    private void jButtonPointSelectActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPointSelectActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_POINT_SELECTED_COLOR);
        if (c == null) return;
        config.VECCI_POINT_SELECTED_COLOR = c;
        VectorColors.VECCI_POINT_SELECTED_COLOR = c;
        jPanel53.setBackground(VectorColors.VECCI_POINT_SELECTED_COLOR);
    }//GEN-LAST:event_jButtonPointSelectActionPerformed

    private void jButtonVectorPosActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonVectorPosActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_POS_COLOR);
        if (c == null) return;
        config.VECCI_POS_COLOR = c;
        VectorColors.VECCI_POS_COLOR = c;
        jPanel54.setBackground(VectorColors.VECCI_POS_COLOR);
    }//GEN-LAST:event_jButtonVectorPosActionPerformed

    private void jButtonVectorMoveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonVectorMoveActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_MOVE_COLOR);
        if (c == null) return;
        config.VECCI_MOVE_COLOR = c;
        VectorColors.VECCI_MOVE_COLOR = c;
        jPanel55.setBackground(VectorColors.VECCI_MOVE_COLOR);
    }//GEN-LAST:event_jButtonVectorMoveActionPerformed

    private void jButtonVectorDragActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonVectorDragActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_VECTOR_DRAG_COLOR);
        if (c == null) return;
        config.VECCI_VECTOR_DRAG_COLOR = c;
        VectorColors.VECCI_VECTOR_DRAG_COLOR = c;
        jPanel56.setBackground(VectorColors.VECCI_VECTOR_DRAG_COLOR);
    }//GEN-LAST:event_jButtonVectorDragActionPerformed

    private void jButtonEndpointActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEndpointActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_VECTOR_ENDPOINT_COLOR);
        if (c == null) return;
        config.VECCI_VECTOR_ENDPOINT_COLOR = c;
        VectorColors.VECCI_VECTOR_ENDPOINT_COLOR = c;
        jPanel57.setBackground(VectorColors.VECCI_VECTOR_ENDPOINT_COLOR);
    }//GEN-LAST:event_jButtonEndpointActionPerformed

    private void jButtonAreaDragActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAreaDragActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color");
        if (c == null) return;
        config.VECCI_DRAG_AREA_COLOR = c;
        VectorColors.VECCI_DRAG_AREA_COLOR = c;
        jPanel58.setBackground(VectorColors.VECCI_DRAG_AREA_COLOR);
    }//GEN-LAST:event_jButtonAreaDragActionPerformed

    private void jButtonxAxisActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonxAxisActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_X_AXIS_COLOR);
        if (c == null) return;
        config.VECCI_X_AXIS_COLOR = c;
        VectorColors.VECCI_X_AXIS_COLOR = c;
        jPanel59.setBackground(VectorColors.VECCI_X_AXIS_COLOR);
    }//GEN-LAST:event_jButtonxAxisActionPerformed

    private void jButtonyAxisActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonyAxisActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_Y_AXIS_COLOR);
        if (c == null) return;
        config.VECCI_Y_AXIS_COLOR = c;
        VectorColors.VECCI_Y_AXIS_COLOR = c;
        jPanel60.setBackground(VectorColors.VECCI_Y_AXIS_COLOR);
    }//GEN-LAST:event_jButtonyAxisActionPerformed

    private void jButtonzAxisActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonzAxisActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.VECCI_Z_AXIS_COLOR);
        if (c == null) return;
        config.VECCI_Z_AXIS_COLOR = c;
        VectorColors.VECCI_Z_AXIS_COLOR = c;
        jPanel61.setBackground(VectorColors.VECCI_Z_AXIS_COLOR);
    }//GEN-LAST:event_jButtonzAxisActionPerformed

    private void jTextField13FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField13FocusLost
        config.TAB_EQU_VALUE = de.malban.util.UtilityString.IntX(jTextField13.getText(),40);
    }//GEN-LAST:event_jTextField13FocusLost

    private void jTextField13ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField13ActionPerformed
        config.TAB_EQU_VALUE = de.malban.util.UtilityString.IntX(jTextField13.getText(),40);
    }//GEN-LAST:event_jTextField13ActionPerformed

    private void jTextField13PropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextField13PropertyChange
        config.TAB_EQU_VALUE = de.malban.util.UtilityString.IntX(jTextField13.getText(),40);
    }//GEN-LAST:event_jTextField13PropertyChange

    private void jTextField13KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField13KeyTyped
        config.TAB_EQU_VALUE = de.malban.util.UtilityString.IntX(jTextField13.getText(),40);
    }//GEN-LAST:event_jTextField13KeyTyped

    private void jTextField14FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField14FocusLost
        config.TAB_EQU = de.malban.util.UtilityString.IntX(jTextField14.getText(),30);
    }//GEN-LAST:event_jTextField14FocusLost

    private void jTextField14ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField14ActionPerformed
        config.TAB_EQU = de.malban.util.UtilityString.IntX(jTextField14.getText(),30);
    }//GEN-LAST:event_jTextField14ActionPerformed

    private void jTextField14PropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextField14PropertyChange
        config.TAB_EQU = de.malban.util.UtilityString.IntX(jTextField14.getText(),30);
    }//GEN-LAST:event_jTextField14PropertyChange

    private void jTextField14KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField14KeyTyped
        config.TAB_EQU = de.malban.util.UtilityString.IntX(jTextField14.getText(),30);
    }//GEN-LAST:event_jTextField14KeyTyped

    private void jTextField15FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField15FocusLost
        config.TAB_MNEMONIC = de.malban.util.UtilityString.IntX(jTextField15.getText(),20);
    }//GEN-LAST:event_jTextField15FocusLost

    private void jTextField15ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField15ActionPerformed
        config.TAB_MNEMONIC = de.malban.util.UtilityString.IntX(jTextField15.getText(),20);
    }//GEN-LAST:event_jTextField15ActionPerformed

    private void jTextField15PropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextField15PropertyChange
        config.TAB_MNEMONIC = de.malban.util.UtilityString.IntX(jTextField15.getText(),20);
    }//GEN-LAST:event_jTextField15PropertyChange

    private void jTextField15KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField15KeyTyped
        config.TAB_MNEMONIC = de.malban.util.UtilityString.IntX(jTextField15.getText(),20);
    }//GEN-LAST:event_jTextField15KeyTyped

    private void jTextField16FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField16FocusLost
        config.TAB_OP = de.malban.util.UtilityString.IntX(jTextField16.getText(),30);
    }//GEN-LAST:event_jTextField16FocusLost

    private void jTextField16ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField16ActionPerformed
        config.TAB_OP = de.malban.util.UtilityString.IntX(jTextField16.getText(),30);
    }//GEN-LAST:event_jTextField16ActionPerformed

    private void jTextField16PropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextField16PropertyChange
        config.TAB_OP = de.malban.util.UtilityString.IntX(jTextField16.getText(),30);
    }//GEN-LAST:event_jTextField16PropertyChange

    private void jTextField16KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField16KeyTyped
        config.TAB_OP = de.malban.util.UtilityString.IntX(jTextField16.getText(),30);
    }//GEN-LAST:event_jTextField16KeyTyped

    private void jTextFieldCommentIndentFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldCommentIndentFocusLost
        config.TAB_COMMENT = de.malban.util.UtilityString.IntX(jTextFieldCommentIndent.getText(),58);
    }//GEN-LAST:event_jTextFieldCommentIndentFocusLost

    private void jTextFieldCommentIndentActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldCommentIndentActionPerformed
        config.TAB_COMMENT = de.malban.util.UtilityString.IntX(jTextFieldCommentIndent.getText(),58);
    }//GEN-LAST:event_jTextFieldCommentIndentActionPerformed

    private void jTextFieldCommentIndentPropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextFieldCommentIndentPropertyChange
        config.TAB_COMMENT = de.malban.util.UtilityString.IntX(jTextFieldCommentIndent.getText(),58);
    }//GEN-LAST:event_jTextFieldCommentIndentPropertyChange

    private void jTextFieldCommentIndentKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldCommentIndentKeyTyped
        config.TAB_COMMENT = de.malban.util.UtilityString.IntX(jTextFieldCommentIndent.getText(),58);
    }//GEN-LAST:event_jTextFieldCommentIndentKeyTyped

    private void jCheckBoxProfilerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxProfilerActionPerformed
        config.doProfile = jCheckBoxProfiler.isSelected();
        DissiPanel.configChanged();
    }//GEN-LAST:event_jCheckBoxProfilerActionPerformed

    private void jCheckBox51ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox51ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox51ActionPerformed

    private void jCheckBox52ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox52ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox52ActionPerformed

    private void jSliderScaleEfficencyThresholdYStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderScaleEfficencyThresholdYStateChanged
        double value = jSliderScaleEfficencyThresholdY.getValue() ;
        value = value /100;
        config.efficiencyThresholdY = value;
    }//GEN-LAST:event_jSliderScaleEfficencyThresholdYStateChanged

    private void jCheckBoxStarterImagesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxStarterImagesActionPerformed
        config.loadStarterImages = jCheckBoxStarterImages.isSelected();
    }//GEN-LAST:event_jCheckBoxStarterImagesActionPerformed

    private void jCheckBoxJOGLActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxJOGLActionPerformed
        config.tryJOGL = jCheckBoxJOGL.isSelected();
        changeDisplay();
    }//GEN-LAST:event_jCheckBoxJOGLActionPerformed

    private void jCheckBoxDeepSyntaxCheckActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxDeepSyntaxCheckActionPerformed
        config.deepSyntaxCheck = jCheckBoxDeepSyntaxCheck.isSelected();
    }//GEN-LAST:event_jCheckBoxDeepSyntaxCheckActionPerformed

    private void jTextField18FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField18FocusLost
        config.deepSyntaxCheckTiming = de.malban.util.UtilityString.IntX(jTextField18.getText(),10000);
    }//GEN-LAST:event_jTextField18FocusLost

    private void jTextField18ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField18ActionPerformed
        config.deepSyntaxCheckTiming = de.malban.util.UtilityString.IntX(jTextField18.getText(),10000);
    }//GEN-LAST:event_jTextField18ActionPerformed

    private void jTextField18PropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextField18PropertyChange
        config.deepSyntaxCheckTiming = de.malban.util.UtilityString.IntX(jTextField18.getText(),10000);
    }//GEN-LAST:event_jTextField18PropertyChange

    private void jTextField18KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField18KeyTyped
        config.deepSyntaxCheckTiming = de.malban.util.UtilityString.IntX(jTextField18.getText(),10000);
    }//GEN-LAST:event_jTextField18KeyTyped

    private void jCheckBoxDeepSyntaxThresholdActiveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxDeepSyntaxThresholdActiveActionPerformed
        config.deepSyntaxCheckThresholdActive = jCheckBoxDeepSyntaxThresholdActive.isSelected();
    }//GEN-LAST:event_jCheckBoxDeepSyntaxThresholdActiveActionPerformed

    private void jTextField19FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField19FocusLost
        config.deepSyntaxCheckThreshold = de.malban.util.UtilityString.IntX(jTextField19.getText(),100000);
    }//GEN-LAST:event_jTextField19FocusLost

    private void jTextField19ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField19ActionPerformed
        config.deepSyntaxCheckThreshold = de.malban.util.UtilityString.IntX(jTextField19.getText(),100000);
    }//GEN-LAST:event_jTextField19ActionPerformed

    private void jTextField19PropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextField19PropertyChange
        config.deepSyntaxCheckThreshold = de.malban.util.UtilityString.IntX(jTextField19.getText(),100000);
    }//GEN-LAST:event_jTextField19PropertyChange

    private void jTextField19KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField19KeyTyped
        config.deepSyntaxCheckThreshold = de.malban.util.UtilityString.IntX(jTextField19.getText(),100000);
    }//GEN-LAST:event_jTextField19KeyTyped

    private void jCheckBox53ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox53ActionPerformed
        setColumnCheckBox((JCheckBox)evt.getSource());
    }//GEN-LAST:event_jCheckBox53ActionPerformed

    private void jCheckBoxMSAAActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxMSAAActionPerformed
        config.JOGLMSAA = jCheckBoxMSAA.isSelected();
        changeDisplay();
    }//GEN-LAST:event_jCheckBoxMSAAActionPerformed

    private void jComboBox8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox8ActionPerformed
        int s = 0;
        
        //TODO check which sample types are available
        if (jComboBox8.getSelectedIndex() == 0) s = 0;
        if (jComboBox8.getSelectedIndex() == 1) s = 2;
        if (jComboBox8.getSelectedIndex() == 2) s = 4;
        if (jComboBox8.getSelectedIndex() == 3) s = 8;
        if (jComboBox8.getSelectedIndex() == 4) s = 16;
        config.JOGLmultiSample = s;
        changeDisplay();
    }//GEN-LAST:event_jComboBox8ActionPerformed

    private void jTextField20ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField20ActionPerformed
         config.JOGL_SIGMA = de.malban.util.UtilityString.DoubleX(jTextField20.getText(), 0.8D);
         changeDisplay();
    }//GEN-LAST:event_jTextField20ActionPerformed

    private void jTextField22ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField22ActionPerformed
         config.JOGLSpillThreshold = de.malban.util.UtilityString.DoubleX(jTextField22.getText(), 0.8D);
         changeDisplay();
    }//GEN-LAST:event_jTextField22ActionPerformed

    private void jCheckBox54ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox54ActionPerformed
         config.JOGLuseGlowShader = jCheckBox54.isSelected();
         changeDisplay();
    }//GEN-LAST:event_jCheckBox54ActionPerformed

    private void jCheckBox55ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox55ActionPerformed
         config.JOGLadditiveBlur = jCheckBox55.isSelected();
         changeDisplay();
    }//GEN-LAST:event_jCheckBox55ActionPerformed

    private void jCheckBox56ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox56ActionPerformed
         config.JOGLaddBase = jCheckBox56.isSelected();
         changeDisplay();
    }//GEN-LAST:event_jCheckBox56ActionPerformed

    private void jTextField1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField1ActionPerformed
         config.JOGLblurPass = de.malban.util.UtilityString.IntX(jTextField1.getText(), 2);
         changeDisplay();
    }//GEN-LAST:event_jTextField1ActionPerformed

    private void jTextField21ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField21ActionPerformed
         config.JOGL_GAUSS_RADIUS = de.malban.util.UtilityString.IntX(jTextField21.getText(), 2);
         changeDisplay();
    }//GEN-LAST:event_jTextField21ActionPerformed

    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed
        Extractor.testChassisFromPara();

    }//GEN-LAST:event_jButton6ActionPerformed

    private void jTextField23ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField23ActionPerformed
         config.JOGLGlowThreshold = de.malban.util.UtilityString.DoubleX(jTextField23.getText(), 0);
    }//GEN-LAST:event_jTextField23ActionPerformed

    private void jTextField24ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField24ActionPerformed
         config.JOGLSpillPass = de.malban.util.UtilityString.IntX(jTextField24.getText(), 1);
    }//GEN-LAST:event_jTextField24ActionPerformed

    private void jCheckBox58ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox58ActionPerformed
         config.JOGLuseSpillShader = jCheckBox58.isSelected();
    }//GEN-LAST:event_jCheckBox58ActionPerformed

    private void jTextField25ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField25ActionPerformed
         config.JOGLInitialSpillDivisor = de.malban.util.UtilityString.DoubleX(jTextField25.getText(), 5);
    }//GEN-LAST:event_jTextField25ActionPerformed

    private void jTextField26ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField26ActionPerformed
         config.JOGLFinalSpillMultiplyer = de.malban.util.UtilityString.DoubleX(jTextField26.getText(), 5);
    }//GEN-LAST:event_jTextField26ActionPerformed

    private void jCheckBox57ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox57ActionPerformed
         config.JOGLSpillAddBase = jCheckBox57.isSelected();
    }//GEN-LAST:event_jCheckBox57ActionPerformed

    private void jCheckBox59ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox59ActionPerformed
        config.JOGLSpillUnfactordAddBase = jCheckBox59.isSelected();
    }//GEN-LAST:event_jCheckBox59ActionPerformed

    private void jTextField28ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField28ActionPerformed
        config.JOGL_speedMaxReduce = de.malban.util.UtilityString.FloatX(jTextField28.getText(), 0.5f);
    }//GEN-LAST:event_jTextField28ActionPerformed

    private void jTextField29ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField29ActionPerformed
        config.JOGLDotDwellDivisor = de.malban.util.UtilityString.FloatX(jTextField29.getText(), 25f);
        config.cartOverwriteSaves.JOGLDotDwellDivisor = config.JOGLDotDwellDivisor;        
    }//GEN-LAST:event_jTextField29ActionPerformed

    private void jCheckBox60ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox60ActionPerformed
        config.JOGLOverlayAdjustment = jCheckBox60.isSelected();
    }//GEN-LAST:event_jCheckBox60ActionPerformed

    private void jTextField30ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField30ActionPerformed
        config.JOGLOverlayAlphaThreshold = de.malban.util.UtilityString.FloatX(jTextField30.getText(), 0.8f);
        config.cartOverwriteSaves.JOGLOverlayAlphaThreshold = config.JOGLOverlayAlphaThreshold;

    }//GEN-LAST:event_jTextField30ActionPerformed

    private void jTextField32ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField32ActionPerformed
        config.JOGLOverlayAlphaAdjustmentFactor = de.malban.util.UtilityString.FloatX(jTextField32.getText(), 0.5f);
        
    }//GEN-LAST:event_jTextField32ActionPerformed

    private void jTextField33ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField33ActionPerformed
        config.JOGLOverlayBrightnessAlphaAdjustmentFactor = de.malban.util.UtilityString.FloatX(jTextField33.getText(), 0.5f);
    }//GEN-LAST:event_jTextField33ActionPerformed

    private void jCheckBoxMSAA1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxMSAA1ActionPerformed
        config.JOGLAutoDisplay = jCheckBoxMSAA1.isSelected();
        changeDisplay();
    }//GEN-LAST:event_jCheckBoxMSAA1ActionPerformed

    private void jCheckBox61ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox61ActionPerformed
        config.JOGLUseLinearSampling = jCheckBox61.isSelected();
        changeDisplay();
    }//GEN-LAST:event_jCheckBox61ActionPerformed

    private void jComboBox9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox9ActionPerformed
        config.JOGLMIP_RESOLUTION = jComboBox9.getSelectedIndex();
        changeDisplay();
    }//GEN-LAST:event_jComboBox9ActionPerformed

    private void jTextField31ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField31ActionPerformed
        config.overflowIntensityDivider = de.malban.util.UtilityString.FloatX(jTextField31.getText(), 15000f);
    }//GEN-LAST:event_jTextField31ActionPerformed

    private void jCheckBox62ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox62ActionPerformed
        config.emulateBorders = jCheckBox62.isSelected();
    }//GEN-LAST:event_jCheckBox62ActionPerformed

    private void jCheckBox63ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox63ActionPerformed
        config.JOGLScreen = jCheckBox63.isSelected();
        changeDisplay();
    }//GEN-LAST:event_jCheckBox63ActionPerformed

    private void jCheckBox66ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox66ActionPerformed
        config.JOGLScreenAdjustment = jCheckBox66.isSelected();
        changeDisplay();
    }//GEN-LAST:event_jCheckBox66ActionPerformed

    private void jTextField34ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField34ActionPerformed
        config.JOGLScreenBrightnessAdjustmentFactor = de.malban.util.UtilityString.FloatX(jTextField34.getText(), 0.5f);
        changeDisplay();
    }//GEN-LAST:event_jTextField34ActionPerformed

    
    private void jComboBoxScreenModesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxScreenModesActionPerformed
        if (mClassSetting>0) return;
        mClassSetting++;
        if (jComboBoxScreenModes.getSelectedIndex() == -1)
        {
            GraphicsEnvironment env = GraphicsEnvironment.getLocalGraphicsEnvironment();
            GraphicsDevice[] devices = env.getScreenDevices();
            DisplayMode[] modes = devices[0].getDisplayModes();

            for (int i = 0; i < modes.length; i++)
            {
                DisplayMode displayMode = modes[i];
                String m = "";
                m+= displayMode.getWidth()+"x";
                m+= displayMode.getHeight()+" ";
                m+= displayMode.getBitDepth()+"bit ";
                m+= displayMode.getRefreshRate()+"Hz";
                if (displayMode.getWidth()==1024)
                {
                    jComboBoxScreenModes.setSelectedItem(m);
                    break;
                }
            }
        }
        mClassSetting--;
        config.fullscreenResolution = (String) jComboBoxScreenModes.getSelectedItem();
        Configuration.getConfiguration().setFullScrrenResString(config.fullscreenResolution);    


    }//GEN-LAST:event_jComboBoxScreenModesActionPerformed

    private void jCheckBox64ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox64ActionPerformed
        config.keepAspectRatio = jCheckBox64.isSelected();
        changeDisplay();

    }//GEN-LAST:event_jCheckBox64ActionPerformed

    private void jCheckBox65ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox65ActionPerformed
        config.debugingCore = jCheckBox65.isSelected();
        checkDebuging();
    }//GEN-LAST:event_jCheckBox65ActionPerformed

    private void jSliderSplineMaxSizeStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSplineMaxSizeStateChanged
       config.maxSplineSize= jSliderSplineMaxSize.getValue();
        
    }//GEN-LAST:event_jSliderSplineMaxSizeStateChanged

    private void jSliderScaleEfficencyThresholdXStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderScaleEfficencyThresholdXStateChanged
        double value = jSliderScaleEfficencyThresholdX.getValue() ;
        value = value /100;
        config.efficiencyThresholdX = value;
         
    }//GEN-LAST:event_jSliderScaleEfficencyThresholdXStateChanged

    private void jTextFieldTabWidthFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldTabWidthFocusLost
        config.tab_width = de.malban.util.UtilityString.IntX(jTextFieldTabWidth.getText(), 4);
        changeTab();
    }//GEN-LAST:event_jTextFieldTabWidthFocusLost

    private void jTextFieldTabWidthActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldTabWidthActionPerformed
        config.tab_width = de.malban.util.UtilityString.IntX(jTextFieldTabWidth.getText(), 4);
        changeTab();
    }//GEN-LAST:event_jTextFieldTabWidthActionPerformed

    private void jTextFieldTabWidthPropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextFieldTabWidthPropertyChange
        config.tab_width = de.malban.util.UtilityString.IntX(jTextFieldTabWidth.getText(), 4);
 //       changeTab();
    }//GEN-LAST:event_jTextFieldTabWidthPropertyChange

    private void jTextFieldTabWidthKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldTabWidthKeyTyped
        config.tab_width = de.malban.util.UtilityString.IntX(jTextFieldTabWidth.getText(), 4);
    //    changeTab();
    }//GEN-LAST:event_jTextFieldTabWidthKeyTyped

    private void jCheckBoxStarterImages1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxStarterImages1ActionPerformed
        config.motdActive = jCheckBoxStarterImages1.isSelected();
    }//GEN-LAST:event_jCheckBoxStarterImages1ActionPerformed

    private void jButtonRegUnChangedActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRegUnChangedActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.valueNotChanged);
        if (c == null) return;
        config.valueNotChanged = c;
        jPanel71.setBackground(config.valueNotChanged);
    }//GEN-LAST:event_jButtonRegUnChangedActionPerformed

    private void jButtonPSGAActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPSGAActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.psgChannelA);
        if (c == null) return;
        config.psgChannelA = c;
        jPanel73.setBackground(config.psgChannelA);
        PSGColorsChanged();
    }//GEN-LAST:event_jButtonPSGAActionPerformed

    private void jButtonPSGBActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPSGBActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.psgChannelB);
        if (c == null) return;
        config.psgChannelB = c;
        jPanel72.setBackground(config.psgChannelB);
        PSGColorsChanged();
    }//GEN-LAST:event_jButtonPSGBActionPerformed

    private void jButtonVecciPSGC(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonVecciPSGC
        Color c = InternalColorChooserDialog.showDialog("Color", config.psgChannelC);
        if (c == null) return;
        config.psgChannelC = c;
        jPanel74.setBackground(config.psgChannelC);
        PSGColorsChanged();
    }//GEN-LAST:event_jButtonVecciPSGC

    private void jButtonPSGNoise(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPSGNoise
        Color c = InternalColorChooserDialog.showDialog("Color", config.psgChannelNoise);
        if (c == null) return;
        config.psgChannelNoise = c;
        jPanel75.setBackground(config.psgChannelNoise);
        PSGColorsChanged();
    }//GEN-LAST:event_jButtonPSGNoise

    private void jButtontableAddressActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtontableAddressActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.tableAddress);
        if (c == null) return;
        config.tableAddress = c;
        jPanel76.setBackground(config.tableAddress);
    }//GEN-LAST:event_jButtontableAddressActionPerformed

    private void jButtontableBIOSActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtontableBIOSActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.tableBIOS);
        if (c == null) return;
        config.tableBIOS = c;
        jPanel78.setBackground(config.tableBIOS);
    }//GEN-LAST:event_jButtontableBIOSActionPerformed

    private void jButtontableBankActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtontableBankActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.tableOtherBank);
        if (c == null) return;
        config.tableOtherBank = c;
        jPanel79.setBackground(config.tableOtherBank);
    }//GEN-LAST:event_jButtontableBankActionPerformed
    
    private void jButtonHTMLLinkActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonHTMLLinkActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.linkColor);
        if (c == null) return;
        config.linkColor = c;
        jPanel80.setBackground(config.linkColor);

        HTMLEditorKit kit = new HTMLEditorKit();
        StyleSheet styleSheet = kit.getStyleSheet();
        styleSheet.addRule("a {color:#"+Global.getHTMLColor(config.linkColor)+";}");        
        Global.linkColor = config.linkColor;
    }//GEN-LAST:event_jButtonHTMLLinkActionPerformed

    private void jButtonVecciBackground10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonVecciBackground10ActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", getBackground());
        if (c == null) return;
        setAllBackgrounds(c);
    }//GEN-LAST:event_jButtonVecciBackground10ActionPerformed

    private void jButtonRegChangedActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRegChangedActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.valueChanged);
        if (c == null) return;
        config.valueChanged = c;
        jPanel77.setBackground(config.valueChanged);
    }//GEN-LAST:event_jButtonRegChangedActionPerformed

    private void jButtonHTMLTextActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonHTMLTextActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.htmltext);
        if (c == null) return;
        config.htmltext = c;
        jPanel82.setBackground(config.htmltext);

        HTMLEditorKit kit = new HTMLEditorKit();
        StyleSheet styleSheet = kit.getStyleSheet();
        styleSheet.addRule("body {color:#"+Global.getHTMLColor(config.htmltext)+";}");
        Global.textColor = config.htmltext;
        
    }//GEN-LAST:event_jButtonHTMLTextActionPerformed

    private void jButtontableIOInputActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtontableIOInputActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color",config.IOInput);
        if (c == null) return;
        config.IOInput = c;
        jPanel83.setBackground(config.IOInput);
    }//GEN-LAST:event_jButtontableIOInputActionPerformed

    private void jButtonIOOutputActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonIOOutputActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.IOOutput);
        if (c == null) return;
        config.IOOutput = c;
        jPanel84.setBackground(config.IOOutput);
    }//GEN-LAST:event_jButtonIOOutputActionPerformed

    private void jButtonTabelSelectionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonTabelSelectionActionPerformed
        Color c = InternalColorChooserDialog.showDialog("Color", config.dataSelection);
        if (c == null) return;
        config.dataSelection = c;
        jPanel85.setBackground(config.dataSelection);
    }//GEN-LAST:event_jButtonTabelSelectionActionPerformed

    private void jButtonVecciBackground6jButtonVecciPSGC(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonVecciBackground6jButtonVecciPSGC
        Color c = InternalColorChooserDialog.showDialog("Color", config.cLinesBack);
        if (c == null) return;
        config.cLinesBack = c;
        jPanel87.setBackground(config.cLinesBack);
    }//GEN-LAST:event_jButtonVecciBackground6jButtonVecciPSGC

    private void jButtonVecciBackground7jButtonPSGNoise(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonVecciBackground7jButtonPSGNoise
        Color c = InternalColorChooserDialog.showDialog("Color", config.cLinesFore);
        if (c == null) return;
        config.cLinesFore = c;
        jPanel86.setBackground(config.cLinesFore);
    }//GEN-LAST:event_jButtonVecciBackground7jButtonPSGNoise

    private void jButtonPre1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPre1ActionPerformed
         showEditPeepProperties();
    }//GEN-LAST:event_jButtonPre1ActionPerformed

    private void jSliderBlankOffStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderBlankOffStateChanged
        config.delays[TIMER_BLANK_OFF_CHANGE] = jSliderBlankOff.getValue();
    }//GEN-LAST:event_jSliderBlankOffStateChanged

    private void jSliderBlankOffTenthStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderBlankOffTenthStateChanged
        config.blankOffDelay = ((double )jSliderBlankOffTenth.getValue())/10;
    }//GEN-LAST:event_jSliderBlankOffTenthStateChanged

    private void jSliderZeroRetainXStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderZeroRetainXStateChanged
        config.zeroRetainX = ((double)jSliderZeroRetainX.getValue())/10000.0;
    }//GEN-LAST:event_jSliderZeroRetainXStateChanged

    private void jSliderZeroRetainYStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderZeroRetainYStateChanged
        config.zeroRetainY = ((double)jSliderZeroRetainY.getValue())/10000.0;
    }//GEN-LAST:event_jSliderZeroRetainYStateChanged
    
    private void jCheckBox67ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox67ActionPerformed
        config.displayModeWriting = jCheckBox67.isSelected();
    }//GEN-LAST:event_jCheckBox67ActionPerformed

    private void jTextField7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField7ActionPerformed
            config.themeFile = jTextField7.getText();
    }//GEN-LAST:event_jTextField7ActionPerformed

    private void jCheckBoxColorModeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxColorModeActionPerformed
        config.vectrexColorMode = jCheckBoxColorMode.isSelected();
    }//GEN-LAST:event_jCheckBoxColorModeActionPerformed

    private void jTextField27FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField27FocusLost
        config.SHORT_TAB_OP = de.malban.util.UtilityString.IntX(jTextField27.getText(),1);
    }//GEN-LAST:event_jTextField27FocusLost

    private void jTextField27ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField27ActionPerformed
        config.SHORT_TAB_OP = de.malban.util.UtilityString.IntX(jTextField27.getText(),1);
    }//GEN-LAST:event_jTextField27ActionPerformed

    private void jTextField27PropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jTextField27PropertyChange
        config.SHORT_TAB_OP = de.malban.util.UtilityString.IntX(jTextField27.getText(),1);
    }//GEN-LAST:event_jTextField27PropertyChange

    private void jTextField27KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField27KeyTyped
        config.SHORT_TAB_OP = de.malban.util.UtilityString.IntX(jTextField27.getText(),1);
    }//GEN-LAST:event_jTextField27KeyTyped

    private void jCheckBoxFaultyVIAActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxFaultyVIAActionPerformed
        config.isFaultyVIA = jCheckBoxFaultyVIA.isSelected();
    }//GEN-LAST:event_jCheckBoxFaultyVIAActionPerformed

    private void jSliderT_2StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderT_2StateChanged
        config.delays[TIMER_T2] = jSliderT_2.getValue()+1;
    }//GEN-LAST:event_jSliderT_2StateChanged

    private void jCheckBoxMouseModeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxMouseModeActionPerformed
        inputMapping.remove("mouseMode");
        if (jCheckBoxMouseMode.isSelected())
            inputMapping.put("mouseMode", "yes");
    }//GEN-LAST:event_jCheckBoxMouseModeActionPerformed
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private de.malban.input.InputControllerDisplay inputControllerDisplay1;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButtonAreaDrag;
    private javax.swing.JButton jButtonByteFrame;
    private javax.swing.JButton jButtonCross;
    private javax.swing.JButton jButtonCrossDrag;
    private javax.swing.JButton jButtonDelete1;
    private javax.swing.JButton jButtonEndpoint;
    private javax.swing.JButton jButtonFileSelect1;
    private javax.swing.JButton jButtonFileSelect2;
    private javax.swing.JButton jButtonHTMLLink;
    private javax.swing.JButton jButtonHTMLText;
    private javax.swing.JButton jButtonHighlite;
    private javax.swing.JButton jButtonIOOutput;
    private javax.swing.JButton jButtonLAF;
    private javax.swing.JButton jButtonLoad;
    private javax.swing.JButton jButtonNew;
    private javax.swing.JButton jButtonPSGA;
    private javax.swing.JButton jButtonPSGB;
    private javax.swing.JButton jButtonPointHighlite;
    private javax.swing.JButton jButtonPointJoined;
    private javax.swing.JButton jButtonPointSelect;
    private javax.swing.JButton jButtonPre1;
    private javax.swing.JButton jButtonRegChanged;
    private javax.swing.JButton jButtonRegUnChanged;
    private javax.swing.JButton jButtonRelative;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JButton jButtonSelect;
    private javax.swing.JButton jButtonTabelSelection;
    private javax.swing.JButton jButtonVecciBackground;
    private javax.swing.JButton jButtonVecciBackground10;
    private javax.swing.JButton jButtonVecciBackground4;
    private javax.swing.JButton jButtonVecciBackground5;
    private javax.swing.JButton jButtonVecciBackground6;
    private javax.swing.JButton jButtonVecciBackground7;
    private javax.swing.JButton jButtonVecciForeground;
    private javax.swing.JButton jButtonVecciGrid;
    private javax.swing.JButton jButtonVectorDrag;
    private javax.swing.JButton jButtonVectorMove;
    private javax.swing.JButton jButtonVectorPos;
    private javax.swing.JButton jButtontableAddress;
    private javax.swing.JButton jButtontableBIOS;
    private javax.swing.JButton jButtontableBank;
    private javax.swing.JButton jButtontableIOInput;
    private javax.swing.JButton jButtonxAxis;
    private javax.swing.JButton jButtonyAxis;
    private javax.swing.JButton jButtonzAxis;
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
    private javax.swing.JCheckBox jCheckBox45;
    private javax.swing.JCheckBox jCheckBox46;
    private javax.swing.JCheckBox jCheckBox47;
    private javax.swing.JCheckBox jCheckBox48;
    private javax.swing.JCheckBox jCheckBox49;
    private javax.swing.JCheckBox jCheckBox5;
    private javax.swing.JCheckBox jCheckBox50;
    private javax.swing.JCheckBox jCheckBox51;
    private javax.swing.JCheckBox jCheckBox52;
    private javax.swing.JCheckBox jCheckBox53;
    private javax.swing.JCheckBox jCheckBox54;
    private javax.swing.JCheckBox jCheckBox55;
    private javax.swing.JCheckBox jCheckBox56;
    private javax.swing.JCheckBox jCheckBox57;
    private javax.swing.JCheckBox jCheckBox58;
    private javax.swing.JCheckBox jCheckBox59;
    private javax.swing.JCheckBox jCheckBox6;
    private javax.swing.JCheckBox jCheckBox60;
    private javax.swing.JCheckBox jCheckBox61;
    private javax.swing.JCheckBox jCheckBox62;
    private javax.swing.JCheckBox jCheckBox63;
    private javax.swing.JCheckBox jCheckBox64;
    private javax.swing.JCheckBox jCheckBox65;
    private javax.swing.JCheckBox jCheckBox66;
    private javax.swing.JCheckBox jCheckBox67;
    private javax.swing.JCheckBox jCheckBox7;
    private javax.swing.JCheckBox jCheckBox8;
    private javax.swing.JCheckBox jCheckBox9;
    private javax.swing.JCheckBox jCheckBoxAutoSync;
    private javax.swing.JCheckBox jCheckBoxColorMode;
    private javax.swing.JCheckBox jCheckBoxDeepSyntaxCheck;
    private javax.swing.JCheckBox jCheckBoxDeepSyntaxThresholdActive;
    private javax.swing.JCheckBox jCheckBoxEfficiency;
    private javax.swing.JCheckBox jCheckBoxFaultyVIA;
    private javax.swing.JCheckBox jCheckBoxGlow;
    private javax.swing.JCheckBox jCheckBoxJOGL;
    private javax.swing.JCheckBox jCheckBoxMSAA;
    private javax.swing.JCheckBox jCheckBoxMSAA1;
    private javax.swing.JCheckBox jCheckBoxMouseMode;
    private javax.swing.JCheckBox jCheckBoxNoise;
    private javax.swing.JCheckBox jCheckBoxOverflow;
    private javax.swing.JCheckBox jCheckBoxProfiler;
    private javax.swing.JCheckBox jCheckBoxScanForVectorLists;
    private javax.swing.JCheckBox jCheckBoxStarterImages;
    private javax.swing.JCheckBox jCheckBoxStarterImages1;
    private javax.swing.JCheckBox jCheckBoxVia;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JComboBox jComboBox2;
    private javax.swing.JComboBox jComboBox3;
    private javax.swing.JComboBox jComboBox4;
    private javax.swing.JComboBox jComboBox5;
    private javax.swing.JComboBox<String> jComboBox6;
    private javax.swing.JComboBox jComboBox7;
    private javax.swing.JComboBox<String> jComboBox8;
    private javax.swing.JComboBox jComboBox9;
    private javax.swing.JComboBox jComboBoxJoystickConfigurations;
    private javax.swing.JComboBox jComboBoxScreenModes;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel100;
    private javax.swing.JLabel jLabel101;
    private javax.swing.JLabel jLabel102;
    private javax.swing.JLabel jLabel103;
    private javax.swing.JLabel jLabel104;
    private javax.swing.JLabel jLabel105;
    private javax.swing.JLabel jLabel106;
    private javax.swing.JLabel jLabel107;
    private javax.swing.JLabel jLabel108;
    private javax.swing.JLabel jLabel109;
    private javax.swing.JLabel jLabel110;
    private javax.swing.JLabel jLabel111;
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
    private javax.swing.JLabel jLabel33;
    private javax.swing.JLabel jLabel34;
    private javax.swing.JLabel jLabel35;
    private javax.swing.JLabel jLabel36;
    private javax.swing.JLabel jLabel37;
    private javax.swing.JLabel jLabel38;
    private javax.swing.JLabel jLabel39;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel40;
    private javax.swing.JLabel jLabel41;
    private javax.swing.JLabel jLabel42;
    private javax.swing.JLabel jLabel43;
    private javax.swing.JLabel jLabel44;
    private javax.swing.JLabel jLabel45;
    private javax.swing.JLabel jLabel46;
    private javax.swing.JLabel jLabel47;
    private javax.swing.JLabel jLabel48;
    private javax.swing.JLabel jLabel49;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel50;
    private javax.swing.JLabel jLabel51;
    private javax.swing.JLabel jLabel52;
    private javax.swing.JLabel jLabel53;
    private javax.swing.JLabel jLabel54;
    private javax.swing.JLabel jLabel55;
    private javax.swing.JLabel jLabel56;
    private javax.swing.JLabel jLabel57;
    private javax.swing.JLabel jLabel58;
    private javax.swing.JLabel jLabel59;
    private javax.swing.JLabel jLabel60;
    private javax.swing.JLabel jLabel61;
    private javax.swing.JLabel jLabel62;
    private javax.swing.JLabel jLabel63;
    private javax.swing.JLabel jLabel64;
    private javax.swing.JLabel jLabel65;
    private javax.swing.JLabel jLabel66;
    private javax.swing.JLabel jLabel67;
    private javax.swing.JLabel jLabel68;
    private javax.swing.JLabel jLabel69;
    private javax.swing.JLabel jLabel70;
    private javax.swing.JLabel jLabel71;
    private javax.swing.JLabel jLabel72;
    private javax.swing.JLabel jLabel73;
    private javax.swing.JLabel jLabel74;
    private javax.swing.JLabel jLabel75;
    private javax.swing.JLabel jLabel76;
    private javax.swing.JLabel jLabel77;
    private javax.swing.JLabel jLabel78;
    private javax.swing.JLabel jLabel79;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel80;
    private javax.swing.JLabel jLabel81;
    private javax.swing.JLabel jLabel82;
    private javax.swing.JLabel jLabel83;
    private javax.swing.JLabel jLabel84;
    private javax.swing.JLabel jLabel85;
    private javax.swing.JLabel jLabel86;
    private javax.swing.JLabel jLabel87;
    private javax.swing.JLabel jLabel88;
    private javax.swing.JLabel jLabel89;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JLabel jLabel90;
    private javax.swing.JLabel jLabel91;
    private javax.swing.JLabel jLabel92;
    private javax.swing.JLabel jLabel93;
    private javax.swing.JLabel jLabel94;
    private javax.swing.JLabel jLabel95;
    private javax.swing.JLabel jLabel96;
    private javax.swing.JLabel jLabel97;
    private javax.swing.JLabel jLabel98;
    private javax.swing.JLabel jLabel99;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel10;
    private javax.swing.JPanel jPanel102;
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
    private javax.swing.JPanel jPanel25;
    private javax.swing.JPanel jPanel26;
    private javax.swing.JPanel jPanel27;
    private javax.swing.JPanel jPanel28;
    private javax.swing.JPanel jPanel29;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel30;
    private javax.swing.JPanel jPanel31;
    private javax.swing.JPanel jPanel32;
    private javax.swing.JPanel jPanel33;
    private javax.swing.JPanel jPanel34;
    private javax.swing.JPanel jPanel35;
    private javax.swing.JPanel jPanel36;
    private javax.swing.JPanel jPanel37;
    private javax.swing.JPanel jPanel38;
    private javax.swing.JPanel jPanel39;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel40;
    private javax.swing.JPanel jPanel41;
    private javax.swing.JPanel jPanel42;
    private javax.swing.JPanel jPanel43;
    private javax.swing.JPanel jPanel44;
    private javax.swing.JPanel jPanel45;
    private javax.swing.JPanel jPanel46;
    private javax.swing.JPanel jPanel47;
    private javax.swing.JPanel jPanel48;
    private javax.swing.JPanel jPanel49;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel50;
    private javax.swing.JPanel jPanel51;
    private javax.swing.JPanel jPanel52;
    private javax.swing.JPanel jPanel53;
    private javax.swing.JPanel jPanel54;
    private javax.swing.JPanel jPanel55;
    private javax.swing.JPanel jPanel56;
    private javax.swing.JPanel jPanel57;
    private javax.swing.JPanel jPanel58;
    private javax.swing.JPanel jPanel59;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel60;
    private javax.swing.JPanel jPanel61;
    private javax.swing.JPanel jPanel62;
    private javax.swing.JPanel jPanel63;
    private javax.swing.JPanel jPanel64;
    private javax.swing.JPanel jPanel65;
    private javax.swing.JPanel jPanel66;
    private javax.swing.JPanel jPanel67;
    private javax.swing.JPanel jPanel68;
    private javax.swing.JPanel jPanel69;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel70;
    private javax.swing.JPanel jPanel71;
    private javax.swing.JPanel jPanel72;
    private javax.swing.JPanel jPanel73;
    private javax.swing.JPanel jPanel74;
    private javax.swing.JPanel jPanel75;
    private javax.swing.JPanel jPanel76;
    private javax.swing.JPanel jPanel77;
    private javax.swing.JPanel jPanel78;
    private javax.swing.JPanel jPanel79;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel80;
    private javax.swing.JPanel jPanel81;
    private javax.swing.JPanel jPanel82;
    private javax.swing.JPanel jPanel83;
    private javax.swing.JPanel jPanel84;
    private javax.swing.JPanel jPanel85;
    private javax.swing.JPanel jPanel86;
    private javax.swing.JPanel jPanel87;
    private javax.swing.JPanel jPanel9;
    private javax.swing.JRadioButton jRadioButton1;
    private javax.swing.JRadioButton jRadioButton2;
    private javax.swing.JRadioButton jRadioButton3;
    private javax.swing.JRadioButton jRadioButton4;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JSlider jSliderBlankOff;
    private javax.swing.JSlider jSliderBlankOffTenth;
    private javax.swing.JSlider jSliderBlankOn;
    private javax.swing.JSlider jSliderBlankOnTenth;
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
    private javax.swing.JSlider jSliderScaleEfficency;
    private javax.swing.JSlider jSliderScaleEfficencyThresholdX;
    private javax.swing.JSlider jSliderScaleEfficencyThresholdY;
    private javax.swing.JSlider jSliderShift;
    private javax.swing.JSlider jSliderSplineDensity;
    private javax.swing.JSlider jSliderSplineMaxSize;
    private javax.swing.JSlider jSliderT1;
    private javax.swing.JSlider jSliderT_2;
    private javax.swing.JSlider jSliderXDrift;
    private javax.swing.JSlider jSliderXSH;
    private javax.swing.JSlider jSliderYDrift;
    private javax.swing.JSlider jSliderZeroDivider;
    private javax.swing.JSlider jSliderZeroRetainX;
    private javax.swing.JSlider jSliderZeroRetainY;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTabbedPane jTabbedPane2;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField10;
    private javax.swing.JTextField jTextField11;
    private javax.swing.JTextField jTextField12;
    private javax.swing.JTextField jTextField13;
    private javax.swing.JTextField jTextField14;
    private javax.swing.JTextField jTextField15;
    private javax.swing.JTextField jTextField16;
    private javax.swing.JTextField jTextField18;
    private javax.swing.JTextField jTextField19;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField20;
    private javax.swing.JTextField jTextField21;
    private javax.swing.JTextField jTextField22;
    private javax.swing.JTextField jTextField23;
    private javax.swing.JTextField jTextField24;
    private javax.swing.JTextField jTextField25;
    private javax.swing.JTextField jTextField26;
    private javax.swing.JTextField jTextField27;
    private javax.swing.JTextField jTextField28;
    private javax.swing.JTextField jTextField29;
    private javax.swing.JTextField jTextField3;
    private javax.swing.JTextField jTextField30;
    private javax.swing.JTextField jTextField31;
    private javax.swing.JTextField jTextField32;
    private javax.swing.JTextField jTextField33;
    private javax.swing.JTextField jTextField34;
    private javax.swing.JTextField jTextField6;
    private javax.swing.JTextField jTextField7;
    private javax.swing.JTextField jTextField8;
    private javax.swing.JTextField jTextField9;
    private javax.swing.JTextField jTextFieldCommentIndent;
    private javax.swing.JTextField jTextFieldFrameBuffer;
    private javax.swing.JTextField jTextFieldPath;
    private javax.swing.JTextField jTextFieldSingestepBuffer;
    private javax.swing.JTextField jTextFieldTabWidth;
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
        if (inputMapping.get("mouseMode") != null)jCheckBoxMouseMode.setSelected(true); else jCheckBoxMouseMode.setSelected(false);
        
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
                if (KeyboardListener.is_ShiftDown()) return;
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
                else
                if (e.type == ControllerEvent.CONTROLLER_AXIS_CHANGED)
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
                    
                    // possibly mouse
                    if (e.type == ControllerEvent.CONTROLLER_RELATIVE_CHANGED)
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
        // SwingUtilities.updateComponentTreeUI(jPopupMenu1);
        // SwingUtilities.updateComponentTreeUI(jPopupMenuTree);
        // SwingUtilities.updateComponentTreeUI(jPopupMenuProjectProperties);
        // int fontSize = Theme.textFieldFont.getFont().getSize();
        // int rowHeight = fontSize+2;
        // jTable1.setRowHeight(rowHeight);
        keyBindingsJPanel1.updateMyUI();
        styleJPanel1.updateMyUI();
        
        SwingUtilities.invokeLater(new Runnable() 
        {
            @Override
            public void run() 
            {
                int tabYOffset = jPanel20.getBounds().y;
                int tabXOffset = jPanel20.getBounds().x;
                int maxY = jPanel35.getBounds().y+jPanel35.getBounds().height+tabYOffset;
                int maxX2 = jPanel7.getBounds().x+jPanel7.getBounds().width+tabXOffset;
                
                int maxX = maxX2;
//                if (maxX2>maxX) maxX = maxX2;
                

                jTabbedPane1.setPreferredSize(new Dimension(maxX,maxY));
            }
        });
    }
    public static void changeTab()
    {
        if (((CSAMainFrame)Configuration.getConfiguration().getMainFrame()) == null) return;
        ArrayList<Object> allVecxis = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getPanels(VediPanel.class);
        for (Object p : allVecxis) 
            ((VediPanel)p).reDisplayAll();
/*
        SwingUtilities.invokeLater(new Runnable() 
        {
            @Override
            public void run() 
            {
                ArrayList<Object> allVecxis = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getPanels(VediPanel.class);
                for (Object p : allVecxis) 
                    ((VediPanel)p).reDisplayAll();
            }
        });
*/        
    }
    
    void changeDisplay()
    {
        config.ALG_MAX_X = de.malban.util.UtilityString.IntX(jTextField11.getText(), 38000);
        config.ALG_MAX_Y = de.malban.util.UtilityString.IntX(jTextField12.getText(), 41000);
        config.cartOverwriteSaves.ALG_MAX_X = config.ALG_MAX_X;
        config.cartOverwriteSaves.ALG_MAX_Y = config.ALG_MAX_Y;

        
        
        ArrayList<Object> allVecxis = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getPanels(VecXPanel.class);
        for (Object p : allVecxis) ((VecXPanel)p).changeDisplay();
    }
 
    void updateVecxBuffer()
    {
        ArrayList<Object> allVecxis = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getPanels(VecXPanel.class);
        for (Object p : allVecxis) ((VecXPanel)p).resetBuffer();
    }

    public void deIconified()  {}
    
    
    
    
    
    private void setScreenModes()
    {
        jComboBoxScreenModes.removeAllItems();
        GraphicsEnvironment env = GraphicsEnvironment.getLocalGraphicsEnvironment();
        GraphicsDevice[] devices = env.getScreenDevices();
        DisplayMode[] modes = devices[0].getDisplayModes();

        for (int i = 0; i < modes.length; i++)
        {
            DisplayMode displayMode = modes[i];
            String m = "";
            m+= displayMode.getWidth()+"x";
            m+= displayMode.getHeight()+" ";
            m+= displayMode.getBitDepth()+"bit ";
            m+= displayMode.getRefreshRate()+"Hz";
            jComboBoxScreenModes.addItem(m);
        }
    }

    public static DisplayMode getDisplayModeForString(String s)
    {
        GraphicsEnvironment env = GraphicsEnvironment.getLocalGraphicsEnvironment();
        GraphicsDevice[] devices = env.getScreenDevices();
        DisplayMode[] modes = devices[0].getDisplayModes();

        for (int i = 0; i < modes.length; i++)
        {
            DisplayMode displayMode = modes[i];
            String m = "";
            m+= displayMode.getWidth()+"x";
            m+= displayMode.getHeight()+" ";
            m+= displayMode.getBitDepth()+"bit ";
            m+= displayMode.getRefreshRate()+"Hz";
            if (s.equals(m)) return displayMode;
            if (m.startsWith(s)) return displayMode;
        }

        // default to something senseable, taken first mode with res of 1024width
        for (int i = 0; i < modes.length; i++)
        {
            DisplayMode displayMode = modes[i];
            String m = "";
            m+= displayMode.getWidth()+"x";
            m+= displayMode.getHeight()+" ";
            m+= displayMode.getBitDepth()+"bit ";
            m+= displayMode.getRefreshRate()+"Hz";
            if ((displayMode.getWidth()==1024) && (displayMode.getBitDepth() == 32))
            {
                return displayMode;
            }
        }
        // default to something senseable, taken first mode with res of 1024width
        for (int i = 0; i < modes.length; i++)
        {
            DisplayMode displayMode = modes[i];
            String m = "";
            m+= displayMode.getWidth()+"x";
            m+= displayMode.getHeight()+" ";
            m+= displayMode.getBitDepth()+"bit ";
            m+= displayMode.getRefreshRate()+"Hz";
            if ((displayMode.getWidth()==1024) && (displayMode.getBitDepth() == 16))
            {
                return displayMode;
            }
        }
        // default to something senseable, taken first mode with res of 1024width
        for (int i = 0; i < modes.length; i++)
        {
            DisplayMode displayMode = modes[i];
            String m = "";
            m+= displayMode.getWidth()+"x";
            m+= displayMode.getHeight()+" ";
            m+= displayMode.getBitDepth()+"bit ";
            m+= displayMode.getRefreshRate()+"Hz";
            if ((displayMode.getWidth()==1024) && (displayMode.getBitDepth() == 8))
            {
                return displayMode;
            }
        }
        return null;
    }

    public static String buildStringForMode(DisplayMode displayMode)
    {
        String m = "";
        if (displayMode == null) return m;
        m+= displayMode.getWidth()+"x";
        m+= displayMode.getHeight()+" ";
        m+= displayMode.getBitDepth()+"bit ";
        m+= displayMode.getRefreshRate()+"Hz";
        return m;
    }
    
     void correctScreenModeIfNeccessary()
    {
        Configuration C = Configuration.getConfiguration();
        C.setFullScrrenResString(buildStringForMode(getDisplayModeForString(C.getFullScrrenResString())));
    }    
    public void checkDebuging()
    {
        // jCheckBox8.setEnabled(config.debugingCore);
        // jCheckBox24.setEnabled(config.debugingCore);
        
        
        if ((config.useRayGun) && (!config.debugingCore)) config.useRayGun=false;
        jCheckBox41.setEnabled(config.debugingCore);
        
        jCheckBox42.setEnabled(config.debugingCore);
        jCheckBox50.setEnabled(config.debugingCore);
        jCheckBox22.setEnabled(config.debugingCore);
        jCheckBoxProfiler.setEnabled(config.debugingCore);
        jCheckBox6.setEnabled(config.debugingCore);
        jCheckBox23.setEnabled(config.debugingCore);
        jLabel1.setEnabled(config.debugingCore);
        jLabel36.setEnabled(config.debugingCore);
        jTextFieldFrameBuffer.setEnabled(config.debugingCore);
        jTextFieldSingestepBuffer.setEnabled(config.debugingCore);
        
    }
    void setAllBackgrounds(Color backColor)
    {
        ArrayList<TokenStyles.MyStyle> cloneStyleList = TokenStyles.styleList;
        TokenStyles.reset();
        
        for (TokenStyles.MyStyle style: cloneStyleList)
        {
            TokenStyles.addStyle(
                style.name,
                backColor,
                StyleConstants.getForeground(style), 
                StyleConstants.isBold(style),
                StyleConstants.isItalic(style),
                StyleConstants.getFontSize(style),
                StyleConstants.getFontFamily(style)
                );
        }
        styleJPanel1.refresh();
    }
    void PSGColorsChanged()
    {
    }
    public static boolean showEditPeepProperties()
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        PeepJPanel panel = new PeepJPanel();
        
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addAsWindow(panel,  700, 700, "PeepConfig");
     
  
        return true;
    }

}

