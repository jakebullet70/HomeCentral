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

	Private dlgHelper As sadB4XDialogHelper
	Private clsExtApps As ExternalAppCtrl
	
	'--- show list of avail apps
	Private lstApps As ListView
	Private btnAppCancel,btnAppSelect As B4XView
	Private pnlApps As Panel
	Private pnlAppBtns As Panel
End Sub


'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Dialog As B4XDialog)
	dlg = Dialog
	clsExtApps = mpage.ExtApps
End Sub


Public Sub Show()
		
	dlg.Initialize((B4XPages.MainPage.Root))
	dlgHelper.Initialize(dlg)
	
	Dim j As DSE_Layout : j.Initialize
	Dim p As B4XView = XUI.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0,  660dip,  480dip)
	p.LoadLayout("viewSetupExtApps")
	
	'-------------------------------------------------------
	LoadAllExtApps
	j.SpreadVertically2(pnlAppBtns,50dip,6dip,"left")
	guiHelpers.SkinButton(Array As Button(btnAppCancel,btnAppSelect))
	'pnlApps.Visible = False
	'--------------------------------------------------------
	
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
		
	dlgHelper.ThemeDialogForm("External Apps Setup")
	Dim rs As ResumableSub = dlg.ShowCustom(p, "SAVE", "", "CLOSE")
	dlgHelper.ThemeDialogBtnsResize
	'dlgHelper.NoCloseOn2ndDialog
	'dlgHelper.ThemeDialogBtnsHideShow(False)
'	btnTest.BringToFront
		
	Wait For (rs) Complete (Result As Int)
	If Result = XUI.DialogResponse_Positive Then
		SaveData
	End If
	
End Sub


Private Sub LoadData()
	'--- populate the 6 ext apps
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




'---------------------------- show all external apps in lst

private Sub LoadAllExtApps
	'https://www.b4x.com/android/forum/threads/get-list-of-installed-apps-and-their-icons.71164/#content
	Dim lv1 As ListView = lstApps
	'Private apps_cancel As Button
	'Private apps_Label1 As Label

    Dim args(1) As Object
    Dim Obj1, Obj2, Obj3 As Reflector
    Dim size, i, flags As Int
    Dim Types(1), name,packName, name_temp As String
    Dim icon As BitmapDrawable
    Dim bmp As Bitmap '= icon.Bitmap
  
    Obj1.Target = Obj1.GetContext
    Obj1.Target = Obj1.RunMethod("getPackageManager") ' PackageManager
    Obj2.Target = Obj1.RunMethod2("getInstalledPackages", 0, "java.lang.int") ' List<PackageInfo>
    size = Obj2.RunMethod("size")
    
	For i = 0 To size -1
		
        Try
            Obj3.Target = Obj2.RunMethod2("get", i, "java.lang.int") ' PackageInfo
            packName = Obj3.GetField("packageName")
 
            Obj3.Target = Obj3.GetField("applicationInfo") ' ApplicationInfo
            flags = Obj3.GetField("flags")
 
            flags = Obj3.GetField("flags")
      
            args(0) = Obj3.Target
            Types(0) = "android.content.pm.ApplicationInfo"
            name = Obj1.RunMethod4("getApplicationLabel", args, Types)
          
            name_temp=name.ToLowerCase
          
            If Bit.And(flags, 1) = 0 Or name_temp.Contains("map") Then
                'app is not in the system image
                icon = Obj1.RunMethod4("getApplicationIcon", args, Types)
                bmp = icon.Bitmap
          
                icon.Initialize(bmp.Resize(50dip, 50dip, True))
                lv1.AddTwoLinesAndBitmap2(name,"",icon.Bitmap,packName)
            End If
			
        Catch '--- Error
            '--- Error in the line "bmp = icon.Bitmap"
          
            bmp.InitializeMutable(50dip,50dip)
            Dim DestRect As Rect
            DestRect.Initialize(0,0,50dip,50dip)
            Dim can As Canvas
            can.Initialize2(bmp)
            Dim pm As PackageManager
            can.DrawDrawable(pm.GetApplicationIcon(packName),DestRect)
          
            icon.Initialize(bmp)
            lv1.AddTwoLinesAndBitmap2(name,"",icon.Bitmap,packName)
        End Try
    Next
  
    'apps_Label1.Text="Select the app:"
    'apps_Label1.Invalidate
    Sleep(0)
    'apps_cancel.Enabled=True
End Sub

Private Sub btnAppCancel_Click
	pnlApps.Visible = False
	dlgHelper.ThemeDialogBtnsHideShow(True)
End Sub

Private Sub btnAppSelect_Click
	
End Sub
'-----------------------------------------------------------------


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

