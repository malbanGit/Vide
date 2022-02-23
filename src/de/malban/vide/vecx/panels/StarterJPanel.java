/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.panels;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.HotKey;
import de.malban.gui.ImageCache;
import de.malban.vide.vecx.VecXPanel;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSATableModel;
import de.malban.gui.components.CSAView;
import de.malban.gui.components.DoubleClickAction;
import de.malban.gui.components.SelectionChangedListener;
import de.malban.gui.components.SelectionEvent;
import de.malban.gui.dialogs.ShowErrorDialog;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.util.DownloaderPanel;
import de.malban.vide.VideConfig;
import de.malban.vide.vecx.VecX;
import de.malban.vide.vecx.cartridge.Cartridge;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_48K;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_ATMEL_EEPROM;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_BANKSWITCH_DONDZILA;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_BANKSWITCH_VECFLASH;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_BS_PB6_IRQ;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_EXTREME_MULTI;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_IMAGER;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_LIGHTPEN1;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_LIGHTPEN2;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_RAM_ANIMACTION;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_DS2430A;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_DUALVEC1;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_DUALVEC2;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_KEYBOARD;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_LOGO;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_PIC_EEPROM;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_RAM_RA_SPECTRUM;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_SID;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_V4E_16K_BS;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_VEC_VOICE;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_VEC_VOX;
import de.malban.vide.vecx.cartridge.CartridgeProperties;
import de.malban.vide.vecx.cartridge.CartridgePropertiesPool;
import java.awt.Desktop;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Serializable;
import java.net.URI;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import javax.swing.SwingUtilities;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author malban
 */
