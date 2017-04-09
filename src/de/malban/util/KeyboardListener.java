/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util;

import java.awt.KeyEventDispatcher;
import java.awt.KeyboardFocusManager;
import java.awt.event.KeyEvent;
/**
 *
 * @author malban
 */
public class KeyboardListener {

    private static boolean isShiftDown;
    private static boolean isCTRLDown;
    private static boolean isALTDown;
    

    static {
        KeyboardFocusManager.getCurrentKeyboardFocusManager().addKeyEventDispatcher(
            new KeyEventDispatcher() {
                public boolean dispatchKeyEvent(KeyEvent e) {
                    isShiftDown = e.isShiftDown();
                    isCTRLDown = e.isControlDown();
                    isALTDown = e.isAltDown();
                    return false;
                }
            });
    }

    public static boolean isAltDown() {
        return isALTDown;
    }
    public static boolean isShiftDown() {
        return isShiftDown;
    }
    public static boolean isControlDown() {
        return isCTRLDown;
    }

}