B4J=true
Group=Main
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' Adapted from OctoTC for use here - 2024
' V. 1.0 	June/7/2022
#End Region
'Static code module
Sub Process_Globals
	Private xui As XUI
	Private Const mModule As String = "clrTheme" 'ignore
	
	Type tthemecolors (bg, bgheader, bgmenu, txtNormal, txtacc,disabled,divider As Int)
	Public customcolors As tthemecolors
	
	Public Background,BackgroundHeader,Background2 As Int
	
	Public txtAccent,txtNormal,txtNormal2 As Int
	Public btnDisableText As Int
	Public DividerColor As Int
	
	Public ItemsBackgroundColor As Int '--- used in sadPrefDialogs
	Private Const MyBlackBG As Int = 0xFF292323  '--- Use as regular BLACK messes with the color weather icons
End Sub
'
'Rose
'			Red
'			Green
'			Gray
'			Dark
'			Dark-Blue
'			Dark-Green
'			Orange

Public Sub Init(theme As String)
	
'	If Main.kvs.ContainsKey(gblConst.INI_CUSTOM_THEME_COLORS) = False Then
'		SeedCustomClrs
'	End If
'	customcolors = Main.kvs.Get(gblConst.INI_CUSTOM_THEME_COLORS)
	InitTheme(theme)
	
End Sub

Public Sub InitTheme(theme As String)
	
	txtNormal = xui.Color_white
	txtAccent = 0xFF74C8C8
	btnDisableText = xui.Color_LightGray
	DividerColor = xui.Color_LightGray
	txtNormal2 = xui.Color_Yellow
	
	theme = theme.ToLowerCase
	Log("Init Theme: " & theme)
	
	Select Case theme
		
		Case "rose"
			Background = -7177863
			BackgroundHeader = -3054235
			Background2 = -7576990
			txtNormal = -15461870
			txtAccent = -395787
			btnDisableText = 1715811894
			DividerColor = 0xFF696969
			
		
		Case "custom"
			Background = customcolors.bg
			BackgroundHeader = customcolors.bgHeader
			Background2 = customcolors.bgMenu
			txtNormal = customcolors.txtNormal
			txtAccent = customcolors.txtAcc
			btnDisableText = customcolors.Disabled
			DividerColor = customcolors.Divider
			
		Case "red"
			Background = xui.Color_ARGB(255,131, 21, 25)
			BackgroundHeader = -5239520
			Background2 = xui.Color_ARGB(255,162, 30, 25)
			btnDisableText = 1006303994
			txtAccent = -1803140
			DividerColor = 0xFFDC143C
			
		Case "green"
			Background = xui.Color_ARGB(255,19, 62, 11)
			BackgroundHeader = -16310780
			Background2 = xui.Color_ARGB(255,10, 53, 2)
			btnDisableText = 720959736
			DividerColor = txtAccent
	
		Case "gray"
			Background = xui.Color_ARGB(255,90, 90, 90)
			BackgroundHeader =-13487823
			Background2 = xui.Color_ARGB(255,60, 60, 60)
			DividerColor = xui.Color_LightGray
			
		Case "dark"
			Background =  MyBlackBG 'xui.Color_ARGB(255,2, 2, 2)
			BackgroundHeader = xui.Color_ARGB(255,30, 30, 30)
			Background2 = xui.Color_ARGB(255,43, 43, 43)
			btnDisableText = 1404812219
			DividerColor = xui.Color_LightGray
			
		Case "dark-blue"
			Background = MyBlackBG' xui.Color_ARGB(255,2,2,2)
			BackgroundHeader = xui.Color_ARGB(255,30, 30, 30)
			Background2 = xui.Color_ARGB(255,43, 43, 43)
			txtNormal = -16739073
			txtAccent = -8472605
			btnDisableText = -12104360
			DividerColor = xui.Color_Gray
			
		Case "dark-green"
			Background =  MyBlackBG 'xui.Color_ARGB(255,2,2,2)
			BackgroundHeader = xui.Color_ARGB(255,30, 30, 30)
			Background2 = xui.Color_ARGB(255,43, 43, 43)
			txtNormal = -11276022
			txtAccent = 0xFFB1E89A
			btnDisableText =0xFF425845
			'DividerColor = txtAccent
			
		Case "orange"
			Background = -14672868
			BackgroundHeader = xui.Color_ARGB(255,11, 11, 11)
			Background2 = xui.Color_ARGB(255,43, 43, 43)
			txtNormal = -1551583
			txtAccent = 0xFFD77762
			btnDisableText = xui.Color_ARGB(50,192,192,192)
			DividerColor = xui.Color_Black
			
		Case Else ' --- "blue"
			Log("Theme Else: " & theme)
			Background = xui.Color_ARGB(255,53, 69, 85)
			BackgroundHeader = -14932432
			Background2 = xui.Color_ARGB(255,45, 62, 78)
			'Background2 = xui.Color_ARGB(255,43, 43, 43)
				
	End Select
	
