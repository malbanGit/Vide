/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.sound;

import de.malban.config.Configuration;
import de.malban.config.Logable;
import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sound.sampled.*;

/**
 *
 * @author Malban
 */
public class Audio
{
    public static boolean mSoundEnabled=true;
    public static void resetCaches()
    {
        PlayClip.resetCache();
    }
    public static AudioPlayable play(String name)
    {
        if (!mSoundEnabled) return null;
        if (Configuration.getConfiguration().isSoundQuiet()) return null;
        name = de.malban.util.UtilityString.cleanFileString(name);
        File f = new File(name);
        if (!f.exists()) return null;

        if (name.endsWith("3"))
        {
            PlayMP3 player = new PlayMP3(name);
            player.play();
            player.setLoop(false);
            return player;
        }
        if (f.length()>100000)
        {
            PlaySound player = new PlaySound(name);
            player.play();
            return player;

        }

        PlayClip player = new PlayClip(name, true);
        player.play();
        return player;
    }

    public static void playCached(String name)
    {
        if (!mSoundEnabled) return;
        if (Configuration.getConfiguration().isSoundQuiet()) return;
        name = de.malban.util.UtilityString.cleanFileString(name);
        File f = new File(name);
        if (!f.exists()) return;

        if (name.endsWith("3"))
        {
            PlayMP3 player = new PlayMP3(name);
            player.play();
            player.setLoop(false);
            return;
        }
        if (f.length()>100000)
        {
            PlaySound player = new PlaySound(name);
            player.play();
            return;
        }
        PlayClip.playClip(name);
    }


public static void mixerTest() throws LineUnavailableException
{
//Mixer.Info mixerInfo = AudioSystem.getMixer(null).getMixerInfo();
    Mixer.Info[] mixerInfos = AudioSystem.getMixerInfo();
		for (Mixer.Info mixerInfo:mixerInfos)
                {
                        System.out.println("\n"+mixerInfo);
			Mixer m = AudioSystem.getMixer(mixerInfo);
			Line.Info[] lineInfos = m.getSourceLineInfo();
			for (Line.Info li:lineInfos) {
				if (li instanceof Port.Info){
					Port.Info pi=(Port.Info)li;
					Line portLine=m.getLine(pi);
					printPortControls(portLine);
				}
			}
			lineInfos = m.getTargetLineInfo();
			for (Line.Info li:lineInfos) {
				if (li instanceof Port.Info){
					if (li instanceof Port.Info){
						Port.Info pi=(Port.Info)li;
						Line portLine=m.getLine(pi);
						printPortControls(portLine);
					}
				}
			}
		}
	}

	private static void printPortControls(Line portLine) throws LineUnavailableException{
		portLine.open();
		Control[] pCtrls=portLine.getControls();
		for(Control memberControl:pCtrls){
			printControl(memberControl);
		}
		portLine.close();
	}

	public static void printControl(Control memberControl) {
		if (memberControl instanceof BooleanControl) {
			BooleanControl bc = (BooleanControl) memberControl;
			System.out.println(bc + ": " + bc.getValue());
		} else if (memberControl instanceof FloatControl) {
			FloatControl fc = (FloatControl) memberControl;
			System.out.println(fc + ": " + fc.getValue());

		} else if (memberControl instanceof EnumControl) {
			EnumControl ec = (EnumControl) memberControl;
			System.out.println(ec + ": " + ec.getValue());
		} else if (memberControl instanceof CompoundControl) {
			CompoundControl cc = (CompoundControl) memberControl;
			System.out.println(cc);
			for (Control compControl:cc.getMemberControls()) {
				printControl(compControl);
			}
		}
	}


















        static
        {
            // setAllVolumne(100);
        }
        public static int mVol = 100;

