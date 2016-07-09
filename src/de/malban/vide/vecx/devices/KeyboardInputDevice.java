/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.vide.vecx.VecX;
import de.malban.vide.vecx.VecXPanel;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import javax.swing.AbstractAction;
import static javax.swing.JComponent.WHEN_IN_FOCUSED_WINDOW;
import javax.swing.KeyStroke;

/**
 *
 * @author malban
 */
public class KeyboardInputDevice implements JoyportDevice
{
    VectrexJoyport joyport;
    VecXPanel panel;

    
    public KeyboardInputDevice(VecXPanel p)
    {
        panel = p;
        setupKeyEvents();
    }
    public void setJoyport(VectrexJoyport j)
    {
        joyport = j;
    }
    public void step(VecX vectrex)    
    {
    }    
    public void deinit()
    {
        joyport = null;
        deinitKeyEvents();
    }
    public void setInputMode(boolean i)
    {
    }
    private void setupKeyEvents()
    {
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_A,0, false), "Button1_1_pressed");
        panel.getActionMap().put("Button1_1_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton1(false, true); }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_S,0, false), "Button1_2_pressed");
        panel.getActionMap().put("Button1_2_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setButton2(false, true); }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_D,0, false), "Button1_3_pressed");
        panel.getActionMap().put("Button1_3_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setButton3(false, true); }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F,0, false), "Button1_4_pressed");
        panel.getActionMap().put("Button1_4_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setButton4(false, true); }});

        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_LEFT,0, false),  "Joy1_Left_pressed");
        panel.getActionMap().put("Joy1_Left_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setHorizontal(0, true); }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT,0, false), "Joy1_Right_pressed");
        panel.getActionMap().put("Joy1_Right_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setHorizontal(0xff, true); }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_UP,0, false),    "Joy1_Up_pressed");
        panel.getActionMap().put("Joy1_Up_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setVertical(0xff, true);  }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,0, false),  "Joy1_Down_pressed");
        panel.getActionMap().put("Joy1_Down_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setVertical(0, true);  }});

        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_A,0, true), "Button1_1_released");
        panel.getActionMap().put("Button1_1_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setButton1(true, true); }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_S,0, true), "Button1_2_released");
        panel.getActionMap().put("Button1_2_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setButton2(true, true); }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_D,0, true), "Button1_3_released");
        panel.getActionMap().put("Button1_3_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setButton3(true, true); }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F,0, true), "Button1_4_released");
        panel.getActionMap().put("Button1_4_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setButton4(true, true); }});

        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_LEFT,0, true),  "Joy1_Left_released");
        panel.getActionMap().put("Joy1_Left_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setHorizontal(0x80, true); }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT,0, true), "Joy1_Right_released");
        panel.getActionMap().put("Joy1_Right_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setHorizontal(0x80, true); }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_UP,0, true),    "Joy1_Up_released");
        panel.getActionMap().put("Joy1_Up_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setVertical(0x80, true); }});
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,0, true),  "Joy1_Down_released");
        panel.getActionMap().put("Joy1_Down_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (joyport != null) joyport.setVertical(0x80, true); }});
        
    }   
    private void deinitKeyEvents()
    {
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_A,0, false), null);
        panel.getActionMap().put("Button1_1_pressed", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_S,0, false), null);
        panel.getActionMap().put("Button1_2_pressed", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_D,0, false), null);
        panel.getActionMap().put("Button1_3_pressed", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F,0, false), null);
        panel.getActionMap().put("Button1_4_pressed", null);

        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_LEFT,0, false),  null);
        panel.getActionMap().put("Joy1_Left_pressed", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT,0, false), null);
        panel.getActionMap().put("Joy1_Right_pressed", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_UP,0, false),    null);
        panel.getActionMap().put("Joy1_Up_pressed", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,0, false), null);
        panel.getActionMap().put("Joy1_Down_pressed", null);

        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_A,0, true), null);
        panel.getActionMap().put("Button1_1_released", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_S,0, true), null);
        panel.getActionMap().put("Button1_2_released", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_D,0, true), null);
        panel.getActionMap().put("Button1_3_released", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F,0, true), null);
        panel.getActionMap().put("Button1_4_released", null);

        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_LEFT,0, true),  null);
        panel.getActionMap().put("Joy1_Left_released", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT,0, true), null);
        panel.getActionMap().put("Joy1_Right_released", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_UP,0, true),    null);
        panel.getActionMap().put("Joy1_Up_released", null);
        panel.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,0, true),  null);
        panel.getActionMap().put("Joy1_Down_released", null);        
    }   
    @Override
    public void updateInputDataFromDevice()
    {
    }
    @Override
    public void updateDeviceWithDataFromVectrex()
    {
    }
}
