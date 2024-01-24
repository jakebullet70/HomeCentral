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
	Private pf As sadPreferencesDialog
	Private prefHelper As sadPreferencesDialogHelper
	
End Sub

Public Sub Initialize(pfdlg As sadPreferencesDialog) 
	pf = pfdlg
End Sub


public Sub CreateDefaultFile
	
	If File.Exists(xui.DefaultFolder,gblConst.FILE_MAIN_SETUP) = False Then
		Dim d1,d2 As Period
		d1.Hours = 6 : d1.Minutes = 30
		d2.Hours = 18 : d2.Minutes = 30
		
		'--- DO NOT USE	File.ReadMap Or File.WriteMap
		'--- DO NOT USE	File.ReadMap Or File.WriteMap
		objHelpers.Map2Disk2(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP, _
					CreateMap( "saboot": "false", "pwroff": 120,  "pwrmt": d1, "pwret": d2,"scrnday":False))
		
	End If
	
End Sub


Public Sub Show
	

	pf.Initialize(mpage.root, "General Settings", 460, 440)
	
	pf.LoadFromJson(File.ReadString(File.DirAssets,"setup_main.json"))
	pf.SetEventsListener(Me,"dlgGeneral")
		
	prefHelper.Initialize(pf)
	Dim data As Map = prefHelper.MapFromDisk2(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP) '--- DO NOT USE	File.ReadMap Or File.WriteMap
	
	prefHelper.pDefaultFontSize = 18
	prefHelper.ThemePrefDialogForm
	pf.PutAtTop = False
	Dim RS As ResumableSub = pf.ShowDialog(data, "SAVE", "CANCEL")
	'prefHelper.dlgHelper.ThemeDialogBtnsResize '--- now done in dlgGeneral_BeforeDialogDisplayed
	
	Wait For (RS) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		guiHelpers.Show_toast("Data Saved")
		
		prefHelper.Map2Disk2(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP, data) '--- DO NOT USE	File.ReadMap Or File.WriteMap
		
		ProcessAutoBootFlag(data.Get("saboot").As(Boolean))
		
		config.ReadMainSetup
		CallSub(mpage.oPageCurrent,"Set_focus")
		'CallSubDelayed(B4XPages.MainPage,"Build_RightSideMenu")
	End If
	
	mpage.tmrTimerCallSub.CallSubDelayedPlus(Main,"Dim_ActionBar_Off",300)
	CallSubDelayed(mpage,"ResetScrn_SleepCounter")
	
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
End Sub


Private Sub ProcessAutoBootFlag(Enabled As Boolean)
	
	Dim fname As String = "autostart.bin"
	If Enabled Then
		If File.Exists(xui.DefaultFolder,fname) Then Return
		File.WriteString(xui.DefaultFolder,fname,"boot")
	Else
		fileHelpers.SafeKill(xui.DefaultFolder,fname)
	End If
	
End Sub

