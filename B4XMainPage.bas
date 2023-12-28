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

Sub Class_Globals
	Public Root As B4XView, xui As XUI, Toast As BCToast
	Private dUtils As DDD
	
	Public Dialog, DialogMSGBOX As B4XDialog
	Private oClock As Clock
	
	Private pnlBG As B4XView
	
	Private pnlCalculator,pnlHome,pnlWeather,pnlConversions,pnlPhotos As B4XView
	Public oPageCurrent As Object = Null
	Private oPageConversion As pageConversions,oPagePhoto As pagePhotos,oPageTimers As pageKTimers
	Private oPageCalculator As pageCalculator,  oPageHome As pageHome, oPageWeather As pageWeather
	
	
	Private pnlMenu As B4XView
	Public lvMenu As CustomListView
	
	Private lblMenu As B4XView, btnHeaderMenu As B4XView
	Public lblHdrTxt1,lblHdrTxt2 As B4XView
	
	Private pnlHeader As B4XView
	Public imgHeader As lmB4XImageViewX
	
	Private lblSetup As B4XView
	Private lblMenuFooter As B4XView
	
	
	Private pnlTimers As B4XView
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
	#if b4j
	xui.SetDataFolder(cnst.APP_NAME)
	#end if
	Main.kvs.Initialize(xui.DefaultFolder,cnst.APP_NAME & "_settings.db3")
	themes.Init '--- set colors
	If Main.kvs.ContainsKey(cnst.SETTINGS_INSTALL_DATE) = False Then
		'--- 1st run!
		Main.kvs.Put(cnst.SETTINGS_INSTALL_DATE,DateTime.Now)
		Main.kvs.Put(cnst.SETTINGS_CURRENT_VER,cnst.APP_FILE_VERSION)
	Else
		'--- this will matter when a new version of the app is released as
		'--- settings files and others things might also need to be updated
		Dim vo As CheckVersions : vo.Initialize
		vo.CheckAndUpgrade
	End If
End Sub


'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.
'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	
	Root = Root1
	Root.LoadLayout("MainPage")
	Toast.Initialize(Root) 
	dUtils.Initialize '--- DDD desgner utils

	BuildGUI
	oClock.Initialize
	
End Sub

Private Sub BuildGUI
	
	guiHelpers.SetVisible(Array As B4XView(pnlTimers,pnlMenu,pnlWeather,pnlCalculator,pnlConversions,pnlPhotos),False)
	
	guiHelpers.SetEnableDisableColorBtnNoBoarder(Array As B4XView(btnHeaderMenu))
	
	pnlBG.SetColorAndBorder(themes.clrPanelBGround,0,xui.Color_Transparent,0)
	
	pnlMenu.SetColorAndBorder(themes.clrPanelBGround,2,themes.clrPanelBorderColor,4)
	pnlHeader.SetColorAndBorder(themes.clrTitleBarBG,0,xui.Color_Transparent,0)
	
	MainMenu.Build()
	
	Toast.pnl.Color = themes.clrTxtNormal
	Toast.DefaultTextColor = themes.clrPanelBGround
	Toast.MaxHeight = 120dip
	
	lvMenu_ItemClick(-2,"hm")
	Sleep(0)
	
End Sub

'--- hearder menu btn show menu - or not
Private Sub btnHeaderMenu_Click
	pnlMenu.SetVisibleAnimated(280, Not (pnlMenu.Visible))
	If pnlMenu.Visible Then pnlMenu.BringToFront
	
	Dim sf As StringFunctions
	
End Sub

Private Sub lvMenu_ItemClick (Index As Int, Value As Object)
	
	If Index <> -2 Then btnHeaderMenu_Click '---  toggle side menu

	'--- fire the lost focus event
	If oPageCurrent <> Null Then
		CallSub(oPageCurrent,"Lost_Focus")
	End If
	
	Select Case Value
		
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
			If oPagePhoto.IsInitialized = False Then oPagePhoto.Initialize(pnlPhotos)
			oPageCurrent = oPagePhoto
			
		Case "tm" '--- timers
			If oPageTimers.IsInitialized = False Then oPageTimers.Initialize(pnlTimers)
			oPageCurrent = oPageTimers
		
	End Select

	'--- set focus to page object
	CallSub(oPageCurrent,"Set_Focus")
	
End Sub

#if b4a
Private Sub lblSetup_Click
#Else
Private Sub lblSetup_MouseClicked (EventData As MouseEvent)
#End If

End Sub


#if b4a
Private Sub lblMenuFooter_Click
#Else
Private Sub lblMenuFooter_MouseClicked (EventData As MouseEvent)
#End If
	Dim o As dlgAbout : o.Initialize(Dialog)
	o.Show
End Sub

