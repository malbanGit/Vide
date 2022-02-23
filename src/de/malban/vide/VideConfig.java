/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide;

import com.fazecast.jSerialComm.SerialPort;
import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.graphics.VectorColors;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.HotKey;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.input.EventController;
import de.malban.input.SystemController;
import de.malban.sound.tinysound.TinySound;
import de.malban.util.syntax.Syntax.TokenStyles;
import static de.malban.vide.vecx.VecXStatics.TIMER_T2;
import de.malban.vide.vecx.cartridge.CartridgeProperties;
import de.muntjak.tinylookandfeel.Theme;
import java.awt.Color;
import java.io.File;
import java.io.FilenameFilter;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.swing.JPanel;
import javax.swing.text.html.HTMLEditorKit;
import javax.swing.text.html.StyleSheet;
import net.java.games.input.Controller;

/**
 *
 * @author Malban
 */

class KeySupport implements Serializable
{
   // make sure statics are initialized!
   HotKey bla = new HotKey("dummy", null, (JPanel) null);

   HashMap <String, HotKey> allMappings = HotKey.allMappings;
   ArrayList<HotKey> hotkeyList = HotKey.hotkeyList;
}

class StyleSupport implements Serializable
{
   HashMap styles = TokenStyles.styles;
   ArrayList styleList = TokenStyles.styleList;
}

class ConfigStatic1 implements Serializable
{
   public  int CHASSIS_AVAILABLE = 0; // 0 not tried, 1 = yes, -1 no and have tried
   public          int DRIFT_CURVE_THRESHOLD = 10;

   public int ALG_MAX_X		= 43000;
   public int ALG_MAX_Y		= 45000;
   public String startFile = "";

  // public int[] delays = {0,5,0,11,4,0,0,0,11,0,13, 2, 3, 1}; // full delays, ramp on and off have partials!
   public int[] delays = {0,5,0,0,11,11,0,0,0,11,0,14, 2, 2, 2, 1}; // full delays, ramp on and off have partials!
   public double[] partialDelays = {0,0,0,0,0,0,0,0,0,0, 0}; // this is not used!
   public String[] delaysDisplay = {"-", "ZERO", "BLANK_ON", "BLANK_OFF", "RAMP", "YSH", "SSH", "ZSH", "RSH", "XSH", "LIGHTPEN", "RAMP_OFF", "MUX_SEL", "SHIFT", "T1", "T2"};
   
   public double zeroRetainX = 50.0/10000.0;
   public double zeroRetainY = 50.0/10000.0;
   public double zero_divider = 6.80;

   public double rampOffFractionValue = 0.9; // only implemented "partial" delay for ramp off
   public double rampOnFractionValue = 0.8; // only implemented "partial" delay for ramp off
   public double blankOnDelay = 1.0; // look at an M or a W, that would not be possible!
   public double blankOffDelay = 1.0; // look at an M or a W, that would not be possible!
   public double reverseBlankLeak = 0.0; // not used anymorew ! look at an M or a W, that would not be possible!
   public boolean drawBlanks = false; // not implemented
   public boolean cycleExactEmulation = true;
   public boolean breakpointsActive = true;
   public boolean enableBankswitch = true;
   public boolean codeScanActive = false;
   public boolean ringbufferActive = false;
   public double warmup = 0; // resolution 0.01
   public double cooldown = 0; // resolution 0.01
   public String usedSystemRom="system"+File.separator+"FASTBOOT.IMG";
   public double drift_x = .09; // resolution 0.01
   public double drift_y = -.04; // resolution 0.01
   public boolean useRayGun = false;
   public boolean autoSync = true;
   public boolean vectorInformationCollectionActive = false;
   public boolean useGlow = true;
   public int brightness = 10; // 0 is default, positive is bright, negative is darker
   public int generation = 1;  // 1-3
   public boolean efficiencyEnabled = true;
   public double efficiency = 5.0;
   public double efficiencyThresholdY = 0.91;
   public double efficiencyThresholdX = 1.80;
   public double noisefactor = 3.8;
   public boolean noise = true;
   public int masterVolume = 255;
   public int psgVolume = 180;
   public  boolean viaShift9BugEnabled = false;
   public  double scaleEfficiency = 1.0;
   public int rotate = 0; 
   public boolean ramAccessAllowed = false;
   public int singestepBuffer = 2000;
   public int frameBuffer = 500; // ca. 20 seconds!

   public boolean useLibAYEmu = false;
   public String useLibAYEmuTable = "AY_Kay";

   public double overflowFactor = 150;
   public boolean emulateIntegrationOverflow = false;
   public boolean resetBreakpointsOnLoad = true;
   public boolean psgSound = true;

   public boolean syncCables = false;
   public boolean speedLimit = true;
   public boolean imagerAutoOnDefault = false;

   public int minimumSpinnerChangeCycles = 30000;
   public int jinputPolltime = 50;
   public boolean doProfile = false;


   /// ASSI CONFIG
   public boolean expandBranches=true;
   public boolean supportUnusedSymbols = true;
   public boolean warnOnDoubleDefine = true;

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

   public boolean loadStarterImages = false;

   // VECXPANEL - DISPLAY
   public int splineDensity = 1; // curve control point every x pixel    
   public int maxSplineSize= 5000;

   public boolean useQuads = false; 
   public int persistenceAlpha=140;
   public boolean antialiazing = true;
   public int lineWidth = 2;
   public boolean vectorsAsArrows = false;
   public boolean paintIntegrators = false;
   public int multiStepDelay = 10;
   public boolean useSplines = true;
   public boolean supressDoubleDraw = false;
   public boolean overlayEnabled = true;
   public boolean emulateBorders = true;

   public boolean tryJOGL = true;
   public boolean JOGLMSAA = true;
   public int JOGLmultiSample = 8;
   public boolean JOGLadditiveBlur = false;    
   public boolean JOGLuseGlowShader = true;    
   public int JOGLblurPass = 5;
   public double JOGL_SIGMA = 3.6D;            
   public int JOGL_GAUSS_RADIUS = 5;
   public boolean JOGLaddBase = true;
   public double JOGLGlowThreshold = 0.0D;
   public boolean JOGLuseSpillShader = true;
   public double JOGLInitialSpillDivisor = 2.5D;
   public double JOGLSpillThreshold = 0.0D;
   public double JOGLFinalSpillMultiplyer = 4D;
   public int JOGLSpillPass = 1;
   public boolean JOGLSpillAddBase = true;
   public boolean JOGLSpillUnfactordAddBase = true;
   public float JOGL_speedMaxReduce = 0.5f;
   public float JOGLDotDwellDivisor = 40f;
   public boolean JOGLOverlayAdjustment = true;
   public float JOGLOverlayAlphaThreshold = 0.7f;
   public float JOGLOverlayAlphaAdjustmentFactor = 0.3f;
   public float JOGLOverlayBrightnessAlphaAdjustmentFactor = 0.4f;
   public boolean JOGLAutoDisplay = false;
   public boolean JOGLUseLinearSampling = true;
   public int JOGLMIP_RESOLUTION = 0;
   public float overflowIntensityDivider = 30000f;

   public boolean JOGLScreenAdjustment = true;
   public float JOGLScreenBrightnessAdjustmentFactor = 0.45f;

   public boolean JOGLScreen = true;
   public boolean JOGLHolders = false;
   public boolean JOGLFrame = false;
   public boolean JOGLCartridge = false;
   public boolean JOGLJoytsickpanel = false;
   public boolean JOGLCablePort1 = false;
   public boolean JOGLCablePort2 = false;

   public boolean keepAspectRatio = true;
   public String fullscreenResolution = "800x600";

