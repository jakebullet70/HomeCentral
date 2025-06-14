﻿B4A=true
Group=Main
ModulesStructureVersion=1
Type=StaticCode
Version=11.5
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' V. 1.Whatever		Its now Aug/2023 
' V. 1.Whatever 	June-Nov/2022
#End Region
Sub Process_Globals
		
	Private DEBUG_TEST_INSTALL As Boolean = False
	'--- Have added the '2' to the end
	
	Public Const LICENSE_FILE As String = "license.txt"
	Public Const CHECK_VERSION_DATE As String = "chk_v_dt"
	
	Public APK_FILE_INFO, APK_NAME As String
	Private Const WEB_ADDR As String = "http://sadlogic.com/homecentral/"
	If DEBUG_TEST_INSTALL Then
		APK_NAME      = WEB_ADDR & "HomeCentral_testing.apk"
		APK_FILE_INFO = WEB_ADDR & "HomeCentral_testing.txt"
	Else
		#if not (FOSS)
		'--- pre android 4.4
		APK_NAME      = WEB_ADDR & "HomeCentral.apk"
		APK_FILE_INFO = WEB_ADDR & "HomeCentral.txt"
		#else
		'--- does not include any google crap! 100% open source.
		APK_FILE_INFO = WEB_ADDR & "HomeCentral_foss.txt"
		APK_NAME      = WEB_ADDR & "HomeCentral_foss.apk"
		#end if
	End If

	Public Const APP_NAME As String = "Home Central"
	Public Const APP_DISPLAY_VERSION As String = Application.VersionName '--- what the user see's
	Public Const APP_FILE_VERSION As Int = Application.VersionCode
	'===============================================================
	
	'--- Locale crap! --- need to get these from somewhere
	Public LOCALE_DATE As String = ""
	Public LOCALE_CLOCK As String =  "EEE h:mm a"
	Public LOCALE_DATETIME As String = ""
	Public LOCALE_TIME As String = ""
	
	
	'--- KVS setting const
	Public Const INI_INSTALL_DATE As String = "instdt"
	Public Const INI_CURRENT_VER As String = "appver"
	
	Public Const INI_WEATHER As String = "WEA-"
	Public Const INI_WEATHER_DEFAULT_CITY As String = INI_WEATHER & "dtcty"
	Public Const INI_WEATHER_USE_METRIC As String = INI_WEATHER & "mtrc" :'--- MPH vs KPH
	Public Const INI_WEATHER_USE_CELSIUS As String = INI_WEATHER & "cels"
	Public Const INI_WEATHER_CITY_LIST As String = INI_WEATHER & "clist"
	Public Const INI_WEATHER_ICONS_PATH As String = INI_WEATHER & "ipth"
	
	Public Const INI_SOUND As String = "SND-"
	Public Const INI_TIMERS_ALARM_VOLUME As String = INI_SOUND & "savol"
	Public Const INI_TIMERS_ALARM_FILE As String = INI_SOUND & "calrmfle"
	
	Public Const INI_SCREEN_BRIGHTNESS_VALUE As String = "scrnbrt"
	'Public Const INI_SCREEN_TAKEOVER_POWER As String = "scrntop"
	
	'Public Const INI_THEME_COLOR As String = "themeclr" '--- selected theme color
	'Public Const INI_CUSTOM_THEME_COLORS As String = "customClrs" '--- users custom colors
	
	'---
	Public Const KEYS_MAIN_SETUP_AUTO_BOOT As String = "saboot"
	Public Const KEYS_MAIN_SETUP_SCRN_OFF_TIME As String = "pwroff"
	Public Const KEYS_MAIN_SETUP_SCRN_CTRL_MORNING_TIME As String = "pwrmt"
	Public Const KEYS_MAIN_SETUP_SCRN_CTRL_EVENING_TIME As String = "pwret"
	Public Const KEYS_MAIN_SETUP_SCRN_CTRL_ON As String = "scrnday"
	Public Const KEYS_MAIN_SETUP_SCRN_CHECK_4_UPDATES As String = "chkup"
		
	Public Const KEYS_MAIN_SETUP_PAGE_WEATHER As String = "pWthr"
	Public Const KEYS_MAIN_SETUP_PAGE_PHOTO As String = "pPhoto"
	Public Const KEYS_MAIN_SETUP_PAGE_CALC As String = "pCalc"
	Public Const KEYS_MAIN_SETUP_PAGE_CONV As String = "pConv"
	Public Const KEYS_MAIN_SETUP_PAGE_TIMERS As String = "pTmrs"
	Public Const KEYS_MAIN_SETUP_PAGE_WEB As String = "pWeb"
	Public Const KEYS_MAIN_SETUP_PAGE_THEME As String = "pTheme"
	
	Public Const INI_WEB_HOME As String = "whome"
	
	
	Public Const KEYS_PICS_SETUP_ACTIVE As String = "pc_on"
	Public Const KEYS_PICS_SETUP_TURN_ON_AFTER As String = "pc_on_tm"
	Public Const KEYS_PICS_SETUP_SECONDS_BETWEEN As String = "pc_sb"
	Public Const KEYS_PICS_SETUP_TRANSITION As String = "pc_trn"
	Public Const KEYS_PICS_SETUP_START_IN_FULLSCREEN As String = "pc_fc"
	
	
	
	'Public Const INI_TIMERS_SOUNDS As String = "tsnd"
	
	
	'-------------------------------------------------------------------
	
	'Public IS0SCREEN0OFF As Boolean = False
	
	'Free key from --->  https://www.weatherapi.com
	Public Const WeatherAPIKey As String = "b48d92cda3b045938a7174835233112"
	'Public AndroidTakeOverSleepFLAG As Boolean = False
			
	
	'--- String constants (not really...) these are left as string for multi language support
	'--- will need a refactor if multi language support is to be supported, but for now...
	
	'Public INI_CONST_SETUP_COLORS As String = "colors"
	
	'=================================================================================================
	Public Const EVENT_CLOCK_CHANGE As String = "clckch"
	Public Const EVENT_INET_ON_CONNECT As String = "inetonc"

	Public Const EVENT_WEATHER_UPDATE_FAILED As String = "wufailed"
	Public Const EVENT_WEATHER_UPDATED As String = "wudt"
	Public Const EVENT_WEATHER_BEFORE_UPDATE As String = "bwudt"

	'--- used in calc'n morning  evening time for screen on  off
	Public Const SCRN_ON_OFF_DUMMY_DATE As String = "2020/05/21"
	'=================================================================================================
	Public Const FILE_MAIN_SETUP As String = "main_settings.bin"
	Public Const FILE_PICS_SETUP As String = "pic_album_settings.bin"
	
	Public Const PIC_LIST_FILE As String = "pics.lst"
	
	Public Const FILE_AUTO_START_FLAG As String = "autostart.bin"
	'===============================================================

	
	'--- pages
	Public Const PAGE_PRINTING As String = "ppr"
	Public Const PAGE_FILES As String = "pfi"
	Public Const PAGE_MAIN As String = "MainPage"
	Public Const PAGE_MOVEMENT As String = "mve"
	Public Const PAGE_MENU As String = "mnu"
		
	'--- android pre 4 action bar	
	Public Const ACTIONBAR_OFF As Int = 1
	Public Const ACTIONBAR_ON As Int = 0
	
	'--- kitchen timer images
	Public Const TIMERS_IMG_STOP As String = "tmr_stop.png"
	Public Const TIMERS_IMG_GO As String = "tmr_go.png"
	Public Const TIMERS_IMG_PAUSE As String = "tmr_pause.png"
			
	'--- android versions		
	Public Const VOLUME_ERR As String = "Problem setting volume. Is device set to 'Do Not Disturb?'"
	Public Const API_ANDROID_4_0 As Int = 14
	Public Const API_ANDROID_4_4 As Int = 19
	Public Const API_ANDROID_4_2 As Int = 17
	
	Public Const PHOTOS_PATH As String = "hc_pics" 
	
	
End Sub
