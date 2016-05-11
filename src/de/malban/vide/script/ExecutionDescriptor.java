/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.script;

/**
 *
 * @author Malban
 */
public class ExecutionDescriptor {
    public static String ED_TYPE_PROJECT_PRE = "PROJECT_PRE";
    public static String ED_TYPE_PROJECT_POST = "PROJECT_POST";
    public static String ED_TYPE_FILE_PRE = "FILE_PRE";
    public static String ED_TYPE_FILE_POST = "FILE_POST";
    public static String ED_TYPE_FILE_ACTION = "FILE_ACTION";
    public static String ED_TYPE_VECCY_IMPORT = "VECCY_IMPORT";
    public static String ED_TYPE_VECCY_EXPORT = "VECCY_EXPORT";
    
    public String type;
    public String callingFrom;
    public String filename; // filename ONLY!
    public String projectname;
    public String parameterString;
    public String parameterInt;
    public String path;
    
    public ExecutionDescriptor(String t, String p, String f, String cf, String pa)
    {
        type = t;
        projectname = p;
        filename = f;
        callingFrom = cf;
        path = pa;
    }
}
