/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.gui.components;

/**
 *
 * @author Malban
 * Taken from: http://java.sun.com/developer/JDCTechTips/2001/tt1220.html
 * THX!
 */
import java.awt.*;
import javax.swing.*;
import javax.swing.event.*;
import java.lang.reflect.*;

public class OverlaylPanel extends JPanel {

  // using special glass pane is for use in fullscrren mode
  JGlassPanel glass = new JGlassPanel();
 
  JRootPane rootPane;
  Component desktop;
  public OverlaylPanel(JRootPane r, Component d)
  {
        setOpaque(false);
        setDoubleBuffered(false);
        super.setVisible(false);
        setForeground(Color.white);
        setBackground(new Color(0,0,0,200));
        rootPane = r;
        desktop = d;
  }
    @Override
    public void paintComponent(java.awt.Graphics g)
    {
        g.setColor(new Color(0,0,0,200));
        g.fillRect(0, 0, getWidth(), getHeight());
        super.paintComponent(g);
    }

  // found somewhere in forums of the www
  void repair( java.awt.Container  c)
  {
    if (c instanceof java.awt.Container)
    for (int j=0;j<((java.awt.Container)c).getComponentCount();j++)
    {
        final java.awt.Component mc = ((java.awt.Container)c).getComponent(j);
        repair((java.awt.Container)mc);
    }
    if (c instanceof JComboBox)
    {
        JComboBox cbo = (JComboBox)c;
        cbo.setLightWeightPopupEnabled(false);
        try {
                Class cls = Class.forName("javax.swing.PopupFactory");
                Field field = cls.getDeclaredField("forceHeavyWeightPopupKey");
                field.setAccessible(true);
                cbo.putClientProperty(field.get(null), Boolean.TRUE);
        } catch (Exception e1) {e1.printStackTrace();}
    }
  }

  private boolean isCombo(Object s)
  {
      Component p=null;
      if (s instanceof Component) p = (Component)s; else return false;
      do
      {
          if (p instanceof JComboBox) return true;
          p=p.getParent();
      }while (p != null);
      return false;
  }

  public void init(JRootPane rootPane, Component desktop)
  {
    // this is for combo boxes in Windowed mode!
    repair(this);
    initGlass();

    // Size frame
    Dimension size = getPreferredSize();
    Dimension rootSize = desktop.getSize();

    setBounds((rootSize.width - size.width) / 2, (rootSize.height - size.height) / 2, size.width, size.height);
    desktop.validate();

    // Add modal internal frame to glass pane
    glass.add(this);

    // Change glass pane to our panel
    rootPane.setGlassPane(glass);

    // Show glass pane, then modal dialog
    glass.setVisible(true);
  }

  private void initGlass()
  {
    // create opaque glass pane
    glass.setLayout(null);
    glass.setOpaque(false);

    // Attach mouse listeners
    MouseInputAdapter adapter = new MouseInputAdapter(){};
    glass.addMouseListener(adapter);
    glass.addMouseMotionListener(adapter);
  }

    @Override
  public void setVisible(boolean value)
  {
        super.setVisible(value);
        if (value)
        {
            init(rootPane, desktop);
        }
        else
        {
            if (glass != null)
            {
                glass.setVisible(false);
                glass.removeAll();
                
            }
            
        }
        updateUI();
        validate();
        repaint();
  }
    @Override
  public boolean isOptimizedDrawingEnabled()
  {
      return false;
  }



  // paint pop ups on glass pane, since they normally appear in a layer below glass pane!
  // see
  /**
   *
http://www.pushing-pixels.org/?p=95
An additional implementation of a glass pane that respects the lightweight popup
        menus for our scenario might do the following after painting the validation
        overlays (sample implementation in
        org.pushingpixels.validation.glasspane.ValidationGlassPaneForPopups):
https://pushingpixels.dev.java.net/source/browse/pushingpixels/src/org/pushingpixels/validation/glasspane/
Starting from the root pane
Go over all components recursively
If a component is a JPopupMenu, is showing and is visible
Paint it on the Graphics passed to the paintComponent() of the glass pane
   *
   *
   * https://pushingpixels.dev.java.net/source/browse/pushingpixels/src/org/pushingpixels/validation/#dirlist
http://www.pushing-pixels.org/?p=90

   */
  class JGlassPanel extends JPanel
  {

    @Override
    protected void paintComponent(Graphics g)
    {
        Point myLoc = this.getLocationOnScreen();
        Component startPoint = SwingUtilities.getRootPane(this);
        Point startLoc = startPoint.getLocationOnScreen();
        int dx = startLoc.x - myLoc.x;
        int dy = startLoc.y - myLoc.y;
        Graphics2D g2d = (Graphics2D) g.create();
        g2d.translate(dx, dy);
        JRootPane rootPane = SwingUtilities.getRootPane(this);
        paintPopupMenus(rootPane, rootPane, g2d);
        g2d.dispose();
    }

    public void paintPopupMenus(JRootPane rootPane, Component comp, Graphics g)
    {
        if (comp instanceof JPopupMenu)
        {
            JPopupMenu jpm = (JPopupMenu) comp;
            if (jpm.isShowing() && jpm.isVisible())
            {
                Graphics2D g2d = (Graphics2D) g.create();
                Point rootPaneLoc = rootPane.getLocationOnScreen();
                Point popupLoc = jpm.getLocationOnScreen();
                g2d.translate(popupLoc.x - rootPaneLoc.x, popupLoc.y - rootPaneLoc.y);
                jpm.paint(g2d);
                g2d.dispose();
            }
        }
        if (comp instanceof Container)
        {
            Container cont = (Container) comp;
            for (int i = 0; i < cont.getComponentCount(); i++)
            {
                paintPopupMenus(rootPane, cont.getComponent(i), g);
            }
        }
    }
  }
}
