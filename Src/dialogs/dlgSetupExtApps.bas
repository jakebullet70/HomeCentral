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
	Private IME As IME
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore

	'Private pnlCont,pnlBtns As B4XView
	Private dlgHelper As sadB4XDialogHelper
	Private clsExtApps As ExternalAppCtrl
	
End Sub


'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Dialog As B4XDialog)
	dlg = Dialog
	clsExtApps = mpage.ExtApps
End Sub


Public Sub Show()
		
	dlg.Initialize((B4XPages.MainPage.Root))
	dlgHelper.Initialize(dlg)
	
	Dim p As B4XView = XUI.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0,  550dip,  480dip)
	p.LoadLayout("viewSetupExtApps")
	
	'Dim j As DSE_Layout : j.Initialize
	'j.SpreadVertically2(pnlBtns,50dip,6dip,"left")
'	guiHelpers.SkinButton(Array As Button(btnAdd,btnRemove,btnTest,btnNewCancel,btnNewSave))
'	guiHelpers.ReSkinB4XComboBox(Array As B4XComboBox( cboSounds))
'	guiHelpers.SetTextColor(Array As B4XView(Label1,Label3,lblTmrVol),clrTheme.txtNormal)
'	guiHelpers.ReSkinB4XSeekBar(Array As B4XSeekBar(sbTimerVol))
'	guiHelpers.SetPanelsBorder(Array As B4XView(pnlTimerVol),clrTheme.txtAccent)
'	guiHelpers.ResizeText("100%",lblTmrVol)
'	guiHelpers.SetTextColorB4XFloatTextField(Array As B4XFloatTextField(txtDescription,txtTime))
	
	
'	sbTimerVol.Value 	= Main.kvs.Get(gblConst.INI_TIMERS_ALARM_VOLUME)
'	sbTimerVol_ValueChanged(sbTimerVol.Value)
	
	IME.Initialize("")
	
'	oLV_helper.Initialize(lstPresets)
'	LoadData
		
	dlgHelper.ThemeDialogForm("Timers Setup")
	Dim rs As ResumableSub = dlg.ShowCustom(p, "SAVE", "", "CLOSE")
	dlgHelper.ThemeDialogBtnsResize
	dlgHelper.NoCloseOn2ndDialog
'	btnTest.BringToFront
		
	Wait For (rs) Complete (Result As Int)
	If Result = XUI.DialogResponse_Positive Then
		SaveData
	End If
	
End Sub


Private Sub LoadData()
'	vol_timers.SelectItemInCBO(cboSounds,Main.kvs.Get(gblConst.INI_TIMERS_ALARM_FILE))
'	LoadGrid
End Sub

Private Sub LoadGrid
'	lstPresets.Clear
'	Dim cursor As Cursor = kt.timers_get_all
'	For i = 0 To cursor.RowCount - 1
'		cursor.Position = i
'		lstPresets.AddSingleLine2(cursor.GetString("time") & "-" & cursor.GetString("description"),cursor.GetString("id"))
'	Next
'	
'	oLV_helper.	ProgrammaticallyClickAndHighlight(0)
	
End Sub


Private Sub SaveData()
'	vol_timers.SaveTimerVolume(cboSounds.SelectedItem,sbTimerVol.Value)
	CallSubDelayed(mpage.oPageCurrent,"Build_Side_Menu")
End Sub


Private Sub btnTest_Click
'	vol_timers.PlaySound(sbTimerVol.Value,vol_timers.BuildAlarmFile(cboSounds.SelectedItem))
End Sub


Sub lstPresets_ItemClick (Position As Int, Value As Object)
'	oLV_helper.ItemClick (Position , Value )
'	CurrentRecID = Value
End Sub


Private Sub ShowErrMsg(txt As String,o As B4XFloatTextField)
	guiHelpers.Show_toast2(txt,1500)
	Sleep(1500)
	o.RequestFocusAndShowKeyboard
End Sub

'
'Private Sub ime_HandleAction As Boolean
'	Dim e As EditText : e = Sender
'	If txtCurrent = e Then
'		Return True
'	Else
'		Return False 'will close the keyboard
'	End If
'End Sub

'#if DEBUG
'#if JAVA
'public void RemoveWarning() throws Exception{
'	anywheresoftware.b4a.shell.Shell s = anywheresoftware.b4a.shell.Shell.INSTANCE;
'	java.lang.reflect.Field f = s.getClass().getDeclaredField("errorMessagesForSyncEvents");
'	f.setAccessible(true);
'	java.util.HashSet<String> h = (java.util.HashSet<String>)f.get(s);
'	if (h == null) {
'		h = new java.util.HashSet<String>();
'		f.set(s, h);
'	}
'	h.add("textfield1_textchanged");
'}
'#End If
'#End If
