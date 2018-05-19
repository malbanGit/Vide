/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.parts;

/**
 *
 * @author Malban
 */
public class DAC {
    // Spec National Semiconductor
    // DAC0808, replacement for MC 1408
    // settling time (max) 150ns
    
    // Vectrex: 
    // Vee = -13V
    // Vcc = +5V
    // Vref+ = +5V (Pin 14)
    // Vref- = GND (Pin 15)
    
    
    // output current represents the analog value of input digital
    // on a vectrex the output current is converted to voltage by
    // a current to voltage circuit 1/2 LF 353
    //
    // DAC Volatge range is finaly from x to y    
}
