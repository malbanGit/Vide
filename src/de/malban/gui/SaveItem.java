/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.gui;

import java.io.Serializable;
import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class SaveItem implements Serializable{
    public int x,y;
    public int w,h;
    public int screenNo = 0;
    public boolean iconified;
    public String name;
    ArrayList<String> names;
}
