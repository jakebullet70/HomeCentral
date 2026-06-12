B4J=true
Group=B4XcustomClasses
ModulesStructureVersion=1
Type=Class
Version=9.5
@EndOfDesignText@
' Author:  sadLogic
' Helper class for B4XDialog V11.8
#Region VERSIONS 
' V1.0  Nov/8/2022	1st run.
#End Region

Sub Class_Globals
	Private xui As XUI
	Private dlg As B4XDialog
	Private Scale As Float
End Sub

Public Sub Initialize(oDlg As B4XDialog) 
	dlg = oDlg
	'dlg.VisibleAnimationDuration = 300
	'dlg.BlurBackground = False
	Dim ac As Accessibility
	'--- scale is returned from Android Text size in setup
	Scale = ac.GetUserFontScale
End Sub


'https://www.b4x.com/android/forum/threads/b4x-b4xdialog-with-adjustable-button-widths.169198/
'Private Sub ArrangeButtons(Dialog1 As B4XDialog, Canvas1 As B4XCanvas)
'	Dim offset As Int = Dialog1.Base.Width - 2dip
'	Dim gap As Int = 4dip
'	For Each BtnType As Int In Array(xui.DialogResponse_Cancel, xui.DialogResponse_Negative, xui.DialogResponse_Positive)
'		For Each btn As B4XView In Dialog1.Base.GetAllViewsRecursive
'			If Initialized(btn.Tag) And btn.Tag = BtnType Then 'ignore
'				Dim r As B4XRect = Canvas1.MeasureText(btn.Text, btn.Font)
'				Dim width As Float = r.Width + 30dip 'change padding as needed
'				btn.SetLayoutAnimated(0, offset - width - gap, btn.Top, width, btn.Height)
'				offset = offset - width - gap
'			End If
'		Next
'	Next
'End Sub


Public Sub ThemeInputDialogBtnsResize()
	
	Try '--- reskin button, if it does not exist then skip the error
		Dim btnCancel As B4XView = dlg.GetButton(xui.DialogResponse_Cancel)
		btnCancel.Font = xui.CreateDefaultFont(NumberFormat2(btnCancel.Font.Size / Scale,1,0,0,False))
		btnCancel.Width = btnCancel.Width + 20dip
		btnCancel.Left = btnCancel.Left - 28dip
		btnCancel.SetColorAndBorder(xui.Color_Transparent,2dip,clrTheme.txtNormal,8dip)
		btnCancel.Height = btnCancel.Height - 4dip '--- resize height just a hair
		btnCancel.Top = btnCancel.Top + 4dip
	Catch
		'Log(LastException)
	End Try 'ignore
	
	Try '--- reskin button, if it does not exist then skip the error
		Dim btnOk As B4XView = dlg.GetButton(xui.DialogResponse_Positive)
		btnOk.Font = xui.CreateDefaultFont(NumberFormat2(btnOk.Font.Size / Scale,1,0,0,False))
		btnOk.Width = btnOk.Width + 20dip
		btnOk.Left = btnOk.Left - 48dip
		btnOk.SetColorAndBorder(xui.Color_Transparent,2dip,clrTheme.txtNormal,8dip)
		btnOk.Height = btnOk.Height - 4dip '--- resize height just a hair
		btnOk.Top = btnOk.Top + 4dip
	Catch
		'Log(LastException)
	End Try 'ignore
	
'	Try '--- reskin button, if it does not exist then skip the error
'		Dim btnNo As B4XView = dlg.GetButton(xui.DialogResponse_Negative)
'		btnNo.Font = xui.CreateDefaultFont(NumberFormat2(btnNo.Font.Size / gFscale,1,0,0,False))
'		btnNo.Width = btnOk.Width + 20dip
'		btnNo.Left = btnOk.Left - 48dip
'		btnNo.SetColorAndBorder(xui.Color_Transparent,2dip,xui.Color_White,8dip)
'	Catch
'		'Log(LastException)
'	End Try 'ignore
	
End Sub



