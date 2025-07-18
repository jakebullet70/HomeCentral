B4J=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' converted, July 2025
' Its ugly, thats what happens when you only get an hour or so a day to work on it
' and then no time for a week, Forget what the heck you where doing and why... Toss in
' a few shells, drones, no water or electricity, and like 10 air raid alarms per day...
' So we are at the point of JUST MAKE IT WORK!
' V. 1.0 derevied from old eHome code - From Around Dec/2015
' 
#End Region


Sub Class_Globals
	
	Private XUI As XUI
	Private dlg As B4XDialog
	Private IME As IME
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private btnRemove,btnAdd,btnEdit As B4XView

	Private dlgHelper As sadB4XDialogHelper
	Private CurrentRecID As Int
	'Private lstNdx As Int
	Private CurrentTxtDesc, CurrentTxtAddr As String
	
	Private pnlAddNew As Panel
	
	Private txtDescription,txtAddr As B4XFloatTextField
	Private btnNewSave,btnNewCancel As Button
	Private oLV_helper As listViewSelector
	
	Private chkHomePage As CheckBox
	Private lstAddr As ListView
	Private OnLstItemMove As Boolean = False
	Private isEditing As Boolean = False
End Sub


'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Dialog As B4XDialog)
	dlg = Dialog
End Sub


Public Sub Show()
	
	web.InitSql
		
	dlg.Initialize((B4XPages.MainPage.Root))
	dlgHelper.Initialize(dlg)
	
	Dim p As B4XView = XUI.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, 560dip,310dip)
	p.LoadLayout("viewSetupWeb")
	
	'Dim j As DSE_Layout : j.Initialize
	'j.SpreadVertically2(pnlBtns,50dip,6dip,"left")
	guiHelpers.SkinButton(Array As Button(btnAdd,btnRemove,btnNewCancel,btnNewSave,btnEdit))
	guiHelpers.SetTextColorB4XFloatTextField(Array As B4XFloatTextField(txtDescription,txtAddr))
	
	guiHelpers.SetCBDrawable(chkHomePage, clrTheme.txtNormal, 1,clrTheme.txtNormal, Chr(8730), Colors.LightGray, 32dip, 2dip)
	chkHomePage.TextColor = clrTheme.txtNormal
	guiHelpers.SetPanelsBorder(Array As B4XView(pnlAddNew),clrTheme.txtAccent)
	pnlAddNew.Color = clrTheme.Background2
	
	'sbTimerVol.Value 	= Main.kvs.Get(gblConst.INI_TIMERS_ALARM_VOLUME)
	'sbTimerVol_ValueChanged(sbTimerVol.Value)
	
	IME.Initialize("")
	
	oLV_helper.Initialize(lstAddr)
	LoadData
		
	dlgHelper.ThemeDialogForm("Web View Setup")
	Dim rs As ResumableSub = dlg.ShowCustom(p, "", "", "CLOSE")
	dlgHelper.ThemeDialogBtnsResize
	dlgHelper.NoCloseOn2ndDialog
	'btnTest.BringToFront
		
	Wait For (rs) Complete (Result As Int)
	CallSubDelayed(mpage.oPageCurrent,"Build_Side_Menu")
		
End Sub


Private Sub LoadData()
	LoadGrid
End Sub

Private Sub LoadGrid
	lstAddr.Clear
	Dim cur As Cursor = web.targets_get_all
	For i = 0 To cur.RowCount - 1
		cur.Position = i
		lstAddr.AddSingleLine2(cur.GetString("description") & " <-> " & cur.GetString("addr"),cur.GetString("id"))
	Next
	
	oLV_helper.ProgrammaticallyClickAndHighlight(0)
	
End Sub


Sub lstAddr_ItemClick (Position As Int, Value As Object)
	OnLstItemMove = True
	oLV_helper.ItemClick(Position ,Value)
	
	CurrentRecID = Value
	'lstNdx = Position
	
	Dim c As Cursor = Main.kvs.oSQL.ExecQuery("SELECT * FROM web_targets WHERE id=" & CurrentRecID)
	c.Position = 0
	CurrentTxtDesc = c.GetString("description")
	CurrentTxtAddr = c.GetString("addr")
	chkHomePage.Checked = IIf(c.GetString("home_page")="1",True,False)
	Sleep(0)
	OnLstItemMove = False
