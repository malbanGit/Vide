/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.gui.components;

import java.awt.*;
import javax.swing.*;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.Stroke;
/**
 *
 * @author Malban
 */
public class OutlineArrow extends JComponent
{
    public Point start=new Point(0,0);
    public Point end=new Point(0,0);
    public float lineThickness = 15.0f;
    public float innerOuterRatio = 3f/10f;
    public Color strokeColor= new Color(0,0,0);
    public Color fillColor= new Color(231,41,8);
    public float headSize = 0.423f;
    public String label = "TEST";
    public java.awt.Font labelFont = null;
  /**
   * Draws an arrow on the given Graphics2D context
   * @param g The Graphics2D context to draw on
   * @param x The x location of the "tail" of the arrow
   * @param y The y location of the "tail" of the arrow
   * @param xx The x location of the "head" of the arrow
   * @param yy The y location of the "head" of the arrow
   */

   
    public OutlineArrow()
    {
        setOpaque(false);
    }
    @Override
    public int getHeight() {return 1500;}
    @Override
    public int getWidth() {return 1500;}
    @Override
    public boolean isVisible() {return true;}
    public void drawArrow( Graphics2D g)
  {
    int x = start.x;
    int y = start.y;
    int xx = end.x;
    int yy = end.y;

    float arrowWidth = lineThickness;
    float theta = headSize;
    int[] xPoints = new int[ 3 ] ;
    int[] yPoints = new int[ 3 ] ;
    float[] vecLine = new float[ 2 ] ;
    float[] vecLeft = new float[ 2 ] ;
    float fLength;
    float th;
    float ta;
    float baseX, baseY ;

    xPoints[ 0 ] = xx ;
    yPoints[ 0 ] = yy ;

    // build the line vector
    vecLine[ 0 ] = (float)xPoints[ 0 ] - x ;
    vecLine[ 1 ] = (float)yPoints[ 0 ] - y ;

    // build the arrow base vector - normal to the line
    vecLeft[ 0 ] = -vecLine[ 1 ] ;
    vecLeft[ 1 ] = vecLine[ 0 ] ;

    // setup length parameters
    fLength = (float)Math.sqrt( vecLine[0] * vecLine[0] + vecLine[1] * vecLine[1] ) ;
    th = arrowWidth / ( 2.0f * fLength ) ;
    ta = arrowWidth / ( 2.0f * ( (float)Math.tan( theta ) / 2.0f ) * fLength ) ;

    // find the base of the arrow
    baseX = ( (float)xPoints[ 0 ] - ta * vecLine[0]);
    baseY = ( (float)yPoints[ 0 ] - ta * vecLine[1]);

    // build the points on the sides of the arrow
    xPoints[ 1 ] = (int)( baseX + th * vecLeft[0] );
    yPoints[ 1 ] = (int)( baseY + th * vecLeft[1] );
    xPoints[ 2 ] = (int)( baseX - th * vecLeft[0] );
    yPoints[ 2 ] = (int)( baseY - th * vecLeft[1] );

    float innerReduce=lineThickness*innerOuterRatio;
    g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    Stroke lineStroke = new BasicStroke(lineThickness, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND);
    Stroke lineFill = new BasicStroke(lineThickness-innerReduce, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND);

    // outline
    g.setStroke(lineStroke);
    g.setColor(strokeColor);
    g.drawLine( x, y, (int)baseX, (int)baseY ) ;
    for (int i=0; i<3;i++)
    {
        g.drawLine( xPoints[i%3], yPoints[i%3], xPoints[(i+1)%3], yPoints[(i+1)%3]) ;
    }

    // and overpaint the outline with the inner fillings
    g.setStroke(lineFill);
    g.setColor(fillColor);
    for (int i=0; i<3;i++)
    {
        g.drawLine( xPoints[i%3], yPoints[i%3], xPoints[(i+1)%3], yPoints[(i+1)%3]) ;
    }
    // otherwise the head is noct completly filled!
    g.fillPolygon( xPoints, yPoints, 3 ) ;

    if ((label==null) || (label.length()==0)) 
    {
        
        g.drawLine( (int)(x), (int)(y), (int)(baseX), (int)(baseY) ) ;
        return;
    }
    if (labelFont==null)
        labelFont = g.getFont();
    else
        g.setFont(labelFont);
    FontMetrics metrics = g.getFontMetrics();

    java.awt.geom.Rectangle2D bounds = metrics.getStringBounds(label, g);
    java.awt.geom.Rectangle2D boundsM = metrics.getStringBounds("n", null);
    int labelWidthInPixels = (int) bounds.getWidth();
    int labelHeightInPixels = (int) bounds.getHeight();

    // for other than magic fonts perhaps an "M" mast be added
    int allWidthInPixels = (int) bounds.getWidth()+1*(int)boundsM.getWidth();
    int allHeightInPixels = (int) bounds.getHeight()+1*(int)boundsM.getHeight()/2;

    int xm = start.x+(end.x - start.x)/2;
    int ym = start.y+(end.y - start.y)/2;
    int sx = xm-(allWidthInPixels/2);
    int sy = ym-(allHeightInPixels/2);

    g.setStroke(lineStroke);
    g.setColor(strokeColor);
    g.fillArc(sx, sy, allWidthInPixels, allHeightInPixels, 0, 360);

    allWidthInPixels -=(innerReduce);
    allHeightInPixels -=(innerReduce);
    sx+=(innerReduce)/2;
    sy+=(innerReduce)/2;
    g.setColor(fillColor);
    g.fillArc(sx, sy, allWidthInPixels, allHeightInPixels, 0, 360);
    g.setStroke(lineFill);
    g.setColor(fillColor);
    g.drawLine( (int)(x), (int)(y), (int)(baseX), (int)(baseY) ) ;

    sx-=labelWidthInPixels/2;
    sy-=labelHeightInPixels/2;
    g.setColor(strokeColor);
    xm = start.x+(end.x - start.x)/2;
    ym = start.y+(end.y - start.y)/2;

    sx = xm-(labelWidthInPixels/2);
    sy = ym+(labelHeightInPixels/4);
    g.drawString(label, sx, sy);
  }
  public @Override void paintComponent (Graphics g)
  {
    drawArrow((Graphics2D) g);
  }
}
