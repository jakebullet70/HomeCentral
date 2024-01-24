B4J=true
Group=Helpers
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/Jakebullet
#Region VERSIONS 
' V. 1.0 	Dec/21/2023
#End Region
'Static code module
Sub Process_Globals
	Private xui As XUI
	Private su As StringUtils
	
	Public gScreenSizeAprox As Double = 7 '--- asume a small tablet
	Public gScreenSizeDPI As Int = 0
	Public gIsLandScape As Boolean
	Public gFscale As Float
	Public gWidth As Float
	Public gHeight As Float
	
End Sub


'=====================================================================================
'  Generic GUI helper methods
'=====================================================================================

'Public Sub LstView2BasicListbox(lst As ListView)
'	lst.
'	lst.singleLineDevider = True
'	lst.dividerHeight = 0
'	lst.ChangeItemPressedColor(g.GetLstItemPressedCD(0))
'	lst.DefaultTextColor = darkText
'	lst.DefaultTextSize = 20
'End Sub


'Public Sub SetTextShadow(pView As B4XView, pRadius As Float, pDx As Float, pDy As Float, pColor As Int)
'	'--- Seems to be Android only???????
'	Dim ref As Reflector
'	ref.Target = pView
'	ref.RunMethod4("setShadowLayer", Array As Object(pRadius, pDx, pDy, pColor), Array As String("java.lang.float", "java.lang.float", "java.lang.float", "java.lang.int"))
'End Sub


'Public Sub FontAwesomeToBitmap(Text As String, FontSize As Float) As B4XBitmap
'	Dim xui As XUI
'	Dim p As Panel = xui.CreatePanel("")
'	p.SetLayoutAnimated(0, 0, 0, 32dip, 32dip)
'	Dim cvs1 As B4XCanvas
'	cvs1.Initialize(p)
'	Dim fnt As B4XFont = xui.CreateFontAwesome(FontSize)
'	Dim r As B4XRect = cvs1.MeasureText(Text, fnt)
'	Dim BaseLine As Int = cvs1.TargetRect.CenterY - r.Height / 2 - r.Top
'	cvs1.DrawText(Text, cvs1.TargetRect.CenterX, BaseLine, fnt, xui.Color_White, "CENTER")
'	Dim b As B4XBitmap = cvs1.CreateBitmap
'	cvs1.Release
'	Return b
'End Sub


'---  change color of bitmap - will be used in themeing for light / dark
'--- https://www.b4x.com/android/forum/threads/b4x-bitmapcreator-change-color-of-bitmap.95518/#post-603416
Public Sub ChangeColorBasedOnAlphaLevel(bmp As B4XBitmap, NewColor As Int) As B4XBitmap
	Dim bc As BitmapCreator
	bc.Initialize(bmp.Width, bmp.Height)
	bc.CopyPixelsFromBitmap(bmp)
	Dim a1, a2 As ARGBColor
	bc.ColorToARGB(NewColor, a1)
	For y = 0 To bc.mHeight - 1
		For x = 0 To bc.mWidth - 1
			bc.GetARGB(x, y, a2)
			If a2.a > 0 Then
				a2.r = a1.r
				a2.g = a1.g
				a2.b = a1.b
				bc.SetARGB(x, y, a2)
			End If
		Next
	Next
	Return bc.Bitmap
End Sub


Public Sub SetVisible(Arr() As B4XView,Visible As Boolean)
	For Each v As B4XView In Arr
		v.Visible = Visible
	Next
End Sub


'Public Sub SetTextColorB4XFloatTextField(views() As B4XFloatTextField)
'	
'	For Each o As B4XFloatTextField In views
'		o.TextField.TextColor = clrTheme.txtNormal
'		o.NonFocusedHintColor = clrTheme.txtAccent
'		o.HintColor = clrTheme.txtAccent
'		o.Update
'	Next
'	
'End Sub


Public Sub SetTextSize(obj() As B4XView,size As Float)
	For Each o As B4XView In obj
		o.TextSize = size
	Next
End Sub
'Public Sub SetTextSizeBtns(obj() As B4XView,size As Float)
' ---> use method above, just pass in btns as b4xview
'	For Each o As B4XView In obj
'		o.TextSize = size
'	Next
'End Sub

