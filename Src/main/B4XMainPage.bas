﻿B4A=true
Group=Main
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Project Actions
'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=Project.zip

' Project folder: ide://run?file=%WINDIR%\SysWOW64\explorer.exe&Args=%PROJECT%

'-------------------------  Run this project in different IDE
'B4A ide://run?file=%WINDIR%\System32\cmd.exe&Args=/c&Args=start&Args=..\..\B4A\%PROJECT_NAME%.b4a
'B4i ide://run?file=%WINDIR%\System32\cmd.exe&Args=/c&Args=start&Args=..\..\B4i\%PROJECT_NAME%.b4i
'B4J ide://run?file=%WINDIR%\System32\cmd.exe&Args=/c&Args=start&Args=..\..\B4J\%PROJECT_NAME%.b4j
#end region

Sub Class_Globals
	Public Root As B4XView, xui As XUI, Toast As BCToast
	Private dUtils As DDD
	'--- globals -------
	Public DebugLog As Boolean = False
	Private PromptExitTwice As Boolean = False
	Private QuietExitNow As Short = 0
	
	Public sql As SQL
	Public ExtApps As ExternalAppCtrl
	Public isInterNetConnected As Boolean = True
	Public EventGbl As EventController
	Public tmrTimerCallSub As sadCallSubUtils
	Public PowerCtrl As PowerControl
	Public Const TAKE_OVER_POWER As Boolean = True
	
	'--- splash screen crap
	Private ivSpash As ImageView, pnlSplash As Panel,lblSplash As Label
	
	'-------------------------------------------
	Public WeatherData As clsWeatherData
	Public useMetric,useCel As Boolean
	
	Public Dialog2,Dialog,DialogMSGBOX As B4XDialog
	Public PrefDlg As sadPreferencesDialog
	
	Public oClock As Clock
	
	'--- this page - master --------------------
	Public pnlBG As B4XView
	
	Private pnlTimers,pnlCalculator,pnlHome,pnlWeather,pnlConversions,pnlPhotos,pnlWEB As B4XView
	Public oPageCurrent As Object = Null, oPageWEB As pageWEB
	Public oPageConversion As pageConversions,oPagePhoto As pagePhotos,oPageTimers As pageKTimers
	Public oPageCalculator As pageCalculator,  oPageHome As pageHome, oPageWeather As pageWeather
	'-----------------------------------------
	'Private lblSnapinText As B4XView
	'Private btnSnapinSetup As B4XView
	'Private pnlSnapinSetup As B4XView
	'-----------------------------------------
	
	'--- header crap -  menu buttons
	Public pnlHeader As B4XView
	Private imgSoundButton,imgMenuButton As lmB4XImageViewX
	Public btnHdrTxt1 As B4XView
	Public segTabMenu As ASSegmentedTab
	
	'--- side menu
	Public lvSideMenu As CustomListView
	Private pnlMenuFooter As B4XView
	Private btnAboutMe,btnScreenOff,btnSetupMaster As Button
	Public pnlSideMenu As B4XView
	Private lblMnuMenu As B4XView
	Private pnlMenuHdrSpacer2,pnlMenuHdrSpacer1 As B4XView
	
	Private pnlScrnOff,pnlSideMenuTouchOverlay As B4XView
	Public mSysScrnOff As Int = 0 '--- when the system turns off the screen
	
	Private pnlPicAlbumFullScrn As B4XView
	'Private imgPicAlbumFullScrn As sadImageSlider
	Private imgPicAlbumFullScrn As lmB4XImageViewX
	
End Sub

Public Sub Initialize
	
	Log("MainPage Init")
	'B4XPages.GetManager.LogEvents = True
	tmrTimerCallSub.Initialize
	EventGbl.Initialize
	Main.kvs.Initialize(xui.DefaultFolder,gblConst.APP_NAME & "_settings.db3")
	sql = Main.kvs.oSql '<--- pointer so we can use the SQL engine in the KVS object
	
	Log("-------------------->  Runnung  <-----------------------")
	'Main.kvs.DeleteAll '--- Dev stuff
	config.Init
	
	clrTheme.Init(config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_THEME))
	'clrTheme.Init(Main.kvs.Get(gblConst.INI_THEME_COLOR))
	
	WeatherData.Initialize
	useCel 	 	  = Main.kvs.GetDefault(gblConst.INI_WEATHER_USE_CELSIUS,True) '--- c OR f
	useMetric = Main.kvs.GetDefault(gblConst.INI_WEATHER_USE_METRIC,False) '--- MPH or KPH
	StartPowerCrap
	If ( File.Exists(xui.DefaultFolder,gblConst.FILE_AUTO_START_FLAG) ) Then
		tmrTimerCallSub.CallSubDelayedPlus(Me,"Kill_StartAtBoot_Service",60000) '--- 1 minute
	End If
	
	ExtApps.Initialize
	Check4Update
