/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide;

import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.HotKey;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.sound.tinysound.TinySound;
import de.malban.util.syntax.Syntax.TokenStyles;
import de.muntjak.tinylookandfeel.Theme;
import de.muntjak.tinylookandfeel.TinyLookAndFeel;
import java.io.File;
import java.io.FilenameFilter;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;

/**
 *
 * @author Malban
 */
public class VideConfig  implements Serializable{
    // VECX CONFIG
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    public int[] delays = {0,5,0,9,8,0,0,0,11,0,13, 4}; // full delays, ramp on and off have partials!
    public double[] partialDelays = {0,0,0,0,0,0,0,0,0,0, 0}; // this is not used!
    public String[] delaysDisplay = {"-", "ZERO", "BLANK", "RAMP", "YSH", "SSH", "ZSH", "RSH", "XSH", "LIGHTPEN", "RAMP_OFF", "MUX_SEL"};
    public double rampOffFractionValue = 0.0; // only implemented "partial" delay for ramp off
    public double rampOnFractionValue = 0.9; // only implemented "partial" delay for ramp off
    public double blankOnDelay = 0; // look at an M or a W, that would not be possible!
    public double reverseBlankLeak = 0.0; // not used anymorew ! look at an M or a W, that would not be possible!
    public boolean drawBlanks = false; // not implemented
    public boolean cycleExactEmulation = true;
    public boolean breakpointsActive = true;
    public boolean enableBankswitch = true;
    public boolean codeScanActive = true;
    public boolean ringbufferActive = true;
    public double warmup = 0; // resolution 0.01
    public double cooldown = 0; // resolution 0.01
    public String usedSystemRom="system"+File.separator+"FASTBOOT.IMG";
    public double drift_x = .1; // resolution 0.01
    public double drift_y = -.02; // resolution 0.01
    public boolean useRayGun = false;
    public boolean autoSync = true;
    public boolean vectorInformationCollectionActive = true;
    public boolean useGlow = true;
    public int brightness = 0; // 0 is default, positive is bright, negative is darker
    public int generation = 3;  // 1-3
    public boolean efficiencyEnabled = false;
    public double efficiency = 20.0;
    public double noisefactor = 1;
    public boolean noise = false;
    public int masterVolume = 255;
    public int psgVolume = 180;

    public double overflowFactor = 150;
    public boolean emulateIntegrationOverflow = false;
    public boolean resetBreakpointsOnLoad = true;
    public boolean psgSound = true;

    public boolean syncCables = false;
    public boolean speedLimit = true;
    public boolean imagerAutoOnDefault = false;
    
    /// ASSI CONFIG
    public boolean expandBranches=true;
    
    // this one is really dangerous, default is OFF!
    public boolean enable8bitExtendedToDirect = false; // if set, even when no DP is set, asmj uses direct addressen, when value is 8bit
    public boolean excludeJumpsToDirect = true; // if set, even when no DP is set, asmj uses direct addressen, when value is 8bit
    
    // allow constructs like " leay #2,y" which are really bad syntax (but as09 allows it)
    public boolean beLaxWithHashTagAndImmediate=true;
    
    public boolean treatUndefinedAsZero = true;
    
    // opt does:
    // lbra -> jmp
    // lb?? -> b?? if offset is small enough
    public boolean opt = true;
    public boolean outputLST = false;
    public boolean includeRelativeToParent = false;
    
    
    // VECXPANEL - DISPLAY
    public int splineDensity = 1; // curve control point every x pixel    
    public boolean useQuads = false; 
    public int persistenceAlpha=120;
    public boolean antialiazing = true;
    public int lineWidth = 2;
    public boolean vectorsAsArrows = false;
    public boolean paintIntegrators = false;
    public int multiStepDelay = 10;
    public boolean useSplines = true;
    public boolean supressDoubleDraw = true;
    public boolean overlayEnabled = true;
    
    // DISSI
    public boolean assumeVectrex = true;
    public boolean createUnkownLabels = true;
    public boolean lstFirst = true;

    // VEDI
    public boolean invokeEmulatorAfterAssembly = true;
    public boolean scanMacros = true;
    public boolean scanVars = true;
    public boolean scanForVectorLists = false;
    
    public String themeFile = "";

    private static VideConfig theOneConfig = new VideConfig();
    
    public static String loadedConfig="";
    
    static class KeySupport implements Serializable
    {
        // make sure statics are initialized!
        HotKey bla = new HotKey("dummy", null, (JPanel) null);

        HashMap <String, HotKey> allMappings = HotKey.allMappings;
        ArrayList<HotKey> hotkeyList = HotKey.hotkeyList;
    }
    KeySupport keySupport = new KeySupport();
    
    static class StyleSupport implements Serializable
    {
        HashMap styles = TokenStyles.styles;
        ArrayList styleList = TokenStyles.styleList;
    }
    StyleSupport styleSupport = new StyleSupport();
    
    public static VideConfig getConfig()
    {
        return theOneConfig;
    }
    private VideConfig()
    {
        load("Default.vsv");
    }

    // filename + path
    public boolean save(String filename)
    {
        try
        {
            keySupport = new KeySupport();
            styleSupport = new StyleSupport();
            loadedConfig = filename;
            return CSAMainFrame.serialize(this ,filename);
        }
        catch (Throwable e)
        {
            log.addLog("Could not save configuration!", WARN);
        }
        return false;
    }

