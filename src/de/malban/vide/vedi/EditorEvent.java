/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

/**
 *
 * @author malban
 */
public class EditorEvent {
    public static final int EV_CARET_CHANGED = 0;
    public static final int EV_KEY_TYPED = 1;
    public static final int EV_TEXT_CHANGED = 2;
    public static final int EV_TEXT_UNDO = 3;
    public static final int EV_TEXT_REDO = 4;
    
    EditorPanelFoundation source;
    int type;
}
