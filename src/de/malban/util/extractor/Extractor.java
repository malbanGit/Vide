/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util.extractor;

/**
 *
 * @author malban
 */
public class Extractor {
    
    /*
  public static final CfgItemTexture txHoldUp = new CfgItemTexture("holders-top", "overlay top holders", JoglContext.KIND_CHS, "data/packs/chassis_holders_top.png", -126.0F, 383.0F, 248.0F, 10.0F);
  public static final CfgItemTexture txHoldDn = new CfgItemTexture("holders-bottom", "overlay bottom holders", JoglContext.KIND_CHS, "data/packs/chassis_holders_bottom.png", -176.0F, -198.0F, 353.0F, 10.0F);
  public static final CfgItemTexture txCart = new CfgItemTexture("cartridge", "chassis cartridge", JoglContext.KIND_CHS, "data/packs/chassis_cartridge.png", 333.0F, -399.0F, 90.0F, 57.0F);
  public static final CfgItemTexture txScreen = new CfgItemTexture("screen", "chassis screen", JoglContext.KIND_CHS, "data/packs/chassis_screen.png", -221.0F, -185.0F, 442.0F, 565.0F);
  public static final CfgItemTexture txFrame = new CfgItemTexture("frame", "chassis frame", JoglContext.KIND_CHS, "data/packs/chassis_frame.png");
  public static final CfgItemTexture txPort1 = new CfgItemTexture("port1", "chassis port1 cable", JoglContext.KIND_CHS, "data/packs/chassis_cable_port1.png", 41.0F, -623.0F, 220.0F, 295.0F);
  public static final CfgItemTexture txPort2 = new CfgItemTexture("port2", "chassis port2 cable", JoglContext.KIND_CHS, "data/packs/chassis_cable_port2.png", -213.0F, -623.0F, 300.0F, 295.0F);
  public static final CfgItemTexture txPanel = new CfgItemTexture("bay-panel", "chassis bay panel", JoglContext.KIND_CHS, "data/packs/chassis_joystick_panel.png", -283.0F, -489.0F, 568.0F, 213.0F);
      
    */
    /*
  public static final CfgItemTexture txScreen = new CfgItemTexture("screen", "chassis screen", JoglContext.KIND_CHS, "data/packs/chassis_screen.png", -221.0F, -185.0F, 442.0F, 565.0F);
CtxTexture chassisFrame = new CtxTexture();
this.chassisFrame.source = localCfgItemTexture;


  public static InputStream getResourceStream(String paramString, Object paramObject)
    throws Exception
  {
    try
    {
      return Utils.getResourceStream(paramString);
    }
    catch (Exception localException)
    {
      InputStream localInputStream = getPackedStream(paramString, paramObject);
      if (localInputStream != null) {
        return localInputStream;
      }
    }
    return Utils.getResourceStream(paramString);
  }
  
  private final Texture loadTexture(GL paramGL, InputStream paramInputStream, CfgItemTexture paramCfgItemTexture)
    throws IOException
  {
    String str = paramCfgItemTexture.path;
    System.out.println("Loading " + paramCfgItemTexture.description + " texture [" + str.replace('\\', '/') + "]");
    System.out.flush();
    return TextureIO.newTexture(paramInputStream, paramCfgItemTexture.mipmap, FileUtil.getFileSuffix(str));
  }
  import com.sun.opengl.util.texture.TextureIO;

public boolean loadTexture(GL paramGL, CtxTexture paramCtxTexture)
  {
    paramCtxTexture.texture = null;
    paramCtxTexture.loaded = true;
    if (paramCtxTexture.source.hasTexture())
    {
      String str = paramCtxTexture.source.path;
      Object localObject = paramCtxTexture.source.kind;
      InputStream localInputStream = null;
      try
      {
        localInputStream = TexLoader.getResourceStream(str, localObject == null ? KIND_OVR : localObject);
        if (localInputStream != null)
        {
          Texture localTexture = loadTexture(paramGL, localInputStream, paramCtxTexture.source);
          paramCtxTexture.texture = new Integer(localTexture.getTextureObject());
          paramCtxTexture.mustFlip = localTexture.getMustFlipVertically();
          return true;
        }
        System.out.println("File does not exist or cannot be read : " + str);
        return false;
      }
      catch (Exception localException)
      {
        System.out.println("Error while loading texture : " + str);
        localException.printStackTrace(System.out);
        return false;
      }
    }
    return false;
  }
*/
    
    // to local path
    void extrectAll()
    {
        // Phonems
        String fileName = "phonems.jvepak";
        extractPhonemesFiles(fileName);

    }
    public static void  extractPhonemesFiles(String paraPathAndName)
    {
        // 16 bit
        Phonemes.loadSamplesWithSave(15, paraPathAndName);
    }
    
}
