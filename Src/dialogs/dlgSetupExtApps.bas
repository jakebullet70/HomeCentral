B4J=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 derevied from eHome code - 	Dec/21/2015
#End Region


Sub Class_Globals
	
	Private XUI As XUI
	Private dlg As B4XDialog
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private btnSetDefaultCity,btnRemove,btnAdd As B4XView
	'Private chkMetric,chkCelsius As CheckBox
	'Private lstLocations As CustomListView

	'Private DefCity, SelectedIconsSet As String = ""

	'Private cboIconSets As B4XComboBox
	'Private pnlCont,pnlBtns As B4XView
	Private dlgHelper As sadB4XDialogHelper
	'Private lvs As sadClvSelections
	
	Private lv As ListView
	Private lblSelectedPRG As Label
	Private txtShortDesc As B4XFloatTextField
	Private btnSave As Button
	Private btnClear As Button
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
	p.LoadLayout("viewSetupExtApps.bal")
	
	'Dim j As DSE_Layout : j.Initialize
	'j.SpreadVertically2(pnlBtns,50dip,6dip,"left")
	'guiHelpers.SkinButton(Array As Button(btnAdd,btnRemove,btnSetDefaultCity))
	'guiHelpers.SetCBDrawable(chkCelsius, clrTheme.txtNormal, 1,clrTheme.txtNormal, Chr(8730), Colors.LightGray, 32dip, 2dip)
	'guiHelpers.SetCBDrawable(chkMetric, clrTheme.txtNormal, 1,clrTheme.txtNormal, Chr(8730), Colors.LightGray, 32dip, 2dip)
	
	'LoadData
	'InitIconSets
	
'	lvs.Initialize(lstLocations)
'	lvs.Mode = lvs.MODE_SINGLE_ITEM_PERMANENT
'	clrTheme.SetThemeCustomListView(lstLocations)
'	lvs.SelectionColor = lstLocations.PressedColor
'	lvs.ItemClicked(0)
'	
'	chkCelsius.TextColor = clrTheme.txtNormal
'	chkMetric.TextColor = clrTheme.txtNormal
'	guiHelpers.SetCBDrawable(chkCelsius, clrTheme.txtNormal, 1, clrTheme.txtAccent, Chr(8730), Colors.LightGray, 32dip, 2dip)
'	guiHelpers.SetCBDrawable(chkMetric, clrTheme.txtNormal, 1,clrTheme.txtAccent, Chr(8730), Colors.LightGray, 32dip, 2dip)
	btnClear.Text = "Clear"
	btnSave.Text = "Save"
	dlgHelper.ThemeDialogForm("External Apps Setup")
	Dim rs As ResumableSub = dlg.ShowCustom(p, "", "", "CLOSE")
	dlgHelper.ThemeDialogBtnsResize
	dlgHelper.NoCloseOn2ndDialog
		
	Wait For (rs) Complete (Result As Int)
	If Result = XUI.DialogResponse_Positive Then
		SaveData
	End If
	
	
End Sub


Private Sub LoadData()
	
End Sub

Private Sub SaveData()
	
	
	CallSubDelayed(mpage.oPageCurrent,"Build_Side_Menu")
	
End Sub

Private Sub btnAdd_Click
	
	
End Sub

Private Sub btnRemove_Click
	
	
End Sub

