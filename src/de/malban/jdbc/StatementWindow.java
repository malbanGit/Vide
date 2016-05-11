/*
 * StatementWindow.java
 *
 * Created on 26. März 2008, 12:51
 */

package de.malban.jdbc;

import de.malban.gui.CSAMainFrame;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InputDialog;
import de.malban.gui.dialogs.ShowErrorDialog;
import de.malban.jdbc.DBConnectionData;
import java.util.*;
import javax.swing.*;
import javax.swing.table.*;
import java.awt.event.* ;
import java.io.* ;
import de.malban.util.ExcelHelper;

/** GUI Class for all Statement manipulations an Execution.
 *
 * for 1.5 compatibilty add:
        jTableResult = new javax.swing.JTable()
				{        
					public boolean getScrollableTracksViewportHeight() {
    			// fetch the table's parent
    			Container viewport = getParent();

    			// if the parent is not a viewport, calling this isn't useful
    			if (!(viewport instanceof JViewport)) {
        		return false;
    			}

    			// return true if the table's preferred height is smaller
    			// than the viewport height, else false
    			return getPreferredSize().height < viewport.getHeight();
			 }};        
 */
public class StatementWindow extends javax.swing.JPanel implements
        Windowable {
    private UserSQLStatementPool mStatementPool;
    private DBConnectionDataPool mConnectionPool;
//    private java.awt.Frame mParent;
    private Object mLastPopUp=null;
    private int mInComboAdd = 0;
    private int mInDBAdd = 0;
    private int mClassSetting = 0;

    JavaSQLResult mOraResult = null;

    HashMap mVComments = new HashMap(); 
    HashMap mSComments = new HashMap(); 
    
    UserSQLStatement mCurrentStatement = new UserSQLStatement();

    private CSAView mParentView = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    de.malban.config.Logable D;
    
    @Override
    public void closing()
    {
    }
    @Override
    public void setParentWindow(CSAView jpv)
    {
        mParentView = jpv;
    }
    @Override
    public void setMenuItem(javax.swing.JMenuItem item)
    {
        mParentMenuItem = item;
        mParentMenuItem.setText("SQL Statement");
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
    
    /** Creates new form StatementWindow */
    public StatementWindow() 
    {
        initComponents();
        mStatementPool = PoolFactory.POOL.getStatementPool();
        mConnectionPool = PoolFactory.POOL.getConnectionPool();

        Collection<String> colC = mStatementPool.getClasses().values();
        Iterator<String> iterC = colC.iterator();
        int i = 0;
        mClassSetting++;
        while (iterC.hasNext())
        {
            String item = (String) iterC.next();
            jComboBoxKlasse.addItem(item);
            if (i==0)
            {
                jComboBoxKlasse.setSelectedIndex(0);
            }
            i++;
        }
        resetStatementPool(null,null);
        mClassSetting--;

        jTableResult.addMouseMotionListener(new MouseMotionListener() { 
            public void mouseDragged(MouseEvent e) { 
                e.consume(); 
                JComponent c = (JComponent) e.getSource(); 
                TransferHandler handler = c.getTransferHandler(); 
                handler.exportAsDrag(c, e, TransferHandler.MOVE); 
            } 
           public void mouseMoved(MouseEvent e) { 
           } 
        }); 

        jTableResult.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {},
            new String [] {}
        ));        
        // not 1.5 compatible jTableResult.setFillsViewportHeight(true);

        jComboBoxSt1.setVisible(false);
        jComboBoxSt2.setVisible(false);
        jComboBoxSt3.setVisible(false);
        jComboBoxSt4.setVisible(false);
        jComboBoxSt5.setVisible(false);
        jComboBoxSt6.setVisible(false);
        jLabelSt1.setVisible(false);
        jLabelSt2.setVisible(false);
        jLabelSt2.setVisible(false);
        jLabelSt3.setVisible(false);
        jLabelSt4.setVisible(false);
        jLabelSt5.setVisible(false);
        jLabelSt6.setVisible(false);
        jLabelStatements.setVisible(false);
        setVisible(true);
   }

