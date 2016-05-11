/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.util;

/**
 *
 * @author Malban
 */
public interface InfoCallback 
{
    public boolean askCancel(String text);
    public boolean giveInfo(String Text, int currentItem, int itemCount);
}
