/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.config;

/**
 *
 * @author malban
 */
public interface TinyLogInterface 
{
    public void printMessage(String s);
    public void printWarning(String s);
    public void printError(String s);

    public void printMessageSU(String s);
    public void printWarningSU(String s);
    public void printErrorSU(String s);
}
