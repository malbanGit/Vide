/*
todo:
chassis drawing
fullscreen
seperate window
commandline parameters

optimize shaders linear sampling..., smaller buffers?
*/



/*
    MSAA framebuffer untialiazing: http://www.songho.ca/opengl/gl_fbo.html
    glow filters with "n" passes (framebuffer based)
    persistency with an "old" back buffer: https://stackoverflow.com/questions/2171085/opengl-blending-with-previous-contents-of-framebuffer
    Chassis possibility with textures

 MSAA prefered to "SMOOTH"
http://nehe.gamedev.net/tutorial/fullscreen_antialiasing/16008/
https://www.khronos.org/opengl/wiki/Common_Mistakes


GLSL VERSIONs
https://github.com/mattdesl/lwjgl-basics/wiki/GLSL-Versions

//http://www.ozone3d.net/tutorials/image_filtering_p2.php


https://stackoverflow.com/questions/18814977/using-a-vbo-to-draw-lines-from-a-vector-of-points-in-opengl

A VBO is a buffer located somewhere in memory (almost always in dedicated GPU memory - VRAM) of a fixed size. You specify this size in glBufferData, and you also simultaneously give the GL a pointer to copy from. The key word here is copy. Everything you do to the vector after glBufferData isn't reflected in the VBO.

You should be binding and doing another glBufferData call after changing the vector. You will also probably get better performance from glBufferSubData or glMapBuffer if the VBO is already large enough to handle the new data, but in a small application like this the performance hit of calling glBufferData every time is basically non-existent.

Also, to address your other question about the values you need to pick out x, y, etc. The way your VBO is set up is that the values are interleaved. so in memory, your vertices will look like this:

+-------------------------------------------------
| x | y | u | v | r | g | b | x | y | u | v | ... 
+-------------------------------------------------

You tell OpenGL where your vertices and colors are with the glVertexPointer and glColorPointer functions respectively.

    The size parameter specifies how many elements there are for each vertex. In this case, it's 2 for vertices, and 3 for colors.
    The type parameter specifies what type each element is. In your case it's GL_FLOAT for both.
    The stride parameter is how many bytes you need to skip from the start of one vertex to the start of the next. With an interleaved setup like yours, this is simply sizeof(vertex) for both.
    The last parameter, pointer, isn't actually a pointer to your vector in this case. When a VBO is bound, pointer becomes a byte offset into the VBO. For vertices, this should be 0, since the first vertex starts at the very first byte of the VBO. For colors, this should be 4 * sizeof(float), since the first color is preceded by 4 floats.




    // https://gamedev.stackexchange.com/questions/18777/how-do-i-implement-anti-aliasing-in-opengl
    //http://antongerdelan.net/opengl/shaders.html
    // open gl Framebuffer
    // http://www.geeks3d.com/20110405/fxaa-fast-approximate-anti-aliasing-demo-glsl-opengl-test-radeon-geforce/
    // https://learnopengl.com/#!Advanced-OpenGL/Anti-Aliasing



//http://lazyfoo.net/tutorials/OpenGL/index.php#Matrices%20and%20Coloring%20Polygons
// http://nehe.gamedev.net/tutorial/texture_mapping/12038/

// blur shader example
// http://roxlu.com/2014/045/fast-opengl-blur-shader
// https://wiki.delphigl.com/index.php/shader_blur2

//https://github.com/mattdesl/lwjgl-basics/wiki/OpenGL-ES-Blurs

// 2 pass blur
// fbo https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson5
// http://www.gamerendering.com/2008/10/11/gaussian-blur-filter-shader/


// stroke
// https://www.dgp.toronto.edu/~hertzman/stroke/





MEMORY
http://forum.jogamp.org/Memory-management-of-Texture-td4031544.html

However, I'm almost sure that JOGL is forced to create a direct NIO buffer under the hood when using this call:
https://github.com/sgothel/jogl/blob/master/src/jogl/classes/com/jogamp/opengl/util/texture/Texture.java#L1091
That's why I told you to take care of direct NIO buffers. AWTTextureData.getBuffer() returns the wrapped buffer, 
not this durect NIO buffer. If you used TextureIO instead of AWTTextureIO, the texture provider would return 
(probably) a TextureData using a direct NIO buffer and then you could get it with TextureData.getBuffer() in order 
to release its native memory with sun.misc.Cleaner... 

Anyway, heeding your warning concerning ByteBuffer, I have run some test:
Test 1: create lots of textures with AWTTextureIO and doesnt destroy them.
Result: Caused memory leaks that's not observed by the JVM until physical memory has run out, then some magic happened, keeping it in check. http://i.imgur.com/n95tV06.png

Test 2: create lots of textures (100 times as big as in test 1, in fact) and use Texture.destroy(GL gl) to get rid of them.
Result: Doesnt cause memory leak. Memory usage fluctuate stably between 200 and 300 MB. http://i.imgur.com/xZ9Ly2u.png

Conclusion: Texture.destroy(GL gl) solves memory leak, walks the dog, sends flowers to the chick, keeps investors happy and puts food on the table.

Disclaimer: FPS is not recorded. 

*/

/*
General VEDI OPENGL notes:

- set brightness to data according to movement speed, brightness and dot dwell
- rendering of "vectrex" lines is done to the current active "drawing" context via glDrawArrays(GL.GL_LINES,) [or points]
- using "vbo" (VertexBufferObjects)
- a BASIC vertex and a fragment shader is used
- color (brightness) information are taken from the vectrex lines gotten from the emulator
- and speed/dotdwell also
- dran can be 3 type of entities
  a) points (with dot dwell)
  b) lines (normal stuff)
  c) curved lines (midline changes) are rendered via catMul Splines (custom routine) using LINE_STRIPS (in GL)
- the context is either a "normal" Framebuffer, or a MSAA Framebuffer depending on the antialiazing settings
- a spill shader is implemented, that can "spill" overflowing color/brightness information to 
  neighboring "pixels"
- glow shader (actual gaussian blur) is aplied with configuration parameters (n-times blur)
- persistence is implemented in the way, that the "old" frame buffer is copied "under" the new (current) with blend function "MAX",
  the new frame is than copied to the next "old" with reduced brightness (configuration persistence). Via a special shader
  brightness is reduced during that copy.
- the resulting frame buffer texture is drawn on a quad of the size of the display, to the opengl panel
- last an overlay is drawn "above" (blending) the display
- overlay can be adjusted with three different values
  a) alpha threshold
  b) alpha "dim" if no vectors are drawn (direct adjustment of alpha values)
  c) alpha "brighter" if vectors are drawn (adjustment via brightness factor of lines)
  implemented via custom shader
imager color rendering, as of now only brightness values are included - no color information 
lightpen (mouse and visibility)
Debug (imager/lightpen/debug/pause messages)
Arrows (display)
LED (display)
rotation
Raygun
Screen drawing
border overflow drawing

*/



package de.malban.vide.vecx;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL2;
import com.jogamp.opengl.GLAutoDrawable;
import com.jogamp.opengl.GLCapabilities;
import com.jogamp.opengl.GLEventListener;
import com.jogamp.opengl.util.FPSAnimator;
import com.jogamp.opengl.util.GLBuffers;
import com.jogamp.opengl.util.gl2.GLUT;
import com.jogamp.opengl.util.texture.Texture;
import com.jogamp.opengl.util.texture.awt.AWTTextureIO;
import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.graphics.SingleVectorPanel;
import de.malban.gui.Scaler;
import de.malban.gui.panels.LogPanel;
import de.malban.jogl.JOGLSupport;
import de.malban.util.extractor.Extractor;
import de.malban.vide.VideConfig;
import static de.malban.vide.vecx.VecX.OVERFLOW_BORDER_RAYWIDTH;
import static de.malban.vide.vecx.VecX.OVERFLOW_SAMPLE_MAX;
import de.malban.vide.vecx.VecX.VectrexDisplayVectors;
import static de.malban.vide.vecx.VecXPanel.DEVICE_IMAGER;
import static de.malban.vide.vecx.VecXPanel.DEVICE_LIGHTPEN;
import de.malban.vide.vecx.VecXState.vector_t;
import de.malban.vide.vecx.spline.CardinalSpline;
import de.malban.vide.vecx.spline.ParrabolicAproximation;
import de.malban.vide.vecx.spline.Pt;
import java.awt.Color;
import java.awt.Container;
import java.awt.KeyboardFocusManager;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.io.File;
import java.nio.ByteBuffer;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import java.util.ArrayList;
import javax.swing.JFrame;
import javax.swing.JInternalFrame;

/**
 *
 * @author Malban
 */

public class VecxiPanel_JOGL extends com.jogamp.opengl.awt.GLJPanel implements DisplayPanelInterface 
{
    VideConfig config = VideConfig.getConfig();
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    VecXPanel vpanel;
    
    float scaleWidthGL = ((float)1)/((float)config.ALG_MAX_X)*2;
    float scaleHeightGL = ((float)1)/((float)config.ALG_MAX_Y)*2;
    float scaleWidth = 0;
    float scaleHeight = 0;
    
    GLEventListener glListener = null;
    VecXState.vector_t directDrawVector = null;

    boolean isInit = false;
    private boolean shadersInitialized = false;
    private boolean buffersInitialized = false;
    
    
    
    
    Texture fboTexture=null;

    int programId = -1;
    int vertexShaderId;
    int fragmentShaderId;
    int positionAttribute;
    int colorAttribute;    

    private boolean blurShadersInitialized = false;
    int blurProgramId = -1;
    int blurPositionAttribute;
    int blurColorAttribute;    
    int blurTextureAttribute;    
    int blurVertexShaderId;
    int blurFragmentShaderId;
    
    int persitencyProgramId = -1;
    int persitencyVertexShaderId;
    int persitencyFragmentShaderId;

    int thresholdProgramId = -1;
    int thresholdVertexShaderId;
    int thresholdFragmentShaderId;

    int spillProgramId = -1;
    int spillVertexShaderId;
    int spillFragmentShaderId;

    int spillFinalProgramId = -1;
    int spillFinalVertexShaderId;
    int spillFinalFragmentShaderId;

    int overlayProgramId = -1;
    int overlayVertexShaderId;
    int overlayFragmentShaderId;
    
    int screenProgramId = -1;
    int screenVertexShaderId;
    int screenFragmentShaderId;

    
    boolean doDeinitBlurShaders = false;
    
    // GL IDs for the overlay
    private IntBuffer overlayTextureObject = GLBuffers.newDirectIntBuffer(1);
    boolean overlayMustFlip = false;
    private boolean overlayInitialized = false;

    boolean screenMustFlip = false;
    private IntBuffer screenTextureObject = GLBuffers.newDirectIntBuffer(1);
    
    
    
    // GL IDs for the shaders
    private IntBuffer vertexBufferObject = GLBuffers.newDirectIntBuffer(1);
    private IntBuffer lineBufferObject = GLBuffers.newDirectIntBuffer(1);

    // GL IDs for MSAA Framebuffer
    private IntBuffer fboMSAABufferObject = GLBuffers.newDirectIntBuffer(1);
    private IntBuffer fboMSAATextureObject = GLBuffers.newDirectIntBuffer(1);


    class LineFBO
    {
        IntBuffer fbo = GLBuffers.newDirectIntBuffer(1);
        IntBuffer texture = GLBuffers.newDirectIntBuffer(1);
        public LineFBO()
        {
            fbo.put(0,0);
            texture.put(0,0);
        }
    }
    LineFBO[] lineFBO = new LineFBO[6]; // framebuffers for blur ping pong (0 and 1), 2 might be used for blur base addition, 3 used for persistency
    LineFBO[] borderFBO = new LineFBO[4]; 


    
    GLAutoDrawable auddr = null;

    int gl2Width = 0;
    int gl2Height = 0;
    boolean framebufferInitialized = false;

    // maximum number of lines that can be held
    // is increased when needed!
    int MAXBUFFERSIZE_LINE = 1000;
    int MAXBUFFERSIZE_POINT = 1000;
    int MAXBUFFERSIZE_LINE_STRIP = 500;
    float linesData[];
    float pointsData[];
    
    int MAX_LINE_STRIPS = 10;
    class LineStripBuffer
    {
        public IntBuffer lineStripBufferObject = GLBuffers.newDirectIntBuffer(1);
        public float lineStripData[];
        // buffer representation needed to access the JOGL routines
        public FloatBuffer lineStripDataBuffer;
        public int lineCount;
        public int dataCount;
        
        public void updateBuffer()
        {
            lineStripData = null;
            lineStripDataBuffer = null;
            
            lineStripData = new float[MAXBUFFERSIZE_LINE_STRIP*(2+3)];
            // buffer representation needed to access the JOGL routines
            lineStripDataBuffer = FloatBuffer.wrap(lineStripData);
            lineCount = 0;
            dataCount = 0;
        }
    }
    LineStripBuffer[] lineStrips=null;
    
    void initLineStrips(int count, GL2 gl2)
    {
        deinitLineStrips(gl2);
        lineStrips = new LineStripBuffer[count];
        for (int i=0; i<count; i++)
        {
            lineStrips[i] = new LineStripBuffer();
            // we "interleaved" the data that we will use
            // meaning, we but color and position information in one array
            // we could also have done that in two different arrays
            // but since we used only one -> we create only ONE VBO [Vertex buffer object]
            gl2.glGenBuffers(1, lineStrips[i].lineStripBufferObject);
            lineStrips[i].updateBuffer();
        }
    }
    void deinitLineStrips(GL2 gl2)
    {
        if (lineStrips==null) return;
        for (int i=0; i<lineStrips.length; i++)
        {
            gl2.glDeleteBuffers(1, lineStrips[i].lineStripBufferObject);
            lineStrips[i].lineStripData = null;
            lineStrips[i].lineStripDataBuffer = null;
            lineStrips[i].lineCount = 0;
            lineStrips[i].dataCount = 0;
            lineStrips[i] = null;
        }
        lineStrips=null;
    }    
    void resetSplines()
    {
        for (int i=0; i<splineCount; i++)
        {
            lineStrips[i].lineCount = 0;
            lineStrips[i].dataCount = 0;
        }
        splineCount = 0;
    }

    int lineCount = 0;
    int pointCount = 0;
    int splineCount = 0;
    // buffer representation needed to access the JOGL routines
    FloatBuffer linesDataBuffer;

    // buffer representation needed to access the JOGL routines
    FloatBuffer pointsDataBuffer;


    // speed = 0 - 127, this is the strength (abs, since strength is -127 - +127)
    // if speed > 128, than speed = speed -128 
    //      speed = dotdwell cycles * 4
    // strength: the higher the strength speed, the less bright the vectors
    // dot dwell: the higher dot dwell -> the brigher the "dot" 
    
    float COLOR_DIV = 127;    
    float SPEED_FACTOR_MAX = 0.9f;

    
    
    public static VecxiPanel_JOGL getJOGLPanel(VecXPanel vp)
    {
        // first time - 
        GLCapabilities caps = JOGLSupport.getJOGLSupport().glcapabilities;
        caps.setRedBits(8);
        caps.setBlueBits(8);
        caps.setGreenBits(8);
        caps.setAlphaBits(8);
        caps.setDepthBits(16);
//        caps.setDoubleBuffered(true);
        VecxiPanel_JOGL gljpanel = new VecxiPanel_JOGL(vp, caps);
//gljpanel.setAutoSwapBufferMode(true);
        

        gljpanel.forceResize();

        if (gljpanel.config.JOGLAutoDisplay)
            gljpanel.animator = new FPSAnimator(gljpanel, REFRESH_FPS, true); 
        
        
        
        
        return gljpanel;
    }
    private static final int REFRESH_FPS = 60;    // Display refresh frames per second
    FPSAnimator animator = null;  // Used to drive display() 
    /**
     * Creates new form JOGLVecxiPanel
     */
    
    private VecxiPanel_JOGL()
    {
    }
    
    private VecxiPanel_JOGL(VecXPanel vp, GLCapabilities caps)
    {
        super(caps);
//        if (config.JOGLScreen) Extractor.testChassisFromPara();
        vpanel = vp;
        vertexBufferObject.put(0,0);
        lineBufferObject.put(0,0);
        fboMSAABufferObject.put(0,0);
        fboMSAATextureObject.put(0,0);
        overlayTextureObject.put(0,0);
        screenTextureObject.put(0,0);

        
        
        lineFBO[0] = new LineFBO();
        lineFBO[1] = new LineFBO();
        lineFBO[2] = new LineFBO();
        lineFBO[3] = new LineFBO();
        lineFBO[4] = new LineFBO();
        lineFBO[5] = new LineFBO();
        
        borderFBO[0] = new LineFBO();
        borderFBO[1] = new LineFBO();
        borderFBO[2] = new LineFBO();
        borderFBO[3] = new LineFBO();

        glListener = new GLEventListener() 
        {
            @Override
            public void reshape( GLAutoDrawable glautodrawable, int x, int y, int width, int height ) {
                setup( glautodrawable, width, height );
                auddr = glautodrawable;
                getCorrectFocus();
            }

            @Override
            public void init( GLAutoDrawable glautodrawable ) {
            }

            @Override
            public void dispose( GLAutoDrawable glautodrawable ) {
            }
            @Override
            public void display( GLAutoDrawable glautodrawable ) {
                render( glautodrawable, glautodrawable.getSurfaceWidth(), glautodrawable.getSurfaceHeight() );
            }
        };
        addGLEventListener( glListener );
        /*
        addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                getCorrectFocus();
            }
        });
        */
        isInit = true;        
    }
        
    void getCorrectFocus()
    {
        boolean isInternal = false;
        Container internal = null; 
        Container frame = null; 
        Container p = getParent();
        while (p != null)
        {
            if (p instanceof JInternalFrame)
            {
                isInternal = true;
                internal = p;
            }
            if (p instanceof JFrame)
            {
                frame = p;
            }
            p = p.getParent();
        }
        
        if (isInternal)
        {
            KeyboardFocusManager.getCurrentKeyboardFocusManager().setGlobalCurrentFocusCycleRoot(internal);
            internal.requestFocus();
        }
        else
        {
            KeyboardFocusManager.getCurrentKeyboardFocusManager().setGlobalCurrentFocusCycleRoot(frame);
            frame.requestFocus();
        }
    }
    
