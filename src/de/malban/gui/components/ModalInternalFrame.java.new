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
import de.malban.config.Configuration;
import java.awt.*;
import java.awt.event.InvocationEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.beans.PropertyVetoException;
import java.lang.reflect.Field;
import java.util.ArrayList;
import javax.swing.*;
import javax.swing.event.MouseInputAdapter;

public class ModalInternalFrame extends JDialog 
{

  public static int isModalCount=0;
  public boolean isModal=false;
  private JButton mExit = null;
  private String mExitText = null;
  // using special glass pane is for use in fullscrren mode
  boolean exitButtonUsed = false;
  ArrayList<JButton> allExitButtons=null;
  String namedExit="";
  
  boolean manualExit = false;
  boolean manualExitState = false;
  public void modalExit(boolean b)
  {
      manualExit = true;
      manualExitState = b;
      setVisible(false);
  }
  public boolean isManualOkExit()
  {
      return manualExit && manualExitState;
  }
  
 
  public String getNamedExit()
  {
      return namedExit;
  }
  public boolean isExitButtonUsed()
  {
      return exitButtonUsed;
  }
  
  public ModalInternalFrame(String title, JRootPane rootPane, Component desktop, final JDialog pane)
  {
    super(Configuration.getConfiguration().getMainFrame(), title, true);
    // ImageIcon i = new ImageIcon(Configuration.getConfiguration().getCurrentTheme().getImage("BlueIconSmall.png"));
    // setFrameIcon(i);
    init( title,  rootPane,  desktop, pane.getContentPane());
  }
  public ModalInternalFrame(String title, JRootPane rootPane, Component desktop, final Container pane)
  {
   this(title, rootPane, desktop, pane, null, null, null);
  }
  public ModalInternalFrame(String title, JRootPane rootPane, Component desktop, final Container pane, JButton exit)
  {
   this(title, rootPane, desktop, pane, exit, null, null);
  }
  public ModalInternalFrame(String title, JRootPane rootPane, Component desktop, final Container pane, String buttonName)
  {
   this(title, rootPane, desktop, pane, null, buttonName, null);
  }
  public ModalInternalFrame(String title, JRootPane rootPane, Component desktop, final Container pane, JButton exit, String buttonName)
  {
    this(title, rootPane, desktop, pane, null, buttonName, null);
      
  }
  public ModalInternalFrame(String title, JRootPane rootPane, Component desktop, final Container pane, JButton exit, String buttonName, ArrayList<JButton> aeb)
  {
    super(Configuration.getConfiguration().getMainFrame(), title, true);
    mExit = exit;
    allExitButtons = aeb;
    mExitText = buttonName;
    
    if (mExit!=null)
    {
        mExit.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                setVisible(false);
            }
        });
        
    }
    if (aeb != null)
    {
        
        for (JButton b: aeb)
        {
            b.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    String buttonText = b.getText();
                    if (buttonText != null)
                    {
                        if (buttonText.equals(mExitText))
                           setVisible(false);
                    }

                    namedExit = b.getName();
                    if (namedExit==null) 
                        namedExit = "";
                    setVisible(false);
                }
            });
        }
    }
    
    
    
    // ImageIcon i = new ImageIcon(Configuration.getConfiguration().getCurrentTheme().getImage("BlueIconSmall.png"));
    // setFrameIcon(i);
    init( title,  rootPane,  desktop, pane);
  }

  public ModalInternalFrame(String title, JRootPane
      rootPane, Component desktop, JOptionPane pane) {
    super(Configuration.getConfiguration().getMainFrame(), title, true);
    cpane = pane;
    // Add in option pane
    getContentPane().add(pane, BorderLayout.CENTER);

    // Size frame
    Dimension size = getPreferredSize();
    Dimension rootSize = desktop.getSize();

    setBounds((rootSize.width - size.width) / 2, (rootSize.height - size.height) / 2, size.width, size.height);
    desktop.validate();
  }

  Container cpane=null;

  boolean isSystemDialog = false;
  public void setSystemDialog(boolean b)
  {
      isSystemDialog = b;
  }
  boolean isSystemDialog()
  {
      return isSystemDialog;
  }
  
  java.awt.event.ActionListener al = null;
  private void init(String title, JRootPane rootPane, Component desktop, final Container pane)
  {
    setTitle(title);
    // this is for combo boxes in Windowed mode!
    cpane = pane;
    // Add in option pane
//    getContentPane().add(pane, BorderLayout.CENTER);

    add(pane, BorderLayout.CENTER);


    // Size frame
    Dimension size = getPreferredSize();
    Dimension rootSize = desktop.getSize();

    setBounds((rootSize.width - size.width) / 2, (rootSize.height - size.height) / 2, size.width, size.height);
    desktop.validate();

  }

   public void setClosed(boolean t)
   {
       
   }
   public void setClosable(boolean t)
   {
       
   }
  


}
