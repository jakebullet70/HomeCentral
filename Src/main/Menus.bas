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
	'Private lvHM As CustomListView '--- menu scrollView
End Sub

Public Sub Init()
	lvSM =  B4XPages.MainPage.lvSideMenu
	'lvHM =  B4XPages.MainPage.lvHeaderMenu
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
'				iv.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(XUI.LoadBitmap(File.DirAssets,imgName),themes.clrTxtNormal)
'				iv.Tag = Text
'			End If
'		End If
'	Next
'	Return p
'End Sub

Public Sub BuildHeaderMenu(tb As ASSegmentedTab)
	
	tb.ShowSeperators = True
	tb.ImageHeight = 46dip
	tb.SelectionPanel.Color = themes.clrMenuSelected
	tb.ItemTextProperties.TextColor = themes.clrTxtNormal
	'tb.ItemTextProperties.SelectedTextColor = themes.clrTxtBright
	
	'tb.CornerRadiusBackground = tb.Base.Height/2 'make the view rounded
	'tb.CornerRadiusBackground = 10dip 'make the view rounded
	Sleep(0)
	
	tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_home.png"),"hm")
	tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_weather.png"),"wt")
	tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_timers.png"),"tm")
	tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_calc.png"),"ca")
	tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_conversions.png"),"cv")
	tb.AddTab2("",XUI.LoadBitmap(File.DirAssets,"main_menu_pics.png"),"ph")
	
	Dim NumOfItems As Int = 6
	tb.mBase.Width = (NumOfItems * 70dip) + (NumOfItems * 4dip)
	tb.Base_Resize2

End Sub


Public Sub BuildSideMenu()
	
	lvSM.Clear
	
	lvSM.GetBase.Color = XUI.Color_Transparent
	lvSM.sv.Color = XUI.Color_Transparent
	lvSM.sv.ScrollViewInnerPanel.Color = XUI.Color_Transparent
	
	lvSM.PressedColor = themes.clrTitleBarBG
	lvSM.DefaultTextBackgroundColor = XUI.Color_Transparent
	lvSM.DefaultTextColor = themes.clrTxtNormal

	lvSM.AddTextItem("plugin mnu 1","01")
	lvSM.AddTextItem("plugin mnu 2","02")
	lvSM.AddTextItem("plugin mnu 3","03")
	lvSM.AddTextItem("plugin mnu 4","04")
	lvSM.AddTextItem("plugin mnu 5","05")
	
	#if b4j
	lvSM.sv.As(ScrollPane).Style="-fx-background:transparent;-fx-background-color:transparent;"
	#End If
	
	'lv.sv.As(ScrollPane).SetVScrollVisibility("NEVER")  scrollbar?
	
End Sub

'Private Sub CreateListItemSideMenu(Text As String, imgName As String, Width As Int, Height As Int) As B4XView
'	Dim p As B4XView = XUI.CreatePanel("")
'	p.SetLayoutAnimated(0, 0, 0,Width, Height)
'	p.LoadLayout("menuItems")
'	'Note that we call DDD.CollectViewsData in CellItem designer script. This is required if we want to get views with dd.GetViewByName.
'	'dUtils.GetViewByName(p, "lblMenuText").Text = Text === errors out and only works on base b4xviews
'	For Each v As B4XView In p.GetAllViewsRecursive
'		If v.Tag Is lmB4XImageViewX Then
'			Dim iv  As lmB4XImageViewX  = v.Tag
'			If "itm" = iv.Tag Then
'				iv.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(XUI.LoadBitmap(File.DirAssets,imgName),themes.clrTxtNormal)
'			End If
'		Else if v.Tag = "txt" Then
'			v.Text = Text
'		End If
'	Next
'	Return p
'End Sub

Public Sub SetHeader(txt As String, imgName As String)
	guiHelpers.ResizeText("  " & txt,B4XPages.MainPage.btnHdrTxt1)
	'B4XPages.MainPage.imgHeader.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(XUI.LoadBitmap(File.DirAssets,imgName),themes.clrTxtNormal)
End Sub




