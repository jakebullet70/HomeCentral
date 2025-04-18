﻿B4J=true
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
	Private IME As IME
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private btnRemove,btnAdd As B4XView
	
	'Private pnlCont,pnlBtns As B4XView
	Private dlgHelper As sadB4XDialogHelper
	Private lvs As sadClvSelections
	
	Private cboSounds As B4XComboBox
	Private btnTest As Button
	
	Private Label3,Label1,Label2,Label4 As Label
	Private lblTmrVol As Label
	Private sbTimerVol As B4XSeekBar
	Private pnlTimerVol As Panel
	Private lstPresets As ListView
	Private pnlVolSnd,pnlAddNew As Panel
	
	Private txtDescription,txtTime As EditText
	
	Private btnNewCancel As Button
	Private btnNewSave As Button
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
	
	'Dim j As DSE_Layout : j.Initialize
	'j.SpreadVertically2(pnlBtns,50dip,6dip,"left")
	guiHelpers.SkinButton(Array As Button(btnAdd,btnRemove,btnTest,btnNewCancel,btnNewSave))
	guiHelpers.ReSkinB4XComboBox(Array As B4XComboBox( cboSounds))
	guiHelpers.SetTextColor(Array As B4XView(Label4,Label2,Label1,Label3,lblTmrVol),clrTheme.txtNormal)
	guiHelpers.ReSkinB4XSeekBar(Array As B4XSeekBar(sbTimerVol))
	guiHelpers.SetPanelsBorder(Array As B4XView(pnlTimerVol),clrTheme.txtAccent)
	guiHelpers.ResizeText("100%",lblTmrVol)
	
	guiHelpers.SkinTextEdit(Array As EditText(txtDescription,txtTime),0,True)
	
	sbTimerVol.Value 	= Main.kvs.Get(gblConst.INI_TIMERS_ALARM_VOLUME)
	sbTimerVol_ValueChanged(sbTimerVol.Value)
	
	IME.Initialize("")
	Dim jo As JavaObject = txtTime
	jo.RunMethod("setImeOptions", Array(Bit.Or(33554432, 6))) 'IME_FLAG_NO_FULLSCREEN | IME_ACTION_DONE
	#if DEBUG
	Dim jo As JavaObject = Me
	jo.RunMethod("RemoveWarning", Null)
	#End If
	
	
	LoadData
	
	'lvs.Initialize(lstPresets)
	'lvs.Mode = lvs.MODE_SINGLE_ITEM_PERMANENT
	'clrTheme.SetThemeCustomListView(lstPresets)
	'lvs.SelectionColor = lstPresets.PressedColor
	'lvs.ItemClicked(0)
		
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
	'lstPresets.DefaultTextColor = clrTheme.txtNormal
	
	Dim cursor As Cursor = kt.timers_get_all
	For i = 0 To cursor.RowCount - 1
		cursor.Position = i
		lstPresets.AddSingleLine2(cursor.GetString("time") & "-" & cursor.GetString("description"),cursor.GetString("id"))
		'lstPresets.AddTextItem("08:00:00-Pasta","08:00:00-Pasta")
		'lst.Add(cursor.GetString("id") & cursor.GetString("id") & cursor.GetString("id"))
		'lstPresets.sv.t
	Next
	Return
	
	'lstPresets.AddTextItem("08:00:00-Pasta","08:00:00-Pasta")
	
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


Private Sub btnTest_Click
	vol_timers.PlaySound(sbTimerVol.Value,vol_timers.BuildAlarmFile(cboSounds.SelectedItem))
End Sub


Private Sub cboSounds_SelectedIndexChanged (Index As Int)
End Sub

Private Sub sbTimerVol_ValueChanged (Value As Int)
	lblTmrVol.Text = Value & "%"
End Sub

Private Sub lstPresets_ItemClick (Index As Int, Value As Object)
	'lvs.ItemClicked(Index)
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
	guiHelpers.Show_toast("Entry deleted")
	
	lvs.SelectedItems.Clear
	lvs.ItemClicked(0)
	
	
End Sub

Private Sub btnAdd_Click
		'pnlAddNew.Visible = True : pnlTimerVol.Visible = False
	ShowAddNew(True)
	txtTime.RequestFocus
	'Dim tf As EditText = TextField1
	'tf.SelectAll
	IME.ShowKeyboard(txtTime)
End Sub

Private Sub btnCancel_Click
	'--- cancel add  new timer
	ShowAddNew(False)
	IME.HideKeyboard
End Sub

Private Sub btnSave_Click
	'--- add  new timer
	ShowAddNew(False)
	guiHelpers.Show_toast("Saved")
	'--- refresh listbox
	IME.HideKeyboard
End Sub

Private Sub ShowAddNew(ShowMe As Boolean)
	pnlAddNew.Visible = ShowMe 
	pnlVolSnd.Visible = Not (ShowMe)
	If ShowMe Then
		pnlVolSnd.SendToBack
		pnlAddNew.BringToFront
		CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_ON)
	Else
		pnlVolSnd.BringToFront
		pnlAddNew.SendToBack
		CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_OFF)
	End If
	Sleep(0)
End Sub

#if DEBUG
#if JAVA
public void RemoveWarning() throws Exception{
	anywheresoftware.b4a.shell.Shell s = anywheresoftware.b4a.shell.Shell.INSTANCE;
	java.lang.reflect.Field f = s.getClass().getDeclaredField("errorMessagesForSyncEvents");
	f.setAccessible(true);
	java.util.HashSet<String> h = (java.util.HashSet<String>)f.get(s);
	if (h == null) {
		h = new java.util.HashSet<String>();
		f.set(s, h);
	}
	h.add("textfield1_textchanged");
}
#End If
#End If