public class StarterJPanel extends javax.swing.JPanel implements
        Windowable, Stateable, SelectionChangedListener{
    public boolean isLoadSettings() { return true; }
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    private CSAView mParent = null;

    boolean myImageShown = VideConfig.getConfig().loadStarterImages;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    public static String SID = "Starter";
    private CartridgeProperties mCartridgeProperties = null;
    
    ArrayList<CartridgeProperties> allCartridges = new ArrayList<CartridgeProperties>();
    
    public static String[] headers = {"Name", "Author","Year", "Homebrew", "Demo", "Snippet", "Game","Cart","Front", "Back", "InGame"};
    class CartridgeTableModel extends AbstractTableModel
    {
        private CartridgeTableModel()
        {
        }

        public int getRowCount()
        {
            return allCartridges.size();
        }
        public int getColumnCount()
        {
            if (!myImageShown)
            {
                return headers.length-4;
                
            }
           return headers.length;
        }
        public Object getValueAt(int row, int col)
        {
            if (col == 0) return allCartridges.get(row).getCartName();
            if (col == 1) return allCartridges.get(row).getAuthor();
            if (col == 2) return allCartridges.get(row).getYear();
            if (col == 3) return allCartridges.get(row).getHomebrew();
            if (col == 4) return allCartridges.get(row).getDemo();
            if (col == 5) return allCartridges.get(row).getSnippet();
            if (col == 6) return allCartridges.get(row).getCompleteGame();
            if (col == 7) return allCartridges.get(row).getSmallCartridgeImage();
            if (col == 8) return allCartridges.get(row).getSmallFrontImage();
            if (col == 9) return allCartridges.get(row).getSmallBackImage();
            if (col == 10) return allCartridges.get(row).getSmallInGameImage();
            return "-";
        }
        public String getColumnName(int col) {
                return headers[col];
        }
        // input data column
        public Class<?> getColumnClass(int col) {
            if (col ==3) return Boolean.class;
            if (col ==4) return Boolean.class;
            if (col ==5) return Boolean.class;
            if (col ==6) return Boolean.class;
            if (col == 7) return BufferedImage.class;
            if (col == 8) return BufferedImage.class;
            if (col == 9) return BufferedImage.class;
            if (col == 10) return BufferedImage.class;
            return String.class;
        }
        // input data column
        public boolean isCellEditable(int row, int col) {
            return false;
        }
        // input data column
        public void setValueAt(Object aValue, int row, int col) {
        }
    }        
    CartridgeTableModel model = new CartridgeTableModel();
        
    /*
    BufferedImage getImage(String filename, int w, int h)
    {
        File f = new File(filename);
        if (!f.exists()) return null;
        BufferedImage org = ImageCache.getImageCache().getImage(filename);
        return ImageCache.getImageCache().getDerivatScale(org, w, h);
    }
    */
    
    public String getID()
    {
        return SID;
    }
    @Override public String getFileID()
    {
        return de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replaceWhiteSpaces(SID, ""),":",""),"(",""),")","") ;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}
    
    @Override
    public void closing()
    {
        deinit();
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
        mParentMenuItem.setText(SID);
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
    /**
     * Creates new form RegisterJPanel
     */
    public StarterJPanel() {
        initComponents();
        if (Global.getOSName().toUpperCase().contains("MAC"))
        {
            HotKey.addMacDefaults(jTextField1);
            HotKey.addMacDefaults(jTextField2);
            HotKey.addMacDefaults(jTextField3);
            HotKey.addMacDefaults(jTextField4);
            HotKey.addMacDefaults(jTextFieldPath);
            HotKey.addMacDefaults(jTextFieldPath3);
            HotKey.addMacDefaults(jTextPane1);
            HotKey.addMacDefaults(jTextPane2);
            HotKey.addMacDefaults(jTextPane3);
            HotKey.addMacDefaults(jTextPane4);
            HotKey.addMacDefaults(jTextPane5);
        }
        loadAllCartridged();
        cSATablePanel1.setRowHeight (102);
        cSATablePanel1.setTableStyleSwitchingEnabled(false);
        cSATablePanel1.setModel(CSATableModel.buildTableModel(model));
        cSATablePanel1.addSelectionListerner(this);
        cSATablePanel1.setDoubleClickAction(new DoubleClickAction()
        {
            public void doIt()
            {
                int[] rows = cSATablePanel1.getSelectedRows();
                if (rows.length>0) startCartridge(rows[0]);
            }
        });
    }


    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel1 = new javax.swing.JPanel();
        jButtonFileSelect2 = new javax.swing.JButton();
        jTextFieldPath = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jLabel1 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jTextField2 = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jTextField3 = new javax.swing.JTextField();
        jLabel10 = new javax.swing.JLabel();
        jTextField4 = new javax.swing.JTextField();
        jCheckBox11 = new javax.swing.JCheckBox();
        jCheckBox12 = new javax.swing.JCheckBox();
        jCheckBox13 = new javax.swing.JCheckBox();
        jCheckBox14 = new javax.swing.JCheckBox();
        singleImagePanel3 = new de.malban.graphics.SingleImagePanel();
        jLabel11 = new javax.swing.JLabel();
        jTextFieldPath3 = new javax.swing.JTextField();
        jLabel12 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTextPane1 = new javax.swing.JTextPane();
        jCheckBox10 = new javax.swing.JCheckBox();
        jCheckBox3 = new javax.swing.JCheckBox();
        jCheckBox6 = new javax.swing.JCheckBox();
        jCheckBox5 = new javax.swing.JCheckBox();
        jCheckBox7 = new javax.swing.JCheckBox();
        jCheckBox4 = new javax.swing.JCheckBox();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox9 = new javax.swing.JCheckBox();
        jCheckBox8 = new javax.swing.JCheckBox();
        jCheckBox15 = new javax.swing.JCheckBox();
        jCheckBox1 = new javax.swing.JCheckBox();
        jCheckBox16 = new javax.swing.JCheckBox();
        jCheckBox17 = new javax.swing.JCheckBox();
        jCheckBox18 = new javax.swing.JCheckBox();
        jCheckBox19 = new javax.swing.JCheckBox();
        jCheckBox20 = new javax.swing.JCheckBox();
        jCheckBox21 = new javax.swing.JCheckBox();
        jCheckBox22 = new javax.swing.JCheckBox();
        jCheckBox23 = new javax.swing.JCheckBox();
        jCheckBox48KROM = new javax.swing.JCheckBox();
        jCheckBox26 = new javax.swing.JCheckBox();
        jCheckBox25 = new javax.swing.JCheckBox();
        jCheckBoxXmas1 = new javax.swing.JCheckBox();
        jCheckBox24 = new javax.swing.JCheckBox();
        jCheckBoxPB6IRQ = new javax.swing.JCheckBox();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTextPane2 = new javax.swing.JTextPane();
        jButtonFileSelect12 = new javax.swing.JButton();
        jPanel3 = new javax.swing.JPanel();
        singleImagePanel1 = new de.malban.graphics.SingleImagePanel();
        singleImagePanel2 = new de.malban.graphics.SingleImagePanel();
        jPanel4 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTextPane3 = new javax.swing.JTextPane();
        jPanel7 = new javax.swing.JPanel();
        jLabel17 = new javax.swing.JLabel();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTextPane4 = new javax.swing.JTextPane();
        jLabel18 = new javax.swing.JLabel();
        jScrollPane5 = new javax.swing.JScrollPane();
        jTextPane5 = new javax.swing.JTextPane();
        jLabel22 = new javax.swing.JLabel();
        singleImagePanel4 = new de.malban.graphics.SingleImagePanel();
        jLabel23 = new javax.swing.JLabel();
        singleImagePanel5 = new de.malban.graphics.SingleImagePanel();
        cSATablePanel1 = new de.malban.gui.components.CSATablePanel();

        setName("regi"); // NOI18N

        jButtonFileSelect2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_link.png"))); // NOI18N
        jButtonFileSelect2.setToolTipText("opens system browser to homepage");
        jButtonFileSelect2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect2ActionPerformed(evt);
            }
        });

        jLabel7.setText("Homepage");

        jLabel1.setText("Author");

        jTextField2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField2ActionPerformed(evt);
            }
        });

        jLabel2.setText("Cart name");

        jLabel6.setText("Year");

        jLabel10.setText("CRC");

        jCheckBox11.setText("Complete game");

        jCheckBox12.setText("Demo");

        jCheckBox13.setText("Snippet");

        jCheckBox14.setText("Homebrew");

        singleImagePanel3.setDrawCheckers(true);
        singleImagePanel3.setMaximumSize(new java.awt.Dimension(138, 198));
        singleImagePanel3.setMinimumSize(new java.awt.Dimension(138, 198));

        javax.swing.GroupLayout singleImagePanel3Layout = new javax.swing.GroupLayout(singleImagePanel3);
        singleImagePanel3.setLayout(singleImagePanel3Layout);
        singleImagePanel3Layout.setHorizontalGroup(
            singleImagePanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 149, Short.MAX_VALUE)
        );
        singleImagePanel3Layout.setVerticalGroup(
            singleImagePanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 216, Short.MAX_VALUE)
        );

        jLabel11.setText("Rights");

        jLabel12.setText("Licence");

        jScrollPane1.setViewportView(jTextPane1);

        jCheckBox10.setText("RAM RA Spectrum");

        jCheckBox3.setText("Lightpen Port 1");
        jCheckBox3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox3ActionPerformed(evt);
            }
        });

        jCheckBox6.setText("extreme multi");
        jCheckBox6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox6ActionPerformed(evt);
            }
        });

        jCheckBox5.setText("3d Imager");
        jCheckBox5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox5ActionPerformed(evt);
            }
        });

        jCheckBox7.setText("Bankswitch Dondzila");

        jCheckBox4.setText("Lightpen Port 2");
        jCheckBox4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox4ActionPerformed(evt);
            }
        });

        jCheckBox2.setText("eEprom DS2430A");

        jCheckBox9.setText("RAM Animaction");

        jCheckBox8.setText("Bankswitch VecFlash");
        jCheckBox8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox8ActionPerformed(evt);
            }
        });

        jCheckBox15.setText("VecVox");

        jCheckBox1.setText("VecVoice");

        jCheckBox16.setText("Microchip 11AA010");
        jCheckBox16.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox16ActionPerformed(evt);
            }
        });

        jCheckBox17.setText("DualVec1");

        jCheckBox18.setText("DualVec2");

        jCheckBox19.setText("RAM Logo");

        jCheckBox20.setText("XMas LED");

        jCheckBox21.setText("eEprom DS2431");

        jCheckBox22.setText("32k forced");

        jCheckBox23.setText("SID");

        jCheckBox48KROM.setText("48k ROM");

        jCheckBox26.setText("Atmel");
        jCheckBox26.setMargin(new java.awt.Insets(0, 2, 1, 0));
        jCheckBox26.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox26ActionPerformed(evt);
            }
        });

        jCheckBox25.setText("PIC");
        jCheckBox25.setEnabled(false);
        jCheckBox25.setMargin(new java.awt.Insets(0, 2, 1, 0));

        jCheckBoxXmas1.setText("16k BS");
        jCheckBoxXmas1.setEnabled(false);
        jCheckBoxXmas1.setMargin(new java.awt.Insets(0, 2, 1, 0));
        jCheckBoxXmas1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxXmas1ActionPerformed(evt);
            }
        });

        jCheckBox24.setText("Keyboard");
        jCheckBox24.setEnabled(false);
        jCheckBox24.setMargin(new java.awt.Insets(0, 2, 1, 0));
        jCheckBox24.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox24ActionPerformed(evt);
            }
        });

        jCheckBoxPB6IRQ.setText("BS PB6 & IRQ");
        jCheckBoxPB6IRQ.setMargin(new java.awt.Insets(0, 2, 1, 0));
        jCheckBoxPB6IRQ.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxPB6IRQActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel2)
                    .addComponent(jLabel1)
                    .addComponent(jLabel7)
                    .addComponent(jLabel11)
                    .addComponent(jLabel12))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jTextFieldPath3, javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
                            .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 127, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jLabel6)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 57, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
                            .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 127, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jLabel10)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 57, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
                            .addComponent(jTextFieldPath, javax.swing.GroupLayout.PREFERRED_SIZE, 208, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGap(18, 18, 18)
                            .addComponent(jButtonFileSelect2))
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 247, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox11)
                            .addComponent(jCheckBox12))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox13)
                            .addComponent(jCheckBox14))))
                .addGap(4, 4, 4)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox1)
                    .addComponent(jCheckBox15)
                    .addComponent(jCheckBox2)
                    .addComponent(jCheckBox16)
                    .addComponent(jCheckBox9)
                    .addComponent(jCheckBox10)
                    .addComponent(jCheckBox3)
                    .addComponent(jCheckBox4)
                    .addComponent(jCheckBox5)
                    .addComponent(jCheckBox6)
                    .addComponent(jCheckBoxPB6IRQ, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jCheckBox7)
                    .addComponent(jCheckBox8)
                    .addComponent(jCheckBox17)
                    .addComponent(jCheckBox18))
                .addGap(1, 1, 1)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(singleImagePanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox22)
                            .addComponent(jCheckBox21)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jCheckBox19)
                                    .addComponent(jCheckBox20))
                                .addGap(27, 27, 27)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jCheckBox23)
                                    .addComponent(jCheckBox48KROM))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox24, javax.swing.GroupLayout.PREFERRED_SIZE, 82, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxXmas1)
                            .addComponent(jCheckBox26, javax.swing.GroupLayout.PREFERRED_SIZE, 96, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBox25, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addContainerGap(34, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel2)
                            .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel10)
                            .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel1)
                            .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel6)
                            .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(7, 7, 7)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel7)
                                .addComponent(jTextFieldPath, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jButtonFileSelect2))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel11)
                            .addComponent(jTextFieldPath3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel12)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 162, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(8, 8, 8)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jCheckBox11)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox12))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jCheckBox13)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox14))))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jCheckBox1)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox15)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox2)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox16)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox9)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox10)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox3)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox4)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox5)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox6)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jCheckBoxPB6IRQ))
                            .addComponent(singleImagePanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(2, 2, 2)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox26)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jCheckBox19)
                                    .addComponent(jCheckBox23))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jCheckBox20)
                                    .addComponent(jCheckBox48KROM)
                                    .addComponent(jCheckBox25))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jCheckBox21)
                                    .addComponent(jCheckBoxXmas1))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jCheckBox22)
                                    .addComponent(jCheckBox24)))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jCheckBox7)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox8)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox17)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBox18)))))
                .addContainerGap(49, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Information", jPanel1);

        jScrollPane3.setViewportView(jTextPane2);

        jButtonFileSelect12.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_16x16.png"))); // NOI18N
        jButtonFileSelect12.setToolTipText("open system pdf viewer");
        jButtonFileSelect12.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect12ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonFileSelect12)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 739, Short.MAX_VALUE))
                .addGap(0, 0, 0))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jButtonFileSelect12)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 340, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );

        jTabbedPane1.addTab("Instruction", jPanel2);

        javax.swing.GroupLayout singleImagePanel1Layout = new javax.swing.GroupLayout(singleImagePanel1);
        singleImagePanel1.setLayout(singleImagePanel1Layout);
        singleImagePanel1Layout.setHorizontalGroup(
            singleImagePanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 247, Short.MAX_VALUE)
        );
        singleImagePanel1Layout.setVerticalGroup(
            singleImagePanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 332, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout singleImagePanel2Layout = new javax.swing.GroupLayout(singleImagePanel2);
        singleImagePanel2.setLayout(singleImagePanel2Layout);
        singleImagePanel2Layout.setHorizontalGroup(
            singleImagePanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 246, Short.MAX_VALUE)
        );
        singleImagePanel2Layout.setVerticalGroup(
            singleImagePanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 332, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 749, Short.MAX_VALUE)
            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel3Layout.createSequentialGroup()
                    .addGap(18, 18, 18)
                    .addComponent(singleImagePanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(484, Short.MAX_VALUE)))
            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel3Layout.createSequentialGroup()
                    .addGap(291, 291, 291)
                    .addComponent(singleImagePanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(212, Short.MAX_VALUE)))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 367, Short.MAX_VALUE)
            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel3Layout.createSequentialGroup()
                    .addContainerGap()
                    .addComponent(singleImagePanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap()))
            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel3Layout.createSequentialGroup()
                    .addContainerGap()
                    .addComponent(singleImagePanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap()))
        );

        jTabbedPane1.addTab("Front", jPanel3);

        jScrollPane2.setViewportView(jTextPane3);

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 749, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 367, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );

        jTabbedPane1.addTab("Critics", jPanel4);

        jLabel17.setText("Eastereggs");

        jScrollPane4.setViewportView(jTextPane4);

        jLabel18.setText("Cheats");

        jScrollPane5.setViewportView(jTextPane5);

        jLabel22.setText("In game image");

        singleImagePanel4.setDrawCheckers(true);
        singleImagePanel4.setMaximumSize(new java.awt.Dimension(138, 198));
        singleImagePanel4.setMinimumSize(new java.awt.Dimension(138, 198));

        javax.swing.GroupLayout singleImagePanel4Layout = new javax.swing.GroupLayout(singleImagePanel4);
        singleImagePanel4.setLayout(singleImagePanel4Layout);
        singleImagePanel4Layout.setHorizontalGroup(
            singleImagePanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );
        singleImagePanel4Layout.setVerticalGroup(
            singleImagePanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );

        jLabel23.setText("Cartridge");

        singleImagePanel5.setDrawCheckers(true);
        singleImagePanel5.setMaximumSize(new java.awt.Dimension(138, 198));
        singleImagePanel5.setMinimumSize(new java.awt.Dimension(138, 198));

        javax.swing.GroupLayout singleImagePanel5Layout = new javax.swing.GroupLayout(singleImagePanel5);
        singleImagePanel5.setLayout(singleImagePanel5Layout);
        singleImagePanel5Layout.setHorizontalGroup(
            singleImagePanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );
        singleImagePanel5Layout.setVerticalGroup(
            singleImagePanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout jPanel7Layout = new javax.swing.GroupLayout(jPanel7);
        jPanel7.setLayout(jPanel7Layout);
        jPanel7Layout.setHorizontalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 394, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel18)
                    .addComponent(jLabel17)
                    .addComponent(jScrollPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 394, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel22)
                    .addComponent(singleImagePanel4, javax.swing.GroupLayout.PREFERRED_SIZE, 125, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel23)
                    .addComponent(singleImagePanel5, javax.swing.GroupLayout.PREFERRED_SIZE, 125, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );
        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel17)
                    .addComponent(jLabel23))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jScrollPane4, javax.swing.GroupLayout.DEFAULT_SIZE, 131, Short.MAX_VALUE)
                    .addComponent(singleImagePanel5, javax.swing.GroupLayout.PREFERRED_SIZE, 131, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel18)
                    .addComponent(jLabel22))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(singleImagePanel4, javax.swing.GroupLayout.PREFERRED_SIZE, 153, Short.MAX_VALUE)
                    .addComponent(jScrollPane5, javax.swing.GroupLayout.DEFAULT_SIZE, 153, Short.MAX_VALUE))
                .addContainerGap())
        );

        jTabbedPane1.addTab("Other", jPanel7);

        cSATablePanel1.setXMLId("StarterTable"); // NOI18N
        cSATablePanel1.setPreferredSize(null);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTabbedPane1)
                    .addComponent(cSATablePanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(cSATablePanel1, javax.swing.GroupLayout.DEFAULT_SIZE, 323, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 395, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonFileSelect2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect2ActionPerformed

        if (jTextFieldPath.getText().trim().length() <= 7) return;
        try
        {
            if (Desktop.isDesktopSupported())
            {
                // Windows, mac
                Desktop.getDesktop().browse(new URI(jTextFieldPath.getText()));
            }
            else
            {
                // Ubuntu
                Runtime runtime = Runtime.getRuntime();
                runtime.exec("/usr/bin/firefox -new-window " + jTextFieldPath.getText());
            }
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
        }
    }//GEN-LAST:event_jButtonFileSelect2ActionPerformed

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

    private void jCheckBox8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox8ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox8ActionPerformed

    private void jButtonFileSelect12ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect12ActionPerformed

        Thread pdfLoaderThread = new Thread()
        {
            public void run()
            {
                if (mCartridgeProperties==null) return;
                if (!DownloaderPanel.ensureLocalFile("PDF", mCartridgeProperties.getPDFLink(), Global.mainPathPrefix+mCartridgeProperties.getPDFFile()))
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            ShowErrorDialog.showErrorDialog("Error loading PDF for: "+mCartridgeProperties.getCartName()+"!");
                        }
                    });                    
                }
                else
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            startPDFCallback();
                        }
                    });                    
                }
            }
        };
        pdfLoaderThread.start();   
        
    }//GEN-LAST:event_jButtonFileSelect12ActionPerformed
                                   

    private void startPDFCallback()
    {
        if (mCartridgeProperties.getPDFFile()!=null)
        {
            if (mCartridgeProperties.getPDFFile().trim().length()>2)
                invokeSystemFile(new File(Global.mainPathPrefix+convertSeperator(mCartridgeProperties.getPDFFile().trim())));
        }
    }
        
    private void jTextField2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField2ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField2ActionPerformed

    private void jCheckBox16ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox16ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox16ActionPerformed

    private void jCheckBox26ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox26ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox26ActionPerformed

    private void jCheckBoxXmas1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxXmas1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxXmas1ActionPerformed

    private void jCheckBox24ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox24ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox24ActionPerformed

    private void jCheckBoxPB6IRQActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxPB6IRQActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxPB6IRQActionPerformed

    public static boolean invokeSystemFile(File file)
    {
        Desktop desktop = null;
        // Before more Desktop API is used, first check
        // whether the API is supported by this particular
        // virtual machine (VM) on this particular host.
        try
        {
            if (Desktop.isDesktopSupported())
            {
                desktop = Desktop.getDesktop();
                desktop.open(file);
            }
        }
        catch (IOException e)
        {
            Configuration.getConfiguration().getDebugEntity().addLog(e, WARN);
            return false;
        }        
        return true;
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private de.malban.gui.components.CSATablePanel cSATablePanel1;
    private javax.swing.JButton jButtonFileSelect12;
    private javax.swing.JButton jButtonFileSelect2;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox10;
    private javax.swing.JCheckBox jCheckBox11;
    private javax.swing.JCheckBox jCheckBox12;
    private javax.swing.JCheckBox jCheckBox13;
    private javax.swing.JCheckBox jCheckBox14;
    private javax.swing.JCheckBox jCheckBox15;
    private javax.swing.JCheckBox jCheckBox16;
    private javax.swing.JCheckBox jCheckBox17;
    private javax.swing.JCheckBox jCheckBox18;
    private javax.swing.JCheckBox jCheckBox19;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox20;
    private javax.swing.JCheckBox jCheckBox21;
    private javax.swing.JCheckBox jCheckBox22;
    private javax.swing.JCheckBox jCheckBox23;
    private javax.swing.JCheckBox jCheckBox24;
    private javax.swing.JCheckBox jCheckBox25;
    private javax.swing.JCheckBox jCheckBox26;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JCheckBox jCheckBox48KROM;
    private javax.swing.JCheckBox jCheckBox5;
    private javax.swing.JCheckBox jCheckBox6;
    private javax.swing.JCheckBox jCheckBox7;
    private javax.swing.JCheckBox jCheckBox8;
    private javax.swing.JCheckBox jCheckBox9;
    private javax.swing.JCheckBox jCheckBoxPB6IRQ;
    private javax.swing.JCheckBox jCheckBoxXmas1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel18;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel22;
    private javax.swing.JLabel jLabel23;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField3;
    private javax.swing.JTextField jTextField4;
    private javax.swing.JTextField jTextFieldPath;
    private javax.swing.JTextField jTextFieldPath3;
    private javax.swing.JTextPane jTextPane1;
    private javax.swing.JTextPane jTextPane2;
    private javax.swing.JTextPane jTextPane3;
    private javax.swing.JTextPane jTextPane4;
    private javax.swing.JTextPane jTextPane5;
    private de.malban.graphics.SingleImagePanel singleImagePanel1;
    private de.malban.graphics.SingleImagePanel singleImagePanel2;
    private de.malban.graphics.SingleImagePanel singleImagePanel3;
    private de.malban.graphics.SingleImagePanel singleImagePanel4;
    private de.malban.graphics.SingleImagePanel singleImagePanel5;
    // End of variables declaration//GEN-END:variables

    
    public void loadAllCartridged()
    {
        allCartridges.clear();
        CartridgePropertiesPool mCartridgePropertiesPool = new CartridgePropertiesPool();
        Collection<CartridgeProperties> colC = mCartridgePropertiesPool.getMapForKlasse("Cartridge").values();
        Iterator<CartridgeProperties> iterC = colC.iterator();
        while (iterC.hasNext())
        {
            CartridgeProperties item = iterC.next();
            allCartridges.add(item);
        }
    }
    public void save()
    {
        CartridgePropertiesPool mCartridgePropertiesPool = new CartridgePropertiesPool();
        Collection<CartridgeProperties> colC = mCartridgePropertiesPool.getMapForKlasse("Cartridge").values();
        mCartridgePropertiesPool.put(mCartridgeProperties);
        mCartridgePropertiesPool.save();
    }
    
    public void selectionChanged(SelectionEvent e)
    {
        int[] rows = cSATablePanel1.getSelectedRows();
        if (rows.length>0) selectCard(rows[0]);
    }

    void selectCard(int no)
    {
        mCartridgeProperties = allCartridges.get(no);
 
        
	jTextField2.setText(mCartridgeProperties.getCartName());
	jTextField1.setText(mCartridgeProperties.getAuthor());
	jTextField3.setText(mCartridgeProperties.getYear());
	jTextField4.setText(""+mCartridgeProperties.getCRC());
	jTextFieldPath.setText(mCartridgeProperties.getHomepage());

	jTextPane4.setText(mCartridgeProperties.getCheats());
	jTextPane5.setText(mCartridgeProperties.getEastereggs());
        
        
	jTextPane1.setText(mCartridgeProperties.getLicence());
	jTextFieldPath3.setText(mCartridgeProperties.getCopyrightType());

        jCheckBox11.setSelected(mCartridgeProperties.getCompleteGame() );
        jCheckBox12.setSelected(mCartridgeProperties.getDemo() );
        jCheckBox13.setSelected(mCartridgeProperties.getSnippet() );
        jCheckBox14.setSelected(mCartridgeProperties.getHomebrew() );
        
        
        int flag = mCartridgeProperties.getTypeFlags();
        jCheckBox1.setSelected((flag&FLAG_VEC_VOICE)!=0);
        jCheckBox2.setSelected((flag&FLAG_DS2430A)!=0);
        jCheckBox16.setSelected((flag&Cartridge.FLAG_MICROCHIP)!=0);
        jCheckBox9.setSelected((flag&FLAG_RAM_ANIMACTION)!=0);
        jCheckBox10.setSelected((flag&FLAG_RAM_RA_SPECTRUM)!=0);
        jCheckBox3.setSelected((flag&FLAG_LIGHTPEN1)!=0);
        jCheckBox4.setSelected((flag&FLAG_LIGHTPEN2)!=0);
        jCheckBox5.setSelected((flag&FLAG_IMAGER)!=0);
        jCheckBox6.setSelected((flag&FLAG_EXTREME_MULTI)!=0);
        jCheckBox7.setSelected((flag&FLAG_BANKSWITCH_DONDZILA)!=0);
        jCheckBox8.setSelected((flag&FLAG_BANKSWITCH_VECFLASH)!=0);
        jCheckBox15.setSelected((flag&FLAG_VEC_VOX)!=0);
        
        jCheckBox17.setSelected((flag&FLAG_DUALVEC1)!=0);
        jCheckBox18.setSelected((flag&FLAG_DUALVEC2)!=0);
        jCheckBox19.setSelected((flag&FLAG_LOGO)!=0);
        jCheckBox20.setSelected((flag&Cartridge.FLAG_XMAS)!=0);
        jCheckBox21.setSelected((flag&Cartridge.FLAG_DS2431)!=0);
        jCheckBox22.setSelected((flag&Cartridge.FLAG_32K_ONLY)!=0);
        jCheckBox23.setSelected((flag&FLAG_SID)!=0);
        jCheckBox48KROM.setSelected((flag&FLAG_48K)!=0);
        jCheckBoxPB6IRQ.setSelected((flag&FLAG_BS_PB6_IRQ)!=0);

        jCheckBox26.setSelected((flag&FLAG_ATMEL_EEPROM)!=0);
        jCheckBox25.setSelected((flag&FLAG_PIC_EEPROM)!=0);
        jCheckBoxXmas1.setSelected((flag&FLAG_V4E_16K_BS)!=0);
        jCheckBox24.setSelected((flag&FLAG_KEYBOARD)!=0);
        
        // load images
        singleImagePanel3.unsetImage();
        if (mCartridgeProperties.getOverlay() != null)
        if (mCartridgeProperties.getOverlay().trim().length()>2)
        {
            singleImagePanel3.setImage(Global.mainPathPrefix+convertSeperator(mCartridgeProperties.getOverlay().trim()), true);
        }
        singleImagePanel1.unsetImage();
        if (mCartridgeProperties.getFrontImage()!= null)
        if (mCartridgeProperties.getFrontImage().trim().length()>2)
        {
            singleImagePanel1.setImage(Global.mainPathPrefix+convertSeperator(mCartridgeProperties.getFrontImage()), true);
        }
        singleImagePanel2.unsetImage();
        if (mCartridgeProperties.getBackImage()!=null)
        if (mCartridgeProperties.getBackImage().trim().length()>2)
        {
            singleImagePanel2.setImage(Global.mainPathPrefix+convertSeperator(mCartridgeProperties.getBackImage().trim()), true);
        }
        singleImagePanel5.unsetImage();
        if (mCartridgeProperties.getCartridgeImage()!=null)
        if (mCartridgeProperties.getCartridgeImage().trim().length()>2)
        {
            singleImagePanel5.setImage(Global.mainPathPrefix+convertSeperator(mCartridgeProperties.getCartridgeImage().trim()), true);
        }
        singleImagePanel4.unsetImage();
        if (mCartridgeProperties.getInGameImage()!=null)
        if (mCartridgeProperties.getInGameImage().trim().length()>2)
        {
            singleImagePanel4.setImage(Global.mainPathPrefix+convertSeperator(mCartridgeProperties.getInGameImage().trim()), true);
        }
        // load texts
        jTextPane2.setText("");
        if (mCartridgeProperties.getInstructionFile() != null)
        if (mCartridgeProperties.getInstructionFile().trim().length()>2)
        {
            try 
            {
                FileReader fr = new FileReader(Global.mainPathPrefix+convertSeperator(mCartridgeProperties.getInstructionFile().trim()));
                jTextPane2.read(fr, null);
                fr.close();
            }
            catch (IOException e) 
            {
                log.addLog(e, WARN);
            }
        }
        jTextPane3.setText("");
        if (mCartridgeProperties.getCritic()!=null)
        if (mCartridgeProperties.getCritic().trim().length()>2)
        {
            try 
            {
                FileReader fr = new FileReader(Global.mainPathPrefix+convertSeperator(mCartridgeProperties.getCritic().trim()));
                jTextPane3.read(fr, null);
                fr.close();
            }
            catch (IOException e) 
            {
                log.addLog(e, WARN);
            }
        }
        jButtonFileSelect12.setEnabled(mCartridgeProperties.getPDFFile().trim().length()!=0);
                
    }
    void startCartridge(int no)
    {
        CSAMainFrame p = (CSAMainFrame)mParent;
        VecXPanel vecxy  = p.getVecxy();
        if (vecxy ==null) return;
    
        CartridgeProperties sel = allCartridges.get(no);
        loadAllCartridged();

        // reload and accdept changed (more or less)
        for (CartridgeProperties rel : allCartridges)
        {
            if (rel.getCartName().equals(sel.getCartName()))
            {
                sel = rel;
                break;
            }
        }
        
     
        vecxy.startCartridge(sel, VecX.START_TYPE_RUN);
    }
    public static String convertSeperator(String filename)
    {
        String ret = de.malban.util.UtilityString.replace(filename, "/", File.separator);
        ret = de.malban.util.UtilityString.replace(ret, "\\", File.separator);
        return ret;
    }
    public void deIconified() { }
}

