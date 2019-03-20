package de.malban.vide.vedi.project;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.components.ModalInternalFrame;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.vide.script.ExecutionDescriptor;
import static de.malban.vide.script.ExecutionDescriptor.ED_TYPE_PROJECT_POST;
import static de.malban.vide.script.ExecutionDescriptor.ED_TYPE_PROJECT_PRE;
import de.malban.vide.script.ExportData;
import de.malban.vide.script.ExportDataPool;
import de.malban.vide.script.ScriptDataPanel;
import de.malban.vide.vecx.cartridge.Cartridge;
import static de.malban.vide.vedi.VediPanel.convertSeperator;
import static de.malban.vide.vedi.peeper.PeepJPanel.showEditPeepProperties;
import de.muntjak.tinylookandfeel.Theme;
import java.awt.Rectangle;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JInternalFrame;
import javax.swing.UIManager;
import javax.swing.table.AbstractTableModel;

public class ProjectPropertiesPanel extends javax.swing.JPanel implements 
         Windowable{
    
    private ExportDataPool mExportDataPool;
    class BankMainTableModel extends AbstractTableModel
    {
        private BankMainTableModel()
        {
        }

        public int getRowCount()
        {
            if (mProjectProperties == null) return 0;
            if (mProjectProperties.mBankMainFiles == null) return 0;
            return mProjectProperties.mBankMainFiles.size();
        }
        public int getColumnCount()
        {
            return 3;
        }
        public Object getValueAt(int row, int col)
        {
            if (col == 0) 
            {
                return ""+row;
            }
            if (mProjectProperties == null) return "";
            if (mProjectProperties.mBankMainFiles == null) return "";
            if (col == 1)
            {
                String name = mProjectProperties.mBankMainFiles.elementAt(row);
                Path p = Paths.get(name);
                return p.getFileName();
            }
            if (col == 2)
            {
                if (row < mProjectProperties.mBankDefines.size())
                {
                    String name = mProjectProperties.mBankDefines.elementAt(row);
                    return name;
                    
                }
            }
            return "-";
        }
        public String getColumnName(int column) {

            if (column ==0) return "#";
            if (column ==1) return "main file for bank";
            if (column ==2) return "define(s)";
            return "";
        }
        // input data column
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        // input data column
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            if (columnIndex == 1) return true;
            if (columnIndex == 2) return true;
            return false;
        }
        // input data column
        public void setValueAt(Object aValue, int rowIndex, int columnIndex) {
            if (mProjectProperties == null) return ;
            if (columnIndex == 1)
            {
                if (mProjectProperties.mBankMainFiles == null) return ;
                if (mProjectProperties.mBankMainFiles.size()<= rowIndex) return ;
                String path = aValue.toString();
                String malRel = de.malban.util.Utility.makeVideRelative(path);
                        
                String repl = mProjectProperties.projectPrefix+File.separator;
                path = de.malban.util.UtilityString.replace(path, repl, "");
                
                
//                String ppath = mProjectProperties.mOldPath.toString();
//                if (ppath.length() != 0 )ppath+=File.separator;
//                Path projectPath = Paths.get(mProjectProperties.projectPrefix);
//                if (projectPath.toString().length() != 0 )ppath+=File.separator;
//                Path filePath = Paths.get(path);
//                
//                Path relativePath1 = projectPath.relativize(filePath);
                mProjectProperties.mBankMainFiles.setElementAt(path.toString(), rowIndex);
            }
            if (columnIndex == 2)
            {
                if (mProjectProperties.mBankDefines == null) return ;
                if (mProjectProperties.mBankDefines.size()<= rowIndex) return ;
                mProjectProperties.mBankDefines.setElementAt(aValue.toString(), rowIndex);
            }
        }
    }        
    BankMainTableModel model = new BankMainTableModel();
    
    private ProjectProperties mProjectProperties = new ProjectProperties();
    private ProjectPropertiesPool mProjectPropertiesPool;
    private int mClassSetting=0;

    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
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
    public void setMenuItem(javax.swing.JMenuItem item)
    {
        mParentMenuItem = item;
        mParentMenuItem.setText("ProjectWindow");

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
    public void deinit()
    {
        removeUIListerner();
    }

    /** Creates new form ProjectPropertiesPanel */
    public ProjectPropertiesPanel() {
        mClassSetting++;
        initComponents();
        initScripts();
        initImager();
        jComboBoxImager.setSelectedIndex(-1);
        mProjectPropertiesPool = new ProjectPropertiesPool();
        resetConfigPool(false, "");
        jPanel1.setVisible(false);

        jTable1.setModel(model);
        String ppath = mProjectProperties.mOldPath.toString();
        if (ppath.length() != 0 )ppath+=File.separator;
        jTable1.getColumnModel().getColumn(1).setCellEditor(new FileChooserCellEditor(ppath+mProjectProperties.mProjectName));

        jTable1.getColumnModel().getColumn(0).setPreferredWidth(5);                
        jTable1.getColumnModel().getColumn(0).setWidth(5);  
        jTable1.getColumnModel().getColumn(1).setPreferredWidth(200);                
        jTable1.getColumnModel().getColumn(1).setWidth(200);  
        jTable1.getColumnModel().getColumn(1).setPreferredWidth(100);                
        jTable1.getColumnModel().getColumn(1).setWidth(100);  
        mClassSetting--;
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
    }

    public ProjectPropertiesPanel(ProjectProperties currentProject) 
    {
        mClassSetting++;
        initComponents();
        initScripts();
        initImager();
        jComboBoxImager.setSelectedIndex(-1);
        
        
        jButtonCreate.setText("ok");
        jButtonCreate.setName("ok");
        mProjectProperties = currentProject;
        setAllFromCurrent();
        jPanel1.setVisible(false);
        
        jTextFieldProjectName.setEnabled(false);
        jTextFieldPath.setEnabled(false);
        jButtonFileSelect1.setEnabled(false);
        
        jTable1.setModel(model);
        String ppath = mProjectProperties.mOldPath.toString();
        if (ppath.length() != 0 )ppath+=File.separator;
        jTable1.getColumnModel().getColumn(1).setCellEditor(new FileChooserCellEditor(ppath+mProjectProperties.mProjectName));

        jTable1.getColumnModel().getColumn(0).setPreferredWidth(5);                
        jTable1.getColumnModel().getColumn(0).setWidth(5);  
        jTable1.getColumnModel().getColumn(1).setPreferredWidth(200);                
        jTable1.getColumnModel().getColumn(1).setWidth(200);  
        mClassSetting--;
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
    }
    
    // called when bankswitching or number of banks changed
    void adjustMains()
    {
        if (mClassSetting > 0) return;
        if (mProjectProperties.mBankMainFiles == null)
            mProjectProperties.mBankMainFiles = new Vector<String>();
        if (mProjectProperties.mBankDefines == null)
            mProjectProperties.mBankDefines = new Vector<String>();
        
        int number=0;
        // determine size of vector and adjust its size
        if (jComboBoxBankswitch.getSelectedIndex()==0)
        {
        }
        else if (jComboBoxBankswitch.getSelectedIndex()==1)
        {
            number = 2;
        }
        else if (jComboBoxBankswitch.getSelectedIndex()==2)
        {
            number = 4;
        }
        else if (jComboBoxBankswitch.getSelectedIndex()==3)
        {
            number = jComboBoxBankswitchNumber.getSelectedIndex()+1;
        }
        if (mProjectProperties.mBankMainFiles.size() > number)
        {
            while (mProjectProperties.mBankMainFiles.size()>number)
                mProjectProperties.mBankMainFiles.removeElementAt(mProjectProperties.mBankMainFiles.size()-1);
        }
        else
        {
            while (mProjectProperties.mBankMainFiles.size()<number)
                mProjectProperties.mBankMainFiles.addElement("");
        }

        if (mProjectProperties.mBankDefines.size() > number)
        {
            while (mProjectProperties.mBankDefines.size()>number)
                mProjectProperties.mBankDefines.removeElementAt(mProjectProperties.mBankDefines.size()-1);
        }
        else
        {
            while (mProjectProperties.mBankDefines.size()<number)
                mProjectProperties.mBankDefines.addElement("");
        }
        
        
        jTable1.tableChanged(null);
        String ppath = mProjectProperties.mOldPath.toString();
        if (ppath.length() != 0 )ppath+=File.separator;
        jTable1.getColumnModel().getColumn(1).setCellEditor(new FileChooserCellEditor(ppath+mProjectProperties.mProjectName));
        jTable1.getColumnModel().getColumn(0).setPreferredWidth(5);                
        jTable1.getColumnModel().getColumn(0).setWidth(5);  
        jTable1.getColumnModel().getColumn(1).setPreferredWidth(200);                
        jTable1.getColumnModel().getColumn(1).setWidth(200);  
    }
    
    
    private void resetConfigPool(boolean select, String klasseToSet) /* allneeded*/
    {
        mClassSetting++;
        Collection<String> collectionKlasse = mProjectPropertiesPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        int i = 0;
        String klasse = "";

        jComboBoxKlasse.removeAllItems();
        while (iterKlasse.hasNext())
        {
            String item = iterKlasse.next();
            jComboBoxKlasse.addItem(item);
            if (select)
            {
                if (klasseToSet.length()==0)
                {
                    if (i==0)
                    {
                        jComboBoxKlasse.setSelectedIndex(i);
                        jTextFieldKlasse.setText(item);
                        klasse = item;
                    }
                }
                else
                {
                    if (klasseToSet.equalsIgnoreCase(item))
                    {
                        jComboBoxKlasse.setSelectedIndex(i);
                        jTextFieldKlasse.setText(item);
                        klasse = item;
                    }
                }
            }
            i++;
        }
        if ((select) && (klasse.length()==0))
        {
            if (jComboBoxKlasse.getItemCount()>0)
            {
                jComboBoxKlasse.setSelectedIndex(0);
                jTextFieldKlasse.setText(jComboBoxKlasse.getSelectedItem().toString());
                klasse = jComboBoxKlasse.getSelectedItem().toString();
            }
        }
        if (!select)  jComboBoxKlasse.setSelectedIndex(-1);

        Collection<ProjectProperties> colC = mProjectPropertiesPool.getMapForKlasse(klasse).values();
        Iterator<ProjectProperties> iterC = colC.iterator();

        jComboBoxName.removeAllItems();
        i = 0;
        while (iterC.hasNext())
        {
            ProjectProperties item = iterC.next();
            jComboBoxName.addItem(item.mName);
            if ((i==0) && (select))
            {
                jComboBoxName.setSelectedIndex(0);
                mProjectProperties = mProjectPropertiesPool.get(item.mName);
                setAllFromCurrent();
            }
            i++;
        }
        if (!select)  jComboBoxName.setSelectedIndex(-1);
        mClassSetting--;
    }

    private void clearAll() /* allneeded*/
    {
        mClassSetting++;
        mProjectProperties = new ProjectProperties();
        setAllFromCurrent();
        mClassSetting--;
    }

    private void setAllFromCurrent() /* allneeded*/
    {
        mClassSetting++;
        jComboBoxKlasse.setSelectedItem(mProjectProperties.mClass);
        jTextFieldKlasse.setText(mProjectProperties.mClass);
        jComboBoxName.setSelectedItem(mProjectProperties.mName);
        jTextFieldName.setText(mProjectProperties.mName);

        jCheckBoxCProject.setSelected(mProjectProperties.mIsCProject);
        jTextFieldCFLAGS.setText(mProjectProperties.mCFLAGS);

        jTextFieldAuthor.setText(mProjectProperties.mAuthor);
        jTextAreaDescription.setText(mProjectProperties.mDescription);
        jTextFieldPath.setText(mProjectProperties.mOldPath );
        jTextFieldProjectName.setText(mProjectProperties.mProjectName );
        if (!jCheckBoxCProject1.isSelected())
            jTextFieldMainFile.setText(mProjectProperties.mMainFile);
        jTextFieldVersion.setText(mProjectProperties.mVersion );
        jCheckBoxCreateSupportCode.setSelected(mProjectProperties.mcreateBankswitchCode);
        jCheckBoxCreateGameLoop.setSelected(mProjectProperties.mcreateGameLoopCode);

        if ((mProjectProperties.mBankswitching != null) && (mProjectProperties.mBankswitching.trim().length()!=0))
            jComboBoxBankswitch.setSelectedItem(mProjectProperties.mBankswitching);
        else
            jComboBoxBankswitch.setSelectedIndex(-1);

        if (mProjectProperties.mNumberOfBanks != 0)
            jComboBoxBankswitchNumber.setSelectedItem(""+mProjectProperties.mNumberOfBanks);
        else
            jComboBoxBankswitchNumber.setSelectedIndex(-1);

        jCheckBox1.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_VEC_VOICE) == Cartridge.FLAG_VEC_VOICE);
        jCheckBox2.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_DS2430A) == Cartridge.FLAG_DS2430A);
        jCheckBox16.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_MICROCHIP) == Cartridge.FLAG_MICROCHIP);
        jCheckBox3.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_LIGHTPEN1) == Cartridge.FLAG_LIGHTPEN1);
        jCheckBox4.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_LIGHTPEN2) == Cartridge.FLAG_LIGHTPEN2);
        jCheckBox5.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_IMAGER) == Cartridge.FLAG_IMAGER);
        jCheckBox6.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_EXTREME_MULTI) == Cartridge.FLAG_EXTREME_MULTI);
        jCheckBox7.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_VEC_VOX) == Cartridge.FLAG_VEC_VOX);
        jCheckBox8.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_DS2431) == Cartridge.FLAG_DS2431);
        jCheckBox9.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_SID) == Cartridge.FLAG_SID);
        jCheckBox10.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_48K) == Cartridge.FLAG_48K);
        jCheckBoxFlashSupport.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_FLASH_SUPPORT) == Cartridge.FLAG_FLASH_SUPPORT);

        jCheckBoxCProject1.setSelected(mProjectProperties.mIsPeerCProject);
        
        jComboBoxImager.setEnabled(jCheckBox5.isSelected());
        if (jCheckBox5.isSelected())
        {
            jComboBoxImager.setSelectedIndex(-1);
            if (mProjectProperties.mWheelName != null)
            {
                for (int i=0; i< jComboBoxImager.getItemCount(); i++)
                {
                    if (jComboBoxImager.getItemAt(i).toString().equals(mProjectProperties.mWheelName))
                    {
                        jComboBoxImager.setSelectedIndex(i);
                        break;
                    }
                }
            }
        }
        
        jCheckBoxCPeepholing.setEnabled(jCheckBoxCProject1.isSelected());
        jCheckBoxCDebugging.setEnabled(jCheckBoxCProject1.isSelected());
        jCheckBoxCKeepEnriched.setEnabled(jCheckBoxCProject1.isSelected());
        jCheckBoxCRumInlined.setEnabled(jCheckBoxCProject1.isSelected());
        
        
        jCheckBoxCDebugging.setSelected(mProjectProperties.mCDebugging);
        jCheckBoxCPeepholing.setSelected(mProjectProperties.mCPeephole);
        jCheckBoxCKeepEnriched.setSelected(mProjectProperties.mCKeepEnriched);
        jCheckBoxCRumInlined.setSelected(mProjectProperties.mCRumInlined);

        
        enableASM(!mProjectProperties.mIsPeerCProject);
        initScripts();

        mClassSetting--;
    }

    private void readAllToCurrent() /* allneeded*/
    {
        
        mProjectProperties.mCDebugging = jCheckBoxCDebugging.isSelected();
        mProjectProperties.mCPeephole = jCheckBoxCPeepholing.isSelected();
        mProjectProperties.mCKeepEnriched = jCheckBoxCKeepEnriched.isSelected();
        mProjectProperties.mCRumInlined = jCheckBoxCRumInlined.isSelected();
        
        
        
        mProjectProperties.mClass = "Project";
        mProjectProperties.mName = jTextFieldProjectName.getText();

        mProjectProperties.mIsCProject = jCheckBoxCProject.isSelected();
        mProjectProperties.mIsPeerCProject = jCheckBoxCProject1.isSelected();
        
        mProjectProperties.mCFLAGS = jTextFieldCFLAGS.getText();
        
        
        mProjectProperties.mAuthor = jTextFieldAuthor.getText();
        mProjectProperties.mDescription = jTextAreaDescription.getText();
        mProjectProperties.mDirectoryName = "";
        mProjectProperties.mOldPath = de.malban.util.Utility.makeVideRelative(jTextFieldPath.getText());

        mProjectProperties.mProjectName = jTextFieldProjectName.getText();
        mProjectProperties.mMainFile = jTextFieldMainFile.getText();
        mProjectProperties.mVersion = jTextFieldVersion.getText();
        if (jComboBoxBankswitch.getSelectedItem() != null)  
            mProjectProperties.mBankswitching = jComboBoxBankswitch.getSelectedItem().toString();
        else
            mProjectProperties.mBankswitching = "none";
        if (jComboBoxBankswitchNumber.getSelectedItem() != null)
            mProjectProperties.mNumberOfBanks = Integer.parseInt(jComboBoxBankswitchNumber.getSelectedItem().toString());
        else
            mProjectProperties.mNumberOfBanks = 1;
        
        mProjectProperties.mcreateBankswitchCode = jCheckBoxCreateSupportCode.isSelected();
        mProjectProperties.mcreateGameLoopCode = jCheckBoxCreateGameLoop.isSelected();
        
        mProjectProperties.mProjectPreScriptClass = "";
        if (jComboBoxPreClass.getSelectedIndex()!=-1)
            mProjectProperties.mProjectPreScriptClass = jComboBoxPreClass.getSelectedItem().toString();
        mProjectProperties.mProjectPreScriptName = "";
        if (jComboBoxPreName.getSelectedIndex()!=-1)
            mProjectProperties.mProjectPreScriptName = jComboBoxPreName.getSelectedItem().toString();
                
        mProjectProperties.mProjectPostScriptClass = "";
        if (jComboBoxPostClass.getSelectedIndex()!=-1)
            mProjectProperties.mProjectPostScriptClass = jComboBoxPostClass.getSelectedItem().toString();
        mProjectProperties.mProjectPostScriptName = "";
        if (jComboBoxPostName.getSelectedIndex()!=-1)
            mProjectProperties.mProjectPostScriptName = jComboBoxPostName.getSelectedItem().toString();
                
        if (mProjectProperties.mBankswitching.equals("none")) // none
        {
            mProjectProperties.mBankMainFiles.clear();
            mProjectProperties.mBankMainFiles.addElement(mProjectProperties.mMainFile);
            mProjectProperties.mBankDefines.clear();
            mProjectProperties.mBankDefines.addElement("");
        }

        mProjectProperties.mWheelName ="";
        if (jCheckBox5.isSelected())
        {
            if (jComboBoxImager.getSelectedIndex()>=0)
            {
                mProjectProperties.mWheelName = jComboBoxImager.getSelectedItem().toString();
            }
        }
        int extra = 0;
        if (jCheckBox1.isSelected()) extra+= Cartridge.FLAG_VEC_VOICE;
        if (jCheckBox2.isSelected()) extra+= Cartridge.FLAG_DS2430A;
        if (jCheckBox16.isSelected()) extra+= Cartridge.FLAG_MICROCHIP;
        if (jCheckBox3.isSelected()) extra+= Cartridge.FLAG_LIGHTPEN1;
        if (jCheckBox4.isSelected()) extra+= Cartridge.FLAG_LIGHTPEN2;
        if (jCheckBox5.isSelected()) extra+= Cartridge.FLAG_IMAGER;
        if (jCheckBox6.isSelected()) extra+= Cartridge.FLAG_EXTREME_MULTI;
        if (jCheckBox7.isSelected()) extra+= Cartridge.FLAG_VEC_VOX;
        if (jCheckBox8.isSelected()) extra+= Cartridge.FLAG_DS2431;
        if (jCheckBox9.isSelected()) extra+= Cartridge.FLAG_SID;
        if (jCheckBox10.isSelected()) extra+= Cartridge.FLAG_48K;
        if (jCheckBoxFlashSupport.isSelected()) extra+= Cartridge.FLAG_FLASH_SUPPORT;
        
        if (jComboBoxBankswitch.getSelectedIndex()==2)
            extra+= Cartridge.FLAG_BS_PB6_IRQ;
        
        
        mProjectProperties.mExtras = extra;
    }
    
    private ProjectProperties getProject()
    {
        return mProjectProperties;
    }
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel6 = new javax.swing.JPanel();
        jTextFieldPath = new javax.swing.JTextField();
        jTextFieldVersion = new javax.swing.JTextField();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTextAreaDescription = new javax.swing.JTextArea();
        jLabel2 = new javax.swing.JLabel();
        jTextFieldAuthor = new javax.swing.JTextField();
        jButtonFileSelect1 = new javax.swing.JButton();
        jLabel7 = new javax.swing.JLabel();
        jTextFieldProjectName = new javax.swing.JTextField();
        jTextFieldMainFile = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel1 = new javax.swing.JLabel();
        jComboBoxBankswitch = new javax.swing.JComboBox();
        jCheckBoxCreateSupportCode = new javax.swing.JCheckBox();
        jComboBoxBankswitchNumber = new javax.swing.JComboBox();
        jPanel1 = new javax.swing.JPanel();
        jComboBoxKlasse = new javax.swing.JComboBox();
        jComboBoxName = new javax.swing.JComboBox();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jTextFieldName = new javax.swing.JTextField();
        jTextFieldKlasse = new javax.swing.JTextField();
        jButtonNew = new javax.swing.JButton();
        jButtonSave = new javax.swing.JButton();
        jButtonSaveAsNew = new javax.swing.JButton();
        jButtonDelete = new javax.swing.JButton();
        jPanel5 = new javax.swing.JPanel();
        jCheckBox1 = new javax.swing.JCheckBox();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox3 = new javax.swing.JCheckBox();
        jCheckBox4 = new javax.swing.JCheckBox();
        jCheckBox5 = new javax.swing.JCheckBox();
        jCheckBox6 = new javax.swing.JCheckBox();
        jCheckBox7 = new javax.swing.JCheckBox();
        jCheckBox16 = new javax.swing.JCheckBox();
        jComboBoxImager = new javax.swing.JComboBox();
        jCheckBox8 = new javax.swing.JCheckBox();
        jCheckBox9 = new javax.swing.JCheckBox();
        jCheckBox10 = new javax.swing.JCheckBox();
        jCheckBoxCDebugging = new javax.swing.JCheckBox();
        jCheckBoxCPeepholing = new javax.swing.JCheckBox();
        jCheckBoxCKeepEnriched = new javax.swing.JCheckBox();
        jCheckBoxCRumInlined = new javax.swing.JCheckBox();
        jCheckBoxFlashSupport = new javax.swing.JCheckBox();
        jButtonPre = new javax.swing.JButton();
        jLabel6 = new javax.swing.JLabel();
        jComboBoxPostName = new javax.swing.JComboBox();
        jLabel10 = new javax.swing.JLabel();
        jComboBoxPostClass = new javax.swing.JComboBox();
        jButtonPost = new javax.swing.JButton();
        jComboBoxPreClass = new javax.swing.JComboBox();
        jComboBoxPreName = new javax.swing.JComboBox();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jButtonCreate = new javax.swing.JButton();
        jButtonCancel = new javax.swing.JButton();
        jCheckBoxCreateGameLoop = new javax.swing.JCheckBox();
        jCheckBoxCProject = new javax.swing.JCheckBox();
        jTextFieldCFLAGS = new javax.swing.JTextField();
        jLabel11 = new javax.swing.JLabel();
        jCheckBoxCProject1 = new javax.swing.JCheckBox();

        setPreferredSize(new java.awt.Dimension(900, 500));

        jTextFieldPath.setPreferredSize(new java.awt.Dimension(6, 21));

        jTextFieldVersion.setText("1.0");
        jTextFieldVersion.setPreferredSize(new java.awt.Dimension(22, 21));

        jTextAreaDescription.setColumns(20);
        jTextAreaDescription.setRows(5);
        jScrollPane1.setViewportView(jTextAreaDescription);

        jLabel2.setText("Version");

        jTextFieldAuthor.setPreferredSize(new java.awt.Dimension(6, 21));

        jButtonFileSelect1.setText("...");
        jButtonFileSelect1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect1.setPreferredSize(new java.awt.Dimension(17, 21));
        jButtonFileSelect1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect1ActionPerformed(evt);
            }
        });

        jLabel7.setText("Path");

        jTextFieldProjectName.setPreferredSize(new java.awt.Dimension(6, 21));
        jTextFieldProjectName.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldProjectNameFocusLost(evt);
            }
        });
        jTextFieldProjectName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldProjectNameActionPerformed(evt);
            }
        });
        jTextFieldProjectName.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldProjectNameKeyReleased(evt);
            }
        });

        jTextFieldMainFile.setPreferredSize(new java.awt.Dimension(6, 21));

        jLabel5.setText("Name");

        jLabel8.setText("Main file");

        jLabel9.setText("Author");

        jLabel1.setText("Description");

        jComboBoxBankswitch.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "none", "2 bank standard", "4 bank PB6/IRQ", "VecFlash (up to 32 banks)" }));
        jComboBoxBankswitch.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxBankswitchActionPerformed(evt);
            }
        });

        jCheckBoxCreateSupportCode.setText("create bankswitch code");

        jComboBoxBankswitchNumber.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "1" }));
        jComboBoxBankswitchNumber.setEnabled(false);
        jComboBoxBankswitchNumber.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxBankswitchNumberActionPerformed(evt);
            }
        });

        jPanel1.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jComboBoxKlasse.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxKlasseActionPerformed(evt);
            }
        });

        jComboBoxName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxNameActionPerformed(evt);
            }
        });

        jLabel3.setText("Name");

        jLabel4.setText("Class");

        jButtonNew.setText("New");
        jButtonNew.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewActionPerformed(evt);
            }
        });

        jButtonSave.setText("Save");
        jButtonSave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveActionPerformed(evt);
            }
        });

        jButtonSaveAsNew.setText("Save as new");
        jButtonSaveAsNew.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveAsNewActionPerformed(evt);
            }
        });

        jButtonDelete.setText("Delete");
        jButtonDelete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDeleteActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel4)
                    .addComponent(jLabel3))
                .addGap(16, 16, 16)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jTextFieldName, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 24, Short.MAX_VALUE)
                    .addComponent(jTextFieldKlasse, javax.swing.GroupLayout.Alignment.LEADING))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jComboBoxKlasse, 0, 46, Short.MAX_VALUE)
                    .addComponent(jComboBoxName, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonSave)
                    .addComponent(jButtonNew))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonSaveAsNew)
                    .addComponent(jButtonDelete))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jButtonDelete)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButtonSave)
                            .addComponent(jButtonSaveAsNew)))
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addGroup(jPanel1Layout.createSequentialGroup()
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jComboBoxKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jButtonNew))
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jComboBoxName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel1Layout.createSequentialGroup()
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel4)
                                .addComponent(jTextFieldKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel3)
                                .addComponent(jTextFieldName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))))
        );

        jCheckBox1.setText("VecVoice");

        jCheckBox2.setText("DS2430A");
        jCheckBox2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox2ActionPerformed(evt);
            }
        });

        jCheckBox3.setText("Lightpen Port 1");
        jCheckBox3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox3ActionPerformed(evt);
            }
        });

        jCheckBox4.setText("Lightpen Port 2");
        jCheckBox4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox4ActionPerformed(evt);
            }
        });

        jCheckBox5.setText("3d Imager");
        jCheckBox5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox5ActionPerformed(evt);
            }
        });

        jCheckBox6.setText("extreme multi");
        jCheckBox6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox6ActionPerformed(evt);
            }
        });

        jCheckBox7.setText("VecVox");

        jCheckBox16.setText("Microchip 11AA010");
        jCheckBox16.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox16ActionPerformed(evt);
            }
        });

        jComboBoxImager.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxImagerActionPerformed(evt);
            }
        });

        jCheckBox8.setText("DS2431");
        jCheckBox8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox8ActionPerformed(evt);
            }
        });

        jCheckBox9.setText("SID");
        jCheckBox9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox9ActionPerformed(evt);
            }
        });

        jCheckBox10.setText("48k ROM");
        jCheckBox10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox10ActionPerformed(evt);
            }
        });

        jCheckBoxCDebugging.setText("C debugging");
        jCheckBoxCDebugging.setEnabled(false);
        jCheckBoxCDebugging.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxCDebuggingActionPerformed(evt);
            }
        });

        jCheckBoxCPeepholing.setText("C peepholing");
        jCheckBoxCPeepholing.setEnabled(false);
        jCheckBoxCPeepholing.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxCPeepholingActionPerformed(evt);
            }
        });

        jCheckBoxCKeepEnriched.setText("C keep enriched");
        jCheckBoxCKeepEnriched.setEnabled(false);
        jCheckBoxCKeepEnriched.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxCKeepEnrichedActionPerformed(evt);
            }
        });

        jCheckBoxCRumInlined.setText("C Rum inlined");
        jCheckBoxCRumInlined.setToolTipText("<html>\nRum functions inlined -> checked<BR>\nRum functions as \"functions\" -> not checked!\n</html>");
        jCheckBoxCRumInlined.setEnabled(false);
        jCheckBoxCRumInlined.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxCRumInlinedActionPerformed(evt);
            }
        });

        jCheckBoxFlashSupport.setText("Flash support");
        jCheckBoxFlashSupport.setToolTipText("SST39SF020A - and only \"barely\"");
        jCheckBoxFlashSupport.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxFlashSupportActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox2)
                            .addComponent(jCheckBox1)
                            .addComponent(jCheckBox7))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox10, javax.swing.GroupLayout.PREFERRED_SIZE, 93, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBox9)
                            .addComponent(jCheckBoxFlashSupport, javax.swing.GroupLayout.PREFERRED_SIZE, 134, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox6)
                            .addComponent(jCheckBox5))
                        .addGap(30, 30, 30)
                        .addComponent(jComboBoxImager, javax.swing.GroupLayout.PREFERRED_SIZE, 109, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jCheckBoxCRumInlined)
                    .addComponent(jCheckBoxCDebugging)
                    .addComponent(jCheckBox8)
                    .addComponent(jCheckBox4)
                    .addComponent(jCheckBox3)
                    .addComponent(jCheckBox16)
                    .addComponent(jCheckBoxCKeepEnriched)
                    .addComponent(jCheckBoxCPeepholing))
                .addContainerGap(18, Short.MAX_VALUE))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox1)
                    .addComponent(jCheckBox9))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox7)
                    .addComponent(jCheckBox10))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox2)
                    .addComponent(jCheckBoxFlashSupport))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox16)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox4)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox6))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGap(1, 1, 1)
                        .addComponent(jComboBoxImager, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox8)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBoxCDebugging)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBoxCPeepholing)
                .addGap(0, 0, 0)
                .addComponent(jCheckBoxCKeepEnriched, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBoxCRumInlined)
                .addContainerGap(49, Short.MAX_VALUE))
        );

        jButtonPre.setText("script");
        jButtonPre.setPreferredSize(new java.awt.Dimension(90, 21));
        jButtonPre.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPreActionPerformed(evt);
            }
        });

        jLabel6.setText("Pre build commands");

        jComboBoxPostName.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));

        jLabel10.setText("Post build commands");

        jComboBoxPostClass.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPostClass.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxPostClassActionPerformed(evt);
            }
        });

        jButtonPost.setText("script");
        jButtonPost.setPreferredSize(new java.awt.Dimension(90, 21));
        jButtonPost.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPostActionPerformed(evt);
            }
        });

        jComboBoxPreClass.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPreClass.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                jComboBoxPreClassItemStateChanged(evt);
            }
        });

        jComboBoxPreName.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));

        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null},
                {null},
                {null},
                {null}
            },
            new String [] {
                "Main for Bank"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jTable1.setAutoResizeMode(javax.swing.JTable.AUTO_RESIZE_LAST_COLUMN);
        jScrollPane2.setViewportView(jTable1);

        jButtonCreate.setText("create");
        jButtonCreate.setName("create"); // NOI18N
        jButtonCreate.setPreferredSize(new java.awt.Dimension(63, 21));
        jButtonCreate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCreateActionPerformed(evt);
            }
        });

        jButtonCancel.setText("cancel");
        jButtonCancel.setName("cancel"); // NOI18N
        jButtonCancel.setPreferredSize(new java.awt.Dimension(63, 21));
        jButtonCancel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCancelActionPerformed(evt);
            }
        });

        jCheckBoxCreateGameLoop.setText("create game loop");

        jCheckBoxCProject.setText("C - Project");
        jCheckBoxCProject.setEnabled(false);
        jCheckBoxCProject.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxCProjectActionPerformed(evt);
            }
        });

        jTextFieldCFLAGS.setText("-O3 -mint8 -msoft-reg-count=0 -quiet -IC/include");
        jTextFieldCFLAGS.setPreferredSize(new java.awt.Dimension(6, 21));

        jLabel11.setText("CFLAGS");

        jCheckBoxCProject1.setText("PeerC - Project");
        jCheckBoxCProject1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxCProject1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel6Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel6Layout.createSequentialGroup()
                                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel5)
                                    .addComponent(jLabel7)
                                    .addComponent(jLabel8)
                                    .addComponent(jLabel9)
                                    .addComponent(jLabel1))
                                .addGap(61, 61, 61)
                                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPanel6Layout.createSequentialGroup()
                                        .addGap(2, 2, 2)
                                        .addComponent(jLabel11)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jTextFieldCFLAGS, javax.swing.GroupLayout.PREFERRED_SIZE, 340, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addComponent(jTextFieldMainFile, javax.swing.GroupLayout.PREFERRED_SIZE, 169, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextFieldAuthor, javax.swing.GroupLayout.PREFERRED_SIZE, 169, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel6Layout.createSequentialGroup()
                                        .addComponent(jCheckBoxCProject)
                                        .addGap(43, 43, 43)
                                        .addComponent(jCheckBoxCProject1))
                                    .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                        .addGroup(jPanel6Layout.createSequentialGroup()
                                            .addComponent(jTextFieldPath, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                            .addComponent(jButtonFileSelect1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel6Layout.createSequentialGroup()
                                            .addComponent(jTextFieldProjectName, javax.swing.GroupLayout.PREFERRED_SIZE, 169, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addGap(51, 51, 51)
                                            .addComponent(jLabel2)
                                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                            .addComponent(jTextFieldVersion, javax.swing.GroupLayout.PREFERRED_SIZE, 58, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 401, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 400, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(jPanel6Layout.createSequentialGroup()
                                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel6)
                                    .addComponent(jLabel10))
                                .addGap(6, 6, 6)
                                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPanel6Layout.createSequentialGroup()
                                        .addComponent(jComboBoxPostName, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jComboBoxPostClass, javax.swing.GroupLayout.PREFERRED_SIZE, 116, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButtonPost, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(jPanel6Layout.createSequentialGroup()
                                        .addComponent(jComboBoxPreName, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jComboBoxPreClass, javax.swing.GroupLayout.PREFERRED_SIZE, 116, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButtonPre, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(jPanel6Layout.createSequentialGroup()
                                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jCheckBoxCreateSupportCode)
                                            .addComponent(jCheckBoxCreateGameLoop))
                                        .addGap(100, 100, 100)
                                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jComboBoxBankswitchNumber, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jComboBoxBankswitch, javax.swing.GroupLayout.PREFERRED_SIZE, 138, javax.swing.GroupLayout.PREFERRED_SIZE))))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel6Layout.createSequentialGroup()
                                .addComponent(jButtonCancel, javax.swing.GroupLayout.PREFERRED_SIZE, 77, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(87, 87, 87)
                                .addComponent(jButtonCreate, javax.swing.GroupLayout.PREFERRED_SIZE, 74, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                .addGap(0, 109, Short.MAX_VALUE))
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldVersion, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldProjectName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel2)
                            .addComponent(jLabel5))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldPath, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonFileSelect1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel7))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldMainFile, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel8))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldAuthor, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel9))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel1)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 85, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxCProject1)
                            .addComponent(jCheckBoxCProject))
                        .addGap(9, 9, 9)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldCFLAGS, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel11))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jComboBoxPreName, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jComboBoxPreClass, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel6, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jButtonPre, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jComboBoxPostClass, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonPost, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jComboBoxPostName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel10)))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jComboBoxBankswitch, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxCreateSupportCode))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel6Layout.createSequentialGroup()
                                .addComponent(jCheckBoxCreateGameLoop)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 82, Short.MAX_VALUE))
                            .addGroup(jPanel6Layout.createSequentialGroup()
                                .addComponent(jComboBoxBankswitchNumber, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 0, Short.MAX_VALUE))))
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButtonCancel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonCreate, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 8, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(13, 13, 13))
        );

        jTabbedPane1.addTab("Project settings", jPanel6);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewActionPerformed
        mClassSetting++;
        mProjectProperties = new ProjectProperties();
        clearAll();
        resetConfigPool(false, "");
        mClassSetting--;
}//GEN-LAST:event_jButtonNewActionPerformed

    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed

        readAllToCurrent();
        
        mProjectPropertiesPool.put(mProjectProperties);
        mProjectPropertiesPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true, klasse);
        jComboBoxName.setSelectedItem(mProjectProperties.mName);
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveActionPerformed

    private void jButtonSaveAsNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveAsNewActionPerformed
        mProjectProperties = new ProjectProperties();
        readAllToCurrent();
        mProjectPropertiesPool.putAsNew(mProjectProperties);
        mProjectPropertiesPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true,klasse);
        jComboBoxName.setSelectedItem(mProjectProperties.mName);
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveAsNewActionPerformed

    private void jButtonDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteActionPerformed
        readAllToCurrent();
        mProjectPropertiesPool.remove(mProjectProperties);
        mProjectPropertiesPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true,klasse);

        if (jComboBoxName.getSelectedIndex() == -1)
        {
            clearAll();
        }

        String key = jComboBoxName.getSelectedItem().toString();
        mProjectProperties = mProjectPropertiesPool.get(key);
        setAllFromCurrent();

        mClassSetting--;
}//GEN-LAST:event_jButtonDeleteActionPerformed

    private void jComboBoxKlasseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxKlasseActionPerformed
        if (mClassSetting >0 ) return;
        mClassSetting++;;

        String selected = jComboBoxKlasse.getSelectedItem().toString();
        clearAll();
        resetConfigPool(true, selected);
        jTextFieldKlasse.setText(jComboBoxKlasse.getSelectedItem().toString());
        String key = jComboBoxName.getSelectedItem().toString();
        mProjectProperties = mProjectPropertiesPool.get(key);
        setAllFromCurrent();
        mClassSetting--;
    }//GEN-LAST:event_jComboBoxKlasseActionPerformed

    private void jComboBoxNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxNameActionPerformed
        if (mClassSetting > 0 ) return;
        String key = jComboBoxName.getSelectedItem().toString();
        mProjectProperties = mProjectPropertiesPool.get(key);
        setAllFromCurrent();
    }//GEN-LAST:event_jComboBoxNameActionPerformed

    private void jButtonFileSelect1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect1ActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setDialogTitle("Select project parent directory");
        fc.setCurrentDirectory(new java.io.File(Global.mainPathPrefix));
        fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String lastPath = fc.getSelectedFile().getAbsolutePath();
        
        Path p = Paths.get(lastPath);
        
        jTextFieldPath.setText(p.toString());
        
    }//GEN-LAST:event_jButtonFileSelect1ActionPerformed

    private void jButtonCreateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCreateActionPerformed
        deinit();
    }//GEN-LAST:event_jButtonCreateActionPerformed

    private void jTextFieldProjectNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldProjectNameActionPerformed
        if (!wasMainSetManually)
        {
            if (!jCheckBoxCProject1.isSelected())
                jTextFieldMainFile.setText(jTextFieldProjectName.getText()+".asm");            
        }

    }//GEN-LAST:event_jTextFieldProjectNameActionPerformed

    private void jTextFieldProjectNameKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldProjectNameKeyReleased
        if (!wasMainSetManually)
        {
            if (!jCheckBoxCProject1.isSelected())
                jTextFieldMainFile.setText(jTextFieldProjectName.getText()+".asm");            
        }
        
    }//GEN-LAST:event_jTextFieldProjectNameKeyReleased

    private void jTextFieldProjectNameFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldProjectNameFocusLost
        if (!wasMainSetManually)
        {
            if (!jCheckBoxCProject1.isSelected())
                jTextFieldMainFile.setText(jTextFieldProjectName.getText()+".asm");            
        }
        
    }//GEN-LAST:event_jTextFieldProjectNameFocusLost

    private void jComboBoxBankswitchNumberActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxBankswitchNumberActionPerformed
        adjustMains();
    }//GEN-LAST:event_jComboBoxBankswitchNumberActionPerformed

    private void jComboBoxBankswitchActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxBankswitchActionPerformed
        if (jComboBoxBankswitch.getSelectedIndex()==0)
        {
            jComboBoxBankswitchNumber.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "1" }));
            jComboBoxBankswitchNumber.setEnabled(false);
        }
        if (jComboBoxBankswitch.getSelectedIndex()==1)
        {
            jComboBoxBankswitchNumber.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "2" }));
            jComboBoxBankswitchNumber.setEnabled(false);
        }
        if (jComboBoxBankswitch.getSelectedIndex()==2)
        {
            String[] s = new String[4];
            for (int i=0;i<=3; i++)
                s[i]=""+(i+1);
            jComboBoxBankswitchNumber.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "4" }));
            jComboBoxBankswitchNumber.setEnabled(false);
        }
        if (jComboBoxBankswitch.getSelectedIndex()==3)
        {
            String[] s = new String[32];
            for (int i=0;i<=31; i++)
                s[i]=""+(i+1);
            jComboBoxBankswitchNumber.setModel(new javax.swing.DefaultComboBoxModel(s));
            jComboBoxBankswitchNumber.setEnabled(true);
        }
        adjustMains();
    }//GEN-LAST:event_jComboBoxBankswitchActionPerformed

    private void jCheckBox3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox3ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox3ActionPerformed

    private void jCheckBox4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox4ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox4ActionPerformed

    private void jCheckBox5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox5ActionPerformed
        jComboBoxImager.setEnabled(jCheckBox5.isSelected());
    }//GEN-LAST:event_jCheckBox5ActionPerformed

    private void jCheckBox6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox6ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox6ActionPerformed

    private void jButtonPreActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPreActionPerformed
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ScriptDataPanel sdp = new ScriptDataPanel();
        ModalInternalFrame modal=null;
        
        String pp = convertSeperator(mProjectProperties.getOldPath());
        if (pp.length() >0 ) pp += File.separator;
        pp += mProjectProperties.getProjectName();
        
        ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_PRE, mProjectProperties.mProjectName, "", "ProjectPropertiesPanel", de.malban.util.Utility.makeVideAbsolute(pp));
        sdp.setSelected(mProjectProperties.mProjectPreScriptClass, mProjectProperties.mProjectPreScriptName, ed);
        modal = new ModalInternalFrame("Scripter", frame.getRootPane(), frame, sdp, "done");
        modal.setVisible(true);        
        
        mProjectProperties.mProjectPreScriptClass = sdp.getSelectedClass();
        mProjectProperties.mProjectPreScriptName = sdp.getSelectedName();
        initScripts();
    }//GEN-LAST:event_jButtonPreActionPerformed

    private void jButtonPostActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPostActionPerformed
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ScriptDataPanel sdp = new ScriptDataPanel();
        ModalInternalFrame modal=null;
        String pp = convertSeperator(mProjectProperties.getOldPath());
        if (pp.length() >0 ) pp += File.separator;
        pp += mProjectProperties.getProjectName();
        ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_POST, mProjectProperties.mProjectName, "", "ProjectPropertiesPanel", pp);
        sdp.setSelected(mProjectProperties.mProjectPostScriptClass, mProjectProperties.mProjectPostScriptName, ed);
        modal = new ModalInternalFrame("Scripter", frame.getRootPane(), frame, sdp, "done");
        modal.setVisible(true);        
        
        mProjectProperties.mProjectPostScriptClass = sdp.getSelectedClass();
        mProjectProperties.mProjectPostScriptName = sdp.getSelectedName();
        initScripts();
    }//GEN-LAST:event_jButtonPostActionPerformed

    private void jComboBoxPreClassItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_jComboBoxPreClassItemStateChanged
        if (mClassSetting>0) return;
        if (jComboBoxPreClass.getSelectedIndex()!= -1)
            mProjectProperties.mProjectPreScriptClass = jComboBoxPreClass.getSelectedItem().toString();
        else
            mProjectProperties.mProjectPreScriptClass = "";
        initScripts();
    }//GEN-LAST:event_jComboBoxPreClassItemStateChanged

    private void jComboBoxPostClassActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxPostClassActionPerformed
        if (mClassSetting>0) return;
        if (jComboBoxPostClass.getSelectedIndex()!= -1)
            mProjectProperties.mProjectPostScriptClass = jComboBoxPostClass.getSelectedItem().toString();
        else
            mProjectProperties.mProjectPostScriptClass = "";
        initScripts();
    }//GEN-LAST:event_jComboBoxPostClassActionPerformed

    private void jCheckBox2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox2ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox2ActionPerformed

    private void jCheckBox16ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox16ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox16ActionPerformed

    private void jCheckBox8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox8ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox8ActionPerformed

    private void jButtonCancelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCancelActionPerformed
        deinit();
    }//GEN-LAST:event_jButtonCancelActionPerformed

    private void jCheckBox9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox9ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox9ActionPerformed

    private void jComboBoxImagerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxImagerActionPerformed
        if (mClassSetting>0) return;
        // TODO add your handling code here:
    }//GEN-LAST:event_jComboBoxImagerActionPerformed

    private void jCheckBoxCProjectActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxCProjectActionPerformed
        mClassSetting++;
        jCheckBoxCProject1.setSelected(!jCheckBoxCProject.isSelected());
        mClassSetting--;
    }//GEN-LAST:event_jCheckBoxCProjectActionPerformed

    private void jCheckBoxCProject1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxCProject1ActionPerformed
        if (mClassSetting>0) return;
        mClassSetting++;
        if (jCheckBoxCProject1.isSelected())
        {
            jTextFieldMainFile.setText("");
            jCheckBoxCProject.setSelected(false);
        }
        jCheckBoxCPeepholing.setEnabled(jCheckBoxCProject1.isSelected());
        jCheckBoxCDebugging.setEnabled(jCheckBoxCProject1.isSelected());
        jCheckBoxCKeepEnriched.setEnabled(jCheckBoxCProject1.isSelected());
        jCheckBoxCRumInlined.setEnabled(jCheckBoxCProject1.isSelected());
        
        mClassSetting--;
        jTextFieldCFLAGS.setText("-quiet -fno-gcse -fverbose-asm -W -Wall -Wextra -Wconversion -Werror -fomit-frame-pointer -fno-toplevel-reorder -mint8 -msoft-reg-count=0 -std=gnu99 -fno-time-report -IC/PeerC/vectrex/include");
        
        enableASM(!jCheckBoxCProject1.isSelected());
        
    }//GEN-LAST:event_jCheckBoxCProject1ActionPerformed

    private void jCheckBoxCDebuggingActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxCDebuggingActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxCDebuggingActionPerformed

    private void jCheckBox10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox10ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox10ActionPerformed

    private void jCheckBoxCPeepholingActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxCPeepholingActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxCPeepholingActionPerformed

    private void jCheckBoxCKeepEnrichedActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxCKeepEnrichedActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxCKeepEnrichedActionPerformed

    private void jCheckBoxCRumInlinedActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxCRumInlinedActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxCRumInlinedActionPerformed

    private void jCheckBoxFlashSupportActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxFlashSupportActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxFlashSupportActionPerformed

    boolean wasMainSetManually = false;

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonCancel;
    private javax.swing.JButton jButtonCreate;
    private javax.swing.JButton jButtonDelete;
    private javax.swing.JButton jButtonFileSelect1;
    private javax.swing.JButton jButtonNew;
    private javax.swing.JButton jButtonPost;
    private javax.swing.JButton jButtonPre;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JButton jButtonSaveAsNew;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox10;
    private javax.swing.JCheckBox jCheckBox16;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JCheckBox jCheckBox5;
    private javax.swing.JCheckBox jCheckBox6;
    private javax.swing.JCheckBox jCheckBox7;
    private javax.swing.JCheckBox jCheckBox8;
    private javax.swing.JCheckBox jCheckBox9;
    private javax.swing.JCheckBox jCheckBoxCDebugging;
    private javax.swing.JCheckBox jCheckBoxCKeepEnriched;
    private javax.swing.JCheckBox jCheckBoxCPeepholing;
    private javax.swing.JCheckBox jCheckBoxCProject;
    private javax.swing.JCheckBox jCheckBoxCProject1;
    private javax.swing.JCheckBox jCheckBoxCRumInlined;
    private javax.swing.JCheckBox jCheckBoxCreateGameLoop;
    private javax.swing.JCheckBox jCheckBoxCreateSupportCode;
    private javax.swing.JCheckBox jCheckBoxFlashSupport;
    private javax.swing.JComboBox jComboBoxBankswitch;
    private javax.swing.JComboBox jComboBoxBankswitchNumber;
    private javax.swing.JComboBox jComboBoxImager;
    private javax.swing.JComboBox jComboBoxKlasse;
    private javax.swing.JComboBox jComboBoxName;
    private javax.swing.JComboBox jComboBoxPostClass;
    private javax.swing.JComboBox jComboBoxPostName;
    private javax.swing.JComboBox jComboBoxPreClass;
    private javax.swing.JComboBox jComboBoxPreName;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JTextArea jTextAreaDescription;
    private javax.swing.JTextField jTextFieldAuthor;
    private javax.swing.JTextField jTextFieldCFLAGS;
    private javax.swing.JTextField jTextFieldKlasse;
    private javax.swing.JTextField jTextFieldMainFile;
    private javax.swing.JTextField jTextFieldName;
    private javax.swing.JTextField jTextFieldPath;
    private javax.swing.JTextField jTextFieldProjectName;
    private javax.swing.JTextField jTextFieldVersion;
    // End of variables declaration//GEN-END:variables

    
    // returns new Properties, not saved yet!
    ModalInternalFrame modelDialog;
    public static ProjectProperties showNewProjectProperties()
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ProjectPropertiesPanel panel = new ProjectPropertiesPanel();
        
        ArrayList<JButton> eb= new ArrayList<JButton>();
        eb.add(panel.jButtonCreate);
        eb.add(panel.jButtonCancel);
        ModalInternalFrame modal = new ModalInternalFrame("New project", frame.getRootPane(), frame, panel,null, null , eb);
        panel.modelDialog = modal;
        modal.setVisible(true);
        String result = modal.getNamedExit();
        panel.deinit();
        if (result.equals("create"))
        {
            panel.readAllToCurrent();
            return panel.getProject();
        }
        
        return null;
    }    
    public static ProjectProperties showEditProjectProperties(ProjectProperties currentProject)
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ProjectPropertiesPanel panel = new ProjectPropertiesPanel(currentProject);
        
        ArrayList<JButton> eb= new ArrayList<JButton>();
        eb.add(panel.jButtonCreate);
        eb.add(panel.jButtonCancel);
        ModalInternalFrame modal = new ModalInternalFrame(currentProject.mProjectName, frame.getRootPane(), frame, panel,null, null , eb);
        panel.modelDialog = modal;
        modal.setResizable(true);
 Rectangle b = modal.getBounds();
 b.width = 1024;
 b.height = 650;
 modal.setBounds(b);
        modal.setVisible(true);
        String result = modal.getNamedExit();
        panel.deinit();
        if (result.equals("ok"))
        {
            panel.readAllToCurrent();
            return panel.getProject();
        }
        
        return null;
    }
    void initScripts()
    {
        mExportDataPool = new ExportDataPool();
        String preClass = mProjectProperties.mProjectPreScriptClass;
        String preName = mProjectProperties.mProjectPreScriptName;

        mClassSetting++;
        Collection<String> collectionKlasse = mExportDataPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        int i = 0;
        String klasse = "";

        jComboBoxPreName.removeAllItems();
        jComboBoxPreClass.removeAllItems();
        jComboBoxPostName.removeAllItems();
        jComboBoxPostClass.removeAllItems();
        while (iterKlasse.hasNext())
        {
            String item = iterKlasse.next();
            jComboBoxPreClass.addItem(item);
            jComboBoxPostClass.addItem(item);
            i++;
        }
        if ((mProjectProperties.mProjectPreScriptClass!=null) && (mProjectProperties.mProjectPreScriptClass.length()!=0))
        {
            jComboBoxPreClass.setSelectedItem(mProjectProperties.mProjectPreScriptClass);
            Collection<ExportData> colC = mExportDataPool.getMapForKlasse(mProjectProperties.mProjectPreScriptClass).values();
            Iterator<ExportData> iterC = colC.iterator();
            /** Sorting */  Vector<String> nnames = new Vector<String>(); while (iterC.hasNext()) nnames.addElement(iterC.next().mName); Collections.sort(nnames, new Comparator<String>() {@Override
                public int compare(String s1, String s2) { return s1.compareTo(s2); } });
            jComboBoxPreName.addItem("");
            for (int j = 0; j < nnames.size(); j++)
            {
                String name = nnames.elementAt(j);
                jComboBoxPreName.addItem(name);
            }
            if ((mProjectProperties.mProjectPreScriptName!=null) && (mProjectProperties.mProjectPreScriptName.length()!=0))
            {
                jComboBoxPreName.setSelectedItem(mProjectProperties.mProjectPreScriptName);
            }
        }
        else
        {
            jComboBoxPreClass.setSelectedIndex(-1);
            jComboBoxPreName.setSelectedIndex(-1);
        }
        
        
        if ((mProjectProperties.mProjectPostScriptClass!=null) && (mProjectProperties.mProjectPostScriptClass.length()!=0))
        {
            jComboBoxPostClass.setSelectedItem(mProjectProperties.mProjectPostScriptClass);
            Collection<ExportData> colC = mExportDataPool.getMapForKlasse(mProjectProperties.mProjectPostScriptClass).values();
            Iterator<ExportData> iterC = colC.iterator();
            /** Sorting */  Vector<String> nnames = new Vector<String>(); while (iterC.hasNext()) nnames.addElement(iterC.next().mName); Collections.sort(nnames, new Comparator<String>() {@Override
                public int compare(String s1, String s2) { return s1.compareTo(s2); } });
            jComboBoxPostName.addItem("");
            for (int j = 0; j < nnames.size(); j++)
            {
                String name = nnames.elementAt(j);
                jComboBoxPostName.addItem(name);
            }
            if ((mProjectProperties.mProjectPostScriptName!=null) && (mProjectProperties.mProjectPostScriptName.length()!=0))
            {
                jComboBoxPostName.setSelectedItem(mProjectProperties.mProjectPostScriptName);
            }
        }
        else
        {
            jComboBoxPostClass.setSelectedIndex(-1);
            jComboBoxPostName.setSelectedIndex(-1);
        }
        
        mClassSetting--;
    }
    void initImager()
    {
        String path = Global.mainPathPrefix+"xml"+File.separator+"wheels";
        ArrayList<String> files = de.malban.util.UtilityFiles.getXMLFileList(path);
        jComboBoxImager.removeAllItems();
        for (String name: files)
        {
            jComboBoxImager.addItem(de.malban.util.UtilityString.replace(name.toLowerCase(), ".xml", ""));
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
        //SwingUtilities.updateComponentTreeUI(jPopupMenu1);
        //SwingUtilities.updateComponentTreeUI(jPopupMenuTree);
        //SwingUtilities.updateComponentTreeUI(jPopupMenuProjectProperties);
        int fontSize = Theme.textFieldFont.getFont().getSize();
        int rowHeight = fontSize+2;
        jTable1.setRowHeight(rowHeight);
    }
    public void deIconified()  {}
    void enableASM(boolean b)
    {
        jCheckBox1.setEnabled(b);
        jCheckBox2.setEnabled(b);
        jCheckBox16.setEnabled(b);
        jCheckBox3.setEnabled(b);
        jCheckBox4.setEnabled(b);
        jCheckBox5.setEnabled(b);
        jCheckBox6.setEnabled(b);
        jCheckBox7.setEnabled(b);
        jCheckBox8.setEnabled(b);
        jCheckBox9.setEnabled(b);
        jComboBoxImager.setEnabled(b);
        jCheckBoxCreateSupportCode.setEnabled(b);
        jCheckBoxCreateGameLoop.setEnabled(b);
        jComboBoxBankswitch.setEnabled(b);
        jTable1.setEnabled(b);
        jCheckBoxCDebugging.setEnabled(!b);
        jCheckBoxCRumInlined.setEnabled(!b);
    }

}
