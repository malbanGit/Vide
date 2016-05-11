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
import java.lang.reflect.Field;
import javax.swing.*;
import javax.swing.event.MouseInputAdapter;

public class ModalPanel extends JPanel {

  public static boolean isModal=false;

  // using special glass pane is for use in fullscrren mode
  JGlassPanel glass = new JGlassPanel();
  
  java.awt.Component oldGlass = null;
  
  protected JRootPane rootPane;
  protected Component desktop;
  protected ModalPanel()
  {
    setOpaque(false);
    setDoubleBuffered(false);
    super.setVisible(false);
    setBackground(new Color(0,0,0,0));
  }
    public void setEnvironment(JRootPane r, Component d)
    {
        rootPane = r;
        desktop = d;
    }
  public ModalPanel(JRootPane r, Component d)
  {
    setOpaque(false);
    setDoubleBuffered(false);
    super.setVisible(false);
    setBackground(new Color(0,0,0,0));
    rootPane = r;
    desktop = d;
  }
    @Override
    public void paintComponent(java.awt.Graphics g)
    {
        g.setColor(getBackground());
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
        } catch (Exception e1) {}
    }
  }

  private boolean isCombo(Object s)
  {
      Component p;
      if (s instanceof Component) p = (Component)s; else return false;
      do
      {
          if (p instanceof JComboBox) return true;
          p=p.getParent();
      }while (p != null);
      return false;
  }

  java.awt.event.ActionListener al = null;
  Container cpane=null;
  public void init(JRootPane rootPane, Component desktop)
  {
    // this is for combo boxes in Windowed mode!
    repair(this);
    initGlass();
    cpane = this;

    // TODO: right now closing on every!!! button click!
    // Define close behavior
    al = new java.awt.event.ActionListener() {
            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) 
            {
                boolean exit = true;
                if (isCombo(evt.getSource())) exit = false;

                if (evt.getSource() instanceof JButton)
                {
                    JButton b = (JButton)evt.getSource();
                    if (b!=null)
                    {
                        if (b.getAction() != null)
                        {
                            String test = b.getAction().toString();
                            // action command file chose directory up... I know its bad, any ideas?
                            if (test.toUpperCase().indexOf("PARENT")!=-1) exit=false;
                        }
                    }
                }
               if (exit)
               {
                    ModalPanel.this.setVisible(false);
                    glass.setVisible(false);
                    setButtonListener(ModalPanel.this, this, false);
               }
            }};

    setButtonListener(ModalPanel.this, al, true);

    // Change frame border
    putClientProperty("JInternalFrame.frameType", "optionDialog");

    // Size frame
    Dimension size = getPreferredSize();
    Dimension rootSize = desktop.getSize();

//    setBounds((rootSize.width - size.width) / 2, (rootSize.height - size.height) / 2, size.width, size.height);
    super.setBounds(getBounds().x, getBounds().y, size.width, size.height);
    desktop.validate();

    // Add modal internal frame to glass pane
    glass.add(this);

    // Change glass pane to our panel
    oldGlass = rootPane.getGlassPane();
    rootPane.setGlassPane(glass);

    // Show glass pane, then modal dialog
    glass.setVisible(true);
  }
  /*
  public void setBounds(int x, int y, int w, int h)
  {
      super.setBounds(x, y, w, h);
      
      if (!glass.isVisible()) return;
      glass.setVisible(false);
      glass.remove(this);
      glass.add(this);

      // Change glass pane to our panel
      rootPane.setGlassPane(glass);

      // Show glass pane, then modal dialog
      glass.setVisible(true);
  }
    */
    void setButtonListener(java.awt.Component c, java.awt.event.ActionListener al, boolean set)
    {
        if (c instanceof JButton)
        {
            if(set)
                ((JButton) c).addActionListener(al);
            else
                ((JButton) c).removeActionListener(al);
        }
        else if (c instanceof java.awt.Container)
        {
            for (int j=0;j<((java.awt.Container)c).getComponentCount();j++)
            {
                final java.awt.Component mc = ((java.awt.Container)c).getComponent(j);
                if (mc instanceof java.awt.Container)
                {
                    setButtonListener(mc, al, set);
                }
            }
        }
    }

  private void initGlass()
  {
    // create opaque glass pane
    glass.setLayout(null);
    glass.setOpaque(false);
    glass.setName("JPortalGlass");

    // Attach mouse listeners
    MouseInputAdapter adapter = new MouseInputAdapter(){};
    glass.addMouseListener(adapter);
    glass.addMouseMotionListener(adapter);
  }

    @Override
  public void setVisible(boolean value)
  {
      if (rootPane==null) return;
      if (desktop==null) return;
        super.setVisible(value);
        if (value)
        {
            init(rootPane, desktop);

            invalidate();
            updateUI();
            validate();
            repaint();
            
            desktop.invalidate();
            
            desktop.validate();
            desktop.repaint();

            
            startModal();
        }
        else
        {
            stopModal();
            if ((cpane !=null ) && (al != null))
                setButtonListener(cpane, al, false);
            if (glass != null)
                glass.setVisible(false);
            if (rootPane != null)
            if (oldGlass!=null)
            {
                rootPane.setGlassPane(oldGlass);
                if (oldGlass instanceof JGlassPanel) 
                {
                    // Show glass pane, then modal dialog
                    oldGlass.setVisible(true);
                }
                else if ((oldGlass.getName() != null) && (oldGlass.getName().equals("JPortalGlass")))
                {
                    oldGlass.setVisible(true);
                }
                 else
                 {
                    rootPane.setGlassPane(oldGlass);
                 }
            }
             else
             {
                rootPane.setGlassPane(oldGlass);
             }
        }
  }

  private synchronized void startModal()
  {
    try {
        if (!isModal) ModalInternalFrame.isModalCount++;
        isModal=true;
      if (SwingUtilities.isEventDispatchThread()) 
      {
        EventQueue theQueue = getToolkit().getSystemEventQueue();
        
        while (isVisible()) 
        {
          AWTEvent event = theQueue.getNextEvent();
          Object source = event.getSource();
          
          if (event instanceof ActiveEvent) 
          {
            ((ActiveEvent)event).dispatch();
          } 
          else if (source instanceof Component) 
          {
            ((Component)source).dispatchEvent( event);
          } 
          else if (source instanceof MenuComponent) 
          {
            ((MenuComponent)source).dispatchEvent( event);
          } 
          else 
          {
            System.err.println( "Unable to dispatch: " + event);
          }
        }
      }
      else 
      {
        while (isVisible()) 
        {
          wait();
        }
      }
    } catch (InterruptedException ignored)
    {
    }
  }

  private synchronized void stopModal()
  {
    if (isModal) ModalInternalFrame.isModalCount--;      
    isModal=false;
    notifyAll();
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
