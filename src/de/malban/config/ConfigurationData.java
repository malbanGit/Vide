package de.malban.config;

import de.malban.util.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;

public class  ConfigurationData
{
	protected String mClass="";
	public String mName="";
	protected int mStartMoney=0;
	protected String mLastPlayer="";
	protected Vector<String> mSetUsed=new Vector<String>();
	protected String mStarterSet="";
	protected String mStarterHeapGeneratopnType="";
	protected int mScale=0;
	protected int mCardWidth=0;
	protected int mCardHeight=0;
	protected String mFullscreenResolution="";
	protected boolean mFirstTimeStarting=false;
	protected String mGathererBaseURL="";
	protected boolean mStartInFullScreen=false;
	protected boolean mOpponentHandShown=false;
	protected boolean mPortableDebugWindow=false;
	protected boolean mPassActiveFirstCreatureStack=false;
	protected boolean mPassAutoOnEmptyStack=false;
	protected Vector<Boolean> mOpponentEmptyStackPass=new Vector<Boolean>();
	protected int mDebugLevel=0;
	protected boolean mAutoUntapCreatures=false;
	protected boolean mAutoUntapLands=false;
	protected boolean mAllowMoreThan7Cards=false;
	protected boolean mAutoPassUpkeep=false;
	protected boolean mSkipDamageWhenNoAttacker=false;
	protected boolean mSkipBlockWhenNoAttacker=false;
	protected boolean mSkipUntapWhenNothingToUntap=false;
	protected boolean mAutoPassDrawAfterCardDrawn=false;
	protected boolean mPassCombatBegin=false;
	protected boolean mPassCombatEnd=false;
	protected boolean mPassEndEnd=false;
	protected boolean mPassEndCleanup=false;
	protected boolean mPassOwnDamageStep=false;
	protected boolean mPassSecondMainWhenNoCombat=false;
	protected boolean mPassBlockerWhenNoBlocker=false;
	protected String mDebugFiles="";
	protected String mDebugClasses="";
	protected String mDebugMethods="";
	protected boolean mDebugTiming=false;
	protected boolean mDebugOff=false;
	protected boolean mDebugFileOnly=false;
	protected boolean mUseScriptCaching=false;
	protected int mSoundVolumne=0;
	protected boolean mFirstTime=false;
	protected String mTitleMusik="";
	protected boolean mGameBackImageEnabled=false;
	protected boolean mImageOnlyFullscreen=false;
	protected String mGameBackImage="";
	protected String mSoundMapName="";
	protected boolean mDisableFileLogs=false;
	protected int mEarnMoneyPerWin=0;
	protected int mBoosterCost=0;
	protected boolean mRememberLastPlayer=false;
	protected boolean mShowTippOfDay=false;
	protected boolean mPlayMusic=false;
	protected boolean mNoPanelChanging=false;
	protected int mWarningTimer=0;
	protected int mErrorTimer=0;
	protected int mSicknessAlpha=0;
	protected int mDeathAlpha=0;
	protected boolean mUseSpaceToDrawInPhase1=false;
	protected boolean mAutoTapMan=false;
	protected boolean mUseManaPool=false;
	protected boolean mDoManaBurn=false;
	protected boolean mLegendaryRuling=false;
	protected int mHandRestriction=0;
	protected boolean mTargetBeforStack=false;
	protected boolean mShowScoreAndPauseEachRound=false;
	protected int mHandRestrictionCount=0;
	protected String mDefaultWeighting="";
	protected boolean mShowDebugLogOnInfo=false;
	protected boolean mDebugAutoSave=false;
	protected boolean mCleanNonHighScoreLeafs=false;
	protected boolean mNoSound=false;
	protected boolean mEAIFullVMtach=false;
	protected String mCurrentThemeName="";
	protected boolean mExpandImage=false;
	protected boolean mFairLandDistribution=false;
	protected int mFairMin=0;
	protected int mFairMax=0;
	public int getStartMoney()
	{
		return mStartMoney;
	}
	public void setStartMoney(int StartMoney)
	{
		mStartMoney=StartMoney;
	}
	public String getLastPlayer()
	{
		return mLastPlayer;
	}
	public void setLastPlayer(String LastPlayer)
	{
		mLastPlayer=LastPlayer;
	}
	public Vector<String> getSetUsed()
	{
		return mSetUsed;
	}
	public void setSetUsed(Vector<String> SetUsed)
	{
		mSetUsed=SetUsed;
	}
	public String getStarterSet()
	{
		return mStarterSet;
	}
	public void setStarterSet(String StarterSet)
	{
		mStarterSet=StarterSet;
	}
	public String getStarterHeapGeneratopnType()
	{
		return mStarterHeapGeneratopnType;
	}
	public void setStarterHeapGeneratopnType(String StarterHeapGeneratopnType)
	{
		mStarterHeapGeneratopnType=StarterHeapGeneratopnType;
	}
	public int getScale()
	{
		return mScale;
	}
	public void setScale(int Scale)
	{
		mScale=Scale;
	}
	public int getCardWidth()
	{
		return mCardWidth;
	}
	public void setCardWidth(int CardWidth)
	{
		mCardWidth=CardWidth;
	}
	public int getCardHeight()
	{
		return mCardHeight;
	}
	public void setCardHeight(int CardHeight)
	{
		mCardHeight=CardHeight;
	}
	public String getFullscreenResolution()
	{
		return mFullscreenResolution;
	}
	public void setFullscreenResolution(String FullscreenResolution)
	{
		mFullscreenResolution=FullscreenResolution;
	}
	public boolean getFirstTimeStarting()
	{
		return mFirstTimeStarting;
	}
	public void setFirstTimeStarting(boolean FirstTimeStarting)
	{
		mFirstTimeStarting=FirstTimeStarting;
	}
	public String getGathererBaseURL()
	{
		return mGathererBaseURL;
	}
	public void setGathererBaseURL(String GathererBaseURL)
	{
		mGathererBaseURL=GathererBaseURL;
	}
	public boolean getStartInFullScreen()
	{
		return mStartInFullScreen;
	}
	public void setStartInFullScreen(boolean StartInFullScreen)
	{
		mStartInFullScreen=StartInFullScreen;
	}
	public boolean getOpponentHandShown()
	{
		return mOpponentHandShown;
	}
	public void setOpponentHandShown(boolean OpponentHandShown)
	{
		mOpponentHandShown=OpponentHandShown;
	}
	public boolean getPortableDebugWindow()
	{
		return mPortableDebugWindow;
	}
	public void setPortableDebugWindow(boolean PortableDebugWindow)
	{
		mPortableDebugWindow=PortableDebugWindow;
	}
	public boolean getPassActiveFirstCreatureStack()
	{
		return mPassActiveFirstCreatureStack;
	}
	public void setPassActiveFirstCreatureStack(boolean PassActiveFirstCreatureStack)
	{
		mPassActiveFirstCreatureStack=PassActiveFirstCreatureStack;
	}
	public boolean getPassAutoOnEmptyStack()
	{
		return mPassAutoOnEmptyStack;
	}
	public void setPassAutoOnEmptyStack(boolean PassAutoOnEmptyStack)
	{
		mPassAutoOnEmptyStack=PassAutoOnEmptyStack;
	}
	public Vector<Boolean> getOpponentEmptyStackPass()
	{
		return mOpponentEmptyStackPass;
	}
	public void setOpponentEmptyStackPass(Vector<Boolean> OpponentEmptyStackPass)
	{
		mOpponentEmptyStackPass=OpponentEmptyStackPass;
	}
	public int getDebugLevel()
	{
		return mDebugLevel;
	}
	public void setDebugLevel(int DebugLevel)
	{
		mDebugLevel=DebugLevel;
	}
	public boolean getAutoUntapCreatures()
	{
		return mAutoUntapCreatures;
	}
	public void setAutoUntapCreatures(boolean AutoUntapCreatures)
	{
		mAutoUntapCreatures=AutoUntapCreatures;
	}
	public boolean getAutoUntapLands()
	{
		return mAutoUntapLands;
	}
	public void setAutoUntapLands(boolean AutoUntapLands)
	{
		mAutoUntapLands=AutoUntapLands;
	}
	public boolean getAllowMoreThan7Cards()
	{
		return mAllowMoreThan7Cards;
	}
	public void setAllowMoreThan7Cards(boolean AllowMoreThan7Cards)
	{
		mAllowMoreThan7Cards=AllowMoreThan7Cards;
	}
	public boolean getAutoPassUpkeep()
	{
		return mAutoPassUpkeep;
	}
	public void setAutoPassUpkeep(boolean AutoPassUpkeep)
	{
		mAutoPassUpkeep=AutoPassUpkeep;
	}
	public boolean getSkipDamageWhenNoAttacker()
	{
		return mSkipDamageWhenNoAttacker;
	}
	public void setSkipDamageWhenNoAttacker(boolean SkipDamageWhenNoAttacker)
	{
		mSkipDamageWhenNoAttacker=SkipDamageWhenNoAttacker;
	}
	public boolean getSkipBlockWhenNoAttacker()
	{
		return mSkipBlockWhenNoAttacker;
	}
	public void setSkipBlockWhenNoAttacker(boolean SkipBlockWhenNoAttacker)
	{
		mSkipBlockWhenNoAttacker=SkipBlockWhenNoAttacker;
	}
	public boolean getSkipUntapWhenNothingToUntap()
	{
		return mSkipUntapWhenNothingToUntap;
	}
	public void setSkipUntapWhenNothingToUntap(boolean SkipUntapWhenNothingToUntap)
	{
		mSkipUntapWhenNothingToUntap=SkipUntapWhenNothingToUntap;
	}
	public boolean getAutoPassDrawAfterCardDrawn()
	{
		return mAutoPassDrawAfterCardDrawn;
	}
	public void setAutoPassDrawAfterCardDrawn(boolean AutoPassDrawAfterCardDrawn)
	{
		mAutoPassDrawAfterCardDrawn=AutoPassDrawAfterCardDrawn;
	}
	public boolean getPassCombatBegin()
	{
		return mPassCombatBegin;
	}
	public void setPassCombatBegin(boolean PassCombatBegin)
	{
		mPassCombatBegin=PassCombatBegin;
	}
	public boolean getPassCombatEnd()
	{
		return mPassCombatEnd;
	}
	public void setPassCombatEnd(boolean PassCombatEnd)
	{
		mPassCombatEnd=PassCombatEnd;
	}
	public boolean getPassEndEnd()
	{
		return mPassEndEnd;
	}
	public void setPassEndEnd(boolean PassEndEnd)
	{
		mPassEndEnd=PassEndEnd;
	}
	public boolean getPassEndCleanup()
	{
		return mPassEndCleanup;
	}
	public void setPassEndCleanup(boolean PassEndCleanup)
	{
		mPassEndCleanup=PassEndCleanup;
	}
	public boolean getPassOwnDamageStep()
	{
		return mPassOwnDamageStep;
	}
	public void setPassOwnDamageStep(boolean PassOwnDamageStep)
	{
		mPassOwnDamageStep=PassOwnDamageStep;
	}
	public boolean getPassSecondMainWhenNoCombat()
	{
		return mPassSecondMainWhenNoCombat;
	}
	public void setPassSecondMainWhenNoCombat(boolean PassSecondMainWhenNoCombat)
	{
		mPassSecondMainWhenNoCombat=PassSecondMainWhenNoCombat;
	}
	public boolean getPassBlockerWhenNoBlocker()
	{
		return mPassBlockerWhenNoBlocker;
	}
	public void setPassBlockerWhenNoBlocker(boolean PassBlockerWhenNoBlocker)
	{
		mPassBlockerWhenNoBlocker=PassBlockerWhenNoBlocker;
	}
	public String getDebugFiles()
	{
		return mDebugFiles;
	}
	public void setDebugFiles(String DebugFiles)
	{
		mDebugFiles=DebugFiles;
	}
	public String getDebugClasses()
	{
		return mDebugClasses;
	}
	public void setDebugClasses(String DebugClasses)
	{
		mDebugClasses=DebugClasses;
	}
	public String getDebugMethods()
	{
		return mDebugMethods;
	}
	public void setDebugMethods(String DebugMethods)
	{
		mDebugMethods=DebugMethods;
	}
	public boolean getDebugTiming()
	{
		return mDebugTiming;
	}
	public void setDebugTiming(boolean DebugTiming)
	{
		mDebugTiming=DebugTiming;
	}
	public boolean getDebugOff()
	{
		return mDebugOff;
	}
	public void setDebugOff(boolean DebugOff)
	{
		mDebugOff=DebugOff;
	}
	public boolean getDebugFileOnly()
	{
		return mDebugFileOnly;
	}
	public void setDebugFileOnly(boolean DebugFileOnly)
	{
		mDebugFileOnly=DebugFileOnly;
	}
	public boolean getUseScriptCaching()
	{
		return mUseScriptCaching;
	}
	public void setUseScriptCaching(boolean UseScriptCaching)
	{
		mUseScriptCaching=UseScriptCaching;
	}
	public int getSoundVolumne()
	{
		return mSoundVolumne;
	}
	public void setSoundVolumne(int SoundVolumne)
	{
		mSoundVolumne=SoundVolumne;
	}
	public boolean getFirstTime()
	{
		return mFirstTime;
	}
	public void setFirstTime(boolean FirstTime)
	{
		mFirstTime=FirstTime;
	}
	public String getTitleMusik()
	{
		return mTitleMusik;
	}
	public void setTitleMusik(String TitleMusik)
	{
		mTitleMusik=TitleMusik;
	}
	public boolean getGameBackImageEnabled()
	{
		return mGameBackImageEnabled;
	}
	public void setGameBackImageEnabled(boolean GameBackImageEnabled)
	{
		mGameBackImageEnabled=GameBackImageEnabled;
	}
	public boolean getImageOnlyFullscreen()
	{
		return mImageOnlyFullscreen;
	}
	public void setImageOnlyFullscreen(boolean ImageOnlyFullscreen)
	{
		mImageOnlyFullscreen=ImageOnlyFullscreen;
	}
	public String getGameBackImage()
	{
		return mGameBackImage;
	}
	public void setGameBackImage(String GameBackImage)
	{
		mGameBackImage=GameBackImage;
	}
	public String getSoundMapName()
	{
		return mSoundMapName;
	}
	public void setSoundMapName(String SoundMapName)
	{
		mSoundMapName=SoundMapName;
	}
	public boolean getDisableFileLogs()
	{
		return mDisableFileLogs;
	}
	public void setDisableFileLogs(boolean DisableFileLogs)
	{
		mDisableFileLogs=DisableFileLogs;
	}
	public int getEarnMoneyPerWin()
	{
		return mEarnMoneyPerWin;
	}
	public void setEarnMoneyPerWin(int EarnMoneyPerWin)
	{
		mEarnMoneyPerWin=EarnMoneyPerWin;
	}
	public int getBoosterCost()
	{
		return mBoosterCost;
	}
	public void setBoosterCost(int BoosterCost)
	{
		mBoosterCost=BoosterCost;
	}
	public boolean getRememberLastPlayer()
	{
		return mRememberLastPlayer;
	}
	public void setRememberLastPlayer(boolean RememberLastPlayer)
	{
		mRememberLastPlayer=RememberLastPlayer;
	}
	public boolean getShowTippOfDay()
	{
		return mShowTippOfDay;
	}
	public void setShowTippOfDay(boolean ShowTippOfDay)
	{
		mShowTippOfDay=ShowTippOfDay;
	}
	public boolean getPlayMusic()
	{
		return mPlayMusic;
	}
	public void setPlayMusic(boolean PlayMusic)
	{
		mPlayMusic=PlayMusic;
	}
	public boolean getNoPanelChanging()
	{
		return mNoPanelChanging;
	}
	public void setNoPanelChanging(boolean NoPanelChanging)
	{
		mNoPanelChanging=NoPanelChanging;
	}
	public int getWarningTimer()
	{
		return mWarningTimer;
	}
	public void setWarningTimer(int WarningTimer)
	{
		mWarningTimer=WarningTimer;
	}
	public int getErrorTimer()
	{
		return mErrorTimer;
	}
	public void setErrorTimer(int ErrorTimer)
	{
		mErrorTimer=ErrorTimer;
	}
	public int getSicknessAlpha()
	{
		return mSicknessAlpha;
	}
	public void setSicknessAlpha(int SicknessAlpha)
	{
		mSicknessAlpha=SicknessAlpha;
	}
	public int getDeathAlpha()
	{
		return mDeathAlpha;
	}
	public void setDeathAlpha(int DeathAlpha)
	{
		mDeathAlpha=DeathAlpha;
	}
	public boolean getUseSpaceToDrawInPhase1()
	{
		return mUseSpaceToDrawInPhase1;
	}
	public void setUseSpaceToDrawInPhase1(boolean UseSpaceToDrawInPhase1)
	{
		mUseSpaceToDrawInPhase1=UseSpaceToDrawInPhase1;
	}
	public boolean getAutoTapMan()
	{
		return mAutoTapMan;
	}
	public void setAutoTapMan(boolean AutoTapMan)
	{
		mAutoTapMan=AutoTapMan;
	}
	public boolean getUseManaPool()
	{
		return mUseManaPool;
	}
	public void setUseManaPool(boolean UseManaPool)
	{
		mUseManaPool=UseManaPool;
	}
	public boolean getDoManaBurn()
	{
		return mDoManaBurn;
	}
	public void setDoManaBurn(boolean DoManaBurn)
	{
		mDoManaBurn=DoManaBurn;
	}
	public boolean getLegendaryRuling()
	{
		return mLegendaryRuling;
	}
	public void setLegendaryRuling(boolean LegendaryRuling)
	{
		mLegendaryRuling=LegendaryRuling;
	}
	public int getHandRestriction()
	{
		return mHandRestriction;
	}
	public void setHandRestriction(int HandRestriction)
	{
		mHandRestriction=HandRestriction;
	}
	public boolean getTargetBeforStack()
	{
		return mTargetBeforStack;
	}
	public void setTargetBeforStack(boolean TargetBeforStack)
	{
		mTargetBeforStack=TargetBeforStack;
	}
	public boolean getShowScoreAndPauseEachRound()
	{
		return mShowScoreAndPauseEachRound;
	}
	public void setShowScoreAndPauseEachRound(boolean ShowScoreAndPauseEachRound)
	{
		mShowScoreAndPauseEachRound=ShowScoreAndPauseEachRound;
	}
	public int getHandRestrictionCount()
	{
		return mHandRestrictionCount;
	}
	public void setHandRestrictionCount(int HandRestrictionCount)
	{
		mHandRestrictionCount=HandRestrictionCount;
	}
	public String getDefaultWeighting()
	{
		return mDefaultWeighting;
	}
	public void setDefaultWeighting(String DefaultWeighting)
	{
		mDefaultWeighting=DefaultWeighting;
	}
	public boolean getShowDebugLogOnInfo()
	{
		return mShowDebugLogOnInfo;
	}
	public void setShowDebugLogOnInfo(boolean ShowDebugLogOnInfo)
	{
		mShowDebugLogOnInfo=ShowDebugLogOnInfo;
	}
	public boolean getDebugAutoSave()
	{
		return mDebugAutoSave;
	}
	public void setDebugAutoSave(boolean DebugAutoSave)
	{
		mDebugAutoSave=DebugAutoSave;
	}
	public boolean getCleanNonHighScoreLeafs()
	{
		return mCleanNonHighScoreLeafs;
	}
	public void setCleanNonHighScoreLeafs(boolean CleanNonHighScoreLeafs)
	{
		mCleanNonHighScoreLeafs=CleanNonHighScoreLeafs;
	}
	public boolean getNoSound()
	{
		return mNoSound;
	}
	public void setNoSound(boolean NoSound)
	{
		mNoSound=NoSound;
	}
	public boolean getEAIFullVMtach()
	{
		return mEAIFullVMtach;
	}
	public void setEAIFullVMtach(boolean EAIFullVMtach)
	{
		mEAIFullVMtach=EAIFullVMtach;
	}
	public String getCurrentThemeName()
	{
		return mCurrentThemeName;
	}
	public void setCurrentThemeName(String CurrentThemeName)
	{
		mCurrentThemeName=CurrentThemeName;
	}
	public boolean getExpandImage()
	{
		return mExpandImage;
	}
	public void setExpandImage(boolean ExpandImage)
	{
		mExpandImage=ExpandImage;
	}
	public boolean getFairLandDistribution()
	{
		return mFairLandDistribution;
	}
	public void setFairLandDistribution(boolean FairLandDistribution)
	{
		mFairLandDistribution=FairLandDistribution;
	}
	public int getFairMin()
	{
		return mFairMin;
	}
	public void setFairMin(int FairMin)
	{
		mFairMin=FairMin;
	}
	public int getFairMax()
	{
		return mFairMax;
	}
	public void setFairMax(int FairMax)
	{
		mFairMax=FairMax;
	}
	private String exportXML()
	{
		String s = new String();
		s += "\t<ConfigurationData>\n";
		s += "\t\t<Class>"+UtilityString.toXML(mClass)+"</Class>\n";
		s += "\t\t<Name>"+UtilityString.toXML(mName)+"</Name>\n";
		s += "\t\t<STARTMONEY>"+mStartMoney+"</STARTMONEY>\n";
		s += "\t\t<LASTPLAYER>"+UtilityString.toXML(mLastPlayer)+"</LASTPLAYER>\n";
		s += "\t\t<SETUSEDs>\n";
		for (int i=0;i<mSetUsed.size(); i++)
		{
			s += "\t\t\t<SETUSED>"+UtilityString.toXML(mSetUsed.elementAt(i))+"</SETUSED>\n";
		}
		s += "\t\t</SETUSEDs>\n";
		s += "\t\t<STARTERSET>"+UtilityString.toXML(mStarterSet)+"</STARTERSET>\n";
		s += "\t\t<STARTERHEAPGENERATIONTYP>"+UtilityString.toXML(mStarterHeapGeneratopnType)+"</STARTERHEAPGENERATIONTYP>\n";
		s += "\t\t<SCALE>"+mScale+"</SCALE>\n";
		s += "\t\t<CARDWIDTH>"+mCardWidth+"</CARDWIDTH>\n";
		s += "\t\t<CARDHEIGHT>"+mCardHeight+"</CARDHEIGHT>\n";
		s += "\t\t<FULLSCREENRESOLUTION>"+UtilityString.toXML(mFullscreenResolution)+"</FULLSCREENRESOLUTION>\n";
		s += "\t\t<FISTTIMESTARTING>"+mFirstTimeStarting+"</FISTTIMESTARTING>\n";
		s += "\t\t<GATHERERBASEURL>"+UtilityString.toXML(mGathererBaseURL)+"</GATHERERBASEURL>\n";
		s += "\t\t<STARTINFULLSCREEN>"+mStartInFullScreen+"</STARTINFULLSCREEN>\n";
		s += "\t\t<OPPONENTHANDSHOWN>"+mOpponentHandShown+"</OPPONENTHANDSHOWN>\n";
		s += "\t\t<PORTABLEDEBUGWINDOW>"+mPortableDebugWindow+"</PORTABLEDEBUGWINDOW>\n";
		s += "\t\t<PASSACTIVEFIRSTCREATURESTACK>"+mPassActiveFirstCreatureStack+"</PASSACTIVEFIRSTCREATURESTACK>\n";
		s += "\t\t<PASSAUTOONEMPTYSTACK>"+mPassAutoOnEmptyStack+"</PASSAUTOONEMPTYSTACK>\n";
		s += "\t\t<OPPONENTEMPTYSTACKPASSs>\n";
		for (int i=0;i<mOpponentEmptyStackPass.size(); i++)
		{
			s += "\t\t\t<OPPONENTEMPTYSTACKPASS>"+mOpponentEmptyStackPass.elementAt(i)+"</OPPONENTEMPTYSTACKPASS>\n";
		}
		s += "\t\t</OPPONENTEMPTYSTACKPASSs>\n";
		s += "\t\t<DEBUGLEVEL>"+mDebugLevel+"</DEBUGLEVEL>\n";
		s += "\t\t<AUTOUNTAPCREATURES>"+mAutoUntapCreatures+"</AUTOUNTAPCREATURES>\n";
		s += "\t\t<AUTOUNTAPLANDS>"+mAutoUntapLands+"</AUTOUNTAPLANDS>\n";
		s += "\t\t<ALLOWMORTHAN7CARDS>"+mAllowMoreThan7Cards+"</ALLOWMORTHAN7CARDS>\n";
		s += "\t\t<AUTOPASSUPKEEP>"+mAutoPassUpkeep+"</AUTOPASSUPKEEP>\n";
		s += "\t\t<SKIPDAMAGEWHENNOATTACKER>"+mSkipDamageWhenNoAttacker+"</SKIPDAMAGEWHENNOATTACKER>\n";
		s += "\t\t<SKIPBLOCKWHENNOATTACKER>"+mSkipBlockWhenNoAttacker+"</SKIPBLOCKWHENNOATTACKER>\n";
		s += "\t\t<SKIPUNTAPIFNOTHINGTOUNTAP>"+mSkipUntapWhenNothingToUntap+"</SKIPUNTAPIFNOTHINGTOUNTAP>\n";
		s += "\t\t<AutoPassDraw>"+mAutoPassDrawAfterCardDrawn+"</AutoPassDraw>\n";
		s += "\t\t<PASSCOMBATBEGIN>"+mPassCombatBegin+"</PASSCOMBATBEGIN>\n";
		s += "\t\t<PASSCOMBATEND>"+mPassCombatEnd+"</PASSCOMBATEND>\n";
		s += "\t\t<PASSENDEND>"+mPassEndEnd+"</PASSENDEND>\n";
		s += "\t\t<PASSENDCLEANUP>"+mPassEndCleanup+"</PASSENDCLEANUP>\n";
		s += "\t\t<PASSOWNDAMAGEDSTEP>"+mPassOwnDamageStep+"</PASSOWNDAMAGEDSTEP>\n";
		s += "\t\t<PASSSECONDMAIN>"+mPassSecondMainWhenNoCombat+"</PASSSECONDMAIN>\n";
		s += "\t\t<PASSBLOCKERWHENNOBLOCKER>"+mPassBlockerWhenNoBlocker+"</PASSBLOCKERWHENNOBLOCKER>\n";
		s += "\t\t<DEBUGFILES>"+UtilityString.toXML(mDebugFiles)+"</DEBUGFILES>\n";
		s += "\t\t<DEBUGCLASSES>"+UtilityString.toXML(mDebugClasses)+"</DEBUGCLASSES>\n";
		s += "\t\t<DEBUGMETHODS>"+UtilityString.toXML(mDebugMethods)+"</DEBUGMETHODS>\n";
		s += "\t\t<DEBUGTIMING>"+mDebugTiming+"</DEBUGTIMING>\n";
		s += "\t\t<DEBUGOFF>"+mDebugOff+"</DEBUGOFF>\n";
		s += "\t\t<DEBUGFILEONLY>"+mDebugFileOnly+"</DEBUGFILEONLY>\n";
		s += "\t\t<USESCRIPTCACHEING>"+mUseScriptCaching+"</USESCRIPTCACHEING>\n";
		s += "\t\t<SOUNDVOLUMNE>"+mSoundVolumne+"</SOUNDVOLUMNE>\n";
		s += "\t\t<FIRSTTIME>"+mFirstTime+"</FIRSTTIME>\n";
		s += "\t\t<TITLEMUSIC>"+UtilityString.toXML(mTitleMusik)+"</TITLEMUSIC>\n";
		s += "\t\t<GAMEBACKIMAGEENABLED>"+mGameBackImageEnabled+"</GAMEBACKIMAGEENABLED>\n";
		s += "\t\t<IMAGEONLYFULLSCREEN>"+mImageOnlyFullscreen+"</IMAGEONLYFULLSCREEN>\n";
		s += "\t\t<GAMEBACKIMAGE>"+UtilityString.toXML(mGameBackImage)+"</GAMEBACKIMAGE>\n";
		s += "\t\t<SOUNDMAPNAME>"+UtilityString.toXML(mSoundMapName)+"</SOUNDMAPNAME>\n";
		s += "\t\t<DISABLEFILELOGS>"+mDisableFileLogs+"</DISABLEFILELOGS>\n";
		s += "\t\t<EARNMONEYPERWIN>"+mEarnMoneyPerWin+"</EARNMONEYPERWIN>\n";
		s += "\t\t<BOOSTERCOST>"+mBoosterCost+"</BOOSTERCOST>\n";
		s += "\t\t<REMEMBERLASTPLAYER>"+mRememberLastPlayer+"</REMEMBERLASTPLAYER>\n";
		s += "\t\t<SHOWTIPOFDAY>"+mShowTippOfDay+"</SHOWTIPOFDAY>\n";
		s += "\t\t<PLAYMUSIC>"+mPlayMusic+"</PLAYMUSIC>\n";
		s += "\t\t<NOPANELCHANGING>"+mNoPanelChanging+"</NOPANELCHANGING>\n";
		s += "\t\t<WARNINGTIMER>"+mWarningTimer+"</WARNINGTIMER>\n";
		s += "\t\t<ERRORTIMER>"+mErrorTimer+"</ERRORTIMER>\n";
		s += "\t\t<SICKNESSALPHA>"+mSicknessAlpha+"</SICKNESSALPHA>\n";
		s += "\t\t<DEATHALPHA>"+mDeathAlpha+"</DEATHALPHA>\n";
		s += "\t\t<UseSpaceToDraw>"+mUseSpaceToDrawInPhase1+"</UseSpaceToDraw>\n";
		s += "\t\t<AutoTapMan>"+mAutoTapMan+"</AutoTapMan>\n";
		s += "\t\t<UseManaPool>"+mUseManaPool+"</UseManaPool>\n";
		s += "\t\t<DoManaBurn>"+mDoManaBurn+"</DoManaBurn>\n";
		s += "\t\t<LegendaryRuling>"+mLegendaryRuling+"</LegendaryRuling>\n";
		s += "\t\t<HandRestriction>"+mHandRestriction+"</HandRestriction>\n";
		s += "\t\t<TargetBeforStack>"+mTargetBeforStack+"</TargetBeforStack>\n";
		s += "\t\t<ShowScoreAndPauseEachRound>"+mShowScoreAndPauseEachRound+"</ShowScoreAndPauseEachRound>\n";
		s += "\t\t<HandRestrictionCount>"+mHandRestrictionCount+"</HandRestrictionCount>\n";
		s += "\t\t<DefaultWeighting>"+UtilityString.toXML(mDefaultWeighting)+"</DefaultWeighting>\n";
		s += "\t\t<ShowDebugLogOnInfo>"+mShowDebugLogOnInfo+"</ShowDebugLogOnInfo>\n";
		s += "\t\t<DebugAutoSave>"+mDebugAutoSave+"</DebugAutoSave>\n";
		s += "\t\t<CleanNonHighScoreLeafs>"+mCleanNonHighScoreLeafs+"</CleanNonHighScoreLeafs>\n";
		s += "\t\t<NoSound>"+mNoSound+"</NoSound>\n";
		s += "\t\t<EAIFullVMtach>"+mEAIFullVMtach+"</EAIFullVMtach>\n";
		s += "\t\t<CurrentThemeName>"+UtilityString.toXML(mCurrentThemeName)+"</CurrentThemeName>\n";
		s += "\t\t<ExpandImage>"+mExpandImage+"</ExpandImage>\n";
		s += "\t\t<FairLandDistribution>"+mFairLandDistribution+"</FairLandDistribution>\n";
		s += "\t\t<FairMin>"+mFairMin+"</FairMin>\n";
		s += "\t\t<FairMax>"+mFairMax+"</FairMax>\n";
		s += "\t</ConfigurationData>\n";
		return s;
	}
	@Override public String toString()
	{
		return mName;
	}
	private static ConfigurationDataXMLHandler XMLHANDLER = new ConfigurationDataXMLHandler();
	public static ConfigurationDataXMLHandler getXMLParseHandler()
	{
		return XMLHANDLER;
	}
	public static boolean saveCollectionAsXML(String filename, Collection<ConfigurationData> col)
	{
		try
		{
			PrintWriter pw = new PrintWriter(de.malban.Global.mBaseDir+filename, "UTF-8");
			pw.print("<?xml version=\"1.0\"?>\n");
			pw.print("<AllConfigurationData>\n");
			Iterator<ConfigurationData> iter = col.iterator();
			while (iter.hasNext())
			{
				ConfigurationData item = iter.next();
				pw.print(item.exportXML());
			}
			pw.print("</AllConfigurationData>\n");
			pw.close();
		}
		catch (IOException e)
		{
			System.err.println(e.toString());
			return false;
		}
		return true;
	}
	public static HashMap<String, ConfigurationData> getHashMapFromXML(String filename)
	{
		HashMap<String, ConfigurationData> filters = new HashMap<String, ConfigurationData>();
		try
		{
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			ConfigurationDataXMLHandler h = ConfigurationData.getXMLParseHandler();
			saxParser.parse(de.malban.Global.mBaseDir+filename, h);
			filters = h.getLastHashMap();
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, e.toString() ,"ConfigurationData Load Error...",  JOptionPane.INFORMATION_MESSAGE);
		}
		return filters;
	}
}
