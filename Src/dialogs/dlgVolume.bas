B4A=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=11.5
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' V. 1.0 	Jan/14/2024
'			Its alive!
#End Region

Sub Class_Globals
	Private ph As Phone
	
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private xui As XUI
	Private mDialog As B4XDialog
	Private pnlMain As B4XView
	
	Private Label3,Label1 As B4XView
	Private cboSounds As B4XComboBox
	Private sbTimerVol As B4XSeekBar
	
	Private btnTest As Button
	Private lblTmrVol As B4XView
	Private pnlTimerVol As B4XView
	
	'--- for SOUND check
	Private MP_Test As MediaPlayer
	Private mpVol As Int  'ignore
	'--- END
	
	Private MaxVolumeMusic,MaxVolumeNotifaction,MaxVolumeSys As Int 'ignore
	
End Sub

Public Sub Initialize(dlg As B4XDialog) 
	mDialog = dlg
	
'	If mpage.DebugLog Then
'		Log("music vol max: " & ph.GetMaxVolume(ph.VOLUME_MUSIC))
'		Log("sys vol max: " & ph.GetMaxVolume(ph.VOLUME_SYSTEM))
'		Log("notifaction vol max: " & ph.GetMaxVolume(ph.VOLUME_NOTIFICATION))
'	End If

	MaxVolumeMusic = 		ph.GetMaxVolume(ph.VOLUME_MUSIC)
	MaxVolumeNotifaction = 	ph.GetMaxVolume(ph.VOLUME_NOTIFICATION)
	MaxVolumeSys = 			ph.GetMaxVolume(ph.VOLUME_SYSTEM)
	
	
	
End Sub


' 'kt' = timers
Public Sub Show(VolType As String)
	
	'--- init
	mDialog.Initialize(mpage.Root)
	Dim dlgHelper As sadB4XDialogHelper
	dlgHelper.Initialize(mDialog)
	
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, 640dip,290dip)
	p.LoadLayout("dlgVolumeSettings")
	
	pnlMain.Color = clrTheme.Background
	guiHelpers.SetTextColor(Array As B4XView(Label3,Label1,lblTmrVol),clrTheme.txtNormal)
	guiHelpers.SkinButton(Array As Button(btnTest))

	
	btnTest.Text = "Test"
	'guiHelpers.SetCBDrawable(chkMute, clrTheme.txtNormal, 1,clrTheme.txtNormal, Chr(8730), Colors.LightGray, 32dip, 2dip)
	guiHelpers.ReSkinB4XComboBox(Array As B4XComboBox(cboSounds))
	guiHelpers.SetPanelsBorder(Array As B4XView(pnlTimerVol),clrTheme.txtAccent)
	
	guiHelpers.ResizeText("100%",lblTmrVol)
	
	cboSounds.cmbBox.AddAll(Array As String( _
				"ktimers_alarm01.ogg","ktimers_alarm02,ogg","ktimers_alarm03.ogg","ktimers_alarm04.ogg","ktimers_alarm05.ogg"))

	guiHelpers.ReSkinB4XSeekBar(Array As B4XSeekBar(sbTimerVol))
	
	If VolType = "kt" Then
		dlgHelper.ThemeDialogForm("Timer Volume") '--- kitchen timers
	Else
		dlgHelper.ThemeDialogForm("Volume ?") '--- ONLY ktimers is calling this at the moment.
	End If
	
	Dim rs As ResumableSub = mDialog.ShowCustom(p, "SAVE", "", "CANCEL")
	dlgHelper.ThemeDialogBtnsResize
	
	Try
		'--- check and see if we can access the vol
		'https://www.b4x.com/android/forum/threads/set-volume-error.92938/
		Log("current sys vol: " & ph.GetVolume(ph.VOLUME_SYSTEM))
		Dim tmp As Int = ph.GetVolume(ph.VOLUME_MUSIC)'ignore
	Catch
		guiHelpers.Show_toast2(gblConst.VOLUME_ERR,4500)
		Log(LastException)
	End Try
	
	sbTimerVol.Value 	= Main.kvs.Get(gblConst.INI_TIMERS_ALARM_VOLUME)
	sbTimerVol_ValueChanged(sbTimerVol.Value)
	
	Wait For (rs) Complete (i As Int)
	If i = xui.DialogResponse_Positive Then '--- save
		Main.kvs.Put(gblConst.INI_TIMERS_ALARM_VOLUME,sbTimerVol.Value)
		Main.kvs.Put(gblConst.INI_TIMERS_ALARM_FILE,cboSounds.SelectedItem)
	End If
	
End Sub


Private Sub sbTimerVol_ValueChanged (Value As Int)
	lblTmrVol.Text = Value & "%"
End Sub

Private Sub btnTest_Click
	Dim vol As Int = sbTimerVol.Value * ("0." & MaxVolumeMusic)
	mpVol = ph.GetVolume(ph.VOLUME_MUSIC) '--- save old volume
	ph.SetVolume(ph.VOLUME_MUSIC, vol, False)
	MP_Test.Initialize()
	MP_Test.Load(File.DirAssets,cboSounds.SelectedItem)
	MP_Test.Play
End Sub


