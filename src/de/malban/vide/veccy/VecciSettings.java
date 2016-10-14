/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.veccy;

import java.io.Serializable;

/**
 *
 * @author malban
 */
public class VecciSettings implements Serializable
{
    public boolean isGrid = true;
    public int gridSize=0;
    public int scaleSlider = 21;
    public int singleVecciScaleSlider = 21;
    public int singleVecciX = 0;
    public int singleVecciY = 0;
    public int singleVecciH = 600;
    public int singleVecciW = 600;
    public boolean hex = true;
    public boolean db = true;
}
