package de.malban.vide.vedi.project;


import de.malban.config.Configuration;
import de.malban.gui.components.ModalInternalFrame;
import de.malban.vide.script.ExecutionDescriptor;
import static de.malban.vide.script.ExecutionDescriptor.ED_TYPE_FILE_ACTION;
import static de.malban.vide.script.ExecutionDescriptor.ED_TYPE_FILE_POST;
import static de.malban.vide.script.ExecutionDescriptor.ED_TYPE_FILE_PRE;
import de.malban.vide.script.ExportData;
import de.malban.vide.script.ExportDataPool;
import de.malban.vide.script.ScriptDataPanel;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JInternalFrame;

public class FilePropertiesPanel extends javax.swing.JPanel {
    private ExportDataPool mExportDataPool;
    private FileProperties mFileProperties = new FileProperties();
    private FilePropertiesPool mFilePropertiesPool;
    private int mClassSetting=0;
    String type ="";
    String pathFull ="";
    String pathOnly ="";
    String filenameOnly ="";
    String filenameBaseOnly ="";
    
    

    /** Creates new form FilePropertiesPanel */
    public FilePropertiesPanel() {
        initComponents();
        mFilePropertiesPool = new FilePropertiesPool();
        resetConfigPool(false, "");
        jPanel1.setVisible(false);
    }
    
    public void setFile(String path)
    {
        
        // get xml representation
        Path p = Paths.get(path);
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        if (pathOnly.length()!=0) pathOnly+=File.separator;
        filenameOnly = p.getFileName().toString();
        
        if (filenameOnly.contains("."))
        {
            filenameBaseOnly  =filenameOnly.substring(0, filenameOnly.indexOf("."));
            type = filenameOnly.substring(filenameOnly.indexOf(".")+1);
        }
        else
            filenameBaseOnly = filenameOnly;

        mFilePropertiesPool = new FilePropertiesPool(pathOnly, filenameBaseOnly+"FileProperty.xml");

            
        mFileProperties =  mFilePropertiesPool.get(filenameOnly);
        if (mFileProperties == null)
        {
            mFileProperties = new FileProperties();
            mFileProperties.mClass = "FileProperty";
            mFileProperties.mName = filenameOnly;
        }
        else
        {
            jButtonCreate.setText("ok");
            jButtonCreate.setName("ok");
        }
    
        jTextField2.setText(pathFull);
        mFileProperties.mFilename = pathFull;
        jTextField1.setText(type);
        setAllFromCurrent();
    
    
    }

