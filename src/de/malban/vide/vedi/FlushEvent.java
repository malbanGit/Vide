/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

/**
 *
 * @author chrissalo
 */
public class FlushEvent {
    public String newlyFlushedText="";
    public FlushEvent(String s)
    {
        newlyFlushedText = s;
    }
}
