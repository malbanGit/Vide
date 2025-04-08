/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.jogl;

import de.malban.Global;
import de.malban.config.Configuration;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import static de.malban.gui.panels.LogPanel.ERROR;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GLES1;
import com.jogamp.opengl.GL2;
import com.jogamp.opengl.GLCapabilities;
import com.jogamp.opengl.GLProfile;
import com.jogamp.opengl.awt.GLJPanel;
import static de.malban.Global.JOGL_ENABLE;
import de.malban.gui.panels.LogPanel;
import de.malban.vide.VideConfig;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

/**
 *
 * @author malban
 */

public class JOGLSupport 
{
    
    public int updateEachMs = 20;

    boolean init = false;
    boolean isSupported = false;
    public volatile boolean exit = false;

    public GLProfile glprofile = null;
    public GLCapabilities glcapabilities = null;
    
    private static JOGLSupport support=null;
    public static JOGLSupport getJOGLSupport()
    {
        if (support==null) support = new JOGLSupport();
        return support;
    }
    
    private JOGLSupport()
    {
    }
    
    public static boolean isVBOSupported()
    {
        return true;
    }
    public static boolean isGL4Supported()
    {
        return false;
    }
    public static boolean isJOGLSupported()
    {
        if (!JOGL_ENABLE)
            return false;
        if (!VideConfig.getConfig().tryJOGL) 
        {
            Configuration.getConfiguration().getDebugEntity().addLog("JOGL: configured off", INFO);
            return false;
        }
        boolean canJOGL = getJOGLSupport().isInit();
        return canJOGL;
    }
    public static void setJOGLSupported(boolean b)
    {
        getJOGLSupport().isSupported = b;
    }

    // http://jogamp.org/wiki/index.php/Using_JOGL_in_AWT_SWT_and_Swing
    private boolean isInit()
    {
        if (!Global.JOGL_ENABLE) 
        {
            //init = true;
            Configuration.getConfiguration().getDebugEntity().addLog("JOGL: forbidden globally", INFO);            
            return isSupported = false;
        }
        if (!init) 
        {
            init = true;
            try
            {

                glprofile = GLProfile.getDefault();
                glcapabilities = new GLCapabilities( glprofile );

            }
            catch (Throwable e)
            {
                Configuration.getConfiguration().getDebugEntity().addLog("JOGL: is not supported", ERROR);
                return isSupported = false;
            }
                
            isSupported = true;
            try
            {
//                GLJPanel gljpanel = new GLJPanel( glcapabilities ); 
//                dumpInfos(gljpanel.getGL());
//                gljpanel.destroy();
            }
            catch (Throwable e)
            {
                Configuration.getConfiguration().getDebugEntity().addLog(e, WARN);
                return false;
            }
            Configuration.getConfiguration().getDebugEntity().addLog("JOGL is supported", INFO);
        }   
        return isSupported;
    }
    // https://github.com/serhiy/jogl-lesson-2
    
    /**
    * Creates and compile the shader in the shader program.
    * 
    * @param gl2 context.
    * @param programId to create its shaders.
    * @param shaderCode to compile.
    * @param shaderType of the shader to be compiled.
    * @return the id of the created and compiled shader.
    * @throws Exception when an error occurs creating the shader program.
    */
    public static int createShader(GL2 gl2, int programId, String shaderCode, int shaderType) throws Exception 
    {
        int shaderId = gl2.glCreateShader(shaderType);
        if (shaderId == 0) 
        {
            throw new Exception("Error creating shader. Shader id is zero.");
        }

        gl2.glShaderSource(shaderId, 1, new String[] { shaderCode }, null);
        gl2.glCompileShader(shaderId);

        IntBuffer intBuffer = IntBuffer.allocate(1);
        gl2.glGetShaderiv(shaderId, GL2.GL_COMPILE_STATUS, intBuffer);

        if (intBuffer.get(0) != 1) 
        {
            gl2.glGetShaderiv(shaderId, GL2.GL_INFO_LOG_LENGTH, intBuffer);
            int size = intBuffer.get(0);
            if (size > 0) 
            {
                ByteBuffer byteBuffer = ByteBuffer.allocate(size);
                gl2.glGetShaderInfoLog(shaderId, size, intBuffer, byteBuffer);
                //System.out.println(new String(byteBuffer.array()));
            }
            throw new Exception("Error compiling shader!");
        }

        gl2.glAttachShader(programId, shaderId);

        return shaderId;
    }

