B4J=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Dec/24/2023
#End Region

'--- This is a generic theme basic MSGBOX class ---
'--- This is a generic theme basic MSGBOX class ---
'--- This is a generic theme basic MSGBOX class ---


Sub Class_Globals
	'Private fx As JFX
	Private XUI As XUI
	Private dlg As B4XDialog
	Private dlgHelper As sadB4XDialogHelper
End Sub


Public Sub Initialize()
	dlg = B4XPages.MainPage.DialogMSGBOX
End Sub




Public Sub Show(msgText As String,title As String, _
				yesBtn As String, noBtn As String, cancelBtn As String) As ResumableSub
								
	Wait For (Show2(msgText,title,yesBtn,noBtn,cancelBtn,0)) Complete (i As Int)
	Return i
	
End Sub


Public Sub ShowOK(msgText As String,title As String) As ResumableSub
				
	Wait For (Show2(msgText,title,"OK","","",0)) Complete (i As Int)
	Return i
	
End Sub


Public Sub Show2(msgText As String,title As String, _
			yesBtn As String,noBtn As String,cancelBtn As String,icon As Int) As ResumableSub'ignore
	
	'--- Icon not used yet
	'--- Icon not used yet
	'--- Icon not used yet
	
		
	dlg.Initialize(B4XPages.MainPage.Root)
	dlgHelper.Initialize(dlg)
	
	dlgHelper.ThemeDialogForm( title)
	Dim rs As ResumableSub = dlg.Show(msgText, yesBtn, noBtn, cancelBtn)
	dlgHelper.ThemeInputDialogBtnsResize
	
	'--- call it!
	Wait For (rs) Complete (i As Int)
	Return i
	
End Sub

