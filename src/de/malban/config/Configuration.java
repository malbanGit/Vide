/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.config;

import de.malban.config.sound.SoundEffect;
import de.malban.config.sound.SoundMap;
import de.malban.config.sound.SoundMapPool;
import de.malban.config.theme.Theme;
import de.malban.gui.ImageCache;
import de.malban.gui.ResizeListener;
import de.malban.gui.ScaleListener;
import de.malban.gui.components.ModalInternalFrame;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.sound.Audio;
import java.awt.Font;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.util.Map;
import java.util.Vector;
import java.util.concurrent.ConcurrentHashMap;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JInternalFrame;
import javax.swing.JOptionPane;
/**
 *
 * @author Malban
 */	
public final class Configuration
{
    public static final int DIALOG_YES=1;
    public static final int DIALOG_NO=2;
    public static final int DIALOG_CANCEL=0;

    

    private Theme currentTheme = null;
    public Theme getCurrentTheme()
    {
        if (currentTheme == null)
        {
            currentTheme = Theme.getThemeInstance(getThemeName());
        }
        return currentTheme;
    }
    
    public String getThemeName()
    {
        String t = mData.mCurrentThemeName;
        if (t == null) t = "default";
        if (t.trim().length() == 0) t = "default";
        return t;
    }
    public void setThemeName(String t)
    {
        if (t == null) t = "default";
        if (t.trim().length() == 0) t = "default";
        mData.mCurrentThemeName = t;
    }
    
    private ConfigurationData mData = null;
    private static Configuration mConfiguration=null;
    private static ConfigurationDataPool mConfigurationDataPool= new ConfigurationDataPool();
    private Vector<ConfigChangedListener> mConfigListener= new Vector<ConfigChangedListener>();

    private Vector<ScaleListener> mScaleListener= new Vector<ScaleListener>();
    private Vector<ResizeListener> mSizeListener= new Vector<ResizeListener>();
    private Vector<LogListener> mDebugListener= new Vector<LogListener>();
    private Vector<LogListener> mLogListener= new Vector<LogListener>();

    private SoundMap mSoundMap = null;
    private int mMainWidth=1024;
    private int mMainHeight=768;
    private int mMainWidthEvent=1024;
    private int mMainHeightEvent=768;

    private Logable mLogPanel = new LogPanel();
    private Logable mDebugPanel = new LogPanel();

    public boolean mIsFullscreen = false;
    private JFrame mMainFrame = null;

    public int getDebugLevel() {return mData.mDebugLevel;}

    public boolean isInit()
    {
        return mMainFrame!=null;
    }
    public void setDebugOff(boolean b)
    {
        if (b==mData.mDebugOff) return;
        mData.mDebugOff=b;
        if (b)
        {
            mDebugPanel = new LogPanel();
            mDebugPanel.setDebugLevel(mData.mDebugLevel);
            mDebugPanel.setInterestedFiles(mData.mDebugFiles);
            mDebugPanel.setInterestedClasses(mData.mDebugClasses);
            mDebugPanel.setInterestedMethods(mData.mDebugMethods);
            mDebugPanel.setTrackTime(mData.mDebugTiming);
            mDebugPanel.setDebugFileOnly(mData.mDebugFileOnly);
            mDebugPanel.setFiletracking(!mData.mDisableFileLogs);
            ((LogPanel)mDebugPanel).setTitle("Debug Window");
        }
        else
        {
            mDebugPanel = new DummyLog();
        }
    }
    
    public void setCacheActive(boolean b)
    {
        mData.mPassAutoOnEmptyStack=b;
    }
    public boolean getCacheActive()
    {
        return mData.mPassAutoOnEmptyStack;
    }

