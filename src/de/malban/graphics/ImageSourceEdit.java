/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * ImageSourceEdit.java
 *
 * Created on 04.05.2010, 13:28:32
 */

package de.malban.graphics;

import de.malban.event.EditMouseEvent;
import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.components.ModalInternalFrame;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.dialogs.QuickHelpModal;
import de.malban.gui.ImageCache;
import de.malban.gui.dialogs.ShowInfoDialog;
import de.malban.script.ExportFrame;
import de.malban.util.UtilityString;
import java.awt.*;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.*;
import javax.imageio.ImageIO;
import javax.swing.JComponent;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.filechooser.FileNameExtensionFilter;

/**
 *
 * @author malban
 */
public class ImageSourceEdit extends javax.swing.JPanel implements
        Windowable, MousePressedListener {
    static final int SAVE_OK = 0;
    static final int SAVE_MULTI = 1;
    static final int SAVE_NOK = 2;
    public static final int MAX_ROW_WIDTH = 1024;

    Vector <BaseImageData> mData = new  Vector <BaseImageData>();
    Vector <BaseImageData> mCloneData = null;
    BaseImageData currentBase = null;

    private ImageSequenceData mISData = new ImageSequenceData();
    private ImageSequenceDataPool mImageSequenceDataPool = null;
    private ImageSequenceDataPool mFilerDataPool = null;

    boolean previewScale = true;
    int inSetting=0;
    int currentSelectedNo=-1;
    boolean newImages = false;
    String currentNotice = "";

    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;

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
        mParentMenuItem.setText("Image Resourcer");
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

    /** Creates new form ImageSourceEdit */
    @SuppressWarnings("LeakingThisInConstructor")
    public ImageSourceEdit() {
        initComponents();
        imageComponent1.setVisible(jToggleButtonPlayAnim.isSelected());

        jComboBoxName.setVisible(false);
        singleImagePanel1.addClickListener(this);
    }

    public void deinit()
    {
        imageComponent1.deinit();
        singleImagePanel1.removeClickListener(this);
    }
    boolean getPool()
    {
        String name = "Graphics"+File.separator+jTextFieldFile.getText()+".xml";
        if (jTextFieldFile.getText().trim().length() == 0) return false;
        mImageSequenceDataPool = new ImageSequenceDataPool(name);
        return true;
    }
    boolean getFilterPool()
    {
        String name = "Graphics"+File.separator+jTextField1.getText()+".xml";
        if (jTextField1.getText().trim().length() == 0) return false;
        mFilerDataPool = new ImageSequenceDataPool(name);
        return true;
    }

    private void resetConfigPool(boolean select, String klasseToSet) /* allneeded*/
    {
        if (!getPool()) return;
        if (mImageSequenceDataPool == null) return;
        mClassSetting++;

        if (select)
            if (klasseToSet.length()!=0)
                jTextFieldKlasse.setText(klasseToSet);
        setPoolOnly();
        String klasse = "";
        if (select)
        {
            if (klasseToSet.length()==0)
            {
                if (jComboBoxKlasse.getItemCount()>0)
                    jComboBoxKlasse.setSelectedIndex(0);
            }
            else
            {
                jComboBoxKlasse.setSelectedItem(klasseToSet);
                jTextFieldKlasse.setText(klasseToSet);
                klasse = klasseToSet;
            }
        }

        if ((select) && (klasse.length()==0))
        {
            if (jComboBoxKlasse.getItemCount()>0)
            {
                jComboBoxKlasse.setSelectedIndex(0);
                jTextFieldKlasse.setText(jComboBoxKlasse.getSelectedItem().toString());

            }
        }
        if (!select)  jComboBoxKlasse.setSelectedIndex(-1);
        if (!select)  jComboBoxName.setSelectedIndex(-1);
        mClassSetting--;
    }
    private void resetFilterPool(boolean select, String klasseToSet) /* allneeded*/
    {
        if (!getFilterPool()) return;

        if (mFilerDataPool == null) return;

        mClassSetting++;
        setFilterPoolOnly();
        mClassSetting--;

        mClassSetting++;
        String klasse = "";
        if (select)
        {
            if (klasseToSet.length()==0)
            {
                if (jComboBoxKlasse1.getItemCount()>0)
                    jComboBoxKlasse1.setSelectedIndex(0);
            }
            else
            {
                jComboBoxKlasse1.setSelectedItem(klasseToSet);
                klasse = klasseToSet;
            }
        }

        if ((select) && (klasse.length()==0))
        {
            if (jComboBoxKlasse1.getItemCount()>0)
            {
                jComboBoxKlasse1.setSelectedIndex(0);
            }
        }
        if (!select)  jComboBoxKlasse1.setSelectedIndex(-1);

        if (jComboBoxKlasse1.getSelectedIndex() !=-1)
        {
            fillFilterCombo();
        }
        mClassSetting--;
    }
    void fillFilterCombo()
    {
        jComboBox1.removeAllItems();

        if (jComboBoxKlasse1.getSelectedIndex()==-1) return;
        String klasse =  jComboBoxKlasse1.getSelectedItem().toString();
        if (klasse.trim().length() == 0) return;

        mClassSetting++;
        Collection<ImageSequenceData> collectionName = mFilerDataPool.getMapForKlasse(klasse).values();
        Iterator<ImageSequenceData> iterN = collectionName.iterator();
        /** Sorting */  Vector<String> nnames = new Vector<String>(); while (iterN.hasNext()) nnames.addElement(iterN.next().mName); Collections.sort(nnames, new Comparator<String>() {@Override
            public int compare(String s1, String s2) { return s1.compareTo(s2); } });

        // all names of images of klasse in nnames

        for (int j = 0; j < nnames.size(); j++)
        {
            String name = nnames.elementAt(j);
            jComboBox1.addItem(name);
        }
        mClassSetting--;
    }

    private void clearAll() /* allneeded*/
    {
        mClassSetting++;
        mISData = new ImageSequenceData();

        setAllFromCurrent();
        mClassSetting--;
        setClassList(-1,"");
    }

    private void setAllFromCurrent() /* allneeded*/
    {
        setAllFromCurrent(false);
    }
    private void setAllFromCurrent(boolean select) /* allneeded*/
    {
        mClassSetting++;
        jComboBoxKlasse.setSelectedItem(mISData.mClass);
        jTextFieldKlasse.setText(mISData.mClass);
        jComboBoxName.setSelectedItem(mISData.mName);
        jTextFieldName.setText(mISData.mName);
        setDelay(mISData.mDelay);
        singleImagePanel2.unsetImage();
        imageComponent1.setSequence(new ImageSequence());
        setCurrentData(BaseImageData.toBase(mISData));

        updateToSelectedPanel();

        currentNotice = mISData.mOriginNotice;
        jCheckBoxRandom.setSelected(mISData.mRandomAnimationStart);

        mClassSetting--;
    }
    int getI(JTextField t)
    {
        return getI(t.getText());
    }

    int getI(String t)
    {
        return  getI(t, 0);
    }
    int getI(String t, int _default)
    {
        int i=_default;
        try
        {
            i = Integer.parseInt(t);
        }
        catch (Throwable e){ }
        return i;
    }

    private void readAllToCurrent() /* allneeded*/
    {
        if (mClassSetting>0) return;
        int selectedNo = -1;
        if (currentSelectedBasePanel != null) 
        {
            selectedNo = getI(currentSelectedBasePanel.getName(),-1);
            
            // all graphics data within ONE imagesequence is changes, not within one class!
            
            if (selectedNo != -1)
            {
                BaseImageData data = mData.elementAt(selectedNo);
                String orgBase = data.fileName;
                String orgName = de.malban.util.UtilityString.getFileName(data.fileName); 
                String path = de.malban.util.UtilityString.getPath(jTextFieldImageSource.getText());
                String orgTarget = path +  orgName;

                if (orgBase.length() == 0) orgTarget="";
                
                for (int i=0; i< mData.size(); i++)
                {
                    data = mData.elementAt(i);
                    if (data.fileName.equals(orgBase))
                    {
                        data.fileName = orgTarget;
                    }
                }
            }
        }

        BaseImageData.fromBase(mISData, readAllToCurrentISE());
        mISData.mDelay = getDelay();
        mISData.mRandomAnimationStart = jCheckBoxRandom.isSelected();
        mISData.mClass = jTextFieldKlasse.getText();
        mISData.mName = jTextFieldName.getText();
        mISData.mOriginNotice = currentNotice;

        mISData.mRandomAnimationStart = jCheckBoxRandom.isSelected();

        
        if (mISData.mName.trim().length()==0)
        {
            mISData.mName="0";
            jTextFieldName.setText("0");
        }

    }
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup1 = new javax.swing.ButtonGroup();
        jPanel8 = new javax.swing.JPanel();
        jPanel6 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        singleImagePanel1 = new de.malban.graphics.SingleImagePanel();
        jLabel14 = new javax.swing.JLabel();
        jSliderSourceScale = new javax.swing.JSlider();
        jPanel5 = new javax.swing.JPanel();
        jLabel22 = new javax.swing.JLabel();
        jLabel23 = new javax.swing.JLabel();
        jLabel21 = new javax.swing.JLabel();
        jLabel20 = new javax.swing.JLabel();
        jPanel7 = new javax.swing.JPanel();
        jPanel4 = new javax.swing.JPanel();
        jLabel9 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        jPanel11 = new javax.swing.JPanel();
        jTextFieldCountAll = new javax.swing.JTextField();
        jLabel25 = new javax.swing.JLabel();
        jLabel18 = new javax.swing.JLabel();
        jLabel32 = new javax.swing.JLabel();
        jTextFieldGapX = new javax.swing.JTextField();
        jCheckBoxPaintGrid = new javax.swing.JCheckBox();
        jTextFieldCountY = new javax.swing.JTextField();
        jTextFieldGapY = new javax.swing.JTextField();
        jLabel11 = new javax.swing.JLabel();
        jLabel19 = new javax.swing.JLabel();
        jCheckBoxVerticalFirst = new javax.swing.JCheckBox();
        jLabel17 = new javax.swing.JLabel();
        jTextFieldCountX = new javax.swing.JTextField();
        jTextFieldStartY = new javax.swing.JTextField();
        jTextFieldStartX = new javax.swing.JTextField();
        jLabel16 = new javax.swing.JLabel();
        jLabel15 = new javax.swing.JLabel();
        jPanel14 = new javax.swing.JPanel();
        jCheckBoxSelectionLock = new javax.swing.JCheckBox();
        jTextFieldPosY = new javax.swing.JTextField();
        jTextFieldPosX = new javax.swing.JTextField();
        jLabel34 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jTextFieldHeight = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jTextFieldWidth = new javax.swing.JTextField();
        jButton11 = new javax.swing.JButton();
        jCheckBoxPaintSelection = new javax.swing.JCheckBox();
        jButtonAddOneImage = new javax.swing.JButton();
        jButtonAddImageSeries = new javax.swing.JButton();
        jCheckBoxAnimationScaled = new javax.swing.JCheckBox();
        jScrollPane3 = new javax.swing.JScrollPane();
        singleImagePanel2 = new de.malban.graphics.SingleImagePanel();
        jScrollPane4 = new javax.swing.JScrollPane();
        imageComponent1 = new de.malban.graphics.ImageComponent();
        jLabel10 = new javax.swing.JLabel();
        jTextFieldDelay = new javax.swing.JTextField();
        jToggleButtonPlayAnim = new javax.swing.JToggleButton();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel9 = new javax.swing.JPanel();
        jButtonOpacityAll = new javax.swing.JButton();
        jButtonScaleAll = new javax.swing.JButton();
        jLabel24 = new javax.swing.JLabel();
        jTextFieldScaleWidth = new javax.swing.JTextField();
        jTextFieldScaleHeight = new javax.swing.JTextField();
        jLabel29 = new javax.swing.JLabel();
        jTextFieldOpacity = new javax.swing.JTextField();
        jLabel30 = new javax.swing.JLabel();
        jButtonRotateAll = new javax.swing.JButton();
        jTextFieldAngle = new javax.swing.JTextField();
        jLabel31 = new javax.swing.JLabel();
        jButtonResozeCanvas = new javax.swing.JButton();
        jButtonMirrorAll = new javax.swing.JButton();
        jCheckBoxVerticalMirror = new javax.swing.JCheckBox();
        jCheckBoxDontChangeSize = new javax.swing.JCheckBox();
        jButton5 = new javax.swing.JButton();
        jButtonSeamless = new javax.swing.JButton();
        jPanel10 = new javax.swing.JPanel();
        jLabel3 = new javax.swing.JLabel();
        jTextFieldSteps = new javax.swing.JTextField();
        jLabel26 = new javax.swing.JLabel();
        jTextFieldStart = new javax.swing.JTextField();
        jLabel27 = new javax.swing.JLabel();
        jTextFieldEnd = new javax.swing.JTextField();
        jRadioButtonRotation = new javax.swing.JRadioButton();
        jRadioButtonScaling = new javax.swing.JRadioButton();
        jRadioButtonOpacity = new javax.swing.JRadioButton();
        jButtonBuildAni = new javax.swing.JButton();
        jLabel42 = new javax.swing.JLabel();
        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jTextFieldColorR = new javax.swing.JTextField();
        jTextFieldColorG = new javax.swing.JTextField();
        jTextFieldColorB = new javax.swing.JTextField();
        jTextFieldColorA = new javax.swing.JTextField();
        jLabel35 = new javax.swing.JLabel();
        jLabel39 = new javax.swing.JLabel();
        jLabel40 = new javax.swing.JLabel();
        jLabel41 = new javax.swing.JLabel();
        jButtonChangeColor = new javax.swing.JButton();
        jButtonSaveImageGraphics = new javax.swing.JButton();
        jButtonSaveImageGraphics1 = new javax.swing.JButton();
        jButton4 = new javax.swing.JButton();
        jPanel24 = new javax.swing.JPanel();
        jSpinner4 = new javax.swing.JSpinner();
        jLabel59 = new javax.swing.JLabel();
        jLabel60 = new javax.swing.JLabel();
        jSpinner5 = new javax.swing.JSpinner();
        jLabel61 = new javax.swing.JLabel();
        jSpinner6 = new javax.swing.JSpinner();
        jPanel23 = new javax.swing.JPanel();
        jSpinner1 = new javax.swing.JSpinner();
        jLabel50 = new javax.swing.JLabel();
        jLabel57 = new javax.swing.JLabel();
        jSpinner2 = new javax.swing.JSpinner();
        jLabel58 = new javax.swing.JLabel();
        jSpinner3 = new javax.swing.JSpinner();
        jPanel19 = new javax.swing.JPanel();
        jButtonCropImage = new javax.swing.JButton();
        jLabel43 = new javax.swing.JLabel();
        jTextFieldPosXCrop = new javax.swing.JTextField();
        jLabel44 = new javax.swing.JLabel();
        jTextFieldPosYCrop = new javax.swing.JTextField();
        jTextFieldWidthCrop = new javax.swing.JTextField();
        jTextFieldHeightCrop = new javax.swing.JTextField();
        jLabel45 = new javax.swing.JLabel();
        jLabel46 = new javax.swing.JLabel();
        jButtonApplyCrop = new javax.swing.JButton();
        jLabel47 = new javax.swing.JLabel();
        jTextFieldPosXOpt = new javax.swing.JTextField();
        jLabel48 = new javax.swing.JLabel();
        jTextFieldPosYOpt = new javax.swing.JTextField();
        jCheckBoxKeepOffset = new javax.swing.JCheckBox();
        jCheckBoxinternalOffset = new javax.swing.JCheckBox();
        jPanel20 = new javax.swing.JPanel();
        jPanel21 = new javax.swing.JPanel();
        jLabel51 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jButtonFileSelect2 = new javax.swing.JButton();
        jLabel52 = new javax.swing.JLabel();
        jComboBoxKlasse1 = new javax.swing.JComboBox();
        jComboBox1 = new javax.swing.JComboBox();
        jLabel53 = new javax.swing.JLabel();
        jButtonApplyFilter = new javax.swing.JButton();
        jPanel22 = new javax.swing.JPanel();
        jButtonBuiltArtifactFilter = new javax.swing.JButton();
        jButton7 = new javax.swing.JButton();
        jLabel49 = new javax.swing.JLabel();
        jLabel54 = new javax.swing.JLabel();
        jLabel55 = new javax.swing.JLabel();
        jLabel56 = new javax.swing.JLabel();
        jButton8 = new javax.swing.JButton();
        jCheckBoxPreviewScaled = new javax.swing.JCheckBox();
        jPanel3 = new javax.swing.JPanel();
        jButtonOneForward = new javax.swing.JButton();
        jButtonOneBack = new javax.swing.JButton();
        jTextFieldCurrentNo = new javax.swing.JTextField();
        jLabel13 = new javax.swing.JLabel();
        jTextFieldCount = new javax.swing.JTextField();
        jLabel12 = new javax.swing.JLabel();
        jButtonDeleteOne = new javax.swing.JButton();
        jButtonAsSource = new javax.swing.JButton();
        jButtonAsSource1 = new javax.swing.JButton();
        jButtonClear = new javax.swing.JButton();
        jLabel33 = new javax.swing.JLabel();
        jLabelSelSize = new javax.swing.JLabel();
        jButtonReverse = new javax.swing.JButton();
        jButtonSaveAnimImage = new javax.swing.JButton();
        jCheckBoxRandom = new javax.swing.JCheckBox();
        jScrollPane1 = new javax.swing.JScrollPane();
        jPanelIMageCollection = new javax.swing.JPanel();
        jPanel12 = new javax.swing.JPanel();
        jPanel13 = new javax.swing.JPanel();
        jLabel2 = new javax.swing.JLabel();
        jTextFieldImageSource = new javax.swing.JTextField();
        jButtonFileSelect = new javax.swing.JButton();
        jButtonAddFileSeries = new javax.swing.JButton();
        jLabel28 = new javax.swing.JLabel();
        jTextFieldFileCount = new javax.swing.JTextField();
        jCheckBoxUseFileSizes = new javax.swing.JCheckBox();
        jButton1 = new javax.swing.JButton();
        jCheckBoxAnimationOffset = new javax.swing.JCheckBox();
        jCheckBoxPreviewOffset = new javax.swing.JCheckBox();
        jButton6 = new javax.swing.JButton();
        jPanel15 = new javax.swing.JPanel();
        jButtonAddAsAnimImage = new javax.swing.JButton();
        jButtonAddMultipleImages = new javax.swing.JButton();
        jLabel36 = new javax.swing.JLabel();
        jTextFieldName = new javax.swing.JTextField();
        jComboBoxName = new javax.swing.JComboBox();
        jButtonDelete = new javax.swing.JButton();
        jCheckBoxReplace = new javax.swing.JCheckBox();
        jButtonReset = new javax.swing.JButton();
        jPanel16 = new javax.swing.JPanel();
        jScrollPane5 = new javax.swing.JScrollPane();
        jPanelIMageCollection1 = new javax.swing.JPanel();
        jPanel17 = new javax.swing.JPanel();
        jPanel18 = new javax.swing.JPanel();
        jComboBoxKlasse = new javax.swing.JComboBox();
        jLabel37 = new javax.swing.JLabel();
        jTextFieldKlasse = new javax.swing.JTextField();
        jButtonNew = new javax.swing.JButton();
        jButtonSaveClassAsImage = new javax.swing.JButton();
        jLabel38 = new javax.swing.JLabel();
        jTextFieldFile = new javax.swing.JTextField();
        jButton3 = new javax.swing.JButton();
        jButtonFileSelect1 = new javax.swing.JButton();
        jButtonSave = new javax.swing.JButton();
        jButtonExport = new javax.swing.JButton();
        jButtonSaveClassSingleImages = new javax.swing.JButton();
        jCheckBoxJustImages = new javax.swing.JCheckBox();
        jToggleButtonPlayAnimMain = new javax.swing.JToggleButton();

        jPanel8.setName("jPanel8"); // NOI18N

        jPanel6.setName("jPanel6"); // NOI18N
        jPanel6.setPreferredSize(new java.awt.Dimension(100, 100));

        jScrollPane2.setName("jScrollPane2"); // NOI18N
        jScrollPane2.setPreferredSize(new java.awt.Dimension(1000, 1000));

        singleImagePanel1.setName("singleImagePanel1"); // NOI18N
        singleImagePanel1.setPreferredSize(new java.awt.Dimension(100, 100));
        singleImagePanel1.addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                singleImagePanel1MouseDragged(evt);
            }
            public void mouseMoved(java.awt.event.MouseEvent evt) {
                singleImagePanel1MouseMoved(evt);
            }
        });

        javax.swing.GroupLayout singleImagePanel1Layout = new javax.swing.GroupLayout(singleImagePanel1);
        singleImagePanel1.setLayout(singleImagePanel1Layout);
        singleImagePanel1Layout.setHorizontalGroup(
            singleImagePanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 235, Short.MAX_VALUE)
        );
        singleImagePanel1Layout.setVerticalGroup(
            singleImagePanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 587, Short.MAX_VALUE)
        );

        jScrollPane2.setViewportView(singleImagePanel1);

        jLabel14.setText("Scale * 1.0");
        jLabel14.setName("jLabel14"); // NOI18N

        jSliderSourceScale.setMajorTickSpacing(1);
        jSliderSourceScale.setMaximum(11);
        jSliderSourceScale.setMinimum(1);
        jSliderSourceScale.setMinorTickSpacing(1);
        jSliderSourceScale.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderSourceScale.setPaintTicks(true);
        jSliderSourceScale.setSnapToTicks(true);
        jSliderSourceScale.setValue(6);
        jSliderSourceScale.setName("jSliderSourceScale"); // NOI18N
        jSliderSourceScale.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderSourceScaleStateChanged(evt);
            }
        });

        jPanel5.setName("jPanel5"); // NOI18N

        jLabel22.setText("Size:");
        jLabel22.setName("jLabel22"); // NOI18N

        jLabel23.setText("100 / 200");
        jLabel23.setName("jLabel23"); // NOI18N

        jLabel21.setText("100 / 200");
        jLabel21.setName("jLabel21"); // NOI18N

        jLabel20.setText("Coords:");
        jLabel20.setName("jLabel20"); // NOI18N

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jLabel20)
                .addGap(4, 4, 4)
                .addComponent(jLabel21)
                .addGap(18, 18, 18)
                .addComponent(jLabel22)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel23)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                .addComponent(jLabel20)
                .addComponent(jLabel22)
                .addComponent(jLabel23)
                .addComponent(jLabel21))
        );

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addComponent(jLabel14, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(3, 3, 3)
                .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addComponent(jSliderSourceScale, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(16, 16, 16)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel14, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                    .addComponent(jSliderSourceScale, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
        );

        jPanel7.setName("jPanel7"); // NOI18N
        jPanel7.setPreferredSize(new java.awt.Dimension(600, 500));

        jPanel4.setBorder(javax.swing.BorderFactory.createTitledBorder("One Image/Image Sequence"));
        jPanel4.setName("jPanel4"); // NOI18N

        jLabel9.setText("Animation");
        jLabel9.setName("jLabel9"); // NOI18N

        jLabel4.setText("<html>Current selection</html>");
        jLabel4.setName("jLabel4"); // NOI18N

        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder("Source image(s)"));
        jPanel2.setName("jPanel2"); // NOI18N
        jPanel2.setLayout(null);

        jPanel11.setName("jPanel11"); // NOI18N
        jPanel11.setLayout(null);

        jTextFieldCountAll.setText("100");
        jTextFieldCountAll.setName("jTextFieldCountAll"); // NOI18N
        jPanel11.add(jTextFieldCountAll);
        jTextFieldCountAll.setBounds(50, 67, 30, 19);

        jLabel25.setText("Y #");
        jLabel25.setName("jLabel25"); // NOI18N
        jPanel11.add(jLabel25);
        jLabel25.setBounds(170, 45, 30, 15);

        jLabel18.setText("Y gap");
        jLabel18.setName("jLabel18"); // NOI18N
        jPanel11.add(jLabel18);
        jLabel18.setBounds(85, 45, 40, 15);

        jLabel32.setText("X #");
        jLabel32.setName("jLabel32"); // NOI18N
        jPanel11.add(jLabel32);
        jLabel32.setBounds(170, 20, 30, 15);

        jTextFieldGapX.setText("0");
        jTextFieldGapX.setName("jTextFieldGapX"); // NOI18N
        jTextFieldGapX.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldGapXFocusLost(evt);
            }
        });
        jPanel11.add(jTextFieldGapX);
        jTextFieldGapX.setBounds(120, 17, 30, 19);

        jCheckBoxPaintGrid.setText("paint grid");
        jCheckBoxPaintGrid.setName("jCheckBoxPaintGrid"); // NOI18N
        jCheckBoxPaintGrid.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxPaintGridActionPerformed(evt);
            }
        });
        jCheckBoxPaintGrid.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jCheckBoxPaintGridFocusLost(evt);
            }
        });
        jPanel11.add(jCheckBoxPaintGrid);
        jCheckBoxPaintGrid.setBounds(90, 69, 80, 19);

        jTextFieldCountY.setText("10");
        jTextFieldCountY.setName("jTextFieldCountY"); // NOI18N
        jTextFieldCountY.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldCountYFocusLost(evt);
            }
        });
        jPanel11.add(jTextFieldCountY);
        jTextFieldCountY.setBounds(200, 42, 30, 19);

        jTextFieldGapY.setText("0");
        jTextFieldGapY.setName("jTextFieldGapY"); // NOI18N
        jTextFieldGapY.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldGapYFocusLost(evt);
            }
        });
        jPanel11.add(jTextFieldGapY);
        jTextFieldGapY.setBounds(120, 42, 30, 19);

        jLabel11.setFont(jLabel11.getFont().deriveFont(jLabel11.getFont().getStyle() | java.awt.Font.BOLD));
        jLabel11.setText("Multi selection in image:");
        jLabel11.setName("jLabel11"); // NOI18N
        jPanel11.add(jLabel11);
        jLabel11.setBounds(0, 0, 170, 15);

        jLabel19.setText("all #");
        jLabel19.setName("jLabel19"); // NOI18N
        jPanel11.add(jLabel19);
        jLabel19.setBounds(3, 70, 40, 15);

        jCheckBoxVerticalFirst.setText("vertical first");
        jCheckBoxVerticalFirst.setName("jCheckBoxVerticalFirst"); // NOI18N
        jPanel11.add(jCheckBoxVerticalFirst);
        jCheckBoxVerticalFirst.setBounds(170, 69, 100, 19);

        jLabel17.setText("X gap");
        jLabel17.setName("jLabel17"); // NOI18N
        jPanel11.add(jLabel17);
        jLabel17.setBounds(85, 20, 40, 15);

        jTextFieldCountX.setText("10");
        jTextFieldCountX.setName("jTextFieldCountX"); // NOI18N
        jTextFieldCountX.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldCountXFocusLost(evt);
            }
        });
        jPanel11.add(jTextFieldCountX);
        jTextFieldCountX.setBounds(200, 17, 30, 19);

        jTextFieldStartY.setText("0");
        jTextFieldStartY.setName("jTextFieldStartY"); // NOI18N
        jTextFieldStartY.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldStartYFocusLost(evt);
            }
        });
        jPanel11.add(jTextFieldStartY);
        jTextFieldStartY.setBounds(50, 42, 30, 19);

        jTextFieldStartX.setText("0");
        jTextFieldStartX.setName("jTextFieldStartX"); // NOI18N
        jTextFieldStartX.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldStartXFocusLost(evt);
            }
        });
        jPanel11.add(jTextFieldStartX);
        jTextFieldStartX.setBounds(50, 17, 30, 19);

        jLabel16.setText("Y start");
        jLabel16.setName("jLabel16"); // NOI18N
        jPanel11.add(jLabel16);
        jLabel16.setBounds(3, 45, 50, 15);

        jLabel15.setText("X start");
        jLabel15.setName("jLabel15"); // NOI18N
        jPanel11.add(jLabel15);
        jLabel15.setBounds(3, 20, 50, 15);

        jPanel2.add(jPanel11);
        jPanel11.setBounds(240, 15, 280, 92);

        jPanel14.setName("jPanel14"); // NOI18N
        jPanel14.setLayout(null);

        jCheckBoxSelectionLock.setText("Lock");
        jCheckBoxSelectionLock.setName("jCheckBoxSelectionLock"); // NOI18N
        jCheckBoxSelectionLock.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxSelectionLockActionPerformed(evt);
            }
        });
        jPanel14.add(jCheckBoxSelectionLock);
        jCheckBoxSelectionLock.setBounds(160, 19, 60, 19);

        jTextFieldPosY.setText("0");
        jTextFieldPosY.setName("jTextFieldPosY"); // NOI18N
        jTextFieldPosY.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldPosYFocusLost(evt);
            }
        });
        jPanel14.add(jTextFieldPosY);
        jTextFieldPosY.setBounds(120, 42, 30, 19);

        jTextFieldPosX.setText("0");
        jTextFieldPosX.setName("jTextFieldPosX"); // NOI18N
        jTextFieldPosX.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldPosXFocusLost(evt);
            }
        });
        jPanel14.add(jTextFieldPosX);
        jTextFieldPosX.setBounds(120, 17, 30, 19);

        jLabel34.setFont(jLabel34.getFont().deriveFont(jLabel34.getFont().getStyle() | java.awt.Font.BOLD));
        jLabel34.setText("Single selection in image:");
        jLabel34.setName("jLabel34"); // NOI18N
        jPanel14.add(jLabel34);
        jLabel34.setBounds(0, 0, 170, 15);

        jLabel5.setText("PosX");
        jLabel5.setName("jLabel5"); // NOI18N
        jPanel14.add(jLabel5);
        jLabel5.setBounds(86, 20, 30, 15);

        jLabel6.setText("PosY");
        jLabel6.setName("jLabel6"); // NOI18N
        jPanel14.add(jLabel6);
        jLabel6.setBounds(86, 45, 30, 15);

        jTextFieldHeight.setText("32");
        jTextFieldHeight.setName("jTextFieldHeight"); // NOI18N
        jTextFieldHeight.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldHeightFocusLost(evt);
            }
        });
        jPanel14.add(jTextFieldHeight);
        jTextFieldHeight.setBounds(50, 42, 30, 19);

        jLabel8.setText("Height");
        jLabel8.setName("jLabel8"); // NOI18N
        jPanel14.add(jLabel8);
        jLabel8.setBounds(3, 45, 50, 15);

        jLabel7.setText("Width");
        jLabel7.setName("jLabel7"); // NOI18N
        jPanel14.add(jLabel7);
        jLabel7.setBounds(3, 20, 50, 15);

        jTextFieldWidth.setText("32");
        jTextFieldWidth.setName("jTextFieldWidth"); // NOI18N
        jTextFieldWidth.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldWidthFocusLost(evt);
            }
        });
        jPanel14.add(jTextFieldWidth);
        jTextFieldWidth.setBounds(50, 17, 30, 19);

        jButton11.setText("Apply");
        jButton11.setToolTipText("Applies newly entered grid / selection data to source image."); // NOI18N
        jButton11.setName("jButton11"); // NOI18N
        jButton11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton11ActionPerformed(evt);
            }
        });
        jPanel14.add(jButton11);
        jButton11.setBounds(160, 42, 60, 23);

        jCheckBoxPaintSelection.setText("paint selection");
        jCheckBoxPaintSelection.setName("jCheckBoxPaintSelection"); // NOI18N
        jCheckBoxPaintSelection.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxPaintSelectionActionPerformed(evt);
            }
        });
        jCheckBoxPaintSelection.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jCheckBoxPaintSelectionFocusLost(evt);
            }
        });
        jPanel14.add(jCheckBoxPaintSelection);
        jCheckBoxPaintSelection.setBounds(122, 66, 100, 19);

        jPanel2.add(jPanel14);
        jPanel14.setBounds(10, 15, 226, 86);

        jButtonAddOneImage.setText("Add single selection");
        jButtonAddOneImage.setToolTipText("Adds the current selection to images.");
        jButtonAddOneImage.setName("jButtonAddOneImage"); // NOI18N
        jButtonAddOneImage.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAddOneImageActionPerformed(evt);
            }
        });
        jPanel2.add(jButtonAddOneImage);
        jButtonAddOneImage.setBounds(4, 104, 142, 23);

        jButtonAddImageSeries.setText("Add series");
        jButtonAddImageSeries.setToolTipText("<html>\nAdds images from the \"grid\"-info. Exactly \"all #\" images will be taken.<br>\n\nImages from grid are taken from top to bottom and than from left to right,.<br>\nif vertical first is selected, form left to right anf top to bottom otherwise.<br>\n\nThese images are added to the anim of the current \"single\" image.\n</html>"); // NOI18N
        jButtonAddImageSeries.setName("jButtonAddImageSeries"); // NOI18N
        jButtonAddImageSeries.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAddImageSeriesActionPerformed(evt);
            }
        });
        jPanel2.add(jButtonAddImageSeries);
        jButtonAddImageSeries.setBounds(150, 104, 90, 23);

        jCheckBoxAnimationScaled.setSelected(true);
        jCheckBoxAnimationScaled.setText("Scaled");
        jCheckBoxAnimationScaled.setName("jCheckBoxAnimationScaled"); // NOI18N
        jCheckBoxAnimationScaled.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxAnimationScaledActionPerformed(evt);
            }
        });

        jScrollPane3.setName("jScrollPane3"); // NOI18N
        jScrollPane3.setPreferredSize(new java.awt.Dimension(110, 110));

        singleImagePanel2.setName("singleImagePanel2"); // NOI18N
        singleImagePanel2.setPreferredSize(new java.awt.Dimension(100, 100));

        javax.swing.GroupLayout singleImagePanel2Layout = new javax.swing.GroupLayout(singleImagePanel2);
        singleImagePanel2.setLayout(singleImagePanel2Layout);
        singleImagePanel2Layout.setHorizontalGroup(
            singleImagePanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 108, Short.MAX_VALUE)
        );
        singleImagePanel2Layout.setVerticalGroup(
            singleImagePanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 108, Short.MAX_VALUE)
        );

        jScrollPane3.setViewportView(singleImagePanel2);

        jScrollPane4.setName("jScrollPane4"); // NOI18N
        jScrollPane4.setPreferredSize(new java.awt.Dimension(110, 110));

        imageComponent1.setName("imageComponent1"); // NOI18N
        imageComponent1.setPreferredSize(new java.awt.Dimension(100, 100));

        javax.swing.GroupLayout imageComponent1Layout = new javax.swing.GroupLayout(imageComponent1);
        imageComponent1.setLayout(imageComponent1Layout);
        imageComponent1Layout.setHorizontalGroup(
            imageComponent1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 108, Short.MAX_VALUE)
        );
        imageComponent1Layout.setVerticalGroup(
            imageComponent1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 108, Short.MAX_VALUE)
        );

        jScrollPane4.setViewportView(imageComponent1);

        jLabel10.setText("Delay");
        jLabel10.setName("jLabel10"); // NOI18N

        jTextFieldDelay.setText("80");
        jTextFieldDelay.setName("jTextFieldDelay"); // NOI18N
        jTextFieldDelay.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldDelayActionPerformed(evt);
            }
        });
        jTextFieldDelay.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldDelayFocusLost(evt);
            }
        });

        jToggleButtonPlayAnim.setText("Play");
        jToggleButtonPlayAnim.setToolTipText("Animates through all images, animation is looped. Given delay is taken.");
        jToggleButtonPlayAnim.setName("jToggleButtonPlayAnim"); // NOI18N
        jToggleButtonPlayAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButtonPlayAnimActionPerformed(evt);
            }
        });

        jTabbedPane1.setName("jTabbedPane1"); // NOI18N

        jPanel9.setName("jPanel9"); // NOI18N
        jPanel9.setLayout(null);

        jButtonOpacityAll.setText("Opacity all");
        jButtonOpacityAll.setToolTipText("Sets opacity of all images to selected opacity.");
        jButtonOpacityAll.setName("jButtonOpacityAll"); // NOI18N
        jButtonOpacityAll.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOpacityAllActionPerformed(evt);
            }
        });
        jPanel9.add(jButtonOpacityAll);
        jButtonOpacityAll.setBounds(104, 55, 90, 23);

        jButtonScaleAll.setText("Scale all");
        jButtonScaleAll.setToolTipText("Scales all images to selected size.");
        jButtonScaleAll.setName("jButtonScaleAll"); // NOI18N
        jButtonScaleAll.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonScaleAllActionPerformed(evt);
            }
        });
        jPanel9.add(jButtonScaleAll);
        jButtonScaleAll.setBounds(10, 55, 80, 23);

        jLabel24.setText("Width");
        jLabel24.setName("jLabel24"); // NOI18N
        jPanel9.add(jLabel24);
        jLabel24.setBounds(10, 8, 40, 15);

        jTextFieldScaleWidth.setText("32");
        jTextFieldScaleWidth.setName("jTextFieldScaleWidth"); // NOI18N
        jPanel9.add(jTextFieldScaleWidth);
        jTextFieldScaleWidth.setBounds(60, 5, 30, 19);

        jTextFieldScaleHeight.setText("32");
        jTextFieldScaleHeight.setName("jTextFieldScaleHeight"); // NOI18N
        jPanel9.add(jTextFieldScaleHeight);
        jTextFieldScaleHeight.setBounds(60, 30, 30, 19);

        jLabel29.setText("Height");
        jLabel29.setName("jLabel29"); // NOI18N
        jPanel9.add(jLabel29);
        jLabel29.setBounds(10, 33, 40, 15);

        jTextFieldOpacity.setText("255");
        jTextFieldOpacity.setName("jTextFieldOpacity"); // NOI18N
        jPanel9.add(jTextFieldOpacity);
        jTextFieldOpacity.setBounds(154, 5, 30, 19);

        jLabel30.setText("Opacity");
        jLabel30.setName("jLabel30"); // NOI18N
        jPanel9.add(jLabel30);
        jLabel30.setBounds(103, 8, 50, 15);

        jButtonRotateAll.setText("Rotate all");
        jButtonRotateAll.setToolTipText("Rotates all images by the given angle.");
        jButtonRotateAll.setName("jButtonRotateAll"); // NOI18N
        jButtonRotateAll.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRotateAllActionPerformed(evt);
            }
        });
        jPanel9.add(jButtonRotateAll);
        jButtonRotateAll.setBounds(200, 55, 80, 23);

        jTextFieldAngle.setText("90");
        jTextFieldAngle.setName("jTextFieldAngle"); // NOI18N
        jPanel9.add(jTextFieldAngle);
        jTextFieldAngle.setBounds(230, 5, 30, 19);

        jLabel31.setText("Angle");
        jLabel31.setName("jLabel31"); // NOI18N
        jPanel9.add(jLabel31);
        jLabel31.setBounds(190, 8, 40, 15);

        jButtonResozeCanvas.setText("Canvas size");
        jButtonResozeCanvas.setToolTipText("Image is centered in new canvas size.");
        jButtonResozeCanvas.setName("jButtonResozeCanvas"); // NOI18N
        jButtonResozeCanvas.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonResozeCanvasActionPerformed(evt);
            }
        });
        jPanel9.add(jButtonResozeCanvas);
        jButtonResozeCanvas.setBounds(10, 80, 100, 23);

        jButtonMirrorAll.setText("Mirror all");
        jButtonMirrorAll.setToolTipText("Mirror all images");
        jButtonMirrorAll.setName("jButtonMirrorAll"); // NOI18N
        jButtonMirrorAll.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonMirrorAllActionPerformed(evt);
            }
        });
        jPanel9.add(jButtonMirrorAll);
        jButtonMirrorAll.setBounds(285, 30, 90, 23);

        jCheckBoxVerticalMirror.setText("Vertical");
        jCheckBoxVerticalMirror.setToolTipText("If not selected -> Horizontally");
        jCheckBoxVerticalMirror.setName("jCheckBoxVerticalMirror"); // NOI18N
        jPanel9.add(jCheckBoxVerticalMirror);
        jCheckBoxVerticalMirror.setBounds(285, 5, 62, 19);

        jCheckBoxDontChangeSize.setText("Don change size!");
        jCheckBoxDontChangeSize.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jCheckBoxDontChangeSize.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jCheckBoxDontChangeSize.setName("jCheckBoxDontChangeSize"); // NOI18N
        jCheckBoxDontChangeSize.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jPanel9.add(jCheckBoxDontChangeSize);
        jCheckBoxDontChangeSize.setBounds(180, 80, 112, 40);

        jButton5.setText("i");
        jButton5.setName("jButton5"); // NOI18N
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });
        jPanel9.add(jButton5);
        jButton5.setBounds(200, 30, 40, 23);

        jButtonSeamless.setText("Create seamless");
        jButtonSeamless.setName("jButtonSeamless"); // NOI18N
        jButtonSeamless.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSeamlessActionPerformed(evt);
            }
        });
        jPanel9.add(jButtonSeamless);
        jButtonSeamless.setBounds(380, 5, 130, 23);

        jTabbedPane1.addTab("Group transformation", jPanel9);

        jPanel10.setName("jPanel10"); // NOI18N
        jPanel10.setLayout(null);

        jLabel3.setText("Steps");
        jLabel3.setName("jLabel3"); // NOI18N
        jPanel10.add(jLabel3);
        jLabel3.setBounds(10, 8, 40, 15);

        jTextFieldSteps.setText("0");
        jTextFieldSteps.setName("jTextFieldSteps"); // NOI18N
        jPanel10.add(jTextFieldSteps);
        jTextFieldSteps.setBounds(47, 5, 30, 19);

        jLabel26.setText("Rotation sizes the new tiles to a squared a²+b²=c²!");
        jLabel26.setName("jLabel26"); // NOI18N
        jPanel10.add(jLabel26);
        jLabel26.setBounds(86, 58, 394, 15);

        jTextFieldStart.setText("0");
        jTextFieldStart.setToolTipText("Either opacity start (0-255) or percentage of scaling start.");
        jTextFieldStart.setName("jTextFieldStart"); // NOI18N
        jPanel10.add(jTextFieldStart);
        jTextFieldStart.setBounds(47, 30, 30, 19);

        jLabel27.setText("End");
        jLabel27.setName("jLabel27"); // NOI18N
        jPanel10.add(jLabel27);
        jLabel27.setBounds(83, 33, 30, 15);

        jTextFieldEnd.setText("0");
        jTextFieldEnd.setToolTipText("Either opacity end (0-255) or percentage of scaling end.");
        jTextFieldEnd.setName("jTextFieldEnd"); // NOI18N
        jPanel10.add(jTextFieldEnd);
        jTextFieldEnd.setBounds(113, 30, 30, 19);

        buttonGroup1.add(jRadioButtonRotation);
        jRadioButtonRotation.setText("Rotation");
        jRadioButtonRotation.setToolTipText("Only steps are used, angle of 360 divieded by steps...");
        jRadioButtonRotation.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        jRadioButtonRotation.setName("jRadioButtonRotation"); // NOI18N
        jPanel10.add(jRadioButtonRotation);
        jRadioButtonRotation.setBounds(10, 57, 80, 19);

        buttonGroup1.add(jRadioButtonScaling);
        jRadioButtonScaling.setText("Scaling ");
        jRadioButtonScaling.setToolTipText("Scaling done in %");
        jRadioButtonScaling.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        jRadioButtonScaling.setName("jRadioButtonScaling"); // NOI18N
        jPanel10.add(jRadioButtonScaling);
        jRadioButtonScaling.setBounds(14, 98, 70, 19);

        buttonGroup1.add(jRadioButtonOpacity);
        jRadioButtonOpacity.setText("Opacity ");
        jRadioButtonOpacity.setToolTipText("Start and end should be between 0 and 255");
        jRadioButtonOpacity.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        jRadioButtonOpacity.setName("jRadioButtonOpacity"); // NOI18N
        jPanel10.add(jRadioButtonOpacity);
        jRadioButtonOpacity.setBounds(12, 78, 80, 19);

        jButtonBuildAni.setText("Apply");
        jButtonBuildAni.setToolTipText("<html>Applies the selected transformation to the selection and adss \"steps\" images to images<html>");
        jButtonBuildAni.setName("jButtonBuildAni"); // NOI18N
        jButtonBuildAni.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonBuildAniActionPerformed(evt);
            }
        });
        jPanel10.add(jButtonBuildAni);
        jButtonBuildAni.setBounds(120, 90, 80, 23);

        jLabel42.setText("Start");
        jLabel42.setName("jLabel42"); // NOI18N
        jPanel10.add(jLabel42);
        jLabel42.setBounds(10, 33, 40, 15);

        jTabbedPane1.addTab("Build animation", jPanel10);

        jPanel1.setName("jPanel1"); // NOI18N

        jLabel1.setText("Color at Cursor:");
        jLabel1.setName("jLabel1"); // NOI18N

        jTextFieldColorR.setText("0");
        jTextFieldColorR.setName("jTextFieldColorR"); // NOI18N

        jTextFieldColorG.setText("0");
        jTextFieldColorG.setName("jTextFieldColorG"); // NOI18N

        jTextFieldColorB.setText("0");
        jTextFieldColorB.setName("jTextFieldColorB"); // NOI18N

        jTextFieldColorA.setText("0");
        jTextFieldColorA.setName("jTextFieldColorA"); // NOI18N

        jLabel35.setText("R");
        jLabel35.setName("jLabel35"); // NOI18N

        jLabel39.setText("G");
        jLabel39.setName("jLabel39"); // NOI18N

        jLabel40.setText("B");
        jLabel40.setName("jLabel40"); // NOI18N

        jLabel41.setText("A");
        jLabel41.setName("jLabel41"); // NOI18N

        jButtonChangeColor.setText("All selected Color to Background");
        jButtonChangeColor.setName("jButtonChangeColor"); // NOI18N
        jButtonChangeColor.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonChangeColorActionPerformed(evt);
            }
        });

        jButtonSaveImageGraphics.setText("Save Image");
        jButtonSaveImageGraphics.setName("jButtonSaveImageGraphics"); // NOI18N
        jButtonSaveImageGraphics.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveImageGraphicsActionPerformed(evt);
            }
        });

        jButtonSaveImageGraphics1.setText("Save As new Image");
        jButtonSaveImageGraphics1.setName("jButtonSaveImageGraphics1"); // NOI18N
        jButtonSaveImageGraphics1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveImageGraphics1ActionPerformed(evt);
            }
        });

        jButton4.setText("Color Reducer");
        jButton4.setEnabled(false);
        jButton4.setName("jButton4"); // NOI18N
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });

        jPanel24.setBorder(javax.swing.BorderFactory.createTitledBorder("RGB adjust"));
        jPanel24.setName("jPanel24"); // NOI18N

        jSpinner4.setModel(new javax.swing.SpinnerNumberModel(Float.valueOf(0.0f), Float.valueOf(-1.0f), null, Float.valueOf(0.01f)));
        jSpinner4.setName("jSpinner4"); // NOI18N
        jSpinner4.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSpinner4StateChanged(evt);
            }
        });

        jLabel59.setText("R");
        jLabel59.setName("jLabel59"); // NOI18N

        jLabel60.setText("G");
        jLabel60.setName("jLabel60"); // NOI18N

        jSpinner5.setModel(new javax.swing.SpinnerNumberModel(Float.valueOf(0.0f), Float.valueOf(-1.0f), null, Float.valueOf(0.01f)));
        jSpinner5.setName("jSpinner5"); // NOI18N
        jSpinner5.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSpinner5StateChanged(evt);
            }
        });

        jLabel61.setText("B");
        jLabel61.setName("jLabel61"); // NOI18N

        jSpinner6.setModel(new javax.swing.SpinnerNumberModel(Float.valueOf(0.0f), Float.valueOf(-1.0f), null, Float.valueOf(0.01f)));
        jSpinner6.setName("jSpinner6"); // NOI18N
        jSpinner6.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSpinner6StateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel24Layout = new javax.swing.GroupLayout(jPanel24);
        jPanel24.setLayout(jPanel24Layout);
        jPanel24Layout.setHorizontalGroup(
            jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel24Layout.createSequentialGroup()
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jLabel61, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel60, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel59, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(4, 4, 4)
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jSpinner4, javax.swing.GroupLayout.DEFAULT_SIZE, 50, Short.MAX_VALUE)
                    .addComponent(jSpinner5)
                    .addComponent(jSpinner6)))
        );
        jPanel24Layout.setVerticalGroup(
            jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel24Layout.createSequentialGroup()
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jSpinner4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel59))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jSpinner5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel60))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel24Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jSpinner6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel61))
                .addGap(0, 10, Short.MAX_VALUE))
        );

        jPanel23.setBorder(javax.swing.BorderFactory.createTitledBorder("HSB adjust"));
        jPanel23.setName("jPanel23"); // NOI18N

        jSpinner1.setModel(new javax.swing.SpinnerNumberModel(Float.valueOf(0.0f), Float.valueOf(-1.0f), null, Float.valueOf(0.01f)));
        jSpinner1.setName("jSpinner1"); // NOI18N
        jSpinner1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSpinner1StateChanged(evt);
            }
        });

        jLabel50.setText("H");
        jLabel50.setName("jLabel50"); // NOI18N

        jLabel57.setText("S");
        jLabel57.setName("jLabel57"); // NOI18N

        jSpinner2.setModel(new javax.swing.SpinnerNumberModel(Float.valueOf(0.0f), Float.valueOf(-1.0f), null, Float.valueOf(0.01f)));
        jSpinner2.setName("jSpinner2"); // NOI18N
        jSpinner2.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSpinner2StateChanged(evt);
            }
        });

        jLabel58.setText("B");
        jLabel58.setName("jLabel58"); // NOI18N

        jSpinner3.setModel(new javax.swing.SpinnerNumberModel(Float.valueOf(0.0f), Float.valueOf(-1.0f), null, Float.valueOf(0.01f)));
        jSpinner3.setName("jSpinner3"); // NOI18N
        jSpinner3.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSpinner3StateChanged(evt);
            }
        });

        javax.swing.GroupLayout jPanel23Layout = new javax.swing.GroupLayout(jPanel23);
        jPanel23.setLayout(jPanel23Layout);
        jPanel23Layout.setHorizontalGroup(
            jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel23Layout.createSequentialGroup()
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jLabel58, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel57, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel50, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(4, 4, 4)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jSpinner1, javax.swing.GroupLayout.DEFAULT_SIZE, 50, Short.MAX_VALUE)
                    .addComponent(jSpinner2)
                    .addComponent(jSpinner3)))
        );
        jPanel23Layout.setVerticalGroup(
            jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel23Layout.createSequentialGroup()
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jSpinner1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel50))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jSpinner2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel57))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel23Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jSpinner3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel58))
                .addGap(0, 0, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 84, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGap(23, 23, 23)
                                .addComponent(jLabel35)
                                .addGap(29, 29, 29)
                                .addComponent(jLabel39)
                                .addGap(27, 27, 27)
                                .addComponent(jLabel40)
                                .addGap(29, 29, 29)
                                .addComponent(jLabel41))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldColorR, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldColorG, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldColorB, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldColorA, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jButtonChangeColor)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 15, Short.MAX_VALUE)
                        .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 122, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jButtonSaveImageGraphics)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButtonSaveImageGraphics1)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel24, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel23, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(9, 9, 9)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel35)
                            .addComponent(jLabel39)
                            .addComponent(jLabel40)
                            .addComponent(jLabel41))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel1)
                            .addComponent(jTextFieldColorR, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldColorG, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldColorB, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldColorA, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButtonChangeColor)
                            .addComponent(jButton4))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButtonSaveImageGraphics)
                            .addComponent(jButtonSaveImageGraphics1)))
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                        .addComponent(jPanel24, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jPanel23, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addGap(0, 21, Short.MAX_VALUE))
        );

        jPanel23.getAccessibleContext().setAccessibleName("RGB adjust");

        jTabbedPane1.addTab("Color Transformation", jPanel1);

        jPanel19.setName("jPanel19"); // NOI18N

        jButtonCropImage.setText("Crop image independend");
        jButtonCropImage.setToolTipText("<html>\nCroping is done so that each image of an animation is optimally fitted into its own set of crop settings.\n<BR>\nMeening all images in an animation (might) have the different crop settings.\n</html>\n");
        jButtonCropImage.setName("jButtonCropImage"); // NOI18N
        jButtonCropImage.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCropImageActionPerformed(evt);
            }
        });

        jLabel43.setText("PosX");
        jLabel43.setName("jLabel43"); // NOI18N

        jTextFieldPosXCrop.setEditable(false);
        jTextFieldPosXCrop.setText("0");
        jTextFieldPosXCrop.setName("jTextFieldPosXCrop"); // NOI18N

        jLabel44.setText("PosY");
        jLabel44.setName("jLabel44"); // NOI18N

        jTextFieldPosYCrop.setEditable(false);
        jTextFieldPosYCrop.setText("0");
        jTextFieldPosYCrop.setName("jTextFieldPosYCrop"); // NOI18N

        jTextFieldWidthCrop.setEditable(false);
        jTextFieldWidthCrop.setText("32");
        jTextFieldWidthCrop.setName("jTextFieldWidthCrop"); // NOI18N

        jTextFieldHeightCrop.setEditable(false);
        jTextFieldHeightCrop.setText("32");
        jTextFieldHeightCrop.setName("jTextFieldHeightCrop"); // NOI18N

        jLabel45.setText("Height");
        jLabel45.setName("jLabel45"); // NOI18N

        jLabel46.setText("Width");
        jLabel46.setName("jLabel46"); // NOI18N

        jButtonApplyCrop.setText("Apply Crop");
        jButtonApplyCrop.setToolTipText("<html> \nApply Crop checks:<BR>\n- if all images have the same crop -> then a \"full\" Crop is done, <BR>\n  meaning the x/y w/h of the image in its source image building is changed<BR>\n- if images have different crop stats -> the the upper, leftmost x,y is taken<BR>\n and to all other images a offset is added that will be used whem image is painted<br>\n the image itself is still cropped to its minimum\n</html> ");
        jButtonApplyCrop.setName("jButtonApplyCrop"); // NOI18N
        jButtonApplyCrop.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonApplyCropActionPerformed(evt);
            }
        });

        jLabel47.setText("optimized Offset X");
        jLabel47.setName("jLabel47"); // NOI18N

        jTextFieldPosXOpt.setEditable(false);
        jTextFieldPosXOpt.setText("0");
        jTextFieldPosXOpt.setName("jTextFieldPosXOpt"); // NOI18N

        jLabel48.setText("optimized Offset Y");
        jLabel48.setName("jLabel48"); // NOI18N

        jTextFieldPosYOpt.setEditable(false);
        jTextFieldPosYOpt.setText("0");
        jTextFieldPosYOpt.setName("jTextFieldPosYOpt"); // NOI18N

        jCheckBoxKeepOffset.setText("Keep Offset");
        jCheckBoxKeepOffset.setToolTipText("<html>  \nIf selected the offset of the image after apply crop are kept even in a single tile.<BR>\nThis is usefull when using fixed sized  tiles, which are only partially pixeled.\n</html>  \n");
        jCheckBoxKeepOffset.setName("jCheckBoxKeepOffset"); // NOI18N

        jCheckBoxinternalOffset.setSelected(true);
        jCheckBoxinternalOffset.setText("internal Offset");
        jCheckBoxinternalOffset.setToolTipText("<html>   If selected the offset of the image after apply crop are kept for the best animation offset.\n<br> each resulting image has the same size.\n<bR>\nif NO checkbox is selected each image in the animation has its own crop settings! </html>   ");
        jCheckBoxinternalOffset.setName("jCheckBoxinternalOffset"); // NOI18N

        javax.swing.GroupLayout jPanel19Layout = new javax.swing.GroupLayout(jPanel19);
        jPanel19.setLayout(jPanel19Layout);
        jPanel19Layout.setHorizontalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel19Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addComponent(jButtonCropImage, javax.swing.GroupLayout.PREFERRED_SIZE, 188, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addComponent(jLabel43)
                                .addGap(5, 5, 5)
                                .addComponent(jTextFieldPosXCrop, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addComponent(jLabel44)
                                .addGap(4, 4, 4)
                                .addComponent(jTextFieldPosYCrop, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addComponent(jLabel46)
                                .addGap(10, 10, 10)
                                .addComponent(jTextFieldWidthCrop, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addComponent(jLabel45)
                                .addGap(7, 7, 7)
                                .addComponent(jTextFieldHeightCrop, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addComponent(jButtonApplyCrop)
                                .addGap(24, 24, 24)
                                .addComponent(jCheckBoxKeepOffset))
                            .addComponent(jCheckBoxinternalOffset))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addComponent(jLabel47)
                                .addGap(5, 5, 5)
                                .addComponent(jTextFieldPosXOpt, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addComponent(jLabel48)
                                .addGap(4, 4, 4)
                                .addComponent(jTextFieldPosYOpt, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                .addContainerGap(162, Short.MAX_VALUE))
        );
        jPanel19Layout.setVerticalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel19Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonCropImage)
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldPosXCrop, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel19Layout.createSequentialGroup()
                                        .addGap(3, 3, 3)
                                        .addComponent(jLabel43)))
                                .addGap(5, 5, 5)
                                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldPosYCrop, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel19Layout.createSequentialGroup()
                                        .addGap(3, 3, 3)
                                        .addComponent(jLabel44))))
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldWidthCrop, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel19Layout.createSequentialGroup()
                                        .addGap(3, 3, 3)
                                        .addComponent(jLabel46)))
                                .addGap(5, 5, 5)
                                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldHeightCrop, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel19Layout.createSequentialGroup()
                                        .addGap(3, 3, 3)
                                        .addComponent(jLabel45)))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldPosXOpt, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel19Layout.createSequentialGroup()
                                        .addGap(3, 3, 3)
                                        .addComponent(jLabel47)))
                                .addGap(5, 5, 5)
                                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldPosYOpt, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel19Layout.createSequentialGroup()
                                        .addGap(1, 1, 1)
                                        .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                            .addComponent(jLabel48)
                                            .addComponent(jCheckBoxinternalOffset)))))
                            .addGroup(jPanel19Layout.createSequentialGroup()
                                .addGap(1, 1, 1)
                                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jCheckBoxKeepOffset)
                                    .addComponent(jButtonApplyCrop))))))
                .addContainerGap(22, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Crop", jPanel19);

        jPanel20.setName("jPanel20"); // NOI18N

        jPanel21.setBorder(javax.swing.BorderFactory.createTitledBorder("Source"));
        jPanel21.setName("jPanel21"); // NOI18N

        jLabel51.setText("File");
        jLabel51.setName("jLabel51"); // NOI18N

        jTextField1.setEnabled(false);
        jTextField1.setFocusable(false);
        jTextField1.setName("jTextField1"); // NOI18N

        jButtonFileSelect2.setText("...");
        jButtonFileSelect2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect2.setName("jButtonFileSelect2"); // NOI18N
        jButtonFileSelect2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect2ActionPerformed(evt);
            }
        });

        jLabel52.setText("Class");
        jLabel52.setName("jLabel52"); // NOI18N

        jComboBoxKlasse1.setName("jComboBoxKlasse1"); // NOI18N
        jComboBoxKlasse1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxKlasse1ActionPerformed(evt);
            }
        });

        jComboBox1.setName("jComboBox1"); // NOI18N

        jLabel53.setText("ImageSequence");
        jLabel53.setName("jLabel53"); // NOI18N

        jButtonApplyFilter.setText("Apply");
        jButtonApplyFilter.setName("jButtonApplyFilter"); // NOI18N
        jButtonApplyFilter.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonApplyFilterActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel21Layout = new javax.swing.GroupLayout(jPanel21);
        jPanel21.setLayout(jPanel21Layout);
        jPanel21Layout.setHorizontalGroup(
            jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel21Layout.createSequentialGroup()
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel51)
                    .addComponent(jLabel52)
                    .addComponent(jLabel53))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jComboBox1, 0, 112, Short.MAX_VALUE)
                    .addComponent(jComboBoxKlasse1, javax.swing.GroupLayout.Alignment.TRAILING, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel21Layout.createSequentialGroup()
                        .addComponent(jButtonApplyFilter)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(jPanel21Layout.createSequentialGroup()
                        .addComponent(jTextField1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonFileSelect2)))
                .addContainerGap())
        );
        jPanel21Layout.setVerticalGroup(
            jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel21Layout.createSequentialGroup()
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel51)
                    .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonFileSelect2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel52)
                    .addComponent(jComboBoxKlasse1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel53))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonApplyFilter)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        jPanel22.setBorder(javax.swing.BorderFactory.createTitledBorder("Meta-Filter"));
        jPanel22.setName("jPanel22"); // NOI18N

        jButtonBuiltArtifactFilter.setText("Built Artifact transitions filter");
        jButtonBuiltArtifactFilter.setName("jButtonBuiltArtifactFilter"); // NOI18N
        jButtonBuiltArtifactFilter.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonBuiltArtifactFilterActionPerformed(evt);
            }
        });

        jButton7.setText("Build Top/Down transitions filter");
        jButton7.setEnabled(false);
        jButton7.setName("jButton7"); // NOI18N
        jButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton7ActionPerformed(evt);
            }
        });

        jLabel49.setText("Metafilter must consist of 3 grafix:");
        jLabel49.setName("jLabel49"); // NOI18N

        jLabel54.setIcon(new javax.swing.ImageIcon(getClass().getResource("/csa/images/01.png"))); // NOI18N
        jLabel54.setName("jLabel54"); // NOI18N

        jLabel55.setIcon(new javax.swing.ImageIcon(getClass().getResource("/csa/images/015.png"))); // NOI18N
        jLabel55.setName("jLabel55"); // NOI18N

        jLabel56.setIcon(new javax.swing.ImageIcon(getClass().getResource("/csa/images/017.png"))); // NOI18N
        jLabel56.setName("jLabel56"); // NOI18N

        javax.swing.GroupLayout jPanel22Layout = new javax.swing.GroupLayout(jPanel22);
        jPanel22.setLayout(jPanel22Layout);
        jPanel22Layout.setHorizontalGroup(
            jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel22Layout.createSequentialGroup()
                .addGroup(jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel49)
                    .addGroup(jPanel22Layout.createSequentialGroup()
                        .addGap(24, 24, 24)
                        .addComponent(jLabel54)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel55)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel56)))
                .addGap(0, 71, Short.MAX_VALUE))
            .addComponent(jButtonBuiltArtifactFilter, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jButton7, javax.swing.GroupLayout.DEFAULT_SIZE, 211, Short.MAX_VALUE)
        );
        jPanel22Layout.setVerticalGroup(
            jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel22Layout.createSequentialGroup()
                .addComponent(jButtonBuiltArtifactFilter)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton7)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel49)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel22Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel54)
                    .addComponent(jLabel55)
                    .addComponent(jLabel56))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jButton8.setText("i");
        jButton8.setName("jButton8"); // NOI18N
        jButton8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton8ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel20Layout = new javax.swing.GroupLayout(jPanel20);
        jPanel20.setLayout(jPanel20Layout);
        jPanel20Layout.setHorizontalGroup(
            jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel20Layout.createSequentialGroup()
                .addComponent(jPanel21, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton8)
                .addGap(27, 27, 27)
                .addComponent(jPanel22, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel20Layout.setVerticalGroup(
            jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel21, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel22, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel20Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButton8)
                .addContainerGap())
        );

        jTabbedPane1.addTab("Filtering", jPanel20);

        jCheckBoxPreviewScaled.setSelected(true);
        jCheckBoxPreviewScaled.setText("Scaled");
        jCheckBoxPreviewScaled.setName("jCheckBoxPreviewScaled"); // NOI18N
        jCheckBoxPreviewScaled.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxPreviewScaledActionPerformed(evt);
            }
        });

        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder("Images"));
        jPanel3.setName("jPanel3"); // NOI18N
        jPanel3.setLayout(null);

        jButtonOneForward.setText(">");
        jButtonOneForward.setToolTipText("Moves selected image one to the right.");
        jButtonOneForward.setName("jButtonOneForward"); // NOI18N
        jButtonOneForward.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOneForwardActionPerformed(evt);
            }
        });
        jPanel3.add(jButtonOneForward);
        jButtonOneForward.setBounds(174, 38, 40, 23);

        jButtonOneBack.setText("<");
        jButtonOneBack.setToolTipText("Moves selected image one to the left.");
        jButtonOneBack.setName("jButtonOneBack"); // NOI18N
        jButtonOneBack.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOneBackActionPerformed(evt);
            }
        });
        jPanel3.add(jButtonOneBack);
        jButtonOneBack.setBounds(125, 38, 40, 23);

        jTextFieldCurrentNo.setToolTipText("Number of the current selected image.");
        jTextFieldCurrentNo.setName("jTextFieldCurrentNo"); // NOI18N
        jPanel3.add(jTextFieldCurrentNo);
        jTextFieldCurrentNo.setBounds(120, 13, 30, 19);

        jLabel13.setText("now");
        jLabel13.setName("jLabel13"); // NOI18N
        jPanel3.add(jLabel13);
        jLabel13.setBounds(90, 16, 30, 15);

        jTextFieldCount.setText("0");
        jTextFieldCount.setToolTipText("Count of images.");
        jTextFieldCount.setName("jTextFieldCount"); // NOI18N
        jPanel3.add(jTextFieldCount);
        jTextFieldCount.setBounds(47, 13, 30, 19);

        jLabel12.setText("Count");
        jLabel12.setName("jLabel12"); // NOI18N
        jPanel3.add(jLabel12);
        jLabel12.setBounds(10, 16, 40, 15);

        jButtonDeleteOne.setText("Delete");
        jButtonDeleteOne.setToolTipText("Deletes selected image.");
        jButtonDeleteOne.setName("jButtonDeleteOne"); // NOI18N
        jButtonDeleteOne.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDeleteOneActionPerformed(evt);
            }
        });
        jPanel3.add(jButtonDeleteOne);
        jButtonDeleteOne.setBounds(342, 13, 70, 23);

        jButtonAsSource.setText("As source");
        jButtonAsSource.setToolTipText("Takes the selected image as new source.");
        jButtonAsSource.setName("jButtonAsSource"); // NOI18N
        jButtonAsSource.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAsSourceActionPerformed(evt);
            }
        });
        jPanel3.add(jButtonAsSource);
        jButtonAsSource.setBounds(415, 38, 90, 23);

        jButtonAsSource1.setText("Get source");
        jButtonAsSource1.setToolTipText("Takes the selected image as new source.");
        jButtonAsSource1.setName("jButtonAsSource1"); // NOI18N
        jButtonAsSource1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAsSource1ActionPerformed(evt);
            }
        });
        jPanel3.add(jButtonAsSource1);
        jButtonAsSource1.setBounds(415, 13, 90, 23);

        jButtonClear.setText("Clear");
        jButtonClear.setToolTipText("Clears (deletes all) images.");
        jButtonClear.setName("jButtonClear"); // NOI18N
        jButtonClear.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonClearActionPerformed(evt);
            }
        });
        jPanel3.add(jButtonClear);
        jButtonClear.setBounds(350, 38, 60, 23);

        jLabel33.setText("Selection Size: ");
        jLabel33.setName("jLabel33"); // NOI18N
        jPanel3.add(jLabel33);
        jLabel33.setBounds(10, 41, 100, 15);

        jLabelSelSize.setText(" ");
        jLabelSelSize.setName("jLabelSelSize"); // NOI18N
        jPanel3.add(jLabelSelSize);
        jLabelSelSize.setBounds(86, 41, 50, 15);

        jButtonReverse.setText("Reverse");
        jButtonReverse.setToolTipText("Reverses the order of all images.");
        jButtonReverse.setName("jButtonReverse"); // NOI18N
        jButtonReverse.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonReverseActionPerformed(evt);
            }
        });
        jPanel3.add(jButtonReverse);
        jButtonReverse.setBounds(228, 13, 81, 23);

        jButtonSaveAnimImage.setText("Save Anim Image");
        jButtonSaveAnimImage.setToolTipText("Reverses the order of all images.");
        jButtonSaveAnimImage.setName("jButtonSaveAnimImage"); // NOI18N
        jButtonSaveAnimImage.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveAnimImageActionPerformed(evt);
            }
        });
        jPanel3.add(jButtonSaveAnimImage);
        jButtonSaveAnimImage.setBounds(218, 38, 130, 23);

        jCheckBoxRandom.setText("Random");
        jCheckBoxRandom.setName("jCheckBoxRandom"); // NOI18N
        jPanel3.add(jCheckBoxRandom);
        jCheckBoxRandom.setBounds(158, 16, 68, 19);

        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
        jScrollPane1.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
        jScrollPane1.setName("jScrollPane1"); // NOI18N

        jPanelIMageCollection.setMinimumSize(new java.awt.Dimension(15, 62));
        jPanelIMageCollection.setName("jPanelIMageCollection"); // NOI18N
        jPanelIMageCollection.setLayout(new java.awt.FlowLayout(java.awt.FlowLayout.LEADING));

        jPanel12.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        jPanel12.setName("jPanel12"); // NOI18N
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
        jPanel13.setName("jPanel13"); // NOI18N
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

        jScrollPane1.setViewportView(jPanelIMageCollection);

        jLabel2.setText("Image source");
        jLabel2.setName("jLabel2"); // NOI18N

        jTextFieldImageSource.setToolTipText("Image path Info");
        jTextFieldImageSource.setName("jTextFieldImageSource"); // NOI18N
        jTextFieldImageSource.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldImageSourceFocusLost(evt);
            }
        });

        jButtonFileSelect.setText("...");
        jButtonFileSelect.setToolTipText("If multiple files are selected, an \"Add Series\" is done automatically for all images.");
        jButtonFileSelect.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect.setName("jButtonFileSelect"); // NOI18N
        jButtonFileSelect.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelectActionPerformed(evt);
            }
        });

        jButtonAddFileSeries.setText("Add file series");
        jButtonAddFileSeries.setToolTipText("<html>\nAdd as series, adds images from files which are<br>\nnumberd, as e.g. \"Pacman01.png\", \"Pacman02.png\",  \"Pacman03.png\"... <br>\nand adds images from these files from posX, posY and width and height.<br>\n<p>\nCount gives the number of files which are looked for.<br>\nIn the above \"Pacman\" exampe - any of these files can be chosen as the \"base\"-file, <br>\nthe numbers at the end will be exchanged with the \"counter\".\n<BR><P>\n<B>Allways use the FULL filename!</B></P>\n</html>"); // NOI18N
        jButtonAddFileSeries.setName("jButtonAddFileSeries"); // NOI18N
        jButtonAddFileSeries.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAddFileSeriesActionPerformed(evt);
            }
        });

        jLabel28.setText("#");
        jLabel28.setName("jLabel28"); // NOI18N

        jTextFieldFileCount.setToolTipText("Default - if digits get filled on the left with '0', a leading '-' does not fill (base is fixed at -1 char)!");
        jTextFieldFileCount.setName("jTextFieldFileCount"); // NOI18N

        jCheckBoxUseFileSizes.setSelected(true);
        jCheckBoxUseFileSizes.setText("Use file sizes!");
        jCheckBoxUseFileSizes.setToolTipText("If not selected the size given by width and Height are taken!");
        jCheckBoxUseFileSizes.setName("jCheckBoxUseFileSizes"); // NOI18N

        jButton1.setText("Origin ");
        jButton1.setName("jButton1"); // NOI18N
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jCheckBoxAnimationOffset.setSelected(true);
        jCheckBoxAnimationOffset.setText("of");
        jCheckBoxAnimationOffset.setName("jCheckBoxAnimationOffset"); // NOI18N
        jCheckBoxAnimationOffset.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxAnimationOffsetActionPerformed(evt);
            }
        });

        jCheckBoxPreviewOffset.setText("of");
        jCheckBoxPreviewOffset.setName("jCheckBoxPreviewOffset"); // NOI18N
        jCheckBoxPreviewOffset.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxPreviewOffsetActionPerformed(evt);
            }
        });

        jButton6.setText("!");
        jButton6.setToolTipText("Easier import for masses of reiners animation sequences");
        jButton6.setName("jButton6"); // NOI18N
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldImageSource, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonFileSelect)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButton6)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButtonAddFileSeries)
                        .addGap(18, 18, 18)
                        .addComponent(jLabel28)
                        .addGap(3, 3, 3)
                        .addComponent(jTextFieldFileCount, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxUseFileSizes)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton1))
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel9)
                            .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel4Layout.createSequentialGroup()
                                .addComponent(jCheckBoxPreviewScaled)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBoxPreviewOffset))
                            .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel4Layout.createSequentialGroup()
                                .addComponent(jLabel10)
                                .addGap(4, 4, 4)
                                .addComponent(jTextFieldDelay, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jToggleButtonPlayAnim)
                            .addGroup(jPanel4Layout.createSequentialGroup()
                                .addComponent(jCheckBoxAnimationScaled)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBoxAnimationOffset)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)))))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextFieldImageSource, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel2)
                    .addComponent(jButtonFileSelect)
                    .addComponent(jButtonAddFileSeries)
                    .addComponent(jLabel28)
                    .addComponent(jTextFieldFileCount, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxUseFileSizes)
                    .addComponent(jButton1)
                    .addComponent(jButton6))
                .addGap(12, 12, 12)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBoxPreviewScaled)
                            .addComponent(jCheckBoxPreviewOffset))
                        .addGap(6, 6, 6)
                        .addComponent(jLabel9)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, 132, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(2, 2, 2)
                        .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 157, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBoxAnimationScaled)
                            .addComponent(jCheckBoxAnimationOffset))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldDelay, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel10))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jToggleButtonPlayAnim))
                    .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 78, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        jPanel15.setBorder(javax.swing.BorderFactory.createTitledBorder("Image Collection"));
        jPanel15.setAlignmentY(0.0F);
        jPanel15.setName("jPanel15"); // NOI18N

        jButtonAddAsAnimImage.setText("Add as (anim) image");
        jButtonAddAsAnimImage.setToolTipText("<html>\nAdds images from the \"grid\"-info. Exactly \"all #\" images will be taken.<br>\n\nImages from grid are taken from top to bottom and than from left to right,.<br>\nif vertical first is selected, form left to right anf top to bottom otherwise.<br>\n\nThese images are added to the anim of the current \"single\" image.\n</html>"); // NOI18N
        jButtonAddAsAnimImage.setName("jButtonAddAsAnimImage"); // NOI18N
        jButtonAddAsAnimImage.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAddAsAnimImageActionPerformed(evt);
            }
        });

        jButtonAddMultipleImages.setText("Add as multiple images");
        jButtonAddMultipleImages.setToolTipText("<html>\nAdds images from the \"grid\"-info. Exactly \"all #\" images will be taken.<br>\n\nImages from grid are taken from top to bottom and than from left to right,.<br>\nif vertical first is selected, form left to right anf top to bottom otherwise.<br>\n\nThese images are added to the anim of the current \"single\" image.\n</html>"); // NOI18N
        jButtonAddMultipleImages.setName("jButtonAddMultipleImages"); // NOI18N
        jButtonAddMultipleImages.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAddMultipleImagesActionPerformed(evt);
            }
        });

        jLabel36.setText("Name");
        jLabel36.setName("jLabel36"); // NOI18N

        jTextFieldName.setName("jTextFieldName"); // NOI18N

        jComboBoxName.setName("jComboBoxName"); // NOI18N
        jComboBoxName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxNameActionPerformed(evt);
            }
        });

        jButtonDelete.setText("Delete");
        jButtonDelete.setToolTipText("Delete this image from collection");
        jButtonDelete.setName("jButtonDelete"); // NOI18N
        jButtonDelete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDeleteActionPerformed(evt);
            }
        });

        jCheckBoxReplace.setText("replace if name exists");
        jCheckBoxReplace.setName("jCheckBoxReplace"); // NOI18N

        jButtonReset.setText("Re Set");
        jButtonReset.setName("jButtonReset"); // NOI18N
        jButtonReset.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonResetActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel15Layout = new javax.swing.GroupLayout(jPanel15);
        jPanel15.setLayout(jPanel15Layout);
        jPanel15Layout.setHorizontalGroup(
            jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel15Layout.createSequentialGroup()
                .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel15Layout.createSequentialGroup()
                        .addComponent(jLabel36)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jTextFieldName, javax.swing.GroupLayout.PREFERRED_SIZE, 133, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxReplace))
                    .addGroup(jPanel15Layout.createSequentialGroup()
                        .addComponent(jButtonAddAsAnimImage)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonAddMultipleImages)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonReset)
                        .addGap(62, 62, 62)
                        .addComponent(jButtonDelete)
                        .addGap(18, 18, 18)
                        .addComponent(jComboBoxName, javax.swing.GroupLayout.PREFERRED_SIZE, 122, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(0, 12, Short.MAX_VALUE))
        );
        jPanel15Layout.setVerticalGroup(
            jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel15Layout.createSequentialGroup()
                .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel15Layout.createSequentialGroup()
                        .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButtonAddAsAnimImage)
                            .addComponent(jButtonAddMultipleImages)
                            .addComponent(jButtonDelete)
                            .addComponent(jButtonReset))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel36)
                            .addComponent(jCheckBoxReplace)))
                    .addComponent(jComboBoxName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(1, 1, 1))
        );

        javax.swing.GroupLayout jPanel7Layout = new javax.swing.GroupLayout(jPanel7);
        jPanel7.setLayout(jPanel7Layout);
        jPanel7Layout.setHorizontalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addComponent(jPanel15, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
            .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel15, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(22, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel8Layout = new javax.swing.GroupLayout(jPanel8);
        jPanel8.setLayout(jPanel8Layout);
        jPanel8Layout.setHorizontalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addComponent(jPanel7, javax.swing.GroupLayout.PREFERRED_SIZE, 667, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, 266, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel8Layout.setVerticalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel7, javax.swing.GroupLayout.DEFAULT_SIZE, 610, Short.MAX_VALUE)
            .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, 610, Short.MAX_VALUE)
        );

        jPanel16.setBorder(javax.swing.BorderFactory.createTitledBorder("Image Collection"));
        jPanel16.setAlignmentX(1.0F);
        jPanel16.setName("jPanel16"); // NOI18N

        jScrollPane5.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane5.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
        jScrollPane5.setName("jScrollPane5"); // NOI18N

        jPanelIMageCollection1.setMinimumSize(new java.awt.Dimension(20, 20));
        jPanelIMageCollection1.setName("jPanelIMageCollection1"); // NOI18N
        jPanelIMageCollection1.setPreferredSize(new java.awt.Dimension(20, 20));
        jPanelIMageCollection1.setLayout(null);

        jPanel17.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        jPanel17.setName("jPanel17"); // NOI18N
        jPanel17.setPreferredSize(new java.awt.Dimension(52, 52));

        javax.swing.GroupLayout jPanel17Layout = new javax.swing.GroupLayout(jPanel17);
        jPanel17.setLayout(jPanel17Layout);
        jPanel17Layout.setHorizontalGroup(
            jPanel17Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 50, Short.MAX_VALUE)
        );
        jPanel17Layout.setVerticalGroup(
            jPanel17Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 50, Short.MAX_VALUE)
        );

        jPanelIMageCollection1.add(jPanel17);
        jPanel17.setBounds(5, 5, 52, 52);

        jScrollPane5.setViewportView(jPanelIMageCollection1);

        javax.swing.GroupLayout jPanel16Layout = new javax.swing.GroupLayout(jPanel16);
        jPanel16.setLayout(jPanel16Layout);
        jPanel16Layout.setHorizontalGroup(
            jPanel16Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel16Layout.createSequentialGroup()
                .addComponent(jScrollPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 78, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel16Layout.setVerticalGroup(
            jPanel16Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane5)
        );

        jPanel18.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel18.setName("jPanel18"); // NOI18N

        jComboBoxKlasse.setName("jComboBoxKlasse"); // NOI18N
        jComboBoxKlasse.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxKlasseActionPerformed(evt);
            }
        });

        jLabel37.setText("Class");
        jLabel37.setName("jLabel37"); // NOI18N

        jTextFieldKlasse.setName("jTextFieldKlasse"); // NOI18N

        jButtonNew.setText("New");
        jButtonNew.setName("jButtonNew"); // NOI18N
        jButtonNew.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewActionPerformed(evt);
            }
        });

        jButtonSaveClassAsImage.setText("Save class as new single image");
        jButtonSaveClassAsImage.setName("jButtonSaveClassAsImage"); // NOI18N
        jButtonSaveClassAsImage.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveClassAsImageActionPerformed(evt);
            }
        });

        jLabel38.setText("File");
        jLabel38.setName("jLabel38"); // NOI18N

        jTextFieldFile.setName("jTextFieldFile"); // NOI18N
        jTextFieldFile.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldFileActionPerformed(evt);
            }
        });
        jTextFieldFile.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldFileFocusLost(evt);
            }
        });

        jButton3.setText("i");
        jButton3.setName("jButton3"); // NOI18N
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        jButtonFileSelect1.setText("...");
        jButtonFileSelect1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect1.setName("jButtonFileSelect1"); // NOI18N
        jButtonFileSelect1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect1ActionPerformed(evt);
            }
        });

        jButtonSave.setText("Save");
        jButtonSave.setToolTipText("Save changes made to image(s)");
        jButtonSave.setName("jButtonSave"); // NOI18N
        jButtonSave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveActionPerformed(evt);
            }
        });

        jButtonExport.setText("User Export");
        jButtonExport.setName("jButtonExport"); // NOI18N
        jButtonExport.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonExportActionPerformed(evt);
            }
        });

        jButtonSaveClassSingleImages.setText("Save class as many single images");
        jButtonSaveClassSingleImages.setName("jButtonSaveClassSingleImages"); // NOI18N
        jButtonSaveClassSingleImages.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveClassSingleImagesActionPerformed(evt);
            }
        });

        jCheckBoxJustImages.setText("Just Images");
        jCheckBoxJustImages.setToolTipText("If selected no Rectangle is drawn arround images!");
        jCheckBoxJustImages.setName("jCheckBoxJustImages"); // NOI18N

        javax.swing.GroupLayout jPanel18Layout = new javax.swing.GroupLayout(jPanel18);
        jPanel18.setLayout(jPanel18Layout);
        jPanel18Layout.setHorizontalGroup(
            jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel18Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addGroup(jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel38)
                    .addComponent(jLabel37))
                .addGap(16, 16, 16)
                .addGroup(jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel18Layout.createSequentialGroup()
                        .addComponent(jTextFieldKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, 135, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jComboBoxKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel18Layout.createSequentialGroup()
                        .addComponent(jTextFieldFile, javax.swing.GroupLayout.PREFERRED_SIZE, 135, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonFileSelect1)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel18Layout.createSequentialGroup()
                        .addComponent(jButtonNew)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSave))
                    .addComponent(jButtonExport, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(46, 46, 46)
                .addGroup(jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonSaveClassAsImage)
                    .addComponent(jButton3))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxJustImages)
                    .addComponent(jButtonSaveClassSingleImages))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel18Layout.setVerticalGroup(
            jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel18Layout.createSequentialGroup()
                .addGroup(jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextFieldFile, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel38)
                    .addComponent(jButtonFileSelect1)
                    .addComponent(jButtonExport)
                    .addComponent(jButton3)
                    .addComponent(jCheckBoxJustImages))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jComboBoxKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButtonNew)
                        .addComponent(jButtonSave)
                        .addComponent(jButtonSaveClassAsImage)
                        .addComponent(jButtonSaveClassSingleImages))
                    .addGroup(jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTextFieldKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel37))))
        );

        jToggleButtonPlayAnimMain.setText("Play");
        jToggleButtonPlayAnimMain.setToolTipText("Animates through all images, animation is looped. Given delay is taken.");
        jToggleButtonPlayAnimMain.setName("jToggleButtonPlayAnimMain"); // NOI18N
        jToggleButtonPlayAnimMain.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButtonPlayAnimMainActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel16, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(layout.createSequentialGroup()
                        .addGap(28, 28, 28)
                        .addComponent(jToggleButtonPlayAnimMain)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jPanel18, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addComponent(jPanel18, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jToggleButtonPlayAnimMain)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel16, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jPanel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
        );
    }// </editor-fold>//GEN-END:initComponents


    private void jComboBoxKlasseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxKlasseActionPerformed
        if (!getPool()) {
            return;
        }
        if (mClassSetting > 0) {
            return;
        }
        if (jComboBoxKlasse.getSelectedIndex()==-1) return;
        mClassSetting++;

        String selected = jComboBoxKlasse.getSelectedItem().toString();
        clearAll();
        resetConfigPool(true, selected);
        jTextFieldKlasse.setText(jComboBoxKlasse.getSelectedItem().toString());
        String selectedName ="";
        if (jComboBoxName.getSelectedIndex()!=-1)
        {
            String key = jComboBoxName.getSelectedItem().toString();
            mISData = mImageSequenceDataPool.get(key);
            selectedName = mISData.mName;
        }

        setAllFromCurrent();
        mClassSetting--;
        setClassList(-1, selectedName);
    }//GEN-LAST:event_jComboBoxKlasseActionPerformed

    private void jButtonNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewActionPerformed
        mClassSetting++;
        mISData = new ImageSequenceData();
        jComboBoxKlasse.setSelectedIndex(-1);
        jTextFieldKlasse.setText("");

        clearAll();
        resetConfigPool(false, "");
        mClassSetting--;
    }//GEN-LAST:event_jButtonNewActionPerformed

    private void jTextFieldFileActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldFileActionPerformed
       
    }//GEN-LAST:event_jTextFieldFileActionPerformed

    private void jTextFieldFileFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldFileFocusLost
        getPool();
        resetConfigPool(false, "");
    }//GEN-LAST:event_jTextFieldFileFocusLost

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        String help = "";
        help += "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"> ";
        help += "<html> <head>   ";
        help += "<title></title> </head>";
        help += "<body> <h3>Save as One</h3>Saves all images within this graphic class as one image,<br> AND sets that image to all graphics<br>(and saves them to disk). <br> ";
        help += "<br>New images generated by this tool allways have alpha channels!";
        help += "<br>";
        help += "</body>";
        help += "</html>";
        QuickHelpModal.showHelpHtml(help);
    }//GEN-LAST:event_jButton3ActionPerformed

    private void jButtonFileSelect1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect1ActionPerformed

        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();

        fc.setCurrentDirectory(new java.io.File("."));
        fc.setCurrentDirectory(new java.io.File("xml"+File.separator+"Graphics"));
