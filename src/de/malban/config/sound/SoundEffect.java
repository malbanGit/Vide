/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.config.sound;

import de.malban.config.Configuration;
import de.malban.config.Logable;
import de.malban.sound.Audio;
import java.util.HashMap;
import java.util.Vector;

/**
 *
 * @author Malban
 */
public class SoundEffect
{
    public static final String FX_EFFECT_CARD_ANY = "Card any";
    public static final String FX_EFFECT_CARD_PLAYED = "Card played";
    public static final String FX_EFFECT_CARD_GRAVE = "Card to grave";
    public static final String FX_EFFECT_CARD_HAND = "Card to hand";
    public static final String FX_EFFECT_CARD_LIBRARY = "Card to library";
    public static final String FX_EFFECT_PLAYER_TURN= "Player turn";
    public static final String FX_EFFECT_PLAYER_END = "Player end";
    public static final String FX_EFFECT_PLAYER_ADD_LIFE = "Player add life";
    public static final String FX_EFFECT_PLAYER_LOSE_LIFE = "Player lose life";
    public static final String FX_EFFECT_GAME_START = "Game start";
    public static final String FX_EFFECT_GAME_END = "Game end";
    public static final String FX_EFFECT_CARD_ACTIVATED = "Card activated";
    public static final String FX_EFFECT_ACHIEVEMENT = "Achievement";

    public static final String[] FX_EFFECT_TRIGGERS=
        {  FX_EFFECT_CARD_ANY,
          FX_EFFECT_CARD_PLAYED,
          FX_EFFECT_CARD_GRAVE,
          FX_EFFECT_CARD_HAND,
          FX_EFFECT_CARD_LIBRARY,
          FX_EFFECT_PLAYER_TURN,
          FX_EFFECT_PLAYER_END,
          FX_EFFECT_PLAYER_ADD_LIFE,
          FX_EFFECT_PLAYER_LOSE_LIFE,
          FX_EFFECT_GAME_START,
          FX_EFFECT_GAME_END,
          FX_EFFECT_CARD_ACTIVATED,
          FX_EFFECT_ACHIEVEMENT
    };



    String mSoundFile="";
    String mColor="";
    String mType="";
    String mSubtype="";
    String mID="";
    String mEvent="";

    @Override
    public String toString()
    {
        String ret = "";
        ret += "File: "+mSoundFile;
        ret += ", Color: "+mColor;
        ret += ", Type: "+mType;
        ret += ", Subtype: "+mSubtype;
        ret += ", ID: "+mID;
        ret += ", Event: "+mEvent;
        return ret;
    }

    static Vector<SoundEffect> buildEffectVector(SoundMap data)
    {
        Vector<SoundEffect> v = new Vector<SoundEffect>();
        for (int i = 0; i < data.mEvent.size(); i++)
        {
            v.addElement(getEffectData(data, i));
        }
        return v;
    }

    public static Vector<SoundEffect> getEffects(SoundMap data, String trigger)
    {
        Vector<SoundEffect> effects = new Vector<SoundEffect>();

        for (int i = 0; i < data.mEvent.size(); i++)
        {
            if (data.mEvent.elementAt(i).equals(trigger))
            {
                effects.addElement( getEffectData(data, i));
            }
        }
        return effects;
    }

    static void setEffectVector(SoundMap data, Vector<SoundEffect> v)
    {
	data.mSoundFile=new Vector<String>();
	data.mColor=new Vector<String>();
	data.mType=new Vector<String>();
	data.mSubtype=new Vector<String>();
	data.mID=new Vector<String>();
	data.mEvent=new Vector<String>();
        for (int i = 0; i < v.size(); i++)
        {
            SoundEffect af = v.elementAt(i);
            addEffect(data, af);
        }
    }

    static void addEffect(SoundMap data, SoundEffect af)
    {
        removeEffect(data, af);
        data.mSoundFile.addElement(af.mSoundFile);
        data.mType.addElement(af.mType);
        data.mColor.addElement(af.mColor);
        data.mSubtype.addElement(af.mSubtype);
        data.mID.addElement(af.mID);
        data.mEvent.addElement(af.mEvent);
    }

    public boolean equals(SoundMap data, int pos)
    {
        return equals(getEffectData(data, pos));
    }
    public boolean equals(SoundMap data)
    {
        return data.toString().equals(toString());
    }

