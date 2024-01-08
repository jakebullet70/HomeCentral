B4J=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V.2.0	Jan-2024
'
' V. 1.0 derevied from eHoome code - 	Dec/21/2015
#End Region


Sub Class_Globals
	Private XUI As XUI
	Private dlg As B4XDialog
	Private btnAdd As B4XView
	Private btnRemove As B4XView
	Private btnSetDefaultCity As B4XView
	Private cboIconSets As ComboBox
	Private chkCelsius As CheckBox
	Private lstLocations As CustomListView
End Sub


'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Dialog As B4XDialog)
	dlg = Dialog
End Sub

Public Sub Show()

		
	dlg.Initialize((B4XPages.MainPage.Root))
	themes.SetThemeb4xDialog(dlg)
	dlg.Title = "Weather Setup"
	Dim p As B4XView = XUI.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0,370dip,320dip)
	p.LoadLayout("viewSetupWeather")
	Dim rs As ResumableSub = dlg.ShowCustom(p, "SAVE", "", "CLOSE")
	themes.SetThemeInputDialogBtns(dlg)
		
		
	Wait For (rs) Complete (Result As Int)
	
End Sub



Private Sub btnAdd_Click
	
End Sub

Private Sub btnRemove_Click
	
End Sub

Private Sub btnSetDefaultCity_Click
	
End Sub

Private Sub cboIconSets_ValueChanged (Value As Object)
	
End Sub