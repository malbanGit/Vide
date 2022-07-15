/*
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.veccy;

import com.sun.javafx.binding.StringFormatter;
import de.malban.Global; 
import de.malban.graphics.Face;
import javax.swing.table.AbstractTableModel;
import de.malban.config.Configuration;
import de.malban.graphics.GFXVectorAnimation;
import de.malban.event.EditMouseEvent;
import de.malban.gui.Windowable;
import de.malban.graphics.MousePressedListener;
import de.malban.graphics.GFXVector;
import de.malban.graphics.GFXVectorList;
import de.malban.graphics.Matrix4x4;
import de.malban.graphics.MouseMovedListener;
import de.malban.graphics.MouseReleasedListener;
import de.malban.graphics.SingleVectorPanel;
import de.malban.graphics.SingleVectorPanel.MyTableModel;
import static de.malban.graphics.SingleVectorPanel.SVP_SELECT_POINT;
import de.malban.graphics.VectorChangedListener;
import static de.malban.graphics.VectorColors.VECCI_X_AXIS_COLOR;
import static de.malban.graphics.VectorColors.VECCI_Y_AXIS_COLOR;
import static de.malban.graphics.VectorColors.VECCI_Z_AXIS_COLOR;
import de.malban.graphics.Vertex;
import static de.malban.graphics.Vertex.ARRAY_X;
import static de.malban.graphics.Vertex.ARRAY_Y;
import static de.malban.graphics.Vertex.ARRAY_Z;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.HotKey;
import de.malban.gui.components.CSAView;
import de.malban.gui.Scaler;
import de.malban.gui.Stateable;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.vide.VideConfig;
import de.malban.vide.assy.Asmj;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.script.ExportFrame;
import de.malban.vide.script.ImportFrame;
import de.malban.vide.veccy.gtest.HLines;
import de.malban.vide.vecx.VecXPanel;
import de.malban.vide.vedi.VediPanel;
import de.malban.vide.vedi.raster.VectorJPanel;
import de.muntjak.tinylookandfeel.Theme;
import java.awt.*;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.awt.event.ActionEvent;
import static java.awt.event.ActionEvent.SHIFT_MASK;
import java.awt.event.MouseEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.Serializable;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DecimalFormat;
import java.util.*;
import javax.swing.AbstractAction;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.event.TableModelEvent;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableCellRenderer;



/**
 *
 * @author malban
 */
public class VeccyPanel extends javax.swing.JPanel implements
        Windowable, MousePressedListener, MouseReleasedListener, MouseMovedListener, Stateable, VectorChangedListener 
{
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    public boolean isLoadSettings() { return true; }

    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private int inSetting=0;
    private boolean continueStarted = false;
    private boolean pointsOk = false;
    VideConfig config = VideConfig.getConfig();

    
    public static GFXVectorList buffer = new GFXVectorList();
    GFXVectorAnimation history = new GFXVectorAnimation();
    ArrayList<Face> faces = new ArrayList<Face>();
    int historyPos = 0;
    boolean historyAdded = false; // drag only one history
    public void preVectorChange()
    {
        addHistory();
    }
    public void postVectorChange()
    {
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
        verifyFaces();
    }
    void addHistory()
    {
        history.add(singleVectorPanel1.getForegroundVectorList().clone());
        historyPos = history.size()-1;
        jButtonUndo.setEnabled(historyPos>0);
        jButtonRedo.setEnabled(historyPos<history.size()-1);
    }
    void stepBackHistory()
    {
        if (historyPos<=0) return;

        // try not to double add
        if (historyPos == history.size()-1)
        {
            String s1 = singleVectorPanel1.getForegroundVectorList().clone().toString();
            String s2 = history.get(history.size()-1).toString();
            if (!s1.equals(s2))
                addHistory();
        }
        
        
        historyPos--;
        GFXVectorList list = history.get(historyPos);
        singleVectorPanel1.setForegroundVectorList(list.clone());
        initFaces();
        jButtonUndo.setEnabled(historyPos>0);
        jButtonRedo.setEnabled(historyPos<history.size()-1);
    }
    void stepForwardHistory()
    {
        if (historyPos>=history.size()-1) return;
        historyPos++;
        GFXVectorList list = history.get(historyPos);
        singleVectorPanel1.setForegroundVectorList(list.clone());
        initFaces();
        jButtonUndo.setEnabled(historyPos>0);
        jButtonRedo.setEnabled(historyPos<history.size()-1);
    }
    
    
    private GFXVectorAnimation currentAnimation = new GFXVectorAnimation();

    // the UID of the vectorlist in the collection that is currently selected
    // this is not the uid of the vectorlist that is beeing edited!
    // usually this is maximal a clone !
    int selectedAnimationFrameUID = -1;
    int preSelectedAnimationFrameUID = -1;

    // the vector that is CURRENTLY being build by the user 
    GFXVector buildingVector= new GFXVector();
    
    // rememeber the UID the current edited vectorlist was cloned from
    // prevents (amongs others) a double selection of the same list
    int lastSetUID = -1;
  
    String error="";
    String warning="";

    
    public static String SID = "Vector Editor";
    public String getID()
    {
        return SID;
    }
    @Override public String getFileID()
    {
        return de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replaceWhiteSpaces(SID, ""),":",""),"(",""),")","") ;
    }
    public VecciSettings settings = new VecciSettings();
    public Serializable getAdditionalStateinfo(){
        settings.gridSize = singleVectorPanel1.getGridWidth();
        settings.isGrid = singleVectorPanel1.isGrid();
        settings.scaleSlider = jSliderSourceScale.getValue();
        settings.avoidConnectMoreThan2 = GFXVectorList.avoidConnectMoreThan2;
        settings.db = GFXVectorList.db;
        settings.hex = GFXVectorList.hex;

        return settings;
    }
    public void setAdditionalStateinfo(Serializable ser)
    {
        settings = (VecciSettings) ser;
        GFXVectorList.db = settings.db;
        GFXVectorList.hex = settings.hex;
        GFXVectorList.avoidConnectMoreThan2 = settings.avoidConnectMoreThan2;
        
        
        jCheckBoxAvoidMoreThan2.setSelected(GFXVectorList.avoidConnectMoreThan2);
        jSliderSourceScale.setValue(settings.scaleSlider);

        int value = jSliderSourceScale.getValue();
        int max = jSliderSourceScale.getMaximum();
        jRadioButton3.setSelected(settings.db);
        jRadioButton4.setSelected(!settings.db);
        jRadioButton5.setSelected(settings.hex);
        jRadioButton6.setSelected(!settings.hex);

        double scale = value - ((max-1)/2);
        
        
        if (value <((max/2)+1))
        {
            int invScale = ((max/2)+2)-value;
            scale = 1.0/invScale;
        }
        jLabelScale.setText("Scale: "+new DecimalFormat("#.##").format(scale));
        jLabelMaxY.setText(""+Scaler.unscaleDoubleToInt(128, scale));
        jLabelMinY.setText("-"+Scaler.unscaleDoubleToInt(128, scale));
        jTextFieldGridWidth.setText(""+settings.gridSize);
        final double val = scale;
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                singleVectorPanel1.setScale(val);
                singleVectorPanel1.setGrid(settings.isGrid, settings.gridSize);
                singleVectorPanel1.sharedRepaint();
            }
        });
        
    }

    
    @Override
    public void closing()
    {
        deinit();
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
        mParentMenuItem.setText(SID);
    }
    @Override
    public javax.swing.JMenuItem getMenuItem()
    {
        return mParentMenuItem;
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
    public javax.swing.JPanel getPanel()
    {
        return this;
    }
    /**
     * Creates new form Panel
     */
    public VeccyPanel() {
        initComponents();

        new HotKey("Delete selected", new AbstractAction() { public void actionPerformed(ActionEvent e) { jMenuItemLineDeleteActionPerformed(null);}}, this);
        new HotKey("Mode change", new AbstractAction() { public void actionPerformed(ActionEvent e) { cycleMode();}}, this);
        new HotKey("UndoMac", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonUndoActionPerformed(null);}}, this);
        new HotKey("RedoMac", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonRedoActionPerformed(null);}}, this);
        new HotKey("UndoWin", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonUndoActionPerformed(null);}}, this);
        new HotKey("RedoWin", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonRedoActionPerformed(null);}}, this);
        
        new HotKey("SelectAllMac", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonSelectAllActionPerformed(null);}}, this);
        new HotKey("SelectAllWin", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonSelectAllActionPerformed(null);}}, this);
        new HotKey("CopyMac", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonCopyActionPerformed(null);}}, this);
        new HotKey("CopyWin", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonCopyActionPerformed(null);}}, this);
        new HotKey("PasteMac", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonPasteActionPerformed(null);}}, this);
        new HotKey("PasteWin", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonPasteActionPerformed(null);}}, this);
        new HotKey("CutMac", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonCutActionPerformed(null);}}, this);
        new HotKey("CutWin", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonCutActionPerformed(null);}}, this);
        
        if (Global.getOSName().toUpperCase().contains("MAC"))
        {
            HotKey.addMacDefaults(jTextFieldVectorCount);
            HotKey.addMacDefaults(jTextFieldGridWidth);
            HotKey.addMacDefaults(jTextFieldRotateZ);
            HotKey.addMacDefaults(jTextFieldRotateX);
            HotKey.addMacDefaults(jTextFieldRotateY);
            HotKey.addMacDefaults(jTextFieldRotateSteps);
            HotKey.addMacDefaults(jTextField4);
            HotKey.addMacDefaults(jTextField5);
            HotKey.addMacDefaults(jTextFieldPattern);
            HotKey.addMacDefaults(jTextFieldIntensity);
            HotKey.addMacDefaults(jTextFieldNeedSplit);
            HotKey.addMacDefaults(jTextFieldRotate2d);
            HotKey.addMacDefaults(jTextFieldScaleFactor);
            HotKey.addMacDefaults(jTextFieldBaseSize);
            HotKey.addMacDefaults(jTextFieldScaleFactor1);
            HotKey.addMacDefaults(jTextFieldExpandYZ);
            HotKey.addMacDefaults(jTextArea1);
            HotKey.addMacDefaults(jTextArea2);
            HotKey.addMacDefaults(jTextFieldPatternName);
            HotKey.addMacDefaults(jTextField8);
            HotKey.addMacDefaults(jTextField9);
            HotKey.addMacDefaults(jTextField10);
            HotKey.addMacDefaults(jTextAreaResult);
            HotKey.addMacDefaults(jTextFieldLabelListname);
            HotKey.addMacDefaults(jTextFieldResync);
            HotKey.addMacDefaults(jTextFieldAnimName);
            HotKey.addMacDefaults(jTextFieldResyncAnim);
            HotKey.addMacDefaults(jTextAreaResult1);
            HotKey.addMacDefaults(jTextFieldLabelListname1);
            HotKey.addMacDefaults(jTextFieldAnimName1);
            HotKey.addMacDefaults(jTextAreaResultSM);
            HotKey.addMacDefaults(jTextFieldLabelStackJumpName);
            HotKey.addMacDefaults(jTextField12);
            HotKey.addMacDefaults(jTextFieldLabelFactorName);
            HotKey.addMacDefaults(jTextFieldLabelListname2);
            HotKey.addMacDefaults(jTextField1);
            HotKey.addMacDefaults(jTextField2);
            HotKey.addMacDefaults(jTextField3);
        }
        
        
        
        jCheckBox1.setSelected(SingleVectorPanel.displayLen);
        // not done yet
        
        singleVectorPanel1.addSibbling(singleImagePanel2);
        singleVectorPanel1.addSibbling(singleImagePanel3);
        singleVectorPanel1.addSibbling(single3dDisplayPanel);
        single3dDisplayPanel.setSingleRepaint(true);
        
        // set axis on each panel
        singleVectorPanel1.setXMain();
        singleImagePanel2.setYMain();
        singleImagePanel3.setZMain();
        
        // add all listeners
        singleVectorPanel1.addMousePressedListener(this);
        singleVectorPanel1.addMouseMovedListener(this);
        singleVectorPanel1.addMouseReleasedListener(this);

        // add grid and scaling
        singleVectorPanel1.setGrid(jCheckBoxGrid.isSelected(), de.malban.util.UtilityString.Int0(jTextFieldGridWidth.getText()));        
        jSliderSourceScaleStateChanged(null);
        jSliderSourceScale1StateChanged(null); 

        jLabel11.setForeground(VECCI_X_AXIS_COLOR);
        jLabel15.setForeground(VECCI_Y_AXIS_COLOR);
        jLabel16.setForeground(VECCI_Z_AXIS_COLOR);

        jLabel10.setForeground(VECCI_X_AXIS_COLOR);
        jLabel12.setForeground(VECCI_Y_AXIS_COLOR);
        jLabel13.setForeground(VECCI_Z_AXIS_COLOR);

        jLabel14.setForeground(VECCI_X_AXIS_COLOR);
        jLabel17.setForeground(VECCI_Y_AXIS_COLOR);
        jLabel18.setForeground(VECCI_Z_AXIS_COLOR);
        
        FaceTableModel faceModel = new FaceTableModel();
        if (faceModel != null)
        {
            jTableFace.setModel(faceModel);
            resetFaceTable();
        }
        ListSelectionModel faceSelectionModel = jTableFace.getSelectionModel();

        faceSelectionModel.addListSelectionListener(new ListSelectionListener() 
        {
              public void valueChanged(ListSelectionEvent e) {
                faceSelectionChanged();
              }
        });        

        
        MyTableModel model = singleVectorPanel1.getTableModel();
        if (model != null)
        {
            jTable1.setModel(model);
            jTable1.getColumnModel().getColumn(1).setMaxWidth(50);
            jTable1.getColumnModel().getColumn(2).setMaxWidth(50);
            jTable1.tableChanged(new TableModelEvent(model));
        }

        
        
        
        // 2d
        jButton2dAxisActionPerformed(null);        

        ListSelectionModel cellSelectionModel = jTable1.getSelectionModel();

        cellSelectionModel.addListSelectionListener(new ListSelectionListener() 
        {
              public void valueChanged(ListSelectionEvent e) {
                tableSelectionChanged();
              }
        });        
        jTable1.setDefaultRenderer(Double.class, new DefaultTableCellRenderer()
        {
            @Override
            public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int col) 
            {
                Component c = super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, col);
                JLabel l = (JLabel)c;
                if (value == null) return c;
                int val = (int) ((double)((Double) value));
                
//                l = new JLabel();
                l.setText(""+val);
                l.setHorizontalAlignment(TRAILING);
                
                if (jRadioButtonSetPoint.isSelected())
                {
                    return l;
                }
                
                if (!jRadioButtonSelectPoint.isSelected())
                {
//                    return l;
                }

                if (table.getModel() instanceof MyTableModel)
                {
                    MyTableModel model = (MyTableModel)table.getModel();
                    GFXVector v = singleVectorPanel1.getForegroundVectorList().get(row);

                    if ((col == 1) || (col == 2)|| (col == 3))
                    {
                        if (isSelected)
                        {
                            l.setBackground(table.getSelectionBackground());
                        }
                        else if (v.start.selected)
                        {
                            l.setBackground(table.getSelectionBackground());
                        }
                        else
                        {
                            l.setBackground(table.getBackground());
                        }
                    }
                    
                    else if ((col == 4) || (col == 5)|| (col == 6))
                    {
                        if (isSelected)
                        {
                            l.setBackground(table.getSelectionBackground());
                        }
                        else if (v.end.selected)
                        {
                            l.setBackground(table.getSelectionBackground());
                        }
                        else
                        {
                            l.setBackground(table.getBackground());
                        }
                    }
                    else
                    {
                        if (isSelected)
                        {
                            l.setBackground(table.getSelectionBackground());
                        }
                        else
                        {
                            l.setBackground(table.getBackground());
                        }
                    }
                        
                    
                }
                return l;
            }   
        });        
    
        mClassSetting++;
        loadPatterns();
        if (knownPatterns.size() == 0)
        {
            fillPatternBox(knownPatterns);
            jComboBoxPatterns.setModel(new DefaultComboBoxModel(knownPatterns));
        }
        
        
        mClassSetting--;
        jComboBoxPatterns.setSelectedIndex(0);
        // use as 2d display
        single3dDisplayPanel1.setAxisAngleX(0);
        single3dDisplayPanel1.setAxisAngleY(0);
        single3dDisplayPanel1.setAxisAngleZ(0);
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 




    }
    VectorJPanel vPanel = null;
    public void deinit()
    {
        removeSBPanel();
        if (vPanel != null)
        {
            vPanel.setVeccy(null);
            vPanel = null;
        }
        removeUIListerner();
    }
    public void setVPanel(VectorJPanel v)
    {
        vPanel = v;
    }
    StoryboardPanelInterface sbPanel = null;
    public void setSBPanel(StoryboardPanelInterface sb)
    {
        sbPanel = sb;
    }
    public void removeSBPanel()
    {
        if (sbPanel != null)
        {
            sbPanel.setVeccy(null);
        }
        sbPanel = null;
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup1 = new javax.swing.ButtonGroup();
        jPopupMenuPoint = new javax.swing.JPopupMenu();
        jMenuItemJoin = new javax.swing.JMenuItem();
        jMenuItemHere = new javax.swing.JMenuItem();
        jMenuItemConnect = new javax.swing.JMenuItem();
        jMenuItemRip = new javax.swing.JMenuItem();
        jMenuItemDelete = new javax.swing.JMenuItem();
        jMenuItemPoint0 = new javax.swing.JMenuItem();
        jMenuItemMove = new javax.swing.JMenuItem();
        jPopupMenuLine = new javax.swing.JPopupMenu();
        jMenuItemLineDelete = new javax.swing.JMenuItem();
        jMenuItemDeleteNotSelected = new javax.swing.JMenuItem();
        jMenuItemInsertPoint = new javax.swing.JMenuItem();
        jMenuItemSwitch = new javax.swing.JMenuItem();
        jMenuItemRemovePoint = new javax.swing.JMenuItem();
        buttonGroup2 = new javax.swing.ButtonGroup();
        buttonGroup3 = new javax.swing.ButtonGroup();
        buttonGroup4 = new javax.swing.ButtonGroup();
        jPanel1 = new javax.swing.JPanel();
        jPanel5 = new javax.swing.JPanel();
        jTabbedPane2 = new javax.swing.JTabbedPane();
        jPanel10 = new javax.swing.JPanel();
        jCheckBoxHasPattern = new javax.swing.JCheckBox();
        jTextFieldPattern = new javax.swing.JTextField();
        jLabelPattern = new javax.swing.JLabel();
        jCheckBoxHasIntensity = new javax.swing.JCheckBox();
        jTextFieldIntensity = new javax.swing.JTextField();
        jLabelPattern1 = new javax.swing.JLabel();
        jButtonSetStyle = new javax.swing.JButton();
        jButtonSetSolid = new javax.swing.JButton();
        jButtonSetMove = new javax.swing.JButton();
        jPanel35 = new javax.swing.JPanel();
        jButtonRotate2d = new javax.swing.JButton();
        jTextFieldRotate2d = new javax.swing.JTextField();
        jButtonMirrorVertically = new javax.swing.JButton();
        jButtonMirrorHorizontally = new javax.swing.JButton();
        jLabel50 = new javax.swing.JLabel();
        jLabel53 = new javax.swing.JLabel();
        jButtonOneForwardSelection2 = new javax.swing.JButton();
        jLabel32 = new javax.swing.JLabel();
        jButtonShrink = new javax.swing.JButton();
        jButtonEnlarge = new javax.swing.JButton();
        jTextFieldScaleFactor = new javax.swing.JTextField();
        jCheckBox6 = new javax.swing.JCheckBox();
        jCheckBox7 = new javax.swing.JCheckBox();
        jCheckBox8 = new javax.swing.JCheckBox();
        jPanel11 = new javax.swing.JPanel();
        jTextFieldBaseSize = new javax.swing.JTextField();
        jLabel19 = new javax.swing.JLabel();
        jButtonCube = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jPanel37 = new javax.swing.JPanel();
        jScrollPane7 = new javax.swing.JScrollPane();
        jTableFace = new javax.swing.JTable();
        jButton1 = new javax.swing.JButton();
        jButton7 = new javax.swing.JButton();
        jLabel55 = new javax.swing.JLabel();
        jButton3 = new javax.swing.JButton();
        jTabbedPane4 = new javax.swing.JTabbedPane();
        jPanelModeSelect = new javax.swing.JPanel();
        jRadioButtonSetPoint = new javax.swing.JRadioButton();
        jRadioButtonSelectPoint = new javax.swing.JRadioButton();
        jRadioButtonSelectLine = new javax.swing.JRadioButton();
        jCheckBoxContinue = new javax.swing.JCheckBox();
        jCheckBoxPointsOk = new javax.swing.JCheckBox();
        jCheckBoxArrows = new javax.swing.JCheckBox();
        jCheckBoxPosition = new javax.swing.JCheckBox();
        jCheckBoxMoves = new javax.swing.JCheckBox();
        jTextField4 = new javax.swing.JTextField();
        jLabel70 = new javax.swing.JLabel();
        jLabel71 = new javax.swing.JLabel();
        jLabel72 = new javax.swing.JLabel();
        jTextField5 = new javax.swing.JTextField();
        jButton8 = new javax.swing.JButton();
        jButton9 = new javax.swing.JButton();
        jPanelShortCuts1 = new javax.swing.JPanel();
        jButton5 = new javax.swing.JButton();
        jButtonConnectWherePossible = new javax.swing.JButton();
        jButtonOrderVectorlist = new javax.swing.JButton();
        jButtonFillGaps = new javax.swing.JButton();
        jButtonRemoveDots = new javax.swing.JButton();
        jButtonFitByteRange = new javax.swing.JButton();
        jCheckBoxFraktion = new javax.swing.JCheckBox();
        jCheckBoxLine = new javax.swing.JCheckBox();
        jButtonOrderSplitWhereNeeded = new javax.swing.JButton();
        jTextFieldNeedSplit = new javax.swing.JTextField();
        jCheckBoxAvoidMoreThan2 = new javax.swing.JCheckBox();
        jButtonConnectWherePossible1 = new javax.swing.JButton();
        jCheckBox3dDots = new javax.swing.JCheckBox();
        jPanelShortCuts2 = new javax.swing.JPanel();
        jButtonDisconnectAll = new javax.swing.JButton();
        jButtonRemoveMove = new javax.swing.JButton();
        jButtonLongestPaths = new javax.swing.JButton();
        jButtonOptimizeSize = new javax.swing.JButton();
        jButtonRemoveDouble = new javax.swing.JButton();
        jButtonRemoveiDouble = new javax.swing.JButton();
        jButtonLongestPathsplus = new javax.swing.JButton();
        jCheckBoxRespectZero = new javax.swing.JCheckBox();
        jButtonRemoveDots1 = new javax.swing.JButton();
        jButtonLongestPaths1 = new javax.swing.JButton();
        jLabelFactor = new javax.swing.JLabel();
        jPanelShortcutsCollection = new javax.swing.JPanel();
        jTextFieldScaleFactor1 = new javax.swing.JTextField();
        jButtonEnlarge1 = new javax.swing.JButton();
        jButtonShrink1 = new javax.swing.JButton();
        jButtonFitByteRange1 = new javax.swing.JButton();
        jCheckBoxFraktion1 = new javax.swing.JCheckBox();
        single3dDisplayPanel = new de.malban.graphics.Single3dDisplayPanel();
        jSliderSourceScale1 = new javax.swing.JSlider();
        jToggleButtonPlayAnim = new javax.swing.JToggleButton();
        jTextFieldDelay = new javax.swing.JTextField();
        jLabelDelay = new javax.swing.JLabel();
        jTabbedPane6 = new javax.swing.JTabbedPane();
        jPanel22 = new javax.swing.JPanel();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel23 = new javax.swing.JPanel();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox3 = new javax.swing.JCheckBox();
        jCheckBox4 = new javax.swing.JCheckBox();
        jLabel1 = new javax.swing.JLabel();
        jTextFieldRotateZ = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jTextFieldRotateX = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        jTextFieldRotateY = new javax.swing.JTextField();
        jTextFieldRotateSteps = new javax.swing.JTextField();
        jButton4 = new javax.swing.JButton();
        jCheckBoxScaleToByte = new javax.swing.JCheckBox();
        jLabel33 = new javax.swing.JLabel();
        jCheckBox5 = new javax.swing.JCheckBox();
        jCheckBoxzrotdir = new javax.swing.JCheckBox();
        jCheckBoxxrotdir = new javax.swing.JCheckBox();
        jCheckBoxyrotdir = new javax.swing.JCheckBox();
        jButtonSelectionRotation = new javax.swing.JButton();
        jPanel24 = new javax.swing.JPanel();
        jLabel7 = new javax.swing.JLabel();
        jTextFieldMorphSteps = new javax.swing.JTextField();
        jButton6 = new javax.swing.JButton();
        jLabel8 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel20 = new javax.swing.JLabel();
        jLabel21 = new javax.swing.JLabel();
        jPanel14 = new javax.swing.JPanel();
        jButtonPathsAsScenario = new javax.swing.JButton();
        jLabelAnim = new javax.swing.JLabel();
        jPanel6 = new javax.swing.JPanel();
        jLabelMaxY = new javax.swing.JLabel();
        jLabelY0 = new javax.swing.JLabel();
        jLabelMinY = new javax.swing.JLabel();
        jSliderSourceScale = new javax.swing.JSlider();
        jLabelScale = new javax.swing.JLabel();
        jCheckBoxByteFrame = new javax.swing.JCheckBox();
        jPanelScroller = new javax.swing.JPanel();
        jButtonUp = new javax.swing.JButton();
        jButtonDown = new javax.swing.JButton();
        jButtonLeft = new javax.swing.JButton();
        jButtonRight = new javax.swing.JButton();
        jPanel18 = new javax.swing.JPanel();
        jLabelStartInX = new javax.swing.JLabel();
        jLabelCurrent = new javax.swing.JLabel();
        jTextFieldStartX = new javax.swing.JTextField();
        jTextFieldCurrentZ = new javax.swing.JTextField();
        jTextFieldCurrentY = new javax.swing.JTextField();
        jLabelCount = new javax.swing.JLabel();
        jTextFieldStartZ = new javax.swing.JTextField();
        jLabelX = new javax.swing.JLabel();
        jTextFieldStartY = new javax.swing.JTextField();
        jTextFieldVectorCount = new javax.swing.JTextField();
        singleVectorPanel1 = new de.malban.graphics.SingleVectorPanel();
        jTextFieldCurrentX = new javax.swing.JTextField();
        jCheckBoxGrid = new javax.swing.JCheckBox();
        jTextFieldGridWidth = new javax.swing.JTextField();
        jPanel31 = new javax.swing.JPanel();
        jButtonSelectAll = new javax.swing.JButton();
        jButtonSaveSelection = new javax.swing.JButton();
        jButtonInsertYM = new javax.swing.JButton();
        jButtonCut = new javax.swing.JButton();
        jButtonPaste = new javax.swing.JButton();
        jButtonCopy = new javax.swing.JButton();
        jButtonRedo = new javax.swing.JButton();
        jButtonUndo = new javax.swing.JButton();
        jButtonSave1 = new javax.swing.JButton();
        jButtonLoad = new javax.swing.JButton();
        jButtonOneForwardSelection1 = new javax.swing.JButton();
        jLabelMode = new javax.swing.JLabel();
        jCheckBox12 = new javax.swing.JCheckBox();
        jButtonSingleEditor = new javax.swing.JButton();
        jButtonSingleEditor1 = new javax.swing.JButton();
        jTabbedPane5 = new javax.swing.JTabbedPane();
        jPanel4 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jCheckBox1 = new javax.swing.JCheckBox();
        jButton10 = new javax.swing.JButton();
        jCheckBoxAlwaysInt = new javax.swing.JCheckBox();
        jPanel16 = new javax.swing.JPanel();
        singleImagePanel2 = new de.malban.graphics.SingleVectorPanel();
        singleImagePanel3 = new de.malban.graphics.SingleVectorPanel();
        jLabelY = new javax.swing.JLabel();
        jLabelZ = new javax.swing.JLabel();
        jTextFieldExpandYZ = new javax.swing.JTextField();
        jButtonExpandDimensionYZ = new javax.swing.JButton();
        jCheckBoxDragVectors = new javax.swing.JCheckBox();
        jPanel21 = new javax.swing.JPanel();
        jTabbedPane3 = new javax.swing.JTabbedPane();
        jPanel8 = new javax.swing.JPanel();
        jSliderSide = new javax.swing.JSlider();
        jSliderTop = new javax.swing.JSlider();
        jSliderFront = new javax.swing.JSlider();
        jTextFieldSide = new javax.swing.JTextField();
        jTextFieldTop = new javax.swing.JTextField();
        jLabel10 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jTextFieldFront = new javax.swing.JTextField();
        jPanel2 = new javax.swing.JPanel();
        jLabel11 = new javax.swing.JLabel();
        jLabel15 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        jSliderFrontTranslocationZ = new javax.swing.JSlider();
        jSliderFrontTranslocationY = new javax.swing.JSlider();
        jSliderFrontTranslocationX = new javax.swing.JSlider();
        jTextFieldFront1 = new javax.swing.JTextField();
        jTextFieldSide1 = new javax.swing.JTextField();
        jTextFieldTop1 = new javax.swing.JTextField();
        jPanel7 = new javax.swing.JPanel();
        jLabel14 = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        jLabel18 = new javax.swing.JLabel();
        jSliderTop1 = new javax.swing.JSlider();
        jSliderSide1 = new javax.swing.JSlider();
        jSliderFront1 = new javax.swing.JSlider();
        jTextFieldFront2 = new javax.swing.JTextField();
        jTextFieldSide2 = new javax.swing.JTextField();
        jTextFieldTop2 = new javax.swing.JTextField();
        jButton2dAxis = new javax.swing.JButton();
        jButton3dAxis = new javax.swing.JButton();
        jLabelDelay1 = new javax.swing.JLabel();
        jCheckBoxDisplayAxis = new javax.swing.JCheckBox();
        jPanel25 = new javax.swing.JPanel();
        jTabbedPane7 = new javax.swing.JTabbedPane();
        jPanel3 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTextArea1 = new javax.swing.JTextArea();
        single3dDisplayPanel1 = new de.malban.graphics.Single3dDisplayPanel();
        jLabel22 = new javax.swing.JLabel();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTextArea2 = new javax.swing.JTextArea();
        jLabel23 = new javax.swing.JLabel();
        jLabel24 = new javax.swing.JLabel();
        jComboBoxPatterns = new javax.swing.JComboBox();
        jLabel25 = new javax.swing.JLabel();
        jLabel26 = new javax.swing.JLabel();
        jLabel27 = new javax.swing.JLabel();
        jTextField8 = new javax.swing.JTextField();
        jTextField9 = new javax.swing.JTextField();
        jTextField10 = new javax.swing.JTextField();
        jTextFieldPatternName = new javax.swing.JTextField();
        jButtonSave3 = new javax.swing.JButton();
        jButtonInterprete = new javax.swing.JButton();
        jLabel49 = new javax.swing.JLabel();
        jCheckBoxMulti = new javax.swing.JCheckBox();
        jButton11 = new javax.swing.JButton();
        jButton12 = new javax.swing.JButton();
        jPanel38 = new javax.swing.JPanel();
        jLabel56 = new javax.swing.JLabel();
        jButtonLoad2 = new javax.swing.JButton();
        jCheckBoxDontRemoveDoubles = new javax.swing.JCheckBox();
        jPanel15 = new javax.swing.JPanel();
        jButtonExport1 = new javax.swing.JButton();
        jPanel26 = new javax.swing.JPanel();
        jTabbedPane8 = new javax.swing.JTabbedPane();
        jPanel19 = new javax.swing.JPanel();
        jScrollPane5 = new javax.swing.JScrollPane();
        jTextAreaResult = new javax.swing.JTextArea();
        jPanel29 = new javax.swing.JPanel();
        jButtonMov_Draw_VLc_a = new javax.swing.JButton();
        jButtonDraw_VLc = new javax.swing.JButton();
        jButtonDraw_VLp = new javax.swing.JButton();
        jButtonDraw_VL_mode = new javax.swing.JButton();
        jLabel4 = new javax.swing.JLabel();
        jLabel34 = new javax.swing.JLabel();
        jLabel35 = new javax.swing.JLabel();
        jLabel36 = new javax.swing.JLabel();
        jLabel37 = new javax.swing.JLabel();
        jTextFieldLabelListname = new javax.swing.JTextField();
        jButtonDraw_syncList = new javax.swing.JButton();
        jTextFieldResync = new javax.swing.JTextField();
        jCheckBoxVec32 = new javax.swing.JCheckBox();
        jCheckBoxextendedList = new javax.swing.JCheckBox();
        jButtonDraw_3d = new javax.swing.JButton();
        jCheckBox3ds = new javax.swing.JCheckBox();
        jCheckBox16 = new javax.swing.JCheckBox();
        jCheckBoxAbsolut = new javax.swing.JCheckBox();
        jButtonDraw_absolut = new javax.swing.JButton();
        jCheckBoxAbsolutStart = new javax.swing.JCheckBox();
        jCheckBoxAbsolutEnd = new javax.swing.JCheckBox();
        jPanel30 = new javax.swing.JPanel();
        jButtonMov_Draw_VLc_aAnim = new javax.swing.JButton();
        jButtonDraw_VLcAnim = new javax.swing.JButton();
        jButtonDraw_VLpAnim = new javax.swing.JButton();
        jButtonDraw_VL_modeAnim = new javax.swing.JButton();
        jTextFieldAnimName = new javax.swing.JTextField();
        jLabel38 = new javax.swing.JLabel();
        jLabel44 = new javax.swing.JLabel();
        jLabel45 = new javax.swing.JLabel();
        jLabel46 = new javax.swing.JLabel();
        jButtonDraw_syncListAnim = new javax.swing.JButton();
        jTextFieldResyncAnim = new javax.swing.JTextField();
        jCheckBoxExtendedAnimSync = new javax.swing.JCheckBox();
        jCheckBoxNoSyncOpt = new javax.swing.JCheckBox();
        jCheckBoxRunnable = new javax.swing.JCheckBox();
        jButtonAssemble = new javax.swing.JButton();
        jButtonEditInVedi = new javax.swing.JButton();
        jCheckBoxAddFactor = new javax.swing.JCheckBox();
        jRadioButton3 = new javax.swing.JRadioButton();
        jRadioButton4 = new javax.swing.JRadioButton();
        jRadioButton5 = new javax.swing.JRadioButton();
        jRadioButton6 = new javax.swing.JRadioButton();
        jCheckBoxCStyle = new javax.swing.JCheckBox();
        jCheckBoxPCStyle = new javax.swing.JCheckBox();
        jPanel32 = new javax.swing.JPanel();
        jScrollPane6 = new javax.swing.JScrollPane();
        jTextAreaResult1 = new javax.swing.JTextArea();
        jButtonEditInVedi1 = new javax.swing.JButton();
        jButtonAssemble1 = new javax.swing.JButton();
        jCheckBoxRunnable1 = new javax.swing.JCheckBox();
        jPanel33 = new javax.swing.JPanel();
        jButtonCodeGen = new javax.swing.JButton();
        jLabel47 = new javax.swing.JLabel();
        jLabel48 = new javax.swing.JLabel();
        jLabel51 = new javax.swing.JLabel();
        jTextFieldLabelListname1 = new javax.swing.JTextField();
        jPanel34 = new javax.swing.JPanel();
        jButtonAnimCodeGen = new javax.swing.JButton();
        jTextFieldAnimName1 = new javax.swing.JTextField();
        jLabel52 = new javax.swing.JLabel();
        jPanel20 = new javax.swing.JPanel();
        jButtonExport = new javax.swing.JButton();
        jPanel40 = new javax.swing.JPanel();
        jButtonLoad3 = new javax.swing.JButton();
        jLabel57 = new javax.swing.JLabel();
        jLabel58 = new javax.swing.JLabel();
        jLabel59 = new javax.swing.JLabel();
        jButtonLoad4 = new javax.swing.JButton();
        jLabel60 = new javax.swing.JLabel();
        jLabel61 = new javax.swing.JLabel();
        jLabel62 = new javax.swing.JLabel();
        jPanel9 = new javax.swing.JPanel();
        jPanel27 = new javax.swing.JPanel();
        jTextFieldLabelListname2 = new javax.swing.JTextField();
        jButtonBuildSmartList = new javax.swing.JButton();
        jTextField3 = new javax.swing.JTextField();
        jTextField2 = new javax.swing.JTextField();
        jTextField1 = new javax.swing.JTextField();
        jLabel66 = new javax.swing.JLabel();
        jLabel65 = new javax.swing.JLabel();
        jLabel64 = new javax.swing.JLabel();
        jLabel63 = new javax.swing.JLabel();
        jCheckBoxIntensity = new javax.swing.JCheckBox();
        jCheckBoxFactor = new javax.swing.JCheckBox();
        jLabel67 = new javax.swing.JLabel();
        jTextFieldLabelFactorName = new javax.swing.JTextField();
        jButtonBuildSmartList1 = new javax.swing.JButton();
        jTextFieldLabelStackJumpName = new javax.swing.JTextField();
        jLabel68 = new javax.swing.JLabel();
        jCheckBoxStackJump = new javax.swing.JCheckBox();
        jLabel69 = new javax.swing.JLabel();
        jCheckBoxNoInitialMove = new javax.swing.JCheckBox();
        jButtonBuildSmartList2 = new javax.swing.JButton();
        jTextField12 = new javax.swing.JTextField();
        jLabel76 = new javax.swing.JLabel();
        jLabel80 = new javax.swing.JLabel();
        jCheckBox14 = new javax.swing.JCheckBox();
        jPanel36 = new javax.swing.JPanel();
        jCheckBoxRunnable2 = new javax.swing.JCheckBox();
        jButtonAssembleSM = new javax.swing.JButton();
        jButtonEditInVedi2 = new javax.swing.JButton();
        jScrollPane8 = new javax.swing.JScrollPane();
        jTextAreaResultSM = new javax.swing.JTextArea();
        jCheckBox9 = new javax.swing.JCheckBox();
        jCheckBox10 = new javax.swing.JCheckBox();
        jLabel73 = new javax.swing.JLabel();
        jTextField6 = new javax.swing.JTextField();
        jTextField7 = new javax.swing.JTextField();
        jLabel74 = new javax.swing.JLabel();
        jLabel75 = new javax.swing.JLabel();
        jTextField11 = new javax.swing.JTextField();
        jCheckBox11 = new javax.swing.JCheckBox();
        jCheckBoxCompileForVB = new javax.swing.JCheckBox();
        jCheckBox13 = new javax.swing.JCheckBox();
        jCheckBoxNoShift = new javax.swing.JCheckBox();
        jCheckBox15 = new javax.swing.JCheckBox();
        jTextField13 = new javax.swing.JTextField();
        jCheckBoxNoHiLo = new javax.swing.JCheckBox();
        jLabel79 = new javax.swing.JLabel();
        jTextFieldSmartMax = new javax.swing.JTextField();
        jPanel28 = new javax.swing.JPanel();
        jCheckBoxSameIntensity = new javax.swing.JCheckBox();
        jCheckBoxSamePattern = new javax.swing.JCheckBox();
        jCheckBox2dOnly = new javax.swing.JCheckBox();
        jLabel5 = new javax.swing.JLabel();
        jTextFieldXMaxLength = new javax.swing.JTextField();
        jTextFieldYMaxLength = new javax.swing.JTextField();
        jLabel6 = new javax.swing.JLabel();
        jCheckBoxVectorsContinuous = new javax.swing.JCheckBox();
        jCheckBoxVectorClosedPolygon = new javax.swing.JCheckBox();
        jLabel28 = new javax.swing.JLabel();
        jLabel29 = new javax.swing.JLabel();
        jTextFieldYMin = new javax.swing.JTextField();
        jTextFieldXMin = new javax.swing.JTextField();
        jTextFieldXMax = new javax.swing.JTextField();
        jTextFieldYMax = new javax.swing.JTextField();
        jLabel30 = new javax.swing.JLabel();
        jTextFieldZMaxLength = new javax.swing.JTextField();
        jLabel31 = new javax.swing.JLabel();
        jTextFieldZMin = new javax.swing.JTextField();
        jTextFieldZMax = new javax.swing.JTextField();
        jCheckBoxVectorOrderedClosedPolygon = new javax.swing.JCheckBox();
        jCheckBoxHighPattern = new javax.swing.JCheckBox();
        jCheckBoxOnePath = new javax.swing.JCheckBox();
        jLabel39 = new javax.swing.JLabel();
        jLabel40 = new javax.swing.JLabel();
        jLabel41 = new javax.swing.JLabel();
        jLabel42 = new javax.swing.JLabel();
        jLabel43 = new javax.swing.JLabel();
        jLabel54 = new javax.swing.JLabel();
        jTextFieldstart1 = new javax.swing.JTextField();
        jButtonFileSelect2 = new javax.swing.JButton();
        jLabel77 = new javax.swing.JLabel();
        jLabel78 = new javax.swing.JLabel();
        jTextFieldstart2 = new javax.swing.JTextField();
        jButtonFileSelect3 = new javax.swing.JButton();
        jPanel39 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jPanelIMageCollection = new javax.swing.JPanel();
        jPanel12 = new javax.swing.JPanel();
        jPanel13 = new javax.swing.JPanel();
        jButtonOneForward = new javax.swing.JButton();
        jTextFieldCurrentNo = new javax.swing.JTextField();
        jLabelImageNow = new javax.swing.JLabel();
        jTextFieldCount = new javax.swing.JTextField();
        jLabelImageCount = new javax.swing.JLabel();
        jButtonApplyCurrent = new javax.swing.JButton();
        jLabelSelSize = new javax.swing.JLabel();
        jButtonReverse = new javax.swing.JButton();
        jButtonDeleteOne = new javax.swing.JButton();
        jButtonSave2 = new javax.swing.JButton();
        jButtonAddCurrent = new javax.swing.JButton();
        jButtonLoad1 = new javax.swing.JButton();
        jRadioButtonAnimation = new javax.swing.JRadioButton();
        jRadioButtonScenario = new javax.swing.JRadioButton();
        jButtonAddCurrent1 = new javax.swing.JButton();
        jButtonClearAnimation = new javax.swing.JButton();
        jButtonOneBack = new javax.swing.JButton();
        jButtonJoin = new javax.swing.JButton();
        jCheckBoxAutoEdit = new javax.swing.JCheckBox();
        jCheckBoxAutoApply = new javax.swing.JCheckBox();
        jButtonJoin1 = new javax.swing.JButton();
        jButtonJoin2 = new javax.swing.JButton();

        jPopupMenuPoint.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jPopupMenuPointMouseExited(evt);
            }
        });

        jMenuItemJoin.setText("Join selected (here)");
        jMenuItemJoin.setToolTipText("Join when continue");
        jMenuItemJoin.setEnabled(false);
        jMenuItemJoin.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemJoinActionPerformed(evt);
            }
        });
        jPopupMenuPoint.add(jMenuItemJoin);

        jMenuItemHere.setText("Join here");
        jMenuItemHere.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemHereActionPerformed(evt);
            }
        });
        jPopupMenuPoint.add(jMenuItemHere);

        jMenuItemConnect.setText("Connect selected");
        jMenuItemConnect.setEnabled(false);
        jMenuItemConnect.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemConnectActionPerformed(evt);
            }
        });
        jPopupMenuPoint.add(jMenuItemConnect);

        jMenuItemRip.setText("Rip joined vector");
        jMenuItemRip.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemRipActionPerformed(evt);
            }
        });
        jPopupMenuPoint.add(jMenuItemRip);

        jMenuItemDelete.setText("Delete selected (not done)");
        jMenuItemDelete.setEnabled(false);
        jMenuItemDelete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemDeleteActionPerformed(evt);
            }
        });
        jPopupMenuPoint.add(jMenuItemDelete);

        jMenuItemPoint0.setText("Set as Start");
        jMenuItemPoint0.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemPoint0ActionPerformed(evt);
            }
        });
        jPopupMenuPoint.add(jMenuItemPoint0);

        jMenuItemMove.setText("Move");
        jMenuItemMove.setToolTipText("Move selected points to highlited point");
        jMenuItemMove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemMoveActionPerformed(evt);
            }
        });
        jPopupMenuPoint.add(jMenuItemMove);

        jPopupMenuLine.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jPopupMenuLineMouseExited(evt);
            }
        });

        jMenuItemLineDelete.setText("Delete selected");
        jMenuItemLineDelete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemLineDeleteActionPerformed(evt);
            }
        });
        jPopupMenuLine.add(jMenuItemLineDelete);

        jMenuItemDeleteNotSelected.setText("Delete not selected");
        jMenuItemDeleteNotSelected.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemDeleteNotSelectedActionPerformed(evt);
            }
        });
        jPopupMenuLine.add(jMenuItemDeleteNotSelected);

        jMenuItemInsertPoint.setText("Insert point");
        jMenuItemInsertPoint.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemInsertPointActionPerformed(evt);
            }
        });
        jPopupMenuLine.add(jMenuItemInsertPoint);

        jMenuItemSwitch.setText("Switch Orientation");
        jMenuItemSwitch.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemSwitchActionPerformed(evt);
            }
        });
        jPopupMenuLine.add(jMenuItemSwitch);

        jMenuItemRemovePoint.setText("Remove middle point");
        jMenuItemRemovePoint.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemRemovePointActionPerformed(evt);
            }
        });
        jPopupMenuLine.add(jMenuItemRemovePoint);

        setName("veccy"); // NOI18N

        jCheckBoxHasPattern.setText("has pattern byte");

        jTextFieldPattern.setText("51");
        jTextFieldPattern.setPreferredSize(new java.awt.Dimension(60, 21));

        jLabelPattern.setText("pattern byte (dec, bin, hex)");

        jCheckBoxHasIntensity.setText("has intensity");

        jTextFieldIntensity.setText("127");
        jTextFieldIntensity.setPreferredSize(new java.awt.Dimension(60, 21));

        jLabelPattern1.setText("intensity (0-127)");

        jButtonSetStyle.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/accept.png"))); // NOI18N
        jButtonSetStyle.setText("set to selected");
        jButtonSetStyle.setToolTipText("Moves selected image one to the right.");
        jButtonSetStyle.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonSetStyle.setPreferredSize(new java.awt.Dimension(150, 21));
        jButtonSetStyle.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSetStyleActionPerformed(evt);
            }
        });

        jButtonSetSolid.setText("solid");
        jButtonSetSolid.setToolTipText("Set selected vector to pattern 255");
        jButtonSetSolid.setPreferredSize(new java.awt.Dimension(150, 21));
        jButtonSetSolid.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSetSolidActionPerformed(evt);
            }
        });

        jButtonSetMove.setText("move");
        jButtonSetMove.setToolTipText("Set selected vector to pattern 0");
        jButtonSetMove.setPreferredSize(new java.awt.Dimension(150, 21));
        jButtonSetMove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSetMoveActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel10Layout = new javax.swing.GroupLayout(jPanel10);
        jPanel10.setLayout(jPanel10Layout);
        jPanel10Layout.setHorizontalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel10Layout.createSequentialGroup()
                        .addComponent(jCheckBoxHasPattern)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel10Layout.createSequentialGroup()
                        .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxHasIntensity)
                            .addGroup(jPanel10Layout.createSequentialGroup()
                                .addComponent(jTextFieldPattern, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabelPattern))
                            .addComponent(jButtonSetStyle, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel10Layout.createSequentialGroup()
                                .addComponent(jTextFieldIntensity, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabelPattern1))
                            .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                .addComponent(jButtonSetMove, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 114, Short.MAX_VALUE)
                                .addComponent(jButtonSetSolid, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)))
                        .addGap(0, 150, Short.MAX_VALUE))))
        );
        jPanel10Layout.setVerticalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jCheckBoxHasPattern)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextFieldPattern, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabelPattern))
                .addGap(18, 18, 18)
                .addComponent(jCheckBoxHasIntensity, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextFieldIntensity, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabelPattern1))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSetStyle, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButtonSetSolid, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSetMove, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(42, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("Line", jPanel10);

        jButtonRotate2d.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/shape_rotate_anticlockwise.png"))); // NOI18N
        jButtonRotate2d.setText("2d rotate (z-axis)");
        jButtonRotate2d.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonRotate2d.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonRotate2d.setPreferredSize(new java.awt.Dimension(160, 21));
        jButtonRotate2d.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRotate2dActionPerformed(evt);
            }
        });

        jTextFieldRotate2d.setText("90");
        jTextFieldRotate2d.setPreferredSize(new java.awt.Dimension(20, 21));

        jButtonMirrorVertically.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/shape_flip_horizontal.png"))); // NOI18N
        jButtonMirrorVertically.setText("mirror vertically");
        jButtonMirrorVertically.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonMirrorVertically.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonMirrorVertically.setPreferredSize(new java.awt.Dimension(160, 21));
        jButtonMirrorVertically.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonMirrorVerticallyActionPerformed(evt);
            }
        });

        jButtonMirrorHorizontally.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/shape_flip_vertical.png"))); // NOI18N
        jButtonMirrorHorizontally.setText("mirror horizontally");
        jButtonMirrorHorizontally.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonMirrorHorizontally.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonMirrorHorizontally.setPreferredSize(new java.awt.Dimension(160, 21));
        jButtonMirrorHorizontally.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonMirrorHorizontallyActionPerformed(evt);
            }
        });

        jLabel50.setForeground(new java.awt.Color(102, 102, 102));
        jLabel50.setText("around y-axis");

        jLabel53.setForeground(new java.awt.Color(102, 102, 102));
        jLabel53.setText("around x-axis");

        jButtonOneForwardSelection2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/images.png"))); // NOI18N
        jButtonOneForwardSelection2.setText("image to vector");
        jButtonOneForwardSelection2.setToolTipText("image to vector");
        jButtonOneForwardSelection2.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonOneForwardSelection2.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonOneForwardSelection2.setPreferredSize(new java.awt.Dimension(160, 21));
        jButtonOneForwardSelection2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOneForwardSelection2ActionPerformed(evt);
            }
        });

        jLabel32.setText("factor");

        jButtonShrink.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/delete.png"))); // NOI18N
        jButtonShrink.setToolTipText("shrink vectorlist");
        jButtonShrink.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonShrink.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonShrinkActionPerformed(evt);
            }
        });

        jButtonEnlarge.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/add.png"))); // NOI18N
        jButtonEnlarge.setToolTipText("expand vectorlist");
        jButtonEnlarge.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonEnlarge.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonEnlargeActionPerformed(evt);
            }
        });

        jTextFieldScaleFactor.setText("1.5");

        jCheckBox6.setSelected(true);
        jCheckBox6.setText("y");

        jCheckBox7.setSelected(true);
        jCheckBox7.setText("x");

        jCheckBox8.setSelected(true);
        jCheckBox8.setText("z");

        javax.swing.GroupLayout jPanel35Layout = new javax.swing.GroupLayout(jPanel35);
        jPanel35.setLayout(jPanel35Layout);
        jPanel35Layout.setHorizontalGroup(
            jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel35Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel35Layout.createSequentialGroup()
                        .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonOneForwardSelection2, javax.swing.GroupLayout.PREFERRED_SIZE, 185, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonMirrorHorizontally, javax.swing.GroupLayout.PREFERRED_SIZE, 185, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonMirrorVertically, javax.swing.GroupLayout.PREFERRED_SIZE, 185, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonRotate2d, javax.swing.GroupLayout.PREFERRED_SIZE, 185, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(20, 20, 20)
                        .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel50)
                            .addComponent(jLabel53)
                            .addComponent(jTextFieldRotate2d, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel35Layout.createSequentialGroup()
                        .addComponent(jLabel32)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel35Layout.createSequentialGroup()
                                .addComponent(jButtonShrink)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonEnlarge))
                            .addComponent(jCheckBox6))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel35Layout.createSequentialGroup()
                                .addComponent(jCheckBox7)
                                .addGap(18, 18, 18)
                                .addComponent(jCheckBox8))
                            .addComponent(jTextFieldScaleFactor, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(0, 78, Short.MAX_VALUE))
        );
        jPanel35Layout.setVerticalGroup(
            jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel35Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonRotate2d, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldRotate2d, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonMirrorVertically, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel50))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonMirrorHorizontally, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel53))
                .addGap(20, 20, 20)
                .addComponent(jButtonOneForwardSelection2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(10, 10, 10)
                .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel32)
                    .addComponent(jButtonShrink)
                    .addComponent(jButtonEnlarge)
                    .addComponent(jTextFieldScaleFactor, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox6)
                    .addComponent(jCheckBox7)
                    .addComponent(jCheckBox8))
                .addContainerGap(64, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("2d-Tools", jPanel35);

        jTextFieldBaseSize.setText("1");
        jTextFieldBaseSize.setPreferredSize(new java.awt.Dimension(13, 21));

        jLabel19.setText("base size");

        jButtonCube.setText("cube");
        jButtonCube.setPreferredSize(new java.awt.Dimension(71, 21));
        jButtonCube.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCubeActionPerformed(evt);
            }
        });

        jButton2.setText("pyramid");
        jButton2.setPreferredSize(new java.awt.Dimension(71, 21));
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel11Layout = new javax.swing.GroupLayout(jPanel11);
        jPanel11.setLayout(jPanel11Layout);
        jPanel11Layout.setHorizontalGroup(
            jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel11Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jButton2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel11Layout.createSequentialGroup()
                        .addComponent(jLabel19)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldBaseSize, javax.swing.GroupLayout.PREFERRED_SIZE, 28, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButtonCube, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel11Layout.setVerticalGroup(
            jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel11Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel19)
                    .addComponent(jTextFieldBaseSize, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonCube, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("Figure", jPanel11);

        jScrollPane7.setPreferredSize(new java.awt.Dimension(300, 402));

        jTableFace.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jTableFace.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTableFace.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                jTableFaceComponentResized(evt);
            }
        });
        jScrollPane7.setViewportView(jTableFace);

        jButton1.setText("add as face");
        jButton1.setToolTipText("<html> \nUse the current selected points and add the thus defined \"face\" to the facelist.<BR>\n<BR>\nThe points must all lie in the same plane (they must be coplanar).<BR>\n</html>");
        jButton1.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButton1.setPreferredSize(new java.awt.Dimension(150, 21));
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton7.setText("delete from face list");
        jButton7.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButton7.setPreferredSize(new java.awt.Dimension(150, 21));
        jButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton7ActionPerformed(evt);
            }
        });

        jLabel55.setPreferredSize(new java.awt.Dimension(150, 21));

        jButton3.setText("execute HLR");
        jButton3.setToolTipText("<html>\nThe current angle settings for DISPLAY is taken,<BR>\nand a hidden line removal is executed to the vectorlist.<BR>\n(provided faces are defined)\n\n</html>");
        jButton3.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButton3.setPreferredSize(new java.awt.Dimension(150, 21));
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel37Layout = new javax.swing.GroupLayout(jPanel37);
        jPanel37.setLayout(jPanel37Layout);
        jPanel37Layout.setHorizontalGroup(
            jPanel37Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel37Layout.createSequentialGroup()
                .addGroup(jPanel37Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jButton7, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 180, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 180, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton3, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 180, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addComponent(jLabel55, javax.swing.GroupLayout.PREFERRED_SIZE, 102, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(59, Short.MAX_VALUE))
            .addComponent(jScrollPane7, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel37Layout.setVerticalGroup(
            jPanel37Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel37Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jScrollPane7, javax.swing.GroupLayout.DEFAULT_SIZE, 144, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel37Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel55, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 26, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("Faces", jPanel37);

        buttonGroup1.add(jRadioButtonSetPoint);
        jRadioButtonSetPoint.setSelected(true);
        jRadioButtonSetPoint.setText("set");
        jRadioButtonSetPoint.setToolTipText("set new vectors/points");
        jRadioButtonSetPoint.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButtonSetPointActionPerformed(evt);
            }
        });

        buttonGroup1.add(jRadioButtonSelectPoint);
        jRadioButtonSelectPoint.setText("select point");
        jRadioButtonSelectPoint.setToolTipText("select endpoint of vectors");
        jRadioButtonSelectPoint.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButtonSelectPointActionPerformed(evt);
            }
        });

        buttonGroup1.add(jRadioButtonSelectLine);
        jRadioButtonSelectLine.setText("select vector");
        jRadioButtonSelectLine.setToolTipText("select of complete vector");
        jRadioButtonSelectLine.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButtonSelectLineActionPerformed(evt);
            }
        });

        jCheckBoxContinue.setText("continue");
        jCheckBoxContinue.setToolTipText("continues vector draw, endpoint of vector A is startpoint of vector B");
        jCheckBoxContinue.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxContinueActionPerformed(evt);
            }
        });

        jCheckBoxPointsOk.setText("points ok");
        jCheckBoxPointsOk.setToolTipText("setting of vectors with start == end");
        jCheckBoxPointsOk.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxPointsOkActionPerformed(evt);
            }
        });

        jCheckBoxArrows.setText("arrows");
        jCheckBoxArrows.setToolTipText("draw arrows of vectors, to show direction");
        jCheckBoxArrows.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxArrowsActionPerformed(evt);
            }
        });

        jCheckBoxPosition.setText("position");
        jCheckBoxPosition.setToolTipText("position in vectorlist, NOT order!");
        jCheckBoxPosition.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxPositionActionPerformed(evt);
            }
        });

        jCheckBoxMoves.setText("moves visible");
        jCheckBoxMoves.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxMovesActionPerformed(evt);
            }
        });

        jLabel70.setText("y");

        jLabel71.setText("change start coordinate");

        jLabel72.setText("x");

        jButton8.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/accept.png"))); // NOI18N
        jButton8.setText("do it list");
        jButton8.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton8.setPreferredSize(new java.awt.Dimension(80, 21));
        jButton8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton8ActionPerformed(evt);
            }
        });

        jButton9.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/accept.png"))); // NOI18N
        jButton9.setText("do it anim");
        jButton9.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton9.setPreferredSize(new java.awt.Dimension(80, 21));
        jButton9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton9ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanelModeSelectLayout = new javax.swing.GroupLayout(jPanelModeSelect);
        jPanelModeSelect.setLayout(jPanelModeSelectLayout);
        jPanelModeSelectLayout.setHorizontalGroup(
            jPanelModeSelectLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelModeSelectLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelModeSelectLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanelModeSelectLayout.createSequentialGroup()
                        .addGroup(jPanelModeSelectLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jRadioButtonSelectLine)
                            .addComponent(jRadioButtonSelectPoint)
                            .addComponent(jRadioButtonSetPoint))
                        .addGap(32, 32, 32)
                        .addGroup(jPanelModeSelectLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanelModeSelectLayout.createSequentialGroup()
                                .addComponent(jCheckBoxMoves, javax.swing.GroupLayout.DEFAULT_SIZE, 210, Short.MAX_VALUE)
                                .addContainerGap(127, Short.MAX_VALUE))
                            .addGroup(jPanelModeSelectLayout.createSequentialGroup()
                                .addGroup(jPanelModeSelectLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jCheckBoxPointsOk, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(jCheckBoxContinue, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(jCheckBoxPosition, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(jCheckBoxArrows, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                    .addGroup(jPanelModeSelectLayout.createSequentialGroup()
                        .addGroup(jPanelModeSelectLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel71)
                            .addGroup(jPanelModeSelectLayout.createSequentialGroup()
                                .addComponent(jLabel70)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(jLabel72)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(jPanelModeSelectLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jButton9, javax.swing.GroupLayout.PREFERRED_SIZE, 125, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jButton8, javax.swing.GroupLayout.PREFERRED_SIZE, 125, javax.swing.GroupLayout.PREFERRED_SIZE))))
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
        );
        jPanelModeSelectLayout.setVerticalGroup(
            jPanelModeSelectLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelModeSelectLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelModeSelectLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanelModeSelectLayout.createSequentialGroup()
                        .addComponent(jRadioButtonSetPoint)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jRadioButtonSelectPoint)
                        .addGap(0, 0, 0)
                        .addComponent(jRadioButtonSelectLine))
                    .addGroup(jPanelModeSelectLayout.createSequentialGroup()
                        .addComponent(jCheckBoxContinue)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxPointsOk)
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBoxArrows)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxPosition)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxMoves)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel71)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanelModeSelectLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel70)
                    .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel72)
                    .addComponent(jButton8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(72, Short.MAX_VALUE))
        );

        jTabbedPane4.addTab("Mode/Select", jPanelModeSelect);

        jButton5.setText("center vectorlist");
        jButton5.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton5.setPreferredSize(new java.awt.Dimension(175, 21));
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jButtonConnectWherePossible.setText("connect where possible");
        jButtonConnectWherePossible.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonConnectWherePossible.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonConnectWherePossible.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonConnectWherePossibleActionPerformed(evt);
            }
        });

        jButtonOrderVectorlist.setText("order vectorlist");
        jButtonOrderVectorlist.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonOrderVectorlist.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonOrderVectorlist.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOrderVectorlistActionPerformed(evt);
            }
        });

        jButtonFillGaps.setText("fill gaps");
        jButtonFillGaps.setToolTipText("<html>\n\nThis also implies:<BR>\n<OL>\n<LI>\"connect where possible\"     </LI>\n<LI> \"order vectorlist\"</LI>\n</OL>\nAnd than creates \"move\" vectors (pattern = 0) between all gaps (except vStart and vEnd).\n</html>");
        jButtonFillGaps.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonFillGaps.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonFillGaps.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFillGapsActionPerformed(evt);
            }
        });

        jButtonRemoveDots.setText("remove dots");
        jButtonRemoveDots.setToolTipText("chose between test for only 2d");
        jButtonRemoveDots.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonRemoveDots.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonRemoveDots.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRemoveDotsActionPerformed(evt);
            }
        });

        jButtonFitByteRange.setText("fit byte");
        jButtonFitByteRange.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonFitByteRange.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonFitByteRange.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFitByteRangeActionPerformed(evt);
            }
        });

        jCheckBoxFraktion.setSelected(true);
        jCheckBoxFraktion.setText("fractions");
        jCheckBoxFraktion.setEnabled(false);

        jCheckBoxLine.setText("line");
        jCheckBoxLine.setToolTipText("if checked polygon will be created with additional lines instead of moves");

        jButtonOrderSplitWhereNeeded.setText("split where needed");
        jButtonOrderSplitWhereNeeded.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonOrderSplitWhereNeeded.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonOrderSplitWhereNeeded.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOrderSplitWhereNeededActionPerformed(evt);
            }
        });

        jTextFieldNeedSplit.setText("127");
        jTextFieldNeedSplit.setPreferredSize(new java.awt.Dimension(27, 21));
        jTextFieldNeedSplit.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldNeedSplitActionPerformed(evt);
            }
        });

        jCheckBoxAvoidMoreThan2.setSelected(true);
        jCheckBoxAvoidMoreThan2.setText("avoid 2+");
        jCheckBoxAvoidMoreThan2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxAvoidMoreThan2ActionPerformed(evt);
            }
        });

        jButtonConnectWherePossible1.setText("max 1:1 connect");
        jButtonConnectWherePossible1.setToolTipText("ensures that no connections has more than 1:1 joins");
        jButtonConnectWherePossible1.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonConnectWherePossible1.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonConnectWherePossible1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonConnectWherePossible1ActionPerformed(evt);
            }
        });

        jCheckBox3dDots.setSelected(true);
        jCheckBox3dDots.setText("3d dots");
        jCheckBox3dDots.setToolTipText("if checked polygon will be created with additional lines instead of moves");

        javax.swing.GroupLayout jPanelShortCuts1Layout = new javax.swing.GroupLayout(jPanelShortCuts1);
        jPanelShortCuts1.setLayout(jPanelShortCuts1Layout);
        jPanelShortCuts1Layout.setHorizontalGroup(
            jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelShortCuts1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jButtonOrderSplitWhereNeeded, javax.swing.GroupLayout.DEFAULT_SIZE, 197, Short.MAX_VALUE)
                    .addComponent(jButtonConnectWherePossible, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonOrderVectorlist, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonFitByteRange, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonRemoveDots, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonFillGaps, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButton5, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonConnectWherePossible1, javax.swing.GroupLayout.DEFAULT_SIZE, 243, Short.MAX_VALUE)
                    .addGroup(jPanelShortCuts1Layout.createSequentialGroup()
                        .addGroup(jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jCheckBoxFraktion, javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jCheckBoxLine)
                                .addGroup(jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                    .addComponent(jTextFieldNeedSplit, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(jCheckBox3dDots, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                            .addComponent(jCheckBoxAvoidMoreThan2))
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanelShortCuts1Layout.setVerticalGroup(
            jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelShortCuts1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonConnectWherePossible1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(6, 6, 6)
                .addGroup(jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonConnectWherePossible, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxAvoidMoreThan2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonOrderVectorlist, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonOrderSplitWhereNeeded, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldNeedSplit, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonFillGaps, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxLine))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonRemoveDots, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBox3dDots))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanelShortCuts1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonFitByteRange, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxFraktion))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jTabbedPane4.addTab("shortcut list", jPanelShortCuts1);

        jButtonDisconnectAll.setText("disconnect all");
        jButtonDisconnectAll.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDisconnectAll.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonDisconnectAll.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDisconnectAllActionPerformed(evt);
            }
        });

        jButtonRemoveMove.setText("remove move vectors");
        jButtonRemoveMove.setToolTipText("Also disconnects all!\n");
        jButtonRemoveMove.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonRemoveMove.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonRemoveMove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRemoveMoveActionPerformed(evt);
            }
        });

        jButtonLongestPaths.setText("connect longest paths");
        jButtonLongestPaths.setToolTipText("disconnects - and connects the longest paths found - in descending order. Switches vector orientations.");
        jButtonLongestPaths.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonLongestPaths.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonLongestPaths.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLongestPathsActionPerformed(evt);
            }
        });

        jButtonOptimizeSize.setText("optimize size");
        jButtonOptimizeSize.setToolTipText("");
        jButtonOptimizeSize.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonOptimizeSize.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonOptimizeSize.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOptimizeSizeActionPerformed(evt);
            }
        });

        jButtonRemoveDouble.setText("remove double vectors");
        jButtonRemoveDouble.setToolTipText("removes doubles (disconnects)");
        jButtonRemoveDouble.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonRemoveDouble.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonRemoveDouble.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRemoveDoubleActionPerformed(evt);
            }
        });

        jButtonRemoveiDouble.setText("remove idouble vectors");
        jButtonRemoveiDouble.setToolTipText("also removes inverse doubles (disconnects)");
        jButtonRemoveiDouble.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonRemoveiDouble.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonRemoveiDouble.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRemoveiDoubleActionPerformed(evt);
            }
        });

        jButtonLongestPathsplus.setText("connect longest paths ++");
        jButtonLongestPathsplus.setToolTipText("same + connect the paths (shortest distance)");
        jButtonLongestPathsplus.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonLongestPathsplus.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonLongestPathsplus.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLongestPathsplusActionPerformed(evt);
            }
        });

        jCheckBoxRespectZero.setText("respect zero");
        jCheckBoxRespectZero.setToolTipText("do not connect, when zero is \"nearer\"");

        jButtonRemoveDots1.setText("remove dots");
        jButtonRemoveDots1.setToolTipText("always 3d");
        jButtonRemoveDots1.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonRemoveDots1.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonRemoveDots1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRemoveDots1ActionPerformed(evt);
            }
        });

        jButtonLongestPaths1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/award_star_gold_3.png"))); // NOI18N
        jButtonLongestPaths1.setText("Isidro All");
        jButtonLongestPaths1.setToolTipText("<html>\nDoes the functions:<BR>\ndisconnect all<BR>\nremove move vectors<BR>\nremove idouble vectors<BR>\nremove dots<BR>\nconnect longest paths ++ (not respect zero)<BR>\nall in one go - take a bit of time - depending on the vectorlist.\n</html>");
        jButtonLongestPaths1.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonLongestPaths1.setPreferredSize(new java.awt.Dimension(175, 21));
        jButtonLongestPaths1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLongestPaths1ActionPerformed(evt);
            }
        });

        jLabelFactor.setText("     ");

        javax.swing.GroupLayout jPanelShortCuts2Layout = new javax.swing.GroupLayout(jPanelShortCuts2);
        jPanelShortCuts2.setLayout(jPanelShortCuts2Layout);
        jPanelShortCuts2Layout.setHorizontalGroup(
            jPanelShortCuts2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelShortCuts2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelShortCuts2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanelShortCuts2Layout.createSequentialGroup()
                        .addGroup(jPanelShortCuts2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jButtonRemoveDots1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 215, Short.MAX_VALUE)
                            .addComponent(jButtonLongestPathsplus, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonRemoveiDouble, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonRemoveDouble, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonDisconnectAll, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonRemoveMove, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addGap(6, 6, 6)
                        .addGroup(jPanelShortCuts2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonOptimizeSize, javax.swing.GroupLayout.PREFERRED_SIZE, 1, Short.MAX_VALUE)
                            .addComponent(jButtonLongestPaths, javax.swing.GroupLayout.DEFAULT_SIZE, 225, Short.MAX_VALUE)
                            .addGroup(jPanelShortCuts2Layout.createSequentialGroup()
                                .addComponent(jLabelFactor, javax.swing.GroupLayout.PREFERRED_SIZE, 56, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 0, Short.MAX_VALUE))
                            .addComponent(jButtonLongestPaths1, javax.swing.GroupLayout.PREFERRED_SIZE, 1, Short.MAX_VALUE)))
                    .addGroup(jPanelShortCuts2Layout.createSequentialGroup()
                        .addComponent(jCheckBoxRespectZero)
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanelShortCuts2Layout.setVerticalGroup(
            jPanelShortCuts2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelShortCuts2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelShortCuts2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonDisconnectAll, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonOptimizeSize, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanelShortCuts2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonRemoveMove, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabelFactor))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonRemoveDouble, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonRemoveiDouble, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanelShortCuts2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonRemoveDots1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonLongestPaths1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(6, 6, 6)
                .addComponent(jCheckBoxRespectZero)
                .addGap(6, 6, 6)
                .addGroup(jPanelShortCuts2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonLongestPathsplus, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonLongestPaths, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        jTabbedPane4.addTab("shortcut 2", jPanelShortCuts2);

        jTextFieldScaleFactor1.setText("1.5");
        jTextFieldScaleFactor1.setPreferredSize(new java.awt.Dimension(23, 21));

        jButtonEnlarge1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/add.png"))); // NOI18N
        jButtonEnlarge1.setToolTipText("expand vectorlist");
        jButtonEnlarge1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonEnlarge1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonEnlarge1ActionPerformed(evt);
            }
        });

        jButtonShrink1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/delete.png"))); // NOI18N
        jButtonShrink1.setToolTipText("shrink vectorlist");
        jButtonShrink1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonShrink1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonShrink1ActionPerformed(evt);
            }
        });

        jButtonFitByteRange1.setText("fit byte");
        jButtonFitByteRange1.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonFitByteRange1.setPreferredSize(new java.awt.Dimension(74, 21));
        jButtonFitByteRange1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFitByteRange1ActionPerformed(evt);
            }
        });

        jCheckBoxFraktion1.setSelected(true);
        jCheckBoxFraktion1.setText("fractions");
        jCheckBoxFraktion1.setEnabled(false);

        javax.swing.GroupLayout jPanelShortcutsCollectionLayout = new javax.swing.GroupLayout(jPanelShortcutsCollection);
        jPanelShortcutsCollection.setLayout(jPanelShortcutsCollectionLayout);
        jPanelShortcutsCollectionLayout.setHorizontalGroup(
            jPanelShortcutsCollectionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanelShortcutsCollectionLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelShortcutsCollectionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanelShortcutsCollectionLayout.createSequentialGroup()
                        .addComponent(jButtonShrink1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonEnlarge1))
                    .addGroup(jPanelShortcutsCollectionLayout.createSequentialGroup()
                        .addComponent(jButtonFitByteRange1, javax.swing.GroupLayout.PREFERRED_SIZE, 93, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldScaleFactor1, javax.swing.GroupLayout.PREFERRED_SIZE, 41, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jCheckBoxFraktion1)))
                .addGap(139, 139, 139))
        );
        jPanelShortcutsCollectionLayout.setVerticalGroup(
            jPanelShortcutsCollectionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelShortcutsCollectionLayout.createSequentialGroup()
                .addGap(18, 18, 18)
                .addGroup(jPanelShortcutsCollectionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonFitByteRange1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxFraktion1)
                    .addComponent(jTextFieldScaleFactor1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(6, 6, 6)
                .addGroup(jPanelShortcutsCollectionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonShrink1)
                    .addComponent(jButtonEnlarge1))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jTabbedPane4.addTab("shortcut collection", jPanelShortcutsCollection);

        single3dDisplayPanel.setMaximumSize(new java.awt.Dimension(150, 150));
        single3dDisplayPanel.setMinimumSize(new java.awt.Dimension(150, 150));

        javax.swing.GroupLayout single3dDisplayPanelLayout = new javax.swing.GroupLayout(single3dDisplayPanel);
        single3dDisplayPanel.setLayout(single3dDisplayPanelLayout);
        single3dDisplayPanelLayout.setHorizontalGroup(
            single3dDisplayPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 150, Short.MAX_VALUE)
        );
        single3dDisplayPanelLayout.setVerticalGroup(
            single3dDisplayPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 150, Short.MAX_VALUE)
        );

        jSliderSourceScale1.setMajorTickSpacing(1);
        jSliderSourceScale1.setMaximum(21);
        jSliderSourceScale1.setMinimum(1);
        jSliderSourceScale1.setMinorTickSpacing(1);
        jSliderSourceScale1.setPaintTicks(true);
        jSliderSourceScale1.setSnapToTicks(true);
        jSliderSourceScale1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderSourceScale1StateChanged(evt);
            }
        });

        jToggleButtonPlayAnim.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jToggleButtonPlayAnim.setToolTipText("Animates through all images, animation is looped. Given delay is taken.");
        jToggleButtonPlayAnim.setPreferredSize(new java.awt.Dimension(21, 21));
        jToggleButtonPlayAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButtonPlayAnimActionPerformed(evt);
            }
        });

        jTextFieldDelay.setText("80");
        jTextFieldDelay.setPreferredSize(new java.awt.Dimension(6, 21));
        jTextFieldDelay.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldDelayActionPerformed(evt);
            }
        });

        jLabelDelay.setText("Delay");

        jTabbedPane6.setMinimumSize(new java.awt.Dimension(101, 280));

        jPanel23.setToolTipText("");

        jCheckBox2.setSelected(true);
        jCheckBox2.setText("z-axis (2d)");

        jCheckBox3.setText("x-axis");

        jCheckBox4.setText("y-axis");

        jLabel1.setText("to angle");

        jTextFieldRotateZ.setText("360");
        jTextFieldRotateZ.setPreferredSize(new java.awt.Dimension(0, 21));

        jLabel2.setText("to angle");

        jTextFieldRotateX.setText("0");
        jTextFieldRotateX.setPreferredSize(new java.awt.Dimension(0, 21));

        jLabel3.setText("to angle");

        jTextFieldRotateY.setText("0");
        jTextFieldRotateY.setPreferredSize(new java.awt.Dimension(0, 21));
        jTextFieldRotateY.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldRotateYActionPerformed(evt);
            }
        });

        jTextFieldRotateSteps.setText("12");
        jTextFieldRotateSteps.setToolTipText("<html>\nNumber of steps <b>BETWEEN</b> the original and the final angle.<BR>\nThis means step count of 0 (zero) results in 2 added animation frames, one for the original, \nand one frame for the rotated angle given.<BR>\nThis also means if the final angle is 360 degrees the first and the last added frame have the same rotation angle!\n</html>");
        jTextFieldRotateSteps.setPreferredSize(new java.awt.Dimension(0, 21));

        jButton4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/accept.png"))); // NOI18N
        jButton4.setText("do it");
        jButton4.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton4.setPreferredSize(new java.awt.Dimension(80, 21));
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });

        jCheckBoxScaleToByte.setSelected(true);
        jCheckBoxScaleToByte.setText("scale to byte");
        jCheckBoxScaleToByte.setToolTipText("... if resulting rotated list is larger than byte values...");
        jCheckBoxScaleToByte.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jCheckBoxScaleToByte.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        jCheckBoxScaleToByte.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxScaleToByteActionPerformed(evt);
            }
        });

        jLabel33.setText("steps");

        jCheckBox5.setText("apply HLR");
        jCheckBox5.setToolTipText("<html>\nApply hidden line removal on result.<BR>\nThe result will be a 2d list only.\n</html>");

        jCheckBoxzrotdir.setText("+/-");

        jCheckBoxxrotdir.setText("+/-");

        jCheckBoxyrotdir.setText("+/-");

        jButtonSelectionRotation.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_rotate_clockwise.png"))); // NOI18N
        jButtonSelectionRotation.setText("selection rotation");
        jButtonSelectionRotation.setToolTipText("<html>\nRotates WITHIN the current vectorlist the selected vectors according to angle settings.<BR>\nMust be in mode \"vector\".<BR> No animation is built!\n\n<html>\n");
        jButtonSelectionRotation.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonSelectionRotation.setPreferredSize(new java.awt.Dimension(80, 21));
        jButtonSelectionRotation.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSelectionRotationActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel23Layout = new javax.swing.GroupLayout(jPanel23);
        jPanel23.setLayout(jPanel23Layout);
        jPanel23Layout.setHorizontalGroup(
            jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel23Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox5)
                    .addComponent(jCheckBox4)
                    .addComponent(jCheckBox3)
                    .addComponent(jCheckBox2))
                .addGap(33, 33, 33)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel33)
                            .addComponent(jCheckBoxScaleToByte)
                            .addComponent(jLabel3)
                            .addComponent(jLabel2)
                            .addComponent(jLabel1))
                        .addGap(5, 5, 5)
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldRotateSteps, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel23Layout.createSequentialGroup()
                                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldRotateY, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextFieldRotateX, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextFieldRotateZ, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jCheckBoxyrotdir)
                                    .addComponent(jCheckBoxxrotdir)
                                    .addComponent(jCheckBoxzrotdir)))))
                    .addComponent(jButton4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addComponent(jButtonSelectionRotation, javax.swing.GroupLayout.DEFAULT_SIZE, 168, Short.MAX_VALUE)
                        .addGap(22, 22, 22)))
                .addContainerGap())
        );
        jPanel23Layout.setVerticalGroup(
            jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel23Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxzrotdir, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jTextFieldRotateZ, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel1, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jCheckBox2, javax.swing.GroupLayout.Alignment.TRAILING))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxxrotdir, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jTextFieldRotateX, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel2, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jCheckBox3, javax.swing.GroupLayout.Alignment.TRAILING))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxyrotdir, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jTextFieldRotateY, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel3, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jCheckBox4, javax.swing.GroupLayout.Alignment.TRAILING))
                .addGap(0, 0, 0)
                .addComponent(jCheckBoxScaleToByte)
                .addGap(0, 0, 0)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextFieldRotateSteps, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel33))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox5)
                    .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(6, 6, 6)
                .addComponent(jButtonSelectionRotation, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        jTabbedPane1.addTab("Rotation", jPanel23);

        jLabel7.setText("steps");

        jTextFieldMorphSteps.setText("12");
        jTextFieldMorphSteps.setPreferredSize(new java.awt.Dimension(20, 21));

        jButton6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/accept.png"))); // NOI18N
        jButton6.setText("do it");
        jButton6.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton6.setPreferredSize(new java.awt.Dimension(80, 21));
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6ActionPerformed(evt);
            }
        });

        jLabel8.setText("Morphing is done between the first and second");

        jLabel9.setText("vectorlist in the animation. The resulting ");

        jLabel20.setText("morph-step vectorlists are added to the ");

        jLabel21.setText("animation.");

        javax.swing.GroupLayout jPanel24Layout = new javax.swing.GroupLayout(jPanel24);
        jPanel24.setLayout(jPanel24Layout);
        jPanel24Layout.setHorizontalGroup(
            jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel24Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel20, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel21, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel24Layout.createSequentialGroup()
                        .addComponent(jLabel7)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldMorphSteps, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButton6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel24Layout.setVerticalGroup(
            jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel24Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel8)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel9)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel20)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel21)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextFieldMorphSteps, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel7)
                    .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(82, 82, 82))
        );

        jTabbedPane1.addTab("Morphing", jPanel24);

        jButtonPathsAsScenario.setText("seperate paths as scenario entries");
        jButtonPathsAsScenario.setPreferredSize(new java.awt.Dimension(74, 21));
        jButtonPathsAsScenario.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPathsAsScenarioActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel14Layout = new javax.swing.GroupLayout(jPanel14);
        jPanel14.setLayout(jPanel14Layout);
        jPanel14Layout.setHorizontalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel14Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonPathsAsScenario, javax.swing.GroupLayout.DEFAULT_SIZE, 226, Short.MAX_VALUE)
                .addContainerGap(70, Short.MAX_VALUE))
        );
        jPanel14Layout.setVerticalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel14Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonPathsAsScenario, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Scenario", jPanel14);

        javax.swing.GroupLayout jPanel22Layout = new javax.swing.GroupLayout(jPanel22);
        jPanel22.setLayout(jPanel22Layout);
        jPanel22Layout.setHorizontalGroup(
            jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
        );
        jPanel22Layout.setVerticalGroup(
            jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
        );

        jTabbedPane6.addTab("build animation", jPanel22);

        jLabelAnim.setText("DISPLAY");
        jLabelAnim.setToolTipText("Animation/Scenario");

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(single3dDisplayPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jSliderSourceScale1, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addComponent(jLabelDelay)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldDelay, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jToggleButtonPlayAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addComponent(jLabelAnim))
                .addGap(5, 5, 5)
                .addComponent(jTabbedPane6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTabbedPane4)
                .addGap(0, 0, 0)
                .addComponent(jTabbedPane2))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jTabbedPane6, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jTabbedPane4, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                    .addComponent(jTabbedPane2)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel5Layout.createSequentialGroup()
                        .addComponent(jLabelAnim)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(single3dDisplayPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jSliderSourceScale1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jToggleButtonPlayAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jTextFieldDelay, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabelDelay)))
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addGap(3, 3, 3))
        );

        jPanel6.setBorder(javax.swing.BorderFactory.createTitledBorder("vectorlist"));

        jLabelMaxY.setText("128");

        jLabelY0.setText("000");

        jLabelMinY.setText("-128");

        jSliderSourceScale.setMajorTickSpacing(1);
        jSliderSourceScale.setMinimum(1);
        jSliderSourceScale.setMinorTickSpacing(1);
        jSliderSourceScale.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderSourceScale.setPaintTicks(true);
        jSliderSourceScale.setSnapToTicks(true);
        jSliderSourceScale.setValue(21);
        jSliderSourceScale.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderSourceScaleStateChanged(evt);
            }
        });

        jLabelScale.setText("Scale: 1");

        jCheckBoxByteFrame.setSelected(true);
        jCheckBoxByteFrame.setText("byteFrame");
        jCheckBoxByteFrame.setToolTipText("display a frame around coordinates of a signed byte (-128 <-> +127)");
        jCheckBoxByteFrame.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxByteFrameActionPerformed(evt);
            }
        });

        jPanelScroller.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jPanelScrollerMouseClicked(evt);
            }
        });
        jPanelScroller.setLayout(null);

        jButtonUp.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_up.png"))); // NOI18N
        jButtonUp.setToolTipText("select all");
        jButtonUp.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonUp.setMargin(new java.awt.Insets(-1, -3, -1, -4));
        jButtonUp.setPreferredSize(new java.awt.Dimension(14, 18));
        jButtonUp.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonUpActionPerformed(evt);
            }
        });
        jPanelScroller.add(jButtonUp);
        jButtonUp.setBounds(19, 1, 14, 18);

        jButtonDown.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_down.png"))); // NOI18N
        jButtonDown.setToolTipText("select all");
        jButtonDown.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDown.setMargin(new java.awt.Insets(-1, -3, -1, -4));
        jButtonDown.setPreferredSize(new java.awt.Dimension(14, 18));
        jButtonDown.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDownActionPerformed(evt);
            }
        });
        jPanelScroller.add(jButtonDown);
        jButtonDown.setBounds(19, 31, 14, 18);

        jButtonLeft.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_left.png"))); // NOI18N
        jButtonLeft.setToolTipText("select all");
        jButtonLeft.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonLeft.setMargin(new java.awt.Insets(-4, 0, -4, -1));
        jButtonLeft.setPreferredSize(new java.awt.Dimension(65, 19));
        jButtonLeft.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLeftActionPerformed(evt);
            }
        });
        jPanelScroller.add(jButtonLeft);
        jButtonLeft.setBounds(0, 18, 19, 14);

        jButtonRight.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_right.png"))); // NOI18N
        jButtonRight.setToolTipText("select all");
        jButtonRight.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonRight.setMargin(new java.awt.Insets(-1, 0, -1, -1));
        jButtonRight.setPreferredSize(new java.awt.Dimension(65, 19));
        jButtonRight.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRightActionPerformed(evt);
            }
        });
        jPanelScroller.add(jButtonRight);
        jButtonRight.setBounds(33, 18, 19, 14);

        jPanel18.setLayout(null);

        jLabelStartInX.setText("start point:");
        jLabelStartInX.setPreferredSize(new java.awt.Dimension(61, 21));
        jPanel18.add(jLabelStartInX);
        jLabelStartInX.setBounds(13, 1, 140, 21);

        jLabelCurrent.setText("current:");
        jLabelCurrent.setPreferredSize(new java.awt.Dimension(40, 21));
        jPanel18.add(jLabelCurrent);
        jLabelCurrent.setBounds(173, 1, 80, 21);

        jTextFieldStartX.setText("80");
        jTextFieldStartX.setPreferredSize(new java.awt.Dimension(0, 21));
        jPanel18.add(jTextFieldStartX);
        jTextFieldStartX.setBounds(10, 22, 40, 21);

        jTextFieldCurrentZ.setText("80");
        jTextFieldCurrentZ.setPreferredSize(new java.awt.Dimension(0, 21));
        jPanel18.add(jTextFieldCurrentZ);
        jTextFieldCurrentZ.setBounds(270, 22, 40, 21);

        jTextFieldCurrentY.setText("80");
        jTextFieldCurrentY.setPreferredSize(new java.awt.Dimension(0, 21));
        jPanel18.add(jTextFieldCurrentY);
        jTextFieldCurrentY.setBounds(220, 22, 40, 21);

        jLabelCount.setText("count:");
        jPanel18.add(jLabelCount);
        jLabelCount.setBounds(120, 350, 60, 20);

        jTextFieldStartZ.setText("80");
        jTextFieldStartZ.setPreferredSize(new java.awt.Dimension(0, 21));
        jPanel18.add(jTextFieldStartZ);
        jTextFieldStartZ.setBounds(110, 22, 40, 21);

        jLabelX.setText("<- X(y) ->");
        jPanel18.add(jLabelX);
        jLabelX.setBounds(10, 350, 90, 20);

        jTextFieldStartY.setText("80");
        jTextFieldStartY.setPreferredSize(new java.awt.Dimension(0, 21));
        jPanel18.add(jTextFieldStartY);
        jTextFieldStartY.setBounds(60, 22, 40, 21);

        jTextFieldVectorCount.setText("0");
        jTextFieldVectorCount.setPreferredSize(new java.awt.Dimension(0, 21));
        jPanel18.add(jTextFieldVectorCount);
        jTextFieldVectorCount.setBounds(170, 350, 40, 21);

        singleVectorPanel1.setMaximumSize(new java.awt.Dimension(300, 300));
        singleVectorPanel1.setMinimumSize(new java.awt.Dimension(300, 300));
        singleVectorPanel1.setPreferredSize(new java.awt.Dimension(300, 300));

        javax.swing.GroupLayout singleVectorPanel1Layout = new javax.swing.GroupLayout(singleVectorPanel1);
        singleVectorPanel1.setLayout(singleVectorPanel1Layout);
        singleVectorPanel1Layout.setHorizontalGroup(
            singleVectorPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );
        singleVectorPanel1Layout.setVerticalGroup(
            singleVectorPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );

        jPanel18.add(singleVectorPanel1);
        singleVectorPanel1.setBounds(10, 46, 300, 300);

        jTextFieldCurrentX.setText("80");
        jTextFieldCurrentX.setPreferredSize(new java.awt.Dimension(0, 21));
        jPanel18.add(jTextFieldCurrentX);
        jTextFieldCurrentX.setBounds(170, 22, 40, 21);

        jCheckBoxGrid.setSelected(true);
        jCheckBoxGrid.setText("grid");
        jCheckBoxGrid.setToolTipText("display grid");
        jCheckBoxGrid.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                jCheckBoxGridItemStateChanged(evt);
            }
        });
        jCheckBoxGrid.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxGridActionPerformed(evt);
            }
        });
        jPanel18.add(jCheckBoxGrid);
        jCheckBoxGrid.setBounds(210, 350, 70, 23);

        jTextFieldGridWidth.setText("1");
        jTextFieldGridWidth.setToolTipText("grid distance");
        jTextFieldGridWidth.setPreferredSize(new java.awt.Dimension(0, 21));
        jTextFieldGridWidth.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldGridWidthFocusLost(evt);
            }
        });
        jTextFieldGridWidth.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldGridWidthActionPerformed(evt);
            }
        });
        jPanel18.add(jTextFieldGridWidth);
        jTextFieldGridWidth.setBounds(280, 350, 30, 21);

        jPanel31.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jButtonSelectAll.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/asterisk_orange.png"))); // NOI18N
        jButtonSelectAll.setToolTipText("select all (vectors)");
        jButtonSelectAll.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonSelectAll.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSelectAll.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSelectAllActionPerformed(evt);
            }
        });

        jButtonSaveSelection.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_edit.png"))); // NOI18N
        jButtonSaveSelection.setToolTipText("save selection as vectorlist");
        jButtonSaveSelection.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSaveSelection.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveSelectionActionPerformed(evt);
            }
        });

        jButtonInsertYM.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_add.png"))); // NOI18N
        jButtonInsertYM.setToolTipText("insert vectorlist");
        jButtonInsertYM.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonInsertYM.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonInsertVectorList(evt);
            }
        });

        jButtonCut.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/cut.png"))); // NOI18N
        jButtonCut.setToolTipText("cut current selection!");
        jButtonCut.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonCut.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCutActionPerformed(evt);
            }
        });

        jButtonPaste.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/paste_plain.png"))); // NOI18N
        jButtonPaste.setToolTipText("paste as selection (from buffer)");
        jButtonPaste.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonPaste.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPasteActionPerformed(evt);
            }
        });

        jButtonCopy.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_copy.png"))); // NOI18N
        jButtonCopy.setToolTipText("copy (to buffer)");
        jButtonCopy.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonCopy.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCopyActionPerformed(evt);
            }
        });

        jButtonRedo.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_redo.png"))); // NOI18N
        jButtonRedo.setToolTipText("Redo (SHIFT 10 times redo)");
        jButtonRedo.setEnabled(false);
        jButtonRedo.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonRedo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRedoActionPerformed(evt);
            }
        });

        jButtonUndo.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_undo.png"))); // NOI18N
        jButtonUndo.setToolTipText("Undo (SHIFT 10 times undo)");
        jButtonUndo.setEnabled(false);
        jButtonUndo.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonUndo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonUndoActionPerformed(evt);
            }
        });

        jButtonSave1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave1.setToolTipText("save vectorlist");
        jButtonSave1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSave1ActionPerformed(evt);
            }
        });

        jButtonLoad.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad.setToolTipText("load vectorlist");
        jButtonLoad.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoadActionPerformed(evt);
            }
        });

        jButtonOneForwardSelection1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/new.png"))); // NOI18N
        jButtonOneForwardSelection1.setToolTipText("New vectorlist");
        jButtonOneForwardSelection1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonOneForwardSelection1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOneForwardSelection1ActionPerformed(evt);
            }
        });

        jLabelMode.setFont(new java.awt.Font("Times", 1, 12)); // NOI18N
        jLabelMode.setForeground(new java.awt.Color(51, 51, 255));
        jLabelMode.setText("SET");

        jCheckBox12.setToolTipText("TF :-) [send generated sources directly to VecFever - if available]");

        javax.swing.GroupLayout jPanel31Layout = new javax.swing.GroupLayout(jPanel31);
        jPanel31.setLayout(jPanel31Layout);
        jPanel31Layout.setHorizontalGroup(
            jPanel31Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel31Layout.createSequentialGroup()
                .addComponent(jButtonLoad)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSave1)
                .addGap(18, 18, 18)
                .addComponent(jButtonOneForwardSelection1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jButtonUndo)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonRedo)
                .addGap(18, 18, 18)
                .addComponent(jButtonSelectAll)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonCopy)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonPaste)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonCut)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonInsertYM)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSaveSelection)
                .addGap(27, 27, 27)
                .addComponent(jLabelMode, javax.swing.GroupLayout.PREFERRED_SIZE, 79, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jCheckBox12))
        );
        jPanel31Layout.setVerticalGroup(
            jPanel31Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jLabelMode, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel31Layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addGroup(jPanel31Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButtonOneForwardSelection1)
                    .addGroup(jPanel31Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jButtonSave1)
                        .addComponent(jButtonLoad)
                        .addComponent(jButtonCopy)
                        .addComponent(jButtonPaste)
                        .addComponent(jButtonCut)
                        .addComponent(jButtonInsertYM)
                        .addComponent(jButtonSaveSelection))
                    .addGroup(jPanel31Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jButtonRedo)
                        .addComponent(jButtonUndo))))
            .addComponent(jButtonSelectAll, javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jCheckBox12, javax.swing.GroupLayout.Alignment.LEADING)
        );

        jButtonSingleEditor.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/application_get.png"))); // NOI18N
        jButtonSingleEditor.setToolTipText("open a large editor window (synchronized)");
        jButtonSingleEditor.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSingleEditor.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSingleEditorActionPerformed(evt);
            }
        });

        jButtonSingleEditor1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/application_view_gallery.png"))); // NOI18N
        jButtonSingleEditor1.setToolTipText("open a large 3d editor window (synchronized)");
        jButtonSingleEditor1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSingleEditor1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSingleEditor1ActionPerformed(evt);
            }
        });

        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jTable1.setSelectionMode(javax.swing.ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
        jTable1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTable1MousePressed(evt);
            }
        });
        jScrollPane1.setViewportView(jTable1);

        jCheckBox1.setSelected(true);
        jCheckBox1.setText("display vector length");
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jButton10.setText("int");
        jButton10.setToolTipText("all coordinates = their integer part");
        jButton10.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton10.setPreferredSize(new java.awt.Dimension(80, 21));
        jButton10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton10ActionPerformed(evt);
            }
        });

        jCheckBoxAlwaysInt.setText("always \"int\"");
        jCheckBoxAlwaysInt.setToolTipText("Might cause \"distortions\" when used wit draging of vectorlists");
        jCheckBoxAlwaysInt.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxAlwaysIntActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jCheckBox1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButton10, javax.swing.GroupLayout.PREFERRED_SIZE, 62, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBoxAlwaysInt, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 383, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox1)
                    .addComponent(jButton10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxAlwaysInt))
                .addGap(11, 11, 11))
        );

        jTabbedPane5.addTab("Vector List", jPanel4);

        jPanel16.setLayout(null);

        singleImagePanel2.setMaximumSize(new java.awt.Dimension(300, 300));
        singleImagePanel2.setMinimumSize(new java.awt.Dimension(300, 300));
        singleImagePanel2.setPreferredSize(new java.awt.Dimension(300, 300));

        javax.swing.GroupLayout singleImagePanel2Layout = new javax.swing.GroupLayout(singleImagePanel2);
        singleImagePanel2.setLayout(singleImagePanel2Layout);
        singleImagePanel2Layout.setHorizontalGroup(
            singleImagePanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );
        singleImagePanel2Layout.setVerticalGroup(
            singleImagePanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );

        jPanel16.add(singleImagePanel2);
        singleImagePanel2.setBounds(309, 15, 300, 300);

        singleImagePanel3.setMaximumSize(new java.awt.Dimension(300, 300));
        singleImagePanel3.setMinimumSize(new java.awt.Dimension(300, 300));
        singleImagePanel3.setPreferredSize(new java.awt.Dimension(300, 300));

        javax.swing.GroupLayout singleImagePanel3Layout = new javax.swing.GroupLayout(singleImagePanel3);
        singleImagePanel3.setLayout(singleImagePanel3Layout);
        singleImagePanel3Layout.setHorizontalGroup(
            singleImagePanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );
        singleImagePanel3Layout.setVerticalGroup(
            singleImagePanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );

        jPanel16.add(singleImagePanel3);
        singleImagePanel3.setBounds(0, 15, 300, 300);

        jLabelY.setText("<- Y(z) ->");
        jPanel16.add(jLabelY);
        jLabelY.setBounds(0, 319, 130, 20);

        jLabelZ.setText("<- Z(x) ->");
        jPanel16.add(jLabelZ);
        jLabelZ.setBounds(480, 320, 130, 21);

        jTextFieldExpandYZ.setText("1");
        jTextFieldExpandYZ.setMinimumSize(new java.awt.Dimension(6, 21));
        jTextFieldExpandYZ.setPreferredSize(new java.awt.Dimension(13, 21));
        jPanel16.add(jTextFieldExpandYZ);
        jTextFieldExpandYZ.setBounds(280, 320, 30, 21);

        jButtonExpandDimensionYZ.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_out.png"))); // NOI18N
        jButtonExpandDimensionYZ.setText("expand");
        jButtonExpandDimensionYZ.setToolTipText("Deletes selected vectorlist.");
        jButtonExpandDimensionYZ.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonExpandDimensionYZ.setPreferredSize(new java.awt.Dimension(62, 21));
        jButtonExpandDimensionYZ.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonExpandDimensionYZActionPerformed(evt);
            }
        });
        jPanel16.add(jButtonExpandDimensionYZ);
        jButtonExpandDimensionYZ.setBounds(140, 320, 130, 21);

        jCheckBoxDragVectors.setText("drag vectors");
        jCheckBoxDragVectors.setPreferredSize(new java.awt.Dimension(89, 21));
        jPanel16.add(jCheckBoxDragVectors);
        jCheckBoxDragVectors.setBounds(320, 320, 150, 21);

        jTabbedPane5.addTab("Y/Z", jPanel16);

        jSliderSide.setMajorTickSpacing(30);
        jSliderSide.setMaximum(360);
        jSliderSide.setPaintTicks(true);
        jSliderSide.setValue(0);
        jSliderSide.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderSideStateChanged(evt);
            }
        });

        jSliderTop.setMajorTickSpacing(30);
        jSliderTop.setMaximum(360);
        jSliderTop.setPaintTicks(true);
        jSliderTop.setValue(0);
        jSliderTop.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderTopStateChanged(evt);
            }
        });

        jSliderFront.setMajorTickSpacing(30);
        jSliderFront.setMaximum(360);
        jSliderFront.setPaintTicks(true);
        jSliderFront.setValue(0);
        jSliderFront.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderFrontStateChanged(evt);
            }
        });

        jTextFieldSide.setText("0");
        jTextFieldSide.setPreferredSize(new java.awt.Dimension(13, 21));

        jTextFieldTop.setText("0");
        jTextFieldTop.setPreferredSize(new java.awt.Dimension(13, 21));

        jLabel10.setText("X-axis");

        jLabel12.setText("Y-axis");

        jLabel13.setText("Z-axis");

        jTextFieldFront.setText("0");
        jTextFieldFront.setPreferredSize(new java.awt.Dimension(13, 21));
        jTextFieldFront.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldFrontActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel8Layout = new javax.swing.GroupLayout(jPanel8);
        jPanel8.setLayout(jPanel8Layout);
        jPanel8Layout.setHorizontalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel10)
                            .addComponent(jLabel12))
                        .addGap(17, 17, 17))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel8Layout.createSequentialGroup()
                        .addComponent(jLabel13)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)))
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jSliderTop, javax.swing.GroupLayout.DEFAULT_SIZE, 234, Short.MAX_VALUE)
                    .addComponent(jSliderFront, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                    .addComponent(jSliderSide, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jTextFieldFront, javax.swing.GroupLayout.DEFAULT_SIZE, 33, Short.MAX_VALUE)
                    .addComponent(jTextFieldSide, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jTextFieldTop, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap(114, Short.MAX_VALUE))
        );
        jPanel8Layout.setVerticalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel8Layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jTextFieldFront, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addGap(5, 5, 5)
                        .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jSliderFront, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel10))))
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jSliderSide, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel12))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel13))
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addGap(12, 12, 12)
                        .addComponent(jTextFieldSide, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel8Layout.createSequentialGroup()
                                .addGap(18, 18, 18)
                                .addComponent(jSliderTop, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel8Layout.createSequentialGroup()
                                .addGap(26, 26, 26)
                                .addComponent(jTextFieldTop, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                .addGap(0, 237, Short.MAX_VALUE))
        );

        jTabbedPane3.addTab("object angle", jPanel8);

        jLabel11.setText("X-axis");

        jLabel15.setText("Y-axis");

        jLabel16.setText("Z-axis");

        jSliderFrontTranslocationZ.setMajorTickSpacing(16);
        jSliderFrontTranslocationZ.setMaximum(128);
        jSliderFrontTranslocationZ.setMinimum(-128);
        jSliderFrontTranslocationZ.setPaintTicks(true);
        jSliderFrontTranslocationZ.setValue(0);
        jSliderFrontTranslocationZ.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderFrontTranslocationZStateChanged(evt);
            }
        });

        jSliderFrontTranslocationY.setMajorTickSpacing(16);
        jSliderFrontTranslocationY.setMaximum(128);
        jSliderFrontTranslocationY.setMinimum(-128);
        jSliderFrontTranslocationY.setPaintTicks(true);
        jSliderFrontTranslocationY.setValue(0);
        jSliderFrontTranslocationY.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderFrontTranslocationYStateChanged(evt);
            }
        });

        jSliderFrontTranslocationX.setMajorTickSpacing(16);
        jSliderFrontTranslocationX.setMaximum(128);
        jSliderFrontTranslocationX.setMinimum(-128);
        jSliderFrontTranslocationX.setPaintTicks(true);
        jSliderFrontTranslocationX.setValue(0);
        jSliderFrontTranslocationX.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderFrontTranslocationXStateChanged(evt);
            }
        });

        jTextFieldFront1.setText("0");
        jTextFieldFront1.setPreferredSize(new java.awt.Dimension(13, 21));

        jTextFieldSide1.setText("0");
        jTextFieldSide1.setPreferredSize(new java.awt.Dimension(13, 21));

        jTextFieldTop1.setText("0");
        jTextFieldTop1.setPreferredSize(new java.awt.Dimension(13, 21));

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel11)
                            .addComponent(jLabel15))
                        .addGap(17, 17, 17))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel16)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)))
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jSliderFrontTranslocationZ, javax.swing.GroupLayout.DEFAULT_SIZE, 335, Short.MAX_VALUE)
                    .addComponent(jSliderFrontTranslocationX, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                    .addComponent(jSliderFrontTranslocationY, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jTextFieldFront1, javax.swing.GroupLayout.DEFAULT_SIZE, 33, Short.MAX_VALUE)
                    .addComponent(jTextFieldSide1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jTextFieldTop1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel2Layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jTextFieldFront1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGap(5, 5, 5)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jSliderFrontTranslocationX, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel11))))
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jSliderFrontTranslocationY, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel15))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel16))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGap(12, 12, 12)
                        .addComponent(jTextFieldSide1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGap(18, 18, 18)
                                .addComponent(jSliderFrontTranslocationZ, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGap(26, 26, 26)
                                .addComponent(jTextFieldTop1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                .addGap(0, 0, Short.MAX_VALUE))
        );

        jTabbedPane3.addTab("object translocation", jPanel2);

        jLabel14.setText("X-axis");

        jLabel17.setText("Y-axis");

        jLabel18.setText("Z-axis");

        jSliderTop1.setMajorTickSpacing(30);
        jSliderTop1.setMaximum(360);
        jSliderTop1.setPaintTicks(true);
        jSliderTop1.setValue(31);
        jSliderTop1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderTop1StateChanged(evt);
            }
        });

        jSliderSide1.setMajorTickSpacing(30);
        jSliderSide1.setMaximum(360);
        jSliderSide1.setPaintTicks(true);
        jSliderSide1.setValue(49);
        jSliderSide1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderSide1StateChanged(evt);
            }
        });

        jSliderFront1.setMajorTickSpacing(30);
        jSliderFront1.setMaximum(360);
        jSliderFront1.setPaintTicks(true);
        jSliderFront1.setValue(38);
        jSliderFront1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderFront1StateChanged(evt);
            }
        });

        jTextFieldFront2.setText("38");
        jTextFieldFront2.setPreferredSize(new java.awt.Dimension(20, 21));

        jTextFieldSide2.setText("49");
        jTextFieldSide2.setPreferredSize(new java.awt.Dimension(20, 21));

        jTextFieldTop2.setText("31");
        jTextFieldTop2.setPreferredSize(new java.awt.Dimension(20, 21));

        jButton2dAxis.setText("axis 2d");
        jButton2dAxis.setPreferredSize(new java.awt.Dimension(20, 21));
        jButton2dAxis.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2dAxisActionPerformed(evt);
            }
        });

        jButton3dAxis.setText("axis 3d");
        jButton3dAxis.setPreferredSize(new java.awt.Dimension(20, 21));
        jButton3dAxis.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3dAxisActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel7Layout = new javax.swing.GroupLayout(jPanel7);
        jPanel7.setLayout(jPanel7Layout);
        jPanel7Layout.setHorizontalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel14)
                    .addComponent(jLabel17)
                    .addComponent(jLabel18))
                .addGap(17, 17, 17)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jSliderTop1, javax.swing.GroupLayout.DEFAULT_SIZE, 236, Short.MAX_VALUE)
                            .addComponent(jSliderFront1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                            .addComponent(jSliderSide1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jTextFieldFront2, javax.swing.GroupLayout.DEFAULT_SIZE, 33, Short.MAX_VALUE)
                            .addComponent(jTextFieldSide2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jTextFieldTop2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addContainerGap(116, Short.MAX_VALUE))
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jButton3dAxis, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButton2dAxis, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
        );
        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel7Layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jTextFieldFront2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addGap(5, 5, 5)
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jSliderFront1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel14))))
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jSliderSide1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel17))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel18))
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addGap(12, 12, 12)
                        .addComponent(jTextFieldSide2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel7Layout.createSequentialGroup()
                                .addGap(18, 18, 18)
                                .addComponent(jSliderTop1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel7Layout.createSequentialGroup()
                                .addGap(26, 26, 26)
                                .addComponent(jTextFieldTop2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButton2dAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton3dAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 178, Short.MAX_VALUE))
        );

        jTabbedPane3.addTab("axis angles", jPanel7);

        jLabelDelay1.setText("display axis");

        jCheckBoxDisplayAxis.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxDisplayAxisActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel21Layout = new javax.swing.GroupLayout(jPanel21);
        jPanel21.setLayout(jPanel21Layout);
        jPanel21Layout.setHorizontalGroup(
            jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel21Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTabbedPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 452, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel21Layout.createSequentialGroup()
                        .addComponent(jLabelDelay1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxDisplayAxis)))
                .addGap(0, 0, 0))
        );
        jPanel21Layout.setVerticalGroup(
            jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel21Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jTabbedPane3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabelDelay1, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jCheckBoxDisplayAxis, javax.swing.GroupLayout.Alignment.TRAILING))
                .addContainerGap())
        );

        jTabbedPane5.addTab("3d settings", jPanel21);

        jTextArea1.setColumns(20);
        jTextArea1.setFont(new java.awt.Font("Courier New", 1, 12)); // NOI18N
        jTextArea1.setRows(5);
        jScrollPane3.setViewportView(jTextArea1);

        single3dDisplayPanel1.setMaximumSize(new java.awt.Dimension(150, 150));
        single3dDisplayPanel1.setMinimumSize(new java.awt.Dimension(150, 150));
        single3dDisplayPanel1.setPreferredSize(new java.awt.Dimension(100, 100));

        javax.swing.GroupLayout single3dDisplayPanel1Layout = new javax.swing.GroupLayout(single3dDisplayPanel1);
        single3dDisplayPanel1.setLayout(single3dDisplayPanel1Layout);
        single3dDisplayPanel1Layout.setHorizontalGroup(
            single3dDisplayPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );
        single3dDisplayPanel1Layout.setVerticalGroup(
            single3dDisplayPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );

        jLabel22.setText("Input");

        jTextArea2.setColumns(20);
        jTextArea2.setFont(new java.awt.Font("Courier New", 1, 12)); // NOI18N
        jTextArea2.setRows(5);
        jScrollPane4.setViewportView(jTextArea2);

        jLabel23.setText("Interpretation");

        jLabel24.setText("display");

        jComboBoxPatterns.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPatterns.setPreferredSize(new java.awt.Dimension(180, 21));
        jComboBoxPatterns.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxPatternsActionPerformed(evt);
            }
        });

        jLabel25.setText("line 1");

        jLabel26.setText("line x");

        jLabel27.setText("last line");

        jTextField8.setText("%C");
        jTextField8.setPreferredSize(new java.awt.Dimension(180, 21));

        jTextField9.setPreferredSize(new java.awt.Dimension(180, 21));

        jTextField10.setText("%Y %X");
        jTextField10.setPreferredSize(new java.awt.Dimension(180, 21));

        jTextFieldPatternName.setPreferredSize(new java.awt.Dimension(180, 21));
        jTextFieldPatternName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPatternNameActionPerformed(evt);
            }
        });

        jButtonSave3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave3.setToolTipText("save current setting");
        jButtonSave3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSave3ActionPerformed(evt);
            }
        });

        jButtonInterprete.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/accept.png"))); // NOI18N
        jButtonInterprete.setToolTipText("Select previous, +SHIFT moves selected vectorlist one to the left.");
        jButtonInterprete.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonInterprete.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonInterprete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonInterpreteActionPerformed(evt);
            }
        });

        jLabel49.setText("multi");

        jButton11.setText("LoadFromHex");
        jButton11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton11ActionPerformed(evt);
            }
        });

        jButton12.setText("Level maze");
        jButton12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton12ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel22)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 287, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel23)
                    .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 250, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel25)
                                    .addComponent(jLabel26)
                                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                                        .addComponent(jButtonInterprete, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButtonSave3)))
                                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                                    .addComponent(jLabel49)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jCheckBoxMulti)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)))
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel24)
                                    .addComponent(jLabel27))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jTextField9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jTextFieldPatternName, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jTextField8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jTextField10, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(single3dDisplayPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jComboBoxPatterns, 0, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jButton12, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButton11, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addContainerGap(96, Short.MAX_VALUE))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel22)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 385, Short.MAX_VALUE))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel23)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane4))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addComponent(jLabel49)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonInterprete))
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jComboBoxPatterns, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jCheckBoxMulti))
                                .addGap(6, 6, 6)
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jTextFieldPatternName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jButtonSave3))))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel25))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel26))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel27)
                            .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(single3dDisplayPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel24))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButton11)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton12)
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addGap(0, 0, 0))
        );

        jTabbedPane7.addTab("text import", jPanel3);

        jLabel56.setText("File");

        jButtonLoad2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad2.setToolTipText("load wavefront obj file");
        jButtonLoad2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoad2ActionPerformed(evt);
            }
        });

        jCheckBoxDontRemoveDoubles.setText("do not remove doubles internally");

        javax.swing.GroupLayout jPanel38Layout = new javax.swing.GroupLayout(jPanel38);
        jPanel38.setLayout(jPanel38Layout);
        jPanel38Layout.setHorizontalGroup(
            jPanel38Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel38Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel56)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonLoad2)
                .addGap(93, 93, 93)
                .addComponent(jCheckBoxDontRemoveDoubles)
                .addContainerGap(547, Short.MAX_VALUE))
        );
        jPanel38Layout.setVerticalGroup(
            jPanel38Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel38Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel38Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxDontRemoveDoubles)
                    .addGroup(jPanel38Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                        .addComponent(jButtonLoad2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel56, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
        );

        jTabbedPane7.addTab("Wavefront *.obj", jPanel38);

        jButtonExport1.setText("User Import");
        jButtonExport1.setPreferredSize(new java.awt.Dimension(91, 21));
        jButtonExport1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonExport1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel15Layout = new javax.swing.GroupLayout(jPanel15);
        jPanel15.setLayout(jPanel15Layout);
        jPanel15Layout.setHorizontalGroup(
            jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel15Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonExport1, javax.swing.GroupLayout.PREFERRED_SIZE, 190, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(674, Short.MAX_VALUE))
        );
        jPanel15Layout.setVerticalGroup(
            jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel15Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonExport1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0))
        );

        jTabbedPane7.addTab("user import", jPanel15);

        javax.swing.GroupLayout jPanel25Layout = new javax.swing.GroupLayout(jPanel25);
        jPanel25.setLayout(jPanel25Layout);
        jPanel25Layout.setHorizontalGroup(
            jPanel25Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane7)
        );
        jPanel25Layout.setVerticalGroup(
            jPanel25Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane7)
        );

        jTabbedPane5.addTab("import", jPanel25);

        jTextAreaResult.setColumns(20);
        jTextAreaResult.setFont(new java.awt.Font("Courier New", 1, 12)); // NOI18N
        jTextAreaResult.setRows(5);
        jScrollPane5.setViewportView(jTextAreaResult);

        jPanel29.setBorder(javax.swing.BorderFactory.createTitledBorder("VectorList"));

        jButtonMov_Draw_VLc_a.setText("Mov_Draw_VLc_a");
        jButtonMov_Draw_VLc_a.setToolTipText("<html>\n<B>Mov_Draw_VLc_a</B>        <BR>                                  \n                                                <BR>                            \nThis routine moves to the first location specified in vector list,    <BR>     \nand then draws lines between the rest of coordinates in the list.    <BR>      \nThe number of vectors to draw is specified as the first byte in the   <BR>     \nvector list.  The current scale factor is used.  The vector list has  <BR>     \nthe following format:                                                 <BR>     \n                                       <BR>                                  \n<PRE>\n   count, rel y, rel x, rel y, rel x, ... \n</PRE>\n<BR>     \n</html>");
        jButtonMov_Draw_VLc_a.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonMov_Draw_VLc_a.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonMov_Draw_VLc_a.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonMov_Draw_VLc_a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonMov_Draw_VLc_aActionPerformed(evt);
            }
        });

        jButtonDraw_VLc.setText("Draw_VLc");
        jButtonDraw_VLc.setToolTipText("<html>\n<B>Draw_VLc</B>        <BR>                                  \n                                                <BR>                            \nThis routine draws vectors between the set of (y,x) points pointed    <BR>     \nto by the X register.  The number of vectors to draw is specified     <BR>     \nas the first byte in the vector list.  The current scale factor is    <BR>     \nused.  The vector list has the following format:                      <BR>  \n<BR>\n<PRE>\n   count, rel y, rel x, rel y, rel x, ... \n</PRE>\n<BR>     \n</html>\n\n\n   \n");
        jButtonDraw_VLc.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VLc.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonDraw_VLc.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonDraw_VLc.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VLcActionPerformed(evt);
            }
        });

        jButtonDraw_VLp.setText("Draw_VLp");
        jButtonDraw_VLp.setToolTipText("<html>\n<B>Draw_VLp</B>        <BR>                                  \n                                                <BR>                            \nThis routine draws patterned lines using the vector list pointed to   <BR>\nby the X-register.  The current scale factor is used.  The vector   <BR>\nlist has the following format: <BR>\n<BR>\n<PRE>\n      pattern, rel y, rel x                                           \n      pattern, rel y, rel x                                           \n         .      .      .                                              \n         .      .      .                                              \n      pattern, rel y, rel x                                           \n      0x01 \n</PRE>\n<BR>     \n</html>\n");
        jButtonDraw_VLp.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VLp.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonDraw_VLp.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonDraw_VLp.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VLpActionPerformed(evt);
            }
        });

        jButtonDraw_VL_mode.setText("Draw_VL_mode");
        jButtonDraw_VL_mode.setToolTipText("<html>\n<B>Draw_VL_mode</B>        <BR>                                  \n                                                <BR>                            \nThis routine processes the vector list pointed to by the X register.  <BR> \nThe current scale factor is used.  The vector list has the following  <BR> \nformat: <BR> \n<BR>\n<PRE>\n     mode, rel y, rel x,                                             \n     mode, rel y, rel x,                                             \n     .      .      .                                                \n     .      .      .                                                \n     mode, rel y, rel x,                                             \n     0x01  \n</PRE>\n<BR>\nwhere mode has the following meaning:         <BR>                        \n                                              <BR>                    \n< 0  use the pattern in $C829        <BR>                           \n= 0  move to specified endpoint      <BR>                           \n= 1  end of list, so return         <BR>                            \n> 1  draw to specified endpoint <BR>\n<BR>     \nThe pattern byte found in the textfield \"pattern byte\" will be used in example code!\n</html>\n");
        jButtonDraw_VL_mode.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VL_mode.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonDraw_VL_mode.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonDraw_VL_mode.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VL_modeActionPerformed(evt);
            }
        });

        jLabel4.setForeground(new java.awt.Color(102, 102, 102));
        jLabel4.setText("Only modes, which can");
        jLabel4.setPreferredSize(new java.awt.Dimension(210, 21));

        jLabel34.setForeground(new java.awt.Color(102, 102, 102));
        jLabel34.setText("be used by type of");
        jLabel34.setPreferredSize(new java.awt.Dimension(210, 21));

        jLabel35.setForeground(new java.awt.Color(102, 102, 102));
        jLabel35.setText("vectorlist (see: vectorlist status).");
        jLabel35.setPreferredSize(new java.awt.Dimension(210, 21));

        jLabel36.setForeground(new java.awt.Color(102, 102, 102));
        jLabel36.setText("(vectorlist must be ordered!)");
        jLabel36.setPreferredSize(new java.awt.Dimension(210, 21));

        jLabel37.setText("Label name:");

        jTextFieldLabelListname.setPreferredSize(new java.awt.Dimension(6, 21));

        jButtonDraw_syncList.setText("Draw sync list");
        jButtonDraw_syncList.setToolTipText("<html>\n<B>Draw sync list</B>        <BR>                                  \n                                                <BR>                            \nFormat developed by Malban, this format describes a \"large\".  <BR> \nVectorlist, which can be synced while drawing. Synced means,   <BR> \nthe beam is zeroed and moved to the next location.   <BR> \nVide automatically inserts a \"sync\" when vectors are not connected. <BR> \n<BR>\nThe Sync point is always the \"displayed\" point 0, 0, after a sync the beam is moved<BR>\nthe vectorlist 0, 0 and from there to the next displayed vector.<BR>\nformat: <BR> \n\nMethod to draw:<BR>\nU = address of vectorlist<BR>\nX = (y,x) position of vectorlist (this will be point 0,0), positioning<BR>\nA = scalefactor \"Move\" (after sync)<BR>\nB = scalefactor \"Vector\" (vectors in vectorlist)<BR>\n\n<BR>\n<PRE>\n     mode, rel y, rel x, <BR>\n     mode, rel y, rel x,<BR>\n     .      .      .        <BR>\n     .      .      .       <BR>\n     mode, rel y, rel x,  <BR>\n     0xff, 0xffff \n</PRE>\n<BR>\nwhere mode has the following meaning:         <BR>                        \n                                              <BR>                    \n0xff draw line        <BR>                           \n0  move to specified endpoint      <BR>                           \n1  sync (and move to specified endpoint)        <BR>     \n\n<BR>     \n</html>\n\n");
        jButtonDraw_syncList.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_syncList.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonDraw_syncList.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonDraw_syncList.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_syncListActionPerformed(evt);
            }
        });

        jTextFieldResync.setText("20");
        jTextFieldResync.setToolTipText("maximum resync size");
        jTextFieldResync.setPreferredSize(new java.awt.Dimension(20, 21));

        jCheckBoxVec32.setToolTipText("Vectrex32 BASIC output");

        jCheckBoxextendedList.setText("extended");
        jCheckBoxextendedList.setEnabled(false);

        jButtonDraw_3d.setText("3d");
        jButtonDraw_3d.setToolTipText("<html>\nThis button can be used to create 3d vectorlist to use with Malban 3d routines.<BR>\nAs of now only \"C\" output is supported.<BR>\n<BR>\nThe 3d routines can only handle \"unfiform\" vectors.<BR>\n<BR>\nUsing the checkbox you can change the way how vectors larger than 1 are treated:<BR>\n- they are made longer using scale (list type 3ds)<BR>\n- longer vectors result in multiple uniform vectors<BR>\n<BR>\nALL vectors must be drawn \"uniformly\" nonetheless.\n</html>");
        jButtonDraw_3d.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButtonDraw_3d.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonDraw_3d.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonDraw_3d.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_3dActionPerformed(evt);
            }
        });

        jCheckBox3ds.setToolTipText("If not checked \"3ds\" lists are created, if checked non 3ds lists.");

        jCheckBox16.setText("keep position (Draw_VLp only)");
        jCheckBox16.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox16ActionPerformed(evt);
            }
        });

        jCheckBoxAbsolut.setToolTipText("use absolut values - only in c, & shift 3d");

        jButtonDraw_absolut.setText("absolut list (start + end)");
        jButtonDraw_absolut.setToolTipText("<html>\n<B>Draw sync list</B>        <BR>                                  \n                                                <BR>                            \nFormat developed by Malban, this format describes a \"large\".  <BR> \nVectorlist, which can be synced while drawing. Synced means,   <BR> \nthe beam is zeroed and moved to the next location.   <BR> \nVide automatically inserts a \"sync\" when vectors are not connected. <BR> \n<BR>\nThe Sync point is always the \"displayed\" point 0, 0, after a sync the beam is moved<BR>\nthe vectorlist 0, 0 and from there to the next displayed vector.<BR>\nformat: <BR> \n\nMethod to draw:<BR>\nU = address of vectorlist<BR>\nX = (y,x) position of vectorlist (this will be point 0,0), positioning<BR>\nA = scalefactor \"Move\" (after sync)<BR>\nB = scalefactor \"Vector\" (vectors in vectorlist)<BR>\n\n<BR>\n<PRE>\n     mode, rel y, rel x, <BR>\n     mode, rel y, rel x,<BR>\n     .      .      .        <BR>\n     .      .      .       <BR>\n     mode, rel y, rel x,  <BR>\n     0xff, 0xffff \n</PRE>\n<BR>\nwhere mode has the following meaning:         <BR>                        \n                                              <BR>                    \n0xff draw line        <BR>                           \n0  move to specified endpoint      <BR>                           \n1  sync (and move to specified endpoint)        <BR>     \n\n<BR>     \n</html>\n\n");
        jButtonDraw_absolut.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_absolut.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonDraw_absolut.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonDraw_absolut.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_absolutActionPerformed(evt);
            }
        });

        jCheckBoxAbsolutStart.setSelected(true);
        jCheckBoxAbsolutStart.setText("start");

        jCheckBoxAbsolutEnd.setSelected(true);
        jCheckBoxAbsolutEnd.setText("end");

        javax.swing.GroupLayout jPanel29Layout = new javax.swing.GroupLayout(jPanel29);
        jPanel29.setLayout(jPanel29Layout);
        jPanel29Layout.setHorizontalGroup(
            jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel29Layout.createSequentialGroup()
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonDraw_VL_mode, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDraw_VLp, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDraw_VLc, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonMov_Draw_VLc_a, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDraw_syncList, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(6, 6, 6)
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel29Layout.createSequentialGroup()
                        .addComponent(jCheckBoxVec32)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel29Layout.createSequentialGroup()
                                .addComponent(jLabel34, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jCheckBox3ds))
                            .addGroup(jPanel29Layout.createSequentialGroup()
                                .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jButtonDraw_3d, javax.swing.GroupLayout.PREFERRED_SIZE, 1, Short.MAX_VALUE))
                            .addGroup(jPanel29Layout.createSequentialGroup()
                                .addComponent(jLabel36, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 0, Short.MAX_VALUE))
                            .addGroup(jPanel29Layout.createSequentialGroup()
                                .addComponent(jLabel35, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jCheckBoxAbsolut)))
                        .addContainerGap())
                    .addGroup(jPanel29Layout.createSequentialGroup()
                        .addComponent(jTextFieldResync, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(12, 12, 12)
                        .addComponent(jLabel37)
                        .addGap(12, 12, 12)
                        .addComponent(jTextFieldLabelListname, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxextendedList, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
            .addGroup(jPanel29Layout.createSequentialGroup()
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox16, javax.swing.GroupLayout.PREFERRED_SIZE, 295, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel29Layout.createSequentialGroup()
                        .addComponent(jButtonDraw_absolut, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jCheckBoxAbsolutStart)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jCheckBoxAbsolutEnd)))
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel29Layout.setVerticalGroup(
            jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel29Layout.createSequentialGroup()
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonMov_Draw_VLc_a, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDraw_3d, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButtonDraw_VLc, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel34, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jCheckBox3ds))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel35, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDraw_VLp, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxAbsolut))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButtonDraw_VL_mode, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel36, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jCheckBoxVec32))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel37)
                        .addComponent(jTextFieldLabelListname, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jCheckBoxextendedList))
                    .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButtonDraw_syncList, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextFieldResync, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonDraw_absolut, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxAbsolutStart)
                    .addComponent(jCheckBoxAbsolutEnd))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 6, Short.MAX_VALUE)
                .addComponent(jCheckBox16))
        );

        jPanel30.setBorder(javax.swing.BorderFactory.createTitledBorder("Animation/Scenario"));
        jPanel30.setToolTipText("");

        jButtonMov_Draw_VLc_aAnim.setText("Mov_Draw_VLc_a");
        jButtonMov_Draw_VLc_aAnim.setToolTipText("<html>\n<B>Mov_Draw_VLc_a</B>        <BR>                                  \n                                                <BR>                            \nThis routine moves to the first location specified in vector list,    <BR>     \nand then draws lines between the rest of coordinates in the list.    <BR>      \nThe number of vectors to draw is specified as the first byte in the   <BR>     \nvector list.  The current scale factor is used.  The vector list has  <BR>     \nthe following format:                                                 <BR>     \n                                       <BR>                                  \n<PRE>\n   count, rel y, rel x, rel y, rel x, ... \n</PRE>\n<BR>     \n</html>");
        jButtonMov_Draw_VLc_aAnim.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonMov_Draw_VLc_aAnim.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonMov_Draw_VLc_aAnim.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonMov_Draw_VLc_aAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonMov_Draw_VLc_aAnimActionPerformed(evt);
            }
        });

        jButtonDraw_VLcAnim.setText("Draw_VLc");
        jButtonDraw_VLcAnim.setToolTipText("<html>\n<B>Draw_VLc</B>        <BR>                                  \n                                                <BR>                            \nThis routine draws vectors between the set of (y,x) points pointed    <BR>     \nto by the X register.  The number of vectors to draw is specified     <BR>     \nas the first byte in the vector list.  The current scale factor is    <BR>     \nused.  The vector list has the following format:                      <BR>  \n<BR>\n<PRE>\n   count, rel y, rel x, rel y, rel x, ... \n</PRE>\n<BR>     \n</html>\n\n\n   \n");
        jButtonDraw_VLcAnim.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VLcAnim.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonDraw_VLcAnim.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonDraw_VLcAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VLcAnimActionPerformed(evt);
            }
        });

        jButtonDraw_VLpAnim.setText("Draw_VLp");
        jButtonDraw_VLpAnim.setToolTipText("<html>\n<B>Draw_VLp</B>        <BR>                                  \n                                                <BR>                            \nThis routine draws patterned lines using the vector list pointed to   <BR>\nby the X-register.  The current scale factor is used.  The vector   <BR>\nlist has the following format: <BR>\n<BR>\n<PRE>\n      pattern, rel y, rel x                                           \n      pattern, rel y, rel x                                           \n         .      .      .                                              \n         .      .      .                                              \n      pattern, rel y, rel x                                           \n      0x01 \n</PRE>\n<BR>     \n</html>\n");
        jButtonDraw_VLpAnim.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VLpAnim.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonDraw_VLpAnim.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonDraw_VLpAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VLpAnimActionPerformed(evt);
            }
        });

        jButtonDraw_VL_modeAnim.setText("Draw_VL_mode");
        jButtonDraw_VL_modeAnim.setToolTipText("<html>\n<B>Draw_VL_mode</B>        <BR>                                  \n                                                <BR>                            \nThis routine processes the vector list pointed to by the X register.  <BR> \nThe current scale factor is used.  The vector list has the following  <BR> \nformat: <BR> \n<BR>\n<PRE>\n     mode, rel y, rel x,                                             \n     mode, rel y, rel x,                                             \n     .      .      .                                                \n     .      .      .                                                \n     mode, rel y, rel x,                                             \n     0x01  \n</PRE>\n<BR>\nwhere mode has the following meaning:         <BR>                        \n                                              <BR>                    \n- 0  use the pattern in $C829        <BR>                           \n= 0  move to specified endpoint      <BR>                           \n= 1  end of list, so return         <BR>                            \n> 1  draw to specified endpoint <BR>\n<BR>     \n</html>\n");
        jButtonDraw_VL_modeAnim.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VL_modeAnim.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonDraw_VL_modeAnim.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonDraw_VL_modeAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VL_modeAnimActionPerformed(evt);
            }
        });

        jTextFieldAnimName.setPreferredSize(new java.awt.Dimension(6, 21));

        jLabel38.setText("Label name:");

        jLabel44.setForeground(new java.awt.Color(102, 102, 102));
        jLabel44.setText("Note: For Draw_VLc and Draw_VLp");
        jLabel44.setPreferredSize(new java.awt.Dimension(230, 21));

        jLabel45.setForeground(new java.awt.Color(102, 102, 102));
        jLabel45.setText("animations only make sense if all ");
        jLabel45.setPreferredSize(new java.awt.Dimension(230, 21));

        jLabel46.setForeground(new java.awt.Color(102, 102, 102));
        jLabel46.setText("frames share the same starting point!");
        jLabel46.setPreferredSize(new java.awt.Dimension(230, 21));

        jButtonDraw_syncListAnim.setText("Draw sync list");
        jButtonDraw_syncListAnim.setToolTipText("<html>\n<B>Draw sync list</B>        <BR>                                  \n                                                <BR>                            \nFormat developed by Malban, this format describes a \"large\".  <BR> \nVectorlist, which can be synced while drawing. Synced means,   <BR> \nthe beam is zeroed and moved to the next location.   <BR> \nVide automatically inserts a \"sync\" when vectors are not connected. <BR> \n<BR>\nThe Sync point is always the \"displayed\" point 0, 0, after a sync the beam is moved<BR>\nthe vectorlist 0, 0 and from there to the next displayed vector.<BR>\nformat: <BR> \n\nMethod to draw:<BR>\nU = address of vectorlist<BR>\nX = (y,x) position of vectorlist (this will be point 0,0), positioning<BR>\nA = scalefactor \"Move\" (after sync)<BR>\nB = scalefactor \"Vector\" (vectors in vectorlist)<BR>\n\n<BR>\n<PRE>\n     mode, rel y, rel x, <BR><BR>                                          \n     .      .      .  <BR>\n     .      .      .  <BR>\n     mode, rel y, rel x,         <BR>\n     0xff, 0xffff <BR>\n</PRE>\n<BR>\nwhere mode has the following meaning:         <BR>                        \n                                              <BR>                    \n0xff draw line        <BR>                           \n0  move to specified endpoint      <BR>                           \n1  sync (and move to specified endpoint)        <BR>     \n\n<BR>     \n</html>\n\n");
        jButtonDraw_syncListAnim.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_syncListAnim.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonDraw_syncListAnim.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonDraw_syncListAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_syncListAnimActionPerformed(evt);
            }
        });

        jTextFieldResyncAnim.setText("20");
        jTextFieldResyncAnim.setToolTipText("maximum resync size");
        jTextFieldResyncAnim.setPreferredSize(new java.awt.Dimension(20, 21));

        jCheckBoxExtendedAnimSync.setText("extended");
        jCheckBoxExtendedAnimSync.setToolTipText("if extended is selected, the generated sync list does also include intensity changes");

        jCheckBoxNoSyncOpt.setText("noOpt");
        jCheckBoxNoSyncOpt.setToolTipText("no additional optimization for synced lists");

        javax.swing.GroupLayout jPanel30Layout = new javax.swing.GroupLayout(jPanel30);
        jPanel30.setLayout(jPanel30Layout);
        jPanel30Layout.setHorizontalGroup(
            jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel30Layout.createSequentialGroup()
                .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonMov_Draw_VLc_aAnim, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDraw_VLcAnim, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDraw_VLpAnim, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDraw_VL_modeAnim, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDraw_syncListAnim, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel44, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel45, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel30Layout.createSequentialGroup()
                        .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel30Layout.createSequentialGroup()
                                .addComponent(jTextFieldResyncAnim, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(12, 12, 12)
                                .addComponent(jLabel38)
                                .addGap(12, 12, 12)
                                .addComponent(jTextFieldAnimName, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel46, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 0, 0)
                        .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxNoSyncOpt)
                            .addComponent(jCheckBoxExtendedAnimSync))))
                .addGap(6, 6, 6))
        );
        jPanel30Layout.setVerticalGroup(
            jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel30Layout.createSequentialGroup()
                .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel30Layout.createSequentialGroup()
                        .addComponent(jButtonMov_Draw_VLc_aAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel30Layout.createSequentialGroup()
                                .addComponent(jButtonDraw_VLcAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonDraw_VLpAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonDraw_VL_modeAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel30Layout.createSequentialGroup()
                                .addComponent(jLabel44, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel45, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel46, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(6, 6, 6))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel30Layout.createSequentialGroup()
                        .addComponent(jCheckBoxNoSyncOpt)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel38)
                        .addComponent(jTextFieldAnimName, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jCheckBoxExtendedAnimSync))
                    .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButtonDraw_syncListAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextFieldResyncAnim, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(35, Short.MAX_VALUE))
        );

        jCheckBoxRunnable.setText("runnable");
        jCheckBoxRunnable.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxRunnableActionPerformed(evt);
            }
        });

        jButtonAssemble.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jButtonAssemble.setToolTipText("Assemble current file, if if project is loaded, build project");
        jButtonAssemble.setEnabled(false);
        jButtonAssemble.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAssemble.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAssembleActionPerformed(evt);
            }
        });

        jButtonEditInVedi.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_edit.png"))); // NOI18N
        jButtonEditInVedi.setToolTipText("edit output in vedi");
        jButtonEditInVedi.setEnabled(false);
        jButtonEditInVedi.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonEditInVedi.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonEditInVediActionPerformed(evt);
            }
        });

        jCheckBoxAddFactor.setText("factor");

        buttonGroup3.add(jRadioButton3);
        jRadioButton3.setSelected(true);
        jRadioButton3.setText("db");
        jRadioButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton3ActionPerformed(evt);
            }
        });

        buttonGroup3.add(jRadioButton4);
        jRadioButton4.setText("fcb");
        jRadioButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton4ActionPerformed(evt);
            }
        });

        buttonGroup4.add(jRadioButton5);
        jRadioButton5.setSelected(true);
        jRadioButton5.setText("hex");
        jRadioButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton5ActionPerformed(evt);
            }
        });

        buttonGroup4.add(jRadioButton6);
        jRadioButton6.setText("dec");
        jRadioButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton6ActionPerformed(evt);
            }
        });

        jCheckBoxCStyle.setText("C");
        jCheckBoxCStyle.setToolTipText("if checked \"runnable\" is ignored!");

        jCheckBoxPCStyle.setText("PC");
        jCheckBoxPCStyle.setToolTipText("Only if \"C\" is checked as well, only for ..._VLc and ... VL_mode");
        jCheckBoxPCStyle.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxPCStyleActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel19Layout = new javax.swing.GroupLayout(jPanel19);
        jPanel19.setLayout(jPanel19Layout);
        jPanel19Layout.setHorizontalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel19Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jPanel30, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel29, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(2, 2, 2)
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane5)
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addComponent(jRadioButton3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jRadioButton4)
                        .addGap(40, 40, 40)
                        .addComponent(jRadioButton5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jRadioButton6)
                        .addContainerGap())
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addComponent(jCheckBoxRunnable)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonAssemble)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonEditInVedi)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jCheckBoxAddFactor)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jCheckBoxCStyle)
                        .addGap(18, 18, 18)
                        .addComponent(jCheckBoxPCStyle)
                        .addGap(5, 5, 5))))
        );
        jPanel19Layout.setVerticalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel19Layout.createSequentialGroup()
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jCheckBoxAddFactor)
                        .addComponent(jCheckBoxCStyle)
                        .addComponent(jCheckBoxPCStyle))
                    .addComponent(jButtonEditInVedi)
                    .addComponent(jButtonAssemble)
                    .addComponent(jCheckBoxRunnable))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane5)
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jRadioButton3)
                    .addComponent(jRadioButton4)
                    .addComponent(jRadioButton5)
                    .addComponent(jRadioButton6))
                .addGap(12, 12, 12))
            .addGroup(jPanel19Layout.createSequentialGroup()
                .addComponent(jPanel29, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel30, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        jTabbedPane8.addTab("text export", jPanel19);

        jTextAreaResult1.setColumns(20);
        jTextAreaResult1.setFont(new java.awt.Font("Courier New", 1, 12)); // NOI18N
        jTextAreaResult1.setRows(5);
        jScrollPane6.setViewportView(jTextAreaResult1);

        jButtonEditInVedi1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_edit.png"))); // NOI18N
        jButtonEditInVedi1.setToolTipText("edit output in vedi");
        jButtonEditInVedi1.setEnabled(false);
        jButtonEditInVedi1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonEditInVedi1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonEditInVedi1ActionPerformed(evt);
            }
        });

        jButtonAssemble1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jButtonAssemble1.setToolTipText("Assemble current file, if if project is loaded, build project");
        jButtonAssemble1.setEnabled(false);
        jButtonAssemble1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAssemble1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAssemble1ActionPerformed(evt);
            }
        });

        jCheckBoxRunnable1.setText("runnable");
        jCheckBoxRunnable1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxRunnable1ActionPerformed(evt);
            }
        });

        jPanel33.setBorder(javax.swing.BorderFactory.createTitledBorder("VectorList"));

        jButtonCodeGen.setText("Moves & Draws");
        jButtonCodeGen.setToolTipText("");
        jButtonCodeGen.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonCodeGen.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonCodeGen.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCodeGenActionPerformed(evt);
            }
        });

        jLabel47.setForeground(new java.awt.Color(102, 102, 102));
        jLabel47.setText("To change the code generation,  ");

        jLabel48.setForeground(new java.awt.Color(102, 102, 102));
        jLabel48.setText("edit the used templates!");

        jLabel51.setText("Label name:");

        jTextFieldLabelListname1.setPreferredSize(new java.awt.Dimension(6, 21));

        javax.swing.GroupLayout jPanel33Layout = new javax.swing.GroupLayout(jPanel33);
        jPanel33.setLayout(jPanel33Layout);
        jPanel33Layout.setHorizontalGroup(
            jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel33Layout.createSequentialGroup()
                .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jButtonCodeGen, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGroup(jPanel33Layout.createSequentialGroup()
                            .addComponent(jLabel51)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jTextFieldLabelListname1, javax.swing.GroupLayout.PREFERRED_SIZE, 88, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel33Layout.createSequentialGroup()
                        .addGap(75, 75, 75)
                        .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel48)
                            .addComponent(jLabel47))))
                .addGap(107, 107, 107))
        );
        jPanel33Layout.setVerticalGroup(
            jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel33Layout.createSequentialGroup()
                .addComponent(jButtonCodeGen, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLabel47)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel48)
                .addGap(21, 21, 21)
                .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel51)
                    .addComponent(jTextFieldLabelListname1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 11, Short.MAX_VALUE))
        );

        jPanel34.setBorder(javax.swing.BorderFactory.createTitledBorder("Animation/Scenario"));

        jButtonAnimCodeGen.setText("Moves & Draws");
        jButtonAnimCodeGen.setToolTipText("");
        jButtonAnimCodeGen.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonAnimCodeGen.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonAnimCodeGen.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAnimCodeGenActionPerformed(evt);
            }
        });

        jTextFieldAnimName1.setPreferredSize(new java.awt.Dimension(6, 21));

        jLabel52.setText("Label name:");

        javax.swing.GroupLayout jPanel34Layout = new javax.swing.GroupLayout(jPanel34);
        jPanel34.setLayout(jPanel34Layout);
        jPanel34Layout.setHorizontalGroup(
            jPanel34Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel34Layout.createSequentialGroup()
                .addGroup(jPanel34Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jButtonAnimCodeGen, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel34Layout.createSequentialGroup()
                        .addComponent(jLabel52)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldAnimName1, javax.swing.GroupLayout.PREFERRED_SIZE, 88, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel34Layout.setVerticalGroup(
            jPanel34Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel34Layout.createSequentialGroup()
                .addComponent(jButtonAnimCodeGen, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(76, 76, 76)
                .addGroup(jPanel34Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel52)
                    .addComponent(jTextFieldAnimName1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 22, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel32Layout = new javax.swing.GroupLayout(jPanel32);
        jPanel32.setLayout(jPanel32Layout);
        jPanel32Layout.setHorizontalGroup(
            jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel32Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jPanel33, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel34, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel32Layout.createSequentialGroup()
                        .addComponent(jCheckBoxRunnable1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonAssemble1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonEditInVedi1)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addComponent(jScrollPane6))
                .addContainerGap())
        );
        jPanel32Layout.setVerticalGroup(
            jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel32Layout.createSequentialGroup()
                .addGroup(jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel32Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonAssemble1)
                            .addComponent(jButtonEditInVedi1)
                            .addComponent(jCheckBoxRunnable1, javax.swing.GroupLayout.Alignment.TRAILING))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane6))
                    .addGroup(jPanel32Layout.createSequentialGroup()
                        .addComponent(jPanel33, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel34, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );

        jTabbedPane8.addTab("code export", jPanel32);

        jButtonExport.setText("User Export");
        jButtonExport.setPreferredSize(new java.awt.Dimension(150, 21));
        jButtonExport.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonExportActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel20Layout = new javax.swing.GroupLayout(jPanel20);
        jPanel20.setLayout(jPanel20Layout);
        jPanel20Layout.setHorizontalGroup(
            jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel20Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonExport, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(714, Short.MAX_VALUE))
        );
        jPanel20Layout.setVerticalGroup(
            jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel20Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonExport, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(373, Short.MAX_VALUE))
        );

        jTabbedPane8.addTab("user export", jPanel20);

        jButtonLoad3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad3.setToolTipText("export to svg file");
        jButtonLoad3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoad3ActionPerformed(evt);
            }
        });

        jLabel57.setText("File");

        jLabel58.setText("export to svg:");

        jLabel59.setForeground(new java.awt.Color(102, 102, 102));
        jLabel59.setText("Simple export of \"lines\" only.");

        jButtonLoad4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad4.setToolTipText("export wavefront obj file");
        jButtonLoad4.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoad4ActionPerformed(evt);
            }
        });

        jLabel60.setText("File");

        jLabel61.setText("export to wavefront obj:");

        jLabel62.setForeground(new java.awt.Color(102, 102, 102));
        jLabel62.setText("Use of v/p/l/f entities only!");

        javax.swing.GroupLayout jPanel40Layout = new javax.swing.GroupLayout(jPanel40);
        jPanel40.setLayout(jPanel40Layout);
        jPanel40Layout.setHorizontalGroup(
            jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel40Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jLabel57)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonLoad3))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jLabel60)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonLoad4))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jLabel58)
                        .addGap(85, 85, 85)
                        .addComponent(jLabel59))
                    .addGroup(jPanel40Layout.createSequentialGroup()
                        .addComponent(jLabel61)
                        .addGap(35, 35, 35)
                        .addComponent(jLabel62, javax.swing.GroupLayout.PREFERRED_SIZE, 191, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(518, Short.MAX_VALUE))
        );
        jPanel40Layout.setVerticalGroup(
            jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel40Layout.createSequentialGroup()
                .addGap(16, 16, 16)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel58)
                    .addComponent(jLabel59))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButtonLoad3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel57, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(26, 26, 26)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel61)
                    .addComponent(jLabel62))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel40Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButtonLoad4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel60, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(281, Short.MAX_VALUE))
        );

        jTabbedPane8.addTab("other", jPanel40);

        jTextFieldLabelListname2.setPreferredSize(new java.awt.Dimension(6, 21));

        jButtonBuildSmartList.setText("build list");
        jButtonBuildSmartList.setToolTipText("<html>\n<B>Draw smart list</B>        <BR>                                  \n\n<BR>     \n</html>\n\n");
        jButtonBuildSmartList.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonBuildSmartList.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonBuildSmartList.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonBuildSmartList.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonBuildSmartListActionPerformed(evt);
            }
        });

        jTextField3.setText("$01");
        jTextField3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField3ActionPerformed(evt);
            }
        });

        jTextField2.setText("$09");

        jTextField1.setText("$5f");

        jLabel66.setText("name");

        jLabel65.setText("default factor");

        jLabel64.setText("scale");

        jLabel63.setText("default Intensity");

        jLabel67.setText("factorname");

        jTextFieldLabelFactorName.setText("BLOW_UP");
        jTextFieldLabelFactorName.setPreferredSize(new java.awt.Dimension(6, 21));

        jButtonBuildSmartList1.setText("build anim list");
        jButtonBuildSmartList1.setToolTipText("<html>\n<B>Draw smart list</B>        <BR>                                  \n                                                <BR>                            \n\n<BR>     \n</html>\n\n");
        jButtonBuildSmartList1.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonBuildSmartList1.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonBuildSmartList1.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonBuildSmartList1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonBuildSmartList1ActionPerformed(evt);
            }
        });

        jTextFieldLabelStackJumpName.setText("BonusCircle_");
        jTextFieldLabelStackJumpName.setToolTipText("counter is appended");
        jTextFieldLabelStackJumpName.setPreferredSize(new java.awt.Dimension(6, 21));

        jLabel68.setText("last move name");

        jLabel69.setText("jump on last move");
        jLabel69.setToolTipText("if last entry is a move/start move - add a stack jump address");

        jCheckBoxNoInitialMove.setSelected(true);
        jCheckBoxNoInitialMove.setText("no positioning move");

        jButtonBuildSmartList2.setText("build scenario list");
        jButtonBuildSmartList2.setToolTipText("<html>\n<B>Draw smart list</B>        <BR>                                  \n                                                <BR>                            \n\n<BR>     \n</html>\n\n");
        jButtonBuildSmartList2.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonBuildSmartList2.setMargin(new java.awt.Insets(2, 4, 2, 4));
        jButtonBuildSmartList2.setPreferredSize(new java.awt.Dimension(140, 21));
        jButtonBuildSmartList2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonBuildSmartList2ActionPerformed(evt);
            }
        });

        jTextField12.setText("SMVB_");
        jTextField12.setEnabled(false);
        jTextField12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField12ActionPerformed(evt);
            }
        });

        jLabel76.setText("function");
        jLabel76.setToolTipText("header to a smart draw function collection");

        jLabel80.setText("no compensation");

        javax.swing.GroupLayout jPanel27Layout = new javax.swing.GroupLayout(jPanel27);
        jPanel27.setLayout(jPanel27Layout);
        jPanel27Layout.setHorizontalGroup(
            jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel27Layout.createSequentialGroup()
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addGroup(jPanel27Layout.createSequentialGroup()
                        .addComponent(jLabel67)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jTextFieldLabelFactorName, javax.swing.GroupLayout.PREFERRED_SIZE, 94, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButtonBuildSmartList, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel27Layout.createSequentialGroup()
                        .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel63)
                            .addComponent(jLabel64)
                            .addComponent(jLabel65))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxFactor)
                            .addComponent(jCheckBoxIntensity))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel27Layout.createSequentialGroup()
                        .addComponent(jLabel66)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jTextFieldLabelListname2, javax.swing.GroupLayout.PREFERRED_SIZE, 94, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButtonBuildSmartList1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel68, javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel27Layout.createSequentialGroup()
                        .addComponent(jCheckBoxStackJump)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel69, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jTextFieldLabelStackJumpName, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jCheckBoxNoInitialMove, javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonBuildSmartList2, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addGroup(jPanel27Layout.createSequentialGroup()
                            .addComponent(jLabel80)
                            .addGap(41, 41, 41)
                            .addComponent(jCheckBox14))
                        .addGroup(jPanel27Layout.createSequentialGroup()
                            .addComponent(jLabel76)
                            .addGap(18, 18, 18)
                            .addComponent(jTextField12, javax.swing.GroupLayout.PREFERRED_SIZE, 86, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(6, 10, Short.MAX_VALUE))
        );
        jPanel27Layout.setVerticalGroup(
            jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel27Layout.createSequentialGroup()
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxIntensity)
                    .addComponent(jLabel63, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel64, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel65, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jCheckBoxFactor)
                        .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel66)
                    .addComponent(jTextFieldLabelListname2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel67)
                    .addComponent(jTextFieldLabelFactorName, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButtonBuildSmartList, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonBuildSmartList1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonBuildSmartList2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(12, 12, 12)
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jCheckBoxStackJump)
                    .addComponent(jLabel69))
                .addGap(4, 4, 4)
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel27Layout.createSequentialGroup()
                        .addComponent(jLabel68)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldLabelStackJumpName, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jCheckBoxNoInitialMove)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField12, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel76))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel80, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jCheckBox14))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jCheckBoxRunnable2.setText("runnable");
        jCheckBoxRunnable2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxRunnable2ActionPerformed(evt);
            }
        });

        jButtonAssembleSM.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jButtonAssembleSM.setToolTipText("Assemble current file, if if project is loaded, build project");
        jButtonAssembleSM.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAssembleSM.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAssembleSMActionPerformed(evt);
            }
        });

        jButtonEditInVedi2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_edit.png"))); // NOI18N
        jButtonEditInVedi2.setToolTipText("edit output in vedi");
        jButtonEditInVedi2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonEditInVedi2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonEditInVedi2ActionPerformed(evt);
            }
        });

        jTextAreaResultSM.setColumns(20);
        jTextAreaResultSM.setFont(new java.awt.Font("Courier New", 1, 12)); // NOI18N
        jTextAreaResultSM.setRows(5);
        jScrollPane8.setViewportView(jTextAreaResultSM);

        jCheckBox9.setSelected(true);
        jCheckBox9.setText("eq difs");
        jCheckBox9.setToolTipText("if length are divided - equalize the devides (gets rids of \"dots\")");

        jCheckBox10.setText("incl. brightness");
        jCheckBox10.setToolTipText("includes brightness information in build vectorlist, images might look more \"even\"");

        jLabel73.setText("min");

        jTextField6.setText("0x1f");
        jTextField6.setToolTipText("minimum brightness");

        jTextField7.setText("0x3f");
        jTextField7.setToolTipText("maximum brightness");

        jLabel74.setText("max");

        jLabel75.setText("#");

        jTextField11.setText("4");
        jTextField11.setToolTipText("brightness dicided in x steps");
        jTextField11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField11ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel36Layout = new javax.swing.GroupLayout(jPanel36);
        jPanel36.setLayout(jPanel36Layout);
        jPanel36Layout.setHorizontalGroup(
            jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel36Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane8)
                    .addGroup(jPanel36Layout.createSequentialGroup()
                        .addComponent(jCheckBoxRunnable2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonAssembleSM, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonEditInVedi2)
                        .addGap(40, 40, 40)
                        .addComponent(jCheckBox9)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jCheckBox10)
                        .addGap(18, 18, 18)
                        .addComponent(jLabel73)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, 47, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel74)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, 47, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel75)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField11, javax.swing.GroupLayout.PREFERRED_SIZE, 47, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 129, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel36Layout.setVerticalGroup(
            jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel36Layout.createSequentialGroup()
                .addGap(12, 12, 12)
                .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jButtonAssembleSM)
                        .addComponent(jButtonEditInVedi2)
                        .addComponent(jCheckBoxRunnable2, javax.swing.GroupLayout.Alignment.TRAILING))
                    .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel75)
                            .addComponent(jTextField11, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel74)
                            .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBox9)
                            .addComponent(jCheckBox10)
                            .addComponent(jLabel73)
                            .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jScrollPane8, javax.swing.GroupLayout.DEFAULT_SIZE, 289, Short.MAX_VALUE)
                .addGap(1, 1, 1))
        );

        jCheckBox11.setSelected(true);
        jCheckBox11.setText("old smart list");
        jCheckBox11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox11ActionPerformed(evt);
            }
        });

        jCheckBoxCompileForVB.setText("vb smart list");
        jCheckBoxCompileForVB.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxCompileForVBActionPerformed(evt);
            }
        });

        jCheckBox13.setText("rts 2");
        jCheckBox13.setEnabled(false);

        jCheckBoxNoShift.setText("no SHIFT");
        jCheckBoxNoShift.setToolTipText("generate for usage without VIA SHIFT reg");

        jCheckBox15.setText("low y");
        jCheckBox15.setToolTipText("Test whether Y is \"very\" negative, if so - use different draw routine. (only VB)");

        jTextField13.setText("-150");
        jTextField13.setToolTipText("Threshold for additional NOP to set y integrators (only VB)");

        jCheckBoxNoHiLo.setText("no hil/lo");
        jCheckBoxNoHiLo.setToolTipText("generate for usage without VIA SHIFT reg");

        jLabel79.setText("smartMax");

        jTextFieldSmartMax.setText("127");
        jTextFieldSmartMax.setToolTipText("maximum strength that will be generated (VB)");

        javax.swing.GroupLayout jPanel9Layout = new javax.swing.GroupLayout(jPanel9);
        jPanel9.setLayout(jPanel9Layout);
        jPanel9Layout.setHorizontalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel9Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel27, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel36, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel9Layout.createSequentialGroup()
                        .addGap(12, 12, 12)
                        .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel9Layout.createSequentialGroup()
                                .addComponent(jCheckBoxCompileForVB)
                                .addGap(42, 42, 42)
                                .addComponent(jCheckBox13)
                                .addGap(36, 36, 36)
                                .addComponent(jCheckBoxNoShift))
                            .addComponent(jCheckBox11))
                        .addGap(35, 35, 35)
                        .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel9Layout.createSequentialGroup()
                                .addComponent(jCheckBox15)
                                .addGap(0, 0, Short.MAX_VALUE))
                            .addGroup(jPanel9Layout.createSequentialGroup()
                                .addComponent(jLabel79, javax.swing.GroupLayout.PREFERRED_SIZE, 63, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                        .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jTextFieldSmartMax)
                            .addComponent(jTextField13, javax.swing.GroupLayout.DEFAULT_SIZE, 52, Short.MAX_VALUE))
                        .addGap(18, 18, 18)
                        .addComponent(jCheckBoxNoHiLo)
                        .addContainerGap(166, Short.MAX_VALUE))))
        );
        jPanel9Layout.setVerticalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel9Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel27, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel9Layout.createSequentialGroup()
                        .addComponent(jPanel36, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel79)
                                .addComponent(jTextFieldSmartMax, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jCheckBox11))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBoxCompileForVB)
                            .addComponent(jCheckBox13)
                            .addComponent(jCheckBoxNoShift)
                            .addComponent(jCheckBox15)
                            .addComponent(jTextField13, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxNoHiLo))))
                .addContainerGap())
        );

        jTabbedPane8.addTab("SmartList", jPanel9);

        javax.swing.GroupLayout jPanel26Layout = new javax.swing.GroupLayout(jPanel26);
        jPanel26.setLayout(jPanel26Layout);
        jPanel26Layout.setHorizontalGroup(
            jPanel26Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane8)
        );
        jPanel26Layout.setVerticalGroup(
            jPanel26Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane8)
        );

        jTabbedPane5.addTab("export", jPanel26);

        jCheckBoxSameIntensity.setText("all vectors same intensity");

        jCheckBoxSamePattern.setText("all vectors same pattern");

        jCheckBox2dOnly.setText("2d only");
        jCheckBox2dOnly.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox2dOnlyActionPerformed(evt);
            }
        });

        jLabel5.setText("X length max");

        jTextFieldXMaxLength.setEditable(false);
        jTextFieldXMaxLength.setText("0");
        jTextFieldXMaxLength.setPreferredSize(new java.awt.Dimension(50, 21));

        jTextFieldYMaxLength.setEditable(false);
        jTextFieldYMaxLength.setText("0");
        jTextFieldYMaxLength.setPreferredSize(new java.awt.Dimension(50, 21));

        jLabel6.setText("Y length max");

        jCheckBoxVectorsContinuous.setText("vectors continuous");

        jCheckBoxVectorClosedPolygon.setText("closed polygon");

        jLabel28.setText("X min/max");

        jLabel29.setText("Y min/max");

        jTextFieldYMin.setEditable(false);
        jTextFieldYMin.setText("0");
        jTextFieldYMin.setPreferredSize(new java.awt.Dimension(50, 21));

        jTextFieldXMin.setEditable(false);
        jTextFieldXMin.setText("0");
        jTextFieldXMin.setPreferredSize(new java.awt.Dimension(50, 21));

        jTextFieldXMax.setEditable(false);
        jTextFieldXMax.setText("0");
        jTextFieldXMax.setPreferredSize(new java.awt.Dimension(50, 21));

        jTextFieldYMax.setEditable(false);
        jTextFieldYMax.setText("0");
        jTextFieldYMax.setPreferredSize(new java.awt.Dimension(50, 21));

        jLabel30.setText("Z length max");

        jTextFieldZMaxLength.setEditable(false);
        jTextFieldZMaxLength.setText("0");
        jTextFieldZMaxLength.setPreferredSize(new java.awt.Dimension(50, 21));

        jLabel31.setText("Z min/max");

        jTextFieldZMin.setEditable(false);
        jTextFieldZMin.setText("0");
        jTextFieldZMin.setPreferredSize(new java.awt.Dimension(50, 21));

        jTextFieldZMax.setEditable(false);
        jTextFieldZMax.setText("0");
        jTextFieldZMax.setPreferredSize(new java.awt.Dimension(50, 21));

        jCheckBoxVectorOrderedClosedPolygon.setText("ordered closed polygon");

        jCheckBoxHighPattern.setText("all pattern high bit set");

        jCheckBoxOnePath.setText("vectors in one path");
        jCheckBoxOnePath.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxOnePathActionPerformed(evt);
            }
        });

        jLabel39.setForeground(new java.awt.Color(102, 102, 102));
        jLabel39.setText("if disabled, so are export: (Mov_)Draw_VLc");

        jLabel40.setForeground(new java.awt.Color(102, 102, 102));

        jLabel41.setForeground(new java.awt.Color(102, 102, 102));
        jLabel41.setText("if disabled, so all exports");

        jLabel42.setForeground(new java.awt.Color(102, 102, 102));
        jLabel42.setText("if any max length is greater 127,");

        jLabel43.setFont(jLabel43.getFont().deriveFont(jLabel43.getFont().getStyle() | java.awt.Font.BOLD, jLabel43.getFont().getSize()+3));
        jLabel43.setText("This is an information tab, changing checkboxes here is a waste of time!");

        jLabel54.setForeground(new java.awt.Color(102, 102, 102));
        jLabel54.setText("than all exports are disabled");

        jTextFieldstart1.setEnabled(false);

        jButtonFileSelect2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
        jButtonFileSelect2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect2ActionPerformed(evt);
            }
        });

        jLabel77.setText("set working VList directory");
        jLabel77.setEnabled(false);

        jLabel78.setText("set working anim directory");
        jLabel78.setEnabled(false);

        jTextFieldstart2.setEnabled(false);

        jButtonFileSelect3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
        jButtonFileSelect3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect3ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel28Layout = new javax.swing.GroupLayout(jPanel28);
        jPanel28.setLayout(jPanel28Layout);
        jPanel28Layout.setHorizontalGroup(
            jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel28Layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel43)
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel28Layout.createSequentialGroup()
                                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jCheckBoxSamePattern)
                                    .addComponent(jCheckBoxHighPattern)
                                    .addComponent(jCheckBoxVectorsContinuous))
                                .addGap(10, 10, 10)
                                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jLabel39, javax.swing.GroupLayout.DEFAULT_SIZE, 326, Short.MAX_VALUE)
                                    .addComponent(jLabel40, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(jLabel41, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                            .addComponent(jCheckBoxOnePath)
                            .addComponent(jCheckBoxSameIntensity)
                            .addComponent(jCheckBox2dOnly)
                            .addComponent(jCheckBoxVectorClosedPolygon)
                            .addComponent(jCheckBoxVectorOrderedClosedPolygon))
                        .addGap(15, 15, 15)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel30)
                            .addComponent(jLabel31)
                            .addComponent(jLabel5)
                            .addComponent(jLabel29)
                            .addComponent(jLabel28)
                            .addComponent(jLabel6))
                        .addGap(12, 12, 12)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldXMin, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldYMin, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldZMin, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldZMaxLength, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldXMaxLength, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldYMaxLength, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldYMax, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldXMax, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldZMax, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                        .addComponent(jLabel42, javax.swing.GroupLayout.DEFAULT_SIZE, 280, Short.MAX_VALUE)
                        .addComponent(jLabel54, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
            .addGroup(jPanel28Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jTextFieldstart1, javax.swing.GroupLayout.PREFERRED_SIZE, 180, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonFileSelect2))
            .addGroup(jPanel28Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel77))
            .addGroup(jPanel28Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addComponent(jTextFieldstart2, javax.swing.GroupLayout.PREFERRED_SIZE, 180, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonFileSelect3))
                    .addComponent(jLabel78)))
        );
        jPanel28Layout.setVerticalGroup(
            jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel28Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addComponent(jLabel43)
                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addGap(4, 4, 4)
                        .addComponent(jCheckBoxSameIntensity)
                        .addGap(0, 0, 0)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBoxSamePattern)
                            .addComponent(jLabel39))
                        .addGap(0, 0, 0)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBoxHighPattern)
                            .addComponent(jLabel40))
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBox2dOnly)
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBoxOnePath)
                        .addGap(0, 0, 0)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBoxVectorsContinuous)
                            .addComponent(jLabel41))
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBoxVectorClosedPolygon)
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBoxVectorOrderedClosedPolygon))
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addGap(13, 13, 13)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel28Layout.createSequentialGroup()
                                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jTextFieldXMin, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel28))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jTextFieldYMin, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel29)))
                            .addGroup(jPanel28Layout.createSequentialGroup()
                                .addComponent(jTextFieldXMax, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldYMax, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldZMin, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldZMax, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel31))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldXMaxLength, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel5))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldYMaxLength, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel6))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldZMaxLength, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel30))))
                .addGap(18, 18, 18)
                .addComponent(jLabel42)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel54)
                .addGap(5, 5, 5)
                .addComponent(jLabel77)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonFileSelect2)
                    .addComponent(jTextFieldstart1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel78)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonFileSelect3)
                    .addComponent(jTextFieldstart2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jTabbedPane5.addTab("vectorlist status", jPanel28);

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabelScale)
                    .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(jPanel6Layout.createSequentialGroup()
                            .addComponent(jSliderSourceScale, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPanel6Layout.createSequentialGroup()
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jPanelScroller, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGroup(jPanel6Layout.createSequentialGroup()
                                    .addGap(2, 2, 2)
                                    .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addComponent(jLabelY0, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jLabelMaxY, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jLabelMinY, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel6Layout.createSequentialGroup()
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                        .addComponent(jButtonSingleEditor1)
                                        .addComponent(jButtonSingleEditor))
                                    .addGap(5, 5, 5))))
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel6Layout.createSequentialGroup()
                            .addGap(4, 4, 4)
                            .addComponent(jCheckBoxByteFrame))))
                .addGap(0, 0, 0)
                .addComponent(jPanel18, javax.swing.GroupLayout.PREFERRED_SIZE, 313, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jTabbedPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                .addGap(5, 5, 5))
            .addComponent(jPanel31, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jCheckBoxByteFrame)
                        .addGap(12, 12, 12)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jSliderSourceScale, javax.swing.GroupLayout.PREFERRED_SIZE, 311, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel6Layout.createSequentialGroup()
                                .addComponent(jLabelMaxY)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jPanelScroller, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(56, 56, 56)
                                .addComponent(jLabelY0)
                                .addGap(32, 32, 32)
                                .addComponent(jButtonSingleEditor1)
                                .addGap(11, 11, 11)
                                .addComponent(jButtonSingleEditor)
                                .addGap(10, 10, 10)
                                .addComponent(jLabelMinY)
                                .addGap(31, 31, 31)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabelScale))
                    .addComponent(jPanel18, javax.swing.GroupLayout.PREFERRED_SIZE, 376, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jTabbedPane5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                .addComponent(jPanel31, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0))
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(3, 3, 3)
                .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(0, 0, 0)
                .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0))
        );

        jPanel39.setBorder(javax.swing.BorderFactory.createTitledBorder("vectorlists collection"));

        jScrollPane2.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
        jScrollPane2.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
        jScrollPane2.setMinimumSize(new java.awt.Dimension(60, 83));

        jPanelIMageCollection.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        jPanelIMageCollection.setMinimumSize(new java.awt.Dimension(15, 62));
        jPanelIMageCollection.setLayout(new java.awt.FlowLayout(java.awt.FlowLayout.LEADING));

        jPanel12.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        jPanel12.setPreferredSize(new java.awt.Dimension(52, 52));

        javax.swing.GroupLayout jPanel12Layout = new javax.swing.GroupLayout(jPanel12);
        jPanel12.setLayout(jPanel12Layout);
        jPanel12Layout.setHorizontalGroup(
            jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 50, Short.MAX_VALUE)
        );
        jPanel12Layout.setVerticalGroup(
            jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 50, Short.MAX_VALUE)
        );

        jPanelIMageCollection.add(jPanel12);

        jPanel13.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        jPanel13.setPreferredSize(new java.awt.Dimension(52, 52));

        javax.swing.GroupLayout jPanel13Layout = new javax.swing.GroupLayout(jPanel13);
        jPanel13.setLayout(jPanel13Layout);
        jPanel13Layout.setHorizontalGroup(
            jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 50, Short.MAX_VALUE)
        );
        jPanel13Layout.setVerticalGroup(
            jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 50, Short.MAX_VALUE)
        );

        jPanelIMageCollection.add(jPanel13);

        jScrollPane2.setViewportView(jPanelIMageCollection);

        jButtonOneForward.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_right.png"))); // NOI18N
        jButtonOneForward.setToolTipText("Select next, +SHIFT moves selected vectorlist one to the right.");
        jButtonOneForward.setPreferredSize(new java.awt.Dimension(35, 21));
        jButtonOneForward.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOneForwardActionPerformed(evt);
            }
        });

        jTextFieldCurrentNo.setToolTipText("Number of the current selected image.");
        jTextFieldCurrentNo.setPreferredSize(new java.awt.Dimension(6, 21));

        jLabelImageNow.setText("now");

        jTextFieldCount.setText("0");
        jTextFieldCount.setToolTipText("Count of images.");
        jTextFieldCount.setPreferredSize(new java.awt.Dimension(6, 21));

        jLabelImageCount.setText("Count");

        jButtonApplyCurrent.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/shape_square_go.png"))); // NOI18N
        jButtonApplyCurrent.setText("apply");
        jButtonApplyCurrent.setToolTipText("apply changes to vectorlist to current selected animation \"frame\"");
        jButtonApplyCurrent.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonApplyCurrent.setPreferredSize(new java.awt.Dimension(90, 21));
        jButtonApplyCurrent.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonApplyCurrentActionPerformed(evt);
            }
        });

        jLabelSelSize.setText(" ");

        jButtonReverse.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_refresh_small.png"))); // NOI18N
        jButtonReverse.setText("Reverse");
        jButtonReverse.setToolTipText("Reverses the order of all vectorlists.");
        jButtonReverse.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonReverse.setPreferredSize(new java.awt.Dimension(120, 21));
        jButtonReverse.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonReverseActionPerformed(evt);
            }
        });

        jButtonDeleteOne.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/exclamation.png"))); // NOI18N
        jButtonDeleteOne.setText("delete");
        jButtonDeleteOne.setToolTipText("Deletes selected vectorlist.");
        jButtonDeleteOne.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDeleteOne.setPreferredSize(new java.awt.Dimension(120, 21));
        jButtonDeleteOne.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDeleteOneActionPerformed(evt);
            }
        });

        jButtonSave2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave2.setToolTipText("save animation");
        jButtonSave2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSave2ActionPerformed(evt);
            }
        });

        jButtonAddCurrent.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/add.png"))); // NOI18N
        jButtonAddCurrent.setText("add current");
        jButtonAddCurrent.setToolTipText("add current \"work\" vectorlist to the end of the animation");
        jButtonAddCurrent.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonAddCurrent.setPreferredSize(new java.awt.Dimension(90, 21));
        jButtonAddCurrent.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAddCurrentActionPerformed(evt);
            }
        });

        jButtonLoad1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad1.setToolTipText("load animation");
        jButtonLoad1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoad1ActionPerformed(evt);
            }
        });

        buttonGroup2.add(jRadioButtonAnimation);
        jRadioButtonAnimation.setSelected(true);
        jRadioButtonAnimation.setText("animation");
        jRadioButtonAnimation.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButtonAnimationActionPerformed(evt);
            }
        });

        buttonGroup2.add(jRadioButtonScenario);
        jRadioButtonScenario.setText("scenario");
        jRadioButtonScenario.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButtonScenarioActionPerformed(evt);
            }
        });

        jButtonAddCurrent1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/add.png"))); // NOI18N
        jButtonAddCurrent1.setText("add view");
        jButtonAddCurrent1.setToolTipText("add current \"work\" vectorlist to the end of the animation");
        jButtonAddCurrent1.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonAddCurrent1.setPreferredSize(new java.awt.Dimension(120, 21));
        jButtonAddCurrent1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAddCurrent1ActionPerformed(evt);
            }
        });

        jButtonClearAnimation.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/new.png"))); // NOI18N
        jButtonClearAnimation.setText("clear");
        jButtonClearAnimation.setToolTipText("new Animation (clears all)");
        jButtonClearAnimation.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonClearAnimation.setPreferredSize(new java.awt.Dimension(120, 21));
        jButtonClearAnimation.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonClearAnimationActionPerformed(evt);
            }
        });

        jButtonOneBack.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_left.png"))); // NOI18N
        jButtonOneBack.setToolTipText("Select previous, +SHIFT moves selected vectorlist one to the left.");
        jButtonOneBack.setPreferredSize(new java.awt.Dimension(35, 21));
        jButtonOneBack.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOneBackActionPerformed(evt);
            }
        });

        jButtonJoin.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/vector_add.png"))); // NOI18N
        jButtonJoin.setText("join");
        jButtonJoin.setToolTipText("<html>\n<body>\nif \"edit on select\" selected:<BR>\nJoins all vectorlist to one in current edit<BR>\nif \"edit on select\" NOT selected:<BR>\nJoins current selected frame to the current edit<BR>\n</body>\n</html>\n");
        jButtonJoin.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonJoin.setPreferredSize(new java.awt.Dimension(120, 21));
        jButtonJoin.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonJoinActionPerformed(evt);
            }
        });

        jCheckBoxAutoEdit.setSelected(true);
        jCheckBoxAutoEdit.setText("edit on select");
        jCheckBoxAutoEdit.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBoxAutoEdit.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxAutoEditActionPerformed(evt);
            }
        });

        jCheckBoxAutoApply.setText("auto apply");

        jButtonJoin1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/user_red.png"))); // NOI18N
        jButtonJoin1.setText("storyboard");
        jButtonJoin1.setToolTipText("<html>\n<body>\nopens the storyboard window.\n</body>\n</html>\n");
        jButtonJoin1.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonJoin1.setPreferredSize(new java.awt.Dimension(120, 21));
        jButtonJoin1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonJoin1ActionPerformed(evt);
            }
        });

        jButtonJoin2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/user_green.png"))); // NOI18N
        jButtonJoin2.setText("storyboard 2");
        jButtonJoin2.setToolTipText("<html>\n<body>\nopens the storyboard window.\n</body>\n</html>\n");
        jButtonJoin2.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonJoin2.setPreferredSize(new java.awt.Dimension(120, 21));
        jButtonJoin2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonJoin2ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel39Layout = new javax.swing.GroupLayout(jPanel39);
        jPanel39.setLayout(jPanel39Layout);
        jPanel39Layout.setHorizontalGroup(
            jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel39Layout.createSequentialGroup()
                .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel39Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel39Layout.createSequentialGroup()
                                .addComponent(jLabelImageCount)
                                .addGap(7, 7, 7)
                                .addComponent(jTextFieldCount, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabelImageNow)
                                .addGap(6, 6, 6)
                                .addComponent(jTextFieldCurrentNo, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel39Layout.createSequentialGroup()
                                .addComponent(jButtonLoad1)
                                .addGap(6, 6, 6)
                                .addComponent(jButtonSave2)
                                .addGap(4, 4, 4)
                                .addComponent(jCheckBoxAutoEdit)))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jRadioButtonAnimation)
                            .addComponent(jRadioButtonScenario))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jButtonAddCurrent, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonApplyCurrent, javax.swing.GroupLayout.DEFAULT_SIZE, 133, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonAddCurrent1, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxAutoApply))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonReverse, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel39Layout.createSequentialGroup()
                                .addComponent(jButtonOneBack, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(11, 11, 11)
                                .addComponent(jButtonOneForward, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel39Layout.createSequentialGroup()
                                .addComponent(jButtonDeleteOne, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonJoin, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jButtonClearAnimation, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel39Layout.createSequentialGroup()
                                .addComponent(jButtonJoin2, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabelSelSize, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .addGroup(jPanel39Layout.createSequentialGroup()
                                .addComponent(jButtonJoin1, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 0, Short.MAX_VALUE)))))
                .addGap(0, 0, 0))
        );
        jPanel39Layout.setVerticalGroup(
            jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel39Layout.createSequentialGroup()
                .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel39Layout.createSequentialGroup()
                        .addComponent(jRadioButtonAnimation)
                        .addGap(1, 1, 1)
                        .addComponent(jRadioButtonScenario))
                    .addGroup(jPanel39Layout.createSequentialGroup()
                        .addGap(4, 4, 4)
                        .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabelImageCount)
                                .addComponent(jTextFieldCount, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabelImageNow)
                                .addComponent(jTextFieldCurrentNo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(2, 2, 2)
                        .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonLoad1)
                            .addComponent(jButtonSave2)
                            .addGroup(jPanel39Layout.createSequentialGroup()
                                .addGap(2, 2, 2)
                                .addComponent(jCheckBoxAutoEdit))))
                    .addGroup(jPanel39Layout.createSequentialGroup()
                        .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButtonAddCurrent, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonAddCurrent1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonReverse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonDeleteOne, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonJoin, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonJoin1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel39Layout.createSequentialGroup()
                                .addGap(8, 8, 8)
                                .addGroup(jPanel39Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jButtonApplyCurrent, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jCheckBoxAutoApply)
                                    .addComponent(jLabelSelSize)
                                    .addComponent(jButtonClearAnimation, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jButtonJoin2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(jPanel39Layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonOneForward, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel39Layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonOneBack, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                .addGap(4, 4, 4)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 83, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel39, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(0, 0, 0)
                .addComponent(jPanel39, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
    }// </editor-fold>//GEN-END:initComponents

        
    private void jSliderSourceScaleStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSourceScaleStateChanged
        if (inSetting>0) return;
        int value = jSliderSourceScale.getValue();
        int max = jSliderSourceScale.getMaximum();

        double scale = value - ((max-1)/2);
        if (value <((max/2)+1))
        {
            value--;
            int invScale = ((max/2))-value;
            if (invScale == 0) 
                scale = 1;
            else
                scale = 1.0/invScale;
        }
        // smooth out "big steps"
        if (scale<1) scale += 0.25;
        if (scale>1) scale -= 0.75;
        if (scale>2) scale -= 0.5;
        if (scale>2.5) scale -= 0.25;
        if (scale>2.75) scale -= 0.5;
        jLabelScale.setText("Scale: "+new DecimalFormat("#.##").format(scale));
        jLabelMaxY.setText(""+Scaler.unscaleDoubleToInt(128, scale));
        jLabelMinY.setText("-"+Scaler.unscaleDoubleToInt(128, scale));
        singleVectorPanel1.setScale(scale);
    }//GEN-LAST:event_jSliderSourceScaleStateChanged

    private void jRadioButtonSelectPointActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButtonSelectPointActionPerformed
       if (jCheckBoxContinue.isSelected())
       {
            // finish "old" continue stuff
            jCheckBoxContinue.setSelected(false);
            jCheckBoxContinueActionPerformed(null);
            jCheckBoxContinue.setSelected(true);
       }
       
       if (jRadioButtonSelectPoint.isSelected())
       {
            singleVectorPanel1.setMode(SVP_SELECT_POINT);
       }
        jLabelMode.setText("POINT");
       singleVectorPanel1.getForegroundVectorList().resetSelection();
       jTable1.repaint();
        
        
    }//GEN-LAST:event_jRadioButtonSelectPointActionPerformed

    private void jRadioButtonSelectLineActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButtonSelectLineActionPerformed
       if (jCheckBoxContinue.isSelected())
       {
            // finish "old" continue stuff
            jCheckBoxContinue.setSelected(false);
            jCheckBoxContinueActionPerformed(null);
            jCheckBoxContinue.setSelected(true);
       }
       if (jRadioButtonSelectLine.isSelected())
       {
            singleVectorPanel1.setMode(SingleVectorPanel.SVP_SELECT_LINE);
       }
        jLabelMode.setText("VECTOR");
       singleVectorPanel1.getForegroundVectorList().resetSelection();
       jTable1.repaint();

    }//GEN-LAST:event_jRadioButtonSelectLineActionPerformed

    private void jCheckBoxGridItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_jCheckBoxGridItemStateChanged
        singleVectorPanel1.setGrid(jCheckBoxGrid.isSelected(), de.malban.util.UtilityString.IntX(jTextFieldGridWidth.getText(),1));
    }//GEN-LAST:event_jCheckBoxGridItemStateChanged

    private void jTextFieldGridWidthFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldGridWidthFocusLost
        singleVectorPanel1.setGrid(jCheckBoxGrid.isSelected(), de.malban.util.UtilityString.IntX(jTextFieldGridWidth.getText(),1));
    }//GEN-LAST:event_jTextFieldGridWidthFocusLost

    private void jTextFieldGridWidthActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldGridWidthActionPerformed
        singleVectorPanel1.setGrid(jCheckBoxGrid.isSelected(), de.malban.util.UtilityString.IntX(jTextFieldGridWidth.getText(),1));
    }//GEN-LAST:event_jTextFieldGridWidthActionPerformed

    private void jCheckBoxContinueActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxContinueActionPerformed
        continueStarted = false;
        if (!jCheckBoxContinue.isSelected())
        {
            singleVectorPanel1.continueVector(null);
            // continuous mode was switched of!
            if (buildingVector.isRelativ())
            {
                // here we again a semtantical meaning of start and end
                // but we can do so with the same reason as 
                // by building new vectors
                // this time we know it is correct
                GFXVector prev = buildingVector.start_connect;
                if (prev != null)
                {
                    prev.end_connect = null;
                    prev.uid_end_connect = -1;
                    prev.end = new Vertex(prev.end);
                    prev.setRelativ(false);
                    
                }
                buildingVector.start_connect = null;
                buildingVector.uid_start_connect = -1;
                buildingVector.start = new Vertex(buildingVector.start);
                buildingVector.setRelativ(false);
            }
        }
    }//GEN-LAST:event_jCheckBoxContinueActionPerformed

    private void jCheckBoxPointsOkActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxPointsOkActionPerformed
        pointsOk = jCheckBoxPointsOk.isSelected();
    }//GEN-LAST:event_jCheckBoxPointsOkActionPerformed

    private void jRadioButtonSetPointActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButtonSetPointActionPerformed
       if (jRadioButtonSetPoint.isSelected())
       {
            singleVectorPanel1.setMode(SingleVectorPanel.SVP_SET);
       }
        jLabelMode.setText("SET");
       jTable1.repaint();
    }//GEN-LAST:event_jRadioButtonSetPointActionPerformed

    private void jMenuItemJoinActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemJoinActionPerformed
        // doesn't matter which panel
        addHistory();
        ArrayList<GFXVector> vs = singleVectorPanel1.getSelectedPointVectors();
        Vertex joinHere = singleVectorPanel1.getHighlightedVPoint();

        // if more than one point in one vector is selected, we take the first!
        GFXVector v1 = vs.get(0);
        GFXVector v2 = vs.get(1);
        Vertex s1 = v1.start;
        Vertex s2 = v2.start;
        if (jCheckBoxContinue.isSelected())
        {
            if (s1.selected)
            {
                if (s2.selected)
                {
                    if (v1.start_connect!=null)
                    {
                        log.addLog("Start Vector1 already has a previous Vector", WARN);
                        return;
                    }
                    if (v2.start_connect!=null)
                    {
                        log.addLog("Start Vector2 already has a previous Vector", WARN);
                        return;
                    }
                    v1.start_connect = v2;
                    v1.uid_start_connect = v2.uid;
                    v2.start_connect = v1;
                    v2.uid_start_connect = v1.uid;
                    
                    v1.start = joinHere;
                    v2.start = joinHere;
                    
                    if ((v1.end_connect != null) && (v1.start_connect != null))
                        v1.setRelativ(true);
                    if ((v2.end_connect != null) && (v2.start_connect != null))
                        v2.setRelativ(true);
                }
                else
                {
                    if (v1.start_connect!=null)
                    {
                        log.addLog("Start Vector1 already has a previous Vector", WARN);
                        return;
                    }
                    if (v2.end_connect!=null)
                    {
                        log.addLog("End Vector2 already has a previous Vector", WARN);
                        return;
                    }
                    v1.start_connect = v2;
                    v1.uid_start_connect = v2.uid;
                    v2.end_connect = v1;
                    v2.uid_end_connect = v1.uid;

                    v1.start = joinHere;
                    v2.end = joinHere;
                    if ((v1.end_connect != null) && (v1.start_connect != null))
                        v1.setRelativ(true);
                    if ((v2.end_connect != null) && (v2.start_connect != null))
                        v2.setRelativ(true);
                }
            }
            else
            {
                if (s2.selected)
                {
                    if (v1.end_connect!=null)
                    {
                        log.addLog("End Vector1 already has a previous Vector", WARN);
                        return;
                    }
                    if (v2.start_connect!=null)
                    {
                        log.addLog("Start Vector2 already has a previous Vector", WARN);
                        return;
                    }
                    v1.end_connect = v2;
                    v1.uid_end_connect = v2.uid;
                    v2.start_connect = v1;
                    v2.uid_start_connect = v1.uid;

                    v1.end = joinHere;
                    v2.start = joinHere;
                    if ((v1.end_connect != null) && (v1.start_connect != null))
                        v1.setRelativ(true);
                    if ((v2.end_connect != null) && (v2.start_connect != null))
                        v2.setRelativ(true);
                }
                else
                {
                    if (v1.end_connect!=null)
                    {
                        log.addLog("End Vector1 already has a previous Vector", WARN);
                        return;
                    }
                    if (v2.end_connect!=null)
                    {
                        log.addLog("End Vector2 already has a previous Vector", WARN);
                        return;
                    }
                    v1.end_connect = v2;
                    v1.uid_end_connect = v2.uid;
                    v2.end_connect = v1;
                    v2.uid_end_connect = v1.uid;

                    v1.end = joinHere;
                    v2.end = joinHere;
                    if ((v1.end_connect != null) && (v1.start_connect != null))
                        v1.setRelativ(true);
                    if ((v2.end_connect != null) && (v2.start_connect != null))
                        v2.setRelativ(true);
                }
            }
        }
        else
        {
            if (s1.selected)
            {
                if (s2.selected)
                {
                    v1.start = new Vertex(joinHere);
                    v2.start = new Vertex(joinHere);
                }
                else
                {
                    v1.start = new Vertex(joinHere);
                    v2.end = new Vertex(joinHere);
                }
            }
            else
            {
                if (s2.selected)
                {
                    v1.end = new Vertex(joinHere);
                    v2.start = new Vertex(joinHere);
                }
                else
                {
                    v1.end = new Vertex(joinHere);
                    v2.end = new Vertex(joinHere);
                }
            }            
        }

        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jMenuItemJoinActionPerformed
    void allwaysInt()
    {
        if (jCheckBoxAlwaysInt.isSelected())
        {
            GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
            vl.intAll();
        }
    }

    private void jPopupMenuPointMouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPopupMenuPointMouseExited
        jPopupMenuPoint.setVisible(false);
    }//GEN-LAST:event_jPopupMenuPointMouseExited

    private void jMenuItemConnectActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemConnectActionPerformed
        addHistory();
        ArrayList<GFXVector> vs = singleVectorPanel1.getSelectedPointVectors();

        // if more than one point in one vector is selected, we take the first!
        GFXVector v1 = vs.get(0);
        GFXVector v2 = vs.get(1);
        GFXVector nv = new GFXVector();
        checkVectorStyles(nv);
        
        Vertex s1 = v1.start;
        Vertex s2 = v2.start;
        
        if (jCheckBoxContinue.isSelected())
        {
            nv.setRelativ(true);
            if (s1.selected)
            {
                if (s2.selected)
                {
                    if (v1.start_connect!=null)
                    {
                        log.addLog("Start Vector1 already has a previous Vector", WARN);
                        return;
                    }
                    if (v2.start_connect!=null)
                    {
                        log.addLog("Start Vector2 already has a previous Vector", WARN);
                        return;
                    }
                    nv.start_connect = v1;
                    nv.uid_start_connect = v1.uid;
                    nv.end_connect = v2;
                    nv.uid_end_connect = v2.uid;
                    
                    v1.start_connect = nv;
                    v1.uid_start_connect = nv.uid;
                    v2.start_connect = nv;
                    v2.uid_start_connect = nv.uid;
                    
                    nv.start = v1.start;
                    nv.end = v2.start;
                    if ((v1.end_connect != null) && (v1.start_connect != null))
                        v1.setRelativ(true);
                    if ((v2.end_connect != null) && (v2.start_connect != null))
                        v2.setRelativ(true);
                }
                else
                {
                    if (v1.start_connect!=null)
                    {
                        log.addLog("Start Vector1 already has a previous Vector", WARN);
                        return;
                    }
                    if (v2.end_connect!=null)
                    {
                        log.addLog("End Vector2 already has a next Vector", WARN);
                        return;
                    }
                    nv.start_connect = v1;
                    nv.uid_start_connect = v1.uid;
                    nv.end_connect = v2;
                    nv.uid_end_connect = v2.uid;

                    v1.start_connect = nv;
                    v1.uid_start_connect = nv.uid;
                    v2.end_connect = nv;
                    v2.uid_end_connect = nv.uid;

                    nv.start = v1.start;
                    nv.end = v2.end;
                    if ((v1.end_connect != null) && (v1.start_connect != null))
                        v1.setRelativ(true);
                    if ((v2.end_connect != null) && (v2.start_connect != null))
                        v2.setRelativ(true);
                }
            }
            else
            {
                if (s2.selected)
                {
                    if (v1.end_connect!=null)
                    {
                        log.addLog("End Vector1 already has a next Vector", WARN);
                        return;
                    }
                    if (v2.start_connect!=null)
                    {
                        log.addLog("Start Vector2 already has a next Vector", WARN);
                        return;
                    }
                    nv.start_connect = v1;
                    nv.uid_start_connect = v1.uid;
                    nv.end_connect = v2;
                    nv.uid_end_connect = v2.uid;

                    v1.end_connect = nv;
                    v1.uid_end_connect = nv.uid;
                    v2.start_connect = nv;
                    v2.uid_start_connect = nv.uid;

                    nv.start = v1.end;
                    nv.end = v2.start;
                    if ((v1.end_connect != null) && (v1.start_connect != null))
                        v1.setRelativ(true);
                    if ((v2.end_connect != null) && (v2.start_connect != null))
                        v2.setRelativ(true);
                }
                else
                {
                    if (v1.end_connect!=null)
                    {
                        log.addLog("End Vector1 already has a next Vector", WARN);
                        return;
                    }
                    if (v2.end_connect!=null)
                    {
                        log.addLog("End Vector2 already has a next Vector", WARN);
                        return;
                    }
                    nv.start_connect = v1;
                    nv.uid_start_connect = v1.uid;
                    nv.end_connect = v2;
                    nv.uid_end_connect = v2.uid;

                    v1.end_connect = nv;
                    v1.uid_end_connect = nv.uid;
                    v2.end_connect = nv;
                    v2.uid_end_connect = nv.uid;

                    nv.start = v1.end;
                    nv.end = v2.end;
                    if ((v1.end_connect != null) && (v1.start_connect != null))
                        v1.setRelativ(true);
                    if ((v2.end_connect != null) && (v2.start_connect != null))
                        v2.setRelativ(true);
                }
            }
        }
        else 
        {
            if (s1.selected)
            {
                if (s2.selected)
                {
                    nv.start = new Vertex(v1.start);
                    nv.end = new Vertex(v2.start);
                }
                else
                {
                    nv.start = new Vertex(v1.start);
                    nv.end = new Vertex(v2.end);
                }
            }
            else 
            {
                if (s2.selected)
                {
                    nv.start = new Vertex(v1.end);
                    nv.end = new Vertex(v2.start);
                }
                else
                {
                    nv.start = new Vertex(v1.end);
                    nv.end = new Vertex(v2.end);
                }
            }            
        }
        singleVectorPanel1.addForegroundVector(nv);
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jMenuItemConnectActionPerformed

    private void jMenuItemRipActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemRipActionPerformed
        addHistory();

        ArrayList<GFXVector> vs = singleVectorPanel1.getSelectedPointVectors();
        GFXVector ve = vs.get(0);
        GFXVector vo = null;
        Vertex ps = ve.start;
        if (ps.highlight)
        {
            if (ve.start_connect == null)
            {
                log.addLog("Point is not joined - can't rip", WARN);
                return;
            }
            vo = ve.start_connect;
            vo.setRelativ(false);
            ve.setRelativ(false);
            if (vo.end.equals(ps))
            {
                // start + end
                ve.start_connect = null;
                ve.uid_start_connect = -1;
                vo.end_connect = null;
                vo.uid_end_connect = -1;
                
                ve.start = new Vertex(ps);
                vo.end = new Vertex(ps);
            }
            else
            {
                // start + start
                ve.start_connect = null;
                ve.uid_start_connect = -1;
                vo.start_connect = null;
                vo.uid_start_connect = -1;
                
                ve.start = new Vertex(ps);
                vo.start = new Vertex(ps);
            }
        }
        else
        {
            ps = ve.end;
            if (ve.end_connect == null)
            {
                log.addLog("Point is not joined - can't rip", WARN);
                return;
            }
            vo = ve.end_connect;
            vo.setRelativ(false);
            ve.setRelativ(false);
            if (vo.end.equals(ps))
            {
                // end + end
                ve.end_connect = null;
                ve.uid_end_connect = -1;
                vo.end_connect = null;
                vo.uid_end_connect = -1;
                
                ve.end = new Vertex(ps);
                vo.end = new Vertex(ps);
            }
            else
            {
                // end + start
                ve.end_connect = null;
                ve.uid_end_connect = -1;
                vo.start_connect = null;
                vo.uid_start_connect = -1;
                
                ve.end = new Vertex(ps);
                vo.start = new Vertex(ps);
            }
        }
        singleImagePanel3.sharedRepaint();        
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jMenuItemRipActionPerformed

    private void jSliderFrontStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderFrontStateChanged
       
        if (inSetting>0) return;
        int value = jSliderFront.getValue();
        jTextFieldFront.setText(""+value);

        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setAngleX(value);
        single3dDisplayPanel.enableSingleRepaint();
    }//GEN-LAST:event_jSliderFrontStateChanged

    private void jSliderSideStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSideStateChanged
        if (inSetting>0) return;
        int value = jSliderSide.getValue();
        jTextFieldSide.setText(""+value);
        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setAngleY(value);
        single3dDisplayPanel.enableSingleRepaint();
    }//GEN-LAST:event_jSliderSideStateChanged

    private void jSliderTopStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderTopStateChanged
        if (inSetting>0) return;
        int value = jSliderTop.getValue();
        jTextFieldTop.setText(""+value);
        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setAngleZ(value);
        single3dDisplayPanel.enableSingleRepaint();
    }//GEN-LAST:event_jSliderTopStateChanged

    private void jSliderSourceScale1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSourceScale1StateChanged
        if (inSetting>0) return;
        int value = jSliderSourceScale1.getValue();
        int max = jSliderSourceScale1.getMaximum();
        double scale = value - ((max-1)/2);
        if (value <((max/2)+1))
        {
            int invScale = ((max/2)+2)-value;
            scale = 1.0/invScale;
        }
        single3dDisplayPanel.setScale(scale);
    }//GEN-LAST:event_jSliderSourceScale1StateChanged

    private void jSliderFrontTranslocationZStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderFrontTranslocationZStateChanged
        if (inSetting>0) return;
        int value = jSliderFrontTranslocationZ.getValue();
        jTextFieldTop1.setText(""+value);
        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setTranslocationZ(value);
        single3dDisplayPanel.enableSingleRepaint();
    }//GEN-LAST:event_jSliderFrontTranslocationZStateChanged

    private void jSliderFrontTranslocationYStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderFrontTranslocationYStateChanged
        if (inSetting>0) return;
        int value = jSliderFrontTranslocationY.getValue();
        jTextFieldSide1.setText(""+value);
        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setTranslocationY(value);
        single3dDisplayPanel.enableSingleRepaint();
    }//GEN-LAST:event_jSliderFrontTranslocationYStateChanged

    private void jSliderFrontTranslocationXStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderFrontTranslocationXStateChanged
        if (inSetting>0) return;
        int value = jSliderFrontTranslocationX.getValue();
        jTextFieldFront1.setText(""+value);
        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setTranslocationX(value);
        single3dDisplayPanel.enableSingleRepaint();
    }//GEN-LAST:event_jSliderFrontTranslocationXStateChanged

    private void jCheckBoxDisplayAxisActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxDisplayAxisActionPerformed
        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setAxisShown(jCheckBoxDisplayAxis.isSelected());
        single3dDisplayPanel.enableSingleRepaint();
    }//GEN-LAST:event_jCheckBoxDisplayAxisActionPerformed

    private void jSliderTop1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderTop1StateChanged
        if (inSetting>0) return;
        int value = jSliderTop1.getValue();
        jTextFieldTop2.setText(""+value);
        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setAxisAngleZ(value);
        single3dDisplayPanel.enableSingleRepaint();
    }//GEN-LAST:event_jSliderTop1StateChanged

    private void jSliderSide1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSide1StateChanged
        if (inSetting>0) return;
        int value = jSliderSide1.getValue();
        jTextFieldSide2.setText(""+value);
        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setAxisAngleY(value);
        single3dDisplayPanel.enableSingleRepaint();
    }//GEN-LAST:event_jSliderSide1StateChanged

    private void jSliderFront1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderFront1StateChanged
        if (inSetting>0) return;
        int value = jSliderFront1.getValue();
        jTextFieldFront2.setText(""+value);
        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setAxisAngleX(value);
        single3dDisplayPanel.enableSingleRepaint();
    }//GEN-LAST:event_jSliderFront1StateChanged

    private void jPopupMenuLineMouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPopupMenuLineMouseExited
        jPopupMenuLine.setVisible(false);
    }//GEN-LAST:event_jPopupMenuLineMouseExited

    public void lineDeleteProxy()
    {
        jMenuItemLineDeleteActionPerformed(null);
    }
    private void jMenuItemLineDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemLineDeleteActionPerformed
        addHistory();
            // just delete it!
        singleVectorPanel1.deleteSelectedVector();
        jTable1.tableChanged(null);
        fillStatus();
        initFaces();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jMenuItemLineDeleteActionPerformed

    private void jMenuItemHereActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemHereActionPerformed
        addHistory();
        singleVectorPanel1.joinAllPointsAtHighlight();
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jMenuItemHereActionPerformed

    private void jButtonOneForwardSelection1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOneForwardSelection1ActionPerformed
        addHistory();
        singleVectorPanel1.clearVectors();
        jTable1.tableChanged(null);
        initFaces();
        fillStatus();
    }//GEN-LAST:event_jButtonOneForwardSelection1ActionPerformed

    private void jCheckBoxArrowsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxArrowsActionPerformed
        singleVectorPanel1.setDrawArrows(jCheckBoxArrows.isSelected());
    }//GEN-LAST:event_jCheckBoxArrowsActionPerformed

    private void jButtonCubeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCubeActionPerformed
        addHistory();
        // add a cube to the vectorList
        GFXVector v = new GFXVector();
        int length = de.malban.util.UtilityString.IntX(jTextFieldBaseSize.getText(), 1);
        addVector(v);
        addVector(v = new GFXVector(v,length,0,0));
        addVector(v = new GFXVector(v,0,length,0));
        addVector(v = new GFXVector(v,-length,0,0));
        addVector(v = new GFXVector(v,0,-length,0));
        
        addVector(v = new GFXVector(v,0,0,length));
        
        addVector(v = new GFXVector(v,length,0,0));
        addVector(v = new GFXVector(v,0,length,0));
        addVector(v = new GFXVector(v,-length,0,0));
        addVector(v = new GFXVector(v,0,-length,0));

        addVector(v = new GFXVector(v,length,0,0));
        addVector(v = new GFXVector(v,0,0,-length));
        
        addVector(v = new GFXVector(v,0,length,0));
        addVector(v = new GFXVector(v,0,0,length));
        addVector(v = new GFXVector(v,-length,0,0));
        addVector(v = new GFXVector(v,0,0,-length));
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
        
    }//GEN-LAST:event_jButtonCubeActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        addHistory();
        GFXVector v = new GFXVector();
        int length = de.malban.util.UtilityString.IntX(jTextFieldBaseSize.getText(), 1);
        addVector(v);
        addVector(v = new GFXVector(v,length,0,0));
        addVector(v = new GFXVector(v,length,0,0));

        addVector(v = new GFXVector(v,0,0,length));
        addVector(v = new GFXVector(v,0,0,length));

        addVector(v = new GFXVector(v,-length,0,0));
        addVector(v = new GFXVector(v,-length,0,0));

        addVector(v = new GFXVector(v,0,0,-length));
        addVector(v = new GFXVector(v,0,0,-length));
        
        addVector(v = new GFXVector(v,length,length,length));
        addVector(v = new GFXVector(v,length,-length,length));
        addVector(v = new GFXVector(v,-length,length,-length));
        addVector(v = new GFXVector(v,-length,-length,length));
        addVector(v = new GFXVector(v,length,length,-length));
        addVector(v = new GFXVector(v,length,-length,-length));
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
        
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jButtonExportActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonExportActionPerformed
        ExportFrame exportFrame = new ExportFrame(this);
        exportFrame.setVisible(true);
    }//GEN-LAST:event_jButtonExportActionPerformed

    private void jButtonExport1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonExport1ActionPerformed
        ImportFrame importFrame = new ImportFrame(this);
        importFrame.setVisible(true);
    }//GEN-LAST:event_jButtonExport1ActionPerformed

    private void jButtonSave1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSave1ActionPerformed
        String filename =Global.mainPathPrefix+"xml"+File.separator+"vectorlist";
        String saveName = VectorListFileChoserJPanel.showSavePanel(filename, "Save Vectorlist", false);
        if (saveName != null)
            saveCurrentList(saveName);
    }//GEN-LAST:event_jButtonSave1ActionPerformed

    String lastPath = "";
    private void jButtonLoadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoadActionPerformed
        String filename =Global.mainPathPrefix+"xml"+File.separator+"vectorlist";
        String loadName = VectorListFileChoserJPanel.showLoadPanel(filename,"Load Vectorlist", false);
        if (loadName != null)
        {
            jRadioButtonSelectLine.setSelected(true);
            jRadioButtonSelectLineActionPerformed(null);
            loadCurrentList(loadName);
        }
        fillStatus();
    }//GEN-LAST:event_jButtonLoadActionPerformed

    private void jButton2dAxisActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2dAxisActionPerformed
        inSetting++;
        jSliderFront1.setValue(0);
        jTextFieldFront2.setText("0");
        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setAxisAngleX(0);
        
        jSliderSide1.setValue(0);
        jTextFieldSide2.setText("0");
        single3dDisplayPanel.setAxisAngleY(0);

        jSliderTop1.setValue(0);
        jTextFieldTop2.setText("0");
        single3dDisplayPanel.setAxisAngleZ(0);
        single3dDisplayPanel.enableSingleRepaint();
        
        
        
        inSetting--;
        
    }//GEN-LAST:event_jButton2dAxisActionPerformed

    private void jButton3dAxisActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3dAxisActionPerformed
        inSetting++;
        jSliderFront1.setValue(38);
        jTextFieldFront2.setText("38");
        single3dDisplayPanel.disableSingleRepaint();
        single3dDisplayPanel.setAxisAngleX(38);
        
        jSliderSide1.setValue(49);
        jTextFieldSide2.setText("49");
        single3dDisplayPanel.setAxisAngleY(49);

        jSliderTop1.setValue(31);
        jTextFieldTop2.setText("31");
        single3dDisplayPanel.setAxisAngleZ(31);
        single3dDisplayPanel.enableSingleRepaint();
        
        inSetting--;
    }//GEN-LAST:event_jButton3dAxisActionPerformed

    private void jTextFieldRotateYActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldRotateYActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldRotateYActionPerformed

    private void jCheckBox2dOnlyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox2dOnlyActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox2dOnlyActionPerformed

    private void jButtonSave2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSave2ActionPerformed
        saveAnimation();
    }//GEN-LAST:event_jButtonSave2ActionPerformed

    private void jButtonApplyCurrentActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonApplyCurrentActionPerformed
        applyChanges();
    }//GEN-LAST:event_jButtonApplyCurrentActionPerformed

    private void jButtonAddCurrentActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAddCurrentActionPerformed
        addCurrentToAnimation();
        jTextFieldCount.setText(""+currentAnimation.size());
    }//GEN-LAST:event_jButtonAddCurrentActionPerformed

    private void jToggleButtonPlayAnimActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButtonPlayAnimActionPerformed
        if (jRadioButtonAnimation.isSelected())
            doAnimation();
        else
            doScenario();
        if (jToggleButtonPlayAnim.isSelected())
        {
            jToggleButtonPlayAnim.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_stop_blue.png"))); // NOI18N
        }
        else
        {
            jToggleButtonPlayAnim.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        }
            
        
        
    }//GEN-LAST:event_jToggleButtonPlayAnimActionPerformed

    private void jButtonLoad1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoad1ActionPerformed
        loadAnimation();
        jTextFieldCount.setText(""+currentAnimation.size());
        fillStatus();
    }//GEN-LAST:event_jButtonLoad1ActionPerformed

    private void jButtonDeleteOneActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteOneActionPerformed
        deleteSelectedFromAnimation();
        jTextFieldCount.setText(""+currentAnimation.size());
        fillStatus();
    }//GEN-LAST:event_jButtonDeleteOneActionPerformed

    private void jButtonInterpreteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonInterpreteActionPerformed

        doInterpret();
        fillStatus();
    }//GEN-LAST:event_jButtonInterpreteActionPerformed

    private void jButtonOneForwardActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOneForwardActionPerformed
        int index = currentAnimation.getIndexFromUID(preSelectedAnimationFrameUID);
        if (index <0) return;
        
        // if shift is pressed, than "switch position" with neighbour
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
        {
            if (index+1>=currentAnimation.size()) return;
            GFXVectorList push = currentAnimation.list.remove(index);
            currentAnimation.list.add(index+1, push);
        }
        else
        {
            index++;
            if (index>=currentAnimation.size()) return;
            int newUID = currentAnimation.get(index).uid;
            if (newUID == -1) return;
            boolean ok = setCurrentListFromUID(newUID, false);
        }
        redrawAnimation();
        fillStatus();
    }//GEN-LAST:event_jButtonOneForwardActionPerformed

    private void jButtonAddCurrent1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAddCurrent1ActionPerformed
        addViewToAnimation();
        jTextFieldCount.setText(""+currentAnimation.size());
    }//GEN-LAST:event_jButtonAddCurrent1ActionPerformed

    private void jButtonSetStyleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSetStyleActionPerformed
        addHistory();
        ArrayList<GFXVector> list = singleVectorPanel1.getSelectedVectors();

        for (GFXVector v : list)
            checkVectorStyles(v);
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonSetStyleActionPerformed

    private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed
        buildRotationAnimation();
    }//GEN-LAST:event_jButton4ActionPerformed

    private void jButtonClearAnimationActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonClearAnimationActionPerformed
        GFXVectorList copy = singleVectorPanel1.getForegroundVectorList().clone();
        currentAnimation = new GFXVectorAnimation();
        singleVectorPanel1.setForegroundVectorList(new GFXVectorList());
        selectedAnimationFrameUID = -1;
        preSelectedAnimationFrameUID = -1;

        if (jToggleButtonPlayAnim.isSelected())
        {
            doAnimation();
        }
        redrawAnimation();
        jTextFieldCount.setText(""+currentAnimation.size());

        setCurrentVectorList(copy);
        singleVectorPanel1.sharedRepaint();
        initFaces();
        fillStatus();
    }//GEN-LAST:event_jButtonClearAnimationActionPerformed

    private void jMenuItemDeleteNotSelectedActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemDeleteNotSelectedActionPerformed
        addHistory();
        singleVectorPanel1.deleteNotSelectedVector();
        initFaces();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
        
    }//GEN-LAST:event_jMenuItemDeleteNotSelectedActionPerformed

    private void jButtonSaveSelectionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveSelectionActionPerformed
        String filename =Global.mainPathPrefix+"xml"+File.separator+"vectorlist";
        String saveName = VectorListFileChoserJPanel.showSavePanel(filename, "Save selected Vectorlist", false);
        if (saveName != null)
        {
            GFXVectorList vl = singleVectorPanel1.getSelectedVectorList();
            // is already a clone!
            vl.resetDisplay();

            if (!saveName.toUpperCase().endsWith(".XML"))
            {
                saveName+= ".xml";
            }
            vl.saveAsXML(saveName);
        }
    }//GEN-LAST:event_jButtonSaveSelectionActionPerformed

    private void jButtonInsertVectorList(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonInsertVectorList
       
        String filename =Global.mainPathPrefix+"xml"+File.separator+"vectorlist";
        String loadName = VectorListFileChoserJPanel.showLoadPanel(filename,"Insert Vectorlist", false);
        if (loadName != null)
        {
            GFXVectorList vl = new GFXVectorList();
            if (vl.loadFromXML(loadName))
            {
                jRadioButtonSelectLine.setSelected(true);
                jRadioButtonSelectLineActionPerformed(null);

                GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
                for (int i=0; i<listNow.size(); i++)
                {
                    listNow.get(i).selected = false;
                }
                singleVectorPanel1.addForegroundVectorList(vl);
                for (int i=0; i<vl.size(); i++)
                {
                    vl.get(i).selected = true;
                }
            }
        }
        mClassSetting++;
        jTable1.tableChanged(null);
        mClassSetting--;
        setSelectedInTable();
        singleVectorPanel1.sharedRepaint();
        fillStatus();
    }//GEN-LAST:event_jButtonInsertVectorList

    public void cutProxy()
    {
        jButtonCutActionPerformed(null);
    }
    private void jButtonCutActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCutActionPerformed
        addHistory();
        jButtonCopyActionPerformed(null);
        jMenuItemLineDeleteActionPerformed(null);
        fillStatus();
    }//GEN-LAST:event_jButtonCutActionPerformed

    public void pasteProxy()
    {
        jButtonPasteActionPerformed(null);
    }
    
    private void jButtonPasteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPasteActionPerformed
        addHistory();
       
        jRadioButtonSelectLine.setSelected(true);
        jRadioButtonSelectLineActionPerformed(null);
        
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        for (int i=0; i<listNow.size(); i++)
        {
            listNow.get(i).selected = false;
        }

        GFXVectorList list = buffer.clone();
        for (int i=0; i<list.size(); i++)
        {
            list.get(i).selected = true;
            listNow.add(list.get(i));
        }
        singleVectorPanel1.sharedRepaint();
        mClassSetting++;
        jTable1.tableChanged(null);
        mClassSetting--;
        setSelectedInTable();
        fillStatus();
        
    }//GEN-LAST:event_jButtonPasteActionPerformed

    public void copyProxy()
    {
        jButtonCopyActionPerformed(null);
    }
    private void jButtonCopyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCopyActionPerformed

        // copy only selected
        // 1. copy all
        buffer = singleVectorPanel1.getForegroundVectorList().clone();
        
        // remove non selected!
        ArrayList<GFXVector> toRemove = new ArrayList<GFXVector>();
        
        // that way all relations are kept intact!
        for (int i=0; i<buffer.size(); i++)
        {
            if (!buffer.get(i).selected)
                toRemove.add(buffer.get(i));
        }
        for (GFXVector v: toRemove)
            buffer.remove(v);
        buffer.resetDisplay();
        
        
    }//GEN-LAST:event_jButtonCopyActionPerformed

    private void jButtonRemoveDotsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRemoveDotsActionPerformed
        addHistory();
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        
        listNow.removePoints(jCheckBox3dDots.isSelected());
        
        
        singleVectorPanel1.sharedRepaint();
        
        mClassSetting++;
        jTable1.tableChanged(null);
        mClassSetting--;
        setSelectedInTable();
        verifyFaces();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonRemoveDotsActionPerformed

    private void jButtonConnectWherePossibleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonConnectWherePossibleActionPerformed
        addHistory();
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        listNow.connectWherePossible(false);
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonConnectWherePossibleActionPerformed

    private void jButtonReverseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonReverseActionPerformed
        ArrayList<GFXVectorList> list = new ArrayList<GFXVectorList>();
        for (int i= currentAnimation.size()-1; i>=0; i--)
        {
            list.add(currentAnimation.get(i));
        }
        currentAnimation.list = list;
        redrawAnimation();
        
        /*
        if (jToggleButtonPlayAnim.isSelected())
        {
            single3dDisplayPanel.setAnimation(currentAnimation);
            single3dDisplayPanel.setDelay(de.malban.util.UtilityString.IntX(jTextFieldDelay.getText(),-1));
        }
                */
    }//GEN-LAST:event_jButtonReverseActionPerformed

    private void jTextFieldDelayActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldDelayActionPerformed
        single3dDisplayPanel.setDelay(de.malban.util.UtilityString.IntX(jTextFieldDelay.getText(),-1));
    }//GEN-LAST:event_jTextFieldDelayActionPerformed

    public void selectAllProxy()
    {
        jButtonSelectAllActionPerformed(null);
    }
    private void jButtonSelectAllActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSelectAllActionPerformed
        if (jRadioButtonSelectPoint.isSelected())
        {
            GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
            for (int i=0; i<listNow.size(); i++)
            {
                GFXVector v = listNow.get(i);
                v.start.selected = true;
                v.end.selected = true;
            }
        }
        else
        {
            GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
            for (int i=0; i<listNow.size(); i++)
            {
                GFXVector v = listNow.get(i);
                v.selected = true;
            }
        }
        jTable1.repaint();
        singleVectorPanel1.sharedRepaint();
    }//GEN-LAST:event_jButtonSelectAllActionPerformed

    private void jCheckBoxByteFrameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxByteFrameActionPerformed
        singleVectorPanel1.setByteFrame(jCheckBoxByteFrame.isSelected());
        // in "play" mode the two are not connected,
        // therefor set it here to!
        single3dDisplayPanel.setByteFrame(jCheckBoxByteFrame.isSelected());
    }//GEN-LAST:event_jCheckBoxByteFrameActionPerformed

    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed
        doMorphing();
    }//GEN-LAST:event_jButton6ActionPerformed

    private void jButtonExpandDimensionYZActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonExpandDimensionYZActionPerformed
        expandDimensionYZ();
        fillStatus();
    }//GEN-LAST:event_jButtonExpandDimensionYZActionPerformed

    private void jMenuItemDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemDeleteActionPerformed
        addHistory();
        // TODO add your handling code here:
    }//GEN-LAST:event_jMenuItemDeleteActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        addHistory();
        centerVectorList();
        fillStatus();
        verifyFaces();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButton5ActionPerformed

    private void jButtonFitByteRangeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFitByteRangeActionPerformed
        addHistory();
        fitByteRange();
        fillStatus();
        verifyFaces();
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonFitByteRangeActionPerformed

    private void jRadioButtonScenarioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButtonScenarioActionPerformed
        if (mClassSetting>0) return;
        if (currentAnimation == null) return;
        currentAnimation.isAnimation = !jRadioButtonScenario.isSelected();
        if (jRadioButtonScenario.isSelected())
            doScenario();
        checkAnimExportButtons();        
    }//GEN-LAST:event_jRadioButtonScenarioActionPerformed

    private void jRadioButtonAnimationActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButtonAnimationActionPerformed
        if (mClassSetting>0) return;
        if (currentAnimation == null) return;
        currentAnimation.isAnimation = jRadioButtonAnimation.isSelected();
        if (jRadioButtonAnimation.isSelected())
            doAnimation();
        checkAnimExportButtons();
    }//GEN-LAST:event_jRadioButtonAnimationActionPerformed

    private void jButtonSave3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSave3ActionPerformed
        savePatterns();
    }//GEN-LAST:event_jButtonSave3ActionPerformed

    private void jComboBoxPatternsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxPatternsActionPerformed

        if (mClassSetting>0) return;
        if (jComboBoxPatterns.getSelectedIndex() == -1) return;
        PatternInfo info = (PatternInfo)jComboBoxPatterns.getSelectedItem();
        jTextFieldPatternName.setText(info.name);
        jTextField8.setText(info.line1Pattern);
        jTextField10.setText(info.lineXPattern);
        jTextField9.setText(info.lastLinePattern);
        // reset
        doInterpret();
    }//GEN-LAST:event_jComboBoxPatternsActionPerformed

    private void jTextFieldPatternNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPatternNameActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldPatternNameActionPerformed

    private void jButtonOneBackActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOneBackActionPerformed
        int index = currentAnimation.getIndexFromUID(preSelectedAnimationFrameUID);
        if (index <=0) return;
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
        {
            GFXVectorList pull = currentAnimation.list.remove(index);
            currentAnimation.list.add(index-1, pull);
        }
        else
        {
            index--;
            int newUID = currentAnimation.get(index).uid;
            if (newUID == -1) return;
            boolean ok = setCurrentListFromUID(newUID, false);
        }
        redrawAnimation();
    
    }//GEN-LAST:event_jButtonOneBackActionPerformed

    private void jButtonJoinActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonJoinActionPerformed
        // build list with all stuff
        GFXVectorList vl = new GFXVectorList();
        if (jCheckBoxAutoEdit.isSelected())
        {
            for (int i=0; i<currentAnimation.size(); i++)
            {
                vl.add(currentAnimation.get(i));
            }
            vl.connectWherePossible(false);
        }
        else
        {
            if (preSelectedAnimationFrameUID == -1) return;

            int indexToJoin = -1;
            for (int i=0;i<currentAnimation.size(); i++)
            {
                int uid = currentAnimation.get(i).uid;
                if (uid ==preSelectedAnimationFrameUID)
                {
                    indexToJoin = i;
                    break;
                }
            }        
            if (indexToJoin==-1) return;
            
            
            vl = singleVectorPanel1.getForegroundVectorList().clone();
            vl.add(currentAnimation.get(indexToJoin));
        }

        singleVectorPanel1.setForegroundVectorList(vl);
        singleVectorPanel1.sharedRepaint();
        initFaces();
        jTable1.tableChanged(null);
        fillStatus();
        
    }//GEN-LAST:event_jButtonJoinActionPerformed

    private void jButtonOrderVectorlistActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOrderVectorlistActionPerformed
        addHistory();
        singleVectorPanel1.getForegroundVectorList().doOrder();
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonOrderVectorlistActionPerformed

    private void jCheckBoxPositionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxPositionActionPerformed
        singleVectorPanel1.setDrawPosition(jCheckBoxPosition.isSelected());
    }//GEN-LAST:event_jCheckBoxPositionActionPerformed

    private void jButtonFillGapsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFillGapsActionPerformed
        addHistory();
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        vl.fillgaps(jCheckBoxLine.isSelected());
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonFillGapsActionPerformed

    private void jButtonPathsAsScenarioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPathsAsScenarioActionPerformed
        pathsAsScenario();
    }//GEN-LAST:event_jButtonPathsAsScenarioActionPerformed

    private void jButtonEnlargeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEnlargeActionPerformed
        addHistory();
        double scale = de.malban.util.UtilityString.FloatX(jTextFieldScaleFactor.getText(), 2);
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();
        vl.scaleAll(scale, safetyMap, jCheckBox6.isSelected(), jCheckBox7.isSelected(), jCheckBox8.isSelected());
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        verifyFaces();
        fillStatus();
    }//GEN-LAST:event_jButtonEnlargeActionPerformed

    private void jButtonShrinkActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonShrinkActionPerformed
        addHistory();

        double scale = 1.0/de.malban.util.UtilityString.FloatX(jTextFieldScaleFactor.getText(), 2);
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();
        vl.scaleAll(scale, safetyMap, jCheckBox6.isSelected(), jCheckBox7.isSelected(), jCheckBox8.isSelected());
        
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        verifyFaces();
        fillStatus();
    }//GEN-LAST:event_jButtonShrinkActionPerformed

    private void jCheckBoxMovesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxMovesActionPerformed
        singleVectorPanel1.setMovesVisible(jCheckBoxMoves.isSelected());
    }//GEN-LAST:event_jCheckBoxMovesActionPerformed

    private void jMenuItemPoint0ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemPoint0ActionPerformed
        addHistory();
        highlightAsStart();
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jMenuItemPoint0ActionPerformed

    
        
    
    private void jButtonAssembleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssembleActionPerformed
        
        String filename = Global.mainPathPrefix+"tmp"+File.separator+"veccytmp.asm";
        de.malban.util.UtilityFiles.createTextFile(filename, jTextAreaResult.getText());
        startASM(filename);
    }//GEN-LAST:event_jButtonAssembleActionPerformed
    // http://stackoverflow.com/questions/6710350/copying-text-to-the-clipboard-using-java
    private static void copy(String text)
    {
        Clipboard clipboard = getSystemClipboard();
        try
        {
        clipboard.setContents(new StringSelection(text), null);
        }
        catch (Throwable e)
        {} // don't bother
    }    
    private static Clipboard getSystemClipboard()
    {
        Toolkit defaultToolkit = Toolkit.getDefaultToolkit();
        Clipboard systemClipboard = defaultToolkit.getSystemClipboard();

        return systemClipboard;
    }    

    private void jButtonMov_Draw_VLc_aActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonMov_Draw_VLc_aActionPerformed
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname.getText();
        if (name.trim().length() == 0) name = "VectorList";
        
        if (jCheckBoxCStyle.isSelected())
        {
            String text = vl.createCMov_Draw_VLc_a(true, name, jCheckBoxAddFactor.isSelected(), jCheckBoxPCStyle.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }
            jTextAreaResult.setText(text);
            copy(text);
        }
        else
        {
            String text = vl.createASMMov_Draw_VLc_a(true, name, jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "BLOW_UP EQU 1\n\n"+text;
            }

            if (jCheckBoxRunnable.isSelected())
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "vectorlistMov_Draw_VLc_a.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main += "\nvData = "+name+"\n";
                text = main +text;
            }


            jTextAreaResult.setText(text);
            copy(text);
            checkAssemblerButton();
        }
    }//GEN-LAST:event_jButtonMov_Draw_VLc_aActionPerformed

    private void jButtonDraw_VLcActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_VLcActionPerformed
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname.getText();
        if (name.trim().length() == 0) name = "VectorList";

        if (jCheckBoxCStyle.isSelected())
        {
            String text = vl.createCMov_Draw_VLc_a(false, name, jCheckBoxAddFactor.isSelected(), jCheckBoxPCStyle.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }
            jTextAreaResult.setText(text);
            copy(text);
        }
        else
        {
            String text = vl.createASMMov_Draw_VLc_a(false, name, jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "BLOW_UP EQU 1\n\n"+text;
            }
            if (jCheckBoxRunnable.isSelected())
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "vectorlistDraw_VLc.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main += "\nvData = "+name+"\n";
                text = main +text;
            }
            jTextAreaResult.setText(text);
            copy(text);
            checkAssemblerButton();            
        }
        

    }//GEN-LAST:event_jButtonDraw_VLcActionPerformed

    private void jButtonDraw_VLpActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_VLpActionPerformed
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname.getText();
        if (name.trim().length() == 0) name = "VectorList";
        
        if (jCheckBoxCStyle.isSelected())
        {
            String text = vl.createCDraw_VLp(name, jCheckBoxAddFactor.isSelected(), jCheckBox16.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }
            jTextAreaResult.setText(text);
            copy(text);
        }
        else
        {
            String text = vl.createASMDraw_VLp(name, jCheckBoxAddFactor.isSelected(), jCheckBox16.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "BLOW_UP EQU 1\n\n"+text;
            }
            if (jCheckBoxRunnable.isSelected())
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "vectorlistDraw_VLp.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main += "\nvData = "+name+"\n";
                text = main +text;
            }
            jTextAreaResult.setText(text);
            copy(text);
            checkAssemblerButton();        
        }
        

    }//GEN-LAST:event_jButtonDraw_VLpActionPerformed

    private void jButtonDraw_VL_modeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_VL_modeActionPerformed
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname.getText();
        if (name.trim().length() == 0) name = "VectorList";
        if (jCheckBoxCStyle.isSelected())
        {
            String text = vl.createCDraw_VL_mode(name, false, jCheckBoxAddFactor.isSelected(), jCheckBoxPCStyle.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }

            jTextAreaResult.setText(text);
            copy(text);
        }
        else
        {
            if (jCheckBoxVec32.isSelected())
            {
                String text = vl.createASMDraw_VL_modeBASIC(name);
                copy(text);

                if (jCheckBoxRunnable.isSelected())
                {
                    text = "function getVectorList()\n" + text + "\n     return VectorList\nendfunction\n";
                    Path template = Paths.get(Global.mainPathPrefix, "template", "drawVectorlist.bas");
                    String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                    text = main +"\n"+text;
                }

                jTextAreaResult.setText(text);
                return;
            }
            String text = vl.createASMDraw_VL_mode(name, false, jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "BLOW_UP EQU 1\n\n"+text;
            }

            if (jCheckBoxRunnable.isSelected())
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "vectorlistDraw_VL_mode.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main = de.malban.util.UtilityString.replace(main, "#PATTERN#", jTextFieldPattern.getText());
                main += "\nvData = "+name+"\n";
                text = main +text;
            }

            jTextAreaResult.setText(text);
            copy(text);
            checkAssemblerButton();
        }

    }//GEN-LAST:event_jButtonDraw_VL_modeActionPerformed

    private void jButtonMov_Draw_VLc_aAnimActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonMov_Draw_VLc_aAnimActionPerformed
        String name = jTextFieldAnimName.getText();
        if (name.trim().length() == 0) 
        {
            if (currentAnimation.isAnimation)
                name = "AnimList";
            else
                name = "SceneList";
        }
        
        if (jCheckBoxCStyle.isSelected())
        {
            String text = currentAnimation.createCMov_Draw_VLc_a(name, jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }
            jTextAreaResult.setText(text);
            copy(text);
        }
        else
        {
            String text = currentAnimation.createASMMov_Draw_VLc_a(name, jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "BLOW_UP EQU 1\n\n"+text;
            }

            if (jCheckBoxRunnable.isSelected())
            {
                Path template;
                if (currentAnimation.isAnimation)
                    template = Paths.get(Global.mainPathPrefix, "template", "animationMov_Draw_VLc_a.template");
                else
                    template = Paths.get(Global.mainPathPrefix, "template", "scenarioMov_Draw_VLc_a.template");

                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main += "\nvData = "+name+"\n";
                main += "vDataLength = "+currentAnimation.size()+"\n";
                text = main +text;
            }

            jTextAreaResult.setText(text);
            copy(text);
            checkAssemblerButton();            
        }
    }//GEN-LAST:event_jButtonMov_Draw_VLc_aAnimActionPerformed

    private void jButtonDraw_VLcAnimActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_VLcAnimActionPerformed
        String name = jTextFieldAnimName.getText();
     //   if (!currentAnimation.isAnimation) return;
        if (name.trim().length() == 0) 
        {
            if (currentAnimation.isAnimation)
                name = "AnimList";
            else
                name = "SceneList";
        }
        if (jCheckBoxCStyle.isSelected())
        {
            String text = currentAnimation.createCDraw_VLc(name, jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }
            jTextAreaResult.setText(text);
            copy(text);
        }
        else
        {
            String text = currentAnimation.createASMDraw_VLc(name, jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "BLOW_UP EQU 1\n\n"+text;
            }

            if (jCheckBoxRunnable.isSelected())
            {
                Path template;
                if (currentAnimation.isAnimation)
                    template = Paths.get(Global.mainPathPrefix, "template", "animationDraw_VLc.template");
                else
                    template = Paths.get(Global.mainPathPrefix, "template", "scenarioDraw_VLc.template");

                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main += "\nvData = "+name+"\n";
                main += "vDataLength = "+currentAnimation.size()+"\n";
                text = main +text;
            }

            jTextAreaResult.setText(text);
            copy(text);
            checkAssemblerButton();
        }
    }//GEN-LAST:event_jButtonDraw_VLcAnimActionPerformed

    private void jButtonDraw_VLpAnimActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_VLpAnimActionPerformed
//        if (!currentAnimation.isAnimation) return;
        String name = jTextFieldAnimName.getText();
        if (name.trim().length() == 0) 
        {
            if (currentAnimation.isAnimation)
                name = "AnimList";
            else
                name = "SceneList";
        }

        if (jCheckBoxCStyle.isSelected())
        {
            String text = currentAnimation.createCDraw_VLp(name, jCheckBoxAddFactor.isSelected(), jCheckBox16.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }
            jTextAreaResult.setText(text);
            copy(text);
        
        }
        else
        {
            String text = currentAnimation.createASMDraw_VLp(name, jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "BLOW_UP EQU 1\n\n"+text;
            }

            if (jCheckBoxRunnable.isSelected())
            {
                Path template;
                if (currentAnimation.isAnimation)
                    template = Paths.get(Global.mainPathPrefix, "template", "animationDraw_VLp.template");
                else
                    template = Paths.get(Global.mainPathPrefix, "template", "scenarioDraw_VLp.template");

                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main += "\nvData = "+name+"\n";
                main += "vDataLength = "+currentAnimation.size()+"\n";
                text = main +text;
            }

            jTextAreaResult.setText(text);
            copy(text);
            checkAssemblerButton();            
        }
    }//GEN-LAST:event_jButtonDraw_VLpAnimActionPerformed

    private void jButtonDraw_VL_modeAnimActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_VL_modeAnimActionPerformed
        String name = jTextFieldAnimName.getText();
        
        if (name.trim().length() == 0) 
        {
            if (currentAnimation.isAnimation)
                name = "AnimList";
            else
                name = "SceneList";
        }
        if (jCheckBoxCStyle.isSelected())
        {
            String text = currentAnimation.createCDraw_VL_mode(name, true, jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }
            jTextAreaResult.setText(text);
            copy(text);
        }
        else
        {
            String text = currentAnimation.createASMDraw_VL_mode(name, true, jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "BLOW_UP EQU 1\n\n"+text;
            }
            if (jCheckBoxRunnable.isSelected())
            {
                Path template;
                if (currentAnimation.isAnimation)
                    template = Paths.get(Global.mainPathPrefix, "template", "animationDraw_VL_mode.template");
                else
                    template = Paths.get(Global.mainPathPrefix, "template", "scenarioDraw_VL_mode.template");

                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main += "\nvData = "+name+"\n";
                main += "vDataLength = "+currentAnimation.size()+"\n";
                text = main +text;
            }
            jTextAreaResult.setText(text);

            copy(text);
            checkAssemblerButton();            
        }

    }//GEN-LAST:event_jButtonDraw_VL_modeAnimActionPerformed
    public void undoProxy()
    {
        jButtonUndoActionPerformed(null);
    }

    private void jButtonUndoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonUndoActionPerformed
        int t=1;
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
        {
            t=10;
        }
        while (t-- >0)
            stepBackHistory();
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
    }//GEN-LAST:event_jButtonUndoActionPerformed
    public void redoProxy()
    {
        jButtonRedoActionPerformed(null);
    }
    private void jButtonRedoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRedoActionPerformed
        int t=1;
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
        {
            t=10;
        }
        while (t-- >0)
            stepForwardHistory();
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
    }//GEN-LAST:event_jButtonRedoActionPerformed

    private void jMenuItemInsertPointActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemInsertPointActionPerformed
        addHistory();
        GFXVector v = singleVectorPanel1.getHighlightedVector();
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        if (v == null) return;
        if (vl == null) return;
        vl.splitHalf(vl.list, v,v.order+1);
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
        
    }//GEN-LAST:event_jMenuItemInsertPointActionPerformed

    private void jCheckBoxRunnableActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxRunnableActionPerformed
        checkAssemblerButton();
    }//GEN-LAST:event_jCheckBoxRunnableActionPerformed

    private void jCheckBoxOnePathActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxOnePathActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxOnePathActionPerformed

    private void jButtonOrderSplitWhereNeededActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOrderSplitWhereNeededActionPerformed
        singleVectorPanel1.getForegroundVectorList().splitWhereNeeded(de.malban.util.UtilityString.IntX(jTextFieldNeedSplit.getText(),127));
        
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonOrderSplitWhereNeededActionPerformed

    private void jButtonOneForwardSelection2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOneForwardSelection2ActionPerformed
        VectorJPanel.showModPanelNoModal(this);
    }//GEN-LAST:event_jButtonOneForwardSelection2ActionPerformed

    private void jButtonEditInVediActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEditInVediActionPerformed
        
        CSAMainFrame frame = (CSAMainFrame)Configuration.getConfiguration().getMainFrame();
//        VediPanel vedi = frame.getVedi();
        
        VediPanel p = new VediPanel(false);        
        p.setTreeVisible(false);
        
        frame.addAsWindow(p, 1024, 768, VediPanel.SID);
        
        String tmpFile = Global.mainPathPrefix+"tmp"+File.separator+"veccyAsm.asm";
        de.malban.util.UtilityFiles.createTextFile(tmpFile, jTextAreaResult.getText());
        p.addTempEditFile(tmpFile);
        
        
    }//GEN-LAST:event_jButtonEditInVediActionPerformed

    private void jButtonEditInVedi1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEditInVedi1ActionPerformed
        
        CSAMainFrame frame = (CSAMainFrame)Configuration.getConfiguration().getMainFrame();
//        VediPanel vedi = frame.getVedi();
        
        VediPanel p = new VediPanel(false);        
        p.setTreeVisible(false);
        frame.addAsWindow(p, 1024, 768, VediPanel.SID);
        
        
        String tmpFile = Global.mainPathPrefix+"tmp"+File.separator+"veccyAsm.asm";
        de.malban.util.UtilityFiles.createTextFile(tmpFile, jTextAreaResult1.getText());
        p.addTempEditFile(tmpFile);
    }//GEN-LAST:event_jButtonEditInVedi1ActionPerformed

    private void jButtonAssemble1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssemble1ActionPerformed
        String filename = Global.mainPathPrefix+"tmp"+File.separator+"veccytmp.asm";
        de.malban.util.UtilityFiles.createTextFile(filename, jTextAreaResult1.getText());
        startASM(filename);
    }//GEN-LAST:event_jButtonAssemble1ActionPerformed

    private void jCheckBoxRunnable1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxRunnable1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxRunnable1ActionPerformed

    private void jButtonCodeGenActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCodeGenActionPerformed
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname1.getText();
        if (name.trim().length() == 0) name = "VectorList";
        String text = vl.createASMCodeGen(name);
        
        if (jCheckBoxRunnable1.isSelected())
        {
            Path template = Paths.get(Global.mainPathPrefix, "template", "vectorlistCodeGen.template");
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            text = main +text;
        }
        
        
        jTextAreaResult1.setText(text);
        copy(text);
        checkAssemblerButton2();
    }//GEN-LAST:event_jButtonCodeGenActionPerformed

    private void jButtonAnimCodeGenActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAnimCodeGenActionPerformed
        String name = jTextFieldAnimName1.getText();
        if (name.trim().length() == 0) 
        {
            if (currentAnimation.isAnimation)
                name = "AnimList";
            else
                name = "SceneList";
        }
        String text = currentAnimation.createASMCodeGen(name);

        if (jCheckBoxRunnable1.isSelected())
        {
            Path template;
            if (currentAnimation.isAnimation)
                template = Paths.get(Global.mainPathPrefix, "template", "animationCodeGen.template");
            else
                template = Paths.get(Global.mainPathPrefix, "template", "scenarioCodeGen.template");
                
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            main += "vDataLength = "+currentAnimation.size()+"\n";
            text = main +text;
        }
        
        jTextAreaResult1.setText(text);
        copy(text);
        checkAssemblerButton2();
    }//GEN-LAST:event_jButtonAnimCodeGenActionPerformed

    private void jButtonRotate2dActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRotate2dActionPerformed
        addHistory();
        int angle = de.malban.util.UtilityString.IntX(jTextFieldRotate2d.getText(), 90);
        GFXVectorList start = singleVectorPanel1.getForegroundVectorList();

        GFXVectorList newList = start;
        Matrix4x4 rotz = Matrix4x4.getRotationZ(Math.toRadians(angle));
        HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();

        for (int c = 0; c <newList.size(); c++)
        {
            GFXVector v = newList.get(c);
            Vertex p1 = v.start;
            Vertex p2 = v.end;


            if (safetyMap.get(p1) == null)
            {
                Vertex p1_ = rotz.multiply(p1);
                p1.coords[0] = Math.round(p1_.coords[0]);
                p1.coords[1] = Math.round(p1_.coords[1]);
                p1.coords[2] = Math.round(p1_.coords[2]);
                safetyMap.put(p1, true);
            }
            if (safetyMap.get(p2) == null)
            {
                Vertex p2_ = rotz.multiply(p2);
                p2.coords[0] = Math.round(p2_.coords[0]);
                p2.coords[1] = Math.round(p2_.coords[1]);
                p2.coords[2] = Math.round(p2_.coords[2]);
                safetyMap.put(p2, true);
            }

            v.start = p1;
            v.end = p2;            
        }
        singleVectorPanel1.sharedRepaint();
        verifyFaces();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
        
    }//GEN-LAST:event_jButtonRotate2dActionPerformed

    private void jButtonMirrorVerticallyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonMirrorVerticallyActionPerformed
        addHistory();
        GFXVectorList start = singleVectorPanel1.getForegroundVectorList();
        GFXVectorList newList = start;
        HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();

        for (int c = 0; c <newList.size(); c++)
        {
            GFXVector v = newList.get(c);
            Vertex p1 = v.start;
            Vertex p2 = v.end;

            if (safetyMap.get(p1) == null)
            {
                p1.coords[0] = -Math.round(p1.coords[0]);
                p1.coords[1] = Math.round(p1.coords[1]);
                p1.coords[2] = Math.round(p1.coords[2]);
                safetyMap.put(p1, true);
            }

            if (safetyMap.get(p2) == null)
            {
                p2.coords[0] = -Math.round(p2.coords[0]);
                p2.coords[1] = Math.round(p2.coords[1]);
                p2.coords[2] = Math.round(p2.coords[2]);
                safetyMap.put(p2, true);
            }

            v.start = p1;
            v.end = p2;            
        }
        
        
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        verifyFaces();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonMirrorVerticallyActionPerformed

    private void jButtonMirrorHorizontallyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonMirrorHorizontallyActionPerformed
        addHistory();
        GFXVectorList start = singleVectorPanel1.getForegroundVectorList();
        GFXVectorList newList = start;
        HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();
        for (int c = 0; c <newList.size(); c++)
        {
            GFXVector v = newList.get(c);
            Vertex p1 = v.start;
            Vertex p2 = v.end;

            if (safetyMap.get(p1) == null)
            {
                p1.coords[0] = Math.round(p1.coords[0]);
                p1.coords[1] = -Math.round(p1.coords[1]);
                p1.coords[2] = Math.round(p1.coords[2]);
                safetyMap.put(p1, true);
            }

            if (safetyMap.get(p2) == null)
            {
                p2.coords[0] = Math.round(p2.coords[0]);
                p2.coords[1] = -Math.round(p2.coords[1]);
                p2.coords[2] = Math.round(p2.coords[2]);
                safetyMap.put(p2, true);
            }

            v.start = p1;
            v.end = p2;            
        }
        
        
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        verifyFaces();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonMirrorHorizontallyActionPerformed

    private void jButtonDraw_syncListActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_syncListActionPerformed

        int resync = de.malban.util.UtilityString.IntX(jTextFieldResync.getText(), 20);
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname.getText();
        if (name.trim().length() == 0) name = "VectorList";
        
        if (jCheckBoxCStyle.isSelected())
        {
            StringBuilder t1 = new StringBuilder();
            vl.createCDraw_syncList(t1, name, jCheckBoxAddFactor.isSelected(), resync,jCheckBoxextendedList.isSelected(), de.malban.util.UtilityString.IntX(jTextFieldNeedSplit.getText(),127));
            String text = t1.toString();
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }

            jTextAreaResult.setText(text);
            copy(text);
        }
        
        else
        {
            StringBuilder t1 = new StringBuilder();
            vl.createASMDraw_syncList(t1, name, jCheckBoxAddFactor.isSelected(), resync,jCheckBoxextendedList.isSelected(), de.malban.util.UtilityString.IntX(jTextFieldNeedSplit.getText(),127));

            String text = t1.toString();

            if (jCheckBoxAddFactor.isSelected())
            {
                text = "BLOW_UP EQU 1\n\n"+text;
            }
            if (jCheckBoxRunnable.isSelected())
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "vectorlistDraw_sync.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main += "\nvData = "+name+"\n";

                text = main +text;
            }

            jTextAreaResult.setText(text);
            copy(text);
            checkAssemblerButton();            
        }
        

    }//GEN-LAST:event_jButtonDraw_syncListActionPerformed

      
    
    private void jCheckBoxAutoEditActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxAutoEditActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxAutoEditActionPerformed

    private void jButtonDraw_syncListAnimActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_syncListAnimActionPerformed

        String name = jTextFieldAnimName.getText();
        int resync = de.malban.util.UtilityString.IntX(jTextFieldResyncAnim.getText(), 20);

        // scenarion does not really make sense, since a sync list ACTUALLY IS some kind of scenario
        if (name.trim().length() == 0) 
        {
            if (currentAnimation.isAnimation)
                name = "AnimList";
            else
                name = "SceneList";
        }
        if (jCheckBoxCStyle.isSelected())
        {
            StringBuilder t1 = new StringBuilder();
            currentAnimation.createCDraw_syncList(t1, name, jCheckBoxAddFactor.isSelected(), resync, jCheckBoxExtendedAnimSync.isSelected(), de.malban.util.UtilityString.IntX(jTextFieldNeedSplit.getText(),127), jCheckBoxNoSyncOpt.isSelected());
            String text= t1.toString();
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }
            jTextAreaResult.setText(text);
            copy(text);
        }
        else
        {
            StringBuilder t1 = new StringBuilder();
            currentAnimation.createASMDraw_syncList(t1, name, jCheckBoxAddFactor.isSelected(), resync, jCheckBoxExtendedAnimSync.isSelected(), de.malban.util.UtilityString.IntX(jTextFieldNeedSplit.getText(),127), jCheckBoxNoSyncOpt.isSelected());
            String text=            t1.toString();
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "BLOW_UP EQU 1\n\n"+t1.toString();
            }
            if (jCheckBoxRunnable.isSelected())
            {
                Path template;
                if (jCheckBoxExtendedAnimSync.isSelected())
                {
                    if (currentAnimation.isAnimation)
                        template = Paths.get(Global.mainPathPrefix, "template", "animationDraw_esync.template");
                    else
                        template = Paths.get(Global.mainPathPrefix, "template", "scenarioDraw_esync.template");
                }
                else
                {
                    if (currentAnimation.isAnimation)
                        template = Paths.get(Global.mainPathPrefix, "template", "animationDraw_sync.template");
                    else
                        template = Paths.get(Global.mainPathPrefix, "template", "scenarioDraw_sync.template");
                }

                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main += "\nvData = "+name+"\n";
                main += "vDataLength = "+currentAnimation.size()+"\n";
                text = main +text;
            }
            jTextAreaResult.setText(text);

            copy(text);
            checkAssemblerButton();   
        }
    }//GEN-LAST:event_jButtonDraw_syncListAnimActionPerformed

    private void jButtonEnlarge1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEnlarge1ActionPerformed
        addHistory();
        double scale = de.malban.util.UtilityString.FloatX(jTextFieldScaleFactor1.getText(), 2);
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();
        vl.scaleAll(scale, safetyMap);
        for (int i= currentAnimation.size()-1; i>=0; i--)
        {
            safetyMap = new HashMap<Vertex, Boolean>();
            currentAnimation.get(i).scaleAll(scale, safetyMap);
        }
        redrawAnimation();
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
    }//GEN-LAST:event_jButtonEnlarge1ActionPerformed

    private void jButtonShrink1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonShrink1ActionPerformed
        addHistory();

        double scale = 1.0/de.malban.util.UtilityString.FloatX(jTextFieldScaleFactor1.getText(), 2);
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();
        vl.scaleAll(scale, safetyMap);
        for (int i= currentAnimation.size()-1; i>=0; i--)
        {
            safetyMap = new HashMap<Vertex, Boolean>();
            currentAnimation.get(i).scaleAll(scale, safetyMap);
        }
        redrawAnimation();
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
    }//GEN-LAST:event_jButtonShrink1ActionPerformed

    private void jButtonFitByteRange1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFitByteRange1ActionPerformed
        addHistory();
        fitByteRangeCollection();
        fillStatus();
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();

    }//GEN-LAST:event_jButtonFitByteRange1ActionPerformed

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        SingleVectorPanel.displayLen = jCheckBox1.isSelected();
        jTable1.tableChanged(null);
    }//GEN-LAST:event_jCheckBox1ActionPerformed
    
    ArrayList<Vertex> getCurrentSelectedPoints()
    {
        ArrayList<Vertex> listOfPoints = new ArrayList<Vertex>();
        ArrayList<GFXVector> toTranslocate = singleVectorPanel1.getSelectedPointVectors();
        HashMap<Vertex, Vertex> alreadyDone = new HashMap<Vertex, Vertex>();
        for (GFXVector v: toTranslocate)
        {
            Vertex start = v.start;
            if (start.selected)
            {
                if (alreadyDone.get(start) == null) 
                {
                    alreadyDone.put(start, start);
                    listOfPoints.add(start);
                }
            }
            Vertex end = v.end;
            if (end.selected)
            {
                if (alreadyDone.get(end) == null) 
                {
                    alreadyDone.put(end, end);
                    listOfPoints.add(end);
                }
            }
        }
        return listOfPoints;
    }
    
    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed

        // coplanar check, see: http://paulbourke.net/geometry/pointlineplane/
        ArrayList<Vertex> listOfPoints =  singleVectorPanel1.getPointSelectionOrder();
        //ArrayList<Vertex> listOfPoints = getCurrentSelectedPoints();
        ArrayList<Vertex> plane = getPlaneDefinition(listOfPoints);
        if (plane == null)
        {
            jLabel55.setText("not even a plane");
        }
        else if (isCoplanar(listOfPoints))
        {
            jLabel55.setText("coplanar");
            addFace((ArrayList<Vertex>)listOfPoints.clone()); // shallow copy!
        }
        else
        {
            jLabel55.setText("not coplanar");
        }
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        HLines hlines = new HLines();
        
        GFXVectorList vl = single3dDisplayPanel.getDisplayVectorList();
        
        GFXVectorList pvl = hlines.processVectorlist(vl);
        
        pvl.resetDisplay();
        currentAnimation.add(pvl);
//        selectedAnimationFrameUID = pvl.uid;
//        preSelectedAnimationFrameUID = pvl.uid;
//        setCurrentListFromUID(selectedAnimationFrameUID, true);
        redrawAnimation();
    }//GEN-LAST:event_jButton3ActionPerformed

    private void jButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton7ActionPerformed
        removeFaces();
    }//GEN-LAST:event_jButton7ActionPerformed

    private void jTableFaceComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_jTableFaceComponentResized
        resetFaceTable();
    }//GEN-LAST:event_jTableFaceComponentResized

    private void jTable1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable1MousePressed
        JTable table =(JTable) evt.getSource();
        Point p = evt.getPoint();
        int row = table.rowAtPoint(p);
        int col = table.columnAtPoint(p);
        
        
        if (evt.getButton() == MouseEvent.BUTTON3)
        {
            SingleVectorPanel svp = singleVectorPanel1;
            
            jMenuItemPoint0.setEnabled(svp.getHighlightedVPoint() != null);
            /*
            if (jRadioButtonSelectPoint.isSelected())
            {
                ArrayList<GFXVector> vs = svp.getSelectedPointVectors();
                jMenuItemConnect.setEnabled(vs.size() == 2);
                jMenuItemJoin.setEnabled(vs.size() >= 2);
                jMenuItemRip.setEnabled(vs.size() >= 2); // but with the same point :-)
                
                jMenuItemHere.setEnabled(false);
                if (jCheckBoxContinue.isSelected())
                {
                    if (svp.getHighlightedVPoint() != null)
                    jMenuItemHere.setEnabled(true);
                }

                if (svp.getHighlightedVPoint() == null)
                    jMenuItemJoin.setEnabled(false);
                
                
                jMenuItemDelete.setEnabled(false);
                // and only
                if (vs.size() == 1)
                {
                    if ((vs.get(0).start_connect != null) &&  (vs.get(0).end_connect != null))
                    jMenuItemDelete.setEnabled(false);
                }
                evt.
                
                jPopupMenuPoint.show(table, evt.evt.getX()-20,evt.evt.getY()-20);
            }
            */
            if (jRadioButtonSelectLine.isSelected())
            {
                ArrayList<GFXVector> vs = svp.getSelectedPointVectors();

//                if (svp.getHighlightedVector() == null)
//                    jMenuItemLineDelete.setEnabled(false);
//                else
                    jMenuItemLineDelete.setEnabled(true);
                
                jMenuItemRemovePoint.setEnabled(svp.getSelectedVectors().size() == 2);
                jPopupMenuLine.show(table, evt.getX()-10,evt.getY()-10);
            }
            return;

        }
        
        
        if (!jRadioButtonSelectPoint.isSelected()) return;

        if (evt.getButton() == MouseEvent.BUTTON1)
        {
            Vertex selected = null;
            GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
            if (row <0) return;
            if (row >= vl.size()) return;
            GFXVector vector = vl.get(row);
            if ((col>=1) && (col <=3)) // start vertex
                selected = vector.start;
            else if ((col>=4) && (col <=6)) // end vertex
                selected = vector.end;
            if (selected == null) return;
            
            if (evt.isShiftDown())
            {
                singleVectorPanel1.addToSelectedVPoint(selected);
            }
            else
            {
                singleVectorPanel1.setToSelectedVPoint(selected);
            }
        }
        if (evt.getButton() == MouseEvent.BUTTON2)
        {
            Vertex selected = null;
            GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
            if (row <0) return;
            if (row >= vl.size()) return;
            GFXVector vector = vl.get(row);
            if ((col>=1) && (col <=3)) // start vertex
                selected = vector.start;
            else if ((col>=4) && (col <=6)) // end vertex
                selected = vector.end;
            if (selected == null) return;
            
            if (evt.isShiftDown())
            {
                singleVectorPanel1.removeToSelectedVPoint(selected);
            }
            singleVectorPanel1.sharedRepaint();
        }
        jTable1.repaint();
    }//GEN-LAST:event_jTable1MousePressed

    String lastImagePath = "";
    private void jButtonLoad2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoad2ActionPerformed

        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setMultiSelectionEnabled(true);
        if (lastImagePath.length()==0)
        {
            lastImagePath=Global.mainPathPrefix+File.separator;
            fc.setCurrentDirectory(new java.io.File(lastImagePath));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastImagePath));
        }
        FileNameExtensionFilter  filter = new  FileNameExtensionFilter("Wavefront", "obj");
        fc.setFileFilter(filter);
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        File[] files = fc.getSelectedFiles();
        String fullPath;
        if ((files == null) || (files.length == 1))
        {
            fullPath = fc.getSelectedFile().getAbsolutePath();
        }
        else // add multiple images
        {
            fullPath = files[0].getAbsolutePath();
        }
        lastImagePath =fullPath;
        
        loadObject(fullPath);
    }//GEN-LAST:event_jButtonLoad2ActionPerformed

    SingleVecciPanel singleVecciPanel = null;
    SingleVecciPanel3d svp3d = null;
    private void jButtonSingleEditorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSingleEditorActionPerformed
        if (singleVecciPanel != null) return;
        singleVecciPanel = SingleVecciPanel.showSingleVecciPanelNoModal(this);
        singleVectorPanel1.addSibbling(singleVecciPanel.getSVP());
        singleVecciPanel.initPart2();
        singleVecciPanel.setSettings(settings);
        singleVecciPanel.getSVP().setGrid(jCheckBoxGrid.isSelected(), de.malban.util.UtilityString.IntX(jTextFieldGridWidth.getText(),1));
    }//GEN-LAST:event_jButtonSingleEditorActionPerformed

    private void jButtonUpActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonUpActionPerformed
        singleVectorPanel1.addYOffset(-singleVectorPanel1.getGridWidth());
//        updateOutput();

    }//GEN-LAST:event_jButtonUpActionPerformed

    private void jButtonDownActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDownActionPerformed
        singleVectorPanel1.addYOffset(singleVectorPanel1.getGridWidth());
//        updateOutput();
    }//GEN-LAST:event_jButtonDownActionPerformed

    private void jButtonLeftActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLeftActionPerformed
        singleVectorPanel1.addXOffset(-singleVectorPanel1.getGridWidth());
//        updateOutput();
    }//GEN-LAST:event_jButtonLeftActionPerformed

    private void jButtonRightActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRightActionPerformed
        singleVectorPanel1.addXOffset(singleVectorPanel1.getGridWidth());
//        updateOutput();
    }//GEN-LAST:event_jButtonRightActionPerformed

    private void jPanelScrollerMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPanelScrollerMouseClicked
        if (evt.getClickCount() == 2)
        {
            singleVectorPanel1.setOffsets(0, 0, 0);
        }
//        updateOutput();
    }//GEN-LAST:event_jPanelScrollerMouseClicked

    
    private void jRadioButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton3ActionPerformed
        settings.db = jRadioButton3.isSelected();
        GFXVectorList.db = settings.db;
    }//GEN-LAST:event_jRadioButton3ActionPerformed

    private void jRadioButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton4ActionPerformed
        settings.db = !jRadioButton4.isSelected();
        GFXVectorList.db = settings.db;
    }//GEN-LAST:event_jRadioButton4ActionPerformed

    private void jRadioButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton5ActionPerformed
        settings.hex = jRadioButton5.isSelected();
        GFXVectorList.hex = settings.hex;

    }//GEN-LAST:event_jRadioButton5ActionPerformed

    private void jRadioButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton6ActionPerformed
        settings.hex = !jRadioButton6.isSelected();
        GFXVectorList.hex = settings.hex;
    }//GEN-LAST:event_jRadioButton6ActionPerformed

    private void jMenuItemSwitchActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemSwitchActionPerformed
        // Switch Vector Orientation


        addHistory();
        GFXVector v = singleVectorPanel1.getHighlightedVector();
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        if (v == null) return;
        if (vl == null) return;
        vl.changeOrientation(v);
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();


    }//GEN-LAST:event_jMenuItemSwitchActionPerformed

    private void jTextFieldNeedSplitActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldNeedSplitActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldNeedSplitActionPerformed

    private void jMenuItemRemovePointActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemRemovePointActionPerformed
        
        ArrayList<GFXVector> vlist = singleVectorPanel1.getSelectedVectors();
        if (vlist.size() != 2) return;
        addHistory();
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();

        vl.joinVectors(vlist);
        
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
        
    }//GEN-LAST:event_jMenuItemRemovePointActionPerformed

    private void jCheckBoxScaleToByteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxScaleToByteActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxScaleToByteActionPerformed

    
    String buildSVG(GFXVectorList vl, int factor)
    {
        StringBuilder svg = new StringBuilder();
        int maxWidth = vl.getXMax() - vl.getXMin()+20;
        int maxHeight = vl.getYMax() - vl.getYMin()+20;

        maxWidth *= factor;
        maxHeight *= factor;
        int xMin = vl.getXMin();
        int yMin = vl.getYMin();
        
        
        int centerX = maxWidth/2;
        int centerY = maxHeight/2;
        
        for (GFXVector v: vl.list)
        {
            int x0 = ((int)v.start.x())*factor+centerX;
            int y0 = ((int)-v.start.y())*factor+centerY;
            int x1 = ((int)v.end.x())*factor+centerX;
            int y1 = ((int)-v.end.y())*factor+centerY;
            
            
            String line = "<line x1=\""+x0+"\" x2=\""+x1+"\" y1=\""+y0+"\" y2=\""+y1+"\" stroke=\"black\" stroke-width=\"5\"/>\n";
            svg.append(line);
        }
        return svg.toString();
    }
    
    private void jButtonLoad3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoad3ActionPerformed
        String name = GetSVGFilenamePanel.showEnterValueDialog();
        name = name+".svg";
        String filename =Global.mainPathPrefix+"xml"+File.separator+"vectorlist";
        name = filename+File.separator+name;
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList().clone();
        
        
        
        int maxWidth = vl.getXMax() - vl.getXMin()+20;
        int maxHeight = vl.getYMax() - vl.getYMin()+20;
        
        int factor = 1;
        if ((maxWidth <500) && (maxHeight <500)) factor = 2;
        if ((maxWidth <200) && (maxHeight <200)) factor = 5;
        if ((maxWidth <100) && (maxHeight <100)) factor = 10;
        if ((maxWidth <50) && (maxHeight <50)) factor = 20;
        if ((maxWidth <40) && (maxHeight <40)) factor = 25;
        if ((maxWidth <20) && (maxHeight <20)) factor = 50;
        if ((maxWidth <10) && (maxHeight <10)) factor = 100;
        try
        {
            String header = "<svg version=\"1.1\"\n";
            header+="baseProfile=\"full\"\n";
            header+="width=\""+(maxWidth*factor)+"\" height=\""+(maxHeight*factor)+"\"\n";
            header+="xmlns=\"http://www.w3.org/2000/svg\">\n";
            String footer = "</svg>";
            StringBuilder svg = new StringBuilder();

            String body = buildSVG(vl, factor);
            
            svg.append(header);

            svg.append("<rect width=\"100%\" height=\"100%\" fill=\"red\" />\n");
            
            svg.append(body);
            svg.append(footer);
            
            
            boolean ok = de.malban.util.UtilityFiles.createTextFile(name, svg.toString());
            if (!ok)
            {
                log.addLog("Create (svg) file '"+name+"' return false", WARN);
            }
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
        }
    }//GEN-LAST:event_jButtonLoad3ActionPerformed

    private void jTextFieldFrontActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldFrontActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldFrontActionPerformed

    private void jCheckBoxGridActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxGridActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxGridActionPerformed

    private void jButtonConnectWherePossible1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonConnectWherePossible1ActionPerformed
        addHistory();
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        listNow.ensureNotMoreThan2Connect();
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonConnectWherePossible1ActionPerformed

    private void jCheckBoxAvoidMoreThan2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxAvoidMoreThan2ActionPerformed
        GFXVectorList.avoidConnectMoreThan2 = jCheckBoxAvoidMoreThan2.isSelected();
        jCheckBoxAvoidMoreThan2.setSelected(GFXVectorList.avoidConnectMoreThan2);
    }//GEN-LAST:event_jCheckBoxAvoidMoreThan2ActionPerformed

    private void jButtonSingleEditor1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSingleEditor1ActionPerformed
        if (svp3d != null) return;
        svp3d = SingleVecciPanel3d.showSingleVecciPanelNoModal(this);
        singleVectorPanel1.addSibbling(svp3d.getSVP());
        svp3d.initPart2();
        svp3d.setSettings(settings);
        svp3d.getSVP().setGrid(jCheckBoxGrid.isSelected(), de.malban.util.UtilityString.IntX(jTextFieldGridWidth.getText(),1));
        return;
    }//GEN-LAST:event_jButtonSingleEditor1ActionPerformed

    private void jButtonJoin1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonJoin1ActionPerformed
        StoryboardPanel.showModPanelNoModal(this);
    }//GEN-LAST:event_jButtonJoin1ActionPerformed

    private void jButtonDisconnectAllActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDisconnectAllActionPerformed
        log.addLog("Disconnect all button pressed!", INFO);
        addHistory();
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        listNow.disconnectAll();
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonDisconnectAllActionPerformed

    private void jButtonRemoveMoveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRemoveMoveActionPerformed
        log.addLog("Remove all button pressed!", INFO);
        addHistory();
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        listNow.removeMoveVectors();
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonRemoveMoveActionPerformed

    private void jButtonLongestPathsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLongestPathsActionPerformed
        log.addLog("Connect longest paths button pressed!", INFO);
        addHistory();
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        listNow.connectLongestPaths();
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonLongestPathsActionPerformed

    private void jButtonOptimizeSizeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOptimizeSizeActionPerformed
        log.addLog("Optimize size button pressed!", INFO);
        addHistory();
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        double factor = listNow.optimizeSize();
        jLabelFactor.setText(""+factor);
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonOptimizeSizeActionPerformed

    private void jButtonRemoveDoubleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRemoveDoubleActionPerformed
         log.addLog("Remove double button pressed!", INFO);
       addHistory();
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        listNow.removeDouble();
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonRemoveDoubleActionPerformed

    private void jButtonRemoveiDoubleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRemoveiDoubleActionPerformed
         log.addLog("Remove idouble button pressed!", INFO);
        addHistory();
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        listNow.removeiDouble();
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonRemoveiDoubleActionPerformed

    private void jButtonLongestPathsplusActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLongestPathsplusActionPerformed
        log.addLog("Connect longest paths++ button pressed!", INFO);
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();

        addHistory();
        listNow.connectLongestPathsPlus(jCheckBoxRespectZero.isSelected());
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonLongestPathsplusActionPerformed

    private void jButtonRemoveDots1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRemoveDots1ActionPerformed
        log.addLog("Remove dots button pressed!", INFO);
        addHistory();
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        
        listNow.removePoints(true);
        singleVectorPanel1.sharedRepaint();
        
        mClassSetting++;
        jTable1.tableChanged(null);
        mClassSetting--;
        setSelectedInTable();
        verifyFaces();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonRemoveDots1ActionPerformed

    private void jButtonLongestPaths1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLongestPaths1ActionPerformed
        // TODO add your handling code here:
        addHistory();
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        listNow.isidroAll();
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonLongestPaths1ActionPerformed

    private void jButtonSelectionRotationActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSelectionRotationActionPerformed
        doSelectionRotation();
    }//GEN-LAST:event_jButtonSelectionRotationActionPerformed

    private void jButtonLoad4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoad4ActionPerformed
        try
        {
            String orgname = GetOBJFilenamePanel.showEnterValueDialog();
            String name = orgname+".obj";
            String filename =Global.mainPathPrefix+"xml"+File.separator+"vectorlist";
            name = filename+File.separator+name;
            GFXVectorList vl = singleVectorPanel1.getForegroundVectorList().clone();

            StringBuilder objText = new StringBuilder();
            objText.append("# Vector data export by Vide\n");
            objText.append("# File named: "+name+"\n\n");
            objText.append("g "+orgname+"\n\n");


            int maxWidth = vl.getXMax() - vl.getXMin()+20;
            int maxHeight = vl.getYMax() - vl.getYMin()+20;
        
            StringBuilder vertice = new StringBuilder();
            StringBuilder lines = new StringBuilder();
            StringBuilder points = new StringBuilder();
            StringBuilder faces = new StringBuilder();
            int vertexNumber = 1;

            HashMap<String, Integer> vertexUIDMap = new HashMap<String, Integer>();
            // locate and remember all vertice
            for (GFXVector v: vl.list)
            {
                double x0 = v.start.x();
                double y0 = v.start.y();
                double z0 = v.start.z();
                double x1 = v.end.x();
                double y1 = v.end.y();
                double z1 = v.end.z();

                String v1 = ""+x0+" "+y0+" "+z0;
                String v2 = ""+x1+" "+y1+" "+z1;
            
                if (vertexUIDMap.get(v1) == null)
                {
                    vertexUIDMap.put(v1, vertexNumber++);
                    vertice.append("v "+v1+"\n");
                }
                if (vertexUIDMap.get(v2) == null)
                {
                    vertexUIDMap.put(v2, vertexNumber++);
                    vertice.append("v "+v2+"\n");
                }
            }
            // mark as used - if used, so faces are not "doubled" by lines/points
            HashMap<Integer, Boolean> vertexUsedInMap = new HashMap<Integer, Boolean>();

            ArrayList<Face>vfaces = vl.buildFacelist();
            for (Face face : vfaces)
            {
                // anything less 3 vertice can not be a face!
                if (face.vertice.size()>2)
                {
                    boolean error = false;
                    String f = "";
                    for (Vertex v: face.vertice)
                    {
                        double x0 = v.x();
                        double y0 = v.y();
                        double z0 = v.z();

                        String v1 = ""+x0+" "+y0+" "+z0;
                        if (vertexUIDMap.get(v1) == null)
                        {
                            error = true;
                        }
                    }
                    if (!error)
                    {
                        for (Vertex v: face.vertice)
                        {
                            double x0 = v.x();
                            double y0 = v.y();
                            double z0 = v.z();

                            String v1 = ""+x0+" "+y0+" "+z0;
                            f +=""+vertexUIDMap.get(v1)+ " ";
                            vertexUsedInMap.put(vertexUIDMap.get(v1), true);
                        }
                        faces.append("f "+f);
                        faces.append("\n");
                    }
                }
            }
            
            // generate lines
            // generate points
            for (GFXVector v: vl.list)
            {
                double x0 = v.start.x();
                double y0 = v.start.y();
                double z0 = v.start.z();
                double x1 = v.end.x();
                double y1 = v.end.y();
                double z1 = v.end.z();

                String v1 = ""+x0+" "+y0+" "+z0;
                String v2 = ""+x1+" "+y1+" "+z1;

                int v1i = vertexUIDMap.get(v1);
                int v2i = vertexUIDMap.get(v2);

                if ((vertexUsedInMap.get(v1i) != null) && (vertexUsedInMap.get(v2i) != null))
                {
                    // already used in face
                    continue;
                }

                if ((x0==x1) && (y0==y1) && (z0==z1))
                {
                    if (vertexUsedInMap.get(v1i) != null) 
                        continue;
                    points.append("p "+v1i+"\n");
                }
                else
                {
                    lines.append("l "+v1i+" "+v2i+"\n");
                }
            }

            objText.append("\n");
            objText.append(vertice);
            objText.append("\n");
            objText.append(points);
            objText.append("\n");
            objText.append(lines);
            objText.append("\n");
            objText.append(faces);


            
            boolean ok = de.malban.util.UtilityFiles.createTextFile(name, objText.toString());
            if (!ok)
            {
                log.addLog("Create (obj) file '"+name+"' return false", WARN);
            }
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
        }
    }//GEN-LAST:event_jButtonLoad4ActionPerformed

    private void jButtonJoin2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonJoin2ActionPerformed
        StoryboardPanelNew.showModPanelNoModal(this);
    }//GEN-LAST:event_jButtonJoin2ActionPerformed

    private void jCheckBoxPCStyleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxPCStyleActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxPCStyleActionPerformed

    private void jButtonDraw_3dActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_3dActionPerformed
        try3dOut(((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK)));
    }//GEN-LAST:event_jButtonDraw_3dActionPerformed

    private void jTextField3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField3ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField3ActionPerformed

    private void jCheckBoxRunnable2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxRunnable2ActionPerformed
        checkAssemblerButtonSM();
    }//GEN-LAST:event_jCheckBoxRunnable2ActionPerformed

    private void jButtonAssembleSMActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssembleSMActionPerformed
        String filename = Global.mainPathPrefix+"tmp"+File.separator+"veccytmp.asm";
        de.malban.util.UtilityFiles.createTextFile(filename, jTextAreaResultSM.getText());
        startASM(filename);
    }//GEN-LAST:event_jButtonAssembleSMActionPerformed

    private void jButtonEditInVedi2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEditInVedi2ActionPerformed
        CSAMainFrame frame = (CSAMainFrame)Configuration.getConfiguration().getMainFrame();
        VediPanel p = new VediPanel(false);        
        p.setTreeVisible(false);
        
        frame.addAsWindow(p, 1024, 768, VediPanel.SID);
        
        String tmpFile = Global.mainPathPrefix+"tmp"+File.separator+"veccyAsm.asm";
        de.malban.util.UtilityFiles.createTextFile(tmpFile, jTextAreaResultSM.getText());
        p.addTempEditFile(tmpFile);
    }//GEN-LAST:event_jButtonEditInVedi2ActionPerformed

    private void jButtonBuildSmartListActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonBuildSmartListActionPerformed
        getParameters();
        buildSmartlist();

    }//GEN-LAST:event_jButtonBuildSmartListActionPerformed

    private void jButtonBuildSmartList1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonBuildSmartList1ActionPerformed
        getParameters();
        buildSmartAnimlist();
    }//GEN-LAST:event_jButtonBuildSmartList1ActionPerformed

    private void jButton8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton8ActionPerformed
        int newX = de.malban.util.UtilityString.Int0(jTextField5.getText());
        int newY = de.malban.util.UtilityString.Int0(jTextField4.getText());
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        
        if (vl.list.size()>0)
        {
            GFXVector v = vl.get(0);
            v.start.y(newY);
            v.start.x(newX);
        }
        
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButton8ActionPerformed

    private void jButton9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton9ActionPerformed

        int newX = de.malban.util.UtilityString.Int0(jTextField5.getText());
        int newY = de.malban.util.UtilityString.Int0(jTextField4.getText());
        
        for (GFXVectorList vl : currentAnimation.list)
        {
            if (vl.list.size()>0)
            {
                GFXVector v = vl.get(0);
                v.start.y(newY);
                v.start.x(newX);
            }
        }
        
        redrawAnimation();
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();

    }//GEN-LAST:event_jButton9ActionPerformed

    private void jButtonBuildSmartList2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonBuildSmartList2ActionPerformed
        getParameters();
        buildSmartScenarioList();
    }//GEN-LAST:event_jButtonBuildSmartList2ActionPerformed

    private void jButton10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton10ActionPerformed
        addHistory();
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        vl.intAll();
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        verifyFaces();
        fillStatus();
    }//GEN-LAST:event_jButton10ActionPerformed

    private void jButtonSetSolidActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSetSolidActionPerformed
        addHistory();
        ArrayList<GFXVector> list = singleVectorPanel1.getSelectedVectors();
        for (GFXVector v : list)
        {
            v.pattern = 255;
        }
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonSetSolidActionPerformed

    private void jButtonSetMoveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSetMoveActionPerformed
        addHistory();
        ArrayList<GFXVector> list = singleVectorPanel1.getSelectedVectors();
        for (GFXVector v : list)
        {
            v.pattern = 0;
        }
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();
    }//GEN-LAST:event_jButtonSetMoveActionPerformed

    private void jCheckBoxAlwaysIntActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxAlwaysIntActionPerformed
        // TODO add your handling code here:
        singleVectorPanel1.getSharedVars().allwaysInt = jCheckBoxAlwaysInt.isSelected();
    }//GEN-LAST:event_jCheckBoxAlwaysIntActionPerformed

    private void jMenuItemMoveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemMoveActionPerformed
        // doesn't matter which panel
        addHistory();
        ArrayList<GFXVector> vs = singleVectorPanel1.getSelectedPointVectors();
        Vertex moveHere = singleVectorPanel1.getHighlightedVPoint();

        for (int i=0; i<vs.size(); i++)
        {
            GFXVector v = vs.get(i);
            if (v.end.selected)
            {
                v.end.x(moveHere.x());
                v.end.y(moveHere.y());
            }
            if (v.start.selected)
            {
                v.start.x(moveHere.x());
                v.start.y(moveHere.y());
            }
        }
        
        

        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();        
        
    }//GEN-LAST:event_jMenuItemMoveActionPerformed

    private void jTextField11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField11ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField11ActionPerformed

    int inSwitch = 0;
    private void jCheckBox11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox11ActionPerformed
        if (inSwitch>0) return;
        inSwitch++;
        jCheckBoxCompileForVB.setSelected(!jCheckBox11.isSelected());
        jCheckBox13.setEnabled(jCheckBoxCompileForVB.isSelected());
        jTextField12.setEnabled(jCheckBoxCompileForVB.isSelected());
        inSwitch--;
    }//GEN-LAST:event_jCheckBox11ActionPerformed

    private void jCheckBoxCompileForVBActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxCompileForVBActionPerformed
        if (inSwitch>0) return;
        inSwitch++;
        jCheckBox11.setSelected(!jCheckBoxCompileForVB.isSelected());
        jCheckBox13.setEnabled(jCheckBoxCompileForVB.isSelected());
        jTextField12.setEnabled(jCheckBoxCompileForVB.isSelected());
        inSwitch--;
    }//GEN-LAST:event_jCheckBoxCompileForVBActionPerformed
    String lastDir =Global.mainPathPrefix;

    private void jButtonFileSelect2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect2ActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
//        fc.setCurrentDirectory(new java.io.File(Global.mainPathPrefix));
        fc.setCurrentDirectory(new java.io.File(lastDir));
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String name = fc.getSelectedFile().getAbsolutePath();
        jTextFieldstart1.setText(name);
        lastDir = fc.getCurrentDirectory().toString();
    }//GEN-LAST:event_jButtonFileSelect2ActionPerformed

    private void jButtonFileSelect3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect3ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jButtonFileSelect3ActionPerformed

    private void jCheckBox16ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox16ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox16ActionPerformed

    private void jTextField12ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField12ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField12ActionPerformed

    private void jButtonDraw_absolutActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_absolutActionPerformed

        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname.getText();
        if (name.trim().length() == 0) name = "VectorList";
        boolean s = jCheckBoxAbsolutStart.isSelected();
        boolean e = jCheckBoxAbsolutEnd.isSelected();

        String text;
        if (jCheckBoxCStyle.isSelected())
        {
            text = vl.createAbsolutListC(name, jCheckBoxAddFactor.isSelected(), jCheckBox16.isSelected(), jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }
            jTextAreaResult.setText(text);
            copy(text);
        }
        else
        {
        text = vl.createAbsolutList(name, s,e);
            
        }
        
        jTextAreaResult.setText(text);
        copy(text);
    }//GEN-LAST:event_jButtonDraw_absolutActionPerformed

    private void jButton11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton11ActionPerformed
        String text = jTextArea1.getText();
        text = de.malban.util.UtilityString.replaceWhiteSpaces(text, "");
        text = de.malban.util.UtilityString.replace(text, "\"", "");
        char[] letters = text.toCharArray();
        StringBuffer out = new StringBuffer();
        int i=0;
        int formatCount =0;
        
        ArrayList<Integer> readVals = new ArrayList<Integer>();
        
        while (i<letters.length)
        {
            int val = 0;
            if (letters[i]<='9') val = val+letters[i]-'0';
            else if (letters[i]<='Z') val = val+letters[i]-'A'+10;
            else if (letters[i]<='z') val = val+letters[i]-'a'+10;
            i++;
            if ((i>=letters.length))
            {
                out = out.append("\nERROR, length not even!");
                break;
            }
            val*=16;
            if (letters[i]<='9') val = val+letters[i]-'0';
            else if (letters[i]<='Z') val = val+letters[i]-'A'+10;
            else if (letters[i]<='z') val = val+letters[i]-'a'+10;
            i++;
            readVals.add(val);
        }
        i=0;
        
        int numLists = readVals.get(i++);
	int curList = 0;
	int numVertices;
	int curVertex;
        int lineCount = 0;
        
	while (curList < numLists)
	{
            out = out.append("; list\n");
            numVertices = readVals.get(i++);
            curVertex = 0;
            while (curVertex < (numVertices - 1) )
            {
                int x0 = readVals.get(i)-128;
                int y0 = readVals.get(i+1)-128;
                int x1 = readVals.get(i+2)-128;
                int y1 = readVals.get(i+3)-128;
                i += 2;
                ++curVertex;
                lineCount++;
                out = out.append("$"+String.format("%02X ",x0&0xff));
                out = out.append("$"+String.format("%02X ",(-y0)&0xff));
                out = out.append("$"+String.format("%02X ",x1&0xff));
                out = out.append("$"+String.format("%02X ",(-y1)&0xff));
                out = out.append("; x0, y0, x1, y1\n");
            }
            ++curList;
            i += 2;
	}
        jTextArea1.setText("$"+String.format("%02X ; linecount\n",lineCount) + out.toString());
        doInterpret();
        fillStatus();
    }//GEN-LAST:event_jButton11ActionPerformed

    private void jButton12ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton12ActionPerformed
        // This class is a port of Daggorath's custom RNG
        class RNG
        {
            byte[] SEED = new byte[3];
            int carry;
            RNG()
            {
                    carry = 0;
                    SEED[0] = 0;
                    SEED[1] = 0;
                    SEED[2] = 0;
            }

            // Accessors
            byte RANDOM()
            {
                    int x, y;
                    byte a, b;
                    carry = 0;
                    for (x = 8; x != 0; --x)
                    {
                            b = 0;
                            a = (byte) (SEED[2] & 0xE1);
                            for (y = 8; y != 0; --y)
                            {
                                    a = lsl(a);
                                    if (carry != 0)
                                            ++b;
                            }
                            b = lsr(b);
                            SEED[0] = rol(SEED[0]);
                            SEED[1] = rol(SEED[1]);
                            SEED[2] = rol(SEED[2]);
                    }
                    return SEED[0];
            }

            byte getSEED(int idx)
            {
                    return SEED[idx];
            }

            // Mutators
            void setSEED(int idx, byte val)
            {
                    SEED[idx] = val;
            }

            void setSEED(byte val0, byte val1, byte val2)
            {
                    SEED[0] = val0;
                    SEED[1] = val1;
                    SEED[2] = val2;
            }


            // Internal Implementation
            byte lsl(byte c)
            {
                    carry = (((c & 128) == 128) ? 1 : 0);
                    return (byte )(c << 1);
            }

            byte lsr(byte c)
            {
                    carry = (((c & 1) == 1) ? 1 : 0);
                    return (byte) (c >> 1);
            }

            byte rol(byte c)
            {
                    int cry;
                    cry = (((c & 128) == 128) ? 1 : 0);
                    c <<= 1;
                    c += carry;
                    carry = cry;
                    return c;
            }
        };
        
	// Constants
        char N_WALL=0x03;
        char E_WALL=0x0c;
        char S_WALL=0x30;
        char W_WALL=0xc0;
        char HF_PAS=0;
        char HF_DOR=1;
        char HF_SDR=2;
        char HF_WAL=3;

        char VF_HOLE_UP=0;
        char VF_LADDER_UP=1;
        char VF_HOLE_DOWN=2;
        char VF_LADDER_DOWN=3;
        char VF_NULL=255;


        char[] MSKTAB = new char[4];
	MSKTAB[0] = 0x03;
	MSKTAB[1] = 0x0C;
	MSKTAB[2] = 0x30;
	MSKTAB[3] = 0xC0;
        
        char[] LEVTAB = new char[7];
	LEVTAB[0] = 0x73;
	LEVTAB[1] = 0xC7;
	LEVTAB[2] = 0x5D;
	LEVTAB[3] = 0x97;
	LEVTAB[4] = 0xF3;
	LEVTAB[5] = 0x13;
	LEVTAB[6] = 0x87;
        
        int[] VFTTAB = new int[42];
	VFTTAB[0] = -1;
	VFTTAB[1] = 1;
	VFTTAB[2] = 0;
	VFTTAB[3] = 23;
	VFTTAB[4] = 0;
	VFTTAB[5] = 15;
	VFTTAB[6] = 4;
	VFTTAB[7] = 0;
	VFTTAB[8] = 20;
	VFTTAB[9] = 17;
	VFTTAB[10] = 1;
	VFTTAB[11] = 28;
	VFTTAB[12] = 30;
	VFTTAB[13] = -1;
	VFTTAB[14] = 1;
	VFTTAB[15] = 2;
	VFTTAB[16] = 3;
	VFTTAB[17] = 0;
	VFTTAB[18] = 3;
	VFTTAB[19] = 31;
	VFTTAB[20] = 0;
	VFTTAB[21] = 19;
	VFTTAB[22] = 20;
	VFTTAB[23] = 0;
	VFTTAB[24] = 31;
	VFTTAB[25] = 0;
	VFTTAB[26] = -1;
	VFTTAB[27] = -1;
	VFTTAB[28] = 0;
	VFTTAB[29] = 0;
	VFTTAB[30] = 31;
	VFTTAB[31] = 0;
	VFTTAB[32] = 5;
	VFTTAB[33] = 0;
	VFTTAB[34] = 0;
	VFTTAB[35] = 22;
	VFTTAB[36] = 28;
	VFTTAB[37] = 0;
	VFTTAB[38] = 31;
	VFTTAB[39] = 16;
	VFTTAB[40] = -1;
	VFTTAB[41] = -1;
        
        int[] STPTAB = new int[8];
	STPTAB[0] = -1;
	STPTAB[1] = 0;
	STPTAB[2] = 0;
	STPTAB[3] = 1;
	STPTAB[4] = 1;
	STPTAB[5] = 0;
	STPTAB[6] = 0;
	STPTAB[7] = -1;

        char[] NEIBOR = new char[9];		// The cells around the player
        
        int level=0;
        RNG rng = new RNG();
        rng.setSEED((byte)LEVTAB[level], (byte)LEVTAB[level+1], (byte)LEVTAB[level+2]);

        
        char[] MAZLND = new char[1024];
        
	/* Locals */
	int		mzctr;
	int		maz_idx;
	int		cell_ctr;
	byte	a_row;
	byte	a_col;
	byte	b_row;
	byte	b_col;
	byte	DIR;
	byte	DST;
	int	DROW;
	int	ROW;
        char val;
        
	char[] DORTAB = new char[4];
	DORTAB[0] = (char)HF_DOR;
	DORTAB[1] = (char)(HF_DOR << 2);
	DORTAB[2] = (char)(HF_DOR << 4);
	DORTAB[3] = (char)(HF_DOR << 6);

	char[] SDRTAB = new char[4];
	SDRTAB[0] = (char) HF_SDR;
	SDRTAB[1] = (char)(HF_SDR << 2);
	SDRTAB[2] = (char)(HF_SDR << 4);
	SDRTAB[3] = (char)(HF_SDR << 6);
        
        
	/* Phase 1: Create Maze */

	/* Set Cells to 0xFF */
	for (mzctr=0; mzctr<1024; ++mzctr)
	{
		MAZLND[mzctr] = 0xff;
	}
	cell_ctr = 500;  // Room Counter

	/* Set Starting Room */
        a_col = (byte) (rng.RANDOM() & 31);
        a_row = (byte) (rng.RANDOM() & 31);
        DROW = (int) ((a_row<<5) + a_col);

//        RndDstDir(&DIR, &DST);
	DIR = (byte) (rng.RANDOM() & 3);
	DST = (byte) ((rng.RANDOM() & 7) + 1);


	while (cell_ctr > 0)
	{
            /* Take a step */
            b_row = (byte)((DROW & 0x3e0)>>5);
            b_col = (byte)(DROW & 0x1f);
            
            b_row += STPTAB[DIR * 2];
            b_col += STPTAB[(DIR * 2) + 1];

            /* Check if it's out of bounds */
            if (BORDER(b_row, b_col) == false)
            {
        //        RndDstDir(&DIR, &DST);
                DIR = (byte) (rng.RANDOM() & 3);
                DST = (byte) ((rng.RANDOM() & 7) + 1);
                continue;
            }

            /* Store index and temp room */
            maz_idx = RC2IDX(b_row, b_col);
            ROW = (int) ((b_row<<5) + b_col);

            /* If not yet touched */
            if (MAZLND[maz_idx] == 0xFF)
            {
//                    FRIEND(ROW);
                    
                    // Finds surrounding cells
                    //void Dungeon::FRIEND(RowCol RC)
                    {
                        int r3, c3;
                        int u = 0;

                        for (r3 = (int)((ROW&0x3e0)>>5); r3 <= ((int)((ROW&0x3e0)>>5)+2); ++r3)
                        {
                            for (c3 = (int)((ROW&0x01f)); c3 <= ((int)((ROW&0x01f))+2); ++c3)
                            {
                                if (BORDER((r3-1), (c3-1)) == false)
                                {
                                    NEIBOR[u] = 0xFF;
                                }
                                else
                                {
                                    NEIBOR[u] = MAZLND[RC2IDX((r3-1), (c3-1))];
                                }
                                ++u;
                            }
                        }
                    }
                    
                    if (NEIBOR[3] + NEIBOR[0] + NEIBOR[1] == 0 ||
                            NEIBOR[1] + NEIBOR[2] + NEIBOR[5] == 0 ||
                            NEIBOR[5] + NEIBOR[8] + NEIBOR[7] == 0 ||
                            NEIBOR[7] + NEIBOR[6] + NEIBOR[3] == 0)
                    {
                //        RndDstDir(&DIR, &DST);
                        DIR = (byte) (rng.RANDOM() & 3);
                        DST = (byte) ((rng.RANDOM() & 7) + 1);
                        continue;
                    }
                    MAZLND[maz_idx] = 0;
                    --cell_ctr;
            }
            if (cell_ctr > 0)
            {
                DROW = ROW;
                --DST;
                if (DST == 0)
                {
                //        RndDstDir(&DIR, &DST);
                        DIR = (byte) (rng.RANDOM() & 3);
                        DST = (byte) ((rng.RANDOM() & 7) + 1);
                        continue;
                }
                else
                {
                        continue;
                }
            }
	}

	/* Phase 2: Create Walls */

	for (int r=0; r<32;r++)
	{
            for (int c=0; c<32;c++)
            {
                DROW = (int)((r<<5)+c);
                maz_idx = DROW;

                if (MAZLND[maz_idx] != 0xFF)
                {
                    //FRIEND(DROW);
                    // Finds surrounding cells
                    //void Dungeon::FRIEND(RowCol RC)
                    {
                        int r3, c3;
                        int u = 0;

                        for (r3 = (int)((DROW&0x3e0)>>5); r3 <= ((int)((DROW&0x3e0)>>5)+2); ++r3)
                        {
                            for (c3 = (int)((DROW&0x01f)); c3 <= ((int)((DROW&0x01f))+2); ++c3)
                            {
                                if (BORDER((r3-1), (c3-1)) == false)
                                {
                                    NEIBOR[u] = 0xFF;
                                }
                                else
                                {
                                    NEIBOR[u] = MAZLND[RC2IDX((r3-1), (c3-1))];
                                }
                                ++u;
                            }
                        }
                    }

                    if (NEIBOR[1] == 0xFF)
                            MAZLND[maz_idx] |= N_WALL;
                    if (NEIBOR[3] == 0xFF)
                            MAZLND[maz_idx] |= W_WALL;
                    if (NEIBOR[5] == 0xFF)
                            MAZLND[maz_idx] |= E_WALL;
                    if (NEIBOR[7] == 0xFF)
                            MAZLND[maz_idx] |= S_WALL;
                }
            }
	}

	/* Phase 3: Create Doors/Secret Doors */
	for (mzctr = 0; mzctr < 70; ++mzctr)
	{
//          MAKDOR(this->DORTAB);
            //void Dungeon::MAKDOR(dodBYTE * table)
            {
                do
                {
                    do
                    {
                        a_col = (byte)(rng.RANDOM() & 31);
                        a_row = (byte)(rng.RANDOM() & 31);
                        ROW = (int) (((a_row&0x1f)<<5) +(a_col&0x1f));
                        //ROW.setRC(a_row, a_col);
                        maz_idx = RC2IDX(a_row, a_col);
                        val = MAZLND[maz_idx];
                    } while (val == 0xFF);

                    DIR =(byte) (rng.RANDOM() & 3);
                } while ((val & MSKTAB[DIR]) != 0);

                MAZLND[maz_idx] |= DORTAB[DIR];

//                ROW.row += STPTAB[DIR * 2];
//                ROW.col += STPTAB[(DIR * 2) + 1];
                int h1 = ((ROW&0x3e0)>>5)+ STPTAB[DIR * 2];
                int h2 = ((ROW&0x1f))+ STPTAB[(DIR * 2) + 1];

                ROW = (int) ((h1<<5)+h2);
                DIR += 2;
                DIR &= 3;
//                maz_idx = RC2IDX(ROW.row, ROW.col);
                maz_idx = ROW;
                MAZLND[maz_idx] |= DORTAB[DIR];
            }
            
            
            
	}

	for (mzctr = 0; mzctr < 45; ++mzctr)
	{
//            MAKDOR(this->SDRTAB);
            {
                do
                {
                    do
                    {
                        a_col = (byte)(rng.RANDOM() & 31);
                        a_row = (byte)(rng.RANDOM() & 31);
                        ROW = (int) (((a_row&0x1f)<<5) +(a_col&0x1f));
                        //ROW.setRC(a_row, a_col);
                        maz_idx = RC2IDX(a_row, a_col);
                        val = MAZLND[maz_idx];
                    } while (val == 0xFF);

                    DIR =(byte) (rng.RANDOM() & 3);
                } while ((val & MSKTAB[DIR]) != 0);

                MAZLND[maz_idx] |= SDRTAB[DIR];

//                ROW.row += STPTAB[DIR * 2];
//                ROW.col += STPTAB[(DIR * 2) + 1];


                int h1 = ((ROW&0x3e0)>>5)+ STPTAB[DIR * 2];
                int h2 = ((ROW&0x1f))+ STPTAB[(DIR * 2) + 1];
                ROW = (int) ((h1<<5)+h2);
                DIR += 2;
                DIR &= 3;
//                maz_idx = RC2IDX(ROW.row, ROW.col);
                maz_idx = ROW;
                MAZLND[maz_idx] |= SDRTAB[DIR];
            }
	}
        char[] NS = new char[4];
	NS[3]='-';
	NS[2]='=';
	NS[1]='-';
	NS[0]=' ';
        
        char[] EW = new char[4];
	EW[3]='|';
	EW[2]=')';
	EW[1]='|';
	EW[0]=' ';

// Prints a text drawing of the maze
//void Dungeon::printMaze()
	int idx, row, x;
	byte n, e, s, w;
	for (idx=0; idx<1024; idx+=32)
	{
            for (x = 0; x < 3; ++x)
            {
                for (row = 0; row < 32; ++row)
                {
                    val = MAZLND[idx+row];
                    n = (byte)((val & 0x03));
                    e = (byte)((val & 0x0C) >> 2);
                    s = (byte)((val & 0x30) >> 4);
                    w = (byte)((val & 0xC0) >> 6);
                    switch (x)
                    {
                    case 0:
                            System.out.print("·" + NS[n]);
                            if (row >= 31)
                            {
                                System.out.print("·");
                            }
                            break;
                    case 1:
                            System.out.print(EW[w]);
                            if (val == 0xFF)
                                System.out.print("#");
                            else
                                System.out.print(" ");
                            if (row >= 31)
                            {
                                System.out.print(EW[e]);
                            }
                            break;
                    case 2:
                            if (idx >= 992)
                            {
                                    System.out.print("·" + NS[s]);
                                    if (row >= 31)
                                    {
                                        System.out.print("·");
                                    }
                            }
                    }
                }
                if (x < 2)
                {
                    System.out.print("\n");
                }
            }
	}

        StringBuffer b=new StringBuffer();
        b.append("const unsigned char const level_"+level+"[1024] = \n{");
        
	for (mzctr=0; mzctr<1024; ++mzctr)
	{
            if ((mzctr & 0x1f) == 0) 
                if (mzctr==0)
                    b.append("\n     ");
                else
                    b.append(",\n     ");
            else
                b.append(", ");
            b.append("0x"+String.format("%02X",(int)MAZLND[mzctr]));
	}
        b.append("\n};\n");
        jTextArea1.setText(b.toString());
        
        

    }//GEN-LAST:event_jButton12ActionPerformed
// Adds doors

boolean BORDER(int R, int C)
{
    if ((R & 224) != 0) return false;
    if ((C & 224) != 0) return false;
    return true;
};
boolean BORDER(byte R, byte C)
{
    if ((R & 224) != 0) return false;
    if ((C & 224) != 0) return false;
    return true;
};
 int RC2IDX(byte R, byte C)
{
    R &= 31;
    C &= 31;
    return (R * 32 + C);
}
int RC2IDX(int R, int C)
{
    R &= 31;
    C &= 31;
    return (R * 32 + C);
}

  
    
    void checkAssemblerButtonSM()
    {
        boolean enabled = jTextAreaResultSM.getText().contains("; HEADER SECTION");
        jButtonAssembleSM.setEnabled(enabled);
        jButtonEditInVedi2.setEnabled((jTextAreaResultSM.getText().length() > 0));
    }

    void closeSingleVecciPanel()
    {
        if (singleVecciPanel != null)
        {
            singleVectorPanel1.removeSibbling(singleVecciPanel.getSVP());

            settings.singleVecciScaleSlider = singleVecciPanel.getScaleSlider();
            
            settings.singleVecciX = singleVecciPanel.xpos;
            settings.singleVecciY = singleVecciPanel.ypos;
            settings.singleVecciW = singleVecciPanel.w;
            settings.singleVecciH = singleVecciPanel.h;
        }
        singleVecciPanel = null;
    }
    void closeSingle3dVecciPanel()
    {
        if (svp3d != null)
        {
            singleVectorPanel1.removeSibbling(svp3d.getSVP());

            settings.singleVecciScaleSlider = svp3d.getScaleSlider();
            
            settings.singleVecciX = svp3d.xpos;
            settings.singleVecciY = svp3d.ypos;
            settings.singleVecciW = svp3d.w;
            settings.singleVecciH = svp3d.h;
        }
        svp3d = null;
    }

    // interface function for communication of events with singleVectorPanel
    public void pressed(EditMouseEvent evt)
    {
        historyAdded = false;
        SingleVectorPanel svp = (SingleVectorPanel)evt.panel;
        //Vertex p = svp.getLastClickPoint();
        Vertex p = evt.lastClickedVectrexPoint;

        if (evt.evt.getButton() == MouseEvent.BUTTON1)
        {
            if (jRadioButtonSetPoint.isSelected())
            {
                if (!jCheckBoxContinue.isSelected()) 
                {
                    buildingVector.start=new Vertex(p);
                    buildingVector.end=new Vertex(p);
                }
                else
                {
                    if (!continueStarted)
                    {
                        buildingVector.start=new Vertex(p);
                    }
                }
                jTextFieldStartX.setText(""+((int)p.x()));
                jTextFieldStartY.setText(""+((int)p.y()));
                jTextFieldStartZ.setText(""+((int)p.z()));
            }
            else if (jRadioButtonSelectPoint.isSelected())
            {
                if (evt.shiftPressed)
                {
                    svp.addHighlightedToSelectedVPoint();
                }
                else
                {
                    svp.setHighlightedToSelectedVPoint();
                }
                setSelectedInTable();
            }        
            else if (jRadioButtonSelectLine.isSelected())
            {
                if (evt.shiftPressed)
                {
                    svp.addHighlightedToSelectedVector();
                }
                else
                {
                    svp.setHighlightedToSelectedVector();
                }
                setSelectedInTable();
            }        
        }
        
        if (evt.evt.getButton() == MouseEvent.BUTTON2)
        {
            if (!evt.shiftPressed)
            {   
                cycleMode();
            }
            else
            {
                if (jRadioButtonSelectPoint.isSelected())
                {
                    svp.removeHighlightedToSelectedVPoint();
                    setSelectedInTable();
                }        
                else if (jRadioButtonSelectLine.isSelected())
                {
                    svp.removeHighlightedToSelectedVector();
                    setSelectedInTable();
                }        
            }
        }
        
        
        if (evt.evt.getButton() == MouseEvent.BUTTON3)
        {
            jMenuItemPoint0.setEnabled(svp.getHighlightedVPoint() != null);
            if (jRadioButtonSelectPoint.isSelected())
            {
                ArrayList<GFXVector> vs = svp.getSelectedPointVectors();
                jMenuItemConnect.setEnabled(vs.size() == 2);
                jMenuItemJoin.setEnabled(vs.size() >= 2);
                jMenuItemRip.setEnabled(vs.size() >= 2); // but with the same point :-)
                
                jMenuItemHere.setEnabled(false);
                if (jCheckBoxContinue.isSelected())
                {
                    if (svp.getHighlightedVPoint() != null)
                    jMenuItemHere.setEnabled(true);
                }

                if (svp.getHighlightedVPoint() == null)
                    jMenuItemJoin.setEnabled(false);
                
                
                jMenuItemDelete.setEnabled(false);
                // and only
                if (vs.size() == 1)
                {
                    if ((vs.get(0).start_connect != null) &&  (vs.get(0).end_connect != null))
                    jMenuItemDelete.setEnabled(false);
                }
                jPopupMenuPoint.show(svp, evt.evt.getX()-20,evt.evt.getY()-20);
            }
            if (jRadioButtonSelectLine.isSelected())
            {
                ArrayList<GFXVector> vs = svp.getSelectedPointVectors();

                if (svp.getHighlightedVector() == null)
                    jMenuItemLineDelete.setEnabled(false);
                else
                    jMenuItemLineDelete.setEnabled(true);
                
                jMenuItemRemovePoint.setEnabled(svp.getSelectedVectors().size() == 2);
                jPopupMenuLine.show(svp, evt.evt.getX()-10,evt.evt.getY()-10);
            }
        }
    }

    // interface function for communication of events with singleVectorPanel
    public void released(EditMouseEvent evt)
    {
        if (evt.evt.getButton() == MouseEvent.BUTTON2)
        {
            return;
        }
        SingleVectorPanel svp = (SingleVectorPanel)evt.panel;
        if (svp.is3d())
        {
            return;
        }
        
        // only add a point, when in setting mode!
        if (jRadioButtonSetPoint.isSelected())
        {
            if (!pointsOk)
            {
                if (buildingVector.start.equals(buildingVector.end)) return;
            }

            // here, for BUILDING
            // the vectors, we assume start and end have
            // semantical meaning
            // and links the old always to start of the new
            // and the new always to end of old!
            // but this is a convention we only here can assume!
            addHistory();
            
            addVector(buildingVector);
            GFXVector old  = buildingVector;
            buildingVector= new GFXVector();
            checkVectorStyles(buildingVector);
            buildingVector.setRelativ(false);
            
            if (jCheckBoxContinue.isSelected())
            {
                buildingVector.setRelativ(true);
                buildingVector.start_connect = old;
                buildingVector.uid_start_connect = old.uid;
                old.end_connect = buildingVector;
                old.uid_end_connect = buildingVector.uid;
                
                buildingVector.start = old.end;
                singleVectorPanel1.continueVector(old);
                continueStarted = true;
            }
            else
            {
                buildingVector.start=new Vertex(old.end);
                if (buildingVector.start_connect != null)
                {
                    buildingVector.start_connect.uid_end_connect = -1;
                    buildingVector.start_connect.end_connect = null;
                }
            }
            if (jCheckBoxAutoApply.isSelected()) applyChanges();
            jTable1.tableChanged(null);
            fillStatus();
        }
    }
    // interface function for communication of events with singleVectorPanel
    public void moved(EditMouseEvent evt)
    {
        if ((evt.dragging) && (evt.ctrlPressed)) return;
        SingleVectorPanel svp = (SingleVectorPanel)evt.panel;
        
        Vertex p = evt.currentVectrexPoint;
        
//        Vertex p = svp.getCurrentPoint();
//        p = svp.convertToVectrex(p);
        jTextFieldCurrentX.setText(""+((int)p.x()));
        jTextFieldCurrentY.setText(""+((int)p.y()));
        jTextFieldCurrentZ.setText(""+((int)p.z()));
        if (evt.dragging)
        {
            if ((jRadioButtonSelectPoint.isSelected()) && (!svp.isSelecting()))
            {
                if (svp == null) return;
                if (!historyAdded)
                    addHistory();
                historyAdded = true;

                // new drag all selected
                int axis1 = svp.getHorizontalAxis();
                int axis2 = svp.getVerticalAxis();
                // base for delta is current highlighted point
                Vertex sv = svp.getHighlightedVPoint();
                Vertex t = evt.translocationInVectrexPoint;

                ArrayList<GFXVector> toTranslocate = svp.getSelectedPointVectors();
                HashMap<Vertex, Vertex> alreadyDone = new HashMap<Vertex, Vertex>();
                for (GFXVector v: toTranslocate)
                {
                    Vertex start = v.start;
                    if (start.selected)
                    {
                        if (alreadyDone.get(start) == null) 
                        {
                            alreadyDone.put(start, start);
                            if (svp.is3d())
                            {
                                start.coord()[ARRAY_X] -= t.coord()[ARRAY_X];
                                start.coord()[ARRAY_Y] -= t.coord()[ARRAY_Y];
                                start.coord()[ARRAY_Z] -= t.coord()[ARRAY_Z];

                                if (svp.isGrid())
                                {
                                    if (start.coord()[ARRAY_X]>0)
                                        start.coord()[ARRAY_X] = (int) ((int) ( ((double)start.coord()[ARRAY_X])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                    else
                                        start.coord()[ARRAY_X] = (int) ((int) ( ((double)start.coord()[ARRAY_X])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));
                                    
                                    if (start.coord()[ARRAY_Y]>0)
                                        start.coord()[ARRAY_Y] = (int) ((int) ( ((double)start.coord()[ARRAY_Y])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                    else
                                        start.coord()[ARRAY_Y] = (int) ((int) ( ((double)start.coord()[ARRAY_Y])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));

                                    if (start.coord()[ARRAY_Z]>0)
                                        start.coord()[ARRAY_Z] = (int) ((int) ( ((double)start.coord()[ARRAY_Z])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                    else
                                        start.coord()[ARRAY_Z] = (int) ((int) ( ((double)start.coord()[ARRAY_Z])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));
                                }
                                
                                
                                
                            }
                            else
                            {
                                start.coord()[axis1] -= t.coord()[axis1];
                                start.coord()[axis2] -= t.coord()[axis2];
                            }
                        }
                    }
                    Vertex end = v.end;
                    if (end.selected)
                    {
                        if (alreadyDone.get(end) == null) 
                        {
                            alreadyDone.put(end, end);
                            if (svp.is3d())
                            {
                                end.coord()[ARRAY_X] -= t.coord()[ARRAY_X];
                                end.coord()[ARRAY_Y] -= t.coord()[ARRAY_Y];
                                end.coord()[ARRAY_Z] -= t.coord()[ARRAY_Z];
                                if (svp.isGrid())
                                {
                                    if (end.coord()[ARRAY_X]>0)
                                        end.coord()[ARRAY_X] = (int) ((int) ( ((double)end.coord()[ARRAY_X])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                    else
                                        end.coord()[ARRAY_X] = (int) ((int) ( ((double)end.coord()[ARRAY_X])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));
                                    
                                    if (end.coord()[ARRAY_Y]>0)
                                        end.coord()[ARRAY_Y] = (int) ((int) ( ((double)end.coord()[ARRAY_Y])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                    else
                                        end.coord()[ARRAY_Y] = (int) ((int) ( ((double)end.coord()[ARRAY_Y])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));

                                    if (end.coord()[ARRAY_Z]>0)
                                        end.coord()[ARRAY_Z] = (int) ((int) ( ((double)end.coord()[ARRAY_Z])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                    else
                                        end.coord()[ARRAY_Z] = (int) ((int) ( ((double)end.coord()[ARRAY_Z])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));
                                }
                            }
                            else
                            {
                                end.coord()[axis1] -= t.coord()[axis1];
                                end.coord()[axis2] -= t.coord()[axis2];
                            }
                        }
                    }
                }
                jTable1.tableChanged(null);
                verifyFaces();
            }
            if ((jRadioButtonSelectLine.isSelected())&& (!svp.isSelecting()))
            {
                if (svp == null) return;
                if (!historyAdded)
                    addHistory();
                historyAdded = true;

                // new drag all selected
                int axis1 = svp.getHorizontalAxis();
                int axis2 = svp.getVerticalAxis();
                // base for delta is current highlighted point
                GFXVector sv = svp.getHighlightedVector();
                Vertex t = evt.translocationInVectrexPoint;

                ArrayList<GFXVector> toTranslocate = svp.getSelectedVectors();
                HashMap<Vertex, Vertex> alreadyDone = new HashMap<Vertex, Vertex>();
                for (GFXVector v: toTranslocate)
                {
                    Vertex start = v.start;
                    if (alreadyDone.get(start) == null) 
                    {
                        alreadyDone.put(start, start);
                        if (svp.is3d())
                        {
                            start.coord()[ARRAY_X] -= t.coord()[ARRAY_X];
                            start.coord()[ARRAY_Y] -= t.coord()[ARRAY_Y];
                            start.coord()[ARRAY_Z] -= t.coord()[ARRAY_Z];
                            if (svp.isGrid())
                            {
                                if (start.coord()[ARRAY_X]>0)
                                    start.coord()[ARRAY_X] = (int) ((int) ( ((double)start.coord()[ARRAY_X])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                else
                                    start.coord()[ARRAY_X] = (int) ((int) ( ((double)start.coord()[ARRAY_X])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));

                                if (start.coord()[ARRAY_Y]>0)
                                    start.coord()[ARRAY_Y] = (int) ((int) ( ((double)start.coord()[ARRAY_Y])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                else
                                    start.coord()[ARRAY_Y] = (int) ((int) ( ((double)start.coord()[ARRAY_Y])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));

                                if (start.coord()[ARRAY_Z]>0)
                                    start.coord()[ARRAY_Z] = (int) ((int) ( ((double)start.coord()[ARRAY_Z])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                else
                                    start.coord()[ARRAY_Z] = (int) ((int) ( ((double)start.coord()[ARRAY_Z])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));
                            }
                            
                        }
                        else
                        {
                            start.coord()[axis1] -= t.coord()[axis1];
                            start.coord()[axis2] -= t.coord()[axis2];
                        }
                    }
                    Vertex end = v.end;
                    if (alreadyDone.get(end) == null) 
                    {
                        alreadyDone.put(end, end);
                        if (svp.is3d())
                        {
                            end.coord()[ARRAY_X] -= t.coord()[ARRAY_X];
                            end.coord()[ARRAY_Y] -= t.coord()[ARRAY_Y];
                            end.coord()[ARRAY_Z] -= t.coord()[ARRAY_Z];
                            if (svp.isGrid())
                            {
                                if (end.coord()[ARRAY_X]>0)
                                    end.coord()[ARRAY_X] = (int) ((int) ( ((double)end.coord()[ARRAY_X])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                else
                                    end.coord()[ARRAY_X] = (int) ((int) ( ((double)end.coord()[ARRAY_X])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));

                                if (end.coord()[ARRAY_Y]>0)
                                    end.coord()[ARRAY_Y] = (int) ((int) ( ((double)end.coord()[ARRAY_Y])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                else
                                    end.coord()[ARRAY_Y] = (int) ((int) ( ((double)end.coord()[ARRAY_Y])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));

                                if (end.coord()[ARRAY_Z]>0)
                                    end.coord()[ARRAY_Z] = (int) ((int) ( ((double)end.coord()[ARRAY_Z])/((double)svp.getGridWidth()) +(((double)1)/2)) * ((double)svp.getGridWidth()));
                                else
                                    end.coord()[ARRAY_Z] = (int) ((int) ( ((double)end.coord()[ARRAY_Z])/((double)svp.getGridWidth()) -(((double)1)/2)) * ((double)svp.getGridWidth()));
                            }
                            
                        }
                        else
                        {
                            end.coord()[axis1] -= t.coord()[axis1];
                            end.coord()[axis2] -= t.coord()[axis2];
                        }
                    }
                }    
                
                jTable1.tableChanged(null);
                verifyFaces();
            }
            setSelectedInTable();
            jTable1.repaint();
            fillStatus();
            if (jCheckBoxAutoApply.isSelected()) applyChanges();
        }
        if (evt.highlightedPoint != null)
        {
            singleVectorPanel1.setHighlightedVPoint(evt.highlightedPoint);
        }
        
        buildingVector.end.set(p);
    }

    // sets to the given vector
    // the styles that are set in the gui fields
    // intensity & pattern
    void checkVectorStyles(GFXVector v)
    {
        if (jCheckBoxHasPattern.isSelected())
        {
            v.pattern = DASM6809.toNumber(jTextFieldPattern.getText());
        }
        if (jCheckBoxHasIntensity.isSelected())
        {
            int i =  DASM6809.toNumber(jTextFieldIntensity.getText()); 
            if (i<0) i = 0;
            if (i>127) i = 0;
            jTextFieldIntensity.setText(""+i);
            v.setIntensity(i);
        }
        else
        {
            v.setIntensity(63);
        }
    }
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.ButtonGroup buttonGroup3;
    private javax.swing.ButtonGroup buttonGroup4;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton10;
    private javax.swing.JButton jButton11;
    private javax.swing.JButton jButton12;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton2dAxis;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton3dAxis;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JButton jButton8;
    private javax.swing.JButton jButton9;
    private javax.swing.JButton jButtonAddCurrent;
    private javax.swing.JButton jButtonAddCurrent1;
    private javax.swing.JButton jButtonAnimCodeGen;
    private javax.swing.JButton jButtonApplyCurrent;
    private javax.swing.JButton jButtonAssemble;
    private javax.swing.JButton jButtonAssemble1;
    private javax.swing.JButton jButtonAssembleSM;
    private javax.swing.JButton jButtonBuildSmartList;
    private javax.swing.JButton jButtonBuildSmartList1;
    private javax.swing.JButton jButtonBuildSmartList2;
    private javax.swing.JButton jButtonClearAnimation;
    private javax.swing.JButton jButtonCodeGen;
    private javax.swing.JButton jButtonConnectWherePossible;
    private javax.swing.JButton jButtonConnectWherePossible1;
    private javax.swing.JButton jButtonCopy;
    private javax.swing.JButton jButtonCube;
    private javax.swing.JButton jButtonCut;
    private javax.swing.JButton jButtonDeleteOne;
    private javax.swing.JButton jButtonDisconnectAll;
    private javax.swing.JButton jButtonDown;
    private javax.swing.JButton jButtonDraw_3d;
    private javax.swing.JButton jButtonDraw_VL_mode;
    private javax.swing.JButton jButtonDraw_VL_modeAnim;
    private javax.swing.JButton jButtonDraw_VLc;
    private javax.swing.JButton jButtonDraw_VLcAnim;
    private javax.swing.JButton jButtonDraw_VLp;
    private javax.swing.JButton jButtonDraw_VLpAnim;
    private javax.swing.JButton jButtonDraw_absolut;
    private javax.swing.JButton jButtonDraw_syncList;
    private javax.swing.JButton jButtonDraw_syncListAnim;
    private javax.swing.JButton jButtonEditInVedi;
    private javax.swing.JButton jButtonEditInVedi1;
    private javax.swing.JButton jButtonEditInVedi2;
    private javax.swing.JButton jButtonEnlarge;
    private javax.swing.JButton jButtonEnlarge1;
    private javax.swing.JButton jButtonExpandDimensionYZ;
    private javax.swing.JButton jButtonExport;
    private javax.swing.JButton jButtonExport1;
    private javax.swing.JButton jButtonFileSelect2;
    private javax.swing.JButton jButtonFileSelect3;
    private javax.swing.JButton jButtonFillGaps;
    private javax.swing.JButton jButtonFitByteRange;
    private javax.swing.JButton jButtonFitByteRange1;
    private javax.swing.JButton jButtonInsertYM;
    private javax.swing.JButton jButtonInterprete;
    private javax.swing.JButton jButtonJoin;
    private javax.swing.JButton jButtonJoin1;
    private javax.swing.JButton jButtonJoin2;
    private javax.swing.JButton jButtonLeft;
    private javax.swing.JButton jButtonLoad;
    private javax.swing.JButton jButtonLoad1;
    private javax.swing.JButton jButtonLoad2;
    private javax.swing.JButton jButtonLoad3;
    private javax.swing.JButton jButtonLoad4;
    private javax.swing.JButton jButtonLongestPaths;
    private javax.swing.JButton jButtonLongestPaths1;
    private javax.swing.JButton jButtonLongestPathsplus;
    private javax.swing.JButton jButtonMirrorHorizontally;
    private javax.swing.JButton jButtonMirrorVertically;
    private javax.swing.JButton jButtonMov_Draw_VLc_a;
    private javax.swing.JButton jButtonMov_Draw_VLc_aAnim;
    private javax.swing.JButton jButtonOneBack;
    private javax.swing.JButton jButtonOneForward;
    private javax.swing.JButton jButtonOneForwardSelection1;
    private javax.swing.JButton jButtonOneForwardSelection2;
    private javax.swing.JButton jButtonOptimizeSize;
    private javax.swing.JButton jButtonOrderSplitWhereNeeded;
    private javax.swing.JButton jButtonOrderVectorlist;
    private javax.swing.JButton jButtonPaste;
    private javax.swing.JButton jButtonPathsAsScenario;
    private javax.swing.JButton jButtonRedo;
    private javax.swing.JButton jButtonRemoveDots;
    private javax.swing.JButton jButtonRemoveDots1;
    private javax.swing.JButton jButtonRemoveDouble;
    private javax.swing.JButton jButtonRemoveMove;
    private javax.swing.JButton jButtonRemoveiDouble;
    private javax.swing.JButton jButtonReverse;
    private javax.swing.JButton jButtonRight;
    private javax.swing.JButton jButtonRotate2d;
    private javax.swing.JButton jButtonSave1;
    private javax.swing.JButton jButtonSave2;
    private javax.swing.JButton jButtonSave3;
    private javax.swing.JButton jButtonSaveSelection;
    private javax.swing.JButton jButtonSelectAll;
    private javax.swing.JButton jButtonSelectionRotation;
    private javax.swing.JButton jButtonSetMove;
    private javax.swing.JButton jButtonSetSolid;
    private javax.swing.JButton jButtonSetStyle;
    private javax.swing.JButton jButtonShrink;
    private javax.swing.JButton jButtonShrink1;
    private javax.swing.JButton jButtonSingleEditor;
    private javax.swing.JButton jButtonSingleEditor1;
    private javax.swing.JButton jButtonUndo;
    private javax.swing.JButton jButtonUp;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox10;
    private javax.swing.JCheckBox jCheckBox11;
    private javax.swing.JCheckBox jCheckBox12;
    private javax.swing.JCheckBox jCheckBox13;
    private javax.swing.JCheckBox jCheckBox14;
    private javax.swing.JCheckBox jCheckBox15;
    private javax.swing.JCheckBox jCheckBox16;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox2dOnly;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBox3dDots;
    private javax.swing.JCheckBox jCheckBox3ds;
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JCheckBox jCheckBox5;
    private javax.swing.JCheckBox jCheckBox6;
    private javax.swing.JCheckBox jCheckBox7;
    private javax.swing.JCheckBox jCheckBox8;
    private javax.swing.JCheckBox jCheckBox9;
    private javax.swing.JCheckBox jCheckBoxAbsolut;
    private javax.swing.JCheckBox jCheckBoxAbsolutEnd;
    private javax.swing.JCheckBox jCheckBoxAbsolutStart;
    private javax.swing.JCheckBox jCheckBoxAddFactor;
    private javax.swing.JCheckBox jCheckBoxAlwaysInt;
    private javax.swing.JCheckBox jCheckBoxArrows;
    private javax.swing.JCheckBox jCheckBoxAutoApply;
    private javax.swing.JCheckBox jCheckBoxAutoEdit;
    private javax.swing.JCheckBox jCheckBoxAvoidMoreThan2;
    private javax.swing.JCheckBox jCheckBoxByteFrame;
    private javax.swing.JCheckBox jCheckBoxCStyle;
    private javax.swing.JCheckBox jCheckBoxCompileForVB;
    private javax.swing.JCheckBox jCheckBoxContinue;
    private javax.swing.JCheckBox jCheckBoxDisplayAxis;
    private javax.swing.JCheckBox jCheckBoxDontRemoveDoubles;
    private javax.swing.JCheckBox jCheckBoxDragVectors;
    private javax.swing.JCheckBox jCheckBoxExtendedAnimSync;
    private javax.swing.JCheckBox jCheckBoxFactor;
    private javax.swing.JCheckBox jCheckBoxFraktion;
    private javax.swing.JCheckBox jCheckBoxFraktion1;
    private javax.swing.JCheckBox jCheckBoxGrid;
    private javax.swing.JCheckBox jCheckBoxHasIntensity;
    private javax.swing.JCheckBox jCheckBoxHasPattern;
    private javax.swing.JCheckBox jCheckBoxHighPattern;
    private javax.swing.JCheckBox jCheckBoxIntensity;
    private javax.swing.JCheckBox jCheckBoxLine;
    private javax.swing.JCheckBox jCheckBoxMoves;
    private javax.swing.JCheckBox jCheckBoxMulti;
    private javax.swing.JCheckBox jCheckBoxNoHiLo;
    private javax.swing.JCheckBox jCheckBoxNoInitialMove;
    private javax.swing.JCheckBox jCheckBoxNoShift;
    private javax.swing.JCheckBox jCheckBoxNoSyncOpt;
    private javax.swing.JCheckBox jCheckBoxOnePath;
    private javax.swing.JCheckBox jCheckBoxPCStyle;
    private javax.swing.JCheckBox jCheckBoxPointsOk;
    private javax.swing.JCheckBox jCheckBoxPosition;
    private javax.swing.JCheckBox jCheckBoxRespectZero;
    private javax.swing.JCheckBox jCheckBoxRunnable;
    private javax.swing.JCheckBox jCheckBoxRunnable1;
    private javax.swing.JCheckBox jCheckBoxRunnable2;
    private javax.swing.JCheckBox jCheckBoxSameIntensity;
    private javax.swing.JCheckBox jCheckBoxSamePattern;
    private javax.swing.JCheckBox jCheckBoxScaleToByte;
    private javax.swing.JCheckBox jCheckBoxStackJump;
    private javax.swing.JCheckBox jCheckBoxVec32;
    private javax.swing.JCheckBox jCheckBoxVectorClosedPolygon;
    private javax.swing.JCheckBox jCheckBoxVectorOrderedClosedPolygon;
    private javax.swing.JCheckBox jCheckBoxVectorsContinuous;
    private javax.swing.JCheckBox jCheckBoxextendedList;
    private javax.swing.JCheckBox jCheckBoxxrotdir;
    private javax.swing.JCheckBox jCheckBoxyrotdir;
    private javax.swing.JCheckBox jCheckBoxzrotdir;
    private javax.swing.JComboBox jComboBoxPatterns;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel18;
    private javax.swing.JLabel jLabel19;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel20;
    private javax.swing.JLabel jLabel21;
    private javax.swing.JLabel jLabel22;
    private javax.swing.JLabel jLabel23;
    private javax.swing.JLabel jLabel24;
    private javax.swing.JLabel jLabel25;
    private javax.swing.JLabel jLabel26;
    private javax.swing.JLabel jLabel27;
    private javax.swing.JLabel jLabel28;
    private javax.swing.JLabel jLabel29;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel30;
    private javax.swing.JLabel jLabel31;
    private javax.swing.JLabel jLabel32;
    private javax.swing.JLabel jLabel33;
    private javax.swing.JLabel jLabel34;
    private javax.swing.JLabel jLabel35;
    private javax.swing.JLabel jLabel36;
    private javax.swing.JLabel jLabel37;
    private javax.swing.JLabel jLabel38;
    private javax.swing.JLabel jLabel39;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel40;
    private javax.swing.JLabel jLabel41;
    private javax.swing.JLabel jLabel42;
    private javax.swing.JLabel jLabel43;
    private javax.swing.JLabel jLabel44;
    private javax.swing.JLabel jLabel45;
    private javax.swing.JLabel jLabel46;
    private javax.swing.JLabel jLabel47;
    private javax.swing.JLabel jLabel48;
    private javax.swing.JLabel jLabel49;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel50;
    private javax.swing.JLabel jLabel51;
    private javax.swing.JLabel jLabel52;
    private javax.swing.JLabel jLabel53;
    private javax.swing.JLabel jLabel54;
    private javax.swing.JLabel jLabel55;
    private javax.swing.JLabel jLabel56;
    private javax.swing.JLabel jLabel57;
    private javax.swing.JLabel jLabel58;
    private javax.swing.JLabel jLabel59;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel60;
    private javax.swing.JLabel jLabel61;
    private javax.swing.JLabel jLabel62;
    private javax.swing.JLabel jLabel63;
    private javax.swing.JLabel jLabel64;
    private javax.swing.JLabel jLabel65;
    private javax.swing.JLabel jLabel66;
    private javax.swing.JLabel jLabel67;
    private javax.swing.JLabel jLabel68;
    private javax.swing.JLabel jLabel69;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel70;
    private javax.swing.JLabel jLabel71;
    private javax.swing.JLabel jLabel72;
    private javax.swing.JLabel jLabel73;
    private javax.swing.JLabel jLabel74;
    private javax.swing.JLabel jLabel75;
    private javax.swing.JLabel jLabel76;
    private javax.swing.JLabel jLabel77;
    private javax.swing.JLabel jLabel78;
    private javax.swing.JLabel jLabel79;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel80;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JLabel jLabelAnim;
    private javax.swing.JLabel jLabelCount;
    private javax.swing.JLabel jLabelCurrent;
    private javax.swing.JLabel jLabelDelay;
    private javax.swing.JLabel jLabelDelay1;
    private javax.swing.JLabel jLabelFactor;
    private javax.swing.JLabel jLabelImageCount;
    private javax.swing.JLabel jLabelImageNow;
    private javax.swing.JLabel jLabelMaxY;
    private javax.swing.JLabel jLabelMinY;
    private javax.swing.JLabel jLabelMode;
    private javax.swing.JLabel jLabelPattern;
    private javax.swing.JLabel jLabelPattern1;
    private javax.swing.JLabel jLabelScale;
    private javax.swing.JLabel jLabelSelSize;
    private javax.swing.JLabel jLabelStartInX;
    private javax.swing.JLabel jLabelX;
    private javax.swing.JLabel jLabelY;
    private javax.swing.JLabel jLabelY0;
    private javax.swing.JLabel jLabelZ;
    private javax.swing.JMenuItem jMenuItemConnect;
    private javax.swing.JMenuItem jMenuItemDelete;
    private javax.swing.JMenuItem jMenuItemDeleteNotSelected;
    private javax.swing.JMenuItem jMenuItemHere;
    private javax.swing.JMenuItem jMenuItemInsertPoint;
    private javax.swing.JMenuItem jMenuItemJoin;
    private javax.swing.JMenuItem jMenuItemLineDelete;
    private javax.swing.JMenuItem jMenuItemMove;
    private javax.swing.JMenuItem jMenuItemPoint0;
    private javax.swing.JMenuItem jMenuItemRemovePoint;
    private javax.swing.JMenuItem jMenuItemRip;
    private javax.swing.JMenuItem jMenuItemSwitch;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel10;
    private javax.swing.JPanel jPanel11;
    private javax.swing.JPanel jPanel12;
    private javax.swing.JPanel jPanel13;
    private javax.swing.JPanel jPanel14;
    private javax.swing.JPanel jPanel15;
    private javax.swing.JPanel jPanel16;
    private javax.swing.JPanel jPanel18;
    private javax.swing.JPanel jPanel19;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel20;
    private javax.swing.JPanel jPanel21;
    private javax.swing.JPanel jPanel22;
    private javax.swing.JPanel jPanel23;
    private javax.swing.JPanel jPanel24;
    private javax.swing.JPanel jPanel25;
    private javax.swing.JPanel jPanel26;
    private javax.swing.JPanel jPanel27;
    private javax.swing.JPanel jPanel28;
    private javax.swing.JPanel jPanel29;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel30;
    private javax.swing.JPanel jPanel31;
    private javax.swing.JPanel jPanel32;
    private javax.swing.JPanel jPanel33;
    private javax.swing.JPanel jPanel34;
    private javax.swing.JPanel jPanel35;
    private javax.swing.JPanel jPanel36;
    private javax.swing.JPanel jPanel37;
    private javax.swing.JPanel jPanel38;
    private javax.swing.JPanel jPanel39;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel40;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    private javax.swing.JPanel jPanelIMageCollection;
    private javax.swing.JPanel jPanelModeSelect;
    private javax.swing.JPanel jPanelScroller;
    private javax.swing.JPanel jPanelShortCuts1;
    private javax.swing.JPanel jPanelShortCuts2;
    private javax.swing.JPanel jPanelShortcutsCollection;
    private javax.swing.JPopupMenu jPopupMenuLine;
    private javax.swing.JPopupMenu jPopupMenuPoint;
    private javax.swing.JRadioButton jRadioButton3;
    private javax.swing.JRadioButton jRadioButton4;
    private javax.swing.JRadioButton jRadioButton5;
    private javax.swing.JRadioButton jRadioButton6;
    private javax.swing.JRadioButton jRadioButtonAnimation;
    private javax.swing.JRadioButton jRadioButtonScenario;
    private javax.swing.JRadioButton jRadioButtonSelectLine;
    private javax.swing.JRadioButton jRadioButtonSelectPoint;
    private javax.swing.JRadioButton jRadioButtonSetPoint;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JScrollPane jScrollPane6;
    private javax.swing.JScrollPane jScrollPane7;
    private javax.swing.JScrollPane jScrollPane8;
    private javax.swing.JSlider jSliderFront;
    private javax.swing.JSlider jSliderFront1;
    private javax.swing.JSlider jSliderFrontTranslocationX;
    private javax.swing.JSlider jSliderFrontTranslocationY;
    private javax.swing.JSlider jSliderFrontTranslocationZ;
    private javax.swing.JSlider jSliderSide;
    private javax.swing.JSlider jSliderSide1;
    private javax.swing.JSlider jSliderSourceScale;
    private javax.swing.JSlider jSliderSourceScale1;
    private javax.swing.JSlider jSliderTop;
    private javax.swing.JSlider jSliderTop1;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTabbedPane jTabbedPane2;
    private javax.swing.JTabbedPane jTabbedPane3;
    private javax.swing.JTabbedPane jTabbedPane4;
    private javax.swing.JTabbedPane jTabbedPane5;
    private javax.swing.JTabbedPane jTabbedPane6;
    private javax.swing.JTabbedPane jTabbedPane7;
    private javax.swing.JTabbedPane jTabbedPane8;
    private javax.swing.JTable jTable1;
    private javax.swing.JTable jTableFace;
    private javax.swing.JTextArea jTextArea1;
    private javax.swing.JTextArea jTextArea2;
    private javax.swing.JTextArea jTextAreaResult;
    private javax.swing.JTextArea jTextAreaResult1;
    private javax.swing.JTextArea jTextAreaResultSM;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField10;
    private javax.swing.JTextField jTextField11;
    private javax.swing.JTextField jTextField12;
    private javax.swing.JTextField jTextField13;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField3;
    private javax.swing.JTextField jTextField4;
    private javax.swing.JTextField jTextField5;
    private javax.swing.JTextField jTextField6;
    private javax.swing.JTextField jTextField7;
    private javax.swing.JTextField jTextField8;
    private javax.swing.JTextField jTextField9;
    private javax.swing.JTextField jTextFieldAnimName;
    private javax.swing.JTextField jTextFieldAnimName1;
    private javax.swing.JTextField jTextFieldBaseSize;
    private javax.swing.JTextField jTextFieldCount;
    private javax.swing.JTextField jTextFieldCurrentNo;
    private javax.swing.JTextField jTextFieldCurrentX;
    private javax.swing.JTextField jTextFieldCurrentY;
    private javax.swing.JTextField jTextFieldCurrentZ;
    private javax.swing.JTextField jTextFieldDelay;
    private javax.swing.JTextField jTextFieldExpandYZ;
    private javax.swing.JTextField jTextFieldFront;
    private javax.swing.JTextField jTextFieldFront1;
    private javax.swing.JTextField jTextFieldFront2;
    private javax.swing.JTextField jTextFieldGridWidth;
    private javax.swing.JTextField jTextFieldIntensity;
    private javax.swing.JTextField jTextFieldLabelFactorName;
    private javax.swing.JTextField jTextFieldLabelListname;
    private javax.swing.JTextField jTextFieldLabelListname1;
    private javax.swing.JTextField jTextFieldLabelListname2;
    private javax.swing.JTextField jTextFieldLabelStackJumpName;
    private javax.swing.JTextField jTextFieldMorphSteps;
    private javax.swing.JTextField jTextFieldNeedSplit;
    private javax.swing.JTextField jTextFieldPattern;
    private javax.swing.JTextField jTextFieldPatternName;
    private javax.swing.JTextField jTextFieldResync;
    private javax.swing.JTextField jTextFieldResyncAnim;
    private javax.swing.JTextField jTextFieldRotate2d;
    private javax.swing.JTextField jTextFieldRotateSteps;
    private javax.swing.JTextField jTextFieldRotateX;
    private javax.swing.JTextField jTextFieldRotateY;
    private javax.swing.JTextField jTextFieldRotateZ;
    private javax.swing.JTextField jTextFieldScaleFactor;
    private javax.swing.JTextField jTextFieldScaleFactor1;
    private javax.swing.JTextField jTextFieldSide;
    private javax.swing.JTextField jTextFieldSide1;
    private javax.swing.JTextField jTextFieldSide2;
    private javax.swing.JTextField jTextFieldSmartMax;
    private javax.swing.JTextField jTextFieldStartX;
    private javax.swing.JTextField jTextFieldStartY;
    private javax.swing.JTextField jTextFieldStartZ;
    private javax.swing.JTextField jTextFieldTop;
    private javax.swing.JTextField jTextFieldTop1;
    private javax.swing.JTextField jTextFieldTop2;
    private javax.swing.JTextField jTextFieldVectorCount;
    private javax.swing.JTextField jTextFieldXMax;
    private javax.swing.JTextField jTextFieldXMaxLength;
    private javax.swing.JTextField jTextFieldXMin;
    private javax.swing.JTextField jTextFieldYMax;
    private javax.swing.JTextField jTextFieldYMaxLength;
    private javax.swing.JTextField jTextFieldYMin;
    private javax.swing.JTextField jTextFieldZMax;
    private javax.swing.JTextField jTextFieldZMaxLength;
    private javax.swing.JTextField jTextFieldZMin;
    private javax.swing.JTextField jTextFieldstart1;
    private javax.swing.JTextField jTextFieldstart2;
    private javax.swing.JToggleButton jToggleButtonPlayAnim;
    private de.malban.graphics.Single3dDisplayPanel single3dDisplayPanel;
    private de.malban.graphics.Single3dDisplayPanel single3dDisplayPanel1;
    private de.malban.graphics.SingleVectorPanel singleImagePanel2;
    private de.malban.graphics.SingleVectorPanel singleImagePanel3;
    private de.malban.graphics.SingleVectorPanel singleVectorPanel1;
    // End of variables declaration//GEN-END:variables

    
    public void addVector(GFXVector v)
    {
        checkVectorStyles(v);
        singleVectorPanel1.addForegroundVector(v);
        jTable1.tableChanged(null);
    }
    
    // method for beansheell to use, to get the current vectorlist
    // beanshell does not know arraylist!
    public Vector getVectors()
    {
        // for Beanshell we must use "old style"
        GFXVectorList v = singleVectorPanel1.getForegroundVectorList();
        Vector vec = new Vector();
        
        for (GFXVector gfxv: v.list)
            vec.addElement(gfxv);
        return vec;
    }
    
    // clears all vectors from the current edited vectorlist
    public void clearVectors()
    {
        singleVectorPanel1.clearVectors();
        initFaces();
        resetFaceTable();
        jTable1.tableChanged(null);
    }
    public boolean saveCurrentList(String filename)
    {
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList().clone();
        vl.resetDisplay();

        if (!filename.toUpperCase().endsWith(".XML"))
        {
            filename+= ".xml";
        }
        return vl.saveAsXML(filename);
    
    }
    public boolean loadCurrentList(String filename)
    {
        GFXVectorList vl = new GFXVectorList();
        if (vl.loadFromXML(filename))
        {
            addHistory();
            setCurrentVectorList(vl);
            return true;
        }
        return false;
    }
    
    void addViewToAnimation()
    {
        GFXVectorList vl = single3dDisplayPanel.getDisplayVectorList();
        
        vl.resetDisplay();
        currentAnimation.add(vl);
        selectedAnimationFrameUID = vl.uid;
        preSelectedAnimationFrameUID = vl.uid;
    
        setCurrentListFromUID(selectedAnimationFrameUID, true);
        redrawAnimation();
    }
    
    
    // adds the currently edited vectorlist to the 
    // current collection
    // a CLONE is added, not the list itself!
    void addCurrentToAnimation()
    {
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList().clone();
        vl.resetDisplay();
        currentAnimation.add(vl);
        selectedAnimationFrameUID = vl.uid;
        
        setCurrentListFromUID(selectedAnimationFrameUID, true);
        redrawAnimation();
    }
    
    // resets completely the display of the current vectorlist collection
    void redrawAnimation()
    {
        jPanelIMageCollection.removeAll();
        boolean uidFound = false;
        for (int i=0;i<currentAnimation.size(); i++)
        {
            if (jCheckBoxAlwaysInt.isSelected())
            {
                currentAnimation.get(i).intAll();
            }

            int uid = currentAnimation.get(i).uid;
            JPanel panel = new JPanel();
            if (uid ==selectedAnimationFrameUID)
            {
                uidFound = true;
                panel.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(255, 255, 0)));
            }
            else
                panel.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
            panel.setPreferredSize(new java.awt.Dimension(52, 52));
            panel.setName(""+uid);
            panel.setLayout(null);
            SingleVectorPanel svp =  new SingleVectorPanel();
            
            svp.setByteFrame(false);
            svp.setBounds(1, 1, 50, 50);
            panel.add(svp);
            svp.addMouseReleasedListener(new MouseReleasedListener()
            {
                public void released(EditMouseEvent evt)
                {
                    animationVectorListMouseClicked(evt.evt);
                }
            });
            svp.setGrid(false, 1);
            svp.clearVectors();
            svp.addForegroundVectorList(currentAnimation.get(i));
            svp.scaleToFit();
            svp.setDrawVectorEnds(false);
            svp.setDrawCross(false);
            jPanelIMageCollection.add(panel);   
            svp.sharedRepaint();
        }
        jScrollPane2.invalidate();
        jScrollPane2.validate();
        jScrollPane2.repaint();
        jButtonApplyCurrent.setEnabled((selectedAnimationFrameUID != -1) && (uidFound));
        
        int index = getIndex(selectedAnimationFrameUID);
        
        
        if (index == -1)
            jTextFieldCurrentNo.setText("");
        else
            jTextFieldCurrentNo.setText(""+index);
        
        if (currentAnimation.isAnimation)
        {
            doAnimation();
        }
        else
        {
            doScenario();
        }
        
        mClassSetting++;
        jRadioButtonAnimation.setSelected(currentAnimation.isAnimation);
        jRadioButtonScenario.setSelected(!currentAnimation.isAnimation);
        mClassSetting--;
        
        checkAnimExportButtons();
     
    }
    
    void checkAnimExportButtons()
    {
        // export Anims
        jButtonMov_Draw_VLc_aAnim.setEnabled(true);
        jButtonDraw_VLcAnim.setEnabled(true);
        jButtonDraw_VLpAnim.setEnabled(true);
        jButtonDraw_VL_modeAnim.setEnabled(true);
        jButtonAnimCodeGen.setEnabled(true);

                
        boolean allSamePattern = currentAnimation.isAllSamePattern();
        boolean allContinuous = currentAnimation.isCompleteRelative();
        boolean allHighPattern = currentAnimation.isAllPatternHigh(true);


        if (!allSamePattern)
        {
            jButtonMov_Draw_VLc_aAnim.setEnabled(false);
            jButtonDraw_VLcAnim.setEnabled(false);
        }
        if (!allContinuous)
        {
            jButtonMov_Draw_VLc_aAnim.setEnabled(false);
            jButtonDraw_VLcAnim.setEnabled(false);
            jButtonDraw_VLpAnim.setEnabled(false);
            jButtonDraw_VL_modeAnim.setEnabled(false);
            jButtonAnimCodeGen.setEnabled(false);
        }
        if (!allHighPattern)
        {
            jButtonDraw_VLpAnim.setEnabled(false);
        }           
    }
    
    
    private void animationVectorListMouseClicked(java.awt.event.MouseEvent evt) 
    {
        JPanel panel = (JPanel)((JPanel) evt.getSource()).getParent(); // parent of svp
        int uid = de.malban.util.UtilityString.IntX(panel.getName(), -1);
        if (uid == lastSetUID)
        {
            return;
        }
        if (uid == -1) 
        {
            lastSetUID = -1;
            selectedAnimationFrameUID = -1;
            preSelectedAnimationFrameUID = -1;
            redrawAnimation();
            return;
        }
        boolean ok = setCurrentListFromUID(uid, false);
        redrawAnimation();
    }                                     
    
    // sets the vectorlist with UID to be the current
    // edited vectorlist
    // the vectorlist of the UID is CLONED, not taken directly!
    private boolean setCurrentListFromUID(int uid, boolean forceEdit)
    {
        
        for (int i=0;i<currentAnimation.size(); i++)
        {
            if (uid == currentAnimation.get(i).uid)
            {
                GFXVectorList vl = currentAnimation.get(i).clone();
                if ((jCheckBoxAutoEdit.isSelected()) || (forceEdit))
                {
                    setCurrentVectorList(vl);
                    selectedAnimationFrameUID = uid;
                    preSelectedAnimationFrameUID = selectedAnimationFrameUID;

                    lastSetUID = selectedAnimationFrameUID;
                    return true;
                }
                else
                {
                    selectedAnimationFrameUID = uid;
                    preSelectedAnimationFrameUID = uid;
                    return true;
                }
            }
        }
        return false;
    }
    
    // convenient function for the three
    // steps to init a new vectorlist in editor parts
    public void setCurrentVectorList(GFXVectorList vl)
    {
        vl.setRelativeWherePossible();
        singleVectorPanel1.clearVectors();
        singleVectorPanel1.addForegroundVectorList(vl.list);
        jTable1.tableChanged(null);
        initFaces();
        fillStatus();
        single3dDisplayPanel.repaint();
    }
    
    boolean saveAnimation()
    {
        String filename =Global.mainPathPrefix+"xml"+File.separator+"vectoranimation";
        String saveName = VectorListFileChoserJPanel.showSavePanel(filename, "Save Vector-Animation", true);
        if (saveName != null)
        {
            if (!saveName.toUpperCase().endsWith(".XML"))
            {
                saveName+= ".xml";
            }
            return currentAnimation.saveAsXML(saveName);
        }
        return false;
    }
    // start animation in view
    // toggles between animation view and view of "3d" of edited vectorlist
    void doAnimation()
    {
        boolean shouldPlay = jToggleButtonPlayAnim.isSelected();
        if (shouldPlay)
        {
            singleVectorPanel1.removeSibbling(single3dDisplayPanel);
            single3dDisplayPanel.setAnimation(currentAnimation);
            single3dDisplayPanel.setDelay(de.malban.util.UtilityString.IntX(jTextFieldDelay.getText(),-1));
        }
        else
        {
            // ensure sibbling is removed:
            singleVectorPanel1.removeSibbling(single3dDisplayPanel);
            single3dDisplayPanel.setAnimation(new GFXVectorAnimation());
            single3dDisplayPanel.setForegroundVectorList(singleVectorPanel1.getForegroundVectorList());
            single3dDisplayPanel.setDelay(-1);
            singleVectorPanel1.addSibbling(single3dDisplayPanel);
            
        }
    }
    boolean loadAnimation()
    {
        String filename =Global.mainPathPrefix+"xml"+File.separator+"vectoranimation";
        String loadName = VectorListFileChoserJPanel.showSavePanel(filename, "Load Vector-Animation", true);
        selectedAnimationFrameUID = -1;
        preSelectedAnimationFrameUID = -1;
        boolean ok = false;
        if (loadName != null)
        {
            if (!loadName.toUpperCase().endsWith(".XML"))
            {
                loadName+= ".xml";
            }
            ok = currentAnimation.loadFromXML(loadName);
            if (ok)
            {
                if (currentAnimation.size()>0)
                {
                    ok = setCurrentListFromUID(currentAnimation.get(0).uid, true);
                }
            }
        }
        
        redrawAnimation();
        return ok;
    }
    // delete current selected item from collection, 
    boolean deleteSelectedFromAnimation()
    {
        if (selectedAnimationFrameUID == -1) return false;
 
        int indexToDelete = -1;
        for (int i=0;i<currentAnimation.size(); i++)
        {
            int uid = currentAnimation.get(i).uid;
            if (uid ==selectedAnimationFrameUID)
            {
                indexToDelete = i;
                break;
            }
        }        
        if (indexToDelete==-1) return false;
        currentAnimation.remove(indexToDelete);
        if (currentAnimation.size()<=indexToDelete)
        {
            indexToDelete--;
        }
        if (indexToDelete >=0)
        {
            int newUID = currentAnimation.get(indexToDelete).uid;
            boolean ok = setCurrentListFromUID(newUID, true);
        }
        redrawAnimation();
        return true;
    }
    // get index in collection for a UID of a vectorlist
    int getIndex(int uid)
    {
        return currentAnimation.getIndexFromUID(uid);
    }
    // set the changes in the current vector list
    // to the vectorlist in the collection the current list originated from
    boolean applyChanges()
    {
        if (selectedAnimationFrameUID == -1) return false;
        
        int indexToReplace = currentAnimation.getIndexFromUID(selectedAnimationFrameUID);
        GFXVectorList newList = singleVectorPanel1.getForegroundVectorList().clone();
        newList.resetDisplay();
        currentAnimation.replace(newList, indexToReplace);

        selectedAnimationFrameUID = newList.uid;
        preSelectedAnimationFrameUID = selectedAnimationFrameUID;


        lastSetUID = selectedAnimationFrameUID;

        redrawAnimation();
        return true;
        
    }
    // select all "selected" vectors also in table!
    void setSelectedInTable()
    {
        if (mClassSetting>0) return;
        mClassSetting++;
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        int i = 0;
        jTable1.clearSelection();
        for (GFXVector v :vl.list)
        {
            if (v.selected)
            {
                jTable1.addRowSelectionInterval(i, i);
            }
            i++;
        }
        mClassSetting--;
        jTable1.repaint();
    }
    void tableSelectionChanged() 
    {
/*
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        if (vl != null)
        {
            for (GFXVector v :vl.list)
            v.selected = false;
        } 
*/        
        if (mClassSetting>0) return;
        if (singleVectorPanel1.isDragging()) return;
        if (!jRadioButtonSelectLine.isSelected()) return;
        
        mClassSetting++;

        int[] selectedRow = jTable1.getSelectedRows();
        
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        int i = 0;
        for (GFXVector v :vl.list)
        {
            v.selected = false;
        }

        for (GFXVector v :vl.list)
        {
            for (int t=0; t<selectedRow.length; t++)
            {
                if (selectedRow[t] == i)
                {
                    v.selected = true;
                    break;
                }
            }
            i++;
        }
        singleVectorPanel1.sharedRepaint();
        mClassSetting--;
        
    }

    void buildRotationAnimation()
    {
        GFXVectorList start = singleVectorPanel1.getForegroundVectorList();

        int steps = de.malban.util.UtilityString.Int0(jTextFieldRotateSteps.getText());

        steps++; // start does not count as step
        double angleX = 0;
        double angleY = 0;
        double angleZ = 0;

        double angleXTarget = 0;
        double angleYTarget = 0;
        double angleZTarget = 0;
    
        double incX = 0;
        double incY = 0;
        double incZ = 0;

        if (jCheckBox2.isSelected())
        {
            angleZTarget = de.malban.util.UtilityString.Int0(jTextFieldRotateZ.getText());
            if (angleZTarget>0)
            {
                incZ = angleZTarget/((double)steps);
            }
            if (jCheckBoxzrotdir.isSelected())
            {
                incZ = 360-incZ;
            }
        }
        if (jCheckBox3.isSelected())
        {
            angleXTarget = de.malban.util.UtilityString.Int0(jTextFieldRotateX.getText());
            if (angleXTarget>0)
            {
                incX = angleXTarget/((double)steps);
            }
            if (jCheckBoxxrotdir.isSelected())
            {
                incX = 360-incX;
            }
        }
        if (jCheckBox4.isSelected())
        {
            angleYTarget = de.malban.util.UtilityString.Int0(jTextFieldRotateY.getText());
            if (angleYTarget>0)
            {
                incY = angleYTarget/((double)steps);
            }
            if (jCheckBoxyrotdir.isSelected())
            {
                incY = 360-incY;
            }
        }
        
        
        GFXVectorList newList = start.clone();
        newList.resetDisplay();


        currentAnimation.add(newList);
        selectedAnimationFrameUID = newList.uid;
        preSelectedAnimationFrameUID = selectedAnimationFrameUID;

        angleX=(angleX+incX)%360;
        angleY=(angleY+incY)%360;
        angleZ=(angleZ+incZ)%360;
        
        
        for (int i=0; i<steps; i++)
        {
            newList = start.clone();
            Matrix4x4 rotx = Matrix4x4.getRotationX(Math.toRadians(angleX));
            Matrix4x4 roty = Matrix4x4.getRotationY(Math.toRadians(angleY));
            Matrix4x4 rotz = Matrix4x4.getRotationZ(Math.toRadians(angleZ));
         
            HashMap<Vertex, Vertex> noDouble = new HashMap<Vertex, Vertex>();
            for (int c = 0; c <newList.size(); c++)
            {
                GFXVector v = newList.get(c);
 
                // transformation
                Vertex p1 = v.start;
                Vertex p2 = v.end;

                if (noDouble.get(p1) == null)
                {
                    noDouble.put(p1,p1);
                    p1 = rotx.multiply(p1);
                    p1 = roty.multiply(p1);
                    p1 = rotz.multiply(p1);
                    p1.coords[0] = Math.round(p1.coords[0]);
                    p1.coords[1] = Math.round(p1.coords[1]);
                    p1.coords[2] = Math.round(p1.coords[2]);
                    v.start.set(p1);
                }
                if (noDouble.get(p2) == null)
                {
                    noDouble.put(p2,p2);
                    p2 = rotx.multiply(p2);
                    p2 = roty.multiply(p2);
                    p2 = rotz.multiply(p2);
                    p2.coords[0] = Math.round(p2.coords[0]);
                    p2.coords[1] = Math.round(p2.coords[1]);
                    p2.coords[2] = Math.round(p2.coords[2]);
                    v.end.set(p2);
                }
            }
            newList.resetDisplay();

            if (jCheckBox5.isSelected())
            {
                // hidden line removal
                HLines hlines = new HLines();
                GFXVectorList newListHLR = hlines.processVectorlist(newList.clone());
                newListHLR.resetDisplay();
                currentAnimation.add(newListHLR);
                selectedAnimationFrameUID = newListHLR.uid;
                preSelectedAnimationFrameUID = selectedAnimationFrameUID;
            }
            else
            {
                currentAnimation.add(newList);
                selectedAnimationFrameUID = newList.uid;
                preSelectedAnimationFrameUID = selectedAnimationFrameUID;
            }
            
//            angleX+=incX;
//            angleY+=incY;
//            angleZ+=incZ;
            angleX=(angleX+incX)%360;
            angleY=(angleY+incY)%360;
            angleZ=(angleZ+incZ)%360;
        }
        
        
        if (jCheckBoxScaleToByte.isSelected())
        {
            double max = currentAnimation.getMaxAbsLenValue();
            if (max > 127.0)
            {
                double mul = 127.0/max;
                HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();
                currentAnimation.scaleAll(mul, safetyMap);
            }
        }
        redrawAnimation();
        jTextFieldCount.setText(""+currentAnimation.size());
    }
    

    // ONLY
    // returns correct list, if input vectors are "false" relative!
    // returns TRUE relative VLIST
    void makeTrueRelative(GFXVectorList vl)
    {
        if (vl.size()==0) return;
        ArrayList<GFXVector> nl = new ArrayList<GFXVector>();

        GFXVector v = new GFXVector();
        int order = 0;
        if (vl.size()>0)
        {
            v.pattern = 0;
            v.intensity = 0;
            v.order = order++;
        }
        v.end.x(vl.get(0).start.x());
        v.end.y(vl.get(0).start.y());
        v.end.z(vl.get(0).start.z());
        nl.add(v);
        
        for (int i=0; i< vl.size();i++)
        {
            v = vl.get(i).clone();
            double relX = v.end.x() - v.start.x();
            double relY = v.end.y() - v.start.y();
            double relZ = v.end.z() - v.start.z();

            v.start_connect = nl.get(i);
            v.uid_start_connect = nl.get(i).uid;
            nl.get(i).end_connect = v;
            nl.get(i).uid_end_connect = v.uid;
            v.start = nl.get(i).end;
            v.order = order++;


            v.end.x(relX);
            v.end.y(relY);
            v.end.z(relZ);
            v.setRelativ(true);
            nl.add(v);
        }
        nl.get(nl.size()-1).setRelativ(false);
        vl.list = nl;
    }
    // ONLY
    // returns correct list, if input vectors are "TRUE" relative!
    // returns False relative VLIST
    void makeFalseRelative(GFXVectorList vl)
    {
        if (vl.size()==0) return;
        ArrayList<GFXVector> nl = new ArrayList<GFXVector>();

        double x = 0;
        double y = 0;
        double z = 0;
        for (int i=1; i< vl.size();i++)
        {
            GFXVector v = new GFXVector();
            
            v.intensity = vl.list.get(i).intensity;
            v.pattern = vl.list.get(i).pattern;
            
            x += vl.list.get(i-1).end.x();
            y += vl.list.get(i-1).end.y();
            z += vl.list.get(i-1).end.z();
            
            v.start.x(x);
            v.start.y(y);
            v.start.z(z);
            
            v.end.x(x + vl.list.get(i).end.x());
            v.end.y(y + vl.list.get(i).end.y());
            v.end.z(z + vl.list.get(i).end.z());
            
            nl.add(v);
        }

        for (int i=1; i< nl.size();i++)
        {
            GFXVector v = nl.get(i);
            v.start = nl.get(i-1).end;
            v.start_connect = nl.get(i-1);
            v.uid_start_connect = nl.get(i-1).uid;
            nl.get(i-1).uid_end_connect = v.uid;
            nl.get(i-1).end_connect = v;
            
            if (i<nl.size()-1)
            {
                v.setRelativ(true);
            }
        }
        vl.list = nl;
    }    
    boolean doMorphing()
    {
        double morphSteps = de.malban.util.UtilityString.IntX(jTextFieldMorphSteps.getText(), 1);
        if (currentAnimation==null) return false;
        if (currentAnimation.list.size()<2) return false;
        if (morphSteps <= 0) return false;
        GFXVectorList original = currentAnimation.list.get(0).clone();
        GFXVectorList target = currentAnimation.list.get(1).clone();
                
        makeTrueRelative(original);
        makeTrueRelative(target);
        
        int morphSize = Math.max(original.size(), target.size());
        
        // ensure same length with "0" vectors
        while (original.size()<morphSize) 
        {
            GFXVector n = new GFXVector();
            original.list.add(n);
        }
        while (target.size()<morphSize) 
        {
            GFXVector n = new GFXVector();
            target.list.add(n);
        }
        
        // difference of each coordinate of each (relative) vector
        ArrayList<Vertex> difs = new ArrayList<Vertex>();
        for (int i=0; i<morphSize; i++)
        {
            Vertex v = new Vertex();
            v.x(original.get(i).end.x()-target.get(i).end.x());
            v.y(original.get(i).end.y()-target.get(i).end.y());
            v.z(original.get(i).end.z()-target.get(i).end.z());
         
            difs.add(v);
        }
        
        for (int steps = 0; steps<morphSteps; steps++)
        {
            GFXVectorList nextMorphList = original.clone();
            
            for (int i = 0; i< nextMorphList.list.size();i++)
            {
                double x = nextMorphList.list.get(i).end.x();
                x -= (steps*difs.get(i).x())/morphSteps;
                nextMorphList.list.get(i).end.x((int)x);

                double y = nextMorphList.list.get(i).end.y();
                y -= (steps*difs.get(i).y())/morphSteps;
                nextMorphList.list.get(i).end.y((int)y);

                double z = nextMorphList.list.get(i).end.z();
                z -= (steps*difs.get(i).z())/morphSteps;
                nextMorphList.list.get(i).end.z((int)z);
            }
            makeFalseRelative(nextMorphList);
            nextMorphList.resetDisplay();
            currentAnimation.add(nextMorphList);
        }
        redrawAnimation();
        jTextFieldCount.setText(""+currentAnimation.size());
        return true;
    }
    void expandDimensionYZ()
    {
        int expandSize = de.malban.util.UtilityString.IntX(jTextFieldExpandYZ.getText(), 1);
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        GFXVectorList newVl = vl.clone();
        boolean dragVector = jCheckBoxDragVectors.isSelected();
        
        
        // expand z, z is zero (assumed)
        
        // for each vector there will be
        // a) a translocated vector to +/- z
        // b) a "drag" vector to the new location
    
        for (int i=0; i< vl.size(); i++)
        {
            GFXVector v = vl.get(i).clone();
            v.start.z(v.start.z()+expandSize);
            v.end.z(v.end.z()+expandSize);
                    
            newVl.add(v);
        }
        
        if (dragVector)
        {
            for (int i=0; i< vl.size(); i++)
            {
                GFXVector v = vl.get(i).clone();
                v.end.set(v.start);
                v.end.z(v.end.z()+expandSize);
                newVl.add(v);
            }
        }
        
        
        newVl.connectWherePossible(false);
        singleVectorPanel1.setForegroundVectorList(newVl);
        singleVectorPanel1.sharedRepaint();
        initFaces();
        jTable1.tableChanged(null);
    }
    
    void centerVectorList()
    {
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        double minX = Integer.MAX_VALUE;
        double maxX = -Integer.MAX_VALUE;
        double minY = Integer.MAX_VALUE;
        double maxY = -Integer.MAX_VALUE;
        double minZ = Integer.MAX_VALUE;
        double maxZ = -Integer.MAX_VALUE;
        
        
        for (int i=0; i< vl.size(); i++)
        {
            GFXVector v = vl.get(i);
            if (minX>v.start.x()) minX = v.start.x();
            if (minX>v.end.x()) minX = v.end.x();
            if (maxX<v.start.x()) maxX = v.start.x();
            if (maxX<v.end.x()) maxX = v.end.x();
            
            if (minY>v.start.y()) minY = v.start.y();
            if (minY>v.end.y()) minY = v.end.y();
            if (maxY<v.start.y()) maxY = v.start.y();
            if (maxY<v.end.y()) maxY = v.end.y();
            
            if (minZ>v.start.z()) minZ = v.start.z();
            if (minZ>v.end.z()) minZ = v.end.z();
            if (maxZ<v.start.z()) maxZ = v.start.z();
            if (maxZ<v.end.z()) maxZ = v.end.z();
        }
        double difX = maxX-minX;
        double difY = maxY-minY;
        double difZ = maxZ-minZ;
        
        int translocationX = (int) (maxX-difX/2);
        int translocationY = (int) (maxY-difY/2);
        int translocationZ = (int) (maxZ-difZ/2);
        
        HashMap<String, Boolean> done = new HashMap<String, Boolean>();
        for (int i=0; i< vl.size(); i++)
        {
            GFXVector v = vl.get(i);
            if (done.get(""+v.start.uid) == null)
            {
                v.start.x(v.start.x()-translocationX);            
                v.start.y(v.start.y()-translocationY);            
                v.start.z(v.start.z()-translocationZ);            
                done.put(""+v.start.uid, true);
            }
            
            if (done.get(""+v.end.uid) == null)
            {
                v.end.x(v.end.x()-translocationX);            
                v.end.y(v.end.y()-translocationY);            
                v.end.z(v.end.z()-translocationZ);            
                done.put(""+v.end.uid, true);
            }
        }        
        
        singleVectorPanel1.sharedRepaint();
        jTable1.repaint();
        verifyFaces();
    }
    void fitByteRange()
    {
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        double max = vl.getMaxAbsLenValue();
        if (jCheckBoxFraktion.isSelected())
        {
            double mul = 127.0/max;
            HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();
            vl.scaleAll(mul, safetyMap);
        }
        verifyFaces();
    }
    void doScenario()
    {
        boolean shouldPlay = jToggleButtonPlayAnim.isSelected();
        if (shouldPlay)
        {
            singleVectorPanel1.removeSibbling(single3dDisplayPanel);
            single3dDisplayPanel.setAnimation(new GFXVectorAnimation());
            single3dDisplayPanel.setDelay(-1);

            // build list with all stuff
            GFXVectorList vl = new GFXVectorList();
            for (int i=0; i<currentAnimation.size(); i++)
            {
                vl.add(currentAnimation.get(i));
            }
            vl.connectWherePossible(false);
            vl.resetDisplay();
            
            single3dDisplayPanel.setForegroundVectorList(vl);
            single3dDisplayPanel.repaint();
        }
        else
        {
            singleVectorPanel1.removeSibbling(single3dDisplayPanel);
            single3dDisplayPanel.setAnimation(new GFXVectorAnimation());
            single3dDisplayPanel.setForegroundVectorList(singleVectorPanel1.getForegroundVectorList());
            single3dDisplayPanel.setDelay(-1);
            singleVectorPanel1.addSibbling(single3dDisplayPanel);
        }
    }

    public static class PatternInfo implements Serializable
    {
        public String line1Pattern=""; 
        public String lineXPattern=""; 
        public String lastLinePattern=""; 
        public String name;
        public String toString()
        {
            return name;
        }
        public boolean equals(PatternInfo other)
        {
            if (!line1Pattern.equals(other.line1Pattern)) return false;
            if (!lineXPattern.equals(other.lineXPattern)) return false;
            if (!lastLinePattern.equals(other.lastLinePattern)) return false;
            if (!name.equals(other.name)) return false;

            return true;
        }
    }
    Vector<PatternInfo> knownPatterns = new Vector<PatternInfo>();
    
    protected boolean loadPatterns()
    {
        
        mClassSetting++;
        jComboBoxPatterns.setModel(new DefaultComboBoxModel(knownPatterns));
        mClassSetting--;
        try
        {
            knownPatterns = (Vector<PatternInfo>) CSAMainFrame.deserialize(Global.mainPathPrefix+"serialize"+File.separator+"PatternInfo.ser");
            if (knownPatterns == null) 
            {
                knownPatterns = new Vector<PatternInfo>();
                return false;
            }
        }
        catch (Throwable e)
        {
            return false;
        }
        mClassSetting++;
        jComboBoxPatterns.setModel(new DefaultComboBoxModel(knownPatterns));
        mClassSetting--;

        return true;
    }
    protected boolean savePatterns()
    {
        PatternInfo ti = new PatternInfo();
        ti.name = jTextFieldPatternName.getText();
        if (ti.name.trim().length() == 0) return false;
        ti.line1Pattern = jTextField8.getText();
        ti.lineXPattern = jTextField10.getText();
        ti.lastLinePattern = jTextField9.getText();
        
        
        for (int i=0; i< knownPatterns.size(); i++)
        {
            if (knownPatterns.elementAt(i).equals(ti)) return true;
        }
        knownPatterns.addElement(ti);
        
        try
        {
            CSAMainFrame.serialize(knownPatterns, Global.mainPathPrefix+"serialize"+File.separator+"PatternInfo.ser");
        }
        catch (Throwable e)
        {
            return false;
        }
        mClassSetting++;
        jComboBoxPatterns.setModel(new DefaultComboBoxModel(knownPatterns));
        jComboBoxPatterns.setSelectedIndex(knownPatterns.size()-1);
        mClassSetting--;
        return true;
    }        
    
    void doInterpret()
    {
        addHistory();
        VeccyInterpreter interpreter = new VeccyInterpreter();
        interpreter.setPatterns(jTextField8.getText(), jTextField10.getText(), jTextField9.getText());
        
        ArrayList<Byte> data = interpreter.setData(jTextArea1.getText());
        if (jCheckBoxMulti.isSelected())
        {
            GFXVectorAnimation newAnim = interpreter.getVectorAnimation();
            jTextArea2.setText(interpreter.toString());

        
            for (GFXVectorList vl: newAnim.list)
            {
                vl.resetDisplay();
                currentAnimation.add(vl);
                selectedAnimationFrameUID = vl.uid;
                preSelectedAnimationFrameUID = selectedAnimationFrameUID;
            }
            redrawAnimation();
            jTextFieldCount.setText(""+currentAnimation.size());        
        }
        else
        {
            GFXVectorList newList = interpreter.getVectorList();
            jTextArea2.setText(interpreter.toString());

            single3dDisplayPanel1.setAnimation(new GFXVectorAnimation());
            single3dDisplayPanel1.setForegroundVectorList(newList);
            single3dDisplayPanel1.setDelay(-1);
            singleVectorPanel1.setForegroundVectorList(newList);
            initFaces();

            jTable1.tableChanged(null);
        }
    }
    public static void fillPatternBox(Vector<PatternInfo> kp)
    {
        if (kp.size() == 0)
        {
            // build default patterns
            PatternInfo pi = new PatternInfo();
            pi.name = "Draw_VLc";
            pi.line1Pattern = "%C0";
            pi.lineXPattern = "%Y %X";
            pi.lastLinePattern = "";
            kp.add(pi);


            pi = new PatternInfo();
            pi.name = "Draw_VL";
            pi.line1Pattern = "";
            pi.lineXPattern = "%Y %X";
            pi.lastLinePattern = "";
            kp.add(pi);

            pi = new PatternInfo();
            pi.name = "Draw_VLcs";
            pi.line1Pattern = "%C0 %I";
            pi.lineXPattern = "%Y %X";
            pi.lastLinePattern = "";
            kp.add(pi);

            pi = new PatternInfo();
            pi.name = "Draw_VLp";
            pi.line1Pattern = "";
            pi.lineXPattern = "%P %Y %X";
            pi.lastLinePattern = "%+";
            kp.add(pi);

            pi = new PatternInfo();
            pi.name = "Draw_VL_mode";
            pi.line1Pattern = "";
            pi.lineXPattern = "%M %Y %X";
            pi.lastLinePattern = "%1";
            kp.add(pi);

            pi = new PatternInfo();
            pi.name = "Mov_Draw_VLc_a";
            pi.line1Pattern = "%C0 %Y %X";
            pi.lineXPattern = "%Y %X";
            pi.lastLinePattern = "";
            kp.add(pi);

            pi = new PatternInfo();
            pi.name = "Mov_Draw_VL_b";
            pi.line1Pattern = "%Y %X";
            pi.lineXPattern = "%Y %X";
            pi.lastLinePattern = "";
            kp.add(pi);
            
            pi = new PatternInfo();
            pi.name = "Mov_Draw_VL_ab";
            pi.line1Pattern = "%Y %X";
            pi.lineXPattern = "%Y %X";
            pi.lastLinePattern = "";
            kp.add(pi);
            
            pi = new PatternInfo();
            pi.name = "Mov_Draw_VL_a";
            pi.line1Pattern = "%Y %X";
            pi.lineXPattern = "%Y %X";
            pi.lastLinePattern = "";
            kp.add(pi);
            
            pi = new PatternInfo();
            pi.name = "Mov_Draw_VL";
            pi.line1Pattern = "%Y %X";
            pi.lineXPattern = "%Y %X";
            pi.lastLinePattern = "";
            kp.add(pi);

            pi = new PatternInfo();
            pi.name = "Mov_Draw_VLcs";
            pi.line1Pattern = "%C0 %I %Y %X";
            pi.lineXPattern = "%Y %X";
            pi.lastLinePattern = "";
            kp.add(pi);
            
            pi = new PatternInfo();
            pi.name = "Draw_Sync";
            pi.line1Pattern = "";
            pi.lineXPattern = "%S %SY %SX";
            pi.lastLinePattern = "%2";
            kp.add(pi);            
            
            pi = new PatternInfo();
            pi.name = "Gyrocks Hershey";
            pi.line1Pattern = "%C0 %I";
            pi.lineXPattern = "%CX1 %CY1";
            pi.lastLinePattern = "";
            kp.add(pi);            

            pi = new PatternInfo();
            pi.name = "Gyrocks Objects";
            pi.line1Pattern = "%C0";
            pi.lineXPattern = "%CX- %CY-";
            pi.lastLinePattern = "";
            kp.add(pi);            
        }
        
    }
    
    void fillStatus()
    {
        
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        jTextFieldVectorCount.setText(""+vl.size());
        jTextFieldVectorCount.setToolTipText(""+vl.getMoveCount()+" move vectors");
        jCheckBoxSameIntensity.setSelected(vl.isAllSameIntensity());
        jCheckBoxSamePattern.setSelected(vl.isAllSamePattern());
        jCheckBoxHighPattern.setSelected(vl.isAllPatternHigh(false));
        jCheckBox2dOnly.setSelected(vl.isPure2d());
        jCheckBoxVectorsContinuous.setSelected(vl.isCompleteRelative());
        jCheckBoxVectorClosedPolygon.setSelected(vl.isClosed());
        jCheckBoxVectorOrderedClosedPolygon.setSelected(vl.isOrderedClosed());
        jCheckBoxOnePath.setSelected(vl.isOnePath());
        jTextFieldXMin.setText(""+vl.getXMin());
        jTextFieldYMin.setText(""+vl.getYMin());
        jTextFieldZMin.setText(""+vl.getZMin());
        jTextFieldXMax.setText(""+vl.getXMax());
        jTextFieldYMax.setText(""+vl.getYMax());
        jTextFieldZMax.setText(""+vl.getZMax());
        jTextFieldXMaxLength.setText(""+vl.getXMaxLength());
        jTextFieldYMaxLength.setText(""+vl.getYMaxLength());
        jTextFieldZMaxLength.setText(""+vl.getZMaxLength());
        
        if (vl.getXMaxLength()>127)
            jTextFieldXMaxLength.setForeground(Color.red);
        else
            jTextFieldXMaxLength.setForeground(Color.black);
        if (vl.getYMaxLength()>127)
            jTextFieldYMaxLength.setForeground(Color.red);
        else
            jTextFieldYMaxLength.setForeground(Color.black);
        if (vl.getZMaxLength()>127)
            jTextFieldZMaxLength.setForeground(Color.red);
        else
            jTextFieldZMaxLength.setForeground(Color.black);
        
        
        // export vectorlist
        jButtonMov_Draw_VLc_a.setEnabled(true);
        jButtonDraw_VLc.setEnabled(true);
        jButtonDraw_VLp.setEnabled(true);
        jButtonDraw_VL_mode.setEnabled(true);
        jButtonCodeGen.setEnabled(true);
        if (!jCheckBoxSamePattern.isSelected())
        {
            jButtonMov_Draw_VLc_a.setEnabled(false);
            jButtonDraw_VLc.setEnabled(false);
        }
        if (!jCheckBoxVectorsContinuous.isSelected() || !jCheckBoxOnePath.isSelected())
        {
            jButtonMov_Draw_VLc_a.setEnabled(false);
            jButtonDraw_VLc.setEnabled(false);
            jButtonDraw_VLp.setEnabled(false);
            jButtonDraw_VL_mode.setEnabled(false);
            jButtonCodeGen.setEnabled(false);
        }
        if (!vl.testOrdered())
        {
            jButtonMov_Draw_VLc_a.setEnabled(false);
            jButtonDraw_VLc.setEnabled(false);
            jButtonDraw_VLp.setEnabled(false);
            jButtonDraw_VL_mode.setEnabled(false);
            jButtonCodeGen.setEnabled(false);
        }
       
//        if (!vl.isAllPatternHigh(true))
//        {
//            jButtonDraw_VLp.setEnabled(false);
//        }
    
        if ((vl.getXMaxLength()>127) || (vl.getYMaxLength()>127)|| (vl.getZMaxLength()>127))
        {
            jButtonMov_Draw_VLc_a.setEnabled(false);
            jButtonDraw_VLc.setEnabled(false);
            jButtonDraw_VLp.setEnabled(false);
            jButtonDraw_VL_mode.setEnabled(false);
        }

        checkAnimExportButtons();
        
    }
    void pathsAsScenario()
    {
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        ArrayList<GFXVectorList> subLists = vl.seperatePaths();
        
        for (GFXVectorList vl2 : subLists)
        {
            vl2.resetDisplay();
            currentAnimation.add(vl2);
        }
        currentAnimation.isAnimation = false;
        redrawAnimation();
        mClassSetting++;
        jRadioButtonScenario.setSelected(true);
        mClassSetting--;
        jTextFieldCount.setText(""+currentAnimation.size());
    }
    void highlightAsStart()
    {
        Vertex here = singleVectorPanel1.getHighlightedVPoint();
        if (here==null) return;
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        vl.setPointZero(here);
        vl.setRelativeWherePossible();
    }

    void checkAssemblerButton()
    {
        boolean enabled = jTextAreaResult.getText().contains("; HEADER SECTION");
        jButtonAssemble.setEnabled(enabled);
        jButtonEditInVedi.setEnabled((jTextAreaResult.getText().length() > 0));
    }
    void checkAssemblerButton2()
    {
        boolean enabled = jTextAreaResult1.getText().contains("; HEADER SECTION");
        jButtonAssemble1.setEnabled(enabled);
        jButtonEditInVedi1.setEnabled((jTextAreaResult1.getText().length() > 0));
    }

    
    Thread one = null;
    public boolean  asmStarted = false;
    public boolean stop = false;
    public boolean running = false;
    public boolean pausing = false;

    // start a thread for assembler
    public void startASM(final String filenameASM)
    {
        if (asmStarted) return;
        asmStarted = true;
        jButtonAssemble.setEnabled(false);
        jButtonAssemble1.setEnabled(false);
        jButtonAssembleSM.setEnabled(false);
        // paranoia!
        if (one != null) return;
        one = new Thread() 
        {
            public void run() 
            {
                try 
                {
                    Thread.sleep(10);
                    try
                    {
                        Asmj asm = new Asmj(filenameASM, null, null, null, null, "",null);
                        String info = asm.getInfo();
                        final boolean asmOk = info.indexOf("0 errors detected.") >=0;
                        
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                asmResult(asmOk);
                            }
                        });                    
                    }
                    catch (final Throwable e)
                    {
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                log.addLog(e, WARN);
                                asmResult(false);
                            }
                        });                    
                    }
                } 
                catch(InterruptedException v) 
                {
                }

                one = null;
                jButtonAssemble.setEnabled(true);
                asmStarted = false;
            }  
        };

        one.setName("Run ASMJ with: "+filenameASM);
        one.start();           
    }    
    protected void asmResult(boolean asmOk)
    {
        if (asmOk)
        {
            VecXPanel vec = ((CSAMainFrame)mParent).getVecxy();
            ((CSAMainFrame)mParent).getInternalFrame(vec).toFront();

            String fname = Global.mainPathPrefix+"tmp"+File.separator+"veccytmp.bin";
            vec.startUp(fname);
            log.addLog("Vecci-Assembly successfull...", INFO);
            if (jCheckBox12.isSelected())
            {
                boolean ok = checkVec4EverFile(fname);
            }
        }
        else
        {
            log.addLog("Vecci-Assembly not successfull, see ASM output...", WARN);
        }
        checkAssemblerButton();
        checkAssemblerButton2();
        checkAssemblerButtonSM();
    }
    
    public boolean checkVec4EverFile(String fname)
    {
        
        if (!checkVec4EverVolume(false)) return false;
        boolean ok = de.malban.util.UtilityFiles.copyOneFile(fname, config.v4eVolumeName+File.separator+"cart.bin");
        if (!ok)
        {
            log.addLog("V4E: error copying file to RAMDISK: "+de.malban.util.UtilityFiles.error, WARN);
            return false;
        }
        else
        {
            log.addLog("V4E: bin file copied to RAM DISK", INFO);
            return ejectVec4Ever();
        }
    }
    boolean ejectVec4Ever()
    {
        boolean available = checkVec4EverVolume(false);
        if (!available)
        {
            jLabel10.setForeground(config.valueChanged);
            return false;
        }
        boolean ok = de.malban.util.UtilityFiles.ejectVolume(config.v4eVolumeName);
        if (!ok)
        {
            log.addLog("V4E: RAM DISK not ejected", WARN);
            return false;
        }
        else
        {
            log.addLog("V4E: RAM DISK ejected", INFO);
        }
        return true;
    }    
    public boolean checkVec4EverVolume(boolean verbose)
    {
        try
        {
            Path path = Paths.get(config.v4eVolumeName);
            File directory = path.toFile();

            // get all the files from a directory
            File[] fList = directory.listFiles();
            // sanitiy check for "README.TXT" on top level
            for (File file : fList) 
            {
                if (file.getName().contains("README.TXT"))
                {
                    String readmetxt = de.malban.util.UtilityString.readTextFileToOneString(file);
                    if (readmetxt.contains("Sontowski"))
                    {
                        log.addLog("V4E: RAM DISK volume found.", INFO);
                        return true; 
                    }
                }
            }
            
        }
        catch (Throwable e)
        {
            if (verbose)
                log.addLog("V4E: RAM DISK volume not found.", INFO);
        }
        return false;
    }    
    void fitByteRangeCollection()
    {
        double max = currentAnimation.getMaxAbsLenValue();
        // a current list
//        centerVectorList();
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();

 if (max==0) max = vl.getMaxAbsLenValue();
 if (max == 0) max  =1;
        
        if (jCheckBoxFraktion1.isSelected())
        {
            double mul = 127.0/max;
            HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();
            vl.scaleAll(mul, safetyMap);
        }

        // b current animation
        if (jCheckBoxFraktion1.isSelected())
        {
            double mul = 127.0/max;
            HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();
            currentAnimation.scaleAll(mul, safetyMap);
        }
        redrawAnimation();
    }    
    int getA(Vertex p1, Vertex p2, Vertex p3)
    {
        int x1 = (int)p1.x();
        int y1 = (int)p1.y();
        int z1 = (int)p1.z();
        int x2 = (int)p2.x();
        int y2 = (int)p2.y();
        int z2 = (int)p2.z();
        int x3 = (int)p3.x();
        int y3 = (int)p3.y();
        int z3 = (int)p3.z();
        int A = y1*(z2-z3) + y2*(z3-z1)+y3*(z1-z2);
        return A;
    }
    int getB(Vertex p1, Vertex p2, Vertex p3)
    {
        int x1 = (int)p1.x();
        int y1 = (int)p1.y();
        int z1 = (int)p1.z();
        int x2 = (int)p2.x();
        int y2 = (int)p2.y();
        int z2 = (int)p2.z();
        int x3 = (int)p3.x();
        int y3 = (int)p3.y();
        int z3 = (int)p3.z();
        int B = z1*(x2-x3) + z2*(x3-x1)+z3*(x1-x2);
        return B;
    }
    int getC(Vertex p1, Vertex p2, Vertex p3)
    {
        int x1 = (int)p1.x();
        int y1 = (int)p1.y();
        int z1 = (int)p1.z();
        int x2 = (int)p2.x();
        int y2 = (int)p2.y();
        int z2 = (int)p2.z();
        int x3 = (int)p3.x();
        int y3 = (int)p3.y();
        int z3 = (int)p3.z();
        int C = x1*(y2-y3) + x2*(y3-y1)+x3*(y1-y2);
        return C;
    }
    int getD(Vertex p1, Vertex p2, Vertex p3)
    {
        int x1 = (int)p1.x();
        int y1 = (int)p1.y();
        int z1 = (int)p1.z();
        int x2 = (int)p2.x();
        int y2 = (int)p2.y();
        int z2 = (int)p2.z();
        int x3 = (int)p3.x();
        int y3 = (int)p3.y();
        int z3 = (int)p3.z();
        int D =-( x1*(y2*z3 - y3*z2) +x2*(y3*z1-y1*z3) +x3*(y1*z2-y2*z1));
        return D;
    }

    // if possible find a set of non colinear points, that
    // determine a plane
    ArrayList<Vertex> getPlaneDefinition(ArrayList<Vertex> listOfPoints)
    {
        if (listOfPoints.size()<3) return null;
        for (int p1 =0; p1<listOfPoints.size();p1++)
        {
            for (int p2 =1; p2<listOfPoints.size();p2++)
            {
                for (int p3 =2; p3<listOfPoints.size();p3++)
                {
                    int A = getA(listOfPoints.get(p1), listOfPoints.get(p2), listOfPoints.get(p3));
                    int B = getB(listOfPoints.get(p1), listOfPoints.get(p2), listOfPoints.get(p3));
                    int C = getC(listOfPoints.get(p1), listOfPoints.get(p2), listOfPoints.get(p3));
                    int D = getD(listOfPoints.get(p1), listOfPoints.get(p2), listOfPoints.get(p3));

                    // if the points are colinear,  ABC = 0!
                    if (!((A==0) && (B==0) && (C==0)))
                    {
                        ArrayList<Vertex> list = new ArrayList<Vertex>();
                        list.add(listOfPoints.get(p1));
                        list.add(listOfPoints.get(p2));
                        list.add(listOfPoints.get(p3));
                        return list;
                    }
                }
            }
        }
        return null;
    }
    
    
    boolean isCoplanar(ArrayList<Vertex> listOfPoints)
    {
        if (listOfPoints.size()<=3)
        {
            // trivial
            return true;
        }
        ArrayList<Vertex> plane = getPlaneDefinition(listOfPoints);
        // all points lie on a line
        if (plane == null)
        {
            // nearly trivial
            return true;
        }
        // plane defining determinats
        int A = getA(plane.get(0), plane.get(1), plane.get(2));
        int B = getB(plane.get(0), plane.get(1), plane.get(2));
        int C = getC(plane.get(0), plane.get(1), plane.get(2));
        int D = getD(plane.get(0), plane.get(1), plane.get(2));

        // test all points
        for (Vertex p:listOfPoints)
        {
            int test = A*((int)p.x()) + B*((int)p.y()) + C*((int)p.z()) +D;
            if (test != 0)
            {
                return false;
            }
        }
        return true;
    }    
    void addFace(ArrayList<Vertex> listOfPoints)
    {
        Face face = new Face();
        int newId = getNewFaceId();
        face.faceID = newId;
        
        String id = ""+newId;
        int pos = 0;
        for (Vertex v: listOfPoints)
        {
            v.face.add(id+"|"+pos);
            pos++;
        }
        face.vertice = (ArrayList<Vertex>) listOfPoints;
        
        String idString = face.getPointsString();
        
        boolean doubleFace = false;
        
        for (Face otherFace: faces)
        {
            String otherIdString = otherFace.getPointsString();
            if (idString.equals(otherIdString))
            {
                doubleFace = true;
                break;
            }
        }
        if (doubleFace) return;
        faces.add(face);
        resetFaceTable();
    }
    public class FaceTableModel extends AbstractTableModel
    {
        public final String[] NAMES = new String[] {"id","uids", "points"};
        @Override
        public int getColumnCount() { return 3;}
        @Override
        public int getRowCount() { return faces.size();}
        @Override
        public Object getValueAt(int row, int col) { 
          if (col == 0) return faces.get(row).faceID;
          if (col == 1) return faces.get(row).getUidsString();
          if (col == 2) return faces.get(row).getPointsString();
          return "-";
        }
        
        @Override
        public boolean isCellEditable(int row, int col) {
            return false;
        }
        
        @Override
        public Class<?> getColumnClass(int col) 
        {
            if (col == 0) return Integer.class;
            if (col == 1) return String.class;
            if (col == 2) return String.class;
            return Object.class;
        }
        
        public void setValueAt(Object aValue, int row, int col)
        {
        }
        
        public String getColumnName(int col) 
        {
          return NAMES[col];
        }
    };    

    
    void verifyFaces()
    {
        boolean removed = false;
        ArrayList<Face> toRemove = new ArrayList<Face>();
        for (Face f: faces)
        {
            if (!isCoplanar(f.vertice))
            {
                toRemove.add(f);
            }
            for (Vertex v: f.vertice)
            {
                if (!singleVectorPanel1.getForegroundVectorList().contains(v))
                {
                    toRemove.add(f);
                    break;
                }
            }
            
        }
        for (Face f: toRemove)
        {
            removeFace(f);
            removed = true;
        }
        if (removed)
            resetFaceTable();
        else
            jTableFace.repaint();
    }
    // removes in table selected face "lines"
    void removeFaces()
    {
        boolean removed = false;
        ArrayList<Face> toRemove = new ArrayList<Face>();
        int[] selected = jTableFace.getSelectedRows();
        for (int i=selected.length-1; i>=0; i--)
        {
            toRemove.add(faces.get(selected[i]));
        }
        for (Face f: toRemove)
        {
            removeFace(f);
            removed = true;
        }
        if (removed)
            resetFaceTable();
    }
    
    // alters arraylist "faces"
    void removeFace(Face face)
    {
        faces.remove(face);
        int pos = 0;
        for (Vertex v: face.vertice)
        {
            v.face.remove(""+face.faceID+"|"+pos);
            pos++;
        }
    }
    int getNewFaceId()
    {
        int id = 0;
        boolean faceIdunique=true;
        
        do 
        {
            id++;
            faceIdunique = true;
            for (Face f: faces)
            {
                if (f.faceID == id) 
                {
                    faceIdunique=false;
                    break;
                }
            }
            
        }while (!faceIdunique);
        
        return id;
    }
    
    void initFaces()
    {
        faces = singleVectorPanel1.getForegroundVectorList().buildFacelist();
        verifyFaces();
        resetFaceTable();
    }
    void resetFaceTable()
    {
        int widthAll = jTableFace.getWidth();
        jTableFace.tableChanged(null);
        jTableFace.getColumnModel().getColumn(0).setMaxWidth(40);
        jTableFace.getColumnModel().getColumn(1).setMaxWidth(200);
        jTableFace.getColumnModel().getColumn(2).setMaxWidth(widthAll-40-200);
        jTableFace.repaint();
    }
    
    void faceSelectionChanged()
    {
        // todo select points of face (when in point mode)
        if (!jRadioButtonSelectPoint.isSelected()) return;
        
        // deleselect all
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        for (int i=0; i<listNow.size(); i++)
        {
            GFXVector v = listNow.get(i);
            v.selected = false;
            if (v.start != null)
                v.start.selected = false;
            if (v.end != null)
                v.end.selected = false;
        }
        
        // select vertice
        int[] selected = jTableFace.getSelectedRows();
        for (int i=selected.length-1; i>=0; i--)
        {
            Face face = faces.get(selected[i]);
            for (Vertex v: face.vertice)
            {
                v.selected = true;
            }
        }
        jTable1.repaint();
        singleVectorPanel1.sharedRepaint();
    }
    void loadObject(String fullPath)
    {
        boolean ok = false;

        
        ArrayList<Vertex> vertexList = new ArrayList<Vertex>();
        ArrayList<Face> faceList = new ArrayList<Face>();        
        try 
        {
            BufferedReader br = new BufferedReader(new FileReader(fullPath));
            try 
            {
                StringBuilder sb = new StringBuilder();
                String line = br.readLine();
                while (line != null) 
                {
                    doOneObjectLine(line, vertexList, faceList);
                    line = br.readLine();
                }
                ok = true;
            } 
            catch (Throwable ex)
            {
                // ignore
                log.addLog(ex, WARN);
            }
            finally 
            {
                br.close();
            }        
        } 
        catch (Throwable ex)
        {
            // ignore
            ok = false;
        }
        if (!ok) return;
        
        
        addHistory();
        singleVectorPanel1.clearVectors();
        
        scaleAndRound(faceList, 127);
        
        GFXVectorList vlist = buildVectorList(faceList);
        
        if (!jCheckBoxDontRemoveDoubles.isSelected())
            vlist.removeDoubles();
        singleVectorPanel1.setForegroundVectorList(vlist);
        
        jTable1.tableChanged(null);
        initFaces();
        fillStatus();
    }
    void doOneObjectLine(String line, ArrayList<Vertex> vertexList, ArrayList<Face> faceList)
    {
        // easy - ignore all lines that do not start with 'v' (vertec) or 'f' (face)
        line = line.toLowerCase().trim();
        line = de.malban.util.UtilityString.replaceWhiteSpaces(line, " ");
        line = de.malban.util.UtilityString.replace(line,"  "," ");
        
        // no vertex when faces have begun!
        if (line.startsWith("v ")) 
        {
            //if (faceList.size()>0) return; // stay in for relative references
            line = line.substring(2).trim(); // remove "v "
            String[] coords = line.split(" ");
            if (coords.length<3) 
            {
                log.addLog("Load OBJ, v line with less than 3 parameters", WARN);
                return; // at least three coordinates
            }
            Vertex vertex = new Vertex();
            vertex.x(de.malban.util.UtilityString.DoubleX(coords[0], 0));
            vertex.y(de.malban.util.UtilityString.DoubleX(coords[1], 0));
            vertex.z(de.malban.util.UtilityString.DoubleX(coords[2], 0));
//System.out.println("Vertex read: "+coords[0]+", "+coords[1]+", "+coords[2]);            
//System.out.println("Vertex value: "+vertex);            
            vertexList.add(vertex);
        }
        else if (line.startsWith("f "))
        {
            line = line.substring(2).trim(); // remove "f "
            String[] vertexNo = line.split(" ");
            Face face = new Face();
            face.type = Face.FACE;
            for (int i=0; i<vertexNo.length; i++)
            {
                String no = vertexNo[i];
                if (no.contains("/"))
                {
                    no = no.substring(0, no.indexOf("/"));
                }
                int noI = de.malban.util.UtilityString.Int0(no.trim());
                if (noI==0) 
                {
                    log.addLog("Load OBJ, f with 0 (zero) vertex reference", WARN);
                    continue; // something is wrong
                }
                else if (noI>0)
                {
                    if (noI>vertexList.size()) 
                    {
                        log.addLog("Load OBJ, f with to large vertex reference ("+noI+")", WARN);
                        continue; // something is wrong
                    }
                    noI--; // start at 1
                    face.vertice.add(vertexList.get(noI));
                }
                else if (noI<0)
                {
                    noI = vertexList.size()-noI;
                    if (noI<0) 
                    {
                        log.addLog("Load OBJ, f with out of bounds relative reference ("+noI+")", WARN);
                        continue; // something is wrong
                    }
                    face.vertice.add(vertexList.get(noI));
                }
            }
            faceList.add(face);
        }
        else if (line.startsWith("p "))
        {
            line = line.substring(2).trim(); // remove "p "
            String[] vertexNo = line.split(" ");
            Face face = new Face();
            face.type = Face.POINT;
            for (int i=0; i<vertexNo.length; i++)
            {
                String no = vertexNo[i];
                if (no.contains("/"))
                {
                    no = no.substring(0, no.indexOf("/"));
                }
                int noI = de.malban.util.UtilityString.Int0(no.trim());
                if (noI==0) 
                {
                    log.addLog("Load OBJ, p with 0 (zero) vertex reference", WARN);
                    continue; // something is wrong
                }
                else if (noI>0)
                {
                    if (noI>vertexList.size()) 
                    {
                        log.addLog("Load OBJ, p with to large vertex reference ("+noI+")", WARN);
                        continue; // something is wrong
                    }
                    noI--; // start at 1
                    face.vertice.add(vertexList.get(noI));
                }
                else if (noI<0)
                {
                    noI = vertexList.size()-noI;
                    if (noI<0) 
                    {
                        log.addLog("Load OBJ, p with out of bounds relative reference ("+noI+")", WARN);
                        continue; // something is wrong
                    }
                    face.vertice.add(vertexList.get(noI));
                }
            }
            faceList.add(face);
        }    
        else if (line.startsWith("l "))
        {
            line = line.substring(2).trim(); // remove "l "
            String[] vertexNo = line.split(" ");
            Face face = new Face();
            face.type = Face.LINE;
            for (int i=0; i<vertexNo.length; i++)
            {
                String no = vertexNo[i];
                if (no.contains("/"))
                {
                    no = no.substring(0, no.indexOf("/"));
                }
                int noI = de.malban.util.UtilityString.Int0(no.trim());
                if (noI==0) 
                {
                    log.addLog("Load OBJ, l with 0 (zero) vertex reference", WARN);
                    continue; // something is wrong
                }
                else if (noI>0)
                {
                    if (noI>vertexList.size()) 
                    {
                        log.addLog("Load OBJ, l with to large vertex reference ("+noI+")", WARN);
                        continue; // something is wrong
                    }
                    noI--; // start at 1
                    face.vertice.add(vertexList.get(noI));
                }
                else if (noI<0)
                {
                    noI = vertexList.size()-noI;
                    if (noI<0) 
                    {
                        log.addLog("Load OBJ, l with out of bounds relative reference ("+noI+")", WARN);
                        continue; // something is wrong
                    }
                    face.vertice.add(vertexList.get(noI));
                }
            }
            faceList.add(face);
        }    
    }
    GFXVectorList buildVectorList(ArrayList<Face> faceList)
    {
        GFXVectorList vlist = new GFXVectorList();
        int faceCounter = 0;
        for (Face face : faceList)
        {
            int vertexCount = 0;
            faceCounter++;
            Vertex lastVertex = null;
            GFXVector lastVector = null;
            for (Vertex vertex: face.vertice)
            {
                if (face.type == Face.POINT)
                {
                    GFXVector vector = new GFXVector();
                    vector.start = vertex;
                    vector.end = vertex;
                    vlist.add(vector);
                    continue;
                }
                if (face.type == Face.LINE)
                {
                    if (lastVertex == null)
                    {
                        lastVertex = vertex;
                        continue;
                    }
                    
                    GFXVector vector = new GFXVector();
                    vector.start = lastVertex;
                    vector.end = vertex;
                    lastVertex = vertex;
                    vector.start.face.add(""+faceCounter+"|"+0);
                    vector.end.face.add(""+faceCounter+"|"+1);
                    faceCounter++; // lines each have an own "face"
                    if (lastVector!=null)
                    {
                        vector.start_connect = lastVector;
                        vector.uid_start_connect = lastVector.uid;
                        lastVector.end_connect = vector;
                        lastVector.uid_end_connect = vector.uid;
                    }
                    lastVector = vector;
                    vlist.add(vector);
                    continue;
                }
                if (face.type == Face.FACE)
                {
                    if (lastVertex == null)
                    {
                        vertex.face.add(""+faceCounter+"|"+(vertexCount++));
                        lastVertex = vertex;
                        continue;
                    }
                    vertex.face.add(""+faceCounter+"|"+(vertexCount++));
                    
                    GFXVector vector = new GFXVector();
                    vector.start = lastVertex;
                    vector.end = vertex;
                    lastVertex = vertex;
                    if (lastVector!=null)
                    {
                        vector.start_connect = lastVector;
                        vector.uid_start_connect = lastVector.uid;
                        lastVector.end_connect = vector;
                        lastVector.uid_end_connect = vector.uid;
                    }
                    lastVector = vector;
                    vlist.add(vector);
                    continue;
                }            
            }
            // add a connection from last point to first point of a face
            if (face.type == Face.FACE)
            {
                GFXVector vector = new GFXVector();
                vector.start = lastVertex;
                vector.end = face.vertice.get(0);
                {
                    vector.start_connect = lastVector;
                    vector.uid_start_connect = lastVector.uid;
                    lastVector.end_connect = vector;
                    lastVector.uid_end_connect = vector.uid;
                }
                vlist.add(vector);
            }
            
            
        }
        return vlist;
    }
    // scale the loaded floats to "maxVal" and round to "integer"
    void scaleAndRound(ArrayList<Face> faceList, int maxVal)
    {
        double max = 0;
        for (Face face : faceList)
        {
            for (Vertex vertex: face.vertice)
            {
                if (Math.abs(vertex.x())>max) max = vertex.x();
                if (Math.abs(vertex.y())>max) max = vertex.y();
                if (Math.abs(vertex.z())>max) max = vertex.z();
            }
        }
        HashMap<Vertex, Vertex> safety = new HashMap<Vertex, Vertex>();
        double scale = ((double)maxVal)/max;
        for (Face face : faceList)
        {
            for (Vertex vertex: face.vertice)
            {
                if (safety.get(vertex)==null)
                {
                    safety.put(vertex,vertex);
                    vertex.x((int)(vertex.x()*scale));
                    vertex.y((int)(vertex.y()*scale));
                    vertex.z((int)(vertex.z()*scale));
                }
            }
        }
    }
    public void removeUIListerner()
    {
        UIManager.removePropertyChangeListener(pListener);
    }
    private PropertyChangeListener pListener = new PropertyChangeListener()
    {
        public void propertyChange(PropertyChangeEvent evt)
        {
            updateMyUI();
        }
    };
    void updateMyUI()
    {
        SwingUtilities.updateComponentTreeUI(jPopupMenuPoint);
        SwingUtilities.updateComponentTreeUI(jPopupMenuLine);
        int fontSize = Theme.textFieldFont.getFont().getSize();
        int rowHeight = fontSize+3;
        jTable1.setRowHeight(rowHeight);
        jTableFace.setRowHeight(rowHeight);
    }
    void doSelectionRotation()
    {
        if (!jRadioButtonSelectLine.isSelected()) return;
        addHistory();
        int angleZ = de.malban.util.UtilityString.IntX(jTextFieldRotateZ.getText(), 90);
        int angleY = de.malban.util.UtilityString.IntX(jTextFieldRotateY.getText(), 90);
        int angleX = de.malban.util.UtilityString.IntX(jTextFieldRotateX.getText(), 90);
        
        if (jCheckBoxzrotdir.isSelected())
            angleZ = 360-angleZ;
        if (jCheckBoxxrotdir.isSelected())
            angleX = 360-angleX;
        if (jCheckBoxyrotdir.isSelected())
            angleY = 360-angleY;
        
        
        
        if (!jCheckBox2.isSelected()) angleZ = 0;
        if (!jCheckBox4.isSelected()) angleY = 0;
        if (!jCheckBox3.isSelected()) angleX = 0;
        
        GFXVectorList start = singleVectorPanel1.getForegroundVectorList();

        GFXVectorList newList = start;
        Matrix4x4 rotx = Matrix4x4.getRotationX(Math.toRadians(angleX));
        Matrix4x4 roty = Matrix4x4.getRotationY(Math.toRadians(angleY));
        Matrix4x4 rotz = Matrix4x4.getRotationZ(Math.toRadians(angleZ));

        HashMap<Vertex, Boolean> safetyMap = new HashMap<Vertex, Boolean>();

        for (int c = 0; c <newList.size(); c++)
        {
            GFXVector v = newList.get(c);
            if (!v.selected) continue;
            Vertex p1 = v.start;
            Vertex p2 = v.end;

            // after rotatation the "border" vectors are not connected any longer...
            if (v.start_connect!=null)
            {
                if (!v.start_connect.selected)
                {
                    GFXVector other = v.start_connect;
                    v.start_connect = null;
                    v.uid_start_connect = -1;
                    v.setRelativ(false);
                    
                    if (other.end.uid == v.start.uid)
                    {
                        other.end = new Vertex(other.end);
                        other.end_connect = null;
                        other.uid_end_connect = -1;
                        other.setRelativ(false);
                    }
                    else if (other.start.uid == v.start.uid)
                    {
                        other.start = new Vertex(other.start);
                        other.start_connect = null;
                        other.uid_start_connect = -1;
                        other.setRelativ(false);
                    }
                }
            }
            if (v.end_connect!=null)
            {
                if (!v.end_connect.selected)
                {
                    GFXVector other = v.end_connect;
                    v.end_connect = null;
                    v.uid_end_connect = -1;
                    v.setRelativ(false);
                    
                    if (other.end.uid == v.end.uid)
                    {
                        other.end = new Vertex(other.end);
                        other.end_connect = null;
                        other.uid_end_connect = -1;
                        other.setRelativ(false);
                    }
                    else if (other.start.uid == v.end.uid)
                    {
                        other.start = new Vertex(other.start);
                        other.start_connect = null;
                        other.uid_start_connect = -1;
                        other.setRelativ(false);
                    }
                }
            }
            
            
            if (safetyMap.get(p1) == null)
            {
                p1 = rotx.multiply(p1);
                p1 = roty.multiply(p1);
                p1 = rotz.multiply(p1);
                p1.coords[0] = Math.round(p1.coords[0]);
                p1.coords[1] = Math.round(p1.coords[1]);
                p1.coords[2] = Math.round(p1.coords[2]);
                safetyMap.put(p1, true);
            }
            if (safetyMap.get(p2) == null)
            {
                p2 = rotx.multiply(p2);
                p2 = roty.multiply(p2);
                p2 = rotz.multiply(p2);
                p2.coords[0] = Math.round(p2.coords[0]);
                p2.coords[1] = Math.round(p2.coords[1]);
                p2.coords[2] = Math.round(p2.coords[2]);
                safetyMap.put(p2, true);
            }

            v.start = p1;
            v.end = p2;            
        }
        singleVectorPanel1.sharedRepaint();
        
        
        
        verifyFaces();
   //     jTable1.tableChanged(null);
        jTable1.repaint();
        fillStatus();
        if (jCheckBoxAutoApply.isSelected()) applyChanges();        
    }
    public void deIconified() { }

    private void try3dOut(boolean shift)
    {
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname.getText();
        if (name.trim().length() == 0) name = "VectorList";
 
        if (jCheckBoxCStyle.isSelected())
        {
            String text = vl.createC3dPattern(name, jCheckBoxAddFactor.isSelected(), jCheckBox3ds.isSelected(),shift, jCheckBoxAbsolut.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "#define BLOW_UP 1\n\n"+text;
            }
            jTextAreaResult.setText(text);
            copy(text);
        }
        else
        {
            String text = vl.createASMMov_Draw_VLc_a(false, name, jCheckBoxAddFactor.isSelected());
            if (jCheckBoxAddFactor.isSelected())
            {
                text = "BLOW_UP EQU 1\n\n"+text;
            }
            if (jCheckBoxRunnable.isSelected())
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "vectorlistDraw_VLc.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main += "\nvData = "+name+"\n";
                text = main +text;
            }
            jTextAreaResult.setText(text);
            copy(text);
            checkAssemblerButton();            
        }        
    }

        
    void buildSmartlist()
    {
        StringBuilder b = new StringBuilder();
        String name = jTextFieldLabelListname2.getText();
        if (name.trim().length() == 0) name = "SM_VectorList";
        b.append(name+"\n");

        if (jCheckBoxFactor.isSelected()) // factor
        {
            int factor = DASM6809.toNumber(jTextField3.getText());
            b.append(jTextFieldLabelFactorName.getText()+" EQU "+"$"+String.format("%02X",factor)+"\n");
        }
        int intensity = DASM6809.toNumber(jTextField1.getText());
        int scale = DASM6809.toNumber(jTextField2.getText());

        if (jCheckBoxIntensity.isSelected()) // intensity
        {
            if (hiLoEnabled)
                b.append("\tdb  $"+String.format("%02X",intensity)+ ",  $" +String.format("%02X", 0) + ", hi("+functionPrefix+"setIntensity), lo("+functionPrefix+"setIntensity)"+"\n");
            else
                b.append("\tdb  $"+String.format("%02X",intensity)+ ",  $" +String.format("%02X", 0) + "\n\tdw "+functionPrefix+"setIntensity)\n");
        }
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        
        if (compileForVB)
        {
            boolean didAddJump = doSmartListOutputVB(b,jCheckBoxFactor.isSelected(), vl, -1);
            if (!didAddJump)
            {
                if (hiLoEnabled)
                {
                    if (jCheckBox13.isSelected())
                        if (lastWasMove)
                           b.append("\tdb  $00, $00,  $00, hi("+functionPrefix+"lastDraw_rts2), lo("+functionPrefix+"lastDraw_rts2)"+"\n");
                        else
                           b.append("\tdb  $fe, $00,  $00, hi("+functionPrefix+"lastDraw_rts2), lo("+functionPrefix+"lastDraw_rts2)"+"\n");
                    else
                        b.append("\tdb  $40, $00,  $00, hi("+functionPrefix+"lastDraw_rts), lo("+functionPrefix+"lastDraw_rts)"+"\n");
                }
                else
                {
                    if (jCheckBox13.isSelected())
                        if (lastWasMove)
                           b.append("\tdb  $00, $00,  $00\n\tdw "+functionPrefix+"lastDraw_rts2\n");
                        else
                           b.append("\tdb  $fe, $00,  $00\n\tdw "+functionPrefix+"lastDraw_rts2\n");
                    else
                        b.append("\tdb  $40, $00,  $00\n\tdw "+functionPrefix+"lastDraw_rts\n");
                }
            }
        }
        else
        {
            
//search for testLowY here
            
            if (useOldSmartlist)
            {
                boolean didAddJump = doSmartListOutput_Org(b,jCheckBoxFactor.isSelected(), vl, -1);
                if (!didAddJump)
                {
                    if (hiLoEnabled)
                        b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + ", hi("+functionPrefix+"lastDraw_rts), lo("+functionPrefix+"lastDraw_rts)"+"\n");
                    else
                        b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + "\n\tdw "+functionPrefix+"lastDraw_rts\n");
                }
            }
            else
            {
                boolean didAddJump = doSmartListOutput(b,jCheckBoxFactor.isSelected(), vl, -1);
                if (!didAddJump)
                {
                    if (hiLoEnabled)
                        b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + ", hi("+functionPrefix+"lastDraw_rts), lo("+functionPrefix+"lastDraw_rts)"+"\n");
                    else
                        b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + "\n\tdw "+functionPrefix+"lastDraw_rts\n");
                }
            }
        }
        
        
        
        if (jCheckBoxRunnable2.isSelected())
        {
            if (useOldSmartlist)
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "smartListDrawOld.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main = de.malban.util.UtilityString.replace(main, "##SCALE##", ""+jTextField2.getText());
                main += "\n_SM_VectorList_ = "+name+"\n";
                jTextAreaResultSM.setText(main + b.toString());
                if (disableCalibration) main = de.malban.util.UtilityString.replace(main, "jsr      calibrationZero", ";jsr      calibrationZero");
            }
            else
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "smartListDraw.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main = de.malban.util.UtilityString.replace(main, "##SCALE##", ""+jTextField2.getText());
                main += "\n_SM_VectorList_ = "+name+"\n";
                if (disableCalibration) main = de.malban.util.UtilityString.replace(main, "jsr      calibrationZero", ";jsr      calibrationZero");
                jTextAreaResultSM.setText(main + b.toString());
            }
            

        }
        else
        {
            jTextAreaResultSM.setText(b.toString());
        }
        updateResult();
        checkAssemblerButtonSM();
    }        
    
    String testForDoubleContinue(String in)
    {
        StringBuilder b = new StringBuilder();
        String[] ins = in.split("\n");
        ArrayList<String> backlog = new ArrayList<String>();
        if (hiLoEnabled)
        {
            for (String line: ins)
            {
                boolean addLine = true;
                boolean tryBacklogging = false;
                if (line.contains("hi("+functionPrefix+"continue_d), lo("+functionPrefix+"continue_d)"))
                {
                    addLine = false;
                    backlog.add(line);
                    if (backlog.size() == MAX_EQUAL_TYPE) 
                    {
                        tryBacklogging = true;
                    }
                }
                else
                    tryBacklogging = true;
                if (tryBacklogging)
                {
                    if (backlog.size() == 1)
                    {
                        b.append(backlog.get(0)).append("\n");
                    }
                    else if (backlog.size() > 1)
                    {
                        for (int i=0; i<backlog.size(); i++)
                        {
                            String l = backlog.get(i);
                            if (i==0)
                            {
                                if (useOldSmartlist)
                                    l = de.malban.util.UtilityString.replace(l, "hi("+functionPrefix+"continue_d), lo("+functionPrefix+"continue_d)", "hi("+functionPrefix+"continue_d"+(backlog.size())+"), lo("+functionPrefix+"continue_d"+(backlog.size())+")");
                                else
                                    l = de.malban.util.UtilityString.replace(l, "hi("+functionPrefix+"continue_d), lo("+functionPrefix+"continue_d)", "hi("+functionPrefix+"continue_d"+(backlog.size()-1)+"), lo("+functionPrefix+"continue_d"+(backlog.size()-1)+")");
                            }
                            else
                            {
                                if (useOldSmartlist)
                                    l = de.malban.util.UtilityString.replace(l, ", hi("+functionPrefix+"continue_d), lo("+functionPrefix+"continue_d)","");
                                else
                                    l = de.malban.util.UtilityString.replace(l, "hi("+functionPrefix+"continue_d), lo("+functionPrefix+"continue_d)","");
                            }
                            b.append(l).append("\n");
                        }
                    }
                    backlog.clear();
                }

                if (addLine)
                    b.append(line).append("\n");
            }



            boolean tryBacklogging = true;
            if (tryBacklogging)
            {
                if (backlog.size() == 1)
                {
                    b.append(backlog.get(0)).append("\n");
                }
                else if (backlog.size() > 1)
                {
                    for (int i=0; i<backlog.size(); i++)
                    {
                        String l = backlog.get(i);
                        if (i==0)
                        {
                            if (useOldSmartlist)
                                l = de.malban.util.UtilityString.replace(l, "hi("+functionPrefix+"continue_d), lo("+functionPrefix+"continue_d)", "hi("+functionPrefix+"continue_d"+(backlog.size())+"), lo("+functionPrefix+"continue_d"+(backlog.size())+")");
                            else
                                l = de.malban.util.UtilityString.replace(l, "hi("+functionPrefix+"continue_d), lo("+functionPrefix+"continue_d)", "hi("+functionPrefix+"continue_d"+(backlog.size()-1)+"), lo("+functionPrefix+"continue_d"+(backlog.size()-1)+")");
                        }
                        else
                        {
                            if (useOldSmartlist)
                                l = de.malban.util.UtilityString.replace(l, ", hi("+functionPrefix+"continue_d), lo("+functionPrefix+"continue_d)","");
                            else
                                l = de.malban.util.UtilityString.replace(l, "hi("+functionPrefix+"continue_d), lo("+functionPrefix+"continue_d)","");
                        }
                        b.append(l).append("\n");
                    }
                }
                backlog.clear();
            }
        }
        else //if (hiLoEnabled)
        {
            for (String line: ins)
            {
                boolean addLine = true;
                boolean tryBacklogging = false;
                if (line.contains("dw "+functionPrefix+"continue_d"))
                {
                    addLine = false;
                    backlog.add(line);
                    if (backlog.size() == MAX_EQUAL_TYPE) 
                    {
                        tryBacklogging = true;
                    }
                }
                else
                    tryBacklogging = true;
                if (tryBacklogging)
                {
                    if (backlog.size() == 1)
                    {
                        b.append(backlog.get(0)).append("\n");
                    }
                    else if (backlog.size() > 1)
                    {
                        for (int i=0; i<backlog.size(); i++)
                        {
                            String l = backlog.get(i);
                            if (i==0)
                            {
                                if (useOldSmartlist)
                                    l = de.malban.util.UtilityString.replace(l, "dw "+functionPrefix+"continue_d", "dw "+functionPrefix+"continue_d"+(backlog.size())+"");
                                else
                                    l = de.malban.util.UtilityString.replace(l, "dw "+functionPrefix+"continue_d", "dw "+functionPrefix+"continue_d"+(backlog.size()-1)+"");
                            }
                            else
                            {
                                if (useOldSmartlist)
                                    l = de.malban.util.UtilityString.replace(l, "\tdw "+functionPrefix+"continue_d","");
                                else
                                    l = de.malban.util.UtilityString.replace(l, "\tdw "+functionPrefix+"continue_d","");
                            }
                            b.append(l).append("\n");
                        }
                    }
                    backlog.clear();
                }

                if (addLine)
                    b.append(line).append("\n");
            }



            boolean tryBacklogging = true;
            if (tryBacklogging)
            {
                if (backlog.size() == 1)
                {
                    b.append(backlog.get(0)).append("\n");
                }
                else if (backlog.size() > 1)
                {
                    for (int i=0; i<backlog.size(); i++)
                    {
                        String l = backlog.get(i);
                        if (i==0)
                        {
                            if (useOldSmartlist)
                                l = de.malban.util.UtilityString.replace(l, "dw "+functionPrefix+"continue_d", "dw "+functionPrefix+"continue_d"+(backlog.size())+"");
                            else
                                l = de.malban.util.UtilityString.replace(l, "dw "+functionPrefix+"continue_d", "dw "+functionPrefix+"continue_d"+(backlog.size()-1)+"");
                        }
                        else
                        {
                            if (useOldSmartlist)
                                l = de.malban.util.UtilityString.replace(l, "\tdw "+functionPrefix+"continue_d","");
                            else
                                l = de.malban.util.UtilityString.replace(l, "\tdw "+functionPrefix+"continue_d","");
                        }
                        b.append(l).append("\n");
                    }
                }
                backlog.clear();
            }
        }
        return b.toString();
    }
		
		
    void buildSmartAnimlist()
    {
        String orgName = jTextFieldLabelListname2.getText();
        String name = "AnimList";
        if (orgName.length()!=0) name = orgName;

        StringBuilder table = new StringBuilder();
        StringBuilder source = new StringBuilder();
        
        
        int count = 0;
        for (GFXVectorList vl : currentAnimation.list)
        {
            table.append(" "+GFXVectorList.getDW()+" "+name+"_"+count);
            if (count == 0)
                table.append(" ; list of all single vectorlists in this");
            table.append("\n");
            
      //      jTextFieldLabelListname2.setText(name+"_"+count);
            /*** ***/
            StringBuilder b = new StringBuilder();

            b.append(name+"_"+count+"\n");

            if (jCheckBoxFactor.isSelected()) // factor
            {
                int factor = DASM6809.toNumber(jTextField3.getText());
                b.append(jTextFieldLabelFactorName.getText()+" EQU "+"$"+String.format("%02X",factor)+"\n");
            }
            int intensity = DASM6809.toNumber(jTextField1.getText());
            int scale = DASM6809.toNumber(jTextField2.getText());

            if (jCheckBoxIntensity.isSelected()) // intensity
            {
                if (hiLoEnabled)
                    b.append("\tdb  $"+String.format("%02X",intensity)+ ",  $" +String.format("%02X", 0) + ", hi("+functionPrefix+"setIntensity), lo("+functionPrefix+"setIntensity)"+"\n");
                else
                    b.append("\tdb  $"+String.format("%02X",intensity)+ ",  $" +String.format("%02X", 0) + "\n\tdw "+functionPrefix+"setIntensity\n");
            }
            if (compileForVB)
            {
                boolean printFinal = doSmartListOutputVB(b,jCheckBoxFactor.isSelected(), vl, count);
                if (!printFinal)
                    if (jCheckBox13.isSelected())
                        if (lastWasMove)
                        {
                            if (hiLoEnabled)
                                b.append("\tdb  $00, $00,  $00, hi("+functionPrefix+"lastDraw_rts2), lo("+functionPrefix+"lastDraw_rts2)"+"\n");
                            else
                                b.append("\tdb  $00, $00,  $00\n\tdw "+functionPrefix+"lastDraw_rts2\n");
                        }
                        else
                        {
                            if (hiLoEnabled)
                                b.append("\tdb  $fe, $00,  $00, hi("+functionPrefix+"lastDraw_rts2), lo("+functionPrefix+"lastDraw_rts2)"+"\n");
                            else
                                b.append("\tdb  $fe, $00,  $00\n\tdw "+functionPrefix+"lastDraw_rts2\n");
                        }
                    else
                    {
                        if (hiLoEnabled)
                            b.append("\tdb  $40, $00,  $00, hi("+functionPrefix+"lastDraw_rts), lo("+functionPrefix+"lastDraw_rts)"+"\n");
                        else
                            b.append("\tdb  $40, $00,  $00\n\tdw "+functionPrefix+"lastDraw_rts\n");
                    }
            }
            else
            {

                if (useOldSmartlist)
                {
                    boolean printFinal = doSmartListOutput_Org(b,jCheckBoxFactor.isSelected(), vl, count);
                    if (!printFinal)
                    {
                        if (hiLoEnabled)
                            b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + ", hi("+functionPrefix+"lastDraw_rts), lo("+functionPrefix+"lastDraw_rts)"+"\n");
                        else
                            b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + "\n\tdw "+functionPrefix+"lastDraw_rts\n");
                    }
                }
                else
                {
                    boolean printFinal = doSmartListOutput(b,jCheckBoxFactor.isSelected(), vl, count);
                    if (!printFinal)
                    {
                        if (hiLoEnabled)
                            b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + ", hi("+functionPrefix+"lastDraw_rts), lo("+functionPrefix+"lastDraw_rts)"+"\n");
                        else
                            b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + "\n\tdw "+functionPrefix+"lastDraw_rts\n");
                    }
                }
            }
                
            /*** ***/
            
            source.append( b.toString() );
            
            count++;
        }
        table.append(" DW 0\n\n");
        table.append(source);
        
        
        if (jCheckBoxRunnable2.isSelected())
        {

            if (useOldSmartlist)
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "smartListAnimOld.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main = de.malban.util.UtilityString.replace(main, "##SCALE##", ""+jTextField2.getText());
                if (disableCalibration) main = de.malban.util.UtilityString.replace(main, "jsr      calibrationZero", ";jsr      calibrationZero");
                jTextAreaResultSM.setText(main + table.toString());
            }
            else
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "smartListAnim.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main = de.malban.util.UtilityString.replace(main, "##SCALE##", ""+jTextField2.getText());
                if (disableCalibration) main = de.malban.util.UtilityString.replace(main, "jsr      calibrationZero", ";jsr      calibrationZero");
                jTextAreaResultSM.setText(main + table.toString());
            }
        }
        else
        {
            jTextAreaResultSM.setText(table.toString());
        }
        updateResult();
        checkAssemblerButtonSM();        
    }

    void buildSmartScenarioList()
    {
        String orgName = jTextFieldLabelListname2.getText();
        String name = "ScenList";
        if (orgName.length()!=0) name = orgName;

        StringBuilder table = new StringBuilder();
        StringBuilder source = new StringBuilder();
        
        
        int count = 0;
        for (GFXVectorList vl : currentAnimation.list)
        {
            table.append(" "+GFXVectorList.getDW()+" "+name+"_"+count);
            if (count == 0)
                table.append(" ; list of all single vectorlists in this");
            table.append("\n");
            
            /*** ***/
            StringBuilder b = new StringBuilder();

            b.append(name+"_"+count+"\n");

            if (jCheckBoxFactor.isSelected()) // factor
            {
                int factor = DASM6809.toNumber(jTextField3.getText());
                b.append(jTextFieldLabelFactorName.getText()+" EQU "+"$"+String.format("%02X",factor)+"\n");
            }
            int intensity = DASM6809.toNumber(jTextField1.getText());
            int scale = DASM6809.toNumber(jTextField2.getText());

            if (jCheckBoxIntensity.isSelected()) // intensity
            {
                if (compileForVB)
                {
                    if (hiLoEnabled)
                        b.append("\tdb  $"+String.format("%02X",intensity)+ ",  $" +String.format("%02X", 0)+ ",  $" +String.format("%02X", 0) + ", hi("+functionPrefix+"setIntensity), lo("+functionPrefix+"setIntensity)"+"\n");
                    else
                        b.append("\tdb  $"+String.format("%02X",intensity)+ ",  $" +String.format("%02X", 0)+ ",  $" +String.format("%02X", 0) + "\n\t dw"+functionPrefix+"setIntensity\n");
                }
                else
                {
                    if (hiLoEnabled)
                        b.append("\tdb  $"+String.format("%02X",intensity)+ ",  $" +String.format("%02X", 0) + ", hi("+functionPrefix+"setIntensity), lo("+functionPrefix+"setIntensity)"+"\n");
                    else
                        b.append("\tdb  $"+String.format("%02X",intensity)+ ",  $" +String.format("%02X", 0) + "\n\tdw "+functionPrefix+"setIntensity\n");
                }
            }
            
            if (compileForVB)
            {
                boolean printFinal = doSmartListOutputVB(b,jCheckBoxFactor.isSelected(), vl, count);
                if (!printFinal)
                {
                    if (jCheckBox13.isSelected())
                        if (lastWasMove)
                        {
                            if (hiLoEnabled)
                                b.append("\tdb  $00, $00,  $00, hi("+functionPrefix+"lastDraw_rts2), lo("+functionPrefix+"lastDraw_rts2)"+"\n");
                            else
                                b.append("\tdb  $00, $00,  $00\n\tdw "+functionPrefix+"lastDraw_rts2\n");
                        }
                        else
                        {
                            if (hiLoEnabled)
                               b.append("\tdb  $fe, $00,  $00, hi("+functionPrefix+"lastDraw_rts2), lo("+functionPrefix+"lastDraw_rts2)"+"\n");
                            else
                               b.append("\tdb  $fe, $00,  $00 \n\tdw "+functionPrefix+"lastDraw_rts2\n");
                        }
                    else
                    {
                        if (hiLoEnabled)
                            b.append("\tdb  $40, $00,  $00, hi("+functionPrefix+"lastDraw_rts), lo("+functionPrefix+"lastDraw_rts)"+"\n");
                        else
                            b.append("\tdb  $40, $00,  $00\n\tdw "+functionPrefix+"lastDraw_rts\n");
                    }
                }
            }
            else
            {

                if (useOldSmartlist)
                {
                    boolean printFinal = doSmartListOutput_Org(b,jCheckBoxFactor.isSelected(), vl, count);
                    if (!printFinal)
                    {
                        if (hiLoEnabled)
                            b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + ", hi("+functionPrefix+"lastDraw_rts), lo("+functionPrefix+"lastDraw_rts)"+"\n");
                        else
                            b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + "\n\tdw "+functionPrefix+"lastDraw_rts\n");
                    }
                }
                else
                {
                    boolean printFinal = doSmartListOutput(b,jCheckBoxFactor.isSelected(), vl, count);
                    if (!printFinal)
                    {
                        if (hiLoEnabled)
                            b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + ", hi("+functionPrefix+"lastDraw_rts), lo("+functionPrefix+"lastDraw_rts)"+"\n");
                        else
                            b.append("\tdb  $"+String.format("%02X",0)+ ",  $" +String.format("%02X",0) + "\n\tdw "+functionPrefix+"lastDraw_rts\n");
                    }
                }
            }            

            
            /*** ***/
            
            source.append( b.toString() );
            
            count++;
        }
        table.append(" DW 0\n\n");
        table.append(source);
        
        
        
        if (jCheckBoxRunnable2.isSelected())
        {
            if (useOldSmartlist)
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "smartListScenarioOld.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main = de.malban.util.UtilityString.replace(main, "##SCALE##", ""+jTextField2.getText());
                if (disableCalibration) main = de.malban.util.UtilityString.replace(main, "jsr      calibrationZero", ";jsr      calibrationZero");
                jTextAreaResultSM.setText(main + table.toString());
            }
            else
            {
                Path template = Paths.get(Global.mainPathPrefix, "template", "smartListScenario.template");
                String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                main = de.malban.util.UtilityString.replace(main, "##SCALE##", ""+jTextField2.getText());
                if (disableCalibration) main = de.malban.util.UtilityString.replace(main, "jsr      calibrationZero", ";jsr      calibrationZero");
                jTextAreaResultSM.setText(main + table.toString());
            }
            
        }
        else
        {
            jTextAreaResultSM.setText(table.toString());
        }
        updateResult();
        checkAssemblerButtonSM();        
    }


    
    class SVector
    {
        int y;
        int x;
        boolean isVisible;
    }

    // ensures max length added is 127                
    void addToList(ArrayList<SVector> sList, SVector sv)  
    {
        int aX = Math.abs(sv.x);
        int aY = Math.abs(sv.y);
        int max = aX>aY?aX:aY;
        if (max<127)
        {
            sList.add(sv);
            return;
        }
        SVector sv1 = new SVector();
        sv1.isVisible = sv.isVisible;
        sv1.y = sv.y/2;
        sv1.x = sv.x/2;
        SVector sv2 = new SVector();
        sv2.isVisible = sv.isVisible;
        if (!divideEqually)
        {
            sv2.y = sv.y-sv1.y;
            sv2.x = sv.x-sv1.x;
        }
        else
        {
            sv2.y = sv1.y;
            sv2.x = sv1.x;
        }
		

        addToList(sList, sv1);
        addToList(sList, sv2);
    }
    
    String db(int i)
    {
        String ret ="";
        i = i&0xff;
        boolean neg = (i>127);
        if (neg) ret = "-$"+String.format("%02X",-(i-256));
        else ret = " $"+String.format("%02X",i);
        return ret;
    }
    
    // returns true if a stackjump happened
    boolean doSmartListOutput_Org(StringBuilder b, boolean hasFactor, GFXVectorList vl, int count)
    {
        
        // list of delta vectors
        ArrayList<SVector> sList = new ArrayList<SVector>();
        
        int lastUID = -1;
        String factorString ="";
        if (hasFactor) factorString =jTextFieldLabelFactorName.getText()+"*";
        
        // first  step build a relative vector koordinate list from
        // current vector list
        // list in SVectors
        boolean isInitialMove = true;

        int lastX = 0;
        int lastY = 0;
        for (GFXVector v: vl.list)
        {
            SVector sv = new SVector();
            Vertex start = v.start;
            Vertex end = v.end;
            
            boolean cont = (start.uid == lastUID);
            
            if (!cont)
            {
                // than we must move to location of V1
                // either from current location
                // or by zeroing
                // smartlists don't zero -> therefore from current location
                sv.x = (int) (start.x() - lastX);
                sv.y = (int) (start.y() - lastY);
                    
                sv.isVisible = false;

                if ((jCheckBoxNoInitialMove.isSelected()) && (isInitialMove))
                {

                }
                else
                {
                    addToList(sList, sv);
                }
                

                sv = new SVector();
                lastX = (int) start.x();
                lastY = (int) start.y();
            }
                
            sv.x = (int) (end.x() - start.x());
            sv.y = (int) (end.y() - start.y());
            sv.isVisible = (v.pattern != 0);
            addToList(sList, sv);
            lastX = (int) end.x();
            lastY = (int) end.y();
            
            if (end != null)
                lastUID = end.uid;
            else
                lastUID = -1;
            isInitialMove = false;
        }
        
        
        // go trhu the list of relative coorinates we just generate and do something smart
        
        lastX = 256; // impossible values
        lastY = 256;
        boolean lastVisible = false;
        int inc = 0;
        boolean doStackJump = false;

        for (int listIndex = 0; listIndex<sList.size(); listIndex++)
        {
            boolean done = false;
            SVector v = sList.get(listIndex);
            int nextX = 256; // impossible values
            int nextY = 256;
            boolean nextVisible = !v.isVisible;
            if (listIndex+1<sList.size())
            {
                nextX = sList.get(listIndex+1).x;
                nextY = sList.get(listIndex+1).y;
                nextVisible = sList.get(listIndex+1).isVisible;
            }

            // TODO ALL KINDS OF SMARTNESS!
            
            if ((0 == v.y) && (0 == v.x))
            {
                continue;
            }
            if (v.isVisible) isInitialMove=false;
            
            boolean skipMove = isInitialMove && jCheckBoxNoInitialMove.isSelected();
            
            String stackJumpAdd1 = "";
            String stackJumpAdd2 = "";
            if (jCheckBoxStackJump.isSelected())
            {
                //if (!v.isVisible)
                {
                    if (listIndex+1>=sList.size())
                    {
                        doStackJump = true;
                        stackJumpAdd1 = "_sj";
                        if (count>=0)
                        {
                            if (hiLoEnabled)
                                stackJumpAdd2 = ", hi("+jTextFieldLabelStackJumpName.getText()+count+"), lo("+jTextFieldLabelStackJumpName.getText()+count+")";
                            else
                                stackJumpAdd2 = "\n\tdw "+jTextFieldLabelStackJumpName.getText()+count+"";
                        }
                        else
                        {
                            if (hiLoEnabled)
                                stackJumpAdd2 = ", hi("+jTextFieldLabelStackJumpName.getText()+"), lo("+jTextFieldLabelStackJumpName.getText()+")";
                            else
                                stackJumpAdd2 = "\n\tdw "+jTextFieldLabelStackJumpName.getText()+"";
                        }
                    }
                }
            }
            
            
            /* ************* */
            if (((nextY == v.y) && (nextX == v.x)) && (nextVisible == v.isVisible))
            {
                boolean localStackJump = doStackJump;
                String stackJumpAdd1Local = stackJumpAdd1;
                String stackJumpAdd2Local = stackJumpAdd2;
                if (jCheckBoxStackJump.isSelected())
                {
                    //if (!v.isVisible)
                    {
                        if (listIndex+2>=sList.size())
                        {
                            localStackJump = true;
                            stackJumpAdd1Local = "_sj";
                            if (count>=0)
                            {
                                if (hiLoEnabled)
                                    stackJumpAdd2Local = ", hi("+jTextFieldLabelStackJumpName.getText()+count+"), lo("+jTextFieldLabelStackJumpName.getText()+count+")";
                                else
                                    stackJumpAdd2Local = "\n\tdw "+jTextFieldLabelStackJumpName.getText()+count+"";
                            }
                            else
                            {
                                if (hiLoEnabled)
                                    stackJumpAdd2Local = ", hi("+jTextFieldLabelStackJumpName.getText()+"), lo("+jTextFieldLabelStackJumpName.getText()+")";
                                else
                                    stackJumpAdd2Local = "\n\tdw "+jTextFieldLabelStackJumpName.getText()+"";
                            }
                        }
                    }
                }
                
                
                
                
                // two identical vectors
                if (v.isVisible == lastVisible) 
                {
                    done = true;
                    listIndex++;
                    if (v.x == 0)
                    {
                        if (!skipMove)
                        {
                            if (hiLoEnabled)
                                b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"continue_d_double_x0), lo("+functionPrefix+"continue_d_double_x0)"+"\n");
                            else
                                b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"continue_d_double_x0\n");
                        }
                    }
                    else
                    {
                        if (v.y == 0)
                        {
                            if (!skipMove)
                            {
                                if (hiLoEnabled)
                                    b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"continue_d_double_y0), lo("+functionPrefix+"continue_d_double_y0)"+"\n");
                                else
                                    b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"continue_d_double_y0\n");
                            }
                        }
                        else
                        {
                            if (!skipMove)
                            {
                                if (hiLoEnabled)
                                    b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"continue_d_double), lo("+functionPrefix+"continue_d_double)"+"\n");
                                else
                                    b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"continue_d_double\n");
                            }
                        }
                    }
                }
                else
                {
                    done = true;
                    listIndex++;
                    if (v.isVisible)
                    {
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"startDraw_d_double"+stackJumpAdd1Local+"), lo("+functionPrefix+"startDraw_d_double"+stackJumpAdd1Local+")"+stackJumpAdd2Local+"\n");
                        else
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"startDraw_d_double"+stackJumpAdd1Local+""+stackJumpAdd2Local+"\n");
                    }
                    else
                    {
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"startMove_d_double"+stackJumpAdd1Local+"), lo("+functionPrefix+"startMove_d_double"+stackJumpAdd1Local+")"+stackJumpAdd2Local+"\n");
                        else
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"startMove_d_double"+stackJumpAdd1Local+""+stackJumpAdd2Local+"\n");
                    }
                    doStackJump = localStackJump;
                }
            }
            if (done)
            {
                lastY = v.y;
                lastX = v.x;
                lastVisible = v.isVisible;
                continue;
            }
            /* ************* */
            if (lastY == v.y)
            {
                // y stays the same
                if (v.isVisible)
                {
                    if (lastVisible)
                    {
                        done = true;
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(0)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"draw_only_XChanges), lo("+functionPrefix+"draw_only_XChanges)"+"; y was "+db(v.y)+"\n");
                        else
                            b.append("\tdb "+factorString+db(0)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"draw_only_XChanges; y was "+db(v.y)+"\n");
                    }
                }
                else
                {
                    if (!lastVisible)
                    {
                        done = true;
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(0)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"draw_only_XChanges), lo("+functionPrefix+"draw_only_XChanges)"+"; y was "+db(v.y)+"\n");
                        else
                            b.append("\tdb "+factorString+db(0)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"draw_only_XChanges; y was "+db(v.y)+"\n");
                    }
                }
            }
            if (done)
            {
                lastY = v.y;
                lastX = v.x;
                lastVisible = v.isVisible;
                continue;
            }
            /* ************* */
            if (v.y == v.x)
            {
                if (lastVisible == v.isVisible)
                {
                    if (!skipMove)
                    {
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(0)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"continue_yEqx), lo("+functionPrefix+"continue_yEqx)"+"; y was "+db(v.y)+"\n");
                        else
                            b.append("\tdb "+factorString+db(0)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"continue_yEqx; y was "+db(v.y)+"\n");
                        done = true;
                    }
                }
            }
            if (done)
            {
                lastY = v.y;
                lastX = v.x;
                lastVisible = v.isVisible;
                continue;
            }
            /* ************* */
            if (v.y == lastX)
            {
                if (lastVisible == v.isVisible)
                {
                    if (!skipMove)
                    {
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(0)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"continue_newY_eq_oldX), lo("+functionPrefix+"continue_newY_eq_oldX)"+"; y was "+db(v.y)+"\n");
                        else
                            b.append("\tdb "+factorString+db(0)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"continue_newY_eq_oldX; y was "+db(v.y)+"\n");
                        done = true;
                    }
                }
            }
            if (done)
            {
                lastY = v.y;
                lastX = v.x;
                lastVisible = v.isVisible;
                continue;
            }
                
            /* ************* */
            if (v.x == 0)
            {
                if (lastVisible == v.isVisible)
                {
                    if (!skipMove)
                    {
                        if (stackJumpAdd1.length()!=0)
                        {
                            if (hiLoEnabled)
                                b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"continue_d_x0"+stackJumpAdd1+"), lo("+functionPrefix+"continue_d_x0"+stackJumpAdd1+")"+stackJumpAdd2+"\n");
                            else
                                b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"continue_d_x0"+stackJumpAdd1+""+stackJumpAdd2+"\n");
                        }
                        else
                        {
                            if (hiLoEnabled)
                                b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"continue_d_x0), lo("+functionPrefix+"continue_d_x0)"+"\n");
                            else
                                b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"continue_d_x0\n");
                        }
                        done = true;
                    }
                }
                else
                {
                    if (v.isVisible)
                    {
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"startDraw_d_x0), lo("+functionPrefix+"startDraw_d_x0)"+"\n");
                        else
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"startDraw_d_x0\n");
                        done = true;
                    }
                    else
                    {
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"startMove_d_x0"+stackJumpAdd1+"), lo("+functionPrefix+"startMove_d_x0"+stackJumpAdd1+")"+stackJumpAdd2+"\n");
                        else
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"startMove_d_x0"+stackJumpAdd1+""+stackJumpAdd2+"\n");
                        done = true;
                    }
                }
            }
            if (done)
            {
                lastY = v.y;
                lastX = v.x;
                lastVisible = v.isVisible;
                continue;
            }
            /* ************* */
            if (v.y == 0)
            {
                if (lastVisible == v.isVisible)
                {
                    if (!skipMove)
                    {
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"continue_d_y0), lo("+functionPrefix+"continue_d_y0)"+"\n");
                        else
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"continue_d_y0\n");
                        done = true;
                    }
                }
                else
                {
                    if (v.isVisible)
                    {
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"startDraw_d_y0), lo("+functionPrefix+"startDraw_d_y0)"+"\n");
                        else
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"startDraw_d_y0\n");
                        done = true;
                    }
                    else
                    {
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"startMove_d_y0"+stackJumpAdd1+"), lo("+functionPrefix+"startMove_d_y0"+stackJumpAdd1+")"+stackJumpAdd2+"\n");
                        else
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"startMove_d_y0"+stackJumpAdd1+""+stackJumpAdd2+"\n");
                        done = true;
                    }
                }
            }
            if (done)
            {
                lastY = v.y;
                lastX = v.x;
                lastVisible = v.isVisible;
                continue;
            }
            
            
            /* ************* */            
            if (v.isVisible)
            {
                if (lastVisible)
                {
                    if (hiLoEnabled)
                        b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"continue_d), lo("+functionPrefix+"continue_d)"+"\n");
                    else
                        b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"continue_d\n");
                }
                else
                {
                    if (hiLoEnabled)
                        b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"startDraw_d"+stackJumpAdd1+"), lo("+functionPrefix+"startDraw_d"+stackJumpAdd1+")"+stackJumpAdd2+"\n");
                    else
                        b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"startDraw_d"+stackJumpAdd1+""+stackJumpAdd2+"\n");
                }
            }
            else
            {
                if (lastVisible)
                {
                    if (hiLoEnabled)
                        b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"startMove_d"+stackJumpAdd1+"), lo("+functionPrefix+"startMove_d"+stackJumpAdd1+")"+stackJumpAdd2+"\n");
                    else
                        b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"startMove_d"+stackJumpAdd1+""+stackJumpAdd2+"\n");
                }
                else
                {
                    if (!skipMove)
                    {
                        if (hiLoEnabled)
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + ", hi("+functionPrefix+"continue_d), lo("+functionPrefix+"continue_d)"+"\n");
                        else
                            b.append("\tdb "+factorString+db(v.y)+ ", "+factorString +db(v.x) + "\n\tdw "+functionPrefix+"continue_d\n");
                    }
                }
            }
            
            lastY = v.y;
            lastX = v.x;
            lastVisible = v.isVisible;
        }        
//BYTE_ADR macro pointer
// hi(pointer), lo(pointer)
// endm
        String fin = testForDoubleContinue(b.toString());
        b.replace(0, b.length(), fin);
        
        // SM_startMove_d
        // SM_startDraw_d
        // SM_continue (ignore d)
        // SM_continue_double (ignore d)
        // SM_continue_d
        // SM_continue_d_double
        // SM_repeat_same
        // SM_continue_newY_eq_oldX
        // SM_continue_only_XChanges
        return doStackJump;
    }
    

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	final int V_START_DRAW = 1; // 0 = MOVE
	final int V_START_MOVE = 2; // 0 = MOVE
	final int V_CONTINUE = 4; // 0 = MOVE
	final int V_STACKJUMP = 8; // 0 = MOVE
	final int V_SAME_X = 16;
	final int V_SAME_Y = 32;
	final int V_VISIBLE = 64;
	final int V_WAS_DIVIDED = 128;
	final int V_CHANGE_INTENSITY = 256;
	final int V_LAST = 512;
        final int V_Y_SAME_OLDX = 1024;
        final int V_START_SEQUENCE =2048; // value in scount
        final int V_CONTINNUE_SEQUENCE =4096;
        final int V_HIGH_NEGATIVE_Y =8192;


	
	final int V_ALLTYPES = V_START_DRAW+V_START_MOVE+V_CONTINUE+V_STACKJUMP+V_SAME_X+V_SAME_Y+V_VISIBLE+V_WAS_DIVIDED+V_CHANGE_INTENSITY+V_LAST+V_Y_SAME_OLDX+V_START_SEQUENCE+V_CONTINNUE_SEQUENCE+V_HIGH_NEGATIVE_Y;
	
	boolean divideEqually = false;
	boolean doIntensities = false;
	int intensityMax = 0x7f;
	int intensityMin = 0x1f;
	int intensitySteps = 0x5;
	String factorStringNew = "";
        boolean useOldSmartlist = false;
        boolean compileForVB = false;
        int usedScale = 9;
        int currentIntensity;
        String functionPrefix = "SM_";
        boolean noShift = false;
        int MAX_EQUAL_TYPE = 7;
        boolean lastWasMove = true;
        boolean testLowY = false;
        boolean hiLoEnabled = true;
        int ythreshold = -80;
        int smartMax = 127;
        boolean disableCalibration = false;
        void getParameters()
        {
            hiLoEnabled = !jCheckBoxNoHiLo.isSelected();
            
            divideEqually = jCheckBox9.isSelected();
            doIntensities = jCheckBox10.isSelected();
            intensityMax = DASM6809.toNumber(jTextField7.getText());
            intensityMin = DASM6809.toNumber(jTextField6.getText());
            smartMax = DASM6809.toNumber(jTextFieldSmartMax.getText());
            disableCalibration = jCheckBox14.isSelected();
            intensitySteps = DASM6809.toNumber(jTextField11.getText());
            if (jCheckBoxFactor.isSelected())
                factorStringNew = jTextFieldLabelFactorName.getText()+"*";
            else factorStringNew="";
            useOldSmartlist = jCheckBox11.isSelected();
            usedScale  = DASM6809.toNumber(jTextField2.getText());
            currentIntensity = intensityMax;
            compileForVB = jCheckBoxCompileForVB.isSelected();
            functionPrefix = jTextField12.getText();
            if (!jCheckBoxCompileForVB.isSelected())
                functionPrefix = "SM_";
            noShift = jCheckBoxNoShift.isSelected();
            MAX_EQUAL_TYPE = 7;
            lastWasMove = true;
            testLowY = jCheckBox15.isSelected();
            ythreshold = DASM6809.toNumber(jTextField13.getText(), true);
        }
        
        
	int getIntensity(int len, int iMin, int iMax, int iSteps)
	{
            if (iSteps <= 1) return iMax;
            if (iSteps == 2) return len>63?iMax:iMin;
            if (len <0) len = len *-1;
            int lenRelative = 127 / iSteps;
            
            int c=1;
            int lenSum = c*lenRelative;
            while (len > lenSum)
            {
                lenSum = (c++)*lenRelative;
            }
            c--; //compensate start 1
            // in c "index" of intensity

            int iDif = (iMax-iMin)/iSteps;
            int iRet = iMin + iDif*(c);

            if (iRet>iMax) return iMax;
            if (iRet<iMin) return iMin;
            return iRet;
	}
	
    // ensures max length added is 127                
    void addToList2(ArrayList<SmartVector> sList, SmartVector sv)  
    {
        int aX = Math.abs(sv.relX);
        int aY = Math.abs(sv.relY);
        
        // don't add 0 moves!
        if ((aX == 0) && (aY==0)) return;
        int max = aX>aY?aX:aY;
        if (max<=smartMax)
        {
            sList.add(sv);
            return;
        }
        
        if (max/2 <=smartMax)
        {
            SmartVector sv1 = new SmartVector();
            sv1.type = sv.type;
            sv1.relY = sv.relY/2;
            sv1.relX = sv.relX/2;
            sv1.type = sv1.type | V_WAS_DIVIDED;
            SmartVector sv2 = new SmartVector();
            sv2.type = sv1.type;
            if (divideEqually)
            {
                sv2.relY = sv1.relY;
                sv2.relX = sv1.relX;
            }
            else
            {
                sv2.relY = sv.relY-sv1.relY;
                sv2.relX = sv.relX-sv1.relX;
            }

            addToList2(sList, sv1);
            addToList2(sList, sv2);
            return;
        }
        if (max/3 <=smartMax)
        {
            SmartVector sv1 = new SmartVector();
            SmartVector sv2 = new SmartVector();
            SmartVector sv3 = new SmartVector();
            sv1.type = sv.type;
            sv1.relY = sv.relY/3;
            sv1.relX = sv.relX/3;
            sv1.type = sv1.type | V_WAS_DIVIDED;

            sv2.type = sv1.type;
            sv3.type = sv1.type;
            if (divideEqually)
            {
                sv2.relY = sv1.relY;
                sv2.relX = sv1.relX;
                sv3.relY = sv1.relY;
                sv3.relX = sv1.relX;
            }
            else
            {
                sv2.relY = sv.relY/3;
                sv2.relX = sv.relY/3;
                
                sv3.relY = sv.relY-sv1.relY-sv2.relY;
                sv3.relX = sv.relX-sv1.relX-sv2.relX;
            }

            addToList2(sList, sv1);
            addToList2(sList, sv2);
            addToList2(sList, sv3);
            return;
        }
//        if (max/4 <=127)
        {
            SmartVector sv1 = new SmartVector();
            sv1.type = sv.type;
            sv1.relY = sv.relY/2;
            sv1.relX = sv.relX/2;
            sv1.type = sv1.type | V_WAS_DIVIDED;
            SmartVector sv2 = new SmartVector();
            sv2.type = sv1.type;
            if (divideEqually)
            {
                sv2.relY = sv1.relY;
                sv2.relX = sv1.relX;
            }
            else
            {
                sv2.relY = sv.relY-sv1.relY;
                sv2.relX = sv.relX-sv1.relX;
            }

            addToList2(sList, sv1);
            addToList2(sList, sv2);
            return;
        }
    }
    class SmartVector
    {
        public int type=0;
        public int relY;
        public int relX;
        public int count=1;
        public int len = 0;
        public int intensity = 0;
        public int sequenceCount = 0;
    }

    boolean doNewStackJump  = false;
    // returns true if a stackjump happened
    boolean doSmartListOutputVB(StringBuilder b, boolean hasFactor, GFXVectorList vl, int count)
    {
        return doSmartListOutput_( b,  hasFactor,  vl,  count, true);
    }
    boolean doSmartListOutput(StringBuilder b, boolean hasFactor, GFXVectorList vl, int count)
    {
        return doSmartListOutput_( b,  hasFactor,  vl,  count, false);
    }
    boolean doSmartListOutput_(StringBuilder b, boolean hasFactor, GFXVectorList vl, int count, boolean vb)
    {
		// list of delta vectors
        ArrayList<SmartVector> sList = new ArrayList<SmartVector>();
        doNewStackJump = false;
        int lastUID = -1;
        String factorString ="";
        
        if (jCheckBoxFactor.isSelected())
            if (hasFactor) factorString =jTextFieldLabelFactorName.getText()+"*";
        
        // first  step build a relative vector coordinate list from
        // current vector list
        // list in SVectors
        boolean isInitialMove = true;

        int lastX = 0;
        int lastY = 0;
        for (GFXVector v: vl.list)
        {
            SmartVector sv = new SmartVector();
            Vertex start = v.start;
            Vertex end = v.end;
            
            boolean cont = (start.uid == lastUID);
            
            if (!cont)
            {
                // than we must move to location of V1
                // either from current location
                // or by zeroing
                // smartlists don't zero -> therefore from current location
                sv.relX = (int) (start.x() - lastX);
                sv.relY = (int) (start.y() - lastY);
                    
                sv.type = sv.type & (V_ALLTYPES - V_VISIBLE);

                if ((jCheckBoxNoInitialMove.isSelected()) && (isInitialMove))
                {

                }
                else
                {
                    addToList2(sList, sv);
                }
                sv = new SmartVector();
                lastX = (int) start.x();
                lastY = (int) start.y();
            }
                
            sv.relX = (int) (end.x() - start.x());
            sv.relY = (int) (end.y() - start.y());
            if (v.pattern != 0)
                sv.type = sv.type | V_VISIBLE;
            addToList2(sList, sv);
            lastX = (int) end.x();
            lastY = (int) end.y();
            
            if (end != null)
                lastUID = end.uid;
            else
                lastUID = -1;
            isInitialMove = false;
        }

        boolean finished = false;

        // insertCounts
        do
        {
            lastX = 256; // impossible values
            lastY = 256;
            int listIndex = 0;
            for (; listIndex<sList.size(); listIndex++)
            {
                boolean done = false;
                SmartVector v = sList.get(listIndex);

                int nextX = 256; // impossible values
                int nextY = 256;
                boolean thisVisibility = (v.type & V_VISIBLE) == V_VISIBLE;
                
                boolean nextVisible = thisVisibility; // default current
                if (listIndex+1<sList.size())
                {
                    nextX = sList.get(listIndex+1).relX;
                    nextY = sList.get(listIndex+1).relY;
                    nextVisible = (sList.get(listIndex+1).type & V_VISIBLE)== V_VISIBLE;
                }
                if (((nextY == v.relY) && (nextX == v.relX)) && (nextVisible == thisVisibility))
                {
                    v.count++;
                    sList.remove(listIndex+1);
                    break;
                }

            }
            finished = listIndex==sList.size();

        } while (!finished);

        // now the final vectors WERE generated, look further for similarities
        lastX = 256; // impossible values
        lastY = 256;
        int listIndex = 0;

        if (sList.size()>0)
        {
            // first first is continue move/ or start draw
            boolean thisVisibility = (sList.get(0).type & V_VISIBLE) == V_VISIBLE;
            if (thisVisibility)
            {
                sList.get(0).type = sList.get(0).type | V_START_DRAW;
                sList.get(0).type = sList.get(0).type & (V_ALLTYPES - V_CONTINUE);
            }
            else
            {
                sList.get(0).type = sList.get(0).type | V_CONTINUE;
                sList.get(0).type = sList.get(0).type & (V_ALLTYPES - V_START_DRAW);
            }
            sList.get(sList.size()-1).type = sList.get(sList.size()-1).type | V_LAST;
        }
        
        int lastYTest = 0;
        for (; listIndex<sList.size(); listIndex++)
        {
            SmartVector v = sList.get(listIndex);

            if (testLowY)
            {
                if (v.relY - lastYTest< ythreshold)
                {
                    v.type = v.type | V_HIGH_NEGATIVE_Y;
                }
/*
                if ((lastYTest < 0) && (lastYTest<v.relY))
                {
                    v.type = v.type | V_HIGH_NEGATIVE_Y;
                }
*/                
                lastYTest = v.relY;
            }
            
            int nextX = 256; // impossible values
            int nextY = 256;
            boolean thisVisibility = (v.type & V_VISIBLE) == V_VISIBLE;
            boolean nextVisible = thisVisibility; // default current
            if (listIndex+1<sList.size())
            {
                nextX = sList.get(listIndex+1).relX;
                nextY = sList.get(listIndex+1).relY;
                nextVisible = (sList.get(listIndex+1).type & V_VISIBLE)== V_VISIBLE;
            }

            if (nextVisible != thisVisibility)
            {
                if (nextVisible)
                {
                    sList.get(listIndex+1).type = sList.get(listIndex+1).type | V_START_DRAW;
                    sList.get(listIndex+1).type = sList.get(listIndex+1).type & (V_ALLTYPES - V_CONTINUE);
                }
                else
                {
                    sList.get(listIndex+1).type = sList.get(listIndex+1).type | V_START_MOVE;
                    sList.get(listIndex+1).type = sList.get(listIndex+1).type & (V_ALLTYPES - V_CONTINUE);
                }
            }
            else
            {
                if (listIndex+1<sList.size())
                {
                    sList.get(listIndex+1).type = sList.get(listIndex+1).type & (V_ALLTYPES - V_START_DRAW);
                    sList.get(listIndex+1).type = sList.get(listIndex+1).type & (V_ALLTYPES - V_START_MOVE);
                    sList.get(listIndex+1).type = sList.get(listIndex+1).type | V_CONTINUE;
                }
            }

            if (nextY == v.relY)
            {
                if (listIndex+1<sList.size())
                    sList.get(listIndex+1).type = sList.get(listIndex+1).type | V_SAME_Y;
            }
            if (nextX == v.relX)
            {
                if (listIndex+1<sList.size())
                    sList.get(listIndex+1).type = sList.get(listIndex+1).type | V_SAME_X;
            }
            if (nextY == v.relX)
            {
                if (listIndex+1<sList.size())
                    sList.get(listIndex+1).type = sList.get(listIndex+1).type | V_Y_SAME_OLDX;
            }
            
            if (jCheckBoxStackJump.isSelected())
            {
                if (listIndex+1>=sList.size())
                {
                    v.type = v.type | V_STACKJUMP;
                }
            }
            
            v.len = Math.abs(v.relY)>Math.abs(v.relX)?Math.abs(v.relY):Math.abs(v.relX);
            v.intensity = getIntensity(v.len, intensityMin, intensityMax, intensitySteps);
        }

        // loop thru intensity changes if wante4d
        if (doIntensities)
        {
            // assuming last intensity is max
            listIndex = 0;
            for (; listIndex<sList.size(); listIndex++)
            {
                SmartVector v = sList.get(listIndex);
                
                boolean thisVisibility = (v.type & V_VISIBLE) == V_VISIBLE;
                if (!thisVisibility) continue;
                if (v.intensity == currentIntensity) continue;

                currentIntensity = v.intensity;
 
                v.type = v.type | V_CHANGE_INTENSITY;
                v.type = v.type | V_START_DRAW;
                v.type = v.type & (V_ALLTYPES - V_CONTINUE);
                
                // also remove same as old X
                // since X is changed while doing a new intensity
                v.type = v.type & (V_ALLTYPES - V_Y_SAME_OLDX);
            }
        }

        // do same types (d1, - d7)
        listIndex = 0;
        for (; listIndex<sList.size(); listIndex++)
        {
            SmartVector v = sList.get(listIndex);

            int thisType = v.type;
            // not relevant
            thisType = thisType | V_SAME_X;
            thisType = thisType | V_SAME_Y;
            thisType = thisType | V_LAST;
            thisType = thisType | V_Y_SAME_OLDX;
            thisType = thisType | V_WAS_DIVIDED;
            int sequence = 1;
            if (((thisType & V_CONTINUE) == V_CONTINUE)&&(v.count==1))
            {
                while (listIndex+sequence<sList.size())
                {
                    int nextType = sList.get(listIndex+sequence).type;
                    
                    if ((nextType & V_HIGH_NEGATIVE_Y) == V_HIGH_NEGATIVE_Y) break;
                    // not relevant
                    nextType = nextType | V_SAME_X;
                    nextType = nextType | V_SAME_Y;
                    nextType = nextType | V_LAST;
                    nextType = nextType | V_Y_SAME_OLDX;
                    nextType = nextType | V_WAS_DIVIDED;
                    if (sList.get(listIndex+sequence).count != 1)
                        nextType = 0;
                    
                    
                    if (nextType == thisType)
                    {
                        sequence++;
                        if (sequence==MAX_EQUAL_TYPE) 
                            break;
                        continue;
                    }
                    break;
                }
                if (sequence>1)
                {
                    v.type = v.type | V_START_SEQUENCE;
                    v.sequenceCount = sequence;
                    for (int i=listIndex+1; i<listIndex+sequence; i++)
                    {
                        sList.get(i).type = sList.get(i).type | V_CONTINNUE_SEQUENCE;
                    }
                    listIndex += (sequence-1);
                }
            }
        }
        
        
        

        listIndex = 0;
        for (; listIndex<sList.size(); listIndex++)
        {
            SmartVector v = sList.get(listIndex);
            b.append(genOutput(v, count, vb));
        }


        // do WAIT with corrected Macros
        // WAIT2 WAIT3 WAIT4 ...

        // perhaps a "good" RTS with every possibly smartlist?
        String fin = testForDoubleContinue(b.toString());
        b.replace(0, b.length(), fin);
        
        return doNewStackJump;
    }
    String genOutput(SmartVector v, int count, boolean vb)
    {
        String stackJumpAdd1 = "";
        String stackJumpAdd2 = "";
        String ret = "";
        boolean doneARound = false;
        int equalVectorCount = v.count;
        int initialEqualCount = equalVectorCount;
        
        String delayInfo = "";
        if (testLowY)
        {
            if ((v.type & V_HIGH_NEGATIVE_Y) == V_HIGH_NEGATIVE_Y)
            {
                delayInfo = "_yd4";
            }
        }

        
        while (equalVectorCount>0)
        {
            if (!doneARound)
            {
                if ((v.type & V_CHANGE_INTENSITY) == V_CHANGE_INTENSITY)
                {
                    if (hiLoEnabled)
                        ret += "\tdb "+db(v.intensity)+ ", "+0+ ", "+0 + ", hi("+functionPrefix+"LightOff_Intensity), lo("+functionPrefix+"LightOff_Intensity)\n";
                    else
                        ret += "\tdb "+db(v.intensity)+ ", "+0+ ", "+0 + "\n\tdw "+functionPrefix+"LightOff_Intensity\n";
                }
            }
            
            String countAdd = "";
            if (equalVectorCount == 1)
            {
                countAdd = "_single";
                equalVectorCount--;
            }
            else if (equalVectorCount == 2)
            {
                countAdd = "_double";
                equalVectorCount-=2;
            }
            else if (equalVectorCount == 3)
            {
                countAdd = "_tripple";
                equalVectorCount-=3;
            }
            else if (equalVectorCount == 4)
            {
                countAdd = "_quadro";
                equalVectorCount-=4;
            }
            else if (equalVectorCount == 5)
            {
                countAdd = "_quint";
                equalVectorCount-=5;
            }
            else if (equalVectorCount == 6)
            {
                countAdd = "_hex";
                equalVectorCount-=6;
            }
            else if (equalVectorCount == 7)
            {
                countAdd = "_sept";
                equalVectorCount-=7;
            }
            else // if (equalVectorCount == 4)
            {
                countAdd = "_octo";
                equalVectorCount-=8;
            }
            
            
            if (((v.type & V_STACKJUMP) == V_STACKJUMP) && (equalVectorCount == 0))
            {
                stackJumpAdd1 = "_sj";
                if (count>=0)
                {
                    if (hiLoEnabled)
                        stackJumpAdd2 = ", hi("+jTextFieldLabelStackJumpName.getText()+count+"), lo("+jTextFieldLabelStackJumpName.getText()+count+")";
                    else
                        stackJumpAdd2 = "\n\tdw "+jTextFieldLabelStackJumpName.getText()+""+count+"";
                }
                else
                    if (hiLoEnabled)
                        stackJumpAdd2 = ", hi("+jTextFieldLabelStackJumpName.getText()+"), lo("+jTextFieldLabelStackJumpName.getText()+")";
                    else
                        stackJumpAdd2 = "\n\tdw "+jTextFieldLabelStackJumpName.getText();
                doNewStackJump = true;
            }
            String drawType ="";
            if ((v.type & V_START_MOVE) == V_START_MOVE)
            {
                drawType = "startMove"+delayInfo;
            }
            else if ((v.type & V_START_DRAW) == V_START_DRAW)
            {
                drawType = "startDraw"+delayInfo;
            }
            else if ((v.type & V_CONTINUE) == V_CONTINUE)
            {
                drawType = "continue"+delayInfo;
            }
            String vbAdd = "";
            if (vb)
                vbAdd = ", $01";
            boolean done = false;
            if (initialEqualCount == 1)
            {
                if ((v.type & V_START_SEQUENCE) == V_START_SEQUENCE)
                {
                    drawType+=""+v.sequenceCount;
                }
                else if ((v.type & V_CONTINNUE_SEQUENCE) == V_CONTINNUE_SEQUENCE)
                {
                
                }
                else if ((v.type & V_Y_SAME_OLDX) == V_Y_SAME_OLDX)
                {
                    if (drawType.indexOf("startDraw")>=0)
                    {
                        if (noShift)
                        {
                            if (hiLoEnabled)
                                ret += "\tdb $ee"+vbAdd+ ", "+factorStringNew +db(v.relX) + ", hi("+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+" ; y was "+db(v.relY)+", now $ee\n";
                            else
                                ret += "\tdb $ee"+vbAdd+ ", "+factorStringNew +db(v.relX) + "\n\tdw "+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+""+stackJumpAdd2+" ; y was "+db(v.relY)+", now $ee\n";
                        }
                        else
                        {
                            if (hiLoEnabled)
                                ret += "\tdb SHITREG_POKE_VALUE"+vbAdd+ ", "+factorStringNew +db(v.relX) + ", hi("+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+" ; y was "+db(v.relY)+", now SHIFT\n";
                            else
                                ret += "\tdb SHITREG_POKE_VALUE"+vbAdd+ ", "+factorStringNew +db(v.relX) + "\n\tdw "+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+""+stackJumpAdd2+" ; y was "+db(v.relY)+", now SHIFT\n";
                        }
                    }
                    else if (drawType.indexOf("startMove")>=0)
                    {
                        if (noShift)
                        {
                            if (hiLoEnabled)
                                ret += "\tdb  $ce"+vbAdd+ ", "+factorStringNew +db(v.relX) + ", hi("+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+" ; y was "+db(v.relY)+", now $ce\n";
                            else
                                ret += "\tdb  $ce"+vbAdd+ ", "+factorStringNew +db(v.relX) + "\n\tdw "+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+""+stackJumpAdd2+" ; y was "+db(v.relY)+", now $ce\n";
                        }
                        else
                        {
                            if (hiLoEnabled)
                                ret += "\tdb  $00"+vbAdd+ ", "+factorStringNew +db(v.relX) + ", hi("+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+" ; y was "+db(v.relY)+", now 0\n";
                            else
                                ret += "\tdb  $00"+vbAdd+ ", "+factorStringNew +db(v.relX) + "\n\tdw "+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+""+stackJumpAdd2+" ; y was "+db(v.relY)+", now 0\n";
                        }
                    }
                    else
                    {
                        if (hiLoEnabled)
                            ret += "\tdb "+factorStringNew +db(v.relY)+vbAdd+ ", "+factorStringNew +db(v.relX) + ", hi("+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+" ; y is "+db(v.relY)+"\n";
                        else
                            ret += "\tdb "+factorStringNew +db(v.relY)+vbAdd+ ", "+factorStringNew +db(v.relX) + "\n\tdw "+functionPrefix+""+drawType+"_newY_eq_oldX"+countAdd+stackJumpAdd1+""+stackJumpAdd2+" ; y is "+db(v.relY)+"\n";
                    }
                    done = true;
                }
                else if (v.relX == v.relY)
                {
                    if (hiLoEnabled)
                        ret += "\tdb "+factorStringNew +db(v.relY)+vbAdd+ ", "+factorStringNew +db(v.relX) +  ", hi("+functionPrefix+""+drawType+"_yEqx"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_yEqx"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"; y is "+db(v.relY)+"\n";
                    else
                        ret += "\tdb "+factorStringNew +db(v.relY)+vbAdd+ ", "+factorStringNew +db(v.relX) +  "\n\tdw "+functionPrefix+""+drawType+"_yEqx"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"; y is "+db(v.relY)+"\n";
                    done = true;
                }
                else if ((v.relX == 0) && (!vb))
                {
                    if (hiLoEnabled)
                        ret += "\tdb "+factorStringNew+db(v.relY) + vbAdd+ ", "+factorStringNew +db(v.relX)  + ", hi("+functionPrefix+""+drawType+"_x0"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_x0"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"\n";
                    else
                        ret += "\tdb "+factorStringNew+db(v.relY) + vbAdd+ ", "+factorStringNew +db(v.relX)  + "\n\tdw "+functionPrefix+""+drawType+"_x0"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"\n";
                    done = true;
                }
                else if ((v.relY == 0) && (!vb))
                {
                    if (hiLoEnabled)
                        ret += "\tdb "+factorStringNew+db(v.relY) + vbAdd+ ", "+factorStringNew +db(v.relX) + ", hi("+functionPrefix+""+drawType+"_y0"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_y0"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"\n";
                    else
                        ret += "\tdb "+factorStringNew+db(v.relY) + vbAdd+ ", "+factorStringNew +db(v.relX) + "\n\tdw "+functionPrefix+""+drawType+"_y0"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"\n";
                    done = true;
                }
                else if ((v.type & V_SAME_Y) == V_SAME_Y)
                {
                    if ((v.type & V_SAME_X) == V_SAME_X)
                    {
                        if (drawType.indexOf("startMove")>=0)
                        {
                            if (noShift)
                            {
                                if (hiLoEnabled)
                                    ret += "\tdb  $ce"+vbAdd +", $ce , hi("+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"; y was "+db(v.relY)+"; x was "+db(v.relX)+"; y now $CE\n";
                                else
                                    ret += "\tdb  $ce"+vbAdd +", $ce \n\tdw "+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"; y was "+db(v.relY)+"; x was "+db(v.relX)+"; y now $CE\n";
                            }
                            else
                            {
                                if (hiLoEnabled)
                                    ret += "\tdb  $00"+vbAdd +", $ce , hi("+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"; y was "+db(v.relY)+"; x was "+db(v.relX)+"\n";
                                else
                                    ret += "\tdb  $00"+vbAdd +", $ce \n\tdw "+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"; y was "+db(v.relY)+"; x was "+db(v.relX)+"\n";
                            }
                        }
                        else if (drawType.indexOf("startDraw")>=0)
                        {
                            if (noShift)
                            {
                                if (hiLoEnabled)
                                    ret += "\tdb  $ee"+vbAdd +", $ee , hi("+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"; y was "+db(v.relY)+"; x was "+db(v.relX)+", y now $ee\n";
                                else
                                    ret += "\tdb  $ee"+vbAdd +", $ee \n\tdw "+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"; y was "+db(v.relY)+"; x was "+db(v.relX)+", y now $ee\n";
                            }
                            else
                            {
                                if (hiLoEnabled)
                                    ret += "\tdb  SHITREG_POKE_VALUE"+vbAdd +", $ee , hi("+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"; y was "+db(v.relY)+"; x was "+db(v.relX)+", y now SHIFTREG\n";
                                else
                                    ret += "\tdb  SHITREG_POKE_VALUE"+vbAdd +", $ee \n\tdw "+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"; y was "+db(v.relY)+"; x was "+db(v.relX)+", y now SHIFTREG\n";
                            }
                        }
                        else
                        {
                            if (hiLoEnabled)
                                ret += "\tdb  $00"+vbAdd +", $01 , hi("+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"; y was "+db(v.relY)+"; x was "+db(v.relX)+"\n";
                            else
                                ret += "\tdb  $00"+vbAdd +", $01 \n\tdw "+functionPrefix+""+drawType+"_xyStays"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"; y was "+db(v.relY)+"; x was "+db(v.relX)+"\n";
                        }
                        done = true;
                    }
                    else
                    {
                        if (drawType.contains("startDraw"))
                        {
                            if (noShift)
                            {
                                if (hiLoEnabled)
                                    ret += "\tdb  $ee" + vbAdd+", "+factorStringNew +db(v.relX) +", hi("+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"; y was "+db(v.relY)+", now $ee\n";
                                else
                                    ret += "\tdb  $ee" + vbAdd+", "+factorStringNew +db(v.relX) +"\n\tdw "+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"; y was "+db(v.relY)+", now $ee\n";
                            }
                            else
                            {
                                if (hiLoEnabled)
                                    ret += "\tdb  SHITREG_POKE_VALUE" + vbAdd+", "+factorStringNew +db(v.relX) +", hi("+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"; y was "+db(v.relY)+", now SHIFT Poke\n";
                                else
                                    ret += "\tdb  SHITREG_POKE_VALUE" + vbAdd+", "+factorStringNew +db(v.relX) +"\n\tdw "+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"; y was "+db(v.relY)+", now SHIFT Poke\n";
                            }
                        }
                        else if (drawType.contains("startMove"))
                        {
                            if (noShift)
                            {
                                if (hiLoEnabled)
                                    ret += "\tdb  $ce" + vbAdd+", "+factorStringNew +db(v.relX) +", hi("+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"; y was "+db(v.relY)+", now $ce\n";
                                else
                                    ret += "\tdb  $ce" + vbAdd+", "+factorStringNew +db(v.relX) +"\n\tdw "+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"; y was "+db(v.relY)+", now $ce\n";
                            }
                            else
                            {
                                if (hiLoEnabled)
                                    ret += "\tdb  $00" + vbAdd+", "+factorStringNew +db(v.relX) +", hi("+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"; y was "+db(v.relY)+", now 0\n";
                                else
                                    ret += "\tdb  $00" + vbAdd+", "+factorStringNew +db(v.relX) +"\n\tdw "+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"; y was "+db(v.relY)+", now 0\n";
                            }
                        }
                        else 
                        {
                            if (hiLoEnabled)
                                ret += "\tdb "+factorStringNew +db(v.relY) + vbAdd+", "+factorStringNew +db(v.relX) +", hi("+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"; y is "+db(v.relY)+"\n";
                            else
                                ret += "\tdb "+factorStringNew +db(v.relY) + vbAdd+", "+factorStringNew +db(v.relX) +"\n\tdw "+functionPrefix+""+drawType+"_yStays"+countAdd+stackJumpAdd1+""+stackJumpAdd2+"; y is "+db(v.relY)+"\n";
                        }
                        done = true;
                    }
                }
            }
            if (done == false)
            {
                if ((v.type & V_CONTINNUE_SEQUENCE) == V_CONTINNUE_SEQUENCE)
                {
                    ret += "\tdb "+factorStringNew+db(v.relY)+ vbAdd +", "+factorStringNew +db(v.relX) + "\n";
                }
                else
                {
                    if (hiLoEnabled)
                        ret += "\tdb "+factorStringNew+db(v.relY)+ vbAdd +", "+factorStringNew +db(v.relX) + ", hi("+functionPrefix+""+drawType+""+countAdd+stackJumpAdd1+"), lo("+functionPrefix+""+drawType+""+countAdd+stackJumpAdd1+")"+stackJumpAdd2+"\n";
                    else
                        ret += "\tdb "+factorStringNew+db(v.relY)+ vbAdd +", "+factorStringNew +db(v.relX) + "\n\tdw "+functionPrefix+""+drawType+""+countAdd+stackJumpAdd1+""+stackJumpAdd2+"\n";
                }
                
            }

            if (equalVectorCount>0)
            {
                // if the # of same types is not enought
                // remove "start" flag
                if ((v.type & V_START_MOVE) == V_START_MOVE)
                {
                    v.type = v.type & (V_ALLTYPES - V_START_MOVE);
                    v.type = v.type | V_CONTINUE;
                }
                else if ((v.type & V_START_DRAW) == V_START_DRAW)
                {
                    v.type = v.type & (V_ALLTYPES - V_START_DRAW);
                    v.type = v.type | V_CONTINUE;
                }
            }
            if ((v.type & V_START_DRAW) == V_START_DRAW)
                lastWasMove = false;
            if ((v.type & V_START_MOVE) == V_START_MOVE)
                lastWasMove = true;
            doneARound = true;
        }

        return ret;
    }
/*    
	final int V_SAME_X = 16;
	final int V_SAME_Y = 32;
	final int V_VISIBLE = 64;
	final int V_WAS_DIVIDED = 128;
	final int V_CHANGE_INTENSITY = 256;
	final int V_LAST = 512;    
shift0+
    
    
    */	
	
    // update runnable result for parameters given
    private void updateResult()
    {
        if (!jCheckBoxRunnable2.isSelected()) return;
        if (!jCheckBoxCompileForVB.isSelected()) return;
        String text = jTextAreaResultSM.getText();
        text = de.malban.util.UtilityString.replace(text, "SM_", jTextField12.getText());
        jTextAreaResultSM.setText(text);
    }
    public void cycleMode()
    {
        if (jRadioButtonSetPoint.isSelected())
        {
            jRadioButtonSelectPoint.setSelected(true);
            jRadioButtonSelectPointActionPerformed(null);                                                        

        }
        else if (jRadioButtonSelectPoint.isSelected())
        {
            jRadioButtonSelectLine.setSelected(true);
            jRadioButtonSelectLineActionPerformed(null);                                                        

        }
        else if (jRadioButtonSelectLine.isSelected())
        {
            jRadioButtonSetPoint.setSelected(true);
            jRadioButtonSetPointActionPerformed(null);                                                        
        }
        if (singleVecciPanel != null) 
            singleVecciPanel.updateMode();
    }
    
    public void animLeft()
    {
        jButtonOneBackActionPerformed(null);
    }
    public void animRight()
    {
        jButtonOneForwardActionPerformed(null);
    }
}


