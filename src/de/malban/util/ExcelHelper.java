package de.malban.util;

import de.malban.Global;
import java.io.*;
import java.util.*;
import java.awt.Desktop.*;
import java.awt.*;

import javax.swing.JTable;


public class ExcelHelper 
{
    private static int counter=0;
    ExcelHelper()
    {
    }

    public static void toExcel(Vector <JTable> tables, String basename)
    {
        // two steps

        // first htmlíze

        // Build HTML
        String cName="";
        //if ((table.getColumnCount()<200) && ((table.getColumnCount()) < (table.getRowCount()*3) ))
        String filename = "";
        File f = null;

        do
        {
            // filename = de.malban.Global.mBaseDir+"tmp\\temp_excel_"+basename+"_"+counter+".xls";
            filename = Global.mainPathPrefix+"tmp\\temp_excel_"+basename+"_"+counter+".xls";
            filename = de.malban.util.UtilityString.cleanFileString(filename);
            f = new File (filename);
            counter++;
        } while (f.isFile());

        System.out.println("Temp Filename used: " + filename);

        try
        {
            PrintWriter pw = new PrintWriter(filename);
            pw.println("<P>List Generated: "+de.malban.util.UtilityDate.dateToStringGermanClock(new Date()) +"</P>");
            boolean swapRowColumn=false;
            for (int t=0; t < tables.size();t++)
            {
                JTable table = tables.elementAt(t);
                if (table.getColumnCount()>250) swapRowColumn=true;
                String html = de.malban.util.HTMLHelper.toHTML(table, swapRowColumn);

                pw.println("<P></P>");

                pw.println(html);
            }

            pw.flush();
            pw.close();

            String log="";
            String result="";
            f = new File(filename);
            if (f == null) return;
            Desktop desktop = null;
            // Before more Desktop API is used, first check
            // whether the API is supported by this particular
            // virtual machine (VM) on this particular host.
            try
            {
                if (Desktop.isDesktopSupported())
                {
                    desktop = Desktop.getDesktop();
                    desktop.open(f);
                }
            }
            catch (IOException e)
            {
                log += System.err.toString();
                e.printStackTrace(System.err);
            }
        }
        catch (Throwable e)
        {
            System.out.println(e);
            e.printStackTrace(System.out);
        }
    }

    public static void toExcel(JTable table)
    {
        toExcel(table, false, "");
    }

    public static void toExcel(JTable table, String basename)
    {
        toExcel(table, false, basename);
    }

    public static void toExcel(JTable table, boolean swapRowColumn, String basename)
    {
        // two steps

        // first htmlíze

        // Build HTML
        String cName="";
        //if ((table.getColumnCount()<200) && ((table.getColumnCount()) < (table.getRowCount()*3) ))
        String filename = "";
        File f = null;

        do
        {
//            filename = de.malban.Global.mBaseDir+"tmp\\temp_excel_"+basename+"_"+counter+".xls";
            filename = Global.mainPathPrefix+"tmp\\temp_excel_"+basename+"_"+counter+".xls";
            filename = de.malban.util.UtilityString.cleanFileString(filename);
            f = new File (filename);
            counter++;
        } while (f.isFile());

        System.out.println("Temp Filename used: " + filename);

        try
        {
            if (table.getColumnCount()>250) swapRowColumn=true;
            PrintWriter pw = new PrintWriter(filename);

            String html = de.malban.util.HTMLHelper.toHTML(table, swapRowColumn);
            pw.println(html);

            pw.flush();
            pw.close();

            String log="";
            String result="";
            f = new File(filename);
            if (f == null) return;
            Desktop desktop = null;
            // Before more Desktop API is used, first check
            // whether the API is supported by this particular
            // virtual machine (VM) on this particular host.
            try
            {
                if (Desktop.isDesktopSupported())
                {
                    desktop = Desktop.getDesktop();
                    desktop.open(f);
                }
            }
            catch (IOException e)
            {
                log += System.err.toString();
                e.printStackTrace(System.err);
            }
        }
        catch (Throwable e)
        {
            System.out.println(e);
            e.printStackTrace(System.out);
        }
    }
}
