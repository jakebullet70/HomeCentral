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
	Public Root As B4XView
	Private xui As XUI
	Private Toast As BCToast
	
	Public Dialog As B4XDialog
	Public DialogMSGBOX As B4XDialog
	
	Private oClock As Clock
	Private pnlBG As B4XView
	Private pnlCurrentPanel As B4XView
	Private pnlCalculator,pnlHome,pnlWeather,pnlConversions As B4XView
	
	Private pnlMenu As B4XView, lvMenu As CustomListView
	
	Private lblMenu As B4XView
	Private lblHdrTxt1 As B4XView
	Public lblHdrTxt2 As B4XView
	
	Private pnlHdrLineBreak As B4XView
	Private pnlHeader As B4XView
	
	
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
		CheckVersions
	End If
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("MainPage")
	Toast.Initialize(Root) '--- needs to be themed  --TODO

	BuildGUI
	oClock.Initialize
	
End Sub

Private Sub BuildGUI
	
	pnlCurrentPanel =  xui.CreatePanel("")
	pnlCurrentPanel = pnlHome	
	
	guiHelpers.SetVisible(Array As B4XView(pnlCurrentPanel,pnlMenu,pnlWeather,pnlCalculator,pnlConversions),False)
	
	pnlHdrLineBreak.SetColorAndBorder(themes.clrPanelBorderColor,0,xui.Color_Transparent,0) '--- not visible at the moment
	pnlBG.SetColorAndBorder(themes.clrPanelBGround,0,xui.Color_Transparent,0)
	
	pnlMenu.SetColorAndBorder(themes.clrPanelBGround,2,themes.clrPanelBorderColor,4)
	pnlHeader.SetColorAndBorder(themes.clrTitleBarBG,0,xui.Color_Transparent,0)
	
	lvMenu.AddTextItem("Home","hm")
	lvMenu.AddTextItem("Weather","wt")
	lvMenu.AddTextItem("Calculator","ca")
	lvMenu.AddTextItem("Conversions","cv")
	
	lvMenu.sv.ScrollViewInnerPanel.Color = xui.Color_Transparent
'	l.CustomListView1.sv.Color = xui.Color_White
'	l.CustomListView1.DefaultTextBackgroundColor = xui.Color_White
	'lvMenu.DefaultTextColor = TextColor
	
	Toast.pnl.Color = themes.clrTxtNormal
	Toast.DefaultTextColor = themes.clrPanelBGround
	Toast.MaxHeight = 120dip
	
	lvMenu_ItemClick(-2,"hm")
	Sleep(0)
	
End Sub

'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.

Private Sub Button1_Click
	Dim o As dlgAbout : o.Initialize(Dialog)
	o.Show
End Sub

Private Sub CheckVersions
	
	If cnst.APP_FILE_VERSION > Main.kvs.Get(cnst.SETTINGS_CURRENT_VER) Then
		'--- do we need to upgade settings files? new stuff?
		'--- tell user of any new features?
		Log("this is a new app version!!!")
		
		'--- now update the app version to the settings file
		Main.kvs.Put(cnst.SETTINGS_CURRENT_VER,cnst.APP_FILE_VERSION)
	End If
	
End Sub

'--- show menu - or not
Private Sub lblMenu_MouseClicked (EventData As MouseEvent)
	pnlMenu.SetVisibleAnimated(280, Not (pnlMenu.Visible))
	If pnlMenu.Visible Then pnlMenu.BringToFront
End Sub

Private Sub lvMenu_ItemClick (Index As Int, Value As Object)
	If Index <> -2 Then lblMenu_MouseClicked(Null)
	pnlCurrentPanel.SetVisibleAnimated(500, False)
	Select Case Value
		Case "cv" ' ---- conversions
			guiHelpers.ResizeText("Conversions",lblHdrTxt1)
			pnlCurrentPanel = pnlConversions
			
		Case "hm" '--- home
			guiHelpers.ResizeText("Home",lblHdrTxt1)
			pnlCurrentPanel = pnlHome
			
		Case "wt" '--- weather	
			guiHelpers.ResizeText("Weather",lblHdrTxt1)
			pnlCurrentPanel = pnlWeather
			
		Case "ca" '--- calulator
			guiHelpers.ResizeText("Calculator",lblHdrTxt1)
			pnlCurrentPanel = pnlCalculator
	End Select
	pnlCurrentPanel.SetVisibleAnimated(500, True)
End Sub