   // DISSI
   public boolean assumeVectrex = true;
   public boolean createUnkownLabels = true;
   public boolean lstFirst = true;
   public boolean pleaseforceDissiIconizeOnRun = false; // !(/&%"/(&!%(/!&%!(/&%(/&"%"
   public boolean romAndPcBreakpoints = false;
   public boolean debugingCore = true;

   public boolean motdActive = true;

   // VEDI
   public boolean invokeEmulatorAfterAssembly = true;
   public boolean scanMacros = true;
   public boolean scanVars = true;
   public boolean scanForVectorLists = false;
   public boolean autoEjectV4EonCompile = true;
   public String v4eVolumeName = "";
   public int tab_width = 4;

   public int TAB_EQU = 30;
   public int TAB_EQU_VALUE = 40;
   public int TAB_MNEMONIC = 20;
   public int TAB_OP = 30;
   public int TAB_COMMENT = 58;


   public int deepSyntaxCheckTiming = 10000; // in ms
   public boolean deepSyntaxCheck = true;

   public int deepSyntaxCheckThreshold = 100000; // in ms
   public boolean deepSyntaxCheckThresholdActive = true;

   // vecci    
   public  Color VECCI_BACKGROUND_COLOR = Color.BLACK;
   public  Color VECCI_CROSS_COLOR = Color.ORANGE;
   public  Color VECCI_CROSS_DRAG_COLOR = Color.GREEN;
   public  Color VECCI_GRID_COLOR = new Color(50,50,50,128);
   public  Color VECCI_FRAME_COLOR = new Color(0,255,255,255);
   public  Color VECCI_VECTOR_FOREGROUND_COLOR = new Color(255,255,255,255); // not used, vectors have "own" color
   public  Color VECCI_VECTOR_BACKGROUND_COLOR = new Color(50,50,50,128);
   public  Color VECCI_VECTOR_ENDPOINT_COLOR = Color.red;
   public  Color VECCI_VECTOR_HIGHLIGHT_COLOR = new Color(255,50,255,255);
   public  Color VECCI_VECTOR_SELECTED_COLOR = new Color(50,50,255,255);
   public  Color VECCI_VECTOR_RELATIVE_COLOR = new Color(255,0,255,255);
   public  Color VECCI_VECTOR_DRAG_COLOR = new Color(255,255,0,255);
   public  Color VECCI_POINT_HIGHLIGHT_COLOR = new Color(255,50,255,255);
   public  Color VECCI_POINT_SELECTED_COLOR = new Color(50,50,255,255);
   public  Color VECCI_POS_COLOR = new Color(200,255,200,255);
   public  Color VECCI_POINT_JOINED_COLOR = new Color(150,50,255,255);
   public  Color VECCI_MOVE_COLOR = new Color(50,50,155,255);
   public  Color VECCI_DRAG_AREA_COLOR = new Color(0,200,0,50);
   public  Color VECCI_X_AXIS_COLOR = Color.BLUE;
   public  Color VECCI_Y_AXIS_COLOR = Color.GREEN;
   public  Color VECCI_Z_AXIS_COLOR = Color.MAGENTA;
   public KeySupport keySupport = new KeySupport();
   public StyleSupport styleSupport = new StyleSupport();
   public String themeFile = "";

   public Color valueChanged = Color.red;
   public Color valueNotChanged = Color.black;
   public Color tableOtherBank = new Color(200,255,255);
   public Color tableBIOS = new Color(200,200,200);
   public Color tableAddress = new Color(200,255,200,255);
   public Color psgChannelA = new Color(204,204,255);
   public Color psgChannelB = new Color(255,204,255);
   public Color psgChannelC = new Color(255,204,204);
   public Color psgChannelNoise =new Color(204,204,204);
   public Color ymCurrentLineBack = new Color(200,200,255);
   public Color linkColor = Color.blue;
   public Color htmltext = Color.black;

   public Color IOInput = new Color(0,203,255);
   public Color IOOutput  = new Color(215,255,188);
   public Color dataSelection = new Color(200,200,255);
}

class ConfigStatic2 implements Serializable
{
   public Color cLinesFore = new Color(250,250,80);
   public Color cLinesBack  = new Color(100,100,255);
   public Color cLsinesBack  = new Color(100,100,255);

   public boolean vectrexColorMode = false; 
   public boolean displayModeWriting = true;
   public boolean isFaultyVIA = false;
   public int SHORT_TAB_OP = 1;
   public int t2Delay = 1;

   public boolean invokeVecMultiAfterAssembly = false;
   public String vecMultiPortDescriptor = SerialPort.getCommPorts().length == 0 ? null : SerialPort.getCommPorts()[0].getSystemPortName();
}

public class VideConfig  implements Serializable{
    // VECX CONFIG
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    
    public static boolean hotKeysEnabled = true;
    public static boolean syntaxHighliteEnabled = true;
    public static boolean editorUndoEnabled = true;
    
    
    ///////// static 1
    public static int CHASSIS_AVAILABLE = 0; // 0 not tried, 1 = yes, -1 no and have tried
    public static         int DRIFT_CURVE_THRESHOLD = 10;

    public static transient ArrayList<ControllerConfig> controllerConfigs = null;
    public int ALG_MAX_X		= 43000;
    public int ALG_MAX_Y		= 45000;
    public String startFile = "";
    
   // public int[] delays = {0,5,0,11,4,0,0,0,11,0,13, 2, 3, 1}; // full delays, ramp on and off have partials!
   public int[] delays = {0,5,0,0,11,11,0,0,0,11,0,14, 2, 2, 2, 1}; // full delays, ramp on and off have partials!
   public double[] partialDelays = {0,0,0,0,0,0,0,0,0,0, 0}; // this is not used!
   public String[] delaysDisplay = {"-", "ZERO", "BLANK_ON", "BLANK_OFF", "RAMP", "YSH", "SSH", "ZSH", "RSH", "XSH", "LIGHTPEN", "RAMP_OFF", "MUX_SEL", "SHIFT", "T1", "T2"};
    
   public double zeroRetainX = 50.0/10000.0;
   public double zeroRetainY = 50.0/10000.0;
    public double zero_divider = 6.80;
    
    public double rampOffFractionValue = 0.9; // only implemented "partial" delay for ramp off
    public double rampOnFractionValue = 0.8; // only implemented "partial" delay for ramp off
    public double blankOnDelay = 1.0; // look at an M or a W, that would not be possible!
    public double blankOffDelay = 1.0; // look at an M or a W, that would not be possible!
    public double reverseBlankLeak = 0.0; // not used anymorew ! look at an M or a W, that would not be possible!
    public boolean drawBlanks = false; // not implemented
    public boolean cycleExactEmulation = true;
    public boolean breakpointsActive = true;
    public boolean enableBankswitch = true;
    public boolean codeScanActive = false;
    public boolean ringbufferActive = false;
    public boolean displayModeWriting = true;
    public boolean vectrexColorMode = false;

    public String usedSystemRom="system"+File.separator+"FASTBOOT.IMG";
    public double drift_x = .09; // resolution 0.01
    public double drift_y = -.04; // resolution 0.01
    public boolean useRayGun = false;
    public boolean autoSync = true;
    public boolean vectorInformationCollectionActive = false;
    public boolean useGlow = true;
    public int brightness = 10; // 0 is default, positive is bright, negative is darker
    public int generation = 1;  // 1-3
    public boolean efficiencyEnabled = true;
    public double efficiency = 5.0;
    public double efficiencyThresholdY = 0.91;
    public double efficiencyThresholdX = 1.80;
    public double noisefactor = 3.8;
    public boolean noise = true;
    public int masterVolume = 255;
    public int psgVolume = 180;
    public  boolean viaShift9BugEnabled = false;
    public static double scaleEfficiency = 1.0;
    public int rotate = 0; 
    public boolean ramAccessAllowed = false;
    public int singestepBuffer = 30000;
    public int frameBuffer = 1000; // ca. 20 seconds!
    