'	Log("Background = " & Background)
'	Log("BackgroundHeader = " & BackgroundHeader)
'	Log("Background2 = " & Background2)
'	Log("txtNormal = " & txtNormal)
'	Log("txtAccent = " & txtAccent)
'	Log("btnDisableText = " & btnDisableText)
'	Log("DividerColor = " &  DividerColor)
	
End Sub


'Private Sub SeedCustomClrs
'	
'	Log("Seed clrs")
'	customcolors.Initialize
'	'--- seed a basic black / white
'	customcolors.bg = xui.Color_ARGB(255,2, 2, 2)
'	customcolors.bgHeader = xui.Color_ARGB(255,30, 30, 30)
'	customcolors.bgMenu = xui.Color_ARGB(255,43, 43, 43)
'	customcolors.txtNormal = xui.Color_white
'	customcolors.txtAcc = xui.Color_LightGray
'	customcolors.Disabled = xui.Color_ARGB(50,192,192,192)
'	customcolors.Divider = xui.Color_LightGray
'	Main.kvs.Put(gblConst.INI_CUSTOM_THEME_COLORS,customcolors)
'	
'End Sub

'=====================================================================

Public Sub ColorToHex4BBLabel(clr As Int) As String 'ignore
	Return "0x" & ColorToHex(clr)
End Sub

Public Sub ColorToHex(clr As Int) As String
	Dim bc As ByteConverter
	Return bc.HexFromBytes(bc.IntsToBytes(Array As Int(clr))) 'ignore
End Sub

Public Sub HexToColor(Hex As String) As Int 'ignore
	Dim bc As ByteConverter
	If Hex.StartsWith("#") Then
		Hex = Hex.SubString(1)
	Else If Hex.StartsWith("0x") Then
		Hex = Hex.SubString(2)
	End If
	Dim ints() As Int = bc.IntsFromBytes(bc.HexToBytes(Hex))
	Return ints(0)
End Sub

Public Sub Int2ARGB(Color As Int) As Int()
	Dim res(4) As Int
	res(0) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff000000), 24)
	res(1) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff0000), 16)
	res(2) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff00), 8)
	res(3) = Bit.And(Color, 0xff)
	Return res
End Sub




'====================================================================
'--- theme standard B4x dialog controls
'====================================================================


'Public Sub SetThemeB4xDialog(d As B4XDialog)
'	
'	'--- still needs work???
'	
'	d.BackgroundColor = Background
'	d.BorderColor = Background2
'	
'	d.TitleBarColor = BackgroundHeader
'	d.TitleBarTextColor = txtNormal
'	
'	d.ButtonsHeight = 54dip
'	d.ButtonsFont = xui.CreateDefaultFont(18)
'	d.ButtonsTextColor = txtNormal
'	d.ButtonsColor = 
'	
'	'd.BorderCornersRadius = 4dip
'
'End Sub


Public Sub SetThemeB4xListTemplate(l As B4XListTemplate)
	
	'--- TODO, needs to be set to theme colors
	
	Dim TextColor As Int = xui.Color_ARGB(0xFF, 0x5B, 0x5B, 0x5B)
	l.CustomListView1.sv.ScrollViewInnerPanel.Color = xui.Color_ARGB(0xFF, 0xDF, 0xDF, 0xDF)
	l.CustomListView1.sv.Color = xui.Color_White
	l.CustomListView1.DefaultTextBackgroundColor = xui.Color_White
	l.CustomListView1.DefaultTextColor = TextColor
	