    static void removeEffect(SoundMap data, SoundEffect af)
    {
        Vector<SoundEffect> v = new Vector<SoundEffect>();
        int index = -1;
        for (int i = 0; i < data.mEvent.size(); i++)
        {
            if (af.equals(data, i))
            {
                index = i;
                break;
            }
        }
        removeEffect(data, index);
    }

    static void removeEffect(SoundMap data, int index)
    {
        if (index != -1)
        {
            data.mSoundFile.removeElementAt(index);
            data.mColor.removeElementAt(index);
            data.mType.removeElementAt(index);
            data.mSubtype.removeElementAt(index);
            data.mID.removeElementAt(index);
            data.mEvent.removeElementAt(index);
        }
    }


    static SoundEffect getEffectData(SoundMap data, int i)
    {
        SoundEffect af = new SoundEffect();
        af.mSoundFile=data.mSoundFile.elementAt(i);
        af.mColor=data.mColor.elementAt(i);
        af.mType=data.mType.elementAt(i);
        af.mSubtype=data.mSubtype.elementAt(i);
        af.mID=data.mID.elementAt(i);
        af.mEvent=data.mEvent.elementAt(i);
        return af;
    }

    static SoundMap activeMap = null;
    static HashMap<String, String> keyPathmap = null;

    public static void resetMappings()
    {
        activeMap = null;
        keyPathmap = null;
    }

    private static void ensureMappingLoaded()
    {
        if (activeMap != null) return;
        Configuration C =Configuration.getConfiguration();
        Logable D = C.getDebugEntity();
        activeMap = C.getSoundMap();
        keyPathmap = new HashMap<String, String>();
        for (int i = 0; i < activeMap.mEvent.size(); i++)
        {
            String key="";
            String value=activeMap.mSoundFile.elementAt(i);

            key += activeMap.mEvent.elementAt(i);
            if (key.indexOf("Card") != -1)
            {
                key+=activeMap.mColor.elementAt(i);
                key+=activeMap.mType.elementAt(i);
                key+=activeMap.mSubtype.elementAt(i);
                key+=activeMap.mID.elementAt(i);
            }
            keyPathmap.put(key, value);
            if (activeMap.mID.elementAt(i).trim().length()>0)
            {
                key = activeMap.mEvent.elementAt(i);
                key+=activeMap.mID.elementAt(i);
                keyPathmap.put(key, value);
            }
        }
    }

    /*
    public static void playSound(Card card, String trigger)
    {
        ensureMappingLoaded();
        Configuration C =Configuration.getConfiguration();
        Logable D = C.getDebugEntity();
        String soundname ="";
        String key = trigger;
        if ((key.indexOf("Card") != -1) && ((card != null)))
        {
            String key2 = key;
            key2+=card.getNowColor();
            String t = card.getType(); if (t.indexOf("Land") != -1) key2+="Land"; else key2 += t;

            key2+=card.getSubtype();
            key2+=card.getId();
            soundname = keyPathmap.get(key2);
            if (soundname == null)
            {
                key2 = key;
                key2+=card.getNowColor();
                t = card.getType(); if (t.indexOf("Land") != -1) key2+="Land"; else key2 += t;
                key2+=card.getSubtype();
                soundname = keyPathmap.get(key2);
                if (soundname == null)
                {
                    key2 = key;
                    key2+=card.getNowColor();
                    t = card.getType(); if (t.indexOf("Land") != -1) key2+="Land"; else key2 += t;
                    soundname = keyPathmap.get(key2);
                    if (soundname == null)
                    {
                            key2 = key;
                            t = card.getType(); if (t.indexOf("Land") != -1) key2+="Land"; else key2 += t;
                            soundname = keyPathmap.get(key2);
                            if (soundname == null)
                            {
                                key2 = key;
                                key2+=card.getNowColor();
                                soundname = keyPathmap.get(key2);
                                if (soundname == null)
                                {
                                    key2 = key;
                                }
                            }

                    }
                }
            }
            key = key2;
        }
        soundname = keyPathmap.get(key);
        if (card != null)
        {
            String key2 = trigger;
            key2+=card.getId();
            soundname = keyPathmap.get(key2);
            if(soundname!=null) key = key2;
            soundname = keyPathmap.get(key);
        }
        else // card == null
        {
        soundname = keyPathmap.get(key);
        }
        if (soundname != null)
            Audio.playCached(soundname);
        else
        {
            if (trigger != null)
            {
                if ( (trigger.toUpperCase().indexOf("WAV") != -1) ||
                     (trigger.toUpperCase().indexOf("MP3") != -1)
                    )
                {
                    Audio.play(trigger);
                }
            }
        }
    }
    */
}
