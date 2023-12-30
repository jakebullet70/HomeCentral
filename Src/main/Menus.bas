B4J=true
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
	Private lvSM As CustomListView '--- menu scrollView
	Private lvHM As CustomListView '--- menu scrollView
End Sub

Public Sub Init()
	lvSM =  B4XPages.MainPage.lvSideMenu
	lvHM =  B4XPages.MainPage.lvHeaderMenu
End Sub

Private Sub CreateListItemSideMenu(Text As String, imgName As String, Width As Int, Height As Int) As B4XView
	Dim p As B4XView = XUI.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0,Width, Height)
	p.LoadLayout("menuItems")
	'Note that we call DDD.CollectViewsData in CellItem designer script. This is required if we want to get views with dd.GetViewByName.
	'dUtils.GetViewByName(p, "lblMenuText").Text = Text === errors out and only works on base b4xviews
	For Each v As B4XView In p.GetAllViewsRecursive
		If v.Tag Is lmB4XImageViewX Then
			Dim iv  As lmB4XImageViewX  = v.Tag
			If "itm" = iv.Tag Then
				iv.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(XUI.LoadBitmap(File.DirAssets,imgName),themes.clrTxtNormal)
			End If
		Else if v.Tag = "txt" Then
			v.Text = Text
		End If
	Next
	Return p
End Sub

Public Sub BuildHeaderMenu()
	
End Sub


Public Sub BuildSideMenu()
	
	
	lvSM.Clear
	
	
	lvSM.GetBase.Color =XUI.Color_White	' XUI.Color_Transparent
	lvSM.sv.Color = XUI.Color_White	'XUI.Color_Transparent
	lvSM.sv.ScrollViewInnerPanel.Color = XUI.Color_White	'XUI.Color_Transparent
	
	lvSM.PressedColor = themes.clrTitleBarBG
	lvSM.DefaultTextBackgroundColor = XUI.Color_Transparent
	lvSM.DefaultTextColor = themes.clrTxtNormal

	lvSM.Add(CreateListItemSideMenu(" Home","main_menu_home.png",lvSM.AsView.Width, 60dip),"hm")
	lvSM.add(CreateListItemSideMenu(" Weather","main_menu_weather.png",lvSM.AsView.Width, 60dip),"wt")
	lvSM.Add(CreateListItemSideMenu(" Timers","main_menu_timers.png",lvSM.AsView.Width, 60dip),"tm")
	lvSM.Add(CreateListItemSideMenu(" Calculator","main_menu_calc.png",lvSM.AsView.Width, 60dip),"ca")
	lvSM.Add(CreateListItemSideMenu(" Conversions","main_menu_conversions.png",lvSM.AsView.Width, 60dip),"cv")
	lvSM.Add(CreateListItemSideMenu(" Photos","main_menu_pics.png",lvSM.AsView.Width, 60dip),"ph")
	
	'lv.sv.As(ScrollPane).SetVScrollVisibility("NEVER")  scrollbar?
	
End Sub

Public Sub SetHeader(txt As String, imgName As String)
	'guiHelpers.ResizeText("  " & txt,B4XPages.MainPage.lblHdrTxt1)
	
	'B4XPages.MainPage.imgHeader.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(XUI.LoadBitmap(File.DirAssets,imgName),themes.clrTxtNormal)
End Sub




