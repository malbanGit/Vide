/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.lwgl;

import de.malban.Global;
import de.malban.config.Configuration;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import java.util.ArrayList;
import org.lwjgl.glfw.*;
import static org.lwjgl.glfw.Callbacks.glfwFreeCallbacks;
import org.lwjgl.opengl.*;

import static org.lwjgl.glfw.GLFW.*;
import static org.lwjgl.opengl.GL11.*;
/**
 *
 * @author malban
 */
public class LWJGLSupport 
{
    public int updateEachMs = 20;

    boolean init = false;
    boolean isSupported = false;
    public volatile boolean exit = false;
    public class GLWindow
    {
        public LWJGLRenderer renderer = null;
        public long window=0;
        public GLCapabilities caps=null;
        
        int x = 0;
        int y = 0;
        int width = 0;
        int height = 0;
        String name="";
    }
    
    private ArrayList<GLWindow> windows = new ArrayList<GLWindow>();
    GLWindow addWindowPending = null;
    GLWindow removeWindowPending = null;

    private static LWJGLSupport support=null;
    public static LWJGLSupport getLWJGLSupport()
    {
        if (support==null) support = new LWJGLSupport();
        return support;
    }
    
    private LWJGLSupport()
    {
    }
    
    
    public static boolean isLWJGLSupported()
    {
        return getLWJGLSupport().isInit();
    }
    
    // first time main thread
    private boolean isInit()
    {
        if (!Global.LWJGL_ENABLE) 
        {
            init = true;
            return isSupported = false;
        }
        if (!init) 
        {
            init = true;
            try
            {
                // Setup an error callback. The default implementation
                // will print the error message in System.err.
                GLFWErrorCallback.createPrint(Configuration.getConfiguration().getLogStream()).set();
                GLFWErrorCallback.createPrint(System.err).set();

                // Initialize GLFW. Most GLFW functions will not work before doing this.
                if ( !glfwInit() )
                {
                    Configuration.getConfiguration().getDebugEntity().addLog("glfwInit() failed", WARN);
                    Configuration.getConfiguration().getDebugEntity().addLog("LWJGL is not supported", INFO);
                    return isSupported = false;
                }
            }
            catch (Throwable e)
            {
                Configuration.getConfiguration().getDebugEntity().addLog("LWJGL is not supported", INFO);
                return isSupported = false;
            }
                
            try
            {

                // Configure our window
                glfwDefaultWindowHints(); // optional, the current window hints are already the default
                glfwWindowHint(GLFW_VISIBLE, GLFW_FALSE); // the window will stay hidden after creation
                glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE); // the window will be resizable

                glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
                glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
                glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
                glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
                
            }
            catch (Throwable e)
            {
                Configuration.getConfiguration().getDebugEntity().addLog(e, WARN);
                return false;
            }
            Configuration.getConfiguration().getDebugEntity().addLog("LWJGL is supported", INFO);
            isSupported = true;
        }   
        return isSupported;
    }
    
    
    // any thread
    public GLWindow addWindow(int x, int y, int width, int height, String name, LWJGLRenderer renderer)
    {
        GLWindow w = new GLWindow();
        w.x = x;
        w.y = y;
        w.width = width;
        w.height = height;
        w.name = name;
        w.renderer = renderer;

        while (addWindowPending != null) 
        {
            try
            {
                Thread.sleep(5);
            }
            catch (Throwable e)
            {
                
            }
        }
        addWindowPending = w;
        return w;
    }
    // any thread
    public void removeWindow(GLWindow w)
    {
        if (w == null) return;
        if (w.window == 0) return;
        if (w.renderer == null) return;
        while (removeWindowPending != null) 
        {
            try
            {
                Thread.sleep(5);
            }
            catch (Throwable e)
            {
            }
        }
        removeWindowPending = w;
    }

    // in main thread
    public void deliverMainThread()
    {
        if (!isLWJGLSupported()) return;
        while (!exit)
        {
            try
            {
                
                glfwPollEvents();
                long cc = glfwGetCurrentContext();

                synchronized (windows)
                {
                    for (GLWindow w: windows)
                    {
                        glfwMakeContextCurrent(w.window);
                        GL.setCapabilities(w.caps);

                        if (glfwWindowShouldClose(w.window))
                        {
                            if (removeWindowPending == null)
                            {
                                removeWindowPending = w;
                            }
                            break;
                        }
                        else
                        {
                            if (w.renderer != null)
                            {

                                w.renderer.render();
                            }
                        }
                    }
                }
                try
                {
                    Thread.sleep(updateEachMs);
                }
                catch (Throwable e)
                {

                }
                if (addWindowPending != null)
                {
                    initWindow(addWindowPending);
                    addWindowPending = null;
                }
                if (removeWindowPending != null)
                {
                    deinitWindow(removeWindowPending);
                    removeWindowPending = null;
                }
            }
            catch (Throwable e)
            {
                e.printStackTrace();
            }
        }
    }

    // in main thread
    private void initWindow(GLWindow w)
    {
        
        // Create the window
        w.window = glfwCreateWindow(w.width, w.height, w.name, 0, 0);
        if ( w.window == 0 ) return;
        
        // Get the resolution of the primary monitor
        GLFWVidMode vidmode = glfwGetVideoMode(glfwGetPrimaryMonitor());

        GLFWKeyCallbackI i = new GLFWKeyCallbackI()
        {

            @Override
            public void invoke(long window, int key, int scancode, int action, int mods) 
            {
                if ( key == GLFW_KEY_ESCAPE && action == GLFW_RELEASE )
                    glfwSetWindowShouldClose(window, true); // We will detect this in our rendering loop            
            }
            
        };
        glfwSetKeyCallback(w.window, i);
        
        
        glfwMakeContextCurrent(w.window);
        // This line is critical for LWJGL's interoperation with GLFW's
        // OpenGL context, or any context that is managed externally.
        // LWJGL detects the context that is current in the current thread,
        // creates the GLCapabilities instance and makes the OpenGL
        // bindings available for use.
        w.caps = GL.createCapabilities();

        // Set the clear color
        glClearColor(1.0f, 0.0f, 0.0f, 0.0f);        
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // clear the framebuffer
            
        // glfwSwapInterval(1);

        glfwShowWindow(w.window);  
        // Center our window
        glfwSetWindowPos(
                w.window,
                (vidmode.width() - w.width) / 2,
                (vidmode.height() - w.height) / 2
        );
        
        synchronized (windows)
        {
            windows.add(w);
        }
    }

    // in main thread
    private void deinitWindow(GLWindow w)
    {
        if (w == null) return;
        if (w.renderer == null) return;
        if (windows.size() == 0) return;
        synchronized (windows)
        {
            windows.remove(w);
        }
        // Make the window visible
        glfwHideWindow(w.window);  
        glfwFreeCallbacks(w.window);
        glfwDestroyWindow(w.window);        

        w.window=0;
        LWJGLRenderer r = w.renderer;
        w.renderer=null;
        
        if (r != null)
            r.lwjglExit();
    }
}
// see: https://github.com/LWJGL/lwjgl3/blob/master/modules/core/src/test/java/org/lwjgl/demo/glfw/MultipleWindows.java