//        fc.setCurrentDirectory(new java.io.File("Graphics"));
        
        FileNameExtensionFilter filter = new FileNameExtensionFilter("xml", "xml");
        fc.setFileFilter(filter);
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) {
            return;
        }
        String name = fc.getSelectedFile().getName();
        jTextFieldFile.setText(de.malban.util.UtilityString.replace(name, ".xml", ""));
        jTextFieldFileFocusLost(null);
    }//GEN-LAST:event_jButtonFileSelect1ActionPerformed

    private void jToggleButtonPlayAnimMainActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButtonPlayAnimMainActionPerformed
        jComboBoxKlasseActionPerformed(null);

    }//GEN-LAST:event_jToggleButtonPlayAnimMainActionPerformed

    
    //on delete the current selection is only in vertical field
    //not in mData
           
    
    private void jButtonDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteActionPerformed
        if (!getPool()) {
            return;
        }
        readAllToCurrent();
        String key = "";
        int index = jComboBoxName.getSelectedIndex();
        mImageSequenceDataPool.remove(mISData);
        mImageSequenceDataPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true, klasse);
        String nameToSet = "";
        if (jComboBoxName.getSelectedIndex() == -1) {
            clearAll();
        }
        else
        {
            if (index > jComboBoxName.getItemCount()-1) index--;
            if (index > 0)
            {
                key = jComboBoxName.getItemAt(index).toString();
                //key = jComboBoxName.getSelectedItem().toString();
                mISData = mImageSequenceDataPool.get(key);
                nameToSet = key;
            }
            
            setAllFromCurrent();
        }
        mClassSetting--;
        setClassList(index, nameToSet);
        if (nameToSet.length()!=0)
        {
            mISData = mImageSequenceDataPool.get(nameToSet);
            setCurrentData(BaseImageData.toBase(mISData));
        }
        
        if (currentSelectedImagePanel!=null)
            jScrollPane5.getViewport().scrollRectToVisible(new Rectangle(5, currentSelectedImagePanel.getY(), 52, 52));
        
    }//GEN-LAST:event_jButtonDeleteActionPerformed

    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed

        if (!getPool()) {
            return;
        }
        readAllToCurrent();

        String currentKey = jTextFieldName.getText();

        if (mImageSequenceDataPool.get(currentKey) != null)
        {
            if (!jCheckBoxReplace.isSelected())
            {
                notSavedShow();
                return;
            }
        }

        int stype = getSaveType();
        if (stype != SAVE_OK) {
            String filename = "";

            if (stype == SAVE_NOK) {
                Configuration C = Configuration.getConfiguration();
                if (C.getMainFrame() == null) {
                    return;
                }
                MustSaveAsOneDialog ac = new MustSaveAsOneDialog();
                ModalInternalFrame modal = new ModalInternalFrame("Save as new image!", C.getMainFrame().getRootPane(), C.getMainFrame(), ac);
                ac.setDialog(modal);
                modal.setVisible(true);
                filename = ac.getFilename();
                if (filename.length() == 0) {
                    return;
                }
            }

            if (filename.length() != 0)
            {
                Vector <BaseImageData> allImages = readAllToCurrentISE();
                String path = "";
                if (allImages.size()>0)
                {
                    String file = allImages.elementAt(0).fileName;
                    path = UtilityString.getPath(file);
                }
                if (path.equals("."+File.separator))
                    path = "."+File.separator+"images"+File.separator;

                saveNewImage(path+filename + ".png");
                jTextFieldImageSource.setText(path+filename + ".png"); // needed for refresh - otherwiese the path will be overwritten
                

                BaseImageData.fromBase(mISData, mData);
                refreshCollection();
            }
        }

        mImageSequenceDataPool.put(mISData);
        mImageSequenceDataPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true, klasse);
        setClassList(-1,mISData.mName);
        mClassSetting--;
        jComboBoxName.setSelectedItem(mISData.mName);
        if (currentSelectedImagePanel!=null)
            jScrollPane5.getViewport().scrollRectToVisible(new Rectangle(5, currentSelectedImagePanel.getY(), 52, 52));

    }//GEN-LAST:event_jButtonSaveActionPerformed

    private void jComboBoxNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxNameActionPerformed
        if (!getPool()) {
            return;
        }
        if (mClassSetting > 0) {
            return;
        }
        String key = jComboBoxName.getSelectedItem().toString();
        mISData = mImageSequenceDataPool.get(key);
        
        setAllFromCurrent(true);
    }//GEN-LAST:event_jComboBoxNameActionPerformed


    private void jButtonAddMultipleImagesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAddMultipleImagesActionPerformed
        if (!getPool()) {
            return;
        }
        readAllToCurrent();
        int stype = getSaveType();

        if (stype != SAVE_OK) {
            String filename = "";

            if (stype == SAVE_NOK) {
                Configuration C = Configuration.getConfiguration();
                if (C.getMainFrame() == null) {
                    return;
                }
                MustSaveAsOneDialog ac = new MustSaveAsOneDialog();
                ModalInternalFrame modal = new ModalInternalFrame("Save as new image!", C.getMainFrame().getRootPane(), C.getMainFrame(), ac);
                ac.setDialog(modal);
                modal.setVisible(true);
                filename = ac.getFilename();
                if (filename.length() == 0) {
                    return;
                }
            }

            if (filename.length() != 0)
            {
                Vector <BaseImageData> allImages = readAllToCurrentISE();
                String path = "";
                if (allImages.size()>0)
                {
                    String file = allImages.elementAt(0).fileName;
                    path = UtilityString.getPath(file);
                }


                saveNewImage(path+filename + ".png");
                BaseImageData.fromBase(mISData, mData);
                refreshCollection();
            }
        }

        String nameOne="";
        Vector <BaseImageData> allImages = readAllToCurrentISE();
        boolean saveOk=true;
        String selectName="";
        for (int i=0; i< allImages.size();i++)
        {
            ImageSequenceData isData = new ImageSequenceData();

            Vector <BaseImageData> oneImage = new Vector <BaseImageData>();
            oneImage.addElement(allImages.elementAt(i));

            isData.mDelay = mISData.mDelay;
            isData.mClass = mISData.mClass;
            isData.mOriginNotice = currentNotice;
            if (allImages.size()>1)
                isData.mName = mISData.mName+i;
            else
                isData.mName=mISData.mName;
            if (i==0) nameOne = isData.mName;

            String currentKey = isData.mName;
            if (mImageSequenceDataPool.get(currentKey) != null)
            {
                saveOk=false;
                break;
            }
            BaseImageData.fromBase(isData, oneImage);
            mImageSequenceDataPool.put(isData);
        }
        if (!saveOk)
        {
            if (!jCheckBoxReplace.isSelected())
            {
                notSavedShow();
                return;
            }
        }
        mImageSequenceDataPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true, klasse);
        jComboBoxName.setSelectedItem(nameOne);
        mClassSetting--;
        setClassList(-1, nameOne);
        if (currentSelectedImagePanel!=null)
            jScrollPane5.getViewport().scrollRectToVisible(new Rectangle(5, currentSelectedImagePanel.getY(), 52, 52));
        
    }//GEN-LAST:event_jButtonAddMultipleImagesActionPerformed

    private void jButtonAddAsAnimImageActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAddAsAnimImageActionPerformed
        jButtonSaveActionPerformed(null);
    }//GEN-LAST:event_jButtonAddAsAnimImageActionPerformed

    private void jButtonAddFileSeriesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAddFileSeriesActionPerformed

        int count = getI(jTextFieldFileCount);
        boolean fillZero = true;

        if (count <0)
        {
            fillZero=false;
            count*=-1;
        }
        String name = jTextFieldImageSource.getText();
        String extension = name.substring(name.lastIndexOf("."));
        String base = name.substring(0, name.lastIndexOf("."));
        boolean greaterTen = count>9;
        if (greaterTen)
            base = base.substring(0, base.length()-2);
        else
            base = base.substring(0, base.length()-1);
        boolean greaterHundred = count>99;
        if (greaterHundred)
            base = base.substring(0, base.length()-1);

        if (!fillZero)
        {
            // if not filled with 0, than start with base -1!
            base = name.substring(0, name.lastIndexOf("."));
            base = base.substring(0, base.length()-1);
        }
        int x = getI(jTextFieldStartX);
        int y = getI(jTextFieldStartY);
        int w = getI(jTextFieldWidth);
        int h = getI(jTextFieldHeight);

        for (int i=0; i<count; i++)
        {
            String path = base;
            if ((i<10) && (greaterTen) && (fillZero)) path+="0";
            if ((i<99) && (greaterHundred) && (fillZero)) path+="0";
            path+=i;
            path+=extension;
            if (count == 1) path = name;

            jTextFieldImageSource.setText(de.malban.util.Utility.makeRelative(path));
            setImage();

            if (jCheckBoxUseFileSizes.isSelected())
            {
                w = singleImagePanel1.getSourceWidth();
                h = singleImagePanel1.getSourceHeight();
                x=0;
                y=0;
            }
            currentBase = singleImagePanel1.getSelection(x,y,w,h);
            currentBase.notice = currentNotice;
            addCurrentToData();
            //jButtonAddOneImageActionPerformed(null);
        }
    }//GEN-LAST:event_jButtonAddFileSeriesActionPerformed

    String lastImagePath="";
    private void jButtonFileSelectActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelectActionPerformed

        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setMultiSelectionEnabled(true);
        if (lastImagePath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File("."));
            fc.setCurrentDirectory(new java.io.File("images"));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastImagePath));
        }
        FileNameExtensionFilter  filter = new  FileNameExtensionFilter("Images", "jpg", "jpeg", "png", "bmp", "gif");
        fc.setFileFilter(filter);
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        File[] files = fc.getSelectedFiles();
        if ((files == null) || (files.length == 1))
        {
            String fullPath = fc.getSelectedFile().getAbsolutePath();
            lastImagePath = fullPath;
            
            jTextFieldImageSource.setText(de.malban.util.Utility.makeRelative(fullPath));
            setImage();
            inSetting++;
            jSliderSourceScale.setValue(6);
            singleImagePanel1.setScale(1);
            inSetting--;
        }
        else // add multiple images
        {
            addMultipleImages(files);
        }

    }//GEN-LAST:event_jButtonFileSelectActionPerformed


    private void jTextFieldImageSourceFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldImageSourceFocusLost
        setImage();
    }//GEN-LAST:event_jTextFieldImageSourceFocusLost

    private void jButtonReverseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonReverseActionPerformed

        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }

        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            baseImageData.pos = (mData.size()-1)-baseImageData.pos;

            if (mCloneData != null) mCloneData.elementAt(i).pos = (mCloneData.size()-1)-mCloneData.elementAt(i).pos;
            
            
            if (baseImageData.cpanel != null)
            baseImageData.cpanel.setName(""+baseImageData.pos);
        }
        BaseImageData.reorder(mData);
        if (mCloneData != null) BaseImageData.reorder(mCloneData);
        refreshCollection();
        if (currentSelectedBasePanel != null)
        {
            currentSelectedBasePanel.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
            currentSelectedBasePanel = null;
            currentSelectedNo = -1;
        }
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
    }//GEN-LAST:event_jButtonReverseActionPerformed

    private void jButtonClearActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonClearActionPerformed
        clearBaseImageData();
        mData = new  Vector <BaseImageData>();
        mCloneData = null;
        currentSelectedBasePanel = null;
        currentSelectedNo = -1;
        refreshCollection();
        newImages = false;
    }//GEN-LAST:event_jButtonClearActionPerformed

    private void jButtonAsSource1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAsSource1ActionPerformed
        if (currentSelectedNo == -1) return;
        currentBase = mData.elementAt(currentSelectedNo);
        currentBase.notice = currentNotice;

        jTextFieldImageSource.setText(currentBase.fileName);
        setImage();
        inSetting++;
        jSliderSourceScale.setValue(6);
        singleImagePanel1.setScale(1);
        inSetting--;
    }//GEN-LAST:event_jButtonAsSource1ActionPerformed

    private void jButtonAsSourceActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAsSourceActionPerformed
        if (currentSelectedNo==-1) return;
        inSetting++;
        jSliderSourceScale.setValue(6);
        singleImagePanel1.setScale(1);
        inSetting--;
        currentBase = mData.elementAt(currentSelectedNo);
        singleImagePanel1.setImage(currentBase.image);
    }//GEN-LAST:event_jButtonAsSourceActionPerformed

    private void jButtonDeleteOneActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteOneActionPerformed
        if (currentSelectedNo == -1) return;
        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        for (int i = 0; i < mData.size(); i++) {
            BaseImageData baseImageData = mData.elementAt(i);
            if (baseImageData.pos > currentSelectedNo)
            baseImageData.pos--;
        }
        mData.removeElementAt(currentSelectedNo);
        if (mCloneData != null) mCloneData.removeElementAt(currentSelectedNo);
        if (currentSelectedNo>= mData.size()) currentSelectedNo--;
        if (currentSelectedNo==-1)
        {
            jTextFieldCurrentNo.setText("");
            jLabelSelSize.setText("");
            currentSelectedBasePanel = null;
            refreshCollection();
            return;
        }
        currentSelectedBasePanel = mData.elementAt(currentSelectedNo).cpanel;
        currentSelectedBasePanel.setBorder(javax.swing.BorderFactory.createLineBorder(Color.ORANGE));
        jTextFieldCurrentNo.setText(""+currentSelectedNo);
        jLabelSelSize.setText(""+mData.elementAt(currentSelectedNo).w+"/"+mData.elementAt(currentSelectedNo).h);
        refreshCollection(false);
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
    }//GEN-LAST:event_jButtonDeleteOneActionPerformed

    private void jButtonOneBackActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOneBackActionPerformed

        if (currentSelectedNo == -1) return;
        if (currentSelectedNo == 0) return;

        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        mData.elementAt(currentSelectedNo).pos--;
        if (mData.elementAt(currentSelectedNo).cpanel != null)
        mData.elementAt(currentSelectedNo).cpanel.setName(""+mData.elementAt(currentSelectedNo).pos);

        mData.elementAt(currentSelectedNo-1).pos++;
        if (mData.elementAt(currentSelectedNo-1).cpanel != null)
        mData.elementAt(currentSelectedNo-1).cpanel.setName(""+mData.elementAt(currentSelectedNo-1).pos);

        BaseImageData.reorder(mData);
        
        if (mCloneData != null)
        {
            mCloneData.elementAt(currentSelectedNo).pos--;

            mCloneData.elementAt(currentSelectedNo-1).pos++;
            BaseImageData.reorder(mCloneData);
        }
        
        
        
        currentSelectedNo--;
        jTextFieldCurrentNo.setText(""+currentSelectedNo);

        refreshCollection(false);
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
    }//GEN-LAST:event_jButtonOneBackActionPerformed

    private void jButtonOneForwardActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOneForwardActionPerformed
        if (currentSelectedNo == -1) return;
        if (currentSelectedNo == mData.size()-1) return;
        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }

        mData.elementAt(currentSelectedNo).pos++;
        if (mData.elementAt(currentSelectedNo).cpanel != null)
        mData.elementAt(currentSelectedNo).cpanel.setName(""+mData.elementAt(currentSelectedNo).pos);

        mData.elementAt(currentSelectedNo+1).pos--;
        if (mData.elementAt(currentSelectedNo+1).cpanel != null)
        mData.elementAt(currentSelectedNo+1).cpanel.setName(""+mData.elementAt(currentSelectedNo+1).pos);

        BaseImageData.reorder(mData);
        if (mCloneData != null)
        {
            mCloneData.elementAt(currentSelectedNo).pos++;

            mCloneData.elementAt(currentSelectedNo-1).pos--;
            BaseImageData.reorder(mCloneData);
        }
        
        
        currentSelectedNo++;
        jTextFieldCurrentNo.setText(""+currentSelectedNo);

        refreshCollection(false);
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
    }//GEN-LAST:event_jButtonOneForwardActionPerformed

    private void jCheckBoxPreviewScaledActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxPreviewScaledActionPerformed

        previewScale = jCheckBoxPreviewScaled.isSelected();
        if (previewScale)
        {
            singleImagePanel2.unsetScale(100,100);
            jButton11ActionPerformed(null);   
            jScrollPane3.invalidate();
            jScrollPane3.validate();
            jScrollPane3.repaint();
            
        }
        else
        {
            singleImagePanel2.setScale(singleImagePanel2.getWidth(), singleImagePanel2.getHeight());
            jButton11ActionPerformed(null);   
            jScrollPane3.invalidate();
            jScrollPane3.validate();
            jScrollPane3.repaint();
        }
        invalidate();
        validate();
        repaint();
    }//GEN-LAST:event_jCheckBoxPreviewScaledActionPerformed

    private void jButtonBuildAniActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonBuildAniActionPerformed

        if (currentBase == null) return;
        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        int steps = getI(jTextFieldSteps);
        int start = getI(jTextFieldStart);
        int end = getI(jTextFieldEnd);
        if (steps <= 1) return;
        BufferedImage bimage = currentBase.image;
        Vector<BufferedImage> bimages = new Vector<BufferedImage>();

        if (jRadioButtonRotation.isSelected())
        {
            double angleInc = 360.0 / ((double)steps);
            double angleNow;
            for (int i=0; i<steps; i++)
            {
                angleNow=(angleInc*((double)i));
                BufferedImage dimg = ImageCache.getImageCache().getDerivatRotate(bimage, angleNow);
                bimages.addElement(dimg);
            }
        }
        if (jRadioButtonOpacity.isSelected())
        {
            double stepIncread = (end-start)/((double)steps);
            double opaqueness;

            for (int s = 0; s<steps;s++)
            {
                opaqueness= start + (s*stepIncread);
                BufferedImage dimg = ImageCache.getImageCache().getDerivatOpaque(bimage, (int) opaqueness);
                bimages.addElement(dimg);
            }
        }
        if (jRadioButtonScaling.isSelected())
        {
            double stepIncread = (end-start)/((double)steps);
            double scalePercent;

            for (int s = 0; s<steps;s++)
            {
                scalePercent= start + (s*stepIncread);
                BufferedImage dimg = ImageCache.getImageCache().getDerivatScale(bimage, (int) scalePercent);
                bimages.addElement(dimg);
            }
        }

        for (int i = 0; i < bimages.size(); i++)
        {
            BufferedImage bufferedImage = bimages.elementAt(i);
            BaseImageData data = new BaseImageData();
            data.image = bufferedImage;
            data.pos = mData.size();
            data.x = 0;
            data.y = 0;

            data.w = bufferedImage.getWidth();
            data.h = bufferedImage.getHeight();
            data.notice = currentNotice;
            mData.addElement(data);
        }
        mCloneData = null;


        refreshCollection();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        newImages = true;
    }//GEN-LAST:event_jButtonBuildAniActionPerformed

    private void jButtonResozeCanvasActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonResozeCanvasActionPerformed

        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }

        int w = getI(jTextFieldScaleWidth);
        int h = getI(jTextFieldScaleHeight);
        if ((w<=0) || (h<=0)) return;
        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            baseImageData.w=w;
            baseImageData.h=h;
            baseImageData.fileName="";
            baseImageData.notice = currentNotice;
            BufferedImage bimage = baseImageData.image;

            BufferedImage dimg = ImageCache.getImageCache().getDerivatCanvasResize(bimage, w,h);
            baseImageData.image = dimg;

            if (baseImageData.cpanel != null)
            {
                removeAllSubListeners(baseImageData.cpanel);
                baseImageData.cpanel.removeAll();
                
                SingleImagePanel sip = new SingleImagePanel();
                baseImageData.cpanel.add(sip, BorderLayout.CENTER);
                sip.setBaseImage(baseImageData.image, 50, 50);

                sip.addMouseListener(new java.awt.event.MouseAdapter() {
                    @Override
                    public void mousePressed(java.awt.event.MouseEvent evt) {
                        jPanelMouseClickedHorizontal(evt);
                    }
                });
            }
        }
        newImages = true;
        mCloneData = null;

        refreshCollection();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
    }//GEN-LAST:event_jButtonResozeCanvasActionPerformed

    private void jButtonRotateAllActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRotateAllActionPerformed

        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        int angle = getI(jTextFieldAngle);
        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            BufferedImage bimage = baseImageData.image;
            if (bimage == null) continue;


            BufferedImage dimg = ImageCache.getImageCache().getDerivatRotate(bimage, angle, jCheckBoxDontChangeSize.isSelected());

            baseImageData.image = dimg;
            baseImageData.xOrg = 0;
            baseImageData.yOrg = 0;
            baseImageData.x = 0;
            baseImageData.y = 0;
            baseImageData.h = dimg.getHeight();
            baseImageData.w = dimg.getWidth();
            baseImageData.notice = currentNotice;
            baseImageData.fileName="";

            if (baseImageData.cpanel != null)
            {
                removeAllSubListeners(baseImageData.cpanel);
                baseImageData.cpanel.removeAll();
                SingleImagePanel sip = new SingleImagePanel();
                baseImageData.cpanel.add(sip, BorderLayout.CENTER);
                sip.setBaseImage(baseImageData.image, 50, 50);

                sip.addMouseListener(new java.awt.event.MouseAdapter() {
                    @Override
                    public void mousePressed(java.awt.event.MouseEvent evt) {
                        jPanelMouseClickedHorizontal(evt);
                    }
                });
            }
        }
        newImages = true;
        mCloneData = null;
        refreshCollection();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
    }//GEN-LAST:event_jButtonRotateAllActionPerformed

    private void jButtonScaleAllActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonScaleAllActionPerformed

        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        int w = getI(jTextFieldScaleWidth);
        int h = getI(jTextFieldScaleHeight);
        if ((w<=0) || (h<=0)) return;
        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            baseImageData.w=w;
            baseImageData.h=h;

            baseImageData.fileName="";
            baseImageData.notice = currentNotice;

            baseImageData.image = ImageCache.getImageCache().getDerivatScale(baseImageData.image, w, h);
            if (baseImageData.cpanel != null)
            {
                removeAllSubListeners(baseImageData.cpanel);
                baseImageData.cpanel.removeAll();
                SingleImagePanel sip = new SingleImagePanel();
                baseImageData.cpanel.add(sip, BorderLayout.CENTER);
                sip.setBaseImage(baseImageData.image, 50, 50);

                sip.addMouseListener(new java.awt.event.MouseAdapter() {
                    @Override
                    public void mousePressed(java.awt.event.MouseEvent evt) {
                        jPanelMouseClickedHorizontal(evt);
                    }
                });
            }
        }
        newImages = true;
        mCloneData = null;

        refreshCollection();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
    }//GEN-LAST:event_jButtonScaleAllActionPerformed

    private void jButtonOpacityAllActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOpacityAllActionPerformed

        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        int o = getI(jTextFieldOpacity);
        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            baseImageData.image = ImageCache.getImageCache().getDerivatOpaque(baseImageData.image, o);
            baseImageData.fileName="";
            baseImageData.notice = currentNotice;
            if (baseImageData.cpanel != null)
            {
                removeAllSubListeners(baseImageData.cpanel);
                baseImageData.cpanel.removeAll();
                SingleImagePanel sip = new SingleImagePanel();
                baseImageData.cpanel.add(sip, BorderLayout.CENTER);
                sip.setBaseImage(baseImageData.image, 50, 50);

                sip.addMouseListener(new java.awt.event.MouseAdapter() {
                    @Override
                    public void mousePressed(java.awt.event.MouseEvent evt) {
                        jPanelMouseClickedHorizontal(evt);
                    }
                });
            }
        }
        newImages = true;
        mCloneData = null;
        
        refreshCollection();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
    }//GEN-LAST:event_jButtonOpacityAllActionPerformed

    private void jToggleButtonPlayAnimActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButtonPlayAnimActionPerformed

        Vector<Image> images = new Vector<Image>();
        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            images.addElement(baseImageData.image);
        }
        BaseImageData.fromBase(mISData, mData);
    
        // WHY the heck do we read all data here! This is SOOO bothersome!
        readAllToCurrent(); /* allneeded*/


        imageComponent1.setSequence(new ImageSequence(mData));
        imageComponent1.setDelay(getI(jTextFieldDelay));
        imageComponent1.setScaled(jCheckBoxAnimationScaled.isSelected(), 100,100);
        imageComponent1.setVisible(jToggleButtonPlayAnim.isSelected());
    }//GEN-LAST:event_jToggleButtonPlayAnimActionPerformed

    private void jTextFieldDelayFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldDelayFocusLost
        imageComponent1.setDelay(getI(jTextFieldDelay));
    }//GEN-LAST:event_jTextFieldDelayFocusLost

    private void jTextFieldDelayActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldDelayActionPerformed
        imageComponent1.setDelay(getI(jTextFieldDelay));
    }//GEN-LAST:event_jTextFieldDelayActionPerformed

    private void jCheckBoxAnimationScaledActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxAnimationScaledActionPerformed
        imageComponent1.setScaled(jCheckBoxAnimationScaled.isSelected(), 100,100);
    }//GEN-LAST:event_jCheckBoxAnimationScaledActionPerformed

    private void jButtonAddImageSeriesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAddImageSeriesActionPerformed

        GridData grid = getGrid();

        int max = getI(jTextFieldCountAll);

        int maxCounter =0;

        if (jCheckBoxVerticalFirst.isSelected())
        {
            for (int xc = 0; xc<grid.gridWidth; xc++)
            {
                for (int yc = 0; yc<grid.gridHeight; yc++)
                {
                    int x = grid.startX + xc*(grid.gapX+grid.singleWidth);
                    int y = grid.startY + yc*(grid.gapY+grid.singleHeight);
                    int w = grid.singleWidth;
                    int h = grid.singleHeight;

                    currentBase = singleImagePanel1.getSelection(x,y,w,h);
                    currentBase.notice = currentNotice;
                    addCurrentToData();
                    //jButtonAddOneImageActionPerformed(null);
                    maxCounter++;
                    if (max != 0)
                    {
                        if (maxCounter>=max) return;
                    }
                }
            }
        }
        else
        {
            for (int yc = 0; yc<grid.gridHeight; yc++)
            {
                for (int xc = 0; xc<grid.gridWidth; xc++)
                {
                    int x = grid.startX + xc*(grid.gapX+grid.singleWidth);
                    int y = grid.startY + yc*(grid.gapY+grid.singleHeight);
                    int w = grid.singleWidth;
                    int h = grid.singleHeight;

                    currentBase = singleImagePanel1.getSelection(x,y,w,h);
                    currentBase.notice = currentNotice;
                    addCurrentToData();
                    // jButtonAddOneImageActionPerformed(null);
                    maxCounter++;
                    if (max != 0)
                    {
                        if (maxCounter>=max) return;
                    }
                }
            }
        }
    }//GEN-LAST:event_jButtonAddImageSeriesActionPerformed

    private void jButtonAddOneImageActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAddOneImageActionPerformed
        addCurrentToData();
    }//GEN-LAST:event_jButtonAddOneImageActionPerformed

    private void addCurrentToData()
    {
        if (currentBase == null) return;
        BaseImageData base = currentBase.copy();
        base.pos = mData.size();
        base.cpanel = null;
        mData.addElement(base);
        currentBase = base;
        refreshCollection();
        mCloneData = null;
    }

    private void jButton11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton11ActionPerformed
        //doGrid();

        // assumes NO SCALE

        // rightly assuming x and y scale is the same!
        double xs = singleImagePanel1.getScaleX();


        singleImagePanel1.unsetScale();

        currentBase = singleImagePanel1.getSelection(
                    UtilityString.Int0(jTextFieldPosX.getText()),
                    UtilityString.Int0(jTextFieldPosY.getText()),
                    UtilityString.Int0(jTextFieldWidth.getText()),
                    UtilityString.Int0(jTextFieldHeight.getText())

                );
        currentBase.notice = currentNotice;

        if (previewScale)
            singleImagePanel2.setBaseImage(currentBase.image, singleImagePanel2.getWidth(),singleImagePanel2.getHeight());
        else
            singleImagePanel2.setBaseImage(currentBase.image);

        singleImagePanel2.setOffset(currentBase.ox, currentBase.oy, jCheckBoxPreviewOffset.isSelected());
        jCheckBoxPaintSelectionActionPerformed(null);
        singleImagePanel1.setScale(xs);

    }//GEN-LAST:event_jButton11ActionPerformed

    private void jTextFieldWidthFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldWidthFocusLost
        doGrid();
        jCheckBoxPaintSelectionActionPerformed(null);
    }//GEN-LAST:event_jTextFieldWidthFocusLost

    private void jTextFieldHeightFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldHeightFocusLost
        doGrid();
        jCheckBoxPaintSelectionActionPerformed(null);
    }//GEN-LAST:event_jTextFieldHeightFocusLost

    private void jCheckBoxSelectionLockActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxSelectionLockActionPerformed
        singleImagePanel1.setSelectionLock(jCheckBoxSelectionLock.isSelected(), getI(jTextFieldWidth), getI(jTextFieldHeight));
        jTextFieldWidth.setEditable(!jCheckBoxSelectionLock.isSelected());
        jTextFieldHeight.setEditable(!jCheckBoxSelectionLock.isSelected());
    }//GEN-LAST:event_jCheckBoxSelectionLockActionPerformed

    private void jTextFieldStartXFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldStartXFocusLost
        doGrid();
    }//GEN-LAST:event_jTextFieldStartXFocusLost

    private void jTextFieldStartYFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldStartYFocusLost
        doGrid();
    }//GEN-LAST:event_jTextFieldStartYFocusLost

    private void jTextFieldCountXFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldCountXFocusLost
        doGrid();
    }//GEN-LAST:event_jTextFieldCountXFocusLost

    private void jTextFieldGapYFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldGapYFocusLost
        doGrid();
    }//GEN-LAST:event_jTextFieldGapYFocusLost

    private void jTextFieldCountYFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldCountYFocusLost
        doGrid();
    }//GEN-LAST:event_jTextFieldCountYFocusLost

    private void jCheckBoxPaintGridFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jCheckBoxPaintGridFocusLost
        doGrid();
    }//GEN-LAST:event_jCheckBoxPaintGridFocusLost

    private void jCheckBoxPaintGridActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxPaintGridActionPerformed
        doGrid();
    }//GEN-LAST:event_jCheckBoxPaintGridActionPerformed

    private void jTextFieldGapXFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldGapXFocusLost
        doGrid();
    }//GEN-LAST:event_jTextFieldGapXFocusLost

    double currentScale = 1;
    private void jSliderSourceScaleStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSourceScaleStateChanged
        if (inSetting>0) return;
        int value = jSliderSourceScale.getValue();
        double scale = value - 5;
        if (value <6)
        {
            int invScale = 7-value;
            scale = 1.0/invScale;
        }
        currentScale = scale;
        jLabel14.setText("Scale * "+scale);
        singleImagePanel1.setScale(scale);
        // jScrollPane2.getViewport().setView(singleImagePanel1);
    }//GEN-LAST:event_jSliderSourceScaleStateChanged

    private void singleImagePanel1MouseMoved(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_singleImagePanel1MouseMoved


        int x = ((int)((double)((double)evt.getX())/currentScale));
        int y = ((int)((double)((double)evt.getY())/currentScale));
//        int y = evt.getY()/((int)currentScale);
        jLabel21.setText(""+x +" / "+y);
        jLabel23.setText(""+singleImagePanel1.selWidth +" / "+singleImagePanel1.selHeight);
    }//GEN-LAST:event_singleImagePanel1MouseMoved

    private void singleImagePanel1MouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_singleImagePanel1MouseDragged

        int x = ((int)((double)((double)evt.getX())/currentScale));
        int y = ((int)((double)((double)evt.getY())/currentScale));
        jLabel21.setText(""+x +" / "+y);
        jLabel23.setText(""+singleImagePanel1.selWidth +" / "+singleImagePanel1.selHeight);
        currentBase = singleImagePanel1.getSelection();
        currentBase.notice = currentNotice;
        jTextFieldPosY.setText(""+currentBase.y);
        jTextFieldPosX.setText(""+currentBase.x);
        jTextFieldWidth.setText(""+currentBase.w);
        jTextFieldHeight.setText(""+currentBase.h);
        jTextFieldPosYCrop.setText(""+currentBase.y);
        jTextFieldPosXCrop.setText(""+currentBase.x);
        jTextFieldWidthCrop.setText(""+currentBase.w);
        jTextFieldHeightCrop.setText(""+currentBase.h);
        jTextFieldPosXCrop.setText(""+0);
        jTextFieldPosYCrop.setText(""+0);
        jTextFieldPosXOpt.setText(""+0);
        jTextFieldPosYOpt.setText(""+0);
        
        if ((mData.size() > 0) && (currentSelectedNo<mData.size()) && (currentSelectedNo!=-1))
        {
            jTextFieldWidthCrop.setText(""+mData.elementAt(currentSelectedNo).cw);
            jTextFieldHeightCrop.setText(""+mData.elementAt(currentSelectedNo).ch);
        }

        ImageCache.getImageCache().setCacheActive(false);
        if (previewScale)
            singleImagePanel2.setBaseImage(currentBase.image, singleImagePanel2.getWidth(),singleImagePanel2.getHeight());
        else
            singleImagePanel2.setBaseImage(currentBase.image);

        singleImagePanel2.setOffset(currentBase.ox, currentBase.oy, jCheckBoxPreviewOffset.isSelected());
        ImageCache.getImageCache().setCacheActive(true);

        jCheckBoxPaintSelectionActionPerformed(null);
    }//GEN-LAST:event_singleImagePanel1MouseDragged

    private void jButtonChangeColorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonChangeColorActionPerformed
        if (currentBase == null) return;
        singleImagePanel1.replaceColorToBackground(
                UtilityString.Int0(jTextFieldColorR.getText()),
                UtilityString.Int0(jTextFieldColorG.getText()),
                UtilityString.Int0(jTextFieldColorB.getText()),
                UtilityString.Int0(jTextFieldColorA.getText())
                );
        currentBase.fileName="";
    }//GEN-LAST:event_jButtonChangeColorActionPerformed

    private void jButtonSaveImageGraphicsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveImageGraphicsActionPerformed
        singleImagePanel1.saveSourceImage();
        mCloneData = null;
    }//GEN-LAST:event_jButtonSaveImageGraphicsActionPerformed

    private void jButtonSaveImageGraphics1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveImageGraphics1ActionPerformed
        singleImagePanel1.saveSourceImage(singleImagePanel1.getOrgName()+".new.png");
        mCloneData = null;
    }//GEN-LAST:event_jButtonSaveImageGraphics1ActionPerformed

    private void jButtonSaveAnimImageActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveAnimImageActionPerformed

        if (!getPool()) {
            return;
        }
        readAllToCurrent();
        //String currentKey = jTextFieldName.getText();

        String filename;
        Configuration C = Configuration.getConfiguration();
        if (C.getMainFrame() == null) {
            return;
        }
        CanSaveAsOneDialog ac = new CanSaveAsOneDialog();
        ModalInternalFrame modal = new ModalInternalFrame("Save as new image?", C.getMainFrame().getRootPane(), C.getMainFrame(), ac);
        ac.setDialog(modal);
        modal.setVisible(true);

        
        filename = ac.getFilename();
        saveAnimationAsOneImageIntern(filename);
    }
    public void saveAnimationAsOneImageIntern(String filename)
    {

        if (filename.length() != 0)
        {
            /*
            Vector <BaseImageData> allImages = readAllToCurrentISE();
            String path = "";
            if (allImages.size()>0)
            {
                String file = allImages.elementAt(0).fileName;
                path = UtilityString.getPath(file);
            }
            */
            filename = "images"+File.separator+ filename+".png";
            jTextFieldImageSource.setText(filename);
            
            //saveNewImage(path+filename + ".png");
            saveNewImage(filename);
            
            BaseImageData.fromBase(mISData, mData);
            refreshCollection();
        }
        mCloneData = null;
    }//GEN-LAST:event_jButtonSaveAnimImageActionPerformed

    private void jButtonSaveClassAsImageActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveClassAsImageActionPerformed

        if (!getPool()) {
            return;
        }
        readAllToCurrent();
        Configuration C = Configuration.getConfiguration();
        if (C.getMainFrame() == null) {
            return;
        }
        MustSaveAsOneDialog ac = new MustSaveAsOneDialog();
        ModalInternalFrame modal = new ModalInternalFrame("Save as new image!", C.getMainFrame().getRootPane(), C.getMainFrame(), ac);
        ac.setDialog(modal);
        modal.setVisible(true);
        String filename = ac.getFilename();
        if (filename.length() == 0)
        {
            return;
        }
        saveClassImagesAsOne(filename);
        

    }//GEN-LAST:event_jButtonSaveClassAsImageActionPerformed

    private void saveClassImagesAsOne(String filename)
    {
        
        filename = "images"+File.separator+ filename+".png";

        // save all of selected class in pool
        Collection<ImageSequenceData> collectionName = mImageSequenceDataPool.getMapForKlasse(jTextFieldKlasse.getText()).values();
        Iterator<ImageSequenceData> iterN = collectionName.iterator();
        /** Sorting */  Vector<String> nnames = new Vector<String>(); while (iterN.hasNext()) nnames.addElement(iterN.next().mName); Collections.sort(nnames, new Comparator<String>() {@Override
            public int compare(String s1, String s2) { return s1.compareTo(s2); } });

        int rowPos=0;
        int rowWidth;
        int rowWidthMax = 0;
        int columnAllHeight;
        int currentMaxHeight = 0;
        int gap = 1;
        int rectangleWidth=2;
        if (jCheckBoxJustImages.isSelected())
        {
            gap = 0;
            rectangleWidth=0;
        }

        int allGap = gap + rectangleWidth;

        rowWidth = 0;
        columnAllHeight = 0;

        boolean newRow = false;
        for (int j = 0; j < nnames.size(); j++)
        {
            String name = nnames.elementAt(j);
            ImageSequenceData iSData = mImageSequenceDataPool.get(name);
            Vector <BaseImageData> allImages = BaseImageData.toBase(iSData);

            for (int i = 0; i < allImages.size(); i++)
            {
                BaseImageData baseImageData = allImages.elementAt(i);
                BufferedImage im = baseImageData.image;
                if ((rowPos != 0) &&  (rowWidth + im.getWidth()+allGap > MAX_ROW_WIDTH)) newRow=true;

                if (newRow)
                {
                    columnAllHeight+= currentMaxHeight+allGap;
                    if (rowWidth >rowWidthMax) rowWidthMax =rowWidth;
                    rowWidth = 0;
                    currentMaxHeight = 0;
                    rowPos=0;
                    newRow = false;
                }
                rowPos++;
                rowWidth+=im.getWidth()+allGap;
                if (im.getHeight()>currentMaxHeight) currentMaxHeight=im.getHeight();
            }
        }
        columnAllHeight+= currentMaxHeight+allGap;
        if (rowWidth >rowWidthMax) rowWidthMax =rowWidth;
        int type = BufferedImage.TYPE_INT_ARGB;
        int w = rowWidthMax;
        int h = columnAllHeight;
        if ((w==0) || (h==0)) return;
        BufferedImage dimg = new BufferedImage(w, h, type);
        Graphics2D g = dimg.createGraphics();

        rowPos=0;
        rowWidthMax = 0;
        currentMaxHeight = 0;

        rowWidth = 0;
        columnAllHeight = 0;

        newRow = false;
        for (int j = 0; j < nnames.size(); j++)
        {
            String name = nnames.elementAt(j);
            ImageSequenceData iSData = mImageSequenceDataPool.get(name);
            Vector <BaseImageData> allImages = BaseImageData.toBase(iSData);

            for (int i = 0; i < allImages.size(); i++)
            {
                BaseImageData baseImageData = allImages.elementAt(i);
                BufferedImage im = baseImageData.image;
                if ((rowPos != 0) &&  (rowWidth + im.getWidth()+allGap > MAX_ROW_WIDTH)) newRow=true;

                if (newRow)
                {
                    columnAllHeight+= currentMaxHeight+allGap;
                    if (rowWidth >rowWidthMax) rowWidthMax =rowWidth;
                    rowWidth = 0;
                    currentMaxHeight = 0;
                    rowPos=0;
                    newRow = false;
                }
                rowPos++;

                if (!jCheckBoxJustImages.isSelected())
                {
                    g.setColor(Color.red);
                    g.drawRect(rowWidth, columnAllHeight, im.getWidth()+rectangleWidth-1, im.getHeight()+rectangleWidth-1);
                }
                rowWidth += rectangleWidth/2;
                g.drawImage(im, null, rowWidth, columnAllHeight+rectangleWidth/2);

                baseImageData.fileName=filename;
                baseImageData.x=rowWidth;
                baseImageData.y=columnAllHeight+rectangleWidth/2;
            baseImageData.xOrg=rowWidth;
            baseImageData.yOrg=columnAllHeight+rectangleWidth/2;
                baseImageData.h=im.getHeight();
                baseImageData.w=im.getWidth();
                baseImageData.notice = currentNotice;

                rowWidth += rectangleWidth/2;
                rowWidth += gap;
                rowWidth+=im.getWidth();

                if (im.getHeight()>currentMaxHeight) currentMaxHeight=im.getHeight();
            }
            BaseImageData.fromBase(iSData, allImages);
        }

        try
        {
            File outputfile = new File(filename);
            ImageIO.write(dimg, "png", outputfile);
            mImageSequenceDataPool.save();
        }
        catch (IOException e)
        {
        }
        BaseImageData.fromBase(mISData, mData);
        mCloneData = null;
        refreshCollection();
    }
    
    
    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        String oldText;
        if (mISData!=null)
            oldText = mISData.mOriginNotice;
        else
            oldText = currentNotice;

        currentNotice = OriginJPanel.showOrigin(oldText);
        if (mISData!=null)
            mISData.mOriginNotice = currentNotice;
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButtonCropImageActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCropImageActionPerformed

        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            baseImageData.calculateCrop();
        }
        if (currentSelectedNo == -1)
        {
            jTextFieldPosXCrop.setText("");
            jTextFieldPosYCrop.setText("");
            jTextFieldWidthCrop.setText("");
            jTextFieldHeightCrop.setText("");

            jTextFieldPosXOpt.setText("");
            jTextFieldPosYOpt.setText("");
            return;
        }
        jTextFieldPosXCrop.setText(""+mData.elementAt(currentSelectedNo).cx);
        jTextFieldPosYCrop.setText(""+mData.elementAt(currentSelectedNo).cy);
        jTextFieldWidthCrop.setText(""+mData.elementAt(currentSelectedNo).cw);
        jTextFieldHeightCrop.setText(""+mData.elementAt(currentSelectedNo).ch);
        jTextFieldPosXOpt.setText(""+mData.elementAt(currentSelectedNo).ox);
        jTextFieldPosYOpt.setText(""+mData.elementAt(currentSelectedNo).oy);

    }//GEN-LAST:event_jButtonCropImageActionPerformed

    private void jButtonApplyCropActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonApplyCropActionPerformed

        // single image is allways a full featured Crop!
        mCloneData = null;
        if (mData.size() == 1)
        {
            if (!jCheckBoxKeepOffset.isSelected())
            {
                BaseImageData baseImageData = mData.elementAt(0);
                baseImageData.applySimpleCrop();
            }
            else
            {
                // with offset
                BaseImageData baseImageData = mData.elementAt(0);
                baseImageData.applyOffsetCrop();
            }
            updateToSelectedPanel();
            refreshCollection(false, true);
            return;
        }


        // from here on only animations

        boolean allSameCrop = true;
        // check if

        int cx=-1;
        int cy=-1;
        int cw=-1;
        int ch=-1;
        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            if (cx==-1)
            {
                cx=baseImageData.cx;
                cy=baseImageData.cy;
                cw=baseImageData.cw;
                ch=baseImageData.ch;
            }
            else
            {
                if (cx != baseImageData.cx) allSameCrop=false;
                if (cy != baseImageData.cy) allSameCrop=false;
                if (cw != baseImageData.cw) allSameCrop=false;
                if (ch != baseImageData.ch) allSameCrop=false;
            }
            if (!allSameCrop) break;
        }

        if (allSameCrop)
        {
            if (!jCheckBoxKeepOffset.isSelected())
            {
                for (int i = 0; i < mData.size(); i++)
                {
                    BaseImageData baseImageData = mData.elementAt(i);
                    baseImageData.applySimpleCrop();
                }
            }
            else
            {
                // with offset
                for (int i = 0; i < mData.size(); i++)
                {
                    BaseImageData baseImageData = mData.elementAt(i);
                    baseImageData.applyOffsetCrop();
                }
            }
            updateToSelectedPanel();
            refreshCollection(false, true);
            return;
        }

        // all (maybe all) different crops
        if (jCheckBoxKeepOffset.isSelected())
        {
            // keep offset allways
            for (int i = 0; i < mData.size(); i++)
            {
                BaseImageData baseImageData = mData.elementAt(i);
                baseImageData.applyOffsetCrop();
            }
        }
        else
        {
            if (jCheckBoxinternalOffset.isSelected())
            {
                // calculate best value offset
                // and use the best offset as base for all

                cx=-1;
                cy=-1;
                int cEndX=-1;
                int cEndY=-1;
                for (int i = 0; i < mData.size(); i++)
                {
                    BaseImageData baseImageData = mData.elementAt(i);
                    if (cx==-1)
                    {
                        cx=baseImageData.cx;
                        cy=baseImageData.cy;
                        cEndX = baseImageData.cw + cx;
                        cEndY = baseImageData.ch + cy;
                    }
                    else
                    {
                        if (cx > baseImageData.cx)
                            cx=baseImageData.cx;
                        if (cy > baseImageData.cy)
                            cy=baseImageData.cy;
                        if (cEndX < baseImageData.cw + baseImageData.cx)
                            cEndX=baseImageData.cw + baseImageData.cx;
                        if (cEndY < baseImageData.ch + baseImageData.cy)
                            cEndY=baseImageData.ch + baseImageData.cy;
                    }
                }
                cw = cEndX - cx;
                ch = cEndY - cy;
                for (int i = 0; i < mData.size(); i++)
                {
                    BaseImageData baseImageData = mData.elementAt(i);
                    baseImageData.cx = cx;
                    baseImageData.cy = cy;
                    baseImageData.cw = cw;
                    baseImageData.ch = ch;
System.out.println("Crop #:"+i);                    
                    baseImageData.applySimpleCrop();
                }
                // now all images are croped to all best off all anim

                jButtonCropImageActionPerformed(null);
                for (int i = 0; i < mData.size(); i++)
                {
                    BaseImageData baseImageData = mData.elementAt(i);
                    baseImageData.applyOffsetCrop();
                }

            }
            else
            {
                // keep never offset for whole animation
                for (int i = 0; i < mData.size(); i++)
                {
                    BaseImageData baseImageData = mData.elementAt(i);
                    baseImageData.applySimpleCrop();
                }
            }
        }
        updateToSelectedPanel();
        refreshCollection(false, true);
    }//GEN-LAST:event_jButtonApplyCropActionPerformed

    private void jCheckBoxPaintSelectionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxPaintSelectionActionPerformed

        if (jCheckBoxPaintSelection.isSelected())
        {
            singleImagePanel1.setSelection(
                        UtilityString.Int0(jTextFieldPosX.getText()),
                        UtilityString.Int0(jTextFieldPosY.getText()),
                        UtilityString.Int0(jTextFieldWidth.getText())-1,
                        UtilityString.Int0(jTextFieldHeight.getText())-1);
        }
        else
        {
            singleImagePanel1.setSelection(-1,-1,-1,-1);
        }
    }//GEN-LAST:event_jCheckBoxPaintSelectionActionPerformed

    private void jCheckBoxPaintSelectionFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jCheckBoxPaintSelectionFocusLost
       
    }//GEN-LAST:event_jCheckBoxPaintSelectionFocusLost

    private void jButtonMirrorAllActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonMirrorAllActionPerformed

        boolean anim = jToggleButtonPlayAnim.isSelected();
        mCloneData = null;
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        int angle = getI(jTextFieldAngle);
        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            BufferedImage bimage = baseImageData.image;
            if (bimage == null) continue;

            BufferedImage dimg = ImageCache.getImageCache().getDerivatMirror(bimage, jCheckBoxVerticalMirror.isSelected());

            baseImageData.image = dimg;
            baseImageData.xOrg = 0;
            baseImageData.yOrg = 0;
            baseImageData.x = 0;
            baseImageData.y = 0;
            baseImageData.h = dimg.getHeight();
            baseImageData.w = dimg.getWidth();
            baseImageData.notice = currentNotice;
            baseImageData.fileName="";

            if (baseImageData.cpanel != null)
            {
                removeAllSubListeners(baseImageData.cpanel);
                baseImageData.cpanel.removeAll();
                SingleImagePanel sip = new SingleImagePanel();
                baseImageData.cpanel.add(sip, BorderLayout.CENTER);
                sip.setBaseImage(baseImageData.image, 50, 50);

                sip.addMouseListener(new java.awt.event.MouseAdapter() {
                    @Override
                    public void mousePressed(java.awt.event.MouseEvent evt) {
                        jPanelMouseClickedHorizontal(evt);
                    }
                });
            }
        }
        newImages = true;
        refreshCollection();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }


    }//GEN-LAST:event_jButtonMirrorAllActionPerformed

    private void jCheckBoxAnimationOffsetActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxAnimationOffsetActionPerformed

        imageComponent1.setUseOffsets(jCheckBoxAnimationOffset.isSelected());
    }//GEN-LAST:event_jCheckBoxAnimationOffsetActionPerformed

    private void jCheckBoxPreviewOffsetActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxPreviewOffsetActionPerformed
        if ((currentSelectedNo<0) || (mData.size()==0) ||(currentSelectedNo>=mData.size()) ) return;
        singleImagePanel2.setOffset(mData.elementAt(currentSelectedNo).ox, mData.elementAt(currentSelectedNo).oy, jCheckBoxPreviewOffset.isSelected());
    }//GEN-LAST:event_jCheckBoxPreviewOffsetActionPerformed

    private void jButtonExportActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonExportActionPerformed

        String klasse = jTextFieldKlasse.getText().trim();
        if (klasse.length()==0)
        {
            ExportFrame exportFrame = new ExportFrame(this);
            exportFrame.setVisible(true);
            return;
        }

        Collection<ImageSequenceData> collectionName = mImageSequenceDataPool.getMapForKlasse(klasse).values();
        //Iterator<ImageSequenceData> iterN = collectionName.iterator();

        ExportFrame exportFrame = new ExportFrame(collectionName);

        exportFrame.setVisible(true);


    }//GEN-LAST:event_jButtonExportActionPerformed

    private void jButtonResetActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonResetActionPerformed
        re_set();
    }//GEN-LAST:event_jButtonResetActionPerformed

    private void jTextFieldPosXFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldPosXFocusLost
        doGrid();
        jCheckBoxPaintSelectionActionPerformed(null);
    }//GEN-LAST:event_jTextFieldPosXFocusLost

    private void jTextFieldPosYFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldPosYFocusLost
        doGrid();
        jCheckBoxPaintSelectionActionPerformed(null);
    }//GEN-LAST:event_jTextFieldPosYFocusLost

    private void jButtonSaveClassSingleImagesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveClassSingleImagesActionPerformed

        if (!getPool()) {
            return;
        }
        readAllToCurrent();
        Configuration C = Configuration.getConfiguration();
        if (C.getMainFrame() == null) {
            return;
        }

        mCloneData = null;

        // save all of selected class in pool
        Collection<ImageSequenceData> collectionName = mImageSequenceDataPool.getMapForKlasse(jTextFieldKlasse.getText()).values();
        Iterator<ImageSequenceData> iterN = collectionName.iterator();
        /** Sorting */  Vector<String> nnames = new Vector<String>(); while (iterN.hasNext()) nnames.addElement(iterN.next().mName); Collections.sort(nnames, new Comparator<String>() {@Override
            public int compare(String s1, String s2) { return s1.compareTo(s2); } });

        int gap = 1;
        int rectangleWidth=2;

        if (jCheckBoxJustImages.isSelected())
        {
            gap = 0;
            rectangleWidth=0;
        }
        int allGap = gap + rectangleWidth;
        int type = BufferedImage.TYPE_INT_ARGB;

        for (int j = 0; j < nnames.size(); j++)
        {
            String name = nnames.elementAt(j);
            String filename = "images"+File.separator+ name+".png";
            ImageSequenceData iSData = mImageSequenceDataPool.get(name);
            Vector <BaseImageData> allImages = BaseImageData.toBase(iSData);

            int width=0;
            int height=0;
            for (int i = 0; i < allImages.size(); i++)
            {
                BaseImageData baseImageData = allImages.elementAt(i);
                BufferedImage im = baseImageData.image;
                if (im == null) continue;
                width += im.getWidth() + allGap;
                if (height < im.getHeight() + allGap)
                    height = im.getHeight() + allGap;
            }
            BufferedImage dimg = new BufferedImage(width, height, type);
            Graphics2D g = dimg.createGraphics();

            int x=0;
            int y=0;
            for (int i = 0; i < allImages.size(); i++)
            {
                BaseImageData baseImageData = allImages.elementAt(i);
                BufferedImage im = baseImageData.image;
                g.setColor(Color.red);
                if (!jCheckBoxJustImages.isSelected())
                    g.drawRect(x, y, im.getWidth()+rectangleWidth-1, im.getHeight()+rectangleWidth-1);

                x += rectangleWidth/2;
                g.drawImage(im, null, x, y + rectangleWidth/2);

                baseImageData.fileName=filename;
                baseImageData.xOrg = x;
                baseImageData.yOrg = y+rectangleWidth/2;
                baseImageData.x=x;
                baseImageData.y=y + rectangleWidth/2;
                baseImageData.h=im.getHeight();
                baseImageData.w=im.getWidth();
                baseImageData.notice = currentNotice;

                x += rectangleWidth/2;
                x += gap;
                x+=im.getWidth();

            }

            try
            {
                File outputfile = new File(filename);
                ImageIO.write(dimg, "png", outputfile);
            }
            catch (IOException e)
            {
            }
            BaseImageData.fromBase(iSData, allImages);
        }

        mImageSequenceDataPool.save();
        BaseImageData.fromBase(mISData, mData);
        refreshCollection();
        
        ShowInfoDialog.showInfoDialog("Images were saved!");
                


    }//GEN-LAST:event_jButtonSaveClassSingleImagesActionPerformed

    private void jButtonFileSelect2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect2ActionPerformed

