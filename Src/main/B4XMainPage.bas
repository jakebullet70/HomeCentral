B4A=true
Group=Main
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=Project.zip

' Project folder: ide://run?file=%WINDIR%\SysWOW64\explorer.exe&Args=%PROJECT%

'-------------------------  Run this project in different IDE
'B4A ide://run?file=%WINDIR%\System32\cmd.exe&Args=/c&Args=start&Args=..\..\B4A\%PROJECT_NAME%.b4a
'B4i ide://run?file=%WINDIR%\System32\cmd.exe&Args=/c&Args=start&Args=..\..\B4i\%PROJECT_NAME%.b4i
'B4J ide://run?file=%WINDIR%\System32\cmd.exe&Args=/c&Args=start&Args=..\..\B4J\%PROJECT_NAME%.b4j

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
	'-------------------------------------------
	
	Public WeatherData As clsWeatherData
	Public useMetric,useCel As Boolean
	
	Public Dialog2,Dialog,DialogMSGBOX As B4XDialog
	Public oClock As Clock
	
	'--- this page - master --------------------
	Private pnlBG As B4XView
	
	Private pnlCalculator,pnlHome,pnlWeather,pnlConversions,pnlPhotos As B4XView
	Public oPageCurrent As Object = Null
	Public oPageConversion As pageConversions,oPagePhoto As pagePhotos,oPageTimers As pageKTimers
	Public oPageCalculator As pageCalculator,  oPageHome As pageHome, oPageWeather As pageWeather
	'-----------------------------------------
	Private pnlTimers As B4XView
	Private lblSnapinText As B4XView
	Private btnSnapinSetup As B4XView
	Private pnlSnapinSetup As B4XView
	'-----------------------------------------
	
	'--- header crap -  menu buttons
	Private pnlHeader As B4XView
	Private imgSoundButton,imgMenuButton As lmB4XImageViewX
	Public btnHdrTxt1 As B4XView
	
	Public lvSideMenu As CustomListView
	Private pnlMenuFooter As B4XView
	Private btnSetupMaster As Button
	Private btnAboutMe As Button
	Public pnlSideMenu As B4XView
	
	Private segTabMenu As ASSegmentedTab
	Private lblMnuMenu As B4XView
	Private pnlMenuHdrSpacer1 As B4XView
	Private pnlMenuHdrSpacer2 As B4XView
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
	tmrTimerCallSub.Initialize
	EventGbl.Initialize
	Main.kvs.Initialize(xui.DefaultFolder,gblConst.APP_NAME & "_settings.db3")
	sql = Main.kvs.oSql '<--- pointer so we can use the SQL engine in the KVS object
	clrTheme.Init(Main.kvs.GetDefault(gblConst.SELECTED_CLR_THEME,"dark-blue"))
	
	Main.kvs.DeleteAll
	
	If Main.kvs.ContainsKey(gblConst.INI_INSTALL_DATE) = False Then
		Prep1stRun  '--- 1st run!
	Else
		'--- this will matter when a new version of the app is released as
		'--- settings files and others things might also need to be updated
		Dim vo As CheckVersions : vo.Initialize
		vo.CheckAndUpgrade
	End If
	
	WeatherData.Initialize
	useCel = Main.kvs.GetDefault(gblConst.INI_WEATHER_USE_CELSIUS,True)
	useMetric = Main.kvs.GetDefault(gblConst.INI_WEATHER_USE_METRIC,False)
	
End Sub

Private Sub Prep1stRun
	Main.kvs.Put(gblConst.INI_INSTALL_DATE,DateTime.Now)
	Main.kvs.Put(gblConst.INI_CURRENT_VER,gblConst.APP_FILE_VERSION)
	Main.kvs.Put(gblConst.INI_WEATHER_DEFAULT_CITY,"Kherson, Ukraine")
	Main.kvs.Put(gblConst.INI_WEATHER_USE_CELSIUS,True)
	Main.kvs.Put(gblConst.INI_WEATHER_USE_METRIC,False)
	Main.kvs.Put(gblConst.INI_WEATHER_CITY_LIST,"Kherson, Ukraine;;Seattle, Wa;;Paris, France")
	
	Main.kvs.Put(gblConst.INI_SOUND_ALARM_VOLUME,75)
	Main.kvs.Put(gblConst.INI_SOUND_ALARM_FILE,"ktimers_alarm05.ogg")
	
End Sub

'https://www.b4x.com/android/forum/threads/b4x-sd-customkeyboard.138438/
'https://www.b4x.com/android/forum/threads/b4x-sd-customkeyboard.138438/
'https://www.b4x.com/android/forum/threads/b4x-sd-customkeyboard.138438/
'https://www.b4x.com/android/forum/threads/b4x-sd-customkeyboard.138438/


'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.
'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	
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
	
	If Dialog.IsInitialized And Dialog.Visible Then
		Dialog.Close(xui.DialogResponse_Cancel) : Return False
	End If
	If Dialog2.IsInitialized And Dialog2.Visible Then
		Dialog2.Close(xui.DialogResponse_Cancel) : Return False
	End If
	If DialogMSGBOX.IsInitialized And DialogMSGBOX.Visible Then
		DialogMSGBOX.Close(xui.DialogResponse_Cancel) : Return False
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
	
	'powerHelpers.ReleaseLocks
	
	CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_ON)
	
	'--- Needed to turn on 'UserClosed' var in Main.Activity_Pause
	'--- as 'back button' should turn it on but is not
	B4XPages.GetNativeParent(Me).Finish
	Return True
