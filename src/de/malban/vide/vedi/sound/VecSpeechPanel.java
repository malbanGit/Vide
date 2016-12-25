/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;

import de.malban.config.Configuration;
import de.malban.config.TinyLogInterface;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.vide.vecx.devices.VecSpeechDevice;
import de.malban.vide.vecx.devices.VecVoiceSamples;
import de.malban.vide.vecx.devices.VecVoiceSamples.SP0256AL;
import de.malban.vide.vecx.devices.VecVoxSamples;
import de.malban.vide.vecx.devices.VecVoxSamples.SpeakJetMSA;
import de.malban.vide.vecx.devices.VecVoxSamples.SpeakSpecials;
import de.malban.vide.vedi.VediPanel;
import de.muntjak.tinylookandfeel.Theme;
import java.awt.Point;
import java.awt.event.MouseEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Vector;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JTable;
import javax.swing.UIManager;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author chrissalo
 */
public class VecSpeechPanel extends javax.swing.JPanel  implements Windowable
{
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    TinyLogInterface tinyLog = null;
    private int mClassSetting=0;
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;

    @Override
    public void closing()
    {
        removeUIListerner();
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
        mParentMenuItem.setText("VecSpeechPanel");
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
    
    
    public class VecVoxSpecialTableModel extends AbstractTableModel
    {    
        String[] columns = {"\"Mnemonic\"", "Code(s)"};

        @Override
        public String getColumnName(int col) {
            return columns[col];
        }
        @Override
        public int getRowCount() {
            return VecVoxSamples.getAllSpecials().size();
        }

        @Override
        public int getColumnCount() {
            return columns.length;
        }
        @Override
        public Object getValueAt(int row, int col) {
            if ((row<0) || (row > 128)) return "";
            if (col==0) return VecVoxSamples.getAllSpecials().get(row).mnemonic;
            if (col==1) return ""+VecVoxSamples.getAllSpecials().get(row).codes;
            return "";
        }
        @Override
        public Class<?> getColumnClass(int col) 
        {
            return Object.class;
        }
        @Override
        public boolean isCellEditable(int row, int col) 
        {
            return false;
        }
    }    
    public class VecVoxTableModel extends AbstractTableModel
    {    
        String[] columns = {"\"Mnemonic\"", "Code", "Example"};

        @Override
        public String getColumnName(int col) {
            return columns[col];
        }
        @Override
        public int getRowCount() {
            return VecVoxSamples.getAllSamples().length;
        }

        @Override
        public int getColumnCount() {
            return columns.length;
        }
        @Override
        public Object getValueAt(int row, int col) {
            if ((row<0) || (row > 128)) return "";
            if (col==0) return VecVoxSamples.getAllSamples()[row].phoneme;
            if (col==1) return ""+VecVoxSamples.getAllSamples()[row].code;
            if (col==2) return VecVoxSamples.getAllSamples()[row].sampleWords;
            return "";
        }
        @Override
        public Class<?> getColumnClass(int col) 
        {
            return Object.class;
        }
        @Override
        public boolean isCellEditable(int row, int col) 
        {
            return false;
        }
    }    
    public class VecVoiceTableModel extends AbstractTableModel
    {    
        String[] columns = {"\"Mnemonic\"", "Code", "Example"};

        @Override
        public String getColumnName(int col) {
            return columns[col];
        }
        @Override
        public int getRowCount() {
            return VecVoiceSamples.getAllSamples().length;
        }

        @Override
        public int getColumnCount() {
            return columns.length;
        }
        @Override
        public Object getValueAt(int row, int col) {
            if ((row<0) || (row > 63)) return "";
            if (col==0) return VecVoiceSamples.getAllSamples()[row].phoneme;
            if (col==1) return ""+VecVoiceSamples.getAllSamples()[row].code;
            if (col==2) return VecVoiceSamples.getAllSamples()[row].sampleWords;
            return "";
        }
        @Override
        public Class<?> getColumnClass(int col) 
        {
            return Object.class;
        }
        @Override
        public boolean isCellEditable(int row, int col) 
        {
            return false;
        }
    }    
    
    /**
     * Creates new form VecSpeechPanel
     */
    public VecSpeechPanel(TinyLogInterface tl) {
        initComponents();
        tinyLog = tl;
        jTable1.setModel(new VecVoxTableModel());
        jTable2.setModel(new VecVoxSpecialTableModel());
        loadPhrases();
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
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
        buttonGroup2 = new javax.swing.ButtonGroup();
        jButtonCreate = new javax.swing.JButton();
        jRadioButtonVecVoice = new javax.swing.JRadioButton();
        jRadioButtonVecVox = new javax.swing.JRadioButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jLabel1 = new javax.swing.JLabel();
        jButtonPlayVectrex = new javax.swing.JButton();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTextAreaInputText = new javax.swing.JTextArea();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTextAreaTranslation = new javax.swing.JTextArea();
        jLabel4 = new javax.swing.JLabel();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTextArea3 = new javax.swing.JTextArea();
        jCheckBox1 = new javax.swing.JCheckBox();
        jCheckBoxPhrasealator = new javax.swing.JCheckBox();
        jCheckBoxNaval = new javax.swing.JCheckBox();
        jCheckBoxAutoPause = new javax.swing.JCheckBox();
        jScrollPane5 = new javax.swing.JScrollPane();
        jTable2 = new javax.swing.JTable();
        jLabel5 = new javax.swing.JLabel();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox3 = new javax.swing.JCheckBox();
        jTextField1 = new javax.swing.JTextField();
        jCheckBox4 = new javax.swing.JCheckBox();
        jTextField2 = new javax.swing.JTextField();
        jCheckBox5 = new javax.swing.JCheckBox();

        jButtonCreate.setText("create source");
        jButtonCreate.setName("create"); // NOI18N
        jButtonCreate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCreateActionPerformed(evt);
            }
        });

        buttonGroup1.add(jRadioButtonVecVoice);
        jRadioButtonVecVoice.setText("VecVoice");
        jRadioButtonVecVoice.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButtonVecVoiceActionPerformed(evt);
            }
        });

        buttonGroup1.add(jRadioButtonVecVox);
        jRadioButtonVecVox.setSelected(true);
        jRadioButtonVecVox.setText("VecVox");
        jRadioButtonVecVox.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButtonVecVoxActionPerformed(evt);
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
        jTable1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTable1MouseClicked(evt);
            }
        });
        jScrollPane1.setViewportView(jTable1);

        jLabel1.setText("\"phonemes\"");

        jButtonPlayVectrex.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jButtonPlayVectrex.setToolTipText("Play current sample!");
        jButtonPlayVectrex.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonPlayVectrex.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPlayVectrexActionPerformed(evt);
            }
        });

        jTextAreaInputText.setColumns(20);
        jTextAreaInputText.setRows(5);
        jTextAreaInputText.setText("fxburp \\RESET \\P3 \\P3 \nfxdanger\nfxalarm\nfxrobotdroid\nfxmonths\nfxnumbers\n");
        jTextAreaInputText.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextAreaInputTextKeyTyped(evt);
            }
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextAreaInputTextKeyReleased(evt);
            }
        });
        jScrollPane2.setViewportView(jTextAreaInputText);

        jLabel2.setText("Text");

        jLabel3.setText("Translation");

        jTextAreaTranslation.setColumns(20);
        jTextAreaTranslation.setRows(5);
        jScrollPane3.setViewportView(jTextAreaTranslation);

        jLabel4.setText("Code");

        jTextArea3.setColumns(20);
        jTextArea3.setRows(5);
        jScrollPane4.setViewportView(jTextArea3);

        jCheckBox1.setSelected(true);
        jCheckBox1.setText("create full example");

        jCheckBoxPhrasealator.setSelected(true);
        jCheckBoxPhrasealator.setText("Phrasealator");
        jCheckBoxPhrasealator.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxPhrasealatorActionPerformed(evt);
            }
        });

        jCheckBoxNaval.setSelected(true);
        jCheckBoxNaval.setText("Naval rules");
        jCheckBoxNaval.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxNavalActionPerformed(evt);
            }
        });

        jCheckBoxAutoPause.setSelected(true);
        jCheckBoxAutoPause.setText("auto pause");
        jCheckBoxAutoPause.setToolTipText("insert a short pause for each \"space\"");
        jCheckBoxAutoPause.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxAutoPauseActionPerformed(evt);
            }
        });

        jTable2.setModel(new javax.swing.table.DefaultTableModel(
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
        jTable2.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTable2MouseClicked(evt);
            }
        });
        jScrollPane5.setViewportView(jTable2);

        jLabel5.setText("Speakjet commands");

        jCheckBox2.setSelected(true);
        jCheckBox2.setText("use jetphones");
        jCheckBox2.setToolTipText("in generated sources use the atariVox \"JetPhones.inc\" for better readability.");

        jCheckBox3.setSelected(true);
        jCheckBox3.setText("blend enable");
        jCheckBox3.setEnabled(false);
        jCheckBox3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox3ActionPerformed(evt);
            }
        });

        jTextField1.setText("15");
        jTextField1.setEnabled(false);

        jCheckBox4.setSelected(true);
        jCheckBox4.setText("suppress silence");
        jCheckBox4.setEnabled(false);
        jCheckBox4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox4ActionPerformed(evt);
            }
        });

        jTextField2.setText("1");
        jTextField2.setEnabled(false);

        jCheckBox5.setSelected(true);
        jCheckBox5.setText("align phases");
        jCheckBox5.setEnabled(false);
        jCheckBox5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox5ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                        .addComponent(jCheckBox3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jCheckBox4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jCheckBox5))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel3)
                            .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 202, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(10, 10, 10)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel4)
                            .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 191, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jRadioButtonVecVoice)
                                .addGap(18, 18, 18)
                                .addComponent(jRadioButtonVecVox)
                                .addGap(18, 18, 18)
                                .addComponent(jButtonPlayVectrex))
                            .addComponent(jLabel2))
                        .addGap(29, 29, 29)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxNaval)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jCheckBoxPhrasealator)
                                .addGap(18, 18, 18)
                                .addComponent(jCheckBoxAutoPause))))
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 403, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGap(6, 6, 6)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel1)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 289, Short.MAX_VALUE)))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox1)
                        .addGap(18, 18, 18)))
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGap(5, 5, 5)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jScrollPane5, javax.swing.GroupLayout.DEFAULT_SIZE, 289, Short.MAX_VALUE)
                            .addComponent(jLabel5)))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jCheckBox2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonCreate)))
                .addGap(0, 0, 0))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButtonPlayVectrex, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jRadioButtonVecVoice)
                                .addComponent(jRadioButtonVecVox)))
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel2)
                            .addComponent(jCheckBoxNaval))
                        .addGap(5, 5, 5)
                        .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 89, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel3)
                            .addComponent(jLabel4))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jScrollPane4)
                            .addComponent(jScrollPane3)))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel1)
                            .addComponent(jCheckBoxPhrasealator)
                            .addComponent(jCheckBoxAutoPause)
                            .addComponent(jLabel5))
                        .addGap(2, 2, 2)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 416, Short.MAX_VALUE)
                            .addComponent(jScrollPane5, javax.swing.GroupLayout.DEFAULT_SIZE, 416, Short.MAX_VALUE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButtonCreate)
                        .addComponent(jCheckBox1)
                        .addComponent(jCheckBox2))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBox3)
                            .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBox4)
                            .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBox5))
                        .addGap(9, 9, 9))))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonCreateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCreateActionPerformed
        createSource();
        if (tinyLog instanceof VediPanel)
        {
            VediPanel vedi = (VediPanel)tinyLog;
            vedi.refreshTree();
        }
    }//GEN-LAST:event_jButtonCreateActionPerformed

    private void jButtonPlayVectrexActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPlayVectrexActionPerformed

        doIt();
        VecSpeechDevice.blendEnable = jCheckBox3.isSelected();
        VecSpeechDevice.blendLen = de.malban.util.UtilityString.Int0(jTextField1.getText());
        VecSpeechDevice.removeSilence = jCheckBox4.isSelected();
        VecSpeechDevice.maxNoise = de.malban.util.UtilityString.Int0(jTextField2.getText());
        VecSpeechDevice.alignBlendToAmplitude = jCheckBox5.isSelected();
        
        VecSpeechDevice.resetWaveCollector();
        VecSpeechDevice.saveWave=true;
        playSpeech();

    }//GEN-LAST:event_jButtonPlayVectrexActionPerformed

    private void jTextAreaInputTextKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextAreaInputTextKeyTyped

    }//GEN-LAST:event_jTextAreaInputTextKeyTyped

    private void jCheckBoxAutoPauseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxAutoPauseActionPerformed
        loadPhrases();
        doIt();
    }//GEN-LAST:event_jCheckBoxAutoPauseActionPerformed

    private void jTextAreaInputTextKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextAreaInputTextKeyReleased
        doIt();
    }//GEN-LAST:event_jTextAreaInputTextKeyReleased

    private void jTable1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable1MouseClicked
        
        JTable table =(JTable) evt.getSource();
        Point p = evt.getPoint();
        int row = table.rowAtPoint(p);
        int col = table.columnAtPoint(p);
        
        if (jRadioButtonVecVox.isSelected())
        {
            if (evt.getClickCount() == 2) 
            {
                SpeakJetMSA sa = VecVoxSamples.getAllSamples()[row];
                if (evt.getButton() == MouseEvent.BUTTON3)
                {
                    VecVoxSamples.playSample(sa.code);
                }
                else
                {
                    int pos = jTextAreaInputText.getCaretPosition();
                    jTextAreaInputText.insert("\\"+sa.phoneme+" ", pos);
                    doIt();
                }
            }        
        }
        else if (jRadioButtonVecVoice.isSelected())
        {
            if (evt.getClickCount() == 2) 
            {
                SP0256AL sa = VecVoiceSamples.getAllSamples()[row];
                if (evt.getButton() == MouseEvent.BUTTON3)
                {
                    VecVoiceSamples.playSample(sa.code);
                }
                else
                {
                    int pos = jTextAreaInputText.getCaretPosition();
                    jTextAreaInputText.insert("\\"+sa.phoneme+" ", pos);
                    doIt();
                }
            }        
        }

    }//GEN-LAST:event_jTable1MouseClicked

    private void jTable2MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable2MouseClicked
        JTable table =(JTable) evt.getSource();
        Point p = evt.getPoint();
        int row = table.rowAtPoint(p);
        int col = table.columnAtPoint(p);
        if (evt.getClickCount() == 2) 
        {
             SpeakSpecials sa = VecVoxSamples.getAllSpecials().get(row);
             int pos = jTextAreaInputText.getCaretPosition();
             String insert = sa.mnemonic+" ";
             
             if (sa.codes.contains(" x "))
             {
                 String[] addi = sa.codes.split(" ");
                 String a = addi[addi.length-1].substring(1);
                 a = de.malban.util.UtilityString.replace(a, ")", "");
                 insert+= (" \\"+a+" ");
             }
             
             jTextAreaInputText.insert(insert, pos);
             doIt();
        }
    }//GEN-LAST:event_jTable2MouseClicked

    private void jCheckBoxPhrasealatorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxPhrasealatorActionPerformed
        doIt();
    }//GEN-LAST:event_jCheckBoxPhrasealatorActionPerformed

    private void jCheckBoxNavalActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxNavalActionPerformed
        doIt();
    }//GEN-LAST:event_jCheckBoxNavalActionPerformed

    private void jRadioButtonVecVoiceActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButtonVecVoiceActionPerformed
        jCheckBoxPhrasealator.setEnabled(false);
        jCheckBoxPhrasealator.setSelected(false);
        jCheckBox2.setEnabled(false);
        