/** More or less reset the whole window with new Data.<BR>
 * if stName is null - the first statement that is found in the current class (combobox respectively) found<BR>
 * if class is set only classes get reloaded<BR>
 * if not class is taken from combobox<BR>
 * @param stName
 * @param stClass
 */
    public void resetStatementPool(String stName, String stClass)
    {
        
        Collection<UserSQLStatement> col;
        if (stClass == null)
        {
            col = mStatementPool.getClassStatements((String)jComboBoxKlasse.getSelectedItem()).values();
        }
        else
        {
            mClassSetting++;
            jComboBoxKlasse.setSelectedItem(stClass);
            col = mStatementPool.getClassStatements(stClass).values();
            mClassSetting--;
        }
        Iterator<UserSQLStatement> iter = col.iterator();
        int i = 0;
        jMenuExecuteNew.removeAll();
        jMenuExecuteHere.removeAll();
        mInComboAdd++;

        jComboBoxStatement.removeAllItems();
        while (iter.hasNext())
        {
            UserSQLStatement item = (UserSQLStatement) iter.next();
            jComboBoxStatement.addItem(item);

            if ((i==0) && (stName == null))
            {
                jComboBoxStatement.setSelectedIndex(i);
                mCurrentStatement = (UserSQLStatement) item;
            }
            if (stName != null)
            {
                if (stName.equals(item.mName))
                {
                    jComboBoxStatement.setSelectedIndex(i);
                    mCurrentStatement = (UserSQLStatement) item;
                }
            }
            i++;
        }
        mInComboAdd--;

        Collection<String> colC = mStatementPool.getClasses().values();
        Iterator<String> iterC = colC.iterator();
        i = 0;
        
        while (iterC.hasNext())
        {
            String item = (String) iterC.next();
            col = mStatementPool.getClassStatements(item).values();
            iter = col.iterator();

            JMenu menuHere = new JMenu();
            menuHere.setText(item);
            jMenuExecuteHere.add(menuHere);            

            JMenu menuNew = new JMenu();
            menuNew.setText(item);
            jMenuExecuteNew.add(menuNew);            

            while (iter.hasNext())
            {
                UserSQLStatement itemST = (UserSQLStatement) iter.next();
            
                 JMenuItem menuItem2 = new JMenuItem();
                 menuItem2.setText(itemST.mName);
                 menuItem2.setActionCommand("Here");
                 menuItem2.addActionListener(new java.awt.event.ActionListener() {
                    public void actionPerformed(java.awt.event.ActionEvent evt) {
                        jMenuItemExecuteHereActionPerformed(evt);
                    }
                });
                menuHere.add(menuItem2);

                 JMenuItem menuItem = new JMenuItem();
                 menuItem.setText(itemST.mName);
                 menuItem.setActionCommand("New");
                 menuItem.addActionListener(new java.awt.event.ActionListener() {
                    public void actionPerformed(java.awt.event.ActionEvent evt) {
                        jMenuItemExecuteNewActionPerformed(evt);
                    }
                });
                menuNew.add(menuItem);
            }
            i++;
        }
        
        setCommentsFormST(mCurrentStatement);
        setStatementToFields(mCurrentStatement);
    }

    /**
     * I think this is depricated...
     * @param st
     */
    public void setStatement(UserSQLStatement st)
    {
        mCurrentStatement = st;
        setCommentsFormST(mCurrentStatement);
        setStatementToFields(mCurrentStatement);
    }

    /** Used if on a table a data is executed with another Query...
     *  
     * 
     * @param var
     */
    public void setVar1(String var)
    {
        jTextFieldVar1.setText(var);
        mCurrentStatement.setVar(0, var, (String) mVComments.get(0));
        statementChecker();
    }

    public void executeStatement()
    {
        jButton1ActionPerformed(null);
    }
    
   private void jMenuItemExecuteHereActionPerformed(java.awt.event.ActionEvent evt) 
   {
       JMenuItem menuItem = (JMenuItem) evt.getSource();
       UserSQLStatement st = (UserSQLStatement) mStatementPool.get(menuItem.getText());
       resetStatementPool(st.mName, st.mKlasse);
       setVar1(mLastObject.mData);
       executeStatement();
   }
   private void jMenuItemExecuteNewActionPerformed(java.awt.event.ActionEvent evt) 
   {
       JMenuItem menuItem = (JMenuItem) evt.getSource();

        StatementWindow stw = new StatementWindow();
        ((CSAMainFrame)mParentView).addPanel(stw);
        ((CSAMainFrame)mParentView).setMainPanel(stw);
       
       UserSQLStatement st = (UserSQLStatement) mStatementPool.get(menuItem.getText());
       stw.resetStatementPool(st.mName, st.mKlasse);
       stw.setVar1(mLastObject.mData);
       stw.executeStatement();
   }
   
   private void setCommentsFormST(UserSQLStatement st)
   {
        mVComments.clear();
        
        for (int i=0; i<st.getVarNumberStatement(); i++)
        {
            mVComments.put(i, st.getVarComment(i));
        }

        for (int i=0; i<st.getVarNumberStatement();i++)
        {
            switch (i)
            {
                    case 0:
                    {
                        jTextFieldVar1.setToolTipText(st.getVarComment(i));
                        break;
                    }
                    case 1:
                    {
                        jTextFieldVar2.setToolTipText(st.getVarComment(i));
                        break;
                    }
                    case 2:
                    {
                        jTextFieldVar3.setToolTipText(st.getVarComment(i));
                        break;
                    }
                    case 3:
                    {
                        jTextFieldVar4.setToolTipText(st.getVarComment(i));
                        break;
                    }
                    case 4:
                    {
                        jTextFieldVar6.setToolTipText(st.getVarComment(i));
                        break;
                    }
                    case 5:
                    {
                        jTextFieldVar5.setToolTipText(st.getVarComment(i));
                        break;
                    }
            }
        }
   }
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPopupMenu1 = new javax.swing.JPopupMenu();
        jMenuItemAddComment = new javax.swing.JMenuItem();
        jPopupMenu2 = new javax.swing.JPopupMenu();
        jMenuItemExport = new javax.swing.JMenuItem();
        jPopupMenu3 = new javax.swing.JPopupMenu();
        jMenuExecuteNew = new javax.swing.JMenu();
        jMenuExecuteHere = new javax.swing.JMenu();
        jMenuItemExportTable = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JSeparator();
        jMenuItemHideColumn = new javax.swing.JMenuItem();
        jMenuItem1 = new javax.swing.JMenuItem();
        jComboBoxStatement = new javax.swing.JComboBox();
        jLabelStatementName = new javax.swing.JLabel();
        jLabelName = new javax.swing.JLabel();
        jTextFieldNAme = new javax.swing.JTextField();
        jLabelDescribtion = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTextAreaDescribtion = new javax.swing.JTextArea();
        jLabelStatement = new javax.swing.JLabel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTextAreaStatement = new javax.swing.JTextArea();
        jLabelNoVars = new javax.swing.JLabel();
        jTextFieldNoVars = new javax.swing.JTextField();
        jLabelVariables = new javax.swing.JLabel();
        jLabelVar1 = new javax.swing.JLabel();
        jTextFieldVar1 = new javax.swing.JTextField();
        jLabelVar2 = new javax.swing.JLabel();
        jTextFieldVar2 = new javax.swing.JTextField();
        jLabelVar3 = new javax.swing.JLabel();
        jTextFieldVar3 = new javax.swing.JTextField();
        jLabelVar4 = new javax.swing.JLabel();
        jTextFieldVar4 = new javax.swing.JTextField();
        jTextFieldVar6 = new javax.swing.JTextField();
        jLabelVar5 = new javax.swing.JLabel();
        jLabelVar6 = new javax.swing.JLabel();
        jTextFieldVar5 = new javax.swing.JTextField();
        jLabelStatements = new javax.swing.JLabel();
        jLabelSt5 = new javax.swing.JLabel();
        jLabelSt6 = new javax.swing.JLabel();
        jLabelSt3 = new javax.swing.JLabel();
        jLabelSt4 = new javax.swing.JLabel();
        jLabelSt1 = new javax.swing.JLabel();
        jLabelSt2 = new javax.swing.JLabel();
        jComboBoxSt1 = new javax.swing.JComboBox();
        jComboBoxSt3 = new javax.swing.JComboBox();
        jComboBoxSt5 = new javax.swing.JComboBox();
        jComboBoxSt2 = new javax.swing.JComboBox();
        jComboBoxSt4 = new javax.swing.JComboBox();
        jComboBoxSt6 = new javax.swing.JComboBox();
        jButton1 = new javax.swing.JButton();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTableResult = new javax.swing.JTable();
        jLabelDBConnection = new javax.swing.JLabel();
        jComboBoxDBConnection = new javax.swing.JComboBox();
        jButtonNew = new javax.swing.JButton();
        jButtonSave = new javax.swing.JButton();
        jLabelTableSize = new javax.swing.JLabel();
        jLabelKlasse = new javax.swing.JLabel();
        jTextFieldKlasse = new javax.swing.JTextField();
        jComboBoxKlasse = new javax.swing.JComboBox();
        jLabelKlasse1 = new javax.swing.JLabel();
        jCheckBox1 = new javax.swing.JCheckBox();
        jButton2 = new javax.swing.JButton();

        jMenuItemAddComment.setLabel("Add Comment"); // NOI18N
        jMenuItemAddComment.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemAddCommentActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemAddComment);

        jMenuItemExport.setText("Export LOB");
        jMenuItemExport.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemExportActionPerformed(evt);
            }
        });
        jPopupMenu2.add(jMenuItemExport);

        jMenuExecuteNew.setText("Execute New");
        jPopupMenu3.add(jMenuExecuteNew);

        jMenuExecuteHere.setText("Execute Here");
        jPopupMenu3.add(jMenuExecuteHere);

        jMenuItemExportTable.setText("Export as CSV");
        jMenuItemExportTable.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemExportTableActionPerformed(evt);
            }
        });
        jPopupMenu3.add(jMenuItemExportTable);
        jPopupMenu3.add(jSeparator1);

        jMenuItemHideColumn.setText("Hide Column");
        jMenuItemHideColumn.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemHideColumnActionPerformed(evt);
            }
        });
        jPopupMenu3.add(jMenuItemHideColumn);

        jMenuItem1.setText("To Excel");
        jMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1ActionPerformed(evt);
            }
        });
        jPopupMenu3.add(jMenuItem1);

        jComboBoxStatement.setPreferredSize(new java.awt.Dimension(160, 20));
        jComboBoxStatement.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxStatementActionPerformed(evt);
            }
        });

        jLabelStatementName.setText("Statement"); // NOI18N

        jLabelName.setText("Name"); // NOI18N

        jTextFieldNAme.setColumns(20);

        jLabelDescribtion.setText("Describtion"); // NOI18N

        jTextAreaDescribtion.setColumns(20);
        jTextAreaDescribtion.setRows(5);
        jScrollPane1.setViewportView(jTextAreaDescribtion);

        jLabelStatement.setText("Statement"); // NOI18N

        jTextAreaStatement.setColumns(20);
        jTextAreaStatement.setRows(5);
        jTextAreaStatement.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextAreaStatementFocusLost(evt);
            }
        });
        jScrollPane2.setViewportView(jTextAreaStatement);

        jLabelNoVars.setText("# Vars: "); // NOI18N

        jTextFieldNoVars.setEditable(false);
        jTextFieldNoVars.setColumns(2);
        jTextFieldNoVars.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldNoVarsActionPerformed(evt);
            }
        });

        jLabelVariables.setText("Variables"); // NOI18N

        jLabelVar1.setText("1:"); // NOI18N

        jTextFieldVar1.setColumns(20);
        jTextFieldVar1.setName("v1"); // NOI18N
        jTextFieldVar1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextFieldVar1MouseClicked(evt);
            }
        });
        jTextFieldVar1.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldVar1FocusLost(evt);
            }
        });

        jLabelVar2.setText("2:"); // NOI18N

        jTextFieldVar2.setColumns(20);
        jTextFieldVar2.setName("v2"); // NOI18N
        jTextFieldVar2.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextFieldVar2MouseClicked(evt);
            }
        });
        jTextFieldVar2.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldVar2FocusLost(evt);
            }
        });

        jLabelVar3.setText("3:"); // NOI18N

        jTextFieldVar3.setColumns(20);
        jTextFieldVar3.setName("v3"); // NOI18N
        jTextFieldVar3.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextFieldVar3MouseClicked(evt);
            }
        });
        jTextFieldVar3.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldVar3FocusLost(evt);
            }
        });

        jLabelVar4.setText("4:"); // NOI18N

        jTextFieldVar4.setColumns(20);
        jTextFieldVar4.setName("v4"); // NOI18N
        jTextFieldVar4.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextFieldVar4MouseClicked(evt);
            }
        });
        jTextFieldVar4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldVar4ActionPerformed(evt);
            }
        });
        jTextFieldVar4.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldVar4FocusLost(evt);
            }
        });

        jTextFieldVar6.setColumns(20);
        jTextFieldVar6.setName("v6"); // NOI18N
        jTextFieldVar6.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextFieldVar6MouseClicked(evt);
            }
        });
        jTextFieldVar6.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldVar6FocusLost(evt);
            }
        });

        jLabelVar5.setText("6:"); // NOI18N

        jLabelVar6.setText("5:"); // NOI18N

        jTextFieldVar5.setColumns(20);
        jTextFieldVar5.setName("v5"); // NOI18N
        jTextFieldVar5.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextFieldVar5MouseClicked(evt);
            }
        });
        jTextFieldVar5.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldVar5FocusLost(evt);
            }
        });

        jLabelStatements.setText("Statements"); // NOI18N

        jLabelSt5.setText("5:"); // NOI18N

        jLabelSt6.setText("6:"); // NOI18N

        jLabelSt3.setText("3:"); // NOI18N

        jLabelSt4.setText("4:"); // NOI18N

        jLabelSt1.setText("1:"); // NOI18N

        jLabelSt2.setText("2:"); // NOI18N

        jComboBoxSt1.setMinimumSize(new java.awt.Dimension(80, 18));
        jComboBoxSt1.setName("s1"); // NOI18N
        jComboBoxSt1.setPreferredSize(new java.awt.Dimension(120, 20));

        jComboBoxSt3.setName("s3"); // NOI18N
        jComboBoxSt3.setPreferredSize(new java.awt.Dimension(120, 20));

        jComboBoxSt5.setName("s5"); // NOI18N
        jComboBoxSt5.setPreferredSize(new java.awt.Dimension(120, 20));

        jComboBoxSt2.setName("s2"); // NOI18N
        jComboBoxSt2.setPreferredSize(new java.awt.Dimension(120, 20));
        jComboBoxSt2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxSt2ActionPerformed(evt);
            }
        });

        jComboBoxSt4.setName("s4"); // NOI18N
        jComboBoxSt4.setPreferredSize(new java.awt.Dimension(120, 20));

        jComboBoxSt6.setName("s6"); // NOI18N
        jComboBoxSt6.setPreferredSize(new java.awt.Dimension(120, 20));

        jButton1.setText("Query"); // NOI18N
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jScrollPane3.setPreferredSize(new java.awt.Dimension(452, 200));

        jTableResult.setAutoCreateRowSorter(true);
        jTableResult.setModel(new javax.swing.table.DefaultTableModel(
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
        jTableResult.setCellSelectionEnabled(true);
        jTableResult.setDragEnabled(true);
        jTableResult.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTableResultMouseClicked(evt);
            }
        });
        jScrollPane3.setViewportView(jTableResult);

        jLabelDBConnection.setText("DBConnection"); // NOI18N
        jLabelDBConnection.setToolTipText(" ");

        jComboBoxDBConnection.setPreferredSize(new java.awt.Dimension(160, 20));
        jComboBoxDBConnection.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxDBConnectionActionPerformed(evt);
            }
        });

        jButtonNew.setText("Neu"); // NOI18N
        jButtonNew.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewActionPerformed(evt);
            }
        });

        jButtonSave.setText("Accept"); // NOI18N
        jButtonSave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveActionPerformed(evt);
            }
        });

        jLabelTableSize.setText("Size:");

        jLabelKlasse.setText("Klasse");

        jTextFieldKlasse.setPreferredSize(new java.awt.Dimension(160, 20));

        jComboBoxKlasse.setPreferredSize(new java.awt.Dimension(160, 20));
        jComboBoxKlasse.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxKlasseActionPerformed(evt);
            }
        });

        jLabelKlasse1.setText("Klasse");

        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jButton2.setText("Update"); // NOI18N
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jCheckBox1)
                                .addComponent(jLabelTableSize))
                            .addComponent(jButton2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButton1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jLabelVar3)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabelVar6, javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                        .addComponent(jLabelVariables)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jTextFieldNoVars, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addComponent(jLabelStatementName)
                                    .addComponent(jLabelKlasse))
                                .addComponent(jLabelVar1)
                                .addComponent(jLabelNoVars))
                            .addComponent(jLabelKlasse1)
                            .addComponent(jLabelName)
                            .addComponent(jLabelDescribtion)
                            .addComponent(jLabelStatement))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jScrollPane2)
                            .addComponent(jScrollPane1)
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                    .addComponent(jTextFieldNAme, javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldKlasse, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(jComboBoxKlasse, javax.swing.GroupLayout.Alignment.LEADING, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(jComboBoxStatement, javax.swing.GroupLayout.Alignment.LEADING, 0, 392, Short.MAX_VALUE))
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButtonNew)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButtonSave))
                                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                                        .addGap(20, 20, 20)
                                        .addComponent(jLabelDBConnection)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jComboBoxDBConnection, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldVar1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextFieldVar3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextFieldVar5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabelVar2)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jTextFieldVar2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabelVar5)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jTextFieldVar6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabelVar4)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jTextFieldVar4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addGap(4, 4, 4)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(layout.createSequentialGroup()
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addGroup(layout.createSequentialGroup()
                                                .addComponent(jLabelSt1)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jComboBoxSt1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                            .addGroup(layout.createSequentialGroup()
                                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                                    .addComponent(jLabelSt5)
                                                    .addComponent(jLabelSt3))
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                                    .addComponent(jComboBoxSt5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                    .addComponent(jComboBoxSt3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jLabelSt2)
                                            .addComponent(jLabelSt4)
                                            .addComponent(jLabelSt6))
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jComboBoxSt6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jComboBoxSt4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jComboBoxSt2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addComponent(jLabelStatements))))))
                .addGap(0, 0, 0))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabelKlasse)
                    .addComponent(jComboBoxKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabelStatementName)
                    .addComponent(jComboBoxStatement, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonNew)
                    .addComponent(jButtonSave))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabelKlasse1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabelName)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabelDescribtion)
                        .addGap(67, 67, 67)
                        .addComponent(jLabelStatement)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabelNoVars))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jTextFieldKlasse, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldNAme, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabelDBConnection)
                            .addComponent(jComboBoxDBConnection, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(15, 15, 15)
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabelStatements)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTextFieldNoVars, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabelVariables)))
                .addGap(5, 5, 5)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jComboBoxSt1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabelSt1)
                            .addComponent(jTextFieldVar2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabelVar2)
                            .addComponent(jLabelSt2)
                            .addComponent(jComboBoxSt2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldVar1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabelVar1))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jComboBoxSt3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabelSt3)
                            .addComponent(jTextFieldVar4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabelVar4)
                            .addComponent(jLabelSt4)
                            .addComponent(jComboBoxSt4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldVar3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabelVar3)))
                    .addGroup(layout.createSequentialGroup()
                        .addGap(52, 52, 52)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabelSt5)
                            .addComponent(jComboBoxSt5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldVar6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabelVar5)
                            .addComponent(jLabelSt6)
                            .addComponent(jComboBoxSt6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldVar5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabelVar6))))
                .addGap(24, 24, 24)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jButton1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabelTableSize)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox1)
                        .addContainerGap())
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 131, Short.MAX_VALUE)))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jMenuItemAddCommentActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemAddCommentActionPerformed
        //String inputValue = JOptionPane.showInputDialog("Enter comment:"); 
        
        String inputValue = InputDialog.showInputDialog("Enter comment:");
        JMenuItem item = (JMenuItem)evt.getSource();
        
        JPopupMenu pMenu = (JPopupMenu) item.getParent();
        JTextField textField = (JTextField) pMenu.getInvoker();
        String name = textField.getName();

        textField.setToolTipText(inputValue);
        if (name.indexOf("v")!=-1)
        {
            // Variable
            int index = Integer.parseInt(name.substring(1));
            System.out.print("Index Var: "+index);
            mVComments.put(index-1, inputValue);
        }
        
       
    }//GEN-LAST:event_jMenuItemAddCommentActionPerformed

    private void jTextFieldVar1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextFieldVar1MouseClicked
        if (evt.getButton() == java.awt.event.MouseEvent.BUTTON3)
        {
            mLastPopUp = evt.getComponent();
            jPopupMenu1.show(evt.getComponent(), evt.getX(), evt.getY());
        }
        
    }//GEN-LAST:event_jTextFieldVar1MouseClicked

    private void jTextFieldVar3MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextFieldVar3MouseClicked
        if (evt.getButton() == java.awt.event.MouseEvent.BUTTON3)
        {
            mLastPopUp = evt.getComponent();
            jPopupMenu1.show(evt.getComponent(), evt.getX(), evt.getY());
        }
       
    }//GEN-LAST:event_jTextFieldVar3MouseClicked

    private void jTextFieldVar5MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextFieldVar5MouseClicked
        if (evt.getButton() == java.awt.event.MouseEvent.BUTTON3)
        {
            mLastPopUp = evt.getComponent();
            jPopupMenu1.show(evt.getComponent(), evt.getX(), evt.getY());
        }
        
}//GEN-LAST:event_jTextFieldVar5MouseClicked

    private void jTextFieldVar2MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextFieldVar2MouseClicked
        if (evt.getButton() == java.awt.event.MouseEvent.BUTTON3)
        {
            mLastPopUp = evt.getComponent();
            jPopupMenu1.show(evt.getComponent(), evt.getX(), evt.getY());
        }
        
    }//GEN-LAST:event_jTextFieldVar2MouseClicked

    private void jTextFieldVar4MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextFieldVar4MouseClicked
        if (evt.getButton() == java.awt.event.MouseEvent.BUTTON3)
        {
            mLastPopUp = evt.getComponent();
            jPopupMenu1.show(evt.getComponent(), evt.getX(), evt.getY());
        }
       
    }//GEN-LAST:event_jTextFieldVar4MouseClicked

    private void jTextFieldVar6MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextFieldVar6MouseClicked
        if (evt.getButton() == java.awt.event.MouseEvent.BUTTON3)
        {
            mLastPopUp = evt.getComponent();
            jPopupMenu1.show(evt.getComponent(), evt.getX(), evt.getY());
        }
        
}//GEN-LAST:event_jTextFieldVar6MouseClicked

    private void jTextFieldNoVarsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldNoVarsActionPerformed
        
    }//GEN-LAST:event_jTextFieldNoVarsActionPerformed

    public void saveTextFieldcontent()
    {
        for (int i=0; i<mCurrentStatement.getVarNumberStatement(); i++)
        {
            switch (i)
            {
                case 0:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar1.getText(), (String) mVComments.get(i));
                    break;
                }
                case 1:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar2.getText(), (String) mVComments.get(i));
                    break;
                }
                case 2:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar3.getText(), mVComments.get(i).toString());
                    break;
                }
                case 3:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar4.getText(), mVComments.get(i).toString());
                    break;
                }
                case 4:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar6.getText(), mVComments.get(i).toString());
                    break;
                }
                case 5:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar5.getText(), mVComments.get(i).toString());
                    break;
                }
            }
        }

        mStatementPool.put(mCurrentStatement);
    }
    private void reReadAllFromGui()
    {
        mCurrentStatement.mDBConnection =  new String();
        if (jComboBoxDBConnection.getSelectedItem() != null)
        {
            mCurrentStatement.mDBConnection =  ((DBConnectionData)jComboBoxDBConnection.getSelectedItem()).toString();
        }
        UserSQLStatement newST = null;
        try
        {
            newST = (UserSQLStatement) mCurrentStatement.clone();
        }
        catch (Throwable e){}
        mCurrentStatement = newST;
        mCurrentStatement.mKlasse = jTextFieldKlasse.getText();
        mCurrentStatement.mName = jTextFieldNAme.getText();
        mCurrentStatement.mDescribtion = jTextAreaDescribtion.getText();
        mCurrentStatement.mStatement = jTextAreaStatement.getText();
        mCurrentStatement.clearVars();
    
        for (int i=0; i<mCurrentStatement.getVarNumberStatement(); i++)
        {
            switch (i)
            {
                case 0:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar1.getText(), (String) mVComments.get(i));
                    break;
                }
                case 1:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar2.getText(), (String) mVComments.get(i));
                    break;
                }
                case 2:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar3.getText(), mVComments.get(i).toString());
                    break;
                }
                case 3:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar4.getText(), mVComments.get(i).toString());
                    break;
                }
                case 4:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar6.getText(), mVComments.get(i).toString());
                    break;
                }
                case 5:
                {
                    mCurrentStatement.setVar(i, jTextFieldVar5.getText(), mVComments.get(i).toString());
                    break;
                }
            }
        }
    }
    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed
        
        reReadAllFromGui();
        mStatementPool.put(mCurrentStatement);
        /*
        mMain.mUserSQLStatement.put(mCurrentStatement.mName, mCurrentStatement);//GEN-LAST:event_jButtonSaveActionPerformed
        */
        
        mStatementPool.save();
        String currentName = mCurrentStatement.mName;
        
        String currentSelectedClass = (String) jComboBoxKlasse.getSelectedItem();
        String currentNewKlass = jTextFieldKlasse.getText();
        if (!jTextFieldKlasse.getText().equals(currentSelectedClass))
        {
            mClassSetting++;
            jComboBoxKlasse.removeAllItems();
            Collection<String> colC = mStatementPool.getClasses().values();
            Iterator<String> iterC = colC.iterator();
            int i = 0;
            while (iterC.hasNext())
            {
                String item = (String) iterC.next();
                jComboBoxKlasse.addItem(item);
                if (item.equals(currentNewKlass))
                {
                    jComboBoxKlasse.setSelectedIndex(i);
                }
                i++;
            }
            resetStatementPool(currentName,null);
            mClassSetting--;
        }
        
        Collection<UserSQLStatement> col = mStatementPool.getClassStatements((String)jComboBoxKlasse.getSelectedItem()).values();
        Iterator<UserSQLStatement> iter = col.iterator();
        
        // int selected = jComboBoxStatement.getSelectedIndex();
        mInComboAdd++;
        jComboBoxStatement.removeAllItems();
        jMenuExecuteNew.removeAll();
        jMenuExecuteHere.removeAll();
        while (iter.hasNext())
        {
            UserSQLStatement item = (UserSQLStatement) iter.next();
            jComboBoxStatement.addItem(item);
             JMenuItem menuItem = new JMenuItem();
             menuItem.setText(item.mName);
             menuItem.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    jMenuItemExecuteNewActionPerformed(evt);
                }
            });
            jMenuExecuteNew.add(menuItem);

            JMenuItem menuItem2 = new JMenuItem();
             menuItem2.setText(item.mName);
             menuItem2.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    jMenuItemExecuteHereActionPerformed(evt);
                }
            });
            jMenuExecuteHere.add(menuItem2);
        }
        iter = col.iterator();
        int i = 0;
        while (iter.hasNext())
        {
            UserSQLStatement item = (UserSQLStatement) iter.next();

            if (mCurrentStatement.mName.equals(item.mName) )
            {
                jComboBoxStatement.setSelectedIndex(i);
                mCurrentStatement = item;
            }
            i++;
        }
        mInComboAdd--;
        jComboBoxDBConnection.setSelectedItem( mCurrentStatement.mDBConnection);
    }                                           

    private void setStatementToFields(UserSQLStatement st)
    {
        UserSQLStatement s = mStatementPool.get(st.mName);

        if (s != null)
        {
            mInComboAdd++;
            jComboBoxStatement.setSelectedItem(s);
            mInComboAdd--;
        }
        
        Collection col = mConnectionPool.getHashMap().values();
        Iterator iter = col.iterator();
        int i = 0;
        mInDBAdd++;
        jComboBoxDBConnection.removeAllItems();
        while (iter.hasNext())
        {
            Object item = iter.next();
            jComboBoxDBConnection.addItem(item);
            i++;
        }
        mInDBAdd--;
        DBConnectionData object = mConnectionPool.get(st.mDBConnection);
        jComboBoxDBConnection.setSelectedItem(object);
	jTextAreaStatement.setText(st.mStatement); 

        jTextAreaDescribtion.setText(st.mDescribtion); 
        jTextFieldNAme.setText(st.mName);
        jTextFieldKlasse.setText(st.mKlasse);
        
        statementChecker();

        if (mOraResult!=null)
        {
            mOraResult.clearAll();
            AbstractTableModel model = (AbstractTableModel) jTableResult.getModel();
            model.fireTableDataChanged();
            model.fireTableStructureChanged();
        }
    }

    private void statementChecker()
    {
        UserSQLStatement st = mCurrentStatement;
        jTextFieldVar1.setEditable(false);
        jTextFieldVar1.setEnabled(false);
        jTextFieldVar2.setEditable(false);
        jTextFieldVar2.setEnabled(false);
        jTextFieldVar3.setEditable(false);
        jTextFieldVar3.setEnabled(false);
        jTextFieldVar4.setEditable(false);
        jTextFieldVar4.setEnabled(false);
        jTextFieldVar6.setEditable(false);
        jTextFieldVar6.setEnabled(false);
        jTextFieldVar5.setEditable(false);
        jTextFieldVar5.setEnabled(false);
        
        jTextFieldNoVars.setText(""+st.getVarNumberStatement());
        for (int i=0; i<st.getVarNumberStatement();i++)
        {
            switch (i)
            {
                    case 0:
                    {
                        jTextFieldVar1.setText(st.getVarString(i));
                        jTextFieldVar1.setToolTipText(st.getVarComment(i));
                        jTextFieldVar1.setEditable(true);
                        jTextFieldVar1.setEnabled(true);
                        break;
                    }
                    case 1:
                    {
                        jTextFieldVar2.setText(st.getVarString(i));
                        jTextFieldVar2.setToolTipText(st.getVarComment(i));
                        jTextFieldVar2.setEditable(true);
                        jTextFieldVar2.setEnabled(true);
                        break;
                    }
                    case 2:
                    {
                        jTextFieldVar3.setText(st.getVarString(i));
                        jTextFieldVar3.setToolTipText(st.getVarComment(i));
                        jTextFieldVar3.setEditable(true);
                        jTextFieldVar3.setEnabled(true);
                        break;
                    }
                    case 3:
                    {
                        jTextFieldVar4.setText(st.getVarString(i));
                        jTextFieldVar4.setToolTipText(st.getVarComment(i));
                        jTextFieldVar4.setEditable(true);
                        jTextFieldVar4.setEnabled(true);
                        break;
                    }
                    case 4:
                    {
                        jTextFieldVar6.setText(st.getVarString(i));
                        jTextFieldVar6.setToolTipText(st.getVarComment(i));
                        jTextFieldVar6.setEditable(true);
                        jTextFieldVar6.setEnabled(true);
                        break;
                    }
                    case 5:
                    {
                        jTextFieldVar5.setText(st.getVarString(i));
                        jTextFieldVar5.setToolTipText(st.getVarComment(i));
                        jTextFieldVar5.setEditable(true);
                        jTextFieldVar5.setEnabled(true);
                        break;
                    }
            }
        }
    }
    private void jTextAreaStatementFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextAreaStatementFocusLost
    // Check Statement vor Vars
        mCurrentStatement.mStatement = jTextAreaStatement.getText();
        jTextAreaStatement.setToolTipText(mCurrentStatement.getBuildStatement());
        statementChecker();
       
    }//GEN-LAST:event_jTextAreaStatementFocusLost

    private void jButtonNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewActionPerformed
    // new!
        mCurrentStatement = new UserSQLStatement();
        jTextFieldVar1.setText("");
        jTextFieldVar2.setText("");
        jTextFieldVar3.setText("");
        jTextFieldVar4.setText("");
        jTextFieldVar6.setText("");
        jTextFieldVar5.setText("");
        setCommentsFormST(mCurrentStatement);
        setStatementToFields(mCurrentStatement);
        jComboBoxDBConnection.setSelectedItem(-1);
        String klasse = (String) jComboBoxKlasse.getSelectedItem();
        if (klasse == null) klasse = new String();
        jTextFieldKlasse.setText(klasse);

       
    }//GEN-LAST:event_jButtonNewActionPerformed

    private void jComboBoxStatementActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxStatementActionPerformed
       
        if (mInComboAdd>0) return;
        Object item = jComboBoxStatement.getSelectedItem();
        if (item == null)
        {
            mCurrentStatement = new UserSQLStatement();       
        }
        else
        {
           mCurrentStatement = mStatementPool.get(item.toString());
        }
        jTextFieldVar1.setText("");
        jTextFieldVar2.setText("");
        jTextFieldVar3.setText("");
        jTextFieldVar4.setText("");
        jTextFieldVar6.setText("");
        jTextFieldVar5.setText("");

        setCommentsFormST(mCurrentStatement);
        setStatementToFields(mCurrentStatement);

        DBConnectionData object = (DBConnectionData) mConnectionPool.get(mCurrentStatement.mDBConnection);
        jComboBoxDBConnection.setSelectedItem(object);
        jTextFieldKlasse.setText(mCurrentStatement.mKlasse);

        if (mOraResult!=null)
        {
            mOraResult.clearAll();
            AbstractTableModel model = (AbstractTableModel) jTableResult.getModel();
            model.fireTableDataChanged();
            model.fireTableStructureChanged();
        }
    }//GEN-LAST:event_jComboBoxStatementActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        // Execute an sql statement!
        DBConnectionData c = null;
        try
        {
            reReadAllFromGui();
            c = mConnectionPool.get(mCurrentStatement.mDBConnection);
            if (c == null)
            {
                ShowErrorDialog.showErrorDialog("Keine DB Verbindung", "Keine DB-Verbindung ausgewählt");
              //  JOptionPane.showMessageDialog(null, "Keine DB-Verbindung ausgewählt" ,"Keine DB Verbindung",  JOptionPane.ERROR_MESSAGE); 
                return;
            }

            mOraResult = c.getSQLResult();
            mOraResult.setStatement(mCurrentStatement);

            c.openConnection();
            if (!mOraResult.doDBQuery())
            {
                //JOptionPane.showMessageDialog(null, mOraResult.getLastException().toString(),mOraResult.getLastError(),  JOptionPane.ERROR_MESSAGE); 
                ShowErrorDialog.showErrorDialog(mOraResult.getLastError(), mOraResult.getLastException().toString());
            }
            else
            {
                 setTableData();
            }
            c.closeConnection();
        }
        catch (Throwable e)
        {
            c.closeConnection();
            e.printStackTrace();

            ShowErrorDialog.showErrorDialog("Unexpected Exception", e.toString());
        }
        
      
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jTextFieldVar1FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldVar1FocusLost
        mCurrentStatement.setVar(0, jTextFieldVar1.getText(), (String) mVComments.get(0));
        jTextAreaStatement.setToolTipText(mCurrentStatement.getBuildStatement());
     
    }//GEN-LAST:event_jTextFieldVar1FocusLost

    private void jTextFieldVar2FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldVar2FocusLost
        mCurrentStatement.setVar(1, jTextFieldVar2.getText(), (String) mVComments.get(1));
        jTextAreaStatement.setToolTipText(mCurrentStatement.getBuildStatement());
        
    }//GEN-LAST:event_jTextFieldVar2FocusLost

    private void jTextFieldVar3FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldVar3FocusLost
        mCurrentStatement.setVar(2, jTextFieldVar3.getText(), (String) mVComments.get(2));
        jTextAreaStatement.setToolTipText(mCurrentStatement.getBuildStatement());
      
    }//GEN-LAST:event_jTextFieldVar3FocusLost

    private void jTextFieldVar4FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldVar4FocusLost
        mCurrentStatement.setVar(3, jTextFieldVar4.getText(), (String) mVComments.get(3));
        jTextAreaStatement.setToolTipText(mCurrentStatement.getBuildStatement());
       
    }//GEN-LAST:event_jTextFieldVar4FocusLost

    private void jTextFieldVar5FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldVar5FocusLost
        mCurrentStatement.setVar(4, jTextFieldVar5.getText(), (String) mVComments.get(4));
        jTextAreaStatement.setToolTipText(mCurrentStatement.getBuildStatement());
       
}//GEN-LAST:event_jTextFieldVar5FocusLost

    private void jTextFieldVar6FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldVar6FocusLost
        mCurrentStatement.setVar(5, jTextFieldVar6.getText(), (String) mVComments.get(5));
        jTextAreaStatement.setToolTipText(mCurrentStatement.getBuildStatement());
       
}//GEN-LAST:event_jTextFieldVar6FocusLost

    private void jComboBoxDBConnectionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxDBConnectionActionPerformed
        if (mInDBAdd>0) return;
        mCurrentStatement.mDBConnection =  new String();
        if (jComboBoxDBConnection.getSelectedItem() != null)
        {
            mCurrentStatement.mDBConnection =  ((DBConnectionData)jComboBoxDBConnection.getSelectedItem()).toString();
        }
        
    }//GEN-LAST:event_jComboBoxDBConnectionActionPerformed

    private int mRow=-1;
    private int mCol=-1;
    private SQLDataObject mLastObject=null;

    private void jTableResultMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTableResultMouseClicked
        if (evt.getButton() == java.awt.event.MouseEvent.BUTTON3)
        {
                JTable table = (JTable) evt.getSource();
                mRow = table.convertRowIndexToModel(table.rowAtPoint(evt.getPoint()));
                mCol = table.convertColumnIndexToModel(table.columnAtPoint(evt.getPoint())); 
        

                try
                {
                    mLastObject= (SQLDataObject) mOraResult.getData(mRow, mCol);
                    if (mLastObject.mIsLob) 
                    {
                        mLastPopUp = evt.getComponent();
                        jPopupMenu2.show(evt.getComponent(), evt.getX(), evt.getY());
                    }
                    else 
                    {
                        mLastPopUp = evt.getComponent();
                        jPopupMenu3.show(evt.getComponent(), evt.getX(), evt.getY());
                    }
                }
                catch (Throwable e) {}
        }
      
    }//GEN-LAST:event_jTableResultMouseClicked

    private void jMenuItemExportActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemExportActionPerformed
      
        try
        {
            File destPath = new File(de.malban.Global.mBaseDir+"LOB_"+mLastObject.mTableName+"_"+mLastObject.mColumnName+"_"+mRow+"_"+mCol+".lob");
            FileOutputStream fout = new FileOutputStream(destPath);
            fout.write(mLastObject.mLobData);
            fout.close();
        }
        catch (Throwable e)
        {
           
            ShowErrorDialog.showErrorDialog("Write Error", e.toString());
        }
        
      
    }//GEN-LAST:event_jMenuItemExportActionPerformed

    private void jTextFieldVar4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldVar4ActionPerformed
       
    }//GEN-LAST:event_jTextFieldVar4ActionPerformed

    private void jComboBoxSt2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxSt2ActionPerformed
       
    }//GEN-LAST:event_jComboBoxSt2ActionPerformed

    private void jComboBoxKlasseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxKlasseActionPerformed
        if (mClassSetting>0) return;
        clearAllFields();
        String klasse = (String) jComboBoxKlasse.getSelectedItem();
        if (klasse == null) klasse = new String();
        jTextFieldKlasse.setText(klasse);
        resetStatementPool(null,null);
        
       
    }//GEN-LAST:event_jComboBoxKlasseActionPerformed

    private void jMenuItemExportTableActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemExportTableActionPerformed

        String name = InputDialog.showInputDialog("Enter Filename:");
        try 
        {
            PrintWriter pw = new PrintWriter(name);
            
            int colCount = jTableResult.getColumnCount();
            int rowCount = jTableResult.getRowCount();
            
            // Heading
            for (int i=0; i <colCount;i++)
            {
                if (i!=0) pw.print(";");
                pw.print(jTableResult.getColumnName(i));
            }

            // Data
            pw.print("\n");
            TableModel model = jTableResult.getModel();
            for (int r=0; r <rowCount;r++)
            {
                for (int c=0; c <colCount;c++)
                {
                    if (c!=0) pw.print(";");
                    pw.print(model.getValueAt(r,c));
                }
                pw.print("\n");
            }
            pw.close();
        } 
        catch (IOException e) 
        {
            System.err.println(e.toString());
        }
            
        
      
    }//GEN-LAST:event_jMenuItemExportTableActionPerformed