    /**
     * Links the shaders within created shader program.
     * 
     * @param gl2 context.
     * @param programId to link its shaders.
     * @throws Exception when an error occurs linking the shaders.
     */
    public static void link(GL2 gl2, int programId) throws Exception 
        {
        gl2.glLinkProgram(programId);

        IntBuffer intBuffer = IntBuffer.allocate(1);
        gl2.glGetProgramiv(programId, GL2.GL_LINK_STATUS, intBuffer);

        if (intBuffer.get(0) != 1) 
        {
            gl2.glGetProgramiv(programId, GL2.GL_INFO_LOG_LENGTH, intBuffer);
            int size = intBuffer.get(0);
            if (size > 0) 
            {
                ByteBuffer byteBuffer = ByteBuffer.allocate(size);
                gl2.glGetProgramInfoLog(programId, size, intBuffer, byteBuffer);
                //System.out.println(new String(byteBuffer.array()));
            }
            throw new Exception("Error linking shader program!");
        }

        gl2.glValidateProgram(programId);

        intBuffer = IntBuffer.allocate(1);
        gl2.glGetProgramiv(programId, GL2.GL_VALIDATE_STATUS, intBuffer);

        if (intBuffer.get(0) != 1) 
        {
            gl2.glGetProgramiv(programId, GL2.GL_INFO_LOG_LENGTH, intBuffer);
            int size = intBuffer.get(0);
            if (size > 0) 
            {
                ByteBuffer byteBuffer = ByteBuffer.allocate(size);
                gl2.glGetProgramInfoLog(programId, size, intBuffer, byteBuffer);
                //System.out.println(new String(byteBuffer.array()));
            }
            throw new Exception("Error validating shader program!");
        }
    }


