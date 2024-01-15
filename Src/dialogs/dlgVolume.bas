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
	
	Private Label2,Label3,Label1 As B4XView
	Private cboSounds As B4XComboBox
	Private sbTimerVol As B4XSeekBar
	Private sbSystemVol As B4XSeekBar
	
	Private chkMute As CheckBox
	Private btnTest As Button
	Private lblSysVol As B4XView
	Private lblTmrVol As B4XView
	Private pnlTimerVol As B4XView
	Private pnlSystemVol As B4XView
End Sub

Public Sub Initialize(dlg As B4XDialog) 
	mDialog = dlg
End Sub


Public Sub Show()
	
	'--- init
	mDialog.Initialize(mpage.Root)
	Dim dlgHelper As sadB4XDialogHelper
	dlgHelper.Initialize(mDialog)
	
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, 640dip,390dip)
	p.LoadLayout("dlgVolumeSettings")
	
	pnlMain.Color = clrTheme.Background
	guiHelpers.SetTextColor(Array As B4XView(Label2,Label3,Label1,lblTmrVol,lblSysVol),clrTheme.txtNormal)
	guiHelpers.SkinButton(Array As Button(btnTest))

	'guiHelpers.ResizeText("Test",btnTest) : btnTest.textsize = btnTest.textsize -4
	btnTest.Text = "Test"
	'guiHelpers.SetCBDrawable(chkMute, clrTheme.txtNormal, 1,clrTheme.txtNormal, Chr(8730), Colors.LightGray, 32dip, 2dip)
	guiHelpers.ReSkinB4XComboBox(Array As B4XComboBox(cboSounds))
	guiHelpers.SetPanelsBorder(Array As B4XView(pnlTimerVol,pnlSystemVol),clrTheme.txtAccent)
	
	guiHelpers.ResizeText("100%",lblSysVol)
	lblTmrVol.TextSize = lblSysVol.TextSize
	
	cboSounds.cmbBox.AddAll(Array As String( _
				"ktimers_alarm01.ogg","ktimers_alarm02,ogg","ktimers_alarm03.ogg","ktimers_alarm04.ogg","ktimers_alarm05.ogg"))
	guiHelpers.ReSkinB4XSeekBar(Array As B4XSeekBar(sbTimerVol,sbSystemVol))
	
	dlgHelper.ThemeDialogForm("System Volumes")
	Dim rs As ResumableSub = mDialog.ShowCustom(p, "SAVE", "", "CANCEL")
	dlgHelper.ThemeDialogBtnsResize
	
	Try
		sbSystemVol.Value 	= ph.GetVolume(ph.VOLUME_MUSIC)
	Catch
		guiHelpers.Show_toast2(gblConst.VOLUME_ERR,4500)
		Log(LastException)
	End Try
	sbTimerVol.Value 	= Main.kvs.Get(gblConst.INI_SOUND_ALARM_VOLUME)
	sbSystemVol_ValueChanged(sbSystemVol.Value)
	sbTimerVol_ValueChanged(sbTimerVol.Value)
	'cboSounds.cmbBox.te
	
	Wait For (rs) Complete (i As Int)
	If i = xui.DialogResponse_Positive Then '--- save
		Main.kvs.Put(gblConst.INI_SOUND_ALARM_VOLUME,sbTimerVol.Value)
		Main.kvs.Put(gblConst.INI_SOUND_ALARM_FILE,cboSounds.SelectedItem)
		ph.SetVolume(
	End If
	
End Sub



Private Sub sbSystemVol_ValueChanged (Value As Int)
	lblSysVol.Text = Value & "%"
End Sub

Private Sub sbTimerVol_ValueChanged (Value As Int)
	lblTmrVol.Text = Value & "%"
End Sub