End Sub

'https://www.b4x.com/android/forum/threads/b4x-sd-customkeyboard.138438/
'https://www.b4x.com/android/forum/threads/b4x-sd-customkeyboard.138438/
'https://www.b4x.com/android/forum/threads/b4x-sd-customkeyboard.138438/
'https://www.b4x.com/android/forum/threads/b4x-sd-customkeyboard.138438/


#region PAGE EVENTS
Private Sub B4XPage_Created(Root1 As B4XView)
	
	Root = Root1
	Root.LoadLayout("MainPage")
	Toast.Initialize(Root) 
	dUtils.Initialize '--- DDD desgner utils
	
	LoadSplash	
	oClock.Initialize
	
	BuildGUI
	If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_PHOTO).As(Boolean) And File.Exists(xui.DefaultFolder,gblConst.PIC_LIST_FILE) Then
		config.ReadPicAlbumSetup
	End If
	CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_OFF)
	
	#if debug
	B4XPages.MainPage.DebugLog = True
	#End If
	
	If config.Is1stRun Then 
		CallSubDelayed(Me,"Show_1stRun")
	Else
		tmrTimerCallSub.CallSubDelayedPlus(Me,"ShowVer",4000)
	End If
	
End Sub

Private Sub CheckForVisibleDialogsAndClose() As Boolean
	If PrefDlg.IsInitialized And PrefDlg.Dialog.Visible Then
		PrefDlg.Dialog.Close(xui.DialogResponse_Cancel) : 	Return True
	End If
	If Dialog.IsInitialized And Dialog.Visible Then
		Dialog.Close(xui.DialogResponse_Cancel) : 			Return True
	End If
	If Dialog2.IsInitialized And Dialog2.Visible Then
		Dialog2.Close(xui.DialogResponse_Cancel) : 			Return True
	End If
	If DialogMSGBOX.IsInitialized And DialogMSGBOX.Visible Then
		DialogMSGBOX.Close(xui.DialogResponse_Cancel) : 	Return True
	End If
	Return False
End Sub



Private Sub B4XPage_CloseRequest As ResumableSub
	Log("B4XPage_CloseRequest")
	If CheckForVisibleDialogsAndClose = True Then
		Return False
	End If
	
	If pnlSideMenu.Visible Then
		pnlSideMenu.SetVisibleAnimated(380, False)
		Return False
	End If
	
	If PromptExitTwice = False Then
		Show_Toast2("Tap again to exit",2200)
		tmrTimerCallSub.CallSubDelayedPlus(Me,"Prompt_Exit_Reset",2200)
		PromptExitTwice = True
		Return False
	End If
	
	'PowerCtrl.ReleaseLocks
	
	
	
	'--- Needed to turn on 'UserClosed' var in Main.Activity_Pause
	'--- as 'back button' should turn it on but is not
'	Main.UserCloseOverRide = True
	
	  StopAllServicesOnExit
	B4XPages.GetNativeParent(Me).Finish
	Sleep(0)
'	ExitApplication
	Log("B4XPage_CloseRequest  end")
	Return True
End Sub
#end region


Public Sub HideSplash_StartUp
	pnlSplash.Visible = False
	pnlBG.Visible = True
End Sub

Public Sub Check4Update
	#if debug
	Log("processing Check4Update flag")
	#end if
	If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_SCRN_CHECK_4_UPDATES) = True Then
		tmrTimerCallSub.CallSubDelayedPlus(Me,"Check4_Update",8000)
		#if debug
		Log("setting Check4Update call")
		#end if
	End If	