    public boolean isSoundQuiet()
    {
        return mData.mNoSound;
    }
    public void setSoundQuiet(boolean p)
    {
        mData.mNoSound = p;
    }
    public boolean isDebugOff()
    {
        return mData.mDebugOff;
    }
    public void setDebugLevel(int d)
    {
        mData.mDebugLevel =d;
        mDebugPanel.setDebugLevel(d);
    }
    public void setDebugFiles(String d)
    {
        mData.mDebugFiles =d;
        mDebugPanel.setInterestedFiles(d);
    }
    public void setDebugClasses(String d)
    {
        mData.mDebugClasses =d;
        mDebugPanel.setInterestedClasses(d);
    }
    public void setDebugMethods(String d)
    {
        mData.mDebugMethods =d;
        mDebugPanel.setInterestedMethods(d);
    }

    public void setDebugTiming(boolean b)
    {
        mData.mDebugTiming =b;
        mDebugPanel.setTrackTime(b);
    }

    public String getDebugFiles()
    {
        return mData.mDebugFiles;
    }
    public String getDebugClasses()
    {
        return mData.mDebugClasses;
    }
    public String getDebugMethods()
    {
        return mData.mDebugMethods;
    }
    public boolean isDebugTiming()
    {
        return mData.mDebugTiming;
    }
    public boolean isDebugFileOnly()
    {
        return mData.mDebugFileOnly;
    }
    public boolean isDebugWindowFrameable()
    {
        return true;
    }
    public void setDebugFileOnly(boolean b)
    {
        mData.mDebugFileOnly =b;
        mDebugPanel.setDebugFileOnly(b);
    }

    public static Configuration getConfiguration()
    {
        if (mConfiguration == null)
        {
            mConfiguration = new Configuration();
        }
        return mConfiguration;
    }

    private Configuration()
    {
        mData = mConfigurationDataPool.get("Configuration");
        ((LogPanel)mLogPanel).setTitle("Log Window");

        if (mData == null) // first time - no config will be available
        {
            mData = new ConfigurationData();
            setDebugOff(mData.mDebugOff);
            mData.mClass="Configuration";
            mData.mName="Configuration";
            mData.mScale=100;
            mData.mCardHeight=285;
            mData.mCardWidth=200;
            mData.mSoundVolumne=80;
            mData.mStartInFullScreen=false;
        }
        else
        {
            setDebugOff(mData.mDebugOff);
            mDebugPanel.setDebugLevel(mData.mDebugLevel);
            mDebugPanel.setInterestedFiles(mData.mDebugFiles);
            mDebugPanel.setInterestedClasses(mData.mDebugClasses);
            mDebugPanel.setInterestedMethods(mData.mDebugMethods);
            mDebugPanel.setTrackTime(mData.mDebugTiming);
            mDebugPanel.setFiletracking(!mData.mDisableFileLogs);
            mLogPanel.setFiletracking(!mData.mDisableFileLogs);
            
             ImageCache.cacheActive = getCacheActive();
       
            
        }
    }

    public void init()
    {
//        Audio.setAllVolumne(mData.mSoundVolumne);
        mDebugPanel.setFiletracking(!mData.mDisableFileLogs);
        mLogPanel.setFiletracking(!mData.mDisableFileLogs);
             ImageCache.cacheActive = getCacheActive();
    }

    public void save()
    {
        mConfigurationDataPool.put(mData);
        mConfigurationDataPool.save();

        mDebugPanel.setDebugLevel(mData.mDebugLevel);
        mDebugPanel.setInterestedFiles(mData.mDebugFiles);
        mDebugPanel.setInterestedClasses(mData.mDebugClasses);
        mDebugPanel.setInterestedMethods(mData.mDebugMethods);
        mDebugPanel.setTrackTime(mData.mDebugTiming);
        mDebugPanel.setFiletracking(!mData.mDisableFileLogs);
        mLogPanel.setFiletracking(!mData.mDisableFileLogs);
             ImageCache.cacheActive = getCacheActive();
        fireConfigChanged();
    }

    public int getScalePercent()
    {
        return mData.mScale;
    }

