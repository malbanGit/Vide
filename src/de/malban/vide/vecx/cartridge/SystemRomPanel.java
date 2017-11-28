package de.malban.vide.vecx.cartridge;


import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import java.io.File;
import java.util.*;
import javax.swing.filechooser.FileNameExtensionFilter;

public class SystemRomPanel extends javax.swing.JPanel implements Windowable{
    private SystemRom mSystemRom = new SystemRom();
    private SystemRomPool mSystemRomPool;
    private int mClassSetting=0;

    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
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
        mParentMenuItem.setText("SystemRom");

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

    /** Creates new form SystemRomPanel */
    public SystemRomPanel() {
        initComponents();
        mSystemRomPool = new SystemRomPool();
        resetConfigPool(true, "SystemRom");
        jLabel4.setVisible(false);
        jTextFieldKlasse.setVisible(false);
        jComboBoxKlasse.setVisible(false);
    }

    private void resetConfigPool(boolean select, String klasseToSet) /* allneeded*/
    {
        mClassSetting++;
        Collection<String> collectionKlasse = mSystemRomPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        int i = 0;
        String klasse = "SystemRom";

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

        Collection<SystemRom> colC = mSystemRomPool.getMapForKlasse(klasse).values();
        Iterator<SystemRom> iterC = colC.iterator();

        jComboBoxName.removeAllItems();
        i = 0;
        while (iterC.hasNext())
        {
            SystemRom item = iterC.next();
            jComboBoxName.addItem(item.mName);
            if ((i==0) && (select))
            {
                jComboBoxName.setSelectedIndex(0);
                mSystemRom = mSystemRomPool.get(item.mName);
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
        mSystemRom = new SystemRom();
        setAllFromCurrent();
        mClassSetting--;
    }

    private void setAllFromCurrent() /* allneeded*/
    {
        mClassSetting++;
        jComboBoxKlasse.setSelectedItem("SystemRom");
        jTextFieldKlasse.setText("SystemRom");
        jComboBoxName.setSelectedItem(mSystemRom.mName);
        jTextFieldName.setText(mSystemRom.mName);

        jTextPane1.setText(mSystemRom.mComment);
        jTextField1.setText(mSystemRom.mVersion);
       jTextFieldPath2.setText(mSystemRom.mCartName);
        mClassSetting--;
    }

    private void readAllToCurrent() /* allneeded*/
    {
        mSystemRom.mClass = "SystemRom";
        mSystemRom.mName = jTextFieldName.getText();

        
        mSystemRom.mComment = jTextPane1.getText();
        mSystemRom.mVersion = jTextField1.getText();
        mSystemRom.mCartName = jTextFieldPath2.getText();
        
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
        jComboBoxName = new javax.swing.JComboBox();
        jLabel3 = new javax.swing.JLabel();
        jTextFieldName = new javax.swing.JTextField();
        jButtonNew = new javax.swing.JButton();
        jButtonSave = new javax.swing.JButton();
        jButtonSaveAsNew = new javax.swing.JButton();
        jButtonDelete = new javax.swing.JButton();
        jPanel2 = new javax.swing.JPanel();
        jLabel10 = new javax.swing.JLabel();
        jTextFieldPath2 = new javax.swing.JTextField();
        jButtonFileSelect3 = new javax.swing.JButton();
        jLabel1 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTextPane1 = new javax.swing.JTextPane();
        jLabel4 = new javax.swing.JLabel();
        jTextFieldKlasse = new javax.swing.JTextField();
        jComboBoxKlasse = new javax.swing.JComboBox();

        jPanel1.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jComboBoxName.setPreferredSize(new java.awt.Dimension(28, 21));
        jComboBoxName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxNameActionPerformed(evt);
            }
        });

        jLabel3.setText("Name");

        jTextFieldName.setPreferredSize(new java.awt.Dimension(28, 21));

