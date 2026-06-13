B4J=true
Group=MiscClasses
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/Jakebullet
#Region VERSIONS 
' V. 1.0 	June/2026
#End Region


Sub Class_Globals
End Sub

Public Sub Initialize()
End Sub


Public Sub GetRealSize() As LayoutValues
	
	'Log("GetRealSize()")
	Dim lv As LayoutValues
	Dim ctxt As JavaObject
	ctxt.InitializeContext
	Dim WindowManager As JavaObject = ctxt.RunMethodJO("getSystemService", Array("window"))
	Dim display As JavaObject = WindowManager.RunMethod("getDefaultDisplay", Null)
	Dim point As JavaObject
	point.InitializeNewInstance("android.graphics.Point", Null)
	display.RunMethod("getRealSize", Array(point))
	lv.Width = point.GetField("x")
	lv.Height = point.GetField("y")
	lv.Scale = 100dip / 100
	Return lv
	
End Sub

Public Sub ExactSize As Double 'ignore
	'--- size of the screen
	'https://www.b4x.com/android/forum/threads/calculate-physical-screen-size.47826/#post-296811
	Dim r As Reflector
	r.Target = r.GetContext
	r.Target = r.RunMethod("getResources")
	r.Target = r.RunMethod("getDisplayMetrics")
	Dim xdpi As Double = r.GetField("xdpi")
	Dim ydpi As Double = r.GetField("ydpi")
	Return Sqrt(Power(100%x / xdpi, 2) + Power(100%y / ydpi, 2))
End Sub