    public void addScaleListerner(ScaleListener listener)
    {
        mScaleListener.removeElement(listener);
        mScaleListener.addElement(listener);
    }

    public void removeScaleListerner(ScaleListener listener)
    {
        mScaleListener.removeElement(listener);
    }

    public void addConfigListerner(ConfigChangedListener listener)
    {
        mConfigListener.removeElement(listener);
        mConfigListener.addElement(listener);
    }

    public void removeConfigListerner(ConfigChangedListener  listener)
    {
        mConfigListener.removeElement(listener);
    }
    
    public void fireConfigChanged()
    {
        for (int i=0; i<mConfigListener.size(); i++)
        {
            mConfigListener.elementAt(i).configurationChanged();
        }
    }

    public void addResizeListener(ResizeListener listener)
    {
        mSizeListener.removeElement(listener);
        mSizeListener.addElement(listener);
    }

    public void removeResizeListener(ResizeListener listener)
    {
        mSizeListener.removeElement(listener);
    }

    public void addLogListener(LogListener listener)
    {
        mLogListener.removeElement(listener);
        mLogListener.addElement(listener);
    }

    public void removeLogListener(LogListener listener)
    {
        mLogListener.removeElement(listener);
    }
    
    public void addDebugListener(LogListener listener)
    {
        mDebugListener.removeElement(listener);
        mDebugListener.addElement(listener);
    }

    public void removeDebugListener(LogListener listener)
    {
        mDebugListener.removeElement(listener);
    }

    public void fireLogAdded(String addTest)
    {
        for (int i=0; i<mSizeListener.size(); i++)
        {
            mLogListener.elementAt(i).logAddedChanged(addTest);
        }
    }
    public void fireDebugAdded(String addTest)
    {
        for (int i=0; i<mSizeListener.size(); i++)
        {
            mDebugListener.elementAt(i).logAddedChanged(addTest);
        }
    }
    public void setMainSize(int w, int h)
    {
        mMainWidth = w;
        mMainHeight = h;
        
        int scale = 100;

        mData.mScale = scale;

    }
    public int getMainWidth()
    {
        return mMainWidth;
    }
    public int getMainHeight()
    {
        return mMainHeight;
    }

    public void setMainFrame(JFrame frame )
    {
        mMainFrame = frame;
    }
    public JFrame getMainFrame()
    {
        return mMainFrame;
    }
    public void DisplayError(String text) {DisplayError(text, null);}

    public void DisplayError(String text, Throwable e)
    {
        getDebugEntity().addLog(text,0);
        String extension = "";
        if (e != null)
        {
            getDebugEntity().addLog(e, 0);
            extension = e.toString();
        }
        if (mMainFrame == null) return;

        // Manually construct an input popup
        javax.swing.JOptionPane optionPane = new JOptionPane( text+"\n"+extension, JOptionPane.ERROR_MESSAGE);
        JInternalFrame modal = new ModalInternalFrame("Error!", getMainFrame().getRootPane(), getMainFrame(), optionPane);
        modal.setVisible(true);
    }

    public void showInfoDialog(String message, String title)
    {
        if (mMainFrame == null) return;
        javax.swing.JOptionPane optionPane = new JOptionPane( message, JOptionPane.INFORMATION_MESSAGE);
        JInternalFrame modal = new ModalInternalFrame(title, getMainFrame().getRootPane(), getMainFrame(), optionPane);
        modal.setVisible(true);
    }

    public int showConfirmDialog(String message, String title)
    {
        if (mMainFrame == null) return DIALOG_CANCEL;
        // Manually construct an input popup
        JOptionPane optionPane = new JOptionPane( message, JOptionPane.QUESTION_MESSAGE,  JOptionPane.YES_NO_OPTION);
        JInternalFrame modal = new ModalInternalFrame(title, getMainFrame().getRootPane(), getMainFrame(), optionPane);
        modal.setVisible(true);

        Object value = optionPane.getValue();
        if (value.equals(new Integer(0)))
        {
            return DIALOG_YES;
        }
        else if (value.equals(new Integer(1)))
        {
            return DIALOG_NO;
        }
        return DIALOG_CANCEL;
    }

