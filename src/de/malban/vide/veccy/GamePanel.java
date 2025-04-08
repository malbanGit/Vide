/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JPanel.java to edit this template
 */

package de.malban.vide.veccy;

import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InputDialog;
import de.malban.gui.panels.LogPanel;
import static de.malban.util.UtilityString.Int0;
import java.util.Collection;
import java.util.Iterator;
import javax.swing.JFrame;
import static de.malban.util.UtilityString.IntX;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import java.util.Vector;


/**
 *
 * @author salchr
 */
public class GamePanel extends javax.swing.JPanel implements Windowable{

    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    VeccyPanel veccy=null;
    private int mClassSetting=0;
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;

    private GameData mGameData = new GameData();
    private GameDataPool mGameDataPool;
    private LevelData mLevelData = new LevelData();
    private LevelDataPool mLevelDataPool;
    private ActionNewData mActionData = new ActionNewData();
    private ActionNewDataPool mActionDataPool;
    private SpriteData mSpriteData = new SpriteData();
    private SpriteDataPool mSpriteDataPool;
    private LevelObjectDataPool mLevelObjectDataPool;

    
    @Override
    public void closing()
    {
        if (veccy != null)
            veccy.removeSBPanel();
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
    @Override public void deIconified() { }
    @Override public void setParentWindow(CSAView jpv)
    {
        mParent = jpv;
    }
    @Override public void setMenuItem(javax.swing.JMenuItem item)
    {
        mParentMenuItem = item;
        mParentMenuItem.setText("Vector: Game");
    }
    @Override public javax.swing.JMenuItem getMenuItem()
    {
        return mParentMenuItem;
    }
    @Override public javax.swing.JPanel getPanel()
    {
        return this;
    }            
    /** Creates new form GamePanel */
    public GamePanel() {
        initComponents();

        mActionDataPool = new ActionNewDataPool();
        resetConfigPoolActions(false);

        mSpriteDataPool = new SpriteDataPool();
        resetConfigPoolSprites(false);

        mGameDataPool = new GameDataPool();
        resetConfigPoolGame(false);

        mLevelObjectDataPool = new LevelObjectDataPool();
        mLevelDataPool = new LevelDataPool();
        resetConfigPoolLevel(false);

        resetDefaultPoolActions();
        spriteNameEditEnabled();
        levelNameEditEnabled();
        jButtonCreateNewLevelObject.setEnabled(mLevelObjectDataPool!=null);
    }
    
    private void resetConfigPoolGame(boolean select) /* allneeded*/
    {
        mClassSetting++;
        Collection<String> collectionKlasse = mGameDataPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        int i = 0;
        String klasse = "AllGames";

        Collection<GameData> colC = mGameDataPool.getMapForKlasse(klasse).values();
        Iterator<GameData> iterC = colC.iterator();

        jComboBoxNameGame.removeAllItems();
        i = 0;
        while (iterC.hasNext())
        {
            GameData item = iterC.next();
            jComboBoxNameGame.addItem(item.mName);
            if ((i==0) && (select))
            {
                jComboBoxNameGame.setSelectedIndex(0);
                mGameData = mGameDataPool.get(item.mName);
                setAllFromCurrentGame();
            }
            i++;
        }
        if (!select)  jComboBoxNameGame.setSelectedIndex(-1);
        mClassSetting--;
    }

    private void clearAllGame() /* allneeded*/
    {
        mClassSetting++;
        mGameData = new GameData();
        mLevelObjectDataPool = null;
        setAllFromCurrentGame();
        
        mLevelData = new LevelData();
        setAllFromCurrentLevel();
        
        mClassSetting--;
    }

    private void setAllFromCurrentGame() /* allneeded*/
    {
        mClassSetting++;
        jComboBoxNameGame.setSelectedItem(mGameData.mName);
        jTextFieldNameGame.setText(mGameData.mName);

        mLevelDataPool = new LevelDataPool();
        resetConfigPoolLevel(false);


        
        levelNameEditEnabled();
        
        mClassSetting--;
    }

    private void readAllToCurrentGame() /* allneeded*/
    {
        mGameData.mName = jTextFieldNameGame.getText();
        mGameData.mClass = "AllGames";

        /* TO DO: Fill in needed Fields!
         *
         */
    }    

    private void resetConfigPoolLevel(boolean select) /* allneeded*/
    {
        mClassSetting++;
        Collection<String> collectionKlasse = mLevelDataPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        int i = 0;
        String klasse =     getGameName()+"_Levels";


        Collection<LevelData> colC = mLevelDataPool.getMapForKlasse(klasse).values();
        Iterator<LevelData> iterC = colC.iterator();

        String currentName = mLevelData.mName;
        jComboBoxNameLevel.removeAllItems();
        i = 0;
        while (iterC.hasNext())
        {
            LevelData item = iterC.next();
            jComboBoxNameLevel.addItem(item.mName);
            if (item.mName.equals(currentName) && (select))
            {
                jComboBoxNameLevel.setSelectedIndex(0);
                mLevelData = mLevelDataPool.get(item.mName);
                setAllFromCurrentLevel();
            }
            i++;
        }
        if (!select)  jComboBoxNameLevel.setSelectedIndex(-1);
        mClassSetting--;
    }

    private void clearAllLevel() /* allneeded*/
    {
        mClassSetting++;
        mLevelData = new LevelData();
        setAllFromCurrentLevel();
        mClassSetting--;
    }

    private void setAllFromCurrentLevel() /* allneeded*/
    {
        mClassSetting++;
        jComboBoxNameLevel.setSelectedItem(mLevelData.mName);
        jTextFieldNameLevel.setText(mLevelData.mName);
        jTextFieldLevelNumber.setText("" + mLevelData.mLevelOrder);
        
        setAllLevelObjects();
        mClassSetting--;
    }

    private void readAllToCurrentLevel() /* allneeded*/
    {
        mLevelData.mName = jTextFieldNameLevel.getText();
        mLevelData.mClass = getGameName()+"_Levels";
        mLevelData.mLevelOrder = IntX(jTextFieldLevelNumber.getText(),1);

        /* TO DO: Fill in needed Fields!
         *
         */
    }
    
    
    
    
    private void resetConfigPoolSprites(boolean select) /* allneeded*/
    {
        mClassSetting++;
        Collection<String> collectionKlasse = mSpriteDataPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        int i = 0;
        String klasse = "AllSprites";

        Collection<SpriteData> colC = mSpriteDataPool.getMapForKlasse(klasse).values();
        List list = new ArrayList(colC);
        Collections.sort(list, new Comparator<SpriteData>()
                {
                   public int compare(SpriteData o1, SpriteData o2)
                   {
                      return o1.mName.compareToIgnoreCase(o2.mName);
                   }
                } );        
        Iterator<SpriteData> iterC = list.iterator();

        jComboBoxSpriteName.removeAllItems();
        i = 0;
        while (iterC.hasNext())
        {
            SpriteData item = iterC.next();
            jComboBoxSpriteName.addItem(item.mName);
            if ((i==0) && (select))
            {
                jComboBoxSpriteName.setSelectedIndex(0);
                mSpriteData = mSpriteDataPool.get(item.mName);
                setAllFromCurrentSprites();
            }
            i++;
        }
        if (!select)  jComboBoxSpriteName.setSelectedIndex(-1);
        mClassSetting--;
    }
    private void resetConfigPoolActions(boolean select) /* allneeded*/
    {
        mClassSetting++;
        Collection<String> collectionKlasse = mActionDataPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        int i = 0;
        String klasse = getSpriteName()+"_Actions";

        Collection<ActionNewData> colC = mActionDataPool.getMapForKlasse(klasse).values();
        Iterator<ActionNewData> iterC = colC.iterator();

        if (colC.size() == 0)
        {
            convertOldActionToNewAction();
            mActionDataPool = new ActionNewDataPool();

            collectionKlasse = mActionDataPool.getKlassenHashMap().values();
            iterKlasse = collectionKlasse.iterator();
            i = 0;
            klasse = getSpriteName()+"_Actions";

            colC = mActionDataPool.getMapForKlasse(klasse).values();
            iterC = colC.iterator();

        }
        
        jComboBoxActionName.removeAllItems();
        i = 0;
        boolean somethingDone = false;
        while (iterC.hasNext())
        {
            ActionNewData item = iterC.next();
            jComboBoxActionName.addItem(item.mName);
            if ((i==0) && (select))
            {
                jComboBoxActionName.setSelectedIndex(0);
                mActionData = mActionDataPool.get(item.mName);
                setAllFromCurrentActions();
            }
            i++;
        }
        if (!select)  jComboBoxActionName.setSelectedIndex(-1);
        mClassSetting--;
    }

    private void resetDefaultPoolActions() /* allneeded*/
    {
        mClassSetting++;
        Collection<String> collectionKlasse = mActionDataPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        int i = 0;
        String klasse = getSpriteName()+"_Actions";


        Collection<ActionNewData> colC = mActionDataPool.getMapForKlasse(klasse).values();
        Iterator<ActionNewData> iterC = colC.iterator();

        String selectedDefaultAction = mSpriteData.mDefaultActionID;
        jComboBoxDefaultAction.removeAllItems();
        jComboBoxDefaultAction.addItem("");
        i = 1;
        while (iterC.hasNext())
        {
            ActionNewData item = iterC.next();
            jComboBoxDefaultAction.addItem(item.mName);

            if (selectedDefaultAction.equals(item.mName)) 
            {
                jComboBoxDefaultAction.setSelectedIndex(i);
            }
            i++;
        }
        mClassSetting--;
    }

    private void clearAllActions() /* allneeded*/
    {
        mClassSetting++;
        mActionData = new ActionNewData();
        setAllFromCurrentActions();
        spriteNameEditEnabled();
        mClassSetting--;
    }

    private void setAllFromCurrentActions() /* allneeded*/
    {
        mClassSetting++;
        jComboBoxActionName.setSelectedItem(mActionData.mName);
        actionPanel2.setActionData(mActionData, mSpriteData);
        /* TO DO: Fill in needed Fields!
         *
         */
        mClassSetting--;
    }

    private void readAllToCurrentActions() /* allneeded*/
    {
        if (actionPanel2 != null) actionPanel2.stopEditing();
        mActionData = actionPanel2.getActionData();
        mActionData.mClass = getSpriteName()+"_Actions";

    }    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        actionPanel1 = new de.malban.vide.veccy.ActionPanel();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanelLevel = new javax.swing.JPanel();
        jLabel5 = new javax.swing.JLabel();
        jTextFieldNameLevel = new javax.swing.JTextField();
        jComboBoxNameLevel = new javax.swing.JComboBox();
        jButtonSaveLevel = new javax.swing.JButton();
        jButtonSaveAsNewLevel = new javax.swing.JButton();
        jButtonDeleteLevel = new javax.swing.JButton();
        jButtonNewLevel = new javax.swing.JButton();
        jButtonCreateNewLevelObject = new javax.swing.JButton();
        jScrollPane2 = new javax.swing.JScrollPane();
        jPanelLevelObjectPanel = new javax.swing.JPanel();
        jLabel6 = new javax.swing.JLabel();
        jTextFieldLevelNumber = new javax.swing.JTextField();
        jPanelSprite = new javax.swing.JPanel();
        jComboBoxDefaultAction = new javax.swing.JComboBox<>();
        jLabel1 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jTextFieldSpriteID = new javax.swing.JTextField();
        jButtonSaveAsNewSprite = new javax.swing.JButton();
        jButtonSaveSprite = new javax.swing.JButton();
        jComboBoxSpriteName = new javax.swing.JComboBox();
        jButtonDeleteSprite = new javax.swing.JButton();
        jButtonNewSprite = new javax.swing.JButton();
        jPanel1 = new javax.swing.JPanel();
        actionPanel2 = new de.malban.vide.veccy.ActionPanel();
        jButtonDeleteAction = new javax.swing.JButton();
        jButtonSaveAsNewAction = new javax.swing.JButton();
        jButtonSaveAction = new javax.swing.JButton();
        jButtonNewAction = new javax.swing.JButton();
        jComboBoxActionName = new javax.swing.JComboBox();
        jLabel2 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jTextFieldSpriteUID = new javax.swing.JTextField();
        jPanel2 = new javax.swing.JPanel();
        backGroundScenePanel1 = new de.malban.vide.veccy.BackGroundScenePanel();
        jButton1 = new javax.swing.JButton();
        jLabel4 = new javax.swing.JLabel();
        jTextFieldNameGame = new javax.swing.JTextField();
        jComboBoxNameGame = new javax.swing.JComboBox();
        jButtonNewGame = new javax.swing.JButton();
        jButtonSaveGame = new javax.swing.JButton();
        jButtonSaveAsNewGame = new javax.swing.JButton();
        jButtonDeleteGame = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTextArea1 = new javax.swing.JTextArea();

        jLabel5.setText("Name");

        jComboBoxNameLevel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxNameLevelActionPerformed(evt);
            }
        });

        jButtonSaveLevel.setText("Save");
        jButtonSaveLevel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveLevelActionPerformed(evt);
            }
        });

        jButtonSaveAsNewLevel.setText("Save as new");
        jButtonSaveAsNewLevel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveAsNewLevelActionPerformed(evt);
            }
        });

        jButtonDeleteLevel.setText("Delete");
        jButtonDeleteLevel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDeleteLevelActionPerformed(evt);
            }
        });

        jButtonNewLevel.setText("New");
        jButtonNewLevel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewLevelActionPerformed(evt);
            }
        });

        jButtonCreateNewLevelObject.setText("add object");
        jButtonCreateNewLevelObject.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCreateNewLevelObjectActionPerformed(evt);
            }
        });

        jScrollPane2.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

        jPanelLevelObjectPanel.setLayout(new javax.swing.BoxLayout(jPanelLevelObjectPanel, javax.swing.BoxLayout.Y_AXIS));
        jScrollPane2.setViewportView(jPanelLevelObjectPanel);

        jLabel6.setText("Level number");

        jTextFieldLevelNumber.setHorizontalAlignment(javax.swing.JTextField.TRAILING);
        jTextFieldLevelNumber.setText("1");
        jTextFieldLevelNumber.setToolTipText("Start with one and go steady up!");

        javax.swing.GroupLayout jPanelLevelLayout = new javax.swing.GroupLayout(jPanelLevel);
        jPanelLevel.setLayout(jPanelLevelLayout);
        jPanelLevelLayout.setHorizontalGroup(
            jPanelLevelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelLevelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelLevelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanelLevelLayout.createSequentialGroup()
                        .addComponent(jLabel5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldNameLevel, javax.swing.GroupLayout.PREFERRED_SIZE, 125, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButtonCreateNewLevelObject))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanelLevelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 131, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBoxNameLevel, javax.swing.GroupLayout.PREFERRED_SIZE, 134, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanelLevelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButtonNewLevel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jTextFieldLevelNumber, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSaveLevel)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSaveAsNewLevel)
                .addGap(41, 41, 41)
                .addComponent(jButtonDeleteLevel)
                .addContainerGap(602, Short.MAX_VALUE))
            .addComponent(jScrollPane2)
        );
        jPanelLevelLayout.setVerticalGroup(
            jPanelLevelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelLevelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelLevelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonNewLevel)
                    .addComponent(jLabel5)
                    .addComponent(jTextFieldNameLevel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBoxNameLevel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDeleteLevel)
                    .addComponent(jButtonSaveLevel)
                    .addComponent(jButtonSaveAsNewLevel))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanelLevelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonCreateNewLevelObject)
                    .addComponent(jLabel6)
                    .addComponent(jTextFieldLevelNumber, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 686, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Levels", jPanelLevel);

        jComboBoxDefaultAction.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxDefaultAction.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxDefaultActionActionPerformed(evt);
            }
        });

        jLabel1.setText("default action");

        jLabel3.setText("Sprite ID");

        jButtonSaveAsNewSprite.setText("Save as new");
        jButtonSaveAsNewSprite.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveAsNewSpriteActionPerformed(evt);
            }
        });

        jButtonSaveSprite.setText("Save");
        jButtonSaveSprite.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveSpriteActionPerformed(evt);
            }
        });

        jComboBoxSpriteName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxSpriteNameActionPerformed(evt);
            }
        });

        jButtonDeleteSprite.setText("Delete");
        jButtonDeleteSprite.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDeleteSpriteActionPerformed(evt);
            }
        });

        jButtonNewSprite.setText("New");
        jButtonNewSprite.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewSpriteActionPerformed(evt);
            }
        });

        jButtonDeleteAction.setText("Delete");
        jButtonDeleteAction.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDeleteActionActionPerformed(evt);
            }
        });

        jButtonSaveAsNewAction.setText("Save as new");
        jButtonSaveAsNewAction.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveAsNewActionActionPerformed(evt);
            }
        });

        jButtonSaveAction.setText("Save");
        jButtonSaveAction.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveActionActionPerformed(evt);
            }
        });

        jButtonNewAction.setText("New");
        jButtonNewAction.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewActionActionPerformed(evt);
            }
        });

        jComboBoxActionName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxActionNameActionPerformed(evt);
            }
        });

        jLabel2.setText("edit action");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(actionPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, 1217, Short.MAX_VALUE)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addGap(48, 48, 48)
                        .addComponent(jComboBoxActionName, javax.swing.GroupLayout.PREFERRED_SIZE, 173, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButtonNewAction)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSaveAction)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSaveAsNewAction)
                        .addGap(34, 34, 34)
                        .addComponent(jButtonDeleteAction)))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jComboBoxActionName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonNewAction)
                    .addComponent(jButtonSaveAction)
                    .addComponent(jButtonSaveAsNewAction)
                    .addComponent(jButtonDeleteAction))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(actionPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, 659, Short.MAX_VALUE))
        );

        jLabel7.setText("UID");

        jTextFieldSpriteUID.setText("0");
        jTextFieldSpriteUID.setToolTipText("Each sprite needs a distinct UID, these is used to identify sprites during colision detection!");

        javax.swing.GroupLayout jPanelSpriteLayout = new javax.swing.GroupLayout(jPanelSprite);
        jPanelSprite.setLayout(jPanelSpriteLayout);
        jPanelSpriteLayout.setHorizontalGroup(
            jPanelSpriteLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanelSpriteLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelSpriteLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel3)
                    .addComponent(jLabel1))
                .addGap(31, 31, 31)
                .addGroup(jPanelSpriteLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jComboBoxDefaultAction, 0, 172, Short.MAX_VALUE)
                    .addComponent(jTextFieldSpriteID))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanelSpriteLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanelSpriteLayout.createSequentialGroup()
                        .addComponent(jLabel7)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jTextFieldSpriteUID, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jComboBoxSpriteName, javax.swing.GroupLayout.PREFERRED_SIZE, 147, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonNewSprite)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSaveSprite)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSaveAsNewSprite)
                .addGap(34, 34, 34)
                .addComponent(jButtonDeleteSprite)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanelSpriteLayout.setVerticalGroup(
            jPanelSpriteLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelSpriteLayout.createSequentialGroup()
                .addGap(5, 5, 5)
                .addGroup(jPanelSpriteLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButtonDeleteSprite, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonSaveAsNewSprite, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonSaveSprite, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonNewSprite, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jComboBoxSpriteName)
                    .addGroup(jPanelSpriteLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTextFieldSpriteID)
                        .addComponent(jLabel3)))
                .addGap(10, 10, 10)
                .addGroup(jPanelSpriteLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(jComboBoxDefaultAction, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel7)
                    .addComponent(jTextFieldSpriteUID, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(4, 4, 4)
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Sprites", jPanelSprite);

        jPanel2.setName(""); // NOI18N

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addComponent(backGroundScenePanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 502, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addComponent(backGroundScenePanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 276, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Background Scene", jPanel2);

        jButton1.setText("Generate game");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jLabel4.setText("Name");

        jComboBoxNameGame.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxNameGameActionPerformed(evt);
            }
        });

        jButtonNewGame.setText("New");
        jButtonNewGame.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewGameActionPerformed(evt);
            }
        });

        jButtonSaveGame.setText("Save");
        jButtonSaveGame.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveGameActionPerformed(evt);
            }
        });

        jButtonSaveAsNewGame.setText("Save as new");
        jButtonSaveAsNewGame.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveAsNewGameActionPerformed(evt);
            }
        });

        jButtonDeleteGame.setText("Delete");
        jButtonDeleteGame.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDeleteGameActionPerformed(evt);
            }
        });

        jTextArea1.setColumns(20);
        jTextArea1.setRows(5);
        jTextArea1.setText("All sprites are drawn with a scale of $8!\nAll positioning is done with a scale of $80!");
        jScrollPane1.setViewportView(jTextArea1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel4)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton1)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jTextFieldNameGame, javax.swing.GroupLayout.PREFERRED_SIZE, 133, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jComboBoxNameGame, javax.swing.GroupLayout.PREFERRED_SIZE, 131, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButtonNewGame)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSaveGame)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSaveAsNewGame)
                        .addGap(42, 42, 42)
                        .addComponent(jButtonDeleteGame)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 333, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel4)
                            .addComponent(jTextFieldNameGame, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jComboBoxNameGame, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonNewGame)
                            .addComponent(jButtonSaveGame)
                            .addComponent(jButtonSaveAsNewGame)
                            .addComponent(jButtonDeleteGame))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton1))
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 48, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jTabbedPane1))
        );

        jTabbedPane1.getAccessibleContext().setAccessibleName("game");
    }// </editor-fold>//GEN-END:initComponents

    private void jComboBoxActionNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxActionNameActionPerformed
        if (mClassSetting > 0 ) return;
        String key = jComboBoxActionName.getSelectedItem().toString();

        mActionData = mActionDataPool.get(key);
        setAllFromCurrentActions();
    }//GEN-LAST:event_jComboBoxActionNameActionPerformed

    private void jButtonSaveActionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionActionPerformed

        readAllToCurrentActions();
        actionPanel2.saveTriggersAndResults();
        
        mActionDataPool.put(mActionData);
        mActionDataPool.save();
        mClassSetting++;
        String nameToSet = mActionData.mName;
        // String klasse = jTextFieldKlasse.getText();
        resetConfigPoolActions(true);
        mClassSetting--;
        jComboBoxActionName.setSelectedItem(nameToSet);
        resetDefaultPoolActions();
        
        
        
        spriteNameEditEnabled();
    }//GEN-LAST:event_jButtonSaveActionActionPerformed

    private void jButtonSaveAsNewActionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveAsNewActionActionPerformed
        mActionData = new ActionNewData();
        readAllToCurrentActions();
        actionPanel2.saveTriggersAndResults();

        mActionDataPool.putAsNew(mActionData);
        mActionDataPool.save();
        mClassSetting++;
        //String klasse = jTextFieldKlasse.getText();
        resetConfigPoolActions(true);
        jComboBoxActionName.setSelectedItem(mActionData.mName);
        spriteNameEditEnabled();
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveAsNewActionActionPerformed

    private void jButtonDeleteActionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteActionActionPerformed
        readAllToCurrentActions();
        mActionDataPool.remove(mActionData);
        mActionDataPool.save();
        mClassSetting++;
        resetConfigPoolActions(true);

        if (jComboBoxActionName.getSelectedIndex() == -1)
        {
            clearAllActions();
        }
        if (jComboBoxActionName.getSelectedItem() == null)
        {
            mActionData = new ActionNewData();
            setAllFromCurrentActions();
            spriteNameEditEnabled();
            mClassSetting--;
            return;
        }
        String key = jComboBoxActionName.getSelectedItem().toString();
        mActionData = mActionDataPool.get(key);
        setAllFromCurrentActions();
        spriteNameEditEnabled();
        mClassSetting--;
    }//GEN-LAST:event_jButtonDeleteActionActionPerformed

    private void jButtonNewActionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewActionActionPerformed
        mClassSetting++;
        mActionData = new ActionNewData();
        mActionData.mtextHeight=2;
        mActionData.mtextWidth=50;
        clearAllActions();
        resetConfigPoolActions(false);
        mClassSetting--;
    }//GEN-LAST:event_jButtonNewActionActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        if (actionPanel2 != null) actionPanel2.stopEditing();
        GameGenerator gg = new GameGenerator(veccy, jTextFieldNameGame.getText());
        gg.generateGame();
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButtonSaveAsNewSpriteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveAsNewSpriteActionPerformed
        String oldName = mSpriteData.mName;

        mSpriteData = new SpriteData();
        readAllToCurrentSprites();
        mSpriteData.mName = InputDialog.showInputDialog("Enter new sprite name:");
        String newName = mSpriteData.mName;

        mSpriteDataPool.putAsNew(mSpriteData);
        String selectedSprite = mSpriteData.mName;
        mSpriteDataPool.save();

        copyActionFromSpriteToSprite(oldName, newName);

        mClassSetting++;
        resetConfigPoolSprites(true);
        jComboBoxSpriteName.setSelectedItem(selectedSprite);
        updateSpriteRefs();
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveAsNewSpriteActionPerformed

    private void jButtonSaveSpriteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveSpriteActionPerformed

        readAllToCurrentSprites();
        mSpriteDataPool.put(mSpriteData);
        String selectedSprite = mSpriteData.mName;
        String selectedAction = mActionData.mName;
        mSpriteDataPool.save();
        mClassSetting++;
        resetConfigPoolSprites(true);
        resetConfigPoolActions(true);
        mClassSetting--;
        jComboBoxSpriteName.setSelectedItem(selectedSprite);
        jComboBoxActionName.setSelectedItem(selectedAction);
        mClassSetting++;
        updateSpriteRefs();
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveSpriteActionPerformed

    private void jComboBoxSpriteNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxSpriteNameActionPerformed
        if (mClassSetting > 0 ) return;
        String key = jComboBoxSpriteName.getSelectedItem().toString();
        mSpriteData = mSpriteDataPool.get(key);
        setAllFromCurrentSprites();
        spriteNameEditEnabled();
    }//GEN-LAST:event_jComboBoxSpriteNameActionPerformed

    private void jButtonDeleteSpriteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteSpriteActionPerformed
        readAllToCurrentSprites();
        mSpriteDataPool.remove(mSpriteData);
        mSpriteDataPool.save();
        mClassSetting++;
        resetConfigPoolSprites(true);

        if (jComboBoxActionName.getSelectedIndex() == -1)
        {
            clearAllSprites();
        }

        String key = jComboBoxActionName.getSelectedItem().toString();
        mSpriteData = mSpriteDataPool.get(key);
        setAllFromCurrentSprites();
        updateSpriteRefs();

        mClassSetting--;
    }//GEN-LAST:event_jButtonDeleteSpriteActionPerformed

    private void jButtonNewSpriteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewSpriteActionPerformed
        mClassSetting++;
        mSpriteData = new SpriteData();
        clearAllSprites();
        resetConfigPoolSprites(false);
        spriteNameEditEnabled();
        mClassSetting--;
    }//GEN-LAST:event_jButtonNewSpriteActionPerformed

    private void jComboBoxNameLevelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxNameLevelActionPerformed
        if (mClassSetting > 0 ) return;
        String key = jComboBoxNameLevel.getSelectedItem().toString();
        mLevelData = mLevelDataPool.get(key);
        verifyLevelData(mLevelData);
        
        setAllFromCurrentLevel();
    }//GEN-LAST:event_jComboBoxNameLevelActionPerformed

    private void jButtonSaveLevelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveLevelActionPerformed
        readAllToCurrentLevel();
        mLevelDataPool.put(mLevelData);
        mLevelDataPool.save();
        mClassSetting++;
        //String currentName = mLevelData.mName;
        resetConfigPoolLevel(true);
        //jComboBoxNameLevel.setSelectedItem(currentName);
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveLevelActionPerformed

    private void jButtonSaveAsNewLevelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveAsNewLevelActionPerformed
        mLevelData = new LevelData();
        readAllToCurrentLevel();
        mLevelDataPool.putAsNew(mLevelData);
        mLevelDataPool.save();
        mClassSetting++;
        resetConfigPoolLevel(true);
        jComboBoxNameLevel.setSelectedItem(mLevelData.mName);
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveAsNewLevelActionPerformed

    private void jButtonDeleteLevelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteLevelActionPerformed
        readAllToCurrentLevel();
        mLevelDataPool.remove(mLevelData);
        mLevelDataPool.save();
        mClassSetting++;
        resetConfigPoolLevel(true);

        if (jComboBoxNameLevel.getSelectedIndex() == -1)
        {
            clearAllLevel();
        }

        String key = jComboBoxNameLevel.getSelectedItem().toString();
        mLevelData = mLevelDataPool.get(key);
        setAllFromCurrentLevel();

        mClassSetting--;
    }//GEN-LAST:event_jButtonDeleteLevelActionPerformed

    private void jButtonNewLevelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewLevelActionPerformed
        mClassSetting++;
        mLevelData = new LevelData();
        clearAllLevel();
        resetConfigPoolLevel(false);
        mClassSetting--;
    }//GEN-LAST:event_jButtonNewLevelActionPerformed

    private void jButtonSaveAsNewGameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveAsNewGameActionPerformed
        mGameData = new GameData();
        readAllToCurrentGame();
        mGameDataPool.putAsNew(mGameData);
        mGameDataPool.save();
        mClassSetting++;
        resetConfigPoolGame(true);
        jComboBoxNameGame.setSelectedItem(mGameData.mName);
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveAsNewGameActionPerformed

    private void jButtonDeleteGameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDeleteGameActionPerformed
        readAllToCurrentGame();
        mGameDataPool.remove(mGameData);
        mGameDataPool.save();
        mClassSetting++;
        resetConfigPoolGame(true);

        if (jComboBoxNameGame.getSelectedIndex() == -1)
        {
            clearAllGame();
        }

        String key = jComboBoxNameGame.getSelectedItem().toString();
        mGameData = mGameDataPool.get(key);
        setAllFromCurrentGame();
        jButtonCreateNewLevelObject.setEnabled(mLevelObjectDataPool!=null);

        mClassSetting--;
    }//GEN-LAST:event_jButtonDeleteGameActionPerformed

    private void jButtonNewGameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewGameActionPerformed
        mClassSetting++;
        mGameData = new GameData();
        clearAllGame();
        resetConfigPoolGame(false);
        jButtonCreateNewLevelObject.setEnabled(mLevelObjectDataPool!=null);
        mClassSetting--;
    }//GEN-LAST:event_jButtonNewGameActionPerformed

    private void jButtonSaveGameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveGameActionPerformed

        readAllToCurrentGame();
        mGameDataPool.put(mGameData);
        mGameDataPool.save();
        mClassSetting++;
        resetConfigPoolGame(true);
        jComboBoxNameGame.setSelectedItem(mGameData.mName);
        mClassSetting--;
    }//GEN-LAST:event_jButtonSaveGameActionPerformed

    private void jComboBoxNameGameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxNameGameActionPerformed
        if (mClassSetting > 0 ) return;
        String key = jComboBoxNameGame.getSelectedItem().toString();
        mGameData = mGameDataPool.get(key);

        setAllFromCurrentGame();
        mLevelData = new LevelData();
        setAllFromCurrentLevel();

