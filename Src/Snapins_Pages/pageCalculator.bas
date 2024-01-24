B4J=true
Group=Pages-Snapins
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  klaus - B4x forum
#Region VERSIONS 
' V. 2.0 	Dec/26/2023 - sadLogic
'			Original fails to run in newer B4A versions. Coverted to B4X Pages
'			Removed scientific calculations, refactored view and themed it!
' V. 1.X	2012-2014 Klaus from the B4X forum
'			https://www.b4x.com/android/forum/threads/tape-calculator.6981/#content
#End Region


Sub Class_Globals
	Private XUI As XUI
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private pnlMain As B4XView
	
	Private XUI As XUI
	Private stu As StringUtils
	
	Private lblPaperRoll As Label
	Private ScaleAuto As Double
	
	Private sVal = "" As String
	Private Val = 0 As Double
	Private Op0 = "" As String
	Private Result = 0 As Double
	Private Txt = "" As String
	Private New = 0 As Int
	
	Private btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9 As Button
	Private btna, btnb, btnc, btnd, btne, btnp As Button
	Private btnBack, btnClr, btnExit As Button

	Private btnCharSize As ToggleButton
	Private pnlKeyboard As Panel
	Private scvPaperRoll As ScrollView
	
	
	Private imgPaperTape As lmB4XImageViewX
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pageCalculatorBase")
	
	ScaleAuto = 1 + 0.5 * ((100%x + 100%y) / (320dip + 430dip) - 1)
	
	lblPaperRoll.Initialize("lblPaperRoll")
	scvPaperRoll.Panel.AddView(lblPaperRoll, 0, 0, imgPaperTape.Width, scvPaperRoll.Height)
	
	scvPaperRoll.Panel.Height = scvPaperRoll.Height
	lblPaperRoll.TextSize = 24 * ScaleAuto
	lblPaperRoll.Color = XUI.Color_Transparent'Colors.White
	lblPaperRoll.TextColor = XUI.Color_Black
	
	imgPaperTape.Bitmap = XUI.LoadBitmap(File.DirAssets,"paper-tape.png")
	'scvPaperRoll.Color = XUI.Color_Transparent
	
	scvPaperRoll.BringToFront
	
	guiHelpers.SkinButton(Array As Button(btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9, _
									btna, btnb, btnc, btnd, btne, btnp,btnBack, btnClr, btnExit))
	
	guiHelpers.ResizeText("0",btn0)
	guiHelpers.SetTextSize(Array As B4XView(btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9, _
									btna, btnb, btnc, btnd, btne, btnp, btnExit),(btn0.TextSize - 10))
	btnClr.Text = "Clear Tape"
	btnBack.TextSize = btna.TextSize - 16
End Sub

'-------------------------------

Public Sub Set_focus()
	mpage.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Side_Menu",250)
	Menus.SetHeader("Calculator","main_menu_calc.png")
	pnlMain.SetVisibleAnimated(500,True)
End Sub
Public Sub Lost_focus()
	pnlMain.SetVisibleAnimated(500,False)
End Sub
Private Sub Page_Setup
	guiHelpers.Show_toast2("No setup for this page",3500)
End Sub

Private Sub Build_Side_Menu
	Menus.BuildSideMenu(Array As String(""),Array As String(""))
End Sub

'=============================================================================================
'=============================================================================================
'=============================================================================================



Private Sub btnDigit_Click
	Dim b As String = Sender.As(B4XView).Tag
	If New = 0 Then New = 1
	
	Select b
		Case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "3.1415926535897932", "."
			Select Op0
				Case "g", "s", "m", "x"
					Return
			End Select

			If Op0 = "e" Then
				Txt = Txt & CRLF & CRLF
				sVal = ""
				Op0 = ""
				Result = 0
				New = 0
			End If

			If b = "3.1415926535897932" Then
				If sVal <> "" Then
					Return
				End If
				Txt = Txt & cPI
				sVal = cPI
			Else If b = "." Then
				If sVal.IndexOf(".") < 0 Then
					Txt = Txt & b
					sVal = sVal & b
				End If
			Else
				Txt = Txt & b
				sVal = sVal & b
			End If
		Case "a", "b", "c", "d", "e", "y"
			If sVal ="" Then
				Select Op0
					Case "a", "b", "c", "d", "y", ""
						Return
				End Select
				sVal = Result
			End If
			GetValue(b)
		Case "g", "s", "x"
			If sVal = "" Then
				Select Op0
					Case "a", "b", "c", "d", "y", ""
						Return
				End Select
				sVal = Result
			End If
			If Op0 = "" Then
				Result = sVal
			End If
			GetValue(b)
		Case "f"
			If Op0 = "e" Then
				Txt = Txt & CRLF & CRLF
				New = 0
				sVal = ""
				Op0 = ""
			End If
	End Select

	UpdateTape
