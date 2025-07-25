﻿B4J=true
Group=Main
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' Adapted from OctoTC for use here - 2024
' V. 1.0 	June/13/2022
#End Region
'Static code module


Sub Process_Globals

	Private xui As XUI
	
	Public IsInit As Boolean = False
	Public MainSetupData As Map
	Public PicAlbumSetupData As Map
	Public Is1stRun As Boolean = False

	'--- android power dlg
'	Public AndroidTakeOverSleepFLAG As Boolean = False
	
	Public TimeEveningOff, TimeMorningON As Long
	
	
End Sub


Public Sub Init

	ConfigMe
	IsInit = True
	
End Sub


Private Sub ConfigMe()
		
	Dim ForceNew As Boolean = False ' DEV stuff
	
	If Main.kvs.ContainsKey(gblConst.INI_INSTALL_DATE) = False Or ForceNew Then
		
		'--- 1st run!
		Is1stRun = True
		Main.kvs.Put(gblConst.INI_INSTALL_DATE,DateTime.Now)
		Main.kvs.Put(gblConst.INI_CURRENT_VER,gblConst.APP_FILE_VERSION)
		Main.kvs.Put(gblConst.INI_WEATHER_DEFAULT_CITY,"Kherson, Ukraine")
		Main.kvs.Put(gblConst.INI_WEATHER_USE_CELSIUS,True)
		Main.kvs.Put(gblConst.INI_WEATHER_USE_METRIC,False)
		Main.kvs.Put(gblConst.INI_WEATHER_CITY_LIST,"Kherson, Ukraine;;Seattle, Wa;;Paris, France")
	
		Main.kvs.Put(gblConst.INI_TIMERS_ALARM_VOLUME,85)
		Main.kvs.Put(gblConst.INI_TIMERS_ALARM_FILE,"ktimers_beep01.ogg")
		
		'--- KEEP!!! in V3.2.0 this is  used to seed the new table and also can be used in a upgrade
		'--- the seed-init method removes it after reading it 
		Main.kvs.Put(gblConst.INI_WEB_HOME,"http://sadlogic.com")

		'--- copy lic file, not like anyone will ever read it or even care.			
		Try
			If File.Exists(xui.DefaultFolder,gblConst.LICENSE_FILE) = False Then	'--- copy Lic file
				File.Copy(File.DirAssets,gblConst.LICENSE_FILE,xui.DefaultFolder,gblConst.LICENSE_FILE)
				File.Copy(File.DirAssets,gblConst.LICENSE_FILE,File.DirDefaultExternal,gblConst.LICENSE_FILE)
			End If
		Catch
		End Try 'ignore
	
		'--- kill it, if it exists it will be rebuilt
		fileHelpers.SafeKill(xui.DefaultFolder,gblConst.FILE_MAIN_SETUP) '--- Dev
		
	Else
		
		'--- this will matter when a new version of the app is released as
		'--- settings files and others things might also need to be updated
		Dim vo As CheckVersions : vo.Initialize
		vo.CheckAndUpgrade
		
	End If
	
	kt.InitSql '--- pointer for SQL engine for kitchen timers or any other SQL work
	
	'======================================================================
	
	'fileHelpers.SafeKill(xui.DefaultFolder,gblConst.FILE_MAIN_SETUP) '--- Dev
	If File.Exists(xui.DefaultFolder,gblConst.FILE_MAIN_SETUP) = False Then
		'--- create main setup
		Dim o3 As dlgSetupMain
		o3.initialize(Null)
		o3.createdefaultfile
	End If
	
	ReadMainSetup
	CreatePhotoAlbumSetup
		
	CalcTimeScreenOnOff
	
	'======================================================================
	
End Sub	
	
Private Sub CreatePhotoAlbumSetup
	'--- added in v3.1.0
	'fileHelpers.SafeKill(xui.DefaultFolder,gblConst.FILE_PICS_SETUP) '--- Dev
	If File.Exists(xui.DefaultFolder,gblConst.FILE_PICS_SETUP) = False Then
		#if debug
		Log("Creating Photo Album setup")
		#end if
		Dim o3 As dlgSetupPics
		o3.initialize(Null)
		o3.CreateDefaultFile
	End If
End Sub
	
'=========================================================================
'====================  Get's for the Main Setup Map file =================
'=========================================================================

Public Sub CalcTimeScreenOnOff
	
	'--- calcs the times as Longs and stores in global vars
	Dim t1, t2 As Period
	t1 = MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_SCRN_CTRL_MORNING_TIME)
	t2 = MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_SCRN_CTRL_EVENING_TIME)
	
	'--- change date/time format
	Dim fmtD As String = DateTime.DateFormat,fmtT As String = DateTime.TimeFormat
	DateTime.DateFormat = "yyyy/MM/dd" : DateTime.TimeFormat = "HH:mm"
	
	TimeEveningOff = DateTime.DateTimeParse(gblConst.SCRN_ON_OFF_DUMMY_DATE,$"$2.0{t2.Hours}:$2.0{t2.Minutes}:00"$)
	TimeMorningON  = DateTime.DateTimeParse(gblConst.SCRN_ON_OFF_DUMMY_DATE,$"$2.0{t1.Hours}:$2.0{t1.Minutes}:00"$)
	
	DateTime.TimeFormat = fmtT : DateTime.DateFormat = fmtD
	
End Sub


Public Sub getWeatherIconSet() As String
	Return Main.kvs.GetDefault(gblConst.INI_WEATHER_ICONS_PATH,"cc01")
End Sub

Public Sub getScreenOffTime() As Int
	#if debug
	'Log("screen off time: " & MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_SCRN_OFF_TIME))
	#End If
	Return MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_SCRN_OFF_TIME)
End Sub

Public Sub ReadMainSetup
	'--- DO NOT USE --->	File.ReadMap Or File.WriteMap, use functions in objHelpers
	MainSetupData = objHelpers.MapFromDisk2(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP) 
End Sub

'=========================================================================

Public Sub Change_AppUpdateCheck(check As Boolean)
	'--- called from 1st run dialog
	MainSetupData.Put(gblConst.KEYS_MAIN_SETUP_SCRN_CHECK_4_UPDATES,check)
	'--- DO NOT USE	File.ReadMap Or File.WriteMap
	objHelpers.Map2Disk2(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP,MainSetupData) 
	ReadMainSetup
	If check Then 
		B4XPages.MainPage.Check4Update
	Else
		#if debug
		Log("update is off")
		#end if
	End If
End Sub

'=============================================================================

Public Sub ReadPicAlbumSetup
	'--- DO NOT USE --->	File.ReadMap Or File.WriteMap, use functions in objHelpers
	If File.Exists(xui.DefaultFolder, gblConst.FILE_PICS_SETUP) Then
		PicAlbumSetupData = objHelpers.MapFromDisk2(xui.DefaultFolder, gblConst.FILE_PICS_SETUP)
	End If
End Sub