    @Override
    public void setRotation(int a) 
    {
        scaleWidth = (float) (((double)gl2Width)/((double)config.ALG_MAX_X));
        scaleHeight = (float) (((double)gl2Height)/((double)config.ALG_MAX_Y));
    }

    @Override
    public void stopGraphics() {
//        System.out.println("JOGL Not supported yet: stopGraphics"); 
    }
    
    static int MAX_RAY_VECTORS = 1000;
    vector_t[][] vectrexVectors = null;
    int rayAddPos = 0;
    int rayCount = 0;
    int currentRayAdd=0;
    int currentRayDisplay=1;
    boolean rayInit = false;
    
    @Override
    synchronized public void rayMove(int x0, int y0, int x1, int y1, int color, int dwell, boolean curved, int alg_vector_speed, int alg_leftEye, int alg_rightEye) {
        if (!rayInit) return;
        if (rayAddPos>=vectrexVectors[currentRayAdd].length-1)
        {
            MAX_RAY_VECTORS = MAX_RAY_VECTORS * 2;
            vectrexVectors = new vector_t[2][MAX_RAY_VECTORS];
            for (int i=0;i<MAX_RAY_VECTORS; i++)
            {
                vectrexVectors[0][i] = new vector_t();
                vectrexVectors[1][i] = new vector_t();
            }
            
            rayAddPos = 0;
            rayCount = 0;
        }
        vectrexVectors[currentRayAdd][rayAddPos].x0 = x0;
        vectrexVectors[currentRayAdd][rayAddPos].y0 = y0;
        vectrexVectors[currentRayAdd][rayAddPos].x1 = x1;
        vectrexVectors[currentRayAdd][rayAddPos].y1 = y1;
                
        vectrexVectors[currentRayAdd][rayAddPos].color = color;
        vectrexVectors[currentRayAdd][rayAddPos].midChange = curved;
        vectrexVectors[currentRayAdd][rayAddPos].speed = alg_vector_speed;

        vectrexVectors[currentRayAdd][rayAddPos].imagerColorLeft = alg_leftEye;
        vectrexVectors[currentRayAdd][rayAddPos].imagerColorRight = alg_rightEye;
        rayAddPos++;
    }
    @Override
    synchronized public void switchDisplay() {
        rayCount=rayAddPos;
        rayAddPos = 0;
        currentRayAdd = (currentRayAdd+1)%2;
        currentRayDisplay = (currentRayDisplay+1)%2;
        repaint();
    }


    @Override
    public void setLightPen()
    {
        // coordinates on image of vectrex
        // the image represents the fill ALG_MAX_X*ALG_MAX_Y
        int x = vpanel.getMouseX();
        int y = vpanel.getMouseY();
        
        // when panel aspect ration active, than there might be offsets for mouse to consider
        y-=topOffset;
        x-=leftOffset;
        
        
        // try correct some rounding mistakes
        y-=4;
        x-=4;

        if (y<0) {vpanel.unsetLightPen();return;} // mouse not pressed on vectrex panel
        
        // in vectrex coordinates,
        // though 0,0 is as of yet not "center", but upper left corner
        int ux =Scaler.unscaleDoubleToInt(x, scaleWidth);
        int uy =Scaler.unscaleDoubleToInt(y, scaleHeight);
        
        vpanel.setLightPen(ux, uy);
    }    


    @Override
    public void resetDirectdraw() {
        directDrawVector = null;
    }

    @Override
    public void updateDisplay()// from display interface, used by vecxi
    {
        if (!config.useRayGun)
            paintVectrex();
        repaint();
    }

    @Override
    public void directDraw(VecXState.vector_t v) {
        directDrawVector = v;
    }
    
    public void overlayChanged()
    {
        deinitOverlayTexture();
        doDeinitBlurShaders = true;
    }
    
    public void deinit()
    {
        if (animator != null)
            animator.stop();
        animator = null;
        deinitOverlayTexture();
        deinitBlurShaders();
        deinitShaders();
        deinitTextures();
        deinitFramebuffer();
        deinitMSAAFramebuffer();
        auddr = null;
        destroy();
        removeGLEventListener( glListener );
        glListener = null;
    }
    
