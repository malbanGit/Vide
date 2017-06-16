/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.graphics;

import java.awt.Color;
import java.io.Serializable;

/**
 *
 * @author malban
 */
public class VectorColors implements Serializable
{
    public static Color VECCI_BACKGROUND_COLOR = Color.BLACK;
    public static Color VECCI_VECTOR_FOREGROUND_COLOR = new Color(255,255,255,255); // not used, vectors have "own" color
    public static Color VECCI_GRID_COLOR = new Color(50,50,50,128);
    public static Color VECCI_FRAME_COLOR = new Color(0,255,255,255);
    public static Color VECCI_CROSS_COLOR = Color.ORANGE;
    public static Color VECCI_CROSS_DRAG_COLOR = Color.GREEN;
    public static Color VECCI_VECTOR_RELATIVE_COLOR = new Color(255,0,255,255);
    public static Color VECCI_VECTOR_HIGHLIGHT_COLOR = new Color(255,50,255,255);
    public static Color VECCI_VECTOR_SELECTED_COLOR = new Color(50,50,255,255);
    public static Color VECCI_VECTOR_DRAG_COLOR = new Color(255,255,0,255);
    public static Color VECCI_POS_COLOR = new Color(200,255,200,255);
    public static Color VECCI_MOVE_COLOR = new Color(50,50,155,255);
    public static Color VECCI_POINT_JOINED_COLOR = new Color(150,50,255,255);
    public static Color VECCI_POINT_HIGHLIGHT_COLOR = new Color(255,50,255,255);
    public static Color VECCI_POINT_SELECTED_COLOR = new Color(50,50,255,255);
    public static Color VECCI_VECTOR_ENDPOINT_COLOR = Color.red;
    
    
    public static Color VECCI_DRAG_AREA_COLOR = new Color(0,200,0,50);
    public static Color VECCI_X_AXIS_COLOR = Color.BLUE;
    public static Color VECCI_Y_AXIS_COLOR = Color.GREEN;
    public static Color VECCI_Z_AXIS_COLOR = Color.MAGENTA;
    
    public static Color VECCI_VECTOR_BACKGROUND_COLOR = new Color(50,50,50,128);
}
