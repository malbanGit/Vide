/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide;

import de.malban.Global;
import de.malban.config.Configuration;
import static de.malban.vide.ConfigJPanel.buildStringForMode;
import de.malban.vide.vecx.cartridge.CartridgeProperties;
import de.malban.vide.vecx.cartridge.CartridgePropertiesPool;
import de.malban.vide.vedi.VediPanel;
import java.awt.DisplayMode;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

/**
 *
 * @author 
 */
public class CLI {
    /*
    - all command start with "-"
    - binary commands have a "+" or "-" added
    - all other commands get there value after a DIRECTLY following "="
    - arguments not starting with "-" will simply be ignored!
    - if a command appears multiple times, the last one wins
    */
    public static final ArrayList<CLICommand> activeCommands = new ArrayList<CLICommand>();
    public static final HashMap<String, CLICommand> activeCommandsMap = new HashMap<String, CLICommand>();
    private static final HashMap<String, CLICommand> knownCommandShort= new HashMap<String, CLICommand>();
    private static final HashMap<String, CLICommand> knownCommandLong= new HashMap<String, CLICommand>();
    
    public static final ArrayList<CLICommand> knownCommands = new ArrayList<CLICommand>();
    
    public static class CLICommand
    {
        public final String longCommand;
        public final String shortCommand;
        public final String help;
        public String value="";
        CLICommand(String l, String s, String h)
        {
            longCommand = l; 
            shortCommand = s; 
            help = h; 
        }
        public boolean isEnabled()
        {
            return value.equals("+");
        }
        public String getValue()
        {
            return value;
        }
        public int getIntValue()
        {
            return de.malban.util.UtilityString.Int0(value);
        }
        public String toString()
        {
            return longCommand+" "+ shortCommand+" "+help;
        }
    }
    
    private static final CLI cli= new CLI();
    public static CLI getCLI()
    {
        return cli;
    }
    private CLI()
    {
        // done
        addKnownCommand("-help            ","-h","       help");
        addKnownCommand("-configuration   ","-co","(=)   name of the configuration file to load (e.g. developer.vsv)");
        addKnownCommand("-jogl            ","-jg","(+/-) start with jogl graphics enabled");
        addKnownCommand("-oldJava         ","-oj","(+/-) start with java graphics enabled");
        addKnownCommand("-keepAspectRatio ","-ar","(+/-) keep aspect ratio when size of vecxi changes");
        addKnownCommand("-exitAfterGame   ","-ex","(+/-) shuts down vide after exiting vecxi");
        addKnownCommand("-fullpanel       ","-fp","(+/-) starts vecxi in fullpanel (only if vecxi runs)");
        addKnownCommand("-fullscreen      ","-fs","(+/-) starts vecxi in fullscreen (only if vecxi runs)");
        addKnownCommand("-enableOverlay   ","-eo","(+/-) whether to load an overlay, if available");
        addKnownCommand("-enableScreen    ","-es","(+/-) whether to enable the 'screen' drawing");
        addKnownCommand("-port0Device     ","-p0","(=)   name of the configured input device (names as they appear in vecxi combobox)");
        addKnownCommand("-port1Device     ","-p1","(=)   name of the configured input device (names as they appear in vecxi combobox)");
        addKnownCommand("-rotation        ","-ro","(=)   rotation (0, 90, 180, 270)");
        addKnownCommand("-binary          ","-bi","(=)   loads a binary file and starts vecxi");
        addKnownCommand("-gameCartridge   ","-gc","(=)   loads a cartridge definition and starts vecxi (name of the cart)");
        addKnownCommand("-resolution      ","-rs","(=)   resolution of fullscreen, format like '800x600'");
        
        addKnownCommand("-hotkeys         ","-hk","(+/-) enable/disable use of hotkeys (for debugging purposes only, default: enable)");
        addKnownCommand("-syntaxhighlite  ","-sy","(+/-) enable/disable use syntaxhighlite (for debugging purposes only, default: enable)");
        addKnownCommand("-undo            ","-un","(+/-) enable/disable use undo in editor (for debugging purposes only, default: enable)");
        addKnownCommand("-versionTest     ","-vt","(+/-) do test for java version (default: enable)");
     
        
    }
    private static void addKnownCommand(String l, String s, String h)
    {
        CLICommand c = new CLICommand(l, s, h);
        knownCommandShort.put(s.trim(), c);
        knownCommandLong.put(l.trim(), c);
        knownCommands.add(c);
    }
    
