/*
TIMER Test4 -> SHOTS do not "fast" expire - sollten 50 sein sieht aus wie 256



August 2023
void copyActionFromSpriteToSprite(String fromName, String toName)
int GamePanel -> not implemented, no SAVE AS for sprites as of now

// todo ACTIONS! More than one!
// not just 0


*/


/*
do moves/draw in a row with a loop!!! should be possible without losing cycles!


For break out, do a dummy Sprite with position and hitbox!        

make a loop of timer moves? with that many nops... it might work

Do multi Triggers

Do synclist as alternative

generate new smartlists from Veccy

Jump to editor on error

generate to vecfever        
        
Test smart lists on different vectrex

*/        
        
        
/*
;x0 nicht erkannt in HELP 2. Vector!

; reduce consecutive moves to ONE move!!!

; generate up xx same line - for large lines!



Triggers need a second sprite field,
so that upon a sprite collision with ONE sprite
- a removeALL on another sprite can be done
- another sprite can be spawned upon collision
...


to test further:
- removeAll
- implementation of trigger order in addTriggerFoundCode

*/
        
/*



!!!
Level objects should be kept in different files!
possibly with export/inpurt

The first HELP of test 6 appears at the lower left screen instead near the character!
-> because the MOVE of the sprite is done before the first values are set to Y,X pos
this should be easily fixable, when upon spawning the position is filled once!



Ensure sprites/ actions can not be named with Sonderzeichen!


A sprite can as of now only have ONE col detect.

A Blocker - can as of now even a standing sprite continuously BLOCK.
(col detect)
-> possibly always Move against a collision
-> works, but is a work around, a player can still "hide" in a block movement...

-> possible workaround soultion... for players have a "global" death variable, that
   gets set, wenn a col detection has a "remove" configured immediately when detected...


If that happens and the order is just wrong, than the sprite can not detect
the collision with another sprite (shot) - and is thus invincible!
*/

/*
level variables
global variables


        !!! this is still an issue
        !!! but blocking only ONE direction (the main collision direction)
        !!! gets for now rid of the problem!
        ensure player 1 is done BEFORE player two
        IN GAME not in generator
        otherwise
        sprite collision detection / block movement can swarted


For that you can define a bounding box with EXACTLY the same values ...
-> also check collisionm direction flags -> opposite mogvement should not be blocked!


next trigger action "block movement"

if error on generate -> open editor with project


player input from analog not directly, but analog value /10 = speed

direct analog input -> perhaps as in pitrex as a "median" from last 5 inputs?
-> should be smoother movement

enemy shots do not target player on the right side!

marker, whether initial timer countdown value is random...

ensure that followers are drawn AFTER the leader!

"dynamic" size of object list, depending on what is used
 - eg 16 bit positions  -but now children when not needed etc

scores
variables

optimize position/speed changes with inca ... (in one function???)

generate smartlists
add aky sound player
add a delay for actions (otherwise player shots are way to many)
vectorlists
delta steps for sprite per animation step
timer that only triggers once

vectorlists


done: restrict sprites to given number in level        
done: position = fixer offset zu anderem Sprite -> usage of DATA-W für anderen sprite
done: Analoge Werte einschränken? (nur von -100 - 100)
done: analog input
done: table of triggers auto resize
done: spawn from player with offset
done x,y bounding border offsets
done: if EXACTLY the same trigger is added twice, than only once instance of the trigger is generated,
      which executes BOTH results (this also works for timers)
done: add sprite
done: and sprite <-> sprite colision
done: sprite height, width offset as 2 values x,y comma seperated in one box
done: new x, y function rand(x), x = (1-9)
done: trigger can trigger SOUND effect (with help of dummy sound action in sprite)
done: random



questions
// todo: what is an enemy? as of now only "patrols"
// only do col detect for player shots every other round?

info:
long timer patrol and text are mutual exclusive, usage of DATA


done multiple spawn of sprites in init - with different positions csv in field
done add text "sprite" (timed display etc)
done "speed change" -> and remove action changes for player input? for test...
     than the target target "speed change" can be applied - no need to have different actions!
done? check collision map generation, that no player shots are used there!
done: enable joystick stuff, which direction to get etc
done: setupNewAction in one go
- done next generators
- partialy done: shots behaviouss
done do all speeds with ?_DELTA
done?   space optimization... if 

*/                

/*
Thoughts:
// optimization
// a) generate a (shrinkable) boundding box with the sprite (s)
//    it and look that one up
//    than only 4 comparissons are needed
// b) only do that for every other (or so) round

// actual colision check is done in the 
// "enemy" code
// here only a flag is checked,
// whether the enemy was colided last round.

Player versus Sprite
- checks are always done in the Sprite (not the player)
- checks with "correct" current action
- these are done on a 1:1 basis, the opponent sprite KNOWS there is only one player (or two)
  and can thus do specific checks versus that player -> efficient

Player versus Player
- checks are always done in the player1
- checks with "correct" current action
- efficient checks, only done once

Sprite versus Sprite
- for this to work CORRECTLY
  it is needed, that each sprite has a unique UID - manually given in the GUI!!!
- these checks are not efficient
  since collision detection is NOT 1:1
  each sprite interested in colliding with another sprite
  goes each round thru ALL sprites and tries to find a sprite it may collide with
  if it finds one - a collision check is done -> the first found collision is "reported"
  if collision did not happen the checks continue (probably all other sprites are iterated thru)

- unfortunatley 
  playerShots <-> enemy sprites also fall under this category

- todo: configure, that collision checks can internally alternate to different rounds (even/odd, every three rounds etc)


NOTE!
A collision detection ALWAYS informs both sprites, the collider and the collidee!
It is enough to add detection to one object, the other object can 
without any addition collision detection REACT on the colision by using 
the "sprite receive collision" trigger cause!













Trigger
maxSpriteObjects = 40; is fixed now!!!

Bounding box values in the GUI
can start with "#" (Hashtag)
Than these values will be taken directly - they will not 
modify the calculated values


In general
 - cause, y, x ticks are trigger "origins"
 - ->target, ->action, ->sprite, ->Y, ->X are things that are changed after the trigger is executed
- exception!
  if cause is a sprite collision, THAN -> sprite is the sprite which is tested upon!
  -> a sprite collision can as of now not SPAWN another sprite
  (sprite collision, shot coliision, enemy collision etc)
 - ->Y, and ->X
   are used for position, speed change, level change - ...
- in target values changes, following things can be used:
  * # number -> an immediate number
  * 'x' -> no change
  * ++ old value plus 1
  * -- old value minus 1
  * +=x old value plus x (x from 1 to 9)
  * -=x old value minus x (x from 1 to 9)
  * =XXX  XXX a global variable
  * neg -> inverse the old value
  * rand(+-x) number = range, + = only positive, - = only negative, +- in both directions, x number between 1-9

- each trigger can only cause 1 result
- long timer and timer can only be used ONCE per action, they are reloaded upon execution



PLAYER:
- if "mchangeWhileActiveY" is (string) "ay" - than position of the sprite is the analog joystick value
  if followed by a number 1-127, than that is +- max and lowest that analog can be
- this kind of movement can not be "blocked" - since it can "jump"

- joystick movement / buttons ...
 - position
   needs x, y position
 - timer
   needs tick
 - long timer
   needs tick -> uses DATA_W
 - sprite collision 
   needs sprite
 - sprite no collision 
   if a specific collision does not happen
   needs sprite
   
    
 - enemy shot collision 
   -> needs a sprite ID of the shot!
 - on creation
   as of now only done for follow sprites!

ENEMY:
 - position
   needs x, y position
 - timer
   needs tick
 - sprite collision, not done for non player collision
 - player shot collision 
    -> needs a sprite ID of the shot!

Results
- action change
  needs action of same sprite
- spawn sprite
  needs sprite ID, sprite action is default
    // a simple number -> a position
    // a "d" + simple number -> a delta position from spawn parents position
    // a "=" + varname -> load contents of variable
    // a "rand" a random value
    //          rand(+-100)
    //          rand(+100)  == rand(100)
    //          rand(-100)
- remove
  removes THIS sprite
- remove all
  removes all sprites of one "sprite ID"
  This is mainly a circumvention of the gui to not need another sprite field.
  All text sprites have a "dummy" id of zero (0)
  you should not use that ID for any other sprites!

- setPosition
  uses Y,X (as new position)
- speed change
  uses Y,X m (as new speed)
- next level
- set level
  if equal level - level is NOT reinitiated!
- variable change
  in ->y a variable name
  in ->x a "changer" (pp, neg ...)
- intensity change
  in ->y a "changer" (pp, neg ...)
- play sfx
  -> uses an Action of this sprite to play a sound
     the action only needs to contain sound information, 
     everything else is ignored!
- random spawn
  builds a random number between 0-255
  compares the result with what is given in Y
  if result is <= Y, than the spawn happens!
- block movement
  !!! attention bounding box collision detection!
  if e.g. for different directions different actions (vectorlists) are used
  than it can happen, that these vectorlists generate different sized bounding boxes
  -> than it can happen, that e.g. going up gets you deeper in the sprite than a bounding
  box with another actions vectorlists does
  if that happens the sprite will have blocked movement overall, since all sprites that
  would "get you away" overlapp from the very start.
  For that you can define a bounding box with EXACTLY the same values ...



Behaviour

follow sprite -> sprite to follow in DATA_W, offsets to follow in DELTA_X, DELTA_Y
                 follow sprites are only allowed to be spawned by their "parent"
                 follow sprites are removed, when leader is removed
                 (possible follow loops are not "cleared" or tested)
                 ! only allowed depth 1, no follower of followers! -> this may result in crash due to stack collisions!

*/


/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.veccy;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.graphics.GFXVector;
import de.malban.graphics.GFXVectorAnimation;
import de.malban.graphics.GFXVectorList;
import de.malban.graphics.Vertex;
import de.malban.gui.dialogs.ShowWarningDialog;
import de.malban.gui.panels.LogPanel;
import static de.malban.util.UtilityString.IntX;
import static de.malban.util.UtilityString.Int0;
import static de.malban.util.UtilityString.cleanCSV;


import static de.malban.gui.panels.LogPanel.WARN;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.ERROR;
import static de.malban.gui.panels.LogPanel.WARN;
import static de.malban.util.UtilityFiles.copyOneFile;
import static de.malban.util.UtilityString.replaceToNewFile;
import static de.malban.util.UtilityString.replace;
import static de.malban.util.UtilityFiles.createTextFile;
import static de.malban.util.UtilityString.cleanSplitNL;
import static de.malban.util.UtilityString.readTextFileToString;
import static de.malban.vide.veccy.ActionPanel.BLOW;
import de.malban.vide.vedi.VediPanel;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;
import javax.swing.JOptionPane;

/**
 *
 * @author salom
 */
public class GameGenerator 
{
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    VeccyPanel veccy=null;
    String name="";
    
    private GameDataPool mGameDataPool;
    private LevelDataPool mLevelDataPool;
    private ActionNewDataPool mActionDataPool;
    private SpriteDataPool mSpriteDataPool;
    private BackGroundScenePool mBackGroundScenePool;
    private LevelObjectDataPool mLevelObjectDataPool;
    private ActionTriggerDataPool mTriggerPool;
    private ActionResultDataPool mResultPool;


    private GameData mGameData;
    private LevelData mLevelData;
    private ActionNewData mActionData;
    private SpriteData mSpriteData;
    private BackGroundScene mSceneData;
    private LevelObjectData mLevelObjectData;

    private HashMap<String, String> mSceneDone = new HashMap<String, String>();
    private HashMap<String, String> mSpritesDone = new HashMap<String, String>();
    private HashMap<String, String> mVectorlistDone = new HashMap<String, String>();
    private HashMap<String, String> mAFXDone = new HashMap<String, String>();
    private HashMap<String, String> mtextDone = new HashMap<String, String>();
    private HashMap<String, String> mSmartlistFunctions = new HashMap<String, String>();
    private HashMap<String, String> mTriggerForActionDone = new HashMap<String, String>();

    private HashMap<String, String> mSpriteVersusSpriteDone = new HashMap<String, String>();
    
    private boolean smartlistUsed = false;

    // todo
    private boolean hasAFX = true;
    private boolean has5Font = true;
    private boolean hasStandardFont = true;
    
    StringBuilder SB_sceneList = new StringBuilder();
    StringBuilder SB_vectorLists = new StringBuilder();
    StringBuilder SB_actionCode = new StringBuilder();
    StringBuilder SB_spriteInitCode = new StringBuilder();
    StringBuilder SB_levelInclude = new StringBuilder();
    StringBuilder SB_additionalFunctions = new StringBuilder();
    StringBuilder SB_AFXSounds = new StringBuilder();

    ArrayList levelList = new ArrayList();
    
    
    boolean doGenerateBaseData = true;
    boolean font5TextRoutineDone = false;
    boolean fontStandardTextRoutineDone = false; 
    boolean font5MultiTextRoutineDone = false;
    boolean fontStandardMultiTextRoutineDone = false; 
    
    public GameGenerator(VeccyPanel vp, String n)
    {
        veccy = vp;
        name = n;

        mActionDataPool = new ActionNewDataPool();
        mSpriteDataPool = new SpriteDataPool();
        mBackGroundScenePool = new BackGroundScenePool();
        mGameDataPool = new GameDataPool();
        mLevelObjectDataPool = new LevelObjectDataPool();
        mLevelDataPool = new LevelDataPool();

        mTriggerPool = new ActionTriggerDataPool();
        mResultPool = new ActionResultDataPool();

    }
    
    public void generateGame()
    {
        String gameName = de.malban.util.UtilityString.onlyUpperASCIINo(de.malban.util.UtilityString.replaceWhiteSpaces(File.separator+name, "_"));
        String gamePathString = Global.mainPathPrefix+ "projects"+File.separator+gameName;
        String upperTemplatePathString = Global.mainPathPrefix+ "template";
        String templatePathString = Global.mainPathPrefix+ "template"+File.separator+"game";
        SB_levelInclude = new StringBuilder();
        
        Path gamePath = Paths.get(gamePathString);

        if (!gamePath.toFile().exists())
        {
            // create dir
            File file = gamePath.toAbsolutePath().toFile();
            boolean b = file.mkdir();
            if (!b)
            {
                JOptionPane.showMessageDialog(Configuration.getConfiguration().getMainFrame(), 
                "Failed to create directory!\n"+gamePath.toAbsolutePath(),
                "Directory creation failed",
                 JOptionPane.ERROR_MESSAGE);

                return;
            }
        }
        // Project file
        Path templatePath = Paths.get(templatePathString,"GameTemplateProjectProperty.xml");
        Vector<String> searchFor = new Vector<String>();
        Vector<String> replaceWith = new Vector<String>();
        
        searchFor.add("<Name>GameTemplate</Name>");
        replaceWith.add("<Name>"+gameName+"</Name>");
        replaceToNewFile(new File(templatePath.toString()), 
                         new File(gamePathString+File.separator+gameName+"ProjectProperty.xml"), 
                         searchFor, replaceWith);
        searchFor.clear();replaceWith.clear();

        templatePath = Paths.get(templatePathString,"gameConfig.i");
        copyOneFile(templatePath.toString(), gamePathString+File.separator+"gameConfig.i");
        
        templatePath = Paths.get(templatePathString,"object.asm");
        copyOneFile(templatePath.toString(), gamePathString+File.separator+"object.asm");

        templatePath = Paths.get(templatePathString,"ram.i");
        copyOneFile(templatePath.toString(), gamePathString+File.separator+"ram.i");

        if (hasAFX)
        {
            templatePath = Paths.get(templatePathString,"ayfxPlayer_channel1.i");
            copyOneFile(templatePath.toString(), gamePathString+File.separator+"ayfxPlayer_channel1.i");
            templatePath = Paths.get(templatePathString,"ayfxPlayer_channel2.i");
            copyOneFile(templatePath.toString(), gamePathString+File.separator+"ayfxPlayer_channel2.i");
            templatePath = Paths.get(templatePathString,"ayfxPlayer_channel3.i");
            copyOneFile(templatePath.toString(), gamePathString+File.separator+"ayfxPlayer_channel3.i");
        }
        
        if (has5Font)
        {
            templatePath = Paths.get(templatePathString,"font_5.asm");
            copyOneFile(templatePath.toString(), gamePathString+File.separator+"font_5.asm");
        }
        if (hasStandardFont)
        {
            templatePath = Paths.get(templatePathString,"font_standard.asm");
            copyOneFile(templatePath.toString(), gamePathString+File.separator+"font_standard.asm");
        }
        
        templatePath = Paths.get(templatePathString,"vectrex.i");
        copyOneFile(templatePath.toString(), gamePathString+File.separator+"vectrex.i");

        templatePath = Paths.get(templatePathString,"macro.i");
        copyOneFile(templatePath.toString(), gamePathString+File.separator+"macro.i");
        
        generateLevels(gamePathString);
        createTextFile(gamePathString+File.separator+"vectorlists.i", SB_vectorLists.toString());

        String smText = buildSmartlistFunctions(mSmartlistFunctions);
        createTextFile(gamePathString+File.separator+"genSmartlist.i", smText);
        
        // Main file
        templatePath = Paths.get(templatePathString,"main.asm");
        searchFor.add("\"GAME_NAME\",");
        replaceWith.add("\""+gameName+"\",");
        
        if (smartlistUsed)
        {
            searchFor.add(";                   include  \"vectorlists.i\"");
            replaceWith.add("                    include  \"vectorlists.i\"");

            // add smartlist definitions
            searchFor.add(";                   include  \"smartlist.asm\"");
            replaceWith.add("                    include  \"genSmartlist.i\"");
/*
            StringBuilder sb = new StringBuilder();
            Vector<String> lines = readTextFileToString(Paths.get(upperTemplatePathString,"smartListAnim.template").toFile());
            boolean addLine = true;
            
            for (int i=0; i<lines.size(); i++)
            {
                String line = lines.elementAt(i);
                if (line.contains("; VIDE_RM_START")) addLine=false;
                if (addLine) sb.append(line).append("\n");
                if (line.contains("; VIDE_RM_END")) addLine=true;
            }
            String fileText = sb.toString();
            fileText = fileText.replace("; nop", "  nop");

            
            fileText = fileText.replace("##SCALE##", "9");
            createTextFile(gamePathString+File.separator+"smartlist.asm", fileText);
*/            
        }

        SB_levelInclude.append("; ------------------\n");
        SB_levelInclude.append("allLevelList:\n");
        for (int i=0; i<levelList.size(); i++)
        {
            SB_levelInclude.append("\tDW "+levelList.get(i).toString()+"\n");
        }
            SB_levelInclude.append("\tDW 0\n");
        SB_levelInclude.append("; ------------------\n");
        
        
        searchFor.add(";LEVEL_INCLUDE_FILES");
        replaceWith.add(SB_levelInclude.toString());
                      
        // last insert main file with all replacements
        replaceToNewFile(new File(templatePath.toString()), 
                         new File(gamePathString+File.separator+"main.asm"), 
                         searchFor, replaceWith);    
                
        searchFor.clear();replaceWith.clear();

        
        // compile start the game
        if (veccy != null)
        {
            veccy.startASM(gamePathString+File.separator+"main.asm");
        }
    }
    
    private void generateLevels(String destPath)
    {
        Collection<String> collectionKlasse = mLevelDataPool.getKlassenHashMap().values();
        Iterator<String> iterKlasse = collectionKlasse.iterator();
        int i = 0;
        String klasse =     name+"_Levels";

        Collection<LevelData> colC = mLevelDataPool.getMapForKlasse(klasse).values();
        List list = new ArrayList(colC);
        Collections.sort(list, new Comparator<LevelData>()
                {
                   public int compare(LevelData o1, LevelData o2)
                   {
                      return o1.mLevelOrder - o2.mLevelOrder;
                   }
                } );        
        Iterator<LevelData> iterC = list.iterator();
        int no=1;
        while (iterC.hasNext())
        {
            mLevelData = iterC.next();

            generateOneLevel(destPath, no++);
        }
    }
    
    // Object types: Sprite, Background Scene, Foreground VList, Global variable
    public void generateOneLevel(String destPath, int no)
    {
        String klasse = mLevelData.mName;
        Collection<LevelObjectData> colC = mLevelObjectDataPool.getMapForKlasse(klasse).values();
        Iterator<LevelObjectData> iterC = colC.iterator();

        int maxSpriteObjects = 0;
        SB_sceneList = new StringBuilder();
        SB_spriteInitCode = new StringBuilder();
        SB_actionCode = new StringBuilder();
        SB_additionalFunctions = new StringBuilder();

        SB_sceneList.append("SceneList"+no+":\n");

        ArrayList lateCommer = new ArrayList();
        while (iterC.hasNext())
        {
            mLevelObjectData = iterC.next();
            doGenerateBaseData = true;
            if (mLevelObjectData.mType.equals("Sprite"))
            {
                maxSpriteObjects += mLevelObjectData.mMaxLiveObjects;
            }
            generateOneLevelObject();
        }
        maxSpriteObjects = 40;
        
        SB_sceneList.append("\tDW       0; 0 terminated list of all scenes");
        if (maxSpriteObjects == 0) maxSpriteObjects = 1; // one at least!
        
        int maxObjects = colC.size();
        
        StringBuilder ram = new StringBuilder();
        ram.append("MAX_OBJECT_L"+no+" = "+maxSpriteObjects+"\n");
        ram.append("\n");
        ram.append("; ---------------------------------- \n");
        ram.append("\n");
        ram.append("\tbss\n");
        ram.append("\n");
        ram.append("\torg LEVEL_RAM\n");

        ram.append("object_list_L"+no+"\tds\tObjectStruct*("+maxSpriteObjects+")\n");
        ram.append("object_list_end_L"+no+"\tds\t0\n");
        ram.append("\n");
        ram.append("; ---------------------------------- \n");
        ram.append("\n");

        ram.append("; ---------------------------------- \n");
        ram.append("; --------- FOR DEBUGGING ---------- \n");
        ram.append("; ---------------------------------- \n");
        for (int i=0; i<maxSpriteObjects; i++)
        {
            ram.append("L"+no+"OBJECT_"+i+"_YPOS = "+i+"*ObjectStruct+object_list_L"+no+"+(Y_POS)\n");
            ram.append("L"+no+"OBJECT_"+i+"_XPOS = "+i+"*ObjectStruct+object_list_L"+no+"+(X_POS)\n");
            ram.append("L"+no+"OBJECT_"+i+"_BEHAVIOUR = "+i+"*ObjectStruct+object_list_L"+no+"+(BEHAVIOUR)\n");
            ram.append("L"+no+"OBJECT_"+i+"_NEXT_OBJECT = "+i+"*ObjectStruct+object_list_L"+no+"+(NEXT_OBJECT)\n");
            ram.append("L"+no+"OBJECT_"+i+"_DATA_W = "+i+"*ObjectStruct+object_list_L"+no+"+(C_DATA_W)\n");
            ram.append("L"+no+"OBJECT_"+i+"_COUNTER = "+i+"*ObjectStruct+object_list_L"+no+"+(C_COUNTER)\n");
            ram.append("L"+no+"OBJECT_"+i+"_DATA_B1 = "+i+"*ObjectStruct+object_list_L"+no+"+(C_DATA_B1)\n");
            ram.append("L"+no+"OBJECT_"+i+"_DATA_POS = "+i+"*ObjectStruct+object_list_L"+no+"+(C_DATA_POS)\n");
            ram.append("L"+no+"OBJECT_"+i+"_DATA_B2 = "+i+"*ObjectStruct+object_list_L"+no+"+(C_DATA_B2)\n");
            ram.append("L"+no+"OBJECT_"+i+"_INTENSITY = "+i+"*ObjectStruct+object_list_L"+no+"+(C_INTENSITY)\n");
            ram.append("L"+no+"OBJECT_"+i+"_TIMER = "+i+"*ObjectStruct+object_list_L"+no+"+(C_TIMER)\n");
            ram.append("L"+no+"OBJECT_"+i+"_ANIM_PLACE = "+i+"*ObjectStruct+object_list_L"+no+"+(C_ANIM_PLACE)\n");
            ram.append("L"+no+"OBJECT_"+i+"_FLAG = "+i+"*ObjectStruct+object_list_L"+no+"+(C_FLAG)\n");
            ram.append("L"+no+"OBJECT_"+i+"_Y_DELTA = "+i+"*ObjectStruct+object_list_L"+no+"+(C_Y_DELTA)\n");
            ram.append("L"+no+"OBJECT_"+i+"_X_DELTA = "+i+"*ObjectStruct+object_list_L"+no+"+(C_X_DELTA)\n");
            ram.append("L"+no+"OBJECT_"+i+"_HEIGHT = "+i+"*ObjectStruct+object_list_L"+no+"+(C_HEIGHT)\n");
            ram.append("L"+no+"OBJECT_"+i+"_WIDTH = "+i+"*ObjectStruct+object_list_L"+no+"+(C_WIDTH)\n");
            ram.append("L"+no+"OBJECT_"+i+"_COLLISION_ID = "+i+"*ObjectStruct+object_list_L"+no+"+(C_COLLISION_ID)\n");
        }

        ram.append("; ---------------------------------- \n");
        ram.append("; --------- FOR DEBUGGING END ------ \n");
        ram.append("; ---------------------------------- \n");
   
        
        levelList.add("initLevel_"+no);
        
        
        StringBuilder code = new StringBuilder();
        code.append("\tcode\n");
        code.append("\n");
        code.append("; ---------------------------------- \n");
        code.append("\n");
        code.append("initLevel_"+no+":\n");
        code.append("; first initialize the object list, so it builds a continous list\n");
        code.append("\tlda      #MAX_OBJECT_L"+no+"\n");
        code.append("\tldu      #object_list_L"+no+"\n");
        code.append("\tjsr      initObjects_ua\n");
        code.append("\tldd      #SceneList"+no+"\n");
        code.append("\tstd      sceneListForLevel\n");

        if (levelHasAnalog())
        {
            code.append("\tlda      #LEVEL_USES_ANALOG_INPUT\n");
        }
        else
            code.append("\tlda      #0\n");
        code.append("\tsta      currentLevelFlags\n");
        
        
        

        
        code.append("\n");
        code.append(SB_spriteInitCode);

        
        code.append("\trts\n");
        code.append("\n");
        code.append("; ---------------------------------- \n");
        code.append("\n");
        code.append(SB_actionCode);
        code.append("\n");
        code.append("; ---------------------------------- \n");
        code.append("\n");

        code.append("; ----------------------------------\n");
        code.append("; ----- ADDITIONAL FUNCTIONS -------\n");
        code.append("; -------- SPRITE INIT -------------\n");
        code.append("; ----------------------------------\n");


        code.append(SB_additionalFunctions);
        code.append("; ----------------------------------\n");
        code.append("; ----- ADDITIONAL FUNCTIONS -------\n");
        code.append("; ------- SPRITE INIT END ----------\n");
        code.append("; ----------------------------------\n");
        code.append("\n");
        code.append("; ---------------------------------- \n");
        code.append(SB_sceneList);
        code.append("; ---------------------------------- \n");
        code.append("\n");
        code.append("; ---------------------------------- \n");
        code.append(SB_AFXSounds);
        code.append("; ---------------------------------- \n");
        code.append("\n");

        
        String pptext = VediPanel.prettyPrint(ram.toString() + code.toString());

        
        createTextFile(destPath+File.separator+"levelRoutines_"+no+".i", pptext);
        SB_levelInclude.append("\t include \""+"levelRoutines_"+no+".i"+"\" \n");
    }
    public void generateOneLevelObject()
    {
        if (mLevelObjectData.mType.equals("Sprite"))
        {
            generateSprite();
        }
        if (mLevelObjectData.mType.equals("Background Scene"))
        {
            generateScene();
        }
    }

    // from current sprite pool (from current level)
    SpriteData getSpriteByID(String spriteID)
    {
        SpriteData spriteData = mSpriteDataPool.getMapForKlasse("AllSprites").get(spriteID);
        return spriteData;
    }
    
    // expecting there is only 1 player one - if more than one, than it returns the first found
    ActionNewData getPlayer1()
    {
        Collection<LevelObjectData> colCo = mLevelObjectDataPool.getMapForKlasse(mLevelData.mName).values();
        Iterator<LevelObjectData> iterCo = colCo.iterator();
        
        while (iterCo.hasNext())
        {
            LevelObjectData levelObjectData = iterCo.next();
            if (levelObjectData.mType.equals("Sprite"))
            {
                SpriteData spriteData = mSpriteDataPool.getMapForKlasse("AllSprites").get(levelObjectData.mSpriteID);
                if (spriteData == null) 
                    continue;
                Collection<ActionNewData> colCa = mActionDataPool.getMapForKlasse(spriteData.mName+"_Actions").values();
                Iterator<ActionNewData> iterCa = colCa.iterator();

                ActionNewData actionData = getDefaultAction(spriteData);
                if (actionData==null) continue;

                // we assume ALL actions of one sprite are player controlled... or at least the default!
                if (actionData.mbehaviour.equals("player 1 controlled"))
                    return actionData;
            }
        }
        return null;
    }

    // expecting there is only 1 player one - if more than one, than it returns the first found
    SpriteData getPlayer1Sprite()
    {
        Collection<LevelObjectData> colCo = mLevelObjectDataPool.getMapForKlasse(mLevelData.mName).values();
        Iterator<LevelObjectData> iterCo = colCo.iterator();
        
        while (iterCo.hasNext())
        {
            LevelObjectData levelObjectData = iterCo.next();
            if (levelObjectData.mType.equals("Sprite"))
            {
                SpriteData spriteData = mSpriteDataPool.getMapForKlasse("AllSprites").get(levelObjectData.mSpriteID);
                if (spriteData == null) 
                    continue;
                Collection<ActionNewData> colCa = mActionDataPool.getMapForKlasse(spriteData.mName+"_Actions").values();
                Iterator<ActionNewData> iterCa = colCa.iterator();

                ActionNewData actionData = getDefaultAction(spriteData);
                if (actionData==null) continue;

                // we assume ALL actions of one sprite are player controlled... or at least the default!
                if (actionData.mbehaviour.equals("player 1 controlled"))
                    return spriteData;
            }
        }
        return null;
    }

    // expecting ther is only 1 player two - if more than one, than it returns the first found
    ActionNewData getPlayer2()
    {
        Collection<LevelObjectData> colCo = mLevelObjectDataPool.getMapForKlasse(mLevelData.mName).values();
        Iterator<LevelObjectData> iterCo = colCo.iterator();
        
        while (iterCo.hasNext())
        {
            LevelObjectData levelObjectData = iterCo.next();
            if (levelObjectData.mType.equals("Sprite"))
            {
                SpriteData spriteData = mSpriteDataPool.getMapForKlasse("AllSprites").get(levelObjectData.mSpriteID);
                if (spriteData==null) continue;
                Collection<ActionNewData> colCa = mActionDataPool.getMapForKlasse(spriteData.mName+"_Actions").values();
                Iterator<ActionNewData> iterCa = colCa.iterator();

                ActionNewData actionData = getDefaultAction(spriteData);
                if (actionData==null) continue;

                // we assume ALL actions of one sprite are player controlled... or at least the default!
                if (actionData.mbehaviour.equals("player 2 controlled"))
                    return actionData;
            }
        }
        return null;
    }

    // expecting there is only 1 player two - if more than one, than it returns the first found
    SpriteData getPlayer2Sprite()
    {
        Collection<LevelObjectData> colCo = mLevelObjectDataPool.getMapForKlasse(mLevelData.mName).values();
        Iterator<LevelObjectData> iterCo = colCo.iterator();
        
        while (iterCo.hasNext())
        {
            LevelObjectData levelObjectData = iterCo.next();
            if (levelObjectData.mType.equals("Sprite"))
            {
                SpriteData spriteData = mSpriteDataPool.getMapForKlasse("AllSprites").get(levelObjectData.mSpriteID);
                if (spriteData == null) 
                    continue;
                Collection<ActionNewData> colCa = mActionDataPool.getMapForKlasse(spriteData.mName+"_Actions").values();
                Iterator<ActionNewData> iterCa = colCa.iterator();

                ActionNewData actionData = getDefaultAction(spriteData);
                if (actionData==null) continue;

                // we assume ALL actions of one sprite are player controlled... or at least the default!
                if (actionData.mbehaviour.equals("player 2 controlled"))
                    return spriteData;
            }
        }
        return null;
    }

