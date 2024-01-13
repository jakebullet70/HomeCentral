B4J=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' V. 1.0 	Jan/14/2024
#End Region

Sub Class_Globals
	
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private xui As XUI
	Private mGeneralDlg As sadPreferencesDialog
	Private prefHelper As sadPreferencesDialogHelper
	
End Sub

Public Sub Initialize(pf As sadPreferencesDialog) 
	mGeneralDlg = pf
End Sub


public Sub CreateDefaultFile
	
	If File.Exists(xui.DefaultFolder,gblConst.GENERAL_OPTIONS_FILE) = False Then
		File.WriteMap(xui.DefaultFolder,gblConst.GENERAL_OPTIONS_FILE,  _
						CreateMap( "logall": "false", "logpwr": "false",  "logfiles": "false", "logoctokey": "false", "logrest": "false", _
						"syscmds": "false", "axesx": "false",  "axesy": "false", "axesz": "false","sboot":"false","syscmds":"false", _
						 "m600":"false","prpwr":"false","mpsd":"true","ort":"Autodetect"))					 
	End If
End Sub


Public Sub Show
	
	Dim Data As Map = File.ReadMap(xui.DefaultFolder,gblConst.GENERAL_OPTIONS_FILE)
	
	Dim h,w As Float '--- TODO - needs refactor
	h = 440dip
	w = 400dip
	
	
	mGeneralDlg.Initialize(mpage.root, "General Settings", w, h)
	
	Dim s As String = File.ReadString(File.DirAssets,"dlggeneral.json")
	If guiHelpers.gIsPortrait Then 
		s = s.Replace("Movement ","Move ") '--- portrait screen GUI fix
	End If
	mGeneralDlg.LoadFromJson(s)
	mGeneralDlg.SetEventsListener(Me,"dlgGeneral")
	
	
	prefHelper.Initialize(mGeneralDlg)
	'If guiHelpers.gIsPortrait Then prefHelper.pDefaultFontSize = 17
	prefHelper.ThemePrefDialogForm
	mGeneralDlg.PutAtTop = False
	Dim RS As ResumableSub = mGeneralDlg.ShowDialog(Data, "OK", "CANCEL")
	prefHelper.dlgHelper.ThemeDialogBtnsResize
	
	Wait For (RS) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		guiHelpers.Show_toast("Data Saved")
		File.WriteMap(xui.DefaultFolder,gblConst.GENERAL_OPTIONS_FILE,Data)
		ProcessAutoBootFlag(Data.Get("sboot").As(Boolean))
		config.ReadGeneralCFG
		CallSub(mpage.oPageCurrent,"Set_focus")
		'CallSubDelayed(B4XPages.MainPage,"Build_RightSideMenu")
	End If
	
	Main.tmrTimerCallSub.CallSubDelayedPlus(Main,"Dim_ActionBar_Off",300)
	
End Sub


Private Sub dlgGeneral_IsValid (TempData As Map) As Boolean 'ignore
	Return True '--- all is good!
	'--- NOT USED BUT HERE IF NEEDED
	
'	Try
'		Dim number As Int = TempData.GetDefault("days", 1)
'		If number < 1 Or number > 14 Then
'			guiHelpers.Show_toast("Days must be between 1 and 14",1200)
'			pdlgLogging.ScrollToItemWithError("days")
'			Return False
'		End If
'		Return True
'	Catch
'		Log(LastException)
'	End Try
'	Return False

End Sub



Private Sub dlgGeneral_BeforeDialogDisplayed (Template As Object)
	prefHelper.SkinDialog(Template)
	
	For i = 0 To mGeneralDlg.PrefItems.Size - 1
		Dim pi As B4XPrefItem = mGeneralDlg.PrefItems.Get(i)
		If pi.ItemType = mGeneralDlg.TYPE_BOOLEAN Then
'			Dim ft As B4XFloatTextField = mGeneralDlg.CustomListView1.GetPanel(i).GetView(0).Tag
'			ft.TextField.Font = xui.CreateDefaultBoldFont(14)    'or whatever you want
'			'rest
		End If
	Next
	
End Sub


Private Sub ProcessAutoBootFlag(Enabled As Boolean)
	
	Dim fname As String = "autostart.bin"
	If Enabled Then
		If File.Exists(xui.DefaultFolder,fname) Then Return
		File.WriteString(xui.DefaultFolder,fname,"boot")
	Else
		fileHelpers.SafeKill(fname)
	End If
	
End Sub

