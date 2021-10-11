/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.gui.HotKey;
import de.malban.vide.VideConfig;
import de.malban.vide.vecx.VecX;
import de.malban.vide.vecx.VecXPanel;
import java.awt.event.ActionEvent;
import javax.swing.AbstractAction;

/**
 *
 * @author malban
 */
public class KeyboardSpinnerDevice extends AbstractDevice
{
    public static final int NONE = 0;
    public static final int RIGHT = 1;
    public static final int LEFT = 2;
    int moveDirection = NONE;
    
    int currentCount =0;
    
    int[] pinMoveLeft = {1, 3, 0, 2};
    int[] pinMoveRight = {2, 0, 3, 1};
    int out = 0;
    long lastCycles = 0;
    public void setJoyport(VectrexJoyport j)
    {
        super.setJoyport(j);
        currentCount = VideConfig.getConfig().minimumSpinnerChangeCycles;
        out = 0;
    }
    @Override
    public void step()
    {
        if (joyport == null) return;
        VecX vectrex = joyport.vecx;
        long c = vectrex.getCycles();
        int dif = (int)(c-lastCycles);
        lastCycles = c;
        currentCount -= dif;
        if (currentCount<=0)
        {
            currentCount = VideConfig.getConfig().minimumSpinnerChangeCycles;
            if (moveDirection==NONE) ;//out = 0;
            if (moveDirection==RIGHT) out = pinMoveRight[out];
            if (moveDirection==LEFT) out = pinMoveLeft[out];
            joyport.setButton1(!((out&0x01)==0x01), true);
            joyport.setButton2(!((out&0x02)==0x02), true);
        }
    }
    
    public int getDeviceID()
    {
        return VecXPanel.DEVICE_KEYBOARD_SPINNER;
    }
    public String getDeviceName()
    {
        return "keyboard spinner";
    }
    VecXPanel panel;
    
    public KeyboardSpinnerDevice(VecXPanel p)
    {
        panel = p;
        setupKeyEvents();
    }
    
    private void setupKeyEvents()
    {
        new HotKey("SpinnerButton_1_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton3(false, true); }}, panel);
        new HotKey("SpinnerButton_2_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton4(false, true); }}, panel);

        new HotKey("SpinnerButton_1_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton3(true, true); }}, panel);
        new HotKey("SpinnerButton_2_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (joyport != null) if (joyportIsInInputMode)joyport.setButton4(true, true); }}, panel);

        new HotKey("Spinner_Left_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  moveDirection = LEFT; }}, panel);
        new HotKey("Spinner_Right_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  moveDirection = RIGHT; }}, panel);

        new HotKey("Spinner_Left_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  moveDirection = NONE;currentCount=-1; }}, panel);
        new HotKey("Spinner_Right_released", new AbstractAction() { public void actionPerformed(ActionEvent e) {  moveDirection = NONE;currentCount=-1; }}, panel);
    }   

    @Override
    public String toString()
    {
        return "Spinner Keyboard";
    }
}
