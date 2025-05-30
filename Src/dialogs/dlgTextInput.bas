﻿B4A=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=11.5
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' V. 1.0 	Aug/12/2022
#End Region

Sub Class_Globals
	
	Private const mModule As String = "dlgTextInput"' 'ignore
	Private mMainObj As B4XMainPage
	Private xui As XUI
	Private mPrompt As String
	Private mTitle As String
	Private mCallback As Object
	Private mEventName As String
	Public txtEdit As String = ""
	
	Private mDialog As B4XDialog 
	
End Sub



Public Sub Initialize( title As String, prompt As String, Callback As Object, EventName As String)
	
	mMainObj = B4XPages.MainPage
	mTitle = title
	mPrompt = prompt
	mCallback = Callback
	mEventName = EventName
	
End Sub


Public Sub Show
	
	'--- init
	mDialog.Initialize(mMainObj.Root)
	Dim dlgHelper As sadB4XDialogHelper
	dlgHelper.Initialize(mDialog)
	
	Dim inputTemplate As sadB4XInputTemplate
	inputTemplate.Initialize
	
	'--- setup edittext control
	Dim et As EditText = inputTemplate.TextField1
	et.InputType = et.INPUT_TYPE_TEXT
	'inputTemplate.ConfigureForNumbers(False, False) 'AllowDecimals, AllowNegative
	
	'--- make it pretty
	inputTemplate.mBase.Color = clrTheme.Background
	inputTemplate.lblTitle.Text = mPrompt
	inputTemplate.lblTitle.TextColor = clrTheme.txtNormal
	
	dlgHelper.ThemeDialogForm( mTitle)
	Dim rs As ResumableSub = mDialog.ShowTemplate(inputTemplate, "SAVE", "", "CANCEL")
	dlgHelper.ThemeInputDialogBtnsResize
	SizeInputDialog(mDialog,inputTemplate)
	inputTemplate.Text = txtEdit
	
	'--- display dialog
	Wait For(rs)complete(intResult As Int)
	CallSub2(mCallback,mEventName,IIf( intResult = xui.DialogResponse_Positive,inputTemplate.Text,""))
	
	CallSubDelayed2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_OFF)

End Sub



Private Sub SizeInputDialog(dlg As B4XDialog, input As sadB4XInputTemplate)
	
	Dim ET As EditText = input.TextField1
	Dim p As Panel = input.GetPanel(dlg) 
	Dim LB As B4XView = p.GetView(0)
	
	LB.Font = xui.CreateDefaultFont(NumberFormat2(22 / guiHelpers.gFscale,1,0,0,False))
	input.mBase.Height = input.mBase.Height + 22dip '--- sets bottom size where btns are
	LB.Height = Round((input.mBase.Height / 2.7)).As(Float)
	
	ET.Gravity = Gravity.CENTER
	ET.Height = Round(input.mBase.Height / 2).As(Float)
	ET.top = LB.Top + LB.Height + 8dip  '(input.mBase.Height / 3)
	ET.Width = input.mBase.Width - (ET.Left * 2)
	ET.TextSize = NumberFormat2(28 / guiHelpers.gFscale,1,0,0,False)
	ET.TextColor = clrTheme.txtNormal 
	
	Dim Cncl As B4XView = dlg.GetButton(xui.DialogResponse_Cancel)
	Dim ok   As B4XView = dlg.GetButton(xui.DialogResponse_Positive)

	Cncl.Top = ET.Top + ET.Height + dlg.TitleBarHeight + 8dip
	ok.Top = Cncl.Top
	
	dlg.Base.Height = ok.Height + ok.Top + 8dip'LB.Height' spacer2 
	'Log("titlebar height:" & header)
	
End Sub

'   RESIZE DIALOG CODE
'   RESIZE DIALOG CODE
'   RESIZE DIALOG CODE

'Sub YourSub
'
'	Dim input As B4XInputTemplate
'	input.Initialize
'	input.RegexPattern = ".+" 'require at least one character
'	input.lblTitle.Text = "Enter Employee Number"
'	input.mBase.Height = 20%y
'	input.mBase.Width = 60%x
'	Dim RS As ResumableSub = (dialog.ShowTemplate(input, "OK", "", "CANCEL"))
'	FormatDialog(input, True, False)
'	Wait For(RS) Complete (Result As Int)
'	If Result = xui.DialogResponse_Positive Then
'	
'End Sub


'Sub FormatDialog(input As B4XInputTemplate, NumOnly As Boolean, PW As Boolean)
'	Dim ET As EditText = input.TextField1
'	Dim p As Panel = input.GetPanel(dialog)
'	ET.Height = (input.mBase.Height / 2)
'	ET.top = (input.mBase.Height / 3)
'	ET.Width = input.mBase.Width - (ET.Left * 2)
'	Dim p As Panel = input.GetPanel(dialog)
'	Dim LB As Label = p.GetView(0)
'	LB.Height = (input.mBase.Height / 3)
'	LB.TextSize = 25
'	LB.TextColor = Colors.Cyan
'	Dim Cncl As B4XView = dialog.GetButton(xui.DialogResponse_Cancel)
'	Cncl.Width = (input.mBase.Width * .45)
'	Cncl.Left = ET.Left
'	Cncl.Height = Cncl.Height * 1.2  '((p.Height - (ET.Top + ET.Height)) * 2) '- 5dip        '
'	Cncl.TextSize = 33
'	Cncl.Color = Colors.RGB(255, 91, 71)
'	Cncl.Top = ET.Top + ET.Height + 15dip
'	Dim ok As B4XView = dialog.GetButton(xui.DialogResponse_Positive)
'	ok.Width = Cncl.Width
'	ok.Left = ET.Left + ET.Width - ok.Width
'	ok.Height = Cncl.Height
'	ok.TextSize = 33
'	ok.Color = Colors.Cyan
'	ok.Top = ET.Top + ET.Height + 15dip
'	ET.TextSize = 32
'	If NumOnly Then
'		'input.ConfigureForNumbers(True, False)
'		IME.SetCustomFilter(ET, ET.INPUT_TYPE_NUMBERS, "-.0123456789")
'	Else
'		ET.InputType = Bit.Or(128, Bit.Or(ET.InputType, 524288)) 'VARIATION_PASSWORD, NO_SUGGESTION
'		ET.PasswordMode = False
'	End If
'	ET.PasswordMode = PW
'End Sub