    //private BackGroundScene mSceneData;
    public void generateScene()
    {
        // ensure no scene code is generated more than once
        doGenerateBaseData = !mSceneDone.containsKey(mLevelObjectData.mScene);
        String klasse = "AllScenes";
        mSceneData = mBackGroundScenePool.getMapForKlasse(klasse).get(mLevelObjectData.mScene);

        if (doGenerateBaseData) generateSceneVectorlist();
        SB_sceneList.append("\tDW        "+mSceneData.mName+"\n");

        if (doGenerateBaseData)
           mSceneDone.put(mLevelObjectData.mScene, mLevelObjectData.mScene);
    }
    void generateSceneVectorlist()
    {
        if (mVectorlistDone.containsKey(mSceneData.msceneFile)) return;

        GFXVectorAnimation animation = new GFXVectorAnimation();
        boolean ok = animation.loadFromXML(mSceneData.msceneFile);
        if (!ok)
        {
            log.addLog("Error loading scene: "+mSceneData.msceneFile, ERROR);
            return;
        }
        smartlistUsed = true;
        
        GenerationParameters p = new GenerationParameters();
        p.compileForVB = true; // use stack for object list 
        p.rts2 = false; //  rts 2
        p.paraName = mSceneData.mName;
        p.doNoPositionMove = false;
        veccy.setParameters(p);

        SB_vectorLists.append(";\n");
        SB_vectorLists.append(";Vectorlists for scene: "+mSceneData.mName+"\n");
        SB_vectorLists.append(";\n");
        SB_vectorLists.append(p.paraName+":\n");
        SB_vectorLists.append(veccy.buildSmartScenarioListG(false, animation, mSmartlistFunctions));
        mVectorlistDone.put(mSceneData.msceneFile, p.paraName);
    }

    
    // this sets 
    // globals: mSpriteData and mActionData
    // as current "handled" entities!
    // these are used in subsequent functions
    public void generateSprite()
    {
        // ensure no sprite code is generated more than once
        
        String klasse = "AllSprites";
        mSpriteData = mSpriteDataPool.getMapForKlasse(klasse).get(mLevelObjectData.mSpriteID);
        if (mSpriteData == null) return;
        doGenerateBaseData = !mSpritesDone.containsKey(mSpriteData.mName);
        
        // iterate all actions of this sprite
        int i = 0;
        klasse = mSpriteData.mName+"_Actions";
        Collection<ActionNewData> colC = mActionDataPool.getMapForKlasse(klasse).values();
        Iterator<ActionNewData> iterC = colC.iterator();
        while (iterC.hasNext())
        {
            mActionData = iterC.next();
            generateAction();
        }
        
        // flag just generated sprite as 
        // done
        if (doGenerateBaseData)
            mSpritesDone.put(mSpriteData.mName, mSpriteData.mName);
    }
    public void generateAction()
    {
        // vectorlists are generated ONCE only
        if (doGenerateBaseData) generateActionVectorlist();
    
        mTriggerForActionDone = new HashMap<String, String>();
        
        
        // part of the action code is generated more than once 
        // e.g. initialization of sprites in the init function of the game
        // if they are used more than once
        generateActionCode();
    }
    int initUID = 0;
    void generateActionCode()
    {
        initUID++;
        String spriteName =  mSpriteData.mName;
        String actionName =  mSpriteData.mName+mActionData.mName+"Behaviour";
        String defaultName =  mSpriteData.mName+"DefaultBehaviour";
        String defaultActionName = mSpriteData.mDefaultActionID;
        String vectorAnimName = mSpriteData.mName+"_"+mActionData.mName;
        
        boolean isTextSprite = isText(mSpriteData);
        boolean isTriggerOnly = mActionData.mbehaviour.equals("trigger only");
        int animationCount = 0;
        GFXVectorAnimation animation = new GFXVectorAnimation();
        if (animation.loadFromXML(mActionData.manimationFile))
            animationCount = animation.size();
        if (doGenerateBaseData)
        {
            SB_actionCode.append("; ********************************** \n");
            SB_actionCode.append("; ************ Code for ************\n");
            SB_actionCode.append("; *** Sprite: "+mSpriteData.mName+" \n");
            SB_actionCode.append("; *** Action: "+mActionData.mName+" \n");
            SB_actionCode.append("; ********************************** \n");
        }
        if (defaultActionName.equals(mActionData.mName))
        {
            if (mLevelObjectData.mLiveOnInit)
            {
                SB_spriteInitCode.append("; --- init sprite: "+mSpriteData.mName+"\n");
                if (mLevelObjectData.myPos.contains(","))
                {
                    String[] yParts = cleanCSV(mLevelObjectData.myPos);
                    String[] xParts = cleanCSV(mLevelObjectData.mxPos);
                    if (yParts.length != xParts.length)
                    {
                        ShowWarningDialog.showWarningDialog("Coordinate size mismatch!", "Number of Y and X coordinates do not match! ("+mSpriteData.mName+")");
                    }
                    SB_spriteInitCode.append("\tbra      "+mLevelObjectData.mSpriteID+"InlinePosDataDone"+initUID+"\n");
                    SB_spriteInitCode.append(mLevelObjectData.mSpriteID+"InlinePosData"+initUID+":\n");

                    for (int i=0;i<yParts.length;i++)
                    {
                        int y = Int0(yParts[i]);
                        int x = 0;
                        if (xParts.length>i)
                            x = Int0(xParts[i]);
                        SB_spriteInitCode.append("\tDB      "+String.format("$%02X",(y&0xff) )+", "+String.format("$%02X",(x&0xff) ) +"\n");
                    }
                    SB_spriteInitCode.append(mLevelObjectData.mSpriteID+"InlinePosDataDone"+initUID+":\n");
                    SB_spriteInitCode.append("\tlda      #"+(yParts.length-1)+" ; \n");
                    SB_spriteInitCode.append("\tsta      temp8bit ; \n");
                    SB_spriteInitCode.append(mLevelObjectData.mSpriteID+"Init"+initUID+":\n");
                    SB_spriteInitCode.append("\tbmi      "+mLevelObjectData.mSpriteID+"Init"+initUID+"Done\n");
                    

                    // no testing for object overflow is done (on init)!!!
                    SB_spriteInitCode.append("\tjsr      newObject\t; return pointer to U \n");
                    SB_spriteInitCode.append(" ; no overflow testing is done during init \n");

                    SB_spriteInitCode.append("\tldx      #"+mLevelObjectData.mSpriteID+"InlinePosData"+initUID+"\n");
                    SB_spriteInitCode.append("\tlda      temp8bit\n");
                    SB_spriteInitCode.append("\tasla\n");
                    SB_spriteInitCode.append("\tldd      a,x\n");
                    SB_spriteInitCode.append("\tstd      Y_POS,u\n");

                    SB_spriteInitCode.append("\tldx      #" + mLevelObjectData.mSpriteID+"DefaultBehaviour" +  " ; sprites always start with their default behaviour\n");
                    String functionName = functionalizeNewAction(mSpriteData, mActionData, "u", false);
                    SB_spriteInitCode.append("\tjsr      "+functionName+"\n");
// assuming init sprites never follow "parent direction"                    
// todo followers for multi init?        
                    SB_spriteInitCode.append("\tdec      temp8bit\n");
                    SB_spriteInitCode.append("\tbra      "+mLevelObjectData.mSpriteID+"Init"+initUID+"\n");

                    SB_spriteInitCode.append(mLevelObjectData.mSpriteID+"Init"+initUID+"Done:\n");
                    
                }
                else
                {
                    String pos = String.format("$%04X",((Int0(mLevelObjectData.myPos)*256)&0xff00) + ((Int0(mLevelObjectData.mxPos))&0xff) );

                    // generate init code

                    // no testing for object overflow is done (on init)!!!
                    SB_spriteInitCode.append("\tjsr      newObject\t; return pointer to U \n");
                    SB_spriteInitCode.append(" ; no overflow testing is done during init \n");

                    // player 1
                    // assuming that is the one and only player 1
                    if (mActionData.mbehaviour.equals("player 1 controlled"))
                        SB_spriteInitCode.append("\tstu      main1Pointer ; store player one pointer for future use\n");
                    // player 2
                    // assuming that is the one and only player
                    if (mActionData.mbehaviour.equals("player 2 controlled"))
                        SB_spriteInitCode.append("\tstu      main2Pointer ; store player two pointer for future use\n");

                    SB_spriteInitCode.append("\tldx      #" + mLevelObjectData.mSpriteID+"DefaultBehaviour" +  " ; sprites always start with their default behaviour\n");
//                    if (!isTriggerOnly) // also do with triggers only - if a trigger only spawns a sprite, it needs a position as base for the sprite!
                    {
                        SB_spriteInitCode.append("\tldd      #"+pos+" ; setup with position \n");
                        SB_spriteInitCode.append("\tstd      Y_POS,u\n");
                    }
                    String functionName = functionalizeNewAction(mSpriteData, mActionData, "u", false);
                    SB_spriteInitCode.append("\tjsr      "+functionName+"\n");
// assuming init sprites never follow "parent direction"                    

                    // can this be put in functionalizeNewAction?
                    // not sure
                    
                    for (int eventCount = 0;eventCount<mActionData.meventUID.size();eventCount++)
                    {
                        ActionTriggerData trigger = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
                        ActionResultData result = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventCount));

                        // todo assume on creation is only one trigger - does not have more trigger parts
                        // otherwise we should use a function hasOnCreation(trigger) == true
                        if (trigger.mtriggerByCause.elementAt(0).equals("on creation"))
                        {
                            SB_spriteInitCode.append("\ttfr      u,y ; save u = created new sprite register usage in 'child'\n");
    //                        for (int i=0;i<mActionData.mtriggerByCause.size(); i++)
//                            for (int i=0;i<trigger.mtriggerByCause.size(); i++)
                            {
    //                            if (mActionData.mtriggerByCause.elementAt(i).equals("on creation"))
//                                if (trigger.mtriggerByCause.elementAt(i).equals("on creation"))
                                {
                                    SB_spriteInitCode.append("; ---- init child (follower) start ----\n");
                                    SB_spriteInitCode.append("\tjsr      newObject\t; return pointer to U \n");
                                    SB_spriteInitCode.append(" ; no overflow testing is done during init \n");

                                    ActionNewData saveAction = mActionData;
                                    SpriteData saveSprite = mSpriteData;

    // todo
    // only 1 result
                                    mSpriteData = getSpriteByID(result.mresultSpriteID.elementAt(0));
                                    mActionData = getActionByID(mSpriteData, mSpriteData.mDefaultActionID);

                                    SB_spriteInitCode.append("\tldx      #" + mSpriteData.mName+"DefaultBehaviour" +  " ; sprites always start with their default behaviour\n");

                                    String functionName2 = functionalizeNewAction(mSpriteData, mActionData, "u", false);
                                    SB_spriteInitCode.append("\tjsr      "+functionName2+"\n");
                                    if (mActionData.mbehaviour.equals("follow sprite"))
                                        SB_spriteInitCode.append("\tsty      C_DATA_W,u\n");

                                    mActionData = saveAction;
                                    mSpriteData = saveSprite;

                                    SB_spriteInitCode.append("; ---- init child (follower) end ----\n");
                                }
                            }
                        }
                    }
                }
            }
        }
        if (!doGenerateBaseData) return;    // ensure behaviours are only done once

        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; ------ BEHAVIOUR CODE START ------\n");
        SB_actionCode.append("; ----------------------------------\n");

        
        if (isTextSprite) 
        {
            SB_actionCode.append("; unique ID of the sprite this behaviour belongs to\n");
            SB_actionCode.append("; all objects need this, so remove all does not produce bad results!\n");
            SB_actionCode.append("\tDB      0 \n");
            SB_actionCode.append(defaultName+":\n");
        }
        else
        {
            SB_actionCode.append("; unique ID of the sprite this behaviour belongs to\n");
            SB_actionCode.append("; we need this for reference to know what collided with what\n");
            SB_actionCode.append("; and I don't want to waste a byte or two in the precious RAM list of objects\n");
            SB_actionCode.append("; ... so each behaviour has the ID of the sprite it belongs to\n");
            SB_actionCode.append("\tDB      "+mSpriteData.mspriteUID+" \n");
            
            if (mSpriteData.mDefaultActionID.equals(mActionData.mName))
                SB_actionCode.append(defaultName+":\n");
            SB_actionCode.append(actionName+":\n");
        }

        // text sprites have different moving from "list" sprites
        // (movement here as on screen movement for positioning the object, not "sprite movement")
        // "movement" of text is done
        // while printing the text
        if ((!isTextSprite) && (!isTriggerOnly))
        {
            addAnimationCode(animationCount);
        }
        
        boolean isPlayer1 = (mActionData.mbehaviour.equals("player 1 controlled"));
        boolean isPlayer2 = (mActionData.mbehaviour.equals("player 2 controlled"));

        // ----------------------------
        // non player movement
        // (special that is)
        // ----------------------------
        if (mActionData.mbehaviour.equals("patrol"))
        {
            addEnemyPatrolCode();
        }
        addMovementCode();
        // ----------------------------

        
        // ----------------------------
        // collision detection
        // ----------------------------
        if (isPlayer1(mSpriteData))
        {
            // player versus player is allways done in player1 !
            addPlayerVersusPlayerCollision();
        }
        
        // player collision routines (not triggered here -> setting of flags!)
        // ----------------------------
        // todo: think of 2 player games against each other
        if ((!isPlayer(mSpriteData)) && (!isTriggerOnly) && (!isTextSprite))
        {
            // any sprite that is not a player,
            // but a player has collision detection configured with
            // has collision detection with that player in its behaviour!
            addPlayerCollisionDetection();
            
            // non player: sprite versus sprite collision detection
            addNonPlayerCollisionDetection();
        }
        // ----------------------------
        // collision detection done
        // ----------------------------

        // ----------------------------
        // react on triggers
        // ----------------------------

        // player specific
        if (isPlayer(mSpriteData) )
        {
            // joystick / buttons
            // sprite collision reactions
            addPlayerActionCode(true);
        }
        else
        {
            // "trigger only" is added here
            // since I allow "trigger only" to react on buttons / joystick
            // eg to react on title screen...
            // other player actions are not relevant and canot be configured anyway
            // (sprite collision etc)
            if (mActionData.mbehaviour.equals("trigger only"))
                addPlayerActionCode(false);
        }
        
        // all other "normal" sprites
        // this is sprite <-> sprite collision reactions
        // text has no bounding box - and collision as of yet is not tested!
        if ((!isTextSprite) && (!isTriggerOnly) && (!isPlayer(mSpriteData)) )
        {
            // sprite collision reactions
            addSpriteActionCode();
        }

        // all sprites
        addSpriteTriggerTimerCode();
        addSpriteTriggerLongTimerCode();
        addSpriteTriggerPostionCode();

        // ----------------------------
        // react on triggers done
        // ----------------------------
        SB_actionCode.append(mSpriteData.mName+mActionData.mName+"BehaviourTriggerDone:\n");

        // ----------------------------
        // sprite movement
        // displaying
        // end finishing
        // ----------------------------
        if (isTextSprite)
        {
            printAndMoveText();
        }
        else if (isTriggerOnly) 
        {
            SB_actionCode.append("\tlds      S_NEXT_OBJECT,s ; load stack with the next object data\n");
            SB_actionCode.append("\tpuls     d,pc ; and jump to the next object in the object list\n");
        }
        else
        {

            // has this sprite a special intensity?
            if (mActionData.mintensity.length() != 0)
            {
                int intensity = IntX(mActionData.mintensity, 300);
                if (intensity != 300)
                {
                    SB_actionCode.append("\tlda      currentLevelFlags ; level flags\n");
                    SB_actionCode.append("\tora      #INTENSITY_IS_DEFAULT ; mark intensity as non standard\n");
                    SB_actionCode.append("\tsta      currentLevelFlags ; level flags\n");
                    
                    SB_actionCode.append("\tldb      INTENSITY,s ; load the current Intensity\n");
                }
                else
                {
                    if (mActionData.mintensity.startsWith("=")) // check for variable
                    {
                        SB_actionCode.append("\tlda      currentLevelFlags ; level flags\n");
                        SB_actionCode.append("\tora      #INTENSITY_IS_DEFAULT ; mark intensity as non standard\n");
                        SB_actionCode.append("\tsta      currentLevelFlags ; level flags\n");

                        SB_actionCode.append("\tldb      "+mActionData.mintensity.substring(1)+" ; load the current Intensity from variable\n");
                    }
                    else
                    {
                        // i dont know - change nothing?
                        ShowWarningDialog.showWarningDialog("Strange intensity settings", "I don't know how to handle the intensity. (Sprite: "+mSpriteData.mName+" action: "+mActionData.mName+")");
                    }
                }
                SB_actionCode.append("\tlds      S_NEXT_OBJECT,s ; load stack with the next object data\n");
            }
            else
            {
                SB_actionCode.append("\tlds      S_NEXT_OBJECT,s ; load stack with the next object data\n");
                // no special intensity for this sprite
                // but do we have cleanups from last round?
                if (levelUsesIntensityInSprites())
                {
                    SB_actionCode.append("\tldb      #$ff ; flag default to no intensity change\n");
                    SB_actionCode.append("\tlda      currentLevelFlags ; level flags\n");
                    SB_actionCode.append("\tanda      #INTENSITY_IS_DEFAULT ; is mark intensity non standard?\n");
                    SB_actionCode.append("\tbeq      noIntensityChange"+initUID+"\n");

                    SB_actionCode.append("\tlda      currentLevelFlags ; mark level as standard intensity\n");
                    SB_actionCode.append("\tanda     #(255-INTENSITY_IS_DEFAULT) ; set flag to default intensity\n");
                    SB_actionCode.append("\tsta      currentLevelFlags ; store level flags\n");
                    
                    SB_actionCode.append("\tldb      #$5f ; load default intensity\n");
                    SB_actionCode.append("noIntensityChange"+initUID+":\n");
                }
            }
            
            SB_actionCode.append("\tldu      vListTemp ; load the current to be displayed smartlist\n");
            SB_actionCode.append("\tMY_MOVE_TO_A_END ; if there is time left for moving... iddle away\n");

            if (mActionData.mintensity.length() != 0)
            {
                SB_actionCode.append("\t_INTENSITY_B ; \n");
            }
            else
            {
                if (levelUsesIntensityInSprites())
                {
                    SB_actionCode.append("\ttstb      ; if b negative we have default intensity\n");
                    SB_actionCode.append("\tbmi      noIntensityChange2"+initUID+"\n");
                
                    SB_actionCode.append("\t_INTENSITY_B ; \n");
                    SB_actionCode.append("noIntensityChange2"+initUID+":\n");
                }
            }
            
            SB_actionCode.append("\tldx      #(%11111110*256)+$98 ; \n");
            SB_actionCode.append("\tldy      #(%00001111*256)+$98 ; \n");
            SB_actionCode.append(" ; and jump to the smartlist drawing \n");
            SB_actionCode.append("\tpulu     d,pc ; -> which in turn jumps to the next object in the list when finished\n");
        }

        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; ------ BEHAVIOUR CODE END --------\n");
        SB_actionCode.append("; ----------------------------------\n");
        
        if ((mActionData.mbehaviour.equals("player 1 controlled")) || (mActionData.mbehaviour.equals("player 2 controlled")))
        {
            GFXVectorList boundingList = ActionPanel.computeBoundingBoxStatic(mActionData);
            if (boundingList!=null)
            {
                // assuming that is the one and only player
                int dyi = (((int)boundingList.get(0).start.y()/BLOW) - ((int)boundingList.get(2).start.y()/BLOW))/2;
                int dxi = (((int)boundingList.get(0).start.x()/BLOW) - ((int)boundingList.get(2).start.x()/BLOW))/2;

                byte dx = (byte)(dxi&0xff);
                byte dy = (byte)(dyi&0xff);

                String xd = String.format("$%02X", dx);
                String yd = String.format("$%02X", dy);
                
                // player sprites have these as data stored
                // "normal" sprites have these values DIRECTLY in their
                // collision detection code
                SB_actionCode.append(mSpriteData.mName+mActionData.mName+"DeltaData:\n");
                SB_actionCode.append("; bounding box delta data for current vectorlist (action)\n");
                SB_actionCode.append("; the bounding box data is calculated using the first\n");
                SB_actionCode.append("; animation phase of the vectorlist animation data\n");
                SB_actionCode.append("; \n");
                SB_actionCode.append("; delta data of enemies (for player<->sprite collision)\n");
                SB_actionCode.append("; is not kept in DB statements, \n");
                SB_actionCode.append("; but are handled in code immediately, since the values\n");
                SB_actionCode.append("; are unique to the sprite->action\n");
                SB_actionCode.append("\tDB      "+yd+", "+xd+"\t; yDelta, xDelta - assuming sprite is midway\n");
                SB_actionCode.append("; ---------------------------------- \n");
            }
        }

        if ((mActionData.mtext != null) && (mActionData.mtext.length() != 0))
        {
            String v = mtextDone.get(mActionData.mtext);
            if (v == null)
            {
                String[] t = cleanSplitNL(mActionData.mtext);
                if (t.length <= 1)
                {
                    SB_actionCode.append(mSpriteData.mName+mActionData.mName+"Text:\n");
                    SB_actionCode.append("\tDB      \""+mActionData.mtext+"\", 0x80\n");
                    SB_actionCode.append("; ---------------------------------- \n");
                    mtextDone.put(mActionData.mtext, mSpriteData.mName+mActionData.mName+"Text");
                }
                else
                {
                    SB_actionCode.append(mSpriteData.mName+mActionData.mName+"MultiText:\n");
                    for (int i=0;i<t.length;i++)
                    {
                        SB_actionCode.append("\t DW " +mSpriteData.mName+mActionData.mName+"MultiText"+i+"\n");
                    }
                    SB_actionCode.append("\t DW 0\n");
                    for (int i=0;i<t.length;i++)
                    {
                        SB_actionCode.append(mSpriteData.mName+mActionData.mName+"MultiText"+i+":\n");
                        SB_actionCode.append("\tDB      \""+t[i]+"\", 0x80\n");
                    }
                    SB_actionCode.append("; ---------------------------------- \n");
                }
            }
        }

        // sound cound
        String afxName = mActionData.msoundFile;
        if (afxName == null) return;
        if (afxName.length() == 0) return;
        if (mAFXDone.get(afxName) != null) return;

        SB_AFXSounds.append(genAYFX(afxName));
        
        mAFXDone.put(afxName, afxName);
    }

    void addMovementCode()
    {
        String actionName =  mSpriteData.mName+mActionData.mName+"Behaviour";
        if (!mActionData.mbehaviour.equals("fixed position"))
        {
            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ MOVEMENT CODE START -------\n");
            SB_actionCode.append("; ----------------------------------\n");


            // follow sprite is a "special" movement
            //
            // the following has in DATA_W
            // the pointer to the sprite it follows
            // it gets its positioning data from there
            // and applies an offset
            // with its own DELTA data to it
            if (mActionData.mbehaviour.equals("follow sprite"))
            {
                SB_actionCode.append("\tldx      DATA_W,s ; position pointer  \n");
                SB_actionCode.append("\tldd      ,x ; load position from parenet  \n");
                SB_actionCode.append("\tadda     Y_DELTA,s ; apply our offset Y \n");
                SB_actionCode.append("\taddb     X_DELTA,s ; apply our offset X \n");
                SB_actionCode.append("\tstD      S_Y_POS,s ; and store the new position\n");
            }
            else
            {
                boolean _isPlayer1 = (mActionData.mbehaviour.equals("player 1 controlled"));
                boolean _isPlayer2 = (mActionData.mbehaviour.equals("player 2 controlled"));

                // VERTICAL

                //
                // players can also have special movement, which is 
                // not done via coordinates, but which comes "directly" from
                // analog input
                // if the Y/X_DELTA starts with "a" than direct analog input is taken as coordinates!
                // if the two letters "ax" or "ay" are followed by a number
                // than that number is taken as an absolut value for min/max the analog value

                // analog vertical input
                if (mActionData.mchangeWhileActiveY.startsWith("ay"))
                {
                    if (_isPlayer1)
                    {
                        SB_actionCode.append("\tlda      Vec_Joy_1_Y ; load current Y \n");
                    }
                    else if (_isPlayer2)
                    {
                        SB_actionCode.append("\tlda      Vec_Joy_2_Y ; load current Y \n");
                    }
                    String restrictionS = replace(mActionData.mchangeWhileActiveY,"ay","");
                    int restriction = Int0(restrictionS);
                    if (restriction>0)
                    {
                        SB_actionCode.append("\tcmpa    #"+restriction+"; ensure that analog value is within specs\n");
                        SB_actionCode.append("\tblt     "+actionName+"AnalogYSmallerMax ; ensure that analog value is within specs\n");
                        SB_actionCode.append("\tlda     #"+restriction+"; load with max\n");
                        SB_actionCode.append("\tbra     "+actionName+"AnalogYCheckDone ; ensure that analog value is within specs\n");
                        SB_actionCode.append(actionName+"AnalogYSmallerMax:\n");
                        SB_actionCode.append("\tcmpa    #-"+restriction+"; ensure that analog value is within specs\n");
                        SB_actionCode.append("\tbgt     "+actionName+"AnalogYCheckDone ; ensure that analog value is within specs\n");
                        SB_actionCode.append("\tlda     #-"+restriction+"; load with min\n");
                        SB_actionCode.append(actionName+"AnalogYCheckDone:\n");
                    }
                }
                else
                {
                    // normal movement
                    // x,y delta are added to position
                    SB_actionCode.append("\tlda      Y_DELTA,s ; load current Y speed\n");
                    SB_actionCode.append("\tadda     S_Y_POS,s ; add position \n");
                }
                SB_actionCode.append("\tsta      S_Y_POS,s ; store to the Y position\n");


                // HORIZONTAL (same as above but for x coordinates)

                // analog horizontal input
                if (mActionData.mchangeWhileActiveX.startsWith("ax"))
                {
                    if (_isPlayer1)
                    {
                        SB_actionCode.append("\tlda      Vec_Joy_1_X ; load current X \n");
                    }
                    else if (_isPlayer2)
                    {
                        SB_actionCode.append("\tlda      Vec_Joy_2_X ; load current X \n");
                    }
                    String restrictionS = replace(mActionData.mchangeWhileActiveX,"ax","");
                    int restriction = Int0(restrictionS);
                    if (restriction>0)
                    {
                        SB_actionCode.append("\tcmpa    #"+restriction+"; ensure that analog value is within specs\n");
                        SB_actionCode.append("\tblt     "+actionName+"AnalogXSmallerMax ; ensure that analog value is within specs\n");
                        SB_actionCode.append("\tlda     #"+restriction+"; load with max\n");
                        SB_actionCode.append("\tbra     "+actionName+"AnalogXCheckDone ; ensure that analog value is within specs\n");
                        SB_actionCode.append(actionName+"AnalogXSmallerMax:\n");
                        SB_actionCode.append("\tcmpa    #-"+restriction+"; ensure that analog value is within specs\n");
                        SB_actionCode.append("\tbgt     "+actionName+"AnalogXCheckDone ; ensure that analog value is within specs\n");
                        SB_actionCode.append("\tlda     #-"+restriction+"; load with min\n");
                        SB_actionCode.append(actionName+"AnalogXCheckDone:\n");
                    }
                }
                else
                {
                    SB_actionCode.append("\tlda      X_DELTA,s ; load current X speed\n");
                    SB_actionCode.append("\tadda     S_X_POS,s ; add position \n");
                }
                SB_actionCode.append("\tsta      S_X_POS,s ; store to the X position\n");
            }

            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ MOVEMENT CODE END ---------\n");
            SB_actionCode.append("; ----------------------------------\n");
        }
    }
    void addAnimationCode(int animationCount)
    {
        String actionName =  mSpriteData.mName+mActionData.mName+"Behaviour";
        SB_actionCode.append("; in S pointer to object structure ()\n");
        SB_actionCode.append("\tMY_MOVE_TO_D_START\n");
        SB_actionCode.append("\tldb      #OBJECT_SCALE\n");
        SB_actionCode.append("\tstb      VIA_t1_cnt_lo\n");

        if (animationCount >1)
        {
            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ ANIMATION CODE START ------\n");
            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("\tlda      animCountdown ; load global countdown\n");
            SB_actionCode.append("\tbne      "+actionName+"NoAnimChange ; only change animation when 0\n");
            SB_actionCode.append("\tlda      ANIM_PLACE,s ; increase current animation phase\n");
            SB_actionCode.append("\tinca\n");
            SB_actionCode.append("\tsta      ANIM_PLACE,s\n");
            SB_actionCode.append("\tcmpa     #"+animationCount+" ; but if to high -> reset to 0\n");
            SB_actionCode.append("\tbne      "+actionName+"NoAnimChange_A_Loaded\n");
            SB_actionCode.append("\tclr      ANIM_PLACE,s\n");
        }
        SB_actionCode.append(actionName+"NoAnimChange:\n");

        if (mVectorlistDone.get(mActionData.manimationFile) == null)
            ShowWarningDialog.showWarningDialog("Vectorlist null!", "Did you not supply a vector animation list? ("+mSpriteData.mName+", action: "+mActionData.mName+")");
        if (animationCount >1)
        {
            SB_actionCode.append("\tlda       ANIM_PLACE,s ; load current animation phase \n");
            SB_actionCode.append(actionName+"NoAnimChange_A_Loaded:\n");
            SB_actionCode.append("\tldx       #"+mVectorlistDone.get(mActionData.manimationFile)+" ; load vectoranimation base address\n");
            SB_actionCode.append("\tlsla ; phase count double -> because it is a word pointer (2 bytes)\n");
            SB_actionCode.append("\tldu       a,x ; and load the actual vectorlist address to be displayed\n");
            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ ANIMATION CODE END --------\n");
            SB_actionCode.append("; ----------------------------------\n");
        }
        else
        {
            SB_actionCode.append(actionName+"NoAnimChange_A_Loaded:\n");
            SB_actionCode.append("\tldx       #"+mVectorlistDone.get(mActionData.manimationFile)+" ; load pointer to vectorlist\n");
            SB_actionCode.append("\tldu       ,x ; and load the actual vectorlist address to be displayed\n");
        }
        SB_actionCode.append("\tstu       vListTemp ; save the for later usage\n");
    }
    
    int printAndMoveUID = 0;
    void printAndMoveText()
    {
        String[] t = cleanSplitNL(mActionData.mtext);

        if (t.length<=1)
        {
            if (mActionData.mtextType.equals("5 font"))
            {
                if (!font5TextRoutineDone)
                    SB_actionCode.append("Font5TextBehaviour:\n");
                else
                {
                    SB_actionCode.append("\tjmp     Font5TextBehaviour\n");
                    return;
                }
            }
            if (mActionData.mtextType.equals("standard font"))
            {
                if (!fontStandardTextRoutineDone)
                    SB_actionCode.append("FontStandardTextBehaviour:\n");
                else
                {
                    SB_actionCode.append("\tjmp     FontStandardTextBehaviour\n");
                    return;
                }
            }
        }
        else
        {
            if (mActionData.mtextType.equals("5 font"))
            {
                if (!font5MultiTextRoutineDone)
                    SB_actionCode.append("Font5MultiTextBehaviour:\n");
                else
                {
                    SB_actionCode.append("\tjmp     Font5MultiTextBehaviour\n");
                    return;
                }
            }
            if (mActionData.mtextType.equals("standard font"))
            {
                if (!fontStandardMultiTextRoutineDone)
                    SB_actionCode.append("FontStandardMultiTextBehaviour:\n");
                else
                {
                    SB_actionCode.append("\tjmp     FontStandardMultiTextBehaviour\n");
                    return;
                }
            }
        }
        
        // print string behaviours
        // are built only once, so they must have no
        // connection to specific actions!
        printAndMoveUID++;

        boolean buildNow = false;
        String stringRoutine="";
        if (mActionData.mtextType.equals("standard font"))
        {
            if (t.length<=1)
            {
                if (!fontStandardTextRoutineDone)
                {
                    stringRoutine = "\tjsr      sync_Std_Print_Str_d ; print the string at D \n";
                    fontStandardTextRoutineDone = true;
                    buildNow = true;
                }
            }
            else
            {
                if (!fontStandardMultiTextRoutineDone)
                {
                    stringRoutine = "\tjsr      sync_Std_Print_Str_d ; print the string at D \n";
                    fontStandardMultiTextRoutineDone = true;
                    buildNow = true;
                }
            }
        }
        if (mActionData.mtextType.equals("5 font"))
        {
            if (t.length<=1)
            {
                if (!font5TextRoutineDone)
                {
                    stringRoutine = "\tjsr      sync_Print_Str_d ; print the string at D \n";
                    font5TextRoutineDone = true;
                    buildNow = true;
                }
            }
            else
            {
                if (!font5MultiTextRoutineDone)
                {
                    stringRoutine = "\tjsr      sync_Print_Str_d ; print the string at D \n";
                    font5MultiTextRoutineDone = true;
                    buildNow = true;
                }
            }
        }
        
        if (buildNow)
        {
            SB_actionCode.append("\tldb      INTENSITY,s ; load the current Intensity\n");
            SB_actionCode.append("\tbmi      noIntensityChange_PaM_1"+printAndMoveUID+"\n");
            SB_actionCode.append("\t_INTENSITY_B ; \n");
            SB_actionCode.append("\tbra      noIntensityChange_PaM_2"+printAndMoveUID+"\n");
            SB_actionCode.append("noIntensityChange_PaM_1"+printAndMoveUID+":\n");

            if (levelUsesIntensityInSprites())
            {
                SB_actionCode.append("\tlda      currentLevelFlags ; level flags\n");
                SB_actionCode.append("\tanda      #INTENSITY_IS_DEFAULT ; is mark intensity non standard?\n");
                SB_actionCode.append("\tbeq       noIntensityChange_PaM_2"+printAndMoveUID+":\n");

                SB_actionCode.append("\tlda      currentLevelFlags ; mark level as standard intensity\n");
                SB_actionCode.append("\tanda     #(255-INTENSITY_IS_DEFAULT) ; set flag to default intensity\n");
                SB_actionCode.append("\tsta      currentLevelFlags ; store level flags\n");

                SB_actionCode.append("\tldb      #$5f ; load default intensity\n");
                SB_actionCode.append("\t_INTENSITY_B ; \n");
            }
            
            SB_actionCode.append("noIntensityChange_PaM_2"+printAndMoveUID+":\n");
            
            SB_actionCode.append("\tsts      temp16bit ; remember stack (current position in object list) \n");
            SB_actionCode.append("\tldd      S_Y_POS,s ; (re)load position (might be destroyed by trigger code) \n");
            SB_actionCode.append("\tldx      HEIGHT,s ; load string sizes \n");
            SB_actionCode.append("\tstx      Vec_Text_HW ; and store them to default \n");
            if (t.length<=1)
            {
                SB_actionCode.append("\tldu      TEXT,s ; load text address to u \n");
                SB_actionCode.append("\tlds      #Vec_Default_Stk ; and enable stack usage (so we can use sub routines) \n");

                SB_actionCode.append(stringRoutine);
            }
            else
            {
                SB_actionCode.append("\tldy      TEXT,s ; load text address to y \n");
                SB_actionCode.append("\tlds      #Vec_Default_Stk ; and enable stack usage (so we can use sub routines) \n");

                SB_actionCode.append("nextMultiLine_PaM"+printAndMoveUID+":\n");
                SB_actionCode.append("\tldu      ,y++ ; load text address to u \n");
                SB_actionCode.append("\tbeq      multiLineDone_PaM"+printAndMoveUID+"\n");

                SB_actionCode.append(stringRoutine);
                SB_actionCode.append("; in D are the old coordinates, adjusted to lines that were drawn");
                SB_actionCode.append("; move a little more down to draw the next line");
                SB_actionCode.append("\tsuba Vec_Text_Height \n");
                SB_actionCode.append("\tsuba Vec_Text_Height \n");
                SB_actionCode.append("\tsuba Vec_Text_Height \n");
                SB_actionCode.append("\tsuba Vec_Text_Height \n");
                SB_actionCode.append("\tbra      nextMultiLine_PaM"+printAndMoveUID+"\n");
                SB_actionCode.append("multiLineDone_PaM"+printAndMoveUID+":\n");
            }
            











            SB_actionCode.append("\tlds      temp16bit ; restore stack to current object in object list\n");
            SB_actionCode.append("\tlda      gameScale ; load ...\n");
            SB_actionCode.append("\tsta      <VIA_t1_cnt_lo ; and set the default movement scale\n");
            SB_actionCode.append("\tldb      #$cc ; reset the beam to zero\n");
            SB_actionCode.append("\tSTb      >VIA_cntl\n");
            SB_actionCode.append("\tldd      #0 ; reset our VIA registers\n");
            SB_actionCode.append("\tstd      >VIA_port_b\n");

            SB_actionCode.append("\tldb      INTENSITY,s ; load the current Intensity\n");
            SB_actionCode.append("\tbmi      noIntensityChange_2PaM"+printAndMoveUID+"\n");
            SB_actionCode.append("\tldb      #$5f ; reset to default intensity\n");
            SB_actionCode.append("\t_INTENSITY_B ; \n");
            SB_actionCode.append("noIntensityChange_2PaM"+printAndMoveUID+":\n");

            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ MOVEMENT CODE START -------\n");
            SB_actionCode.append("; ----------------------------------\n");

            SB_actionCode.append("\tlda      Y_DELTA,s ; load current Y speed\n");
            SB_actionCode.append("\tadda     S_Y_POS,s ; add position \n");
            SB_actionCode.append("\tsta      S_Y_POS,s ; store to the Y position\n");

            SB_actionCode.append("\tlda      X_DELTA,s ; load current X speed\n");
            SB_actionCode.append("\tadda     S_X_POS,s ; add position \n");
            SB_actionCode.append("\tsta      S_X_POS,s ; store to the X position\n");

            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ MOVEMENT CODE END ---------\n");
            SB_actionCode.append("; ----------------------------------\n");

            SB_actionCode.append("\tlds      S_NEXT_OBJECT,s ; load stack with the next object data\n");
            SB_actionCode.append("\tpuls     d,pc ; and jump to the next object in the object list\n");
        }
    }
    String genAYFX(String inFilename)
    {
        byte[] data;
        Path path = Paths.get(inFilename);
        String nameOnly = path.getFileName().toString();
        String barenameOnly = nameOnly.substring(0, nameOnly.length()-4); // is a ".afx", tehrefor a -4 must work!
        
        try
        {
            data = Files.readAllBytes(path);
        }
        catch (Throwable e)
        {
            return "";
        }

        StringBuilder buf = new StringBuilder();
        int count = 0;

        buf.append("; AYFX - Data of file: \""+inFilename+"\"\n");
        buf.append(""+barenameOnly+"_data:\n");
        for (int i=0; i< data.length;i++)
        {
            if (count == 0)
            {
                buf.append(" DB ");
            }
            else
            {
                buf.append(", ");

            }
            buf.append(String.format("$%02X",data[i] ));
            count++;
            if (count == 10)
            {
                count =0;
                buf.append("\n" );
            }
        }
        return buf.toString();
    }

    void generateActionVectorlist()
    {
        if (mVectorlistDone.containsKey(mActionData.manimationFile)) return;

        GFXVectorAnimation animation = new GFXVectorAnimation();
        boolean ok = animation.loadFromXML(mActionData.manimationFile);
        if (!ok)
        {
            log.addLog("Error loading animation: "+mActionData.manimationFile, ERROR);
            return;
        }
        smartlistUsed = true;
        
        GenerationParameters p = new GenerationParameters();
        p.compileForVB = true; // use stack for object list 
        p.rts2 = true; //  rts 2
        p.paraName = mSpriteData.mName+"_"+mActionData.mName;
        p.doNoPositionMove = false;
        veccy.setParameters(p);

        SB_vectorLists.append(";\n");
        SB_vectorLists.append(";Vectorlists for action: "+mActionData.mName+", sprite: "+mSpriteData.mName+"\n");
        SB_vectorLists.append(";\n");
        SB_vectorLists.append(p.paraName+":\n");
        SB_vectorLists.append(veccy.buildSmartAnimlistG(false, animation, mSmartlistFunctions));
        mVectorlistDone.put(mActionData.manimationFile, p.paraName);
    }

    // only player specific triggers are handled here
    // eg position - not
    // if not player - than it can only be "trigger only"
    void addPlayerActionCode(boolean isPlayer)
    {
        boolean XLoaded=false;
        boolean YLoaded=false;

        SB_actionCode.append("; ----------------------------------\n");
        if (isPlayer)
            SB_actionCode.append("; ---- PLAYER ACTION CODE START ----\n");
        else
            SB_actionCode.append("; ---- TRIGGER CODE ONLY START -----\n");
        SB_actionCode.append("; ----------------------------------\n");
SB_actionCode.append("; DEBUG: addPlayerActionCode enter\n");

        boolean buttonLoaded = false;

        boolean isPlayer1 = mActionData.mbehaviour.equals("player 1 controlled");
        boolean isPlayer2 = mActionData.mbehaviour.equals("player 2 controlled");

        // block movement must be done BEFORE action changes (that change movement)
        // otherwise we can not take back the movement done before!
        // -> sprite collision must be done before joystick handling!

        // the outer loop is needed to ensure an
        // order to trigger handling
        for (int outer = 0; outer<3; outer++)
        {
SB_actionCode.append("; DEBUG: addPlayerActionCode outer: "+outer+"\n");
            
            
            int eventtriggerCount = 0;
            for (int eventCount = 0;eventCount<mActionData.meventUID.size();eventCount++)
{
SB_actionCode.append("; DEBUG: addPlayerActionCode eventCount: "+eventCount+"\n");
            ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
            ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
            
            for (int triggerCount = 0;triggerCount<triggers.mtriggerByCause.size();triggerCount++)
            {
SB_actionCode.append("; DEBUG: addPlayerActionCode triggerCount: "+triggerCount+"\n");
                eventtriggerCount++;
                if (mTriggerForActionDone.containsKey(buildTriggerKey(triggerCount, eventCount))) continue;

                boolean triggerFound = false;
                String cause = triggers.mtriggerByCause.elementAt(triggerCount);
// todo ACTIONS! More than one!
// not just 0
                String targetAction = results.mresultActionID.elementAt(0);
                String triggerIDString = mSpriteData.mName+mActionData.mName+eventCount+""+triggerCount+""+outer;
                String actionIDStringIter = mSpriteData.mName+targetAction;
                String branchString = "";

                //*********************************************
                // start to check trigger conditions

                if (outer == 2)
                {
                    // clean up/set optimization booleans
                    if (cause.contains("button down"))
                    {
                        if (!buttonLoaded)
                        {
                            SB_actionCode.append("\tlda       Vec_Btn_State ; load current button state\n");
                            buttonLoaded = true;
                        }
                    }
                    else if (cause.contains("button pressed"))
                    {
                        if (!buttonLoaded)
                        {
                            SB_actionCode.append("\tlda       Vec_Buttons ; load current toggle button state\n");
                            buttonLoaded = true;
                        }
                    }
                    else
                    {
                            buttonLoaded = false;
                    }
                    if (!cause.startsWith("joystick"))
                    {
                        YLoaded=false;
                        XLoaded=false;
                    }
                    // input checking
                    if ((cause.equals("button down 1")) || (cause.equals("button pressed 1")))
                    {
                        SB_actionCode.append("; trigger: "+cause+"\n");
                        triggerFound = true;
                        if (isPlayer1) SB_actionCode.append("\tbita      #$01 ; button 1\n");
                        if (isPlayer2) SB_actionCode.append("\tbita      #$10 ; button 1\n");
                        branchString = "\tbeq       endTest"+triggerIDString+"\n";
                    }
                    if ((cause.equals("button down 2")) || (cause.equals("button pressed 2")))
                    {
                        SB_actionCode.append("; trigger: "+cause+"\n");
                        triggerFound = true;
                        if (isPlayer1) SB_actionCode.append("\tbita      #$02 ; button 2\n");
                        if (isPlayer2) SB_actionCode.append("\tbita      #$20 ; button 2\n");
                        branchString = "\tbeq       endTest"+triggerIDString+"\n";
                    }
                    if ((cause.equals("button down 3")) || (cause.equals("button pressed 3")))
                    {
                        SB_actionCode.append("; trigger: "+cause+"\n");
                        triggerFound = true;
                        if (isPlayer1) SB_actionCode.append("\tbita      #$04 ; button 3\n");
                        if (isPlayer2) SB_actionCode.append("\tbita      #$40 ; button 3\n");
                        branchString = "\tbeq       endTest"+triggerIDString+"\n";
                    }
                    if ((cause.equals("button down 4")) || (cause.equals("button pressed 4")))
                    {
                        SB_actionCode.append("; trigger: "+cause+"\n");
                        triggerFound = true;
                        if (isPlayer1) SB_actionCode.append("\tbita      #$08 ; button 4\n");
                        if (isPlayer2) SB_actionCode.append("\tbita      #$80 ; button 4\n");
                        branchString = "\tbeq       endTest"+triggerIDString+"\n";
                    }
                    if (cause.equals("joystick center"))
                    {
                        SB_actionCode.append("; trigger: "+cause+"\n");
                        triggerFound = true;
                        // assuming digital
                        if (isPlayer1) SB_actionCode.append("\tldd       Vec_Joy_1_X; testing X and Y -> 16 bit\n");
                        if (isPlayer2) SB_actionCode.append("\tldd       Vec_Joy_2_X; testing X and Y -> 16 bit\n");
                        branchString = "\tbne       endTest"+triggerIDString+"\n";
                    }
                    if (cause.equals("joystick up"))
                    {
                        // todo
                        // check if there is also a trigger for
                        // up left, up right
                        // if so - do it BEFORE

                        SB_actionCode.append("; trigger: "+cause+"\n");
                        triggerFound = true;

                        if (isPlayer1) SB_actionCode.append("\tlda       Vec_Joy_1_Y\n");
                        if (isPlayer2) SB_actionCode.append("\tlda       Vec_Joy_2_Y\n");

                        YLoaded=true;
                        XLoaded=false;
                        branchString = "\tble       endTest"+triggerIDString+"\n";
                    }
                    if (cause.equals("joystick down"))
                    {
                        // todo
                        // check if there is also a trigger for
                        // down left, down right
                        // if so - do it BEFORE


                        SB_actionCode.append("; trigger: "+cause+"\n");
                        triggerFound = true;
                        if (!YLoaded)
                        {
                            if (isPlayer1) SB_actionCode.append("\tlda       Vec_Joy_1_Y\n");
                            if (isPlayer2) SB_actionCode.append("\tlda       Vec_Joy_2_Y\n");
                        }
                        YLoaded=true;
                        XLoaded=false;
                        branchString = "\tbpl       endTest"+triggerIDString+"\n";
                    }
                    if (cause.equals("joystick right"))
                    {
                        SB_actionCode.append("; trigger: "+cause+"\n");
                        triggerFound = true;
                        if (isPlayer1) SB_actionCode.append("\tldb       Vec_Joy_1_X\n");
                        if (isPlayer2) SB_actionCode.append("\tldb       Vec_Joy_2_X\n");
                        XLoaded=true;
                        YLoaded=false;
                        branchString = "\tble       endTest"+triggerIDString+"\n";
                    }
                    if (cause.equals("joystick left"))
                    {
                        SB_actionCode.append("; trigger: "+cause+"\n");
                        triggerFound = true;
                        if (!XLoaded)
                        {
                            if (isPlayer1) SB_actionCode.append("\tldb       Vec_Joy_1_X\n");
                            if (isPlayer2) SB_actionCode.append("\tldb       Vec_Joy_2_X\n");
                        }

                        YLoaded=false;
                        XLoaded=true;
                        branchString = "\tbpl       endTest"+triggerIDString+"\n";
                    }
                }
                if (outer == 0)
                {
                    // ensure that no collision checks are done BEFORE collision checks
                    // because a successfull collision check 
                    // restores the flags to no collision -> and thus triggers a no collision which comes after!
                    // NON colision detection
                    if ((cause.equals("sprite no collision")) && (isPlayer))
                    {
                        triggerFound = true;
                        branchString = addNoCollisionCheck(eventCount, triggerCount, triggerIDString, "endTest");
                    }
                }
                if (outer == 1)
                {
                    // colision detection
                    if (((cause.equals("sprite collision")) || (cause.equals("sprite receive collision"))) && (isPlayer))
                    {
                        triggerFound = true;
SB_actionCode.append("; DEBUG: addCollisionCheck start\n");
                        branchString = addCollisionCheck(eventCount, triggerCount, triggerIDString, "endTest");
SB_actionCode.append("; DEBUG: addCollisionCheck end\n");
                    }            
                }

                if (triggerFound)
                {
SB_actionCode.append("; DEBUG: addTriggerFoundCode start\n");
                    addTriggerFoundCode(eventCount, triggerCount, branchString);
SB_actionCode.append("; DEBUG: addTriggerFoundCode end\n");
                    SB_actionCode.append("endTest"+triggerIDString+":\n");
                }
            }
}            
            
        } // loop outer
SB_actionCode.append("; DEBUG: addPlayerActionCode exit\n");


        SB_actionCode.append("; ----------------------------------\n");
        if (isPlayer)
            SB_actionCode.append("; ---- PLAYER ACTION CODE END ------\n");
        else
            SB_actionCode.append("; ---- TRIGGER ONLY CODE END -------\n");
        SB_actionCode.append("; ----------------------------------\n");
    }
    String addCollisionCheck(int eventCount,int triggerCount, String triggerIDString, String endTest)
    {
        ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
        ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventCount));

        String cause = triggers.mtriggerByCause.elementAt(triggerCount);
