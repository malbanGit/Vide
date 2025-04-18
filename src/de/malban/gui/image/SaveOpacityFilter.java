/*
Copyright 2006 Jerry Huxtable

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package de.malban.gui.image;

import java.awt.*;
import java.awt.image.*;

/**
 * Sets the opacity (alpha) of every pixel in an image to a constant value.
 */
public class SaveOpacityFilter extends PointFilter {
	
	private int opacity;
	private int opacity24;

	/**
	 * Construct an OpacityFilter with 50% opacity.
	 */
	public SaveOpacityFilter() {
		this(0x88);
	}

	/**
	 * Construct an OpacityFilter with the given opacity (alpha).
	 * @param opacity the opacity (alpha) in the range 0..255
	 */
	public SaveOpacityFilter(int opacity) {
		setOpacity(opacity);
	}

	/**
	 * Set the opacity.
	 * @param opacity the opacity (alpha) in the range 0..255
     * @see #getOpacity
	 */
	public void setOpacity(int opacity) {
		this.opacity = opacity;
		opacity24 = opacity << 24;
	}
	
	/**
	 * Get the opacity setting.
	 * @return the opacity
     * @see #setOpacity
	 */
	public int getOpacity() {
		return opacity;
	}
	
        // csa changes:
        // dont set new opacity, when current opacity is smaller 
        // this is smoother on images, which have pixels which already have some alphas set!
	public int filterRGB(int x, int y, int rgb) 
        {
            int oldRGB = (rgb >>24)&0xff;
            if (oldRGB > opacity) 
                return (rgb & 0xffffff) | opacity24;
            return rgb;
	}

	public String toString() {
		return "Colors/Transparency...";
	}

}

