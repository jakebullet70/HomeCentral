B4J=true
Group=Helpers-StaticCodeMods
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
	
End Sub


'=====================================================================================
'  Generic GUI helper methods
'=====================================================================================
'
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

Public Sub SetPanelsTranparent(Arr() As B4XView)
	For Each o As B4XView In Arr
		o.SetColorAndBorder(xui.Color_Transparent,0dip,xui.Color_Transparent,0dip)
	Next
End Sub

Public Sub SetEnableDisableColor(btnArr() As B4XView)
	For Each btn As B4XView In btnArr
		If btn.enabled Then
			btn.TextColor = themes.clrTxtNormal
			btn.SetColorAndBorder(xui.Color_Transparent,2dip,themes.clrTxtNormal,8dip)
		Else
			btn.TextColor = themes.clrTxtDisabled
			btn.SetColorAndBorder(xui.Color_Transparent,2dip,themes.clrTxtDisabled,8dip)
		End If
	Next
End Sub
Public Sub SetEnableDisableColorBtnNoBoarder(btnArr() As B4XView)
	For Each btn As B4XView In btnArr
		If btn.enabled Then
			btn.TextColor = themes.clrTxtNormal
			btn.SetColorAndBorder(xui.Color_Transparent,0,themes.clrTxtNormal,0)
		Else
			btn.TextColor = themes.clrTxtDisabled
			btn.SetColorAndBorder(xui.Color_Transparent,0,themes.clrTxtDisabled,0)
		End If
	Next
End Sub
'=========================================================================================
'=========================================================================================

'--- just an easy wat to Toast!!!!
Public Sub Show_toast(msg As String)
	CallSubDelayed2(B4XPages.MainPage,"Show_Toast", msg)
End Sub
Public Sub Show_toast2(msg As String, ms As Int)
	CallSubDelayed3(B4XPages.MainPage,"Show_Toast2", msg, ms)
End Sub




Public Sub ToolTipOnNode(Nd As Node, msg As String, add As Boolean)
	Dim joToolTip As JavaObject
	Dim joToolTip2 As JavaObject = joToolTip.InitializeNewInstance("javafx.scene.control.Tooltip", Array(msg))
	If add = True Then
		joToolTip.RunMethod("install", Array(Nd, joToolTip2))
	Else
		joToolTip.RunMethod("uninstall", Array(Nd, joToolTip2))
	End If
End Sub




'-----------------------------------------------------------------------------
Public Sub ResizeText(value As Object, lbl As B4XView)
	
	#if b4j '--- b4j dose not resize
	XUIViewsUtils.SetTextOrCSBuilderToLabel(lbl,value)
	Return
	#else
	Dim multipleLines As Boolean = lbl.Text.Contains(CRLF)
	Dim size As Float
	For size = 5 To 72
		If CheckSize(size, multipleLines,lbl) Then Exit
	Next
	size = size - 0.5
	If CheckSize(size, multipleLines,lbl) Then size = size - 0.5
	'Sleep(0)
	lbl.TextSize = size
	'Return size
	#End If
	
End Sub

#if b4a
'returns true if the size is too large
Private Sub CheckSize(size As Float, multipleLines As Boolean, lbl As B4XView) As Boolean
	lbl.TextSize = size
	If multipleLines Then
		Dim su As StringUtils
		Return su.MeasureMultilineTextHeight(lbl,lbl.Text) > lbl.Height
	Else
		Dim stuti As StringUtils
		Return MeasureTextWidth(lbl.Text,lbl.Font) > lbl.Width Or stuti.MeasureMultilineTextHeight(lbl,lbl.Text) > lbl.Height
	End If
	
End Sub
Private Sub MeasureTextWidth(Text As String, Font1 As B4XFont) As Int
	'https://www.b4x.com/android/forum/threads/b4x-xui-add-measuretextwidth-and-measuretextheight-to-b4xcanvas.91865/#content
	Private bmp As Bitmap
	bmp.InitializeMutable(1, 1)'ignore
	Private cvs As Canvas
	cvs.Initialize2(bmp)
	Return cvs.MeasureStringWidth(Text, Font1.ToNativeFont, Font1.Size)
End Sub
'-----------------------------------------------------------------------------
#end if

Public Sub MeasureTextHeight(Text As String, Font1 As B4XFont) As Int 'ignore
#If B4A    
    Private bmp As Bitmap
    bmp.InitializeMutable(2dip, 2dip)
    Private cvs As Canvas
    cvs.Initialize2(bmp)
    Return cvs.MeasureStringHeight(Text, Font1.ToNativeFont, Font1.Size)
#Else If B4i
    Return Text.MeasureHeight(Font1.ToNativeFont)
#Else If B4J
	Dim jo As JavaObject
	jo.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
	jo.RunMethod("setFont",Array(Font1.ToNativeFont))
	jo.RunMethod("setLineSpacing",Array(0.0))
	jo.RunMethod("setWrappingWidth",Array(0.0))
	Dim Bounds As JavaObject = jo.RunMethod("getLayoutBounds",Null)
	Return Bounds.RunMethod("getHeight",Null)
#End If
End Sub


Public Sub SizeFontAdjust() As Float
	#if b4j
	Return 1
	#else
	Dim I As Int = GetDeviceLayoutValues.Width
	If I > 760 And I < 900 Then
		Return 1
	Else If I > 901 And I < 1099 Then
		Return 1.20
	Else If I > 1200 Then
		Return 1.45
	Else
		LogWrite("Scrn Size Err 001:" & I,ID_LOG_ERR)
		Return 1
	End If
	#End If
End Sub


Public Sub ResizeText2( Text As String,lbl As B4XView) 
	Dim font As Font = lbl.Font
	Dim width As Double = lbl.Width
	Dim v As Double = jMeasureMultilineTextHeight2(font, width , Text)
	'Dim l As Int = fnct.CountChar(Text,CRLF)
	lbl.TextSize = v.As(Int)
	lbl.Text = Text
	'Log(v)
End Sub



Private Sub jMeasureMultilineTextHeight2(Font As Font, Width As Double, Text As String) As Double
	' Erel --> https://www.b4x.com/android/forum/threads/measure-multiline-text-height.84331/
	Dim jo As JavaObject = Me
	Return jo.RunMethod("MeasureMultilineTextHeight", Array(Font, Text, Width))
End Sub
#if Java
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import javafx.scene.text.Font;
import javafx.scene.text.TextBoundsType;
public static double MeasureMultilineTextHeight(Font f, String text, double width) throws Exception {
  Method m = Class.forName("com.sun.javafx.scene.control.skin.Utils").getDeclaredMethod("computeTextHeight",
  Font.class, String.class, double.class, TextBoundsType.class);
  m.setAccessible(true);
  return (Double)m.invoke(null, f, text, width, TextBoundsType.LOGICAL);
  }
#end if