End Sub

Public Sub SetThemeCustomListView(lv As CustomListView)
	lv.AsView.SetColorAndBorder(xui.Color_Transparent,0dip,xui.Color_Transparent,0dip)
	lv.sv.ScrollViewInnerPanel.Color = xui.Color_Transparent
	lv.GetBase.Color = xui.Color_Transparent
	lv.sv.Color = xui.Color_Transparent
	
	lv.PressedColor = BackgroundHeader
	lv.DefaultTextBackgroundColor = xui.Color_Transparent
	lv.DefaultTextColor = txtNormal
End Sub

'Public Sub SetThemeB4xInputTemplate(input As B4XInputTemplate,prompt As String)
'
'	Dim TextColor As Int = txtNormal
'	input.lblTitle.Text = prompt
'	input.TextField1.TextColor = TextColor
'	input.lblTitle.TextColor = TextColor
'	input.SetBorderColor(TextColor, Background2)
'
'	
'End Sub
Public Sub SetThemeSadB4xInputTemplate(input As sadB4XInputTemplate,prompt As String)

	Dim TextColor As Int = txtNormal
	input.lblTitle.Text = prompt
	input.TextField1.TextColor = TextColor
	input.lblTitle.TextColor = TextColor
	input.SetBorderColor(TextColor, Background2)
	
End Sub

Public Sub SetThemeB4xSearchTemplate(search As B4XSearchTemplate)
	
	'--- TODO, needs to be set to theme colors

	
	Dim TextColor As Int = xui.Color_ARGB(0xFF, 0x5B, 0x5B, 0x5B)
	search.SearchField.TextField.TextColor = TextColor
	search.SearchField.NonFocusedHintColor = TextColor
	search.CustomListView1.sv.ScrollViewInnerPanel.Color = xui.Color_ARGB(0xFF, 0xDF, 0xDF, 0xDF)
	search.CustomListView1.sv.Color = xui.Color_White
	search.CustomListView1.DefaultTextBackgroundColor = xui.Color_White
	search.CustomListView1.DefaultTextColor = TextColor
	If search.SearchField.lblV.IsInitialized Then search.SearchField.lblV.TextColor = TextColor
	If search.SearchField.lblClear.IsInitialized Then search.SearchField.lblClear.TextColor = TextColor

End Sub


'Public Sub SetThemeB4xDate(datetemplate As B4XDateTemplate)
'	Dim TextColor As Int = xui.Color_ARGB(0xFF, 0x5B, 0x5B, 0x5B)
'	datetemplate.DaysInWeekColor = xui.Color_Black
'	datetemplate.SelectedColor = xui.Color_ARGB(0xFF, 0x39, 0xD7, 0xCE)
'	datetemplate.HighlightedColor = xui.Color_ARGB(0xFF, 0x00, 0xCE, 0xFF)
'	datetemplate.DaysInMonthColor = TextColor
'	datetemplate.lblMonth.TextColor = TextColor
'	datetemplate.lblYear.TextColor = TextColor
'	datetemplate.SelectedColor = xui.Color_ARGB(0xFF, 0xFF, 0xA7, 0x61)
'	For Each x As B4XView In Array(datetemplate.btnMonthLeft, datetemplate.btnMonthRight, datetemplate.btnYearLeft, datetemplate.btnYearRight)
'		x.Color = xui.Color_Transparent
'	Next
'End Sub


Public Sub SetThemePrefDialog(pf As PreferencesDialog)
	
	'--- TODO, needs to be set to theme colors - NEEDS TO BE CHECKED!!!!
	'--- SEEMS TO THEME EVERYTHING
	
	'--- Need to wait for object to be created as colors need to be set after the underlying CLV is ready
	pf.CustomListView1.GetBase.Color =Background
	pf.CustomListView1.sv.Color =Background
	pf.CustomListView1.sv.ScrollViewInnerPanel.Color = Background
	For i = 0 To pf.CustomListView1.Size - 1
		pf.CustomListView1.GetPanel(i).Color = Background
	Next
End Sub