Public Sub EnableDisableViews(Arr() As B4XView,EnableDisable As Boolean)
	For Each o As B4XView In Arr
		o.enabled = EnableDisable
	Next
End Sub

Public Sub SetTextColor(obj() As B4XView,clr As Int)
	For Each o As B4XView In obj
		o.TextColor = clr
	Next
End Sub



Public Sub ThemeFloatTextField(Arr() As B4XFloatTextField) 'ignore
	For Each o As B4XFloatTextField In Arr
		'--- TODO
	Next
End Sub

'Public Sub BringViews2Front(Arr() As B4XView)
'	For Each o As B4XView In Arr
'		o.BringToFront
'	Next
'End Sub

Public Sub SetPanelsDividers(Arr() As B4XView,clr As Int)
	For Each o As B4XView In Arr
		o.SetColorAndBorder(clr,1dip,clr,3dip)
		o.Color = clr
	Next
End Sub

Public Sub SetPanelsBorder(Arr() As B4XView,clr As Int)
	For Each o As B4XView In Arr
		o.SetColorAndBorder(xui.Color_Transparent,1dip,clr,3dip)
	Next
End Sub

Public Sub SetPanelsTranparent(Arr() As B4XView)
	For Each o As B4XView In Arr
		o.SetColorAndBorder(xui.Color_Transparent,0dip,xui.Color_Transparent,0dip)
	Next
End Sub

'Public Sub SetEnableDisableColor(btnArr() As B4XView)
'	For Each btn As B4XView In btnArr
'		If btn.enabled Then
'			btn.TextColor = clrTheme.txtNormal
'			btn.SetColorAndBorder(xui.Color_Transparent,2dip,clrTheme.txtNormal,8dip)
'		Else
'			btn.TextColor = clrTheme.btnDisableText
'			btn.SetColorAndBorder(xui.Color_Transparent,2dip,clrTheme.btnDisableText,8dip)
'		End If
'	Next
'End Sub
'Public Sub SetEnableDisableColorBtnNoBoarder(btnArr() As B4XView)
'	For Each btn As B4XView In btnArr
'		If btn.enabled Then
'			btn.TextColor = clrTheme.txtNormal
'			btn.SetColorAndBorder(xui.Color_Transparent,0,clrTheme.txtNormal,0)
'		Else
'			btn.TextColor =  clrTheme.btnDisableText
'			btn.SetColorAndBorder(xui.Color_Transparent,0,clrTheme.btnDisableText,0)
'		End If
'	Next
'End Sub

Public Sub ReSkinB4XSeekBar(sb() As B4XSeekBar)
	For Each b As B4XSeekBar In sb
		b.ThumbColor = clrTheme.txtNormal
		b.Color1 = clrTheme.txtAccent
		b.Color2 = clrTheme.txtNormal
	Next
End Sub

Public Sub ReSkinB4XComboBox(cbo() As B4XComboBox)
	
	For Each cb As B4XComboBox In cbo
		Try
			
			'--- change cbo down arrow color - not working Android 4
			Dim jo1 As JavaObject = cb.cmbBox.Background
			Dim p As Phone
			If p.SdkVersion < 29 Then
				jo1.RunMethod("setColorFilter", Array(clrTheme.txtNormal, "SRC_ATOP"))
			Else
				Dim jo2 As JavaObject
				jo2 = jo2.InitializeNewInstance("android.graphics.BlendModeColorFilter", Array(clrTheme.txtNormal, "SRC_ATOP"))
				jo1.RunMethod("setColorFilter", Array(jo2))
			End If
			'-----------
			
			cb.cmbBox.TextColor = clrTheme.txtNormal
			cb.cmbBox.Color = clrTheme.BackgroundHeader
			cb.cmbBox.DropdownBackgroundColor = clrTheme.BackgroundHeader
			cb.cmbBox.DropdownTextColor = clrTheme.txtNormal
		
		Catch
			Log(LastException)
		End Try
		
	Next
End Sub


Public Sub SetTextColorB4XFloatTextField(views() As B4XFloatTextField)
	
	For Each o As B4XFloatTextField In views
		o.TextField.TextColor = clrTheme.txtNormal
		o.NonFocusedHintColor = clrTheme.txtAccent
		o.HintColor = clrTheme.txtAccent
		o.Update
	Next
	
End Sub

'=========================================================================================
'=========================================================================================