// TODO!
        String targetAction = results.mresultActionID.elementAt(0);
        String actionIDStringIter = mSpriteData.mName+targetAction;
        String branchString = "";
        SB_actionCode.append("; trigger: "+cause+"\n");

        SB_actionCode.append(" ; collision testing is done on the\n");
        SB_actionCode.append(" ; enemy objects, if one collided with THIS sprite\n");
        SB_actionCode.append(" ; a flag is set and can be reacted upon here (in the next round)\n");
        SB_actionCode.append("\tldb      FLAG,s       ; \n");
        SB_actionCode.append("\tbitb     #(SPRITE_SPRITE_COLLISION_BIT)       ; check if collision with a sprite occured\n");
        SB_actionCode.append("\tbeq       "+endTest+triggerIDString+"\n"); // no collision occured

        //AND                
        String otherID = triggers.mtriggerBySpriteID.elementAt(triggerCount);
        if ((otherID!=null) && (otherID.length()!=0))
        {
            SpriteData sprite = getSpriteByID(otherID);
            SB_actionCode.append("\tlda     COLLISION_ID,s ; load id of the sprite with which the collision happened\n");
            SB_actionCode.append("\tcmpa    #"+sprite.mspriteUID+" ; check if collision with the CORRECT sprite happened\n");
            SB_actionCode.append("\tbne       "+endTest+triggerIDString+"\n"); // no collision occured
            // collision trigger IS taken
            // cleanup
            SB_actionCode.append("\tandb      #(255-SPRITE_SPRITE_COLLISION_BIT)       ; remove flag\n");
            SB_actionCode.append("\tstb      FLAG,s       ; \n");
            branchString = "\tbrn       "+endTest+triggerIDString+"\n";
        }
        else
        {
            ShowWarningDialog.showWarningDialog("Unkown player<->sprite collision!", "An unkown collision detection can occur, otherID = null. (Player action: "+mActionData.mName+", trigger count: "+triggerCount+")");
            // collision trigger IS taken
            // cleanup
            SB_actionCode.append("\tandb      #(255-SPRITE_SPRITE_COLLISION_BIT)       ; remove flag\n");
            SB_actionCode.append("\tstb      FLAG,s       ; \n");
            branchString = "\tbrn       "+endTest+triggerIDString+"\n";
        }
        return branchString;
    }                        
    String addNoCollisionCheck(int eventCount,int triggerCount, String triggerIDString, String endTest)
    {
        ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
        ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventCount));

        String cause = triggers.mtriggerByCause.elementAt(triggerCount);
        String targetAction = results.mresultActionID.elementAt(triggerCount);
        String actionIDStringIter = mSpriteData.mName+targetAction;
        String branchString = "";
        SB_actionCode.append("; trigger: "+cause+"\n");

        SB_actionCode.append("\tldb      FLAG,s       ; \n");
        SB_actionCode.append("\tbitb     #(SPRITE_SPRITE_COLLISION_BIT)       ; check if collision with a sprite occured\n");
        SB_actionCode.append("\tbeq       noCollisionDetected"+triggerIDString+"\n"); // no collision occured

        // check if collision with an other sprite occured - if yes -> than still no collision!
        String otherID = triggers.mtriggerBySpriteID.elementAt(triggerCount);
        if ((otherID!=null) && (otherID.length()!=0))
        {
            SpriteData sprite = getSpriteByID(otherID);
            SB_actionCode.append("\tlda     COLLISION_ID,s ; load id of the sprite with which the collision happened\n");
            SB_actionCode.append("\tcmpa    #"+sprite.mspriteUID+" ; check if collision with the CORRECT sprite happened\n");
            SB_actionCode.append("\tbeq       "+endTest+triggerIDString+"\n"); // collision occured - trigger not taken
            branchString = "\tbrn       "+endTest+triggerIDString+"\n";
        }
        else
        {
            ShowWarningDialog.showWarningDialog("Unkown player<->sprite no collision!", "An unkown no collision detection can occur, otherID = null. (Player action: "+mActionData.mName+", trigger count: "+triggerCount+")");
            // collision trigger IS NOT taken
            SB_actionCode.append("\tbra       "+endTest+triggerIDString+"\n"); // unkown collision occured - trigger not taken
        }
        SB_actionCode.append("noCollisionDetected"+triggerIDString+": \n"); // no collision occured
        return branchString;
    }                        

    void addSpriteActionCode()
    {
        String endOFActionHandle = mSpriteData.mName+mActionData.mName+"BehaviourNoAnimChange";

        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; ----- SPRITE ACTION CODE START ---\n");
        SB_actionCode.append("; ----------------------------------\n");

        /*
            if there are other action than collision detection - ensure that
            collision detection comes before anything that changes sprites/actions, that changes movement        

            block movement must be done BEFORE action changes (that change movement)
            otherwise I can not take back the movement done before!
            -> sprite collision must be done before joystick handling!
        */
        
        boolean buttonLoaded = false;
        
        // the outer loop is needed to ensure an
        // order to trigger handling
        for (int outer = 0; outer<2; outer++)
        {
        
            for (int eventCount = 0;eventCount<mActionData.meventUID.size();eventCount++)
{                
        ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
        ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
            
            for (int triggerCount = 0;triggerCount<triggers.mtriggerByCause.size();triggerCount++)
            {
                if (mTriggerForActionDone.containsKey(buildTriggerKey(triggerCount, eventCount))) continue;
                boolean triggerFound = false;
                String cause = triggers.mtriggerByCause.elementAt(triggerCount);
                String targetAction = results.mresultActionID.elementAt(triggerCount);
                String triggerIDString = mSpriteData.mName+mActionData.mName+eventCount+""+triggerCount+""+outer;
                String actionIDStringIter = mSpriteData.mName+targetAction;
                String branchString = "";

                StringBuilder postTriggerAdd = new StringBuilder();
                //*********************************************
                // start to check trigger conditions
                // colision detection

                if (outer == 0)
                {
                    // ensure that no collision checks are done BEFORE collision checks
                    // because a successfull collision check 
                    // restores the flags to no collision -> and thus triggers a no collision which comes after!
                    // NON colision detection
                    if (cause.equals("sprite no collision")) 
                    {
                        triggerFound = true;
                        branchString = addNoCollisionCheck(eventCount, triggerCount, triggerIDString, "endTestSprSpr");
                    }
                }
                if (outer == 1)
                {
                    // colision detection
                    if ((cause.equals("sprite collision")) || (cause.equals("sprite receive collision"))) 
                    {
                        triggerFound = true;
                        branchString = addCollisionCheck(eventCount, triggerCount, triggerIDString, "endTestSprSpr");
                    }            
                }

                if (triggerFound)
                {
                    addTriggerFoundCode(eventCount, triggerCount, branchString);
                }

                SB_actionCode.append("endTestSprSpr"+triggerIDString+":\n");
            }
}            
        }
        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; ----- SPRITE ACTION CODE END -----\n");
        SB_actionCode.append("; ----------------------------------\n");
    }

    
    void addSpriteTriggerPostionCode()
    {
        String actionIDString = mSpriteData.mName+mActionData.mName;
        if (hasPositionTrigger(mActionData))
        {
            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ POSITION CODE START -------\n");
            SB_actionCode.append("; ----------------------------------\n");
        }
        for (int eventCount = 0;eventCount<mActionData.meventUID.size();eventCount++)
{                
        ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
        ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
        for (int triggerCount = 0;triggerCount<triggers.mtriggerByCause.size();triggerCount++)
        {
            String triggerID="e"+eventCount+"_t"+triggerCount;
            if (mTriggerForActionDone.containsKey(buildTriggerKey(triggerCount,eventCount))) continue;
            boolean wasPositionTrigger = false;
            String branchString = "";
// TODO            
// result 0
            String target = results.mresultType.elementAt(0);
            if (triggers.mtriggerByCause.elementAt(triggerCount).equals("position equals"))
            {
                SB_actionCode.append("; trigger: position equals\n");
                wasPositionTrigger = true;
                String pos = String.format("$%04X",((triggers.mtriggerByY.elementAt(triggerCount)*256)&0xff00) + ((triggers.mtriggerByX.elementAt(triggerCount))&0xff) );
                SB_actionCode.append("\tldd      S_Y_POS,s\n");
                SB_actionCode.append("\tcmpd     #"+pos+"\n");
                branchString = "\tbne      "+mSpriteData.mName+mActionData.mName+triggerID+"PosCompareDone\n";
            }
            if (triggers.mtriggerByCause.elementAt(triggerCount).equals("position > Y"))
            {
                SB_actionCode.append("; trigger: position > Y\n");
                wasPositionTrigger = true;
                String pos = String.format("$%02X",((triggers.mtriggerByY.elementAt(triggerCount))&0xff));
                SB_actionCode.append("\tlda      S_Y_POS,s\n");
                SB_actionCode.append("\tcmpa     #"+pos+"\n");
                branchString = "\tble      "+mSpriteData.mName+mActionData.mName+triggerID+"PosCompareDone\n";
            }
            if (triggers.mtriggerByCause.elementAt(triggerCount).equals("position < Y"))
            {
                SB_actionCode.append("; trigger: position < Y\n");
                wasPositionTrigger = true;
                String pos = String.format("$%02X",((triggers.mtriggerByY.elementAt(triggerCount))&0xff));
                SB_actionCode.append("\tlda      S_Y_POS,s\n");
                SB_actionCode.append("\tcmpa     #"+pos+"\n");
                branchString = "\tbge      "+mSpriteData.mName+mActionData.mName+triggerID+"PosCompareDone\n";
            }
            if (triggers.mtriggerByCause.elementAt(triggerCount).equals("position > X"))
            {
                SB_actionCode.append("; trigger: position > X\n");
                wasPositionTrigger = true;
                String pos = String.format("$%02X",((triggers.mtriggerByX.elementAt(triggerCount))&0xff));
                SB_actionCode.append("\tlda      S_X_POS,s\n");
                SB_actionCode.append("\tcmpa     #"+pos+"\n");
                branchString = "\tble      "+mSpriteData.mName+mActionData.mName+triggerID+"PosCompareDone\n";
            }
            if (triggers.mtriggerByCause.elementAt(triggerCount).equals("position < X"))
            {
                SB_actionCode.append("; trigger: position < X\n");
                wasPositionTrigger = true;
                String pos = String.format("$%02X",((triggers.mtriggerByX.elementAt(triggerCount))&0xff));
                SB_actionCode.append("\tlda      S_X_POS,s\n");
                SB_actionCode.append("\tcmpa     #"+pos+"\n");
                branchString = "\tbge      "+mSpriteData.mName+mActionData.mName+triggerID+"PosCompareDone\n";
            }
            
            if (wasPositionTrigger)
            {
                addTriggerFoundCode(eventCount, triggerCount, branchString);
                SB_actionCode.append(mSpriteData.mName+mActionData.mName+triggerID+"PosCompareDone:\n");
            }
        }   
}
        if (hasPositionTrigger(mActionData))
        {
            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ POSITION CODE END ---------\n");
            SB_actionCode.append("; ----------------------------------\n");
        }
    }
    String buildTriggerKey(int trigger, int event)
    {
        ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(event));
        ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(event));
        String t=mSpriteData.mName+mActionData.mName+"_"+event+"_"
                +triggers.mtriggerByCause.elementAt(trigger)
                +triggers.mtriggerByTicks.elementAt(trigger)
                +triggers.mtriggerByX.elementAt(trigger)
                +triggers.mtriggerByY.elementAt(trigger);
        if (triggers.mtriggerByCause.elementAt(trigger).contains("collision"))
            t+=triggers.mtriggerBySpriteID.elementAt(trigger);
        return t;
    }

    // assuming only one timer is active per action!
    // and that the timer event has only one trigger
    void addSpriteTriggerTimerCode()
    {
        if (getTimerEventIndex(mActionData)==-1)
        {
            return;
        }
        int eventIndex = getTimerEventIndex(mActionData);
        ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventIndex));
        ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventIndex));
// TODO only 1 result
        if (mTriggerForActionDone.containsKey(buildTriggerKey(0, eventIndex))) return;

        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; -------- TIMER CODE START --------\n");
        SB_actionCode.append("; ----------------------------------\n");

        String actionIDString = mSpriteData.mName+mActionData.mName;
// TODO only 1 result
        String target = results.mresultType.elementAt(0);
        SB_actionCode.append("; trigger: timer expired\n");
        SB_actionCode.append("\tdec       TIMER,s\n");
        SB_actionCode.append("\tlbne      "+actionIDString+"TimerNotExpired\n");
        
        // reload timer
// TODO only 1 result
        String reload = triggers.mtriggerByTicks.elementAt(0);
        if (reload.startsWith("=")) 
        {
            reload = reload.substring(1);
            SB_actionCode.append("\tlda      "+reload+" ; reload timer\n");
        }
        else
        {
            SB_actionCode.append("\tlda      #"+reload+" ; reload timer\n");
        }
            
        SB_actionCode.append("\tsta      TIMER,s\n");

        // this is not "optimized", no "jmp" is created!
// TODO only 1 result
        addTriggerFoundCode(eventIndex, 0, "");
        
        SB_actionCode.append(actionIDString+"TimerNotExpired:\n");
        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; -------- TIMER CODE END ----------\n");
        SB_actionCode.append("; ----------------------------------\n");
    }

    // assuming only one timer is active per action!
    // long timer used DATA, not possible together with PATROL and TEXT, and follower 
    void addSpriteTriggerLongTimerCode()
    {
        if (getLongTimerEventIndex(mActionData)==-1)
        {
            return;
        }
        int eventIndex = getLongTimerEventIndex(mActionData);
        ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventIndex));
        ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventIndex));

// TODO only 1 result
        if (mTriggerForActionDone.containsKey(buildTriggerKey(0, eventIndex))) return;
        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; ---- LONG TIMER CODE START -------\n");
        SB_actionCode.append("; ----------------------------------\n");

        String actionIDString = mSpriteData.mName+mActionData.mName;
// TODO only 1 result
        String target = results.mresultType.elementAt(0);
        SB_actionCode.append("; trigger: long timer expired\n");
        SB_actionCode.append("\tldx       DATA_W,s\n");
        SB_actionCode.append("\tleax      -1,x\n");
        SB_actionCode.append("\tstx       DATA_W,s\n");
        SB_actionCode.append("\tlbpl      "+actionIDString+"LongTimerNotExpired\n");

        // reload timer
// TODO only 1 result
        String reload = triggers.mtriggerByTicks.elementAt(0);
        if (reload.startsWith("=")) 
        {
            reload = reload.substring(1);
            SB_actionCode.append("\tldd      "+reload+" ; reload timer (16bit)\n");
        }
        else
        {
            SB_actionCode.append("\tldd      #"+reload+" ; reload timer\n");
        }
            
        SB_actionCode.append("\tstd      DATA_W,s\n");

        // this is not "optimized", no "jmp" is created!
