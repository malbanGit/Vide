/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.gui.HotKey;
import de.malban.vide.vecx.VecXPanel;
import static de.malban.vide.vecx.VecXPanel.DEVICE_KEYBOARD_JOYSTICK0;
import static de.malban.vide.vecx.VecXStatics.JOYSTICK_CENTER;
import java.awt.event.ActionEvent;
import javax.swing.AbstractAction;

/**
 *
 * @author malban
 */
public class KeyboardJoystickDevice extends AbstractDevice
{
    public int getDeviceID()
    {
        return DEVICE_KEYBOARD_JOYSTICK0+keySet;
    }
    public String getDeviceName()
    {
        return "keyboard joystick";
    }
    VecXPanel panel;
    
    int keySet = 0;
    public KeyboardJoystickDevice(VecXPanel p, int po)
    {
        panel = p;
        keySet = po;
        setupKeyEvents();
    }
                

    private void setupKeyEvents()
    {
        if (keySet == 0)
        {
            new HotKey("Button1_1_pressed", new AbstractAction() {@Override public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton1(false, true); }}, panel);
            new HotKey("Button1_2_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton2(false, true); }}, panel);
            new HotKey("Button1_3_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton3(false, true); }}, panel);
            new HotKey("Button1_4_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton4(false, true); }}, panel);

            new HotKey("Button1_1_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton1(true, true); }}, panel);
            new HotKey("Button1_2_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton2(true, true); }}, panel);
            new HotKey("Button1_3_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton3(true, true); }}, panel);
            new HotKey("Button1_4_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton4(true, true); }}, panel);

            new HotKey("Joy1_Left_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) 
            {  
                if (joyport != null) joyport.setHorizontal(0, true); }}, panel);
            new HotKey("Joy1_Right_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(0xff, true); }}, panel);
            new HotKey("Joy1_Up_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0xff, true); }}, panel);
            new HotKey("Joy1_Down_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0, true); }}, panel);

            new HotKey("Joy1_Left_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(JOYSTICK_CENTER, true); }}, panel);
            new HotKey("Joy1_Right_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(JOYSTICK_CENTER, true); }}, panel);
            new HotKey("Joy1_Up_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(JOYSTICK_CENTER, true); }}, panel);
            new HotKey("Joy1_Down_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(JOYSTICK_CENTER, true); }}, panel);        
        }
        else if (keySet == 1)
        {
            new HotKey("Button2_1_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton1(false, true); }}, panel);
            new HotKey("Button2_2_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton2(false, true); }}, panel);
            new HotKey("Button2_3_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton3(false, true); }}, panel);
            new HotKey("Button2_4_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton4(false, true); }}, panel);

            new HotKey("Button2_1_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton1(true, true); }}, panel);
            new HotKey("Button2_2_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton2(true, true); }}, panel);
            new HotKey("Button2_3_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton3(true, true); }}, panel);
            new HotKey("Button2_4_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton4(true, true); }}, panel);

            new HotKey("Joy2_Left_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(0, true); }}, panel);
            new HotKey("Joy2_Right_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(0xff, true); }}, panel);
            new HotKey("Joy2_Up_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0xff, true); }}, panel);
            new HotKey("Joy2_Down_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0, true); }}, panel);

            new HotKey("Joy2_Left_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(JOYSTICK_CENTER, true); }}, panel);
            new HotKey("Joy2_Right_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(JOYSTICK_CENTER, true); }}, panel);
            new HotKey("Joy2_Up_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(JOYSTICK_CENTER, true); }}, panel);
            new HotKey("Joy2_Down_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(JOYSTICK_CENTER, true); }}, panel);        
        }
    }   

    @Override
    public String toString()
    {
        if (keySet == 0)
            return "Joystick Keyboard Keyset 0";
        else if (keySet ==1) 
            return "Joystick Keyboard Keyset 1";
        return "Keyboard Input?";
    }
}
