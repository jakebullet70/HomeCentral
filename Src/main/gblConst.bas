B4A=true
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
	Public Const INI_WEATHER_USE_METRIC As String = INI_WEATHER & "mtrc"
	Public Const INI_WEATHER_USE_CELSIUS As String = INI_WEATHER & "cels"
	Public Const INI_WEATHER_CITY_LIST As String = INI_WEATHER & "clist"
	Public Const INI_WEATHER_ICONS_PATH As String = INI_WEATHER & "ipth"
	
	Public Const INI_SOUND As String = "SND-"
	Public Const INI_SOUND_ALARM_VOLUME As String = INI_SOUND & "savol"
	Public Const INI_SOUND_ALARM_FILE As String = INI_SOUND & "calrmfle"
	
	Public Const INI_SCREEN_BRIGHTNESS_VALUE As String = "scrnbrt"
	'Public Const INI_SCREEN_TAKEOVER_POWER As String = "scrntop"
	
	Public Const INI_THEME_COLOR As String = "themeclr" '--- selected theme color
	Public Const INI_CUSTOM_THEME_COLORS As String = "customClrs" '--- users custom colors
	
	'---
	Public Const KEYS_MAIN_SETUP_AUTO_BOOT As String = "saboot"
	Public Const KEYS_MAIN_SETUP_SCRN_BLANK_TIME As String = "pwroff"
	Public Const KEYS_MAIN_SETUP_SCRN_CTRL_MORNING_TIME As String = "pwrmt"
	Public Const KEYS_MAIN_SETUP_SCRN_CTRL_EVENING_TIME As String = "pwret"
	Public Const KEYS_MAIN_SETUP_SCRN_CTRL_ON As String = "scrnday"
	
	Public Const KEYS_MAIN_SETUP_PAGE_WEATHER As String = "pWthr"
	Public Const KEYS_MAIN_SETUP_PAGE_PHOTO As String = "pPhoto"
	Public Const KEYS_MAIN_SETUP_PAGE_CALC As String = "pCalc"
	Public Const KEYS_MAIN_SETUP_PAGE_CONV As String = "pConv"
	Public Const KEYS_MAIN_SETUP_PAGE_TIMERS As String = "pTmrs"
	
	
	
	
	
	
	'-------------------------------------------------------------------
	
	Public IS0SCREEN0OFF As Boolean = False
	
	Public WeatherAPIKey As String = "b48d92cda3b045938a7174835233112"
	Public WEATHERicons As String = "cc01" '--- see puSetupWeather in old eHome - api,cc01,ms01,tv01,ww01
	'Public AndroidTakeOverSleepFLAG As Boolean = False
			
	
	'--- String constants (not really...) these are left as string for multi language support
	'--- will need a refactor if multi language support is to be supported, but for now...
	
	'Public INI_CONST_SETUP_COLORS As String = "colors"
	
	'=================================================================================================
	Public Const EVENT_CLOCK_CHANGE As String = "clckch"
	Public Const EVENT_INET_ON_CONNECT As String = "inetonc"
	
'	Public Const EVENT_WEATHER_GEO_FAILED As String = "geoBAD"
'	Public Const EVENT_WEATHER_GEO_OK As String = "geoOK"
	Public Const EVENT_WEATHER_UPDATE_FAILED As String = "wufailed"
	Public Const EVENT_WEATHER_UPDATED As String = "wudt"
	Public Const EVENT_WEATHER_BEFORE_UPDATE As String = "bwudt"



	'=================================================================================================
	Public Const FILE_MAIN_SETUP As String = "main_settings.bin"
	
	
	'===============================================================


	
	
'	'---------------------------------------------------------------------------------------------------------------------
'	'--- saved data for pref dialogs
'	Public Const ANDROID_POWER_OPTIONS_FILE As String = "power_options.map"
'	Public Const FILE_MAIN_SETUP As String = "general_options.map"
'	Public Const FILAMENT_CHANGE_FILE As String = "fil_loadunload.map"
'	'---------------------------------------------------------------------------------------------------------------------
	
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
	
	
		
	Public Const VOLUME_ERR As String = "Problem setting volume. Is device set to 'Do Not Disturb?'"
	Public Const API_ANDROID_4_0 As Int = 14
	Public Const API_ANDROID_4_4 As Int = 19
	
	
End Sub