    public int showFileChooserDialog(String message, String title)
    {
        if (mMainFrame == null) return DIALOG_CANCEL;

        return DIALOG_CANCEL;
    }


    public int showFileDialog(String message, String title)
    {
        if (mMainFrame == null) return DIALOG_CANCEL;
        // Manually construct an input popup
        JOptionPane optionPane = new JOptionPane( message, JOptionPane.QUESTION_MESSAGE,  JOptionPane.YES_NO_OPTION);

        final JFileChooser fc = new JFileChooser();

        int returnVal = fc.showOpenDialog(null);

        JInternalFrame modal = new ModalInternalFrame(title, getMainFrame().getRootPane(), getMainFrame(), optionPane);
        modal.setVisible(true);

        Object value = optionPane.getValue();
        if (value.equals(new Integer(0)))
        {
            return DIALOG_YES;
        }
        else if (value.equals(new Integer(1)))
        {
            return DIALOG_NO;
        }
        return DIALOG_CANCEL;
    }

    boolean firstTimeSizeChanged = true;

    public void fireSizeChanged(boolean forced)
    {
        //1024 = 39%
        // 740 = 39%
        // 740 *0,39 = 100%
        // 740 *39 = 10000%
        /*
        740 / 0,39
        740 * 1/0,39

        100 / 39

        740*100/(39)
        pixel  in 100%
        */
        if (firstTimeSizeChanged)
        {
            firstTimeSizeChanged = false;
            forced = true;
        }
        if ((mMainWidth != mMainWidthEvent) ||(mMainHeight != mMainHeightEvent) || (forced))
        {
            
            mData.mScale = 100;

            for (int i=0; i<mSizeListener.size(); i++)
            {
                mSizeListener.elementAt(i).sizeChanged();
            }

        }
        mMainWidthEvent=mMainWidth;
        mMainHeightEvent=mMainHeight;

    }

   public Logable getLogEntity()
   {
        return mLogPanel;
   }



 // Prepare a static "cache" mapping font names to Font objects.
  private final static String[] names = { /*"MAGIC.TTF"*/ };
  private final static Map<String, Font> cache = new ConcurrentHashMap<String, Font>(names.length);
  static
  {
        for (String name : names)
        {
          cache.put(name, getFont(name));
        }
  }
  public static Font getFont(String name)
  {
    Font font;
    if (cache != null)
    {
      if ((font = cache.get(name)) != null)
      {
            return font;
      }
    }
    String fName = "fonts"+File.separator + name;
    try
    {
      //InputStream is = Configuration.class.getResourceAsStream(fName);
      InputStream is = new FileInputStream(new File(fName));
      font = Font.createFont(Font.TRUETYPE_FONT, is).deriveFont(20f);
    }
    catch (Exception ex)
    {
      ex.printStackTrace();
      System.err.println(fName + " not loaded.  Using serif font.");
      font = new Font("serif", Font.PLAIN, 24);
    }
    return font;
  }

   public Font getMagicFont(int s)
   {
       return cache.get( "MAGIC.TTF").deriveFont((float) s);
   }

   public Logable getDebugEntity()
   {
        return mDebugPanel;

   }


    public void clearLog()
    {
        mLogPanel.clearLog();

    }
    public void clearDebugLog()
    {
        mDebugPanel.clearLog();
    }

    public void resetStatic()
    {
        Audio.resetCaches();
        SoundEffect.resetMappings();
    }

    public void setSoundVolumne(int volumne)
    {
        mData.mSoundVolumne=volumne;
    }
    public int getSoundVolumne()
    {
        return mData.mSoundVolumne;
    }

