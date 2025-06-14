B4J=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' V. 1.0 	June/9/2025
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


Public Sub CreateDefaultFile
	
	If File.Exists(xui.DefaultFolder,gblConst.FILE_PICS_SETUP) = False Then
		
		'--- DO NOT USE	File.ReadMap Or File.WriteMap, use ObjHelper methods
		objHelpers.Map2Disk2(xui.DefaultFolder, gblConst.FILE_PICS_SETUP, CreateMap( _
					gblConst.KEYS_PICS_SETUP_ACTIVE: False, _
					gblConst.KEYS_PICS_SETUP_START_IN_FULLSCREEN: False, _
					gblConst.KEYS_PICS_SETUP_TURN_ON_AFTER : 30, _
					gblConst.KEYS_PICS_SETUP_SECONDS_BETWEEN: 35, _
					gblConst.KEYS_PICS_SETUP_TRANSITION: "Slide" _
					))
	
		'--- kill the pic list file if there
		fileHelpers.SafeKill(xui.DefaultFolder,gblConst.PIC_LIST_FILE)
		
	End If
	
End Sub


Public Sub Show
	
	'oldTheme = config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_THEME)
	
	pf.Initialize(mpage.root, "Picture Album Settings", 460, 340)
	
	pf.LoadFromJson(File.ReadString(File.DirAssets,"setup_pics.json"))
	pf.SetEventsListener(Me,"dlgGeneral")
		
	prefHelper.Initialize(pf)
	Dim data As Map = prefHelper.MapFromDisk2(xui.DefaultFolder, gblConst.FILE_PICS_SETUP) '--- DO NOT USE	File.ReadMap Or File.WriteMap
	'Dim PrevData As Map = objHelpers.CopyObject(data)
	
	prefHelper.pDefaultFontSize = 18
	prefHelper.ThemePrefDialogForm
	pf.PutAtTop = False
	Dim RS As ResumableSub = pf.ShowDialog(data, "SAVE", "CANCEL")
	'prefHelper.dlgHelper.ThemeDialogBtnsResize '--- now done in dlgGeneral_BeforeDialogDisplayed
	
	Wait For (RS) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then

		guiHelpers.Show_toast("Data Saved")
		prefHelper.Map2Disk2(xui.DefaultFolder, gblConst.FILE_PICS_SETUP,data) '--- DO NOT USE	File.ReadMap Or File.WriteMap
		
		'ProcessAutoBootFlag(data.Get(gblConst.KEYS_MAIN_SETUP_AUTO_BOOT).As(Boolean))
		
		'config.ReadMainSetup
		'config.CalcTimeScreenOnOff	
		
		CallSub(mpage.oPageCurrent,"Set_focus")
		CallSubDelayed(B4XPages.MainPage,"setup_on_off_scrn_event")
		
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

