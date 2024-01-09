B4J=true
Group=Helpers-StaticCodeMods
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Dec/21/2023
#End Region
'Static code module
Sub Process_Globals
	Private fx As JFX, XUI As XUI
	
	Public SelectedTheme As String 
	
	Public clrMenuSelected As Int
	Public clrTxtNormal As Int
	Public clrTxtBright As Int
	Public clrTxtDisabled As Int
	Public clrTxtHint As Int
	Public clrTxtPositive As Int '--- a go / postive color
	Public clrTxtNegitive As Int '--- a NO go / negitive color
	
	Public clrPanelBGround As Int
	Public clrPanelBorderColor As Int
	
	Public clrTitleBarBG As Int
	Public clrTitleBarTXT As Int
	
	Public clrDlgButtonsTextColor As Int
	Public clrDlgButtonsColor As Int
	Public clrDlgButtonsBorder As Int
	Public clrDlgBorderColor As Int
		
	'--- more to be added i am sure
	
	
End Sub

Public Sub Init

	'--- here we read what theme has been selected
	'--- just assume light theme at the moment
	'---
	'--- refactoring needs to be done here
	
	
	SelectedTheme = "light"
	SetThemeColors	
	
End Sub

Private Sub SetThemeColors
	Select Case SelectedTheme
		
		'--- these are temp - need to refactored to someting pretty
		
		Case "light"
			clrPanelBGround =  XUI.Color_White
			clrPanelBorderColor = XUI.Color_LightGray
			
			clrDlgButtonsTextColor = XUI.Color_Blue
			clrDlgButtonsColor = XUI.Color_Transparent
			clrDlgBorderColor = XUI.Color_Transparent
			clrDlgButtonsBorder = XUI.Color_Black

			clrTxtHint = XUI.Color_LightGray	
			
			clrTxtBright = XUI.Color_Blue
			clrTxtDisabled = XUI.Color_Gray
			clrTxtNormal = XUI.Color_Black
			
			clrTxtPositive = XUI.Color_ARGB(255,26,85,9)
			clrTxtNegitive = XUI.Color_Red
			
			'clrTitleBarBG = XUI.Color_ARGB(255,0, 128, 88)
			clrTitleBarBG = HexToColor("#FF60B6E2")
			clrTitleBarTXT = XUI.Color_White
			
			clrMenuSelected = XUI.Color_Black
			
		Case "dark"
			
			clrPanelBGround = HexToColor("#FF555555")
			
			
	End Select
	
	'--- theme the main form dialog
	'--- this might need to be called again
	'B4XPages.MainPage.Dialog.Initialize(B4XPages.MainPage.Root)
	'SetThemeB4xDialog(B4XPages.MainPage.Dialog)
	
End Sub


'====================================================================
'--- suport / conversion routines 
'====================================================================


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


Public Sub SetThemeB4xDialog(d As B4XDialog)
	
	'--- still needs work???
	
	d.BackgroundColor = clrPanelBGround
	d.BorderColor = clrPanelBorderColor
	
	d.ButtonsTextColor = clrDlgButtonsTextColor
	d.ButtonsColor = clrDlgButtonsColor
	
	d.TitleBarColor = clrTitleBarBG
	d.TitleBarTextColor = clrTitleBarTXT
	d.BodyTextColor = clrTxtNormal
	
	'd.BorderCornersRadius = 4dip

End Sub


Public Sub SetThemeB4xListTemplate(l As B4XListTemplate)
	
	'--- TODO, needs to be set to theme colors
	
	Dim TextColor As Int = XUI.Color_ARGB(0xFF, 0x5B, 0x5B, 0x5B)
	l.CustomListView1.sv.ScrollViewInnerPanel.Color = XUI.Color_ARGB(0xFF, 0xDF, 0xDF, 0xDF)
	l.CustomListView1.sv.Color = XUI.Color_White
	l.CustomListView1.DefaultTextBackgroundColor = XUI.Color_White
	l.CustomListView1.DefaultTextColor = TextColor
	
End Sub

