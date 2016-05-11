/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 *
 *
 *
 * NOT USED!
 */

package de.malban.gui;



//#condition polish.midp || polish.usePolishGui
/*http://www.koders.com/java/fidC8F9F7FA81EF89A3584DEC6435B86AC04B906520.aspx?s=FileIOStream
 * Created on 09-Nov-2004 at 00:32:59.
 *
 * Copyright (c) 2004-2005 Robert Virkus / Enough Software
 *
 * This file is part of J2ME Polish.
 *
 * J2ME Polish is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * J2ME Polish is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with J2ME Polish; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Commercial licenses are also available, please
 * refer to the accompanying LICENSE.txt or visit
 * http://www.j2mepolish.org for details.
 */

import java.awt.Graphics;
import java.awt.Image;

/**
 * <p>Is used for a performant showing of String with a bitmap font.</p>
 *
 * <p>Copyright Enough Software 2004, 2005</p>

 * <pre>
 * history
 *        09-Nov-2004 - rob creation
 * </pre>
 * @author Robert Virkus, j2mepolish@enough.de
 */

 /*
 * Last modified on 25.01.2006 by Radu Zah, Butterfly-effected, raduzah@yahoo.com.
 *
 * Problem 1 description: a text that needed more than 20 lines caused an ArrayIndexOutOfBounds exception.
 * Reason: The lineWidths array had an hardcoded size of 20 elements.
 * Resolution: Added a method that increases the length of the array by creating a new array with the size of
 *	the old array + a grow factor and copies the element to the new array. (See increaseShortArraySize(short src[], byte growFactor))
 *
 * Problem 2 description: the RIGHT and HCENTER orientation didn't work correctly, this was more obvious on the RIGHT orientation where
 *	the text wasn't aligned on the right.
 * Reason: on the layout method, the line widths weren't computed correctly (this is why the LEFT orientation didn't have this problem,
 * because it doesn't use the lineWidths). The space width wasn't substracted from the current line width even if it was changed to a
 * line break and thus it is not displayed.
 * Resolution: substracted the space width from the current line width when a line break was included. Instead of line
 *	<i>currentLineWidth -= lastSpaceWidth;</i> I used <i>currentLineWidth -= (lastSpaceWidth + this.actualCharacterWidths[ this.spaceIndex ]);</i>.
 *
 * I added a new method that returns a copy of the usedCharactersWidths array to have a more closer look on how the String
 *	is actually displayed. because of this I made the ABSOLUTE_LINE_BREAK and ARTIFICAL_LINE_BREAK constants public.
 *
 * Also, I removed the private final short[] originalLineIndeces data member because was never used inside the class and it couldn't been
 * used from outside since it was private.
 */
public class BitMapFontViewer {

	public final static byte	ABSOLUTE_LINE_BREAK = -2;
	public final static byte	ARTIFICAL_LINE_BREAK = -3;
	private final Image image;
	private final short[] xPositions;
	private final byte[] usedCharactersWidths;
	private final int fontHeight;
	private int verticalPadding;
	private final int spaceIndex;
	private int height;
	private int width;
	private int numberOfLines;
	private short[] lineWidths;
	private final int[] indeces;
	private final byte[] actualCharacterWidths;
	private int orientation;