// TODO only 1 result
        addTriggerFoundCode(eventIndex, 0, "");
        
        SB_actionCode.append(actionIDString+"LongTimerNotExpired:\n");
        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; ------ LONG TIMER CODE END -------\n");
        SB_actionCode.append("; ----------------------------------\n");
    }
    String get8bitKeyClean(String n)
    {
        String s = get8bitKey(n);
        s= replace(s,"-","n");
        s= replace(s,"+","p");
        s= replace(s,"(","");
        s= replace(s,")","");
        s= replace(s,"!","");
        return s;
    }
    String get8bitKey(String n)
    {
        int v = IntX(n, 300);
        if (v<300) 
        {
            String ret =""+v;
//            ret = de.malban.util.UtilityString.replace(ret, "-", "n");
            return ret;
        }
        if (n.toLowerCase().equals("x")) return "x";    // no change!
        if (n.toLowerCase().startsWith("rand")) return n.toLowerCase();    // no change!
        if (n.toLowerCase().equals("neg")) return "neg";    
        if (n.toLowerCase().equals("++")) return "pp";
        if (n.toLowerCase().equals("--")) return "nn";
        
        if (n.toLowerCase().equals("+=0")) return "p0";
        if (n.toLowerCase().equals("+=1")) return "p1";
        if (n.toLowerCase().equals("+=2")) return "p2";
        if (n.toLowerCase().equals("+=3")) return "p3";
        if (n.toLowerCase().equals("+=4")) return "p4";
        if (n.toLowerCase().equals("+=5")) return "p5";
        if (n.toLowerCase().equals("+=6")) return "p6";
        if (n.toLowerCase().equals("+=7")) return "p7";
        if (n.toLowerCase().equals("+=8")) return "p8";
        if (n.toLowerCase().equals("+=9")) return "p9";

        if (n.toLowerCase().equals("-=0")) return "n0";
        if (n.toLowerCase().equals("-=1")) return "n1";
        if (n.toLowerCase().equals("-=2")) return "n2";
        if (n.toLowerCase().equals("-=3")) return "n3";
        if (n.toLowerCase().equals("-=4")) return "n4";
        if (n.toLowerCase().equals("-=5")) return "n5";
        if (n.toLowerCase().equals("-=6")) return "n6";
        if (n.toLowerCase().equals("-=7")) return "n7";
        if (n.toLowerCase().equals("-=8")) return "n8";
        if (n.toLowerCase().equals("-=9")) return "n9";

        if (n.toLowerCase().startsWith("=")) return "var"+n.substring(1);
        return "UNKNOWN";
    }

    int randomUID = 0;
    String genDCodeForKey(String key, String reg, String org, int result)
    {
        StringBuilder ret = new StringBuilder();
        String varName = "";
        String lda = "\tld"+reg+"      ";
        String adda = "\tadd"+reg+"     ";
        String nega = "\tneg"+reg+"     ";

        if (key.startsWith("rand"))
        {
            randomUID++;
            boolean pn = false;
            boolean n = false;
            boolean p = false;
            key = replace(key, "rand","");
            if (key.contains("+-")) pn = true;
            key = replace(key, "+-","");
            if (key.contains("-")) n = true;
            key = replace(key, "-","");
            if (key.contains("+")) p = true;
            key = replace(key, "+","");
            if ((!pn) && (!n) && (!p)) p = true;
            
            key= replace(key,"(","");
            key= replace(key,")","");
            
            
            int val = Int0(key);
            if (val == 0)
            {
                ShowWarningDialog.showWarningDialog("Random", "Can't discern random base. ("+mSpriteData.mName+", action: "+mActionData.mName+")");
                ret.append(lda+org+"\n");
                return ret.toString();
            }
            int min=0;
            int max=0;
            if (p) 
            {
                min = 0;
                max = val;
            }
            if (n) 
            {
                min = -val;
                max = 0;
            }
            if (pn) 
            {
                min = -val;
                max = val;
            }
            
            
            ret.append("\tsts      temp16bit ; remember stack (current position in object list) \n");
            ret.append("\tlds      #Vec_Default_Stk ; and enable stack usage (so we can use sub routines) \n");

            ret.append("\tpshs d\n");
            
            ret.append("repeatRandom"+randomUID+":\n");
            ret.append("\tjsr      Random ; todo replace with good random \n");
            if (p)
                ret.append("\tanda     #%00001111; max 15 \n");
            if (n)
            {
                ret.append("\tanda     #%00001111; max 15 \n");
                ret.append("\tnega     #%10000000; max 15 \n");
            }
            if (pn)
            {
                ret.append("\tbpl      repeatPos"+randomUID+ "\n");
                
                ret.append("\tora     #%11110000; max -15 \n");
                ret.append("\tbra      repeatNegDone"+randomUID+ "\n");

                ret.append("repeatPos"+randomUID+ ":\n");
                ret.append("\tanda     #%00001111; max 15 \n");
                ret.append("repeatNegDone"+randomUID+ ":\n");

            }
            ret.append("\tcmpa     #"+max+"; max  \n");
            ret.append("\tbgt       repeatRandom"+randomUID+";  \n");
            
            ret.append("\tcmpa     #"+min+"; min  \n");
            ret.append("\tblt       repeatRandom"+randomUID+";  \n");

            ret.append("\tsta temp8bit\n");
            ret.append("\tpuls d\n");
            ret.append("\tlds      temp16bit ; reload stack \n");
            ret.append("\tld"+reg+" temp8bit\n");
            
            return ret.toString();
        }

        
        
        int adder=10;
        if (key.equals("pp")) adder = 1;
        else if (key.equals("x")) 
        {
            adder = 0;
        }
        else if (key.startsWith("p"))
        {
            adder = IntX(key.substring(1), 300);
        }
        else if (key.equals("nn")) adder = -1;
        else if (key.startsWith("n"))
        {
            adder = -IntX(key.substring(1), 300);
        }
        if (key.startsWith("var"))
        {
            varName = key.substring(3);
            ret.append(lda+varName+"\n");
        }
        else if (key.startsWith("neg"))
        {
            ret.append(lda+org+"\n");
            ret.append(nega+"\n");
        }
        else if (adder<10)
        {
            ret.append(lda+org+"\n");
            if (adder != 0)
                ret.append(adda+"#"+adder+"\n");
        }
        else if (result<300)
        {
            ret.append(lda+"#"+result+"\n");
        }
        else
        {
            ShowWarningDialog.showWarningDialog("change error", "Change can not be built! ("+mSpriteData.mName+", action: "+mActionData.mName+")");
            ret.append(lda+org+"\n");
        }
        return ret.toString();
    }


    void loadDWithPosChange(StringBuilder s, String yC, String xC)
    {
        int resultY = IntX(yC, 300);
        int resultX = IntX(xC, 300);
        if ((resultY<300) && (resultX<300))
        {
            String pos = String.format("$%04X",((resultY*256)&0xff00) + ((resultX)&0xff) );
            s.append("\tldd      #"+pos+"\n");
            return;
        }

        String code1 = genDCodeForKey(get8bitKey(yC), "a", "S_Y_POS,s", resultY);
        String code2 = genDCodeForKey(get8bitKey(xC), "b", "S_X_POS,s", resultX);
        s.append(code1);
        s.append(code2);
    }

    void loadDWithSpeedChange(StringBuilder s, String yC, String xC)
    {
        int resultY = IntX(yC, 300);
        int resultX = IntX(xC, 300);
        if ((resultY<300) && (resultX<300))
        {
            String pos = String.format("$%04X",((resultY*256)&0xff00) + ((resultX)&0xff) );
            s.append("\tldd      #"+pos+"\n");
            return;
        }
        String code1 = genDCodeForKey(get8bitKey(yC), "a", "Y_DELTA,s", resultY);
        String code2 = genDCodeForKey(get8bitKey(xC), "b", "X_DELTA,s", resultX);
        s.append(code1);
        s.append(code2);
    }
    void loadAWithVarChange(StringBuilder s, String yC, String xC)
    {
        int resultY = IntX(yC, 300);
        int resultX = IntX(xC, 300);
        if (resultY<300) 
        {
            ShowWarningDialog.showWarningDialog("No Variable found", "No Variable found! ("+mSpriteData.mName+", action: "+mActionData.mName+")");
            return;
        }
        String key = get8bitKey(yC);

        String varNameTarget = "";
        if (key.startsWith("var"))
        {
            varNameTarget = key.substring(3);
        }
        else 
            ShowWarningDialog.showWarningDialog("No Variable found", "No Variable found (2)! ("+mSpriteData.mName+", action: "+mActionData.mName+")");

        key = get8bitKey(xC);
        String code1 = genDCodeForKey(key, "a", varNameTarget, resultX);
        s.append(code1);
    }
    void loadAWithContents(StringBuilder s, String yC)
    {
        int resultY = IntX(yC, 300);


        String code1 = genDCodeForKey(get8bitKey(yC), "a", "#0", resultY);
        s.append(code1);
        return ;
    }

    // returns how many trigger of EXACTLY the same reasons are found (and bind them later together)
    int[] getTriggerCounts(String triggerKey)
    {
        ArrayList l = new ArrayList();

        for (int eventCount = 0;eventCount<mActionData.meventUID.size();eventCount++)
        {
            ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
            ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
            for (int triggerCount = 0;triggerCount<triggers.mtriggerByCause.size();triggerCount++)
            {
                String localKey = buildTriggerKey(triggerCount, eventCount);
                if (localKey.equals(triggerKey))
                    l.add(triggerCount);
            }
        }
        
        int[] ret = new int[l.size()];
        for (int i=0;i<l.size();i++) ret[i] = (int) l.get(i);
        return ret;
    }
    
    // note "branchString" Stuff (reusing the same outcomes from different triggers)
    // is at the moment not used anymore
    // this "collided" with the idea,
    // that exactly the same triggers can be bound together to ONE trigger, that has several outcomes
    // the produced code is a bit longer
    // but it is more flexible this way
    private HashMap<String, String> mTriggerResults = new HashMap<String, String>();
    int triggerFoundUID = 0;
    
    
    void addTriggerFoundCode(int eventCount,int tCount, String branchString)
    {
        ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
        ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventCount));


        for (int rcount = 0;rcount<results.mresultType.size(); rcount++)
        {

        String tKey = buildTriggerKey(tCount, eventCount);
        mTriggerForActionDone.put(tKey, tKey);

        int[] triggerCountsForCause = getTriggerCounts(tKey);
        if (triggerCountsForCause.length==0)
            ShowWarningDialog.showWarningDialog("Trigger count mismatch!", "A trigger identified could not be found! (Sprite: "+mSpriteData.mName+", Action: "+mActionData.mName+")");

        
        //check for remove action
        //if remove action witing triggerCountsForCause[] do that one LAST
        // since the remove code jumps to the next sprite
        // and does not consider any multiple outcomes (e.g. also trigger a sound upon death)
        for (int rem = 0; rem < 4; rem++)
        {
            boolean isFirst = true;
            for (int ii=0;ii<triggerCountsForCause.length; ii++)
            {
                int triggerCount = triggerCountsForCause[ii];
                String endOFActionHandle = mSpriteData.mName+mActionData.mName+"BehaviourTriggerDone";
                String cause = triggers.mtriggerByCause.elementAt(triggerCount);
                String targetAction = results.mresultActionID.elementAt(rcount);

// todo check if result count must be in the triggerIDString
                String triggerIDString = mSpriteData.mName+mActionData.mName+""+eventCount+"_"+triggerCount+"_"+rcount;
                String actionIDStringIter = mSpriteData.mName+targetAction;

                // generate a unique key
                // so that actions with the same results
                // can be reused!
                // Reuse is cancled, see above
                String key = actionIDStringIter+"Triggered";

                int resultY = IntX(results.mresultY.elementAt(rcount), 300);
                int resultX = IntX(results.mresultX.elementAt(rcount), 300);

                if (rem == 0)
                {
                    if (results.mresultType.elementAt(rcount).equals("action change"))
                    {
                        key = key + "ActionChange"+targetAction;
                    }
                    if (results.mresultType.elementAt(rcount).equals("random spawn sprite"))
                    {
                        String spawnID = results.mresultSpriteID.elementAt(rcount);
                        key = key + "RandomSpriteSpawn"+spawnID;
                    }
                    if (results.mresultType.elementAt(rcount).equals("spawn sprite"))
                    {
                        String spawnID = results.mresultSpriteID.elementAt(rcount);
                        key = key + "SpriteSpawn"+spawnID;
                    }
                    if (results.mresultType.elementAt(rcount).equals("set position"))
                    {
                        String pos = String.format("0x%04X",((resultY*256)&0xff00) + ((resultX)&0xff) );
                        key = key + "SetPosition"+get8bitKeyClean(results.mresultY.elementAt(rcount))+"_"+get8bitKeyClean(results.mresultX.elementAt(rcount));
                    }
                    if (results.mresultType.elementAt(rcount).equals("block movement"))
                    {
                        key = key + "BlockMovement";
                    }
                    if (results.mresultType.elementAt(rcount).equals("speed change"))
                    {
                        String pos = String.format("0x%04X",((resultY*256)&0xff00) + ((resultX)&0xff) );
                        key = key + "SetSpeed"+get8bitKeyClean(results.mresultY.elementAt(rcount))+"_"+get8bitKeyClean(results.mresultX.elementAt(rcount));
                    }
                    if (results.mresultType.elementAt(rcount).equals("variable change"))
                    {
                        // todo add variable
                        key = key + "varChange";
                        // source in Y
                        // target in X
                    }
                    if (results.mresultType.elementAt(rcount).equals("intensity change"))
                    {
                        // todo add variable
                        key = key + "intensityChange";
                        // source in Y
                        // target in X
                    }

                    if (results.mresultType.elementAt(rcount).equals("play sfx"))
                    {
                        // todo add variable
                        key = key + "playsfx";
                        // source in Y
                        // target in X
                    }
                }
                if (rem == 1)
                {
                    if (results.mresultType.elementAt(rcount).equals("remove all"))
                    {
                        key = key + "RemoveAll";
                    }
                }

                if (rem == 2)
                {
                    if (results.mresultType.elementAt(rcount).equals("remove"))
                    {
                        key = key + "Remove";
                    }
                }

                if (rem == 3)
                {
                    if (results.mresultType.elementAt(rcount).equals("next level"))
                    {
                        key = key + "nextLevel";
                    }
                    if (results.mresultType.elementAt(rcount).equals("set level"))
                    {
                        // todo add level no!
                        key = key + "setLevel";
                    }
                }


    /* with multiple instances of the same trigger, I can not allow jumping back, because we can not ensure not doing code twice, code not at all - or even run into an endless loop!            
                if (triggerCountsForCause.length == 1)
                {
                    String jmpName = mTriggerResults.get(key);
                    if (jmpName != null)
                    {
                        if (branchString.length() < 4)
                        {
                            SB_actionCode.append("\tjmp      "+jmpName+"\n");
                            return;
                        }
                        String br_ins=branchString.substring(1, 1+3).toLowerCase();
                        String lbr_ins="";
                        if (br_ins.equals("brn")) lbr_ins = "lbra";
                        if (br_ins.equals("beq")) lbr_ins = "lbne";
                        if (br_ins.equals("bne")) lbr_ins = "lbeq";
                        if (br_ins.equals("bpl")) lbr_ins = "lbmi";
                        if (br_ins.equals("ble")) lbr_ins = "lbgt";
                        if (br_ins.equals("bge")) lbr_ins = "lblt";

                        if (lbr_ins.length()==0)
                        {
                            SB_actionCode.append(branchString);
                            SB_actionCode.append("\tjmp      "+jmpName+"\n");
                            return;
                        }
                        SB_actionCode.append("\t"+lbr_ins+"      "+jmpName+"\n");
                        return;
                    }
                }
    */
                if (isFirst)// (ii==0) // 0 does not work with remove beeing done behind!
                {
                    if (branchString.length()>0)
                    {
                        if (!branchString.substring(1).startsWith("brn"))
                            SB_actionCode.append(branchString);
                    }
                    else
                        SB_actionCode.append(branchString);
                }
                isFirst = false;

                triggerFoundUID++;

    /////////////////////////            
    /////////////////////////            
    /////////////////////////            

                //*********************************************
                // start handling the "results" of the triggers
                if (rem == 0)
                {
                    if (results.mresultType.elementAt(rcount).equals("variable change"))
                    {
                        String toChange = results.mresultY.elementAt(rcount);
                        String changer = results.mresultX.elementAt(rcount);

                        loadAWithVarChange(SB_actionCode, toChange, changer);
                        String varNameTarget = get8bitKey(toChange);

                        if (varNameTarget.startsWith("var"))
                        {
                            varNameTarget = varNameTarget.substring(3);
                            SB_actionCode.append("\tsta      "+varNameTarget+"\n");
                        }
                        else 
                            ShowWarningDialog.showWarningDialog("No Variable found", "No Variable found (3)! ("+mSpriteData.mName+", action: "+mActionData.mName+")");
                    }
                    if (results.mresultType.elementAt(rcount).equals("intensity change"))
                    {
                        String deltaString = results.mresultY.elementAt(rcount);
                        String code1 = genDCodeForKey(get8bitKey(deltaString), "a", "INTENSITY,s", resultY);
                        SB_actionCode.append(code1);
                        SB_actionCode.append("\tsta      INTENSITY,s ;\n");
                    }
                    if (results.mresultType.elementAt(rcount).equals("set position"))
                   {
                       SB_actionCode.append("; trigger result -> set position\n");
                       loadDWithPosChange(SB_actionCode, results.mresultY.elementAt(rcount), results.mresultX.elementAt(rcount));
                       SB_actionCode.append("\tstd      S_Y_POS,s\n");
                   }
                   if (results.mresultType.elementAt(rcount).equals("block movement"))
                   {
                       // check direction of block
                       // and inhibit movement in that direction

                       // in flag is the direction that is blocked
                       SB_actionCode.append("\tldb      FLAG,s ; load collision direction flags\n");

                       // vertical test
                       SB_actionCode.append("\tlda      Y_DELTA,s ; load current Y speed\n");
                       SB_actionCode.append("\tbeq      "+triggerIDString+"TriggerBlockCheckVerticalEscape ; 0 -> don't care\n");
                       SB_actionCode.append("\tbpl      "+triggerIDString+"TriggerBlockCheckNorth ; postive -> tries to go north\n");
                       SB_actionCode.append("\tbitb     #COLLISION_SOUTH ; negative -> here check south block\n");
                       SB_actionCode.append("\tbeq      "+triggerIDString+"TriggerBlockCheckVerticalDone ; not blocked branch\n");
                       SB_actionCode.append("\tnega       ; invert last delta\n");
                       SB_actionCode.append("\tbra      "+triggerIDString+"TriggerBlockCheckVerticalDone ; \n");

                       SB_actionCode.append(triggerIDString+"TriggerBlockCheckVerticalEscape ; 0 -> don't care\n");
                       SB_actionCode.append("\tbitb     #COLLISION_SOUTH ; \n");
                       SB_actionCode.append("\tbeq      "+triggerIDString+"TriggerBlockCheckNoEscapeNotSouth ; not blocked branch\n");
                       SB_actionCode.append("\tinca       ; one step to the north\n");
                       SB_actionCode.append("\tbra      "+triggerIDString+"TriggerBlockCheckVerticalDone ; \n");
                       SB_actionCode.append(triggerIDString+"TriggerBlockCheckNoEscapeNotSouth:\n");
                       SB_actionCode.append("\tbitb     #COLLISION_NORTH ; \n");
                       SB_actionCode.append("\tbeq      "+triggerIDString+"TriggerBlockCheckVerticalDone ; \n");
                       SB_actionCode.append("\tdeca       ; one step to the south\n");
                       SB_actionCode.append("\tbra      "+triggerIDString+"TriggerBlockCheckVerticalDone ; \n");

                       SB_actionCode.append(triggerIDString+"TriggerBlockCheckNorth: ; trying to go north\n");
                       SB_actionCode.append("\tbitb     #COLLISION_NORTH ; is it blocked?\n");
                       SB_actionCode.append("\tbeq      "+triggerIDString+"TriggerBlockCheckVerticalDone ; no... than branch\n");
                       SB_actionCode.append("\tnega       ; negate trying to go north\n");
                       SB_actionCode.append(triggerIDString+"TriggerBlockCheckVerticalDone: ; \n");
                       SB_actionCode.append("\tadda     S_Y_POS,s ; set position \n");
                       SB_actionCode.append("\tsta      S_Y_POS,s ; set position \n");

                       // horizontal test
                       SB_actionCode.append("\tlda      X_DELTA,s ; load current X speed\n");
                       SB_actionCode.append("\tbeq      "+triggerIDString+"TriggerBlockCheckHorizontalEscape ; 0 -> don't care\n");
                       SB_actionCode.append("\tbpl      "+triggerIDString+"TriggerBlockCheckEast ; postive -> tries to go east\n");
                       SB_actionCode.append("\tbitb     #COLLISION_WEST ; negative -> here check west block\n");
                       SB_actionCode.append("\tbeq      "+triggerIDString+"TriggerBlockCheckHorizontalDone ; not blocked branch\n");
                       SB_actionCode.append("\tnega       ; invert last delta\n");
                       SB_actionCode.append("\tbra      "+triggerIDString+"TriggerBlockCheckHorizontalDone ; \n");

                   SB_actionCode.append(triggerIDString+"TriggerBlockCheckHorizontalEscape: ; 0 -> don't care\n");
                       SB_actionCode.append("\tbitb     #COLLISION_WEST ; \n");
                       SB_actionCode.append("\tbeq      "+triggerIDString+"TriggerBlockCheckNoEscapeNotWest ; not blocked branch\n");
                       SB_actionCode.append("\tinca       ; one step to the east\n");
                       SB_actionCode.append("\tbra      "+triggerIDString+"TriggerBlockCheckHorizontalDone ; \n");
                       SB_actionCode.append(triggerIDString+"TriggerBlockCheckNoEscapeNotWest:\n");
                       SB_actionCode.append("\tbitb     #COLLISION_EAST ; \n");
                       SB_actionCode.append("\tbeq      "+triggerIDString+"TriggerBlockCheckHorizontalDone ; \n");
                       SB_actionCode.append("\tdeca       ; one step to the west\n");
                   SB_actionCode.append("\tbra      "+triggerIDString+"TriggerBlockCheckHorizontalDone ; \n");

                       SB_actionCode.append(triggerIDString+"TriggerBlockCheckEast: ; trying to go east\n");
                       SB_actionCode.append("\tbitb     #COLLISION_EAST ; is it blocked?\n");
                       SB_actionCode.append("\tbeq      "+triggerIDString+"TriggerBlockCheckHorizontalDone ; no... than branch\n");
                       SB_actionCode.append("\tnega       ; negate trying to go east\n");
                       SB_actionCode.append(triggerIDString+"TriggerBlockCheckHorizontalDone: ; \n");
                       SB_actionCode.append("\tadda     S_X_POS,s ; set position \n");
                       SB_actionCode.append("\tsta      S_X_POS,s ; set position \n");
                   }

                   if (results.mresultType.elementAt(rcount).equals("speed change"))
                   {
                       SB_actionCode.append("; trigger result -> speed change\n");
                       loadDWithSpeedChange(SB_actionCode, results.mresultY.elementAt(0), results.mresultX.elementAt(0));
                       SB_actionCode.append("\tstd      Y_DELTA,s\n");
                   }

                   if (results.mresultType.elementAt(rcount).equals("action change"))
                   {
                       SB_actionCode.append("; trigger result -> action change\n");
                       SB_actionCode.append("\tldx       #"+actionIDStringIter+"Behaviour ; load new behaviour (action)\n");
                       ActionNewData action = getActionByID(mSpriteData, targetAction);
                       setupNewAction(SB_actionCode, mSpriteData, action, "s", true);

                       if (action.mbehaviour.equals("parent direction"))
                       {
                           // in an action change - we do not really have a parent
                           // with different values
                           // we are actually our own parent

                           // IMHO parent direction does not make much sense here...
                       }
                   }
                    if (results.mresultType.elementAt(rcount).equals("play sfx"))
                    {
                        String actionID = results.mresultActionID.elementAt(rcount);
                        ActionNewData action = getActionByID(mSpriteData, actionID);

                        if (action.msoundFile.length() != 0)
                        {
                            SB_actionCode.append("; trigger result -> play sfx\n");
                            SB_actionCode.append("\tsts      temp16bit ; remember stack (current position in object list) \n");
                            SB_actionCode.append("\tlds      #Vec_Default_Stk ; and enable stack usage (so we can use sub routines) \n");

                            Path path = Paths.get(action.msoundFile);
                            String nameOnly = path.getFileName().toString();
                            String barenameOnly = nameOnly.substring(0, nameOnly.length()-4); // is a ".afx", tehrefor a -4 must work!
                            SB_actionCode.append("\tldd      #"+barenameOnly+"_data ; \n");
                            SB_actionCode.append("\tjsr      playSound ; \n");
                            SB_actionCode.append("\tlds      temp16bit ; restore stack to current object in object list\n");
                        }
                    }
                    boolean doRandomSpawn = false;
                    if (results.mresultType.elementAt(rcount).equals("random spawn sprite"))
                    {
                        SB_actionCode.append("; trigger result -> random spawn sprite\n");
                        SB_actionCode.append("\tsts      temp16bit ; remember stack (current position in object list) \n");
                        SB_actionCode.append("\tlds      #Vec_Default_Stk ; and enable stack usage (so we can use sub routines) \n");
                        SB_actionCode.append("\tjsr      Random ; todo replace with good random \n");
                        SB_actionCode.append("\tlds      temp16bit ; restore stack to current object in object list\n");
                        SB_actionCode.append("\tcmpa     #"+triggers.mtriggerByY.elementAt(triggerCount)+" ; compare with 'Y'\n");
                        SB_actionCode.append("\tbhi      #"+triggerIDString+"TriggerSpawnFailed ; not in range -> don't spawn\n");
                        doRandomSpawn = true;
                    }

                    if ((results.mresultType.elementAt(rcount).equals("spawn sprite")) || (doRandomSpawn))
                    {
                        String spawnID = results.mresultSpriteID.elementAt(rcount);
                        SpriteData sprite = getSpriteByID(spawnID);
                        if (sprite == null)
                        {
                            ShowWarningDialog.showWarningDialog("Sprite is Null!", "Sprite is null, did you forget to give a spawn sprite? ("+mSpriteData.mName+", action: "+mActionData.mName+")");
                        }

                        ActionNewData action = getDefaultAction(sprite);


                        if (!doRandomSpawn)
                            SB_actionCode.append("; trigger result -> sprite spawn\n");
                        int maxSprite = getMaxAllowedSprite(spawnID);

                        getSpawnPositionToX(eventCount, triggerCount, mActionData, SB_actionCode, action);


                        SB_actionCode.append("\tsts      temp16bit ; remember stack (current position in object list) \n");
                        SB_actionCode.append("\tlds      #Vec_Default_Stk ; and enable stack usage (so we can use sub routines) \n");

                        if (maxSprite>0)
                        {
                            SB_actionCode.append("\tlda      #"+maxSprite+" ; check if not to many sprites of this kind \n");
                            SB_actionCode.append("\tldb      #"+sprite.mspriteUID+" ; uid of this kind of sprites \n");
                            SB_actionCode.append("\tjsr      checkObjectCount ; Z flag is set, when not allowed \n");
                            SB_actionCode.append("\tbeq      "+triggerIDString+"TriggerSpawnFailed ; \n");
                        }

                        SB_actionCode.append("\tjsr      newObject ; return pointer to U \n");
                        SB_actionCode.append("\tcmpu     #OBJECT_LIST_COMPARE_ADDRESS ; check if object creation was successfull \n");
                        SB_actionCode.append("\tbls      "+triggerIDString+"TriggerSpawnFailed ; branch if not successfull\n");
                        if (action.mbehaviour.equals("follow sprite"))
                            SB_actionCode.append("\tstx      C_DATA_W,u\n");
                        else
                            SB_actionCode.append("\tstx      Y_POS,u\t; spawn at current location\n");

                        if (action.msoundFile.length() != 0)
                        {
                            Path path = Paths.get(action.msoundFile);
                            String nameOnly = path.getFileName().toString();
                            String barenameOnly = nameOnly.substring(0, nameOnly.length()-4); // is a ".afx", tehrefor a -4 must work!
                            SB_actionCode.append("\tldd      #"+barenameOnly+"_data ; \n");
                            SB_actionCode.append("\tjsr      playSound ; \n");
                        }

                        SB_actionCode.append("\tldx      #" + spawnID+"DefaultBehaviour" +  "\n");

                        String functionName = functionalizeNewAction(sprite, action, "u", false);
                        SB_actionCode.append("\tjsr      "+functionName+"\n");
                        SB_actionCode.append(triggerIDString+"TriggerSpawnFailed:\n");
                        if (!hasTrigger(action, "on creation"))
                            SB_actionCode.append("\tlds      temp16bit ; restore stack to current object in object list\n");

                        if (action.mbehaviour.equals("parent direction"))
                        {
                            SB_actionCode.append("\tldx      temp16bit ; this is the pointer to our stack drawn parent\n");
                            SB_actionCode.append("; --- adjust for behaviour: parent direction\n");
                            // take current direction of action
                            // use the speed of the shot

                            SB_actionCode.append("\tldb      #"+action.mchangeWhileActiveX+" ; load shot speed (assumed an absolut + value )\n");
                            SB_actionCode.append("\tlda      Y_DELTA,x ; parent speed y vertically\n");
                            SB_actionCode.append("\tsta      C_Y_DELTA,u ; set to action\n");
                            SB_actionCode.append("\tbeq      "+sprite.mName+action.mName+"yDeltaDone"+triggerFoundUID+" \n");
                            SB_actionCode.append("\tbpl      "+sprite.mName+action.mName+"yDeltaPositiv"+triggerFoundUID+" \n");
                            SB_actionCode.append("\tnegb      \n");
                            SB_actionCode.append("\tstb       C_Y_DELTA,u ; set to action\n");
                            SB_actionCode.append("\tnegb      \n");
                            SB_actionCode.append("\tbra      "+sprite.mName+action.mName+"yDeltaDone"+triggerFoundUID+" \n");
                            SB_actionCode.append(sprite.mName+action.mName+"yDeltaPositiv"+triggerFoundUID+": \n");
                            SB_actionCode.append("\tstb      C_Y_DELTA,u ; set to action\n");
                            SB_actionCode.append(sprite.mName+action.mName+"yDeltaDone"+triggerFoundUID+": \n");


                            SB_actionCode.append("\tlda      X_DELTA,x ; parent speed x vertically\n");
                            SB_actionCode.append("\tsta      C_X_DELTA,u ; set to action\n");
                            SB_actionCode.append("\tbeq      "+sprite.mName+action.mName+"xDeltaDone"+triggerFoundUID+" \n");
                            SB_actionCode.append("\tbpl      "+sprite.mName+action.mName+"xDeltaPositiv"+triggerFoundUID+" \n");
                            SB_actionCode.append("\tnegb      \n");
                            SB_actionCode.append("\tstb      C_X_DELTA,u ; set to action\n");
                            SB_actionCode.append("\tnegb      \n");
                            SB_actionCode.append("\tbra      "+sprite.mName+action.mName+"xDeltaDone"+triggerFoundUID+" \n");
                            SB_actionCode.append(sprite.mName+action.mName+"xDeltaPositiv"+triggerFoundUID+": \n");
                            SB_actionCode.append("\tstb      C_X_DELTA,u ; set to action\n");
                            SB_actionCode.append(sprite.mName+action.mName+"xDeltaDone"+triggerFoundUID+": \n");
                        }
                    
                        ActionTriggerData trigger = getTrigger(action, "on creation");
                        if (trigger != null)
                        {
                            SB_actionCode.append("\ttfr      u,y ; save u = created new sprite register usage in 'child'\n");

                            for (int eventCount2 = 0;eventCount2<action.meventUID.size();eventCount2++)
                            {
                                trigger = getTriggerByUID(action, action.meventUID.elementAt(eventCount2));
                                ActionResultData result = getResultByUID(action, action.meventUID.elementAt(eventCount2));

                                // todo assume on creation is only one trigger - does not have more trigger parts
                                // otherwise we should use a function hasOnCreation(trigger) == true
                                if (trigger.mtriggerByCause.elementAt(rcount).equals("on creation"))
                                {
                                    SB_actionCode.append("; ---- init child (follower) start ----\n");

                                    SB_actionCode.append("\tjsr      newObject\t; return pointer to U \n");
                                    SB_actionCode.append("\tcmpu     #OBJECT_LIST_COMPARE_ADDRESS ; check if object creation was successfull \n");
                                    SB_actionCode.append("\tbls      "+triggerIDString+"TriggerSpawnFailedOnCreation ; branch if not successfull\n");

                                    ActionNewData saveAction = mActionData;
                                    SpriteData saveSprite = mSpriteData;

                                    mSpriteData = getSpriteByID(result.mresultSpriteID.elementAt(rcount));
                                    mActionData = getActionByID(mSpriteData, mSpriteData.mDefaultActionID);

                                    SB_actionCode.append("\tldx      #" + mSpriteData.mName+"DefaultBehaviour" +  " ; sprites always start with their default behaviour\n");

                                    String functionName2 = functionalizeNewAction(mSpriteData, mActionData, "u", false);
                                    SB_actionCode.append("\tjsr      "+functionName2+"\n");
                                    SB_actionCode.append("\tsty      C_DATA_W,u\n");
                                    // assuming followerer are never parent direction
                                    mActionData = saveAction;
                                    mSpriteData = saveSprite;

                                    SB_actionCode.append("; ---- init child (follower) end ----\n");
                                }
                            }
                            SB_actionCode.append(triggerIDString+"TriggerSpawnFailedOnCreation:\n");
                            SB_actionCode.append("\tlds      temp16bit ; restore stack to current object in object list\n");
                        }
                    }            
               }
                if (rem == 1)
                {
                    if (results.mresultType.elementAt(rcount).equals("remove all"))
                    {
                        SB_actionCode.append("; trigger result -> remove all\n");
                        addRemoveAllCode(SB_actionCode, results.mresultSpriteID.elementAt(0));

//at the end must jump to next result                        

                    }
                }
                if (rem == 2)
                {
                    if (results.mresultType.elementAt(rcount).equals("remove"))
                    {
                        SB_actionCode.append("; trigger result -> remove\n");
                        addRemoveCode(SB_actionCode);
                        
//at the end must jump to next result                  
        
        
//each result must be possible to be inserted on its own - and repeatedly

//after all results are done -> the "end code" must be added
                        
                    }
                }
                
                
                if (rem == 3)
                {
                    if (results.mresultType.elementAt(rcount).equals("next level"))
                    {
                        SB_actionCode.append("\tMY_MOVE_TO_A_END ; if there is time left for moving... iddle away\n");
                        SB_actionCode.append("\tlds       #Vec_Default_Stk             ; correct the stack to default address\n");
                        SB_actionCode.append("\tinc       currentLevel\n");
                        SB_actionCode.append("\tjmp       initCurrentLevel ; if there is time left for moving... iddle away\n");
                    }

                    if (results.mresultType.elementAt(rcount).equals("set level"))
                    {
                        loadAWithContents(SB_actionCode, results.mresultY.elementAt(rcount));
                        SB_actionCode.append("\tcmpa      currentLevel\n");
                        SB_actionCode.append("\tbeq      "+triggerIDString+"SetLevelEqual ; \n");
                        SB_actionCode.append("\tsta       currentLevel\n");

                        SB_actionCode.append("\tMY_MOVE_TO_A_END ; if there is time left for moving... iddle away\n");
                        SB_actionCode.append("\tlds       #Vec_Default_Stk             ; correct the stack to default address\n");
                        SB_actionCode.append("\tjmp       initCurrentLevel ; if there is time left for moving... iddle away\n");
                        SB_actionCode.append(triggerIDString+"SetLevelEqual: ; \n");
                    }
                }
    /////////////////////////            
    /////////////////////////            
    /////////////////////////            
            }
        } // remove loop
        
        
        }// result count loop
        
    }
    
    
        
    void addEnemyPatrolCode()
    {
        String actionIDString = mSpriteData.mName+mActionData.mName;

        // add code to switch to other action of same (player 1 controlled) sprite
        // on trigger 
        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; -------- PATROL CODE START -------\n");
        SB_actionCode.append("; ----------------------------------\n");
        
        int dataPos = 0;
        int posCount=0;

        int maxStations = mActionData.mpositioning.size()/3;
        
        if (maxStations == 0) return;
        if (maxStations > 1) 
        {
            SB_actionCode.append("; patrol positions are handled DIRECTLY\n");
            SB_actionCode.append("; there is no list to go thru, but each\n");
            SB_actionCode.append("; position is programmed directly/immediately\n");
            SB_actionCode.append("; thus the following checks are in reality a jumptable\n");
            SB_actionCode.append("\tlda       DATA_POS,s\t; what patrol position stage are we in?\n");
        }
        int counter=0;
        while (posCount != maxStations-1)
        {
            SB_actionCode.append("\tbeq       "+actionIDString+"Patrol_"+posCount+"\n");
            posCount++;
            if (posCount<maxStations-1)
                SB_actionCode.append("\tdeca       \n");
            else
            {
                SB_actionCode.append("\tbra       "+actionIDString+"Patrol_"+(posCount)+"\n");
            }
        }

        dataPos = 0;
        posCount=0;
        while (true)
        {
            if (posCount == maxStations) break;
            int count = mActionData.mpositioning.elementAt(dataPos+0);
            int sy = mActionData.mpositioning.elementAt(dataPos+1);
            int sx = mActionData.mpositioning.elementAt(dataPos+2);
            int nextCount;
            if (posCount == maxStations-1)
                nextCount = mActionData.mpositioning.elementAt(0);
            else
                nextCount = mActionData.mpositioning.elementAt(dataPos+0+3);
            
            SB_actionCode.append(actionIDString+"Patrol_"+posCount+":\n");
            if (sy != 0)
            {
                if (sy==1) SB_actionCode.append("\tinc      S_Y_POS,s ; increase y by 1\n");
                else if (sy==-1) SB_actionCode.append("\tdec      S_Y_POS,s  ; decrease y by 1\n");
                else 
                {
                    SB_actionCode.append("\tlda       S_Y_POS,s\n");
                    SB_actionCode.append("\tadda      #"+sy+"\n");
                    SB_actionCode.append("\tsta       S_Y_POS,s ; add and store the speed to the Y position\n");
                }
            }
            
            if (sx != 0)
            {
                if (sx==1) SB_actionCode.append("\tinc      S_X_POS,s ; increase x by 1\n");
                else if (sx==-1) SB_actionCode.append("\tdec      S_X_POS,s ; decrease x by 1\n");
                else 
                {
                    SB_actionCode.append("\tldb       S_X_POS,s\n");
                    SB_actionCode.append("\taddb      #"+sx+"\n");
                    SB_actionCode.append("\tstb       S_X_POS,s ; add and store the speed to the X position\n");
                }
            }
            SB_actionCode.append("\tdec        COUNTER,s ; decrease counter for this pattrol phase\n");
            SB_actionCode.append("\tbne        "+actionIDString+"PatrolDone ; if not zero branch\n");

            if (!(posCount==maxStations-1))
                SB_actionCode.append("\tinc       DATA_POS,s ; go to the next patrol phase\n");
            else
                SB_actionCode.append("\tclr       DATA_POS,s ; reset phase to the first \n");

            SB_actionCode.append("\tlda       #"+nextCount+" ; and initialize the count for the next phase\n");
            SB_actionCode.append("\tsta        COUNTER,s\n");
            if (posCount+1 != maxStations) 
                SB_actionCode.append("\tbra        "+actionIDString+"PatrolDone\n");
            posCount++;
            dataPos+=3;
        }
        SB_actionCode.append(actionIDString+"PatrolDone:\n");
        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; -------- PATROL CODE END ---------\n");
        SB_actionCode.append("; ----------------------------------\n");
    }
    
    boolean isText(SpriteData sprite)
    {
        ActionNewData action = getDefaultAction(sprite);
        if (action == null) return true; // !?!?! - it not a propper sprite anyway
        boolean isText = ((action.mtext != null ) && (action.mtext.length() != 0 ));
        if (action.mbehaviour.equals("text")) isText=true;
        return isText;
    }
    boolean isTriggerOnly(SpriteData sprite)
    {
        ActionNewData action = getDefaultAction(sprite);
        if (action == null) return true; // !?!?! - it not a propper sprite anyway
        return (action.mbehaviour.equals("trigger only"));
    }
    boolean isPlayer(SpriteData sprite)
    {
        ActionNewData action = getDefaultAction(sprite);
        if (action == null) return false;
        return ((action.mbehaviour.equals("player 1 controlled")) || (action.mbehaviour.equals("player 2 controlled")) );
    }
    boolean isPlayer1(SpriteData sprite)
    {
        ActionNewData action = getDefaultAction(sprite);
        if (action == null) return false;
        return action.mbehaviour.equals("player 1 controlled");
    }
    boolean isPlayer2(SpriteData sprite)
    {
        ActionNewData action = getDefaultAction(sprite);
        if (action == null) return false;
            return action.mbehaviour.equals("player 2 controlled");
    }
