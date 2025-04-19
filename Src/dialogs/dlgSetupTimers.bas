B4J=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V.2.0	Apr-2025
'
' V. 1.0 derevied from eHome code - 	Dec/21/2015
#End Region


Sub Class_Globals
	
	Private XUI As XUI
	Private dlg As B4XDialog
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private btnRemove,btnAdd As B4XView
	Private mMediaPlayer As MediaPlayer

	'Private pnlCont,pnlBtns As B4XView
	Private dlgHelper As sadB4XDialogHelper
	Private lvs As sadClvSelections
	
	Private cboSounds As B4XComboBox
	Private btnTest As Button
	
	Private Label3,Label1 As Label
	Private lblTmrVol As Label
	Private sbTimerVol As B4XSeekBar
	Private pnlTimerVol As Panel
	Private lstPresets As CustomListView
End Sub


'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Dialog As B4XDialog)
	dlg = Dialog
End Sub


Public Sub Show()
		
	dlg.Initialize((B4XPages.MainPage.Root))
	dlgHelper.Initialize(dlg)
	
	Dim p As B4XView = XUI.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0,  550dip,  480dip)
	p.LoadLayout("viewSetupTimers")
	'CallSubDelayed(p, "Script_Resize")
	
	'Dim j As DSE_Layout : j.Initialize
	'j.SpreadVertically2(pnlBtns,50dip,6dip,"left")
	guiHelpers.SkinButton(Array As Button(btnAdd,btnRemove,btnTest))
	guiHelpers.ReSkinB4XComboBox(Array As B4XComboBox( cboSounds))
	guiHelpers.SetTextColor(Array As B4XView(Label1,Label3,lblTmrVol),clrTheme.txtNormal)
	guiHelpers.ReSkinB4XSeekBar(Array As B4XSeekBar(sbTimerVol))
	guiHelpers.SetPanelsBorder(Array As B4XView(pnlTimerVol),clrTheme.txtAccent)
	guiHelpers.ResizeText("100%",lblTmrVol)
	
	sbTimerVol.Value 	= Main.kvs.Get(gblConst.INI_TIMERS_ALARM_VOLUME)
	sbTimerVol_ValueChanged(sbTimerVol.Value)
	
	LoadData
	
	lvs.Initialize(lstPresets)
	lvs.Mode = lvs.MODE_SINGLE_ITEM_PERMANENT
	clrTheme.SetThemeCustomListView(lstPresets)
	lvs.SelectionColor = lstPresets.PressedColor
	lvs.ItemClicked(0)
		
	dlgHelper.ThemeDialogForm("Timers Setup")
	Dim rs As ResumableSub = dlg.ShowCustom(p, "SAVE", "", "CLOSE")
	dlgHelper.ThemeDialogBtnsResize
	dlgHelper.NoCloseOn2ndDialog
	btnTest.BringToFront
		
	Wait For (rs) Complete (Result As Int)
	If Result = XUI.DialogResponse_Positive Then
		SaveData
	End If
	
	
End Sub


Private Sub LoadData()
	
	vol_timers.SetTimerSoundFiles(cboSounds,Main.kvs.Get(gblConst.INI_TIMERS_ALARM_FILE))
		
	lstPresets.Clear
	lstPresets.DefaultTextColor = clrTheme.txtNormal
	lstPresets.AddTextItem("08:00:00-Pasta","08:00:00-Pasta")
	
	'lstLocations.Items.Initialize
'	For Each city As String In ll
'		lstLocations.AddTextItem(city,city)
'	Next
'	
'	DefCity = Main.kvs.Get(gblConst.INI_WEATHER_DEFAULT_CITY)
'	chkCelsius.Checked = Main.kvs.Get(gblConst.INI_WEATHER_USE_CELSIUS)
'	chkMetric.Checked = Main.kvs.Get(gblConst.INI_WEATHER_USE_METRIC)
	
End Sub

Private Sub SaveData()
	
	''Main.kvs.Put(gblConst.INI_TIMERS_ALARM_VOLUME,75)
	'Main.kvs.Put(gblConst.INI_TIMERS_ALARM_FILE,vol_timers.BuildAlarmFile(cboSounds.cmbBox.SelectedItem))
	vol_timers.SaveTimerVolume(cboSounds.SelectedItem,sbTimerVol.Value)



	
'	Dim dd As String
'	For x = 0 To lstLocations.Size - 1
'		dd = dd & lstLocations.GetValue(x)& ";;"
'	Next
	'dd = strHelpers.TrimLast(dd,";;")
	'Main.kvs.Put(gblConst.INI_WEATHER_CITY_LIST,dd)
	'Main.kvs.Put(gblConst.INI_WEATHER_CITY_LIST,"Seattle;;Denver;;Kherson")
	
	'Main.kvs.Put(gblConst.INI_WEATHER_DEFAULT_CITY,DefCity)
'	Main.kvs.Put(gblConst.INI_WEATHER_USE_CELSIUS,chkCelsius.Checked)
'	Main.kvs.Put(gblConst.INI_WEATHER_USE_METRIC,chkMetric.Checked)
	
	'gblConst.WEATHERicons = SelectedIconsSet
	'Main.kvs.Put(gblConst.INI_WEATHER_ICONS_PATH,SelectedIconsSet)
	
	CallSubDelayed(mpage.oPageCurrent,"Build_Side_Menu")
	
End Sub

Private Sub btnAdd_Click
	
	Dim t As sadB4XInputTemplate : t.Initialize
	mpage.Dialog2.Initialize(mpage.Root)
	
	Try
		Dim dlgHelper2 As sadB4XDialogHelper
		dlgHelper2.Initialize(mpage.Dialog2)
	
		dlgHelper2.ThemeDialogForm("Enter city")
		
		't.ConfigureForNumbers(False, False)
		't.TextField1.As(EditText).SingleLine = True
		
		Dim rs As ResumableSub = mpage.Dialog2.ShowTemplate(t, "OK", "", "CANCEL")
		dlgHelper2.ThemeDialogBtnsResize
		clrTheme.SetThemesadB4xInputTemplate(t,"City name")
	
		Wait For (rs) Complete (i As Int)
		If i = XUI.DialogResponse_Cancel Then
			Return
		End If
		
		lstPresets.AddTextItem(t.Text,t.Text)
		
	Catch
		Log(LastException)
	End Try
	
	
End Sub

Private Sub btnRemove_Click
	
	If lstPresets.Size = 1 Then
		guiHelpers.Show_toast("Cannot delete last entry")
		Return
	End If
	
	Dim o As dlgThemedMsgBox : o.Initialize
	Wait For (o.Show("Are you sure you want to delete this entry?","Question?","YES", "", "CANCEL")) Complete (i As Int)
	If i = XUI.DialogResponse_Cancel Then 
		Return
	End If
	
	lstPresets.RemoveAt(lvs.SelectedItems.AsList.Get(0))
	guiHelpers.Show_toast("City deleted")
	
	lvs.SelectedItems.Clear
	lvs.ItemClicked(0)
	
	
End Sub


Private Sub cboSounds_SelectedIndexChanged (Index As Int)
End Sub

Private Sub sbTimerVol_ValueChanged (Value As Int)
	lblTmrVol.Text = Value & "%"
End Sub

Private Sub lstPresets_ItemClick (Index As Int, Value As Object)
	lvs.ItemClicked(Index)
End Sub

Private Sub btnTest_Click
	vol_timers.PlaySound(sbTimerVol.Value,vol_timers.BuildAlarmFile(cboSounds.SelectedItem))
End Sub