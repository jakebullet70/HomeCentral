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
	Private chkCelsius As CheckBox
	Private lstLocations As ListView
	Private DefCity As String = ""
	Private chkMetric As CheckBox
	Private cboIconSets As Spinner
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
	
	LoadData
	
	Dim rs As ResumableSub = dlg.ShowCustom(p, "SAVE", "", "CLOSE")
	themes.SetThemeInputDialogBtns(dlg)
		
	Wait For (rs) Complete (Result As Int)
	If Result = XUI.DialogResponse_Positive Then
		SaveData
	End If
	
	
End Sub


Private Sub LoadData()
	
	Dim ll() As String = Regex.Split(";;", Main.kvs.Get(cnst.INI_WEATHER_CITY_LIST))
	
	'lstLocations.Items.Initialize
	For Each city As String In ll
		'lstLocations.Items.Add(city)
		lstLocations.AddSingleLine(city)
	Next
	
	DefCity = Main.kvs.Get(cnst.INI_WEATHER_DEFAULT_CITY)
	chkCelsius.Checked = Main.kvs.Get(cnst.INI_WEATHER_USE_CELSIUS)
	chkMetric.Checked = Main.kvs.Get(cnst.INI_WEATHER_USE_METRIC)
	
	'lstLocations.SelectedIndex = 0
	'lstLocations.Items.
	
End Sub

Private Sub SaveData()
	
	Dim dd As String
'	For x = 0 To lstLocations.Items.Size -1
'		dd = dd & lstLocations.Items.Get(x) & ";;"
'	Next
	dd = strHelpers.TrimLast(dd,";;")
	Main.kvs.Put(cnst.INI_WEATHER_CITY_LIST,dd)
	Main.kvs.Put(cnst.INI_WEATHER_DEFAULT_CITY,DefCity)
	Main.kvs.Put(cnst.INI_WEATHER_USE_CELSIUS,chkCelsius.Checked)
	Main.kvs.Put(cnst.INI_WEATHER_USE_METRIC,chkMetric.Checked)
	
End Sub

Private Sub btnAdd_Click
End Sub

Private Sub btnRemove_Click
End Sub

Private Sub btnSetDefaultCity_Click
	'DefCity = lstLocations.sv.
End Sub

Private Sub cboIconSets_ValueChanged (Value As Object)
End Sub

Private Sub chkMetric_CheckedChange(Checked As Boolean)
	
End Sub