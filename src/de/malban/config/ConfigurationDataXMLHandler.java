package de.malban.config;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.*;
import java.util.*;
public class  ConfigurationDataXMLHandler extends DefaultHandler
{
	private HashMap<String, ConfigurationData> mConfigurationData;
	private ConfigurationData mCurrentData = null;
	private String mCurrentElement = null;
	private String mStartMoney = "";
	private String mLastPlayer = "";
	private String mSetUsed = "";
	private Vector<String> mSetUseds = null;
	private String mStarterSet = "";
	private String mStarterHeapGeneratopnType = "";
	private String mScale = "";
	private String mCardWidth = "";
	private String mCardHeight = "";
	private String mFullscreenResolution = "";
	private String mFirstTimeStarting = "";
	private String mGathererBaseURL = "";
	private String mStartInFullScreen = "";
	private String mOpponentHandShown = "";
	private String mPortableDebugWindow = "";
	private String mPassActiveFirstCreatureStack = "";
	private String mPassAutoOnEmptyStack = "";
	private String mOpponentEmptyStackPass = "";
	private Vector<Boolean> mOpponentEmptyStackPasss = null;
	private String mDebugLevel = "";
	private String mAutoUntapCreatures = "";
	private String mAutoUntapLands = "";
	private String mAllowMoreThan7Cards = "";
	private String mAutoPassUpkeep = "";
	private String mSkipDamageWhenNoAttacker = "";
	private String mSkipBlockWhenNoAttacker = "";
	private String mSkipUntapWhenNothingToUntap = "";
	private String mAutoPassDrawAfterCardDrawn = "";
	private String mPassCombatBegin = "";
	private String mPassCombatEnd = "";
	private String mPassEndEnd = "";
	private String mPassEndCleanup = "";
	private String mPassOwnDamageStep = "";
	private String mPassSecondMainWhenNoCombat = "";
	private String mPassBlockerWhenNoBlocker = "";
	private String mDebugFiles = "";
	private String mDebugClasses = "";
	private String mDebugMethods = "";
	private String mDebugTiming = "";
	private String mDebugOff = "";
	private String mDebugFileOnly = "";
	private String mUseScriptCaching = "";
	private String mSoundVolumne = "";
	private String mFirstTime = "";
	private String mTitleMusik = "";
	private String mGameBackImageEnabled = "";
	private String mImageOnlyFullscreen = "";
	private String mGameBackImage = "";
	private String mSoundMapName = "";
	private String mDisableFileLogs = "";
	private String mEarnMoneyPerWin = "";
	private String mBoosterCost = "";
	private String mRememberLastPlayer = "";
	private String mShowTippOfDay = "";
	private String mPlayMusic = "";
	private String mNoPanelChanging = "";
	private String mWarningTimer = "";
	private String mErrorTimer = "";
	private String mSicknessAlpha = "";
	private String mDeathAlpha = "";
	private String mUseSpaceToDrawInPhase1 = "";
	private String mAutoTapMan = "";
	private String mUseManaPool = "";
	private String mDoManaBurn = "";
	private String mLegendaryRuling = "";
	private String mHandRestriction = "";
	private String mTargetBeforStack = "";
	private String mShowScoreAndPauseEachRound = "";
	private String mHandRestrictionCount = "";
	private String mDefaultWeighting = "";
	private String mShowDebugLogOnInfo = "";
	private String mDebugAutoSave = "";
	private String mCleanNonHighScoreLeafs = "";
	private String mNoSound = "";
	private String mEAIFullVMtach = "";
	private String mCurrentThemeName = "";
	private String mExpandImage = "";
	private String mFairLandDistribution = "";
	private String mFairMin = "";
	private String mFairMax = "";
	public HashMap<String, ConfigurationData> getLastHashMap()
	{
		return mConfigurationData;
	}
	@Override public void startDocument() throws SAXException
	{
		mCurrentData = new ConfigurationData();
		mConfigurationData = new HashMap<String, ConfigurationData>();
	}
	@Override public void endDocument () throws SAXException
	{
	}
	@Override public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException
	{
		mCurrentElement = qName;
		if (qName.equalsIgnoreCase("ConfigurationData"))
		{
			mCurrentData = new ConfigurationData();
			mStartMoney = "";
			mLastPlayer = "";
			mSetUsed = "";
			mSetUseds = new Vector<String>();
			mStarterSet = "";
			mStarterHeapGeneratopnType = "";
			mScale = "";
			mCardWidth = "";
			mCardHeight = "";
			mFullscreenResolution = "";
			mFirstTimeStarting = "";
			mGathererBaseURL = "";
			mStartInFullScreen = "";
			mOpponentHandShown = "";
			mPortableDebugWindow = "";
			mPassActiveFirstCreatureStack = "";
			mPassAutoOnEmptyStack = "";
			mOpponentEmptyStackPass = "";
			mOpponentEmptyStackPasss = new Vector<Boolean>();
			mDebugLevel = "";
			mAutoUntapCreatures = "";
			mAutoUntapLands = "";
			mAllowMoreThan7Cards = "";
			mAutoPassUpkeep = "";
			mSkipDamageWhenNoAttacker = "";
			mSkipBlockWhenNoAttacker = "";
			mSkipUntapWhenNothingToUntap = "";
			mAutoPassDrawAfterCardDrawn = "";
			mPassCombatBegin = "";
			mPassCombatEnd = "";
			mPassEndEnd = "";
			mPassEndCleanup = "";
			mPassOwnDamageStep = "";
			mPassSecondMainWhenNoCombat = "";
			mPassBlockerWhenNoBlocker = "";
			mDebugFiles = "";
			mDebugClasses = "";
			mDebugMethods = "";
			mDebugTiming = "";
			mDebugOff = "";
			mDebugFileOnly = "";
			mUseScriptCaching = "";
			mSoundVolumne = "";
			mFirstTime = "";
			mTitleMusik = "";
			mGameBackImageEnabled = "";
			mImageOnlyFullscreen = "";
			mGameBackImage = "";
			mSoundMapName = "";
			mDisableFileLogs = "";
			mEarnMoneyPerWin = "";
			mBoosterCost = "";
			mRememberLastPlayer = "";
			mShowTippOfDay = "";
			mPlayMusic = "";
			mNoPanelChanging = "";
			mWarningTimer = "";
			mErrorTimer = "";
			mSicknessAlpha = "";
			mDeathAlpha = "";
			mUseSpaceToDrawInPhase1 = "";
			mAutoTapMan = "";
			mUseManaPool = "";
			mDoManaBurn = "";
			mLegendaryRuling = "";
			mHandRestriction = "";
			mTargetBeforStack = "";
			mShowScoreAndPauseEachRound = "";
			mHandRestrictionCount = "";
			mDefaultWeighting = "";
			mShowDebugLogOnInfo = "";
			mDebugAutoSave = "";
			mCleanNonHighScoreLeafs = "";
			mNoSound = "";
			mEAIFullVMtach = "";
			mCurrentThemeName = "";
			mExpandImage = "";
			mFairLandDistribution = "";
			mFairMin = "";
			mFairMax = "";
		}
	}
	@Override public void characters(char[] ch, int start, int length)
	{
		String s = new String( ch, start, length );
		if (mCurrentElement == null) return;
		if (mCurrentElement.equalsIgnoreCase("Class")) mCurrentData.mClass += s;
		if (mCurrentElement.equalsIgnoreCase("Name")) mCurrentData.mName += s;
		if (mCurrentElement.equalsIgnoreCase("STARTMONEY")) mStartMoney += s;
		if (mCurrentElement.equalsIgnoreCase("LASTPLAYER")) mLastPlayer += s;
		if (mCurrentElement.equalsIgnoreCase("SETUSED")) mSetUsed += s;
		if (mCurrentElement.equalsIgnoreCase("STARTERSET")) mStarterSet += s;
		if (mCurrentElement.equalsIgnoreCase("STARTERHEAPGENERATIONTYP")) mStarterHeapGeneratopnType += s;
		if (mCurrentElement.equalsIgnoreCase("SCALE")) mScale += s;
		if (mCurrentElement.equalsIgnoreCase("CARDWIDTH")) mCardWidth += s;
		if (mCurrentElement.equalsIgnoreCase("CARDHEIGHT")) mCardHeight += s;
		if (mCurrentElement.equalsIgnoreCase("FULLSCREENRESOLUTION")) mFullscreenResolution += s;
		if (mCurrentElement.equalsIgnoreCase("FISTTIMESTARTING")) mFirstTimeStarting += s;
		if (mCurrentElement.equalsIgnoreCase("GATHERERBASEURL")) mGathererBaseURL += s;
		if (mCurrentElement.equalsIgnoreCase("STARTINFULLSCREEN")) mStartInFullScreen += s;
		if (mCurrentElement.equalsIgnoreCase("OPPONENTHANDSHOWN")) mOpponentHandShown += s;
		if (mCurrentElement.equalsIgnoreCase("PORTABLEDEBUGWINDOW")) mPortableDebugWindow += s;
		if (mCurrentElement.equalsIgnoreCase("PASSACTIVEFIRSTCREATURESTACK")) mPassActiveFirstCreatureStack += s;
		if (mCurrentElement.equalsIgnoreCase("PASSAUTOONEMPTYSTACK")) mPassAutoOnEmptyStack += s;
		if (mCurrentElement.equalsIgnoreCase("OPPONENTEMPTYSTACKPASS")) mOpponentEmptyStackPass += s;
		if (mCurrentElement.equalsIgnoreCase("DEBUGLEVEL")) mDebugLevel += s;
		if (mCurrentElement.equalsIgnoreCase("AUTOUNTAPCREATURES")) mAutoUntapCreatures += s;
		if (mCurrentElement.equalsIgnoreCase("AUTOUNTAPLANDS")) mAutoUntapLands += s;
		if (mCurrentElement.equalsIgnoreCase("ALLOWMORTHAN7CARDS")) mAllowMoreThan7Cards += s;
		if (mCurrentElement.equalsIgnoreCase("AUTOPASSUPKEEP")) mAutoPassUpkeep += s;
		if (mCurrentElement.equalsIgnoreCase("SKIPDAMAGEWHENNOATTACKER")) mSkipDamageWhenNoAttacker += s;
		if (mCurrentElement.equalsIgnoreCase("SKIPBLOCKWHENNOATTACKER")) mSkipBlockWhenNoAttacker += s;
		if (mCurrentElement.equalsIgnoreCase("SKIPUNTAPIFNOTHINGTOUNTAP")) mSkipUntapWhenNothingToUntap += s;
		if (mCurrentElement.equalsIgnoreCase("AutoPassDraw")) mAutoPassDrawAfterCardDrawn += s;
		if (mCurrentElement.equalsIgnoreCase("PASSCOMBATBEGIN")) mPassCombatBegin += s;
		if (mCurrentElement.equalsIgnoreCase("PASSCOMBATEND")) mPassCombatEnd += s;
		if (mCurrentElement.equalsIgnoreCase("PASSENDEND")) mPassEndEnd += s;
		if (mCurrentElement.equalsIgnoreCase("PASSENDCLEANUP")) mPassEndCleanup += s;
		if (mCurrentElement.equalsIgnoreCase("PASSOWNDAMAGEDSTEP")) mPassOwnDamageStep += s;
		if (mCurrentElement.equalsIgnoreCase("PASSSECONDMAIN")) mPassSecondMainWhenNoCombat += s;
		if (mCurrentElement.equalsIgnoreCase("PASSBLOCKERWHENNOBLOCKER")) mPassBlockerWhenNoBlocker += s;
		if (mCurrentElement.equalsIgnoreCase("DEBUGFILES")) mDebugFiles += s;
		if (mCurrentElement.equalsIgnoreCase("DEBUGCLASSES")) mDebugClasses += s;
		if (mCurrentElement.equalsIgnoreCase("DEBUGMETHODS")) mDebugMethods += s;
		if (mCurrentElement.equalsIgnoreCase("DEBUGTIMING")) mDebugTiming += s;
		if (mCurrentElement.equalsIgnoreCase("DEBUGOFF")) mDebugOff += s;
		if (mCurrentElement.equalsIgnoreCase("DEBUGFILEONLY")) mDebugFileOnly += s;
		if (mCurrentElement.equalsIgnoreCase("USESCRIPTCACHEING")) mUseScriptCaching += s;
		if (mCurrentElement.equalsIgnoreCase("SOUNDVOLUMNE")) mSoundVolumne += s;
		if (mCurrentElement.equalsIgnoreCase("FIRSTTIME")) mFirstTime += s;
		if (mCurrentElement.equalsIgnoreCase("TITLEMUSIC")) mTitleMusik += s;
		if (mCurrentElement.equalsIgnoreCase("GAMEBACKIMAGEENABLED")) mGameBackImageEnabled += s;
		if (mCurrentElement.equalsIgnoreCase("IMAGEONLYFULLSCREEN")) mImageOnlyFullscreen += s;
		if (mCurrentElement.equalsIgnoreCase("GAMEBACKIMAGE")) mGameBackImage += s;
		if (mCurrentElement.equalsIgnoreCase("SOUNDMAPNAME")) mSoundMapName += s;
		if (mCurrentElement.equalsIgnoreCase("DISABLEFILELOGS")) mDisableFileLogs += s;
		if (mCurrentElement.equalsIgnoreCase("EARNMONEYPERWIN")) mEarnMoneyPerWin += s;
		if (mCurrentElement.equalsIgnoreCase("BOOSTERCOST")) mBoosterCost += s;
		if (mCurrentElement.equalsIgnoreCase("REMEMBERLASTPLAYER")) mRememberLastPlayer += s;
		if (mCurrentElement.equalsIgnoreCase("SHOWTIPOFDAY")) mShowTippOfDay += s;
		if (mCurrentElement.equalsIgnoreCase("PLAYMUSIC")) mPlayMusic += s;
		if (mCurrentElement.equalsIgnoreCase("NOPANELCHANGING")) mNoPanelChanging += s;
		if (mCurrentElement.equalsIgnoreCase("WARNINGTIMER")) mWarningTimer += s;
		if (mCurrentElement.equalsIgnoreCase("ERRORTIMER")) mErrorTimer += s;
		if (mCurrentElement.equalsIgnoreCase("SICKNESSALPHA")) mSicknessAlpha += s;
		if (mCurrentElement.equalsIgnoreCase("DEATHALPHA")) mDeathAlpha += s;
		if (mCurrentElement.equalsIgnoreCase("UseSpaceToDraw")) mUseSpaceToDrawInPhase1 += s;
		if (mCurrentElement.equalsIgnoreCase("AutoTapMan")) mAutoTapMan += s;
		if (mCurrentElement.equalsIgnoreCase("UseManaPool")) mUseManaPool += s;
		if (mCurrentElement.equalsIgnoreCase("DoManaBurn")) mDoManaBurn += s;
		if (mCurrentElement.equalsIgnoreCase("LegendaryRuling")) mLegendaryRuling += s;
		if (mCurrentElement.equalsIgnoreCase("HandRestriction")) mHandRestriction += s;
		if (mCurrentElement.equalsIgnoreCase("TargetBeforStack")) mTargetBeforStack += s;
		if (mCurrentElement.equalsIgnoreCase("ShowScoreAndPauseEachRound")) mShowScoreAndPauseEachRound += s;
		if (mCurrentElement.equalsIgnoreCase("HandRestrictionCount")) mHandRestrictionCount += s;
		if (mCurrentElement.equalsIgnoreCase("DefaultWeighting")) mDefaultWeighting += s;
		if (mCurrentElement.equalsIgnoreCase("ShowDebugLogOnInfo")) mShowDebugLogOnInfo += s;
		if (mCurrentElement.equalsIgnoreCase("DebugAutoSave")) mDebugAutoSave += s;
		if (mCurrentElement.equalsIgnoreCase("CleanNonHighScoreLeafs")) mCleanNonHighScoreLeafs += s;
		if (mCurrentElement.equalsIgnoreCase("NoSound")) mNoSound += s;
		if (mCurrentElement.equalsIgnoreCase("EAIFullVMtach")) mEAIFullVMtach += s;
		if (mCurrentElement.equalsIgnoreCase("CurrentThemeName")) mCurrentThemeName += s;
		if (mCurrentElement.equalsIgnoreCase("ExpandImage")) mExpandImage += s;
		if (mCurrentElement.equalsIgnoreCase("FairLandDistribution")) mFairLandDistribution += s;
		if (mCurrentElement.equalsIgnoreCase("FairMin")) mFairMin += s;
		if (mCurrentElement.equalsIgnoreCase("FairMax")) mFairMax += s;
	}
	@Override public void endElement(String uri, String localName, String qName) throws SAXException
	{
		if ("SETUSED".equalsIgnoreCase(qName))
		{
			mSetUseds.addElement(mSetUsed);
			mSetUsed="";
		}
		if ("OPPONENTEMPTYSTACKPASS".equalsIgnoreCase(qName))
		{
			try{
			mOpponentEmptyStackPasss.addElement(Boolean.parseBoolean(mOpponentEmptyStackPass));
			}catch (Throwable e){}
			mOpponentEmptyStackPass="";
		}
		if ("ConfigurationData".equalsIgnoreCase(qName))
		{
			if (mCurrentData != null)
			{
				try{
				mCurrentData.mStartMoney = Integer.parseInt(mStartMoney);
				}catch (Throwable e){}
				mStartMoney = "";
				mCurrentData.mLastPlayer = mLastPlayer;
				mLastPlayer = "";
				mSetUsed = "";
				mCurrentData.mSetUsed = mSetUseds;
				mCurrentData.mStarterSet = mStarterSet;
				mStarterSet = "";
				mCurrentData.mStarterHeapGeneratopnType = mStarterHeapGeneratopnType;
				mStarterHeapGeneratopnType = "";
				try{
				mCurrentData.mScale = Integer.parseInt(mScale);
				}catch (Throwable e){}
				mScale = "";
				try{
				mCurrentData.mCardWidth = Integer.parseInt(mCardWidth);
				}catch (Throwable e){}
				mCardWidth = "";
				try{
				mCurrentData.mCardHeight = Integer.parseInt(mCardHeight);
				}catch (Throwable e){}
				mCardHeight = "";
				mCurrentData.mFullscreenResolution = mFullscreenResolution;
				mFullscreenResolution = "";
				try{
				mCurrentData.mFirstTimeStarting = Boolean.parseBoolean(mFirstTimeStarting);
				}catch (Throwable e){}
				mFirstTimeStarting = "";
				mCurrentData.mGathererBaseURL = mGathererBaseURL;
				mGathererBaseURL = "";
				try{
				mCurrentData.mStartInFullScreen = Boolean.parseBoolean(mStartInFullScreen);
				}catch (Throwable e){}
				mStartInFullScreen = "";
				try{
				mCurrentData.mOpponentHandShown = Boolean.parseBoolean(mOpponentHandShown);
				}catch (Throwable e){}
				mOpponentHandShown = "";
				try{
				mCurrentData.mPortableDebugWindow = Boolean.parseBoolean(mPortableDebugWindow);
				}catch (Throwable e){}
				mPortableDebugWindow = "";
				try{
				mCurrentData.mPassActiveFirstCreatureStack = Boolean.parseBoolean(mPassActiveFirstCreatureStack);
				}catch (Throwable e){}
				mPassActiveFirstCreatureStack = "";
				try{
				mCurrentData.mPassAutoOnEmptyStack = Boolean.parseBoolean(mPassAutoOnEmptyStack);
				}catch (Throwable e){}
				mPassAutoOnEmptyStack = "";
				mOpponentEmptyStackPass = "";
				mCurrentData.mOpponentEmptyStackPass = mOpponentEmptyStackPasss;
				try{
				mCurrentData.mDebugLevel = Integer.parseInt(mDebugLevel);
				}catch (Throwable e){}
				mDebugLevel = "";
				try{
				mCurrentData.mAutoUntapCreatures = Boolean.parseBoolean(mAutoUntapCreatures);
				}catch (Throwable e){}
				mAutoUntapCreatures = "";
				try{
				mCurrentData.mAutoUntapLands = Boolean.parseBoolean(mAutoUntapLands);
				}catch (Throwable e){}
				mAutoUntapLands = "";
				try{
				mCurrentData.mAllowMoreThan7Cards = Boolean.parseBoolean(mAllowMoreThan7Cards);
				}catch (Throwable e){}
				mAllowMoreThan7Cards = "";
				try{
				mCurrentData.mAutoPassUpkeep = Boolean.parseBoolean(mAutoPassUpkeep);
				}catch (Throwable e){}
				mAutoPassUpkeep = "";
				try{
				mCurrentData.mSkipDamageWhenNoAttacker = Boolean.parseBoolean(mSkipDamageWhenNoAttacker);
				}catch (Throwable e){}
				mSkipDamageWhenNoAttacker = "";
				try{
				mCurrentData.mSkipBlockWhenNoAttacker = Boolean.parseBoolean(mSkipBlockWhenNoAttacker);
				}catch (Throwable e){}
				mSkipBlockWhenNoAttacker = "";
				try{
				mCurrentData.mSkipUntapWhenNothingToUntap = Boolean.parseBoolean(mSkipUntapWhenNothingToUntap);
				}catch (Throwable e){}
				mSkipUntapWhenNothingToUntap = "";
				try{
				mCurrentData.mAutoPassDrawAfterCardDrawn = Boolean.parseBoolean(mAutoPassDrawAfterCardDrawn);
				}catch (Throwable e){}
				mAutoPassDrawAfterCardDrawn = "";
				try{
				mCurrentData.mPassCombatBegin = Boolean.parseBoolean(mPassCombatBegin);
				}catch (Throwable e){}
				mPassCombatBegin = "";
				try{
				mCurrentData.mPassCombatEnd = Boolean.parseBoolean(mPassCombatEnd);
				}catch (Throwable e){}
				mPassCombatEnd = "";
				try{
				mCurrentData.mPassEndEnd = Boolean.parseBoolean(mPassEndEnd);
				}catch (Throwable e){}
				mPassEndEnd = "";
				try{
				mCurrentData.mPassEndCleanup = Boolean.parseBoolean(mPassEndCleanup);
				}catch (Throwable e){}
				mPassEndCleanup = "";
				try{
				mCurrentData.mPassOwnDamageStep = Boolean.parseBoolean(mPassOwnDamageStep);
				}catch (Throwable e){}
				mPassOwnDamageStep = "";
				try{
				mCurrentData.mPassSecondMainWhenNoCombat = Boolean.parseBoolean(mPassSecondMainWhenNoCombat);
				}catch (Throwable e){}
				mPassSecondMainWhenNoCombat = "";
				try{
				mCurrentData.mPassBlockerWhenNoBlocker = Boolean.parseBoolean(mPassBlockerWhenNoBlocker);
				}catch (Throwable e){}
				mPassBlockerWhenNoBlocker = "";
				mCurrentData.mDebugFiles = mDebugFiles;
				mDebugFiles = "";
				mCurrentData.mDebugClasses = mDebugClasses;
				mDebugClasses = "";
				mCurrentData.mDebugMethods = mDebugMethods;
				mDebugMethods = "";
				try{
				mCurrentData.mDebugTiming = Boolean.parseBoolean(mDebugTiming);
				}catch (Throwable e){}
				mDebugTiming = "";
				try{
				mCurrentData.mDebugOff = Boolean.parseBoolean(mDebugOff);
				}catch (Throwable e){}
				mDebugOff = "";
				try{
				mCurrentData.mDebugFileOnly = Boolean.parseBoolean(mDebugFileOnly);
				}catch (Throwable e){}
				mDebugFileOnly = "";
				try{
				mCurrentData.mUseScriptCaching = Boolean.parseBoolean(mUseScriptCaching);
				}catch (Throwable e){}
				mUseScriptCaching = "";
				try{
				mCurrentData.mSoundVolumne = Integer.parseInt(mSoundVolumne);
				}catch (Throwable e){}
				mSoundVolumne = "";
				try{
				mCurrentData.mFirstTime = Boolean.parseBoolean(mFirstTime);
				}catch (Throwable e){}
				mFirstTime = "";
				mCurrentData.mTitleMusik = mTitleMusik;
				mTitleMusik = "";
				try{
				mCurrentData.mGameBackImageEnabled = Boolean.parseBoolean(mGameBackImageEnabled);
				}catch (Throwable e){}
				mGameBackImageEnabled = "";
				try{
				mCurrentData.mImageOnlyFullscreen = Boolean.parseBoolean(mImageOnlyFullscreen);
				}catch (Throwable e){}
				mImageOnlyFullscreen = "";
				mCurrentData.mGameBackImage = mGameBackImage;
				mGameBackImage = "";
				mCurrentData.mSoundMapName = mSoundMapName;
				mSoundMapName = "";
				try{
				mCurrentData.mDisableFileLogs = Boolean.parseBoolean(mDisableFileLogs);
				}catch (Throwable e){}
				mDisableFileLogs = "";
				try{
				mCurrentData.mEarnMoneyPerWin = Integer.parseInt(mEarnMoneyPerWin);
				}catch (Throwable e){}
				mEarnMoneyPerWin = "";
				try{
				mCurrentData.mBoosterCost = Integer.parseInt(mBoosterCost);
				}catch (Throwable e){}
				mBoosterCost = "";
				try{
				mCurrentData.mRememberLastPlayer = Boolean.parseBoolean(mRememberLastPlayer);
				}catch (Throwable e){}
				mRememberLastPlayer = "";
				try{
				mCurrentData.mShowTippOfDay = Boolean.parseBoolean(mShowTippOfDay);
				}catch (Throwable e){}
				mShowTippOfDay = "";
				try{
				mCurrentData.mPlayMusic = Boolean.parseBoolean(mPlayMusic);
				}catch (Throwable e){}
				mPlayMusic = "";
				try{
				mCurrentData.mNoPanelChanging = Boolean.parseBoolean(mNoPanelChanging);
				}catch (Throwable e){}
				mNoPanelChanging = "";
				try{
				mCurrentData.mWarningTimer = Integer.parseInt(mWarningTimer);
				}catch (Throwable e){}
				mWarningTimer = "";
				try{
				mCurrentData.mErrorTimer = Integer.parseInt(mErrorTimer);
				}catch (Throwable e){}
				mErrorTimer = "";
				try{
				mCurrentData.mSicknessAlpha = Integer.parseInt(mSicknessAlpha);
				}catch (Throwable e){}
				mSicknessAlpha = "";
				try{
				mCurrentData.mDeathAlpha = Integer.parseInt(mDeathAlpha);
				}catch (Throwable e){}
				mDeathAlpha = "";
				try{
				mCurrentData.mUseSpaceToDrawInPhase1 = Boolean.parseBoolean(mUseSpaceToDrawInPhase1);
				}catch (Throwable e){}
				mUseSpaceToDrawInPhase1 = "";
				try{
				mCurrentData.mAutoTapMan = Boolean.parseBoolean(mAutoTapMan);
				}catch (Throwable e){}
				mAutoTapMan = "";
				try{
				mCurrentData.mUseManaPool = Boolean.parseBoolean(mUseManaPool);
				}catch (Throwable e){}
				mUseManaPool = "";
				try{
				mCurrentData.mDoManaBurn = Boolean.parseBoolean(mDoManaBurn);
				}catch (Throwable e){}
				mDoManaBurn = "";
				try{
				mCurrentData.mLegendaryRuling = Boolean.parseBoolean(mLegendaryRuling);
				}catch (Throwable e){}
				mLegendaryRuling = "";
				try{
				mCurrentData.mHandRestriction = Integer.parseInt(mHandRestriction);
				}catch (Throwable e){}
				mHandRestriction = "";
				try{
				mCurrentData.mTargetBeforStack = Boolean.parseBoolean(mTargetBeforStack);
				}catch (Throwable e){}
				mTargetBeforStack = "";
				try{
				mCurrentData.mShowScoreAndPauseEachRound = Boolean.parseBoolean(mShowScoreAndPauseEachRound);
				}catch (Throwable e){}
				mShowScoreAndPauseEachRound = "";
				try{
				mCurrentData.mHandRestrictionCount = Integer.parseInt(mHandRestrictionCount);
				}catch (Throwable e){}
				mHandRestrictionCount = "";
				mCurrentData.mDefaultWeighting = mDefaultWeighting;
				mDefaultWeighting = "";
				try{
				mCurrentData.mShowDebugLogOnInfo = Boolean.parseBoolean(mShowDebugLogOnInfo);
				}catch (Throwable e){}
				mShowDebugLogOnInfo = "";
				try{
				mCurrentData.mDebugAutoSave = Boolean.parseBoolean(mDebugAutoSave);
				}catch (Throwable e){}
				mDebugAutoSave = "";
				try{
				mCurrentData.mCleanNonHighScoreLeafs = Boolean.parseBoolean(mCleanNonHighScoreLeafs);
				}catch (Throwable e){}
				mCleanNonHighScoreLeafs = "";
				try{
				mCurrentData.mNoSound = Boolean.parseBoolean(mNoSound);
				}catch (Throwable e){}
				mNoSound = "";
				try{
				mCurrentData.mEAIFullVMtach = Boolean.parseBoolean(mEAIFullVMtach);
				}catch (Throwable e){}
				mEAIFullVMtach = "";
				mCurrentData.mCurrentThemeName = mCurrentThemeName;
				mCurrentThemeName = "";
				try{
				mCurrentData.mExpandImage = Boolean.parseBoolean(mExpandImage);
				}catch (Throwable e){}
				mExpandImage = "";
				try{
				mCurrentData.mFairLandDistribution = Boolean.parseBoolean(mFairLandDistribution);
				}catch (Throwable e){}
				mFairLandDistribution = "";
				try{
				mCurrentData.mFairMin = Integer.parseInt(mFairMin);
				}catch (Throwable e){}
				mFairMin = "";
				try{
				mCurrentData.mFairMax = Integer.parseInt(mFairMax);
				}catch (Throwable e){}
				mFairMax = "";
				mConfigurationData.put(mCurrentData.mName, mCurrentData);
				mCurrentData = null;
			}
		}
		mCurrentElement = null;
	}
}