    void deinitOverlayTexture()
    {
        if (auddr != null)
        {
            // do gl deinit "globally" in support!
            if (auddr.getGL() != null)
            {
                GL2 gl2 = auddr.getGL().getGL2();
                if (overlayInitialized)
                {
                    if (overlayTextureObject.get(0) != 0)
                    {
                        gl2.glDeleteTextures(1, overlayTextureObject);
                        overlayTextureObject.put(0,0);

                    }
                }
            }
        }
        overlayInitialized = false;
    }
    void deinitChassisTexture()
    {
        if (auddr != null)
        {
            // do gl deinit "globally" in support!
            if (auddr.getGL() != null)
            {
                GL2 gl2 = auddr.getGL().getGL2();
                if (screenTextureObject.get(0) != 0)
                {
                    gl2.glDeleteTextures(1, screenTextureObject);
                    screenTextureObject.put(0,0);
                }
            }
        }
    }
    void deinitTextures()
    {
        deinitOverlayTexture();
        deinitChassisTexture();
    }
    void deinitShaders()
    {
        if (auddr != null)
        {
            if (auddr.getGL() != null)
            {
                GL2 gl2 = auddr.getGL().getGL2();
                if (programId != -1)
                {
                    gl2.glDetachShader(programId, vertexShaderId);
                    gl2.glDetachShader(programId, fragmentShaderId);
                    gl2.glDeleteProgram(programId);
                    
                    gl2.glDetachShader(persitencyProgramId, persitencyVertexShaderId);
                    gl2.glDetachShader(persitencyProgramId, persitencyFragmentShaderId);
                    gl2.glDeleteProgram(persitencyProgramId);

                    gl2.glDetachShader(thresholdProgramId, thresholdVertexShaderId);
                    gl2.glDetachShader(thresholdProgramId, thresholdFragmentShaderId);
                    gl2.glDeleteProgram(thresholdProgramId);

                    gl2.glDetachShader(spillProgramId, spillVertexShaderId);
                    gl2.glDetachShader(spillProgramId, spillFragmentShaderId);
                    gl2.glDeleteProgram(spillProgramId);

                    gl2.glDetachShader(spillFinalProgramId, spillFinalVertexShaderId);
                    gl2.glDetachShader(spillFinalProgramId, spillFinalFragmentShaderId);
                    gl2.glDeleteProgram(spillFinalProgramId);

                    gl2.glDetachShader(overlayProgramId, overlayVertexShaderId);
                    gl2.glDetachShader(overlayProgramId, overlayFragmentShaderId);
                    gl2.glDeleteProgram(overlayProgramId);

                    gl2.glDetachShader(screenProgramId, screenVertexShaderId);
                    gl2.glDetachShader(screenProgramId, screenFragmentShaderId);
                    gl2.glDeleteProgram(screenProgramId);
                }
            }
        }
        shadersInitialized = false;
        programId = -1;
    }
    void deinitMSAAFramebuffer()
    {
        if (!framebufferInitialized) return;
        if (auddr != null)
        {
            // do gl deinit "globally" in support!
            if (auddr.getGL() != null)
            {
                GL2 gl2 = auddr.getGL().getGL2();
                if (fboMSAATextureObject.get(0) != 0) gl2.glDeleteTextures(1, fboMSAATextureObject);
                if (fboMSAABufferObject.get(0) != 0) gl2.glDeleteFramebuffers(1, fboMSAABufferObject);

                fboMSAABufferObject.put(0,0);
                fboMSAATextureObject.put(0,0);
            }
        }
        framebufferInitialized = false;
        
    }  
    void deinitFramebuffer()
    {
        if (auddr != null)
        {
            // do gl deinit "globally" in support!
            if (auddr.getGL() != null)
            {
                GL2 gl2 = auddr.getGL().getGL2();
                if (lineFBO[0].texture.get(0) != 0) gl2.glDeleteTextures(1, lineFBO[0].texture);
                if (lineFBO[0].fbo.get(0) != 0) gl2.glDeleteFramebuffers(1, lineFBO[0].fbo);
                if (lineFBO[1].texture.get(0) != 0) gl2.glDeleteTextures(1, lineFBO[1].texture);
                if (lineFBO[1].fbo.get(0) != 0) gl2.glDeleteFramebuffers(1, lineFBO[1].fbo);
                if (lineFBO[2].texture.get(0) != 0) gl2.glDeleteTextures(1, lineFBO[2].texture);
                if (lineFBO[2].fbo.get(0) != 0) gl2.glDeleteFramebuffers(1, lineFBO[2].fbo);
                if (lineFBO[3].texture.get(0) != 0) gl2.glDeleteTextures(1, lineFBO[3].texture);
                if (lineFBO[3].fbo.get(0) != 0) gl2.glDeleteFramebuffers(1, lineFBO[3].fbo);
                if (lineFBO[4].texture.get(0) != 0) gl2.glDeleteTextures(1, lineFBO[4].texture);
                if (lineFBO[4].fbo.get(0) != 0) gl2.glDeleteFramebuffers(1, lineFBO[4].fbo);
                if (lineFBO[5].texture.get(0) != 0) gl2.glDeleteTextures(1, lineFBO[5].texture);
                if (lineFBO[5].fbo.get(0) != 0) gl2.glDeleteFramebuffers(1, lineFBO[5].fbo);

                if (borderFBO[0].texture.get(0) != 0) gl2.glDeleteTextures(1, borderFBO[0].texture);
                if (borderFBO[0].fbo.get(0) != 0) gl2.glDeleteFramebuffers(1, borderFBO[0].fbo);
                if (borderFBO[1].texture.get(0) != 0) gl2.glDeleteTextures(1, borderFBO[1].texture);
                if (borderFBO[1].fbo.get(0) != 0) gl2.glDeleteFramebuffers(1, borderFBO[1].fbo);
                if (borderFBO[2].texture.get(0) != 0) gl2.glDeleteTextures(1, borderFBO[2].texture);
                if (borderFBO[2].fbo.get(0) != 0) gl2.glDeleteFramebuffers(1, borderFBO[2].fbo);
                if (borderFBO[3].texture.get(0) != 0) gl2.glDeleteTextures(1, borderFBO[3].texture);
                if (borderFBO[3].fbo.get(0) != 0) gl2.glDeleteFramebuffers(1, borderFBO[3].fbo);
                
                
                lineFBO[0].texture.put(0,0);
                lineFBO[0].fbo.put(0,0);
                lineFBO[1].texture.put(0,0);
                lineFBO[1].fbo.put(0,0);
                lineFBO[2].texture.put(0,0);
                lineFBO[2].fbo.put(0,0);
                lineFBO[3].texture.put(0,0);
                lineFBO[3].fbo.put(0,0);
                lineFBO[4].texture.put(0,0);
                lineFBO[4].fbo.put(0,0);
                lineFBO[5].texture.put(0,0);
                lineFBO[5].fbo.put(0,0);

                borderFBO[0].texture.put(0,0);
                borderFBO[0].fbo.put(0,0);
                borderFBO[1].texture.put(0,0);
                borderFBO[1].fbo.put(0,0);
                borderFBO[2].texture.put(0,0);
                borderFBO[2].fbo.put(0,0);
                borderFBO[3].texture.put(0,0);
                borderFBO[3].fbo.put(0,0);
            }
        }
    }  
    boolean initShader(GL2 gl2, String vertexShaderFile, String fragmentShaderFile)
    {
        try
        {
            deinitShaders();
            
            // order of GL hardware pipeline execution
            // first vertex
            // second fragment
            //
            // load source code to each "program" we want to use in gl implementation
            String vertexShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(vertexShaderFile)));
            String fragmentShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(fragmentShaderFile)));

            // both sources are "linked" as ONE execution program
            // run in two pipeline "sections"
            programId = gl2.glCreateProgram();
            
            // compile the vertex shader
            vertexShaderId = JOGLSupport.createShader(gl2, programId, vertexShaderCode, GL2.GL_VERTEX_SHADER);
            // compile the fragment shader
            fragmentShaderId = JOGLSupport.createShader(gl2, programId, fragmentShaderCode, GL2.GL_FRAGMENT_SHADER);
            // link both of the "objects" to one "executable" (so to say)
            JOGLSupport.link(gl2, programId);  
            
            // vertex shader uses two attributes, that are supplied 
            // by "us"
            // the linker choses the "placement" of the attributes
            // so here we get the attributes from the "linker" and we remember them for later useage
            positionAttribute = gl2.glGetAttribLocation(programId, "inPosition");
            colorAttribute = gl2.glGetAttribLocation(programId, "inColor");        
            
            if (!JOGLSupport.checkError(gl2,"initShader()"))
            {
                //System.out.println("JOGL ERROR");
                return false;
            }


            // order of GL hardware pipeline execution
            // first vertex
            // second fragment
            //
            // load source code to each "program" we want to use in gl implementation
            String persitencyVertexShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/blurShader.vs")));
            String persitencyFragmentShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/persitencyShader.fs")));
            
            
            // both sources are "linked" as ONE execution program
            // run in two pipeline "sections"
            persitencyProgramId = gl2.glCreateProgram();
            
            // compile the vertex shader
            persitencyVertexShaderId = JOGLSupport.createShader(gl2, persitencyProgramId, persitencyVertexShaderCode, GL2.GL_VERTEX_SHADER);
            // compile the fragment shader
            persitencyFragmentShaderId = JOGLSupport.createShader(gl2, persitencyProgramId, persitencyFragmentShaderCode, GL2.GL_FRAGMENT_SHADER);
            // link both of the "objects" to one "executable" (so to say)
            JOGLSupport.link(gl2, persitencyProgramId);  
            
            
            
            // order of GL hardware pipeline execution
            // first vertex
            // second fragment
            //
            // load source code to each "program" we want to use in gl implementation
            String thresholdVertexShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/blurShader.vs")));
            String thresholdFragmentShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/thresholdShader.fs")));
            
            
            thresholdProgramId = gl2.glCreateProgram();
            // compile the vertex shader
            thresholdVertexShaderId = JOGLSupport.createShader(gl2, thresholdProgramId, thresholdVertexShaderCode, GL2.GL_VERTEX_SHADER);
            // compile the fragment shader
            thresholdFragmentShaderId = JOGLSupport.createShader(gl2, thresholdProgramId, thresholdFragmentShaderCode, GL2.GL_FRAGMENT_SHADER);
            // link both of the "objects" to one "executable" (so to say)
            JOGLSupport.link(gl2, thresholdProgramId);  
            
            String spillVertexShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/blurShader.vs")));
            String spillFragmentShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/spillShader.fs")));
            spillProgramId = gl2.glCreateProgram();
            // compile the vertex shader
            spillVertexShaderId = JOGLSupport.createShader(gl2, spillProgramId, spillVertexShaderCode, GL2.GL_VERTEX_SHADER);
            // compile the fragment shader
            spillFragmentShaderId = JOGLSupport.createShader(gl2, spillProgramId, spillFragmentShaderCode, GL2.GL_FRAGMENT_SHADER);
            // link both of the "objects" to one "executable" (so to say)
            JOGLSupport.link(gl2, spillProgramId);  

            String spillFinalVertexShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/blurShader.vs")));
            String spillFinalFragmentShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/spillFinalShader.fs")));
            spillFinalProgramId = gl2.glCreateProgram();
            // compile the vertex shader
            spillFinalVertexShaderId = JOGLSupport.createShader(gl2, spillFinalProgramId, spillFinalVertexShaderCode, GL2.GL_VERTEX_SHADER);
            // compile the fragment shader
            spillFinalFragmentShaderId = JOGLSupport.createShader(gl2, spillFinalProgramId, spillFinalFragmentShaderCode, GL2.GL_FRAGMENT_SHADER);
            // link both of the "objects" to one "executable" (so to say)
            JOGLSupport.link(gl2, spillFinalProgramId);  

            String overlayVertexShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/blurShader.vs")));
            String overlayFragmentShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/overlayShader.fs")));
            overlayProgramId = gl2.glCreateProgram();
            // compile the vertex shader
            overlayVertexShaderId = JOGLSupport.createShader(gl2, overlayProgramId, overlayVertexShaderCode, GL2.GL_VERTEX_SHADER);
            // compile the fragment shader
            overlayFragmentShaderId = JOGLSupport.createShader(gl2, overlayProgramId, overlayFragmentShaderCode, GL2.GL_FRAGMENT_SHADER);
            // link both of the "objects" to one "executable" (so to say)
            JOGLSupport.link(gl2, overlayProgramId);  

            String screenVertexShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/blurShader.vs")));
            String screenFragmentShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/shaders/screenShader.fs")));
            screenProgramId = gl2.glCreateProgram();
            // compile the vertex shader
            screenVertexShaderId = JOGLSupport.createShader(gl2, screenProgramId, screenVertexShaderCode, GL2.GL_VERTEX_SHADER);
            // compile the fragment shader
            screenFragmentShaderId = JOGLSupport.createShader(gl2, screenProgramId, screenFragmentShaderCode, GL2.GL_FRAGMENT_SHADER);
            // link both of the "objects" to one "executable" (so to say)
            JOGLSupport.link(gl2, screenProgramId);  
        }
        
        catch (Throwable e)
        {
            e.printStackTrace();
            return false;
        }
        shadersInitialized = true;
        return true;
    }
    synchronized boolean initOverlay(GL2 gl2)
    {
        try
        {
            deinitOverlayTexture();
            
            if (!config.overlayEnabled) return true;         
            if (vpanel.getOverlayImageOrg() != null)
            {
                // old "GL" need to transfer pixels manually - see below                
                // this is only a shortcut to get the "overlayMustFlip"
                // the actual data with my Gl 2.1 is corrupt if loaded via TextureIO
                // therfor I load it manuall using the the ByteFormat parameters
                Texture overlayTexture = AWTTextureIO.newTexture(gl2.getGLProfile(), vpanel.getOverlayImageOrg(), false);
                overlayMustFlip = overlayTexture.getMustFlipVertically();
                overlayTexture.destroy(gl2);
                overlayTexture = null;
                      

                DataBufferByte ddb = ((DataBufferByte)vpanel.getOverlayImageOrg().getData().getDataBuffer());
                ByteBuffer overlayTexturePixelBuffer = ByteBuffer.wrap(ddb.getData());

                gl2.glGenTextures(1, overlayTextureObject);
                gl2.glBindTexture(GL2.GL_TEXTURE_2D, overlayTextureObject.get(0));
                gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
                gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
                gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, vpanel.getOverlayImageOrg().getWidth(), vpanel.getOverlayImageOrg().getHeight(), 0, GL2. GL_RGBA, GL2.GL_UNSIGNED_INT_8_8_8_8, overlayTexturePixelBuffer);
                
                gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
                
                if (!JOGLSupport.checkError(gl2,"initOverlay()"))
                {
                    //System.out.println("JOGL ERROR");
                    return false;
                }
                
                overlayInitialized = true;
            }
        }
        
        catch (Throwable e)
        {
            e.printStackTrace();
            return false;
        }
        return true;
    }
    synchronized boolean initChassis(GL2 gl2)
    {
        try
        {
            deinitChassisTexture();

            if (!config.JOGLScreen) return true;        

            String screenName = Global.mainPathPrefix+"theme/screen.png";
            BufferedImage screen = de.malban.util.UtilityImage.loadImage(screenName);
            if (screen==null)
            {
                log.addLog("Screen not found!");
                //System.out.println("Screen Image not found");
                config.CHASSIS_AVAILABLE = -1;
                return false;
            }
            
            // old "GL" need to transfer pixels manually - see below                
            // this is only a shortcut to get the "overlayMustFlip"
            // the actual data with my Gl 2.1 is corrupt if loaded via TextureIO
            // therfor I load it manuall using the the ByteFormat parameters
            Texture screenTexture = AWTTextureIO.newTexture(gl2.getGLProfile(), screen, false);
            screenMustFlip = screenTexture.getMustFlipVertically();
            screenTexture.destroy(gl2);
            screenTexture = null;


            DataBufferByte ddb = ((DataBufferByte)screen.getData().getDataBuffer());
            ByteBuffer screenTexturePixelBuffer = ByteBuffer.wrap(ddb.getData());

            gl2.glGenTextures(1, screenTextureObject);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, screenTextureObject.get(0));
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
            gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, screen.getWidth(), screen.getHeight(), 0, GL2. GL_RGBA, GL2.GL_UNSIGNED_INT_8_8_8_8, screenTexturePixelBuffer);

            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            if (!JOGLSupport.checkError(gl2,"initChassis()"))
            {
                //System.out.println("JOGL ERROR");
                return false;
            }

        }
        
        catch (Throwable e)
        {
            e.printStackTrace();
            return false;
        }
        if (config.CHASSIS_AVAILABLE!=1) return true;
        return true;
    }    
    synchronized boolean initMSAAFramebuffer(GL2 gl2)
    {
        try
        {
            if ((config.JOGLMSAA) && (JOGLSupport.getVersion()>=210))
            {
                deinitMSAAFramebuffer();

                /* OPEN GL 3.2 and higher */
                if (JOGLSupport.getVersion()>=320)
                {
                    // MSAA
                    // texture for FBO
                    gl2.glGenTextures(1, fboMSAATextureObject);
                    gl2.glBindTexture(GL2.GL_TEXTURE_2D_MULTISAMPLE, fboMSAATextureObject.get(0));
                    gl2.glTexImage2DMultisample(GL2.GL_TEXTURE_2D_MULTISAMPLE, config.JOGLmultiSample, GL2.GL_RGBA, gl2Width, gl2Height, false );
//                    gl2.glTexParameteri(GL2.GL_TEXTURE_2D_MULTISAMPLE, GL2.GL_TEXTURE_MIN_FILTER, GL2.GL_LINEAR);
//                    gl2.glTexParameteri(GL2.GL_TEXTURE_2D_MULTISAMPLE, GL2.GL_TEXTURE_MAG_FILTER, GL2.GL_LINEAR);

                    if (!JOGLSupport.checkError(gl2,"initMSAAFramebuffer():320"))
                    {
                        //System.out.println("JOGL ERROR");
                        return false;
                    }

//                    gl2.glTexParameteri(GL2.GL_TEXTURE_2D_MULTISAMPLE, GL2.GL_TEXTURE_BASE_LEVEL, 0);
//                    gl2.glTexParameteri(GL2.GL_TEXTURE_2D_MULTISAMPLE, GL2.GL_TEXTURE_MAX_LEVEL, 0);
                    gl2.glBindTexture(GL2.GL_TEXTURE_2D_MULTISAMPLE, 0);

                    gl2.glGenFramebuffers(1, fboMSAABufferObject);
                    gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, fboMSAABufferObject.get(0));

                    // attach the texture to FBO color attachment point
                    gl2.glFramebufferTexture2D(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_TEXTURE_2D_MULTISAMPLE, fboMSAATextureObject.get(0), 0); 


                    gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
                }
                else if (JOGLSupport.getVersion()>=210)
                {
                    /* OPEN GL 2.1 */
                    // MSAA
                    // texture for FBO
                    // multi sampled color buffer
                    gl2.glGenRenderbuffers(1, fboMSAATextureObject);
                    gl2.glBindRenderbuffer(GL2.GL_RENDERBUFFER, fboMSAATextureObject.get(0));
                    gl2.glRenderbufferStorageMultisample(GL2.GL_RENDERBUFFER, config.JOGLmultiSample, GL2.GL_RGBA, gl2Width, gl2Height);


                    if (!JOGLSupport.checkError(gl2,"initMSAAFramebuffer():210a"))
                    {
                        //System.out.println("a JOGL ERROR");
                        return false;
                    }
                    gl2.glBindRenderbuffer(GL2.GL_RENDERBUFFER, 0);

                    gl2.glGenFramebuffers(1, fboMSAABufferObject);
                    gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, fboMSAABufferObject.get(0));

                    // attach the texture to FBO color attachment point
                    gl2.glFramebufferRenderbuffer(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_RENDERBUFFER, fboMSAATextureObject.get(0)); 

                    gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);

                    if (!JOGLSupport.checkError(gl2,"initMSAAFramebuffer():210b"))
                    {
                        //System.out.println("a JOGL ERROR");
                        return false;
                    }
                    if(!JOGLSupport.checkFramebufferStatus(gl2, fboMSAABufferObject.get(0), "fboMSAABufferObject"))
                    {
                        //System.out.println("2. Framebuffer incomplete!");
                        return false;
                    }
                }
                framebufferInitialized = true;
            }
        }
        catch (Throwable e)
        {
            e.printStackTrace();
            return false;
        }
        return true;
    }
    synchronized boolean initFramebuffer(GL2 gl2)
    {
        try
        {
            deinitFramebuffer();
            
            // texture for FBO
            gl2.glGenTextures(1, lineFBO[0].texture);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[0].texture.get(0));
            gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, gl2Width, gl2Height, 0, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, null);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MIN_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAG_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, 0);
            
            gl2.glGenTextures(1, lineFBO[1].texture);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[1].texture.get(0));
            gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, gl2Width, gl2Height, 0, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, null);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MIN_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAG_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, 0);
            
            gl2.glGenTextures(1, lineFBO[2].texture);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[2].texture.get(0));
            gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, gl2Width, gl2Height, 0, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, null);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MIN_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAG_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, 0);
            
            gl2.glGenTextures(1, lineFBO[3].texture);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[3].texture.get(0));
            gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, gl2Width, gl2Height, 0, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, null);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MIN_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAG_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, 0);

            if (config.JOGLMIP_RESOLUTION>0)
            {
                int w = gl2Width/(1<<config.JOGLMIP_RESOLUTION);
                int h = gl2Height/(1<<config.JOGLMIP_RESOLUTION);
                
                gl2.glGenTextures(1, lineFBO[4].texture);
                gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[4].texture.get(0));
                gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, w, h, 0, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, null);
                gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MIN_FILTER, GL2.GL_LINEAR);
                gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAG_FILTER, GL2.GL_LINEAR);
                gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
                gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
                gl2.glBindTexture(GL2.GL_TEXTURE_2D, 0);
                
                gl2.glGenTextures(1, lineFBO[5].texture);
                gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[5].texture.get(0));
                gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, w, h, 0, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, null);
                gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MIN_FILTER, GL2.GL_LINEAR);
                gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAG_FILTER, GL2.GL_LINEAR);
                gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
                gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
                gl2.glBindTexture(GL2.GL_TEXTURE_2D, 0);
            }
            
            gl2.glGenTextures(1, borderFBO[0].texture);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, borderFBO[0].texture.get(0));
            gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, OVERFLOW_BORDER_RAYWIDTH, VecX.OVERFLOW_SAMPLE_MAX, 0, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, null);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MIN_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAG_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, 0);
            
            gl2.glGenTextures(1, borderFBO[1].texture);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, borderFBO[1].texture.get(0));
            gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, OVERFLOW_BORDER_RAYWIDTH, VecX.OVERFLOW_SAMPLE_MAX, 0, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, null);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MIN_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAG_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, 0);
            
            gl2.glGenTextures(1, borderFBO[2].texture);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, borderFBO[2].texture.get(0));
            gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, OVERFLOW_SAMPLE_MAX, OVERFLOW_BORDER_RAYWIDTH, 0, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, null);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MIN_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAG_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, 0);
            
            gl2.glGenTextures(1, borderFBO[3].texture);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, borderFBO[3].texture.get(0));
            gl2.glTexImage2D(GL2.GL_TEXTURE_2D, 0, GL2.GL_RGBA, OVERFLOW_SAMPLE_MAX, OVERFLOW_BORDER_RAYWIDTH, 0, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, null);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MIN_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAG_FILTER, GL2.GL_LINEAR);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_BASE_LEVEL, 0);
            gl2.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAX_LEVEL, 0);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, 0);

            
            
            if (!JOGLSupport.checkError(gl2, "initFramebuffer():1"))
            {
                //System.out.println("a JOGL ERROR");
                return false;
            }
            gl2.glBindRenderbuffer(GL2.GL_RENDERBUFFER, 0);

            gl2.glGenFramebuffers(1, lineFBO[0].fbo);
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
            gl2.glFramebufferTexture2D(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_TEXTURE_2D, lineFBO[0].texture.get(0), 0); 

            gl2.glGenFramebuffers(1, lineFBO[1].fbo);
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[1].fbo.get(0));
            gl2.glFramebufferTexture2D(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_TEXTURE_2D, lineFBO[1].texture.get(0), 0); 

            gl2.glGenFramebuffers(1, lineFBO[2].fbo);
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
            gl2.glFramebufferTexture2D(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_TEXTURE_2D, lineFBO[2].texture.get(0), 0); 

            gl2.glGenFramebuffers(1, lineFBO[3].fbo);
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[3].fbo.get(0));
            gl2.glFramebufferTexture2D(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_TEXTURE_2D, lineFBO[3].texture.get(0), 0); 

            
            
            if (config.JOGLMIP_RESOLUTION>0)
            {
                gl2.glGenFramebuffers(1, lineFBO[4].fbo);
                gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[4].fbo.get(0));
                gl2.glFramebufferTexture2D(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_TEXTURE_2D, lineFBO[4].texture.get(0), 0); 

                gl2.glGenFramebuffers(1, lineFBO[5].fbo);
                gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[5].fbo.get(0));
                gl2.glFramebufferTexture2D(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_TEXTURE_2D, lineFBO[5].texture.get(0), 0); 
            }
            
            gl2.glGenFramebuffers(1, borderFBO[0].fbo);
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, borderFBO[0].fbo.get(0));
            gl2.glFramebufferTexture2D(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_TEXTURE_2D, borderFBO[0].texture.get(0), 0); 

            gl2.glGenFramebuffers(1, borderFBO[1].fbo);
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, borderFBO[1].fbo.get(0));
            gl2.glFramebufferTexture2D(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_TEXTURE_2D, borderFBO[1].texture.get(0), 0); 

            gl2.glGenFramebuffers(1, borderFBO[2].fbo);
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, borderFBO[2].fbo.get(0));
            gl2.glFramebufferTexture2D(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_TEXTURE_2D, borderFBO[2].texture.get(0), 0); 

            gl2.glGenFramebuffers(1, borderFBO[3].fbo);
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, borderFBO[3].fbo.get(0));
            gl2.glFramebufferTexture2D(GL2.GL_FRAMEBUFFER, GL2.GL_COLOR_ATTACHMENT0, GL2.GL_TEXTURE_2D, borderFBO[3].texture.get(0), 0); 
            
            
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);

            if (!JOGLSupport.checkError(gl2, "initFramebuffer():2"))
            {
                //System.out.println("a JOGL ERROR");
                return false;
            }

            boolean ok = true; // ok
            ok &= JOGLSupport.checkFramebufferStatus(gl2, lineFBO[0].fbo.get(0), "lineFBO[0]");
            ok &= JOGLSupport.checkFramebufferStatus(gl2, lineFBO[1].fbo.get(0), "lineFBO[1]");
            ok &= JOGLSupport.checkFramebufferStatus(gl2, lineFBO[2].fbo.get(0), "lineFBO[2]");
            ok &= JOGLSupport.checkFramebufferStatus(gl2, lineFBO[3].fbo.get(0), "lineFBO[3]");
            if (config.JOGLMIP_RESOLUTION>0)
            {
                ok &= JOGLSupport.checkFramebufferStatus(gl2, lineFBO[4].fbo.get(0), "lineFBO[4]");
                ok &= JOGLSupport.checkFramebufferStatus(gl2, lineFBO[5].fbo.get(0), "lineFBO[5]");
            }
            ok &= JOGLSupport.checkFramebufferStatus(gl2, borderFBO[0].fbo.get(0), "borderFBO[0]");
            ok &= JOGLSupport.checkFramebufferStatus(gl2, borderFBO[1].fbo.get(0), "borderFBO[1]");
            ok &= JOGLSupport.checkFramebufferStatus(gl2, borderFBO[2].fbo.get(0), "borderFBO[2]");
            ok &= JOGLSupport.checkFramebufferStatus(gl2, borderFBO[3].fbo.get(0), "borderFBO[3]");
            
            if(!ok)
            {
                //System.out.println("3. Framebuffer incomplete!");
                return false;
            }
            // init persistency as clear
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[3].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        }
        catch (Throwable e)
        {
            e.printStackTrace();
            return false;
        }
        return true;
    }
    synchronized protected void setup(GLAutoDrawable glautodrawable, int width, int height ) 
    {
        vectrexVectors = new vector_t[2][MAX_RAY_VECTORS];
        for (int i=0;i<MAX_RAY_VECTORS; i++)
        {
            vectrexVectors[0][i] = new vector_t();
            vectrexVectors[1][i] = new vector_t();
        }
        currentRayAdd=0;
        currentRayDisplay=1;
        rayAddPos = 0;
        rayCount = 0;
        rayInit = true;

        
        gl2Width = width;
        gl2Height = height;
        scaleWidth = (float) (((double)gl2Width)/((double)config.ALG_MAX_X));
        scaleHeight = (float) (((double)gl2Height)/((double)config.ALG_MAX_Y));

        GL2 gl2 = glautodrawable.getGL().getGL2();
        JOGLSupport.dumpInfos(gl2);

        gl2.glDisable( GL2.GL_LINE_SMOOTH );
        gl2.glDisable( GL2.GL_POLYGON_SMOOTH );
        gl2.glDisable( GL2.GL_POINT_SMOOTH);
        gl2.glDisable(GL2.GL_MULTISAMPLE );
        
        gl2.glEnable(GL2.GL_TEXTURE_2D);
        gl2.glActiveTexture(GL2.GL_TEXTURE0 );
        
        initBuffers(gl2);
        
        if (!shadersInitialized)
            initShader(gl2, Global.mainPathPrefix+"theme/shaders/default.vs", Global.mainPathPrefix+"theme/shaders/default.fs");
        if (!blurShadersInitialized)
            initBlurShader(gl2, Global.mainPathPrefix+"theme/shaders/blurShader.vs", Global.mainPathPrefix+"theme/shaders/blurShader.fs");
        if (!overlayInitialized)
            initOverlay(gl2);
        initChassis(gl2);
        initFramebuffer(gl2);
        initMSAAFramebuffer(gl2);
        if (animator != null)
            animator.start(); // start the animation loop 
    }
    
    void deinitBuffers(GL2 gl2)
    {
        gl2.glDeleteBuffers(1, vertexBufferObject);
        gl2.glDeleteBuffers(1, lineBufferObject);
        deinitLineStrips(gl2);
        buffersInitialized = false;
    }
    
    void initBuffers(GL2 gl2)
    {
        if (buffersInitialized) return;
        // we "interleaved" the data that we will use
        // meaning, we but color and position information in one array
        // we could also have done that in two different arrays
        // but since we used only one -> we create only ONE VBO [Vertex buffer object]
        gl2.glGenBuffers(1, vertexBufferObject);
        
        // we "interleaved" the data that we will use
        // meaning, we but color and position information in one array
        // we could also have done that in two different arrays
        // but since we used only one -> we create only ONE VBO [Vertex buffer object]
        gl2.glGenBuffers(1, lineBufferObject);
        
        linesData = new float[MAXBUFFERSIZE_LINE*(2+2+3+3)];
        // buffer representation needed to access the JOGL routines
        linesDataBuffer = FloatBuffer.wrap(linesData);

        pointsData = new float[MAXBUFFERSIZE_POINT*(2+3)];
        // buffer representation needed to access the JOGL routines
        pointsDataBuffer = FloatBuffer.wrap(pointsData);
        
        initLineStrips(MAX_LINE_STRIPS, gl2);        
        
        buffersInitialized = true;
    }
    
    void addCatmullRom(ArrayList<Point> spline, int c, int s, int left, int right)
    {
        if (splineCount>=MAX_LINE_STRIPS) return;
        boolean isImager = vpanel.isImagerMode();
        float brightnessAdjustFactor = (100f+((float)config.brightness))/100f;
        synchronized (spline)
        {
            if (spline.size() == 2)
            {
                // draw a simple line
                float x0 = Scaler.scaleFloatToFloat(spline.get(0).x-config.ALG_MAX_X/2, scaleWidthGL);
                float y0 = Scaler.scaleFloatToFloat(-(spline.get(0).y-config.ALG_MAX_Y/2), scaleHeightGL);
                float x1 = Scaler.scaleFloatToFloat(spline.get(1).x-config.ALG_MAX_X/2, scaleWidthGL);
                float y1 = Scaler.scaleFloatToFloat(-(spline.get(1).y-config.ALG_MAX_Y/2), scaleHeightGL);
                


                // lines that are shorter than "lineWidth" (not exact) are declared points!
                if ((Math.abs((x0*gl2Width)-(x1*gl2Width)) < config.lineWidth) && (Math.abs((y0*gl2Height)-(y1*gl2Height)) < config.lineWidth))
                {

                    if (MAXBUFFERSIZE_POINT<pointCount-1)
                    {
                        MAXBUFFERSIZE_POINT = MAXBUFFERSIZE_POINT *2;
                        pointsData = new float[MAXBUFFERSIZE_POINT*(2+3)];
                        pointsDataBuffer = FloatBuffer.wrap(pointsData);
                    }

                    float bAdjust=brightnessAdjustFactor/COLOR_DIV;
                    Color drawColor = new Color(c,c,c,255);
                    if (isImager)
                    {
                        drawColor = vpanel.getColor(c, left, right, drawColor);
                    }

                    if (config.JOGLuseSpillShader) 
                        bAdjust = (float)(bAdjust/config.JOGLInitialSpillDivisor);

                    if (s >= 128) 
                    {
                        //int sp = vector.speed-128;
                        int dotDwell =(int) ((s-128)/config.JOGLDotDwellDivisor);
                        /*
                        do
                        {
                            // point
                            // coordinate 1
                            pointsData[pointCount++] =x0;
                            pointsData[pointCount++] =y0;

                            // color 1
                            pointsData[pointCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                            pointsData[pointCount++] =((float)drawColor.getGreen())*bAdjust;;
                            pointsData[pointCount++] =((float)drawColor.getBlue())*bAdjust;;
                        }
                        while (--dotDwell>0);
                        */
                        // point
                        // coordinate 1
                        pointsData[pointCount++] =x0;
                        pointsData[pointCount++] =y0;

                        // color 1
                        pointsData[pointCount++] =((float)drawColor.getRed())*bAdjust*dotDwell; // R G B
                        pointsData[pointCount++] =((float)drawColor.getGreen())*bAdjust*dotDwell;
                        pointsData[pointCount++] =((float)drawColor.getBlue())*bAdjust*dotDwell;
                    }
                    else
                    {
                        float speed = s;
                        float speedFactor = SPEED_FACTOR_MAX-config.JOGL_speedMaxReduce *(speed/127); //max slow down 0,5
                        bAdjust *= speedFactor;
                        // point
                        // coordinate 1
                        pointsData[pointCount++] =x0;
                        pointsData[pointCount++] =y0;

                        // color 1
                        pointsData[pointCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                        pointsData[pointCount++] =((float)drawColor.getGreen())*bAdjust;;
                        pointsData[pointCount++] =((float)drawColor.getBlue())*bAdjust;;
                    }

                }
                else
                {
                    float bAdjust=brightnessAdjustFactor/COLOR_DIV;
                    Color drawColor = new Color(c,c,c,255);
                    if (isImager)
                    {
                        drawColor = vpanel.getColor(c, left, right, drawColor);
                    }

                    if (config.JOGLuseSpillShader) 
                        bAdjust = (float)(bAdjust/config.JOGLInitialSpillDivisor);

                    float speed = s;
                    if (s >= 128) speed = 0f;

                    float speedFactor = SPEED_FACTOR_MAX-config.JOGL_speedMaxReduce *(speed/127); //max slow down 0,5
                    bAdjust *= speedFactor;

                    // line

                    // coordinate 1
                    linesData[lineCount++] =x0;
                    linesData[lineCount++] =y0;

                    // color 1
                    linesData[lineCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                    linesData[lineCount++] =((float)drawColor.getGreen())*bAdjust;;
                    linesData[lineCount++] =((float)drawColor.getBlue())*bAdjust;;

                    // coordinate 2
                    linesData[lineCount++] =x1;
                    linesData[lineCount++] =y1;

                    // color 2
                    linesData[lineCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                    linesData[lineCount++] =((float)drawColor.getGreen())*bAdjust;;
                    linesData[lineCount++] =((float)drawColor.getBlue())*bAdjust;;
                }
                return;
            }            
            
            float bAdjust=brightnessAdjustFactor/COLOR_DIV;
            Color drawColor = new Color(c,c,c,255);
            if (isImager)
            {
                drawColor = vpanel.getColor(c, left, right, drawColor);
            }

            if (config.JOGLuseSpillShader) 
                bAdjust = (float)(bAdjust/config.JOGLInitialSpillDivisor);

            // there can be "spline points"
            if (s >= 128) 
            {
                //int sp = vector.speed-128;

                for (int p = 0; p<spline.size(); p++)
                {
                    float dotDwell =(float) ((float)(s-128)/((float)config.JOGLDotDwellDivisor));
                    dotDwell = dotDwell/((float)spline.size());
//                    int dotDwell =(int) (((s-128)/config.JOGLDotDwellDivisor) / spline.size());
                    
                    float x0 = Scaler.scaleFloatToFloat(spline.get(p).x-config.ALG_MAX_X/2, scaleWidthGL);
                    float y0 = Scaler.scaleFloatToFloat(-(spline.get(p).y-config.ALG_MAX_Y/2), scaleHeightGL);
                    if (MAXBUFFERSIZE_POINT<pointCount-1)
                    {
                        MAXBUFFERSIZE_POINT = MAXBUFFERSIZE_POINT *2;
                        pointsData = new float[MAXBUFFERSIZE_POINT*(2+3)];
                        pointsDataBuffer = FloatBuffer.wrap(pointsData);
                    }
                    /*
                    do
                    {
                        // point
                        // coordinate 1
                        pointsData[pointCount++] =x0;
                        pointsData[pointCount++] =y0;

                        // color 1
                        pointsData[pointCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                        pointsData[pointCount++] =((float)drawColor.getGreen())*bAdjust;;
                        pointsData[pointCount++] =((float)drawColor.getBlue())*bAdjust;;
                    }
                    while (--dotDwell>0);
                    */
                    // point
                    // coordinate 1
                    pointsData[pointCount++] =x0;
                    pointsData[pointCount++] =y0;

                    // color 1
                    pointsData[pointCount++] =((float)drawColor.getRed())*bAdjust*dotDwell; // R G B
                    pointsData[pointCount++] =((float)drawColor.getGreen())*bAdjust*dotDwell;
                    pointsData[pointCount++] =((float)drawColor.getBlue())*bAdjust*dotDwell;
                }
                return;
            }
            float speed = s;
            if (s >= 128) speed = 0f;

            float speedFactor = SPEED_FACTOR_MAX-config.JOGL_speedMaxReduce *(speed/127); //max slow down 0,5
            bAdjust *= speedFactor;
            
            // if splines are to big different than there can be "loops"
            CardinalSpline cs = new CardinalSpline();
            Pt po= null;
            for (Point p: spline)
            {
                Pt pt = new Pt(p.x,p.y);

                if (po != null)
                {
                    double xDif = p.x-po.x;
                    double yDif = p.y-po.y;
                    double d = (int) Math.sqrt((xDif)*(xDif)+(yDif)*(yDif));
                    if (d>config.maxSplineSize)
                    {

                        double div = d/(config.maxSplineSize/2);
                        
                        for (int i=1;i<div;i++)
                        {
                            cs.addPoint(new Pt(po.x+i*(xDif/div),po.y+i*(yDif/div)));
                        }
                    }
                }
                po = pt;
                cs.addPoint(pt);
            }
            
            
            cs.caculate();
            ArrayList<Pt> pts = cs.getPoints();
            
            //ArrayList<Pt> pts = ParrabolicAproximation.getAproximation(spline);
            
         
            
            if (pts.size() == 0) return;

            LineStripBuffer lineStripBuffer = lineStrips[splineCount];
            if (pts.size()*(2+3)>=lineStripBuffer.lineStripData.length)
            {
                while (pts.size()*(2+3)>=MAXBUFFERSIZE_LINE_STRIP) MAXBUFFERSIZE_LINE_STRIP = MAXBUFFERSIZE_LINE_STRIP*2;
                lineStripBuffer.updateBuffer();
            }
            lineStripBuffer.lineCount = pts.size();
            splineCount++;
            
            for (int i=0;i<pts.size(); i++)
            {
                lineStripBuffer.lineStripData[lineStripBuffer.dataCount++] = Scaler.scaleFloatToFloat(pts.get(i).ix()-config.ALG_MAX_X/2, scaleWidthGL);
                lineStripBuffer.lineStripData[lineStripBuffer.dataCount++] = Scaler.scaleFloatToFloat(-(pts.get(i).iy()-config.ALG_MAX_Y/2), scaleHeightGL);

                // color 1
                lineStripBuffer.lineStripData[lineStripBuffer.dataCount++] = ((float)drawColor.getRed())*bAdjust; // R G B
                lineStripBuffer.lineStripData[lineStripBuffer.dataCount++] = ((float)drawColor.getGreen())*bAdjust;
                lineStripBuffer.lineStripData[lineStripBuffer.dataCount++] = ((float)drawColor.getBlue())*bAdjust;
            }
        }
    }

    ArrayList<Point> spline = new ArrayList();
    // color = 0 -127
    void prepareData()
    {
        boolean isImager = vpanel.isImagerMode();
        // count of floats
        // and place in the array
        lineCount = 0;
        pointCount = 0;
        resetSplines();
        spline.clear();
        
        
        float brightnessAdjustFactor = (100f+((float)config.brightness))/100f;

        VectrexDisplayVectors vList = vpanel.getDisplayList();
        
        vector_t[] list = vList.vectrexVectors;
        int count = vList.count;
        if (config.useRayGun)
        {
            list = vectrexVectors[currentRayDisplay];
            count = rayCount;
        }

        
        if (count == 0) return;

        if (MAXBUFFERSIZE_LINE<count+(config.vectorsAsArrows?2*count:0))
        {
            while (MAXBUFFERSIZE_LINE<count+(config.vectorsAsArrows?2*count:0))
                MAXBUFFERSIZE_LINE = MAXBUFFERSIZE_LINE *2;

            linesData = new float[MAXBUFFERSIZE_LINE*(2+2+3+3)];
            linesDataBuffer = FloatBuffer.wrap(linesData);
        }
        
        // 2 floats for coordinate 1
        // 3 floats for color 1
        // 2 floats for coordinate 2
        // 3 floats for color 2
        // = 10 floats 
        // this represents two "data packages"

        boolean inSpline = false;
        int splineColor=0;

        // now we prepare the data that we will send to the graphics hardware
        // data for our shaders are send in form of "vertex" data packages
        // one line consists of two vertex (startpoint and endpoint)
        // for now we also supply a color
        // since data is sent for the smallest possible packages (vertex) and you can't send "meta data"
        // each vertex also receives color data
        // https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glBufferData.xhtml
        // http://antongerdelan.net/opengl/vertexbuffers.html
        for (int v = 0; v < count; v++) 
        {
            VecXState.vector_t vector = list[v];

            //////////// SPLINE START
            if (config.useSplines)
            {
                synchronized(spline)
                {
                    if (!inSpline)
                    {
                        if (v != count-1)
                        {
                            if ((list[v+1].midChange) 
                                && (list[v].x1 == list[v+1].x0)
                                && (list[v].y1 == list[v+1].y0)
                                        )
                            {
                                // start Spline
                                spline.clear();
                                spline.add(new Point(list[v].x0,list[v].y0 ));
                                splineColor = (int)(list[v].color); 
                                inSpline = true;
                                continue;
                                
                            }
                        }
                    }
                    else
                    {
                        if ((list[v].midChange)
                                && (list[v-1].x1 == list[v].x0)
                                && (list[v-1].y1 == list[v].y0)
                                        )
                        {
                            // add point Spline
                            spline.add(new Point(list[v].x0,list[v].y0 ));
                            if (v == count-1) // is end of current vector list? Than we MUST draw even if spline is not finished
                            {
                                // start Spline
                                spline.add(new Point(list[v].x1,list[v].y1 ));
                                addCatmullRom(spline, splineColor, list[v].speed, list[v].imagerColorLeft, list[v].imagerColorRight);
                                inSpline = false;
                                continue;
                            }

                        }
                        else if ((list[v].midChange) && (( Math.abs(list[v-1].x1 - list[v].x0)<config.DRIFT_CURVE_THRESHOLD) &&  (Math.abs(list[v-1].y1 - list[v].y0)<config.DRIFT_CURVE_THRESHOLD)))
                        {
                            // add point Spline
                            spline.add(new Point(list[v-1].x1,list[v-1].y1 ));
                            if (v == count-1) // is end of current vector list? Than we MUST draw even if spline is not finished
                            {
                                // start Spline
                                spline.add(new Point(list[v].x1,list[v].y1 ));
                                addCatmullRom(spline, splineColor, list[v].speed, list[v].imagerColorLeft, list[v].imagerColorRight);
                                inSpline = false;
                                continue;
                            }

                        }
                        else
                        {
                            // 0 -> 1 von -1 und aktuell als line
                            spline.add(new Point(list[v-1].x1,list[v-1].y1 ));
                            
                            addCatmullRom(spline, splineColor, list[v-1].speed, list[v-1].imagerColorLeft, list[v-1].imagerColorRight);
                            inSpline = false;
                            // check if next vector is again the beginning of a spline
                            if (v != count-1)
                            {
                                if (list[v+1].midChange)
                                {
                                    // start Spline
                                    spline.clear();
                                    spline.add(new Point(list[v].x0,list[v].y0 ));
                                    splineColor = (int)(list[v].color); 
                                    inSpline = true;
                                    continue;

                                }
                            }
                        }
                    }
                }
            }
            if (inSpline) 
                continue;
            //////////// SPLINE END

            float x0 = Scaler.scaleFloatToFloat(vector.x0-config.ALG_MAX_X/2, scaleWidthGL);
            float y0 = Scaler.scaleFloatToFloat(-(vector.y0-config.ALG_MAX_Y/2), scaleHeightGL);
            float x1 = Scaler.scaleFloatToFloat(vector.x1-config.ALG_MAX_X/2, scaleWidthGL);
            float y1 = Scaler.scaleFloatToFloat(-(vector.y1-config.ALG_MAX_Y/2), scaleHeightGL);

            
            // lines that are shorter than "lineWidth" (not exact) are declared points!
            
            if ((Math.abs((x0*gl2Width)-(x1*gl2Width)) < config.lineWidth) && (Math.abs((y0*gl2Height)-(y1*gl2Height)) < config.lineWidth))
            {

                if (MAXBUFFERSIZE_POINT<pointCount-1)
                {
                    MAXBUFFERSIZE_POINT = MAXBUFFERSIZE_POINT *2;
                    pointsData = new float[MAXBUFFERSIZE_POINT*(2+3)];
                    pointsDataBuffer = FloatBuffer.wrap(pointsData);
                }

                float bAdjust=brightnessAdjustFactor/COLOR_DIV;
                Color drawColor = new Color(vector.color,vector.color,vector.color,255);
                if (isImager)
                {
                    drawColor = vpanel.getColor(vector.color, vector.imagerColorLeft, vector.imagerColorRight, drawColor);
                }

                if (config.JOGLuseSpillShader) 
                    bAdjust = (float)(bAdjust/config.JOGLInitialSpillDivisor);
                
                
                if (vector.speed >= 128) 
                {
                    //int sp = vector.speed-128;
                    float dotDwell =(float) ((float)(vector.speed-128)/((float)config.JOGLDotDwellDivisor));
                    /*
                    do
                    {
                        // point
                        // coordinate 1
                        pointsData[pointCount++] =x0;
                        pointsData[pointCount++] =y0;

                        // color 1
                        pointsData[pointCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                        pointsData[pointCount++] =((float)drawColor.getGreen())*bAdjust;;
                        pointsData[pointCount++] =((float)drawColor.getBlue())*bAdjust;;
                    }
                    while (--dotDwell>0);
                    */
                    // point
                    // coordinate 1
                    pointsData[pointCount++] =x0;
                    pointsData[pointCount++] =y0;

                    // color 1
                    pointsData[pointCount++] =((float)drawColor.getRed())*bAdjust*dotDwell; // R G B
                    pointsData[pointCount++] =((float)drawColor.getGreen())*bAdjust*dotDwell;
                    pointsData[pointCount++] =((float)drawColor.getBlue())*bAdjust*dotDwell;
                }
                else
                {
                    float speed = vector.speed;
                    float speedFactor = SPEED_FACTOR_MAX-config.JOGL_speedMaxReduce *(speed/127); //max slow down 0,5
                    bAdjust *= speedFactor;
                    // point
                    // coordinate 1
                    pointsData[pointCount++] =Scaler.scaleFloatToFloat(vector.x0-config.ALG_MAX_X/2, scaleWidthGL);
                    pointsData[pointCount++] =Scaler.scaleFloatToFloat(-(vector.y0-config.ALG_MAX_Y/2), scaleHeightGL);

                    // color 1
                    pointsData[pointCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                    pointsData[pointCount++] =((float)drawColor.getGreen())*bAdjust;;
                    pointsData[pointCount++] =((float)drawColor.getBlue())*bAdjust;;
                }
                
            }
            else
            {
                float bAdjust=brightnessAdjustFactor/COLOR_DIV;
                Color drawColor = new Color(vector.color,vector.color,vector.color,255);
                if (isImager)
                {
                    drawColor = vpanel.getColor(vector.color, vector.imagerColorLeft, vector.imagerColorRight, drawColor);
                }

                if (config.JOGLuseSpillShader) 
                    bAdjust = (float)(bAdjust/config.JOGLInitialSpillDivisor);
                
                float speed = vector.speed;
                if (vector.speed >= 128) speed = 0f;
                
                float speedFactor = SPEED_FACTOR_MAX-config.JOGL_speedMaxReduce *(speed/127); //max slow down 0,5
                bAdjust *= speedFactor;

                // line
                // coordinate 1
                linesData[lineCount++] =Scaler.scaleFloatToFloat(vector.x0-config.ALG_MAX_X/2, scaleWidthGL);
                linesData[lineCount++] =Scaler.scaleFloatToFloat(-(vector.y0-config.ALG_MAX_Y/2), scaleHeightGL);

                // color 1
                linesData[lineCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                linesData[lineCount++] =((float)drawColor.getGreen())*bAdjust;
                linesData[lineCount++] =((float)drawColor.getBlue())*bAdjust;

                // coordinate 2
                linesData[lineCount++] =Scaler.scaleFloatToFloat(vector.x1-config.ALG_MAX_X/2, scaleWidthGL);
                linesData[lineCount++] =Scaler.scaleFloatToFloat(-(vector.y1-config.ALG_MAX_Y/2), scaleHeightGL);

                // color 2
                linesData[lineCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                linesData[lineCount++] =((float)drawColor.getGreen())*bAdjust;
                linesData[lineCount++] =((float)drawColor.getBlue())*bAdjust;                
                if (config.vectorsAsArrows)
                {

                    float dx = vector.x1 - vector.x0, dy = vector.y1 - vector.y0;
                    float angle = (float)Math.atan2(dy, dx);
                    int len = (int) Math.sqrt(dx*dx + dy*dy);
                    int arrowHeadBoxSize = 200; // size in vectrex coordinates, roughly 40000x40000
                    float unitDx = dx / len;
                    float unitDy=dy/len;
                    float arrowX1 = vector.x1 - (unitDx*arrowHeadBoxSize)- (unitDy * arrowHeadBoxSize);
                    float arrowY1 = vector.y1 - (unitDy*arrowHeadBoxSize)+ (unitDx * arrowHeadBoxSize);
                    float arrowX2 = vector.x1 - (unitDx*arrowHeadBoxSize)+ (unitDy * arrowHeadBoxSize);
                    float arrowY2 = vector.y1 - (unitDy*arrowHeadBoxSize)- (unitDx * arrowHeadBoxSize);
        

                    
                    // line arrow 1
                    // coordinate 1
                    linesData[lineCount++] =Scaler.scaleFloatToFloat(vector.x1-config.ALG_MAX_X/2, scaleWidthGL);
                    linesData[lineCount++] =Scaler.scaleFloatToFloat(-(vector.y1-config.ALG_MAX_Y/2), scaleHeightGL);

                    // color 1
                    linesData[lineCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                    linesData[lineCount++] =((float)drawColor.getGreen())*bAdjust;
                    linesData[lineCount++] =((float)drawColor.getBlue())*bAdjust;

                    // coordinate 2
                    linesData[lineCount++] =Scaler.scaleFloatToFloat(arrowX1-config.ALG_MAX_X/2, scaleWidthGL);
                    linesData[lineCount++] =Scaler.scaleFloatToFloat(-(arrowY1-config.ALG_MAX_Y/2), scaleHeightGL);

                    // color 2
                    linesData[lineCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                    linesData[lineCount++] =((float)drawColor.getGreen())*bAdjust;
                    linesData[lineCount++] =((float)drawColor.getBlue())*bAdjust;                

                    // line arrow 2
                    // coordinate 1
                    linesData[lineCount++] =Scaler.scaleFloatToFloat(vector.x1-config.ALG_MAX_X/2, scaleWidthGL);
                    linesData[lineCount++] =Scaler.scaleFloatToFloat(-(vector.y1-config.ALG_MAX_Y/2), scaleHeightGL);

                    // color 1
                    linesData[lineCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                    linesData[lineCount++] =((float)drawColor.getGreen())*bAdjust;
                    linesData[lineCount++] =((float)drawColor.getBlue())*bAdjust;

                    // coordinate 2
                    linesData[lineCount++] =Scaler.scaleFloatToFloat(arrowX2-config.ALG_MAX_X/2, scaleWidthGL);
                    linesData[lineCount++] =Scaler.scaleFloatToFloat(-(arrowY2-config.ALG_MAX_Y/2), scaleHeightGL);

                    // color 2
                    linesData[lineCount++] =((float)drawColor.getRed())*bAdjust; // R G B
                    linesData[lineCount++] =((float)drawColor.getGreen())*bAdjust;
                    linesData[lineCount++] =((float)drawColor.getBlue())*bAdjust;                
                }

            }
        }        
    }
    
    
    private void renderLineStrips(GL2 gl2)
    {
        if (splineCount == 0) return;
        
        // the one vbo we created we bind to the state machine
        // and set its usage to be of an array buffer
 
        // enable our "compiled" shader (objects) to be used by the graphics cards hardware pipeline
        gl2.glUseProgram(programId);
        for (int i=0; i<splineCount; i++)
        {
            gl2.glBindBuffer(GL2.GL_ARRAY_BUFFER, lineStrips[i].lineStripBufferObject.get(0));

            // the data that we "generated" above will function as source for the vbo
            // the buffer that is currently "bound" will get its data from the FloatBuffer, that in term is filled
            // by our vertex data we set up in above "line" loop (alongside with the interleaved colors)
            // usage is still as an ARRAY, and the "optimal" type of usage is that of "STATIC_DRAW"
            gl2.glBufferData(GL2.GL_ARRAY_BUFFER, lineStrips[i].dataCount*Float.BYTES, lineStrips[i].lineStripDataBuffer, GL2.GL_STATIC_DRAW);        


            // since we only use one VBO
            // we need not use VAOs (Vertex Array Objects), 
            // otherwise if we had not interleaved our color/position information
            // the two seperate VBOs we created would have to be put in VertexArrayObjects and 
            // the Array object would have to be bound to the state machine also.
            //
            // this we can skip and set up the one and only VBO that we actually want to use

            // the Buffer is already bound to the VBO (see above)
            // now we enable the two attributes in the current (vertex) shader
            // both attributes represent the data that we supply to the GL
            // (in the array, a vertex and a color)
            //
            // to enable we have to pass the attribute location (that were given by the linker)
            gl2.glEnableVertexAttribArray(positionAttribute);
            gl2.glEnableVertexAttribArray(colorAttribute);
            //
            // now we have to tell the state machine where in our array the
            // above defined attributes are found
            // position:
            // is one of the coordinates of a line
            // has two float vars
            // is not normalized
            // and to get to the next "position"-data one has to add (2+3)*floatSize bytes (stride)
            // original data offset is 0
            gl2.glVertexAttribPointer(positionAttribute, 2, GL.GL_FLOAT, false, (2+3)*Float.BYTES, 0);
            //
            // now we have to tell the state machine where in our array the
            // above defined attributes are found
            // color:
            // has three float vars
            // is not normalized
            // and to get to the next "color"-data one has to add (2+3)*floatSize bytes (stride)
            // original data offset is 2 "coordinates" away from start (== 2* Float size bytes)
            gl2.glVertexAttribPointer(colorAttribute, 3, GL.GL_FLOAT, false, (2+3)*Float.BYTES, 2*Float.BYTES);//4);

            // the "current" (bound) array of data is that of our one and only VBO
//            gl2.glBindVertexArray(lineStrips[i].lineStripBufferObject.get(0));

            // draw all data that the buffer consists of
            // times two, because each line has two vertex
            // linecount is count of FLOATS for one line
            // 2*2*3*3 is the amount the lines (inclusive 2 colors) floats
            gl2.glDrawArrays(GL.GL_LINE_STRIP, 0, lineStrips[i].lineCount );//*Float.BYTES);
        }

        // cleanup
        gl2.glDisableVertexAttribArray(positionAttribute);
        gl2.glDisableVertexAttribArray(colorAttribute);

        // disable our "compiled" shader (objects) to be used by the graphics cards hardware pipeline
        gl2.glUseProgram(0);        
    }                
                
    private void renderPoints(GL2 gl2)
    {
        if (pointCount == 0) return;

        // the one vbo we created we bind to the state machine
        // and set its usage to be of an array buffer
        gl2.glBindBuffer(GL2.GL_ARRAY_BUFFER, vertexBufferObject.get(0));

        // the data that we "generated" above will function as source for the vbo
        // the buffer that is currently "bound" will get its data from the FloatBuffer, that in term is filled
        // by our vertex data we set up in above "line" loop (alongside with the interleaved colors)
        // usage is still as an ARRAY, and the "optimal" type of usage is that of "STATIC_DRAW"
        gl2.glBufferData(GL2.GL_ARRAY_BUFFER, pointCount*Float.BYTES, pointsDataBuffer, GL2.GL_STATIC_DRAW);        

        // enable our "compiled" shader (objects) to be used by the graphics cards hardware pipeline
        gl2.glUseProgram(programId);

        // since we only use one VBO
        // we need not use VAOs (Vertex Array Objects), 
        // otherwise if we had not interleaved our color/position information
        // the two seperate VBOs we created would have to be put in VertexArrayObjects and 
        // the Array object would have to be bound to the state machine also.
        //
        // this we can skip and set up the one and only VBO that we actually want to use

        // the Buffer is already bound to the VBO (see above)
        // now we enable the two attributes in the current (vertex) shader
        // both attributes represent the data that we supply to the GL
        // (in the array, a vertex and a color)
        //
        // to enable we have to pass the attribute location (that were given by the linker)
        gl2.glEnableVertexAttribArray(positionAttribute);
        gl2.glEnableVertexAttribArray(colorAttribute);
        //
        // no we have to tell the state machine where in our array the
        // above defined attributes are found
        // position:
        // is one of the coordinates of a line
        // has two float vars
        // is not normalized
        // and to get to the next "position"-data one has to add (2+3)*floatSize bytes (stride)
        // original data offset is 0
        gl2.glVertexAttribPointer(positionAttribute, 2, GL.GL_FLOAT, false, (2+3)*Float.BYTES, 0);
        //
        // no we have to tell the state machine where in our array the
        // above defined attributes are found
        // color:
        // has three float vars
        // is not normalized
        // and to get to the next "color"-data one has to add (2+3)*floatSize bytes (stride)
        // original data offset is 2 "coordinates" away from start (== 2* Float size bytes)
        gl2.glVertexAttribPointer(colorAttribute, 3, GL.GL_FLOAT, false, (2+3)*Float.BYTES, 2*Float.BYTES);//4);

        // the "current" (bound) array of data is that of our one and only VBO
//        gl2.glBindVertexArray(vertexBufferObject.get(0));
        // draw all data that the buffer consists of
        gl2.glDrawArrays(GL.GL_POINTS, 0, pointCount/(2+3));

        // cleanup
        gl2.glDisableVertexAttribArray(positionAttribute);
        gl2.glDisableVertexAttribArray(colorAttribute);

        // disable our "compiled" shader (objects) to be used by the graphics cards hardware pipeline
        gl2.glUseProgram(0);        
    }
    private void renderLines(GL2 gl2)
    {
        if (lineCount == 0) return;
        
        // the one vbo we created we bind to the state machine
        // and set its usage to be of an array buffer
 
        gl2.glBindBuffer(GL2.GL_ARRAY_BUFFER, lineBufferObject.get(0));

        // the data that we "generated" above will function as source for the vbo
        // the buffer that is currently "bound" will get its data from the FloatBuffer, that in term is filled
        // by our vertex data we set up in above "line" loop (alongside with the interleaved colors)
        // usage is still as an ARRAY, and the "optimal" type of usage is that of "STATIC_DRAW"
        gl2.glBufferData(GL2.GL_ARRAY_BUFFER, lineCount*Float.BYTES, linesDataBuffer, GL2.GL_STATIC_DRAW);        

        // enable our "compiled" shader (objects) to be used by the graphics cards hardware pipeline
        gl2.glUseProgram(programId);

        // since we only use one VBO
        // we need not use VAOs (Vertex Array Objects), 
        // otherwise if we had not interleaved our color/position information
        // the two seperate VBOs we created would have to be put in VertexArrayObjects and 
        // the Array object would have to be bound to the state machine also.
        //
        // this we can skip and set up the one and only VBO that we actually want to use

        // the Buffer is already bound to the VBO (see above)
        // now we enable the two attributes in the current (vertex) shader
        // both attributes represent the data that we supply to the GL
        // (in the array, a vertex and a color)
        //
        // to enable we have to pass the attribute location (that were given by the linker)
        gl2.glEnableVertexAttribArray(positionAttribute);
        gl2.glEnableVertexAttribArray(colorAttribute);
        //
        // no we have to tell the state machine where in our array the
        // above defined attributes are found
        // position:
        // is one of the coordinates of a line
        // has two float vars
        // is not normalized
        // and to get to the next "position"-data one has to add (2+3)*floatSize bytes (stride)
        // original data offset is 0
        gl2.glVertexAttribPointer(positionAttribute, 2, GL.GL_FLOAT, false, (2+3)*Float.BYTES, 0);
        //
        // no we have to tell the state machine where in our array the
        // above defined attributes are found
        // color:
        // has three float vars
        // is not normalized
        // and to get to the next "color"-data one has to add (2+3)*floatSize bytes (stride)
        // original data offset is 2 "coordinates" away from start (== 2* Float size bytes)
        gl2.glVertexAttribPointer(colorAttribute, 3, GL.GL_FLOAT, false, (2+3)*Float.BYTES, 2*Float.BYTES);//4);

        // the "current" (bound) array of data is that of our one and only VBO
//        gl2.glBindVertexArray(lineBufferObject.get(0));
        // draw all data that the buffer consists of
        // times two, because each line has two vertex
        // linecount is count of FLOATS for one line
        // 2*2*3*3 is the amount the lines (inclusive 2 colors) floats
        gl2.glDrawArrays(GL.GL_LINES, 0, 2*(lineCount/(2+2+3+3)) );

        // cleanup
        gl2.glDisableVertexAttribArray(positionAttribute);
        gl2.glDisableVertexAttribArray(colorAttribute);

        // disable our "compiled" shader (objects) to be used by the graphics cards hardware pipeline
        gl2.glUseProgram(0);        
    }

    // renders overlay "over" FBO0
    // result is also in FBO0
    private void renderOverlay(GL2 gl2)
    {
        if ((config.overlayEnabled) && (!overlayInitialized))    
        {
            initOverlay(gl2);
            if (!overlayInitialized) return;
        }
        else
        {
            if (!config.overlayEnabled) 
            {
                if (overlayInitialized) 
                    deinitOverlayTexture();
                return;
            }
        }

        gl2.glEnable(GL2.GL_BLEND);            
        gl2.glBlendFunc(GL2.GL_SRC_ALPHA, GL2.GL_ONE_MINUS_SRC_ALPHA);
        
        gl2.glLoadIdentity();
        gl2.glEnable(GL2.GL_TEXTURE_2D);

        gl2.glActiveTexture(GL2.GL_TEXTURE1 );
        gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[0].texture.get(0));

        if (config.JOGLOverlayAdjustment)
        {
            gl2.glUseProgram(overlayProgramId);
            gl2.glActiveTexture(GL.GL_TEXTURE0);

            int i = gl2.glGetUniformLocation(overlayProgramId, "overlayTexture");
            gl2.glUniform1i(i, 0);

            i = gl2.glGetUniformLocation(overlayProgramId, "destinationTexture");
            gl2.glUniform1i(i, 1);

            i = gl2.glGetUniformLocation(overlayProgramId, "alphaThreshold");
            gl2.glUniform1f(i, (float) config.JOGLOverlayAlphaThreshold); // needed for sub pixel opaque lines, which are rendered to "half" transparent

            i = gl2.glGetUniformLocation(overlayProgramId, "overlayAlphaAdjust");
            gl2.glUniform1f(i, (float) config.JOGLOverlayAlphaAdjustmentFactor);

            i = gl2.glGetUniformLocation(overlayProgramId, "destinationAlphaAdjust");
            gl2.glUniform1f(i, (float) config.JOGLOverlayBrightnessAlphaAdjustmentFactor);
        }

        gl2.glActiveTexture(GL2.GL_TEXTURE0 );
        gl2.glBindTexture(GL2.GL_TEXTURE_2D, overlayTextureObject.get(0));


        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
        
        gl2.glBegin( GL2.GL_QUADS ); 

        float y1 = overlayMustFlip ? 1.0F : -1.0F;
        float y2 = 1.0F - y1;
        if (y1==1.0f) y2=-1.0f; else y2 =1.0f;


        gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
        gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
        gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
        gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
        gl2.glEnd();

        gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        gl2.glUseProgram(0);


        gl2.glBlendFunc(GL2.GL_SRC_ALPHA, GL2.GL_ONE);
        gl2.glDisable(GL2.GL_BLEND);            
    }
    private void setupRender(GL2 gl2)
    {
        //Initialize clear color 
        gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );

        // initialize line width
        gl2.glLineWidth(config.lineWidth);
        gl2.glPointSize(config.lineWidth);
        gl2.glDisable(GL2.GL_DEPTH_TEST);
        gl2.glEnable(GL.GL_TEXTURE_2D);        
        
        if (!config.JOGLMSAA)
        {
            if (config.antialiazing)
            {
                gl2.glEnable(GL2.GL_BLEND);
                gl2.glBlendFunc(GL2.GL_SRC_ALPHA, GL2.GL_ONE_MINUS_SRC_ALPHA);            

                gl2.glEnable(GL2.GL_POLYGON_SMOOTH);
                gl2.glHint(GL2.GL_POLYGON_SMOOTH_HINT, GL2.GL_NICEST);

                gl2.glEnable(GL2.GL_LINE_SMOOTH);
                gl2.glHint(GL2.GL_LINE_SMOOTH_HINT, GL2.GL_NICEST);
            }
            else
            {
                gl2.glDisable(GL2.GL_DITHER);
                gl2.glDisable(GL2.GL_BLEND);

                gl2.glHint(GL2.GL_POLYGON_SMOOTH_HINT, GL2.GL_FASTEST);
                gl2.glDisable(GL2.GL_POLYGON_SMOOTH);

                gl2.glHint(GL2.GL_LINE_SMOOTH_HINT, GL2.GL_FASTEST);
                gl2.glDisable(GL2.GL_LINE_SMOOTH);

                gl2.glHint(GL2.GL_POINT_SMOOTH_HINT, GL2.GL_FASTEST);
                gl2.glDisable(GL2.GL_POINT_SMOOTH);
            }
        }
        else
        {
            gl2.glDisable(GL2.GL_MULTISAMPLE);
            gl2.glDisable(GL2.GL_DITHER);
            gl2.glDisable(GL2.GL_BLEND);

            gl2.glHint(GL2.GL_POLYGON_SMOOTH_HINT, GL2.GL_FASTEST);
            gl2.glDisable(GL2.GL_POLYGON_SMOOTH);

            gl2.glHint(GL2.GL_LINE_SMOOTH_HINT, GL2.GL_FASTEST);
            gl2.glDisable(GL2.GL_LINE_SMOOTH);

            gl2.glHint(GL2.GL_POINT_SMOOTH_HINT, GL2.GL_FASTEST);
            gl2.glDisable(GL2.GL_POINT_SMOOTH);
        }
    }
    synchronized protected void render(GLAutoDrawable glautodrawable, int width, int height ) {
        if (vpanel.getVecXState() == null) return;
        //if (width != gl2Width) System.out.println("W: "+width +"!="+ gl2Width);
        //if (height != gl2Height) System.out.println("H: "+height +"!="+ gl2Height);
        
        GL2 gl2 = glautodrawable.getGL().getGL2();
        setupRender(gl2);

        // clear the GL "screen"
        gl2.glClear(GL2.GL_DEPTH_BUFFER_BIT | GL2.GL_COLOR_BUFFER_BIT);

        prepareData();
        preDataRender(gl2);
        renderPoints(gl2);
        renderLineStrips(gl2);
        renderLines(gl2);
        postDataRender(gl2);
  
        renderChassis(gl2);
        renderOverlay(gl2);
        
        renderDebug(gl2);
        {
            gl2.glPushMatrix();
            gl2.glRotatef(config.rotate, 0, 0, 1);
            
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
            // put the final result on screen
            // display single FBO on Quad            
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[0].texture.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            float y1 = -1.0F;
            float y2 = 1.0F;
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
            gl2.glPopMatrix();
        }
        
        
//        gl2.glFlush();
//        glautodrawable.swapBuffers();
        if (splineCount>=MAX_LINE_STRIPS)
        {
            while (splineCount>=MAX_LINE_STRIPS) MAX_LINE_STRIPS = MAX_LINE_STRIPS*2;
                initLineStrips(MAX_LINE_STRIPS, gl2);        
        }
    }
    
    // sets an active drawing context
    // either the "normal" FBO
    // or an MSAA FBO
    // if skipped - drawin will be done directly to screen (better skip postRender too)
    void preDataRender(GL2 gl2)
    {
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
        gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
        gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
        
        if (( ((config.JOGLMSAA) && (JOGLSupport.getVersion()>=210)) ) && (config.antialiazing))
        {
            gl2.glEnable(GL2.GL_MULTISAMPLE);
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, fboMSAABufferObject.get(0));

            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
            
            if (!JOGLSupport.checkError(gl2, "preDataRender()"))
            {
                //System.out.println("JOGL ERROR");
                return;
            }
        }
        
        gl2.glEnable(GL2.GL_BLEND);            
        gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);
    }
        
    // gets the active drawing area (some FBO, either a "normal" or a MSAA)
    // if MSAA, than the MSAA is drawn onto a non multisample FBO
    // the (resulting) "normal" FBO is painted to screen
    // using the texture of the FBO to draw onto a "panel" sized quad
    // leaves with current finished display in FBO0
    void postDataRender(GL2 gl2)
    {
        gl2.glDisable(GL2.GL_BLEND);            

        // if MSAA, than copy buffers to fbo[0]
        if (( ((config.JOGLMSAA) && (JOGLSupport.getVersion()>=210)) ) && (config.antialiazing))
        {
            gl2.glDisable(GL2.GL_MULTISAMPLE);
            
            gl2.glBindFramebuffer(GL2.GL_DRAW_FRAMEBUFFER, lineFBO[0].fbo.get(0));   // Make sure no FBO is set as the draw framebuffer
            gl2.glBindFramebuffer(GL2.GL_READ_FRAMEBUFFER, fboMSAABufferObject.get(0)); // Make sure your multisampled FBO is the read framebuffer
            gl2.glBlitFramebuffer(0, 0, gl2Width, gl2Height, 0, 0, gl2Width, gl2Height, GL2.GL_COLOR_BUFFER_BIT, GL2.GL_NEAREST);
            
            if (!JOGLSupport.checkError(gl2, "postDataRender(): 1"))
            {
                //System.out.println("JOGL ERROR");
                return ;
            }
        }
        gl2.glBindFramebuffer(GL2.GL_DRAW_FRAMEBUFFER, 0);   // Make sure no FBO is set as the draw framebuffer
        
        processSpill(gl2);

        // glo
        processGlow(gl2);
        if (config.emulateBorders)
        {
            processBorderGlow(gl2);
        }

        // process persistency
        if (config.persistenceAlpha!=255)
        {
            // copy last persistency texture "under" the current fbo
            gl2.glEnable(GL2.GL_BLEND);            
            gl2.glBlendEquation(GL2.GL_MAX);
            gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);

            gl2.glBindFramebuffer(GL2.GL_DRAW_FRAMEBUFFER, lineFBO[0].fbo.get(0));
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[3].texture.get(0));

            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, 1.0F ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );


            gl2.glBlendEquation(GL2.GL_FUNC_ADD);
            gl2.glDisable(GL2.GL_BLEND);            

            // copy result to persistency "next" (brightness reduced by 1/255 * persistencyAlpha)
            
            // this must be cleared first
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[3].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
        
            
            gl2.glActiveTexture(GL.GL_TEXTURE0);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[0].texture.get(0));
            
            gl2.glUseProgram(persitencyProgramId);

            int i = gl2.glGetUniformLocation(persitencyProgramId, "colorReduce");

            gl2.glUniform1f(i, ((float) (1.0f/255.0f) * (255-config.persistenceAlpha) ) );

            int uit = gl2.glGetUniformLocation(persitencyProgramId, "uTexture");
            gl2.glUniform1i(uit, 0);
            
            float y1 = -1.0F;
            float y2 = 1.0F;

            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
            gl2.glUseProgram(0);        
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        }



        if (!JOGLSupport.checkError(gl2, "postDataRender(): 2"))
        {
            //System.out.println("JOGL ERROR");
            return ;
        }
    }    

    synchronized private void paintVectrex()
    {
        repaint();
    }
    
    
    // already drawn lines/points are expected to be 
    // drawn to the texture of lineFBO[0].texture.get(0)
    // glow is using "repaints" of the above in several
    // passes to lineFBO[0] and lineFBO[1]
    // finally result is again in lineFBO[0].texture.get(0)
    void processGlow(GL2 gl2)
    {
        if (!config.JOGLuseGlowShader) return;
        if (config.JOGLaddBase) 
        {
            // save "basic" output to be added to final result
            // copy db[0] to fbo[2]
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
            
            gl2.glBindFramebuffer(GL2.GL_DRAW_FRAMEBUFFER, lineFBO[2].fbo.get(0));   
            gl2.glBindFramebuffer(GL2.GL_READ_FRAMEBUFFER, lineFBO[0].fbo.get(0));   
            gl2.glBlitFramebuffer(0, 0, gl2Width, gl2Height, 0, 0, gl2Width, gl2Height, GL2.GL_COLOR_BUFFER_BIT, GL2.GL_NEAREST);
            
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        }

        if (config.JOGLGlowThreshold!=0)
        {
            // build a object, that only contains colors > threshold
            gl2.glUseProgram(thresholdProgramId);
            

            //ensure the direction is along the X-axis only
            int i = gl2.glGetUniformLocation(thresholdProgramId, "threshold");
            gl2.glUniform1f(i, (float)config.JOGLGlowThreshold);

            gl2.glActiveTexture(GL.GL_TEXTURE0);
            i = gl2.glGetUniformLocation(blurProgramId, "uTexture");
            gl2.glUniform1i(i, 0);

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[1].fbo.get(0));
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[0].texture.get(0));
            float y1 = -1.0F;
            float y2 = 1.0F;

            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
            gl2.glUseProgram(0);

            if (!JOGLSupport.checkError(gl2, "processGlow(): 1"))
            {
                //System.out.println("JOGL ERROR");
                return;
            }
            // and back to 0 again
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[1].texture.get(0));

            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
        }

        
        if (config.JOGLadditiveBlur)
        {
            gl2.glEnable(GL2.GL_BLEND);            
            gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);
        }
        
        // reinit shaders if the parameters changed
        if (doDeinitBlurShaders)
        {
            initBlurShader(gl2, Global.mainPathPrefix+"theme/shaders/blurShader.vs", Global.mainPathPrefix+"theme/shaders/blurShader.fs");
            doDeinitBlurShaders = false;
        }
        if (config.JOGLMIP_RESOLUTION!=0)
        {
            doScaledBlur(gl2);
            return;
        }
        
        
        // first round we draw to FBO1
        // this must be cleared first
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[1].fbo.get(0));
        gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
        gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
        
        gl2.glActiveTexture(GL.GL_TEXTURE0);
        gl2.glUseProgram(blurProgramId);

        if (!JOGLSupport.checkError(gl2, "processGlow(): 2"))
        {
            //System.out.println("JOGL ERROR");
            return;
        }

        
        for (int bp=0; bp<config.JOGLblurPass; bp++)
        {
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[1].fbo.get(0));

            //ensure the direction is along the X-axis only
            int i = gl2.glGetUniformLocation(blurProgramId, "uShift");
            gl2.glUniform2f(i, 1.0f/((float)gl2Width), 0f);

            i = gl2.glGetUniformLocation(blurProgramId, "uTexture");
            gl2.glUniform1i(i, 0);

            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[0].texture.get(0));
            float y1 = -1.0F;
            float y2 = 1.0F;

            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            if (!JOGLSupport.checkError(gl2, "processGlow(): 3"))
            {
                //System.out.println("JOGL ERROR");
                return;
            }



            // now we draw to FBO0
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));

            i = gl2.glGetUniformLocation(blurProgramId, "uShift");
            gl2.glUniform2f(i, 0f, 1.0f/((float)gl2Height));

            i = gl2.glGetUniformLocation(blurProgramId, "uTexture");
            gl2.glUniform1i(i, 0);

            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[1].texture.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            y1 = -1.0F;
            y2 = 1.0F;
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        }

        if (!JOGLSupport.checkError(gl2, "processGlow(): 4"))
        {
            //System.out.println("JOGL ERROR");
            return;
        }

        // disable our "compiled" shader (objects) to be used by the graphics cards hardware pipeline
        gl2.glUseProgram(0);        



        if (config.JOGLaddBase) 
        {
            gl2.glEnable(GL2.GL_BLEND);            
            gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);

            // first round we draw to FBO1
            // this must be cleared first
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));

            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[2].texture.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, 1.0F ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        }

        gl2.glDisable(GL2.GL_BLEND);
    }
    
    void deinitBlurShaders()
    {
        if (auddr != null)
        {
            if (auddr.getGL() != null)
            {
                GL2 gl2 = auddr.getGL().getGL2();
                if (blurProgramId != -1)
                {
                    gl2.glDetachShader(blurProgramId, blurVertexShaderId);
                    gl2.glDetachShader(blurProgramId, blurFragmentShaderId);
                    gl2.glDeleteProgram(blurProgramId);
                }
            }
        }
        blurShadersInitialized = false;
        blurProgramId = -1;
    }
    
    boolean initBlurShader(GL2 gl2, String vertexShaderFile, String fragmentShaderFile)
    {
        try
        {
            deinitBlurShaders();
            
            // order of GL hardware pipeline execution
            // first vertex
            // second fragment
            //
            // load source code to each "program" we want to use in gl implementation
            String vertexShaderCode = de.malban.util.UtilityString.readTextFileToOneString(new File(de.malban.util.UtilityFiles.convertSeperator(vertexShaderFile)));
            String fragmentShaderCode_org = buildBlurFragmentShader_org(createGaussianKernel_org(config.JOGL_GAUSS_RADIUS, config.JOGL_SIGMA));

            String fragmentShaderCode = buildBlurFragmentShader_lin(createGaussianKernel_linWeight(config.JOGL_GAUSS_RADIUS, config.JOGL_SIGMA), createGaussianKernel_linOffset(config.JOGL_GAUSS_RADIUS, config.JOGL_SIGMA));
            
            if (!config.JOGLUseLinearSampling )            
                fragmentShaderCode = fragmentShaderCode_org;
//System.out.println(fragmentShaderCode);
            
            // both sources are "linked" as ONE execution program
            // run in two pipeline "sections"
            blurProgramId = gl2.glCreateProgram();
            
            // compile the vertex shader
            blurVertexShaderId = JOGLSupport.createShader(gl2, blurProgramId, vertexShaderCode, GL2.GL_VERTEX_SHADER);
            // compile the fragment shader
            blurFragmentShaderId = JOGLSupport.createShader(gl2, blurProgramId, fragmentShaderCode, GL2.GL_FRAGMENT_SHADER);
            // link both of the "objects" to one "executable" (so to say)
            JOGLSupport.link(gl2, blurProgramId);  
            
            // vertex shader uses attributes, that are supplied 
            // by "us"
            // the linker choses the "placement" of the attributes
            // so here we get the attributes from the "linker" and we remember them for later useage
            blurPositionAttribute = gl2.glGetAttribLocation(blurProgramId, "Position");
            blurColorAttribute = gl2.glGetAttribLocation(blurProgramId, "Color");        
            blurTextureAttribute = gl2.glGetAttribLocation(blurProgramId, "TexCoord");        
            
            if (!JOGLSupport.checkError(gl2, "initBlurShader()"))
            {
                //System.out.println("JOGL ERROR");
                return false;
            }

        }
        
        catch (Throwable e)
        {
            e.printStackTrace();
            return false;
        }
        blurShadersInitialized = true;
        return true;
    }
     
   // returns a float array of (steps*2)+1    
  public static final float[] createGaussianKernel_org(int steps, double sigma)
  {
        float[] kernel = new float[(steps*2)+1];

        double f1 = 1.0D / (Math.sqrt(2*Math.PI*sigma*sigma));
        for (int i = 0; i < steps+1; i++)
        {

            double x2 = i * i;
            double s2 = 2*sigma*sigma;
            double ex = -x2/s2;
            double f2 = Math.exp(ex);
            double result = f1*f2;
            kernel[steps-i] = ((float)(result));
            kernel[steps+i] = ((float)(result));
        }
        return kernel;
  }

  // kernal data is complete
  // better perfoamce can be reached with:
  static String buildBlurFragmentShader_org(float[] kernalData)
  {
      int steps = kernalData.length;
      StringBuilder b = new StringBuilder();
      b.append("#version 120").append("\n");
      b.append("uniform sampler2D uTexture;").append("\n");
      b.append("uniform vec2 uShift;").append("\n");
      b.append("const int gaussRadius = "+steps+";").append("\n");
      b.append("void main() ").append("\n");
      b.append("{").append("\n");
      b.append("vec2 texCoord = gl_TexCoord[0].xy - float(int(gaussRadius/2)) * uShift;").append("\n");
      b.append("vec3 color = vec3(0.0, 0.0, 0.0);").append("\n");

      for (int i=0; i<steps; i++)
      {
        b.append("color += "+(kernalData[i])+" * texture2D(uTexture, texCoord).xyz;").append("\n");
        b.append("texCoord += uShift;").append("\n");
      }
      
      b.append("gl_FragColor = vec4(color,1.0);").append("\n");
      b.append("}").append("\n");
      return b.toString();
  }

  // https://github.com/manuelbua/blur-ninja
    // https://gist.github.com/zz85/10542662
    // https://gamedev.stackexchange.com/questions/27474/optimizing-gaussian-blur-with-linear-filtering
    // http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/ or http://prideout.net/archive/bloom/
    // https://software.intel.com/en-us/blogs/2014/07/15/an-investigation-of-fast-real-time-gpu-based-image-blur-algorithms
  // returns a float array of (steps*2)+1    
  // returns a float array of (steps)
  public static final float[] createGaussianKernel_linWeight(int steps, double sigma)
  {
        float[] kernel_org = createGaussianKernel_org(steps, sigma); // steps * 2+1
        boolean even = ((steps%2) ==0);
        float[] weight = new float[even?steps/2+1:steps/2+1];
        int c = 0;
        int start = steps;
        int end = steps*2;
        if (even)
        {
            weight[c++] = kernel_org[steps];
            start++;
        }
        for (int i=start; i< end; i+=2)
        {
            weight[c++] = kernel_org[i] + kernel_org[i+1];
        }
        return weight;
  }
  // returns a float array of (steps)
  public static final float[] createGaussianKernel_linOffset(int steps, double sigma)
  {
        float[] kernel_org = createGaussianKernel_org(steps, sigma); // steps * 2+1
        float[] weights = createGaussianKernel_linWeight(steps, sigma);

        boolean even = ((steps%2) ==0);
        float[] offsets = new float[even?steps/2+1:steps/2+1];
        offsets[0] = 0;
        int c = 0;
        int end = steps*2;
        int start = steps;

        if (even)
        {
            offsets[c++] = 0;
            start++;
        }

        for (int i=start; i< end; i+=2)
        {
            int w = i-start;
            if (even) w++;
            offsets[c] = ((w * kernel_org[(i)]) + ((w+1) * kernel_org[i+1]))  / weights[c];
            
            if (Float.isNaN(offsets[c])) offsets[c] = (w+w+1)/2;
            
            c++;
        }
        return offsets;
  }
  static String buildBlurFragmentShader_lin(float[] kernalWeightData, float[] kernalOffsetData)
  {
      int steps = kernalWeightData.length;
      StringBuilder b = new StringBuilder();
      b.append("#version 120").append("\n");
      b.append("uniform sampler2D uTexture;").append("\n");
      b.append("uniform vec2 uShift;").append("\n");
      b.append("const int gaussRadius = "+steps+";").append("\n");
      b.append("void main() ").append("\n");
      b.append("{").append("\n");
      b.append("vec2 centreUV = gl_TexCoord[0].xy;").append("\n");
      
      b.append("float gOffsets["+kernalOffsetData.length+"];").append("\n");
      b.append("float gWeights["+kernalWeightData.length+"];").append("\n");

      for (int i=0; i<steps; i++)
      {
        b.append("gOffsets["+i+"] = "+kernalOffsetData[i]+";").append("\n");
      }      
      for (int i=0; i<steps; i++)
      {
        b.append("gWeights["+i+"] = "+kernalWeightData[i]+";").append("\n");
      }      
      b.append("vec2 texCoordOffset;\n");
      b.append("vec3 col;\n");
      b.append("vec3 color = vec3(0.0, 0.0, 0.0);\n");
      for (int i=0; i<steps; i++)
      {
        b.append("texCoordOffset = gOffsets["+i+"] * uShift;\n");
        b.append("col = texture2D(uTexture, centreUV + texCoordOffset).xyz + texture2D(uTexture, centreUV - texCoordOffset).xyz;").append("\n");
        b.append("color += gWeights["+i+"] * col;").append("\n");
      }
      b.append("gl_FragColor = vec4(color,1.0);").append("\n");
      b.append("}").append("\n");
      return b.toString();
  }


    // already drawn lines/points are expected to be 
    // drawn to the texture of lineFBO[0].texture.get(0)
    // glow is using "repaints" of the above in several
    // passes to lineFBO[0] and lineFBO[1]
    // finally result is again in lineFBO[0].texture.get(0)
    void processSpill(GL2 gl2)
    {
        if (!config.JOGLuseSpillShader) return;
        
        if (config.JOGLSpillAddBase)
        {
            // save "basic" output to be added to final result
            // copy fb0[0] to fbo[2]
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
         
            if (config.JOGLSpillUnfactordAddBase)
            {
                // above add factored original
                gl2.glBindFramebuffer(GL2.GL_DRAW_FRAMEBUFFER, lineFBO[2].fbo.get(0));   
                gl2.glBindFramebuffer(GL2.GL_READ_FRAMEBUFFER, lineFBO[0].fbo.get(0));   
                gl2.glBlitFramebuffer(0, 0, gl2Width, gl2Height, 0, 0, gl2Width, gl2Height, GL2.GL_COLOR_BUFFER_BIT, GL2.GL_NEAREST);
            }
            else
            {
                // disable our "compiled" shader (objects) to be used by the graphics cards hardware pipeline
                gl2.glUseProgram(spillFinalProgramId);
                gl2.glActiveTexture(GL.GL_TEXTURE0);

                int i = gl2.glGetUniformLocation(spillFinalProgramId, "uTexture");
                gl2.glUniform1i(i, 0);

                i = gl2.glGetUniformLocation(spillFinalProgramId, "factor");
                gl2.glUniform1f(i, (float) config.JOGLInitialSpillDivisor);

                // correct framebuffer from 0 to 1

                // this must be cleared first
                gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
                gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
                gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);

                gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[0].texture.get(0));
                gl2.glBegin( GL2.GL_QUADS ); 
                gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, -1.0F ); 
                gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
                gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
                gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, 1.0F ); 
                gl2.glEnd();
                gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

                gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
                gl2.glUseProgram(0);
            }
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        }
        
        
        gl2.glActiveTexture(GL.GL_TEXTURE0);
        gl2.glUseProgram(spillProgramId);

        if (!JOGLSupport.checkError(gl2, "processSpill():1"))
        {
            //System.out.println("JOGL ERROR");
            return;
        }

        for (int bp=0; bp<config.JOGLSpillPass; bp++)
        {
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[1].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);

            //ensure the direction is along the X-axis only
            int i = gl2.glGetUniformLocation(spillProgramId, "uShift");
            gl2.glUniform2f(i, 1.0f/((float)gl2Width), 1.0f/((float)gl2Height));

            i = gl2.glGetUniformLocation(spillProgramId, "uTexture");
            gl2.glUniform1i(i, 0);

            i = gl2.glGetUniformLocation(spillProgramId, "spillThreshold");
            gl2.glUniform1f(i, (float) config.JOGLSpillThreshold);

            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[0].texture.get(0));
            float y1 = -1.0F;
            float y2 = 1.0F;

            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            if (!JOGLSupport.checkError(gl2, "processSpill():2"))
            {
                //System.out.println("JOGL ERROR");
                return;
            }

            // now we draw to FBO0
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);

            i = gl2.glGetUniformLocation(spillProgramId, "uShift");
            gl2.glUniform2f(i, 1.0f/((float)gl2Width), 1.0f/((float)gl2Height));

            i = gl2.glGetUniformLocation(spillProgramId, "uTexture");
            gl2.glUniform1i(i, 0);

            i = gl2.glGetUniformLocation(spillProgramId, "spillThreshold");
            gl2.glUniform1f(i, (float) config.JOGLSpillThreshold);

            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[1].texture.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            y1 = -1.0F;
            y2 = 1.0F;
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        }

        if (!JOGLSupport.checkError(gl2, "processSpill():3"))
        {
            //System.out.println("JOGL ERROR");
            return;
        }

        // disable our "compiled" shader (objects) to be used by the graphics cards hardware pipeline
        gl2.glUseProgram(spillFinalProgramId);
        gl2.glActiveTexture(GL.GL_TEXTURE0);

        int i = gl2.glGetUniformLocation(spillFinalProgramId, "uTexture");
        gl2.glUniform1i(i, 0);

        i = gl2.glGetUniformLocation(spillFinalProgramId, "factor");
        gl2.glUniform1f(i, (float) config.JOGLFinalSpillMultiplyer);

        // correct framebuffer from 0 to 1

        // this must be cleared first
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[1].fbo.get(0));
        gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);

        gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[0].texture.get(0));
        gl2.glBegin( GL2.GL_QUADS ); 
        gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, -1.0F ); 
        gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
        gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
        gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, 1.0F ); 
        gl2.glEnd();
        gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        gl2.glUseProgram(0);

        // and put it back to fb0
        
        // this must be cleared first
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
        gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);

        gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[1].texture.get(0));
        gl2.glBegin( GL2.GL_QUADS ); 
        gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, -1.0F ); 
        gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
        gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
        gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, 1.0F ); 
        gl2.glEnd();

        gl2.glUseProgram(0);
        gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);


        if (config.JOGLSpillAddBase) 
        {
            gl2.glEnable(GL2.GL_BLEND);            
            gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));

            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[2].texture.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, 1.0F ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        }

        gl2.glDisable(GL2.GL_BLEND);

    }

    // http://slabode.exofire.net/circle_draw.shtml
    void drawCircle(GL2 gl2, float cx, float cy, float r, int num_segments) 
    { 
	float theta = 2 * ((float)Math.PI) / ((float)num_segments); 
	float tangetial_factor = (float) Math.tan(theta);//calculate the tangential factor 

	float radial_factor =  (float)Math.cos(theta);//calculate the radial factor 
	
	float x = r;//we start at angle = 0 

	float y = 0; 
    
	gl2.glBegin(GL.GL_LINE_LOOP); 
	for(int ii = 0; ii < num_segments; ii++) 
	{ 
		gl2.glVertex2f(x + cx, y + cy);//output vertex 
        
		//calculate the tangential vector 
		//remember, the radial vector is (x, y) 
		//to get the tangential vector we flip those coordinates and negate one of them 

		float tx = -y; 
		float ty = x; 
        
		//add the tangential vector 
		x += tx * tangetial_factor; 
		y += ty * tangetial_factor; 
        
		//correct using the radial factor 
		x *= radial_factor; 
		y *= radial_factor; 
	} 
	gl2.glEnd(); 
    }    
    static final float RADIUS = 8;// pixel
    static final int SEGMENTS = 8;

    // renders "over" FBO0
    private void renderDebug(GL2 gl2)
    {
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
        gl2.glPushAttrib(GL2.GL_CURRENT_BIT);
        if (config.paintIntegrators)
        {
            float xa = Scaler.scaleFloatToFloat((float)vpanel.getIntegratorX()-config.ALG_MAX_X/2, scaleWidthGL);
            float ya = Scaler.scaleFloatToFloat(-((float)vpanel.getIntegratorY()-config.ALG_MAX_Y/2), scaleHeightGL);
            float r = Scaler.scaleFloatToFloat(RADIUS, 1.0f/(float)gl2Width);
            gl2.glColor3f(1f,0f,0f); // red
            drawCircle(gl2, (float)xa, (float)ya, r, SEGMENTS);

        }
        if ( vpanel.isPausing())
        {
            GLUT glut = new GLUT();
            gl2.glColor3f(1f,0f,0f); // red
            gl2.glRasterPos2f(-Scaler.scaleFloatToFloat((float)((glut.glutBitmapLength(GLUT.BITMAP_HELVETICA_18, "PAUSE")))/2.0f, 1.0f/(float)gl2Width), Scaler.scaleFloatToFloat((float)(gl2Height/3), 1.0f/(float)gl2Height)     );
            glut.glutBitmapString(GLUT.BITMAP_HELVETICA_18, "PAUSE");
        }
        if (vpanel.isDebuging())
        {
            GLUT glut = new GLUT();
            gl2.glColor3f(0f,1f,0f); // green
            gl2.glRasterPos2f(-Scaler.scaleFloatToFloat((float)((glut.glutBitmapLength(GLUT.BITMAP_HELVETICA_18, "Debug")))/2.0f, 1.0f/(float)gl2Width), Scaler.scaleFloatToFloat((float)(gl2Height/3), 1.0f/(float)gl2Height)     );
            glut.glutBitmapString(GLUT.BITMAP_HELVETICA_18, "Debug");
        }
        if(vpanel.getDeviceList().get(DEVICE_LIGHTPEN).isActive())
        {
            GLUT glut = new GLUT();
            if (vpanel.isMousePressed())
                gl2.glColor3f(1f,0.5f,0f); // orange
            else
                gl2.glColor3f(1f,1f,0f); // yellow
            gl2.glRasterPos2f(-Scaler.scaleFloatToFloat((float)((glut.glutBitmapLength(GLUT.BITMAP_HELVETICA_18, "Lightpen")))/2.0f, 1.0f/(float)gl2Width), Scaler.scaleFloatToFloat((float)(gl2Height/3), 1.0f/(float)gl2Height)     );
            glut.glutBitmapString(GLUT.BITMAP_HELVETICA_18, "Lightpen");
        }
        if(vpanel.getDeviceList().get(DEVICE_IMAGER).isActive())
        {
            GLUT glut = new GLUT();
            gl2.glColor3f(1f,1f,0f); // yellow
            gl2.glRasterPos2f(-Scaler.scaleFloatToFloat((float)((glut.glutBitmapLength(GLUT.BITMAP_HELVETICA_18, "Goggle")))/2.0f, 1.0f/(float)gl2Width), Scaler.scaleFloatToFloat((float)(gl2Height/3), 1.0f/(float)gl2Height)     );
            glut.glutBitmapString(GLUT.BITMAP_HELVETICA_18, "Goggle");
        }
        
        
        
        
        if (vpanel.isMouseMode())
        {
            if (!vpanel.isCrossDisabled()) // out of bounds
            {
                int width = gl2Width;
                int height = gl2Height;
                double scaleWidth = ((double)width)/((double)config.ALG_MAX_X);
                double scaleHeight = ((double)height)/((double)config.ALG_MAX_Y);


                double distance = Double.MAX_VALUE;
                if (vpanel.getVinfi() != null)
                {
                    int x = vpanel.getMouseX();
                    int y = vpanel.getMouseY();
                    
                    y-=topOffset;
                    x-=leftOffset;
                    

                    x =Scaler.unscaleDoubleToInt(x, scaleWidth);
                    y =Scaler.unscaleDoubleToInt(y, scaleHeight);
                    x -=config.ALG_MAX_X/2;
                    y -=config.ALG_MAX_Y/2;
                    y =-y;

                    vpanel.getVinfi().setMouseCoordinates( x,  y);
                }


                int x = vpanel.getMouseX();
                int y = vpanel.getMouseY();
                y-=topOffset;
                x-=leftOffset;
                
                

                Color col = vpanel.getCrossColor();
                gl2.glColor3f(((float)col.getRed())/255f,((float)col.getGreen())/255f,((float)col.getBlue())/255f); // yellow

                
                gl2.glLineWidth(1);
                drawLineInScreenCoordinates(gl2, 0, y, gl2Width, y);                    
                drawLineInScreenCoordinates(gl2, x, 0, x, gl2Height);                    

                // search a vector that is in range!
                VectrexDisplayVectors vList = vpanel.getDisplayList();


                for (int i = 0; i < vList.count; i++) 
                {
                    VecXState.vector_t v = vList.vectrexVectors[i];

                    double x0=v.x0;
                    double y0=v.y0;
                    double x1=v.x1;
                    double y1=v.y1;
                    double d;

                    // vector coordinates in xy pos in relation to image!
                    x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
                    y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
                    x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
                    y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);

                    // nice, but now that I think of it I need a line SEGMENT, not a line!
                    d = SingleVectorPanel.getDistancePointToVector((double)vpanel.getMouseX()-leftOffset, (double)vpanel.getMouseY()-topOffset, x0,y0,x1,y1);
                    if (d<distance) 
                    {
                        distance = d;
                        vpanel.setFound(v);
                    }
                    if (distance==0) break;
                }

                if (directDrawVector != null)
                {
                    double x0=directDrawVector.x0;
                    double y0=directDrawVector.y0;
                    double x1=directDrawVector.x1;
                    double y1=directDrawVector.y1;
                    double d;

                    // vector coordinates in xy pos in relation to image!
                    x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
                    y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
                    x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
                    y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);

                    // nice, but now that I think of it I need a line SEGMENT, not a line!
                    d = SingleVectorPanel.getDistancePointToVector((double)vpanel.getMouseX(), (double)vpanel.getMouseY(), x0,y0,x1,y1);
                    if (d<distance) 
                    {
                        distance = d;
                        vpanel.setFound(directDrawVector);
                    }
                }

                // distance must be NEAR (in range)
                if (vpanel.getFound() != null)
                {
                    if (distance<=5) // arround 5 Pixel
                    {
                    }
                    else
                    {
                        vpanel.setFound(null);
                    }
                }        
                if (vpanel.getFound() != null)
                {
                    // select vector!
                    double x0=vpanel.getFound().x0;
                    double y0=vpanel.getFound().y0;
                    double x1=vpanel.getFound().x1;
                    double y1=vpanel.getFound().y1;

                    x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
                    y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
                    x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
                    y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);

                    gl2.glColor3f(0f,0f,1f); // blue

                    // construct a perpendicular vector for a 
                    // paralle transition
                    double py = x0-x1;
                    double px = -(y0-y1);
                    double l = Math.sqrt((Math.pow(py,2) + Math.pow(px,2)));

                    double transition = 3;

                    double px0 = x0 + (transition / l) * px;
                    double py0 = y0 + (transition / l) * py;
                    double px1 = x1 + (transition / l) * px;
                    double py1 = y1 + (transition / l) * py;

                    double transition2 = -3;

                    double px02 = x0 + (transition2 / l) * px;
                    double py02 = y0 + (transition2 / l) * py;
                    double px12 = x1 + (transition2 / l) * px;
                    double py12 = y1 + (transition2 / l) * py;

                    
                    // coordinates in screen         
                    drawLineInScreenCoordinates(gl2, (float)px0, (float)py0, (float)px1, (float)py1);                    
                    drawLineInScreenCoordinates(gl2, (float)px02, (float)py02, (float)px12, (float)py12);                    
                    drawLineInScreenCoordinates(gl2, (float)px0, (float)py0, (float)px02, (float)py02);                    
                    drawLineInScreenCoordinates(gl2, (float)px1, (float)py1, (float)px12, (float)py12);                    
                }
            }
        }        
        int LED_SCREEN_OFFSET = 40;
        if (vpanel.isLEDState())
        {
            float brightness = 1.0f;
            gl2.glEnable(GL2.GL_BLEND);
            gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ZERO);
            if (vpanel.isLEDDir())
            {
                for (int i=22; i>12;i-=2)
                {
                    int alpha = 250-((i-12)*20)-vpanel.getLEDStep()*2;
                    brightness = (float)((float) alpha)/255.0f;
                    gl2.glColor3f(brightness,brightness,brightness); // 
                    drawDiskInScreenCoordinates(gl2,this.getWidth()-LED_SCREEN_OFFSET, this.getHeight()-LED_SCREEN_OFFSET, (i-10)*2);
                }
                gl2.glColor4f(1f,1f,1f,1f); // yellow
                drawDiskInScreenCoordinates(gl2,this.getWidth()-LED_SCREEN_OFFSET, this.getHeight()-LED_SCREEN_OFFSET, 4);

                brightness = (float)((float) (255-vpanel.getLEDStep()))/255.0f;
                gl2.glColor3f(brightness,brightness,brightness); // 
                drawDiskInScreenCoordinates(gl2,this.getWidth()-LED_SCREEN_OFFSET, this.getHeight()-LED_SCREEN_OFFSET, 2);
                vpanel.setLEDStep(vpanel.getLEDStep()+1);
                if (vpanel.getLEDStep() >= 15)vpanel.setLEDDir(false);
            }
            else if (!vpanel.isLEDDir())
            {
                for (int i=22; i>12;i-=2)
                {
                    int alpha = 250-((i-12)*20)-vpanel.getLEDStep()*2;

                    brightness = (float)((float) alpha)/255.0f;
                    gl2.glColor3f(brightness,brightness,brightness); // 
                    
                    drawDiskInScreenCoordinates(gl2,this.getWidth()-LED_SCREEN_OFFSET, this.getHeight()-LED_SCREEN_OFFSET, (i-10)*2);
                }
                brightness = (float)((float) (255-vpanel.getLEDStep()))/255.0f;
                gl2.glColor3f(brightness,brightness,brightness); // 

                
                drawDiskInScreenCoordinates(gl2,this.getWidth()-LED_SCREEN_OFFSET, this.getHeight()-LED_SCREEN_OFFSET, 4);

                gl2.glColor4f(1f,1f,1f,1f); // 
                drawDiskInScreenCoordinates(gl2,this.getWidth()-LED_SCREEN_OFFSET, this.getHeight()-LED_SCREEN_OFFSET, 2);
                vpanel.setLEDStep(vpanel.getLEDStep()-1);
                if (vpanel.getLEDStep() <= 0)vpanel.setLEDDir(true);
            }
            gl2.glDisable(GL2.GL_BLEND);
        }        
        if (directDrawVector != null)
        {
            gl2.glColor3f(1f,1f,0f); // yellow
            gl2.glBegin(GL.GL_LINES);

            float _x0 =  Scaler.scaleFloatToFloat(directDrawVector.x0-config.ALG_MAX_X/2, scaleWidthGL);
            float _y0 = Scaler.scaleFloatToFloat(-(directDrawVector.y0-config.ALG_MAX_Y/2), scaleHeightGL);
            float _x1 =  Scaler.scaleFloatToFloat(directDrawVector.x1-config.ALG_MAX_X/2, scaleWidthGL);
            float _y1 = Scaler.scaleFloatToFloat(-(directDrawVector.y1-config.ALG_MAX_Y/2), scaleHeightGL);
            gl2.glVertex2f(_x0, _y0);
            gl2.glVertex2f(_x1, _y1);

            gl2.glEnd();
        }
            
        
        /* TODO
            directDrawVector
            rotate
            RAY
        */
        gl2.glPopAttrib();
    }
    private static int DISK_SEGEMENTS = 10;
    private void drawDiskInScreenCoordinates(GL2 gl2, float xi, float yi, float radius)
    {
        gl2.glBegin( GL.GL_TRIANGLE_FAN );
        
        float x =  (((float)+xi)/(0.5f*(float)gl2Width ))-1.0f;
        float y = -(((float)+yi)/(0.5f*(float)gl2Height))+1.0f;
        float r = radius/gl2Width;
        
        gl2.glVertex2f(x, y);
        for( int n = 0; n <= DISK_SEGEMENTS; ++n ) 
        {
            double t = 2 * Math.PI * (float)n / (float)DISK_SEGEMENTS;
            
            float xx = x + (float)Math.sin(t) * r;
            float yy = y + (float)Math.cos(t) * r;
            
            gl2.glVertex2f(xx, yy);
        }
        gl2.glEnd();        
    }
    private void drawLineInScreenCoordinates(GL2 gl2, float px0, float py0, float px1, float py1)
    {
        gl2.glBegin(GL.GL_LINES);

        float _x0 =  (((float)+px0)/(0.5f*(float)gl2Width ))-1.0f;
        float _y0 = -(((float)+py0)/(0.5f*(float)gl2Height))+1.0f;
        float _x1 =  (((float)+px1)/(0.5f*(float)gl2Width ))-1.0f;
        float _y1 = -(((float)+py1)/(0.5f*(float)gl2Height))+1.0f;
        gl2.glVertex2f(_x0, _y0);
        gl2.glVertex2f(_x1, _y1);

        gl2.glEnd();
    }

    
    void doScaledBlur(GL2 gl2)
    {
        int w = gl2Width/(1<<config.JOGLMIP_RESOLUTION);
        int h = gl2Height/(1<<config.JOGLMIP_RESOLUTION);

        // this must be cleared first
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[4].fbo.get(0));
        gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
        gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[5].fbo.get(0));
        gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
        gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
        gl2.glActiveTexture(GL.GL_TEXTURE0);
        