    public boolean useLibAYEmu = false;
    public String useLibAYEmuTable = "AY_Kay";

    public double overflowFactor = 150;
    public boolean emulateIntegrationOverflow = false;
    public boolean resetBreakpointsOnLoad = true;
    public boolean psgSound = true;

    public boolean syncCables = false;
    public boolean speedLimit = true;
    public boolean imagerAutoOnDefault = false;
    
    public int minimumSpinnerChangeCycles = 30000;
    public int jinputPolltime = 50;
    public boolean doProfile = false;
    
    
    /// ASSI CONFIG
    public boolean expandBranches=true;
    public boolean supportUnusedSymbols = true;
    public boolean warnOnDoubleDefine = true;
    
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
    
    public boolean loadStarterImages = false;
    
    // VECXPANEL - DISPLAY
    public int splineDensity = 1; // curve control point every x pixel    
    public int maxSplineSize= 5000;

    public boolean useQuads = false; 
    public int persistenceAlpha=140;
    public boolean antialiazing = true;
    public int lineWidth = 2;
    public boolean vectorsAsArrows = false;
    public boolean paintIntegrators = false;
    public int multiStepDelay = 10;
    public boolean useSplines = true;
    public boolean supressDoubleDraw = false;
    public boolean overlayEnabled = true;
    public boolean emulateBorders = true;

    public boolean tryJOGL = true;
    public boolean JOGLMSAA = true;
    public int JOGLmultiSample = 8;
    public boolean JOGLadditiveBlur = false;    
    public boolean JOGLuseGlowShader = true;    
    public int JOGLblurPass = 5;
    public double JOGL_SIGMA = 3.6D;            
    public int JOGL_GAUSS_RADIUS = 5;
    public boolean JOGLaddBase = true;
    public double JOGLGlowThreshold = 0.0D;
    public boolean JOGLuseSpillShader = true;
    public double JOGLInitialSpillDivisor = 2.5D;
    public double JOGLSpillThreshold = 0.0D;
    public double JOGLFinalSpillMultiplyer = 4D;
    public int JOGLSpillPass = 1;
    public boolean JOGLSpillAddBase = true;
    public boolean JOGLSpillUnfactordAddBase = true;
    public float JOGL_speedMaxReduce = 0.5f;
    public float JOGLDotDwellDivisor = 40f;
    public boolean JOGLOverlayAdjustment = true;
    public float JOGLOverlayAlphaThreshold = 0.7f;
    public float JOGLOverlayAlphaAdjustmentFactor = 0.3f;
    public float JOGLOverlayBrightnessAlphaAdjustmentFactor = 0.4f;
    public boolean JOGLAutoDisplay = false;
    public boolean JOGLUseLinearSampling = true;
    public int JOGLMIP_RESOLUTION = 0;
    public float overflowIntensityDivider = 30000f;

    public boolean JOGLScreenAdjustment = true;
    public float JOGLScreenBrightnessAdjustmentFactor = 0.45f;
    
    public boolean JOGLScreen = true;
    public boolean JOGLHolders = false;
    public boolean JOGLFrame = false;
    public boolean JOGLCartridge = false;
    public boolean JOGLJoytsickpanel = false;
    public boolean JOGLCablePort1 = false;
    public boolean JOGLCablePort2 = false;

    public boolean keepAspectRatio = true;
    public String fullscreenResolution = "800x600";
    
    // DISSI
    public boolean assumeVectrex = true;
    public boolean createUnkownLabels = true;
    public boolean lstFirst = true;
    public boolean pleaseforceDissiIconizeOnRun = false; // !(/&%"/(&!%(/!&%!(/&%(/&"%"
    public boolean romAndPcBreakpoints = false;
    public boolean debugingCore = true;
    
    public boolean motdActive = true;
    // VEDI
    public boolean invokeEmulatorAfterAssembly = true;
    public boolean scanMacros = true;
    public boolean scanVars = true;
    public boolean scanForVectorLists = false;
    public boolean autoEjectV4EonCompile = true;
    public String v4eVolumeName = "";
    public int tab_width = 4;
    
    public int TAB_EQU = 30;
    public int TAB_EQU_VALUE = 40;
    public int TAB_MNEMONIC = 20;
    public int TAB_OP = 30;
    public int TAB_COMMENT = 58;


    
    
    public int deepSyntaxCheckTiming = 10000; // in ms
    public boolean deepSyntaxCheck = true;

    public int deepSyntaxCheckThreshold = 100000; // in ms
    public boolean deepSyntaxCheckThresholdActive = true;
    
    // vecci    
    public  Color VECCI_BACKGROUND_COLOR = Color.BLACK;
    public  Color VECCI_CROSS_COLOR = Color.ORANGE;
    public  Color VECCI_CROSS_DRAG_COLOR = Color.GREEN;
    public  Color VECCI_GRID_COLOR = new Color(50,50,50,128);
    public  Color VECCI_FRAME_COLOR = new Color(0,255,255,255);
    public  Color VECCI_VECTOR_FOREGROUND_COLOR = new Color(255,255,255,255); // not used, vectors have "own" color
    public  Color VECCI_VECTOR_BACKGROUND_COLOR = new Color(50,50,50,128);
    public  Color VECCI_VECTOR_ENDPOINT_COLOR = Color.red;
    public  Color VECCI_VECTOR_HIGHLIGHT_COLOR = new Color(255,50,255,255);
    public  Color VECCI_VECTOR_SELECTED_COLOR = new Color(50,50,255,255);
    public  Color VECCI_VECTOR_RELATIVE_COLOR = new Color(255,0,255,255);
    public  Color VECCI_VECTOR_DRAG_COLOR = new Color(255,255,0,255);
    public  Color VECCI_POINT_HIGHLIGHT_COLOR = new Color(255,50,255,255);
    public  Color VECCI_POINT_SELECTED_COLOR = new Color(50,50,255,255);
    public  Color VECCI_POS_COLOR = new Color(200,255,200,255);
    public  Color VECCI_POINT_JOINED_COLOR = new Color(150,50,255,255);
    public  Color VECCI_MOVE_COLOR = new Color(50,50,155,255);
    public  Color VECCI_DRAG_AREA_COLOR = new Color(0,200,0,50);
    public  Color VECCI_X_AXIS_COLOR = Color.BLUE;
    public  Color VECCI_Y_AXIS_COLOR = Color.GREEN;
    public  Color VECCI_Z_AXIS_COLOR = Color.MAGENTA;
    KeySupport keySupport = new KeySupport();
    StyleSupport styleSupport = new StyleSupport();
    public String themeFile = "";
    

    public Color valueChanged = Color.red;
    public Color valueNotChanged = Color.black;
    public Color tableOtherBank = new Color(200,255,255);
    public Color tableBIOS = new Color(200,200,200);
    public Color tableAddress = new Color(200,255,200,255);
    public Color psgChannelA = new Color(204,204,255);
    public Color psgChannelB = new Color(255,204,255);
    public Color psgChannelC = new Color(255,204,204);
    public Color psgChannelNoise =new Color(204,204,204);
    public Color ymCurrentLineBack = new Color(200,200,255);
    public Color linkColor = Color.blue;
    public Color htmltext = Color.black;
    
