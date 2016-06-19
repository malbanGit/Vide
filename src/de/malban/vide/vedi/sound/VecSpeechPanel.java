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
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.vide.vecx.VecSpeech;
import de.malban.vide.vecx.VecVoiceSamples;
import de.malban.vide.vecx.VecVoxSamples;
import de.malban.vide.vecx.VecVoxSamples.SpeakJetMSA;
import de.malban.vide.vecx.VecVoxSamples.SpeakSpecials;
import de.malban.vide.vedi.VediPanel;
import java.awt.Point;
import java.awt.event.MouseEvent;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Vector;
import javax.swing.JFrame;
import javax.swing.JTable;
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
            if ((row<128) || (row > 255)) return "";
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
    
    /**
     * Creates new form VecSpeechPanel
     */
    public VecSpeechPanel(TinyLogInterface tl) {
        initComponents();
        tinyLog = tl;
        jTable1.setModel(new VecVoxTableModel());
        jTable2.setModel(new VecVoxSpecialTableModel());
        loadPhrases();
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
        jRadioButton1 = new javax.swing.JRadioButton();
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

        jButtonCreate.setText("create source");
        jButtonCreate.setName("create"); // NOI18N
        jButtonCreate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCreateActionPerformed(evt);
            }
        });

        buttonGroup1.add(jRadioButton1);
        jRadioButton1.setText("VecVoice");
        jRadioButton1.setEnabled(false);

        buttonGroup1.add(jRadioButtonVecVox);
        jRadioButtonVecVox.setSelected(true);
        jRadioButtonVecVox.setText("VecVox");

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

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jCheckBox1)
                        .addGap(29, 29, 29)
                        .addComponent(jButtonCreate, javax.swing.GroupLayout.PREFERRED_SIZE, 110, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel3)
                                    .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 183, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel4)
                                    .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jRadioButton1)
                                        .addGap(18, 18, 18)
                                        .addComponent(jRadioButtonVecVox)
                                        .addGap(18, 18, 18)
                                        .addComponent(jButtonPlayVectrex)
                                        .addGap(29, 29, 29))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel2)
                                        .addGap(18, 18, 18)))
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jCheckBoxNaval)
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jCheckBoxPhrasealator)
                                        .addGap(18, 18, 18)
                                        .addComponent(jCheckBoxAutoPause))))
                            .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 403, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(6, 6, 6)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel1)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 289, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(5, 5, 5)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 289, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel5))
                .addContainerGap(48, Short.MAX_VALUE))
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
                                .addComponent(jRadioButton1)
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
                            .addComponent(jScrollPane1)
                            .addComponent(jScrollPane5))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonCreate)
                    .addComponent(jCheckBox1)))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonCreateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCreateActionPerformed
        createSource();
    }//GEN-LAST:event_jButtonCreateActionPerformed

    private void jButtonPlayVectrexActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPlayVectrexActionPerformed
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
    
    public static void showVecSpeechPanelNoModal(TinyLogInterface tl)
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        VecSpeechPanel panel = new VecSpeechPanel( tl);
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addPanel(panel);
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).windowMe(panel, 1024, 600, panel.getMenuItem().getText());
    }        
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.JButton jButtonCreate;
    private javax.swing.JButton jButtonPlayVectrex;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBoxAutoPause;
    private javax.swing.JCheckBox jCheckBoxNaval;
    private javax.swing.JCheckBox jCheckBoxPhrasealator;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JRadioButton jRadioButton1;
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
                
                if (containsLowerCase(twoSides[1])) 
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
        for (String phrase: phrases)
        {
            if (phrase.length() == 0) continue;
            if (doPause)
            {
                if (jCheckBoxAutoPause.isSelected())
                {
                    out.add("\\P5");
                }
            }
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
    
    // translate one word with naval algorithm
    ArrayList<String> doSpeakJetNaval(String word)
    {
        String navelCodes = NavalTranslation.xlate_word(word);
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
        if (!jRadioButtonVecVox.isSelected()) return;
        ArrayList<String> mnemonics=applySpeakJetTranslation();
        outPutMnemonicsSpeakJet(mnemonics);
    }
    
    void createSource()
    {
        /*
        String pathOnly = Paths.get(currentModFile).getParent().toString();
        if (pathOnly.length()!=0)pathOnly+=File.separator;
        
        String nameOnly = Paths.get(currentModFile).getFileName().toString();;
        int li = nameOnly.lastIndexOf(".");
        if (li>=0) 
            nameOnly = nameOnly.substring(0,li);
       
        Mod2Vectrex m2v = new Mod2Vectrex( );
        
        
        int v0=0;
        int v1=1;
        int v2=2;
        if (jRadioButton1.isSelected()) v0=0; else if (jRadioButton2.isSelected()) v0=1;else if (jRadioButton3.isSelected()) v0=2;else v0=3;
        if (jRadioButton5.isSelected()) v1=0; else if (jRadioButton6.isSelected()) v1=1;else if (jRadioButton7.isSelected()) v1=2;else v1=3;
        if (jRadioButton9.isSelected()) v2=0; else if (jRadioButton10.isSelected()) v2=1;else if (jRadioButton11.isSelected()) v2=2;else v2=3;
        
        m2v.vectrexModMapping[0] = v0;
        m2v.vectrexModMapping[1] = v1;
        m2v.vectrexModMapping[2] = v2;
        
        String result = m2v.doIt(currentModFile, instrumentHandles, jTextField1.getText(), jTextField3.getText(), jCheckBoxIndirectOutput.isSelected());
        tinyLog.printMessage(result);

        Path include = Paths.get(".", "template", "VECTREX.I");
        de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathOnly+ "VECTREX.I");
        Path digital = Paths.get(".", "template", "modPlayer.i");
        de.malban.util.UtilityFiles.copyOneFile(digital.toString(), pathOnly+ "modPlayer.i");

        Path template = Paths.get(".", "template", "modPlayMain.template");
        String exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

        exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#MOD_NAME#", ""+nameOnly.toUpperCase());
        exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#MOD_NAME_ASM#", ""+nameOnly+".asm");
        de.malban.util.UtilityFiles.createTextFile(pathOnly+nameOnly+"Main.asm", exampleMain);    
        
      // ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).removePanel(this);
        if (tinyLog instanceof VediPanel)
        {
            ((VediPanel)tinyLog).returnFromModPanel(true);
        }
        */
    }
    void playSpeech()
    {
        if (!jRadioButtonVecVox.isSelected()) return;
        
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
        VecSpeech.speakSpeakJet(param);
    }
}