Public Sub SkinButtonNoBorder(obj() As Button)
	Dim clrNormal ,clrPressed As Int
	clrNormal = clrTheme.txtNormal
	clrPressed = ChangeColorVisible(clrTheme.txtNormal)
	For Each b As Button In obj
		SetColorTextStateList(b,clrPressed,clrNormal,clrTheme.btnDisableText)
		
		Dim DefaultDrawable, PressedDrawable As ColorDrawable
		DefaultDrawable.Initialize(xui.Color_Transparent,8dip)
		PressedDrawable.Initialize2(clrPressed,8dip,2dip,clrNormal)
		Dim sld1 As StateListDrawable :sld1.Initialize
		sld1.AddState(sld1.State_Pressed, PressedDrawable)
		sld1.AddCatchAllState(DefaultDrawable)
		b.Background = sld1
	Next
End Sub
Public Sub SkinButton(obj() As Button)
	'--- sets the bg and frame color
	Dim clrAccent, clrNormal ,clrPressed As Int
	clrNormal = clrTheme.txtNormal
	clrAccent = clrTheme.txtAccent
	
	clrPressed = ChangeColorVisible(clrTheme.txtNormal)
	For Each btn As Button In obj
		SetColorTextStateList(btn,clrPressed,clrNormal,clrTheme.btnDisableText)
		
		Dim DefaultDrawable, PressedDrawable,DisabledDrawable As ColorDrawable
		DefaultDrawable.Initialize2(xui.Color_Transparent, 8dip,2dip,clrAccent)
		PressedDrawable.Initialize2(clrPressed,8dip,2dip,clrNormal)
		DisabledDrawable.Initialize2(xui.Color_Transparent,8dip,2dip,clrTheme.btnDisableText)
		
		Dim sld1 As StateListDrawable : sld1.Initialize
		sld1.AddState(sld1.State_Pressed, PressedDrawable)
		sld1.AddState(sld1.State_Disabled, DisabledDrawable)
		sld1.AddCatchAllState(DefaultDrawable)
		btn.Background = sld1
	Next
End Sub

Private Sub SetColorTextStateList(Btn As Button,Pressed As Int,Enabled As Int,Disabled As Int)
	'--- sets the text color
	Dim States(3,1) As Int
	States(0,0) = 16842919    'Pressed
	States(1,0) = 16842910    'Enabled
	States(2,0) = -16842910 'Disabled

	Dim Color(3) As Int = Array As Int(Pressed,Enabled,Disabled)

	Dim CSL As JavaObject
	CSL.InitializeNewInstance("android.content.res.ColorStateList",Array As Object(States,Color))
	Dim B1 As JavaObject = Btn
	B1.RunMethod("setTextColor",Array As Object(CSL))
End Sub
Private Sub ChangeColorVisible(clr As Int) As Int
	Dim argb() As Int = clrTheme.Int2ARGB(clr)
	Return xui.Color_ARGB(90,argb(1),argb(2),argb(3))
End Sub
'========================================================================


'--- just an easy wat to Toast!!!!
Public Sub Show_toast(msg As String)
	CallSubDelayed2(B4XPages.MainPage,"Show_Toast", msg)
End Sub
Public Sub Show_toast2(msg As String, ms As Int)
	CallSubDelayed3(B4XPages.MainPage,"Show_Toast2", msg, ms)
End Sub



'--- returns true if the size is too large
'--- called from setText
public Sub CheckSize(size As Float, MultipleLines As Boolean, mLbl As Label) As Boolean
	#if release
	Try
	#end if
	
	Dim cvs As Canvas ,  bmp As Bitmap
	bmp.InitializeMutable(1%x,1%y)
	cvs.Initialize2(bmp)
	mLbl.TextSize = size
	If MultipleLines Then
		Return su.MeasureMultilineTextHeight(mLbl, mLbl.Text) > mLbl.Height
	Else
		Return cvs.MeasureStringWidth(mLbl.Text, mLbl.Typeface, size) > mLbl.Width Or su.MeasureMultilineTextHeight(mLbl, mLbl.Text) > mLbl.Height
	End If
		
	#if release	
	Catch
		Log(LastException)
	End Try
	#end if
	Return True '--- just return true if error
		
End Sub