    public Color IOInput = new Color(0,203,255);
    public Color IOOutput  = new Color(215,255,188);
    public Color dataSelection = new Color(200,200,255);
    
    
    
    
/////////////

/////// Static 2
   public Color cLinesFore = new Color(250,250,80);
   public Color cLinesBack  = new Color(100,100,255);
   public Color cLsinesBack  = new Color(100,100,255);

   public boolean isFaultyVIA = false;
   public int SHORT_TAB_OP = 1;

   public boolean invokeVecMultiAfterAssembly = false;
    public String vecMultiPortDescriptor = SerialPort.getCommPorts().length == 0 ? null : SerialPort.getCommPorts()[0].getSystemPortName();
/////////////
    
    
    
    private static VideConfig theOneConfig = new VideConfig();
    public static String loadedConfig="";
    
    
    //// cli only
    public transient boolean doExitAfterVecxi=false;
    public transient boolean startInFullScreenMode = false;
    public transient boolean startInFullPanelMode = false;
    public transient CartridgeProperties cartridgeToStart = null;
    public transient String devicePort0 = null;
    public transient String devicePort1 = null;
    
    void resetCLIOnly()
    {
        doExitAfterVecxi = false;
        startInFullScreenMode = false;
        startInFullPanelMode = false;
        cartridgeToStart = null;
        devicePort0 = null;
        devicePort1 = null;
    }
    
    
    public static VideConfig getConfig()
    {
        return theOneConfig;
    }
    private VideConfig()
    {
        String name = "Default.vsv";
        try
        {
            String loadfilename2 = de.malban.util.UtilityString.replace(name, "vsv", "vs2");
            String completeName = Global.mainPathPrefix+"serialize"+File.separator+loadfilename2;
            if (!(new File(completeName).exists())) 
                name = "default.vsv";
        }
        catch (Throwable e) {} // for gui builder
        
        load(name);
    }
    public boolean saveControllerConfig()
    {
        try
        {
            if (controllerConfigs == null) controllerConfigs = new ArrayList<ControllerConfig>();

            CSAMainFrame.serialize(controllerConfigs ,Global.mainPathPrefix+"serialize"+File.separator+"controllerConfig.ser");
        }
        catch (Throwable e)
        {
            log.addLog("Could not save controller configuration!", WARN);
            return false;
        }        
        return true;
    }

    // filename + path
    public boolean save(String filename)
    {
        saveControllerConfig();
        try
        {
            boolean success = true;
            keySupport = new KeySupport();
            styleSupport = new StyleSupport();
            loadedConfig = filename;
                       
            ConfigStatic1 saveStatic1 = new ConfigStatic1();
            copyFromConfigToStatic(this, saveStatic1);
            filename = de.malban.util.UtilityString.replace(loadedConfig, "vsv", "vs1");
            success = success & CSAMainFrame.serialize(saveStatic1 ,filename);

            ConfigStatic2 saveStatic2 = new ConfigStatic2();
            copyFromConfigToStatic(this, saveStatic2);
            filename = de.malban.util.UtilityString.replace(loadedConfig, "vsv", "vs2");
            success = success & CSAMainFrame.serialize(saveStatic2 ,filename);

            return success;
        }
        catch (Throwable e)
        {
            log.addLog("Could not save configuration!", WARN);
        }
        return false;
    }

    class CartChanges
    {
        public boolean autoSync = true;
        public boolean ramAccessAllowed = false;
        public boolean romAndPcBreakpoints = false;
        public int ALG_MAX_X		= 43000;
        public int ALG_MAX_Y		= 45000;
        public float JOGLOverlayAlphaThreshold = 0.7f;
        public float JOGLDotDwellDivisor = 40f;

    }
    public transient CartChanges cartOverwriteSaves = new CartChanges();
    private void setCartOverwriteSaves()
    {
        cartOverwriteSaves.autoSync = autoSync;
        cartOverwriteSaves.ramAccessAllowed = ramAccessAllowed;
        cartOverwriteSaves.romAndPcBreakpoints = romAndPcBreakpoints;
        cartOverwriteSaves.ALG_MAX_X = ALG_MAX_X;
        cartOverwriteSaves.ALG_MAX_Y = ALG_MAX_Y;
        cartOverwriteSaves.JOGLOverlayAlphaThreshold = JOGLOverlayAlphaThreshold;
        cartOverwriteSaves.JOGLDotDwellDivisor = JOGLDotDwellDivisor;
    }
    public void resetCartChanges()
    {
        autoSync = cartOverwriteSaves.autoSync;
        ramAccessAllowed = cartOverwriteSaves.ramAccessAllowed;
        romAndPcBreakpoints = cartOverwriteSaves.romAndPcBreakpoints;
        ALG_MAX_X = cartOverwriteSaves.ALG_MAX_X;
        ALG_MAX_Y = cartOverwriteSaves.ALG_MAX_Y;
        JOGLOverlayAlphaThreshold = cartOverwriteSaves.JOGLOverlayAlphaThreshold;
        JOGLDotDwellDivisor = cartOverwriteSaves.JOGLDotDwellDivisor;
    }
    // filename only
    public boolean load(String filename)
    {
        try
        {
            if (controllerConfigs == null)
            {
                // if not loaded yet - load now
                ArrayList<ControllerConfig> cConfig =  (ArrayList<ControllerConfig>) CSAMainFrame.deserialize(Global.mainPathPrefix+"serialize"+File.separator+"controllerConfig.ser");
                if (cConfig != null) 
                {
                    controllerConfigs = cConfig;
                }
                else
                {
                    controllerConfigs = new ArrayList<ControllerConfig>();
                }
                initControllers();
            }   
            
            
            String loadfilename = de.malban.util.UtilityString.replace(filename, "vsv", "vs1");
            ConfigStatic1 loadStatic1 =  (ConfigStatic1) CSAMainFrame.deserialize(Global.mainPathPrefix+"serialize"+File.separator+loadfilename);
            if (loadStatic1 != null) 
            {
                copyFromStaticToConfig(loadStatic1, this);
            }

            if (styleSupport != null)
            {
// ensures no new values get lost, when saved is read
		Set entries = styleSupport.styles.entrySet();
		Iterator it = entries.iterator();
		while (it.hasNext())
		{
                    Map.Entry entry = (Map.Entry) it.next();
                    TokenStyles.MyStyle value = (TokenStyles.MyStyle) entry.getValue();
                    String name = (String) entry.getKey();
                    TokenStyles.styles.put(name, value);
                    TokenStyles.addToList(value);
		}

            }        

            String loadfilename2 = de.malban.util.UtilityString.replace(filename, "vsv", "vs2");
            ConfigStatic2 loadStatic2 =  (ConfigStatic2) CSAMainFrame.deserialize(Global.mainPathPrefix+"serialize"+File.separator+loadfilename2);
            if (loadStatic2 != null) 
            {
                copyFromStaticToConfig(loadStatic2, this);
            }
            
         
            
            
            this.resetCLIOnly();
            loadedConfig = filename;
            double v =  ((double) masterVolume)/(double)255.0;
            TinySound.setGlobalVolume(v);
            EventController.setPollResultion(jinputPolltime);
            
            Configuration.getConfiguration().setFullScrrenResString(fullscreenResolution);    

            
// comment this out for one !go"
// to add new keyboard configs to default!

            if (keySupport != null)
            {
                if ( keySupport.allMappings.size()>0)
                {
                    HotKey.allMappings = keySupport.allMappings;
                    HotKey.hotkeyList = keySupport.hotkeyList;
                }
            }

            de.malban.vide.ConfigJPanel.changeTab();

            
            VectorColors.VECCI_BACKGROUND_COLOR = this.VECCI_BACKGROUND_COLOR;
            VectorColors.VECCI_CROSS_COLOR = this.VECCI_CROSS_COLOR;
            VectorColors.VECCI_CROSS_DRAG_COLOR = this.VECCI_CROSS_DRAG_COLOR;
            VectorColors.VECCI_GRID_COLOR = this.VECCI_GRID_COLOR;
            VectorColors.VECCI_FRAME_COLOR = this.VECCI_FRAME_COLOR;
            VectorColors.VECCI_VECTOR_FOREGROUND_COLOR = this.VECCI_VECTOR_FOREGROUND_COLOR;
            VectorColors.VECCI_VECTOR_BACKGROUND_COLOR = this.VECCI_VECTOR_BACKGROUND_COLOR;
            VectorColors.VECCI_VECTOR_ENDPOINT_COLOR = this.VECCI_VECTOR_ENDPOINT_COLOR;
            VectorColors.VECCI_VECTOR_HIGHLIGHT_COLOR = this.VECCI_VECTOR_HIGHLIGHT_COLOR;
            VectorColors.VECCI_VECTOR_SELECTED_COLOR = this.VECCI_VECTOR_SELECTED_COLOR;
            VectorColors.VECCI_VECTOR_RELATIVE_COLOR = this.VECCI_VECTOR_RELATIVE_COLOR;
            VectorColors.VECCI_VECTOR_DRAG_COLOR = this.VECCI_VECTOR_DRAG_COLOR;
            VectorColors.VECCI_POINT_HIGHLIGHT_COLOR = this.VECCI_POINT_HIGHLIGHT_COLOR;
            VectorColors.VECCI_POINT_SELECTED_COLOR = this.VECCI_POINT_SELECTED_COLOR;
            VectorColors.VECCI_POS_COLOR = this.VECCI_POS_COLOR;
            VectorColors.VECCI_POINT_JOINED_COLOR = this.VECCI_POINT_JOINED_COLOR;
            VectorColors.VECCI_MOVE_COLOR = this.VECCI_MOVE_COLOR;
            
            VectorColors.VECCI_DRAG_AREA_COLOR = this.VECCI_DRAG_AREA_COLOR;
            VectorColors.VECCI_X_AXIS_COLOR = this.VECCI_X_AXIS_COLOR;
            VectorColors.VECCI_Y_AXIS_COLOR = this.VECCI_Y_AXIS_COLOR;
            VectorColors.VECCI_Z_AXIS_COLOR = this.VECCI_Z_AXIS_COLOR;
            
            boolean didThemeInit = false;
            if (themeFile!=null)
            {
                if (themeFile.length()!=0)
                {
                    String themeFileToLoad = de.malban.util.Utility.makeVideAbsolute(themeFile);
                    
                    
                    File file = new File(de.malban.util.UtilityFiles.convertSeperator(themeFileToLoad));
                    if (file.exists())
                    {
                        Global.linkColor = linkColor;
                        Global.textColor = htmltext;
                        // get rid of the stupd ever the same message that initializing was done successfully!
                        System.setOut(Global.devNull);
                        Theme.loadTheme(file);
                        System.setOut(Global.devOut);                    
                        Global.initLAF();
                        didThemeInit = true;
                    }
                }
            }
            if(!didThemeInit)
            {   
                Global.linkColor = linkColor;
                Global.textColor = htmltext;
                HTMLEditorKit kit = new HTMLEditorKit();
                StyleSheet styleSheet = kit.getStyleSheet();
                styleSheet.addRule("a {color:#"+Global.getHTMLColor(linkColor)+";}");
                styleSheet.addRule("body {color:#"+Global.getHTMLColor(htmltext)+";}");
            }
            
        }
        catch (Throwable e)
        {
            log.addLog("Could not load saved configuration!", WARN);
            return false;
        }
        setCartOverwriteSaves();
        return true;
    }
    
