/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.veccy;

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
import de.malban.graphics.Vertex;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.components.CSAView;
import de.malban.gui.Scaler;
import de.malban.gui.Stateable;
import de.malban.gui.components.CSAInternalFrame;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.util.KeyboardListener;
import de.malban.vide.assy.Asmj;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.script.ExportFrame;
import de.malban.vide.script.ImportFrame;
import de.malban.vide.veccy.gtest.HLines;
import de.malban.vide.vecx.VecXPanel;
import de.malban.vide.vedi.VediPanel;
import de.malban.vide.vedi.raster.VectorJPanel;
import java.awt.*;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.awt.event.MouseEvent;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.Serializable;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DecimalFormat;
import java.util.*;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.SwingUtilities;
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
        Windowable, MousePressedListener, MouseReleasedListener, MouseMovedListener, Stateable, VectorChangedListener {
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    public boolean isLoadSettings() { return true; }

    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private int inSetting=0;
    private boolean continueStarted = false;
    private boolean pointsOk = false;

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

    
    public static String SID = "Vecci";
    public String getID()
    {
        return SID;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}

    
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
        mParentMenuItem.setText("Vector Draw");
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
        jCheckBox1.setSelected(SingleVectorPanel.displayLen);

        // not done yet
        jPanelScroller.setVisible(false);
        
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

        jLabel11.setForeground(Color.BLUE);
        jLabel15.setForeground(Color.GREEN);
        jLabel16.setForeground(Color.MAGENTA);

        jLabel10.setForeground(Color.BLUE);
        jLabel12.setForeground(Color.GREEN);
        jLabel13.setForeground(Color.MAGENTA);

        jLabel14.setForeground(Color.BLUE);
        jLabel17.setForeground(Color.GREEN);
        jLabel18.setForeground(Color.MAGENTA);
        
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
                int val = (int) ((double)((Double) value));
                
                JLabel l = (JLabel)c;
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
    }
    VectorJPanel vPanel = null;
    public void deinit()
    {
        if (vPanel != null)
        {
            vPanel.setVeccy(null);
            vPanel = null;
        }
    }
    public void setVPanel(VectorJPanel v)
    {
        vPanel = v;
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
        jPopupMenuLine = new javax.swing.JPopupMenu();
        jMenuItemLineDelete = new javax.swing.JMenuItem();
        jMenuItemDeleteNotSelected = new javax.swing.JMenuItem();
        jMenuItemInsertPoint = new javax.swing.JMenuItem();
        buttonGroup2 = new javax.swing.ButtonGroup();
        jPanel1 = new javax.swing.JPanel();
        applyCurrent = new javax.swing.JPanel();
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
        jScrollPane2 = new javax.swing.JScrollPane();
        jPanelIMageCollection = new javax.swing.JPanel();
        jPanel12 = new javax.swing.JPanel();
        jPanel13 = new javax.swing.JPanel();
        jButtonAddCurrent = new javax.swing.JButton();
        jButtonLoad1 = new javax.swing.JButton();
        jRadioButton1 = new javax.swing.JRadioButton();
        jRadioButton2 = new javax.swing.JRadioButton();
        jButtonAddCurrent1 = new javax.swing.JButton();
        jButtonClearAnimation = new javax.swing.JButton();
        jButtonOneBack = new javax.swing.JButton();
        jButtonJoin = new javax.swing.JButton();
        jCheckBoxAutoEdit = new javax.swing.JCheckBox();
        jCheckBoxAutoApply = new javax.swing.JCheckBox();
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
        jPanel35 = new javax.swing.JPanel();
        jButtonRotate2d = new javax.swing.JButton();
        jTextFieldRotate2d = new javax.swing.JTextField();
        jButtonMirrorVertically = new javax.swing.JButton();
        jButtonMirrorHorizontally = new javax.swing.JButton();
        jLabel50 = new javax.swing.JLabel();
        jLabel53 = new javax.swing.JLabel();
        jButtonOneForwardSelection2 = new javax.swing.JButton();
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
        jPanel9 = new javax.swing.JPanel();
        jRadioButtonSetPoint = new javax.swing.JRadioButton();
        jRadioButtonSelectPoint = new javax.swing.JRadioButton();
        jRadioButtonSelectLine = new javax.swing.JRadioButton();
        jCheckBoxContinue = new javax.swing.JCheckBox();
        jCheckBoxPointsOk = new javax.swing.JCheckBox();
        jCheckBoxArrows = new javax.swing.JCheckBox();
        jCheckBoxPosition = new javax.swing.JCheckBox();
        jCheckBoxMoves = new javax.swing.JCheckBox();
        jPanel27 = new javax.swing.JPanel();
        jButton5 = new javax.swing.JButton();
        jButtonConnectWherePossible = new javax.swing.JButton();
        jButtonOrderVectorlist = new javax.swing.JButton();
        jButtonFillGaps = new javax.swing.JButton();
        jButtonRemoveDots = new javax.swing.JButton();
        jButtonFitByteRange = new javax.swing.JButton();
        jCheckBoxFraktion = new javax.swing.JCheckBox();
        jCheckBoxLine = new javax.swing.JCheckBox();
        jButtonOrderSplitWhereNeeded = new javax.swing.JButton();
        jButtonShrink = new javax.swing.JButton();
        jButtonEnlarge = new javax.swing.JButton();
        jTextFieldScaleFactor = new javax.swing.JTextField();
        jLabel32 = new javax.swing.JLabel();
        jPanel36 = new javax.swing.JPanel();
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
        jPanel17 = new javax.swing.JPanel();
        jTabbedPane5 = new javax.swing.JTabbedPane();
        jPanel4 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jCheckBox1 = new javax.swing.JCheckBox();
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
        jPanel38 = new javax.swing.JPanel();
        jLabel56 = new javax.swing.JLabel();
        jButtonLoad2 = new javax.swing.JButton();
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
        jCheckBoxRunnable = new javax.swing.JCheckBox();
        jButtonAssemble = new javax.swing.JButton();
        jButtonEditInVedi = new javax.swing.JButton();
        jCheckBoxAddFactor = new javax.swing.JCheckBox();
        jLabel54 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
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
        jLabelMaxY = new javax.swing.JLabel();
        jLabelY0 = new javax.swing.JLabel();
        jLabelMinY = new javax.swing.JLabel();
        jSliderSourceScale = new javax.swing.JSlider();
        jLabelScale = new javax.swing.JLabel();
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
        jCheckBoxByteFrame = new javax.swing.JCheckBox();
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
        jPanelScroller = new javax.swing.JPanel();
        jButtonUp = new javax.swing.JButton();
        jButtonDown = new javax.swing.JButton();
        jButtonLeft = new javax.swing.JButton();
        jButtonRight = new javax.swing.JButton();

        jPopupMenuPoint.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jPopupMenuPointMouseExited(evt);
            }
        });

        jMenuItemJoin.setText("Join selected (here)");
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

        setName("veccy"); // NOI18N

        applyCurrent.setBorder(javax.swing.BorderFactory.createTitledBorder("vectorlists collection"));
        applyCurrent.setEnabled(false);
        applyCurrent.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                applyCurrentComponentResized(evt);
            }
        });
        applyCurrent.setLayout(null);

        jButtonOneForward.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_right.png"))); // NOI18N
        jButtonOneForward.setToolTipText("Select next, +SHIFT moves selected vectorlist one to the right.");
        jButtonOneForward.setPreferredSize(new java.awt.Dimension(35, 19));
        jButtonOneForward.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOneForwardActionPerformed(evt);
            }
        });
        applyCurrent.add(jButtonOneForward);
        jButtonOneForward.setBounds(580, 35, 40, 20);

        jTextFieldCurrentNo.setToolTipText("Number of the current selected image.");
        applyCurrent.add(jTextFieldCurrentNo);
        jTextFieldCurrentNo.setBounds(120, 13, 30, 19);

        jLabelImageNow.setText("now");
        applyCurrent.add(jLabelImageNow);
        jLabelImageNow.setBounds(90, 16, 30, 15);

        jTextFieldCount.setText("0");
        jTextFieldCount.setToolTipText("Count of images.");
        applyCurrent.add(jTextFieldCount);
        jTextFieldCount.setBounds(47, 13, 30, 19);

        jLabelImageCount.setText("Count");
        applyCurrent.add(jLabelImageCount);
        jLabelImageCount.setBounds(10, 16, 40, 15);

        jButtonApplyCurrent.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/shape_square_go.png"))); // NOI18N
        jButtonApplyCurrent.setText("apply");
        jButtonApplyCurrent.setToolTipText("apply changes to vectorlist to current selected animation \"frame\"");
        jButtonApplyCurrent.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonApplyCurrent.setPreferredSize(new java.awt.Dimension(90, 19));
        jButtonApplyCurrent.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonApplyCurrentActionPerformed(evt);
            }
        });
        applyCurrent.add(jButtonApplyCurrent);
        jButtonApplyCurrent.setBounds(240, 35, 110, 20);

        jLabelSelSize.setText(" ");
        applyCurrent.add(jLabelSelSize);
        jLabelSelSize.setBounds(320, 40, 50, 15);

        jButtonReverse.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_refresh_small.png"))); // NOI18N
        jButtonReverse.setText("Reverse");
        jButtonReverse.setToolTipText("Reverses the order of all vectorlists.");
        jButtonReverse.setPreferredSize(new java.awt.Dimension(69, 19));
        jButtonReverse.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonReverseActionPerformed(evt);
            }
        });
        applyCurrent.add(jButtonReverse);
        jButtonReverse.setBounds(511, 10, 110, 20);

        jButtonDeleteOne.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/exclamation.png"))); // NOI18N
        jButtonDeleteOne.setText("delete");
        jButtonDeleteOne.setToolTipText("Deletes selected vectorlist.");
        jButtonDeleteOne.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDeleteOne.setPreferredSize(new java.awt.Dimension(62, 19));
        jButtonDeleteOne.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDeleteOneActionPerformed(evt);
            }
        });
        applyCurrent.add(jButtonDeleteOne);
        jButtonDeleteOne.setBounds(630, 10, 110, 20);

        jButtonSave2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave2.setToolTipText("save animation");
        jButtonSave2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSave2ActionPerformed(evt);
            }
        });
        applyCurrent.add(jButtonSave2);
        jButtonSave2.setBounds(36, 35, 20, 20);

        jScrollPane2.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
        jScrollPane2.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);

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

        applyCurrent.add(jScrollPane2);
        jScrollPane2.setBounds(10, 70, 1170, 83);

        jButtonAddCurrent.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/add.png"))); // NOI18N
        jButtonAddCurrent.setText("add current");
        jButtonAddCurrent.setToolTipText("add current \"work\" vectorlist to the end of the animation");
        jButtonAddCurrent.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonAddCurrent.setPreferredSize(new java.awt.Dimension(90, 19));
        jButtonAddCurrent.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAddCurrentActionPerformed(evt);
            }
        });
        applyCurrent.add(jButtonAddCurrent);
        jButtonAddCurrent.setBounds(240, 10, 110, 20);

        jButtonLoad1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad1.setToolTipText("load animation");
        jButtonLoad1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoad1ActionPerformed(evt);
            }
        });
        applyCurrent.add(jButtonLoad1);
        jButtonLoad1.setBounds(10, 35, 20, 20);

        buttonGroup2.add(jRadioButton1);
        jRadioButton1.setSelected(true);
        jRadioButton1.setText("animation");
        jRadioButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton1ActionPerformed(evt);
            }
        });
        applyCurrent.add(jRadioButton1);
        jRadioButton1.setBounds(160, 10, 73, 19);

        buttonGroup2.add(jRadioButton2);
        jRadioButton2.setText("scenario");
        jRadioButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton2ActionPerformed(evt);
            }
        });
        applyCurrent.add(jRadioButton2);
        jRadioButton2.setBounds(160, 30, 65, 19);

        jButtonAddCurrent1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/add.png"))); // NOI18N
        jButtonAddCurrent1.setText("add view");
        jButtonAddCurrent1.setToolTipText("add current \"work\" vectorlist to the end of the animation");
        jButtonAddCurrent1.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonAddCurrent1.setPreferredSize(new java.awt.Dimension(90, 19));
        jButtonAddCurrent1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAddCurrent1ActionPerformed(evt);
            }
        });
        applyCurrent.add(jButtonAddCurrent1);
        jButtonAddCurrent1.setBounds(360, 10, 110, 20);

        jButtonClearAnimation.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/new.png"))); // NOI18N
        jButtonClearAnimation.setText("clear");
        jButtonClearAnimation.setToolTipText("new Animation (clears all)");
        jButtonClearAnimation.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonClearAnimation.setPreferredSize(new java.awt.Dimension(62, 19));
        jButtonClearAnimation.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonClearAnimationActionPerformed(evt);
            }
        });
        applyCurrent.add(jButtonClearAnimation);
        jButtonClearAnimation.setBounds(630, 35, 110, 20);

        jButtonOneBack.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_left.png"))); // NOI18N
        jButtonOneBack.setToolTipText("Select previous, +SHIFT moves selected vectorlist one to the left.");
        jButtonOneBack.setPreferredSize(new java.awt.Dimension(35, 19));
        jButtonOneBack.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOneBackActionPerformed(evt);
            }
        });
        applyCurrent.add(jButtonOneBack);
        jButtonOneBack.setBounds(511, 35, 40, 20);

        jButtonJoin.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/vector_add.png"))); // NOI18N
        jButtonJoin.setText("join");
        jButtonJoin.setToolTipText("<html>\n<body>\nif \"edit on select\" selected:<BR>\nJoins all vectorlist to one in current edit<BR>\nif \"edit on select\" NOT selected:<BR>\nJoins current selected frame to the current edit<BR>\n</body>\n</html>\n");
        jButtonJoin.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonJoin.setPreferredSize(new java.awt.Dimension(62, 19));
        jButtonJoin.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonJoinActionPerformed(evt);
            }
        });
        applyCurrent.add(jButtonJoin);
        jButtonJoin.setBounds(750, 10, 110, 20);

        jCheckBoxAutoEdit.setSelected(true);
        jCheckBoxAutoEdit.setText("edit on select");
        jCheckBoxAutoEdit.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBoxAutoEdit.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxAutoEditActionPerformed(evt);
            }
        });
        applyCurrent.add(jCheckBoxAutoEdit);
        jCheckBoxAutoEdit.setBounds(60, 37, 100, 16);

        jCheckBoxAutoApply.setText("auto apply");
        applyCurrent.add(jCheckBoxAutoApply);
        jCheckBoxAutoApply.setBounds(360, 37, 78, 19);

        jCheckBoxHasPattern.setText("has pattern byte");

        jTextFieldPattern.setText("51");

        jLabelPattern.setText("pattern byte (dec, bin, hex)");

        jCheckBoxHasIntensity.setText("has intensity");

        jTextFieldIntensity.setText("127");

        jLabelPattern1.setText("intensity (0-127)");

        jButtonSetStyle.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/accept.png"))); // NOI18N
        jButtonSetStyle.setText("set to selected");
        jButtonSetStyle.setToolTipText("Moves selected image one to the right.");
        jButtonSetStyle.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonSetStyle.setPreferredSize(new java.awt.Dimension(110, 19));
        jButtonSetStyle.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSetStyleActionPerformed(evt);
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
                        .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel10Layout.createSequentialGroup()
                                .addComponent(jTextFieldIntensity, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabelPattern1))
                            .addComponent(jCheckBoxHasIntensity)
                            .addGroup(jPanel10Layout.createSequentialGroup()
                                .addComponent(jTextFieldPattern, javax.swing.GroupLayout.PREFERRED_SIZE, 77, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabelPattern)))
                        .addGap(0, 251, Short.MAX_VALUE))
                    .addGroup(jPanel10Layout.createSequentialGroup()
                        .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonSetStyle, javax.swing.GroupLayout.PREFERRED_SIZE, 132, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxHasPattern))
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
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
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 59, Short.MAX_VALUE)
                .addComponent(jButtonSetStyle, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        jTabbedPane2.addTab("Line", jPanel10);

        jButtonRotate2d.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/shape_rotate_anticlockwise.png"))); // NOI18N
        jButtonRotate2d.setText("2d rotate (z-axis)");
        jButtonRotate2d.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonRotate2d.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonRotate2d.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRotate2dActionPerformed(evt);
            }
        });

        jTextFieldRotate2d.setText("90");

        jButtonMirrorVertically.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/shape_flip_horizontal.png"))); // NOI18N
        jButtonMirrorVertically.setText("mirror vertically");
        jButtonMirrorVertically.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonMirrorVertically.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonMirrorVertically.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonMirrorVerticallyActionPerformed(evt);
            }
        });

        jButtonMirrorHorizontally.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/shape_flip_vertical.png"))); // NOI18N
        jButtonMirrorHorizontally.setText("mirror horizontally");
        jButtonMirrorHorizontally.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonMirrorHorizontally.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonMirrorHorizontally.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonMirrorHorizontallyActionPerformed(evt);
            }
        });

        jLabel50.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel50.setText("around y-axis");

        jLabel53.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel53.setText("around x-axis");

        jButtonOneForwardSelection2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/images.png"))); // NOI18N
        jButtonOneForwardSelection2.setText("image to vector");
        jButtonOneForwardSelection2.setToolTipText("image to vector");
        jButtonOneForwardSelection2.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonOneForwardSelection2.setPreferredSize(new java.awt.Dimension(134, 19));
        jButtonOneForwardSelection2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOneForwardSelection2ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel35Layout = new javax.swing.GroupLayout(jPanel35);
        jPanel35.setLayout(jPanel35Layout);
        jPanel35Layout.setHorizontalGroup(
            jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel35Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel35Layout.createSequentialGroup()
                        .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jButtonMirrorVertically, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 164, Short.MAX_VALUE)
                            .addComponent(jButtonRotate2d, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonMirrorHorizontally, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addGap(20, 20, 20)
                        .addGroup(jPanel35Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel50, javax.swing.GroupLayout.DEFAULT_SIZE, 304, Short.MAX_VALUE)
                            .addComponent(jLabel53, javax.swing.GroupLayout.DEFAULT_SIZE, 304, Short.MAX_VALUE)
                            .addGroup(jPanel35Layout.createSequentialGroup()
                                .addComponent(jTextFieldRotate2d, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 258, Short.MAX_VALUE))))
                    .addGroup(jPanel35Layout.createSequentialGroup()
                        .addComponent(jButtonOneForwardSelection2, javax.swing.GroupLayout.PREFERRED_SIZE, 151, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE))))
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
                .addGap(42, 42, 42)
                .addComponent(jButtonOneForwardSelection2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(68, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("2d-Tools", jPanel35);

        jTextFieldBaseSize.setText("1");

        jLabel19.setText("base size");

        jButtonCube.setText("cube");
        jButtonCube.setPreferredSize(new java.awt.Dimension(53, 19));
        jButtonCube.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCubeActionPerformed(evt);
            }
        });

        jButton2.setText("pyramid");
        jButton2.setPreferredSize(new java.awt.Dimension(71, 19));
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
                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel11Layout.createSequentialGroup()
                        .addComponent(jLabel19)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldBaseSize, javax.swing.GroupLayout.PREFERRED_SIZE, 28, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButtonCube, javax.swing.GroupLayout.PREFERRED_SIZE, 73, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(398, Short.MAX_VALUE))
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
                .addContainerGap(129, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("Figure", jPanel11);

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

        jButton1.setText("add selected as face");
        jButton1.setToolTipText("<html> \nUse the current selected points and add the thus defined \"face\" to the facelist.<BR>\n<BR>\nThe points must all lie in the same plane (they must be coplanar).<BR>\n</html>");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton7.setText("delete from face list");
        jButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton7ActionPerformed(evt);
            }
        });

        jButton3.setText("execute HLR");
        jButton3.setToolTipText("<html>\nThe current angle settings for DISPLAY is taken,<BR>\nand a hidden line removal is executed to the vectorlist.<BR>\n(provided faces are defined)\n\n</html>");
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel37Layout = new javax.swing.GroupLayout(jPanel37);
        jPanel37.setLayout(jPanel37Layout);
        jPanel37Layout.setHorizontalGroup(
            jPanel37Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane7, javax.swing.GroupLayout.DEFAULT_SIZE, 500, Short.MAX_VALUE)
            .addGroup(jPanel37Layout.createSequentialGroup()
                .addGroup(jPanel37Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jButton3, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButton1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel55, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton7))
        );
        jPanel37Layout.setVerticalGroup(
            jPanel37Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel37Layout.createSequentialGroup()
                .addComponent(jScrollPane7, javax.swing.GroupLayout.PREFERRED_SIZE, 134, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addGroup(jPanel37Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel37Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButton1)
                        .addComponent(jButton7))
                    .addComponent(jLabel55, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton3)
                .addGap(0, 5, Short.MAX_VALUE))
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

        javax.swing.GroupLayout jPanel9Layout = new javax.swing.GroupLayout(jPanel9);
        jPanel9.setLayout(jPanel9Layout);
        jPanel9Layout.setHorizontalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel9Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jRadioButtonSelectLine)
                    .addComponent(jRadioButtonSelectPoint)
                    .addComponent(jRadioButtonSetPoint))
                .addGap(32, 32, 32)
                .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                        .addComponent(jCheckBoxPointsOk, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jCheckBoxContinue)
                        .addComponent(jCheckBoxPosition, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jCheckBoxArrows, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jCheckBoxMoves, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(46, Short.MAX_VALUE))
        );
        jPanel9Layout.setVerticalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel9Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel9Layout.createSequentialGroup()
                        .addComponent(jRadioButtonSetPoint)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jRadioButtonSelectPoint)
                        .addGap(0, 0, 0)
                        .addComponent(jRadioButtonSelectLine))
                    .addGroup(jPanel9Layout.createSequentialGroup()
                        .addComponent(jCheckBoxContinue)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxPointsOk)
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBoxArrows)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxPosition)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxMoves)))
                .addContainerGap(102, Short.MAX_VALUE))
        );

        jTabbedPane4.addTab("Mode/Select", jPanel9);

        jButton5.setText("center vectorlist");
        jButton5.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton5.setPreferredSize(new java.awt.Dimension(74, 19));
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jButtonConnectWherePossible.setText("connect where possible");
        jButtonConnectWherePossible.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonConnectWherePossible.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonConnectWherePossible.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonConnectWherePossibleActionPerformed(evt);
            }
        });

        jButtonOrderVectorlist.setText("order vectorlist");
        jButtonOrderVectorlist.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonOrderVectorlist.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonOrderVectorlist.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOrderVectorlistActionPerformed(evt);
            }
        });

        jButtonFillGaps.setText("fill gaps");
        jButtonFillGaps.setToolTipText("<html>\n\nThis also implies:<BR>\n<OL>\n<LI>\"connect where possible\"     </LI>\n<LI> \"order vectorlist\"</LI>\n</OL>\nAnd than creates \"move\" vectors (pattern = 0) between all gaps (except vStart and vEnd).\n</html>");
        jButtonFillGaps.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonFillGaps.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonFillGaps.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFillGapsActionPerformed(evt);
            }
        });

        jButtonRemoveDots.setText("remove dots");
        jButtonRemoveDots.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonRemoveDots.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonRemoveDots.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRemoveDotsActionPerformed(evt);
            }
        });

        jButtonFitByteRange.setText("fit byte");
        jButtonFitByteRange.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonFitByteRange.setPreferredSize(new java.awt.Dimension(74, 19));
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
        jButtonOrderSplitWhereNeeded.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonOrderSplitWhereNeeded.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOrderSplitWhereNeededActionPerformed(evt);
            }
        });

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

        jLabel32.setText("factor");

        javax.swing.GroupLayout jPanel27Layout = new javax.swing.GroupLayout(jPanel27);
        jPanel27.setLayout(jPanel27Layout);
        jPanel27Layout.setHorizontalGroup(
            jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel27Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel27Layout.createSequentialGroup()
                        .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jButtonOrderSplitWhereNeeded, javax.swing.GroupLayout.DEFAULT_SIZE, 175, Short.MAX_VALUE)
                            .addComponent(jButton5, javax.swing.GroupLayout.DEFAULT_SIZE, 175, Short.MAX_VALUE)
                            .addComponent(jButtonConnectWherePossible, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonOrderVectorlist, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonFitByteRange, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonRemoveDots, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonFillGaps, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxLine, javax.swing.GroupLayout.PREFERRED_SIZE, 48, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxFraktion, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 77, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel27Layout.createSequentialGroup()
                        .addComponent(jButtonShrink)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonEnlarge)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldScaleFactor, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel32, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(12, Short.MAX_VALUE))
        );
        jPanel27Layout.setVerticalGroup(
            jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel27Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonConnectWherePossible, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonOrderVectorlist, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonOrderSplitWhereNeeded, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonFillGaps, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxLine))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonRemoveDots, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonFitByteRange, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxFraktion))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jButtonShrink)
                        .addComponent(jButtonEnlarge))
                    .addGroup(jPanel27Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTextFieldScaleFactor, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel32)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jTabbedPane4.addTab("shortcut list", jPanel27);

        jTextFieldScaleFactor1.setText("1.5");

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
        jButtonFitByteRange1.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonFitByteRange1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFitByteRange1ActionPerformed(evt);
            }
        });

        jCheckBoxFraktion1.setSelected(true);
        jCheckBoxFraktion1.setText("fractions");
        jCheckBoxFraktion1.setEnabled(false);

        javax.swing.GroupLayout jPanel36Layout = new javax.swing.GroupLayout(jPanel36);
        jPanel36.setLayout(jPanel36Layout);
        jPanel36Layout.setHorizontalGroup(
            jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 276, Short.MAX_VALUE)
            .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel36Layout.createSequentialGroup()
                    .addGap(11, 11, 11)
                    .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(jPanel36Layout.createSequentialGroup()
                            .addComponent(jButtonFitByteRange1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jCheckBoxFraktion1, javax.swing.GroupLayout.PREFERRED_SIZE, 77, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel36Layout.createSequentialGroup()
                            .addComponent(jButtonShrink1)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jButtonEnlarge1)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jTextFieldScaleFactor1, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGap(11, 11, 11)))
        );
        jPanel36Layout.setVerticalGroup(
            jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 209, Short.MAX_VALUE)
            .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel36Layout.createSequentialGroup()
                    .addGap(92, 92, 92)
                    .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButtonFitByteRange1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jCheckBoxFraktion1))
                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                    .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addGroup(jPanel36Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonShrink1)
                            .addComponent(jButtonEnlarge1))
                        .addComponent(jTextFieldScaleFactor1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addContainerGap(73, Short.MAX_VALUE)))
        );

        jTabbedPane4.addTab("shortcut collection", jPanel36);

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
        jToggleButtonPlayAnim.setPreferredSize(new java.awt.Dimension(49, 19));
        jToggleButtonPlayAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButtonPlayAnimActionPerformed(evt);
            }
        });

        jTextFieldDelay.setText("80");
        jTextFieldDelay.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldDelayActionPerformed(evt);
            }
        });

        jLabelDelay.setText("Delay");

        jPanel23.setToolTipText("");

        jCheckBox2.setSelected(true);
        jCheckBox2.setText("z-axis (2d)");

        jCheckBox3.setText("x-axis");

        jCheckBox4.setText("y-axis");

        jLabel1.setText("to angle");

        jTextFieldRotateZ.setText("360");

        jLabel2.setText("to angle");

        jTextFieldRotateX.setText("0");

        jLabel3.setText("to angle");

        jTextFieldRotateY.setText("0");
        jTextFieldRotateY.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldRotateYActionPerformed(evt);
            }
        });

        jTextFieldRotateSteps.setText("12");
        jTextFieldRotateSteps.setToolTipText("<html>\nNumber of steps <b>BETWEEN</b> the original and the final angle.<BR>\nThis means step count of 0 (zero) results in 2 added animation frames, one for the original, \nand one frame for the rotated angle given.<BR>\nThis also means if the final angle is 360 degrees the first and the last added frame have the same rotation angle!\n</html>");

        jButton4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/accept.png"))); // NOI18N
        jButton4.setText("do it");
        jButton4.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton4.setPreferredSize(new java.awt.Dimension(74, 19));
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

        jLabel33.setText("steps");

        jCheckBox5.setText("apply HLR");
        jCheckBox5.setToolTipText("<html>\nApply hidden line removal on result.<BR>\nThe result will be a 2d list only.\n</html>");

        javax.swing.GroupLayout jPanel23Layout = new javax.swing.GroupLayout(jPanel23);
        jPanel23.setLayout(jPanel23Layout);
        jPanel23Layout.setHorizontalGroup(
            jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel23Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel23Layout.createSequentialGroup()
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox2)
                            .addComponent(jCheckBox3)
                            .addComponent(jCheckBox4))
                        .addGap(33, 33, 33)
                        .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel23Layout.createSequentialGroup()
                                .addComponent(jLabel3)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextFieldRotateY, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel23Layout.createSequentialGroup()
                                .addComponent(jLabel2)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextFieldRotateX, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel23Layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextFieldRotateZ, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jCheckBoxScaleToByte, javax.swing.GroupLayout.PREFERRED_SIZE, 111, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 39, Short.MAX_VALUE))
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addComponent(jLabel33, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldRotateSteps, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel23Layout.createSequentialGroup()
                        .addComponent(jCheckBox5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel23Layout.setVerticalGroup(
            jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel23Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox2)
                    .addComponent(jLabel1)
                    .addComponent(jTextFieldRotateZ, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(5, 5, 5)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox3)
                    .addComponent(jLabel2)
                    .addComponent(jTextFieldRotateX, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(5, 5, 5)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox4)
                    .addComponent(jLabel3)
                    .addComponent(jTextFieldRotateY, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(2, 2, 2)
                .addComponent(jCheckBoxScaleToByte)
                .addGap(29, 29, 29)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextFieldRotateSteps, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel33))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBox5))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Rotation", jPanel23);

        jLabel7.setText("steps");

        jTextFieldMorphSteps.setText("12");

        jButton6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/accept.png"))); // NOI18N
        jButton6.setText("do it");
        jButton6.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton6.setPreferredSize(new java.awt.Dimension(74, 19));
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
                    .addComponent(jLabel9, javax.swing.GroupLayout.DEFAULT_SIZE, 261, Short.MAX_VALUE)
                    .addComponent(jLabel20, javax.swing.GroupLayout.DEFAULT_SIZE, 261, Short.MAX_VALUE)
                    .addComponent(jLabel21, javax.swing.GroupLayout.DEFAULT_SIZE, 261, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel24Layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel24Layout.createSequentialGroup()
                                .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldMorphSteps, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jButton6, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
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
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 40, Short.MAX_VALUE)
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel7)
                    .addComponent(jTextFieldMorphSteps, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(6, 6, 6)
                .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        jTabbedPane1.addTab("Morphing", jPanel24);

        jButtonPathsAsScenario.setText("seperate paths as scenario entries");
        jButtonPathsAsScenario.setPreferredSize(new java.awt.Dimension(74, 19));
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
                .addComponent(jButtonPathsAsScenario, javax.swing.GroupLayout.PREFERRED_SIZE, 237, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(36, Short.MAX_VALUE))
        );
        jPanel14Layout.setVerticalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel14Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonPathsAsScenario, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(155, Short.MAX_VALUE))
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
            .addComponent(jTabbedPane1)
        );

        jTabbedPane6.addTab("build animation", jPanel22);

        jLabelAnim.setText("DISPLAY/Animation/Scenario");

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabelAnim)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(jPanel5Layout.createSequentialGroup()
                            .addGap(4, 4, 4)
                            .addComponent(jLabelDelay, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jTextFieldDelay, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jToggleButtonPlayAnim, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jSliderSourceScale1, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(single3dDisplayPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jTabbedPane6, javax.swing.GroupLayout.PREFERRED_SIZE, 293, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTabbedPane4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTabbedPane2))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jTabbedPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 239, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jTabbedPane4, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                        .addComponent(jTabbedPane6, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel5Layout.createSequentialGroup()
                            .addComponent(jLabelAnim)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(single3dDisplayPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jSliderSourceScale1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jToggleButtonPlayAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jTextFieldDelay, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabelDelay)))))
                .addGap(5, 5, 5))
        );

        jPanel6.setBorder(javax.swing.BorderFactory.createTitledBorder("vectorlist"));

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

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jCheckBox1)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 293, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox1)
                .addGap(12, 12, 12))
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
        singleImagePanel2.setBounds(309, 13, 300, 300);

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
        singleImagePanel3.setBounds(0, 13, 300, 300);

        jLabelY.setText("<- Y(z) ->");
        jPanel16.add(jLabelY);
        jLabelY.setBounds(0, 319, 70, 15);

        jLabelZ.setText("<- Z(x) ->");
        jPanel16.add(jLabelZ);
        jLabelZ.setBounds(550, 320, 70, 15);

        jTextFieldExpandYZ.setText("1");
        jPanel16.add(jTextFieldExpandYZ);
        jTextFieldExpandYZ.setBounds(80, 320, 30, 19);

        jButtonExpandDimensionYZ.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_out.png"))); // NOI18N
        jButtonExpandDimensionYZ.setText("expand dimension");
        jButtonExpandDimensionYZ.setToolTipText("Deletes selected vectorlist.");
        jButtonExpandDimensionYZ.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonExpandDimensionYZ.setPreferredSize(new java.awt.Dimension(62, 21));
        jButtonExpandDimensionYZ.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonExpandDimensionYZActionPerformed(evt);
            }
        });
        jPanel16.add(jButtonExpandDimensionYZ);
        jButtonExpandDimensionYZ.setBounds(120, 320, 160, 21);

        jCheckBoxDragVectors.setText("drag vectors");
        jPanel16.add(jCheckBoxDragVectors);
        jCheckBoxDragVectors.setBounds(290, 320, 120, 19);

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

        jTextFieldTop.setText("0");

        jLabel10.setText("X-axis");

        jLabel12.setText("Y-axis");

        jLabel13.setText("Z-axis");

        jTextFieldFront.setText("0");

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
                    .addComponent(jSliderTop, javax.swing.GroupLayout.DEFAULT_SIZE, 161, Short.MAX_VALUE)
                    .addComponent(jSliderFront, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                    .addComponent(jSliderSide, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jTextFieldFront, javax.swing.GroupLayout.DEFAULT_SIZE, 33, Short.MAX_VALUE)
                    .addComponent(jTextFieldSide)
                    .addComponent(jTextFieldTop))
                .addContainerGap(40, Short.MAX_VALUE))
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
                .addGap(0, 54, Short.MAX_VALUE))
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

        jTextFieldSide1.setText("0");

        jTextFieldTop1.setText("0");

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
                    .addComponent(jSliderFrontTranslocationZ, javax.swing.GroupLayout.DEFAULT_SIZE, 188, Short.MAX_VALUE)
                    .addComponent(jSliderFrontTranslocationX, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                    .addComponent(jSliderFrontTranslocationY, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jTextFieldFront1, javax.swing.GroupLayout.DEFAULT_SIZE, 33, Short.MAX_VALUE)
                    .addComponent(jTextFieldSide1)
                    .addComponent(jTextFieldTop1))
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

        jTextFieldSide2.setText("49");

        jTextFieldTop2.setText("31");

        jButton2dAxis.setText("axis 2d");
        jButton2dAxis.setPreferredSize(new java.awt.Dimension(67, 19));
        jButton2dAxis.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2dAxisActionPerformed(evt);
            }
        });

        jButton3dAxis.setText("axis 3d");
        jButton3dAxis.setPreferredSize(new java.awt.Dimension(67, 19));
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
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel14)
                            .addComponent(jLabel17))
                        .addGap(17, 17, 17))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel7Layout.createSequentialGroup()
                        .addComponent(jLabel18)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)))
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addComponent(jButton2dAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButton3dAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jSliderTop1, javax.swing.GroupLayout.DEFAULT_SIZE, 161, Short.MAX_VALUE)
                            .addComponent(jSliderFront1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                            .addComponent(jSliderSide1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jTextFieldFront2, javax.swing.GroupLayout.DEFAULT_SIZE, 33, Short.MAX_VALUE)
                            .addComponent(jTextFieldSide2)
                            .addComponent(jTextFieldTop2))
                        .addContainerGap(40, Short.MAX_VALUE))))
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
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton2dAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton3dAxis, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 23, Short.MAX_VALUE))
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
                    .addComponent(jTabbedPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 305, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel21Layout.createSequentialGroup()
                        .addComponent(jLabelDelay1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxDisplayAxis)))
                .addContainerGap(533, Short.MAX_VALUE))
        );
        jPanel21Layout.setVerticalGroup(
            jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel21Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jTabbedPane3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabelDelay1)
                    .addComponent(jCheckBoxDisplayAxis))
                .addContainerGap(83, Short.MAX_VALUE))
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
        jComboBoxPatterns.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxPatterns.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxPatternsActionPerformed(evt);
            }
        });

        jLabel25.setText("line 1");

        jLabel26.setText("line x");

        jLabel27.setText("last line");

        jTextField8.setText("%C");

        jTextField10.setText("%Y %X");

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

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel22)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 306, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(6, 6, 6)
                        .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 222, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(5, 5, 5)
                        .addComponent(jLabel23)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel24, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(single3dDisplayPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addContainerGap(110, Short.MAX_VALUE))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jLabel25, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel26, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel27, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                                        .addComponent(jButtonInterprete, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jButtonSave3)))
                                .addGap(8, 8, 8))
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addComponent(jLabel49, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jCheckBoxMulti)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)))
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jTextField8, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 132, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, 132, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, 132, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldPatternName, javax.swing.GroupLayout.PREFERRED_SIZE, 132, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jComboBoxPatterns, javax.swing.GroupLayout.PREFERRED_SIZE, 132, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 0, Short.MAX_VALUE))))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel22)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane3))
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
                                    .addGroup(jPanel3Layout.createSequentialGroup()
                                        .addComponent(jComboBoxPatterns, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(7, 7, 7))
                                    .addGroup(jPanel3Layout.createSequentialGroup()
                                        .addComponent(jCheckBoxMulti)
                                        .addGap(6, 6, 6)))
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jTextFieldPatternName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jButtonSave3))))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel27))
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jTextField8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel25))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel26))
                                .addGap(25, 25, 25)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 29, Short.MAX_VALUE)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel24)
                            .addComponent(single3dDisplayPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 21, Short.MAX_VALUE)))
                .addContainerGap())
        );

        jTabbedPane7.addTab("text import", jPanel3);

        jLabel56.setText("File");

        jButtonLoad2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad2.setToolTipText("load YM");
        jButtonLoad2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoad2ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel38Layout = new javax.swing.GroupLayout(jPanel38);
        jPanel38.setLayout(jPanel38Layout);
        jPanel38Layout.setHorizontalGroup(
            jPanel38Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel38Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel56, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonLoad2)
                .addContainerGap(771, Short.MAX_VALUE))
        );
        jPanel38Layout.setVerticalGroup(
            jPanel38Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel38Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel38Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButtonLoad2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel56, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap(280, Short.MAX_VALUE))
        );

        jTabbedPane7.addTab("Wavefront *.obj", jPanel38);

        jButtonExport1.setText("User Import");
        jButtonExport1.setPreferredSize(new java.awt.Dimension(91, 19));
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
                .addComponent(jButtonExport1, javax.swing.GroupLayout.PREFERRED_SIZE, 114, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(720, Short.MAX_VALUE))
        );
        jPanel15Layout.setVerticalGroup(
            jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel15Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonExport1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(286, Short.MAX_VALUE))
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
        jButtonMov_Draw_VLc_a.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonMov_Draw_VLc_a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonMov_Draw_VLc_aActionPerformed(evt);
            }
        });

        jButtonDraw_VLc.setText("Draw_VLc");
        jButtonDraw_VLc.setToolTipText("<html>\n<B>Draw_VLc</B>        <BR>                                  \n                                                <BR>                            \nThis routine draws vectors between the set of (y,x) points pointed    <BR>     \nto by the X register.  The number of vectors to draw is specified     <BR>     \nas the first byte in the vector list.  The current scale factor is    <BR>     \nused.  The vector list has the following format:                      <BR>  \n<BR>\n<PRE>\n   count, rel y, rel x, rel y, rel x, ... \n</PRE>\n<BR>     \n</html>\n\n\n   \n");
        jButtonDraw_VLc.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VLc.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonDraw_VLc.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VLcActionPerformed(evt);
            }
        });

        jButtonDraw_VLp.setText("Draw_VLp");
        jButtonDraw_VLp.setToolTipText("<html>\n<B>Draw_VLp</B>        <BR>                                  \n                                                <BR>                            \nThis routine draws patterned lines using the vector list pointed to   <BR>\nby the X-register.  The current scale factor is used.  The vector   <BR>\nlist has the following format: <BR>\n<BR>\n<PRE>\n      pattern, rel y, rel x                                           \n      pattern, rel y, rel x                                           \n         .      .      .                                              \n         .      .      .                                              \n      pattern, rel y, rel x                                           \n      0x01 \n</PRE>\n<BR>     \n</html>\n");
        jButtonDraw_VLp.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VLp.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonDraw_VLp.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VLpActionPerformed(evt);
            }
        });

        jButtonDraw_VL_mode.setText("Draw_VL_mode");
        jButtonDraw_VL_mode.setToolTipText("<html>\n<B>Draw_VL_mode</B>        <BR>                                  \n                                                <BR>                            \nThis routine processes the vector list pointed to by the X register.  <BR> \nThe current scale factor is used.  The vector list has the following  <BR> \nformat: <BR> \n<BR>\n<PRE>\n     mode, rel y, rel x,                                             \n     mode, rel y, rel x,                                             \n     .      .      .                                                \n     .      .      .                                                \n     mode, rel y, rel x,                                             \n     0x01  \n</PRE>\n<BR>\nwhere mode has the following meaning:         <BR>                        \n                                              <BR>                    \n< 0  use the pattern in $C829        <BR>                           \n= 0  move to specified endpoint      <BR>                           \n= 1  end of list, so return         <BR>                            \n> 1  draw to specified endpoint <BR>\n<BR>     \n</html>\n");
        jButtonDraw_VL_mode.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VL_mode.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonDraw_VL_mode.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VL_modeActionPerformed(evt);
            }
        });

        jLabel4.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel4.setText("Only modes are available which can");

        jLabel34.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel34.setText("be used to draw the current type of");

        jLabel35.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel35.setText("vectorlist (see tab: vectorlist status).");

        jLabel36.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel36.setText("(vectorlist is assumed to be ordered!)");

        jLabel37.setText("Label name:");

        jButtonDraw_syncList.setText("Draw sync list");
        jButtonDraw_syncList.setToolTipText("<html>\n<B>Draw sync list</B>        <BR>                                  \n                                                <BR>                            \nFormat developed by Malban, this format describes a \"large\".  <BR> \nVectorlist, which can be synced while drawing. Synced means,   <BR> \nthe beam is zeroed and moved to the next location.   <BR> \nVide automatically inserts a \"sync\" when vectors are not connected. <BR> \n<BR>\nThe Sync point is always the \"displayed\" point 0, 0, after a sync the beam is moved<BR>\nthe vectorlist 0, 0 and from there to the next displayed vector.<BR>\nformat: <BR> \n\nMethod to draw:\nU = address of vectorlist\nX = (y,x) position of vectorlist (this will be point 0,0), positioning\nA = scalefactor \"Move\" (after sync)\nB = scalefactor \"Vector\" (vectors in vectorlist)\n\n<BR>\n<PRE>\n     mode, rel y, rel x,                                             \n     mode, rel y, rel x,                                             \n     .      .      .                                                \n     .      .      .                                                \n     mode, rel y, rel x,                                             \n     0xff, 0xffff \n</PRE>\n<BR>\nwhere mode has the following meaning:         <BR>                        \n                                              <BR>                    \n0xff draw line        <BR>                           \n0  move to specified endpoint      <BR>                           \n1  sync (and move to specified endpoint)        <BR>     \n\n<BR>     \n</html>\n\n");
        jButtonDraw_syncList.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_syncList.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonDraw_syncList.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_syncListActionPerformed(evt);
            }
        });

        jTextFieldResync.setText("20");
        jTextFieldResync.setToolTipText("maximum resync size");

        jCheckBoxVec32.setToolTipText("Vectrex32 BASIC output");

        javax.swing.GroupLayout jPanel29Layout = new javax.swing.GroupLayout(jPanel29);
        jPanel29.setLayout(jPanel29Layout);
        jPanel29Layout.setHorizontalGroup(
            jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel29Layout.createSequentialGroup()
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jButtonDraw_VLp, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 130, Short.MAX_VALUE)
                    .addComponent(jButtonDraw_VLc, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonMov_Draw_VLc_a, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonDraw_VL_mode, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonDraw_syncList, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel29Layout.createSequentialGroup()
                        .addComponent(jCheckBoxVec32)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel34, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel35, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel36, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel29Layout.createSequentialGroup()
                        .addComponent(jTextFieldResync, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel37)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldLabelListname, javax.swing.GroupLayout.PREFERRED_SIZE, 88, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel29Layout.setVerticalGroup(
            jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel29Layout.createSequentialGroup()
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonMov_Draw_VLc_a, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel4))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonDraw_VLc, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel34))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonDraw_VLp, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel35))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButtonDraw_VL_mode, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel36))
                    .addComponent(jCheckBoxVec32))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel37)
                        .addComponent(jTextFieldLabelListname, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel29Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButtonDraw_syncList, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextFieldResync, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(5, 5, 5))
        );

        jPanel30.setBorder(javax.swing.BorderFactory.createTitledBorder("Animation/Scenario"));

        jButtonMov_Draw_VLc_aAnim.setText("Mov_Draw_VLc_a");
        jButtonMov_Draw_VLc_aAnim.setToolTipText("<html>\n<B>Mov_Draw_VLc_a</B>        <BR>                                  \n                                                <BR>                            \nThis routine moves to the first location specified in vector list,    <BR>     \nand then draws lines between the rest of coordinates in the list.    <BR>      \nThe number of vectors to draw is specified as the first byte in the   <BR>     \nvector list.  The current scale factor is used.  The vector list has  <BR>     \nthe following format:                                                 <BR>     \n                                       <BR>                                  \n<PRE>\n   count, rel y, rel x, rel y, rel x, ... \n</PRE>\n<BR>     \n</html>");
        jButtonMov_Draw_VLc_aAnim.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonMov_Draw_VLc_aAnim.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonMov_Draw_VLc_aAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonMov_Draw_VLc_aAnimActionPerformed(evt);
            }
        });

        jButtonDraw_VLcAnim.setText("Draw_VLc");
        jButtonDraw_VLcAnim.setToolTipText("<html>\n<B>Draw_VLc</B>        <BR>                                  \n                                                <BR>                            \nThis routine draws vectors between the set of (y,x) points pointed    <BR>     \nto by the X register.  The number of vectors to draw is specified     <BR>     \nas the first byte in the vector list.  The current scale factor is    <BR>     \nused.  The vector list has the following format:                      <BR>  \n<BR>\n<PRE>\n   count, rel y, rel x, rel y, rel x, ... \n</PRE>\n<BR>     \n</html>\n\n\n   \n");
        jButtonDraw_VLcAnim.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VLcAnim.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonDraw_VLcAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VLcAnimActionPerformed(evt);
            }
        });

        jButtonDraw_VLpAnim.setText("Draw_VLp");
        jButtonDraw_VLpAnim.setToolTipText("<html>\n<B>Draw_VLp</B>        <BR>                                  \n                                                <BR>                            \nThis routine draws patterned lines using the vector list pointed to   <BR>\nby the X-register.  The current scale factor is used.  The vector   <BR>\nlist has the following format: <BR>\n<BR>\n<PRE>\n      pattern, rel y, rel x                                           \n      pattern, rel y, rel x                                           \n         .      .      .                                              \n         .      .      .                                              \n      pattern, rel y, rel x                                           \n      0x01 \n</PRE>\n<BR>     \n</html>\n");
        jButtonDraw_VLpAnim.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VLpAnim.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonDraw_VLpAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VLpAnimActionPerformed(evt);
            }
        });

        jButtonDraw_VL_modeAnim.setText("Draw_VL_mode");
        jButtonDraw_VL_modeAnim.setToolTipText("<html>\n<B>Draw_VL_mode</B>        <BR>                                  \n                                                <BR>                            \nThis routine processes the vector list pointed to by the X register.  <BR> \nThe current scale factor is used.  The vector list has the following  <BR> \nformat: <BR> \n<BR>\n<PRE>\n     mode, rel y, rel x,                                             \n     mode, rel y, rel x,                                             \n     .      .      .                                                \n     .      .      .                                                \n     mode, rel y, rel x,                                             \n     0x01  \n</PRE>\n<BR>\nwhere mode has the following meaning:         <BR>                        \n                                              <BR>                    \n< 0  use the pattern in $C829        <BR>                           \n= 0  move to specified endpoint      <BR>                           \n= 1  end of list, so return         <BR>                            \n> 1  draw to specified endpoint <BR>\n<BR>     \n</html>\n");
        jButtonDraw_VL_modeAnim.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_VL_modeAnim.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonDraw_VL_modeAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_VL_modeAnimActionPerformed(evt);
            }
        });

        jLabel38.setText("Label name:");

        jLabel44.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel44.setText("Note: For Draw_VLc and Draw_VLp");

        jLabel45.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel45.setText("animations only make sense if all ");

        jLabel46.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel46.setText("frames share the same starting point!");

        jButtonDraw_syncListAnim.setText("Draw sync list");
        jButtonDraw_syncListAnim.setToolTipText("<html>\n<B>Draw sync list</B>        <BR>                                  \n                                                <BR>                            \nFormat developed by Malban, this format describes a \"large\".  <BR> \nVectorlist, which can be synced while drawing. Synced means,   <BR> \nthe beam is zeroed and moved to the next location.   <BR> \nVide automatically inserts a \"sync\" when vectors are not connected. <BR> \n<BR>\nThe Sync point is always the \"displayed\" point 0, 0, after a sync the beam is moved<BR>\nthe vectorlist 0, 0 and from there to the next displayed vector.<BR>\nformat: <BR> \n\nMethod to draw:\nU = address of vectorlist\nX = (y,x) position of vectorlist (this will be point 0,0), positioning\nA = scalefactor \"Move\" (after sync)\nB = scalefactor \"Vector\" (vectors in vectorlist)\n\n<BR>\n<PRE>\n     mode, rel y, rel x,                                             \n     mode, rel y, rel x,                                             \n     .      .      .                                                \n     .      .      .                                                \n     mode, rel y, rel x,                                             \n     0xff, 0xffff \n</PRE>\n<BR>\nwhere mode has the following meaning:         <BR>                        \n                                              <BR>                    \n0xff draw line        <BR>                           \n0  move to specified endpoint      <BR>                           \n1  sync (and move to specified endpoint)        <BR>     \n\n<BR>     \n</html>\n\n");
        jButtonDraw_syncListAnim.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonDraw_syncListAnim.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonDraw_syncListAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDraw_syncListAnimActionPerformed(evt);
            }
        });

        jTextFieldResyncAnim.setText("20");
        jTextFieldResyncAnim.setToolTipText("maximum resync size");

        javax.swing.GroupLayout jPanel30Layout = new javax.swing.GroupLayout(jPanel30);
        jPanel30.setLayout(jPanel30Layout);
        jPanel30Layout.setHorizontalGroup(
            jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel30Layout.createSequentialGroup()
                .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel30Layout.createSequentialGroup()
                        .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jButtonDraw_VLpAnim, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonDraw_VLcAnim, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonMov_Draw_VLc_aAnim, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonDraw_VL_modeAnim, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(34, 34, 34)
                        .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel44, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel45, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel46, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                    .addGroup(jPanel30Layout.createSequentialGroup()
                        .addComponent(jButtonDraw_syncListAnim, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldResyncAnim, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(58, 58, 58)
                        .addComponent(jLabel38)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldAnimName, javax.swing.GroupLayout.PREFERRED_SIZE, 88, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(6, 6, 6))
        );
        jPanel30Layout.setVerticalGroup(
            jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel30Layout.createSequentialGroup()
                .addComponent(jButtonMov_Draw_VLc_aAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonDraw_VLcAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel44))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonDraw_VLpAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel45))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonDraw_VL_modeAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel46))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel38)
                        .addComponent(jTextFieldAnimName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel30Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButtonDraw_syncListAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextFieldResyncAnim, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
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

        jCheckBoxAddFactor.setText("add  factor");

        jLabel54.setText("scale:");
        jLabel54.setEnabled(false);

        jTextField1.setEnabled(false);

        javax.swing.GroupLayout jPanel19Layout = new javax.swing.GroupLayout(jPanel19);
        jPanel19.setLayout(jPanel19Layout);
        jPanel19Layout.setHorizontalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel19Layout.createSequentialGroup()
                .addGap(4, 4, 4)
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jPanel29, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel30, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addComponent(jCheckBoxRunnable)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonAssemble)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonEditInVedi)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jCheckBoxAddFactor, javax.swing.GroupLayout.PREFERRED_SIZE, 94, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel54, javax.swing.GroupLayout.PREFERRED_SIZE, 39, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 100, Short.MAX_VALUE))
                    .addComponent(jScrollPane5, javax.swing.GroupLayout.DEFAULT_SIZE, 418, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel19Layout.setVerticalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel19Layout.createSequentialGroup()
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addComponent(jPanel29, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jPanel30, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxRunnable, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jButtonAssemble, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jButtonEditInVedi, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jCheckBoxAddFactor)
                                .addComponent(jLabel54)
                                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 270, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
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
        jButtonCodeGen.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonCodeGen.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCodeGenActionPerformed(evt);
            }
        });

        jLabel47.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel47.setText("To change the code generation,  ");

        jLabel48.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel48.setText("edit the used templates!");

        jLabel51.setText("Label name:");

        javax.swing.GroupLayout jPanel33Layout = new javax.swing.GroupLayout(jPanel33);
        jPanel33.setLayout(jPanel33Layout);
        jPanel33Layout.setHorizontalGroup(
            jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel33Layout.createSequentialGroup()
                .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel33Layout.createSequentialGroup()
                        .addComponent(jButtonCodeGen, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(30, 30, 30)
                        .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel48, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel47, javax.swing.GroupLayout.DEFAULT_SIZE, 214, Short.MAX_VALUE)))
                    .addGroup(jPanel33Layout.createSequentialGroup()
                        .addComponent(jLabel51)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldLabelListname1, javax.swing.GroupLayout.PREFERRED_SIZE, 88, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel33Layout.setVerticalGroup(
            jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel33Layout.createSequentialGroup()
                .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonCodeGen, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel47))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel48)
                .addGap(57, 57, 57)
                .addGroup(jPanel33Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel51)
                    .addComponent(jTextFieldLabelListname1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 13, Short.MAX_VALUE))
        );

        jPanel34.setBorder(javax.swing.BorderFactory.createTitledBorder("Animation/Scenario"));

        jButtonAnimCodeGen.setText("Moves & Draws");
        jButtonAnimCodeGen.setToolTipText("");
        jButtonAnimCodeGen.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonAnimCodeGen.setPreferredSize(new java.awt.Dimension(74, 19));
        jButtonAnimCodeGen.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAnimCodeGenActionPerformed(evt);
            }
        });

        jLabel52.setText("Label name:");

        javax.swing.GroupLayout jPanel34Layout = new javax.swing.GroupLayout(jPanel34);
        jPanel34.setLayout(jPanel34Layout);
        jPanel34Layout.setHorizontalGroup(
            jPanel34Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel34Layout.createSequentialGroup()
                .addGroup(jPanel34Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonAnimCodeGen, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel34Layout.createSequentialGroup()
                        .addComponent(jLabel52)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldAnimName1, javax.swing.GroupLayout.PREFERRED_SIZE, 88, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(227, Short.MAX_VALUE))
        );
        jPanel34Layout.setVerticalGroup(
            jPanel34Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel34Layout.createSequentialGroup()
                .addComponent(jButtonAnimCodeGen, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(74, 74, 74)
                .addGroup(jPanel34Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel52)
                    .addComponent(jTextFieldAnimName1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 0, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel32Layout = new javax.swing.GroupLayout(jPanel32);
        jPanel32.setLayout(jPanel32Layout);
        jPanel32Layout.setHorizontalGroup(
            jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel32Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jPanel33, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel34, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel32Layout.createSequentialGroup()
                        .addComponent(jCheckBoxRunnable1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonAssemble1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonEditInVedi1)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addComponent(jScrollPane6, javax.swing.GroupLayout.DEFAULT_SIZE, 428, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel32Layout.setVerticalGroup(
            jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel32Layout.createSequentialGroup()
                .addGroup(jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel32Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel32Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonAssemble1)
                            .addComponent(jButtonEditInVedi1)
                            .addComponent(jCheckBoxRunnable1, javax.swing.GroupLayout.Alignment.TRAILING))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane6, javax.swing.GroupLayout.PREFERRED_SIZE, 270, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel32Layout.createSequentialGroup()
                        .addComponent(jPanel33, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel34, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addContainerGap())
        );

        jTabbedPane8.addTab("code export", jPanel32);

        jButtonExport.setText("User Export");
        jButtonExport.setPreferredSize(new java.awt.Dimension(90, 19));
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
                .addComponent(jButtonExport, javax.swing.GroupLayout.PREFERRED_SIZE, 122, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(712, Short.MAX_VALUE))
        );
        jPanel20Layout.setVerticalGroup(
            jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel20Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonExport, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(282, Short.MAX_VALUE))
        );

        jTabbedPane8.addTab("user export", jPanel20);

        javax.swing.GroupLayout jPanel26Layout = new javax.swing.GroupLayout(jPanel26);
        jPanel26.setLayout(jPanel26Layout);
        jPanel26Layout.setHorizontalGroup(
            jPanel26Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane8)
        );
        jPanel26Layout.setVerticalGroup(
            jPanel26Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane8, javax.swing.GroupLayout.PREFERRED_SIZE, 342, Short.MAX_VALUE)
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

        jTextFieldYMaxLength.setEditable(false);
        jTextFieldYMaxLength.setText("0");

        jLabel6.setText("Y length max");

        jCheckBoxVectorsContinuous.setText("vectors continuous");

        jCheckBoxVectorClosedPolygon.setText("closed polygon");

        jLabel28.setText("X min/max");

        jLabel29.setText("Y min/max");

        jTextFieldYMin.setEditable(false);
        jTextFieldYMin.setText("0");

        jTextFieldXMin.setEditable(false);
        jTextFieldXMin.setText("0");

        jTextFieldXMax.setEditable(false);
        jTextFieldXMax.setText("0");

        jTextFieldYMax.setEditable(false);
        jTextFieldYMax.setText("0");

        jLabel30.setText("Z length max");

        jTextFieldZMaxLength.setEditable(false);
        jTextFieldZMaxLength.setText("0");

        jLabel31.setText("Z min/max");

        jTextFieldZMin.setEditable(false);
        jTextFieldZMin.setText("0");

        jTextFieldZMax.setEditable(false);
        jTextFieldZMax.setText("0");

        jCheckBoxVectorOrderedClosedPolygon.setText("ordered closed polygon");

        jCheckBoxHighPattern.setText("all pattern high bit set");

        jCheckBoxOnePath.setText("vectors in one path");
        jCheckBoxOnePath.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxOnePathActionPerformed(evt);
            }
        });

        jLabel39.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel39.setText("if disabled, so are export to: Draw_VLc and Mov_Draw_VLc_a");

        jLabel40.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel40.setText("if disabled, so are export to: Draw_VLp");

        jLabel41.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel41.setText("if disabled, so all exports");

        jLabel42.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel42.setText("if any max length is greater 127, than all exports are disabled");

        jLabel43.setFont(new java.awt.Font("Geneva", 1, 14)); // NOI18N
        jLabel43.setText("This is an information tab, changing checkboxes here is a waste of time!");

        javax.swing.GroupLayout jPanel28Layout = new javax.swing.GroupLayout(jPanel28);
        jPanel28.setLayout(jPanel28Layout);
        jPanel28Layout.setHorizontalGroup(
            jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel28Layout.createSequentialGroup()
                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel29, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel28, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel31, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel28Layout.createSequentialGroup()
                                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                    .addComponent(jTextFieldXMin, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextFieldYMin, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jTextFieldYMax, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextFieldXMax, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(jPanel28Layout.createSequentialGroup()
                                .addComponent(jTextFieldZMin, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jTextFieldZMax, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(67, 67, 67)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                .addComponent(jLabel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jLabel6))
                            .addComponent(jLabel30, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(5, 5, 5)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jTextFieldYMaxLength, javax.swing.GroupLayout.DEFAULT_SIZE, 49, Short.MAX_VALUE)
                            .addComponent(jTextFieldXMaxLength, javax.swing.GroupLayout.DEFAULT_SIZE, 49, Short.MAX_VALUE)
                            .addComponent(jTextFieldZMaxLength)))
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addGap(345, 345, 345)
                        .addComponent(jLabel42))
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addComponent(jLabel43))
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxSamePattern, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxHighPattern, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxVectorsContinuous, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxVectorClosedPolygon, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxVectorOrderedClosedPolygon, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(36, 36, 36)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel40)
                            .addComponent(jLabel39)
                            .addComponent(jLabel41)))
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addComponent(jCheckBoxSameIntensity, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addComponent(jCheckBoxOnePath, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addComponent(jCheckBox2dOnly, javax.swing.GroupLayout.PREFERRED_SIZE, 170, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(173, Short.MAX_VALUE))
        );
        jPanel28Layout.setVerticalGroup(
            jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel28Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel43)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBoxSameIntensity)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBoxSamePattern)
                    .addComponent(jLabel39))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBoxHighPattern)
                    .addComponent(jLabel40))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox2dOnly)
                .addGap(1, 1, 1)
                .addComponent(jCheckBoxOnePath)
                .addGap(0, 0, 0)
                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBoxVectorsContinuous)
                    .addComponent(jLabel41))
                .addGap(4, 4, 4)
                .addComponent(jCheckBoxVectorClosedPolygon)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBoxVectorOrderedClosedPolygon)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel28)
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel28Layout.createSequentialGroup()
                                .addComponent(jTextFieldXMin, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
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
                            .addComponent(jLabel31)))
                    .addGroup(jPanel28Layout.createSequentialGroup()
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel5)
                            .addComponent(jTextFieldXMaxLength, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel6)
                            .addComponent(jTextFieldYMaxLength, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel28Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel30)
                            .addComponent(jTextFieldZMaxLength, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel42)
                .addGap(49, 49, 49))
        );

        jTabbedPane5.addTab("vectorlist status", jPanel28);

        javax.swing.GroupLayout jPanel17Layout = new javax.swing.GroupLayout(jPanel17);
        jPanel17.setLayout(jPanel17Layout);
        jPanel17Layout.setHorizontalGroup(
            jPanel17Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
        );
        jPanel17Layout.setVerticalGroup(
            jPanel17Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 372, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        jLabelMaxY.setText("128");

        jLabelY0.setText("000");

        jLabelMinY.setText("-128");

        jSliderSourceScale.setMajorTickSpacing(1);
        jSliderSourceScale.setMaximum(25);
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

        jPanel18.setLayout(null);

        jLabelStartInX.setText("start point:");
        jPanel18.add(jLabelStartInX);
        jLabelStartInX.setBounds(13, 1, 90, 15);

        jLabelCurrent.setText("current:");
        jPanel18.add(jLabelCurrent);
        jLabelCurrent.setBounds(173, 1, 80, 15);

        jTextFieldStartX.setText("80");
        jPanel18.add(jTextFieldStartX);
        jTextFieldStartX.setBounds(10, 20, 40, 19);

        jTextFieldCurrentZ.setText("80");
        jPanel18.add(jTextFieldCurrentZ);
        jTextFieldCurrentZ.setBounds(270, 20, 40, 19);

        jTextFieldCurrentY.setText("80");
        jPanel18.add(jTextFieldCurrentY);
        jTextFieldCurrentY.setBounds(220, 20, 40, 19);

        jLabelCount.setText("vector count:");
        jPanel18.add(jLabelCount);
        jLabelCount.setBounds(70, 350, 80, 15);

        jTextFieldStartZ.setText("80");
        jPanel18.add(jTextFieldStartZ);
        jTextFieldStartZ.setBounds(110, 20, 40, 19);

        jLabelX.setText("<- X(y) ->");
        jPanel18.add(jLabelX);
        jLabelX.setBounds(10, 350, 70, 15);

        jTextFieldStartY.setText("80");
        jPanel18.add(jTextFieldStartY);
        jTextFieldStartY.setBounds(60, 20, 40, 19);

        jTextFieldVectorCount.setText("0");
        jPanel18.add(jTextFieldVectorCount);
        jTextFieldVectorCount.setBounds(150, 350, 30, 19);

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
        singleVectorPanel1.setBounds(10, 40, 300, 300);

        jTextFieldCurrentX.setText("80");
        jPanel18.add(jTextFieldCurrentX);
        jTextFieldCurrentX.setBounds(170, 20, 40, 19);

        jCheckBoxGrid.setSelected(true);
        jCheckBoxGrid.setText("grid");
        jCheckBoxGrid.setToolTipText("display grid");
        jCheckBoxGrid.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                jCheckBoxGridItemStateChanged(evt);
            }
        });
        jPanel18.add(jCheckBoxGrid);
        jCheckBoxGrid.setBounds(230, 350, 50, 19);

        jTextFieldGridWidth.setText("1");
        jTextFieldGridWidth.setToolTipText("grid distance");
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
        jTextFieldGridWidth.setBounds(280, 350, 30, 19);

        jCheckBoxByteFrame.setSelected(true);
        jCheckBoxByteFrame.setText("byteFrame");
        jCheckBoxByteFrame.setToolTipText("display a frame around coordinates of a signed byte (-128 <-> +127)");
        jCheckBoxByteFrame.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxByteFrameActionPerformed(evt);
            }
        });

        jPanel31.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jButtonSelectAll.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/asterisk_orange.png"))); // NOI18N
        jButtonSelectAll.setToolTipText("select all (vectors)");
        jButtonSelectAll.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonSelectAll.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSelectAll.setPreferredSize(new java.awt.Dimension(65, 19));
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
        jButtonRedo.setToolTipText("Redo");
        jButtonRedo.setEnabled(false);
        jButtonRedo.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonRedo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRedoActionPerformed(evt);
            }
        });

        jButtonUndo.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_undo.png"))); // NOI18N
        jButtonUndo.setToolTipText("Undo");
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
                .addComponent(jButtonSelectAll, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
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
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel31Layout.setVerticalGroup(
            jPanel31Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel31Layout.createSequentialGroup()
                .addComponent(jButtonSelectAll, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
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
        );

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
        jButtonUp.setBounds(20, 0, 18, 18);

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
        jButtonDown.setBounds(20, 40, 18, 18);

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
        jButtonLeft.setBounds(0, 19, 20, 19);

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
        jButtonRight.setBounds(40, 19, 20, 19);

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabelScale, javax.swing.GroupLayout.PREFERRED_SIZE, 67, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(jPanel6Layout.createSequentialGroup()
                            .addComponent(jSliderSourceScale, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPanel6Layout.createSequentialGroup()
                                    .addGap(2, 2, 2)
                                    .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                        .addComponent(jLabelMinY, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jLabelY0, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jLabelMaxY, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addGroup(jPanel6Layout.createSequentialGroup()
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jPanelScroller, javax.swing.GroupLayout.PREFERRED_SIZE, 51, javax.swing.GroupLayout.PREFERRED_SIZE))))
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel6Layout.createSequentialGroup()
                            .addGap(4, 4, 4)
                            .addComponent(jCheckBoxByteFrame))))
                .addComponent(jPanel18, javax.swing.GroupLayout.PREFERRED_SIZE, 318, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel17, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jPanel31, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jCheckBoxByteFrame)
                        .addGap(12, 12, 12)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jSliderSourceScale, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 311, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel6Layout.createSequentialGroup()
                                .addComponent(jLabelMaxY)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jPanelScroller, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(63, 63, 63)
                                .addComponent(jLabelY0)
                                .addGap(93, 93, 93)
                                .addComponent(jLabelMinY)
                                .addGap(31, 31, 31)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabelScale))
                    .addComponent(jPanel18, javax.swing.GroupLayout.PREFERRED_SIZE, 378, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel17, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 0, 0)
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
                    .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(applyCurrent, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(3, 3, 3)
                .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(0, 0, 0)
                .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(applyCurrent, javax.swing.GroupLayout.PREFERRED_SIZE, 160, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

        
    private void jSliderSourceScaleStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSourceScaleStateChanged
        if (inSetting>0) return;
        int value = jSliderSourceScale.getValue();
        int max = jSliderSourceScale.getMaximum();

        double scale = value - ((max-1)/2);
        
        
        if (value <((max/2)+1))
        {
            int invScale = ((max/2)+2)-value;
            scale = 1.0/invScale;
        }
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
        single3dDisplayPanel.setAngleX(value);
    }//GEN-LAST:event_jSliderFrontStateChanged

    private void jSliderSideStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSideStateChanged
        if (inSetting>0) return;
        int value = jSliderSide.getValue();
        jTextFieldSide.setText(""+value);
        single3dDisplayPanel.setAngleY(value);
    }//GEN-LAST:event_jSliderSideStateChanged

    private void jSliderTopStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderTopStateChanged
        if (inSetting>0) return;
        int value = jSliderTop.getValue();
        jTextFieldTop.setText(""+value);
        single3dDisplayPanel.setAngleZ(value);
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
        single3dDisplayPanel.setTranslocationZ(value);
    }//GEN-LAST:event_jSliderFrontTranslocationZStateChanged

    private void jSliderFrontTranslocationYStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderFrontTranslocationYStateChanged
        if (inSetting>0) return;
        int value = jSliderFrontTranslocationY.getValue();
        jTextFieldSide1.setText(""+value);
        single3dDisplayPanel.setTranslocationY(value);
    }//GEN-LAST:event_jSliderFrontTranslocationYStateChanged

    private void jSliderFrontTranslocationXStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderFrontTranslocationXStateChanged
        if (inSetting>0) return;
        int value = jSliderFrontTranslocationX.getValue();
        jTextFieldFront1.setText(""+value);
        single3dDisplayPanel.setTranslocationX(value);
    }//GEN-LAST:event_jSliderFrontTranslocationXStateChanged

    private void jCheckBoxDisplayAxisActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxDisplayAxisActionPerformed
        single3dDisplayPanel.setAxisShown(jCheckBoxDisplayAxis.isSelected());
        
    }//GEN-LAST:event_jCheckBoxDisplayAxisActionPerformed

    private void jSliderTop1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderTop1StateChanged
        if (inSetting>0) return;
        int value = jSliderTop1.getValue();
        jTextFieldTop2.setText(""+value);
        single3dDisplayPanel.setAxisAngleZ(value);
    }//GEN-LAST:event_jSliderTop1StateChanged

    private void jSliderSide1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSide1StateChanged
        if (inSetting>0) return;
        int value = jSliderSide1.getValue();
        jTextFieldSide2.setText(""+value);
        single3dDisplayPanel.setAxisAngleY(value);
    }//GEN-LAST:event_jSliderSide1StateChanged

    private void jSliderFront1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderFront1StateChanged
        if (inSetting>0) return;
        int value = jSliderFront1.getValue();
        jTextFieldFront2.setText(""+value);
        single3dDisplayPanel.setAxisAngleX(value);
    }//GEN-LAST:event_jSliderFront1StateChanged

    private void jPopupMenuLineMouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPopupMenuLineMouseExited
        jPopupMenuLine.setVisible(false);
    }//GEN-LAST:event_jPopupMenuLineMouseExited

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
        String filename ="xml"+File.separator+"vectorlist";
        String saveName = VectorListFileChoserJPanel.showSavePanel(filename, "Save Vectorlist", false);
        if (saveName != null)
            saveCurrentList(saveName);
    }//GEN-LAST:event_jButtonSave1ActionPerformed

    String lastPath = "";
    private void jButtonLoadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoadActionPerformed
        String filename ="xml"+File.separator+"vectorlist";
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
        single3dDisplayPanel.setAxisAngleX(0);
        
        jSliderSide1.setValue(0);
        jTextFieldSide2.setText("0");
        single3dDisplayPanel.setAxisAngleY(0);

        jSliderTop1.setValue(0);
        jTextFieldTop2.setText("0");
        single3dDisplayPanel.setAxisAngleZ(0);
        
        
        
        inSetting--;
        
    }//GEN-LAST:event_jButton2dAxisActionPerformed

    private void jButton3dAxisActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3dAxisActionPerformed
        inSetting++;
        jSliderFront1.setValue(38);
        jTextFieldFront2.setText("38");
        single3dDisplayPanel.setAxisAngleX(38);
        
        jSliderSide1.setValue(49);
        jTextFieldSide2.setText("49");
        single3dDisplayPanel.setAxisAngleY(49);

        jSliderTop1.setValue(31);
        jTextFieldTop2.setText("31");
        single3dDisplayPanel.setAxisAngleZ(31);
        
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
        if (jRadioButton1.isSelected())
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
        if (KeyboardListener.isShiftDown())
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

