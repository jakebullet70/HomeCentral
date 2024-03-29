﻿B4J=true
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
	Public MainSetupData As Map

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
	
		fileHelpers.SafeKill(xui.DefaultFolder,gblConst.FILE_MAIN_SETUP) '--- Dev
		
	Else
		
		'--- this will matter when a new version of the app is released as
		'--- settings files and others things might also need to be updated
		Dim vo As CheckVersions : vo.Initialize
		vo.CheckAndUpgrade
		
	End If
	
	
	'======================================================================
	
	'fileHelpers.SafeKill(xui.DefaultFolder,gblConst.FILE_MAIN_SETUP) '--- Dev
	If File.Exists(xui.DefaultFolder,gblConst.FILE_MAIN_SETUP) = False Then
		Dim o3 As dlgSetupMain
		o3.initialize(Null)
		o3.createdefaultfile
	End If
	ReadMainSetup
	
	'======================================================================
	
End Sub	
	
'=========================================================================
'====================  Get's for the Main Setup Map file =================
'=========================================================================

Public Sub getScreenOffTime() As Int
	#if debug
	Log("screen off time: " & MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_SCRN_BLANK_TIME))
	#End If
	Return MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_SCRN_BLANK_TIME)
End Sub

Public Sub ReadMainSetup
	'--- DO NOT USE	File.ReadMap Or File.WriteMap
	MainSetupData = objHelpers.MapFromDisk2(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP) 
End Sub

'=========================================================================