/*        
        
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setMultiSelectionEnabled(true);
        if (lastImagePath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File("."));
            fc.setCurrentDirectory(new java.io.File("images"));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastImagePath));
        }
        FileNameExtensionFilter  filter = new  FileNameExtensionFilter("Images", "jpg", "jpeg", "png", "bmp", "gif");
        fc.setFileFilter(filter);
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        
*/        
        
        

        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setCurrentDirectory(new java.io.File("."));
        fc.setCurrentDirectory(new java.io.File("xml"+File.separator+"Graphics"));
//        fc.setCurrentDirectory(new java.io.File("Graphics"));
        FileNameExtensionFilter filter = new FileNameExtensionFilter("xml", "xml");
        fc.setFileFilter(filter);
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) {
            return;
        }
        String name = fc.getSelectedFile().getName();
        jTextField1.setText(de.malban.util.UtilityString.replace(name, ".xml", ""));

        getFilterPool();
        resetFilterPool(false, "");
    }//GEN-LAST:event_jButtonFileSelect2ActionPerformed

    private void jComboBoxKlasse1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxKlasse1ActionPerformed

        if (mClassSetting > 0) {
            return;
        }
        if (!getFilterPool()) {
            return;
        }
        if (jComboBoxKlasse1.getSelectedIndex()==-1) return;
        mClassSetting++;

        String selected = jComboBoxKlasse1.getSelectedItem().toString();
        resetFilterPool(true, selected);
        mClassSetting--;
    }//GEN-LAST:event_jComboBoxKlasse1ActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        String help = "";
        help += "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"> ";
        help += "<html> <head>   ";
        help += "<title></title> </head>";
        help += "<body> <h3>Rotating</h3>Please note, that rotating an animation with different sized images,<br> may lead to undesireable results, ";
        help += "<br>since the size of each rotated image is calculated on its own!";
        help += "<br><br>This may lead to even stranger results if combinded with the crop-feature!";
        help += "</body>";
        help += "</html>";
        QuickHelpModal.showHelpHtml(help);    }//GEN-LAST:event_jButton5ActionPerformed

    private void jButtonBuiltArtifactFilterActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonBuiltArtifactFilterActionPerformed
        // build 32 from three
        // first is vertical on the left

        // build 4 straight!

        // rotate 3 time each 90 degrees without size change

        if (mData.size()<3) return;

        BaseImageData baseImageData = mData.elementAt(0);

        BaseImageData biDataLine90 =     baseImageData.copy();
        BufferedImage bimage = biDataLine90.image;

        if (bimage == null) return;
        BufferedImage dimg = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);
        biDataLine90.image = dimg;
        biDataLine90.cpanel = null;
        biDataLine90.x = 0;
        biDataLine90.y = 0;
        biDataLine90.notice = currentNotice;
        biDataLine90.fileName="";

        BaseImageData biDataLine180 = biDataLine90.copy();
        bimage = biDataLine180.image;
        biDataLine180.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        BaseImageData biDataLine270 = biDataLine180.copy();
        bimage = biDataLine270.image;
        biDataLine270.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        BaseImageData biDataLine2Vertical = biDataLine180.copy();
        //biDataLine2Vertical.image = joinHalfHorizontal(baseImageData.image, biDataLine180.image);
        biDataLine2Vertical.image = joinBrighterPixels(baseImageData.image, biDataLine180.image);
        BaseImageData biDataLine2Horizontal = biDataLine180.copy();
        //biDataLine2Horizontal.image = joinHalfVertical(biDataLine90.image, biDataLine270.image);
        biDataLine2Horizontal.image = joinBrighterPixels(biDataLine90.image, biDataLine270.image);

        BaseImageData biDataLineCornerWN = biDataLine180.copy();
        biDataLineCornerWN.image = joinBrighterPixels(baseImageData.image, biDataLine90.image);

        BaseImageData biDataLineCornerEN = biDataLine180.copy();
        biDataLineCornerEN.image = joinBrighterPixels(biDataLine180.image, biDataLine90.image);

        BaseImageData biDataLineCornerSW = biDataLine180.copy();
        biDataLineCornerSW.image = joinBrighterPixels(baseImageData.image, biDataLine270.image);

        BaseImageData biDataLineCornerES = biDataLine180.copy();
        biDataLineCornerES.image = joinBrighterPixels(biDataLine180.image, biDataLine270.image);

        mData.add(biDataLine90);
        mData.add(biDataLine180);
        mData.add(biDataLine270);
        mData.add(biDataLine2Vertical);
        mData.add(biDataLine2Horizontal);


        BaseImageData allCorners = mData.elementAt(1);

        biDataLineCornerWN.image = joinBrighterPixelsNW(biDataLineCornerWN.image, allCorners.image);
        biDataLineCornerEN.image = joinBrighterPixelsNE(biDataLineCornerEN.image, allCorners.image);
        biDataLineCornerSW.image = joinBrighterPixelsSW(biDataLineCornerSW.image, allCorners.image);
        biDataLineCornerES.image = joinBrighterPixelsSE(biDataLineCornerES.image, allCorners.image);

        mData.add(biDataLineCornerWN);
        mData.add(biDataLineCornerEN);
        mData.add(biDataLineCornerSW);
        mData.add(biDataLineCornerES);

        BaseImageData U_N = biDataLineCornerES.copy();
        U_N.image = joinBrighterPixels(U_N.image, biDataLineCornerSW.image);
        BaseImageData U_S = biDataLineCornerEN.copy();
        U_S.image = joinBrighterPixels(U_S.image, biDataLineCornerWN.image);

        BaseImageData U_E = biDataLineCornerWN.copy();
        U_E.image = joinBrighterPixels(U_E.image, biDataLineCornerSW.image);
        BaseImageData U_W = biDataLineCornerEN.copy();
        U_W.image = joinBrighterPixels(U_W.image, biDataLineCornerES.image);

        mData.add(U_N);
        mData.add(U_S);
        mData.add(U_E);
        mData.add(U_W);

        BaseImageData cornerNW = mData.elementAt(2);
        BaseImageData cornerNE = cornerNW.copy();
        bimage = cornerNE.image;

        dimg = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);
        cornerNE.image = dimg;
        cornerNE.cpanel = null;
        cornerNE.x = 0;
        cornerNE.y = 0;
        cornerNE.notice = currentNotice;
        cornerNE.fileName="";

        BaseImageData cornerSE = cornerNE.copy();
        bimage = cornerSE.image;
        cornerSE.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        BaseImageData cornerSW = cornerSE.copy();
        bimage = cornerSW.image;
        cornerSW.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        mData.add(cornerNE);
        mData.add(cornerSE);
        mData.add(cornerSW);

        BaseImageData cornerNE_NW = cornerNE.copy();
        cornerNE_NW.image = joinBrighterPixels(cornerNE_NW.image, cornerNW.image);

        BaseImageData cornerSE_SW = cornerSE.copy();
        cornerSE_SW.image = joinBrighterPixels(cornerSE_SW.image, cornerSW.image);

        BaseImageData cornerNE_SE = cornerNE.copy();
        cornerNE_SE.image = joinBrighterPixels(cornerNE_SE.image, cornerSE.image);

        BaseImageData cornerNW_SW = cornerSW.copy();
        cornerNW_SW.image = joinBrighterPixels(cornerNW_SW.image, cornerNW.image);

        BaseImageData cornerNE_SW = cornerNE.copy();
        cornerNE_SW.image = joinBrighterPixels(cornerNE_SW.image, cornerSW.image);

        BaseImageData cornerNW_SE = cornerNW.copy();
        cornerNW_SE.image = joinBrighterPixels(cornerNW_SE.image, cornerSE.image);

        mData.add(cornerNE_NW);
        mData.add(cornerSE_SW);
        mData.add(cornerNE_SE);
        mData.add(cornerNW_SW);
        mData.add(cornerNE_SW);
        mData.add(cornerNW_SE);

        BaseImageData cornerNE_NW_SE = cornerNE_NW.copy();
        cornerNE_NW_SE.image = joinBrighterPixels(cornerNE_NW_SE.image, cornerSE.image);

        BaseImageData cornerSE_SW_NE = cornerSE_SW.copy();
        cornerSE_SW_NE.image = joinBrighterPixels(cornerSE_SW_NE.image, cornerNE.image);

        BaseImageData cornerNE_NW_SW = cornerNE_NW.copy();
        cornerNE_NW_SW.image = joinBrighterPixels(cornerNE_NW_SW.image, cornerSW.image);

        BaseImageData cornerSE_SW_NW = cornerSE_SW.copy();
        cornerSE_SW_NW.image = joinBrighterPixels(cornerSE_SW_NW.image, cornerNW.image);

        mData.add(cornerNE_NW_SE);
        mData.add(cornerSE_SW_NE);
        mData.add(cornerNE_NW_SW);
        mData.add(cornerSE_SW_NW);

        BaseImageData cornerSE_SW_NW_NE = cornerSE_SW_NW.copy();
        cornerSE_SW_NW_NE.image = joinBrighterPixels(cornerSE_SW_NW_NE.image, cornerNE.image);

        mData.add(cornerSE_SW_NW_NE);


        currentBase = biDataLine2Horizontal;
        // test new images , add to display and watch!

        refreshCollection();


        newImages = true;
        refreshCollection();
        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        mCloneData = null;
        
    }//GEN-LAST:event_jButtonBuiltArtifactFilterActionPerformed

    private void jButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton7ActionPerformed


         // build 32 from three
        // first is vertical on the left

        // build 4 straight!

        // rotate 3 time each 90 degrees without size change

        if (mData.size()<4) return;


        // THREE
        BaseImageData baseImageData = mData.elementAt(0);

        BaseImageData biDataLine90 =     baseImageData.copy();
        BufferedImage bimage = biDataLine90.image;

        if (bimage == null) return;
        BufferedImage dimg = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);
        biDataLine90.image = dimg;
        biDataLine90.cpanel = null;
        biDataLine90.x = 0;
        biDataLine90.y = 0;
        biDataLine90.notice = currentNotice;
        biDataLine90.fileName="";

        BaseImageData biDataLine180 = biDataLine90.copy();
        bimage = biDataLine180.image;
        biDataLine180.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        BaseImageData biDataLine270 = biDataLine180.copy();
        bimage = biDataLine270.image;
        biDataLine270.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        mData.add(biDataLine90);
        mData.add(biDataLine180);
        mData.add(biDataLine270);

        // TWO
        // North
        BaseImageData NW_N = mData.elementAt(3);

        BaseImageData NE_N = NW_N.copy();
        bimage = NE_N.image;
        NE_N.cpanel = null;
        NE_N.x = 0;
        NE_N.y = 0;
        NE_N.notice = currentNotice;
        NE_N.fileName="";

        dimg = ImageCache.getImageCache().getDerivatMirror(bimage, false);
        NE_N.image = dimg;

        // East
        BaseImageData NE_E = NE_N.copy();
        bimage = NW_N.image; // extra westen!
        NE_E.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        BaseImageData SE_E = NE_N.copy();
        bimage = SE_E.image;
        SE_E.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        // South
        BaseImageData SE_S = NE_E.copy();
        bimage = SE_S.image; // extra westen!
        SE_S.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        BaseImageData SW_S = SE_E.copy();
        bimage = SW_S.image;
        SW_S.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        // West
        BaseImageData SW_W = SE_S.copy();
        bimage = SW_W.image; // extra westen!
        SW_W.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        BaseImageData NW_W = SW_S.copy();
        bimage = NW_W.image;
        NW_W.image = ImageCache.getImageCache().getDerivatRotate(bimage, 90, true);

        mData.add(NE_N);
        mData.add(NE_E);
        mData.add(SE_E);
        mData.add(SE_S);
        mData.add(SW_S);
        mData.add(SW_W);
        mData.add(NW_W);



        

        refreshCollection();


        newImages = true;
        refreshCollection();
        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        mCloneData = null;
    }//GEN-LAST:event_jButton7ActionPerformed

    private void jButton8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton8ActionPerformed
        String help = "";
        help += "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"> ";
        help += "<html> <head>   ";
        help += "<title></title> </head>";
        help += "<body> <h3>Filters</h3>Filters by convention are build like:<br>";
        help += "<ol>";
        help += "<li>filter color is BLACK (0,0,0)</li>";
        help += "<li>filtered is by alpha channel, 0 means filtered 'away', 255 means all stays the same, in between -> transparent</li>";
        help += "<li>all other colors (than black) are applied to source tile</li>";
        help += "</ol>";
        help += "</body>";
        help += "</html>";
        QuickHelpModal.showHelpHtml(help);
    }//GEN-LAST:event_jButton8ActionPerformed

    private void jButtonApplyFilterActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonApplyFilterActionPerformed
       //First get Images for Filter
        if (jComboBoxKlasse1.getSelectedIndex()==-1) return;
        if (jComboBox1.getSelectedIndex()==-1) return;

        String klasse =  jComboBoxKlasse1.getSelectedItem().toString();
        String name =  jComboBox1.getSelectedItem().toString();
        if (klasse.trim().length() == 0) return;
        if (name.trim().length() == 0) return;

        //mClassSetting++;



        ImageSequenceData iSData = mFilerDataPool.get(name);
        Vector <BaseImageData> data = BaseImageData.toBase(iSData);

        if (data.size()<=0) return; // mask must not have 0 images

        Vector<BufferedImage> filterImages = new Vector<BufferedImage>();
        for (int i = 0; i < data.size(); i++)
        {
            BaseImageData baseImageData = data.elementAt(i);
            if (baseImageData.image == null) continue;
            filterImages.addElement(baseImageData.image);
        }

        // get images for current graphic
        Vector<BufferedImage> sourceImages = new Vector<BufferedImage>();
        if (mData.size()<=0) return; // no grafix
        for (int i=0; i<mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            if (baseImageData.image == null) continue;
            sourceImages.addElement(baseImageData.image);
        }

        // apply all filters to all images
        Vector<BufferedImage> resultImages = new Vector<BufferedImage>();
        for (int s = 0; s < sourceImages.size(); s++)
        {
            BufferedImage sourceImage = sourceImages.elementAt(s);
            for (int f = 0; f < filterImages.size(); f++)
            {
                BufferedImage filterImage = filterImages.elementAt(f);
                BufferedImage resultImage = applyFilter(sourceImage,filterImage);
                resultImages.addElement(resultImage);
            }
        }

        // after apply all, add all
        for (int r = 0; r < resultImages.size(); r++)
        {
            BufferedImage resultImage = resultImages.elementAt(r);

            BaseImageData baseImageData = new BaseImageData();
            baseImageData.image = resultImage;
            baseImageData.cpanel = null;
            baseImageData.xOrg = 0;
            baseImageData.yOrg = 0;
            baseImageData.x = 0;
            baseImageData.y = 0;
            baseImageData.notice = currentNotice;
            baseImageData.fileName="";

            mData.add(baseImageData);
        }

        // done
        refreshCollection();

        newImages = true;
        refreshCollection();
        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        mCloneData = null;


    }//GEN-LAST:event_jButtonApplyFilterActionPerformed

    private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed

        CSAMainFrame frame = (CSAMainFrame) Global.mMainWindow;
        ColorReduceJPanel c = new ColorReduceJPanel();
        frame.addPanel(c);
        frame.setMainPanel(c);
        frame.windowMe(c,1018,680, "Color Reducer");

    }//GEN-LAST:event_jButton4ActionPerformed

    void resetClones()
    {
        mCloneData = null;
    }
    void ensureCurrentClone()
    {
        if (mCloneData != null) return;
        mCloneData = new  Vector <BaseImageData>();
        for (int i=0; i< mData.size(); i++)
        {
            BaseImageData data = mData.elementAt(i).clone();
            mCloneData.addElement(data);
        }

    }

    void doRGBHSBAdjust(boolean rgb)
    {
        ensureCurrentClone();
        
        boolean anim = jToggleButtonPlayAnim.isSelected();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }
        float r = ((Number) jSpinner4.getValue()).floatValue();
        float g = ((Number) jSpinner5.getValue()).floatValue();
        float b = ((Number) jSpinner6.getValue()).floatValue();

        float _h = ((Number) jSpinner1.getValue()).floatValue();
        float _s = ((Number) jSpinner2.getValue()).floatValue();
        float _b = ((Number) jSpinner3.getValue()).floatValue();
        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            BaseImageData clone = mCloneData.elementAt(i);
            
            baseImageData.image = ImageCache.getImageCache().getDerivatRGB(clone.image, r, g, b);
            baseImageData.image = ImageCache.getImageCache().getDerivatHSB(baseImageData.image, _h, _s, _b);

            baseImageData.fileName="";
            baseImageData.notice = currentNotice;
            if (baseImageData.cpanel != null)
            {
                removeAllSubListeners(baseImageData.cpanel);
                baseImageData.cpanel.removeAll();
                SingleImagePanel sip = new SingleImagePanel();
                baseImageData.cpanel.add(sip, BorderLayout.CENTER);
                sip.setBaseImage(baseImageData.image, 50, 50);

                sip.addMouseListener(new java.awt.event.MouseAdapter() {
                    @Override
                    public void mousePressed(java.awt.event.MouseEvent evt) {
                        jPanelMouseClickedHorizontal(evt);
                    }
                });
            }
        }
        newImages = true;
        refreshCollection();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }     
    }
    
    private void jSpinner4StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSpinner4StateChanged
        doRGBHSBAdjust(true);
    }//GEN-LAST:event_jSpinner4StateChanged

    private void jSpinner5StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSpinner5StateChanged
        doRGBHSBAdjust(true);
    }//GEN-LAST:event_jSpinner5StateChanged

    private void jSpinner6StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSpinner6StateChanged
        doRGBHSBAdjust(true);
    }//GEN-LAST:event_jSpinner6StateChanged

    private void jSpinner1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSpinner1StateChanged
        doRGBHSBAdjust(false);
    }//GEN-LAST:event_jSpinner1StateChanged

    private void jSpinner2StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSpinner2StateChanged
        doRGBHSBAdjust(false);
    }//GEN-LAST:event_jSpinner2StateChanged

    private void jSpinner3StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSpinner3StateChanged
        doRGBHSBAdjust(false);
    }//GEN-LAST:event_jSpinner3StateChanged

    private void jButtonSeamlessActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSeamlessActionPerformed
        
        // new image will have double width and double height
        
        boolean anim = jToggleButtonPlayAnim.isSelected();

        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(false);
            jToggleButtonPlayAnimActionPerformed(null);
        }

        int mDataOrgSize = mData.size();
        for (int i = 0; i < mDataOrgSize; i++)
        {
            BufferedImage bimage = mData.elementAt(i).image;
            if (bimage == null) continue;

            int h = bimage.getHeight();
            int w = bimage.getWidth();

        // first mirror
            BufferedImage mirror1 = ImageCache.getImageCache().getDerivatMirror(bimage, false); // horziontal mirror

            BufferedImage newImage1 = new BufferedImage(w+w, h, BufferedImage.TYPE_INT_ARGB);
            Graphics2D go = newImage1.createGraphics();
            
            go.drawImage(bimage, 0, 0, w, h, 0, 0, w, h, null);
            go.drawImage(mirror1, w, 0, w+w, h, 0, 0, w, h, null);
            BufferedImage mirror2 = ImageCache.getImageCache().getDerivatMirror(newImage1, true); // vertical mirror

            BufferedImage newImage2 = new BufferedImage(w+w, h+h, BufferedImage.TYPE_INT_ARGB);
            Graphics2D go2 = newImage2.createGraphics();
            
            go2.drawImage(newImage1, 0, 0, w+w, h, 0, 0, w+w, h, null);
            go2.drawImage(mirror2, 0, h, w+w, h+h, 0, 0, w+w, h, null);
            // in mirror2 there should now be a double sized tile which is a seamless one

            BaseImageData baseImageData = mData.elementAt(i).clone();
            
            baseImageData.image = newImage2;
            baseImageData.xOrg = 0;
            baseImageData.yOrg = 0;
            baseImageData.x = 0;
            baseImageData.y = 0;
            baseImageData.h = baseImageData.image.getHeight();
            baseImageData.w = baseImageData.image.getWidth();
            baseImageData.notice = currentNotice;
            baseImageData.fileName="";

            if (baseImageData.cpanel != null)
            {
                removeAllSubListeners(baseImageData.cpanel);
                baseImageData.cpanel.removeAll();
                SingleImagePanel sip = new SingleImagePanel();
                baseImageData.cpanel.add(sip, BorderLayout.CENTER);
                sip.setBaseImage(baseImageData.image, 50, 50);

                sip.addMouseListener(new java.awt.event.MouseAdapter() {
                    @Override
                    public void mousePressed(java.awt.event.MouseEvent evt) {
                        jPanelMouseClickedHorizontal(evt);
                    }
                });
            }
            mData.addElement(baseImageData);
        }
        newImages = true;
        refreshCollection();
        if (anim)
        {
            jToggleButtonPlayAnim.setSelected(true);
            jToggleButtonPlayAnimActionPerformed(null);
        }

        
    }//GEN-LAST:event_jButtonSeamlessActionPerformed

    File[] getFiles(String baseDir, String action, String direction)
    {
        Vector<File> vFiles = new Vector<File>();
    
        String fileName = baseDir/*+File.separator*/+action+" "+direction;
        if (action.length()==0)
             fileName = baseDir/*+File.separator*/+direction;
        int counter = -1;
        String stringCounter="";
        
        File f = new File("");
        do
        {
            counter++;
            stringCounter =  String.format( "%04d", counter ) ;
            if (direction.length()==0) stringCounter="";
            String fName = fileName.trim()+ stringCounter;
            fName+=".bmp";
            f = new File(fName);
            
System.out.print("Testing Filename:" +fName);            
            if (f.exists())
            {
                vFiles.addElement(f);
System.out.println(" -> found");            
            }
else System.out.println(" -> not found");            
            if (stringCounter.length()==0) break;
        }
        while (f.exists());
        
        
        return vFiles.toArray(new File[0]);
    }
    
    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed

        // imports all kinds of animations done by Reiner 
        
        // file name is taken from UI
        //String fileName = jTextFieldFile.getText();
       //String baseName = jTextFieldImageSource.getText(); 
       //String baseDir = de.malban.util.UtilityString.getPath(baseName);

       //if (fileName.length() == 0) return;
       
       // in these Subdirs under "images/Chars"
       // the animations will be sought
       String[] filesDirs={
            "axestan shield 96x bitmaps",
            
            "barbar bitmaps",
            "barbarian king bitmaps",
            "bat bitmaps",
            "black mage bitmaps 96x96",
            "black ninja sword bitmaps",
            "blackknight battlefield bitmaps",
            "blue archer bitmaps 96x96",
            "blueknight battlefield bitmaps",
            "brown wolf bitmaps",
            "caveman 96 bitmaps",
            "caveman club 96 bitmaps",
            "chicken 45 bitmaps",
            "cow blacknwhite bitmaps",
            "dark dwarf 96x bitmaps",
            "dark princess 96x bitmaps",
            "deer 96x bitmaps",
            "devil bitmaps",
            "dino green bitmaps",
            "dino red bitmaps",
            "donkey bitmaps",
            "elsa bitmaps",
            "fairy bitmaps",
            "firedragon bitmaps ground",
            "floating skull bitmaps",
            "floating skull dark bitmaps",
            "floating skull green bitmaps",
            "flying soul blonde bitmaps",
            "flying soul brown bitmaps",
            "freya axe bitmaps",
            "freya noarms bitmaps",
            "ghost bitmaps",
            "green archer bitmaps 96x96",
            "green dragonfly bitmaps",
            "green dwarf 96x bitmaps",
            "green knight battlefield bitmaps",
            "green swordsman bitmaps",
            "green zombie bitmaps",
            "greenGnome",
            "grey caveman 96X bitmaps",
            "grey troll bitmaps",
            "grey wolf  bitmaps",
            "groggystars bitmaps",
            "hammerwilly bitmaps",
            "horseriding knight 144x bitmaps",
            "hunter 96x bitmaps",
            "ice troll bitmaps",
            "john doe bitmaps96x96",
            "jumping fish bitmaps",
            "koenig bitmaps",
            "lavatroll bitmaps",
            "lilly bitmaps",
            "lion female 128 bitmaps",
            "lion male 128 bitmaps",
            "lionsoul bitmaps",
            "luzia the witch bitmaps",
            "luziasheep bitmaps",
            "magic animations BITMAPS",
            "magier 45 bitmaps",
            "mister death working bitmaps",
            "mummy 45 bitmaps",
            "mushyman bitmaps",
            "nobeard bitmaps",
            "ogre 96x bitmaps",
            "pink zombie bitmaps",
            "pirat bitmaps",
            "piratesailor blue bitmaps",
            "princess 96x bitmaps",
            "queen 96x bitmaps",
            "red archer bitmaps 96x96",
            "red dragonfly bitmaps",
            "red knight bitmaps",
            "red spider bitmaps",
            "red swordsman bitmaps",
            "red zombie bitmaps",
            "redGnome",
            "schaufelwilly bitmaps",
            "schwein bitmaps",
            "sheep bitmaps",
            "skelette",
            "soldier bitmaps",
            "spider bitmaps",
            "staffstan bitmaps",
            "stan unarmed  bitmaps",
            "swampthing bitmaps",
            "swordskel bitmaps",
            "swordstan bitmaps",
            "Swrom",
            "thief bitmaps96x96",
            "transportwilly bitmaps",
            "vlad 96x bitmaps",
            "vlad axe 96x bitmaps",
            "vlad sword 96x bitmaps",
            "wasp96bitmaps",
            "waterdragon ground bitmaps",
            "white mage bitmaps 96x96",
            "willy bitmaps",
            "yellow archer bitmaps 96x96",
            "yellow dragonfly bitmaps"
               
            };
       
       // remove the following passages from dir names -> to build class names
       String[] remove={"bitmaps", "96x96", "96x","96X", "96", "45", "144x", "128"};

       // load animations with the following "starters"
       // if not found nothing will be loaded!
       String[] actions = {
            "magic spelling",
            "magic attack",
            "magieattack",
            "attack",
            "running", 
            "walking",
            "schiesst",
            "spit",
            "magie",
            "rennt",
            "flying",
            "luft",
            "fliegt",
            "shooting",

            "green dragonfly",
            "red dragonfly",
            "yellow dragonfly", 
// not loaded is to much for now!
            "biting",
            "walk",
            "pick up",
            "stealing",
            "throwing",
            "wurmhaufen",
            "wurm stirbt",
            "wurm steigt",
            "wurm erscheint",
            "kriecht",
            "strickt",
            "macht faxen",
            "frisst",
            "digging",
            "greeting",
            "scythe unequip",
            "equip",
            "sits",
            "jumping fish",
            "pickup",
            "laydown",
            "headshaking",
            "building",
            "bows",
            "heult",
            "treffer",
            "disintegrate",
            "spricht",
            "disappear",
            "sitzt hin",
            "skull stand up",
            "stand up",
            "floating",
            "sleeps",
            "liest",
            "labert",
            "roaring",
            "appearing",
            "knit",
            "looking",
            "muuuh",
            "eating",
            "picking",
            "howling",
            "stands up",
            "sits down",
            "swordunequip",
            "swordequip",
            "been hit", 
            
            "talking",
            "tipping over", 
            "kippt um",
            "paused", 
            "highflying",
            "stopped", 
            "vladmorphtobat", 
            "stopped0000",
            "stopped0001",
            "stopped0002",
            "stopped0003",
            "stopped0004",
            "stopped0005",
            "stopped0006",
            "stopped0007",
            ""
               
       };
       
       // following directions for each animation will be loaded
       String[] dirs = {"e", "w", "s", "n", "ne", "nw", "se", "sw", "stopped", "steht", "groggy", "liosoul","stirbt","aus","moving", ""};
       
       // all animations are counted from 0000 up to xxxx whenever a corresponding file ist not found
       
       // ensure usage of file sizes, since all animation parts are in single bmp files
        jCheckBoxUseFileSizes.setSelected(true);
        jCheckBoxReplace.setSelected(true);
        
        // base directory
        String base="."+File.separator+"images"+File.separator+"Chars";
        for (int d = 0; d < filesDirs.length; d++) 
        {
            String klasse = filesDirs[d];
            for (int r=0; r <remove.length; r++ )
            {
                klasse = de.malban.util.UtilityString.replace(klasse, remove[r], "");
            }

            // a new class name!
            klasse = de.malban.util.UtilityString.replace(klasse.trim(), " ", "_");
            jTextFieldFile.setText(klasse);
            jTextFieldKlasse.setText(klasse);
            String baseAnimName = klasse;

            String directory = base+File.separator;

            // directory to look for images 
            directory += filesDirs[d]+File.separator;
            
            // go thru all directions
            for (int a = 0; a < actions.length; a++) 
            {
                // go thru all actions
                String action = actions[a];
                for (int i = 0; i < dirs.length; i++) 
                {
                    String direction = dirs[i];
                   //Clear
                    
                    //deinit all subs
                    jButtonClearActionPerformed(null);        

                    // get all files in that directory with given action and direction
                    File[] files = getFiles(directory, action, direction);
                    
                    // if nothing found - go on
                    if (files.length <=0) continue;
            

                    // add all files to current sequence
                    addMultipleImages(files);

                    // set the base name for the images
                    jTextFieldName.setText(baseAnimName+"_"+action+"_"+direction);
                    //jTextFieldFileCount.setText(""+files.length);
                    // add

                    

                    // save all images as one animtion
                    jButtonAddAsAnimImageActionPerformed(null);    

                    
                    String filename = "AllReinersCharAnimations"+File.separator+baseAnimName+"_"+action+"_"+direction;
                    saveAnimationAsOneImage(filename);
                    jButtonAddAsAnimImageActionPerformed(null);    

                    // reset
//                    jButtonResetActionPerformed(null);
                    
                    // save the animationSequence as one Image
                    //jButtonSaveAnimImageActionPerformed(null);
                    
                    // reset
                    jButtonResetActionPerformed(null);
                    
                    // get color to alpha channel
                    singleImagePanel1.fillRGBA(4+98,4);pressed(null);

                    // set that color to be non opaque (alpha == 0
                    jButtonChangeColorActionPerformed(null);
                    // save as the same imagejButtonChangeColorActionPerformed
                    jButtonSaveImageGraphicsActionPerformed(null);
                    // and again a reset
//                    jButtonResetActionPerformed(null);
                
                }
            }

        }
    }//GEN-LAST:event_jButton6ActionPerformed

    // assuming
    // both images have the same size!
    BufferedImage joinHalfVertical(BufferedImage image1, BufferedImage image2)
    {
        int hh1 = image1.getHeight()/2;
        int hh2 = image2.getHeight()/2;
        int w = image1.getWidth();
        if (w>image2.getWidth()) w = image2.getWidth();
        BufferedImage newImage;

        newImage = new BufferedImage(w, hh1+hh2, BufferedImage.TYPE_INT_ARGB);
        Graphics2D go = newImage.createGraphics();
        go.drawImage(image1, 0, 0, w, hh1, 0, 0, w, hh1, null);
        go.drawImage(image2, 0, hh1, w, hh1+hh2, 0, hh1, w, hh1+hh2, null);
        return newImage;
    }

    // assuming
    // both images have the same size!
    BufferedImage joinHalfHorizontal(BufferedImage image1, BufferedImage image2)
    {
        int hw1 = image1.getWidth()/2;
        int hw2 = image2.getWidth()/2;
        int h = image1.getHeight();
        if (h>image2.getHeight()) h = image2.getHeight();
        BufferedImage newImage;

        newImage = new BufferedImage(hw1+hw2, h, BufferedImage.TYPE_INT_ARGB);
        Graphics2D go = newImage.createGraphics();

        go.drawImage(image1, 0, 0, hw1, h, 0, 0, hw1, h, null);
        go.drawImage(image2, hw1, 0, hw1+hw2, h, hw1, 0, hw1+hw2, h, null);
        return newImage;
    }

    BufferedImage applyFilter(BufferedImage sourceImage, BufferedImage filterImage)
    {
        BufferedImage filterImageUse = ImageCache.getImageCache().getDerivatScale(filterImage, sourceImage.getWidth(), sourceImage.getHeight());
        int h = sourceImage.getHeight();
        int w = sourceImage.getWidth();
        BufferedImage newImage;

        newImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
        Graphics2D go = newImage.createGraphics();

        for (int y=0; y<h; y++)
        {
            for (int x=0; x<w; x++)
            {
                Color f1;
                Color s2;
                int pixel = 0;
                f1 = new Color(filterImageUse.getRGB(x,y));
                int fr = f1.getRed();
                int fg = f1.getGreen();
                int fb = f1.getBlue();
                int frgba =filterImageUse.getRGB(x, y);
                int fa = (frgba >> 24) & 0xFF;
                boolean filterIsBlack = (fr+ fg + fb) == 0;
                boolean alphaIsZero = (fa) == 0;

                s2 = new Color(sourceImage.getRGB(x,y));
                int sr = s2.getRed();
                int sg = s2.getGreen();
                int sb = s2.getBlue();

                int srgba =sourceImage.getRGB(x, y);
                int sa = (srgba >> 24) & 0xFF;

                if (!filterIsBlack)
                {
                    // if non black, than the filter value is taken!
                    pixel = frgba;
                }
                //else if (alphaIsZero)
                //{
                //    // else alpha = zero, than the source value is taken!
                //    pixel = srgba;
                //}
                else
                {
                    // pixel is alpha blended with filter alpha
                    pixel = srgba;
                    pixel = pixel & 0x00ffffff;
                    pixel = pixel | (fa << 24);
                }
                newImage.setRGB(x, y, pixel);
            }
        }
        return newImage;
    }

    // assuming
    // both images have the same size!
    BufferedImage joinBrighterPixels(BufferedImage image1, BufferedImage image2)
    {
        int h = image1.getHeight();
        int w = image1.getWidth();
        if (h>image2.getHeight()) h = image2.getHeight();
        if (w>image2.getWidth()) w = image2.getWidth();
        BufferedImage newImage;

        newImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
        Graphics2D go = newImage.createGraphics();

        for (int y=0; y<h; y++)
        {
            for (int x=0; x<w; x++)
            {
                int b1=-1;
                int b2=-1;
                Color c1;
                Color c2;
                if ((image1.getWidth()>x) && (image1.getHeight()>y))
                {
                    c1 = new Color(image1.getRGB(x,y));
                    int r = c1.getRed();
                    int g = c1.getGreen();
                    int b = c1.getBlue();

                    int rgba =image1.getRGB(x, y);
                    int A = (rgba >> 24) & 0xFF;

                    double a = ((double)A)/255;
                    b1 = (int)((r+g+b)*a);
                    if (A==0) b1=-1;
                    if (b1!=-1) if (r+g+b == 0) b1=A;
                }
                if ((image2.getWidth()>x) && (image2.getHeight()>y))
                {
                    c2 = new Color(image2.getRGB(x,y));
                    int r = c2.getRed();
                    int g = c2.getGreen();
                    int b = c2.getBlue();

                    int rgba =image2.getRGB(x, y);
                    int A = (rgba >> 24) & 0xFF;

                    double a = ((double)A)/255;
                    b2 = (int)((r+g+b)*a);
                    if (A==0) b2=-1;
                    if (b2!=-1) if (r+g+b == 0) b2=A;
                }
                if (b1>b2)
                {
                    newImage.setRGB(x, y, image1.getRGB(x,y));
                }
                else if (b2>b1)
                {
                    newImage.setRGB(x, y, image2.getRGB(x,y));
                }
                else if (b1!=-1)
                {
                    newImage.setRGB(x, y, image1.getRGB(x,y));
                }
            }
        }
        return newImage;
    }


    // assuming
    // both images have the same size!
    BufferedImage joinBrighterPixelsNW(BufferedImage image1, BufferedImage image2)
    {
        int h = image2.getHeight()/2;
        int w = image2.getWidth()/2;
        BufferedImage newImage;

        newImage = new BufferedImage(image2.getWidth(), image2.getHeight(), BufferedImage.TYPE_INT_ARGB);
        for (int y=0; y<h; y++)
        {
            for (int x=0; x<w; x++)
            {
                newImage.setRGB(x, y, image2.getRGB(x,y));
            }
        }
        return joinBrighterPixels(image1, newImage);
    }
    BufferedImage joinBrighterPixelsNE(BufferedImage image1, BufferedImage image2)
    {
        int h = image2.getHeight()/2;
        int w = image2.getWidth();
        BufferedImage newImage;

        newImage = new BufferedImage(image2.getWidth(), image2.getHeight(), BufferedImage.TYPE_INT_ARGB);
        for (int y=0; y<h; y++)
        {
            for (int x=image2.getWidth()/2; x<w; x++)
            {
                newImage.setRGB(x, y, image2.getRGB(x,y));
            }
        }
        return joinBrighterPixels(image1, newImage);
    }
    BufferedImage joinBrighterPixelsSW(BufferedImage image1, BufferedImage image2)
    {
        int h = image2.getHeight();
        int w = image2.getWidth()/2;
        BufferedImage newImage;

        newImage = new BufferedImage(image2.getWidth(), image2.getHeight(), BufferedImage.TYPE_INT_ARGB);
        for (int y=image2.getHeight()/2; y<h; y++)
        {
            for (int x=0; x<w; x++)
            {
                newImage.setRGB(x, y, image2.getRGB(x,y));
            }
        }
        return joinBrighterPixels(image1, newImage);
    }
    BufferedImage joinBrighterPixelsSE(BufferedImage image1, BufferedImage image2)
    {
        int h = image2.getHeight();
        int w = image2.getWidth();
        BufferedImage newImage;

        newImage = new BufferedImage(image2.getWidth(), image2.getHeight(), BufferedImage.TYPE_INT_ARGB);
        for (int y=image2.getHeight()/2; y<h; y++)
        {
            for (int x=image2.getWidth()/2; x<w; x++)
            {
                newImage.setRGB(x, y, image2.getRGB(x,y));
            }
        }
        return joinBrighterPixels(image1, newImage);
    }


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private de.malban.graphics.ImageComponent imageComponent1;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton11;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JButton jButton8;
    private javax.swing.JButton jButtonAddAsAnimImage;
    private javax.swing.JButton jButtonAddFileSeries;
    private javax.swing.JButton jButtonAddImageSeries;
    private javax.swing.JButton jButtonAddMultipleImages;
    private javax.swing.JButton jButtonAddOneImage;
    private javax.swing.JButton jButtonApplyCrop;
    private javax.swing.JButton jButtonApplyFilter;
    private javax.swing.JButton jButtonAsSource;
    private javax.swing.JButton jButtonAsSource1;
    private javax.swing.JButton jButtonBuildAni;
    private javax.swing.JButton jButtonBuiltArtifactFilter;
    private javax.swing.JButton jButtonChangeColor;
    private javax.swing.JButton jButtonClear;
    private javax.swing.JButton jButtonCropImage;
    private javax.swing.JButton jButtonDelete;
    private javax.swing.JButton jButtonDeleteOne;
    private javax.swing.JButton jButtonExport;
    private javax.swing.JButton jButtonFileSelect;
    private javax.swing.JButton jButtonFileSelect1;
    private javax.swing.JButton jButtonFileSelect2;
    private javax.swing.JButton jButtonMirrorAll;
    private javax.swing.JButton jButtonNew;
    private javax.swing.JButton jButtonOneBack;
    private javax.swing.JButton jButtonOneForward;
    private javax.swing.JButton jButtonOpacityAll;
    private javax.swing.JButton jButtonReset;
    private javax.swing.JButton jButtonResozeCanvas;
    private javax.swing.JButton jButtonReverse;
    private javax.swing.JButton jButtonRotateAll;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JButton jButtonSaveAnimImage;
    private javax.swing.JButton jButtonSaveClassAsImage;
    private javax.swing.JButton jButtonSaveClassSingleImages;
    private javax.swing.JButton jButtonSaveImageGraphics;
    private javax.swing.JButton jButtonSaveImageGraphics1;
    private javax.swing.JButton jButtonScaleAll;
    private javax.swing.JButton jButtonSeamless;
    private javax.swing.JCheckBox jCheckBoxAnimationOffset;
    private javax.swing.JCheckBox jCheckBoxAnimationScaled;
    private javax.swing.JCheckBox jCheckBoxDontChangeSize;
    private javax.swing.JCheckBox jCheckBoxJustImages;
    private javax.swing.JCheckBox jCheckBoxKeepOffset;
    private javax.swing.JCheckBox jCheckBoxPaintGrid;
    private javax.swing.JCheckBox jCheckBoxPaintSelection;
    private javax.swing.JCheckBox jCheckBoxPreviewOffset;
    private javax.swing.JCheckBox jCheckBoxPreviewScaled;
    private javax.swing.JCheckBox jCheckBoxRandom;
    private javax.swing.JCheckBox jCheckBoxReplace;
    private javax.swing.JCheckBox jCheckBoxSelectionLock;
    private javax.swing.JCheckBox jCheckBoxUseFileSizes;
    private javax.swing.JCheckBox jCheckBoxVerticalFirst;
    private javax.swing.JCheckBox jCheckBoxVerticalMirror;
    private javax.swing.JCheckBox jCheckBoxinternalOffset;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JComboBox jComboBoxKlasse;
    private javax.swing.JComboBox jComboBoxKlasse1;
    private javax.swing.JComboBox jComboBoxName;
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
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JLabel jLabelSelSize;
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
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    private javax.swing.JPanel jPanelIMageCollection;
    private javax.swing.JPanel jPanelIMageCollection1;
    private javax.swing.JRadioButton jRadioButtonOpacity;
    private javax.swing.JRadioButton jRadioButtonRotation;
    private javax.swing.JRadioButton jRadioButtonScaling;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JSlider jSliderSourceScale;
    private javax.swing.JSpinner jSpinner1;
    private javax.swing.JSpinner jSpinner2;
    private javax.swing.JSpinner jSpinner3;
    private javax.swing.JSpinner jSpinner4;
    private javax.swing.JSpinner jSpinner5;
    private javax.swing.JSpinner jSpinner6;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextFieldAngle;
    private javax.swing.JTextField jTextFieldColorA;
    private javax.swing.JTextField jTextFieldColorB;
    private javax.swing.JTextField jTextFieldColorG;
    private javax.swing.JTextField jTextFieldColorR;
    private javax.swing.JTextField jTextFieldCount;
    private javax.swing.JTextField jTextFieldCountAll;
    private javax.swing.JTextField jTextFieldCountX;
    private javax.swing.JTextField jTextFieldCountY;
    private javax.swing.JTextField jTextFieldCurrentNo;
    private javax.swing.JTextField jTextFieldDelay;
    private javax.swing.JTextField jTextFieldEnd;
    private javax.swing.JTextField jTextFieldFile;
    private javax.swing.JTextField jTextFieldFileCount;
    private javax.swing.JTextField jTextFieldGapX;
    private javax.swing.JTextField jTextFieldGapY;
    private javax.swing.JTextField jTextFieldHeight;
    private javax.swing.JTextField jTextFieldHeightCrop;
    private javax.swing.JTextField jTextFieldImageSource;
    private javax.swing.JTextField jTextFieldKlasse;
    private javax.swing.JTextField jTextFieldName;
    private javax.swing.JTextField jTextFieldOpacity;
    private javax.swing.JTextField jTextFieldPosX;
    private javax.swing.JTextField jTextFieldPosXCrop;
    private javax.swing.JTextField jTextFieldPosXOpt;
    private javax.swing.JTextField jTextFieldPosY;
    private javax.swing.JTextField jTextFieldPosYCrop;
    private javax.swing.JTextField jTextFieldPosYOpt;
    private javax.swing.JTextField jTextFieldScaleHeight;
    private javax.swing.JTextField jTextFieldScaleWidth;
    private javax.swing.JTextField jTextFieldStart;
    private javax.swing.JTextField jTextFieldStartX;
    private javax.swing.JTextField jTextFieldStartY;
    private javax.swing.JTextField jTextFieldSteps;
    private javax.swing.JTextField jTextFieldWidth;
    private javax.swing.JTextField jTextFieldWidthCrop;
    private javax.swing.JToggleButton jToggleButtonPlayAnim;
    private javax.swing.JToggleButton jToggleButtonPlayAnimMain;
    private de.malban.graphics.SingleImagePanel singleImagePanel1;
    private de.malban.graphics.SingleImagePanel singleImagePanel2;
    // End of variables declaration//GEN-END:variables

    void setImage()
    {
        singleImagePanel1.setImage(jTextFieldImageSource.getText());
    }

    void doGrid()
    {
        if (inSetting>0) return;
        if (!jCheckBoxPaintGrid.isSelected())
        {
            singleImagePanel1.setGrid(false);
            return;
        }
        singleImagePanel1.setGrid(true);
        GridData grid = getGrid();

        singleImagePanel1.setGrid(grid);
    }
    GridData getGrid()
    {
        GridData grid = new GridData();
        grid.startX = getI(jTextFieldStartX);
        grid.startY = getI(jTextFieldStartY);
        grid.singleWidth = getI(jTextFieldWidth);
        grid.singleHeight = getI(jTextFieldHeight);
        grid.gapX = getI(jTextFieldGapX);
        grid.gapY = getI(jTextFieldGapY);
        grid.gridWidth = getI(jTextFieldCountX);
        grid.gridHeight = getI(jTextFieldCountY);
        return grid;
    }
    int getDelay()
    {
        return getI(jTextFieldDelay);
    }
    public void setDelay(int d)
    {
        jTextFieldDelay.setText(""+d);
    }

    void setCurrentData(Vector <BaseImageData> data)
    {
        
       mCloneData = null;
       clearBaseImageData();
       mData = data;
        if (mData.size()>0)
        {
            BaseImageData bdata = mData.elementAt(0);
            currentNotice = bdata.notice;

            String fullPath = bdata.fileName;
            jTextFieldImageSource.setText(de.malban.util.Utility.makeRelative(fullPath));
            setImage();
            inSetting++;

            jSliderSourceScale.setValue(6);
            singleImagePanel1.setScale(1);
            inSetting--;
        }
        refreshCollection();
        updateToSelectedPanel();
    }

    Vector <BaseImageData> readAllToCurrentISE()
    {
        return mData;
    }
    void refreshCollection()
    {
        refreshCollection(true);
    }
    void refreshCollection(boolean unselect)
    {
        refreshCollection(unselect, false);
    }

    void clearBaseImageData()
    {
        removeAllSubListeners(jPanelIMageCollection);
        jPanelIMageCollection.removeAll();
        if (mData==null) return;
        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            baseImageData.cpanel = null;
        }
        mData = null;
    }
    
    void removeAllSubListenersDirect_(Component c)
    {
        // Mouse listener
        MouseListener[] ml = c.getMouseListeners();
        for (int j = 0; j < ml.length; j++) {
            MouseListener mouseListener = ml[j];
            c.removeMouseListener(mouseListener);
        }
        if (c instanceof SingleImagePanel)
        {
            //((SingleImagePanel)c).unsetImage();
            ((SingleImagePanel)c).deinit();            
        }
        if (c instanceof ImageComponent)
        {
            ((ImageComponent)c).deinit();
        }
        
    }
    
    void removeAllSubListeners(Container con)
    {
        for (int i=0; i<con.getComponentCount(); i++)
        {
            Component c = con.getComponent(i);
            if (c instanceof Container)
            {
                removeAllSubListeners((Container) c);
                //con.remove(c); // DANGER!
            }
            removeAllSubListenersDirect_(c);
        }
    }
    
    // refreshes the horitontal image sequence
    // and sets the selected image to 0
    void refreshCollection(boolean unselect, boolean refreshImage)
    {
        removeAllSubListeners(jPanelIMageCollection);
        jPanelIMageCollection.removeAll();
        
        JPanel newSelection = null;
        for (int i = 0; i < mData.size(); i++)
        {
            BaseImageData baseImageData = mData.elementAt(i);
            SingleImagePanel sip;
            if (baseImageData.cpanel == null)
            {
                baseImageData.cpanel = new JPanel();
                baseImageData.cpanel.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
                baseImageData.cpanel.setPreferredSize(new java.awt.Dimension(52, 52));
                baseImageData.cpanel.setLayout(new BorderLayout());
                sip = new SingleImagePanel();
                baseImageData.cpanel.add(sip, BorderLayout.CENTER);
                
                sip.setBaseImage(baseImageData.image, 50, 50);
                sip.setOffset(baseImageData.ox, baseImageData.oy, true);
                sip.addMouseListener(new java.awt.event.MouseAdapter() {
                    @Override
                    public void mousePressed(java.awt.event.MouseEvent evt) {
                        jPanelMouseClickedHorizontal(evt);
                    }
                });
            }
            else if (refreshImage)
            {
                sip = (SingleImagePanel)baseImageData.cpanel.getComponent(0);
                sip.setBaseImage(baseImageData.image, 50, 50);
                sip.setOffset(baseImageData.ox, baseImageData.oy, true);
                sip.addMouseListener(new java.awt.event.MouseAdapter() {
                    @Override
                    public void mousePressed(java.awt.event.MouseEvent evt) {
                        jPanelMouseClickedHorizontal(evt);
                    }
                });
            }
            else
            {
                sip = (SingleImagePanel)baseImageData.cpanel.getComponent(0);
                sip.setBaseImage(baseImageData.image, 50, 50);
                sip.setOffset(baseImageData.ox, baseImageData.oy, true);
                sip.addMouseListener(new java.awt.event.MouseAdapter() {
                    @Override
                    public void mousePressed(java.awt.event.MouseEvent evt) {
                        jPanelMouseClickedHorizontal(evt);
                    }
                });
            }

            if (i==0)
            {
                newSelection = baseImageData.cpanel;
                currentNotice = baseImageData.notice;
            }

            baseImageData.cpanel.setName(""+i); // name must be reset if image was deleted
            jPanelIMageCollection.add(baseImageData.cpanel);
            baseImageData.cpanel.repaint();
        }

        jPanelIMageCollection.invalidate();
        jPanelIMageCollection.validate();
        jPanelIMageCollection.repaint();
        repaint();
        jToggleButtonPlayAnimActionPerformed(null);
        jTextFieldCount.setText(""+mData.size());
        if (unselect)
        {
            jTextFieldCurrentNo.setText("");
            jLabelSelSize.setText("");
            currentSelectedNo=-1;
            if (currentSelectedBasePanel != null)
            {
                currentSelectedBasePanel.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
            }
            currentSelectedBasePanel = null;
        }
        currentSelectedBasePanel = newSelection;
    }

    JPanel currentSelectedBasePanel = null;
    
    // sets the current horizontal settings
    // currentSelectedBasePanel must be selceted in advance!
    void updateToSelectedPanel()
    {
        if (currentSelectedBasePanel == null) return;
        currentSelectedBasePanel.setBorder(javax.swing.BorderFactory.createLineBorder(Color.ORANGE));
        currentSelectedNo = getI(currentSelectedBasePanel.getName(),-1);
        if (currentSelectedNo == -1)
        {
            jTextFieldCurrentNo.setText("");
            jLabelSelSize.setText("");
            jTextFieldImageSource.setText("");
        }
        else
        {
            currentNotice = mData.elementAt(currentSelectedNo).notice;
            jTextFieldImageSource.setText(mData.elementAt(currentSelectedNo).fileName);
            jTextFieldCurrentNo.setText(""+currentSelectedNo);
            jLabelSelSize.setText(""+mData.elementAt(currentSelectedNo).w+"/"+mData.elementAt(currentSelectedNo).h);
            jTextFieldWidth.setText(""+mData.elementAt(currentSelectedNo).w);
            jTextFieldHeight.setText(""+mData.elementAt(currentSelectedNo).h);

            jTextFieldPosX.setText(""+mData.elementAt(currentSelectedNo).x);
            jTextFieldPosY.setText(""+mData.elementAt(currentSelectedNo).y);


            jTextFieldPosXCrop.setText(""+mData.elementAt(currentSelectedNo).cx);
            jTextFieldPosYCrop.setText(""+mData.elementAt(currentSelectedNo).cy);
            jTextFieldWidthCrop.setText(""+mData.elementAt(currentSelectedNo).cw);
            jTextFieldHeightCrop.setText(""+mData.elementAt(currentSelectedNo).ch);
            jTextFieldPosXOpt.setText(""+mData.elementAt(currentSelectedNo).ox);
            jTextFieldPosYOpt.setText(""+mData.elementAt(currentSelectedNo).oy);

        // currentBase = mData.elementAt(currentSelectedNo);
        // singleImagePanel1.setImage(currentBase.image);
    // void setImage()
        singleImagePanel1.setImage(jTextFieldImageSource.getText());

            currentBase = singleImagePanel1.getSelection(mData.elementAt(currentSelectedNo).x,mData.elementAt(currentSelectedNo).y, mData.elementAt(currentSelectedNo).w, mData.elementAt(currentSelectedNo).h);
            currentBase.ox = mData.elementAt(currentSelectedNo).ox;
            currentBase.oy = mData.elementAt(currentSelectedNo).oy;

            currentBase.notice = currentNotice;

            if (previewScale)
                singleImagePanel2.setBaseImage(mData.elementAt(currentSelectedNo).image, singleImagePanel2.getWidth(),singleImagePanel2.getHeight());
            else
                singleImagePanel2.setBaseImage(mData.elementAt(currentSelectedNo).image);

            singleImagePanel2.setOffset(mData.elementAt(currentSelectedNo).ox, mData.elementAt(currentSelectedNo).oy, jCheckBoxPreviewOffset.isSelected());
        }

        
        jCheckBoxPaintSelectionActionPerformed(null);
    }

    private void jPanelMouseClickedHorizontal(java.awt.event.MouseEvent evt)
    {
        if (currentSelectedBasePanel != null)
        {
            currentSelectedBasePanel.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        }
        currentSelectedBasePanel = (JPanel) ((JPanel) evt.getSource()).getParent();
        updateToSelectedPanel();
    }

    void saveNewImage(String name)
    {
        int s = mISData.mHeight.size();
        mCloneData = null;
        if (s==0) return;

        Vector <BaseImageData> allImages = readAllToCurrentISE();

        int rowPos=0;
        int rowWidth;
        int rowWidthMax = 0;
        int columnAllHeight;
        int currentMaxHeight = 0;

        int gap = 1;
        int rectangleWidth=2;
        if (jCheckBoxJustImages.isSelected())
        {
            gap = 0;
            rectangleWidth=0;
        }

        int allGap = gap + rectangleWidth;

        rowWidth = 0;
        columnAllHeight = 0;

        for (int i = 0; i < allImages.size(); i++)
        {
            boolean newRow = false;
            BaseImageData baseImageData = allImages.elementAt(i);
            BufferedImage im = baseImageData.image;
            if ((rowPos != 0) &&  (rowWidth + im.getWidth()+allGap > MAX_ROW_WIDTH)) newRow=true;

            if (newRow)
            {
                columnAllHeight+= currentMaxHeight+allGap;
                if (rowWidth >rowWidthMax) rowWidthMax =rowWidth;
                rowWidth = 0;
                currentMaxHeight = 0;
                rowPos=0;
            }
            rowPos++;
            rowWidth+=im.getWidth()+allGap;
            if (im.getHeight()>currentMaxHeight) currentMaxHeight=im.getHeight();
        }
        columnAllHeight+= currentMaxHeight+allGap;
        if (rowWidth >rowWidthMax) rowWidthMax =rowWidth;

        BufferedImage bimage = allImages.elementAt(0).image;
        int type = BufferedImage.TYPE_INT_ARGB;

        int w = rowWidthMax;
        int h = columnAllHeight;
        BufferedImage dimg = new BufferedImage(w, h, type);
        Graphics2D g = dimg.createGraphics();

        rowPos=0;
        rowWidthMax = 0;
        currentMaxHeight = 0;

        rowWidth = 0;
        columnAllHeight = 0;

        for (int i = 0; i < allImages.size(); i++)
        {
            boolean newRow = false;
            BaseImageData baseImageData = allImages.elementAt(i);
            BufferedImage im = baseImageData.image;
            if ((rowPos != 0) &&  (rowWidth + im.getWidth()+allGap > MAX_ROW_WIDTH)) newRow=true;

            if (newRow)
            {
                columnAllHeight+= currentMaxHeight+allGap;
                if (rowWidth >rowWidthMax) rowWidthMax =rowWidth;
                rowWidth = 0;
                currentMaxHeight = 0;
                rowPos=0;
            }
            rowPos++;

            if (!jCheckBoxJustImages.isSelected())
            {
                g.setColor(Color.red);
                g.drawRect(rowWidth, columnAllHeight, im.getWidth()+rectangleWidth-1, im.getHeight()+rectangleWidth-1);
            }
            rowWidth += rectangleWidth/2;

            g.drawImage(im, null, rowWidth, columnAllHeight+rectangleWidth/2);


            baseImageData.fileName=name;
            baseImageData.xOrg = rowWidth;
            baseImageData.yOrg = columnAllHeight + (rectangleWidth/2);
            baseImageData.x=rowWidth;
            baseImageData.y=columnAllHeight + (rectangleWidth/2);
            baseImageData.h=im.getHeight();
            baseImageData.w=im.getWidth();

            baseImageData.cx=0;
            baseImageData.cy=0;
            baseImageData.ch=im.getHeight();
            baseImageData.cw=im.getWidth();


            baseImageData.notice = currentNotice;

            rowWidth += rectangleWidth/2;
            rowWidth += gap;
            rowWidth += im.getWidth();
            if (im.getHeight()>currentMaxHeight) currentMaxHeight=im.getHeight();
        }

//The formatName parameter selects the image format in which to save the BufferedImage.
// see: http://java.sun.com/docs/books/tutorial/2d/images/saveimage.html



        try
        {
            File outputfile = new File(name);
            ImageIO.write(dimg, "png", outputfile);
        }
        catch (IOException e)
        {
        }


        BaseImageData.fromBase(mISData, mData);
        
        
        refreshCollection();
    }

    int getSaveType()
    {
        int ret = SAVE_OK;
        String lastFilename = "";

        Vector <BaseImageData> allImages = readAllToCurrentISE();

        for (int i = 0; i < allImages.size(); i++)
        {
            BaseImageData baseImageData = allImages.elementAt(i);
            if (lastFilename.length()==0) lastFilename = baseImageData.fileName;
            if (!(lastFilename.equals(baseImageData.fileName))) ret = SAVE_OK;//SAVE_MULTI;
            if (baseImageData.fileName.trim().length()==0) return SAVE_NOK;

        }
        return ret;
    }

    void setPoolOnly()
    {
        if (!getPool()) return;
        if (mImageSequenceDataPool == null) return;

        mClassSetting++;
        jComboBoxKlasse.removeAllItems();
        Collection<String> collectionKlasse = mImageSequenceDataPool.getKlassenHashMap().values();
        Iterator<String> iterC = collectionKlasse.iterator();
        /** Sorting */  Vector<String> cnames = new Vector<String>(); while (iterC.hasNext()) cnames.addElement(iterC.next()); Collections.sort(cnames, new Comparator<String>()
            {@Override public int compare(String s1, String s2) { return s1.compareTo(s2); } });
        for (int j = 0; j < cnames.size(); j++)
        {
            String string = cnames.elementAt(j);
            jComboBoxKlasse.addItem(string);
        }

        String klasse = jTextFieldKlasse.getText().trim();
        if (klasse.length()==0)  {mClassSetting--; return;}


        jComboBoxName.removeAllItems();
        Collection<ImageSequenceData> collectionName = mImageSequenceDataPool.getMapForKlasse(klasse).values();
        Iterator<ImageSequenceData> iterN = collectionName.iterator();
        /** Sorting */  Vector<String> nnames = new Vector<String>(); while (iterN.hasNext()) nnames.addElement(iterN.next().mName); Collections.sort(nnames, new Comparator<String>() {@Override
            public int compare(String s1, String s2) { return s1.compareTo(s2); } });
        for (int j = 0; j < nnames.size(); j++)
        {
            String string = nnames.elementAt(j);
            jComboBoxName.addItem(string);
        }
        mClassSetting--;
    }

    void setFilterPoolOnly()
    {
        if (!getFilterPool()) return;
        if (mFilerDataPool == null) return;

        mClassSetting++;
        jComboBoxKlasse1.removeAllItems();
        Collection<String> collectionKlasse = mFilerDataPool.getKlassenHashMap().values();
        Iterator<String> iterC = collectionKlasse.iterator();
        /** Sorting */  Vector<String> cnames = new Vector<String>(); while (iterC.hasNext()) cnames.addElement(iterC.next()); Collections.sort(cnames, new Comparator<String>()
            {@Override public int compare(String s1, String s2) { return s1.compareTo(s2); } });
        for (int j = 0; j < cnames.size(); j++)
        {
            String string = cnames.elementAt(j);
            jComboBoxKlasse1.addItem(string);
        }
        mClassSetting--;
    }

    private void setClassList_()
    {
        setClassList(-1, "");
    }
    
    private void setClassList(int index, String sname)
    {
        int toSelectNo=index;
        
        if (toSelectNo>jPanelIMageCollection1.getComponentCount())
            toSelectNo = jPanelIMageCollection1.getComponentCount()-1;


        removeAllSubListeners(jPanelIMageCollection1);
        jPanelIMageCollection1.removeAll();
        currentSelectedImagePanel = null;
        if (jComboBoxKlasse.getSelectedIndex()==-1) return;
        String klasse =  jComboBoxKlasse.getSelectedItem().toString();
        if (klasse.trim().length() == 0) return;

        mClassSetting++;
        Collection<ImageSequenceData> collectionName = mImageSequenceDataPool.getMapForKlasse(klasse).values();
        Iterator<ImageSequenceData> iterN = collectionName.iterator();
        /** Sorting */  Vector<String> nnames = new Vector<String>(); while (iterN.hasNext()) nnames.addElement(iterN.next().mName); Collections.sort(nnames, new Comparator<String>() {@Override
            public int compare(String s1, String s2) { return s1.compareTo(s2); } });

        // all names of images of klasse in nnames

        int x = 5;
        int y = 5;
        for (int j = 0; j < nnames.size(); j++)
        {
            String name = nnames.elementAt(j);
            if (toSelectNo==-1)
            {
                if (name.equals(sname))
                    toSelectNo = j;
            }
            ImageSequenceData iSData = mImageSequenceDataPool.get(name);

            Vector <BaseImageData> data = BaseImageData.toBase(iSData);
            if (data.size()>0)
            {
                JPanel ipanel = new JPanel();
                if (j==toSelectNo)
                {
                    currentSelectedImagePanel = ipanel;
                    ipanel.setBorder(javax.swing.BorderFactory.createLineBorder(Color.ORANGE));
                }
                else
                    ipanel.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));

                ipanel.setName(""+name);
                ipanel.setPreferredSize(new java.awt.Dimension(52, 52));
                ipanel.setLayout(new BorderLayout());
                ImageComponent mip = new ImageComponent();

                ipanel.add(mip, BorderLayout.CENTER);
                //mip.setImages(images);
                mip.setSequence(new ImageSequence(iSData));


                mip.addMouseListener(new java.awt.event.MouseAdapter() {
                    @Override
                    public void mousePressed(java.awt.event.MouseEvent evt) {
                        jPanelMouseClickedImageVertical(evt);
                    }
                });

                ipanel.setBounds(x, y, 52, 52);

                jPanelIMageCollection1.add(ipanel);
                if (jToggleButtonPlayAnimMain.isSelected())
                {
                    mip.setDelay(iSData.getDelay());
                }
                else
                {
                    mip.setDelay(-1);
                }

                mip.setScaled(true, 52, 52);
                mip.setVisible(true);
                y += 52;
                y += 5;

            }

        }
        
        jPanelIMageCollection1.setBounds(0,0,62,y);
        jPanelIMageCollection1.setPreferredSize(new Dimension(62,y));
        jPanelIMageCollection1.invalidate();
        jPanelIMageCollection1.validate();
        jPanelIMageCollection1.repaint();
        repaint();
        mClassSetting--;
    }

    JPanel currentSelectedImagePanel = null;

    private void jPanelMouseClickedImageVertical(java.awt.event.MouseEvent evt) {
        JComponent c = (JComponent) evt.getSource();
        c = (JComponent) c.getParent();
        JPanel newSelectedImagePanel = (JPanel) c;
        selectVerticalImage(newSelectedImagePanel);
    }

    private void selectVerticalImage(JPanel newSelectedImagePanel)
    {
        if (newSelectedImagePanel == currentSelectedImagePanel) return;

        if (currentSelectedImagePanel != null)
        {
            currentSelectedImagePanel.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        }

        currentSelectedImagePanel = newSelectedImagePanel;
        currentSelectedImagePanel.setBorder(javax.swing.BorderFactory.createLineBorder(Color.ORANGE));
        String name  = currentSelectedImagePanel.getName();
        if (name.trim().length() == 0)
        {
            jTextFieldCurrentNo.setText("");
            jLabelSelSize.setText("");
        }
        else
        {
            if (!getPool())
            {
                return;
            }

            mISData = mImageSequenceDataPool.get(name);
            mCloneData = null;
            
            setAllFromCurrent();
        }
    }

    @Override
    public void pressed(EditMouseEvent evt)
    {
        jTextFieldColorR.setText(""+singleImagePanel1.getR());
        jTextFieldColorG.setText(""+singleImagePanel1.getG());
        jTextFieldColorB.setText(""+singleImagePanel1.getB());
        jTextFieldColorA.setText(""+singleImagePanel1.getA());
    }

    void notSavedShow()
    {
        Configuration.getConfiguration().DisplayError("Images not saved! Image with key name already exists!");
    }

    // reset image cache
    // load data new
    // set to same state as befor
    // to be used after a source image changed in any way
    //
    // not done horziontal data!
    void re_set()
    {
        ImageCache.clearCache();
        mCloneData = null;

        JPanel verticalImage = currentSelectedImagePanel;
        jComboBoxKlasseActionPerformed(null);
        if (verticalImage != null)
        {
            String name = verticalImage.getName();
            verticalImage = null;

            for(int i=0; i< jPanelIMageCollection1.getComponentCount(); i++)
            {
                String thisname = jPanelIMageCollection1.getComponent(i).getName();
                if (name.equals(thisname))
                {
                    verticalImage = (JPanel) jPanelIMageCollection1.getComponent(i);
                    break;
                }
            }
            if (verticalImage != null)
            {
                selectVerticalImage(verticalImage);
            }
        }
    }
    /** Batch Funcitons Start */

    // batching
    public void setFilename(String f)
    {
        jTextFieldFile.setText(f);
    }
    public void setKlasse(String k)
    {
        jTextFieldKlasse.setText(k);
    }
    public void clearImages()
    {
        jButtonClearActionPerformed(null);        
    }
    public void addMultipleImages(File[] files)
    {
        int x = getI(jTextFieldStartX);
        int y = getI(jTextFieldStartY);
        int w = getI(jTextFieldWidth);
        int h = getI(jTextFieldHeight);
        for (int i=0; i<files.length; i++)
        {
            String fullPath = files[i].getAbsolutePath();
            lastImagePath = fullPath;
            jTextFieldImageSource.setText(de.malban.util.Utility.makeRelative(fullPath));
            setImage();
            
            if (jCheckBoxUseFileSizes.isSelected())
            {
                w = singleImagePanel1.getSourceWidth();
                h = singleImagePanel1.getSourceHeight();
                x=0;
                y=0;
            }
            currentBase = singleImagePanel1.getSelection(x,y,w,h);
            currentBase.notice = currentNotice;
            addCurrentToData();
        }
    }    
    public void setImageSequenceName(String n)
    {
        jTextFieldName.setText(n);
    }

    public void addAsAnimation()
    {
        jButtonAddAsAnimImageActionPerformed(null);    
    }

    public void saveAnimationAsOneImage(String f)
    {
        saveAnimationAsOneImageIntern(f);
    }

    public void resetCache()
    {
        jButtonResetActionPerformed(null);
    }
    

    public void setColorToBackgroundAt(int x, int y)
    {
        singleImagePanel1.fillRGBA(x,y);pressed(null);
        jButtonChangeColorActionPerformed(null);
    }
    public void saveColoredImageAsSelf()
    {
        jButtonSaveImageGraphicsActionPerformed(null);
    }
    
    public void setUseFileSizes(boolean b)
    {
        jCheckBoxUseFileSizes.setSelected(b);
    }
    public void setReplaceSequenceDataOnSameName(boolean b)
    {
        jCheckBoxReplace.setSelected(b);
    }
    
    public String stringformat(String s, int i)
    {
        return String.format( s, i ) ;
    }
    
    /** Batch Funcitons End */
}
