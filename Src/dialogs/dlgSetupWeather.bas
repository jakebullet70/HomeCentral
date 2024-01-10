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
	Private btnSetDefaultCity,btnRemove,btnAdd As B4XView
	Private chkMetric,chkCelsius As CheckBox
	Private lstLocations As CustomListView

	Private DefCity, SelectedIcons As String = ""

	Private cboIconSets As B4XComboBox
	Private pnlCont,pnlBtns As B4XView
	Private dlgHelper As sadB4XDialogHelper
	Private lvs As sadClvSelections
	
End Sub


'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Dialog As B4XDialog)
	dlg = Dialog
End Sub

Public Sub Show()

		
	dlg.Initialize((B4XPages.MainPage.Root))
	dlgHelper.Initialize(dlg)
	
	Dim p As B4XView = XUI.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0,  430dip, 400dip)
	p.LoadLayout("viewSetupWeather")
	
	'Dim j As DSE_Layout : j.Initialize
	'j.SpreadVertically2(pnlBtns,50dip,6dip,"left")
	guiHelpers.SkinButton(Array As Button(btnAdd,btnRemove,btnSetDefaultCity))
	
	LoadData
	InitIconSets
	
	lvs.Initialize(lstLocations)
	lvs.Mode = lvs.MODE_SINGLE_ITEM_PERMANENT
	clrTheme.SetThemeCustomListView(lstLocations)
	lvs.SelectionColor = lstLocations.PressedColor
	lvs.ItemClicked(0)
	
	chkCelsius.TextColor = clrTheme.txtNormal
	chkMetric.TextColor = clrTheme.txtNormal
	guiHelpers.SetCBDrawable(chkCelsius, clrTheme.txtNormal, 1, clrTheme.txtAccent, Chr(8730), Colors.LightGray, 32dip, 2dip)
	guiHelpers.SetCBDrawable(chkMetric, clrTheme.txtNormal, 1,clrTheme.txtAccent, Chr(8730), Colors.LightGray, 32dip, 2dip)

	guiHelpers.ReSkinB4XComboBox(Array As B4XComboBox( cboIconSets))
		
	dlgHelper.ThemeDialogForm("Weather Setup")
	Dim rs As ResumableSub = dlg.ShowCustom(p, "SAVE", "", "CLOSE")
	dlgHelper.ThemeInputDialogBtnsResize
		
	Wait For (rs) Complete (Result As Int)
	If Result = XUI.DialogResponse_Positive Then
		SaveData
	End If
	
	
End Sub

Private Sub lstLocations_ItemClick (Index As Int, Value As Object)
	lvs.ItemClicked(Index)
End Sub


Private Sub LoadData()
	
	Dim ll() As String = Regex.Split(";;", Main.kvs.Get(gblConst.INI_WEATHER_CITY_LIST))
	
	lstLocations.Clear
	lstLocations.DefaultTextColor = clrTheme.txtNormal
	
	'lstLocations.Items.Initialize
	For Each city As String In ll
		lstLocations.AddTextItem(city,"")
	Next
	
	DefCity = Main.kvs.Get(gblConst.INI_WEATHER_DEFAULT_CITY)
	chkCelsius.Checked = Main.kvs.Get(gblConst.INI_WEATHER_USE_CELSIUS)
	chkMetric.Checked = Main.kvs.Get(gblConst.INI_WEATHER_USE_METRIC)
	
End Sub

Private Sub SaveData()
	
	Dim dd As String
	For x = 0 To lstLocations.Size - 1
		dd = dd & lstLocations.GetRawListItem(x).TextItem & ";;"
	Next
	dd = strHelpers.TrimLast(dd,";;")
	Main.kvs.Put(gblConst.INI_WEATHER_CITY_LIST,dd)
	Main.kvs.Put(gblConst.INI_WEATHER_DEFAULT_CITY,DefCity)
	Main.kvs.Put(gblConst.INI_WEATHER_USE_CELSIUS,chkCelsius.Checked)
	Main.kvs.Put(gblConst.INI_WEATHER_USE_METRIC,chkMetric.Checked)
	''gblConst.WEATHERicons
End Sub

Private Sub btnAdd_Click
End Sub

Private Sub btnRemove_Click
	
	If lstLocations.Size = 1 Then
		guiHelpers.Show_toast("Cannot delete last city")
	End If
	
	
End Sub

Private Sub btnSetDefaultCity_Click
	'DefCity = lstLocations.sv.
End Sub

Private Sub cboIconSets_ValueChanged (Value As Object)
End Sub

Private Sub chkMetric_CheckedChange(Checked As Boolean)
End Sub


'=====================================================
Private Sub InitIconSets
	
	cboIconSets.cmbBox.AddAll(Array As String("Icons - Bright and shiny 1","Icons - Bright and shiny 2", _
										"Icons - Material design","Icons - Material design (Color)","Icons - API (Color)"))
	
	Select Case gblConst.WEATHERicons
		Case "cc01"    : cboIconSets.SelectedIndex = 0
		Case "ww01"  : cboIconSets.SelectedIndex = 1
		Case "ms01"   : cboIconSets.SelectedIndex = 2
		Case "tv03"	   : cboIconSets.SelectedIndex = 3
		Case "api"	   : cboIconSets.SelectedIndex = 4
	End Select
	SetIconSet(cboIconSets.SelectedIndex)
End Sub

Private Sub cboIconSets_SelectedIndexChanged (Index As Int)
	SetIconSet(Index)
End Sub

Private Sub SetIconSet(i As Int)
	Select Case i
		Case 0 : SelectedIcons = "cc01"
		Case 1 : SelectedIcons = "ww01"
		Case 2 : SelectedIcons = "ms01"
		Case 3 : SelectedIcons = "tv03"
		Case 4 : SelectedIcons = "api"
	End Select
End Sub