        public static void setAllVolumneWindows(int vol)
        {
            try
            {
                
            //    mixerTest();
            }
            catch (Throwable e){}
            mVol = vol;
            try
            {
                Mixer.Info[] mixers = AudioSystem.getMixerInfo();
                for (Mixer.Info info : mixers)
                {
                    Mixer mixer = AudioSystem.getMixer(info);
                    if (mixer.isLineSupported(Port.Info.SPEAKER))
                    {
                        Port port = (Port) mixer.getLine(Port.Info.SPEAKER);
                        boolean openPortNeeded = !port.isOpen();
                        try
                        {
                            if (openPortNeeded)
                            {
                                port.open();
                            }
                            if (port.isControlSupported(FloatControl.Type.VOLUME))
                            {
                                FloatControl volumeControl = (FloatControl) port.getControl(FloatControl.Type.VOLUME);
                                float min = volumeControl.getMinimum();
                                float max = volumeControl.getMaximum();
                                float current = volumeControl.getValue();
                                double percent = 100.0 * (current - min) / (max - min);
//                                System.out.println("Current Volume is " + percent + "%.");
    // setting to 50%
                                float v = (max - min) / 2.0f + min;
                                v = (((max - min)/100)*vol) +min;
                                volumeControl.setValue(v);
                            }

                        } finally
                        {
                            if (openPortNeeded && port.isOpen())
                            {
                                port.close();
                            }
                        }
                    }
                }
            }
            catch (Throwable e){}
        }


        public static void setAllVolumne(int vol)
        {
            String os = System.getProperty("os.name");

            if (os.toUpperCase().indexOf("WINDOW")!=-1)
            {
                setAllVolumneWindows(vol);
            }
            else if (os.toUpperCase().indexOf("MAC")!=-1)
            {
                setAllVolumneMac(vol);
            }
            else
            {
                setAllVolumneLinux(vol);
            }
        }

        // good resource: http://sourceforge.net/projects/jsresources/files/mixer/


        // looking for "MASTER" works for me - dont know if that control is allways labeld master....

        // this pretty hard coded. should probable be better made
        public static void setAllVolumneLinux(int vol)
        {
            Logable D = Configuration.getConfiguration().getDebugEntity();
            boolean volumeSet = false;
            List<Mixer> portMixers = getPortMixers();
            if (portMixers.isEmpty())
            {
                D.addLog("There are no mixers that support Port lines. Sound volume can not be set!",0);
            }
            Iterator<Mixer> iterator = portMixers.iterator();
            while (iterator.hasNext())
            {
                Mixer mixer = iterator.next();
                String strMixerName = mixer.getMixerInfo().getName();
//System.out.println("Mixer: " + strMixerName);
		Port.Info[] infosToCheck = getPortInfo(mixer);
		for (int i = 0; i < infosToCheck.length; i++)
		{
                    Port port = null;
                    try
                    {
                            port = (Port) mixer.getLine(infosToCheck[i]);
                            port.open();
                    }
                    catch (LineUnavailableException e)
                    {
                         //   e.printStackTrace();
                    }
                    if (port != null)
                    {
                        String	strPortName = ((Port.Info) port.getLineInfo()).getName();
//System.out.println("Port: " + strPortName);
                        if (strPortName.toUpperCase().indexOf("MASTER") ==-1 ) continue;
                        Control[]	aControls = port.getControls();
                        for (int t = 0; t < aControls.length; t++)
                        {
                            if (aControls[t] instanceof FloatControl)
                            {
                                FloatControl control = (FloatControl) aControls[t];
                                Control.Type type = control.getType();
                                String strControlName = type.toString();
                                if (!isVolumne(control)) continue;
//System.out.println("Control direct: " +  strControlName);
//
                                FloatControl volumeControl = (FloatControl) control;
                                float min = volumeControl.getMinimum();
                                float max = volumeControl.getMaximum();
                                float current = volumeControl.getValue();
                                double percent = 100.0 * (current - min) / (max - min);
                                // System.out.println("Current Volume is " + percent + "%.");
                                volumeSet = true;
    // setting to 50%
                                float v = (max - min) / 2.0f + min;
                                v = (((max - min)/100)*vol) +min;
                                volumeControl.setValue(v);
                            }
                            if (aControls[t] instanceof CompoundControl)
                            {
                                CompoundControl control = (CompoundControl) aControls[t];

                                String strControlName = control.getType().toString();
//System.out.println("Control compound: " +  strControlName);
                                Control[] subControls = control.getMemberControls();
                                for (int s = 0; s < subControls.length; s++)
                                {
                                    Control con = subControls[s];
                                    if (con instanceof FloatControl)
                                    {
                                        FloatControl subCon = (FloatControl)con;
                                        String strControlSubName = subCon.getType().toString();
                                        if (!isVolumne(subCon)) continue;
//System.out.println("Control sub: " +  strControlSubName);
//



                                        FloatControl volumeControl = (FloatControl) subCon;
                                        float min = volumeControl.getMinimum();
                                        float max = volumeControl.getMaximum();
                                        float current = volumeControl.getValue();
                                        double percent = 100.0 * (current - min) / (max - min);
                                        // System.out.println("Current Volume is " + percent + "%.");
            // setting to 50%
                                        float v = (max - min) / 2.0f + min;
                                        v = (((max - min)/100)*vol) +min;
                                        volumeControl.setValue(v);

                                        volumeSet = true;
                                    }
                                }

                            }
                        }
                    }
		}
            }
            if (!volumeSet)
            {
                D.addLog("Volume was not set, please contact auhtor, this should be easy to fix, once known what to look for!", 0);
            }
        }