//        gl2.glGenerateMipmap(GL.GL_TEXTURE_2D);
            
        gl2.glBindFramebuffer(GL2.GL_READ_FRAMEBUFFER, lineFBO[0].fbo.get(0));        
        gl2.glBindFramebuffer(GL2.GL_DRAW_FRAMEBUFFER, lineFBO[4].fbo.get(0));        
        gl2.glBlitFramebuffer(0, 0, gl2Width, gl2Height, 0, 0, w, h, GL2.GL_COLOR_BUFFER_BIT, GL2.GL_LINEAR);        

        
        gl2.glUseProgram(blurProgramId);

        if (!JOGLSupport.checkError(gl2, "doScaledBlur():1"))
        {
            //System.out.println("JOGL ERROR");
            return;
        }
        gl2.glViewport(0, 0, w, h);
        for (int bp=0; bp<config.JOGLblurPass; bp++)
        {
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[5].fbo.get(0));

            //ensure the direction is along the X-axis only
            int i = gl2.glGetUniformLocation(blurProgramId, "uShift");
            gl2.glUniform2f(i, 1.0f/((float)w), 0f);

            i = gl2.glGetUniformLocation(blurProgramId, "uTexture");
            gl2.glUniform1i(i, 0);

            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[4].texture.get(0));
            float y1 = -1.0F;
            float y2 = 1.0F;

            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            if (!JOGLSupport.checkError(gl2, "doScaledBlur():2"))
            {
                //System.out.println("JOGL ERROR");
                return;
            }



            // now we draw to FBO0
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[4].fbo.get(0));

            i = gl2.glGetUniformLocation(blurProgramId, "uShift");
            gl2.glUniform2f(i, 0f, 1.0f/((float)h));

            i = gl2.glGetUniformLocation(blurProgramId, "uTexture");
            gl2.glUniform1i(i, 0);

            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[5].texture.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            y1 = -1.0F;
            y2 = 1.0F;
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        }

        if (!JOGLSupport.checkError(gl2, "doScaledBlur():3"))
        {
            //System.out.println("JOGL ERROR");
            return;
        }
        gl2.glViewport(0, 0, gl2Width, gl2Height);

        // disable our "compiled" shader (objects) to be used by the graphics cards hardware pipeline
        gl2.glUseProgram(0);        
        gl2.glDisable(GL2.GL_BLEND);
        gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
        gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
        gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
        
        gl2.glBindFramebuffer(GL2.GL_READ_FRAMEBUFFER, lineFBO[4].fbo.get(0));        
        gl2.glBindFramebuffer(GL2.GL_DRAW_FRAMEBUFFER, lineFBO[0].fbo.get(0));        
        gl2.glBlitFramebuffer(0, 0, w, h, 0, 0, gl2Width, gl2Height, GL2.GL_COLOR_BUFFER_BIT, GL2.GL_LINEAR);        
        
        
        
        if (config.JOGLaddBase) 
        {
            gl2.glEnable(GL2.GL_BLEND);            
            gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);

            // first round we draw to FBO1
            // this must be cleared first
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));

            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[2].texture.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, 1.0F ); 
            gl2.glEnd();
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        }

        gl2.glDisable(GL2.GL_BLEND);
    }
    
    boolean needBorderGlow(float[] test)
    {
        for (int i=0; i<test.length; i++)
            if (test[i] != 0) return true;
        return false;
    }
    
