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
	Private MainForm As Form 'ignore
	#if b4j
	Public snapInHeight,snapInWidth As Int
	#end If
	
	'------------------------------------------------------------
	
	Public WeatherData As clsWeatherData
	Public useMetric,useCel As Boolean
	
	Public Dialog, DialogMSGBOX As B4XDialog
	Public oClock As Clock
	
	'--- this page - master --------------------
	Private pnlBG As B4XView
	
	Private pnlCalculator,pnlHome,pnlWeather,pnlConversions,pnlPhotos As B4XView
	Public oPageCurrent As Object = Null
	Private oPageConversion As pageConversions,oPagePhoto As pagePhotos,oPageTimers As pageKTimers
	Private oPageCalculator As pageCalculator,  oPageHome As pageHome, oPageWeather As pageWeather
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
	
	Public lvSideMenu,lvHeaderMenu As CustomListView
	Private pnlMenuFooter As B4XView
	Private btnSetupMaster As Button
	Private btnAboutMe As Button
	Private pnlSideMenu As B4XView
	
	Private segTabMenu As ASSegmentedTab
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
	#if b4j
	xui.SetDataFolder(cnst.APP_NAME)
	#end if
	Main.EventGbl.Initialize
	Main.kvs.Initialize(xui.DefaultFolder,cnst.APP_NAME & "_settings.db3")
	Main.sql = Main.kvs.oSql '<--- pointer so we can use the SQL engine in the KVS object
	themes.Init '--- set colors
	'Main.kvs.DeleteAll
	If Main.kvs.ContainsKey(cnst.INI_INSTALL_DATE) = False Then
		Prep1stRun  '--- 1st run!
	Else
		'--- this will matter when a new version of the app is released as
		'--- settings files and others things might also need to be updated
		Dim vo As CheckVersions : vo.Initialize
		vo.CheckAndUpgrade
	End If
	
	WeatherData.Initialize
	useCel = Main.kvs.GetDefault(cnst.INI_WEATHER_USE_CELSIUS,True)
	useMetric = Main.kvs.GetDefault(cnst.INI_WEATHER_USE_METRIC,False)
	
End Sub

Private Sub Prep1stRun
	Main.kvs.Put(cnst.INI_INSTALL_DATE,DateTime.Now)
	Main.kvs.Put(cnst.INI_CURRENT_VER,cnst.APP_FILE_VERSION)
	Main.kvs.Put(cnst.INI_WEATHER_DEFAULT_CITY,"Kherson, Ukraine")
	Main.kvs.Put(cnst.INI_WEATHER_USE_CELSIUS,True)
	Main.kvs.Put(cnst.INI_WEATHER_USE_METRIC,False)
	Main.kvs.Put(cnst.INI_WEATHER_CITY_LIST,"Kherson, Ukraine;;Seattle, Wa;;Paris, France")
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
	MainForm = B4XPages.GetNativeParent(Me)
	Toast.Initialize(Root) 
	dUtils.Initialize '--- DDD desgner utils
	oClock.Initialize
	
	BuildGUI
	#region RaspPI
	#if raspPiFullScrn	
	'--- needs to be checked
	'--- https://www.b4x.com/android/forum/threads/full-screen-form.130511/
	MainForm = Form1
	MainForm.SetFormStyle("TRANSPARENT")
	Dim jform As JavaObject = MainForm
	Dim jStage As JavaObject=jform.GetFieldJO("stage")
	jStage.RunMethod("setMaximized", Array(True))
	jStage.RunMethod("setAlwaysOnTop", Array(True))
	MainForm.Resizable=False
	MainForm.Show
	#end if
	#end region
	
	
	#if debug
	Main.DebugLog = True
	#End If
	
End Sub


Private Sub BuildGUI
	
	guiHelpers.SetVisible(Array As B4XView(pnlTimers,pnlSideMenu,pnlWeather,pnlCalculator,pnlConversions,pnlPhotos),False)
	
	guiHelpers.SetEnableDisableColorBtnNoBoarder(Array As B4XView(btnSnapinSetup,btnAboutMe,btnSetupMaster,btnHdrTxt1))
	
	pnlBG.SetColorAndBorder(themes.clrPanelBGround,0,xui.Color_Transparent,0)
	pnlMenuFooter.SetColorAndBorder(xui.Color_Transparent,0,xui.Color_Transparent,0)
	pnlSideMenu.SetColorAndBorder(themes.clrPanelBGround,2,themes.clrPanelBorderColor,4)
		
	Menus.Init
	Menus.BuildSideMenu()
	Menus.BuildHeaderMenu(segTabMenu)
	
	pnlHeader.SetColorAndBorder(themes.clrTitleBarBG,0,xui.Color_Transparent,0)
	imgMenuButton.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(xui.LoadBitmap(File.DirAssets,"main_menu_menu.png"),themes.clrTxtNormal)
	imgSoundButton.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(xui.LoadBitmap(File.DirAssets,"main_menu_volume.png"),themes.clrTxtNormal)
	
	Toast.pnl.Color = themes.clrTxtNormal
	Toast.DefaultTextColor = themes.clrPanelBGround
	Toast.MaxHeight = 120dip
	
	Sleep(0)
	segTabMenu_TabChanged(-2)
	
End Sub

#if b4j
Private Sub B4XPage_Resize (Width As Int, Height As Int)
	pnlBG.Width =  Width : snapInWidth =  Width
	pnlBG.Height = Height : snapInHeight =  Height - pnlHeader.Height
		
	If Dialog.IsInitialized And Dialog.Visible Then Dialog.Resize(Width, Height)
	
	If SubExists(oPageCurrent,"Resize_Me") Then  
		Sleep(0) 	'--- this is the size of the snapin page (full page - header)
		CallSubDelayed3(oPageCurrent,"Resize_Me",snapInWidth , snapInHeight)
	End If
	
End Sub
#end if

'================== MAIN MENU ====================================
#region MAIN_MENU
'--- header menu btn show menu - or not?
Private Sub imgMenuButton_MouseClicked(EventData As MouseEvent)
	pnlSideMenu.SetVisibleAnimated(380, Not (pnlSideMenu.Visible))
	If pnlSideMenu.Visible Then
		pnlSideMenu.BringToFront
		pnlHeader.BringToFront
	End If
End Sub

Private Sub imgSoundButton_MouseClicked(EventData As MouseEvent)	
End Sub

Private Sub segTabMenu_TabChanged(index As Int)
	
	Dim value As String
	If index <> -2 Then 
		pnlSideMenu.SetVisibleAnimated(380, False) '---  toggle side menu
		value = segTabMenu.Getvalue(index)
	Else
		value = "hm"
	End If
	
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
	Toast.Show($"[TextSize=24][b][FontAwesome=0xF05A/]  ${msg}[/b][/TextSize]"$)
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






	