End Sub


Private Sub BuildGUI
	
	guiHelpers.SetVisible(Array As B4XView(pnlTimers,pnlSideMenu,pnlWeather,pnlCalculator,pnlConversions,pnlPhotos),False)
	
	guiHelpers.SkinButtonNoBorder(Array As Button(btnSnapinSetup,btnAboutMe,btnSetupMaster,btnHdrTxt1))
	
	pnlBG.SetColorAndBorder(clrTheme.Background,0dip,xui.Color_Transparent,0dip)
	pnlMenuFooter.SetColorAndBorder(xui.Color_Transparent,0dip,xui.Color_Transparent,0dip)
	pnlSideMenu.SetColorAndBorder(clrTheme.BackgroundHeader,2dip,clrTheme.Background2,4dip)
	
	pnlMenuHdrSpacer1.SetColorAndBorder(clrTheme.Background,1dip,clrTheme.Background,3dip)
	pnlMenuHdrSpacer2.SetColorAndBorder(clrTheme.Background,1dip,clrTheme.Background,3dip)
	
	guiHelpers.SetTextColor(Array As B4XView(lblMnuMenu),clrTheme.txtNormal)
	
	Menus.Init
	Menus.BuildHeaderMenu(segTabMenu)
	
	pnlHeader.SetColorAndBorder(clrTheme.BackgroundHeader,0,xui.Color_Transparent,0)
	
	imgMenuButton.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(xui.LoadBitmap(File.DirAssets,"main_menu_menu.png"),clrTheme.txtNormal)
	imgSoundButton.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(xui.LoadBitmap(File.DirAssets,"main_menu_volume.png"),clrTheme.txtNormal)
	
	Toast.pnl.Color = clrTheme.txtNormal
	Toast.DefaultTextColor = clrTheme.BackgroundHeader
	Toast.MaxHeight = 120dip
	
	Sleep(0)
	segTabMenu_TabChanged(-2)
	
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


Private Sub segTabMenu_TabChanged(index As Int)
	
	Dim value As String
	If index = -3 Then  '--- this is called when a ktimer fires
		value = "tm"
	Else if index = -2 Then  '--- 1st run
		value = "hm"
	Else '--- normal press
		pnlSideMenu.SetVisibleAnimated(380, False) '---  toggle side menu
		value = segTabMenu.Getvalue(index)
	End If
	CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_OFF)
	
	pnlSnapinSetup.Visible = False

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
			pnlSnapinSetup.Visible = True :	guiHelpers.ResizeText("Home Setup", lblSnapinText)
			
		Case "wt" '--- weather	
			If oPageWeather.IsInitialized = False Then oPageWeather.Initialize(pnlWeather)
			oPageCurrent = oPageWeather
			pnlSnapinSetup.Visible = True : 	guiHelpers.ResizeText("Weather Setup", lblSnapinText)
			
		Case "ca" '--- calculator
			If oPageCalculator.IsInitialized = False Then oPageCalculator.Initialize(pnlCalculator)
			oPageCurrent = oPageCalculator
			
		Case "ph" '--- photo albumn
			If oPagePhoto.IsInitialized = False Then oPagePhoto.Initialize(pnlPhotos)
			oPageCurrent = oPagePhoto
			pnlSnapinSetup.Visible = True : guiHelpers.ResizeText("Photos Setup", lblSnapinText)
			
		Case "tm" '--- timers
			If oPageTimers.IsInitialized = False Then oPageTimers.Initialize(pnlTimers)
			oPageCurrent = oPageTimers
			pnlSnapinSetup.Visible = True : guiHelpers.ResizeText("Timers Setup", lblSnapinText)
		
	End Select

	'--- set focus to page object
	CallSub(oPageCurrent,"Set_Focus")
	
End Sub
#end region

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
	'--- this resets the var if they do not do it in 2 seconds
	QuietExitNow = 0
End Sub

Private Sub btnHdrTxt1_Click
	QuietExitNow = QuietExitNow + 1
	If QuietExitNow > 3 Then
		B4XPages.ClosePage(Me)
		Return
	End If
	If tmrTimerCallSub.Exists(Me,"Prompt_Exit_Quiet") = Null Then
		tmrTimerCallSub.CallSubDelayedPlus(Me,"Prompt_Exit_Quiet",2200)
	End If
End Sub

Private Sub btnSetupMaster_Click
	pnlSideMenu.SetVisibleAnimated(380, False)
	guiHelpers.Show_toast2("TODO",3500)
End Sub

Private Sub btnAboutMe_Click
	pnlSideMenu.SetVisibleAnimated(380, False)
	Dim o As dlgAbout : o.Initialize(Dialog)
	o.Show
End Sub

Private Sub btnSnapinSetup_Click
	pnlSideMenu.SetVisibleAnimated(380, False)
	If SubExists(oPageCurrent,"Page_Setup") Then
		CallSub(oPageCurrent,"Page_Setup")
	End If
End Sub

Private Sub imgSoundButton_Click
End Sub

Private Sub lvSideMenu_ItemClick (Index As Int, Value As Object)
	CallSubDelayed3(oPageCurrent,"SideMenu_ItemClick",Index,Value)
End Sub

Private Sub Alarm_Fired
	Log("call this --->  pnlScrnOff_Click") '--- turn on screen i think
	'pnlScrnOff_Click
	'''AlarmFiredPauseRadio
End Sub

Public Sub Alarm_Start(x As Int)
	'--- alarm fired, change to the ktimers snapin
	oPageTimers.AlarmStart(x)
End Sub
