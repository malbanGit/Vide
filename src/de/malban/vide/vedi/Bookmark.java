/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author malban
 */
public class Bookmark implements Serializable {
    int lineNumber=-1;
    String name="";
    String fullFilename;
    String project;
    int number;
    public String toString()
    {
        return ""+number+": "+fullFilename+"->"+lineNumber;
    }
            
}