End Sub


Private Sub btnRemove_Click
	
	' if deleting entry is the default home page then do?
	
	' add note to wiki on web page - Android 4 not supporting modern SSL
	
	If lstAddr.Size = 1 Then
		guiHelpers.Show_toast("Cannot delete last entry")
		Return
	End If
	
	Dim o As dlgThemedMsgBox : o.Initialize
	Wait For (o.Show("Are you sure you want to delete this entry?","Question?","YES", "", "CANCEL")) Complete (i As Int)
	If i = XUI.DialogResponse_Cancel Then 
		Return
	End If
	
	'web.targets_delete(CurrentRecID)   
	web.oSQL.ExecNonQuery("DELETE FROM web_targets WHERE id=" & CurrentRecID)
	guiHelpers.Show_toast("Entry deleted")
	LoadGrid
	
End Sub

Private Sub btnAdd_Click
	ShowAddNewEdit(True)
	txtDescription.Text = "" : txtAddr.Text = ""
	chkHomePage.Checked = False
	txtAddr.RequestFocusAndShowKeyboard
End Sub

Private Sub btnCancel_Click
	'--- cancel add  new timer preset
	ShowAddNewEdit(False)
	IME.HideKeyboard
End Sub


Private Sub btnEdit_Click
	isEditing = True
	ShowAddNewEdit(True)
	txtDescription.Text = CurrentTxtDesc
	txtAddr.Text = CurrentTxtAddr
	txtAddr.RequestFocusAndShowKeyboard
End Sub


Private Sub btnSave_Click
	'--- add  new timer
	IME.HideKeyboard
	Sleep(0)
	If strHelpers.IsNullOrEmpty(txtAddr.Text) Then 
		ShowErrMsg("Web address cannot be empty",txtAddr)
		'	Dim tf As EditText = txtTime :	tf.SelectAll
		Return
	End If
	If strHelpers.IsNullOrEmpty(txtDescription.Text) Then
		ShowErrMsg("Description is not valid",txtDescription)
		Return
	End If
	ShowAddNewEdit(False)
	
	If isEditing Then
		web.targets_update(txtDescription.Text,txtAddr.Text,CurrentRecID)
	Else
		web.targets_insert_new(txtDescription.Text,txtAddr.Text,False)
	End If
	
	guiHelpers.Show_toast("Saved")
	LoadGrid
	isEditing = False
	
End Sub

Private Sub ShowErrMsg(txt As String,o As B4XFloatTextField)
	guiHelpers.Show_toast2(txt,1500)
	Sleep(1500)
	o.RequestFocusAndShowKeyboard
End Sub

Private Sub ShowAddNewEdit(ShowMe As Boolean)
	pnlAddNew.Visible = ShowMe 
	guiHelpers.EnableDisableViews( _
			Array As B4XView(btnAdd,btnRemove,btnEdit),Not (pnlAddNew.Visible))
	guiHelpers.SetVisible( _
			Array As B4XView(lstAddr,chkHomePage),Not (pnlAddNew.Visible))
	If ShowMe Then
		pnlAddNew.BringToFront
		CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_ON)
	Else
		pnlAddNew.SendToBack
		CallSub2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_OFF)
	End If
	Sleep(0)
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


Private Sub chkHomePage_CheckedChange(Checked As Boolean)
	If OnLstItemMove Or pnlAddNew.Visible Then Return
	If lstAddr.Size = 1 Then
		guiHelpers.Show_toast("Cannot change the last item")
		chkHomePage.Checked = True
		Return
	End If
	
	If Not(Checked) = True Then
		guiHelpers.Show_toast("Cannot change, assign a new item as home page first")
		chkHomePage.Checked = True
		Return
	End If
	
	'web.targets_clear_home_page
	'web.targets_set_home_page(CurrentRecID)
	web.oSQL.ExecNonQuery($"UPDATE web_targets SET home_page = "";"$)
	web.oSQL.ExecNonQuery($"UPDATE web_targets SET home_page = "1" WHERE id="$ & CurrentRecID)
End Sub


