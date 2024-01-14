B4J=true
Group=Main
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' V. 1.0 	June/13/2022
#End Region
'Static code module


Sub Process_Globals

	Private xui As XUI
	Private Const LICENSE_FILE As String = "LICENSE.txt"
	Public IsInit As Boolean = False

	'--- android power dlg
'	Public AndroidTakeOverSleepFLAG As Boolean = False
	
	
End Sub

Public Sub Init

	ConfigMe
	IsInit = True
	
End Sub


Private Sub ConfigMe()
	
	If Main.kvs.ContainsKey(gblConst.INI_INSTALL_DATE) = False Then
		
		'--- 1st run!
		Main.kvs.Put(gblConst.INI_INSTALL_DATE,DateTime.Now)
		Main.kvs.Put(gblConst.INI_CURRENT_VER,gblConst.APP_FILE_VERSION)
		Main.kvs.Put(gblConst.INI_WEATHER_DEFAULT_CITY,"Kherson, Ukraine")
		Main.kvs.Put(gblConst.INI_WEATHER_USE_CELSIUS,True)
		Main.kvs.Put(gblConst.INI_WEATHER_USE_METRIC,False)
		Main.kvs.Put(gblConst.INI_WEATHER_CITY_LIST,"Kherson, Ukraine;;Seattle, Wa;;Paris, France")
	
		Main.kvs.Put(gblConst.INI_SOUND_ALARM_VOLUME,75)
		Main.kvs.Put(gblConst.INI_SOUND_ALARM_FILE,"ktimers_alarm05.ogg")
	
		Main.kvs.Put(gblConst.INI_THEME_COLOR,"Rose")
		
		If File.Exists(xui.DefaultFolder,LICENSE_FILE) = False Then	'--- copy Lic file
			File.Copy(File.DirAssets,LICENSE_FILE,xui.DefaultFolder,LICENSE_FILE)
		End If
	
		
	Else
		
		'--- this will matter when a new version of the app is released as
		'--- settings files and others things might also need to be updated
		Dim vo As CheckVersions : vo.Initialize
		vo.CheckAndUpgrade
		
	End If
	
	
	'======================================================================
	
	'fileHelpers.SafeKill2(xui.DefaultFolder,gblConst.GENERAL_OPTIONS_FILE) '--- Dev
	If File.Exists(xui.DefaultFolder,gblConst.GENERAL_OPTIONS_FILE) = False Then
		Dim o3 As dlgSetupMain
		o3.initialize(Null)
		o3.createdefaultfile
	End If
	'ReadGeneralCFG
	
	'======================================================================
	
End Sub	
	
'=========================================================================


'Public Sub ReadManualBedScrewLevelFLAG As Boolean
'	Dim Data As Map = File.ReadMap(xui.DefaultFolder,gblConst.BED_MANUAL_LEVEL_FILE)
'	Return Data.Get(gblConst.bedManualShow).As(Boolean)
'End Sub


Public Sub ReadGeneralCFG
	
	Dim Data As Map = File.ReadMap(xui.DefaultFolder,gblConst.GENERAL_OPTIONS_FILE)
	
'	'--- these used to come from Octoprint but now we get them locally as the camera view 
'	'--- in Octoprint might be different from your eyeball view in front of your printer
'	oc.PrinterProfileInvertedX = Data.GetDefault("axesx",False)
'	oc.PrinterProfileInvertedY = Data.GetDefault("axesy",False)
'	oc.PrinterProfileInvertedZ = Data.GetDefault("axesz",False)
'		
'	If Data.Get("logall").As(Boolean) Then
'		logPOWER_EVENTS = True
'		logFILE_EVENTS = True
'		logREQUEST_OCTO_KEY = True
'		logREST_API = True
'	Else
'		logPOWER_EVENTS = Data.Get("logpwr").As(Boolean)
'		logFILE_EVENTS = Data.Get("logfiles").As(Boolean)
'		logREQUEST_OCTO_KEY = Data.Get("logoctokey").As(Boolean)
'		logREST_API = Data.Get("logrest").As(Boolean)
'	End If
	
End Sub

Public Sub ReadAndroidPowerCFG
	
'	Dim Data As Map = File.ReadMap(xui.DefaultFolder,gblConst.ANDROID_POWER_OPTIONS_FILE)
'	
'	AndroidTakeOverSleepFLAG = Data.Get("TakePwr")
'	AndroidNotPrintingScrnOffFLAG = Data.Get("NotPrintingScrnOff")
'	AndroidNotPrintingMinTill  = Data.Get("NotPrintingMinTill")
'	AndroidPrintingScrnOffFLAG  = Data.Get("PrintingScrnOff")
'	AndroidPrintingMinTill  = Data.Get("PrintingMinTill")

End Sub