//        copy.setRelativeWherePossible();
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
        String filename ="xml"+File.separator+"vectorlist";
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
       
        String filename ="xml"+File.separator+"vectorlist";
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

    private void jButtonCutActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCutActionPerformed
        addHistory();
        jButtonCopyActionPerformed(null);
        jMenuItemLineDeleteActionPerformed(null);
        fillStatus();
    }//GEN-LAST:event_jButtonCutActionPerformed

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
        
        listNow.removePoints();
        
        
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

    private void jButtonSelectAllActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSelectAllActionPerformed
        GFXVectorList listNow = singleVectorPanel1.getForegroundVectorList();
        for (int i=0; i<listNow.size(); i++)
        {
            GFXVector v = listNow.get(i);
            v.selected = true;
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

    private void jRadioButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton2ActionPerformed
        if (mClassSetting>0) return;
        if (currentAnimation == null) return;
        currentAnimation.isAnimation = !jRadioButton2.isSelected();
        if (jRadioButton2.isSelected())
            doScenario();
        checkAnimExportButtons();        
    }//GEN-LAST:event_jRadioButton2ActionPerformed

    private void jRadioButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton1ActionPerformed
        if (mClassSetting>0) return;
        if (currentAnimation == null) return;
        currentAnimation.isAnimation = jRadioButton1.isSelected();
        if (jRadioButton1.isSelected())
            doAnimation();
        checkAnimExportButtons();
    }//GEN-LAST:event_jRadioButton1ActionPerformed

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
        if (KeyboardListener.isShiftDown())
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
        vl.scaleAll(scale, safetyMap);
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
        vl.scaleAll(scale, safetyMap);
        
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
        
        String filename = "tmp"+File.separator+"veccytmp.asm";
        de.malban.util.UtilityFiles.createTextFile(filename, jTextAreaResult.getText());
        startASM(filename);
    }//GEN-LAST:event_jButtonAssembleActionPerformed
    // http://stackoverflow.com/questions/6710350/copying-text-to-the-clipboard-using-java
    private static void copy(String text)
    {
        Clipboard clipboard = getSystemClipboard();

        clipboard.setContents(new StringSelection(text), null);
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
        String text = vl.createASMMov_Draw_VLc_a(true, name, jCheckBoxAddFactor.isSelected());
        if (jCheckBoxAddFactor.isSelected())
        {
            text = "BLOW_UP EQU 1\n\n"+text;
        }
        
        if (jCheckBoxRunnable.isSelected())
        {
            Path template = Paths.get(".", "template", "vectorlistMov_Draw_VLc_a.template");
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            text = main +text;
        }
        
        
        jTextAreaResult.setText(text);
        copy(text);
        checkAssemblerButton();
    }//GEN-LAST:event_jButtonMov_Draw_VLc_aActionPerformed

    private void jButtonDraw_VLcActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_VLcActionPerformed
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname.getText();
        if (name.trim().length() == 0) name = "VectorList";
        String text = vl.createASMMov_Draw_VLc_a(false, name, jCheckBoxAddFactor.isSelected());
        if (jCheckBoxAddFactor.isSelected())
        {
            text = "BLOW_UP EQU 1\n\n"+text;
        }
        if (jCheckBoxRunnable.isSelected())
        {
            Path template = Paths.get(".", "template", "vectorlistDraw_VLc.template");
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            text = main +text;
        }
        jTextAreaResult.setText(text);
        copy(text);
        checkAssemblerButton();
    }//GEN-LAST:event_jButtonDraw_VLcActionPerformed

    private void jButtonDraw_VLpActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_VLpActionPerformed
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname.getText();
        if (name.trim().length() == 0) name = "VectorList";
        String text = vl.createASMDraw_VLp(name, jCheckBoxAddFactor.isSelected());
        if (jCheckBoxAddFactor.isSelected())
        {
            text = "BLOW_UP EQU 1\n\n"+text;
        }
        if (jCheckBoxRunnable.isSelected())
        {
            Path template = Paths.get(".", "template", "vectorlistDraw_VLp.template");
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            text = main +text;
        }
        jTextAreaResult.setText(text);
        copy(text);
        checkAssemblerButton();
    }//GEN-LAST:event_jButtonDraw_VLpActionPerformed

    private void jButtonDraw_VL_modeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_VL_modeActionPerformed
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname.getText();
        if (name.trim().length() == 0) name = "VectorList";
        if (jCheckBoxVec32.isSelected())
        {
            String text = vl.createASMDraw_VL_modeBASIC(name);
            copy(text);
            
            if (jCheckBoxRunnable.isSelected())
            {
                text = "function getVectorList()\n" + text + "\n     return VectorList\nendfunction\n";
                Path template = Paths.get(".", "template", "drawVectorlist.bas");
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
            Path template = Paths.get(".", "template", "vectorlistDraw_VL_mode.template");
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            text = main +text;
        }
        
        jTextAreaResult.setText(text);
        copy(text);
        checkAssemblerButton();
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
        String text = currentAnimation.createASMMov_Draw_VLc_a(name, jCheckBoxAddFactor.isSelected());
        if (jCheckBoxAddFactor.isSelected())
        {
            text = "BLOW_UP EQU 1\n\n"+text;
        }

        if (jCheckBoxRunnable.isSelected())
        {
            Path template;
            if (currentAnimation.isAnimation)
                template = Paths.get(".", "template", "animationMov_Draw_VLc_a.template");
            else
                template = Paths.get(".", "template", "scenarioMov_Draw_VLc_a.template");
                
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            main += "vDataLength = "+currentAnimation.size()+"\n";
            text = main +text;
        }
        
        jTextAreaResult.setText(text);
        copy(text);
        checkAssemblerButton();
    }//GEN-LAST:event_jButtonMov_Draw_VLc_aAnimActionPerformed

    private void jButtonDraw_VLcAnimActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_VLcAnimActionPerformed
        String name = jTextFieldAnimName.getText();
        if (!currentAnimation.isAnimation) return;
        if (name.trim().length() == 0) 
        {
            if (currentAnimation.isAnimation)
                name = "AnimList";
            else
                name = "SceneList";
        }

        String text = currentAnimation.createASMDraw_VLc(name, jCheckBoxAddFactor.isSelected());
        if (jCheckBoxAddFactor.isSelected())
        {
            text = "BLOW_UP EQU 1\n\n"+text;
        }
        
        if (jCheckBoxRunnable.isSelected())
        {
            Path template;
            if (currentAnimation.isAnimation)
                template = Paths.get(".", "template", "animationDraw_VLc.template");
            else
                template = Paths.get(".", "template", "scenarioDraw_VLc.template");
                
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            main += "vDataLength = "+currentAnimation.size()+"\n";
            text = main +text;
        }
        
        jTextAreaResult.setText(text);
        copy(text);
        checkAssemblerButton();
    }//GEN-LAST:event_jButtonDraw_VLcAnimActionPerformed

    private void jButtonDraw_VLpAnimActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_VLpAnimActionPerformed
        if (!currentAnimation.isAnimation) return;
        String name = jTextFieldAnimName.getText();
        if (name.trim().length() == 0) 
        {
            if (currentAnimation.isAnimation)
                name = "AnimList";
            else
                name = "SceneList";
        }

        String text = currentAnimation.createASMDraw_VLp(name, jCheckBoxAddFactor.isSelected());
        if (jCheckBoxAddFactor.isSelected())
        {
            text = "BLOW_UP EQU 1\n\n"+text;
        }
        
        if (jCheckBoxRunnable.isSelected())
        {
            Path template;
            if (currentAnimation.isAnimation)
                template = Paths.get(".", "template", "animationDraw_VLp.template");
            else
                template = Paths.get(".", "template", "scenarioDraw_VLp.template");
                
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            main += "vDataLength = "+currentAnimation.size()+"\n";
            text = main +text;
        }
        
        jTextAreaResult.setText(text);
        copy(text);
        checkAssemblerButton();
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

        String text = currentAnimation.createASMDraw_VL_mode(name, true, jCheckBoxAddFactor.isSelected());
        if (jCheckBoxAddFactor.isSelected())
        {
            text = "BLOW_UP EQU 1\n\n"+text;
        }
        if (jCheckBoxRunnable.isSelected())
        {
            Path template;
            if (currentAnimation.isAnimation)
                template = Paths.get(".", "template", "animationDraw_VL_mode.template");
            else
                template = Paths.get(".", "template", "scenarioDraw_VL_mode.template");
                
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            main += "vDataLength = "+currentAnimation.size()+"\n";
            text = main +text;
        }
        jTextAreaResult.setText(text);
        
        copy(text);
        checkAssemblerButton();
    }//GEN-LAST:event_jButtonDraw_VL_modeAnimActionPerformed

    private void jButtonUndoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonUndoActionPerformed
        stepBackHistory();
        singleVectorPanel1.sharedRepaint();
        jTable1.tableChanged(null);
        fillStatus();
    }//GEN-LAST:event_jButtonUndoActionPerformed

    private void jButtonRedoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRedoActionPerformed
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

    private void applyCurrentComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_applyCurrentComponentResized
        Rectangle r = jScrollPane2.getBounds();
        r.width = applyCurrent.getWidth()-15;
        jScrollPane2.setBounds(r);
    }//GEN-LAST:event_applyCurrentComponentResized

    private void jCheckBoxOnePathActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxOnePathActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxOnePathActionPerformed

    private void jButtonOrderSplitWhereNeededActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOrderSplitWhereNeededActionPerformed
        singleVectorPanel1.getForegroundVectorList().splitWhereNeeded();
        
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
        frame.addPanel(p);
        frame.setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame f = frame.windowMe(p, 1024, 768, VediPanel.SID);
        
        
        String tmpFile = "tmp"+File.separator+"veccyAsm.asm";
        de.malban.util.UtilityFiles.createTextFile(tmpFile, jTextAreaResult.getText());
        p.addTempEditFile(tmpFile);
        
        
    }//GEN-LAST:event_jButtonEditInVediActionPerformed

    private void jButtonEditInVedi1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEditInVedi1ActionPerformed
        
        CSAMainFrame frame = (CSAMainFrame)Configuration.getConfiguration().getMainFrame();