Public Sub   ThemeDialogBtnsResize()
	
	
	Try '--- reskin button, if it does not exist then skip the error
		Dim btnCancel As B4XView = dlg.GetButton(xui.DialogResponse_Cancel)
		btnCancel.Font = xui.CreateDefaultFont(NumberFormat2(btnCancel.Font.Size / Scale,1,0,0,False))
		btnCancel.Width = btnCancel.Width + 20dip
		btnCancel.Left = btnCancel.Left - 28dip
		btnCancel.SetColorAndBorder(xui.Color_Transparent,2dip,clrTheme.txtNormal,8dip)
		btnCancel.Height = btnCancel.Height - 4dip '--- resize height just a hair
		btnCancel.Top = btnCancel.Top + 4dip
	Catch
		'Log(LastException)
	End Try 'ignore
	
	Try '--- reskin button, if it does not exist then skip the error
		Dim btnOk As B4XView = dlg.GetButton(xui.DialogResponse_Positive)
		btnOk.Font = xui.CreateDefaultFont(NumberFormat2(btnOk.Font.Size / Scale,1,0,0,False))
		btnOk.Width = btnOk.Width + 20dip
		btnOk.Left = btnOk.Left - 48dip
		btnOk.SetColorAndBorder(xui.Color_Transparent,2dip,clrTheme.txtNormal,8dip)
		btnOk.Height = btnOk.Height - 4dip '--- resize height just a hair
		btnOk.Top = btnOk.Top + 4dip
	Catch
		'Log(LastException)
	End Try 'ignore

	Try '--- reskin button, if it does not exist then skip the error
		Dim btnNo As B4XView = dlg.GetButton(xui.DialogResponse_Negative)
		btnNo.Font = xui.CreateDefaultFont(NumberFormat2(btnNo.Font.Size / Scale,1,0,0,False))
		btnNo.Width = btnNo.Width + 20dip
		btnNo.Left = btnNo.Left - 48dip
		btnNo.SetColorAndBorder(xui.Color_Transparent,2dip,clrTheme.txtNormal,8dip)
		btnNo.Height = btnNo.Height - 4dip '--- resize height just a hair
		btnNo.Top = btnNo.Top + 4dip
	Catch
		'Log(LastException)
	End Try 'ignore

	
End Sub



Public Sub ThemeDialogForm(title As Object)
	Dim size As Float = IIf(guiHelpers.gScreenSizeAprox > 6,25,22)
	ThemeDialogForm2(title,size)
End Sub


Public Sub ThemeDialogForm2(title As Object,txtSize As Int)
	
	Try
		dlg.Title = title
		If guiHelpers.gScreenSizeAprox > 5.5 Then
			dlg.TitleBarHeight=6%y
		End If
	Catch
		'--- errors sometimes, I think... something to do with the title not showing on smaller screens
		'--- b4xdialog.PutAtTop = False  <----   this!
		'Log("ThemeDialogForm-set title: " & LastException)
	End Try 'ignore
	
	dlg.TitleBarFont = xui.CreateDefaultFont(NumberFormat2(txtSize / Scale,1,0,0,False))
	dlg.TitleBarColor = clrTheme.BackgroundHeader
	dlg.TitleBarTextColor = clrTheme.txtNormal
	dlg.ButtonsTextColor = clrTheme.txtNormal
	dlg.BorderColor = clrTheme.txtNormal
	dlg.BackgroundColor = clrTheme.Background2
	dlg.ButtonsFont = xui.CreateDefaultFont(txtSize)
	dlg.ButtonsHeight = 60dip
	dlg.BorderCornersRadius = 4dip
	dlg.BodyTextColor = clrTheme.txtAccent
	'dlg.BorderWidth=4dip
	
	
End Sub


Public Sub AnimateDialog (FromEdge As String)
	Dim base As B4XView = dlg.Base
	Dim top As Int = base.Top
	Dim left As Int = base.Left
	Select FromEdge.ToLowerCase
		Case "bottom"
			base.Top = base.Parent.Height
		Case "top"
			base.Top = -base.Height
		Case "left"
			base.Left = -base.Width
		Case "right"
			base.Left = base.Parent.Width
	End Select
	base.SetLayoutAnimated(220, left, top, base.Width, base.Height)
End Sub


Public Sub NoCloseOn2ndDialog
	'dlg.Dialog.Base.Parent.Tag = "" 'this will prevent the dialog from closing when the second dialog appears.
	dlg.Base.Parent.Tag = "" 'this will prevent the dialog from closing when the second dialog appears.
End Sub
