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
	Public isInterNetConnected As Boolean = True
	Public EventGbl As EventController
	Public tmrTimerCallSub As sadCallSubUtils
	Public PowerCtrl As PowerControl
	'-------------------------------------------
	
	Public WeatherData As clsWeatherData
	Public useMetric,useCel As Boolean
	
	Public Dialog2,Dialog,DialogMSGBOX As B4XDialog
	Public PrefDlg As sadPreferencesDialog
	
	Public oClock As Clock
	
	'--- this page - master --------------------
	Private pnlBG As B4XView
	
	Private pnlTimers,pnlCalculator,pnlHome,pnlWeather,pnlConversions,pnlPhotos As B4XView
	Public oPageCurrent As Object = Null
	Public oPageConversion As pageConversions,oPagePhoto As pagePhotos,oPageTimers As pageKTimers
	Public oPageCalculator As pageCalculator,  oPageHome As pageHome, oPageWeather As pageWeather
	'-----------------------------------------
	'Private lblSnapinText As B4XView
	'Private btnSnapinSetup As B4XView
	'Private pnlSnapinSetup As B4XView
	'-----------------------------------------
	
	'--- header crap -  menu buttons
	Private pnlHeader As B4XView
	Private imgSoundButton,imgMenuButton As lmB4XImageViewX
	Public btnHdrTxt1 As B4XView
	
	'--- side menu
	Public lvSideMenu As CustomListView
	Private pnlMenuFooter As B4XView
	Private btnSetupMaster As Button
	Private btnAboutMe As Button
	Public pnlSideMenu As B4XView
	Public segTabMenu As ASSegmentedTab
	Private lblMnuMenu As B4XView
	Private pnlMenuHdrSpacer2,pnlMenuHdrSpacer1 As B4XView
	
	Private pnlScrnOff As B4XView
End Sub

Public Sub Initialize
	
	'B4XPages.GetManager.LogEvents = True
	tmrTimerCallSub.Initialize
	EventGbl.Initialize
	Main.kvs.Initialize(xui.DefaultFolder,gblConst.APP_NAME & "_settings.db3")
	sql = Main.kvs.oSql '<--- pointer so we can use the SQL engine in the KVS object
	
	Log("-------------------->  Runnung  <-----------------------")
	'Main.kvs.DeleteAll 
	config.Init
	clrTheme.Init(Main.kvs.Get(gblConst.INI_THEME_COLOR))
	
	WeatherData.Initialize
	useCel 		= Main.kvs.GetDefault(gblConst.INI_WEATHER_USE_CELSIUS,True)
	useMetric 	= Main.kvs.GetDefault(gblConst.INI_WEATHER_USE_METRIC,False)
	StartPowerCrap
	
	
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
	oClock.Initialize
	
	BuildGUI
	CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_OFF)
	
	#if debug
	B4XPages.MainPage.DebugLog = True
	#End If
	
End Sub

Private Sub B4XPage_CloseRequest As ResumableSub
	
	'-----------------------------------------------------------------
	If PrefDlg.IsInitialized And PrefDlg.Dialog.Visible Then
		PrefDlg.Dialog.Close(xui.DialogResponse_Cancel) : 	Return False
	End If
	If Dialog.IsInitialized And Dialog.Visible Then
		Dialog.Close(xui.DialogResponse_Cancel) : 			Return False
	End If
	If Dialog2.IsInitialized And Dialog2.Visible Then
		Dialog2.Close(xui.DialogResponse_Cancel) : 			Return False
	End If
	If DialogMSGBOX.IsInitialized And DialogMSGBOX.Visible Then
		DialogMSGBOX.Close(xui.DialogResponse_Cancel) : 	Return False
	End If
	'-----------------------------------------------------------------
	
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
	
	CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_ON)
	
	'--- Needed to turn on 'UserClosed' var in Main.Activity_Pause
	'--- as 'back button' should turn it on but is not
	B4XPages.GetNativeParent(Me).Finish
	Return True
End Sub
#end region

Private Sub BuildGUI
	
	guiHelpers.SetVisible(Array As B4XView(pnlTimers,pnlSideMenu,pnlWeather,pnlCalculator,pnlConversions,pnlPhotos),False)
	pnlScrnOff.SetLayoutAnimated(0,0,0,100%x,100%y) '--- covers the whole screen and eats the touch when screen blanked
	pnlScrnOff.Color = Colors.ARGB(255,0,0,0) '--- scrn is black
	pnlScrnOff.As(Panel).Elevation = 8dip
	pnlScrnOff_Click
	
	guiHelpers.SkinButtonNoBorder(Array As Button(btnAboutMe,btnSetupMaster,btnHdrTxt1))
	
	pnlBG.SetColorAndBorder(clrTheme.Background,0dip,xui.Color_Transparent,0dip)
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
	'Log(pnlSideMenu.Left)
	'Log(pnlSideMenu.Width)
	
	If pnlSideMenu.Visible = False Then
		guiHelpers.AnimateB4xView("RIGHT",pnlSideMenu)
	Else
		pnlSideMenu.SetVisibleAnimated(380, False)
'		pnlSideMenu.SetLayoutAnimated(190, 1065dip, pnlSideMenu.top, 1065dip+216dip, pnlSideMenu.Height)
'		Sleep(190)
'		pnlSideMenu.Visible = False
'		pnlSideMenu.Left = 1065dip
'		pnlSideMenu.width = 215dip
	End If
	Sleep(0)
	If pnlSideMenu.Visible Then
		pnlSideMenu.BringToFront
		pnlHeader.BringToFront
	End If