    private void resetConfigPool(boolean select, String klasseToSet) /* allneeded*/
    {
        mClassSetting++;
        Collection<String> collectionKlasse = mFilePropertiesPool.getKlassenHashMap().values();
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

        Collection<FileProperties> colC = mFilePropertiesPool.getMapForKlasse(klasse).values();
        Iterator<FileProperties> iterC = colC.iterator();

        jComboBoxName.removeAllItems();
        i = 0;
        while (iterC.hasNext())
        {
            FileProperties item = iterC.next();
            jComboBoxName.addItem(item.mName);
            if ((i==0) && (select))
            {
                jComboBoxName.setSelectedIndex(0);
                mFileProperties = mFilePropertiesPool.get(item.mName);
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
        mFileProperties = new FileProperties();
        setAllFromCurrent();
        mClassSetting--;
    }

    private void setAllFromCurrent() /* allneeded*/
    {
        mClassSetting++;
        jComboBoxKlasse.setSelectedItem(mFileProperties.mClass);
        jTextFieldKlasse.setText(mFileProperties.mClass);
        jComboBoxName.setSelectedItem(mFileProperties.mName);
        jTextFieldName.setText(mFileProperties.mName);

        
        jTextFieldFlags.setText(""+mFileProperties.mFlags);
        jTextFieldVersion.setText(""+mFileProperties.mVersion);
        jTextAreaDescription.setText(""+mFileProperties.mDescription);
        jTextFieldParam1.setText(""+mFileProperties.mParemeter1);
        jTextFieldParam2.setText(""+mFileProperties.mParemeter2);
        jTextFieldParam3.setText(""+mFileProperties.mParemeter3);

        jTextField2.setText(mFileProperties.mFilename);
        jCheckBox1.setSelected(mFileProperties.mNoInternalProcessing);
        initScripts();
        
        
        mClassSetting--;
    }

    private void readAllToCurrent() /* allneeded*/
    {

        mFileProperties.mFlags = jTextFieldFlags.getText();
        mFileProperties.mVersion = jTextFieldVersion.getText();
        mFileProperties.mDescription = jTextAreaDescription.getText();

        mFileProperties.mParemeter1 = jTextFieldParam1.getText();
        mFileProperties.mParemeter2 = jTextFieldParam2.getText();
        mFileProperties.mParemeter3 = jTextFieldParam3.getText();
        
        mFileProperties.mFilename = jTextField2.getText();
        
        
        mFileProperties.mNoInternalProcessing = jCheckBox1.isSelected();

        mFileProperties.mPreScriptClass = "";
        if (jComboBoxPreClass.getSelectedIndex()!=-1)
            mFileProperties.mPreScriptClass = jComboBoxPreClass.getSelectedItem().toString();
        mFileProperties.mPreScriptName = "";
        if (jComboBoxPreName.getSelectedIndex()!=-1)
            mFileProperties.mPreScriptName = jComboBoxPreName.getSelectedItem().toString();
                
        mFileProperties.mPostScriptClass = "";
        if (jComboBoxPostClass.getSelectedIndex()!=-1)
            mFileProperties.mPostScriptClass = jComboBoxPostClass.getSelectedItem().toString();
        mFileProperties.mPostScriptName = "";
        if (jComboBoxPostName.getSelectedIndex()!=-1)
            mFileProperties.mPostScriptName = jComboBoxPostName.getSelectedItem().toString();
                
        mFileProperties.mActionScriptClass = "";
        if (jComboBoxActionClass.getSelectedIndex()!=-1)
            mFileProperties.mActionScriptClass = jComboBoxActionClass.getSelectedItem().toString();
        mFileProperties.mActionScriptName = "";
        if (jComboBoxActionName.getSelectedIndex()!=-1)
            mFileProperties.mActionScriptName = jComboBoxActionName.getSelectedItem().toString();
    
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
        jPanel3 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jTextField2 = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTextAreaDescription = new javax.swing.JTextArea();
        jLabel6 = new javax.swing.JLabel();
        jTextFieldParam1 = new javax.swing.JTextField();
        jTextFieldParam2 = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jTextFieldParam3 = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jComboBoxPostName = new javax.swing.JComboBox();
        jComboBoxPreName = new javax.swing.JComboBox();
        jComboBoxPreClass = new javax.swing.JComboBox();
        jComboBoxPostClass = new javax.swing.JComboBox();
        jButtonPost = new javax.swing.JButton();
        jButtonPre = new javax.swing.JButton();
        jButtonAction = new javax.swing.JButton();
        jComboBoxActionClass = new javax.swing.JComboBox();
        jComboBoxActionName = new javax.swing.JComboBox();
        jLabel11 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jTextFieldVersion = new javax.swing.JTextField();
        jLabel13 = new javax.swing.JLabel();
        jTextFieldFlags = new javax.swing.JTextField();
        jCheckBox1 = new javax.swing.JCheckBox();
        jPanel4 = new javax.swing.JPanel();
        jButtonCreate = new javax.swing.JButton();
        jButtonCancel = new javax.swing.JButton();
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

        jLabel1.setText("Filename");

        jTextField1.setEditable(false);

        jLabel2.setText("Typ");

        jTextField2.setEditable(false);

        jLabel5.setText("Description");

        jTextAreaDescription.setColumns(20);
        jTextAreaDescription.setRows(5);
        jScrollPane1.setViewportView(jTextAreaDescription);

        jLabel6.setText("Parameter");

        jLabel7.setText("Parameter");

        jLabel8.setText("Parameter");

        jLabel9.setText("Pre build commands");

        jLabel10.setText("Post build commands");

        jComboBoxPostName.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPostName.setPreferredSize(new java.awt.Dimension(59, 19));

        jComboBoxPreName.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPreName.setPreferredSize(new java.awt.Dimension(59, 19));

        jComboBoxPreClass.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPreClass.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxPreClass.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                jComboBoxPreClassItemStateChanged(evt);
            }
        });