End Sub
Private Sub StopAllServicesOnExit
	Log("  StopAllServicesOnExit-Release power locks")
	PowerCtrl.ReleaseLocks
	CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_ON)
	tmrTimerCallSub.Destroy '--- should not need this but oh well...  :)
	StopService("httputils2service")
	StopService("Starter")
	
End Sub

Private Sub LoadSplash
	ivSpash.Bitmap = LoadBitmapResize(File.DirAssets, "splash.png", ivSpash.Width, ivSpash.Height,True)
	pnlBG.Visible = False
	pnlSplash.Visible = True
	#if debug
	tmrTimerCallSub.CallSubDelayedPlus(Me,"HideSplash_StartUp",1000)   '--- just a splash screen
	#else
	tmrTimerCallSub.CallSubDelayedPlus(Me,"HideSplash_StartUp",3500)   '--- just a splash screen
	#End If
End Sub

Private Sub BuildGUI
	
	guiHelpers.SetVisible(Array As B4XView(pnlWEB,pnlTimers,pnlSideMenu,pnlWeather,pnlCalculator,pnlConversions,pnlPhotos),False)
	pnlScrnOff.SetLayoutAnimated(0,0,0,100%x,100%y) '--- covers the whole screen and eats the touch when screen blanked
	pnlScrnOff.Color = Colors.ARGB(255,0,0,0) '--- scrn is black
	pnlScrnOff_Click
	pnlSideMenuTouchOverlay_show(False)
	
	guiHelpers.SkinButtonNoBorder(Array As Button(btnAboutMe,btnSetupMaster,btnHdrTxt1,btnScreenOff))
	
	guiHelpers.ResizeText("<  Screen Off  >",btnScreenOff.As(B4XView))
		
	'guiHelpers.SkinButton(Array As Button(btnScreenOff))
	pnlBG.SetColorAndBorder(clrTheme.Background,0dip,xui.Color_Transparent,0dip)
	pnlPicAlbumFullScrn.SetColorAndBorder(clrTheme.Background,0dip,xui.Color_Transparent,0dip)
	pnlMenuFooter.SetColorAndBorder(xui.Color_Transparent,0dip,xui.Color_Transparent,0dip)
	pnlSideMenu.SetColorAndBorder(clrTheme.BackgroundHeader,2dip,clrTheme.Background2,4dip)
	
	pnlMenuHdrSpacer1.SetColorAndBorder(clrTheme.Background,1dip,clrTheme.Background,3dip)
	pnlMenuHdrSpacer2.SetColorAndBorder(clrTheme.Background,1dip,clrTheme.Background,3dip)
	
	guiHelpers.SetTextColor(Array As B4XView(lblMnuMenu),clrTheme.txtNormal)
	
	Menus.Init
	Menus.BuildHeaderMenu(segTabMenu,Me,"segTabMenu")
	
	pnlHeader.SetColorAndBorder(clrTheme.BackgroundHeader,0,xui.Color_Transparent,0)
	
	imgMenuButton.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(xui.LoadBitmap(File.DirAssets,"main_menu_menu.png"),clrTheme.txtNormal)
	imgSoundButton.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(xui.LoadBitmap(File.DirAssets,"main_menu_volume.png"),clrTheme.txtNormal)
	
	pnlSideMenuTouchOverlay.Width = pnlHome.Width - pnlSideMenu.Width
	
	Toast.pnl.Color = clrTheme.txtNormal
	Toast.DefaultTextColor = clrTheme.BackgroundHeader
	Toast.MaxHeight = 120dip
	
	Sleep(0)
	segTabMenu_TabChanged(-2)
	tmrTimerCallSub.CallSubDelayedPlus(Main,"Dim_ActionBar_Off",300)
	
End Sub

'================== MAIN MENU ====================================
#region MAIN_MENU
'--- header menu btn show menu - or not?
Private Sub imgMenuButton_Click
	If pnlSideMenu.Visible = False Then
		guiHelpers.AnimateB4xView("RIGHT",pnlSideMenu)
	Else
		pnlSideMenu.SetVisibleAnimated(380, False)
	End If
	Sleep(0)
	If pnlSideMenu.Visible Then
		pnlSideMenu.BringToFront
		pnlHeader.BringToFront
		pnlSideMenuTouchOverlay_show(True)
	End If
End Sub

