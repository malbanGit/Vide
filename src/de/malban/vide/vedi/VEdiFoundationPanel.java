/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import de.malban.Global;
import de.malban.vide.vedi.panels.BinaryPanel;
import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.util.syntax.entities.ASM6809FileMaster;
import de.malban.util.syntax.entities.C6809FileMaster;
import java.awt.Component;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Point;
import java.io.File;
import java.io.PrintStream;
import java.io.Serializable;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import javax.swing.SwingUtilities;

/**
 *
 * @author malban
 */
public abstract class VEdiFoundationPanel extends javax.swing.JPanel implements
        Windowable, Stateable{
    private static int UID_BASE = 0;
    public final int UID = (UID_BASE++);
    public JFrame getFrame()
    {
        return (CSAMainFrame)mParent;
    }
    protected VediSettings settings = new VediSettings();
    protected CSAView mParent = null;
    protected javax.swing.JMenuItem mParentMenuItem = null;
    protected int mClassSetting=0;

    public abstract String getID();

    protected boolean wrapped = false;
    public class MyCloseListener implements CloseListener {

        private String tabName;
        JTabbedPane jTabbedPane1;

        public MyCloseListener(String tabName, JTabbedPane j) {
            this.tabName = tabName;
            this.jTabbedPane1 = j;
        }
        public void renameTo(String newFilename)
        {
            tabName=newFilename;
        }

        public String getTabName() {
            return tabName;
        }
        public boolean closeRequested(CloseEvent evt) 
        {
            int index = jTabbedPane1.indexOfTab(getTabName());
            if (index >= 0) 
            {
                // TODO ask if save is needed etc
                if (VEdiFoundationPanel.this.closeRequested(tabName))
                {
                    Component comp = jTabbedPane1.getComponentAt(index);
                    if (comp instanceof EditorPanel)
                    {
                        EditorPanel edi = (EditorPanel) comp;
                        edi.stopColoring();
                    }
                    if (comp instanceof BinaryPanel)
                    {
                        BinaryPanel edi = (BinaryPanel) comp;
                        edi.deinit();
                    }
                    deselectInTree(getTabName());
                    
                    jTabbedPane1.removeTabAt(index);
                    // It would probably be worthwhile getting the source
                    // casting it back to a JButton and removing
                    // the action handler reference ;)
                    evt.source.removeCloseListerner(this);
                    evt.source.removeUIListerner();
                }

            }
            return true;
        }
    }     
    public static VEdiFoundationPanel getVedi(Component o)
    {
        do
        {
            if (o instanceof VEdiFoundationPanel) return (VEdiFoundationPanel)o;
            o = o.getParent();
            
        } while (o != null);
        
        return null;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}
    @Override
    public void closing()
    {
        deinit();
    }
    @Override public boolean isIcon()
    {
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        if (frame.getInternalFrame(this) == null) return false;
        return frame.getInternalFrame(this).isIcon();
    }
    @Override public void setIcon(boolean b)
    {
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        if (frame.getInternalFrame(this) == null) return;
        try
        {
            frame.getInternalFrame(this).setIcon(b);
        }
        catch (Throwable e){}
    }
    @Override
    public void setParentWindow(CSAView jpv)
    {
        mParent = jpv;
    }
    @Override
    public void setMenuItem(javax.swing.JMenuItem item)
    {
        mParentMenuItem = item;
        mParentMenuItem.setText(getID());

    }
    @Override
    public javax.swing.JMenuItem getMenuItem()
    {
        return mParentMenuItem;
    }
    @Override
    public javax.swing.JPanel getPanel()
    {
        return this;
    }
    abstract public void deinit();
    abstract public void init();

    ASM6809FileMaster asmInfo;
    C6809FileMaster cInfo;
    
    public ASM6809FileMaster getAsmInfo()
    {
        return asmInfo;
    }
    public C6809FileMaster getCInfo()
    {
        return cInfo;
    }
    protected void initSyntax()
    {
        asmInfo = ASM6809FileMaster.getInstance(UID);
        cInfo = C6809FileMaster.getInstance(UID);
    }
    protected void deinitSyntax()
    {
        ASM6809FileMaster.removeInstance(UID);
        C6809FileMaster.removeInstance(UID);
    }
    

    public CustomOutputStream asmMessagesOut;
    public CustomOutputStream asmErrorOut;
    public CustomOutputStream asmListOut;
    public CustomOutputStream asmSymbolOut;
    PrintStream asmList;
    PrintStream asmMessages;
    PrintStream asmError;
    PrintStream asmSymbol;
    /**
     * Creates new form VEdiFoundationPanel
     */
    public VEdiFoundationPanel() {
        // ASM Info stream!
        asmMessagesOut = new CustomOutputStream();
        asmMessages = new PrintStream(asmMessagesOut);
        asmMessagesOut.setCallback(new FlushListener()
        {
            public void wasFlushed(final FlushEvent ev)
            {
                SwingUtilities.invokeLater(new Runnable()
                {
                    public void run()
                    {
                        printASMMessage(ev.newlyFlushedText, ASM_MESSAGE_INFO);
                    }
                });                    
            }
        });
        // ASM Error stream!
        asmErrorOut = new CustomOutputStream();
        asmError = new PrintStream(asmErrorOut);
        asmErrorOut.setCallback(new FlushListener()
        {
            int stateType = ASM_MESSAGE_ERROR;
            public void wasFlushed(final FlushEvent ev)
            {
                SwingUtilities.invokeLater(new Runnable()
                {
                    public void run()
                    {
                        if (ev.newlyFlushedText.indexOf("++++++")>=0)
                            stateType = ASM_MESSAGE_WARNING;
                        if (ev.newlyFlushedText.indexOf("******")>=0)
                            stateType = ASM_MESSAGE_ERROR;
                        if (ev.newlyFlushedText.indexOf("######")>=0)
                            stateType = ASM_MESSAGE_OPTIMIZATION;
                        
                        printASMMessage(ev.newlyFlushedText, stateType);
                    }
                });                    
            }
        });
        // ASM List stream!
        asmListOut = new CustomOutputStream();
        asmList = new PrintStream(asmListOut);
        asmListOut.setCallback(new FlushListener()
        {
            public void wasFlushed(final FlushEvent ev)
            {
                SwingUtilities.invokeLater(new Runnable()
                {
                    public void run()
                    {
                        printASMList(ev.newlyFlushedText, ASM_LIST);
                    }
                });                    
            }
        });
        // ASM Symbol stream!
        asmSymbolOut = new CustomOutputStream();
        asmSymbol = new PrintStream(asmSymbolOut);
        asmSymbolOut.setCallback(new FlushListener()
        {
            public void wasFlushed(final FlushEvent ev)
            {
                SwingUtilities.invokeLater(new Runnable()
                {
                    public void run()
                    {
                        printASMList(ev.newlyFlushedText, ASM_SYMBOL);
                    }
                });                    
            }
        });
//        initScheduler();
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 400, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables
    protected void addCloseButton(JTabbedPane jTabbedPane1, String name)
    {
        // add close button to TAB
        // see: http://stackoverflow.com/questions/11553112/how-to-add-close-button-to-a-jtabbedpane-tab
        int index = jTabbedPane1.indexOfTab(name);
        JPanel pnlTab = new JPanel(new GridBagLayout());
        pnlTab.setOpaque(false);
        JLabel lblTitle = new JLabel(name+"  ");
//        lblTitle.setForeground(new Color(0,150,0,255));
        CloseButton btnClose = new CloseButton();
//        btnClose.setForeground(Color.black);

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.weightx = 1;

        pnlTab.add(lblTitle, gbc);

        gbc.gridx++;
        gbc.weightx = 0;
        pnlTab.add(btnClose, gbc);

        jTabbedPane1.setTabComponentAt(index, pnlTab);

        btnClose.addCloseListerner(new VediPanel.MyCloseListener(name, jTabbedPane1) );
    }

    public String getSettingsName()
    {
        return "Vedi.ser";
    }
    protected boolean loadSettings()
    {
        if (!isLoadSettings()) return true;
        VediSettings s;
        try
        {
            s = (VediSettings) CSAMainFrame.deserialize(Global.mainPathPrefix+"serialize"+File.separator+getSettingsName());
            settings = s;
            settings.adjustOS();
            if (settings == null) return false;
        }
        catch (Throwable e)
        {
            return false;
        }
        return true;
    }
    public boolean isLoadSettings()
    {
        return true;
    }
    protected boolean saveSettings()
    {
        if (!isLoadSettings()) return true;
        try
        {
            settings.relativePaths();
            CSAMainFrame.serialize(settings, Global.mainPathPrefix+"serialize"+File.separator+getSettingsName());
        }
        catch (Throwable e)
        {
            return false;
        }
        return true;
    }
    abstract public void printMessage(String s);
    abstract public void printWarning(String s);
    abstract public void printError(String s);
    abstract public void printASMList(String s, int type);
    abstract public void printASMMessage(String s, int type);
    abstract protected boolean closeRequested(String tabName);
    
    abstract public void doQuickHelp(String s, String f2);
    abstract public void tabChanged(boolean b);
    abstract public void changeFileName(String s, String f2);
    abstract public void processIncludeLine(String s);
    abstract public void processWord(String s);
    abstract public void requestSearchFocus();
    abstract protected void deselectInTree(String name);
    abstract public void run();
    abstract public void debug();
    

    public static final int ASM_MESSAGE_INFO = 0;
    public static final int ASM_MESSAGE_ERROR = 1;
    public static final int ASM_MESSAGE_WARNING = 2;
    public static final int ASM_MESSAGE_OPTIMIZATION = 3;
    
    public static final int ASM_LIST = 2;
    public static final int ASM_SYMBOL = 3;
    public Point getEditorPos()
    {
        Point p = new Point();
        return p;
    }
}
