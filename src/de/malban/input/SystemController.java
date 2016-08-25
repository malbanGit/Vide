/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.input;

import de.malban.config.Configuration;
import static de.malban.gui.panels.LogPanel.WARN;
import java.io.File;
import java.lang.reflect.Constructor;
import java.security.AccessController;
import java.security.PrivilegedAction;
import java.util.ArrayList;
import net.java.games.input.Controller;
import net.java.games.input.ControllerEnvironment;

/**
 *
 * @author malban
 */
public class SystemController 
{
    public static final String OSNAME;
    public static final String NATIVES_PATH;

    private static ArrayList<Controller> foundControllers;
    private static Boolean jinputAvailable = null;
    static 
    {
        // http://www.java-gaming.org/topics/setup-natives-from-code/32484/view.html
        OSNAME = System.getProperty("os.name").toLowerCase();
        if (OSNAME.contains("win")) NATIVES_PATH = "lib/";
        else if(OSNAME.contains("mac"))NATIVES_PATH = "lib";
        else if(OSNAME.contains("lin"))NATIVES_PATH = "lib";
        else if(OSNAME.contains("sol"))NATIVES_PATH = "lib";
        else NATIVES_PATH = "lib";

        // see: http://stackoverflow.com/questions/17413690/java-jinput-rescan-reload-controllers
        /**
         * Fix windows 8 warnings by defining a working plugin
         */
        AccessController.doPrivileged(new PrivilegedAction<Object>() 
        {
            public Object run() {
                String os = System.getProperty("os.name", "").trim();
                if ((os.startsWith("Windows 8")) || (os.startsWith("Windows 1"))) {  // 8, 8.1 etc.

                    // disable default plugin lookup
                    System.setProperty("jinput.useDefaultPlugin", "false");

                    // set to same as windows 7 (tested for windows 8 and 8.1)
                    System.setProperty("net.java.games.input.plugins", "net.java.games.input.DirectAndRawInputEnvironmentPlugin");

                }
                return null;
            }
        });
        if (!OSNAME.contains("mac"))
        {
            // set native library path
            AccessController.doPrivileged(new PrivilegedAction() 
            {
                public Object run() 
                {
                    System.setProperty("net.java.games.input.librarypath", new File(NATIVES_PATH).getAbsolutePath());
                    return null;
                }
            });         

        }
        else
        {
            // set native library path
            AccessController.doPrivileged(new PrivilegedAction() 
            {
                public Object run() 
                {
                    System.setProperty("java.library.path", new File("lib").getAbsolutePath());
                    return null;
                }
            });         
        }
    }

    public static boolean isJInputAvailable()
    {
        if (jinputAvailable == null)
        {
             createDefaultEnvironment();
        }
        return jinputAvailable;
    }
    
    private static ControllerEnvironment createDefaultEnvironment()  
    {
        try
        {
            // Find constructor (class is package private, so we can't access it directly)
            Constructor<ControllerEnvironment> constructor = (Constructor<ControllerEnvironment>)
                Class.forName("net.java.games.input.DefaultControllerEnvironment").getDeclaredConstructors()[0];

            // Constructor is package private, so we have to deactivate access control checks
            constructor.setAccessible(true);

            // Create object with default constructor
            ControllerEnvironment env = constructor.newInstance();
            jinputAvailable = true;
            return env;
        }
        catch (Throwable e)
        {
            Configuration.getConfiguration().getLogEntity().addLog(e, WARN);
        }
        jinputAvailable = false;
        return null;
    }
    
    /**
     * Search (and save) for controllers of type Controller.Type.STICK,
     * Controller.Type.GAMEPAD, Controller.Type.WHEEL and Controller.Type.FINGERSTICK.
     * @return 
     */
    public static ArrayList<Controller> getCurrentControllers() 
    {
        foundControllers = new ArrayList<Controller>();
        ControllerEnvironment env = createDefaultEnvironment();
        if (env == null) return foundControllers;
        
        Controller[] controllers = env.getControllers();
        
        for(int i = 0; i < controllers.length; i++)
        {
            Controller controller = controllers[i];
            
            if (
                    controller.getType() == Controller.Type.STICK || 
                    controller.getType() == Controller.Type.GAMEPAD || 
                    controller.getType() == Controller.Type.WHEEL ||
                    controller.getType() == Controller.Type.MOUSE ||
                    controller.getType() == Controller.Type.TRACKBALL ||
                    controller.getType() == Controller.Type.FINGERSTICK
               )
            {
                // Add new controller to the list of all controllers.
                foundControllers.add(controller);
            }
        }
        return foundControllers;
    }
    
    public static Controller getController(String name)
    {
        if (foundControllers == null) return null;
        for (Controller c: foundControllers)
        {
            if (c.getName().equals(name)) return c;
        }
        return null;
    }
}