Private Sub Change_Pages2(value As String)
	For x = 0 To segTabMenu.Size - 1
		If segTabMenu.GetValue(x) = value Then
			segTabMenu.SelectedIndex(x,500) : '--- fires event to change page 
		End If
	Next
End Sub

Private Sub segTabMenu_TabChanged(index As Int)
	'Log("*********** segTabMenu_TabChanged **************")
	Dim value As String
	If index = -2 Then  '--- 1st run
		value = "hm"
	Else '--- normal press
		pnlSideMenu.SetVisibleAnimated(380, False) '---  toggle side menu
		value = segTabMenu.Getvalue(index)
	End If
	
	'--- fire the lost focus event
	If oPageCurrent <> Null Then
		CallSub(oPageCurrent,"Lost_Focus")
	End If
	
	Select Case value
		
		Case "cv" ' ---- conversions
			If oPageConversion.IsInitialized = False Then oPageConversion.Initialize(pnlConversions)
			oPageCurrent = oPageConversion
			
		Case "hm" '--- home
			If oPageHome.IsInitialized = False Then oPageHome.Initialize(pnlHome)
			oPageCurrent = oPageHome
			
		Case "wt" '--- weather	
			If oPageWeather.IsInitialized = False Then oPageWeather.Initialize(pnlWeather)
			oPageCurrent = oPageWeather
			
		Case "ca" '--- calculator
			If oPageCalculator.IsInitialized = False Then oPageCalculator.Initialize(pnlCalculator)
			oPageCurrent = oPageCalculator
			
		Case "ph" '--- photo album
			If oPagePhoto.IsInitialized = False Then 
				oPagePhoto.Initialize(pnlPhotos,pnlPicAlbumFullScrn,imgPicAlbumFullScrn)
			End If
			oPageCurrent = oPagePhoto
			
		Case "tm" '--- timers
			If oPageTimers.IsInitialized = False Then oPageTimers.Initialize(pnlTimers)
			oPageCurrent = oPageTimers
		
		Case "wb" '--- web
			If oPageWEB.IsInitialized = False Then oPageWEB.Initialize(pnlWEB)
			oPageCurrent = oPageWEB
		
	End Select

	'--- set focus to page object
	CallSub(oPageCurrent,"Set_Focus")
	ResetScrn_SleepCounter
	CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_OFF)
	
End Sub
#end region

'============================ MISC ===============================
#region MISC

Public Sub Show_Toast(Message As String)
	Show_Toast2(Message,2500)
End Sub
Public Sub Show_Toast2(msg As String, ms As Int)
	'--- TODO, needs to be themed!!!
	Toast.DurationMs = ms
	Toast.Show($"[TextSize=30][b][FontAwesome=0xF05A/]  ${msg}[/b][/TextSize]"$)
End Sub
Private Sub Prompt_Exit_Reset
	'--- user has to tap 'back' button twice to exit in 2 seconds
	'--- this resets the var if they do not do it in 2 seconds
	PromptExitTwice = False
	CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_OFF)
End Sub
Private Sub Prompt_Exit_Quiet
	'--- user has tapped the title button 4 times
	'--- this resets the var if they do not do it in 2.4 seconds
	QuietExitNow = 0
End Sub
Private Sub btnHdrTxt1_Click
	QuietExitNow = QuietExitNow + 1
	If QuietExitNow > 3 Then
		'B4XPages.ClosePage(Me) '--- if the pic timer is firing its still running???
		Sleep(0)
		'wait for B4XPage_CloseRequest -- FAILS
		'the B4XPage_CloseRequest is NEVER fired
		'--- this is hacky but seems to work. --------
		Sleep(0):   StopAllServicesOnExit : Sleep(0)
		B4XPages.ClosePage(Me) : Sleep(100)
		B4XPages.GetNativeParent(Me).Finish : Sleep(100)
		ExitApplication 
		'-----------------------------------------------------
'		Dim ph As Phone
'		If ph.SdkVersion > 15 Then 'android 4.1 and above
'			Dim jo As JavaObject
'			jo.InitializeContext
'			jo.RunMethod("finishAffinity", Null)
'		Else
'			B4XPages.GetNativeParent(Me).Finish
'			'ExitApplication
'		End If
		Return
	End If
	If tmrTimerCallSub.Exists(Me,"Prompt_Exit_Quiet") = Null Then
		tmrTimerCallSub.CallSubDelayedPlus(Me,"Prompt_Exit_Quiet",2200)
	End If
