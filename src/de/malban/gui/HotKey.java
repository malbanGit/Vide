package de.malban.gui;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import de.malban.vide.VideConfig;
import java.awt.event.KeyEvent;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import javax.swing.Action;
import static javax.swing.JComponent.WHEN_IN_FOCUSED_WINDOW;
import javax.swing.JPanel;
import javax.swing.KeyStroke;
import javax.swing.text.JTextComponent;

/**
 *
 * @author malban
 */

// usage of "HotKey" class
//        new HotKey("Run", new AbstractAction() { public void actionPerformed(ActionEvent e) {  run(); }}, this);
// (calling constructor, no need to save the new "hotkey", the constructor initiates all needed stuff)
// the actual KEYs must be known by the HotKey class (see static {})
// in static the default keys for each "name" are defined
// if user redefines them the new defines are serialized and thus remembered
//
// so for a new hotkey you need
// - add a default keyset for a name in the "static" region of this class
// - add the hotkey constructor (see above) to the class where you want to use the hotkey
//
// the actual serialization is done from apart of this class, in the case of vide
// this is done via "VideConfig"


public class HotKey implements Serializable
{
    public String name="";
    public String where = "";
    public int event = 0;
    public int mask=0;
    public boolean onRelease = false;

    transient Action action = null;
    transient JTextComponent editor=null;
    transient JPanel panel = null;
    transient public static HashMap <String, HotKey> allMappings;
    transient public static ArrayList<HotKey> hotkeyList;
    
