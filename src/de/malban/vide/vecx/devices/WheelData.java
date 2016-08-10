/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import java.awt.Color;
import java.io.Serializable;

/**
 *
 * @author malban
 */
public class WheelData implements Serializable{
    // angle of 0 start of black
    // angles are "counted" clockwise
    public String name;
    public int id;
    public double indexAngle;
    public double[] startAngle;
    public Color[] colors;

}