//        VediPanel vedi = frame.getVedi();
        
        VediPanel p = new VediPanel(false);        
        p.setTreeVisible(false);
        frame.addPanel(p);
        frame.setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame f = frame.windowMe(p, 1024, 768, VediPanel.SID);
        
        
        String tmpFile = "tmp"+File.separator+"veccyAsm.asm";
        de.malban.util.UtilityFiles.createTextFile(tmpFile, jTextAreaResult1.getText());
        p.addTempEditFile(tmpFile);
    }//GEN-LAST:event_jButtonEditInVedi1ActionPerformed

    private void jButtonAssemble1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssemble1ActionPerformed
        String filename = "tmp"+File.separator+"veccytmp.asm";
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
            Path template = Paths.get(".", "template", "vectorlistCodeGen.template");
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
                template = Paths.get(".", "template", "animationCodeGen.template");
            else
                template = Paths.get(".", "template", "scenarioCodeGen.template");
                
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

    private void jButtonUpActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonUpActionPerformed
        singleVectorPanel1.addYOffset(-1);
    }//GEN-LAST:event_jButtonUpActionPerformed

    private void jButtonDownActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDownActionPerformed
        singleVectorPanel1.addYOffset(1);
    }//GEN-LAST:event_jButtonDownActionPerformed

    private void jButtonRightActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRightActionPerformed
        singleVectorPanel1.addXOffset(1);
    }//GEN-LAST:event_jButtonRightActionPerformed

    private void jButtonLeftActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLeftActionPerformed
        singleVectorPanel1.addXOffset(-1);

    }//GEN-LAST:event_jButtonLeftActionPerformed

    private void jButtonDraw_syncListActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDraw_syncListActionPerformed

        int resync = de.malban.util.UtilityString.IntX(jTextFieldResync.getText(), 20);
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        String name = jTextFieldLabelListname.getText();
        if (name.trim().length() == 0) name = "VectorList";
        String text = vl.createASMDraw_syncList(name, jCheckBoxAddFactor.isSelected(), resync);
        if (jCheckBoxAddFactor.isSelected())
        {
            text = "BLOW_UP EQU 1\n\n"+text;
        }
        if (jCheckBoxRunnable.isSelected())
        {
            Path template = Paths.get(".", "template", "vectorlistDraw_sync.template");
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            
            text = main +text;
        }
        
        jTextAreaResult.setText(text);
        copy(text);
        checkAssemblerButton();
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

        String text = currentAnimation.createASMDraw_syncList(name, jCheckBoxAddFactor.isSelected(), resync);
        if (jCheckBoxAddFactor.isSelected())
        {
            text = "BLOW_UP EQU 1\n\n"+text;
        }
        if (jCheckBoxRunnable.isSelected())
        {
            Path template;
            if (currentAnimation.isAnimation)
                template = Paths.get(".", "template", "animationDraw_sync.template");
            else
                template = Paths.get(".", "template", "scenarioDraw_sync.template");
                
            String main = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
            main += "\nvData = "+name+"\n";
            main += "vDataLength = "+currentAnimation.size()+"\n";
            text = main +text;
        }
        jTextAreaResult.setText(text);
        
        copy(text);
        checkAssemblerButton();
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
            lastImagePath="."+File.separator;
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

    // interface function for communication of events with singleVectorPanel
    public void pressed(EditMouseEvent evt)
    {
        historyAdded = false;
        SingleVectorPanel svp = (SingleVectorPanel)evt.panel;
        Vertex p = svp.getLastClickPoint();
        p = svp.convertToVectrex(p);

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
            // and links the old allways to start of the new
            // and the new allways to end of old!
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
        SingleVectorPanel svp = (SingleVectorPanel)evt.panel;
        Vertex p = svp.getCurrentPoint();
        p = svp.convertToVectrex(p);
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
                Vertex t = svp.getDragTranslocation(evt.dragOriginX, evt.dragOriginY, evt.dragNowX, evt.dragNowY);

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
                            start.coord()[axis1] -= t.coord()[axis1];
                            start.coord()[axis2] -= t.coord()[axis2];
                        }
                    }
                    Vertex end = v.end;
                    if (end.selected)
                    {
                        if (alreadyDone.get(end) == null) 
                        {
                            alreadyDone.put(end, end);
                            end.coord()[axis1] -= t.coord()[axis1];
                            end.coord()[axis2] -= t.coord()[axis2];
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
                Vertex t = svp.getDragTranslocation(evt.dragOriginX, evt.dragOriginY, evt.dragNowX, evt.dragNowY);
                
                ArrayList<GFXVector> toTranslocate = svp.getSelectedVectors();
                HashMap<Vertex, Vertex> alreadyDone = new HashMap<Vertex, Vertex>();
                for (GFXVector v: toTranslocate)
                {
                    Vertex start = v.start;
                    if (alreadyDone.get(start) == null) 
                    {
                        alreadyDone.put(start, start);
                        start.coord()[axis1] -= t.coord()[axis1];
                        start.coord()[axis2] -= t.coord()[axis2];
                    }
                    Vertex end = v.end;
                    if (alreadyDone.get(end) == null) 
                    {
                        alreadyDone.put(end, end);
                        end.coord()[axis1] -= t.coord()[axis1];
                        end.coord()[axis2] -= t.coord()[axis2];
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
    private javax.swing.JPanel applyCurrent;
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton2dAxis;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton3dAxis;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JButton jButtonAddCurrent;
    private javax.swing.JButton jButtonAddCurrent1;
    private javax.swing.JButton jButtonAnimCodeGen;
    private javax.swing.JButton jButtonApplyCurrent;
    private javax.swing.JButton jButtonAssemble;
    private javax.swing.JButton jButtonAssemble1;
    private javax.swing.JButton jButtonClearAnimation;
    private javax.swing.JButton jButtonCodeGen;
    private javax.swing.JButton jButtonConnectWherePossible;
    private javax.swing.JButton jButtonCopy;
    private javax.swing.JButton jButtonCube;
    private javax.swing.JButton jButtonCut;
    private javax.swing.JButton jButtonDeleteOne;
    private javax.swing.JButton jButtonDown;
    private javax.swing.JButton jButtonDraw_VL_mode;
    private javax.swing.JButton jButtonDraw_VL_modeAnim;
    private javax.swing.JButton jButtonDraw_VLc;
    private javax.swing.JButton jButtonDraw_VLcAnim;
    private javax.swing.JButton jButtonDraw_VLp;
    private javax.swing.JButton jButtonDraw_VLpAnim;
    private javax.swing.JButton jButtonDraw_syncList;
    private javax.swing.JButton jButtonDraw_syncListAnim;
    private javax.swing.JButton jButtonEditInVedi;
    private javax.swing.JButton jButtonEditInVedi1;
    private javax.swing.JButton jButtonEnlarge;
    private javax.swing.JButton jButtonEnlarge1;
    private javax.swing.JButton jButtonExpandDimensionYZ;
    private javax.swing.JButton jButtonExport;
    private javax.swing.JButton jButtonExport1;
    private javax.swing.JButton jButtonFillGaps;
    private javax.swing.JButton jButtonFitByteRange;
    private javax.swing.JButton jButtonFitByteRange1;
    private javax.swing.JButton jButtonInsertYM;
    private javax.swing.JButton jButtonInterprete;
    private javax.swing.JButton jButtonJoin;
    private javax.swing.JButton jButtonLeft;
    private javax.swing.JButton jButtonLoad;
    private javax.swing.JButton jButtonLoad1;
    private javax.swing.JButton jButtonLoad2;
    private javax.swing.JButton jButtonMirrorHorizontally;
    private javax.swing.JButton jButtonMirrorVertically;
    private javax.swing.JButton jButtonMov_Draw_VLc_a;
    private javax.swing.JButton jButtonMov_Draw_VLc_aAnim;
    private javax.swing.JButton jButtonOneBack;
    private javax.swing.JButton jButtonOneForward;
    private javax.swing.JButton jButtonOneForwardSelection1;
    private javax.swing.JButton jButtonOneForwardSelection2;
    private javax.swing.JButton jButtonOrderSplitWhereNeeded;
    private javax.swing.JButton jButtonOrderVectorlist;
    private javax.swing.JButton jButtonPaste;
    private javax.swing.JButton jButtonPathsAsScenario;
    private javax.swing.JButton jButtonRedo;
    private javax.swing.JButton jButtonRemoveDots;
    private javax.swing.JButton jButtonReverse;
    private javax.swing.JButton jButtonRight;
    private javax.swing.JButton jButtonRotate2d;
    private javax.swing.JButton jButtonSave1;
    private javax.swing.JButton jButtonSave2;
    private javax.swing.JButton jButtonSave3;
    private javax.swing.JButton jButtonSaveSelection;
    private javax.swing.JButton jButtonSelectAll;
    private javax.swing.JButton jButtonSetStyle;
    private javax.swing.JButton jButtonShrink;
    private javax.swing.JButton jButtonShrink1;
    private javax.swing.JButton jButtonUndo;
    private javax.swing.JButton jButtonUp;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox2dOnly;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JCheckBox jCheckBox5;
    private javax.swing.JCheckBox jCheckBoxAddFactor;
    private javax.swing.JCheckBox jCheckBoxArrows;
    private javax.swing.JCheckBox jCheckBoxAutoApply;
    private javax.swing.JCheckBox jCheckBoxAutoEdit;
    private javax.swing.JCheckBox jCheckBoxByteFrame;
    private javax.swing.JCheckBox jCheckBoxContinue;
    private javax.swing.JCheckBox jCheckBoxDisplayAxis;
    private javax.swing.JCheckBox jCheckBoxDragVectors;
    private javax.swing.JCheckBox jCheckBoxFraktion;
    private javax.swing.JCheckBox jCheckBoxFraktion1;
    private javax.swing.JCheckBox jCheckBoxGrid;
    private javax.swing.JCheckBox jCheckBoxHasIntensity;
    private javax.swing.JCheckBox jCheckBoxHasPattern;
    private javax.swing.JCheckBox jCheckBoxHighPattern;
    private javax.swing.JCheckBox jCheckBoxLine;
    private javax.swing.JCheckBox jCheckBoxMoves;
    private javax.swing.JCheckBox jCheckBoxMulti;
    private javax.swing.JCheckBox jCheckBoxOnePath;
    private javax.swing.JCheckBox jCheckBoxPointsOk;
    private javax.swing.JCheckBox jCheckBoxPosition;
    private javax.swing.JCheckBox jCheckBoxRunnable;
    private javax.swing.JCheckBox jCheckBoxRunnable1;
    private javax.swing.JCheckBox jCheckBoxSameIntensity;
    private javax.swing.JCheckBox jCheckBoxSamePattern;
    private javax.swing.JCheckBox jCheckBoxScaleToByte;
    private javax.swing.JCheckBox jCheckBoxVec32;
    private javax.swing.JCheckBox jCheckBoxVectorClosedPolygon;
    private javax.swing.JCheckBox jCheckBoxVectorOrderedClosedPolygon;
    private javax.swing.JCheckBox jCheckBoxVectorsContinuous;
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
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JLabel jLabelAnim;
    private javax.swing.JLabel jLabelCount;
    private javax.swing.JLabel jLabelCurrent;
    private javax.swing.JLabel jLabelDelay;
    private javax.swing.JLabel jLabelDelay1;
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
    private javax.swing.JMenuItem jMenuItemPoint0;
    private javax.swing.JMenuItem jMenuItemRip;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel10;
    private javax.swing.JPanel jPanel11;
    private javax.swing.JPanel jPanel12;
    private javax.swing.JPanel jPanel13;
    private javax.swing.JPanel jPanel14;
    private javax.swing.JPanel jPanel15;
    private javax.swing.JPanel jPanel16;
    private javax.swing.JPanel jPanel17;
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
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    private javax.swing.JPanel jPanelIMageCollection;
    private javax.swing.JPanel jPanelScroller;
    private javax.swing.JPopupMenu jPopupMenuLine;
    private javax.swing.JPopupMenu jPopupMenuPoint;
    private javax.swing.JRadioButton jRadioButton1;
    private javax.swing.JRadioButton jRadioButton2;
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
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField10;
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
    private javax.swing.JTextField jTextFieldLabelListname;
    private javax.swing.JTextField jTextFieldLabelListname1;
    private javax.swing.JTextField jTextFieldMorphSteps;
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
        jRadioButton1.setSelected(currentAnimation.isAnimation);
        jRadioButton2.setSelected(!currentAnimation.isAnimation);
        mClassSetting--;
        
        checkAnimExportButtons();
     
    }
    
    void checkAnimExportButtons()
    {
        // export Anims
        jButtonMov_Draw_VLc_aAnim.setEnabled(true);
        jButtonDraw_VLcAnim.setEnabled(currentAnimation.isAnimation);
        jButtonDraw_VLpAnim.setEnabled(currentAnimation.isAnimation);
        jButtonDraw_VL_modeAnim.setEnabled(true);
        jButtonAnimCodeGen.setEnabled(true);

                
        boolean allSamePattern = currentAnimation.isAllSamePattern();
        boolean allContinuous = currentAnimation.isCompleteRelative();
        boolean allHighPattern = currentAnimation.isAllPatternHigh();


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
                    lastSetUID = selectedAnimationFrameUID;
                    preSelectedAnimationFrameUID = selectedAnimationFrameUID;
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
        String filename ="xml"+File.separator+"vectoranimation";
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
        String filename ="xml"+File.separator+"vectoranimation";
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
     //   if (steps == 0) return;
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
        }
        if (jCheckBox3.isSelected())
        {
            angleXTarget = de.malban.util.UtilityString.Int0(jTextFieldRotateX.getText());
            if (angleXTarget>0)
            {
                incX = angleXTarget/((double)steps);
            }
        }
        if (jCheckBox4.isSelected())
        {
            angleYTarget = de.malban.util.UtilityString.Int0(jTextFieldRotateY.getText());
            if (angleYTarget>0)
            {
                incY = angleYTarget/((double)steps);
            }
        }
        
        
        GFXVectorList newList = start.clone();
        newList.resetDisplay();


        currentAnimation.add(newList);
        selectedAnimationFrameUID = newList.uid;
        preSelectedAnimationFrameUID = selectedAnimationFrameUID;

        angleX+=incX;
        angleY+=incY;
        angleZ+=incZ;
        
        
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
                
            
            
            
            
            angleX+=incX;
            angleY+=incY;
            angleZ+=incZ;
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
//        centerVectorList();
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
            knownPatterns = (Vector<PatternInfo>) CSAMainFrame.deserialize("serialize"+File.separator+"PatternInfo.ser");
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
            CSAMainFrame.serialize(knownPatterns, "serialize"+File.separator+"PatternInfo.ser");
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
        }
        
    }
    
    void fillStatus()
    {
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();
        jTextFieldVectorCount.setText(""+vl.size());
        jCheckBoxSameIntensity.setSelected(vl.isAllSameIntensity());
        jCheckBoxSamePattern.setSelected(vl.isAllSamePattern());
        jCheckBoxHighPattern.setSelected(vl.isAllPatternHigh());
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
        if (!jCheckBoxVectorsContinuous.isSelected())
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
        if (!jCheckBoxHighPattern.isSelected())
        {
            jButtonDraw_VLp.setEnabled(false);
        }
        if ((vl.getXMaxLength()>127) || (vl.getYMaxLength()>127)|| (vl.getZMaxLength()>127))
        {
            jButtonMov_Draw_VLc_a.setEnabled(false);
            jButtonDraw_VLc.setEnabled(false);
            jButtonDraw_VLp.setEnabled(false);
            jButtonDraw_VL_mode.setEnabled(false);
        }

        
        
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
        jRadioButton2.setSelected(true);
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
                        Asmj asm = new Asmj(filenameASM, null, null, null, null, "");
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


            String fname = "tmp"+File.separator+"veccytmp.bin";
            vec.startUp(fname);
            log.addLog("Veccy-Assembly successfull...", INFO);
        }
        else
        {
            log.addLog("Veccy-Assembly not successfull, see ASM output...", WARN);
        }
        checkAssemblerButton();
        checkAssemblerButton2();
    }
    void fitByteRangeCollection()
    {
        double max = currentAnimation.getMaxAbsLenValue();

        // a current list
//        centerVectorList();
        GFXVectorList vl = singleVectorPanel1.getForegroundVectorList();

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

}


