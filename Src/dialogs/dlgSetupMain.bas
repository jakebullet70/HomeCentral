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
	Private oldTheme As String
	
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
		objHelpers.Map2Disk2(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP, CreateMap( _
					gblConst.KEYS_MAIN_SETUP_AUTO_BOOT: False, _
					gblConst.KEYS_MAIN_SETUP_SCRN_BLANK_TIME : 120, _
					gblConst.KEYS_MAIN_SETUP_SCRN_CTRL_MORNING_TIME : d1, _
					gblConst.KEYS_MAIN_SETUP_SCRN_CTRL_EVENING_TIME: d2, _
					gblConst.KEYS_MAIN_SETUP_SCRN_CTRL_ON: False, _
					gblConst.KEYS_MAIN_SETUP_PAGE_WEATHER: True, _
					gblConst.KEYS_MAIN_SETUP_PAGE_PHOTO: False, _
					gblConst.KEYS_MAIN_SETUP_PAGE_CALC: True, _
					gblConst.KEYS_MAIN_SETUP_PAGE_CONV: True, _
					gblConst.KEYS_MAIN_SETUP_PAGE_TIMERS: True, _
					gblConst.KEYS_MAIN_SETUP_PAGE_WEB: False, _
					gblConst.KEYS_MAIN_SETUP_PAGE_THEME: "Red" _
					))
		
	End If
	
End Sub

Private Sub DoesMenuNeedRebuild(newData As Map, OldData As Map) As Boolean
	
	Return _
		(newData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_WEATHER) <> OldData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_WEATHER)) Or _
		(newData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_PHOTO) <> OldData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_PHOTO)) Or _
		(newData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_CALC) <> OldData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_CALC)) Or _
		(newData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_CONV) <> OldData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_CONV)) Or _
		(newData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_WEB) <> OldData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_WEB)) Or _
		(newData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_TIMERS) <> OldData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_TIMERS))
		
End Sub


Public Sub Show
	
	oldTheme = config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_THEME)
	
	pf.Initialize(mpage.root, "General Settings", 460, 440)
	
	pf.LoadFromJson(File.ReadString(File.DirAssets,"setup_main.json"))
	pf.SetEventsListener(Me,"dlgGeneral")
		
	prefHelper.Initialize(pf)
	Dim data As Map = prefHelper.MapFromDisk2(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP) '--- DO NOT USE	File.ReadMap Or File.WriteMap
	Dim PrevData As Map = objHelpers.CopyObject(data)
	
	prefHelper.pDefaultFontSize = 18
	prefHelper.ThemePrefDialogForm
	pf.PutAtTop = False
	Dim RS As ResumableSub = pf.ShowDialog(data, "SAVE", "CANCEL")
	'prefHelper.dlgHelper.ThemeDialogBtnsResize '--- now done in dlgGeneral_BeforeDialogDisplayed
	
	Wait For (RS) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then

		guiHelpers.Show_toast("Data Saved")
		prefHelper.Map2Disk2(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP, data) '--- DO NOT USE	File.ReadMap Or File.WriteMap
		
		ProcessAutoBootFlag(data.Get(gblConst.KEYS_MAIN_SETUP_AUTO_BOOT).As(Boolean))
		
		config.ReadMainSetup
		
		If DoesMenuNeedRebuild(data,PrevData) Then
			'Log("rebild menu")
			Dim Const GoHome As Int = -2 
			guiHelpers.Show_toast2("Rebulding Menu",3000)
			CallSubDelayed2(mpage,"segTabMenu_TabChanged",GoHome)
			mpage.segTabMenu.Index = 0
			Sleep(1500)
			Menus.BuildHeaderMenu(mpage.segTabMenu,mpage,"segTabMenu")
			Sleep(0)
		End If
		
		If oldTheme <> config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_THEME) Then
			guiHelpers.Show_toast2("Restart to apply theme change",2500)	
		End If
		
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


Private Sub ProcessAutoBootFlag(Enabled As Boolean)
		
	If Enabled Then
		If File.Exists(xui.DefaultFolder,gblConst.FILE_AUTO_START_FLAG) Then Return
		File.WriteString(xui.DefaultFolder,gblConst.FILE_AUTO_START_FLAG,"boot")
	Else
		fileHelpers.SafeKill(xui.DefaultFolder,gblConst.FILE_AUTO_START_FLAG)
	End If
	
End Sub