Public Sub SetThemeB4xInputTemplate(input As B4XInputTemplate)
	
	'--- TODO, needs to be set to theme colors

	Dim TextColor As Int = XUI.Color_ARGB(0xFF, 0x5B, 0x5B, 0x5B)
	input.TextField1.TextColor = TextColor
	input.lblTitle.TextColor = TextColor
	input.SetBorderColor(TextColor, XUI.Color_Red)

	
End Sub

Public Sub SetThemeB4xSearchTemplate(search As B4XSearchTemplate)
	
	'--- TODO, needs to be set to theme colors

	
	Dim TextColor As Int = XUI.Color_ARGB(0xFF, 0x5B, 0x5B, 0x5B)
	search.SearchField.TextField.TextColor = TextColor
	search.SearchField.NonFocusedHintColor = TextColor
	search.CustomListView1.sv.ScrollViewInnerPanel.Color = XUI.Color_ARGB(0xFF, 0xDF, 0xDF, 0xDF)
	search.CustomListView1.sv.Color = XUI.Color_White
	search.CustomListView1.DefaultTextBackgroundColor = XUI.Color_White
	search.CustomListView1.DefaultTextColor = TextColor
	If search.SearchField.lblV.IsInitialized Then search.SearchField.lblV.TextColor = TextColor
	If search.SearchField.lblClear.IsInitialized Then search.SearchField.lblClear.TextColor = TextColor

End Sub



Public Sub SetThemeInputDialogBtns(dlg As B4XDialog)
	
	'--- reskin buttons, if it does not exist then skip the error
	Try 
		Dim btnCancel As B4XView = dlg.GetButton(XUI.DialogResponse_Cancel)
		btnCancel.Font = XUI.CreateDefaultBoldFont(btnCancel.TextSize - 1)
		btnCancel.SetColorAndBorder(XUI.Color_Transparent,2dip,clrDlgButtonsBorder, 8dip)
		btnCancel.Height = btnCancel.Height - 4dip '--- resize height just a hair
		btnCancel.Top = btnCancel.Top + 4dip
	Catch
	End Try 'ignore
	
	Try 
		Dim btnOk As B4XView = dlg.GetButton(XUI.DialogResponse_Positive)
		btnOk.Font = XUI.CreateDefaultBoldFont(btnOk.TextSize - 1)
		btnOk.SetColorAndBorder(XUI.Color_Transparent,2dip,clrDlgButtonsBorder, 8dip)
		btnOk.Height = btnOk.Height - 4dip '--- resize height just a hair
		btnOk.Top = btnOk.Top + 4dip
	Catch
	End Try 'ignore
	
	Try 
		Dim btnNo As B4XView = dlg.GetButton(XUI.DialogResponse_Negative)
		btnNo.Font = XUI.CreateDefaultBoldFont(btnNo.TextSize - 1)
		btnNo.SetColorAndBorder(XUI.Color_Transparent,2dip,clrDlgButtonsBorder, 8dip)
		btnNo.Height = btnNo.Height - 4dip '--- resize height just a hair
		btnNo.Top = btnNo.Top + 4dip
	Catch
	End Try 'ignore
	
End Sub

'Public Sub SetThemeSwiftButton(Arr() As SwiftButton)
'	For Each o As SwiftButton In Arr
'		o.SetColors(clrSwiftBtnPrimary,clrSwiftBtnSecondary)
'		o.disabledColor = clrSwiftBtnDisabled
'		o.CornersRadius = 5
'		o.SideHeight = 4
'		o.xLBL.TextColor = clrTxtNormal
'	Next
'End Sub


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


Public Sub SetThemePrefDiolog(pf As PreferencesDialog)
	'--- Need to wait for object to be created as colors need to be set after the underlying CLV is ready
	pf.CustomListView1.GetBase.Color =clrPanelBGround
	pf.CustomListView1.sv.Color =clrPanelBGround
	pf.CustomListView1.sv.ScrollViewInnerPanel.Color = clrPanelBGround
	For i = 0 To pf.CustomListView1.Size - 1
		pf.CustomListView1.GetPanel(i).Color = clrPanelBGround
	Next
End Sub