/*    
    // only default action is checked!
    // only sprites not shots
    boolean isEnemy(SpriteData sprite)
    {
        ActionData action = getDefaultAction(sprite);
        return action.misEnemy;
    }
    // only default action is checked!
    // only sprites not shots
    boolean isEnemyShot(SpriteData sprite)
    {
        ActionData action = getDefaultAction(sprite);
        return action.misEnemyShot;
    }
    // only default action is checked!
    // only sprites not shots
    boolean isPlayerShot(SpriteData sprite)
    {
        ActionData action = getDefaultAction(sprite);
        return action.misPlayerShot;
    }
*/
    ActionResultData getResults(String uid)
    {
        Collection<String> collectionKlasse = mResultPool.getKlassenHashMap().values();
//        String klasse = "AllResults";
        String klasse = uid;//"AllTriggers";

        Collection<ActionResultData> colC = mResultPool.getMapForKlasse(klasse).values();
        Iterator<ActionResultData> iterC = colC.iterator();

        while (iterC.hasNext())
        {
            ActionResultData item = iterC.next();
            if (item.mName.equals(uid))
            {
                return item;
            }
        }
    
       
        ActionResultData results = new ActionResultData();

        results.mresultType = new Vector<String>();
        results.mresultActionID = new Vector<String>();
        results.mresultSpriteID = new Vector<String>();
        results.mresultY = new Vector<String>();
        results.mresultX = new Vector<String>();

        return results;
    }
    
    ActionTriggerData getTriggers(String uid)
    {
        Collection<String> collectionKlasse = mTriggerPool.getKlassenHashMap().values();
        String klasse = uid;//"AllTriggers";

        Collection<ActionTriggerData> colC = mTriggerPool.getMapForKlasse(klasse).values();
        Iterator<ActionTriggerData> iterC = colC.iterator();

        while (iterC.hasNext())
        {
            ActionTriggerData item = iterC.next();
            if (item.mName.equals(uid))
            {
                return item;
            }
        }
        ActionTriggerData triggers = new ActionTriggerData();

        triggers.mtriggerByCause = new Vector<String>();
        triggers.mtriggerBySpriteID = new Vector<String>();
        triggers.mtriggerByY = new Vector<Integer>();
        triggers.mtriggerByX = new Vector<Integer>();
        triggers.mtriggerByTicks = new Vector<String>();
        return triggers;
    }

    ActionTriggerData getTriggerTypeStart(ActionNewData action, String cause)
    {
        for (int i=0; i<action.meventUID.size(); i++)
        {
            ActionTriggerData triggers = getTriggers(action.meventUID.elementAt(i));
            for (int ii=0; ii<triggers.mtriggerByCause.size(); ii++)
            {
                if (triggers.mtriggerByCause.elementAt(ii).startsWith(cause))
                    return triggers;
            }
        }
        return null;
    }
    ActionTriggerData getTrigger(ActionNewData action, String testTrigger)
    {
        for (int i=0; i<action.meventUID.size(); i++)
        {
            ActionTriggerData triggers = getTriggers(action.meventUID.elementAt(i));
            for (int ii=0; ii<triggers.mtriggerByCause.size(); ii++)
            {
                if (triggers.mtriggerByCause.elementAt(ii).equals(testTrigger))
                    return triggers;
            }
        }
        return null;
    }

    ActionResultData getResult(ActionNewData action, String testTrigger)
    {
        for (int i=0; i<action.meventUID.size(); i++)
        {
            ActionTriggerData triggers = getTriggers(action.meventUID.elementAt(i));
            for (int ii=0; ii<triggers.mtriggerByCause.size(); ii++)
            {
                if (triggers.mtriggerByCause.elementAt(ii).equals(testTrigger))
                {
                    return getResults(action.meventUID.elementAt(i));
                }
            }
        }
        return null;
    }

    
    ActionTriggerData getTriggerByUID(ActionNewData action, String uid)
    {
        return getTriggers(uid);
    }
    ActionResultData getResultByUID(ActionNewData action, String uid)
    {
        return getResults(uid);
    }

    boolean hasTriggerTypeStart(ActionNewData action, String cause)
    {
        return getTriggerTypeStart(action, cause) != null;
    }
    boolean hasTrigger(ActionNewData action, String cause)
    {
        return getTrigger(action, cause) != null;
    }

    
    boolean hasPositionTrigger(ActionNewData action)
    {
        return hasTriggerTypeStart(action, "position");
    }
    boolean hasButtonAction(ActionNewData action)
    {
        return hasTriggerTypeStart(action, "button");
    }    
    boolean hasButton1Action(ActionNewData action)
    {
        return hasTrigger(action, "button 1");
    }    
    boolean hasButton2Action(ActionNewData action)
    {
        return hasTrigger(action, "button 2");
    }    
    boolean hasButton3Action(ActionNewData action)
    {
        return hasTrigger(action, "button 3");
    }    
    boolean hasButton4Action(ActionNewData action)
    {
        return hasTrigger(action, "button 4");
    }    

    boolean hasSpriteCollisionWithSprite(SpriteData thisSprite, SpriteData thatSprite)
    {
        if (thisSprite == null) return false;
        if (thatSprite == null) return false;
        boolean ret = false;

        // go thru all actions of one sprite and look if
        // we have any collision with other sprite
        Collection<ActionNewData> colCa = mActionDataPool.getMapForKlasse(thisSprite.mName+"_Actions").values();
        Iterator<ActionNewData> iterCa = colCa.iterator();
        while (iterCa.hasNext())
        {
            ActionNewData actionData = iterCa.next();
            // go thru all triggers of action of player and look if
            // we have any collision with given sprite
            
            for (int eventCount = 0;eventCount<actionData.meventUID.size();eventCount++)
            {
                ActionTriggerData triggers = getTriggerByUID(actionData, actionData.meventUID.elementAt(eventCount));
                for (int triggerCount = 0;triggerCount<triggers.mtriggerByCause.size();triggerCount++)
                {
                    if (triggers.mtriggerByCause.elementAt(triggerCount).equals("sprite collision"))
                    {
                        if (triggers.mtriggerBySpriteID.elementAt(triggerCount).equals(thatSprite.mName))
                            return true;
                    }
                }
            }
        }

        // and vice versa!
        colCa = mActionDataPool.getMapForKlasse(thatSprite.mName+"_Actions").values();
        iterCa = colCa.iterator();
        while (iterCa.hasNext())
        {
            ActionNewData actionData = iterCa.next();
            // go thru all triggers of action of player and look if
            // we have any collision with given sprite
            for (int eventCount = 0;eventCount<actionData.meventUID.size();eventCount++)
            {
                ActionTriggerData triggers = getTriggerByUID(actionData, actionData.meventUID.elementAt(eventCount));
                for (int triggerCount = 0;triggerCount<triggers.mtriggerByCause.size();triggerCount++)
                {
                    if (triggers.mtriggerByCause.elementAt(triggerCount).equals("sprite collision"))
                    {
                        if (triggers.mtriggerBySpriteID.elementAt(triggerCount).equals(thisSprite.mName))
                            return true;
                    }
                }
            }
        }
        return false;
    }
    
    
    boolean hasPlayer1CollisionWith(SpriteData sprite)
    {
        return hasSpriteCollisionWithSprite(getPlayer1Sprite(), sprite);
    }
    boolean hasPlayer2CollisionWith(SpriteData sprite)
    {
        return hasSpriteCollisionWithSprite(getPlayer2Sprite(), sprite);
    }
    
    // any player versus player - only added to player1
    void addPlayerVersusPlayerCollision()
    {
        if (!isPlayer1(mSpriteData)) return; 

        // is there a collision configured?
        if (!hasSpriteCollisionWithSprite(getPlayer1Sprite(), getPlayer2Sprite())) return; 

        String actionIDString = mSpriteData.mName+mActionData.mName;
        ActionNewData player1Data = getPlayer1();

        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; ---- COLLISION CODE START PvP ----\n");
        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("\tldx      main2Pointer  ; player pointer \n");
// WAS START
        generalCollisionDetection(SB_actionCode, "actionDelta1", "actionDelta2", "actionDelta1+1", "actionDelta2+1", "P1vP2", null,100,100,100,100);
// WAS END
        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; ----- COLLISION CODE END PvP -----\n");
        SB_actionCode.append("; ----------------------------------\n");
    }

    byte abs(byte i)
    {
        if (i<0) return (byte) (-i);
        return i;
    }
    // using boundingBoxData
    // expects in X not stack pulled "opponent"
    // expects in S stack pulled "ourself"
    int generalDetectionUID=0;
    void generalCollisionDetection(StringBuilder s, String delta1Y, String delta2Y, String delta1X, String delta2X, String kindOfCheck, String endBranch
    , int idelta1Y, int idelta12Y, int idelta1X, int idelta2X )
    {
        generalDetectionUID++;
        String actionIDString = mSpriteData.mName+mActionData.mName+generalDetectionUID+"_"+kindOfCheck;

        if (endBranch == null)
            endBranch = "\tbhs      "+actionIDString+"NoColDetect ; if lower -> we overlap, possible collision, lets check X\n";

        s.append("\tclrb      ; used as 8 bit buffer for hit directions, lower 4 bits opponent, upper 4 bits ourself\n");

        boolean forceTest = false;
        if ( abs((byte) (idelta1X - idelta1Y)) <5 ) forceTest = true;
        // Y
        s.append("; check Y position \n");
        s.append("\tlda      "+delta1Y+"  ; y delta of ourself action\n");
        s.append("\tadda     "+delta2Y+"  ; y delta of opponent action\n");
        s.append("\tsta      temp8bit    ; the complete HEIGHT of possible overlap \n");

        s.append("\tlda      Y_POS,x       ; load opponent Y position \n");
        s.append("\tsuba     S_Y_POS,s     ; subtract the ourself Y position \n");
        s.append("\tbpl      "+actionIDString+"YDeltaIsPositiv\n");
        s.append("\tnega     ; we are interested in ABSOLUT values for overlapping\n");
        s.append("\torb      #LoN_HiS ; Opponent is hit from north\n");
        s.append("\tbra      "+actionIDString+"YDeltaNegativeDone\n");
        s.append(actionIDString+"YDeltaIsPositiv:\n");
        s.append("\torb      #LoS_HiN ;Opponent is hit from south\n");
        s.append(actionIDString+"YDeltaNegativeDone:\n");

        s.append("\tcmpa     temp8bit ; compare the resulting position difference, with our max delta\n");
        s.append(endBranch);

        if ((idelta1X>=2)||(forceTest)) // if lower 2 than probably a vertical wall - do not favour verticals in result
        {
            s.append("\tsta     temp16bit ; remember the absolut difference (8bit used)\n");
        }
        else
            s.append("\tclr     temp16bit ; possibly vertical wall - interfere with resulting ONE result\n");

        // X
        s.append("; check X position \n");
        s.append("\tlda      "+delta1X+" ; x delta of ourself action\n");
        s.append("\tadda     "+delta2X+" ; x delta of opponent action\n");
        s.append("\tsta      temp8bit ; the complete WIDTH of possible overlap \n");

        s.append("\tlda      X_POS,x       ; load player opponent X position\n");
        s.append("\tsuba     S_X_POS,s     ; subtract ourself X postion\n");
        s.append("\tbpl      "+actionIDString+"XDeltaIsPositiv\n");
        s.append("\tnega     ; we are interested in ABSOLUT values for overlapping\n");
        s.append("\torb      #LoE_HiW ; Opponent is hit from east\n");
        s.append("\tbra      "+actionIDString+"XDeltaNegativeDone\n");
        s.append(actionIDString+"XDeltaIsPositiv:\n");
        s.append("\torb      #LoW_HiE ; P2 is hit from west\n");
        s.append(actionIDString+"XDeltaNegativeDone:\n");

        s.append("\tcmpa     temp8bit ; compare the resulting position difference, with our max delta\n");
        s.append(endBranch);


        if ((idelta1Y>=2)||(forceTest)) // if lower 2 than probably a horizintal wall - do not check horizontal!
        {
        
        }
        else
            s.append("\tclra ; possibly horizontal wall - interfere with resulting ONE result\n");

        // collision!
        s.append(";--- collision between sprites! \n");

        s.append(" ; in reg A and temp16bit the vertical and horizontal overlappings are stored\n");
        s.append(" ; the larger of both is probably our most\n");
        s.append(" ; recent overlapping\n");
        s.append(" ; so this defines the ONE direction the collision happened\n");
        s.append(" ; if reg A smaller temp16, than vertical is 'main'\n");

        s.append("\tcmpa     temp16bit ; compare the horizontal and vertical distances\n");
        s.append("\tblo     "+actionIDString+"VerticalIsMain ; \n");
        s.append("\tandb    #NO_VERTICAL_AND ; horizontal is main\n");
        s.append("\tbra     "+actionIDString+"MainCheckDone ; \n");

        s.append(actionIDString+"VerticalIsMain:\n");
        s.append("\tandb    #NO_HORZONTAL_AND ; \n");
        s.append(actionIDString+"MainCheckDone:\n");
        
        s.append(" ; store out findings to the sprite flag\n");
        s.append("\ttfr      b,a       ; store a  copy of the flags in reg A\n");
        s.append("\tanda     #%00001111 ; flag of only opponent \n");
        s.append("\tora      #SPRITE_SPRITE_COLLISION_BIT ; and add a sprite collision! \n");
        s.append("\tsta      C_FLAG,x       ; store it\n");

        s.append("\tlsrb    ; scroll in our own flags \n");
        s.append("\tlsrb     \n");
        s.append("\tlsrb     \n");
        s.append("\tlsrb     \n");
        s.append("\torb      #SPRITE_SPRITE_COLLISION_BIT ; and add a sprite collision! \n");
        s.append("\tstb      FLAG,s       ; store it\n");
        
        s.append("\tldu      S_BEHAVIOUR,s       ; Behaviour of ourself\n");
        s.append("\tlda      -1,u       ; sprite ID of this sprite \n");
        s.append("\tsta      C_COLLISION_ID,x       ; store to opponent our ID as collision id \n");

        //; -> set player sprite id to opposite collision        
        s.append("\tldu      BEHAVIOUR,x       ; Behaviour of opponent\n");
        s.append("\tlda      -1,u              ; sprite ID of opponent \n");
        s.append("\tsta      COLLISION_ID,s    ; store to ourself the collision ID of the opponent\n");
        s.append(actionIDString+"NoColDetect:\n");
    }

    
    // any sprite versus player
    // if configured in current player action
    void addPlayerCollisionDetection()
    {
        //boolean isEnemyShot = isEnemyShot(mSpriteData);
        //boolean isEnemy = isEnemy(mSpriteData);
        //boolean isPlayerShot = isPlayerShot(mSpriteData);
        boolean isPlayer = isPlayer(mSpriteData);
        if (isPlayer) return; // player vs player must be handled extra!

        if (hasPlayer1CollisionWith(mSpriteData)) 
        {
    
            // 1) get current player 
            // 2) see if he has colision detection with current sprite
            // 3) if yes do a bounding box check
            // 4) set player colision flag 
            // 5) in the next player behaviour round the action is switched due to the flag
            // 
            String actionIDString = mSpriteData.mName+mActionData.mName;
            ActionNewData player1Data = getPlayer1();

            GFXVectorList boundingList = ActionPanel.computeBoundingBoxStatic(mActionData);
            if (boundingList==null) return;

            int dyi = (((int)boundingList.get(0).start.y()/BLOW) - ((int)boundingList.get(2).start.y()/BLOW))/2;
            int dxi = (((int)boundingList.get(0).start.x()/BLOW) - ((int)boundingList.get(2).start.x()/BLOW))/2;

            byte dx = (byte)(dxi&0xff);
            byte dy = (byte)(dyi&0xff);

            String xd = String.format("$%02X", dx);
            String yd = String.format("$%02X", dy);

            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ COLLISION CODE START P1 ---\n");
            SB_actionCode.append("; ----------------------------------\n");
// WAS START
            SB_actionCode.append("\tldx      main1Pointer  ; player pointer \n");
        generalCollisionDetection(SB_actionCode, "#"+yd,"actionDelta1",  "#"+xd,"actionDelta1+1",  "SvP1", null,abs(dy),100,abs(dx),100);
// WAS END

            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ COLLISION CODE END P1 -----\n");
            SB_actionCode.append("; ----------------------------------\n");
        }

        if (hasPlayer2CollisionWith(mSpriteData)) 
        {
            // 1) get current player 
            // 2) see if he has colision detection with current sprite
            // 3) if yes do a bounding box check
            // 4) set player colision flag 
            // 5) in the next player behaviour round the action is switched due to the flag
            // 
            String actionIDString = mSpriteData.mName+mActionData.mName;
            ActionNewData player2Data = getPlayer2();

            GFXVectorList boundingList = ActionPanel.computeBoundingBoxStatic(mActionData);
            if (boundingList==null) return;

            int dyi = (((int)boundingList.get(0).start.y()/BLOW) - ((int)boundingList.get(2).start.y()/BLOW))/2;
            int dxi = (((int)boundingList.get(0).start.x()/BLOW) - ((int)boundingList.get(2).start.x()/BLOW))/2;

            byte dx = (byte)(dxi&0xff);
            byte dy = (byte)(dyi&0xff);

            String xd = String.format("$%02X", dx);
            String yd = String.format("$%02X", dy);


            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ COLLISION CODE START P2 ---\n");
            SB_actionCode.append("; ----------------------------------\n");
// WAS START
            SB_actionCode.append("\tldx      main2Pointer  ; player pointer \n");
            generalCollisionDetection(SB_actionCode, "#"+yd,"actionDelta2", "#"+xd, "actionDelta2+1",  "SvP2", null,abs(dy),100,abs(dx),100);
// WAS END
            SB_actionCode.append("; ----------------------------------\n");
            SB_actionCode.append("; ------ COLLISION CODE END P2 -----\n");
            SB_actionCode.append("; ----------------------------------\n");
        }
    }
   
    int spriteColDetectionUID = 0;
    // this sprite is collision detected with ALL
    // in this sprite set triggered sprites (no player, no text, no trigger only)
    void addNonPlayerCollisionDetection()
    {
        if (isPlayer(mSpriteData)) return; 
        if (isText(mSpriteData)) return;
        if (isTriggerOnly(mSpriteData)) return;
        
        
        
        GFXVectorList boundingList = ActionPanel.computeBoundingBoxStatic(mActionData);
        if (boundingList==null) return;
        int dyi = (((int)boundingList.get(0).start.y()/BLOW) - ((int)boundingList.get(2).start.y()/BLOW))/2;
        int dxi = (((int)boundingList.get(0).start.x()/BLOW) - ((int)boundingList.get(2).start.x()/BLOW))/2;
        byte dx = (byte)(dxi&0xff);
        byte dy = (byte)(dyi&0xff);
        String xd = String.format("$%02X", dx);
        String yd = String.format("$%02X", dy);

        int[] colDetectSpriteIDs = getColDetectSpriteIDs();
        if (colDetectSpriteIDs.length == 0) return;
        
        spriteColDetectionUID++;
        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; ------ COLLISION CODE START ------\n");
        SB_actionCode.append("; ------- SPRITE <-> SPRITE --------\n");
        SB_actionCode.append("; ----------------------------------\n");

        String actionIDString = mSpriteData.mName+mActionData.mName;
        String uid = actionIDString+"spvsp"+spriteColDetectionUID;

        SB_actionCode.append("; go thru all possible sprites!\n");
        SB_actionCode.append("\tldx      objectlist_used_head ; load head of the object list\n");
        SB_actionCode.append(uid+"compareNextObject:\n");

        SB_actionCode.append("\tldu      BEHAVIOUR,x ; load behaviour address\n");
        SB_actionCode.append("\tlda      -1,u ; load sprite ID of the other sprite, check if we are interested\n");
        
        boolean selfCheckFound = false;
        for (int i=0;i<colDetectSpriteIDs.length; i++)
        {
            SpriteData otherSprite = getSpriteByUID(colDetectSpriteIDs[i]);
            if (otherSprite == null)
            {
                ShowWarningDialog.showWarningDialog("Collision with unkown sprite", "Did you add all sprites to the level, that you defined in your actions? (Sprite: "+mSpriteData.mName+", action: "+mActionData.mName+", unkown sprite ID: "+colDetectSpriteIDs[i]+")");
                continue;
            }
            
            if (isPlayer(otherSprite)) continue;
            if (isText(otherSprite)) continue;
            if (isTriggerOnly(otherSprite)) continue;

            String key1 = otherSprite.mName+"Versus"+mSpriteData.mName;
            String key2 = mSpriteData.mName+"Versus"+otherSprite.mName;
            
            // this check was already done (in the other sprite?)
            if (mSpriteVersusSpriteDone.get(key1) != null) continue;
            mSpriteVersusSpriteDone.put(key1, key1);
            mSpriteVersusSpriteDone.put(key2, key2);

            // colision detection with possibly ourself
            // check object address!!!
            if (mSpriteData.mspriteUID == colDetectSpriteIDs[i])
            {
                selfCheckFound = true;
                continue;
            }
            
            SB_actionCode.append("\tcmpa     #"+colDetectSpriteIDs[i]+" ; interested in this one?\n");
            SB_actionCode.append("\tbeq      "+uid+"checkForColDetect; if yes, branch to the check\n");
        }
        
        // do check with our own kind LAST
        if (selfCheckFound)
        {
            SB_actionCode.append(" ; this is a collision with our own kind - special check needed!\n");
            SB_actionCode.append("\tcmpa     #"+mSpriteData.mspriteUID+" ; interested in this one?\n");
            SB_actionCode.append("\tbne      "+uid+"checkNextObject ; if no, branch to next\n");

            // in x the start address of the "other" sprite in ram
            // in s is the stack pulled address of our own
            SB_actionCode.append(" ; ensure we are not testing for coliision with ourself\n");
            SB_actionCode.append("\tleay     STACK_PULL_OFFSET,x ; in y the start in ram of the current handled object\n");
            SB_actionCode.append("\tsty     temp16bit ; save to be able to compare\n");
            SB_actionCode.append("\tcmpx     temp16bit ; compare\n");
            SB_actionCode.append("\tbne      "+uid+"checkForColDetect; if not the same, branch to the check\n");
        }
        
        SB_actionCode.append(uid+"checkNextObject:\n");
        SB_actionCode.append("\tldx      NEXT_OBJECT,x ; initiate the next possible object to test \n");
        SB_actionCode.append("\tcmpx     #OBJECT_LIST_COMPARE_ADDRESS; is it the end of the list?\n");
        SB_actionCode.append("\tbhi      "+uid+"compareNextObject; no, than branch to next check\n");
        SB_actionCode.append("\tbra      "+uid+"objectsDoneNoCollision; yes -> than get out of here\n");


        SB_actionCode.append(uid+"checkForColDetect:\n");

        SB_actionCode.append("; in X pointer to other sprite to be checked\n");
// WAS START
            generalCollisionDetection(SB_actionCode, "#"+yd,"C_HEIGHT,x", "#"+xd, "C_WIDTH,x",  "SvS", "\tbhi      "+uid+"checkNextObject ; if lower -> we overlap, continue\n",abs(dy),100,abs(dx),100);
// WAS END


// needed?
// is not one col detect enough?
// SB_actionCode.append("\tbra      "+uid+"checkNextObject ; \n");
                


        SB_actionCode.append(uid+"objectsDoneNoCollision:\n");

        SB_actionCode.append("; ----------------------------------\n");
        SB_actionCode.append("; ------- COLLISION CODE END -------\n");
        SB_actionCode.append("; ------- SPRITE <-> SPRITE --------\n");
        SB_actionCode.append("; ----------------------------------\n");
    }

    int continuousNumber=0;
    void setupNewAction(StringBuilder s, SpriteData sprite,ActionNewData action , String indexRegister, boolean stackAlreadyPulled)
    {
        continuousNumber++;
        HashMap<String, String> stackWasPulled = new HashMap<String, String>();
        HashMap<String, String> stackNotPulled = new HashMap<String, String>();
        stackWasPulled.put("BEHAVIOUR", "S_BEHAVIOUR");
        stackWasPulled.put("DATA_POS", "DATA_POS");
        stackWasPulled.put("COUNTER", "COUNTER");
        stackWasPulled.put("DATA_W", "DATA_W");
        stackWasPulled.put("X_DELTA", "X_DELTA");
        stackWasPulled.put("Y_DELTA", "Y_DELTA");
        stackWasPulled.put("TEXT", "TEXT");
        stackWasPulled.put("FLAG", "FLAG");
        stackWasPulled.put("ANIM_PLACE", "ANIM_PLACE");
        stackWasPulled.put("TIMER", "TIMER");
        stackWasPulled.put("Y_POS", "S_Y_POS");
        stackWasPulled.put("X_POS", "S_X_POS");
        stackWasPulled.put("INTENSITY", "INTENSITY");
        stackWasPulled.put("HEIGHT", "HEIGHT");
        stackWasPulled.put("WIDTH", "WIDTH");
        stackWasPulled.put("COLLISION_ID", "COLLISION_ID");
        
        stackNotPulled.put("BEHAVIOUR", "BEHAVIOUR");
        stackNotPulled.put("DATA_POS", "C_DATA_POS");
        stackNotPulled.put("COUNTER", "C_COUNTER");
        stackNotPulled.put("TEXT", "C_TEXT");
        stackNotPulled.put("DATA_W", "C_DATA_W");
        stackNotPulled.put("X_DELTA", "C_X_DELTA");
        stackNotPulled.put("Y_DELTA", "C_Y_DELTA");
        stackNotPulled.put("FLAG", "C_FLAG");
        stackNotPulled.put("ANIM_PLACE", "C_ANIM_PLACE");
        stackNotPulled.put("TIMER", "C_TIMER");
        stackNotPulled.put("INTENSITY", "C_INTENSITY");
        stackNotPulled.put("Y_POS", "Y_POS");
        stackNotPulled.put("X_POS", "X_POS");
        stackNotPulled.put("HEIGHT", "C_HEIGHT");
        stackNotPulled.put("WIDTH", "C_WIDTH");
        stackNotPulled.put("COLLISION_ID", "C_COLLISION_ID");

        
        
        HashMap<String, String> m;
        if (stackAlreadyPulled) m = stackWasPulled; else m = stackNotPulled;
        if (action == null)
        {
            ShowWarningDialog.showWarningDialog("Action is Null!", "Action is null, did you perhaps rename an action/sprite? ("+sprite.mName+", action: "+action.mName+")");
            return;
        }
        boolean isPlayer1 = (action.mbehaviour.equals("player 1 controlled"));
        boolean isPlayer2 = (action.mbehaviour.equals("player 2 controlled"));
        boolean isTriggerOnly = (action.mbehaviour.equals("trigger only"));

        GFXVectorList boundingList = null;
        
        boolean isTextAction = isText(sprite);

        if (isTextAction)
        {
            // handle text address to DATA_W
            String[] t = cleanSplitNL(action.mtext);
            String v = mtextDone.get(action.mtext);
            if (v == null)
            {
                if (t.length <= 1)
                    s.append("\tldd      #"+sprite.mName+action.mName+"Text ; load text for this action \n");
                else 
                    s.append("\tldd      #"+sprite.mName+action.mName+"MultiText ; load text for this action \n");
            }
            else
                s.append("\tldd      #"+v+" ; load text for this action \n");
            s.append("\tstd      "+m.get("TEXT")+","+indexRegister+" ; set to action\n");

            // handle text width and height
            s.append("\tlda       #"+action.mtextHeight+" ; height\n");
            s.append("\tsta       "+m.get("HEIGHT")+","+indexRegister+" ; set to action\n");
            s.append("\tlda       #"+action.mtextWidth+" ; width\n");
            s.append("\tsta       "+m.get("WIDTH")+","+indexRegister+" ; set to action\n");
            if (mActionData.mintensity.length() != 0)
            {
                int intensity = IntX(mActionData.mintensity, 300);

                // intensity has an immediate value?
                if (intensity != 300)
                {
                    s.append("\tlda      #"+intensity+" ; load the intensity value\n");
                    s.append("\tsta      "+m.get("INTENSITY")+","+indexRegister+" ; and set it to the object structure\n");
                }
                else
                {
                    ShowWarningDialog.showWarningDialog("Text & Intensity", "Text sprites are not allowed to have a variable in intensity! (Sprite: "+sprite.mName+", Action: "+action.mName+")");
                    s.append("\tlda      #$ff ; don't use intensity\n");
                    s.append("\tsta      "+m.get("INTENSITY")+","+indexRegister+" ; and set it to the object structure\n");
                }
            }
            else
            {
                s.append("\tlda      #$ff ; don't use intensity\n");
                s.append("\tsta      "+m.get("INTENSITY")+","+indexRegister+" ; and set it to the object structure\n");
            }
        }
        else
        {
            // intensity used with this one?
            if (mActionData.mintensity.length() != 0)
            {
                int intensity = IntX(mActionData.mintensity, 300);

                // intensity has an immediate value?
                if (intensity != 300)
                {
                    s.append("\tlda      #"+intensity+" ; load the intensity value\n");
                    s.append("\tsta      "+m.get("INTENSITY")+","+indexRegister+" ; and set it to the object structure\n");
                }
            }

            if (!isTriggerOnly)
                boundingList = ActionPanel.computeBoundingBoxStatic(action);
        }

        if (boundingList!=null)
        {
            int dyi = (((int)boundingList.get(0).start.y()/BLOW) - ((int)boundingList.get(2).start.y()/BLOW))/2;
            int dxi = (((int)boundingList.get(0).start.x()/BLOW) - ((int)boundingList.get(2).start.x()/BLOW))/2;

            byte dx = (byte)(dxi&0xff);
            byte dy = (byte)(dyi&0xff);

            String xd = String.format("$%02X", dx);
            String yd = String.format("$%02X", dy);

            s.append("\tlda       #"+yd+" ; height\n");
            s.append("\tsta       "+m.get("HEIGHT")+","+indexRegister+" ; set to action\n");
            s.append("\tlda       #"+xd+" ; width\n");
            s.append("\tsta       "+m.get("WIDTH")+","+indexRegister+" ; set to action\n");
        }

        s.append("\tstx       "+m.get("BEHAVIOUR")+","+indexRegister+" ; set the behaviour\n");
        if ((!isTriggerOnly)|| (isTextAction))
        {
            if (!action.mchangeWhileActiveY.contains("a"))
            {
                if (action.mchangeWhileActiveY.length()==0)
                    ShowWarningDialog.showWarningDialog("Text Zero length!", "Delta Y is not set! (Sprite: "+sprite.mName+", Action: "+action.mName+")");
                s.append("\tlda       #"+action.mchangeWhileActiveY+" ; get speed value y\n");
                s.append("\tsta       "+m.get("Y_DELTA")+","+indexRegister+" ; set to action\n");
            }
            if (!action.mchangeWhileActiveX.contains("a"))
            {
                if (action.mchangeWhileActiveX.length()==0)
                    ShowWarningDialog.showWarningDialog("Text Zero length!", "Delta X is not set! (Sprite: "+sprite.mName+", Action: "+action.mName+")");
                
                s.append("\tlda       #"+action.mchangeWhileActiveX+" ; get speed value x\n");
                s.append("\tsta       "+m.get("X_DELTA")+","+indexRegister+" ; set to action\n");
            }
        }
        int ltindex = getLongTimerEventIndex(action);
        
        boolean isLongTimer = ltindex != -1;
        boolean isFollow = (action.mbehaviour.equals("follow sprite"));

        if ((isTextAction) && (action.mbehaviour.equals("patrol")))
            ShowWarningDialog.showWarningDialog("Text on Patrol!", "An action can not be both - a text action and have the patrol flag!");
        if ((isLongTimer) && (action.mbehaviour.equals("patrol")))
            ShowWarningDialog.showWarningDialog("Long timer on Patrol!", "An action can not be both - a long timer and have the patrol flag!");
        if ((isLongTimer) && (isTextAction))
            ShowWarningDialog.showWarningDialog("Long timer on Text!", "An action can not be both - a long timer and have text!");

        if ((isFollow) && (action.mbehaviour.equals("patrol")))
            ShowWarningDialog.showWarningDialog("Follow on Patrol!", "An action can not be both - a Follow and have the patrol flag!");
        if ((isFollow) && (isLongTimer))
            ShowWarningDialog.showWarningDialog("Follow on Long timer!", "An action can not be both - a long timer and Follow!");
        if ((isFollow) && (isTextAction))
            ShowWarningDialog.showWarningDialog("Follow on Text!", "An action can not be both - a Follow and have text!");

        
        // patroling enemies
        if (action.mbehaviour.equals("patrol"))
        {
            s.append(" ; init patroling\n");
            s.append("\tclr       "+m.get("DATA_POS")+","+indexRegister+" ; start with patrol position 0\n");
            int count = 1;
            if (action.mpositioning != null)
               if (action.mpositioning.size() != 0)
                count = action.mpositioning.elementAt(0);
            s.append("\tlda       #"+count+"\n");
            s.append("\tsta       "+m.get("COUNTER")+","+indexRegister+" ; and remember the times the patrol data should be applied\n");
        }
        else if (!isTextAction)
        {
            if (isLongTimer)
            {
                // reload timer
                
// todo
// event index                
                ActionTriggerData triggers = getTriggerByUID(action, action.meventUID.elementAt(ltindex));
                String load = triggers.mtriggerByTicks.elementAt(0);
                if (load.startsWith("=")) 
                {
                    load = load.substring(1);
                    s.append("\tldd      "+load+" ; load timer (16bit)\n");
                }
                else
                {
                    s.append("\tldd      #"+load+" ; load timer\n");
                }
            }
            else if (isFollow)
            {
                // follower gets the parent set in "parent"
            }
            else
            {
                s.append("\tldd       #0 ; init unused object fields to 0\n");
            }
            if (!isFollow)
                s.append("\tstd       "+m.get("DATA_W")+","+indexRegister+"\n");
        }

        s.append("\tclra      \n");
        s.append("\tsta       "+m.get("FLAG")+","+indexRegister+" ; clear flags (collision detection) \n");
        
        if (!isTriggerOnly)
        {
            s.append("\tclr       "+m.get("ANIM_PLACE")+","+indexRegister+" ; clear animation position\n");
            s.append("\tclr       "+m.get("COLLISION_ID")+","+indexRegister+" ; clear colision ID\n");
        }
        if (isPlayer1)
        {
            // in intro a text can be a player ... waiting for button!
            if (!isTextAction)
            {
                s.append(" ; player 1 remember delta data\n");
                s.append("\tldd      "+sprite.mName+action.mName+"DeltaData  ; that is the bounding box data as delta\n");
                s.append("\tstd      actionDelta1\n");
            }
        }
        if (isPlayer2)
        {
            // in intro a text can be a player ... waiting for button!
            if (!isTextAction)
            {
                s.append(" ; player 2 remember delta data\n");
                s.append("\tldd      "+sprite.mName+action.mName+"DeltaData  ; that is the bounding box data as delta\n");
                s.append("\tstd      actionDelta2\n");
            }
        }
// todo 
// singular index!
        int tindex = getTimerEventIndex(action);

        
        if (tindex!=-1)
        {
            ActionTriggerData triggers = getTriggerByUID(action, action.meventUID.elementAt(tindex));
            // reload timer
            String reload = triggers.mtriggerByTicks.elementAt(0);
            if (reload.startsWith("=")) 
            {
                reload = reload.substring(1);
                s.append("\tlda      "+reload+" ; load timer\n");
            }
            else
            {
                s.append("\tlda      #"+reload+" ; load timer\n");
            }
        }
        else
            s.append("\tclra ; clear timer tick count (not used with this action)\n");

        s.append("\tsta      "+m.get("TIMER")+","+indexRegister+"\n");

        if (action.mbehaviour.equals("fixed movement"))
        {
        }
        if (action.mbehaviour.equals("parent direction"))
        {
            /*
            this can only be done where we KNOW the parent
            at the spawn point
            in here we do not know where to look!
            */
            // here we must set the defined y_delta, x_delta, so we can use them where we are spawned!
            // but this is already done above!
                        
        }
        
        if (action.mbehaviour.equals("target player 1"))
        {
            int shotSpeed = IntX(action.mchangeWhileActiveY,1);

            s.append("; --- adjust for behaviour: target player 1\n");
            // set "speeds" and direction
            // to target approxemately current player position
            s.append("; --- vertical\n");
            s.append("\tldx      main1Pointer  ; player pointer \n");

            s.append("\tlda      Y_POS,x ; current player Y position\n");
            s.append("\tsuba     "+m.get("Y_POS")+","+indexRegister+" ; delta to our position \n");
            s.append("\tbpl      "+sprite.mName+action.mName+"TargetPlayer1YDeltaNoNeg"+continuousNumber+" \n");
            s.append("\tnega      \n");
            s.append(sprite.mName+action.mName+"TargetPlayer1YDeltaNoNeg"+continuousNumber+":\n");
            s.append("\tcmpa     #10 ; compare to shot position \n");
            s.append("\tbhs      "+sprite.mName+action.mName+"TargetPlayer1YNotTiny"+continuousNumber+" \n");
            s.append("\tclrb     \n");
            s.append("\tbra      "+sprite.mName+action.mName+"TargetPlayer1YDone"+continuousNumber+"\n");
            s.append(sprite.mName+action.mName+"TargetPlayer1YNotTiny"+continuousNumber+":\n");

            s.append("\tlda      Y_POS,x ; current player Y position\n");
            s.append("\tcmpa     "+m.get("Y_POS")+","+indexRegister+" ; compare to shot position \n");
            s.append("\tbgt      "+sprite.mName+action.mName+"TargetPlayer1YGreater"+continuousNumber+"\n");
            s.append("\tldb      #-"+shotSpeed+" ; if lower, than negative speed\n");
            s.append("\tbra      "+sprite.mName+action.mName+"TargetPlayer1YDone"+continuousNumber+"\n");
            s.append(sprite.mName+action.mName+"TargetPlayer1YGreater"+continuousNumber+":\n");
            s.append("\tldb      #"+shotSpeed+" ; if higher, than positive speed\n");
            s.append(sprite.mName+action.mName+"TargetPlayer1YDone"+continuousNumber+":\n");
            s.append("\tstb      "+m.get("Y_DELTA")+","+indexRegister+" ; store the speed to Y_DELTA\n");
            s.append("\tsuba     "+m.get("Y_POS")+","+indexRegister+" ; calculate the the delta of the two positions\n");
            s.append("\tbpl      "+sprite.mName+action.mName+"TargetPlayer1YGreaterNoNeg"+continuousNumber+"\n");
            s.append("\tnega     ; only the ABSOLUT value\n");
            s.append(sprite.mName+action.mName+"TargetPlayer1YGreaterNoNeg"+continuousNumber+": \n");
            s.append("\tsta      temp8bit ; and store it in tmp\n");

            s.append("; --- horizontal\n");
            s.append("\tlda      X_POS,x ; current player X position\n");
            s.append("\tsuba     "+m.get("X_POS")+","+indexRegister+" ; delta to our position \n");
            s.append("\tbpl      "+sprite.mName+action.mName+"TargetPlayer1XDeltaNoNeg"+continuousNumber+"\n");
            s.append("\tnega      \n");
            s.append(sprite.mName+action.mName+"TargetPlayer1XDeltaNoNeg"+continuousNumber+":\n");
            s.append("\tcmpa     #10 ; compare to shot position \n");
            s.append("\tbhs      "+sprite.mName+action.mName+"TargetPlayer1XNotTiny"+continuousNumber+"\n");
            s.append("\tclrb     \n");
            s.append("\ttst      "+m.get("Y_DELTA")+","+indexRegister+" ; check if both directions are 0 - if so load X speed with default value\n");
            s.append("\tbne      "+sprite.mName+action.mName+"TargetPlayer1XDone"+continuousNumber+"\n");
            s.append("\tldb      #"+shotSpeed+"\n");
            s.append("\tbra      "+sprite.mName+action.mName+"TargetPlayer1XDone"+continuousNumber+"\n");
            s.append(sprite.mName+action.mName+"TargetPlayer1XNotTiny"+continuousNumber+":\n");

            s.append("\tldx      main1Pointer  ; player pointer \n");
            s.append("\tlda      X_POS,x ; current player X position\n");
            s.append("\tcmpa     "+m.get("X_POS")+","+indexRegister+" ; compare to shot position \n");
            s.append("\tbgt      "+sprite.mName+action.mName+"TargetPlayer1XGreater"+continuousNumber+"\n");
            s.append("\tldb      #-"+shotSpeed+" ; if lower, than negative speed\n");
            s.append("\tbra      "+sprite.mName+action.mName+"TargetPlayer1XDone"+continuousNumber+"\n");
            s.append(sprite.mName+action.mName+"TargetPlayer1XGreater"+continuousNumber+":\n");
            s.append("\tldb      #"+shotSpeed+" ; if higher, than positive speed\n");
            s.append(sprite.mName+action.mName+"TargetPlayer1XDone"+continuousNumber+":\n");
            s.append("\tstb      "+m.get("X_DELTA")+","+indexRegister+" ; store the speed to X_DELTA\n");
            s.append("\tsuba     "+m.get("X_POS")+","+indexRegister+" ; calculate the the delta of the two positions\n");
            s.append("\tbpl      "+sprite.mName+action.mName+"TargetPlayer1XGreaterNoNeg"+continuousNumber+"\n");
            s.append("\tnega     ; only the ABSOLUT value\n");
            s.append(sprite.mName+action.mName+"TargetPlayer1XGreaterNoNeg"+continuousNumber+": \n");

            s.append(sprite.mName+action.mName+"TargetPlayer1XGreaterNoNeg"+continuousNumber+": \n");

            s.append("\ttfr      a,b ; in a x delta, save it in reg b\n");
            s.append("\tasla     ; double x delta\n");
            s.append("\tcmpa     temp8bit ; compare to y delta\n");
            s.append("\tble      "+sprite.mName+action.mName+"TargetPlayer1YWayBigger"+continuousNumber+" ; if double X still smaller than y delta, than y delta is BiG\n");
            s.append("\tlda      temp8bit ; load y delta\n");
            s.append("\tstb      temp8bit ; store x delta\n");
            s.append("\tasla     ; double the y delta\n");
            s.append("\tcmpa     temp8bit ; compare to x delta\n");
            s.append("\tbhs      "+sprite.mName+action.mName+"TargetPlayer1Done"+continuousNumber+"\n");

            s.append("\tasl      "+m.get("X_DELTA")+","+indexRegister+" ; than double the X speed\n");
            s.append("\tbra      "+sprite.mName+action.mName+"TargetPlayer1Done"+continuousNumber+"\n");
            s.append(sprite.mName+action.mName+"TargetPlayer1YWayBigger"+continuousNumber+":\n");

            s.append("\tasl      "+m.get("Y_DELTA")+","+indexRegister+" ; than double the Y speed\n");
            s.append(sprite.mName+action.mName+"TargetPlayer1Done"+continuousNumber+":\n");
        }
        if (action.mbehaviour.equals("target player 2"))
        {
            int shotSpeed = IntX(action.mchangeWhileActiveY,1);

            s.append("; --- adjust for behaviour: target player 2\n");
            // set "speeds" and direction
            // to target approxemately current player position
            s.append("; --- vertical\n");
            s.append("\tldx      main2Pointer  ; player pointer \n");

            s.append("\tlda      Y_POS,x ; current player Y position\n");
            s.append("\tsuba     "+m.get("Y_POS")+","+indexRegister+" ; delta to our position \n");
            s.append("\tbpl      "+sprite.mName+action.mName+"TargetPlayer2YDeltaNoNeg"+continuousNumber+" \n");
            s.append("\tnega      \n");
            s.append(sprite.mName+action.mName+"TargetPlayer2YDeltaNoNeg"+continuousNumber+":\n");
            s.append("\tcmpa     #10 ; compare to shot position \n");
            s.append("\tbhs      "+sprite.mName+action.mName+"TargetPlayer2YNotTiny"+continuousNumber+" \n");
            s.append("\tclrb     \n");
            s.append("\tbra      "+sprite.mName+action.mName+"TargetPlayer2YDone"+continuousNumber+"\n");
            s.append(sprite.mName+action.mName+"TargetPlayer2YNotTiny"+continuousNumber+":\n");

            s.append("\tlda      Y_POS,x ; current player Y position\n");
            s.append("\tcmpa     "+m.get("Y_POS")+","+indexRegister+" ; compare to shot position \n");
            s.append("\tbgt      "+sprite.mName+action.mName+"TargetPlayer2YGreater"+continuousNumber+"\n");
            s.append("\tldb      #-"+shotSpeed+" ; if lower, than negative speed\n");
            s.append("\tbra      "+sprite.mName+action.mName+"TargetPlayer2YDone"+continuousNumber+"\n");
            s.append(sprite.mName+action.mName+"TargetPlayer2YGreater"+continuousNumber+":\n");
            s.append("\tldb      #"+shotSpeed+" ; if higher, than positive speed\n");
            s.append(sprite.mName+action.mName+"TargetPlayer2YDone"+continuousNumber+":\n");
            s.append("\tstb      "+m.get("Y_DELTA")+","+indexRegister+" ; store the speed to Y_DELTA\n");
            s.append("\tsuba     "+m.get("Y_POS")+","+indexRegister+" ; calculate the the delta of the two positions\n");
            s.append("\tbpl      "+sprite.mName+action.mName+"TargetPlayer2YGreaterNoNeg"+continuousNumber+"\n");
            s.append("\tnega     ; only the ABSOLUT value\n");
            s.append(sprite.mName+action.mName+"TargetPlayer2YGreaterNoNeg"+continuousNumber+": \n");
            s.append("\tsta      temp8bit ; and store it in tmp\n");

            s.append("; --- horizontal\n");
            s.append("\tlda      X_POS,x ; current player X position\n");
            s.append("\tsuba     "+m.get("X_POS")+","+indexRegister+" ; delta to our position \n");
            s.append("\tbpl      "+sprite.mName+action.mName+"TargetPlayer2XDeltaNoNeg"+continuousNumber+"\n");
            s.append("\tnega      \n");
            s.append(sprite.mName+action.mName+"TargetPlayer2XDeltaNoNeg"+continuousNumber+":\n");
            s.append("\tcmpa     #10 ; compare to shot position \n");
            s.append("\tbhs      "+sprite.mName+action.mName+"TargetPlayer2XNotTiny"+continuousNumber+"\n");
            s.append("\tclrb     \n");
            s.append("\ttst      "+m.get("Y_DELTA")+","+indexRegister+" ; check if both directions are 0 - if so load X speed with default value\n");
            s.append("\tbne      "+sprite.mName+action.mName+"TargetPlayer2XDone"+continuousNumber+"\n");
            s.append("\tldb      #"+shotSpeed+"\n");
            s.append("\tbra      "+sprite.mName+action.mName+"TargetPlayer2XDone"+continuousNumber+"\n");
            s.append(sprite.mName+action.mName+"TargetPlayer2XNotTiny"+continuousNumber+":\n");

            s.append("\tldx      main2Pointer  ; player pointer \n");
            s.append("\tlda      X_POS,x ; current player X position\n");
            s.append("\tcmpa     "+m.get("X_POS")+","+indexRegister+" ; compare to shot position \n");
            s.append("\tbgt      "+sprite.mName+action.mName+"TargetPlayer2XGreater"+continuousNumber+"\n");
            s.append("\tldb      #-"+shotSpeed+" ; if lower, than negative speed\n");
            s.append("\tbra      "+sprite.mName+action.mName+"TargetPlayer2XDone"+continuousNumber+"\n");
            s.append(sprite.mName+action.mName+"TargetPlayer2XGreater"+continuousNumber+":\n");
            s.append("\tldb      #"+shotSpeed+" ; if higher, than positive speed\n");
            s.append(sprite.mName+action.mName+"TargetPlayer2XDone"+continuousNumber+":\n");
            s.append("\tstb      "+m.get("X_DELTA")+","+indexRegister+" ; store the speed to X_DELTA\n");
            s.append("\tsuba     "+m.get("X_POS")+","+indexRegister+" ; calculate the the delta of the two positions\n");
            s.append("\tbpl      "+sprite.mName+action.mName+"TargetPlayer2XGreaterNoNeg"+continuousNumber+"\n");
            s.append("\tnega     ; only the ABSOLUT value\n");
            s.append(sprite.mName+action.mName+"TargetPlayer2XGreaterNoNeg"+continuousNumber+": \n");

            s.append(sprite.mName+action.mName+"TargetPlayer2XGreaterNoNeg"+continuousNumber+": \n");

            s.append("\ttfr      a,b ; in a x delta, save it in reg b\n");
            s.append("\tasla     ; double x delta\n");
            s.append("\tcmpa     temp8bit ; compare to y delta\n");
            s.append("\tble      "+sprite.mName+action.mName+"TargetPlayer2YWayBigger"+continuousNumber+" ; if double X still smaller than y delta, than y delta is BiG\n");
            s.append("\tlda      temp8bit ; load y delta\n");
            s.append("\tstb      temp8bit ; store x delta\n");
            s.append("\tasla     ; double the y delta\n");
            s.append("\tcmpa     temp8bit ; compare to x delta\n");
            s.append("\tbhs      "+sprite.mName+action.mName+"TargetPlayer2Done"+continuousNumber+"\n");

            s.append("\tasl      "+m.get("X_DELTA")+","+indexRegister+" ; than double the X speed\n");
            s.append("\tbra      "+sprite.mName+action.mName+"TargetPlayer2Done"+continuousNumber+"\n");
            s.append(sprite.mName+action.mName+"TargetPlayer2YWayBigger"+continuousNumber+":\n");

            s.append("\tasl      "+m.get("Y_DELTA")+","+indexRegister+" ; than double the Y speed\n");
            s.append(sprite.mName+action.mName+"TargetPlayer2Done"+continuousNumber+":\n");
        }
        /*
        if (hasTrigger(action, "on creation"))
        ... is handled at the place of "creation"
        ... stack handling is a nightmare otherwise!
        */
    }
    
  
    // there is only one timer per actions
    // -> there should only be one timer trigger
    // if there are more than one -> they are ignored!
    //
    // return >=0 on success
    // else return -1

    // assuming a timer event has one one trigger!
    // returns EventCount
    int getTimerEventIndex(ActionNewData action)
    {
        for (int eventCount = 0;eventCount<action.meventUID.size();eventCount++)
        {                
            ActionTriggerData triggers = getTriggerByUID(action, action.meventUID.elementAt(eventCount));
            ActionResultData results = getResultByUID(action, action.meventUID.elementAt(eventCount));
            for (int triggerCount = 0;triggerCount<triggers.mtriggerByCause.size();triggerCount++)
            {
                if (triggers.mtriggerByCause.elementAt(triggerCount).equals("timer expired"))
                {
                    return eventCount;
                }
            }
        }        
        return -1;
    }
    
    // returns EventCount
    int getLongTimerEventIndex(ActionNewData action)
    {
        for (int eventCount = 0;eventCount<action.meventUID.size();eventCount++)
        {
            ActionTriggerData triggers = getTriggerByUID(action, action.meventUID.elementAt(eventCount));
            ActionResultData results = getResultByUID(action, action.meventUID.elementAt(eventCount));

            for (int i=0;i<triggers.mtriggerByCause.size(); i++)
            {
                if (triggers.mtriggerByCause.elementAt(i).equals("long timer expired"))
                {
                    return eventCount;
                }
            }
        }
        return -1;
    }
                

    ActionNewData getActionByID(SpriteData sprite, String actionID)
    {
        Collection<ActionNewData> colCa = mActionDataPool.getMapForKlasse(sprite.mName+"_Actions").values();
        Iterator<ActionNewData> iterCa = colCa.iterator();

        while (iterCa.hasNext())
        {
            ActionNewData actionData = iterCa.next();

            // break in first action, we assume ALL actions of one sprite are player controlled... 
            if (actionData.mName.equals(actionID))
                return actionData;
        }
        return null;
    }
    
    ActionNewData getDefaultAction(SpriteData sprite)
    {
        ActionNewData action = getActionByID(sprite, sprite.mDefaultActionID);
        if (action == null) 
            ShowWarningDialog.showWarningDialog("Action is Null!", "Default sprite action is null, did you save the sprite correctly?<BR>Did you delete an action/sprite without removing it from the level?<BR> ("+sprite.mName+")");
        return action;
    }
    
    int removeUID = 0;
    void addRemoveCode(StringBuilder b)
    {
        removeUID++;
        
        b.append("\tleax     -(NEXT_OBJECT),s\t; in x pointer to THIS original object structure start\n");
        b.append("\tleay      ,x ; remember this in y, so we can check for followers later\n");
        b.append("\tlds      S_NEXT_OBJECT,s ; load stack with the next object to process in the list\n");
        b.append("\tsts      temp16bit ; save that temporarily\n");
        b.append("\tlds      #Vec_Default_Stk ; and enable stack usage (so we can use sub routines) \n");
        b.append("\tjsr      removeObject\t; object in X, destroys D and U\n");
//b.append("\tlds      temp16bit ; and reload the stack value we need\n");
        b.append("; do some work, that usually is done at the end \n");
        b.append("; of the smartlist...\n");
        b.append("\tlda      gameScale ; load ...\n");
        b.append("\tsta      <VIA_t1_cnt_lo ; and set the default movement scale\n");
        b.append("\tldb      #$cc ; reset the beam to zero\n");
        b.append("\tMY_MOVE_TO_A_END ; end the actual moving to the position of the now deleted object\n");
        b.append("\tSTb      >VIA_cntl\n");
        b.append("\tldd      #0 ; reset our VIA registers\n");
        b.append("\tstd      >VIA_port_b\n");


// if sprite has follower -> remove follower!
// remove all sprites, that in DATA_w have the address of this sprites Y_POS
//;--------------- remove followers
        b.append("; go thru all possible sprites!\n");
        b.append("RemoveStartAgain"+removeUID+":\n");
        b.append("\tldx      objectlist_used_head ; load head of the object list\n");
        b.append("RemoveCompareNextObject"+removeUID+":\n");
        b.append("\tcmpy        C_DATA_W,x ; does this look like a follower?\n");
        b.append("\tbne         RemoveNoFollower"+removeUID+"\n");
        b.append("\tjsr      removeObject\t; object in X, destroys D and U\n");
        b.append("\tbne         RemoveStartAgain"+removeUID+"\n");
        
        b.append("RemoveNoFollower"+removeUID+":\n");
        
        b.append("\tldx      NEXT_OBJECT,x ; initiate the next possible object to test \n");
        b.append("\tcmpx     #OBJECT_LIST_COMPARE_ADDRESS; is it the end of the list?\n");
        b.append("\tbhi      RemoveCompareNextObject"+removeUID+" ; no - so test the next\n");
//;--------------        


        b.append("\tlds      temp16bit ; and reload the stack value we need\n");
        b.append("\tpuls     d,pc ; and jump to the next object in the object list\n");
    }
    
    // to remove entety in reg X
    void addOneCompleteRemoveX(StringBuilder b, boolean stackAlreadySaved)
    {
        String removeAllUID = "rAllInner"+removeAllUID_;

        if (!stackAlreadySaved)
        {
            b.append("\tsts      temp16bit ; save that temporarily\n");
            b.append("\tlds      #Vec_Default_Stk ; and enable stack usage (so we can use sub routines) \n");
        }
        b.append("\tjsr      removeObject; object in X, destroys D and U\n");

        // if sprite has follower -> remove follower!
        // remove all sprites, that in DATA_w have the address of this sprites Y_POS

        b.append(";--------------- remove followers!\n");
        b.append("; go thru all possible sprites!\n");
        b.append("RemoveStartAgain"+removeAllUID+":\n");
        b.append("\tldx      objectlist_used_head ; load head of the object list\n");
        b.append("RemoveCompareNextObject"+removeAllUID+":\n");
        b.append("\tcmpy        C_DATA_W,x ; does this look like a follower?\n");
        b.append("\tbne         RemoveNoFollower"+removeAllUID+"\n");
        b.append("\tjsr      removeObject\t; object in X, destroys D and U\n");
        b.append("\tbne         RemoveStartAgain"+removeAllUID+"\n");
        
        b.append("RemoveNoFollower"+removeAllUID+":\n");
        
        b.append("\tldx      NEXT_OBJECT,x ; initiate the next possible object to test \n");
        b.append("\tcmpx     #OBJECT_LIST_COMPARE_ADDRESS; is it the end of the list?\n");
        b.append("\tbhi      RemoveCompareNextObject"+removeAllUID+" ; no - so test the next\n");
//;--------------        

        if (!stackAlreadySaved)
        {
            b.append("\tlds      temp16bit ; and reload the stack value we need\n");
        }
    }

    int removeAllUID_ = 0;
    void addRemoveAllCode(StringBuilder b, String spriteID)
    {
        removeAllUID_++;
        String removeAllUID = "rAll"+removeAllUID_;
        SpriteData sprite = getSpriteByID(spriteID);
        int spriteUID = sprite.mspriteUID;
        b.append("\tsts      temp16bit ; save that temporarily\n");
        b.append("\tlds      #Vec_Default_Stk ; and enable stack usage (so we can use sub routines) \n");
b.append("\tpshs y \n");
        
        b.append("; go thru all possible sprites!\n");
        b.append("RemoveStartAgain"+removeAllUID+":\n");
        b.append("\tldx      objectlist_used_head ; load head of the object list\n");
        b.append("RemoveCompareNextObject"+removeAllUID+":\n");
        b.append("\tldy      BEHAVIOUR,x ; behaviour address of the sprite\n");
        b.append("\tleay     -1,y ; spriteID is behaviour -1\n");
        b.append("\tlda      ,y ; get the spriteID\n");
        b.append("\tcmpa     #"+spriteUID+" ; is this the id we are looking for?\n");
        b.append("\tbeq      doOneRemove"+removeAllUID+" ; \n");
        b.append("\tldx      NEXT_OBJECT,x ; initiate the next possible object to test \n");
        b.append("\tcmpx     #OBJECT_LIST_COMPARE_ADDRESS; is it the end of the list?\n");
        b.append("\tbhi      RemoveCompareNextObject"+removeAllUID+" ; no - so test the next\n");
        b.append("\tjmp      RemoveAllDone"+removeAllUID+"\n");
        

        b.append("doOneRemove"+removeAllUID+": ; \n");
        addOneCompleteRemoveX(b, true);
        b.append("\tbra      RemoveStartAgain"+removeAllUID+"\n");
          
        b.append("RemoveAllDone"+removeAllUID+":\n");
        if (mSpriteData.mName.equals(spriteID))
        {
            b.append("; I just removed myself - I don't know for sure if my following sprite is still\n");
            b.append("; valid - so I will hickup the game - and return to main!\n");

            b.append("; do some work, that usually is done at the end \n");
            b.append("; of the smartlist...\n");
            b.append("\tlda      gameScale ; load ...\n");
            b.append("\tsta      <VIA_t1_cnt_lo ; and set the default movement scale\n");
            b.append("\tldb      #$cc ; reset the beam to zero\n");
            b.append("\tMY_MOVE_TO_A_END ; end the actual moving to the position of the now deleted object\n");
            b.append("\tSTb      >VIA_cntl\n");
            b.append("\tldd      #0 ; reset our VIA registers\n");
            b.append("\tstd      >VIA_port_b\n");

            b.append("\tjmp      jmpBack1FromObjectHandling ;\n");
        }
        else
        {
            b.append("\tpuls y \n");
            b.append("\tlds      temp16bit ; get our stack back and continue\n");
        }
    }
    
    // this is so "new" can be reused!
    private HashMap<String, String> knownFunctions = new HashMap<String, String>();
    String functionalizeNewAction(SpriteData sprite, ActionNewData action , String indexRegister, boolean stackAlreadyPulled)
    {
        StringBuilder result = new StringBuilder();
        String name = "newAction_"+sprite.mName+action.mName+indexRegister+stackAlreadyPulled;
        if (knownFunctions.get(name) != null) return name;

        SB_additionalFunctions.append("; ----------------------------------\n");
        SB_additionalFunctions.append(name+":\n");
        setupNewAction(SB_additionalFunctions, sprite, action, indexRegister, stackAlreadyPulled);
        SB_additionalFunctions.append("\trts\n");
        SB_additionalFunctions.append("; ----------------------------------\n");
        knownFunctions.put(name,name);
        return name;
    }

    
    SpriteData getSpriteByUID(int uid)
    {
        boolean found=false;
        SpriteData spriteFound = null;
        String klasse = mLevelData.mName;
        Collection<LevelObjectData> colC = mLevelObjectDataPool.getMapForKlasse(klasse).values();
        Iterator<LevelObjectData> iterC = colC.iterator();
        String oldName = "";
        while (iterC.hasNext())
        {
            LevelObjectData levelObject = iterC.next();
            if (levelObject.mType.equals("Sprite"))
            {
                SpriteData sprite = getSpriteByID(levelObject.mSpriteID);
                if (sprite.mspriteUID == uid)
                {
                    if ((found) && (!oldName.equals(sprite.mName)))
                    {
                        ShowWarningDialog.showWarningDialog("Sprite ID not UNIQUE", "Non unique sprite id in collision detection found ("+sprite.mName+"<->"+spriteFound.mName+"("+uid+")"+")");
                    }
                    oldName = sprite.mName;
                    spriteFound = sprite;
                    found = true;
                }
            }
        }
        return spriteFound;
    }


    
    
    // get all distinct int IDs of sprites the current sprite has a general colision detections trigger for
    // ignore fights against player 1 and player 2
    int[] getColDetectSpriteIDs()
    {
        HashMap<Integer, Integer> intA = new HashMap<Integer, Integer>();

        for (int eventCount = 0;eventCount<mActionData.meventUID.size();eventCount++)
        {
            ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
            ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
            for (int triggerCount = 0;triggerCount<triggers.mtriggerByCause.size();triggerCount++)
            {
                if (triggers.mtriggerByCause.elementAt(triggerCount).equals("sprite collision"))
                {
                    int spid = 0;
                    try
                    {
                        if (isPlayer(getSpriteByID(triggers.mtriggerBySpriteID.elementAt(triggerCount)))) continue;
                        if (isTriggerOnly(getSpriteByID(triggers.mtriggerBySpriteID.elementAt(triggerCount)))) continue;
                        if (isText(getSpriteByID(triggers.mtriggerBySpriteID.elementAt(triggerCount)))) continue;
                        spid = getSpriteByID(triggers.mtriggerBySpriteID.elementAt(triggerCount)).mspriteUID;

                    }
                    catch (Throwable e)
                    {
                        ShowWarningDialog.showWarningDialog("Col detect sprite not found!", "Did you forget to supply a sprite ID? (sprite: "+mSpriteData.mName+", action: "+mActionData.mName+")");
                    }
                    intA.put(spid, spid);
                }
            }
        }
        int[] ret = new int[intA.size()];
        
        Set entries = intA.entrySet();
        Iterator it = entries.iterator();
        int i=0;
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            Integer value = (Integer) entry.getValue();
            ret[i++] = value;
        }
        return ret;
    }

    int getMaxAllowedSprite(String spriteID)
    {
        String klasse = mLevelData.mName;
        Collection<LevelObjectData> colC = mLevelObjectDataPool.getMapForKlasse(klasse).values();
        Iterator<LevelObjectData> iterC = colC.iterator();

        int maxSprites = 0;

        while (iterC.hasNext())
        {
            LevelObjectData o = iterC.next();
            if (o.mType.equals("Sprite"))
            {
                if (o.mSpriteID.equals(spriteID))
                    maxSprites += o.mMaxLiveObjects;
            }
        }
        return maxSprites;
    }
    boolean levelHasAnalog()
    {
        ActionNewData player1 = getPlayer1();
        ActionNewData player2 = getPlayer2();
        
        if (player1 != null) 
        {
            if (player1.mchangeWhileActiveY.contains("a")) return true;
            if (player1.mchangeWhileActiveX.contains("a")) return true;
        }
        if (player2 != null) 
        {
            if (player2.mchangeWhileActiveY.contains("a")) return true;
            if (player2.mchangeWhileActiveX.contains("a")) return true;
        }
        return false;
    }
    
    // a simple number -> a position
    // a "d" + simple number -> a delta position from spawn parents position
    // a "=" + varname -> load contents of variable
    // a "rand" a random value
    //          rand(+-100)
    //          rand(+100)  == rand(100)
    //          rand(-100)
    int spawnPosUID = 0;
    void getSpawnPositionToX(int eventCount, int triggerCount, ActionNewData action, StringBuilder s, ActionNewData childAction)
    {
        ActionTriggerData triggers = getTriggerByUID(mActionData, mActionData.meventUID.elementAt(eventCount));
        ActionResultData results = getResultByUID(mActionData, mActionData.meventUID.elementAt(eventCount));

        spawnPosUID++;
        // todo:
        // var
        // rand
        // abs
        // delta parent
        // = parent
        
        if (childAction.mbehaviour.equals("follow sprite"))
        {
            s.append("\tleax      STACK_PULL_OFFSET,s ; remember current sprites position pointer for follower\n");
            return;
        }

        
// todo
// only 1 result
        String sY = results.mresultY.elementAt(0);
        String sX = results.mresultX.elementAt(0);
        int ydelta = IntX(sY,300);
        int xdelta = IntX(sX,300);
        
        // immediate values
        if ((ydelta < 300) && (xdelta < 300))
        {
            String pos = String.format("$%04X",((ydelta*256)&0xff00) + ((xdelta)&0xff) );
            s.append("\tldx      #"+pos+" ; remember current position\n");
            return;
        }
         // delta to parent pos
        if ((sY.startsWith("d")) && (sX.startsWith("d")))
        {
            sY = sY.substring(1);
            sX = sX.substring(1);
            ydelta = IntX(sY,300);
            xdelta = IntX(sX,300);
            if ((ydelta==0) && (xdelta==0))
            {
                s.append("\tldx      S_Y_POS,s ; remember current position\n");
                return;
            }
            s.append("\tldd      S_Y_POS,s ; remember current position\n");
            s.append("\tadda      #"+ydelta+" ; add y offset of spawn position \n");
            s.append("\taddb      #"+xdelta+" ; add x offset of spawn position \n");
            s.append("\ttfr      d,x ; remember current position\n");
            return;
        }
        
        // now we differentiate between Y and X
        
        s.append("\tldd      S_Y_POS,s ; remember current position\n");
        if (ydelta<300) // take this value!
        {
            String pos = String.format("$%02X",((ydelta)&0xff) );
            s.append("\tlda      #"+pos+" ; remember current position\n");
        }
        else if (sY.startsWith("d")) // delta to parent pos
        {
            sY = sY.substring(1);
            ydelta = IntX(sY,300);
            s.append("\tadda      #"+ydelta+" ; add y offset of spawn position \n");
        }
        else if (sY.startsWith("=")) // variable
        {
            sY = sY.substring(1);
            s.append("\tlda      "+sY+" ; variable contents \n");
        }
        else if (sY.startsWith("rand")) // a random value
        {
            boolean pn = false;
            boolean n = false;
            boolean p = false;
            sY = replace(sY, "rand","");
            if (sY.contains("+-")) pn = true;
            sY = replace(sY, "+-","");
            if (sY.contains("-")) n = true;
            sY = replace(sY, "-","");
            if (sY.contains("+")) p = true;
            sY = replace(sY, "+","");
            if ((!pn) && (!n) && (!p)) p = true;
            
            sY= replace(sY,"(","");
            sY= replace(sY,")","");
            
            int val = Int0(sY);
            if (val == 0)
            {
                ShowWarningDialog.showWarningDialog("Spawn Random", "Can't discern random base (Y). ("+mSpriteData.mName+", action: "+mActionData.mName+")");
                s.append("\tldx      #pos ; ERROR fallback return!\n");
                return;
            }
            int min=0;
            int max=0;
            if (p) 
            {
                min = 0;
                max = val;
            }
            if (n) 
            {
                min = -val;
                max = 0;
            }
            if (pn) 
            {
                min = -val;
                max = val;
            }
            
            
            s.append("\tsts      temp16bit ; remember stack (current position in object list) \n");
            s.append("\tlds      #Vec_Default_Stk ; and enable stack usage (so we can use sub routines) \n");

            s.append("\tpshs d\n");
            
            s.append("repeatSpawnRandomY"+spawnPosUID+":\n");
            s.append("\tjsr      Random ; todo replace with good random \n");
            if (p)
                s.append("\tanda     #%01111111; max 127 \n");
            if (n)
            {
                s.append("\tora     #%10000000; max 0 \n");
            }
            s.append("\tcmpa     #"+max+"; max  \n");
            s.append("\tbgt       repeatSpawnRandomY"+spawnPosUID+";  \n");
            
            s.append("\tcmpa     #"+min+"; min  \n");
            s.append("\tblt       repeatSpawnRandomY"+spawnPosUID+";  \n");

            s.append("\tsta temp8bit\n");
            s.append("\tpuls d\n");
            s.append("\tlds      temp16bit ; reload stack \n");
            s.append("\tlda      temp8bit\n");
        }
/// X
        
        if (xdelta<300) // take this value!
        {
            String pos = String.format("$%02X",((xdelta)&0xff) );
            s.append("\tldb      #"+pos+" ; remember current position\n");
        }
        else if (sX.startsWith("d")) // delta to parent pos
        {
            sX = sX.substring(1);
            xdelta = IntX(sX,300);
            s.append("\taddb      #"+xdelta+" ; add x offset of spawn position \n");
        }
        else if (sX.startsWith("=")) // variable
        {
            sX = sX.substring(1);
            s.append("\tldb      "+sX+" ; variable contents \n");
        }

        else if (sX.startsWith("rand")) // a random value
        {
            boolean pn = false;
            boolean n = false;
            boolean p = false;
            sX = replace(sX, "rand","");
            if (sX.contains("+-")) pn = true;
            sX = replace(sX, "+-","");
            if (sX.contains("-")) n = true;
            sX = replace(sX, "-","");
            if (sX.contains("+")) p = true;
            sX = replace(sX, "+","");
            if ((!pn) && (!n) && (!p)) p = true;
            
            sX= replace(sX,"(","");
            sX= replace(sX,")","");
            
            int val = Int0(sX);
            if (val == 0)
            {
                ShowWarningDialog.showWarningDialog("Spawn Random", "Can't discern random base (X). ("+mSpriteData.mName+", action: "+mActionData.mName+")");
                s.append("\tldx      #pos ; ERROR fallback return!\n");
                return;
            }
            int min=0;
            int max=0;
            if (p) 
            {
                min = 0;
                max = val;
            }
            if (n) 
            {
                min = -val;
                max = 0;
            }
            if (pn) 
            {
                min = -val;
                max = val;
            }
            
            
            s.append("\tsts      temp16bit ; remember stack (current position in object list) \n");
            s.append("\tlds      #Vec_Default_Stk ; and enable stack usage (so we can use sub routines) \n");
            s.append("\tpshs d\n");
            s.append("repeatSpawnRandomX"+spawnPosUID+":\n");
            s.append("\tjsr      Random ; todo replace with good random \n");
            if (p)
                s.append("\tanda     #%01111111; max 127 \n");
            if (n)
            {
                s.append("\tora     #%10000000; max 0 \n");
            }
            s.append("\tcmpa     #"+max+"; max  \n");
            s.append("\tbgt       repeatSpawnRandomX"+spawnPosUID+";  \n");
            
            s.append("\tcmpa     #"+min+"; min  \n");
            s.append("\tblt       repeatSpawnRandomX"+spawnPosUID+";  \n");

            s.append("\tsta temp8bit\n");
            s.append("\tpuls d\n");
            s.append("\tlds      temp16bit ; reload stack \n");
            s.append("\tldb      temp8bit\n");
        }
        
        s.append("\ttfr      d,x ; remember current position\n");
        return;
            
    }
    
    // go thur all sprites and see if any uses intensity
    boolean levelUsesIntensityInSprites()
    {
        Collection<LevelObjectData> colCo = mLevelObjectDataPool.getMapForKlasse(mLevelData.mName).values();
        Iterator<LevelObjectData> iterCo = colCo.iterator();
        
        while (iterCo.hasNext())
        {
            LevelObjectData levelObjectData = iterCo.next();
            if (levelObjectData.mType.equals("Sprite"))
            {
                SpriteData spriteData = mSpriteDataPool.getMapForKlasse("AllSprites").get(levelObjectData.mSpriteID);
                if (spriteData == null) 
                    continue;
                Collection<ActionNewData> colCa = mActionDataPool.getMapForKlasse(spriteData.mName+"_Actions").values();
                Iterator<ActionNewData> iterCa = colCa.iterator();
                
                while (iterCa.hasNext())
                {
                    ActionNewData actionData = iterCa.next();
                    
                    // text is "self regenerating" with intensity
                    if (actionData.mbehaviour.equals("text")) continue;
                    
                    // break in any action that uses intensity
                    if (actionData.mintensity.length()!=0)
                        return true;
                }
            }
        }
        return false;
    }

    public static int MAX_NUM_GEN = 16;

    private HashMap<String, String> mSmartListDone = new HashMap<String, String>();
    
    int alternateSmartlist = 2;
    
    
    // not finished - only collects and interpretes data ...
    String buildSmartlistFunctionsAlternate1(HashMap<String, String> smartlistCollector)
    {
        StringBuilder smB = new StringBuilder();

        String START_T1_AGAIN_MOVE = "START_T1_AGAIN_MOVE             macro\n"+
                         "\tnop 2\n" +
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String START_T1_AGAIN_DRAW = "START_T1_AGAIN_DRAW             macro\n"+
                         "\tnop 2\n" +
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String START_T1 = "START_T1             macro\n"+
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String START_T1_B = "START_T1_B             macro\n"+
                         "\tstb      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String PULL_NEXT_LINE = "PULL_NEXT_LINE             macro\n"+
                         "\tpulu     d,pc                         ;[9] \n"+
                         "\tendm\n";


        String LAST_DRAW_RTS2 = "SM_lastDraw_rts2                                        ;#isfunction  \n"+
                    "\tSET_SHIFT_END  \n"+
                    "\tlda      gameScale \n"+
                    "\tsta      <VIA_t1_cnt_lo \n"+
                    "\tldb      #$cc \n"+
                    "\tSTb      <VIA_cntl                    ;/BLANK low and /ZERO low \n"+

/* or calibrate if used
                    "; zero ref\n"+
		    "\tLDD     #$0302\n"+
                    "\tCLR     <VIA_port_a     ;clear D/A register\n"+
                    "\tSTA     <VIA_port_b     ;mux=1, disable mux\n"+
                    "\tSTB     <VIA_port_b     ;mux=1, enable mux\n"+
                    "\tSTB     <VIA_port_b     ;do it again\n"+
*/                
                    "\tLDB     #$01\n"+
                    "\tSTB     <VIA_port_b     ;disable mux\n"+
                    "\tpuls     d,pc                         ; (D = y,x, pc = next object) \n";

        String LAST_DRAW_RTS = "SM_lastDraw_rts                                        ;#isfunction  \n"+
                    "\tSET_SHIFT_END  \n"+
                    "\tlda      gameScale \n"+
                    "\tsta      <VIA_t1_cnt_lo \n"+
                    "\tldb      #$cc \n"+
                    "\tSTb      <VIA_cntl                    ;/BLANK low and /ZERO low \n"+
/* or calibrate if used
                    "; zero ref\n"+
		    "\tLDD     #$0302\n"+
                    "\tCLR     <VIA_port_a     ;clear D/A register\n"+
                    "\tSTA     <VIA_port_b     ;mux=1, disable mux\n"+
                    "\tSTB     <VIA_port_b     ;mux=1, enable mux\n"+
                    "\tSTB     <VIA_port_b     ;do it again\n"+
*/                
                    "\tLDB     #$01\n"+
                    "\tSTB     <VIA_port_b     ;disable mux\n"+
                    "\trts \n";

        String TH_MOVE_START_Y_X = "TH_MOVE_START_Y_X             macro\n"+
                             "\tSTA      <VIA_port_a                  ;[4] Send Y to A/D\n"+
                             "\tclra                                  ;[2]\n"+
                             "\tsta      <VIA_port_b                  ;[4] Enable mux\n"+
 "\tinca; [2]" +
 "\tnop ;[2] - delay"+
 "\texg a,a; [6]" +

 "\tstd <VIA_port_b [5]" +

 "\tnop ;[2] - delay"+
 "\tnop ;[2] - delay"+
 "\tbrn 0; [3]" +
 "\tdeca; [2]" +
 "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n" +
                    
//                             "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
//                             "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                             "\tendm\n";

        String TH_DRAW_START_Y_X = "TH_DRAW_START_Y_X             macro\n"+
                             "\tSTA      <VIA_port_a                  ;[4] Send Y to A/D\n"+
                             "\tclra                                  ;[2]\n"+
                             "\tsta      <VIA_port_b                  ;[4] Enable mux\n"+
 "\tinca; [2]" +
 "\tnop ;[2] - delay"+
 "\tnop ;[2] - delay"+
 "\tsta <VIA_shift_reg [4]" +
 "\tstd <VIA_port_b [5]" +
 "\tdeca; [2]" +
 "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n" +
                    
//                             "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
//                             "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                             "\tendm\n";


// 18 cycles before each draw cont 
        String TH_WAIT_CONT = "TH_WAIT_CONT              macro\n"+
 "\texg a,a; [6]" +
 "\texg a,a; [6]" +
 "\texg a,a; [6]" +
                             "\tendm\n";
        
        String TH_DRAW_CONT = "TH_DRAW_CONT             macro\n"+
                             "\tSTA      <VIA_port_a                  ;[4] Send Y to A/D\n"+
                             "\tclra                                  ;[2]\n"+
                             "\tsta      <VIA_port_b                  ;[4] Enable mux\n"+
 "\tinca; [2]" +
 "\n ldx #10*256+0; [3]" +               
 "\tnop ;[2] - delay"+
// "\tbrn 0 ;[3] - delay"+
 "\tstd <VIA_port_b [5]" +
 "\tstx      <VIA_t1_cnt_lo               ;[5] Clear T1H\n" +
                    
//                             "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
//                             "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                             "\tendm\n";

        String TH_DRAW_END = "TH_DRAW_END             macro\n"+
// wait 20
 "\texg a,a; [6]" +
 "\texg a,a; [6]" +
 "\texg a,a; [6]" +
 "\tnop; [2]" +
                
"\tLDA      #$f0                  ;[2]\n"+
// WAIT
 "\tnop; [2]" +
 "\tbrn 0; [3]" +
 "\tsta <VIA_shift_reg [4]" +
                   
//                             "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
//                             "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                             "\tendm\n";

        
        
        
        smB.append("\tnoopt\n");

        smB.append(TH_MOVE_START_Y_X);
        smB.append(TH_DRAW_START_Y_X);
        smB.append(TH_WAIT_CONT);
        smB.append(TH_DRAW_CONT);
        smB.append(TH_DRAW_END);
        
        smB.append(START_T1);
        smB.append(START_T1_AGAIN_MOVE);
        smB.append(START_T1_AGAIN_DRAW);
        smB.append(START_T1_B);
        smB.append(PULL_NEXT_LINE);

        GenerationParameters p = new GenerationParameters();

        p.compileForVB = true; // use stack for object list 
        p.rts2 = false; //  rts 2
        p.paraName = "Example";
        p.doNoPositionMove = false;
        veccy.setParameters(p);
        
        String prefix = veccy.functionPrefix;

        String types[] = new String[4];
        types[0] = "startMove";
        types[1] = "startDraw";
        types[2] = "continue_draw";
        types[3] = "continue_move";

        for (int ii=0;ii<4;ii++)
        {
        
            Set entries = smartlistCollector.entrySet();
            Iterator it = entries.iterator();
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                String fName = (String) entry.getValue();
                String n = replace(fName, prefix, "");

                String drawType = "";
                String delayInfo = "";
                int sequenceCount=0;
                String optimization="";
                String countAdd = "";
                if (n.startsWith("startMove")) drawType = "startMove";
                if (n.startsWith("startDraw")) drawType = "startDraw";
    //            if (n.startsWith("continue")) drawType = "continue";
                if (n.startsWith("continue_draw")) drawType = "continue_draw";
                if (n.startsWith("continue_move")) drawType = "continue_move";


                n =  replace(n, drawType, "");
                if (n.startsWith("_yd4")) delayInfo = "_yd4";
                n =  replace(n, delayInfo, "");

                if (n.length()>0)
                    sequenceCount = Int0(n.substring(0,1));
                if (sequenceCount>0) n =  n.substring(1);

                if (n.startsWith("_newY_eq_oldX")) optimization="_newY_eq_oldX";
                if (n.startsWith("_yEqx")) optimization="_yEqx";
                if (n.startsWith("_x0")) optimization="_x0";
                if (n.startsWith("_y0")) optimization="_y0";
                if (n.startsWith("_xyStays")) optimization="_xyStays";
                if (n.startsWith("_yStays")) optimization="_yStays";
                n =  replace(n, optimization, "");

                int sameCount = 0;
                if (n.startsWith("_multi")) 
                {
                    if (n.length()>=2+6)
                    {
                        sameCount = Int0(n.substring(6,8));
                        if (sameCount<=0)
                        {
                            sameCount = Int0(n.substring(6,7));
                        }
                    }
                    else if (n.length()>=1)
                    {
                        sameCount = Int0(n.substring(6,7));
                    }
                    countAdd="_multi"+sameCount;
                    n =  replace(n, countAdd, "");
                }


                boolean decode = false;
                if (fName.startsWith(prefix+"setIntensity"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'setIntensity'");
                }
                else if (fName.startsWith(prefix+"lastDraw_rts2"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'lastDraw_rts2'");
                }
                else if (fName.startsWith(prefix+"lastDraw_rts"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'lastDraw_rts'");
                }
                else if (fName.startsWith(prefix+"LightOff_Intensity"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'LightOff_Intensity'");
                }

                if (!decode)
                {
                    if (n.length() != 0)
                    {
                        ShowWarningDialog.showWarningDialog("Function name unresolved!", "Smartlist function name could not be decoded ("+fName+")");
                        continue;
                    }
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + '"+ drawType+"' + '"+ delayInfo+"' + '"+ sequenceCount+"' + '"+ optimization+"' + '"+ countAdd+"'");
        fName = replace(fName, "_yd4","");
                    String bName = prefix+drawType+"_yd4"+     /*sequenceCount */optimization+countAdd;
                    String oName = prefix+drawType+  /*delayInfo+sequenceCount+*/optimization+countAdd;

                    if (mSmartListDone.containsKey(fName)) continue;

                    if ((drawType.equals("startMove")) && (types[ii].equals("startMove")))
                    {
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");
                        smB.append("\tSET_SHIFT_END\n");
                        addOpto(smB, optimization, false);
                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_sm"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }

                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("startMove"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            smB.append("\tSET_SHIFT_END\n");
                            addOpto(smB, "", false);
                            smB.append("\tjmp "+"again_sm"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_sm"+i +":\n");
                                smB.append("\tnop\n");

                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE\n");
                                    smB.append("\tjmp "+"again_sm"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("startMove"+"_multi"+MAX_NUM_GEN, "startMove"+"_multi"+MAX_NUM_GEN);
                        }
                        mSmartListDone.put(fName, fName);
                    }
                    else if ((drawType.equals("startDraw")) && (types[ii].equals("startDraw")))
                    {
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");
                        addOpto(smB, optimization, true);
                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_sd"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }

                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("startDraw"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            addOpto(smB, "", false);
                            smB.append("\tjmp "+"again_sd"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_sd"+i +":\n");
                                smB.append("\tnop\n");
                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW\n");
                                    smB.append("\tjmp "+"again_sd"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("startDraw"+"_multi"+MAX_NUM_GEN, "startDraw"+"_multi"+MAX_NUM_GEN);
                        }
                        mSmartListDone.put(fName, fName);
                    }
                    else if ((drawType.equals("continue_draw")) && (types[ii].equals("continue_draw")))
                    {
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");
                        if (!optimization.equals("_xyStays"))
                        {
                            smB.append("\tSET_SHIFT_END\n");
                            addOpto(smB, optimization, true);
                        }
                        else 
                            addOpto(smB, optimization, false);

                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_cd"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }

                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("continue_draw"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            if (!optimization.equals("_xyStays"))
                            {
                                smB.append("\tSET_SHIFT_END\n");
                                addOpto(smB, "", false);
                            }
                            else 
                                addOpto(smB, optimization, false);
    
                            smB.append("\tjmp "+"again_cd"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_cd"+i +":\n");
                                smB.append("\tnop\n");
                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW\n");
                                    smB.append("\tjmp "+"again_cd"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("continue_draw"+"_multi"+MAX_NUM_GEN, "continue_draw"+"_multi"+MAX_NUM_GEN);
                        }

                        mSmartListDone.put(fName, fName);
                    }
                    else if ((drawType.equals("continue_move")) && (types[ii].equals("continue_move")))
                    {
                        // -> these are only needed for the start of the Vectorlist - to move to the startpoint
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");

                        addOpto(smB, optimization, false);

                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_cm"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }
                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("continue_move"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            addOpto(smB, "", false);
                            smB.append("\tjmp "+"again_cm"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_cm"+i +":\n");
                                smB.append("\tnop\n");
                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE\n");
                                    smB.append("\tjmp "+"again_cm"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("continue_move"+"_multi"+MAX_NUM_GEN, "continue_move"+"multi"+MAX_NUM_GEN);
                        }
                        mSmartListDone.put(fName, fName);
                    }
                }
            }
        }
        smB.append("\topt\n");
        smB.append(LAST_DRAW_RTS2);
        smB.append(LAST_DRAW_RTS);
        
        
        return smB.toString();
    }
    String buildSmartlistFunctionsAlternate2(HashMap<String, String> smartlistCollector)
    {
        // city
        smartlistCollector.put("SM_continue_move_multi6", "SM_continue_move_multi6");
        smartlistCollector.put("SM_continue_draw", "SM_continue_draw");
        smartlistCollector.put("SM_continue_draw_multi2", "SM_continue_draw_multi2");
        smartlistCollector.put("SM_continue_draw_multi3", "SM_continue_draw_multi3");
        smartlistCollector.put("SM_continue_draw_multi4", "SM_continue_draw_multi4");
        smartlistCollector.put("SM_continue_draw_multi12", "SM_continue_draw_multi12");
        smartlistCollector.put("SM_continue_draw_yd4", "SM_continue_draw_yd4");
        smartlistCollector.put("SM_continue_draw_yd4_multi2", "SM_continue_draw_yd4_multi2");
        smartlistCollector.put("SM_continue_draw_yd4_multi4", "SM_continue_draw_yd4_multi4");
        smartlistCollector.put("SM_continue_draw_yd4_newY_eq_oldX", "SM_continue_draw_yd4_newY_eq_oldX");
        smartlistCollector.put("SM_continue_draw_yd4_yEqx", "SM_continue_draw_yd4_yEqx");
        smartlistCollector.put("SM_startDraw", "SM_startDraw");
        smartlistCollector.put("SM_startDraw_multi2", "SM_startDraw_multi2");
        smartlistCollector.put("SM_startDraw_yd4_multi3", "SM_startDraw_yd4_multi3");
        smartlistCollector.put("SM_startMove", "SM_startMove");
        smartlistCollector.put("SM_startMove_multi2", "SM_startMove_multi2");
        smartlistCollector.put("SM_startMove_multi6", "SM_startMove_multi6");

        // net
        smartlistCollector.put("SM_continue_move_multi3", "SM_continue_move_multi3");
        smartlistCollector.put("SM_startDraw_multi8", "SM_startDraw_multi8");
        smartlistCollector.put("SM_startDraw_yd4_multi8", "SM_startDraw_yd4_multi8");
        smartlistCollector.put("SM_startDraw_yd4_multi16", "SM_startDraw_yd4_multi16");
        smartlistCollector.put("SM_startMove_multi16", "SM_startMove_multi16");
        smartlistCollector.put("SM_startMove_yd4_multi16", "SM_startMove_yd4_multi16");
        smartlistCollector.put("SM_continue_draw_multi6", "SM_continue_draw_multi6");
        smartlistCollector.put("SM_continue_draw_multi8", "SM_continue_draw_multi8");
        smartlistCollector.put("SM_continue_move_multi12", "SM_continue_move_multi12");
        smartlistCollector.put("SM_continue_move_multi16", "SM_continue_move_multi16");
        smartlistCollector.put("SM_startDraw_multi6", "SM_startDraw_multi6");
        smartlistCollector.put("SM_continue_draw_multi16", "SM_continue_draw_multi16");
        smartlistCollector.put("SM_startDraw_multi12", "SM_startDraw_multi12");

	
//        add slow set
        StringBuilder smB = new StringBuilder();
        String SET_Y_X = "SET_Y_X             macro\n"+
                         "\tSTA      <VIA_port_a                  ;[4] Send Y to A/D\n"+
                         "\tclra                                  ;[2]\n"+
                         "\tsta      <VIA_port_b                  ;[4] Enable mux\n"+
                         "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                         "\tendm\n";
        String SET_YSTAYS_X = "SET_YSTAYS_X             macro\n"+
                         "\t                                      ;[] A is generated to 0\n"+
                         "\tnop 4                                 ;[8]\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                         "\tendm\n";

        String SET_Y_EQUOLD_X = "SET_Y_EQUOLD_X             macro\n"+
                         "\t                                      ;[] A is generated to 0\n"+
                         "\tsta      <VIA_port_b                  ;[4] Enable mux\n"+
                         "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                         "\tendm\n";

        String SET_Y_EQU_X = "SET_Y_EQU_X             macro\n"+
                         "\t                                      ;[ ] A is generated to 0\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send Y to A/D\n"+
                         "\tsta      <VIA_port_b                  ;[4] Enable mux\n"+
                         "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
                         "\tendm\n";
        String SET_Y_X0 = "SET_Y_X0             macro\n"+
                         "\tSTA      <VIA_port_a                  ;[4] Send Y to A/D\n"+
                         "\tstb      <VIA_port_b                  ;[4] Enable mux\n"+
                         "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                         "\tendm\n";
        String SET_Y0_X = "SET_Y0_X             macro\n"+
                         "\tSTA      <VIA_port_a                  ;[4] Send Y to A/D\n"+
                         "\tsta      <VIA_port_b                  ;[4] Enable mux\n"+
                         "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                         "\tendm\n";

        String SET_SHIFT_START = "SET_SHIFT_START             macro\n"+
                         "\tsty      <VIA_shift_reg               ;[4] Store pattern in shift register \n"+
                         "\tendm\n";
        String SET_SHIFT_END = "SET_SHIFT_END             macro\n"+
                         "\tstx      <VIA_shift_reg               ;[5, but shift after 4!] \n"+
                         "\tendm\n";
        String START_T1_AGAIN_MOVE = "START_T1_AGAIN_MOVE             macro\n"+
                         "\tnop 2\n" +
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String START_T1_AGAIN_DRAW = "START_T1_AGAIN_DRAW             macro\n"+
                         "\tnop 2\n" +
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";

        String START_T1_AGAIN_MOVE_LAST = "START_T1_AGAIN_MOVE_LAST             macro\n"+
                         "\tnop 2\n" +
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String START_T1_AGAIN_DRAW_LAST = "START_T1_AGAIN_DRAW_LAST             macro\n"+
                         "\tnop 2\n" +
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";


        String START_T1 = "START_T1             macro\n"+
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String START_T1_B = "START_T1_B             macro\n"+
                         "\tstb      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String PULL_NEXT_LINE = "PULL_NEXT_LINE             macro\n"+
                         "\tpulu     d,pc                         ;[9] \n"+
                         "\tendm\n";


        String LAST_DRAW_RTS2 = "SM_lastDraw_rts2                                        ;#isfunction  \n"+
                    "\tSET_SHIFT_END  \n"+
                    "\tlda      gameScale \n"+
                    "\tsta      <VIA_t1_cnt_lo \n"+
                    "\tldb      #$cc \n"+
                    "\tSTb      <VIA_cntl                    ;/BLANK low and /ZERO low \n"+

/* or calibrate if used
                    "; zero ref\n"+
		    "\tLDD     #$0302\n"+
                    "\tCLR     <VIA_port_a     ;clear D/A register\n"+
                    "\tSTA     <VIA_port_b     ;mux=1, disable mux\n"+
                    "\tSTB     <VIA_port_b     ;mux=1, enable mux\n"+
                    "\tSTB     <VIA_port_b     ;do it again\n"+
*/                
                    "\tLDB     #$01\n"+
                    "\tSTB     <VIA_port_b     ;disable mux\n"+
                    "\tpuls     d,pc                         ; (D = y,x, pc = next object) \n";

        String LAST_DRAW_RTS = "SM_lastDraw_rts                                        ;#isfunction  \n"+
                    "\tSET_SHIFT_END  \n"+
                    "\tlda      gameScale \n"+
                    "\tsta      <VIA_t1_cnt_lo \n"+
                    "\tldb      #$cc \n"+
                    "\tSTb      <VIA_cntl                    ;/BLANK low and /ZERO low \n"+
/* or calibrate if used
                    "; zero ref\n"+
		    "\tLDD     #$0302\n"+
                    "\tCLR     <VIA_port_a     ;clear D/A register\n"+
                    "\tSTA     <VIA_port_b     ;mux=1, disable mux\n"+
                    "\tSTB     <VIA_port_b     ;mux=1, enable mux\n"+
                    "\tSTB     <VIA_port_b     ;do it again\n"+
*/                
                    "\tLDB     #$01\n"+
                    "\tSTB     <VIA_port_b     ;disable mux\n"+
                    "\trts \n";
        
        
        smB.append("\tnoopt\n");
        
        smB.append(SET_Y_X);
        smB.append(SET_YSTAYS_X);
        smB.append(SET_Y_EQUOLD_X);
        smB.append(SET_Y_EQU_X);
        smB.append(SET_Y_X0);
        smB.append(SET_Y0_X);
        smB.append(SET_SHIFT_START);
        smB.append(SET_SHIFT_END);
        smB.append(START_T1);
        smB.append(START_T1_AGAIN_MOVE);
        smB.append(START_T1_AGAIN_DRAW);
        smB.append(START_T1_AGAIN_MOVE_LAST);
        smB.append(START_T1_AGAIN_DRAW_LAST);
        smB.append(START_T1_B);
        smB.append(PULL_NEXT_LINE);

        GenerationParameters p = new GenerationParameters();

        p.compileForVB = true; // use stack for object list 
        p.rts2 = false; //  rts 2
        p.paraName = "Example";
        p.doNoPositionMove = false;
        veccy.setParameters(p);
        
        String prefix = veccy.functionPrefix;

        String types[] = new String[4];
        types[0] = "startMove";
        types[1] = "startDraw";
        types[2] = "continue_draw";
        types[3] = "continue_move";

        for (int ii=0;ii<4;ii++)
        {
        
            Set entries = smartlistCollector.entrySet();
            Iterator it = entries.iterator();
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                String fName = (String) entry.getValue();
                String n = replace(fName, prefix, "");

                String drawType = "";
                String delayInfo = "";
                int sequenceCount=0;
                String optimization="";
                String countAdd = "";
                if (n.startsWith("startMove")) drawType = "startMove";
                if (n.startsWith("startDraw")) drawType = "startDraw";
    //            if (n.startsWith("continue")) drawType = "continue";
                if (n.startsWith("continue_draw")) drawType = "continue_draw";
                if (n.startsWith("continue_move")) drawType = "continue_move";


                n =  replace(n, drawType, "");
                if (n.startsWith("_yd4")) delayInfo = "_yd4";
                n =  replace(n, delayInfo, "");

                if (n.length()>0)
                    sequenceCount = Int0(n.substring(0,1));
                if (sequenceCount>0) n =  n.substring(1);

                if (n.startsWith("_newY_eq_oldX")) optimization="_newY_eq_oldX";
                if (n.startsWith("_yEqx")) optimization="_yEqx";
                if (n.startsWith("_x0")) optimization="_x0";
                if (n.startsWith("_y0")) optimization="_y0";
                if (n.startsWith("_xyStays")) optimization="_xyStays";
                if (n.startsWith("_yStays")) optimization="_yStays";
                n =  replace(n, optimization, "");

                int sameCount = 0;
                if (n.startsWith("_multi")) 
                {
                    if (n.length()>=2+6)
                    {
                        sameCount = Int0(n.substring(6,8));
                        if (sameCount<=0)
                        {
                            sameCount = Int0(n.substring(6,7));
                        }
                    }
                    else if (n.length()>=1)
                    {
                        sameCount = Int0(n.substring(6,7));
                    }
                    countAdd="_multi"+sameCount;
                    n =  replace(n, countAdd, "");
                }


                boolean decode = false;
                if (fName.startsWith(prefix+"setIntensity"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'setIntensity'");
                }
                else if (fName.startsWith(prefix+"lastDraw_rts2"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'lastDraw_rts2'");
                }
                else if (fName.startsWith(prefix+"lastDraw_rts"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'lastDraw_rts'");
                }
                else if (fName.startsWith(prefix+"LightOff_Intensity"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'LightOff_Intensity'");
                }

                if (!decode)
                {
                    if (n.length() != 0)
                    {
                        ShowWarningDialog.showWarningDialog("Function name unresolved!", "Smartlist function name could not be decoded ("+fName+")");
                        continue;
                    }
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + '"+ drawType+"' + '"+ delayInfo+"' + '"+ sequenceCount+"' + '"+ optimization+"' + '"+ countAdd+"'");
        fName = replace(fName, "_yd4","");
                    String bName = prefix+drawType+"_yd4"+     /*sequenceCount */optimization+countAdd;
                    String oName = prefix+drawType+  /*delayInfo+sequenceCount+*/optimization+countAdd;

                    if (mSmartListDone.containsKey(fName)) continue;

                    if ((drawType.equals("startMove")) && (types[ii].equals("startMove")))
                    {
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");
                        smB.append("\tSET_SHIFT_END\n");
                        addOpto(smB, optimization, false);
                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_sm"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }

                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("startMove"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            smB.append("\tSET_SHIFT_END\n");
                            addOpto(smB, "", false);
                            smB.append("\tjmp "+"again_sm"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_sm"+i +":\n");
                                smB.append("\tnop\n");

                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE\n");
                                    smB.append("\tjmp "+"again_sm"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("startMove"+"_multi"+MAX_NUM_GEN, "startMove"+"_multi"+MAX_NUM_GEN);
                        }
                        mSmartListDone.put(fName, fName);
                    }
                    else if ((drawType.equals("startDraw")) && (types[ii].equals("startDraw")))
                    {
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");
                        addOpto(smB, optimization, true);
                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_sd"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }

                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("startDraw"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            addOpto(smB, "", false);
                            smB.append("\tjmp "+"again_sd"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_sd"+i +":\n");
                                smB.append("\tnop\n");
                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW\n");
                                    smB.append("\tjmp "+"again_sd"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("startDraw"+"_multi"+MAX_NUM_GEN, "startDraw"+"_multi"+MAX_NUM_GEN);
                        }
                        mSmartListDone.put(fName, fName);
                    }
                    else if ((drawType.equals("continue_draw")) && (types[ii].equals("continue_draw")))
                    {
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");
                        if (!optimization.equals("_xyStays"))
                        {
                            smB.append("\tSET_SHIFT_END\n");
                            addOpto(smB, optimization, true);
                        }
                        else 
                            addOpto(smB, optimization, false);

                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_cd"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }

                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("continue_draw"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            if (!optimization.equals("_xyStays"))
                            {
                                smB.append("\tSET_SHIFT_END\n");
                                addOpto(smB, "", false);
                            }
                            else 
                                addOpto(smB, optimization, false);
    
                            smB.append("\tjmp "+"again_cd"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_cd"+i +":\n");
                                smB.append("\tnop\n");
                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW\n");
                                    smB.append("\tjmp "+"again_cd"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("continue_draw"+"_multi"+MAX_NUM_GEN, "continue_draw"+"_multi"+MAX_NUM_GEN);
                        }

                        mSmartListDone.put(fName, fName);
                    }
                    else if ((drawType.equals("continue_move")) && (types[ii].equals("continue_move")))
                    {
                        // -> these are only needed for the start of the Vectorlist - to move to the startpoint
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");

                        addOpto(smB, optimization, false);

                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_cm"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }
                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("continue_move"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            addOpto(smB, "", false);
                            smB.append("\tjmp "+"again_cm"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_cm"+i +":\n");
                                smB.append("\tnop\n");
                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE\n");
                                    smB.append("\tjmp "+"again_cm"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("continue_move"+"_multi"+MAX_NUM_GEN, "continue_move"+"multi"+MAX_NUM_GEN);
                        }
                        mSmartListDone.put(fName, fName);
                    }
                }
            }
        }
        smB.append("\topt\n");
        smB.append(LAST_DRAW_RTS2);
        smB.append(LAST_DRAW_RTS);
        
        
        return smB.toString();
    }
    String buildSmartlistFunctions(HashMap<String, String> smartlistCollector)
    {
        if (alternateSmartlist == 1)
            return buildSmartlistFunctionsAlternate1(smartlistCollector);
        if (alternateSmartlist == 2)
            return buildSmartlistFunctionsAlternate2(smartlistCollector);
        // city
        smartlistCollector.put("SM_continue_move_multi6", "SM_continue_move_multi6");
        smartlistCollector.put("SM_continue_draw", "SM_continue_draw");
        smartlistCollector.put("SM_continue_draw_multi2", "SM_continue_draw_multi2");
        smartlistCollector.put("SM_continue_draw_multi3", "SM_continue_draw_multi3");
        smartlistCollector.put("SM_continue_draw_multi4", "SM_continue_draw_multi4");
        smartlistCollector.put("SM_continue_draw_multi12", "SM_continue_draw_multi12");
        smartlistCollector.put("SM_continue_draw_yd4", "SM_continue_draw_yd4");
        smartlistCollector.put("SM_continue_draw_yd4_multi2", "SM_continue_draw_yd4_multi2");
        smartlistCollector.put("SM_continue_draw_yd4_multi4", "SM_continue_draw_yd4_multi4");
        smartlistCollector.put("SM_continue_draw_yd4_newY_eq_oldX", "SM_continue_draw_yd4_newY_eq_oldX");
        smartlistCollector.put("SM_continue_draw_yd4_yEqx", "SM_continue_draw_yd4_yEqx");
        smartlistCollector.put("SM_startDraw", "SM_startDraw");
        smartlistCollector.put("SM_startDraw_multi2", "SM_startDraw_multi2");
        smartlistCollector.put("SM_startDraw_yd4_multi3", "SM_startDraw_yd4_multi3");
        smartlistCollector.put("SM_startMove", "SM_startMove");
        smartlistCollector.put("SM_startMove_multi2", "SM_startMove_multi2");
        smartlistCollector.put("SM_startMove_multi6", "SM_startMove_multi6");

        // net
        smartlistCollector.put("SM_continue_move_multi3", "SM_continue_move_multi3");
        smartlistCollector.put("SM_startDraw_multi8", "SM_startDraw_multi8");
        smartlistCollector.put("SM_startDraw_yd4_multi8", "SM_startDraw_yd4_multi8");
        smartlistCollector.put("SM_startDraw_yd4_multi16", "SM_startDraw_yd4_multi16");
        smartlistCollector.put("SM_startMove_multi16", "SM_startMove_multi16");
        smartlistCollector.put("SM_startMove_yd4_multi16", "SM_startMove_yd4_multi16");
        smartlistCollector.put("SM_continue_draw_multi6", "SM_continue_draw_multi6");
        smartlistCollector.put("SM_continue_draw_multi8", "SM_continue_draw_multi8");
        smartlistCollector.put("SM_continue_move_multi12", "SM_continue_move_multi12");
        smartlistCollector.put("SM_continue_move_multi16", "SM_continue_move_multi16");
        smartlistCollector.put("SM_startDraw_multi6", "SM_startDraw_multi6");
        smartlistCollector.put("SM_continue_draw_multi16", "SM_continue_draw_multi16");
        smartlistCollector.put("SM_startDraw_multi12", "SM_startDraw_multi12");

	
        
        StringBuilder smB = new StringBuilder();
        String SET_Y_X = "SET_Y_X             macro\n"+
                         "\tSTA      <VIA_port_a                  ;[4] Send Y to A/D\n"+
                         "\tclra                                  ;[2]\n"+
                         "\tsta      <VIA_port_b                  ;[4] Enable mux\n"+
                         "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                         "\tendm\n";
        String SET_YSTAYS_X = "SET_YSTAYS_X             macro\n"+
                         "\t                                      ;[] A is generated to 0\n"+
                         "\tnop 4                                 ;[8]\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                         "\tendm\n";

        String SET_Y_EQUOLD_X = "SET_Y_EQUOLD_X             macro\n"+
                         "\t                                      ;[] A is generated to 0\n"+
                         "\tsta      <VIA_port_b                  ;[4] Enable mux\n"+
                         "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                         "\tendm\n";

        String SET_Y_EQU_X = "SET_Y_EQU_X             macro\n"+
                         "\t                                      ;[ ] A is generated to 0\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send Y to A/D\n"+
                         "\tsta      <VIA_port_b                  ;[4] Enable mux\n"+
                         "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
                         "\tendm\n";
        String SET_Y_X0 = "SET_Y_X0             macro\n"+
                         "\tSTA      <VIA_port_a                  ;[4] Send Y to A/D\n"+
                         "\tstb      <VIA_port_b                  ;[4] Enable mux\n"+
                         "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                         "\tendm\n";
        String SET_Y0_X = "SET_Y0_X             macro\n"+
                         "\tSTA      <VIA_port_a                  ;[4] Send Y to A/D\n"+
                         "\tsta      <VIA_port_b                  ;[4] Enable mux\n"+
                         "\tINC      <VIA_port_b                  ;[6] Disable mux\n"+
                         "\tSTB      <VIA_port_a                  ;[4] Send X to A/D\n"+
                         "\tendm\n";

        String SET_SHIFT_START = "SET_SHIFT_START             macro\n"+
                         "\tsty      <VIA_shift_reg               ;[4] Store pattern in shift register \n"+
                         "\tendm\n";
        String SET_SHIFT_END = "SET_SHIFT_END             macro\n"+
                         "\tstx      <VIA_shift_reg               ;[5, but shift after 4!] \n"+
                         "\tendm\n";
        String START_T1_AGAIN_MOVE = "START_T1_AGAIN_MOVE             macro\n"+
                         "\tnop 2\n" +
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String START_T1_AGAIN_DRAW = "START_T1_AGAIN_DRAW             macro\n"+
                         "\tnop 2\n" +
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";

        String START_T1_AGAIN_MOVE_LAST = "START_T1_AGAIN_MOVE_LAST             macro\n"+
                         "\tnop 2\n" +
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String START_T1_AGAIN_DRAW_LAST = "START_T1_AGAIN_DRAW_LAST             macro\n"+
                         "\tnop 2\n" +
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";


        String START_T1 = "START_T1             macro\n"+
                         "\tsta      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String START_T1_B = "START_T1_B             macro\n"+
                         "\tstb      <VIA_t1_cnt_hi               ;[4] Clear T1H\n"+
                         "\tendm\n";
        String PULL_NEXT_LINE = "PULL_NEXT_LINE             macro\n"+
                         "\tpulu     d,pc                         ;[9] \n"+
                         "\tendm\n";


        String LAST_DRAW_RTS2 = "SM_lastDraw_rts2                                        ;#isfunction  \n"+
                    "\tSET_SHIFT_END  \n"+
                    "\tlda      gameScale \n"+
                    "\tsta      <VIA_t1_cnt_lo \n"+
                    "\tldb      #$cc \n"+
                    "\tSTb      <VIA_cntl                    ;/BLANK low and /ZERO low \n"+

/* or calibrate if used
                    "; zero ref\n"+
		    "\tLDD     #$0302\n"+
                    "\tCLR     <VIA_port_a     ;clear D/A register\n"+
                    "\tSTA     <VIA_port_b     ;mux=1, disable mux\n"+
                    "\tSTB     <VIA_port_b     ;mux=1, enable mux\n"+
                    "\tSTB     <VIA_port_b     ;do it again\n"+
*/                
                    "\tLDB     #$01\n"+
                    "\tSTB     <VIA_port_b     ;disable mux\n"+
                    "\tpuls     d,pc                         ; (D = y,x, pc = next object) \n";

        String LAST_DRAW_RTS = "SM_lastDraw_rts                                        ;#isfunction  \n"+
                    "\tSET_SHIFT_END  \n"+
                    "\tlda      gameScale \n"+
                    "\tsta      <VIA_t1_cnt_lo \n"+
                    "\tldb      #$cc \n"+
                    "\tSTb      <VIA_cntl                    ;/BLANK low and /ZERO low \n"+
/* or calibrate if used
                    "; zero ref\n"+
		    "\tLDD     #$0302\n"+
                    "\tCLR     <VIA_port_a     ;clear D/A register\n"+
                    "\tSTA     <VIA_port_b     ;mux=1, disable mux\n"+
                    "\tSTB     <VIA_port_b     ;mux=1, enable mux\n"+
                    "\tSTB     <VIA_port_b     ;do it again\n"+
*/                
                    "\tLDB     #$01\n"+
                    "\tSTB     <VIA_port_b     ;disable mux\n"+
                    "\trts \n";
        
        
        smB.append("\tnoopt\n");
        
        smB.append(SET_Y_X);
        smB.append(SET_YSTAYS_X);
        smB.append(SET_Y_EQUOLD_X);
        smB.append(SET_Y_EQU_X);
        smB.append(SET_Y_X0);
        smB.append(SET_Y0_X);
        smB.append(SET_SHIFT_START);
        smB.append(SET_SHIFT_END);
        smB.append(START_T1);
        smB.append(START_T1_AGAIN_MOVE);
        smB.append(START_T1_AGAIN_DRAW);
        smB.append(START_T1_AGAIN_MOVE_LAST);
        smB.append(START_T1_AGAIN_DRAW_LAST);
        smB.append(START_T1_B);
        smB.append(PULL_NEXT_LINE);

        GenerationParameters p = new GenerationParameters();

        p.compileForVB = true; // use stack for object list 
        p.rts2 = false; //  rts 2
        p.paraName = "Example";
        p.doNoPositionMove = false;
        veccy.setParameters(p);
        
        String prefix = veccy.functionPrefix;

        String types[] = new String[4];
        types[0] = "startMove";
        types[1] = "startDraw";
        types[2] = "continue_draw";
        types[3] = "continue_move";

        for (int ii=0;ii<4;ii++)
        {
        
            Set entries = smartlistCollector.entrySet();
            Iterator it = entries.iterator();
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                String fName = (String) entry.getValue();
                String n = replace(fName, prefix, "");

                String drawType = "";
                String delayInfo = "";
                int sequenceCount=0;
                String optimization="";
                String countAdd = "";
                if (n.startsWith("startMove")) drawType = "startMove";
                if (n.startsWith("startDraw")) drawType = "startDraw";
    //            if (n.startsWith("continue")) drawType = "continue";
                if (n.startsWith("continue_draw")) drawType = "continue_draw";
                if (n.startsWith("continue_move")) drawType = "continue_move";


                n =  replace(n, drawType, "");
                if (n.startsWith("_yd4")) delayInfo = "_yd4";
                n =  replace(n, delayInfo, "");

                if (n.length()>0)
                    sequenceCount = Int0(n.substring(0,1));
                if (sequenceCount>0) n =  n.substring(1);

                if (n.startsWith("_newY_eq_oldX")) optimization="_newY_eq_oldX";
                if (n.startsWith("_yEqx")) optimization="_yEqx";
                if (n.startsWith("_x0")) optimization="_x0";
                if (n.startsWith("_y0")) optimization="_y0";
                if (n.startsWith("_xyStays")) optimization="_xyStays";
                if (n.startsWith("_yStays")) optimization="_yStays";
                n =  replace(n, optimization, "");

                int sameCount = 0;
                if (n.startsWith("_multi")) 
                {
                    if (n.length()>=2+6)
                    {
                        sameCount = Int0(n.substring(6,8));
                        if (sameCount<=0)
                        {
                            sameCount = Int0(n.substring(6,7));
                        }
                    }
                    else if (n.length()>=1)
                    {
                        sameCount = Int0(n.substring(6,7));
                    }
                    countAdd="_multi"+sameCount;
                    n =  replace(n, countAdd, "");
                }


                boolean decode = false;
                if (fName.startsWith(prefix+"setIntensity"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'setIntensity'");
                }
                else if (fName.startsWith(prefix+"lastDraw_rts2"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'lastDraw_rts2'");
                }
                else if (fName.startsWith(prefix+"lastDraw_rts"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'lastDraw_rts'");
                }
                else if (fName.startsWith(prefix+"LightOff_Intensity"))
                {
                    decode = true;
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + 'LightOff_Intensity'");
                }

                if (!decode)
                {
                    if (n.length() != 0)
                    {
                        ShowWarningDialog.showWarningDialog("Function name unresolved!", "Smartlist function name could not be decoded ("+fName+")");
                        continue;
                    }
                    System.out.println("FN: "+fName+" decoded to: '"+prefix+"' + '"+ drawType+"' + '"+ delayInfo+"' + '"+ sequenceCount+"' + '"+ optimization+"' + '"+ countAdd+"'");
        fName = replace(fName, "_yd4","");
                    String bName = prefix+drawType+"_yd4"+     /*sequenceCount */optimization+countAdd;
                    String oName = prefix+drawType+  /*delayInfo+sequenceCount+*/optimization+countAdd;

                    if (mSmartListDone.containsKey(fName)) continue;

                    if ((drawType.equals("startMove")) && (types[ii].equals("startMove")))
                    {
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");
                        smB.append("\tSET_SHIFT_END\n");
                        addOpto(smB, optimization, false);
                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_sm"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }

                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("startMove"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            smB.append("\tSET_SHIFT_END\n");
                            addOpto(smB, "", false);
                            smB.append("\tjmp "+"again_sm"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_sm"+i +":\n");
                                smB.append("\tnop\n");

                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE\n");
                                    smB.append("\tjmp "+"again_sm"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("startMove"+"_multi"+MAX_NUM_GEN, "startMove"+"_multi"+MAX_NUM_GEN);
                        }
                        mSmartListDone.put(fName, fName);
                    }
                    else if ((drawType.equals("startDraw")) && (types[ii].equals("startDraw")))
                    {
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");
                        addOpto(smB, optimization, true);
                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_sd"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }

                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("startDraw"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            addOpto(smB, "", false);
                            smB.append("\tjmp "+"again_sd"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_sd"+i +":\n");
                                smB.append("\tnop\n");
                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW\n");
                                    smB.append("\tjmp "+"again_sd"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("startDraw"+"_multi"+MAX_NUM_GEN, "startDraw"+"_multi"+MAX_NUM_GEN);
                        }
                        mSmartListDone.put(fName, fName);
                    }
                    else if ((drawType.equals("continue_draw")) && (types[ii].equals("continue_draw")))
                    {
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");
                        if (!optimization.equals("_xyStays"))
                        {
                            smB.append("\tSET_SHIFT_END\n");
                            addOpto(smB, optimization, true);
                        }
                        else 
                            addOpto(smB, optimization, false);

                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_cd"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }

                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("continue_draw"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            if (!optimization.equals("_xyStays"))
                            {
                                smB.append("\tSET_SHIFT_END\n");
                                addOpto(smB, "", false);
                            }
                            else 
                                addOpto(smB, optimization, false);
    
                            smB.append("\tjmp "+"again_cd"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_cd"+i +":\n");
                                smB.append("\tnop\n");
                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW\n");
                                    smB.append("\tjmp "+"again_cd"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_DRAW_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("continue_draw"+"_multi"+MAX_NUM_GEN, "continue_draw"+"_multi"+MAX_NUM_GEN);
                        }

                        mSmartListDone.put(fName, fName);
                    }
                    else if ((drawType.equals("continue_move")) && (types[ii].equals("continue_move")))
                    {
                        // -> these are only needed for the start of the Vectorlist - to move to the startpoint
                        smB.append(bName+":\n");
                        smB.append(oName+":\n");

                        addOpto(smB, optimization, false);

                        if (sameCount > 1)
                        {
                            smB.append("\tjmp      again_cm"+(sameCount-1)+"\n");
                        }
                        else
                        {
                            smB.append("\tPULL_NEXT_LINE\n");
                        }
                        // ensure up MAX_NUM_GEN
                        if (!mSmartListDone.containsKey("continue_move"+"_multi"+MAX_NUM_GEN)) 
                        {
                            smB.append(drawType+"_multi"+MAX_NUM_GEN+":\n");
                            addOpto(smB, "", false);
                            smB.append("\tjmp "+"again_cm"+(MAX_NUM_GEN-1)+"\n");

                            for (int i = MAX_NUM_GEN-1; i>=1;i--)
                            {
                                smB.append("again_cm"+i +":\n");
                                smB.append("\tnop\n");
                                if (i!=1)
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE\n");
                                    smB.append("\tjmp "+"again_cm"+(i-1)+"\n");
                                }
                                else
                                {
                                    smB.append("\tSTART_T1_AGAIN_MOVE_LAST\n");
                                }
                            }
                            smB.append("\tPULL_NEXT_LINE\n");
                            mSmartListDone.put("continue_move"+"_multi"+MAX_NUM_GEN, "continue_move"+"multi"+MAX_NUM_GEN);
                        }
                        mSmartListDone.put(fName, fName);
                    }
                }
            }
        }
        smB.append("\topt\n");
        smB.append(LAST_DRAW_RTS2);
        smB.append(LAST_DRAW_RTS);
        
        
        return smB.toString();
    }
    void addOpto(StringBuilder smB, String optimization, boolean isDraw)
    {
        if (optimization.length()==0)
        {
            smB.append("\tSET_Y_X\n");
            if (isDraw) smB.append("\tSET_SHIFT_START\n");
            smB.append("\tSTART_T1\n");
        }
        else if (optimization.equals("_yStays"))
        {
            smB.append("\tSET_YSTAYS_X\n");
            if (isDraw) smB.append("\tSET_SHIFT_START\n");
            smB.append("\tSTART_T1\n");
        }
        else if (optimization.equals("_xyStays"))
        {
            if (isDraw) smB.append("\tSET_SHIFT_START\n");
            smB.append("\tSTART_T1\n");
        }
        else if (optimization.equals("_y0"))
        {
            smB.append("\tSET_Y0_X\n");
            if (isDraw) smB.append("\tSET_SHIFT_START\n");
            smB.append("\tSTART_T1\n");
        }
        else if (optimization.equals("_x0"))
        {
            smB.append("\tSSET_Y_X0\n");
            if (isDraw) smB.append("\tSET_SHIFT_START\n");
            smB.append("\tSTART_T1_B\n");
        }
        else if (optimization.equals("_yEqx"))
        {
            smB.append("\tSET_Y_EQU_X\n");
            if (isDraw) smB.append("\tSET_SHIFT_START\n");
            smB.append("\tSTART_T1\n");
        }
        else if (optimization.equals("_newY_eq_oldX"))
        {
            smB.append("\tSET_Y_EQUOLD_X\n");
            if (isDraw) smB.append("\tSET_SHIFT_START\n");
            smB.append("\tSTART_T1\n");
        }
    }
}

