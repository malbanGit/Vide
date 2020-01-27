/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.input;

import de.malban.Global;
import de.malban.config.Configuration;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import java.io.OutputStream;
import java.io.PrintStream;
import java.lang.reflect.Constructor;
import java.util.ArrayList;
import net.java.games.input.Controller;
import net.java.games.input.ControllerEnvironment;

/**
 *
 * @author malban
 */
public class SystemController 
{
    public static boolean init = false;
    public static boolean supported = false;
    private static ArrayList<Controller> foundControllers;
    private static Boolean jinputAvailable = null;

    public static boolean isJInputAvailable()
    {
        if (jinputAvailable == null)
        {
             createDefaultEnvironment();
        }
        return jinputAvailable;
    }
    
    public static boolean isJInputSupported()
    {
        createDefaultEnvironment();
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

            
            // needs             // -Djava.library.path="lib"

            String test = System.mapLibraryName("jinput-osx");
//            if (test.equals("libjinput-osx.dylib")) test = "libjinput-osx.jnilib";
            
//            System.loadLibrary("jinput-osx");
            // Create object with default constructor

            
            ControllerEnvironment env = constructor.newInstance();
            if (!init)
            {
                // get rid of the stupd ever the same message that some stup input device can not be mapped!
                System.setErr(Global.devNull);
                Controller[] controllers = env.getControllers();
                System.setErr(Global.devErr);
                init = true;
                Configuration.getConfiguration().getDebugEntity().addLog("JInput is supported", INFO);
            }
            jinputAvailable = true;
            return env;
        }
        catch (Throwable e)
        {
            Configuration.getConfiguration().getLogEntity().addLog(e, WARN);
        }
        try
        {
            // this try & catch is only that the component still works in netbeans
        System.setErr(Global.devErr);
        }
        catch (Throwable e)
        {
        }
        
        jinputAvailable = false;
        if (!init)
        {
            init = true;
            Configuration.getConfiguration().getDebugEntity().addLog("JInput is not supported", INFO);
        }
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
    
    public static Controller getControllerReload(String name)
    {
        getCurrentControllers();
        if (foundControllers == null) return null;
        for (Controller c: foundControllers)
        {
            if (c.getName().equals(name)) return c;
        }
        return null;
    }
}
