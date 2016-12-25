package de.malban.util;


import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.components.CSAInternalFrame;
import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.dialogs.ShowInfoDialog;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import static de.malban.gui.panels.LogPanel.ERROR;
import java.awt.Rectangle;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.Proxy;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class DownloaderPanel extends javax.swing.JPanel {
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    private Downloader mDownloader = new Downloader();
    private DownloaderPool mDownloaderPool;
    private int mClassSetting=0;
    boolean forcedClass = false;
    String className = "";
    static String lastImagePath ="";
    
    /** Creates new form DownloaderPanel */
    public DownloaderPanel() {
        initComponents();
        mDownloaderPool = new DownloaderPool();
        jTabbedPane1.removeAll();
        resetConfigPool(false, "");
        if (lastImagePath.length()==0)
        {
            Path currentRelativePath = Paths.get("");  
            lastImagePath = currentRelativePath.toAbsolutePath().toString();
        }
    }
    
    public Downloader getDownloader()
    {
        readAllToCurrent();
        return mDownloader;
    }

    public void setValues(String cn, String selectedItemName, boolean fc)
    {
        forcedClass = fc;
        className = cn;
        resetConfigPool(true, className);
        jComboBoxName.setSelectedItem(selectedItemName);
        jComboBoxKlasse.setEnabled(!forcedClass);
        jTextFieldKlasse.setEnabled(!forcedClass);
    }
    
    private void resetConfigPool(boolean select, String klasseToSet) /* allneeded*/
    {
        mClassSetting++;
        Collection<String> collectionKlasse = mDownloaderPool.getKlassenHashMap().values();
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
        if (forcedClass)
        {
            if (!klasse.equals(className))
            {
                jComboBoxKlasse.addItem(className);
            }
            klasse = className;
            jComboBoxKlasse.setSelectedItem(className);
            jTextFieldKlasse.setText(className);
        }

        

        Collection<Downloader> colC = mDownloaderPool.getMapForKlasse(klasse).values();
        Iterator<Downloader> iterC = colC.iterator();

        jComboBoxName.removeAllItems();
        i = 0;
        while (iterC.hasNext())
        {
            Downloader item = iterC.next();
            jComboBoxName.addItem(item.mName);
            if ((i==0) && (select))
            {
                jComboBoxName.setSelectedIndex(0);
                mDownloader = mDownloaderPool.get(item.mName);
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
        mDownloader = new Downloader();
        if (forcedClass)
            mDownloader.mClass = className;
        setAllFromCurrent();
        mClassSetting--;
    }

    private void setAllFromCurrent() /* allneeded*/
    {
        mClassSetting++;
        jComboBoxKlasse.setSelectedItem(mDownloader.mClass);
        jTextFieldKlasse.setText(mDownloader.mClass);
        jComboBoxName.setSelectedItem(mDownloader.mName);
        jTextFieldName.setText(mDownloader.mName);
        jTabbedPane1.removeAll();

        jTextField1.setText(mDownloader.mURL );
        jTextField6.setText(mDownloader.mDestinationDirAll );
        jCheckBox1.setSelected(mDownloader.misZip);
        jCheckBox2.setSelected(mDownloader.mUnpackAll );

        for (int i=0; i<mDownloader.mFileInZip.size();i++)
        {
            JPanel jPanel3 = new javax.swing.JPanel();
            JLabel jLabel6 = new javax.swing.JLabel();
            JTextField jTextField4 = new javax.swing.JTextField();
            JLabel jLabel7 = new javax.swing.JLabel();
            JTextField jTextField5 = new javax.swing.JTextField();
            JButton jButtonFileSelect4 = new javax.swing.JButton();
        jTextField4.setPreferredSize(new java.awt.Dimension(6, 21));
        jTextField5.setPreferredSize(new java.awt.Dimension(6, 21));

            jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder("Zip"));

            jLabel6.setText("Name in Zip");

            jLabel7.setText("Name unpacked");

            jButtonFileSelect4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
            jButtonFileSelect4.setMargin(new java.awt.Insets(0, 1, 0, -1));
            final JTextField bla = jTextField5;
            jButtonFileSelect4.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) 
                {
                    InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
                    fc.setMultiSelectionEnabled(false);
                    fc.setCurrentDirectory(new java.io.File(lastImagePath));
                    int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
                    if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
                    File files = fc.getSelectedFile();
                    if (files != null) 
                    {
                        String fullPath = fc.getSelectedFile().getAbsolutePath();
                        lastImagePath = fullPath;
                        bla.setText(de.malban.util.Utility.makeRelative(fullPath));
                    }
                }
            });

            javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
            jPanel3.setLayout(jPanel3Layout);
            jPanel3Layout.setHorizontalGroup(
                jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel3Layout.createSequentialGroup()
                    .addContainerGap()
                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jLabel7)
                        .addComponent(jLabel6))
                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jTextField4)
                        .addGroup(jPanel3Layout.createSequentialGroup()
                            .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 382, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                            .addComponent(jButtonFileSelect4)
                            .addGap(0, 0, Short.MAX_VALUE)))
                    .addContainerGap())
            );
            jPanel3Layout.setVerticalGroup(
                jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel3Layout.createSequentialGroup()
                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addGroup(jPanel3Layout.createSequentialGroup()
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel6)
                                .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel7)
                                .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addComponent(jButtonFileSelect4))
                    .addGap(0, 10, Short.MAX_VALUE))
            );

            jTextField4.setText(mDownloader.mFileInZip.elementAt(i));
            jTextField5.setText(mDownloader.mFileUnpacked.elementAt(i));
            jTabbedPane1.addTab("File "+(i+1), jPanel3);            
        }
        jButtonFileSelect10.setEnabled(jCheckBox1.isSelected());
        jButtonFileSelect11.setEnabled(jCheckBox1.isSelected());
        jCheckBox2.setEnabled(jCheckBox1.isSelected());
        jTabbedPane1.setEnabled(jCheckBox1.isSelected());
        if (jCheckBox2.isSelected())
        {
            jTabbedPane1.setEnabled(false);
        }
        setTabEnabled();
        mClassSetting--;
    }

    private void readAllToCurrent() /* allneeded*/
    {
        mDownloader.mClass = jTextFieldKlasse.getText();
        mDownloader.mName = jTextFieldName.getText();

        mDownloader.mURL = jTextField1.getText();
        mDownloader.mDestinationDirAll = jTextField6.getText();
        mDownloader.misZip = jCheckBox1.isSelected();
        mDownloader.mUnpackAll = jCheckBox2.isSelected();
        mDownloader.mFileInZip.clear();
        mDownloader.mFileUnpacked.clear();
        for (int i=0; i < jTabbedPane1.getTabCount(); i++)
        {
            JPanel p = (JPanel) jTabbedPane1.getComponentAt(i);
            JTextField t= (JTextField)p.getComponent(2);
            mDownloader.mFileInZip.addElement(t.getText());
            t= (JTextField)p.getComponent(3);
            mDownloader.mFileUnpacked.addElement(t.getText());
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
        jPanel2 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jCheckBox1 = new javax.swing.JCheckBox();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel3 = new javax.swing.JPanel();
        jLabel6 = new javax.swing.JLabel();
        jTextField4 = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jTextField5 = new javax.swing.JTextField();
        jButtonFileSelect4 = new javax.swing.JButton();
        jButtonFileSelect10 = new javax.swing.JButton();
        jButtonFileSelect11 = new javax.swing.JButton();
        jCheckBox2 = new javax.swing.JCheckBox();
        jLabel8 = new javax.swing.JLabel();
        jTextField6 = new javax.swing.JTextField();
        jButtonFileSelect5 = new javax.swing.JButton();

        jPanel1.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jComboBoxKlasse.setPreferredSize(new java.awt.Dimension(150, 21));
        jComboBoxKlasse.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxKlasseActionPerformed(evt);
            }
        });

        jComboBoxName.setPreferredSize(new java.awt.Dimension(150, 21));
        jComboBoxName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxNameActionPerformed(evt);
            }
        });

        jLabel3.setText("Name");

        jLabel4.setText("Class");

        jTextFieldName.setPreferredSize(new java.awt.Dimension(150, 21));

        jTextFieldKlasse.setPreferredSize(new java.awt.Dimension(150, 21));

        jButtonNew.setText("New");
        jButtonNew.setPreferredSize(new java.awt.Dimension(130, 21));
        jButtonNew.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewActionPerformed(evt);
            }
        });

        jButtonSave.setText("Save");
        jButtonSave.setPreferredSize(new java.awt.Dimension(130, 21));
        jButtonSave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveActionPerformed(evt);
            }
        });

        jButtonSaveAsNew.setText("Save as new");
        jButtonSaveAsNew.setPreferredSize(new java.awt.Dimension(130, 21));
        jButtonSaveAsNew.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveAsNewActionPerformed(evt);
            }
        });

        jButtonDelete.setText("Delete");
        jButtonDelete.setPreferredSize(new java.awt.Dimension(130, 21));
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
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextFieldKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jComboBoxKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBoxName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonSave, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonNew, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonDelete, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonSaveAsNew, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonNew, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonDelete, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jComboBoxKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonSaveAsNew, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonSave, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jComboBoxName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(16, 16, 16)
                        .addComponent(jLabel4))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(43, 43, 43)
                        .addComponent(jLabel3)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jLabel1.setText("URL");

        jTextField1.setPreferredSize(new java.awt.Dimension(600, 21));

        jCheckBox1.setText("isZip");
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jTabbedPane1.setEnabled(false);

        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder("Zip"));

        jLabel6.setText("Name in Zip");

        jTextField4.setPreferredSize(new java.awt.Dimension(6, 21));

        jLabel7.setText("Name unpacked");

        jTextField5.setPreferredSize(new java.awt.Dimension(6, 21));

        jButtonFileSelect4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
        jButtonFileSelect4.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect4ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel6)
                    .addComponent(jLabel7))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 417, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 382, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButtonFileSelect4)))
                .addContainerGap(76, Short.MAX_VALUE))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel6)
                    .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel7)
                        .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButtonFileSelect4))
                .addGap(0, 47, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("File #", jPanel3);

        jButtonFileSelect10.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/add.png"))); // NOI18N
        jButtonFileSelect10.setEnabled(false);
        jButtonFileSelect10.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect10ActionPerformed(evt);
            }
        });

        jButtonFileSelect11.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/delete.png"))); // NOI18N
        jButtonFileSelect11.setEnabled(false);
        jButtonFileSelect11.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect11ActionPerformed(evt);
            }
        });

        jCheckBox2.setText("complete Unzip");
        jCheckBox2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox2ActionPerformed(evt);
            }
        });

        jLabel8.setText("Destination");

        jTextField6.setToolTipText("Complete Unzip - or single file");
        jTextField6.setPreferredSize(new java.awt.Dimension(6, 21));

        jButtonFileSelect5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
        jButtonFileSelect5.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect5ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel8)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, 535, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButtonFileSelect5))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel2Layout.createSequentialGroup()
                                .addComponent(jCheckBox1)
                                .addGap(18, 18, 18)
                                .addComponent(jButtonFileSelect10)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonFileSelect11)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jCheckBox2))
                            .addComponent(jTabbedPane1)
                            .addComponent(jTextField1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox1)
                            .addComponent(jButtonFileSelect10)
                            .addComponent(jButtonFileSelect11)
                            .addComponent(jCheckBox2))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTabbedPane1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel8)))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addComponent(jButtonFileSelect5)))
                .addGap(70, 70, 70))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewActionPerformed
        mClassSetting++;
        mDownloader = new Downloader();
        clearAll();
        if (forcedClass)
            resetConfigPool(false, className);
        else
            resetConfigPool(false, "");
        mClassSetting--;
}//GEN-LAST:event_jButtonNewActionPerformed

    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed

        readAllToCurrent();
        mDownloaderPool.put(mDownloader);
        String name = mDownloader.mName;
        mDownloaderPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true, klasse);
        mClassSetting--;
        jComboBoxName.setSelectedItem(name);
    }//GEN-LAST:event_jButtonSaveActionPerformed

    private void jButtonSaveAsNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveAsNewActionPerformed
        mDownloader = new Downloader();
        readAllToCurrent();
        mDownloaderPool.putAsNew(mDownloader);
        mDownloaderPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true,klasse);
        jComboBoxName.setSelectedItem(mDownloader.mName);
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveAsNewActionPerformed

    private void jButtonDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteActionPerformed
        readAllToCurrent();
        mDownloaderPool.remove(mDownloader);
        mDownloaderPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true,klasse);

        if (jComboBoxName.getSelectedIndex() == -1)
        {
            clearAll();
        }
        if (jComboBoxName.getItemCount()==0)
        {
            jButtonNewActionPerformed(null);
            mClassSetting--;
            return;
        }
        
        String key = jComboBoxName.getSelectedItem().toString();
        mDownloader = mDownloaderPool.get(key);
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
        mDownloader = mDownloaderPool.get(key);
        setAllFromCurrent();
        mClassSetting--;
    }//GEN-LAST:event_jComboBoxKlasseActionPerformed

    private void jComboBoxNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxNameActionPerformed
        if (mClassSetting > 0 ) return;
        String key = jComboBoxName.getSelectedItem().toString();
        mDownloader = mDownloaderPool.get(key);
        setAllFromCurrent();
    }//GEN-LAST:event_jComboBoxNameActionPerformed

    private void jButtonFileSelect4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect4ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jButtonFileSelect4ActionPerformed

    private void jButtonFileSelect10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect10ActionPerformed

        JPanel jPanel3 = new javax.swing.JPanel();
        JLabel jLabel6 = new javax.swing.JLabel();
        JTextField jTextField4 = new javax.swing.JTextField();
        JLabel jLabel7 = new javax.swing.JLabel();
        JTextField jTextField5 = new javax.swing.JTextField();
        JButton jButtonFileSelect4 = new javax.swing.JButton();
        jTextField4.setPreferredSize(new java.awt.Dimension(6, 21));
        jTextField5.setPreferredSize(new java.awt.Dimension(6, 21));
        
        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder("Zip"));

        jLabel6.setText("Name in Zip");

        jLabel7.setText("Name unpacked");

        jButtonFileSelect4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
        jButtonFileSelect4.setMargin(new java.awt.Insets(0, 1, 0, -1));
        final JTextField bla = jTextField5;
        jButtonFileSelect4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                    InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
                    fc.setMultiSelectionEnabled(false);
                    fc.setCurrentDirectory(new java.io.File(lastImagePath));
                    int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
                    if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
                    File files = fc.getSelectedFile();
                    if (files != null) 
                    {
                        String fullPath = fc.getSelectedFile().getAbsolutePath();
                        lastImagePath = fullPath;
                        bla.setText(de.malban.util.Utility.makeRelative(fullPath));
                    }
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel7)
                    .addComponent(jLabel6))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField4)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 382, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButtonFileSelect4)
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel6)
                            .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel7)
                            .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addComponent(jButtonFileSelect4))
                .addGap(0, 10, Short.MAX_VALUE))
        );

        mDownloader.mFileInZip.addElement("");
        mDownloader.mFileUnpacked.addElement("");
        jTabbedPane1.addTab("File "+mDownloader.mFileInZip.size(), jPanel3);
    }//GEN-LAST:event_jButtonFileSelect10ActionPerformed

    private void jButtonFileSelect11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect11ActionPerformed
        if (mDownloader.mFileInZip.size()==0) return;
        mDownloader.mFileInZip.removeElementAt(mDownloader.mFileInZip.size()-1);
        mDownloader.mFileUnpacked.removeElementAt(mDownloader.mFileUnpacked.size()-1);
        jTabbedPane1.remove(jTabbedPane1.getTabCount()-1);

    }//GEN-LAST:event_jButtonFileSelect11ActionPerformed

    private void jButtonFileSelect5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect5ActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setMultiSelectionEnabled(false);
        fc.setCurrentDirectory(new java.io.File(lastImagePath));
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        File files = fc.getSelectedFile();
        if (files != null) 
        {
            String fullPath = fc.getSelectedFile().getAbsolutePath();
            lastImagePath = fullPath;
            jTextField6.setText(de.malban.util.Utility.makeRelative(fullPath));
        }
    }//GEN-LAST:event_jButtonFileSelect5ActionPerformed

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        jButtonFileSelect10.setEnabled(jCheckBox1.isSelected());
        jButtonFileSelect11.setEnabled(jCheckBox1.isSelected());
        jCheckBox2.setEnabled(jCheckBox1.isSelected());
        jTabbedPane1.setEnabled(jCheckBox1.isSelected());
        if (jCheckBox2.isSelected())
        {
            jTabbedPane1.setEnabled(false);
        }
        setTabEnabled();
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jCheckBox2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox2ActionPerformed
        jTabbedPane1.setEnabled(jCheckBox1.isSelected());
        if (jCheckBox2.isSelected())
        {
            jTabbedPane1.setEnabled(false);
        }
        setTabEnabled();
    }//GEN-LAST:event_jCheckBox2ActionPerformed
    void setTabEnabled()
    {
        for (int i=0; i< jTabbedPane1.getTabCount(); i++)
        {
            ((JPanel)jTabbedPane1.getComponentAt(i)).setEnabled(jTabbedPane1.isEnabled());
            for (int ii=0; ii< ((JPanel)jTabbedPane1.getComponentAt(i)).getComponentCount(); ii++)
            {
                JComponent c = (JComponent)((JPanel)jTabbedPane1.getComponentAt(i)).getComponent(ii);
                c.setEnabled(jTabbedPane1.isEnabled());
            }
        }
        
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonDelete;
    private javax.swing.JButton jButtonFileSelect10;
    private javax.swing.JButton jButtonFileSelect11;
    private javax.swing.JButton jButtonFileSelect4;
    private javax.swing.JButton jButtonFileSelect5;
    private javax.swing.JButton jButtonNew;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JButton jButtonSaveAsNew;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JComboBox jComboBoxKlasse;
    private javax.swing.JComboBox jComboBoxName;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField4;
    private javax.swing.JTextField jTextField5;
    private javax.swing.JTextField jTextField6;
    private javax.swing.JTextField jTextFieldKlasse;
    private javax.swing.JTextField jTextFieldName;
    // End of variables declaration//GEN-END:variables

    public static Downloader getDownloader(String mClass, String mName)
    {
        DownloaderPool downloaderPool = new DownloaderPool();
        Collection<Downloader> colC = downloaderPool.getMapForKlasse(mClass).values();
        Iterator<Downloader> iterC = colC.iterator();

        while (iterC.hasNext())
        {
            Downloader item = iterC.next();
            if (item.mName.equals(mName)) return item;
        }        
        return null;
    }
    static int loaded;
    static boolean finished=true;
    static class WorkerThread extends Thread
    {
        String result;
        String _url;
        String destinationName;
        public void run()
        {
           result = saveUrlInternal( _url, destinationName);
        }
        public String getResult()
        {
            return result;
        }
    };
    public static String saveUrl(String _url, String destinationName)
    {
        if (!finished) return null;
        loaded = 0;
        finished = false;
        WorkerThread runner = new WorkerThread();
        runner._url = _url;
        runner.destinationName = destinationName;
        runner.start();
        
        ShowInfoDialog dialog = new ShowInfoDialog();
        dialog.setButtonVisible(false);
        dialog.setText("Loading file from internet...");
        CSAInternalFrame frame = new CSAInternalFrame();
        Rectangle bb = frame.getBounds();
        frame.setBounds(bb.x, bb.y, 400, 150);
        frame.setParent((CSAView)Configuration.getConfiguration().getMainFrame());
        frame.addPanel(dialog);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addInternalFrame(frame);

        frame.setVisible(true);
        while (!finished)
        {
            try
            {
                Thread.sleep(100);
                dialog.setText("Loading file from internet... "+loaded+" bytes...");
            }
            catch (Throwable e)
            {
                
            }
        }
        frame.setVisible(false);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).removeInternalFrame(frame);
        
        return runner.getResult();
    }
    // if destination file exists, nothing is loaded
    // we assume the file was downloaded befor!
    public static String saveUrlInternal(String _url, String destinationName)
    {
        File ff = new File(destinationName);
        if (ff.exists()) 
        {
            finished = true;
            return destinationName;
        }
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        Proxy p = null;
        p = Proxy.NO_PROXY;
        try
        {
            BufferedInputStream in;
            BufferedOutputStream out;
            URL url = new URL(_url);


            File f = new File(destinationName);
            in = new BufferedInputStream(url.openConnection(p).getInputStream());
            out = new BufferedOutputStream(new FileOutputStream(f));
            byte[] b = new byte[10000];
            int len = in.read(b);
            while (len != -1)
            {
                out.write(b, 0, len);
                len = in.read(b);
                loaded+=len;
            }
            in.close();
            out.close();
        } 
        catch (Throwable e)
        {
            log.addLog(e, de.malban.gui.panels.LogPanel.ERROR);
            finished = true;
            return null;
        }
        log.addLog("Download from "+_url+" -> "+destinationName+" - done", INFO);
        finished = true;
        return destinationName;
    }    
    public static boolean ensureLocalFile(String mClass, String mName, String localFile)
    {
        if (mName==null) return true; // no downloadable
        if (mName.trim().length()==0) return true; // no downloadable
        File f = new File(convertSeperator(localFile));
        if (!f.isDirectory())
            if (f.exists()) return true;
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        boolean ret = true;
        
        
        Downloader downloader = getDownloader( mClass,  mName);
        if (downloader == null)
        {
            log.addLog("DownloaderPanel: download config not found: "+mClass+"->"+mName, WARN);
            return false;
        }
        if (!downloader.misZip)
        {
            String name = convertSeperator(downloader.mDestinationDirAll);
            f = new File(name);
            if (f.exists()) return true;
            // no - try downloading
            String savedName = saveUrl(downloader.mURL, name);
            if ( savedName == null) return false;
            f = new File(name);
            if (f.exists()) return true;
            return false;
        }

        BufferedInputStream in;
        BufferedOutputStream out;
        int last = downloader.mURL.lastIndexOf("/");
        if (last == -1) 
        {
            log.addLog("DownloaderPanel: url is weird: "+downloader.mURL, WARN);
            return false;            
        }
        String[] adder = mName.split(" ");
        String loadedZipName = "download"+File.separator+"zips"+File.separator+ adder[0]+ downloader.mURL.substring(last+1);

        
        String savedName = saveUrl(downloader.mURL, loadedZipName);
        if ( savedName == null) return false;
        try
        {
            if (downloader.mUnpackAll)
            {
                de.malban.util.UtilityFiles.unzip(savedName, downloader.mDestinationDirAll);
            }
            else
            {
                de.malban.util.UtilityFiles.unzip(savedName, "tmp");
                for (int i=0; i<downloader.mFileInZip.size();i++)
                {
                    de.malban.util.UtilityFiles.copyOneFile("tmp"+File.separator+convertSeperator(downloader.mFileInZip.elementAt(i)), convertSeperator(downloader.mFileUnpacked.elementAt(i)));

                }
            }
            de.malban.util.UtilityFiles.cleanDirectory("tmp");
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            return false;
        }
        return ret;
    }
    public static String convertSeperator(String filename)
    {
        String ret = de.malban.util.UtilityString.replace(filename, "/", File.separator);
        ret = de.malban.util.UtilityString.replace(ret, "\\", File.separator);
        return ret;
    }
}