    ///////////////////////////////////////////////////////////////////////////////
    // check FBO completeness
    ///////////////////////////////////////////////////////////////////////////////
    public static boolean checkFramebufferStatus(GL2 gl2, int fbo, String which)
    {
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        // check FBO status
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, fbo); // bind
        int status = gl2.glCheckFramebufferStatus(GL2.GL_FRAMEBUFFER);
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);   // unbind
        switch(status)
        {
        case GL2.GL_FRAMEBUFFER_COMPLETE:
            //log.addLog(which+": "+"Framebuffer complete.", INFO);
            return true;

        case GL2.GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
            log.addLog("[ERROR] "+which+": "+ "Framebuffer incomplete: Attachment is NOT complete.", ERROR);
            return false;

        case GL2.GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
            log.addLog("[ERROR] "+which+": "+ "Framebuffer incomplete: No image is attached to FBO.", ERROR);
            return false;
    
    case GL2.GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
        log.addLog("[ERROR] "+which+": "+ "Framebuffer incomplete: Attached images have different dimensions.", ERROR);
        return false;

    case GL2.GL_FRAMEBUFFER_INCOMPLETE_FORMATS:
        log.addLog("[ERROR] "+which+": "+ "Framebuffer incomplete: Color attached images have different internal formats.", ERROR);
        return false;
        case GL2.GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER:
            log.addLog("[ERROR] "+which+": "+ "Framebuffer incomplete: Draw buffer.", ERROR);
            return false;

        case GL2.GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER:
            log.addLog("[ERROR] "+which+": "+ "Framebuffer incomplete: Read buffer.", ERROR);
            return false;

        case GL2.GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE:
            log.addLog("[ERROR] "+which+": "+ "Framebuffer incomplete: Multisample.", ERROR);
            return false;

        case GL2.GL_FRAMEBUFFER_UNSUPPORTED:
            log.addLog("[ERROR] "+which+": "+ "Framebuffer incomplete: Unsupported by FBO implementation.", ERROR);
            return false;

        default:
            log.addLog("[ERROR] "+which+": "+ "Framebuffer incomplete: Unknown error.", ERROR);
            return false;
        }
    }

    public static boolean checkError(GL2 gl2, String where)
    {
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        int errorCode = gl2.glGetError();
        switch (errorCode)
        {
            case GL2.GL_NO_ERROR:
            {
//                log.addLog(where+": "+"JOGL OK", INFO);
                return true;
            }
            case GL2.GL_INVALID_ENUM:
            {
                log.addLog(where+": "+"JOGL GL_INVALID_ENUM", ERROR);
                return false;
            }
            case GL2.GL_INVALID_VALUE:
            {
                log.addLog(where+": "+"JOGL GL_INVALID_VALUE", ERROR);
                return false;
            }
            case GL2.GL_INVALID_OPERATION:
            {
                log.addLog(where+": "+"JOGL GL_INVALID_OPERATION", ERROR);
                return false;
            }
            case GL2.GL_INVALID_FRAMEBUFFER_OPERATION:
            {
                log.addLog(where+": "+"JOGL GL_INVALID_FRAMEBUFFER_OPERATION", ERROR);
                return false;
            }
            case GL2.GL_OUT_OF_MEMORY:
            {
                log.addLog(where+": "+"JOGL GL_OUT_OF_MEMORY", ERROR);
                return false;
            }
            case com.jogamp.opengl.GL2ES1.GL_STACK_UNDERFLOW:
            {
                log.addLog(where+": "+"JOGL GL_STACK_UNDERFLOW", ERROR);
                return false;
            }
            case com.jogamp.opengl.GL2ES1.GL_STACK_OVERFLOW:
            {
                log.addLog(where+": "+"JOGL GL_STACK_OVERFLOW", ERROR);
                return false;
            }
            default:
            {
                log.addLog(where+": "+"JOGL ERROR: " + errorCode, ERROR);
                return false;
            }
        }
    }
    public static String getJOGLInfo()
    {
        if (!isJOGLSupported())
        {
            DINFO = "JOGL not supported";
            return DINFO;
        }
                    
        try
        {
            GLProfile glprofile = null;
            GLCapabilities glcapabilities = null;
            glprofile = GLProfile.getDefault();
            glcapabilities = new GLCapabilities( glprofile );
        }
        catch (Throwable e)
        {
            DINFO = "JOGL not supported";
            return DINFO;
        }


        return DINFO;
    }
    
    // Thx Franck - I copied these...
    private static Map<Integer, String> GL_CONSTANTS;
    
    public static String dumpExtensions(GL gl)
    {
        StringBuilder b = new StringBuilder();
        String str = gl.glGetString(GL.GL_EXTENSIONS);
        StringTokenizer localStringTokenizer = new StringTokenizer(str, " ", false);
        b.append("OpenGL extensions :\n");
        while (localStringTokenizer.hasMoreTokens()) 
        {
          b.append("> " + localStringTokenizer.nextToken()+"\n");
        }
        b.append("\n");
        return b.toString();
    }
  
    static String DINFO = "Not initialized!";
    public static String dumpInfos(GL gl)
    {
        if (!DINFO.equals("Not initialized!"))
        {
            return DINFO;
        }
                    
        StringBuilder b = new StringBuilder();
        glVersion = getString(gl, GL.GL_VERSION);
        b.append("OpenGL version ..... [" + glVersion + "]\n");
        b.append("OpenGL vendor ...... [" + getString(gl, GL.GL_VENDOR) + "]"+"\n");
        b.append("OpenGL renderer .... [" + getString(gl, GL.GL_RENDERER) + "]"+"\n");
        b.append("OpenGL GLSL ........ [" + getString(gl, GL2.GL_SHADING_LANGUAGE_VERSION_ARB) + "]"+"\n");
        b.append(" "+"\n");
        b.append("MAX_TEXTURE_UNITS = " + getInt(gl, GL2.GL_MAX_TEXTURE_UNITS)+"\n");
        b.append("MAX_TEXTURE_IMAGE_UNITS = " + getInt(gl, GL2.GL_MAX_TEXTURE_IMAGE_UNITS_ARB)+"\n");
        b.append("MAX_COMBINED_TEXTURE_IMAGE_UNITS = " + getInt(gl, GL2.GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS)+"\n");
        b.append("MAX_VERTEX_TEXTURE_IMAGE_UNITS = " + getInt(gl, GL2.GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS)+"\n");
        b.append("MAX_TEXTURE_COORDS = " + getInt(gl, GL2.GL_MAX_TEXTURE_COORDS)+"\n");
        b.append("MAX_TEXTURE_SIZE = " + getInt(gl, GL2.GL_MAX_TEXTURE_SIZE)+"\n");
        b.append("MAX_VIEWPORT_DIMS = " + getInt(gl, GL2.GL_MAX_VIEWPORT_DIMS)+"\n");
        b.append("MAX_RENDERBUFFER_SIZE = " + getInt(gl, GL2.GL_MAX_RENDERBUFFER_SIZE)+"\n");
        b.append(" "+"\n");
        b.append("MAX_ATTRIB_STACK_DEPTH = " + getInt(gl, GL2.GL_MAX_ATTRIB_STACK_DEPTH)+"\n");
        b.append("MAX_CLIENT_ATTRIB_STACK_DEPTH = " + getInt(gl, GL2.GL_MAX_CLIENT_ATTRIB_STACK_DEPTH)+"\n");
        b.append("MAX_MODELVIEW_STACK_DEPTH = " + getInt(gl, GL2.GL_MAX_MODELVIEW_STACK_DEPTH)+"\n");
        b.append("MAX_PROJECTION_STACK_DEPTH = " + getInt(gl, GL2.GL_MAX_PROJECTION_STACK_DEPTH)+"\n");
        b.append("MAX_COLOR_ATTACHMENTS = " + getInt(gl, GL2.GL_MAX_COLOR_ATTACHMENTS)+"\n");
        b.append("MAX_DRAW_BUFFERS = " + getInt(gl, GL2.GL_MAX_DRAW_BUFFERS)+"\n");
        b.append("AUX_BUFFERS = " + getInt(gl, GL2.GL_AUX_BUFFERS)+"\n");
        b.append(" "+"\n");
        b.append("ALIASED_POINT_SIZE_RANGE = " + getRange(gl, GL2.GL_ALIASED_POINT_SIZE_RANGE)+"\n");
        b.append("SMOOTH_POINT_SIZE_RANGE = " + getRange(gl, GL2.GL_SMOOTH_POINT_SIZE_RANGE)+"\n");
        b.append("POINT_SIZE_RANGE = " + getRange(gl, GL2.GL_POINT_SIZE_RANGE)+"\n");
        b.append("POINT_SIZE_GRANULARITY = " + getInt(gl, GL2.GL_POINT_SIZE_GRANULARITY)+"\n");
        b.append("SMOOTH_POINT_SIZE_GRANULARITY = " + getInt(gl, GL2.GL_SMOOTH_POINT_SIZE_GRANULARITY)+"\n");
        b.append(" "+"\n");
        b.append("ALIASED_LINE_WIDTH_RANGE = " + getRange(gl, GL2.GL_ALIASED_LINE_WIDTH_RANGE)+"\n");
        b.append("SMOOTH_LINE_WIDTH_RANGE = " + getRange(gl, GL2.GL_SMOOTH_LINE_WIDTH_RANGE)+"\n");
        b.append("LINE_WIDTH_RANGE = " + getRange(gl, GL2.GL_LINE_WIDTH_RANGE)+"\n");
        b.append("LINE_WIDTH_GRANULARITY = " + getInt(gl, GL2.GL_LINE_WIDTH_GRANULARITY)+"\n");
        b.append("SMOOTH_LINE_WIDTH_GRANULARITY = " + getInt(gl, GL2.GL_SMOOTH_LINE_WIDTH_GRANULARITY)+"\n");
        b.append(" "+"\n");
        b.append("GL_rgba_BITS = (R" + getInt(gl, GL2.GL_RED_BITS) + ", G" + getInt(gl, GL2.GL_GREEN_BITS) + ", B" + getInt(gl, GL2.GL_BLUE_BITS) + ", A" + getInt(gl, GL2.GL_ALPHA_BITS) + ")"+"\n");
        b.append("GL_ACCUM_rgba_BITS = (R" + getInt(gl, GL2.GL_ACCUM_RED_BITS) + ", G" + getInt(gl, GL2.GL_ACCUM_GREEN_BITS) + ", B" + getInt(gl, GL2.GL_ACCUM_BLUE_BITS) + ", A" + getInt(gl, GL2.GL_ACCUM_ALPHA_BITS) + ")"+"\n");
        b.append("GL_DEPTH_BITS = " + getInt(gl, GL2.GL_DEPTH_BITS)+"\n");
        b.append("GL_STENCIL_BITS = " + getInt(gl, GL2.GL_STENCIL_BITS)+"\n");
        b.append("GL_SUBPIXEL_BITS = " + getInt(gl, GL2.GL_SUBPIXEL_BITS)+"\n");
        b.append("GL_STEREO = " + getBool(gl, GL2.GL_STEREO)+"\n");
        b.append(" "+"\n");
        maxSample = de.malban.util.UtilityString.Int0(getInt(gl, GL.GL_MAX_SAMPLES ));
        b.append("MAX_SAMPLES = " + maxSample+"\n");
        multiSample = de.malban.util.UtilityString.Int0(getInt(gl, GL.GL_SAMPLES ));
        b.append("SAMPLES = " + multiSample+"\n");
        b.append("M VERSION = " + getVersion()+"\n");
        b.append(" "+"\n");
        
       
        
        b.append(dumpExtensions(gl));
        DINFO = b.toString();
        return DINFO;
    }
    public static String glVersion = "";
    public static int maxSample = 0;
    public static int multiSample = 0;
    public static boolean isMultiSampleSupported()
    {
        return (maxSample>1);
    }
    // 2.1 = 210
    
    public static int getVersion()
    {
        if (glVersion.trim().length() == 0) return 0;
        int pos = 0;
        int times = 100;
        int v = de.malban.util.UtilityString.Int0(glVersion.substring(pos++, pos)) * times;
        
        times = times / 10;
        String t = glVersion.substring(pos++, pos);
        if (!t.equals("."))
        {
            v += de.malban.util.UtilityString.Int0(t) * times; 
            times = times / 10;
        }
        else
        {
            v += de.malban.util.UtilityString.Int0(glVersion.substring(pos++, pos)) * times; 
            times = times / 10;
        }
        
        return v;
    }
            
    
  
  public static String getBool(GL paramGL, int paramInt)
  {
    int[] arrayOfInt = new int[3];
    paramGL.glGetIntegerv(paramInt, arrayOfInt, 0);
    return arrayOfInt[0] != 0 ? "true" : 1280 == paramGL.glGetError() ? "n/a" : "false";
  }
  
  public static String getInt(GL paramGL, int paramInt)
  {
    int[] arrayOfInt = { -1, -1, -1 };
    paramGL.glGetIntegerv(paramInt, arrayOfInt, 0);
    return 1280 == paramGL.glGetError() ? "n/a" : Integer.toString(arrayOfInt[0]);
  }
  
  public static String getString(GL paramGL, int paramInt)
  {
    String str = paramGL.glGetString(paramInt);
    return 1280 == paramGL.glGetError() ? "n/a" : str;
  }
  
  public static String getRange(GL paramGL, int paramInt)
  {
    int[] arrayOfInt = { -1, -1, -1 };
    paramGL.glGetIntegerv(paramInt, arrayOfInt, 0);
    return "[" + arrayOfInt[0] + ".." + arrayOfInt[1] + "]";
  }
  
  public static final String getNonNullConstantName(int paramInt)
  {
    String str = getConstantName(paramInt);
    return "0x" + Integer.toHexString(paramInt).toUpperCase();
  }
  
  public static final synchronized String getConstantName(int paramInt)
  {
    if (GL_CONSTANTS == null) {
      GL_CONSTANTS = fetchConstants();
    }
    return (String)GL_CONSTANTS.get(Integer.valueOf(paramInt));
  }
  
  private static final Map<Integer, String> fetchConstants()
  {
    HashMap localHashMap = new HashMap();
    Field[] arrayOfField;
    int j = (arrayOfField = GL.class.getDeclaredFields()).length;
    for (int i = 0; i < j; i++)
    {
      Field localField = arrayOfField[i];
      String str = localField.getName();
      try
      {
        if (str.startsWith("GL_"))
        {
          int k = localField.getModifiers();
          if ((Modifier.isStatic(k)) && (Modifier.isPublic(k)) && (localField.getType().isAssignableFrom(Integer.TYPE)))
          {
            Object localObject = localField.get(null);
            localHashMap.put((Integer)localObject, str.substring(3));
          }
        }
      }
      catch (Exception localException) {}
    }
    return localHashMap;
  }
  

}