    // filename only
    public boolean load(String filename)
    {
        try
        {
            VideConfig newConfig =  (VideConfig) CSAMainFrame.deserialize("serialize"+File.separator+filename);
            if (newConfig == null) return false;
            copyAll(newConfig, this);
            loadedConfig = filename;
            double v =  ((double) masterVolume)/(double)255.0;
            TinySound.setGlobalVolume(v);
            if (keySupport != null)
            {
                if ( keySupport.allMappings.size()>0)
                {
                    HotKey.allMappings = keySupport.allMappings;
                    HotKey.hotkeyList = keySupport.hotkeyList;
                }
            }
            if (styleSupport != null)
            {
                if (styleSupport.styles.size()>0)
                {
                    TokenStyles.styles = styleSupport.styles;
                    TokenStyles.styleList = styleSupport.styleList;
                }
            }
            
            if (themeFile!=null)
            {
                if (themeFile.length()!=0)
                {
                    File file = new File(de.malban.util.UtilityFiles.convertSeperator(themeFile));
                    if (file.exists())
                    {
                        Theme.loadTheme(file);
                        // re-install the Tiny Look and Feel
                        UIManager.setLookAndFeel(new TinyLookAndFeel());

                        // Update the ComponentUIs for all Components. This
                        // needs to be invoked for all windows.
                        SwingUtilities.updateComponentTreeUI(Configuration.getConfiguration().getMainFrame());  
                    }
                }
            }
        }
        catch (Throwable e)
        {
            log.addLog("Could not load saved configuration!", WARN);
            return false;
        }

        return true;
    }
    
    // must copy all, 
    // otherwise all "children" would need to reset their config...
    
    private void copyAll(VideConfig from, VideConfig to)
    {
        System.arraycopy(from.delays, 0, to.delays, 0, from.delays.length);
        System.arraycopy(from.partialDelays, 0, to.partialDelays, 0, from.partialDelays.length);
        System.arraycopy(from.delaysDisplay, 0, to.delaysDisplay, 0, from.delaysDisplay.length);
        to.keySupport = from.keySupport;
        to.styleSupport = from.styleSupport;
        to.themeFile = from.themeFile;
        to.rampOffFractionValue = from.rampOffFractionValue; // only implemented "partial" delay for ramp off
        to.rampOnFractionValue = from.rampOnFractionValue; // only implemented "partial" delay for ramp off
        to.blankOnDelay = from.blankOnDelay; // look at an M or a W, that would not be possible!
        to.reverseBlankLeak = from.reverseBlankLeak; // not used anymorew ! look at an M or a W, that would not be possible!
        to.drawBlanks = from.drawBlanks; // not implemented
        to.cycleExactEmulation = from.cycleExactEmulation;
        to.breakpointsActive = from.breakpointsActive;
        to.enableBankswitch = from.enableBankswitch;
        to.codeScanActive = from.codeScanActive;
        to.ringbufferActive = from.ringbufferActive;
        to.warmup = from.warmup; // resolution 0.01
        to.cooldown = from.cooldown; // resolution 0.01
        to.usedSystemRom=from.usedSystemRom;
        to.drift_x = from.drift_x; // resolution 0.01
        to.drift_y = from.drift_y; // resolution 0.01
        to.useRayGun = from.useRayGun;
        to.autoSync = from.autoSync;
        to.generation = from.generation;
        to.efficiencyEnabled = from.efficiencyEnabled;
        to.efficiency = from.efficiency;
        to.noise = from.noise;
        to.noisefactor = from.noisefactor;
        to.overflowFactor = from.overflowFactor;
        to.emulateIntegrationOverflow = from.emulateIntegrationOverflow;
        to.resetBreakpointsOnLoad = from.resetBreakpointsOnLoad;
        to.vectorInformationCollectionActive = from.vectorInformationCollectionActive;
        to.masterVolume = from.masterVolume;
        to.psgSound = from.psgSound;
        to.psgVolume = from.psgVolume;
        to.speedLimit = from.speedLimit;
        to.imagerAutoOnDefault = from.imagerAutoOnDefault;
        

        /// ASSI CONFIG
        to.expandBranches = from.expandBranches;
        to.enable8bitExtendedToDirect = from.enable8bitExtendedToDirect;
        to.excludeJumpsToDirect = from.excludeJumpsToDirect;
        to.beLaxWithHashTagAndImmediate = from.beLaxWithHashTagAndImmediate;
        to.treatUndefinedAsZero = from.treatUndefinedAsZero;
        to.includeRelativeToParent = from.includeRelativeToParent;
        to.opt = from.opt;
        to.outputLST = from.outputLST;
    
        // VECXPANEL - DISPLAY
        to.splineDensity = from.splineDensity;
        to.useQuads = from.useQuads;
        to.persistenceAlpha = from.persistenceAlpha;
        to.antialiazing = from.antialiazing;
        to.lineWidth = from.lineWidth;
        to.vectorsAsArrows = from.vectorsAsArrows;
        to.paintIntegrators = from.paintIntegrators;
        to.multiStepDelay = from.multiStepDelay;
        to.useSplines = from.useSplines;
        to.supressDoubleDraw = from.supressDoubleDraw;
        to.brightness = from.brightness;
        to.useGlow = from.useGlow;
        to.overlayEnabled = from.overlayEnabled;
        
        
        // DISSI
        to.assumeVectrex = from.assumeVectrex;
        to.createUnkownLabels = from.createUnkownLabels;
        to.lstFirst = from.lstFirst;

        // VEDI
        to.invokeEmulatorAfterAssembly = from.invokeEmulatorAfterAssembly;
        to.scanMacros = from.scanMacros;
        to.scanVars = from.scanVars;
        to.scanForVectorLists = from.scanForVectorLists;
        
        
            
        
    }
    
    public static File[] getConfigs()
    {
        File dir = new File("serialize");
        File[] files = dir.listFiles(new FilenameFilter() 
        {
                @Override
                public boolean accept(File dir, String name) 
                {
                    return name.toLowerCase().endsWith(".vsv");
                }
            });     
        return files;
    }
    
}