//        jButtonCreate.setEnabled(false);
        jScrollPane5.setVisible(false);
        jLabel5.setVisible(false);
        
        jTable1.setModel(new VecVoiceTableModel());
        loadPhrases();
        
        doIt();
    }//GEN-LAST:event_jRadioButtonVecVoiceActionPerformed

    private void jRadioButtonVecVoxActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButtonVecVoxActionPerformed
        jCheckBoxPhrasealator.setEnabled(true);
        jCheckBoxPhrasealator.setSelected(true);
        jCheckBox2.setEnabled(false);
        jButtonCreate.setEnabled(true);
        jScrollPane5.setVisible(true);
        jLabel5.setVisible(true);
        jTable1.setModel(new VecVoxTableModel());
        loadPhrases();
        doIt();
    }//GEN-LAST:event_jRadioButtonVecVoxActionPerformed

    private void jCheckBox4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox4ActionPerformed
        VecSpeechDevice.removeSilence = jCheckBox4.isSelected();
        VecSpeechDevice.maxNoise = de.malban.util.UtilityString.Int0(jTextField2.getText());
        
    }//GEN-LAST:event_jCheckBox4ActionPerformed

    private void jCheckBox3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox3ActionPerformed
        VecSpeechDevice.blendEnable = jCheckBox3.isSelected();
        VecSpeechDevice.blendLen = de.malban.util.UtilityString.Int0(jTextField1.getText());
        
    }//GEN-LAST:event_jCheckBox3ActionPerformed

    private void jCheckBox5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox5ActionPerformed
        VecSpeechDevice.alignBlendToAmplitude = jCheckBox5.isSelected();
    }//GEN-LAST:event_jCheckBox5ActionPerformed

    private void outPutMnemonicsSP0256Al2(ArrayList<String> mnemonics)
    {
        int count = 0;
        StringBuilder out1=new StringBuilder();
        StringBuilder out2=new StringBuilder();
        for (String m: mnemonics)
        {
            if (count != 0)
            {
                out1.append(" ");
                out2.append(", ");
            }
            out1.append(m);
            out2.append(getCodeStringSP0256Al2(m));
            if (count++ ==4)
            {
                count =0;
                out1.append("\n");
                out2.append("\n");
            }
        }
        jTextAreaTranslation.setText(out1.toString());
        jTextArea3.setText(out2.toString());
    }
    private void outPutMnemonicsSpeakJet(ArrayList<String> mnemonics)
    {
        int count = 0;
        StringBuilder out1=new StringBuilder();
        StringBuilder out2=new StringBuilder();
        for (String m: mnemonics)
        {
            if (count != 0)
            {
                out1.append(" ");
                out2.append(", ");
            }
            out1.append(m);
            out2.append(getCodeStringSpeakJet(m));
            if (count++ ==4)
            {
                count =0;
                out1.append("\n");
                out2.append("\n");
            }
        }
        jTextAreaTranslation.setText(out1.toString());
        jTextArea3.setText(out2.toString());
    }
    
    private String getCodeStringSP0256Al2(String mnemonic)
    {
        String unescape = de.malban.util.UtilityString.replace(mnemonic, "\\", "");
        HashMap<String, String> codeMap = VecVoiceSamples.getCodeMap();
        
        String code = codeMap.get(unescape);
        if (code == null) return "ERROR";
        int pos = code.indexOf(" x ");
        if (pos != -1)
        {
            code = code.substring(0, pos).trim();
        }
        code = code.trim();
        if (code.endsWith(","))
        {
            code = code.substring(0, code.length()-1);
            code = code.trim();
        }
        return code;
    }
    private String getCodeStringSpeakJet(String mnemonic)
    {
        String unescape = de.malban.util.UtilityString.replace(mnemonic, "\\", "");
        HashMap<String, String> codeMap = VecVoxSamples.getCodeMap();
        
        String code = codeMap.get(unescape);
        if (code == null) return "ERROR";
        int pos = code.indexOf(" x ");
        if (pos != -1)
        {
            code = code.substring(0, pos).trim();
        }
        code = code.trim();
        if (code.endsWith(","))
        {
            code = code.substring(0, code.length()-1);
            code = code.trim();
        }
        return code;
    }
    
    String home = "";
    public static void showVecSpeechPanelNoModal(TinyLogInterface tl, String path)
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        VecSpeechPanel panel = new VecSpeechPanel( tl);
        panel.home = path;
        if (path == null)
        {
            panel.standalone = true;
        }
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addPanel(panel);
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).windowMe(panel, 1024, 600, panel.getMenuItem().getText());
    }        
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.JButton jButtonCreate;
    private javax.swing.JButton jButtonPlayVectrex;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JCheckBox jCheckBox5;
    private javax.swing.JCheckBox jCheckBoxAutoPause;
    private javax.swing.JCheckBox jCheckBoxNaval;
    private javax.swing.JCheckBox jCheckBoxPhrasealator;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JRadioButton jRadioButtonVecVoice;
    private javax.swing.JRadioButton jRadioButtonVecVox;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JTable jTable1;
    private javax.swing.JTable jTable2;
    private javax.swing.JTextArea jTextArea3;
    private javax.swing.JTextArea jTextAreaInputText;
    private javax.swing.JTextArea jTextAreaTranslation;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField2;
    // End of variables declaration//GEN-END:variables

    HashMap<String, String> phrasealatorMap = new HashMap<String, String>();
    boolean loadPhrases()
    {
        phrasealatorMap = new HashMap<String, String>();
        try
        {
            Vector<String> strings = de.malban.util.UtilityString.readTextFileToString(new File("template"+File.separator+"Phrasealator.Dic"));
            ArrayList<String> iterativePhrase = new ArrayList<String>();
            for (int i=0; i< strings.size(); i++)
            {
                String line = strings.elementAt(i);
                String[] twoSides = line.split("=");
                if (twoSides.length != 2) continue;
                
                twoSides[1] = twoSides[1].replace("\\Fast ", "\\FAST ");
                twoSides[1] = twoSides[1].replace("\\Slow ", "\\SLOW ");
                twoSides[1] = twoSides[1].replace("\\Soft ", "\\SOFT ");
                twoSides[1] = twoSides[1].replace("\\Stress ", "\\STRESS ");
                twoSides[1] = twoSides[1].replace("\\Reset ", "\\RESET ");
                
                if (containsWithoutSlash(twoSides[1])) 
                {
                    iterativePhrase.add(line);
                    continue;
                }
                phrasealatorMap.put(twoSides[0].trim().toUpperCase(), twoSides[1].trim().toUpperCase());
            }
            
            for (String line: iterativePhrase)
            {
                String[] twoSides = line.split("=");
                String from = twoSides[0];
                String to = twoSides[1];
                to = to.replace("\\Fast ", "\\FAST ");
                to = to.replace("\\Slow ", "\\SLOW ");
                to = to.replace("\\Soft ", "\\SOFT ");
                to = to.replace("\\Stress ", "\\STRESS ");
                to = to.replace("\\Reset ", "\\RESET ");
                to = to.replace(",", " \\P2 "); // a long pause
                to = to.replace("  ", " "); 
             
                String[] subs = to.split(" ");
                String newTo = "";
                for (String s: subs)
                {
                    String mapped = phrasealatorMap.get(s.toUpperCase());
                    if (mapped != null)
                    {
                        newTo+= " " + mapped;
                        if (jCheckBoxAutoPause.isSelected())
                        {
                            newTo += " \\P2";
                        }
                    }
                    else
                    {
                        newTo+= " " + s.toUpperCase();
                    }
                    
                }
                newTo = newTo.replace("  ", " "); 
                newTo = newTo.trim(); 
                
                phrasealatorMap.put(from.toUpperCase(), newTo.toUpperCase());
            }
            
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
            return false;
        }
        return true;
    }
    
    ArrayList<String> applySP0256Al2Translation()
    {
        ArrayList<String> out = new ArrayList<String>();
        
        String text = getCleanInput();

        String[] phrases = text.toUpperCase().split(" ");
        boolean doPause = false;
        for (String phrase: phrases)
        {
            if (phrase.length() == 0) continue;
            if (doPause)
            {
                if (jCheckBoxAutoPause.isSelected())
                {
                    out.add("\\PA4");
                }
            }
            // check "escapes"
            if (phrase.startsWith("\\"))
            {
                out.add(phrase);
                continue;
            }
            
            doPause = true;
            
            // check Naval translation
            if (jCheckBoxNaval.isSelected())
            {
                out.addAll(doSP0256Al2Naval(phrase));
            }
        }
        out.add("\\VOICE_TERM");
        return out;
    }

    // text must be "splitable" with a SPACE
    // escape sequences for Phrasealtaor compatible 
    // escapes are accepted
    // ,;. are translated to P2
    // raw numbers from 0 to 255 can be escaped
    // everything that can not be identiefied is ignored
    ArrayList<String> applySpeakJetTranslation()
    {
        ArrayList<String> out = new ArrayList<String>();
        
        String text = getCleanInput();

        String[] phrases = text.toUpperCase().split(" ");
        boolean doPause = false;
        String lastPhrase = "";
        for (String phrase: phrases)
        {
            if (phrase.length() == 0) continue;
            if (doPause)
            {
                // dont autopause after a command!
                if (!lastPhrase.toUpperCase().contains("\\"))
                {
                    if (jCheckBoxAutoPause.isSelected())
                    {
                        out.add("\\P5");
                    }
                }
            }
            lastPhrase = phrase;
            // check "escapes"
            if (phrase.startsWith("\\"))
            {
                out.add(phrase);
                continue;
            }
            
            doPause = true;
            
            if (jCheckBoxPhrasealator.isSelected())
            {
                // check direct phrase
                String t = phrasealatorMap.get(phrase);
                if (t != null)
                {

                    String[] codes = t.split(" ");
                    for (String code: codes)
                    {
                        if (code.trim().length() == 0) continue;
                        out.add(code);
                    }
                    continue;
                }
            }
            
            // check Naval translation
            if (jCheckBoxNaval.isSelected())
            {
                out.addAll(doSpeakJetNaval(phrase));
            }
        }
        out.add("\\VOX_TERM");
        return out;
    }

    boolean containsLowerCase(String l)
    {
        return !l.toUpperCase().equals(l);
    }
    boolean containsWithoutSlash(String l)
    {
        l = l.trim(); 
        l = l.replace(",", " "); 
        l = l.replace("  ", " "); 
        String a[] = l.split(" ");
        for (String aa: a)
        {
            if (aa.trim().length() == 0) continue;
            if (!aa.startsWith("\\")) return true;
        }
        
        return false;
    }
    
    // translate one word with naval algorithm
    ArrayList<String> doSpeakJetNaval(String word)
    {
        String navelCodes = NavalTranslationSpeakJet.xlate_word(word);
        ArrayList<String> out = new ArrayList<String>();
        
        String[] codes = navelCodes.split(" ");
        for (String code: codes)
        {
            if (code.trim().length() == 0) continue;
            int c = de.malban.util.UtilityString.IntX(code.trim(), -1);
            if (c == -1) continue;
            if (c<128) continue; // might be special characters like "!"
            
            out.add("\\"+VecVoxSamples.getAllSamples()[c-128].phoneme);
        }
        return out;
    }
    // translate one word with naval algorithm
    ArrayList<String> doSP0256Al2Naval(String word)
    {
        String navelCodes = NavalTranslationSP0256AL2.xlate_word(word);
        ArrayList<String> out = new ArrayList<String>();
        
        String[] codes = navelCodes.split(" ");
        for (String code: codes)
        {
            if (code.trim().length() == 0) continue;
            int c = de.malban.util.UtilityString.IntX(code.trim(), -1);
            if (c == -1) continue;
            if (c>63) continue; // might be special characters like "!"
            
            out.add("\\"+VecVoiceSamples.getAllSamples()[c].phoneme);
        }
        return out;
    }
    String getCleanInput()
    {
        String text = jTextAreaInputText.getText();
        ArrayList<String> out = new ArrayList<String>();
        
        text = text.replace(",", " \\P2 "); 
        text = text.replace(".", " \\P2 "); 
        text = text.replace(";", " \\P2 "); 
        text = text.replace("\"", ""); 
        text = text.replace("\n", " "); 
        text = text.replace("\r", " "); 
        text = text.replace("\t", " "); 
        return text;
    }

    void doIt()
    {
        ArrayList<String> mnemonics;
        if (!jRadioButtonVecVox.isSelected()) 
        {
            mnemonics=applySP0256Al2Translation();
            outPutMnemonicsSP0256Al2(mnemonics);
        }
        else
        {
            mnemonics=applySpeakJetTranslation();
            outPutMnemonicsSpeakJet(mnemonics);
        }
    }
    boolean standalone=false;
    void createSource()
    {
        if (standalone)
        {
            // ask where to save!
            InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
            fc.setDialogTitle("Select save directory");
            fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
            fc.setCurrentDirectory(new java.io.File("."+File.separator));

            int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
            if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
            home = fc.getSelectedFile().getAbsolutePath();
            if (!home.endsWith(File.separator)) home+=File.separator;
        }
        
        if (jRadioButtonVecVox.isSelected()) 
        {

            String pathOnly = Paths.get(home).toString();
            if (pathOnly.length()!=0)pathOnly+=File.separator;

            Path include = Paths.get(".", "template", "VECTREX.I");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathOnly+ "VECTREX.I");

            Path serial = Paths.get(".", "template", "ser_ji.i");
            de.malban.util.UtilityFiles.copyOneFile(serial.toString(), pathOnly+ "ser_ji.i");

            Path vecVox = Paths.get(".", "template", "vecvox.i");
            de.malban.util.UtilityFiles.copyOneFile(vecVox.toString(), pathOnly+ "vecvox.i");

            if (jCheckBox2.isSelected())
            {
                Path jetPhones = Paths.get(".", "template", "jetphones.inc");
                de.malban.util.UtilityFiles.copyOneFile(jetPhones.toString(), pathOnly+ "jetphones.inc");
            }

            String vectrexData = generateVectrexData(jCheckBox2.isSelected());
            de.malban.util.UtilityFiles.createTextFile(pathOnly+"speechData.i", vectrexData);    

            if (jCheckBox1.isSelected())
            {
                Path template = Paths.get(".", "template", "vecVoxMain.template");
                String exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                de.malban.util.UtilityFiles.createTextFile(pathOnly+"vecVoxMain.asm", exampleMain);    
            }

            if (tinyLog instanceof VediPanel)
            {
                ((VediPanel)tinyLog).returnFromVecVoxPanel(1);
            }
            if (jCheckBox1.isSelected())
            if (standalone)
            {
                VediPanel.openInVedi(pathOnly+"vecVoxMain.asm");
            }
        }
        else if (jRadioButtonVecVoice.isSelected())
        {

            String pathOnly = Paths.get(home).toString();
            if (pathOnly.length()!=0)pathOnly+=File.separator;

            Path include = Paths.get(".", "template", "VECTREX.I");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathOnly+ "VECTREX.I");

            Path serial = Paths.get(".", "template", "ser_ji.i");
            de.malban.util.UtilityFiles.copyOneFile(serial.toString(), pathOnly+ "ser_ji.i");

            Path vecVox = Paths.get(".", "template", "vecvoice.i");
            de.malban.util.UtilityFiles.copyOneFile(vecVox.toString(), pathOnly+ "vecvoice.i");

            String vectrexData = generateVectrexVecVoiceData();
            de.malban.util.UtilityFiles.createTextFile(pathOnly+"speechData.i", vectrexData);    

            if (jCheckBox1.isSelected())
            {
                Path template = Paths.get(".", "template", "vecVoiceMain.template");
                String exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                de.malban.util.UtilityFiles.createTextFile(pathOnly+"vecVoiceMain.asm", exampleMain);    
            }

            if (tinyLog instanceof VediPanel)
            {
                ((VediPanel)tinyLog).returnFromVecVoxPanel(2);
            }
            if (jCheckBox1.isSelected())
            if (standalone)
            {
                VediPanel.openInVedi(pathOnly+"vecVoiceMain.asm");
            }
            
        }
    }
    void playSpeech()
    {
        /*
        if (!jRadioButtonVecVox.isSelected())
        {
            return;
        }
*/        
        String text = jTextArea3.getText();
        text = de.malban.util.UtilityString.replace(text, ",", " ");
        text = de.malban.util.UtilityString.replaceWhiteSpaces(text, ",");
        text = de.malban.util.UtilityString.replace(text, " ", ",");
        text = de.malban.util.UtilityString.replace(text, ",,", ",");
        String[] splitter = text.split(",");
        ArrayList<Integer> param = new ArrayList<Integer>();
        for (String one: splitter)
        {
            if (one.trim().length() == 0) continue;
            param.add(de.malban.util.UtilityString.Int0(one.trim()) );
        }
        VecSpeechDevice.speak(param, jRadioButtonVecVoice.isSelected());
    }
    
    String generateVectrexVecVoiceData()
    {
        doIt();
        StringBuilder ret = new StringBuilder();

        ret.append("speechData:\n");
        
        String text = jTextArea3.getText();
        text = de.malban.util.UtilityString.replace(text, ",", " ");
        text = de.malban.util.UtilityString.replaceWhiteSpaces(text, ",");
        text = de.malban.util.UtilityString.replace(text, " ", ",");
        text = de.malban.util.UtilityString.replace(text, ",,", ",");
        String[] splitter = text.split(",");
        int count =0;
        for (String one: splitter)
        {
            if (one.trim().length() == 0) continue;
            int code = de.malban.util.UtilityString.Int0(one.trim());
            
            if (count == 0)
            {
                ret.append(" db ");
            }
            else
            {
                ret.append(", ");
            }
            ret.append((""+code));
            count++;
            if (count == 10)
            {
                ret.append("\n");
                count = 0;
            }
            
        }
        return ret.toString();
    }
    String generateVectrexData(boolean useJetPhones)
    {
        doIt();
        StringBuilder ret = new StringBuilder();
        if (useJetPhones)
        {
            ret.append(" include \"jetphones.inc\"\n\n");
        }
        ret.append("speechData:\n");
        
        String text = jTextArea3.getText();
        text = de.malban.util.UtilityString.replace(text, ",", " ");
        text = de.malban.util.UtilityString.replaceWhiteSpaces(text, ",");
        text = de.malban.util.UtilityString.replace(text, " ", ",");
        text = de.malban.util.UtilityString.replace(text, ",,", ",");
        String[] splitter = text.split(",");
        int count =0;
        boolean wasSpecial = false;
        for (String one: splitter)
        {
            if (one.trim().length() == 0) continue;
            int code = de.malban.util.UtilityString.Int0(one.trim());
            
            if (count == 0)
            {
                ret.append(" db ");
            }
            else
            {
                ret.append(", ");
            }
            if (useJetPhones)
            {
                if (!wasSpecial)
                {
                    ret.append(VecVoxSamples.getMnemonic(code));
                }
                else
                {
                    ret.append(""+code);
                }
                wasSpecial = false;
                if (code == 20 )wasSpecial = true;
                if (code == 21 )wasSpecial = true;
                if (code == 22 )wasSpecial = true;
                if (code == 23 )wasSpecial = true;
                if (code == 26 )wasSpecial = true;
                if (code == 30 )wasSpecial = true;
            }
            else
            {
                ret.append((""+code));
            }
            count++;
            if (count == 10)
            {
                ret.append("\n");
                count = 0;
            }
            
        }
        return ret.toString();
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
        jTable2.setRowHeight(rowHeight);
    }
}