Public Sub ResizeText(value As String, mLbl As Label)
	Dim HighValue As Float  = 2
	Dim LowValue As Float = 1
	Dim CurrentValue As Float

	mLbl.Text = value
	Dim multipleLines As Boolean = mLbl.Text.Contains(CRLF)
	'need to set actual start values so find Gross Start/Stop values
	'first is linear Growth with some arbitrary 'large' value 'going with 30
	'this can be fine tuned based on size of the display that you are aiming for/have available vs size of your CustomViews

	Do While Not(CheckSize(HighValue, multipleLines,mLbl))
		LowValue = HighValue
		HighValue = HighValue + 30
	Loop

	CurrentValue = (HighValue + LowValue)/2
	'
	'initial sizes set, now for binary approach
	'
	'adjust this to taste.  I like it at 1, and I think it looks very nice... can go a little larger for even faster times
	'smaller for closer hit to actual optimum, but sacrificing a little speed
	'
	'Dim ToleranceValue As Float = .5
	Dim ToleranceValue As Float = 2

	Dim currentResult As Boolean
	Do While (CurrentValue - LowValue) > ToleranceValue Or (HighValue - CurrentValue) > ToleranceValue
		
		currentResult = CheckSize(CurrentValue, multipleLines,mLbl)
		
		If currentResult Then 'this means currentvalue is too large
			HighValue = CurrentValue
		Else 'currentValue is too small
			LowValue = CurrentValue
		End If
		CurrentValue = (HighValue + LowValue) / 2
	Loop
	
	Dim offset As Int = 0
	mLbl.TextSize = ((CurrentValue - ToleranceValue) + offset)
	'debugLog("size:"& mLbl.TextSize)
End Sub

'=========================================================================

Public Sub SizeFontAdjust() As Float
	Dim I As Int =  gWidth
	If I > 760 And I < 900 Then
		Return 1
	Else If I > 901 And I < 1099 Then
		Return 1.20
	Else If I > 1200 Then
		Return 1.45
	Else
		'LogWrite("Scrn Size Err 001:" & I,ID_LOG_ERR)
		Return 1
	End If
End Sub




Public Sub SetTextShadow(pView As B4XView, pRadius As Float, pDx As Float, pDy As Float, pColor As Int)
	Dim ref As Reflector
	ref.Target = pView
	ref.RunMethod4("setShadowLayer", Array As Object(pRadius, pDx, pDy, pColor), Array As String("java.lang.float", "java.lang.float", "java.lang.float", "java.lang.int"))
End Sub

Public Sub SetViewShadow (View As B4XView, Offset As Double, Color As Int)
    #if B4J
    Dim DropShadow As JavaObject
	'You might prefer to ignore panels as the shadow is different.
	'If View Is Pane Then Return
    DropShadow.InitializeNewInstance(IIf(View Is Pane, "javafx.scene.effect.InnerShadow", "javafx.scene.effect.DropShadow"), Null)
    DropShadow.RunMethod("setOffsetX", Array(Offset))
    DropShadow.RunMethod("setOffsetY", Array(Offset))
    DropShadow.RunMethod("setRadius", Array(Offset))
    Dim fx As JFX
    DropShadow.RunMethod("setColor", Array(fx.Colors.From32Bit(Color)))
    View.As(JavaObject).RunMethod("setEffect", Array(DropShadow))
    #Else If B4A
	Offset = Offset * 2
	View.As(JavaObject).RunMethod("setElevation", Array(Offset.As(Float)))
    #Else If B4i
    View.As(View).SetShadow(Color, Offset, Offset, 0.5, False)
    #End If
End Sub

