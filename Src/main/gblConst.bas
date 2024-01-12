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
	
	Public Const API_ANDROID_4_0 As Int = 14
	Public Const API_ANDROID_4_4 As Int = 19
		
	Public APK_FILE_INFO, APK_NAME As String
	'===============================================================
	
	Public Const APP_NAME As String = "Home Central"
	Public Const APP_DISPLAY_VERSION As String = "0.5.0" '--- what the user see's
	Public Const APP_FILE_VERSION As Int = 1
	
	'--- Locale crap! --- need to get these from somewhere
	Public LOCALE_DATE As String = ""
	Public LOCALE_CLOCK As String =  "EEE h:mm a"
	Public LOCALE_DATETIME As String = ""
	Public LOCALE_TIME As String = ""
	
	
	'--- KVS setting const
	Public Const INI_INSTALL_DATE As String = "instdt"
	Public Const INI_CURRENT_VER As String = "appver"
	
	Public Const INI_WEATHER_DEFAULT_CITY As String = "wtdtcty"
	Public Const INI_WEATHER_USE_METRIC As String = "wtmtrc"
	Public Const INI_WEATHER_USE_CELSIUS As String = "wtcels"
	Public Const INI_WEATHER_CITY_LIST As String = "wtclist"
	Public Const INI_WEATHER_ICONS_PATH As String = "wtipth"
	
	
	Public Const INI_SOUND_ALARM_VOLUME As String = "savol"
	Public Const INI_SOUND_ALARM_FILE As String = "calrmfle"
	
	Public IS0SCREEN0OFF As Boolean = False
	
	Public WeatherAPIKey As String = "b48d92cda3b045938a7174835233112 "
	Public WEATHERicons As String = "cc01" '--- see puSetupWeather in old eHome - api,cc01,ms01,tv01,ww01
			
	
	'--- String constants (not really...) these are left as string for multi language support
	'--- will need a refactor if multi language support is to be supported, but for now...
	
	'Public INI_CONST_SETUP_COLORS As String = "colors"
	'Public INI_CONST_SETUP As String = "setup"
	'Public INI_CONST_MAIN As String = "main"
	'Public INI_CONST_MENUKEYS As String = "menu"
	'Public INI_CONST_SNAPINS As String = "snapins"
	'Public INI_CONST_WEATHER As String = "weather"
	
	Public const WeatherAPIKey As String = "b48d92cda3b045938a7174835233112 "
	
	Public WEATHERicons As String = "cc01" '--- see puSetupWeather in old eHome - api,cc01,ms01,tv01,ww01
	
	'=================================================================================================
	Public Const EVENT_CLOCK_CHANGE As String = "clckch"
	Public Const EVENT_INET_ON_CONNECT As String = "inetonc"
	
	Public Const EVENT_WEATHER_GEO_FAILED As String = "geoBAD"
	Public Const EVENT_WEATHER_GEO_OK As String = "geoOK"
	Public Const EVENT_WEATHER_UPDATE_FAILED As String = "wufailed"
	Public Const EVENT_WEATHER_UPDATED As String = "wudt"
	Public Const EVENT_WEATHER_BEFORE_UPDATE As String = "bwudt"

	
	Public Const API_ANDROID_4_0 As Int = 14
	Public Const API_ANDROID_4_4 As Int = 19

	
	
	
	
	'--- Have added the '2' to the end 	
	
	Private Const WEB_ADDR As String = "http://sadlogic.com/octotouchcontroller2/"
	If DEBUG_TEST_INSTALL Then
		APK_NAME      = WEB_ADDR & "OctoTouchController_testing.apk"
		APK_FILE_INFO = WEB_ADDR & "OctoTouchController_testing.txt"
	Else
		#if not (FOSS)
		'--- pre android 4.4
		APK_NAME      = WEB_ADDR & "OctoTouchController.apk"
		APK_FILE_INFO = WEB_ADDR & "OctoTouchController.txt"
		#else
		'--- does not include any google crap! 100% open source.
		APK_FILE_INFO = WEB_ADDR & "OctoTouchController_foss.txt"
		APK_NAME      = WEB_ADDR & "OctoTouchController_foss.apk"
		#end if
	End If
	
	'===============================================================

	Public Const SELECTED_CLR_THEME As String = "themeclr" '--- selected theme color
	Public Const CUSTOM_THEME_COLORS As String = "customClrs" '--- users custom colors
	
	
'	'---------------------------------------------------------------------------------------------------------------------
'	'--- saved data for pref dialogs
'	Public Const ANDROID_POWER_OPTIONS_FILE As String = "power_options.map"
'	Public Const GENERAL_OPTIONS_FILE As String = "general_options.map"
'	Public Const FILAMENT_CHANGE_FILE As String = "fil_loadunload.map"
'	Public Const BED_MANUAL_LEVEL_FILE As String = "bed_level.map"
'	Public Const PRINTER_SETUP_FILE As String = "printer_setup.map"
'	'Public Const PSU_KLIPPER_SETUP_FILE As String = "psu_setup.map"
'	Public Const HTTP_ONOFF_SETUP_FILE As String = "onoff_setup.map"
'	Public Const GCODE_CUSTOM_SETUP_FILE As String = "gcode_setup.map"
'	Public Const BLCR_TOUCH_FILE As String = "blcr_touch_setup.map"
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
	
	
	Public Const TIMERS_IMG_STOP As String = "tmr_stop.png"
	Public Const TIMERS_IMG_GO As String = "tmr_go.png"
	Public Const TIMERS_IMG_PAUSE As String = "tmr_pause.png"

	
End Sub