//        clearAllGame();
        resetConfigPoolGame(false);
        setAllFromCurrentGame();
    }//GEN-LAST:event_jComboBoxNameGameActionPerformed

    private void jButtonCreateNewLevelObjectActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCreateNewLevelObjectActionPerformed
        mClassSetting++;
        LevelObjectData mLevelObjectData = new LevelObjectData();
        addLevelObjectPanel(mLevelObjectData);
        mClassSetting--;
    }//GEN-LAST:event_jButtonCreateNewLevelObjectActionPerformed

    private void jComboBoxDefaultActionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxDefaultActionActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jComboBoxDefaultActionActionPerformed

    private void clearAllSprites() /* allneeded*/
    {
        mClassSetting++;
        mSpriteData = new SpriteData();
        setAllFromCurrentSprites();
        clearAllActions();
        mClassSetting--;
    }

    private void setAllFromCurrentSprites() /* allneeded*/
    {
        mClassSetting++;
        jComboBoxActionName.setSelectedItem(mSpriteData.mName);
        jTextFieldSpriteID.setText(mSpriteData.mName);
        
        resetConfigPoolActions(true);
        resetDefaultPoolActions();
        jComboBoxDefaultAction.setSelectedItem(mSpriteData.mDefaultActionID);
        jTextFieldSpriteUID.setText(""+mSpriteData.mspriteUID);

        mClassSetting--;
    }
    
    
    void levelNameEditEnabled()
    {
        boolean enabled = false;
        readAllToCurrentLevel();
        String klasse = getGameName()+"_Levels";
        Collection<ActionNewData> colC = mActionDataPool.getMapForKlasse(klasse).values();

        if (mLevelData.mName == null) enabled = true;
        else
        if (mLevelData.mName.length() == 0) enabled = true;
        else enabled = colC.isEmpty();
        jTextFieldNameGame.setEditable(enabled);
    }
    void spriteNameEditEnabled()
    {
        boolean enabled = false;
        readAllToCurrentSprites();
        String klasse = getSpriteName()+"_Actions";
        Collection<ActionNewData> colC = mActionDataPool.getMapForKlasse(klasse).values();

        if (mSpriteData.mName == null) enabled = true;
        else
        if (mSpriteData.mName.length() == 0) enabled = true;
        else enabled = colC.isEmpty();
        jTextFieldSpriteID.setEditable(enabled);
    }
    String getSpriteName()
    {
 //       readAllToCurrentSprites();
        mSpriteData.mName = jTextFieldSpriteID.getText();
       return mSpriteData.mName;
    }
    String getGameName()
    {
        readAllToCurrentGame();
        return mGameData.mName;
    }
    private void readAllToCurrentSprites() /* allneeded*/
    {
        mSpriteData.mClass = "AllSprites";
        mSpriteData.mName = jTextFieldSpriteID.getText();
        if (jComboBoxDefaultAction.getSelectedItem() != null)
            mSpriteData.mDefaultActionID = jComboBoxDefaultAction.getSelectedItem().toString();
        else
            if (mSpriteData.mDefaultActionID == null) mSpriteData.mDefaultActionID = "";
        mSpriteData.mspriteUID = Int0(jTextFieldSpriteUID.getText());
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private de.malban.vide.veccy.ActionPanel actionPanel1;
    private de.malban.vide.veccy.ActionPanel actionPanel2;
    private de.malban.vide.veccy.BackGroundScenePanel backGroundScenePanel1;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButtonCreateNewLevelObject;
    private javax.swing.JButton jButtonDeleteAction;
    private javax.swing.JButton jButtonDeleteGame;
    private javax.swing.JButton jButtonDeleteLevel;
    private javax.swing.JButton jButtonDeleteSprite;
    private javax.swing.JButton jButtonNewAction;
    private javax.swing.JButton jButtonNewGame;
    private javax.swing.JButton jButtonNewLevel;
    private javax.swing.JButton jButtonNewSprite;
    private javax.swing.JButton jButtonSaveAction;
    private javax.swing.JButton jButtonSaveAsNewAction;
    private javax.swing.JButton jButtonSaveAsNewGame;
    private javax.swing.JButton jButtonSaveAsNewLevel;
    private javax.swing.JButton jButtonSaveAsNewSprite;
    private javax.swing.JButton jButtonSaveGame;
    private javax.swing.JButton jButtonSaveLevel;
    private javax.swing.JButton jButtonSaveSprite;
    private javax.swing.JComboBox jComboBoxActionName;
    private javax.swing.JComboBox<String> jComboBoxDefaultAction;
    private javax.swing.JComboBox jComboBoxNameGame;
    private javax.swing.JComboBox jComboBoxNameLevel;
    private javax.swing.JComboBox jComboBoxSpriteName;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanelLevel;
    private javax.swing.JPanel jPanelLevelObjectPanel;
    private javax.swing.JPanel jPanelSprite;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTextArea jTextArea1;
    private javax.swing.JTextField jTextFieldLevelNumber;
    private javax.swing.JTextField jTextFieldNameGame;
    private javax.swing.JTextField jTextFieldNameLevel;
    private javax.swing.JTextField jTextFieldSpriteID;
    private javax.swing.JTextField jTextFieldSpriteUID;
    // End of variables declaration//GEN-END:variables

    public static void showModPanelNoModal(VeccyPanel v)
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        GamePanel panel = new GamePanel();
        if (v != null)
        {
            v.setGamePanel(panel);
            panel.veccy = v;
        }
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addAsWindow(panel, 1080, 800, "Vector: GamePanel");
    }    

    private void resetConfigPoolLevelObjects() 
    {
        mClassSetting++;
        Collection<String> collectionKlasse = mLevelObjectDataPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        int i = 0;
        String klasse = mLevelData.mName;

        Collection<LevelObjectData> colC = mLevelObjectDataPool.getMapForKlasse(klasse).values();
        Iterator<LevelObjectData> iterC = colC.iterator();

        jPanelLevelObjectPanel.removeAll();
        
        while (iterC.hasNext())
        {
            LevelObjectData item = iterC.next();
            addLevelObjectPanel(item);
        }
        jPanelLevelObjectPanel.invalidate();
        jPanelLevelObjectPanel.revalidate();
        jPanelLevelObjectPanel.repaint();
        mClassSetting--;
    }
    private void addLevelObjectPanel(LevelObjectData item)
    {
        mClassSetting++;
        LevelObjectDataPanel panel = new LevelObjectDataPanel(this, item);
        jPanelLevelObjectPanel.add(panel);
        panel.updateObjectComboBox(item.mType);
        jPanelLevelObjectPanel.invalidate();
        jPanelLevelObjectPanel.revalidate();
        jPanelLevelObjectPanel.repaint();
        mClassSetting--;
    }
    public void saveLevelObject(LevelObjectData lodata)
    {
        lodata.mClass = mLevelData.mName;
        mLevelObjectDataPool.put(lodata);
        mLevelObjectDataPool.save();
        mClassSetting++;
        mClassSetting--;
    }
    public void removeLevelObject(LevelObjectData lodata)
    {
        mLevelObjectDataPool.remove(lodata);
        mLevelObjectDataPool.save();
        mClassSetting++;
        resetConfigPoolLevelObjects();
        mClassSetting--;
    }
    public void setAllLevelObjects()
    {
        if (mLevelObjectDataPool == null)
            mLevelObjectDataPool = new LevelObjectDataPool();
        resetConfigPoolLevelObjects();
    }
    void updateSpriteRefs()
    {
        resetConfigPoolLevelObjects();
    }
    void verifyLevelData(LevelData level)
    {
        String klasse = level.mName;
        Collection<LevelObjectData> colC = mLevelObjectDataPool.getMapForKlasse(klasse).values();
        Iterator<LevelObjectData> iterC = colC.iterator();

        SpriteDataPool localSpriteDataPool = new SpriteDataPool();
        while (iterC.hasNext())
        {
            LevelObjectData o = iterC.next();
            if (o.mType.equals("Sprite"))
            {
                SpriteData sprite = localSpriteDataPool.getMapForKlasse("AllSprites").get(o.mSpriteID);
                if (sprite == null)
                {
                    System.out.println("SpriteID not found: "+o.mSpriteID);
                    mLevelObjectDataPool.remove(o);
                    continue;
                }
                ActionData action = getActionByID(sprite, sprite.mDefaultActionID);
                if (action == null)
                {
                    System.out.println("Sprite has no default action: "+o.mSpriteID);
                    mLevelObjectDataPool.remove(o);
                    continue;
                }
            }
        }
    }
    ActionData getActionByID(SpriteData sprite, String actionID)
    {
        ActionDataPool localActionDataPool = new ActionDataPool();
        Collection<ActionData> colCa = localActionDataPool.getMapForKlasse(sprite.mName+"_Actions").values();
        Iterator<ActionData> iterCa = colCa.iterator();

        while (iterCa.hasNext())
        {
            ActionData actionData = iterCa.next();

            // break in first action, we assume ALL actions of one sprite are player controlled... 
            if (actionData.mName.equals(actionID))
                return actionData;
        }
        return null;
    }
    