    // must copy all, 
    // otherwise all "children" would need to reset their config...
    
    private void copyFromStaticToConfig(ConfigStatic1 from, VideConfig to)
    {
        to.ALG_MAX_X = from.ALG_MAX_X;
        to.ALG_MAX_Y = from.ALG_MAX_Y;
        to.startFile = from.startFile;
        
        for (int i=0; i<from.delays.length; i++)
            to.delays[i] = from.delays[i];
        
//        System.arraycopy(from.delays, 0, to.delays, 0, from.delays.length);
        System.arraycopy(from.partialDelays, 0, to.partialDelays, 0, from.partialDelays.length);
//        System.arraycopy(from.delaysDisplay, 0, to.delaysDisplay, 0, from.delaysDisplay.length);
        to.keySupport = from.keySupport;
        to.styleSupport = from.styleSupport;
        to.themeFile = from.themeFile;
        to.rampOffFractionValue = from.rampOffFractionValue; // only implemented "partial" delay for ramp off
        to.rampOnFractionValue = from.rampOnFractionValue; // only implemented "partial" delay for ramp off
        to.blankOnDelay = from.blankOnDelay; // look at an M or a W, that would not be possible!
        to.blankOffDelay = from.blankOffDelay; // look at an M or a W, that would not be possible!
        to.reverseBlankLeak = from.reverseBlankLeak; // not used anymorew ! look at an M or a W, that would not be possible!
        to.drawBlanks = from.drawBlanks; // not implemented
        to.cycleExactEmulation = from.cycleExactEmulation;
        to.breakpointsActive = from.breakpointsActive;
        to.enableBankswitch = from.enableBankswitch;
        to.codeScanActive = from.codeScanActive;
        to.ringbufferActive = from.ringbufferActive;
        to.usedSystemRom=from.usedSystemRom;
        to.zeroRetainX=from.zeroRetainX;
        to.zeroRetainY=from.zeroRetainY;
        to.zero_divider=from.zero_divider;
        to.rotate=from.rotate;
        to.ramAccessAllowed=from.ramAccessAllowed;
        to.singestepBuffer=from.singestepBuffer;
        to.frameBuffer=from.frameBuffer;
        
        to.useLibAYEmu=from.useLibAYEmu;
        to.useLibAYEmuTable=from.useLibAYEmuTable;
        to.doProfile=from.doProfile;
        to.maxSplineSize=from.maxSplineSize;
        to.debugingCore=from.debugingCore;

        to.motdActive=from.motdActive;
        
        
        to.romAndPcBreakpoints = from.romAndPcBreakpoints; // resolution 0.01
        to.drift_x = from.drift_x; // resolution 0.01
        to.drift_y = from.drift_y; // resolution 0.01
        to.useRayGun = from.useRayGun;
        to.autoSync = from.autoSync;
        to.generation = from.generation;
        to.efficiencyEnabled = from.efficiencyEnabled;
        to.efficiencyThresholdX = from.efficiencyThresholdX;
        to.efficiencyThresholdY = from.efficiencyThresholdY;
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
        to.viaShift9BugEnabled = from.viaShift9BugEnabled;

        /// ASSI CONFIG
        to.expandBranches = from.expandBranches;
        to.supportUnusedSymbols=from.supportUnusedSymbols;
        to.enable8bitExtendedToDirect = from.enable8bitExtendedToDirect;
        to.excludeJumpsToDirect = from.excludeJumpsToDirect;
        to.beLaxWithHashTagAndImmediate = from.beLaxWithHashTagAndImmediate;
        to.treatUndefinedAsZero = from.treatUndefinedAsZero;
        to.includeRelativeToParent = from.includeRelativeToParent;
        to.opt = from.opt;
        to.warnOnDoubleDefine = from.warnOnDoubleDefine;
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
        to.emulateBorders = from.emulateBorders;
        
        
        // DISSI
        to.assumeVectrex = from.assumeVectrex;
        to.createUnkownLabels = from.createUnkownLabels;
        to.lstFirst = from.lstFirst;
        to.pleaseforceDissiIconizeOnRun = from.pleaseforceDissiIconizeOnRun;
        to.v4eVolumeName = from.v4eVolumeName;
        
        // VEDI
        to.invokeEmulatorAfterAssembly = from.invokeEmulatorAfterAssembly;
        to.scanMacros = from.scanMacros;
        to.scanVars = from.scanVars;
        to.scanForVectorLists = from.scanForVectorLists;
        to.autoEjectV4EonCompile = from.autoEjectV4EonCompile;

        to.deepSyntaxCheckTiming = from.deepSyntaxCheckTiming;
        to.deepSyntaxCheck = from.deepSyntaxCheck;
        to.deepSyntaxCheckThreshold = from.deepSyntaxCheckThreshold;
        to.deepSyntaxCheckThresholdActive = from.deepSyntaxCheckThresholdActive;
        to.tab_width = from.tab_width;

        
        to.loadStarterImages = from.loadStarterImages;
        to.tryJOGL = from.tryJOGL;
        to.JOGLMSAA = from.JOGLMSAA;
        to.JOGLmultiSample = from.JOGLmultiSample;
        to.JOGLuseGlowShader = from.JOGLuseGlowShader;
        to.JOGLadditiveBlur = from.JOGLadditiveBlur;
        to.JOGLblurPass = from.JOGLblurPass;
        to.JOGL_SIGMA = from.JOGL_SIGMA;
        to.JOGL_GAUSS_RADIUS = from.JOGL_GAUSS_RADIUS;
        to.JOGLaddBase = from.JOGLaddBase;
        to.JOGLGlowThreshold = from.JOGLGlowThreshold;

        to.JOGLuseSpillShader = from.JOGLuseSpillShader;
        to.JOGLSpillPass = from.JOGLSpillPass;

        to.JOGLSpillAddBase = from.JOGLSpillAddBase;
        to.JOGLInitialSpillDivisor = from.JOGLInitialSpillDivisor;
        to.JOGLSpillThreshold = from.JOGLSpillThreshold;
        to.JOGLFinalSpillMultiplyer = from.JOGLFinalSpillMultiplyer;
        to.JOGLSpillUnfactordAddBase = from.JOGLSpillUnfactordAddBase;
        to.JOGL_speedMaxReduce = from.JOGL_speedMaxReduce;
        to.JOGLDotDwellDivisor = from.JOGLDotDwellDivisor;
        
        to.JOGLOverlayAdjustment = from.JOGLOverlayAdjustment;
        to.JOGLOverlayAlphaThreshold = from.JOGLOverlayAlphaThreshold;
        to.JOGLOverlayAlphaAdjustmentFactor = from.JOGLOverlayAlphaAdjustmentFactor;
        to.JOGLOverlayBrightnessAlphaAdjustmentFactor = from.JOGLOverlayBrightnessAlphaAdjustmentFactor;
        to.JOGLAutoDisplay = from.JOGLAutoDisplay;
        to.JOGLUseLinearSampling = from.JOGLUseLinearSampling;
        to.JOGLMIP_RESOLUTION = from.JOGLMIP_RESOLUTION;
        
        to.JOGLScreenBrightnessAdjustmentFactor = from.JOGLScreenBrightnessAdjustmentFactor;
        to.JOGLScreenAdjustment = from.JOGLScreenAdjustment;
        
        
        to.JOGLScreen = from.JOGLScreen;
        to.JOGLHolders = from.JOGLHolders;
        to.JOGLFrame = from.JOGLFrame;
        to.JOGLCartridge = from.JOGLCartridge;
        to.JOGLJoytsickpanel = from.JOGLJoytsickpanel;
        to.JOGLCablePort1 = from.JOGLCablePort1;
        to.JOGLCablePort2 = from.JOGLCablePort2;
        
        to.keepAspectRatio = from.keepAspectRatio;
        to.fullscreenResolution = from.fullscreenResolution;
        

        
        to.overflowIntensityDivider = from.overflowIntensityDivider;
        // vecci
        to.VECCI_BACKGROUND_COLOR = from.VECCI_BACKGROUND_COLOR;
        to.VECCI_CROSS_COLOR = from.VECCI_CROSS_COLOR;
        to.VECCI_CROSS_DRAG_COLOR = from.VECCI_CROSS_DRAG_COLOR;
        to.VECCI_GRID_COLOR = from.VECCI_GRID_COLOR;
        to.VECCI_FRAME_COLOR = from.VECCI_FRAME_COLOR;
        to.VECCI_VECTOR_FOREGROUND_COLOR = from.VECCI_VECTOR_FOREGROUND_COLOR;
        to.VECCI_VECTOR_BACKGROUND_COLOR = from.VECCI_VECTOR_BACKGROUND_COLOR;
        to.VECCI_VECTOR_ENDPOINT_COLOR = from.VECCI_VECTOR_ENDPOINT_COLOR;
        to.VECCI_VECTOR_HIGHLIGHT_COLOR = from.VECCI_VECTOR_HIGHLIGHT_COLOR;
        to.VECCI_VECTOR_SELECTED_COLOR = from.VECCI_VECTOR_SELECTED_COLOR;
        to.VECCI_VECTOR_RELATIVE_COLOR = from.VECCI_VECTOR_RELATIVE_COLOR;
        to.VECCI_VECTOR_DRAG_COLOR = from.VECCI_VECTOR_DRAG_COLOR;
        to.VECCI_POINT_HIGHLIGHT_COLOR = from.VECCI_POINT_HIGHLIGHT_COLOR;
        to.VECCI_POINT_SELECTED_COLOR = from.VECCI_POINT_SELECTED_COLOR;
        to.VECCI_POS_COLOR = from.VECCI_POS_COLOR;
        to.VECCI_POINT_JOINED_COLOR = from.VECCI_POINT_JOINED_COLOR;
        to.VECCI_MOVE_COLOR = from.VECCI_MOVE_COLOR;
        
        to.VECCI_DRAG_AREA_COLOR = from.VECCI_DRAG_AREA_COLOR;
        to.VECCI_X_AXIS_COLOR = from.VECCI_X_AXIS_COLOR;
        to.VECCI_Y_AXIS_COLOR = from.VECCI_Y_AXIS_COLOR;
        to.VECCI_Z_AXIS_COLOR = from.VECCI_Z_AXIS_COLOR;
        
        
        to.valueChanged = from.valueChanged;
        to.valueNotChanged = from.valueNotChanged;
        to.tableOtherBank = from.tableOtherBank;
        to.tableBIOS = from.tableBIOS;
        to.tableAddress = from.tableAddress;
        to.psgChannelA = from.psgChannelA;
        to.psgChannelB = from.psgChannelB;
        to.psgChannelC = from.psgChannelC;
        to.psgChannelNoise = from.psgChannelNoise;
        to.ymCurrentLineBack = from.ymCurrentLineBack;
        to.linkColor = from.linkColor;
        to.htmltext = from.htmltext;
        to.IOInput = from.IOInput;
        to.IOOutput = from.IOOutput;
        to.dataSelection = from.dataSelection;

        to.TAB_EQU = from.TAB_EQU;
        to.TAB_EQU_VALUE = from.TAB_EQU_VALUE;
        to.TAB_MNEMONIC = from.TAB_MNEMONIC;
        to.TAB_OP = from.TAB_OP;
        to.TAB_COMMENT = from.TAB_COMMENT;

    }
    private void copyFromConfigToStatic(VideConfig from, ConfigStatic1 to)
    {
        to.ALG_MAX_X = from.ALG_MAX_X;
        to.ALG_MAX_Y = from.ALG_MAX_Y;
        to.startFile = from.startFile;
        
        for (int i=0; i<from.delays.length-1; i++)
            to.delays[i] = from.delays[i];
//        System.arraycopy(from.delays, 0, to.delays, 0, from.delays.length);
        System.arraycopy(from.partialDelays, 0, to.partialDelays, 0, from.partialDelays.length);
//      System.arraycopy(from.delaysDisplay, 0, to.delaysDisplay, 0, from.delaysDisplay.length);
        
        to.keySupport = from.keySupport;
        to.styleSupport = from.styleSupport;
        to.themeFile = from.themeFile;
        
        to.rampOffFractionValue = from.rampOffFractionValue; // only implemented "partial" delay for ramp off
        to.rampOnFractionValue = from.rampOnFractionValue; // only implemented "partial" delay for ramp off
        to.blankOnDelay = from.blankOnDelay; // look at an M or a W, that would not be possible!
        to.blankOffDelay = from.blankOffDelay; // look at an M or a W, that would not be possible!
        to.reverseBlankLeak = from.reverseBlankLeak; // not used anymorew ! look at an M or a W, that would not be possible!
        to.drawBlanks = from.drawBlanks; // not implemented
        to.cycleExactEmulation = from.cycleExactEmulation;
        to.breakpointsActive = from.breakpointsActive;
        to.enableBankswitch = from.enableBankswitch;
        to.codeScanActive = from.codeScanActive;
        to.ringbufferActive = from.ringbufferActive;
        to.usedSystemRom=from.usedSystemRom;
        to.zero_divider=from.zero_divider;
        to.zeroRetainX=from.zeroRetainX;
        to.zeroRetainY=from.zeroRetainY;
        to.rotate=from.rotate;
        to.ramAccessAllowed=from.ramAccessAllowed;
        to.singestepBuffer=from.singestepBuffer;
        to.frameBuffer=from.frameBuffer;
        
        to.useLibAYEmu=from.useLibAYEmu;
        to.useLibAYEmuTable=from.useLibAYEmuTable;
        to.doProfile=from.doProfile;
        to.maxSplineSize=from.maxSplineSize;
        to.debugingCore=from.debugingCore;

        to.motdActive=from.motdActive;
        
        
        to.romAndPcBreakpoints = from.romAndPcBreakpoints; // resolution 0.01
        to.drift_x = from.drift_x; // resolution 0.01
        to.drift_y = from.drift_y; // resolution 0.01
        to.useRayGun = from.useRayGun;
        to.autoSync = from.autoSync;
        to.generation = from.generation;
        to.efficiencyEnabled = from.efficiencyEnabled;
        to.efficiencyThresholdX = from.efficiencyThresholdX;
        to.efficiencyThresholdY = from.efficiencyThresholdY;
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
        to.viaShift9BugEnabled = from.viaShift9BugEnabled;

        /// ASSI CONFIG
        to.expandBranches = from.expandBranches;
        to.supportUnusedSymbols=from.supportUnusedSymbols;
        to.enable8bitExtendedToDirect = from.enable8bitExtendedToDirect;
        to.excludeJumpsToDirect = from.excludeJumpsToDirect;
        to.beLaxWithHashTagAndImmediate = from.beLaxWithHashTagAndImmediate;
        to.treatUndefinedAsZero = from.treatUndefinedAsZero;
        to.includeRelativeToParent = from.includeRelativeToParent;
        to.opt = from.opt;
        to.warnOnDoubleDefine = from.warnOnDoubleDefine;
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
        to.emulateBorders = from.emulateBorders;
        
        
        // DISSI
        to.assumeVectrex = from.assumeVectrex;
        to.createUnkownLabels = from.createUnkownLabels;
        to.lstFirst = from.lstFirst;
        to.pleaseforceDissiIconizeOnRun = from.pleaseforceDissiIconizeOnRun;
        to.v4eVolumeName = from.v4eVolumeName;
        
        // VEDI
        to.invokeEmulatorAfterAssembly = from.invokeEmulatorAfterAssembly;
        to.scanMacros = from.scanMacros;
        to.scanVars = from.scanVars;
        to.scanForVectorLists = from.scanForVectorLists;
        to.autoEjectV4EonCompile = from.autoEjectV4EonCompile;

        to.deepSyntaxCheckTiming = from.deepSyntaxCheckTiming;
        to.deepSyntaxCheck = from.deepSyntaxCheck;
        to.deepSyntaxCheckThreshold = from.deepSyntaxCheckThreshold;
        to.deepSyntaxCheckThresholdActive = from.deepSyntaxCheckThresholdActive;
        to.tab_width = from.tab_width;

        
        to.loadStarterImages = from.loadStarterImages;
        to.tryJOGL = from.tryJOGL;
        to.JOGLMSAA = from.JOGLMSAA;
        to.JOGLmultiSample = from.JOGLmultiSample;
        to.JOGLuseGlowShader = from.JOGLuseGlowShader;
        to.JOGLadditiveBlur = from.JOGLadditiveBlur;
        to.JOGLblurPass = from.JOGLblurPass;
        to.JOGL_SIGMA = from.JOGL_SIGMA;
        to.JOGL_GAUSS_RADIUS = from.JOGL_GAUSS_RADIUS;
        to.JOGLaddBase = from.JOGLaddBase;
        to.JOGLGlowThreshold = from.JOGLGlowThreshold;

        to.JOGLuseSpillShader = from.JOGLuseSpillShader;
        to.JOGLSpillPass = from.JOGLSpillPass;

        to.JOGLSpillAddBase = from.JOGLSpillAddBase;
        to.JOGLInitialSpillDivisor = from.JOGLInitialSpillDivisor;
        to.JOGLSpillThreshold = from.JOGLSpillThreshold;
        to.JOGLFinalSpillMultiplyer = from.JOGLFinalSpillMultiplyer;
        to.JOGLSpillUnfactordAddBase = from.JOGLSpillUnfactordAddBase;
        to.JOGL_speedMaxReduce = from.JOGL_speedMaxReduce;
        to.JOGLDotDwellDivisor = from.JOGLDotDwellDivisor;
        
        to.JOGLOverlayAdjustment = from.JOGLOverlayAdjustment;
        to.JOGLOverlayAlphaThreshold = from.JOGLOverlayAlphaThreshold;
        to.JOGLOverlayAlphaAdjustmentFactor = from.JOGLOverlayAlphaAdjustmentFactor;
        to.JOGLOverlayBrightnessAlphaAdjustmentFactor = from.JOGLOverlayBrightnessAlphaAdjustmentFactor;
        to.JOGLAutoDisplay = from.JOGLAutoDisplay;
        to.JOGLUseLinearSampling = from.JOGLUseLinearSampling;
        to.JOGLMIP_RESOLUTION = from.JOGLMIP_RESOLUTION;
        
        to.JOGLScreenBrightnessAdjustmentFactor = from.JOGLScreenBrightnessAdjustmentFactor;
        to.JOGLScreenAdjustment = from.JOGLScreenAdjustment;
        
        
        to.JOGLScreen = from.JOGLScreen;
        to.JOGLHolders = from.JOGLHolders;
        to.JOGLFrame = from.JOGLFrame;
        to.JOGLCartridge = from.JOGLCartridge;
        to.JOGLJoytsickpanel = from.JOGLJoytsickpanel;
        to.JOGLCablePort1 = from.JOGLCablePort1;
        to.JOGLCablePort2 = from.JOGLCablePort2;
        
        to.keepAspectRatio = from.keepAspectRatio;
        to.fullscreenResolution = from.fullscreenResolution;
        

        
        to.overflowIntensityDivider = from.overflowIntensityDivider;
        // vecci
        to.VECCI_BACKGROUND_COLOR = from.VECCI_BACKGROUND_COLOR;
        to.VECCI_CROSS_COLOR = from.VECCI_CROSS_COLOR;
        to.VECCI_CROSS_DRAG_COLOR = from.VECCI_CROSS_DRAG_COLOR;
        to.VECCI_GRID_COLOR = from.VECCI_GRID_COLOR;
        to.VECCI_FRAME_COLOR = from.VECCI_FRAME_COLOR;
        to.VECCI_VECTOR_FOREGROUND_COLOR = from.VECCI_VECTOR_FOREGROUND_COLOR;
        to.VECCI_VECTOR_BACKGROUND_COLOR = from.VECCI_VECTOR_BACKGROUND_COLOR;
        to.VECCI_VECTOR_ENDPOINT_COLOR = from.VECCI_VECTOR_ENDPOINT_COLOR;
        to.VECCI_VECTOR_HIGHLIGHT_COLOR = from.VECCI_VECTOR_HIGHLIGHT_COLOR;
        to.VECCI_VECTOR_SELECTED_COLOR = from.VECCI_VECTOR_SELECTED_COLOR;
        to.VECCI_VECTOR_RELATIVE_COLOR = from.VECCI_VECTOR_RELATIVE_COLOR;
        to.VECCI_VECTOR_DRAG_COLOR = from.VECCI_VECTOR_DRAG_COLOR;
        to.VECCI_POINT_HIGHLIGHT_COLOR = from.VECCI_POINT_HIGHLIGHT_COLOR;
        to.VECCI_POINT_SELECTED_COLOR = from.VECCI_POINT_SELECTED_COLOR;
        to.VECCI_POS_COLOR = from.VECCI_POS_COLOR;
        to.VECCI_POINT_JOINED_COLOR = from.VECCI_POINT_JOINED_COLOR;
        to.VECCI_MOVE_COLOR = from.VECCI_MOVE_COLOR;
        
        to.VECCI_DRAG_AREA_COLOR = from.VECCI_DRAG_AREA_COLOR;
        to.VECCI_X_AXIS_COLOR = from.VECCI_X_AXIS_COLOR;
        to.VECCI_Y_AXIS_COLOR = from.VECCI_Y_AXIS_COLOR;
        to.VECCI_Z_AXIS_COLOR = from.VECCI_Z_AXIS_COLOR;

        to.valueChanged = from.valueChanged;
        to.valueNotChanged = from.valueNotChanged;
        to.tableOtherBank = from.tableOtherBank;
        to.tableBIOS = from.tableBIOS;
        to.tableAddress = from.tableAddress;
        to.psgChannelA = from.psgChannelA;
        to.psgChannelB = from.psgChannelB;
        to.psgChannelC = from.psgChannelC;
        to.psgChannelNoise = from.psgChannelNoise;
        to.ymCurrentLineBack = from.ymCurrentLineBack;
        to.linkColor = from.linkColor;
        to.htmltext = from.htmltext;
        to.IOInput = from.IOInput;
        to.IOOutput = from.IOOutput;
        to.dataSelection = from.dataSelection;
        
        
        to.TAB_EQU = from.TAB_EQU;
        to.TAB_EQU_VALUE = from.TAB_EQU_VALUE;
        to.TAB_MNEMONIC = from.TAB_MNEMONIC;
        to.TAB_OP = from.TAB_OP;
        to.TAB_COMMENT = from.TAB_COMMENT;
    }
    private void copyFromStaticToConfig(ConfigStatic2 from, VideConfig to)
    {
        to.cLinesBack = from.cLinesBack;
        to.cLinesFore = from.cLinesFore;
        to.cLsinesBack = from.cLsinesBack;
        to.displayModeWriting = from.displayModeWriting;
        to.vectrexColorMode = from.vectrexColorMode;
        to.isFaultyVIA = from.isFaultyVIA;
        to.SHORT_TAB_OP = from.SHORT_TAB_OP;
        to.delays[TIMER_T2] = from.t2Delay;

        to.invokeVecMultiAfterAssembly = from.invokeVecMultiAfterAssembly;
        to.vecMultiPortDescriptor = from.vecMultiPortDescriptor;
    }
    private void copyFromConfigToStatic(VideConfig from, ConfigStatic2 to)
    {
        to.cLinesBack = from.cLinesBack;
        to.cLinesFore = from.cLinesFore;
        to.cLsinesBack = from.cLsinesBack;
        to.displayModeWriting = from.displayModeWriting;
        to.vectrexColorMode = from.vectrexColorMode;
        to.isFaultyVIA = from.isFaultyVIA;
        to.SHORT_TAB_OP = from.SHORT_TAB_OP;
        to.t2Delay = from.delays[TIMER_T2];

        to.invokeVecMultiAfterAssembly = from.invokeVecMultiAfterAssembly;
        to.vecMultiPortDescriptor = from.vecMultiPortDescriptor;
    }
    
