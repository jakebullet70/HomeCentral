﻿B4A=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=11.5
@EndOfDesignText@
' Author:  sadLogic - Kherson, Ukraine
#Region VERSIONS 
' --- Apr/2025 -- Modified for Home Central
' V. 1.0 	Oct/11/2022
#End Region

Sub Class_Globals
	
	Private const mModule As String = "dlgAppUpdate"' 'ignore
	Private mMainObj As B4XView, xui As XUI
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	
	Private BasePnl As B4XView, mDialog As B4XDialog
	Private lblAction As AutoTextSizeLabel,lblPB As Label
	
	Private btnContinue As Button
	
	Private Const DAYS_BETWEEN_CHECKS As Int = 26

End Sub

Public Sub CleanUpApkDownload
	
	fileHelpers.SafeKill(Main.Provider.SharedFolder,gblConst.APK_NAME)
	fileHelpers.SafeKill(Main.Provider.SharedFolder,gblConst.APK_FILE_INFO)
	fileHelpers.SafeKill(xui.DefaultFolder,gblConst.APK_NAME)
	fileHelpers.SafeKill(xui.DefaultFolder,gblConst.APK_FILE_INFO)
		
End Sub


Public Sub CheckIfNewDownloadAvail()As ResumableSub
	
	'Dim inSub As String = "CheckIfNewDownloadAvail"
	
	Dim oldDate As Long = Main.kvs.GetDefault(gblConst.CHECK_VERSION_DATE,0)
	If oldDate = 0 Then
		Main.kvs.Put(gblConst.CHECK_VERSION_DATE,DateTime.Now) '<-- never been run so save date
		Return False
	End If
	
'	Dim p As Period : p.Days = -12 '--- TESTING ---
'	Dim tdate As Long = DateUtils.AddPeriod(DateTime.Now, p)
'	Main.kvs.Put(gblConst.CHECK_VERSION_DATE,tdate)
'	oldDate = Main.kvs.GetDefault(gblConst.CHECK_VERSION_DATE,0)
	
	Dim days As Int = DateUtils.PeriodBetweenInDays(oldDate,DateTime.Now).As(Period).Days
	'logMe.LogIt("update check - days between: " & days,"")
	LogIt.LogWrite("update check - days between: " & days,0)
	If days < DAYS_BETWEEN_CHECKS Then
		Return False
	End If
	
	
	Dim sm As HttpDownloadStr : sm.Initialize
	Wait For (sm.SendRequest(gblConst.APK_FILE_INFO)) Complete(txt As String)
	
	If txt.Contains("vcode=") = False Then 
		Return False '--- no connection? bad ver info?
	End If
	
	txt = txt.Replace(Chr(13),"") '<-- strip the chr(13) in case its a Windows file
		
	Try
		
		Main.kvs.Put(gblConst.CHECK_VERSION_DATE,DateTime.Now) '--- save version check date
		Dim parts() As String = Regex.Split(CRLF,txt)
		Dim VerCode As String = Regex.Split("=",parts(0))(1)
		
		Return (VerCode.As(Int) > Application.VersionCode)
		
	Catch
		LogIt.LogWrite(LastException.Message,2)
		Return False
		
	End Try
	
End Sub


Public Sub Initialize(dlg As B4XDialog) 
	
	mDialog = dlg
	mMainObj = mpage.Root
	
End Sub

Public Sub Close_Me
	'mDialog.Close(-1)
	mDialog.Close(xui.DialogResponse_Cancel)
End Sub