End Sub
#end region

'==============================================================


Private Sub btnAboutMe_Click
	pnlSideMenu.SetVisibleAnimated(380, False)
	Dim o As dlgAbout : o.Initialize(Dialog)
	o.Show
End Sub

Private Sub Show_1stRun
	Dim o As dlg1stRun : o.Initialize(Dialog) :	o.Show
End Sub


Private Sub imgSoundButton_Click
	
	Try
		If oPageCurrent <> oPageTimers Then
			guiHelpers.Show_toast2("System Volume",2000)
			Dim ph As Phone
			ph.SetVolume(ph.VOLUME_SYSTEM,ph.GetMaxVolume(ph.VOLUME_SYSTEM),True)
			Return
		End If
		
		'guiHelpers.Show_toast2("System Volume",2000)
		Dim o1 As dlgVolume : o1.Initialize(Dialog) '--- kitchen timers
		o1.Show("kt")
		
	Catch
		guiHelpers.Show_toast2(gblConst.VOLUME_ERR,4500)
		Log(LastException)
	End Try
End Sub


Private Sub lvSideMenu_ItemClick (Index As Int, Value As Object)
	
	pnlSideMenuTouchOverlay_show(False)
	ResetScrn_SleepCounter '--- reset the power / screen on-off
	If SubExists(oPageCurrent,"SideMenu_ItemClick") Then
		CallSubDelayed3(oPageCurrent,"SideMenu_ItemClick",Index,Value)
	End If
	
End Sub


Private Sub btnSetupMaster_Click
	
	pnlSideMenu.SetVisibleAnimated(380, False)
	'CallSub(Main,"Set_ScreenTmr") '--- reset the power / screen on-off
	
	'--- call the setup for the page
	If oPageCurrent = oPageTimers Then
		SetupMainMenu_Event("tm",Null)
		Return
	Else If oPageCurrent = oPageWeather Then
		SetupMainMenu_Event("wth",Null)
		Return
	Else If oPageCurrent = oPageWEB Then
		SetupMainMenu_Event("wb",Null)
		Return
	Else If oPageCurrent = oPagePhoto Then
		SetupMainMenu_Event("pic",Null)
		Return
	Else If oPageCurrent <> oPageHome Then
		guiHelpers.Show_toast("No setup for this page")
		pnlSideMenuTouchOverlay_show(False)
		Return
	End If

	'--- home setup
	Dim gui As guiMsgs : gui.Initialize
	Dim o1 As dlgListbox
	
	o1.Initialize("Setup Menu",Me,"SetupMainMenu_Event",Dialog)
	o1.IsMenu = True
	o1.Show(440dip,380dip,gui.BuildMainSetup())
	
End Sub

Private Sub SetupMainMenu_Event(t As String,o As Object)
	'---
	'--- call the setup for the current showed paage
	'---
	pnlSideMenuTouchOverlay_show(False)
	CallSubDelayed(Me,"ResetScrn_SleepCounter")
	Select Case t
		Case "up"
			Dim up As dlgAppUpdate : up.Initialize(Dialog) : up.Show
		Case "wth"
			Dim o1 As dlgSetupWeather : o1.Initialize(Dialog) : o1.Show
		Case "gn"
			Dim o2 As dlgSetupMain : o2.Initialize(PrefDlg) : o2.Show
		Case "wb"
			'Dim o3 As dlgTextInput  
			'o3.Initialize("Home Page","Address",B4XPages.MainPage,"save_home_web_addr") :
			'o3.txtEdit = Main.kvs.Get(gblConst.INI_WEB_HOME) & "" : o3.Show
			Dim ox As dlgSetupWeb : ox.Initialize(Dialog) : ox.Show
		Case "tm"
			Dim o4 As dlgSetupTimers : o4.Initialize(Dialog) : o4.Show
		Case "pic"
			Dim o5 As dlgSetupPics 
			o5.Initialize(PrefDlg)
			o5.Show
		Case "as"
			ExtApps.Run_AndroidSettings
		Case Else
			
	End Select