    public void setStartInFullScrren(boolean b)
    {
        mData.mStartInFullScreen = b;
    }
    public boolean isStartInFullScrren()
    {
        return mData.mStartInFullScreen;
    }
    public void setFullScrrenResString(String res)
    {
        if (res==null) res ="";
        mData.mFullscreenResolution = res;
    }
    public String getFullScrrenResString()
    {
        if (mData.mFullscreenResolution == null) return "";
        return mData.mFullscreenResolution;
    }

    public boolean isFirstTime()
    {
        return !mData.mFirstTimeStarting;
    }
    public void  setFirstTime(boolean f)
    {
        mData.mFirstTimeStarting = !f;
    }
    public void setTitleMusic(String t)
    {
        mData.mTitleMusik = t;
    }
    public String getTitleMusic()
    {
        return mData.mTitleMusik;
    }

    public void setFileLoggingDisabled(boolean b)
    {
        mData.mDisableFileLogs = b;
        mDebugPanel.setFiletracking(!mData.mDisableFileLogs);
        mLogPanel.setFiletracking(!mData.mDisableFileLogs);
    }
    public boolean isFileLoggingDisabled()
    {
        return mData.mDisableFileLogs;
    }

    public void setPlayTitleMusic(boolean b )
    {
        mData.mPlayMusic = b;
    }
    public boolean isPlayTitleMusic()
    {
        return mData.mPlayMusic;
    }

    public void setSoundMapName(String s)
    {
        mData.mSoundMapName = s;
        Audio.resetCaches();
        SoundEffect.resetMappings();
        mSoundMap = null;
    }

    public String getSoundMapName()
    {
        return mData.mSoundMapName;
    }

    public SoundMap getSoundMap()
    {
        if (mSoundMap == null)
        {
            SoundMapPool mSoundMapPool = new SoundMapPool();
            mSoundMap = mSoundMapPool.get(mData.mSoundMapName);
            if (mSoundMap == null)
                mSoundMap = new SoundMap();
            SoundEffect.resetMappings();
        }
        return mSoundMap;
    }

    public void setShowTOD(boolean b)
    {
        mData.mShowTippOfDay = b;
    }
    public boolean isShowTOD()
    {
        return mData.mShowTippOfDay;
    }

    Vector<String> getAllThemes() {
        return new Vector<String>();
    }
    public boolean isBackImageShown()
    {
        return false;
    }
    
        
    class DummyLog implements Logable
    {
        @Override public void setFiletracking(boolean b){}
        @Override public void setInterestedClasses(String c){}
        @Override public void setInterestedMethods(String m){}
        @Override public void setInterestedFiles(String f){}
        @Override public void setTrackTime(boolean b){}
        @Override public void setTrackInFile(boolean b){}
        @Override public void setDebugLevel(int l){}
        @Override public void setDebugFileOnly(boolean b){}
        @Override public void setLog(String text, int level){}
        @Override public void addLog(Throwable e, int level){}
        @Override public void addLog(String text, int level){}
        @Override public void setLog(String text){}
        @Override public void addLog(Throwable e){}
        @Override public void addLog(String text){}
        @Override public String getLog(){return "";}
        @Override public boolean saveLog(){return false;}
        @Override public void clearLog(){}
        @Override public void addLogListener(LogListener l){};
        @Override public void removeLogListener(LogListener l){};
    }

    static StringBuilder add = new StringBuilder();
    public static PrintStream getLogStream()
    {
        PrintStream  p= new PrintStream(
            new OutputStream()
            {
                @Override
                public void write( int b )
                {
                    add.append((char)b);
                    if (b=='\n')
                    {
                        Configuration.getConfiguration().getDebugEntity().addLog(add.toString(), WARN);
                        add.delete(0, add.length());
                    }
                }
            }
        );
//        p.flush();
        return p;
    }
}