// TDODO    
    void copyActionFromSpriteToSprite(String fromName, String toName)
    {
        /*
        Collection<ActionNewData> colFrom = mActionDataPool.getMapForKlasse(fromName+"_Actions").values();
        Iterator<ActionNewData> iterFrom = colFrom.iterator();

        while (iterFrom.hasNext())
        {
            ActionNewData oldActionData = iterFrom.next();
            ActionNewData newActionData = new ActionNewData();
            
            newActionData.mClass = toName+"_Actions";
            newActionData.mName = oldActionData.mName+"_"+toName;

            newActionData. manimationFile= oldActionData.manimationFile;
            newActionData. mchangeWhileActiveX= oldActionData.mchangeWhileActiveX;
            newActionData. mchangeWhileActiveY= oldActionData.mchangeWhileActiveY;
            newActionData. msoundLoop= oldActionData.msoundLoop;
            newActionData. msoundFile= oldActionData.msoundFile;
            newActionData. mbehaviour= oldActionData.mbehaviour;
            newActionData. mboundingBoxOffsetX= oldActionData.mboundingBoxOffsetX;
            newActionData. mtext= oldActionData.mtext;
            newActionData. mtextType= oldActionData.mtextType;
            newActionData. mtextHeight= oldActionData.mtextHeight;
            newActionData. mtextWidth= oldActionData.mtextWidth;
            newActionData. misEnemy= oldActionData.misEnemy;
            newActionData. misPlayerShot = oldActionData.misEnemy;
            newActionData. misEnemyShot= oldActionData.misEnemyShot;
            newActionData. mboundingBoxOffsetY= oldActionData.mboundingBoxOffsetY;

            newActionData.mpositioning = (Vector<Integer>) oldActionData.mpositioning.clone();
            newActionData.mtriggerByCause = (Vector<String>) oldActionData.mtriggerByCause.clone();
            newActionData.mtriggerByTarget = (Vector<String>) oldActionData.mtriggerByTarget.clone();
            newActionData.mtriggerByY = (Vector<Integer>) oldActionData.mtriggerByY.clone();
            newActionData.mtriggerByX = (Vector<Integer>) oldActionData.mtriggerByX.clone();
            newActionData.mtriggerByTicks = (Vector<String>) oldActionData.mtriggerByTicks.clone();
            newActionData.mtriggerBySpriteID = (Vector<String>) oldActionData.mtriggerBySpriteID.clone();
            newActionData.mtriggerByActionID = (Vector<String>) oldActionData.mtriggerByActionID.clone();
            newActionData.mdeltaPerStepX = (Vector<Integer>) oldActionData.mdeltaPerStepX.clone();
            newActionData.mdeltaPerStepY = (Vector<Integer>) oldActionData.mdeltaPerStepY.clone();
            newActionData.mtriggerResultY = (Vector<String>) oldActionData.mtriggerResultY.clone();
            newActionData.mtriggerResultX = (Vector<String>) oldActionData.mtriggerResultX.clone();
            
            for (int i=0;i<newActionData.mtriggerByActionID.size(); i++)
            {
                String oldID = newActionData.mtriggerByActionID.elementAt(i);
                if (oldID.length() >0)
                {
                    String newID = oldID+"_"+toName;
                    newActionData.mtriggerByActionID.setElementAt(newID, i);
                }

            }
            mActionDataPool.put(newActionData);
        }
        mActionDataPool.save();

        SpriteData spriteData = mSpriteDataPool.getMapForKlasse("AllSprites").get(toName);
        spriteData.mDefaultActionID = spriteData.mDefaultActionID+"_"+toName;
        mSpriteDataPool.put(mSpriteData);
        mSpriteDataPool.save();
*/
    }
    
    void convertOldActionToNewAction()
    {
        ActionDataPool oldPool = new ActionDataPool();
        
        
        Collection<String> collectionKlasse = oldPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        while (iterKlasse.hasNext())
        {
            String klasse = iterKlasse.next();
            Collection<ActionData> colC = oldPool.getMapForKlasse(klasse).values();
            Iterator<ActionData> iterC = colC.iterator();
            while (iterC.hasNext())
            {
                ActionData oldAction = iterC.next();
                String key = oldAction.mName;
// if (!oldAction.mClass.startsWith("Main1_Actions") ) continue;
                ActionNewDataPool newPool = mActionDataPool;
                ActionNewData newAction = newPool.get(key);
                if (newAction != null) return;

                // now convert
                newAction = new ActionNewData();
                mActionData.mtextHeight=2;
                mActionData.mtextWidth=50;

                newAction.mClass= oldAction.mClass;
                newAction.mName= oldAction.mName;
                newAction.manimationFile= oldAction.manimationFile;
                newAction.mchangeWhileActiveX= oldAction.mchangeWhileActiveX;
                newAction.mchangeWhileActiveY= oldAction.mchangeWhileActiveY;
                newAction.msoundLoop= oldAction.msoundLoop;
                newAction.msoundFile= oldAction.msoundFile;
                newAction.mbehaviour= oldAction.mbehaviour;

                newAction.mboundingBoxOffsetX= oldAction.mboundingBoxOffsetX;
                newAction.mtext= oldAction.mtext;
                newAction.mtextType= oldAction.mtextType;
                newAction.mtextHeight= oldAction.mtextHeight;
                newAction.mtextWidth= oldAction.mtextWidth;
                newAction.misEnemy= oldAction.misEnemy;
                newAction.mboundingBoxOffsetY= oldAction.mboundingBoxOffsetY;
                newAction.misPlayerShot= oldAction.misPlayerShot;
                newAction.misEnemyShot= oldAction.misEnemyShot;
                newAction.mintensity= oldAction.mintensity;

                newAction.mpositioning= oldAction.mpositioning;

                ActionTriggerDataPool mTriggerPool = new ActionTriggerDataPool();
                ActionResultDataPool mResultPool = new ActionResultDataPool();
                for (int i=0; i<oldAction.mtriggerByCause.size(); i++)
                {
                    String uid = UUID.randomUUID().toString();
                    newAction.meventUID.addElement(uid);
                    newAction.meventName.addElement(""+i);


                    
                    
                    ActionTriggerData triggers = new ActionTriggerData();
                    triggers.mtriggerByCause = new Vector<String>();
                    triggers.mtriggerBySpriteID = new Vector<String>();
                    triggers.mtriggerByY = new Vector<Integer>();
                    triggers.mtriggerByX = new Vector<Integer>();
                    triggers.mtriggerByTicks = new Vector<String>();

                    triggers.mtriggerByCause.addElement(oldAction.mtriggerByCause.elementAt(i));
                    triggers.mtriggerBySpriteID.addElement(oldAction.mtriggerBySpriteID.elementAt(i));
                    triggers.mtriggerByY.addElement(oldAction.mtriggerByY.elementAt(i));
                    triggers.mtriggerByX.addElement(oldAction.mtriggerByX.elementAt(i));
                    triggers.mtriggerByTicks.addElement(oldAction.mtriggerByTicks.elementAt(i));

                    triggers.mClass = uid;
                    triggers.mName = uid;
String triggerName = "";
if (triggers.mtriggerByCause.size()>0) triggerName +=triggers.mtriggerByCause.elementAt(0);
if (triggers.mtriggerBySpriteID.size()>0) if (triggers.mtriggerBySpriteID.elementAt(0).trim().length()>0) triggerName +=" "+triggers.mtriggerBySpriteID.elementAt(0);
if (triggers.mtriggerByY.size()>0) if (triggers.mtriggerByY.elementAt(0)!=0) triggerName +=" Y:"+triggers.mtriggerByY.elementAt(0);
if (triggers.mtriggerByX.size()>0) if (triggers.mtriggerByX.elementAt(0)!=0) triggerName +=" X:"+triggers.mtriggerByX.elementAt(0);
if (triggers.mtriggerByTicks.size()>0) if ((triggers.mtriggerByTicks.elementAt(0).trim().length()>0) && ((!triggers.mtriggerByTicks.elementAt(0).trim().startsWith("0")))) triggerName +=" Ticks:"+triggers.mtriggerByTicks.elementAt(0);
                    newAction.mtriggerName.addElement(""+i+"." +triggerName);




                    ActionResultData results = new ActionResultData();
                    results.mresultType = new Vector<String>();
                    results.mresultActionID = new Vector<String>();
                    results.mresultSpriteID = new Vector<String>();
                    results.mresultY = new Vector<String>();
                    results.mresultX = new Vector<String>();

                    results.mresultType.addElement(oldAction.mtriggerByTarget.elementAt(i));
                    results.mresultActionID.addElement(oldAction.mtriggerByActionID.elementAt(i));
                    results.mresultSpriteID.addElement(oldAction.mtriggerBySpriteID.elementAt(i));
                    results.mresultY .addElement(oldAction.mtriggerResultY.elementAt(i));
                    results.mresultX.addElement(oldAction.mtriggerResultX.elementAt(i));
                    results.mClass = uid;
                    results.mName = uid;
String resultName = "";
if (results.mresultType.size()>0) resultName +=results.mresultType.elementAt(0);
if (results.mresultActionID.size()>0) if (results.mresultActionID.elementAt(0).trim().length()>0) resultName +=" "+results.mresultActionID.elementAt(0);
if (results.mresultSpriteID.size()>0) if (results.mresultSpriteID.elementAt(0).trim().length()>0) resultName+=" Sprite:"+results.mresultSpriteID.elementAt(0);
if (results.mresultY.size()>0)        if ((results.mresultY.elementAt(0).trim().length()>0) && (!results.mresultY.elementAt(0).trim().startsWith("0"))) resultName +=" Y:"+results.mresultY.elementAt(0);
if (results.mresultX.size()>0)        if ((results.mresultX.elementAt(0).trim().length()>0) && (!results.mresultX.elementAt(0).trim().startsWith("0"))) resultName +=" X:"+results.mresultX.elementAt(0);
                    newAction.mresultName.addElement(""+i+"." +resultName);

                    mTriggerPool.put(triggers);
                    mResultPool.put(results);
                }
                mTriggerPool.save();
                mResultPool.save();

                mActionDataPool.put(newAction);
                mActionDataPool.save();

            }        
        }
    }
}
