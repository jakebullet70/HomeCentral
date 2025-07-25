﻿B4J=true
Group=Main
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Dec/23/2023
#End Region
'Static code module
Sub Process_Globals
	Private XUI As XUI
	Private ac As Accessibility
	Private Scale As Float
End Sub

Public Sub Init()
End Sub


'Private Sub CreateListItemHdrMenu(Text As String, imgName As String, Width As Int, Height As Int) As B4XView
'	Dim p As B4XView = XUI.CreatePanel("")
'	p.SetLayoutAnimated(0, 0, 0,Width, Height)
'	p.LoadLayout("menuHdrItems")
'	'Note that we call DDD.CollectViewsData in CellItem designer script. This is required if we want to get views with dd.GetViewByName.
'	'dUtils.GetViewByName(p, "lblMenuText").Text = Text '=== errors out and only works on base b4xviews
'	For Each v As B4XView In p.GetAllViewsRecursive
'		If v.Tag Is lmB4XImageViewX Then
'			Dim iv  As lmB4XImageViewX  = v.Tag
'			If "itm" = iv.Tag Then
'				iv.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(XUI.LoadBitmap(File.DirAssets,imgName),clrTheme.txtNormal)
'				iv.Tag = Text
'			End If
'		End If
'	Next
'	Return p
'End Sub

Public Sub BuildHeaderMenu(tb As ASSegmentedTab,CallBack As Object,Event As String)
	
	tb.Clear
	tb.ShowSeperators = True
	tb.ImageHeight = 46dip
	tb.SelectionPanel.Color = clrTheme.Background2
	tb.ItemTextProperties.TextColor = clrTheme.txtNormal
	tb.ItemTextProperties.SelectedTextColor = clrTheme.txtAccent
	
	'tb.CornerRadiusBackground = tb.Base.Height/2 'make the view rounded
	'tb.CornerRadiusBackground = 10dip 'make the view rounded
	Sleep(0)

	Try
		Dim ttl As Int = 1
		tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_home.png"),"hm")
	
		If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_WEATHER) Then
			tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_weather.png"),"wt")
			ttl = ttl + 1
		End If
		If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_TIMERS) Then
			tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_timers.png"),"tm")
			ttl = ttl + 1
		End If
		If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_CALC) Then
			tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_calc.png"),"ca")
			ttl = ttl + 1
		End If
		If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_CONV) Then
			tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_conversions.png"),"cv")
			ttl = ttl + 1
		End If
		If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_PHOTO) Then
			tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_pics.png"),"ph")
			ttl = ttl + 1
		End If
		If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_WEB) Then
			tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_web.png"),"wb")
			ttl = ttl + 1
		End If
		
	Catch
		Dim a As String = "Snapin file needs to be rebuilt!!!!!!!!!!!!!!!!!!!!!"
		Log(a) ': Log(a)
		ExitApplication
	End Try
	
	tb.mBase.Width = (ttl * 70dip) + (ttl * 4dip)
	tb.Base_Resize2
	Sleep(0)
	
	'--- adjust the header text
	B4XPages.MainPage.btnHdrTxt1.Left = B4XPages.MainPage.segTabMenu.mBase.Width
	B4XPages.MainPage.btnHdrTxt1.Width = B4XPages.MainPage.pnlHeader.Width - (B4XPages.MainPage.segTabMenu.mBase.Width + 135dip)
	
End Sub


Public Sub BuildSideMenu(lstMnus As List, lstRetVals As List)
	
	Dim lvSM As CustomListView = B4XPages.MainPage.lvSideMenu
	lvSM.Clear
	
	If lstMnus.Size = 1 And lstMnus.Get(0) = "" Then 
		Return '--- no menus for this page
	End If
	
	clrTheme.SetThemeCustomListView(lvSM)
	Scale = ac.GetUserFontScale
	Dim lbl As Label : lbl.Initialize("")
	lbl.TextSize = 20 * Scale '--- scale is returned from Android Text size in setup
	If lbl.TextSize < 20 Then lbl.TextSize = 20
	
	Try
		
		For x = 0 To lstMnus.size - 1
			lbl.Text = lstMnus.Get(x)
			If lstRetVals.IsInitialized = False Then
				lvSM.AddTextItem(lbl.Text,"")
			Else
				lvSM.AddTextItem(lbl.Text,lstRetVals.get(x))
			End If
		Next
		
	Catch
		Log("BuildSideMenu-->" & LastException)
	End Try
	
	'lv.sv.As(ScrollPane).SetVScrollVisibility("NEVER")  scrollbar?
	
End Sub

Public Sub SetHeader(txt As String, imgName As String)
	guiHelpers.ResizeText("  " & txt,B4XPages.MainPage.btnHdrTxt1)
	B4XPages.MainPage.btnHdrTxt1.TextSize = B4XPages.MainPage.btnHdrTxt1.TextSize - 6
	'B4XPages.MainPage.imgHeader.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(XUI.LoadBitmap(File.DirAssets,imgName),clrTheme.txtNormal)
End Sub