'Change the size and color of a Checkbox graphic. Set the tick character and color, as well as the box size and color
'and padding (distance from the box to the edge of the graphic) and a disabled fill color
'Pass "Fill" as the TickChar to fill the box with TickColor when selected.
Public Sub SetCBDrawable(CB As CheckBox,BoxColor As Int,BoxWidth As Int, _
			TickColor As Int,TickChar As String,DisabledColor As Int,Size As Int,Padding As Int)
			
	Dim SLD As StateListDrawable
	SLD.Initialize

	Dim BMEnabled,BMChecked,BMDisabled As Bitmap
	BMEnabled.InitializeMutable(Size,Size)
	BMChecked.InitializeMutable(Size,Size)
	BMDisabled.InitializeMutable(Size,Size)
	'Draw Enabled State
	Dim CNV As Canvas
	CNV.Initialize2(BMEnabled)
	Dim Rect1 As Rect
	Rect1.Initialize(Padding ,Padding ,Size - Padding ,Size - Padding)
	CNV.DrawRect(Rect1,BoxColor,False,BoxWidth)
	Dim Enabled,Checked,Disabled As BitmapDrawable
	Enabled.Initialize(BMEnabled)
	'Draw Selected state
	Dim CNV1 As Canvas
	CNV1.Initialize2(BMChecked)
	If TickChar = "Fill" Then
		CNV1.DrawRect(Rect1,TickColor,True,BoxWidth)
		CNV1.DrawRect(Rect1,BoxColor,False,BoxWidth)
	Else
		CNV1.DrawRect(Rect1,BoxColor,False,BoxWidth)
		'Start small and find the largest font that allows the tick to fit in the box
		Dim FontSize As Int = 6
		Do While CNV.MeasureStringHeight(TickChar,Typeface.DEFAULT,FontSize) < Size - (BoxWidth * 2) - (Padding * 2)
			FontSize = FontSize + 1
		Loop
		FontSize = FontSize - 1
		'Draw the TickChar centered in the box
		CNV1.DrawText(TickChar,Size/2,(Size + CNV.MeasureStringHeight(TickChar,Typeface.DEFAULT,FontSize))/2,Typeface.DEFAULT,FontSize,TickColor,"CENTER")
	End If
	Checked.Initialize(BMChecked)
	'Draw disabled State
	Dim CNV2 As Canvas
	CNV2.Initialize2(BMDisabled)
	CNV2.DrawRect(Rect1,DisabledColor,True,BoxWidth)
	CNV2.DrawRect(Rect1,BoxColor,False,BoxWidth)
	Disabled.Initialize(BMDisabled)

	'Add to the StateList Drawable
	SLD.AddState(SLD.State_Disabled,Disabled)
	SLD.AddState(SLD.State_Checked,Checked)
	SLD.AddState(SLD.State_Enabled,Enabled)
	SLD.AddCatchAllState(Enabled)
	'Add SLD to the Checkbox
	Dim JO As JavaObject = CB
	JO.RunMethod("setButtonDrawable",Array As Object(SLD))
End Sub



Public Sub AnimateB4xView (FromEdge As String,base As B4XView)
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
	base.Visible = True
	base.SetLayoutAnimated(220, left, top, base.Width, base.Height)
End Sub



'Sets up the colors of the buttons
Public Sub SkinTextEdit2(et() As EditText ,brd_r As Int)    
    
	Dim cd As ColorDrawable
	Dim sd As StateListDrawable
	sd.Initialize
	
	For Each v As EditText In et
	
		cd.Initialize2(clrTheme.btnDisableText,brd_r,2dip,clrTheme.btnDisableText)
		sd.AddState(sd.State_Disabled, cd)

		cd.Initialize2(clrTheme.txtAccent,brd_r,2dip,clrTheme.txtAccent)
		sd.AddState(sd.State_Focused, cd)

		'--- must be the last one
		cd.Initialize2(clrTheme.txtNormal,brd_r,2dip,clrTheme.txtNormal)
		sd.AddCatchAllState(cd)
	
		v.Background = sd
	Next
	
End Sub
Public Sub SkinTextEdit(et() As EditText ,brd_r As Int,NoPopupKB As Boolean)    
    
	Dim cd As ColorDrawable
	Dim sd As StateListDrawable
	sd.Initialize
	
	For Each v As EditText In et
	
		cd.Initialize2(clrTheme.btnDisableText,brd_r,2dip,clrTheme.btnDisableText)
		sd.AddState(sd.State_Disabled, cd)

		cd.Initialize2(clrTheme.txtAccent,brd_r,2dip,clrTheme.txtAccent)
		sd.AddState(sd.State_Focused, cd)

		'--- must be the last one
		cd.Initialize2(clrTheme.txtNormal,brd_r,2dip,clrTheme.txtNormal)
		sd.AddCatchAllState(cd)
	
		v.Background = sd
		
		If NoPopupKB Then
			v.InputType = v.INPUT_TYPE_NONE
		End If
		
	Next
	
End Sub