    public static File[] getConfigs()
    {
        File dir = new File(Global.mainPathPrefix+"serialize");
        File[] files = dir.listFiles(new FilenameFilter() 
        {
                @Override
                public boolean accept(File dir, String name) 
                {
                    return name.toLowerCase().endsWith(".vs1");
                }
            });     
        File[] nFiles = new File[files.length];
        int i=0;
        for (File f: files)
        {
            nFiles[i++] = new File(de.malban.util.UtilityString.replace(f.getName(), "vs1", "vsv"));
            
        }
        
        return nFiles;
    }
    
    // controllers must be:
    // a) configured
    // b) available thru JInput
    private void initControllers()
    {
        ArrayList<Controller> controllers = SystemController.getCurrentControllers();
        for (ControllerConfig cConfig : controllerConfigs)
        {
            String configId = cConfig.JInputId;
            for (Controller controller: controllers)
            {
                if (controller.getName().equals(configId))
                {
                    cConfig.isWorking = true;
                    break;
                }
            }
        }
    }
    
    public static ArrayList<ControllerConfig> getAvailableControllerConfigs()
    {
        ArrayList<ControllerConfig> cConfigs = new ArrayList<ControllerConfig>();
        for (ControllerConfig cConfig : controllerConfigs)
        {
            if (cConfig.isWorking)
                cConfigs.add(cConfig);
        }
        return cConfigs;
    }
    
    public Color getValueNotChangedColor()
    {
        return valueNotChanged;
    }
    public Color getValueChangedColor()
    {
        return valueChanged;
    }
    
    
    public Color getTableOtherBankColor()
    {
        return tableOtherBank;
    }
    public Color getTableBIOSColor()
    {
        return tableBIOS;
    }
    public Color getTableAdressColor()
    {
        return tableAddress;
    }
    public Color getPSGChannelAColor()
    {
        return psgChannelA;
    }
    public Color getPSGChannelBColor()
    {
        return psgChannelB;
    }
    public Color getPSGChannelCColor()
    {
        return psgChannelC;
    }
    public Color getPSGChannelNoiseColor()
    {
        return psgChannelNoise;
    }
    public Color getTableYMBackColor()
    {
        return ymCurrentLineBack;
    }
    public Color getTextLinkColor()
    {
        return linkColor;
    }
    public Color getHTMLTextColor()
    {
        return htmltext;
    }
}
