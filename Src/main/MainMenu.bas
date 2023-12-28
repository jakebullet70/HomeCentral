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
	Private lv As CustomListView '--- menu scrollView
End Sub



Private Sub CreateListItem(Text As String, imgName As String, Width As Int, Height As Int) As B4XView
	Dim p As B4XView = XUI.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, Width, Height)
	p.LoadLayout("menuItems")
	'Note that we call DDD.CollectViewsData in CellItem designer script. This is required if we want to get views with dd.GetViewByName.
	'dUtils.GetViewByName(p, "lblMenuText").Text = Text === errors out and only works on base b4xviews
	For Each v As B4XView In p.GetAllViewsRecursive
		If v.Tag Is lmB4XImageViewX Then
			Dim bft  As lmB4XImageViewX  = v.Tag
			If "itm" = bft.Tag Then
				bft.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(XUI.LoadBitmap(File.DirAssets,imgName),themes.clrTxtNormal)
			End If
		Else if v.Tag = "txt" Then
			v.Text = Text
		End If
	Next
	Return p
End Sub



Public Sub Build()
	
	lv =  B4XPages.MainPage.lvMenu
	
	lv.Clear
	lv.sv.ScrollViewInnerPanel.Color = XUI.Color_Transparent
	'lv.sv.Color= XUI.Color_Transparent
	'lv.sv.
	
	'lv.GetBase.Color= XUI.Color_Transparent
	lv.PressedColor = themes.clrTitleBarBG
	lv.DefaultTextBackgroundColor = XUI.Color_Transparent
	lv.DefaultTextColor = themes.clrTxtNormal

	lv.Add(CreateListItem(" Home","main_menu_home.png",lv.AsView.Width, 60dip),"hm")
	lv.Add(CreateListItem(" Weather","main_menu_weather.png",lv.AsView.Width, 60dip),"wt")
	lv.Add(CreateListItem(" Timers","main_menu_timers.png",lv.AsView.Width, 60dip),"tm")
	lv.Add(CreateListItem(" Calculator","main_menu_calc.png",lv.AsView.Width, 60dip),"ca")
	lv.Add(CreateListItem(" Conversions","main_menu_conversions.png",lv.AsView.Width, 60dip),"cv")
	lv.Add(CreateListItem(" Photos","main_menu_pics.png",lv.AsView.Width, 60dip),"ph")
	
End Sub

Public Sub SetHeader(txt As String, imgName As String)
	guiHelpers.ResizeText("  " & txt,B4XPages.MainPage.lblHdrTxt1)
	B4XPages.MainPage.imgHeader.Bitmap = guiHelpers.ChangeColorBasedOnAlphaLevel(XUI.LoadBitmap(File.DirAssets,imgName),themes.clrTxtNormal)
End Sub