	/**
	 * Views a specific input string with a specific bitmap font.
	 *
	 * @param image the basic font-image
	 * @param indeces array of the x-positions of the to-be-displayed characters
	 * @param xPositions array of the x-positions of the to-be-displayed characters
	 * @param characterWidths array of the widths of the to-be-displayed characters
	 * @param fontHeight the height of the font
	 * @param spaceIndex the index of the space character
	 * @param verticalPadding the padding between two lines
	 *
	 */
	public BitMapFontViewer(Image image, int[] indeces, short[] xPositions, byte[] characterWidths, int fontHeight, int spaceIndex, int verticalPadding ) {
		this.image = image;
		this.indeces = indeces;
		this.actualCharacterWidths = characterWidths;
		this.spaceIndex = spaceIndex;
		this.lineWidths = new short[ 20 ];
		this.verticalPadding = verticalPadding;
		this.xPositions = new short[ indeces.length ];
		this.usedCharactersWidths = new byte[ indeces.length ];
		short currentLineWidth = 0;
		short maxLineWidth = 0;
		short linesIndex = 0;
		for (int i = 0; i < indeces.length; i++) {
			int index = indeces[i];
			//System.out.println("character [" + i + "] is index " + index );
			if (index == -1) {
				// ignore, this is a character which is not available in the character-map
			} else if (index == ABSOLUTE_LINE_BREAK) {
				// this is a line-break
				if (currentLineWidth > maxLineWidth) {
					maxLineWidth = currentLineWidth;
				}
				this.lineWidths[ linesIndex ] = currentLineWidth;
				currentLineWidth = 0;
				// mark the character as absolute line-break:
				this.usedCharactersWidths[i] = ABSOLUTE_LINE_BREAK;
				linesIndex++;
				//now check not to exceed the lineWidths array limit //use a grow factor of 10
				if (linesIndex >= this.lineWidths.length) this.lineWidths = increaseShortArraySize(this.lineWidths, (byte)10);
			} else {
				// this is a normal character
				this.xPositions[i] = xPositions[ index ];
				byte characterWidth = characterWidths[ index ];
				this.usedCharactersWidths[i] = characterWidth;
				currentLineWidth += characterWidth;
			}
		}
		// store the width of the last-line:
		this.lineWidths[ linesIndex ] = currentLineWidth;
		if ( currentLineWidth > maxLineWidth ) {
			maxLineWidth = currentLineWidth;
		}
		this.numberOfLines = linesIndex + 1;
		this.height = this.numberOfLines * (fontHeight + verticalPadding) - verticalPadding;
		this.width = maxLineWidth;
		this.fontHeight = fontHeight;
	}



	/**
	 * Paints this viewer on the screen.
	 *
	 * @param x the x-position for the text.
	 *          When the orientation is LEFT, x defines the left-border;
	 *          when the orientation is RIGHT, x defines the rigth border;
	 *          when the orientation is HCENTER, x defines the middle between left and right border.
	 * @param y the top y-position of the first line.
	 * @param g the graphics object
	 */
	public void paint( int x, int y, Graphics g ) {
		int clipX = g.getClipBounds().x;
		int clipY =  g.getClipBounds().y;
		int clipWidth =  g.getClipBounds().width;
		int clipHeight =  g.getClipBounds().height;
		int clipXEnd = clipX + clipWidth;
		int startX = x;
		boolean isLayoutRight = false;
		boolean isLayoutCenter = false;
		if (isLayoutCenter) {
			x = startX - (this.lineWidths[ 0 ] / 2);
		} else if (isLayoutRight) {
			x = startX - this.lineWidths[ 0 ];
		}
		int lineIndex = 0;
		for (int i = 0; i < this.xPositions.length; i++ ) {
			byte characterWidth = this.usedCharactersWidths[i];
			//System.out.println("character-width[" + i + "] = " + characterWidth + " xPos=" + this.xPositions[i]);
			if (characterWidth == 0) {
				continue;
			} else if (characterWidth < 0) {
				// this is a line-break:
				lineIndex++;
				if (isLayoutCenter) {
					x = startX - (this.lineWidths[ lineIndex ] / 2);
				} else if (isLayoutRight) {
					x = startX - this.lineWidths[ lineIndex ];
				} else {
					x = startX;
				}
				y += this.fontHeight + this.verticalPadding;
				continue;
			} else if (x >= clipXEnd) {
				// this character is outside of the clipping area:
				continue;
			}
			g.clipRect( x, y, characterWidth, this.fontHeight );
			int imageX = x - this.xPositions[i];
			//System.out.println( "clipping " + x + ", " + y + ", " + characterWidth + ", " + this.fontHeight + ")   imageStartX=" +( x - this.xPositions[i]) + " imageX=" + imageX);
			g.drawImage( this.image, imageX, y ,null);
			x += characterWidth;
			// reset clip:
			g.setClip(clipX, clipY, clipWidth, clipHeight);
		}

	}

	/**
	 * Retrieves the width needed for this viewer.
	 *
	 * @return the width in pixels
	 */
	public int getWidth() {
		return this.width;
	}

	/**
	 * Retrieves the height needed for this viewer.
	 *
	 * @return the height in pixels
	 */
	public int getHeight() {
		return this.height;
	}