End Sub

Private Sub save_home_web_addr(txt As String)
	' --- Dim o3 As dlgTextInput <-- callback from here
	If strHelpers.IsNullOrEmpty(txt) Then Return
	Main.kvs.Put(gblConst.INI_WEB_HOME,txt)
End Sub


Public Sub Check4_Update
	
	Dim obj As dlgAppUpdate : obj.Initialize(Null)
	Wait For (obj.CheckIfNewDownloadAvail()) Complete (yes As Boolean)
	If yes Then
		guiHelpers.Show_toast2("App update available", 3600)
	End If
	
End Sub
'==============================================================
Public Sub ShowVer
	guiHelpers.Show_toast2("Version: V" & Application.VersionName,2200)
End Sub

'--------------------  kTimers stuff
Private Sub Alarm_Fired_Before_Start
	Log("Alarm_Fired_Before_Start")
	If PowerCtrl.IsScreenOff Then
		pnlScrnOff_Click
	End If
	
	'--- check if we are showing photos.
	IfPhotoShow_TurnOff
	
End Sub

Public Sub Alarm_Fired_Start(x As Int)
	Log("Alarm_Fired_Start")
	'--- alarm fired, will change to the ktimers page
	oPageTimers.AlarmStart(x)
End Sub
'-----------------------------------------

Private Sub pnlSideMenuTouchOverlay_Click
	'Log("----------------------------- > pnlSideMenuTouchOverlay_Click")
	If pnlSideMenu.Visible Then 
		pnlSideMenu.SetVisibleAnimated(380, False)
	End If
	pnlSideMenuTouchOverlay_show(False)
	CallSubDelayed(Me,"ResetScrn_SleepCounter")
End Sub

Private Sub pnlSideMenuTouchOverlay_show(show_me As Boolean)
	If show_me = True Then
		pnlSideMenuTouchOverlay.Visible = True
		pnlSideMenuTouchOverlay.As(Panel).Elevation = 8dip
		pnlSideMenuTouchOverlay.BringToFront
	Else
		pnlSideMenuTouchOverlay.Visible = False
		pnlSideMenuTouchOverlay.As(Panel).Elevation = -8dip
		pnlSideMenuTouchOverlay.SendToBack
	End If
	Sleep(0)
End Sub

Private Sub Kill_StartAtBoot_Service
	Log("StartAtBoot service killed!")
	'--- this service should be gone but its a crappy Android OS...
	'guiHelpers.Show_toast("killing startup service")
	StopService("startAtBoot")
End Sub

Public Sub TurnScreen_Dim
	PowerCtrl.DimTheScrnBySettingBrightness '--- calls the phone intent
	pnlScrnOff.Color = Colors.ARGB(128,0,0,0)
	pnlBlankScreen_show(True)
End Sub

#Region "ANDROID POWER-BRIGHTNESS-SLEEP-SCREEN_OFF SUPPORT"
Private Sub StartPowerCrap
	'Log("StartPowerCrap")
	PowerCtrl.Initialize(True)
	ResetScrn_SleepCounter
