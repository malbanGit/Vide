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
import static de.malban.vide.vecx.VecXStatics.VECTOR_CNT;
import java.nio.FloatBuffer;
import java.util.ArrayList;
import org.lwjgl.BufferUtils;
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
        
        public int x = 0;
        public int y = 0;
        public int width = 0;
        public int height = 0;
        public String name="";
        
        public boolean resized=false;
//        public FloatBuffer DataBuffer= BufferUtils.createFloatBuffer(VECTOR_CNT);
  
        // ray test
        public FloatBuffer DataBuffer= BufferUtils.createFloatBuffer(200000);
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
// Mac needed?
                glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
                glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
                glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
                glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
                
                
                
                // see also : http://http.developer.nvidia.com/GPUGems2/gpugems2_chapter22.html
                // http://www.java-gaming.org/topics/lwjgl-antialiased-lines/30894/msg/285878/view.html#msg285878
                // sort of antialiaze
                glfwWindowHint(GLFW_STENCIL_BITS, 4);
glfwWindowHint(GLFW_SAMPLES, 4);
                
// http://www.opengl-tutorial.org/
//http://www.opengl-tutorial.org/intermediate-tutorials/tutorial-10-transparency/

//different cxolors: http://www.opengl-tutorial.org/beginners-tutorials/tutorial-4-a-colored-cube/
//glow:
//blur
  //      and use additive blending

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
    int shader;
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
                        if (w.resized){
                            GL11.glViewport(0, 0, w.width, w.height);
                            w.resized = false;
                        }
                        
                        glfwMakeContextCurrent(w.window);
                        GL.setCapabilities(w.caps);

                        if (glfwWindowShouldClose(w.window))
                        {
                            if (removeWindowPending == null)
                            {
                                removeWindowPending = w;
                            }
                            continue;
                        }
                        if (w.renderer == null) continue;

        w.DataBuffer.clear();
                        int lines = w.renderer.render(w);
        w.DataBuffer.flip();//set the limit at the position=end of the data(ie no effect right now),and sets the position at 0 again 
        int buffer = GL15.glGenBuffers();
        GL15.glBindBuffer(GL15.GL_ARRAY_BUFFER, buffer);
        GL15.glBufferData(GL15.GL_ARRAY_BUFFER, w.DataBuffer, GL15.GL_STATIC_DRAW);
        
                        
                        if (lines == 0) continue;
                        GL11.glClear(GL11.GL_COLOR_BUFFER_BIT | GL11.GL_DEPTH_BUFFER_BIT); // clear the framebuffer
                        GL20.glUseProgram(shader);
  
                        int position=GL20.glGetAttribLocation(shader, "position");
                        GL20.glEnableVertexAttribArray(position);
                        GL20.glVertexAttribPointer(position, 2, GL11.GL_FLOAT, false, 0, 0);
                        GL11.glDrawArrays(GL11.GL_LINES, 0, lines);
GL15.glDeleteBuffers(buffer);

                        
                        // cleanup
                        GL20.glDisableVertexAttribArray(position);
                        GL20.glUseProgram(0);

                        glfwSwapBuffers(w.window); // swap the color buffers

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

        // Center our window
        glfwSetWindowPos(
                w.window,
                (vidmode.width() - w.width) / 2,
                (vidmode.height() - w.height) / 2
        );
        
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
        
        GLFWWindowSizeCallbackI windowSizeCallback;
        glfwSetWindowSizeCallback(w.window, windowSizeCallback = new GLFWWindowSizeCallbackI() 
            {
                @Override
                public void invoke(long window, int width, int height) 
                {
                    w.resized=true;
                    w.width=width;
                    w.height=height;
                }
            });            
        
        glfwMakeContextCurrent(w.window);
        
        // Enable v-sync
        glfwSwapInterval(1);
        glfwShowWindow(w.window);  

        // This line is critical for LWJGL's interoperation with GLFW's
        // OpenGL context, or any context that is managed externally.
        // LWJGL detects the context that is current in the current thread,
        // creates the GLCapabilities instance and makes the OpenGL
        // bindings available for use.
        w.caps = GL.createCapabilities();

        

        ////////////////Prepare the Shader////////////////
        String vert=
                "#version 330                                \n"+
                "in vec2 position;                            \n"+
                "void main(){                                \n"+
                "    gl_Position = vec4(position, 0.0f,1.0f);        \n"+
                "}                                            \n";
        String frag=
                "#version 330                                \n"+
                "out vec4 out_color;                        \n"+
                "void main(){                                \n"+
                "    out_color = vec4(1.0f, 0.0f, 0.0f, 0.5f);        \n"+
                "}                                            \n";
        shader = createShaderProgramme(new int[]{
                GL20.GL_VERTEX_SHADER, GL20.GL_FRAGMENT_SHADER
        }, new String[]{
                vert, frag
        });

        ////////////////End////////////////                    

        
        // Set the clear color
        glClearColor(0.0f, 0.0f, 0.0f, 0.0f);        
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // clear the framebuffer
                glLineWidth(1);

        
        
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
    int CreateShader(int shadertype,String shaderString)
    {
         int shader = GL20.glCreateShader(shadertype);
         GL20.glShaderSource(shader, shaderString);
         GL20.glCompileShader(shader);
         int status = GL20.glGetShaderi(shader, GL20.GL_COMPILE_STATUS);
         if (status == GL11.GL_FALSE){

             String error=GL20.glGetShaderInfoLog(shader);

             String ShaderTypeString = null;
             switch(shadertype)
             {
             case GL20.GL_VERTEX_SHADER: ShaderTypeString = "vertex"; break;
             case GL32.GL_GEOMETRY_SHADER: ShaderTypeString = "geometry"; break;
             case GL20.GL_FRAGMENT_SHADER: ShaderTypeString = "fragment"; break;
             }

             System.err.println( "Compile failure in " +ShaderTypeString + " shader:\n" + error);
         }
         return shader;
     }

     public int createShaderProgramme(int[] shadertypes, String[] shaders){
         int[] shaderids = new int[shaders.length];
         for (int i = 0; i < shaderids.length; i++) {
             shaderids[i] = CreateShader(shadertypes[i], shaders[i]);
         }
         return createShaderProgramme(shaderids);
     }

     public int createShaderProgramme(int[] shaders){
         int program = GL20.glCreateProgram();
         for (int i = 0; i < shaders.length; i++) {
             GL20.glAttachShader(program, shaders[i]);
         }
         GL20.glLinkProgram(program);

         // link status seem not to be a valid parameter for GL20
         // WRONG! IN EXAMPLE
        int status =                  GL20.glGetProgrami(program, GL20.GL_LINK_STATUS);
         if (status == GL11.GL_FALSE){
             String error = GL20.glGetProgramInfoLog(program);
             System.err.println( "Linker failure: "+error);
         }
         for (int i = 0; i < shaders.length; i++) {
             GL20.glDetachShader(program, shaders[i]);
         }
         return program;
     }   
}
// see: https://github.com/LWJGL/lwjgl3/blob/master/modules/core/src/test/java/org/lwjgl/demo/glfw/MultipleWindows.java