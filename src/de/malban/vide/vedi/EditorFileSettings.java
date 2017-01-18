/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import java.io.Serializable;
import java.util.Objects;

/**
 *
 * @author malban
 */
public class EditorFileSettings  implements Serializable
{
    public String filename="";
    public int position = 0;
    
    public boolean equals(EditorFileSettings o)
    {
        if (o == null) return false;
        return filename.equals(((EditorFileSettings)o).filename);
    }
    @Override
    public boolean equals(Object o)
    {
        if (o == null) return false;
        if (!(o instanceof EditorFileSettings)) return false;
        return equals(((EditorFileSettings)o));
    }

    @Override
    public int hashCode() {
        int hash = 5;
        hash = 97 * hash + Objects.hashCode(this.filename);
        return hash;
    }
    
}
