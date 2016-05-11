/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.config;

/**
 *
 * @author Malban
 */
public interface LogListener {
  public void logChanged();
  public void logAddedChanged(String text);

}