End Sub
Public Sub ResetScrn_SleepCounter
	Log("ResetScrn_SleepCounter")
	'PowerCtrl.IsScreenOff
	If pnlScrnOff.IsInitialized And pnlScrnOff.Visible = True Then
		'--- screen is off already, should never happen but...
		#if debug
		Log("=============== Already off, removing from tmrCallSub")
		#end if
		tmrTimerCallSub.ExistsRemove(Me,"TurnScreen_Off_Sys")
		If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_PHOTO).As(Boolean) Then
			tmrTimerCallSub.ExistsRemove(B4XPages.MainPage,"turn_on_pic_album")
		End If
		'tmrTimerCallSub.ExistsRemove(Me,"TurnScreen_Dim") ---  what about pic album????
		Return
	End If
	
	'Log(config.getScreenOffTime)
	
	'--- screen on/off
	If config.getScreenOffTime <> 0 Then
		Log($"tmrTimerCallSub.ExistsRemoveAdd_DelayedPlus(Me,"TurnScreen_Off_Sys",60000 * config.getScreenOffTime)"$)
		tmrTimerCallSub.ExistsRemoveAdd_DelayedPlus(Me,"TurnScreen_Off_Sys",60000 * config.getScreenOffTime)
		'tmrTimerCallSub.ExistsRemoveAdd_DelayedPlus(Me,"TurnScreen_Dim",60000 * (config.getScreenOffTime * 0.5))
	Else
		Log($"pnlScrnOff(tmrTimerCallSub.ExistsRemove(Me,"TurnScreen_Off_Sys")"$)
		tmrTimerCallSub.ExistsRemove(Me,"TurnScreen_Off_Sys")
		'tmrTimerCallSub.ExistsRemove(Me,"TurnScreen_Dim")
	End If
	
	'--- is the pic album on?
	#if debug
	Log("pic album on:" & config.PicAlbumSetupData.IsInitialized)
	#end if
	If config.PicAlbumSetupData.IsInitialized And _
						config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_PHOTO).As(Boolean) And _
						oPageCurrent <> oPagePhoto Then
						
		Log($"tmrTimerCallSub.ExistsRemoveAdd_DelayedPlus(Me,"turn_on_pic_album",60000 * ${config.PicAlbumSetupData.Get(gblConst.KEYS_PICS_SETUP_TURN_ON_AFTER)})"$)
		tmrTimerCallSub.ExistsRemoveAdd_DelayedPlus(Me,"turn_on_pic_album",60000 * _
								config.PicAlbumSetupData.Get(gblConst.KEYS_PICS_SETUP_TURN_ON_AFTER))
	Else
		
		Log($"tmrTimerCallSub.ExistsRemove(Me,"turn_on_pic_album")"$)
		tmrTimerCallSub.ExistsRemove(Me,"turn_on_pic_album")
	End If
	
	
End Sub

Public Sub turn_on_pic_album
	If oPageCurrent = oPagePhoto Then 
		Return 
	End If
	
	#if debug
	Log("===================================")
	Log("turn_on_pic_album")
	Log("====================================")
	#end if
	
	Change_Pages2("ph") '--- switch pages
	CallSubDelayed(oPagePhoto,"Start_full_scrn")
	
End Sub


Public Sub setup_on_off_scrn_event()
	If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_SCRN_CTRL_ON) = True Then
		EventGbl.Subscribe(gblConst.EVENT_CLOCK_CHANGE, Me,"ScreenOnOff_Clock_Event")
	Else
		EventGbl.Unsubscribe(gblConst.EVENT_CLOCK_CHANGE,Me)
	End If
End Sub

Private Sub Is_NightTime() As Boolean
	
	Try
		#if debug
		Log("Is_NightTime check")
		#end if
		
			
		Dim strM As String  = strHelpers.PadLeft(DateTime.GetMinute(DateTime.now).As(String),"0",2)
		Dim strH As String  = DateTime.GetHour(DateTime.now).As(String)
				
		Dim timeOn,timeOff,timeNow As Long
		
		'--- change date/time format
		Dim fmtD As String = DateTime.DateFormat,fmtT As String = DateTime.TimeFormat
		DateTime.DateFormat = "yyyy/MM/dd" : DateTime.TimeFormat = "HH:mm"
		
		'Log($"${gblConst.SCRN_ON_OFF_DUMMY_DATE} $2.0{t2.Hours}:$2.0{t2.Minutes}:00"$)
		timeNow = DateTime.DateTimeParse(gblConst.SCRN_ON_OFF_DUMMY_DATE,strH & ":" & strM & ":00")
		timeOff = config.TimeEveningOff
		timeOn  = config.TimeMorningON
		
		'--- Testing
'		timeNow = DateTime.DateTimeParse(gblConst.SCRN_ON_OFF_DUMMY_DATE,"4:01:00")
'		timeOff = DateTime.DateTimeParse(gblConst.SCRN_ON_OFF_DUMMY_DATE,"22:00:00")
'		timeOn  = DateTime.DateTimeParse(gblConst.SCRN_ON_OFF_DUMMY_DATE,"7:00:00")
		
		'--- restore date/time format
		DateTime.TimeFormat = fmtT : DateTime.DateFormat = fmtD
		
		Return dtHelpers.IsTimeBetween(timeNow,timeOff,timeOn)

		
	Catch
		LogIt.LogWrite("ScreenOnOff_Clock_Event-Parsing err: " & LastException,1)
	End Try
	Return False
	
