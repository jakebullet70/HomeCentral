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
		
		Dim ser As B4XSerializator '--- in the RandomAccessFile jar
		File.WriteBytes(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP, _
					ser.ConvertObjectToBytes(CreateMap( "saboot": "false", "pwroff": 45,  "pwrmt": d1, "pwret": d2)))
		
	End If
	
End Sub


Public Sub Show
	
	Dim ser As B4XSerializator '--- in the RandomAccessFile jar
	Dim data As Map = ser.ConvertBytesToObject(File.ReadBytes(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP))
			
	pf.Initialize(mpage.root, "General Settings", 400, 440)
	
	pf.LoadFromJson(File.ReadString(File.DirAssets,"setup_main.json"))
	pf.SetEventsListener(Me,"dlgGeneral")
	
	
	prefHelper.Initialize(pf)
	'If guiHelpers.gIsPortrait Then prefHelper.pDefaultFontSize = 17
	prefHelper.ThemePrefDialogForm
	pf.PutAtTop = False
	Dim RS As ResumableSub = pf.ShowDialog(data, "OK", "CANCEL")
	prefHelper.dlgHelper.ThemeDialogBtnsResize
	
	Wait For (RS) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		guiHelpers.Show_toast("Data Saved")
		
		File.WriteBytes(xui.DefaultFolder, gblConst.FILE_MAIN_SETUP, ser.ConvertObjectToBytes(data))
		
		ProcessAutoBootFlag(data.Get("saboot").As(Boolean))
		
		config.ReadMainSetup
		CallSub(mpage.oPageCurrent,"Set_focus")
		'CallSubDelayed(B4XPages.MainPage,"Build_RightSideMenu")
	End If
	
	mpage.tmrTimerCallSub.CallSubDelayedPlus(Main,"Dim_ActionBar_Off",300)
	
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
	
	For i = 0 To pf.PrefItems.Size - 1
		Dim pi As B4XPrefItem = pf.PrefItems.Get(i)
		If pi.ItemType = pf.TYPE_BOOLEAN Then
'			Dim ft As B4XFloatTextField = pf.CustomListView1.GetPanel(i).GetView(0).Tag
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
		fileHelpers.SafeKill(xui.DefaultFolder,fname)
	End If
	
End Sub