    static
    {
            allMappings= new HashMap<>();
            hotkeyList = new ArrayList<>();

            HotKey.addMap(KeyEvent.VK_C, java.awt.event.KeyEvent.META_DOWN_MASK, javax.swing.text.DefaultEditorKit.copyAction, "Editor");
            HotKey.addMap(KeyEvent.VK_V, java.awt.event.KeyEvent.META_DOWN_MASK, javax.swing.text.DefaultEditorKit.pasteAction, "Editor");
            HotKey.addMap(KeyEvent.VK_X, java.awt.event.KeyEvent.META_DOWN_MASK, javax.swing.text.DefaultEditorKit.cutAction, "Editor");
            HotKey.addMap(KeyEvent.VK_TAB, java.awt.event.KeyEvent.SHIFT_DOWN_MASK ,"unindent", "Editor");
            HotKey.addMap(KeyEvent.VK_TAB, 0 ,"indent", "Editor");
            HotKey.addMap(KeyEvent.VK_Z, java.awt.event.KeyEvent.META_DOWN_MASK ,"UndoMac", "Editor");
            HotKey.addMap(KeyEvent.VK_Y, java.awt.event.KeyEvent.META_DOWN_MASK ,"RedoMac", "Editor");
            HotKey.addMap(KeyEvent.VK_Z, java.awt.event.KeyEvent.CTRL_DOWN_MASK ,"UndoWin", "Editor");
            HotKey.addMap(KeyEvent.VK_Y, java.awt.event.KeyEvent.CTRL_DOWN_MASK ,"RedoWin", "Editor");
            HotKey.addMap(KeyEvent.VK_F, java.awt.event.KeyEvent.META_DOWN_MASK ,"SearchMac", "Editor");
            HotKey.addMap(KeyEvent.VK_F, java.awt.event.KeyEvent.CTRL_DOWN_MASK ,"SearchWin", "Editor");

            HotKey.addMap(KeyEvent.VK_F5, 0, "Run", "Editor");
            HotKey.addMap(KeyEvent.VK_F6, 0, "Debug", "Editor");
            HotKey.addMap(KeyEvent.VK_F1, 0, "QuickHelp", "Editor");
            
            
            
            HotKey.addMap(KeyEvent.VK_R, java.awt.event.KeyEvent.META_DOWN_MASK, "RecolorMac", "Editor");
            HotKey.addMap(KeyEvent.VK_R, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "RecolorWin", "Editor");
            HotKey.addMap(KeyEvent.VK_J, java.awt.event.KeyEvent.META_DOWN_MASK, "JumpMac", "Editor");
            HotKey.addMap(KeyEvent.VK_J, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "JumpWin", "Editor");

            HotKey.addMap(KeyEvent.VK_1, java.awt.event.KeyEvent.META_DOWN_MASK, "GoBookmark1Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_1, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "GoBookmark1Win", "Editor");
            HotKey.addMap(KeyEvent.VK_1, java.awt.event.KeyEvent.META_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark1Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_1, java.awt.event.KeyEvent.CTRL_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark1Win", "Editor");

            HotKey.addMap(KeyEvent.VK_2, java.awt.event.KeyEvent.META_DOWN_MASK, "GoBookmark2Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_2, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "GoBookmark2Win", "Editor");
            HotKey.addMap(KeyEvent.VK_2, java.awt.event.KeyEvent.META_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark2Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_2, java.awt.event.KeyEvent.CTRL_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark2Win", "Editor");

            HotKey.addMap(KeyEvent.VK_3, java.awt.event.KeyEvent.META_DOWN_MASK, "GoBookmark3Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_3, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "GoBookmark3Win", "Editor");
            HotKey.addMap(KeyEvent.VK_3, java.awt.event.KeyEvent.META_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark3Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_3, java.awt.event.KeyEvent.CTRL_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark3Win", "Editor");

            HotKey.addMap(KeyEvent.VK_4, java.awt.event.KeyEvent.META_DOWN_MASK, "GoBookmark4Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_4, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "GoBookmark4Win", "Editor");
            HotKey.addMap(KeyEvent.VK_4, java.awt.event.KeyEvent.META_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark4Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_4, java.awt.event.KeyEvent.CTRL_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark4Win", "Editor");

            HotKey.addMap(KeyEvent.VK_5, java.awt.event.KeyEvent.META_DOWN_MASK, "GoBookmark5Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_5, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "GoBookmark5Win", "Editor");
            HotKey.addMap(KeyEvent.VK_5, java.awt.event.KeyEvent.META_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark5Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_5, java.awt.event.KeyEvent.CTRL_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark5Win", "Editor");

            HotKey.addMap(KeyEvent.VK_6, java.awt.event.KeyEvent.META_DOWN_MASK, "GoBookmark6Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_6, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "GoBookmark6Win", "Editor");
            HotKey.addMap(KeyEvent.VK_6, java.awt.event.KeyEvent.META_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark6Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_6, java.awt.event.KeyEvent.CTRL_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark6Win", "Editor");

            HotKey.addMap(KeyEvent.VK_7, java.awt.event.KeyEvent.META_DOWN_MASK, "GoBookmark7Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_7, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "GoBookmark7Win", "Editor");
            HotKey.addMap(KeyEvent.VK_7, java.awt.event.KeyEvent.META_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark7Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_7, java.awt.event.KeyEvent.CTRL_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark7Win", "Editor");

            HotKey.addMap(KeyEvent.VK_8, java.awt.event.KeyEvent.META_DOWN_MASK, "GoBookmark8Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_8, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "GoBookmark8Win", "Editor");
            HotKey.addMap(KeyEvent.VK_8, java.awt.event.KeyEvent.META_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark8Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_8, java.awt.event.KeyEvent.CTRL_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark8Win", "Editor");

            HotKey.addMap(KeyEvent.VK_9, java.awt.event.KeyEvent.META_DOWN_MASK, "GoBookmark9Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_9, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "GoBookmark9Win", "Editor");
            HotKey.addMap(KeyEvent.VK_9, java.awt.event.KeyEvent.META_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark9Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_9, java.awt.event.KeyEvent.CTRL_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark9Win", "Editor");

            HotKey.addMap(KeyEvent.VK_0, java.awt.event.KeyEvent.META_DOWN_MASK, "GoBookmark0Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_0, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "GoBookmark0Win", "Editor");
            HotKey.addMap(KeyEvent.VK_0, java.awt.event.KeyEvent.META_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark0Mac", "Editor");
            HotKey.addMap(KeyEvent.VK_0, java.awt.event.KeyEvent.CTRL_DOWN_MASK|java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "SetBookmark0Win", "Editor");
            
            
            
            HotKey.addMap(KeyEvent.VK_A, 0, "Button1_1_pressed", false);
            HotKey.addMap(KeyEvent.VK_A, 0, "Button1_1_released", true);
            HotKey.addMap(KeyEvent.VK_S, 0, "Button1_2_pressed", false);
            HotKey.addMap(KeyEvent.VK_S, 0, "Button1_2_released", true);
            HotKey.addMap(KeyEvent.VK_D, 0, "Button1_3_pressed", false);
            HotKey.addMap(KeyEvent.VK_D, 0, "Button1_3_released", true);
            HotKey.addMap(KeyEvent.VK_F, 0, "Button1_4_pressed", false);
            HotKey.addMap(KeyEvent.VK_F, 0, "Button1_4_released", true);

            HotKey.addMap(KeyEvent.VK_LEFT, 0, "Joy1_Left_pressed", false);
            HotKey.addMap(KeyEvent.VK_LEFT, 0, "Joy1_Left_released", true);
            HotKey.addMap(KeyEvent.VK_RIGHT, 0, "Joy1_Right_pressed", false);
            HotKey.addMap(KeyEvent.VK_RIGHT, 0, "Joy1_Right_released", true);
            HotKey.addMap(KeyEvent.VK_UP, 0, "Joy1_Up_pressed", false);
            HotKey.addMap(KeyEvent.VK_UP, 0, "Joy1_Up_released", true);
            HotKey.addMap(KeyEvent.VK_DOWN, 0, "Joy1_Down_pressed", false);
            HotKey.addMap(KeyEvent.VK_DOWN, 0, "Joy1_Down_released", true);
            HotKey.addMap(KeyEvent.VK_C, 0, "SpinnerButton_1_pressed", false);
            HotKey.addMap(KeyEvent.VK_V, 0, "SpinnerButton_2_pressed", true);
            HotKey.addMap(KeyEvent.VK_C, 0, "SpinnerButton_1_released", false);
            HotKey.addMap(KeyEvent.VK_V, 0, "SpinnerButton_2_released", true);
            
            HotKey.addMap(KeyEvent.VK_Y, 0, "Spinner_Left_pressed", false);
            HotKey.addMap(KeyEvent.VK_Y, 0, "Spinner_Left_released", true);
            HotKey.addMap(KeyEvent.VK_X, 0, "Spinner_Right_pressed", false);
            HotKey.addMap(KeyEvent.VK_X, 0, "Spinner_Right_released", true);
            
            HotKey.addMap(KeyEvent.VK_Q, 0, "Button2_1_pressed", false);
            HotKey.addMap(KeyEvent.VK_Q, 0, "Button2_1_released", true);
            HotKey.addMap(KeyEvent.VK_W, 0, "Button2_2_pressed", false);
            HotKey.addMap(KeyEvent.VK_W, 0, "Button2_2_released", true);
            HotKey.addMap(KeyEvent.VK_E, 0, "Button2_3_pressed", false);
            HotKey.addMap(KeyEvent.VK_E, 0, "Button2_3_released", true);
            HotKey.addMap(KeyEvent.VK_R, 0, "Button2_4_pressed", false);
            HotKey.addMap(KeyEvent.VK_R, 0, "Button2_4_released", true);

            HotKey.addMap(KeyEvent.VK_J, 0, "Joy2_Left_pressed", false);
            HotKey.addMap(KeyEvent.VK_J, 0, "Joy2_Left_released", true);
            HotKey.addMap(KeyEvent.VK_L, 0, "Joy2_Right_pressed", false);
            HotKey.addMap(KeyEvent.VK_L, 0, "Joy2_Right_released", true);
            HotKey.addMap(KeyEvent.VK_I, 0, "Joy2_Up_pressed", false);
            HotKey.addMap(KeyEvent.VK_I, 0, "Joy2_Up_released", true);
            HotKey.addMap(KeyEvent.VK_M, 0, "Joy2_Down_pressed", false);
            HotKey.addMap(KeyEvent.VK_M, 0, "Joy2_Down_released", true);
            
            HotKey.addMap(KeyEvent.VK_P, 0, "Pause/Toggle", "Vecxi");
            HotKey.addMap(KeyEvent.VK_O, 0, "Overlay/Toggle", "Vecxi");
            HotKey.addMap(KeyEvent.VK_1, 0, "VecX QuickSave", "Vecxi");
            HotKey.addMap(KeyEvent.VK_2, 0, "VecX QuickLoad", "Vecxi");
            HotKey.addMap(KeyEvent.VK_B, 0, "RingbufferToggle", "Vecxi");            
            HotKey.addMap(KeyEvent.VK_P, java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "Panel/Toggle", "Vecxi");
            HotKey.addMap(KeyEvent.VK_F, java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "FullScreen/Toggle", "Vecxi");
            HotKey.addMap(KeyEvent.VK_Q, 0, "Quit vecxi", "Vecxi");
            
            
            
            
            HotKey.addMap(KeyEvent.VK_F3, 0, "Search next", "Editor");
            HotKey.addMap(KeyEvent.VK_F3, java.awt.event.KeyEvent.SHIFT_DOWN_MASK, "Search previous", "Editor");

            HotKey.addMap(KeyEvent.VK_S, java.awt.event.KeyEvent.META_DOWN_MASK, "SaveMac", "Editor");
            HotKey.addMap(KeyEvent.VK_S, java.awt.event.KeyEvent.CTRL_DOWN_MASK, "SaveWin", "Editor");
    }
    
    
    
    public String getKeyString() 
    {
        return getKeyStroke().toString();
    }
    public static void addMap(int e, int m, String n, boolean or)
    {
        HotKey hk = new HotKey( e,  m,  n, null,(JTextComponent)null, or);
        hotkeyList.add(hk);
        allMappings.put(n, hk);
    }
    public static void addMap(int e, int m, String n, String w)
    {
        HotKey oldVal = allMappings.get(n);
        if (oldVal != null)
            hotkeyList.remove(oldVal);

        HotKey hk = new HotKey( e,  m,  n, null,(JTextComponent)null);
        hk.where = w;
        hotkeyList.add(hk);
        allMappings.put(n, hk);
    }
    public HotKey(String n, Action a, JTextComponent ed)
    {
        HotKey hk = allMappings.get(n);
        if (hk == null)
            return;
        event = hk.event;
        mask = hk.mask;
        name = hk.name;
        onRelease = hk.onRelease;
        action = a;
        editor = ed;
        addKeysToEditor();
    }    
    public HotKey(String n, Action a, JPanel p)
    {
        HotKey hk = allMappings.get(n);
        if (hk == null)
            return;
        event = hk.event;
        mask = hk.mask;
        name = hk.name;
        onRelease = hk.onRelease;
        action = a;
        panel = p;
        addKeysToPanel();
    }
    private HotKey(int e, int m, String n, Action a, JTextComponent ed)
    {
        this( e,  m,  n,  a,  ed, false);
    }
    private HotKey(int e, int m, String n, Action a, JTextComponent ed, boolean or)
    {
        event = e;
        mask = m;
        name = n;
        action = a;
        editor = ed;
        onRelease = or;
        addKeysToEditor();
    }
    private HotKey(int e, int m, String n, Action a, JPanel p)
    {
        this( e,  m,  n,  a,  p, false);
    }
    private HotKey(int e, int m, String n, Action a, JPanel p, boolean or)
    {
        event = e;
        mask = m;
        name = n;
        action = a;
        panel = p;
        addKeysToPanel();
    }
    public KeyStroke getKeyStroke()
    {
        return KeyStroke.getKeyStroke(event, mask, onRelease);
    }
    private void addKeysToEditor()
    {
        if (!VideConfig.hotKeysEnabled) return;
        
        if (editor==null) return;
        editor.getInputMap().put(getKeyStroke(), name);
        if (action != null)
            editor.getActionMap().put(name, action);
    }
    private void addKeysToPanel()
    {
        if (!VideConfig.hotKeysEnabled) return;

        if (panel==null) return;
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(getKeyStroke(), name);
        if (action != null)
            panel.getActionMap().put(name, action);
    }  
}