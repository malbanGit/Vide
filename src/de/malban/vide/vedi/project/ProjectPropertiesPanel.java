package de.malban.vide.vedi.project;


import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.components.ModalInternalFrame;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.vide.script.ExecutionDescriptor;
import static de.malban.vide.script.ExecutionDescriptor.ED_TYPE_FILE_ACTION;
import static de.malban.vide.script.ExecutionDescriptor.ED_TYPE_FILE_PRE;
import static de.malban.vide.script.ExecutionDescriptor.ED_TYPE_PROJECT_POST;
import static de.malban.vide.script.ExecutionDescriptor.ED_TYPE_PROJECT_PRE;
import de.malban.vide.script.ExportData;
import de.malban.vide.script.ExportDataPool;
import de.malban.vide.script.ScriptDataPanel;
import de.malban.vide.vecx.cartridge.Cartridge;
import static de.malban.vide.vedi.VediPanel.convertSeperator;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JInternalFrame;
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
                
                String ppath = mProjectProperties.mPath.toString();
                if (ppath.length() != 0 )ppath+=File.separator;
                Path projectPath = Paths.get(ppath+mProjectProperties.mProjectName);
                Path filePath = Paths.get(path);
                
                Path relativePath1 = projectPath.relativize(filePath);
                mProjectProperties.mBankMainFiles.setElementAt(relativePath1.toString(), rowIndex);
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
    }

    /** Creates new form ProjectPropertiesPanel */
    public ProjectPropertiesPanel() {
        mClassSetting++;
        initComponents();
        initScripts();
        mProjectPropertiesPool = new ProjectPropertiesPool();
        resetConfigPool(false, "");
        jPanel1.setVisible(false);

        jTable1.setModel(model);
        String ppath = mProjectProperties.mPath.toString();
        if (ppath.length() != 0 )ppath+=File.separator;
        jTable1.getColumnModel().getColumn(1).setCellEditor(new FileChooserCellEditor(ppath+mProjectProperties.mProjectName));

        jTable1.getColumnModel().getColumn(0).setPreferredWidth(5);                
        jTable1.getColumnModel().getColumn(0).setWidth(5);  
        jTable1.getColumnModel().getColumn(1).setPreferredWidth(200);                
        jTable1.getColumnModel().getColumn(1).setWidth(200);  
        jTable1.getColumnModel().getColumn(1).setPreferredWidth(100);                
        jTable1.getColumnModel().getColumn(1).setWidth(100);  
        mClassSetting--;

    }

    public ProjectPropertiesPanel(ProjectProperties currentProject) 
    {
        mClassSetting++;
        initComponents();
        initScripts();
        jButtonCreate.setText("ok");
        jButtonCreate.setName("ok");
        mProjectProperties = currentProject;
        setAllFromCurrent();
        jPanel1.setVisible(false);
        
        jTextFieldProjectName.setEnabled(false);
        jTextFieldPath.setEnabled(false);
        jButtonFileSelect1.setEnabled(false);
        
        jTable1.setModel(model);
        String ppath = mProjectProperties.mPath.toString();
        if (ppath.length() != 0 )ppath+=File.separator;
        jTable1.getColumnModel().getColumn(1).setCellEditor(new FileChooserCellEditor(ppath+mProjectProperties.mProjectName));

        jTable1.getColumnModel().getColumn(0).setPreferredWidth(5);                
        jTable1.getColumnModel().getColumn(0).setWidth(5);  
        jTable1.getColumnModel().getColumn(1).setPreferredWidth(200);                
        jTable1.getColumnModel().getColumn(1).setWidth(200);  
        mClassSetting--;
    }
    
    // called when bankswitching or number of banks changed
    void adjustMains()
    {
        if (mClassSetting > 0) return;
        if (mProjectProperties.mBankMainFiles == null)
            mProjectProperties.mBankMainFiles = new Vector<>();
        if (mProjectProperties.mBankDefines == null)
            mProjectProperties.mBankDefines = new Vector<>();
        
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
        String ppath = mProjectProperties.mPath.toString();
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

        
        jTextFieldAuthor.setText(mProjectProperties.mAuthor);
        jTextAreaDescription.setText(mProjectProperties.mDescription);
        jTextFieldPath.setText(mProjectProperties.mPath );
        jTextFieldProjectName.setText(mProjectProperties.mProjectName );
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
        jCheckBox2.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_RAM_DS2430A) == Cartridge.FLAG_RAM_DS2430A);
        jCheckBox3.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_LIGHTPEN1) == Cartridge.FLAG_LIGHTPEN1);
        jCheckBox4.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_LIGHTPEN2) == Cartridge.FLAG_LIGHTPEN2);
        jCheckBox5.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_IMAGER) == Cartridge.FLAG_IMAGER);
        jCheckBox6.setSelected((mProjectProperties.mExtras & Cartridge.FLAG_EXTREM_MULTI) == Cartridge.FLAG_EXTREM_MULTI);
        
        
        initScripts();
        mClassSetting--;
    }

    private void readAllToCurrent() /* allneeded*/
    {
        mProjectProperties.mClass = "Project";
        mProjectProperties.mName = jTextFieldProjectName.getText();

        mProjectProperties.mAuthor = jTextFieldAuthor.getText();
        mProjectProperties.mDescription = jTextAreaDescription.getText();
        mProjectProperties.mDirectoryName = "";
        mProjectProperties.mPath = de.malban.util.Utility.makeRelative(jTextFieldPath.getText());

        mProjectProperties.mProjectName = jTextFieldProjectName.getText();
        mProjectProperties.mMainFile = jTextFieldMainFile.getText();
        mProjectProperties.mVersion = jTextFieldVersion.getText();
        mProjectProperties.mBankswitching = jComboBoxBankswitch.getSelectedItem().toString();
        mProjectProperties.mNumberOfBanks = Integer.parseInt(jComboBoxBankswitchNumber.getSelectedItem().toString());
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

        int extra = 0;
        if (jCheckBox1.isSelected()) extra+= Cartridge.FLAG_VEC_VOICE;
        if (jCheckBox2.isSelected()) extra+= Cartridge.FLAG_RAM_DS2430A;
        if (jCheckBox3.isSelected()) extra+= Cartridge.FLAG_LIGHTPEN1;
        if (jCheckBox4.isSelected()) extra+= Cartridge.FLAG_LIGHTPEN2;
        if (jCheckBox5.isSelected()) extra+= Cartridge.FLAG_IMAGER;
        if (jCheckBox6.isSelected()) extra+= Cartridge.FLAG_EXTREM_MULTI;
        
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

        jPanel2 = new javax.swing.JPanel();
        jButtonCreate = new javax.swing.JButton();
        jButtonCancel = new javax.swing.JButton();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel3 = new javax.swing.JPanel();
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
        jCheckBoxCreateGameLoop = new javax.swing.JCheckBox();
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
        jPanel4 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jPanel5 = new javax.swing.JPanel();
        jCheckBox1 = new javax.swing.JCheckBox();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox3 = new javax.swing.JCheckBox();
        jCheckBox4 = new javax.swing.JCheckBox();
        jCheckBox5 = new javax.swing.JCheckBox();
        jCheckBox6 = new javax.swing.JCheckBox();
        jButtonPre = new javax.swing.JButton();
        jLabel6 = new javax.swing.JLabel();
        jComboBoxPostName = new javax.swing.JComboBox();
        jLabel10 = new javax.swing.JLabel();
        jComboBoxPostClass = new javax.swing.JComboBox();
        jButtonPost = new javax.swing.JButton();
        jComboBoxPreClass = new javax.swing.JComboBox();
        jComboBoxPreName = new javax.swing.JComboBox();

        setPreferredSize(new java.awt.Dimension(700, 600));

        jButtonCreate.setText("create");
        jButtonCreate.setName("create"); // NOI18N
        jButtonCreate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCreateActionPerformed(evt);
            }
        });

        jButtonCancel.setText("cancel");
        jButtonCancel.setName("cancel"); // NOI18N

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButtonCancel)
                .addGap(116, 116, 116)
                .addComponent(jButtonCreate)
                .addContainerGap())
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                .addComponent(jButtonCancel)
                .addComponent(jButtonCreate))
        );

        jPanel3.setLayout(null);
        jPanel3.add(jTextFieldPath);
        jTextFieldPath.setBounds(135, 30, 330, 19);

        jTextFieldVersion.setText("1.0");
        jPanel3.add(jTextFieldVersion);
        jTextFieldVersion.setBounds(437, 80, 58, 19);

        jTextAreaDescription.setColumns(20);
        jTextAreaDescription.setRows(5);
        jScrollPane1.setViewportView(jTextAreaDescription);

        jPanel3.add(jScrollPane1);
        jScrollPane1.setBounds(135, 111, 360, 80);

        jLabel2.setText("Version");
        jPanel3.add(jLabel2);
        jLabel2.setBounds(371, 82, 54, 15);
        jPanel3.add(jTextFieldAuthor);
        jTextFieldAuthor.setBounds(135, 80, 169, 19);

        jButtonFileSelect1.setText("...");
        jButtonFileSelect1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect1ActionPerformed(evt);
            }
        });
        jPanel3.add(jButtonFileSelect1);
        jButtonFileSelect1.setBounds(471, 30, 13, 19);

        jLabel7.setText("Path");
        jPanel3.add(jLabel7);
        jLabel7.setBounds(17, 30, 50, 15);

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
        jPanel3.add(jTextFieldProjectName);
        jTextFieldProjectName.setBounds(135, 5, 169, 19);
        jPanel3.add(jTextFieldMainFile);
        jTextFieldMainFile.setBounds(135, 55, 169, 19);

        jLabel5.setText("Name");
        jPanel3.add(jLabel5);
        jLabel5.setBounds(17, 7, 50, 15);

        jLabel8.setText("Main file");
        jPanel3.add(jLabel8);
        jLabel8.setBounds(17, 57, 80, 15);

        jLabel9.setText("Author");
        jPanel3.add(jLabel9);
        jLabel9.setBounds(17, 82, 70, 15);

        jLabel1.setText("Description");
        jPanel3.add(jLabel1);
        jLabel1.setBounds(17, 111, 90, 15);

        jComboBoxBankswitch.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "none", "2 bank standard", "VecFlash (up to 64 banks)" }));
        jComboBoxBankswitch.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxBankswitchActionPerformed(evt);
            }
        });
        jPanel3.add(jComboBoxBankswitch);
        jComboBoxBankswitch.setBounds(351, 278, 144, 21);

        jCheckBoxCreateSupportCode.setText("create bankswitch code");
        jPanel3.add(jCheckBoxCreateSupportCode);
        jCheckBoxCreateSupportCode.setBounds(135, 280, 170, 19);

        jCheckBoxCreateGameLoop.setText("create standard game loop");
        jPanel3.add(jCheckBoxCreateGameLoop);
        jCheckBoxCreateGameLoop.setBounds(135, 252, 180, 19);

        jComboBoxBankswitchNumber.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "1" }));
        jComboBoxBankswitchNumber.setEnabled(false);
        jComboBoxBankswitchNumber.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxBankswitchNumberActionPerformed(evt);
            }
        });
        jPanel3.add(jComboBoxBankswitchNumber);
        jComboBoxBankswitchNumber.setBounds(517, 278, 46, 21);

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

        jPanel3.add(jPanel1);
        jPanel1.setBounds(135, 516, 313, 9);

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

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 360, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 203, Short.MAX_VALUE)
        );

        jPanel3.add(jPanel4);
        jPanel4.setBounds(135, 307, 372, 203);

        jCheckBox1.setText("VecVoice");

        jCheckBox2.setText("RAM DS2430A");

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

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jCheckBox3, javax.swing.GroupLayout.DEFAULT_SIZE, 114, Short.MAX_VALUE)
                    .addComponent(jCheckBox4, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jCheckBox5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jCheckBox6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(jCheckBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 86, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jCheckBox1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox4)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox5)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox6)
                .addGap(0, 71, Short.MAX_VALUE))
        );

        jPanel3.add(jPanel5);
        jPanel5.setBounds(517, 2, 134, 190);

        jButtonPre.setLabel("configure script");
        jButtonPre.setPreferredSize(new java.awt.Dimension(90, 19));
        jButtonPre.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPreActionPerformed(evt);
            }
        });
        jPanel3.add(jButtonPre);
        jButtonPre.setBounds(517, 198, 127, 19);

        jLabel6.setText("Pre build commands");
        jPanel3.add(jLabel6);
        jLabel6.setBounds(17, 200, 120, 15);

        jComboBoxPostName.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPostName.setPreferredSize(new java.awt.Dimension(59, 19));
        jPanel3.add(jComboBoxPostName);
        jComboBoxPostName.setBounds(135, 223, 144, 19);

        jLabel10.setText("Post build commands");
        jPanel3.add(jLabel10);
        jLabel10.setBounds(17, 225, 130, 15);

        jComboBoxPostClass.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPostClass.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxPostClass.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxPostClassActionPerformed(evt);
            }
        });
        jPanel3.add(jComboBoxPostClass);
        jComboBoxPostClass.setBounds(351, 223, 144, 19);

        jButtonPost.setLabel("configure script");
        jButtonPost.setPreferredSize(new java.awt.Dimension(90, 19));
        jButtonPost.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPostActionPerformed(evt);
            }
        });
        jPanel3.add(jButtonPost);
        jButtonPost.setBounds(517, 223, 127, 19);

        jComboBoxPreClass.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPreClass.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxPreClass.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                jComboBoxPreClassItemStateChanged(evt);
            }
        });
        jPanel3.add(jComboBoxPreClass);
        jComboBoxPreClass.setBounds(351, 198, 144, 19);

        jComboBoxPreName.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPreName.setPreferredSize(new java.awt.Dimension(59, 19));
        jPanel3.add(jComboBoxPreName);
        jComboBoxPreName.setBounds(135, 198, 144, 19);

        jTabbedPane1.addTab("Project settings", jPanel3);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jTabbedPane1)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jTabbedPane1)
                .addGap(1, 1, 1)
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
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
        fc.setCurrentDirectory(new java.io.File("."+File.separator));
        fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String lastPath = fc.getSelectedFile().getAbsolutePath();
        
        Path p = Paths.get(lastPath);
        
        jTextFieldPath.setText(p.toString());
        
    }//GEN-LAST:event_jButtonFileSelect1ActionPerformed

    private void jButtonCreateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCreateActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jButtonCreateActionPerformed

    private void jTextFieldProjectNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldProjectNameActionPerformed
        if (!wasMainSetManually)
            jTextFieldMainFile.setText(jTextFieldProjectName.getText()+".asm");
    }//GEN-LAST:event_jTextFieldProjectNameActionPerformed

    private void jTextFieldProjectNameKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldProjectNameKeyReleased
        if (!wasMainSetManually)
            jTextFieldMainFile.setText(jTextFieldProjectName.getText()+".asm");
    }//GEN-LAST:event_jTextFieldProjectNameKeyReleased

    private void jTextFieldProjectNameFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldProjectNameFocusLost
        if (!wasMainSetManually)
            jTextFieldMainFile.setText(jTextFieldProjectName.getText()+".asm");
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
            String[] s = new String[64];
            for (int i=0;i<=63; i++)
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
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox5ActionPerformed

    private void jCheckBox6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox6ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox6ActionPerformed

    private void jButtonPreActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPreActionPerformed
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ScriptDataPanel sdp = new ScriptDataPanel();
        JInternalFrame modal=null;
        
        String pp = convertSeperator(mProjectProperties.getPath());
        if (pp.length() >0 ) pp += File.separator;
        pp += mProjectProperties.getProjectName();
        
        ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_PRE, mProjectProperties.mProjectName, "", "ProjectPropertiesPanel", pp);
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
        JInternalFrame modal=null;
        String pp = convertSeperator(mProjectProperties.getPath());
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
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JCheckBox jCheckBox5;
    private javax.swing.JCheckBox jCheckBox6;
    private javax.swing.JCheckBox jCheckBoxCreateGameLoop;
    private javax.swing.JCheckBox jCheckBoxCreateSupportCode;
    private javax.swing.JComboBox jComboBoxBankswitch;
    private javax.swing.JComboBox jComboBoxBankswitchNumber;
    private javax.swing.JComboBox jComboBoxKlasse;
    private javax.swing.JComboBox jComboBoxName;
    private javax.swing.JComboBox jComboBoxPostClass;
    private javax.swing.JComboBox jComboBoxPostName;
    private javax.swing.JComboBox jComboBoxPreClass;
    private javax.swing.JComboBox jComboBoxPreName;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JTextArea jTextAreaDescription;
    private javax.swing.JTextField jTextFieldAuthor;
    private javax.swing.JTextField jTextFieldKlasse;
    private javax.swing.JTextField jTextFieldMainFile;
    private javax.swing.JTextField jTextFieldName;
    private javax.swing.JTextField jTextFieldPath;
    private javax.swing.JTextField jTextFieldProjectName;
    private javax.swing.JTextField jTextFieldVersion;
    // End of variables declaration//GEN-END:variables

    
    // returns new Properties, not saved yet!
    JInternalFrame modelDialog;
    public static ProjectProperties showNewProjectProperties()
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ProjectPropertiesPanel panel = new ProjectPropertiesPanel();
        
        ArrayList<JButton> eb= new ArrayList<>();
        eb.add(panel.jButtonCreate);
        eb.add(panel.jButtonCancel);
        ModalInternalFrame modal = new ModalInternalFrame("New project", frame.getRootPane(), frame, panel,null, null , eb);
        panel.modelDialog = modal;
        modal.setVisible(true);
        String result = modal.getNamedExit();
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
        
        
        
        ArrayList<JButton> eb= new ArrayList<>();
        eb.add(panel.jButtonCreate);
        eb.add(panel.jButtonCancel);
        ModalInternalFrame modal = new ModalInternalFrame(currentProject.mProjectName, frame.getRootPane(), frame, panel,null, null , eb);
        panel.modelDialog = modal;
        modal.setVisible(true);
        String result = modal.getNamedExit();
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

}