private void jMenuItemHideColumnActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemHideColumnActionPerformed

    JTable table = (JTable) evt.getSource();
   
}//GEN-LAST:event_jMenuItemHideColumnActionPerformed

private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed

    if (jCheckBox1.isSelected())
    {
        jTableResult.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
    }
    else
    {
        jTableResult.setAutoResizeMode(JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    }
    
}//GEN-LAST:event_jCheckBox1ActionPerformed

private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed

        ExcelHelper.toExcel(jTableResult);

}//GEN-LAST:event_jMenuItem1ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        // Execute an sql statement!
        DBConnectionData c = null;
        try
        {
            reReadAllFromGui();
            c = mConnectionPool.get(mCurrentStatement.mDBConnection);
            if (c == null)
            {
                ShowErrorDialog.showErrorDialog("Keine DB Verbindung", "Keine DB-Verbindung ausgewählt");
             
                return;
            }

            mOraResult = c.getSQLResult();
            mOraResult.setStatement(mCurrentStatement);

            c.openConnection();
            if (!mOraResult.doDBChange())
            {
                //JOptionPane.showMessageDialog(null, mOraResult.getLastException().toString(),mOraResult.getLastError(),  JOptionPane.ERROR_MESSAGE); 
                ShowErrorDialog.showErrorDialog(mOraResult.getLastError(), mOraResult.getLastException().toString());
            }
            else
            {
                 setTableData();
            }
            c.commit();
            c.closeConnection();
        }
        catch (Throwable e)
        {
            c.rollback();
            c.closeConnection();
            e.printStackTrace();
//            JOptionPane.showMessageDialog(null, e.toString(),"Unexpected Exception",  JOptionPane.ERROR_MESSAGE); 
            ShowErrorDialog.showErrorDialog("Unexpected Exception", e.toString());
        }
                
    }//GEN-LAST:event_jButton2ActionPerformed
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButtonNew;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JComboBox jComboBoxDBConnection;
    private javax.swing.JComboBox jComboBoxKlasse;
    private javax.swing.JComboBox jComboBoxSt1;
    private javax.swing.JComboBox jComboBoxSt2;
    private javax.swing.JComboBox jComboBoxSt3;
    private javax.swing.JComboBox jComboBoxSt4;
    private javax.swing.JComboBox jComboBoxSt5;
    private javax.swing.JComboBox jComboBoxSt6;
    private javax.swing.JComboBox jComboBoxStatement;
    private javax.swing.JLabel jLabelDBConnection;
    private javax.swing.JLabel jLabelDescribtion;
    private javax.swing.JLabel jLabelKlasse;
    private javax.swing.JLabel jLabelKlasse1;
    private javax.swing.JLabel jLabelName;
    private javax.swing.JLabel jLabelNoVars;
    private javax.swing.JLabel jLabelSt1;
    private javax.swing.JLabel jLabelSt2;
    private javax.swing.JLabel jLabelSt3;
    private javax.swing.JLabel jLabelSt4;
    private javax.swing.JLabel jLabelSt5;
    private javax.swing.JLabel jLabelSt6;
    private javax.swing.JLabel jLabelStatement;
    private javax.swing.JLabel jLabelStatementName;
    private javax.swing.JLabel jLabelStatements;
    private javax.swing.JLabel jLabelTableSize;
    private javax.swing.JLabel jLabelVar1;
    private javax.swing.JLabel jLabelVar2;
    private javax.swing.JLabel jLabelVar3;
    private javax.swing.JLabel jLabelVar4;
    private javax.swing.JLabel jLabelVar5;
    private javax.swing.JLabel jLabelVar6;
    private javax.swing.JLabel jLabelVariables;
    private javax.swing.JMenu jMenuExecuteHere;
    private javax.swing.JMenu jMenuExecuteNew;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItemAddComment;
    private javax.swing.JMenuItem jMenuItemExport;
    private javax.swing.JMenuItem jMenuItemExportTable;
    private javax.swing.JMenuItem jMenuItemHideColumn;
    private javax.swing.JPopupMenu jPopupMenu1;
    private javax.swing.JPopupMenu jPopupMenu2;
    private javax.swing.JPopupMenu jPopupMenu3;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JTable jTableResult;
    private javax.swing.JTextArea jTextAreaDescribtion;
    private javax.swing.JTextArea jTextAreaStatement;
    private javax.swing.JTextField jTextFieldKlasse;
    private javax.swing.JTextField jTextFieldNAme;
    private javax.swing.JTextField jTextFieldNoVars;
    private javax.swing.JTextField jTextFieldVar1;
    private javax.swing.JTextField jTextFieldVar2;
    private javax.swing.JTextField jTextFieldVar3;
    private javax.swing.JTextField jTextFieldVar4;
    private javax.swing.JTextField jTextFieldVar5;
    private javax.swing.JTextField jTextFieldVar6;
    // End of variables declaration//GEN-END:variables
    
    private void setTableData()
    {
        if (mOraResult == null)
        {
            return;
        }
        
        AbstractTableModel model = new 
             AbstractTableModel() {
                @Override public String getColumnName(int col) 
                {
                    return mOraResult.getColumnName(col);
                }
                public int getRowCount() { return mOraResult.getRowCount(); }
                public int getColumnCount() { return mOraResult.getColumnCount(); }
                public Object getValueAt(int row, int col) 
                {
                    Object result = "";
                    try
                    {
                        result = mOraResult.getData(row, col).mData; 
                    }
                    catch (Throwable e)
                    {
                
                    }
                    return result;
                }
                @Override public boolean isCellEditable(int row, int col)
                    { return false; }
            };
        jLabelTableSize.setText("Size: "+mOraResult.getRowCount()+"x"+mOraResult.getColumnCount());
        jTableResult.setModel(model);
    }
    private void clearAllFields()
    {
        mInComboAdd++;
        mInDBAdd++;
        mClassSetting++;
        setStatement(new UserSQLStatement());
        mInComboAdd--;
        mInDBAdd--;
        mClassSetting--;
    }
}