    public boolean parseArguments(String[] args)
    {
        String v;
        String c;
        int i = 0;
        for (String a:args)
        {
//System.out.println("arg["+(i++)+"]: "+a);
            a = a.trim();
            if (!a.startsWith("-")) continue;
            if (a.length()<2) continue;
            if (a.toLowerCase().substring(1).equals("h")) return doHelp();
            if ((a.endsWith("-")) || (a.endsWith("+")))
            {
                v = a.substring(a.length()-1,a.length()).trim();
                c = a.substring(0 ,a.length()-1).trim();
            }
            else
            {
                int p = a.indexOf("=");
                if (p==-1) continue;
                if (p==a.length()-1) continue;
                
                v = a.substring(p+1 ,a.length()).trim();
                c = a.substring(0,p).trim();
            }
            c = c.toLowerCase().trim();
            
//System.out.println("c="+c);
//System.out.println("v="+v);
            CLICommand com = knownCommandShort.get(c);
            if (com == null) com= knownCommandLong.get(c);
            if (com == null) continue;
//System.out.println("found...");
            com.value=v;
            activeCommands.add(com);
            activeCommandsMap.put(com.shortCommand, com);
        }
        return false;
    }

    public void injectCLIConfig()
    {
        // ensure config is loaded, before changing with CLI values
        VideConfig config = VideConfig.getConfig();
        
        // and overwrite values with CLI commands
        
        if (CLI.activeCommandsMap.get("-co") != null) 
        {
            String configFile = CLI.activeCommandsMap.get("-co").getValue();
            config.load(configFile);
        }

        if (CLI.activeCommandsMap.get("-hk") != null) VideConfig.hotKeysEnabled = CLI.activeCommandsMap.get("-hk").isEnabled();
        if (CLI.activeCommandsMap.get("-sy") != null) VideConfig.syntaxHighliteEnabled = CLI.activeCommandsMap.get("-sy").isEnabled();
        if (CLI.activeCommandsMap.get("-un") != null) VideConfig.editorUndoEnabled = CLI.activeCommandsMap.get("-un").isEnabled();
        if (CLI.activeCommandsMap.get("-vt") != null) Global.doTestJava = CLI.activeCommandsMap.get("-vt").isEnabled();
        
        if (CLI.activeCommandsMap.get("-jg") != null) config.tryJOGL = CLI.activeCommandsMap.get("-jg").isEnabled();
        if (CLI.activeCommandsMap.get("-oj") != null) config.tryJOGL = !CLI.activeCommandsMap.get("-oj").isEnabled();
        if (CLI.activeCommandsMap.get("-ar") != null) config.keepAspectRatio = CLI.activeCommandsMap.get("-ar").isEnabled();
        if (CLI.activeCommandsMap.get("-ex") != null) config.doExitAfterVecxi = CLI.activeCommandsMap.get("-ex").isEnabled();
        if (CLI.activeCommandsMap.get("-fp") != null) config.startInFullPanelMode = CLI.activeCommandsMap.get("-fp").isEnabled();
        if (CLI.activeCommandsMap.get("-fs") != null) config.startInFullScreenMode = CLI.activeCommandsMap.get("-fs").isEnabled();
        if (CLI.activeCommandsMap.get("-eo") != null) config.overlayEnabled = CLI.activeCommandsMap.get("-eo").isEnabled();
        if (CLI.activeCommandsMap.get("-es") != null) config.JOGLScreen = CLI.activeCommandsMap.get("-es").isEnabled();
        if (CLI.activeCommandsMap.get("-p0") != null) config.devicePort0 = CLI.activeCommandsMap.get("-p0").getValue();
        if (CLI.activeCommandsMap.get("-p1") != null) config.devicePort1 = CLI.activeCommandsMap.get("-p1").getValue();
        
        
        
        if (CLI.activeCommandsMap.get("-ro") != null) 
        {
            String ro = CLI.activeCommandsMap.get("-ro").getValue().trim();
            int roi = de.malban.util.UtilityString.Int0(ro);
            if ((roi == 0) || (roi == 90) || (roi == 180) || (roi == 270))
                config.rotate = roi;
        }
        if (CLI.activeCommandsMap.get("-bi") != null) 
        {
            String fn = de.malban.util.Utility.makeVideAbsolute(CLI.activeCommandsMap.get("-bi").getValue());
            fn = de.malban.util.Utility.makeVideAbsolute(fn);
            if (new File(fn).exists()) config.startFile = fn;
        }
        if (CLI.activeCommandsMap.get("-gc") != null) 
        {
            String cartName = CLI.activeCommandsMap.get("-gc").getValue();

            ArrayList<CartridgeProperties> allCartridges = new ArrayList<CartridgeProperties>();
            CartridgePropertiesPool mCartridgePropertiesPool = new CartridgePropertiesPool();
            Collection<CartridgeProperties> colC = mCartridgePropertiesPool.getMapForKlasse("Cartridge").values();
            Iterator<CartridgeProperties> iterC = colC.iterator();
            while (iterC.hasNext())
            {
                CartridgeProperties item = iterC.next();
                allCartridges.add(item);
            }
            for (CartridgeProperties cart :allCartridges)
            {
                if (cartName.equalsIgnoreCase(cart.getCartName()))
                {
                    config.cartridgeToStart = cart;
                    break;
                }
            }
        }
        if (CLI.activeCommandsMap.get("-rs") != null) 
        {
            String res = CLI.activeCommandsMap.get("-rs").getValue().toLowerCase();
            boolean resok = res.contains("x");
            String[] split = res.split("x");
            split = VediPanel.removeEmpty(split);
            if (split.length != 2) resok = false;
            int h = 0;
            int w = 0;
            if (resok)
            {
                w = de.malban.util.UtilityString.Int0(split[0]);
                h = de.malban.util.UtilityString.Int0(split[1]);
            }
            if ((h==0)|| (w==0)) resok = false;
            if (resok)
            {
                GraphicsEnvironment env = GraphicsEnvironment.getLocalGraphicsEnvironment();
                GraphicsDevice[] devices = env.getScreenDevices();
                DisplayMode[] modes = devices[0].getDisplayModes();
                
                for (int i = 0; i < modes.length; i++)
                {
                    DisplayMode displayMode = modes[i];
                    if ((displayMode.getWidth() == w) && (displayMode.getHeight() == h))
                    {
                        Configuration C = Configuration.getConfiguration();
                        String modeString = buildStringForMode(displayMode);
                        C.setFullScrrenResString(modeString);
                        config.fullscreenResolution = modeString;
                        break;
                    }
                }
            }
        }
    }
    private static boolean doHelp()
    {
        Set entries = knownCommandShort.entrySet();
        Iterator it = entries.iterator();
        System.out.println("List of all command line options. No defaults are given, since");
        System.out.println("vedi upon start reads the configuration file \"default\" - ");
        System.out.println("which can be set up by the user.");
        System.out.println("The values of the configuration file are overwritten by values");
        System.out.println("given via the command line.");
        System.out.println("The commands are 'excuted' in the here listed order, commands");
        System.out.println("further down the list, can negate previous commands!");
        System.out.println("If a command fails - it does so quietly, no error message ");
        System.out.println("'false parameter' or the like will be displayed!\n");
        for (CLICommand com:knownCommands) System.out.println(com);

        return true;
    }
    
    
    
}
