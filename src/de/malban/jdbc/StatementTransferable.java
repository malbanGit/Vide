package de.malban.jdbc;

import javax.swing.*;
import javax.swing.table.*;
import java.awt.datatransfer.*;
import java.io.*;

/**
 * Transferable Handler for "Statements" Objects - of a flavor "STATEMENTFLAVOR" 
 * (Strings are also supported as Flavor: DataFlavor.stringFlavor)
 * Used in DataWindow to Transport data from there to Textfields.
 * 
 * @author Malban
 */
public class StatementTransferable implements Transferable 
{ 
  public static final DataFlavor STATEMENTFLAVOR=new DataFlavor(Object.class,"Object"); 

  Object myValue; 

  public StatementTransferable(Object value) 
  { 
    myValue=value; 
  } 

  public DataFlavor[] getTransferDataFlavors() 
  { 
    return new DataFlavor[]{STATEMENTFLAVOR};
  } 

  public boolean isDataFlavorSupported(DataFlavor flavor) 
  { 
    return (flavor==STATEMENTFLAVOR); 
  } 

  public Object getTransferData(DataFlavor flavor) throws 
         UnsupportedFlavorException, IOException 
  { 
    if(flavor==STATEMENTFLAVOR) return myValue; 
    else throw new UnsupportedFlavorException(flavor); 
  }    

} 