        jComboBoxPostClass.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPostClass.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxPostClass.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxPostClassActionPerformed(evt);
            }
        });

        jButtonPost.setLabel("configure script");
        jButtonPost.setPreferredSize(new java.awt.Dimension(90, 19));
        jButtonPost.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPostActionPerformed(evt);
            }
        });

        jButtonPre.setLabel("configure script");
        jButtonPre.setPreferredSize(new java.awt.Dimension(90, 19));
        jButtonPre.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPreActionPerformed(evt);
            }
        });

        jButtonAction.setLabel("configure script");
        jButtonAction.setPreferredSize(new java.awt.Dimension(90, 19));
        jButtonAction.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonActionActionPerformed(evt);
            }
        });

        jComboBoxActionClass.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxActionClass.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxActionClass.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                jComboBoxActionClassItemStateChanged(evt);
            }
        });

        jComboBoxActionName.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxActionName.setPreferredSize(new java.awt.Dimension(59, 19));

        jLabel11.setText("Action script");

        jLabel12.setText("Version");

        jTextFieldVersion.setText("1.0");

        jLabel13.setText("Flags");

        jCheckBox1.setText("no internal processing");
        jCheckBox1.setToolTipText("if selected no internal procressing (assembling) is done");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGap(5, 5, 5)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel1)
                            .addComponent(jLabel2))
                        .addGap(72, 72, 72)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(63, 63, 63)
                                .addComponent(jLabel13, javax.swing.GroupLayout.PREFERRED_SIZE, 54, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(12, 12, 12)
                                .addComponent(jTextFieldFlags, javax.swing.GroupLayout.PREFERRED_SIZE, 58, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel12, javax.swing.GroupLayout.PREFERRED_SIZE, 54, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(12, 12, 12)
                                .addComponent(jTextFieldVersion, javax.swing.GroupLayout.PREFERRED_SIZE, 58, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jTextField2)))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel5)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel6)
                                    .addComponent(jLabel7)
                                    .addComponent(jLabel8))
                                .addGap(65, 65, 65)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jCheckBox1)
                                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                        .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 509, Short.MAX_VALUE)
                                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jTextFieldParam1, javax.swing.GroupLayout.PREFERRED_SIZE, 153, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextFieldParam2, javax.swing.GroupLayout.PREFERRED_SIZE, 153, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextFieldParam3, javax.swing.GroupLayout.PREFERRED_SIZE, 153, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel10)
                                    .addComponent(jLabel11)
                                    .addComponent(jLabel9))
                                .addGap(41, 41, 41)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jComboBoxPostName, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jComboBoxActionName, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jComboBoxPreName, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(33, 33, 33)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jComboBoxPostClass, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addComponent(jComboBoxPreClass, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jComboBoxActionClass, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addGap(22, 22, 22)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jButtonPre, javax.swing.GroupLayout.PREFERRED_SIZE, 127, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jButtonAction, javax.swing.GroupLayout.PREFERRED_SIZE, 127, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jButtonPost, javax.swing.GroupLayout.PREFERRED_SIZE, 127, javax.swing.GroupLayout.PREFERRED_SIZE))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 39, Short.MAX_VALUE)))
                .addContainerGap(31, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGap(12, 12, 12)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel2)
                    .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldVersion, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel12)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGap(2, 2, 2)
                                .addComponent(jLabel13))
                            .addComponent(jTextFieldFlags, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel5)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(12, 12, 12)
                .addComponent(jCheckBox1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel6)
                            .addComponent(jTextFieldParam1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel7)
                            .addComponent(jTextFieldParam2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel8)
                            .addComponent(jTextFieldParam3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPanel2Layout.createSequentialGroup()
                                        .addGap(2, 2, 2)
                                        .addComponent(jLabel11))
                                    .addComponent(jComboBoxActionName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPanel2Layout.createSequentialGroup()
                                        .addGap(2, 2, 2)
                                        .addComponent(jLabel9))
                                    .addComponent(jComboBoxPreName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                                .addComponent(jButtonAction, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonPre, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jComboBoxActionClass, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jComboBoxPreClass, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(6, 6, 6)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addComponent(jLabel10))
                    .addComponent(jComboBoxPostName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBoxPostClass, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonPost, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(162, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(2, 2, 2))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel2, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        jTabbedPane1.addTab("File Settings", jPanel3);

        jButtonCreate.setText("create");
        jButtonCreate.setName("create"); // NOI18N
        jButtonCreate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCreateActionPerformed(evt);
            }
        });

        jButtonCancel.setText("cancel");
        jButtonCancel.setName("cancel"); // NOI18N

        jPanel1.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jComboBoxKlasse.setPreferredSize(new java.awt.Dimension(28, 19));
        jComboBoxKlasse.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxKlasseActionPerformed(evt);
            }
        });

        jComboBoxName.setPreferredSize(new java.awt.Dimension(28, 19));
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
                .addGap(28, 28, 28)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jTextFieldKlasse, javax.swing.GroupLayout.DEFAULT_SIZE, 244, Short.MAX_VALUE)
                    .addComponent(jTextFieldName))
                .addGap(5, 5, 5)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jComboBoxKlasse, 0, 208, Short.MAX_VALUE)
                    .addComponent(jComboBoxName, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonSave)
                    .addComponent(jButtonNew))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonSaveAsNew)
                    .addComponent(jButtonDelete))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
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
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jButtonNew)
                                .addComponent(jComboBoxKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
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

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel4Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButtonCancel)
                .addGap(116, 116, 116)
                .addComponent(jButtonCreate)
                .addContainerGap())
            .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel4Layout.createSequentialGroup()
                    .addGap(338, 338, 338)
                    .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(338, Short.MAX_VALUE)))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                .addComponent(jButtonCancel)
                .addComponent(jButtonCreate))
            .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel4Layout.createSequentialGroup()
                    .addGap(7, 7, 7)
                    .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 9, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
            .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jTabbedPane1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewActionPerformed
        mClassSetting++;
        mFileProperties = new FileProperties();
        clearAll();
        resetConfigPool(false, "");
        mClassSetting--;
}//GEN-LAST:event_jButtonNewActionPerformed

    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed

        readAllToCurrent();
        mFilePropertiesPool.put(mFileProperties);
        mFilePropertiesPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true, klasse);
        jComboBoxName.setSelectedItem(mFileProperties.mName);
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveActionPerformed

    private void jButtonSaveAsNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveAsNewActionPerformed
        mFileProperties = new FileProperties();
        readAllToCurrent();
        mFilePropertiesPool.putAsNew(mFileProperties);
        mFilePropertiesPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true,klasse);
        jComboBoxName.setSelectedItem(mFileProperties.mName);
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveAsNewActionPerformed

    private void jButtonDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteActionPerformed
        readAllToCurrent();
        mFilePropertiesPool.remove(mFileProperties);
        mFilePropertiesPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true,klasse);

        if (jComboBoxName.getSelectedIndex() == -1)
        {
            clearAll();
        }

        String key = jComboBoxName.getSelectedItem().toString();
        mFileProperties = mFilePropertiesPool.get(key);
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
        mFileProperties = mFilePropertiesPool.get(key);
        setAllFromCurrent();
        mClassSetting--;
    }//GEN-LAST:event_jComboBoxKlasseActionPerformed

    private void jComboBoxNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxNameActionPerformed
        if (mClassSetting > 0 ) return;
        String key = jComboBoxName.getSelectedItem().toString();
        mFileProperties = mFilePropertiesPool.get(key);
        setAllFromCurrent();
    }//GEN-LAST:event_jComboBoxNameActionPerformed

    private void jButtonCreateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCreateActionPerformed
        // try to create dir and save project properties
        readAllToCurrent();
        mFilePropertiesPool.put(mFileProperties);
        mFilePropertiesPool.save();
        
    }//GEN-LAST:event_jButtonCreateActionPerformed

    private void jComboBoxActionClassItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_jComboBoxActionClassItemStateChanged
        if (mClassSetting>0) return;
        if (jComboBoxActionClass.getSelectedIndex()!= -1)
        mFileProperties.mActionScriptClass = jComboBoxActionClass.getSelectedItem().toString();
        else
        mFileProperties.mActionScriptClass = "";
        initScripts();
    }//GEN-LAST:event_jComboBoxActionClassItemStateChanged

    private void jButtonActionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonActionActionPerformed
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ScriptDataPanel sdp = new ScriptDataPanel();
        JInternalFrame modal=null;

        if (Paths.get(mFileProperties.mFilename).getParent() == null) return;
        String path = Paths.get(mFileProperties.mFilename).getParent().toString();
        
        String filenameOnly = Paths.get(mFileProperties.mFilename).getFileName().toString();
        
        ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_FILE_ACTION, "", filenameOnly, "FilePropertiesPanel", path);
        sdp.setSelected(mFileProperties.mActionScriptClass, mFileProperties.mActionScriptName, ed);
        modal = new ModalInternalFrame("Scripter", frame.getRootPane(), frame, sdp, "done");
        modal.setVisible(true);

        mFileProperties.mActionScriptClass = sdp.getSelectedClass();
        mFileProperties.mActionScriptName = sdp.getSelectedName();
        initScripts();
    }//GEN-LAST:event_jButtonActionActionPerformed

    private void jButtonPreActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPreActionPerformed
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ScriptDataPanel sdp = new ScriptDataPanel();
        JInternalFrame modal=null;
        if (Paths.get(mFileProperties.mFilename).getParent() == null) return;
        String path = Paths.get(mFileProperties.mFilename).getParent().toString();
        String filenameOnly = Paths.get(mFileProperties.mFilename).getFileName().toString();
        
        ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_FILE_PRE, "", filenameOnly, "FilePropertiesPanel", path);
        sdp.setSelected(mFileProperties.mPreScriptClass, mFileProperties.mPreScriptName, ed);
        modal = new ModalInternalFrame("Scripter", frame.getRootPane(), frame, sdp, "done");
        modal.setVisible(true);

        mFileProperties.mPreScriptClass = sdp.getSelectedClass();
        mFileProperties.mPreScriptName = sdp.getSelectedName();
        initScripts();
    }//GEN-LAST:event_jButtonPreActionPerformed

    private void jButtonPostActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPostActionPerformed
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ScriptDataPanel sdp = new ScriptDataPanel();
        JInternalFrame modal=null;

        if (Paths.get(mFileProperties.mFilename).getParent() == null) return;
        String path = Paths.get(mFileProperties.mFilename).getParent().toString();
        String filenameOnly = Paths.get(mFileProperties.mFilename).getFileName().toString();
        
        ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_FILE_POST, "", filenameOnly, "FilePropertiesPanel", path);
        sdp.setSelected(mFileProperties.mPostScriptClass, mFileProperties.mPostScriptName, ed);
        modal = new ModalInternalFrame("Scripter", frame.getRootPane(), frame, sdp, "done");
        modal.setVisible(true);

        mFileProperties.mPostScriptClass = sdp.getSelectedClass();
        mFileProperties.mPostScriptName = sdp.getSelectedName();
        initScripts();
    }//GEN-LAST:event_jButtonPostActionPerformed

    private void jComboBoxPostClassActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxPostClassActionPerformed
        if (mClassSetting>0) return;
        if (jComboBoxPostClass.getSelectedIndex()!= -1)
        mFileProperties.mPostScriptClass = jComboBoxPostClass.getSelectedItem().toString();
        else
        mFileProperties.mPostScriptClass = "";
        initScripts();
    }//GEN-LAST:event_jComboBoxPostClassActionPerformed

    private void jComboBoxPreClassItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_jComboBoxPreClassItemStateChanged
        if (mClassSetting>0) return;
        if (jComboBoxPreClass.getSelectedIndex()!= -1)
        mFileProperties.mPreScriptClass = jComboBoxPreClass.getSelectedItem().toString();
        else
        mFileProperties.mPreScriptClass = "";
        initScripts();
    }//GEN-LAST:event_jComboBoxPreClassItemStateChanged


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonAction;
    public javax.swing.JButton jButtonCancel;
    public javax.swing.JButton jButtonCreate;
    private javax.swing.JButton jButtonDelete;
    private javax.swing.JButton jButtonNew;
    private javax.swing.JButton jButtonPost;
    private javax.swing.JButton jButtonPre;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JButton jButtonSaveAsNew;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JComboBox jComboBoxActionClass;
    private javax.swing.JComboBox jComboBoxActionName;
    private javax.swing.JComboBox jComboBoxKlasse;
    private javax.swing.JComboBox jComboBoxName;
    private javax.swing.JComboBox jComboBoxPostClass;
    private javax.swing.JComboBox jComboBoxPostName;
    private javax.swing.JComboBox jComboBoxPreClass;
    private javax.swing.JComboBox jComboBoxPreName;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
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
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTextArea jTextAreaDescription;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextFieldFlags;
    private javax.swing.JTextField jTextFieldKlasse;
    private javax.swing.JTextField jTextFieldName;
    private javax.swing.JTextField jTextFieldParam1;
    private javax.swing.JTextField jTextFieldParam2;
    private javax.swing.JTextField jTextFieldParam3;
    private javax.swing.JTextField jTextFieldVersion;
    // End of variables declaration//GEN-END:variables

    // returns new Properties, not saved yet!
    JInternalFrame modelDialog;
    public static boolean showNewFilesProperties()
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        FilePropertiesPanel panel = new FilePropertiesPanel();
        
        ArrayList<JButton> eb= new ArrayList<JButton>();
        eb.add(panel.jButtonCreate);
        eb.add(panel.jButtonCancel);
        ModalInternalFrame modal = new ModalInternalFrame("New project", frame.getRootPane(), frame, panel,null, null , eb);
        panel.modelDialog = modal;
        modal.setVisible(true);
        String result = modal.getNamedExit();
        if (result.equals("create"))
        {
            panel.readAllToCurrent();
            return true;
        }
        
        return false;
    }    
    public static boolean showEditFileProperties(String filename)
    {
        Path p = Paths.get(filename);
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        FilePropertiesPanel panel = new FilePropertiesPanel();
        panel.setFile(filename);
        
        
        
        ArrayList<JButton> eb= new ArrayList<JButton>();
        eb.add(panel.jButtonCreate);
        eb.add(panel.jButtonCancel);
        ModalInternalFrame modal = new ModalInternalFrame(p.getFileName().toString(), frame.getRootPane(), frame, panel,null, null , eb);
        panel.modelDialog = modal;
        modal.setVisible(true);
        String result = modal.getNamedExit();
        if (result.equals("ok"))
        {
            panel.readAllToCurrent();
            return true;
        }
        
        return false;
    }

    void initScripts()
    {
        mExportDataPool = new ExportDataPool();
        String preClass = mFileProperties.mPreScriptClass;
        String preName = mFileProperties.mPreScriptName;

        mClassSetting++;
        Collection<String> collectionKlasse = mExportDataPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        int i = 0;
        String klasse = "";

        jComboBoxPreName.removeAllItems();
        jComboBoxPreClass.removeAllItems();
        jComboBoxPostName.removeAllItems();
        jComboBoxPostClass.removeAllItems();
        jComboBoxActionName.removeAllItems();
        jComboBoxActionClass.removeAllItems();
        while (iterKlasse.hasNext())
        {
            String item = iterKlasse.next();
            jComboBoxPreClass.addItem(item);
            jComboBoxPostClass.addItem(item);
            jComboBoxActionClass.addItem(item);
            i++;
        }
        if ((mFileProperties.mPreScriptClass!=null) && (mFileProperties.mPreScriptClass.length()!=0))
        {
            jComboBoxPreClass.setSelectedItem(mFileProperties.mPreScriptClass);
            Collection<ExportData> colC = mExportDataPool.getMapForKlasse(mFileProperties.mPreScriptClass).values();
            Iterator<ExportData> iterC = colC.iterator();
            /** Sorting */  Vector<String> nnames = new Vector<String>(); while (iterC.hasNext()) nnames.addElement(iterC.next().mName); Collections.sort(nnames, new Comparator<String>() {@Override
                public int compare(String s1, String s2) { return s1.compareTo(s2); } });
            jComboBoxPreName.addItem("");
            for (int j = 0; j < nnames.size(); j++)
            {
                String name = nnames.elementAt(j);
                jComboBoxPreName.addItem(name);
            }
            if ((mFileProperties.mPreScriptName!=null) && (mFileProperties.mPreScriptName.length()!=0))
            {
                jComboBoxPreName.setSelectedItem(mFileProperties.mPreScriptName);
            }
        }
        else
        {
            jComboBoxPreClass.setSelectedIndex(-1);
            jComboBoxPreName.setSelectedIndex(-1);
        }
        
        
        
        
        
        if ((mFileProperties.mPostScriptClass!=null) && (mFileProperties.mPostScriptClass.length()!=0))
        {
            jComboBoxPostClass.setSelectedItem(mFileProperties.mPostScriptClass);
            Collection<ExportData> colC = mExportDataPool.getMapForKlasse(mFileProperties.mPostScriptClass).values();
            Iterator<ExportData> iterC = colC.iterator();
            /** Sorting */  Vector<String> nnames = new Vector<String>(); while (iterC.hasNext()) nnames.addElement(iterC.next().mName); Collections.sort(nnames, new Comparator<String>() {@Override
                public int compare(String s1, String s2) { return s1.compareTo(s2); } });
            jComboBoxPostName.addItem("");
            for (int j = 0; j < nnames.size(); j++)
            {
                String name = nnames.elementAt(j);
                jComboBoxPostName.addItem(name);
            }
            if ((mFileProperties.mPostScriptName!=null) && (mFileProperties.mPostScriptName.length()!=0))
            {
                jComboBoxPostName.setSelectedItem(mFileProperties.mPostScriptName);
            }
        }
        else
        {
            jComboBoxPostClass.setSelectedIndex(-1);
            jComboBoxPostName.setSelectedIndex(-1);
        }
        
        
        
        
        
        
        if ((mFileProperties.mActionScriptClass!=null) && (mFileProperties.mActionScriptClass.length()!=0))
        {
            jComboBoxActionClass.setSelectedItem(mFileProperties.mActionScriptClass);
            Collection<ExportData> colC = mExportDataPool.getMapForKlasse(mFileProperties.mActionScriptClass).values();
            Iterator<ExportData> iterC = colC.iterator();
            /** Sorting */  Vector<String> nnames = new Vector<String>(); while (iterC.hasNext()) nnames.addElement(iterC.next().mName); Collections.sort(nnames, new Comparator<String>() {@Override
                public int compare(String s1, String s2) { return s1.compareTo(s2); } });
            jComboBoxActionName.addItem("");
            for (int j = 0; j < nnames.size(); j++)
            {
                String name = nnames.elementAt(j);
                jComboBoxActionName.addItem(name);
            }
            if ((mFileProperties.mActionScriptName!=null) && (mFileProperties.mActionScriptName.length()!=0))
            {
                jComboBoxActionName.setSelectedItem(mFileProperties.mActionScriptName);
            }
        }
        else
        {
            jComboBoxActionClass.setSelectedIndex(-1);
            jComboBoxActionName.setSelectedIndex(-1);
        }        
        
        mClassSetting--;

        
        
        
    }
}