        jButtonNew.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/new.png"))); // NOI18N
        jButtonNew.setText("New");
        jButtonNew.setPreferredSize(new java.awt.Dimension(130, 21));
        jButtonNew.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewActionPerformed(evt);
            }
        });

        jButtonSave.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/disk.png"))); // NOI18N
        jButtonSave.setText("Save");
        jButtonSave.setPreferredSize(new java.awt.Dimension(130, 21));
        jButtonSave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveActionPerformed(evt);
            }
        });

        jButtonSaveAsNew.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/disk_add.png"))); // NOI18N
        jButtonSaveAsNew.setText("Save as new");
        jButtonSaveAsNew.setPreferredSize(new java.awt.Dimension(130, 21));
        jButtonSaveAsNew.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveAsNewActionPerformed(evt);
            }
        });

        jButtonDelete.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/cross.png"))); // NOI18N
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
                .addComponent(jLabel3)
                .addGap(16, 16, 16)
                .addComponent(jTextFieldName, javax.swing.GroupLayout.PREFERRED_SIZE, 146, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jComboBoxName, javax.swing.GroupLayout.PREFERRED_SIZE, 146, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButtonSave, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonNew, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonSaveAsNew, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDelete, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(3, 3, 3)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonNew, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonDelete, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jComboBoxName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel3)
                                    .addComponent(jTextFieldName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButtonSave, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonSaveAsNew, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(4, 4, 4))
        );

        jLabel10.setText("File");

        jTextFieldPath2.setPreferredSize(new java.awt.Dimension(6, 21));

        jButtonFileSelect3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
        jButtonFileSelect3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect3ActionPerformed(evt);
            }
        });

        jLabel1.setText("Version");

        jTextField1.setPreferredSize(new java.awt.Dimension(6, 21));

        jLabel2.setText("Comment");

        jScrollPane1.setViewportView(jTextPane1);

        jLabel4.setText("Class");

        jTextFieldKlasse.setText("SystemRom");
        jTextFieldKlasse.setPreferredSize(new java.awt.Dimension(0, 21));

        jComboBoxKlasse.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "SystemRom" }));
        jComboBoxKlasse.setPreferredSize(new java.awt.Dimension(0, 21));
        jComboBoxKlasse.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxKlasseActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel10)
                    .addComponent(jLabel1)
                    .addComponent(jLabel2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jTextFieldPath2, javax.swing.GroupLayout.PREFERRED_SIZE, 227, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(12, 12, 12)
                        .addComponent(jButtonFileSelect3))
                    .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 67, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 259, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jLabel4)
                    .addComponent(jComboBoxKlasse, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jTextFieldKlasse, javax.swing.GroupLayout.DEFAULT_SIZE, 135, Short.MAX_VALUE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonFileSelect3)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel10)
                        .addComponent(jTextFieldPath2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel2)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 142, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jComboBoxKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(50, 50, 50))))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewActionPerformed
        mClassSetting++;
        mSystemRom = new SystemRom();
        clearAll();
        resetConfigPool(false, "SystemRom");
        mClassSetting--;
}//GEN-LAST:event_jButtonNewActionPerformed

    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed

        readAllToCurrent();
        mSystemRomPool.put(mSystemRom);
        mSystemRomPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true, klasse);
        jComboBoxName.setSelectedItem(mSystemRom.mName);
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveActionPerformed

    private void jButtonSaveAsNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveAsNewActionPerformed
        mSystemRom = new SystemRom();
        readAllToCurrent();
        mSystemRomPool.putAsNew(mSystemRom);
        mSystemRomPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true,klasse);
        jComboBoxName.setSelectedItem(mSystemRom.mName);
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveAsNewActionPerformed

    private void jButtonDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteActionPerformed
        readAllToCurrent();
        mSystemRomPool.remove(mSystemRom);
        mSystemRomPool.save();
        mClassSetting++;
        String klasse = jTextFieldKlasse.getText();
        resetConfigPool(true,klasse);

        if (jComboBoxName.getSelectedIndex() == -1)
        {
            clearAll();
        }

        String key = jComboBoxName.getSelectedItem().toString();
        mSystemRom = mSystemRomPool.get(key);
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
        mSystemRom = mSystemRomPool.get(key);
        setAllFromCurrent();
        mClassSetting--;
    }//GEN-LAST:event_jComboBoxKlasseActionPerformed

    private void jComboBoxNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxNameActionPerformed
        if (mClassSetting > 0 ) return;
        String key = jComboBoxName.getSelectedItem().toString();
        mSystemRom = mSystemRomPool.get(key);
        setAllFromCurrent();
    }//GEN-LAST:event_jComboBoxNameActionPerformed

    String lastImagePath=Global.mainPathPrefix+"system"+File.separator;
    private void jButtonFileSelect3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect3ActionPerformed

        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setMultiSelectionEnabled(false);
        if (lastImagePath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File(Global.mainPathPrefix+"system"+File.separator));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastImagePath));
        }
        FileNameExtensionFilter  filter = new  FileNameExtensionFilter("Vectrex roms", "vec", "rom", "bin", "img");
        fc.setFileFilter(filter);
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        File files = fc.getSelectedFile();
        if (files != null)
        {
            String fullPath = fc.getSelectedFile().getAbsolutePath();
            lastImagePath = fullPath;
            jTextFieldPath2.setText(de.malban.util.Utility.makeRelative(fullPath));
        }
    }//GEN-LAST:event_jButtonFileSelect3ActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonDelete;
    private javax.swing.JButton jButtonFileSelect3;
    private javax.swing.JButton jButtonNew;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JButton jButtonSaveAsNew;
    private javax.swing.JComboBox jComboBoxKlasse;
    private javax.swing.JComboBox jComboBoxName;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextFieldKlasse;
    private javax.swing.JTextField jTextFieldName;
    private javax.swing.JTextField jTextFieldPath2;
    private javax.swing.JTextPane jTextPane1;
    // End of variables declaration//GEN-END:variables

    public void deIconified() { }
}
