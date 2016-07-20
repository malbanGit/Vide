/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.gui.HotKey;
import de.malban.vide.vecx.VecXPanel;
import static de.malban.vide.vecx.VecXPanel.DEVICE_KEYBOARD0;
import java.awt.event.ActionEvent;
import javax.swing.AbstractAction;

/**
 *
 * @author malban
 */
public class KeyboardInputDevice extends AbstractDevice
{
    public int getDeviceID()
    {
        return DEVICE_KEYBOARD0;
    }
    VecXPanel panel;
    
    int port = 0;
    public KeyboardInputDevice(VecXPanel p, int po)
    {
        panel = p;
        port = po;
        setupKeyEvents();
    }
    
    private void setupKeyEvents()
    {
        if (port == 0)
        {
            new HotKey("Button1_1_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton1(false, true); }}, panel);
            new HotKey("Button1_2_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton2(false, true); }}, panel);
            new HotKey("Button1_3_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton3(false, true); }}, panel);
            new HotKey("Button1_4_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton4(false, true); }}, panel);

            new HotKey("Button1_1_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton1(true, true); }}, panel);
            new HotKey("Button1_2_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton2(true, true); }}, panel);
            new HotKey("Button1_3_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton3(true, true); }}, panel);
            new HotKey("Button1_4_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton4(true, true); }}, panel);

            new HotKey("Joy1_Left_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(0, true); }}, panel);
            new HotKey("Joy1_Right_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(0xff, true); }}, panel);
            new HotKey("Joy1_Up_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0xff, true); }}, panel);
            new HotKey("Joy1_Down_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0, true); }}, panel);

            new HotKey("Joy1_Left_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(0x80, true); }}, panel);
            new HotKey("Joy1_Right_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(0x80, true); }}, panel);
            new HotKey("Joy1_Up_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0x80, true); }}, panel);
            new HotKey("Joy1_Down_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0x80, true); }}, panel);        
        }
        else if (port == 1)
        {
            new HotKey("Button2_1_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton1(false, true); }}, panel);
            new HotKey("Button2_2_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton2(false, true); }}, panel);
            new HotKey("Button2_3_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton3(false, true); }}, panel);
            new HotKey("Button2_4_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton4(false, true); }}, panel);

            new HotKey("Button2_1_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton1(true, true); }}, panel);
            new HotKey("Button2_2_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton2(true, true); }}, panel);
            new HotKey("Button2_3_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton3(true, true); }}, panel);
            new HotKey("Button2_4_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setButton4(true, true); }}, panel);

            new HotKey("Joy2_Left_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(0, true); }}, panel);
            new HotKey("Joy2_Right_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(0xff, true); }}, panel);
            new HotKey("Joy2_Up_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0xff, true); }}, panel);
            new HotKey("Joy2_Down_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0, true); }}, panel);

            new HotKey("Joy2_Left_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(0x80, true); }}, panel);
            new HotKey("Joy2_Right_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setHorizontal(0x80, true); }}, panel);
            new HotKey("Joy2_Up_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0x80, true); }}, panel);
            new HotKey("Joy2_Down_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) joyport.setVertical(0x80, true); }}, panel);        
        }
    }   

    @Override
    public String toString()
    {
        if (port == 0)
            return "Keyboard Input0";
        else if (port ==1) 
            return "Keyboard Input1";
        return "Keyboard Input?";
    }
}