Public Sub Show() As ResumableSub
	
	CleanUpApkDownload
	BasePnl = xui.CreatePanel("")
	BasePnl.SetLayoutAnimated(0, 0, 0, IIf(guiHelpers.gIsLandScape, 360dip,96%x) ,260dip)
	BasePnl.LoadLayout("viewAppUpdate")
	
	lblAction.TextColor = clrTheme.txtNormal
	lblAction.Text = "Checking for update..."
	btnContinue.Visible = False
	lblPB.Visible   = False
	lblPB.TextColor = clrTheme.txtNormal
	BasePnl.Color = clrTheme.Background

	'---TODO, make a generic function
	guiHelpers.SkinButton(Array As Button(btnContinue))
	btnContinue.TextSize = 22'NumberFormat2(btnContinue.TextSize / guiHelpers.gFscale,1,0,0,False) - IIf(guiHelpers.gFscale > 1,2,0)
		
	'--- init dialog
	mDialog.Initialize(mMainObj)
	Dim dlgHelper As sadB4XDialogHelper
	dlgHelper.Initialize(mDialog)
	
	dlgHelper.ThemeDialogForm("App Update")
	Dim rs As ResumableSub = mDialog.ShowCustom(BasePnl,"","","CLOSE")
	dlgHelper.ThemeInputDialogBtnsResize
	
	'--- grab the txt file with version info
	mpage.tmrTimerCallSub.CallSubDelayedPlus(Me,"Grab_VerInfo",250)

	'--- wait for dialog	
	Wait For (rs) Complete (Result As Int)
	Return Result
	
End Sub


Private Sub Grab_VerInfo

	Sleep(0)
	'--- save version check date
	Main.kvs.Put(gblConst.CHECK_VERSION_DATE,DateTime.Now)
	
	Dim sm As HttpDownloadStr : sm.Initialize
	Wait For (sm.SendRequest(gblConst.APK_FILE_INFO)) Complete(txt As String)
	
	If txt.Contains("vcode=") = False Then
		lblAction.BaseLabel.Height = lblAction.BaseLabel.Height + 20dip
		lblAction.Text = "Error talking to update server."
		Return
	End If
	
	
	txt = txt.Replace(Chr(13),"") '--- strip the chr(13) in case its a Windows file
	
	Try
		
		Dim parts() As String = Regex.Split(CRLF,txt)
		Dim VerCode As String = Regex.Split("=",parts(0))(1)
		
		If VerCode.As(Int) <= Application.VersionCode Then
			lblAction.Text = "No update found."
			Return
		End If
		
		lblAction.BaseLabel.Top = lblAction.BaseLabel.Top - 6dip
		lblAction.Text = $"Update found: V${Regex.Split("=",parts(1))(1)}"$
		btnContinue.Visible = True
		btnContinue.Text = "Download"
		
	Catch
		
		LogIt.LogWrite("GrabVerInfo-" & LastException,2)
		lblAction.Text = "Error parsing update file."
		
	End Try
	
	
End Sub


Private Sub btnCtrl_Click
	
	'--- continue, download the APK
	Dim btn As B4XView = mDialog.GetButton(xui.DialogResponse_Cancel)
	btn.Visible = False
	btnContinue.Visible = False
	'lblPB.Visible = True
	lblAction.Text = "Downloading Update..."
	
		
	Dim DownloadDir As String = GetDownloadDir 'ignore
	
	Dim j As HttpJob : j.Initialize("", Me)
	
	j.Download(gblConst.APK_NAME)
	Wait For (j) JobDone(j As HttpJob)
	Sleep(0)
	
	If j.Success Then
		
		lblAction.Text = "Writing file..."
		Sleep(200)
		
		Dim out As OutputStream = File.OpenOutput(DownloadDir, _
				fileHelpers.GetFilenameFromPath(gblConst.APK_NAME), False)
				
		File.Copy2(j.GetInputStream, out)
		out.Close '<------ very important
		j.Release
		Sleep(200)
		
		mpage.tmrTimerCallSub.CallSubDelayedPlus2(Main,"Start_ApkInstall",300,Array As String(DownloadDir))
		
		mDialog.Close(xui.DialogResponse_Cancel) '<--- close me, exit dialog
		Return

	Else
		
		Dim err As String = ""
		'--- if end point is bad it will have errored aot at downloading the ver text file
		If j.ErrorMessage.Contains("File not") Then err = "File not found"
		lblAction.Text = "Download failed" & CRLF & err
		
	End If
	
	j.Release
	
End Sub


Private Sub GetDownloadDir() As String
	
	'--- its an android version thing...
	Dim dl As String
	Try

		dl = Main.Provider.SharedFolder
		File.WriteString(dl,"t.t","test")
		File.Delete(dl,"t.t")
		
	Catch
		
		dl = xui.DefaultFolder
		LogIt.LogWrite("Main.Provider.SharedFolder ERROR!",2)
		
	End Try 'ignore
	
	Log("App update folder: " & dl)
	Return dl '--- all good
	
End Sub






