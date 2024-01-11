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

	Private DefCity, SelectedIconsSet As String = ""

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
	p.SetLayoutAnimated(0, 0, 0,  430dip,  450dip)
	p.LoadLayout("viewSetupWeather")
	
	'Dim j As DSE_Layout : j.Initialize
	'j.SpreadVertically2(pnlBtns,50dip,6dip,"left")
	guiHelpers.SkinButton(Array As Button(btnAdd,btnRemove,btnSetDefaultCity))
	guiHelpers.ReSkinB4XComboBox(Array As B4XComboBox( cboIconSets))
	
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

	
		
	dlgHelper.ThemeDialogForm("Weather Setup")
	Dim rs As ResumableSub = dlg.ShowCustom(p, "SAVE", "", "CLOSE")
	dlgHelper.ThemeInputDialogBtnsResize
	dlgHelper.NoCloseOn2ndDialog
		
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
		lstLocations.AddTextItem(city,city)
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
	
	gblConst.WEATHERicons = SelectedIconsSet
	Main.kvs.Put(gblConst.INI_WEATHER_ICONS_PATH,SelectedIconsSet)
	
End Sub

Private Sub btnAdd_Click
End Sub

Private Sub btnRemove_Click
	
	If lstLocations.Size = 1 Then
		guiHelpers.Show_toast("Cannot delete last city")
		Return
	End If
	
	Dim o As dlgThemedMsgBox : o.Initialize
	Wait For (o.Show("Are you sure you want to delete city?","Question?","YES", "", "CANCEL")) Complete (i As Int)
	If i = XUI.DialogResponse_Cancel Then 
		Return
	End If
	
	lstLocations.RemoveAt(lvs.SelectedItems.AsList.Get(0))
	guiHelpers.Show_toast("City deleted")
	lvs.SelectAndMakeVisible(0)
	
End Sub

Private Sub btnSetDefaultCity_Click
	Try
		DefCity = lstLocations.GetValue( lvs.SelectedItems.AsList.Get(0))
		guiHelpers.Show_toast(DefCity & " - set as default city")
	Catch
		Log(LastException)
	End Try
	
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
	SelectedIconsSet = gblConst.WEATHERicons
	
End Sub

Private Sub cboIconSets_SelectedIndexChanged (Index As Int)
	SetIconSet(Index)
End Sub

Private Sub SetIconSet(i As Int)
	Log(i)
	Select Case i
		Case 0 : SelectedIconsSet = "cc01"
		Case 1 : SelectedIconsSet = "ww01"
		Case 2 : SelectedIconsSet = "ms01"
		Case 3 : SelectedIconsSet = "tv03"
		Case 4 : SelectedIconsSet = "api"
	End Select
End Sub