End Sub

Public Sub ScreenOnOff_Clock_Event(ttime As Object)
	'--- wedge into the clock event so this will fire ever minute
	#if debug
	Dim Debug As Boolean = False
	If Debug Then Log("Sub ScreenOnOff_Clock_Event called")
	#end If
	
	If mSysScrnOff > 0 And mSysScrnOff = DateTime.GetDayOfMonth(DateTime.Now) Then
		#if debug
		If Debug Then Log("Screen was turned off by the system and is same day, nothing to do")
		#end if
		Return 
	End If
	
	Dim IsNightTime As Boolean = Is_NightTime
	If (IsNightTime = pnlScrnOff.Visible) Then
		#if debug
		If Debug Then Log("sub: ScreenOnOff_Clock_Event- nothing to do")
		#end if
		Return
	End If
	#if debug
	If Debug Then Log("sub: ScreenOnOff_Clock_Event- Processing")
	#end if
	If IsNightTime Then
		TurnScreen_Off : 	ResetScrn_SleepCounter
	Else
		pnlScrnOff_Click : 	'ResetScrn_SleepCounter - called in the click event
	End If
End Sub


Private Sub pnlScrnOff_Click
'	Log("-----------------------------------------------------> pnlScrnOff_Click - hide panel")
	pnlBlankScreen_show(False)
	PowerCtrl.Screen_On(TAKE_OVER_POWER) '=== This is CONST set to True
	If WeatherData.LastUpdatedAt = 1 Then
		WeatherData.Try_Weather_Update
	End If
	mSysScrnOff = 0 ' reset it
	pnlHeader.BringToFront
	ResetScrn_SleepCounter
	CallSubDelayed2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_OFF)
	
	'--- what if we are at night and the screen is off?
	If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_SCRN_CTRL_ON) = True And Is_NightTime Then
		EventGbl.Unsubscribe(gblConst.EVENT_CLOCK_CHANGE,Me)
		'--- keep screen on for 5 minutes then... restart the night time check
		tmrTimerCallSub.ExistsRemoveAdd_DelayedPlus(Me,"setup_on_off_scrn_event",60000*5)
		guiHelpers.Show_toast2("Night time screen off overide - 5 minutes",3500)
	End If
	
End Sub
Public Sub TurnScreen_Off
	Log("---------------------> TurnScreen_Off event - cover screen with panel")
	CheckForVisibleDialogsAndClose
	pnlBlankScreen_show(True)
	PowerCtrl.Screen_Off
	
	IfPhotoShow_TurnOff 
		
	CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_OFF)
End Sub
Public Sub TurnScreen_Off_Sys
	'--- event 
	Log("TurnScreen_Off_Sys")
	mSysScrnOff = DateTime.GetDayOfMonth(DateTime.Now)
	TurnScreen_Off
End Sub

Private Sub IfPhotoShow_TurnOff
	'--- if pframe then pause the pframe timer
	If oPagePhoto.IsInitialized And oPageCurrent = oPagePhoto Then
		'--- just turn it off
		'oPagePhoto.tmrPicShow.Enabled = False
		CallSub(oPagePhoto,"Stop_fullScrn") '--- if its on?
	End If
End Sub
Private Sub imgPicAlbumFullScrn_Click
	CallSub(oPagePhoto,"Stop_fullScrn")
End Sub


Private Sub btnScreenOff_Click
	'#if debug
	Log("User -> Screen_Off called")
	'#End If
	pnlSideMenu.SetVisibleAnimated(380, False)
	pnlSideMenuTouchOverlay_show(False)
	'UserTurnedOffScrn = DateTime.GetDayOfMonth(DateTime.Now)
	TurnScreen_Off
End Sub

Private Sub pnlBlankScreen_show(show_me As Boolean)
	If show_me = True Then
		pnlScrnOff.Visible = True
		pnlScrnOff.As(Panel).Elevation = 8dip
		pnlScrnOff.BringToFront
		'pnlHeader.BringToFront
	Else
		pnlScrnOff.Visible = False
		pnlScrnOff.As(Panel).Elevation = -8dip
		pnlScrnOff.SendToBack
		pnlHeader.BringToFront
	End If
	Sleep(0)
End Sub

#end region

