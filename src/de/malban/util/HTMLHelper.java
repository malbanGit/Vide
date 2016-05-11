package de.malban.util;

import javax.swing.JTable;

public class HTMLHelper
{
    HTMLHelper()
    {
    }

    public static void toHTML(JTable table)
    {
        toHTML(table, false);
    }

    public static String toHTML(JTable table, boolean swapRowColumn)
    {
        // Build HTML
        String cName="";
        StringBuffer html= new StringBuffer();
        try
        {
            if (!swapRowColumn)
            {
                html.append("<table border=\"1\" bordercolor=\"black\">\n");
                html.append("<tr>\n");
                for (int c=0; c<table.getColumnCount(); c++)
                {
                    cName = table.getColumnName(c);
                    html.append("<th bgcolor=\"#c0c0c0\" color=\"#000000\">\n");

                    html.append(de.malban.util.UtilityString.toHTML(cName));
                    html.append(" </th>\n");
                }
                html.append("</tr>\n");

                for (int r=0; r<table.getRowCount(); r++)
                {
                    html.append("<tr>\n");
                    for (int c=0; c<table.getColumnCount(); c++)
                    {
                        Object o = table.getModel().getValueAt(table.convertRowIndexToModel(r), table.convertColumnIndexToModel(c));
                        String object ="";
                        if (o!=null) object = o.toString();
                        if (o==null) o="";

                        if (o.equals("null")) o="";
                        java.awt.Color co= new java.awt.Color(255,255,255);
                        java.awt.Component cc=null;
                        try{
                        cc = table.getCellRenderer(r, c).getTableCellRendererComponent(table, o, false, false, r, c);
                        }catch (Throwable e){}
                        if (cc != null)
                        {
                            co= cc.getBackground();
                        }

                        String rr = Integer.toHexString(co.getRed());
                        String g = Integer.toHexString(co.getGreen());
                        String b = Integer.toHexString(co.getBlue());

                        if (rr.length()<2) rr="0"+rr;
                        if (g.length()<2) g="0"+g;
                        if (b.length()<2) b="0"+b;

                        String back = "#"+rr+g+b;
                        String front = "#000000";

                        html.append("<td bgcolor=\""+back+"\" color=\""+front+"\">");

                        if (o instanceof Double)
                        { // machs deutsch - sonst macht excel ein datum aus den Zahlen 5.11 wird der 5 Novemnber...
                            object = de.malban.util.UtilityString.replace(object, ".",",");
                        }
                        html.append(de.malban.util.UtilityString.toHTML(object));
                        html.append(" </td>\n");
                    }
                    html.append("</tr>\n");
                }
                html.append("</table>\n");
            }
            else
            {
                html.append("<table border=\"1\" bordercolor=\"black\">\n");

                for (int c=0; c<table.getColumnCount(); c++)
                {
                    html.append("<tr>\n");
                    for (int r=0; r<table.getRowCount(); r++)
                    {
                        Object o = table.getModel().getValueAt(table.convertRowIndexToModel(r), table.convertColumnIndexToModel(c));
                        String object ="";
                        if (o!=null) object = o.toString();
                        if (o==null) o="";
                        if (o.equals("null")) o="";
                        java.awt.Color co= new java.awt.Color(255,255,255);
                        java.awt.Component cc=null;
                        try{
                        cc = table.getCellRenderer(r, c).getTableCellRendererComponent(table, o, false, false, r, c);
                        }catch (Throwable e){}
                         if (cc != null)
                        {
                            co= cc.getBackground();
                        }

                        String rr = Integer.toHexString(co.getRed());
                        String g = Integer.toHexString(co.getGreen());
                        String b = Integer.toHexString(co.getBlue());

                        if (rr.length()<2) rr="0"+rr;
                        if (g.length()<2) g="0"+g;
                        if (b.length()<2) b="0"+b;

                        String back = "#"+rr+g+b;
                        String front = "#000000";

                        if (r == 0)
                        {
                            cName = table.getColumnName(c);
                            html.append("<td bgcolor=\"#c0c0c0\" color=\"#000000\">");
                            html.append(de.malban.util.UtilityString.toHTML(cName));
                            html.append(" </td>\n");

                        }
                        html.append("<td bgcolor=\""+back+"\" color=\""+front+"\">");

                        if (o instanceof Double)
                        { // machs deutsch - sonst macht excel ein datum aus den Zahlen 5.11 wird der 5 Novemnber...
                            object = de.malban.util.UtilityString.replace(object, ".",",");
                        }
                        html.append(de.malban.util.UtilityString.toHTML(object));
                        html.append(" </td>\n");
                    }
                    html.append("</tr>\n");
                }
                html.append("</table>\n");
            }
            String log="";
            String result="";
        }
        catch (Throwable e)
        {
            System.out.println(e);
            e.printStackTrace(System.out);
        }
        return html.toString();
    }

}