	/**
	 * Layouts this text-viewer.
	 *
	 * @param firstLineWidth the available width for the first line
	 * @param lineWidth the available width for the following lines
	 * @param paddingVertical the space between lines
	 * @param orientationSetting the orientation of this viewer, either Grapics.LEFT, Graphics.RIGHT or Graphics.HCENTER
	 */
	public void layout( int firstLineWidth, int lineWidth, int paddingVertical, int orientationSetting ) {
		this.orientation = orientationSetting;
		this.verticalPadding = paddingVertical;
		// remove all existing artificial line-breaks first.
		int lineIndex = 0;
		short currentLineWidth = 0;
		short maxLineWidth = 0;
		int lastSpaceIndex = -1;
		int lastSpaceWidth = 0;
		int lineStartIndex = 0;
		for (int i = 0; i < this.usedCharactersWidths.length; i++ ) {
			byte characterWidth = this.usedCharactersWidths[i];
			if ( characterWidth == ARTIFICAL_LINE_BREAK) {
				// restore original character width:
				characterWidth = this.actualCharacterWidths[ this.indeces[i] ];
				this.usedCharactersWidths[i] = characterWidth;
			} else if (characterWidth == ABSOLUTE_LINE_BREAK) {
				// this is an absolute linebreak (\n)
				this.lineWidths[ lineIndex ] = currentLineWidth;
				if (currentLineWidth > maxLineWidth) {
					maxLineWidth = currentLineWidth;
				}
				lineStartIndex = (i + 1);
				lineIndex++;
				//now check not to exceed the lineWidths array limit //use a grow factor of 10
				if (lineIndex >= this.lineWidths.length) this.lineWidths = increaseShortArraySize(this.lineWidths, (byte)10);
				currentLineWidth = 0;
				continue;
			}

			// this is a normal character
			int index = this.indeces[i];
			if (index == this.spaceIndex) {
				lastSpaceIndex = i;
				lastSpaceWidth = currentLineWidth;
			}
			currentLineWidth += characterWidth;
			if (currentLineWidth > firstLineWidth) {
				// we need to include an artificial line-break:
				if (lastSpaceIndex > lineStartIndex ) {
					this.usedCharactersWidths[ lastSpaceIndex ] = ARTIFICAL_LINE_BREAK;
					lineStartIndex = lastSpaceIndex + 1;
					this.lineWidths[ lineIndex ] = (short) lastSpaceWidth;
					if (lastSpaceWidth > maxLineWidth) {
						maxLineWidth = (short) lastSpaceWidth;
					}
					currentLineWidth -= (lastSpaceWidth + this.actualCharacterWidths[ this.spaceIndex ]);
					lineIndex++;
					//now check not to exceed the lineWidths array limit //use a grow factor of 10
					if (lineIndex >= this.lineWidths.length) this.lineWidths = increaseShortArraySize(this.lineWidths, (byte)10);
				// } else {
					// System.out.println("Unable to break line without any prior space");
				}
			}
			firstLineWidth = lineWidth;
		}
		// store the width of the last-line:
		this.lineWidths[ lineIndex ] = currentLineWidth;
		if ( currentLineWidth > maxLineWidth ) {
			maxLineWidth = currentLineWidth;
		}
		this.numberOfLines = lineIndex + 1;
		this.width = maxLineWidth;
		this.height = this.numberOfLines * (this.fontHeight + paddingVertical) - paddingVertical;
	}

	/**
	 * Returns the height of used font.
	 *
	 * @return the height of the bitmap-font in pixels.
	 */
	public int getFontHeight() {
		return this.fontHeight;
	}

	/**
	 * Retrieves the number of lines which are used to display the embedded text.
	 *
	 * @return the number of lines.
	 */
	public int getNumberOfLines() {
		return this.numberOfLines;
	}

	/**
	 * Increases the size of o short array with a given grow factor. It creates a new array with the size
	 * src.length + growFactor and copies the elements of src array into the new array.
	 *
	 * @param src the array that needs a larger size.
	 * @param growFactor the grow factor.
	 * @return the increased array.
	 */
	private short[] increaseShortArraySize(short src[], byte growFactor)
	{
		short dest[] = new short[src.length + growFactor];
		System.arraycopy(src, 0, dest, 0, src.length);
		return dest;
	}

	/**
	 *	Returns the used character widths. This is usefull to have information about the actual
	 *	position of each character. You can modify the array because only a copy is returned.
	 *
	 * @return a copy of the internal byte array representing the widths of the included characters
	 */
	public byte[] getUsedCharactersWidths()
	{
		byte ret[] = new byte[this.usedCharactersWidths.length];
		System.arraycopy(this.usedCharactersWidths, 0, ret, 0, ret.length);
		return ret;
	}
}