End Sub

Private Sub Change_Pages2(value As String)
	For x = 0 To segTabMenu.Size - 1
		If segTabMenu.GetValue(x) = value Then
			segTabMenu.SelectedIndex(x,500)
		End If
	Next
End Sub

Private Sub segTabMenu_TabChanged(index As Int)
	
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
			
		Case "ph" '--- photo albumn
			If oPagePhoto.IsInitialized = False Then 
				oPagePhoto.Initialize(pnlPhotos)
			End If
			oPageCurrent = oPagePhoto
			
		Case "tm" '--- timers
			If oPageTimers.IsInitialized = False Then oPageTimers.Initialize(pnlTimers)
			oPageCurrent = oPageTimers
		
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
		tmrTimerCallSub.Destroy '--- should not need this but oh well...  :)
		B4XPages.GetNativeParent(Me).Finish
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

Private Sub imgSoundButton_Click
	Try
		If oPageCurrent <> oPageTimers Then
			Dim ph As Phone
			ph.SetVolume(ph.VOLUME_SYSTEM,ph.GetMaxVolume(ph.VOLUME_SYSTEM),True)
			Return
		End If
		
		Dim o1 As dlgVolume : o1.Initialize(Dialog) '--- kitchen timers
		o1.Show("kt")
	Catch
		guiHelpers.Show_toast2(gblConst.VOLUME_ERR,4500)
		Log(LastException)
	End Try
End Sub

Private Sub lvSideMenu_ItemClick (Index As Int, Value As Object)
	
	ResetScrn_SleepCounter '--- reset the power / screen on-off
	If SubExists(oPageCurrent,"SideMenu_ItemClick") Then
		CallSubDelayed3(oPageCurrent,"SideMenu_ItemClick",Index,Value)
	End If
	
End Sub


Private Sub btnSetupMaster_Click
	
	pnlSideMenu.SetVisibleAnimated(380, False)
	'CallSub(Main,"Set_ScreenTmr") '--- reset the power / screen on-off

	Dim gui As guiMsgs : gui.Initialize
	Dim o1 As dlgListbox
	
	o1.Initialize("Setup Menu",Me,"SetupMainMenu_Event",Dialog)
	o1.IsMenu = True
	o1.Show(440dip,380dip,gui.BuildMainSetup())
	
End Sub

Private Sub SetupMainMenu_Event(t As String,o As Object)
	Select Case t
		Case "wth"
			Dim o1 As dlgSetupWeather : o1.Initialize(Dialog) : o1.Show
		Case "gn"
			Dim o2 As dlgSetupMain : o2.Initialize(PrefDlg) : o2.Show
				
	End Select
End Sub

'--------------------  kTimers stuff
Private Sub Alarm_Fired
	Log("Alarm_Fired")
	If PowerCtrl.IsScreenOff Then
		pnlScrnOff_Click
	End If
	
	IfPhotoShow_TurnOff
	
	'''AlarmFiredPauseRadio
End Sub

Public Sub Alarm_Start(x As Int)
	'--- alarm fired, will change to the ktimers page
	oPageTimers.AlarmStart(x)
End Sub
'-----------------------------------------

#Region "ANDROID POWER-BRIGHTNESS-SLEEP SUPPORT"
Private Sub StartPowerCrap
	PowerCtrl.Initialize(True)
	ResetScrn_SleepCounter
	setup_on_off_scrn_event(True)
End Sub
Public Sub ResetScrn_SleepCounter
	tmrTimerCallSub.ExistsRemoveAdd_DelayedPlus(Me,"TurnScreen_Off",60000 * config.getScreenOffTime)
End Sub
Private Sub setup_on_off_scrn_event(DoIt As Boolean)
	If DoIt Then
		'EventGbl.Subscribe(gblConst.EVENT_CLOCK_CHANGE, Me,"event_screenOnOff_clock")
	Else
		'EventGbl.Unsubscribe(gblConst.EVENT_CLOCK_CHANGE, Me)
	End If
End Sub

Private Sub clock_event_screenOnOff
	'--- wedge into the clock event so this will fire ever minute
	
	'--- check for screen off in the evening time
	
End Sub

Private Sub pnlScrnOff_Click
	pnlScrnOff.SendToBack
	pnlScrnOff.Visible = False '--- this is the WHOLE PANEL covering the screen
	PowerCtrl.Screen_On(True)
	If WeatherData.LastUpdatedAt = 1 Then
		WeatherData.Try_Update
	End If
	ResetScrn_SleepCounter
End Sub
Public Sub TurnScreen_Off

	pnlScrnOff.Visible = True
	PowerCtrl.Screen_Off
	pnlScrnOff.BringToFront
	
	IfPhotoShow_TurnOff
	
	
	CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_OFF)
End Sub

Private Sub IfPhotoShow_TurnOff
	'--- if pframe then pause the pframe timer
	If oPagePhoto.IsInitialized And oPageCurrent = oPagePhoto Then
		'If oPagePhoto.tmrPicShow.Enabled Then
		'--- just turn it off
			oPagePhoto.tmrPicShow.Enabled = False
		'End If
	End If
End Sub

#end region