End Sub

Private Sub GetValue(Op As String)
	If Op0 = "e" And (Op = "s" Or Op = "g" Or Op = "x") Then
		Val = Result
	Else
		Val = sVal
	End If
	
	sVal = ""
	
	If Op = "g" Or Op = "s" Or Op = "x" Then
		If Op0 = "a" Or Op0 = "b" Or Op0 = "c" Or Op0 = "d" Or Op0 = "y" Then
			CalcResult(Op0)
			Txt = Txt & "  = " & Result
		End If
		Operation(Op)
		CalcResult(Op)
		Txt = Txt & "  = " & Result
		Op0 = Op
		Op0 = "e"
		Op = "e"
		Return
	End If
	
	If New = 1 Then
		Result = Val
		Operation(Op)
		If Op = "g" Or Op = "s" Or Op = "x" Then
			CalcResult(Op)
			Txt = Txt & "  = " & Result
			Op = "e"
		End If
		UpdateTape
		New = 2
		Op0 = Op
		Return
	End If
	
	If Op = "e" Then
		If Op0 = "e" Then
			Return
		End If
		Txt = Txt & CRLF & " =  "
		CalcResult(Op0)
		Txt = Txt & Result
	Else
		If Op0 = "g" Or Op0 = "s" Or Op0 = "x" Then
			Operation(Op)
			Op0 = Op
			Return
		End If
		
		CalcResult(Op0)
		If Op0<>"e" Then
			Txt = Txt & "  = " & Result
		End If
		Operation(Op)
		If Op = "g" Or Op = "s" Or Op = "x" Then
			CalcResult(Op)
			Txt = Txt & "  = " & Result
			Op = "e"
		End If
	End If
	Op0 = Op
End Sub

Private Sub Operation(Op As String)
	Select Op
		Case "a"
			Txt = Txt & CRLF & "+ "
		Case "b"
			Txt = Txt & CRLF & "- "
		Case "c"
			Txt = Txt & CRLF & "* "
		Case "d"
			Txt = Txt & CRLF & "/ "
'		Case "g"
'			Txt = Txt & CRLF & "x2 "
'		Case "s"
'			Txt = Txt & CRLF & "√ "
'		Case "x"
'			Txt = Txt & CRLF & "1/x "
'		Case "y"
'			Txt = Txt & CRLF & "% "
	End Select
End Sub

Private Sub CalcResult(Op As String)
	Select Op
		Case "a"
			Result = Result + Val
		Case "b"
			Result = Result - Val
		Case "c"
			Result = Result * Val
		Case "d"
			Result = Result / Val
		Case "g"
			Result = Result * Result
		Case "s"
			Result = Sqrt(Result)
		Case "x"
			If Result <> 0 Then
				Result = 1 / Result
			End If
		Case "y"
			Result = Result * Val / 100
	End Select
End Sub

Private Sub UpdateTape
	Dim h As Float
	
	'/Log(Txt)
	
	lblPaperRoll.Text = Txt

	h = stu.MeasureMultilineTextHeight(lblPaperRoll, Txt)
	If h > scvPaperRoll.Height Then
		lblPaperRoll.Height = h
		scvPaperRoll.Panel.Height = h
		Sleep(0)
		scvPaperRoll.ScrollPosition = h
	End If
	CallSubDelayed(mpage,"ResetScrn_SleepCounter")
End Sub

Private Sub btnClr_Click
	Dim o As dlgThemedMsgBox : o.Initialize
	Wait For (o.Show("Do you really want To clear the calculation?","A T T E N T I O N","YES", "", "CANCEL")) Complete (i As Int)
	If i = XUI.DialogResponse_Positive Then
		Val = 0
		sVal = ""
		Result = 0
		New = 0
		Txt = ""
		Op0 = ""
		lblPaperRoll.Text = ""
		lblPaperRoll.Height = scvPaperRoll.Height
		scvPaperRoll.Panel.Height = scvPaperRoll.Height
	End If
End Sub

Private Sub btnBack_Click
	If sVal.Length > 0 Then
		Txt = sVal.SubString2(0, sVal.Length - 1)
		sVal = sVal.SubString2(0, sVal.Length - 1)
		UpdateTape
	End If
End Sub

Private Sub btnCharSize_CheckedChange(Checked As Boolean)
	If Checked = False Then
		lblPaperRoll.TextSize = 17 * ScaleAuto
	Else
		lblPaperRoll.TextSize = 24 * ScaleAuto
	End If
End Sub