	private static boolean isBalanceOrPan(FloatControl control)
	{
		Control.Type type = control.getType();
		return type.equals(FloatControl.Type.PAN) || type.equals(FloatControl.Type.BALANCE);
	}

        private static boolean isVolumne(FloatControl control)
	{
		Control.Type type = control.getType();
		return type.equals(FloatControl.Type.VOLUME) || type.equals(FloatControl.Type.MASTER_GAIN);
	}



	private static final Port.Info[]	EMPTY_PORT_INFO_ARRAY = new Port.Info[0];
	/**	Returns the Mixers that support Port lines.
	 */
	private static List<Mixer> getPortMixers()
	{
		List<Mixer>		supportingMixers = new ArrayList<Mixer>();
		Mixer.Info[]	aMixerInfos = AudioSystem.getMixerInfo();
		Line.Info	portInfo = new Line.Info(Port.class);
		for (int i = 0; i < aMixerInfos.length; i++)
		{
			Mixer	mixer = AudioSystem.getMixer(aMixerInfos[i]);
			boolean	bSupportsPorts = arePortsSupported(mixer);
			if (bSupportsPorts)
			{
				supportingMixers.add(mixer);
			}
		}
		return supportingMixers;
	}


	
	private static boolean arePortsSupported(Mixer mixer)
	{
		Line.Info[]	infos;
		infos = mixer.getSourceLineInfo();
		for (int i = 0; i < infos.length; i++)
		{
			if (infos[i] instanceof Port.Info)
			{
				return true;
			}
		}
		infos = mixer.getTargetLineInfo();
		for (int i = 0; i < infos.length; i++)
		{
			if (infos[i] instanceof Port.Info)
			{
				return true;
			}
		}
		return false;
	}



	private static Port.Info[] getPortInfo(Mixer mixer)
	{
		Line.Info[]	infos;
		List<Port.Info> portInfoList = new ArrayList<Port.Info>();
		infos = mixer.getSourceLineInfo();
		for (int i = 0; i < infos.length; i++)
		{
			if (infos[i] instanceof Port.Info)
			{
				portInfoList.add((Port.Info) infos[i]);
			}
		}
		infos = mixer.getTargetLineInfo();
		for (int i = 0; i < infos.length; i++)
		{
			if (infos[i] instanceof Port.Info)
			{
				portInfoList.add((Port.Info) infos[i]);
			}
		}
		Port.Info[]	portInfos = /*(Port.Info[])*/ portInfoList.toArray(EMPTY_PORT_INFO_ARRAY);
		return portInfos;
	}


        public static void setAllVolumneMac(int vol)
        {
            
            Logable D = Configuration.getConfiguration().getDebugEntity();
            if (D != null) return; // do nothing!
            boolean volumeSet = false;

    Mixer.Info[] mixerInfos = AudioSystem.getMixerInfo();
		for (Mixer.Info mixerInfo:mixerInfos)
                {
                        System.out.println("\n"+mixerInfo);
			Mixer m = AudioSystem.getMixer(mixerInfo);
                        Control[] c1 =m.getControls();
			Line.Info[] lineInfos = m.getSourceLineInfo();
			for (Line.Info li:lineInfos) 
                        {
                            

                            Line line;
                            try 
                            {
                                line = m.getLine(li);
                                Control[] c = line.getControls();
                                FloatControl volume= (FloatControl) line.getControl(FloatControl.Type.MASTER_GAIN);                                 
                                float max = volume.getMaximum();
                                float min = volume.getMinimum();
                                float dist = max-min;
                                
                                float v = dist /100 *vol;

                                volume.setValue(min+v); 
                            } 
                            catch (Throwable ex) 
                            {
                                Logger.getLogger(Audio.class.getName()).log(Level.SEVERE, null, ex);
                            }

                                
			}
                
                
                }

                
        
        }




}