//    float overflowIntensityDivider = 15000f;
    float maxBorderIntensity = 0.8f;
    
    // this COSTS quite a lot!
    void processBorderGlow(GL2 gl2)
    {
        
        VectrexDisplayVectors vList = vpanel.getDisplayList();
        int BORDER_LEFT = 0;
        int BORDER_RIGHT = 1;
        int BORDER_TOP = 2;
        int BORDER_BOTTOM = 3;
        gl2.glBlendEquation(GL2.GL_FUNC_ADD);
        gl2.glDisable(GL2.GL_BLEND);            
        gl2.glPointSize(2);
        
        if (needBorderGlow(vList.left))
        {
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, borderFBO[BORDER_LEFT].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
            
            
            gl2.glPushAttrib(GL2.GL_CURRENT_BIT);
            gl2.glViewport(0, 0, OVERFLOW_BORDER_RAYWIDTH, OVERFLOW_SAMPLE_MAX);
            gl2.glBegin(GL.GL_POINTS);
            for (int i=0; i<vList.left.length; i++)
            {
                float intensity = vList.left[i]/config.overflowIntensityDivider;
                if (intensity>maxBorderIntensity) intensity = maxBorderIntensity;
                gl2.glColor3f(intensity,intensity,intensity); // 
                float x = 1f;
                float y= -((2f/(OVERFLOW_SAMPLE_MAX-1)*i)-1f);
                gl2.glVertex2f(x,y);
            }
            gl2.glEnd();
            gl2.glPopAttrib();
            
//    gl2.glEnable(GL2.GL_BLEND);            
//    gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);
    // blit it scaled onto FBo0
            
            gl2.glViewport(0, 0, gl2Width, gl2Height);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, borderFBO[BORDER_LEFT].texture.get(0));
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, 1.0F ); 
            gl2.glEnd();

            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);

    gl2.glEnable(GL2.GL_BLEND);            
    gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);
            
            
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[2].texture.get(0));
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0f, 0.f ); gl2.glVertex2f( -1f, -1.0F ); 
            gl2.glTexCoord2f( 0.5f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 0.5f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0f, 1.f ); gl2.glVertex2f( -1f, 1.0F ); 
            gl2.glEnd();

            if (!JOGLSupport.checkError(gl2, "processBorderGlow(): left"))
            {
                //System.out.println("JOGL ERROR");
                return;
            }
            
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
            gl2.glDisable(GL2.GL_BLEND);
        }

        if (needBorderGlow(vList.right))
        {
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, borderFBO[BORDER_RIGHT].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
            
            
            gl2.glPushAttrib(GL2.GL_CURRENT_BIT);
            gl2.glViewport(0, 0, OVERFLOW_BORDER_RAYWIDTH, OVERFLOW_SAMPLE_MAX);
            gl2.glBegin(GL.GL_POINTS);
            for (int i=0; i<vList.right.length; i++)
            {
                float intensity = vList.right[i]/config.overflowIntensityDivider;
                if (intensity>maxBorderIntensity) intensity = maxBorderIntensity;
                gl2.glColor3f(intensity,intensity,intensity); // 
                float x = -1f;
                float y= -((2f/(OVERFLOW_SAMPLE_MAX-1)*i)-1f);
                gl2.glVertex2f(x,y);
            }
            gl2.glEnd();
            gl2.glPopAttrib();
            
            gl2.glEnable(GL2.GL_BLEND);            
            gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);
            // blit it scaled onto FBo0
            
            gl2.glViewport(0, 0, gl2Width, gl2Height);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, borderFBO[BORDER_RIGHT].texture.get(0));
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, 1.0F ); 
            gl2.glEnd();
            
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
            
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[2].texture.get(0));
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.5f, 0.f ); gl2.glVertex2f( -1f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0.5f, 1.f ); gl2.glVertex2f( -1f, 1.0F ); 
            gl2.glEnd();
            if (!JOGLSupport.checkError(gl2, "processBorderGlow(): right"))
            {
                //System.out.println("JOGL ERROR");
                return;
            }
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
            gl2.glDisable(GL2.GL_BLEND);
        }
         
        
        
     
        

        
        
        if (needBorderGlow(vList.top))
        {
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, borderFBO[BORDER_TOP].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
            
            
            gl2.glPushAttrib(GL2.GL_CURRENT_BIT);
            gl2.glViewport(0, 0,OVERFLOW_SAMPLE_MAX, OVERFLOW_BORDER_RAYWIDTH);
            gl2.glBegin(GL.GL_POINTS);
            for (int i=0; i<vList.top.length; i++)
            {
                float intensity = vList.top[i]/config.overflowIntensityDivider;
                if (intensity>maxBorderIntensity) intensity = maxBorderIntensity;
                gl2.glColor3f(intensity,intensity,intensity); // 
                float x= ((2f/(OVERFLOW_SAMPLE_MAX-1)*i)-1f);
                float y = 1f;
                gl2.glVertex2f(x,y);
            }
            gl2.glEnd();
            gl2.glPopAttrib();
            
            gl2.glEnable(GL2.GL_BLEND);            
            gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);
            // blit it scaled onto FBo0
            
            gl2.glViewport(0, 0, gl2Width, gl2Height);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, borderFBO[BORDER_TOP].texture.get(0));
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, 1.0F ); 
            gl2.glEnd();

            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);

            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[2].texture.get(0));
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0f, 0.5f ); gl2.glVertex2f( -1f, -1.0F ); 
            gl2.glTexCoord2f( 1f, 0.5f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 1f, 0.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0f, 0.f ); gl2.glVertex2f( -1f, 1.0F ); 
            gl2.glEnd();
            if (!JOGLSupport.checkError(gl2, "processBorderGlow(): top"))
            {
                //System.out.println("JOGL ERROR");
                return;
            }
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        
            gl2.glDisable(GL2.GL_BLEND);
            
            
        
        }

        
        
        if (needBorderGlow(vList.bottom))
        {
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, borderFBO[BORDER_BOTTOM].fbo.get(0));
            gl2.glClearColor( 0.f, 0.f, 0.f, 1.f );
            gl2.glClear(GL2.GL_COLOR_BUFFER_BIT);
            
            
            gl2.glPushAttrib(GL2.GL_CURRENT_BIT);
            gl2.glViewport(0, 0,OVERFLOW_SAMPLE_MAX, OVERFLOW_BORDER_RAYWIDTH);
            gl2.glBegin(GL.GL_POINTS);
            for (int i=0; i<vList.bottom.length; i++)
            {
                float intensity = vList.bottom[i]/config.overflowIntensityDivider;
                if (intensity>maxBorderIntensity) intensity = maxBorderIntensity;
                gl2.glColor3f(intensity,intensity,intensity); // 
                float x= ((2f/(OVERFLOW_SAMPLE_MAX-1)*i)-1f);
                float y = 1f;
                gl2.glVertex2f(x,y);
            }
            gl2.glEnd();
            gl2.glPopAttrib();
            
            gl2.glEnable(GL2.GL_BLEND);            
            gl2.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);
            // blit it scaled onto FBo0
            
            gl2.glViewport(0, 0, gl2Width, gl2Height);
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, borderFBO[BORDER_BOTTOM].texture.get(0));
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[2].fbo.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, 1.0F ); 
            gl2.glEnd();

            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);

            gl2.glBindTexture(GL2.GL_TEXTURE_2D, lineFBO[2].texture.get(0));
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));
            gl2.glBegin( GL2.GL_QUADS ); 
            gl2.glTexCoord2f( 0f, 0.f ); gl2.glVertex2f( -1f, -1.0F ); 
            gl2.glTexCoord2f( 1f, 0.f ); gl2.glVertex2f( 1.0f, -1.0F ); 
            gl2.glTexCoord2f( 1f, 0.5f ); gl2.glVertex2f( 1.0f, 1.0F ); 
            gl2.glTexCoord2f( 0f, 0.5f ); gl2.glVertex2f( -1f, 1.0F ); 
            gl2.glEnd();
            if (!JOGLSupport.checkError(gl2, "processBorderGlow(): bottom"))
            {
                //System.out.println("JOGL ERROR");
                return;
            }
            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );

            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
        
            gl2.glDisable(GL2.GL_BLEND);
        }
        
                
        gl2.glPointSize(config.lineWidth);

    }
    void renderChassis(GL2 gl2)
    {
        if (config.JOGLScreen)
        {
            gl2.glEnable(GL2.GL_BLEND);            
            gl2.glBlendFunc(GL2.GL_SRC_ALPHA, GL2.GL_ONE_MINUS_SRC_ALPHA);
            
            gl2.glLoadIdentity();
            gl2.glEnable(GL2.GL_TEXTURE_2D);

            gl2.glActiveTexture(GL2.GL_TEXTURE0 );
            gl2.glBindTexture(GL2.GL_TEXTURE_2D, screenTextureObject.get(0));
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, lineFBO[0].fbo.get(0));

            
            if (config.JOGLScreenAdjustment)
            {
                gl2.glUseProgram(screenProgramId);
                gl2.glActiveTexture(GL.GL_TEXTURE0);

                int i = gl2.glGetUniformLocation(screenProgramId, "screenTexture");
                gl2.glUniform1i(i, 0);

                i = gl2.glGetUniformLocation(screenProgramId, "screenBrightnessAdjust");
                gl2.glUniform1f(i, (float) config.JOGLScreenBrightnessAdjustmentFactor);
            }            


            
            gl2.glBegin( GL2.GL_QUADS ); 

            float y1 = screenMustFlip ? 1.0F : -1.0F;
            float y2 = 1.0F - y1;
            if (y1==1.0f) y2=-1.0f; else y2 =1.0f;


            gl2.glTexCoord2f( 0.f, 0.f ); gl2.glVertex2f( -1.f, y1 ); 
            gl2.glTexCoord2f( 1.f, 0.f ); gl2.glVertex2f( 1.0f, y1 ); 
            gl2.glTexCoord2f( 1.f, 1.f ); gl2.glVertex2f( 1.0f, y2 ); 
            gl2.glTexCoord2f( 0.f, 1.f ); gl2.glVertex2f( -1.f, y2 ); 
            gl2.glEnd();

            gl2.glBindTexture( GL2.GL_TEXTURE_2D, 0 );
            gl2.glBindFramebuffer(GL2.GL_FRAMEBUFFER, 0);
            gl2.glUseProgram(0);

            gl2.glBlendFunc(GL2.GL_SRC_ALPHA, GL2.GL_ONE);
            gl2.glBlendEquation(GL2.GL_FUNC_ADD);
            gl2.glDisable(GL2.GL_BLEND);               
        }
        if (config.CHASSIS_AVAILABLE!=1) return;
    }
    // of jogl panel in screen coordonates
    // only when aspect ratio is active
    int topOffset = 0;
    int leftOffset = 0;
    // some bad stuff happens if un iconified.
    public void forceResize()
    {
        Rectangle bounds = new Rectangle(0,vpanel.getYOffset(),vpanel.getWidth(),vpanel.getHeight()-(vpanel.getYOffset()));

        if ((bounds.width !=0) && (bounds.height != 0))
        {
            if (config.keepAspectRatio)
            {
                float width = bounds.width;
                float height = bounds.height;
                float ratio = 4f/3f;
                if ((config.rotate == 0) || (config.rotate == 180))
                {
                    float naturalRatio = (float)bounds.height / (float)bounds.width;
                    if (naturalRatio >ratio) height = width * ratio;
                    if (naturalRatio <ratio) width = height / ratio;
                }
                else
                {
                    float naturalRatio = (float)bounds.width / (float)bounds.height;
                    if (naturalRatio >ratio) width = height * ratio;
                    if (naturalRatio <ratio) height = width / ratio;
                }
                topOffset =  0 + (int) ((bounds.height-height)/2); // lightpen mouse is already respecting the panel offset
                leftOffset = 0 + (int) ((bounds.width-width)/2);
                
                bounds.x = leftOffset;
                bounds.y = vpanel.getYOffset() +topOffset;
                bounds.width = (int) width;
                bounds.height = (int) height;
            }
            else
            {
                topOffset = 0;
                leftOffset = 0;
            }
            
        }
        gl2Width = bounds.width;
        gl2Height = bounds.height;
        scaleWidth = (float) (((double)gl2Width)/((double)config.ALG_MAX_X));
        scaleHeight = (float) (((double)gl2Height)/((double)config.ALG_MAX_Y));
        setBounds(bounds);
    }
}
