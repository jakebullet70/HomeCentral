﻿B4J=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Dec/21/2023
#End Region


Sub Class_Globals
	Private XUI As XUI
	Private dlg As B4XDialog
	Private lblAbout As B4XView
	Private dlgHelper As sadB4XDialogHelper
End Sub


'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Dialog As B4XDialog)
	dlg = Dialog
End Sub

Public Sub Show()

		
	dlg.Initialize((B4XPages.MainPage.Root))
	dlgHelper.Initialize(dlg)
	
	
	Dim p As B4XView = XUI.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0,400dip,400dip)
	p.LoadLayout("dlgAbout")
	
	dlgHelper.ThemeDialogForm( "About")
	Dim rs As ResumableSub = dlg.ShowCustom(p, "", "", "OK")
	dlgHelper.ThemeDialogBtnsResize
		
	'--- interesting text goes here
	lblAbout.TextSize = 18
	lblAbout.Text = "This Could Be An About Box..." & CRLF & "more text to be added later"
		
	Wait For (rs) Complete (Result As Int)
	
End Sub

